from rest_framework import serializers
from .models import (
    Category,
    Element,
)

class DimensionWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        exclude = ("polymorphic_ctype",)

class DimensionReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = Category
        exclude = ("polymorphic_ctype",)


class ElementWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Element
        exclude = ("polymorphic_ctype",)

class ElementReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = Element
        exclude = ("polymorphic_ctype",)

