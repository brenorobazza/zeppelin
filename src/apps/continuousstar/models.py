from django.db import models

from apps.core.models import Base


class ContinuousPhase(Base):
    """"""

    class Meta:
        db_table = "continuous_star_continuous_phase"


class ContinuousActivity(Base):
    """"""

    continuous_phase = models.ForeignKey(
        ContinuousPhase,
        blank=True,
        null=True,
        on_delete=models.CASCADE,
        related_name="continuous_phase_%(class)s",
    )

    class Meta:
        db_table = "continuous_star_continuous_activity"
