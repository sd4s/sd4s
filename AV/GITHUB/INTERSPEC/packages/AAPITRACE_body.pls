create or replace PACKAGE BODY aapiTrace AS

  PROCEDURE CleanTrace
  AS
  BEGIN
    DELETE FROM atStackTrace
    WHERE logdate < SYSDATE - (5 - depth);
  END;

  PROCEDURE StartJob
  AS
      lsCommand VARCHAR2(256 CHAR) := 'aapiTrace.CleanTrace;';
      lnCount   NUMBER;
      lnJob     BINARY_INTEGER;
      PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
      SELECT COUNT(*)
      INTO lnCount
      FROM dba_jobs
      WHERE what = lsCommand;
  
      IF lnCount = 0 THEN
          dbms_job.submit(
              job       => lnJob,
              what      => lsCommand,
              next_date => TRUNC(SYSDATE) + 21 / 24,
              interval  => 'SYSDATE + 1'
          );
          COMMIT;
      END IF;
  END;

  PROCEDURE Log(
    asAction IN iapiType.Description_Type DEFAULT NULL,
    asParam  IN iapiType.Description_Type DEFAULT NULL,
    asValue  IN iapiType.Info_Type DEFAULT NULL
  ) AS
    PRAGMA AUTONOMOUS_TRANSACTION;

    lsCall    iapiType.Info_Type;
    lsHandle  iapiType.Description_Type;
    lnAudID  iapiType.NumVal_Type;
    lsUserID  iapiType.UserId_Type;
    lsMachine iapiType.LongDescription_Type;
    lsOSUser  iapiType.LongDescription_Type;

    lsModule  iapiType.Description_Type;
    lsObject  iapiType.LongDescription_Type;
    lnLine    iapiType.NumVal_Type;
    lnDepth   iapiType.NumVal_Type;
  BEGIN
    lsUserID := NVL(iapiGeneral.Session.ApplicationUser.UserID, USER);
    IF lsUserID NOT LIKE 'MVL%' THEN
      RETURN; --Disable logging for regular users for now.
    END IF;

    lnAudID := SYS_CONTEXT('USERENV', 'SESSIONID');
    lsMachine := SYS_CONTEXT('USERENV', 'HOST');
    lsOSUser := SYS_CONTEXT('USERENV', 'OS_USER');
    lsModule := SYS_CONTEXT('USERENV', 'MODULE');

    lsCall := dbms_utility.format_call_stack();
    lsCall := SUBSTR(lsCall, INSTR(UPPER(lsCall), UPPER(gsSource), -1) + LENGTH(gsSource) + 1);

    lnDepth := REGEXP_COUNT(lsCall, CHR(10)) - 1;
    
    lsCall := SUBSTR(lsCall, 1, INSTR(lsCall, CHR(10)) - 1);
    lsHandle := SUBSTR(lsCall, 1, 16);
    lnLine := TO_NUMBER(SUBSTR(lsCall, 19, 8));
    lsObject := SUBSTR(lsCall, 29);
  
    INSERT INTO atStackTrace(
      seq_no, logdate, handle,
      audsid, user_id, machine, os_user,
      module, object, line, depth,
      action, param, value
    ) VALUES (
      StackTraceSeqNo_Seq.NEXTVAL, SYSTIMESTAMP, lsHandle,
      lnAudID, lsUserID, lsMachine, lsOSUser,
      lsModule, lsObject, lnLine, lnDepth,
      asAction, asParam, asValue
    );

    COMMIT;
  END;

  PROCEDURE Enter
  AS
  BEGIN
    Log(asAction => 'ENTER');
  END;

  PROCEDURE Param(
    asParam IN iapiType.Description_Type,
    asValue IN iapiType.Info_Type
  ) AS
  BEGIN
    Log(asAction => 'PARAM', asParam => asParam, asValue => asValue);
  END;

  PROCEDURE Var(
    asVar   IN iapiType.Description_Type,
    asValue IN iapiType.Info_Type
  ) AS
  BEGIN
    Log(asAction => 'VAR', asParam => asVar, asValue => asValue);
  END;

  PROCEDURE Trace(
    asVar   IN iapiType.Description_Type,
    asValue IN iapiType.Info_Type
  ) AS
  BEGIN
    Log(asAction => 'TRACE', asParam => asVar, asValue => asValue);
  END;

  PROCEDURE Error(
    asValue IN iapiType.Info_Type
  ) AS
  BEGIN
    Log(asAction => 'ERROR', asValue => asValue);
  END;

  PROCEDURE Exit(
    asValue IN iapiType.Info_Type DEFAULT NULL
  ) AS
  BEGIN
    Log(asAction => 'EXIT', asParam => CASE WHEN asValue IS NOT NULL THEN '<RETURN>' END, asValue => asValue);
  END;

END;