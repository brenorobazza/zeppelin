from django.contrib import admin
from .models import AcademicDegreeCategory,AcademicDegree,AcademicDegreeStatus,KnwoledgeLevel,ExperienceLevel,Position,Employee,EmployeeKnowledge,SthStageKnwoledgeLevel,SthStageExperienceLevel,Team

@admin.register(AcademicDegreeCategory)
class AcademicDegreeCategoryAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(AcademicDegree)
class AcademicDegreeAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(AcademicDegreeStatus)
class AcademicDegreeStatusAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(KnwoledgeLevel)
class KnwoledgeLevelAdmin(admin.ModelAdmin):
    list_display = ['id', 'value']
    list_display_links = ['id', 'value']
    search_fields = ['id', 'value']
    list_per_page = 25
    ordering = ['-id']

@admin.register(ExperienceLevel)
class ExperienceLevelAdmin(admin.ModelAdmin):
    list_display = ['id', 'value']
    list_display_links = ['id', 'value']
    search_fields = ['id', 'value']
    list_per_page = 25
    ordering = ['-id']

@admin.register(Position)
class PositionAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(Employee)
class EmployeeAdmin(admin.ModelAdmin):
    list_display = ['id', 'e_mail', 'role']
    list_display_links = ['id', 'e_mail', 'role']
    search_fields = ['id', 'e_mail', 'role']
    list_per_page = 25
    ordering = ['-id']

@admin.register(EmployeeKnowledge)
class EmployeeKnowledgeAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(SthStageKnwoledgeLevel)
class SthStageKnwoledgeLevelAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(SthStageExperienceLevel)
class SthStageExperienceLevelAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(Team)
class TeamAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

