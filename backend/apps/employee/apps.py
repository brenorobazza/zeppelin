from django.apps import AppConfig

class EmployeeConfig(AppConfig):
    name  = 'apps.employee'
    label = 'apps_employee'

    def ready(self):
        import apps.employee.signals
