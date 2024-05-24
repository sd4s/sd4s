CREATE OR REPLACE PACKAGE BODY unapime3 AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;
L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(10000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_TIMED_EVENT_TP  UTEV.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
L_EV_DETAILS      VARCHAR2(255);
STPERROR          EXCEPTION;

P_SAVESCMECL_INSERT_EVENT      BOOLEAN;
P_SAVESCMECL_CALLS             INTEGER;
P_SAVESCMECL_TR_SEQ            INTEGER;
P_SAVESCMECLVALUES_CALLS       INTEGER;
P_SAVESCMECLVALUES_TR_SEQ      INTEGER;

PA_EQ            UNAPIGEN.VC20_TABLE_TYPE;
PA_DBAPI_NAME    UNAPIGEN.VC20_TABLE_TYPE;
PA_EV_DETAILS    UNAPIGEN.VC255_TABLE_TYPE;

CURSOR C_SYSTEM (A_SETTING_NAME VARCHAR2) IS
   SELECT SETTING_VALUE
   FROM UTSYSTEM
   WHERE SETTING_NAME = A_SETTING_NAME;
P_COPY_EST_COST                VARCHAR2(255);
P_COPY_EST_TIME                VARCHAR2(255);
P_CLIENT_EVMGR_USED            VARCHAR2(3);

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;


PROCEDURE ADDEQ(A_EQ IN VARCHAR2, A_LAB IN VARCHAR2, A_EV_DETAILS IN VARCHAR2, A_API_NAME IN VARCHAR2) 
IS
L_FOUND    BOOLEAN;
   
BEGIN
   
   IF A_EQ<>'-' THEN
      
      L_FOUND := FALSE;
      FOR L_SEQ_NO IN 1..PA_EQ_NR_OF_ROWS LOOP
         IF PA_EQ(L_SEQ_NO) = A_EQ AND
            PA_EV_DETAILS(L_SEQ_NO) = 'lab='||A_LAB||'#'||A_EV_DETAILS THEN
            L_FOUND := TRUE;
            EXIT;
         END IF;
      END LOOP;

      IF NOT L_FOUND THEN
         PA_EQ_NR_OF_ROWS := NVL(PA_EQ_NR_OF_ROWS,0)+1;
         PA_EQ(PA_EQ_NR_OF_ROWS) := A_EQ;
         PA_EV_DETAILS(PA_EQ_NR_OF_ROWS) := 'lab='||A_LAB||'#'||A_EV_DETAILS;
         PA_DBAPI_NAME(PA_EQ_NR_OF_ROWS) := A_API_NAME;
      END IF;
   END IF;
END ADDEQ;

PROCEDURE INSERTEVENTSEQ 
IS

BEGIN
   FOR L_SEQ_NO IN 1..PA_EQ_NR_OF_ROWS LOOP
      L_EVENT_TP := 'EquipmentUsed';
      L_EV_SEQ_NR := -1;

      L_EV_DETAILS := PA_EV_DETAILS(L_SEQ_NO);
      L_RESULT := UNAPIEV.INSERTEVENT(PA_DBAPI_NAME(L_SEQ_NO), UNAPIGEN.P_EVMGR_NAME, 'eq', 
                                      PA_EQ(L_SEQ_NO), '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
   END LOOP;   
END INSERTEVENTSEQ;


FUNCTION EVALUATEEQUIPMENT
(A_EQ_TP        IN          VARCHAR2,        
 A_LAB          IN OUT      VARCHAR2,        
 A_EQ              OUT      VARCHAR2,        
 A_ERROR_MSG       OUT      VARCHAR2)        
RETURN NUMBER IS


CURSOR L_USEEQINLAB_CURSOR (A_EQ_TP VARCHAR2, A_LAB VARCHAR2) IS
   SELECT MAX(EQ.EQ), MAX(EQ.LAB)
   FROM UTEQ EQ, UTEQTYPE TP
   WHERE TP.EQ_TP = A_EQ_TP
   AND TP.EQ = EQ.EQ
   AND TP.VERSION = EQ.VERSION
   AND TP.LAB = EQ.LAB
   AND EQ.LAB = NVL(A_LAB, EQ.LAB)   
   HAVING COUNT(DISTINCT(EQ.EQ||'#'||EQ.LAB))=1;

BEGIN   
   
   
   
   
   
   
   IF UNAPIGEN.P_LAB IS NOT NULL THEN
      A_LAB := UNAPIGEN.P_LAB;
   END IF;
   IF A_EQ_TP IS NOT NULL THEN
      
      OPEN L_USEEQINLAB_CURSOR(A_EQ_TP, A_LAB);
      FETCH L_USEEQINLAB_CURSOR
      INTO A_EQ, A_LAB;
      CLOSE L_USEEQINLAB_CURSOR;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF L_USEEQINLAB_CURSOR%ISOPEN THEN
      CLOSE L_USEEQINLAB_CURSOR;
   END IF;
   A_ERROR_MSG := SUBSTR(SQLERRM, 1, 200);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END EVALUATEEQUIPMENT;

FUNCTION SAVESCMERESULT                               
(A_ALARMS_HANDLED   IN     CHAR,                      
 A_SC               IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG               IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE           IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA               IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE           IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME               IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE           IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_REANALYSIS       IN OUT UNAPIGEN.NUM_TABLE_TYPE,   
 A_VALUE_F          IN     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_VALUE_S          IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_UNIT             IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FORMAT           IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_EXEC_END_DATE    IN OUT UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXECUTOR         IN OUT UNAPIGEN.VC20_TABLE_TYPE,  
 A_LAB              IN OUT UNAPIGEN.VC20_TABLE_TYPE,  
 A_EQ               IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_EQ_VERSION       IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MANUALLY_ENTERED IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_REAL_COST        IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_REAL_TIME        IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_MODIFY_FLAG      IN OUT UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS       IN     NUMBER,                    
 A_MODIFY_REASON    IN     VARCHAR2)                  
RETURN NUMBER IS

L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_SS                     VARCHAR2(2);
L_LOG_HS                 CHAR(1);
L_LOG_HS_DETAILS         CHAR(1);
L_ALLOW_MODIFY           CHAR(1);
L_ACTIVE                 CHAR(1);
L_CURRENT_TIMESTAMP      TIMESTAMP WITH TIME ZONE;
L_SEQ_NO                 INTEGER;
L_EXEC_START_DATE        TIMESTAMP WITH TIME ZONE;
L_EXEC_START_DATE_TZ     TIMESTAMP WITH TIME ZONE;
L_VALUE_F                NUMBER;
L_VALUE_S                VARCHAR2(40);
L_UNIT                   VARCHAR2(20);
L_FORMAT                 VARCHAR2(40);
L_OLD_VALUE_F            NUMBER;
L_OLD_VALUE_S            VARCHAR2(40);
L_OLD_UNIT               VARCHAR2(20);
L_OLD_FORMAT             VARCHAR2(40);
L_CELL_VALUE_F           FLOAT;
L_CELL_VALUE_S           VARCHAR2(40);
L_CELL_UNIT              VARCHAR2(20);
L_CELL_FORMAT            VARCHAR2(40);
L_NEXT_CELL              VARCHAR2(20);
L_NR_RESULTS             NUMBER;
L_ME_RECORD_OK           BOOLEAN;
L_ME_HANDLED             BOOLEAN;
L_COMPLETELY_SAVED       BOOLEAN;
L_SCME_REC               UTSCME%ROWTYPE;
L_DATE_CURSOR            INTEGER;
L_DATE                   TIMESTAMP WITH TIME ZONE;
L_HS_DETAILS_SEQ_NR      INTEGER;
L_MT_VERSION             VARCHAR2(20);




   
CURSOR L_SCMECELLINPUT_CURSOR(A_SC IN VARCHAR2,
                              A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                              A_PA IN VARCHAR2, A_PANODE IN NUMBER,
                              A_ME IN VARCHAR2, A_MENODE IN NUMBER) IS
   
   
   SELECT '1' FIRSTUSE, B.PG, B.PGNODE, B.PA, B.PANODE, B.ME, B.MENODE, B.REANALYSIS, B.CELL, 
          B.FORMAT FORMAT, C.INPUT_TP, C.INPUT_SOURCE, C.INPUT_VERSION, C.INPUT_PG, 
          C.INPUT_PGNODE, C.INPUT_PP_VERSION, C.INPUT_PA, C.INPUT_PANODE, C.INPUT_PR_VERSION,
          C.INPUT_ME, C.INPUT_MENODE, C.INPUT_MT_VERSION, C.INPUT_REANALYSIS            
   FROM UTSCME A , UTSCMECELL B, UTSCMECELLINPUT C
   WHERE C.SC = A_SC
     AND C.INPUT_MENODE IS NULL 
     AND NVL(C.INPUT_PG, A_PG)  = A_PG
     AND NVL(C.INPUT_PA, A_PA)  = A_PA
     AND C.SC = A.SC
     AND C.PG = A.PG
     AND C.PGNODE = A.PGNODE
     AND C.PA = A.PA
     AND C.PANODE = A.PANODE
     AND C.ME = A.ME
     AND C.MENODE = A.MENODE
     AND C.INPUT_TP = 'mt'
     AND C.INPUT_ME = A_ME
     
     
     AND UNAPIAUT.SQLGETSCMEALLOWMODIFY(A.SC, A.PG, A.PGNODE, A.PA, A.PANODE, A.ME, A.MENODE, A.REANALYSIS) = '1'
     
     AND (A.EXEC_END_DATE IS NULL OR 
          (A.EXEC_END_DATE IS NOT NULL AND A.ALLOW_MODIFY='#')) 
     AND C.SC = B.SC
     AND C.PG = B.PG
     AND C.PGNODE = B.PGNODE
     AND C.PA = B.PA
     AND C.PANODE = B.PANODE
     AND C.ME = B.ME
     AND C.MENODE = B.MENODE
     AND C.CELL = B.CELL
   UNION
   
   SELECT '0' FIRSTUSE, B.PG, B.PGNODE, B.PA, B.PANODE, B.ME, B.MENODE, B.REANALYSIS, B.CELL, 
          B.FORMAT FORMAT, C.INPUT_TP, C.INPUT_SOURCE, C.INPUT_VERSION, C.INPUT_PG, 
          C.INPUT_PGNODE, C.INPUT_PP_VERSION, C.INPUT_PA, C.INPUT_PANODE, C.INPUT_PR_VERSION,
          C.INPUT_ME, C.INPUT_MENODE, C.INPUT_MT_VERSION, C.INPUT_REANALYSIS 
   FROM UTSCME A , UTSCMECELL B, UTSCMECELLINPUT C
   WHERE C.SC = A_SC
     AND C.INPUT_PG = A_PG
     AND C.INPUT_PGNODE = A_PGNODE
     AND C.INPUT_PA = A_PA
     AND C.INPUT_PANODE = A_PANODE
     AND C.INPUT_ME = A_ME
     AND C.INPUT_MENODE = A_MENODE     
     AND C.SC = A.SC
     AND C.PG = A.PG
     AND C.PGNODE = A.PGNODE
     AND C.PA = A.PA
     AND C.PANODE = A.PANODE
     AND C.ME = A.ME
     AND C.MENODE = A.MENODE
     AND C.INPUT_TP = 'mt'
     AND C.INPUT_ME = A_ME
     
     
     AND UNAPIAUT.SQLGETSCMEALLOWMODIFY(A.SC, A.PG, A.PGNODE, A.PA, A.PANODE, A.ME, A.MENODE, A.REANALYSIS) = '1'
     
     AND (A.EXEC_END_DATE IS NULL OR 
          (A.EXEC_END_DATE IS NOT NULL AND A.ALLOW_MODIFY='#')) 
     AND C.SC = B.SC
     AND C.PG = B.PG
     AND C.PGNODE = B.PGNODE
     AND C.PA = B.PA
     AND C.PANODE = B.PANODE
     AND C.ME = B.ME
     AND C.MENODE = B.MENODE
     AND C.CELL = B.CELL
  ORDER BY 1,3,5,7 DESC;

CURSOR L_SCME_COUNTRESULTS(A_SC IN VARCHAR2, 
                           A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                           A_PA IN VARCHAR2, A_PANODE IN NUMBER) IS
    SELECT NVL(COUNT(SC),0)
    FROM UTSCME 
    WHERE SC=A_SC
    AND PG = A_PG
    AND PGNODE = A_PGNODE
    AND PA = A_PA
    AND PANODE = A_PANODE
    AND NVL(ACTIVE, '1') = '1'
    AND NVL(SS, '@~') <> '@C'
    AND EXEC_END_DATE IS NOT NULL;
    
CURSOR L_SCMEOLD_CURSOR (A_SC IN VARCHAR2, 
                         A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                         A_PA IN VARCHAR2, A_PANODE IN NUMBER,
                         A_ME IN VARCHAR2, A_MENODE IN NUMBER)IS
   SELECT A.*
   FROM UDSCME A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE
     AND A.ME = A_ME
     AND A.MENODE = A_MENODE;
L_SCMEOLD_REC UDSCME%ROWTYPE;
L_SCMENEW_REC UDSCME%ROWTYPE;

CURSOR L_CELL_OLD_CURSOR(C_SC VARCHAR2, 
                         C_PG VARCHAR2, C_PGNODE NUMBER,
                         C_PA VARCHAR2, C_PANODE NUMBER,
                         C_ME VARCHAR2, C_MENODE NUMBER,
                         C_REANALYSIS NUMBER, C_CELL VARCHAR2) IS
   SELECT VALUE_F, VALUE_S, UNIT, FORMAT 
   FROM UTSCMECELL
   WHERE SC = C_SC
   AND PG = C_PG
   AND PGNODE = C_PGNODE
   AND PA = C_PA
   AND PANODE = C_PANODE
   AND ME = C_ME
   AND MENODE = C_MENODE
   AND REANALYSIS = C_REANALYSIS
   AND CELL = C_CELL;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   L_COMPLETELY_SAVED := TRUE;
   L_SQLERRM := NULL;
   L_HS_DETAILS_SEQ_NR := 0;
   
   IF NVL(A_ALARMS_HANDLED, UNAPIGEN.ALARMS_NOT_HANDLED) NOT IN 
      (UNAPIGEN.ALARMS_NOT_HANDLED, UNAPIGEN.ALARMS_PARTIALLY_HANDLED, UNAPIGEN.ALARMS_ALREADY_HANDLED) THEN
      L_SQLERRM := 'Invalid value for alarms_handled flag'||NVL(A_ALARMS_HANDLED, 'EMPTY');
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      L_ME_RECORD_OK := TRUE;          
      L_ME_HANDLED := TRUE;

      IF NVL(A_SC(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PG(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PGNODE(L_SEQ_NO), 0) = 0 OR
         NVL(A_PA(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PANODE(L_SEQ_NO), 0) = 0 OR
         NVL(A_ME(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_MENODE(L_SEQ_NO), 0) = 0 OR
         A_REANALYSIS(L_SEQ_NO) IS NULL THEN
         UNAPIGEN.P_TXN_ERROR  := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;

      ELSIF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_UPDATE THEN
         
         
         
         L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC(L_SEQ_NO),
                                                     A_PG(L_SEQ_NO),
                                                     A_PGNODE(L_SEQ_NO),
                                                     A_PA(L_SEQ_NO),
                                                     A_PANODE(L_SEQ_NO),
                                                     A_ME(L_SEQ_NO),
                                                     A_MENODE(L_SEQ_NO),
                                                     A_REANALYSIS(L_SEQ_NO),
                                                     L_MT_VERSION,
                                                     L_LC, L_LC_VERSION, L_SS, L_ALLOW_MODIFY,
                                                     L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
            L_RET_CODE <> UNAPIGEN.DBERR_NOTMODIFIABLE THEN
            A_MODIFY_FLAG(L_SEQ_NO) := L_RET_CODE;
            L_ME_RECORD_OK := FALSE;
         END IF;

      ELSIF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.DBERR_SUCCESS THEN
         
         
         
         L_ME_RECORD_OK := FALSE; 
         L_ME_HANDLED := FALSE;   

      ELSE
         
         
         
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INVALMODFLAG;
         RAISE STPERROR;

      END IF;

      
      
      
      IF NVL(A_MANUALLY_ENTERED(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
         UNAPIGEN.P_TXN_ERROR  := UNAPIGEN.DBERR_MANUALLY_ENTERED;
         RAISE STPERROR;
      END IF;

      IF L_ME_RECORD_OK THEN
         
         
         
         SELECT *
         INTO L_SCME_REC
         FROM UTSCME
         WHERE SC = A_SC(L_SEQ_NO)
           AND PG = A_PG(L_SEQ_NO)
           AND PGNODE = A_PGNODE(L_SEQ_NO)
           AND PA = A_PA(L_SEQ_NO)
           AND PANODE = A_PANODE(L_SEQ_NO)
           AND ME = A_ME(L_SEQ_NO)
           AND MENODE = A_MENODE(L_SEQ_NO);
         
         
         
         
         L_FORMAT := L_SCME_REC.FORMAT;
         IF A_FORMAT(L_SEQ_NO) IS NOT NULL THEN
            L_FORMAT := A_FORMAT(L_SEQ_NO);
         END IF;
         L_VALUE_F := A_VALUE_F(L_SEQ_NO);
         L_VALUE_S := A_VALUE_S(L_SEQ_NO);
         L_RET_CODE := UNAPIGEN.FORMATRESULT(L_VALUE_F, L_FORMAT, L_VALUE_S);
         
         
   
         
         
         
         
         
         IF L_VALUE_F IS NOT NULL THEN
            IF L_SCME_REC.PLAUS_LOW IS NOT NULL THEN
               IF L_VALUE_F < L_SCME_REC.PLAUS_LOW THEN
                  UNAPIGEN.P_TXN_ERROR  := UNAPIGEN.DBERR_PLAUSIBILITY;
                  RAISE STPERROR;
               END IF;
            END IF;
            IF L_SCME_REC.PLAUS_HIGH IS NOT NULL THEN
               IF L_VALUE_F > L_SCME_REC.PLAUS_HIGH THEN
                  UNAPIGEN.P_TXN_ERROR  := UNAPIGEN.DBERR_PLAUSIBILITY;
                  RAISE STPERROR;
               END IF;
            END IF;
         END IF;
   
         
         
         
         IF L_SCME_REC.EXEC_END_DATE IS NOT NULL THEN
            L_RET_CODE := UNAPIMEP.REANALSCMETHOD
                          (A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                           A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                           A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
                           A_REANALYSIS(L_SEQ_NO), A_MODIFY_REASON);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;
            END IF;
         END IF;
   
         
         
         
         OPEN L_SCMEOLD_CURSOR(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO),
                               A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO),
                               A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO),
                               A_MENODE(L_SEQ_NO));
         FETCH L_SCMEOLD_CURSOR
         INTO L_SCMEOLD_REC;
         CLOSE L_SCMEOLD_CURSOR;
         L_SCMENEW_REC := L_SCMEOLD_REC;
            
         
         
         
         L_EXEC_START_DATE         := NVL(L_SCME_REC.EXEC_START_DATE, L_CURRENT_TIMESTAMP);
         L_EXEC_START_DATE_TZ      := NVL(L_SCME_REC.EXEC_START_DATE_TZ, L_CURRENT_TIMESTAMP);
         A_EXEC_END_DATE(L_SEQ_NO) := NVL(A_EXEC_END_DATE(L_SEQ_NO), L_CURRENT_TIMESTAMP);
         A_EXECUTOR(L_SEQ_NO)      := NVL(A_EXECUTOR(L_SEQ_NO), UNAPIGEN.P_USER);
   
         UPDATE UTSCME
         SET VALUE_F          = L_VALUE_F,
             VALUE_S          = L_VALUE_S,
             UNIT             = A_UNIT(L_SEQ_NO),
             FORMAT           = L_FORMAT,
             EXEC_START_DATE  = L_EXEC_START_DATE,
             EXEC_START_DATE_TZ  = DECODE(L_EXEC_START_DATE_TZ, EXEC_START_DATE_TZ, EXEC_START_DATE_TZ, L_EXEC_START_DATE_TZ),
             EXEC_END_DATE    = A_EXEC_END_DATE(L_SEQ_NO),
             EXEC_END_DATE_TZ    = DECODE(A_EXEC_END_DATE(L_SEQ_NO), EXEC_END_DATE_TZ, EXEC_END_DATE_TZ, A_EXEC_END_DATE(L_SEQ_NO)),
             EXECUTOR         = A_EXECUTOR(L_SEQ_NO),
             LAB              = A_LAB(L_SEQ_NO),
             EQ               = A_EQ(L_SEQ_NO),
             EQ_VERSION       = A_EQ_VERSION(L_SEQ_NO),
             MANUALLY_ENTERED = A_MANUALLY_ENTERED(L_SEQ_NO),
             REAL_COST        = A_REAL_COST(L_SEQ_NO),
             REAL_TIME        = A_REAL_TIME(L_SEQ_NO),
             ALLOW_MODIFY     = '#',
             ACTIVE           = '1' 
                                    
          WHERE SC = A_SC(L_SEQ_NO)
            AND PG = A_PG(L_SEQ_NO)
            AND PGNODE = A_PGNODE(L_SEQ_NO)
            AND PA = A_PA(L_SEQ_NO)
            AND PANODE = A_PANODE(L_SEQ_NO)
            AND ME = A_ME(L_SEQ_NO)
            AND MENODE = A_MENODE(L_SEQ_NO)
          RETURNING VALUE_F, VALUE_S, UNIT, 
                    FORMAT, EXEC_START_DATE, EXEC_START_DATE_TZ, EXEC_END_DATE, EXEC_END_DATE_TZ, 
                    EXECUTOR, LAB, EQ, EQ_VERSION, 
                    MANUALLY_ENTERED, REAL_COST, REAL_TIME, 
                    ALLOW_MODIFY
          INTO L_SCMENEW_REC.VALUE_F, L_SCMENEW_REC.VALUE_S, L_SCMENEW_REC.UNIT, 
               L_SCMENEW_REC.FORMAT, L_SCMENEW_REC.EXEC_START_DATE, L_SCMENEW_REC.EXEC_START_DATE_TZ, 
          L_SCMENEW_REC.EXEC_END_DATE, L_SCMENEW_REC.EXEC_END_DATE_TZ,
               L_SCMENEW_REC.EXECUTOR, L_SCMENEW_REC.LAB, L_SCMENEW_REC.EQ, L_SCMENEW_REC.EQ_VERSION,
               L_SCMENEW_REC.MANUALLY_ENTERED, L_SCMENEW_REC.REAL_COST, L_SCMENEW_REC.REAL_TIME, 
               L_SCMENEW_REC.ALLOW_MODIFY;

         
         
         
          L_RET_CODE := UNAPIME2.UPDATELINKEDSCMECELL(
                          A_SC => A_SC(L_SEQ_NO),
                          A_PG => A_PG(L_SEQ_NO),
                          A_PGNODE => A_PGNODE(L_SEQ_NO),
                          A_PA => A_PA(L_SEQ_NO),
                          A_PANODE => A_PANODE(L_SEQ_NO),
                          A_ME => A_ME(L_SEQ_NO),
                          A_MENODE => A_MENODE(L_SEQ_NO),
                          A_ME_STD_PROPERTY => L_SCME_REC.MT_VERSION,
                          A_MT_VERSION => L_SCME_REC.MT_VERSION,
                          A_DESCRIPTION => L_SCME_REC.DESCRIPTION,
                          A_UNIT => L_SCME_REC.UNIT,
                          A_EXEC_START_DATE => L_SCME_REC.EXEC_START_DATE,
                          A_EXEC_END_DATE => L_SCME_REC.EXEC_END_DATE,
                          A_EXECUTOR => L_SCME_REC.EXECUTOR,
                          A_LAB => L_SCME_REC.LAB,
                          A_EQ => L_SCME_REC.EQ,
                          A_EQ_VERSION => L_SCME_REC.EQ_VERSION,
                          A_PLANNED_EXECUTOR => L_SCME_REC.PLANNED_EXECUTOR,
                          A_PLANNED_EQ => L_SCME_REC.PLANNED_EQ,
                          A_PLANNED_EQ_VERSION => L_SCME_REC.PLANNED_EQ_VERSION,
                          A_DELAY => L_SCME_REC.DELAY,
                          A_DELAY_UNIT => L_SCME_REC.DELAY_UNIT,
                          A_FORMAT => L_SCME_REC.FORMAT,
                          A_ACCURACY => L_SCME_REC.ACCURACY,
                          A_REAL_COST => L_SCME_REC.REAL_COST,
                          A_REAL_TIME => L_SCME_REC.REAL_TIME,
                          A_SOP => L_SCME_REC.SOP,
                          A_SOP_VERSION => L_SCME_REC.SOP_VERSION,
                          A_PLAUS_LOW => L_SCME_REC.PLAUS_LOW,
                          A_PLAUS_HIGH => L_SCME_REC.PLAUS_HIGH,
                          A_ME_CLASS => L_SCME_REC.ME_CLASS);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               L_SQLERRM := 'sc=' || A_SC(L_SEQ_NO) || '#pg=' || A_PG(L_SEQ_NO) ||
                  '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) ||
                  '#pa=' || A_PA(L_SEQ_NO) ||
                  '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                  '#me=' || A_ME(L_SEQ_NO) ||
                  '#menode=' || TO_CHAR(A_MENODE(L_SEQ_NO)) ||
                  '#UpdateLinkedScMeCell#ErrorCode=' || TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            END IF;                           

         
         
         
         OPEN L_SCME_COUNTRESULTS(A_SC(L_SEQ_NO),A_PG(L_SEQ_NO),A_PGNODE(L_SEQ_NO),
                                  A_PA(L_SEQ_NO),A_PANODE(L_SEQ_NO));
         FETCH L_SCME_COUNTRESULTS 
         INTO L_NR_RESULTS;
         CLOSE L_SCME_COUNTRESULTS;
      
         
         
         
         L_EV_SEQ_NR := -1;
         L_EVENT_TP := 'MeResultUpdated';
         L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                         '#pg=' || A_PG(L_SEQ_NO) ||
                         '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) ||
                         '#pa=' || A_PA(L_SEQ_NO) ||
                         '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                         '#menode=' || TO_CHAR(A_MENODE(L_SEQ_NO)) ||
                         '#reanalysis=' || TO_CHAR(A_REANALYSIS(L_SEQ_NO)) ||
                         '#alarms_handled=' || NVL(A_ALARMS_HANDLED, UNAPIGEN.ALARMS_NOT_HANDLED) ||
                         '#nr_results=' || TO_CHAR(L_NR_RESULTS) ||
                         '#mt_version=' || L_MT_VERSION;

         L_RESULT := UNAPIEV.INSERTEVENT('SaveScMeResult',
                                         UNAPIGEN.P_EVMGR_NAME, 'me', A_ME(L_SEQ_NO),
                                         L_LC, L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS,
                                         L_EV_SEQ_NR);
   
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
         END IF;

         
         
         
         IF L_LOG_HS = '1' THEN
            IF ( NVL((L_SCME_REC.VALUE_F <> L_VALUE_F), TRUE) AND NOT(L_SCME_REC.VALUE_F IS NULL AND L_VALUE_F IS NULL) ) OR
               ( NVL((L_SCME_REC.VALUE_S <> L_VALUE_S), TRUE) AND NOT(L_SCME_REC.VALUE_S IS NULL AND L_VALUE_S IS NULL) ) THEN 
               INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                                    WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
               VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                      A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO), 
                      UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                      'method "'||A_ME(L_SEQ_NO)||'" result is updated.',
                      L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
            END IF;   
         END IF;

         
         
         
         IF L_LOG_HS_DETAILS = '1' THEN
            UNAPIHSDETAILS.ADDSCMEHSDETAILS(L_SCMEOLD_REC, L_SCMENEW_REC,UNAPIGEN.P_TR_SEQ, 
                                            L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR);
         END IF;

         
         
         
         
         
         
         
         L_EVENT_TP := 'EvaluateMeDetails';
   
         FOR L_SCMECELLINPUT_REC IN
             L_SCMECELLINPUT_CURSOR(A_SC(L_SEQ_NO),
                                    A_PG(L_SEQ_NO),A_PGNODE(L_SEQ_NO),
                                    A_PA(L_SEQ_NO),A_PANODE(L_SEQ_NO),
                                    A_ME(L_SEQ_NO),A_MENODE(L_SEQ_NO)) LOOP
   
            IF L_SCMECELLINPUT_REC.FIRSTUSE = '0' THEN
               
               
               
               OPEN L_CELL_OLD_CURSOR(A_SC(L_SEQ_NO), 
                                      L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE,
                                      L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE,
                                      L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE,
                                      L_SCMECELLINPUT_REC.REANALYSIS, L_SCMECELLINPUT_REC.CELL);
               FETCH L_CELL_OLD_CURSOR INTO L_OLD_VALUE_F, L_OLD_VALUE_S, L_OLD_UNIT, L_OLD_FORMAT;
               IF L_CELL_OLD_CURSOR%NOTFOUND THEN
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
                  RAISE STPERROR;
               END IF;
               CLOSE L_CELL_OLD_CURSOR;

               
               
               
               L_CELL_UNIT := L_OLD_UNIT;
               L_CELL_FORMAT := L_OLD_FORMAT;
               L_RET_CODE := UNAPIGEN.TRANSFORMRESULT(L_VALUE_S,
                                                      L_VALUE_F,      
                                                      A_UNIT(L_SEQ_NO),
                                                      L_FORMAT,    
                                                      L_CELL_VALUE_S,    
                                                      L_CELL_VALUE_F,      
                                                      L_CELL_UNIT,    
                                                      L_CELL_FORMAT);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                  RAISE STPERROR;
               END IF;
               L_VALUE_S := L_CELL_VALUE_S;
               L_VALUE_F := L_CELL_VALUE_F;
               L_UNIT := L_CELL_UNIT;
               L_FORMAT := L_CELL_FORMAT;

               UPDATE UTSCMECELL
               SET VALUE_F = L_VALUE_F,
                   VALUE_S = L_VALUE_S,
                   UNIT = L_UNIT,
                   FORMAT = L_FORMAT
               WHERE SC = A_SC(L_SEQ_NO)
                 AND PG = L_SCMECELLINPUT_REC.PG
                 AND PGNODE = L_SCMECELLINPUT_REC.PGNODE
                 AND PA = L_SCMECELLINPUT_REC.PA
                 AND PANODE = L_SCMECELLINPUT_REC.PANODE
                 AND ME = L_SCMECELLINPUT_REC.ME
                 AND MENODE = L_SCMECELLINPUT_REC.MENODE
                 AND CELL = L_SCMECELLINPUT_REC.CELL;
               IF SQL%ROWCOUNT = 0 THEN
                  RAISE NO_DATA_FOUND;
               END IF;

               UPDATE UTSCMECELLINPUT
               SET INPUT_REANALYSIS = A_REANALYSIS(L_SEQ_NO)
               WHERE SC = A_SC(L_SEQ_NO)
                 AND PG = L_SCMECELLINPUT_REC.PG
                 AND PGNODE = L_SCMECELLINPUT_REC.PGNODE
                 AND PA = L_SCMECELLINPUT_REC.PA
                 AND PANODE = L_SCMECELLINPUT_REC.PANODE
                 AND ME = L_SCMECELLINPUT_REC.ME
                 AND MENODE = L_SCMECELLINPUT_REC.MENODE
                 AND CELL = L_SCMECELLINPUT_REC.CELL;

               L_EV_SEQ_NR := -1;
               L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) ||
                               '#pg=' || L_SCMECELLINPUT_REC.PG ||
                               '#pgnode=' || TO_CHAR(L_SCMECELLINPUT_REC.PGNODE) ||
                               '#pa=' || L_SCMECELLINPUT_REC.PA ||
                               '#panode=' || TO_CHAR(L_SCMECELLINPUT_REC.PANODE) ||
                               '#menode=' || TO_CHAR(L_SCMECELLINPUT_REC.MENODE) ||
                               '#cell=' || L_SCMECELLINPUT_REC.CELL ||
                               '#mt_version=' || L_MT_VERSION;

               L_RESULT := UNAPIEV.INSERTEVENT('SaveScMeResult',
                                               UNAPIGEN.P_EVMGR_NAME, 'me',
                                               L_SCMECELLINPUT_REC.ME, L_LC, L_LC_VERSION, L_SS,
                                               L_EVENT_TP, L_EV_DETAILS,
                                               L_EV_SEQ_NR);

               IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNAPIGEN.P_TXN_ERROR := L_RESULT;
                  RAISE STPERROR;
               END IF;

               
               
               
               IF L_LOG_HS_DETAILS = '1' THEN
                  IF NVL((L_OLD_VALUE_F <> L_VALUE_F), TRUE) AND 
                     NOT(L_OLD_VALUE_F IS NULL AND L_VALUE_F IS NULL)  THEN 
                     L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
                     INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                                 EV_SEQ, SEQ, DETAILS)
                     VALUES(A_SC(L_SEQ_NO), L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE, 
                            L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE, 
                            L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE, 
                            UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                            'method cell "'||L_SCMECELLINPUT_REC.CELL||'" is updated: property <value_f> changed value from "' || L_OLD_VALUE_F || '" to "' || L_VALUE_F || '".');
                  END IF;

                  IF NVL((L_OLD_VALUE_S <> L_VALUE_S), TRUE) AND 
                     NOT(L_OLD_VALUE_S IS NULL AND L_VALUE_S IS NULL)  THEN 
                     L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
                     INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                                 EV_SEQ, SEQ, DETAILS)
                     VALUES(A_SC(L_SEQ_NO), L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE, 
                            L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE, 
                            L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE, 
                            UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                            'method cell "'||L_SCMECELLINPUT_REC.CELL||'" is updated: property <value_s> changed value from "' || L_OLD_VALUE_S || '" to "' || L_VALUE_S || '".');
                  END IF;

                  IF NVL((L_OLD_UNIT <> L_UNIT), TRUE) AND 
                     NOT(L_OLD_UNIT IS NULL AND L_UNIT IS NULL)  THEN 
                     L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
                     INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                                 EV_SEQ, SEQ, DETAILS)
                     VALUES(A_SC(L_SEQ_NO), L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE, 
                            L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE, 
                            L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE, 
                            UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                            'method cell "'||L_SCMECELLINPUT_REC.CELL||'" is updated: property <unit> changed value from "' || L_OLD_UNIT || '" to "' || L_UNIT || '".');
                  END IF;

                  IF NVL((L_OLD_FORMAT <> L_FORMAT), TRUE) AND 
                     NOT(L_OLD_FORMAT IS NULL AND L_FORMAT IS NULL)  THEN 
                     L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
                     INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                                 EV_SEQ, SEQ, DETAILS)
                     VALUES(A_SC(L_SEQ_NO), L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE, 
                            L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE, 
                            L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE, 
                            UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                            'method cell "'||L_SCMECELLINPUT_REC.CELL||'" is updated: property <format> changed value from "' || L_OLD_FORMAT || '" to "' || L_FORMAT || '".');
                  END IF;
               END IF;
            ELSE
               
               L_RET_CODE := UNAPIME2.EVALUATEMECELLINPUT(A_SC(L_SEQ_NO), L_SCMECELLINPUT_REC.PG, 
                                L_SCMECELLINPUT_REC.PGNODE, L_SCMECELLINPUT_REC.PA, 
                                L_SCMECELLINPUT_REC.PANODE, L_SCMECELLINPUT_REC.ME, 
                                L_SCMECELLINPUT_REC.MENODE, L_SCMECELLINPUT_REC.REANALYSIS,
                                L_SCMECELLINPUT_REC.CELL, L_SCMECELLINPUT_REC.FORMAT, 
                                L_SCMECELLINPUT_REC.INPUT_TP, L_SCMECELLINPUT_REC.INPUT_SOURCE,
                                L_SCMECELLINPUT_REC.INPUT_VERSION,
                                L_SCMECELLINPUT_REC.INPUT_PG, L_SCMECELLINPUT_REC.INPUT_PGNODE,
                                L_SCMECELLINPUT_REC.INPUT_PP_VERSION,
                                L_SCMECELLINPUT_REC.INPUT_PA, L_SCMECELLINPUT_REC.INPUT_PANODE,
                                L_SCMECELLINPUT_REC.INPUT_PR_VERSION,
                                L_SCMECELLINPUT_REC.INPUT_ME, L_SCMECELLINPUT_REC.INPUT_MENODE,
                                L_SCMECELLINPUT_REC.INPUT_MT_VERSION,
                                A_REANALYSIS(L_SEQ_NO));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Warning#EvaluateMeCellInput returned ' || TO_CHAR(L_RET_CODE)||
                               '#cell=' || L_SCMECELLINPUT_REC.CELL ||
                               'sc=' || A_SC(L_SEQ_NO) || 
                               '#pg=' || L_SCMECELLINPUT_REC.PG || '#pgnode=' || TO_CHAR(L_SCMECELLINPUT_REC.PGNODE) ||
                               '#pa=' || L_SCMECELLINPUT_REC.PA || '#panode=' || TO_CHAR(L_SCMECELLINPUT_REC.PANODE) ||
                               '#me=' || L_SCMECELLINPUT_REC.ME || '#menode=' || TO_CHAR(L_SCMECELLINPUT_REC.MENODE);

                  UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                  RAISE STPERROR;
               END IF;
            
            END IF;
         END LOOP;

         
         
         
         OPEN UNAPIME.C_FIRST_EMPTY_CELL_CURSOR(A_SC(L_SEQ_NO), 
                           A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                           A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                           A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO));
         FETCH UNAPIME.C_FIRST_EMPTY_CELL_CURSOR INTO L_NEXT_CELL;
         IF UNAPIME.C_FIRST_EMPTY_CELL_CURSOR%NOTFOUND THEN
            L_NEXT_CELL := NULL;
         END IF;
         CLOSE UNAPIME.C_FIRST_EMPTY_CELL_CURSOR;

         UPDATE UTSCME
         SET NEXT_CELL = L_NEXT_CELL
         WHERE SC = A_SC(L_SEQ_NO) 
           AND PG = A_PG(L_SEQ_NO) AND PGNODE = A_PGNODE(L_SEQ_NO)
           AND PA = A_PA(L_SEQ_NO) AND PANODE = A_PANODE(L_SEQ_NO)
           AND ME = A_ME(L_SEQ_NO) AND MENODE = A_MENODE(L_SEQ_NO);

         
         
         
         IF L_LOG_HS_DETAILS = '1' THEN
            IF NVL((L_SCMEOLD_REC.NEXT_CELL <> L_NEXT_CELL), TRUE) AND 
               NOT(L_SCMEOLD_REC.NEXT_CELL IS NULL AND L_NEXT_CELL IS NULL)  THEN 
               L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                           EV_SEQ, SEQ, DETAILS)
               VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                      A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO), 
                      UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                      'method "'||A_ME(L_SEQ_NO)||'" is updated: property <next_cell> changed value from "' || L_SCMEOLD_REC.NEXT_CELL || '" to "' || L_NEXT_CELL || '".');
            END IF;
         END IF;

         
         
         
         IF A_EQ(L_SEQ_NO) IS NOT NULL THEN
            ADDEQ(A_EQ(L_SEQ_NO),
                  A_LAB(L_SEQ_NO),
                                  'sc=' || A_SC(L_SEQ_NO) ||
                                  '#pg=' || A_PG(L_SEQ_NO) || 
                                  '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) ||
                                  '#pa=' || A_PA(L_SEQ_NO) || 
                                  '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                                  '#me=' || A_ME(L_SEQ_NO) || 
                                  '#menode=' || TO_CHAR(A_MENODE(L_SEQ_NO)) ||
                                  '#mt_version=' || L_MT_VERSION ||
                                  
                                  '#version=' || UNVERSION.P_NO_VERSION,    
                                  
                  'SaveScMeResult');
         END IF;

         
         
         
      ELSE
         IF L_ME_HANDLED THEN
            L_COMPLETELY_SAVED := FALSE;
         END IF;
      END IF;
   END LOOP;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_MODIFY_FLAG(L_SEQ_NO) < UNAPIGEN.DBERR_SUCCESS THEN
         A_MODIFY_FLAG(L_SEQ_NO) := UNAPIGEN.DBERR_SUCCESS;
      END IF;
   END LOOP;
   
   IF L_COMPLETELY_SAVED THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN(UNAPIGEN.DBERR_PARTIALSAVE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveScMeResult',SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('SaveScMeResult',L_SQLERRM);   
   END IF;
   IF UNAPIME.C_FIRST_EMPTY_CELL_CURSOR%ISOPEN THEN
      CLOSE UNAPIME.C_FIRST_EMPTY_CELL_CURSOR;
   END IF;
   IF L_SCME_COUNTRESULTS%ISOPEN THEN
      CLOSE L_SCME_COUNTRESULTS;
   END IF;
   IF L_SCMEOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCMEOLD_CURSOR;
   END IF;
   IF L_CELL_OLD_CURSOR%ISOPEN THEN
      CLOSE L_CELL_OLD_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveScMeResult'));
END SAVESCMERESULT;
 
FUNCTION SAVESCMECELL                                  
(A_COMPLETED        IN     CHAR,                       
 A_SC               IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_PG               IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_PGNODE           IN     UNAPIGEN.LONG_TABLE_TYPE,   
 A_PA               IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_PANODE           IN     UNAPIGEN.LONG_TABLE_TYPE,   
 A_ME               IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_MENODE           IN     UNAPIGEN.LONG_TABLE_TYPE,   
 A_REANALYSIS       IN OUT UNAPIGEN.NUM_TABLE_TYPE,    
 A_CELL             IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_CELLNODE         IN     UNAPIGEN.LONG_TABLE_TYPE,   
 A_DSP_TITLE        IN     UNAPIGEN.VC40_TABLE_TYPE,   
 A_VALUE_F          IN     UNAPIGEN.FLOAT_TABLE_TYPE,  
 A_VALUE_S          IN     UNAPIGEN.VC40_TABLE_TYPE,   
 A_CELL_TP          IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_POS_X            IN     UNAPIGEN.NUM_TABLE_TYPE,    
 A_POS_Y            IN     UNAPIGEN.NUM_TABLE_TYPE,    
 A_ALIGN            IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_WINSIZE_X        IN     UNAPIGEN.NUM_TABLE_TYPE,    
 A_WINSIZE_Y        IN     UNAPIGEN.NUM_TABLE_TYPE,    
 A_IS_PROTECTED     IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_MANDATORY        IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_HIDDEN           IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_UNIT             IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_FORMAT           IN     UNAPIGEN.VC40_TABLE_TYPE,   
 A_EQ               IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_EQ_VERSION       IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_COMPONENT        IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_CALC_TP          IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_CALC_FORMULA     IN     UNAPIGEN.VC2000_TABLE_TYPE, 
 A_VALID_CF         IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_MAX_X            IN     UNAPIGEN.NUM_TABLE_TYPE,    
 A_MAX_Y            IN     UNAPIGEN.NUM_TABLE_TYPE,    
 A_MULTI_SELECT     IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_MODIFY_FLAG      IN OUT UNAPIGEN.NUM_TABLE_TYPE,    
 A_NR_OF_ROWS       IN     NUMBER,                     
 A_NEXT_ROWS        IN     NUMBER)                     
RETURN NUMBER IS

L_LC                                   VARCHAR2(2);
L_LC_VERSION                           VARCHAR2(20);
L_SS                                   VARCHAR2(2);
L_LOG_HS                               CHAR(1);
L_LOG_HS_DETAILS                       CHAR(1);
L_ALLOW_MODIFY                         CHAR(1);
L_ACTIVE                               CHAR(1);
L_CELL_RECORD_OK                       BOOLEAN_TABLE_TYPE;
L_CELL_HANDLED                         BOOLEAN;
L_COMPLETELY_SAVED                     BOOLEAN;
L_COMPLETED                            BOOLEAN;
L_COMPLETED_CHAR                       CHAR(1);
L_CONFIRM_COMPLETE                     CHAR(1);
L_CNT                                  INTEGER;
L_NEXT_CELL                            VARCHAR2(20);
L_OLD_NEXT_CELL                        VARCHAR2(20);
L_OLD_ME_EXEC_START_DATE               TIMESTAMP WITH TIME ZONE;
L_NEW_ME_EXEC_START_DATE               TIMESTAMP WITH TIME ZONE;
L_ME_EXEC_END_DATE                     TIMESTAMP WITH TIME ZONE;
L_PA_EXEC_END_DATE                     TIMESTAMP WITH TIME ZONE;
L_ME_REANALYSIS                        INTEGER;
L_PA_REANALYSIS                        INTEGER;
L_ALL_CELLS_COMPLETED                  BOOLEAN;
L_HS_DETAILS_SEQ_NR                    INTEGER;
L_MT_VERSION                           VARCHAR2(20);
L_HANDLE_OUTPUT                        BOOLEAN;
L_WS_CLASS                             CHAR(1);
L_LAB_FETCHED                          BOOLEAN;
L_LAB                                  VARCHAR2(20);
L_CURRENT_TIMESTAMP                    TIMESTAMP WITH TIME ZONE;


L_WT_VERSION                           VARCHAR2(20);
L_WS_LC                                VARCHAR2(2);
L_WS_LC_VERSION                        VARCHAR2(20);
L_WS_SS                                VARCHAR2(2);
L_WS_ALLOW_MODIFY                      CHAR(1);
L_WS_ACTIVE                            CHAR(1);
L_WS_LOG_HS                            CHAR(1);
L_WS_LOG_HS_DETAILS                    CHAR(1);

L_EQ_NESTEDTAB                         VC20_NESTEDTABLE_TYPE := VC20_NESTEDTABLE_TYPE();
L_INACTIVE_EQ_COUNT                    INTEGER;
CURR_ITEM                              INTEGER;

CURSOR L_ME_EXEC_END_DATE_CURSOR (A_SC VARCHAR2,
                        A_PG VARCHAR2, A_PGNODE NUMBER,
                        A_PA VARCHAR2, A_PANODE NUMBER,
                        A_ME VARCHAR2, A_MENODE NUMBER) IS
   SELECT EXEC_START_DATE, EXEC_END_DATE, REANALYSIS
   FROM UTSCME
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE;

CURSOR L_SCME_CURSOR (A_SC VARCHAR2,
                      A_PG VARCHAR2, A_PGNODE NUMBER,
                      A_PA VARCHAR2, A_PANODE NUMBER,
                      A_ME VARCHAR2, A_MENODE NUMBER) IS
   SELECT MT_VERSION, LOG_HS
   FROM UTSCME
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE;

CURSOR L_PA_EXEC_END_DATE_CURSOR (A_SC VARCHAR2,
                        A_PG VARCHAR2, A_PGNODE NUMBER,
                        A_PA VARCHAR2, A_PANODE NUMBER) IS
   SELECT EXEC_END_DATE, REANALYSIS
   FROM UTSCPA
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE;

CURSOR L_MECELLOUTPUT_CURSOR (A_SC VARCHAR2,
                              A_PG VARCHAR2, A_PGNODE NUMBER,
                              A_PA VARCHAR2, A_PANODE NUMBER,
                              A_ME VARCHAR2, A_MENODE NUMBER)  IS
   SELECT A.*, B.VALUE_F VALUE_F, B.VALUE_S VALUE_S, B.CELL_TP CELL_TP, B.HIDDEN HIDDEN
   FROM UTSCMECELLOUTPUT A, UTSCMECELL B
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE
     AND A.ME = A_ME
     AND A.MENODE = A_MENODE
     AND A.SC = B.SC
     AND A.PG = B.PG
     AND A.PGNODE = B.PGNODE
     AND A.PA = B.PA
     AND A.PANODE = B.PANODE
     AND A.ME = B.ME
     AND A.MENODE = B.MENODE
     AND A.CELL = B.CELL;

CURSOR L_MECELLLIST_L_CURSOR (A_SC VARCHAR2,
                        A_PG VARCHAR2, A_PGNODE NUMBER,
                        A_PA VARCHAR2, A_PANODE NUMBER,
                        A_ME VARCHAR2, A_MENODE NUMBER,
                        A_CELL VARCHAR2) IS
   SELECT VALUE_S, VALUE_F 
   FROM UTSCMECELLLIST
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE
   AND CELL = A_CELL
   AND SELECTED <> '0'
   ORDER BY INDEX_X, INDEX_Y;
L_MECELLLIST_L_REC   L_MECELLLIST_L_CURSOR%ROWTYPE;

CURSOR L_MECELLLIST_T_CURSOR (A_SC VARCHAR2,
                        A_PG VARCHAR2, A_PGNODE NUMBER,
                        A_PA VARCHAR2, A_PANODE NUMBER,
                        A_ME VARCHAR2, A_MENODE NUMBER,
                        A_CELL VARCHAR2) IS
   SELECT INDEX_Y,
          MAX(DECODE(INDEX_X, 0, VALUE_S)) OBJECT_ID,
          MAX(DECODE(INDEX_X, 1, VALUE_S)) VALUE_S,
          MAX(DECODE(INDEX_X, 1, VALUE_F)) VALUE_F
   FROM UTSCMECELLLIST
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE
   AND CELL = A_CELL
   AND INDEX_X IN (0,1)
   GROUP BY INDEX_Y
   HAVING (MAX(DECODE(INDEX_X, 1, VALUE_S))  IS NOT NULL
           OR MAX(DECODE(INDEX_X, 1, VALUE_F))  IS NOT NULL)
   ORDER BY INDEX_Y;
L_MECELLLIST_T_REC   L_MECELLLIST_T_CURSOR%ROWTYPE;

CURSOR L_SCMECELLOLD_CURSOR (A_SC IN VARCHAR2,   A_PG IN VARCHAR2, 
                             A_PGNODE IN NUMBER, A_PA IN VARCHAR2, 
                             A_PANODE IN NUMBER, A_ME IN VARCHAR2, 
                             A_MENODE IN NUMBER, A_CELL IN VARCHAR2) IS
   SELECT A.*
   FROM UTSCMECELL A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE
     AND A.ME = A_ME
     AND A.MENODE = A_MENODE
     AND A.CELL = A_CELL;
L_SCMECELLOLD_REC UTSCMECELL%ROWTYPE;
L_SCMECELLNEW_REC UTSCMECELL%ROWTYPE;

CURSOR L_WSME_CURSOR(C_SC VARCHAR2,
                     C_PG VARCHAR2, C_PGNODE NUMBER,
                     C_PA VARCHAR2, C_PANODE NUMBER,
                     C_ME VARCHAR2, C_MENODE NUMBER,
                     C_REANALYSIS NUMBER) IS
   SELECT DISTINCT WS
     FROM UTWSME
    WHERE SC         = C_SC
      AND PG         = C_PG
      AND PGNODE     = C_PGNODE
      AND PA         = C_PA
      AND PANODE     = C_PANODE
      AND ME         = C_ME
      AND MENODE     = C_MENODE
      AND REANALYSIS = C_REANALYSIS;

CURSOR L_WS_CLASS_CURSOR(C_WS VARCHAR2) IS
   SELECT WS_CLASS
     FROM UTWS
    WHERE WS = C_WS;
    
CURSOR L_SCMELAB_CURSOR (A_SC VARCHAR2,
                         A_PG VARCHAR2, A_PGNODE NUMBER,
                         A_PA VARCHAR2, A_PANODE NUMBER,
                         A_ME VARCHAR2, A_MENODE NUMBER) IS
   SELECT LAB
   FROM UTSCME
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE;

CURSOR L_SCMECOMPONENT_CURSOR (A_SC VARCHAR2,
                              A_PG VARCHAR2, A_PGNODE NUMBER,
                              A_PA VARCHAR2, A_PANODE NUMBER,
                              A_ME VARCHAR2, A_MENODE NUMBER)  IS
   SELECT COUNT(CELL)
   FROM UTSCMECELL A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE
     AND A.ME = A_ME
     AND A.MENODE = A_MENODE
     AND A.COMPONENT IS NOT NULL ;

L_SCMECOMPONENT_USED   INTEGER DEFAULT 0; 
L_SCMECALIBRATION      CHAR(1) ; 

BEGIN

   
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_COMPLETED, ' ') NOT IN ('0', '1', '2') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_COMPLETED;
      RAISE STPERROR;
   END IF;

   L_LAB_FETCHED := FALSE;
   L_SQLERRM := NULL;
   IF NVL(A_NEXT_ROWS, 0) = 0 THEN
      IF NVL(P_SAVESCMECL_CALLS, 0) <> 0 THEN
         L_SQLERRM := 'SaveScMeCell termination call never called for previous method sheet ! (a_next_rows=-1)';
         RAISE STPERROR;
      END IF;
      P_SAVESCMECL_CALLS := 1;
      P_SAVESCMECL_INSERT_EVENT := FALSE;
   ELSIF NVL(A_NEXT_ROWS, 0) = -1 THEN
      IF NVL(P_SAVESCMECL_CALLS, 0) = 0 THEN
         P_SAVESCMECL_INSERT_EVENT := FALSE;
      END IF;
      P_SAVESCMECL_CALLS := NVL(P_SAVESCMECL_CALLS, 0) + 1;      
   ELSIF NVL(A_NEXT_ROWS, 0) = 1 THEN
      IF NVL(P_SAVESCMECL_CALLS, 0) = 0 THEN   
         L_SQLERRM := 'SaveScMeCell startup call never called ! (a_next_rows=0)';
         RAISE STPERROR;   
      END IF;
      IF NVL(UNAPIGEN.P_TXN_LEVEL, 0) <= 1 THEN   
         L_SQLERRM := 'SaveScMeCell called with a_next_rows=1 in a non MST transaction !';
         RAISE STPERROR;   
      END IF;
      P_SAVESCMECL_CALLS := NVL(P_SAVESCMECL_CALLS, 0) + 1;      
   ELSE
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NEXTROWS;
      RAISE STPERROR;
   END IF;         
   IF P_SAVESCMECL_CALLS = 1 THEN
      P_SAVESCMECL_TR_SEQ := UNAPIGEN.P_TR_SEQ;
   ELSE
      IF UNAPIGEN.P_TR_SEQ <> P_SAVESCMECL_TR_SEQ THEN
         L_SQLERRM := 'Successive calls of SaveScMeCell not in the same transaction !';
         RAISE STPERROR;   
      END IF;
   END IF;
   
   
   
   
   IF UNAPIME.P_DONT_CHECK_IF_USED_EQ_ACTIVE = FALSE THEN 
      BEGIN
         CURR_ITEM := 1;
         WHILE CURR_ITEM <= A_NR_OF_ROWS LOOP
            IF ( A_MODIFY_FLAG(CURR_ITEM) NOT IN(UNAPIGEN.DBERR_SUCCESS, UNAPIGEN.MOD_FLAG_DELETE) ) AND
               ( NVL(A_EQ (CURR_ITEM), '-') <> '-' ) THEN 
               L_EQ_NESTEDTAB.EXTEND() ;
               L_EQ_NESTEDTAB(L_EQ_NESTEDTAB.COUNT) :=  A_EQ (CURR_ITEM);
            END IF ;
            CURR_ITEM := CURR_ITEM + 1;
         END LOOP;

         SELECT NVL(CALIBRATION, '0') 
         INTO L_SCMECALIBRATION
         FROM UTSCME
         WHERE SC = A_SC(1)
           AND PG = A_PG(1)
           AND PGNODE = A_PGNODE(1)
           AND PA = A_PA(1)
           AND PANODE = A_PANODE(1)
           AND ME = A_ME(1)
           AND MENODE = A_MENODE(1);

         
         SELECT COUNT(EQ)
         INTO L_INACTIVE_EQ_COUNT
         FROM UTEQ
         WHERE EQ IN (SELECT * FROM TABLE(CAST(L_EQ_NESTEDTAB AS VC20_NESTEDTABLE_TYPE)))
         AND NVL(ACTIVE, 0) = 0 ;

         IF ( L_INACTIVE_EQ_COUNT > 0 ) AND ( L_SCMECALIBRATION = '0' ) THEN
            L_SQLERRM := 'Equipment used is not active. An equipment in an inactive status indicates that the equipment can not be used to make any measurement. ' || 
                         'It has been put out-of-order manualy by someone or by the equipment management rules (out of calibration).';
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
            RAISE STPERROR;
         END IF;
      END ;
   END IF ;

   IF NVL(P_SAVESCMECL_CALLS, 0)= 1 THEN
      
      
      
      
      SELECT NVL(COUNT(SC), 0)
      INTO L_CNT
      FROM UTSCMECELL
      WHERE SC = A_SC(1)
        AND PG = A_PG(1)
        AND PGNODE = A_PGNODE(1)
        AND PA = A_PA(1)
        AND PANODE = A_PANODE(1)
        AND ME = A_ME(1)
        AND MENODE = A_MENODE(1);

      IF L_CNT = 0 THEN
         L_RET_CODE := UNAPIME2.CREATESCMEDETAILS(A_SC(1), A_PG(1), A_PGNODE(1),
                                                  A_PA(1), A_PANODE(1), A_ME(1), A_MENODE(1), A_REANALYSIS(1));
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END IF;
   END IF;
   
   
   
   
   L_COMPLETELY_SAVED := TRUE;
   L_HS_DETAILS_SEQ_NR := 0;
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP

      L_CELL_HANDLED := TRUE;
      L_CELL_RECORD_OK(L_SEQ_NO) := TRUE;
     
      IF NVL(A_SC(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PG(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PGNODE(L_SEQ_NO), 0) = 0 OR
         NVL(A_PA(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PANODE(L_SEQ_NO), 0) = 0 OR
         NVL(A_ME(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_MENODE(L_SEQ_NO), 0) = 0 OR
         A_REANALYSIS(L_SEQ_NO) IS NULL OR
         NVL(A_CELL(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_CELLNODE(L_SEQ_NO), 0) = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      ELSIF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_UPDATE,
                                        UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES) THEN

         IF NVL(A_IS_PROTECTED(L_SEQ_NO), ' ') NOT IN ('0','1','2','3','4','5','6','7','8','9') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_PROTECTED;
            RAISE STPERROR;
         END IF;

         IF NVL(A_MANDATORY(L_SEQ_NO), ' ') NOT IN ('2', '1','0') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MANDATORY;
            RAISE STPERROR;
         END IF;
   
         IF NVL(A_HIDDEN(L_SEQ_NO), ' ') NOT IN ('1','0') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_HIDDEN;
            RAISE STPERROR;
         END IF;
         IF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES THEN
            
            BEGIN
               SELECT REANALYSIS
               INTO A_REANALYSIS(L_SEQ_NO)
               FROM UTSCME
               WHERE SC = A_SC(L_SEQ_NO)
                 AND PG = A_PG(L_SEQ_NO)
                 AND PGNODE = A_PGNODE(L_SEQ_NO)
                 AND PA = A_PA(L_SEQ_NO)
                 AND PANODE = A_PANODE(L_SEQ_NO)
                 AND ME = A_ME(L_SEQ_NO)
                 AND MENODE = A_MENODE(L_SEQ_NO);
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NORECORDS;
               RAISE STPERROR;         
            END;
         END IF;
         
         
         
         
         L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC(L_SEQ_NO),
                                          A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                                          A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                                          A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
                                          A_REANALYSIS(L_SEQ_NO), L_MT_VERSION, 
                                          L_LC, L_LC_VERSION, L_SS, L_ALLOW_MODIFY, 
                                          L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            A_MODIFY_FLAG(L_SEQ_NO) := L_RET_CODE;
            L_CELL_RECORD_OK(L_SEQ_NO) := FALSE;

         END IF;

      ELSIF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.DBERR_SUCCESS THEN
         L_CELL_RECORD_OK(L_SEQ_NO) := FALSE;
         L_CELL_HANDLED := FALSE;
      ELSE
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INVALMODFLAG;
         RAISE STPERROR;         
      END IF;

      
      
      
      OPEN L_ME_EXEC_END_DATE_CURSOR 
          (A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
           A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO), 
           A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO));
      FETCH L_ME_EXEC_END_DATE_CURSOR INTO L_OLD_ME_EXEC_START_DATE, L_ME_EXEC_END_DATE, L_ME_REANALYSIS;
      IF L_ME_EXEC_END_DATE_CURSOR%NOTFOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         CLOSE L_ME_EXEC_END_DATE_CURSOR;
         RAISE STPERROR;
      END IF;
      CLOSE L_ME_EXEC_END_DATE_CURSOR;
      
      IF L_ME_EXEC_END_DATE IS NOT NULL THEN
         UNAPIME.P_CELLSAVED4ME := A_SC(L_SEQ_NO)||'#'|| A_PG(L_SEQ_NO)||'#'|| A_PGNODE(L_SEQ_NO)||'#'||
                           A_PA(L_SEQ_NO)||'#'|| A_PANODE(L_SEQ_NO)||'#'||
                           A_ME(L_SEQ_NO)||'#'|| A_MENODE(L_SEQ_NO);
         L_RET_CODE := UNAPIMEP.REANALSCMEFROMDETAILS
                       (A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                        A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                        A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
                        L_ME_REANALYSIS, 'SaveScMeCell');
         UNAPIME.P_CELLSAVED4ME := NULL;
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
         A_REANALYSIS(L_SEQ_NO) := L_ME_REANALYSIS;
      END IF;

      
      
      
      OPEN L_PA_EXEC_END_DATE_CURSOR (A_SC(L_SEQ_NO), 
                                      A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                                      A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO));
      FETCH L_PA_EXEC_END_DATE_CURSOR INTO L_PA_EXEC_END_DATE, L_PA_REANALYSIS;
      IF L_PA_EXEC_END_DATE_CURSOR%NOTFOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         CLOSE L_PA_EXEC_END_DATE_CURSOR;
         RAISE STPERROR;
      END IF;
      CLOSE L_PA_EXEC_END_DATE_CURSOR;
      
      IF L_PA_EXEC_END_DATE IS NOT NULL THEN
         UNAPIME.P_CELLSAVED4ME := A_SC(L_SEQ_NO)||'#'|| A_PG(L_SEQ_NO)||'#'|| A_PGNODE(L_SEQ_NO)||'#'||
                           A_PA(L_SEQ_NO)||'#'|| A_PANODE(L_SEQ_NO)||'#'||
                           A_ME(L_SEQ_NO)||'#'|| A_MENODE(L_SEQ_NO);
         L_RET_CODE := UNAPIMEP.REANALSCPAFROMDETAILS
                       (A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                        A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                        L_PA_REANALYSIS, 'SaveScMeCell');
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
         UNAPIME.P_CELLSAVED4ME := NULL;
      END IF;

      
      
      
      OPEN L_SCMECELLOLD_CURSOR(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO),
                                A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO),
                                A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO),
                                A_MENODE(L_SEQ_NO), A_CELL(L_SEQ_NO));
      FETCH L_SCMECELLOLD_CURSOR
      INTO L_SCMECELLOLD_REC;
      CLOSE L_SCMECELLOLD_CURSOR;
            
      IF L_CELL_RECORD_OK(L_SEQ_NO) THEN
         IF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_UPDATE THEN
            
            
            
            
            
            
            UPDATE UTSCMECELL
            SET DSP_TITLE    = A_DSP_TITLE(L_SEQ_NO),
                VALUE_F      = A_VALUE_F(L_SEQ_NO),
                VALUE_S      = A_VALUE_S(L_SEQ_NO),
                CELL_TP      = A_CELL_TP(L_SEQ_NO),
                POS_X        = A_POS_X(L_SEQ_NO),
                POS_Y        = A_POS_Y(L_SEQ_NO),
                ALIGN        = A_ALIGN(L_SEQ_NO),
                WINSIZE_X    = A_WINSIZE_X(L_SEQ_NO),
                WINSIZE_Y    = A_WINSIZE_Y(L_SEQ_NO),
                IS_PROTECTED = A_IS_PROTECTED(L_SEQ_NO),
                MANDATORY    = A_MANDATORY(L_SEQ_NO),
                HIDDEN       = A_HIDDEN(L_SEQ_NO),
                UNIT         = A_UNIT(L_SEQ_NO),
                FORMAT       = A_FORMAT(L_SEQ_NO),
                EQ           = A_EQ(L_SEQ_NO),
                EQ_VERSION   = A_EQ_VERSION(L_SEQ_NO),
                COMPONENT    = A_COMPONENT(L_SEQ_NO),
                CALC_TP      = A_CALC_TP(L_SEQ_NO),
                CALC_FORMULA = A_CALC_FORMULA(L_SEQ_NO),
                VALID_CF     = A_VALID_CF(L_SEQ_NO),
                MAX_X        = A_MAX_X(L_SEQ_NO),
                MAX_Y        = A_MAX_Y(L_SEQ_NO),
                MULTI_SELECT = A_MULTI_SELECT(L_SEQ_NO)
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO)
              AND CELL = A_CELL(L_SEQ_NO)
            RETURNING SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, CELLNODE, DSP_TITLE, 
                      VALUE_F, VALUE_S, CELL_TP, POS_X, POS_Y, ALIGN, WINSIZE_X, WINSIZE_Y, IS_PROTECTED, 
                      MANDATORY, HIDDEN, UNIT, FORMAT, EQ, EQ_VERSION, COMPONENT, CALC_TP, 
                      CALC_FORMULA, VALID_CF, MAX_X, MAX_Y, MULTI_SELECT
            INTO L_SCMECELLNEW_REC.SC, L_SCMECELLNEW_REC.PG, L_SCMECELLNEW_REC.PGNODE, L_SCMECELLNEW_REC.PA, 
                 L_SCMECELLNEW_REC.PANODE, L_SCMECELLNEW_REC.ME, L_SCMECELLNEW_REC.MENODE, 
                 L_SCMECELLNEW_REC.REANALYSIS, L_SCMECELLNEW_REC.CELL, L_SCMECELLNEW_REC.CELLNODE, 
                 L_SCMECELLNEW_REC.DSP_TITLE, L_SCMECELLNEW_REC.VALUE_F, L_SCMECELLNEW_REC.VALUE_S, 
                 L_SCMECELLNEW_REC.CELL_TP, L_SCMECELLNEW_REC.POS_X, L_SCMECELLNEW_REC.POS_Y, 
                 L_SCMECELLNEW_REC.ALIGN, L_SCMECELLNEW_REC.WINSIZE_X, L_SCMECELLNEW_REC.WINSIZE_Y, 
                 L_SCMECELLNEW_REC.IS_PROTECTED, L_SCMECELLNEW_REC.MANDATORY, L_SCMECELLNEW_REC.HIDDEN, 
                 L_SCMECELLNEW_REC.UNIT, L_SCMECELLNEW_REC.FORMAT, L_SCMECELLNEW_REC.EQ, 
                 L_SCMECELLNEW_REC.EQ_VERSION, L_SCMECELLNEW_REC.COMPONENT, 
                 L_SCMECELLNEW_REC.CALC_TP, L_SCMECELLNEW_REC.CALC_FORMULA, 
                 L_SCMECELLNEW_REC.VALID_CF, L_SCMECELLNEW_REC.MAX_X, L_SCMECELLNEW_REC.MAX_Y, 
                 L_SCMECELLNEW_REC.MULTI_SELECT;

            IF SQL%ROWCOUNT=0 THEN
                UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
                RAISE STPERROR;
            END IF;

            IF L_LOG_HS_DETAILS = '1' THEN
               L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
                        IF L_RET_CODE <> 0 THEN
                           UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                           RAISE STPERROR;
                        END IF;

               UNAPIHSDETAILS.ADDSCMECELLHSDETAILS(L_SCMECELLOLD_REC, L_SCMECELLNEW_REC,UNAPIGEN.P_TR_SEQ, 
                                                   L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR);
            END IF;
         ELSIF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES THEN
            
            
            
            
            
            
            
            
            INSERT INTO UTSCMECELL
            (SC, PG, PGNODE, 
             PA, PANODE, ME, MENODE,
             REANALYSIS, CELL, CELLNODE,
             DSP_TITLE, VALUE_F, VALUE_S, CELL_TP, 
             POS_X, POS_Y, ALIGN, WINSIZE_X, WINSIZE_Y,
             IS_PROTECTED, MANDATORY, HIDDEN, UNIT,
             FORMAT, EQ, EQ_VERSION, COMPONENT, CALC_TP, 
             CALC_FORMULA, VALID_CF, MAX_X, MAX_Y, MULTI_SELECT)
            VALUES            
            (A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), 
             A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
             A_REANALYSIS(L_SEQ_NO), A_CELL(L_SEQ_NO), A_CELLNODE(L_SEQ_NO),
             A_DSP_TITLE(L_SEQ_NO), A_VALUE_F(L_SEQ_NO), A_VALUE_S(L_SEQ_NO), A_CELL_TP(L_SEQ_NO),
             A_POS_X(L_SEQ_NO), A_POS_Y(L_SEQ_NO), A_ALIGN(L_SEQ_NO), A_WINSIZE_X(L_SEQ_NO), A_WINSIZE_Y(L_SEQ_NO),
             A_IS_PROTECTED(L_SEQ_NO), A_MANDATORY(L_SEQ_NO), A_HIDDEN(L_SEQ_NO), A_UNIT(L_SEQ_NO), 
             A_FORMAT(L_SEQ_NO), A_EQ(L_SEQ_NO), A_EQ_VERSION(L_SEQ_NO), A_COMPONENT(L_SEQ_NO), A_CALC_TP(L_SEQ_NO),
             A_CALC_FORMULA(L_SEQ_NO), A_VALID_CF(L_SEQ_NO), A_MAX_X(L_SEQ_NO), A_MAX_Y(L_SEQ_NO), A_MULTI_SELECT(L_SEQ_NO));

            IF L_LOG_HS_DETAILS = '1' THEN
               L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
               IF L_RET_CODE <> 0 THEN
                  UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                  RAISE STPERROR;
               END IF;

               L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                           EV_SEQ, SEQ, DETAILS)
               VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                      A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO), 
                      UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                      'method "'||A_ME(L_SEQ_NO)||'" is updated: the cell "' || A_CELL(L_SEQ_NO) || '" is added.');
            END IF;
         
         END IF;
         
         
         
         IF L_OLD_ME_EXEC_START_DATE IS NULL THEN
            UPDATE UTSCME
            SET EXEC_START_DATE = L_CURRENT_TIMESTAMP,
                EXEC_START_DATE_TZ = L_CURRENT_TIMESTAMP
            WHERE SC = A_SC(L_SEQ_NO) 
              AND PG = A_PG(L_SEQ_NO) AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO) AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO) AND MENODE = A_MENODE(L_SEQ_NO)
              AND EXEC_START_DATE IS NULL
            RETURNING EXEC_START_DATE
            INTO L_NEW_ME_EXEC_START_DATE;
            IF SQL%ROWCOUNT > 0 THEN
               
               
               
               IF L_LOG_HS_DETAILS = '1' THEN
                  IF L_EV_SEQ_NR IS NULL THEN
                     L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
                     IF L_RET_CODE <> 0 THEN
                        UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                        RAISE STPERROR;
                     END IF;
                  END IF;
                  IF NVL((L_OLD_ME_EXEC_START_DATE <> L_NEW_ME_EXEC_START_DATE), TRUE) AND 
                     NOT(L_OLD_ME_EXEC_START_DATE IS NULL AND L_NEW_ME_EXEC_START_DATE IS NULL)  THEN 
                     L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
                     INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                                 EV_SEQ, SEQ, DETAILS)
                     VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                            A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO), 
                            UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                            'method "'||A_ME(L_SEQ_NO)||'" is updated: property <exec_start_date> changed value from "' ||
                            TO_CHAR(L_OLD_ME_EXEC_START_DATE, UNAPIGEN.P_JOBS_DATE_FORMAT) || '" to "' ||
                            TO_CHAR(L_NEW_ME_EXEC_START_DATE, UNAPIGEN.P_JOBS_DATE_FORMAT) || '".');
                  END IF;
               END IF;
            END IF;
         END IF;
         
         
         
         
         IF NVL(A_NEXT_ROWS, 0) = -1 THEN
            
            
            
            SELECT NEXT_CELL
            INTO L_OLD_NEXT_CELL
            FROM UTSCME
            WHERE SC = A_SC(L_SEQ_NO) 
              AND PG = A_PG(L_SEQ_NO) AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO) AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO) AND MENODE = A_MENODE(L_SEQ_NO);
         
            OPEN UNAPIME.C_FIRST_EMPTY_CELL_CURSOR(A_SC(L_SEQ_NO), 
                              A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                              A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                              A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO));
            FETCH UNAPIME.C_FIRST_EMPTY_CELL_CURSOR INTO L_NEXT_CELL;
            IF UNAPIME.C_FIRST_EMPTY_CELL_CURSOR%NOTFOUND THEN
               L_NEXT_CELL := NULL;
            END IF;
            CLOSE UNAPIME.C_FIRST_EMPTY_CELL_CURSOR;

            UPDATE UTSCME
            SET NEXT_CELL = L_NEXT_CELL
            WHERE SC = A_SC(L_SEQ_NO) 
              AND PG = A_PG(L_SEQ_NO) AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO) AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO) AND MENODE = A_MENODE(L_SEQ_NO);

            
            
            
            IF L_LOG_HS_DETAILS = '1' THEN
               IF NVL((L_OLD_NEXT_CELL <> L_NEXT_CELL), TRUE) AND 
                  NOT(L_OLD_NEXT_CELL IS NULL AND L_NEXT_CELL IS NULL)  THEN 
                  L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
                  INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                              EV_SEQ, SEQ, DETAILS)
                  VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                         A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO), 
                         UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                         'method "'||A_ME(L_SEQ_NO)||'" is updated: property <next_cell> changed value from "' || L_OLD_NEXT_CELL || '" to "' || L_NEXT_CELL || '".');
               END IF;
            END IF;

            P_SAVESCMECL_INSERT_EVENT := TRUE;
         END IF;  
         
         
         
         
         IF A_EQ(L_SEQ_NO) IS NOT NULL THEN
            
            IF L_LAB_FETCHED = FALSE THEN
               OPEN L_SCMELAB_CURSOR(A_SC(L_SEQ_NO), 
                                     A_PG(L_SEQ_NO),  A_PGNODE(L_SEQ_NO),
                                     A_PA(L_SEQ_NO),  A_PANODE(L_SEQ_NO),
                                     A_ME(L_SEQ_NO),  A_MENODE(L_SEQ_NO));
               FETCH L_SCMELAB_CURSOR
               INTO L_LAB;
               CLOSE L_SCMELAB_CURSOR;
               L_LAB_FETCHED := TRUE;
            END IF;
         
            ADDEQ(A_EQ(L_SEQ_NO), L_LAB,
                                  'sc=' || A_SC(L_SEQ_NO) ||
                                  '#pg=' || A_PG(L_SEQ_NO) || 
                                  '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) ||
                                  '#pa=' || A_PA(L_SEQ_NO) || 
                                  '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                                  '#me=' || A_ME(L_SEQ_NO) || 
                                  '#menode=' || TO_CHAR(A_MENODE(L_SEQ_NO)) ||
                                  '#mt_version=' || L_MT_VERSION ||
                                  
                                  '#version=' || UNVERSION.P_NO_VERSION,    
                                  
                  'SaveScMeCell');
         END IF;
      ELSE
         IF L_CELL_HANDLED THEN
            L_COMPLETELY_SAVED := FALSE;
         END IF;
      END IF;
   END LOOP;
   
   
   

   L_COMPLETED := FALSE;

   
   IF NVL(A_NEXT_ROWS, 0) = -1 THEN

      
      IF A_COMPLETED = '1' THEN
         L_COMPLETED := TRUE;
      ELSE
         SELECT CONFIRM_COMPLETE
         INTO L_CONFIRM_COMPLETE
         FROM UTSCME
         WHERE SC = A_SC(1)
           AND PG = A_PG(1)
           AND PGNODE = A_PGNODE(1)
           AND PA = A_PA(1)
           AND PANODE = A_PANODE(1)
           AND ME = A_ME(1)
           AND MENODE = A_MENODE(1);
           
         
         
         
         
         
         
         
         
         
         
         
         
         IF L_CONFIRM_COMPLETE = '0' THEN
            L_HANDLE_OUTPUT := TRUE;

            FOR L_WSME_REC IN L_WSME_CURSOR(A_SC(1), A_PG(1), A_PGNODE(1), A_PA(1), A_PANODE(1), 
                                            A_ME(1), A_MENODE(1), A_REANALYSIS(1)) LOOP
               L_RET_CODE := UNAPIAUT.GETWSAUTHORISATION
                               (L_WSME_REC.WS, L_WT_VERSION, L_WS_LC, L_WS_LC_VERSION, L_WS_SS,
                                L_WS_ALLOW_MODIFY, L_WS_ACTIVE, L_WS_LOG_HS, L_WS_LOG_HS_DETAILS);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'GetWsAuthorisation returned '||L_RET_CODE||'#ws='||L_WSME_REC.WS;
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
                  RAISE STPERROR;
               END IF;

               IF L_WS_ALLOW_MODIFY = '1' THEN
                  OPEN L_WS_CLASS_CURSOR(L_WSME_REC.WS);
                  FETCH L_WS_CLASS_CURSOR 
                  INTO L_WS_CLASS;
                  IF NVL(L_WS_CLASS, '0') NOT IN ('1', '2') THEN
                     L_HANDLE_OUTPUT := FALSE;
                     CLOSE L_WS_CLASS_CURSOR;
                     EXIT;
                  END IF;
                  CLOSE L_WS_CLASS_CURSOR;
               END IF;
            END LOOP;

            IF L_HANDLE_OUTPUT THEN
               FOR L_MECELLOUTPUT_REC IN L_MECELLOUTPUT_CURSOR(A_SC(1), A_PG(1), A_PGNODE(1), 
                                                               A_PA(1), A_PANODE(1), A_ME(1), A_MENODE(1)) LOOP
                  L_ALL_CELLS_COMPLETED := TRUE;
                  IF L_MECELLOUTPUT_REC.CELL_TP NOT IN ('T', 'L') THEN
                     IF L_MECELLOUTPUT_REC.VALUE_F IS NULL AND L_MECELLOUTPUT_REC.VALUE_S IS NULL 
                        AND L_MECELLOUTPUT_REC.HIDDEN = '0' THEN
                        L_ALL_CELLS_COMPLETED := FALSE;
                        EXIT;
                     END IF;
                  ELSIF L_MECELLOUTPUT_REC.CELL_TP = 'L' THEN
                     OPEN L_MECELLLIST_L_CURSOR(A_SC(1), A_PG(1), A_PGNODE(1),  A_PA(1), A_PANODE(1), 
                                                A_ME(1), A_MENODE(1), L_MECELLOUTPUT_REC.CELL);
                     FETCH L_MECELLLIST_L_CURSOR
                     INTO L_MECELLLIST_L_REC;
                     IF L_MECELLLIST_L_CURSOR%NOTFOUND AND L_MECELLOUTPUT_REC.HIDDEN = '0' THEN
                        L_ALL_CELLS_COMPLETED := FALSE;
                        CLOSE L_MECELLLIST_L_CURSOR;
                        EXIT;
                     END IF;
                     CLOSE L_MECELLLIST_L_CURSOR;
                  ELSIF L_MECELLOUTPUT_REC.CELL_TP = 'T' THEN
                     OPEN L_MECELLLIST_T_CURSOR(A_SC(1), A_PG(1), A_PGNODE(1),  A_PA(1), A_PANODE(1), 
                                                A_ME(1), A_MENODE(1), L_MECELLOUTPUT_REC.CELL);
                     FETCH L_MECELLLIST_T_CURSOR
                     INTO L_MECELLLIST_T_REC;
                     IF L_MECELLLIST_T_CURSOR%NOTFOUND AND L_MECELLOUTPUT_REC.HIDDEN = '0' THEN
                        L_ALL_CELLS_COMPLETED := FALSE;
                        CLOSE L_MECELLLIST_T_CURSOR;
                        EXIT;
                     END IF;
                     CLOSE L_MECELLLIST_T_CURSOR;
                  END IF;
               END LOOP;

               IF L_ALL_CELLS_COMPLETED THEN
                  
                  L_COMPLETED := TRUE;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   
   IF L_COMPLETED THEN
   
      IF P_CLIENT_EVMGR_USED='YES' THEN 
         OPEN L_SCMECOMPONENT_CURSOR (A_SC(1), A_PG(1), A_PGNODE(1), A_PA(1), A_PANODE(1), A_ME(1), A_MENODE(1));
         FETCH L_SCMECOMPONENT_CURSOR
         INTO L_SCMECOMPONENT_USED;
         CLOSE L_SCMECOMPONENT_CURSOR;
      END IF ;
     
     IF ( L_SCMECOMPONENT_USED <> 0 ) THEN
        
       
        L_COMPLETED := FALSE;
     END IF ;

      IF NOT (A_COMPLETED = '0' AND P_CLIENT_EVMGR_USED='YES' AND L_SCMECOMPONENT_USED <> 0) THEN
         
         
         
         
         
         
         
         
         L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC(1),
                                                     A_PG(1), A_PGNODE(1),
                                                     A_PA(1), A_PANODE(1),
                                                     A_ME(1), A_MENODE(1), A_REANALYSIS(1), L_MT_VERSION, 
                                         L_LC, L_LC_VERSION, L_SS, L_ALLOW_MODIFY, 
                                         L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
   
         
         
         
         L_RET_CODE := UNAPIME5.HANDLESCMECELLOUTPUT(A_SC(1),
                                                     A_PG(1), A_PGNODE(1),
                                                     A_PA(1), A_PANODE(1),
                                                     A_ME(1), A_MENODE(1), A_REANALYSIS(1));
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END IF;
   END IF;

   IF NVL(A_NEXT_ROWS, 0) = -1 THEN
      OPEN L_SCME_CURSOR(A_SC(1), A_PG(1), A_PGNODE(1), A_PA(1), A_PANODE(1), A_ME(1), A_MENODE(1));
      FETCH L_SCME_CURSOR INTO L_MT_VERSION, L_LOG_HS;
      IF L_SCME_CURSOR%NOTFOUND THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         CLOSE L_SCME_CURSOR;
         RAISE STPERROR;
      END IF;
      CLOSE L_SCME_CURSOR;

      L_EVENT_TP := 'MeDetailsUpdated';
      L_EV_SEQ_NR := -1;
      IF L_COMPLETED THEN
         L_COMPLETED_CHAR := '1';
      ELSE
         L_COMPLETED_CHAR := '0';
      END IF;
      
      L_EV_DETAILS := 'sc=' || A_SC(1) ||
                      '#pg=' || A_PG(1) || 
                      '#pgnode=' || TO_CHAR(A_PGNODE(1)) ||
                      '#pa=' || A_PA(1) || 
                      '#panode=' || TO_CHAR(A_PANODE(1)) ||
                      '#menode=' || TO_CHAR(A_MENODE(1)) ||
                      '#completed=' || L_COMPLETED_CHAR ||
                      '#mt_version=' || L_MT_VERSION||
                      '#a_completed_arg='||A_COMPLETED; 
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
      L_RESULT := UNAPIEV.INSERTEVENT('SaveScMeCell', UNAPIGEN.P_EVMGR_NAME,
                                      'me', A_ME(1), L_LC, L_LC_VERSION, L_SS,
                                      L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
      
      IF L_LOG_HS = '1' THEN
      
         INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, WHAT, 
                              WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC(1), A_PG(1), A_PGNODE(1), A_PA(1), A_PANODE(1), A_ME(1), A_MENODE(1), 
                UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'method "'||A_ME(1)||'" cells are updated.',
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;

   END IF;

   
   IF NVL(A_NEXT_ROWS, 0) = -1 THEN
      
      P_SAVESCMECL_CALLS := 0;
      P_SAVESCMECL_INSERT_EVENT := FALSE;
   END IF;
      
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_MODIFY_FLAG(L_SEQ_NO) < UNAPIGEN.DBERR_SUCCESS THEN
         A_MODIFY_FLAG(L_SEQ_NO) := UNAPIGEN.DBERR_SUCCESS;
      END IF;
   END LOOP;

   IF L_COMPLETELY_SAVED THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN(UNAPIGEN.DBERR_PARTIALSAVE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveScMeCell',SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('SaveScMeCell',L_SQLERRM);   
   END IF;
   IF UNAPIME.C_FIRST_EMPTY_CELL_CURSOR%ISOPEN THEN
      CLOSE UNAPIME.C_FIRST_EMPTY_CELL_CURSOR;
   END IF;
   IF L_MECELLLIST_L_CURSOR%ISOPEN THEN
      CLOSE L_MECELLLIST_L_CURSOR;
   END IF;
   IF L_MECELLLIST_T_CURSOR%ISOPEN THEN
      CLOSE L_MECELLLIST_T_CURSOR;
   END IF;
   IF L_SCMECELLOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCMECELLOLD_CURSOR;
   END IF;
   IF L_WSME_CURSOR%ISOPEN THEN
      CLOSE L_WSME_CURSOR;
   END IF;
   IF L_WS_CLASS_CURSOR%ISOPEN THEN
      CLOSE L_WS_CLASS_CURSOR;
   END IF;
   IF L_ME_EXEC_END_DATE_CURSOR%ISOPEN THEN
      CLOSE L_ME_EXEC_END_DATE_CURSOR;
   END IF;
   IF L_SCME_CURSOR%ISOPEN THEN
      CLOSE L_SCME_CURSOR;
   END IF;
   IF L_SCMELAB_CURSOR%ISOPEN THEN
      CLOSE L_SCMELAB_CURSOR;
   END IF;
   P_SAVESCMECL_INSERT_EVENT := FALSE;
   P_SAVESCMECL_CALLS := 0;
   UNAPIME.P_CELLSAVED4ME := NULL;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveScMeCell'));
END SAVESCMECELL;

FUNCTION SAVESCMECELLVALUES                         
(A_SC             IN     VARCHAR2,                  
 A_PG             IN     VARCHAR2,                  
 A_PGNODE         IN     NUMBER,                    
 A_PA             IN     VARCHAR2,                  
 A_PANODE         IN     NUMBER,                    
 A_ME             IN     VARCHAR2,                  
 A_MENODE         IN     NUMBER,                    
 A_REANALYSIS     IN OUT NUMBER,                    
 A_CELL           IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_INDEX_X        IN     UNAPIGEN.NUM_TABLE_TYPE,   
 A_INDEX_Y        IN     UNAPIGEN.NUM_TABLE_TYPE,   
 A_VALUE_F        IN     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_VALUE_S        IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_SELECTED       IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NR_OF_ROWS     IN     NUMBER,                    
 A_NEXT_ROWS      IN     NUMBER)                    
RETURN NUMBER IS

L_LC                                   VARCHAR2(2);
L_LC_VERSION                           VARCHAR2(20);
L_SS                                   VARCHAR2(2);
L_LOG_HS                               CHAR(1);
L_LOG_HS_DETAILS                       CHAR(1);
L_ALLOW_MODIFY                         CHAR(1);
L_ACTIVE                               CHAR(1);
L_ME_EXEC_END_DATE                     TIMESTAMP WITH TIME ZONE;
L_PA_EXEC_END_DATE                     TIMESTAMP WITH TIME ZONE;
L_ME_REANALYSIS                        INTEGER;
L_PA_REANALYSIS                        INTEGER;
L_WHAT_DESCRIPTION                     VARCHAR2(255);
L_HS_SEQ                               INTEGER;
L_MT_VERSION                           VARCHAR2(20);
L_CNT                                  INTEGER;
L_CURRENT_TIMESTAMP                    TIMESTAMP WITH TIME ZONE;
L_NEW_ME_EXEC_START_DATE               TIMESTAMP WITH TIME ZONE;
L_OLD_ME_EXEC_START_DATE               TIMESTAMP WITH TIME ZONE;
L_HS_DETAILS_SEQ_NR                    INTEGER;

CURSOR L_ME_EXEC_END_DATE_CURSOR (A_SC VARCHAR2,
                        A_PG VARCHAR2, A_PGNODE NUMBER,
                        A_PA VARCHAR2, A_PANODE NUMBER,
                        A_ME VARCHAR2, A_MENODE NUMBER) IS
   SELECT EXEC_END_DATE, REANALYSIS
   FROM UTSCME
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE;

CURSOR L_PA_EXEC_END_DATE_CURSOR (A_SC VARCHAR2,
                        A_PG VARCHAR2, A_PGNODE NUMBER,
                        A_PA VARCHAR2, A_PANODE NUMBER) IS
   SELECT EXEC_END_DATE, REANALYSIS
   FROM UTSCPA
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE;

CURSOR L_SCMECELLLISTOLD_CURSOR (A_SC IN VARCHAR2,   A_PG IN VARCHAR2, 
                                 A_PGNODE IN NUMBER, A_PA IN VARCHAR2, 
                                 A_PANODE IN NUMBER, A_ME IN VARCHAR2, 
                                 A_MENODE IN NUMBER, A_CELL IN VARCHAR2,
                                 A_INDEX_X IN NUMBER, A_INDEX_Y IN NUMBER) IS
   SELECT *
   FROM UTSCMECELLLIST A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE
     AND A.ME = A_ME
     AND A.MENODE = -A_MENODE 
     AND A.CELL = A_CELL
     AND A.INDEX_X = A_INDEX_X
     AND A.INDEX_Y = A_INDEX_Y;
L_SCMECELLLISTOLD_REC UTSCMECELLLIST%ROWTYPE;
L_SCMECELLLISTNEW_REC UTSCMECELLLIST%ROWTYPE;
   
BEGIN

   
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   L_HS_DETAILS_SEQ_NR := 0;

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

   L_SQLERRM := NULL;
   IF NVL(A_NEXT_ROWS, 0) = 0 THEN
      IF NVL(P_SAVESCMECLVALUES_CALLS, 0) <> 0 THEN
         L_SQLERRM := 'Previous SaveScMeCellValues termination call never called ! (a_next_rows=-1)';
         RAISE STPERROR;
      END IF;
      P_SAVESCMECLVALUES_CALLS := 1;
   ELSIF NVL(A_NEXT_ROWS, 0) = -1 THEN
      P_SAVESCMECLVALUES_CALLS := NVL(P_SAVESCMECLVALUES_CALLS, 0) + 1;      
   ELSIF NVL(A_NEXT_ROWS, 0) = 1 THEN
      IF NVL(P_SAVESCMECLVALUES_CALLS, 0) = 0 THEN   
         L_SQLERRM := 'SaveScMeCellValues startup call never called ! (a_next_rows=0)';
         RAISE STPERROR;   
      END IF;
      IF NVL(UNAPIGEN.P_TXN_LEVEL, 0) <= 1 THEN   
         L_SQLERRM := 'SaveScMeCellValues called with a_next_rows=1 in a non MST transaction !';
         RAISE STPERROR;   
      END IF;
      P_SAVESCMECLVALUES_CALLS := NVL(P_SAVESCMECLVALUES_CALLS, 0) + 1;      
   ELSE
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NEXTROWS;
      RAISE STPERROR;
   END IF;         
   IF P_SAVESCMECLVALUES_CALLS = 1 THEN
      P_SAVESCMECLVALUES_TR_SEQ := UNAPIGEN.P_TR_SEQ;
   ELSE
      IF UNAPIGEN.P_TR_SEQ <> P_SAVESCMECLVALUES_TR_SEQ THEN
         L_SQLERRM := 'Successive calls of SaveScMeCellValues not in the same transaction !';
         RAISE STPERROR;   
      END IF;
   END IF;

   IF NVL(P_SAVESCMECLVALUES_CALLS, 0)= 1 THEN
      
      
      
      
      SELECT NVL(COUNT(SC), 0)
      INTO L_CNT
      FROM UTSCMECELL
      WHERE SC = A_SC
        AND PG = A_PG
        AND PGNODE = A_PGNODE
        AND PA = A_PA
        AND PANODE = A_PANODE
        AND ME = A_ME
        AND MENODE = A_MENODE;

      IF L_CNT = 0 THEN
         L_RET_CODE := UNAPIME2.CREATESCMEDETAILS(A_SC, A_PG, A_PGNODE,
                                                  A_PA, A_PANODE, A_ME, A_MENODE, A_REANALYSIS);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END IF;
   END IF;
     
   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, 
                                               A_MENODE, A_REANALYSIS, L_MT_VERSION, L_LC,
                                               L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE,
                                               L_LOG_HS, L_LOG_HS_DETAILS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   
   
   OPEN L_ME_EXEC_END_DATE_CURSOR (A_SC, A_PG, A_PGNODE,
                                A_PA, A_PANODE, A_ME, A_MENODE);
   FETCH L_ME_EXEC_END_DATE_CURSOR 
   INTO L_ME_EXEC_END_DATE, L_ME_REANALYSIS;
   IF L_ME_EXEC_END_DATE_CURSOR%NOTFOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      CLOSE L_ME_EXEC_END_DATE_CURSOR;
      RAISE STPERROR;
   END IF;
   CLOSE L_ME_EXEC_END_DATE_CURSOR;
   
   IF L_ME_EXEC_END_DATE IS NOT NULL THEN
      L_RET_CODE := UNAPIMEP.REANALSCMEFROMDETAILS
                    (A_SC, A_PG, A_PGNODE,
                     A_PA, A_PANODE,
                     A_ME, A_MENODE, L_ME_REANALYSIS, 'SaveScMeCellValues');
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
      A_REANALYSIS := L_ME_REANALYSIS;
   END IF;

   
   
   
   
   OPEN L_PA_EXEC_END_DATE_CURSOR (A_SC, 
                                   A_PG, A_PGNODE,
                                   A_PA, A_PANODE);
   FETCH L_PA_EXEC_END_DATE_CURSOR 
   INTO L_PA_EXEC_END_DATE, L_PA_REANALYSIS;
   IF L_PA_EXEC_END_DATE_CURSOR%NOTFOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      CLOSE L_PA_EXEC_END_DATE_CURSOR;
      RAISE STPERROR;
   END IF;
   CLOSE L_PA_EXEC_END_DATE_CURSOR;
   
   IF L_PA_EXEC_END_DATE IS NOT NULL THEN
      L_RET_CODE := UNAPIMEP.REANALSCPAFROMDETAILS
                    (A_SC, A_PG, A_PGNODE,
                     A_PA, A_PANODE,
                     L_PA_REANALYSIS, 'SaveScMeCellValues');
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;

   
   
   IF NVL(P_SAVESCMECLVALUES_CALLS, 0) = 1 THEN

      
      
      
      
      DELETE UTSCMECELLLIST
      WHERE SC = A_SC
        AND PG = A_PG
        AND PGNODE = A_PGNODE
        AND PA = A_PA
        AND PANODE = A_PANODE
        AND ME = A_ME
        AND MENODE = -A_MENODE;

      
      UPDATE UTSCMECELLLIST
      SET MENODE = -MENODE
      WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = A_MENODE;

      
      DELETE UTSCMECELLLISTOUTPUT
      WHERE SC = A_SC
        AND PG = A_PG
        AND PGNODE = A_PGNODE
        AND PA = A_PA
        AND PANODE = A_PANODE
        AND ME = A_ME
        AND MENODE = A_MENODE;
      
      
      
      
      
      UPDATE UTSCME
      SET EXEC_START_DATE = L_CURRENT_TIMESTAMP,
          EXEC_START_DATE_TZ = L_CURRENT_TIMESTAMP
      WHERE SC = A_SC
        AND PG = A_PG
        AND PGNODE = A_PGNODE
        AND PA = A_PA
        AND PANODE = A_PANODE
        AND ME = A_ME
        AND MENODE = A_MENODE
        AND EXEC_START_DATE IS NULL
      RETURNING EXEC_START_DATE
      INTO L_NEW_ME_EXEC_START_DATE;
      IF SQL%ROWCOUNT > 0 THEN
         
         
         
         IF L_LOG_HS_DETAILS = '1' THEN
            IF L_EV_SEQ_NR IS NULL THEN
               L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
               IF L_RET_CODE <> 0 THEN
                  UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                  RAISE STPERROR;
               END IF;
            END IF;
            L_OLD_ME_EXEC_START_DATE := NULL; 
            IF NVL((L_OLD_ME_EXEC_START_DATE <> L_NEW_ME_EXEC_START_DATE), TRUE) AND 
               NOT(L_OLD_ME_EXEC_START_DATE IS NULL AND L_NEW_ME_EXEC_START_DATE IS NULL)  THEN 
               L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                           EV_SEQ, SEQ, DETAILS)
               VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                      UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                      'method "'||A_ME||'" is updated: property <exec_start_date> changed value from "' ||
                      TO_CHAR(L_OLD_ME_EXEC_START_DATE, UNAPIGEN.P_JOBS_DATE_FORMAT) || '" to "' ||
                      TO_CHAR(L_NEW_ME_EXEC_START_DATE, UNAPIGEN.P_JOBS_DATE_FORMAT) || '".');
            END IF;
         END IF;
      END IF;
   END IF;
   
   IF L_LOG_HS_DETAILS = '1' THEN
      L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
      IF L_RET_CODE <> 0 THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
   END IF;
   
   L_HS_SEQ := 0;
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_SELECTED(L_SEQ_NO), ' ') NOT IN ('1','0') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SELECTED;
         RAISE STPERROR;
      END IF;
      
      INSERT INTO UTSCMECELLLIST(SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS,
                                 CELL, INDEX_X, INDEX_Y, VALUE_F, VALUE_S,
                                 SELECTED)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_REANALYSIS,
             A_CELL(L_SEQ_NO), A_INDEX_X(L_SEQ_NO), A_INDEX_Y(L_SEQ_NO),
             A_VALUE_F(L_SEQ_NO), A_VALUE_S(L_SEQ_NO), A_SELECTED(L_SEQ_NO));

      IF L_LOG_HS_DETAILS = '1' THEN
         L_SCMECELLLISTOLD_REC := NULL;
         OPEN L_SCMECELLLISTOLD_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE,
                                       A_CELL(L_SEQ_NO), A_INDEX_X(L_SEQ_NO), A_INDEX_Y(L_SEQ_NO));
         FETCH L_SCMECELLLISTOLD_CURSOR
         INTO L_SCMECELLLISTOLD_REC;
         IF L_SCMECELLLISTOLD_CURSOR%FOUND THEN
            L_SCMECELLLISTOLD_REC.MENODE := -L_SCMECELLLISTOLD_REC.MENODE;
         ELSE
            L_SCMECELLLISTOLD_REC.SC := A_SC;
            L_SCMECELLLISTOLD_REC.PG := A_PG;
            L_SCMECELLLISTOLD_REC.PGNODE := A_PGNODE;
            L_SCMECELLLISTOLD_REC.PA := A_PA;
            L_SCMECELLLISTOLD_REC.PANODE := A_PANODE;
            L_SCMECELLLISTOLD_REC.ME := A_ME;
            L_SCMECELLLISTOLD_REC.MENODE := A_MENODE;
            L_SCMECELLLISTOLD_REC.REANALYSIS := A_REANALYSIS;
            L_SCMECELLLISTOLD_REC.CELL:= A_CELL(L_SEQ_NO);
            L_SCMECELLLISTOLD_REC.INDEX_X := A_INDEX_X(L_SEQ_NO);
            L_SCMECELLLISTOLD_REC.INDEX_Y := A_INDEX_Y(L_SEQ_NO);
            L_SCMECELLLISTOLD_REC.SELECTED := '0';
         END IF;
         CLOSE L_SCMECELLLISTOLD_CURSOR;

         L_SCMECELLLISTNEW_REC.SC := A_SC;
         L_SCMECELLLISTNEW_REC.PG := A_PG;
         L_SCMECELLLISTNEW_REC.PGNODE := A_PGNODE;
         L_SCMECELLLISTNEW_REC.PA := A_PA;
         L_SCMECELLLISTNEW_REC.PANODE := A_PANODE;
         L_SCMECELLLISTNEW_REC.ME := A_ME;
         L_SCMECELLLISTNEW_REC.MENODE := A_MENODE;
         L_SCMECELLLISTNEW_REC.REANALYSIS := A_REANALYSIS;
         L_SCMECELLLISTNEW_REC.CELL:= A_CELL(L_SEQ_NO);
         L_SCMECELLLISTNEW_REC.INDEX_X := A_INDEX_X(L_SEQ_NO);
         L_SCMECELLLISTNEW_REC.INDEX_Y := A_INDEX_Y(L_SEQ_NO);
         L_SCMECELLLISTNEW_REC.VALUE_F := A_VALUE_F(L_SEQ_NO);
         L_SCMECELLLISTNEW_REC.VALUE_S := A_VALUE_S(L_SEQ_NO);
         L_SCMECELLLISTNEW_REC.SELECTED := A_SELECTED(L_SEQ_NO);
         
         UNAPIHSDETAILS.ADDSCMECELLLISTHSDETAILS(L_SCMECELLLISTOLD_REC, L_SCMECELLLISTNEW_REC,
                                                 UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR,L_HS_SEQ);
                                                 
      END IF;
      
   END LOOP;
     
   
   IF NVL(A_NEXT_ROWS, 0) = -1 THEN

      DELETE FROM UTSCMECELLLIST
      WHERE SC = A_SC
      AND PG = A_PG
      AND PGNODE = A_PGNODE
      AND PA = A_PA
      AND PANODE = A_PANODE
      AND ME = A_ME
      AND MENODE = -A_MENODE;

      
      P_SAVESCMECLVALUES_CALLS := 0;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveScMeCellValues',SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('SaveScMeCell',L_SQLERRM);   
   END IF;
   IF L_SCMECELLLISTOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCMECELLLISTOLD_CURSOR;
   END IF;
   
   P_SAVESCMECLVALUES_CALLS := 0;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveScMeCellValues'));
END SAVESCMECELLVALUES;

FUNCTION SAVESCMETHOD                                      
(A_ALARMS_HANDLED        IN     CHAR,                      
 A_SC                    IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG                    IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE                IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA                    IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE                IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME                    IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE                IN OUT UNAPIGEN.LONG_TABLE_TYPE,  
 A_REANALYSIS            IN OUT UNAPIGEN.NUM_TABLE_TYPE,   
 A_MT_VERSION            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCRIPTION           IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_VALUE_F               IN     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_VALUE_S               IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_UNIT                  IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_EXEC_START_DATE       IN     UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXEC_END_DATE         IN OUT UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXECUTOR              IN OUT UNAPIGEN.VC20_TABLE_TYPE,  
 A_LAB                   IN OUT UNAPIGEN.VC20_TABLE_TYPE,  
 A_EQ                    IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_EQ_VERSION            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLANNED_EXECUTOR      IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLANNED_EQ            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLANNED_EQ_VERSION    IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MANUALLY_ENTERED      IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ALLOW_ADD             IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ASSIGN_DATE           IN     UNAPIGEN.DATE_TABLE_TYPE,  
 A_ASSIGNED_BY           IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MANUALLY_ADDED        IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_DELAY                 IN     UNAPIGEN.NUM_TABLE_TYPE,   
 A_DELAY_UNIT            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FORMAT                IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_ACCURACY              IN     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_REAL_COST             IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_REAL_TIME             IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_CALIBRATION           IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_CONFIRM_COMPLETE      IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_AUTORECALC            IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ME_RESULT_EDITABLE    IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NEXT_CELL             IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SOP                   IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_SOP_VERSION           IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLAUS_LOW             IN     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_PLAUS_HIGH            IN     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_WINSIZE_X             IN     UNAPIGEN.NUM_TABLE_TYPE,   
 A_WINSIZE_Y             IN     UNAPIGEN.NUM_TABLE_TYPE,   
 A_ME_CLASS              IN     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LOG_HS                IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LOG_HS_DETAILS        IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LC                    IN     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LC_VERSION            IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MODIFY_FLAG           IN OUT UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS            IN     NUMBER,                    
 A_MODIFY_REASON         IN     VARCHAR2)                  
RETURN NUMBER IS

L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_SS                     VARCHAR2(2);
L_SS_TO                  VARCHAR2(2);
L_LOG_HS                 CHAR(1);
L_LOG_HS_DETAILS         CHAR(1);
L_ALLOW_MODIFY           CHAR(1);
L_ACTIVE                 CHAR(1);
L_INSERT                 BOOLEAN;
L_ME_RECORD_OK           BOOLEAN;
L_ME_HANDLED             BOOLEAN;
CURR_ITEM                INTEGER;
NEXT_ITEM                INTEGER;
PREV_NODE                NUMBER(9);
NEXT_NODE                NUMBER(9);
NODE_STEP                NUMBER(9);
L_SEQ_NO                 INTEGER;
L_LAST_SEQ_NO            INTEGER;
NBR_OF_NODES_TO_CREATE   INTEGER;
L_COMPLETELY_SAVED       BOOLEAN;
L_DELETED_NODE           NUMBER(9);
L_DELAYED_TILL           TIMESTAMP WITH TIME ZONE;
L_OLD_DELAY              INTEGER;
L_OLD_DELAY_UNIT         VARCHAR2(20);
L_DELETE_CURSOR          INTEGER;
L_CURRENT_TIMESTAMP                TIMESTAMP WITH TIME ZONE;
L_REF_DATE               TIMESTAMP WITH TIME ZONE;
L_PG_CONFIRM_ASSIGN      CHAR(1);
L_PGORPA_DELAYED         BOOLEAN;
L_COUNT                  INTEGER;
L_HS_DETAILS_SEQ_NR      INTEGER;
L_MT_VERSION             VARCHAR2(20);
L_NEVER_CREATE_METHODS   CHAR(1);

L_SVRES_SEQ              INTEGER;
L_SVRES_SC               UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_PG               UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_PGNODE           UNAPIGEN.LONG_TABLE_TYPE;
L_SVRES_PA               UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_PANODE           UNAPIGEN.LONG_TABLE_TYPE;
L_SVRES_ME               UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_MENODE           UNAPIGEN.LONG_TABLE_TYPE;
L_SVRES_VALUE_F          UNAPIGEN.FLOAT_TABLE_TYPE;
L_SVRES_VALUE_S          UNAPIGEN.VC40_TABLE_TYPE;
L_SVRES_UNIT             UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_FORMAT           UNAPIGEN.VC40_TABLE_TYPE;
L_SVRES_EXEC_END_DATE    UNAPIGEN.DATE_TABLE_TYPE;
L_SVRES_EXECUTOR         UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_LAB              UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_EQ               UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_EQ_VERSION       UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_MANUALLY_ENTERED UNAPIGEN.CHAR1_TABLE_TYPE;
L_SVRES_REAL_COST        UNAPIGEN.VC40_TABLE_TYPE;
L_SVRES_REAL_TIME        UNAPIGEN.VC40_TABLE_TYPE;
L_SVRES_REANALYSIS       UNAPIGEN.NUM_TABLE_TYPE;
L_SVRES_MODIFY_FLAG      UNAPIGEN.NUM_TABLE_TYPE;
L_SVRES_ORIG_INDEX       UNAPIGEN.NUM_TABLE_TYPE;
L_ROW                    INTEGER;

L_AUTO_CREATE_CELLS      CHAR(1);
L_CREATE_CELLS_TAB       BOOLEAN_TABLE_TYPE;

L_EQ_NESTEDTAB           VC20_NESTEDTABLE_TYPE := VC20_NESTEDTABLE_TYPE();
L_INACTIVE_EQ_COUNT      INTEGER ;

CURSOR L_SCMEGK_CURSOR (A_SC IN VARCHAR2, A_PG IN VARCHAR2, A_PGNODE IN NUMBER) IS
   SELECT DISTINCT GK
   FROM UTSCMEGK
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE;

CURSOR L_WSME_CURSOR (A_SC IN VARCHAR2, 
                      A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                      A_PA IN VARCHAR2, A_PANODE IN NUMBER,
                      A_ME IN VARCHAR2, A_MENODE IN NUMBER) IS
   SELECT A.WS, B.WT_VERSION, B.LC, B.LC_VERSION, B.SS
   FROM UTWS B, UTWSME A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE
     AND A.ME = A_ME
     AND A.MENODE = A_MENODE
     AND A.WS = B.WS;

CURSOR L_MT_CURSOR (A_MT IN VARCHAR2, A_MT_VERSION IN VARCHAR2) IS
   SELECT AUTO_CREATE_CELLS
   FROM UTMT
   WHERE MT = A_MT
   AND VERSION = A_MT_VERSION;

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
L_SCMEOLD_REC UDSCME%ROWTYPE;
L_SCMENEW_REC UDSCME%ROWTYPE;

CURSOR L_SCPG_CURSOR (C_SC IN VARCHAR2, 
                      C_PG IN VARCHAR2, C_PGNODE IN NUMBER) IS
   SELECT NEVER_CREATE_METHODS
   FROM UTSCPG
   WHERE SC = C_SC
     AND PG = C_PG
     AND PGNODE = C_PGNODE;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;

   
   L_SVRES_SEQ := 0;
   L_SQLERRM := NULL;

   IF NVL(A_ALARMS_HANDLED, UNAPIGEN.ALARMS_NOT_HANDLED) NOT IN (UNAPIGEN.ALARMS_NOT_HANDLED, UNAPIGEN.ALARMS_PARTIALLY_HANDLED, UNAPIGEN.ALARMS_ALREADY_HANDLED) THEN
      L_SQLERRM := 'Invalid value for alarms_handled flag'||NVL(A_ALARMS_HANDLED, 'EMPTY');
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;

   
   
   
   IF UNAPIME.P_DONT_CHECK_IF_USED_EQ_ACTIVE = FALSE THEN 
      BEGIN
         CURR_ITEM := 1;
         WHILE CURR_ITEM <= A_NR_OF_ROWS LOOP
            IF ( A_MODIFY_FLAG(CURR_ITEM) NOT IN(UNAPIGEN.DBERR_SUCCESS, UNAPIGEN.MOD_FLAG_DELETE) ) AND
               ( NVL(A_EQ (CURR_ITEM), '-') <> '-' ) AND 
               ( NVL(A_CALIBRATION (CURR_ITEM), '0') = '0' ) THEN 
               L_EQ_NESTEDTAB.EXTEND() ;
               L_EQ_NESTEDTAB(L_EQ_NESTEDTAB.COUNT) :=  A_EQ (CURR_ITEM);
            END IF ;
            CURR_ITEM := CURR_ITEM + 1;
         END LOOP;

         
         SELECT COUNT(EQ)
         INTO L_INACTIVE_EQ_COUNT
         FROM UTEQ
         WHERE EQ IN (SELECT * FROM TABLE(CAST(L_EQ_NESTEDTAB AS VC20_NESTEDTABLE_TYPE)))
         AND NVL(ACTIVE, 0) = 0 ;

         IF L_INACTIVE_EQ_COUNT > 0 THEN
            L_SQLERRM := 'Equipment used is not active. An equipment in an inactive status indicates that the equipment can not be used to make any measurement. ' || 
                         'It has been put out-of-order manualy by someone or by the equipment management rules (out of calibration).';
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
            RAISE STPERROR;
         END IF;
      END ;
   END IF;
   
   
   
   
   CURR_ITEM := 1;
   WHILE CURR_ITEM <= A_NR_OF_ROWS LOOP
      IF A_MODIFY_FLAG(CURR_ITEM) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                      UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                      UNAPIGEN.MOD_FLAG_CREATE) THEN
         IF NVL(A_MENODE(CURR_ITEM), 0) <> 0 THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NEWNODENOTZERO;
            RAISE STPERROR;
         END IF;
         
         
         
         NEXT_ITEM := CURR_ITEM;
         NBR_OF_NODES_TO_CREATE := 0;
         WHILE (A_MODIFY_FLAG(NEXT_ITEM) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                             UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,                
                                             UNAPIGEN.MOD_FLAG_CREATE) AND
                NVL(A_SC(NEXT_ITEM), ' ') = NVL(A_SC(CURR_ITEM),' ') AND
                NVL(A_PG(NEXT_ITEM), ' ') = NVL(A_PG(CURR_ITEM),' ') AND
                NVL(A_PGNODE(NEXT_ITEM), 0) = NVL(A_PGNODE(CURR_ITEM), 0) AND
                NVL(A_PA(NEXT_ITEM), ' ') = NVL(A_PA(CURR_ITEM),' ') AND
                NVL(A_PANODE(NEXT_ITEM), 0) = NVL(A_PANODE(CURR_ITEM), 0)) LOOP
            NBR_OF_NODES_TO_CREATE := NBR_OF_NODES_TO_CREATE + 1;
            IF NEXT_ITEM < A_NR_OF_ROWS THEN
               NEXT_ITEM := NEXT_ITEM + 1;
            ELSE
               EXIT;
            END IF;
         END LOOP;
         
         
         
         
         
         IF A_MODIFY_FLAG(NEXT_ITEM) NOT IN (UNAPIGEN.MOD_FLAG_INSERT,
                                             UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,         
                                             UNAPIGEN.MOD_FLAG_CREATE) AND
            NVL(A_SC(NEXT_ITEM), ' ') = NVL(A_SC(CURR_ITEM), ' ') AND
            NVL(A_PG(NEXT_ITEM), ' ') = NVL(A_PG(CURR_ITEM), ' ') AND
            NVL(A_PGNODE(NEXT_ITEM), 0) = NVL(A_PGNODE(CURR_ITEM), 0) AND
            NVL(A_PA(NEXT_ITEM), ' ') = NVL(A_PA(CURR_ITEM), ' ') AND
            NVL(A_PANODE(NEXT_ITEM), 0) = NVL(A_PANODE(CURR_ITEM), 0) THEN

            NEXT_NODE := A_MENODE(NEXT_ITEM);
            SELECT NVL(MAX(MENODE), 0)
            INTO PREV_NODE
            FROM UTSCME
            WHERE MENODE < NEXT_NODE
              AND SC = A_SC(CURR_ITEM)
              AND PG = A_PG(CURR_ITEM)
              AND PGNODE = A_PGNODE(CURR_ITEM)
              AND PA = A_PA(CURR_ITEM)
              AND PANODE = A_PANODE(CURR_ITEM);
            NODE_STEP :=
               TRUNC(ABS((NEXT_NODE - PREV_NODE)) / (NBR_OF_NODES_TO_CREATE + 1));

            IF NODE_STEP < 1 THEN
               UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NODELIMITOVERF;
               RAISE STPERROR;
            END IF;
         ELSE
            
            SELECT NVL(MAX(MENODE), 0)
            INTO PREV_NODE
            FROM UTSCME
            WHERE SC = A_SC(CURR_ITEM)
              AND PG = A_PG(CURR_ITEM)
              AND PGNODE = A_PGNODE(CURR_ITEM)
              AND PA = A_PA(CURR_ITEM)
              AND PANODE = A_PANODE(CURR_ITEM);
            NODE_STEP := UNAPIGEN.DEFAULT_NODE_INTERVAL;
         END IF;

         
         
         
         FOR I IN 1..NBR_OF_NODES_TO_CREATE LOOP
            A_MENODE(CURR_ITEM + I - 1) := PREV_NODE + (NODE_STEP * I);
         END LOOP;

         CURR_ITEM := CURR_ITEM + NBR_OF_NODES_TO_CREATE;
      ELSE
         CURR_ITEM := CURR_ITEM + 1;
      END IF;
   END LOOP;

   
   
   
   L_COMPLETELY_SAVED := TRUE;

   
   
   
   L_HS_DETAILS_SEQ_NR := 0;
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      L_ME_RECORD_OK := TRUE;          
      L_ME_HANDLED := TRUE;
      L_SS_TO := NULL;

      
      
      
      IF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                     UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                     UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                     UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU,
                                     UNAPIGEN.MOD_FLAG_CREATE) THEN
         IF NVL(A_MT_VERSION(L_SEQ_NO), ' ') = ' ' THEN
            RETURN(UNAPIGEN.DBERR_MTVERSION);
         END IF;
      END IF;

      IF NVL(A_SC(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PG(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PGNODE(L_SEQ_NO), 0) = 0 OR
         NVL(A_PA(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PANODE(L_SEQ_NO), 0) = 0 OR
         NVL(A_ME(L_SEQ_NO), ' ') = ' ' THEN

         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
         
         
         
      ELSIF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                        UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,               
                                        UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                        UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU,               
                                        UNAPIGEN.MOD_FLAG_CREATE,
                                        UNAPIGEN.MOD_FLAG_UPDATE,
                                        UNAPIGEN.MOD_FLAG_DELETE) THEN
         L_MT_VERSION := A_MT_VERSION(L_SEQ_NO);
         L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC(L_SEQ_NO),
                                          A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                                          A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                                          A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
                                          A_REANALYSIS(L_SEQ_NO), L_MT_VERSION, 
                                          L_LC, L_LC_VERSION, L_SS, L_ALLOW_MODIFY,
                                          L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
         IF L_RET_CODE = UNAPIGEN.DBERR_NOOBJECT THEN
            L_INSERT := TRUE;
         ELSIF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
            L_INSERT := FALSE;
         ELSE
            A_MODIFY_FLAG(L_SEQ_NO) := L_RET_CODE;
            L_ME_RECORD_OK := FALSE;
         END IF;
         
      ELSIF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.DBERR_SUCCESS THEN 
         
         
         
         L_ME_RECORD_OK := FALSE; 
         L_ME_HANDLED := FALSE;   
      ELSE
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INVALMODFLAG;
         RAISE STPERROR;         
      END IF;

      
      L_CREATE_CELLS_TAB(L_SEQ_NO) := FALSE;

      
      
      
      IF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                     UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                     UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                     UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU,
                                     UNAPIGEN.MOD_FLAG_CREATE,
                                     UNAPIGEN.MOD_FLAG_UPDATE) THEN
         IF NVL(A_MANUALLY_ENTERED(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MANUALLY_ENTERED;
            RAISE STPERROR;

         ELSIF NVL(A_MANUALLY_ADDED(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MANUALLYADDED;
            RAISE STPERROR;

         ELSIF NVL(A_ALLOW_ADD(L_SEQ_NO), '0') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_ALLOWADD;
            RAISE STPERROR;

         ELSIF NVL(A_CALIBRATION(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_CALIBRATION;
            RAISE STPERROR;

         ELSIF NVL(A_CONFIRM_COMPLETE(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_CONFIRMCOMPLETE;
            RAISE STPERROR;

         ELSIF NVL(A_AUTORECALC(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_AUTORECALC;
            RAISE STPERROR;
         ELSIF NVL(A_ME_RESULT_EDITABLE(L_SEQ_NO), ' ') NOT IN ('0', '1', '2') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MERESULTEDITABLE;
            RAISE STPERROR;
         END IF;         
      END IF;

      
      
      
      IF L_ME_RECORD_OK THEN
         IF NVL(A_LOG_HS(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_LOGHS;
            RAISE STPERROR;
         END IF;
         IF NVL(A_LOG_HS_DETAILS(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_LOGHSDETAILS;
            RAISE STPERROR;
         END IF;
      END IF;

      
      
      
      
      
      IF L_ME_RECORD_OK THEN
         SELECT NVL(COUNT(OBJECT_TP),0)
         INTO L_COUNT
         FROM UTDELAY
         WHERE ( SC = A_SC(L_SEQ_NO)
                 AND PG = A_PG(L_SEQ_NO)
                 AND PGNODE = A_PGNODE(L_SEQ_NO)
                 AND OBJECT_TP = 'pg' )
            OR ( SC = A_SC(L_SEQ_NO)
                 AND PG = A_PG(L_SEQ_NO)
                 AND PGNODE = A_PGNODE(L_SEQ_NO)
                 AND PA = A_PA(L_SEQ_NO)
                 AND PANODE = A_PANODE(L_SEQ_NO)
                 AND OBJECT_TP = 'pa' );
         IF L_COUNT = 0 THEN
            L_PGORPA_DELAYED := FALSE;
         ELSE
            L_PGORPA_DELAYED := TRUE;
         END IF;         

         IF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                        UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                        UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,                                        
                                        UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU,
                                        UNAPIGEN.MOD_FLAG_CREATE,
                                        UNAPIGEN.MOD_FLAG_UPDATE) AND
            (NOT L_PGORPA_DELAYED) AND
            NVL(A_DELAY(L_SEQ_NO), 0) <> 0 THEN

            BEGIN 
               SELECT DELAYED_FROM
               INTO L_REF_DATE
               FROM UTDELAY
               WHERE SC = A_SC(L_SEQ_NO)
                 AND PG = A_PG(L_SEQ_NO)
                 AND PGNODE = A_PGNODE(L_SEQ_NO)
                 AND PA = A_PA(L_SEQ_NO)
                 AND PANODE = A_PANODE(L_SEQ_NO)
                 AND ME = A_ME(L_SEQ_NO)
                 AND MENODE = A_MENODE(L_SEQ_NO)
                 AND OBJECT_TP = 'me';
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               SELECT SAMPLING_DATE
               INTO L_REF_DATE
               FROM UTSC
               WHERE SC = A_SC(L_SEQ_NO);      
               IF L_REF_DATE IS NULL THEN
                  L_REF_DATE := L_CURRENT_TIMESTAMP;
               END IF;
            END;

            L_RET_CODE := UNAPIAUT.CALCULATEDELAY(A_DELAY(L_SEQ_NO),
                                                  A_DELAY_UNIT(L_SEQ_NO),
                                                  L_REF_DATE, L_DELAYED_TILL);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;
            END IF;
          END IF;
       END IF;

      
      
      
      
      
      
      IF L_ME_RECORD_OK AND
         A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_UPDATE THEN

         
         
         
         IF L_INSERT THEN
            
            
            
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
            RAISE STPERROR;

         ELSE
            
            
            
            IF L_PGORPA_DELAYED THEN
               
               
               
               L_SS_TO := '@D';
               L_SS := '@D';
            ELSE
               
               
               
               SELECT DELAY, DELAY_UNIT
               INTO L_OLD_DELAY, L_OLD_DELAY_UNIT
               FROM UTSCME
               WHERE SC = A_SC(L_SEQ_NO)
                 AND PG = A_PG(L_SEQ_NO)
                 AND PGNODE = A_PGNODE(L_SEQ_NO)
                 AND PA = A_PA(L_SEQ_NO)
                 AND PANODE = A_PANODE(L_SEQ_NO)
                 AND ME = A_ME(L_SEQ_NO)
                 AND MENODE = A_MENODE(L_SEQ_NO);
               
               
               
               IF NVL(L_OLD_DELAY, 0) <> NVL(A_DELAY(L_SEQ_NO), 0) OR
                  NVL(L_OLD_DELAY_UNIT, ' ') <> NVL(A_DELAY_UNIT(L_SEQ_NO), ' ')
                  THEN
                  IF NVL(L_OLD_DELAY, 0) = 0 THEN
                     
                     
                     
                     IF NVL(A_DELAY(L_SEQ_NO), 0) <> 0 THEN
                        
                        
                        
                        
                        
                        L_SS_TO := '@D';
                        INSERT INTO UTDELAY(SC, PG, PGNODE, PA, PANODE, ME,
                                            MENODE, OBJECT_TP,
                                            DELAY, DELAY_UNIT, DELAYED_FROM,
                                            DELAYED_TILL)
                        VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO),
                               A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO),
                               A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO),
                               A_MENODE(L_SEQ_NO), 'me', A_DELAY(L_SEQ_NO),
                               A_DELAY_UNIT(L_SEQ_NO), L_REF_DATE, L_DELAYED_TILL);

                        L_EV_SEQ_NR  := -1;
                        L_TIMED_EVENT_TP := 'MeActivate';
                        L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                                        '#pg=' || A_PG(L_SEQ_NO) || 
                                        '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) || 
                                        '#pa=' || A_PA(L_SEQ_NO) || 
                                        '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                                        '#menode=' || TO_CHAR(A_MENODE(L_SEQ_NO)) ||
                                        '#mt_version=' || L_MT_VERSION;
                        L_RESULT :=
                           UNAPIEV.INSERTTIMEDEVENT('SaveScMethod',
                                                    UNAPIGEN.P_EVMGR_NAME,
                                                    'me', A_ME(L_SEQ_NO), L_LC, L_LC_VERSION,
                                                    L_SS, L_TIMED_EVENT_TP,
                                                    L_EV_DETAILS,
                                                    L_EV_SEQ_NR, L_DELAYED_TILL);
                        IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                           UNAPIGEN.P_TXN_ERROR := L_RESULT;
                           RAISE STPERROR;
                        END IF;
                     END IF;
                  ELSE
                     
                     
                     
                     IF NVL(A_DELAY(L_SEQ_NO), 0) = 0 THEN
                        
                        
                        
                        
                        
                        
                        
                        
                        DELETE FROM UTDELAY
                        WHERE SC = A_SC(L_SEQ_NO)
                        AND PG = A_PG(L_SEQ_NO)
                        AND PGNODE = A_PGNODE(L_SEQ_NO)
                        AND PA = A_PA(L_SEQ_NO)
                        AND PANODE = A_PANODE(L_SEQ_NO)
                        AND ME = A_ME(L_SEQ_NO)
                        AND MENODE = A_MENODE(L_SEQ_NO)
                        AND OBJECT_TP = 'me';

                        DELETE FROM UTEVTIMED
                        WHERE OBJECT_TP = 'me'
                          AND OBJECT_ID = A_ME(L_SEQ_NO)
                          AND INSTR(EV_DETAILS, 'sc=' || A_SC(L_SEQ_NO)) <> 0
                          AND INSTR(EV_DETAILS, 'pg=' || A_PG(L_SEQ_NO)) <> 0
                          AND INSTR(EV_DETAILS, 'pgnode=' ||
                                    TO_CHAR(A_PGNODE(L_SEQ_NO))) <> 0
                          AND INSTR(EV_DETAILS, 'pa=' || A_PA(L_SEQ_NO)) <> 0
                          AND INSTR(EV_DETAILS, 'panode=' ||
                                    TO_CHAR(A_PANODE(L_SEQ_NO))) <> 0
                          AND INSTR(EV_DETAILS, 'menode=' ||
                                    TO_CHAR(A_MENODE(L_SEQ_NO))) <> 0
                          AND EV_TP = 'MeActivate';

                        L_EV_SEQ_NR := -1;
                        L_TIMED_EVENT_TP := 'MeActivate';
                        L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                                        '#pg=' || A_PG(L_SEQ_NO) || 
                                        '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) || 
                                        '#pa=' || A_PA(L_SEQ_NO) || 
                                        '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                                        '#menode=' || TO_CHAR(A_MENODE(L_SEQ_NO)) ||
                                        '#mt_version=' || L_MT_VERSION;
                        L_RESULT :=
                           UNAPIEV.INSERTEVENT('SaveScMethod', UNAPIGEN.P_EVMGR_NAME,
                                               'me', A_ME(L_SEQ_NO), L_LC, L_LC_VERSION, L_SS,
                                               L_TIMED_EVENT_TP, L_EV_DETAILS,
                                               L_EV_SEQ_NR);
                        IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                           UNAPIGEN.P_TXN_ERROR := L_RESULT;
                           RAISE STPERROR;
                        END IF;

                     ELSE
                        
                        
                        
                        
                        
                        UPDATE UTDELAY
                        SET DELAY = A_DELAY(L_SEQ_NO),
                            DELAY_UNIT = A_DELAY_UNIT(L_SEQ_NO),
                            DELAYED_FROM = L_REF_DATE,
                            DELAYED_FROM_TZ = DECODE(L_REF_DATE, DELAYED_FROM_TZ, DELAYED_FROM_TZ, L_REF_DATE),
                            DELAYED_TILL = L_DELAYED_TILL,
                            DELAYED_TILL_TZ = DECODE(L_DELAYED_TILL, DELAYED_TILL_TZ, DELAYED_TILL_TZ, L_DELAYED_TILL)
                        WHERE SC = A_SC(L_SEQ_NO)
                          AND PG = A_PG(L_SEQ_NO)
                          AND PGNODE = A_PGNODE(L_SEQ_NO)
                          AND PA = A_PA(L_SEQ_NO)
                          AND PANODE = A_PANODE(L_SEQ_NO)
                          AND ME = A_ME(L_SEQ_NO)
                          AND MENODE = A_MENODE(L_SEQ_NO)
                          AND OBJECT_TP = 'me';

                        L_EV_SEQ_NR := -1;
                        L_TIMED_EVENT_TP := 'MeActivate';
                        L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                                        '#pg=' || A_PG(L_SEQ_NO) || 
                                        '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) || 
                                        '#pa=' || A_PA(L_SEQ_NO) || 
                                        '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                                        '#menode=' || TO_CHAR(A_MENODE(L_SEQ_NO)) ||
                                        '#mt_version=' || L_MT_VERSION;
                        L_RESULT := 
                           UNAPIEV.UPDATETIMEDEVENT('me', A_ME(L_SEQ_NO),
                                                    L_TIMED_EVENT_TP,
                                                    L_EV_DETAILS,
                                                    L_DELAYED_TILL);
                        IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                           UNAPIGEN.P_TXN_ERROR := L_RESULT;
                           RAISE STPERROR;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;

            
            
            
            OPEN L_SCMEOLD_CURSOR(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO),
                                  A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO),
                                  A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO),
                                  A_MENODE(L_SEQ_NO));
            FETCH L_SCMEOLD_CURSOR
            INTO L_SCMEOLD_REC;
            CLOSE L_SCMEOLD_CURSOR;
            L_SCMENEW_REC := L_SCMEOLD_REC;
            
            
            
            
            
            
            
            
            
            
            UPDATE UTSCME
            SET DESCRIPTION          = A_DESCRIPTION(L_SEQ_NO),
                UNIT                 = A_UNIT(L_SEQ_NO),
                EXEC_START_DATE      = NVL(A_EXEC_START_DATE(L_SEQ_NO),EXEC_START_DATE),
                EXEC_START_DATE_TZ   = NVL(DECODE(A_EXEC_START_DATE(L_SEQ_NO), EXEC_START_DATE_TZ, EXEC_START_DATE_TZ, A_EXEC_START_DATE(L_SEQ_NO)),EXEC_START_DATE_TZ),
                EXECUTOR             = A_EXECUTOR(L_SEQ_NO),
                LAB                  = A_LAB(L_SEQ_NO),
                EQ                   = A_EQ(L_SEQ_NO),
                EQ_VERSION           = A_EQ_VERSION(L_SEQ_NO),
                PLANNED_EXECUTOR     = A_PLANNED_EXECUTOR(L_SEQ_NO),
                PLANNED_EQ           = A_PLANNED_EQ(L_SEQ_NO),
                PLANNED_EQ_VERSION   = A_PLANNED_EQ_VERSION(L_SEQ_NO),
                MANUALLY_ENTERED     = A_MANUALLY_ENTERED(L_SEQ_NO),
                ALLOW_ADD            = A_ALLOW_ADD(L_SEQ_NO),
                ASSIGN_DATE          = A_ASSIGN_DATE(L_SEQ_NO),
                ASSIGN_DATE_TZ       = DECODE(A_ASSIGN_DATE(L_SEQ_NO), ASSIGN_DATE_TZ, ASSIGN_DATE_TZ, A_ASSIGN_DATE(L_SEQ_NO)),
                ASSIGNED_BY          = A_ASSIGNED_BY(L_SEQ_NO),
                MANUALLY_ADDED       = A_MANUALLY_ADDED(L_SEQ_NO),
                DELAY                = A_DELAY(L_SEQ_NO),
                DELAY_UNIT           = A_DELAY_UNIT(L_SEQ_NO),
                FORMAT               = A_FORMAT(L_SEQ_NO),
                ACCURACY             = A_ACCURACY(L_SEQ_NO),
                REAL_COST            = A_REAL_COST(L_SEQ_NO),
                REAL_TIME            = A_REAL_TIME(L_SEQ_NO),
                CALIBRATION          = A_CALIBRATION(L_SEQ_NO),
                CONFIRM_COMPLETE     = A_CONFIRM_COMPLETE(L_SEQ_NO),
                AUTORECALC           = A_AUTORECALC(L_SEQ_NO),
                ME_RESULT_EDITABLE   = A_ME_RESULT_EDITABLE(L_SEQ_NO),
                SOP                  = A_SOP(L_SEQ_NO),
                SOP_VERSION          = A_SOP_VERSION(L_SEQ_NO),
                PLAUS_LOW            = A_PLAUS_LOW(L_SEQ_NO),
                PLAUS_HIGH           = A_PLAUS_HIGH(L_SEQ_NO),
                WINSIZE_X            = NVL(A_WINSIZE_X(L_SEQ_NO) ,0),
                WINSIZE_Y            = NVL(A_WINSIZE_Y(L_SEQ_NO) ,0),
                ME_CLASS             = A_ME_CLASS(L_SEQ_NO),
                LOG_HS               = A_LOG_HS(L_SEQ_NO),
                LOG_HS_DETAILS       = A_LOG_HS_DETAILS(L_SEQ_NO),
                ALLOW_MODIFY         = '#'
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO)
            RETURNING DESCRIPTION, UNIT, EXEC_START_DATE, EXEC_START_DATE_TZ, EXECUTOR, LAB, EQ, EQ_VERSION, 
                      PLANNED_EXECUTOR, PLANNED_EQ, PLANNED_EQ_VERSION, MANUALLY_ENTERED, 
                      ALLOW_ADD, ASSIGN_DATE, ASSIGN_DATE_TZ, ASSIGNED_BY, MANUALLY_ADDED, DELAY, DELAY_UNIT, 
                      FORMAT, ACCURACY, REAL_COST, REAL_TIME, CALIBRATION, CONFIRM_COMPLETE, 
                      AUTORECALC, ME_RESULT_EDITABLE, SOP, SOP_VERSION, PLAUS_LOW, PLAUS_HIGH, 
                      WINSIZE_X, WINSIZE_Y, ME_CLASS, LOG_HS, LOG_HS_DETAILS, ALLOW_MODIFY
            INTO L_SCMENEW_REC.DESCRIPTION, L_SCMENEW_REC.UNIT, L_SCMENEW_REC.EXEC_START_DATE,  L_SCMENEW_REC.EXEC_START_DATE_TZ,
                 L_SCMENEW_REC.EXECUTOR, L_SCMENEW_REC.LAB, 
                 L_SCMENEW_REC.EQ, L_SCMENEW_REC.EQ_VERSION,
                 L_SCMENEW_REC.PLANNED_EXECUTOR, L_SCMENEW_REC.PLANNED_EQ, 
                 L_SCMENEW_REC.PLANNED_EQ_VERSION, L_SCMENEW_REC.MANUALLY_ENTERED,
                 L_SCMENEW_REC.ALLOW_ADD, L_SCMENEW_REC.ASSIGN_DATE, L_SCMENEW_REC.ASSIGN_DATE_TZ, L_SCMENEW_REC.ASSIGNED_BY,
                 L_SCMENEW_REC.MANUALLY_ADDED, L_SCMENEW_REC.DELAY, L_SCMENEW_REC.DELAY_UNIT, 
                 L_SCMENEW_REC.FORMAT, L_SCMENEW_REC.ACCURACY, 
                 L_SCMENEW_REC.REAL_COST, L_SCMENEW_REC.REAL_TIME, L_SCMENEW_REC.CALIBRATION,
                 L_SCMENEW_REC.CONFIRM_COMPLETE, L_SCMENEW_REC.AUTORECALC, 
                 L_SCMENEW_REC.ME_RESULT_EDITABLE, L_SCMENEW_REC.SOP, L_SCMENEW_REC.SOP_VERSION, 
                 L_SCMENEW_REC.PLAUS_LOW, L_SCMENEW_REC.PLAUS_HIGH, L_SCMENEW_REC.WINSIZE_X, 
                 L_SCMENEW_REC.WINSIZE_Y, L_SCMENEW_REC.ME_CLASS,
                 L_SCMENEW_REC.LOG_HS, L_SCMENEW_REC.LOG_HS_DETAILS, L_SCMENEW_REC.ALLOW_MODIFY;

            
            
            
            
            
                          
            IF (NVL(L_SCMEOLD_REC.VALUE_F, 0) <> NVL(A_VALUE_F(L_SEQ_NO), 0)) OR
               (L_SCMEOLD_REC.VALUE_F IS NULL AND A_VALUE_F(L_SEQ_NO) IS NOT NULL) OR
               (L_SCMEOLD_REC.VALUE_F IS NOT NULL AND A_VALUE_F(L_SEQ_NO) IS NULL) OR
               NVL(L_SCMEOLD_REC.VALUE_S, ' ') <> NVL(A_VALUE_S(L_SEQ_NO), ' ') THEN

               
               
               
               L_SVRES_SEQ := L_SVRES_SEQ + 1;
               L_SVRES_SC(L_SVRES_SEQ) := A_SC(L_SEQ_NO);
               L_SVRES_PG(L_SVRES_SEQ) := A_PG(L_SEQ_NO);
               L_SVRES_PGNODE(L_SVRES_SEQ) := A_PGNODE(L_SEQ_NO);
               L_SVRES_PA(L_SVRES_SEQ) := A_PA(L_SEQ_NO);
               L_SVRES_PANODE(L_SVRES_SEQ) := A_PANODE(L_SEQ_NO);
               L_SVRES_ME(L_SVRES_SEQ) := A_ME(L_SEQ_NO);
               L_SVRES_MENODE(L_SVRES_SEQ) := A_MENODE(L_SEQ_NO);
               L_SVRES_VALUE_F(L_SVRES_SEQ) := A_VALUE_F(L_SEQ_NO);
               L_SVRES_VALUE_S(L_SVRES_SEQ) := A_VALUE_S(L_SEQ_NO);
               L_SVRES_UNIT(L_SVRES_SEQ) := A_UNIT(L_SEQ_NO);
               L_SVRES_FORMAT(L_SVRES_SEQ) := A_FORMAT(L_SEQ_NO);
               L_SVRES_EXEC_END_DATE(L_SVRES_SEQ) := A_EXEC_END_DATE(L_SEQ_NO);
               L_SVRES_EXECUTOR(L_SVRES_SEQ) := A_EXECUTOR(L_SEQ_NO);
               L_SVRES_LAB(L_SVRES_SEQ) := A_LAB(L_SEQ_NO);
               L_SVRES_EQ(L_SVRES_SEQ) := A_EQ(L_SEQ_NO);
               L_SVRES_EQ_VERSION(L_SVRES_SEQ) := A_EQ_VERSION(L_SEQ_NO);
               L_SVRES_MANUALLY_ENTERED(L_SVRES_SEQ) :=
                                        A_MANUALLY_ENTERED(L_SEQ_NO);
               L_SVRES_REANALYSIS(L_SVRES_SEQ) := A_REANALYSIS(L_SEQ_NO);
               L_SVRES_REAL_COST(L_SVRES_SEQ) := A_REAL_COST(L_SEQ_NO);
               L_SVRES_REAL_TIME(L_SVRES_SEQ) := A_REAL_TIME(L_SEQ_NO);
               L_SVRES_MODIFY_FLAG(L_SVRES_SEQ) := UNAPIGEN.MOD_FLAG_UPDATE;
               L_SVRES_ORIG_INDEX(L_SVRES_SEQ) := L_SEQ_NO;
            END IF;

            
            
            
            
            L_RET_CODE := UNAPIME2.UPDATELINKEDSCMECELL(A_SC => A_SC(L_SEQ_NO),
                                                        A_PG => A_PG(L_SEQ_NO),
                                                        A_PGNODE => A_PGNODE(L_SEQ_NO),
                                                        A_PA => A_PA(L_SEQ_NO),
                                                        A_PANODE => A_PANODE(L_SEQ_NO),
                                                        A_ME => A_ME(L_SEQ_NO),
                                                        A_MENODE => A_MENODE(L_SEQ_NO),
                                                        A_ME_STD_PROPERTY => NULL,
                                                        A_MT_VERSION => L_MT_VERSION,
                                                        A_DESCRIPTION => A_DESCRIPTION(L_SEQ_NO),
                                                        A_UNIT => A_UNIT(L_SEQ_NO),
                                                        A_EXEC_START_DATE => A_EXEC_START_DATE(L_SEQ_NO),
                                                        A_EXEC_END_DATE => A_EXEC_END_DATE(L_SEQ_NO),
                                                        A_EXECUTOR => A_EXECUTOR(L_SEQ_NO),
                                                        A_LAB => A_LAB(L_SEQ_NO),
                                                        A_EQ => A_EQ(L_SEQ_NO),
                                                        A_EQ_VERSION => A_EQ_VERSION(L_SEQ_NO),
                                                        A_PLANNED_EXECUTOR => A_PLANNED_EXECUTOR(L_SEQ_NO),
                                                        A_PLANNED_EQ => A_PLANNED_EQ(L_SEQ_NO),
                                                        A_PLANNED_EQ_VERSION => A_PLANNED_EQ_VERSION(L_SEQ_NO),
                                                        A_DELAY => A_DELAY(L_SEQ_NO),
                                                        A_DELAY_UNIT => A_DELAY_UNIT(L_SEQ_NO),
                                                        A_FORMAT => A_FORMAT(L_SEQ_NO),
                                                        A_ACCURACY => A_ACCURACY(L_SEQ_NO),
                                                        A_REAL_COST => A_REAL_COST(L_SEQ_NO),
                                                        A_REAL_TIME => A_REAL_TIME(L_SEQ_NO),
                                                        A_SOP => A_SOP(L_SEQ_NO),
                                                        A_SOP_VERSION => A_SOP_VERSION(L_SEQ_NO),
                                                        A_PLAUS_LOW => A_PLAUS_LOW(L_SEQ_NO),
                                                        A_PLAUS_HIGH => A_PLAUS_HIGH(L_SEQ_NO),
                                                        A_ME_CLASS => A_ME_CLASS(L_SEQ_NO));
            
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               L_SQLERRM := 'sc=' || A_SC(L_SEQ_NO) || '#pg=' || A_PG(L_SEQ_NO) ||
                  '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) ||
                  '#pa=' || A_PA(L_SEQ_NO) ||
                  '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                  '#me=' || A_ME(L_SEQ_NO) ||
                  '#menode=' || TO_CHAR(A_MENODE(L_SEQ_NO)) ||
                  '#UpdateLinkedScMeCell#ErrorCode=' || TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            END IF;                           

            
            
            
            L_EVENT_TP := 'MethodUpdated';
         END IF;

      
      
      
      ELSIF L_ME_RECORD_OK AND
            A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                        UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,            
                                        UNAPIGEN.MOD_FLAG_CREATE,
                                        UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                        UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU) THEN 

         
         
         
         IF NOT L_INSERT THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MEALREADYEXIST;
            RAISE STPERROR;
         END IF;
         
         OPEN L_SCPG_CURSOR(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO));
         FETCH L_SCPG_CURSOR INTO L_NEVER_CREATE_METHODS;
         IF L_SCPG_CURSOR%NOTFOUND THEN
            L_NEVER_CREATE_METHODS := '0';
         END IF;
         CLOSE L_SCPG_CURSOR;

         
         
         
         IF L_NEVER_CREATE_METHODS = '1' THEN
            L_ME_RECORD_OK := FALSE;
            A_MODIFY_FLAG(L_SEQ_NO) := UNAPIGEN.DBERR_ADDMETHODSNOTALLOWED;
         ELSE
            
            
            
            IF L_PGORPA_DELAYED THEN
               
               
               
               L_SS := '@D';
               L_SS_TO := '@D';
            ELSE
               
               
               
               IF NVL(A_DELAY(L_SEQ_NO), 0) <> 0 THEN
                  
                  
                  
                  
                  
                  L_SS_TO := '@D';
                  INSERT INTO UTDELAY(SC, PG, PGNODE,
                                      PA, PANODE, ME, MENODE, OBJECT_TP,
                                      DELAY, DELAY_UNIT, DELAYED_FROM, DELAYED_TILL)
                  VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                         A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                         A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
                         'me', A_DELAY(L_SEQ_NO), A_DELAY_UNIT(L_SEQ_NO), L_REF_DATE,
                         L_DELAYED_TILL);
                  L_EV_SEQ_NR  := -1;
                  L_TIMED_EVENT_TP := 'MeActivate';
                  L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                                  '#pg=' || A_PG(L_SEQ_NO) || 
                                  '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) || 
                                  '#pa=' || A_PA(L_SEQ_NO) || 
                                  '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) || 
                                  '#menode=' || TO_CHAR(A_MENODE(L_SEQ_NO)) ||
                                  '#mt_version=' || L_MT_VERSION;
                  L_RESULT :=
                     UNAPIEV.INSERTTIMEDEVENT('SaveScMethod',
                                              UNAPIGEN.P_EVMGR_NAME,
                                              'me', A_ME(L_SEQ_NO), L_LC, L_LC_VERSION, L_SS,
                                              L_TIMED_EVENT_TP, L_EV_DETAILS,
                                              L_EV_SEQ_NR, L_DELAYED_TILL);
                  IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                     UNAPIGEN.P_TXN_ERROR := L_RESULT;
                     RAISE STPERROR;
                  END IF;
               END IF;
            END IF;

            
            
            
            
            IF NVL(A_LC(L_SEQ_NO), ' ') <> ' ' THEN
               L_LC := A_LC(L_SEQ_NO);
            END IF;
            IF NVL(A_LC_VERSION(L_SEQ_NO), ' ') <> ' ' THEN
               L_LC_VERSION := A_LC_VERSION(L_SEQ_NO);
            END IF;
            
            
            
            
            
            
            A_REANALYSIS(L_SEQ_NO) := 0; 

            INSERT INTO UTSCME(SC, PG, PGNODE, PA, PANODE, ME, MENODE, MT_VERSION, DESCRIPTION,
                               VALUE_F, VALUE_S, UNIT, 
                               EXEC_START_DATE, EXEC_START_DATE_TZ, EXEC_END_DATE, EXEC_END_DATE_TZ, EXECUTOR, LAB, EQ, EQ_VERSION,
                               PLANNED_EXECUTOR, PLANNED_EQ, PLANNED_EQ_VERSION, MANUALLY_ENTERED,
                               ALLOW_ADD, ASSIGN_DATE, ASSIGN_DATE_TZ,
                               ASSIGNED_BY, MANUALLY_ADDED, DELAY, DELAY_UNIT,
                               FORMAT, ACCURACY, REAL_COST, REAL_TIME,
                               CALIBRATION, CONFIRM_COMPLETE, AUTORECALC, ME_RESULT_EDITABLE,
                               SOP, SOP_VERSION, PLAUS_LOW, PLAUS_HIGH, WINSIZE_X, WINSIZE_Y,
                               REANALYSIS, ME_CLASS, LOG_HS, LOG_HS_DETAILS, ALLOW_MODIFY, ACTIVE,
                               LC, LC_VERSION)
             VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                    A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                    A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO), L_MT_VERSION,
                    A_DESCRIPTION(L_SEQ_NO), NULL, NULL, A_UNIT(L_SEQ_NO),
                    A_EXEC_START_DATE(L_SEQ_NO), A_EXEC_START_DATE(L_SEQ_NO), NULL, NULL, NULL, A_LAB(L_SEQ_NO), A_EQ(L_SEQ_NO), A_EQ_VERSION(L_SEQ_NO),
                    A_PLANNED_EXECUTOR(L_SEQ_NO), A_PLANNED_EQ(L_SEQ_NO), A_PLANNED_EQ_VERSION(L_SEQ_NO), 
                    A_MANUALLY_ENTERED(L_SEQ_NO), A_ALLOW_ADD(L_SEQ_NO),
                    A_ASSIGN_DATE(L_SEQ_NO), A_ASSIGN_DATE(L_SEQ_NO), A_ASSIGNED_BY(L_SEQ_NO),
                    A_MANUALLY_ADDED(L_SEQ_NO), A_DELAY(L_SEQ_NO),
                    A_DELAY_UNIT(L_SEQ_NO), A_FORMAT(L_SEQ_NO),
                    A_ACCURACY(L_SEQ_NO),
                    A_REAL_COST(L_SEQ_NO), A_REAL_TIME(L_SEQ_NO),
                    A_CALIBRATION(L_SEQ_NO), A_CONFIRM_COMPLETE(L_SEQ_NO),
                    A_AUTORECALC(L_SEQ_NO), A_ME_RESULT_EDITABLE(L_SEQ_NO),
                    A_SOP(L_SEQ_NO), A_SOP_VERSION(L_SEQ_NO), A_PLAUS_LOW(L_SEQ_NO),
                    A_PLAUS_HIGH(L_SEQ_NO), NVL(A_WINSIZE_X(L_SEQ_NO) ,0),NVL(A_WINSIZE_Y(L_SEQ_NO),0),
                    0, A_ME_CLASS(L_SEQ_NO), A_LOG_HS(L_SEQ_NO), A_LOG_HS_DETAILS(L_SEQ_NO), '#', '0',
                    L_LC, L_LC_VERSION);
            UNAPIAUT.UPDATELCINAUTHORISATIONBUFFER('me', A_SC(L_SEQ_NO) || A_PG(L_SEQ_NO) || TO_CHAR(A_PGNODE(L_SEQ_NO))||
                                                           A_PA(L_SEQ_NO) || TO_CHAR(A_PANODE(L_SEQ_NO))||
                                                           A_ME(L_SEQ_NO) || TO_CHAR(A_MENODE(L_SEQ_NO)),
                                                           '', L_LC, L_LC_VERSION);                 

            OPEN L_MT_CURSOR(A_ME(L_SEQ_NO), L_MT_VERSION);
            FETCH L_MT_CURSOR
            INTO L_AUTO_CREATE_CELLS;
            IF L_MT_CURSOR%NOTFOUND THEN
               L_AUTO_CREATE_CELLS := '0';
            END IF;
            CLOSE L_MT_CURSOR;

            IF L_AUTO_CREATE_CELLS = '1' THEN
               L_CREATE_CELLS_TAB(L_SEQ_NO) := TRUE;
            END IF;

            
            
            
            IF A_VALUE_F(L_SEQ_NO) IS NOT NULL OR
               A_VALUE_S(L_SEQ_NO) IS NOT NULL THEN

               
               
               
               L_SVRES_SEQ := L_SVRES_SEQ + 1;
               L_SVRES_SC(L_SVRES_SEQ) := A_SC(L_SEQ_NO);
               L_SVRES_PG(L_SVRES_SEQ) := A_PG(L_SEQ_NO);
               L_SVRES_PGNODE(L_SVRES_SEQ) := A_PGNODE(L_SEQ_NO);
               L_SVRES_PA(L_SVRES_SEQ) := A_PA(L_SEQ_NO);
               L_SVRES_PANODE(L_SVRES_SEQ) := A_PANODE(L_SEQ_NO);
               L_SVRES_ME(L_SVRES_SEQ) := A_ME(L_SEQ_NO);
               L_SVRES_MENODE(L_SVRES_SEQ) := A_MENODE(L_SEQ_NO);
               L_SVRES_VALUE_F(L_SVRES_SEQ) := A_VALUE_F(L_SEQ_NO);
               L_SVRES_VALUE_S(L_SVRES_SEQ) := A_VALUE_S(L_SEQ_NO);
               L_SVRES_UNIT(L_SVRES_SEQ) := A_UNIT(L_SEQ_NO);
               L_SVRES_FORMAT(L_SVRES_SEQ) := A_FORMAT(L_SEQ_NO);
               L_SVRES_EXEC_END_DATE(L_SVRES_SEQ) := A_EXEC_END_DATE(L_SEQ_NO);
               L_SVRES_EXECUTOR(L_SVRES_SEQ) := A_EXECUTOR(L_SEQ_NO);
               L_SVRES_LAB(L_SVRES_SEQ) := A_LAB(L_SEQ_NO);
               L_SVRES_EQ(L_SVRES_SEQ) := A_EQ(L_SEQ_NO);
               L_SVRES_EQ_VERSION(L_SVRES_SEQ) := A_EQ_VERSION(L_SEQ_NO);
               L_SVRES_MANUALLY_ENTERED(L_SVRES_SEQ) := A_MANUALLY_ENTERED(L_SEQ_NO);
               L_SVRES_REAL_COST(L_SVRES_SEQ) := A_REAL_COST(L_SEQ_NO);
               L_SVRES_REAL_TIME(L_SVRES_SEQ) := A_REAL_TIME(L_SEQ_NO);
               L_SVRES_REANALYSIS(L_SVRES_SEQ) := A_REANALYSIS(L_SEQ_NO);
               L_SVRES_MODIFY_FLAG(L_SVRES_SEQ) := UNAPIGEN.MOD_FLAG_UPDATE;
               L_SVRES_ORIG_INDEX(L_SVRES_SEQ) := L_SEQ_NO;

            END IF;

            
            
            
            L_EVENT_TP := 'MethodCreated';
         END IF;

      
      
      
      ELSIF L_ME_RECORD_OK AND 
            A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_DELETE THEN

         
         IF UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTALLOWEDIN21CFR11;
            RAISE STPERROR;
         END IF;
         
         IF L_INSERT THEN
            
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
            RAISE STPERROR;

         
         
         
         ELSIF L_ACTIVE = '1' THEN
            
            
            
            SELECT CONFIRM_ASSIGN
            INTO L_PG_CONFIRM_ASSIGN
            FROM UTSCPG
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO);

            IF L_PG_CONFIRM_ASSIGN = '0' THEN
               
               A_MODIFY_FLAG(L_SEQ_NO) := UNAPIGEN.DBERR_OPACTIVE;
               L_ME_RECORD_OK := FALSE;
               L_COMPLETELY_SAVED := FALSE;
            END IF;
         END IF;

         IF L_ME_RECORD_OK THEN 
            
            
            
            DELETE FROM UTSCRD
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTRSCRD
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            
            
            
            L_DELETE_CURSOR := DBMS_SQL.OPEN_CURSOR;
            FOR L_SCMEGKDEL IN L_SCMEGK_CURSOR(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO),
                                               A_PGNODE(L_SEQ_NO)) LOOP
               BEGIN
                  L_SQL_STRING := 'DELETE FROM utscmegk' || L_SCMEGKDEL.GK ||
                                  ' WHERE sc=''' || REPLACE( A_SC(L_SEQ_NO), '''', '''''') ||
                                  ''' AND pg=''' || REPLACE( A_PG(L_SEQ_NO), '''', '''''') ||
                                  ''' AND pgnode=' || A_PGNODE(L_SEQ_NO) ||
                                  ' AND pa=''' || REPLACE( A_PA(L_SEQ_NO), '''', '''''') ||
                                  ''' AND panode=' || A_PANODE(L_SEQ_NO) ||
                                  ' AND me=''' || REPLACE( A_ME(L_SEQ_NO), '''', '''''') ||
                                  ''' AND menode=' || A_MENODE(L_SEQ_NO) ;
                  DBMS_SQL.PARSE(L_DELETE_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
                  L_RESULT := DBMS_SQL.EXECUTE(L_DELETE_CURSOR);
               EXCEPTION
               WHEN OTHERS THEN
                  IF SQLCODE = -942 THEN
                     NULL; 
                  ELSE
                     RAISE;
                  END IF;
               END;
            END LOOP;
            DBMS_SQL.CLOSE_CURSOR(L_DELETE_CURSOR);

            DELETE FROM UTSCMEGK
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTRSCMECELLLISTOUTPUT
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTRSCMECELLOUTPUT
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTRSCMECELLINPUT
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTRSCMECELLLIST
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTRSCMECELL
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTRSCME
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTSCMECELLINPUT
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTSCMECELLOUTPUT
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTSCMECELLLIST
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME     = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTSCMECELLLISTOUTPUT
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME     = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTSCMECELL
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME     = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTSCMEHS
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME     = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTSCMEHSDETAILS
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME     = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTSCMEAU
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME     = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            
            
            FOR L_WSME_REC IN L_WSME_CURSOR(A_SC(L_SEQ_NO),
                                            A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                                            A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                                            A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO)) LOOP

                L_EV_SEQ_NR := -1;
                L_EVENT_TP := 'WsDetailsUpdated';
                L_EV_DETAILS := 'wt_version=' || L_WSME_REC.WT_VERSION;

                L_RESULT := UNAPIEV.INSERTEVENT('SaveScMethod', UNAPIGEN.P_EVMGR_NAME,
                                                'ws', L_WSME_REC.WS, L_WSME_REC.LC, L_WSME_REC.LC_VERSION, 
                                                L_WSME_REC.SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
                IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                   UNAPIGEN.P_TXN_ERROR := L_RESULT;
                   RAISE STPERROR;
                END IF;
            END LOOP;

            DELETE FROM UTWSME
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME     = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTSCME
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME     = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            
            
            
            DELETE FROM UTDELAY
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = A_PG(L_SEQ_NO)
              AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME     = A_ME(L_SEQ_NO)
              AND MENODE = A_MENODE(L_SEQ_NO);

            DELETE FROM UTEVTIMED
            WHERE OBJECT_TP = 'me'
              AND OBJECT_ID = A_ME(L_SEQ_NO)
              AND INSTR(EV_DETAILS, 'sc=' || A_SC(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pg=' || A_PG(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'pa=' || A_PA(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'panode=' || TO_CHAR(A_PANODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'menode=' || TO_CHAR(A_MENODE(L_SEQ_NO))) <> 0;

            DELETE FROM UTEVTIMED
            WHERE INSTR(EV_DETAILS, 'sc=' || A_SC(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pg=' || A_PG(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'pa=' || A_PA(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'panode=' || TO_CHAR(A_PANODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'me=' || A_ME(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'menode=' || TO_CHAR(A_MENODE(L_SEQ_NO))) <> 0;

            DELETE FROM UTEVRULESDELAYED
            WHERE OBJECT_TP = 'me'
              AND OBJECT_ID = A_ME(L_SEQ_NO)
              AND INSTR(EV_DETAILS, 'sc=' || A_SC(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pg=' || A_PG(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'pa=' || A_PA(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'panode=' || TO_CHAR(A_PANODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'menode=' || TO_CHAR(A_MENODE(L_SEQ_NO))) <> 0;

            DELETE FROM UTEVRULESDELAYED
            WHERE INSTR(EV_DETAILS, 'sc=' || A_SC(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pg=' || A_PG(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'pa=' || A_PA(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'panode=' || TO_CHAR(A_PANODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'me=' || A_ME(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'menode=' || TO_CHAR(A_MENODE(L_SEQ_NO))) <> 0;

            L_DELETED_NODE := A_MENODE(L_SEQ_NO);
            A_MENODE(L_SEQ_NO) := 0;  

            
            
            
            L_EVENT_TP := 'MethodDeleted';
         END IF;
      END IF;

      
      
      
      IF L_ME_RECORD_OK THEN
         L_EV_SEQ_NR := -1;
         IF A_MODIFY_FLAG(L_SEQ_NO) <> UNAPIGEN.MOD_FLAG_DELETE THEN
            L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                            '#pg=' || A_PG(L_SEQ_NO) || 
                            '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) || 
                            '#pa=' || A_PA(L_SEQ_NO) || 
                            '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) || 
                            '#menode=' || TO_CHAR(A_MENODE(L_SEQ_NO)) ||
                            '#mt_version=' || L_MT_VERSION;
         ELSE
            L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                            '#pg=' || A_PG(L_SEQ_NO) || 
                            '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) || 
                            '#pa=' || A_PA(L_SEQ_NO) || 
                            '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) || 
                            '#menode=' || TO_CHAR(L_DELETED_NODE) ||
                            '#mt_version=' || L_MT_VERSION;
         END IF;

         IF NVL(L_SS_TO, ' ') <> ' ' THEN
            L_EV_DETAILS := L_EV_DETAILS || 
                            '#ss_to=' || L_SS_TO;
         END IF;

         L_RESULT := UNAPIEV.INSERTEVENT('SaveScMethod', UNAPIGEN.P_EVMGR_NAME,
                                         'me', A_ME(L_SEQ_NO), L_LC, L_LC_VERSION, L_SS,
                                         L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
         END IF;
      ELSE
         IF L_ME_HANDLED THEN
            L_COMPLETELY_SAVED := FALSE;
         END IF;
      END IF;

      
      
      
      IF L_ME_RECORD_OK AND
         L_LOG_HS <> A_LOG_HS(L_SEQ_NO) AND
         A_MODIFY_FLAG(L_SEQ_NO) <> UNAPIGEN.MOD_FLAG_DELETE THEN
         IF A_LOG_HS(L_SEQ_NO) = '1' THEN
            INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                                 WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
                   UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched ON', 
                   'Audit trail is turned on.',
                   L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         ELSE
            INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                                 WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
                   UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched OFF', 
                   'Audit trail is turned off.', 
                   L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         END IF;
      END IF;

      
      
      
      IF L_ME_RECORD_OK AND
         L_LOG_HS_DETAILS <> A_LOG_HS_DETAILS(L_SEQ_NO) AND
         A_MODIFY_FLAG(L_SEQ_NO) <> UNAPIGEN.MOD_FLAG_DELETE THEN
         IF A_LOG_HS_DETAILS(L_SEQ_NO) = '1' THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
                   UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'Audit trail details is turned on.');
         ELSE
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
                   UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'Audit trail details is turned off.');
         END IF;
      END IF;

      
      
      
      IF L_ME_RECORD_OK AND (L_LOG_HS = '1' OR A_LOG_HS(L_SEQ_NO)='1') THEN
         IF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_DELETE THEN
            
            
            
            
            
            
            INSERT INTO UTSCPAHS(SC, PG, PGNODE, PA, PANODE, WHO, WHO_DESCRIPTION, 
                                 WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                   'method "'||A_ME(L_SEQ_NO)||'" is deleted.', 
                   L_CURRENT_TIMESTAMP,L_CURRENT_TIMESTAMP,  A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         ELSIF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                           UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                           UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                           UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU) THEN
            
            
            
            
            INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                                 WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
                   NVL(A_ASSIGNED_BY(L_SEQ_NO), UNAPIGEN.P_USER), 
                   NVL(UNAPIGEN.SQLUSERDESCRIPTION(A_ASSIGNED_BY(L_SEQ_NO)), UNAPIGEN.P_USER_DESCRIPTION),
                   L_EVENT_TP, 
                   'method "'||A_ME(L_SEQ_NO)||'" is created.',
                   L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         ELSE
            
            
            
            INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, 
                                 WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO), UNAPIGEN.P_USER, 
                   UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                   'method "'||A_ME(L_SEQ_NO)||'" is updated.',
                   L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         END IF;
      END IF;

      
      
      
      IF L_ME_RECORD_OK AND (L_LOG_HS_DETAILS = '1' OR A_LOG_HS_DETAILS(L_SEQ_NO)='1') THEN
         IF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_DELETE THEN
            
            
            
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;            
            INSERT INTO UTSCPAHSDETAILS(SC, PG, PGNODE, PA, PANODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'method "'||A_ME(L_SEQ_NO)||'" is deleted.');
         ELSIF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                           UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                           UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                           UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU) THEN
            
            
            
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;            
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE,
                                        TR_SEQ, EV_SEQ, SEQ, DETAILS) 
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO),
                   UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'method "'||A_ME(L_SEQ_NO)||'" is created.');
         ELSE
            
            
            
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;            
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                        TR_SEQ, EV_SEQ, SEQ, DETAILS) 
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO), 
                   UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'method "'||A_ME(L_SEQ_NO)||'" is updated.');
            UNAPIHSDETAILS.ADDSCMEHSDETAILS(L_SCMEOLD_REC, L_SCMENEW_REC,UNAPIGEN.P_TR_SEQ, 
                                            L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR); 
         END IF;
      END IF;

      
      
      
      
      
      
      IF L_ME_RECORD_OK AND
         A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_CREATE,
                                     UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                     UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU) THEN
         
         
         
         
         L_RET_CODE := UNAPIMEP2.INITANDSAVESCMEATTRIBUTES(A_SC(L_SEQ_NO), 
                                                           A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                                                           A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                                                           A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO));
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
         
      END IF;

   
   
   
   END LOOP;

   
   
   
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF L_CREATE_CELLS_TAB(L_SEQ_NO) THEN
         L_RET_CODE := UNAPIME2.CREATESCMEDETAILS(A_SC(L_SEQ_NO),
                                                  A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                                                  A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                                                  A_ME(L_SEQ_NO), A_MENODE(L_SEQ_NO), 0);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            L_SQLERRM := 'sc=' || A_SC(L_SEQ_NO) || '#pg=' || A_PG(L_SEQ_NO) ||
                      '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) ||
                      '#pa=' || A_PA(L_SEQ_NO) ||
                      '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                      '#me=' || A_ME(L_SEQ_NO) ||
                      '#menode=' || TO_CHAR(A_MENODE(L_SEQ_NO)) ||
                      '#CreateScMeDetails#ErrorCode=' || TO_CHAR(L_RET_CODE);
            RAISE STPERROR;
         END IF;
      END IF;
   END LOOP;

   
   
   
   IF L_SVRES_SEQ <> 0 THEN
      L_RET_CODE := UNAPIME.SAVESCMERESULT(A_ALARMS_HANDLED,
                           L_SVRES_SC, L_SVRES_PG,
                           L_SVRES_PGNODE, L_SVRES_PA, L_SVRES_PANODE,
                           L_SVRES_ME, L_SVRES_MENODE, L_SVRES_REANALYSIS,
                           L_SVRES_VALUE_F, L_SVRES_VALUE_S,
                           L_SVRES_UNIT, L_SVRES_FORMAT, L_SVRES_EXEC_END_DATE,
                           L_SVRES_EXECUTOR, L_SVRES_LAB, L_SVRES_EQ, L_SVRES_EQ_VERSION,
                           L_SVRES_MANUALLY_ENTERED,
                           L_SVRES_REAL_COST, L_SVRES_REAL_TIME,
                           L_SVRES_MODIFY_FLAG,
                           L_SVRES_SEQ, A_MODIFY_REASON);
                           
      
      IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS OR
         L_RET_CODE = UNAPIGEN.DBERR_PARTIALSAVE THEN

         FOR L_ROW IN 1..L_SVRES_SEQ LOOP
            IF L_SVRES_MODIFY_FLAG(L_ROW) = UNAPIGEN.DBERR_SUCCESS THEN
               A_REANALYSIS(L_SVRES_ORIG_INDEX(L_ROW)) := L_SVRES_REANALYSIS(L_ROW);
            END IF;
         END LOOP;
      
      END IF;

      IF L_RET_CODE = UNAPIGEN.DBERR_PARTIALSAVE THEN
         
         
         
         FOR L_ROW IN 1..L_SVRES_SEQ LOOP
            IF L_SVRES_MODIFY_FLAG(L_ROW) > UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_SVRES_MODIFY_FLAG(L_ROW);
               L_SQLERRM := 'sc=' || L_SVRES_SC(L_ROW) || '#pg=' || L_SVRES_PG(L_ROW) ||
                         '#pgnode=' || TO_CHAR(L_SVRES_PGNODE(L_ROW)) ||
                         '#pa=' || L_SVRES_PA(L_ROW)||
                         '#panode=' || TO_CHAR(L_SVRES_PANODE(L_ROW)) ||
                         '#me=' || L_SVRES_ME(L_ROW) ||
                         '#menode=' || TO_CHAR(L_SVRES_MENODE(L_ROW)) ||
                         '#SaveScMeResult#ErrorCode=' || TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            END IF;
         END LOOP;
      ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         L_SQLERRM := 'sc(1)=' || L_SVRES_SC(1) || '#pg(1)=' || L_SVRES_PG(1) ||
                   '#pgnode(1)=' || TO_CHAR(L_SVRES_PGNODE(1)) ||
                   '#pa(1)=' || L_SVRES_PA(1)||
                   '#panode(1)=' || TO_CHAR(L_SVRES_PANODE(1)) ||
                   '#me(1)=' || L_SVRES_ME(1) ||
                   '#menode(1)=' || TO_CHAR(L_SVRES_MENODE(1)) ||
                   '#nr_of_rows=' || TO_CHAR(L_SVRES_SEQ) ||
                   '#SaveScMeResult#ErrorCode=' || TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;                           

      
      
      L_SEQ_NO := 1;
      L_LAST_SEQ_NO := 1;
      FOR L_ROW IN 1..L_SVRES_SEQ LOOP
         FOR L_SEQ_NO IN L_LAST_SEQ_NO..A_NR_OF_ROWS LOOP
            IF A_SC(L_SEQ_NO) = L_SVRES_SC(L_ROW) AND
               A_PG(L_SEQ_NO) = L_SVRES_PG(L_ROW) AND
               A_PGNODE(L_SEQ_NO) = L_SVRES_PGNODE(L_ROW) AND
               A_PA(L_SEQ_NO) = L_SVRES_PA(L_ROW) AND
               A_PANODE(L_SEQ_NO) = L_SVRES_PANODE(L_ROW) AND
               A_ME(L_SEQ_NO) = L_SVRES_ME(L_ROW) AND
               A_MENODE(L_SEQ_NO) = L_SVRES_MENODE(L_ROW) THEN
                  A_EXECUTOR(L_SEQ_NO) := L_SVRES_EXECUTOR(L_ROW);
                  A_LAB(L_SEQ_NO) := L_SVRES_LAB(L_ROW);
                  A_EXEC_END_DATE(L_SEQ_NO) := L_SVRES_EXEC_END_DATE(L_ROW);
                  L_LAST_SEQ_NO := L_SEQ_NO;
                  EXIT;
            END IF;
         END LOOP;
      END LOOP;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_MODIFY_FLAG(L_SEQ_NO) < UNAPIGEN.DBERR_SUCCESS THEN
         A_MODIFY_FLAG(L_SEQ_NO) := UNAPIGEN.DBERR_SUCCESS;
      END IF;
   END LOOP;

   IF L_COMPLETELY_SAVED THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN(UNAPIGEN.DBERR_PARTIALSAVE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveScMethod',SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('SaveScMethod',L_SQLERRM);   
   END IF;
   IF DBMS_SQL.IS_OPEN(L_DELETE_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_DELETE_CURSOR);
   END IF;
   IF L_SCMEOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCMEOLD_CURSOR;
   END IF;
   IF L_MT_CURSOR%ISOPEN THEN
      CLOSE L_MT_CURSOR;
   END IF;
   IF L_SCPG_CURSOR%ISOPEN THEN
      CLOSE L_SCPG_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveScMethod'));
END SAVESCMETHOD;

FUNCTION INITSCMETHOD                                      
(A_MT                   IN      VARCHAR2,                  
 A_MT_VERSION_IN        IN      VARCHAR2,                  
 A_SEQ                  IN      NUMBER,                    
 A_SC                   IN      VARCHAR2,                  
 A_PG                   IN      VARCHAR2,                  
 A_PGNODE               IN      NUMBER,                    
 A_PA                   IN      VARCHAR2,                  
 A_PANODE               IN      NUMBER,                    
 A_PR_VERSION           IN      VARCHAR2,                  
 A_MT_NR_MEASUR         IN      NUMBER,                    
 A_REANALYSIS           OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_MT_VERSION           OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCRIPTION          OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_VALUE_F              OUT     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_VALUE_S              OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_UNIT                 OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_EXEC_START_DATE      OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXEC_END_DATE        OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXECUTOR             OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_LAB                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_EQ                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_EQ_VERSION           OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLANNED_EXECUTOR     OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLANNED_EQ           OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLANNED_EQ_VERSION   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MANUALLY_ENTERED     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ALLOW_ADD            OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ASSIGN_DATE          OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_ASSIGNED_BY          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MANUALLY_ADDED       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_DELAY                OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_DELAY_UNIT           OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FORMAT               OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_ACCURACY             OUT     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_REAL_COST            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_REAL_TIME            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_CALIBRATION          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_CONFIRM_COMPLETE     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_AUTORECALC           OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ME_RESULT_EDITABLE   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NEXT_CELL            OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SOP                  OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_SOP_VERSION          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLAUS_LOW            OUT     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_PLAUS_HIGH           OUT     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_WINSIZE_X            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_WINSIZE_Y            OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_ME_CLASS             OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LOG_HS               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LOG_HS_DETAILS       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LC                   OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LC_VERSION           OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_NR_OF_ROWS           IN OUT  NUMBER)                    
RETURN NUMBER IS

L_MT_VERSION_IN        VARCHAR2(20);
L_MT_VERSION           VARCHAR2(20);
L_DESCRIPTION          VARCHAR2(40);
L_VALUE_F              FLOAT;
L_VALUE_S              VARCHAR2(40);
L_UNIT                 VARCHAR2(20);
L_EXEC_START_DATE      TIMESTAMP WITH TIME ZONE;
L_EXEC_END_DATE        TIMESTAMP WITH TIME ZONE;
L_EXECUTOR             VARCHAR2(20);
L_LAB                  VARCHAR2(20);
L_EQ                   VARCHAR2(20);
L_EQ_VERSION           VARCHAR2(20);
L_PLANNED_EXECUTOR     VARCHAR2(20);
L_PLANNED_EQ_TP        VARCHAR2(20);
L_PLANNED_EQ           VARCHAR2(20);
L_PLANNED_EQ_VERSION   VARCHAR2(20);
L_MANUALLY_ENTERED     CHAR(1);
L_ALLOW_ADD            CHAR(1);
L_ASSIGN_DATE          TIMESTAMP WITH TIME ZONE;
L_ASSIGNED_BY          VARCHAR2(20);
L_MANUALLY_ADDED       CHAR(1);
L_DELAY                NUMBER(3);
L_DELAY_UNIT           VARCHAR2(20);
L_FORMAT               VARCHAR2(40);
L_ACCURACY             FLOAT;
L_REAL_COST            VARCHAR2(40);
L_REAL_TIME            VARCHAR2(40);
L_CALIBRATION          CHAR(1);
L_CONFIRM_COMPLETE     CHAR(1);
L_AUTORECALC           CHAR(1);
L_ME_RESULT_EDITABLE   CHAR(1);
L_NEXT_CELL            VARCHAR2(20);
L_SOP                  VARCHAR2(40);
L_SOP_VERSION          VARCHAR2(20);
L_PLAUS_LOW            FLOAT;
L_PLAUS_HIGH           FLOAT;
L_WINSIZE_X            NUMBER(4);
L_WINSIZE_Y            NUMBER(4);
L_REANALYSIS           NUMBER(3);
L_ME_CLASS             VARCHAR2(2);
L_LOG_HS               CHAR(1);
L_LOG_HS_DETAILS       CHAR(1);
L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_NR_MEASUR            NUMBER(3);
L_PRMT_NR_MEASUR       NUMBER(3);
L_CUR_ALLOW_ADD        CHAR(1);
L_CUR_ACCURACY         FLOAT;
L_CUR_UNIT             VARCHAR2(20);
L_CUR_FORMAT           VARCHAR2(40);
L_SEQ                  NUMBER;
L_CALL_STACK           VARCHAR2(2000);
L_PR_VERSION           VARCHAR2(20);
L_COUNT_MT             INTEGER;
L_COUNT_PR             INTEGER;
L_MT_DEFINITION_EXISTS BOOLEAN;

CURSOR L_MT_CURSOR(C_MT VARCHAR2, C_MT_VERSION VARCHAR2) IS
   SELECT VERSION, DESCRIPTION, UNIT, EST_COST, EST_TIME, ACCURACY, CALIBRATION, AUTORECALC, 
          ME_RESULT_EDITABLE, CONFIRM_COMPLETE, EXECUTOR, EQ_TP, SOP, SOP_VERSION, 
          PLAUS_LOW, PLAUS_HIGH, WINSIZE_X, WINSIZE_Y, FORMAT, MT_CLASS, SC_LC, SC_LC_VERSION
   FROM UTMT
   WHERE MT = C_MT
   AND VERSION = C_MT_VERSION;

CURSOR L_PRMT_CURSOR(C_PR VARCHAR2, C_PR_VERSION VARCHAR2, C_MT VARCHAR2, C_MT_VERSION VARCHAR2, 
                     A_SEQ NUMBER) IS
   SELECT NVL(NR_MEASUR,1), UNIT, FORMAT, ALLOW_ADD, ACCURACY
   FROM UTPRMT
   WHERE PR = C_PR
   AND VERSION = C_PR_VERSION
   AND MT = C_MT
   AND UNAPIGEN.VALIDATEVERSION('mt', MT, MT_VERSION) = C_MT_VERSION
   AND SEQ= NVL(A_SEQ, SEQ)
   ORDER BY SEQ;
   
CURSOR L_OBJECTS_CURSOR (A_OBJECT_TYPE VARCHAR2) IS
   SELECT LOG_HS, LOG_HS_DETAILS
   FROM UTOBJECTS
   WHERE OBJECT=A_OBJECT_TYPE;

BEGIN

   IF NVL(A_NR_OF_ROWS, 0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_MT, ' ') = ' ' OR
      NVL(A_SC, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PA, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_NOOBJID);
   END IF;

   
   IF NVL(A_SEQ, 0) = 0 THEN
      L_SEQ := NULL;
   ELSE
      L_SEQ := A_SEQ;
   END IF;

   
   BEGIN
      L_MT_VERSION_IN := UNAPIGEN.VALIDATEVERSION('mt', A_MT, A_MT_VERSION_IN);
      L_MT_DEFINITION_EXISTS := TRUE;
   EXCEPTION
   WHEN OTHERS THEN
      
      
      
      
      SELECT COUNT(*)
      INTO L_COUNT_MT
      FROM UTMT
      WHERE MT = A_MT;
      
      IF L_COUNT_MT >= 1 THEN
         RAISE;
      END IF;
      L_MT_DEFINITION_EXISTS := FALSE;
      
   END;
   
   BEGIN
      L_PR_VERSION := UNAPIGEN.VALIDATEVERSION('pr', A_PA, A_PR_VERSION);
   EXCEPTION
   WHEN OTHERS THEN
      
      
      
      
      SELECT COUNT(*)
      INTO L_COUNT_PR
      FROM UTPR
      WHERE PR = A_PA;
      
      IF L_COUNT_PR >= 1 THEN
         RAISE;
      END IF;
      
      L_PR_VERSION := NULL;
   END;
      

   
   
   
   L_VALUE_F := NULL;
   L_VALUE_S := NULL;
   L_EXEC_START_DATE := NULL;
   L_EXEC_END_DATE := NULL;
   L_LAB := NULL;
   L_EQ := NULL;
   L_EQ_VERSION := NULL;
   L_PLANNED_EXECUTOR := NULL;
   L_PLANNED_EQ := NULL;
   L_PLANNED_EQ_VERSION := NULL;
   L_MANUALLY_ENTERED := '0';
   L_ALLOW_ADD := '1';
   L_ASSIGN_DATE := CURRENT_TIMESTAMP;
   L_ASSIGNED_BY := UNAPIGEN.P_USER;
   L_MANUALLY_ADDED := '1';
   L_ACCURACY := 0;
   L_DELAY := 0;
   L_DELAY_UNIT := NULL;
   L_REANALYSIS := 0;
   L_NEXT_CELL := NULL;
   L_ME_CLASS := NULL;

   
   L_LOG_HS := '0';
   OPEN L_OBJECTS_CURSOR('me');
   FETCH L_OBJECTS_CURSOR INTO L_LOG_HS, L_LOG_HS_DETAILS;
   CLOSE L_OBJECTS_CURSOR;
   
   
   
   
   IF A_MT = '/' OR L_MT_DEFINITION_EXISTS = FALSE THEN
      L_MT_VERSION := UNVERSION.P_NO_VERSION;
      L_DESCRIPTION := A_MT;
      L_UNIT := '';
      L_REAL_COST := NULL;
      L_REAL_TIME := NULL;
      L_ACCURACY := 0;
      L_CALIBRATION := '0';
      L_AUTORECALC := '0';
      L_ME_RESULT_EDITABLE := '1';
      L_CONFIRM_COMPLETE := '0';
      L_PLANNED_EXECUTOR := '';
      L_PLANNED_EQ := '';
      L_PLANNED_EQ_VERSION := '';
      L_SOP := '/';
      L_SOP_VERSION := '';
      L_PLAUS_LOW := NULL;
      L_PLAUS_HIGH := NULL;
      L_WINSIZE_X := 0;
      L_WINSIZE_Y := 0;
      L_FORMAT := UNAPIGEN.P_DEFAULT_FORMAT;
      L_ME_CLASS := '';
      L_LC := '';
      L_LC_VERSION := '';
   ELSE
      OPEN L_MT_CURSOR(A_MT, L_MT_VERSION_IN);
      FETCH L_MT_CURSOR
      INTO L_MT_VERSION, L_DESCRIPTION, L_UNIT, L_REAL_COST, L_REAL_TIME, L_ACCURACY, 
           L_CALIBRATION, L_AUTORECALC, L_ME_RESULT_EDITABLE, L_CONFIRM_COMPLETE, 
           L_PLANNED_EXECUTOR, L_PLANNED_EQ_TP, L_SOP, L_SOP_VERSION, 
           L_PLAUS_LOW, L_PLAUS_HIGH, L_WINSIZE_X, L_WINSIZE_Y, L_FORMAT, L_ME_CLASS, 
           L_LC, L_LC_VERSION;
      IF L_MT_CURSOR%NOTFOUND THEN
         CLOSE L_MT_CURSOR;
         RETURN(UNAPIGEN.DBERR_NOOBJECT);
      END IF;
      CLOSE L_MT_CURSOR;
   
      
      
      
      
      IF P_COPY_EST_COST <> 'YES' THEN
         L_REAL_COST := NULL;
      END IF;
      IF P_COPY_EST_TIME <> 'YES' THEN
         L_REAL_TIME := NULL;
      END IF;
   END IF;
   
   
   
   
   OPEN L_PRMT_CURSOR(A_PA, L_PR_VERSION, A_MT, L_MT_VERSION_IN, L_SEQ);
   FETCH L_PRMT_CURSOR 
   INTO L_PRMT_NR_MEASUR, L_CUR_UNIT, L_CUR_FORMAT, L_CUR_ALLOW_ADD, L_CUR_ACCURACY;
   
   IF L_PRMT_CURSOR%FOUND THEN
      IF NVL(L_CUR_ALLOW_ADD, ' ') <> ' ' THEN
         L_ALLOW_ADD := L_CUR_ALLOW_ADD;
      END IF;
      IF L_CUR_ACCURACY IS NOT NULL THEN
         L_ACCURACY := L_CUR_ACCURACY;
      END IF;
      IF NVL(L_CUR_UNIT, ' ') <> ' ' THEN
         L_UNIT := L_CUR_UNIT;
      END IF;
      IF NVL(L_CUR_FORMAT, ' ') <> ' ' THEN
         L_FORMAT := L_CUR_FORMAT;
      END IF;
   ELSE
      L_ALLOW_ADD := '1';
   END IF;

   
   
   
   IF A_MT_NR_MEASUR IS NOT NULL THEN
     L_NR_MEASUR := A_MT_NR_MEASUR;
   ELSE
      IF L_PRMT_CURSOR%FOUND THEN
         L_NR_MEASUR := L_PRMT_NR_MEASUR;
      ELSE
         L_NR_MEASUR := 1;
      END IF;
   END IF;
   CLOSE L_PRMT_CURSOR;
      
   
   
         
   L_RET_CODE := EVALUATEEQUIPMENT(L_PLANNED_EQ_TP, L_LAB, L_PLANNED_EQ, L_SQLERRM);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      L_SQLERRM := 'EvaluateEquipment failed:'||L_SQLERRM;
      RAISE STPERROR;
   END IF;
   
   
   
   
   FOR L_ROWS IN 1..L_NR_MEASUR LOOP
      A_MT_VERSION(L_ROWS) := L_MT_VERSION;
      A_DESCRIPTION(L_ROWS) := L_DESCRIPTION;
      A_VALUE_F(L_ROWS) := L_VALUE_F;
      A_VALUE_S(L_ROWS) := L_VALUE_S;
      A_UNIT(L_ROWS) := L_UNIT;
      A_EXEC_START_DATE(L_ROWS) := L_EXEC_START_DATE;
      A_EXEC_END_DATE(L_ROWS) := L_EXEC_END_DATE;
      A_EXECUTOR(L_ROWS) := L_EXECUTOR;
      A_LAB(L_ROWS) := L_LAB;
      A_EQ(L_ROWS) := L_EQ;
      IF L_EQ IS NOT NULL THEN
         A_EQ_VERSION(L_ROWS) := UNAPIGEN.VALIDATEVERSION('eq', L_EQ, L_EQ_VERSION);
      ELSE
         A_EQ_VERSION(L_ROWS) := NULL;
      END IF;      
      A_PLANNED_EXECUTOR(L_ROWS) := L_PLANNED_EXECUTOR;
      A_PLANNED_EQ(L_ROWS) := L_PLANNED_EQ;
      IF L_PLANNED_EQ IS NOT NULL THEN
         A_PLANNED_EQ_VERSION(L_ROWS) := UNAPIGEN.VALIDATEVERSION('eq', L_PLANNED_EQ, L_PLANNED_EQ_VERSION);
      ELSE
         A_PLANNED_EQ_VERSION(L_ROWS) := NULL;
      END IF;      
      A_MANUALLY_ENTERED(L_ROWS) := L_MANUALLY_ENTERED;
      A_ALLOW_ADD(L_ROWS) := L_ALLOW_ADD;
      A_ASSIGN_DATE(L_ROWS) := L_ASSIGN_DATE;
      A_ASSIGNED_BY(L_ROWS) := L_ASSIGNED_BY;
      A_MANUALLY_ADDED(L_ROWS) := L_MANUALLY_ADDED;
      A_DELAY(L_ROWS) := L_DELAY;
      A_DELAY_UNIT(L_ROWS) := L_DELAY_UNIT;
      A_FORMAT(L_ROWS) := L_FORMAT;
      A_ACCURACY(L_ROWS) := L_ACCURACY;
      A_REAL_COST(L_ROWS) := L_REAL_COST;
      A_REAL_TIME(L_ROWS) := L_REAL_TIME;
      A_CALIBRATION(L_ROWS) := L_CALIBRATION;
      A_CONFIRM_COMPLETE(L_ROWS) := L_CONFIRM_COMPLETE;
      A_AUTORECALC(L_ROWS) := L_AUTORECALC;
      A_ME_RESULT_EDITABLE(L_ROWS) := L_ME_RESULT_EDITABLE;
      A_NEXT_CELL(L_ROWS) := L_NEXT_CELL;
      A_SOP(L_ROWS) := L_SOP;
      A_SOP_VERSION(L_ROWS) := L_SOP_VERSION;
      A_PLAUS_LOW(L_ROWS) := L_PLAUS_LOW;
      A_PLAUS_HIGH(L_ROWS) := L_PLAUS_HIGH;
      A_WINSIZE_X(L_ROWS) := L_WINSIZE_X;
      A_WINSIZE_Y(L_ROWS) := L_WINSIZE_Y;
      A_REANALYSIS(L_ROWS) := L_REANALYSIS;
      A_ME_CLASS(L_ROWS) := L_ME_CLASS;
      A_LOG_HS(L_ROWS) := L_LOG_HS;
      A_LOG_HS_DETAILS(L_ROWS) := L_LOG_HS_DETAILS;
      A_LC(L_ROWS) := L_LC;
      IF L_LC IS NOT NULL THEN
         A_LC_VERSION(L_ROWS) := UNAPIGEN.VALIDATEVERSION('lc', L_LC, L_LC_VERSION);
      ELSE
         A_LC_VERSION(L_ROWS) := NULL;
      END IF;      
   END LOOP;
   
   
   
   
   IF L_NR_MEASUR > A_NR_OF_ROWS THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'InitScMethods','a_nr_of_rows ('||A_NR_OF_ROWS||
             ') too small for required Method initialisation');
   END IF;

   A_NR_OF_ROWS := L_NR_MEASUR;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SQLERRM;
      END IF;
      UNAPIGEN.U4ROLLBACK;      
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
              'InitScMethod', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF L_PRMT_CURSOR%ISOPEN THEN
         CLOSE L_PRMT_CURSOR;
      END IF;
      IF L_MT_CURSOR%ISOPEN THEN
         CLOSE L_MT_CURSOR;
      END IF;
      IF L_OBJECTS_CURSOR%ISOPEN THEN
         CLOSE L_OBJECTS_CURSOR;
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END INITSCMETHOD;

BEGIN
   P_SAVESCMECLVALUES_CALLS := 0;
   P_SAVESCMECL_CALLS := 0;
   P_SAVESCMECL_INSERT_EVENT := FALSE;
   
   OPEN C_SYSTEM('COPY_EST_COST');
   FETCH C_SYSTEM INTO P_COPY_EST_COST;
   IF C_SYSTEM%NOTFOUND THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'UNAPIME3.Initilisation', 'missing system setting: COPY_EST_COST');
      UNAPIGEN.U4COMMIT;
      CLOSE C_SYSTEM;
   END IF;
   CLOSE C_SYSTEM;

   OPEN C_SYSTEM('COPY_EST_TIME');
   FETCH C_SYSTEM INTO P_COPY_EST_TIME;
   IF C_SYSTEM%NOTFOUND THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'UNAPIME3.Initilisation', 'missing system setting: COPY_EST_TIME');
      UNAPIGEN.U4COMMIT;
      CLOSE C_SYSTEM;
   END IF;
   CLOSE C_SYSTEM;
   OPEN C_SYSTEM ('CLIENT_EVMGR_USED');
   FETCH C_SYSTEM INTO P_CLIENT_EVMGR_USED;
   IF C_SYSTEM%NOTFOUND THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'UNAPIME3.Initilisation', 'missing system setting: CLIENT_EVMGR_USED');
      UNAPIGEN.U4COMMIT;
      CLOSE C_SYSTEM;
   END IF;
   CLOSE C_SYSTEM;
   
END UNAPIME3;