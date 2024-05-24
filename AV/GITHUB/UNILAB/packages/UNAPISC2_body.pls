PACKAGE BODY unapisc2 AS






L_SQL_STRING      VARCHAR2(10000);
L_WHERE_CLAUSE    VARCHAR2(10000);

L_EVENT_TP        UTEV.EV_TP%TYPE;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
L_EV_DETAILS      VARCHAR2(255);
L_SQLERRM         VARCHAR2(255);
L_ERRM            VARCHAR2(255);
L_RET_CODE        INTEGER;
STPERROR          EXCEPTION;
L_ROW             INTEGER;

P_STPLAN_CURSOR          INTEGER;  
L_SC_CURSOR              INTEGER;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.21');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;


FUNCTION GETPREFVALUE                                  
(A_UP_IN            IN     NUMBER,                     
 A_US_IN            IN     VARCHAR2,                   
 A_PREF_NAME_IN     IN     VARCHAR2,                   
 A_PREF_VALUE       OUT    VARCHAR2)                   
RETURN NUMBER IS

L_UPUSPREF_UP           UNAPIGEN.LONG_TABLE_TYPE;
L_UPUSPREF_US           UNAPIGEN.VC20_TABLE_TYPE;
L_UPUSPREF_PREF_NAME    UNAPIGEN.VC20_TABLE_TYPE;
L_UPUSPREF_PREF_VALUE   UNAPIGEN.VC40_TABLE_TYPE;
L_UPUSPREF_INHERIT_PREF UNAPIGEN.CHAR1_TABLE_TYPE;
L_UPUSPREF_NR_OF_ROWS   NUMBER;
L_UP_IN                 NUMBER;

BEGIN 
   
   
   
   IF UNAPIEV.P_EV_MGR_SESSION THEN
      BEGIN
         SELECT DEF_UP
         INTO L_UP_IN
         FROM UTAD
         WHERE AD = A_US_IN;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN(UNAPIGEN.DBERR_NOOBJECT);
      END;
   ELSE
     L_UP_IN := A_UP_IN;
   END IF;

   L_RET_CODE := UNAPIUPP.GETUPUSPREF(L_UP_IN, NVL(A_US_IN,UNAPIGEN.P_USER) , A_PREF_NAME_IN,
                                      L_UPUSPREF_UP, L_UPUSPREF_US, L_UPUSPREF_PREF_NAME,
                                      L_UPUSPREF_PREF_VALUE, L_UPUSPREF_INHERIT_PREF,
                                      L_UPUSPREF_NR_OF_ROWS);
   IF L_RET_CODE = UNAPIGEN.DBERR_NORECORDS THEN
      A_PREF_VALUE := '';
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_SQLERRM := 'GetUpUsPref returned '||TO_CHAR(L_RET_CODE) || ' for (up,user,pref_name)=('||
                   TO_CHAR(A_UP_IN) || ',' ||  NVL(A_US_IN,UNAPIGEN.P_USER) || ',' || A_PREF_NAME_IN ||')';
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   ELSIF L_UPUSPREF_NR_OF_ROWS > 1 THEN
      L_SQLERRM := 'GetUpUsPref returned too much rows for (up,user,pref_name)=('||
                   TO_CHAR(A_UP_IN) || ',' ||  NVL(A_US_IN,UNAPIGEN.P_USER) || ',' || A_PREF_NAME_IN ||')';
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
   A_PREF_VALUE := L_UPUSPREF_PREF_VALUE(1);
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END GETPREFVALUE;

FUNCTION COPYSAMPLE                  
(A_SC_FROM         IN     VARCHAR2,  
 A_ST_TO           IN     VARCHAR2,  
 A_ST_TO_VERSION   IN OUT VARCHAR2,   
 A_SC_TO           IN OUT VARCHAR2,  
 A_REF_DATE        IN     DATE,      
 A_COPY_IC         IN     VARCHAR2,  
 A_COPY_PG         IN     VARCHAR2,  
 A_USERID          IN     VARCHAR2,  
 A_MODIFY_REASON   IN     VARCHAR2)  
RETURN NUMBER IS

L_SAMPLING_DATE         TIMESTAMP WITH TIME ZONE;
L_PREF_VALUE            VARCHAR2(40);
L_COPY_IC               VARCHAR2(40);
L_COPY_PG               VARCHAR2(40);
L_DATE_CURSOR           INTEGER;
L_SC_TO_GK_CURSOR       INTEGER;
L_ST_REC                UTST%ROWTYPE;
L_EDIT_ALLOWED          CHAR(1);
L_VALID_CF              VARCHAR2(20);
L_DELAYED_TILL          TIMESTAMP WITH TIME ZONE;
L_TIMED_EVENT_TP        VARCHAR2(255);
L_REF_DATE              TIMESTAMP WITH TIME ZONE;
L_LC                    VARCHAR2(2);
L_LC_VERSION            VARCHAR2(20);
L_SS                    VARCHAR2(2);
L_LOG_HS                CHAR(1);
L_LOG_HS_DETAILS        CHAR(1);
L_ALLOW_MODIFY          CHAR(1);
L_ACTIVE                CHAR(1);
L_SC_CLASS              VARCHAR2(2);
L_ST_TO                 VARCHAR2(20);
L_ST_TO_VERSION         VARCHAR2(20);
L_COPY_PARAMETERS       CHAR(1);
L_COPY_METHODS          CHAR(1);
L_ST_VERSION            VARCHAR2(20);
L_ST_ACTIVE             CHAR(1);
L_HS_DETAILS_SEQ_NR     INTEGER;
L_RETRIES               INTEGER;
L_FIELDTYPE_TAB         UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDNAMES_TAB        UNAPIGEN.VC20_TABLE_TYPE;
L_FIELDVALUES_TAB       UNAPIGEN.VC40_TABLE_TYPE;
L_FIELDNR_OF_ROWS       NUMBER;
L_MAX_NUMBER_OF_SAMPLES INTEGER;
L_COUNT_SAMPLES         INTEGER;
L_EVMGR_NAME            VARCHAR2(20);
L_COPY_EVENT_MGR        VARCHAR2(20);

CURSOR L_SC_FROM_GK_CURSOR(A_SC_FROM VARCHAR2) IS
   SELECT A.GK, A.GKSEQ, A.VALUE
   FROM UTSCGK A
   WHERE A.SC = A_SC_FROM;

CURSOR L_SC_ST_CURSOR(A_SC_FROM VARCHAR2) IS
   SELECT A.ST, A.ST_VERSION
   FROM UTSC A
   WHERE A.SC = A_SC_FROM;

CURSOR L_ST_ACTIVE_CURSOR(A_ST VARCHAR2, A_ST_VERSION VARCHAR2) IS
   SELECT A.ACTIVE
   FROM UTST A
   WHERE A.ST = A_ST
   AND A.VERSION = A_ST_VERSION;

CURSOR L_OBJECTS_CURSOR (A_OBJECT_TYPE VARCHAR2) IS
   SELECT LOG_HS
   FROM UTOBJECTS
   WHERE OBJECT=A_OBJECT_TYPE;

CURSOR L_ALLSCIC_CURSOR(A_SC VARCHAR2) IS
   SELECT IC, ICNODE
   FROM UTSCIC
   WHERE SC = A_SC
   ORDER BY ICNODE;












CURSOR L_SCIC_POS_CURSOR (A_SC_FROM VARCHAR2, A_SC_TO   VARCHAR2, A_IC VARCHAR2) IS
SELECT A.IC_TO, A.ICNODE_TO, B.IC_FROM, B.ICNODE_FROM 
FROM (SELECT IC IC_TO, ICNODE ICNODE_TO, ROW_NUMBER() OVER(ORDER BY ICNODE ASC) POSITION
      FROM (SELECT IC,ICNODE FROM UTSCIC
           WHERE SC=A_SC_TO 
           AND IC=A_IC
           GROUP BY IC,ICNODE)) A,
     (SELECT IC IC_FROM, ICNODE ICNODE_FROM, ROW_NUMBER() OVER(ORDER BY ICNODE ASC) POSITION
      FROM (SELECT IC,ICNODE FROM UTSCIC
           WHERE SC=A_SC_FROM
           AND IC=A_IC
           GROUP BY IC,ICNODE)) B
WHERE A.POSITION = B.POSITION(+);
L_SCIC_POS_REC     L_SCIC_POS_CURSOR%ROWTYPE;    
L_SCIC_POS_FOUND   BOOLEAN;    

CURSOR L_ALLSCPG_CURSOR(A_SC VARCHAR2) IS
   SELECT PG, PGNODE
   FROM UTSCPG
   WHERE SC = A_SC
   ORDER BY PGNODE;












CURSOR L_SCPG_POS_CURSOR (A_SC_FROM VARCHAR2, A_SC_TO   VARCHAR2, A_PG VARCHAR2) IS
SELECT A.PG_TO, A.PGNODE_TO, B.PG_FROM, B.PGNODE_FROM 
FROM (SELECT PG PG_TO, PGNODE PGNODE_TO, ROWNUM POSITION
      FROM (SELECT PG,PGNODE FROM UTSCPG
           WHERE SC=A_SC_TO 
           AND PG=A_PG
           GROUP BY PG,PGNODE)) A,
     (SELECT PG PG_FROM, PGNODE PGNODE_FROM, ROWNUM POSITION
      FROM (SELECT PG,PGNODE FROM UTSCPG
           WHERE SC=A_SC_FROM
           AND PG=A_PG
           GROUP BY PG,PGNODE)) B
WHERE A.POSITION = B.POSITION(+);
L_SCPG_POS_REC     L_SCPG_POS_CURSOR%ROWTYPE;    
L_SCPG_POS_FOUND   BOOLEAN;    

BEGIN

   
   L_SQLERRM := '';
   
   BEGIN
      SELECT SETTING_VALUE
      INTO L_COPY_EVENT_MGR
      FROM UTSYSTEM
      WHERE SETTING_NAME = 'COPY_EVENT_MGR';
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      L_COPY_EVENT_MGR := 'U4EVMGR' ; 
   END;

   L_EVMGR_NAME := UNAPIGEN.P_EVMGR_NAME;
   UNAPIGEN.P_EVMGR_NAME := L_COPY_EVENT_MGR;

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   IF UNAPIGEN.P_PP_KEY4PRODUCT IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SETCONNECTION;
      RAISE STPERROR;               
   END IF;

   
   
   
   
   
   
   IF NVL(A_SC_FROM, ' ') = ' ' THEN
      L_RET_CODE := UNAPIGEN.DBERR_NOOBJID;
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF NVL(A_COPY_IC, ' ') NOT IN 
     ('CREATE IC', 'CREATE IC COPY IIVALUE', 'COPY IC', 'COPY IC COPY IIVALUE') THEN
     L_SQLERRM:= 'copy_ic has illegal value';
     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_COPYIC;
     RAISE STPERROR;
   END IF;

   IF NVL(A_COPY_PG, ' ') NOT IN 
     ('CREATE PG', 'CREATE PG COPY PAVALUE', 'COPY PG', 'COPY PG COPY PAVALUE', 'WHEN INFO AVAILABLE') THEN
     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_COPYPG;
     L_SQLERRM:= 'copy_pg has illegal value';
     RAISE STPERROR;
   END IF;

   
   IF A_ST_TO IS NOT NULL THEN
      A_ST_TO_VERSION := UNAPIGEN.VALIDATEVERSION('st', A_ST_TO, A_ST_TO_VERSION);
      L_ST_TO         := A_ST_TO;
      L_ST_TO_VERSION := A_ST_TO_VERSION;
   ELSE
      
      OPEN L_SC_ST_CURSOR(A_SC_FROM);
      FETCH L_SC_ST_CURSOR
      INTO L_ST_TO, L_ST_TO_VERSION;
      IF L_SC_ST_CURSOR%NOTFOUND THEN
         CLOSE L_SC_ST_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         L_SQLERRM:= 'sample a_sc_from'||A_SC_FROM||' does not exist';
         RAISE STPERROR;
      END IF;
      CLOSE L_SC_ST_CURSOR;

      
      L_ST_ACTIVE := '0';
      OPEN L_ST_ACTIVE_CURSOR(L_ST_TO, L_ST_TO_VERSION);
      FETCH L_ST_ACTIVE_CURSOR
      INTO L_ST_ACTIVE;
      IF L_ST_ACTIVE_CURSOR%NOTFOUND THEN
         CLOSE L_ST_ACTIVE_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         L_SQLERRM:= 'sample type st='||L_ST_TO||'#version='||L_ST_TO_VERSION||' does not exist';
         RAISE STPERROR;
      END IF;
      CLOSE L_ST_ACTIVE_CURSOR;

      
      IF L_ST_ACTIVE = '0' THEN
         L_ST_TO_VERSION := NULL;
         A_ST_TO_VERSION := UNAPIGEN.VALIDATEVERSION('st', L_ST_TO, L_ST_TO_VERSION);
      ELSE
         A_ST_TO_VERSION := L_ST_TO_VERSION;
      END IF;
   END IF;   

   
   
   
   L_RET_CODE := UNAPIGEN.GETMAXSAMPLES(L_MAX_NUMBER_OF_SAMPLES);
   IF NVL(L_MAX_NUMBER_OF_SAMPLES, 0) >= 0 THEN
      
      
      SELECT COUNT(*)
      INTO L_COUNT_SAMPLES
      FROM UTSC;
      
      IF (L_COUNT_SAMPLES+1) >= L_MAX_NUMBER_OF_SAMPLES THEN
         L_SQLERRM := 'The maximum number of samples for your system has been reached. You need another type license.';
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
         RAISE STPERROR;      
      END IF;
   END IF;
   
   
      
   
   
   
   
   IF A_REF_DATE IS NULL THEN
      L_REF_DATE := NULL;
      L_SAMPLING_DATE := NULL;
   ELSE
      L_SAMPLING_DATE := A_REF_DATE;
      L_REF_DATE := A_REF_DATE;
   END IF;

   
   
   
   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   LOOP
      L_RET_CODE := UNAPISCP.ISSAMPLENOTINTRANSITION(A_SC_FROM);
      EXIT WHEN L_RET_CODE <> UNAPIGEN.DBERR_TRANSITION;
      EXIT WHEN L_RETRIES <= 0;
      L_RETRIES := L_RETRIES - 1;
      DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
   END LOOP;
   
   IF L_RET_CODE = UNAPIGEN.DBERR_TRANSITION THEN
      L_SQLERRM := 'Sample to copy from (sc='||A_SC_FROM||')is in transition';
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_SQLERRM := 'UNAPISCP.IsSampleNotInTransition returned='||L_RET_CODE;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   L_FIELDNR_OF_ROWS := 0;
   IF NVL(A_SC_TO, ' ') = ' ' THEN
      L_RET_CODE := UNAPISC.GENERATESAMPLECODE(L_ST_TO, L_ST_TO_VERSION, L_REF_DATE, 
                                               L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, 
                                               L_FIELDVALUES_TAB, L_FIELDNR_OF_ROWS,
                                               A_SC_TO, L_EDIT_ALLOWED, L_VALID_CF);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

   
   
   
   
   
   
   
   
   L_ST_VERSION := L_ST_TO_VERSION;
   L_RET_CODE := UNAPIAUT.GETSCAUTHORISATION(A_SC_TO, L_ST_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_NOOBJECT  THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SCALREADYEXIST;
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   

   IF (NVL(L_ST_TO, ' ') <> ' ') AND (NVL(L_ST_TO_VERSION, ' ') <> ' ') THEN
      BEGIN
         SELECT *
         INTO L_ST_REC
         FROM UTST
         WHERE ST = L_ST_TO
           AND VERSION = L_ST_TO_VERSION;
         L_ST_REC.SC_LC_VERSION := UNAPIGEN.USEVERSION('lc', L_ST_REC.SC_LC, L_ST_REC.SC_LC_VERSION);
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR;
      END;
   END IF;
   
   
   
   
   L_COPY_PG := A_COPY_PG;
   IF NVL(L_COPY_PG, 'ON SAMPLE CREATION') = 'WHEN INFO AVAILABLE' THEN
      L_SC_CLASS := '1';
   ELSIF (NVL(L_ST_TO, ' ') <> ' ') AND (NVL(L_ST_TO_VERSION, ' ') <> ' ') THEN 
      L_SC_CLASS := L_ST_REC.ST_CLASS ;
   ELSE
      L_SC_CLASS := NULL;    
   END IF;

   
   
   
   
   IF (NVL(L_ST_TO, ' ') <> ' ') AND (NVL(L_ST_TO_VERSION, ' ') <> ' ') THEN
      
      INSERT INTO UTSC(SC, ST, ST_VERSION, DESCRIPTION, SHELF_LIFE_VAL, 
                       SHELF_LIFE_UNIT, SAMPLING_DATE, SAMPLING_DATE_TZ, CREATION_DATE, CREATION_DATE_TZ, CREATED_BY, 
                       PRIORITY, LABEL_FORMAT, DESCR_DOC, 
                       DESCR_DOC_VERSION, SC_CLASS, LOG_HS, LOG_HS_DETAILS, ALLOW_MODIFY,
                       ACTIVE, LC, LC_VERSION, ALLOW_ANY_PP)
      VALUES(A_SC_TO, L_ST_TO, L_ST_TO_VERSION, L_ST_REC.DESCRIPTION, L_ST_REC.SHELF_LIFE_VAL,
             L_ST_REC.SHELF_LIFE_UNIT, L_SAMPLING_DATE,L_SAMPLING_DATE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NVL(A_USERID,UNAPIGEN.P_USER),
             L_ST_REC.PRIORITY, L_ST_REC.LABEL_FORMAT, L_ST_REC.DESCR_DOC, 
             L_ST_REC.DESCR_DOC_VERSION, L_SC_CLASS, L_LOG_HS, L_LOG_HS_DETAILS, '#',
             '0', L_ST_REC.SC_LC, L_ST_REC.SC_LC_VERSION, L_ST_REC.ALLOW_ANY_PP);
      UNAPIAUT.UPDATELCINAUTHORISATIONBUFFER('sc', A_SC_TO, '', L_ST_REC.SC_LC, L_ST_REC.SC_LC_VERSION);
   ELSE
      INSERT INTO UTSC(SC, SAMPLING_DATE, SAMPLING_DATE_TZ, CREATION_DATE, CREATION_DATE_TZ, CREATED_BY, LOG_HS, 
                       LOG_HS_DETAILS, ALLOW_MODIFY, ACTIVE, LC, LC_VERSION, ALLOW_ANY_PP, SC_CLASS, 
                       SHELF_LIFE_VAL, SHELF_LIFE_UNIT)
      VALUES (A_SC_TO, L_SAMPLING_DATE, L_SAMPLING_DATE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NVL(A_USERID,UNAPIGEN.P_USER), L_LOG_HS, 
              L_LOG_HS_DETAILS, '#', '0', '', '', '1', L_SC_CLASS, 
              0, 'DD');
   END IF;

   
   
   
   INSERT INTO UTSCAU(SC, AU, AUSEQ, VALUE)
   SELECT A_SC_TO, AU, AUSEQ, VALUE
   FROM UTSCAU
   WHERE SC = A_SC_FROM;   
   
   
   L_SC_TO_GK_CURSOR := DBMS_SQL.OPEN_CURSOR;
   
   
   
   FOR L_SC_FROM_GK_REC IN L_SC_FROM_GK_CURSOR(A_SC_FROM) LOOP
      BEGIN
         IF L_SC_FROM_GK_REC.VALUE IS NOT NULL THEN
            L_SQL_STRING := 'INSERT INTO utscgk' || L_SC_FROM_GK_REC.GK ||
                            '(sc, ' || L_SC_FROM_GK_REC.GK || ') VALUES (''' ||
                             REPLACE(A_SC_TO, '''', '''''') || ''',''' || 
                             REPLACE(L_SC_FROM_GK_REC.VALUE, '''', '''''') || ''')'; 

            DBMS_SQL.PARSE(L_SC_TO_GK_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            L_RESULT := DBMS_SQL.EXECUTE(L_SC_TO_GK_CURSOR);

            IF L_RESULT = 0 THEN
               UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NORECORDS;
               RAISE STPERROR;
            END IF;
         END IF;

         
         INSERT INTO UTSCGK(SC, GK, GKSEQ, VALUE)
         VALUES(A_SC_TO, L_SC_FROM_GK_REC.GK, L_SC_FROM_GK_REC.GKSEQ, L_SC_FROM_GK_REC.VALUE);
      EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         
         
         NULL;
      WHEN OTHERS THEN
         
         
         IF SQLCODE=-942 THEN
            NULL;
         ELSE
            RAISE;
         END IF;
      END;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_SC_TO_GK_CURSOR);

   
   IF INSTR(A_COPY_IC, 'CREATE IC')<>0 THEN
      L_RET_CODE := UNAPIIC.CREATESCINFODETAILS(L_ST_TO, L_ST_TO_VERSION, A_SC_TO,
                                                UNAPIGEN.PERFORM_FREQ_FILTERING,
                                                L_REF_DATE, A_MODIFY_REASON);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CreateScInfoDetails returned='||L_RET_CODE||
                      '#st='||L_ST_TO|| 
                      '#st_version='||L_ST_TO_VERSION|| 
                      '#sc='||A_SC_TO;
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   ELSIF INSTR(A_COPY_IC, 'COPY IC')<>0 THEN
      L_RET_CODE := UNAPIIC.COPYSCINFODETAILS(A_SC_FROM, L_ST_TO, L_ST_TO_VERSION, A_SC_TO, 
                                              A_MODIFY_REASON);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CopyScInfoDetails returned='||L_RET_CODE||
                      '#sc_from='||A_SC_FROM||
                      '#st='||L_ST_TO||
                      '#st_version='||L_ST_TO_VERSION||
                      '#sc_to='||A_SC_TO;
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;   
   END IF;

   
   IF INSTR(A_COPY_PG, 'CREATE PG')<>0 THEN
      L_RET_CODE := UNAPISC.CREATESCANALYSESDETAILS(L_ST_TO, L_ST_TO_VERSION, A_SC_TO,
                                                UNAPIGEN.PERFORM_FREQ_FILTERING,
                                                L_REF_DATE, 
                                                L_FIELDTYPE_TAB, L_FIELDNAMES_TAB, 
                                                L_FIELDVALUES_TAB, L_FIELDNR_OF_ROWS,
                                                A_MODIFY_REASON);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CreateScAnalysesDetails returned='||L_RET_CODE||
                      '#st='||L_ST_TO||
                      '#st_version='||NVL(L_ST_TO_VERSION, 'NULL')||
                      '#sc='||A_SC_TO;
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   ELSIF INSTR(A_COPY_PG, 'COPY PG')<>0 THEN
      
      L_COPY_METHODS := '0';
      IF INSTR(A_COPY_PG, 'COPY PAVALUE')=0 THEN
         L_COPY_METHODS := '1';
      END IF;
      L_COPY_PARAMETERS := '1'; 
      L_RET_CODE := UNAPISC2.COPYSCANALYSESDETAILS(A_SC_FROM, L_ST_TO, L_ST_TO_VERSION, A_SC_TO, 
                                                   L_COPY_PARAMETERS, L_COPY_METHODS, A_MODIFY_REASON);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'CopyScAnalysesDetails returned='||L_RET_CODE||
                      '#sc_from='||A_SC_FROM||
                      '#st='||L_ST_TO||
                      '#st_version='||NVL(L_ST_TO_VERSION, 'NULL')||
                      '#sc_to='||A_SC_TO||
                      '#copy_methods='||L_COPY_METHODS;
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;
   
  
   
   
   
   

   L_EVENT_TP := 'SampleCreated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'st_version=' || L_ST_TO_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('CopySample', UNAPIGEN.P_EVMGR_NAME, 'sc',
                                   A_SC_TO, '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
   VALUES(A_SC_TO, NVL(A_USERID, UNAPIGEN.P_USER), 
          UNAPIGEN.SQLUSERDESCRIPTION(NVL(A_USERID, UNAPIGEN.P_USER)), 
          L_EVENT_TP, 'Sample "'||A_SC_TO||'" is created by copying sample "'||A_SC_FROM||'"', 
          CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);

   L_HS_DETAILS_SEQ_NR := 0;
   L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
   INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
   VALUES(A_SC_TO, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
          'Sample "'||A_SC_TO||'" is created by copying sample "'||A_SC_FROM||'"');
   
   
   
   
   
   IF NVL(L_ST_REC.SHELF_LIFE_VAL, 0) <> 0 THEN
      
      
      
      L_RET_CODE := UNAPIAUT.CALCULATEDELAY(L_ST_REC.SHELF_LIFE_VAL,
                                            L_ST_REC.SHELF_LIFE_UNIT,
                                            L_REF_DATE, L_DELAYED_TILL);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;

      
      
      
      L_TIMED_EVENT_TP := 'ScShelfLifeExceeded';
      L_EV_DETAILS := 'st_version=' || L_ST_TO_VERSION;
      L_RESULT := UNAPIEV.INSERTTIMEDEVENT('CreateSample', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC_TO, '', 
                                           '', '', L_TIMED_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR, 
                                           L_DELAYED_TILL);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
   END IF;

   
   
   
   IF INSTR(A_COPY_IC, 'COPY IIVALUE')<>0 THEN
      
      FOR L_ALLSCIC_REC IN L_ALLSCIC_CURSOR(A_SC_TO) LOOP
         
         
         
         L_SCIC_POS_FOUND := FALSE;
         OPEN L_SCIC_POS_CURSOR(A_SC_FROM, A_SC_TO, L_ALLSCIC_REC.IC);
         LOOP
            FETCH L_SCIC_POS_CURSOR
            INTO L_SCIC_POS_REC;
            IF L_SCIC_POS_REC.IC_TO = L_ALLSCIC_REC.IC AND
               L_SCIC_POS_REC.ICNODE_TO = L_ALLSCIC_REC.ICNODE THEN
               L_SCIC_POS_FOUND := TRUE;
               EXIT;
            END IF;
            EXIT WHEN L_SCIC_POS_CURSOR%NOTFOUND;
         END LOOP;
         CLOSE L_SCIC_POS_CURSOR;

         IF L_SCIC_POS_FOUND AND 
            L_SCIC_POS_REC.IC_FROM IS NOT NULL THEN
            L_RET_CODE := UNAPIIC.COPYSCINFOVALUES(A_SC_FROM, L_SCIC_POS_REC.IC_FROM, 
                                                   L_SCIC_POS_REC.ICNODE_FROM, L_ST_TO, L_ST_TO_VERSION, 
                                                   A_SC_TO, L_SCIC_POS_REC.IC_TO, 
                                                   L_SCIC_POS_REC.ICNODE_TO, A_MODIFY_REASON);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               L_SQLERRM := 'CopyScInfoValues returned='||L_RET_CODE||
                            '#sc_from='||A_SC_FROM||
                            '#ic_from='||L_SCIC_POS_REC.IC_FROM||
                            '#icnode_from='|| L_SCIC_POS_REC.ICNODE_FROM||
                            '#st='||L_ST_TO||
                            '#st_version='||L_ST_TO_VERSION||
                            '#sc_to='||A_SC_TO||
                            '#ic_to='||L_SCIC_POS_REC.IC_TO||
                            '#icnode_to='|| L_SCIC_POS_REC.ICNODE_TO;
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;
            END IF;
         END IF;
      END LOOP;         
   END IF;

   
   IF INSTR(A_COPY_PG, 'COPY PAVALUE')<>0 THEN
      
      FOR L_ALLSCPG_REC IN L_ALLSCPG_CURSOR(A_SC_TO) LOOP
         
         
         
         L_SCPG_POS_FOUND := FALSE;
         OPEN L_SCPG_POS_CURSOR(A_SC_FROM, A_SC_TO, L_ALLSCPG_REC.PG);
         LOOP
            FETCH L_SCPG_POS_CURSOR
            INTO L_SCPG_POS_REC;
            IF L_SCPG_POS_REC.PG_TO = L_ALLSCPG_REC.PG AND
               L_SCPG_POS_REC.PGNODE_TO = L_ALLSCPG_REC.PGNODE THEN
               L_SCPG_POS_FOUND := TRUE;
               EXIT;
            END IF;
            EXIT WHEN L_SCPG_POS_CURSOR%NOTFOUND;
         END LOOP;
         CLOSE L_SCPG_POS_CURSOR;
         
         IF L_SCPG_POS_FOUND AND 
            L_SCPG_POS_REC.PG_FROM IS NOT NULL THEN
            L_RET_CODE := UNAPIPG.COPYSCPGPARESULTS(A_SC_FROM, L_SCPG_POS_REC.PG_FROM, 
                                                    L_SCPG_POS_REC.PGNODE_FROM, L_ST_TO, 
                                                    L_ST_TO_VERSION, A_SC_TO, L_SCPG_POS_REC.PG_TO, 
                                                    L_SCPG_POS_REC.PGNODE_TO, A_MODIFY_REASON);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               L_SQLERRM := 'CopyScPgPaResults returned='||L_RET_CODE||
                            '#sc_from='||A_SC_FROM||
                            '#pg_from='||L_SCPG_POS_REC.PG_FROM||
                            '#pgnode_from='|| L_SCPG_POS_REC.PGNODE_FROM||
                            '#st='||L_ST_TO||
                            '#st_version='||L_ST_TO_VERSION||
                            '#sc_to='||A_SC_TO||
                            '#pg_to='||L_SCPG_POS_REC.PG_TO||
                            '#pgnode_to='|| L_SCPG_POS_REC.PGNODE_TO;
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;
            END IF;   
         END IF;
      END LOOP;         
   END IF;

   
   
   
   
   
   L_EVENT_TP := 'SampleCopied';
   L_EV_DETAILS := 'sc_from=' || A_SC_FROM ||
                   '#st_version=' || L_ST_TO_VERSION;
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('CopySample', UNAPIGEN.P_EVMGR_NAME, 'sc',
                                   A_SC_TO, '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
   VALUES(A_SC_TO, NVL(A_USERID, UNAPIGEN.P_USER), UNAPIGEN.SQLUSERDESCRIPTION(NVL(A_USERID, UNAPIGEN.P_USER)), 
          L_EVENT_TP, 'sc_from='||A_SC_FROM, 
          CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);

   L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
   INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
   VALUES(A_SC_TO, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 'sc_from='||A_SC_FROM);

   IF A_MODIFY_REASON IS NOT NULL THEN
      INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC_TO, NVL(A_USERID, UNAPIGEN.P_USER), UNAPIGEN.SQLUSERDESCRIPTION(NVL(A_USERID, UNAPIGEN.P_USER)), 
             L_EVENT_TP, 'sc_from='||A_SC_FROM, 
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   UNAPIGEN.P_EVMGR_NAME := L_EVMGR_NAME;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CopySample', SQLERRM);
   
   ELSIF L_SQLERRM IS NOT NULL THEN
   
      UNAPIGEN.LOGERROR('CopySample', L_SQLERRM);   
   END IF;
   IF DBMS_SQL.IS_OPEN(L_DATE_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_DATE_CURSOR);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_SC_TO_GK_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_SC_TO_GK_CURSOR);
   END IF;
   IF L_OBJECTS_CURSOR%ISOPEN THEN
      CLOSE L_OBJECTS_CURSOR;
   END IF;
   IF L_SCIC_POS_CURSOR%ISOPEN THEN
      CLOSE L_SCIC_POS_CURSOR;
   END IF;
   IF L_SC_ST_CURSOR%ISOPEN THEN
      CLOSE L_SC_ST_CURSOR;
   END IF;
   IF L_ST_ACTIVE_CURSOR%ISOPEN THEN
      CLOSE L_ST_ACTIVE_CURSOR;
   END IF;
   UNAPIGEN.P_EVMGR_NAME := L_EVMGR_NAME;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'CopySample'));
END COPYSAMPLE;

FUNCTION COPYSCANALYSESDETAILS                         
(A_SC_FROM             IN        VARCHAR2,             
 A_ST_TO               IN        VARCHAR2,             
 A_ST_TO_VERSION       IN OUT    VARCHAR2,              
 A_SC_TO               IN        VARCHAR2,             
 A_COPY_PARAMETERS     IN        CHAR,                 
 A_COPY_METHODS        IN        CHAR,                 
 A_MODIFY_REASON       IN        VARCHAR2)             
RETURN NUMBER IS

L_SC                      UNAPIGEN.VC20_TABLE_TYPE;
L_PG                      UNAPIGEN.VC20_TABLE_TYPE;
L_PGNODE                  UNAPIGEN.LONG_TABLE_TYPE;
L_PP_VERSION              UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY1                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY2                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY3                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY4                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY5                 UNAPIGEN.VC20_TABLE_TYPE;
L_DESCRIPTION             UNAPIGEN.VC40_TABLE_TYPE;
L_VALUE_F                 UNAPIGEN.FLOAT_TABLE_TYPE;
L_VALUE_S                 UNAPIGEN.VC40_TABLE_TYPE;
L_UNIT                    UNAPIGEN.VC20_TABLE_TYPE;
L_EXEC_START_DATE         UNAPIGEN.DATE_TABLE_TYPE;
L_EXEC_END_DATE           UNAPIGEN.DATE_TABLE_TYPE;
L_EXECUTOR                UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EXECUTOR        UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ENTERED        UNAPIGEN.CHAR1_TABLE_TYPE;
L_ASSIGN_DATE             UNAPIGEN.DATE_TABLE_TYPE;
L_ASSIGNED_BY             UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ADDED          UNAPIGEN.CHAR1_TABLE_TYPE;
L_FORMAT                  UNAPIGEN.VC40_TABLE_TYPE;
L_CONFIRM_ASSIGN          UNAPIGEN.CHAR1_TABLE_TYPE;
L_ALLOW_ANY_PR            UNAPIGEN.CHAR1_TABLE_TYPE;
L_NEVER_CREATE_METHODS    UNAPIGEN.CHAR1_TABLE_TYPE;
L_DELAY                   UNAPIGEN.NUM_TABLE_TYPE;
L_DELAY_UNIT              UNAPIGEN.VC20_TABLE_TYPE;
L_REANALYSIS              UNAPIGEN.NUM_TABLE_TYPE;
L_PG_CLASS                UNAPIGEN.VC2_TABLE_TYPE;
L_LOG_HS                  UNAPIGEN.CHAR1_TABLE_TYPE;
L_LOG_HS_DETAILS          UNAPIGEN.CHAR1_TABLE_TYPE;
L_LC                      UNAPIGEN.VC2_TABLE_TYPE;
L_LC_VERSION              UNAPIGEN.VC20_TABLE_TYPE;
L_MODIFY_FLAG             UNAPIGEN.NUM_TABLE_TYPE;
L_NR_OF_ROWS              NUMBER;
L_ERRM                    VARCHAR2(255);
L_SEQ                     NUMBER(5);
L_LOG_HS_SC               CHAR(1);
L_LOG_HS_DETAILS_SC       CHAR(1);
L_HS_DETAILS_SEQ_NR       INTEGER;

CURSOR L_SCPG_CURSOR(A_SC VARCHAR2) IS
   SELECT *
   FROM UTSCPG
   WHERE SC = A_SC
   ORDER BY PGNODE;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   IF NVL(A_SC_FROM, ' ') = ' ' OR
      NVL(A_ST_TO, ' ') = ' ' OR
      NVL(A_SC_TO, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_ERRM := NULL;

   
   
   
   L_NR_OF_ROWS := 0;
   FOR L_SCPG_REC IN L_SCPG_CURSOR(A_SC_FROM) LOOP
      L_NR_OF_ROWS := L_NR_OF_ROWS + 1;
      L_SC(L_NR_OF_ROWS) := A_SC_TO;
      L_PG(L_NR_OF_ROWS) := L_SCPG_REC.PG;
      L_PGNODE(L_NR_OF_ROWS) := L_SCPG_REC.PGNODE;
      L_PP_VERSION(L_NR_OF_ROWS) := L_SCPG_REC.PP_VERSION;
      L_PP_KEY1(L_NR_OF_ROWS) := L_SCPG_REC.PP_KEY1;
      L_PP_KEY2(L_NR_OF_ROWS) := L_SCPG_REC.PP_KEY2;
      L_PP_KEY3(L_NR_OF_ROWS) := L_SCPG_REC.PP_KEY3;
      L_PP_KEY4(L_NR_OF_ROWS) := L_SCPG_REC.PP_KEY4;
      L_PP_KEY5(L_NR_OF_ROWS) := L_SCPG_REC.PP_KEY5;
      L_DESCRIPTION(L_NR_OF_ROWS) := L_SCPG_REC.DESCRIPTION;      
      L_UNIT(L_NR_OF_ROWS) := L_SCPG_REC.UNIT;      
      L_PLANNED_EXECUTOR(L_NR_OF_ROWS) := L_SCPG_REC.PLANNED_EXECUTOR;
      L_FORMAT(L_NR_OF_ROWS) := L_SCPG_REC.FORMAT;
      L_CONFIRM_ASSIGN(L_NR_OF_ROWS) := L_SCPG_REC.CONFIRM_ASSIGN;
      L_ALLOW_ANY_PR(L_NR_OF_ROWS) := L_SCPG_REC.ALLOW_ANY_PR;      
      L_NEVER_CREATE_METHODS(L_NR_OF_ROWS) := L_SCPG_REC.NEVER_CREATE_METHODS;
      L_DELAY(L_NR_OF_ROWS) := L_SCPG_REC.DELAY;
      L_DELAY_UNIT(L_NR_OF_ROWS) := L_SCPG_REC.DELAY_UNIT;      
      L_REANALYSIS(L_NR_OF_ROWS) := 0;      
      L_PG_CLASS(L_NR_OF_ROWS) := L_SCPG_REC.PG_CLASS;
      L_LOG_HS(L_NR_OF_ROWS) := L_SCPG_REC.LOG_HS;
      L_LOG_HS_DETAILS(L_NR_OF_ROWS) := L_SCPG_REC.LOG_HS_DETAILS;
      L_LC(L_NR_OF_ROWS) := L_SCPG_REC.LC;
      L_LC_VERSION(L_NR_OF_ROWS) := L_SCPG_REC.LC_VERSION;

      L_VALUE_F(L_NR_OF_ROWS) := NULL;
      L_VALUE_S(L_NR_OF_ROWS) := NULL;
      L_EXEC_START_DATE(L_NR_OF_ROWS) := NULL;
      L_EXEC_END_DATE(L_NR_OF_ROWS) := NULL;
      
      
      IF NVL(A_COPY_METHODS,'0') = '1' THEN
         
         L_EXECUTOR(L_NR_OF_ROWS) := NULL;
      ELSE
         IF L_SCPG_REC.EXECUTOR IS NULL THEN
            
            L_EXECUTOR(L_NR_OF_ROWS) := NULL;
         ELSE
            
            L_EXECUTOR(L_NR_OF_ROWS) := UNAPIGEN.P_USER;
         END IF;
      END IF;
      
      L_MANUALLY_ENTERED(L_NR_OF_ROWS) := '0';
      L_MANUALLY_ADDED(L_NR_OF_ROWS) := '0';
      L_ASSIGN_DATE(L_NR_OF_ROWS) := CURRENT_TIMESTAMP;
      L_ASSIGNED_BY(L_NR_OF_ROWS) := UNAPIGEN.P_USER;
      L_MODIFY_FLAG(L_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES;
   END LOOP;

   
   
   
   IF L_NR_OF_ROWS > 0 THEN
      L_RET_CODE := UNAPIPG.SAVESCPARAMETERGROUP(L_SC, L_PG, L_PGNODE, L_PP_VERSION, 
                       L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5,
                       L_DESCRIPTION, L_VALUE_F, L_VALUE_S, L_UNIT, L_EXEC_START_DATE, 
                       L_EXEC_END_DATE, L_EXECUTOR, L_PLANNED_EXECUTOR,
                       L_MANUALLY_ENTERED, L_ASSIGN_DATE, L_ASSIGNED_BY, 
                       L_MANUALLY_ADDED, L_FORMAT, L_CONFIRM_ASSIGN, L_ALLOW_ANY_PR, 
                       L_NEVER_CREATE_METHODS, L_DELAY, L_DELAY_UNIT, L_PG_CLASS, 
                       L_LOG_HS, L_LOG_HS_DETAILS, L_LC, L_LC_VERSION, 
                       L_MODIFY_FLAG, L_NR_OF_ROWS, A_MODIFY_REASON);
      IF L_RET_CODE = UNAPIGEN.DBERR_PARTIALSAVE THEN
         
         
         
         FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
            IF L_MODIFY_FLAG(L_ROW) > UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_MODIFY_FLAG(L_ROW);
               L_ERRM  := 'sc=' || A_SC_TO || 
                          '#pg=' || L_PG(L_ROW) ||
                          '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW))||
                          '#SaveScParameterGroup#ErrorCode=' || TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            END IF;
         END LOOP;
      ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

   
   
   
   
   INSERT INTO UTSCPGAU (SC, PG, PGNODE, AU, AUSEQ, VALUE)
   SELECT A_SC_TO, PG, PGNODE, AU, AUSEQ, VALUE
   FROM UTSCPGAU
   WHERE SC = A_SC_FROM;

   IF NVL(A_COPY_PARAMETERS,'0') = '1' THEN
      FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
         
         
         
         
         
         
         L_RET_CODE := UNAPIPG.COPYSCPGDETAILS(A_SC_FROM, L_PG(L_ROW), L_PGNODE(L_ROW), A_ST_TO, 
                                               A_ST_TO_VERSION, L_SC(L_ROW), L_PG(L_ROW), 
                                               L_PGNODE(L_ROW), A_COPY_METHODS, A_MODIFY_REASON);
         
         
         
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_ERRM := 'sc_from=' || A_SC_FROM|| 
                      '#pg_from=' || L_PG(L_ROW) ||
                      '#pgnode_from=' || TO_CHAR(L_PGNODE(L_ROW)) ||
                      '#row='|| TO_CHAR(L_ROW) ||
                      '#sc_to='|| L_SC(L_ROW) ||
                      '#pg=' || L_PG(L_ROW) ||
                      '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW)) ||
                      '#copy_me=' || A_COPY_METHODS ||
                      '#CopyScPgDetails#ErrorCode=' || TO_CHAR(L_RET_CODE);
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END LOOP;
   END IF;

   
   
   
   L_EV_SEQ_NR := -1;
   L_EVENT_TP := 'ScAnalysesCreated';
   L_EV_DETAILS := 'st=' || A_ST_TO ||
                   '#st_version=' || A_ST_TO_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('CopyScAnalysesDetails', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC_TO, '', 
                                   '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   BEGIN
      SELECT LOG_HS, LOG_HS_DETAILS
      INTO L_LOG_HS_SC, L_LOG_HS_DETAILS_SC
      FROM UTSC
      WHERE SC = A_SC_TO;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END;

   IF NVL(L_LOG_HS_SC, ' ') = '1' THEN
      INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, 
                         WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_SC_TO, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'sample "'||A_SC_TO||'" analysis details are created.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;
   
   L_HS_DETAILS_SEQ_NR := 0;
   IF NVL(L_LOG_HS_DETAILS_SC, ' ') = '1' THEN
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES (A_SC_TO, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
              'sample "'||A_SC_TO||'" analysis details are created.');
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CopyScAnalysesDetails', SQLERRM);
   ELSIF L_ERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('CopyScAnalysesDetails', L_ERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CopyScAnalysesDetails'));
END COPYSCANALYSESDETAILS;

FUNCTION CHANGESCSAMPLETYPE                            
(A_SC               IN     VARCHAR2,                   
 A_ST               IN     VARCHAR2,                   
 A_ST_VERSION       IN OUT VARCHAR2,                   
 A_MODIFY_REASON    IN     VARCHAR2)                   
RETURN NUMBER IS

L_OLD_ST               VARCHAR2(20);
L_ST_VERSION           VARCHAR2(20);
L_OLD_ST_VERSION       VARCHAR2(20);
L_DESCRIPTION          VARCHAR2(40);
L_OLD_DESCRIPTION      VARCHAR2(40);
L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_SS                   VARCHAR2(2);
L_LOG_HS               CHAR(1);
L_LOG_HS_DETAILS       CHAR(1);
L_ALLOW_MODIFY         CHAR(1);
L_ACTIVE               CHAR(1);
L_HS_DETAILS_SEQ_NR    INTEGER;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;
   
   L_ST_VERSION := UNAPIGEN.VALIDATEVERSION('st',A_ST,A_ST_VERSION);

   L_RET_CODE := UNAPIAUT.GETSCAUTHORISATION(A_SC, L_OLD_ST_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   SELECT ST, DESCRIPTION
   INTO L_OLD_ST, L_OLD_DESCRIPTION
   FROM UTSC
   WHERE SC = A_SC;

   BEGIN
      SELECT DESCRIPTION
      INTO L_DESCRIPTION
      FROM UTST
      WHERE ST = A_ST
        AND VERSION = L_ST_VERSION;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      L_DESCRIPTION := NULL;
   END;
   
   UPDATE UTSC
   SET ST = A_ST,
       ST_VERSION = L_ST_VERSION,
       DESCRIPTION = L_DESCRIPTION
   WHERE SC = A_SC;
   
   L_RET_CODE := UNAPISC.UPDATELINKEDSCII
                    (A_SC, 'st', '0', A_ST, L_ST_VERSION, '',
                    '', '', '',
                    '', '', '',
                    '', '', '',
                    '', '', '', '',
                    '', '', '', '', '',
                    '', '');
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
   
   L_RET_CODE := UNAPISC.UPDATELINKEDSCII
                    (A_SC, 'description', '0', '', '', L_DESCRIPTION,
                    '', '', '',
                    '', '', '',
                    '', '', '',
                    '', '', '', '',
                    '', '', '', '', '',
                    '', '');
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
   
   L_EVENT_TP := 'ScSampleTypeChanged';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'st_from=' || L_OLD_ST ||
                   '#st_from_version=' || L_OLD_ST_VERSION ||
                   '#st=' || A_ST ||
                   '#st_version=' || L_ST_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('ChangeScSampleType', UNAPIGEN.P_EVMGR_NAME, 'sc', A_SC, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF NVL(L_LOG_HS, ' ') = '1' THEN
      IF NVL((L_OLD_ST <> A_ST), TRUE) AND NOT(L_OLD_ST IS NULL AND A_ST IS NULL) THEN 
         INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'sample "'||A_SC||'" is updated: property <st> changed value from "'||L_OLD_ST||'" to "'||A_ST||'".', 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
      IF NVL((L_OLD_ST_VERSION <> L_ST_VERSION), TRUE) AND NOT(L_OLD_ST_VERSION IS NULL AND L_ST_VERSION IS NULL) THEN 
         INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'sample "'||A_SC||'" is updated: property <st_version> changed value from "'||L_OLD_ST_VERSION||'" to "'||L_ST_VERSION||'".', 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
      IF NVL((L_OLD_DESCRIPTION <> L_DESCRIPTION), TRUE) AND NOT(L_OLD_DESCRIPTION IS NULL AND L_DESCRIPTION IS NULL) THEN 
         INSERT INTO UTSCHS(SC, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'sample "'||A_SC||'" is updated: property <description> changed value from "'||L_OLD_DESCRIPTION||'" to "'||L_DESCRIPTION||'".', 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   END IF;

   L_HS_DETAILS_SEQ_NR := 0;
   IF NVL(L_LOG_HS_DETAILS, ' ') = '1' THEN
      IF NVL((L_OLD_ST <> A_ST), TRUE) AND NOT(L_OLD_ST IS NULL AND A_ST IS NULL) THEN 
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'sample "'||A_SC||'" is updated: property <st> changed value from "'||L_OLD_ST||'" to "'||A_ST||'".');
      END IF;
      IF NVL((L_OLD_ST_VERSION <> L_ST_VERSION), TRUE) AND NOT(L_OLD_ST_VERSION IS NULL AND L_ST_VERSION IS NULL) THEN 
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'sample "'||A_SC||'" is updated: property <st_version> changed value from "'||L_OLD_ST_VERSION||'" to "'||L_ST_VERSION||'".');
      END IF;
      IF NVL((L_OLD_DESCRIPTION <> L_DESCRIPTION), TRUE) AND NOT(L_OLD_DESCRIPTION IS NULL AND L_DESCRIPTION IS NULL) THEN 
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCHSDETAILS(SC, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'sample "'||A_SC||'" is updated: property <description> changed value from "'||L_OLD_DESCRIPTION||'" to "'||L_DESCRIPTION||'".');
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ChangeScSampleType', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ChangeScSampleType'));
END CHANGESCSAMPLETYPE;

FUNCTION UPDATELINKEDSCII                     
(A_SC                  IN     VARCHAR2,       
 A_SC_STD_PROPERTY     IN     VARCHAR2,       
 A_SC_CREATION         IN     CHAR,           
 A_ST                  IN     VARCHAR2,       
 A_ST_VERSION          IN     VARCHAR2,       
 A_DESCRIPTION         IN     VARCHAR2,       
 A_SHELF_LIFE_VAL      IN     NUMBER,         
 A_SHELF_LIFE_UNIT     IN     VARCHAR2,       
 A_SAMPLING_DATE       IN     DATE,           
 A_CREATION_DATE       IN     DATE,           
 A_CREATED_BY          IN     VARCHAR2,       
 A_EXEC_START_DATE     IN     DATE,           
 A_EXEC_END_DATE       IN     DATE,           
 A_PRIORITY            IN     NUMBER,         
 A_LABEL_FORMAT        IN     VARCHAR2,       
 A_DESCR_DOC           IN     VARCHAR2,       
 A_DESCR_DOC_VERSION   IN     VARCHAR2,       
 A_RQ                  IN     VARCHAR2,       
 A_SD                  IN     VARCHAR2,       
 A_DATE1               IN     DATE,           
 A_DATE2               IN     DATE,           
 A_DATE3               IN     DATE,           
 A_DATE4               IN     DATE,           
 A_DATE5               IN     DATE,           
 A_ALLOW_ANY_PP        IN     CHAR,           
 A_SC_CLASS            IN     VARCHAR2)       
RETURN NUMBER IS

L_UPDATE              BOOLEAN;
L_ENTER_LOOP          BOOLEAN;
L_SC_STD_PROPERTY     VARCHAR2(2000);
L_IIVALUE_F           NUMBER;
L_IIVALUE_S           VARCHAR2(40);
L_ERRM                VARCHAR2(255);
L_DATEVALID           VARCHAR2(80);
L_II_LOG_HS           CHAR(1);
L_II_LOG_HS_DETAILS   CHAR(1);
L_IC_LOG_HS           CHAR(1);
L_IC_LOG_HS_DETAILS   CHAR(1);
L_HS_DETAILS_SEQ_NR   INTEGER;
L_PREV_RQ             VARCHAR2(20);
L_PREV_IC             VARCHAR2(20);
L_PREV_ICNODE         NUMBER;
L_SAMPLING_DATE       TIMESTAMP WITH TIME ZONE;
L_CREATION_DATE       TIMESTAMP WITH TIME ZONE;
L_EXEC_START_DATE     TIMESTAMP WITH TIME ZONE;
L_EXEC_END_DATE       TIMESTAMP WITH TIME ZONE;
L_DATE1               TIMESTAMP WITH TIME ZONE;
L_DATE2               TIMESTAMP WITH TIME ZONE;
L_DATE3               TIMESTAMP WITH TIME ZONE;
L_DATE4               TIMESTAMP WITH TIME ZONE;
L_DATE5               TIMESTAMP WITH TIME ZONE;




CURSOR L_SCII_CURSOR(A_SC VARCHAR2, A_SC_STD_PROPERTY VARCHAR2) IS
   SELECT SCII.*, IE.IEVALUE, IE.FORMAT, IE.DATA_TP
   FROM UTSCII SCII, UTSCIC SCIC, UTIE IE
   WHERE SCII.SC = A_SC
     AND SCII.SC = SCIC.SC
     AND SCII.IC = SCIC.IC
     AND SCII.ICNODE = SCIC.ICNODE
     AND SCII.II = IE.IE
     AND SCII.IE_VERSION = IE.VERSION
     AND IE.DEF_VAL_TP = 'S'
     AND IE.IEVALUE = NVL(A_SC_STD_PROPERTY, IE.IEVALUE)
     AND (IE.IE, IE.VERSION) NOT IN 
        (SELECT C.IE, UNAPIGEN.VALIDATEVERSION('ie', C.IE, C.IE_VERSION) IE_VERSION
         FROM UTIPIE C
         WHERE C.IP = SCII.IC
           AND C.VERSION = SCIC.IP_VERSION
           AND C.IE = SCII.II
           AND UNAPIGEN.VALIDATEVERSION('ie', C.IE, C.IE_VERSION) = SCII.IE_VERSION
           AND (C.DEF_VAL_TP<>'F' OR C.IEVALUE IS NOT NULL))
   UNION 
 SELECT SCII.*, IPIE.IEVALUE, IE.FORMAT, IE.DATA_TP
   FROM UTSCII SCII, UTSCIC SCIC, UTIPIE IPIE, UTIE IE
   WHERE SCII.SC = A_SC
     AND SCII.SC = SCIC.SC
     AND SCII.IC = SCIC.IC
     AND SCII.ICNODE = SCIC.ICNODE
     AND SCIC.IC = IPIE.IP
     AND SCIC.IP_VERSION = IPIE.VERSION
     AND SCII.II = IE.IE
     AND SCII.IE_VERSION = IE.VERSION
     AND IPIE.IE = IE.IE
     AND UNAPIGEN.VALIDATEVERSION('ie', IPIE.IE, IPIE.IE_VERSION) = IE.VERSION
     AND IPIE.DEF_VAL_TP = 'S'
     AND IPIE.IEVALUE = NVL(A_SC_STD_PROPERTY, IPIE.IEVALUE);

CURSOR L_SCIIOLD_CURSOR (A_SC IN VARCHAR2, 
                         A_IC IN VARCHAR2, A_ICNODE IN NUMBER,
                         A_II IN VARCHAR2, A_IINODE IN NUMBER) IS
   SELECT A.*
   FROM UDSCII A
   WHERE A.SC = A_SC
     AND A.IC = A_IC
     AND A.ICNODE = A_ICNODE
     AND A.II = A_II
     AND A.IINODE = A_IINODE;
L_SCIIOLD_REC UDSCII%ROWTYPE;
L_SCIINEW_REC UDSCII%ROWTYPE;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   
   
   
   L_ENTER_LOOP := FALSE;
   L_HS_DETAILS_SEQ_NR := 0;
   L_PREV_RQ := NULL;
   L_PREV_IC := NULL;
   L_PREV_ICNODE := NULL;

   L_SAMPLING_DATE := A_SAMPLING_DATE;
   L_CREATION_DATE := A_CREATION_DATE;
   L_EXEC_START_DATE := A_EXEC_START_DATE;
   L_EXEC_END_DATE := A_EXEC_END_DATE;
   L_DATE1 := A_DATE1;
   L_DATE2 := A_DATE2;
   L_DATE3 := A_DATE3;
   L_DATE4 := A_DATE4;
   L_DATE5 := A_DATE5;

   FOR L_SCII_REC IN L_SCII_CURSOR(A_SC, A_SC_STD_PROPERTY) LOOP

      L_ENTER_LOOP := TRUE;
      L_UPDATE := TRUE;
      IF L_SCII_REC.IEVALUE = 'sc' THEN
         L_SC_STD_PROPERTY := A_SC;
      ELSIF L_SCII_REC.IEVALUE = 'st' THEN
         IF A_SC_CREATION = '1' THEN
            L_UPDATE := FALSE;
         ELSE
            L_SC_STD_PROPERTY := A_ST;
         END IF;
      ELSIF L_SCII_REC.IEVALUE = 'description' THEN
         L_SC_STD_PROPERTY := A_DESCRIPTION;
      ELSIF L_SCII_REC.IEVALUE = 'shelf_life_val' THEN
         L_SC_STD_PROPERTY := A_SHELF_LIFE_VAL;
      ELSIF L_SCII_REC.IEVALUE = 'shelf_life_unit' THEN
         L_SC_STD_PROPERTY := A_SHELF_LIFE_UNIT;
      ELSIF L_SCII_REC.IEVALUE = 'sampling_date' THEN
         L_SC_STD_PROPERTY := TO_CHAR(L_SAMPLING_DATE, SUBSTR(L_SCII_REC.FORMAT,2));
      ELSIF L_SCII_REC.IEVALUE = 'creation_date' THEN
         L_SC_STD_PROPERTY := TO_CHAR(L_CREATION_DATE, SUBSTR(L_SCII_REC.FORMAT,2));
      ELSIF L_SCII_REC.IEVALUE = 'created_by' THEN
         L_SC_STD_PROPERTY := A_CREATED_BY;
      ELSIF L_SCII_REC.IEVALUE = 'exec_start_date' THEN
         L_SC_STD_PROPERTY := TO_CHAR(L_EXEC_START_DATE, SUBSTR(L_SCII_REC.FORMAT,2));
      ELSIF L_SCII_REC.IEVALUE = 'exec_end_date' THEN
         L_SC_STD_PROPERTY := TO_CHAR(L_EXEC_END_DATE, SUBSTR(L_SCII_REC.FORMAT,2));
      ELSIF L_SCII_REC.IEVALUE = 'priority' THEN
         L_SC_STD_PROPERTY := A_PRIORITY;
      ELSIF L_SCII_REC.IEVALUE = 'label_format' THEN
         L_SC_STD_PROPERTY := A_LABEL_FORMAT;
      ELSIF L_SCII_REC.IEVALUE = 'descr_doc' THEN
         L_SC_STD_PROPERTY := A_DESCR_DOC;
      ELSIF L_SCII_REC.IEVALUE = 'rq' THEN
         L_SC_STD_PROPERTY := A_RQ;
      ELSIF L_SCII_REC.IEVALUE = 'sd' THEN
         L_SC_STD_PROPERTY := A_SD;
      ELSIF L_SCII_REC.IEVALUE = 'date1' THEN
         L_SC_STD_PROPERTY := TO_CHAR(L_DATE1, SUBSTR(L_SCII_REC.FORMAT,2));
      ELSIF L_SCII_REC.IEVALUE = 'date2' THEN
         L_SC_STD_PROPERTY := TO_CHAR(L_DATE2, SUBSTR(L_SCII_REC.FORMAT,2));
      ELSIF L_SCII_REC.IEVALUE = 'date3' THEN
         L_SC_STD_PROPERTY := TO_CHAR(L_DATE3, SUBSTR(L_SCII_REC.FORMAT,2));
      ELSIF L_SCII_REC.IEVALUE = 'date4' THEN
         L_SC_STD_PROPERTY := TO_CHAR(L_DATE4, SUBSTR(L_SCII_REC.FORMAT,2));
      ELSIF L_SCII_REC.IEVALUE = 'date5' THEN
         L_SC_STD_PROPERTY := TO_CHAR(L_DATE5, SUBSTR(L_SCII_REC.FORMAT,2));
      ELSIF L_SCII_REC.IEVALUE = 'allow_any_pp' THEN
         L_SC_STD_PROPERTY := A_ALLOW_ANY_PP;
      ELSIF L_SCII_REC.IEVALUE = 'sc_class' THEN
         L_SC_STD_PROPERTY := A_SC_CLASS;
      ELSE
         L_SQLERRM := L_SCII_REC.IEVALUE || ' is not a valid sample standard property for info field '||L_SCII_REC.II||
                      ' in info profile '||L_SCII_REC.IC ||' sc=' ||L_SCII_REC.SC || '#icnode=' ||
                            TO_CHAR(L_SCII_REC.ICNODE) || '#iinode=' || TO_CHAR(L_SCII_REC.IINODE);
         RAISE STPERROR;
      END IF;

      
      
      
      IF L_SCII_REC.DATA_TP = 'A' THEN                      
         
         IF SUBSTR(L_SCII_REC.FORMAT,1,1)='C' THEN
            IF LENGTH(L_SCII_REC.FORMAT)>1 THEN
               L_SC_STD_PROPERTY := SUBSTR(L_SC_STD_PROPERTY,1,SUBSTR(L_SCII_REC.FORMAT,2));
            ELSE
               NULL;
            END IF;
         
         ELSIF SUBSTR(L_SCII_REC.FORMAT,1,1)='D' THEN
            L_DATEVALID := L_SC_STD_PROPERTY||'@'||SUBSTR(L_SCII_REC.FORMAT,2);
            L_RET_CODE := UNAPIGEN.DATEVALID(L_DATEVALID, L_ERRM);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                      'UpdateLinkedScii',
                      'Warning#DateValid returned '||L_RET_CODE || ' for info field '||L_SCII_REC.II||
                      ' with value '||L_SC_STD_PROPERTY||'@'||SUBSTR(L_SCII_REC.FORMAT,2) );
            END IF;
         ELSE
            L_IIVALUE_F := NULL;
            BEGIN
               L_IIVALUE_F := TO_NUMBER(L_SC_STD_PROPERTY);
            EXCEPTION
            WHEN VALUE_ERROR THEN
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                      'UpdateLinkedScii', 
                      'Warning#Value could not be converted to a float for info field '||L_SCII_REC.II||
                      ' using format '||L_SCII_REC.FORMAT||' with value '||L_SC_STD_PROPERTY);
            END;
            L_IIVALUE_S := '';
            L_RET_CODE := UNAPIGEN.FORMATRESULT(L_IIVALUE_F, L_SCII_REC.FORMAT, L_IIVALUE_S);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
                      'UpdateLinkedScii',
                      'Warning#FormatResult returned '||L_RET_CODE || ' for info field '||L_SCII_REC.II||
                      ' using format '||L_SCII_REC.FORMAT||' with value '||L_SC_STD_PROPERTY );
            END IF;
           L_SC_STD_PROPERTY := L_IIVALUE_S;         
         END IF;
      ELSIF L_SCII_REC.DATA_TP IN ('D','M') THEN            
         L_DATEVALID := L_SC_STD_PROPERTY||'@'||SUBSTR(L_SCII_REC.FORMAT,2);
         L_RET_CODE := UNAPIGEN.DATEVALID(L_DATEVALID, L_ERRM);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'UpdateLinkedScii',
                   'Warning#DateValid returned '||L_RET_CODE || ' for info field '||L_SCII_REC.II||
                   ' with value '||L_SC_STD_PROPERTY||'@'||SUBSTR(L_SCII_REC.FORMAT,2) );
         END IF;   
      ELSIF L_SCII_REC.DATA_TP IN ('I','F') THEN            
         L_IIVALUE_F := NULL;
         BEGIN
            L_IIVALUE_F := TO_NUMBER(L_SC_STD_PROPERTY);
         EXCEPTION
         WHEN VALUE_ERROR THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'UpdateLinkedScii', 
                   'Warning#Value could not be converted to a float for info field '||L_SCII_REC.II||
                   ' using format '||L_SCII_REC.FORMAT||' with value '||L_SC_STD_PROPERTY);
         END;
         L_IIVALUE_S := '';
         L_RET_CODE := UNAPIGEN.FORMATRESULT(L_IIVALUE_F, L_SCII_REC.FORMAT, L_IIVALUE_S);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                      'UpdateLinkedScii', 
                      'Warning#FormatResult returned '||L_RET_CODE || ' for info field '||L_SCII_REC.II||
                      ' using format '||L_SCII_REC.FORMAT||' with value '||L_SC_STD_PROPERTY );
         END IF;
         L_SC_STD_PROPERTY := L_IIVALUE_S;         
      END IF;
      
      IF L_UPDATE THEN
         
         
         
         OPEN L_SCIIOLD_CURSOR(L_SCII_REC.SC, 
                               L_SCII_REC.IC, L_SCII_REC.ICNODE,
                               L_SCII_REC.II, L_SCII_REC.IINODE);
         FETCH L_SCIIOLD_CURSOR
         INTO L_SCIIOLD_REC;
         CLOSE L_SCIIOLD_CURSOR;
         L_SCIINEW_REC := L_SCIIOLD_REC;

         
         
         
         UPDATE UTSCII 
         SET IIVALUE = L_SC_STD_PROPERTY
         WHERE SC     = L_SCII_REC.SC 
           AND IC     = L_SCII_REC.IC 
           AND ICNODE = L_SCII_REC.ICNODE
           AND II     = L_SCII_REC.II 
           AND IINODE = L_SCII_REC.IINODE
         RETURNING IIVALUE, LOG_HS, LOG_HS_DETAILS
         INTO L_SCIINEW_REC.IIVALUE, L_II_LOG_HS, L_II_LOG_HS_DETAILS;

         BEGIN
            SELECT LOG_HS, LOG_HS_DETAILS
            INTO L_IC_LOG_HS, L_IC_LOG_HS_DETAILS
            FROM UTSCIC
            WHERE SC     = L_SCII_REC.SC 
              AND IC     = L_SCII_REC.IC 
              AND ICNODE = L_SCII_REC.ICNODE;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
            RAISE STPERROR;
         END;

         
         
         
         L_EV_SEQ_NR := -1;
         L_EVENT_TP  := 'InfoFieldValueChanged';
         L_EV_DETAILS := 'sc=' || A_SC || 
                         '#ic=' || L_SCII_REC.IC ||
                         '#icnode=' || TO_CHAR(L_SCII_REC.ICNODE) || 
                         '#iinode=' || TO_CHAR(L_SCII_REC.IINODE) || 
                         '#old_value=' || SUBSTR(L_SCIIOLD_REC.IIVALUE,1,40) || 
                         '#new_value=' || SUBSTR(L_SCIINEW_REC.IIVALUE,1,40) ||
                         '#ie_version=' || L_SCII_REC.IE_VERSION;
         L_RESULT := UNAPIEV.INSERTINFOFIELDEVENT('SaveScIiValue', UNAPIGEN.P_EVMGR_NAME,
                                                  'ii', L_SCII_REC.II, L_SCII_REC.LC, L_SCII_REC.LC_VERSION, L_SCII_REC.SS,
                                                  L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
         END IF;

         IF L_EV_SEQ_NR = -1 THEN
            L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
            IF L_RET_CODE <> 0 THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;
            END IF;
         END IF;

         IF NVL(L_II_LOG_HS, ' ') = '1' THEN
            L_EVENT_TP := 'InfoFieldValueChanged';
            INSERT INTO UTSCICHS(SC, IC, ICNODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
                                 LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC, L_SCII_REC.IC, L_SCII_REC.ICNODE, UNAPIGEN.P_USER, 
                   UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                   'info field "'||L_SCII_REC.II||'" is updated.',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);

            IF NVL((L_SCIIOLD_REC.IIVALUE <> L_SCIINEW_REC.IIVALUE), TRUE) AND NOT(L_SCIIOLD_REC.IIVALUE IS NULL AND L_SCIINEW_REC.IIVALUE IS NULL)  THEN 
               INSERT INTO UTSCICHS(SC, IC, ICNODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
                                    LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
               VALUES(A_SC, L_SCII_REC.IC, L_SCII_REC.ICNODE, UNAPIGEN.P_USER, 
                      UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                      'info field "'||L_SCII_REC.II||'" is updated: property <iivalue> changed value from "'||SUBSTR(L_SCIIOLD_REC.IIVALUE,1,40)||'" to "'||SUBSTR(L_SCIINEW_REC.IIVALUE,1,40)||'".',
                      CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
            END IF;
         END IF;
                  
         IF NVL(L_IC_LOG_HS, ' ') = '1' THEN
            L_EVENT_TP  := 'InfoFieldValuesChanged';
            INSERT INTO UTSCICHS(SC, IC, ICNODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
                                 LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC, L_SCII_REC.IC, L_SCII_REC.ICNODE, UNAPIGEN.P_USER, 
                   UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                   'info card "'||L_SCII_REC.IC||'" info field values are updated.',
                   CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         END IF;

         IF NVL(L_II_LOG_HS_DETAILS, ' ') = '1' THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCICHSDETAILS(SC, IC, ICNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC, L_SCII_REC.IC, L_SCII_REC.ICNODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, 
                   L_HS_DETAILS_SEQ_NR, 'info field "'||L_SCII_REC.II||'" is updated.');
                   
            UNAPIHSDETAILS.ADDSCIIHSDETAILS(L_SCIIOLD_REC, L_SCIINEW_REC, UNAPIGEN.P_TR_SEQ, 
                                            L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR); 
         END IF;
         
         IF NVL(L_IC_LOG_HS_DETAILS, ' ') = '1' THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCICHSDETAILS(SC, IC, ICNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC, L_SCII_REC.IC, L_SCII_REC.ICNODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, 
                   L_HS_DETAILS_SEQ_NR, 'info card "'||L_SCII_REC.IC||'" info field values are updated.');
         END IF;
      END IF;
   END LOOP;
      
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('UpdateLinkedScii', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('UpdateLinkedScii', L_SQLERRM);   
   END IF;
   IF L_SCIIOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCIIOLD_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'UpdateLinkedScii'));
END UPDATELINKEDSCII;

FUNCTION GETSAMPLE                                        
(A_SC                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_ST                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_ST_VERSION          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCRIPTION         OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_SHELF_LIFE_VAL      OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_SHELF_LIFE_UNIT     OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SAMPLING_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_CREATION_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_CREATED_BY          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_EXEC_START_DATE     OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXEC_END_DATE       OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_PRIORITY            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_LABEL_FORMAT        OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCR_DOC           OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCR_DOC_VERSION   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_RQ                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SD                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DATE1               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE2               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE3               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE4               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_DATE5               OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_ALLOW_ANY_PP        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SC_CLASS            OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LOG_HS              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LOG_HS_DETAILS      OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ALLOW_MODIFY        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_AR                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ACTIVE              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LC                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LC_VERSION          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SS                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_NR_OF_ROWS          IN OUT  NUMBER,                    
 A_WHERE_CLAUSE        IN      VARCHAR2)                  
RETURN NUMBER IS

L_SC                             VARCHAR2(20);
L_ST                             VARCHAR2(20);
L_ST_VERSION                     VARCHAR2(20);
L_DESCRIPTION                    VARCHAR2(40);
L_SHELF_LIFE_VAL                 NUMBER(3);
L_SHELF_LIFE_UNIT                VARCHAR2(20);
L_SAMPLING_DATE                  TIMESTAMP WITH TIME ZONE;
L_CREATION_DATE                  TIMESTAMP WITH TIME ZONE;
L_CREATED_BY                     VARCHAR2(20);
L_EXEC_START_DATE                TIMESTAMP WITH TIME ZONE;
L_EXEC_END_DATE                  TIMESTAMP WITH TIME ZONE;
L_PRIORITY                       NUMBER(3);
L_LABEL_FORMAT                   VARCHAR2(20);
L_DESCR_DOC                      VARCHAR2(40);
L_DESCR_DOC_VERSION              VARCHAR2(20);
L_RQ                             VARCHAR2(20);
L_SD                             VARCHAR2(20);
L_DATE1                          TIMESTAMP WITH TIME ZONE;
L_DATE2                          TIMESTAMP WITH TIME ZONE;
L_DATE3                          TIMESTAMP WITH TIME ZONE;
L_DATE4                          TIMESTAMP WITH TIME ZONE;
L_DATE5                          TIMESTAMP WITH TIME ZONE;
L_ALLOW_ANY_PP                   CHAR(1);
L_SC_CLASS                       VARCHAR2(2);
L_LOG_HS                         CHAR(1);
L_LOG_HS_DETAILS                 CHAR(1);
L_ALLOW_MODIFY                   CHAR(1);
L_AR                             CHAR(1);
L_ACTIVE                         CHAR(1);
L_LC                             VARCHAR2(2);
L_LC_VERSION                     VARCHAR2(20);
L_SS                             VARCHAR2(2);
L_FETCH_RQSC                     BOOLEAN;
L_FETCH_SDSC                     BOOLEAN;
L_BIND_FIXED_SC_FLAG             BOOLEAN;
L_BIND_SCME_SELECTION            BOOLEAN;  
L_ADD_ORACLE_HINT       BOOLEAN;


BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   L_FETCH_RQSC := FALSE;
   L_FETCH_SDSC := FALSE;
   L_ADD_ORACLE_HINT := FALSE;
   L_BIND_FIXED_SC_FLAG := FALSE;
   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
   ELSIF A_WHERE_CLAUSE = 'SELECTED METHODS' THEN
      
      
      IF UNAPIME.P_SELECTION_CLAUSE IS NOT NULL THEN 
         L_WHERE_CLAUSE := 'WHERE sc IN (SELECT DISTINCT a.sc FROM '||UNAPIME.P_SELECTION_CLAUSE|| ') ORDER BY sc'; 
         L_BIND_SCME_SELECTION := TRUE;
         L_ADD_ORACLE_HINT := TRUE ;
      ELSE
         L_WHERE_CLAUSE := 'ORDER BY sc'; 
      END IF;
   ELSIF REPLACE( SUBSTR(A_WHERE_CLAUSE, 1 , INSTR(A_WHERE_CLAUSE,'''')), ' ', '')='RQ=''' THEN
      
      
      L_FETCH_RQSC := TRUE;
      L_WHERE_CLAUSE := 'WHERE utrqsc.sc=a.sc AND utrqsc.rq= :rq_val '; 
      IF INSTR(UPPER(A_WHERE_CLAUSE), 'ORDER BY')=0 THEN
         L_WHERE_CLAUSE := L_WHERE_CLAUSE||' ORDER BY utrqsc.seq'; 
      END IF;
    ELSIF REPLACE( SUBSTR(A_WHERE_CLAUSE, 1 , INSTR(A_WHERE_CLAUSE,'''')), ' ', '')='SD=''' THEN
      
      
      L_FETCH_SDSC := TRUE;
      L_WHERE_CLAUSE := 'WHERE utsdcellsc.sc=a.sc AND utsdcellsc.sd= :sd_val '; 
      IF INSTR(UPPER(A_WHERE_CLAUSE), 'ORDER BY')=0 THEN
         L_WHERE_CLAUSE := L_WHERE_CLAUSE||' ORDER BY utsdcellsc.seq'; 
      END IF;
      
     
   ELSIF
      UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := 'WHERE a.sc = :sc_val ORDER BY sc';
      L_BIND_FIXED_SC_FLAG := TRUE;
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;
   
   IF NOT DBMS_SQL.IS_OPEN(L_SC_CURSOR) THEN
      L_SC_CURSOR := DBMS_SQL.OPEN_CURSOR;
      IF L_FETCH_RQSC THEN
         L_SQL_STRING := 'SELECT a.sc, a.st, a.st_version, a.description, a.shelf_life_val, ' ||
                      'a.shelf_life_unit, a.sampling_date, a.creation_date, ' ||
                      'a.created_by, a.exec_start_date, a.exec_end_date, ' ||
                      'a.priority, a.label_format, a.descr_doc, a.descr_doc_version, a.rq, a.sd, ' ||
                      'a.date1, a.date2, a.date3, a.date4, a.date5, ' ||
                      'a.allow_any_pp, a.sc_class, a.log_hs, a.log_hs_details, ' ||
                      'a.allow_modify, a.active, a.lc, a.lc_version, a.ss, a.ar ' ||       
                      'FROM dd' || UNAPIGEN.P_DD || '.uvsc a, utrqsc ' || L_WHERE_CLAUSE;
      
      ELSIF L_FETCH_SDSC THEN
         L_SQL_STRING := 'SELECT a.sc, a.st, a.st_version, a.description, a.shelf_life_val, ' ||
                      'a.shelf_life_unit, a.sampling_date, a.creation_date, ' ||
                      'a.created_by, a.exec_start_date, a.exec_end_date, ' ||
                      'a.priority, a.label_format, a.descr_doc, a.descr_doc_version, a.rq, a.sd, ' ||
                      'a.date1, a.date2, a.date3, a.date4, a.date5, ' ||
                      'a.allow_any_pp, a.sc_class, a.log_hs, a.log_hs_details, ' ||
                      'a.allow_modify, a.active, a.lc, a.lc_version, a.ss, a.ar ' ||       
                      'FROM dd' || UNAPIGEN.P_DD || '.uvsc a, utsdcellsc ' || L_WHERE_CLAUSE;
      
      ELSE
         L_SQL_STRING := 'SELECT a.sc, a.st, a.st_version, a.description, a.shelf_life_val, ' ||
                      'a.shelf_life_unit, a.sampling_date, a.creation_date, ' ||
                      'a.created_by, a.exec_start_date, a.exec_end_date, ' ||
                      'a.priority, a.label_format, a.descr_doc, a.descr_doc_version, a.rq, a.sd, ' ||
                      'a.date1, a.date2, a.date3, a.date4, a.date5, ' ||
                      'a.allow_any_pp, a.sc_class, a.log_hs, a.log_hs_details, ' ||
                      'a.allow_modify, a.active, a.lc, a.lc_version, a.ss, a.ar ' ||       
                      'FROM dd' || UNAPIGEN.P_DD || '.uvsc a ' || L_WHERE_CLAUSE;
      END IF;
      
      IF L_ADD_ORACLE_HINT THEN
         UNAPIAUT.ADDORACLECBOHINT (L_SQL_STRING);
      END IF;
      DBMS_SQL.PARSE(L_SC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      IF L_BIND_SCME_SELECTION THEN
         FOR L_X IN 1..UNAPIME.P_SELECTION_VAL_TAB.COUNT() LOOP
            DBMS_SQL.BIND_VARIABLE(L_SC_CURSOR, ':col_val'||L_X , UNAPIME.P_SELECTION_VAL_TAB(L_X)); 
         END LOOP;
      ELSIF L_FETCH_RQSC THEN
         DBMS_SQL.BIND_VARIABLE(L_SC_CURSOR, ':rq_val' , SUBSTR(A_WHERE_CLAUSE,5, LENGTH(A_WHERE_CLAUSE)-5)); 
      ELSIF L_FETCH_SDSC THEN
         DBMS_SQL.BIND_VARIABLE(L_SC_CURSOR, ':sd_val' , SUBSTR(A_WHERE_CLAUSE,5, LENGTH(A_WHERE_CLAUSE)-5)); 
      ELSIF L_BIND_FIXED_SC_FLAG THEN
         DBMS_SQL.BIND_VARIABLE(L_SC_CURSOR, ':sc_val' , A_WHERE_CLAUSE); 
      END IF;
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     1,   L_SC,               20);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     2,   L_ST,               20);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     3,   L_ST_VERSION,       20);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     4,   L_DESCRIPTION,      40);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     5,   L_SHELF_LIFE_VAL);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     6,   L_SHELF_LIFE_UNIT,  20);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     7,   L_SAMPLING_DATE);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     8,   L_CREATION_DATE);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     9,   L_CREATED_BY,       20);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     10,  L_EXEC_START_DATE);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     11,  L_EXEC_END_DATE);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     12,  L_PRIORITY);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     13,  L_LABEL_FORMAT,     20);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     14,  L_DESCR_DOC,        40);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     15,  L_DESCR_DOC_VERSION,20);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     16,  L_RQ,               20);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     17,  L_SD,               20);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     18,  L_DATE1);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     19,  L_DATE2);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     20,  L_DATE3);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     21,  L_DATE4);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     22,  L_DATE5);
      DBMS_SQL.DEFINE_COLUMN_CHAR(L_SC_CURSOR,23,  L_ALLOW_ANY_PP,     1);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     24,  L_SC_CLASS,         2);
      DBMS_SQL.DEFINE_COLUMN_CHAR(L_SC_CURSOR,25,  L_LOG_HS,           1);
      DBMS_SQL.DEFINE_COLUMN_CHAR(L_SC_CURSOR,26,  L_LOG_HS_DETAILS,   1);
      DBMS_SQL.DEFINE_COLUMN_CHAR(L_SC_CURSOR,27,  L_ALLOW_MODIFY,     1);
      DBMS_SQL.DEFINE_COLUMN_CHAR(L_SC_CURSOR,28,  L_ACTIVE,           1);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     29,  L_LC,               2);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     30,  L_LC_VERSION,       20);
      DBMS_SQL.DEFINE_COLUMN(L_SC_CURSOR,     31,  L_SS,               2);
      DBMS_SQL.DEFINE_COLUMN_CHAR(L_SC_CURSOR,32,  L_AR,               1);
      L_RESULT := DBMS_SQL.EXECUTE(L_SC_CURSOR);
   END IF;
   
   L_RESULT := DBMS_SQL.FETCH_ROWS(L_SC_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       1,   L_SC);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       2,   L_ST);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       3,   L_ST_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       4,   L_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       5,   L_SHELF_LIFE_VAL);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       6,   L_SHELF_LIFE_UNIT);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       7,   L_SAMPLING_DATE);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       8,   L_CREATION_DATE);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       9,   L_CREATED_BY);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       10,  L_EXEC_START_DATE);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       11,  L_EXEC_END_DATE);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       12,  L_PRIORITY);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       13,  L_LABEL_FORMAT);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       14,  L_DESCR_DOC);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       15,  L_DESCR_DOC_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       16,  L_RQ);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       17,  L_SD);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       18,  L_DATE1);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       19,  L_DATE2);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       20,  L_DATE3);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       21,  L_DATE4);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       22,  L_DATE5);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_SC_CURSOR,  23,  L_ALLOW_ANY_PP);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       24,  L_SC_CLASS);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_SC_CURSOR,  25,  L_LOG_HS);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_SC_CURSOR,  26,  L_LOG_HS_DETAILS);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_SC_CURSOR,  27,  L_ALLOW_MODIFY);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_SC_CURSOR,  28,  L_ACTIVE);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       29,  L_LC);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       30,  L_LC_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_SC_CURSOR,       31,  L_SS);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_SC_CURSOR,  32,  L_AR);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_SC(L_FETCHED_ROWS)               :=  L_SC;
      A_ST(L_FETCHED_ROWS)               :=  L_ST;
      A_ST_VERSION(L_FETCHED_ROWS)       :=  L_ST_VERSION;
      A_DESCRIPTION(L_FETCHED_ROWS)      :=  L_DESCRIPTION;
      A_SHELF_LIFE_VAL(L_FETCHED_ROWS)   :=  L_SHELF_LIFE_VAL;
      A_SHELF_LIFE_UNIT(L_FETCHED_ROWS)  :=  L_SHELF_LIFE_UNIT;
      A_SAMPLING_DATE(L_FETCHED_ROWS)    :=  L_SAMPLING_DATE;
      A_CREATION_DATE(L_FETCHED_ROWS)    :=  L_CREATION_DATE;
      A_CREATED_BY(L_FETCHED_ROWS)       :=  L_CREATED_BY;
      A_EXEC_START_DATE(L_FETCHED_ROWS)  :=  L_EXEC_START_DATE;
      A_EXEC_END_DATE(L_FETCHED_ROWS)    :=  L_EXEC_END_DATE;
      A_PRIORITY(L_FETCHED_ROWS)         :=  L_PRIORITY;
      A_LABEL_FORMAT(L_FETCHED_ROWS)     :=  L_LABEL_FORMAT;
      A_DESCR_DOC(L_FETCHED_ROWS)        :=  L_DESCR_DOC;
      A_DESCR_DOC_VERSION(L_FETCHED_ROWS):=  L_DESCR_DOC_VERSION;
      A_RQ(L_FETCHED_ROWS)               :=  L_RQ;
      A_SD(L_FETCHED_ROWS)               :=  L_SD;
      A_DATE1(L_FETCHED_ROWS)            :=  L_DATE1;
      A_DATE2(L_FETCHED_ROWS)            :=  L_DATE2;
      A_DATE3(L_FETCHED_ROWS)            :=  L_DATE3;
      A_DATE4(L_FETCHED_ROWS)            :=  L_DATE4;
      A_DATE5(L_FETCHED_ROWS)            :=  L_DATE5;
      A_ALLOW_ANY_PP(L_FETCHED_ROWS)     :=  L_ALLOW_ANY_PP;
      A_SC_CLASS(L_FETCHED_ROWS)         :=  L_SC_CLASS;
      A_LOG_HS(L_FETCHED_ROWS)           :=  L_LOG_HS;
      A_LOG_HS_DETAILS(L_FETCHED_ROWS)   :=  L_LOG_HS_DETAILS;
      A_ALLOW_MODIFY(L_FETCHED_ROWS)     :=  L_ALLOW_MODIFY;
      A_ACTIVE(L_FETCHED_ROWS)           :=  L_ACTIVE;
      A_LC(L_FETCHED_ROWS)               :=  L_LC;
      A_LC_VERSION(L_FETCHED_ROWS)       :=  L_LC_VERSION;
      A_SS(L_FETCHED_ROWS)               :=  L_SS;
      A_AR(L_FETCHED_ROWS)               :=  L_AR;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_SC_CURSOR);
      END IF;

   END LOOP;

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
      DBMS_SQL.CLOSE_CURSOR(L_SC_CURSOR);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      DBMS_SQL.CLOSE_CURSOR(L_SC_CURSOR);
   ELSE   
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   
   IF A_WHERE_CLAUSE <> 'SELECTED METHODS' AND
      L_FETCH_RQSC = FALSE AND
      L_FETCH_SDSC = FALSE AND
      DBMS_SQL.IS_OPEN(L_SC_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_SC_CURSOR);
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'GetSample', L_SQLERRM);
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'GetSample', SUBSTR(L_SQL_STRING,1,200));
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'GetSample', SUBSTR(L_SQL_STRING,201,200));
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'GetSample', SUBSTR(L_SQL_STRING,401,200));
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(L_SC_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_SC_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETSAMPLE;

FUNCTION SQLGETSCBESTMATCHINGPPLS                            
(A_SC                     IN      VARCHAR2,                  
 A_ST                     IN      VARCHAR2,                  
 A_ST_VERSION             IN      VARCHAR2,                  
 A_FIELDTYPE_TAB          IN      VC20_NESTEDTABLE_TYPE,     
 A_FIELDNAMES_TAB         IN      VC20_NESTEDTABLE_TYPE,     
 A_FIELDVALUES_TAB        IN      VC40_NESTEDTABLE_TYPE,     
 A_FIELDNR_OF_ROWS        IN      NUMBER)                    
RETURN UOSTPPKEYLIST IS

L_UOSTPPKEYLIST       UOSTPPKEYLIST := UOSTPPKEYLIST();
L_UOSTPPKEYLIST_OUT   UOSTPPKEYLIST := UOSTPPKEYLIST();

CURSOR L_SC_CURSOR(A_SC VARCHAR2) IS
   SELECT ST, ST_VERSION
   FROM UTSC
   WHERE SC = A_SC;
L_ST                    VARCHAR2(20);
L_ST_VERSION            VARCHAR2(20);
L_PP_KEY1_VALUES        VC20_NESTEDTABLE_TYPE := VC20_NESTEDTABLE_TYPE();
L_PP_KEY2_VALUES        VC20_NESTEDTABLE_TYPE := VC20_NESTEDTABLE_TYPE();
L_PP_KEY3_VALUES        VC20_NESTEDTABLE_TYPE := VC20_NESTEDTABLE_TYPE();
L_PP_KEY4_VALUES        VC20_NESTEDTABLE_TYPE := VC20_NESTEDTABLE_TYPE();
L_PP_KEY5_VALUES        VC20_NESTEDTABLE_TYPE := VC20_NESTEDTABLE_TYPE();
L_REF_CURSOR            UNAPIGEN.CURSOR_REF_TYPE;
L_PP                    VARCHAR2(20);
L_PP_VERSION            VARCHAR2(20);
L_PP_KEY1               VARCHAR2(20);
L_PP_KEY2               VARCHAR2(20);
L_PP_KEY3               VARCHAR2(20);
L_PP_KEY4               VARCHAR2(20);
L_PP_KEY5               VARCHAR2(20);
L_SEQ                   NUMBER(5);
L_SUPPLIER_KNOWN        BOOLEAN;
L_CUSTOMER_KNOWN        BOOLEAN;
L_PREVIOUS_PP           VARCHAR2(20);
L_PREVIOUS_PP_VERSION   VARCHAR2(20);
L_PREVIOUS_PP_KEY1      VARCHAR2(20);
L_PREVIOUS_PP_KEY2      VARCHAR2(20);
L_PREVIOUS_PP_KEY3      VARCHAR2(20);
L_PREVIOUS_PP_KEY4      VARCHAR2(20);
L_PREVIOUS_PP_KEY5      VARCHAR2(20);
L_SUPPLIER              VARCHAR2(20);
L_PREVIOUS_SUPPLIER     VARCHAR2(20);
L_CUSTOMER              VARCHAR2(20);
L_PREVIOUS_CUSTOMER     VARCHAR2(20);
L_ROW                   INTEGER;
L_ORDER_BY_CLAUSE       VARCHAR2(255);

   FUNCTION INTERNALVALIDATEPPVERSION 
   (A_PP                     IN       VARCHAR2,  
    A_VERSION                IN       VARCHAR2,  
    A_PP_KEY1                IN       VARCHAR2,  
    A_PP_KEY2                IN       VARCHAR2,  
    A_PP_KEY3                IN       VARCHAR2,  
    A_PP_KEY4                IN       VARCHAR2,  
    A_PP_KEY5                IN       VARCHAR2)  
   RETURN VARCHAR2 AS
   L_VALIDATED_VERSION   VARCHAR2(20);
   BEGIN
      L_VALIDATED_VERSION := UNAPIGEN.VALIDATEPPVERSION(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5);
      RETURN(L_VALIDATED_VERSION);
   EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      RETURN(NULL);
   END;
   
BEGIN

   
   
   
   

   
   
   
   
   IF A_SC IS NULL AND
      A_ST IS NULL THEN
      RAISE_APPLICATION_ERROR(-20000, 'Argument a_sc OR a_st must be specified when calling UNAPISC.SQLGetScBestMatchingPpLs.');
   END IF;

   
   IF UNAPIGEN.P_PP_KEY4PRODUCT IS NULL THEN
      RAISE_APPLICATION_ERROR(-20000, 'UNAPISC.SQLGetScBestMatchingPpLs may not be called in a session where no SetConnection took place');
   END IF;

   
   
   
   
   
   
      
   IF A_ST IS NULL THEN
      OPEN L_SC_CURSOR(A_SC);
      FETCH L_SC_CURSOR
      INTO L_ST, L_ST_VERSION;
      CLOSE L_SC_CURSOR;
   ELSE
      L_ST := A_ST;
      IF A_ST_VERSION IS NULL THEN
         L_ST_VERSION := UNAPIGEN.VALIDATEVERSION('st', A_ST, A_ST_VERSION);
      ELSE
         L_ST_VERSION := A_ST_VERSION;
      END IF;
   END IF;
   
   
   
   FOR L_X IN 1..5 LOOP
      IF L_X = 1 THEN
         L_PP_KEY1_VALUES.EXTEND;
         L_PP_KEY1_VALUES(L_PP_KEY1_VALUES.COUNT) :=  ' ';
      ELSIF L_X = 2 THEN
         L_PP_KEY2_VALUES.EXTEND;
         L_PP_KEY2_VALUES(L_PP_KEY2_VALUES.COUNT) :=  ' ';
      ELSIF L_X = 3 THEN
         L_PP_KEY3_VALUES.EXTEND;
         L_PP_KEY3_VALUES(L_PP_KEY3_VALUES.COUNT) :=  ' ';
      ELSIF L_X = 4 THEN
         L_PP_KEY4_VALUES.EXTEND;
         L_PP_KEY4_VALUES(L_PP_KEY4_VALUES.COUNT) :=  ' ';
      ELSIF L_X = 5 THEN
         L_PP_KEY5_VALUES.EXTEND;
         L_PP_KEY5_VALUES(L_PP_KEY5_VALUES.COUNT) :=  ' ';
      END IF;
   END LOOP;
   
   IF A_FIELDNR_OF_ROWS = 0 THEN
      
      L_SUPPLIER_KNOWN := FALSE;
      L_CUSTOMER_KNOWN := FALSE;
      FOR L_SCGK_REC IN (SELECT GK, VALUE FROM UTSCGK WHERE SC=A_SC) LOOP
         FOR L_X IN 1..UNAPIGEN.P_PP_KEY_NR_OF_ROWS LOOP
            IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) IN ('gk', 'customer', 'supplier') THEN
               IF L_SCGK_REC.GK = SUBSTR(UNAPIGEN.P_PP_KEY_NAME_TAB(L_X),4) THEN
                  IF L_X = 1 THEN
                     L_PP_KEY1_VALUES.EXTEND;
                     L_PP_KEY1_VALUES(L_PP_KEY1_VALUES.COUNT) :=  L_SCGK_REC.VALUE;
                  ELSIF L_X = 2 THEN
                     L_PP_KEY2_VALUES.EXTEND;
                     L_PP_KEY2_VALUES(L_PP_KEY2_VALUES.COUNT) :=  L_SCGK_REC.VALUE;
                  ELSIF L_X = 3 THEN
                     L_PP_KEY3_VALUES.EXTEND;
                     L_PP_KEY3_VALUES(L_PP_KEY3_VALUES.COUNT) :=  L_SCGK_REC.VALUE;
                  ELSIF L_X = 4 THEN
                     L_PP_KEY4_VALUES.EXTEND;
                     L_PP_KEY4_VALUES(L_PP_KEY4_VALUES.COUNT) :=  L_SCGK_REC.VALUE;
                  ELSIF L_X = 5 THEN
                     L_PP_KEY5_VALUES.EXTEND;
                     L_PP_KEY5_VALUES(L_PP_KEY5_VALUES.COUNT) :=  L_SCGK_REC.VALUE;
                  END IF;
                  IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) = 'supplier' THEN
                     L_SUPPLIER_KNOWN := TRUE;
                  END IF;
                  IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) = 'customer' THEN
                     L_CUSTOMER_KNOWN := TRUE;
                  END IF;
               END IF;
            END IF;
         END LOOP;
      END LOOP;
   ELSE
      
      L_SUPPLIER_KNOWN := FALSE;
      L_CUSTOMER_KNOWN := FALSE;
      FOR L_FIELDNR IN 1..A_FIELDNR_OF_ROWS LOOP
         FOR L_X IN 1..UNAPIGEN.P_PP_KEY_NR_OF_ROWS LOOP
            IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) IN ('gk', 'customer', 'supplier') THEN
               IF A_FIELDNAMES_TAB(L_FIELDNR) = SUBSTR(UNAPIGEN.P_PP_KEY_NAME_TAB(L_X),4) THEN
                  IF L_X = 1 THEN
                     L_PP_KEY1_VALUES.EXTEND;
                     L_PP_KEY1_VALUES(L_PP_KEY1_VALUES.COUNT) :=  A_FIELDVALUES_TAB(L_FIELDNR);
                  ELSIF L_X = 2 THEN
                     L_PP_KEY2_VALUES.EXTEND;
                     L_PP_KEY2_VALUES(L_PP_KEY2_VALUES.COUNT) :=  A_FIELDVALUES_TAB(L_FIELDNR);
                  ELSIF L_X = 3 THEN
                     L_PP_KEY3_VALUES.EXTEND;
                     L_PP_KEY3_VALUES(L_PP_KEY3_VALUES.COUNT) :=  A_FIELDVALUES_TAB(L_FIELDNR);
                  ELSIF L_X = 4 THEN
                     L_PP_KEY4_VALUES.EXTEND;
                     L_PP_KEY4_VALUES(L_PP_KEY4_VALUES.COUNT) :=  A_FIELDVALUES_TAB(L_FIELDNR);
                  ELSIF L_X = 5 THEN
                     L_PP_KEY5_VALUES.EXTEND;
                     L_PP_KEY5_VALUES(L_PP_KEY5_VALUES.COUNT) :=  A_FIELDVALUES_TAB(L_FIELDNR);
                  END IF;
                  IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) = 'supplier' THEN
                     L_SUPPLIER_KNOWN := TRUE;
                  END IF;
                  IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) = 'customer' THEN
                     L_CUSTOMER_KNOWN := TRUE;
                  END IF;
               END IF;
            END IF;
         END LOOP;
      END LOOP;      
   END IF;
   
   
   
   
   L_SQL_STRING := 'SELECT seq, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5 FROM dd'||
                   UNAPIGEN.P_DD || '.uvstpp stpp ';
   
   L_WHERE_CLAUSE := 'WHERE st = :a_st AND version=:a_version ';
   L_ORDER_BY_CLAUSE := ' ORDER BY pp, pp_version';
   
   
   
   IF UNAPIGEN.P_PP_KEY4PRODUCT > 0 THEN
      L_ORDER_BY_CLAUSE := ' ORDER BY pp, pp_version , pp_key'||UNAPIGEN.P_PP_KEY4PRODUCT||' DESC';
   END IF;

   
   
   FOR L_X IN 1..UNAPIGEN.P_PP_KEY_NR_OF_ROWS LOOP
      IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) NOT IN ('st', 'customer', 'supplier') THEN
         L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND pp_key'||L_X||
                           ' IN (SELECT * FROM TABLE(CAST (:l_pp_key'||L_X||'_values AS VC20_NESTEDTABLE_TYPE)))';
         L_ORDER_BY_CLAUSE := L_ORDER_BY_CLAUSE||',pp_key'||L_X||' DESC';
      ELSE
         
         L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND EXISTS '||
                           '(SELECT ''X'' FROM TABLE(CAST (:l_pp_key'||L_X||'_values AS VC20_NESTEDTABLE_TYPE)))';
      END IF;
      IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) IN ('customer', 'supplier') THEN
         L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND pp_key'||L_X||' = '' ''';
      END IF;
   END LOOP;
   
   FOR L_X IN UNAPIGEN.P_PP_KEY_NR_OF_ROWS+1..5 LOOP
      L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND EXISTS '||
                        '(SELECT ''X'' FROM TABLE(CAST (:l_pp_key'||L_X||'_values AS VC20_NESTEDTABLE_TYPE)))';
   END LOOP;

   
   OPEN L_REF_CURSOR
   FOR L_SQL_STRING || L_WHERE_CLAUSE || L_ORDER_BY_CLAUSE
   USING L_ST, L_ST_VERSION, L_PP_KEY1_VALUES, L_PP_KEY2_VALUES,
         L_PP_KEY3_VALUES, L_PP_KEY4_VALUES, L_PP_KEY5_VALUES;
   L_PREVIOUS_PP := ' ';
   L_PREVIOUS_PP_VERSION := ' ';
   LOOP
      FETCH L_REF_CURSOR
      INTO L_SEQ, L_PP, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5;

      EXIT WHEN L_REF_CURSOR%NOTFOUND;
      IF L_PP <> L_PREVIOUS_PP OR
         L_PP_VERSION <> L_PREVIOUS_PP_VERSION THEN
         
         IF INTERNALVALIDATEPPVERSION(L_PP, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, 
                                      L_PP_KEY3, L_PP_KEY4, L_PP_KEY5) IS NOT NULL THEN
            L_UOSTPPKEYLIST.EXTEND;
            L_UOSTPPKEYLIST(L_UOSTPPKEYLIST.COUNT) := 
                                UOSTPPKEY(L_ST, L_ST_VERSION, L_PP, L_PP_VERSION,
                                          L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4,
                                          L_PP_KEY5, L_SEQ);
            L_PREVIOUS_PP := L_PP;
            L_PREVIOUS_PP_VERSION := L_PP_VERSION;
         END IF;
      END IF;
   END LOOP;
   CLOSE L_REF_CURSOR;

   
   
   
   
   IF L_SUPPLIER_KNOWN THEN
      IF UNAPIGEN.P_PP_KEY4CUSTOMER > 0 THEN
         L_SQL_STRING := 'SELECT seq, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,'||
                         'pp_key'||UNAPIGEN.P_PP_KEY4SUPPLIER||' supplier,pp_key'||UNAPIGEN.P_PP_KEY4CUSTOMER||' customer FROM dd'||
                         UNAPIGEN.P_DD || '.uvstpp stpp ';
      ELSE
         L_SQL_STRING := 'SELECT seq, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,'||
                         'pp_key'||UNAPIGEN.P_PP_KEY4SUPPLIER||' supplier,'' '' customer FROM dd'||
                         UNAPIGEN.P_DD || '.uvstpp stpp ';
      END IF;
      
      L_WHERE_CLAUSE := 'WHERE st = :a_st AND version=:a_version ';
      L_ORDER_BY_CLAUSE := ' ORDER BY pp, pp_version';
      
      
      
      IF UNAPIGEN.P_PP_KEY4PRODUCT > 0 THEN
         L_ORDER_BY_CLAUSE := ' ORDER BY pp, pp_version, pp_key'||UNAPIGEN.P_PP_KEY4PRODUCT||' DESC';
      END IF;

      
      FOR L_X IN 1..UNAPIGEN.P_PP_KEY_NR_OF_ROWS LOOP
         IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) <> 'st' THEN
            L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND pp_key'||L_X||
                              ' IN (SELECT * FROM TABLE(CAST (:l_pp_key'||L_X||'_values AS VC20_NESTEDTABLE_TYPE)))';
            IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) NOT IN ('st','supplier', 'customer') THEN
               L_ORDER_BY_CLAUSE := L_ORDER_BY_CLAUSE||',pp_key'||L_X||' DESC';
            END IF;
         ELSE
            
            L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND EXISTS '||
                              '(SELECT ''X'' FROM TABLE(CAST (:l_pp_key'||L_X||'_values AS VC20_NESTEDTABLE_TYPE)))';
         END IF;
         
         IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) = 'supplier' THEN
            L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND pp_key'||L_X||' <> '' ''';
         END IF;
      END LOOP;
      
      FOR L_X IN UNAPIGEN.P_PP_KEY_NR_OF_ROWS+1..5 LOOP
         L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND EXISTS '||
                           '(SELECT ''X'' FROM TABLE(CAST (:l_pp_key'||L_X||'_values AS VC20_NESTEDTABLE_TYPE)))';
      END LOOP;
      
      IF UNAPIGEN.P_PP_KEY4CUSTOMER > 0 THEN
         L_ORDER_BY_CLAUSE := L_ORDER_BY_CLAUSE||',pp_key'||UNAPIGEN.P_PP_KEY4SUPPLIER||' DESC'||
                              ',pp_key'||UNAPIGEN.P_PP_KEY4CUSTOMER||' DESC';
      ELSE
         L_ORDER_BY_CLAUSE := L_ORDER_BY_CLAUSE||',pp_key'||UNAPIGEN.P_PP_KEY4SUPPLIER||' DESC';
      END IF;
      
      
      OPEN L_REF_CURSOR
      FOR L_SQL_STRING || L_WHERE_CLAUSE || L_ORDER_BY_CLAUSE
      USING L_ST, L_ST_VERSION, L_PP_KEY1_VALUES, L_PP_KEY2_VALUES,
            L_PP_KEY3_VALUES, L_PP_KEY4_VALUES, L_PP_KEY5_VALUES;
      L_PREVIOUS_PP := ' ';
      L_PREVIOUS_PP_VERSION := ' ';
      L_PREVIOUS_SUPPLIER := ' ';
      L_PREVIOUS_CUSTOMER := ' ';
      LOOP
         FETCH L_REF_CURSOR
         INTO L_SEQ, L_PP, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, L_SUPPLIER, L_CUSTOMER;

         EXIT WHEN L_REF_CURSOR%NOTFOUND;
         IF L_PP <> L_PREVIOUS_PP OR 
            L_PP_VERSION <> L_PREVIOUS_PP_VERSION OR
            L_SUPPLIER <> L_PREVIOUS_SUPPLIER OR
            (L_CUSTOMER <> ' ' AND L_CUSTOMER <> L_PREVIOUS_CUSTOMER) THEN
            
            IF INTERNALVALIDATEPPVERSION(L_PP, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, 
                                         L_PP_KEY3, L_PP_KEY4, L_PP_KEY5) IS NOT NULL THEN
               L_UOSTPPKEYLIST.EXTEND;
               L_UOSTPPKEYLIST(L_UOSTPPKEYLIST.COUNT) := 
                          UOSTPPKEY(L_ST, L_ST_VERSION, L_PP, L_PP_VERSION, 
                                    L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4,
                                    L_PP_KEY5, L_SEQ);
               L_PREVIOUS_PP := L_PP;
               L_PREVIOUS_PP_VERSION := L_PP_VERSION;
               L_PREVIOUS_SUPPLIER := L_SUPPLIER;
               L_PREVIOUS_CUSTOMER := L_CUSTOMER;
            END IF;
         END IF;
      END LOOP;
      CLOSE L_REF_CURSOR;
   END IF;

   
   
   
   
   IF L_CUSTOMER_KNOWN THEN
      IF UNAPIGEN.P_PP_KEY4SUPPLIER > 0 THEN
         L_SQL_STRING := 'SELECT seq, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,'||
                         'pp_key'||UNAPIGEN.P_PP_KEY4CUSTOMER||' customer,pp_key'||UNAPIGEN.P_PP_KEY4SUPPLIER||' supplier FROM dd'||
                         UNAPIGEN.P_DD || '.uvstpp stpp ';
      ELSE
         L_SQL_STRING := 'SELECT seq, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,'||
                         'pp_key'||UNAPIGEN.P_PP_KEY4CUSTOMER||' customer,'' '' supplier FROM dd'||
                         UNAPIGEN.P_DD || '.uvstpp stpp ';
      END IF;

      
      L_WHERE_CLAUSE := 'WHERE st = :a_st AND version=:a_version ';
      L_ORDER_BY_CLAUSE := ' ORDER BY pp, pp_version';
      
      
      
      IF UNAPIGEN.P_PP_KEY4PRODUCT > 0 THEN
         L_ORDER_BY_CLAUSE := ' ORDER BY pp, pp_version, pp_key'||UNAPIGEN.P_PP_KEY4PRODUCT||' DESC';
      END IF;

      
      FOR L_X IN 1..UNAPIGEN.P_PP_KEY_NR_OF_ROWS LOOP
         IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) <> 'st' THEN
            L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND pp_key'||L_X||
                              ' IN (SELECT * FROM TABLE(CAST (:l_pp_key'||L_X||'_values AS VC20_NESTEDTABLE_TYPE)))';
            IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) NOT IN ('st','supplier', 'customer') THEN
               L_ORDER_BY_CLAUSE := L_ORDER_BY_CLAUSE||',pp_key'||L_X||' DESC';
            END IF;
         ELSE
            
            L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND EXISTS '||
                              '(SELECT ''X'' FROM TABLE(CAST (:l_pp_key'||L_X||'_values AS VC20_NESTEDTABLE_TYPE)))';
         END IF;
         
         IF UNAPIGEN.P_PP_KEY_TP_TAB(L_X) = 'customer' THEN
            L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND pp_key'||L_X||' <> '' ''';
         END IF;
      END LOOP;
      
      FOR L_X IN UNAPIGEN.P_PP_KEY_NR_OF_ROWS+1..5 LOOP
         L_WHERE_CLAUSE := L_WHERE_CLAUSE || ' AND EXISTS '||
                           '(SELECT ''X'' FROM TABLE(CAST (:l_pp_key'||L_X||'_values AS VC20_NESTEDTABLE_TYPE)))';
      END LOOP;
      
      IF UNAPIGEN.P_PP_KEY4SUPPLIER > 0 THEN
         L_ORDER_BY_CLAUSE := L_ORDER_BY_CLAUSE||',pp_key'||UNAPIGEN.P_PP_KEY4CUSTOMER||' DESC'||
                              ',pp_key'||UNAPIGEN.P_PP_KEY4SUPPLIER||' DESC';
      ELSE
         L_ORDER_BY_CLAUSE := L_ORDER_BY_CLAUSE||',pp_key'||UNAPIGEN.P_PP_KEY4CUSTOMER||' DESC';
      END IF;

      
      OPEN L_REF_CURSOR
      FOR L_SQL_STRING || L_WHERE_CLAUSE || L_ORDER_BY_CLAUSE
      USING L_ST, L_ST_VERSION, L_PP_KEY1_VALUES, L_PP_KEY2_VALUES,
            L_PP_KEY3_VALUES, L_PP_KEY4_VALUES, L_PP_KEY5_VALUES;
      L_PREVIOUS_PP := ' ';
      L_PREVIOUS_PP_VERSION := ' ';
      L_PREVIOUS_CUSTOMER := ' ';
      L_PREVIOUS_SUPPLIER := ' ';
      LOOP
         FETCH L_REF_CURSOR
         INTO L_SEQ, L_PP, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, L_CUSTOMER, L_SUPPLIER;

         EXIT WHEN L_REF_CURSOR%NOTFOUND;
         IF L_PP <> L_PREVIOUS_PP OR
            L_PP_VERSION <> L_PREVIOUS_PP_VERSION OR
            L_CUSTOMER <> L_PREVIOUS_CUSTOMER OR
            (L_SUPPLIER <> ' ' AND L_SUPPLIER <> L_PREVIOUS_SUPPLIER) THEN
            
            IF INTERNALVALIDATEPPVERSION(L_PP, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, 
                                         L_PP_KEY3, L_PP_KEY4, L_PP_KEY5) IS NOT NULL THEN
               L_UOSTPPKEYLIST.EXTEND;
               L_UOSTPPKEYLIST(L_UOSTPPKEYLIST.COUNT) := 
                          UOSTPPKEY(L_ST, L_ST_VERSION, L_PP, L_PP_VERSION, 
                                    L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4,
                                    L_PP_KEY5, L_SEQ);
               L_PREVIOUS_PP := L_PP;
               L_PREVIOUS_PP_VERSION := L_PP_VERSION;
               L_PREVIOUS_CUSTOMER := L_CUSTOMER;
               L_PREVIOUS_SUPPLIER := L_SUPPLIER;
            END IF;
         END IF;
      END LOOP;
      CLOSE L_REF_CURSOR;
   END IF;

   
   
   
   
   
   L_ROW := 0;
   OPEN L_REF_CURSOR 
   FOR 'SELECT st, version, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, seq '|| 
       'FROM dd'||UNAPIGEN.P_DD||'.uvstpp WHERE (st, version, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) IN '||
       '(SELECT st, version, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5 '||
       ' FROM TABLE(CAST(:l_uostppkeylist AS uostppkeylist))) '||
       'ORDER BY seq'
   USING L_UOSTPPKEYLIST;

   LOOP
      FETCH L_REF_CURSOR 
      INTO L_ST, L_ST_VERSION, L_PP, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, L_SEQ;
      EXIT WHEN L_REF_CURSOR%NOTFOUND;
      L_ROW := L_ROW + 1;
      L_UOSTPPKEYLIST_OUT.EXTEND();
      L_UOSTPPKEYLIST_OUT(L_ROW) := UOSTPPKEY(L_ST, L_ST_VERSION, L_PP, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, L_SEQ);
   END LOOP;
   CLOSE L_REF_CURSOR;
   RETURN(L_UOSTPPKEYLIST_OUT);

EXCEPTION
WHEN OTHERS THEN
   IF L_SC_CURSOR%ISOPEN THEN
      CLOSE L_SC_CURSOR;
   END IF;
   IF L_REF_CURSOR%ISOPEN THEN
      CLOSE L_REF_CURSOR;
   END IF;
   RAISE;
   
END SQLGETSCBESTMATCHINGPPLS;

END UNAPISC2;