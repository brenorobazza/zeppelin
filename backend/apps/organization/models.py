from operator import truediv
from django.db import models
from apps.core.models import Base

class OrganizationCategory(Base):
    name = models.CharField(max_length=200, help_text= "organization type's name", unique=True)

    class meta:
        db_table = 'organization_category'

    def __str__(self):
        return self.name


class Size(Base):
    """
    Represents a Size of organization.
    """

    name = models.CharField(max_length=200, help_text= "organization type's name", unique=True)
    
    class meta:
        db_table = 'size'

    def __str__(self):
        
        return self.name

class OrganizationType(Base):
    """
    Represents a type of organization.
    """

    name = models.CharField(max_length=200, help_text= "organization type's name", unique=True)
    description = models.TextField(help_text= "organization type's description")

    category_organization_type = models.ForeignKey(OrganizationCategory, on_delete=models.CASCADE,help_text= "category",null=True, blank=True)

    class meta:
        db_table = 'organization_type'

    def __str__(self):
        return self.name

class Region(Base):
    name = models.CharField(max_length=200, help_text= "Region", unique=True)


    class meta:
        ordering = ['name']
    
    def __str__(self):
        
        return self.name


class State(Base):
    name = models.CharField(max_length=200, help_text= "State", unique=True)
    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)
    
    region_state = models.ForeignKey(Region, on_delete=models.CASCADE,help_text= "region",null=True, blank=True)
    
    class meta:
        db_table = 'location'
        ordering = ['name']

    def __str__(self):
        
        return self.name


class Organization(Base):

    """
    Represents a organization.
    """

    name = models.CharField(max_length=200, help_text= "organization's name")
    description = models.TextField(help_text= "organization's description", blank=True, null=True)
    organization_size = models.ForeignKey(Size, on_delete=models.CASCADE,help_text= "organization size",null=True, blank=True)
    organization_type = models.ForeignKey(OrganizationType, on_delete=models.CASCADE,help_text= "organization type",null=True, blank=True)
    age = models.IntegerField(help_text= "organization's age",blank=True, null=True)
    location = models.ForeignKey(State, on_delete=models.CASCADE,help_text= "location",null=True, blank=True)
    
    class meta:
        db_table = 'organization'

    def __str__(self):
        
        return self.name
