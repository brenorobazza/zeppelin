from django.apps import AppConfig

class OrganizationConfig(AppConfig):
    name  = 'apps.organization'
    label = 'apps_organization'

    def ready(self):
        import apps.organization.signals
