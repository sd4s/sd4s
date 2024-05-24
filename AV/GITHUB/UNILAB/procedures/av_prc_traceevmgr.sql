--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure TRACEEVMGR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."TRACEEVMGR" (
    a_name    IN VARCHAR2,
    a_session IN NUMBER,
    a_enable  IN NUMBER
) AS
    l_name                  VARCHAR2(20);
    l_session               NUMBER;
    l_result                NUMBER;
    l_ev_seq_nr             NUMBER;
    l_up                    NUMBER(5);
    l_user_profile          VARCHAR2(40);
    l_language              VARCHAR2(20);
    l_tk                    VARCHAR2(20);
    l_numeric_characters    VARCHAR2(2);
    l_dateformat            VARCHAR2(255);
BEGIN
    l_dateformat := 'DDfx/fxMM/RR HH24fx:fxMI:SS';
    l_numeric_characters := 'DB';
    l_result := unapigen.SetConnection(
        'UNTRACE',
        'UNILAB',
        'UNILAB40',
        'UNTRACE',
        l_numeric_characters,
        l_dateformat,
        l_up,
        l_user_profile,
        l_language,
        l_tk
    );
    IF (l_result <> unapigen.DBERR_SUCCESS) THEN
        RETURN;
    END IF;
    
    /*
    l_result := unapigen.BeginTxn(UNAPIGEN.P_SINGLE_API_TXN);
    IF (l_result <> unapigen.DBERR_SUCCESS) THEN
        RETURN;
    END IF;
    */
    
    l_ev_seq_nr := -1;
    unapigen.P_TR_SEQ := -a_session;
    l_result := unapiev.InsertEvent(
        'UNTRACE',
        a_name,
        '',
        '',
        '',
        '',
        '',
        CASE WHEN a_enable = 0 THEN 'TraceOff' ELSE 'TraceOn'    END,
        CASE WHEN a_enable = 0 THEN ''         ELSE 'PIPE2TABLE' END,
        l_ev_seq_nr
    );
    IF (l_result <> unapigen.DBERR_SUCCESS) THEN
        RETURN;
    END IF;

    SELECT COUNT(*)
    INTO l_result
    FROM dba_scheduler_jobs
    WHERE job_class = 'UNI_JC_EVENTMGR_U611'
    AND job_action LIKE 'UNAPIEV.EVENTMANAGERJOB(''' || a_name || ''',%);';
    
    FOR l_index IN 1..l_result LOOP
        dbms_alert.signal(a_name, 1);
    END LOOP;
END;

/
