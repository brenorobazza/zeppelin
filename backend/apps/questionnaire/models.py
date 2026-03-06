from django.core.exceptions import ValidationError
from django.db import models
from apps.sth.models import Stage
from apps.practitionerseye.models import Element
from apps.cseframework.models import Process
from apps.core.models import Base
from apps.organization.models import Organization 
from apps.employee.models import  Employee
from apps.continuousstar.models import ContinuousActivity

class AdoptedLevel(Base):

    """
    Represents an adopted level`.
    """

    name = models.CharField(max_length=200,help_text= "name")
    description = models.TextField(help_text= "description")
    percentage = models.IntegerField(help_text= "percentage")

    class meta:
        db_table = 'adopted_level'
    
    def __str__(self):
        return self.name

    
class Statement(Base):

    """
    Represents a statement related to :model:`sth.stage`, related to :model:`practitioners_eye.element` and related to :model:`cse_framework.process`
    """

    code = models.CharField(max_length=200, null=True, blank=True)
    text = models.TextField()
    sth_stage = models.ForeignKey(Stage, on_delete=models.CASCADE,null=True, blank=True,related_name="questionnarie_sth_stage%(class)s")
    pe_element = models.ForeignKey(Element, on_delete=models.CASCADE,null=True, blank=True,related_name="questionnarie_pe_element%(class)s")
    fcse_processes = models.ManyToManyField(Process)
    continuous_activity = models.ForeignKey(ContinuousActivity, on_delete=models.CASCADE,null=True, blank=True,related_name="continuous_activity_%(class)s")

    class meta:
        db_table = 'statement'
    
    def __str__(self):
        return self.code + "-"+ self.statement

class FeedbackQuestionnaire(Base):
    collected_date = models.DateTimeField(auto_now_add=True)
    feedback_date = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return str(self.feedback_date)

class Questionnaire(Base):
    
    """
    Represents a Questionnaire related to :model:`questionnaire.employee`.
    """
    
    applied_date = models.DateTimeField(null=True, blank=True)
    document = models.FileField(upload_to='documents/%Y/%m/%d/')
    uploaded_at = models.DateTimeField(auto_now_add=True)
    employee_questionnaire = models.ForeignKey(Employee, on_delete=models.CASCADE, null=True, blank=True,related_name="questionnaire_questionnaire_%(class)s")
   
    class meta:
        db_table = 'questionnaire'
    
    def __str__(self):
       return self.document.name


class QuestionnaireExcel(Questionnaire):

    feedback_questionnaire = models.ForeignKey(FeedbackQuestionnaire, on_delete=models.CASCADE, null=True, blank=True)


class QuestionnaireGoogleForms(Questionnaire):
    pass

class Answer(Base):

    """
    Represents a answer of questionnaire related to :model:`questionnaire.Questionnaire`, related to :model:`questionnaire.AdoptedLevel` and :model:`questionnaire.Statement`.
    """

    questionnaire_answer = models.ForeignKey(Questionnaire, on_delete=models.CASCADE, blank=True, null=True)
    adopted_level_answer = models.ForeignKey(AdoptedLevel, on_delete=models.CASCADE)
    statement_answer = models.ForeignKey(Statement, on_delete=models.CASCADE)
    comment_answer = models.TextField()
    organization_answer = models.ForeignKey(Organization, on_delete=models.CASCADE)
    
   

    class meta:
        db_table = 'answer'
    
    def __str__(self):
        return self.statement.code 
