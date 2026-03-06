from django.conf import settings
from .models import AcademicDegree, AcademicDegreeStatus, KnwoledgeLevel, ExperienceLevel, EmployeeKnowledge, Employee, Position, SthStageKnwoledgeLevel, SthStageExperienceLevel
from apps.sth.models import Stage
import xlrd 


class EmployeeServiceBase():

    def __init__(self):
        self.academic_degrees = {}
        self.academic_degrees_status = {}
        self.knwoledge_levels = {}
        self.experience_levels = {}
        self.stages = {}
        
        for academic_degree in AcademicDegree.objects.all():
            self.academic_degrees[academic_degree.name] = academic_degree

        for academic_degree_status in AcademicDegreeStatus.objects.all():
            self.academic_degrees_status[academic_degree_status.name]=academic_degree_status

        for knwoledge_level in KnwoledgeLevel.objects.all():
            self.knwoledge_levels[knwoledge_level.name]=knwoledge_level
        
        for experience_level in ExperienceLevel.objects.all():
            self.experience_levels[experience_level.name]=experience_level
        
        for stage in Stage.objects.all():
            self.stages[stage.name] = stage

    

class EmployeeService (EmployeeServiceBase):

    
    
    def process_data(self, instance, organization):
        
        self.questionnarie = instance
        self.wb = xlrd.open_workbook(settings.MEDIA_ROOT+"/"+str(instance.document)) 
        self.sheet = self.wb.sheet_by_index(4)
        self.organization = organization
        
        self.__create_employee()
        self.__academic_degree()
        self.__knowledge_level()
        self.__experience_level()

        self.questionnarie.employee = self.employee
        self.questionnarie.save()
        
    def __create_employee(self):

        employee_name = self.sheet.cell_value(8, 2).strip()
        employee_email = self.sheet.cell_value(9, 2).strip()

        employee = Employee.objects.filter(email=employee_email)
        if len(employee) == 0:
            employee = Employee(name=employee_name, email=employee_email, organization=self.organization)
            employee.save()
        
        else:
            employee = employee[0]

        self.employee = employee
    
    def __academic_degree(self):
        
        academic_degree = self.sheet.cell_value(10, 2).strip()
        academic_degree_status = self.sheet.cell_value(12, 2).strip()

        academic_degree = self.academic_degrees[academic_degree]
        academic_degree_status = self.academic_degrees_status[academic_degree_status]


        self.employee_knowledge = EmployeeKnowledge(academic_degree=academic_degree,academic_degree_status=academic_degree_status,employee=self.employee)
        self.employee_knowledge.save()

    
    def __knowledge_level(self):

        for line in range(17,21): 
            stage = self.sheet.cell_value(line, 1).strip()
            knwoledge_level = self.sheet.cell_value(line, 2).strip()

            stage = self.stages[stage]
            knwoledge_level = self.knwoledge_levels[knwoledge_level]

            sth_stage_knwoledge_level = SthStageKnwoledgeLevel(stage=stage,knwoledge_level=knwoledge_level,employee_knowledge=self.employee_knowledge)
            sth_stage_knwoledge_level.save()
        
    def __experience_level(self):

        for line in range(24,28): 
            
            stage = self.sheet.cell_value(line, 1).strip()
            experience_level = self.sheet.cell_value(line, 2).strip()

            stage = self.stages[stage]
            experience_level = self.experience_levels[experience_level]

            sth_stage_knwoledge_level = SthStageExperienceLevel(stage=stage,experience_level=experience_level,employee_knowledge=self.employee_knowledge)
            sth_stage_knwoledge_level.save()


class EmployeenGoogleFormsService(EmployeeServiceBase):

    def process_data(self, sheet, instance, line, organization ):
        
        self.questionnarie = instance
        self.organization = organization
        self.current_line = line
        self.sheet = sheet

        self.positions = {}

        for position in Position.objects.all():
            self.positions[position.name] = position

        self.__create_employee()
        self.__academic_degree()
        self.__position()
        
        self.__knowledge_level()
        self.__experience_level()

        instance.employee = self.employee
        instance.save()


    def __position(self):
        
        position_sheet = self.sheet.cell_value(self.current_line, 9).strip()
        position = None
        
        if position_sheet not in self.positions:
            position = Position()
            position.name = position_sheet
            position.save()
        
        else:
            position = self.positions[position_sheet]
        
        self.employee.position = position
        self.employee.save()

    def __create_employee(self):
        

        employee_name = ""
        employee_email = self.sheet.cell_value(self.current_line , 1).strip()
   
        employee = Employee.objects.filter(email=employee_email)

        if len(employee) == 0:
            employee = Employee(name=employee_name, email=employee_email, organization=self.organization)
            employee.save()
        else:
            employee = employee[0]

        self.employee = employee
    
    def __academic_degree(self):
        
        academic_degree = self.sheet.cell_value(self.current_line, 7).strip()
        academic_degree_status = self.sheet.cell_value(self.current_line, 8).strip()
        
        academic_degree = self.academic_degrees[academic_degree]
        academic_degree_status = self.academic_degrees_status[academic_degree_status]


        self.employee_knowledge = EmployeeKnowledge(academic_degree=academic_degree,
                                                    academic_degree_status=academic_degree_status,
                                                    employee=self.employee)
        self.employee_knowledge.save()


    def __create_experience_level(self, sth_level, experience_level):

        sth_experience_level_level = SthStageExperienceLevel(stage=sth_level,experience_level=experience_level,employee=self.employee)
        sth_experience_level_level.save()
        
      
    def __experience_level(self):
        
        agile_level = self.stages['Desenvolvimento Ágil']
        
        ci_level = self.stages['Integração Contínua']
        
        cd_level = self.stages['Entrega Contínua']

        pd_level = self.stages['P&D como Sistema de Inovação']
    
        #agil
        knwoledge_level = self.sheet.cell_value(self.current_line, 14).strip()
        knwoledge_level = self.experience_levels[knwoledge_level]
        self.__create_experience_level(agile_level,knwoledge_level)

        #CI
        knwoledge_level = self.sheet.cell_value(self.current_line, 15).strip()
        knwoledge_level = self.experience_levels[knwoledge_level]
        self.__create_experience_level(ci_level,knwoledge_level)

        #CD
        knwoledge_level = self.sheet.cell_value(self.current_line, 16).strip()
        knwoledge_level = self.experience_levels[knwoledge_level]
        self.__create_experience_level(cd_level,knwoledge_level)

        #P&D
        knwoledge_level = self.sheet.cell_value(self.current_line, 17).strip()
        knwoledge_level = self.experience_levels[knwoledge_level]
        self.__create_experience_level(pd_level,knwoledge_level)


    def __create_knowledge_level(self, sth_level, knwoledge_level):

        sth_stage_knwoledge_level = SthStageKnwoledgeLevel(stage=sth_level,
        knwoledge_level=knwoledge_level,employee=self.employee)
        
        sth_stage_knwoledge_level.save()

    def __knowledge_level(self):
        
        agile_level = self.stages['Desenvolvimento Ágil']
        
        ci_level = self.stages['Integração Contínua']
        
        cd_level = self.stages['Entrega Contínua']

        pd_level = self.stages['P&D como Sistema de Inovação']
    
        #Agil
        knwoledge_level = self.sheet.cell_value(self.current_line, 10).strip()
        knwoledge_level = self.knwoledge_levels[knwoledge_level]
        self.__create_knowledge_level(agile_level,knwoledge_level)

        #Integração Contínua
        knwoledge_level = self.sheet.cell_value(self.current_line, 11).strip()
        knwoledge_level = self.knwoledge_levels[knwoledge_level]
        self.__create_knowledge_level(ci_level,knwoledge_level)

        #Entrega Contínua
        knwoledge_level = self.sheet.cell_value(self.current_line, 12).strip()
        knwoledge_level = self.knwoledge_levels[knwoledge_level]
        self.__create_knowledge_level(cd_level,knwoledge_level)

        #P&D
        knwoledge_level = self.sheet.cell_value(self.current_line, 13).strip()
        knwoledge_level = self.knwoledge_levels[knwoledge_level]
        self.__create_knowledge_level(pd_level,knwoledge_level)
