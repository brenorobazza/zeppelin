from django.db import models
from django.utils.translation import gettext_lazy as _
from apps.core.models import Base, Historical
from apps.organization.models import Organization

class AcademicDegreeCategory(Base):
    """"""

    class Meta:
        db_table = 'academic_degree_category'

class AcademicDegree(Base):
    """"""
    academic_degree_category = models.ForeignKey(AcademicDegreeCategory, blank=True, null=True, on_delete=models.CASCADE, related_name="academic_degree_category_%(class)s")

    class Meta:
        db_table = 'academic_degree'

class AcademicDegreeStatus(Base):
    """"""

    class Meta:
        db_table = 'academic_degree_status'

class KnwoledgeLevel(Base):
    """"""

    value = models.DecimalField(max_digits=14, decimal_places=2, null=True, blank=True)



    class Meta:
        db_table = 'knowledge_level'

class ExperienceLevel(Base):
    """"""

    value = models.DecimalField(max_digits=14, decimal_places=2, null=True, blank=True)



    class Meta:
        db_table = 'experience_level'

class Position(Base):
    """"""

    class Meta:
        db_table = 'position'

class Employee(Base):
    """"""

    e_mail = models.EmailField(null=True, blank=True)
    role = models.CharField(max_length=300, null=True, blank=True)


    employee_position = models.ForeignKey(Position, blank=True, null=True, on_delete=models.CASCADE, related_name="position_%(class)s")
    employee_organization = models.ForeignKey('apps_organization.Organization', blank=True, null=True, on_delete=models.CASCADE, related_name="employee_organization_%(class)s")

    class Meta:
        db_table = 'employee'

class EmployeeKnowledge(Historical):
    """"""



    academic_degree = models.ForeignKey(AcademicDegree, blank=True, null=True, on_delete=models.CASCADE, related_name="academic_degree_%(class)s")
    academic_degree_status = models.ForeignKey(AcademicDegreeStatus, blank=True, null=True, on_delete=models.CASCADE, related_name="academic_degree_status_%(class)s")
    employee = models.ForeignKey(Employee, blank=True, null=True, on_delete=models.CASCADE, related_name="employee_%(class)s")

    class Meta:
        db_table = 'employee_knowledge'

class SthStageKnwoledgeLevel(Historical):
    """"""



    stage = models.ForeignKey('apps_sth.Stage', blank=True, null=True, on_delete=models.CASCADE, related_name="stage_%(class)s")
    Knwoledge_level = models.ForeignKey(KnwoledgeLevel, blank=True, null=True, on_delete=models.CASCADE, related_name="knwoledge_level_%(class)s")
    employee = models.ForeignKey(Employee, blank=True, null=True, on_delete=models.CASCADE, related_name="employee_%(class)s")

    class Meta:
        db_table = 'sth_stage_knwoledge_level'


class SthStageExperienceLevel (Base):

    stage_experience_level = models.ForeignKey('apps_sth.Stage', on_delete=models.CASCADE,help_text= "employee's knowledge")
    experience_level = models.ForeignKey(ExperienceLevel, on_delete=models.CASCADE,help_text= "employee's knowledge")
    employee_experience_level = models.ForeignKey(Employee, on_delete=models.CASCADE,help_text= "employee's knowledge", related_name= "employee_experience_level")

    class meta:
        db_table = 'sth_stage_experience_level'
    
    def __str__(self):
        return str(self.employee) +"-"+str(self.stage) +"-"+ str(self.experience_level)




class Team(Base):
    name = models.CharField(max_length=200, help_text= "team's name")
    description = models.TextField(help_text= "team's description")
    organization_team = models.ForeignKey(Organization, on_delete=models.CASCADE,help_text= "organization")
    responsible = models.ForeignKey(Employee, on_delete=models.CASCADE,help_text= "Employee")


