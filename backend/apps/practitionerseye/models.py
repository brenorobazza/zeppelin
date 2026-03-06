from django.db import models
from apps.core.models import Base

class Category (Base):

    """
    Represents a category of PE.
    """

    name = models.CharField(max_length=200, help_text= "Category's name", unique=True)
    description = models.TextField(help_text= "Category's description")

    class meta:
        db_table = 'practitioners_eye_category'

    def __str__(self):
        """ String para representar o category"""
        return self.name

class Element (Base):

    """
    Represents a element of PE, related to :model:`practitioners_eye.category`.
    """

    name = models.CharField(max_length=200,help_text= "Element's name")
    description = models.TextField(help_text= "Element's description")
    dimension = models.ForeignKey(Category, on_delete=models.CASCADE,help_text= "Element's category")

    class meta:
        db_table = 'practitioners_eye_element'
        ordering = ['dimension.name','name']
    def __str__(self):
        """ String para representar o element"""
        return self.dimension.name +" - "+self.name