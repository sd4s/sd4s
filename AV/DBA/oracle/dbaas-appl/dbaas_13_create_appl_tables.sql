--create dbaas app-tables...

CREATE TABLE DBAAS.APPL_SYNONIEMEN
( SYNM_ID            NUMBER(10)
, SYNM_SCHEMA_PREFIX varchar2(12)   
, SYNM_OBJECT_NAME   varchar2(64)  
, SYNM_SYNONYM_OWNER varchar2(30)  
, SYNM_SYNONYM_NAME  varchar2(30) default null
);
 
 
CREATE TABLE DBAAS.APPL_GRANTS
( GRNT_ID            NUMBER(10)
, GRNT_SCHEMA_PREFIX varchar2(12)   
, GRNT_OBJECT_NAME   varchar2(30)  
, GRNT_GRANT_TO      varchar2(30)  
, GRNT_PERMISSIONS   varchar2(128) default null 
);

--drop table DBAAS.APPL_SDO_GEOM_METADATA
create table DBAAS.APPL_SDO_GEOM_METADATA
as select owner, table_name, column_name, diminfo, srid from all_sdo_geom_metadata where 1 = 0
;

CREATE TABLE DBAAS.APPL_SEQUENCES
( SEQE_ID            NUMBER(10)
, SEQE_SEQUENCE_NAME varchar2(1000)   
, SEQE_TABLE_NAME    varchar2(1000)  
, SEQE_COLUMN_NAME   varchar2(1000) 
);
 
 
--
-- grant privileges
--
--ndb
grant select,insert,update,delete on DBAAS.APPL_SYNONIEMEN to ADM,ATTIC;
grant select,insert,update,delete on DBAAS.APPL_GRANTS to ADM,ATTIC;
grant select,insert,update,delete on DBAAS.APPL_SDO_GEOM_METADATA to ADM,ATTIC;
grant select,insert,update,delete on DBAAS.APPL_SEQUENCES to ADM,ATTIC;
--sdb
grant select,insert,update,delete on DBAAS.APPL_SYNONIEMEN to ADM,WDI_EIGENAAR;
grant select,insert,update,delete on DBAAS.APPL_GRANTS to ADM,WDI_EIGENAAR;
grant select,insert,update,delete on DBAAS.APPL_SDO_GEOM_METADATA to ADM,WDI_EIGENAAR;
grant select,insert,update,delete on DBAAS.APPL_SEQUENCES to ADM,WDI_EIGENAAR;



--
-- private synonyms maken
--
create or replace PUBLIC synonym APPL_SYNONIEMEN for DBAAS.APPL_SYNONIEMEN;
create or replace PUBLIC synonym APPL_GRANTS for DBAAS.APPL_GRANTS;
create or replace PUBLIC synonym APPL_SDO_GEOM_METADATA for DBAAS.APPL_SDO_GEOM_METADATA;
create or replace PUBLIC synonym APPL_SEQUENCES for DBAAS.APPL_SEQUENCES;



prompt
prompt vullen van SPATIAL-METADATA-TABEL
prompt let op: zorg wel dat de DBAAS-PACKAGES ZIJN AANGEMAAKT OP DE NDBT/SDBT-db:
PROMPT

--NDBt: maak-db-LINK aan naar NDB ALS USER dbaas
begin
  -- Call the procedure
  dbaas_dba.create_classic_dblink(p_link_name => 'QARTO_DBAAS_DBL' ,
                                  p_owner => 'DBAAS' ,
                                  p_user => 'ATTIC' ,
                                  p_password => 'RWSATTIC2012' ,
                                  p_host => '145.45.12.171' ,
                                  p_port => 1526,
                                  p_service => 'NDB_RWS_NL' );
end;
/

--SDBT: maak-db-LINK aan naar SDB ALS USER DBAAS
begin
  -- Call the procedure
  dbaas_dba.create_classic_dblink(p_link_name => 'QARTO_DBAAS_DBL' ,
                                  p_owner => 'DBAAS' ,
                                  p_user => 'WDI_EIGENAAR' ,
                                  p_password => 'RWSWDI_EIGENAAR2012' ,
                                  p_host => '145.45.12.171' ,
                                  p_port => 1526,
                                  p_service => 'SDB_RWS_NL' );
end;
/
--ndb/sdb
INSERT INTO APPL_SDO_GEOM_METADATA (SELECT  owner, table_name, column_name, diminfo, srid from all_sdo_geom_metadata@qarto_dbaas_dbl);
select * from appl_sdo_geom_metadata ap where not exists (select '' from all_sdo_geom_metadata al where al.owner=ap.owner and al.table_name=ap.table_name and al.column_name=ap.column_name )

--NDBT:
--insert ontbrekende METADATA vanuit APPL_SDO_GEOM_METADATA...
connect attic/rwsattic2012@ndbt
insert INTO user_sdo_geom_metadata select table_name, column_name, diminfo, srid from appl_sdo_geom_metadata ap where owner='ATTIC' and not exists (select '' from user_sdo_geom_metadata al where al.table_name=ap.table_name and al.column_name=ap.column_name )
connect adm/rwsadm2012@ndbt
insert INTO user_sdo_geom_metadata select table_name, column_name, diminfo, srid 
                                   from appl_sdo_geom_metadata ap 
								   where owner='ADM' 
                                   and not exists (select '' from user_sdo_geom_metadata al where al.table_name=ap.table_name and al.column_name=ap.column_name )
--SDBT:
connect adm/rwsadm2012@sdbt
insert INTO user_sdo_geom_metadata select table_name, column_name, diminfo, srid from appl_sdo_geom_metadata ap where owner='ADM' and not exists (select '' from user_sdo_geom_metadata al where al.table_name=ap.table_name and al.column_name=ap.column_name )
connect wdi_eigenaar/rwswdi_eigenaar2012@sdbt
insert INTO user_sdo_geom_metadata select table_name, column_name, diminfo, srid from appl_sdo_geom_metadata ap where owner='WDI_EIGENAAR' and not exists (select '' from user_sdo_geom_metadata al where al.table_name=ap.table_name and al.column_name=ap.column_name )


PROMPT 
PROMPT EINDE SCRIPT
PROMPT

