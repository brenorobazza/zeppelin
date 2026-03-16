from collections import defaultdict
from statistics import mean

from apps.organization.models import Organization
from django.core.exceptions import ValidationError
from django.utils.text import slugify

from .models import AdoptedLevel, Answer, Questionnaire


# Este serviço concentra a camada analítica criada para o TCC.
# Ele recebe respostas já persistidas e monta estruturas prontas
# para as telas principais: dashboard, results, recommendations e history.
class QuestionnaireAnalyticsService:
    # Estágios usados como recorte principal da análise do frontend atual.
    CI_CD_STAGE_NAMES = ("Integração Contínua", "Entrega Contínua")

    # Converte nomes completos do banco em siglas amigáveis para a interface.
    STAGE_SHORT_NAMES = {
        "Desenvolvimento Ágil": "Agile",
        "Integração Contínua": "CI",
        "Entrega Contínua": "CD",
        "P&D como Sistema de Inovação": "Experimentation",
    }

    # Mantém uma ordem previsível de exibição dos estágios.
    STAGE_ORDER = {
        "Desenvolvimento Ágil": 1,
        "Integração Contínua": 2,
        "Entrega Contínua": 3,
        "P&D como Sistema de Inovação": 4,
    }

    # Agrupa as recomendações em trilhas simples de roadmap.
    RECOMMENDATION_TRACKS = (
        {
            "key": "Adopt now",
            "title": "Adopt first",
            "description": (
                "Practices still absent or abandoned in the selected cycle."
            ),
        },
        {
            "key": "Consolidate",
            "title": "Consolidate to process level",
            "description": (
                "Practices that exist locally and should be expanded "
                "to process level."
            ),
        },
    )

    # Carrega os níveis de adoção uma única vez para reutilização ao longo dos cálculos.
    def __init__(self):
        self.adopted_levels = list(AdoptedLevel.objects.order_by("percentage"))

    # Monta a resposta resumida do dashboard, focada em resultado geral do ciclo atual.
    def get_dashboard_payload(self, request):
        context = self._resolve_context(request)
        answers = context["current_answers"]
        stage_scores = self._build_stage_scores(answers)
        recommendations = self._build_recommendations(answers)
        history_cycles = self._build_history_cycles(context["all_answers"])

        return {
            "organization": self._serialize_organization(context["organization"]),
            "cycle": self._serialize_cycle(
                context["questionnaire"],
                answers,
            ),
            "scope": context["stage_scope"],
            "snapshot": {
                "overall_score": self._score_for_answers(answers),
                "overall_level": self._resolve_average_level(
                    self._score_for_answers(answers)
                ),
                "answered_practices": len(answers),
                "recommendation_count": len(recommendations),
                "executive_summary": self._build_executive_summary(stage_scores),
                "overall_delta": self._history_delta(
                    history_cycles,
                    "overall_score",
                ),
            },
            "stage_scores": stage_scores,
            "adoption_levels": self._build_adoption_distribution(answers),
            "strengths": self._build_strengths(answers),
            "bottlenecks": self._build_bottlenecks(answers),
            "recommendations_preview": recommendations[:3],
        }

    # Monta a resposta detalhada da tela de resultados, com foco em forças e gargalos.
    def get_results_payload(self, request):
        context = self._resolve_context(request)
        answers = context["current_answers"]
        stage_scores = self._build_stage_scores(answers)
        recommendations = self._build_recommendations(answers)
        overall_score = self._score_for_answers(answers)

        stage_values = [item["score"] for item in stage_scores]
        stage_gap = (
            max(stage_values) - min(stage_values) if len(stage_values) > 1 else 0
        )

        return {
            "organization": self._serialize_organization(context["organization"]),
            "cycle": self._serialize_cycle(
                context["questionnaire"],
                answers,
            ),
            "scope": context["stage_scope"],
            "summary": {
                "overall_score": overall_score,
                "overall_level": self._resolve_average_level(overall_score),
                "answered_practices": len(answers),
                "stage_gap": stage_gap,
            },
            "stage_scores": stage_scores,
            "dimensions": self._build_dimension_results(answers),
            "strengths": self._build_strengths(answers),
            "bottlenecks": self._build_bottlenecks(answers),
            "opportunities": recommendations[:5],
        }

    # Gera o roadmap acionável a partir das práticas com menor maturidade.
    def get_recommendations_payload(self, request):
        context = self._resolve_context(request)
        answers = context["current_answers"]
        recommendations = self._build_recommendations(answers)

        grouped_tracks = []
        for lane in self.RECOMMENDATION_TRACKS:
            items = [item for item in recommendations if item["track"] == lane["key"]]
            grouped_tracks.append({**lane, "count": len(items), "items": items})

        return {
            "organization": self._serialize_organization(context["organization"]),
            "cycle": self._serialize_cycle(
                context["questionnaire"],
                answers,
            ),
            "scope": context["stage_scope"],
            "summary": {
                "triggered_recommendations": len(recommendations),
                "adopt_now_count": len(
                    [item for item in recommendations if item["track"] == "Adopt now"]
                ),
                "consolidate_count": len(
                    [item for item in recommendations if item["track"] == "Consolidate"]
                ),
            },
            "filters": {
                "available_stages": sorted(
                    {
                        item["stage_short_name"]
                        for item in recommendations
                        if item["stage_short_name"]
                    }
                ),
                "available_tracks": [
                    item["key"] for item in self.RECOMMENDATION_TRACKS
                ],
                "available_priorities": ["High", "Medium", "Low"],
            },
            "tracks": grouped_tracks,
            "items": recommendations,
        }

    # Resume a evolução entre ciclos para responder o que mudou ao longo do tempo.
    def get_history_payload(self, request):
        context = self._resolve_context(request)
        cycles = self._build_history_cycles(context["all_answers"])

        if len(cycles) >= 2:
            baseline = cycles[0]
            current = cycles[-1]
            overall_delta = current["overall_score"] - baseline["overall_score"]
            recommendation_reduction = (
                baseline["recommendation_count"] - current["recommendation_count"]
            )
        else:
            overall_delta = 0
            recommendation_reduction = 0

        return {
            "organization": self._serialize_organization(context["organization"]),
            "scope": context["stage_scope"],
            "summary": {
                "cycle_count": len(cycles),
                "overall_delta": overall_delta,
                "recommendation_reduction": recommendation_reduction,
            },
            "cycles": cycles,
        }

    # Resolve todo o contexto necessário: organização, escopo, ciclo escolhido e respostas filtradas.
    def _resolve_context(self, request):
        organization = self._resolve_organization(request)
        stage_scope = request.query_params.get("stage_scope", "ci_cd")
        all_answers = list(self._base_answers_queryset(organization.id, stage_scope))
        questionnaire = self._resolve_questionnaire(
            request,
            organization.id,
            all_answers,
        )
        current_answers = self._answers_for_questionnaire(
            all_answers,
            questionnaire,
        )

        if not current_answers:
            current_answers = all_answers

        return {
            "organization": organization,
            "questionnaire": questionnaire,
            "stage_scope": stage_scope,
            "all_answers": all_answers,
            "current_answers": current_answers,
        }

    # Descobre a organização a partir da URL ou do usuário autenticado.
    def _resolve_organization(self, request):
        organization_id = request.query_params.get("organization_id")

        # O usuário deve estar obrigatoriamente autenticado.
        if not request.user or not request.user.is_authenticated:
            raise ValidationError(
                "organization_id is required when the user is not authenticated"
            )

        # Identifica todas as organizações às quais o usuário tem acesso (via Employee).
        user_organizations = Organization.objects.filter(
            employee_organization_employee__e_mail__iexact=request.user.email
        ).distinct()

        if organization_id:
            # Trava de Segurança: Verifica se o usuário tem permissão para a empresa solicitada.
            org = user_organizations.filter(id=organization_id).first()
            if not org:
                raise ValidationError(
                    f"Access denied or organization {organization_id} not found."
                )
            return org

        # Fallback: Se nenhuma empresa foi pedida na URL, assume a primeira vinculada ao usuário.
        org = user_organizations.first()
        if not org:
            raise ValidationError(
                "could not resolve any organization for the authenticated user"
            )

        return org

    # Consulta base com relacionamentos carregados para evitar excesso de queries.
    def _base_answers_queryset(self, organization_id, stage_scope):
        queryset = (
            Answer.objects.filter(organization_answer_id=organization_id)
            .select_related(
                "organization_answer",
                "questionnaire_answer",
                "adopted_level_answer",
                "statement_answer__sth_stage",
                "statement_answer__pe_element__dimension",
            )
            .order_by(
                "questionnaire_answer_id",
                "statement_answer__code",
                "id",
            )
        )

        if stage_scope == "ci_cd":
            queryset = queryset.filter(
                statement_answer__sth_stage__name__in=self.CI_CD_STAGE_NAMES
            )

        return queryset

    # Resolve qual ciclo/questionário deve ser usado na análise atual.
    def _resolve_questionnaire(self, request, organization_id, answers):
        questionnaire_id = request.query_params.get("questionnaire_id")
        if questionnaire_id:
            questionnaire = (
                Questionnaire.objects.filter(
                    id=questionnaire_id,
                    answer__organization_answer_id=organization_id,
                )
                .distinct()
                .first()
            )
            if questionnaire is None:
                raise ValidationError("questionnaire_id not found")
            return questionnaire

        questionnaire_ids = {
            answer.questionnaire_answer_id
            for answer in answers
            if answer.questionnaire_answer_id is not None
        }
        if not questionnaire_ids:
            return None

        return (
            Questionnaire.objects.filter(id__in=questionnaire_ids)
            .order_by("-applied_date", "-uploaded_at", "-id")
            .first()
        )

    # Filtra apenas as respostas do ciclo selecionado.
    def _answers_for_questionnaire(self, answers, questionnaire):
        if questionnaire is None:
            return list(answers)

        filtered = [
            answer
            for answer in answers
            if answer.questionnaire_answer_id == questionnaire.id
        ]
        return filtered

    # Converte a organização para um formato simples e estável para o frontend.
    def _serialize_organization(self, organization):
        return {
            "id": organization.id,
            "name": organization.name,
            "type": getattr(organization.organization_type, "name", None),
            "size": getattr(organization.organization_size, "name", None),
            "age_months": organization.age,
        }

    # Converte o ciclo para um resumo legível usado no topo das telas.
    def _serialize_cycle(self, questionnaire, answers):
        if questionnaire is None:
            return {
                "id": None,
                "label": "Aggregated organization snapshot",
                "applied_date": None,
                "answered_practices": len(answers),
            }

        applied_date = questionnaire.applied_date or questionnaire.uploaded_at
        return {
            "id": questionnaire.id,
            "label": (
                f"Questionnaire {questionnaire.id}"
                if applied_date is None
                else applied_date.strftime("%B %Y")
            ),
            "applied_date": applied_date,
            "answered_practices": len(answers),
        }

    # Calcula a pontuação média do conjunto de respostas.
    def _score_for_answers(self, answers):
        percentages = [
            answer.adopted_level_answer.percentage
            for answer in answers
            if answer.adopted_level_answer is not None
        ]
        if not percentages:
            return 0
        return round(mean(percentages))

    # Traduz um score numérico para o nível de adoção mais próximo.
    def _resolve_average_level(self, score):
        if not self.adopted_levels:
            return None

        closest = min(
            self.adopted_levels,
            key=lambda level: abs(level.percentage - score),
        )
        return closest.name

    # Agrupa as respostas por estágio e calcula os indicadores de cada grupo.
    def _build_stage_scores(self, answers):
        grouped = defaultdict(list)
        for answer in answers:
            stage = getattr(answer.statement_answer, "sth_stage", None)
            stage_name = getattr(stage, "name", None) or "Unknown stage"
            grouped[stage_name].append(answer)

        items = []
        for stage_name, stage_answers in grouped.items():
            score = self._score_for_answers(stage_answers)
            items.append(
                {
                    "key": slugify(stage_name),
                    "name": stage_name,
                    "short_name": self.STAGE_SHORT_NAMES.get(
                        stage_name,
                        stage_name,
                    ),
                    "score": score,
                    "current_level": self._resolve_average_level(score),
                    "answered_practices": len(stage_answers),
                    "strength_count": len(
                        [
                            answer
                            for answer in stage_answers
                            if answer.adopted_level_answer.percentage >= 60
                        ]
                    ),
                    "bottleneck_count": len(
                        [
                            answer
                            for answer in stage_answers
                            if answer.adopted_level_answer.percentage < 60
                        ]
                    ),
                }
            )

        return sorted(
            items,
            key=lambda item: self.STAGE_ORDER.get(item["name"], 999),
        )

    # Conta quantas práticas caem em cada nível de adoção.
    def _build_adoption_distribution(self, answers):
        total = len(answers) or 1
        grouped = defaultdict(list)
        for answer in answers:
            level = answer.adopted_level_answer
            grouped[level.id].append(answer)

        items = []
        for level in self.adopted_levels:
            count = len(grouped.get(level.id, []))
            items.append(
                {
                    "id": level.id,
                    "key": slugify(level.name),
                    "label": level.name,
                    "count": count,
                    "percentage": round((count / total) * 100),
                    "score": level.percentage,
                }
            )

        return items

    # Seleciona as práticas mais maduras para a seção de pontos fortes.
    def _build_strengths(self, answers, limit=3):
        candidates = [
            answer for answer in answers if answer.adopted_level_answer.percentage >= 60
        ]
        candidates.sort(
            key=lambda answer: (
                -answer.adopted_level_answer.percentage,
                answer.statement_answer.code or "",
            )
        )
        return [self._serialize_insight(answer) for answer in candidates[:limit]]

    # Seleciona as práticas mais críticas para a seção de gargalos.
    def _build_bottlenecks(self, answers, limit=3):
        candidates = [
            answer for answer in answers if answer.adopted_level_answer.percentage < 60
        ]
        candidates.sort(
            key=lambda answer: (
                answer.adopted_level_answer.percentage,
                answer.statement_answer.code or "",
            )
        )
        return [self._serialize_insight(answer) for answer in candidates[:limit]]

    # Agrupa resultados por tema/dimensão para facilitar a leitura do diagnóstico.
    def _build_dimension_results(self, answers):
        grouped = defaultdict(list)
        for answer in answers:
            dimension = getattr(
                getattr(answer.statement_answer, "pe_element", None),
                "dimension",
                None,
            )
            dimension_name = getattr(dimension, "name", None) or "Unclassified"
            grouped[dimension_name].append(answer)

        items = []
        for dimension_name, dimension_answers in grouped.items():
            score = self._score_for_answers(dimension_answers)
            strongest = max(
                dimension_answers,
                key=lambda answer: answer.adopted_level_answer.percentage,
            )
            weakest = min(
                dimension_answers,
                key=lambda answer: answer.adopted_level_answer.percentage,
            )
            focus_codes = [
                answer.statement_answer.code
                for answer in dimension_answers[:3]
                if answer.statement_answer.code
            ]

            items.append(
                {
                    "key": slugify(dimension_name),
                    "name": dimension_name,
                    "focus": ", ".join(focus_codes)
                    if focus_codes
                    else "Practice cluster",
                    "score": score,
                    "current_level": self._resolve_average_level(score),
                    "answered_practices": len(dimension_answers),
                    "strength": self._compact_statement(
                        strongest.statement_answer.text
                    ),
                    "bottleneck": self._compact_statement(
                        weakest.statement_answer.text
                    ),
                    "strength_item": self._serialize_insight(strongest),
                    "bottleneck_item": self._serialize_insight(weakest),
                }
            )

        return sorted(
            items,
            key=lambda item: (-item["score"], item["name"]),
        )

    # Gera recomendações para práticas abaixo do limiar de 60 por cento.
    def _build_recommendations(self, answers):
        items = []
        candidates = [
            answer for answer in answers if answer.adopted_level_answer.percentage < 60
        ]
        candidates.sort(
            key=lambda answer: (
                answer.adopted_level_answer.percentage,
                self.STAGE_ORDER.get(
                    getattr(answer.statement_answer.sth_stage, "name", ""), 999
                ),
                answer.statement_answer.code or "",
            )
        )

        for answer in candidates:
            level = answer.adopted_level_answer
            stage_name = getattr(
                answer.statement_answer.sth_stage,
                "name",
                None,
            )
            track = "Adopt now" if level.percentage <= 10 else "Consolidate"
            priority = "High" if level.percentage <= 10 else "Medium"

            if level.percentage == 0:
                current_level = "Not adopted"
            elif level.percentage <= 10:
                current_level = "Abandoned"
            elif level.percentage <= 30:
                current_level = "Project/Product level"
            else:
                current_level = level.name

            items.append(
                {
                    "id": answer.id,
                    "question_id": answer.statement_answer.code,
                    "stage_name": stage_name,
                    "stage_short_name": self.STAGE_SHORT_NAMES.get(
                        stage_name,
                        stage_name,
                    ),
                    "dimension_name": getattr(
                        getattr(
                            answer.statement_answer.pe_element,
                            "dimension",
                            None,
                        ),
                        "name",
                        None,
                    ),
                    "track": track,
                    "priority": priority,
                    "current_level": current_level,
                    "title": self._recommendation_title(answer),
                    "recommendation": self._recommendation_copy(
                        answer,
                        track,
                    ),
                    "expected_impact": self._expected_impact(
                        answer,
                        track,
                    ),
                    "next_step": self._next_step(
                        answer,
                        track,
                    ),
                    "status": "Suggested",
                }
            )

        return items

    # Reconstrói a linha do tempo dos ciclos da organização.
    def _build_history_cycles(self, answers):
        grouped = defaultdict(list)
        questionnaires = {}

        for answer in answers:
            key = (
                answer.questionnaire_answer_id
                or f"aggregate-{answer.organization_answer_id}"
            )
            grouped[key].append(answer)
            if answer.questionnaire_answer_id is not None:
                questionnaires[
                    answer.questionnaire_answer_id
                ] = answer.questionnaire_answer

        def sort_key(item):
            key, cycle_answers = item
            questionnaire = questionnaires.get(key)
            if questionnaire is None:
                return ("9999-12-31", 999999)

            applied_date = questionnaire.applied_date or questionnaire.uploaded_at
            return (
                (
                    applied_date.isoformat()
                    if applied_date is not None
                    else "9999-12-30"
                ),
                questionnaire.id,
            )

        cycles = []
        for key, cycle_answers in sorted(grouped.items(), key=sort_key):
            questionnaire = questionnaires.get(key)
            overall_score = self._score_for_answers(cycle_answers)
            stage_scores = self._build_stage_scores(cycle_answers)
            adoption_counts = {
                item["key"]: item["count"]
                for item in self._build_adoption_distribution(cycle_answers)
            }

            cycles.append(
                {
                    "id": getattr(questionnaire, "id", None),
                    "label": (
                        f"Questionnaire {questionnaire.id}"
                        if questionnaire and questionnaire.applied_date is None
                        else (
                            questionnaire.applied_date or questionnaire.uploaded_at
                        ).strftime("%B %Y")
                        if questionnaire
                        else "Aggregated snapshot"
                    ),
                    "applied_date": (
                        questionnaire.applied_date or questionnaire.uploaded_at
                        if questionnaire
                        else None
                    ),
                    "overall_score": overall_score,
                    "overall_level": self._resolve_average_level(overall_score),
                    "answered_practices": len(cycle_answers),
                    "recommendation_count": len(
                        [
                            answer
                            for answer in cycle_answers
                            if answer.adopted_level_answer.percentage < 60
                        ]
                    ),
                    "stage_scores": stage_scores,
                    "adoption_levels": adoption_counts,
                }
            )

        return cycles

    # Calcula a diferença entre o último e o penúltimo ciclo para um campo específico.
    def _history_delta(self, cycles, field_name):
        if len(cycles) < 2:
            return 0
        return cycles[-1][field_name] - cycles[-2][field_name]

    # Padroniza o formato de forças e gargalos para o frontend.
    def _serialize_insight(self, answer):
        stage_name = getattr(answer.statement_answer.sth_stage, "name", None)
        return {
            "id": answer.id,
            "question_id": answer.statement_answer.code,
            "stage_name": stage_name,
            "stage_short_name": self.STAGE_SHORT_NAMES.get(
                stage_name,
                stage_name,
            ),
            "current_level": answer.adopted_level_answer.name,
            "score": answer.adopted_level_answer.percentage,
            "title": self._compact_statement(answer.statement_answer.text),
            "evidence": self._insight_evidence(answer),
        }

    # Define qual texto de evidência será mostrado para cada insight.
    def _insight_evidence(self, answer):
        if answer.comment_answer:
            return answer.comment_answer.strip()

        dimension_name = getattr(
            getattr(
                answer.statement_answer.pe_element,
                "dimension",
                None,
            ),
            "name",
            None,
        )
        if dimension_name:
            return f"{answer.adopted_level_answer.name} in {dimension_name}."
        return answer.adopted_level_answer.name

    # Encurta textos longos para caber melhor nos cards e listas.
    def _compact_statement(self, text, limit=110):
        compact = " ".join((text or "").split())
        if len(compact) <= limit:
            return compact
        return f"{compact[: limit - 3].rstrip()}..."

    # Gera a frase-resumo exibida no topo do dashboard.
    def _build_executive_summary(self, stage_scores):
        if not stage_scores:
            return "No answered practices were found for the selected organization."

        strongest = max(stage_scores, key=lambda item: item["score"])
        weakest = min(stage_scores, key=lambda item: item["score"])
        return (
            f"{strongest['short_name']} currently leads the diagnosis with score "
            f"{strongest['score']}, while "
            f"{weakest['short_name']} needs the most attention "
            f"with score {weakest['score']}."
        )

    # Cria um título curto para cada recomendação do roadmap.
    def _recommendation_title(self, answer):
        code = answer.statement_answer.code or "Practice"
        return f"{code} - strengthen this practice"

    # Gera a explicação principal da recomendação em linguagem natural.
    def _recommendation_copy(self, answer, track):
        statement = self._compact_statement(
            answer.statement_answer.text,
            limit=160,
        )
        if track == "Adopt now":
            return (
                f"Establish the practice described in '{statement}' as a "
                "repeatable team routine, "
                "with explicit ownership, execution criteria and evidence collection."
            )

        return (
            f"Expand the practice described in '{statement}' from local usage "
            "to a shared process, "
            "with documented expectations and wider team adoption."
        )

    # Resume o impacto esperado caso a recomendação seja executada.
    def _expected_impact(self, answer, track):
        stage_name = getattr(answer.statement_answer.sth_stage, "name", None)
        short_name = self.STAGE_SHORT_NAMES.get(stage_name, stage_name)
        if track == "Adopt now":
            return (
                f"Reduce low-maturity gaps in {short_name} and create a "
                "stable baseline for future cycles."
            )
        return (
            f"Move {short_name} practices from isolated adoption to a "
            "consistent process-level capability."
        )

    # Sugere a primeira ação concreta para colocar a recomendação em prática.
    def _next_step(self, answer, track):
        code = answer.statement_answer.code or "the selected practice"
        if track == "Adopt now":
            return (
                f"Map the current blockers around {code}, assign an owner "
                "and define a 30-day pilot."
            )
        return (
            f"Review how {code} is performed today and define what must "
            "change to standardize it across teams."
        )
