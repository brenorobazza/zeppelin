from .models import (
    OrganizationCategory,
    Size,
    OrganizationType,
    Region,
    State,
    Organization,
)
from .serializers import (
    OrganizationCategoryReadSerializer,
    OrganizationCategoryWriteSerializer,
    SizeReadSerializer,
    SizeWriteSerializer,
    OrganizationTypeReadSerializer,
    OrganizationTypeWriteSerializer,
    RegionReadSerializer,
    RegionWriteSerializer,
    StateReadSerializer,
    StateWriteSerializer,
    OrganizationReadSerializer,
    OrganizationWriteSerializer,
)


from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import IsAdminUser, AllowAny
from rest_condition import Or
from oauth2_provider.contrib.rest_framework import (
    TokenHasReadWriteScope,
    OAuth2Authentication,
)
from rest_framework.authentication import SessionAuthentication
from .pagination import CustomPagination
from rest_framework import filters
import django_filters.rest_framework


class OrganizationCategoryViewSet(ModelViewSet):
    queryset = OrganizationCategory.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend,
    )
    filterset_fields = "__all__"
    search_fields = []
    ordering_fields = "__all__"
    ordering = ["id"]

    def get_serializer_class(self):
        if self.request.method in ["GET"]:
            return OrganizationCategoryReadSerializer
        return OrganizationCategoryWriteSerializer


class SizeViewSet(ModelViewSet):
    queryset = Size.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend,
    )
    filterset_fields = "__all__"
    search_fields = []
    ordering_fields = "__all__"
    ordering = ["id"]

    def get_serializer_class(self):
        if self.request.method in ["GET"]:
            return SizeReadSerializer
        return SizeWriteSerializer


class OrganizationTypeViewSet(ModelViewSet):
    queryset = OrganizationType.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend,
    )
    filterset_fields = "__all__"
    search_fields = []
    ordering_fields = "__all__"
    ordering = ["id"]

    def get_serializer_class(self):
        if self.request.method in ["GET"]:
            return OrganizationTypeReadSerializer
        return OrganizationTypeWriteSerializer


class RegionViewSet(ModelViewSet):
    queryset = Region.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend,
    )
    filterset_fields = "__all__"
    search_fields = []
    ordering_fields = "__all__"
    ordering = ["id"]

    def get_serializer_class(self):
        if self.request.method in ["GET"]:
            return RegionReadSerializer
        return RegionWriteSerializer


class StateViewSet(ModelViewSet):
    queryset = State.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend,
    )
    filterset_fields = "__all__"
    search_fields = ["latitude", "longitude"]
    ordering_fields = "__all__"
    ordering = ["id"]

    def get_serializer_class(self):
        if self.request.method in ["GET"]:
            return StateReadSerializer
        return StateWriteSerializer


class OrganizationViewSet(ModelViewSet):
    queryset = Organization.objects.all()
    pagination_class = CustomPagination
    authentication_classes = [OAuth2Authentication, SessionAuthentication]
    permission_classes = [Or(IsAdminUser, TokenHasReadWriteScope)]
    filter_backends = (
        filters.SearchFilter,
        filters.OrderingFilter,
        django_filters.rest_framework.DjangoFilterBackend,
    )
    filterset_fields = "__all__"
    search_fields = ["name"]
    ordering_fields = "__all__"
    ordering = ["id"]

    """
    get_authenticators e get_permissions são sobrescritos para permitir
    acesso anônimo às operações de listagem e recuperação, enquanto exigem
    autenticação e permissões adequadas para operações de criação,
    atualização e exclusão.

    Removê-los fará com que todas as operações exijam autenticação e permissões,
    o que pode aumentar a segurança, mas reduzirá a acessibilidade para usuários não autenticados.
    """

    def get_authenticators(self):
        if self.request.method in ["GET"]:
            return []
        return super().get_authenticators()

    def get_permissions(self):
        if self.action in ["list", "retrieve"]:
            return [AllowAny()]
        return [Or(IsAdminUser, TokenHasReadWriteScope)]

    def get_serializer_class(self):
        if self.request.method in ["GET"]:
            return OrganizationReadSerializer
        return OrganizationWriteSerializer
