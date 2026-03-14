from datetime import timedelta
from types import SimpleNamespace

from django.contrib.auth import get_user_model
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase
from django.urls import reverse
from django.utils import timezone

from apps.continuousstar.models import ContinuousActivity, ContinuousPhase
from apps.cseframework.models import Process
from apps.employee.models import Employee
from apps.organization.models import Organization
from apps.practitionerseye.models import Category, Element
from apps.questionnaire.analytics import QuestionnaireAnalyticsService
from apps.questionnaire.models import AdoptedLevel, Answer, Questionnaire, Statement
from apps.sth.models import Stage


# Este mixin monta um cenario de teste pequeno, mas suficiente para a camada analitica.
# Ele simula duas avaliacoes da mesma empresa e uma resposta de outra empresa
# para validar filtro, historico e isolamento de dados.
class QuestionnaireAnalyticsFixtureMixin:
    @classmethod
    def setUpTestData(cls):
        # Cria uma base de dados fixa compartilhada entre todos os testes desta suite.
        # Modelo padrao de usuario usado para autenticar as rotas.
        cls.user_model = get_user_model()

        # Organizacao principal usada no cenario.
        cls.organization = Organization.objects.create(
            name="Zeppelin Labs",
            description="Organization used in analytics tests",
            age=48,
        )

        # Organizacao secundaria usada para garantir que nao ha vazamento de dados.
        cls.other_organization = Organization.objects.create(
            name="Other Org",
            description="Should not leak into analytics payloads",
        )

        # Usuario autenticado e funcionario vinculado a empresa principal.
        cls.user = cls.user_model.objects.create_user(
            username="alex@example.com",
            email="alex@example.com",
            password="testpass123",
        )
        cls.employee = Employee.objects.create(
            e_mail="alex@example.com",
            role="Engineering Manager",
            employee_organization=cls.organization,
        )

        # Niveis de adocao que serao usados para score, gargalos e roadmap.
        cls.not_adopted = AdoptedLevel.objects.create(
            name="Not adopted",
            description="Practice is not adopted",
            percentage=0,
        )
        cls.abandoned = AdoptedLevel.objects.create(
            name="Abandoned",
            description="Practice was abandoned",
            percentage=10,
        )
        cls.project_level = AdoptedLevel.objects.create(
            name="Project/Product level",
            description="Practice exists locally",
            percentage=30,
        )
        cls.process_level = AdoptedLevel.objects.create(
            name="Process level",
            description="Practice is repeatable at process level",
            percentage=60,
        )
        cls.institutionalized = AdoptedLevel.objects.create(
            name="Institutionalized",
            description="Practice is institutionalized",
            percentage=100,
        )

        # Estagios centrais do recorte CI/CD.
        cls.ci_stage = Stage.objects.create(
            name=QuestionnaireAnalyticsService.CI_CD_STAGE_NAMES[0],
            description="Continuous integration stage",
        )
        cls.cd_stage = Stage.objects.create(
            name=QuestionnaireAnalyticsService.CI_CD_STAGE_NAMES[1],
            description="Continuous delivery stage",
        )

        # Estruturas auxiliares exigidas pelos modelos relacionados.
        cls.phase = ContinuousPhase.objects.create(
            name="Delivery flow",
            description="Continuous delivery phase",
        )
        cls.activity = ContinuousActivity.objects.create(
            name="Pipeline automation",
            description="Pipeline automation activity",
            continuous_phase=cls.phase,
        )

        cls.process = Process.objects.create(
            name="CI/CD governance",
            description="Process used in analytics tests",
        )

        cls.ci_category = Category.objects.create(
            name="Integration practices",
            description="Dimension for CI practices",
        )
        cls.cd_category = Category.objects.create(
            name="Delivery practices",
            description="Dimension for CD practices",
        )
        cls.ci_element = Element.objects.create(
            name="Build validation",
            description="Element linked to CI",
            dimension=cls.ci_category,
        )
        cls.cd_element = Element.objects.create(
            name="Release flow",
            description="Element linked to CD",
            dimension=cls.cd_category,
        )

        # Quatro assertivas minimas para representar o recorte de praticas CI/CD.
        cls.statement_ci_1 = cls._create_statement(
            code="CI.01",
            text="Every commit triggers an automated build.",
            stage=cls.ci_stage,
            element=cls.ci_element,
        )
        cls.statement_ci_2 = cls._create_statement(
            code="CI.02",
            text="Automated tests are executed consistently in the pipeline.",
            stage=cls.ci_stage,
            element=cls.ci_element,
        )
        cls.statement_cd_1 = cls._create_statement(
            code="CD.01",
            text="Deployment packages are produced automatically and consistently.",
            stage=cls.cd_stage,
            element=cls.cd_element,
        )
        cls.statement_cd_2 = cls._create_statement(
            code="CD.02",
            text="Production deployments are repeatable and observable.",
            stage=cls.cd_stage,
            element=cls.cd_element,
        )

        # Dois ciclos diferentes para validar selecao do mais recente e comparacao historica.
        cls.old_cycle = cls._create_questionnaire(days_ago=180)
        cls.current_cycle = cls._create_questionnaire(days_ago=30)

        # Respostas do ciclo antigo: quadro mais imaturo.
        cls._create_answer(
            questionnaire=cls.old_cycle,
            statement=cls.statement_ci_1,
            level=cls.not_adopted,
            comment="No build automation yet.",
        )
        cls._create_answer(
            questionnaire=cls.old_cycle,
            statement=cls.statement_ci_2,
            level=cls.abandoned,
            comment="Tests were disabled after instability.",
        )
        cls._create_answer(
            questionnaire=cls.old_cycle,
            statement=cls.statement_cd_1,
            level=cls.not_adopted,
            comment="Artifacts are created manually.",
        )
        cls._create_answer(
            questionnaire=cls.old_cycle,
            statement=cls.statement_cd_2,
            level=cls.project_level,
            comment="Some teams deploy with scripts.",
        )

        # Respostas do ciclo atual: parte amadureceu, parte ainda gera recomendacao.
        cls._create_answer(
            questionnaire=cls.current_cycle,
            statement=cls.statement_ci_1,
            level=cls.process_level,
            comment="Build is automated for all repositories.",
        )
        cls._create_answer(
            questionnaire=cls.current_cycle,
            statement=cls.statement_ci_2,
            level=cls.institutionalized,
            comment="Pipeline tests are enforced centrally.",
        )
        cls._create_answer(
            questionnaire=cls.current_cycle,
            statement=cls.statement_cd_1,
            level=cls.project_level,
            comment="Packaging exists but still varies between products.",
        )
        cls._create_answer(
            questionnaire=cls.current_cycle,
            statement=cls.statement_cd_2,
            level=cls.abandoned,
            comment="Deployment repeatability regressed after tool changes.",
        )

        cls._create_answer(
            questionnaire=cls.current_cycle,
            statement=cls.statement_ci_1,
            level=cls.institutionalized,
            organization=cls.other_organization,
            comment="Different organization answer.",
        )

        # Instanciamos o servico por ultimo, quando os niveis de adocao ja existem no banco.
        cls.service = QuestionnaireAnalyticsService()

    @classmethod
    # Cria uma assertiva completa com os relacionamentos exigidos pelo modelo.
    def _create_statement(cls, code, text, stage, element):
        statement = Statement.objects.create(
            code=code,
            text=text,
            sth_stage=stage,
            pe_element=element,
            continuous_activity=cls.activity,
        )
        statement.fcse_processes.add(cls.process)
        return statement

    @classmethod
    # Cria um questionario com data relativa para facilitar a ordenacao por ciclo.
    def _create_questionnaire(cls, days_ago):
        applied_date = timezone.now() - timedelta(days=days_ago)
        return Questionnaire.objects.create(
            applied_date=applied_date,
            document=SimpleUploadedFile(
                f"questionnaire-{days_ago}.txt",
                b"diagnosis content",
            ),
            employee_questionnaire=cls.employee,
        )

    @classmethod
    # Cria uma resposta individual vinculando pratica, nivel, empresa e ciclo.
    def _create_answer(
        cls,
        questionnaire,
        statement,
        level,
        comment,
        organization=None,
    ):
        return Answer.objects.create(
            questionnaire_answer=questionnaire,
            adopted_level_answer=level,
            statement_answer=statement,
            comment_answer=comment,
            organization_answer=organization or cls.organization,
        )

    # Monta um objeto simples que imita uma request, suficiente para testar o servico.
    def build_service_request(self, user=None, **query_params):
        return SimpleNamespace(query_params=query_params, user=user or self.user)


# Testes unitarios do servico de analytics.
class QuestionnaireAnalyticsServiceTests(
    QuestionnaireAnalyticsFixtureMixin,
    TestCase,
):
    # Garante que o dashboard usa o ciclo mais recente quando nenhum filtro e informado.
    def test_dashboard_payload_uses_latest_cycle_for_authenticated_user(self):
        payload = self.service.get_dashboard_payload(self.build_service_request())

        self.assertEqual(payload["organization"]["name"], "Zeppelin Labs")
        self.assertEqual(payload["cycle"]["id"], self.current_cycle.id)
        self.assertEqual(payload["snapshot"]["answered_practices"], 4)
        self.assertEqual(payload["snapshot"]["recommendation_count"], 2)
        self.assertEqual(payload["snapshot"]["overall_score"], 50)

        stage_short_names = {item["short_name"] for item in payload["stage_scores"]}
        self.assertEqual(stage_short_names, {"CI", "CD"})

    # Garante que o roadmap muda corretamente quando um ciclo especifico e solicitado.
    def test_recommendations_payload_honors_selected_cycle(self):
        payload = self.service.get_recommendations_payload(
            self.build_service_request(questionnaire_id=str(self.old_cycle.id))
        )

        self.assertEqual(payload["cycle"]["id"], self.old_cycle.id)
        self.assertEqual(payload["summary"]["triggered_recommendations"], 4)
        self.assertEqual(payload["summary"]["adopt_now_count"], 3)
        self.assertEqual(payload["summary"]["consolidate_count"], 1)

    # Garante que o historico resume a diferenca entre os ciclos disponiveis.
    def test_history_payload_summarizes_progress_between_cycles(self):
        payload = self.service.get_history_payload(self.build_service_request())

        self.assertEqual(payload["summary"]["cycle_count"], 2)
        self.assertEqual(payload["summary"]["overall_delta"], 40)
        self.assertEqual(payload["summary"]["recommendation_reduction"], 2)
        self.assertEqual(len(payload["cycles"]), 2)


# Testes de integracao dos endpoints usados pelo frontend.
class QuestionnaireAnalyticsApiTests(
    QuestionnaireAnalyticsFixtureMixin,
    TestCase,
):
    def setUp(self):
        # Todas as rotas analiticas exigem autenticacao, entao o cliente faz login aqui.
        self.client.force_login(self.user)

    # Verifica se o endpoint do dashboard devolve o payload esperado.
    def test_dashboard_endpoint_returns_backend_payload(self):
        response = self.client.get(reverse("questionnaire-analytics-dashboard"))
        expected_summary = self.service.get_dashboard_payload(
            self.build_service_request()
        )["snapshot"]["executive_summary"]

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()["cycle"]["id"], self.current_cycle.id)
        self.assertEqual(
            response.json()["snapshot"]["executive_summary"],
            expected_summary,
        )

    # Verifica se a API de resultados entrega blocos centrais para a tela analitica.
    def test_results_endpoint_returns_strengths_and_bottlenecks(self):
        response = self.client.get(reverse("questionnaire-analytics-results"))
        payload = response.json()

        self.assertEqual(response.status_code, 200)
        self.assertEqual(payload["summary"]["answered_practices"], 4)
        self.assertGreaterEqual(len(payload["strengths"]), 1)
        self.assertGreaterEqual(len(payload["bottlenecks"]), 1)
        self.assertEqual(len(payload["dimensions"]), 2)

    # Verifica se a API de recomendacoes respeita o filtro por ciclo.
    def test_recommendations_endpoint_supports_questionnaire_filter(self):
        response = self.client.get(
            reverse("questionnaire-analytics-recommendations"),
            {"questionnaire_id": self.old_cycle.id},
        )
        payload = response.json()

        self.assertEqual(response.status_code, 200)
        self.assertEqual(payload["cycle"]["id"], self.old_cycle.id)
        self.assertEqual(payload["summary"]["triggered_recommendations"], 4)

    # Verifica se a API de historico agrega corretamente os dois ciclos do cenario.
    def test_history_endpoint_returns_two_cycles(self):
        response = self.client.get(reverse("questionnaire-analytics-history"))
        payload = response.json()

        self.assertEqual(response.status_code, 200)
        self.assertEqual(payload["summary"]["cycle_count"], 2)
        self.assertEqual(len(payload["cycles"]), 2)

    # Verifica se entradas invalidas retornam erro tratado e nao falha interna.
    def test_dashboard_endpoint_returns_400_for_invalid_organization(self):
        response = self.client.get(
            reverse("questionnaire-analytics-dashboard"),
            {"organization_id": 999999},
        )

        self.assertEqual(response.status_code, 400)
        self.assertEqual(response.json()["error"], "organization_id not found")
