from collections import defaultdict
from datetime import datetime

from django.contrib.auth.models import User
from django.core.files.base import ContentFile
from django.core.management import call_command
from django.core.management.base import BaseCommand
from django.db import transaction
from django.utils import timezone

from apps.employee.models import Employee
from apps.organization.models import Organization, OrganizationType, Size
from apps.questionnaire.models import AdoptedLevel, Answer, Questionnaire, Statement


class Command(BaseCommand):
    help = (
        "Cria uma base demo funcional para o TCC com empresas, ciclos e respostas "
        "persistidas a partir do catalogo oficial de questions.json."
    )

    demo_username = "demo.analyst"
    demo_email = "demo@zeppelin.local"
    demo_password = "zeppelin-demo-123"

    demo_scenarios = (
        {
            "organization": {
                "name": "Company A - Atlas Retail",
                "description": (
                    "Demo company with visible maturity evolution between two "
                    "assessment cycles."
                ),
                "age": 84,
                "type_name": "Retail SaaS",
                "type_description": "Retail software company with B2B SaaS products.",
                "size_name": "Medium organization",
            },
            "role": "Engineering Manager",
            "cycles": (
                {
                    "slug": "company-a-cycle-1",
                    "applied_date": datetime(2025, 8, 15, 10, 0, 0),
                    "profile": "company_a_cycle_1",
                },
                {
                    "slug": "company-a-cycle-2",
                    "applied_date": datetime(2026, 2, 15, 10, 0, 0),
                    "profile": "company_a_cycle_2",
                },
            ),
        },
        {
            "organization": {
                "name": "Company B - Beacon Health",
                "description": (
                    "Demo company with an intermediate profile to support "
                    "cross-company comparison."
                ),
                "age": 120,
                "type_name": "Digital Health Platform",
                "type_description": "Health technology company with digital service products.",
                "size_name": "Large organization",
            },
            "role": "Head of Engineering",
            "cycles": (
                {
                    "slug": "company-b-cycle-1",
                    "applied_date": datetime(2026, 1, 20, 10, 0, 0),
                    "profile": "company_b_cycle_1",
                },
            ),
        },
    )

    profile_stage_percentages = {
        "company_a_cycle_1": {
            "Agile R&D Organization": [30, 30, 60, 10, 30, 60, 30, 100, 10, 30],
            "Continuous Integration": [10, 0, 30, 10, 30, 0, 10, 30, 60, 10],
            "Continuous Deployment": [0, 10, 10, 30, 0, 10, 30, 0, 10, 30],
            "R&D as an Experiment System": [0, 0, 10, 30, 0, 10, 0, 30, 10, 0],
        },
        "company_a_cycle_2": {
            "Agile R&D Organization": [60, 100, 60, 60, 100, 60, 100, 60, 60, 100],
            "Continuous Integration": [60, 60, 100, 60, 100, 60, 60, 100, 60, 30],
            "Continuous Deployment": [30, 60, 60, 30, 60, 100, 60, 30, 60, 30],
            "R&D as an Experiment System": [30, 60, 30, 60, 30, 60, 100, 30, 60, 30],
        },
        "company_b_cycle_1": {
            "Agile R&D Organization": [60, 30, 60, 60, 30, 60, 100, 30, 60, 60],
            "Continuous Integration": [30, 60, 30, 60, 30, 60, 100, 30, 60, 30],
            "Continuous Deployment": [10, 30, 60, 30, 10, 60, 30, 10, 60, 30],
            "R&D as an Experiment System": [0, 10, 30, 30, 10, 30, 0, 10, 30, 60],
        },
    }

    level_notes = {
        0: "The practice is not adopted in the current operating model.",
        10: "The practice was attempted before, but is currently inconsistent or abandoned.",
        30: "The practice exists in some products, but is not shared as an organization-wide process.",
        60: "The practice is repeatable and standardized across teams.",
        100: "The practice is institutionalized and continuously reinforced.",
    }

    @transaction.atomic
    def handle(self, *args, **options):
        self.stdout.write(
            self.style.NOTICE(
                "Loading official questionnaire catalog and generating demo answers..."
            )
        )

        call_command("load_initial_questionnaire_data")

        adopted_levels = {
            level.percentage: level
            for level in AdoptedLevel.objects.order_by("percentage")
        }
        statements = list(
            Statement.objects.select_related("sth_stage").order_by("code")
        )
        if not statements:
            self.stdout.write(
                self.style.ERROR("No questionnaire statements were found.")
            )
            return

        demo_user = self._create_or_update_demo_user()
        organizations = self._create_or_update_demo_organizations()
        employees = self._create_or_update_demo_employees(organizations)

        self._clear_previous_demo_cycles(employees)

        created_questionnaires = []
        created_answers = 0
        previous_levels_by_org = defaultdict(dict)

        for scenario in self.demo_scenarios:
            organization_name = scenario["organization"]["name"]
            organization = organizations[organization_name]
            employee = employees[organization_name]

            for cycle in scenario["cycles"]:
                questionnaire = self._create_questionnaire(employee, cycle)
                created_questionnaires.append((organization, questionnaire))
                created_answers += self._create_answers_for_cycle(
                    organization=organization,
                    questionnaire=questionnaire,
                    statements=statements,
                    adopted_levels=adopted_levels,
                    profile_name=cycle["profile"],
                    previous_levels=previous_levels_by_org[organization_name],
                )

        self.stdout.write(self.style.SUCCESS("Demo dataset loaded successfully."))
        self.stdout.write(
            f"Demo user: {demo_user.username} / password: {self.demo_password}"
        )
        for organization, questionnaire in created_questionnaires:
            self.stdout.write(
                f"- {organization.name} -> questionnaire {questionnaire.id} ({questionnaire.applied_date:%Y-%m-%d})"
            )
        self.stdout.write(f"Total answers created: {created_answers}")

    def _create_or_update_demo_user(self):
        user, created = User.objects.get_or_create(
            username=self.demo_username,
            defaults={"email": self.demo_email},
        )
        changed = created
        if user.email != self.demo_email:
            user.email = self.demo_email
            changed = True
        if not user.check_password(self.demo_password):
            user.set_password(self.demo_password)
            changed = True
        if changed:
            user.save()
        return user

    def _create_or_update_demo_organizations(self):
        organizations = {}
        for scenario in self.demo_scenarios:
            data = scenario["organization"]
            organization_type, _ = OrganizationType.objects.get_or_create(
                name=data["type_name"],
                defaults={"description": data["type_description"]},
            )
            size, _ = Size.objects.get_or_create(name=data["size_name"])
            organization, _ = Organization.objects.update_or_create(
                name=data["name"],
                defaults={
                    "description": data["description"],
                    "age": data["age"],
                    "organization_type": organization_type,
                    "organization_size": size,
                },
            )
            organizations[data["name"]] = organization
        return organizations

    def _create_or_update_demo_employees(self, organizations):
        employees = {}
        for scenario in self.demo_scenarios:
            organization_name = scenario["organization"]["name"]
            organization = organizations[organization_name]
            employee, _ = Employee.objects.update_or_create(
                e_mail=self.demo_email,
                employee_organization=organization,
                defaults={"role": scenario["role"]},
            )
            employees[organization_name] = employee
        return employees

    def _clear_previous_demo_cycles(self, employees):
        demo_questionnaires = Questionnaire.objects.filter(
            employee_questionnaire__in=list(employees.values())
        )
        Answer.objects.filter(questionnaire_answer__in=demo_questionnaires).delete()
        demo_questionnaires.delete()

    def _create_questionnaire(self, employee, cycle):
        questionnaire = Questionnaire(
            applied_date=timezone.make_aware(cycle["applied_date"]),
            employee_questionnaire=employee,
        )
        file_name = f"{cycle['slug']}.txt"
        questionnaire.document.save(
            file_name,
            ContentFile(
                f"Demo questionnaire seed for {employee.employee_organization.name}".encode(
                    "utf-8"
                )
            ),
            save=False,
        )
        questionnaire.save()
        return questionnaire

    def _create_answers_for_cycle(
        self,
        organization,
        questionnaire,
        statements,
        adopted_levels,
        profile_name,
        previous_levels,
    ):
        created_answers = 0
        stage_counters = defaultdict(int)

        for statement in statements:
            stage_name = getattr(statement.sth_stage, "name", "") or "Unknown stage"
            percentage = self._resolve_percentage(
                profile_name,
                stage_name,
                stage_counters[stage_name],
            )
            adopted_level = adopted_levels[percentage]
            previous_percentage = previous_levels.get(statement.code)

            Answer.objects.create(
                questionnaire_answer=questionnaire,
                adopted_level_answer=adopted_level,
                statement_answer=statement,
                comment_answer=self._build_comment(
                    statement=statement,
                    stage_name=stage_name,
                    adopted_level=adopted_level,
                    previous_percentage=previous_percentage,
                ),
                organization_answer=organization,
            )

            previous_levels[statement.code] = percentage
            stage_counters[stage_name] += 1
            created_answers += 1

        return created_answers

    def _resolve_percentage(self, profile_name, stage_name, index):
        stage_pattern = self.profile_stage_percentages.get(profile_name, {}).get(
            stage_name,
            [30],
        )
        return stage_pattern[index % len(stage_pattern)]

    def _build_comment(self, statement, stage_name, adopted_level, previous_percentage):
        base_note = self.level_notes.get(
            adopted_level.percentage,
            "The practice is still being calibrated in this demo dataset.",
        )
        comment = f"{statement.code} in {stage_name}: {base_note}"

        if previous_percentage is None:
            return comment

        delta = adopted_level.percentage - previous_percentage
        if delta > 0:
            return f"{comment} Compared with the previous cycle, this practice improved by {delta} points."
        if delta < 0:
            return f"{comment} Compared with the previous cycle, this practice regressed by {abs(delta)} points."
        return f"{comment} The maturity level remained stable compared with the previous cycle."
