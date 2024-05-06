--*****************************************************************************************************
--*****************************************************************************************************
--*****************************************************************************************************
-- let op: ONDERSTAANDE ZAKEN ALLEEN UITVOEREN INDIEN DE CONFIG-TABEL OOK DAADWERKELIJK GEVULD IS ....
--*****************************************************************************************************
--*****************************************************************************************************
--*****************************************************************************************************
--*****************************************************************************************************

--
-- UPDATE-PK-EXISTS
--UNILAB:
-- PK=J
UPDATE DBA_AWS_SUPPLEMENTAL_LOG SET ASL_PK_EXISTS_JN = 'J' WHERE ASL_TABLE_NAME in (SELECT con.TABLE_NAME FROM ALL_CONSTRAINTS con WHERE OWNER='UNILAB' AND  CONSTRAINT_TYPE='P') AND ASL_PK_EXISTS_JN IS NULL;
-- PK=N
UPDATE DBA_AWS_SUPPLEMENTAL_LOG SET ASL_PK_EXISTS_JN = 'N' WHERE ASL_TABLE_NAME NOT in (SELECT con.TABLE_NAME FROM ALL_CONSTRAINTS con WHERE OWNER='UNILAB' AND  CONSTRAINT_TYPE='P') AND ASL_PK_EXISTS_JN IS NULL;

--INTERSPEC
-- PK=J
UPDATE DBA_AWS_SUPPLEMENTAL_LOG SET ASL_PK_EXISTS_JN = 'J' WHERE ASL_TABLE_NAME in (SELECT con.TABLE_NAME FROM ALL_CONSTRAINTS con WHERE OWNER='INTERSPC' AND  CONSTRAINT_TYPE='P') AND ASL_PK_EXISTS_JN IS NULL;
-- PK=N
UPDATE DBA_AWS_SUPPLEMENTAL_LOG SET ASL_PK_EXISTS_JN = 'N' WHERE ASL_TABLE_NAME NOT in (SELECT con.TABLE_NAME FROM ALL_CONSTRAINTS con WHERE OWNER='INTERSPC' AND  CONSTRAINT_TYPE='P') AND ASL_PK_EXISTS_JN IS NULL;

--CONTROLE ACHTERAF
select count(*), asl_pk_exists_jn
from dba_aws_supplemental_log
group by asl_pk_exists_jn
order by asl_pk_exists_jn
;
/*
unilab:
157	J
24	N
--
interspec:
82	J
6	N
*/
--
COMMIT;

--
-- UPDATE ALS_SUPPL_LOG_TYPE
-- DEFAULT LOG-TYPE=ALL
update dba_aws_supplemental_log set ASL_SUPPL_LOG_TYPE = 'ALL' WHERE ASL_SUPPL_LOG_TYPE IS NULL;
update dba_aws_supplemental_log set ASL_SUPPL_LOG_TYPE = 'ALL' ;
/*
-- EVT. SPECIFIEK MAKEN PER EXISTING-PK. DOEN WIJ NU ECHTER NIET. WE LATEN ALLE TABELLEN OP "ALL" STAAN...
update dba_aws_supplemental_log set ASL_SUPPL_LOG_TYPE = CASE WHEN ASL_PK_EXISTS_JN = 'J' THEN 'PK' 
                                                              WHEN ASL_PK_EXISTS_JN = 'N' THEN 'ALL' 
															  ELSE '' END;
*/
--
select count(*), ASL_SUPPL_LOG_TYPE
from dba_aws_supplemental_log
group by ASL_SUPPL_LOG_TYPE
order by ASL_SUPPL_LOG_TYPE
;
/*
20	ALL
158	PK
*/
commit;


--
-- ZET ALLE TABELLEN OP ACTIVE !
--
update dba_aws_supplemental_log set ASL_IND_ACTIVE_JN = 'J' WHERE ASL_IND_ACTIVE_JN IS NULL;
--
select count(*), asl_ind_active_jn
from dba_aws_supplemental_log
group by asl_ind_active_jn
order by asl_ind_active_jn
;
COMMIT;

--**************************************************************************************************
--ALLE TABELLEN MET EEN BLOB-COLUMN zetten we vooralsnog op INACTIVE. REPLICEREN GAAT NOG NIET GOED.
--**************************************************************************************************
SELECT COUNT(*), ASL_IND_ACTIVE_JN FROM DBA_AWS_SUPPLEMENTAL_LOG GROUP BY ASL_IND_ACTIVE_JN;
UPDATE DBA_AWS_SUPPLEMENTAL_LOG SET ASL_IND_ACTIVE_JN = 'N', ASL_OPMERKING=ASL_OPMERKING||' COLUMN=DATA=BLOB' WHERE ASL_SCHEMA_OWNER = 'UNILAB' AND  ASL_TABLE_NAME = 'UTBLOB';
--
COMMIT;




-- *************************************************************************************
-- *************************************************************************************
-- LET OP:   ADD-SUPPLEMENTAL-LOGGING PROCEDURE MOET REEDS ZIJN AANGEMAAKT.......
-- *************************************************************************************
-- *************************************************************************************
--
--drop procedure dba_aws_add_supplemental_log;
--create or replace procedure dba_aws_add_supplemental_log (p_table_name varchar2 default null, p_debug varchar2 default 'J')
/*
alter table ATTACHED_SPECIFICATION add supplemental log data (all) columns;
*/

SET SERVEROUTPUT ON
--INCL DEBUG, GEEN COMMIT...
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'UTEQ', p_debug=>'J'); END;
/*
serveroutput:
ALTER TABLE UTEQ ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS
*/
--DAADWERKELIJK AANZETTEN...
--BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'UTRQGKRQDAY', p_debug=>'N'); END;

--debug alle tabellen in schema...
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'', p_debug=>'J'); END;
--************************************************************************************************************
--************************************************************************************************************
--en nu HELE SCHEMA voor het ECHIE...!!!!!!!!!!!!!!!!!!!! (DEBUG=N)
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'', p_debug=>'N'); END;
--of specifieke tabel:
--BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'UTRQAU', p_debug=>'N'); END;
--BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'AVSPECIFICATION_WEIGHT', p_debug=>'N'); END;
--
alter system switch logfile; 
--************************************************************************************************************
--************************************************************************************************************
--LET OP: DE ACTIVATION-DATE WORDT AUTOMATISCH GEVULD VANUIT PROCEDURE = DBA_AWS_ADD_SUPPLEMENTAL_LOG !!!!!!!!!!
--indien nodig dan handmatig met onderstaand statement:
--update dba_aws_supplemental_log set asl_activation_date = sysdate where ASL_IND_ACTIVE_JN = 'J' and asl_activation_date is null;




--evt. herstellen van activation-date:
select table_name from dba_aws_supplemental_log where asl_activation_date is null;
--
update dba_aws_supplemental_log set asl_activation_date = null where asl_activation_date > trunc(sysdate);
commit;



--CONTROLE TABELLEN MET SUPPLEMENTAL-LOGGING...
--Alles is gebaseerd op de LOG-GROUP. Geef je deze niet expliciet op, dan genereert oracle deze (SYS_%).
--WHERE LOG_GROUP_TYPE='ALL COLUMN LOGGING'
select * from ALL_LOG_GROUPS where  OWNER='UNILAB' ;  --and TABLE_NAME='UTEQ';
/*
UNILAB	SYS_C0078142	UTEQ	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078143	UTRQ	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078144	UTRQAU	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078145	UTRQGK	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078146	UTRQGKISTEST	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078147	UTRQII	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078148	UTSC	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078149	UTSCAU	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078150	UTSCGK	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078151	UTSCGKISTEST	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078152	UTSCII	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078153	UTSCME	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078154	UTSCMECELL	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078155	UTSCMEGK	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078156	UTSCMEGKME_IS_RELEVANT	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078157	UTSCPA	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078158	UTSCPAAU	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
UNILAB	SYS_C0078159	UTSS	ALL COLUMN LOGGING	ALWAYS	GENERATED NAME
*/
select * from ALL_LOG_GROUPS where  OWNER='INTERSPC' ;  --and TABLE_NAME='ITUP';

--group-columns (worden niet aangemaakt als je ze niet opgeeft...)
select * from ALL_LOG_GROUP_COLUMNS where  OWNER='UNILAB' ;  --and TABLE_NAME='UTEQ' AND COLUMN_NAME='SC';
--no rows selected...

--
--CONTROLE WELKE TABELLEN NIET VAN SUPPLEMENTAL-LOGGING ZIJN VOORZIEN:
--
select asl_table_name from dba_aws_supplemental_log where asl_table_name not in (select log.table_name from dba_log_groups LOG where LOG.owner='UNILAB' );
/*
UNILAB:
UNILAB                --delete from dba_aws_supplemental_log where asl_table_name='UNILAB' ;
AVAO_SPECIFICATION    --delete from dba_aws_supplemental_log where asl_table_name='AVAO_SPECIFICATION' ;
AVAO_SPEC_DESC        --delete from dba_aws_supplemental_log where asl_table_name='AVAO_SPEC_DESC' ;
UTVRQGKRQDAY          --update  dba_aws_supplemental_log  set asl_table_name ='UTRQGKRQDAY'  where asl_table_name='UTVRQGKRQDAY' 
*/
select asl_table_name from dba_aws_supplemental_log where asl_table_name not in (select log.table_name from dba_log_groups LOG where LOG.owner='INTERSPC' );
/*
SPECIFICAITON_KW         --update dba_aws_supplemental_log  set asl_table_name ='SPECIFICATION_KW'  where asl_table_name='SPECIFICAITON_KW' 
                          --delete from dba_aws_supplemental_log where asl_table_name like 'SPECIFICAITON_KW' 
AVSEPCIFICATION_WEIGHT   --update dba_aws_supplemental_log  set asl_table_name ='AVSPECIFICATION_WEIGHT'  where asl_table_name='AVSEPCIFICATION_WEIGHT' 
                         
RVPART_PLANT             --DELETE FROM  dba_aws_supplemental_log where asl_table_name like 'RVPART_PLANT' 
*/



--**********************************************************************************************
--**********************************************************************************************
--**********************************************************************************************
--
--HERSTELLEN / VERWIJDEREN VAN SUPPLEMENTAL-LOGGING
--OP GEHELE DATABASE: ALTER DATABASE DROP SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
--                    ALTER DATABASE DROP SUPPLEMENTAL LOG DATA;
--PER TABEL:   alter table [TABLE_NAME] drop supplemental log group [GROUP_NAME]

--OF:
--alter table UTEQ drop supplemental log data (all) columns;
--
--alter system switch logfile; 

conn interspec/moonflower@U611

SET SERVEROUTPUT ON
alter table AVSPECIFICATION_WEIGHT drop supplemental log data (all) columns;
alter system switch logfile; 
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'AVSPECIFICATION_WEIGHT', p_debug=>'J'); END;
alter system switch logfile; 


ERROR: http-error on sc_interspec_en (MISSING S)
ERROR: aws_sdk_cpp
--db-connectie: SELECT current_scn FROM v$database




prompt
prompt einde script
prompt

