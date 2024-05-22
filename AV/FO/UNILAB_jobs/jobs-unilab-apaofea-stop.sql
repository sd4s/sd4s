--CXAPP.stopalldbjobs :
--
/*
SET PAGES 999
SET LINESIZE 300
COLUMN JOB_ACTION FORMAT A200
--
SELECT job_name, job_action
FROM dba_scheduler_jobs
WHERE (    UPPER (job_action) NOT LIKE '%EVENTMANAGERJOB%'
      AND UPPER (job_action) NOT LIKE '%TIMEDEVENTMGR%'
      AND UPPER (job_action) NOT LIKE '%EQUIPMENTMANAGERJOB%'
      AND UPPER (job_action) NOT LIKE '%UNILINK%'
	  )
AND UPPER (job_name) LIKE 'UNI_J%';
AND UPPER (job_name) LIKE 'UNI_J_FEA'
;

JOB_NAME                       JOB_ACTION
------------------------------ --------------------------------------------------------------------------------------------------------
UNI_J_OUTDOOREVENTMGR          APAO_OUTDOOR.OUTDOOREVENTMGR;
UNI_J_CLEANUPTABLEUTERROR      BEGIN CLEARUTERROR; END;
UNI_J_CLEANATEVLOG             BEGIN CLEARATEVLOG; END;
UNI_J_STCHANGESSTOAPPROVED     DECLARE r NUMBER; BEGIN r:= APAOACTION.STCHANGESSTOAPPROVED; END;
UNI_J_REMOVEMEGKME_IS_RELEVANT DECLARE r NUMBER; BEGIN r:= APAOACTION.MeRemoveGk('ME_IS_RELEVANT'); END;
UNI_J_REGULARRELEASE           DECLARE r NUMBER; BEGIN r:= APAOREGULARRELEASE.EvaluateTimeCountBased; END;
UNI_J_FEA                      DECLARE r NUMBER; BEGIN r:= APAOFEA.ExecuteMeshing(); END;
UNI_J_WATSON                   begin apao_watson.import_files(p_test => false); end;
UNI_J_NEWVERMGR31438           UNAPIGEN.NewVersionMgr;
UNI_J_SAMPLEPLANNER            UNAPIPLAN.SamplePlanner(TRUNC(CURRENT_TIMESTAMP, 'DD'),TRUNC(CURRENT_TIMESTAMP, 'DD') + 7 - 1/86400,24);
UNI_J_ISULIF_31441             pa_specxinterface.p_create_gk_table;

11 rows selected.
*/
--
--roept aan:
--   DBMS_SCHEDULER.DROP_JOB(l_job);
--   DBMS_OUTPUT.put_line ( 'Stop <' || l_action || '> successful');

--aanzetten weer via: pa_LimsInterface.f_StartInterface()

--conn interspc/moonflower@is61
PROMPT SCRIPT JOBS-unilab-apaofea-STOP UITVOEREN ALS USER UNILAB !!!!

spool E:\DBA\jobs\log_jobs_unilab_apaofea_stop.log
alter session set nls_date_format="dd-mm-yyyy hh24:mi:ss";
select user, sysdate from dual;

set serveroutput on
--
declare
CURSOR l_addon_job_cursor
IS
SELECT job_name, job_action
FROM dba_scheduler_jobs
WHERE (    UPPER (job_action) NOT LIKE '%EVENTMANAGERJOB%'
      AND  UPPER (job_action) NOT LIKE '%TIMEDEVENTMGR%'
      AND  UPPER (job_action) NOT LIKE '%EQUIPMENTMANAGERJOB%'
      AND  UPPER (job_action) NOT LIKE '%UNILINK%'
	  )
--AND UPPER (job_name) LIKE 'UNI_J%';
AND UPPER (job_name) LIKE 'UNI_J_FEA'
;
l_result        number;
l_sqlerrm       VARCHAR2 (255);
l_job           VARCHAR2(30);
l_action        VARCHAR2(4000);
begin
  OPEN l_addon_job_cursor;
  LOOP
    FETCH l_addon_job_cursor INTO l_job, l_action ;
    EXIT WHEN l_addon_job_cursor%NOTFOUND;
    DBMS_SCHEDULER.DROP_JOB(l_job);
    DBMS_OUTPUT.put_line ( 'Stop <' || l_action || '> successful');
  END LOOP;
  CLOSE l_addon_job_cursor;
  UNAPIGEN.U4COMMIT;
  DBMS_OUTPUT.put_line ('Unscheduling ADDONJOBs successful');
EXCEPTION
  WHEN OTHERS
  THEN
    l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
    DBMS_OUTPUT.put_line ('Unscheduling ADDONJOBs failed:');
    DBMS_OUTPUT.put_line (l_sqlerrm);
END;
/

--controle jobs na STOPPEN van UNILAB-jobs:
--let op: DE INTERSPEC-jobs zijn (in tegenstelling tot UNILAB-jobs) GEEN scheduled-jobs, maar zijn DBMS_JOBS !!
set pages 999
set linesize 300
column what format a50
column log_user format a10
column priv_user format a10
column schema_user format a10
column last_date format a20
column next_date format a20
--select job, what, log_user, priv_user, schema_user, to_char(last_date,'dd-mm-yyyy hh24:mi:ss') , to_char(next_date,'dd-mm-yyyy hh24:mi:ss'), broken, failures, nls_env, instance

prompt
prompt overzicht AANWEZIGE-JOBS na STOPPEN van 2x PA-LIMSinterface-JOBS:
prompt
SELECT JOB_NAME, STATE, ENABLED, NEXT_RUN_DATE 
FROM USER_SCHEDULER_JOBS 
;



prompt einde script


spool off;

--exit;





