BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'UNILAB.UNI_J_REGULARRELEASE');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'UNILAB.UNI_J_REGULARRELEASE'
      ,start_date      => TO_TIMESTAMP_TZ('2023/11/13 19:52:51.000000 +01:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm')
      ,repeat_interval => 'FREQ = MINUTELY; INTERVAL = 1'
      ,end_date        => NULL
      ,job_class       => 'UNI_JC_OTHER_JOBS'
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'DECLARE r NUMBER; BEGIN r:= APAOREGULARRELEASE.EvaluateTimeCountBased; END;'
      ,comments        => NULL
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'UNILAB.UNI_J_REGULARRELEASE'
     ,attribute => 'RESTARTABLE'
     ,value     => TRUE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'UNILAB.UNI_J_REGULARRELEASE'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'UNILAB.UNI_J_REGULARRELEASE'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'UNILAB.UNI_J_REGULARRELEASE'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'UNILAB.UNI_J_REGULARRELEASE'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'UNILAB.UNI_J_REGULARRELEASE'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'UNILAB.UNI_J_REGULARRELEASE'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'UNILAB.UNI_J_REGULARRELEASE'
     ,attribute => 'AUTO_DROP'
     ,value     => TRUE);
END;
/


--Handmatig de logging aanzetten:
begin
SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'UNILAB.UNI_J_REGULARRELEASE'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_FULL);
end;
/

--Handmatig de logging aanzetten:
begin
SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'UNILAB.UNI_J_REGULARRELEASE'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
end;
/

