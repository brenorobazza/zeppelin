from .models import (
    AdoptedLevel,
    Statement,
    FeedbackQuestionnaire,
    Questionnaire,
    QuestionnaireExcel,
    Answer,
)
from .serializers import (
    AdoptedLevelReadSerializer, AdoptedLevelWriteSerializer,
    StatementReadSerializer, StatementWriteSerializer,
    FeedbackQuestionnaireReadSerializer, FeedbackQuestionnaireWriteSerializer,
    QuestionnaireReadSerializer, QuestionnaireWriteSerializer,
    QuestionnaireExcelReadSerializer, QuestionnaireExcelWriteSerializer,
    AnswerReadSerializer, AnswerWriteSerializer,
)

from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import IsAdminUser
from rest_condition import And, Or
from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope, OAuth2Authentication
from rest_framework.authentication import SessionAuthentication
from .pagination import CustomPagination
from rest_framework import generics
from rest_framework import filters
import django_filters.rest_framework


class AdoptedLevelViewSet(ModelViewSet):
    queryset = AdoptedLevel.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = ['percentage']
    ordering_fields = 'percentage'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return AdoptedLevelReadSerializer
        return AdoptedLevelWriteSerializer

class StatementViewSet(ModelViewSet):
    queryset = Statement.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = ['code', 'statement']
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return StatementReadSerializer
        return StatementWriteSerializer

class FeedbackQuestionnaireViewSet(ModelViewSet):
    queryset = FeedbackQuestionnaire.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = ['collected_date']
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return FeedbackQuestionnaireReadSerializer
        return FeedbackQuestionnaireWriteSerializer

class QuestionnaireViewSet(ModelViewSet):
    queryset = Questionnaire.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = ['applied_date']
    search_fields = ['applied_date']
    ordering_fields = ['applied_date']
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return QuestionnaireReadSerializer
        return QuestionnaireWriteSerializer

class QuestionnaireExcelViewSet(ModelViewSet):
    queryset = QuestionnaireExcel.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = ['applied_date']
    search_fields = ['applied_date']
    ordering_fields = ['applied_date']
    ordering = ["id"]
    
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return QuestionnaireExcelReadSerializer
        return QuestionnaireExcelWriteSerializer

class AnswerViewSet(ModelViewSet):
    queryset = Answer.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = ['comment']
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return AnswerReadSerializer
        return AnswerWriteSerializer
