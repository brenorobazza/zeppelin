from django.conf import settings
from .models import State as Location, Size as OrganizationSize, OrganizationType, Organization


class OrganizationAbstractService():

    def __init__(self):
        self.organization_sizes = {}
        self.organization_types = {}
        self.locations = {}

        self.organization = None
        
        for location in Location.objects.all():
            self.locations[location.name] = location

        for organization_type in OrganizationType.objects.all():
            self.organization_types[organization_type.name] = organization_type

        for organization_size in OrganizationSize.objects.all():
            self.organization_sizes[organization_size.name]=organization_size


class OrganizationGoogleFormsService(OrganizationAbstractService):


    def process_data(self, sheet,instance,current_line):
        
        self.questionnarie = instance
        
        self.sheet = sheet
        
        self.current_line = current_line
        
        self.__create_organization()
        
        return self.organization

    def  __create_organization(self):

        organization_name = self.sheet.cell_value(self.current_line , 2).strip()

        organization_age = str(self.sheet.cell_value(self.current_line , 3)).strip()

        organization_state = self.locations[self.sheet.cell_value(self.current_line , 4).strip()]

        organization_type_sheet = self.sheet.cell_value(self.current_line , 5).strip()

        orgnization_size = self.organization_sizes[self.sheet.cell_value(self.current_line , 6).strip()]

        organization_type = None

        if organization_type_sheet not in self.organization_types:
            
            organization_type = OrganizationType()
            organization_type.name = organization_type_sheet
            organization_type.description = organization_type_sheet
            organization_type.save()

            self.organization_types[organization_type_sheet] = organization_type
        else:
            organization_type = self.organization_types[organization_type_sheet]

        #criando a organização    

        self.organization = Organization()
        self.organization.name = organization_name
        self.organization.age = float(organization_age)
        self.organization.organization_size = orgnization_size
        self.organization.organization_type = organization_type
        self.organization.location = organization_state
        
        self.organization.save()
    
   
class OrganizationService (OrganizationAbstractService):

    def __init__(self):
        self.organization_sizes = {}
        self.organization_types = {}
        
        for organization_type in OrganizationType.objects.all():
            self.organization_types[organization_type.name] = organization_type

        for organization_size in OrganizationSize.objects.all():
            self.organization_sizes[organization_size.name]=organization_size

    def process_data(self, instance):
        self.questionnarie = instance
        self.wb = xlrd.open_workbook(settings.MEDIA_ROOT+"/"+str(instance.document)) 
        self.sheet = self.wb.sheet_by_index(3)
    
        self.__create_organization()
        self.__create_development_team_information()

        return self.organization
    
    def __create_organization (self):

        organization_name = self.sheet.cell_value(3, 2).strip()
        organization_type = self.sheet.cell_value(7, 2).strip()
        organization_size = self.sheet.cell_value(8, 2).strip()
        organization_age = self.sheet.cell_value(9, 2)

        organization_type = self.organization_types[organization_type]
        organization_size = self.organization_sizes[organization_size]

        
        organization = Organization.objects.filter(name__icontains=organization_name)
        
        if len(organization) == 0:

            organization = Organization(name=organization_name,organizaton_size=organization_size, organizaton_type=organization_type, age=organization_age)
            organization.save()
        else:
            organization = organization[0]
        self.organization = organization
        
    
    def __create_development_team_information(self):

        development_team_size = self.sheet.cell_value(12, 2)
        
        development_team_agile_size = self.sheet.cell_value(13, 2)

        development_team_overview = DevelopmentTeamOverview(development_team_size=development_team_size,
                                                            people_working_agile=development_team_agile_size, 
                                                            organization=self.organization)
        development_team_overview.save()


