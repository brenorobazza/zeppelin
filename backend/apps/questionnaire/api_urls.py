from django.urls import path, register_converter, include
from rest_framework import routers
from .api_views import (
    AdoptedLevelViewSet,
    StatementViewSet,
    FeedbackQuestionnaireViewSet,
    QuestionnaireViewSet,
    QuestionnaireExcelViewSet,
    AnswerViewSet,
)
router = routers.DefaultRouter()

router.register(r'adoptedlevel', AdoptedLevelViewSet, basename='adoptedlevel')
router.register(r'statement', StatementViewSet, basename='statement')
router.register(r'feedbackquestionnaire', FeedbackQuestionnaireViewSet, basename='feedbackquestionnaire')
router.register(r'questionnaire', QuestionnaireViewSet, basename='questionnaire')
router.register(r'questionnaireexcel', QuestionnaireExcelViewSet, basename='questionnaireexcel')
router.register(r'answer', AnswerViewSet, basename='answer')

urlpatterns = [
    path('questionnaire/', include(router.urls))
]
