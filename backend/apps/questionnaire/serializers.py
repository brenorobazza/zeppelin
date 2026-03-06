from rest_framework import serializers
from .models import (
    AdoptedLevel,
    Statement,
    FeedbackQuestionnaire,
    Questionnaire,
    QuestionnaireExcel,
    Answer,
)

class AdoptedLevelWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdoptedLevel
        exclude = ("polymorphic_ctype",)

class AdoptedLevelReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = AdoptedLevel
        exclude = ("polymorphic_ctype",)


class StatementWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Statement
        exclude = ("polymorphic_ctype",)

class StatementReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = Statement
        exclude = ("polymorphic_ctype",)


class FeedbackQuestionnaireWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = FeedbackQuestionnaire
        exclude = ("polymorphic_ctype",)

class FeedbackQuestionnaireReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = FeedbackQuestionnaire
        exclude = ("polymorphic_ctype",)


class QuestionnaireWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Questionnaire
        exclude = ("polymorphic_ctype",)

class QuestionnaireReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = Questionnaire
        exclude = ("polymorphic_ctype",)


class QuestionnaireExcelWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = QuestionnaireExcel
        exclude = ("polymorphic_ctype",)

class QuestionnaireExcelReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = QuestionnaireExcel
        exclude = ("polymorphic_ctype",)


class AnswerWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Answer
        exclude = ("polymorphic_ctype",)

class AnswerReadSerializer(serializers.ModelSerializer):
    class Meta:
        depth = 1
        model = Answer
        exclude = ("polymorphic_ctype",)

