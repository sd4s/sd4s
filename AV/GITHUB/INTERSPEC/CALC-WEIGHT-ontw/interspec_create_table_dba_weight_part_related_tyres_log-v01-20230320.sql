rem ============================================================================
rem Naam     : interspec_create_table_dba_weight_related_tyres_log.sql
rem
rem Doel     : Creeren van LOG-tabel tbv VERWERKING dagelijkse mutaties in SPEC-GEWICHTEN tbv SYNC van INTERSPEC naar SAP
rem             In deze tabel houden we bij welke TYRES volledig opnieuw het gewicht berekend moet worden omdat er min. 1 component is gewijzigd.
rem 
rem            LETOP: dit is de LOG-tabel vanuit DAGELIJKSE VERWERKING van WEIGHT-mutaties vanuit INTERSPEC.
rem
REM VERWERK_DATUM_VANAF (=datum vanaf van vorige run, format dd-mm-yyyy hh:59:59, initieel vullen met startdatum)
REM
rem Parameter: geen
rem
rem Wijzigingshistorie
rem ==================
rem Datum       Naam            Omschrijving
rem 18-03-2023  P.schepens      Creatie
rem                             
rem
rem ============================================================================

--drop sequence DBA_WEIGHT_PARTNEWREV_LOG_SEQ
CREATE SEQUENCE  INTERSPC.DBA_WEIGHT_RELTYRE_LOG_SEQ  MINVALUE 0 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;

--drop table DBA_COMP_PART_NEW_REV_LOG;

prompt descr DBA_WEIGHT_RELATED_TYRE_LOG

PROMPT CREATE TABEL DBA_WEIGHT_RELATED_TYRE_LOG (WRT)

declare
l_stmnt  varchar2(4000);
begin
  l_stmnt := 'CREATE TABLE DBA_WEIGHT_RELATED_TYRE_LOG '||
              '( ID                          NUMBER NOT NULL  '||
              ', tech_calculation_date       date '||
              ', DATUM_VERWERKING            DATE '||
              ', part_no                     VARCHAR2(18 CHAR) '||
              ', revision                    number '||
              ', plant                       varchar2(100 char) '||
              ', alternative                 number(2) '||
			  ', frame_id                    varchar2(100 char) '||
			  ', issued_date                 date ' || 
              ', mainpart                    VARCHAR2(18 CHAR) '||
              ', mainrevision                number '||
              ', mainplant                   varchar2(100 char) '||
              ', mainalternative             number(2) '||
              ', TECH_DAT_LAATSTE_WIJZ       DATE '||
              ', TECH_USER_LAATSTE_WIJZ      VARCHAR2(100 CHAR) '||
			  ', mainframeid                 varchar2(100) '||
              ')';
  execute immediate l_stmnt;
  DBMS_OUTPUT.PUT_LINE('tabel DBA_WEIGHT_RELATED_TYRE_LOG is aangemaakt');
exception
  when others
  then DBMS_OUTPUT.PUT_LINE('tabel DBA_WEIGHT_RELATED_TYRE_LOG bestaat al. is OK');
end;
/
descr DBA_WEIGHT_RELATED_TYRE_LOG;

/*
CREATE TABLE DBA_WEIGHT_RELATED_TYRE_LOG
( ID                          NUMBER NOT NULL
, tech_calculation_date       date 
, DATUM_VERWERKING            DATE 
, part_no                     VARCHAR2(18 CHAR) 
, revision                    number 
, plant                       varchar2(100 char) 
, alternative                 number(2) 
, frame_id                    varchar2(100 char) 
, issued_date                 date 
, mainpart                    VARCHAR2(18 CHAR) 
, mainrevision                number 
, mainplant                   varchar2(100 char) 
, mainalternative             number(2) 
, TECH_DAT_LAATSTE_WIJZ       DATE 
, TECH_USER_LAATSTE_WIJZ      VARCHAR2(100 CHAR) 
, mainframeid                 varchar2(100) 
);

alter table DBA_WEIGHT_RELATED_TYRE_LOG add new_header_base_quantity number;
alter table DBA_WEIGHT_RELATED_TYRE_LOG add old_header_base_quantity number;
alter table DBA_WEIGHT_RELATED_TYRE_LOG add mainframeid varchar2(100) ;


*/
--PK
alter table INTERSPC.DBA_WEIGHT_RELATED_TYRE_LOG DROP CONSTRAINT PK_WEIGHT_RELTYRE_LOG_ID ;
--
ALTER TABLE INTERSPC.DBA_WEIGHT_RELATED_TYRE_LOG ADD CONSTRAINT PK_WEIGHT_RELTYRE_LOG_ID PRIMARY KEY (ID)
USING INDEX
TABLESPACE SPECI ;

--
drop index INTERSPC.IX_WRT_LOG_CALC_DATE;
create index INTERSPC.IX_WRT_LOG_CALC_DATE  ON INTERSPC.DBA_WEIGHT_RELATED_TYRE_LOG (TECH_CALCULATION_DATE) TABLESPACE SPECI
;
drop index INTERSPC.IX_WRT_LOG_DATUM_VERWERKING;
create index INTERSPC.IX_WRT_LOG_DATUM_VERWERKING  ON INTERSPC.DBA_WEIGHT_RELATED_TYRE_LOG (DATUM_VERWERKING) TABLESPACE SPECI
;
drop index INTERSPC.IX_WRT_LOG_PART_REVISION;
create index INTERSPC.IX_WRT_LOG_PART_REVISION       ON INTERSPC.DBA_WEIGHT_RELATED_TYRE_LOG (PART_NO, REVISION) TABLESPACE SPECI
;



create or replace trigger DBA_WRT_BRIU_TR 
before insert or update
on DBA_WEIGHT_RELATED_TYRE_LOG 
for each row
declare
gc_trigger          constant varchar2(32) := 'dba_wrt_briu_tr' ;
begin
  if :new.id is null
  then select DBA_WEIGHT_RELTYRE_LOG_SEQ.nextval into :new.id from dual;
  end if;
  if :new.tech_calculation_date is null
  then :new.tech_calculation_date := sysdate;
  end if;
  -- tech-attributen vullen
  if :new.TECH_DAT_LAATSTE_WIJZ is null
  then :new.TECH_DAT_LAATSTE_WIJZ := sysdate;
  end if;
  if :new.TECH_USER_LAATSTE_WIJZ is null
  then :new.TECH_USER_LAATSTE_WIJZ := user;
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

--test insert:

insert into DBA_WEIGHT_RELATED_TYRE_LOG
(part_no
,revision)
values ('peter',1);

select * from DBA_WEIGHT_RELATED_TYRE_LOG;

COMMIT;




/*==============================================================*/
/* View: DBA_VW_WEIGHT_RELATED_TYRE_LOG                         */
/*==============================================================*/



prompt
prompt einde script
prompt

