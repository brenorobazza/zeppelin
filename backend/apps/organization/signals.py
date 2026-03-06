from .models import OrganizationCategory, Size, OrganizationType, Region, State, Organization
from django.db.models.signals import (
    pre_init,   post_init,
    pre_save,   post_save,
    pre_delete, post_delete,
    m2m_changed
)
from django.dispatch import receiver
from django.contrib.auth.models import Group

## Signals from OrganizationCategory
@receiver(pre_init, sender=OrganizationCategory)
def pre_init_organizationcategory(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=OrganizationCategory)
def post_init_organizationcategory(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=OrganizationCategory)
def pre_save_organizationcategory(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=OrganizationCategory)
def post_save_organizationcategory(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=OrganizationCategory)
def pre_delete_organizationcategory(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=OrganizationCategory)
def post_delete_organizationcategory(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=OrganizationCategory)
def m2m_changed_organizationcategory(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from Size
@receiver(pre_init, sender=Size)
def pre_init_size(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=Size)
def post_init_size(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=Size)
def pre_save_size(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=Size)
def post_save_size(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=Size)
def pre_delete_size(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=Size)
def post_delete_size(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=Size)
def m2m_changed_size(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from OrganizationType
@receiver(pre_init, sender=OrganizationType)
def pre_init_organizationtype(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=OrganizationType)
def post_init_organizationtype(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=OrganizationType)
def pre_save_organizationtype(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=OrganizationType)
def post_save_organizationtype(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=OrganizationType)
def pre_delete_organizationtype(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=OrganizationType)
def post_delete_organizationtype(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=OrganizationType)
def m2m_changed_organizationtype(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from Region
@receiver(pre_init, sender=Region)
def pre_init_region(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=Region)
def post_init_region(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=Region)
def pre_save_region(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=Region)
def post_save_region(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=Region)
def pre_delete_region(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=Region)
def post_delete_region(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=Region)
def m2m_changed_region(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from State
@receiver(pre_init, sender=State)
def pre_init_state(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=State)
def post_init_state(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=State)
def pre_save_state(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=State)
def post_save_state(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=State)
def pre_delete_state(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=State)
def post_delete_state(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=State)
def m2m_changed_state(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from Organization
@receiver(pre_init, sender=Organization)
def pre_init_organization(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=Organization)
def post_init_organization(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=Organization)
def pre_save_organization(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=Organization)
def post_save_organization(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=Organization)
def pre_delete_organization(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=Organization)
def post_delete_organization(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=Organization)
def m2m_changed_organization(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass

