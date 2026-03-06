from rest_framework import serializers
from .models import (
    ContinuousPhase,
    ContinuousActivity,
)

class ContinuousPhaseWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = ContinuousPhase
        exclude = ("polymorphic_ctype",)

class ContinuousPhaseReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = ContinuousPhase
        exclude = ("polymorphic_ctype",)


class ContinuousActivityWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = ContinuousActivity
        exclude = ("polymorphic_ctype",)

class ContinuousActivityReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = ContinuousActivity
        exclude = ("polymorphic_ctype",)

