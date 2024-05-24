PACKAGE BODY unapime2 AS

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

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION SUBSTITUTE_TILDES                           
(A_SC             IN     VARCHAR2,                   
 A_PG             IN     VARCHAR2,                   
 A_PA             IN     VARCHAR2,                   
 A_ME             IN     VARCHAR2,                   
 A_CELL           IN     VARCHAR2,                   
 A_STR            IN OUT VARCHAR2,                   
 A_STR_TP         IN     VARCHAR2)                   
RETURN NUMBER IS
L_STR VARCHAR2(20);
BEGIN
   L_STR := SQLSUBSTITUTETILDES(A_SC, A_PG, A_PA, A_ME, A_CELL, A_STR, A_STR_TP);
   A_STR := L_STR;
   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('Substitute_tildes',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'Substitute_tildes'));
END SUBSTITUTE_TILDES;

FUNCTION SQLSUBSTITUTETILDES                         
(A_SC             IN     VARCHAR2,                   
 A_PG             IN     VARCHAR2,                   
 A_PA             IN     VARCHAR2,                   
 A_ME             IN     VARCHAR2,                   
 A_CELL           IN     VARCHAR2,                   
 A_STR            IN     VARCHAR2,                   
 A_STR_TP         IN     VARCHAR2)                   
RETURN VARCHAR2 IS

L_POS1      INTEGER;
L_POS2      INTEGER;
L_POS3      INTEGER;
L_POS4      INTEGER;
L_POS5      INTEGER;
L_INDEX_X   NUMBER(3);
L_INDEX_Y   NUMBER(3);
L_TILDE_STR    VARCHAR2(20);
L_TILDE_SUBSTR VARCHAR2(20);
L_STR       VARCHAR2(20);

CURSOR L_CELLLIST_CURSOR IS
   SELECT VALUE_S
   FROM UTSCMECELLLIST
   WHERE SC = A_SC
   AND PG = A_PG
   AND PA = A_PA
   AND ME = A_ME
   AND CELL = L_TILDE_SUBSTR
   AND INDEX_X = L_INDEX_X
   AND INDEX_Y = L_INDEX_Y
   ORDER BY PGNODE,PANODE,MENODE;

CURSOR L_CELL_CURSOR IS
   SELECT VALUE_S
   FROM UTSCMECELL
   WHERE SC = A_SC
   AND PG = A_PG
   AND PA = A_PA
   AND ME = A_ME
   AND CELL = L_TILDE_STR
   ORDER BY PGNODE,PANODE,MENODE;

BEGIN
   L_STR := A_STR;
   L_POS1 := INSTR(L_STR, '~', 1);
   IF L_POS1 > 0 THEN
      L_POS2 := INSTR(L_STR, '~', L_POS1+1);
      IF L_POS2 > 0 THEN
         L_TILDE_STR := SUBSTR(L_STR, L_POS1+1, L_POS2-L_POS1-1);
         
         IF L_TILDE_STR = 'Current' THEN
            IF A_STR_TP = 'pg' THEN
               L_STR := A_PG;
            ELSIF A_STR_TP = 'pa' THEN
               L_STR := A_PA;
            ELSIF A_STR_TP = 'me' THEN
               L_STR := A_ME;



            ELSE
               
               NULL;
            END IF;
         ELSE
            
            L_POS3 := INSTR(L_TILDE_STR, '[');
            IF L_POS3 > 0 THEN
               
               
               L_TILDE_SUBSTR := SUBSTR(L_TILDE_STR, 1, L_POS3-1);
               L_POS4 := INSTR(L_TILDE_STR, ',', L_POS3);
               L_POS5 := INSTR(L_TILDE_STR, ']', L_POS3);
               BEGIN
               IF L_POS4 > 0 THEN
                  L_INDEX_X := TO_NUMBER(SUBSTR(L_TILDE_STR, L_POS3+1, L_POS3-L_POS4-1));
                  L_INDEX_Y := TO_NUMBER(SUBSTR(L_TILDE_STR, L_POS4+1, L_POS4-L_POS5-1));
               ELSE
                  L_INDEX_X := TO_NUMBER(SUBSTR(L_TILDE_STR, L_POS3+1, L_POS3-L_POS5-1));
                  L_INDEX_Y := 0;
               END IF;
               EXCEPTION
               WHEN VALUE_ERROR THEN
                  L_INDEX_X := 0;
                  L_INDEX_Y := 0;
               END;
               
               OPEN L_CELLLIST_CURSOR;
               IF L_CELLLIST_CURSOR%FOUND THEN
                  FETCH L_CELLLIST_CURSOR INTO L_STR;
                  CLOSE L_CELLLIST_CURSOR;
               ELSE
                  CLOSE L_CELLLIST_CURSOR;
                  L_INDEX_X := 0;
                  L_INDEX_Y := 0;
                  OPEN L_CELLLIST_CURSOR;
                  IF L_CELLLIST_CURSOR%FOUND THEN
                     FETCH L_CELLLIST_CURSOR INTO L_STR;
                  END IF;
                  CLOSE L_CELLLIST_CURSOR;
               END IF;
            ELSE
               
               OPEN L_CELL_CURSOR;
               IF L_CELL_CURSOR%FOUND THEN
                  FETCH L_CELL_CURSOR INTO L_STR;
               END IF;
               CLOSE L_CELL_CURSOR;
            END IF;
         END IF;
      ELSE
         NULL;
      END IF;
   ELSE
      NULL;
   END IF;
   RETURN (L_STR);
EXCEPTION
WHEN OTHERS THEN
   IF L_CELLLIST_CURSOR%ISOPEN THEN
      CLOSE L_CELLLIST_CURSOR;
   END IF;
   IF L_CELL_CURSOR%ISOPEN THEN
      CLOSE L_CELL_CURSOR;
   END IF;
   RAISE;
END SQLSUBSTITUTETILDES;

FUNCTION EVALUATEMECELLINPUT                              
(A_SC                   IN     VARCHAR2,                  
 A_PG                   IN     VARCHAR2,                  
 A_PGNODE               IN     NUMBER,                    
 A_PA                   IN     VARCHAR2,                  
 A_PANODE               IN     NUMBER,                    
 A_ME                   IN     VARCHAR2,                  
 A_MENODE               IN     NUMBER,                    
 A_REANALYSIS           IN     NUMBER,                    
 A_CELL                 IN     VARCHAR2,                  
 A_FORMAT               IN     VARCHAR2,                  
 A_INPUT_TP             IN     VARCHAR2,                  
 A_INPUT_SOURCE         IN     VARCHAR2,                  
 A_INPUT_VERSION        IN     VARCHAR2,                  
 A_INPUT_PP             IN OUT VARCHAR2,                  
 A_INPUT_PGNODE         IN OUT NUMBER,                    
 A_INPUT_PP_VERSION     IN OUT VARCHAR2,                  
 A_INPUT_PR             IN OUT VARCHAR2,                  
 A_INPUT_PANODE         IN OUT NUMBER,                    
 A_INPUT_PR_VERSION     IN OUT VARCHAR2,                  
 A_INPUT_MT             IN OUT VARCHAR2,                  
 A_INPUT_MENODE         IN OUT NUMBER,                    
 A_INPUT_MT_VERSION     IN OUT VARCHAR2,                  
 A_INPUT_REANALYSIS     IN OUT NUMBER)                    
RETURN NUMBER IS

L_VALUE_F                FLOAT;
L_VALUE_S                VARCHAR2(40);
L_EQ                     VARCHAR2(20);
L_LAB                    VARCHAR2(20);
L_MT_EQ                  VARCHAR2(20);
L_MT_LAB                 VARCHAR2(20);
L_MT_COUNT_EQLS          INTEGER;
L_CELL_EQ                VARCHAR2(20);
L_CELL_LAB               VARCHAR2(20);
L_CELL_COUNT_EQLS        INTEGER;
L_MTEQ_IN_EQLS           INTEGER;
L_UNIT                   VARCHAR2(20);
L_FORMAT                 VARCHAR2(40);
L_OLD_VALUE_F            FLOAT;
L_OLD_VALUE_S            VARCHAR2(40);
L_OLD_EQ                 VARCHAR2(20);
L_OLD_UNIT               VARCHAR2(20);
L_OLD_FORMAT             VARCHAR2(40);
L_CELL_VALUE_F           FLOAT;
L_CELL_VALUE_S           VARCHAR2(40);
L_CELL_UNIT              VARCHAR2(20);
L_CELL_FORMAT            VARCHAR2(40);
L_EVAL_DETAILS           BOOLEAN;
L_HS_DETAILS_SEQ_NR      INTEGER;
L_DEADLOCK_RAISED_ON_UPD_SCME    BOOLEAN;






CURSOR L_SCMERESULT_CURSOR (C_SC VARCHAR2, 
                            C_PG VARCHAR2, C_PGNODE NUMBER,
                            C_PA VARCHAR2, C_PANODE NUMBER,
                            C_ME VARCHAR2, C_MENODE NUMBER,
                            C_REANALYSIS NUMBER) IS
   SELECT VALUE_F, VALUE_S, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, UNIT, FORMAT
   FROM UTSCME A
   WHERE SC = C_SC
   AND PG = NVL(C_PG, PG)
   AND PGNODE = NVL(C_PGNODE, A.PGNODE)
   AND PA = NVL(C_PA, PA)
   AND PANODE = NVL(C_PANODE, A.PANODE)
   AND ME = C_ME
   AND MENODE = NVL(C_MENODE, A.MENODE)
   AND REANALYSIS = NVL(C_REANALYSIS, A.REANALYSIS)
   AND NVL(SS, '@~') <> '@C'
   AND EXEC_END_DATE IS NOT NULL
   ORDER BY ABS(DECODE(C_PG, NULL, 1, PGNODE - C_PGNODE)), ABS(DECODE(C_PA, NULL, 1, PANODE - C_PANODE)), EXEC_END_DATE DESC;






CURSOR L_SCPARESULT_CURSOR (C_SC VARCHAR2,
                            C_PG VARCHAR2, C_PGNODE NUMBER,
                            C_PA VARCHAR2, C_PANODE NUMBER,
                            C_REANALYSIS NUMBER) IS
   SELECT VALUE_F, VALUE_S, PG, PGNODE, PA, PANODE, REANALYSIS, UNIT, FORMAT
   FROM UTSCPA
   WHERE SC = C_SC
   AND PG = NVL(C_PG, PG)
   AND PGNODE = NVL(C_PGNODE, PGNODE)
   AND PA = C_PA
   AND PANODE = NVL(C_PANODE, PANODE)
   AND REANALYSIS = NVL(C_REANALYSIS, REANALYSIS)
   AND NVL(SS, '@~') <> '@C'
   AND EXEC_END_DATE IS NOT NULL
   ORDER BY ABS(DECODE(C_PG, NULL, 1, PGNODE - C_PGNODE)), EXEC_END_DATE DESC;

CURSOR L_EQCT_CURSOR (A_EQ VARCHAR2, A_LAB VARCHAR2, A_CT_NAME VARCHAR2) IS
   SELECT B.VALUE_F, B.VALUE_S, B.UNIT, B.FORMAT
   FROM UTEQCT B, UTEQ A
   WHERE A.EQ = A_EQ
     AND A.LAB = A_LAB
     AND B.EQ = A.EQ
     AND B.LAB = A.LAB
     AND B.CT_NAME = A_CT_NAME
     AND A.CA_WARN_LEVEL NOT IN (UNAPIGEN.TO_CALIBRATE, UNAPIGEN.OUT_OF_CALIBRATION);


CURSOR L_SCME_CURSOR IS
   SELECT *
   FROM UTSCME
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE;
L_SCME_REC      L_SCME_CURSOR%ROWTYPE;

CURSOR L_CELL_OLD_CURSOR IS
   SELECT VALUE_F, VALUE_S, EQ, UNIT, FORMAT 
   FROM UTSCMECELL
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE
   AND REANALYSIS = A_REANALYSIS
   AND CELL = A_CELL;
 
BEGIN

   L_HS_DETAILS_SEQ_NR := 0;
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_MENODE, 0) = 0 OR
      NVL(A_CELL, ' ') = ' ' OR
      A_REANALYSIS IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_INPUT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INPUTTP;
      RAISE STPERROR;
   END IF;

   OPEN L_SCME_CURSOR;
   FETCH L_SCME_CURSOR
   INTO L_SCME_REC;
   IF L_SCME_CURSOR%NOTFOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      CLOSE L_SCME_CURSOR;
      RAISE STPERROR;
   END IF;
   CLOSE L_SCME_CURSOR;
   
   IF L_SCME_REC.REANALYSIS <> A_REANALYSIS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTCURRENTMETHOD;
      RAISE STPERROR;   
   END IF;
   
   IF NVL(A_INPUT_TP, 'kb') <> 'kb' THEN

      

      
      IF A_INPUT_PP = '~Any~' THEN
         A_INPUT_PP := NULL;
      ELSIF A_INPUT_PP = '~Current~' THEN
         A_INPUT_PP := A_PG;
         A_INPUT_PGNODE := A_PGNODE;
      END IF;

      
      IF A_INPUT_PR = '~Any~' THEN
         A_INPUT_PR := NULL;
      ELSIF A_INPUT_PR = '~Current~' THEN
         A_INPUT_PR := A_PA;
         A_INPUT_PANODE := A_PANODE;
      END IF;

      
      IF A_INPUT_MT = '~Current~' THEN
         A_INPUT_MT := A_ME;
         A_INPUT_MENODE := A_MENODE;
      END IF;

      
      
      
      
      
      L_EVAL_DETAILS := FALSE;
      L_VALUE_F := NULL;
      L_VALUE_S := '';
      L_EQ := NULL;
      L_UNIT := '';
      L_FORMAT := '';

      
      
      
      IF A_INPUT_TP = 'mt' THEN
         OPEN L_SCMERESULT_CURSOR(A_SC, A_INPUT_PP, A_INPUT_PGNODE, A_INPUT_PR, A_INPUT_PANODE, 
                                  A_INPUT_MT, A_INPUT_MENODE, A_INPUT_REANALYSIS);
         FETCH L_SCMERESULT_CURSOR 
         INTO L_VALUE_F,L_VALUE_S, A_INPUT_PP, A_INPUT_PGNODE, A_INPUT_PR, A_INPUT_PANODE, 
              A_INPUT_MT, A_INPUT_MENODE, A_INPUT_REANALYSIS, L_UNIT, L_FORMAT;
         IF L_SCMERESULT_CURSOR%FOUND THEN        
            L_EVAL_DETAILS := TRUE;
         END IF;
         CLOSE L_SCMERESULT_CURSOR;
         
      
      
      
      ELSIF A_INPUT_TP = 'pr' THEN
         OPEN L_SCPARESULT_CURSOR(A_SC, A_INPUT_PP, A_INPUT_PGNODE, A_INPUT_PR, A_INPUT_PANODE, 
                                  A_INPUT_REANALYSIS);
         FETCH L_SCPARESULT_CURSOR 
         INTO L_VALUE_F,L_VALUE_S, A_INPUT_PP, A_INPUT_PGNODE, A_INPUT_PR, A_INPUT_PANODE, 
              A_INPUT_REANALYSIS, L_UNIT, L_FORMAT;
         IF L_SCPARESULT_CURSOR%FOUND THEN         
            L_EVAL_DETAILS := TRUE;
         END IF;
         CLOSE L_SCPARESULT_CURSOR;

      
      
      
      ELSIF A_INPUT_TP = 'eq' THEN
      
         
         IF L_SCME_REC.LAB IS NULL THEN
            IF UNAPIGEN.P_LAB IS NOT NULL THEN
               L_MT_LAB := UNAPIGEN.P_LAB;
               L_CELL_LAB := UNAPIGEN.P_LAB;
               L_LAB := UNAPIGEN.P_LAB;
            END IF;
         ELSE
            L_MT_LAB := L_SCME_REC.LAB;
            L_CELL_LAB := L_SCME_REC.LAB;         
            L_LAB := L_SCME_REC.LAB;
         END IF;
         
         
         IF L_SCME_REC.EQ IS NOT NULL THEN
            L_MT_EQ := L_SCME_REC.EQ;
         ELSE
            L_MT_EQ := L_SCME_REC.PLANNED_EQ;
            
            
            IF L_MT_EQ IS NULL THEN
               
               
               
               
               BEGIN
                  SELECT MAX(EQ.EQ), MAX(EQ.LAB)
                  INTO L_MT_EQ, L_MT_LAB
                  FROM UTEQ EQ, UTEQTYPE TP
                  WHERE TP.EQ_TP IN (SELECT DISTINCT EQ_TP
                                     FROM UTMTCELLEQTYPE
                                     WHERE MT = A_ME
                                       AND VERSION = L_SCME_REC.MT_VERSION
                                       AND CELL = A_ME)     
                  AND TP.EQ = EQ.EQ
                  AND TP.VERSION = EQ.VERSION
                  AND TP.LAB = EQ.LAB
                  AND EQ.LAB = NVL(L_MT_LAB, EQ.LAB)
                  HAVING COUNT(DISTINCT(EQ.EQ||'#'||EQ.LAB))=1;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  L_MT_EQ := NULL;
                  L_MT_LAB := NULL;
                  
                  SELECT COUNT(DISTINCT(EQ.EQ||'#'||EQ.LAB))
                  INTO L_MT_COUNT_EQLS
                  FROM UTEQ EQ, UTEQTYPE TP
                  WHERE TP.EQ_TP IN (SELECT DISTINCT EQ_TP
                                     FROM UTMTCELLEQTYPE
                                     WHERE MT = A_ME
                                       AND VERSION = L_SCME_REC.MT_VERSION
                                       AND CELL = A_ME)     
                  AND TP.EQ = EQ.EQ
                  AND TP.VERSION = EQ.VERSION
                  AND TP.LAB = EQ.LAB
                  AND EQ.LAB = NVL(L_MT_LAB, EQ.LAB);
               END;               
            END IF;
         END IF;
         
         
         L_CELL_COUNT_EQLS := 0;
         L_CELL_EQ := NULL;
         BEGIN
            SELECT MAX(EQ.EQ) CELL_EQ, 
                   MAX(EQ.LAB) CELL_LAB,
                   COUNT(DISTINCT(EQ.EQ||'#'||EQ.LAB)) CELL_COUNT_EQLS, 
                   MAX(DECODE(EQ.EQ, L_MT_EQ, 1, 0)) MTEQ_IN_EQLS
            INTO L_CELL_EQ, L_CELL_LAB, L_CELL_COUNT_EQLS, L_MTEQ_IN_EQLS
            FROM UTEQ EQ, UTEQTYPE TP
            WHERE TP.EQ_TP IN (SELECT DISTINCT EQ_TP
                               FROM UTMTCELLEQTYPE
                               WHERE MT = A_ME
                                 AND VERSION = L_SCME_REC.MT_VERSION
                                 AND CELL = A_CELL)     
              AND TP.EQ = EQ.EQ
              AND TP.VERSION = EQ.VERSION
              AND TP.LAB = EQ.LAB
              AND EQ.LAB = NVL(L_CELL_LAB, EQ.LAB);
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            L_CELL_EQ := NULL;
            L_CELL_LAB := NULL;
            L_CELL_COUNT_EQLS := 0;
            L_MTEQ_IN_EQLS := 0;
         END;               
               
         IF L_MT_EQ IS NULL THEN
            
            IF L_CELL_COUNT_EQLS = 0 THEN
               IF L_MT_COUNT_EQLS = 0 THEN
                  
                  INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
                  VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                         'EvaluateMeCellInput','Warning! No equipment type specified for cell "'||A_CELL||
                         '" in method "'||A_ME||'"');        
               END IF;
            ELSIF L_CELL_COUNT_EQLS = 1 THEN
               
               L_EQ := L_CELL_EQ;
               L_LAB := L_CELL_LAB;
            ELSE
               
               L_EQ := NULL;   
               L_LAB := NULL;
            END IF;
         ELSE
            
            IF L_CELL_COUNT_EQLS = 0 THEN
               
               L_EQ := L_MT_EQ;
               L_LAB := L_MT_LAB;
            ELSIF L_CELL_COUNT_EQLS = 1 THEN
               
               
               L_EQ := L_CELL_EQ;
               L_LAB := L_CELL_LAB;
            ELSE
               
               IF L_MTEQ_IN_EQLS = 1 THEN
                  L_EQ := L_MT_EQ;              
                  L_LAB := L_MT_LAB;
               ELSE
                  L_EQ := NULL;      
                  L_LAB := NULL;
               END IF;
            END IF;         
         END IF;
         
         IF L_EQ IS NOT NULL THEN
            OPEN L_EQCT_CURSOR(L_EQ, L_LAB, A_INPUT_SOURCE);
            FETCH L_EQCT_CURSOR
            INTO L_VALUE_F, L_VALUE_S, L_UNIT, L_FORMAT;
            IF L_EQCT_CURSOR%FOUND THEN         
               L_EVAL_DETAILS := TRUE;
            END IF;                    
            CLOSE L_EQCT_CURSOR;
         END IF;

      
      
      
      ELSIF A_INPUT_TP = 'me' THEN

         IF A_INPUT_SOURCE = 'description' THEN
            L_VALUE_S := L_SCME_REC.DESCRIPTION;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'mt_version' THEN
            L_VALUE_S := L_SCME_REC.MT_VERSION;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'unit' THEN
            L_VALUE_S := L_SCME_REC.UNIT;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'exec_start_date' THEN
            L_VALUE_S := TO_CHAR(L_SCME_REC.EXEC_START_DATE, SUBSTR(A_FORMAT,2));
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'exec_end_date' THEN
            L_VALUE_S := TO_CHAR(L_SCME_REC.EXEC_END_DATE, SUBSTR(A_FORMAT,2));
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'executor' THEN
            L_VALUE_S := L_SCME_REC.EXECUTOR;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'lab' THEN
            L_VALUE_S := L_SCME_REC.LAB;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'eq' THEN
            L_VALUE_S := L_SCME_REC.EQ;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'planned_executor' THEN
            L_VALUE_S := L_SCME_REC.PLANNED_EXECUTOR;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'planned_eq' THEN
            L_VALUE_S := L_SCME_REC.PLANNED_EQ;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'delay' THEN
            L_VALUE_S := NULL;
            L_VALUE_F := L_SCME_REC.DELAY;
         ELSIF A_INPUT_SOURCE = 'delay_unit' THEN
            L_VALUE_S  := L_SCME_REC.DELAY_UNIT;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'format' THEN
            L_VALUE_S  := L_SCME_REC.FORMAT;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'accuracy' THEN
            L_VALUE_S := NULL;
            L_VALUE_F := L_SCME_REC.ACCURACY;
         ELSIF A_INPUT_SOURCE = 'real_cost' THEN
            L_VALUE_S  := L_SCME_REC.REAL_COST;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'real_time' THEN
            L_VALUE_S  := L_SCME_REC.REAL_TIME;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'sop' THEN
            L_VALUE_S  := L_SCME_REC.SOP;
            L_VALUE_F := NULL;
         ELSIF A_INPUT_SOURCE = 'plaus_low' THEN
            L_VALUE_S := NULL;
            L_VALUE_F := L_SCME_REC.PLAUS_LOW;
         ELSIF A_INPUT_SOURCE = 'plaus_high' THEN
            L_VALUE_S := NULL;
            L_VALUE_F := L_SCME_REC.PLAUS_HIGH;
         ELSIF A_INPUT_SOURCE = 'me_class' THEN
            L_VALUE_S  := L_SCME_REC.ME_CLASS;
            L_VALUE_F := NULL;
         ELSE
            L_SQLERRM := A_INPUT_SOURCE || ' is not a valid method standard property for cell ' ||
                A_CELL || '#sc=' || A_SC || '#menode=' ||
                TO_CHAR(A_MENODE) || '#me=' || A_ME;
            RAISE STPERROR;
         END IF;

         L_EVAL_DETAILS := TRUE;

         
         
         IF SUBSTR(A_FORMAT,1,1)='C' THEN
            IF L_VALUE_S IS NULL AND L_VALUE_F IS NOT NULL THEN
               L_VALUE_S := L_VALUE_F; 
            END IF;
            IF LENGTH(A_FORMAT)>1 THEN
               L_VALUE_S := SUBSTR(L_VALUE_S,1,SUBSTR(A_FORMAT,2));
               L_VALUE_F := NULL;
            ELSE
               
               L_VALUE_F := NULL;
            END IF;
         
         ELSIF SUBSTR(A_FORMAT,1,1)='D' THEN
            
            NULL;
         
         ELSE
            L_RET_CODE := UNAPIGEN.FORMATRESULT(L_VALUE_F, A_FORMAT, L_VALUE_S);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
               VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
               'EvaluateMeCellInput',          
               'Warning#FormatResult returned ' || TO_CHAR(L_RET_CODE) ||
               '#value_s=' || L_VALUE_S ||
               '#value_f=' || L_VALUE_F ||
               '#format=' || A_FORMAT ||
               '#cell=' || A_CELL ||
               '#sc=' || A_SC || 
               '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
               '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
               '#me=' || A_ME || '#menode=' || TO_CHAR(A_MENODE));
            END IF;
         END IF;
      END IF;

      BEGIN
         
         INSERT INTO UTSCMECELLINPUT(SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, 
                                     INPUT_TP, INPUT_SOURCE, INPUT_VERSION,
                                     INPUT_PG, INPUT_PGNODE, INPUT_PP_VERSION, 
                                     INPUT_PA, INPUT_PANODE, INPUT_PR_VERSION, 
                                     INPUT_ME, INPUT_MENODE, INPUT_MT_VERSION,
                                     INPUT_REANALYSIS)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_REANALYSIS, A_CELL, 
                A_INPUT_TP, A_INPUT_SOURCE, A_INPUT_VERSION,
                A_INPUT_PP, A_INPUT_PGNODE, A_INPUT_PP_VERSION,
                A_INPUT_PR, A_INPUT_PANODE, A_INPUT_PR_VERSION,
                A_INPUT_MT, A_INPUT_MENODE, A_INPUT_MT_VERSION,
                A_INPUT_REANALYSIS);
      EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         UPDATE UTSCMECELLINPUT
         SET INPUT_PG = A_INPUT_PP,
             INPUT_PGNODE = A_INPUT_PGNODE,
             INPUT_PP_VERSION = A_INPUT_PP_VERSION,
             INPUT_PA = A_INPUT_PR,
             INPUT_PANODE = A_INPUT_PANODE,
             INPUT_PR_VERSION = A_INPUT_PR_VERSION,
             INPUT_ME = A_INPUT_MT,
             INPUT_MENODE = A_INPUT_MENODE,
             INPUT_MT_VERSION = A_INPUT_MT_VERSION,
             INPUT_REANALYSIS = A_INPUT_REANALYSIS
         WHERE SC = A_SC
           AND PG = A_PG
           AND PGNODE = A_PGNODE
           AND PA = A_PA
           AND PANODE = A_PANODE
           AND ME = A_ME
           AND MENODE = A_MENODE
           AND REANALYSIS = A_REANALYSIS
           AND CELL = A_CELL;
      END;
      

      
      IF L_EVAL_DETAILS THEN
         
         
         
         OPEN L_CELL_OLD_CURSOR;
         FETCH L_CELL_OLD_CURSOR INTO L_OLD_VALUE_F, L_OLD_VALUE_S, L_OLD_EQ, L_OLD_UNIT, L_OLD_FORMAT;
         IF L_CELL_OLD_CURSOR%NOTFOUND THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
            RAISE STPERROR;
         END IF;
         CLOSE L_CELL_OLD_CURSOR;

         
         
         
         L_CELL_UNIT := L_OLD_UNIT;
         L_CELL_FORMAT := L_OLD_FORMAT;
         L_RET_CODE := UNAPIGEN.TRANSFORMRESULT(L_VALUE_S,
                                                L_VALUE_F,      
                                                L_UNIT,    
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
             EQ = L_EQ,
             UNIT = L_UNIT,
             FORMAT = L_FORMAT
         WHERE SC = A_SC
         AND PG = A_PG
         AND PGNODE = A_PGNODE
         AND PA = A_PA
         AND PANODE = A_PANODE
         AND ME = A_ME
         AND MENODE = A_MENODE
         AND REANALYSIS = A_REANALYSIS
         AND CELL = A_CELL;

         L_DEADLOCK_RAISED_ON_UPD_SCME := FALSE;
         BEGIN 
            
            
            
            
            IF NVL(L_LAB, '#') <> NVL(L_SCME_REC.LAB, '-') THEN
               UPDATE UTSCME
               SET LAB = L_LAB
               WHERE SC = A_SC
                 AND PG = A_PG
                 AND PGNODE = A_PGNODE
                 AND PA = A_PA
                 AND PANODE = A_PANODE
                 AND ME = A_ME
                 AND MENODE = A_MENODE;
               IF L_SCME_REC.LOG_HS_DETAILS = '1' THEN
                  L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
                  L_EV_SEQ_NR := NVL(UNAPIEV.P_EV_REC.EV_SEQ, -1);
                  INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                              EV_SEQ, SEQ, DETAILS)
                  VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                         UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                         'method "'||A_ME||'" is updated: property <lab> changed value from "' || L_SCME_REC.LAB || '" to "' || L_LAB || '".');
               END IF;
            END IF;      
         EXCEPTION
         WHEN OTHERS THEN
            IF SQLCODE<>-60 THEN
               RAISE; 
            ELSE
               L_DEADLOCK_RAISED_ON_UPD_SCME := TRUE;
            END IF;
         END; 
   

         L_EVENT_TP := 'EvaluateMeDetails';
         L_EV_SEQ_NR := -1;
         L_EV_DETAILS := 'sc=' || A_SC ||
                         '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                         '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                         '#menode=' || TO_CHAR(A_MENODE) ||
                         '#reanalysis=' || TO_CHAR(A_REANALYSIS) || 
                         '#cell=' || A_CELL || 
                         '#mt_version=' || L_SCME_REC.MT_VERSION;
         IF L_DEADLOCK_RAISED_ON_UPD_SCME THEN
            L_EV_DETAILS := L_EV_DETAILS || '#updmelab=' || L_LAB;
         END IF;

         L_RESULT := UNAPIEV.INSERTEVENT('EvaluateMeCellInput', 
                                          UNAPIGEN.P_EVMGR_NAME, 'me',
                                          A_ME, NULL, NULL, NULL,
                                          L_EVENT_TP, L_EV_DETAILS,
                                          L_EV_SEQ_NR);

         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
         END IF;

         
         
         
         IF L_SCME_REC.LOG_HS_DETAILS = '1' THEN
            IF NVL((L_OLD_VALUE_F <> L_VALUE_F), TRUE) AND 
               NOT(L_OLD_VALUE_F IS NULL AND L_VALUE_F IS NULL)  THEN 
               L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                           EV_SEQ, SEQ, DETAILS)
               VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                      UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                      'method cell "'||A_CELL||'" is updated: property <value_f> changed value from "' || L_OLD_VALUE_F || '" to "' || L_VALUE_F || '".');
            END IF;
            
            IF NVL((L_OLD_VALUE_S <> L_VALUE_S), TRUE) AND 
               NOT(L_OLD_VALUE_S IS NULL AND L_VALUE_S IS NULL)  THEN 
               L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                           EV_SEQ, SEQ, DETAILS)
               VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                      UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                      'method cell "'||A_CELL||'" is updated: property <value_s> changed value from "' || L_OLD_VALUE_S || '" to "' || L_VALUE_S || '".');
            END IF;

            IF NVL((L_OLD_EQ <> L_EQ), TRUE) AND 
               NOT(L_OLD_EQ IS NULL AND L_EQ IS NULL)  THEN 
               L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                           EV_SEQ, SEQ, DETAILS)
               VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                      UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                      'method cell "'||A_CELL||'" is updated: property <eq> changed value from "' || L_OLD_EQ || '" to "' || L_EQ || '".');
            END IF;

            IF NVL((L_OLD_UNIT <> L_UNIT), TRUE) AND 
               NOT(L_OLD_UNIT IS NULL AND L_UNIT IS NULL)  THEN 
               L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                           EV_SEQ, SEQ, DETAILS)
               VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                      UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                      'method cell "'||A_CELL||'" is updated: property <unit> changed value from "' || L_OLD_UNIT || '" to "' || L_UNIT || '".');
            END IF;

            IF NVL((L_OLD_FORMAT <> L_FORMAT), TRUE) AND 
               NOT(L_OLD_FORMAT IS NULL AND L_FORMAT IS NULL)  THEN 
               L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                           EV_SEQ, SEQ, DETAILS)
               VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                      UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                      'method cell "'||A_CELL||'" is updated: property <format> changed value from "' || L_OLD_FORMAT || '" to "' || L_FORMAT || '".');
            END IF;
         END IF;
      END IF;

   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('EvaluateMeCellInput',SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('EvaluateMeCellInput',L_SQLERRM);   
   END IF;
   IF L_SCMERESULT_CURSOR%ISOPEN THEN
      CLOSE L_SCMERESULT_CURSOR;
   END IF;
   IF L_SCPARESULT_CURSOR%ISOPEN THEN
      CLOSE L_SCPARESULT_CURSOR;
   END IF;
   IF L_EQCT_CURSOR%ISOPEN THEN
      CLOSE L_EQCT_CURSOR;
   END IF;
   IF L_SCME_CURSOR%ISOPEN THEN
      CLOSE L_SCME_CURSOR;
   END IF;
   IF L_CELL_OLD_CURSOR%ISOPEN THEN
      CLOSE L_CELL_OLD_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'EvaluateMeCellInput'));
END EVALUATEMECELLINPUT;

FUNCTION CREATESCMEDETAILS                                           
(A_SC                            IN        VARCHAR2,                 
 A_PG                            IN        VARCHAR2,                 
 A_PGNODE                        IN        NUMBER,                   
 A_PA                            IN        VARCHAR2,                 
 A_PANODE                        IN        NUMBER,                   
 A_ME                            IN        VARCHAR2,                 
 A_MENODE                        IN        NUMBER,                   
 A_REANALYSIS                    IN        NUMBER,                   
 A_ROLLBACK_ON_DETAILSEXIST      IN        CHAR)                     
RETURN NUMBER IS

L_LC                             VARCHAR2(2);
L_LC_VERSION                     VARCHAR2(20);
L_SS                             VARCHAR2(2);
L_LOG_HS                         CHAR(1);
L_LOG_HS_DETAILS                 CHAR(1);
L_ALLOW_MODIFY                   CHAR(1);
L_ACTIVE                         CHAR(1);
L_MTCELL_REC                     UTMTCELL%ROWTYPE;
L_CNT                            NUMBER(4);
L_CNT_CURRENT                    NUMBER(4);
L_FOUND                          BOOLEAN;
L_VALUE_F                        FLOAT;
L_VALUE_S                        VARCHAR2(40);
L_PG                             VARCHAR2(20);
L_PGNODE                         NUMBER(9);
L_PA                             VARCHAR2(20);
L_PANODE                         NUMBER(9);
L_ME                             VARCHAR2(20);
L_MENODE                         NUMBER(9);
L_NEXT_CELL                      VARCHAR2(20);
L_DATE_CURSOR                    INTEGER;
L_DATE                           TIMESTAMP WITH TIME ZONE;
L_INPUT_PGNODE                   NUMBER(9);
L_INPUT_PANODE                   NUMBER(9);
L_INPUT_MENODE                   NUMBER(9);
L_INPUT_REANALYSIS               NUMBER(3);
L_HS_DETAILS_SEQ_NR              INTEGER;
L_MT_VERSION                     VARCHAR2(20);
L_LAB                            VARCHAR2(20);
L_SAVE_EQ                        VARCHAR2(20);
L_DEADLOCK_RAISED_ON_UPD_SCME    BOOLEAN;

CURSOR L_MTCELL_CURSOR (A_MT VARCHAR2, A_MT_VERSION VARCHAR2) IS
   SELECT *
   FROM UTMTCELL
   WHERE MT = A_MT
   AND VERSION = A_MT_VERSION
   ORDER BY SEQ;

CURSOR L_MTCELLLIST_CURSOR (A_MT VARCHAR2, A_MT_VERSION VARCHAR2) IS
   SELECT A.CELL, A.INDEX_X, A.INDEX_Y, A.VALUE_F, A.VALUE_S, A.SELECTED
   FROM UTMTCELLLIST A, UTMTCELL B
   WHERE A.MT = A_MT
     AND A.VERSION = A_MT_VERSION
     AND A.MT = B.MT
     AND A.VERSION = B.VERSION
     AND A.CELL = B.CELL;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
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

   
   
   
   BEGIN
      SELECT COUNT(*), COUNT(DECODE(REANALYSIS,A_REANALYSIS,1,NULL)), MT_VERSION
      INTO L_CNT, L_CNT_CURRENT, L_MT_VERSION
      FROM UTSCME
      WHERE SC = A_SC
        AND PG = A_PG
        AND PGNODE = A_PGNODE
        AND PA = A_PA
        AND PANODE = A_PANODE
        AND ME = A_ME
        AND MENODE = A_MENODE
      GROUP BY MT_VERSION; 
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      L_CNT := 0;
   END;

   IF NVL(L_CNT, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;

   IF NVL(L_CNT_CURRENT, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTCURRENTMETHOD;
      RAISE STPERROR;
   END IF;

   
   
   
   SELECT COUNT(*)
   INTO L_CNT
   FROM UTSCMECELL
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE
     AND ME = A_ME
     AND MENODE = A_MENODE
     AND REANALYSIS = A_REANALYSIS;

   IF NVL(L_CNT, 0) > 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_DETAILSEXIST;
      RAISE STPERROR;
   END IF;

   
   
   
   FOR L_MTCELL_REC IN L_MTCELL_CURSOR(A_ME, L_MT_VERSION) LOOP
      L_FOUND := TRUE;
      
      
      
      INSERT INTO UTSCMECELL(SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS,
                             CELL, CELLNODE, 
                             DSP_TITLE, 
                             CELL_TP,POS_X, POS_Y, 
                             ALIGN, WINSIZE_X, WINSIZE_Y, 
                             IS_PROTECTED, MANDATORY, HIDDEN, 
                             UNIT, FORMAT, CALC_TP, CALC_FORMULA,
                             VALID_CF, MAX_X, MAX_Y, COMPONENT,
                             MULTI_SELECT)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_REANALYSIS,
             L_MTCELL_REC.CELL, L_MTCELL_REC.SEQ * UNAPIGEN.DEFAULT_NODE_INTERVAL,
             L_MTCELL_REC.DSP_TITLE,
             L_MTCELL_REC.CELL_TP, L_MTCELL_REC.POS_X, L_MTCELL_REC.POS_Y, 
             L_MTCELL_REC.ALIGN, L_MTCELL_REC.WINSIZE_X, L_MTCELL_REC.WINSIZE_Y,
             L_MTCELL_REC.IS_PROTECTED, L_MTCELL_REC.MANDATORY, L_MTCELL_REC.HIDDEN,
             L_MTCELL_REC.UNIT, L_MTCELL_REC.FORMAT, L_MTCELL_REC.CALC_TP, L_MTCELL_REC.CALC_FORMULA,
             L_MTCELL_REC.VALID_CF, L_MTCELL_REC.MAX_X, L_MTCELL_REC.MAX_Y, L_MTCELL_REC.COMPONENT,
             L_MTCELL_REC.MULTI_SELECT);

      
      
      
      IF L_MTCELL_REC.DEF_VAL_TP IN ('F','A') THEN
         L_SQLERRM := NULL;
         BEGIN
            L_PG := A_PG;
            L_PGNODE := A_PGNODE;
            L_PA := A_PA;
            L_PANODE := A_PANODE;
            L_ME := A_ME;
            L_MENODE := A_MENODE;

            L_RET_CODE := UNAPIMEP.FILLMEDEFAULTVALUE(A_SC, L_PG, L_PGNODE,
                                           L_PA, L_PANODE, L_ME,
                                           L_MENODE, L_MTCELL_REC.DEF_VAL_TP,
                                           L_MTCELL_REC.VALUE_S,
                                           L_MTCELL_REC.DEF_AU_LEVEL,
                                           L_MTCELL_REC.FORMAT,
                                           L_VALUE_F, L_VALUE_S);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               L_SQLERRM := SUBSTR('Warning#FillMeDefaultValue returned ' || TO_CHAR(L_RET_CODE)||
                                   '#def_val_tp=' || L_MTCELL_REC.DEF_VAL_TP ||
                                   '#value_s=' || L_MTCELL_REC.VALUE_S ||
                                   '#def_au_level=' || L_MTCELL_REC.DEF_AU_LEVEL ||
                                   '#format=' || L_MTCELL_REC.FORMAT ||
                                   '#cell=' || L_MTCELL_REC.CELL ||
                                   'sc=' || A_SC || 
                                   '#pg=' || L_PG || '#pgnode=' || TO_CHAR(L_PGNODE) ||
                                   '#pa=' || L_PA || '#panode=' || TO_CHAR(L_PANODE) ||
                                   '#me=' || L_ME || '#menode=' || TO_CHAR(L_MENODE),
                                   1, 255);
            END IF;
         EXCEPTION 
         WHEN OTHERS THEN
            L_SQLERRM := 'Warning#FillMeDefaultValue raised SqlCode=' || TO_CHAR(SQLCODE) ||
                      '#def_val_tp=' || L_MTCELL_REC.DEF_VAL_TP ||
                      '#value_s=' || L_MTCELL_REC.VALUE_S ||
                      '#def_au_level=' || L_MTCELL_REC.DEF_AU_LEVEL ||
                      '#format=' || L_MTCELL_REC.FORMAT ||
                      '#cell=' || L_MTCELL_REC.CELL ||
                      '#sc=' || A_SC || 
                      '#pg=' || L_PG || '#pgnode=' || TO_CHAR(L_PGNODE) ||
                      '#pa=' || L_PA || '#panode=' || TO_CHAR(L_PANODE) ||
                      '#me=' || L_ME || '#menode=' || TO_CHAR(L_MENODE);
         END;
      END IF;
      
      IF L_SQLERRM IS NOT NULL THEN
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'CreateScMeDetails', L_SQLERRM);
      END IF;
      
      UPDATE UTSCMECELL
      SET VALUE_S = L_VALUE_S,
          VALUE_F = L_VALUE_F
      WHERE SC = A_SC
        AND PG = A_PG
        AND PGNODE = A_PGNODE
        AND PA = A_PA
        AND PANODE = A_PANODE
        AND ME = A_ME
        AND MENODE = A_MENODE
        AND REANALYSIS = A_REANALYSIS
        AND CELL = L_MTCELL_REC.CELL;

      
      
      
      
      L_INPUT_PGNODE := NULL;
      L_INPUT_PANODE := NULL;
      L_INPUT_MENODE := NULL;      
      L_INPUT_REANALYSIS := NULL;

      L_RET_CODE := UNAPIME2.EVALUATEMECELLINPUT(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, 
                                                 A_MENODE, A_REANALYSIS, L_MTCELL_REC.CELL,
                                                 L_MTCELL_REC.FORMAT, L_MTCELL_REC.INPUT_TP, 
                                                 L_MTCELL_REC.INPUT_SOURCE, L_MTCELL_REC.INPUT_SOURCE_VERSION,
                                                 L_MTCELL_REC.INPUT_PP, L_INPUT_PGNODE, L_MTCELL_REC.INPUT_PP_VERSION,
                                                 L_MTCELL_REC.INPUT_PR, L_INPUT_PANODE, L_MTCELL_REC.INPUT_PR_VERSION,
                                                 L_MTCELL_REC.INPUT_MT, L_INPUT_MENODE, L_MTCELL_REC.INPUT_MT_VERSION,
                                                 L_INPUT_REANALYSIS);

      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         L_SQLERRM := 'Warning#EvaluateMeCellInput returned ' || TO_CHAR(L_RET_CODE)||
                      '#cell=' || L_MTCELL_REC.CELL ||
                      'sc=' || A_SC || 
                      '#pg=' || L_PG || '#pgnode=' || TO_CHAR(L_PGNODE) ||
                      '#pa=' || L_PA || '#panode=' || TO_CHAR(L_PANODE) ||
                      '#me=' || L_ME || '#menode=' || TO_CHAR(L_MENODE);
         
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;
      
      
      
      
      IF NVL(L_MTCELL_REC.SAVE_TP, ' ') <> ' ' THEN

         
         SELECT LAB
         INTO L_LAB
         FROM UTSCME
         WHERE SC = A_SC
           AND PG = A_PG
           AND PGNODE = A_PGNODE
           AND PA = A_PA
           AND PANODE = A_PANODE
           AND ME = A_ME
           AND MENODE = A_MENODE;
           
         L_RET_CODE := UNAPIME3.EVALUATEEQUIPMENT(L_MTCELL_REC.SAVE_EQ_TP, L_LAB, L_SAVE_EQ, L_SQLERRM);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
            L_SQLERRM := 'EvaluateEquipment failed for cell:'||L_MTCELL_REC.CELL||'#mt='||A_ME||':'||SUBSTR(L_SQLERRM,1,150);
            RAISE STPERROR;
         END IF;           
         
         INSERT INTO UTSCMECELLOUTPUT(SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS,
                                      CELL, SAVE_TP, SAVE_PG, SAVE_PA, SAVE_ME,
                                      SAVE_EQ, SAVE_ID, CREATE_NEW)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_REANALYSIS,
                L_MTCELL_REC.CELL, L_MTCELL_REC.SAVE_TP, L_MTCELL_REC.SAVE_PP,
                L_MTCELL_REC.SAVE_PR, L_MTCELL_REC.SAVE_MT, L_SAVE_EQ,
                L_MTCELL_REC.SAVE_ID, L_MTCELL_REC.CREATE_NEW);
      END IF;
   END LOOP;

   
   
   
   FOR L_MTCELLLIST IN L_MTCELLLIST_CURSOR (A_ME, L_MT_VERSION) LOOP
      L_FOUND := TRUE;

      INSERT INTO UTSCMECELLLIST(SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS,
                                 CELL, INDEX_X, INDEX_Y, VALUE_F, VALUE_S, SELECTED)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_REANALYSIS,
             L_MTCELLLIST.CELL, L_MTCELLLIST.INDEX_X, L_MTCELLLIST.INDEX_Y,
             L_MTCELLLIST.VALUE_F, L_MTCELLLIST.VALUE_S, L_MTCELLLIST.SELECTED);
   END LOOP;

   IF NOT L_FOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;

   OPEN UNAPIME.C_FIRST_EMPTY_CELL_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE,
                                          A_ME, A_MENODE);
   FETCH UNAPIME.C_FIRST_EMPTY_CELL_CURSOR INTO L_NEXT_CELL;
   IF UNAPIME.C_FIRST_EMPTY_CELL_CURSOR%NOTFOUND THEN
      L_NEXT_CELL := NULL;
   END IF;
   CLOSE UNAPIME.C_FIRST_EMPTY_CELL_CURSOR;

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   L_DEADLOCK_RAISED_ON_UPD_SCME := FALSE;
   BEGIN 
      UPDATE UTSCME
      SET NEXT_CELL = L_NEXT_CELL
      WHERE SC = A_SC AND PG = A_PG AND PGNODE = A_PGNODE
        AND PA = A_PA AND PANODE = A_PANODE
        AND ME = A_ME AND MENODE = A_MENODE;

   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE<>-60 THEN
         RAISE; 
      ELSE
         L_DEADLOCK_RAISED_ON_UPD_SCME := TRUE;
      END IF;
   END; 

   
   
   
   L_EVENT_TP := 'MeDetailsCreated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'sc=' || A_SC ||
                   '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                   '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                   '#menode=' || TO_CHAR(A_MENODE) || 
                   '#reanalysis=' || TO_CHAR(A_REANALYSIS) ||
                   '#mt_version=' || L_MT_VERSION;
   IF L_DEADLOCK_RAISED_ON_UPD_SCME THEN
      L_EV_DETAILS := L_EV_DETAILS || '#updnextce=1';
   END IF;
   L_RESULT := UNAPIEV.INSERTEVENT('CreateScMeDetails', UNAPIGEN.P_EVMGR_NAME,
                                   'me', A_ME, L_LC, L_LC_VERSION, L_SS,
                                   L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
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
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTSCMEHS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, WHO, WHO_DESCRIPTION, WHAT, 
                           WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, UNAPIGEN.P_USER, 
             UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
             'method "'||A_ME||'" cells are created.',
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   L_HS_DETAILS_SEQ_NR := 0;
   IF L_LOG_HS_DETAILS = '1' THEN
      L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
      INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
      VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
             UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
             'method "'||A_ME||'" cells are created.');
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   
   
   
   
   IF L_MTCELL_CURSOR%ISOPEN THEN
      CLOSE L_MTCELL_CURSOR;
   END IF;
   IF L_MTCELLLIST_CURSOR%ISOPEN THEN
      CLOSE L_MTCELLLIST_CURSOR;
   END IF;
   IF UNAPIME.C_FIRST_EMPTY_CELL_CURSOR%ISOPEN THEN
      CLOSE UNAPIME.C_FIRST_EMPTY_CELL_CURSOR;
   END IF;
   L_RESULT := UNAPIGEN.ENDTXN; 
   RETURN(UNAPIGEN.DBERR_SUCCESS);
WHEN OTHERS THEN
   IF UNAPIGEN.P_TXN_ERROR = UNAPIGEN.DBERR_DETAILSEXIST THEN
      NULL; 
   ELSE
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('CreateScMeDetails',SQLERRM);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIGEN.LOGERROR('CreateScMeDetails',L_SQLERRM);   
      END IF;
   END IF;
   IF L_MTCELL_CURSOR%ISOPEN THEN
      CLOSE L_MTCELL_CURSOR;
   END IF;
   IF L_MTCELLLIST_CURSOR%ISOPEN THEN
      CLOSE L_MTCELLLIST_CURSOR;
   END IF;
   IF UNAPIME.C_FIRST_EMPTY_CELL_CURSOR%ISOPEN THEN
      CLOSE UNAPIME.C_FIRST_EMPTY_CELL_CURSOR;
   END IF;
   IF UNAPIGEN.P_TXN_ERROR = UNAPIGEN.DBERR_DETAILSEXIST THEN
      IF A_ROLLBACK_ON_DETAILSEXIST = '1' THEN
         RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CreateScMeDetails'));
      ELSE
         L_RESULT := UNAPIGEN.ENDTXN; 
         RETURN(UNAPIGEN.DBERR_SUCCESS);
      END IF;
   ELSE
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CreateScMeDetails'));
   END IF;
END CREATESCMEDETAILS;

FUNCTION CREATESCMEDETAILS                            
(A_SC             IN        VARCHAR2,                 
 A_PG             IN        VARCHAR2,                 
 A_PGNODE         IN        NUMBER,                   
 A_PA             IN        VARCHAR2,                 
 A_PANODE         IN        NUMBER,                   
 A_ME             IN        VARCHAR2,                 
 A_MENODE         IN        NUMBER,                   
 A_REANALYSIS     IN        NUMBER)                   
RETURN NUMBER IS
BEGIN
   RETURN(CREATESCMEDETAILS(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_REANALYSIS, '1')); 
END;

FUNCTION UPDATELINKEDSCMECELL                         
(A_SC                          IN     VARCHAR2,       
 A_PG                          IN     VARCHAR2,       
 A_PGNODE                      IN     NUMBER,         
 A_PA                          IN     VARCHAR2,       
 A_PANODE                      IN     NUMBER,         
 A_ME                          IN     VARCHAR2,       
 A_MENODE                      IN     NUMBER,         
 A_ME_STD_PROPERTY             IN     VARCHAR2,       
 A_MT_VERSION                  IN     VARCHAR2,       
 A_DESCRIPTION                 IN     VARCHAR2,       
 A_UNIT                        IN     VARCHAR2,       
 A_EXEC_START_DATE             IN     DATE,           
 A_EXEC_END_DATE               IN     DATE,           
 A_EXECUTOR                    IN     VARCHAR2,       
 A_LAB                         IN     VARCHAR2,       
 A_EQ                          IN     VARCHAR2,       
 A_EQ_VERSION                  IN     VARCHAR2,       
 A_PLANNED_EXECUTOR            IN     VARCHAR2,       
 A_PLANNED_EQ                  IN     VARCHAR2,       
 A_PLANNED_EQ_VERSION          IN     VARCHAR2,       
 A_DELAY                       IN     NUMBER,         
 A_DELAY_UNIT                  IN     VARCHAR2,       
 A_FORMAT                      IN     VARCHAR2,       
 A_ACCURACY                    IN     FLOAT,          
 A_REAL_COST                   IN     VARCHAR2,       
 A_REAL_TIME                   IN     VARCHAR2,       
 A_SOP                         IN     VARCHAR2,       
 A_SOP_VERSION                 IN     VARCHAR2,       
 A_PLAUS_LOW                   IN     FLOAT,          
 A_PLAUS_HIGH                  IN     FLOAT,          
 A_ME_CLASS                    IN     VARCHAR2)       
RETURN NUMBER IS

L_ME_PROP_VALUE_S     VARCHAR2(40);
L_ME_PROP_VALUE_F     FLOAT;
L_OLD_ME_PROP_VALUE_S VARCHAR2(40);
L_OLD_ME_PROP_VALUE_F FLOAT;
L_HS_DETAILS_SEQ_NR   INTEGER;
L_LOG_HS_DETAILS      CHAR(1);

CURSOR L_SCMECELL_CURSOR(C_SC VARCHAR2, C_PG VARCHAR2, C_PGNODE NUMBER,
                         C_PA VARCHAR2, C_PANODE NUMBER,
                         C_ME VARCHAR2, C_MENODE NUMBER, C_ME_STD_PROPERTY VARCHAR2) IS
   SELECT A.INPUT_SOURCE, B.*
   FROM UTSCMECELLINPUT A, UTSCMECELL B
   WHERE A.SC = C_SC
     AND A.PG = C_PG
     AND A.PGNODE = C_PGNODE
     AND A.PA = C_PA
     AND A.PANODE = C_PANODE
     AND A.ME = C_ME
     AND A.MENODE = C_MENODE
     AND A.SC = B.SC
     AND A.PG = B.PG
     AND A.PGNODE = B.PGNODE
     AND A.PA = B.PA
     AND A.PANODE = B.PANODE
     AND A.ME = B.ME
     AND A.MENODE = B.MENODE
     AND A.CELL = B.CELL
     AND A.INPUT_TP = 'me'
     AND A.INPUT_SOURCE = NVL(C_ME_STD_PROPERTY, A.INPUT_SOURCE);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_ME, ' ') = ' ' OR
      NVL(A_MENODE, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_HS_DETAILS_SEQ_NR := 0;
   
   
   
   
   
   FOR L_SCMECELL_REC IN L_SCMECELL_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE,
                                           A_ME, A_MENODE, A_ME_STD_PROPERTY) LOOP

      IF L_SCMECELL_REC.INPUT_SOURCE = 'description' THEN
         L_ME_PROP_VALUE_S := A_DESCRIPTION;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'unit' THEN
         L_ME_PROP_VALUE_S  := A_UNIT;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'exec_start_date' THEN
         L_ME_PROP_VALUE_S  := TO_CHAR(A_EXEC_START_DATE, SUBSTR(L_SCMECELL_REC.FORMAT,2));
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'exec_end_date' THEN
         L_ME_PROP_VALUE_S  := TO_CHAR(A_EXEC_END_DATE, SUBSTR(L_SCMECELL_REC.FORMAT,2));
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'executor' THEN
         L_ME_PROP_VALUE_S  := A_EXECUTOR;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'lab' THEN
         L_ME_PROP_VALUE_S  := A_LAB;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'eq' THEN
         L_ME_PROP_VALUE_S  := A_EQ;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'planned_executor' THEN
         L_ME_PROP_VALUE_S  := A_PLANNED_EXECUTOR;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'planned_eq' THEN
         L_ME_PROP_VALUE_S  := A_PLANNED_EQ;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'delay' THEN
         L_ME_PROP_VALUE_F := A_DELAY;
         L_RET_CODE := UNAPIGEN.FORMATRESULT(L_ME_PROP_VALUE_F, L_SCMECELL_REC.FORMAT, L_ME_PROP_VALUE_S);
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'delay_unit' THEN
         L_ME_PROP_VALUE_S  := A_DELAY_UNIT;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'format' THEN
         L_ME_PROP_VALUE_S  := A_FORMAT;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'accuracy' THEN
         L_ME_PROP_VALUE_F := A_ACCURACY;
         L_RET_CODE := UNAPIGEN.FORMATRESULT(L_ME_PROP_VALUE_F, L_SCMECELL_REC.FORMAT, L_ME_PROP_VALUE_S);
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'real_cost' THEN
         L_ME_PROP_VALUE_S  := A_REAL_COST;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'real_time' THEN
         L_ME_PROP_VALUE_S  := A_REAL_TIME;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'sop' THEN
         L_ME_PROP_VALUE_S  := A_SOP;
         L_ME_PROP_VALUE_F := NULL;
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'plaus_low' THEN
         L_ME_PROP_VALUE_F := A_PLAUS_LOW;
         L_RET_CODE := UNAPIGEN.FORMATRESULT(L_ME_PROP_VALUE_F, L_SCMECELL_REC.FORMAT, L_ME_PROP_VALUE_S);
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'plaus_high' THEN
         L_ME_PROP_VALUE_F := A_PLAUS_HIGH;
         L_RET_CODE := UNAPIGEN.FORMATRESULT(L_ME_PROP_VALUE_F, L_SCMECELL_REC.FORMAT, L_ME_PROP_VALUE_S);
      ELSIF L_SCMECELL_REC.INPUT_SOURCE = 'me_class' THEN
         L_ME_PROP_VALUE_S  := A_ME_CLASS;
         L_ME_PROP_VALUE_F := NULL;
      ELSE
         L_SQLERRM := L_SCMECELL_REC.INPUT_SOURCE || ' is not a valid method standard property for cell ' ||
                      L_SCMECELL_REC.CELL || '#sc=' ||L_SCMECELL_REC.SC || '#menode=' ||
                      TO_CHAR(L_SCMECELL_REC.MENODE) || '#me=' || L_SCMECELL_REC.ME;
         RAISE STPERROR;
      END IF;

      
      
      
      SELECT LOG_HS_DETAILS
      INTO L_LOG_HS_DETAILS
      FROM UTSCME
      WHERE SC = L_SCMECELL_REC.SC 
        AND PG = L_SCMECELL_REC.PG
        AND PGNODE = L_SCMECELL_REC.PGNODE
        AND PA = L_SCMECELL_REC.PA
        AND PANODE = L_SCMECELL_REC.PANODE
        AND ME = L_SCMECELL_REC.ME
        AND MENODE = L_SCMECELL_REC.MENODE;

      
      
      
      SELECT VALUE_F, VALUE_S
      INTO L_OLD_ME_PROP_VALUE_F, L_OLD_ME_PROP_VALUE_S
      FROM UTSCMECELL
      WHERE SC = L_SCMECELL_REC.SC 
        AND PG = L_SCMECELL_REC.PG
        AND PGNODE = L_SCMECELL_REC.PGNODE
        AND PA = L_SCMECELL_REC.PA
        AND PANODE = L_SCMECELL_REC.PANODE
        AND ME = L_SCMECELL_REC.ME
        AND MENODE = L_SCMECELL_REC.MENODE
        AND CELL = L_SCMECELL_REC.CELL
        AND CELLNODE = L_SCMECELL_REC.CELLNODE;

      UPDATE UTSCMECELL
      SET VALUE_S = L_ME_PROP_VALUE_S,
          VALUE_F = L_ME_PROP_VALUE_F
      WHERE SC = L_SCMECELL_REC.SC 
        AND PG = L_SCMECELL_REC.PG
        AND PGNODE = L_SCMECELL_REC.PGNODE
        AND PA = L_SCMECELL_REC.PA
        AND PANODE = L_SCMECELL_REC.PANODE
        AND ME = L_SCMECELL_REC.ME
        AND MENODE = L_SCMECELL_REC.MENODE
        AND CELL = L_SCMECELL_REC.CELL
        AND CELLNODE = L_SCMECELL_REC.CELLNODE;

      
      
      
      IF L_LOG_HS_DETAILS = '1' THEN
         L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
         IF L_RET_CODE <> 0 THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;

         IF NVL((L_OLD_ME_PROP_VALUE_F <> L_ME_PROP_VALUE_F), TRUE) AND 
            NOT(L_OLD_ME_PROP_VALUE_F IS NULL AND L_ME_PROP_VALUE_F IS NULL)  THEN 
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                        EV_SEQ, SEQ, DETAILS)
            VALUES(L_SCMECELL_REC.SC, L_SCMECELL_REC.PG, L_SCMECELL_REC.PGNODE, L_SCMECELL_REC.PA, 
                   L_SCMECELL_REC.PANODE, L_SCMECELL_REC.ME, L_SCMECELL_REC.MENODE, 
                   UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                   'method cell "'||L_SCMECELL_REC.CELL||'" is updated: property <value_f> changed value from "' || L_OLD_ME_PROP_VALUE_F || '" to "' || L_ME_PROP_VALUE_F || '".');
         END IF;
            
         IF NVL((L_OLD_ME_PROP_VALUE_S <> L_ME_PROP_VALUE_S), TRUE) AND 
            NOT(L_OLD_ME_PROP_VALUE_S IS NULL AND L_ME_PROP_VALUE_S IS NULL)  THEN 
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, TR_SEQ, 
                                        EV_SEQ, SEQ, DETAILS)
            VALUES(L_SCMECELL_REC.SC, L_SCMECELL_REC.PG, L_SCMECELL_REC.PGNODE, L_SCMECELL_REC.PA, 
                   L_SCMECELL_REC.PANODE, L_SCMECELL_REC.ME, L_SCMECELL_REC.MENODE, 
                   UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                   'method cell "'||L_SCMECELL_REC.CELL||'" is updated: property <value_s> changed value from "' || L_OLD_ME_PROP_VALUE_S || '" to "' || L_ME_PROP_VALUE_S || '".');
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
      UNAPIGEN.LOGERROR('UpdateLinkedScMeCell', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('UpdateLinkedScMeCell', L_SQLERRM);   
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'UpdateLinkedScMeCell'));
END UPDATELINKEDSCMECELL;

FUNCTION GETSCREMETHOD                                     
(A_SC                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE               OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE               OUT     UNAPIGEN.LONG_TABLE_TYPE,  
 A_ME                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_MENODE               OUT     UNAPIGEN.LONG_TABLE_TYPE,  
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
 A_ALLOW_MODIFY         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ACTIVE               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LC                   OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_LC_VERSION           OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_SS                   OUT     UNAPIGEN.VC2_TABLE_TYPE,   
 A_REANALYSEDRESULT     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NR_OF_ROWS           IN OUT  NUMBER,                    
 A_WHERE_CLAUSE         IN      VARCHAR2)                  
RETURN NUMBER IS

L_SC                      VARCHAR2(20);
L_PG                      VARCHAR2(20);
L_PGNODE                  NUMBER(9);
L_PA                      VARCHAR2(20);
L_PANODE                  NUMBER(9);
L_ME                      VARCHAR2(20);
L_MENODE                  NUMBER(9);
L_MT_VERSION              VARCHAR2(20);
L_DESCRIPTION             VARCHAR2(40);
L_VALUE_F                 FLOAT;
L_VALUE_S                 VARCHAR2(40);
L_UNIT                    VARCHAR2(20);
L_EXEC_START_DATE         TIMESTAMP WITH TIME ZONE;
L_EXEC_END_DATE           TIMESTAMP WITH TIME ZONE;
L_EXECUTOR                VARCHAR2(20);
L_LAB                     VARCHAR2(20);
L_EQ                      VARCHAR2(20);
L_EQ_VERSION              VARCHAR2(20);
L_PLANNED_EXECUTOR        VARCHAR2(20);
L_PLANNED_EQ              VARCHAR2(20);
L_PLANNED_EQ_VERSION      VARCHAR2(20);
L_MANUALLY_ENTERED        CHAR(1);
L_ALLOW_ADD               CHAR(1);
L_ASSIGN_DATE             TIMESTAMP WITH TIME ZONE;
L_ASSIGNED_BY             VARCHAR2(20);
L_MANUALLY_ADDED          CHAR(1);
L_DELAY                   NUMBER(3);
L_DELAY_UNIT              VARCHAR2(20);
L_FORMAT                  VARCHAR2(40);
L_ACCURACY                FLOAT;
L_REAL_COST               VARCHAR2(40);
L_REAL_TIME               VARCHAR2(40);
L_CALIBRATION             CHAR(1);
L_CONFIRM_COMPLETE        CHAR(1);
L_AUTORECALC              CHAR(1);
L_ME_RESULT_EDITABLE      CHAR(1);
L_NEXT_CELL               VARCHAR2(20);
L_SOP                     VARCHAR2(40);
L_SOP_VERSION             VARCHAR2(20);
L_PLAUS_LOW               FLOAT;
L_PLAUS_HIGH              FLOAT;
L_WINSIZE_X               NUMBER(4);
L_WINSIZE_Y               NUMBER(4);
L_REANALYSIS              NUMBER(3);
L_ME_CLASS                VARCHAR2(2);
L_LOG_HS                  CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_ALLOW_MODIFY            CHAR(1);
L_ACTIVE                  CHAR(1);
L_LC                      VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_ME_CURSOR               INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS, 0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
   ELSIF
      UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := 'WHERE sc = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' ORDER BY sc, pgnode, panode, menode, reanalysis';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_ME_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'SELECT sc, pg, pgnode, pa, panode, me, menode, mt_version, ' ||
                   'description, value_f, value_s, unit, exec_start_date, ' ||
                   'exec_end_date, executor, lab, eq, eq_version, planned_executor, planned_eq,' ||
                   'planned_eq_version, manually_entered, allow_add, assign_date, assigned_by, ' ||
                   'manually_added,delay, delay_unit, format, ' ||
                   'accuracy, real_cost, real_time, calibration, ' ||
                   'confirm_complete, autorecalc, me_result_editable, next_cell, sop,'||
                   'sop_version, plaus_low, plaus_high, winsize_x, winsize_y, reanalysis, ' ||
                   'me_class, log_hs, log_hs_details, allow_modify, active, lc, lc_version, ss ' ||
                   'FROM dd' || UNAPIGEN.P_DD || '.uvrscme ' || L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_ME_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      1, L_SC, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      2, L_PG, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      3, L_PGNODE);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      4, L_PA, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      5, L_PANODE);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      6, L_ME, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      7, L_MENODE);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      8, L_MT_VERSION, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      9, L_DESCRIPTION, 40);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      10, L_VALUE_F);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      11, L_VALUE_S, 40);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      12, L_UNIT, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      13, L_EXEC_START_DATE);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      14, L_EXEC_END_DATE);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      15, L_EXECUTOR, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      16, L_LAB, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      17, L_EQ, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      18, L_EQ_VERSION, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      19, L_PLANNED_EXECUTOR, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      20, L_PLANNED_EQ, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      21, L_PLANNED_EQ_VERSION, 20);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_ME_CURSOR, 22, L_MANUALLY_ENTERED, 1);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_ME_CURSOR, 23, L_ALLOW_ADD, 1);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      24, L_ASSIGN_DATE);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      25, L_ASSIGNED_BY, 20);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_ME_CURSOR, 26, L_MANUALLY_ADDED, 1);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      27, L_DELAY);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      28, L_DELAY_UNIT, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      29, L_FORMAT, 40);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      30, L_ACCURACY);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      31, L_REAL_COST, 40);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      32, L_REAL_TIME, 40);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_ME_CURSOR, 33, L_CALIBRATION, 1);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_ME_CURSOR, 34, L_CONFIRM_COMPLETE, 1);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_ME_CURSOR, 35, L_AUTORECALC, 1);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_ME_CURSOR, 36, L_ME_RESULT_EDITABLE, 1);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      37, L_NEXT_CELL, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      38, L_SOP, 40);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      39, L_SOP_VERSION, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      40, L_PLAUS_LOW);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      41, L_PLAUS_HIGH);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      42, L_WINSIZE_X);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      43, L_WINSIZE_Y);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      44, L_REANALYSIS);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      45, L_ME_CLASS, 2);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_ME_CURSOR, 46, L_LOG_HS, 1);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_ME_CURSOR, 47, L_LOG_HS_DETAILS, 1);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_ME_CURSOR, 48, L_ALLOW_MODIFY, 1);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_ME_CURSOR, 49, L_ACTIVE, 1);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      50, L_LC, 2);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      51, L_LC_VERSION, 20);
   DBMS_SQL.DEFINE_COLUMN(L_ME_CURSOR,      52, L_SS, 2);
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_ME_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      1, L_SC);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      2, L_PG);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      3, L_PGNODE);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      4, L_PA);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      5, L_PANODE);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      6, L_ME);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      7, L_MENODE);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      8, L_MT_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      9, L_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      10, L_VALUE_F);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      11, L_VALUE_S);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      12, L_UNIT);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      13, L_EXEC_START_DATE);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      14, L_EXEC_END_DATE);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      15, L_EXECUTOR);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      16, L_LAB);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      17, L_EQ);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      18, L_EQ_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      19, L_PLANNED_EXECUTOR);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      20, L_PLANNED_EQ);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      21, L_PLANNED_EQ_VERSION);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_ME_CURSOR, 22, L_MANUALLY_ENTERED);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_ME_CURSOR, 23, L_ALLOW_ADD);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      24, L_ASSIGN_DATE);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      25, L_ASSIGNED_BY);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_ME_CURSOR, 26, L_MANUALLY_ADDED);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      27, L_DELAY);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      28, L_DELAY_UNIT);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      29, L_FORMAT);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      30, L_ACCURACY);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      31, L_REAL_COST);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      32, L_REAL_TIME);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_ME_CURSOR, 33, L_CALIBRATION);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_ME_CURSOR, 34, L_CONFIRM_COMPLETE);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_ME_CURSOR, 35, L_AUTORECALC);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_ME_CURSOR, 36, L_ME_RESULT_EDITABLE);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      37, L_NEXT_CELL);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      38, L_SOP);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      39, L_SOP_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      40, L_PLAUS_LOW);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      41, L_PLAUS_HIGH);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      42, L_WINSIZE_X);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      43, L_WINSIZE_Y);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      44, L_REANALYSIS);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      45, L_ME_CLASS);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_ME_CURSOR, 46, L_LOG_HS);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_ME_CURSOR, 47, L_LOG_HS_DETAILS);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_ME_CURSOR, 48, L_ALLOW_MODIFY);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_ME_CURSOR, 49, L_ACTIVE);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      50, L_LC);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      51, L_LC_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_ME_CURSOR,      52, L_SS);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_SC(L_FETCHED_ROWS) := L_SC;
      A_PG(L_FETCHED_ROWS) := L_PG;
      A_PGNODE(L_FETCHED_ROWS) := L_PGNODE;
      A_PA(L_FETCHED_ROWS) := L_PA;
      A_PANODE(L_FETCHED_ROWS) := L_PANODE;
      A_ME(L_FETCHED_ROWS) := L_ME;
      A_MENODE(L_FETCHED_ROWS) := L_MENODE;
      A_MT_VERSION(L_FETCHED_ROWS) := L_MT_VERSION;
      A_DESCRIPTION(L_FETCHED_ROWS) := L_DESCRIPTION;
      A_VALUE_F(L_FETCHED_ROWS) := L_VALUE_F;
      A_VALUE_S(L_FETCHED_ROWS) := L_VALUE_S;
      A_UNIT(L_FETCHED_ROWS) := L_UNIT;
      A_EXEC_START_DATE(L_FETCHED_ROWS) := L_EXEC_START_DATE;
      A_EXEC_END_DATE(L_FETCHED_ROWS) := L_EXEC_END_DATE;
      A_EXECUTOR(L_FETCHED_ROWS) := L_EXECUTOR;
      A_LAB(L_FETCHED_ROWS) := L_LAB;
      A_EQ(L_FETCHED_ROWS) := L_EQ;
      A_EQ_VERSION(L_FETCHED_ROWS) := L_EQ_VERSION;
      A_PLANNED_EXECUTOR(L_FETCHED_ROWS) := L_PLANNED_EXECUTOR;
      A_PLANNED_EQ(L_FETCHED_ROWS) := L_PLANNED_EQ;
      A_PLANNED_EQ_VERSION(L_FETCHED_ROWS) := L_PLANNED_EQ_VERSION;
      A_MANUALLY_ENTERED(L_FETCHED_ROWS) := L_MANUALLY_ENTERED;
      A_ALLOW_ADD(L_FETCHED_ROWS) := L_ALLOW_ADD;
      A_ASSIGN_DATE(L_FETCHED_ROWS) := L_ASSIGN_DATE;
      A_ASSIGNED_BY(L_FETCHED_ROWS) := L_ASSIGNED_BY;
      A_MANUALLY_ADDED(L_FETCHED_ROWS) := L_MANUALLY_ADDED;
      A_DELAY(L_FETCHED_ROWS) := L_DELAY;
      A_DELAY_UNIT(L_FETCHED_ROWS) := L_DELAY_UNIT;
      A_FORMAT(L_FETCHED_ROWS) := L_FORMAT;
      A_ACCURACY(L_FETCHED_ROWS) := L_ACCURACY;
      A_REAL_COST(L_FETCHED_ROWS) := L_REAL_COST;
      A_REAL_TIME(L_FETCHED_ROWS) := L_REAL_TIME;
      A_CALIBRATION(L_FETCHED_ROWS) := L_CALIBRATION;
      A_CONFIRM_COMPLETE(L_FETCHED_ROWS) := L_CONFIRM_COMPLETE;
      A_AUTORECALC(L_FETCHED_ROWS) := L_AUTORECALC;
      A_ME_RESULT_EDITABLE(L_FETCHED_ROWS) := L_ME_RESULT_EDITABLE;
      A_NEXT_CELL(L_FETCHED_ROWS) := L_NEXT_CELL;
      A_SOP(L_FETCHED_ROWS) := L_SOP;
      A_SOP_VERSION(L_FETCHED_ROWS) := L_SOP_VERSION;
      A_PLAUS_LOW(L_FETCHED_ROWS) := L_PLAUS_LOW;
      A_PLAUS_HIGH(L_FETCHED_ROWS) := L_PLAUS_HIGH;
      A_WINSIZE_X(L_FETCHED_ROWS) := L_WINSIZE_X;
      A_WINSIZE_Y(L_FETCHED_ROWS) := L_WINSIZE_Y;
      A_REANALYSIS(L_FETCHED_ROWS) := L_REANALYSIS;
      A_ME_CLASS(L_FETCHED_ROWS) := L_ME_CLASS;
      A_LOG_HS(L_FETCHED_ROWS) := L_LOG_HS;
      A_LOG_HS_DETAILS(L_FETCHED_ROWS) := L_LOG_HS_DETAILS;
      A_ALLOW_MODIFY(L_FETCHED_ROWS) := L_ALLOW_MODIFY;
      A_ACTIVE(L_FETCHED_ROWS) := L_ACTIVE;
      A_LC(L_FETCHED_ROWS) := L_LC;
      A_LC_VERSION(L_FETCHED_ROWS) := L_LC_VERSION;
      A_SS(L_FETCHED_ROWS) := L_SS;
      A_REANALYSEDRESULT(L_FETCHED_ROWS) := '1';
      
      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_ME_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_ME_CURSOR);

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
              'GetScReMethod', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(L_ME_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_ME_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETSCREMETHOD;

FUNCTION GETSCMEDEFAULTRESULT                            
(A_SC               IN      UNAPIGEN.VC20_TABLE_TYPE,    
 A_PG               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,    
 A_PGNODE           IN OUT  UNAPIGEN.LONG_TABLE_TYPE,    
 A_PA               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,    
 A_PANODE           IN OUT  UNAPIGEN.LONG_TABLE_TYPE,    
 A_ME               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,    
 A_MENODE           IN OUT  UNAPIGEN.LONG_TABLE_TYPE,    
 A_VALUE_F          OUT     UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_VALUE_S          OUT     UNAPIGEN.VC40_TABLE_TYPE,    
 A_NR_OF_ROWS       IN      NUMBER)                      
RETURN NUMBER IS

L_PG               VARCHAR2(20);
L_PGNODE           NUMBER(9);
L_PA               VARCHAR2(20);
L_PANODE           NUMBER(9);
L_ME               VARCHAR2(20);
L_MENODE           NUMBER(9);
L_EQ               VARCHAR2(20);
L_VALUE_F          FLOAT;
L_FORMAT           VARCHAR2(40);
L_VALUE_S          VARCHAR2(40);
L_DEF_VAL_TP       CHAR(1);
L_DEF_VAL          VARCHAR2(40);
L_DEF_AU_LEVEL     VARCHAR2(4);
L_FETCHED_ROWS     NUMBER;
L_MT_VERSION       VARCHAR2(20);

CURSOR L_MT_VERSION_CURSOR(A_SC VARCHAR2, 
                           A_PG VARCHAR2, A_PGNODE NUMBER,
                           A_PA VARCHAR2, A_PANODE NUMBER,
                           A_ME VARCHAR2, A_MENODE NUMBER) IS
   SELECT MT_VERSION
   FROM UTSCME
   WHERE SC = A_SC
   AND PG = A_PG
   AND PGNODE = A_PGNODE
   AND PA = A_PA
   AND PANODE = A_PANODE
   AND ME = A_ME
   AND MENODE = A_MENODE;

CURSOR L_MT_CURSOR(A_MT VARCHAR2, A_MT_VERSION VARCHAR2) IS
   SELECT DEF_VAL_TP, DEF_VAL, DEF_AU_LEVEL, FORMAT
   FROM UTMT
   WHERE MT = A_MT
   AND VERSION = A_MT_VERSION;

BEGIN
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;
   L_FETCHED_ROWS := 0;
   
   FOR L_ROWS IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_SC(L_ROWS), ' ') = ' ' OR
         NVL(A_PG(L_ROWS), ' ') = ' ' OR
         NVL(A_PA(L_ROWS), ' ') = ' ' OR
         NVL(A_ME(L_ROWS), ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_NOOBJID);
      END IF;

      OPEN L_MT_VERSION_CURSOR(A_SC(L_ROWS),
                               A_PG(L_ROWS), A_PGNODE(L_ROWS),
                               A_PA(L_ROWS), A_PANODE(L_ROWS),
                               A_ME(L_ROWS), A_MENODE(L_ROWS));
      FETCH L_MT_VERSION_CURSOR INTO L_MT_VERSION;
      CLOSE L_MT_VERSION_CURSOR;

      OPEN L_MT_CURSOR(A_ME(L_ROWS), L_MT_VERSION);
      FETCH L_MT_CURSOR
      INTO L_DEF_VAL_TP, L_DEF_VAL, L_DEF_AU_LEVEL, L_FORMAT;
      IF L_MT_CURSOR%NOTFOUND THEN
         CLOSE L_MT_CURSOR;
         RETURN(UNAPIGEN.DBERR_NOOBJECT);
      END IF;
      CLOSE L_MT_CURSOR;
      L_PG := A_PG(L_ROWS);
      L_PGNODE := A_PGNODE(L_ROWS);
      L_PA := A_PA(L_ROWS);
      L_PANODE := A_PANODE(L_ROWS);
      L_ME := A_ME(L_ROWS);
      L_MENODE := A_MENODE(L_ROWS);
      L_SQLERRM := NULL;
      BEGIN
         L_RET_CODE := UNAPIMEP.FILLMEDEFAULTVALUE(A_SC(L_ROWS), L_PG,
                                        L_PGNODE, L_PA, L_PANODE, L_ME,
                                        L_MENODE, L_DEF_VAL_TP,
                                        L_DEF_VAL, L_DEF_AU_LEVEL, L_FORMAT,
                                        L_VALUE_F, L_VALUE_S);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'Warning#FillMeDefaultValue returned ' || TO_CHAR(L_RET_CODE)||
                         '#def_val_tp=' || L_DEF_VAL_TP ||
                         '#value_s=' || L_VALUE_S ||
                         '#def_au_level=' || L_DEF_AU_LEVEL ||
                         '#format=' || L_FORMAT ||
                         'sc=' || A_SC(L_ROWS) || 
                         '#pg=' || L_PG || '#pgnode=' || TO_CHAR(L_PGNODE) ||
                         '#pa=' || L_PA || '#panode=' || TO_CHAR(L_PANODE) ||
                         '#me=' || L_ME || '#menode=' || TO_CHAR(L_MENODE);
         END IF;  
      EXCEPTION
      WHEN OTHERS THEN
         L_SQLERRM := 'Warning#FillMeDefaultValue returned ' || TO_CHAR(L_RET_CODE)||
                      '#def_val_tp=' || L_DEF_VAL_TP ||
                      '#value_s=' || L_VALUE_S ||
                      '#def_au_level=' || L_DEF_AU_LEVEL ||
                      '#format=' || L_FORMAT ||
                      'sc=' || A_SC(L_ROWS) || 
                      '#pg=' || L_PG || '#pgnode=' || TO_CHAR(L_PGNODE) ||
                      '#pa=' || L_PA || '#panode=' || TO_CHAR(L_PANODE) ||
                      '#me=' || L_ME || '#menode=' || TO_CHAR(L_MENODE);
      END;
      
      IF L_SQLERRM IS NOT NULL THEN
         INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
               'GetScMeDefaultResult', L_SQLERRM);
      END IF;
      
      A_VALUE_S(L_ROWS) := L_VALUE_S;
      A_VALUE_F(L_ROWS) := L_VALUE_F;
      
   END LOOP;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(UNAPIGEN.DBERR_NORECORDS);
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
            'GetScMeDefaultResult', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF L_MT_CURSOR%ISOPEN THEN
         CLOSE L_MT_CURSOR;
      END IF;
      IF L_MT_VERSION_CURSOR%ISOPEN THEN
         CLOSE L_MT_VERSION_CURSOR;
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETSCMEDEFAULTRESULT;

END UNAPIME2;