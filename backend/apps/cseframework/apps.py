from django.apps import AppConfig

class CSEFrameworkConfig(AppConfig):
    name  = 'apps.cseframework'
    label = 'apps_cseframework'

    def ready(self):
        import apps.cseframework.signals
