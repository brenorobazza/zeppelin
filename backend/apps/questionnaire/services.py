from pprint import pprint
from django.conf import settings
from .models import Statement, AdoptedLevel, Answer, Questionnaire
import xlrd 
from apps.organization.services import OrganizationService, OrganizationGoogleFormsService
from apps.employee.services import EmployeeService, EmployeenGoogleFormsService
import hashlib

class QuestionnaireBase ():

    def __init__(self):
        self.statements = {}
        self.adoption_levels = {}
        count = 0 
        for statement in Statement.objects.all():
            count = count + 1
            hash = hashlib.md5(statement.statement.strip().encode('utf-8'))
            hash = hash.hexdigest()
            self.statements[hash] = statement

        for adoption_level in AdoptedLevel.objects.all():
            self.adoption_levels[adoption_level.name]=adoption_level

class QuestionnaireGoogleForms(QuestionnaireBase):
    
    def process_data(self, sheet,organization,line):
        self.organization = organization
        self.current_line = line
        self.sheet = sheet
        
        for column in range (18, 89):
            #response
            adoption_level = self.sheet.cell_value(self.current_line, column).strip()
           
            value = self.sheet.cell_value(0, column).strip()
            
            index = value.find(".")
            count = len (value)
            
            statement_google = value[index+1: count]
            print (statement_google)
            hash = hashlib.md5(statement_google.strip().encode('utf-8'))
            hash = hash.hexdigest()
            
            adoption_level = self.adoption_levels[adoption_level]
            statement = self.statements [hash]   

            answer = Answer(organization=self.organization,
                                adopted_level=adoption_level,
                                statement= statement)
            answer.save()
           
class QuestionnaireFile (QuestionnaireBase):
    
   
    def process_data(self, instance):
        self.questionnarie = instance
        self.wb = xlrd.open_workbook(settings.MEDIA_ROOT+"/"+str(instance.document)) 
        self.__process_assertives()
    
    def __process_assertives(self):
        pprint ("Agile answer")
        self.agile_assertives()
        pprint ("CI Assertives")
        self.ci_assertives()
        pprint ("CD Assertives")
        self.cd_assertives()
        pprint ("P&D Assertives")
        self.pd_assertives()
    
    def __assertives(self, sheet_id):
        
        sheet = self.wb.sheet_by_index(sheet_id)

        for line in range(6,sheet.nrows): 

            code = sheet.cell_value(line, 1).strip()
            if code in self.statements:
                
                adopted_level = sheet.cell_value(line, 3).strip()
                comment = sheet.cell_value(line, 4).strip()
                statement = self.statements[code]
                adopted_level = self.adoption_levels[adopted_level]

                answer = Answer(questionnaire=self.questionnarie,
                                adopted_level=adopted_level,
                                statement= statement,
                                comment= comment)
                answer.save()
                
        
    def agile_assertives(self):
        self.__assertives(5)

    def ci_assertives(self):
        self.__assertives(6)
    
    def cd_assertives(self):
        self.__assertives(7)
    
    def pd_assertives(self):
        self.__assertives(8)



class QuestionnaireExcelService():

    def __init__(self):
        self.organization_service = OrganizationService() 
        self.employee_service = EmployeeService()
        self.questionnaire_file = QuestionnaireFile()
    
    def process_data(self, instance):
    
        organization = self.organization_service.process_data(instance)
    
        self.employee_service.process_data(instance,organization)
    
        self.questionnaire_file.process_data(instance)
    
class QuestionnaireGoogleFormsService():
    
    def __init__(self):
        self.organization_service = OrganizationGoogleFormsService() 
        
        self.employee_service = EmployeenGoogleFormsService()

        self.questionnaire_file = QuestionnaireGoogleForms()
        
        self.practices = {}

    def process_data(self, instance):

        self.wb = xlrd.open_workbook(settings.MEDIA_ROOT+"/"+str(instance.document)) 
        
        self.sheet = self.wb.sheet_by_index(0)
        
        '''
        # Processando para saber aonde estão os index
        for column in range (18, 89):
            value = self.sheet.cell_value(0, column).strip()
            index = value.find(".")
            count = len (value)
            statement = value[index+1: count]
            hash = hashlib.md5(statement.strip().encode('utf-8'))
            hash = str(hash)
            self.practices[hash] = hash
        '''   
        
        # Processando as empresas e os empregados
        for line in range(1, self.sheet.nrows):     
            
            organization = self.organization_service.process_data(self.sheet,instance,line)
               
            self.employee_service.process_data(self.sheet,instance,line,organization)
            
            self.questionnaire_file.process_data(self.sheet,organization,line)
        
