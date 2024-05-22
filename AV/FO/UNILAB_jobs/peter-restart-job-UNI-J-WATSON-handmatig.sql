SET SERVEROUTPUT ON
--
DECLARE
l_job          VARCHAR2(30);
l_action       VARCHAR2(4000);
l_sqlerrm      VARCHAR2 (255);
--uren, bijv. 13:00 uur:
--l_start_tijd   NUMBER :=  13 ;        --DEFAULT = 21 = 21:00 UUR !!! , 
--uren/minuten, bijv. 13:45 uur:
l_start_tijd   NUMBER :=  (13*60 + 45)/60  ; --DEFAULT = 21:00 = 21:00 UUR !!! , 
--
CURSOR l_addon_job_cursor
IS
SELECT job_name, job_action
FROM dba_scheduler_jobs
WHERE UPPER(JOB_NAME) LIKE 'UNI_J_WATSON'
;
--WHERE UPPER (job_action) NOT LIKE '%EVENTMANAGERJOB%'
--AND UPPER (job_action) NOT LIKE '%TIMEDEVENTMGR%'
--AND UPPER (job_action) NOT LIKE '%EQUIPMENTMANAGERJOB%'
--AND UPPER (job_action) NOT LIKE '%UNILINK%'
--AND UPPER (job_name) LIKE 'UNI_J%';
BEGIN
  BEGIN
    OPEN l_addon_job_cursor;
    LOOP
      FETCH l_addon_job_cursor INTO l_job, l_action ;
      EXIT WHEN l_addon_job_cursor%NOTFOUND;
	  --
      DBMS_SCHEDULER.DROP_JOB(l_job);
	  --
      DBMS_OUTPUT.put_line ( 'Stop <' || l_job || '> successful');
    END LOOP;
    CLOSE l_addon_job_cursor;
	COMMIT;
    EXCEPTION
      WHEN OTHERS
      THEN l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
            DBMS_OUTPUT.put_line ('Unscheduling ADDONJOB '||L_JOB||' failed:');
            DBMS_OUTPUT.put_line (l_sqlerrm);
  END;
  --
  --HERSTART UNI-J-WATSON
  -- uren:     x / 24
  -- minuten:  ((13*60 + 45) / (24*60))
  l_job := 'UNI_J_WATSON';
  --
  dbms_scheduler.create_job
    (job_name        => l_job
    ,job_class       => 'UNI_JC_OTHER_JOBS'
    ,job_type        => 'PLSQL_BLOCK'
    ,job_action      => 'begin apao_watson.import_files(p_test => false); end;'
    ,start_date      =>  trunc(sysdate) + l_start_tijd / 24 
    ,repeat_interval => unapiev.sqltranslatedjobinterval(1, 'days')
    ,enabled         => true);
    --
  dbms_scheduler.set_attribute 
    (name            => l_job
    ,attribute       => 'restartable'
    ,value           => true);
end;
/
	