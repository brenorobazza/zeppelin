import csv
from collections import defaultdict
from functools import lru_cache
from pathlib import Path
from statistics import mean

from apps.organization.models import Organization
from django.core.exceptions import ValidationError
from django.utils.text import slugify

from .models import AdoptedLevel, Answer, Questionnaire, Statement


@lru_cache(maxsize=1)
def load_recommendations_catalog():
    catalog_path = (
        Path(__file__).resolve().parent / "data" / "recommendations_catalog.csv"
    )
    if not catalog_path.exists():
        return {}

    with catalog_path.open(encoding="utf-8-sig", newline="") as catalog_file:
        reader = csv.DictReader(catalog_file)
        return {
            (row.get("Question number") or "").strip(): {
                "question_description": (row.get("Question Description") or "").strip(),
                "catalog_recommendation": (row.get("Recommendation") or "").strip(),
            }
            for row in reader
            if (row.get("Question number") or "").strip()
        }


class QuestionnaireAnalyticsService:
    # Estágios usados como recorte principal da análise do frontend atual.
    CI_CD_STAGE_NAMES = (
        "Continuous Integration",
        "Continuous Deployment",
        "Integracao Continua",
        "Entrega Continua",
    )

    # Converte nomes completos do banco em siglas amigaveis para a interface.
    STAGE_SHORT_NAMES = {
        "Traditional Development": "Traditional",
        "Agile R&D Organization": "Agile",
        "Continuous Integration": "CI",
        "Continuous Deployment": "CD",
        "R&D as an Experiment System": "Experimentation",
        "Desenvolvimento Agil": "Agile",
        "Integracao Continua": "CI",
        "Entrega Continua": "CD",
        "Experimentacao Continua": "Experimentation",
    }

    # Mantem uma ordem previsivel de exibicao dos estagios.
    STAGE_ORDER = {
        "Traditional Development": 0,
        "Agile R&D Organization": 1,
        "Continuous Integration": 2,
        "Continuous Deployment": 3,
        "R&D as an Experiment System": 4,
        "Desenvolvimento Agil": 1,
        "Integracao Continua": 2,
        "Entrega Continua": 3,
        "Experimentacao Continua": 4,
    }

    DIMENSION_LABELS = {
        "Traditional Development": "Traditional Development",
        "Agile R&D Organization": "Agile Development",
        "Continuous Integration": "Continuous Integration",
        "Continuous Deployment": "Continuous Deployment",
        "R&D as an Experiment System": "Continuous Experimentation",
        "Desenvolvimento Agil": "Agile Development",
        "Integracao Continua": "Continuous Integration",
        "Entrega Continua": "Continuous Deployment",
        "Experimentacao Continua": "Continuous Experimentation",
    }
    DIMENSION_ORDER = {
        "Development": 0,
        "Quality": 1,
        "Software Management": 2,
        "Technical Solution": 3,
        "Knowledge": 4,
        "Business": 5,
        "User/Customer": 6,
        "Agile Development": 7,
        "Continuous Integration": 8,
        "Continuous Deployment": 9,
        "Continuous Experimentation": 10,
        "Traditional Development": 11,
        "Unclassified": 999,
    }
    INSTRUMENT_WEIGHT_BY_PERCENTAGE = {
        0: 0,
        10: 22,
        30: 38,
        60: 68,
        100: 100,
    }
    INSTRUMENT_PRACTICE_CATALOG = {
        "CI.01": {
            "dimension": "Development",
            "element": "Modularized architecture and design",
        },
        "CI.02": {
            "dimension": "Development",
            "element": "Modularized architecture and design",
        },
        "CI.03": {
            "dimension": "Software Management",
            "element": "Continuos integration of work",
        },
        "CI.04": {"dimension": "Quality", "element": "Automated Tests"},
        "CI.05": {"dimension": "Quality", "element": "Automated Tests"},
        "CI.06": {"dimension": "Quality", "element": "Regular Builds"},
        "CI.07": {"dimension": "Quality", "element": "Regular Builds"},
        "CI.08": {"dimension": "Technical Solution", "element": "Version control"},
        "CI.09": {"dimension": "Technical Solution", "element": "Branching strategies"},
        "CI.10": {"dimension": "Quality", "element": "Pull-Request"},
        "CI.11": {"dimension": "Quality", "element": "Code coverage"},
        "CI.12": {"dimension": "Quality", "element": "Audits"},
        "CI.13": {"dimension": "Software Management", "element": "Agile Practice"},
        "CI.14": {
            "dimension": "Development",
            "element": "Continuous planning activities",
        },
        "CI.15": {"dimension": "Knowledge", "element": "Sharing Knowledge"},
        "CD.01": {
            "dimension": "User/Customer",
            "element": "Involved users other stakeholders",
        },
        "CD.02": {"dimension": "Quality", "element": "Audits"},
        "CD.03": {
            "dimension": "Software Management",
            "element": "Continuos deployment of releases",
        },
        "CD.04": {"dimension": "Business", "element": "Management commitement"},
        "CD.05": {
            "dimension": "Development",
            "element": "Modularized architecture and design",
        },
        "CD.06": {"dimension": "User/Customer", "element": "Proactive customers"},
        "CD.07": {
            "dimension": "User/Customer",
            "element": "Learning from usage data and feedback",
        },
        "CD.08": {"dimension": "Business", "element": "Appropriate product ideia"},
        "CD.09": {"dimension": "Business", "element": "Management commitement"},
        "CD.10": {"dimension": "Business", "element": "Management commitement"},
        "CD.11": {
            "dimension": "User/Customer",
            "element": "Involved users other stakeholders",
        },
        "CD.12": {"dimension": "Software Management", "element": "Continuos delivery"},
        "CD.13": {
            "dimension": "Software Management",
            "element": "Continuos deployment of releases",
        },
        "CD.14": {
            "dimension": "Knowledge",
            "element": "Capturing decisions and rationale",
        },
        "CD.15": {"dimension": "Software Management", "element": "Agile Practice"},
        "CD.16": {"dimension": "Knowledge", "element": "Continuos learning"},
        "CD.17": {"dimension": "Knowledge", "element": "Sharing Knowledge"},
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
    COMPARISON_LENS_CONFIG = {
        "eye": {
            "title": "Eye of CSE benchmark",
            "subtitle": "Seven-dimensional view of maturity balance across the organization.",
            "axes": [
                {"key": "Development", "label": "Development"},
                {"key": "Quality", "label": "Quality"},
                {"key": "Software Management", "label": "Software Mgt"},
                {"key": "Technical Solution", "label": "Technical Solution"},
                {"key": "Knowledge", "label": "Knowledge"},
                {"key": "Business", "label": "Business"},
                {"key": "User/Customer", "label": "User/Customer"},
            ],
            "item_key": "name",
            "item_value": "score",
        },
        "sth": {
            "title": "StH benchmark",
            "subtitle": "Stairway to Heaven stages compared against the selected cohort reference.",
            "axes": [
                {"key": "Agile", "label": "ARO"},
                {"key": "CI", "label": "CI"},
                {"key": "CD", "label": "CD"},
                {"key": "Experimentation", "label": "EXP"},
            ],
            "item_key": "short_name",
            "item_value": "score",
        },
    }

    # Carrega os níveis de adoção uma única vez para reutilização ao longo dos cálculos.
    def __init__(self):
        self.adopted_levels = list(AdoptedLevel.objects.order_by("percentage"))
        self.recommendations_catalog = load_recommendations_catalog()

    def _get_recommendations_catalog(self):
        catalog = getattr(self, "recommendations_catalog", None)
        if catalog is None:
            catalog = load_recommendations_catalog()
            self.recommendations_catalog = catalog
        return catalog

    # Monta a resposta resumida do dashboard, focada em resultado geral do ciclo atual.
    def get_dashboard_payload(self, request):
        context = self._resolve_context(request)
        answers = context["current_answers"]
        selected_answers = context.get("selected_answers", answers)
        selected_cycle_empty = context.get("selected_cycle_empty", False)
        expected_statement_count = context.get("expected_statement_count", len(answers))
        expected_stage_counts = context.get("expected_stage_counts")
        stage_scores = self._build_stage_scores(
            answers,
            expected_stage_counts=expected_stage_counts,
        )
        recommendations = self._build_recommendations(answers)
        history_cycles = self._build_history_cycles(
            context["all_answers"], context["organization"]
        )
        overall_score = self._score_for_answers(
            answers,
            expected_total=expected_statement_count,
        )
        questionnaire_status = self._questionnaire_status(
            len(answers), expected_statement_count
        )

        return {
            "organization": self._serialize_organization(context["organization"]),
            "cycle": self._serialize_cycle(
                context["questionnaire"],
                selected_answers if context["questionnaire"] is not None else answers,
            ),
            "scope": context["stage_scope"],
            "selected_cycle_empty": selected_cycle_empty,
            "snapshot": {
                "overall_score": overall_score,
                "overall_level": self._resolve_average_level(overall_score),
                "answered_practices": len(answers),
                "questionnaire_status": questionnaire_status,
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
        selected_answers = context.get("selected_answers", answers)
        selected_cycle_empty = context.get("selected_cycle_empty", False)
        expected_statement_count = context.get("expected_statement_count", len(answers))
        stage_scores = self._build_stage_scores(answers)
        recommendations = self._build_recommendations(answers)
        overall_score = self._score_for_answers(answers)
        questionnaire_status = self._questionnaire_status(
            len(answers), expected_statement_count
        )

        stage_values = [item["score"] for item in stage_scores]
        stage_gap = (
            max(stage_values) - min(stage_values) if len(stage_values) > 1 else 0
        )

        return {
            "organization": self._serialize_organization(context["organization"]),
            "cycle": self._serialize_cycle(
                context["questionnaire"],
                selected_answers if context["questionnaire"] is not None else answers,
            ),
            "scope": context["stage_scope"],
            "selected_cycle_empty": selected_cycle_empty,
            "summary": {
                "overall_score": overall_score,
                "overall_level": self._resolve_average_level(overall_score),
                "answered_practices": len(answers),
                "questionnaire_status": questionnaire_status,
                "stage_gap": stage_gap,
            },
            "stage_scores": stage_scores,
            "adoption_level_stage_overview": self._build_adoption_level_stage_overview(
                answers
            ),
            "dimensions": self._build_dimension_results(answers),
            "dimension_overview": self._build_dimension_stage_overview(answers),
            "element_overview": self._build_dimension_element_overview(answers),
            "strengths": self._build_strengths(answers),
            "bottlenecks": self._build_bottlenecks(answers),
            "opportunities": recommendations[:5],
        }

    # Gera o roadmap acionável a partir das práticas com menor maturidade.
    def get_recommendations_payload(self, request):
        context = self._resolve_context(request)
        answers = context["current_answers"]
        selected_answers = context.get("selected_answers", answers)
        selected_cycle_empty = context.get("selected_cycle_empty", False)
        recommendations = self._build_recommendations(answers)

        grouped_tracks = []
        for lane in self.RECOMMENDATION_TRACKS:
            items = [item for item in recommendations if item["track"] == lane["key"]]
            grouped_tracks.append({**lane, "count": len(items), "items": items})

        return {
            "organization": self._serialize_organization(context["organization"]),
            "cycle": self._serialize_cycle(
                context["questionnaire"],
                selected_answers if context["questionnaire"] is not None else answers,
            ),
            "scope": context["stage_scope"],
            "selected_cycle_empty": selected_cycle_empty,
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
                "available_practice_groups": sorted(
                    {
                        item["dimension_name"]
                        for item in recommendations
                        if item["dimension_name"]
                    }
                ),
                "available_priorities": ["High", "Medium", "Low"],
            },
            "tracks": grouped_tracks,
            "items": recommendations,
        }

    # Resume a evolução entre ciclos para responder o que mudou ao longo do tempo.
    def get_history_payload(self, request):
        context = self._resolve_context(request)
        selected_answers = context.get("selected_answers", context["current_answers"])
        selected_cycle_empty = context.get("selected_cycle_empty", False)
        cycles = self._build_history_cycles(
            context["all_answers"], context["organization"]
        )

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
            "cycle": self._serialize_cycle(
                context["questionnaire"],
                selected_answers,
            ),
            "scope": context["stage_scope"],
            "selected_cycle_empty": selected_cycle_empty,
            "summary": {
                "cycle_count": len(cycles),
                "overall_delta": overall_delta,
                "recommendation_reduction": recommendation_reduction,
            },
            "cycles": cycles,
        }

    # Monta a resposta agregada de comparacao para o card de benchmark.
    def get_comparison_payload(self, request):
        context = self._resolve_context(request)
        organization = context["organization"]
        current_answers = context["current_answers"]
        all_answers = context["all_answers"]

        reference_mode = request.query_params.get("reference_mode", "first-submission")
        reference_questionnaire_id = request.query_params.get(
            "reference_questionnaire_id"
        )

        reference_answers, reference_questionnaire = self._resolve_reference_answers(
            all_answers,
            reference_mode,
            reference_questionnaire_id,
        )

        current_questionnaire = context["questionnaire"]
        current_cycle = self._serialize_cycle(current_questionnaire, current_answers)
        reference_cycle = self._serialize_cycle(
            reference_questionnaire,
            reference_answers,
        )

        current_overall_score = self._score_for_answers(current_answers)
        reference_overall_score = self._score_for_answers(reference_answers)

        return {
            "organization": self._serialize_organization(organization),
            "scope": context["stage_scope"],
            "selection": {
                "reference_mode": reference_mode,
                "current_cycle": current_cycle,
                "reference_cycle": reference_cycle,
                "available_cycles": self._build_history_cycles(all_answers),
            },
            "summary": {
                "current_score": current_overall_score,
                "reference_score": reference_overall_score,
                "delta": current_overall_score - reference_overall_score,
                "current_answered_practices": len(current_answers),
                "reference_answered_practices": len(reference_answers),
            },
            "lenses": {
                "eye": self._build_comparison_lens_payload(
                    lens_key="eye",
                    current_items=self._build_dimension_results(current_answers),
                    reference_items=self._build_dimension_results(reference_answers),
                    current_overall_score=current_overall_score,
                    reference_overall_score=reference_overall_score,
                ),
                "sth": self._build_comparison_lens_payload(
                    lens_key="sth",
                    current_items=[
                        item
                        for item in self._build_stage_scores(current_answers)
                        if item["short_name"] != "Traditional"
                    ],
                    reference_items=[
                        item
                        for item in self._build_stage_scores(reference_answers)
                        if item["short_name"] != "Traditional"
                    ],
                    current_overall_score=current_overall_score,
                    reference_overall_score=reference_overall_score,
                ),
            },
        }

    # Resolve todo o contexto necessário: organização, escopo, ciclo escolhido e respostas filtradas.
    def _resolve_context(self, request):
        organization = self._resolve_organization(request)
        stage_scope = request.query_params.get("stage_scope", "all")
        all_answers = list(self._base_answers_queryset(organization.id, stage_scope))
        questionnaire = self._resolve_questionnaire(
            request,
            organization.id,
            all_answers,
        )
        selected_answers = self._answers_for_questionnaire(
            all_answers,
            questionnaire,
        )
        selected_cycle_empty = questionnaire is not None and not selected_answers
        current_answers = selected_answers

        if not current_answers:
            current_answers = all_answers

        expected_statement_count, expected_stage_counts = self._build_statement_targets(
            stage_scope
        )

        return {
            "organization": organization,
            "questionnaire": questionnaire,
            "stage_scope": stage_scope,
            "all_answers": all_answers,
            "selected_answers": selected_answers,
            "selected_cycle_empty": selected_cycle_empty,
            "current_answers": current_answers,
            "expected_statement_count": expected_statement_count,
            "expected_stage_counts": expected_stage_counts,
        }

    def _resolve_reference_answers(
        self,
        answers,
        reference_mode,
        reference_questionnaire_id,
    ):
        grouped = self._group_answers_by_questionnaire(answers)

        if reference_mode == "first-submission":
            ordered_groups = sorted(
                grouped.items(),
                key=lambda item: self._questionnaire_sort_key(
                    item[1][0].questionnaire_answer if item[1] else None
                ),
            )
            if not ordered_groups:
                return list(answers), None

            for questionnaire_id, cycle_answers in ordered_groups:
                if questionnaire_id is not None:
                    return cycle_answers, cycle_answers[0].questionnaire_answer

            fallback_answers = ordered_groups[0][1]
            return (
                fallback_answers,
                fallback_answers[0].questionnaire_answer if fallback_answers else None,
            )

        if reference_mode == "specific-cycles":
            if reference_questionnaire_id in (None, ""):
                raise ValidationError(
                    "reference_questionnaire_id is required for specific-cycles comparison"
                )

            try:
                questionnaire_id = int(reference_questionnaire_id)
            except (TypeError, ValueError) as exc:
                raise ValidationError(
                    "reference_questionnaire_id must be an integer"
                ) from exc

            cycle_answers = grouped.get(questionnaire_id)
            if cycle_answers is None:
                raise ValidationError("reference_questionnaire_id not found")
            if not cycle_answers:
                raise ValidationError(
                    "reference_questionnaire_id has no answers in the selected scope"
                )

            return cycle_answers, cycle_answers[0].questionnaire_answer

        raise ValidationError(
            "reference_mode must be first-submission or specific-cycles"
        )

    def _group_answers_by_questionnaire(self, answers):
        grouped = defaultdict(list)
        for answer in answers:
            grouped[answer.questionnaire_answer_id].append(answer)
        return grouped

    def _questionnaire_sort_key(self, questionnaire):
        if questionnaire is None:
            return ("9999-12-31", 999999)

        applied_date = questionnaire.applied_date or questionnaire.uploaded_at
        return (
            applied_date.isoformat() if applied_date is not None else "9999-12-30",
            questionnaire.id,
        )

    def _build_comparison_lens_payload(
        self,
        lens_key,
        current_items,
        reference_items,
        current_overall_score,
        reference_overall_score,
    ):
        config = self.COMPARISON_LENS_CONFIG[lens_key]
        current_lookup = {
            item[config["item_key"]]: item[config["item_value"]]
            for item in current_items
        }
        reference_lookup = {
            item[config["item_key"]]: item[config["item_value"]]
            for item in reference_items
        }

        axes = []
        for axis in config["axes"]:
            current_value = current_lookup.get(axis["key"], 0)
            reference_value = reference_lookup.get(axis["key"], 0)
            axes.append(
                {
                    "key": axis["key"],
                    "label": axis["label"],
                    "current": current_value,
                    "reference": reference_value,
                    "delta": current_value - reference_value,
                }
            )

        return {
            "title": config["title"],
            "subtitle": config["subtitle"],
            "current_score": current_overall_score,
            "reference_score": reference_overall_score,
            "delta": current_overall_score - reference_overall_score,
            "axes": axes,
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
            questionnaire = Questionnaire.objects.filter(id=questionnaire_id).first()
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
    def _score_for_answers(self, answers, expected_total=None):
        percentages = [
            answer.adopted_level_answer.percentage
            for answer in answers
            if answer.adopted_level_answer is not None
        ]
        total = len(percentages)
        if expected_total is not None:
            total = max(total, expected_total)

        if total == 0:
            return 0
        return round(sum(percentages) / total)

    def _questionnaire_status(self, answered_count, expected_total):
        if expected_total <= 0:
            return "Incomplete"
        return "Complete" if answered_count >= expected_total else "Incomplete"

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
    def _build_stage_scores(self, answers, expected_stage_counts=None):
        grouped = defaultdict(list)
        for answer in answers:
            stage = getattr(answer.statement_answer, "sth_stage", None)
            stage_name = getattr(stage, "name", None) or "Unknown stage"
            grouped[stage_name].append(answer)

        items = []
        stage_names = list(grouped.keys())
        if expected_stage_counts:
            stage_names = list(
                dict.fromkeys([*expected_stage_counts.keys(), *stage_names]).keys()
            )

        for stage_name in stage_names:
            stage_answers = grouped.get(stage_name, [])
            expected_total = (
                expected_stage_counts.get(stage_name)
                if expected_stage_counts is not None
                else None
            )
            score = self._score_for_answers(
                stage_answers,
                expected_total=expected_total,
            )
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
                    "total_practices": expected_total
                    if expected_total is not None
                    else len(stage_answers),
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

    def _build_statement_targets(self, stage_scope):
        queryset = Statement.objects.select_related("sth_stage")

        if stage_scope == "ci_cd":
            queryset = queryset.filter(sth_stage__name__in=self.CI_CD_STAGE_NAMES)

        stage_counts = defaultdict(int)
        total = 0

        for statement in queryset:
            stage_name = getattr(statement.sth_stage, "name", None) or "Unknown stage"
            stage_counts[stage_name] += 1
            total += 1

        return total, dict(stage_counts)

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
            dimension_name = self._resolve_dimension_name(answer)
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

    def _build_dimension_stage_overview(self, answers):
        grouped = defaultdict(
            lambda: {
                "organization": [],
                "CI": [],
                "CD": [],
            }
        )

        for answer in answers:
            statement_code = getattr(answer.statement_answer, "code", "") or ""
            if statement_code not in self.INSTRUMENT_PRACTICE_CATALOG:
                continue

            dimension_name = self._resolve_dimension_name(answer)
            stage_name = getattr(answer.statement_answer.sth_stage, "name", None)
            stage_short_name = self.STAGE_SHORT_NAMES.get(stage_name, stage_name)
            score = self._instrument_weight(answer)

            grouped[dimension_name]["organization"].append(score)
            if stage_short_name in {"CI", "CD"}:
                grouped[dimension_name][stage_short_name].append(score)

        items = []
        ci_aggregate = []
        cd_aggregate = []
        organization_aggregate = []

        for dimension_name, buckets in grouped.items():
            ci_scores = buckets["CI"]
            cd_scores = buckets["CD"]
            org_scores = buckets["organization"]

            ci_aggregate.extend(ci_scores)
            cd_aggregate.extend(cd_scores)
            organization_aggregate.extend(org_scores)

            items.append(
                {
                    "key": slugify(dimension_name),
                    "name": dimension_name,
                    "ci_score": round(mean(ci_scores)) if ci_scores else None,
                    "cd_score": round(mean(cd_scores)) if cd_scores else None,
                    "organization_score": round(mean(org_scores)) if org_scores else 0,
                    "ci_practice_count": len(ci_scores),
                    "cd_practice_count": len(cd_scores),
                    "practice_count": len(org_scores),
                }
            )

        items.sort(
            key=lambda item: (
                self.DIMENSION_ORDER.get(item["name"], 500),
                item["name"],
            )
        )

        return {
            "dimensions": items,
            "summary": {
                "ci_score": round(mean(ci_aggregate)) if ci_aggregate else None,
                "cd_score": round(mean(cd_aggregate)) if cd_aggregate else None,
                "organization_score": (
                    round(mean(organization_aggregate)) if organization_aggregate else 0
                ),
                "statement_count": len(organization_aggregate),
            },
        }

    def _build_adoption_level_stage_overview(self, answers):
        stage_level_counts = {
            "CI": defaultdict(int),
            "CD": defaultdict(int),
        }

        for answer in answers:
            statement_code = getattr(answer.statement_answer, "code", "") or ""
            if statement_code not in self.INSTRUMENT_PRACTICE_CATALOG:
                continue

            stage_name = getattr(answer.statement_answer.sth_stage, "name", None)
            stage_short_name = self.STAGE_SHORT_NAMES.get(stage_name, stage_name)
            if stage_short_name not in {"CI", "CD"}:
                continue

            level_name = getattr(answer.adopted_level_answer, "name", "") or ""
            stage_level_counts[stage_short_name][level_name] += 1

        rows = []
        total_ci = 0
        total_cd = 0
        total_organization = 0
        weighted_ci = 0
        weighted_cd = 0
        weighted_organization = 0

        for level in self.adopted_levels:
            weight = self.INSTRUMENT_WEIGHT_BY_PERCENTAGE.get(
                level.percentage,
                level.percentage,
            )
            ci_count = stage_level_counts["CI"].get(level.name, 0)
            cd_count = stage_level_counts["CD"].get(level.name, 0)
            organization_count = ci_count + cd_count

            total_ci += ci_count
            total_cd += cd_count
            total_organization += organization_count
            weighted_ci += ci_count * weight
            weighted_cd += cd_count * weight
            weighted_organization += organization_count * weight

            rows.append(
                {
                    "key": slugify(level.name),
                    "label": level.name,
                    "weight": weight,
                    "ci_count": ci_count,
                    "cd_count": cd_count,
                    "organization_count": organization_count,
                }
            )

        return {
            "levels": rows,
            "totals": {
                "ci_count": total_ci,
                "cd_count": total_cd,
                "organization_count": total_organization,
            },
            "degree_of_adoption": {
                "ci_score": round(weighted_ci / total_ci) if total_ci else None,
                "cd_score": round(weighted_cd / total_cd) if total_cd else None,
                "organization_score": (
                    round(weighted_organization / total_organization)
                    if total_organization
                    else None
                ),
            },
        }

    def _build_dimension_element_overview(self, answers):
        grouped = defaultdict(
            lambda: {
                "organization": [],
                "CI": [],
                "CD": [],
            }
        )

        for answer in answers:
            statement_code = getattr(answer.statement_answer, "code", "") or ""
            if statement_code not in self.INSTRUMENT_PRACTICE_CATALOG:
                continue

            dimension_name = self._resolve_dimension_name(answer)
            element_name = self._resolve_element_name(answer) or "Unclassified element"
            stage_name = getattr(answer.statement_answer.sth_stage, "name", None)
            stage_short_name = self.STAGE_SHORT_NAMES.get(stage_name, stage_name)
            score = self._instrument_weight(answer)

            grouped[(dimension_name, element_name)]["organization"].append(score)
            if stage_short_name in {"CI", "CD"}:
                grouped[(dimension_name, element_name)][stage_short_name].append(score)

        element_order = {}
        order_index = 0
        for code, item in self.INSTRUMENT_PRACTICE_CATALOG.items():
            dimension_name = item.get("dimension") or "Unclassified"
            element_name = item.get("element") or "Unclassified element"
            key = (dimension_name, element_name)
            if key not in element_order:
                element_order[key] = order_index
                order_index += 1

        rows = []
        for (dimension_name, element_name), buckets in grouped.items():
            ci_scores = buckets["CI"]
            cd_scores = buckets["CD"]
            org_scores = buckets["organization"]

            rows.append(
                {
                    "key": slugify(f"{dimension_name}-{element_name}"),
                    "dimension_name": dimension_name,
                    "element_name": element_name,
                    "ci_score": round(mean(ci_scores)) if ci_scores else None,
                    "cd_score": round(mean(cd_scores)) if cd_scores else None,
                    "organization_score": round(mean(org_scores)) if org_scores else 0,
                }
            )

        rows.sort(
            key=lambda item: (
                self.DIMENSION_ORDER.get(item["dimension_name"], 500),
                element_order.get(
                    (item["dimension_name"], item["element_name"]),
                    9999,
                ),
                item["element_name"],
            )
        )

        return {
            "rows": rows,
            "summary": self._build_dimension_stage_overview(answers)["summary"],
        }

    # Gera recomendações para práticas abaixo do limiar de 60 por cento.
    def _build_recommendations(self, answers):
        items = []
        recommendations_catalog = self._get_recommendations_catalog()
        candidates = [
            answer for answer in answers if self._is_recommendation_candidate(answer)
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
            statement = answer.statement_answer
            stage_name = getattr(
                statement.sth_stage,
                "name",
                None,
            )
            track = "Adopt now" if level.percentage <= 10 else "Consolidate"
            priority = "High" if level.percentage <= 10 else "Medium"
            catalog_entry = recommendations_catalog.get(statement.code, {})
            element_name = self._resolve_element_name(answer)

            items.append(
                {
                    "id": answer.id,
                    "question_id": statement.code,
                    "question_description": (
                        catalog_entry.get("question_description") or statement.text
                    ),
                    "stage_name": stage_name,
                    "stage_short_name": self.STAGE_SHORT_NAMES.get(
                        stage_name,
                        stage_name,
                    ),
                    "dimension_name": self._resolve_dimension_name(answer),
                    "element_name": element_name,
                    "track": track,
                    "priority": priority,
                    "current_level": level.name,
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
                    "catalog_recommendation": catalog_entry.get(
                        "catalog_recommendation", ""
                    ),
                    "trigger_rule": self._recommendation_rule(level, track),
                    "reference_source": (
                        "Questionnaire recommendations catalog"
                        if catalog_entry.get("catalog_recommendation")
                        else "Generated from analytics rules"
                    ),
                    "status": "Suggested",
                }
            )

        return items

    # Reconstrói a linha do tempo dos ciclos da organização.
    def _build_history_cycles(self, answers, organization=None):
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

        if organization:
            org_questionnaires = Questionnaire.objects.filter(
                employee_questionnaire__employee_organization_id=organization.id
            )
            for q in org_questionnaires:
                if q.id not in questionnaires:
                    questionnaires[q.id] = q
                    if q.id not in grouped:
                        grouped[q.id] = []

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
                            if self._is_recommendation_candidate(answer)
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

    def _is_recommendation_candidate(self, answer):
        percentage = getattr(answer.adopted_level_answer, "percentage", 0)
        if percentage >= 60:
            return False

        statement_code = getattr(answer.statement_answer, "code", "") or ""
        return statement_code.startswith(("CI.", "CD."))

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

    # Resolve a dimensao exibida na interface mesmo quando o catalogo
    # oficial informa apenas o stage da pergunta.
    def _resolve_dimension_name(self, answer):
        statement_code = getattr(answer.statement_answer, "code", "") or ""
        instrument_entry = self.INSTRUMENT_PRACTICE_CATALOG.get(statement_code)
        if instrument_entry:
            return instrument_entry["dimension"]

        dimension = getattr(
            getattr(answer.statement_answer, "pe_element", None),
            "dimension",
            None,
        )
        if getattr(dimension, "name", None):
            return dimension.name

        stage_name = getattr(
            getattr(answer.statement_answer, "sth_stage", None),
            "name",
            None,
        )
        if stage_name:
            return self.DIMENSION_LABELS.get(stage_name, stage_name)

        if statement_code.startswith("AO."):
            return "Agile Development"
        if statement_code.startswith("CI."):
            return "Continuous Integration"
        if statement_code.startswith("CD."):
            return "Continuous Deployment"
        if statement_code.startswith("IS."):
            return "Continuous Experimentation"
        return "Unclassified"

    def _resolve_element_name(self, answer):
        element_name = getattr(
            getattr(answer.statement_answer, "pe_element", None), "name", None
        )
        if element_name:
            return element_name

        statement_code = getattr(answer.statement_answer, "code", "") or ""
        instrument_entry = self.INSTRUMENT_PRACTICE_CATALOG.get(statement_code)
        if instrument_entry:
            return instrument_entry["element"]

        return None

    def _instrument_weight(self, answer):
        percentage = getattr(answer.adopted_level_answer, "percentage", 0)
        return self.INSTRUMENT_WEIGHT_BY_PERCENTAGE.get(percentage, percentage)

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

    def _recommendation_rule(self, level, track):
        if track == "Adopt now":
            return (
                f"{level.name} practices should first be established as a stable "
                "working routine."
            )

        return (
            f"{level.name} practices should now be expanded from local usage to "
            "process-level capability."
        )

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
