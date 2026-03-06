from django.db import models
from apps.core.models import Base

class Stage (Base):

    """
    Represents a stage of StH.
    """

    class meta:
        db_table = 'sth_stage'
        ordering = ['name']

    def __str__(self):
        """ String para representar o stage"""
        return self.name
