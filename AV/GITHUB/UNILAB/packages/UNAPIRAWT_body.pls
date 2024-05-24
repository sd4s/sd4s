PACKAGE BODY unapirawt AS






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




FUNCTION REMOVEWTFROMARCHIVE
(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   
   DELETE FROM UAUTWT
    WHERE WT = A_WT
      AND VERSION = A_VERSION;
   DELETE FROM UAUTWTAU
    WHERE WT = A_WT
      AND VERSION = A_VERSION;
   DELETE FROM UAUTWTHS
    WHERE WT = A_WT
      AND VERSION = A_VERSION;
   DELETE FROM UAUTWTHSDETAILS
    WHERE WT = A_WT
      AND VERSION = A_VERSION;
   DELETE FROM UAUTWTROWS
    WHERE WT = A_WT
      AND VERSION = A_VERSION;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
END REMOVEWTFROMARCHIVE;




FUNCTION COPYWTTOARCHDB(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN) RETURN NUMBER IS
BEGIN
   
   EXECUTE IMMEDIATE
   'INSERT INTO uautwt'||
   UNAPIRA.LISTALLCOLUMNS('utwt', 'BRACKETS', '1') ||
   ' SELECT '||   UNAPIRA.LISTALLCOLUMNS('utwt', 'NO_BRACKETS', '1') ||
   ' FROM utwt'||
   ' WHERE wt = '''||A_WT||''''||
   ' AND version = '''||A_VERSION||'''';
   INSERT INTO UAUTWTAU
      (WT, VERSION, AU, AU_VERSION, AUSEQ, VALUE)
   SELECT        WT, VERSION, AU, AU_VERSION, AUSEQ, VALUE
   FROM UTWTAU
   WHERE WT = A_WT
   AND VERSION = A_VERSION;
   INSERT INTO UAUTWTHS
      (WT, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
   SELECT  WT, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ
   FROM UTWTHS
   WHERE WT = A_WT
   AND VERSION = A_VERSION;
   INSERT INTO UAUTWTHSDETAILS
      (WT, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS)
   SELECT        WT, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS
   FROM UTWTHSDETAILS
   WHERE WT = A_WT
   AND VERSION = A_VERSION;
   INSERT INTO UAUTWTROWS
      (WT, VERSION, ROWNR, ST, ST_VERSION, SC, SC_CREATE)
   SELECT        WT, VERSION, ROWNR, ST, ST_VERSION, SC, SC_CREATE
   FROM UTWTROWS
   WHERE WT = A_WT
   AND VERSION = A_VERSION;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   IF A_IGNORE_DUP_VAL_ON_INDEX THEN
      L_RET_CODE := REMOVEWTFROMARCHIVE(A_WT, A_VERSION);
   END IF;
   RETURN(UNAPIGEN.DBERR_NORECORDS);
END COPYWTTOARCHDB;

FUNCTION ARCHIVEWTTODB
(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   L_RET_CODE := COPYWTTOARCHDB(A_WT, A_VERSION, TRUE);
   IF L_RET_CODE = UNAPIGEN.DBERR_NORECORDS THEN
      L_RET_CODE := COPYWTTOARCHDB(A_WT, A_VERSION, FALSE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CopyWtToArchDB#return='||TO_CHAR(L_RET_CODE)||' for wt='||A_WT||'#version='||A_VERSION;
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
          'ArchiveWtToDB', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVEWTTODB;

FUNCTION COPYWTFROMARCHDB(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN) RETURN NUMBER IS
BEGIN
   
   EXECUTE IMMEDIATE
   'INSERT INTO utwt'||
   UNAPIRA.LISTALLCOLUMNS('utwt', 'BRACKETS', '1') ||
   ' SELECT '||   UNAPIRA.LISTALLCOLUMNS('utwt', 'NO_BRACKETS', '1') ||
   ' FROM uautwt'||
   ' WHERE wt = '''||A_WT||'''' ||
   ' AND version = '''||A_VERSION||'''';
   INSERT INTO UTWTAU
      (WT, VERSION, AU, AU_VERSION, AUSEQ, VALUE)
   SELECT        WT, VERSION, AU, AU_VERSION, AUSEQ, VALUE
   FROM UAUTWTAU
   WHERE WT = A_WT
   AND VERSION = A_VERSION;
   INSERT INTO UTWTHS
      (WT, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
   SELECT  WT, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ
   FROM UAUTWTHS
   WHERE WT = A_WT
   AND VERSION = A_VERSION;
   INSERT INTO UTWTHSDETAILS
      (WT, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS)
   SELECT        WT, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS
   FROM UAUTWTHSDETAILS
   WHERE WT = A_WT
   AND VERSION = A_VERSION;
   INSERT INTO UTWTROWS
      (WT, VERSION, ROWNR, ST, ST_VERSION, SC, SC_CREATE)
   SELECT        WT, VERSION, ROWNR, ST, ST_VERSION, SC, SC_CREATE
   FROM UAUTWTROWS
   WHERE WT = A_WT
   AND VERSION = A_VERSION;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   IF A_IGNORE_DUP_VAL_ON_INDEX THEN
      L_RET_CODE := REMOVEWTFROMDB(A_WT, A_VERSION);
   END IF;
   RETURN(UNAPIGEN.DBERR_NORECORDS);
END COPYWTFROMARCHDB;

FUNCTION RESTOREWTFROMDB
(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   L_RET_CODE := COPYWTFROMARCHDB(A_WT, A_VERSION, TRUE);
   IF L_RET_CODE = UNAPIGEN.DBERR_NORECORDS THEN
      L_RET_CODE := COPYWTFROMARCHDB(A_WT, A_VERSION, FALSE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CopyWtFromArchDB#return='||TO_CHAR(L_RET_CODE)||' for wt='||A_WT||'#version='||A_VERSION;
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
          'RestoreWtFromDB', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END RESTOREWTFROMDB;

FUNCTION REMOVEWTFROMDB
(A_WT IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   

   DELETE FROM UTWT
   WHERE WT = A_WT
   AND VERSION = A_VERSION;

   DELETE FROM UTWTAU
   WHERE WT = A_WT
   AND VERSION = A_VERSION;

   DELETE FROM UTWTHS
   WHERE WT = A_WT
   AND VERSION = A_VERSION;

   DELETE FROM UTWTHSDETAILS
   WHERE WT = A_WT
   AND VERSION = A_VERSION;

   DELETE FROM UTWTROWS
   WHERE WT = A_WT
   AND VERSION = A_VERSION;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
END REMOVEWTFROMDB;

FUNCTION ARCHIVEWTTOFILE
(A_WT            IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER IS
   
   CURSOR L_UTWT_CURSOR (A_WT IN VARCHAR2, A_VERSION IN VARCHAR2) IS
      SELECT * FROM UDWT WHERE WT=A_WT AND VERSION=A_VERSION;

   CURSOR L_UTWTAU_CURSOR (A_WT IN VARCHAR2, A_VERSION IN VARCHAR2) IS
      SELECT * FROM UTWTAU WHERE WT=A_WT AND VERSION=A_VERSION;

   CURSOR L_UTWTHS_CURSOR (A_WT IN VARCHAR2, A_VERSION IN VARCHAR2) IS
      SELECT * FROM UTWTHS WHERE WT=A_WT AND VERSION=A_VERSION;

   CURSOR L_UTWTHSDETAILS_CURSOR (A_WT IN VARCHAR2, A_VERSION IN VARCHAR2) IS
      SELECT * FROM UTWTHSDETAILS WHERE WT=A_WT AND VERSION=A_VERSION;

   CURSOR L_UTWTROWS_CURSOR (A_WT IN VARCHAR2, A_VERSION IN VARCHAR2) IS
      SELECT * FROM UTWTROWS WHERE WT=A_WT AND VERSION=A_VERSION;

BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP :='utwt'||'wt='||A_WT||'#version='||A_VERSION;
   FOR L_REC IN L_UTWT_CURSOR(A_WT, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utwt' || L_SEP ||
      L_REC.WT || L_SEP || L_REC.VERSION || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_FROM,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_FROM_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_TILL,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_TILL_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      L_REC.DESCRIPTION || L_SEP || L_REC.DESCRIPTION2 || L_SEP ||
      L_REC.MIN_ROWS || L_SEP || L_REC.MAX_ROWS || L_SEP ||
      L_REC.VALID_CF || L_SEP || L_REC.DESCR_DOC || L_SEP ||
      L_REC.DESCR_DOC_VERSION || L_SEP || L_REC.WS_LY || L_SEP ||
      L_REC.WS_UC || L_SEP || L_REC.WS_UC_VERSION || L_SEP ||
      L_REC.WS_LC || L_SEP || L_REC.WS_LC_VERSION || L_SEP ||
      L_REC.INHERIT_AU || L_SEP || L_REC.LAST_COMMENT || L_SEP ||
      L_REC.WT_CLASS || L_SEP || L_REC.LOG_HS || L_SEP ||
      L_REC.LOG_HS_DETAILS || L_SEP || L_REC.ALLOW_MODIFY || L_SEP ||
      L_REC.ACTIVE || L_SEP || L_REC.LC || L_SEP || L_REC.LC_VERSION || L_SEP ||
      L_REC.SS || L_SEP || L_REC.AR1 || L_SEP || L_REC.AR2 || L_SEP ||
      L_REC.AR3 || L_SEP || L_REC.AR4 || L_SEP || L_REC.AR5 || L_SEP ||
      L_REC.AR6 || L_SEP || L_REC.AR7 || L_SEP || L_REC.AR8 || L_SEP ||
      L_REC.AR9 || L_SEP || L_REC.AR10 || L_SEP || L_REC.AR11 || L_SEP ||
      L_REC.AR12 || L_SEP || L_REC.AR13 || L_SEP || L_REC.AR14 || L_SEP ||
      L_REC.AR15 || L_SEP || L_REC.AR16 || L_SEP || L_REC.AR17 || L_SEP ||
      L_REC.AR18 || L_SEP || L_REC.AR19 || L_SEP || L_REC.AR20 || L_SEP ||
      L_REC.AR21 || L_SEP || L_REC.AR22 || L_SEP || L_REC.AR23 || L_SEP ||
      L_REC.AR24 || L_SEP || L_REC.AR25 || L_SEP || L_REC.AR26 || L_SEP ||
      L_REC.AR27 || L_SEP || L_REC.AR28 || L_SEP || L_REC.AR29 || L_SEP ||
      L_REC.AR30 || L_SEP || L_REC.AR31 || L_SEP || L_REC.AR32 || L_SEP ||
      L_REC.AR33 || L_SEP || L_REC.AR34 || L_SEP || L_REC.AR35 || L_SEP ||
      L_REC.AR36 || L_SEP || L_REC.AR37 || L_SEP || L_REC.AR38 || L_SEP ||
      L_REC.AR39 || L_SEP || L_REC.AR40 || L_SEP || L_REC.AR41 || L_SEP ||
      L_REC.AR42 || L_SEP || L_REC.AR43 || L_SEP || L_REC.AR44 || L_SEP ||
      L_REC.AR45 || L_SEP || L_REC.AR46 || L_SEP || L_REC.AR47 || L_SEP ||
      L_REC.AR48 || L_SEP || L_REC.AR49 || L_SEP || L_REC.AR50 || L_SEP ||
      L_REC.AR51 || L_SEP || L_REC.AR52 || L_SEP || L_REC.AR53 || L_SEP ||
      L_REC.AR54 || L_SEP || L_REC.AR55 || L_SEP || L_REC.AR56 || L_SEP ||
      L_REC.AR57 || L_SEP || L_REC.AR58 || L_SEP || L_REC.AR59 || L_SEP ||
      L_REC.AR60 || L_SEP || L_REC.AR61 || L_SEP || L_REC.AR62 || L_SEP ||
      L_REC.AR63 || L_SEP || L_REC.AR64 || L_SEP || L_REC.AR65 || L_SEP ||
      L_REC.AR66 || L_SEP || L_REC.AR67 || L_SEP || L_REC.AR68 || L_SEP ||
      L_REC.AR69 || L_SEP || L_REC.AR70 || L_SEP || L_REC.AR71 || L_SEP ||
      L_REC.AR72 || L_SEP || L_REC.AR73 || L_SEP || L_REC.AR74 || L_SEP ||
      L_REC.AR75 || L_SEP || L_REC.AR76 || L_SEP || L_REC.AR77 || L_SEP ||
      L_REC.AR78 || L_SEP || L_REC.AR79 || L_SEP || L_REC.AR80 || L_SEP ||
      L_REC.AR81 || L_SEP || L_REC.AR82 || L_SEP || L_REC.AR83 || L_SEP ||
      L_REC.AR84 || L_SEP || L_REC.AR85 || L_SEP || L_REC.AR86 || L_SEP ||
      L_REC.AR87 || L_SEP || L_REC.AR88 || L_SEP || L_REC.AR89 || L_SEP ||
      L_REC.AR90 || L_SEP || L_REC.AR91 || L_SEP || L_REC.AR92 || L_SEP ||
      L_REC.AR93 || L_SEP || L_REC.AR94 || L_SEP || L_REC.AR95 || L_SEP ||
      L_REC.AR96 || L_SEP || L_REC.AR97 || L_SEP || L_REC.AR98 || L_SEP ||
      L_REC.AR99 || L_SEP || L_REC.AR100 || L_SEP || L_REC.AR101 || L_SEP ||
      L_REC.AR102 || L_SEP || L_REC.AR103 || L_SEP || L_REC.AR104 || L_SEP ||
      L_REC.AR105 || L_SEP || L_REC.AR106 || L_SEP || L_REC.AR107 || L_SEP ||
      L_REC.AR108 || L_SEP || L_REC.AR109 || L_SEP || L_REC.AR110 || L_SEP ||
      L_REC.AR111 || L_SEP || L_REC.AR112 || L_SEP || L_REC.AR113 || L_SEP ||
      L_REC.AR114 || L_SEP || L_REC.AR115 || L_SEP || L_REC.AR116 || L_SEP ||
      L_REC.AR117 || L_SEP || L_REC.AR118 || L_SEP || L_REC.AR119 || L_SEP ||
      L_REC.AR120 || L_SEP || L_REC.AR121 || L_SEP || L_REC.AR122 || L_SEP ||
      L_REC.AR123 || L_SEP || L_REC.AR124 || L_SEP || L_REC.AR125 || L_SEP ||
      L_REC.AR126 || L_SEP || L_REC.AR127 || L_SEP || L_REC.AR128;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utwtau'||'wt='||A_WT||'#version='||A_VERSION;
   FOR L_REC IN L_UTWTAU_CURSOR(A_WT, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utwtau' || L_SEP ||
      L_REC.WT || L_SEP || L_REC.VERSION || L_SEP || L_REC.AU || L_SEP ||
      L_REC.AU_VERSION || L_SEP || L_REC.AUSEQ || L_SEP || L_REC.VALUE;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utwths'||'wt='||A_WT||'#version='||A_VERSION;
   FOR L_REC IN L_UTWTHS_CURSOR(A_WT, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utwths' || L_SEP ||
      L_REC.WT || L_SEP || L_REC.VERSION || L_SEP || L_REC.WHO || L_SEP ||
      L_REC.WHO_DESCRIPTION || L_SEP || L_REC.WHAT || L_SEP ||
      L_REC.WHAT_DESCRIPTION || L_SEP ||
      TO_CHAR(L_REC.LOGDATE,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.LOGDATE_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      L_REC.WHY || L_SEP || L_REC.TR_SEQ || L_SEP || L_REC.EV_SEQ;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utwthsdetails'||'wt='||A_WT||'#version='||A_VERSION;
   FOR L_REC IN L_UTWTHSDETAILS_CURSOR(A_WT, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utwthsdetails' || L_SEP ||
      L_REC.WT || L_SEP || L_REC.VERSION || L_SEP || L_REC.TR_SEQ || L_SEP ||
      L_REC.EV_SEQ || L_SEP || L_REC.SEQ || L_SEP || L_REC.DETAILS;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utwtrows'||'wt='||A_WT||'#version='||A_VERSION;
   FOR L_REC IN L_UTWTROWS_CURSOR(A_WT, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utwtrows' || L_SEP ||
      L_REC.WT || L_SEP || L_REC.VERSION || L_SEP || L_REC.ROWNR || L_SEP ||
      L_REC.ST || L_SEP || L_REC.ST_VERSION || L_SEP || L_REC.SC || L_SEP ||
      L_REC.SC_CREATE;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

UNAPIRA3.U4DATAPUTLINE( ' ');

RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN UTL_FILE.INVALID_PATH THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWtToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_NOOBJECT);

WHEN UTL_FILE.INVALID_MODE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWtToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.INVALID_FILEHANDLE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWtToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.INVALID_OPERATION THEN
   
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWtToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_NOOBJECT);

WHEN UTL_FILE.READ_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWtToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.WRITE_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWtToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.INTERNAL_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWtToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SQLERRM;
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWtToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWtToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVEWTTOFILE;

BEGIN
   L_SEP := UNAPIRA.P_INTERNAL_SEP;
END UNAPIRAWT;