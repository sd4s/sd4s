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


drop view IF EXISTS  sc_lims_dal.REQUEST;
drop view IF EXISTS  sc_lims_dal.REQUEST_DATA_TIME_INFO;
drop view IF EXISTS  sc_lims_dal.REQUEST_INFO_CARD;
drop view IF EXISTS  sc_lims_dal.REQUEST_INFO_FIELD;
drop view IF EXISTS  sc_lims_dal.REQUEST_ATTRIBUTES;
drop view IF EXISTS  sc_lims_dal.REQUEST_HISTORY;
drop view IF EXISTS  sc_lims_dal.REQUEST_GROUP_KEY;
drop view IF EXISTS  sc_lims_dal.SAMPLE;
drop view IF EXISTS  sc_lims_dal.SAMPLE_GROUP_KEY;
drop view IF EXISTS  sc_lims_dal.SAMPLE_DATA_TIME_INFO;
drop view IF EXISTS  sc_lims_dal.SAMPLE_ATTRIBUTES;
drop view IF EXISTS  sc_lims_dal.SAMPLE_HISTORY;
drop view IF EXISTS  sc_lims_dal.SAMPLE_INFO_CARD;
drop view IF EXISTS  sc_lims_dal.SAMPLE_INFO_FIELD;
drop view IF EXISTS  sc_lims_dal.SAMPLE_PART_NO_INFO_CARD;
drop view IF EXISTS  sc_lims_dal.SAMPLE_PART_NO_GROUPKEY;
drop view IF EXISTS  sc_lims_dal.PARAMETER_GROUP;
drop view IF EXISTS  sc_lims_dal.PARAMETER_GROUP_DATA_TIME_INFO;
drop view IF EXISTS  sc_lims_dal.PARAMETER_GROUP_ATTRIBUTES;
drop view IF EXISTS  sc_lims_dal.PARAMETER;
drop view IF EXISTS  sc_lims_dal.PARAMETER_DATA_TIME_INFO;
drop view IF EXISTS  sc_lims_dal.PARAMETER_SPECIFICATIONS;
drop view IF EXISTS  sc_lims_dal.PARAMETER_ATTRIBUTES;
drop view IF EXISTS  sc_lims_dal.PARAMETER_HISTORY;
drop view IF EXISTS  sc_lims_dal.PARAMETER_REANALYSIS;
drop view IF EXISTS  sc_lims_dal.METHOD;
drop view IF EXISTS  sc_lims_dal.METHOD_DATA_TIME_INFO;
drop view IF EXISTS  sc_lims_dal.METHOD_GROUP_KEY;
drop view IF EXISTS  sc_lims_dal.METHOD_ATTRIBUTES;
drop view IF EXISTS  sc_lims_dal.METHOD_HISTORY;
drop view IF EXISTS  sc_lims_dal.METHOD_REANALYSIS;
drop view IF EXISTS  sc_lims_dal.METHOD_CELL;

--einde script


