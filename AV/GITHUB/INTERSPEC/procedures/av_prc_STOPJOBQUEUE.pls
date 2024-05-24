create or replace PROCEDURE            "STOPJOBQUEUE" AS 
BEGIN
    dbms_alert.signal('JOBQUEUE', 'EXIT');
    COMMIT;
END STOPJOBQUEUE;