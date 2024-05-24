PACKAGE BODY unapirast AS






STPERROR      EXCEPTION;
L_RET_CODE    INTEGER;
L_SQLERRM     VARCHAR2(255);
L_SQL_STRING  VARCHAR2(2000);
L_DYN_CURSOR  INTEGER;
L_SEP         CHAR(1);

CURSOR L_ALLSTGK_TABLES_CURSOR IS
   SELECT DISTINCT TABLE_NAME,
   LENGTH(TABLE_NAME) TABLE_ORDER2
   FROM USER_TAB_COLUMNS
   WHERE COLUMN_NAME = 'ST'
   AND (TABLE_NAME LIKE 'UTSTGK%')
   ORDER BY 2 ASC, 1 ASC;




PROCEDURE LOGERROR
(A_API IN VARCHAR2, A_ERROR_MSG IN VARCHAR2)
IS
BEGIN
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
           A_API, A_ERROR_MSG);
END LOGERROR;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
   RETURN (NULL);
END GETVERSION;




FUNCTION REMOVESTFROMARCHIVE
(A_ST IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   

   DELETE FROM UAUTST
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UAUTSTAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UAUTSTHS
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UAUTSTHSDETAILS
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UAUTSTIP
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UAUTSTIPAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UAUTSTMTFREQ
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UAUTSTPRFREQ
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UAUTSTPP
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UAUTSTPPAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   
   FOR L_TABLE_REC IN L_ALLSTGK_TABLES_CURSOR LOOP
      L_SQL_STRING := 'DELETE FROM '||L_TABLE_REC.TABLE_NAME||'@uniarch '||
                      'WHERE st=:a_st AND version=:a_version';
      BEGIN
         DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7);
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st', A_ST);
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_version', A_VERSION);
         L_RET_CODE := DBMS_SQL.EXECUTE(L_DYN_CURSOR);
      EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE <> -942 THEN
            L_SQLERRM := SUBSTR(SQLERRM,1,200);
            LOGERROR ('RemoveStFromArchive',L_SQLERRM);
            L_SQLERRM := 'Error while archiving table '||L_TABLE_REC.TABLE_NAME;
            LOGERROR ('RemoveStFromArchive',L_SQLERRM);
         ELSE
            L_SQLERRM := 'Table '||L_TABLE_REC.TABLE_NAME||' does not exist';
            LOGERROR ('RemoveStFromArchive',L_SQLERRM);
         END IF;
      END;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
END REMOVESTFROMARCHIVE;




FUNCTION COPYSTTOARCHDB(A_ST IN VARCHAR2, A_VERSION IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN) RETURN NUMBER IS
BEGIN
   
   EXECUTE IMMEDIATE
   'INSERT INTO uautst' ||
   UNAPIRA.LISTALLCOLUMNS('utst', 'BRACKETS', '1') ||
   ' SELECT '||   UNAPIRA.LISTALLCOLUMNS('utst', 'NO_BRACKETS', '1') ||
   ' FROM utst' ||
   ' WHERE st = '''||A_ST||'''' ||
   ' AND version = '''||A_VERSION||'''';
   INSERT INTO UAUTSTAU
      (ST, VERSION, AU, AU_VERSION, AUSEQ, VALUE)
   SELECT        ST, VERSION, AU, AU_VERSION, AUSEQ, VALUE
   FROM UTSTAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;
   INSERT INTO UAUTSTHS
      (ST, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
   SELECT  ST, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ
   FROM UTSTHS
   WHERE ST = A_ST
   AND VERSION = A_VERSION;
   INSERT INTO UAUTSTHSDETAILS
      (ST, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS)
   SELECT        ST, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS
   FROM UTSTHSDETAILS
   WHERE ST = A_ST
   AND VERSION = A_VERSION;
   INSERT INTO UAUTSTIP
      (ST, VERSION, IP, IP_VERSION, SEQ, IS_PROTECTED, HIDDEN, FREQ_TP, FREQ_VAL,
      FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL,
      INHERIT_AU)
   SELECT  ST, VERSION, IP, IP_VERSION, SEQ, IS_PROTECTED, HIDDEN, FREQ_TP, FREQ_VAL,
      FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL,
      INHERIT_AU
   FROM UTSTIP
   WHERE ST = A_ST
   AND VERSION = A_VERSION;
   INSERT INTO UAUTSTIPAU
      (ST, VERSION, IP, IP_VERSION, AU, AU_VERSION, AUSEQ, VALUE)
   SELECT        ST, VERSION, IP, IP_VERSION, AU, AU_VERSION, AUSEQ, VALUE
   FROM UTSTIPAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;
   INSERT INTO UAUTSTMTFREQ
      (ST, VERSION, PR, PR_VERSION, MT, MT_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT,
      INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL)
   SELECT  ST, VERSION, PR, PR_VERSION, MT, MT_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT,
      INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL
   FROM UTSTMTFREQ
   WHERE ST = A_ST
   AND VERSION = A_VERSION;
   INSERT INTO UAUTSTPRFREQ
      (ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR,
      PR_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED,
      LAST_SCHED_TZ, LAST_CNT, LAST_VAL)
   SELECT  ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR,
      PR_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED,
      LAST_SCHED_TZ, LAST_CNT, LAST_VAL
   FROM UTSTPRFREQ
   WHERE ST = A_ST
   AND VERSION = A_VERSION;
   INSERT INTO UAUTSTPP
      (ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5,
      SEQ, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ,
      LAST_CNT, LAST_VAL, INHERIT_AU)
   SELECT  ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5,
      SEQ, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ,
      LAST_CNT, LAST_VAL, INHERIT_AU
   FROM UTSTPP
   WHERE ST = A_ST
   AND VERSION = A_VERSION;
   INSERT INTO UAUTSTPPAU
      (ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, AU,
      AU_VERSION, AUSEQ, VALUE)
   SELECT  ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, AU,
      AU_VERSION, AUSEQ, VALUE
   FROM UTSTPPAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;
   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;

   
   FOR L_TABLE_REC IN L_ALLSTGK_TABLES_CURSOR LOOP
      L_SQL_STRING := 'INSERT INTO '||L_TABLE_REC.TABLE_NAME||'@uniarch '||
                      UNAPIRA.LISTALLCOLUMNS(L_TABLE_REC.TABLE_NAME, 'BRACKETS', '0') ||
                      ' SELECT '||
                      UNAPIRA.LISTALLCOLUMNS(L_TABLE_REC.TABLE_NAME, 'NO_BRACKETS', '0') ||
                      ' FROM '||L_TABLE_REC.TABLE_NAME||
                      ' WHERE st=:a_st'||
                      ' AND version=:a_version';
      BEGIN
         DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7);
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st', A_ST);
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_version', A_VERSION);
         L_RET_CODE := DBMS_SQL.EXECUTE(L_DYN_CURSOR);
      EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE <> -942 THEN
            L_SQLERRM := SUBSTR(SQLERRM,1,200);
            LOGERROR ('CopyStToArchDB',L_SQLERRM);
            L_SQLERRM := 'Error while archiving table '||L_TABLE_REC.TABLE_NAME;
            LOGERROR ('CopyStToArchDB',L_SQLERRM);
         ELSE
            L_SQLERRM := 'Table '||L_TABLE_REC.TABLE_NAME||' does not exist';
            LOGERROR ('CopyStToArchDB',L_SQLERRM);
         END IF;
      END;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   IF A_IGNORE_DUP_VAL_ON_INDEX THEN
      L_RET_CODE := REMOVESTFROMARCHIVE(A_ST, A_VERSION);
   END IF;
   RETURN(UNAPIGEN.DBERR_NORECORDS);
END COPYSTTOARCHDB;

FUNCTION ARCHIVESTTODB
(A_ST IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   L_RET_CODE := COPYSTTOARCHDB(A_ST, A_VERSION, TRUE);
   IF L_RET_CODE = UNAPIGEN.DBERR_NORECORDS THEN
      L_RET_CODE := COPYSTTOARCHDB(A_ST, A_VERSION, FALSE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CopyStToArchDB#return='||TO_CHAR(L_RET_CODE)||' for st='||A_ST||'#version='||A_VERSION;
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
          'ArchiveStToDB', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVESTTODB;

FUNCTION COPYSTFROMARCHDB(A_ST IN VARCHAR2, A_VERSION IN VARCHAR2, A_IGNORE_DUP_VAL_ON_INDEX BOOLEAN) RETURN NUMBER IS
BEGIN
   

   EXECUTE IMMEDIATE
   'INSERT INTO utst' ||
   UNAPIRA.LISTALLCOLUMNS('utst', 'BRACKETS', '1') ||
   ' SELECT '||   UNAPIRA.LISTALLCOLUMNS('utst', 'NO_BRACKETS', '1') ||
   ' FROM uautst' ||
   ' WHERE st = '''||A_ST||'''' ||
   ' AND version = '''||A_VERSION||'''';

   INSERT INTO UTSTAU
      (ST, VERSION, AU, AU_VERSION, AUSEQ, VALUE)
   SELECT        ST, VERSION, AU, AU_VERSION, AUSEQ, VALUE
   FROM UAUTSTAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   INSERT INTO UTSTHS
      (ST, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
   SELECT  ST, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,
      LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ
   FROM UAUTSTHS
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   INSERT INTO UTSTHSDETAILS
      (ST, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS)
   SELECT        ST, VERSION, TR_SEQ, EV_SEQ, SEQ, DETAILS
   FROM UAUTSTHSDETAILS
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   INSERT INTO UTSTIP
      (ST, VERSION, IP, IP_VERSION, SEQ, IS_PROTECTED, HIDDEN, FREQ_TP, FREQ_VAL,
      FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL,
      INHERIT_AU)
   SELECT  ST, VERSION, IP, IP_VERSION, SEQ, IS_PROTECTED, HIDDEN, FREQ_TP, FREQ_VAL,
      FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL,
      INHERIT_AU
   FROM UAUTSTIP
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   INSERT INTO UTSTIPAU
      (ST, VERSION, IP, IP_VERSION, AU, AU_VERSION, AUSEQ, VALUE)
   SELECT        ST, VERSION, IP, IP_VERSION, AU, AU_VERSION, AUSEQ, VALUE
   FROM UAUTSTIPAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   INSERT INTO UTSTMTFREQ
      (ST, VERSION, PR, PR_VERSION, MT, MT_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT,
      INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL)
   SELECT  ST, VERSION, PR, PR_VERSION, MT, MT_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT,
      INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL
   FROM UAUTSTMTFREQ
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   INSERT INTO UTSTPRFREQ
      (ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR,
      PR_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED,
      LAST_SCHED_TZ, LAST_CNT, LAST_VAL)
   SELECT  ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR,
      PR_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED,
      LAST_SCHED_TZ, LAST_CNT, LAST_VAL
   FROM UAUTSTPRFREQ
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   INSERT INTO UTSTPP
      (ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5,
      SEQ, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ,
      LAST_CNT, LAST_VAL, INHERIT_AU)
   SELECT  ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5,
      SEQ, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ,
      LAST_CNT, LAST_VAL, INHERIT_AU
   FROM UAUTSTPP
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   INSERT INTO UTSTPPAU
      (ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, AU,
      AU_VERSION, AUSEQ, VALUE)
   SELECT  ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, AU,
      AU_VERSION, AUSEQ, VALUE
   FROM UAUTSTPPAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;
   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   
   FOR L_TABLE_REC IN L_ALLSTGK_TABLES_CURSOR LOOP
      L_SQL_STRING := 'INSERT INTO '||L_TABLE_REC.TABLE_NAME||' '||
                      UNAPIRA.LISTALLCOLUMNS(L_TABLE_REC.TABLE_NAME, 'BRACKETS', '0') ||
                      ' SELECT '||
                      UNAPIRA.LISTALLCOLUMNS(L_TABLE_REC.TABLE_NAME, 'NO_BRACKETS', '0') ||
                      ' FROM '||L_TABLE_REC.TABLE_NAME||'@uniarch '||
                      ' WHERE st=:a_st'||
                      ' AND version=:a_version';
      BEGIN
         DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7);
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st', A_ST);
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_version', A_VERSION);
         L_RET_CODE := DBMS_SQL.EXECUTE(L_DYN_CURSOR);
      EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE <> -942 THEN
            L_SQLERRM := SUBSTR(SQLERRM,1,200);
            LOGERROR ('CopyStFromArchDB',L_SQLERRM);
            L_SQLERRM := 'Error while archiving table '||L_TABLE_REC.TABLE_NAME;
            LOGERROR ('CopyStFromArchDB',L_SQLERRM);
         ELSE
            L_SQLERRM := 'Table '||L_TABLE_REC.TABLE_NAME||' does not exist';
            LOGERROR ('CopyStFromArchDB',L_SQLERRM);
         END IF;
      END;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   IF A_IGNORE_DUP_VAL_ON_INDEX THEN
      L_RET_CODE := REMOVESTFROMDB(A_ST, A_VERSION);
   END IF;
   RETURN(UNAPIGEN.DBERR_NORECORDS);
END COPYSTFROMARCHDB;

FUNCTION RESTORESTFROMDB
(A_ST IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   L_RET_CODE := COPYSTFROMARCHDB(A_ST, A_VERSION, TRUE);
   IF L_RET_CODE = UNAPIGEN.DBERR_NORECORDS THEN
      L_RET_CODE := COPYSTFROMARCHDB(A_ST, A_VERSION, FALSE);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CopyStFromArchDB#return='||TO_CHAR(L_RET_CODE)||' for st='||A_ST||'#version='||A_VERSION;
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
          'RestoreStFromDB', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END RESTORESTFROMDB;

FUNCTION REMOVESTFROMDB
(A_ST IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER IS
BEGIN
   

   DELETE FROM UTST
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UTSTAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UTSTHS
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UTSTHSDETAILS
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UTSTIP
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UTSTIPAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UTSTMTFREQ
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UTSTPRFREQ
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UTSTPP
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   DELETE FROM UTSTPPAU
   WHERE ST = A_ST
   AND VERSION = A_VERSION;

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   
   FOR L_TABLE_REC IN L_ALLSTGK_TABLES_CURSOR LOOP
      L_SQL_STRING := 'DELETE FROM '||L_TABLE_REC.TABLE_NAME ||
                      ' WHERE st=:a_st'||
                      ' AND version=:a_version';
      BEGIN
         DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7);
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st', A_ST);
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_version', A_VERSION);
         L_RET_CODE := DBMS_SQL.EXECUTE(L_DYN_CURSOR);
      EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE <> -942 THEN
            L_SQLERRM := SUBSTR(SQLERRM,1,200);
            LOGERROR ('RemoveStFromDB',L_SQLERRM);
            L_SQLERRM := 'Error while archiving table '||L_TABLE_REC.TABLE_NAME;
            LOGERROR ('RemoveStFromDB',L_SQLERRM);
         ELSE
            L_SQLERRM := 'Table '||L_TABLE_REC.TABLE_NAME||' does not exist';
            LOGERROR ('RemoveStFromDB',L_SQLERRM);
         END IF;
      END;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
END REMOVESTFROMDB;

FUNCTION ARCHIVESTTOFILE
(A_ST            IN VARCHAR2, A_VERSION IN VARCHAR2)
RETURN NUMBER IS

CURSOR L_UTST_CURSOR (A_ST IN VARCHAR2, A_VERSION IN VARCHAR2) IS
   SELECT * FROM UDST WHERE ST=A_ST AND VERSION=A_VERSION;

CURSOR L_UTSTAU_CURSOR (A_ST IN VARCHAR2, A_VERSION IN VARCHAR2) IS
   SELECT * FROM UTSTAU WHERE ST=A_ST AND VERSION=A_VERSION;

CURSOR L_UTSTHS_CURSOR (A_ST IN VARCHAR2, A_VERSION IN VARCHAR2) IS
   SELECT * FROM UTSTHS WHERE ST=A_ST AND VERSION=A_VERSION;

CURSOR L_UTSTHSDETAILS_CURSOR (A_ST IN VARCHAR2, A_VERSION IN VARCHAR2) IS
   SELECT * FROM UTSTHSDETAILS WHERE ST=A_ST AND VERSION=A_VERSION;

CURSOR L_UTSTIP_CURSOR (A_ST IN VARCHAR2, A_VERSION IN VARCHAR2) IS
   SELECT * FROM UTSTIP WHERE ST=A_ST AND VERSION=A_VERSION;

CURSOR L_UTSTIPAU_CURSOR (A_ST IN VARCHAR2, A_VERSION IN VARCHAR2) IS
   SELECT * FROM UTSTIPAU WHERE ST=A_ST AND VERSION=A_VERSION;

CURSOR L_UTSTMTFREQ_CURSOR (A_ST IN VARCHAR2, A_VERSION IN VARCHAR2) IS
   SELECT * FROM UTSTMTFREQ WHERE ST=A_ST AND VERSION=A_VERSION;

CURSOR L_UTSTPRFREQ_CURSOR (A_ST IN VARCHAR2, A_VERSION IN VARCHAR2) IS
   SELECT * FROM UTSTPRFREQ WHERE ST=A_ST AND VERSION=A_VERSION;

CURSOR L_UTSTPP_CURSOR (A_ST IN VARCHAR2, A_VERSION IN VARCHAR2) IS
   SELECT * FROM UTSTPP WHERE ST=A_ST AND VERSION=A_VERSION;

CURSOR L_UTSTPPAU_CURSOR (A_ST IN VARCHAR2, A_VERSION IN VARCHAR2) IS
   SELECT * FROM UTSTPPAU WHERE ST=A_ST AND VERSION=A_VERSION;

BEGIN
   L_SQLERRM:=NULL;
   UNAPIRA.L_EXCEPTION_STEP :='utst' ||'st='||A_ST||'#version='||A_VERSION;
   FOR L_REC IN L_UTST_CURSOR(A_ST, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utst' || L_SEP ||
      L_REC.ST || L_SEP || L_REC.VERSION || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_FROM,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_FROM_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_TILL,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.EFFECTIVE_TILL_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      L_REC.DESCRIPTION || L_SEP || L_REC.DESCRIPTION2 || L_SEP ||
      L_REC.IS_TEMPLATE || L_SEP || L_REC.CONFIRM_USERID || L_SEP ||
      L_REC.SHELF_LIFE_VAL || L_SEP || L_REC.SHELF_LIFE_UNIT || L_SEP ||
      L_REC.NR_PLANNED_SC || L_SEP || L_REC.FREQ_TP || L_SEP ||
      L_REC.FREQ_VAL || L_SEP || L_REC.FREQ_UNIT || L_SEP ||
      L_REC.INVERT_FREQ || L_SEP ||
      TO_CHAR(L_REC.LAST_SCHED,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.LAST_SCHED_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      L_REC.LAST_CNT || L_SEP || L_REC.LAST_VAL || L_SEP ||
      L_REC.PRIORITY || L_SEP || L_REC.LABEL_FORMAT || L_SEP ||
      L_REC.DESCR_DOC || L_SEP || L_REC.DESCR_DOC_VERSION || L_SEP ||
      L_REC.ALLOW_ANY_PP || L_SEP || L_REC.SC_UC || L_SEP ||
      L_REC.SC_UC_VERSION || L_SEP || L_REC.SC_LC || L_SEP ||
      L_REC.SC_LC_VERSION || L_SEP || L_REC.INHERIT_AU || L_SEP ||
      L_REC.INHERIT_GK || L_SEP || L_REC.LAST_COMMENT || L_SEP ||
      L_REC.ST_CLASS || L_SEP || L_REC.LOG_HS || L_SEP ||
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

   UNAPIRA.L_EXCEPTION_STEP :='utstau' ||'st='||A_ST||'#version='||A_VERSION;
   FOR L_REC IN L_UTSTAU_CURSOR(A_ST, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utstau' || L_SEP ||
      L_REC.ST || L_SEP || L_REC.VERSION || L_SEP || L_REC.AU || L_SEP ||
      L_REC.AU_VERSION || L_SEP || L_REC.AUSEQ || L_SEP || L_REC.VALUE;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utsths' ||'st='||A_ST||'#version='||A_VERSION;
   FOR L_REC IN L_UTSTHS_CURSOR(A_ST, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utsths' || L_SEP ||
      L_REC.ST || L_SEP || L_REC.VERSION || L_SEP || L_REC.WHO || L_SEP ||
      L_REC.WHO_DESCRIPTION || L_SEP || L_REC.WHAT || L_SEP ||
      L_REC.WHAT_DESCRIPTION || L_SEP ||
      TO_CHAR(L_REC.LOGDATE,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.LOGDATE_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      L_REC.WHY || L_SEP || L_REC.TR_SEQ || L_SEP || L_REC.EV_SEQ;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utsthsdetails' ||'st='||A_ST||'#version='||A_VERSION;
   FOR L_REC IN L_UTSTHSDETAILS_CURSOR(A_ST, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utsthsdetails' || L_SEP ||
      L_REC.ST || L_SEP || L_REC.VERSION || L_SEP || L_REC.TR_SEQ || L_SEP ||
      L_REC.EV_SEQ || L_SEP || L_REC.SEQ || L_SEP || L_REC.DETAILS;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utstip' ||'st='||A_ST||'#version='||A_VERSION;
   FOR L_REC IN L_UTSTIP_CURSOR(A_ST, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utstip' || L_SEP ||
      L_REC.ST || L_SEP || L_REC.VERSION || L_SEP || L_REC.IP || L_SEP ||
      L_REC.IP_VERSION || L_SEP || L_REC.SEQ || L_SEP ||
      L_REC.IS_PROTECTED || L_SEP || L_REC.HIDDEN || L_SEP ||
      L_REC.FREQ_TP || L_SEP || L_REC.FREQ_VAL || L_SEP ||
      L_REC.FREQ_UNIT || L_SEP || L_REC.INVERT_FREQ || L_SEP ||
      TO_CHAR(L_REC.LAST_SCHED,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.LAST_SCHED_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      L_REC.LAST_CNT || L_SEP || L_REC.LAST_VAL || L_SEP ||
      L_REC.INHERIT_AU;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utstipau' ||'st='||A_ST||'#version='||A_VERSION;
   FOR L_REC IN L_UTSTIPAU_CURSOR(A_ST, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utstipau' || L_SEP ||
      L_REC.ST || L_SEP || L_REC.VERSION || L_SEP || L_REC.IP || L_SEP ||
      L_REC.IP_VERSION || L_SEP || L_REC.AU || L_SEP ||
      L_REC.AU_VERSION || L_SEP || L_REC.AUSEQ || L_SEP || L_REC.VALUE;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utstmtfreq' ||'st='||A_ST||'#version='||A_VERSION;
   FOR L_REC IN L_UTSTMTFREQ_CURSOR(A_ST, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utstmtfreq' || L_SEP ||
      L_REC.ST || L_SEP || L_REC.VERSION || L_SEP || L_REC.PR || L_SEP ||
      L_REC.PR_VERSION || L_SEP || L_REC.MT || L_SEP ||
      L_REC.MT_VERSION || L_SEP || L_REC.FREQ_TP || L_SEP ||
      L_REC.FREQ_VAL || L_SEP || L_REC.FREQ_UNIT || L_SEP ||
      L_REC.INVERT_FREQ || L_SEP ||
      TO_CHAR(L_REC.LAST_SCHED,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.LAST_SCHED_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      L_REC.LAST_CNT || L_SEP || L_REC.LAST_VAL;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utstprfreq' ||'st='||A_ST||'#version='||A_VERSION;
   FOR L_REC IN L_UTSTPRFREQ_CURSOR(A_ST, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utstprfreq' || L_SEP ||
      L_REC.ST || L_SEP || L_REC.VERSION || L_SEP || L_REC.PP || L_SEP ||
      L_REC.PP_VERSION || L_SEP || L_REC.PP_KEY1 || L_SEP ||
      L_REC.PP_KEY2 || L_SEP || L_REC.PP_KEY3 || L_SEP ||
      L_REC.PP_KEY4 || L_SEP || L_REC.PP_KEY5 || L_SEP || L_REC.PR || L_SEP ||
      L_REC.PR_VERSION || L_SEP || L_REC.FREQ_TP || L_SEP ||
      L_REC.FREQ_VAL || L_SEP || L_REC.FREQ_UNIT || L_SEP ||
      L_REC.INVERT_FREQ || L_SEP ||
      TO_CHAR(L_REC.LAST_SCHED,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.LAST_SCHED_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      L_REC.LAST_CNT || L_SEP || L_REC.LAST_VAL;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utstpp' ||'st='||A_ST||'#version='||A_VERSION;
   FOR L_REC IN L_UTSTPP_CURSOR(A_ST, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utstpp' || L_SEP ||
      L_REC.ST || L_SEP || L_REC.VERSION || L_SEP || L_REC.PP || L_SEP ||
      L_REC.PP_VERSION || L_SEP || L_REC.PP_KEY1 || L_SEP ||
      L_REC.PP_KEY2 || L_SEP || L_REC.PP_KEY3 || L_SEP ||
      L_REC.PP_KEY4 || L_SEP || L_REC.PP_KEY5 || L_SEP || L_REC.SEQ || L_SEP ||
      L_REC.FREQ_TP || L_SEP || L_REC.FREQ_VAL || L_SEP ||
      L_REC.FREQ_UNIT || L_SEP || L_REC.INVERT_FREQ || L_SEP ||
      TO_CHAR(L_REC.LAST_SCHED,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      TO_CHAR(L_REC.LAST_SCHED_TZ,UNAPIRA.P_TSTZ_FORMAT) || L_SEP ||
      L_REC.LAST_CNT || L_SEP || L_REC.LAST_VAL || L_SEP ||
      L_REC.INHERIT_AU;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP :='utstppau' ||'st='||A_ST||'#version='||A_VERSION;
   FOR L_REC IN L_UTSTPPAU_CURSOR(A_ST, A_VERSION) LOOP
      UNAPIRA3.L_PUTTEXT := 'utstppau' || L_SEP ||
      L_REC.ST || L_SEP || L_REC.VERSION || L_SEP || L_REC.PP || L_SEP ||
      L_REC.PP_VERSION || L_SEP || L_REC.PP_KEY1 || L_SEP ||
      L_REC.PP_KEY2 || L_SEP || L_REC.PP_KEY3 || L_SEP ||
      L_REC.PP_KEY4 || L_SEP || L_REC.PP_KEY5 || L_SEP || L_REC.AU || L_SEP ||
      L_REC.AU_VERSION || L_SEP || L_REC.AUSEQ || L_SEP || L_REC.VALUE;
      UNAPIRA3.U4DATAPUTLINE(UNAPIRA3.L_PUTTEXT);
   END LOOP;

   
   
   UNAPIRA.L_EXCEPTION_STEP :='ArchiveStGkToFile#st='||A_ST||'#version='||A_VERSION;
   L_RET_CODE := UNAPIRA3.ARCHIVESTGKTOFILE(A_ST, A_VERSION);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_SQLERRM := 'ArchiveStGkToFile return='||L_RET_CODE||'for st '||A_ST||'#version='||A_VERSION;
      RAISE STPERROR;
   END IF;

   UNAPIRA3.U4DATAPUTLINE( ' ');

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN UTL_FILE.INVALID_PATH THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_NOOBJECT);

WHEN UTL_FILE.INVALID_MODE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.INVALID_FILEHANDLE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.INVALID_OPERATION THEN
   
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_NOOBJECT);

WHEN UTL_FILE.READ_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.WRITE_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN UTL_FILE.INTERNAL_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);

WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SQLERRM;
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVESTTOFILE;

BEGIN
   L_SEP:=UNAPIRA.P_INTERNAL_SEP;
END UNAPIRAST;