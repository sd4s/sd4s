PACKAGE BODY unapipg3 AS

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(2000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_TIMED_EVENT_TP  UTEVTIMED.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
STPERROR          EXCEPTION;

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;


P_EXT_TST_TP                     UNAPIGEN.VC20_TABLE_TYPE; 
P_EXT_TST_ID                     UNAPIGEN.VC20_TABLE_TYPE; 
P_EXT_TST_ID_VERSION             UNAPIGEN.VC20_TABLE_TYPE;
P_EXT_PP_SEQ                     UNAPIGEN.NUM_TABLE_TYPE;
P_EXT_PR_SEQ                     UNAPIGEN.NUM_TABLE_TYPE;
P_EXT_MT_SEQ                     UNAPIGEN.NUM_TABLE_TYPE;
P_EXT_PP_KEY1                    UNAPIGEN.VC20_TABLE_TYPE;
P_EXT_PP_KEY2                    UNAPIGEN.VC20_TABLE_TYPE;
P_EXT_PP_KEY3                    UNAPIGEN.VC20_TABLE_TYPE;
P_EXT_PP_KEY4                    UNAPIGEN.VC20_TABLE_TYPE;
P_EXT_PP_KEY5                    UNAPIGEN.VC20_TABLE_TYPE;
P_NR_OBJECTS                     INTEGER;
P_LAST_ROW                       INTEGER;
P_LAST_ATTRIBUTE                 INTEGER;
P_CURRENT_PP                           VARCHAR(20);
P_CURRENT_PR                           VARCHAR(20);
P_CURRENT_PP_VERSION       VARCHAR(20);
P_CURRENT_PP_SEQ           NUMBER(9);
P_CURRENT_PR_SEQ           NUMBER(9);
P_CURRENT_MT_SEQ           NUMBER(9);
P_CURRENT_PP_KEY1          VARCHAR(20);
P_CURRENT_PP_KEY2          VARCHAR(20);
P_CURRENT_PP_KEY3          VARCHAR(20);
P_CURRENT_PP_KEY4          VARCHAR(20);
P_CURRENT_PP_KEY5          VARCHAR(20);
P_CURRENT_PR_VERSION       VARCHAR(20);

L_CONFIG_DETAILS_CURSOR    INTEGER;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION GETTESTPLANATTRIBUTES                             
(A_OBJECT_TP            IN      VARCHAR2,                  
 A_OBJECT_ID            IN      VARCHAR2,                  
 A_OBJECT_VERSION       IN      VARCHAR2,                  
 A_TST_TP               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_TST_ID               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_TST_ID_VERSION       OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_SEQ               OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_PR_SEQ               OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_MT_SEQ               OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_PP_KEY1              OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY2              OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY3              OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY4              OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY5              OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_AU                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_AU_VERSION           OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_VALUE                OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCRIPTION          OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_IS_PROTECTED         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SINGLE_VALUED        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NEW_VAL_ALLOWED      OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_STORE_DB             OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_VALUE_LIST_TP        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_RUN_MODE             OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SERVICE              OUT     UNAPIGEN.VC255_TABLE_TYPE, 
 A_CF_VALUE             OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_NR_OF_ROWS           IN OUT  NUMBER,                    
 A_NEXT_ROWS            IN      NUMBER)                    
RETURN NUMBER IS

L_NOT_ASSIGNED  INTEGER;
L_ASSIGNED      INTEGER;
L_SOME_ASSIGNED INTEGER;
L_COUNT_SC      NUMBER;
L_REF_OBJECT_TP VARCHAR2(2);
L_REF_OBJECT_ID VARCHAR2(20);
L_REF_OBJECT_VERSION VARCHAR2(20);

L_ROW INTEGER;
L_LAST_ROW INTEGER;
L_AU_FOUND             INTEGER;
L_CURRENT_ROW          INTEGER;
L_CURRENT_PP           VARCHAR2(20);
L_CURRENT_PP_VERSION   VARCHAR2(20);
L_CURRENT_PP_SEQ       NUMBER(9);
L_CURRENT_PR_SEQ       NUMBER(9);
L_CURRENT_MT_SEQ       NUMBER(9);
L_CURRENT_PP_KEY1      VARCHAR2(20);
L_CURRENT_PP_KEY2      VARCHAR2(20);
L_CURRENT_PP_KEY3      VARCHAR2(20);
L_CURRENT_PP_KEY4      VARCHAR2(20);
L_CURRENT_PP_KEY5      VARCHAR2(20);
L_CURRENT_PR           VARCHAR2(20);
L_CURRENT_PR_VERSION   VARCHAR2(20);
L_CURRENT_MT           VARCHAR2(20);
L_CURRENT_MT_VERSION   VARCHAR2(20);
    

L_REC_MAINSEQ           NUMBER;
L_REC_TST_TP            VARCHAR2(20);
L_REC_TST_ID            VARCHAR2(20);
L_REC_TST_ID_VERSION    VARCHAR2(20);
L_REC_TST_DESCRIPTION   VARCHAR2(40);
L_REC_PP                VARCHAR2(20);
L_REC_PP_KEY1           VARCHAR2(20);
L_REC_PP_KEY2           VARCHAR2(20);
L_REC_PP_KEY3           VARCHAR2(20);
L_REC_PP_KEY4           VARCHAR2(20);
L_REC_PP_KEY5           VARCHAR2(20);
L_REC_PP_SEQ            NUMBER;
L_REC_PR                VARCHAR2(20);
L_REC_PR_SEQ            NUMBER;
L_REC_MT                VARCHAR2(20);
L_REC_MT_SEQ            NUMBER;
L_REC_TST_NR_MEASUR     NUMBER;

CURSOR L_PPAU_CURSOR (A_PARENT_ID VARCHAR2, A_PARENT_VERSION VARCHAR2,
                      A_OBJECT_ID VARCHAR2, A_OBJECT_VERSION VARCHAR2, 
                      A_PP_KEY1 VARCHAR2, A_PP_KEY2 VARCHAR2,
                      A_PP_KEY3 VARCHAR2, A_PP_KEY4 VARCHAR2,
                      A_PP_KEY5 VARCHAR2) IS
   SELECT A.AU, A.AUSEQ, D.VERSION, A.VALUE, D.DESCRIPTION, D.IS_PROTECTED, D.SINGLE_VALUED,
       D.NEW_VAL_ALLOWED, D.STORE_DB, D.VALUE_LIST_TP,
       D.RUN_MODE, D.SERVICE, D.CF_VALUE
   FROM UTPPAU A,  UTAU D
   WHERE A.PP = A_OBJECT_ID
     AND A.VERSION = A_OBJECT_VERSION
     AND A.PP_KEY1 = A_PP_KEY1
     AND A.PP_KEY2 = A_PP_KEY2
     AND A.PP_KEY3 = A_PP_KEY3
     AND A.PP_KEY4 = A_PP_KEY4
     AND A.PP_KEY5 = A_PP_KEY5
     AND A.AU = D.AU
     AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION
     AND A.AU NOT IN 
     (SELECT DISTINCT E.AU 
         FROM UTSTPPAU E,  UTAU F
         WHERE E.PP = A_OBJECT_ID
              AND E.PP_KEY1 = A_PP_KEY1
              AND E.PP_KEY2 = A_PP_KEY2
              AND E.PP_KEY3 = A_PP_KEY3
              AND E.PP_KEY4 = A_PP_KEY4
              AND E.PP_KEY5 = A_PP_KEY5
              AND UNAPIGEN.USEPPVERSION(E.PP, E.PP_VERSION, E.PP_KEY1, E.PP_KEY2, E.PP_KEY3, E.PP_KEY4, E.PP_KEY5) = A_OBJECT_VERSION 
              AND E.ST = A_PARENT_ID
              AND E.VERSION = A_PARENT_VERSION
              AND E.AU = F.AU
              AND UNAPIGEN.USEVERSION('au', E.AU, E.AU_VERSION) = F.VERSION) 
   ORDER BY A.AU, A.AUSEQ;
     
CURSOR L_STPPAU_CURSOR (A_PARENT_ID VARCHAR2, A_PARENT_VERSION VARCHAR2, 
                        A_OBJECT_ID VARCHAR2, A_OBJECT_VERSION VARCHAR2, 
                        A_PP_KEY1 VARCHAR2, A_PP_KEY2 VARCHAR2, 
                        A_PP_KEY3 VARCHAR2, A_PP_KEY4 VARCHAR2, 
                        A_PP_KEY5 VARCHAR2) IS
   SELECT A.AU, A.AUSEQ, D.VERSION, A.VALUE, D.DESCRIPTION, D.IS_PROTECTED, D.SINGLE_VALUED,
       D.NEW_VAL_ALLOWED, D.STORE_DB, D.VALUE_LIST_TP,
       D.RUN_MODE, D.SERVICE, D.CF_VALUE
   FROM UTSTPPAU A,  UTAU D
   WHERE A.PP = A_OBJECT_ID
     AND A.PP_KEY1 = A_PP_KEY1
     AND A.PP_KEY2 = A_PP_KEY2
     AND A.PP_KEY3 = A_PP_KEY3
     AND A.PP_KEY4 = A_PP_KEY4
     AND A.PP_KEY5 = A_PP_KEY5
     AND UNAPIGEN.USEPPVERSION(A.PP, A.PP_VERSION, A.PP_KEY1, A.PP_KEY2, A.PP_KEY3, A.PP_KEY4, A.PP_KEY5) = A_OBJECT_VERSION 
     AND A.ST = A_PARENT_ID
     AND A.VERSION = A_PARENT_VERSION
     AND A.AU = D.AU
     AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION 
   ORDER BY A.AU, A.AUSEQ;
 
 CURSOR L_PRAU_CURSOR (A_PARENT_ID VARCHAR2, A_PARENT_VERSION VARCHAR2, 
                       A_OBJECT_ID VARCHAR2, A_OBJECT_VERSION VARCHAR2, 
                       A_PP_KEY1 VARCHAR2, A_PP_KEY2 VARCHAR2, 
                       A_PP_KEY3 VARCHAR2, A_PP_KEY4 VARCHAR2, 
                       A_PP_KEY5 VARCHAR2) IS
    SELECT A.AU, A.AUSEQ, D.VERSION, A.VALUE, D.DESCRIPTION, D.IS_PROTECTED, D.SINGLE_VALUED,
        D.NEW_VAL_ALLOWED, D.STORE_DB, D.VALUE_LIST_TP,
        D.RUN_MODE, D.SERVICE, D.CF_VALUE
    FROM UTPRAU A,  UTAU D
    WHERE A.PR = A_OBJECT_ID
      AND A.VERSION = A_OBJECT_VERSION
      AND A.AU = D.AU
      AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION
      AND A.AU NOT IN 
     (SELECT DISTINCT E.AU 
          FROM UTPPPRAU E,  UTAU F
          WHERE E.PP = A_PARENT_ID
            AND E.VERSION = A_PARENT_VERSION
            AND E.PP_KEY1 = A_PP_KEY1
            AND E.PP_KEY2 = A_PP_KEY2
            AND E.PP_KEY3 = A_PP_KEY3
            AND E.PP_KEY4 = A_PP_KEY4
            AND E.PP_KEY5 = A_PP_KEY5
            AND E.PR = A_OBJECT_ID
            AND UNAPIGEN.USEVERSION('pr', E.PR, E.PR_VERSION) = A_OBJECT_VERSION 
            AND E.AU = F.AU
            AND UNAPIGEN.USEVERSION('au', E.AU, E.AU_VERSION) = F.VERSION) 
   ORDER BY A.AU, A.AUSEQ;
   
 CURSOR L_PPPRAU_CURSOR (A_PARENT_ID VARCHAR2, A_PARENT_VERSION VARCHAR2, 
                         A_OBJECT_ID VARCHAR2, A_OBJECT_VERSION VARCHAR2, 
                         A_PP_KEY1 VARCHAR2, A_PP_KEY2 VARCHAR2, 
                         A_PP_KEY3 VARCHAR2, A_PP_KEY4 VARCHAR2, 
                         A_PP_KEY5 VARCHAR2) IS
    SELECT A.AU, A.AUSEQ, D.VERSION, A.VALUE, D.DESCRIPTION, D.IS_PROTECTED, D.SINGLE_VALUED,
        D.NEW_VAL_ALLOWED, D.STORE_DB, D.VALUE_LIST_TP,
        D.RUN_MODE, D.SERVICE, D.CF_VALUE
    FROM UTPPPRAU A,  UTAU D
    WHERE A.PP = A_PARENT_ID
        AND A.VERSION = A_PARENT_VERSION
        AND A.PP_KEY1 = A_PP_KEY1
        AND A.PP_KEY2 = A_PP_KEY2
        AND A.PP_KEY3 = A_PP_KEY3
        AND A.PP_KEY4 = A_PP_KEY4
        AND A.PP_KEY5 = A_PP_KEY5
        AND A.PR = A_OBJECT_ID
        AND UNAPIGEN.USEVERSION('pr', A.PR, A.PR_VERSION) = A_OBJECT_VERSION 
        AND A.AU = D.AU
        AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION 
   ORDER BY A.AU, A.AUSEQ;    

 CURSOR L_MTAU_CURSOR (A_PARENT_ID VARCHAR2, A_PARENT_VERSION VARCHAR2, A_OBJECT_ID VARCHAR2, A_OBJECT_VERSION VARCHAR2) IS
    SELECT A.AU, A.AUSEQ, D.VERSION, A.VALUE, D.DESCRIPTION, D.IS_PROTECTED, D.SINGLE_VALUED,
        D.NEW_VAL_ALLOWED, D.STORE_DB, D.VALUE_LIST_TP,
        D.RUN_MODE, D.SERVICE, D.CF_VALUE
    FROM UTMTAU A,  UTAU D
    WHERE A.MT = A_OBJECT_ID
      AND A.VERSION = A_OBJECT_VERSION
      AND A.AU = D.AU
      AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION
      AND A.AU NOT IN 
     (SELECT DISTINCT E.AU 
       FROM UTPRMTAU E,  UTAU F
       WHERE E.PR = A_PARENT_ID
         AND E.VERSION = A_PARENT_VERSION
         AND E.MT = A_OBJECT_ID
         AND UNAPIGEN.USEVERSION('mt', E.MT, E.MT_VERSION) = A_OBJECT_VERSION 
         AND E.AU = F.AU
         AND UNAPIGEN.USEVERSION('au', E.AU, E.AU_VERSION) = F.VERSION) 
   ORDER BY A.AU, A.AUSEQ;
   
 CURSOR L_PRMTAU_CURSOR (A_PARENT_ID VARCHAR2, A_PARENT_VERSION VARCHAR2, A_OBJECT_ID VARCHAR2, A_OBJECT_VERSION VARCHAR2) IS
    SELECT A.AU, A.AUSEQ, D.VERSION, A.VALUE, D.DESCRIPTION, D.IS_PROTECTED, D.SINGLE_VALUED,
        D.NEW_VAL_ALLOWED, D.STORE_DB, D.VALUE_LIST_TP,
        D.RUN_MODE, D.SERVICE, D.CF_VALUE
    FROM UTPRMTAU A,  UTAU D
    WHERE A.PR = A_PARENT_ID
      AND A.VERSION = A_PARENT_VERSION
      AND A.MT = A_OBJECT_ID
      AND UNAPIGEN.VALIDATEVERSION('mt', A.MT, A.MT_VERSION) = A_OBJECT_VERSION
      AND A.AU = D.AU
      AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION 
   ORDER BY A.AU, A.AUSEQ;
   
   
 CURSOR L_RTPPAU_CURSOR (A_PARENT_ID VARCHAR2, A_PARENT_VERSION VARCHAR2, A_OBJECT_ID VARCHAR2, A_OBJECT_VERSION VARCHAR2, A_PP_KEY1 VARCHAR2, A_PP_KEY2 VARCHAR2, A_PP_KEY3 VARCHAR2, A_PP_KEY4 VARCHAR2, A_PP_KEY5 VARCHAR2) IS
    SELECT A.AU, A.AUSEQ, D.VERSION, A.VALUE, D.DESCRIPTION, D.IS_PROTECTED, D.SINGLE_VALUED,
        D.NEW_VAL_ALLOWED, D.STORE_DB, D.VALUE_LIST_TP,
        D.RUN_MODE, D.SERVICE, D.CF_VALUE
    FROM UTRTPPAU A,  UTAU D
    WHERE A.RT = A_PARENT_ID
        AND A.VERSION = A_PARENT_VERSION
        AND A.PP = A_OBJECT_ID
        AND A.PP_KEY1 = A_PP_KEY1
        AND A.PP_KEY2 = A_PP_KEY2
        AND A.PP_KEY3 = A_PP_KEY3
        AND A.PP_KEY4 = A_PP_KEY4
        AND A.PP_KEY5 = A_PP_KEY5
        AND UNAPIGEN.VALIDATEPPVERSION(A.PP,A.PP_VERSION,A.PP_KEY1,A.PP_KEY2,A.PP_KEY3,A.PP_KEY4,A.PP_KEY5) = A_OBJECT_VERSION
        AND A.AU = D.AU
        AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION 
   ORDER BY A.AU, A.AUSEQ;
   
 CURSOR L_RTSTPPAU_CURSOR (A_PARENT_ID VARCHAR2, A_PARENT_VERSION VARCHAR2, A_OBJECT_ID VARCHAR2, A_OBJECT_VERSION VARCHAR2, A_PP_KEY1 VARCHAR2, A_PP_KEY2 VARCHAR2, A_PP_KEY3 VARCHAR2, A_PP_KEY4 VARCHAR2, A_PP_KEY5 VARCHAR2) IS
    SELECT B.AU, B.AUSEQ, D.VERSION, B.VALUE, D.DESCRIPTION, D.IS_PROTECTED, D.SINGLE_VALUED,
        D.NEW_VAL_ALLOWED, D.STORE_DB, D.VALUE_LIST_TP,
        D.RUN_MODE, D.SERVICE, D.CF_VALUE
    FROM UTRTST A,  UTAU D, UTSTPPAU B
    WHERE A.RT = A_PARENT_ID
        AND A.VERSION = A_PARENT_VERSION
        AND A.ST = B.ST
        AND UNAPIGEN.VALIDATEVERSION('st', A.ST ,A.ST_VERSION) = B.VERSION
        AND B.PP = A_OBJECT_ID
        AND B.PP_KEY1 = A_PP_KEY1
        AND B.PP_KEY2 = A_PP_KEY2
        AND B.PP_KEY3 = A_PP_KEY3
        AND B.PP_KEY4 = A_PP_KEY4
        AND B.PP_KEY5 = A_PP_KEY5
        AND UNAPIGEN.VALIDATEPPVERSION(B.PP,B.PP_VERSION,B.PP_KEY1,B.PP_KEY2,B.PP_KEY3,B.PP_KEY4,B.PP_KEY5) = A_OBJECT_VERSION
        AND B.AU = D.AU
        AND UNAPIGEN.VALIDATEVERSION('au', B.AU, B.AU_VERSION) = D.VERSION 
   ORDER BY B.AU, B.AUSEQ;

CURSOR L_ST_CURSOR (A_SC VARCHAR2) IS
   SELECT ST, ST_VERSION
   FROM UTSC
   WHERE SC=A_SC;

CURSOR L_RT_CURSOR (A_RQ VARCHAR2) IS
   SELECT RT, RT_VERSION
   FROM UTRQ
   WHERE RQ=A_RQ;

CURSOR L_COUNTRQSC_CURSOR (A_RQ VARCHAR2) IS
   SELECT COUNT(SC)
   FROM UTRQSC
   WHERE RQ=A_RQ;
   

   PROCEDURE APPENDATTRIBUTE( AL_TST_TP                IN   VARCHAR2,  
                              AL_TST_ID                IN   VARCHAR2, 
                              AL_TST_ID_VERSION        IN   VARCHAR2,  
                              AL_PP_SEQ                IN   NUMBER,  
                              AL_PR_SEQ                IN   NUMBER,  
                              AL_MT_SEQ                IN   NUMBER,  
                              AL_PP_KEY1               IN   VARCHAR2,  
                              AL_PP_KEY2               IN   VARCHAR2,  
                              AL_PP_KEY3               IN   VARCHAR2,  
                              AL_PP_KEY4               IN   VARCHAR2,  
                              AL_PP_KEY5               IN   VARCHAR2,  
                              AL_AU                    IN   VARCHAR2,  
                              AL_AU_VERSION            IN   VARCHAR2,  
                              AL_VALUE                 IN   VARCHAR2,  
                              AL_DESCRIPTION           IN   VARCHAR2,  
                              AL_IS_PROTECTED          IN   CHAR, 
                              AL_SINGLE_VALUED         IN   CHAR, 
                              AL_NEW_VAL_ALLOWED       IN   CHAR, 
                              AL_STORE_DB              IN   CHAR, 
                              AL_VALUE_LIST_TP         IN   CHAR, 
                              AL_RUN_MODE              IN   CHAR, 
                              AL_SERVICE               IN   VARCHAR2, 
                              AL_CF_VALUE              IN   VARCHAR2 ) IS
    BEGIN

       IF L_CURRENT_ROW >= A_NR_OF_ROWS THEN
          L_SQLERRM := 'Major error: asign attempt outside array limits. nr_of_rows='||A_NR_OF_ROWS||
                       '#tst_tp='||AL_TST_TP||'#tst_id='||AL_TST_ID;
          RAISE STPERROR;
       END IF;
       L_CURRENT_ROW := L_CURRENT_ROW + 1;
       A_TST_TP(L_CURRENT_ROW)          := AL_TST_TP ;
       A_TST_ID(L_CURRENT_ROW)          := AL_TST_ID ;
       A_TST_ID_VERSION(L_CURRENT_ROW)  := AL_TST_ID_VERSION ;
       A_PP_SEQ(L_CURRENT_ROW)          := AL_PP_SEQ;
       A_PR_SEQ(L_CURRENT_ROW)          := AL_PR_SEQ;
       A_MT_SEQ(L_CURRENT_ROW)          := AL_MT_SEQ;
       A_PP_KEY1(L_CURRENT_ROW)         := AL_PP_KEY1;
       A_PP_KEY2(L_CURRENT_ROW)         := AL_PP_KEY2;
       A_PP_KEY3(L_CURRENT_ROW)         := AL_PP_KEY3;
       A_PP_KEY4(L_CURRENT_ROW)         := AL_PP_KEY4;
       A_PP_KEY5(L_CURRENT_ROW)         := AL_PP_KEY5;
       A_AU(L_CURRENT_ROW)              := AL_AU ;
       A_AU_VERSION(L_CURRENT_ROW)      := AL_AU_VERSION ;
       A_VALUE(L_CURRENT_ROW)           := AL_VALUE ;
       A_DESCRIPTION(L_CURRENT_ROW)     := AL_DESCRIPTION ;
       A_IS_PROTECTED(L_CURRENT_ROW)    := AL_IS_PROTECTED ;
       A_SINGLE_VALUED(L_CURRENT_ROW)   := AL_SINGLE_VALUED ;
       A_NEW_VAL_ALLOWED(L_CURRENT_ROW) := AL_NEW_VAL_ALLOWED ;
       A_STORE_DB(L_CURRENT_ROW)        := AL_STORE_DB ;
       A_VALUE_LIST_TP(L_CURRENT_ROW)   := AL_VALUE_LIST_TP ;
       A_RUN_MODE(L_CURRENT_ROW)        := AL_RUN_MODE ;
       A_SERVICE(L_CURRENT_ROW)         := AL_SERVICE ;
       A_CF_VALUE(L_CURRENT_ROW)        := AL_CF_VALUE ;
       
    END APPENDATTRIBUTE;
 
BEGIN

   L_SQLERRM := NULL;
   
   
   L_NOT_ASSIGNED  := 0;
   L_ASSIGNED      := 1;
   L_SOME_ASSIGNED := 2;
  
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_OBJECT_TP, ' ') NOT IN ('rq', 'sc', 'rt', 'st') THEN
      RETURN(UNAPIGEN.DBERR_OBJTP);
   END IF;
   
   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_NOOBJID);
   END IF;
   
   IF NVL(A_NEXT_ROWS, 0) NOT IN (-1, 0, 1) THEN
      RETURN(UNAPIGEN.DBERR_NEXTROWS);
   END IF;

   
   IF A_NEXT_ROWS = -1 THEN
      IF DBMS_SQL.IS_OPEN(L_CONFIG_DETAILS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_CONFIG_DETAILS_CURSOR);
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;
   
   
   IF A_OBJECT_TP IN ('rt', 'st') THEN
       L_REF_OBJECT_TP := A_OBJECT_TP;
       L_REF_OBJECT_ID := A_OBJECT_ID;
       L_REF_OBJECT_VERSION := A_OBJECT_VERSION;
    ELSIF A_OBJECT_TP = 'sc' THEN
       L_REF_OBJECT_TP := 'st';
       OPEN L_ST_CURSOR(A_OBJECT_ID);
       FETCH L_ST_CURSOR
       INTO L_REF_OBJECT_ID, L_REF_OBJECT_VERSION;
       CLOSE L_ST_CURSOR;
    ELSIF A_OBJECT_TP = 'rq' THEN
       L_REF_OBJECT_TP := 'rt';
       OPEN L_RT_CURSOR(A_OBJECT_ID);
       FETCH L_RT_CURSOR
       INTO L_REF_OBJECT_ID, L_REF_OBJECT_VERSION;
       CLOSE L_RT_CURSOR;
    END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN
      
      
      P_NR_OBJECTS :=0;          
                                 
      P_LAST_ROW :=1;            
                                 
      P_LAST_ATTRIBUTE   := -1;  
                                 

      IF NOT DBMS_SQL.IS_OPEN(L_CONFIG_DETAILS_CURSOR) THEN
         
                           
                           
                           
                           
                           L_SQL_STRING    :=         'SELECT 1 mainseq, tst_tp, tst_id,  tst_id_version, tst_description, '
                                                                                    ||'pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, pp_seq, pr, pr_seq, '
                                                                                    ||'mt, mt_seq, tst_nr_measur '
                                                                                    ||'FROM dd'||UNAPIGEN.P_DD||'.uvassignfulltestplan '
                                                                                    ||'WHERE object_tp = '''||L_REF_OBJECT_TP
                                                                                    ||''' AND object_id = '''||REPLACE(L_REF_OBJECT_ID, '''', '''''')           
                                                                                    ||''' AND object_version = '''||REPLACE(L_REF_OBJECT_VERSION, '''', '''''') 
                                                                                    ||''' ORDER BY pp_seq, pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, '
                                                                                    ||'pr_seq, pr, pr_version, mt_seq, mt, mt_version';
                           L_CONFIG_DETAILS_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;
     
      L_FETCHED_ROWS := 0;
   
                  DBMS_SQL.PARSE(L_CONFIG_DETAILS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 1,  L_REC_MAINSEQ             );
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 2,  L_REC_TST_TP,           20);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 3,  L_REC_TST_ID,           20);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 4,  L_REC_TST_ID_VERSION,   20);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 5,  L_REC_TST_DESCRIPTION,  40);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 6,  L_REC_PP,               20);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 7,  L_REC_PP_KEY1,          20);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 8,  L_REC_PP_KEY2,          20);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 9,  L_REC_PP_KEY3,          20);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 10, L_REC_PP_KEY4,          20);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 11, L_REC_PP_KEY5,          20);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 12, L_REC_PP_SEQ              );
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 13, L_REC_PR,               20);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 14, L_REC_PR_SEQ              );
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 15, L_REC_MT,               20);
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 16, L_REC_MT_SEQ              );
                  DBMS_SQL.DEFINE_COLUMN(L_CONFIG_DETAILS_CURSOR, 17, L_REC_TST_NR_MEASUR       );

                  L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_CONFIG_DETAILS_CURSOR);

      LOOP
         EXIT WHEN L_RESULT = 0;

                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 1,  L_REC_MAINSEQ         );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 2,  L_REC_TST_TP          );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 3,  L_REC_TST_ID          );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 4,  L_REC_TST_ID_VERSION  );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 5,  L_REC_TST_DESCRIPTION );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 6,  L_REC_PP              );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 7,  L_REC_PP_KEY1         );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 8,  L_REC_PP_KEY2         );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 9,  L_REC_PP_KEY3         );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 10, L_REC_PP_KEY4         );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 11, L_REC_PP_KEY5         );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 12, L_REC_PP_SEQ          );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 13, L_REC_PR              );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 14, L_REC_PR_SEQ          );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 15, L_REC_MT              );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 16, L_REC_MT_SEQ          );
                           DBMS_SQL.COLUMN_VALUE(L_CONFIG_DETAILS_CURSOR, 17, L_REC_TST_NR_MEASUR   );

         L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
         P_EXT_TST_TP(L_FETCHED_ROWS)         := L_REC_TST_TP;
         P_EXT_TST_ID(L_FETCHED_ROWS)         := L_REC_TST_ID;
         P_EXT_TST_ID_VERSION(L_FETCHED_ROWS) := L_REC_TST_ID_VERSION;
         P_EXT_PP_SEQ(L_FETCHED_ROWS)         := L_REC_PP_SEQ;
         P_EXT_PR_SEQ(L_FETCHED_ROWS)         := L_REC_PR_SEQ;
         P_EXT_MT_SEQ(L_FETCHED_ROWS)         := L_REC_MT_SEQ;
         P_EXT_PP_KEY1(L_FETCHED_ROWS)        := L_REC_PP_KEY1;
         P_EXT_PP_KEY2(L_FETCHED_ROWS)        := L_REC_PP_KEY2;
         P_EXT_PP_KEY3(L_FETCHED_ROWS)        := L_REC_PP_KEY3;
         P_EXT_PP_KEY4(L_FETCHED_ROWS)        := L_REC_PP_KEY4;
         P_EXT_PP_KEY5(L_FETCHED_ROWS)        := L_REC_PP_KEY5;
         
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_CONFIG_DETAILS_CURSOR);
      END LOOP;
      DBMS_SQL.CLOSE_CURSOR(L_CONFIG_DETAILS_CURSOR);
      P_NR_OBJECTS := L_FETCHED_ROWS;
   ELSIF NVL(A_NEXT_ROWS,0) = 1 THEN
      L_CURRENT_PP := P_CURRENT_PP;
      L_CURRENT_PP_SEQ := P_CURRENT_PP_SEQ;
      L_CURRENT_PR_SEQ := P_CURRENT_PR_SEQ;
      L_CURRENT_MT_SEQ := P_CURRENT_MT_SEQ;
      L_CURRENT_PP_KEY1 := P_CURRENT_PP_KEY1;
      L_CURRENT_PP_KEY2 := P_CURRENT_PP_KEY2;
      L_CURRENT_PP_KEY3 := P_CURRENT_PP_KEY3;
      L_CURRENT_PP_KEY4 := P_CURRENT_PP_KEY4;
      L_CURRENT_PP_KEY5 := P_CURRENT_PP_KEY5;
      L_CURRENT_PP_VERSION := P_CURRENT_PP_VERSION;
      L_CURRENT_PR := P_CURRENT_PR;
      L_CURRENT_PR_VERSION := P_CURRENT_PR_VERSION;
   ELSE
      
      P_EXT_TST_TP.DELETE;
      P_EXT_TST_ID.DELETE;
      P_EXT_TST_ID_VERSION.DELETE;
      P_EXT_PP_SEQ.DELETE;
      P_EXT_PR_SEQ.DELETE;
      P_EXT_MT_SEQ.DELETE;
      P_EXT_PP_KEY1.DELETE;
      P_EXT_PP_KEY2.DELETE;
      P_EXT_PP_KEY3.DELETE;
      P_EXT_PP_KEY4.DELETE;
      P_EXT_PP_KEY5.DELETE;
      P_NR_OBJECTS := -1;
      P_LAST_ROW   := -1;
      P_LAST_ATTRIBUTE   := -1;
      RETURN(UNAPIGEN.DBERR_SUCCESS);   
   END IF;

   IF P_LAST_ROW = -1 THEN 
     RETURN(UNAPIGEN.DBERR_NOCURSOR);
   END IF;
 
   L_CURRENT_ROW := 0;
   L_LAST_ROW :=0;
 
   FOR L_ROW IN P_LAST_ROW..P_NR_OBJECTS LOOP
      L_LAST_ROW := L_ROW;
      L_AU_FOUND := 0;
      
      
      
      IF P_EXT_TST_TP(L_ROW) = 'pp' THEN
         L_CURRENT_PP := P_EXT_TST_ID(L_ROW);
         L_CURRENT_PR := '';
         L_CURRENT_MT := '';
         L_CURRENT_PP_VERSION := P_EXT_TST_ID_VERSION(L_ROW);
         L_CURRENT_PP_SEQ := P_EXT_PP_SEQ(L_ROW);
         L_CURRENT_PR_SEQ := P_EXT_PR_SEQ(L_ROW);
         L_CURRENT_MT_SEQ := P_EXT_MT_SEQ(L_ROW);
         L_CURRENT_PP_KEY1 := P_EXT_PP_KEY1(L_ROW);
         L_CURRENT_PP_KEY2 := P_EXT_PP_KEY2(L_ROW);
         L_CURRENT_PP_KEY3 := P_EXT_PP_KEY3(L_ROW);
         L_CURRENT_PP_KEY4 := P_EXT_PP_KEY4(L_ROW);
         L_CURRENT_PP_KEY5 := P_EXT_PP_KEY5(L_ROW);
         IF L_REF_OBJECT_TP = 'st' THEN
            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               FOR L_STPPAU_REC IN L_STPPAU_CURSOR(L_REF_OBJECT_ID, L_REF_OBJECT_VERSION, P_EXT_TST_ID(L_ROW), P_EXT_TST_ID_VERSION(L_ROW), P_EXT_PP_KEY1(L_ROW), P_EXT_PP_KEY2(L_ROW), P_EXT_PP_KEY3(L_ROW), P_EXT_PP_KEY4(L_ROW), P_EXT_PP_KEY5(L_ROW) ) LOOP
                  L_AU_FOUND :=L_AU_FOUND +1;
                  EXIT WHEN L_STPPAU_CURSOR%NOTFOUND; 
                  
                  
                  
                  
                  
                  
                  
                  IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN 
                     APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                     P_EXT_TST_ID(L_ROW), 
                                     P_EXT_TST_ID_VERSION(L_ROW),  
                                     P_EXT_PP_SEQ(L_ROW),  
                                     P_EXT_PR_SEQ(L_ROW),  
                                     P_EXT_MT_SEQ(L_ROW),  
                                     P_EXT_PP_KEY1(L_ROW),  
                                     P_EXT_PP_KEY2(L_ROW),  
                                     P_EXT_PP_KEY3(L_ROW),  
                                     P_EXT_PP_KEY4(L_ROW),  
                                     P_EXT_PP_KEY5(L_ROW),  
                                     L_STPPAU_REC.AU,
                                     L_STPPAU_REC.VERSION,
                                     L_STPPAU_REC.VALUE,
                                     L_STPPAU_REC.DESCRIPTION,
                                     L_STPPAU_REC.IS_PROTECTED,
                                     L_STPPAU_REC.SINGLE_VALUED,
                                     L_STPPAU_REC.NEW_VAL_ALLOWED,
                                     L_STPPAU_REC.STORE_DB,
                                     L_STPPAU_REC.VALUE_LIST_TP,
                                     L_STPPAU_REC.RUN_MODE,
                                     L_STPPAU_REC.SERVICE,
                                     L_STPPAU_REC.CF_VALUE);
                  END IF;
                  EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
               END LOOP;
            END IF;
            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               FOR L_REC IN L_PPAU_CURSOR(L_REF_OBJECT_ID, L_REF_OBJECT_VERSION, P_EXT_TST_ID(L_ROW), P_EXT_TST_ID_VERSION(L_ROW), P_EXT_PP_KEY1(L_ROW), P_EXT_PP_KEY2(L_ROW), P_EXT_PP_KEY3(L_ROW), P_EXT_PP_KEY4(L_ROW), P_EXT_PP_KEY5(L_ROW)  ) LOOP
                  L_AU_FOUND :=L_AU_FOUND +1;
                  EXIT WHEN L_PPAU_CURSOR%NOTFOUND;  
                  
                  
                  IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN
                     APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                     P_EXT_TST_ID(L_ROW), 
                                     P_EXT_TST_ID_VERSION(L_ROW),  
                                     P_EXT_PP_SEQ(L_ROW),  
                                     P_EXT_PR_SEQ(L_ROW),  
                                     P_EXT_MT_SEQ(L_ROW),  
                                     P_EXT_PP_KEY1(L_ROW),  
                                     P_EXT_PP_KEY2(L_ROW),  
                                     P_EXT_PP_KEY3(L_ROW),  
                                     P_EXT_PP_KEY4(L_ROW),  
                                     P_EXT_PP_KEY5(L_ROW),  
                                     L_REC.AU,
                                     L_REC.VERSION,
                                     L_REC.VALUE,
                                     L_REC.DESCRIPTION,
                                     L_REC.IS_PROTECTED,
                                     L_REC.SINGLE_VALUED,
                                     L_REC.NEW_VAL_ALLOWED,
                                     L_REC.STORE_DB,
                                     L_REC.VALUE_LIST_TP,
                                     L_REC.RUN_MODE,
                                     L_REC.SERVICE,
                                     L_REC.CF_VALUE);
                  END IF;
                  EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
               END LOOP;
            END IF;
            
            
            
            
            
            
            
            
            
            
            
            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               IF L_AU_FOUND = 0 AND ( P_LAST_ATTRIBUTE = -1 OR L_ROW >  P_LAST_ROW ) THEN  
                  
                  APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                  P_EXT_TST_ID(L_ROW), 
                                  P_EXT_TST_ID_VERSION(L_ROW),  
                                  P_EXT_PP_SEQ(L_ROW),  
                                  P_EXT_PR_SEQ(L_ROW),  
                                  P_EXT_MT_SEQ(L_ROW),  
                                  P_EXT_PP_KEY1(L_ROW),  
                                  P_EXT_PP_KEY2(L_ROW),  
                                  P_EXT_PP_KEY3(L_ROW),  
                                  P_EXT_PP_KEY4(L_ROW),  
                                  P_EXT_PP_KEY5(L_ROW),  
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '');
                END IF;
             END IF;
             EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
         ELSIF L_REF_OBJECT_TP = 'rt' THEN
            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               FOR L_RTPPAU_REC IN L_RTPPAU_CURSOR(L_REF_OBJECT_ID, L_REF_OBJECT_VERSION, P_EXT_TST_ID(L_ROW), P_EXT_TST_ID_VERSION(L_ROW), P_EXT_PP_KEY1(L_ROW), P_EXT_PP_KEY2(L_ROW), P_EXT_PP_KEY3(L_ROW), P_EXT_PP_KEY4(L_ROW), P_EXT_PP_KEY5(L_ROW)  ) LOOP
                  L_AU_FOUND :=L_AU_FOUND +1;
                  EXIT WHEN L_RTPPAU_CURSOR%NOTFOUND; 
                  
                  
                  IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN
                     APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                     P_EXT_TST_ID(L_ROW), 
                                     P_EXT_TST_ID_VERSION(L_ROW),  
                                     P_EXT_PP_SEQ(L_ROW),  
                                     P_EXT_PR_SEQ(L_ROW),  
                                     P_EXT_MT_SEQ(L_ROW),  
                                     P_EXT_PP_KEY1(L_ROW),  
                                     P_EXT_PP_KEY2(L_ROW),  
                                     P_EXT_PP_KEY3(L_ROW),  
                                     P_EXT_PP_KEY4(L_ROW),  
                                     P_EXT_PP_KEY5(L_ROW),  
                                     L_RTPPAU_REC.AU,
                                     L_RTPPAU_REC.VERSION,
                                     L_RTPPAU_REC.VALUE,
                                     L_RTPPAU_REC.DESCRIPTION,
                                     L_RTPPAU_REC.IS_PROTECTED,
                                     L_RTPPAU_REC.SINGLE_VALUED,
                                     L_RTPPAU_REC.NEW_VAL_ALLOWED,
                                     L_RTPPAU_REC.STORE_DB,
                                     L_RTPPAU_REC.VALUE_LIST_TP,
                                     L_RTPPAU_REC.RUN_MODE,
                                     L_RTPPAU_REC.SERVICE,
                                     L_RTPPAU_REC.CF_VALUE);
                  END IF;
                  EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
               END LOOP;
            END IF;
            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               FOR L_RTSTPPAU_REC IN L_RTSTPPAU_CURSOR(L_REF_OBJECT_ID, L_REF_OBJECT_VERSION, P_EXT_TST_ID(L_ROW), P_EXT_TST_ID_VERSION(L_ROW), P_EXT_PP_KEY1(L_ROW), P_EXT_PP_KEY2(L_ROW), P_EXT_PP_KEY3(L_ROW), P_EXT_PP_KEY4(L_ROW), P_EXT_PP_KEY5(L_ROW) ) LOOP
                  L_AU_FOUND :=L_AU_FOUND +1;
                  EXIT WHEN L_RTSTPPAU_CURSOR%NOTFOUND; 
                  
                  
                  IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN
                     APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                     P_EXT_TST_ID(L_ROW), 
                                     P_EXT_TST_ID_VERSION(L_ROW),  
                                     P_EXT_PP_SEQ(L_ROW),  
                                     P_EXT_PR_SEQ(L_ROW),  
                                     P_EXT_MT_SEQ(L_ROW),  
                                     P_EXT_PP_KEY1(L_ROW),  
                                     P_EXT_PP_KEY2(L_ROW),  
                                     P_EXT_PP_KEY3(L_ROW),  
                                     P_EXT_PP_KEY4(L_ROW),  
                                     P_EXT_PP_KEY5(L_ROW),  
                                     L_RTSTPPAU_REC.AU,
                                     L_RTSTPPAU_REC.VERSION,
                                     L_RTSTPPAU_REC.VALUE,
                                     L_RTSTPPAU_REC.DESCRIPTION,
                                     L_RTSTPPAU_REC.IS_PROTECTED,
                                     L_RTSTPPAU_REC.SINGLE_VALUED,
                                     L_RTSTPPAU_REC.NEW_VAL_ALLOWED,
                                     L_RTSTPPAU_REC.STORE_DB,
                                     L_RTSTPPAU_REC.VALUE_LIST_TP,
                                     L_RTSTPPAU_REC.RUN_MODE,
                                     L_RTSTPPAU_REC.SERVICE,
                                     L_RTSTPPAU_REC.CF_VALUE);
                  END IF;
                  EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
               END LOOP;
            END IF;
            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               FOR L_REC IN L_PPAU_CURSOR(L_REF_OBJECT_ID, L_REF_OBJECT_VERSION, P_EXT_TST_ID(L_ROW), P_EXT_TST_ID_VERSION(L_ROW) ,  P_EXT_PP_KEY1(L_ROW), P_EXT_PP_KEY2(L_ROW), P_EXT_PP_KEY3(L_ROW), P_EXT_PP_KEY4(L_ROW), P_EXT_PP_KEY5(L_ROW) ) LOOP
                  L_AU_FOUND :=L_AU_FOUND +1;
                  EXIT WHEN L_PPAU_CURSOR%NOTFOUND;  
                  
                  
                  IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN
                     APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                     P_EXT_TST_ID(L_ROW), 
                                     P_EXT_TST_ID_VERSION(L_ROW),  
                                     P_EXT_PP_SEQ(L_ROW),  
                                     P_EXT_PR_SEQ(L_ROW),  
                                     P_EXT_MT_SEQ(L_ROW),  
                                     P_EXT_PP_KEY1(L_ROW),  
                                     P_EXT_PP_KEY2(L_ROW),  
                                     P_EXT_PP_KEY3(L_ROW),  
                                     P_EXT_PP_KEY4(L_ROW),  
                                     P_EXT_PP_KEY5(L_ROW),  
                                     L_REC.AU,
                                     L_REC.VERSION,
                                     L_REC.VALUE,
                                     L_REC.DESCRIPTION,
                                     L_REC.IS_PROTECTED,
                                     L_REC.SINGLE_VALUED,
                                     L_REC.NEW_VAL_ALLOWED,
                                     L_REC.STORE_DB,
                                     L_REC.VALUE_LIST_TP,
                                     L_REC.RUN_MODE,
                                     L_REC.SERVICE,
                                     L_REC.CF_VALUE);
                  END IF;
                  EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
               END LOOP;
            END IF;
            
            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               IF L_AU_FOUND = 0 AND ( P_LAST_ATTRIBUTE = -1 OR L_ROW >  P_LAST_ROW ) THEN
                  
                  APPENDATTRIBUTE(  P_EXT_TST_TP(L_ROW),  
                                 P_EXT_TST_ID(L_ROW), 
                                 P_EXT_TST_ID_VERSION(L_ROW),  
                                 P_EXT_PP_SEQ(L_ROW),  
                                 P_EXT_PR_SEQ(L_ROW),  
                                 P_EXT_MT_SEQ(L_ROW),  
                                 P_EXT_PP_KEY1(L_ROW),  
                                 P_EXT_PP_KEY2(L_ROW),  
                                 P_EXT_PP_KEY3(L_ROW),  
                                 P_EXT_PP_KEY4(L_ROW),  
                                 P_EXT_PP_KEY5(L_ROW),  
                                 '',
                                 '',
                                 '',
                                 '',
                                 '',
                                 '',
                                 '',
                                 '',
                                 '',
                                 '',
                                 '',
                                 '');
               END IF;
            END IF;
            EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
         END IF;
      
      
      
      ELSIF P_EXT_TST_TP(L_ROW) = 'px' THEN
         IF L_REF_OBJECT_TP = 'st' THEN
            

            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               FOR L_REC IN L_PPAU_CURSOR(L_REF_OBJECT_TP, L_REF_OBJECT_VERSION, P_EXT_TST_ID(L_ROW),  P_EXT_TST_ID_VERSION(L_ROW), P_EXT_PP_KEY1(L_ROW), P_EXT_PP_KEY2(L_ROW), P_EXT_PP_KEY3(L_ROW), P_EXT_PP_KEY4(L_ROW), P_EXT_PP_KEY5(L_ROW)  ) LOOP
                  L_AU_FOUND :=L_AU_FOUND +1;
                  EXIT WHEN L_PPAU_CURSOR%NOTFOUND; 
                  
                  
                  IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN 
                     APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                     P_EXT_TST_ID(L_ROW), 
                                     P_EXT_TST_ID_VERSION(L_ROW),  
                                     P_EXT_PP_SEQ(L_ROW),  
                                     P_EXT_PR_SEQ(L_ROW),  
                                     P_EXT_MT_SEQ(L_ROW),  
                                     P_EXT_PP_KEY1(L_ROW),  
                                     P_EXT_PP_KEY2(L_ROW),  
                                     P_EXT_PP_KEY3(L_ROW),  
                                     P_EXT_PP_KEY4(L_ROW),  
                                     P_EXT_PP_KEY5(L_ROW),  
                                     L_REC.AU,
                                     L_REC.VERSION,
                                     L_REC.VALUE,
                                     L_REC.DESCRIPTION,
                                     L_REC.IS_PROTECTED,
                                     L_REC.SINGLE_VALUED,
                                     L_REC.NEW_VAL_ALLOWED,
                                     L_REC.STORE_DB,
                                     L_REC.VALUE_LIST_TP,
                                     L_REC.RUN_MODE,
                                     L_REC.SERVICE,
                                     L_REC.CF_VALUE);
                  END IF;
                  EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
               END LOOP;
            END IF;
            
            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               IF L_AU_FOUND = 0 AND ( P_LAST_ATTRIBUTE >0 OR L_ROW >  P_LAST_ROW ) THEN
                  
                  APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                  P_EXT_TST_ID(L_ROW), 
                                  P_EXT_TST_ID_VERSION(L_ROW),  
                                  P_EXT_PP_SEQ(L_ROW),  
                                  P_EXT_PR_SEQ(L_ROW),  
                                  P_EXT_MT_SEQ(L_ROW),  
                                  P_EXT_PP_KEY1(L_ROW),  
                                  P_EXT_PP_KEY2(L_ROW),  
                                  P_EXT_PP_KEY3(L_ROW),  
                                  P_EXT_PP_KEY4(L_ROW),  
                                  P_EXT_PP_KEY5(L_ROW),  
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '');
               END IF;
            END IF;
            EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
         ELSIF L_REF_OBJECT_TP = 'rt' THEN
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               
               FOR L_RTPPAU_REC IN L_RTPPAU_CURSOR(L_REF_OBJECT_ID, L_REF_OBJECT_VERSION, P_EXT_TST_ID(L_ROW), P_EXT_TST_ID_VERSION(L_ROW) ,  P_EXT_PP_KEY1(L_ROW), P_EXT_PP_KEY2(L_ROW), P_EXT_PP_KEY3(L_ROW), P_EXT_PP_KEY4(L_ROW), P_EXT_PP_KEY5(L_ROW) ) LOOP
                  L_AU_FOUND :=L_AU_FOUND +1;
                  EXIT WHEN L_RTPPAU_CURSOR%NOTFOUND; 
                  
                  
                  IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN
                     APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                     P_EXT_TST_ID(L_ROW), 
                                     P_EXT_TST_ID_VERSION(L_ROW),  
                                     P_EXT_PP_SEQ(L_ROW),  
                                     P_EXT_PR_SEQ(L_ROW),  
                                     P_EXT_MT_SEQ(L_ROW),  
                                     P_EXT_PP_KEY1(L_ROW),  
                                     P_EXT_PP_KEY2(L_ROW),  
                                     P_EXT_PP_KEY3(L_ROW),  
                                     P_EXT_PP_KEY4(L_ROW),  
                                     P_EXT_PP_KEY5(L_ROW),  
                                     L_RTPPAU_REC.AU,
                                     L_RTPPAU_REC.VERSION,
                                     L_RTPPAU_REC.VALUE,
                                     L_RTPPAU_REC.DESCRIPTION,
                                     L_RTPPAU_REC.IS_PROTECTED,
                                     L_RTPPAU_REC.SINGLE_VALUED,
                                     L_RTPPAU_REC.NEW_VAL_ALLOWED,
                                     L_RTPPAU_REC.STORE_DB,
                                     L_RTPPAU_REC.VALUE_LIST_TP,
                                     L_RTPPAU_REC.RUN_MODE,
                                     L_RTPPAU_REC.SERVICE,
                                     L_RTPPAU_REC.CF_VALUE);
                  END IF;
                  EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
               END LOOP;
            END IF;
            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               FOR L_RTSTPPAU_REC IN L_RTSTPPAU_CURSOR(L_REF_OBJECT_ID, L_REF_OBJECT_VERSION, P_EXT_TST_ID(L_ROW), P_EXT_TST_ID_VERSION(L_ROW) , P_EXT_PP_KEY1(L_ROW), P_EXT_PP_KEY2(L_ROW), P_EXT_PP_KEY3(L_ROW), P_EXT_PP_KEY4(L_ROW), P_EXT_PP_KEY5(L_ROW) ) LOOP
                  L_AU_FOUND :=L_AU_FOUND +1;
                  EXIT WHEN L_RTSTPPAU_CURSOR%NOTFOUND; 
                  
                  
                  IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN
                     APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                     P_EXT_TST_ID(L_ROW), 
                                     P_EXT_TST_ID_VERSION(L_ROW),  
                                     P_EXT_PP_SEQ(L_ROW),  
                                     P_EXT_PR_SEQ(L_ROW),  
                                     P_EXT_MT_SEQ(L_ROW),  
                                     P_EXT_PP_KEY1(L_ROW),  
                                     P_EXT_PP_KEY2(L_ROW),  
                                     P_EXT_PP_KEY3(L_ROW),  
                                     P_EXT_PP_KEY4(L_ROW),  
                                     P_EXT_PP_KEY5(L_ROW),  
                                     L_RTSTPPAU_REC.AU,
                                     L_RTSTPPAU_REC.VERSION,
                                     L_RTSTPPAU_REC.VALUE,
                                     L_RTSTPPAU_REC.DESCRIPTION,
                                     L_RTSTPPAU_REC.IS_PROTECTED,
                                     L_RTSTPPAU_REC.SINGLE_VALUED,
                                     L_RTSTPPAU_REC.NEW_VAL_ALLOWED,
                                     L_RTSTPPAU_REC.STORE_DB,
                                     L_RTSTPPAU_REC.VALUE_LIST_TP,
                                     L_RTSTPPAU_REC.RUN_MODE,
                                     L_RTSTPPAU_REC.SERVICE,
                                     L_RTSTPPAU_REC.CF_VALUE);
                  END IF;
                  EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
               END LOOP;
            END IF;
            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               FOR L_REC IN L_PPAU_CURSOR(L_REF_OBJECT_ID, L_REF_OBJECT_VERSION, P_EXT_TST_ID(L_ROW), P_EXT_TST_ID_VERSION(L_ROW) , P_EXT_PP_KEY1(L_ROW), P_EXT_PP_KEY2(L_ROW), P_EXT_PP_KEY3(L_ROW), P_EXT_PP_KEY4(L_ROW), P_EXT_PP_KEY5(L_ROW) ) LOOP
                  L_AU_FOUND :=L_AU_FOUND +1;
                  EXIT WHEN L_PPAU_CURSOR%NOTFOUND;  
                  
                  
                  IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN
                     APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                     P_EXT_TST_ID(L_ROW), 
                                     P_EXT_TST_ID_VERSION(L_ROW),  
                                     P_EXT_PP_SEQ(L_ROW),  
                                     P_EXT_PR_SEQ(L_ROW),  
                                     P_EXT_MT_SEQ(L_ROW),  
                                     P_EXT_PP_KEY1(L_ROW),  
                                     P_EXT_PP_KEY2(L_ROW),  
                                     P_EXT_PP_KEY3(L_ROW),  
                                     P_EXT_PP_KEY4(L_ROW),  
                                     P_EXT_PP_KEY5(L_ROW),  
                                     L_REC.AU,
                                     L_REC.VERSION,
                                     L_REC.VALUE,
                                     L_REC.DESCRIPTION,
                                     L_REC.IS_PROTECTED,
                                     L_REC.SINGLE_VALUED,
                                     L_REC.NEW_VAL_ALLOWED,
                                     L_REC.STORE_DB,
                                     L_REC.VALUE_LIST_TP,
                                     L_REC.RUN_MODE,
                                     L_REC.SERVICE,
                                     L_REC.CF_VALUE);
                  END IF;
                  EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
               END LOOP;
            END IF;
            
            
            IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
               IF L_AU_FOUND = 0 AND ( P_LAST_ATTRIBUTE = -1 OR L_ROW >  P_LAST_ROW ) THEN
                  
                    APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                    P_EXT_TST_ID(L_ROW), 
                                    P_EXT_TST_ID_VERSION(L_ROW),  
                                    P_EXT_PP_SEQ(L_ROW),  
                                    P_EXT_PR_SEQ(L_ROW),  
                                    P_EXT_MT_SEQ(L_ROW),  
                                    P_EXT_PP_KEY1(L_ROW),  
                                    P_EXT_PP_KEY2(L_ROW),  
                                    P_EXT_PP_KEY3(L_ROW),  
                                    P_EXT_PP_KEY4(L_ROW),  
                                    P_EXT_PP_KEY5(L_ROW),  
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '');
               END IF;
            END IF;
            EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
         END IF;
      
      
      
      ELSIF P_EXT_TST_TP(L_ROW) = 'pr' THEN
         L_CURRENT_PR := P_EXT_TST_ID(L_ROW);
         L_CURRENT_PR_VERSION := P_EXT_TST_ID_VERSION(L_ROW);
         L_CURRENT_MT := '';
         
         IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
            FOR L_REC IN L_PPPRAU_CURSOR(L_CURRENT_PP, L_CURRENT_PP_VERSION, P_EXT_TST_ID(L_ROW),  P_EXT_TST_ID_VERSION(L_ROW), P_EXT_PP_KEY1(L_ROW), P_EXT_PP_KEY2(L_ROW), P_EXT_PP_KEY3(L_ROW), P_EXT_PP_KEY4(L_ROW), P_EXT_PP_KEY5(L_ROW)  ) LOOP
               L_AU_FOUND :=L_AU_FOUND +1;
               EXIT WHEN L_PPPRAU_CURSOR%NOTFOUND; 
               
               
               IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN 
                  APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                  P_EXT_TST_ID(L_ROW), 
                                  P_EXT_TST_ID_VERSION(L_ROW),  
                                  P_EXT_PP_SEQ(L_ROW),  
                                  P_EXT_PR_SEQ(L_ROW),  
                                  P_EXT_MT_SEQ(L_ROW),  
                                  P_EXT_PP_KEY1(L_ROW),  
                                  P_EXT_PP_KEY2(L_ROW),  
                                  P_EXT_PP_KEY3(L_ROW),  
                                  P_EXT_PP_KEY4(L_ROW),  
                                  P_EXT_PP_KEY5(L_ROW),  
                                  L_REC.AU,
                                  L_REC.VERSION,
                                  L_REC.VALUE,
                                  L_REC.DESCRIPTION,
                                  L_REC.IS_PROTECTED,
                                  L_REC.SINGLE_VALUED,
                                  L_REC.NEW_VAL_ALLOWED,
                                  L_REC.STORE_DB,
                                  L_REC.VALUE_LIST_TP,
                                  L_REC.RUN_MODE,
                                  L_REC.SERVICE,
                                  L_REC.CF_VALUE);
               END IF;
               EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
            END LOOP;
         END IF;
         IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
            
            FOR L_REC IN L_PRAU_CURSOR(L_CURRENT_PP, L_CURRENT_PP_VERSION, P_EXT_TST_ID(L_ROW), P_EXT_TST_ID_VERSION(L_ROW) , P_EXT_PP_KEY1(L_ROW), P_EXT_PP_KEY2(L_ROW), P_EXT_PP_KEY3(L_ROW), P_EXT_PP_KEY4(L_ROW), P_EXT_PP_KEY5(L_ROW) ) LOOP
               L_AU_FOUND :=L_AU_FOUND +1;
               EXIT WHEN L_PRAU_CURSOR%NOTFOUND; 
               
               
               IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN 
                  APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                  P_EXT_TST_ID(L_ROW), 
                                  P_EXT_TST_ID_VERSION(L_ROW),  
                                  P_EXT_PP_SEQ(L_ROW),  
                                  P_EXT_PR_SEQ(L_ROW),  
                                  P_EXT_MT_SEQ(L_ROW),  
                                  P_EXT_PP_KEY1(L_ROW),  
                                  P_EXT_PP_KEY2(L_ROW),  
                                  P_EXT_PP_KEY3(L_ROW),  
                                  P_EXT_PP_KEY4(L_ROW),  
                                  P_EXT_PP_KEY5(L_ROW),  
                                  L_REC.AU,
                                  L_REC.VERSION,
                                  L_REC.VALUE,
                                  L_REC.DESCRIPTION,
                                  L_REC.IS_PROTECTED,
                                  L_REC.SINGLE_VALUED,
                                  L_REC.NEW_VAL_ALLOWED,
                                  L_REC.STORE_DB,
                                  L_REC.VALUE_LIST_TP,
                                  L_REC.RUN_MODE,
                                  L_REC.SERVICE,
                                  L_REC.CF_VALUE);
               END IF;
               EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
            END LOOP;
         END IF;
         
         
         IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
            IF L_AU_FOUND = 0 AND ( P_LAST_ATTRIBUTE >0 OR L_ROW >  P_LAST_ROW ) THEN
               
               APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                               P_EXT_TST_ID(L_ROW), 
                               P_EXT_TST_ID_VERSION(L_ROW),  
                               P_EXT_PP_SEQ(L_ROW),  
                               P_EXT_PR_SEQ(L_ROW),  
                               P_EXT_MT_SEQ(L_ROW),  
                               P_EXT_PP_KEY1(L_ROW),  
                               P_EXT_PP_KEY2(L_ROW),  
                               P_EXT_PP_KEY3(L_ROW),  
                               P_EXT_PP_KEY4(L_ROW),  
                               P_EXT_PP_KEY5(L_ROW),  
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '');
            END IF;
         END IF;
         EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
      
      
      
      ELSIF P_EXT_TST_TP(L_ROW) = 'mt' THEN
         
         L_CURRENT_MT := P_EXT_TST_ID(L_ROW);
         L_CURRENT_MT_VERSION := P_EXT_TST_ID_VERSION(L_ROW);
         IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
            FOR L_REC IN L_PRMTAU_CURSOR(L_CURRENT_PR, L_CURRENT_PR_VERSION, P_EXT_TST_ID(L_ROW), P_EXT_TST_ID_VERSION(L_ROW) ) LOOP
               L_AU_FOUND :=L_AU_FOUND +1;
               EXIT WHEN L_PRMTAU_CURSOR%NOTFOUND;
               
               
               IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN  
                  APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                  P_EXT_TST_ID(L_ROW), 
                                  P_EXT_TST_ID_VERSION(L_ROW),  
                                  P_EXT_PP_SEQ(L_ROW),  
                                  P_EXT_PR_SEQ(L_ROW),  
                                  P_EXT_MT_SEQ(L_ROW),  
                                  P_EXT_PP_KEY1(L_ROW),  
                                  P_EXT_PP_KEY2(L_ROW),  
                                  P_EXT_PP_KEY3(L_ROW),  
                                  P_EXT_PP_KEY4(L_ROW),  
                                  P_EXT_PP_KEY5(L_ROW),  
                                  L_REC.AU,
                                  L_REC.VERSION,
                                  L_REC.VALUE,
                                  L_REC.DESCRIPTION,
                                  L_REC.IS_PROTECTED,
                                  L_REC.SINGLE_VALUED,
                                  L_REC.NEW_VAL_ALLOWED,
                                  L_REC.STORE_DB,
                                  L_REC.VALUE_LIST_TP,
                                  L_REC.RUN_MODE,
                                  L_REC.SERVICE,
                                  L_REC.CF_VALUE);
               END IF;
               EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
            END LOOP;
         END IF;       
         
         IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
            FOR L_REC IN L_MTAU_CURSOR(L_CURRENT_PR, L_CURRENT_PR_VERSION, P_EXT_TST_ID(L_ROW), P_EXT_TST_ID_VERSION(L_ROW) ) LOOP
               L_AU_FOUND :=L_AU_FOUND +1;
               EXIT WHEN L_MTAU_CURSOR%NOTFOUND OR L_CURRENT_ROW >= A_NR_OF_ROWS; 
               
               
               IF ( L_AU_FOUND > P_LAST_ATTRIBUTE OR L_ROW >  P_LAST_ROW ) THEN 
                  APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                                  P_EXT_TST_ID(L_ROW), 
                                  P_EXT_TST_ID_VERSION(L_ROW),  
                                  P_EXT_PP_SEQ(L_ROW),  
                                  P_EXT_PR_SEQ(L_ROW),  
                                  P_EXT_MT_SEQ(L_ROW),  
                                  P_EXT_PP_KEY1(L_ROW),  
                                  P_EXT_PP_KEY2(L_ROW),  
                                  P_EXT_PP_KEY3(L_ROW),  
                                  P_EXT_PP_KEY4(L_ROW),  
                                  P_EXT_PP_KEY5(L_ROW),  
                                  L_REC.AU,
                                  L_REC.VERSION,
                                  L_REC.VALUE,
                                  L_REC.DESCRIPTION,
                                  L_REC.IS_PROTECTED,
                                  L_REC.SINGLE_VALUED,
                                  L_REC.NEW_VAL_ALLOWED,
                                  L_REC.STORE_DB,
                                  L_REC.VALUE_LIST_TP,
                                  L_REC.RUN_MODE,
                                  L_REC.SERVICE,
                                  L_REC.CF_VALUE);
               END IF;
               EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
            END LOOP;
         END IF;
         
         
         IF L_CURRENT_ROW < A_NR_OF_ROWS THEN
            IF L_AU_FOUND = 0 AND ( P_LAST_ATTRIBUTE >0 OR L_ROW >  P_LAST_ROW )  THEN
               
               APPENDATTRIBUTE(P_EXT_TST_TP(L_ROW),  
                               P_EXT_TST_ID(L_ROW), 
                               P_EXT_TST_ID_VERSION(L_ROW),  
                               P_EXT_PP_SEQ(L_ROW),  
                               P_EXT_PR_SEQ(L_ROW),  
                               P_EXT_MT_SEQ(L_ROW),  
                               P_EXT_PP_KEY1(L_ROW),  
                               P_EXT_PP_KEY2(L_ROW),  
                               P_EXT_PP_KEY3(L_ROW),  
                               P_EXT_PP_KEY4(L_ROW),  
                               P_EXT_PP_KEY5(L_ROW),  
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '',
                               '');
           END IF;
        END IF;
        EXIT WHEN L_CURRENT_ROW >= A_NR_OF_ROWS; 
     END IF;
   END LOOP;

   IF  (L_CURRENT_ROW >= A_NR_OF_ROWS) THEN
      
      P_CURRENT_PP := L_CURRENT_PP;
      P_CURRENT_PP_VERSION := L_CURRENT_PP_VERSION;
      P_CURRENT_PP_SEQ := L_CURRENT_PP_SEQ;
      P_CURRENT_PR_SEQ := L_CURRENT_PR_SEQ;
      P_CURRENT_MT_SEQ := L_CURRENT_MT_SEQ;
      P_CURRENT_PP_KEY1 := L_CURRENT_PP_KEY1;
      P_CURRENT_PP_KEY2 := L_CURRENT_PP_KEY2;
      P_CURRENT_PP_KEY3 := L_CURRENT_PP_KEY3;
      P_CURRENT_PP_KEY4 := L_CURRENT_PP_KEY4;
      P_CURRENT_PP_KEY5 := L_CURRENT_PP_KEY5;
      P_CURRENT_PR := L_CURRENT_PR;
      P_CURRENT_PR_VERSION := L_CURRENT_PR_VERSION;
      P_LAST_ROW := L_LAST_ROW;
      P_LAST_ATTRIBUTE := L_AU_FOUND;
   ELSE
      P_EXT_TST_TP.DELETE;
      P_EXT_TST_ID.DELETE;
      P_EXT_TST_ID_VERSION.DELETE;
      P_EXT_PP_SEQ.DELETE;
      P_EXT_PR_SEQ.DELETE;
      P_EXT_MT_SEQ.DELETE;
      P_EXT_PP_KEY1.DELETE;
      P_EXT_PP_KEY2.DELETE;
      P_EXT_PP_KEY3.DELETE;
      P_EXT_PP_KEY4.DELETE;
      P_EXT_PP_KEY5.DELETE;
      P_NR_OBJECTS := -1;
      P_LAST_ROW   := -1;
      P_LAST_ATTRIBUTE   := -1;
   END IF;
    
   L_FETCHED_ROWS := L_CURRENT_ROW;
 
   FOR L_ROW IN 1..L_FETCHED_ROWS LOOP
      IF A_TST_TP(L_ROW) = 'px' THEN
         
         A_TST_TP(L_ROW) := 'pr';
      END IF;
   END LOOP;
   
    
   IF (L_FETCHED_ROWS = 0) THEN
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
       A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SQLERRM;
         UNAPIGEN.U4ROLLBACK;
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'GetTestPlanAttributes', L_SQLERRM);
         UNAPIGEN.U4COMMIT;
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIGEN.U4ROLLBACK;
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'GetTestPlanAttributes', L_SQLERRM);
         UNAPIGEN.U4COMMIT;
      END IF;
      IF DBMS_SQL.IS_OPEN(L_CONFIG_DETAILS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_CONFIG_DETAILS_CURSOR);
      END IF;
      IF UNAPIGEN.P_TXN_ERROR > UNAPIGEN.DBERR_SUCCESS AND
         UNAPIGEN.P_TXN_ERROR IS NOT NULL THEN
         
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
                'GetTestPlanAttributes', 'Return code='||UNAPIGEN.P_TXN_ERROR||'#a_obect_tp='||A_OBJECT_TP||'#a_object_id='|| REPLACE(A_OBJECT_ID, '''', '''''') ||'#a_object_version='||A_OBJECT_VERSION|| '#a_nr_of_rows='||A_NR_OF_ROWS||'#a_next_rows='||A_NEXT_ROWS);
         UNAPIGEN.U4COMMIT;
         RETURN (UNAPIGEN.P_TXN_ERROR);
      ELSE
         RETURN(UNAPIGEN.DBERR_GENFAIL);
      END IF;
END GETTESTPLANATTRIBUTES;

END UNAPIPG3;