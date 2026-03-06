from .models import Historical, Base
from django.db.models.signals import (
    pre_init,   post_init,
    pre_save,   post_save,
    pre_delete, post_delete,
    m2m_changed
)
from django.dispatch import receiver
from django.contrib.auth.models import Group

## Signals from Historical
@receiver(pre_init, sender=Historical)
def pre_init_historical(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=Historical)
def post_init_historical(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=Historical)
def pre_save_historical(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=Historical)
def post_save_historical(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=Historical)
def pre_delete_historical(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=Historical)
def post_delete_historical(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=Historical)
def m2m_changed_historical(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass


## Signals from Base
@receiver(pre_init, sender=Base)
def pre_init_base(sender, *args, **kwargs):
    pass

@receiver(post_init, sender=Base)
def post_init_base(sender, instance, **kwargs):
    pass

@receiver(pre_save, sender=Base)
def pre_save_base(sender, instance, raw, using, update_fields, **kwargs):
    pass

@receiver(post_save, sender=Base)
def post_save_base(sender, instance, created, raw, using, update_fields, **kwargs):
    pass

@receiver(pre_delete, sender=Base)
def pre_delete_base(sender, instance, using, **kwargs):
    pass

@receiver(post_delete, sender=Base)
def post_delete_base(sender, instance, using, **kwargs):
    pass

@receiver(m2m_changed, sender=Base)
def m2m_changed_base(sender, instance, action, reverse, model, pk_set, using, **kwargs):
    pass

