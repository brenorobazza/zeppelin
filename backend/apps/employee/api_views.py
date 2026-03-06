from .models import (
    AcademicDegreeCategory,
    AcademicDegree,
    AcademicDegreeStatus,
    KnwoledgeLevel,
    ExperienceLevel,
    Position,
    Employee,
    EmployeeKnowledge,
    SthStageKnwoledgeLevel,
    SthStageExperienceLevel,
    Team,
)
from .serializers import (
    AcademicDegreeCategoryReadSerializer, AcademicDegreeCategoryWriteSerializer,
    AcademicDegreeReadSerializer, AcademicDegreeWriteSerializer,
    AcademicDegreeStatusReadSerializer, AcademicDegreeStatusWriteSerializer,
    KnwoledgeLevelReadSerializer, KnwoledgeLevelWriteSerializer,
    ExperienceLevelReadSerializer, ExperienceLevelWriteSerializer,
    PositionReadSerializer, PositionWriteSerializer,
    EmployeeReadSerializer, EmployeeWriteSerializer,
    EmployeeKnowledgeReadSerializer, EmployeeKnowledgeWriteSerializer,
    SthStageKnwoledgeLevelReadSerializer, SthStageKnwoledgeLevelWriteSerializer,
    SthStageExperienceLevelReadSerializer, SthStageExperienceLevelWriteSerializer,
    TeamReadSerializer, TeamWriteSerializer,
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


class AcademicDegreeCategoryViewSet(ModelViewSet):
    queryset = AcademicDegreeCategory.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = []
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return AcademicDegreeCategoryReadSerializer
        return AcademicDegreeCategoryWriteSerializer

class AcademicDegreeViewSet(ModelViewSet):
    queryset = AcademicDegree.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = []
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return AcademicDegreeReadSerializer
        return AcademicDegreeWriteSerializer

class AcademicDegreeStatusViewSet(ModelViewSet):
    queryset = AcademicDegreeStatus.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = []
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return AcademicDegreeStatusReadSerializer
        return AcademicDegreeStatusWriteSerializer

class KnwoledgeLevelViewSet(ModelViewSet):
    queryset = KnwoledgeLevel.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = ['value']
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return KnwoledgeLevelReadSerializer
        return KnwoledgeLevelWriteSerializer

class ExperienceLevelViewSet(ModelViewSet):
    queryset = ExperienceLevel.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = ['value']
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return ExperienceLevelReadSerializer
        return ExperienceLevelWriteSerializer

class PositionViewSet(ModelViewSet):
    queryset = Position.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = []
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return PositionReadSerializer
        return PositionWriteSerializer

class EmployeeViewSet(ModelViewSet):
    queryset = Employee.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = ['e_mail', 'role']
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return EmployeeReadSerializer
        return EmployeeWriteSerializer

class EmployeeKnowledgeViewSet(ModelViewSet):
    queryset = EmployeeKnowledge.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = []
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return EmployeeKnowledgeReadSerializer
        return EmployeeKnowledgeWriteSerializer

class SthStageKnwoledgeLevelViewSet(ModelViewSet):
    queryset = SthStageKnwoledgeLevel.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = []
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return SthStageKnwoledgeLevelReadSerializer
        return SthStageKnwoledgeLevelWriteSerializer

class SthStageExperienceLevelViewSet(ModelViewSet):
    queryset = SthStageExperienceLevel.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = []
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return SthStageExperienceLevelReadSerializer
        return SthStageExperienceLevelWriteSerializer

class TeamViewSet(ModelViewSet):
    queryset = Team.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend
    )
    filterset_fields = '__all__'
    search_fields = []
    ordering_fields = '__all__'
    ordering = ["id"]
    
    def get_serializer_class(self):
        if self.request.method in ['GET']:
            return TeamReadSerializer
        return TeamWriteSerializer
