from django.contrib import admin
from .models import OrganizationCategory,Size,OrganizationType,Region,State,Organization

@admin.register(OrganizationCategory)
class OrganizationCategoryAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(Size)
class SizeAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(OrganizationType)
class OrganizationTypeAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(Region)
class RegionAdmin(admin.ModelAdmin):
    list_display = ['id',]
    list_display_links = ['id',]
    search_fields = ['id',]
    list_per_page = 25
    ordering = ['-id']

@admin.register(State)
class StateAdmin(admin.ModelAdmin):
    list_display = ['id', 'latitude', 'longitude']
    list_display_links = ['id', 'latitude', 'longitude']
    search_fields = ['id', 'latitude', 'longitude']
    list_per_page = 25
    ordering = ['-id']

@admin.register(Organization)
class OrganizationAdmin(admin.ModelAdmin):
    list_display = ['id', 'age']
    list_display_links = ['id', 'age']
    search_fields = ['id', 'age']
    list_per_page = 25
    ordering = ['-id']

