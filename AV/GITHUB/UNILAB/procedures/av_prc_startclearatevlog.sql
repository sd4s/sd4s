--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure STARTCLEARATEVLOG
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."STARTCLEARATEVLOG"     
AS
    lsJob VARCHAR2(30) := 'UNI_J_CLEANATEVLOG';
BEGIN
    dbms_scheduler.create_job(
        job_name   => lsJob,
        job_class  => 'UNI_JC_OTHER_JOBS',
        job_type   => 'PLSQL_BLOCK',
        job_action => 'BEGIN CLEARATEVLOG; END;',
        start_date => TRUNC(SYSDATE, 'DD') + 1,
        repeat_interval => unapiev.SqlTranslatedJobInterval(1, 'days'),
        enabled    => TRUE
    );
    dbms_scheduler.set_attribute(
        name      => lsJob,
        attribute => 'restartable',
        value     => TRUE
    );
END STARTCLEARATEVLOG;
 

/
