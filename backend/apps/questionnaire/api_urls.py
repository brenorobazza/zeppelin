from django.urls import path, include
from rest_framework import routers
from .api_views import (
    AdoptedLevelViewSet,
    StatementViewSet,
    FeedbackQuestionnaireViewSet,
    QuestionnaireViewSet,
    QuestionnaireExcelViewSet,
    AnswerViewSet,
    QuestionnaireDashboardAnalyticsView,
    QuestionnaireResultsAnalyticsView,
    QuestionnaireRecommendationsAnalyticsView,
    QuestionnaireHistoryAnalyticsView,
)

router = routers.DefaultRouter()

# Rotas CRUD ja existentes do modulo questionnaire.

router.register(r"adoptedlevel", AdoptedLevelViewSet, basename="adoptedlevel")
router.register(r"statement", StatementViewSet, basename="statement")
router.register(
    r"feedbackquestionnaire",
    FeedbackQuestionnaireViewSet,
    basename="feedbackquestionnaire",
)
router.register(r"questionnaire", QuestionnaireViewSet, basename="questionnaire")
router.register(
    r"questionnaireexcel", QuestionnaireExcelViewSet, basename="questionnaireexcel"
)
router.register(r"answer", AnswerViewSet, basename="answer")

# Rotas analíticas para o dashboard e relatórios.
urlpatterns = [
    path("questionnaire/", include(router.urls)),
    path(
        "questionnaire/analytics/dashboard/",
        QuestionnaireDashboardAnalyticsView.as_view(),
        name="questionnaire-analytics-dashboard",
    ),
    path(
        "questionnaire/analytics/results/",
        QuestionnaireResultsAnalyticsView.as_view(),
        name="questionnaire-analytics-results",
    ),
    path(
        "questionnaire/analytics/recommendations/",
        QuestionnaireRecommendationsAnalyticsView.as_view(),
        name="questionnaire-analytics-recommendations",
    ),
    path(
        "questionnaire/analytics/history/",
        QuestionnaireHistoryAnalyticsView.as_view(),
        name="questionnaire-analytics-history",
    ),
]
