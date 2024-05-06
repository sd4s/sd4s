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
--1.FRAMES
--1.1.FRAME          (replicated without access/user-group-descriptions )
--1.2.FRAME_KEYWORD      
--1.3.FRAME_DATA     (couldn't be replicated to redshift)

--************************************************************************************************************
--1.FRAMES 
--************************************************************************************************************

--************************************************************************************************************
--1.1.FRAME      (kon niet met alle gerelateerde tabellen gerepliceerd worden)
--************************************************************************************************************
--TABEL workflow_group WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 17-05-2022 !!!!!!!
--TABEL user_access_group WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 17-05-2022 !!!!!!!
--TABEL user_group_list WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 17-05-2022 !!!!!!!

/*
create or replace view sc_lims_dal.frame
(frame_number                --short name of a frame
,frame_revision              --revision-number of a frame
,frame_name                  --short name of the frame without revision
,owner                       --owner db of the frame
,description                 --frame description with revision-number
,status                      --frame status
,frame_type                  --Short description of the Specification Type assigned to Frame
,international               --Whether the Frame is International or not (Yes, No)
,workflow_group_id           --identification of the Workflow Group assigned to the Frame
,workflow_group_description  --Short description of the Workflow Group assigned to the Frame
,access_group                --identification of the Access Group assigned to the Frame
,access_group_description    --Short description of the Access Group assigned to the Frame
,access_user_group_id        --This object should be added to the query to apply the InterSpec access control (only those Specifications will be returned where the user has access to). The result shows the User-GROUP-ID.
,access_user_id              --This object should be added to the query to apply the InterSpec access control (only those Specifications will be returned where the user has access to). The result shows the User ID.
,status_change_date          --Date on which the Frame Status has been changed
,created_by                  --User ID of User who created the Frame
,created_on                  --Date of Frame Creation
,last_modified_by            --User ID of User who made the last changes to the Frame
,last_modified_on            --Date of last modification
)
as
select fh.frame_no
,      fh.frame_revision
,      fh.frame_no ||' ['||fh.frame_revision||']'
,      fh.owner                       --f_owner_descr(fh.owner)
,      fh.description
,      DECODE(fh.STATUS,1,'In development',2,'Current',3,'Historic',4,'Obsolete',5,'Used',to_char(fh.STATUS))
,      fh.sort_desc
,      DECODE(fh.INTL,0,'No',1,'Yes','?')
,      fh.workflow_group_id
,      wfg.sort_desc
,      fh.access_group
,      ag.sort_desc
,      uag.user_group_id
,      ugl.user_id
,      fh.status_change_date
,      fh.created_by
,      fh.created_on
,      fh.last_modified_by  
,      fh.last_modified_on
from sc_interspec_ens.frame_header            fh
,    sc_interspec_ens.workflow_group          wfg
,    sc_interspec_ens.access_group            ag
,    sc_interspec_ens.user_access_group       uag
,    sc_interspec_ens.user_group_list         ugl
where fh.workflow_group_id = wfg.workflow_group_id
and   fh.access_group      = ag.access_group
and   ag.access_group      = uag.access_group
and   uag.user_group_id    = ugl.user_group_id
;
*/

create or replace view sc_lims_dal.frame
(frame_number                --short name of a frame
,frame_revision              --revision-number of a frame
,frame_name                  --short name of the frame without revision
,owner                       --owner db of the frame
,description                 --frame description with revision-number
,status                      --frame status
,frame_type                  --Short description of the Specification Type assigned to Frame
,international               --Whether the Frame is International or not (Yes, No)
,workflow_group_id           --identification of the Workflow Group assigned to the Frame
,access_group                --identification of the Access Group assigned to the Frame
,access_group_description    --Short description of the Access Group assigned to the Frame
,status_change_date          --Date on which the Frame Status has been changed
,created_by                  --User ID of User who created the Frame
,created_on                  --Date of Frame Creation
,last_modified_by            --User ID of User who made the last changes to the Frame
,last_modified_on            --Date of last modification
)
as
select fh.frame_no
,      fh.revision
,      fh.frame_no ||' ['||fh.revision||']'
,      fh.owner                       --f_owner_descr(fh.owner)
,      fh.description
,      CASE fh.status when 1 then 'In development'
                      when 2 then 'Current'
					  when 3 then 'Historic'
					  when 4 then 'Obsolete'
					  when 5 then 'Used'
					  else 'unknown'
					  end
,      fh.description
,      DECODE(fh.INTL,0,'No',1,'Yes','?')
,      fh.workflow_group_id
,      fh.access_group
,      ag.sort_desc
,      fh.status_change_date
,      fh.created_by
,      fh.created_on
,      fh.last_modified_by  
,      fh.last_modified_on
from sc_interspec_ens.frame_header            fh
,    sc_interspec_ens.access_group            ag
where fh.access_group      = ag.access_group
;

--table-comment:
comment on VIEW sc_lims_dal.frame is 'Contains all FRAME-templates, new specifications are being made on base of a frame';

--column-comment:
comment on COLUMN sc_lims_dal.frame.frame_number               is 'short name of a frame';
comment on COLUMN sc_lims_dal.frame.frame_revision             is 'revision-number of a frame';
comment on COLUMN sc_lims_dal.frame.frame_name                 is 'short name of the frame without revision';
comment on COLUMN sc_lims_dal.frame.owner                      is 'owner db of the frame';
comment on COLUMN sc_lims_dal.frame.description                is 'frame description with revision-number';
comment on COLUMN sc_lims_dal.frame.status                     is 'frame status';
comment on COLUMN sc_lims_dal.frame.frame_type                 is 'Short description of the Specification Type assigned to Frame';
comment on COLUMN sc_lims_dal.frame.international              is 'Whether the Frame is International or not (Yes, No)';
comment on COLUMN sc_lims_dal.frame.workflow_group_id          is 'identification of the Workflow Group assigned to the Frame';
comment on COLUMN sc_lims_dal.frame.access_group               is 'identification of the Access Group assigned to the Frame';
comment on COLUMN sc_lims_dal.frame.access_group_description   is 'Short description of the Access Group assigned to the Frame';
comment on COLUMN sc_lims_dal.frame.status_change_date         is 'Date on which the Frame Status has been changed';
comment on COLUMN sc_lims_dal.frame.created_by                 is 'User ID of User who created the Frame';
comment on COLUMN sc_lims_dal.frame.created_on                 is 'Date of Frame Creation';
comment on COLUMN sc_lims_dal.frame.last_modified_by           is 'User ID of User who made the last changes to the Frame';
comment on COLUMN sc_lims_dal.frame.last_modified_on           is 'Date of last modification';

--************************************************************************************************************
--1.2.FRAME_KEYWORD      
--************************************************************************************************************
create or replace view sc_lims_dal.frame_keyword
(frame_number                --short name of a frame
,keyword_id                  --Identification of a keyword
,kewyword_name               --Keyword Name
)
as
select fkw.frame_no
,      fkw.kw_id              --
,      kw.description        --iapiRM.rmf_kw_descr(@Prompt('Language:','N','Where clauses\Language ID',mono,constrained),RPMV_FRAME_KW.KW_ID)
from sc_interspec_ens.frame_kw       fkw
,    sc_interspec_ens.itkw           kw
where fkw.kw_id = kw.kw_id
;
--table-comment:
comment on VIEW sc_lims_dal.frame_keyword is 'Contains all FRAME-keywords';

--column-comment:
comment on COLUMN sc_lims_dal.frame_keyword.frame_number             is 'short name of a frame';
comment on COLUMN sc_lims_dal.frame_keyword.keyword_id               is 'Identification of a keyword';
comment on COLUMN sc_lims_dal.frame_keyword.kewyword_name            is 'Keyword Name';

/*
--************************************************************************************************************
--1.3.FRAME_DATA     (kan niet worden gerepliceerd)
--************************************************************************************************************
--TABEL FRAMEDATA WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 17-05-2022 !!!!!!!
--
create or replace view sc_lims_dal.frame_data
(frame_number                --short name of a frame
,frame_revision              --revision-number of a frame
,section_id                  --identification of a section
,section_revision            --revision-number of a section
,section_description         --section name
,sub_section_id                  --identification of a section
,sub_section_revision            --revision-number of a section
,sub_section_description         --section name
,sequence_number                 --sequence-number
,property_group_id               --identification of a property-group
,property_group_revsision        --revision-number of a property-group
,property_group_description      --property-group name
,property_id                     --identification of a property
,property_revsision              --revision-number of a property
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
,characteristic_revsision         --characteristic Revision of the Frame Data
,characteristic_description       --property-characteristec-name
,association_id                --association ID of the frame-data
,association_revsision         --association Revision of the Frame Data
,association_description       --property-association-name
)
as
select fd.frame_no
,      fd.revision
,      fd.section_id
,      fd.section_rev
,      sec.description
,      fd.sub_section_id
,      fd.sub_section_rev
,      ss.description
,      fd.property_group
,      fd.property_group_rev
,      pg.description 
,      fd.property
,      fd.property_rev
,      pr.description 
,      fd.header_id
,      fd.header_rev
,      he.description
,      fd.attribute
,      fd.attribute_rev
,      att.description
,      fd.test_method
,      fd.test_method_rev
,      tm.description
,      fd,characteristic
,      fd.characteristic_rev
,      ch.description
,      fd.association
,      fd.association_rev
,      ass.description
from sc_interspec_ens.framedata        fd
,    sc_interspec_ens.section          sec
,    sc_interspec_ens.sub_section      ss
,    sc_interspec_ens.property_group   pg
,    sc_interspec_ens.propertry        pr
,    sc_interspec_ens.header           he
,    sc_interspec_ens.attribute        att
,    sc_interspec_ens.test_method      tm
,    sc_interspec_ens.characteristic   ch
,    sc_interspec_ens.association      ass
where fd.section_id     = sec.section_id
and   fd.sub_section_id = ss.sub_section_id
and   fd.property_group = pg.property_group
and   fd.property       = pr.property
and   fd.header_id      = he.header_id
and   fd.attribute      = att.attribute
and   fd.test_method    = tm.test_method
and   fd.characteristic = ch.characteristic
and   fd.association    = ass.association
;
*/


--************************************************************************************************************
--****   OPERATIONAL 
--************************************************************************************************************
--2.SPECIFICATIONS
--
--2.1.Specification                 (couldn't replicate alle reference-tables)
--2.2.Specification_part            (couldn't replicate alle reference-tables)
--2.3.Specification_keyword   
--2.4.SPECIFICATION_CLASSIFICATION   
--2.5.SPEC_PART_MANUFACTURER        (couldn't replicate with keywords)
--2.6.SPEC_PART_PLANT               (couldn't replicate with keywords)
--2.7.specification_section    
--2.8.specification_section_text    (couldn't replicate because of BLOB-TEXT)
--2.9.specification_property    
--2.10.specification_data    
--2.11.SPECIFICATION_BOM_HEADER
--2.12.SPECIFICATION_BOM_ITEM
--

--************************************************************************************************************
--2.1.Specification   (kan niet met referentietabellen worden gerepliceerd)
--************************************************************************************************************
--TABEL workflow_group WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 17-05-2022 !!!!!!!
--TABEL work_flow      WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 17-05-2022 !!!!!!!

--relation:  specification_header:workflow_group = (0/1/n):1
--           workflow_group:work_flow            = (0/1/n):1
--
--SPECS: 326844 
--************************************************************************************************************

create or replace view sc_lims_dal.specification
(part_number                 --Specification Partcode without Revision number
,spec_revision               --Revision number of the Specification
,spec_description            --Spec Description of the Spec Header
,spec_created_by             --Full Name of the User who created the Specification
,spec_created_on             --Date on which Specification has been created
,workflow_group_id           --Identification of the Workflowgroup assigned to the Specification
,spec_last_modified_by       --Name of the User who made the last change(s) to the Specification
,spec_last_modified_on       --Date of last modification
,spec_status_change_date     --Date of the last Status Change
,spec_phase_in_tolerance     --Spec Phase In Tolerance of the Spec Header
,spec_locked                 --Name of the User who locked to the Specification
,spec_issued_date            --Date on which Specification has become Current
,spec_status_id              --ID of the Specification Status
,status                      --Short description of the Specification Status
,status_description          --Full description of the Specification Status
,status_type                 --Status Type to which the Specification Status belongs
,spec_type_ID                --Identification of Specification Type
,spec_type                   --Short description of Specification Type
,spec_type_description       --Full description of Specification Type
,spec_type_group             --Specification Type Group to which the Specification Type belongs
,spec_ped_in_sync            --Synchronized Planned-Effective Dates
,spec_obsolescence_date      --Date on which the Specification Status has changed to Historic
,spec_planned_effective_date --Planned Effective Date of the Specification
,spec_internat_part_no       --Partnumber of the International Parent Specification
,spec_internat_part_revision --Revision number of the International Parent Specification
,spec_frame_id               --Short description of the Frame on which the Specification is based
,spec_frame_revision         --Revision Number of the Frame on which the Specification is based
)
as
select sh.part_no
,      sh.revision
,      sh.description
,      sh.created_by
,      sh.created_on
,      sh.workflow_group_id
,      sh.last_modified_by
,      sh.last_modified_on
,      sh.status_change_date
,      sh.phase_in_tolerance
,      sh.locked
,      sh.issued_date
,      sh.status
,      st.sort_desc
,      st.description
,      st.status_type
,      sh.class3_id
,      spt.sort_desc
,      spt.description
,      spt.type
,      sh.ped_in_sync
,      sh.obsolescence_date
,      sh.planned_effective_date
,      sh.int_part_no
,      sh.int_part_rev
,      sh.frame_id
,      sh.frame_rev
from sc_interspec_ens.specification_header sh
,    sc_interspec_ens.status               st
,    sc_interspec_ens.class3               spt
where sh.status        = st.status
and   sh.class3_id     = spt.class
;

--select spec_frame_id, count(*) from sc_lims_dal.specification group by spec_frame_id;
--SELECT * FROM sc_lims_dal.specification WHERE spec_frame_id ='A_PCR_v1';

--table-comment:
comment on VIEW sc_lims_dal.specification is 'Contains all SPECIFICATION-HEADERS, all statusses.';

--column-comment:
comment on COLUMN sc_lims_dal.specification.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal.specification.spec_revision               is 'Revision number of the Specification';
comment on COLUMN sc_lims_dal.specification.spec_description            is 'Spec Description of the Spec Header';
comment on COLUMN sc_lims_dal.specification.spec_created_by             is 'Full Name of the User who created the Specification';
comment on COLUMN sc_lims_dal.specification.spec_created_on             is 'Date on which Specification has been created';
comment on COLUMN sc_lims_dal.specification.workflow_group_id           is 'Identification of the Workflowgroup assigned to the Specification';
comment on COLUMN sc_lims_dal.specification.spec_last_modified_by       is 'Name of the User who made the last change(s) to the Specification';
comment on COLUMN sc_lims_dal.specification.spec_last_modified_on       is 'Date of last modification';
comment on COLUMN sc_lims_dal.specification.spec_status_change_date     is 'Date of the last Status Change';
comment on COLUMN sc_lims_dal.specification.spec_phase_in_tolerance     is 'Spec Phase In Tolerance of the Spec Header';
comment on COLUMN sc_lims_dal.specification.spec_locked                 is 'Name of the User who locked to the Specification';
comment on COLUMN sc_lims_dal.specification.spec_issued_date            is 'Date on which Specification has become Current';
comment on COLUMN sc_lims_dal.specification.spec_status_id              is 'ID of the Specification Status';
comment on COLUMN sc_lims_dal.specification.status                      is 'Short description of the Specification Status';
comment on COLUMN sc_lims_dal.specification.status_description          is 'Full description of the Specification Status';
comment on COLUMN sc_lims_dal.specification.status_type                 is 'Status Type to which the Specification Status belongs';
comment on COLUMN sc_lims_dal.specification.spec_type_ID                is 'Identification of Specification Type';
comment on COLUMN sc_lims_dal.specification.spec_type                   is 'Short description of Specification Type';
comment on COLUMN sc_lims_dal.specification.spec_type_description       is 'Full description of Specification Type';
comment on COLUMN sc_lims_dal.specification.spec_type_group             is 'Specification Type Group to which the Specification Type belongs';
comment on COLUMN sc_lims_dal.specification.spec_ped_in_sync            is 'Synchronized Planned-Effective Dates';
comment on COLUMN sc_lims_dal.specification.spec_obsolescence_date      is 'Date on which the Specification Status has changed to Historic';
comment on COLUMN sc_lims_dal.specification.spec_planned_effective_date is 'Planned Effective Date of the Specification';
comment on COLUMN sc_lims_dal.specification.spec_internat_part_no       is 'Partnumber of the International Parent Specification';
comment on COLUMN sc_lims_dal.specification.spec_internat_part_revision is 'Revision number of the International Parent Specification';
comment on COLUMN sc_lims_dal.specification.spec_frame_id               is 'Short description of the Frame on which the Specification is based';
comment on COLUMN sc_lims_dal.specification.spec_frame_revision         is 'Revision Number of the Frame on which the Specification is based';

--************************************************************************************************************
--2.2.Specification_part   (kan niet met ALLE gerelateerde referentietabellen worden gerepliceerd)
--************************************************************************************************************
--TABEL ITPRNOTE WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 17-05-2022 !!!!!!!

--relation: part:specification_header = 1:n
--          part:itprnote             = 1:(0/1)
/*
create or replace view sc_lims_dal.specification_part
(part_number            --part-number of the part-header
,part_source            --Source of the Partcode, I-S means Internal Interspec
,part_description       --description of the part-header
,part_base_uom          --Base Unit Of Measure of the part
,part_note              --Header Note
)
as
select pa.part_no
,      pa.part_source
,      sh.description
,      pa.uom
,      no.text
from sc_interspec_ens.part                 pa
,    sc_interspec_ens.specification_header sh
,    sc_interspec_ens.itprnote             no
where pa.part_no = sh.part_no
and   pa.part_no = no.part_no(+)
;
*/

create or replace view sc_lims_dal.specification_part
(part_number            --part-number of the part-header
,part_source            --Source of the Partcode, I-S means Internal Interspec
,part_description       --description of the part-header
,part_base_uom          --Base Unit Of Measure of the part
)
as
select pa.part_no
,      pa.part_source
,      sh.description
,      pa.base_uom
from sc_interspec_ens.part                 pa
,    sc_interspec_ens.specification_header sh
where pa.part_no = sh.part_no
;
--table-comment:
comment on VIEW sc_lims_dal.specification_part   is 'Contains all PARTS (tyres) with a specific specification, all statusses ';

--column-comment:
comment on COLUMN sc_lims_dal.specification_part.part_number         is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal.specification_part.part_source         is 'Source of the Partcode, I-S means Internal Interspec';
comment on COLUMN sc_lims_dal.specification_part.part_description    is 'description of the part-header';
comment on COLUMN sc_lims_dal.specification_part.part_base_uom       is 'Base Unit Of Measure of the part';


--************************************************************************************************************
--2.3.Specification_keyword   
--************************************************************************************************************
--TABEL ITPRNOTE WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 17-05-2022 !!!!!!!

--relation: part:specification_kw = 1:n

create or replace view sc_lims_dal.specification_keyword
(part_number              --part-number of the part-header
,keyword_id               --Value of the Keyword assigned to the Specification
,keyword_name             --Name of the Keyword in the Reference Language
,keyword_value            --Value of the Keyword assigned to the Specification
)
as
select kw.part_no
,      kw.kw_id
,      kw.kw_id            --iapiRM.rmf_kw_descr(@Select(Where clauses\Default Language ID),RPMV_SPECIFICATION_KW.KW_ID)
,      kw.kw_value
from sc_interspec_ens.specification_kw  KW
;
--table-comment:
comment on VIEW sc_lims_dal.specification_keyword   is 'Contains all specification keywords';
--column-comment:
comment on COLUMN sc_lims_dal.specification_keyword.part_number         is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal.specification_keyword.keyword_id          is 'Value of the Keyword assigned to the Specification';
comment on COLUMN sc_lims_dal.specification_keyword.keyword_name        is 'Name of the Keyword in the Reference Language';
comment on COLUMN sc_lims_dal.specification_keyword.keyword_value       is 'Value of the Keyword assigned to the Specification';

--RMPV1_CLASSIFICATION (hier zit autorisatie-check ook in, en levert om die reden 0-rijen op)
--itprcl = part-classification
--
--relation:  specification_header:classification = 1:(0/1)

--************************************************************************************************************
--2.4.SPECIFICATION_CLASSIFICATION   
--************************************************************************************************************

CREATE OR REPLACE VIEW sc_lims_dal.SPECIFICATION_CLASSIFICATION
(PART_NUMBER                         --part-number of the part-header
,part_node                           --part-classification-type (exists only one type)
,part_classification_type            --Part Classification Type of the Part Classification
,part_classification_tree_type       --Part Classification Tree Type of the Part Classification
,part_classification_hierarchy_level --Part Classification Hierarchy Level of the Part Classification
,part_classification_name            --Part Classification Name of the Part Classification
,part_classification_value           --Part Classification Value of the Part Classification
) 
AS 
SELECT sh.part_no
,      d.node
,      1 AS cf_seq
,      d.spec_group as treetype
,      pr.hier_level
,      mcn.long_name
,      mcd.long_name
FROM sc_interspec_ens.specification_header sh
,    sc_interspec_ens.class3               c3
,    sc_interspec_ens.itcld                d
,    sc_interspec_ens.itprcl               pr
,    sc_interspec_ens.material_class       mcn
,    sc_interspec_ens.material_class       mcd
WHERE sh.class3_id = c3.CLASS 
AND   d.spec_group = c3.TYPE
and   (   sh.part_no = pr.part_no
      and d.node     = pr.type )
and   (   pr.type = mcn.code	  
      and mcn.identifier > 0   )
and   (   pr.matl_class_id = mcd.identifier	  
      and mcd.identifier > 0   )
UNION
SELECT a.part_no
,      AT.code
,      DECODE (AT.TYPE, 'TV', 2, 3) AS cf_seq
,      null
,      null
,      null
,      null
FROM sc_interspec_ens.itprcl a
,    sc_interspec_ens.itclat AT
WHERE a.TYPE = AT.code
;

--table-comment:
comment on VIEW sc_lims_dal.SPECIFICATION_CLASSIFICATION   is 'Contains all specification PART classification';
--column-comment:
comment on COLUMN sc_lims_dal.SPECIFICATION_CLASSIFICATION.part_number                         is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal.SPECIFICATION_CLASSIFICATION.PART_NODE                           is 'part-classification-type (exists only one type)';
comment on COLUMN sc_lims_dal.SPECIFICATION_CLASSIFICATION.part_classification_type            is 'Part Classification Type of the Part Classification';
comment on COLUMN sc_lims_dal.SPECIFICATION_CLASSIFICATION.part_classification_tree_type       is 'Part Classification Tree Type of the Part Classification';
comment on COLUMN sc_lims_dal.SPECIFICATION_CLASSIFICATION.part_classification_hierarchy_level is 'Part Classification Hierarchy Level of the Part Classification';
comment on COLUMN sc_lims_dal.SPECIFICATION_CLASSIFICATION.part_classification_name            is 'Part Classification Name of the Part Classification';
comment on COLUMN sc_lims_dal.SPECIFICATION_CLASSIFICATION.part_classification_value           is 'Part Classification Value of the Part Classification';


--************************************************************************************************************
--2.5.SPEC_PART_MANUFACTURER     (kan niet met keywords worden gesynchroniseerd)
--************************************************************************************************************
--TABEL itmfckw WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 17-05-2022 !!!!!!!

--itmfc   = manufacturer
--itprmfc = part/manufacturer koppeltabel
--
--relation: part:ifprmfc  = 1:(0/1/n)
--          itprmfc:itmfc = 1:(0/1/n)
--          ifmfc:itmfckw = 1:(0/1/n)
/*
CREATE OR REPLACE VIEW sc_lims_dal.SPEC_PART_MANUFACTURER
(PART_NUMBER                      --part-number of the part-header
,manufacturer_id                  --ID of the Manufacturer assigned to the Specification header
,manufacturer_trade_name          --trade name
,manufacturer_plant_id            --Plant to which the Manufacturer has been assigned
,manufacturer_clearance_number    --clearance number
,manufacturer_audit_date          --Audit Date
,manufacturer_audit_frequency     --Audit Frequency
,manufacturer_product_code        --Manufacturer Product Code of the Part Manufacturer
,manufacturer_approval_date       --Manufacturer Approval Date of the Part Manufacturer
,part_manufacturer_keyword_id     --Keyword assigned to the Specification
,part_manufacturer_keyword_name   --Name of the Keyword assigned to the Specification
)
as
select prm.part_no
,      mfc.mfc_id
,      prm.trade_name
,      prm.mpl_id
,      prm.clearance_no
,      prm.audit_date
,      prm.audit_freq
,      prm.product_code
,      prm.approval_date
,      kw.kw_id
,      kw.kw_value
FROM sc_interspec_ens.ITPRMFC prm           
,    sc_interspec_ens.itmfc   mfc
,    sc_interspec_ens.itmfckw kw
where mfc.mfc_id = prm.mfc_id
and   mfc.mfc_id = kw.mfc_id(+)
;
*/
CREATE OR REPLACE VIEW sc_lims_dal.SPEC_PART_MANUFACTURER
(PART_NUMBER                      --part-number of the part-header
,manufacturer_id                  --ID of the Manufacturer assigned to the Specification header
,manufacturer_trade_name          --trade name
,manufacturer_plant_id            --Plant to which the Manufacturer has been assigned
,manufacturer_clearance_number    --clearance number
,manufacturer_audit_date          --Audit Date
,manufacturer_audit_frequency     --Audit Frequency
,manufacturer_product_code        --Manufacturer Product Code of the Part Manufacturer
,manufacturer_approval_date       --Manufacturer Approval Date of the Part Manufacturer
)
as
select prm.part_no
,      mfc.mfc_id
,      prm.trade_name
,      prm.mpl_id
,      prm.clearance_no
,      prm.audit_date
,      prm.audit_freq
,      prm.product_code
,      prm.approval_date
FROM sc_interspec_ens.ITPRMFC prm           
,    sc_interspec_ens.itmfc   mfc
where mfc.mfc_id = prm.mfc_id
;

--table-comment:
comment on VIEW sc_lims_dal.SPEC_PART_MANUFACTURER   is 'Contains all manufacturers fro all part-no';
--column-comment:
comment on COLUMN sc_lims_dal.SPEC_PART_MANUFACTURER.part_number                      is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal.SPEC_PART_MANUFACTURER.manufacturer_id                  is 'ID of the Manufacturer assigned to the Specification header';
comment on COLUMN sc_lims_dal.SPEC_PART_MANUFACTURER.manufacturer_trade_name          is 'trade name';
comment on COLUMN sc_lims_dal.SPEC_PART_MANUFACTURER.manufacturer_plant_id            is 'Plant to which the Manufacturer has been assigned';
comment on COLUMN sc_lims_dal.SPEC_PART_MANUFACTURER.manufacturer_clearance_number    is 'clearance number';
comment on COLUMN sc_lims_dal.SPEC_PART_MANUFACTURER.manufacturer_audit_date          is 'Audit Date';
comment on COLUMN sc_lims_dal.SPEC_PART_MANUFACTURER.manufacturer_audit_frequency     is 'Audit Frequency';
comment on COLUMN sc_lims_dal.SPEC_PART_MANUFACTURER.manufacturer_product_code        is 'Manufacturer Product Code of the Part Manufacturer';
comment on COLUMN sc_lims_dal.SPEC_PART_MANUFACTURER.manufacturer_approval_date       is 'Manufacturer Approval Date of the Part Manufacturer';

--************************************************************************************************************
--2.6.SPEC_PART_PLANT     (kan niet met keywords worden gesynchroniseerd)
--************************************************************************************************************
--TABEL itplkw WORDT NIET GESYNCHRONISEERD NAAR AWS DD. 17-05-2022 !!!!!!!

--itplkw = plant-keyword
--relation:  plant:part_plant = 1:(0/1/n)
--           plant:
/*
CREATE OR REPLACE VIEW sc_lims_dal.SPEC_PART_PLANT
(PART_NO                     --part-number of the part-header
,plant_id                    --Short description of the Plant  assigned to the Specification
,plant_description           --description of the Plant  assigned to the Specification
,part_plant_component_scrap  --Scrap factor assigned to the plant (as assigned in spec header)
,part_plant_costing_flag     --Whether Costing Flag is switched on for the plant (assigned in spec header)
,part_plant_bulk_flag        --Whether Bulk Flag is switched on for the plant (assigned in spec header)
,plant_keyword_id            --Value of the Keyword assigned to the Specification
,plant_keyword_value         --Value of the Keyword assigned to the Specification
)
as
select pp.PART_NO
,      pp.plant
,      pl.description
,      pp.component_scrap
,      pp.relevency_to_costing
,      pp.bulk_material
,      kw.kw_id
,      kw.kw_value
from sc_interspec_ens.part_plant  pp
,    sc_interspec_ens.plant       pl
,    sc_interspec_ens.itplkw      kw
where pl.plant = pp.plant
and   pl.plant = kw.plant(+)
;
*/
CREATE OR REPLACE VIEW sc_lims_dal.SPEC_PART_PLANT
(PART_NUMBER                 --part-number of the part-header
,plant_id                    --Short description of the Plant  assigned to the Specification
,plant_description           --description of the Plant  assigned to the Specification
,part_plant_component_scrap  --Scrap factor assigned to the plant (as assigned in spec header)
,part_plant_costing_flag     --Whether Costing Flag is switched on for the plant (assigned in spec header)
,part_plant_bulk_flag        --Whether Bulk Flag is switched on for the plant (assigned in spec header)
)
as
select pp.PART_NO
,      pp.plant
,      pl.description
,      pp.component_scrap
,      pp.relevency_to_costing
,      pp.bulk_material
from sc_interspec_ens.part_plant  pp
,    sc_interspec_ens.plant       pl
where pl.plant = pp.plant
;
--table-comment:
comment on VIEW sc_lims_dal.SPEC_PART_PLANT   is 'Contains all plants for all part-no';
--column-comment:
comment on COLUMN sc_lims_dal.SPEC_PART_PLANT.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal.SPEC_PART_PLANT.plant_id                    is 'Short description of the Plant  assigned to the Specification';
comment on COLUMN sc_lims_dal.SPEC_PART_PLANT.plant_description           is 'description of the Plant  assigned to the Specification';
comment on COLUMN sc_lims_dal.SPEC_PART_PLANT.part_plant_component_scrap  is 'Scrap factor assigned to the plant (as assigned in spec header)';
comment on COLUMN sc_lims_dal.SPEC_PART_PLANT.part_plant_costing_flag     is 'Whether Costing Flag is switched on for the plant (assigned in spec header)';
comment on COLUMN sc_lims_dal.SPEC_PART_PLANT.part_plant_bulk_flag        is 'Whether Bulk Flag is switched on for the plant (assigned in spec header)';


--************************************************************************************************************
--2.7.specification_section    
--
--revision-hist
--dd 10-03-2024		added columns REF_ID, REF_VER + REV_OWNER for making a relation to OBJECT-tables like ITOIRAW (type=6)
--************************************************************************************************************
drop view sc_lims_dal.specification_section;
--
create or replace view sc_lims_dal.specification_section
(part_number                    --Specification Partcode without Revision number
,revision                       --Revision number of the Specification
,section_id                     --Section-ID
,section_description            --Section Name in the Reference Language
,section_revision               --Section revision
,section_sequence_number        --Sequence-number of the Spec Sections
,sub_section_id                 --Sub-Section-ID
,sub_section_description        --Subsection Name in the Reference Language
,sub_section_revision           --Sub-Section revision
,sub_section_sequence_number    --Sequence-number of the Spec sub-Sections
,section_type                   --Section type
,ref_id                         --reference-object-id, depending on section-type referring to specific table
,ref_ver                        --reference-version
,ref_owner 					    --reference-owner
)
as
select ss.part_no
,      ss.revision
,      ss.section_id                
,      sec.description
,      ss.section_rev
,      ss.section_sequence_no
,      ss.sub_section_id  
,      sub.description              
,      ss.sub_section_rev
,      ss.sequence_no
,      DECODE(ss.TYPE,1,'Property Group'
                     ,2,'Reference Text'
                     ,3,'BOM'
                     ,4,'Single Property'
                     ,5,'Free Text'
                     ,6,'Image or File'
                     ,7,'Process Data'
                     ,8,'Attached Specs'
                     ,9,'Ingredient List'
                     ,10,'Base Name')    section_type   
,      ss.ref_id
,      ss.ref_ver
,      ss.ref_owner 					 
from sc_interspec_ens.specification_section ss
,    sc_interspec_ens.section               sec
,    sc_interspec_ens.sub_section           sub
where ss.section_id     = sec.section_id
and   ss.sub_section_id = sub.sub_section_id
;
--table-comment:
comment on VIEW sc_lims_dal.specification_section   is 'Contains all sections + subsections for specification-parts';
--column-comment:
comment on COLUMN sc_lims_dal.specification_section.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal.specification_section.revision                    is 'Revision number of the Specification';
comment on COLUMN sc_lims_dal.specification_section.section_id                  is 'Section-ID';
comment on COLUMN sc_lims_dal.specification_section.section_description         is 'Section Name in the Reference Language';
comment on COLUMN sc_lims_dal.specification_section.section_revision            is 'Section revision';
comment on COLUMN sc_lims_dal.specification_section.section_sequence_number     is 'Sequence-number of the Spec Sections';
comment on COLUMN sc_lims_dal.specification_section.sub_section_id              is 'Sub-Section-ID';
comment on COLUMN sc_lims_dal.specification_section.sub_section_description     is 'Subsection Name in the Reference Language';
comment on COLUMN sc_lims_dal.specification_section.sub_section_revision        is 'Sub-Section revision';
comment on COLUMN sc_lims_dal.specification_section.sub_section_sequence_number is 'Sequence-number of the Spec sub-Sections';
comment on COLUMN sc_lims_dal.specification_section.section_type                is 'Section type';
comment on COLUMN sc_lims_dal.specification_section.ref_id                      is 'Reference-object-id';
comment on COLUMN sc_lims_dal.specification_section.ref_ver                     is 'Reference-object-version';
comment on COLUMN sc_lims_dal.specification_section.ref_owner                   is 'Reference-object-owner';


--grant all on  sc_lims_dal.av_requestoverviewresults   to usr_rna_readonly1;



--************************************************************************************************************
--2.8.specification_section_text    (kan niet worden gesynchroniseerd door BLOB-TEXT)
--************************************************************************************************************
--TABEL specification_text WORDT NIET GESYNCHRONISEERD door BLOB-TEXT !!!!!   NAAR AWS DD. 17-05-2022 !!!!!!!

/*
create or replace view sc_lims_dal.specification_section_text
(part_number                    --Specification Partcode without Revision number
,revision                       --Revision number of the Specification
,section_id                     --Section-ID
,section_description            --Section Name in the Reference Language
,section_revision               --Section revision
,sub_section_id                 --Sub-Section-ID
,sub_section_description        --Subsection Name in the Reference Language
,sub_section_revision           --SubSection revision
,text_type                      --Text Type of the Spec Free Text
,text_type_revision             --Revision number of the text-type
,text                           --text-value
,text_type_description          --Free Text Type of the Spec Free Text
,section_type                   --Section type (bijv. 5=free text)
)
as
select txt.part_no
,      txt.revision
,      txt.section_id
,      sec.description
,      txt.section_rev
,      txt.sub_section_id
,      sub.description
,      txt.sub_section_rev
,      txt.text_type
,      txt.text_type_rev
,      txt.text
,      tt.description
,      DECODE(ss.TYPE,1,'Property Group'
               ,2,'Reference Text'
               ,3,'BOM'
               ,4,'Single Property'
               ,5,'Free Text'
               ,6,'Image or File'
               ,7,'Process Data'
               ,8,'Attached Specs'
               ,9,'Ingredient List'
               ,10,'Base Name')    section_type   
from sc_interspec_ens.specification_section ss
,    sc_interspec_ens.specification_text    txt
,    sc_interspec_ens.section               sec
,    sc_interspec_ens.sub_section           sub
,    sc_interspec_ens.text_type             tt
where ss.PART_NO        = txt.PART_NO(+) 
and   ss.REVISION       = txt.REVISION(+) 
AND   ss.SECTION_ID     = txt.SECTION_ID(+) 
AND   ss.SUB_SECTION_ID = txt.SUB_SECTION_ID(+) 
AND   ss.REF_ID         = txt.TEXT_TYPE(+) 
and   ss.section_id     = sec.section_id
and   ss.sub_section_id = sub.sub_section_id
and   txt.text_type     = tt.text_type
--AND   ss.TYPE           = 5
;
*/


--************************************************************************************************************
--2.9.specification_property    
--************************************************************************************************************
drop view sc_lims_dal.specification_property;
--
create or replace view sc_lims_dal.specification_property
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
,property_revision               --revision-number of a property
,property_description             --property-name
,attribute_id                     --Property attribute ID of the Frame Data
,attribute_revision               --revision-number of ther frame-attribute
,attribute_description            --property-attribute-name
,test_method_id                   --Test Method ID of the Frame Data
,test_method_revision             --Test Method Revision of the Frame Data
,test_method_description          --property-test-method-name
,characteristic_id                --characteristic ID of the frame-data
,characteristic_revision          --characteristic Revision of the Frame Data
,characteristic_description       --property-characteristec-name
,association_id                --association ID of the frame-data
,association_revision          --association Revision of the Frame Data
,association_description       --property-association-name
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
SELECT sp.part_no
,      sp.revision
,      sp.section_id
,      sp.section_rev
,      sec.description        as section
,      sp.sub_section_id
,      sp.sub_section_rev
,      sub.description        as sub_section
,      sp.property_group
,      sp.property_group_rev
,      prg.description        as property_group
,      sp.property
,      sp.property_rev
,      prp.description        AS property
,      sp.attribute
,      sp.attribute_rev
,      att.description        as attribute
,      sp.test_method
,      sp.test_method_rev
,      tst.description        as test_method
,      sp.characteristic 
,      sp.characteristic_rev
,      cha.description        as characteristic
,      sp.association
,      sp.association_rev
,      ass.description        as association
,      sp.uom_id
,      sp.uom_rev
,      uom.description        AS uom
,      sp.num_1
,      sp.num_2
,      sp.num_3
,      sp.num_4
,      sp.num_5
,      sp.num_6
,      sp.num_7
,      sp.num_8
,      sp.num_9
,      sp.num_10
,      sp.char_1
,      sp.char_2
,      sp.char_3
,      sp.char_4
,      sp.char_5
,      sp.char_6
,      sp.boolean_1
,      sp.boolean_2
,      sp.boolean_3
,      sp.boolean_4
,      sp.date_1
,      sp.date_2
FROM  sc_interspec_ens.specification_prop  sp
,     sc_interspec_ens.section             sec
,     sc_interspec_ens.sub_section         sub
,     sc_interspec_ens.property_group      prg
,     sc_interspec_ens.property            prp
,     sc_interspec_ens.attribute           att
,     sc_interspec_ens.test_method         tst
,     sc_interspec_ens.characteristic      cha
,     sc_interspec_ens.association         ass
,     sc_interspec_ens.uom                 uom
where sp.section_id     = sec.section_id
and   sp.sub_section_id = sub.sub_section_id
and   sp.property_group = prg.property_group
and   sp.property       = prp.property
and   sp.attribute      = att.attribute(+)
and   sp.test_method    = tst.test_method(+)
and   sp.characteristic = cha.characteristic_id(+)
and   sp.association    = ass.association(+)
and   sp.uom_id         = uom.uom_id(+)
;
--table-comment:
comment on VIEW sc_lims_dal.specification_property   is 'Contains all specification-properties with all the values without header-info';
--column-comment:
comment on COLUMN sc_lims_dal.specification_property.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal.specification_property.revision                    is 'Revision number of the Specification';
comment on COLUMN sc_lims_dal.specification_property.section_id                  is 'identification of a section';
comment on COLUMN sc_lims_dal.specification_property.section_revision            is 'revision-number of a section';
comment on COLUMN sc_lims_dal.specification_property.section_description         is 'section name';
comment on COLUMN sc_lims_dal.specification_property.sub_section_id              is 'identification of a section';
comment on COLUMN sc_lims_dal.specification_property.sub_section_revision        is 'revision-number of a section';
comment on COLUMN sc_lims_dal.specification_property.sub_section_description     is 'section name';
comment on COLUMN sc_lims_dal.specification_property.property_group_id           is 'identification of a property-group';
comment on COLUMN sc_lims_dal.specification_property.property_group_revision     is 'revision-number of a property-group';
comment on COLUMN sc_lims_dal.specification_property.property_group_description  is 'property-group name';
comment on COLUMN sc_lims_dal.specification_property.property_id                 is 'identification of a property';
comment on COLUMN sc_lims_dal.specification_property.property_revision           is 'revision-number of a property';
comment on COLUMN sc_lims_dal.specification_property.property_description        is 'property-name';
comment on COLUMN sc_lims_dal.specification_property.attribute_id                is 'Property attribute ID of the Frame Data';
comment on COLUMN sc_lims_dal.specification_property.attribute_revision          is 'revision-number of ther frame-attribute';
comment on COLUMN sc_lims_dal.specification_property.attribute_description       is 'property-attribute-name';
comment on COLUMN sc_lims_dal.specification_property.test_method_id              is 'Test Method ID of the Frame Data';
comment on COLUMN sc_lims_dal.specification_property.test_method_revision        is 'Test Method Revision of the Frame Data';
comment on COLUMN sc_lims_dal.specification_property.test_method_description     is 'property-test-method-name';
comment on COLUMN sc_lims_dal.specification_property.characteristic_id           is 'characteristic ID of the frame-data';
comment on COLUMN sc_lims_dal.specification_property.characteristic_revision     is 'characteristic Revision of the Frame Data';
comment on COLUMN sc_lims_dal.specification_property.characteristic_description  is 'property-characteristec-name';
comment on COLUMN sc_lims_dal.specification_property.association_id              is 'association ID of the frame-data';
comment on COLUMN sc_lims_dal.specification_property.association_revision        is 'association Revision of the Frame Data';
comment on COLUMN sc_lims_dal.specification_property.association_description     is 'property-association-name';
comment on COLUMN sc_lims_dal.specification_property.uom_id                      is 'Base Unit Of Measure ID of the property';
comment on COLUMN sc_lims_dal.specification_property.uom_revision                is 'Base Unit Of Measure Revision of the property';
comment on COLUMN sc_lims_dal.specification_property.uom_description             is 'Base Unit Of Measure of the part';



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
--2.10.specification_data    
--***********************************************************************************************************
drop view sc_lims_dal.specification_data;
--
create or replace view sc_lims_dal.specification_data
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
SELECT spd.part_no
,      spd.revision
,      spd.section_id
,      spd.section_rev
,      sec.description        as section
,      spd.sub_section_id
,      spd.sub_section_rev
,      sub.description        as sub_section
,      spd.sequence_no
,      spd.property_group
,      spd.property_group_rev
,      prg.description        as property_group
,      spd.property
,      spd.property_rev
,      prp.description        AS property
,      spd.header_id
,      spd.header_rev
,      hea.description        AS header
,      spd.attribute
,      spd.attribute_rev
,      att.description        as attribute
,      spd.test_method
,      spd.test_method_rev
,      tst.description        as test_method
,      spd.characteristic 
,      spd.characteristic_rev
,      cha.description        as characteristic
,      spd.association
,      spd.association_rev
,      ass.description        as association
,      spd.value
,      spd.value_s
,      spd.uom_id
,      spd.uom_rev
,      uom.description
FROM  sc_interspec_ens.mv_specdata       spd
JOIN  sc_interspec_ens.section           sec ON spd.section_id     = sec.section_id
JOIN  sc_interspec_ens.sub_section       sub ON spd.sub_section_id = sub.sub_section_id
JOIN  sc_interspec_ens.property_group    prg on spd.property_group = prg.property_group
JOIN  sc_interspec_ens.property          prp ON spd.property       = prp.property
full OUTER JOIN  sc_interspec_ens.header      hea ON spd.header_id      = hea.header_id
full OUTER JOIN  sc_interspec_ens.attribute   att on spd.attribute      = att.attribute
full OUTER JOIN  sc_interspec_ens.test_method tst ON spd.test_method    = tst.test_method
full OUTER JOIN  sc_interspec_ens.characteristic cha on spd.characteristic = cha.characteristic_id
full OUTER JOIN  sc_interspec_ens.association    ass ON spd.association    = ass.association
FULL OUTER JOIN  sc_interspec_ens.uom            uom ON spd.uom_id         = uom.uom_id
;

/*
FROM  sc_interspec_ens.specdata       spd
,     sc_interspec_ens.section        sec
,     sc_interspec_ens.sub_section    sub
,     sc_interspec_ens.property_group prg
,     sc_interspec_ens.property       prp
,     sc_interspec_ens.header         hea
,     sc_interspec_ens.attribute      att
,     sc_interspec_ens.test_method    tst
,     sc_interspec_ens.characteristic cha
,     sc_interspec_ens.association    ass
,     sc_interspec_ens.uom            uom
where spd.section_id     = sec.section_id
and   spd.sub_section_id = sub.sub_section_id
and   spd.property_group = prg.property_group
and   spd.property       = prp.property
and   spd.header_id      = hea.header_id
and   spd.attribute      = att.attribute(+)
and   spd.test_method    = tst.test_method(+)
and   spd.characteristic = cha.characteristic_id(+)
and   spd.association    = ass.association(+)
and   spd.uom_id         = uom.uom_id(+)
*/

--select * from sc_lims_dal.specification_data where part_number='EF_Y225/35R19QPPX' ;




--table-comment:
comment on VIEW sc_lims_dal.specification_data   is 'Contains all specification-property-data with its values';
--column-comment:
comment on COLUMN sc_lims_dal.specification_data.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal.specification_data.revision                    is 'Revision number of the Specification';
comment on COLUMN sc_lims_dal.specification_data.section_id                  is 'identification of a section';
comment on COLUMN sc_lims_dal.specification_data.section_revision            is 'revision-number of a section';
comment on COLUMN sc_lims_dal.specification_data.section_description         is 'section name';
comment on COLUMN sc_lims_dal.specification_data.sub_section_id              is 'identification of a section';
comment on COLUMN sc_lims_dal.specification_data.sub_section_revision        is 'revision-number of a section';
comment on COLUMN sc_lims_dal.specification_data.sub_section_description     is 'section name';
comment on COLUMN sc_lims_dal.specification_data.sequence_number             is 'sequence-number';
comment on COLUMN sc_lims_dal.specification_data.property_group_id           is 'identification of a property-group';
comment on COLUMN sc_lims_dal.specification_data.property_group_revision    is 'revision-number of a property-group';
comment on COLUMN sc_lims_dal.specification_data.property_group_description  is 'property-group name';
comment on COLUMN sc_lims_dal.specification_data.property_id                 is 'identification of a property';
comment on COLUMN sc_lims_dal.specification_data.property_revision          is 'revision-number of a property';
comment on COLUMN sc_lims_dal.specification_data.property_description        is 'property-name';
comment on COLUMN sc_lims_dal.specification_data.header_id                   is 'Property Header ID of the Frame Data';
comment on COLUMN sc_lims_dal.specification_data.header_revision             is 'revision-number of ther frame-header';
comment on COLUMN sc_lims_dal.specification_data.header_description          is 'property-header-name';
comment on COLUMN sc_lims_dal.specification_data.attribute_id                is 'Property attribute ID of the Frame Data';
comment on COLUMN sc_lims_dal.specification_data.attribute_revision          is 'revision-number of ther frame-attribute';
comment on COLUMN sc_lims_dal.specification_data.attribute_description       is 'property-attribute-name';
comment on COLUMN sc_lims_dal.specification_data.test_method_id              is 'Test Method ID of the Frame Data';
comment on COLUMN sc_lims_dal.specification_data.test_method_revision        is 'Test Method Revision of the Frame Data';
comment on COLUMN sc_lims_dal.specification_data.test_method_description     is 'property-test-method-name';
comment on COLUMN sc_lims_dal.specification_data.characteristic_id           is 'characteristic ID of the frame-data';
comment on COLUMN sc_lims_dal.specification_data.characteristic_revision    is 'characteristic Revision of the Frame Data';
comment on COLUMN sc_lims_dal.specification_data.characteristic_description  is 'property-characteristec-name';
comment on COLUMN sc_lims_dal.specification_data.association_id              is 'association ID of the frame-data';
comment on COLUMN sc_lims_dal.specification_data.association_revision       is 'association Revision of the Frame Data';
comment on COLUMN sc_lims_dal.specification_data.association_description     is 'property-association-name';
comment on COLUMN sc_lims_dal.specification_data.spec_value                  is 'Value of the property assigned to the Specification-property';
comment on COLUMN sc_lims_dal.specification_data.spec_value_s                is 'String-Value of the property assigned to the Specification-property';
comment on COLUMN sc_lims_dal.specification_data.uom_id                      is 'Base Unit Of Measure ID of the property';
comment on COLUMN sc_lims_dal.specification_data.uom_revision                is 'Base Unit Of Measure Revision of the property';
comment on COLUMN sc_lims_dal.specification_data.uom_description             is 'Base Unit Of Measure of the part';


--************************************************************************************************************
--2.11.SPECIFICATION_BOM_HEADER
--************************************************************************************************************
create or replace view sc_lims_dal.specification_bom_header
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
select bh.part_no
,      bh.revision
,      bh.plant
,      pl.description     as plant_description
,      bh.alternative
,      bh.base_quantity
,      bh.description
,      bh.conv_factor
,      bh.bom_type
,      bh.bom_usage
,      bh.min_qty
,      bh.max_qty
,      bh.plant_effective_date
,      bh.preferred
from sc_interspec_ens.bom_header  bh
,    sc_interspec_ens.plant       pl
where bh.plant = pl.plant
;

--table-comment:
comment on VIEW sc_lims_dal.specification_bom_header   is 'Contains all specification-headers of tyres and all related components of that tyre';
--column-comment:
comment on COLUMN sc_lims_dal.specification_bom_header.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal.specification_bom_header.revision                    is 'Revision number of the Specification';
comment on COLUMN sc_lims_dal.specification_bom_header.plant                       is 'the Plant for which the BOM has been created';
comment on COLUMN sc_lims_dal.specification_bom_header.plant_description           is 'Full description of the Plant for which the BOM has been created';
comment on COLUMN sc_lims_dal.specification_bom_header.alternative                 is 'BOM Alternative, 1=current, 2=alternative';
comment on COLUMN sc_lims_dal.specification_bom_header.base_quantity               is 'Base quantity of the BOM as defined in the BOM Header';
comment on COLUMN sc_lims_dal.specification_bom_header.description                 is 'BOM Header Description';
comment on COLUMN sc_lims_dal.specification_bom_header.conversion_factor           is 'BOM Conversion Factor of the Spec BOM';
comment on COLUMN sc_lims_dal.specification_bom_header.bom_type                    is 'BOM Type: FP (Percentage BOM) or FQ (Quantity BOM)';
comment on COLUMN sc_lims_dal.specification_bom_header.bom_usage                   is 'BOM Usage: returns a numeric value: 1.00 for PROD, 5.00 for SALES and 6.00 for COST';
comment on COLUMN sc_lims_dal.specification_bom_header.min_qty                     is 'Minimum Base quantity of the BOM as defined in the BOM Header';
comment on COLUMN sc_lims_dal.specification_bom_header.max_qty                     is 'Maximum Base quantity of the BOM as defined in the BOM Header';
comment on COLUMN sc_lims_dal.specification_bom_header.plant_effective_date        is 'BOM Planned Effective Date (as defined in the BOM Header)';
comment on COLUMN sc_lims_dal.specification_bom_header.preferred                   is 'BOM Preferred of the Spec BOM';

--************************************************************************************************************
--2.12.SPECIFICATION_BOM_ITEM
--************************************************************************************************************
create or replace view sc_lims_dal.specification_bom_item
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
select bi.part_no
,      bi.revision
,      bi.plant
,      plh.description     as header_plant_description
,      bi.alternative
,      bi.item_number
,      bi.component_part
,      bi.component_revision
,      bi.component_plant
,      pli.description      as item_plant_description
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
,      cha1.description       as characteristic_1
,      bi.ch_2
,      cha2.description       as characteristic_2
,      bi.ch_3
,      cha3.description       as characteristic_3
from sc_interspec_ens.bom_item       bi
,    sc_interspec_ens.plant          plh
,    sc_interspec_ens.plant          pli
,    sc_interspec_ens.characteristic cha1
,    sc_interspec_ens.characteristic cha2
,    sc_interspec_ens.characteristic cha3
where bi.plant           = plh.plant
and   bi.component_plant = pli.plant
and   bi.ch_1            = cha1.characteristic_id(+)
and   bi.ch_2            = cha2.characteristic_id(+)
and   bi.ch_3            = cha3.characteristic_id(+)
;
--table-comment:
comment on VIEW sc_lims_dal.specification_bom_item   is 'Contains all specification-bom_items related to tyres or components';
--column-comment:
comment on COLUMN sc_lims_dal.specification_bom_item.part_number                 is 'Specification Partcode without Revision number';
comment on COLUMN sc_lims_dal.specification_bom_item.revision                    is 'Revision number of the Specification-header';
comment on COLUMN sc_lims_dal.specification_bom_item.plant                       is 'the Plant for which the BOM-header has been created';
comment on COLUMN sc_lims_dal.specification_bom_item.plant_description           is 'Full description of the Plant for which the BOM-header has been created';
comment on COLUMN sc_lims_dal.specification_bom_item.alternative                 is 'BOM Alternative, 1=current, 2=alternative';
comment on COLUMN sc_lims_dal.specification_bom_item.item_number                 is 'Number of component-part within a heading-tyre/component';
comment on COLUMN sc_lims_dal.specification_bom_item.component_part              is 'Specification-item-component/material Partcode without Revision number';
comment on COLUMN sc_lims_dal.specification_bom_item.component_revision          is 'Revision number of the Specification-item-component/material';
comment on COLUMN sc_lims_dal.specification_bom_item.component_plant             is 'the Plant for which the BOM-item-component has been created';
comment on COLUMN sc_lims_dal.specification_bom_item.component_plant_description is 'Full description of the Plant for which the BOM-item-component has been created';
comment on COLUMN sc_lims_dal.specification_bom_item.quantity                    is 'Quantity of the BOM Item in a BOM';
comment on COLUMN sc_lims_dal.specification_bom_item.uom                         is 'Base UOM of the BOM Item';
comment on COLUMN sc_lims_dal.specification_bom_item.ch_1                        is 'characteristic ID of the first bom-item-data';
comment on COLUMN sc_lims_dal.specification_bom_item.characteristic_1_description is 'first bom-item-characteristec-name';
comment on COLUMN sc_lims_dal.specification_bom_item.ch_2                         is 'characteristic ID of the second bom-item-data';
comment on COLUMN sc_lims_dal.specification_bom_item.characteristic_2_description is 'second bom-item-characteristec-name';
comment on COLUMN sc_lims_dal.specification_bom_item.ch_3                         is 'characteristic ID of the third bom-item-data';
comment on COLUMN sc_lims_dal.specification_bom_item.characteristic_3_description is 'third bom-item-characteristec-name';


--************************************************************************************************************
--2.13.SPECIFICATION_BOM_ITEM_FULL
--************************************************************************************************************
drop view sc_lims_dal.SPECIFICATION_BOM_ITEM_FULL;
--Create VIEW ALL BOM-ITEMS-REVISIONS incl STATUS + MAX(REVISION)
CREATE or REPLACE view sc_lims_dal.SPECIFICATION_BOM_ITEM_FULL
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
select bi.part_no
,      bi.revision
,      sh.issued_date
,      sh.obsolescence_date
,      bi.plant
,      bi.alternative
,      bh.preferred
,      sh.status
,      s.sort_desc
,      s.status_type
,      p.description
,      sh.frame_id
,      bi.component_part
,      (select MAX(bh1.revision)
        from sc_interspec_ens.status               s1
		,    sc_interspec_ens.specification_header sh1
		,    sc_interspec_ens.bom_header           bh1 
		where bh1.part_no    = bi.component_part 
		and   sh1.part_no    = bh1.part_no 
		and   sh1.revision   = bh1.revision 
		and   sh1.status     = s1.status )  componentrevisionmax
,      (select distinct bh1.revision 
        from sc_interspec_ens.status               s1
		,    sc_interspec_ens.specification_header sh1
		,    sc_interspec_ens.bom_header           bh1 
		where bh1.part_no    = bi.component_part 
		and   sh1.part_no    = bh1.part_no 
		and   sh1.revision   = bh1.revision 
		and   sh1.status     = s1.status 
		and   s1.status_type = 'CURRENT')  componentrevisioncurrent
,      bi.quantity
,      bi.uom
,      bi.ch_1
,      c.description    functiecode 
from sc_interspec_ens.characteristic       c
,    sc_interspec_ens.part                 p
,    sc_interspec_ens.status               s
,    sc_interspec_ens.specification_header sh
,    sc_interspec_ens.bom_header           bh
,    sc_interspec_ens.bom_item             bi
where bi.part_no     = bh.part_no
and   bi.revision    = bh.revision
and   bi.alternative = bh.alternative
and   sh.part_no     = bh.part_no
and   sh.revision    = bh.revision
and   sh.status      = s.status
--and   s.status_type  = 'CURRENT' 
and   bh.part_no     = p.part_no
and   bi.ch_1        = c.characteristic_id(+)
;
--and rownum < 5
--order by bi.part_no
--,        bi.revision
--,        bi.component_part

--************************************************************************************************************
--2.14.SPEC_BOM_ITEM_CURRENT_TREE
--SELECTION: header-revision = max(header-revision), of status = CURRENT is maakt dan niet uit...
--let op: er zit nog GEEN constructie in voor bepalen van MAX(REVISION).
--        Zodra we SUB-QUERY inbouwen krijgen we bij gebruik van RECURSIVE-query een foutmelding:
--        ERROR: Correlated subquery in recursive CTE is not supported yet
--current: 508166
--************************************************************************************************************
drop view sc_lims_dal_ai.AI_SPEC_BOM_ITEM_CURRENT_TREE;
drop view sc_lims_dal.SPEC_BOM_ITEM_CURRENT_TREE;
--Create VIEW ALL BOM-ITEMS-REVISIONS incl STATUS + MAX(REVISION)
CREATE or REPLACE view sc_lims_dal.SPEC_BOM_ITEM_CURRENT_TREE
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
select bi.part_no
,      bi.revision
,      sh.issued_date
,      sh.obsolescence_date
,      bi.plant
,      bi.alternative
,      bh.preferred
,      sh.status
,      s.sort_desc
,      s.status_type
,      p.description
,      sh.frame_id
,      bi.component_part
,      bi.quantity
,      bi.uom
,      bi.ch_1
,      c.description    functiecode 
from sc_interspec_ens.characteristic       c
,    sc_interspec_ens.part                 p
,    sc_interspec_ens.status               s
,    sc_interspec_ens.specification_header sh
,    sc_interspec_ens.bom_header           bh
,    sc_interspec_ens.bom_item             bi
where bi.part_no     = bh.part_no
and   bi.revision    = bh.revision
and   bh.preferred   = 1
and   bi.alternative = bh.alternative
and   sh.part_no     = bh.part_no
and   sh.revision    = bh.revision
and   sh.status      = s.status
and   s.status_type  in ('CURRENT')
and   bh.part_no     = p.part_no
and   bi.ch_1        = c.characteristic_id(+)
;

--************************************************************************************************************
--2.14.SPEC_BOM_ITEM_ALL_REV_TREE
--SELECTION: alle header-revisions, status dan HISTORIC of CURRENT is maakt dan niet uit...
--let op: er zit nog GEEN constructie in voor bepalen van MAX(REVISION).
--        Zodra we SUB-QUERY inbouwen krijgen we bij gebruik van RECURSIVE-query een foutmelding:
--        ERROR: Correlated subquery in recursive CTE is not supported yet
--all-rows: 1174245

--************************************************************************************************************
drop view sc_lims_dal_ai.AI_SPEC_BOM_ITEM_ALL_REV_TREE;
drop view sc_lims_dal.SPEC_BOM_ITEM_ALL_REV_TREE;
--Create VIEW ALL BOM-ITEMS-REVISIONS incl STATUS + MAX(REVISION)
CREATE or REPLACE view sc_lims_dal.SPEC_BOM_ITEM_ALL_REV_TREE
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
select bi.part_no
,      bi.revision
,      sh.issued_date
,      sh.obsolescence_date
,      bi.plant
,      bi.alternative
,      bh.preferred
,      sh.status
,      s.sort_desc
,      s.status_type
,      p.description
,      sh.frame_id
,      bi.component_part
,      bi.quantity
,      bi.uom
,      bi.ch_1
,      c.description    functiecode 
from sc_interspec_ens.characteristic       c
,    sc_interspec_ens.part                 p
,    sc_interspec_ens.status               s
,    sc_interspec_ens.specification_header sh
,    sc_interspec_ens.bom_header           bh
,    sc_interspec_ens.bom_item             bi
where bi.part_no     = bh.part_no
and   bi.revision    = bh.revision
and   bh.preferred   = 1
and   bi.alternative = bh.alternative
and   sh.part_no     = bh.part_no
and   sh.revision    = bh.revision
and   sh.status      = s.status
and   s.status_type  in ('CURRENT','HISTORIC')
and   bh.part_no     = p.part_no
and   bi.ch_1        = c.characteristic_id(+)
;
--einde script


