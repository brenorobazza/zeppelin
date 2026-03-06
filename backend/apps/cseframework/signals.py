from .models import Process
from django.db.models.signals import (
    pre_init,   post_init,
    pre_save,   post_save,
    pre_delete, post_delete,
    m2m_changed
)
from django.dispatch import receiver
from django.contrib.auth.models import Group

## Signals from Process
@receiver(pre_init, sender=Process)
def pre_init_process(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=Process)
def post_init_process(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=Process)
def pre_save_process(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=Process)
def post_save_process(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=Process)
def pre_delete_process(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=Process)
def post_delete_process(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=Process)
def m2m_changed_process(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass

