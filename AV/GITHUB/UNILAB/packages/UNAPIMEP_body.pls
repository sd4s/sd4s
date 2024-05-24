create or replace PACKAGE BODY unapimep AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;
L_SQLERRM         VARCHAR2(255);


L_SQL_STRING      VARCHAR2(10000);
L_WHERE_CLAUSE    VARCHAR2(10000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
L_EV_DETAILS      VARCHAR2(255);
STPERROR          EXCEPTION;

P_SELECTMEGK_CURSOR            INTEGER;
P_SELECTMEPROP_CURSOR          INTEGER;
L_MEGK_CURSOR                  INTEGER;
L_AU_CURSOR                    INTEGER;
L_INTERNAL_DELETEDETAILS       BOOLEAN DEFAULT FALSE;               
P_CLIENT_EVMGR_USED            VARCHAR2(3);
P_HS_DETAILS_CURSOR            INTEGER;
P_HS_CURSOR                    INTEGER;

P_CHGMESS_CALLS                INTEGER;
P_CHGMESS_TR_SEQ               INTEGER;
P_CANCELMELS_CALLS             INTEGER;
P_CANCELMELS_TR_SEQ            INTEGER;
P_ELSIGNMELS_CALLS             INTEGER;
P_ELSIGNMELS_TR_SEQ            INTEGER;
P_GETSCMELS_LCANDSS_CALLS      INTEGER;
P_GETSCMELS_LCANDSS_TR_SEQ     INTEGER;
P_GETSCMELS_LCANDSS_INT_TRANS  BOOLEAN;

CURSOR C_SYSTEM (A_SETTING_NAME VARCHAR2) IS
   SELECT SETTING_VALUE
   FROM UTSYSTEM
   WHERE SETTING_NAME = A_SETTING_NAME;
P_COPY_EST_COST                VARCHAR2(255);
P_COPY_EST_TIME                VARCHAR2(255);

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;


PROCEDURE SAVEPOINT_UNILAB4 IS
BEGIN
   IF UNAPIEV.P_EVMGRS_EV_IN_BULK = '1' THEN
      UNAPIGEN.U4SAVEPOINT('unilab4');
   ELSE
      SAVEPOINT UNILAB4;
   END IF;
END SAVEPOINT_UNILAB4;

FUNCTION GETSCMEGROUPKEY
(A_SC              OUT    UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG              OUT    UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE          OUT    UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA              OUT    UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE          OUT    UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME              OUT    UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE          OUT    UNAPIGEN.LONG_TABLE_TYPE,  
 A_GK              OUT    UNAPIGEN.VC20_TABLE_TYPE,  
 A_GK_VERSION      OUT    UNAPIGEN.VC20_TABLE_TYPE,  
 A_VALUE           OUT    UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCRIPTION     OUT    UNAPIGEN.VC40_TABLE_TYPE,  
 A_IS_PROTECTED    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_VALUE_UNIQUE    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SINGLE_VALUED   OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NEW_VAL_ALLOWED OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_MANDATORY       OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_VALUE_LIST_TP   OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_DSP_ROWS        OUT    UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS      IN OUT NUMBER,                    
 A_WHERE_CLAUSE    IN     VARCHAR2)                  
RETURN NUMBER IS

L_SC                             VARCHAR2(20);
L_PG                             VARCHAR2(20);
L_PGNODE                         NUMBER(9);
L_PA                             VARCHAR2(20);
L_PANODE                         NUMBER(9);
L_ME                             VARCHAR2(20);
L_MENODE                         NUMBER(9);
L_GK                             VARCHAR2(20);
L_GK_VERSION                     VARCHAR2(20);
L_VALUE                          VARCHAR2(40);
L_DESCRIPTION                    VARCHAR2(40);
L_IS_PROTECTED                   CHAR(1);
L_VALUE_UNIQUE                   CHAR(1);
L_SINGLE_VALUED                  CHAR(1);
L_NEW_VAL_ALLOWED                CHAR(1);
L_MANDATORY                      CHAR(1);
L_VALUE_LIST_TP                  CHAR(1);
L_DSP_ROWS                       NUMBER(3);
L_FETCH_WSME                     BOOLEAN;
L_BIND_SCME_SELECTION            BOOLEAN;
L_BIND_FIXED_SC_FLAG             BOOLEAN;
L_ADDORACLECBOHINT               BOOLEAN;
L_GKDEF_REC                      UNAPIGK.GKDEFINITIONREC;
L_TEMP_RET_CODE                  INTEGER;

BEGIN

   L_FETCH_WSME := FALSE;
   L_BIND_SCME_SELECTION := FALSE;
   L_BIND_FIXED_SC_FLAG := FALSE;
   L_ADDORACLECBOHINT := FALSE;
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;
   
   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
   ELSIF A_WHERE_CLAUSE = 'SELECTION' THEN
      IF UNAPIME.P_SELECTION_CLAUSE IS NOT NULL THEN 
         IF INSTR(UPPER(UNAPIME.P_SELECTION_CLAUSE), ' WHERE ') <> 0 THEN       
            L_WHERE_CLAUSE := ','||UNAPIME.P_SELECTION_CLAUSE|| 
                              ' AND a.sc=gk.sc AND a.pg=gk.pg AND a.pgnode=gk.pgnode ' ||
                              'AND a.pa=gk.pa AND a.panode=gk.panode ' ||
                              'AND a.me=gk.me AND a.menode=gk.menode ' ||
                              'ORDER BY gk.sc, gk.pgnode, gk.panode, gk.menode, gk.gkseq';
         ELSE
            L_WHERE_CLAUSE := ','||UNAPIME.P_SELECTION_CLAUSE||  
                              ' WHERE a.sc=gk.sc AND a.pg=gk.pg AND a.pgnode=gk.pgnode ' ||
                              'AND a.pa=gk.pa AND a.panode=gk.panode ' ||
                              'AND a.me=gk.me AND a.menode=gk.menode ' ||
                              'ORDER BY gk.sc, gk.pgnode, gk.panode, gk.menode, gk.gkseq';
         END IF;    
         L_BIND_SCME_SELECTION := TRUE;
         L_ADDORACLECBOHINT := TRUE;
      ELSE
         L_WHERE_CLAUSE := 'ORDER BY gk.sc,gk.pgnode,gk.panode,gk.menode,gk.gkseq'; 
      END IF;
    ELSIF REPLACE( SUBSTR(A_WHERE_CLAUSE, 1 , INSTR(A_WHERE_CLAUSE,'''')), ' ', '')='WS=''' THEN
      
            
      L_FETCH_WSME := TRUE;
      L_WHERE_CLAUSE := 'WHERE utwsme.sc = gk.sc AND utwsme.pg=gk.pg AND utwsme.pgnode=gk.pgnode ' ||
                        'AND utwsme.pa=gk.pa AND utwsme.panode=gk.panode ' ||
                        'AND utwsme.me=gk.me AND utwsme.menode=gk.menode ' ||
                        'AND utwsme.ws = :ws_val ' ||
                        ' GROUP BY gk.sc, gk.pg, gk.pgnode, gk.pa, gk.panode, gk.me, gk.menode, ' ||
                        'gk.gkseq, gk.gk, gk.gk_version, gk.value'; 
      IF INSTR(UPPER(A_WHERE_CLAUSE), 'ORDER BY')=0 THEN
         L_WHERE_CLAUSE := L_WHERE_CLAUSE||' ORDER BY gk.sc, gk.pgnode, gk.panode, gk.menode, gk.gkseq'; 
      END IF;   
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_BIND_FIXED_SC_FLAG := TRUE;
      L_WHERE_CLAUSE := 'WHERE gk.sc = :sc_val ORDER BY gk.pgnode, gk.panode, gk.menode, gk.gkseq';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   IF NOT DBMS_SQL.IS_OPEN(L_MEGK_CURSOR) THEN
      
      L_TEMP_RET_CODE := UNAPIGK.INITGROUPKEYDEFBUFFER('me');
      IF L_TEMP_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE_APPLICATION_ERROR(-20000, 'InitGroupKeyDefBuffer failed with ret_code='||L_TEMP_RET_CODE||' for a_gk_tp=me');   
      END IF;
      
      L_MEGK_CURSOR := DBMS_SQL.OPEN_CURSOR;
      IF L_FETCH_WSME THEN
         L_SQL_STRING := 'SELECT gk.sc, gk.pg, gk.pgnode, gk.pa, gk.panode, gk.me, gk.menode, ' ||
                         'gk.gk, gk.gk_version, gk.value FROM dd'|| UNAPIGEN.P_DD ||'.uvscmegk gk, utwsme '||L_WHERE_CLAUSE;
      ELSE 
         L_SQL_STRING := 'SELECT gk.sc, gk.pg, gk.pgnode, gk.pa, gk.panode, gk.me, gk.menode, ' ||
                         'gk.gk, gk.gk_version, gk.value FROM dd'|| UNAPIGEN.P_DD ||'.uvscmegk gk '||L_WHERE_CLAUSE;
      END IF;                
      IF L_ADDORACLECBOHINT THEN
         UNAPIAUT.ADDORACLECBOHINT (L_SQL_STRING) ;
      END IF;
      DBMS_SQL.PARSE(L_MEGK_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      IF L_BIND_SCME_SELECTION THEN
         FOR L_X IN 1..UNAPIME.P_SELECTION_VAL_TAB.COUNT() LOOP
            DBMS_SQL.BIND_VARIABLE(L_MEGK_CURSOR, ':col_val'||L_X , UNAPIME.P_SELECTION_VAL_TAB(L_X)); 
         END LOOP;
      ELSIF L_BIND_FIXED_SC_FLAG THEN
         DBMS_SQL.BIND_VARIABLE(L_MEGK_CURSOR, ':sc_val' , A_WHERE_CLAUSE); 
      ELSIF L_FETCH_WSME THEN
         DBMS_SQL.BIND_VARIABLE(L_MEGK_CURSOR, ':ws_val' , SUBSTR(A_WHERE_CLAUSE,5, LENGTH(A_WHERE_CLAUSE)-5)); 
      END IF;

      DBMS_SQL.DEFINE_COLUMN(L_MEGK_CURSOR, 1, L_SC, 20);
      DBMS_SQL.DEFINE_COLUMN(L_MEGK_CURSOR, 2, L_PG, 20);
      DBMS_SQL.DEFINE_COLUMN(L_MEGK_CURSOR, 3, L_PGNODE);
      DBMS_SQL.DEFINE_COLUMN(L_MEGK_CURSOR, 4, L_PA, 20);
      DBMS_SQL.DEFINE_COLUMN(L_MEGK_CURSOR, 5, L_PANODE);
      DBMS_SQL.DEFINE_COLUMN(L_MEGK_CURSOR, 6, L_ME, 20);
      DBMS_SQL.DEFINE_COLUMN(L_MEGK_CURSOR, 7, L_MENODE);
      DBMS_SQL.DEFINE_COLUMN(L_MEGK_CURSOR, 8, L_GK, 20);
      DBMS_SQL.DEFINE_COLUMN(L_MEGK_CURSOR, 9, L_GK_VERSION, 20);
      DBMS_SQL.DEFINE_COLUMN(L_MEGK_CURSOR, 10, L_VALUE, 40);
      L_RESULT := DBMS_SQL.EXECUTE(L_MEGK_CURSOR);
   END IF;
   
   L_RESULT := DBMS_SQL.FETCH_ROWS(L_MEGK_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_MEGK_CURSOR, 1, L_SC);
      DBMS_SQL.COLUMN_VALUE(L_MEGK_CURSOR, 2, L_PG);
      DBMS_SQL.COLUMN_VALUE(L_MEGK_CURSOR, 3, L_PGNODE);
      DBMS_SQL.COLUMN_VALUE(L_MEGK_CURSOR, 4, L_PA);
      DBMS_SQL.COLUMN_VALUE(L_MEGK_CURSOR, 5, L_PANODE);
      DBMS_SQL.COLUMN_VALUE(L_MEGK_CURSOR, 6, L_ME);
      DBMS_SQL.COLUMN_VALUE(L_MEGK_CURSOR, 7, L_MENODE);
      DBMS_SQL.COLUMN_VALUE(L_MEGK_CURSOR, 8, L_GK);
      DBMS_SQL.COLUMN_VALUE(L_MEGK_CURSOR, 9, L_GK_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_MEGK_CURSOR, 10, L_VALUE);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_SC(L_FETCHED_ROWS) := L_SC;
      A_PG(L_FETCHED_ROWS) := L_PG;
      A_PGNODE(L_FETCHED_ROWS) := L_PGNODE;
      A_PA(L_FETCHED_ROWS) := L_PA;
      A_PANODE(L_FETCHED_ROWS) := L_PANODE;
      A_ME(L_FETCHED_ROWS) := L_ME;
      A_MENODE(L_FETCHED_ROWS) := L_MENODE;
      A_GK(L_FETCHED_ROWS) := L_GK;
      A_GK_VERSION(L_FETCHED_ROWS) := L_GK_VERSION;
      A_VALUE(L_FETCHED_ROWS) := L_VALUE;

      
      BEGIN
         L_GKDEF_REC := UNAPIGK.P_GK_DEF_BUFFER(L_GK);
         A_DESCRIPTION(L_FETCHED_ROWS) := L_GKDEF_REC.DESCRIPTION;
         A_IS_PROTECTED(L_FETCHED_ROWS) := L_GKDEF_REC.IS_PROTECTED;
         A_VALUE_UNIQUE(L_FETCHED_ROWS) := L_GKDEF_REC.VALUE_UNIQUE;
         A_SINGLE_VALUED(L_FETCHED_ROWS) := L_GKDEF_REC.SINGLE_VALUED;
         A_NEW_VAL_ALLOWED(L_FETCHED_ROWS) := L_GKDEF_REC.NEW_VAL_ALLOWED;
         A_MANDATORY(L_FETCHED_ROWS) := L_GKDEF_REC.MANDATORY;
         A_VALUE_LIST_TP(L_FETCHED_ROWS) := L_GKDEF_REC.VALUE_LIST_TP;
         A_DSP_ROWS(L_FETCHED_ROWS) := L_GKDEF_REC.DSP_ROWS;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         
         
         
         A_DESCRIPTION(L_FETCHED_ROWS)     := L_GK;
         A_IS_PROTECTED(L_FETCHED_ROWS)    := '1';
         A_VALUE_UNIQUE(L_FETCHED_ROWS)    := '0';
         A_SINGLE_VALUED(L_FETCHED_ROWS)   := '1';
         A_NEW_VAL_ALLOWED(L_FETCHED_ROWS) := '1';
         A_MANDATORY(L_FETCHED_ROWS)       := '0';
         A_VALUE_LIST_TP(L_FETCHED_ROWS)   := 'F';
         A_DSP_ROWS(L_FETCHED_ROWS)        := 10;      
      END;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_MEGK_CURSOR);
      END IF;
   END LOOP;

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
      DBMS_SQL.CLOSE_CURSOR(L_MEGK_CURSOR);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      DBMS_SQL.CLOSE_CURSOR(L_MEGK_CURSOR);
   ELSE   
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   IF A_WHERE_CLAUSE <> 'SELECTION' AND
      L_FETCH_WSME = FALSE AND   
      DBMS_SQL.IS_OPEN(L_MEGK_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_MEGK_CURSOR);
   END IF;

   IF NOT DBMS_SQL.IS_OPEN(L_MEGK_CURSOR) THEN
      L_TEMP_RET_CODE := UNAPIGK.CLOSEGROUPKEYDEFBUFFER('me');
      IF L_TEMP_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE_APPLICATION_ERROR(-20000, 'CloseGroupKeyDefBuffer failed with ret_code='||L_TEMP_RET_CODE||' for a_gk_tp=me');   
      END IF;
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'GetScMeGroupKey', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(L_MEGK_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_MEGK_CURSOR);
      END IF;
      L_RET_CODE := UNAPIGK.CLOSEGROUPKEYDEFBUFFER('me');
      
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETSCMEGROUPKEY;

FUNCTION INITSCMEATTRIBUTE
(A_SC               IN     VARCHAR2,                  
 A_PR               IN     VARCHAR2,                  
 A_PR_VERSION       IN     VARCHAR2,                  
 A_MT               IN     VARCHAR2,                  
 A_MT_VERSION       IN     VARCHAR2,                  
 A_AU               OUT    UNAPIGEN.VC20_TABLE_TYPE,  
 A_AU_VERSION       OUT    UNAPIGEN.VC20_TABLE_TYPE,  
 A_VALUE            OUT    UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCRIPTION      OUT    UNAPIGEN.VC40_TABLE_TYPE,  
 A_IS_PROTECTED     OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SINGLE_VALUED    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NEW_VAL_ALLOWED  OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_STORE_DB         OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_VALUE_LIST_TP    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_RUN_MODE         OUT    UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SERVICE          OUT    UNAPIGEN.VC255_TABLE_TYPE, 
 A_CF_VALUE         OUT    UNAPIGEN.VC20_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT NUMBER)                    
RETURN NUMBER IS

L_PR               VARCHAR2(20);
L_PR_VERSION       VARCHAR2(20);

CURSOR L_PRMT_CURSOR(C_PR VARCHAR2, C_PR_VERSION VARCHAR2, C_MT VARCHAR2, C_MT_VERSION VARCHAR2) IS
   SELECT PR
   FROM UTPRMT
   WHERE PR = C_PR
   AND VERSION = C_PR_VERSION
   AND MT = C_MT
   AND UNAPIGEN.VALIDATEVERSION('mt', MT, MT_VERSION) = C_MT_VERSION;
L_PRMT_REC L_PRMT_CURSOR%ROWTYPE;

CURSOR L_PRMTAU_CURSOR (C_PR VARCHAR2, C_PR_VERSION VARCHAR2, C_MT VARCHAR2, C_MT_VERSION VARCHAR2) IS
   
   
   
   
   SELECT A.AU, A.AUSEQ, D.VERSION, A.VALUE, D.DESCRIPTION, D.IS_PROTECTED, D.SINGLE_VALUED,
       D.NEW_VAL_ALLOWED, D.STORE_DB, D.VALUE_LIST_TP,
       D.RUN_MODE, D.SERVICE, D.CF_VALUE
   FROM UTMTAU A, UTMT B, UTPRMT C, UTAU D
   WHERE A.MT = C_MT
     AND A.VERSION  = C_MT_VERSION
     AND A.MT = B.MT
     AND A.VERSION = B.VERSION
     AND A.AU = D.AU
     AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION
     AND C.PR = C_PR
     AND C.VERSION = C_PR_VERSION     
     AND C.MT = B.MT
     AND UNAPIGEN.VALIDATEVERSION('mt', C.MT, C.MT_VERSION) = B.VERSION
     AND DECODE(D.INHERIT_AU,'0',DECODE(C.INHERIT_AU,'2',B.INHERIT_AU,C.INHERIT_AU),D.INHERIT_AU) = '1'
     AND A.AU NOT IN (SELECT DISTINCT J.AU
                      FROM UTPRMTAU J, UTPRMT K, UTMT L, UTAU M
                      WHERE J.MT = L.MT
                        AND UNAPIGEN.VALIDATEVERSION('mt', J.MT, J.MT_VERSION) = L.VERSION                      
                        AND J.PR = C_PR
                        AND J.VERSION = C_PR_VERSION
                        AND J.MT = C_MT
                        AND UNAPIGEN.VALIDATEVERSION('mt', J.MT, J.MT_VERSION) = C_MT_VERSION
                        AND J.MT = K.MT
                        AND UNAPIGEN.VALIDATEVERSION('mt', J.MT, J.MT_VERSION) = UNAPIGEN.VALIDATEVERSION('mt', K.MT, K.MT_VERSION)                                                
                        AND J.PR = K.PR
                        AND J.VERSION = K.VERSION
                        AND DECODE(M.INHERIT_AU,'0',DECODE(K.INHERIT_AU,'2',L.INHERIT_AU,K.INHERIT_AU),M.INHERIT_AU) = '1'
                        AND M.AU = J.AU
                        AND M.VERSION = UNAPIGEN.VALIDATEVERSION('au', J.AU, J.AU_VERSION))
   
   
   
   
   UNION
   SELECT V.AU, V.AUSEQ+500, Y.VERSION, V.VALUE, Y.DESCRIPTION, Y.IS_PROTECTED, Y.SINGLE_VALUED,
       Y.NEW_VAL_ALLOWED, Y.STORE_DB, Y.VALUE_LIST_TP,
       Y.RUN_MODE, Y.SERVICE, Y.CF_VALUE
   FROM UTPRMTAU V, UTPRMT W, UTMT X, UTAU Y
   WHERE V.MT = X.MT
     AND UNAPIGEN.VALIDATEVERSION('mt', V.MT, V.MT_VERSION) = X.VERSION
     AND V.PR = C_PR
     AND V.VERSION = C_PR_VERSION     
     AND V.MT = C_MT
     AND UNAPIGEN.VALIDATEVERSION('mt', V.MT, V.MT_VERSION) = C_MT_VERSION
     AND V.PR = W.PR
     AND V.VERSION = W.VERSION
     AND V.MT = W.MT
     AND UNAPIGEN.VALIDATEVERSION('mt', V.MT, V.MT_VERSION) = UNAPIGEN.VALIDATEVERSION('mt', W.MT, W.MT_VERSION)
     AND DECODE(Y.INHERIT_AU,'0',DECODE(W.INHERIT_AU,'2',X.INHERIT_AU,W.INHERIT_AU),Y.INHERIT_AU) = '1' 
     AND V.AU = Y.AU
     AND UNAPIGEN.VALIDATEVERSION('au', V.AU, V.AU_VERSION) = Y.VERSION     
   ORDER BY 2;

CURSOR L_MTAU_CURSOR (C_MT VARCHAR2, C_MT_VERSION VARCHAR2) IS
   
   
   
   
   SELECT A.AU, A.AUSEQ, D.VERSION, A.VALUE, D.DESCRIPTION, D.IS_PROTECTED, D.SINGLE_VALUED,
       D.NEW_VAL_ALLOWED, D.STORE_DB, D.VALUE_LIST_TP,
       D.RUN_MODE, D.SERVICE, D.CF_VALUE
   FROM UTMTAU A, UTMT B, UTAU D
   WHERE A.MT = C_MT
     AND A.VERSION = C_MT_VERSION
     AND A.MT = B.MT
     AND A.VERSION = B.VERSION
     AND A.AU = D.AU
     AND UNAPIGEN.VALIDATEVERSION('au', A.AU, A.AU_VERSION) = D.VERSION          
     AND DECODE(D.INHERIT_AU, '0', B.INHERIT_AU, D.INHERIT_AU) = '1'
     ORDER BY 2;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_MT, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_NOOBJID);
   END IF;
   IF NVL(A_MT_VERSION, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_MTVERSION);
   END IF;
   
   L_PR := A_PR;
   IF A_PR IS NOT NULL THEN
      IF NVL(A_PR_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_PRVERSION);
      END IF;      
      L_PR_VERSION := A_PR_VERSION;
   END IF;

   IF L_PR IS NOT NULL THEN
      
      
      
      
      OPEN L_PRMT_CURSOR(L_PR, L_PR_VERSION, A_MT, A_MT_VERSION);
      FETCH L_PRMT_CURSOR
      INTO L_PRMT_REC;
      IF L_PRMT_CURSOR%NOTFOUND THEN
         L_PR := NULL;
      END IF;
      CLOSE L_PRMT_CURSOR;
   END IF;
   
   L_FETCHED_ROWS := 0;

   IF L_PR IS NOT NULL THEN   
   
      FOR L_PRMTAU_REC IN L_PRMTAU_CURSOR(L_PR, L_PR_VERSION, A_MT, A_MT_VERSION) LOOP
         L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
         A_AU(L_FETCHED_ROWS) := L_PRMTAU_REC.AU;
         A_AU_VERSION(L_FETCHED_ROWS) := L_PRMTAU_REC.VERSION;
         A_VALUE(L_FETCHED_ROWS) := L_PRMTAU_REC.VALUE;
         A_DESCRIPTION(L_FETCHED_ROWS) := L_PRMTAU_REC.DESCRIPTION;
         A_IS_PROTECTED(L_FETCHED_ROWS) := L_PRMTAU_REC.IS_PROTECTED;
         A_SINGLE_VALUED(L_FETCHED_ROWS) := L_PRMTAU_REC.SINGLE_VALUED;
         A_NEW_VAL_ALLOWED(L_FETCHED_ROWS) := L_PRMTAU_REC.NEW_VAL_ALLOWED;
         A_STORE_DB(L_FETCHED_ROWS) := L_PRMTAU_REC.STORE_DB;
         A_VALUE_LIST_TP(L_FETCHED_ROWS) := L_PRMTAU_REC.VALUE_LIST_TP;
         A_RUN_MODE(L_FETCHED_ROWS) := L_PRMTAU_REC.RUN_MODE;
         A_SERVICE(L_FETCHED_ROWS) := L_PRMTAU_REC.SERVICE;
         A_CF_VALUE(L_FETCHED_ROWS) := L_PRMTAU_REC.CF_VALUE;
         EXIT WHEN L_FETCHED_ROWS >= A_NR_OF_ROWS;
      END LOOP;
      
   ELSE

      FOR L_MTAU_REC IN L_MTAU_CURSOR(A_MT, A_MT_VERSION) LOOP
         L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
         A_AU(L_FETCHED_ROWS) := L_MTAU_REC.AU;
         A_AU_VERSION(L_FETCHED_ROWS) := L_MTAU_REC.VERSION;
         A_VALUE(L_FETCHED_ROWS) := L_MTAU_REC.VALUE;
         A_DESCRIPTION(L_FETCHED_ROWS) := L_MTAU_REC.DESCRIPTION;
         A_IS_PROTECTED(L_FETCHED_ROWS) := L_MTAU_REC.IS_PROTECTED;
         A_SINGLE_VALUED(L_FETCHED_ROWS) := L_MTAU_REC.SINGLE_VALUED;
         A_NEW_VAL_ALLOWED(L_FETCHED_ROWS) := L_MTAU_REC.NEW_VAL_ALLOWED;
         A_STORE_DB(L_FETCHED_ROWS) := L_MTAU_REC.STORE_DB;
         A_VALUE_LIST_TP(L_FETCHED_ROWS) := L_MTAU_REC.VALUE_LIST_TP;
         A_RUN_MODE(L_FETCHED_ROWS) := L_MTAU_REC.RUN_MODE;
         A_SERVICE(L_FETCHED_ROWS) := L_MTAU_REC.SERVICE;
         A_CF_VALUE(L_FETCHED_ROWS) := L_MTAU_REC.CF_VALUE;
         EXIT WHEN L_FETCHED_ROWS >= A_NR_OF_ROWS;
      END LOOP;
   
   END IF;

   IF L_FETCHED_ROWS = 0 THEN
      A_NR_OF_ROWS := 0;
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'InitScMeAttribute', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END INITSCMEATTRIBUTE;

FUNCTION SAVESCMEGROUPKEY
(A_SC              IN     VARCHAR2,                   
 A_PG              IN     VARCHAR2,                   
 A_PGNODE          IN     NUMBER,                     
 A_PA              IN     VARCHAR2,                   
 A_PANODE          IN     NUMBER,                     
 A_ME              IN     VARCHAR2,                   
 A_MENODE          IN     NUMBER,                     
 A_GK              IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_GK_VERSION      IN OUT UNAPIGEN.VC20_TABLE_TYPE,   
 A_VALUE           IN     UNAPIGEN.VC40_TABLE_TYPE,   
 A_NR_OF_ROWS      IN     NUMBER,                     
 A_MODIFY_REASON   IN     VARCHAR2)                   
RETURN NUMBER IS

L_LC                VARCHAR2(2);
L_LC_VERSION        VARCHAR2(20);
L_SS                VARCHAR2(2);
L_LOG_HS            CHAR(1);
L_LOG_HS_DETAILS    CHAR(1);
L_ALLOW_MODIFY      CHAR(1);
L_ACTIVE            CHAR(1);
L_ME_CURSOR         INTEGER;
L_NEW_SEQ           NUMBER;
L_GK_HANDLE         BOOLEAN_TABLE_TYPE;
L_GK_FOUND          BOOLEAN;
L_WHAT_DESCRIPTION  VARCHAR2(255);
L_HS_SEQ            INTEGER;
L_MT_VERSION        VARCHAR2(20);
L_SKIP              BOOLEAN;

TABLE_DOES_NOT_EXIST EXCEPTION;
PRAGMA EXCEPTION_INIT (TABLE_DOES_NOT_EXIST, -942);

CURSOR L_GK_CURSOR IS
   SELECT GK, GK_VERSION, VALUE
   FROM UTSCMEGK
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE
   ORDER BY GKSEQ;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_PG, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_MENODE, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_GK(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;
      L_GK_HANDLE(L_SEQ_NO) := TRUE;
   END LOOP;

   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, 
                                               A_MENODE, NULL, L_MT_VERSION, L_LC, L_LC_VERSION,
                                               L_SS, L_ALLOW_MODIFY, L_ACTIVE,
                                               L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTSCME
   SET ALLOW_MODIFY = '#'
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   
   L_EVENT_TP := 'MeGroupKeyUpdated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'sc=' || A_SC ||
                   '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                   '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                   '#menode=' || TO_CHAR(A_MENODE) ||
                   '#mt_version=' || L_MT_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveScMeGroupKey', UNAPIGEN.P_EVMGR_NAME,
                                   'me', A_ME, L_LC, L_LC_VERSION, L_SS,
                                   L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') AND (UNAPIGEN.P_LOG_GK_HS = '1') THEN
      INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, WHAT,
                           WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_USER, 
             UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
             'method "'||A_ME||'" group keys are updated.', 
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_SEQ := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_SEQ := L_HS_SEQ + 1;
      INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
             UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
             'method "'||A_ME||'" group keys are updated.');
   END IF;

   L_ME_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_MEGK IN L_GK_CURSOR LOOP
      L_GK_FOUND := FALSE;
      FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
         
         IF L_MEGK.GK = A_GK(L_SEQ_NO) AND
            (L_MEGK.VALUE = A_VALUE(L_SEQ_NO) OR
             (L_MEGK.VALUE IS NULL AND A_VALUE(L_SEQ_NO) IS NULL)) THEN
            L_GK_HANDLE(L_SEQ_NO) := FALSE;
            L_GK_FOUND := TRUE;
            EXIT;
         END IF;
      END LOOP;

      IF NOT L_GK_FOUND THEN
         
         DELETE FROM UTSCMEGK
         WHERE SC = A_SC
            AND PG = A_PG
            AND PGNODE = A_PGNODE
            AND PA = A_PA
            AND PANODE = A_PANODE
            AND ME = A_ME
            AND MENODE = A_MENODE
            AND GK = L_MEGK.GK
            AND VALUE = L_MEGK.VALUE;

         
         IF L_MEGK.VALUE IS NULL THEN
            DELETE FROM UTSCMEGK
            WHERE SC = A_SC
              AND PG = A_PG
              AND PGNODE = A_PGNODE
              AND PA = A_PA
              AND PANODE = A_PANODE
              AND ME = A_ME
              AND MENODE = A_MENODE
              AND GK = L_MEGK.GK
              AND VALUE IS NULL;
         END IF;

         IF (L_LOG_HS_DETAILS = '1') THEN
            L_WHAT_DESCRIPTION := 'Groupkey "'||L_MEGK.GK||'" with value "'||L_MEGK.VALUE||'" is removed from method "'||A_ME||'".';
            L_HS_SEQ := L_HS_SEQ + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_TR_SEQ, 
                   L_EV_SEQ_NR, L_HS_SEQ, L_WHAT_DESCRIPTION);
         END IF;   

         L_SQL_STRING := 'DELETE FROM utscmegk' || L_MEGK.GK ||
                         ' WHERE sc = :sc' || 
                         ' AND pg = :pg' ||  
                         ' AND pgnode = :pgnode' || 
                         ' AND pa = :pa' || 
                         ' AND panode = :panode' || 
                         ' AND me = :me' || 
                         ' AND menode = :menode' || 
                         ' AND ' || L_MEGK.GK || '= :value '; 
         BEGIN
            DBMS_SQL.PARSE(L_ME_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':sc' , A_SC); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pg' , A_PG); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pgnode' , A_PGNODE); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pa' , A_PA); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':panode' , A_PANODE); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':me' , A_ME); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':menode' , A_MENODE); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':value' , L_MEGK.VALUE); 
            L_RESULT := DBMS_SQL.EXECUTE(L_ME_CURSOR);
         EXCEPTION
         WHEN TABLE_DOES_NOT_EXIST THEN
            
            
            NULL;
         END;
      END IF;
   END LOOP;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF L_GK_HANDLE(L_SEQ_NO) THEN
         L_SKIP := FALSE;
         IF NVL(A_VALUE(L_SEQ_NO), ' ') <> ' ' THEN
            L_SQL_STRING := 'INSERT INTO utscmegk' || A_GK(L_SEQ_NO) ||
                            ' ('||A_GK(L_SEQ_NO)||', sc, pg, pgnode, pa, panode, me, menode)'||
                            ' VALUES(:value, :sc, :pg, :pgnode, :pa, :panode, :me, :menode)' ;
            BEGIN
               DBMS_SQL.PARSE(L_ME_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':sc' , A_SC); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pg' , A_PG); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pgnode' , A_PGNODE); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pa' , A_PA); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':panode' , A_PANODE); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':me' , A_ME); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':menode' , A_MENODE); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':value' , A_VALUE(L_SEQ_NO)); 
               L_RESULT := DBMS_SQL.EXECUTE(L_ME_CURSOR);
            EXCEPTION
            WHEN TABLE_DOES_NOT_EXIST THEN
               
               
               NULL;
            WHEN DUP_VAL_ON_INDEX THEN
               L_SKIP := TRUE;
            END;
         END IF;

         IF NOT L_SKIP THEN
            
            INSERT INTO UTSCMEGK(SC, PG, PGNODE, PA, PANODE, ME, MENODE, GK, GKSEQ,
                                 VALUE)
            SELECT A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE,
                   A_GK(L_SEQ_NO), NVL(MAX(GKSEQ), 0) + 1, A_VALUE(L_SEQ_NO)
            FROM UTSCMEGK
            WHERE SC =A_SC
               AND PG = A_PG
               AND PGNODE = A_PGNODE
               AND PA = A_PA
               AND PANODE = A_PANODE
               AND ME = A_ME
               AND MENODE = A_MENODE;

            IF (L_LOG_HS_DETAILS = '1') THEN
               L_WHAT_DESCRIPTION := 'Groupkey "'||A_GK(L_SEQ_NO)||'" is added to method "'||A_ME||'", value is "'||A_VALUE(L_SEQ_NO)||'".';
               L_HS_SEQ := L_HS_SEQ + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
               VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_TR_SEQ, 
                      L_EV_SEQ_NR, L_HS_SEQ, L_WHAT_DESCRIPTION);
            END IF;   
         END IF;
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_ME_CURSOR);

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   IF DBMS_SQL.IS_OPEN(L_ME_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_ME_CURSOR);
   END IF;
   UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_UNIQUEGK;
   
   
   L_RESULT := UNAPIGEN.ENDTXN;
   RETURN(UNAPIGEN.P_TXN_ERROR);
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveScMeGroupKey', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('SaveScMeGroupKey', L_SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_ME_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_ME_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveScMeGroupKey'));
END SAVESCMEGROUPKEY;

FUNCTION SAVE1SCMEGROUPKEY
(A_SC              IN     VARCHAR2,                   
 A_PG              IN     VARCHAR2,                   
 A_PGNODE          IN     NUMBER,                     
 A_PA              IN     VARCHAR2,                   
 A_PANODE          IN     NUMBER,                     
 A_ME              IN     VARCHAR2,                   
 A_MENODE          IN     NUMBER,                     
 A_GK              IN     VARCHAR2,                   
 A_GK_VERSION      IN OUT VARCHAR2,                   
 A_VALUE           IN     UNAPIGEN.VC40_TABLE_TYPE,   
 A_NR_OF_ROWS      IN     NUMBER,                     
 A_MODIFY_REASON   IN     VARCHAR2)                   
RETURN NUMBER IS

L_LC                VARCHAR2(2);
L_LC_VERSION        VARCHAR2(20);
L_SS                VARCHAR2(2);
L_LOG_HS            CHAR(1);
L_LOG_HS_DETAILS    CHAR(1);
L_ALLOW_MODIFY      CHAR(1);
L_ACTIVE            CHAR(1);
L_ME_CURSOR         INTEGER;
L_NEW_SEQ           NUMBER;
L_GK_HANDLE         BOOLEAN_TABLE_TYPE;
L_GK_FOUND          BOOLEAN;
L_INSERT_EVENT      BOOLEAN;
L_LAST_SEQ          INTEGER;
L_WHAT_DESCRIPTION  VARCHAR2(255);
L_HS_SEQ            INTEGER;
L_MT_VERSION        VARCHAR2(20);
L_SKIP              BOOLEAN;

TABLE_DOES_NOT_EXIST EXCEPTION;
PRAGMA EXCEPTION_INIT (TABLE_DOES_NOT_EXIST, -942);

CURSOR L_GK_CURSOR IS
   SELECT VALUE, GKSEQ
   FROM UTSCMEGK
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE
      AND GK = A_GK
   ORDER BY GKSEQ;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> 
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_GK, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_MENODE, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      L_GK_HANDLE(L_SEQ_NO) := TRUE;
   END LOOP;

   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, 
                                               A_MENODE, NULL, L_MT_VERSION, L_LC, L_LC_VERSION, 
                                               L_SS, L_ALLOW_MODIFY, L_ACTIVE,
                                               L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
                   
   
   
   
   L_INSERT_EVENT := TRUE;
   IF UNAPIEV.P_EV_MGR_SESSION AND
      UNAPIEV.P_SCMEGK_PREVIOUS_ME = A_ME AND
      UNAPIEV.P_SCMEGK_PREVIOUS_DETAILS = L_EV_DETAILS THEN
      L_INSERT_EVENT := FALSE;
   END IF;
   UNAPIEV.P_SCMEGK_PREVIOUS_ME := A_ME;
   UNAPIEV.P_SCMEGK_PREVIOUS_DETAILS := L_EV_DETAILS;
   
   L_EVENT_TP := 'MeGroupKeyUpdated';
   IF L_INSERT_EVENT AND 
      (NOT UNAPIEV.P_EV_MGR_SESSION) THEN

      UPDATE UTSCME
      SET ALLOW_MODIFY = '#'
      WHERE SC = A_SC
         AND PG = A_PG
         AND PGNODE = A_PGNODE
         AND PA = A_PA
         AND PANODE = A_PANODE
         AND ME = A_ME
         AND MENODE = A_MENODE;

      IF SQL%ROWCOUNT < 1 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR ;
      END IF;

      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'sc=' || A_SC ||
                      '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                      '#menode=' || TO_CHAR(A_MENODE) ||
                      '#gk=' || A_GK || '#gk_version=' || A_GK_VERSION ||
                      '#mt_version=' || L_MT_VERSION;

      L_RESULT := UNAPIEV.INSERTEVENT('Save1ScMeGroupKey', UNAPIGEN.P_EVMGR_NAME,
                                      'me', A_ME, L_LC, L_LC_VERSION, L_SS,
                                      L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
   ELSE
      L_EV_SEQ_NR := 0;   
   END IF;

   
   IF (L_EV_SEQ_NR = 0) OR (L_EV_SEQ_NR = 1) THEN
      L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
      IF L_RET_CODE <> 0 THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

   IF (L_LOG_HS = '1') AND (UNAPIGEN.P_LOG_GK_HS = '1') THEN
      INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, WHAT,
                           WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_USER,
             UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
             'method "'||A_ME||'" group key "'||A_GK||'" is created/updated.', 
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_SEQ := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_SEQ := L_HS_SEQ + 1;
      INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
             UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
             'method "'||A_ME||'" group key "'||A_GK||'" is created/updated.');
   END IF;   

   L_LAST_SEQ := 499;
   L_ME_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_MEGK IN L_GK_CURSOR LOOP
      L_GK_FOUND := FALSE;
      FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
         IF (L_MEGK.VALUE = A_VALUE(L_SEQ_NO) OR
             (L_MEGK.VALUE IS NULL AND A_VALUE(L_SEQ_NO) IS NULL)) THEN
            L_GK_HANDLE(L_SEQ_NO) := FALSE;
            L_GK_FOUND := TRUE;
            EXIT;
         END IF;
      END LOOP;

      IF NOT L_GK_FOUND THEN
         DELETE FROM UTSCMEGK
         WHERE SC = A_SC
            AND PG = A_PG
            AND PGNODE = A_PGNODE
            AND PA = A_PA
            AND PANODE = A_PANODE
            AND ME = A_ME
            AND MENODE = A_MENODE
            AND GK = A_GK
            AND VALUE = L_MEGK.VALUE;

         IF L_MEGK.VALUE IS NULL THEN
            DELETE FROM UTSCMEGK
            WHERE SC = A_SC
              AND PG = A_PG
              AND PGNODE = A_PGNODE
              AND PA = A_PA
              AND PANODE = A_PANODE
              AND ME = A_ME
              AND MENODE = A_MENODE
              AND GK = A_GK
              AND VALUE IS NULL;
         END IF;

         IF (L_LOG_HS_DETAILS = '1') THEN
            L_WHAT_DESCRIPTION := 'Groupkey "'||A_GK||'" with value "'||L_MEGK.VALUE||'" is removed from method "'||A_ME||'".';
            L_HS_SEQ := L_HS_SEQ + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_TR_SEQ, 
                   L_EV_SEQ_NR, L_HS_SEQ, L_WHAT_DESCRIPTION);
         END IF;   

         L_SQL_STRING := 'DELETE FROM utscmegk' || A_GK ||
                         ' WHERE sc = :sc' || 
                         ' AND pg = :pg' ||  
                         ' AND pgnode = :pgnode' || 
                         ' AND pa = :pa' || 
                         ' AND panode = :panode' || 
                         ' AND me = :me' || 
                         ' AND menode = :menode' || 
                         ' AND ' || A_GK || '= :value '; 
         BEGIN
            DBMS_SQL.PARSE(L_ME_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':sc' , A_SC); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pg' , A_PG); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pgnode' , A_PGNODE); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pa' , A_PA); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':panode' , A_PANODE); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':me' , A_ME); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':menode' , A_MENODE); 
            DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':value' , L_MEGK.VALUE); 
            L_RESULT := DBMS_SQL.EXECUTE(L_ME_CURSOR);
         EXCEPTION
         WHEN TABLE_DOES_NOT_EXIST THEN
            
            
            NULL;
         END;
      ELSE      
         L_LAST_SEQ := L_MEGK.GKSEQ;         
      END IF;
   END LOOP;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF L_GK_HANDLE(L_SEQ_NO) THEN
         L_SKIP := FALSE; 
         IF NVL(A_VALUE(L_SEQ_NO), ' ') <> ' ' THEN
            L_SQL_STRING := 'INSERT INTO utscmegk'||A_GK||
                            ' ('||A_GK||', sc, pg, pgnode, pa, panode, me, menode)'||
                            ' VALUES(:value, :sc, :pg, :pgnode, :pa, :panode, :me, :menode)' ;
            BEGIN
               DBMS_SQL.PARSE(L_ME_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':sc' , A_SC); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pg' , A_PG); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pgnode' , A_PGNODE); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':pa' , A_PA); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':panode' , A_PANODE); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':me' , A_ME); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':menode' , A_MENODE); 
               DBMS_SQL.BIND_VARIABLE(L_ME_CURSOR, ':value' , A_VALUE(L_SEQ_NO)); 
               L_RESULT := DBMS_SQL.EXECUTE(L_ME_CURSOR);
            EXCEPTION
            WHEN TABLE_DOES_NOT_EXIST THEN
               
               
               NULL;
            WHEN DUP_VAL_ON_INDEX THEN
               L_SKIP := TRUE;
            END;
         END IF;

         IF NOT L_SKIP THEN
            L_LAST_SEQ := L_LAST_SEQ+1;

            
            INSERT INTO UTSCMEGK
            (SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
             GK, GKSEQ, VALUE)
            VALUES
            (A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE,
             A_GK, L_LAST_SEQ, A_VALUE(L_SEQ_NO));

            IF (L_LOG_HS_DETAILS = '1') THEN
               L_WHAT_DESCRIPTION := 'Groupkey "'||A_GK||'" is added to method "'||A_ME||'", value is "'||A_VALUE(L_SEQ_NO)||'".';
               L_HS_SEQ := L_HS_SEQ + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
               VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_TR_SEQ, 
                      L_EV_SEQ_NR, L_HS_SEQ, L_WHAT_DESCRIPTION);
            END IF;   
         END IF;
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_ME_CURSOR);
     
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   IF DBMS_SQL.IS_OPEN(L_ME_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_ME_CURSOR);
   END IF;
   UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_UNIQUEGK;
   
   
   L_RESULT := UNAPIGEN.ENDTXN;
   RETURN(UNAPIGEN.P_TXN_ERROR);
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('Save1ScMeGroupKey', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('Save1ScMeGroupKey', L_SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_ME_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_ME_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'Save1ScMeGroupKey'));
END SAVE1SCMEGROUPKEY;

FUNCTION GETSCMEATTRIBUTE
(A_SC                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE             OUT   UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE             OUT   UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE             OUT   UNAPIGEN.LONG_TABLE_TYPE,  
 A_AU                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_AU_VERSION         OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_VALUE              OUT   UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCRIPTION        OUT   UNAPIGEN.VC40_TABLE_TYPE,  
 A_IS_PROTECTED       OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SINGLE_VALUED      OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NEW_VAL_ALLOWED    OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_STORE_DB           OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_VALUE_LIST_TP      OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_RUN_MODE           OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SERVICE            OUT   UNAPIGEN.VC255_TABLE_TYPE, 
 A_CF_VALUE           OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_NR_OF_ROWS         IN OUT NUMBER,                   
 A_WHERE_CLAUSE       IN     VARCHAR2)                 
RETURN NUMBER IS

L_AU                             VARCHAR2(20);
L_AU_VERSION                     VARCHAR2(20);
L_SC                             VARCHAR2(20);
L_PG                             VARCHAR2(20);
L_PGNODE                         NUMBER(9);
L_PA                             VARCHAR2(20);
L_PANODE                         NUMBER(9);
L_ME                             VARCHAR2(20);
L_MENODE                         NUMBER(9);
L_VALUE                          VARCHAR2(40);
L_DESCRIPTION                    VARCHAR2(40);
L_IS_PROTECTED                   CHAR(1);
L_SINGLE_VALUED                  CHAR(1);
L_NEW_VAL_ALLOWED                CHAR(1);
L_STORE_DB                       CHAR(1);
L_VALUE_LIST_TP                  CHAR(1);
L_RUN_MODE                       CHAR(1);
L_SERVICE                        VARCHAR2(255);
L_CF_VALUE                       VARCHAR2(20);
L_BIND_SCME_SELECTION            BOOLEAN;
L_BIND_FIXED_SC_FLAG             BOOLEAN;

BEGIN

   L_BIND_SCME_SELECTION := FALSE;
   L_BIND_FIXED_SC_FLAG := FALSE;
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
   ELSIF A_WHERE_CLAUSE = 'SELECTION' THEN
      IF UNAPIME.P_SELECTION_CLAUSE IS NOT NULL THEN 
         IF INSTR(UPPER(UNAPIME.P_SELECTION_CLAUSE), ' WHERE ') <> 0 THEN       
            L_WHERE_CLAUSE := ','||UNAPIME.P_SELECTION_CLAUSE|| 
                              ' AND a.sc=au.sc AND a.pg=au.pg AND a.pgnode=au.pgnode ' ||
                              'AND a.pa=au.pa AND a.panode=au.panode ' ||
                              'AND a.me=au.me AND a.menode=au.menode ' ||
                              'ORDER BY au.sc, au.pgnode, au.panode, au.menode, au.auseq';
         ELSE
            L_WHERE_CLAUSE := ','||UNAPIME.P_SELECTION_CLAUSE||  
                              ' WHERE a.sc=au.sc AND a.pg=au.pg AND a.pgnode=au.pgnode ' ||
                              'AND a.pa=au.pa AND a.panode=au.panode ' ||
                              'AND a.me=au.me AND a.menode=au.menode ' ||
                              'ORDER BY au.sc, au.pgnode, au.panode, au.menode, au.auseq';
         END IF;
         L_BIND_SCME_SELECTION := TRUE;
      ELSE
         L_WHERE_CLAUSE := 'ORDER BY au.sc,au.pgnode,au.panode,au.menode,au.auseq'; 
      END IF;
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_BIND_FIXED_SC_FLAG := TRUE;
      L_WHERE_CLAUSE := 'WHERE au.sc = :sc_val ORDER BY au.pgnode, au.panode, au.menode, au.auseq';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_SQL_STRING := 'SELECT au.sc, au.pg, au.pgnode, au.pa, au.panode, au.me, au.menode, au.au, au.au_version, '||
                   'au.value FROM dd' || UNAPIGEN.P_DD || '.uvscmeau au ' || L_WHERE_CLAUSE;

   IF NOT DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
   
      L_AU_CURSOR := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      IF L_BIND_SCME_SELECTION THEN
         FOR L_X IN 1..UNAPIME.P_SELECTION_VAL_TAB.COUNT() LOOP
            DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':col_val'||L_X , UNAPIME.P_SELECTION_VAL_TAB(L_X)); 
         END LOOP;
      ELSIF L_BIND_FIXED_SC_FLAG THEN
         DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':sc_val' , A_WHERE_CLAUSE); 
      END IF;
      
      DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 1, L_SC, 20);
      DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 2, L_PG, 20);
      DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 3, L_PGNODE);
      DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 4, L_PA, 20);
      DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 5, L_PANODE);
      DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 6, L_ME, 20);
      DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 7, L_MENODE);
      DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 8, L_AU, 20);
      DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 9, L_AU_VERSION, 20);
      DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 10, L_VALUE, 40);
      L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
   END IF;
   
   L_RESULT := DBMS_SQL.FETCH_ROWS(L_AU_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP

      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 1, L_SC);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 2, L_PG);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 3, L_PGNODE);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 4, L_PA);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 5, L_PANODE);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 6, L_ME);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 7, L_MENODE);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 8, L_AU);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 9, L_AU_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 10, L_VALUE);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_SC(L_FETCHED_ROWS) := L_SC;
      A_PG(L_FETCHED_ROWS) := L_PG;
      A_PGNODE(L_FETCHED_ROWS) := L_PGNODE;
      A_PA(L_FETCHED_ROWS) := L_PA;
      A_PANODE(L_FETCHED_ROWS) := L_PANODE;
      A_ME(L_FETCHED_ROWS) := L_ME;
      A_MENODE(L_FETCHED_ROWS) := L_MENODE;
      A_AU(L_FETCHED_ROWS) := L_AU;
      A_AU_VERSION(L_FETCHED_ROWS) := L_AU_VERSION;
      A_VALUE(L_FETCHED_ROWS) := L_VALUE;

      OPEN UNAPIGEN.L_AUDET_CURSOR(L_AU, L_AU_VERSION);
      FETCH UNAPIGEN.L_AUDET_CURSOR
      INTO L_DESCRIPTION, L_IS_PROTECTED, L_SINGLE_VALUED,
           L_NEW_VAL_ALLOWED, L_STORE_DB, L_VALUE_LIST_TP, L_RUN_MODE,
           L_SERVICE, L_CF_VALUE;
      IF UNAPIGEN.L_AUDET_CURSOR%NOTFOUND THEN
         
         
         
         A_DESCRIPTION(L_FETCHED_ROWS)     := L_AU;
         A_IS_PROTECTED(L_FETCHED_ROWS)    := '1';
         A_SINGLE_VALUED(L_FETCHED_ROWS)   := '1';
         A_NEW_VAL_ALLOWED(L_FETCHED_ROWS) := '0';
         A_STORE_DB(L_FETCHED_ROWS)        := '0';
         A_VALUE_LIST_TP(L_FETCHED_ROWS)   := 'E';
         A_RUN_MODE(L_FETCHED_ROWS)        := 'H';
         A_SERVICE(L_FETCHED_ROWS)         := NULL;
         A_CF_VALUE(L_FETCHED_ROWS)        := NULL;
      ELSE      
         A_DESCRIPTION(L_FETCHED_ROWS) := L_DESCRIPTION;
         A_IS_PROTECTED(L_FETCHED_ROWS) := L_IS_PROTECTED;
         A_SINGLE_VALUED(L_FETCHED_ROWS) := L_SINGLE_VALUED;
         A_NEW_VAL_ALLOWED(L_FETCHED_ROWS) := L_NEW_VAL_ALLOWED;
         A_STORE_DB(L_FETCHED_ROWS) := L_STORE_DB;
         A_VALUE_LIST_TP(L_FETCHED_ROWS) := L_VALUE_LIST_TP;
         A_RUN_MODE(L_FETCHED_ROWS) := L_RUN_MODE;
         A_SERVICE(L_FETCHED_ROWS) := L_SERVICE;
         A_CF_VALUE(L_FETCHED_ROWS) := L_CF_VALUE;
      END IF;
      CLOSE UNAPIGEN.L_AUDET_CURSOR;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_AU_CURSOR);
      END IF;
   END LOOP;

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
      DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
   ELSE   
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   IF A_WHERE_CLAUSE <> 'SELECTION' AND
      DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'GetScMeAttribute', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF UNAPIGEN.L_AUDET_CURSOR%ISOPEN THEN
         CLOSE UNAPIGEN.L_AUDET_CURSOR;
      END IF;
      IF DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETSCMEATTRIBUTE;

FUNCTION SAVESCMEATTRIBUTE
(A_SC             IN        VARCHAR2,                 
 A_PG             IN        VARCHAR2,                 
 A_PGNODE         IN        NUMBER,                   
 A_PA             IN        VARCHAR2,                 
 A_PANODE         IN        NUMBER,                   
 A_ME             IN        VARCHAR2,                 
 A_MENODE         IN        NUMBER,                   
 A_AU             IN        UNAPIGEN.VC20_TABLE_TYPE, 
 A_AU_VERSION     IN OUT    UNAPIGEN.VC20_TABLE_TYPE, 
 A_VALUE          IN        UNAPIGEN.VC40_TABLE_TYPE, 
 A_NR_OF_ROWS     IN        NUMBER,                   
 A_MODIFY_REASON  IN        VARCHAR2)                 
RETURN NUMBER IS

L_SC                VARCHAR2(20);
L_PG                VARCHAR2(20);
L_PGNODE            NUMBER(9);
L_PA                VARCHAR2(20);
L_PANODE            NUMBER(9);
L_ME                VARCHAR2(20);
L_MENODE            NUMBER(9);
L_AU                VARCHAR2(20);
L_VALUE             VARCHAR2(40);
L_AU_CURSOR         INTEGER;
L_ALLOW_MODIFY      CHAR(1);
L_AUSEQ             NUMBER;
L_LOG_HS            CHAR(1);
L_LOG_HS_DETAILS    CHAR(1);
L_ACTIVE            CHAR(1);
L_LC                VARCHAR2(2);
L_LC_VERSION        VARCHAR2(20);
L_SS                VARCHAR2(2);
L_WHAT_DESCRIPTION  VARCHAR2(255);
L_HS_SEQ            INTEGER;
L_MT_VERSION        VARCHAR2(20);

CURSOR L_MODIFIEDAU_CURSOR IS
   
   (SELECT A.AU AU, A.AU_VERSION AU_VERSION, A.VALUE VALUE, 'DELETE' ACTION
    FROM UTSCMEAU A
    WHERE A.SC = A_SC
    AND A.PG = A_PG
    AND A.PGNODE = A_PGNODE
    AND A.PA = A_PA
    AND A.PANODE = A_PANODE
    AND A.ME = A_ME
    AND A.MENODE = A_MENODE
    AND AUSEQ < 0
   MINUS
    SELECT A.AU AU, A.AU_VERSION AU_VERSION, A.VALUE VALUE, 'DELETE' ACTION
    FROM UTSCMEAU A
    WHERE A.SC = A_SC
    AND A.PG = A_PG
    AND A.PGNODE = A_PGNODE
    AND A.PA = A_PA
    AND A.PANODE = A_PANODE
    AND A.ME = A_ME
    AND A.MENODE = A_MENODE
    AND AUSEQ > 0)
   UNION ALL
   
   (SELECT A.AU AU, A.AU_VERSION AU_VERSION, A.VALUE VALUE, 'NEW' ACTION
    FROM UTSCMEAU A
    WHERE A.SC = A_SC
    AND A.PG = A_PG
    AND A.PGNODE = A_PGNODE
    AND A.PA = A_PA
    AND A.PANODE = A_PANODE
    AND A.ME = A_ME
    AND A.MENODE = A_MENODE
    AND AUSEQ > 0
   MINUS
    SELECT A.AU AU, A.AU_VERSION AU_VERSION, A.VALUE VALUE, 'NEW' ACTION
    FROM UTSCMEAU A
    WHERE A.SC = A_SC
    AND A.PG = A_PG
    AND A.PGNODE = A_PGNODE
    AND A.PA = A_PA
    AND A.PANODE = A_PANODE
    AND A.ME = A_ME
    AND A.MENODE = A_MENODE
    AND AUSEQ < 0);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;


   IF NVL(A_NR_OF_ROWS, -1) < 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NROFROWS;
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_PG, ' ') = ' ' OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_MENODE, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;


   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                                               NULL, L_MT_VERSION, L_LC, L_LC_VERSION, L_SS, 
                                               L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTSCME
   SET ALLOW_MODIFY = '#'
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;
   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   
   
   
   UPDATE UTSCMEAU
   SET AUSEQ = -AUSEQ
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_AU(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;
      
      INSERT INTO UTSCMEAU(SC, PG, PGNODE, PA, PANODE, ME, MENODE, AU,
                           AUSEQ, VALUE)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE,
             A_AU(L_SEQ_NO), L_SEQ_NO, A_VALUE(L_SEQ_NO));
   END LOOP;

   L_EVENT_TP := 'MeAttributesUpdated';
   L_EV_DETAILS := 'sc=' || A_SC ||
                   '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                   '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                   '#menode=' || TO_CHAR(A_MENODE) ||
                   '#mt_version=' || L_MT_VERSION;
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveScMeAttribute', UNAPIGEN.P_EVMGR_NAME, 'me', A_ME, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF(L_LOG_HS = '1') THEN
       INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                            WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
       VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_USER, 
              UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'method "'||A_ME||'" attributes are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_SEQ := 0;
   IF(L_LOG_HS_DETAILS = '1') THEN
       L_HS_SEQ := L_HS_SEQ + 1;
       INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
       VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
              UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
              'method "'||A_ME||'" attributes are updated.');
   END IF;

   
   
      
   
   
   
   IF (L_LOG_HS_DETAILS = '1') THEN
      FOR L_AU_REC IN L_MODIFIEDAU_CURSOR LOOP
         IF L_AU_REC.ACTION = 'DELETE' THEN
            L_WHAT_DESCRIPTION := 'Attribute "'||L_AU_REC.AU||'" with value "'||L_AU_REC.VALUE||'" is removed from method "'||A_ME||'".';            
         ELSE
            L_WHAT_DESCRIPTION := 'Attribute "'||L_AU_REC.AU||'" is added to method "'||A_ME||'", value is "'||L_AU_REC.VALUE||'".';
         END IF;
         L_HS_SEQ := L_HS_SEQ + 1;
         INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_TR_SEQ, 
                L_EV_SEQ_NR, L_HS_SEQ, L_WHAT_DESCRIPTION);
      END LOOP;
   END IF;
  
   
   
   
   DELETE FROM UTSCMEAU
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE
   AND AUSEQ < 0;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveScMeAttribute', SQLERRM);
   END IF;
   IF L_MODIFIEDAU_CURSOR%ISOPEN THEN
      CLOSE L_MODIFIEDAU_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveScMeAttribute'));
END SAVESCMEATTRIBUTE;

FUNCTION SAVE1SCMEATTRIBUTE
(A_SC             IN        VARCHAR2,                 
 A_PG             IN        VARCHAR2,                 
 A_PGNODE         IN        NUMBER,                   
 A_PA             IN        VARCHAR2,                 
 A_PANODE         IN        NUMBER,                   
 A_ME             IN        VARCHAR2,                 
 A_MENODE         IN        NUMBER,                   
 A_AU             IN        VARCHAR2,                 
 A_AU_VERSION     IN OUT    VARCHAR2,                 
 A_VALUE          IN        UNAPIGEN.VC40_TABLE_TYPE, 
 A_NR_OF_ROWS     IN        NUMBER,                   
 A_MODIFY_REASON  IN        VARCHAR2)                 
RETURN NUMBER IS

L_LC                VARCHAR2(2);
L_LC_VERSION        VARCHAR2(20);
L_SS                VARCHAR2(2);
L_LOG_HS            CHAR(1);
L_LOG_HS_DETAILS    CHAR(1);
L_ALLOW_MODIFY      CHAR(1);
L_ACTIVE            CHAR(1);
L_NEW_SEQ           NUMBER;
L_AU_HANDLE         BOOLEAN_TABLE_TYPE;
L_AU_FOUND          BOOLEAN;
L_INSERT_EVENT      BOOLEAN;
L_LAST_SEQ          INTEGER;
L_WHAT_DESCRIPTION  VARCHAR2(255);
L_HS_SEQ            INTEGER;
L_MT_VERSION        VARCHAR2(20);

CURSOR L_AU_CURSOR IS
   SELECT VALUE, AUSEQ
   FROM UTSCMEAU
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE
      AND AU = A_AU
   ORDER BY AUSEQ;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> 
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_AU, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_MENODE, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      L_AU_HANDLE(L_SEQ_NO) := TRUE;
   END LOOP;

   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, 
                                               A_MENODE, NULL, L_MT_VERSION, L_LC, L_LC_VERSION, 
                                               L_SS, L_ALLOW_MODIFY, L_ACTIVE,
                                               L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTSCME
   SET ALLOW_MODIFY = '#'
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   L_EVENT_TP := 'MeAttributesUpdated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'sc=' || A_SC ||
                   '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                   '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                   '#menode=' || TO_CHAR(A_MENODE) ||
                   '#au=' || A_AU || '#au_version=' || A_AU_VERSION ||
                   '#mt_version=' || L_MT_VERSION;
                   
   L_RESULT := UNAPIEV.INSERTEVENT('Save1ScMeAttribute', UNAPIGEN.P_EVMGR_NAME,
                                   'me', A_ME, L_LC, L_LC_VERSION, L_SS,
                                   L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, WHAT,
                           WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_USER,
             UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
             'method "'||A_ME||'" attribute "'||A_AU||'" is created/updated.', 
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_SEQ := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_SEQ := L_HS_SEQ + 1;
      INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
             UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_SEQ, 
             'method "'||A_ME||'" attribute "'||A_AU||'" is created/updated.');
   END IF;   

   L_LAST_SEQ := 499;
   FOR L_MEAU IN L_AU_CURSOR LOOP
      L_AU_FOUND := FALSE;
      FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
         IF (L_MEAU.VALUE = A_VALUE(L_SEQ_NO) OR
             (L_MEAU.VALUE IS NULL AND A_VALUE(L_SEQ_NO) IS NULL)) THEN
            L_AU_HANDLE(L_SEQ_NO) := FALSE;
            L_AU_FOUND := TRUE;
            EXIT;
         END IF;
      END LOOP;

      IF NOT L_AU_FOUND THEN
         DELETE FROM UTSCMEAU
         WHERE SC = A_SC
            AND PG = A_PG
            AND PGNODE = A_PGNODE
            AND PA = A_PA
            AND PANODE = A_PANODE
            AND ME = A_ME
            AND MENODE = A_MENODE
            AND AU = A_AU
            AND VALUE = L_MEAU.VALUE;

         IF L_MEAU.VALUE IS NULL THEN
            DELETE FROM UTSCMEAU
            WHERE SC = A_SC
              AND PG = A_PG
              AND PGNODE = A_PGNODE
              AND PA = A_PA
              AND PANODE = A_PANODE
              AND ME = A_ME
              AND MENODE = A_MENODE
              AND AU = A_AU
              AND VALUE IS NULL;
         END IF;

         IF (L_LOG_HS_DETAILS = '1') THEN
            L_WHAT_DESCRIPTION := 'Attribute "'||A_AU||'" with value "'||L_MEAU.VALUE||'" is removed from method "'||A_ME||'".';
            L_HS_SEQ := L_HS_SEQ + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_TR_SEQ, 
                   L_EV_SEQ_NR, L_HS_SEQ, L_WHAT_DESCRIPTION);
         END IF;   
      ELSE      
         L_LAST_SEQ := L_MEAU.AUSEQ;         
      END IF;
   END LOOP;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF L_AU_HANDLE(L_SEQ_NO) THEN
         L_LAST_SEQ := L_LAST_SEQ+1;

         
         INSERT INTO UTSCMEAU
         (SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
          AU, AUSEQ, VALUE)
         VALUES
         (A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE,
          A_AU, L_LAST_SEQ, A_VALUE(L_SEQ_NO));

         IF (L_LOG_HS_DETAILS = '1') THEN
            L_WHAT_DESCRIPTION := 'Attribute "'||A_AU||'" is added to method "'||A_ME||'", value is "'||A_VALUE(L_SEQ_NO)||'".';
            L_HS_SEQ := L_HS_SEQ + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_TR_SEQ, 
                   L_EV_SEQ_NR, L_HS_SEQ, L_WHAT_DESCRIPTION);
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
      UNAPIGEN.LOGERROR('Save1ScMeAttribute', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('Save1ScMeAttribute', L_SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'Save1ScMeAttribute'));
END SAVE1SCMEATTRIBUTE;

FUNCTION INITANDSAVESCMEATTRIBUTES
(A_SC               IN      VARCHAR2,                  
 A_PG               IN      VARCHAR2,                  
 A_PGNODE           IN      NUMBER,                    
 A_PA               IN      VARCHAR2,                  
 A_PANODE           IN      NUMBER,                    
 A_ME               IN      VARCHAR2,                  
 A_MENODE           IN      NUMBER)                    
RETURN NUMBER IS

BEGIN
   RETURN(UNAPIMEP2.INITANDSAVESCMEATTRIBUTES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE));
END INITANDSAVESCMEATTRIBUTES;

FUNCTION GETSCMEHISTORY 
(A_SC                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE            OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE            OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE            OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_WHO               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_WHO_DESCRIPTION   OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_WHAT              OUT     UNAPIGEN.VC60_TABLE_TYPE,  
 A_WHAT_DESCRIPTION  OUT     UNAPIGEN.VC255_TABLE_TYPE, 
 A_LOGDATE           OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_WHY               OUT     UNAPIGEN.VC255_TABLE_TYPE, 
 A_TR_SEQ            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_EV_SEQ            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS        IN OUT  NUMBER,                    
 A_WHERE_CLAUSE      IN      VARCHAR2)                  
RETURN NUMBER IS

L_NR_OF_ROWS_IN               INTEGER;
L_NR_OF_ROWS_OUT              INTEGER;


L_SC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_PG_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_PGNODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
L_PA_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_PANODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
L_ME_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_MENODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
L_WHO_TAB                     UNAPIGEN.VC20_TABLE_TYPE;
L_WHO_DESCRIPTION_TAB         UNAPIGEN.VC40_TABLE_TYPE;
L_WHAT_TAB                    UNAPIGEN.VC60_TABLE_TYPE;
L_WHAT_DESCRIPTION_TAB        UNAPIGEN.VC255_TABLE_TYPE;
L_LOGDATE_TAB                 UNAPIGEN.DATE_TABLE_TYPE;
L_WHY_TAB                     UNAPIGEN.VC255_TABLE_TYPE;
L_TR_SEQ_TAB                  UNAPIGEN.NUM_TABLE_TYPE;
L_EV_SEQ_TAB                  UNAPIGEN.NUM_TABLE_TYPE;

BEGIN
   L_NR_OF_ROWS_IN := A_NR_OF_ROWS;
   L_NR_OF_ROWS_OUT := L_NR_OF_ROWS_IN;
   L_RET_CODE := GETSCMEHISTORY(A_SC,
                                A_PG,
                                A_PGNODE,
                                A_PA,
                                A_PANODE,
                                A_ME,
                                A_MENODE,
                                A_WHO,             
                                A_WHO_DESCRIPTION,
                                A_WHAT,            
                                A_WHAT_DESCRIPTION,
                                A_LOGDATE,         
                                A_WHY,             
                                A_TR_SEQ,          
                                A_EV_SEQ,          
                                L_NR_OF_ROWS_OUT,      
                                A_WHERE_CLAUSE,
                                0);
    IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
       RETURN(L_RET_CODE);
    ELSE
       A_NR_OF_ROWS := L_NR_OF_ROWS_OUT;
       IF L_NR_OF_ROWS_OUT = L_NR_OF_ROWS_IN THEN
          
          L_RET_CODE := GETSCMEHISTORY(L_SC_TAB,             
                                       L_PG_TAB,
                                       L_PGNODE_TAB,
                                       L_PA_TAB,
                                       L_PANODE_TAB,
                                       L_ME_TAB,
                                       L_MENODE_TAB,
                                       L_WHO_TAB,
                                       L_WHO_DESCRIPTION_TAB,
                                       L_WHAT_TAB,
                                       L_WHAT_DESCRIPTION_TAB,
                                       L_LOGDATE_TAB,
                                       L_WHY_TAB,
                                       L_TR_SEQ_TAB,
                                       L_EV_SEQ_TAB,
                                       L_NR_OF_ROWS_OUT,      
                                       A_WHERE_CLAUSE,
                                       -1);
          IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
             RETURN(L_RET_CODE);
          END IF;
       END IF;
    END IF;
    RETURN(L_RET_CODE);
                              
EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
          'GetScMeHistory', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETSCMEHISTORY;

FUNCTION GETSCMEHISTORY
(A_SC                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE            OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE            OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME                OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE            OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_WHO               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_WHO_DESCRIPTION   OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_WHAT              OUT     UNAPIGEN.VC60_TABLE_TYPE,  
 A_WHAT_DESCRIPTION  OUT     UNAPIGEN.VC255_TABLE_TYPE, 
 A_LOGDATE           OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_WHY               OUT     UNAPIGEN.VC255_TABLE_TYPE, 
 A_TR_SEQ            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_EV_SEQ            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS        IN OUT  NUMBER,                    
 A_WHERE_CLAUSE      IN      VARCHAR2,                  
 A_NEXT_ROWS         IN      NUMBER)                    
RETURN NUMBER IS

L_SC                VARCHAR2(20);
L_PG                VARCHAR2(20);
L_PGNODE            NUMBER(9);
L_PA                VARCHAR2(20);
L_PANODE            NUMBER(9);
L_ME                VARCHAR2(20);
L_MENODE            NUMBER(9);
L_WHO               VARCHAR2(20);
L_WHO_DESCRIPTION   VARCHAR2(40);
L_WHAT              VARCHAR2(60);
L_WHAT_DESCRIPTION  VARCHAR2(255);
L_LOGDATE           TIMESTAMP WITH TIME ZONE;
L_WHY               VARCHAR2(255);
L_TR_SEQ            NUMBER;
L_EV_SEQ            NUMBER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_NEXT_ROWS, 0) NOT IN (-1, 0, 1) THEN
      RETURN(UNAPIGEN.DBERR_NEXTROWS);
   END IF;

   
   IF A_NEXT_ROWS = -1 THEN
      IF DBMS_SQL.IS_OPEN(P_HS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(P_HS_CURSOR);
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_HS_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN
      
      IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
      ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
         L_WHERE_CLAUSE := 'WHERE sc = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                           ''' ORDER BY pgnode, panode, menode, logdate DESC';
      ELSE
         L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
      END IF;
      
      L_WHERE_CLAUSE := REPLACE(REPLACE(L_WHERE_CLAUSE, 
                                        'logdate DESC', 
                                        'logdate DESC, ROWID DESC'),
                                'LOGDATE DESC', 
                                'LOGDATE DESC, ROWID DESC');

      IF DBMS_SQL.IS_OPEN(P_HS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(P_HS_CURSOR);
      END IF;
      P_HS_CURSOR := DBMS_SQL.OPEN_CURSOR;
      L_SQL_STRING := 'SELECT sc, pg, pgnode, pa, panode, me, menode, '||
                      'who, who_description, what, what_description, logdate, why, tr_seq, ev_seq '||
                      'FROM dd' || UNAPIGEN.P_DD || '.uvscmehs ' || L_WHERE_CLAUSE;
      DBMS_SQL.PARSE(P_HS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 1, L_SC, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 2, L_PG, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 3, L_PGNODE);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 4, L_PA, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 5, L_PANODE);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 6, L_ME, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 7, L_MENODE);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 8, L_WHO, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 9, L_WHO_DESCRIPTION, 40);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 10, L_WHAT, 60);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 11, L_WHAT_DESCRIPTION, 255);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 12, L_LOGDATE);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 13, L_WHY, 255);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 14, L_TR_SEQ);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 15, L_EV_SEQ);
      L_RESULT := DBMS_SQL.EXECUTE(P_HS_CURSOR);
   END IF;
   
   L_RESULT := DBMS_SQL.FETCH_ROWS(P_HS_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 1, L_SC);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 2, L_PG);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 3, L_PGNODE);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 4, L_PA);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 5, L_PANODE);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 6, L_ME);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 7, L_MENODE);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 8, L_WHO);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 9, L_WHO_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 10,L_WHAT);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 11,L_WHAT_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 12,L_LOGDATE);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 13,L_WHY);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 14,L_TR_SEQ);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 15,L_EV_SEQ);
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_SC(L_FETCHED_ROWS)               := L_SC;
      A_PG(L_FETCHED_ROWS)               := L_PG;
      A_PGNODE(L_FETCHED_ROWS)           := L_PGNODE;
      A_PA(L_FETCHED_ROWS)               := L_PA;
      A_PANODE(L_FETCHED_ROWS)           := L_PANODE;
      A_ME(L_FETCHED_ROWS)               := L_ME;
      A_MENODE(L_FETCHED_ROWS)           := L_MENODE;
      A_WHO(L_FETCHED_ROWS)              := L_WHO;
      A_WHO_DESCRIPTION(L_FETCHED_ROWS)  := L_WHO_DESCRIPTION;
      A_WHAT(L_FETCHED_ROWS)             := L_WHAT;
      A_WHAT_DESCRIPTION(L_FETCHED_ROWS) := L_WHAT_DESCRIPTION;
      A_LOGDATE(L_FETCHED_ROWS)          := TO_CHAR(L_LOGDATE);
      A_WHY(L_FETCHED_ROWS)              := L_WHY;
      A_TR_SEQ(L_FETCHED_ROWS)           := L_TR_SEQ;
      A_EV_SEQ(L_FETCHED_ROWS)           := L_EV_SEQ;
      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_HS_CURSOR);
      END IF;
   END LOOP;

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
      DBMS_SQL.CLOSE_CURSOR(P_HS_CURSOR);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      DBMS_SQL.CLOSE_CURSOR(P_HS_CURSOR);
   ELSE
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;
   RETURN(L_RET_CODE);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'GetScMeHistory', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(P_HS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(P_HS_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETSCMEHISTORY;

FUNCTION GETSCMEHISTORYDETAILS 
(A_SC                OUT     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PG                OUT     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PGNODE            OUT     UNAPIGEN.LONG_TABLE_TYPE,    
 A_PA                OUT     UNAPIGEN.VC20_TABLE_TYPE,    
 A_PANODE            OUT     UNAPIGEN.LONG_TABLE_TYPE,    
 A_ME                OUT     UNAPIGEN.VC20_TABLE_TYPE,    
 A_MENODE            OUT     UNAPIGEN.LONG_TABLE_TYPE,    
 A_TR_SEQ            OUT     UNAPIGEN.NUM_TABLE_TYPE,     
 A_EV_SEQ            OUT     UNAPIGEN.NUM_TABLE_TYPE,     
 A_SEQ               OUT     UNAPIGEN.NUM_TABLE_TYPE,     
 A_DETAILS           OUT     UNAPIGEN.VC4000_TABLE_TYPE,  
 A_NR_OF_ROWS        IN OUT  NUMBER,                      
 A_WHERE_CLAUSE      IN      VARCHAR2,                    
 A_NEXT_ROWS         IN      NUMBER)                      
RETURN NUMBER IS

L_SC                      VARCHAR2(20);
L_PG                      VARCHAR2(20);
L_PGNODE                  NUMBER(9);
L_PA                      VARCHAR2(20);
L_PANODE                  NUMBER(9);
L_ME                      VARCHAR2(20);
L_MENODE                  NUMBER(9);
L_TR_SEQ                  NUMBER;
L_EV_SEQ                  NUMBER;
L_SEQ                     NUMBER;
L_DETAILS                 VARCHAR2(4000);

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_NEXT_ROWS, 0) NOT IN (-1, 0, 1) THEN
      RETURN(UNAPIGEN.DBERR_NEXTROWS);
   END IF;

   
   IF A_NEXT_ROWS = -1 THEN
      IF DBMS_SQL.IS_OPEN(P_HS_DETAILS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(P_HS_DETAILS_CURSOR);
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_HS_DETAILS_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN

      
      IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
      ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
         L_WHERE_CLAUSE := 'WHERE sc = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                           ''' ORDER BY pgnode, panode, menode, tr_seq DESC, ev_seq DESC, seq DESC';
      ELSE
         L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
      END IF;

      IF DBMS_SQL.IS_OPEN(P_HS_DETAILS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(P_HS_DETAILS_CURSOR);
      END IF;
      P_HS_DETAILS_CURSOR := DBMS_SQL.OPEN_CURSOR;
      L_SQL_STRING := 'SELECT sc, pg, pgnode, pa, panode, me, menode, tr_seq, ev_seq, seq, details '||
                      'FROM dd' || UNAPIGEN.P_DD || '.uvscmehsdetails ' ||
                      L_WHERE_CLAUSE;
      DBMS_SQL.PARSE(P_HS_DETAILS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      DBMS_SQL.DEFINE_COLUMN(P_HS_DETAILS_CURSOR, 1, L_SC, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_DETAILS_CURSOR, 2, L_PG, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_DETAILS_CURSOR, 3, L_PGNODE);
      DBMS_SQL.DEFINE_COLUMN(P_HS_DETAILS_CURSOR, 4, L_PA, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_DETAILS_CURSOR, 5, L_PANODE);
      DBMS_SQL.DEFINE_COLUMN(P_HS_DETAILS_CURSOR, 6, L_ME, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_DETAILS_CURSOR, 7, L_MENODE);
      DBMS_SQL.DEFINE_COLUMN(P_HS_DETAILS_CURSOR, 8, L_TR_SEQ);
      DBMS_SQL.DEFINE_COLUMN(P_HS_DETAILS_CURSOR, 9, L_EV_SEQ);
      DBMS_SQL.DEFINE_COLUMN(P_HS_DETAILS_CURSOR, 10, L_SEQ);
      DBMS_SQL.DEFINE_COLUMN(P_HS_DETAILS_CURSOR, 11, L_DETAILS, 4000);   
      L_RESULT := DBMS_SQL.EXECUTE(P_HS_DETAILS_CURSOR);
   END IF;
   
   L_RESULT := DBMS_SQL.FETCH_ROWS(P_HS_DETAILS_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(P_HS_DETAILS_CURSOR, 1, L_SC);
      DBMS_SQL.COLUMN_VALUE(P_HS_DETAILS_CURSOR, 2, L_PG);
      DBMS_SQL.COLUMN_VALUE(P_HS_DETAILS_CURSOR, 3, L_PGNODE);
      DBMS_SQL.COLUMN_VALUE(P_HS_DETAILS_CURSOR, 4, L_PA);
      DBMS_SQL.COLUMN_VALUE(P_HS_DETAILS_CURSOR, 5, L_PANODE);
      DBMS_SQL.COLUMN_VALUE(P_HS_DETAILS_CURSOR, 6, L_ME);
      DBMS_SQL.COLUMN_VALUE(P_HS_DETAILS_CURSOR, 7, L_MENODE);
      DBMS_SQL.COLUMN_VALUE(P_HS_DETAILS_CURSOR, 8, L_TR_SEQ);
      DBMS_SQL.COLUMN_VALUE(P_HS_DETAILS_CURSOR, 9, L_EV_SEQ);
      DBMS_SQL.COLUMN_VALUE(P_HS_DETAILS_CURSOR, 10, L_SEQ);
      DBMS_SQL.COLUMN_VALUE(P_HS_DETAILS_CURSOR, 11, L_DETAILS);
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_SC(L_FETCHED_ROWS)      := L_SC;
      A_PG(L_FETCHED_ROWS)      := L_PG;
      A_PGNODE(L_FETCHED_ROWS)  := L_PGNODE;
      A_PA(L_FETCHED_ROWS)      := L_PA;
      A_PANODE(L_FETCHED_ROWS)  := L_PANODE;
      A_ME(L_FETCHED_ROWS)      := L_ME;
      A_MENODE(L_FETCHED_ROWS)  := L_MENODE;
      A_TR_SEQ(L_FETCHED_ROWS)  := L_TR_SEQ;
      A_EV_SEQ(L_FETCHED_ROWS)  := L_EV_SEQ;
      A_SEQ(L_FETCHED_ROWS)     := L_SEQ;
      A_DETAILS(L_FETCHED_ROWS) := L_DETAILS;
      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_HS_DETAILS_CURSOR);
      END IF;
   END LOOP;

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
      DBMS_SQL.CLOSE_CURSOR(P_HS_DETAILS_CURSOR);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      DBMS_SQL.CLOSE_CURSOR(P_HS_DETAILS_CURSOR);
   ELSE
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;
   RETURN(L_RET_CODE);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'GetScMeHistoryDetails', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(P_HS_DETAILS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(P_HS_DETAILS_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETSCMEHISTORYDETAILS;

FUNCTION SAVESCMEHISTORY
(A_SC                IN        VARCHAR2,                  
 A_PG                IN        VARCHAR2,                  
 A_PGNODE            IN        NUMBER,                    
 A_PA                IN        VARCHAR2,                  
 A_PANODE            IN        NUMBER,                    
 A_ME                IN        VARCHAR2,                  
 A_MENODE            IN        NUMBER,                    
 A_WHO               IN        UNAPIGEN.VC20_TABLE_TYPE,  
 A_WHO_DESCRIPTION   IN        UNAPIGEN.VC40_TABLE_TYPE,  
 A_WHAT              IN        UNAPIGEN.VC60_TABLE_TYPE,  
 A_WHAT_DESCRIPTION  IN        UNAPIGEN.VC255_TABLE_TYPE, 
 A_LOGDATE           IN        UNAPIGEN.DATE_TABLE_TYPE,  
 A_WHY               IN        UNAPIGEN.VC255_TABLE_TYPE, 
 A_TR_SEQ            IN        UNAPIGEN.NUM_TABLE_TYPE,   
 A_EV_SEQ            IN        UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS        IN        NUMBER)                    
RETURN NUMBER IS

L_ALLOW_MODIFY     CHAR(1);
L_LOG_HS           CHAR(1);
L_LOG_HS_DETAILS   CHAR(1);
L_LC               VARCHAR2(2);
L_LC_VERSION       VARCHAR2(20);
L_SS               VARCHAR2(2);
L_ACTIVE           CHAR(1);
L_MT_VERSION       VARCHAR2(20);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_NR_OF_ROWS, -1) < 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NROFROWS;
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_PG, ' ') = ' ' OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_MENODE, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                                               NULL, L_MT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                               L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS
   LOOP
      UPDATE UTSCMEHS
      SET WHY = A_WHY(L_SEQ_NO)
      WHERE SC = A_SC
         AND PG = A_PG
         AND PGNODE = A_PGNODE
         AND PA = A_PA
         AND PANODE = A_PANODE
         AND ME = A_ME
         AND MENODE = A_MENODE
         AND WHO = A_WHO(L_SEQ_NO)
         AND WHO_DESCRIPTION = A_WHO_DESCRIPTION(L_SEQ_NO)
         AND TO_CHAR(LOGDATE) = A_LOGDATE(L_SEQ_NO)
         AND WHAT = A_WHAT(L_SEQ_NO)
         AND WHAT_DESCRIPTION = A_WHAT_DESCRIPTION(L_SEQ_NO)
         AND TR_SEQ = A_TR_SEQ(L_SEQ_NO)
         AND EV_SEQ = A_EV_SEQ(L_SEQ_NO);
   END LOOP;

   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveScMeHistory', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveScMeHistory'));
END SAVESCMEHISTORY;

FUNCTION ADDSCMECOMMENT
(A_SC           IN  VARCHAR2,                 
 A_PG           IN  VARCHAR2,                 
 A_PGNODE       IN  NUMBER,                   
 A_PA           IN  VARCHAR2,                 
 A_PANODE       IN  NUMBER,                   
 A_ME           IN  VARCHAR2,                 
 A_MENODE       IN  NUMBER,                   
 A_COMMENT      IN  VARCHAR2)                 
RETURN NUMBER IS

L_ALLOW_MODIFY      CHAR(1);
L_LOG_HS            CHAR(1);
L_LOG_HS_DETAILS    CHAR(1);
L_LC                VARCHAR2(2);
L_LC_VERSION        VARCHAR2(20);
L_ACTIVE            CHAR(1);
L_SS                VARCHAR2(2);
L_HS_DETAILS_SEQ_NR INTEGER;
L_OLD_COMMENT       VARCHAR2(255);
L_MT_VERSION        VARCHAR2(20);

CURSOR L_SCMECOMMENTOLD_CURSOR (A_SC IN VARCHAR2, 
                                A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                                A_PA IN VARCHAR2, A_PANODE IN NUMBER,
                                A_ME IN VARCHAR2, A_MENODE IN NUMBER) IS
   SELECT LAST_COMMENT
   FROM UTSCME A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE
     AND A.ME = A_ME
     AND A.MENODE = A_MENODE;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_PG, ' ') = ' ' OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_MENODE, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                                               NULL, L_MT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                               L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   
   
   OPEN L_SCMECOMMENTOLD_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE);
   FETCH L_SCMECOMMENTOLD_CURSOR
   INTO L_OLD_COMMENT;
   CLOSE L_SCMECOMMENTOLD_CURSOR;

   UPDATE UTSCME
   SET LAST_COMMENT = A_COMMENT
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE;
   
   L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
   IF L_RET_CODE <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN   
      INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                           WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_USER,
             UNAPIGEN.P_USER_DESCRIPTION, 'Comment', 
             'comment is added on method "'||A_ME||'"', 
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_COMMENT, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_DETAILS_SEQ_NR := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      IF NVL((L_OLD_COMMENT <> A_COMMENT), TRUE) AND NOT(L_OLD_COMMENT IS NULL AND A_COMMENT IS NULL)  THEN 
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, 
                L_HS_DETAILS_SEQ_NR, 
                'method "'||A_ME||'" is updated: property <last_comment> changed value from "' || SUBSTR(L_OLD_COMMENT,1,40) || '" to "' || SUBSTR(A_COMMENT,1,40) || '".');
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('AddScMeComment', SQLERRM);
   END IF;
   IF L_SCMECOMMENTOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCMECOMMENTOLD_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'AddScMeComment'));
END ADDSCMECOMMENT;

FUNCTION GETSCMECOMMENT
(A_SC               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE           OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE           OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE           OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_LAST_COMMENT     OUT     UNAPIGEN.VC255_TABLE_TYPE, 
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_WHERE_CLAUSE     IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS


BEGIN
   RETURN(UNAPIMEP2.GETSCMECOMMENT(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_LAST_COMMENT, A_NR_OF_ROWS, A_WHERE_CLAUSE, A_NEXT_ROWS));
END GETSCMECOMMENT;

FUNCTION SCMETRANSITIONAUTHORISED          
(A_SC                IN      VARCHAR2,     
 A_PG                IN      VARCHAR2,     
 A_PGNODE            IN      NUMBER,       
 A_PA                IN      VARCHAR2,     
 A_PANODE            IN      NUMBER,       
 A_ME                IN      VARCHAR2,     
 A_MENODE            IN      NUMBER,       
 A_REANALYSIS        IN      NUMBER,       
 A_LC                IN OUT  VARCHAR2,     
 A_LC_VERSION        IN OUT  VARCHAR2,     
 A_OLD_SS            IN OUT  VARCHAR2,     
 A_NEW_SS            IN      VARCHAR2,     
 A_AUTHORISED_BY     IN      VARCHAR2,     
 A_LC_SS_FROM        OUT     VARCHAR2,     
 A_TR_NO             OUT     NUMBER,       
 A_ALLOW_MODIFY      OUT     CHAR,         
 A_ACTIVE            OUT     CHAR,         
 A_LOG_HS            OUT     CHAR,         
 A_LOG_HS_DETAILS    OUT     CHAR)         
RETURN NUMBER IS

L_LC                  VARCHAR2(2);
L_LC_VERSION          VARCHAR2(20);
L_SS                  VARCHAR2(2);
L_OLD_ACTIVE          CHAR(1);
L_OLD_ALLOW_MODIFY    CHAR(1);
L_PA_LC               VARCHAR2(2);
L_PA_LC_VERSION       VARCHAR2(20);
L_PA_SS               VARCHAR2(2);
L_PA_ALLOW_MODIFY     CHAR(1);
L_PA_ACTIVE           CHAR(1);
L_PA_LOG_HS           CHAR(1);
L_PA_LOG_HS_DETAILS   CHAR(1);
L_TR_OK               BOOLEAN;
L_MT_VERSION          VARCHAR2(20);
L_PR_VERSION          VARCHAR2(20);
L_LOCK_ME             VARCHAR2(20);

CURSOR L_COS_CURSOR(A_LC VARCHAR2, A_LC_VERSION VARCHAR2, 
                    A_SS_FROM VARCHAR2, A_SS_TO VARCHAR2, A_UP NUMBER, A_USER VARCHAR2) IS
   SELECT SS_FROM, TR_NO
   FROM  UTLCUS
   WHERE LC  = A_LC
     AND VERSION = A_LC_VERSION
     AND SS_FROM IN (A_SS_FROM, '@@')
     AND SS_TO   = A_SS_TO
     AND US IN (A_USER, '~ANY~',  'UP'||TO_CHAR(A_UP))
   ORDER BY SS_FROM DESC, TR_NO;

CURSOR L_TR_CURSOR(A_LC VARCHAR2, A_LC_VERSION VARCHAR2, A_SS_FROM VARCHAR2, A_SS_TO VARCHAR2) IS
   SELECT SS_FROM, TR_NO
   FROM  UTLCTR
   WHERE LC  = A_LC
     AND VERSION = A_LC_VERSION
     AND SS_FROM IN (A_SS_FROM, '@@')
     AND SS_TO   = A_SS_TO
   ORDER BY SS_FROM DESC, TR_NO;

CURSOR L_TRDYN_CURSOR(A_LC VARCHAR2, A_LC_VERSION VARCHAR2, A_SS_FROM VARCHAR2, A_SS_TO VARCHAR2) IS
   SELECT *
   FROM  UTLCUS
   WHERE LC  = A_LC
     AND VERSION = A_LC_VERSION
     AND SS_FROM IN (A_SS_FROM, '@@')
     AND SS_TO   = A_SS_TO
     AND US = '~DYNAMIC~'
   ORDER BY SS_FROM DESC, TR_NO;

BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_MENODE, 0) = 0 OR 
      A_REANALYSIS IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   SELECT ME
   INTO L_LOCK_ME
   FROM UTSCME
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE
   FOR UPDATE;

   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                                               A_REANALYSIS, L_MT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                               L_OLD_ALLOW_MODIFY, L_OLD_ACTIVE, A_LOG_HS, 
                                               A_LOG_HS_DETAILS);
                                               
   UNAPIGEN.LOGERROR('UnapiMep.SCMETRANSITIONAUTHORISED','SCMEAUT-1: '||A_SC||' ME: '||A_ME||' na UNAPIAUT.GETSCMEAUTHORISATION ret_code: '||l_ret_code);
                                               
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      IF L_RET_CODE <> UNAPIGEN.DBERR_NOTMODIFIABLE THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      ELSE
         L_RET_CODE := UNAPIAUT.GETSCPAAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, L_PR_VERSION, 
                                                     L_PA_LC, L_PA_LC_VERSION, L_PA_SS,
                                                     L_PA_ALLOW_MODIFY, L_PA_ACTIVE, L_PA_LOG_HS, 
                                                     L_PA_LOG_HS_DETAILS);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END IF;
   END IF;
   
   L_SS := NVL(L_SS, '@~');

   IF A_LC IS NULL THEN
      
      IF L_LC IS NULL THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OBJECTLCMATCH;
         RAISE STPERROR;
      END IF;
      IF L_LC_VERSION IS NULL THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OBJECTLCVERSIONMATCH;
         RAISE STPERROR;
      END IF;
      A_LC := L_LC;
      A_LC_VERSION := L_LC_VERSION;
   ELSE
      
      IF A_LC <> NVL(L_LC, '####') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OBJECTLCMATCH;
         RAISE STPERROR;
      END IF;

      
      
      IF L_LC_VERSION IS NULL THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OBJECTLCVERSIONMATCH;
         RAISE STPERROR;
      END IF;
      A_LC_VERSION := L_LC_VERSION;
   END IF;

   IF NVL(A_OLD_SS, ' ') = ' ' THEN
      
      A_OLD_SS := L_SS;
   ELSE
      
      IF A_OLD_SS <> L_SS THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OBJECTSSMATCH;
         RAISE STPERROR;
      END IF;
   END IF;

   BEGIN
      SELECT ALLOW_MODIFY, ACTIVE
      INTO A_ALLOW_MODIFY, A_ACTIVE
      FROM UTSS
      WHERE SS = A_NEW_SS;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOSS;
      RAISE STPERROR;
   END;

   
   
   
   L_TR_OK := FALSE;
   OPEN L_COS_CURSOR (L_LC, L_LC_VERSION, L_SS, A_NEW_SS, UNAPIGEN.P_CURRENT_UP, NVL(A_AUTHORISED_BY, UNAPIGEN.P_USER))  ;
   FETCH L_COS_CURSOR INTO  A_LC_SS_FROM, A_TR_NO;

   IF L_COS_CURSOR%FOUND THEN
      L_TR_OK := TRUE;
   ELSE
      
      
      OPEN L_TR_CURSOR (L_LC, L_LC_VERSION, L_SS, A_NEW_SS);
      FETCH L_TR_CURSOR INTO  A_LC_SS_FROM, A_TR_NO;
      IF L_TR_CURSOR%NOTFOUND THEN
         UNAPIAUT.P_NOT_AUTHORISED := 'Transition lc(ss_from => ss_to)='||L_LC||'('||NVL(L_SS,'NULL')||' OR @@ => '||A_NEW_SS||') does not exist';
         L_TR_OK := FALSE;
      ELSE
      
         
         
         IF NVL(A_AUTHORISED_BY, UNAPIGEN.P_USER) = UNAPIGEN.P_DBA_NAME THEN
            L_TR_OK := TRUE;
         ELSE
            
            
            
            
            
            
            
            OPEN L_TRDYN_CURSOR (L_LC, L_LC_VERSION, L_SS, A_NEW_SS);
            LOOP
               FETCH L_TRDYN_CURSOR INTO  UNAPIAUT.P_LCTRUS_REC;
               IF L_TRDYN_CURSOR%NOTFOUND THEN
                  UNAPIAUT.P_NOT_AUTHORISED := 'Transition lc(ss_from => ss_to)='||L_LC||'('||NVL(L_SS,'NULL')||' OR @@ => '||A_NEW_SS||' not authorised for user:';
                  L_TR_OK := FALSE;
                  EXIT;
               ELSE
                  UNAPIAUT.P_OBJECT_TP      := 'me';
                  UNAPIAUT.P_OBJECT_ID      := A_ME;
                  UNAPIAUT.P_OBJECT_VERSION := NULL;
                  UNAPIAUT.P_LC             := L_LC;
                  UNAPIAUT.P_SS_FROM        := L_SS;
                  UNAPIAUT.P_LC_SS_FROM     := UNAPIAUT.P_LCTRUS_REC.SS_FROM;
                  UNAPIAUT.P_SS_TO          := A_NEW_SS;
                  UNAPIAUT.P_TR_NO          := UNAPIAUT.P_LCTRUS_REC.TR_NO;
                  UNAPIAUT.P_RQ             := NULL;
                  UNAPIAUT.P_CH             := NULL;
                  UNAPIAUT.P_SD             := NULL;
                  UNAPIAUT.P_SC             := A_SC;
                  UNAPIAUT.P_WS             := NULL;
                  UNAPIAUT.P_PG             := A_PG;    UNAPIAUT.P_PGNODE := A_PGNODE;
                  UNAPIAUT.P_PA             := A_PA;    UNAPIAUT.P_PANODE := A_PANODE;
                  UNAPIAUT.P_ME             := A_ME;    UNAPIAUT.P_MENODE := A_MENODE;
                  UNAPIAUT.P_IC             := NULL;    UNAPIAUT.P_ICNODE := NULL;
                  UNAPIAUT.P_II             := NULL;    UNAPIAUT.P_IINODE := NULL;
                  UNAPIAUT.P_PP_KEY1        := NULL;                  
                  UNAPIAUT.P_PP_KEY2        := NULL;                  
                  UNAPIAUT.P_PP_KEY3        := NULL;                  
                  UNAPIAUT.P_PP_KEY4        := NULL;                  
                  UNAPIAUT.P_PP_KEY5        := NULL;                  
                  UNAPIAUT.P_LAB            := NULL;
                  A_LC_SS_FROM := UNAPIAUT.P_LCTRUS_REC.SS_FROM;
                  A_TR_NO := UNAPIAUT.P_LCTRUS_REC.TR_NO;
                  L_TR_OK := UNACCESS.TRANSITIONAUTHORISED;
                  IF L_TR_OK THEN
                     UNAPIAUT.P_NOT_AUTHORISED := NULL;
                     EXIT;
                  ELSE
                     
                     
                     
                     UNAPIAUT.P_NOT_AUTHORISED := 'Dynamic user authorisation evaluation returned False Transition lc(ss_from => ss_to)='||L_LC||'('||NVL(L_SS,'NULL')||' OR @@ => '||A_NEW_SS||' not authorised for user:';
                  END IF;
               END IF;
            END LOOP;
            CLOSE L_TRDYN_CURSOR;
         END IF;
      END IF;
      CLOSE L_TR_CURSOR;
   END IF;
   CLOSE L_COS_CURSOR;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NOT L_TR_OK THEN
      RETURN(UNAPIGEN.DBERR_NOTAUTHORISED);
   ELSE
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ScMeTransitionAuthorised', SQLERRM);
   END IF;
   IF L_COS_CURSOR%ISOPEN THEN
      CLOSE L_COS_CURSOR;
   END IF;
   IF L_TR_CURSOR%ISOPEN THEN
      CLOSE L_TR_CURSOR;
   END IF;
   IF L_TRDYN_CURSOR%ISOPEN THEN
      CLOSE L_TRDYN_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ScMeTransitionAuthorised'));
END SCMETRANSITIONAUTHORISED;

FUNCTION CHANGESCMESTATUS
(A_SC                IN      VARCHAR2,     
 A_PG                IN      VARCHAR2,     
 A_PGNODE            IN      NUMBER,       
 A_PA                IN      VARCHAR2,     
 A_PANODE            IN      NUMBER,       
 A_ME                IN      VARCHAR2,     
 A_MENODE            IN      NUMBER,       
 A_REANALYSIS        IN      NUMBER,       
 A_OLD_SS            IN      VARCHAR2,     
 A_NEW_SS            IN      VARCHAR2,     
 A_LC                IN      VARCHAR2,     
 A_LC_VERSION        IN      VARCHAR2,     
 A_MODIFY_REASON     IN      VARCHAR2)     
RETURN NUMBER IS

L_LC                    VARCHAR2(2);
L_LC_VERSION            VARCHAR2(20);
L_OLD_SS                VARCHAR2(2);
L_ALLOW_MODIFY          CHAR(1);
L_ACTIVE                CHAR(1);
L_LOG_HS                CHAR(1);
L_LOG_HS_DETAILS        CHAR(1);
L_LC_SS_FROM            VARCHAR2(2);
L_TR_NO                 NUMBER(3);
L_HS_DETAILS_SEQ_NR     INTEGER;
L_OBJECT_ID             VARCHAR2(255);
L_MT_VERSION            VARCHAR2(20);

CURSOR L_VERSION_CURSOR IS
   SELECT MT_VERSION 
   FROM UTSCME
   WHERE SC     = A_SC
     AND PG     = A_PG
     AND PGNODE = A_PGNODE
     AND PA     = A_PA
     AND PANODE = A_PANODE
     AND ME     = A_ME
     AND MENODE = A_MENODE;
  
BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   L_LC := A_LC;
   L_LC_VERSION := A_LC_VERSION;
   L_OLD_SS := A_OLD_SS; 
   L_RET_CODE := UNAPIMEP.SCMETRANSITIONAUTHORISED
                    (A_SC, A_PG, A_PGNODE, A_PA,
                     A_PANODE, A_ME, A_MENODE, A_REANALYSIS,
                     L_LC, L_LC_VERSION, L_OLD_SS, A_NEW_SS,
                     UNAPIGEN.P_USER,
                     L_LC_SS_FROM, L_TR_NO, 
                     L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
                     
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
      L_RET_CODE <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      UPDATE UTSCME
      SET SS = A_NEW_SS,
          ALLOW_MODIFY = '#',
          ACTIVE = L_ACTIVE
      WHERE SC = A_SC
        AND PG = A_PG
        AND PGNODE = A_PGNODE
        AND PA = A_PA
        AND PANODE = A_PANODE
        AND ME = A_ME
        AND MENODE = A_MENODE;

      IF SQL%ROWCOUNT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
         RAISE STPERROR;
      END IF;

      OPEN L_VERSION_CURSOR;
      FETCH L_VERSION_CURSOR INTO L_MT_VERSION;
      IF L_VERSION_CURSOR%NOTFOUND THEN
         CLOSE L_VERSION_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MTVERSION;
         RAISE STPERROR;
      END IF;
      CLOSE L_VERSION_CURSOR;

      L_EVENT_TP := 'MeStatusChanged';
      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'sc=' || A_SC ||
                      '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                      '#menode=' || A_MENODE || 
                      '#tr_no=' || L_TR_NO ||
                      '#ss_from=' || L_OLD_SS ||
                      '#lc_ss_from='|| L_LC_SS_FROM ||
                      '#mt_version=' || L_MT_VERSION;
                      
      L_RESULT := UNAPIEV.INSERTEVENT('ChangeScMeStatus', UNAPIGEN.P_EVMGR_NAME, 'me',
                                      A_ME, L_LC, L_LC_VERSION, A_NEW_SS, L_EVENT_TP,
                                      L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
   
      IF L_LOG_HS = '1' THEN
         INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                              WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'status of method "'||A_ME||'" is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_NEW_SS)||'" ['||A_NEW_SS||'].', 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;

      L_HS_DETAILS_SEQ_NR := 0;
      IF L_LOG_HS_DETAILS = '1' THEN
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'status of method "'||A_ME||'" is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_NEW_SS)||'" ['||A_NEW_SS||'].');
      END IF;
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   L_OBJECT_ID :=  A_SC || A_PG || TO_CHAR(A_PGNODE) || A_PA || TO_CHAR(A_PANODE) ||
                   A_ME || TO_CHAR(A_MENODE);
   UNAPIAUT.UPDATEAUTHORISATIONBUFFER('me', L_OBJECT_ID, NULL, A_NEW_SS);

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ChangeScMeStatus', SQLERRM);
   END IF;
   IF L_VERSION_CURSOR%ISOPEN THEN
      CLOSE L_VERSION_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ChangeScMeStatus'));
END CHANGESCMESTATUS;

FUNCTION INTERNALCHANGESCMESTATUS          
(A_SC                IN      VARCHAR2,     
 A_PG                IN      VARCHAR2,     
 A_PGNODE            IN      NUMBER,       
 A_PA                IN      VARCHAR2,     
 A_PANODE            IN      NUMBER,       
 A_ME                IN      VARCHAR2,     
 A_MENODE            IN      NUMBER,       
 A_REANALYSIS        IN      NUMBER,       
 A_NEW_SS            IN      VARCHAR2,     
 A_MODIFY_REASON     IN      VARCHAR2)     
RETURN NUMBER IS

L_RET_CODE                    INTEGER;

L_OLD_SS                      VARCHAR2(2);
L_LC                          VARCHAR2(2);
L_LC_VERSION                  VARCHAR2(20);


L_SEQ_NR                      NUMBER;
L_OBJECT_ID                   VARCHAR2(255);
L_MT_VERSION                  VARCHAR2(20);


L_TMP_RETRIESWHENINTRANSITION  INTEGER;
L_TMP_INTERVALWHENINTRANSITION NUMBER;
L_TMP_REMOTE_MODE              INTEGER;

BEGIN 

   L_TMP_REMOTE_MODE := UNAPIGEN.P_REMOTE;
   UNAPIGEN.P_REMOTE := '1'; 
   
   L_OLD_SS := NULL;
   L_LC := NULL;
   L_LC_VERSION := NULL;
   L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      A_PGNODE IS NULL OR
      NVL(A_PA, ' ') = ' ' OR
      A_PANODE IS NULL OR
      NVL(A_ME, ' ') = ' ' OR
      A_MENODE IS NULL OR
      A_REANALYSIS IS NULL OR
      NVL(A_NEW_SS, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIPRP.CHECKELECSIGNATURE(A_NEW_SS);
   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN

      
      L_TMP_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
      L_TMP_INTERVALWHENINTRANSITION := UNAPIEV.P_INTERVALWHENINTRANSITION;
      UNAPIEV.P_RETRIESWHENINTRANSITION  := 1;
      UNAPIEV.P_INTERVALWHENINTRANSITION := 0.2;   

      
      
      IF A_NEW_SS <> '@C' THEN
         L_RET_CODE := UNAPIMEP.CHANGESCMESTATUS (A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_REANALYSIS,
                                                  L_OLD_SS, A_NEW_SS, L_LC, L_LC_VERSION, A_MODIFY_REASON);

      ELSIF A_NEW_SS = '@C' THEN
         L_RET_CODE := UNAPIMEP.CANCELSCME (A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_REANALYSIS, A_MODIFY_REASON);      
      END IF;
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS; 
         
         L_SEQ_NR := NULL;
         BEGIN 
            SELECT MT_VERSION
            INTO L_MT_VERSION
            FROM UTSCME
            WHERE SC = A_SC
            AND PG = A_PG
            AND PGNODE = A_PGNODE
            AND PA = A_PA
            AND PANODE = A_PANODE
            AND ME = A_ME
            AND MENODE = A_MENODE;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            L_MT_VERSION := NULL;
         END;

         L_RET_CODE := UNAPIEV.INSERTEVENT
                         (A_API_NAME          => 'InternalChangeScMeStatus',
                          A_EVMGR_NAME        => UNAPIGEN.P_EVMGR_NAME,
                          A_OBJECT_TP         => 'me',
                          A_OBJECT_ID         => A_ME,
                          A_OBJECT_LC         => NULL,
                          A_OBJECT_LC_VERSION => NULL,
                          A_OBJECT_SS         => NULL,
                          A_EV_TP             => 'MethodUpdated',
                          A_EV_DETAILS        => 'sc=' || A_SC || 
                                                 '#pg=' || A_PG ||
                                                 '#pgnode=' || TO_CHAR(A_PGNODE) ||
                                                 '#pa=' || A_PA ||
                                                 '#panode=' || TO_CHAR(A_PANODE) ||
                                                 '#menode=' || TO_CHAR(A_MENODE) ||
                                                 '#mt_version='||L_MT_VERSION||
                                                 '#ss_to='||A_NEW_SS,
                          A_SEQ_NR            => L_SEQ_NR);
      END IF;

      
      UNAPIEV.P_RETRIESWHENINTRANSITION  := L_TMP_RETRIESWHENINTRANSITION;
      UNAPIEV.P_INTERVALWHENINTRANSITION := L_TMP_INTERVALWHENINTRANSITION;      
   ELSE
         L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF;   

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   L_OBJECT_ID :=  A_SC || A_PG || TO_CHAR(A_PGNODE) || A_PA || TO_CHAR(A_PANODE) ||
                   A_ME || TO_CHAR(A_MENODE);
   UNAPIAUT.UPDATEAUTHORISATIONBUFFER('me', L_OBJECT_ID, NULL, A_NEW_SS);

   UNAPIGEN.P_REMOTE := L_TMP_REMOTE_MODE;
   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   
   UNAPIGEN.P_REMOTE := L_TMP_REMOTE_MODE;
   IF L_TMP_RETRIESWHENINTRANSITION IS NOT NULL THEN
      UNAPIEV.P_RETRIESWHENINTRANSITION  := L_TMP_RETRIESWHENINTRANSITION;
      UNAPIEV.P_INTERVALWHENINTRANSITION := L_TMP_INTERVALWHENINTRANSITION;   
   END IF;
   IF SQLCODE <> 1 THEN 
      UNAPIGEN.LOGERROR('InternalChangeScMeStatus', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('InternalChangeScMeStatus', L_SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'InternalChangeScMeStatus'));
END INTERNALCHANGESCMESTATUS;

FUNCTION CANCELSCME
(A_SC                IN      VARCHAR2,     
 A_PG                IN      VARCHAR2,     
 A_PGNODE            IN      NUMBER,       
 A_PA                IN      VARCHAR2,     
 A_PANODE            IN      NUMBER,       
 A_ME                IN      VARCHAR2,     
 A_MENODE            IN      NUMBER,       
 A_REANALYSIS        IN      NUMBER,       
 A_MODIFY_REASON     IN      VARCHAR2)     
RETURN NUMBER IS

L_LC                    VARCHAR2(2);
L_LC_VERSION            VARCHAR2(20);
L_OLD_SS                VARCHAR2(2);
L_NEW_SS                VARCHAR2(2);
L_ALLOW_MODIFY          CHAR(1);
L_ACTIVE                CHAR(1);
L_LOG_HS                CHAR(1);
L_LOG_HS_DETAILS        CHAR(1);
L_LC_SS_FROM            VARCHAR2(2);
L_TR_NO                 NUMBER(3);
L_HS_DETAILS_SEQ_NR     INTEGER;
L_REANALYSIS            NUMBER(3);
L_MT_VERSION            VARCHAR2(20);
L_EXEC_START_DATE       TIMESTAMP WITH TIME ZONE;
L_EXEC_END_DATE         TIMESTAMP WITH TIME ZONE;
L_EXEC_START_DATE_TZ    TIMESTAMP WITH TIME ZONE;
L_EXEC_END_DATE_TZ      TIMESTAMP WITH TIME ZONE;
L_ME_SS                 VARCHAR2(2);
L_PA_SS                 VARCHAR2(2);
L_ME_REANALYSIS         NUMBER(3);
L_OBJECT_ID             VARCHAR2(255);
L_CURRENT_TIMESTAMP               VARCHAR2(40);



CURSOR L_SCMECELLOUTPUT_CURSOR(A_SC IN VARCHAR2,
                               A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                               A_PA IN VARCHAR2, A_PANODE IN NUMBER,
                               A_ME IN VARCHAR2, A_MENODE IN NUMBER) IS
   SELECT SAVE_TP, SAVE_PG PG, SAVE_PGNODE PGNODE,
                   SAVE_PA PA, SAVE_PANODE PANODE,
                   SAVE_ME ME, SAVE_MENODE MENODE,
                   SAVE_REANALYSIS REANALYSIS
   FROM UTSCMECELLOUTPUT
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE
   AND SAVE_TP IN ('pr', 'mt')
   UNION ALL
   SELECT SAVE_TP, SAVE_PG PG, SAVE_PGNODE PGNODE,
                   SAVE_PA PA, SAVE_PANODE PANODE,
                   SAVE_ME ME, SAVE_MENODE MENODE,
                   SAVE_REANALYSIS REANALYSIS
   FROM UTSCMECELLLISTOUTPUT
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE
   AND SAVE_TP IN ('pr', 'mt')
   ORDER BY 1 DESC, 2 ASC, 4 ASC, 6 ASC;

CURSOR L_VERSION_CURSOR IS
   SELECT MT_VERSION 
   FROM UTSCME
   WHERE SC     = A_SC
     AND PG     = A_PG
     AND PGNODE = A_PGNODE
     AND PA     = A_PA
     AND PANODE = A_PANODE
     AND ME     = A_ME
     AND MENODE = A_MENODE;

BEGIN
   --A_SC||','||A_PG||'-'||PGNODE||','||A_PGNODE||','||A_PA||'-'||A_PANODE||','||A_ME||'-'||A_MENODE
   UNAPIGEN.LOGERRORNOREMOTEAPICALL('Unapimep.CancelScMe','SCME-1: '||A_SC||','||A_PG||'-'||A_PGNODE||','||A_PGNODE||','||A_PA||'-'||A_PANODE||','||A_ME||'-'||A_MENODE||' start');

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   L_HS_DETAILS_SEQ_NR := 0;
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   L_LC := NULL;
   L_LC_VERSION := NULL;
   L_OLD_SS := NULL; 
   L_NEW_SS := '@C';
   L_RET_CODE := UNAPIMEP.SCMETRANSITIONAUTHORISED
                    (A_SC, A_PG, A_PGNODE, A_PA,
                     A_PANODE, A_ME, A_MENODE, A_REANALYSIS,
                     L_LC, L_LC_VERSION, L_OLD_SS, L_NEW_SS,
                     UNAPIGEN.P_USER,
                     L_LC_SS_FROM, L_TR_NO, 
                     L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);

   UNAPIGEN.LOGERRORNOREMOTEAPICALL('Unapimep.CancelScMe','SCME-2: '||A_SC||' ME: '||A_ME||' na UNAPIMEP.SCMETRANSITIONAUTHORISED result: '||l_ret_code);

                     
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
      L_RET_CODE <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      
      
      
      
      UPDATE UTSCME
      SET SS = L_NEW_SS,
          ALLOW_MODIFY = '#',
          ACTIVE = L_ACTIVE,
          EXEC_START_DATE = NVL(EXEC_START_DATE, L_CURRENT_TIMESTAMP),
          EXEC_START_DATE_TZ = NVL(EXEC_START_DATE, L_CURRENT_TIMESTAMP),
          EXEC_END_DATE = NVL(EXEC_END_DATE, L_CURRENT_TIMESTAMP),
          EXEC_END_DATE_TZ = NVL(EXEC_END_DATE, L_CURRENT_TIMESTAMP),
     DELAY = 0
      WHERE SC = A_SC
        AND PG = A_PG
        AND PGNODE = A_PGNODE
        AND PA = A_PA
        AND PANODE = A_PANODE
        AND ME = A_ME
        AND MENODE = A_MENODE
      RETURNING REANALYSIS, EXEC_START_DATE, EXEC_START_DATE_TZ, EXEC_END_DATE, EXEC_END_DATE_TZ
      INTO L_REANALYSIS, L_EXEC_START_DATE, L_EXEC_START_DATE_TZ, L_EXEC_END_DATE, L_EXEC_END_DATE_TZ;

   
      IF SQL%ROWCOUNT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
         RAISE STPERROR;
      END IF;

      UNAPIGEN.LOGERRORNOREMOTEAPICALL('Unapimep.CancelScMe','SCME-3: '||A_SC||' ME: '||A_ME||' na UPDATE UTSCME allow-modify=#');
      
      IF L_REANALYSIS <> A_REANALYSIS THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTCURRENTMETHOD;
         RAISE STPERROR;         
      END IF;
      
      
      
      DELETE FROM UTDELAY
      WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE
      AND OBJECT_TP = 'me';

      DELETE FROM UTEVTIMED
      WHERE OBJECT_TP = 'me'
        AND OBJECT_ID = A_ME
        AND INSTR(EV_DETAILS, 'sc=' || A_SC) <> 0
        AND INSTR(EV_DETAILS, 'pg=' || A_PG) <> 0
        AND INSTR(EV_DETAILS, 'pgnode=' ||
                  TO_CHAR(A_PGNODE)) <> 0
        AND INSTR(EV_DETAILS, 'pa=' || A_PA) <> 0
        AND INSTR(EV_DETAILS, 'panode=' ||
                  TO_CHAR(A_PANODE)) <> 0
        AND INSTR(EV_DETAILS, 'menode=' ||
                  TO_CHAR(A_MENODE)) <> 0
        AND EV_TP = 'MeActivate';

   
      
      
      
      L_RET_CODE := UNAPIME2.UPDATELINKEDSCMECELL(A_SC => A_SC,
                                                  A_PG => A_PG,
                                                  A_PGNODE => A_PGNODE,
                                                  A_PA => A_PA,
                                                  A_PANODE => A_PANODE,
                                                  A_ME => A_ME,
                                                  A_MENODE => A_MENODE,
                                                  A_ME_STD_PROPERTY => 'exec_end_date',
                                                  A_MT_VERSION => NULL,
                                                  A_DESCRIPTION => NULL,
                                                  A_UNIT => NULL,
                                                  A_EXEC_START_DATE => NULL,
                                                  A_EXEC_END_DATE => L_EXEC_END_DATE,
                                                  A_EXECUTOR => NULL,
                                                  A_LAB => NULL,
                                                  A_EQ => NULL,
                                                  A_EQ_VERSION => NULL,
                                                  A_PLANNED_EXECUTOR => NULL,
                                                  A_PLANNED_EQ => NULL,
                                                  A_PLANNED_EQ_VERSION => NULL,
                                                  A_DELAY => NULL,
                                                  A_DELAY_UNIT => NULL,
                                                  A_FORMAT => NULL,
                                                  A_ACCURACY => NULL,
                                                  A_REAL_COST => NULL,
                                                  A_REAL_TIME => NULL,
                                                  A_SOP => NULL,
                                                  A_SOP_VERSION => NULL,
                                                  A_PLAUS_LOW => NULL,
                                                  A_PLAUS_HIGH => NULL,
                                                  A_ME_CLASS => NULL);              
                                                  
      UNAPIGEN.LOGERRORNOREMOTEAPICALL('Unapimep.CancelScMe','SCME-4: '||A_SC||' ME: '||A_ME||' na UNAPIMEP2.UPDATELINKEDSCMECELL exec-end-date RET_CODE: '||L_RET_CODE);
                                                                                      
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         L_SQLERRM := 'sc=' || A_SC || 
                      '#pg=' || A_PG ||
                      '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#pa=' || A_PA ||
                      '#panode=' || TO_CHAR(A_PANODE) ||
                      '#me=' || A_ME ||
                      '#menode=' || TO_CHAR(A_MENODE) ||
                      '#UpdateLinkedScMeCell#ErrorCode=' || TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;                           

      L_RET_CODE := UNAPIME2.UPDATELINKEDSCMECELL(A_SC => A_SC,
                                                  A_PG => A_PG,
                                                  A_PGNODE => A_PGNODE,
                                                  A_PA => A_PA,
                                                  A_PANODE => A_PANODE,
                                                  A_ME => A_ME,
                                                  A_MENODE => A_MENODE,
                                                  A_ME_STD_PROPERTY => 'exec_start_date',
                                                  A_MT_VERSION => NULL,
                                                  A_DESCRIPTION => NULL,
                                                  A_UNIT => NULL,
                                                  A_EXEC_START_DATE => L_EXEC_START_DATE,
                                                  A_EXEC_END_DATE => NULL,
                                                  A_EXECUTOR => NULL,
                                                  A_LAB => NULL,
                                                  A_EQ => NULL,
                                                  A_EQ_VERSION => NULL,
                                                  A_PLANNED_EXECUTOR => NULL,
                                                  A_PLANNED_EQ => NULL,
                                                  A_PLANNED_EQ_VERSION => NULL,
                                                  A_DELAY => NULL,
                                                  A_DELAY_UNIT => NULL,
                                                  A_FORMAT => NULL,
                                                  A_ACCURACY => NULL,
                                                  A_REAL_COST => NULL,
                                                  A_REAL_TIME => NULL,
                                                  A_SOP => NULL,
                                                  A_SOP_VERSION => NULL,
                                                  A_PLAUS_LOW => NULL,
                                                  A_PLAUS_HIGH => NULL,
                                                  A_ME_CLASS => NULL);
                                                  
      UNAPIGEN.LOGERRORNOREMOTEAPICALL('Unapimep.CancelScMe','SCME-5: '||A_SC||' ME: '||A_ME||' na UNAPIME2.UPDATELINKEDSCMECELL exec-start-date RET_CODE: '||L_RET_CODE);

                                                  
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         L_SQLERRM := 'sc=' || A_SC || 
                      '#pg=' || A_PG ||
                      '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#pa=' || A_PA ||
                      '#panode=' || TO_CHAR(A_PANODE) ||
                      '#me=' || A_ME ||
                      '#menode=' || TO_CHAR(A_MENODE) ||
                      '#UpdateLinkedScMeCell#ErrorCode=' || TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;                           

      
      
      
      
      L_RESULT := UNAPIMEP2.CLEARWHEREUSEDINMEDETAILS('me', A_SC, A_PG, A_PGNODE, A_PA, A_PANODE,
                                                      A_ME, A_MENODE, A_REANALYSIS, A_REANALYSIS, A_MODIFY_REASON);

      UNAPIGEN.LOGERRORNOREMOTEAPICALL('Unapimep.CancelScMe','SCME-6: '||A_SC||' ME: '||A_ME||' na UNAPIMEP2.CLEARWHEREUSEDINMEDETAILS result: '||l_result);

                                                      
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;          

      
      
      
         
      FOR L_SCMECELL_REC IN L_SCMECELLOUTPUT_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE) LOOP
         IF L_SCMECELL_REC.SAVE_TP = 'pr' AND 
            L_SCMECELL_REC.PANODE IS NOT NULL THEN
               
               SELECT SS
               INTO L_PA_SS
               FROM UTSCPA
               WHERE SC = A_SC
               AND PG = L_SCMECELL_REC.PG
               AND PGNODE = L_SCMECELL_REC.PGNODE
               AND PA = L_SCMECELL_REC.PA
               AND PANODE = L_SCMECELL_REC.PANODE;

               IF L_PA_SS <> '@C' THEN
                  L_RESULT := UNAPIPAP.CANCELSCPA(A_SC, L_SCMECELL_REC.PG, L_SCMECELL_REC.PGNODE, 
                                                  L_SCMECELL_REC.PA, L_SCMECELL_REC.PANODE,
                                                  A_MODIFY_REASON);
               ELSE
                  L_RESULT := UNAPIGEN.DBERR_SUCCESS;
               END IF;

            IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS AND 
               L_RESULT <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
               UNAPIGEN.P_TXN_ERROR := L_RESULT;
               RAISE STPERROR;
            END IF;
         ELSIF L_SCMECELL_REC.SAVE_TP = 'mt' AND
            L_SCMECELL_REC.MENODE IS NOT NULL THEN
            IF L_SCMECELL_REC.PG = A_PG AND
               L_SCMECELL_REC.PGNODE = A_PGNODE AND
               L_SCMECELL_REC.PA = A_PA AND
               L_SCMECELL_REC.PANODE = A_PANODE AND
               L_SCMECELL_REC.ME = A_ME AND
               L_SCMECELL_REC.MENODE = A_MENODE THEN
               
               
               L_RESULT := UNAPIGEN.DBERR_SUCCESS;
            ELSE  
               
               SELECT SS, REANALYSIS
               INTO L_ME_SS, L_ME_REANALYSIS
               FROM UTSCME
               WHERE SC = A_SC
               AND PG = L_SCMECELL_REC.PG
               AND PGNODE = L_SCMECELL_REC.PGNODE
               AND PA = L_SCMECELL_REC.PA
               AND PANODE = L_SCMECELL_REC.PANODE
               AND ME = L_SCMECELL_REC.ME
               AND MENODE = L_SCMECELL_REC.MENODE;
               
               
               IF L_ME_SS <> '@C' THEN 
                  L_RESULT := UNAPIMEP.CANCELSCME(A_SC, L_SCMECELL_REC.PG, L_SCMECELL_REC.PGNODE, 
                                                  L_SCMECELL_REC.PA, L_SCMECELL_REC.PANODE,
                                                  L_SCMECELL_REC.ME, L_SCMECELL_REC.MENODE, 
                                                  L_ME_REANALYSIS, A_MODIFY_REASON);
                ELSE
                   L_RESULT := UNAPIGEN.DBERR_SUCCESS;
                END IF;
            END IF;
            IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS AND 
               L_RESULT <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
               UNAPIGEN.P_TXN_ERROR := L_RESULT;
               RAISE STPERROR;
            END IF;
         END IF;
      END LOOP;

      OPEN L_VERSION_CURSOR;
      FETCH L_VERSION_CURSOR INTO L_MT_VERSION;
      IF L_VERSION_CURSOR%NOTFOUND THEN
         CLOSE L_VERSION_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MTVERSION;
         RAISE STPERROR;
      END IF;
      CLOSE L_VERSION_CURSOR;

      L_EVENT_TP := 'MeCanceled';
      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'sc=' || A_SC ||
                      '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                      '#menode=' || A_MENODE || 
                      '#tr_no=' || L_TR_NO ||
                      '#ss_from=' || L_OLD_SS ||
                      '#lc_ss_from='|| L_LC_SS_FROM ||
                      '#mt_version=' || L_MT_VERSION;
      L_RESULT := UNAPIEV.INSERTEVENT('CancelScMe', UNAPIGEN.P_EVMGR_NAME, 'me',
                                      A_ME, L_LC, L_LC_VERSION, L_NEW_SS, L_EVENT_TP,
                                      L_EV_DETAILS, L_EV_SEQ_NR);
                                      
      UNAPIGEN.LOGERRORNOREMOTEAPICALL('Unapimep.CancelScMe','SCME-7: '||A_SC||' ME: '||A_ME||' na UNAPIEV.INSERTEVENT (CancelScMe) result: '||l_result);
                                      
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
   
      IF L_LOG_HS = '1' THEN
         INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                              WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'method "'||A_ME||'" canceled, status is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'||UNAPIGEN.SQLSSNAME(L_NEW_SS)||'" ['||L_NEW_SS||'].', 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
                
         UNAPIGEN.LOGERRORNOREMOTEAPICALL('Unapimep.CancelScMe','SCME-7b: '||A_SC||' ME: '||A_ME||' na insert UTSCMEHS' );
                
      END IF;

      IF L_LOG_HS_DETAILS = '1' THEN
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'method "'||A_ME||'" canceled, status is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'||UNAPIGEN.SQLSSNAME(L_NEW_SS)||'" ['||L_NEW_SS||'].');
                
         UNAPIGEN.LOGERRORNOREMOTEAPICALL('Unapimep.CancelScMe','SCME-7c: '||A_SC||' ME: '||A_ME||' na insert UTSCMEHSDETAILS' );
      END IF;

      
      
      
      IF L_LOG_HS_DETAILS = '1' THEN
         
         IF L_EXEC_START_DATE = L_CURRENT_TIMESTAMP THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                        EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                   UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                   'method "'||A_ME||'" is updated: property <exec_start_date_tz> changed value from "" to "' || L_EXEC_START_DATE_TZ || '".');
         END IF;

         
         IF L_EXEC_END_DATE = L_CURRENT_TIMESTAMP THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                        EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                   UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                   'method "'||A_ME||'" is updated: property <exec_end_date_tz> changed value from "" to "' || L_EXEC_END_DATE_TZ || '".');
         END IF;
      END IF;
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   L_OBJECT_ID :=  A_SC || A_PG || TO_CHAR(A_PGNODE) || A_PA || TO_CHAR(A_PANODE) ||
                   A_ME || TO_CHAR(A_MENODE);
   UNAPIAUT.UPDATEAUTHORISATIONBUFFER('me', L_OBJECT_ID, NULL, '@C');

   UNAPIGEN.LOGERRORNOREMOTEAPICALL('Unapimep.CancelScMe','SCME-6 KLAAR: '||A_SC||' ME: '||A_ME||' object-id: '||L_OBJECT_ID||' na UNAPIAUT.UPDATEAUTHORISATIONBUFFER @C, voor return L_RET_CODE: '||L_RET_CODE);

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CancelScMe', SQLERRM);
   END IF;
   IF L_VERSION_CURSOR%ISOPEN THEN
      CLOSE L_VERSION_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CancelScMe'));
END CANCELSCME;

FUNCTION CHANGESCMELIFECYCLE
(A_SC                IN      VARCHAR2,     
 A_PG                IN      VARCHAR2,     
 A_PGNODE            IN      NUMBER,       
 A_PA                IN      VARCHAR2,     
 A_PANODE            IN      NUMBER,       
 A_ME                IN      VARCHAR2,     
 A_MENODE            IN      NUMBER,       
 A_REANALYSIS        IN      NUMBER,       
 A_OLD_LC            IN      VARCHAR2,     
 A_OLD_LC_VERSION    IN      VARCHAR2,     
 A_NEW_LC            IN      VARCHAR2,     
 A_NEW_LC_VERSION    IN      VARCHAR2,     
 A_MODIFY_REASON     IN      VARCHAR2)     
RETURN NUMBER IS

L_COUNT_US            NUMBER;
L_COUNT_LC            NUMBER;
L_ALLOW_MODIFY        CHAR(1);
L_LOG_HS              CHAR(1);
L_LOG_HS_DETAILS      CHAR(1);
L_LC                  VARCHAR2(2);
L_LC_VERSION          VARCHAR2(20);
L_SS                  VARCHAR2(2);
L_ACTIVE              CHAR(1);
L_OBJECT_ID           VARCHAR2(255);
L_PA_ALLOW_MODIFY     CHAR(1);
L_PA_LOG_HS           CHAR(1);
L_PA_LOG_HS_DETAILS   CHAR(1);
L_PA_LC               VARCHAR2(2);
L_PA_LC_VERSION       VARCHAR2(20);
L_PA_SS               VARCHAR2(2);
L_PA_ACTIVE           CHAR(1);
L_HS_DETAILS_SEQ_NR   INTEGER;
L_MT_VERSION          VARCHAR2(20);
L_PR_VERSION          VARCHAR2(20);
L_LOCK_ME             VARCHAR2(20);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_PG, ' ') = ' ' OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_MENODE, 0) = 0 OR
      A_REANALYSIS IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   SELECT ME
   INTO L_LOCK_ME
   FROM UTSCME
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE
   FOR UPDATE;

   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                                               A_REANALYSIS, L_MT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                               L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      IF L_RET_CODE <> UNAPIGEN.DBERR_NOTMODIFIABLE THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      ELSE
         L_RET_CODE := UNAPIAUT.GETSCPAAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, L_PR_VERSION,
                                                     L_PA_LC, L_PA_LC_VERSION, L_PA_SS,
                                                     L_PA_ALLOW_MODIFY, L_PA_ACTIVE, L_PA_LOG_HS, 
                                                     L_PA_LOG_HS_DETAILS);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END IF;
   END IF;
   
   L_SS := NVL(L_SS, '@~');

   IF NVL(A_OLD_LC, ' ') = ' ' THEN
      
      NULL;
   ELSE
      IF A_OLD_LC <> L_LC THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OBJECTLCMATCH;
         RAISE STPERROR;
      END IF;

      
      
   END IF;

   SELECT COUNT(*)
   INTO L_COUNT_LC
   FROM UTLC
   WHERE VERSION = UNVERSION.P_NO_VERSION    
     AND LC = A_NEW_LC;

   IF L_COUNT_LC = 0  THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOLC;
      RAISE STPERROR;
   END IF;

   IF (NVL(L_LC, ' ') <> ' ') AND (NVL(L_LC_VERSION, ' ') <> ' ') THEN
      SELECT COUNT(*)
      INTO L_COUNT_US
      FROM UTLCUS
      WHERE LC = L_LC
        AND VERSION = L_LC_VERSION
        AND SS_FROM = L_SS
        AND US IN (UNAPIGEN.P_USER, '~ANY~', 'UP'||TO_CHAR(UNAPIGEN.P_CURRENT_UP));
        
      IF L_COUNT_US = 0  THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTAUTHORISED;
         RAISE STPERROR;
      END IF;
   END IF;

   UPDATE UTSCME
   SET LC = A_NEW_LC,
       LC_VERSION = UNVERSION.P_NO_VERSION,    
       ALLOW_MODIFY = '#',
       SS = ''
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE
     AND ME = A_ME
     AND MENODE = A_MENODE;

   IF SQL%ROWCOUNT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
      RAISE STPERROR;
   END IF;

   L_EVENT_TP := 'MeLifeCycleChanged';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'sc=' || A_SC ||
                   '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                   '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                   '#menode=' || TO_CHAR(A_MENODE) ||
                   '#from_lc=' || L_LC || 
                   '#from_lc_version=' || L_LC_VERSION || 
                   '#ss_from=' || L_SS ||
                   '#mt_version=' || L_MT_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('ChangeScMeLifeCycle', UNAPIGEN.P_EVMGR_NAME, 'me', A_ME, A_NEW_LC, 
                                   UNVERSION.P_NO_VERSION, '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);    
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' OR A_MODIFY_REASON IS NOT NULL THEN
      INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                           WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_USER,
             UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
             'life cycle of method "'||A_ME||'" is changed from "'||UNAPIGEN.SQLLCNAME(L_LC)||'" ['||L_LC||'] to "'||UNAPIGEN.SQLLCNAME(A_NEW_LC)||'" ['||A_NEW_LC||'].', 
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_DETAILS_SEQ_NR := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
             UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
             'life cycle of method "'||A_ME||'" is changed from "'||UNAPIGEN.SQLLCNAME(L_LC)||'" ['||L_LC||'] to "'||UNAPIGEN.SQLLCNAME(A_NEW_LC)||'" ['||A_NEW_LC||'].');
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;














   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ChangeScMeLifeCycle',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ChangeScMeLifeCycle'));
END CHANGESCMELIFECYCLE;

FUNCTION SELECTSCMEGKVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_GK               IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS
L_COL_OPERATOR           UNAPIGEN.VC20_TABLE_TYPE;
L_COL_ANDOR              UNAPIGEN.VC3_TABLE_TYPE;
BEGIN
FOR L_X IN 1..A_COL_NR_OF_ROWS LOOP
    L_COL_OPERATOR(L_X) := '=';
    L_COL_ANDOR(L_X) := 'AND';
END LOOP;
 RETURN(UNAPIMEP.SELECTSCMEGKVALUES(A_COL_ID,
                                 A_COL_TP,
                                 A_COL_VALUE,
                                 L_COL_OPERATOR,
                                 L_COL_ANDOR,
                                 A_COL_NR_OF_ROWS,
                                 A_GK,
                                 A_VALUE,
                                 A_NR_OF_ROWS,
                                 A_ORDER_BY_CLAUSE,
                                 A_NEXT_ROWS));
END SELECTSCMEGKVALUES;

FUNCTION SELECTSCMEGKVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_OPERATOR     IN      UNAPIGEN.VC20_TABLE_TYPE,  
 A_COL_ANDOR        IN      UNAPIGEN.VC3_TABLE_TYPE,   
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_GK               IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS

L_VALUE                          VARCHAR2(40);
L_ORDER_BY_CLAUSE                VARCHAR2(255);
L_FROM_CLAUSE                    VARCHAR2(500);
L_NEXT_ME_JOIN                   VARCHAR2(4);
L_NEXT_MEGK_JOIN                 VARCHAR2(4);
L_NEXT_SCGK_JOIN                 VARCHAR2(4);
L_COLUMN_HANDLED                 BOOLEAN_TABLE_TYPE;
L_ANYOR_PRESENT                  BOOLEAN;
L_COL_ANDOR                      VARCHAR2(3);
L_PREV_COL_TP                    VARCHAR2(40);
L_PREV_COL_ID                    VARCHAR2(40);
L_PREV_COL_INDEX                 INTEGER;
L_WHERE_CLAUSE4JOIN              VARCHAR2(2000);
L_LENGTH                         INTEGER;
L_SQL_VAL_TAB                    VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_NEXT_ROWS, 0) NOT IN (-1, 0, 1) THEN
      RETURN(UNAPIGEN.DBERR_NEXTROWS);
   END IF;

   
   IF A_NEXT_ROWS = -1 THEN
      IF P_SELECTMEGK_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_SELECTMEGK_CURSOR);
         P_SELECTMEGK_CURSOR := NULL;
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_SELECTMEGK_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;
   
   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN

      
      L_SQL_STRING := 'SELECT DISTINCT b.' || A_GK ||' FROM ';
      L_FROM_CLAUSE := 'dd' || UNAPIGEN.P_DD || '.uvscme a, utscmegk' || A_GK || ' b';

      
      L_WHERE_CLAUSE4JOIN := 'a.sc = b.sc' || 
                        ' AND a.pg = b.pg AND a.pgnode = b.pgnode' ||
                        ' AND a.pa = b.pa AND a.panode = b.panode' ||
                        ' AND a.me = b.me AND a.menode = b.menode AND ';
      L_WHERE_CLAUSE := '';
      L_ANYOR_PRESENT := FALSE;
      FOR I IN 1..A_COL_NR_OF_ROWS LOOP
         L_COLUMN_HANDLED(I) := FALSE;
         IF LTRIM(RTRIM(UPPER(A_COL_ANDOR(I)))) = 'OR' AND
            NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
            L_ANYOR_PRESENT := TRUE;
         END IF;
         
         
         IF I<>1 THEN
            IF NVL(A_COL_TP(I), ' ') = NVL(A_COL_TP(I-1), ' ') AND
               NVL(A_COL_ID(I), ' ') = NVL(A_COL_ID(I-1), ' ') AND
               NVL(A_COL_OPERATOR(I), '=') = '=' AND
               NVL(A_COL_OPERATOR(I-1), '=') = '=' AND
               NVL(A_COL_ANDOR(I-1), 'AND') =  'AND' AND
               (NVL(A_COL_VALUE(I), ' ') <> ' ' OR NVL(A_COL_VALUE(I-1), ' ') <> ' ') THEN
               IF I> 2 AND A_COL_ANDOR(I-2) = 'OR' THEN
                  L_ANYOR_PRESENT := TRUE;
               END IF;
            END IF;
         END IF;         
      END LOOP;
      
      
      
      L_NEXT_MEGK_JOIN := 'a';
      L_NEXT_SCGK_JOIN := 'a';
      L_NEXT_ME_JOIN := 'a';
   
      FOR I IN REVERSE 1..A_COL_NR_OF_ROWS LOOP
         IF NVL(LTRIM(A_COL_ID(I)), ' ') = ' ' THEN
            RETURN(UNAPIGEN.DBERR_SELCOLSINVALID);
         END IF;
   
         
         L_COL_ANDOR := 'AND';
         IF I<>1 THEN
            L_COL_ANDOR := A_COL_ANDOR(I-1);
         END IF;
         IF L_COL_ANDOR IS NULL THEN
            
            L_COL_ANDOR := 'AND';
         END IF;

         IF L_COLUMN_HANDLED(I) = FALSE THEN
            
            IF NVL(A_COL_TP(I), ' ') = 'megk' THEN
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utscme', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => 'utscmegk', A_JOINCOLUMN1 => 'me', A_JOINCOLUMN2 => '', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_MEGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            
            ELSIF NVL(A_COL_TP(I), ' ') = 'scgk' THEN
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => 'utscgk', A_JOINCOLUMN1 => 'sc', A_JOINCOLUMN2 => '', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_SCGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSE
               
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utscme', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_ME_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            END IF;
         END IF;
      END LOOP;
   
      
      IF SUBSTR(L_WHERE_CLAUSE4JOIN, -4) = 'AND ' THEN
         L_WHERE_CLAUSE4JOIN := SUBSTR(L_WHERE_CLAUSE4JOIN, 1,
                                  LENGTH(L_WHERE_CLAUSE4JOIN)-4);
      END IF;
      
      
      IF SUBSTR(L_WHERE_CLAUSE, -4) = 'AND ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-4);
      END IF;
      IF UPPER(SUBSTR(L_WHERE_CLAUSE, -4)) = ' OR ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-3);
      END IF;
      
      IF L_WHERE_CLAUSE4JOIN IS NOT NULL THEN
         IF L_WHERE_CLAUSE IS NULL THEN
            L_WHERE_CLAUSE := ' WHERE ' || L_WHERE_CLAUSE4JOIN;
         ELSE
            L_WHERE_CLAUSE := ' WHERE (' || L_WHERE_CLAUSE4JOIN || ') AND ('||L_WHERE_CLAUSE||') ';
         END IF;
      ELSE
         IF L_WHERE_CLAUSE IS NOT NULL THEN
            L_WHERE_CLAUSE := ' WHERE '||L_WHERE_CLAUSE;
         ELSE
            L_WHERE_CLAUSE := ' ';
         END IF;
      END IF;

      L_ORDER_BY_CLAUSE := NVL(A_ORDER_BY_CLAUSE, ' ORDER BY 1');

      L_SQL_STRING := L_SQL_STRING || L_FROM_CLAUSE || L_WHERE_CLAUSE || L_ORDER_BY_CLAUSE;

      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            
                   
      IF P_SELECTMEGK_CURSOR IS NULL THEN
         P_SELECTMEGK_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;
   
      UNAPIAUT.ADDORACLECBOHINT (L_SQL_STRING) ;
      DBMS_SQL.PARSE(P_SELECTMEGK_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      FOR L_X IN 1..L_SQL_VAL_TAB.COUNT() LOOP
         DBMS_SQL.BIND_VARIABLE(P_SELECTMEGK_CURSOR, ':col_val'||L_X , L_SQL_VAL_TAB(L_X)); 
      END LOOP;   
   
      DBMS_SQL.DEFINE_COLUMN(P_SELECTMEGK_CURSOR, 1, L_VALUE, 40);
   
      L_RESULT := DBMS_SQL.EXECUTE(P_SELECTMEGK_CURSOR);
      
   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTMEGK_CURSOR);
   L_FETCHED_ROWS := 0;
   
   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(P_SELECTMEGK_CURSOR, 1, L_VALUE);
   
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
   
      A_VALUE(L_FETCHED_ROWS) := L_VALUE;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTMEGK_CURSOR);
      END IF;
   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
       DBMS_SQL.CLOSE_CURSOR(P_SELECTMEGK_CURSOR);
       P_SELECTMEGK_CURSOR := NULL;
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_SELECTMEGK_CURSOR);
      P_SELECTMEGK_CURSOR := NULL;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
              'SelectScMeGkValues', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'SelectScMeGkValues', '(SQL)'||SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));             
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQLERRM) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQLERRM, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_SELECTMEGK_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_SELECTMEGK_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END SELECTSCMEGKVALUES;

FUNCTION SELECTSCMEPROPVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_PROP             IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS
L_COL_OPERATOR           UNAPIGEN.VC20_TABLE_TYPE;
L_COL_ANDOR              UNAPIGEN.VC3_TABLE_TYPE;
BEGIN
FOR L_X IN 1..A_COL_NR_OF_ROWS LOOP
    L_COL_OPERATOR(L_X) := '=';
    L_COL_ANDOR(L_X) := 'AND';
END LOOP;
 RETURN(UNAPIMEP.SELECTSCMEPROPVALUES(A_COL_ID,
                                 A_COL_TP,
                                 A_COL_VALUE,
                                 L_COL_OPERATOR,
                                 L_COL_ANDOR,
                                 A_COL_NR_OF_ROWS,
                                 A_PROP,
                                 A_VALUE,
                                 A_NR_OF_ROWS,
                                 A_ORDER_BY_CLAUSE,
                                 A_NEXT_ROWS));
END SELECTSCMEPROPVALUES;

FUNCTION SELECTSCMEPROPVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_OPERATOR     IN      UNAPIGEN.VC20_TABLE_TYPE,  
 A_COL_ANDOR        IN      UNAPIGEN.VC3_TABLE_TYPE,   
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_PROP             IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS

L_VALUE                          VARCHAR2(40);
L_MEGK_CURSOR                    INTEGER;
L_ORDER_BY_CLAUSE                VARCHAR2(255);
L_FROM_CLAUSE                    VARCHAR2(500);
L_NEXT_SCGK_JOIN                 VARCHAR2(4);
L_NEXT_MEGK_JOIN                 VARCHAR2(4);
L_NEXT_ME_JOIN                   VARCHAR2(4);
L_COLUMN_HANDLED                 BOOLEAN_TABLE_TYPE;
L_ANYOR_PRESENT                  BOOLEAN;
L_COL_ANDOR                      VARCHAR2(3);
L_PREV_COL_TP                    VARCHAR2(40);
L_PREV_COL_ID                    VARCHAR2(40);
L_PREV_COL_INDEX                 INTEGER;
L_WHERE_CLAUSE4JOIN              VARCHAR2(2000);
L_LENGTH                         INTEGER;
L_SQL_VAL_TAB                    VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_NEXT_ROWS, 0) NOT IN (-1, 0, 1) THEN
      RETURN(UNAPIGEN.DBERR_NEXTROWS);
   END IF;

   
   IF A_NEXT_ROWS = -1 THEN
      IF P_SELECTMEPROP_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_SELECTMEPROP_CURSOR);
         P_SELECTMEPROP_CURSOR := NULL;
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_SELECTMEPROP_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN

      L_SQL_STRING := 'SELECT DISTINCT a.' || A_PROP ||' FROM ';
      L_FROM_CLAUSE := 'dd' || UNAPIGEN.P_DD || '.uvscme a';

      
      L_WHERE_CLAUSE4JOIN := '';
      L_WHERE_CLAUSE := '';
      L_ANYOR_PRESENT := FALSE;
      FOR I IN 1..A_COL_NR_OF_ROWS LOOP
         L_COLUMN_HANDLED(I) := FALSE;
         IF LTRIM(RTRIM(UPPER(A_COL_ANDOR(I)))) = 'OR' AND
            NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
            L_ANYOR_PRESENT := TRUE;
         END IF;
         
         
         IF I<>1 THEN
            IF NVL(A_COL_TP(I), ' ') = NVL(A_COL_TP(I-1), ' ') AND
               NVL(A_COL_ID(I), ' ') = NVL(A_COL_ID(I-1), ' ') AND
               NVL(A_COL_OPERATOR(I), '=') = '=' AND
               NVL(A_COL_OPERATOR(I-1), '=') = '=' AND
               NVL(A_COL_ANDOR(I-1), 'AND') =  'AND' AND
               (NVL(A_COL_VALUE(I), ' ') <> ' ' OR NVL(A_COL_VALUE(I-1), ' ') <> ' ') THEN
               IF I> 2 AND A_COL_ANDOR(I-2) = 'OR' THEN
                  L_ANYOR_PRESENT := TRUE;
               END IF;
            END IF;
         END IF;         
      END LOOP;

      
      
      
      L_NEXT_ME_JOIN := 'a';      
      L_NEXT_MEGK_JOIN := 'a';      
      L_NEXT_SCGK_JOIN := 'a';      

      FOR I IN REVERSE 1..A_COL_NR_OF_ROWS LOOP
         IF NVL(LTRIM(A_COL_ID(I)), ' ') = ' ' THEN
           RETURN(UNAPIGEN.DBERR_SELCOLSINVALID);
         END IF;
         
         L_COL_ANDOR := 'AND';
         IF I<>1 THEN
            L_COL_ANDOR := A_COL_ANDOR(I-1);
         END IF;
         IF L_COL_ANDOR IS NULL THEN
            
            L_COL_ANDOR := 'AND';
         END IF;

         IF L_COLUMN_HANDLED(I) = FALSE THEN
            
            IF NVL(A_COL_TP(I), ' ') = 'megk' THEN
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utscme', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => 'utscmegk', A_JOINCOLUMN1 => 'me', A_JOINCOLUMN2 => '', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_MEGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            
            ELSIF NVL(A_COL_TP(I), ' ') = 'scgk' THEN
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsc', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => 'utscgk', A_JOINCOLUMN1 => 'sc', A_JOINCOLUMN2 => '', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_SCGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSE  
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utscme', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_ME_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            END IF;
         END IF;
      END LOOP;

      
      IF SUBSTR(L_WHERE_CLAUSE4JOIN, -4) = 'AND ' THEN
         L_WHERE_CLAUSE4JOIN := SUBSTR(L_WHERE_CLAUSE4JOIN, 1,
                                  LENGTH(L_WHERE_CLAUSE4JOIN)-4);
      END IF;
      
      
      IF SUBSTR(L_WHERE_CLAUSE, -4) = 'AND ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-4);
      END IF;
      IF UPPER(SUBSTR(L_WHERE_CLAUSE, -4)) = ' OR ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-3);
      END IF;
      
      IF L_WHERE_CLAUSE4JOIN IS NOT NULL THEN
         IF L_WHERE_CLAUSE IS NULL THEN
            L_WHERE_CLAUSE := ' WHERE ' || L_WHERE_CLAUSE4JOIN;
         ELSE
            L_WHERE_CLAUSE := ' WHERE (' || L_WHERE_CLAUSE4JOIN || ') AND ('||L_WHERE_CLAUSE||') ';
         END IF;
      ELSE
         IF L_WHERE_CLAUSE IS NOT NULL THEN
            L_WHERE_CLAUSE := ' WHERE '||L_WHERE_CLAUSE;
         ELSE
            L_WHERE_CLAUSE := ' ';
         END IF;
      END IF;

      L_ORDER_BY_CLAUSE := NVL(A_ORDER_BY_CLAUSE, ' ORDER BY 1');

      L_SQL_STRING := L_SQL_STRING || L_FROM_CLAUSE || L_WHERE_CLAUSE || L_ORDER_BY_CLAUSE;

      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            

      IF P_SELECTMEPROP_CURSOR IS NULL THEN
         P_SELECTMEPROP_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;

      UNAPIAUT.ADDORACLECBOHINT (L_SQL_STRING) ;
      DBMS_SQL.PARSE(P_SELECTMEPROP_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      FOR L_X IN 1..L_SQL_VAL_TAB.COUNT() LOOP
         DBMS_SQL.BIND_VARIABLE(P_SELECTMEPROP_CURSOR, ':col_val'||L_X , L_SQL_VAL_TAB(L_X)); 
      END LOOP;

      DBMS_SQL.DEFINE_COLUMN(P_SELECTMEPROP_CURSOR, 1, L_VALUE, 40);

      L_RESULT := DBMS_SQL.EXECUTE(P_SELECTMEPROP_CURSOR);

   END IF;
   
   L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTMEPROP_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(P_SELECTMEPROP_CURSOR, 1, L_VALUE);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_VALUE(L_FETCHED_ROWS) := L_VALUE;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTMEPROP_CURSOR);
      END IF;
   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
       DBMS_SQL.CLOSE_CURSOR(P_SELECTMEPROP_CURSOR);
       P_SELECTMEPROP_CURSOR := NULL;
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_SELECTMEPROP_CURSOR);
      P_SELECTMEPROP_CURSOR := NULL;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
              'SelectScMePropValues', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'SelectScMePropValues', '(SQL)'||SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));             
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQLERRM) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQLERRM, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_SELECTMEPROP_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_SELECTMEPROP_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END SELECTSCMEPROPVALUES;

FUNCTION REANALSCMEFROMDETAILS                      
(A_SC               IN        VARCHAR2,                 
 A_PG               IN        VARCHAR2,                 
 A_PGNODE           IN        NUMBER,                   
 A_PA               IN        VARCHAR2,                 
 A_PANODE           IN        NUMBER,                   
 A_ME               IN        VARCHAR2,                 
 A_MENODE           IN        NUMBER,                   
 A_REANALYSIS       IN OUT    NUMBER,                   
 A_MODIFY_REASON    IN        VARCHAR2)                 
RETURN NUMBER IS

L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_SS                     VARCHAR2(2);
L_LOG_HS                 CHAR(1);
L_LOG_HS_DETAILS         CHAR(1);
L_ALLOW_MODIFY           CHAR(1);
L_ACTIVE                 CHAR(1);
L_REANALYSIS             NUMBER(3);
L_RD_REANALYSIS          NUMBER(3);
L_HS_DETAILS_SEQ_NR      INTEGER;
L_MT_VERSION             VARCHAR2(20);
L_REAL_COST              VARCHAR2(40);
L_REAL_TIME              VARCHAR2(40);
L_OLD_VALUE_S            VARCHAR2(20);
L_NEW_VALUE_S            VARCHAR2(20);
L_IS_VALUE_S_UPDATED     BOOLEAN:= FALSE;
L_COUNT_EVENTS           INTEGER;
L_EV_DETAILS_LIKE        VARCHAR2(255);

CURSOR L_SCME_CURSOR IS
   SELECT REANALYSIS
   FROM UTSCME
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE
     AND ME = A_ME
     AND MENODE = A_MENODE;

CURSOR L_SCRD_CURSOR IS
   SELECT RD, RDNODE
   FROM UTSCRD
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE
     AND ME = A_ME
     AND MENODE = A_MENODE;

CURSOR L_SCMEOLD_CURSOR (A_SC IN VARCHAR2, 
                         A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                         A_PA IN VARCHAR2, A_PANODE IN NUMBER,
                         A_ME IN VARCHAR2, A_MENODE IN NUMBER) IS
   SELECT A.*
   FROM UDSCME A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE
     AND A.ME = A_ME
     AND A.MENODE = A_MENODE;
L_SCMEOLD_REC            UDSCME%ROWTYPE;
L_SCMENEW_REC            UDSCME%ROWTYPE;


CURSOR L_UTSCMEOLD_CURSOR (A_SC IN VARCHAR2, 
                           A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                           A_PA IN VARCHAR2, A_PANODE IN NUMBER,
                           A_ME IN VARCHAR2, A_MENODE IN NUMBER) IS
   SELECT A.*
   FROM UTSCME A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE
     AND A.ME = A_ME
     AND A.MENODE = A_MENODE;
L_UTSCMEOLD_REC           UTSCME%ROWTYPE;

CURSOR L_MT_CURSOR (C_MT VARCHAR2, C_MT_VERSION VARCHAR2) IS 
   SELECT EST_COST, EST_TIME
   FROM UTMT
   WHERE MT = C_MT
   AND VERSION = C_MT_VERSION;

BEGIN

   
   
   
   
   
   
   
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_MENODE, 0) = 0 OR
      A_REANALYSIS IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                                               A_REANALYSIS, L_MT_VERSION, L_LC, L_LC_VERSION, L_SS, 
                                               L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   OPEN L_SCME_CURSOR;
   FETCH L_SCME_CURSOR
   INTO L_REANALYSIS;
   IF L_SCME_CURSOR%NOTFOUND THEN
      CLOSE L_SCME_CURSOR;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;
   CLOSE L_SCME_CURSOR;

   
   
   L_EV_DETAILS_LIKE := 'sc=' || A_SC ||
                      '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                      '#menode=' || TO_CHAR(A_MENODE) ||'%';
   SELECT COUNT(*)
   INTO L_COUNT_EVENTS
   FROM UTEV
   WHERE TR_SEQ = UNAPIGEN.P_TR_SEQ
   
   AND DBAPI_NAME LIKE 'ReanalScMe%'
   AND OBJECT_TP ='me'
   AND OBJECT_ID = A_ME
   AND EV_DETAILS LIKE L_EV_DETAILS_LIKE;
   
   IF L_COUNT_EVENTS>0 THEN
      
      IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   IF A_REANALYSIS <> L_REANALYSIS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTCURRENTMETHOD;
      RAISE STPERROR;
   END IF;
   
   
   
   
   
   L_EVENT_TP := 'MethodUpdated';
   L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'sc=' || A_SC ||
                      '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                      '#menode=' || TO_CHAR(A_MENODE) ||
                      '#mt_version=' || L_MT_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('ReanalScMeFromDetails', UNAPIGEN.P_EVMGR_NAME, 'me', A_ME, '',
                                   '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   
   
   
   L_IS_VALUE_S_UPDATED := FALSE;
   
   OPEN L_UTSCMEOLD_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE);
   FETCH L_UTSCMEOLD_CURSOR
   INTO L_UTSCMEOLD_REC;
   CLOSE L_UTSCMEOLD_CURSOR;
      
   
   
   
   IF ( SUBSTR(L_UTSCMEOLD_REC.VALUE_S, -4)  IN ('#BLB', '@TXT', '#IMG', '#LNK', '#TXT', '#DOC' ) ) THEN

      L_OLD_VALUE_S := L_UTSCMEOLD_REC.VALUE_S ;
      L_NEW_VALUE_S := SUBSTR(L_OLD_VALUE_S, 0, LENGTH(L_OLD_VALUE_S) - 4 ) || '#R' || SUBSTR(L_OLD_VALUE_S, -4) ;

      IF ( SUBSTR(L_OLD_VALUE_S, -4)  = '#BLB') THEN
         UPDATE UTBLOB
         SET ID = L_NEW_VALUE_S
         WHERE ID = L_OLD_VALUE_S ;

         UPDATE UTBLOBHS
         SET ID = L_NEW_VALUE_S
         WHERE ID = L_OLD_VALUE_S ;
      ELSE 
         UPDATE UTLONGTEXT
         SET DOC_NAME = L_NEW_VALUE_S
         WHERE DOC_NAME = L_OLD_VALUE_S ;
      END IF ;

      L_UTSCMEOLD_REC.VALUE_S := L_NEW_VALUE_S ;
      L_IS_VALUE_S_UPDATED := TRUE;

   END IF ; 
   
   BEGIN
      INSERT INTO UTRSCME
      VALUES L_UTSCMEOLD_REC ;
   EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      
      
      IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
      RETURN(UNAPIGEN.DBERR_SUCCESS);      
   END;
      
      
   
   
   
   
   
   
   IF (P_COPY_EST_COST = 'YES') OR (P_COPY_EST_TIME = 'YES') THEN
      OPEN L_MT_CURSOR(A_ME, L_MT_VERSION);
      FETCH L_MT_CURSOR INTO L_REAL_COST, L_REAL_TIME;
      IF L_MT_CURSOR%NOTFOUND THEN
         CLOSE L_MT_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR;
      END IF;
      CLOSE L_MT_CURSOR;
   END IF;
   IF P_COPY_EST_COST <> 'YES' THEN
      L_REAL_COST := NULL;
   END IF;
   IF P_COPY_EST_TIME <> 'YES' THEN
      L_REAL_TIME := NULL;
   END IF;

   
   
   
   OPEN L_SCMEOLD_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE);
   FETCH L_SCMEOLD_CURSOR
   INTO L_SCMEOLD_REC;
   CLOSE L_SCMEOLD_CURSOR;
   
   IF (L_IS_VALUE_S_UPDATED = TRUE) THEN
      
      L_SCMEOLD_REC.VALUE_S := L_NEW_VALUE_S;
   END IF;
   
   L_SCMENEW_REC := L_SCMEOLD_REC;

   
   
   
   UPDATE UTSCME
      SET VALUE_F = NULL,
          VALUE_S = NULL,
          EXEC_START_DATE = NULL,
          EXEC_START_DATE_TZ = NULL,
          EXEC_END_DATE = NULL,
          EXEC_END_DATE_TZ = NULL,
          EXECUTOR = NULL,
          EQ = NULL,
          EQ_VERSION = NULL,
          MANUALLY_ENTERED = '0',
          REAL_COST = L_REAL_COST,
          REAL_TIME = L_REAL_TIME,
          REANALYSIS = REANALYSIS + 1
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE
   RETURNING VALUE_F, VALUE_S, EXEC_START_DATE, EXEC_START_DATE_TZ, EXEC_END_DATE, EXECUTOR, EQ, EQ_VERSION, 
             MANUALLY_ENTERED, REAL_COST, REAL_TIME, REANALYSIS
   INTO L_SCMENEW_REC.VALUE_F, L_SCMENEW_REC.VALUE_S, L_SCMENEW_REC.EXEC_START_DATE, 
        L_SCMENEW_REC.EXEC_END_DATE, L_SCMENEW_REC.EXEC_END_DATE_TZ, L_SCMENEW_REC.EXECUTOR, L_SCMENEW_REC.EQ, 
        L_SCMENEW_REC.EQ_VERSION, L_SCMENEW_REC.MANUALLY_ENTERED, L_SCMENEW_REC.REAL_COST, 
        L_SCMENEW_REC.REAL_TIME, L_SCMENEW_REC.REANALYSIS;
   A_REANALYSIS := L_SCMENEW_REC.REANALYSIS;
 
   UPDATE UTSCMECELL
   SET REANALYSIS = L_SCMENEW_REC.REANALYSIS
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;
   
   UPDATE UTSCMECELLLIST
   SET REANALYSIS = L_SCMENEW_REC.REANALYSIS
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;

   UPDATE UTSCMECELLINPUT
   SET REANALYSIS = L_SCMENEW_REC.REANALYSIS
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;

   UPDATE UTSCMECELLOUTPUT
   SET REANALYSIS = L_SCMENEW_REC.REANALYSIS
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;

   UPDATE UTSCMECELLLISTOUTPUT
   SET REANALYSIS = L_SCMENEW_REC.REANALYSIS
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;

   
   
   
   FOR L_SCRD IN L_SCRD_CURSOR LOOP

      INSERT INTO UTRSCRD
      SELECT *
      FROM UTSCRD
      WHERE SC = A_SC
        AND PG = A_PG
        AND PGNODE = A_PGNODE
        AND PA = A_PA
        AND PANODE = A_PANODE
        AND ME = A_ME
        AND MENODE = A_MENODE
        AND RD = L_SCRD.RD
        AND RDNODE = L_SCRD.RDNODE;
   
      
      
      
      UPDATE UTSCRD
         SET VALUE_F = NULL,
             VALUE_S = NULL,
             REANALYSIS = REANALYSIS + 1
      WHERE SC = A_SC
         AND PG = A_PG
         AND PGNODE = A_PGNODE
         AND PA = A_PA
         AND PANODE = A_PANODE
         AND ME = A_ME
         AND MENODE = A_MENODE
         AND RD = L_SCRD.RD
         AND RDNODE = L_SCRD.RDNODE;

   END LOOP;

   
   IF P_CLIENT_EVMGR_USED IS NULL THEN
      P_CLIENT_EVMGR_USED := 'NO';
      OPEN C_SYSTEM ('CLIENT_EVMGR_USED');
      FETCH C_SYSTEM INTO P_CLIENT_EVMGR_USED;
      CLOSE C_SYSTEM;   
   END IF;
   
   IF P_CLIENT_EVMGR_USED='YES' THEN
      
      
      
      
      
      UPDATE UTSCMECELL
      SET VALUE_F = NULL,
          VALUE_S = NULL
      WHERE SC = A_SC
        AND PG = A_PG
        AND PGNODE = A_PGNODE
        AND PA = A_PA
        AND PANODE = A_PANODE
        AND ME = A_ME
        AND MENODE = A_MENODE
        AND CELL_TP = 'K';

      
      L_EVENT_TP := 'EvaluateMeDetails';
      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'sc=' || A_SC ||
                      '#pg=' || A_PG ||
                      '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#pa=' || A_PA ||
                      '#panode=' || TO_CHAR(A_PANODE) ||
                      '#menode=' || TO_CHAR(A_MENODE) ||
                      '#mt_version=' || L_SCMENEW_REC.MT_VERSION ;

      L_RESULT := UNAPIEV.INSERTEVENT('ReanalScMeFromDetails',
                                      UNAPIGEN.P_EVMGR_NAME, 'me',
                                      A_ME, '','', '',
                                      L_EVENT_TP, L_EV_DETAILS,
                                      L_EV_SEQ_NR);

      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF; 
   END IF;
   
   
   L_EVENT_TP := 'MeReanalysis';

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, WHAT,
                           WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_USER,
             UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
             'method "'||A_ME||'" is implicitely reanalysed',
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_DETAILS_SEQ_NR := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ,
                                  SEQ, DETAILS)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, 
             L_HS_DETAILS_SEQ_NR, 'method "'||A_ME||'" is implicitely reanalysed');

      UNAPIHSDETAILS.ADDSCMEHSDETAILS(L_SCMEOLD_REC, L_SCMENEW_REC, UNAPIGEN.P_TR_SEQ, 
                                      L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR); 
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ReanalScMeFromDetails', SQLERRM);
   END IF;
   IF L_SCME_CURSOR%ISOPEN THEN
      CLOSE L_SCME_CURSOR;
   END IF;
   IF L_SCRD_CURSOR%ISOPEN THEN
      CLOSE L_SCRD_CURSOR;
   END IF;
   IF L_SCMEOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCMEOLD_CURSOR;
   END IF;
   IF C_SYSTEM%ISOPEN THEN
      CLOSE C_SYSTEM;
   END IF;   
   IF L_MT_CURSOR%ISOPEN THEN
      CLOSE L_MT_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ReanalScMeFromDetails'));
END REANALSCMEFROMDETAILS;

FUNCTION REANALSCPAFROMDETAILS                      
(A_SC               IN    VARCHAR2,                 
 A_PG               IN    VARCHAR2,                 
 A_PGNODE           IN    NUMBER,                   
 A_PA               IN    VARCHAR2,                 
 A_PANODE           IN    NUMBER,                   
 A_REANALYSIS       OUT   NUMBER,                   
 A_MODIFY_REASON    IN    VARCHAR2)                 
RETURN NUMBER IS

L_LC                            VARCHAR2(2);
L_LC_VERSION                    VARCHAR2(20);
L_SS                            VARCHAR2(2);
L_LOG_HS                        CHAR(1);
L_LOG_HS_DETAILS                CHAR(1);
L_ALLOW_MODIFY                  CHAR(1);
L_ACTIVE                        CHAR(1);
L_REANALYSIS                    NUMBER(3);
L_ME_REANALYSIS                 NUMBER(3);
L_HS_DETAILS_SEQ_NR             INTEGER;
L_OLD_VALID_SQC                 CHAR(1);
L_PR_VERSION                    VARCHAR2(20);
L_PREVIOUS_ALLOW_MODIFY_CHECK   CHAR(1);
L_PAOUTPUT_REANALYSIS           NUMBER(3);
L_OLD_REANALYSIS                NUMBER(3);
L_NEW_REANALYSIS                NUMBER(3);
L_OLD_VALUE_S                   VARCHAR2(20);
L_NEW_VALUE_S                   VARCHAR2(20);
L_IS_VALUE_S_UPDATED            BOOLEAN:=FALSE;
L_COUNT_EVENTS                  INTEGER;
L_EV_DETAILS_LIKE               VARCHAR2(255);

CURSOR L_SCPA_CURSOR IS
   SELECT REANALYSIS
   FROM UTSCPA
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE;

CURSOR L_SCME_MAX_CURSOR IS
   SELECT NVL(MAX(REANALYSIS),0)
   FROM UTSCME
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE;

CURSOR L_SCPAOLD_CURSOR (A_SC IN VARCHAR2, 
                         A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                         A_PA IN VARCHAR2, A_PANODE IN NUMBER) IS
   SELECT A.*
   FROM UDSCPA A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE;
L_SCPAOLD_REC           UDSCPA%ROWTYPE;
L_SCPANEW_REC           UDSCPA%ROWTYPE;


CURSOR L_UTSCPAOLD_CURSOR (A_SC IN VARCHAR2, 
                         A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                         A_PA IN VARCHAR2, A_PANODE IN NUMBER) IS
   SELECT A.*
   FROM UTSCPA A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE;
L_UTSCPAOLD_REC           UTSCPA%ROWTYPE;

CURSOR L_SCPASQCOLD_CURSOR (A_SC IN VARCHAR2, 
                            A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                            A_PA IN VARCHAR2, A_PANODE IN NUMBER) IS
   SELECT VALID_SQC
   FROM UTSCPASQC A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE;

CURSOR L_SCPAOUTPUT_CURSOR IS
   SELECT *
   FROM UTSCPAOUTPUT A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE;
L_SCPAOUTPUT_REC L_SCPAOUTPUT_CURSOR%ROWTYPE;
     

BEGIN

   
   
   
   
   
   
   
   
   
   
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_PANODE, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIAUT.GETSCPAAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, L_PR_VERSION, 
                                               L_LC, L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE,
                                               L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   OPEN L_SCPA_CURSOR;
   FETCH L_SCPA_CURSOR
   INTO L_OLD_REANALYSIS;
   IF L_SCPA_CURSOR%NOTFOUND THEN
      CLOSE L_SCPA_CURSOR;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;
   CLOSE L_SCPA_CURSOR;
   
   
   
   L_EV_DETAILS_LIKE := 'sc=' || A_SC ||
                      '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#panode=' || TO_CHAR(A_PANODE) ||'%';
   SELECT COUNT(*)
   INTO L_COUNT_EVENTS
   FROM UTEV
   WHERE TR_SEQ = UNAPIGEN.P_TR_SEQ
   
   AND DBAPI_NAME LIKE 'ReanalScPa%'
   AND OBJECT_TP ='pa'
   AND OBJECT_ID = A_PA
   AND EV_DETAILS LIKE L_EV_DETAILS_LIKE;

   IF L_COUNT_EVENTS>0 THEN
      
      IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   
   
   
   
   L_EVENT_TP := 'ParameterUpdated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'sc=' || A_SC || 
                   '#pg=' || A_PG ||'#pgnode=' || TO_CHAR(A_PGNODE) || 
                   '#panode=' || TO_CHAR(A_PANODE) ||
                   '#pr_version=' || L_PR_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('ReanalScPaFromDetails', UNAPIGEN.P_EVMGR_NAME, 'pa', A_PA, '',
                                   '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   
   
   
   FOR L_SCPAOUTPUT_REC IN L_SCPAOUTPUT_CURSOR LOOP
      
      
      
      L_RESULT := UNAPIAUT.GETALLOWMODIFYCHECKMODE(L_PREVIOUS_ALLOW_MODIFY_CHECK);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;

      IF L_PREVIOUS_ALLOW_MODIFY_CHECK = '0' THEN
         L_RESULT := UNAPIAUT.DISABLEALLOWMODIFYCHECK('1');
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
         END IF;
      END IF;

      
      
      
      L_RET_CODE := UNAPIAUT.DISABLEARCHECK('1');
      IF L_SCPAOUTPUT_REC.SC = A_SC AND
         L_SCPAOUTPUT_REC.SAVE_PG = A_PG AND
         L_SCPAOUTPUT_REC.SAVE_PGNODE= A_PGNODE AND
         L_SCPAOUTPUT_REC.SAVE_PA = A_PA AND
         L_SCPAOUTPUT_REC.SAVE_PANODE= A_PANODE THEN
         
         NULL;
      ELSE            
         L_RESULT := UNAPIPA2.REANALSCPARAMETER(
                                        L_SCPAOUTPUT_REC.SC, 
                                        L_SCPAOUTPUT_REC.SAVE_PG, 
                                        L_SCPAOUTPUT_REC.SAVE_PGNODE, 
                                        L_SCPAOUTPUT_REC.SAVE_PA, 
                                        L_SCPAOUTPUT_REC.SAVE_PANODE, 
                                        L_PAOUTPUT_REANALYSIS,
                                        A_MODIFY_REASON);
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS AND
            L_RESULT <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
         END IF;
      END IF;
      L_RET_CODE := UNAPIAUT.DISABLEARCHECK('0');

      
      
      
      L_RESULT := UNAPIAUT.DISABLEALLOWMODIFYCHECK(L_PREVIOUS_ALLOW_MODIFY_CHECK);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;

   END LOOP;

   
   
   
   OPEN L_SCME_MAX_CURSOR;
   FETCH L_SCME_MAX_CURSOR
   INTO L_ME_REANALYSIS;
   IF L_SCME_MAX_CURSOR%NOTFOUND THEN
      CLOSE L_SCME_MAX_CURSOR;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;
   CLOSE L_SCME_MAX_CURSOR;
      
   L_NEW_REANALYSIS := GREATEST(NVL(L_OLD_REANALYSIS,0)+1, NVL(L_ME_REANALYSIS,0));
   
   
   
   
   
   
   
   
   L_RESULT := UNAPIMEP2.CLEARWHEREUSEDINMEDETAILS('pa', A_SC, A_PG, A_PGNODE, A_PA, A_PANODE,
                                                      NULL, NULL, L_OLD_REANALYSIS, L_NEW_REANALYSIS, A_MODIFY_REASON);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   
   
   
   L_IS_VALUE_S_UPDATED := FALSE;
      
   OPEN L_UTSCPAOLD_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE);
   FETCH L_UTSCPAOLD_CURSOR
   INTO L_UTSCPAOLD_REC;
   CLOSE L_UTSCPAOLD_CURSOR;
      
   
   
   
   IF ( SUBSTR(L_UTSCPAOLD_REC.VALUE_S, -4)  IN ('#BLB', '@TXT', '#IMG', '#LNK', '#TXT', '#DOC' ) ) THEN

      L_OLD_VALUE_S := L_UTSCPAOLD_REC.VALUE_S ;
      L_NEW_VALUE_S := SUBSTR(L_OLD_VALUE_S, 0, LENGTH(L_OLD_VALUE_S) - 4 ) || '#R' || SUBSTR(L_OLD_VALUE_S, -4) ;

      IF ( SUBSTR(L_OLD_VALUE_S, -4)  = '#BLB') THEN
         UPDATE UTBLOB
         SET ID = L_NEW_VALUE_S
         WHERE ID = L_OLD_VALUE_S ;

         UPDATE UTBLOBHS
         SET ID = L_NEW_VALUE_S
         WHERE ID = L_OLD_VALUE_S ;
      ELSE 
         UPDATE UTLONGTEXT
         SET DOC_NAME = L_NEW_VALUE_S
         WHERE DOC_NAME = L_OLD_VALUE_S ;
      END IF ;

      L_UTSCPAOLD_REC.VALUE_S := L_NEW_VALUE_S ;
      L_IS_VALUE_S_UPDATED := TRUE;

   END IF ; 

   INSERT INTO UTRSCPA
   VALUES L_UTSCPAOLD_REC ;

   
   
   
   OPEN L_SCPAOLD_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE);
   FETCH L_SCPAOLD_CURSOR
   INTO L_SCPAOLD_REC;
   CLOSE L_SCPAOLD_CURSOR;

   IF (L_IS_VALUE_S_UPDATED = TRUE) THEN
      
      L_SCPAOLD_REC.VALUE_S := L_NEW_VALUE_S;
   END IF;

   L_SCPANEW_REC := L_SCPAOLD_REC;

   
   
   
   INSERT INTO UTRSCPASPA(SC, PG, PGNODE, PA, PANODE, REANALYSIS, 
      LOW_LIMIT, HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV, REL_LOW_DEV,
      TARGET, HIGH_DEV, REL_HIGH_DEV)
   SELECT SC, PG, PGNODE, PA, PANODE, L_OLD_REANALYSIS, LOW_LIMIT,
          HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV, REL_LOW_DEV,
          TARGET, HIGH_DEV, REL_HIGH_DEV
   FROM UTSCPASPA
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE;

   
   
   
   INSERT INTO UTRSCPASPB(SC, PG, PGNODE, PA, PANODE, REANALYSIS, 
      LOW_LIMIT, HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV, REL_LOW_DEV,
      TARGET, HIGH_DEV, REL_HIGH_DEV)
   SELECT SC, PG, PGNODE, PA, PANODE, L_OLD_REANALYSIS, LOW_LIMIT,
          HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV, REL_LOW_DEV,
          TARGET, HIGH_DEV, REL_HIGH_DEV
   FROM UTSCPASPB
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE;

   
   
   
   INSERT INTO UTRSCPASPC(SC, PG, PGNODE, PA, PANODE, REANALYSIS, 
      LOW_LIMIT, HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV, REL_LOW_DEV,
      TARGET, HIGH_DEV, REL_HIGH_DEV)
   SELECT SC, PG, PGNODE, PA, PANODE, L_OLD_REANALYSIS, LOW_LIMIT,
          HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV, REL_LOW_DEV,
          TARGET, HIGH_DEV, REL_HIGH_DEV
   FROM UTSCPASPC
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE;

   
   
   
   INSERT INTO UTRSCPASQC
   (SC, PG, PGNODE, PA, PANODE, REANALYSIS, SQC_AVG, SQC_SIGMA,
    SQC_AVGR, SQC_UCLR, VALID_SQC)
   SELECT SC, PG, PGNODE, PA, PANODE, L_OLD_REANALYSIS, SQC_AVG, SQC_SIGMA,
          SQC_AVGR, SQC_UCLR, VALID_SQC
   FROM UTSCPASQC
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE;

   
   
   
   OPEN L_SCPASQCOLD_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE);
   FETCH L_SCPASQCOLD_CURSOR
   INTO L_OLD_VALID_SQC;
   CLOSE L_SCPASQCOLD_CURSOR;

   
   
   
   UPDATE UTSCPASQC
   SET VALID_SQC = NULL
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE;
      
   
   
   
   DELETE FROM UTSCPATD
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE;

   
   
   
   DELETE FROM UTRESULTEXCEPTION
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE;
      
   
   
   
   
      
   
   
   
   UPDATE UTSCPA
      SET VALUE_F = NULL,
          VALUE_S = NULL,
          EXEC_START_DATE = NULL,
          EXEC_START_DATE_TZ = NULL,
          EXEC_END_DATE = NULL,
          EXEC_END_DATE_TZ = NULL,
          EXECUTOR = NULL,
          MANUALLY_ENTERED = '0',
          VALID_SPECSA = NULL,
          VALID_SPECSB = NULL,
          VALID_SPECSC = NULL,
          VALID_LIMITSA = NULL,
          VALID_LIMITSB = NULL,
          VALID_LIMITSC = NULL,
          VALID_TARGETA = NULL,
          VALID_TARGETB = NULL,
          VALID_TARGETC = NULL,
          REANALYSIS = L_NEW_REANALYSIS,
          PA_CLASS = '0'
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
   RETURNING VALUE_F, VALUE_S, EXEC_START_DATE, EXEC_START_DATE_TZ, EXEC_END_DATE, EXEC_END_DATE_TZ, EXECUTOR, MANUALLY_ENTERED, 
             VALID_SPECSA, VALID_SPECSB, VALID_SPECSC, VALID_LIMITSA, VALID_LIMITSB, 
             VALID_LIMITSC, VALID_TARGETA, VALID_TARGETB, VALID_TARGETC, REANALYSIS, PA_CLASS
   INTO L_SCPANEW_REC.VALUE_F, L_SCPANEW_REC.VALUE_S, L_SCPANEW_REC.EXEC_START_DATE,  L_SCPANEW_REC.EXEC_START_DATE_TZ,
        L_SCPANEW_REC.EXEC_END_DATE, L_SCPANEW_REC.EXEC_END_DATE_TZ, L_SCPANEW_REC.EXECUTOR, L_SCPANEW_REC.MANUALLY_ENTERED, 
        L_SCPANEW_REC.VALID_SPECSA, L_SCPANEW_REC.VALID_SPECSB, L_SCPANEW_REC.VALID_SPECSC, 
        L_SCPANEW_REC.VALID_LIMITSA, L_SCPANEW_REC.VALID_LIMITSB, L_SCPANEW_REC.VALID_LIMITSC, 
        L_SCPANEW_REC.VALID_TARGETA, L_SCPANEW_REC.VALID_TARGETB, L_SCPANEW_REC.VALID_TARGETC, 
        L_SCPANEW_REC.REANALYSIS, L_SCPANEW_REC.PA_CLASS;
   A_REANALYSIS := L_NEW_REANALYSIS;
   
   
   L_EVENT_TP := 'PaReanalysis';

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTSCPAHS(SC, PG, PGNODE, PA, PANODE, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
                           LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 
             L_EVENT_TP, 'parameter "'||A_PA||'" is implicitely reanalysed',
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_DETAILS_SEQ_NR := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTSCPAHSDETAILS(SC, PG, PGNODE, PA, PANODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
             'parameter "'||A_PA||'" is implicitely reanalysed');

      UNAPIHSDETAILS.ADDSCPAHSDETAILS(L_SCPAOLD_REC, L_SCPANEW_REC, UNAPIGEN.P_TR_SEQ, 
                                      L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR); 

      IF L_OLD_VALID_SQC IS NOT NULL THEN
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCPAHSDETAILS(SC, PG, PGNODE, PA, PANODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'parameter "'||A_PA||'" is updated: property <valid_sqc> changed value from "' || L_OLD_VALID_SQC|| '" to "".');
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ReanalScPaFromDetails', SQLERRM);
   END IF;
   IF L_SCPA_CURSOR%ISOPEN THEN
      CLOSE L_SCPA_CURSOR;
   END IF;
   IF L_SCME_MAX_CURSOR%ISOPEN THEN
      CLOSE L_SCME_MAX_CURSOR;
   END IF;
   IF L_SCPAOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCPAOLD_CURSOR;
   END IF;
   IF L_SCPASQCOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCPASQCOLD_CURSOR;
   END IF;
   L_RET_CODE := UNAPIAUT.DISABLEARCHECK('0');
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ReanalScPaFromDetails'));
END REANALSCPAFROMDETAILS;

FUNCTION REANALSCMETHOD
(A_SC             IN        VARCHAR2,                 
 A_PG             IN        VARCHAR2,                 
 A_PGNODE         IN        NUMBER,                   
 A_PA             IN        VARCHAR2,                 
 A_PANODE         IN        NUMBER,                   
 A_ME             IN        VARCHAR2,                 
 A_MENODE         IN        NUMBER,                   
 A_REANALYSIS     IN OUT    NUMBER,                   
 A_MODIFY_REASON  IN        VARCHAR2)                 
RETURN NUMBER IS

L_LC                    VARCHAR2(2);
L_LC_VERSION            VARCHAR2(20);
L_OLD_SS                VARCHAR2(2);
L_NEW_SS                VARCHAR2(2);
L_TR_NO                 NUMBER(3);
L_LOG_HS                CHAR(1);
L_LOG_HS_DETAILS        CHAR(1);
L_ALLOW_MODIFY          CHAR(1);
L_ACTIVE                CHAR(1);
L_REANALYSIS            NUMBER(3);
L_RD_REANALYSIS         NUMBER(3);
L_LC_SS_FROM            VARCHAR2(2);
L_REANALYSIS_OUT        NUMBER(3);
L_OBJECT_ID             VARCHAR2(255);
L_HS_DETAILS_SEQ_NR     INTEGER;
L_MT_VERSION            VARCHAR2(20);
L_REAL_COST             VARCHAR2(40);
L_REAL_TIME             VARCHAR2(40);
L_ME_SS                 VARCHAR2(2);
L_ME_REANALYSIS         NUMBER(3);
L_OLD_VALUE_S           VARCHAR2(20);
L_NEW_VALUE_S           VARCHAR2(20);
L_IS_VALUE_S_UPDATED    BOOLEAN:=FALSE;
L_COUNT_EVENTS          INTEGER;
L_EV_DETAILS_LIKE       VARCHAR2(255);


CURSOR L_SCME_CURSOR IS
   SELECT REANALYSIS, LC, LC_VERSION, MT_VERSION
   FROM UTSCME
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE
     AND ME = A_ME
     AND MENODE = A_MENODE;

CURSOR L_SCRD_CURSOR IS
   SELECT RD, RDNODE
   FROM UTSCRD
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE
     AND ME = A_ME
     AND MENODE = A_MENODE;

CURSOR L_LC_CURSOR(A_LC VARCHAR2, A_LC_VERSION VARCHAR2) IS
   SELECT NVL(SS_AFTER_REANALYSIS,'IE') SS_AFTER_REANALYSIS
   FROM UTLC
   WHERE LC = A_LC
     AND VERSION = A_LC_VERSION;



CURSOR L_SCMECELLOUTPUT_CURSOR(A_SC IN VARCHAR2,
                               A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                               A_PA IN VARCHAR2, A_PANODE IN NUMBER,
                               A_ME IN VARCHAR2, A_MENODE IN NUMBER) IS
   SELECT CELL, 0 INDEX_Y, SAVE_TP, SAVE_PG, SAVE_PGNODE,
                   SAVE_PA, SAVE_PANODE,
                   SAVE_ME, SAVE_MENODE,
                   SAVE_REANALYSIS, 'celloutput' OUTPUT_TP, '0' HASBEENMODIFIED
   FROM UTSCMECELLOUTPUT
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE
   AND SAVE_TP IN ('pr', 'mt')
   UNION ALL
   SELECT CELL, INDEX_Y, SAVE_TP, SAVE_PG, SAVE_PGNODE,
                   SAVE_PA, SAVE_PANODE,
                   SAVE_ME, SAVE_MENODE,
                   SAVE_REANALYSIS, 'celllistoutput' OUTPUT_TP, '0' HASBEENMODIFIED
   FROM UTSCMECELLLISTOUTPUT
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE
   AND SAVE_TP IN ('pr', 'mt')   
   ORDER BY 3 DESC, 4 ASC, 6 ASC, 7 ASC;
   
CURSOR L_CHECK_UTRSCPA_CURSOR (A_SC IN VARCHAR2,
                               A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                               A_PA IN VARCHAR2, A_PANODE IN NUMBER) IS              
   SELECT SC, PG, PGNODE, PA, PANODE, REANALYSIS
   FROM UTSCPA
   WHERE SC = A_SC 
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE
   INTERSECT
   SELECT SC, PG, PGNODE, PA, PANODE, REANALYSIS
   FROM UTRSCPA
   WHERE SC = A_SC 
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE;
L_CHECK_UTRSCPA_REC        L_CHECK_UTRSCPA_CURSOR%ROWTYPE;     
L_REANALYSIS_PERFORMED     BOOLEAN;

CURSOR L_SCPAREANALYSIS_CURSOR (A_SC VARCHAR2, A_PG VARCHAR2, A_PGNODE NUMBER,
                                A_PA VARCHAR2, A_PANODE NUMBER) IS
SELECT REANALYSIS
FROM UTSCPA
WHERE SC = A_SC
  AND PG = A_PG
  AND PGNODE = A_PGNODE
  AND PA = A_PA
  AND PANODE = A_PANODE;
L_SCPAREANALYSIS_REC L_SCPAREANALYSIS_CURSOR  %ROWTYPE;

CURSOR L_SCMEREANALYSIS_CURSOR (A_SC VARCHAR2, A_PG VARCHAR2, A_PGNODE NUMBER,
                                A_PA VARCHAR2, A_PANODE NUMBER,
                                A_ME VARCHAR2, A_MENODE NUMBER) IS
SELECT REANALYSIS
FROM UTSCME
WHERE SC = A_SC
  AND PG = A_PG
  AND PGNODE = A_PGNODE
  AND PA = A_PA
  AND PANODE = A_PANODE
  AND ME = A_ME
  AND MENODE = A_MENODE;
L_SCMEREANALYSIS_REC L_SCMEREANALYSIS_CURSOR  %ROWTYPE;

CURSOR L_SCMEOLD_CURSOR (A_SC IN VARCHAR2, 
                         A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                         A_PA IN VARCHAR2, A_PANODE IN NUMBER,
                         A_ME IN VARCHAR2, A_MENODE IN NUMBER) IS
   SELECT A.*
   FROM UDSCME A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE
     AND A.ME = A_ME
     AND A.MENODE = A_MENODE;
L_SCMEOLD_REC           UDSCME%ROWTYPE;
L_SCMENEW_REC           UDSCME%ROWTYPE;


CURSOR L_UTSCMEOLD_CURSOR (A_SC IN VARCHAR2, 
                           A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                           A_PA IN VARCHAR2, A_PANODE IN NUMBER,
                           A_ME IN VARCHAR2, A_MENODE IN NUMBER) IS
   SELECT A.*
   FROM UTSCME A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE
     AND A.ME = A_ME
     AND A.MENODE = A_MENODE;
L_UTSCMEOLD_REC           UTSCME%ROWTYPE;

CURSOR L_MT_CURSOR (C_MT VARCHAR2, C_MT_VERSION VARCHAR2) IS 
   SELECT EST_COST, EST_TIME
   FROM UTMT
   WHERE MT = C_MT
   AND VERSION = C_MT_VERSION;

   
   PROCEDURE COPYSCMECELLSINTOREANALTABLES IS
      L_CELL_OLD_VALUE_S           VARCHAR2(20);
      L_CELL_NEW_VALUE_S           VARCHAR2(20);

      
      CURSOR L_UTSCMECELLOLD_CURSOR (A_SC IN VARCHAR2, 
                           A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                           A_PA IN VARCHAR2, A_PANODE IN NUMBER,
                           A_ME IN VARCHAR2, A_MENODE IN NUMBER) IS
      SELECT A.*
      FROM UTSCMECELL A
      WHERE A.SC = A_SC
      AND A.PG = A_PG
      AND A.PGNODE = A_PGNODE
      AND A.PA = A_PA
      AND A.PANODE = A_PANODE
      AND A.ME = A_ME
      AND A.MENODE = A_MENODE;
      L_UTSCMECELLOLD_REC           UTSCMECELL%ROWTYPE;
		L_SCMECELL_FOUND              BOOLEAN DEFAULT FALSE;

    
   BEGIN
   
      
      
      
      OPEN L_UTSCMECELLOLD_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE);
      FETCH L_UTSCMECELLOLD_CURSOR
      INTO L_UTSCMECELLOLD_REC;

		IF L_UTSCMECELLOLD_CURSOR%FOUND THEN
			L_SCMECELL_FOUND := TRUE;
		END IF ;

      CLOSE L_UTSCMECELLOLD_CURSOR;
      
      
      
      
		IF L_SCMECELL_FOUND THEN 
         FOR L_UTSCMECELLOLD_REC IN L_UTSCMECELLOLD_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE) LOOP 
            IF ( SUBSTR(L_UTSCMECELLOLD_REC.VALUE_S, -4)  IN ('#BLB', '@TXT', '#IMG', '#LNK', '#TXT', '#DOC' ) ) THEN

               L_CELL_OLD_VALUE_S := L_UTSCMECELLOLD_REC.VALUE_S ;
               L_CELL_NEW_VALUE_S := SUBSTR(L_CELL_OLD_VALUE_S, 0, LENGTH(L_CELL_OLD_VALUE_S) - 4 ) || '#R' || SUBSTR(L_CELL_OLD_VALUE_S, -4) ;

               IF ( SUBSTR(L_CELL_OLD_VALUE_S, -4)  = '#BLB') THEN
                  UPDATE UTBLOB
                  SET ID = L_CELL_NEW_VALUE_S
                  WHERE ID = L_CELL_OLD_VALUE_S ;

                  UPDATE UTBLOBHS
                  SET ID = L_CELL_NEW_VALUE_S
                  WHERE ID = L_CELL_OLD_VALUE_S ;
               ELSE 
                  UPDATE UTLONGTEXT
                  SET DOC_NAME = L_CELL_NEW_VALUE_S
                  WHERE DOC_NAME = L_CELL_OLD_VALUE_S ;
               END IF ;

               L_UTSCMECELLOLD_REC.VALUE_S := L_CELL_NEW_VALUE_S ;

            END IF ; 

            INSERT INTO UTRSCMECELL 
              (SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, CELLNODE, DSP_TITLE, VALUE_F, VALUE_S,
               CELL_TP, POS_X, POS_Y, ALIGN, WINSIZE_X, WINSIZE_Y, IS_PROTECTED, MANDATORY, HIDDEN, UNIT, FORMAT,
               EQ, EQ_VERSION, COMPONENT, CALC_TP, CALC_FORMULA, VALID_CF, MAX_X, MAX_Y, MULTI_SELECT)
            VALUES (L_UTSCMECELLOLD_REC.SC, L_UTSCMECELLOLD_REC.PG, L_UTSCMECELLOLD_REC.PGNODE, L_UTSCMECELLOLD_REC.PA,
               L_UTSCMECELLOLD_REC.PANODE, L_UTSCMECELLOLD_REC.ME, L_UTSCMECELLOLD_REC.MENODE, L_UTSCMECELLOLD_REC.REANALYSIS,
               L_UTSCMECELLOLD_REC.CELL, L_UTSCMECELLOLD_REC.CELLNODE, L_UTSCMECELLOLD_REC.DSP_TITLE, L_UTSCMECELLOLD_REC.VALUE_F,
               L_UTSCMECELLOLD_REC.VALUE_S, L_UTSCMECELLOLD_REC.CELL_TP, L_UTSCMECELLOLD_REC.POS_X, L_UTSCMECELLOLD_REC.POS_Y,
               L_UTSCMECELLOLD_REC.ALIGN, L_UTSCMECELLOLD_REC.WINSIZE_X, L_UTSCMECELLOLD_REC.WINSIZE_Y, L_UTSCMECELLOLD_REC.IS_PROTECTED,
               L_UTSCMECELLOLD_REC.MANDATORY, L_UTSCMECELLOLD_REC.HIDDEN, L_UTSCMECELLOLD_REC.UNIT, L_UTSCMECELLOLD_REC.FORMAT,
               L_UTSCMECELLOLD_REC.EQ, L_UTSCMECELLOLD_REC.EQ_VERSION, L_UTSCMECELLOLD_REC.COMPONENT, L_UTSCMECELLOLD_REC.CALC_TP,
               L_UTSCMECELLOLD_REC.CALC_FORMULA, L_UTSCMECELLOLD_REC.VALID_CF, L_UTSCMECELLOLD_REC.MAX_X, L_UTSCMECELLOLD_REC.MAX_Y,
               L_UTSCMECELLOLD_REC.MULTI_SELECT) ;
               
         END LOOP ;

	      
	      
	      
	      INSERT INTO UTRSCMECELLLIST
	      (SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, INDEX_X,  INDEX_Y, VALUE_F, VALUE_S, SELECTED)
	      SELECT SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, INDEX_X,  INDEX_Y, VALUE_F, VALUE_S, SELECTED
	      FROM UTSCMECELLLIST
	      WHERE SC = A_SC
	         AND PG = A_PG
	         AND PGNODE = A_PGNODE
	         AND PA = A_PA
	         AND PANODE = A_PANODE
	         AND ME = A_ME
	         AND MENODE = A_MENODE
	         AND REANALYSIS = A_REANALYSIS;

	      
	      
	      
	      INSERT INTO UTRSCMECELLOUTPUT
	      (SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, SAVE_TP,  SAVE_PG, SAVE_PGNODE, SAVE_PA, SAVE_PANODE, SAVE_ME, SAVE_MENODE, SAVE_EQ, SAVE_ID, SAVE_IDNODE, SAVE_REANALYSIS,  CREATE_NEW)
	      SELECT SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, SAVE_TP,  SAVE_PG, SAVE_PGNODE, SAVE_PA, SAVE_PANODE, SAVE_ME, SAVE_MENODE, SAVE_EQ, SAVE_ID, SAVE_IDNODE, SAVE_REANALYSIS,  CREATE_NEW
	      FROM UTSCMECELLOUTPUT
	      WHERE SC = A_SC
	         AND PG = A_PG
	         AND PGNODE = A_PGNODE
	         AND PA = A_PA
	         AND PANODE = A_PANODE
	         AND ME = A_ME
	         AND MENODE = A_MENODE
	         AND REANALYSIS = A_REANALYSIS;

	      
	      
	      
	      INSERT INTO UTRSCMECELLLISTOUTPUT
	      (SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, INDEX_Y,  SAVE_TP, SAVE_PG, SAVE_PGNODE, SAVE_PA, SAVE_PANODE, SAVE_ME, SAVE_MENODE, SAVE_EQ, SAVE_ID, SAVE_IDNODE,  SAVE_REANALYSIS, CREATE_NEW)
	      SELECT SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, INDEX_Y,  SAVE_TP, SAVE_PG, SAVE_PGNODE, SAVE_PA, SAVE_PANODE, SAVE_ME, SAVE_MENODE, SAVE_EQ, SAVE_ID, SAVE_IDNODE,  SAVE_REANALYSIS, CREATE_NEW
	      FROM UTSCMECELLLISTOUTPUT
	      WHERE SC = A_SC
	         AND PG = A_PG
	         AND PGNODE = A_PGNODE
	         AND PA = A_PA
	         AND PANODE = A_PANODE
	         AND ME = A_ME
	         AND MENODE = A_MENODE
	         AND REANALYSIS = A_REANALYSIS;

	      
	      
	      
	      INSERT INTO UTRSCMECELLINPUT
	      (SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, INPUT_TP,  INPUT_SOURCE, INPUT_PG, INPUT_PGNODE, INPUT_PA, INPUT_PANODE, INPUT_ME, INPUT_MENODE, INPUT_REANALYSIS)
	      SELECT SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, INPUT_TP,  INPUT_SOURCE, INPUT_PG, INPUT_PGNODE, INPUT_PA, INPUT_PANODE, INPUT_ME, INPUT_MENODE, INPUT_REANALYSIS
	      FROM UTSCMECELLINPUT
	      WHERE SC = A_SC
	         AND PG = A_PG
	         AND PGNODE = A_PGNODE
	         AND PA = A_PA
	         AND PANODE = A_PANODE
	         AND ME = A_ME
	         AND MENODE = A_MENODE
	         AND REANALYSIS = A_REANALYSIS;
	   END IF ;
   END COPYSCMECELLSINTOREANALTABLES;   

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_MENODE, 0) = 0 OR
      A_REANALYSIS IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   OPEN L_SCME_CURSOR;
   FETCH L_SCME_CURSOR
   INTO L_REANALYSIS, L_LC, L_LC_VERSION, L_MT_VERSION;
   
   IF L_SCME_CURSOR%NOTFOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      CLOSE L_SCME_CURSOR;
      RAISE STPERROR;
   END IF;
   CLOSE L_SCME_CURSOR;
   
   
   
   L_EV_DETAILS_LIKE := 'sc=' || A_SC ||
                      '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                      '#menode=' || TO_CHAR(A_MENODE) ||'%';
   SELECT COUNT(*)
   INTO L_COUNT_EVENTS
   FROM UTEV
   WHERE TR_SEQ = UNAPIGEN.P_TR_SEQ
   
   AND DBAPI_NAME LIKE 'ReanalScMe%'
   AND OBJECT_TP ='me'
   AND OBJECT_ID = A_ME
   AND EV_DETAILS LIKE L_EV_DETAILS_LIKE;
   
   IF L_COUNT_EVENTS>0 THEN
      
      IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   IF A_REANALYSIS <> L_REANALYSIS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTCURRENTMETHOD;
      RAISE STPERROR;   
   END IF;
   
   
   OPEN L_LC_CURSOR(L_LC, L_LC_VERSION);
   FETCH L_LC_CURSOR
   INTO L_NEW_SS;
   
   IF L_LC_CURSOR%NOTFOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOLC;
      CLOSE L_LC_CURSOR;
      RAISE STPERROR;
   END IF;
   CLOSE L_LC_CURSOR;
   
   L_OLD_SS := NULL; 
   L_RET_CODE := UNAPIMEP.SCMETRANSITIONAUTHORISED
                    (A_SC, A_PG, A_PGNODE, A_PA,
                     A_PANODE, A_ME, A_MENODE, A_REANALYSIS,
                     L_LC, L_LC_VERSION, L_OLD_SS, L_NEW_SS,
                     UNAPIGEN.P_USER,
                     L_LC_SS_FROM, L_TR_NO, 
                     L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
                     
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
      L_RET_CODE <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN

      
      L_EVENT_TP := 'MeReanalysis';
      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'sc=' || A_SC ||
                      '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                      '#menode=' || TO_CHAR(A_MENODE) ||
                      '#old_reanalysis=' || TO_CHAR(L_REANALYSIS) ||
                      '#new_reanalysis=' || TO_CHAR(L_REANALYSIS + 1)||
                      '#tr_no=' || L_TR_NO ||
                      '#ss_from=' || L_OLD_SS ||
                      '#lc_ss_from='|| L_LC_SS_FROM || 
                      '#mt_version=' || L_MT_VERSION;
      L_RESULT := UNAPIEV.INSERTEVENT('ReanalScMethod', UNAPIGEN.P_EVMGR_NAME, 'me', A_ME, L_LC,
                                      L_LC_VERSION, L_NEW_SS, L_EVENT_TP, L_EV_DETAILS,
                                      L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;

      
      
      
      L_IS_VALUE_S_UPDATED := FALSE;
         
      OPEN L_UTSCMEOLD_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE);
      FETCH L_UTSCMEOLD_CURSOR
      INTO L_UTSCMEOLD_REC;
      CLOSE L_UTSCMEOLD_CURSOR;
      
      
      
      
      IF ( SUBSTR(L_UTSCMEOLD_REC.VALUE_S, -4)  IN ('#BLB', '@TXT', '#IMG', '#LNK', '#TXT', '#DOC' ) ) THEN

         L_OLD_VALUE_S := L_UTSCMEOLD_REC.VALUE_S ;
         L_NEW_VALUE_S := SUBSTR(L_OLD_VALUE_S, 0, LENGTH(L_OLD_VALUE_S) - 4 ) || '#R' || SUBSTR(L_OLD_VALUE_S, -4) ;

         IF ( SUBSTR(L_OLD_VALUE_S, -4)  = '#BLB') THEN
            UPDATE UTBLOB
            SET ID = L_NEW_VALUE_S
            WHERE ID = L_OLD_VALUE_S ;

            UPDATE UTBLOBHS
            SET ID = L_NEW_VALUE_S
            WHERE ID = L_OLD_VALUE_S ;
         ELSE 
            UPDATE UTLONGTEXT
            SET DOC_NAME = L_NEW_VALUE_S
            WHERE DOC_NAME = L_OLD_VALUE_S ;
         END IF ;

         L_UTSCMEOLD_REC.VALUE_S := L_NEW_VALUE_S ;
         L_IS_VALUE_S_UPDATED := TRUE;

      END IF ; 

      INSERT INTO UTRSCME
      VALUES L_UTSCMEOLD_REC ;
      
      
      
      
      OPEN L_SCMEOLD_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE);
      FETCH L_SCMEOLD_CURSOR
      INTO L_SCMEOLD_REC;
      CLOSE L_SCMEOLD_CURSOR;
      
      IF (L_IS_VALUE_S_UPDATED = TRUE) THEN
         
         L_SCMEOLD_REC.VALUE_S := L_NEW_VALUE_S;
      END IF;
      
      L_SCMENEW_REC := L_SCMEOLD_REC;

      
      
      
      L_RESULT := UNAPIMEP2.CLEARWHEREUSEDINMEDETAILS('me', A_SC, A_PG, A_PGNODE, A_PA, A_PANODE,
                                                      A_ME, A_MENODE, A_REANALYSIS, A_REANALYSIS+1, A_MODIFY_REASON);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
      
      
      
      
         
      FOR L_SCMECELL_REC IN L_SCMECELLOUTPUT_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE) LOOP
         IF L_SCMECELL_REC.SAVE_TP = 'pr' AND 
            L_SCMECELL_REC.SAVE_PANODE IS NOT NULL THEN            
            L_RESULT := UNAPIGEN.DBERR_SUCCESS;
            IF L_SCMECELL_REC.SAVE_PG = A_PG AND
               L_SCMECELL_REC.SAVE_PGNODE = A_PGNODE AND
               L_SCMECELL_REC.SAVE_PA = A_PA AND
               L_SCMECELL_REC.SAVE_PANODE = A_PANODE THEN
               
               
               
               
               
               OPEN L_CHECK_UTRSCPA_CURSOR(A_SC, 
                                           L_SCMECELL_REC.SAVE_PG, L_SCMECELL_REC.SAVE_PGNODE,
                                           L_SCMECELL_REC.SAVE_PA, L_SCMECELL_REC.SAVE_PANODE);
               FETCH L_CHECK_UTRSCPA_CURSOR
               INTO L_CHECK_UTRSCPA_REC;
               L_REANALYSIS_PERFORMED := L_CHECK_UTRSCPA_CURSOR%FOUND;
               CLOSE L_CHECK_UTRSCPA_CURSOR;               

               IF L_REANALYSIS_PERFORMED THEN
                  
                  
                  
                  L_SCMECELL_REC.HASBEENMODIFIED := '1';
                  L_SCMECELL_REC.SAVE_REANALYSIS := L_CHECK_UTRSCPA_REC.REANALYSIS;
               ELSE
                  
                  
                  OPEN L_SCPAREANALYSIS_CURSOR(A_SC, L_SCMECELL_REC.SAVE_PG, L_SCMECELL_REC.SAVE_PGNODE,
                                                     L_SCMECELL_REC.SAVE_PA, L_SCMECELL_REC.SAVE_PANODE);
                  FETCH L_SCPAREANALYSIS_CURSOR
                  INTO L_SCPAREANALYSIS_REC;
                  CLOSE L_SCPAREANALYSIS_CURSOR;
                  IF L_SCPAREANALYSIS_REC.REANALYSIS = L_SCMECELL_REC.SAVE_REANALYSIS THEN
                     L_RESULT := UNAPIMEP.REANALSCPAFROMDETAILS(A_SC, 
                                                                L_SCMECELL_REC.SAVE_PG, 
                                                                L_SCMECELL_REC.SAVE_PGNODE,
                                                                L_SCMECELL_REC.SAVE_PA, 
                                                                L_SCMECELL_REC.SAVE_PANODE,
                                                                L_REANALYSIS_OUT, A_MODIFY_REASON);               
                     IF L_RESULT = UNAPIGEN.DBERR_SUCCESS THEN
                        L_SCMECELL_REC.HASBEENMODIFIED := '1';
                        L_SCMECELL_REC.SAVE_REANALYSIS := L_REANALYSIS_OUT;
                     END IF;
                  END IF;
               END IF;
            ELSE
               
               
               OPEN L_SCPAREANALYSIS_CURSOR(A_SC, L_SCMECELL_REC.SAVE_PG, L_SCMECELL_REC.SAVE_PGNODE,
                                                  L_SCMECELL_REC.SAVE_PA, L_SCMECELL_REC.SAVE_PANODE);
               FETCH L_SCPAREANALYSIS_CURSOR
               INTO L_SCPAREANALYSIS_REC;
               CLOSE L_SCPAREANALYSIS_CURSOR;
               IF L_SCPAREANALYSIS_REC.REANALYSIS = L_SCMECELL_REC.SAVE_REANALYSIS THEN
                  L_RESULT := UNAPIPA2.REANALSCPARAMETER(A_SC, 
                                                         L_SCMECELL_REC.SAVE_PG, 
                                                         L_SCMECELL_REC.SAVE_PGNODE,
                                                         L_SCMECELL_REC.SAVE_PA, 
                                                         L_SCMECELL_REC.SAVE_PANODE,
                                                         L_REANALYSIS_OUT, A_MODIFY_REASON);
                  IF L_RESULT = UNAPIGEN.DBERR_SUCCESS THEN
                     L_SCMECELL_REC.HASBEENMODIFIED := '1';
                     L_SCMECELL_REC.SAVE_REANALYSIS := L_REANALYSIS_OUT;
                  END IF;
               END IF;
            END IF;
 
            IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS AND 
               L_RESULT <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
               UNAPIGEN.P_TXN_ERROR := L_RESULT;
               RAISE STPERROR;
            END IF;
         
         ELSIF L_SCMECELL_REC.SAVE_TP = 'mt' AND
            L_SCMECELL_REC.SAVE_MENODE IS NOT NULL THEN
            L_RESULT := UNAPIGEN.DBERR_SUCCESS;
            IF L_SCMECELL_REC.SAVE_PG = A_PG AND
               L_SCMECELL_REC.SAVE_PGNODE = A_PGNODE AND
               L_SCMECELL_REC.SAVE_PA = A_PA AND
               L_SCMECELL_REC.SAVE_PANODE = A_PANODE AND
               L_SCMECELL_REC.SAVE_ME = A_ME AND
               L_SCMECELL_REC.SAVE_MENODE = A_MENODE THEN
               
               
               L_RESULT := UNAPIGEN.DBERR_SUCCESS;
               
               L_SCMECELL_REC.HASBEENMODIFIED := '1';
               L_SCMECELL_REC.SAVE_REANALYSIS := A_REANALYSIS+1;                  
            ELSE   
               
               OPEN L_SCMEREANALYSIS_CURSOR(A_SC, L_SCMECELL_REC.SAVE_PG, L_SCMECELL_REC.SAVE_PGNODE,
                                                  L_SCMECELL_REC.SAVE_PA, L_SCMECELL_REC.SAVE_PANODE,
                                                  L_SCMECELL_REC.SAVE_ME, L_SCMECELL_REC.SAVE_MENODE);
               FETCH L_SCMEREANALYSIS_CURSOR
               INTO L_SCMEREANALYSIS_REC;
               CLOSE L_SCMEREANALYSIS_CURSOR;
               IF L_SCMEREANALYSIS_REC.REANALYSIS = L_SCMECELL_REC.SAVE_REANALYSIS THEN
                  L_REANALYSIS_OUT := L_SCMECELL_REC.SAVE_REANALYSIS;
                  L_RESULT := UNAPIMEP.REANALSCMETHOD(A_SC, 
                                                      L_SCMECELL_REC.SAVE_PG, L_SCMECELL_REC.SAVE_PGNODE, 
                                                      L_SCMECELL_REC.SAVE_PA, L_SCMECELL_REC.SAVE_PANODE,
                                                      L_SCMECELL_REC.SAVE_ME, L_SCMECELL_REC.SAVE_MENODE, 
                                                      L_REANALYSIS_OUT, A_MODIFY_REASON);
                  IF L_RESULT = UNAPIGEN.DBERR_SUCCESS THEN
                     L_SCMECELL_REC.HASBEENMODIFIED := '1';
                     L_SCMECELL_REC.SAVE_REANALYSIS := L_REANALYSIS_OUT;
                  END IF;
               ELSE
                  L_RESULT := UNAPIGEN.DBERR_SUCCESS;
                  
                  L_SCMECELL_REC.HASBEENMODIFIED := '1';
                  L_SCMECELL_REC.SAVE_REANALYSIS := L_SCMEREANALYSIS_REC.REANALYSIS;                  
               END IF;
            END IF;
            IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS AND 
               L_RESULT <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
               UNAPIGEN.P_TXN_ERROR := L_RESULT;
               RAISE STPERROR;
            END IF;
         END IF;
         
         IF L_SCMECELL_REC.HASBEENMODIFIED = '1' THEN
            IF L_SCMECELL_REC.SAVE_TP = 'mt'  THEN
               IF L_SCMECELL_REC.OUTPUT_TP = 'celloutput' THEN
                  UPDATE UTSCMECELLOUTPUT
                  SET SAVE_REANALYSIS = L_REANALYSIS_OUT
                  WHERE SC = A_SC
                    AND PG = A_PG
                    AND PGNODE = A_PGNODE
                    AND PA = A_PA
                    AND PANODE = A_PANODE
                    AND ME = A_ME
                    AND MENODE = A_MENODE
                    AND REANALYSIS = A_REANALYSIS
                    AND CELL = L_SCMECELL_REC.CELL
                    AND SAVE_TP = L_SCMECELL_REC.SAVE_TP
                    AND SAVE_PG = L_SCMECELL_REC.SAVE_PG
                    AND SAVE_PGNODE = L_SCMECELL_REC.SAVE_PGNODE
                    AND SAVE_PA = L_SCMECELL_REC.SAVE_PA
                    AND SAVE_PANODE = L_SCMECELL_REC.SAVE_PANODE
                    AND SAVE_ME = L_SCMECELL_REC.SAVE_ME
                    AND SAVE_MENODE = L_SCMECELL_REC.SAVE_MENODE;
               ELSIF L_SCMECELL_REC.OUTPUT_TP = 'celllistoutput' THEN
                  UPDATE UTSCMECELLLISTOUTPUT
                  SET SAVE_REANALYSIS = L_REANALYSIS_OUT
                  WHERE SC = A_SC
                    AND PG = A_PG
                    AND PGNODE = A_PGNODE
                    AND PA = A_PA
                    AND PANODE = A_PANODE
                    AND ME = A_ME
                    AND MENODE = A_MENODE
                    AND REANALYSIS = A_REANALYSIS
                    AND CELL = L_SCMECELL_REC.CELL
                    AND INDEX_Y = L_SCMECELL_REC.INDEX_Y
                    AND SAVE_TP = L_SCMECELL_REC.SAVE_TP
                    AND SAVE_PG = L_SCMECELL_REC.SAVE_PG
                    AND SAVE_PGNODE = L_SCMECELL_REC.SAVE_PGNODE
                    AND SAVE_PA = L_SCMECELL_REC.SAVE_PA
                    AND SAVE_PANODE = L_SCMECELL_REC.SAVE_PANODE
                    AND SAVE_ME = L_SCMECELL_REC.SAVE_ME
                    AND SAVE_MENODE = L_SCMECELL_REC.SAVE_MENODE;
               END IF;              
            ELSIF L_SCMECELL_REC.SAVE_TP = 'pr'  THEN
               IF L_SCMECELL_REC.OUTPUT_TP = 'celloutput' THEN
                  UPDATE UTSCMECELLOUTPUT
                  SET SAVE_REANALYSIS = L_REANALYSIS_OUT
                  WHERE SC = A_SC
                    AND PG = A_PG
                    AND PGNODE = A_PGNODE
                    AND PA = A_PA
                    AND PANODE = A_PANODE
                    AND ME = A_ME
                    AND MENODE = A_MENODE
                    AND REANALYSIS = A_REANALYSIS
                    AND CELL = L_SCMECELL_REC.CELL
                    AND SAVE_TP = L_SCMECELL_REC.SAVE_TP
                    AND SAVE_PG = L_SCMECELL_REC.SAVE_PG
                    AND SAVE_PGNODE = L_SCMECELL_REC.SAVE_PGNODE
                    AND SAVE_PA = L_SCMECELL_REC.SAVE_PA
                    AND SAVE_PANODE = L_SCMECELL_REC.SAVE_PANODE;
               ELSIF L_SCMECELL_REC.OUTPUT_TP = 'celllistoutput' THEN
                  UPDATE UTSCMECELLLISTOUTPUT
                  SET SAVE_REANALYSIS = L_REANALYSIS_OUT
                  WHERE SC = A_SC
                    AND PG = A_PG
                    AND PGNODE = A_PGNODE
                    AND PA = A_PA
                    AND PANODE = A_PANODE
                    AND ME = A_ME
                    AND MENODE = A_MENODE
                    AND REANALYSIS = A_REANALYSIS
                    AND CELL = L_SCMECELL_REC.CELL
                    AND INDEX_Y = L_SCMECELL_REC.INDEX_Y
                    AND SAVE_TP = L_SCMECELL_REC.SAVE_TP
                    AND SAVE_PG = L_SCMECELL_REC.SAVE_PG
                    AND SAVE_PGNODE = L_SCMECELL_REC.SAVE_PGNODE
                    AND SAVE_PA = L_SCMECELL_REC.SAVE_PA
                    AND SAVE_PANODE = L_SCMECELL_REC.SAVE_PANODE;
               END IF;              
            END IF;
         END IF;
      END LOOP;
   
      
      
      
      COPYSCMECELLSINTOREANALTABLES;

      
      
      
      L_INTERNAL_DELETEDETAILS := TRUE;
      L_RET_CODE := UNAPIMEP.DELETESCMEDETAILS(A_SC, A_PG, A_PGNODE, A_PA,
                                               A_PANODE, A_ME, A_MENODE, A_REANALYSIS);
      L_INTERNAL_DELETEDETAILS := FALSE;
   
      
      
      
      FOR L_SCRD IN L_SCRD_CURSOR LOOP
         L_RET_CODE := UNAPIRD.REANALSCRAWDATA(A_SC, A_PG, A_PGNODE, A_PA,
                                               A_PANODE, A_ME, A_MENODE,
                                               L_SCRD.RD, L_SCRD.RDNODE,
                                               L_RD_REANALYSIS,
                                               A_MODIFY_REASON);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END LOOP;

      
      
      
      
      
      
      IF (P_COPY_EST_COST = 'YES') OR (P_COPY_EST_TIME = 'YES') THEN
         OPEN L_MT_CURSOR(A_ME, L_MT_VERSION);
         FETCH L_MT_CURSOR INTO L_REAL_COST, L_REAL_TIME;
         IF L_MT_CURSOR%NOTFOUND THEN
            CLOSE L_MT_CURSOR;
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
            RAISE STPERROR;
         END IF;
         CLOSE L_MT_CURSOR;
      END IF;
      IF P_COPY_EST_COST <> 'YES' THEN
         L_REAL_COST := NULL;
      END IF;
      IF P_COPY_EST_TIME <> 'YES' THEN
         L_REAL_TIME := NULL;
      END IF;

      
      
      
      UPDATE UTSCME
         SET ALLOW_MODIFY='#',
             SS = L_NEW_SS,
             VALUE_F = NULL,
             VALUE_S = NULL,
             EXEC_START_DATE = NULL,
             EXEC_START_DATE_TZ = NULL,
             EXEC_END_DATE = NULL,
             EXEC_END_DATE_TZ = NULL,
        EXECUTOR = NULL,
             EQ = NULL,
             EQ_VERSION = NULL,
             MANUALLY_ENTERED = '0',
             REAL_COST = L_REAL_COST,
             REAL_TIME = L_REAL_TIME,
             REANALYSIS = REANALYSIS + 1
      WHERE SC = A_SC
        AND PG = A_PG
        AND PGNODE = A_PGNODE
        AND PA = A_PA
        AND PANODE = A_PANODE
        AND ME = A_ME
        AND MENODE = A_MENODE
      RETURNING VALUE_F, VALUE_S, EXEC_START_DATE, EXEC_START_DATE_TZ, EXEC_END_DATE, EXEC_END_DATE_TZ, EXECUTOR, EQ, EQ_VERSION, 
                MANUALLY_ENTERED, REAL_COST, REAL_TIME, REANALYSIS, ALLOW_MODIFY, SS
      INTO L_SCMENEW_REC.VALUE_F, L_SCMENEW_REC.VALUE_S, L_SCMENEW_REC.EXEC_START_DATE,  L_SCMENEW_REC.EXEC_START_DATE_TZ,
           L_SCMENEW_REC.EXEC_END_DATE, L_SCMENEW_REC.EXEC_END_DATE_TZ, L_SCMENEW_REC.EXECUTOR, L_SCMENEW_REC.EQ, 
           L_SCMENEW_REC.EQ_VERSION, L_SCMENEW_REC.MANUALLY_ENTERED, L_SCMENEW_REC.REAL_COST, 
           L_SCMENEW_REC.REAL_TIME, L_SCMENEW_REC.REANALYSIS, L_SCMENEW_REC.ALLOW_MODIFY, 
           L_SCMENEW_REC.SS;
      A_REANALYSIS := L_SCMENEW_REC.REANALYSIS;

      
      
      
      

      IF L_LOG_HS = '1' THEN
         INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                              WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'method "'||A_ME||'" reanalysed, status is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'||UNAPIGEN.SQLSSNAME(L_NEW_SS)||'" ['||L_NEW_SS||'].', 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;

      L_HS_DETAILS_SEQ_NR := 0;
      IF L_LOG_HS_DETAILS = '1' THEN
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ,
                                     SEQ, DETAILS)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_TR_SEQ, 
                L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'method "'||A_ME||'" reanalysed, status is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'||UNAPIGEN.SQLSSNAME(L_NEW_SS)||'" ['||L_NEW_SS||'].');

         UNAPIHSDETAILS.ADDSCMEHSDETAILS(L_SCMEOLD_REC, L_SCMENEW_REC, UNAPIGEN.P_TR_SEQ, 
                                         L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR); 
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      L_OBJECT_ID :=  A_SC || A_PG || TO_CHAR(A_PGNODE) || A_PA || TO_CHAR(A_PANODE) ||
                      A_ME || TO_CHAR(A_MENODE);
      UNAPIAUT.UPDATEAUTHORISATIONBUFFER('me', L_OBJECT_ID, NULL, L_NEW_SS);
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ReanalScMethod', SQLERRM);
   END IF;
   IF L_SCME_CURSOR%ISOPEN THEN
      CLOSE L_SCME_CURSOR;
   END IF;
   IF L_SCRD_CURSOR%ISOPEN THEN
      CLOSE L_SCRD_CURSOR;
   END IF;
   IF L_LC_CURSOR%ISOPEN THEN
      CLOSE L_LC_CURSOR;
   END IF;
   IF L_CHECK_UTRSCPA_CURSOR%ISOPEN THEN
      CLOSE L_CHECK_UTRSCPA_CURSOR;
   END IF;
   IF L_SCMEOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCMEOLD_CURSOR;
   END IF;
   IF L_MT_CURSOR%ISOPEN THEN
      CLOSE L_MT_CURSOR;
   END IF;
   L_INTERNAL_DELETEDETAILS := FALSE;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ReanalScMethod'));
END REANALSCMETHOD;








FUNCTION FILLMEDEFAULTVALUE              
(A_SC               IN      VARCHAR2,    
 A_PG               IN OUT  VARCHAR2,    
 A_PGNODE           IN OUT  NUMBER,      
 A_PA               IN OUT  VARCHAR2,    
 A_PANODE           IN OUT  NUMBER,      
 A_ME               IN OUT  VARCHAR2,    
 A_MENODE           IN OUT  NUMBER,      
 A_DEF_VAL_TP       IN CHAR,             
 A_DEF_VAL          IN VARCHAR2,         
 A_DEF_AU_LEVEL     IN VARCHAR2,         
 A_FORMAT           IN VARCHAR2,         
 A_VALUE_F          OUT     FLOAT,       
 A_VALUE_S          OUT     VARCHAR2)    
RETURN NUMBER IS

L_EQ               VARCHAR2(20);
L_VALUE_F          FLOAT;
L_VALUE_S          VARCHAR2(40);
L_FETCHED_ROWS     NUMBER;
L_DATE_CURSOR      INTEGER;
L_DATE             TIMESTAMP WITH TIME ZONE;
L_PP_VERSION       VARCHAR2(20);
L_PP_KEY1          VARCHAR2(20);
L_PP_KEY2          VARCHAR2(20);
L_PP_KEY3          VARCHAR2(20);
L_PP_KEY4          VARCHAR2(20);
L_PP_KEY5          VARCHAR2(20);
L_PR_VERSION       VARCHAR2(20);
L_MT_VERSION       VARCHAR2(20);

CURSOR L_PP_CURSOR IS
   SELECT PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5
   FROM UTSCPG
   WHERE SC = A_SC
   AND PG = A_PG 
   AND PGNODE = A_PGNODE;

CURSOR L_PR_VERSION_CURSOR IS
   SELECT PR_VERSION
   FROM UTSCPA
   WHERE SC = A_SC
   AND PG = A_PG 
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE;

CURSOR L_MT_VERSION_CURSOR IS
   SELECT MT_VERSION
   FROM UTSCME
   WHERE SC = A_SC
   AND PG = A_PG 
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE;

CURSOR L_STAU_CURSOR(A_SC VARCHAR2, A_DEF_VAL VARCHAR2) IS
   SELECT S.VALUE
   FROM UTSTAU S, UTSC C
   WHERE C.SC = A_SC
     AND S.ST = C.ST
     AND S.VERSION = C.ST_VERSION
     AND S.AU = A_DEF_VAL
   ORDER BY S.AUSEQ;

CURSOR L_RTAU_CURSOR(A_SC VARCHAR2, A_DEF_VAL VARCHAR2) IS
   SELECT S.VALUE
   FROM UTRTAU S, UTRQ R, UTSC C
   WHERE C.SC = A_SC
     AND C.RQ = R.RQ
     AND S.RT = R.RT
     AND S.VERSION = R.RT_VERSION
     AND S.AU = A_DEF_VAL
   ORDER BY S.AUSEQ;

CURSOR L_PPAU_CURSOR(A_PP VARCHAR2, A_PP_VERSION VARCHAR2, A_PP_KEY1 VARCHAR2, A_PP_KEY2 VARCHAR2, 
                     A_PP_KEY3 VARCHAR2, A_PP_KEY4 VARCHAR2, A_PP_KEY5 VARCHAR2, A_DEF_VAL VARCHAR2) IS
   SELECT VALUE
   FROM UTPPAU
   WHERE PP      = A_PP
     AND VERSION = A_PP_VERSION
     AND PP_KEY1 = A_PP_KEY1
     AND PP_KEY2 = A_PP_KEY2
     AND PP_KEY3 = A_PP_KEY3
     AND PP_KEY4 = A_PP_KEY4
     AND PP_KEY5 = A_PP_KEY5
     AND AU = A_DEF_VAL
   ORDER BY AUSEQ;
   
CURSOR L_STPPAU_CURSOR(A_SC VARCHAR2, A_PP VARCHAR2, A_PP_VERSION VARCHAR2, A_PP_KEY1 VARCHAR2, A_PP_KEY2 VARCHAR2, 
                       A_PP_KEY3 VARCHAR2, A_PP_KEY4 VARCHAR2, A_PP_KEY5 VARCHAR2, A_DEF_VAL VARCHAR2) IS
   SELECT S.VALUE
   FROM UTSTPPAU S, UTSC C
   WHERE C.SC = A_SC
     AND S.ST = C.ST
     AND S.VERSION = C.ST_VERSION
     AND S.PP      = A_PP
     AND UNAPIGEN.VALIDATEPPVERSION(S.PP,S.PP_VERSION,S.PP_KEY1,S.PP_KEY2,S.PP_KEY3,S.PP_KEY4,S.PP_KEY5) = A_PP_VERSION
     AND S.PP_KEY1 = A_PP_KEY1
     AND S.PP_KEY2 = A_PP_KEY2
     AND S.PP_KEY3 = A_PP_KEY3
     AND S.PP_KEY4 = A_PP_KEY4
     AND S.PP_KEY5 = A_PP_KEY5
     AND S.AU = A_DEF_VAL
   ORDER BY S.AUSEQ;

CURSOR L_PRAU_CURSOR(A_PR VARCHAR2, A_PR_VERSION VARCHAR2, A_DEF_VAL VARCHAR2) IS
   SELECT VALUE
   FROM UTPRAU
   WHERE PR = A_PR
     AND VERSION = A_PR_VERSION
     AND AU = A_DEF_VAL
   ORDER BY AUSEQ;

CURSOR L_PPPRAU_CURSOR(A_PP VARCHAR2, A_PP_VERSION VARCHAR2, A_PP_KEY1 VARCHAR2, A_PP_KEY2 VARCHAR2, 
                       A_PP_KEY3 VARCHAR2, A_PP_KEY4 VARCHAR2, A_PP_KEY5 VARCHAR2, 
                       A_PR VARCHAR2, A_PR_VERSION VARCHAR2, A_DEF_VAL VARCHAR2) IS
   SELECT VALUE
   FROM UTPPPRAU
   WHERE PP      = A_PP
     AND VERSION = A_PP_VERSION
     AND PP_KEY1 = A_PP_KEY1
     AND PP_KEY2 = A_PP_KEY2
     AND PP_KEY3 = A_PP_KEY3
     AND PP_KEY4 = A_PP_KEY4
     AND PP_KEY5 = A_PP_KEY5
     AND PR = A_PR
     AND UNAPIGEN.VALIDATEVERSION('pr',PR,PR_VERSION) = A_PR_VERSION
     AND AU = A_DEF_VAL
   ORDER BY AUSEQ;

CURSOR L_PRMTAU_CURSOR(A_PR VARCHAR2, A_PR_VERSION VARCHAR2,
                       A_MT VARCHAR2, A_MT_VERSION VARCHAR2, 
                       A_DEF_VAL VARCHAR2) IS
   SELECT VALUE
   FROM UTPRMTAU
   WHERE PR = A_PR
     AND VERSION = A_PR_VERSION
     AND MT = A_MT
     AND UNAPIGEN.VALIDATEVERSION('mt',MT,MT_VERSION) = A_MT_VERSION
     AND AU = A_DEF_VAL
   ORDER BY AUSEQ;

CURSOR L_MTAU_CURSOR(A_MT VARCHAR2, A_MT_VERSION VARCHAR2, A_DEF_VAL VARCHAR2) IS
   SELECT VALUE
   FROM UTMTAU
   WHERE MT = A_MT
     AND VERSION = A_MT_VERSION
     AND AU = A_DEF_VAL
   ORDER BY AUSEQ;

CURSOR L_EQAU_CURSOR(A_EQ VARCHAR2, A_DEF_VAL VARCHAR2) IS
   SELECT VALUE
   FROM UTEQAU
   WHERE EQ = A_EQ
     AND AU = A_DEF_VAL
   ORDER BY AUSEQ;

CURSOR L_RTSTAU_CURSOR(A_SC VARCHAR2, A_DEF_VAL VARCHAR2) IS
   SELECT S.VALUE
   FROM UTRTSTAU S, UTSC C, UTRQ R
   WHERE C.SC = A_SC
     AND S.ST = C.ST
     AND UNAPIGEN.VALIDATEVERSION('st',S.ST,S.ST_VERSION) = C.ST_VERSION
     AND S.RT = R.RT
     AND S.VERSION = R.RT_VERSION
     AND R.RQ = C.RQ
     AND S.AU = A_DEF_VAL
   ORDER BY S.AUSEQ;

CURSOR L_SCAU_CURSOR(A_SC VARCHAR2, A_DEF_VAL VARCHAR2) IS
   SELECT VALUE
   FROM UTSCAU
   WHERE SC = A_SC
     AND AU = A_DEF_VAL
   ORDER BY AUSEQ;

CURSOR L_SCPGAU_CURSOR(A_SC VARCHAR2, A_PG VARCHAR2, A_PGNODE NUMBER, A_DEF_VAL VARCHAR2) IS
   SELECT VALUE
   FROM UTSCPGAU
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND AU = A_DEF_VAL
   ORDER BY AUSEQ;

CURSOR L_SCPAAU_CURSOR(A_SC VARCHAR2, A_PG VARCHAR2, A_PGNODE NUMBER,
                       A_PA VARCHAR2, A_PANODE NUMBER, A_DEF_VAL VARCHAR2) IS
   SELECT VALUE
   FROM UTSCPAAU
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE
     AND AU = A_DEF_VAL
   ORDER BY AUSEQ;

CURSOR L_SCMEAU_CURSOR(A_SC VARCHAR2, A_PG VARCHAR2, A_PGNODE NUMBER,
                       A_PA VARCHAR2, A_PANODE NUMBER,
                       A_ME VARCHAR2, A_MENODE NUMBER,
                       A_DEF_VAL VARCHAR2) IS
   SELECT VALUE
   FROM UTSCMEAU
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE
     AND ME = A_ME
     AND MENODE = A_MENODE
     AND AU = A_DEF_VAL
   ORDER BY AUSEQ;

CURSOR L_RQAU_CURSOR(A_SC VARCHAR2, A_DEF_VAL VARCHAR2) IS
   SELECT VALUE
   FROM UTRQAU
   WHERE RQ = (SELECT RQ FROM UTSC WHERE SC=A_SC)
     AND AU = A_DEF_VAL
   ORDER BY AUSEQ;

BEGIN

   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_ME, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_NOOBJID);
   END IF;

   IF NVL(A_DEF_VAL_TP, ' ') = 'F' THEN
      L_VALUE_S := A_DEF_VAL;
   ELSIF NVL(A_DEF_VAL_TP, ' ') = 'A' THEN
      IF NVL(A_DEF_AU_LEVEL, ' ') = 'st' THEN

         OPEN L_STAU_CURSOR(A_SC, A_DEF_VAL);
         FETCH L_STAU_CURSOR
         INTO L_VALUE_S;
         IF L_STAU_CURSOR%NOTFOUND THEN
            CLOSE L_STAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_STAU_CURSOR;
      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'rt' THEN

         OPEN L_RTAU_CURSOR(A_SC, A_DEF_VAL);
         FETCH L_RTAU_CURSOR
         INTO L_VALUE_S;
         IF L_RTAU_CURSOR%NOTFOUND THEN
            CLOSE L_RTAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_RTAU_CURSOR;

      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'rtst' THEN

         OPEN L_RTSTAU_CURSOR(A_SC, A_DEF_VAL);
         FETCH L_RTSTAU_CURSOR
         INTO L_VALUE_S;
         IF L_RTSTAU_CURSOR%NOTFOUND THEN
            CLOSE L_RTSTAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_RTSTAU_CURSOR;
      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'pp' THEN

         OPEN L_PP_CURSOR;
         FETCH L_PP_CURSOR INTO L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5;
         CLOSE L_PP_CURSOR;

         OPEN L_PPAU_CURSOR(A_PG, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, A_DEF_VAL);
         FETCH L_PPAU_CURSOR
         INTO L_VALUE_S;
         IF L_PPAU_CURSOR%NOTFOUND THEN
            CLOSE L_PPAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_PPAU_CURSOR;

      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'stpp' THEN

         OPEN L_PP_CURSOR;
         FETCH L_PP_CURSOR INTO L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5;
         CLOSE L_PP_CURSOR;

         OPEN L_STPPAU_CURSOR(A_SC, A_PG, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, A_DEF_VAL);
         FETCH L_STPPAU_CURSOR
         INTO L_VALUE_S;
         IF L_STPPAU_CURSOR%NOTFOUND THEN
            CLOSE L_STPPAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_STPPAU_CURSOR;

      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'pr' THEN

         OPEN L_PR_VERSION_CURSOR;
         FETCH L_PR_VERSION_CURSOR INTO L_PR_VERSION;
         CLOSE L_PR_VERSION_CURSOR;

         OPEN L_PRAU_CURSOR(A_PA, L_PR_VERSION, A_DEF_VAL);
         FETCH L_PRAU_CURSOR
         INTO L_VALUE_S;
         IF L_PRAU_CURSOR%NOTFOUND THEN
            CLOSE L_PRAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_PRAU_CURSOR;

      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'pppr' THEN
         OPEN L_PP_CURSOR;
         FETCH L_PP_CURSOR INTO L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5;
         CLOSE L_PP_CURSOR;

         OPEN L_PR_VERSION_CURSOR;
         FETCH L_PR_VERSION_CURSOR INTO L_PR_VERSION;
         CLOSE L_PR_VERSION_CURSOR;

         OPEN L_PPPRAU_CURSOR(A_PG, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, 
                              A_PA, L_PR_VERSION, A_DEF_VAL);
         FETCH L_PPPRAU_CURSOR
         INTO L_VALUE_S;
         IF L_PPPRAU_CURSOR%NOTFOUND THEN
            CLOSE L_PPPRAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_PPPRAU_CURSOR;

      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'prmt' THEN
         OPEN L_PR_VERSION_CURSOR;
         FETCH L_PR_VERSION_CURSOR INTO L_PR_VERSION;
         CLOSE L_PR_VERSION_CURSOR;

         OPEN L_MT_VERSION_CURSOR;
         FETCH L_MT_VERSION_CURSOR INTO L_MT_VERSION;
         CLOSE L_MT_VERSION_CURSOR;

         OPEN L_PRMTAU_CURSOR(A_PA, L_PR_VERSION, A_ME, L_MT_VERSION, A_DEF_VAL);
         FETCH L_PRMTAU_CURSOR
         INTO L_VALUE_S;
         IF L_PRMTAU_CURSOR%NOTFOUND THEN
            CLOSE L_PRMTAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_PRMTAU_CURSOR;

      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'mt' THEN
         OPEN L_MT_VERSION_CURSOR;
         FETCH L_MT_VERSION_CURSOR INTO L_MT_VERSION;
         CLOSE L_MT_VERSION_CURSOR;

         OPEN L_MTAU_CURSOR(A_ME, L_MT_VERSION, A_DEF_VAL);
         FETCH L_MTAU_CURSOR
         INTO L_VALUE_S;
         IF L_MTAU_CURSOR%NOTFOUND THEN
            CLOSE L_MTAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_MTAU_CURSOR;

      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'eq' THEN
         SELECT EQ
         INTO L_EQ
         FROM UTSCME
         WHERE SC = A_SC
           AND PG = A_PG
           AND PGNODE = A_PGNODE
           AND PA = A_PA
           AND PANODE = A_PANODE
           AND ME = A_ME
           AND MENODE = A_MENODE;
         IF L_EQ IS NULL THEN
            OPEN L_MT_VERSION_CURSOR;
            FETCH L_MT_VERSION_CURSOR INTO L_MT_VERSION;
            CLOSE L_MT_VERSION_CURSOR;
            
            
            






            
         END IF;
         IF NVL(L_EQ, ' ') <> ' ' THEN
            OPEN L_EQAU_CURSOR(L_EQ, A_DEF_VAL);
            FETCH L_EQAU_CURSOR
            INTO L_VALUE_S;
            IF L_EQAU_CURSOR%NOTFOUND THEN
               CLOSE L_EQAU_CURSOR;
               RETURN(UNAPIGEN.DBERR_NOOBJECT);
            END IF;
            CLOSE L_EQAU_CURSOR;
         ELSE
            RETURN(UNAPIGEN.DBERR_SELECTEQ);
         END IF;
      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'sc' THEN

         OPEN L_SCAU_CURSOR(A_SC, A_DEF_VAL);
         FETCH L_SCAU_CURSOR
         INTO L_VALUE_S;
         IF L_SCAU_CURSOR%NOTFOUND THEN
            CLOSE L_SCAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_SCAU_CURSOR;
      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'scpg' THEN

         OPEN L_SCPGAU_CURSOR(A_SC, A_PG, A_PGNODE, A_DEF_VAL);
         FETCH L_SCPGAU_CURSOR
         INTO L_VALUE_S;
         IF L_SCPGAU_CURSOR%NOTFOUND THEN
            CLOSE L_SCPGAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_SCPGAU_CURSOR;
      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'scpa' THEN

         OPEN L_SCPAAU_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_DEF_VAL);
         FETCH L_SCPAAU_CURSOR
         INTO L_VALUE_S;
         IF L_SCPAAU_CURSOR%NOTFOUND THEN
            CLOSE L_SCPAAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_SCPAAU_CURSOR;
      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'scme' THEN

         OPEN L_SCMEAU_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_DEF_VAL);
         FETCH L_SCMEAU_CURSOR
         INTO L_VALUE_S;
         IF L_SCMEAU_CURSOR%NOTFOUND THEN
            CLOSE L_SCMEAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_SCMEAU_CURSOR;
      ELSIF NVL(A_DEF_AU_LEVEL, ' ') = 'rq' THEN

         OPEN L_RQAU_CURSOR(A_SC, A_DEF_VAL);
         FETCH L_RQAU_CURSOR
         INTO L_VALUE_S;
         IF L_RQAU_CURSOR%NOTFOUND THEN
            CLOSE L_RQAU_CURSOR;
            RETURN(UNAPIGEN.DBERR_NOOBJECT);
         END IF;
         CLOSE L_RQAU_CURSOR;
      ELSE
         RETURN(UNAPIGEN.DBERR_AULEVEL);
      END IF;
   ELSE
      RETURN(UNAPIGEN.DBERR_DEFVALUETP);
   END IF;

   
   
   
   
   IF SUBSTR(A_FORMAT,1,1)='C' THEN
      IF LENGTH(A_FORMAT)>1 THEN
         L_VALUE_S := SUBSTR(L_VALUE_S,1,SUBSTR(A_FORMAT,2));
         L_VALUE_F := NULL;
      ELSE
         
         L_VALUE_F := NULL;
      END IF;
   
   ELSIF SUBSTR(A_FORMAT,1,1)='D' THEN
      L_VALUE_F := NULL;
      IF L_VALUE_S IS NOT NULL THEN
         BEGIN
            L_DATE_CURSOR := DBMS_SQL.OPEN_CURSOR;
            IF SUBSTR(L_VALUE_S,1,1)='=' THEN
               L_SQL_STRING := 'BEGIN :l_date :' || L_VALUE_S || '; END;';
            ELSE
               L_SQL_STRING := 'BEGIN :l_date :=' || SUBSTR(L_VALUE_S,2) || '; END;';
            END IF;
            DBMS_SQL.PARSE(L_DATE_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            DBMS_SQL.BIND_VARIABLE(L_DATE_CURSOR, ':l_date', L_DATE);
            L_RESULT := DBMS_SQL.EXECUTE(L_DATE_CURSOR);
            DBMS_SQL.VARIABLE_VALUE(L_DATE_CURSOR, ':l_date', L_DATE);
            DBMS_SQL.CLOSE_CURSOR(L_DATE_CURSOR);

            L_VALUE_S := TO_CHAR(L_DATE, SUBSTR(A_FORMAT,2));

         EXCEPTION
         WHEN OTHERS THEN
            IF DBMS_SQL.IS_OPEN(L_DATE_CURSOR) THEN
               DBMS_SQL.CLOSE_CURSOR(L_DATE_CURSOR);
            END IF;
            RETURN(UNAPIGEN.DBERR_INVALIDDATE);
         END;
      END IF;
   
   ELSE
      L_VALUE_F := NULL;
      L_RET_CODE := UNAPIGEN.FORMATRESULT(L_VALUE_F, A_FORMAT, L_VALUE_S);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         RETURN(L_RET_CODE);
      END IF;
   END IF;
   
   A_VALUE_S := L_VALUE_S;
   A_VALUE_F := L_VALUE_F;
   
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN NO_DATA_FOUND THEN
   RETURN(UNAPIGEN.DBERR_NORECORDS);
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
         'FillMeDefaultValue', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   IF L_PP_CURSOR%ISOPEN THEN
      CLOSE L_PP_CURSOR;
   END IF;
   IF L_PR_VERSION_CURSOR%ISOPEN THEN
      CLOSE L_PR_VERSION_CURSOR;
   END IF;
   IF L_MT_VERSION_CURSOR%ISOPEN THEN
      CLOSE L_MT_VERSION_CURSOR;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END FILLMEDEFAULTVALUE;

FUNCTION GETSCMEACCESS
(A_SC             OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG             OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE         OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA             OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE         OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME             OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE         OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_DD             OUT     UNAPIGEN.VC3_TABLE_TYPE,   
 A_DATA_DOMAIN    OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_ACCESS_RIGHTS  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NR_OF_ROWS     IN OUT  NUMBER,                    
 A_WHERE_CLAUSE   IN      VARCHAR2)                  
RETURN NUMBER IS

BEGIN
   RETURN(UNAPIMEP2.GETSCMEACCESS(
                       A_SC, A_PG, A_PGNODE, A_PA, A_PANODE,
                       A_ME, A_MENODE, A_DD, A_DATA_DOMAIN,
                       A_ACCESS_RIGHTS, A_NR_OF_ROWS,A_WHERE_CLAUSE));
END GETSCMEACCESS;

FUNCTION SAVESCMEACCESS
(A_SC             IN      VARCHAR2,                  
 A_PG             IN      VARCHAR2,                 
 A_PGNODE         IN      NUMBER,                   
 A_PA             IN      VARCHAR2,                 
 A_PANODE         IN      NUMBER,                   
 A_ME             IN      VARCHAR2,                 
 A_MENODE         IN      NUMBER,                   
 A_DD             IN      UNAPIGEN.VC3_TABLE_TYPE,   
 A_ACCESS_RIGHTS  IN      UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NR_OF_ROWS     IN      NUMBER,                    
 A_MODIFY_REASON  IN      VARCHAR2)                  
RETURN NUMBER IS

BEGIN
   RETURN(UNAPIMEP2.SAVESCMEACCESS(
                       A_SC, A_PG, A_PGNODE, A_PA, A_PANODE,
                       A_ME, A_MENODE, A_DD, A_ACCESS_RIGHTS,
                       A_NR_OF_ROWS,A_MODIFY_REASON));
END SAVESCMEACCESS;

FUNCTION SCMEELECTRONICSIGNATURE
(A_SC                IN      VARCHAR2,     
 A_PG                IN      VARCHAR2,     
 A_PGNODE            IN      NUMBER,       
 A_PA                IN      VARCHAR2,     
 A_PANODE            IN      NUMBER,       
 A_ME                IN      VARCHAR2,     
 A_MENODE            IN      NUMBER,       
 A_REANALYSIS        IN      NUMBER,       
 A_AUTHORISED_BY     IN      VARCHAR2,     
 A_MODIFY_REASON     IN      VARCHAR2)     
RETURN NUMBER IS

L_MT_VERSION        VARCHAR2(20);
L_LC                VARCHAR2(2);
L_LC_VERSION        VARCHAR2(20);
L_SS                VARCHAR2(2);
L_ALLOW_MODIFY      CHAR(1);
L_ACTIVE            CHAR(1);
L_LOG_HS            CHAR(1);
L_LOG_HS_DETAILS    CHAR(1);
L_HS_DETAILS_SEQ_NR INTEGER;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                                               NULL, L_MT_VERSION, L_LC, L_LC_VERSION, L_SS, 
                                               L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF A_AUTHORISED_BY IS NOT NULL THEN
      L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);

      INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                           WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_AUTHORISED_BY, 
             UNAPIGEN.SQLUSERDESCRIPTION(A_AUTHORISED_BY), 'ElectronicSignature', 
             'Last action of method "'||A_ME||'" is signed electronically.', 
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);

      L_HS_DETAILS_SEQ_NR := 0;
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
             UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
             'Last action of method "'||A_ME||'" is signed electronically.');
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ScMeElectronicSignature', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ScMeElectronicSignature'));
END SCMEELECTRONICSIGNATURE;

FUNCTION DELETESCMEDETAILS                            
(A_SC             IN        VARCHAR2,                 
 A_PG             IN        VARCHAR2,                 
 A_PGNODE         IN        NUMBER,                   
 A_PA             IN        VARCHAR2,                 
 A_PANODE         IN        NUMBER,                   
 A_ME             IN        VARCHAR2,                 
 A_MENODE         IN        NUMBER,                   
 A_REANALYSIS     IN        NUMBER)                   
RETURN NUMBER IS

L_LC               VARCHAR2(2);
L_LC_VERSION       VARCHAR2(20);
L_SS               VARCHAR2(2);
L_LOG_HS           CHAR(1);
L_LOG_HS_DETAILS   CHAR(1);
L_MT_VERSION       VARCHAR2(20);
L_HS_DETAILS_SEQ_NR  INTEGER;

CURSOR L_VERSION_CURSOR IS
   SELECT MT_VERSION 
   FROM UTSCME
   WHERE SC     = A_SC
     AND PG     = A_PG
     AND PGNODE = A_PGNODE
     AND PA     = A_PA
     AND PANODE = A_PANODE
     AND ME     = A_ME
     AND MENODE = A_MENODE;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_MENODE, 0) = 0 OR
      A_REANALYSIS IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   IF L_INTERNAL_DELETEDETAILS = FALSE THEN
            IF UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTALLOWEDIN21CFR11;
                  RAISE STPERROR;
            END IF;
   END IF;
   
   
   L_INTERNAL_DELETEDETAILS := FALSE;
   
   
   
   
   DELETE FROM UTSCMECELL
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE
     AND ME = A_ME
     AND MENODE = A_MENODE;         

   
   
   
   DELETE FROM UTSCMECELLLIST
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;

   
   
   
   DELETE FROM UTSCMECELLOUTPUT
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;

   
   
   
   DELETE FROM UTSCMECELLLISTOUTPUT
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;

   
   
   
   DELETE FROM UTSCMECELLINPUT
   WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;

   OPEN L_VERSION_CURSOR;
   FETCH L_VERSION_CURSOR INTO L_MT_VERSION;
   IF L_VERSION_CURSOR%NOTFOUND THEN
      CLOSE L_VERSION_CURSOR;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MTVERSION;
      RAISE STPERROR;
   END IF;
   CLOSE L_VERSION_CURSOR;

   L_EVENT_TP := 'MeDetailsDeleted';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'sc=' || A_SC ||
                   '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                   '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                   '#menode=' || TO_CHAR(A_MENODE) ||
                   '#mt_version=' || L_MT_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('DeleteScMeDetails', UNAPIGEN.P_EVMGR_NAME,
                                   'me', A_ME, L_LC, L_LC_VERSION, L_SS,
                                   L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   BEGIN
      SELECT LOG_HS, LOG_HS_DETAILS
      INTO L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTSCME
      WHERE MENODE = A_MENODE
        AND ME = A_ME
        AND PANODE = A_PANODE
        AND PA = A_PA
        AND PGNODE = A_PGNODE
        AND PG = A_PG
        AND SC = A_SC;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN (UNAPIGEN.DBERR_NOOBJECT);
   END;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, WHAT, 
                           WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_USER, 
             UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
             'method "'||A_ME||'" cells are deleted.',
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_DETAILS_SEQ_NR := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES  (A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
               'method "'||A_ME||'" cells are deleted.');
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('DeleteScMeDetails',SQLERRM);
   END IF;
   IF L_VERSION_CURSOR%ISOPEN THEN
      CLOSE L_VERSION_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'DeleteScMeDetails'));
END DELETESCMEDETAILS;

FUNCTION GETSCMELSCOMMONLCANDSTATUS
(A_SC            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE        IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE        IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE        IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_REANALYSIS    IN     UNAPIGEN.NUM_TABLE_TYPE,   
 A_LC            OUT    VARCHAR2,                  
 A_LC_VERSION    OUT    VARCHAR2,                  
 A_SS            OUT    VARCHAR2,                  
 A_NR_OF_ROWS    IN     NUMBER,                    
 A_NEXT_ROWS     IN     NUMBER)                    
RETURN NUMBER IS
BEGIN



   L_SQLERRM := NULL;
   L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   IF NVL(A_NEXT_ROWS, 0) = 0 THEN
      
      

      IF NVL(UNAPIGEN.P_TXN_LEVEL, 0) <= 0 THEN 
         IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
            RAISE STPERROR;
         END IF;
         P_GETSCMELS_LCANDSS_INT_TRANS := TRUE;

      ELSE

         P_GETSCMELS_LCANDSS_INT_TRANS := FALSE;      
      END IF;
      IF NVL(P_GETSCMELS_LCANDSS_CALLS, 0) <> 0 THEN
         L_SQLERRM := 'GetScMeLsCommonLcAndStatus termination call never called for previous calls ! (a_next_rows=-1)';
         RAISE STPERROR;
      END IF;
      P_GETSCMELS_LCANDSS_CALLS := 1;
   ELSIF NVL(A_NEXT_ROWS, 0) = -1 THEN
      P_GETSCMELS_LCANDSS_CALLS := NVL(P_GETSCMELS_LCANDSS_CALLS, 0) + 1;      
   ELSIF NVL(A_NEXT_ROWS, 0) = 1 THEN
      IF NVL(P_GETSCMELS_LCANDSS_CALLS, 0) = 0 THEN   
         L_SQLERRM := 'GetScMeLsCommonLcAndStatus startup call never called ! (a_next_rows=0)';
         RAISE STPERROR;   
      END IF;
      IF NVL(UNAPIGEN.P_TXN_LEVEL, 0) < 1 THEN   
         L_SQLERRM := 'GetScMeLsCommonLcAndStatus called with a_next_rows=1 but call with a_next_rows=0 never took place !';
         RAISE STPERROR;   
      END IF;
      P_GETSCMELS_LCANDSS_CALLS := NVL(P_GETSCMELS_LCANDSS_CALLS, 0) + 1;      
   ELSE
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NEXTROWS;
      RAISE STPERROR;
   END IF;         
   IF P_GETSCMELS_LCANDSS_CALLS = 1 THEN
      P_GETSCMELS_LCANDSS_TR_SEQ := UNAPIGEN.P_TR_SEQ;
   ELSE
      IF UNAPIGEN.P_TR_SEQ <> P_GETSCMELS_LCANDSS_TR_SEQ THEN
         L_SQLERRM := 'Assertion failure: Successive calls of GetScMeLsCommonLcAndStatus not in the same internal transaction !';
         RAISE STPERROR;   
      END IF;
   END IF;

   FORALL L_ROW IN 1..A_NR_OF_ROWS      
      INSERT INTO UTMELSSAVESCMERESULT
      (SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS)
       VALUES
      (A_SC(L_ROW), A_PG(L_ROW), A_PGNODE(L_ROW), A_PA(L_ROW), A_PANODE(L_ROW), A_ME(L_ROW), A_MENODE(L_ROW), A_REANALYSIS(L_ROW));       

   
   IF NVL(A_NEXT_ROWS, 0) = -1 THEN      
      
      P_GETSCMELS_LCANDSS_CALLS := 0;
      
      BEGIN
         SELECT LC, LC_VERSION, SS
         INTO A_LC, A_LC_VERSION, A_SS
         FROM (SELECT LC, LC_VERSION, SS,  ROW_NUMBER() OVER (ORDER BY MY_COUNT DESC) AS R
               FROM (SELECT LC, LC_VERSION, SS,  COUNT('x') MY_COUNT  
                     FROM UTSCME 
                     WHERE (SC,PG,PGNODE,PA,PANODE,ME,MENODE,REANALYSIS) IN
                           (SELECT SC,PG,PGNODE,PA,PANODE,ME,MENODE,REANALYSIS
                            FROM UTMELSSAVESCMERESULT)
                     GROUP BY LC, LC_VERSION, SS))                                           
         WHERE R=1;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
      END;
      
      DELETE FROM UTMELSSAVESCMERESULT;
   
      IF P_GETSCMELS_LCANDSS_INT_TRANS THEN    
         IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
            RAISE STPERROR;
         END IF;
         P_GETSCMELS_LCANDSS_INT_TRANS := FALSE;
      END IF;      
   END IF;      

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetScMeLsCommonLcAndStatus',SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('GetScMeLsCommonLcAndStatus',L_SQLERRM);   
   END IF;
   P_GETSCMELS_LCANDSS_CALLS := 0;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'GetScMeLsCommonLcAndStatus'));
END GETSCMELSCOMMONLCANDSTATUS;

FUNCTION CHANGESCMELSSTATUS
(A_OLD_SS        IN     VARCHAR2,                               
 A_NEW_SS        IN     VARCHAR2,                               
 A_LC            IN     VARCHAR2,                               
 A_LC_VERSION    IN     VARCHAR2,                               
 A_SC            IN     UNAPIGEN.VC20_TABLE_TYPE,               
 A_PG            IN     UNAPIGEN.VC20_TABLE_TYPE,               
 A_PGNODE        IN     UNAPIGEN.LONG_TABLE_TYPE,               
 A_PA            IN     UNAPIGEN.VC20_TABLE_TYPE,               
 A_PANODE        IN     UNAPIGEN.LONG_TABLE_TYPE,               
 A_ME            IN     UNAPIGEN.VC20_TABLE_TYPE,               
 A_MENODE        IN     UNAPIGEN.LONG_TABLE_TYPE,               
 A_REANALYSIS    IN     UNAPIGEN.NUM_TABLE_TYPE,                
 A_MODIFY_FLAG   OUT    UNAPIGEN.NUM_TABLE_TYPE,                
 A_NR_OF_ROWS    IN     NUMBER,                                 
 A_NEXT_ROWS     IN     NUMBER,                                 
 A_MODIFY_REASON IN     VARCHAR2)                               
RETURN NUMBER IS

L_COMPLETELY_SAVED           BOOLEAN;

BEGIN

   
   
   
   
   
   

   L_SQLERRM := NULL;   
   L_COMPLETELY_SAVED := TRUE;
   IF NVL(A_NEXT_ROWS, 0) = 0 THEN
      IF NVL(P_CHGMESS_CALLS, 0) <> 0 THEN
         L_SQLERRM := 'ChangeScMeLsStatus termination call never called for previous method sheet ! (a_next_rows=-1)';
         RAISE STPERROR;
      END IF;
      P_CHGMESS_CALLS := 1;
   ELSIF NVL(A_NEXT_ROWS, 0) = -1 THEN
      P_CHGMESS_CALLS := NVL(P_CHGMESS_CALLS, 0) + 1;      
   ELSIF NVL(A_NEXT_ROWS, 0) = 1 THEN
      IF NVL(P_CHGMESS_CALLS, 0) = 0 THEN   
         L_SQLERRM := 'ChangeScMeLsStatus startup call never called ! (a_next_rows=0)';
         RAISE STPERROR;   
      END IF;
      IF NVL(UNAPIGEN.P_TXN_LEVEL, 0) <= 1 THEN   
         L_SQLERRM := 'ChangeScMeLsStatus called with a_next_rows=1 in a non MST transaction !';
         RAISE STPERROR;   
      END IF;
      P_CHGMESS_CALLS := NVL(P_CHGMESS_CALLS, 0) + 1;      
   ELSE
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NEXTROWS;
      RAISE STPERROR;
   END IF;         
   IF P_CHGMESS_CALLS = 1 THEN
      IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
      P_CHGMESS_TR_SEQ := UNAPIGEN.P_TR_SEQ;
   ELSE
      IF UNAPIGEN.P_TR_SEQ <> P_CHGMESS_TR_SEQ THEN
         L_SQLERRM := 'Successive calls of ChangeScMeLsStatus not in the same transaction !';
         RAISE STPERROR;   
      END IF;
   END IF;

   
   SAVEPOINT_UNILAB4;
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP

      L_RET_CODE := UNAPIMEP.CHANGESCMESTATUS(
                        A_SC(L_SEQ_NO),
                        A_PG(L_SEQ_NO),
                        A_PGNODE(L_SEQ_NO),
                        A_PA(L_SEQ_NO),
                        A_PANODE(L_SEQ_NO),
                        A_ME(L_SEQ_NO),
                        A_MENODE(L_SEQ_NO),
                        A_REANALYSIS(L_SEQ_NO),
                        A_OLD_SS,
                        A_NEW_SS,
                        A_LC,
                        A_LC_VERSION,
                        A_MODIFY_REASON);
                        
      A_MODIFY_FLAG(L_SEQ_NO) := L_RET_CODE;
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_COMPLETELY_SAVED := FALSE;
      END IF;
      SAVEPOINT_UNILAB4;
   
   END LOOP;
   
   
   IF NVL(A_NEXT_ROWS, 0) = -1 THEN
      
      P_CHGMESS_CALLS := 0;
      IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
   END IF;
   IF L_COMPLETELY_SAVED THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN(UNAPIGEN.DBERR_PARTIALSAVE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ChangeScMeLsStatus',SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('ChangeScMeLsStatus',L_SQLERRM);   
   END IF;
   P_CHGMESS_CALLS := 0;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ChangeScMeLsStatus'));
END CHANGESCMELSSTATUS;

FUNCTION CANCELSCMELS
(A_SC            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE        IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE        IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE        IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_REANALYSIS    IN     UNAPIGEN.NUM_TABLE_TYPE,   
 A_MODIFY_FLAG   OUT    UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS    IN     NUMBER,                    
 A_NEXT_ROWS     IN     NUMBER,                    
 A_MODIFY_REASON IN     VARCHAR2)                  
RETURN NUMBER IS

L_COMPLETELY_SAVED           BOOLEAN;
L_ME_REANALYSIS              NUMBER(3);

BEGIN

   
   
   
   
   
   
   L_SQLERRM := NULL;   
   L_COMPLETELY_SAVED := TRUE;
   IF NVL(A_NEXT_ROWS, 0) = 0 THEN
      IF NVL(P_CANCELMELS_CALLS, 0) <> 0 THEN
         L_SQLERRM := 'CancelScMeLs termination call never called for previous method sheet ! (a_next_rows=-1)';
         RAISE STPERROR;
      END IF;
      P_CANCELMELS_CALLS := 1;
   ELSIF NVL(A_NEXT_ROWS, 0) = -1 THEN
      P_CANCELMELS_CALLS := NVL(P_CANCELMELS_CALLS, 0) + 1;      
   ELSIF NVL(A_NEXT_ROWS, 0) = 1 THEN
      IF NVL(P_CANCELMELS_CALLS, 0) = 0 THEN   
         L_SQLERRM := 'CancelScMeLs startup call never called ! (a_next_rows=0)';
         RAISE STPERROR;   
      END IF;
      IF NVL(UNAPIGEN.P_TXN_LEVEL, 0) <= 1 THEN   
         L_SQLERRM := 'CancelScMeLs called with a_next_rows=1 in a non MST transaction !';
         RAISE STPERROR;   
      END IF;
      P_CANCELMELS_CALLS := NVL(P_CANCELMELS_CALLS, 0) + 1;      
   ELSE
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NEXTROWS;
      RAISE STPERROR;
   END IF;         
   IF P_CANCELMELS_CALLS = 1 THEN
      IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
      P_CANCELMELS_TR_SEQ := UNAPIGEN.P_TR_SEQ;
   ELSE
      IF UNAPIGEN.P_TR_SEQ <> P_CANCELMELS_TR_SEQ THEN
         L_SQLERRM := 'Successive calls of CancelScMeLs not in the same transaction !';
         RAISE STPERROR;   
      END IF;
   END IF;

   
   SAVEPOINT_UNILAB4;
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP

      
      
      SELECT REANALYSIS
      INTO L_ME_REANALYSIS
      FROM UTSCME
      WHERE SC = A_SC(L_SEQ_NO)
      AND PG = A_PG(L_SEQ_NO)
      AND PGNODE = A_PGNODE(L_SEQ_NO)
      AND PA = A_PA(L_SEQ_NO)
      AND PANODE = A_PANODE(L_SEQ_NO)
      AND ME = A_ME(L_SEQ_NO)
      AND MENODE = A_MENODE(L_SEQ_NO);
      
      L_RET_CODE := UNAPIMEP.CANCELSCME(
                        A_SC(L_SEQ_NO),
                        A_PG(L_SEQ_NO),
                        A_PGNODE(L_SEQ_NO),
                        A_PA(L_SEQ_NO),
                        A_PANODE(L_SEQ_NO),
                        A_ME(L_SEQ_NO),
                        A_MENODE(L_SEQ_NO),
                        L_ME_REANALYSIS,
                        A_MODIFY_REASON);
                        
      A_MODIFY_FLAG(L_SEQ_NO) := L_RET_CODE;
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_COMPLETELY_SAVED := FALSE;
      END IF;      
      SAVEPOINT_UNILAB4;
   
   END LOOP;
   
   
   IF NVL(A_NEXT_ROWS, 0) = -1 THEN
      
      P_CANCELMELS_CALLS := 0;
      IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
   END IF;
   IF L_COMPLETELY_SAVED THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN(UNAPIGEN.DBERR_PARTIALSAVE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CancelScMeLs',SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('CancelScMeLs',L_SQLERRM);   
   END IF;
   P_CANCELMELS_CALLS := 0;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CancelScMeLs'));
END CANCELSCMELS;

FUNCTION SCMELSELECTRONICSIGNATURE
(A_SC            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE        IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE        IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE        IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_REANALYSIS    IN     UNAPIGEN.NUM_TABLE_TYPE,   
 A_AUTHORISED_BY IN     VARCHAR2,                  
 A_MODIFY_FLAG   OUT    UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS    IN     NUMBER,                    
 A_NEXT_ROWS     IN     NUMBER,                    
 A_MODIFY_REASON IN     VARCHAR2)                  
RETURN NUMBER IS

L_COMPLETELY_SAVED           BOOLEAN;

BEGIN

   
   
   
   
   
   
   L_SQLERRM := NULL;   
   L_COMPLETELY_SAVED := TRUE;
   IF NVL(A_NEXT_ROWS, 0) = 0 THEN
      IF NVL(P_ELSIGNMELS_CALLS, 0) <> 0 THEN
         L_SQLERRM := 'ElecSignMeLs termination call never called for previous method sheet ! (a_next_rows=-1)';
         RAISE STPERROR;
      END IF;
      P_ELSIGNMELS_CALLS := 1;
   ELSIF NVL(A_NEXT_ROWS, 0) = -1 THEN
      P_ELSIGNMELS_CALLS := NVL(P_ELSIGNMELS_CALLS, 0) + 1;      
   ELSIF NVL(A_NEXT_ROWS, 0) = 1 THEN
      IF NVL(P_ELSIGNMELS_CALLS, 0) = 0 THEN   
         L_SQLERRM := 'ElecSignMeLs startup call never called ! (a_next_rows=0)';
         RAISE STPERROR;   
      END IF;
      IF NVL(UNAPIGEN.P_TXN_LEVEL, 0) <= 1 THEN   
         L_SQLERRM := 'ElecSignMeLs called with a_next_rows=1 in a non MST transaction !';
         RAISE STPERROR;   
      END IF;
      P_ELSIGNMELS_CALLS := NVL(P_ELSIGNMELS_CALLS, 0) + 1;      
   ELSE
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NEXTROWS;
      RAISE STPERROR;
   END IF;         
   IF P_ELSIGNMELS_CALLS = 1 THEN
      IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
      P_ELSIGNMELS_TR_SEQ := UNAPIGEN.P_TR_SEQ;
   ELSE
      IF UNAPIGEN.P_TR_SEQ <> P_ELSIGNMELS_TR_SEQ THEN
         L_SQLERRM := 'Successive calls of ElecSignMeLs not in the same transaction !';
         RAISE STPERROR;   
      END IF;
   END IF;

   
   SAVEPOINT_UNILAB4;
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP

      L_RET_CODE := UNAPIMEP.SCMEELECTRONICSIGNATURE(
                        A_SC(L_SEQ_NO),
                        A_PG(L_SEQ_NO),
                        A_PGNODE(L_SEQ_NO),
                        A_PA(L_SEQ_NO),
                        A_PANODE(L_SEQ_NO),
                        A_ME(L_SEQ_NO),
                        A_MENODE(L_SEQ_NO),
                        A_REANALYSIS(L_SEQ_NO),
                        A_AUTHORISED_BY,
                        A_MODIFY_REASON);
                        
      A_MODIFY_FLAG(L_SEQ_NO) := L_RET_CODE;
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_COMPLETELY_SAVED := FALSE;
      END IF;
      SAVEPOINT_UNILAB4;
   
   END LOOP;
   
   
   IF NVL(A_NEXT_ROWS, 0) = -1 THEN
      
      P_ELSIGNMELS_CALLS := 0;
      IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
   END IF;
   IF L_COMPLETELY_SAVED THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN(UNAPIGEN.DBERR_PARTIALSAVE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ElecSignMeLs',SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('ElecSignMeLs',L_SQLERRM);   
   END IF;
   P_ELSIGNMELS_CALLS := 0;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ElecSignMeLs'));
END SCMELSELECTRONICSIGNATURE;

BEGIN
   P_CLIENT_EVMGR_USED := NULL;
   
   OPEN C_SYSTEM('COPY_EST_COST');
   FETCH C_SYSTEM INTO P_COPY_EST_COST;
   IF C_SYSTEM%NOTFOUND THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'UNAPIMEP.Initilisation', 'missing system setting: COPY_EST_COST');
      UNAPIGEN.U4COMMIT;
      CLOSE C_SYSTEM;
   END IF;
   CLOSE C_SYSTEM;

   OPEN C_SYSTEM('COPY_EST_TIME');
   FETCH C_SYSTEM INTO P_COPY_EST_TIME;
   IF C_SYSTEM%NOTFOUND THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'UNAPIMEP.Initilisation', 'missing system setting: COPY_EST_TIME');
      UNAPIGEN.U4COMMIT;
      CLOSE C_SYSTEM;
   END IF;
   CLOSE C_SYSTEM;
END UNAPIMEP;
/
