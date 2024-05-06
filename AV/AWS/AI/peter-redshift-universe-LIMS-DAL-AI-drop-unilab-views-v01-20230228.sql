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

drop view IF EXISTS sc_lims_dal_ai.AI_METHOD_CELL;
drop view IF EXISTS sc_lims_dal_ai.AI_METHOD;
drop view IF EXISTS sc_lims_dal_ai.ai_sample;
drop view IF EXISTS sc_lims_dal_ai.AI_SAMPLE_PART_NO_GROUPKEY;
--



--einde script


