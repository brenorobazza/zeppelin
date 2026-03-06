from django.apps import AppConfig

class QuestionnaireConfig(AppConfig):
    name  = 'apps.questionnaire'
    label = 'apps_questionnaire'

    def ready(self):
        import apps.questionnaire.signals
