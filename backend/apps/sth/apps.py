from django.apps import AppConfig

class SthConfig(AppConfig):
    name  = 'apps.sth'
    label = 'apps_sth'

    def ready(self):
        import apps.sth.signals
