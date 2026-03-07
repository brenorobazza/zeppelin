from django.db import models
from polymorphic.models import PolymorphicModel


class Historical(PolymorphicModel):
    """"""

    created_at = models.DateTimeField(auto_now_add=True)  # melhor que blank=True
    modified_at = models.DateTimeField(auto_now=True)

    class Meta:
        # db_table = 'historical'
        abstract = True


class Base(PolymorphicModel):
    """"""

    name = models.CharField(max_length=300, null=True, blank=True)
    description = models.CharField(max_length=300, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)  # melhor que blank=True
    modified_at = models.DateTimeField(auto_now=True)

    class Meta:
        # db_table = 'base'
        abstract = True
