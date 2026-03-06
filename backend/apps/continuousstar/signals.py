from .models import ContinuousPhase, ContinuousActivity
from django.db.models.signals import (
    pre_init,   post_init,
    pre_save,   post_save,
    pre_delete, post_delete,
    m2m_changed
)
from django.dispatch import receiver
from django.contrib.auth.models import Group

## Signals from ContinuousPhase
@receiver(pre_init, sender=ContinuousPhase)
def pre_init_continuousphase(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=ContinuousPhase)
def post_init_continuousphase(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=ContinuousPhase)
def pre_save_continuousphase(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=ContinuousPhase)
def post_save_continuousphase(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=ContinuousPhase)
def pre_delete_continuousphase(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=ContinuousPhase)
def post_delete_continuousphase(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=ContinuousPhase)
def m2m_changed_continuousphase(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from ContinuousActivity
@receiver(pre_init, sender=ContinuousActivity)
def pre_init_continuousactivity(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=ContinuousActivity)
def post_init_continuousactivity(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=ContinuousActivity)
def pre_save_continuousactivity(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=ContinuousActivity)
def post_save_continuousactivity(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=ContinuousActivity)
def pre_delete_continuousactivity(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=ContinuousActivity)
def post_delete_continuousactivity(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=ContinuousActivity)
def m2m_changed_continuousactivity(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass

