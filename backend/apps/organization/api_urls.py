from django.urls import path, register_converter, include
from rest_framework import routers
from .api_views import (
    OrganizationCategoryViewSet,
    SizeViewSet,
    OrganizationTypeViewSet,
    RegionViewSet,
    StateViewSet,
    OrganizationViewSet,
)
router = routers.DefaultRouter()

router.register(r'organizationcategory', OrganizationCategoryViewSet, basename='organizationcategory')
router.register(r'size', SizeViewSet, basename='size')
router.register(r'organizationtype', OrganizationTypeViewSet, basename='organizationtype')
router.register(r'region', RegionViewSet, basename='region')
router.register(r'state', StateViewSet, basename='state')
router.register(r'organization', OrganizationViewSet, basename='organization')

urlpatterns = [
    path('organization/', include(router.urls))
]
