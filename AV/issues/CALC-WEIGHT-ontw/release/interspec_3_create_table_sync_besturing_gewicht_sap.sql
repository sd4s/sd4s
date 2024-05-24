rem ============================================================================
rem Naam     : interspec_create_table_sync_besturing_gewicht_sap.sql
rem
rem Doel     : Creeren van besturings-tabel tbv synchronisatie SPEC-GEWICHTEN van INTERSPEC naar SAP
rem            Op basis van deze tabel kan vanuit INTERSPEC de synchronisatie STOPGEZET worden !!!
rem 
rem            LETOP: dit is de stuurtabel vanuit INTERSPEC.
rem
REM haal start-datum op (lees: datum-verwerkt van vorige run, is actuele voorkomen in stuurtabel !)
REM  VERWERKING_AAN     (=J/N, Alleen indien J dan verder gaan met verwerken)
REM  VERWERK_DATUM_VANAF (=datum vanaf van vorige run, format dd-mm-yyyy hh:59:59, initieel vullen met startdatum)
REM  VERWERK_DATUM_TM   (=datum tot wanneer (TRUNC(SYSDATE) er verwerkt is, format dd-mm-yyyy hh:59:59, initieel vullen met einddatum van een mutatie-verwerkings-run)
REM  DATUM_ONTLADEN_TM  (=datum t/m van vorige run, format dd-mm-yyyy hh:59:59, initieel vullen met startdatum)
REM  SYNC_PERIODE       (=periode in dagen, default=1 DAG, synchronisatie loopt van hh:00:00 tot/met hh:59:59 )
REM
rem Parameter: geen
rem
rem Wijzigingshistorie
rem ==================
rem
rem Datum       Naam            Omschrijving
rem 14-07-2022  P.schepens      Creatie
rem                             
rem
rem ============================================================================

--
CREATE SEQUENCE  INTERSPC.DBA_WEIGHT_CALC_SEQ  MINVALUE 0 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;


--drop table DBA_SYNC_BESTURING_WEIGHT_SAP;

prompt descr DBA_SYNC_BESTURING_WEIGHT_SAP

PROMPT CREATE TABEL DBA_SYNC_BESTURING_WEIGHT_SAP (WEIGHT)

declare
l_stmnt  varchar2(4000);
begin
  l_stmnt := 'CREATE TABLE DBA_SYNC_BESTURING_WEIGHT_SAP '||
              '( ID                          NUMBER NOT NULL  '||
              ', SBW_MUT_VERWERKING_AAN      VARCHAR2(1)  NOT NULL '||
              ', SBW_SYNC_PERIODE_DAGEN      NUMBER(2)    NOT NULL '||      
              ', SBW_DATUM_VERWERKT_VANAF    DATE '||
              ', SBW_DATUM_VERWERKT_TM       DATE '||
			  ', SBW_AANTAL_TYRES            NUMBER '||
              ', SBW_DATUM_ONTLADEN_SAP_TM   DATE '||
              ', SBW_TECH_DAT_LAATSTE_WIJZ   DATE '||
              ', SBW_TECH_USER_LAATSTE_WIJZ  VARCHAR2(100 CHAR) '||
			  ', SBW_SYNC_TYPE               VARCHAR2(10 CHAR) '||
			  ', SBW_SELECTED_FRAME_ID       VARCHAR2(4000 CHAR) '||
              ')';
  execute immediate l_stmnt;
  DBMS_OUTPUT.PUT_LINE('tabel DBA_SYNC_BESTURING_WEIGHT_SAP is aangemaakt');
exception
  when others
  then DBMS_OUTPUT.PUT_LINE('tabel DBA_SYNC_BESTURING_WEIGHT_SAP bestaat al. is OK');
end;
/

/*
CREATE TABLE DBA_SYNC_BESTURING_WEIGHT_SAP
( ID                          NUMBER NOT NULL
, SBW_MUT_VERWERKING_AAN      VARCHAR2(1)  NOT NULL
, SBW_SYNC_PERIODE_DAGEN      NUMBER(2)    NOT NULL
, SBW_DATUM_VERWERKT_VANAF
, SBW_DATUM_VERWERKT_TM
, SBW_DATUM_ONTLADEN_SAP_TM   DATE 
, SBW_TECH_DAT_LAATSTE_WIJZ   DATE 
, SBW_TECH_USER_LAATSTE_WIJZ  VARCHAR2(100 CHAR)
, SBW_SYNC_TYPE               VARCHAR2(10 CHAR) 
, SBW_SELECTED_FRAME_ID       VARCHAR2(4000 CHAR) 
);

ALTER TABLE DBA_SYNC_BESTURING_WEIGHT_SAP ADD SBW_SYNC_TYPE VARCHAR2(10 CHAR);
ALTER TABLE DBA_SYNC_BESTURING_WEIGHT_SAP ADD SBW_SELECTED_FRAME_ID VARCHAR2(4000 CHAR);

*/
--PK
alter table INTERSPC.DBA_SYNC_BESTURING_WEIGHT_SAP DROP CONSTRAINT PK_SBW_SAP_ID ;
--
ALTER TABLE INTERSPC.DBA_SYNC_BESTURING_WEIGHT_SAP ADD CONSTRAINT PK_SBW_SAP_ID PRIMARY KEY (ID)
USING INDEX
TABLESPACE SPECI ;

--CHECK-CONSTRAINT
alter table DBA_SYNC_BESTURING_WEIGHT_SAP
   add constraint DBA_SBW_MUT_VERWERKING_AAN_CC check (SBW_MUT_VERWERKING_AAN in ('J','N'));


--GRANT SELECT,INSERT,UPDATE,DELETE ON DBA_SYNC_BESTURING_WEIGHT_SAP TO SCI_BRK_DBL;
--GRANT SELECT,INSERT,UPDATE,DELETE ON DBA_SYNC_BESTURING_WEIGHT_SAP TO R_BRK_SEL;


create or replace trigger DBA_SBW_BRIU_TR 
before insert or update
on DBA_SYNC_BESTURING_WEIGHT_SAP 
for each row
declare
gc_trigger          constant varchar2(32) := 'dba_sbw_briu_tr' ;
begin
  if :new.id is null
  then select dba_weight_calc_seq.nextval into :new.id from dual;
  end if;
  -- tech-attributen vullen
  if :new.SBW_TECH_DAT_LAATSTE_WIJZ is null
  then :new.SBW_TECH_DAT_LAATSTE_WIJZ := sysdate;
  end if;
  if :new.SBW_TECH_USER_LAATSTE_WIJZ is null
  then :new.SBW_TECH_USER_LAATSTE_WIJZ := user;
  end if;
  --
  --  Errors handling
exception
  when others
  then
    dbms_output.put_line('ALG-OTHER-EXCP-fout '||gc_trigger||':'||sqlcode||'-'||sqlerrm );
    raise;
end;
/

--INSERT EERSTE STUUR-RECORD !!!

insert into DBA_SYNC_BESTURING_WEIGHT_SAP
( ID
, SBW_MUT_VERWERKING_AAN 
, SBW_SYNC_PERIODE_DAGEN
, SBW_DATUM_VERWERKT_VANAF
, SBW_DATUM_VERWERKT_TM
, SBW_AANTAL_TYRES 
, SBW_DATUM_ONTLADEN_SAP_TM
)
values (1,'J',1,to_date('01-07-2022','dd-mm-yyyy'),to_date('30-06-2022 23:59:59','dd-mm-yyyy hh24:mi:ss'),0, to_date('01-07-2022','dd-mm-yyyy'))
;
--
COMMIT;


/*==============================================================*/
/* View: DBA_VW_SYNC_BEST_WEIGHT_SAP                            */
/*==============================================================*/
create or replace view DBA_VW_SYNC_BEST_WEIGHT_SAP 
(ID
,SBW_MUT_VERWERKING_AAN
,SBW_SYNC_PERIODE_DAGEN
,SBW_DATUM_VERWERKT_VANAF
,SBW_DATUM_VERWERKT_TM
,SBW_AANTAL_TYRES 
,SBW_DATUM_ONTLADEN_SAP_TM
)
as
select ID
,      SBW_MUT_VERWERKING_AAN
,      SBW_SYNC_PERIODE_DAGEN
,      SBW_DATUM_VERWERKT_VANAF
,      SBW_DATUM_VERWERKT_TM
,      SBW_AANTAL_TYRES 
,      SBW_DATUM_ONTLADEN_SAP_TM
from DBA_SYNC_BESTURING_WEIGHT_SAP  SBW
;



prompt
prompt einde script
prompt

