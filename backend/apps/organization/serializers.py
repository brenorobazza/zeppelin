from rest_framework import serializers
from .models import (
    OrganizationCategory,
    Size,
    OrganizationType,
    Region,
    State,
    Organization,
)

class OrganizationCategoryWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrganizationCategory
        exclude = ("polymorphic_ctype",)

class OrganizationCategoryReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = OrganizationCategory
        exclude = ("polymorphic_ctype",)


class SizeWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Size
        exclude = ("polymorphic_ctype",)

class SizeReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = Size
        exclude = ("polymorphic_ctype",)


class OrganizationTypeWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrganizationType
        exclude = ("polymorphic_ctype",)

class OrganizationTypeReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = OrganizationType
        exclude = ("polymorphic_ctype",)


class RegionWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Region
        exclude = ("polymorphic_ctype",)

class RegionReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = Region
        exclude = ("polymorphic_ctype",)


class StateWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = State
        exclude = ("polymorphic_ctype",)

class StateReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = State
        exclude = ("polymorphic_ctype",)


class OrganizationWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organization
        exclude = ("polymorphic_ctype",)

class OrganizationReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = Organization
        exclude = ("polymorphic_ctype",)

