from django.urls import path, register_converter, include
from rest_framework import routers
from .api_views import (
    ContinuousPhaseViewSet,
    ContinuousActivityViewSet,
)
router = routers.DefaultRouter()

router.register(r'continuousphase', ContinuousPhaseViewSet, basename='continuousphase')
router.register(r'continuousactivity', ContinuousActivityViewSet, basename='continuousactivity')

urlpatterns = [
    path('continuousstar/', include(router.urls))
]
