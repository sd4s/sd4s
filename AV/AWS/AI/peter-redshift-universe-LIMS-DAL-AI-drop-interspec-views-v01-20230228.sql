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
drop view IF EXISTS sc_lims_dal_ai.ai_specification_property;
drop view IF EXISTS sc_lims_dal_ai.ai_specification_data;
drop view IF EXISTS sc_lims_dal_ai.ai_specification;
drop view IF EXISTS sc_lims_dal_ai.ai_specification_bom_header;
drop view IF EXISTS sc_lims_dal_ai.ai_specification_bom_item;
DROP VIEW IF EXISTS sc_lims_dal_ai.AI_SPECIFICATION_BOM_ITEM_FULL;
drop view IF EXISTS sc_lims_dal_ai.AI_SPEC_BOM_ITEM_CURRENT_TREE;
drop view IF EXISTS sc_lims_dal_ai.AI_SPEC_BOM_ITEM_ALL_REV_TREE;


--

--einde script


