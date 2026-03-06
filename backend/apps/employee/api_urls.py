from django.urls import path, register_converter, include
from rest_framework import routers
from .api_views import (
    AcademicDegreeCategoryViewSet,
    AcademicDegreeViewSet,
    AcademicDegreeStatusViewSet,
    KnwoledgeLevelViewSet,
    ExperienceLevelViewSet,
    PositionViewSet,
    EmployeeViewSet,
    EmployeeKnowledgeViewSet,
    SthStageKnwoledgeLevelViewSet,
    SthStageExperienceLevelViewSet,
    TeamViewSet,
)
router = routers.DefaultRouter()

router.register(r'academicdegreecategory', AcademicDegreeCategoryViewSet, basename='academicdegreecategory')
router.register(r'academicdegree', AcademicDegreeViewSet, basename='academicdegree')
router.register(r'academicdegreestatus', AcademicDegreeStatusViewSet, basename='academicdegreestatus')
router.register(r'knwoledgelevel', KnwoledgeLevelViewSet, basename='knwoledgelevel')
router.register(r'experiencelevel', ExperienceLevelViewSet, basename='experiencelevel')
router.register(r'position', PositionViewSet, basename='position')
router.register(r'employee', EmployeeViewSet, basename='employee')
router.register(r'employeeknowledge', EmployeeKnowledgeViewSet, basename='employeeknowledge')
router.register(r'sthstageknwoledgelevel', SthStageKnwoledgeLevelViewSet, basename='sthstageknwoledgelevel')
router.register(r'sthstageexperiencelevel', SthStageExperienceLevelViewSet, basename='sthstageexperiencelevel')
router.register(r'team', TeamViewSet, basename='team')

urlpatterns = [
    path('employee/', include(router.urls))
]
