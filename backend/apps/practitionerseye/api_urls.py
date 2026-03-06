from django.urls import path, register_converter, include
from rest_framework import routers
from .api_views import (
    DimensionViewSet,
    ElementViewSet,
)
router = routers.DefaultRouter()

router.register(r'dimension', DimensionViewSet, basename='dimension')
router.register(r'element', ElementViewSet, basename='element')

urlpatterns = [
    path('practitionerseye/', include(router.urls))
]
