from django.urls import path, register_converter, include
from rest_framework import routers
from .api_views import (
    ProcessViewSet,
)
router = routers.DefaultRouter()

router.register(r'process', ProcessViewSet, basename='process')

urlpatterns = [
    path('cseframework/', include(router.urls))
]
