from django.db import models
from django.utils.translation import gettext_lazy as _
from polymorphic.models import PolymorphicModel
from apps.core.models import Base


class Process(Base):
    """"""

    class Meta:
        db_table = 'fcse_process'

