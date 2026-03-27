from collections import defaultdict

from django.core.management.base import BaseCommand
from django.db import transaction

from apps.organization.models import Organization


def normalize_organization_name(value):
    return " ".join((value or "").split()).casefold()


class Command(BaseCommand):
    help = (
        "Merge duplicate organizations by normalized name, reassigning related "
        "records to the canonical organization with the lowest id."
    )

    def add_arguments(self, parser):
        parser.add_argument(
            "--dry-run",
            action="store_true",
            help="Show the duplicates that would be merged without changing the database.",
        )

    @transaction.atomic
    def handle(self, *args, **options):
        dry_run = options["dry_run"]
        organizations = Organization.objects.all().order_by("id")
        grouped_organizations = defaultdict(list)

        for organization in organizations:
            normalized_name = normalize_organization_name(organization.name)
            if normalized_name:
                grouped_organizations[normalized_name].append(organization)

        duplicate_groups = [
            group for group in grouped_organizations.values() if len(group) > 1
        ]

        if not duplicate_groups:
            self.stdout.write(self.style.SUCCESS("No duplicate organizations found."))
            return

        total_merged = 0
        for group in duplicate_groups:
            canonical = group[0]
            duplicates = group[1:]
            duplicate_ids = [organization.id for organization in duplicates]

            self.stdout.write(
                f"Canonical organization {canonical.id} ({canonical.name}) <- duplicates {duplicate_ids}"
            )

            if dry_run:
                continue

            for duplicate in duplicates:
                self._merge_related_records(canonical, duplicate)
                self._fill_missing_fields(canonical, duplicate)
                duplicate.delete()
                total_merged += 1

        if dry_run:
            self.stdout.write(
                self.style.WARNING(
                    f"Dry run complete. {sum(len(group) - 1 for group in duplicate_groups)} duplicates would be merged."
                )
            )
            transaction.set_rollback(True)
            return

        self.stdout.write(
            self.style.SUCCESS(
                f"Finished merging {total_merged} duplicate organizations."
            )
        )

    def _merge_related_records(self, canonical, duplicate):
        for relation in Organization._meta.related_objects:
            field = relation.field

            if not field.many_to_one and not field.one_to_one:
                continue

            relation.related_model.objects.filter(**{field.name: duplicate}).update(
                **{field.name: canonical}
            )

    def _fill_missing_fields(self, canonical, duplicate):
        updated_fields = []

        for field_name in [
            "description",
            "organization_size",
            "organization_type",
            "age",
            "location",
        ]:
            canonical_value = getattr(canonical, field_name)
            duplicate_value = getattr(duplicate, field_name)

            if canonical_value or not duplicate_value:
                continue

            setattr(canonical, field_name, duplicate_value)
            updated_fields.append(field_name)

        if updated_fields:
            canonical.save(update_fields=updated_fields)
