--SCRIPT draaien als user = INTERSPEC 
--CLOB-TABELLEN:

--*********************
--INTERSPEC:
--*********************
/*
30	INTERSPC	FRAME_TEXT	J	ALL	N		 COLUMN=TEXT=CLOB
57	INTERSPC	ITPRNOTE	J	ALL	N		 COLUMN=TEXT=CLOB
78	INTERSPC	REFERENCE_TEXT	J	ALL	N		 COLUMN=TEXT=CLOB
88	INTERSPC	SPECIFICATION_TEXT	J	ALL	N		 COLUMN=TEXT=CLOB
*/

set linesize 300
select * from DBA_AWS_SUPPLEMENTAL_LOG where asl_table_name in ('FRAME_TEXT', 'ITPRNOTE', 'REFERENCE_TEXT','SPECIFICATION_TEXT');
/*
30	INTERSPC	FRAME_TEXT	J	ALL	N		 COLUMN=TEXT=CLOB
57	INTERSPC	ITPRNOTE	J	ALL	N		 COLUMN=TEXT=CLOB
78	INTERSPC	REFERENCE_TEXT	J	ALL	N		 COLUMN=TEXT=CLOB
88	INTERSPC	SPECIFICATION_TEXT	J	ALL	N		 COLUMN=TEXT=CLOB
*/
set linesize 300
select ASL_id, ASL_schema_owner, ASL_table_name, ASL_pk_exists_jn, ASL_suppl_log_type, ASL_ind_active_jn, ASL_activation_date 
from dba_aws_supplemental_log 
where ASL_ind_active_jn='J' and ASL_table_name in ('FRAME_TEXT', 'ITPRNOTE', 'REFERENCE_TEXT','SPECIFICATION_TEXT');



UPDATE dba_aws_supplemental_log set ASL_IND_ACTIVE_JN='J'  where asl_table_name in ('FRAME_TEXT', 'ITPRNOTE', 'REFERENCE_TEXT','SPECIFICATION_TEXT');
commit;


alter system switch logfile; 


--
-- Create ADD-SUPPLEMENTAL-LOGGING PROCEDURE
--drop procedure dba_aws_add_supplemental_log;
--create or replace procedure dba_aws_add_supplemental_log (p_table_name varchar2 default null, p_debug varchar2 default 'J')

/*
RECHTSTREEKS: alter table ATTACHED_SPECIFICATION add supplemental log data (all) columns;
*/
--BETER MET PROCEDURE:

SET SERVEROUTPUT ON
--INCL DEBUG, GEEN COMMIT...
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'FRAME_TEXT', p_debug=>'J'); END;
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'ITPRNOTE', p_debug=>'J'); END;
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'REFERENCE_TEXT', p_debug=>'J'); END;
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'SPECIFICATION_TEXT', p_debug=>'J'); END;

--DAADWERKELIJK AANZETTEN...
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'FRAME_TEXT', p_debug=>'N'); END;
/
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'ITPRNOTE', p_debug=>'N'); END;
/
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'REFERENCE_TEXT', p_debug=>'N'); END;
/
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'SPECIFICATION_TEXT', p_debug=>'N'); END;
/
COMMIT;


alter system switch logfile; 




--**********************************
--CONTROLE op LOGGING-GROUPS:
--**********************************
/*
 Name                                      Null?    Type
 ----------------------------------------- -------- ------------
 OWNER                                     NOT NULL VARCHAR2(30)
 LOG_GROUP_NAME                            NOT NULL VARCHAR2(30)
 TABLE_NAME                                NOT NULL VARCHAR2(30)
 LOG_GROUP_TYPE                                     VARCHAR2(28)
 ALWAYS                                             VARCHAR2(11)
 GENERATED                                          VARCHAR2(14)
*/ 

set linesize 300
select owner, table_name
from ALL_LOG_GROUPS 
--where TABLE_NAME in ('FRAME_TEXT')
order by owner, table_name
;

set linesize 300
select owner, table_name
from ALL_LOG_GROUPS 
where  OWNER='INTERSPC' 
and TABLE_NAME in ('FRAME_TEXT', 'ITPRNOTE', 'REFERENCE_TEXT','SPECIFICATION_TEXT')
order by owner, table_name
;
 
 
--group-columns (worden niet aangemaakt als je ze niet opgeeft...)
--select * from ALL_LOG_GROUP_COLUMNS where  OWNER='INTERSPC' ;  
--and TABLE_NAME='HEADER' AND COLUMN_NAME='DESCRIPTION';
--no rows selected...
 


--
--HERSTELLEN / VERWIJDEREN VAN SUPPLEMENTAL-LOGGING
--OP GEHELE DATABASE: ALTER DATABASE DROP SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
--                    ALTER DATABASE DROP SUPPLEMENTAL LOG DATA;
--PER TABEL:   alter table [TABLE_NAME] drop supplemental log group [GROUP_NAME]
--OF:
/*
alter table FRAME_TEXT drop supplemental log data (all) columns;
alter table ITPRNOTE drop supplemental log data (all) columns;
alter table REFERENCE_TEXT drop supplemental log data (all) columns;
alter table SPECIFICATION_TEXT drop supplemental log data (all) columns;
--
alter system switch logfile; 
*/

 