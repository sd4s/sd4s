--create procedure to count total number of rows in AWS-REPLICATED-tables off table DBA_AWS_SUPPLEMENTAL_LOG
--and store te results in table DBA_AWS_SUPPLEMENTAL_COUNT
--
drop table DBA_AWS_SUPPLEMENTAL_COUNT cascade constraints;
--
CREATE TABLE DBA_AWS_SUPPLEMENTAL_COUNT
( ASC_ID              NUMBER(10)
, ASC_SCHEMA_OWNER    varchar2(100)   
, ASC_TABLE_NAME      varchar2(100)  
, ASC_CHECK_DATE      DATE
, ASC_COUNT           number
, ASC_OPMERKING       varchar2(1000)
);

--table_name     = naam van tabel die van supplementatl-logging moet worden voorzien
--check_date     = SYSDATE van het moment waarop de SUPPLEMENTAL-COUNT van de gerelateerde tabel is bepaald !!
--count          = aantal rijen van replicated-table in UNILAB-/interspec schema

ALTER TABLE DBA_AWS_SUPPLEMENTAL_COUNT ADD CONSTRAINT AT_ASC_ID_PK PRIMARY KEY (ASC_ID);
--
CREATE UNIQUE INDEX AT_ASC_TABLE_NAME_UK ON DBA_AWS_SUPPLEMENTAL_COUNT (ASC_SCHEMA_OWNER, ASC_TABLE_NAME, ASC_CHECK_DATE)  ;


--
--SEQUENCE ASL_ID gebruiken we ook voor het genereren van ID's voor de COUNT-LOGGING TABEL !!!
--

--
-- grant privileges
--
--grant select,insert,update,delete on DBA_AWS_SUPPLEMENTAL_COUNT to UNILAB;
grant select,insert,update,delete on DBA_AWS_SUPPLEMENTAL_COUNT to INTERSPC;
--grant select                      on ASL_ID_SEQ to UNILAB;
grant select                      on ASL_ID_SEQ to INTERSPC;

--
-- public synonyms maken
--
create or replace PUBLIC synonym DBA_AWS_SUPPLEMENTAL_COUNT for DBA_AWS_SUPPLEMENTAL_COUNT;

--
--create insert-TRIGGER om ASL_ID te vullen.
--
--drop trigger asl_tr_bri;
--
create or replace TRIGGER at_asc_tr_bri
BEFORE INSERT ON dba_aws_supplemental_count
FOR EACH ROW
BEGIN
  IF inserting AND :NEW.ASC_id IS NULL 
  THEN
    --USE ASL-ID-SEQ also to fill asc_id !!
    SELECT ASL_id_seq.nextval INTO :NEW.ASC_id FROM dual;
  END IF;
END;
/


prompt 
propmt einde script
prompt
