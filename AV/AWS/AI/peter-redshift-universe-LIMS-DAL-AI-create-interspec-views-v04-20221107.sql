--UNILAB-UNIVERSE
--REDSHIFT: https://docs.aws.amazon.com/redshift/latest/dg/c_SQL_commands.html
--
--To view comments, query the PG_DESCRIPTION system catalog. 
--Relname:      frame                                          (let op: lowercase !!)
--Namespace:	sc_lims_dal, sc_unilab_ens, sc_interspec_ens   (let op: lowercase !!)
-- 
select oid, relname, relnamespace from pg_class where relname='frame';
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
and   cla.relname    = 'frame' 
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
and   cla.relname = 'frame' 
and   cla.relnamespace = (select oid from pg_catalog.pg_namespace where nspname = 'sc_lims_dal') 
;

--************************************************************************************************************
--****   CONFIGURATION 
--************************************************************************************************************
--nvt


--************************************************************************************************************
--****   OPERATIONAL 
--************************************************************************************************************
--2.SPECIFICATIONS
--2.1.Specification                 (couldn't replicate alle reference-tables)
--2.9.specification_property    
--2.10.specification_data    
--2.11.SPECIFICATION_BOM_HEADER
--2.12.SPECIFICATION_BOM_ITEM
--

--************************************************************************************************************
--2.1.Specification   (basis: sc_lims_dal.specification)
--Authorisation-criteria:    
--   frame_id in ('A_PCR','A_TBR' ,' A_OHT') + part_no like 'EF%' / 'XEF%' / 'GF%' / 'XGF%' 
--   frame_id in (A_PCR_VULC v1','A_TBR_VULC','E_PCR_VULC') + part_no like 'EV%' / 'XEV%' / 'GFV' / 'XGV%' 
--   frame_id in ('A_Bead v1','E_Bead','E_Bead_AT','E_Bead_Bare_AT') + part_no like 'EB%' / 'XEB%' / 'GB%' / 'XGB%' 
-- status_type in ('CURRENT')
-- revision = (select max(sp.specification) from specification sh where sh.part_no = part_no and sh.status_type = 'CURRNT' )
--
--specs: 15407 HISTORIC, 20159 HISTORIC+CURRENT
--************************************************************************************************************
--interspec
drop view sc_lims_dal_ai.ai_specification_property;
drop view sc_lims_dal_ai.ai_specification_data;
--unilab
drop view sc_lims_dal_ai.ai_sample;
drop view sc_lims_dal_ai.AI_METHOD;
drop view sc_lims_dal_ai.AI_METHOD_CELL;
drop view sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY;
--
drop view sc_lims_dal_ai.ai_specification;
--
create or replace view sc_lims_dal_ai.ai_specification
(part_number                 
,spec_revision               
,spec_description            
,spec_created_by             
,spec_created_on             
,workflow_group_id           
,spec_last_modified_by       
,spec_last_modified_on       
,spec_status_change_date     
,spec_phase_in_tolerance     
,spec_locked                 
,spec_issued_date            
,spec_status_id              
,status                      
,status_description          
,status_type                 
,spec_type_ID                
,spec_type                   
,spec_type_description       
,spec_type_group             
,spec_ped_in_sync            
,spec_obsolescence_date      
,spec_planned_effective_date 
,spec_internat_part_no       
,spec_internat_part_revision 
,spec_frame_id               
,spec_frame_revision         
)
as
select part_number
,spec_revision    
,spec_description 
,spec_created_by  
,spec_created_on  
,workflow_group_id
,spec_last_modified_by 
,spec_last_modified_on 
,spec_status_change_date
,spec_phase_in_tolerance
,spec_locked           
,spec_issued_date      
,spec_status_id        
,status                
,status_description    
,status_type           
,spec_type_ID          
,spec_type             
,spec_type_description 
,spec_type_group       
,spec_ped_in_sync      
,spec_obsolescence_date 
,spec_planned_effective_date
,spec_internat_part_no      
,spec_internat_part_revision
,spec_frame_id              
,spec_frame_revision 
from sc_lims_dal.specification sp
where (  (   sp.spec_frame_id in ('A_PCR','A_TBR','A_OHT')
         and   (  sp.part_number like 'EF%' 
               or sp.part_number like 'XEF%' 
               or sp.part_number like 'GF%' 
               or sp.part_number like 'XGF%' 
               )
         )
      or (  sp.spec_frame_id in ('A_PCR_VULC v1','A_TBR_VULC','E_PCR_VULC')
         and   (  sp.part_number like 'EV%' 
               or sp.part_number like 'XEV%' 
               or sp.part_number like 'GV%' 
               or sp.part_number like 'XGV%' 
               )
         )
      or (  sp.spec_frame_id in ('A_Bead v1','E_Bead','E_Bead_AT','E_Bead_Bare_AT')
         and   (  sp.part_number like 'EB%' 
               or sp.part_number like 'XEB%' 
               or sp.part_number like 'GB%' 
               or sp.part_number like 'XGB%' 
               )
         )
     )
and   sp.spec_revision = (select max(sh.spec_revision) from sc_lims_dal.specification sh where sh.part_number = sp.part_number and sh.status_type in ('CURRENT','HISTORIC')  )
;

--SELECT COUNT(*) FROM sc_lims_dal_ai.ai_specification;
--9866
--SELECT COUNT(*), STATUS_TYPE FROM sc_lims_dal_ai.ai_specification GROUP BY STATUS_TYPE;


--table-comment:
comment on VIEW sc_lims_dal_ai.ai_specification is 'Contains SPECIFICATION-HEADERS from PCR/TBR/OHT-tyres, all current/historic revision.';

--column-comment:
comment on COLUMN sc_lims_dal_ai.ai_specification.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_revision               is 'Revision number of the Specification';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_description            is 'Spec Description of the Spec Header';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_created_by             is 'Full Name of the User who created the Specification';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_created_on             is 'Date on which Specification has been created';
comment on COLUMN sc_lims_dal_ai.ai_specification.workflow_group_id           is 'Identification of the Workflowgroup assigned to the Specification';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_last_modified_by       is 'Name of the User who made the last change(s) to the Specification';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_last_modified_on       is 'Date of last modification';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_status_change_date     is 'Date of the last Status Change';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_phase_in_tolerance     is 'Spec Phase In Tolerance of the Spec Header';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_locked                 is 'Name of the User who locked to the Specification';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_issued_date            is 'Date on which Specification has become Current';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_status_id              is 'ID of the Specification Status';
comment on COLUMN sc_lims_dal_ai.ai_specification.status                      is 'Short description of the Specification Status';
comment on COLUMN sc_lims_dal_ai.ai_specification.status_description          is 'Full description of the Specification Status';
comment on COLUMN sc_lims_dal_ai.ai_specification.status_type                 is 'Status Type to which the Specification Status belongs';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_type_ID                is 'Identification of Specification Type';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_type                   is 'Short description of Specification Type';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_type_description       is 'Full description of Specification Type';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_type_group             is 'Specification Type Group to which the Specification Type belongs';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_ped_in_sync            is 'Synchronized Planned-Effective Dates';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_obsolescence_date      is 'Date on which the Specification Status has changed to Historic';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_planned_effective_date is 'Planned Effective Date of the Specification';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_internat_part_no       is 'Partnumber of the International Parent Specification';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_internat_part_revision is 'Revision number of the International Parent Specification';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_frame_id               is 'Short description of the Frame on which the Specification is based';
comment on COLUMN sc_lims_dal_ai.ai_specification.spec_frame_revision         is 'Revision Number of the Frame on which the Specification is based';




--************************************************************************************************************
--2.9.specification_property  ( base-view:  sc_lims_dal.specification_property )
--Authorisation-criteria:    
--only specific section/subsection/propertygroup:
--frame-id: TYRE
--Cap-strip layup:  section_id=700835 and sub_section_id=0 and property_group=702056 and property=965
--M.B.W.:           section_id=700835 and sub_section_id=0 and property_group=186    and property=705212
--Number of plies:  section_id=700835 and sub_section_id=0 and property_group=702056 and property=712615
--Overall diameter: section_id=700835 and sub_section_id=0 and property_group=185    and property=705300
--Section width:    section_id=700835 and sub_section_id=0 and property_group=182    and property=703424
--ETRTO rimwidth:   section_id=700579 and sub_section_id=0 and property_group=701562 and property=705195
--Rim protector radius: 700579	General information	0	(none)	701563	General tyre characteristics	707328	
--Rim protector radius: 700835	D-spec				0	(none)	701565	Master drawing					715440	
--Sidewall type:		700835	D-spec	0	(none)	186		Parent segment	1033	Sidewall type
--c_Ba:					700835	D-spec	0	(none)	701565	Master drawing	715089	c_Ba
--frame-id: BEAD
--Bead width: 700835	D-spec	0	(none)	701560	D-Spec (section)	704651	Bead width
--Bead width: 700835	D-spec	0	(none)	701559	D-Spec (reinforcements)	704651	Bead width
--Bead width: 700584	Properties	0	(none)	701560	D-Spec (section)	704651	Bead width
--Bead width: 700584	Properties	0	(none)	701796	Bead properties	704651	Bead width
--frame-id: VULCANIZED-TYRE
--PCI pressure: 701058	Processing Gyongyoshalasz	702943	702916	PCI	709538	PCI pressure
--PCI pressure: 700583	Processing					700542	702916	PCI	709538	PCI pressure
--PCI pressure: 701058	Processing Gyongyoshalasz	702944	702916	PCI	709538	PCI pressure
--PCI pressure: 701058	Processing Gyongyoshalasz	700542	702916	PCI	709538	PCI pressure
--Dependencies:
--REFERENTIAL-CONSTRAINT: part-no/revision exists in view AI_SPECIFICATION !!!!! (current REVISION of PCR/TBR/OHT-tyres)
--************************************************************************************************************
drop view sc_lims_dal_ai.ai_specification_property;
--
create or replace view sc_lims_dal_ai.ai_specification_property
(part_number                    --Specification Partcode without Revision number
,revision                       --Revision number of the Specification
,section_id                     --identification of a section
,section_revision               --revision-number of a section
,section_description            --section name
,sub_section_id                  --identification of a sub-section
,sub_section_revision            --revision-number of a sub-section
,sub_section_description         --section name
,property_group_id               --identification of a property-group
,property_group_revision         --revision-number of a property-group
,property_group_description      --property-group name
,property_id                     --identification of a property
,property_revision                --revision-number of a property
,property_description             --property-name
,attribute_id                     --Property attribute ID of the Frame Data
,attribute_revision               --revision-number of ther frame-attribute
,attribute_description            --property-attribute-name
,test_method_id                   --Test Method ID of the Frame Data
,test_method_revision             --Test Method Revision of the Frame Data
,test_method_description          --property-test-method-name
,characteristic_id                --characteristic ID of the frame-data
,characteristic_revision         --characteristic Revision of the Frame Data
,characteristic_description       --property-characteristec-name
,association_id                 --association ID of the frame-data
,association_revision           --association Revision of the Frame Data
,association_description        --property-association-name
,uom_id                         --Base Unit Of Measure ID of the property
,uom_revision                   --Base Unit Of Measure Revision of the property
,uom_description                --Base Unit Of Measure of the part
,num_1
,num_2
,num_3
,num_4
,num_5
,num_6
,num_7
,num_8
,num_9
,num_10
,char_1
,char_2
,char_3
,char_4
,char_5
,char_6
,boolean_1
,boolean_2
,boolean_3
,boolean_4
,date_1
,date_2
)
as
SELECT part_number
,revision         
,section_id       
,section_revision 
,section_description
,sub_section_id     
,sub_section_revision
,sub_section_description
,property_group_id      
,property_group_revision
,property_group_description
,property_id               
,property_revision        
,property_description      
,attribute_id              
,attribute_revision        
,attribute_description     
,test_method_id            
,test_method_revision      
,test_method_description   
,characteristic_id         
,characteristic_revision  
,characteristic_description
,association_id            
,association_revision     
,association_description   
,uom_id                    
,uom_revision              
,uom_description
,num_1
,num_2
,num_3
,num_4
,num_5
,num_6
,num_7
,num_8
,num_9
,num_10
,char_1
,char_2
,char_3
,char_4
,char_5
,char_6
,boolean_1
,boolean_2
,boolean_3
,boolean_4
,date_1
,date_2
FROM  sc_lims_dal.specification_property sp
where exists (select '' from sc_lims_dal_ai.ai_specification asp where asp.part_number = sp.part_number and asp.spec_revision = sp.revision) 
and   (   sp.property_id    in (965,705212,712615,705300,703424,705195,707328,715440,1033,715089)   --etrto
      OR  sp.property_id    in (704651)            --bead
	  OR  sp.property_id    in (709538)            --vulc-tyre
      or  sp.property_id    in (715087)            --rim-protector-radius on oracleprod-test
 )
;

--ERROR: value "705212" is out of range for type smallint
--OPLOSSING: zonder string-value dan gaat het wel goed.

--table-comment:
comment on VIEW sc_lims_dal_ai.ai_specification_property   is 'Contains specific specification-properties from CURRENT-PCR/TBR/OHT-tyres';
--column-comment:
comment on COLUMN sc_lims_dal_ai.ai_specification_property.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.revision                    is 'Revision number of the Specification';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.section_id                  is 'identification of a section';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.section_revision            is 'revision-number of a section';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.section_description         is 'section name';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.sub_section_id              is 'identification of a section';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.sub_section_revision        is 'revision-number of a section';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.sub_section_description     is 'section name';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.property_group_id           is 'identification of a property-group';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.property_group_revision     is 'revision-number of a property-group';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.property_group_description  is 'property-group name';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.property_id                 is 'identification of a property';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.property_revision           is 'revision-number of a property';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.property_description        is 'property-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.attribute_id                is 'Property attribute ID of the Frame Data';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.attribute_revision          is 'revision-number of ther frame-attribute';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.attribute_description       is 'property-attribute-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.test_method_id              is 'Test Method ID of the Frame Data';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.test_method_revision        is 'Test Method Revision of the Frame Data';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.test_method_description     is 'property-test-method-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.characteristic_id           is 'characteristic ID of the frame-data';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.characteristic_revision     is 'characteristic Revision of the Frame Data';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.characteristic_description  is 'property-characteristec-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.association_id              is 'association ID of the frame-data';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.association_revision        is 'association Revision of the Frame Data';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.association_description     is 'property-association-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.uom_id                      is 'Base Unit Of Measure ID of the property';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.uom_revision                is 'Base Unit Of Measure Revision of the property';
comment on COLUMN sc_lims_dal_ai.ai_specification_property.uom_description             is 'Base Unit Of Measure of the part';



/*
--Inhoud van SPECIFICATION_PROP zit ook SPECDATA !
--Daarbij zijn de waardes van de NUM-velden alleen uitgesplitst naar aparte records met eigen HEADER-betekenis.
--SPECIFICATION_PROP:
--part-no           section             prop-group  property            uom         test-methode    num-1   num-2   num-3   num-4   num-5
--XM_B07-311	1	700584	100	0	100	701300	200	703173	300	0	100	701089	100	700582	100	500	2.95	2.05	3.85	3.63	2.28												N							0		0	0			0	N	N	N	N			0		0		0		0
--
--PROPERTY:
--703173	RH 190°C
--
--SPECDATA (part_no='XM_B07-311' and property_group=701300 and property=703173):
--part-no           section             ref-id   prop-group property    header-id value  value_s uom    test-method ch  association 
--XM_B07-311	1	700584	0	131	1	701300	200	701300	703173	0	700496	2.05	2.05	701089	700582	900607	900128	-1	0	0		100	100	200	300	100	100	100	0	0	100	0	1
--XM_B07-311	1	700584	0	132	1	701300	200	701300	703173	0	700497	2.28	2.28	701089	700582	900607	900128	-1	0	0		100	100	200	300	100	100	100	0	0	100	0	1
--XM_B07-311	1	700584	0	133	1	701300	200	701300	703173	0	700498	2.95	2.95	701089	700582	900607	900128	-1	0	0		100	100	200	300	100	100	100	0	0	100	0	1
--XM_B07-311	1	700584	0	134	1	701300	200	701300	703173	0	700499	3.63	3.63	701089	700582	900607	900128	-1	0	0		100	100	200	300	100	100	100	0	0	100	0	1
--XM_B07-311	1	700584	0	135	1	701300	200	701300	703173	0	700500	3.85	3.85	701089	700582	900607	900128	-1	0	0		100	100	200	300	100	100	100	0	0	100	0	1
--XM_B07-311	1	700584	0	136	1	701300	200	701300	703173	0	700503	0		N		701089	700582	900607	900128	-1	0	1		100	100	200	300	100	100	100	0	0	200	0	1
--XM_B07-311	1	700584	0	137	1	701300	200	701300	703173	0	700532	0				701089	700582	900607	900128	-1	0	1		100	100	200	300	100	100	100	0	0	300	0	1
--
--Via header-id is te achterhalen welke betekenis de value heeft: header_id
--700496	LSL		1	0
--700497	LWL		1	0
--700498	Target	1	0
--700499	UWL		1	0
--700500	USL		1	0
*/


--************************************************************************************************************
--2.10.specification_data    ( base-view:  sc_lims_dal.specification_property )
--Authorisation-criteria:    
--frame-id: TYRE
--Cap-strip layup:  section_id=700835 and sub_section_id=0 and property_group=702056 and property=965
--M.B.W.:           section_id=700835 and sub_section_id=0 and property_group=186    and property=705212
--Number of plies:  section_id=700835 and sub_section_id=0 and property_group=702056 and property=712615
--Overall diameter: section_id=700835 and sub_section_id=0 and property_group=185    and property=705300
--Section width:    section_id=700835 and sub_section_id=0 and property_group=182    and property=703424
--ETRTO rimwidth:   section_id=700579 and sub_section_id=0 and property_group=701562 and property=705195
--Rim protector radius: 700579	General information	0	(none)	701563	General tyre characteristics	707328	
--Rim protector radius: 700835	D-spec				0	(none)	701565	Master drawing					715440	
--Sidewall type:		700835	D-spec	0	(none)	186		Parent segment	1033	Sidewall type
--c_Ba:					700835	D-spec	0	(none)	701565	Master drawing	715089	c_Ba
--frame-id: BEAD
--Bead width: 700835	D-spec	0	(none)	701560	D-Spec (section)	704651	Bead width
--Bead width: 700835	D-spec	0	(none)	701559	D-Spec (reinforcements)	704651	Bead width
--Bead width: 700584	Properties	0	(none)	701560	D-Spec (section)	704651	Bead width
--Bead width: 700584	Properties	0	(none)	701796	Bead properties	704651	Bead width
--frame-id: VULCANIZED-TYRE
--PCI pressure: 701058	Processing Gyongyoshalasz	702943	702916	PCI	709538	PCI pressure
--PCI pressure: 700583	Processing					700542	702916	PCI	709538	PCI pressure
--PCI pressure: 701058	Processing Gyongyoshalasz	702944	702916	PCI	709538	PCI pressure
--PCI pressure: 701058	Processing Gyongyoshalasz	700542	702916	PCI	709538	PCI pressure
--Dependencies:
--REFERENTIAL-CONSTRAINT: part-no/revision exists in view AI_SPECIFICATION !!!!! (current REVISION of PCR/TBR/OHT-tyres)
--***********************************************************************************************************
create or replace view sc_lims_dal_ai.ai_specification_data
(part_number                    --Specification Partcode without Revision number
,revision                       --Revision number of the Specification
,section_id                     --identification of a section
,section_revision               --revision-number of a section
,section_description            --section name
,sub_section_id                  --identification of a sub-section
,sub_section_revision            --revision-number of a sub-section
,sub_section_description         --section name
,sequence_number                 --sequence-number
,property_group_id               --identification of a property-group
,property_group_revision        --revision-number of a property-group
,property_group_description      --property-group name
,property_id                     --identification of a property
,property_revision              --revision-number of a property
,property_description             --property-name
,header_id                        --Property Header ID of the Frame Data
,header_revision                  --revision-number of ther frame-header
,header_description               --property-header-name
,attribute_id                     --Property attribute ID of the Frame Data
,attribute_revision               --revision-number of ther frame-attribute
,attribute_description            --property-attribute-name
,test_method_id                   --Test Method ID of the Frame Data
,test_method_revision             --Test Method Revision of the Frame Data
,test_method_description          --property-test-method-name
,characteristic_id                --characteristic ID of the frame-data
,characteristic_revision         --characteristic Revision of the Frame Data
,characteristic_description       --property-characteristec-name
,association_id                --association ID of the frame-data
,association_revision         --association Revision of the Frame Data
,association_description       --property-association-name
,spec_value                     --Value of the property assigned to the Specification-property
,spec_value_s                   --String-Value of the property assigned to the Specification-property
,uom_id                         --Base Unit Of Measure ID of the property
,uom_revision                   --Base Unit Of Measure Revision of the property
,uom_description                --Base Unit Of Measure of the part
)
as
SELECT part_number 
,revision          
,section_id        
,section_revision  
,section_description
,sub_section_id     
,sub_section_revision 
,sub_section_description 
,sequence_number         
,property_group_id       
,property_group_revision 
,property_group_description
,property_id            
,property_revision      
,property_description   
,header_id              
,header_revision        
,header_description     
,attribute_id           
,attribute_revision     
,attribute_description  
,test_method_id         
,test_method_revision   
,test_method_description
,characteristic_id      
,characteristic_revision
,characteristic_description
,association_id            
,association_revision      
,association_description   
,spec_value                
,spec_value_s              
,uom_id                    
,uom_revision              
,uom_description
FROM  sc_lims_dal.specification_data       spd
where exists (select '' from sc_lims_dal_ai.ai_specification asp where asp.part_number = spd.part_number and asp.spec_revision = spd.revision) 
and   (   spd.property_id    in (965,705212,712615,705300,703424,705195,707328,715440,1033,715089)   --etrto
      OR  spd.property_id    in (704651)            --bead
	  OR  spd.property_id    in (709538)            --vulc-tyre
	  or  spd.property_id    in (715087)            --rim-protector-radius on oracleprod-test
	  )
;


--table-comment:
comment on VIEW sc_lims_dal_ai.ai_specification_data   is 'Contains all specification-property-data with its values';
--column-comment:
comment on COLUMN sc_lims_dal_ai.ai_specification_data.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.revision                    is 'Revision number of the Specification';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.section_id                  is 'identification of a section';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.section_revision            is 'revision-number of a section';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.section_description         is 'section name';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.sub_section_id              is 'identification of a section';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.sub_section_revision        is 'revision-number of a section';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.sub_section_description     is 'section name';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.sequence_number             is 'sequence-number';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.property_group_id           is 'identification of a property-group';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.property_group_revision    is 'revision-number of a property-group';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.property_group_description  is 'property-group name';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.property_id                 is 'identification of a property';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.property_revision          is 'revision-number of a property';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.property_description        is 'property-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.header_id                   is 'Property Header ID of the Frame Data';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.header_revision             is 'revision-number of ther frame-header';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.header_description          is 'property-header-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.attribute_id                is 'Property attribute ID of the Frame Data';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.attribute_revision          is 'revision-number of ther frame-attribute';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.attribute_description       is 'property-attribute-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.test_method_id              is 'Test Method ID of the Frame Data';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.test_method_revision        is 'Test Method Revision of the Frame Data';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.test_method_description     is 'property-test-method-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.characteristic_id           is 'characteristic ID of the frame-data';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.characteristic_revision    is 'characteristic Revision of the Frame Data';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.characteristic_description  is 'property-characteristec-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.association_id              is 'association ID of the frame-data';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.association_revision       is 'association Revision of the Frame Data';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.association_description     is 'property-association-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.spec_value                  is 'Value of the property assigned to the Specification-property';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.spec_value_s                is 'String-Value of the property assigned to the Specification-property';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.uom_id                      is 'Base Unit Of Measure ID of the property';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.uom_revision                is 'Base Unit Of Measure Revision of the property';
comment on COLUMN sc_lims_dal_ai.ai_specification_data.uom_description             is 'Base Unit Of Measure of the part';


--************************************************************************************************************
--2.11.SPECIFICATION_BOM_HEADER     ( base-view:  sc_lims_dal.specification_bom_header )
--Authorisation-criteria:    
--none
--Dependencies:
--REFERENTIAL-CONSTRAINT: none
--************************************************************************************************************
drop view sc_lims_dal_ai.ai_specification_bom_header;
--
create or replace view sc_lims_dal_ai.ai_specification_bom_header
(part_number                    --Specification Partcode without Revision number
,revision                       --Revision number of the Specification
,plant                          --the Plant for which the BOM has been created
,plant_description              --Full description of the Plant for which the BOM has been created
,alternative                    --BOM Alternative, 1=current, 2=alternative
,base_quantity                  --Base quantity of the BOM as defined in the BOM Header
,description                    --BOM Header Description
,conversion_factor              --BOM Conversion Factor of the Spec BOM
,bom_type                       --BOM Type: FP (Percentage BOM) or FQ (Quantity BOM)
,bom_usage                      --BOM Usage: returns a numeric value: 1.00 for PROD, 5.00 for SALES and 6.00 for COST
,min_qty                        --Minimum Base quantity of the BOM as defined in the BOM Header
,max_qty                        --Maximum Base quantity of the BOM as defined in the BOM Header
,plant_effective_date           --BOM Planned Effective Date (as defined in the BOM Header)
,preferred                      --BOM Preferred of the Spec BOM
)
as
select bh.part_number
,      bh.revision
,      bh.plant
,      bh.plant_description
,      bh.alternative
,      bh.base_quantity
,      bh.description
,      bh.conversion_factor
,      bh.bom_type
,      bh.bom_usage
,      bh.min_qty
,      bh.max_qty
,      bh.plant_effective_date
,      bh.preferred
from sc_lims_dal.specification_bom_header  bh
where bh.revision = (select max(bh2.revision) from sc_lims_dal.specification_bom_header bh2 where bh2.part_number = bh.part_number )
;
--BOM-HEADER bevat naast tyre ook alle components zonder directe relatie naar een PCR/TBR/OHT-tyre !!!
--We kunnen hier dus niet zomaar een extra AUTH-CRITERIA op zetten !!! Zou eventueel alleen kunnen op nieuwe DBA_WEIGHT_COMPONENT_PART ?
--where exists (select '' from sc_lims_dal_ai.ai_specification asp where asp.part_number = spd.part_number and asp.spec_revision = spd.revision) 


--table-comment:
comment on VIEW sc_lims_dal_ai.ai_specification_bom_header   is 'Contains all specification-headers of tyres and all related components of that tyre';
--column-comment:
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.revision                    is 'Revision number of the Specification';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.plant                       is 'the Plant for which the BOM has been created';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.plant_description           is 'Full description of the Plant for which the BOM has been created';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.alternative                 is 'BOM Alternative, 1=current, 2=alternative';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.base_quantity               is 'Base quantity of the BOM as defined in the BOM Header';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.description                 is 'BOM Header Description';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.conversion_factor           is 'BOM Conversion Factor of the Spec BOM';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.bom_type                    is 'BOM Type: FP (Percentage BOM) or FQ (Quantity BOM)';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.bom_usage                   is 'BOM Usage: returns a numeric value: 1.00 for PROD, 5.00 for SALES and 6.00 for COST';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.min_qty                     is 'Minimum Base quantity of the BOM as defined in the BOM Header';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.max_qty                     is 'Maximum Base quantity of the BOM as defined in the BOM Header';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.plant_effective_date        is 'BOM Planned Effective Date (as defined in the BOM Header)';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_header.preferred                   is 'BOM Preferred of the Spec BOM';

--************************************************************************************************************
--2.12.SPECIFICATION_BOM_ITEM          ( base-view:  sc_lims_dal.specification_bom_item )
--Authorisation-criteria:    
--none
--Dependencies:
--REFERENTIAL-CONSTRAINT: none
--************************************************************************************************************
drop view sc_lims_dal_ai.ai_specification_bom_item;
--
create or replace view sc_lims_dal_ai.ai_specification_bom_item
(part_number                    --Specification-header Partcode without Revision number
,revision                       --Revision number of the Specification-header
,plant                          --the Plant for which the BOM-header has been created
,plant_description              --Full description of the Plant for which the BOM-header has been created
,alternative                    --BOM Alternative, 1=current, 2=alternative
,item_number                    --Number of component-part within a heading-tyre/component
,component_part                 --Specification-item-component/material Partcode without Revision number
,component_revision             --Revision number of the Specification-item-component/material
,component_plant                --the Plant for which the BOM-item-component has been created
,component_plant_description    --Full description of the Plant for which the BOM-item-component has been created
,quantity                       --Quantity of the BOM Item in a BOM
,uom                            --Base UOM of the BOM Item
,num_1
,num_2
,num_3
,num_4
,num_5
,char_1
,char_2
,char_3
,char_4
,char_5
,date_1
,date_2
,ch_1                              --characteristic ID of the first bom-item-data
,characteristic_1_description      --first bom-item-characteristec-name
,ch_2                              --characteristic ID of the second bom-item-data
,characteristic_2_description      --second bom-item-characteristec-name
,ch_3                              --characteristic ID of the third bom-item-data
,characteristic_3_description      --third bom-item-characteristec-name
)
as
select bi.part_number
,      bi.revision
,      bi.plant
,      bi.plant_description
,      bi.alternative
,      bi.item_number
,      bi.component_part
,      bi.component_revision
,      bi.component_plant
,      bi.component_plant_description
,      bi.quantity
,      bi.uom
,      bi.num_1
,      bi.num_2
,      bi.num_3
,      bi.num_4
,      bi.num_5
,      bi.char_1
,      bi.char_2
,      bi.char_3
,      bi.char_4
,      bi.char_5
,      bi.date_1
,      bi.date_2
,      bi.ch_1
,      bi.characteristic_1_description
,      bi.ch_2
,      bi.characteristic_2_description
,      bi.ch_3
,      bi.characteristic_3_description
from sc_lims_dal.specification_bom_item       bi
where bi.revision = (select max(bh.revision) from sc_lims_dal.specification_bom_header bh where bh.part_number = bi.part_number )
;
--in VIEW SC_LIMS_DAL zit NOG geen selectie op meest-actuele revision...
--where bi.revision = (select max(bh.revision) from sc_lims_dal.specification_bom_header bh where bh.part_number = bi.part_number )
--
--BOM-ITEM bevat naast tyre ook alle components zonder directe relatie naar een PCR/TBR/OHT-tyre !!!
--We kunnen hier dus niet zomaar een extra AUTH-CRITERIA op zetten !!! Zou eventueel alleen kunnen op nieuwe DBA_WEIGHT_COMPONENT_PART ?
--where exists (select '' from sc_lims_dal_ai.ai_specification asp where asp.part_number = spd.part_number and asp.spec_revision = spd.revision) 


--table-comment:
comment on VIEW sc_lims_dal_ai.ai_specification_bom_item   is 'Contains from latest BOM-HEADER-revisions the specification-bom_items NOT ONLY related to PCR/TBR/OHT-tyres and components';
--column-comment:
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.revision                    is 'Revision number of the Specification-header';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.plant                       is 'the Plant for which the BOM-header has been created';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.plant_description           is 'Full description of the Plant for which the BOM-header has been created';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.alternative                 is 'BOM Alternative, 1=current, 2=alternative';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.item_number                 is 'Number of component-part within a heading-tyre/component';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.component_part              is 'Specification-item-component/material Partcode without Revision number';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.component_revision          is 'Revision number of the Specification-item-component/material';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.component_plant             is 'the Plant for which the BOM-item-component has been created';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.component_plant_description is 'Full description of the Plant for which the BOM-item-component has been created';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.quantity                    is 'Quantity of the BOM Item in a BOM';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.uom                         is 'Base UOM of the BOM Item';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.ch_1                        is 'characteristic ID of the first bom-item-data';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.characteristic_1_description is 'first bom-item-characteristec-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.ch_2                         is 'characteristic ID of the second bom-item-data';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.characteristic_2_description is 'second bom-item-characteristec-name';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.ch_3                         is 'characteristic ID of the third bom-item-data';
comment on COLUMN sc_lims_dal_ai.ai_specification_bom_item.characteristic_3_description is 'third bom-item-characteristec-name';


--************************************************************************************************************
--2.13.SPECIFICATION_FULL_BOM_ITEM      ( base-view:  sc_lims_dal.specification_bom_item_full )
--Authorisation-criteria:    
--none
--Dependencies:
--REFERENTIAL-CONSTRAINT: none
--************************************************************************************************************
DROP VIEW sc_lims_dal_ai.AI_SPECIFICATION_BOM_ITEM_FULL;
--Create VIEW ALL BOM-ITEMS-REVISIONS incl STATUS + MAX(REVISION)
CREATE or REPLACE view sc_lims_dal_ai.AI_SPECIFICATION_BOM_ITEM_FULL
(part_number
,revision
,issueddate
,obsolescencedate
,plant
,alternative
,preferred
,status
,sort_desc
,status_type
,description
,frame_id
,component_part
,componentrevisionmax
,componentrevisioncurrent
,quantity
,uom
,ch_1
,functiecode 
)
as
select part_number
,revision
,issueddate
,obsolescencedate
,plant
,alternative
,preferred
,status
,sort_desc
,status_type
,description
,frame_id
,component_part
,componentrevisionmax
,componentrevisioncurrent
,quantity
,uom
,ch_1
,functiecode 
from sc_lims_dal.specification_bom_item_full   bi
; 


--************************************************************************************************************
--2.14.SPEC_BOM_ITEM_CURRENT_TREE
--************************************************************************************************************
drop view sc_lims_dal_ai.AI_SPEC_BOM_ITEM_CURRENT_TREE;
--Create VIEW ALL BOM-ITEMS-REVISIONS incl STATUS + MAX(REVISION)
CREATE or REPLACE view sc_lims_dal_ai.AI_SPEC_BOM_ITEM_CURRENT_TREE
(part_number
,revision
,issueddate
,obsolescencedate
,plant
,alternative
,preferred
,status
,sort_desc
,status_type
,description
,frame_id
,component_part
,quantity
,uom
,ch_1
,functiecode 
)
as
select part_number
,revision
,issueddate
,obsolescencedate
,plant
,alternative
,preferred
,status
,sort_desc
,status_type
,description
,frame_id
,component_part
,quantity
,uom
,ch_1
,functiecode 
from sc_lims_dal.SPEC_BOM_ITEM_CURRENT_TREE bi
;


--************************************************************************************************************
--2.14.SPEC_BOM_ITEM_ALL_REV_TREE
--************************************************************************************************************
drop view sc_lims_dal_ai.AI_SPEC_BOM_ITEM_ALL_REV_TREE;
--Create VIEW ALL BOM-ITEMS-REVISIONS incl STATUS + MAX(REVISION)
CREATE or REPLACE view sc_lims_dal_ai.AI_SPEC_BOM_ITEM_ALL_REV_TREE
(part_number
,revision
,issueddate
,obsolescencedate
,plant
,alternative
,preferred
,status
,sort_desc
,status_type
,description
,frame_id
,component_part
,quantity
,uom
,ch_1
,functiecode 
)
as
select part_number
,revision
,issueddate
,obsolescencedate
,plant
,alternative
,preferred
,status
,sort_desc
,status_type
,description
,frame_id
,component_part
,quantity
,uom
,ch_1
,functiecode 
from sc_lims_dal.SPEC_BOM_ITEM_ALL_REV_TREE bi
;


--uitvragen van de BOM mbv deze view:
/*
WITH RECURSIVE bom_item_header(level, part_no, revision, component_part, path) 
AS (SELECT  1
   ,        b.part_number
   ,        b.revision
   ,        b.component_part
   ,        CAST(b.component_part AS VARCHAR(1000))  
   FROM    sc_lims_dal_ai.AI_SPEC_BOM_ITEM_CURRENT_TREE   b
   WHERE   b.part_number    = 'EF_V215/45R16A4GX'     
   UNION ALL 
   SELECT bh.level + 1
   ,      BI.part_number
   ,      BI.revision
   ,      BI.component_part
   ,      concat( concat( bh.path, '/'), BI.COMPONENT_PART) AS path
   FROM    sc_lims_dal.SPEC_BOM_ITEM_CURRENT_TREE  bi
   ,       bom_item_header                         bh
   WHERE   bh.component_part = bi.part_number
  )
SELECT * FROM bom_item_header
;
*/




--einde script


