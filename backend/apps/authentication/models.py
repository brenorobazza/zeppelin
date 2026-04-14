from django.conf import settings
from django.db import models
from apps.organization.models import Organization


class UserOrganizationPreference(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="organization_preference",
    )
    current_organization = models.ForeignKey(
        Organization,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="current_preferred_by_users",
    )

    class Meta:
        db_table = "user_organization_preference"
