from .models import Stage
from django.db.models.signals import (
    pre_init,   post_init,
    pre_save,   post_save,
    pre_delete, post_delete,
    m2m_changed
)
from django.dispatch import receiver
from django.contrib.auth.models import Group

## Signals from Stage
@receiver(pre_init, sender=Stage)
def pre_init_stage(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=Stage)
def post_init_stage(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=Stage)
def pre_save_stage(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=Stage)
def post_save_stage(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=Stage)
def pre_delete_stage(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=Stage)
def post_delete_stage(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=Stage)
def m2m_changed_stage(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass

