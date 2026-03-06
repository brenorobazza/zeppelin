from django.apps import AppConfig

class ContinuousStarConfig(AppConfig):
    name  = 'apps.continuousstar'
    label = 'apps_continuousstar'

    def ready(self):
        import apps.continuousstar.signals
