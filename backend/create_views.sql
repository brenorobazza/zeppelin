create view assertive_category_stage_process as select 
qs."statement" , 
qs.code , 
pee."name" as "element",
pec."name" as "category",
sth."name" as "sth_stage",
cfp."name" as "process"
from 
questionnaire_statement qs
inner join practitioners_eye_element pee on pee.id = qs.pe_element_id 
inner join practitioners_eye_dimension pec on pec.id = pee.dimension_id  
inner join sth_stage sth on sth.id  = qs.sth_stage_id 
inner join questionnaire_statement_fcse_processes sfp on sfp.statement_id = qs.id 
inner join cse_framework_process cfp on cfp.id = sfp.process_id 


create view employee_knwoledge_level_view as select 
ss."name" as sth,
ek."name" as knwoledge_level,
ek.value,
count (ek."name") as qtd, 
ee.organization_id
from employee_employee ee 
inner join employee_sthstageknwoledgelevel es on es.employee_id = ee.id  
inner join sth_stage ss on ss.id = es.stage_id 
inner join employee_knwoledgelevel ek on ek.id = es.knwoledge_level_id  
group by sth, knwoledge_level, value, ee.organization_id
order by sth


drop view answer_sth_stage_adopted_level_view
create view answer_sth_stage_adopted_level_view as select 
qa.organization_id, 
qal.name as adopted_level,
qal.id as adopted_level_id,
qal.percentage as adopted_level_percentage, 
ss.name as  sth_stage,
ss.id as sth_stage_id,
count (*) as value
from 
questionnaire_answer qa 
inner join questionnaire_statement qs on qa.statement_id = qs.id
inner join sth_stage ss on ss.id = qs.sth_stage_id 
inner join questionnaire_adoptedlevel qal on qal.id = qa.adopted_level_id
group by adopted_level, sth_stage, qal.percentage, qal.id, qa.organization_id, ss.id
order by qal.id




create view employee_experience_level_view as select 
ss."name" as sth,
ek."name" as experience_level,
ek.value,
count (ek."name") as qtd
from employee_employee ee 
inner join employee_sthstageexperiencelevel es on es.employee_id = ee.id  
inner join sth_stage ss on ss.id = es.stage_id 
inner join employee_experiencelevel ek on ek.id = es.experience_level_id  
group by sth, experience_level, value
order by sth    


create view employee_academic_category_experience_level_sth_view as Select 
e_v.academic_category,
ss."name" as sth,
ek.value,
count (ek."name") as qtd
from 
employee_academic_category_view e_v 
inner join employee_sthstageexperiencelevel es on es.employee_id = e_v.employee_id 
inner join sth_stage ss on ss.id = es.stage_id 
inner join employee_experiencelevel ek on ek.id = es.experience_level_id  
group by sth,academic_category, ek.value
order by academic_category


create view employee_view as select distinct
select distinct
qo.id as "organization_id",
ee.id as employee_id,
ee.email as "employee_email",
ep."name" as "employee_position",
ep.id as "employee_position_id",
ea."name" as "employee_academic_degree",
ea.id as "employee_academic_degree_id",
ea_status."name" as "employee_academic_degree_status",
ea_status.id as "employee_academic_degree_status_id",
ss."name" as "employee_sth_stage_knowledge",
ss.id as "employee_sth_stage_knowledge_id",
ek."name" as "knwoledge_level",
ek.id as "knwoledge_level_knowledge_id",
ss2."name" as "employee_sth_stage_experience",
ss2.id as "employee_sth_stage_experience_id",
ee2."name" as "experience_level",
ee2.id as "experience_id"
from 
organization_organization  qo
inner join employee_employee ee on qo.id = ee.organization_id 
inner join employee_position ep on ep.id = ee.position_id 
inner join employee_employeeknowledge eknowledge on eknowledge.employee_id = ee.id 
inner join employee_academicdegree ea on eknowledge.academic_degree_id = ea.id 
inner join employee_academicdegreestatus ea_status on ea_status.id = eknowledge.academic_degree_status_id 
inner join employee_sthstageknwoledgelevel es on es.employee_id = ee.id
inner join sth_stage ss on ss.id = es.stage_id
inner join employee_knwoledgelevel ek on ek.id = es.knwoledge_level_id 
inner join employee_sthstageexperiencelevel es2 on es2.employee_id = ee.id 
inner join sth_stage ss2 on ss2.id = es2.stage_id
inner join employee_experiencelevel ee2 on ee2.id = es2.experience_level_id 



create view organization_view as select  
oo.id as organization_id, 
oo.name as organization_name,
oo.age,
oo_type.name as organization_type,
oo_size.name as organization_size,
os.name as state,
orr.name as region,
ooc.name as category
from 
organization_organization oo 
inner join organization_organizationtype oo_type on oo.organization_type_id  = oo_type.id 
inner join organization_size oo_size on oo.organization_size_id = oo_size.id
inner join organization_state os ON os.id = oo.location_id
inner join organization_region orr on orr.id = os.region_id
inner join organization_organizationcategory ooc on ooc.id = oo_type.category_id 

(select 
sth_stage,
category,
(sum (value*adopted_level_percentage)/sum(value)) as value
from answer_sth_stage_adopted_level_view x
inner join organization_view ov on ov.organization_id = x.organization_id
group by sth_stage, category
order by category, sth_stage)

union all

(select 
sth_stage,
'Geral' as category,
(sum (value*adopted_level_percentage)/sum(value)) as value
from answer_sth_stage_adopted_level_view x
group by sth_stage
order by sth_stage);



## relação de employee com categorias
create view employee_academic_category_view as select 
ea.name as "academic_category",
employee.id as "employee_id",
employee.organization_id as "organization_id"
from 
employee_academicdegreecategory ea
inner join employee_academicdegree ea2 on ea2.category_id = ea.id
inner join employee_employeeknowledge ee on ee.academic_degree_id  = ea2.id
inner join employee_employee employee on employee.id = ee.employee_id

create view employee_academic_category_knowledge_level_sth_view as Select e_v.academic_category,
ss."name" as sth,
ek.value,
count (ek."name") as qtd
from 
employee_academic_category_view e_v 
inner join employee_sthstageknwoledgelevel es on es.employee_id = e_v.employee_id 
inner join sth_stage ss on ss.id = es.stage_id 
inner join employee_knwoledgelevel ek on ek.id = es.knwoledge_level_id  
group by sth,academic_category, ek.value
order by academic_category 


create view answer_sth_stage_eye_dimensions_adopted_level_view as select 
qa.organization_id, 
qal.percentage as adopted_level_percentage, 
ss.name as sth_stage,
ped."name" as eyes_dimension,
sum (*) as practices_by_dimension
from 
questionnaire_answer qa 
inner join questionnaire_statement qs on qa.statement_id = qs.id
inner join sth_stage ss on ss.id = qs.sth_stage_id 
inner join practitioners_eye_element pee on pee.id = qs.pe_element_id  
inner join practitioners_eye_dimension ped on ped.id = pee.dimension_id 
inner join questionnaire_adoptedlevel qal on qal.id = qa.adopted_level_id
group by eyes_dimension, adopted_level, sth_stage, organization_id, adopted_level_percentage, qal.id

select  
sth_stage,
eyes_dimension,
(SUM (practices_by_dimension*adopted_level_percentage)/SUM(practices_by_dimension)) as value
from answer_sth_stage_eye_dimensions_adopted_level_view
where organization_id = 533
group by sth_stage, eyes_dimension

create view answer_sth_stage_eye_dimensions_element_view as select 
qa.organization_id, 
qal.percentage as adopted_level_percentage, 
ss.name as sth_stage,
pee."name" as eyes_element, 
count (*) as practices_by_dimension
from 
questionnaire_answer qa 
inner join questionnaire_statement qs on qa.statement_id = qs.id
inner join sth_stage ss on ss.id = qs.sth_stage_id 
inner join practitioners_eye_element pee on pee.id = qs.pe_element_id  
inner join practitioners_eye_dimension ped on ped.id = pee.dimension_id 
inner join questionnaire_adoptedlevel qal on qal.id = qa.adopted_level_id
group by eyes_dimension,eyes_element,sth_stage, organization_id, adopted_level_percentage, qal.id



drop view answer_sth_stage_eye_dimensions_element_view
create view answer_sth_stage_eye_element_view as select 
qa.organization_id, 
qal.percentage as adopted_level_percentage, 
ss.name as sth_stage,
pee."name" as eyes_element, 
count (*) as practices_by_dimension
from 
questionnaire_answer qa 
inner join questionnaire_statement qs on qa.statement_id = qs.id
inner join sth_stage ss on ss.id = qs.sth_stage_id 
inner join practitioners_eye_element pee on pee.id = qs.pe_element_id  
inner join practitioners_eye_dimension ped on ped.id = pee.dimension_id 
inner join questionnaire_adoptedlevel qal on qal.id = qa.adopted_level_id
group by eyes_element,sth_stage, organization_id, adopted_level_percentage, qal.id


create view answer_sth_stage_fce_process_view as select 
qa.organization_id, 
qal.percentage as adopted_level_percentage,
cfp.name as process,
ss.name as sth_stage,
count (*) as practices_by_dimension
from 
questionnaire_answer qa 
inner join questionnaire_statement qs on qa.statement_id = qs.id
inner join questionnaire_statement_fcse_processes qsfp on qsfp.statement_id = qs.id 
inner join cse_framework_process cfp on cfp.id = qsfp.process_id 
inner join sth_stage ss on ss.id = qs.sth_stage_id 
inner join questionnaire_adoptedlevel qal on qal.id = qa.adopted_level_id
group by organization_id, sth_stage, process, adopted_level_percentage


drop view answer_eye_cse_dimension_adopted_level_view
create view answer_eye_cse_dimension_adopted_level_view as select 
qa.organization_id, 
qal.name as adopted_level,
qal.id as adopted_level_id,
qal.percentage as adopted_level_percentage, 
ped."name"  as  dimension,
ped.id as dimension_id,
ss.name as sth_stage,
ss.id as sth_stage_id,
count (*) as value
from 
questionnaire_answer qa 
inner join questionnaire_statement qs on qa.statement_id = qs.id
inner join sth_stage ss on ss.id = qs.sth_stage_id 
inner join practitioners_eye_element pee  on qs.pe_element_id = pee.id  
inner join practitioners_eye_dimension ped on ped.id = pee.dimension_id 
inner join questionnaire_adoptedlevel qal on qal.id = qa.adopted_level_id
group by adopted_level, ped."name" , qal.percentage, qal.id, qa.organization_id, ped.id,  ss."name", ss.id
order by qal.id

drop view answer_eye_cse_element_adopted_level_view
create view answer_eye_cse_element_adopted_level_view as select 
qa.organization_id, 
qal.name as adopted_level,
qal.id as adopted_level_id,
qal.percentage as adopted_level_percentage, 
pee."name"  as  "element",
pee.id as "element_id",
ss.name as sth_stage,
ss.id as sth_stage_id,
count (*) as value
from 
questionnaire_answer qa 
inner join questionnaire_statement qs on qa.statement_id = qs.id
inner join sth_stage ss on ss.id = qs.sth_stage_id 
inner join practitioners_eye_element pee  on qs.pe_element_id = pee.id  
inner join practitioners_eye_dimension ped on ped.id = pee.dimension_id 
inner join questionnaire_adoptedlevel qal on qal.id = qa.adopted_level_id
group by adopted_level, pee."name" , qal.percentage, qal.id, qa.organization_id, pee.id, ss."name", ss.id
order by qal.id


create view answer_process_cse_adopted_level_view as select 
qa.organization_id, 
qal.name as adopted_level,
qal.id as adopted_level_id,
qal.percentage as adopted_level_percentage, 
cfp."name"  as  process_cse,
cfp.id as process_cse_id,
ss.name as sth_stage,
ss.id as sth_stage_id,
count (*) as value
from 
questionnaire_answer qa 
inner join questionnaire_statement qs on qa.statement_id = qs.id
inner join sth_stage ss on ss.id = qs.sth_stage_id 
inner join questionnaire_adoptedlevel qal on qal.id = qa.adopted_level_id
inner join questionnaire_statement_fcse_processes qsfp on qsfp.statement_id = qs.id 
inner join cse_framework_process cfp on cfp.id = qsfp.process_id 
group by adopted_level, cfp."name" , qal.percentage, qal.id, qa.organization_id, cfp.id,  ss."name", ss.id
order by qal.id
