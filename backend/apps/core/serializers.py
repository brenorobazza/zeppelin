from rest_framework import serializers
from .models import (
    Historical,
    Base,
)

class HistoricalWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Historical
        

class HistoricalReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = Historical
        


class BaseWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Base
        

class BaseReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = Base
        

