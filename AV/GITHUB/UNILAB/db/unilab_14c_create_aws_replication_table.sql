--create dbaas DBA-AWS-replication-tables...
conn unilab/unilab@u611
--
drop table DBA_AWS_SUPPLEMENTAL_LOG cascade constraints;
--
CREATE TABLE DBA_AWS_SUPPLEMENTAL_LOG
( ASL_ID              NUMBER(10)
, ASL_SCHEMA_OWNER    varchar2(100 CHAR)   
, ASL_TABLE_NAME      varchar2(100 CHAR)  
, ASL_PK_EXISTS_JN    varchar2(1 CHAR)
, ASL_SUPPL_LOG_TYPE  varchar2(3 CHAR)
, ASL_IND_ACTIVE_JN   varchar2(1 CHAR)  
, ASL_ACTIVATION_DATE DATE
, ASL_OPMERKING       varchar2(1000 CHAR)
);

--table_name     = naam van tabel die van supplementatl-logging moet worden voorzien
--pk_exists_jn   = waarde in (J,N), WORDT DOOR BEHEERDER HANDMATIG GEVULD
--suppl_log_type = waarde in (PK, ALL), WORDT DOOR BEHEERDER HANDMATIG GEVULD, Deze instelling bepaald welke logging er wordt aangezet.
--                 Ondanks dat tabel een PK heeft, kan beheerder er toch voor kiezen om voor de ALL-COLUMNS te gaan !!
--ind_active_jn  = waarde in (J,N), WORDT DOOR BEHEERDER HANDMATIG GEVULD 
--activation_date = SYSDATE van het moment waarop de SUPPLEMENTAL-LOGGING van deze tabel is aangezet !!

ALTER TABLE DBA_AWS_SUPPLEMENTAL_LOG MODIFY ASL_SCHEMA_OWNER VARCHAR2(100 CHAR) ;
ALTER TABLE DBA_AWS_SUPPLEMENTAL_LOG MODIFY ASL_TABLE_NAME VARCHAR2(100 CHAR) ;
ALTER TABLE DBA_AWS_SUPPLEMENTAL_LOG MODIFY ASL_PK_EXISTS_JN VARCHAR2(1 CHAR) ;
ALTER TABLE DBA_AWS_SUPPLEMENTAL_LOG MODIFY ASL_SUPPL_LOG_TYPE VARCHAR2(3 CHAR) ;
ALTER TABLE DBA_AWS_SUPPLEMENTAL_LOG MODIFY ASL_IND_ACTIVE_JN VARCHAR2(1 CHAR) ;
ALTER TABLE DBA_AWS_SUPPLEMENTAL_LOG MODIFY ASL_OPMERKING VARCHAR2(1000 CHAR) ;
--
ALTER TABLE DBA_AWS_SUPPLEMENTAL_LOG ADD CONSTRAINT AT_ASL_ID_PK PRIMARY KEY (ASL_ID);
--
CREATE UNIQUE INDEX AT_ASL_TABLE_NAME_UK ON DBA_AWS_SUPPLEMENTAL_LOG (ASL_SCHEMA_OWNER, ASL_TABLE_NAME)  ;


--
--CREATE SEQUENCE
--
drop sequence ASL_id_seq;
--
CREATE SEQUENCE  ASL_ID_SEQ
MINVALUE 1 
MAXVALUE 9999999999999999999999999999 
INCREMENT BY 1 
START WITH 1 
NOCACHE  
ORDER NOCYCLE 
;


--
-- grant privileges
--
grant select,insert,update,delete on DBA_AWS_SUPPLEMENTAL_LOG to UNILAB;
grant select,insert,update,delete on DBA_AWS_SUPPLEMENTAL_LOG to INTERSPC;
grant select                      on ASL_ID_SEQ to UNILAB;
grant select                      on ASL_ID_SEQ to INTERSPC;

--
-- public synonyms maken
--
create or replace PUBLIC synonym DBA_AWS_SUPPLEMENTAL_LOG for DBA_AWS_SUPPLEMENTAL_LOG;
create or replace PUBLIC synonym ASL_ID_SEQ for ASL_ID_SEQ;


--
--create insert-TRIGGER om ASL_ID te vullen.
--
--drop trigger asl_tr_bri;
--
create or replace TRIGGER at_asl_tr_bri
BEFORE INSERT ON dba_aws_supplemental_log
FOR EACH ROW
BEGIN
  IF inserting AND :NEW.ASL_id IS NULL 
  THEN
    SELECT ASL_id_seq.nextval INTO :NEW.ASL_id FROM dual;
  END IF;
END;
/

--
-- Insert INHOUD DBA_AWS_SUPPLEMENTAL_LOG met data uit spreadsheet:
-- (We weten op dit moment nog niet of tabel wel/niet een PK heeft...Dit vullen we later met aparte procedure...)
--
/*
insert into DBA_AWS_SUPPLEMENTAL_LOG (ASL_schema_owner, ASL_table_name) values ('UNILAB','');
insert into DBA_AWS_SUPPLEMENTAL_LOG (ASL_schema_owner, ASL_table_name) values ('INTERSPC','');
*/

/*
--LET OP: VOOR DE VULLING HEBBEN WE NU EEN APART-INSERT-SCRIPT !! KOMT LATER.
--
--AI-TABLES EXTRA TOEVOEGEN INDIEN DEZE NOG NIET BESTAAN !!!
SELECT tab.asl_schema_owner, tab.ASL_TABLE_NAME
FROM DBA_AWS_SUPPLEMENTAL_LOG tab
WHERE tab.ASL_table_name in 
('UTEQ'
,'UTRQ'
,'UTRQAU'
,'UTRQGK'
,'UTRQGKISTEST'
,'UTRQII'
,'UTSC'
,'UTSCAU'
,'UTSCGK'
,'UTSCGKISTEST'
,'UTSCII'
,'UTSCME'
,'UTSCMECELL'
,'UTSCMEGK'
,'UTSCMEGKME_IS_RELEVANT'
,'UTSCPA'
,'UTSCPAAU'
,'UTSS'
);

--ONTBREKENDE-TABEL TOEVOEGEN ONTBREKENDE-AI-TABEL:
insert into DBA_AWS_SUPPLEMENTAL_LOG (ASL_schema_owner, ASL_table_name) values ('UNILAB','UTRQAU');
*/
--
/*
AWS-TABLE                      ORACLE-TABLE-NAME (??)
---------------------          --------------------------
BOM_LAYOUT                    ITBOMLY
OBJECT                        ITOID of ITOIH
PART_BOM_LAYOUT               -
PROPERTY_LAYOUT_HEADER        HEADER
SECTION_PROPERTY_VALUE        -
SPECIFICATION_FREETEXT        SPECIFICATION_TEXT
SPECIFICATION_KEYWORD         SPECIFICATION_KW
SPECIFICATION_STATUS          STATUS kolom in SPECIFICATION_HEADER?
SPECIFICATION_STATUS_HISTORY  STATUS_HISTORY
*/

/*
SELECT tab.asl_schema_owner, tab.ASL_TABLE_NAME
FROM DBA_AWS_SUPPLEMENTAL_LOG tab
WHERE tab.ASL_table_name in 
('ATTACHED_SPECIFICATION'  --OK
,'BOM_HEADER'              --OK
,'BOM_ITEM'                --OK
,'ITBOMLY'                 --WAS: 'BOM_LAYOUT'
,'ITOID','ITOIH'           --WAS: 'OBJECT'
--,'PART_BOM_LAYOUT'
,'HEADER'                  --WAS: 'PROPERTY_LAYOUT_HEADER' 
,'REFERENCE_TEXT'          --OK
--,'SECTION_PROPERTY_VALUE'
,'SPECIFICATION_TEXT'      --WAS: 'SPECIFICATION_FREETEXT'
,'SPECIFICATION_KW'        --WAS: 'SPECIFICATION_KEYWORD'
,'SPECIFICATION_PROP'      --OK
,'SPECIFICATION_SECTION'   --OK
--,'SPECIFICATION_STATUS'
,'STATUS_HISTORY'          --WAS: 'SPECIFICATION_STATUS_HISTORY'
);
--ALLE TABELLEN KOMEN AL VOOR !!!!
*/







prompt
prompt einde script
prompt

