PACKAGE BODY unapiralc AS






STPERROR      EXCEPTION;
L_RET_CODE    INTEGER;
L_SQLERRM     VARCHAR2(255);
L_SQL_STRING  VARCHAR2(2000);
L_DYN_CURSOR  INTEGER;
L_SEP         CHAR(1);

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
   RETURN (NULL);
END GETVERSION;




PROCEDURE LOGERROR
(A_API IN VARCHAR2, A_ERROR_MSG IN VARCHAR2)
IS
BEGIN
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
           A_API, A_ERROR_MSG);
END LOGERROR;




FUNCTION REMOVELCFROMARCHIVE
(A_LC IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   

   DELETE FROM UAUTLC
   WHERE LC = A_LC;

   DELETE FROM UAUTLCAF
   WHERE LC = A_LC;

   DELETE FROM UAUTLCAU
   WHERE LC = A_LC;

   DELETE FROM UAUTLCHS
   WHERE LC = A_LC;

   DELETE FROM UAUTLCTR
   WHERE LC = A_LC;

   DELETE FROM UAUTLCUS
   WHERE LC = A_LC;

   DELETE FROM UAUTLCHSDETAILS
   WHERE LC = A_LC;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
END REMOVELCFROMARCHIVE;




FUNCTION COPYLCTOARCHDB(A_LC IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN) RETURN NUMBER IS
BEGIN
   

   INSERT INTO UAUTLC
      (LC, VERSION, VERSION_IS_CURRENT, EFFECTIVE_FROM, EFFECTIVE_FROM_TZ,
      EFFECTIVE_TILL, EFFECTIVE_TILL_TZ, NAME, DESCRIPTION, INTENDED_USE,
      IS_TEMPLATE, INHERIT_AU, SS_AFTER_REANALYSIS, LAST_COMMENT, LC_CLASS, LOG_HS,
      LOG_HS_DETAILS, ALLOW_MODIFY, ACTIVE, LC_LC, LC_LC_VERSION, SS)
   SELECT  LC, VERSION, VERSION_IS_CURRENT, EFFECTIVE_FROM, EFFECTIVE_FROM_TZ,
      EFFECTIVE_TILL, EFFECTIVE_TILL_TZ, NAME, DESCRIPTION, INTENDED_USE,
      IS_TEMPLATE, INHERIT_AU, SS_AFTER_REANALYSIS, LAST_COMMENT, LC_CLASS, LOG_HS,
      LOG_HS_DETAILS, ALLOW_MODIFY, ACTIVE, LC_LC, LC_LC_VERSION, SS
   FROM UTLC
   WHERE LC = A_LC;

   INSERT INTO UAUTLCAF
      (LC, VERSION, SS_FROM, SS_TO, TR_NO, SEQ, AF)
   SELECT        LC, VERSION, SS_FROM, SS_TO, TR_NO, SEQ, AF
   FROM UTLCAF
   WHERE LC = A_LC;

   INSERT INTO UAUTLCAU
      (LC, VERSION, AU, AU_VERSION, AUSEQ, VALUE)
   SELECT        LC, VERSION, AU, AU_VERSION, AUSEQ, VALUE
   FROM UTLCAU
   WHERE LC = A_LC;

   INSERT INTO UAUTLCHS
      (LC, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
   SELECT  LC, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ
   FROM UTLCHS
   WHERE LC = A_LC;

   INSERT INTO UAUTLCTR
      (LC, VERSION, SS_FROM, SS_TO, TR_NO, CONDITION)
   SELECT        LC, VERSION, SS_FROM, SS_TO, TR_NO, CONDITION
   FROM UTLCTR
   WHERE LC = A_LC;

   INSERT INTO UAUTLCUS
      (LC, VERSION, SS_FROM, SS_TO, TR_NO, US)
   SELECT        LC, VERSION, SS_FROM, SS_TO, TR_NO, US
   FROM UTLCUS
   WHERE LC = A_LC;

   INSERT INTO UAUTLCHSDETAILS
      (LC, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS)
   SELECT        LC, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS
   FROM UTLCHSDETAILS
   WHERE LC = A_LC;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   IF A_IGNORE_DUP_VAL_ON_INDEX THEN
      L_RET_CODE := REMOVELCFROMARCHIVE(A_LC);
   END IF;
   RETURN(UNAPIGEN.DBERR_NORECORDS);
END COPYLCTOARCHDB;

FUNCTION ARCHIVELCTODB
(A_LC IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   L_RET_CODE := COPYLCTOARCHDB(A_LC, TRUE);
   IF L_RET_CODE = UNAPIGEN.DBERR_NORECORDS THEN
      L_RET_CODE := COPYLCTOARCHDB(A_LC, FALSE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CopyLcToArchDB#return='||TO_CHAR(L_RET_CODE)||' for lc='||A_LC;
         RAISE STPERROR;
      END IF;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,200);
   END IF;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'ArchiveLcToDB', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVELCTODB;

FUNCTION COPYLCFROMARCHDB(A_LC IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN) RETURN NUMBER IS
BEGIN
   

   INSERT INTO UTLC
      (LC, VERSION, VERSION_IS_CURRENT, EFFECTIVE_FROM, EFFECTIVE_FROM_TZ,
      EFFECTIVE_TILL, EFFECTIVE_TILL_TZ, NAME, DESCRIPTION, INTENDED_USE,
      IS_TEMPLATE, INHERIT_AU, SS_AFTER_REANALYSIS, LAST_COMMENT, LC_CLASS, LOG_HS,
      LOG_HS_DETAILS, ALLOW_MODIFY, ACTIVE, LC_LC, LC_LC_VERSION, SS)
   SELECT  LC, VERSION, VERSION_IS_CURRENT, EFFECTIVE_FROM, EFFECTIVE_FROM_TZ,
      EFFECTIVE_TILL, EFFECTIVE_TILL_TZ, NAME, DESCRIPTION, INTENDED_USE,
      IS_TEMPLATE, INHERIT_AU, SS_AFTER_REANALYSIS, LAST_COMMENT, LC_CLASS, LOG_HS,
      LOG_HS_DETAILS, ALLOW_MODIFY, ACTIVE, LC_LC, LC_LC_VERSION, SS
   FROM UAUTLC
   WHERE LC = A_LC;

   INSERT INTO UTLCAF
      (LC, VERSION, SS_FROM, SS_TO, TR_NO, SEQ, AF)
   SELECT        LC, VERSION, SS_FROM, SS_TO, TR_NO, SEQ, AF
   FROM UAUTLCAF
   WHERE LC = A_LC;

   INSERT INTO UTLCAU
      (LC, VERSION, AU, AU_VERSION, AUSEQ, VALUE)
   SELECT        LC, VERSION, AU, AU_VERSION, AUSEQ, VALUE
   FROM UAUTLCAU
   WHERE LC = A_LC;

   INSERT INTO UTLCHS
      (LC, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
   SELECT  LC, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ
   FROM UAUTLCHS
   WHERE LC = A_LC;

   INSERT INTO UTLCTR
      (LC, VERSION, SS_FROM, SS_TO, TR_NO, CONDITION)
   SELECT        LC, VERSION, SS_FROM, SS_TO, TR_NO, CONDITION
   FROM UAUTLCTR
   WHERE LC = A_LC;

   INSERT INTO UTLCUS
      (LC, VERSION, SS_FROM, SS_TO, TR_NO, US)
   SELECT        LC, VERSION, SS_FROM, SS_TO, TR_NO, US
   FROM UAUTLCUS
   WHERE LC = A_LC;

   INSERT INTO UTLCHSDETAILS
      (LC, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS)
   SELECT        LC, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS
   FROM UAUTLCHSDETAILS
   WHERE LC = A_LC;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   IF A_IGNORE_DUP_VAL_ON_INDEX THEN
      L_RET_CODE := REMOVELCFROMDB(A_LC);
   END IF;
   RETURN(UNAPIGEN.DBERR_NORECORDS);
END COPYLCFROMARCHDB;

FUNCTION RESTORELCFROMDB
(A_LC IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   L_RET_CODE := COPYLCFROMARCHDB(A_LC, TRUE);
   IF L_RET_CODE = UNAPIGEN.DBERR_NORECORDS THEN
      L_RET_CODE := COPYLCFROMARCHDB(A_LC, FALSE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CopyLcFromArchDB#return='||TO_CHAR(L_RET_CODE)||' for lc='||A_LC;
         RAISE STPERROR;
      END IF;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,200);
   END IF;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'RestoreLcFromDB', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END RESTORELCFROMDB;

FUNCTION REMOVELCFROMDB
(A_LC IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   

   DELETE FROM UTLC
   WHERE LC = A_LC;

   DELETE FROM UTLCAF
   WHERE LC = A_LC;

   DELETE FROM UTLCAU
   WHERE LC = A_LC;

   DELETE FROM UTLCHS
   WHERE LC = A_LC;

   DELETE FROM UTLCTR
   WHERE LC = A_LC;

   DELETE FROM UTLCUS
   WHERE LC = A_LC;

   DELETE FROM UTLCHSDETAILS
   WHERE LC = A_LC;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
END REMOVELCFROMDB;

FUNCTION ARCHIVELCTOFILE
(A_LC            IN VARCHAR2)
RETURN NUMBER IS

CURSOR L_UTLC_CURSOR (A_LC IN VARCHAR2) IS
   SELECT * FROM UTLC WHERE LC=A_LC;

CURSOR L_UTLCAF_CURSOR (A_LC IN VARCHAR2) IS
   SELECT * FROM UTLCAF WHERE LC=A_LC;

CURSOR L_UTLCAU_CURSOR (A_LC IN VARCHAR2) IS
   SELECT * FROM UTLCAU WHERE LC=A_LC;

CURSOR L_UTLCHS_CURSOR (A_LC IN VARCHAR2) IS
   SELECT * FROM UTLCHS WHERE LC=A_LC;

CURSOR L_UTLCTR_CURSOR (A_LC IN VARCHAR2) IS
   SELECT * FROM UTLCTR WHERE LC=A_LC;

CURSOR L_UTLCUS_CURSOR (A_LC IN VARCHAR2) IS
   SELECT * FROM UTLCUS WHERE LC=A_LC;

CURSOR L_UTLCHSDETAILS_CURSOR (A_LC IN VARCHAR2) IS
   SELECT * FROM UTLCHSDETAILS WHERE LC=A_LC;

BEGIN

   L_SQLERRM:=NULL;
   UNAPIRA.L_EXCEPTION_STEP :='utlc' ||'lc='||A_LC;
   FOR L_REC IN L_UTLC_CURSOR(A_LC) LOOP
      UNAPIRA3.L_PUTTEXT := 'utlc' || L_SEP ||
      L_REC.LC || L_SEP || L_REC.VERSION || L_SEP ||
      L_REC.VERSION_IS_CURRENT || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_FROM,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_FROM_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_TILL,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_TILL_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      L_REC.NAME || L_SEP || L_REC.DESCRIPTION || L_SEP ||
      L_REC.INTENDED_USE || L_SEP || L_REC.IS_TEMPLATE || L_SEP ||
      L_REC.INHERIT_AU || L_SEP || L_REC.SS_AFTER_REANALYSIS || L_SEP ||
      L_REC.LAST_COMMENT || L_SEP || L_REC.LC_CLASS || L_SEP ||
      L_REC.LOG_HS || L_SEP || L_REC.LOG_HS_DETAILS || L_SEP ||
      L_REC.ALLOW_MODIFY || L_SEP || L_REC.ACTIVE || L_SEP ||
      L_REC.LC_LC || L_SEP || L_REC.LC_LC_VERSION || L_SEP || L_REC.SS;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utlcaf' ||'lc='||A_LC;
   FOR L_REC IN L_UTLCAF_CURSOR(A_LC) LOOP
      UNAPIRA3.L_PUTTEXT := 'utlcaf' || L_SEP ||
      L_REC.LC || L_SEP || L_REC.VERSION || L_SEP || L_REC.SS_FROM || L_SEP ||
      L_REC.SS_TO || L_SEP || L_REC.TR_NO || L_SEP || L_REC.SEQ || L_SEP ||
      L_REC.AF;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utlcau' ||'lc='||A_LC;
   FOR L_REC IN L_UTLCAU_CURSOR(A_LC) LOOP
      UNAPIRA3.L_PUTTEXT := 'utlcau' || L_SEP ||
      L_REC.LC || L_SEP || L_REC.VERSION || L_SEP || L_REC.AU || L_SEP ||
      L_REC.AU_VERSION || L_SEP || L_REC.AUSEQ || L_SEP || L_REC.VALUE;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utlchs' ||'lc='||A_LC;
   FOR L_REC IN L_UTLCHS_CURSOR(A_LC) LOOP
      UNAPIRA3.L_PUTTEXT := 'utlchs' || L_SEP ||
      L_REC.LC || L_SEP || L_REC.VERSION || L_SEP || L_REC.WHO || L_SEP ||
      L_REC.WHO_DESCRIPTION || L_SEP || L_REC.WHAT || L_SEP ||
      L_REC.WHAT_DESCRIPTION || L_SEP ||
      TO_CHAR(L_REC.LOGDATE,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.LOGDATE_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      L_REC.WHY || L_SEP || L_REC.TR_SEQ || L_SEP || L_REC.EV_SEQ;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utlctr' ||'lc='||A_LC;
   FOR L_REC IN L_UTLCTR_CURSOR(A_LC) LOOP
      UNAPIRA3.L_PUTTEXT := 'utlctr' || L_SEP ||
      L_REC.LC || L_SEP || L_REC.VERSION || L_SEP || L_REC.SS_FROM || L_SEP ||
      L_REC.SS_TO || L_SEP || L_REC.TR_NO || L_SEP || L_REC.CONDITION;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utlcus' ||'lc='||A_LC;
   FOR L_REC IN L_UTLCUS_CURSOR(A_LC) LOOP
      UNAPIRA3.L_PUTTEXT := 'utlcus' || L_SEP ||
      L_REC.LC || L_SEP || L_REC.VERSION || L_SEP || L_REC.SS_FROM || L_SEP ||
      L_REC.SS_TO || L_SEP || L_REC.TR_NO || L_SEP || L_REC.US;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utlchsdetails' ||'lc='||A_LC;
   FOR L_REC IN L_UTLCHSDETAILS_CURSOR(A_LC) LOOP
      UNAPIRA3.L_PUTTEXT := 'utlchsdetails' || L_SEP ||
      L_REC.LC || L_SEP || L_REC.VERSION || L_SEP || L_REC.TR_SEQ || L_SEP ||
      L_REC.EV_SEQ || L_SEP || L_REC.SEQ || L_SEP || L_REC.DETAILS;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

UNAPIRA3.U4DATAPUTLINE( ' ');

RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN UTL_FILE.INVALID_PATH THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveLcToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_NOOBJECT);

WHEN UTL_FILE.INVALID_MODE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveLcToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.INVALID_FILEHANDLE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveLcToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.INVALID_OPERATION THEN
   
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveLcToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_NOOBJECT);

WHEN UTL_FILE.READ_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveLcToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.WRITE_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveLcToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.INTERNAL_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveLcToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SQLERRM;
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveLcToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveLcToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVELCTOFILE;

BEGIN
   L_SEP:=UNAPIRA.P_INTERNAL_SEP;
END UNAPIRALC;