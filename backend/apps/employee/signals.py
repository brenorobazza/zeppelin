from .models import AcademicDegreeCategory, AcademicDegree, AcademicDegreeStatus, KnwoledgeLevel, ExperienceLevel, Position, Employee, EmployeeKnowledge, SthStageKnwoledgeLevel, SthStageExperienceLevel, Team
from django.db.models.signals import (
    pre_init,   post_init,
    pre_save,   post_save,
    pre_delete, post_delete,
    m2m_changed
)
from django.dispatch import receiver
from django.contrib.auth.models import Group

## Signals from AcademicDegreeCategory
@receiver(pre_init, sender=AcademicDegreeCategory)
def pre_init_academicdegreecategory(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=AcademicDegreeCategory)
def post_init_academicdegreecategory(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=AcademicDegreeCategory)
def pre_save_academicdegreecategory(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=AcademicDegreeCategory)
def post_save_academicdegreecategory(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=AcademicDegreeCategory)
def pre_delete_academicdegreecategory(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=AcademicDegreeCategory)
def post_delete_academicdegreecategory(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=AcademicDegreeCategory)
def m2m_changed_academicdegreecategory(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from AcademicDegree
@receiver(pre_init, sender=AcademicDegree)
def pre_init_academicdegree(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=AcademicDegree)
def post_init_academicdegree(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=AcademicDegree)
def pre_save_academicdegree(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=AcademicDegree)
def post_save_academicdegree(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=AcademicDegree)
def pre_delete_academicdegree(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=AcademicDegree)
def post_delete_academicdegree(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=AcademicDegree)
def m2m_changed_academicdegree(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from AcademicDegreeStatus
@receiver(pre_init, sender=AcademicDegreeStatus)
def pre_init_academicdegreestatus(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=AcademicDegreeStatus)
def post_init_academicdegreestatus(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=AcademicDegreeStatus)
def pre_save_academicdegreestatus(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=AcademicDegreeStatus)
def post_save_academicdegreestatus(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=AcademicDegreeStatus)
def pre_delete_academicdegreestatus(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=AcademicDegreeStatus)
def post_delete_academicdegreestatus(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=AcademicDegreeStatus)
def m2m_changed_academicdegreestatus(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from KnwoledgeLevel
@receiver(pre_init, sender=KnwoledgeLevel)
def pre_init_knwoledgelevel(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=KnwoledgeLevel)
def post_init_knwoledgelevel(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=KnwoledgeLevel)
def pre_save_knwoledgelevel(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=KnwoledgeLevel)
def post_save_knwoledgelevel(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=KnwoledgeLevel)
def pre_delete_knwoledgelevel(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=KnwoledgeLevel)
def post_delete_knwoledgelevel(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=KnwoledgeLevel)
def m2m_changed_knwoledgelevel(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from ExperienceLevel
@receiver(pre_init, sender=ExperienceLevel)
def pre_init_experiencelevel(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=ExperienceLevel)
def post_init_experiencelevel(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=ExperienceLevel)
def pre_save_experiencelevel(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=ExperienceLevel)
def post_save_experiencelevel(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=ExperienceLevel)
def pre_delete_experiencelevel(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=ExperienceLevel)
def post_delete_experiencelevel(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=ExperienceLevel)
def m2m_changed_experiencelevel(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from Position
@receiver(pre_init, sender=Position)
def pre_init_position(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=Position)
def post_init_position(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=Position)
def pre_save_position(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=Position)
def post_save_position(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=Position)
def pre_delete_position(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=Position)
def post_delete_position(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=Position)
def m2m_changed_position(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from Employee
@receiver(pre_init, sender=Employee)
def pre_init_employee(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=Employee)
def post_init_employee(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=Employee)
def pre_save_employee(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=Employee)
def post_save_employee(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=Employee)
def pre_delete_employee(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=Employee)
def post_delete_employee(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=Employee)
def m2m_changed_employee(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from EmployeeKnowledge
@receiver(pre_init, sender=EmployeeKnowledge)
def pre_init_employeeknowledge(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=EmployeeKnowledge)
def post_init_employeeknowledge(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=EmployeeKnowledge)
def pre_save_employeeknowledge(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=EmployeeKnowledge)
def post_save_employeeknowledge(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=EmployeeKnowledge)
def pre_delete_employeeknowledge(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=EmployeeKnowledge)
def post_delete_employeeknowledge(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=EmployeeKnowledge)
def m2m_changed_employeeknowledge(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from SthStageKnwoledgeLevel
@receiver(pre_init, sender=SthStageKnwoledgeLevel)
def pre_init_sthstageknwoledgelevel(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=SthStageKnwoledgeLevel)
def post_init_sthstageknwoledgelevel(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=SthStageKnwoledgeLevel)
def pre_save_sthstageknwoledgelevel(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=SthStageKnwoledgeLevel)
def post_save_sthstageknwoledgelevel(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=SthStageKnwoledgeLevel)
def pre_delete_sthstageknwoledgelevel(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=SthStageKnwoledgeLevel)
def post_delete_sthstageknwoledgelevel(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=SthStageKnwoledgeLevel)
def m2m_changed_sthstageknwoledgelevel(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from SthStageExperienceLevel
@receiver(pre_init, sender=SthStageExperienceLevel)
def pre_init_sthstageexperiencelevel(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=SthStageExperienceLevel)
def post_init_sthstageexperiencelevel(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=SthStageExperienceLevel)
def pre_save_sthstageexperiencelevel(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=SthStageExperienceLevel)
def post_save_sthstageexperiencelevel(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=SthStageExperienceLevel)
def pre_delete_sthstageexperiencelevel(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=SthStageExperienceLevel)
def post_delete_sthstageexperiencelevel(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=SthStageExperienceLevel)
def m2m_changed_sthstageexperiencelevel(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from Team
@receiver(pre_init, sender=Team)
def pre_init_team(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=Team)
def post_init_team(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=Team)
def pre_save_team(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=Team)
def post_save_team(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=Team)
def pre_delete_team(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=Team)
def post_delete_team(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=Team)
def m2m_changed_team(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass

