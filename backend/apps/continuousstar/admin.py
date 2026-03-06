from django.contrib import admin
from .models import ContinuousPhase,ContinuousActivity

@admin.register(ContinuousPhase)
class ContinuousPhaseAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(ContinuousActivity)
class ContinuousActivityAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

