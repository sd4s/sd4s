--Create hulptabel voor test-werkzaamheden:  interspc.DBA_WEIGHT_COMPONENT_PART
--

--dbms_output.put_line(l_part_no||';'||l_path||';'||l_quantity_path||';'||l_quantity_kg||';'||l_excl_quantity_kg ||';'||l_uom );
--
CREATE SEQUENCE  INTERSPC.DBA_WEIGHT_COMP_PART_SEQ  MINVALUE 0 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;


--tabel wordt gevuld met main-part-no (meestal de band, of vulcanized-tyre, maar kan ook een part-no zijn waar nog component-materialen onderzitten.
DROP TABLE INTERSPC.DBA_WEIGHT_COMPONENT_PART CASCADE CONSTRAINTS;
PURGE RECYCLEBIN;
--
CREATE table INTERSPC.DBA_WEIGHT_COMPONENT_PART
(id                    number         NOT NULL
,tech_calculation_date date
,datum_verwerking      date
,mainpart              VARCHAR2(18 CHAR)
,mainrevision          number
,mainplant             varchar2(100 char)
,mainalternative       number(2)
,mainframeid           varchar2(100 char)
,part_no               VARCHAR2(18 CHAR)
,revision              number
,plant                 varchar2(100 char)
,alternative           number(2)
,header_issueddate     date
,header_status         varchar2(30)
,component_part_no     VARCHAR2(18 CHAR)
,component_description varchar2(1000 char)
,component_revision    number
,component_alternative number(2)
,component_issueddate  date
,component_status      varchar2(30)
,characteristic_id     number
,functiecode           varchar2(1000 char)
,path                  varchar2(4000)
,quantity_path         varchar2(4000)
,bom_quantity_kg       number
,comp_part_eenheid_kg  number
,remark                varchar2(4000)
,lvl                   varchar2(100)
,lvl_tree              varchar2(1000)
,item_number           number(4,0)
)
TABLESPACE SPECD;

--dd. 08-08-2022:
--alter table dba_weight_component_part add lvl          varchar2(100);
--alter table dba_weight_component_part add lvl_tree     varchar2(1000);
--alter table dba_weight_component_part add item_number  number(4,0);

--dd. 16-02-2023:
alter table dba_weight_component_part add sap_article_code     varchar2(40);
alter table dba_weight_component_part add sap_da_article_code  varchar2(40);



--PK
alter table INTERSPC.DBA_WEIGHT_COMPONENT_PART DROP CONSTRAINT PK_WEIGHT_COMP_PART_ID ;
--
ALTER TABLE INTERSPC.DBA_WEIGHT_COMPONENT_PART ADD CONSTRAINT PK_WEIGHT_COMP_PART_ID PRIMARY KEY (ID)
USING INDEX
TABLESPACE SPECI ;

--uk
alter table INTERSPC.DBA_WEIGHT_COMPONENT_PART drop constraint INTERSPC.UK_WEIGHT_COMP_PART_NO;
drop index INTERSPC.UK_WEIGHT_COMP_PART_NO;
--UK incl. de tech_calculation_date zodat we output van meerdere runs in tabel op kunnen slaan !!!
create unique index INTERSPC.UK_WEIGHT_COMP_PART_NO  ON INTERSPC.DBA_WEIGHT_COMPONENT_PART (TECH_CALCULATION_DATE, MAINPART, PART_NO, ALTERNATIVE, ITEM_NUMBER, COMPONENT_PART_NO, CHARACTERISTIC_ID, PATH) TABLESPACE SPECI ;
--

--indexes
drop index INTERSPC.IX_WEIGHT_COMP_PART_REVISION;
create index INTERSPC.IX_WEIGHT_COMP_PART_REVISION  ON INTERSPC.DBA_WEIGHT_COMPONENT_PART (COMPONENT_PART_NO, COMPONENT_REVISION) TABLESPACE SPECI
;

drop index INTERSPC.IX_WEIGHT_PART_REVISION;
create index INTERSPC.IX_WEIGHT_PART_REVISION       ON INTERSPC.DBA_WEIGHT_COMPONENT_PART (PART_NO, REVISION) TABLESPACE SPECI
;

drop index INTERSPC.IX_WEIGHT_MAINPART_COMP;
create index INTERSPC.IX_WEIGHT_MAINPART_COMP       ON INTERSPC.DBA_WEIGHT_COMPONENT_PART (MAINPART, COMPONENT_PART_NO) TABLESPACE SPECI
;

drop index INTERSPC.IX_WEIGHT_COMP_DATUM_VERWERK;
create index INTERSPC.IX_WEIGHT_COMP_DATUM_VERWERK  ON INTERSPC.DBA_WEIGHT_COMPONENT_PART (DATUM_VERWERKING) TABLESPACE SPECI
;


--trigger
--drop trigger DBA_WEIGHT_COMP_PART_BRIU;
--
create or replace TRIGGER DBA_WEIGHT_COMP_PART_BRI
BEFORE INSERT ON INTERSPC.DBA_WEIGHT_COMPONENT_PART
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  if :new.id is null
  then select dba_weight_comp_part_seq.nextval into :new.id from dual;
  end if;
  if :new.tech_calculation_date is null
  then :new.tech_calculation_date := sysdate;
  end if;
  --
END;
/

/*
--Van deze procedure is een apart CREATE-SCRIPT gemaakt !!!!
--Dit was origineel, maar wordt vanaf 08-08-2022 verder vanuit deze locatie niet onderhouden...
--
--AUTONOMOUS-procedure voor inserten van WEIGH-CALCULATION COMPONENT-PARTS:
create or replace procedure DBA_INSERT_WEIGHT_COMP_PART (p_tech_calculation_date date default null
                                                        ,p_datum_verwerking      date default null
                                                        ,p_mainpart              varchar2
                                                        ,p_mainrevision          number
                                                        ,p_mainplant             varchar2
                                                        ,p_mainalternative       number
                                                        ,p_mainframeid           varchar2
                                                        ,p_part_no               varchar2
														,p_revision              number
                                                        ,p_plant                 varchar2
                                                        ,p_alternative           number
														,p_header_issueddate     date
														,p_header_status         varchar2
														,p_component_part_no     varchar2
                                                        ,p_component_description varchar2
														,p_component_revision    number
														,p_component_alternative number
														,p_component_issueddate  date
														,p_component_status      varchar2
 								                        ,p_characteristic_id     number
														,p_functiecode           varchar2
								                        ,p_path                  varchar2
								                        ,p_quantity_path         varchar2
								                        ,p_bom_quantity_kg       number
														,p_comp_part_eenheid_kg  number
								                        ,p_remark                varchar2 ) 
is
pragma autonomous_transaction;
--procedure om bom-header-components incl. unit-kg op te slaan voor SAP-INTERAFACE !!
--TECH_CALCULATION_DATE wordt gevuld vanuit aanroepende procedure DBA_BEPAAL_COMP_PART_GEWICHT
--zodat deze datum voor alle COMPONENT-PARTS van een BAND/TYRE hetzelfde is!
--
l_calc_date   date;
begin
  --
  insert into DBA_WEIGHT_COMPONENT_PART
  (tech_calculation_date
  ,datum_verwerking
  ,mainpart
  ,mainrevision
  ,mainplant
  ,mainalternative
  ,mainframeid
  ,part_no
  ,revision
  ,plant
  ,alternative
  ,header_issueddate
  ,header_status
  ,component_part_no
  ,component_description
  ,component_revision
  ,component_alternative
  ,component_issueddate
  ,component_status
  ,characteristic_id
  ,functiecode
  ,path
  ,quantity_path
  ,bom_quantity_kg
  ,comp_part_eenheid_kg
  ,remark       
  )
  values
  (p_tech_calculation_date
  ,p_datum_verwerking
  ,p_mainpart
  ,p_mainrevision
  ,p_mainplant
  ,p_mainalternative
  ,p_mainframeid
  ,p_part_no
  ,p_revision
  ,p_plant
  ,p_alternative
  ,p_header_issueddate
  ,p_header_status
  ,p_component_part_no
  ,p_component_description
  ,p_component_revision
  ,p_component_alternative
  ,p_component_issueddate
  ,p_component_status
  ,p_characteristic_id
  ,p_functiecode
  ,p_path
  ,p_quantity_path
  ,p_bom_quantity_kg
  ,p_comp_part_eenheid_kg         
  ,p_remark 
  );
  --
  commit;
  --
exception
  when others
  then dbms_output.put_line('DBA-INSERT-WEIGHT-COMP_PART-ALG-EXCP-ERROR MAINPART: '||p_mainpart||' PART_NO: '||p_part_no||' COMP-PART: '||p_COMPONENT_PART_NO||' CHR: '||P_CHARACTERISTIC_ID||' : '||sqlerrm);
       null;
end;
/
show err




--***********************************************************************
--***********************************************************************
--testen van PROCEDURE=DBA_BEPAAL_COMP_PART_GEWICHT met een MAIN-PART-NO:
--***********************************************************************
--***********************************************************************
SET SERVEROUTPUT ON
declare
l_component_part             varchar2(100) := 'EF_Q165/80R15SCS';  --'EC_DE04';  --'EM_764';
begin
  dbms_output.put_line('start dba_bepaal_comp_part_gewicht');
  DBA_BEPAAL_COMP_PART_GEWICHT (p_header_part_no=>l_component_part
                               ,p_alternative=>'1' );
  dbms_output.put_line('eind dba_bepaal_comp_part_gewicht');
END;
/  


/*
-- dit is wel vreemd:
-- Hoe kan het we 2x zelfde partno/componenten tegenkomen vanuit hetzelfde PATH als een vorige ... ???
-- ANTW: doordat sommige part-no door CHARACTERISTIC een betekenis krijgen, bijv. 1 item voor links en andere voor RECHTS...
*/







--Uitvragen VAN DBA_WEIGHT_CALCULATION-tabel:

SELECT part_no, substr(path,1,instr(path,'|',-1)), sum(quantity_kg) , sum(excl_quantity_kg) 
FROM DBA_WEIGHT_CALCULATION 
WHERE main_part_no = 'EF_Y245/35R20QPRX'    --EV_BY245/35R20QPRX
group by part_no, substr(path,1,instr(path,'|',-1))
order by part_no, substr(path,1,instr(path,'|',-1))
;


SELECT sum(quantity_kg), sum(excl_quantity_kg) 
FROM DBA_WEIGHT_CALCULATION 
WHERE main_part_no = 'EF_Y245/35R20QPRX'    --EV_BY245/35R20QPRX
;
/*
22.5297379	11.49179848584842259749816169411974386529
--
--DIT LIJKT WEL HET GOEDE RESULTAAT TE ZIJN !!!!!!
*/
SELECT sum(quantity_kg), sum(excl_quantity_kg), sum(decode(uom,'pcs',0,quantity_kg)), sum(decode(uom,'pcs',0,excl_quantity_kg)) 
FROM DBA_WEIGHT_CALCULATION 
WHERE main_part_no = 'EF_Y245/35R20QPRX'
;
/*
22.5297379	11.49179848584842259749816169411974386529	21.5297379	10.49179848584842259749816169411974386529
--
--CONCLUSIE: NU KOMT GEWICHT OP HETZELFDE UIT ALS DE VULCANIZED-TYRE. ECHTER NOG NIET HETZELFDE ALS IN AS400-XLS, MAAR KOMT WAARSCHIJNLIJK DOOR DUBBELE COMPONENT-PART-NO !!!!
--
*/



SELECT sum(quantity_kg), sum(excl_quantity_kg) 
FROM DBA_WEIGHT_CALCULATION 
WHERE main_part_no = 'EV_BY245/35R20QPRX'   --'EF_Y245/35R20QPRX'
;

SELECT sum(quantity_kg), sum(excl_quantity_kg), sum(decode(uom,'pcs',0,quantity_kg)), sum(decode(uom,'pcs',0,excl_quantity_kg)) 
FROM DBA_WEIGHT_CALCULATION 
WHERE main_part_no = 'EV_BY245/35R20QPRX'   --'EF_Y245/35R20QPRX'
;


PROMPT EINDE SCRIPT






           