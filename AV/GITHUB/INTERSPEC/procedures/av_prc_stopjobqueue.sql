--------------------------------------------------------
--  File created - Monday-October-26-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure STOPJOBQUEUE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "INTERSPC"."STOPJOBQUEUE" AS 
BEGIN
    dbms_alert.signal('JOBQUEUE', 'EXIT');
    COMMIT;
END STOPJOBQUEUE;

/
