MATERIALIZED-VIEW:  mv_bom_item_comp_header
--
--*************************************************************************************************************
--INTERSPEC: grant awsdwh for table: mv_bom_item_comp_header
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

GRANT SELECT ON MV_BOM_ITEM_COMP_HEADER TO AWSDWH;

--*************************************************************************************************************
--controle op PK 
--*************************************************************************************************************
--WELKE INDEXEN OP MV_BOM_ITEM_COMP_HEADER AANWEZIG:
SELECT * from all_indexes where table_name = 'MV_BOM_ITEM_COMP_HEADER';
/*
INTERSPC	PK_MV_BOM_ITEM_PART_REV	NORMAL	INTERSPC	MV_BOM_ITEM_COMP_HEADER	TABLE	UNIQUE		DISABLED		SPECI	2	255	65536	1048576	1	2147483645						10	YES	2	9315	958190	1	1	938607	VALID	958190	958190	09-02-2024 09:11:51	1	1	NO	N	N	N	DEFAULT	DEFAULT	DEFAULT	NO						YES				NO	NO	NO	VISIBLE		YES
INTERSPC	IX_MV_BOM_ITEM_PART_REV	NORMAL	INTERSPC	MV_BOM_ITEM_COMP_HEADER	TABLE	NONUNIQUE	DISABLED		SPECI	2	255	65536	1048576	1	2147483645						10	YES	2	9341	150714	1	5	854948	VALID	941000	106280	08-02-2024 22:00:17	1	1	NO	N	N	N	DEFAULT	DEFAULT	DEFAULT	NO						YES				NO	NO	NO	VISIBLE		YES
INTERSPC	IX_MV_BOM_ITEM_COMP_REV	NORMAL	INTERSPC	MV_BOM_ITEM_COMP_HEADER	TABLE	NONUNIQUE	DISABLED		SPECI	2	255	65536	1048576	1	2147483645						10	YES	2	10727	80392	1	8	688025	VALID	947021	89164	08-02-2024 22:00:18	1	1	NO	N	N	N	DEFAULT	DEFAULT	DEFAULT	NO						YES				NO	NO	NO	VISIBLE		YES
*/




--*************************************************************************************************************
--INTERSPEC: voeg record aan supplemental-log-tabel toe, als basis voor latere procedures voor beheer !!!!!!!
--*************************************************************************************************************
--51	INTERSPC	ITOIRAW	J	ALL	N		 COLUMN=DESKTOP_OBJECT=BLOB
select * from DBA_AWS_SUPPLEMENTAL_LOG where asl_table_name LIKE ('%WEIGHT%');
select * from DBA_AWS_SUPPLEMENTAL_LOG where asl_table_name in ('MV_BOM_ITEM_COMP_HEADER');
--
select ASL_id, ASL_schema_owner, ASL_table_name, ASL_pk_exists_jn, ASL_suppl_log_type, ASL_ind_active_jn, ASL_activation_date 
from dba_aws_supplemental_log 
where ASL_ind_active_jn='J' and ASL_table_name='MV_BOM_ITEM_COMP_HEADER'
;
--add supp.log
INSERT INTO DBA_AWS_SUPPLEMENTAL_LOG (ASL_SCHEMA_OWNER, ASL_TABLE_NAME, ASL_PK_EXISTS_JN, ASL_SUPPL_LOG_TYPE, ASL_IND_ACTIVE_JN, ASL_ACTIVATION_DATE ) 
VALUES ('INTERSPC' ,'MV_BOM_ITEM_COMP_HEADER','J','ALL','J',SYSDATE);

--LET OP: ZORG DAT asl-activiation-date=NULL, anders werkt procedure niet:
UPDATE dba_aws_supplemental_log set ASL_IND_ACTIVE_JN='J' , ASL_activation_date=null where asl_table_name in ('MV_BOM_ITEM_COMP_HEADER');
commit;
--conn system
alter system switch logfile; 



--
--*************************************************************************************************************
--ADD SUPPLEMENTAL-LOGGING. BETER MET PROCEDURE:

SET SERVEROUTPUT ON
--INCL DEBUG, GEEN COMMIT...
--interspec:
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'MV_BOM_ITEM_COMP_HEADER', p_debug=>'J'); END;
/
--DAADWERKELIJK AANZETTEN...
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'MV_BOM_ITEM_COMP_HEADER', p_debug=>'N'); END;
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
and TABLE_NAME in ('MV_BOM_ITEM_COMP_HEADER')
order by owner, table_name
;

--
--HERSTELLEN / VERWIJDEREN VAN SUPPLEMENTAL-LOGGING
--OP GEHELE DATABASE: ALTER DATABASE DROP SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
--                    ALTER DATABASE DROP SUPPLEMENTAL LOG DATA;
--PER TABEL:   alter table [TABLE_NAME] drop supplemental log group [GROUP_NAME]
--OF:
/*
alter table MV_BOM_ITEM_COMP_HEADER drop supplemental log data (all) columns;
--
alter system switch logfile; 
*/

