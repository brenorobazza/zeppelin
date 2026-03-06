from django.urls import path, register_converter, include
from rest_framework import routers
from .api_views import (
    StageViewSet,
)
router = routers.DefaultRouter()

router.register(r'stage', StageViewSet, basename='stage')

urlpatterns = [
    path('sth/', include(router.urls))
]
