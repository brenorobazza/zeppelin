from django.apps import AppConfig

class PractitionersEyeConfig(AppConfig):
    name  = 'apps.practitionerseye'
    label = 'apps_practitionerseye'

    def ready(self):
        import apps.practitionerseye.signals
