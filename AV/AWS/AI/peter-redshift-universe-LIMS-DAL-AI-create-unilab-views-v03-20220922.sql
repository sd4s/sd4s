--UNILAB-UNIVERSE
--REDSHIFT: https://docs.aws.amazon.com/redshift/latest/dg/c_SQL_commands.html
--
--To view comments, query the PG_DESCRIPTION system catalog. 
--Relname:      request    (let op: KLEINE LETTERS)
--Namespace:	sc_lims_dal, sc_unilab_ens, sc_interspec_ens   (let op: KLEINE LETTERS)
-- 
select oid, relname, relnamespace from pg_class where relname='request';
--1326662	request	  1230816

--RETRIEVE TABLE/VIEW-COMMENT
select descr.objoid        --table-id
,      cla.relname         --table-name
,      descr.objsubid
,      descr.description
from pg_catalog.pg_class       cla
,    pg_catalog.pg_description descr
where cla.oid        = descr.objoid 
and   descr.objsubid = 0
and   cla.relname    = 'request' 
and   cla.relnamespace = (select oid from pg_catalog.pg_namespace where nspname = 'sc_lims_dal') 
;

--RETRIEVE TABLE/VIEW-COLUMNS-COMMENT
select descr.objoid        --table-id
,      cla.relname         --table-name
,      descr.objsubid
,      att.attname
,      descr.description
from pg_catalog.pg_attribute   att
,    pg_catalog.pg_class       cla
,    pg_catalog.pg_description descr
where cla.oid      = descr.objoid 
and   att.attrelid = descr.objoid 
and   att.attnum   = descr.objsubid
and   cla.relname = 'request' 
and   cla.relnamespace = (select oid from pg_catalog.pg_namespace where nspname = 'sc_lims_dal') 
;


--************************************************************************************************************
--****   OPERATIONAL 
--************************************************************************************************************
--
--2.1.SAMPLE
--2.2.SAMPLE_GROUP_KEY
--2.3.SAMPLE_DATA_TIME_INFO
--2.4.SAMPLE_ATTRIBUTES
--2.5.SAMPLE_HISTORY
--2.6.SAMPLE_HIST_DETAILS            (couldn't be created, isn't fully replicated) 
--2.7.SAMPLE_INFO_CARD 
--2.8.SAMPLE_INFO_CARD_HISTORY       (couldn't be created, isn't fully replicated) 
--2.9.SAMPLE_INFO_CARD_HIST_DETAILS  (couldn't be created, isn't fully replicated) 
--2.10.SAMPLE_INFO_FIELD
--2.11.SAMPLE_PART_NO_INFO_CARD
--2.12.SAMPLE_PART_NO_GROUPKEY
--
--3.1.PARAMETER_GROUP
--3.2.PARAMETER_GROUP_DATA_TIME_INFO
--3.3.PARAMETER_GROUP_REANALYSIS      (is replicated, but table is empty) 
--3.4.PARAMETER_GROUP_ATTRIBUTES      
--3.5.PARAMETER_GROUP_HISTORY         (couldn't be created, isn't fully replicated) 
--3.6.PARAMETER_GROUP_HIST_DETAILS    (couldn't be created, isn't fully replicated) 
--   
--4.1.PARAMETER
--4.2.PARAMETER_DATA_TIME_INFO
--4.3.PARAMETER_SPECIFICATIONS
--4.4.PARAMETER_ATTRIBUTES
--4.5.PARAMETER_HISTORY
--4.6.PARAMETER_HIST_DETAILS           (couldn't be created, isn't fully replicated) 
--4.7.PARAMETER_REANALYSIS      
--
--5.1.METHOD
--5.2.METHOD_DATA_TIME_INFO
--5.3.METHOD_GROUP_KEY
--5.4.METHOD_ATTRIBUTES
--5.5.METHOD_HISTORY
--5.6.METHOD_HIST_DETAILS              (couldn't be created, isn't fully replicated) 
--5.7.METHOD_REANALYSIS      
--


--************************************************************************************************************
--1. requests
--************************************************************************************************************

--***********************************************************************************************************
--****   2.SAMPLES
--***********************************************************************************************************


--**********************************
--2.12.SAMPLE_PART_NO_GROUPKEY    (base-view:  sc_lims_dal.sample_group_key)
--Authorisation-criteria: 
-- <NA>:   if necessary we only need the GK "LIKE '%PART_NO%' ", for the link to INTERSPEC-PART-NO !!!!!!
-- 
--Dependencies:
--REFERENTIAL-CONSTRAINT: part-no/revision exists in view SC_LIMS_DAL_AI.AI_SPECIFICATION !!!!! (current REVISION of PCR/TBR/OHT-tyres)
--**********************************
--Bij outdoor-testing kunnen we kiezen voor request-type test "normal (4x zelfde band), combined (front+rear), en mixed (4xverschillende band)"
--Deze kunnen we bij SAMPLE opgeven, en komen dan ook op de INFO-CARD te staan !!
--De info-card geeft aan op welke POSITIE de band zit (bijv. avScReqPctFL, FR, RL, RR)

drop view sc_lims_dal_ai.ai_sample;
drop view sc_lims_dal_ai.AI_METHOD;
drop view sc_lims_dal_ai.AI_METHOD_CELL;
drop view sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY;
--
create or replace view sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY
(sample_code                         --sample-code
,group_key                           --group-keys
,group_key_sequence                  --group-key-sequence 
,value                               --group-key value
)
as
select sample_code 
,      group_key         
,      group_key_sequence
,      value     
from sc_lims_dal.sample_part_no_groupkey gk
where exists (select '' from sc_lims_dal_ai.ai_specification asp where asp.part_number = gk.value ) 
;

--table-comment:
--table-comment:
comment on VIEW sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY is 'Contains current UNILAB-SAMPLES RELATED TO PCR/TBR/OHT-part-no ';

--column-comment:
comment on COLUMN sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY.sample_code            is 'sample-code';
comment on COLUMN sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY.group_key              is 'group-keys';
comment on COLUMN sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY.group_key_sequence     is 'group-key-sequence';
comment on COLUMN sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY.value                  is 'group-key value';





--**********************************
--2.1.SAMPLE      (base-view:  sc_lims_dal.sample )
--Authorisation-criteria: 
--Dependencies:
--REFERENTIAL-CONSTRAINT: SAMPLE-CODE exists in view SC_LIMS_DAL_AI.AI_SAMPLE_GROUP_KEY !!!!! (current REVISION of PCR/TBR/OHT-tyres)
--**********************************
drop view sc_lims_dal_ai.ai_sample;
--
create or replace view sc_lims_dal_ai.ai_sample
(sample_code              --sample-code
,request_code             --Request-code of the Samples
,allow_modify             --allow modify
,sop                      --Standard Operational Procedure for SAMPLE
,label_format             --Label format used for printing samples
,priority                 --Priority of sample
,last_comment             --Last comment of the sample
,description              --Sample code description
,created_by               --Person who created the sample
,version_description      --Version Description of the samples
,version                  --Version of the samples
,sample_type              --Sample type
,shelf_life_unit          --Shelf life unit of the Samples
,shell_life_value         --Shelf life value of the Samples
,life_cycle               --Life cycle that determines the request's status changes
,life_cycle_description   --life cycle description
,status                   --Status the sample has reached in its life cycle
,status_description       --Status the sample has reached in its life cycle (description)
)
as
select sample_code  
,request_code       
,allow_modify       
,sop                
,label_format       
,priority           
,last_comment       
,description        
,created_by         
,version_description
,version            
,sample_type        
,shelf_life_unit    
,shell_life_value   
,life_cycle         
,life_cycle_description
,status                
,status_description   
from sc_lims_dal.sample  sc
where exists (select '' from sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY asgk where asgk.sample_code = sc.sample_code ) 
and   sc.status in ('CM', 'OS', 'OW', 'SC', 'WC')
;

--table-comment:
comment on VIEW sc_lims_dal_ai.ai_sample is 'Contains ONLY UNILAB-SAMPLE related to current PCR/TBR/OHT-specs';

--column-comment:
comment on COLUMN sc_lims_dal_ai.ai_sample.sample_code            is 'sample-code';
comment on COLUMN sc_lims_dal_ai.ai_sample.request_code           is 'Request-code of the Samples';
comment on COLUMN sc_lims_dal_ai.ai_sample.allow_modify           is 'allow modify';
comment on COLUMN sc_lims_dal_ai.ai_sample.sop                    is 'Standard Operational Procedure for SAMPLE';
comment on COLUMN sc_lims_dal_ai.ai_sample.label_format           is 'Label format used for printing samples';
comment on COLUMN sc_lims_dal_ai.ai_sample.priority               is 'Priority of sample';
comment on COLUMN sc_lims_dal_ai.ai_sample.last_comment           is 'Last comment of the sample';
comment on COLUMN sc_lims_dal_ai.ai_sample.description            is 'Sample code description';
comment on COLUMN sc_lims_dal_ai.ai_sample.created_by             is 'Person who created the sample';
comment on COLUMN sc_lims_dal_ai.ai_sample.version_description    is 'Version Description of the samples';
comment on COLUMN sc_lims_dal_ai.ai_sample.version                is 'Version of the samples';
comment on COLUMN sc_lims_dal_ai.ai_sample.sample_type            is 'Sample type';
comment on COLUMN sc_lims_dal_ai.ai_sample.shelf_life_unit        is 'Shelf life unit of the Samples';
comment on COLUMN sc_lims_dal_ai.ai_sample.shell_life_value       is 'Shelf life value of the Samples';
comment on COLUMN sc_lims_dal_ai.ai_sample.life_cycle             is 'Life cycle that determines the requests status changes';
comment on COLUMN sc_lims_dal_ai.ai_sample.life_cycle_description is 'life cycle description';
comment on COLUMN sc_lims_dal_ai.ai_sample.status                 is 'Status the sample has reached in its life cycle';
comment on COLUMN sc_lims_dal_ai.ai_sample.status_description     is 'Status the sample has reached in its life cycle (description)';






--************************************************************************************************************
--****   5.METHOD
--************************************************************************************************************

--**********************************
--5.1.METHOD
--**********************************
drop view sc_lims_dal_ai.AI_METHOD;
--
create or replace view sc_lims_dal_ai.AI_METHOD
(sample_code              --Sample-code of the Parameter groups
,parameter_group          --Parameter group
,parameter_group_node     --Parameter group node
,parameter                --Parameter
,parameter_node           --Parameter-node
,method                   --method
,method_node              --method-node
,autorecalculation        --auto-recalculation
,confirm_complete         --Confirm complete
,reanalysis               --The number of times the parameter has been reanalysed for this sample
,sop                      --/SOP of the Methods
,manually_added           --/Manually added of the Methods
,manually_entered         --Manually entered of the Methods
,allow_additional_measure --Allow additional measurement of the Methods
,last_comment             --Last comment of the parameter-group
,description              --Parameter group description
,version_description      --Version Description of the Parameter 
,version                  --Version of the Parameter 
,delay_value              --Amount of time between the sampling date and the moment the parameter was assigned to the sample (value)
,delay_unit               --Amount of time between the sampling date and the moment the parameter was assigned to the sample (unit)
,result_unit              --unit
,result_value_f           --result-value
,result_value_s           --result-value-string
,result_format            --result format
,planned_executor         --Name of the person who was supposed to execute the parameter  for the sample
,executor                 --Name of the person who actually executed the parameter  for the sample
,assigned_by              --ID of the user who assigned the parameter  to the sample
,lab                      --Laboratorium
,planned_equipment        --Equipment supposed to be used for the method
,equipment                --Equipment used for the method
,real_cost                --Real cost of executing this method
,real_time                --Real time needed for executing this method
,life_cycle               --Life cycle that determines the request's status changes
,life_cycle_description   --life cycle description
,status                   --Status the sample has reached in its life cycle
,status_description       --Status the sample has reached in its life cycle (description)
)
as
select sample_code   
,parameter_group     
,parameter_group_node
,parameter           
,parameter_node      
,method              
,method_node         
,autorecalculation   
,confirm_complete    
,reanalysis          
,sop                 
,manually_added      
,manually_entered    
,allow_additional_measure 
,last_comment             
,description              
,version_description      
,version                  
,delay_value              
,delay_unit               
,result_unit              
,result_value_f           
,result_value_s           
,result_format            
,planned_executor         
,executor                 
,assigned_by              
,lab                      
,planned_equipment        
,equipment                
,real_cost                
,real_time                
,life_cycle               
,life_cycle_description   
,status                   
,status_description 
from sc_lims_dal.method  scme
where exists (select '' from sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY asgk where asgk.sample_code = scme.sample_code ) 
and   scme.status in ('CM')
and   scme.parameter LIKE '%TT520AX%' 
and   scme.method    like '%TT520%' 
;
--table-comment:
comment on VIEW sc_lims_dal_ai.AI_METHOD is 'Contains all UNILAB-SAMPLE METHOD, all statusses, ';

--column-comment:
comment on COLUMN sc_lims_dal_ai.AI_METHOD.sample_code              is 'sample-code';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.parameter_group          is 'Parameter group';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.parameter_group_node     is 'Parameter group node';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.parameter                is 'Parameter';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.parameter_node           is 'Parameter-node';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.method                   is 'method';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.method_node              is 'method-node';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.autorecalculation        is 'auto-recalculation';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.confirm_complete         is 'Confirm complete';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.reanalysis               is 'The number of times the parameter has been reanalysed for this sample';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.sop                      is 'SOP of the Methods';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.manually_added           is 'Manually added of the Methods';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.manually_entered         is 'Manually entered of the Methods';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.allow_additional_measure is 'Allow additional measurement of the Methods';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.last_comment             is 'Last comment of the parameter-group';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.description              is 'Parameter group description';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.version_description      is 'Version Description of the Parameter ';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.version                  is 'Version of the Parameter ';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.delay_value              is 'Amount of time between the sampling date and the moment the parameter was assigned to the sample (value)';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.delay_unit               is 'Amount of time between the sampling date and the moment the parameter was assigned to the sample (unit)';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.result_unit              is 'unit';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.result_value_f           is 'result-value';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.result_value_s           is 'result-value-string';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.result_format            is 'result format';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.planned_executor         is 'Name of the person who was supposed to execute the parameter  for the sample';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.executor                 is 'Name of the person who actually executed the parameter  for the sample';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.assigned_by              is 'ID of the user who assigned the parameter  to the sample';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.lab                      is 'Laboratorium';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.planned_equipment        is 'Equipment supposed to be used for the method';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.equipment                is 'Equipment used for the method';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.real_cost                is 'Real cost of executing this method';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.real_time                is 'Real time needed for executing this method';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.life_cycle               is 'Life cycle that determines the requests status changes';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.life_cycle_description   is 'life cycle description';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.status                   is 'Status the sample has reached in its life cycle';
comment on COLUMN sc_lims_dal_ai.AI_METHOD.status_description       is 'Status the sample has reached in its life cycle (description)';



--************************************************************************************************************
--****   6.METHOD-CELL
--************************************************************************************************************

--**********************************
--6.1.METHOD_CELL 
--**********************************
DROP VIEW sc_lims_dal_ai.AI_METHOD_CELL;
--
create or replace view sc_lims_dal_ai.AI_METHOD_CELL
(sample_code              --Sc of the Parameter groups
,parameter_group          --Parameter group
,parameter_group_node     --Parameter group node
,parameter                --Parameter
,parameter_node           --Parameter-node
,method                   --method
,method_node              --method-node
,cell                     --cell
,cell_node                --cell-node
,multi_select             --Multi select of the Method cells
,calculation_formula      --Calculation formula
,calculation_type         --Calculation type
,equipment                --Equipment used for the method
,alignment                --Alignment (alignment of text in cell)
,cell_type                --Cell type
,pos_x                    --Pos X (X position of cell in methodsheet)
,pos_y                    --Pos Y (Y position of cell in method sheet)
,valid_cf                 --Valid cf of the Method cells
,display_title            --Description of cells in method sheet
,result_unit              --unit
,result_value_f           --result-value
,result_value_s           --result-value-string
,result_format            --result format
)
as
select sample_code    
,parameter_group      
,parameter_group_node 
,parameter            
,parameter_node       
,method               
,method_node          
,cell                 
,cell_node            
,multi_select         
,calculation_formula  
,calculation_type     
,equipment            
,alignment            
,cell_type            
,pos_x                
,pos_y                
,valid_cf             
,display_title        
,result_unit          
,result_value_f       
,result_value_s       
,result_format  
from sc_lims_dal.METHOD_CELL  scmecel
where exists (select '' from sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY asgk where asgk.sample_code = scmecel.sample_code ) 
and   scmecel.parameter LIKE '%TT520AX%' 
and   scmecel.method    like '%TT520%' 
and   scmecel.cell in 
('w_max'
,'Circumference'
,'Tyrediameter'
,'p_infl'		
,'p_infl_PSI'
)
;
--table-comment:
comment on VIEW sc_lims_dal_ai.AI_METHOD_CELL is 'Contains all UNILAB-SAMPLE METHOD cell results';

--column-comment:
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.sample_code              is 'sample-code';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.parameter_group          is 'Parameter group';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.parameter_group_node     is 'Parameter group node';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.parameter                is 'Parameter';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.parameter_node           is 'Parameter-node';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.method                   is 'method';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.method_node              is 'method-node';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.cell                     is 'cell';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.cell_node                is 'cell-node';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.multi_select             is 'Multi select of the Method cells';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.calculation_formula      is 'Calculation formula';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.calculation_type         is 'Calculation type';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.equipment                is 'Equipment used for the method';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.alignment                is 'Alignment (alignment of text in cell)';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.cell_type                is 'Cell type';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.pos_x                    is 'Pos X (X position of cell in methodsheet)';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.pos_y                    is 'Pos Y (Y position of cell in method sheet)';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.valid_cf                 is 'Valid cf of the Method cells';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.display_title            is 'Description of cells in method sheet';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.result_unit              is 'unit';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.result_value_f           is 'result-value';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.result_value_s           is 'result-value-string';
comment on COLUMN sc_lims_dal_ai.AI_METHOD_CELL.result_format            is 'result format';





--einde script


