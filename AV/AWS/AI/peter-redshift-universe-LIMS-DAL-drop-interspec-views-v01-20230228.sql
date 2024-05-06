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



--related SC_LIMS_DAL_AI-views:
drop view IF EXISTS sc_lims_dal_ai.AI_SPEC_BOM_ITEM_CURRENT_TREE;
drop view IF EXISTS sc_lims_dal_ai.AI_SPEC_BOM_ITEM_ALL_REV_TREE;

--SC_LIMS_DAL-views
drop view IF EXISTS sc_lims_dal.frame;
drop view IF EXISTS sc_lims_dal.frame_keyword;
drop view IF EXISTS sc_lims_dal.specification;
drop view IF EXISTS sc_lims_dal.specification_part;
drop view IF EXISTS sc_lims_dal.specification_keyword;
drop VIEW IF EXISTS sc_lims_dal.SPECIFICATION_CLASSIFICATION;
drop VIEW IF EXISTS sc_lims_dal.SPEC_PART_MANUFACTURER;
drop VIEW IF EXISTS sc_lims_dal.SPEC_PART_PLANT;
drop view IF EXISTS sc_lims_dal.specification_section;
drop view IF EXISTS sc_lims_dal.specification_property;
drop view IF EXISTS sc_lims_dal.specification_data;
drop view IF EXISTS sc_lims_dal.specification_bom_header;
drop view IF EXISTS sc_lims_dal.specification_bom_item;
drop view IF EXISTS sc_lims_dal.SPECIFICATION_BOM_ITEM_FULL;
drop view IF EXISTS sc_lims_dal.SPEC_BOM_ITEM_CURRENT_TREE;
drop view IF EXISTS sc_lims_dal.SPEC_BOM_ITEM_ALL_REV_TREE;



--einde script


