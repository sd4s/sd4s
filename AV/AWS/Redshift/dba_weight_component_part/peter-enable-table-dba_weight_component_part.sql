--TABEL: DBA_WEIGHT_COMPONENT_PART
--
--*************************************************************************************************************
--INTERSPEC: grant awsdwh for table: DBA_WEIGHT_COMPONENT_PART
--*************************************************************************************************************
--conn INTERSPC/INTERSPC@IS61
set serveroutput on
declare
cursor c1 is select table_name from user_tables;
cmd varchar2(200);
begin
dbms_output.enable(1000000);
for c in c1 
loop
  cmd := 'GRANT SELECT ON '||c.table_name|| ' TO AWSDWH' ;
  DBMS_OUTPUT.PUT_LINE(cmd);
  execute immediate cmd;
end loop;
end;
/


--*************************************************************************************************************
--INTERSPEC: voeg record aan supplemental-log-tabel toe, als basis voor latere procedures voor beheer !!!!!!!
--*************************************************************************************************************
--51	INTERSPC	ITOIRAW	J	ALL	N		 COLUMN=DESKTOP_OBJECT=BLOB
select * from DBA_AWS_SUPPLEMENTAL_LOG where asl_table_name LIKE ('%WEIGHT%');
select * from DBA_AWS_SUPPLEMENTAL_LOG where asl_table_name in ('DBA_WEIGHT_COMPONENT_PART');
--
select ASL_id, ASL_schema_owner, ASL_table_name, ASL_pk_exists_jn, ASL_suppl_log_type, ASL_ind_active_jn, ASL_activation_date 
from dba_aws_supplemental_log 
where ASL_ind_active_jn='J' and ASL_table_name='DBA_WEIGHT_COMPONENT_PART'
;
--add supp.log
INSERT INTO DBA_AWS_SUPPLEMENTAL_LOG (ASL_SCHEMA_OWNER, ASL_TABLE_NAME, ASL_PK_EXISTS_JN, ASL_SUPPL_LOG_TYPE, ASL_IND_ACTIVE_JN, ASL_ACTIVATION_DATE ) 
VALUES ('INTERSPC' ,'DBA_WEIGHT_COMPONENT_PART','J','ALL','J',SYSDATE);
--ZORG DAT asl-activiation-date=NULL, anders werkt procedure niet:
UPDATE dba_aws_supplemental_log set ASL_IND_ACTIVE_JN='J' , ASL_activation_date=null where asl_table_name in ('DBA_WEIGHT_COMPONENT_PART');
commit;
--conn system
alter system switch logfile; 

--*************************************************************************************************************
--controle op PK 
--*************************************************************************************************************
--WELKE INDEXEN OP SPECDATA AANWEZIG:
SELECT * from all_indexes where table_name = 'DBA_WEIGHT_COMPONENT_PART';
/*
INTERSPC	PK_WEIGHT_COMP_PART_ID			NORMAL	INTERSPC	DBA_WEIGHT_COMPONENT_PART	TABLE	UNIQUE         --PK !!!!!!!!!!!
INTERSPC	UK_WEIGHT_COMP_PART_NO			NORMAL	INTERSPC	DBA_WEIGHT_COMPONENT_PART	TABLE	UNIQUE
INTERSPC	IX_WEIGHT_COMP_DATUM_VERWERK	NORMAL	INTERSPC	DBA_WEIGHT_COMPONENT_PART	TABLE	NONUNIQUE
INTERSPC	IX_WEIGHT_COMP_PART_REVISION	NORMAL	INTERSPC	DBA_WEIGHT_COMPONENT_PART	TABLE	NONUNIQUE
INTERSPC	IX_WEIGHT_PART_REVISION			NORMAL	INTERSPC	DBA_WEIGHT_COMPONENT_PART	TABLE	NONUNIQUE
INTERSPC	IX_WEIGHT_MAINPART_COMP			NORMAL	INTERSPC	DBA_WEIGHT_COMPONENT_PART	TABLE	NONUNIQUE
*/


--
--*************************************************************************************************************
--ADD SUPPLEMENTAL-LOGGING. BETER MET PROCEDURE:

SET SERVEROUTPUT ON
--INCL DEBUG, GEEN COMMIT...
--interspec:
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'DBA_WEIGHT_COMPONENT_PART', p_debug=>'J'); END;
/
--DAADWERKELIJK AANZETTEN...
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'DBA_WEIGHT_COMPONENT_PART', p_debug=>'N'); END;
/
commit;
--conn system
alter system switch logfile; 


--*****************************
--controle achteraf:
SET LINESIZE 300
select owner, table_name
from ALL_LOG_GROUPS 
where  OWNER='INTERSPC' 
and TABLE_NAME in ('DBA_WEIGHT_COMPONENT_PART')
order by owner, table_name
;

--
--HERSTELLEN / VERWIJDEREN VAN SUPPLEMENTAL-LOGGING
--OP GEHELE DATABASE: ALTER DATABASE DROP SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
--                    ALTER DATABASE DROP SUPPLEMENTAL LOG DATA;
--PER TABEL:   alter table [TABLE_NAME] drop supplemental log group [GROUP_NAME]
--OF:
/*
alter table UTBLOB drop supplemental log data (all) columns;
--
alter system switch logfile; 
*/

--**************************************************************************
--CREATE VIEW ON TOP OF TABLE FOR TYRE-FINISHED-PRODUCT-PARTS
--**************************************************************************
  CREATE OR REPLACE FORCE VIEW "INTERSPC"."DBA_VW_CRRNT_WEIGHT_TYRES" ("PART_NO", "REVISION", "ALTERNATIVE", "MAINFRAMEID", "WEIGHT_UNIT_KG", "HEADER_ISSUEDDATE", "HEADER_STATUS_DESC", "SAP_ARTICLE_CODE", "SAP_DA_ARTICLE_CODE") AS 
  select dwc.part_no
,      dwc.revision
,      dwc.alternative
,      dwc.mainframeid
,      nvl(dwc.comp_part_eenheid_kg,0)                           WEIGHTUNITKG
,      to_char(dwc.header_issueddate,'dd-mm-yyyy hh24:mi:ss')    HEADERISSUEDDATE
,      dwc.header_status                                         HEADERSTATUSDESC
,      dwc.sap_article_code
,      dwc.sap_da_article_code
from  dba_weight_component_part dwc
WHERE dwc.mainpart            = dwc.part_no                --neem start-regel voor de TYRE
--and   dwc.remark              like '%MAINPART-HEADER-TYRE:%'
and   dwc.component_part_no   is null        
and   dwc.component_revision  is null
and   dwc.HEADER_STATUS in (select s.sort_desc from status s where status_type='CURRENT')   
and   dwc.HEADER_ISSUEDDATE is not null
AND   dwc.REVISION = (SELECT max(dwc2.revision) 
                      FROM dba_weight_component_part dwc2 
			  	  	  WHERE dwc2.part_no = dwc.part_no 
					  and   dwc2.component_part_no   is null        
                      and   dwc2.component_revision  is null
					  --and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0
				     )
AND   dwc.DATUM_VERWERKING = (SELECT max(dwc2.datum_verwerking)  
                              FROM dba_weight_component_part dwc2 
                              WHERE dwc2.part_no = dwc.part_no 
                              and   dwc.component_part_no   is null         
                              and   dwc.component_revision  is null					  
                              --and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0       --header altijd actuele selecteren
                              )
AND   dwc.TECH_CALCULATION_DATE = (SELECT max(dwc2.tech_calculation_date)    
                                   FROM dba_weight_component_part dwc2 
                                   WHERE dwc2.part_no             = dwc.part_no 
								   and   dwc2.datum_verwerking    = dwc.datum_verwerking
                                   and   dwc2.component_part_no   is null         
                                   and   dwc2.component_revision  is null					  
                                   --and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0       --header altijd actuele selecteren
				                  )

;
