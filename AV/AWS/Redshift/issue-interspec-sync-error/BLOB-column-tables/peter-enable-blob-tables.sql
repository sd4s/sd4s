--BLOB-TABELLEN:
--INTERSPEC
--51	INTERSPC	ITOIRAW	J	ALL	N		 COLUMN=DESKTOP_OBJECT=BLOB
select * from DBA_AWS_SUPPLEMENTAL_LOG where asl_table_name in ('ITOIRAW');

select ASL_id, ASL_schema_owner, ASL_table_name, ASL_pk_exists_jn, ASL_suppl_log_type, ASL_ind_active_jn, ASL_activation_date 
from dba_aws_supplemental_log 
where ASL_ind_active_jn='J' and ASL_table_name='ITOIRAW'
;
UPDATE dba_aws_supplemental_log set ASL_IND_ACTIVE_JN='J' , ASL_activation_date=null where asl_table_name in ('ITOIRAW');
commit;



alter system switch logfile; 


--
--Create ADD-SUPPLEMENTAL-LOGGING PROCEDURE
--BETER MET PROCEDURE:

SET SERVEROUTPUT ON
--INCL DEBUG, GEEN COMMIT...
--interspec:
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'ITOIRAW', p_debug=>'J'); END;
/
--DAADWERKELIJK AANZETTEN...
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'ITOIRAW', p_debug=>'N'); END;
/
commit;

alter system switch logfile; 

--*****************************
--controle achteraf:
SET LINESIZE 300
select owner, table_name
from ALL_LOG_GROUPS 
where  OWNER='INTERSPC' 
and TABLE_NAME in ('ITOIRAW')
order by owner, table_name
;







--*******************************************************************
--*******************************************************************
--*******************************************************************
--UNILAB:
--35	UNILAB	UTBLOB	J	ALL	N		 COLUMN=DATA=BLOB
set linesize 300
select * from DBA_AWS_SUPPLEMENTAL_LOG where asl_table_name in ('UTBLOB');

set linesize 300
select ASL_id, ASL_schema_owner, ASL_table_name, ASL_pk_exists_jn, ASL_suppl_log_type, ASL_ind_active_jn, ASL_activation_date 
from dba_aws_supplemental_log 
where ASL_ind_active_jn='J' and ASL_table_name='UTBLOB'
;
UPDATE dba_aws_supplemental_log set ASL_IND_ACTIVE_JN='J' , ASL_activation_date=null  where asl_table_name in ('UTBLOB');
commit;

alter system switch logfile; 

--
--Create ADD-SUPPLEMENTAL-LOGGING PROCEDURE
--BETER MET PROCEDURE:

SET SERVEROUTPUT ON
--INCL DEBUG, GEEN COMMIT...
--unilab:
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'UTBLOB', p_debug=>'J'); END;
/
--DAADWERKELIJK AANZETTEN...
--unilab:
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'UTBLOB', p_debug=>'N'); END;
/
COMMIT;

alter system switch logfile; 


--*****************************
--controle achteraf:
SET LINESIZE 300
select owner, table_name
from ALL_LOG_GROUPS 
where  OWNER='UNILAB' 
and TABLE_NAME in ('UTBLOB')
order by owner, table_name
;


--
--HERSTELLEN / VERWIJDEREN VAN SUPPLEMENTAL-LOGGING
--OP GEHELE DATABASE: ALTER DATABASE DROP SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
--                    ALTER DATABASE DROP SUPPLEMENTAL LOG DATA;
--PER TABEL:   alter table [TABLE_NAME] drop supplemental log group [GROUP_NAME]
--OF:
/*
UPDATE dba_aws_supplemental_log set ASL_IND_ACTIVE_JN='J' , ASL_activation_date=null  where asl_table_name in ('UTBLOB');
commit;

set serveroutput on
alter table UTBLOB drop supplemental log data (all) columns;
--
alter system switch logfile; 
*/

