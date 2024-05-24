PACKAGE BODY unapipa2 AS

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(2000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_TIMED_EVENT_TP  UTEVTIMED.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
L_EV_DETAILS      VARCHAR2(255);
L_ERRM            VARCHAR2(255);
STPERROR          EXCEPTION;

P_SCPARESULT_RECURSIVE   CHAR(1);

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_21.00');
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

FUNCTION CREATESCPADETAILS                            
(A_ST             IN        VARCHAR2,                 
 A_ST_VERSION     IN OUT    VARCHAR2,                 
 A_PP             IN        VARCHAR2,                 
 A_PP_VERSION     IN OUT    VARCHAR2,                 
 A_PP_KEY1        IN        VARCHAR2,                 
 A_PP_KEY2        IN        VARCHAR2,                 
 A_PP_KEY3        IN        VARCHAR2,                 
 A_PP_KEY4        IN        VARCHAR2,                 
 A_PP_KEY5        IN        VARCHAR2,                  
 A_PR             IN        VARCHAR2,                 
 A_PR_VERSION     IN OUT    VARCHAR2,                 
 A_SEQ            IN        NUMBER,                   
 A_SC             IN        VARCHAR2,                 
 A_PG             IN        VARCHAR2,                 
 A_PGNODE         IN        NUMBER,                   
 A_PANODE         IN        NUMBER,                   
 A_FILTER_FREQ    IN        CHAR,                     
 A_REF_DATE       IN        DATE,                     
 A_MT             IN        VARCHAR2,                 
 A_MT_VERSION     IN OUT    VARCHAR2,                 
 A_MT_NR_MEASUR   IN        NUMBER,                    
 A_MODIFY_REASON  IN        VARCHAR2)                 
RETURN NUMBER IS

L_SC                  UNAPIGEN.VC20_TABLE_TYPE;
L_PG                  UNAPIGEN.VC20_TABLE_TYPE;
L_PGNODE              UNAPIGEN.LONG_TABLE_TYPE;
L_PA                  UNAPIGEN.VC20_TABLE_TYPE;
L_PANODE              UNAPIGEN.LONG_TABLE_TYPE;
L_ME                  UNAPIGEN.VC20_TABLE_TYPE;
L_MENODE              UNAPIGEN.LONG_TABLE_TYPE;
L_MT_VERSION          UNAPIGEN.VC20_TABLE_TYPE;
L_DESCRIPTION         UNAPIGEN.VC40_TABLE_TYPE;
L_VALUE_F             UNAPIGEN.FLOAT_TABLE_TYPE;
L_VALUE_S             UNAPIGEN.VC40_TABLE_TYPE;
L_UNIT                UNAPIGEN.VC20_TABLE_TYPE;
L_EXEC_START_DATE     UNAPIGEN.DATE_TABLE_TYPE;
L_EXEC_END_DATE       UNAPIGEN.DATE_TABLE_TYPE;
L_EXECUTOR            UNAPIGEN.VC20_TABLE_TYPE;
L_LAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_EQ                  UNAPIGEN.VC20_TABLE_TYPE;
L_EQ_VERSION          UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EXECUTOR    UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EQ          UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EQ_VERSION  UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ENTERED    UNAPIGEN.CHAR1_TABLE_TYPE;
L_ALLOW_ADD           UNAPIGEN.CHAR1_TABLE_TYPE;
L_ASSIGN_DATE         UNAPIGEN.DATE_TABLE_TYPE;
L_ASSIGNED_BY         UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ADDED      UNAPIGEN.CHAR1_TABLE_TYPE;
L_DELAY               UNAPIGEN.NUM_TABLE_TYPE;
L_DELAY_UNIT          UNAPIGEN.VC20_TABLE_TYPE;
L_FORMAT              UNAPIGEN.VC40_TABLE_TYPE;
L_ACCURACY            UNAPIGEN.FLOAT_TABLE_TYPE;
L_REAL_COST           UNAPIGEN.VC40_TABLE_TYPE;
L_REAL_TIME           UNAPIGEN.VC40_TABLE_TYPE;
L_CALIBRATION         UNAPIGEN.CHAR1_TABLE_TYPE;
L_CONFIRM_COMPLETE    UNAPIGEN.CHAR1_TABLE_TYPE;
L_AUTORECALC          UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_RESULT_EDITABLE  UNAPIGEN.CHAR1_TABLE_TYPE;
L_NEXT_CELL           UNAPIGEN.VC20_TABLE_TYPE;
L_SOP                 UNAPIGEN.VC40_TABLE_TYPE;
L_SOP_VERSION         UNAPIGEN.VC20_TABLE_TYPE;
L_PLAUS_LOW           UNAPIGEN.FLOAT_TABLE_TYPE;
L_PLAUS_HIGH          UNAPIGEN.FLOAT_TABLE_TYPE;
L_WINSIZE_X           UNAPIGEN.NUM_TABLE_TYPE;
L_WINSIZE_Y           UNAPIGEN.NUM_TABLE_TYPE;
L_REANALYSIS          UNAPIGEN.NUM_TABLE_TYPE;
L_ME_CLASS            UNAPIGEN.VC2_TABLE_TYPE;
L_LOG_HS              UNAPIGEN.CHAR1_TABLE_TYPE;
L_LOG_HS_DETAILS      UNAPIGEN.CHAR1_TABLE_TYPE;
L_LC                  UNAPIGEN.VC2_TABLE_TYPE;
L_LC_VERSION          UNAPIGEN.VC20_TABLE_TYPE;
L_MODIFY_FLAG         UNAPIGEN.NUM_TABLE_TYPE;
L_NR_OF_ROWS          NUMBER;
L_ERRM                VARCHAR2(255);
L_REF_DATE            TIMESTAMP WITH TIME ZONE;
L_FILTER_FREQ         CHAR(1);
L_MT                  VARCHAR2(20);
L_MT_VERSION_IN       VARCHAR2(20);
L_MT_NR_MEASUR        NUMBER;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   
   
   
   
   IF NVL(A_ST, ' ') = ' ' OR
      NVL(A_SC, ' ') = ' ' OR
      NVL(A_PR, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PANODE, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_REF_DATE := A_REF_DATE;
   IF L_REF_DATE IS NULL THEN
      SELECT SAMPLING_DATE
      INTO L_REF_DATE
      FROM UTSC
      WHERE SC = A_SC;
   END IF;
   IF L_REF_DATE IS NULL THEN
      L_REF_DATE := CURRENT_TIMESTAMP;
   END IF;

   L_FILTER_FREQ := NVL(A_FILTER_FREQ, '1');
   L_MT := A_MT;
   L_MT_VERSION_IN := A_MT_VERSION;
   L_MT_NR_MEASUR := A_MT_NR_MEASUR;
   L_NR_OF_ROWS := UNAPIGEN.P_MAX_CHUNK_SIZE;
   
   
   
   
   L_RET_CODE := UNAPIPA.INITSCPADETAILS(A_ST, A_ST_VERSION, A_PP, A_PGNODE, A_PP_VERSION,
                                         A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, 
                                         A_PR, A_PR_VERSION, A_SC, L_FILTER_FREQ,
                                         L_REF_DATE, L_MT, L_MT_VERSION_IN, L_MT_NR_MEASUR,
                                         L_ME, L_REANALYSIS, L_MT_VERSION, L_DESCRIPTION, L_VALUE_F, L_VALUE_S,
                                         L_UNIT, L_EXEC_START_DATE,
                                         L_EXEC_END_DATE , L_EXECUTOR, L_LAB, L_EQ, L_EQ_VERSION, 
                                         L_PLANNED_EXECUTOR, L_PLANNED_EQ, L_PLANNED_EQ_VERSION,
                                         L_MANUALLY_ENTERED,
                                         L_ALLOW_ADD, L_ASSIGN_DATE,
                                         L_ASSIGNED_BY, L_MANUALLY_ADDED, L_DELAY,
                                         L_DELAY_UNIT, L_FORMAT, 
                                         L_ACCURACY, L_REAL_COST, L_REAL_TIME,
                                         L_CALIBRATION, L_CONFIRM_COMPLETE,
                                         L_AUTORECALC, L_ME_RESULT_EDITABLE,
                                         L_NEXT_CELL, L_SOP, L_SOP_VERSION,
                                         L_PLAUS_LOW, L_PLAUS_HIGH,
                                         L_WINSIZE_X, L_WINSIZE_Y, 
                                         L_ME_CLASS, L_LOG_HS, L_LOG_HS_DETAILS, L_LC, L_LC_VERSION, L_NR_OF_ROWS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      L_ERRM := 'st=' || A_ST || '#st_version=' || A_ST_VERSION ||
                '#pp=' || A_PP || '#pp_version=' || A_PP_VERSION ||
                '#pr=' || A_PR || '#pr_version=' || A_PR_VERSION ||
                '#sc=' || A_SC ||'#filter_freq='||L_FILTER_FREQ ||
                '#ref_date=' || L_REF_DATE ||
                '#l_nr_of_rows=' || TO_CHAR(L_NR_OF_ROWS) ||
                '#InitScPaDetails#ErrorCode=' || TO_CHAR(L_RET_CODE);
      RAISE STPERROR;
   END IF;

   
   
   
   FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
      L_SC(L_ROW) := A_SC;
      L_PG(L_ROW) := A_PG;
      L_PGNODE(L_ROW) := A_PGNODE;
      L_PA(L_ROW) := A_PR;
      L_PANODE(L_ROW) := A_PANODE;
      L_MANUALLY_ADDED(L_ROW) := '0';
      L_MODIFY_FLAG(L_ROW) := UNAPIGEN.MOD_FLAG_INSERT;
      L_MENODE(L_ROW) := 0;
      
      
      
      L_DELAY(L_ROW) := NVL(L_DELAY(L_ROW), 0);
      L_DELAY_UNIT(L_ROW) := NVL(L_DELAY_UNIT(L_ROW), 'DD');
   END LOOP;

   
   
   
   IF L_NR_OF_ROWS > 0 THEN
      L_RET_CODE := UNAPIME.SAVESCMETHOD(UNAPIGEN.ALARMS_NOT_HANDLED,
                                         L_SC, L_PG, L_PGNODE, L_PA,
                                         L_PANODE, L_ME, L_MENODE, L_REANALYSIS,
                                         L_MT_VERSION, L_DESCRIPTION, L_VALUE_F,
                                         L_VALUE_S, L_UNIT, L_EXEC_START_DATE,
                                         L_EXEC_END_DATE, L_EXECUTOR, L_LAB, L_EQ, L_EQ_VERSION,
                                         L_PLANNED_EXECUTOR, L_PLANNED_EQ, L_PLANNED_EQ_VERSION,
                                         L_MANUALLY_ENTERED,
                                         L_ALLOW_ADD, L_ASSIGN_DATE,
                                         L_ASSIGNED_BY,
                                         L_MANUALLY_ADDED, L_DELAY, L_DELAY_UNIT,
                                         L_FORMAT, L_ACCURACY,
                                         L_REAL_COST, L_REAL_TIME, L_CALIBRATION,
                                         L_CONFIRM_COMPLETE, L_AUTORECALC, L_ME_RESULT_EDITABLE,
                                         L_NEXT_CELL, L_SOP, L_SOP_VERSION, L_PLAUS_LOW, 
                                         L_PLAUS_HIGH, L_WINSIZE_X,
                                         L_WINSIZE_Y, L_ME_CLASS,
                                         L_LOG_HS, L_LOG_HS_DETAILS, L_LC, L_LC_VERSION, L_MODIFY_FLAG,
                                         L_NR_OF_ROWS, A_MODIFY_REASON);
      IF L_RET_CODE = UNAPIGEN.DBERR_PARTIALSAVE THEN
         
         
         
         FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
            IF L_MODIFY_FLAG(L_ROW) > UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_MODIFY_FLAG(L_ROW);
               L_ERRM := 'sc=' || L_SC(L_ROW) || '#pg=' || L_PG(L_ROW) ||
                         '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW)) ||
                         '#pa=' || L_PA(L_ROW)||
                         '#panode=' || TO_CHAR(L_PANODE(L_ROW)) ||
                         '#me=' || L_ME(L_ROW) ||
                         '#menode=' || TO_CHAR(L_MENODE(L_ROW)) ||
                         '#SaveScMethod#ErrorCode=' || TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            END IF;
         END LOOP;
      ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         L_ERRM := 'sc(1)=' || L_SC(1) || '#pg(1)=' || L_PG(1) ||
                   '#pgnode(1)=' || TO_CHAR(L_PGNODE(1)) ||
                   '#pa(1)=' || L_PA(1)||
                   '#panode(1)=' || TO_CHAR(L_PANODE(1)) ||
                   '#me(1)=' || L_ME(1) ||
                   '#menode(1)=' || TO_CHAR(L_MENODE(1)) ||
                   '#nr_of_rows=' || TO_CHAR(L_NR_OF_ROWS) ||
                   '#SaveScMethod#ErrorCode=' || TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;
   END IF;

   
   
   
   FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
      L_RET_CODE := UNAPIMEP.INITANDSAVESCMEATTRIBUTES(A_SC, L_PG(L_ROW), L_PGNODE(L_ROW), L_PA(L_ROW), L_PANODE(L_ROW), L_ME(L_ROW), L_MENODE(L_ROW));
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         L_ERRM  := 'sc=' || A_SC || '#pg=' || L_PG(L_ROW) ||
                    '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW)) ||
                    '#pa=' || L_PA(L_ROW) ||
                    '#panode=' || TO_CHAR(L_PANODE(L_ROW)) || 
                    '#me=' || L_ME(L_ROW) ||
                    '#menode=' || TO_CHAR(L_MENODE(L_ROW)) || 
                    '#InitAndSaveScMeAttributes#ErrorCode=' || TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;
   END LOOP;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CreateScPaDetails', SQLERRM);
   ELSIF L_ERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('CreateScPaDetails', L_ERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CreateScPaDetails'));
END CREATESCPADETAILS;

FUNCTION ADDSCPADETAILS                           
(A_SC             IN    VARCHAR2,                 
 A_ST             IN    VARCHAR2,                 
 A_ST_VERSION     IN    VARCHAR2,                 
 A_PG             IN    VARCHAR2,                 
 A_PGNODE         IN    NUMBER,                   
 A_PA             IN    VARCHAR2,                 
 A_PANODE         IN    NUMBER,                   
 A_MT             IN    VARCHAR2,                 
 A_MT_VERSION     IN    VARCHAR2,                 
 A_SEQ            IN    NUMBER,                   
 A_MODIFY_REASON  IN    VARCHAR2)                 
RETURN NUMBER IS

L_SC                  UNAPIGEN.VC20_TABLE_TYPE;
L_PG                  UNAPIGEN.VC20_TABLE_TYPE;
L_PGNODE              UNAPIGEN.LONG_TABLE_TYPE;
L_PA                  UNAPIGEN.VC20_TABLE_TYPE;
L_PANODE              UNAPIGEN.LONG_TABLE_TYPE;
L_ME                  UNAPIGEN.VC20_TABLE_TYPE;
L_MENODE              UNAPIGEN.LONG_TABLE_TYPE;
L_REANALYSIS          UNAPIGEN.NUM_TABLE_TYPE;
L_MT_VERSION          UNAPIGEN.VC20_TABLE_TYPE;
L_DESCRIPTION         UNAPIGEN.VC40_TABLE_TYPE;
L_VALUE_F             UNAPIGEN.FLOAT_TABLE_TYPE;
L_VALUE_S             UNAPIGEN.VC40_TABLE_TYPE;
L_UNIT                UNAPIGEN.VC20_TABLE_TYPE;
L_EXEC_START_DATE     UNAPIGEN.DATE_TABLE_TYPE;
L_EXEC_END_DATE       UNAPIGEN.DATE_TABLE_TYPE;
L_EXECUTOR            UNAPIGEN.VC20_TABLE_TYPE;
L_LAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_EQ                  UNAPIGEN.VC20_TABLE_TYPE;
L_EQ_VERSION          UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EXECUTOR    UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EQ          UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EQ_VERSION  UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ENTERED    UNAPIGEN.CHAR1_TABLE_TYPE;
L_ALLOW_ADD           UNAPIGEN.CHAR1_TABLE_TYPE;
L_ASSIGN_DATE         UNAPIGEN.DATE_TABLE_TYPE;
L_ASSIGNED_BY         UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ADDED      UNAPIGEN.CHAR1_TABLE_TYPE;
L_DELAY               UNAPIGEN.NUM_TABLE_TYPE;
L_DELAY_UNIT          UNAPIGEN.VC20_TABLE_TYPE;
L_FORMAT              UNAPIGEN.VC40_TABLE_TYPE;
L_ACCURACY            UNAPIGEN.FLOAT_TABLE_TYPE;
L_REAL_COST           UNAPIGEN.VC40_TABLE_TYPE;
L_REAL_TIME           UNAPIGEN.VC40_TABLE_TYPE;
L_CALIBRATION         UNAPIGEN.CHAR1_TABLE_TYPE;
L_CONFIRM_COMPLETE    UNAPIGEN.CHAR1_TABLE_TYPE;
L_AUTORECALC          UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_RESULT_EDITABLE  UNAPIGEN.CHAR1_TABLE_TYPE;
L_NEXT_CELL           UNAPIGEN.VC20_TABLE_TYPE;
L_SOP                 UNAPIGEN.VC40_TABLE_TYPE;
L_SOP_VERSION         UNAPIGEN.VC20_TABLE_TYPE;
L_PLAUS_LOW           UNAPIGEN.FLOAT_TABLE_TYPE;
L_PLAUS_HIGH          UNAPIGEN.FLOAT_TABLE_TYPE;
L_WINSIZE_X           UNAPIGEN.NUM_TABLE_TYPE;
L_WINSIZE_Y           UNAPIGEN.NUM_TABLE_TYPE;
L_ME_CLASS            UNAPIGEN.VC2_TABLE_TYPE;
L_LOG_HS              UNAPIGEN.CHAR1_TABLE_TYPE;
L_LOG_HS_DETAILS      UNAPIGEN.CHAR1_TABLE_TYPE;
L_LC                  UNAPIGEN.VC2_TABLE_TYPE;
L_LC_VERSION          UNAPIGEN.VC20_TABLE_TYPE;
L_MODIFY_FLAG         UNAPIGEN.NUM_TABLE_TYPE;
L_NR_OF_ROWS          NUMBER;
L_ERRM                VARCHAR2(255);
L_REF_DATE            TIMESTAMP WITH TIME ZONE;
L_FILTER_FREQ         CHAR(1);
L_MT_NR_MEASUR        NUMBER;
L_PR_VERSION          VARCHAR2(20);

CURSOR L_VERSION_CURSOR IS
   SELECT PR_VERSION 
   FROM UTSCPA
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE;
  
BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   IF NVL(A_SC, ' ') = ' ' OR
      NVL(A_PG, ' ') = ' ' OR
      NVL(A_PGNODE, 0) = 0 OR
      NVL(A_PA, ' ') = ' ' OR
      NVL(A_PANODE, 0) = 0 OR
      NVL(A_MT, ' ') = ' ' OR
      A_SEQ IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   
   
   L_FILTER_FREQ := '0';
   L_REF_DATE := NULL; 
   L_MT_NR_MEASUR := NULL;
   L_ERRM := NULL;
 
   
   
   
   OPEN L_VERSION_CURSOR;
   FETCH L_VERSION_CURSOR
   INTO L_PR_VERSION;
   IF L_VERSION_CURSOR%NOTFOUND THEN
      CLOSE L_VERSION_CURSOR;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_PRVERSION;
      RAISE STPERROR;
   END IF;
   CLOSE L_VERSION_CURSOR;
   L_RET_CODE := UNAPIME.INITSCMETHOD(A_MT, A_MT_VERSION, A_SEQ, A_SC, A_PG, A_PGNODE,
                                      A_PA, A_PANODE, L_PR_VERSION, L_MT_NR_MEASUR, L_REANALYSIS,
                                      L_MT_VERSION, L_DESCRIPTION, L_VALUE_F, L_VALUE_S,
                                      L_UNIT, L_EXEC_START_DATE,
                                      L_EXEC_END_DATE , L_EXECUTOR, L_LAB, L_EQ, L_EQ_VERSION,
                                      L_PLANNED_EXECUTOR, L_PLANNED_EQ, L_PLANNED_EQ_VERSION, 
                                      L_MANUALLY_ENTERED,
                                      L_ALLOW_ADD, L_ASSIGN_DATE,
                                      L_ASSIGNED_BY, L_MANUALLY_ADDED, L_DELAY,
                                      L_DELAY_UNIT, L_FORMAT, 
                                      L_ACCURACY, L_REAL_COST, L_REAL_TIME,
                                      L_CALIBRATION, L_CONFIRM_COMPLETE,
                                      L_AUTORECALC, L_ME_RESULT_EDITABLE, 
                                      L_NEXT_CELL, L_SOP, L_SOP_VERSION,
                                      L_PLAUS_LOW, L_PLAUS_HIGH,
                                      L_WINSIZE_X, L_WINSIZE_Y, 
                                      L_ME_CLASS, L_LOG_HS, L_LOG_HS_DETAILS, L_LC, L_LC_VERSION,
                                      L_NR_OF_ROWS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      L_ERRM := 'mt=' || A_MT || '#seq=' || TO_CHAR(A_SEQ) ||
                '#sc=' || A_SC || '#pg=' || A_PG || 
                '#pgnode=' || TO_CHAR(A_PGNODE) ||
                '#pa=' || A_PA || '#panode=' || TO_CHAR(A_PANODE) ||
                '#l_nr_of_rows=' || TO_CHAR(L_NR_OF_ROWS) ||
                '#InitScMethod#ErrorCode=' || TO_CHAR(L_RET_CODE);
      RAISE STPERROR;
   END IF;

   
   
   
   FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
      L_SC(L_ROW) := A_SC;
      L_PG(L_ROW) := A_PG;
      L_PGNODE(L_ROW) := A_PGNODE;
      L_PA(L_ROW) := A_PA;
      L_PANODE(L_ROW) := A_PANODE;
      L_MANUALLY_ADDED(L_ROW) := '0';
      L_MODIFY_FLAG(L_ROW) := UNAPIGEN.MOD_FLAG_INSERT;
      L_ME(L_ROW) := A_MT;
      L_MENODE(L_ROW) := 0;
      
      
      
      L_DELAY(L_ROW) := NVL(L_DELAY(L_ROW), 0);
      L_DELAY_UNIT(L_ROW) := NVL(L_DELAY_UNIT(L_ROW), 'DD');
   END LOOP;

   
   
   
   IF L_NR_OF_ROWS > 0 THEN
      L_RET_CODE := UNAPIME.SAVESCMETHOD(UNAPIGEN.ALARMS_NOT_HANDLED,
                                         L_SC, L_PG, L_PGNODE, L_PA,
                                         L_PANODE, L_ME, L_MENODE, L_REANALYSIS, L_MT_VERSION,
                                         L_DESCRIPTION, L_VALUE_F,
                                         L_VALUE_S, L_UNIT, L_EXEC_START_DATE,
                                         L_EXEC_END_DATE, L_EXECUTOR, L_LAB, L_EQ, L_EQ_VERSION, 
                                         L_PLANNED_EXECUTOR, L_PLANNED_EQ, L_PLANNED_EQ_VERSION, 
                                         L_MANUALLY_ENTERED,
                                         L_ALLOW_ADD, L_ASSIGN_DATE,
                                         L_ASSIGNED_BY,
                                         L_MANUALLY_ADDED, L_DELAY, L_DELAY_UNIT,
                                         L_FORMAT, L_ACCURACY,
                                         L_REAL_COST, L_REAL_TIME, L_CALIBRATION,
                                         L_CONFIRM_COMPLETE, L_AUTORECALC, L_ME_RESULT_EDITABLE,
                                         L_NEXT_CELL, L_SOP, L_SOP_VERSION, L_PLAUS_LOW, 
                                         L_PLAUS_HIGH, L_WINSIZE_X,
                                         L_WINSIZE_Y, L_ME_CLASS,
                                         L_LOG_HS, L_LOG_HS_DETAILS, L_LC, L_LC_VERSION, 
                                         L_MODIFY_FLAG, L_NR_OF_ROWS, A_MODIFY_REASON);
      IF L_RET_CODE = UNAPIGEN.DBERR_PARTIALSAVE THEN
         
         
         
         FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
            IF L_MODIFY_FLAG(L_ROW) > UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_MODIFY_FLAG(L_ROW);
               L_ERRM := 'sc=' || L_SC(L_ROW) || '#pg=' || L_PG(L_ROW) ||
                         '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW)) ||
                         '#pa=' || L_PA(L_ROW)||
                         '#panode=' || TO_CHAR(L_PANODE(L_ROW)) ||
                         '#me=' || L_ME(L_ROW) ||
                         '#menode=' || TO_CHAR(L_MENODE(L_ROW)) ||
                         '#SaveScMethod#ErrorCode=' || TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            END IF;
         END LOOP;
      ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         L_ERRM := 'sc(1)=' || L_SC(1) || '#pg(1)=' || L_PG(1) ||
                   '#pgnode(1)=' || TO_CHAR(L_PGNODE(1)) ||
                   '#pa(1)=' || L_PA(1)||
                   '#panode(1)=' || TO_CHAR(L_PANODE(1)) ||
                   '#me(1)=' || L_ME(1) ||
                   '#menode(1)=' || TO_CHAR(L_MENODE(1)) ||
                   '#nr_of_rows=' || TO_CHAR(L_NR_OF_ROWS) ||
                   '#SaveScMethod#ErrorCode=' || TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;
   END IF;

   
   
   
   FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
      L_RET_CODE := UNAPIMEP.INITANDSAVESCMEATTRIBUTES(A_SC, L_PG(L_ROW), L_PGNODE(L_ROW), L_PA(L_ROW), L_PANODE(L_ROW), L_ME(L_ROW), L_MENODE(L_ROW));
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         L_ERRM  := 'sc=' || A_SC || '#pg=' || L_PG(L_ROW) ||
                    '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW)) ||
                    '#pa=' || L_PA(L_ROW) ||
                    '#panode=' || TO_CHAR(L_PANODE(L_ROW)) || 
                    '#me=' || L_ME(L_ROW) ||
                    '#menode=' || TO_CHAR(L_MENODE(L_ROW)) || 
                    '#InitAndSaveScMeAttributes#ErrorCode=' || TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;
   END LOOP;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('AddScPaDetails', SQLERRM);
   ELSIF L_ERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('AddScPaDetails', L_ERRM);
   END IF;
   IF L_VERSION_CURSOR%ISOPEN THEN
      CLOSE L_VERSION_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'AddScPaDetails'));
END ADDSCPADETAILS;

FUNCTION COPYSCPADETAILS                              
(A_SC_FROM        IN        VARCHAR2,                 
 A_PG_FROM        IN        VARCHAR2,                 
 A_PGNODE_FROM    IN        NUMBER,                   
 A_PA_FROM        IN        VARCHAR2,                 
 A_PANODE_FROM    IN        NUMBER,                   
 A_ST_TO          IN        VARCHAR2,                 
 A_ST_TO_VERSION  IN        VARCHAR2,                 
 A_SC_TO          IN        VARCHAR2,                 
 A_PG_TO          IN        VARCHAR2,                 
 A_PGNODE_TO      IN        NUMBER,                   
 A_PA_TO          IN        VARCHAR2,                 
 A_PANODE_TO      IN        NUMBER,                   
 A_MODIFY_REASON  IN        VARCHAR2)                 
RETURN NUMBER IS

L_SC                  UNAPIGEN.VC20_TABLE_TYPE;
L_PG                  UNAPIGEN.VC20_TABLE_TYPE;
L_PGNODE              UNAPIGEN.LONG_TABLE_TYPE;
L_PA                  UNAPIGEN.VC20_TABLE_TYPE;
L_PANODE              UNAPIGEN.LONG_TABLE_TYPE;
L_ME                  UNAPIGEN.VC20_TABLE_TYPE;
L_MENODE              UNAPIGEN.LONG_TABLE_TYPE;
L_REANALYSIS          UNAPIGEN.NUM_TABLE_TYPE;
L_MT_VERSION          UNAPIGEN.VC20_TABLE_TYPE;
L_DESCRIPTION         UNAPIGEN.VC40_TABLE_TYPE;
L_VALUE_F             UNAPIGEN.FLOAT_TABLE_TYPE;
L_VALUE_S             UNAPIGEN.VC40_TABLE_TYPE;
L_UNIT                UNAPIGEN.VC20_TABLE_TYPE;
L_EXEC_START_DATE     UNAPIGEN.DATE_TABLE_TYPE;
L_EXEC_END_DATE       UNAPIGEN.DATE_TABLE_TYPE;
L_EXECUTOR            UNAPIGEN.VC20_TABLE_TYPE;
L_LAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_EQ                  UNAPIGEN.VC20_TABLE_TYPE;
L_EQ_VERSION          UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EXECUTOR    UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EQ          UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EQ_VERSION  UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ENTERED    UNAPIGEN.CHAR1_TABLE_TYPE;
L_ALLOW_ADD           UNAPIGEN.CHAR1_TABLE_TYPE;
L_ASSIGN_DATE         UNAPIGEN.DATE_TABLE_TYPE;
L_ASSIGNED_BY         UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ADDED      UNAPIGEN.CHAR1_TABLE_TYPE;
L_DELAY               UNAPIGEN.NUM_TABLE_TYPE;
L_DELAY_UNIT          UNAPIGEN.VC20_TABLE_TYPE;
L_FORMAT              UNAPIGEN.VC40_TABLE_TYPE;
L_ACCURACY            UNAPIGEN.FLOAT_TABLE_TYPE;
L_REAL_COST           UNAPIGEN.VC40_TABLE_TYPE;
L_REAL_TIME           UNAPIGEN.VC40_TABLE_TYPE;
L_CALIBRATION         UNAPIGEN.CHAR1_TABLE_TYPE;
L_CONFIRM_COMPLETE    UNAPIGEN.CHAR1_TABLE_TYPE;
L_AUTORECALC          UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_RESULT_EDITABLE  UNAPIGEN.CHAR1_TABLE_TYPE;
L_NEXT_CELL           UNAPIGEN.VC20_TABLE_TYPE;
L_SOP                 UNAPIGEN.VC40_TABLE_TYPE;
L_SOP_VERSION         UNAPIGEN.VC20_TABLE_TYPE;
L_PLAUS_LOW           UNAPIGEN.FLOAT_TABLE_TYPE;
L_PLAUS_HIGH          UNAPIGEN.FLOAT_TABLE_TYPE;
L_WINSIZE_X           UNAPIGEN.NUM_TABLE_TYPE;
L_WINSIZE_Y           UNAPIGEN.NUM_TABLE_TYPE;
L_ME_CLASS            UNAPIGEN.VC2_TABLE_TYPE;
L_LOG_HS              UNAPIGEN.CHAR1_TABLE_TYPE;
L_LOG_HS_DETAILS      UNAPIGEN.CHAR1_TABLE_TYPE;
L_LC                  UNAPIGEN.VC2_TABLE_TYPE;
L_LC_VERSION          UNAPIGEN.VC20_TABLE_TYPE;
L_MODIFY_FLAG         UNAPIGEN.NUM_TABLE_TYPE;
L_NR_OF_ROWS          NUMBER;
L_ERRM                VARCHAR2(255);



CURSOR L_SCME_FROM_GK_CURSOR(A_SC_FROM VARCHAR2, 
                             A_PG_FROM VARCHAR2, A_PGNODE_FROM NUMBER,
                             A_PA_FROM VARCHAR2, A_PANODE_FROM NUMBER) IS
   SELECT A.ME, A.MENODE, A.GK, A.GKSEQ, A.VALUE
   FROM UTSCMEGK A
   WHERE A.SC = A_SC_FROM
   AND A.PG = A_PG_FROM
   AND A.PGNODE = A_PGNODE_FROM
   AND A.PA = A_PA_FROM
   AND A.PANODE = A_PANODE_FROM;

CURSOR L_SCME_CURSOR(A_SC VARCHAR2,
                     A_PG VARCHAR2, A_PGNODE NUMBER,
                     A_PA VARCHAR2, A_PANODE NUMBER) IS
   SELECT *
   FROM UTSCME
   WHERE SC=A_SC
   AND PG=A_PG
   AND PGNODE=A_PGNODE
   AND PA=A_PA
   AND PANODE=A_PANODE
   ORDER BY MENODE;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   
   
   
   IF NVL(A_SC_FROM, ' ') = ' ' OR
      NVL(A_PG_FROM, ' ') = ' ' OR
      NVL(A_PGNODE_FROM, 0) = 0 OR
      NVL(A_PA_FROM, ' ') = ' ' OR
      NVL(A_PANODE_FROM, 0) = 0 OR
      NVL(A_ST_TO, ' ') = ' ' OR
      NVL(A_SC_TO, ' ') = ' ' OR
      NVL(A_PG_TO, ' ') = ' ' OR
      NVL(A_PGNODE_TO, 0) = 0 OR
      NVL(A_PA_TO, ' ') = ' ' OR
      NVL(A_PANODE_TO, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   
   
   L_NR_OF_ROWS := 0;
   FOR L_SCME_REC IN L_SCME_CURSOR(A_SC_FROM, A_PG_FROM, A_PGNODE_FROM, A_PA_FROM, A_PANODE_FROM) LOOP
      L_NR_OF_ROWS := L_NR_OF_ROWS + 1;
      L_SC(L_NR_OF_ROWS) := A_SC_TO;
      L_PG(L_NR_OF_ROWS) := A_PG_TO;
      L_PGNODE(L_NR_OF_ROWS) := A_PGNODE_TO;
      L_PA(L_NR_OF_ROWS) := A_PA_TO;
      L_PANODE(L_NR_OF_ROWS) := A_PANODE_TO;
      L_ME(L_NR_OF_ROWS) := L_SCME_REC.ME;
      L_MENODE(L_NR_OF_ROWS) := L_SCME_REC.MENODE;            
      L_MT_VERSION(L_NR_OF_ROWS) := L_SCME_REC.MT_VERSION;
      L_DESCRIPTION(L_NR_OF_ROWS) := L_SCME_REC.DESCRIPTION;            
      L_UNIT(L_NR_OF_ROWS) := L_SCME_REC.UNIT;
      L_LAB(L_NR_OF_ROWS) := L_SCME_REC.LAB;
      L_EQ(L_NR_OF_ROWS) := L_SCME_REC.EQ;
      L_EQ_VERSION(L_NR_OF_ROWS) := L_SCME_REC.EQ_VERSION;
      L_PLANNED_EXECUTOR(L_NR_OF_ROWS) := L_SCME_REC.PLANNED_EXECUTOR;
      L_PLANNED_EQ(L_NR_OF_ROWS) := L_SCME_REC.PLANNED_EQ;
      L_PLANNED_EQ_VERSION(L_NR_OF_ROWS) := L_SCME_REC.PLANNED_EQ_VERSION;
      L_ALLOW_ADD(L_NR_OF_ROWS) := L_SCME_REC.ALLOW_ADD;
      L_DELAY(L_NR_OF_ROWS) := L_SCME_REC.DELAY;
      L_DELAY_UNIT(L_NR_OF_ROWS) := L_SCME_REC.DELAY_UNIT;
      L_FORMAT(L_NR_OF_ROWS) := L_SCME_REC.FORMAT;
      L_ACCURACY(L_NR_OF_ROWS) := L_SCME_REC.ACCURACY;
      L_REAL_COST(L_NR_OF_ROWS) := L_SCME_REC.REAL_COST;
      L_REAL_TIME(L_NR_OF_ROWS) := L_SCME_REC.REAL_TIME;
      L_CALIBRATION(L_NR_OF_ROWS) := L_SCME_REC.CALIBRATION;
      L_CONFIRM_COMPLETE(L_NR_OF_ROWS) := L_SCME_REC.CONFIRM_COMPLETE;
      L_AUTORECALC(L_NR_OF_ROWS) := L_SCME_REC.AUTORECALC;
      L_ME_RESULT_EDITABLE(L_NR_OF_ROWS) := L_SCME_REC.ME_RESULT_EDITABLE;
      L_NEXT_CELL(L_NR_OF_ROWS) := L_SCME_REC.NEXT_CELL;
      L_SOP(L_NR_OF_ROWS) := L_SCME_REC.SOP;
      L_SOP_VERSION(L_NR_OF_ROWS) := L_SCME_REC.SOP_VERSION;
      L_PLAUS_LOW(L_NR_OF_ROWS) := L_SCME_REC.PLAUS_LOW;
      L_PLAUS_HIGH(L_NR_OF_ROWS) := L_SCME_REC.PLAUS_HIGH;
      L_WINSIZE_X(L_NR_OF_ROWS) := L_SCME_REC.WINSIZE_X;
      L_WINSIZE_Y(L_NR_OF_ROWS) := L_SCME_REC.WINSIZE_Y;
      L_ME_CLASS(L_NR_OF_ROWS) := L_SCME_REC.ME_CLASS;
      L_LOG_HS(L_NR_OF_ROWS) := L_SCME_REC.LOG_HS;
      L_LOG_HS_DETAILS(L_NR_OF_ROWS) := L_SCME_REC.LOG_HS_DETAILS;
      L_LC(L_NR_OF_ROWS) := L_SCME_REC.LC;      
      L_LC_VERSION(L_NR_OF_ROWS) := L_SCME_REC.LC_VERSION;
      
      L_REANALYSIS(L_NR_OF_ROWS) := 0;
      L_VALUE_F(L_NR_OF_ROWS) := NULL;
      L_VALUE_S(L_NR_OF_ROWS) := NULL;      
      L_EXEC_START_DATE(L_NR_OF_ROWS) := NULL;
      L_EXEC_END_DATE(L_NR_OF_ROWS) := NULL;
      L_EXECUTOR(L_NR_OF_ROWS) := UNAPIGEN.P_USER;
      L_MANUALLY_ENTERED(L_NR_OF_ROWS) := '0';
      L_MANUALLY_ADDED(L_NR_OF_ROWS) := '0';
      L_ASSIGN_DATE(L_NR_OF_ROWS) := CURRENT_TIMESTAMP;
      L_ASSIGNED_BY(L_NR_OF_ROWS) := UNAPIGEN.P_USER;
      L_MODIFY_FLAG(L_NR_OF_ROWS) := UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES;
   END LOOP;
   
   
   
   

   IF L_NR_OF_ROWS > 0 THEN
      L_RET_CODE := UNAPIME.SAVESCMETHOD(UNAPIGEN.ALARMS_NOT_HANDLED,
                                         L_SC, L_PG, L_PGNODE, L_PA,
                                         L_PANODE, L_ME, L_MENODE, L_REANALYSIS,
                                         L_MT_VERSION, L_DESCRIPTION, L_VALUE_F,
                                         L_VALUE_S, L_UNIT, L_EXEC_START_DATE,
                                         L_EXEC_END_DATE, L_EXECUTOR, L_LAB, L_EQ, L_EQ_VERSION, 
                                         L_PLANNED_EXECUTOR, L_PLANNED_EQ, L_PLANNED_EQ_VERSION,
                                         L_MANUALLY_ENTERED,
                                         L_ALLOW_ADD, L_ASSIGN_DATE,
                                         L_ASSIGNED_BY,
                                         L_MANUALLY_ADDED, L_DELAY, L_DELAY_UNIT,
                                         L_FORMAT, L_ACCURACY,
                                         L_REAL_COST, L_REAL_TIME, L_CALIBRATION,
                                         L_CONFIRM_COMPLETE, L_AUTORECALC, L_ME_RESULT_EDITABLE,
                                         L_NEXT_CELL, L_SOP, L_SOP_VERSION, L_PLAUS_LOW, 
                                         L_PLAUS_HIGH, L_WINSIZE_X,
                                         L_WINSIZE_Y, L_ME_CLASS,
                                         L_LOG_HS, L_LOG_HS_DETAILS, L_LC, L_LC_VERSION, 
                                         L_MODIFY_FLAG, L_NR_OF_ROWS, A_MODIFY_REASON);
      IF L_RET_CODE = UNAPIGEN.DBERR_PARTIALSAVE THEN
         
         
         
         FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
            IF L_MODIFY_FLAG(L_ROW) > UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_MODIFY_FLAG(L_ROW);
               L_ERRM := 'sc=' || L_SC(L_ROW) || '#pg=' || L_PG(L_ROW) ||
                         '#pgnode=' || TO_CHAR(L_PGNODE(L_ROW)) ||
                         '#pa=' || L_PA(L_ROW)||
                         '#panode=' || TO_CHAR(L_PANODE(L_ROW)) ||
                         '#me=' || L_ME(L_ROW) ||
                         '#menode=' || TO_CHAR(L_MENODE(L_ROW)) ||
                         '#SaveScMethod#ErrorCode=' || TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            END IF;
         END LOOP;
      ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         L_ERRM := 'sc(1)=' || L_SC(1) || '#pg(1)=' || L_PG(1) ||
                   '#pgnode(1)=' || TO_CHAR(L_PGNODE(1)) ||
                   '#pa(1)=' || L_PA(1)||
                   '#panode(1)=' || TO_CHAR(L_PANODE(1)) ||
                   '#me(1)=' || L_ME(1) ||
                   '#menode(1)=' || TO_CHAR(L_MENODE(1)) ||
                   '#nr_of_rows=' || TO_CHAR(L_NR_OF_ROWS) ||
                   '#SaveScMethod#ErrorCode=' || TO_CHAR(L_RET_CODE);
         RAISE STPERROR;
      END IF;
   END IF;

   
   
   
   INSERT INTO UTSCMEAU (SC, PG, PGNODE, PA, PANODE, ME, MENODE, AU, AUSEQ, VALUE)
   SELECT A_SC_TO, A_PG_TO, A_PGNODE_TO, PA, PANODE, ME, MENODE, AU, AUSEQ, VALUE
   FROM UTSCMEAU
   WHERE SC = A_SC_FROM
   AND PG = A_PG_FROM
   AND PGNODE = A_PGNODE_FROM
   AND PA = A_PA_FROM
   AND PANODE = A_PANODE_FROM;
























































   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CopyScPaDetails', SQLERRM);
   ELSIF L_ERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('CopyScPaDetails', L_ERRM);
   END IF;



   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CopyScPaDetails'));
END COPYSCPADETAILS;

FUNCTION INITSCPADETAILS                                         
(A_ST                      IN         VARCHAR2,                  
 A_ST_VERSION              IN OUT     VARCHAR2,                  
 A_PP                      IN         VARCHAR2,                  
 A_PGNODE                  IN         NUMBER,                    
 A_PP_VERSION              IN OUT     VARCHAR2,                  
 A_PP_KEY1                 IN         VARCHAR2,                  
 A_PP_KEY2                 IN         VARCHAR2,                  
 A_PP_KEY3                 IN         VARCHAR2,                  
 A_PP_KEY4                 IN         VARCHAR2,                  
 A_PP_KEY5                 IN         VARCHAR2,                   
 A_PR                      IN         VARCHAR2,                  
 A_PR_VERSION              IN OUT     VARCHAR2,                  
 A_SC                      IN         VARCHAR2,                  
 A_FILTER_FREQ             IN         CHAR,                      
 A_REF_DATE                IN         DATE,                      
 A_MT                      IN         VARCHAR2,                  
 A_MT_VERSION_IN           IN         VARCHAR2,                  
 A_MT_NR_MEASUR            IN         NUMBER,                    
 A_ME                      OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_REANALYSIS              OUT        UNAPIGEN.NUM_TABLE_TYPE,   
 A_MT_VERSION              OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCRIPTION             OUT        UNAPIGEN.VC40_TABLE_TYPE,  
 A_VALUE_F                 OUT        UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_VALUE_S                 OUT        UNAPIGEN.VC40_TABLE_TYPE,  
 A_UNIT                    OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_EXEC_START_DATE         OUT        UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXEC_END_DATE           OUT        UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXECUTOR                OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_LAB                     OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_EQ                      OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_EQ_VERSION              OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLANNED_EXECUTOR        OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLANNED_EQ              OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLANNED_EQ_VERSION      OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_MANUALLY_ENTERED        OUT        UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ALLOW_ADD               OUT        UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ASSIGN_DATE             OUT        UNAPIGEN.DATE_TABLE_TYPE,  
 A_ASSIGNED_BY             OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_MANUALLY_ADDED          OUT        UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_DELAY                   OUT        UNAPIGEN.NUM_TABLE_TYPE,   
 A_DELAY_UNIT              OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_FORMAT                  OUT        UNAPIGEN.VC40_TABLE_TYPE,  
 A_ACCURACY                OUT        UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_REAL_COST               OUT        UNAPIGEN.VC40_TABLE_TYPE, 
 A_REAL_TIME               OUT        UNAPIGEN.VC40_TABLE_TYPE, 
 A_CALIBRATION             OUT        UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_CONFIRM_COMPLETE        OUT        UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_AUTORECALC              OUT        UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ME_RESULT_EDITABLE      OUT        UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NEXT_CELL               OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_SOP                     OUT        UNAPIGEN.VC40_TABLE_TYPE,  
 A_SOP_VERSION             OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLAUS_LOW               OUT        UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_PLAUS_HIGH              OUT        UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_WINSIZE_X               OUT        UNAPIGEN.NUM_TABLE_TYPE,   
 A_WINSIZE_Y               OUT        UNAPIGEN.NUM_TABLE_TYPE,   
 A_ME_CLASS                OUT        UNAPIGEN.VC2_TABLE_TYPE,   
 A_LOG_HS                  OUT        UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LOG_HS_DETAILS          OUT        UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LC                      OUT        UNAPIGEN.VC2_TABLE_TYPE,   
 A_LC_VERSION              OUT        UNAPIGEN.VC20_TABLE_TYPE,  
 A_NR_OF_ROWS              IN OUT     NUMBER)                    
RETURN NUMBER IS

L_REF_DATE                TIMESTAMP WITH TIME ZONE;
L_FREQ_FROM               CHAR(2);
L_ASSIGN                  BOOLEAN;
L_FREQ_TP                 CHAR(1);
L_FREQ_VAL                NUMBER;
L_FREQ_UNIT               VARCHAR2(20);
L_INVERT_FREQ             CHAR(1);
L_LAST_SCHED              TIMESTAMP WITH TIME ZONE;
L_LAST_CNT                NUMBER(5);
L_LAST_VAL                VARCHAR2(40);
L_ME                      UNAPIGEN.VC20_TABLE_TYPE;
L_MT_VERSION              UNAPIGEN.VC20_TABLE_TYPE;
L_DESCRIPTION             UNAPIGEN.VC40_TABLE_TYPE;
L_VALUE_F                 UNAPIGEN.FLOAT_TABLE_TYPE;
L_VALUE_S                 UNAPIGEN.VC40_TABLE_TYPE;
L_UNIT                    UNAPIGEN.VC20_TABLE_TYPE;
L_EXEC_START_DATE         UNAPIGEN.DATE_TABLE_TYPE;
L_EXEC_END_DATE           UNAPIGEN.DATE_TABLE_TYPE;
L_EXECUTOR                UNAPIGEN.VC20_TABLE_TYPE;
L_LAB                     UNAPIGEN.VC20_TABLE_TYPE;
L_EQ                      UNAPIGEN.VC20_TABLE_TYPE;
L_EQ_VERSION              UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EXECUTOR        UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EQ              UNAPIGEN.VC20_TABLE_TYPE;
L_PLANNED_EQ_VERSION      UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ENTERED        UNAPIGEN.CHAR1_TABLE_TYPE;
L_ALLOW_ADD               UNAPIGEN.CHAR1_TABLE_TYPE;
L_ASSIGN_DATE             UNAPIGEN.DATE_TABLE_TYPE;
L_ASSIGNED_BY             UNAPIGEN.VC20_TABLE_TYPE;
L_MANUALLY_ADDED          UNAPIGEN.CHAR1_TABLE_TYPE;
L_DELAY                   UNAPIGEN.NUM_TABLE_TYPE;
L_DELAY_UNIT              UNAPIGEN.VC20_TABLE_TYPE;
L_FORMAT                  UNAPIGEN.VC40_TABLE_TYPE;
L_ACCURACY                UNAPIGEN.FLOAT_TABLE_TYPE;
L_REAL_COST               UNAPIGEN.VC40_TABLE_TYPE;
L_REAL_TIME               UNAPIGEN.VC40_TABLE_TYPE;
L_CALIBRATION             UNAPIGEN.CHAR1_TABLE_TYPE;
L_CONFIRM_COMPLETE        UNAPIGEN.CHAR1_TABLE_TYPE;
L_AUTORECALC              UNAPIGEN.CHAR1_TABLE_TYPE;
L_ME_RESULT_EDITABLE      UNAPIGEN.CHAR1_TABLE_TYPE;
L_NEXT_CELL               UNAPIGEN.VC20_TABLE_TYPE;
L_SOP                     UNAPIGEN.VC40_TABLE_TYPE;
L_SOP_VERSION             UNAPIGEN.VC20_TABLE_TYPE;
L_PLAUS_LOW               UNAPIGEN.FLOAT_TABLE_TYPE;
L_PLAUS_HIGH              UNAPIGEN.FLOAT_TABLE_TYPE;
L_WINSIZE_X               UNAPIGEN.NUM_TABLE_TYPE;
L_WINSIZE_Y               UNAPIGEN.NUM_TABLE_TYPE;
L_REANALYSIS              UNAPIGEN.NUM_TABLE_TYPE;
L_ME_CLASS                UNAPIGEN.VC2_TABLE_TYPE;
L_LOG_HS                  UNAPIGEN.CHAR1_TABLE_TYPE;
L_LOG_HS_DETAILS          UNAPIGEN.CHAR1_TABLE_TYPE;
L_ALLOW_MODIFY            UNAPIGEN.CHAR1_TABLE_TYPE;
L_ACTIVE                  UNAPIGEN.CHAR1_TABLE_TYPE;
L_LC                      UNAPIGEN.VC2_TABLE_TYPE;
L_LC_VERSION              UNAPIGEN.VC20_TABLE_TYPE;
L_SS                      UNAPIGEN.VC2_TABLE_TYPE;
L_NR_OF_ROWS              NUMBER;
L_TOT_NR_ROWS             NUMBER;
L_FILTER_FREQ             CHAR(1);
L_OTHER_MENODE            NUMBER;
L_DYN_CURSOR              INTEGER;
L_OVR_RUL_MT_ASSG         BOOLEAN;
L_IGNORE_OTHER            CHAR(1);
L_MT_NR_MEASUR            NUMBER;
L_PPPRMT_VERSION_USED     VARCHAR2(20);
L_PGNODE                  NUMBER;
L_NEVER_CREATE_METHODS    CHAR(1);
L_SUPPLIER                VARCHAR2(20);
L_CUSTOMER                VARCHAR2(20);

CURSOR L_PRMT_CURSOR(C_PR VARCHAR2, C_PR_VERSION VARCHAR2) IS
   SELECT A.PR, A.VERSION PR_VERSION, A.MT, A.MT_VERSION, A.SEQ, A.FREQ_TP, A.FREQ_VAL, A.FREQ_UNIT, A.INVERT_FREQ,
          A.ST_BASED_FREQ, A.LAST_SCHED, A.LAST_CNT, A.LAST_VAL, A.IGNORE_OTHER
   FROM UTPRMTBUFFER A
   WHERE A.PR = C_PR
   AND A.VERSION = C_PR_VERSION
   ORDER BY A.SEQ;

CURSOR L_PRMT2_CURSOR(C_PR VARCHAR2, C_PR_VERSION VARCHAR2, C_MT VARCHAR2) IS
   SELECT IGNORE_OTHER
   FROM UTPRMT
   WHERE PR = C_PR
   AND VERSION = C_PR_VERSION
   AND MT = C_MT
   ORDER BY SEQ;



CURSOR L_STMTFREQ_CURSOR(C_MT VARCHAR2, C_MT_VERSION VARCHAR2) IS
   SELECT FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED,
          LAST_CNT, LAST_VAL
   FROM UTSTMTFREQBUFFER
   WHERE ST = A_ST
     AND VERSION = A_ST_VERSION
     AND PR = A_PR
     AND NVL(PR_VERSION, '~Current~') = NVL(A_PR_VERSION, '~Current~')
     AND MT = C_MT
     AND NVL(MT_VERSION, '~Current~') = NVL(C_MT_VERSION, '~Current~');

CURSOR L_SCME_CURSOR(C_PP VARCHAR2, C_PGNODE VARCHAR2, C_MT VARCHAR2) IS
   SELECT MENODE
   FROM UTSCME
   WHERE SC = A_SC
     AND PG = C_PP
     AND PGNODE = NVL(C_PGNODE,PGNODE)
     AND ME = C_MT
     AND NVL(SS,'@~') <> '@C';

CURSOR L_SCMEALREADYASSIGNED_CURSOR(C_MT VARCHAR2) IS
   SELECT MENODE
   FROM UTSCME ME
   WHERE ME.SC = A_SC
     AND ME.ME = C_MT
     
     AND DECODE(ME.SS, NULL, '1', NVL(ME.ACTIVE,'1')) = '1'     
     AND NVL(ME.SS,'@~') <> '@C';

CURSOR L_PPPRMT_CURSOR(A_PP VARCHAR2, A_PP_VERSION VARCHAR2, A_PP_KEY1 VARCHAR2, A_PP_KEY2 VARCHAR2,
                       A_PP_KEY3 VARCHAR2, A_PP_KEY4 VARCHAR2, A_PP_KEY5 VARCHAR2, 
                       A_PR VARCHAR2, A_PR_VERSION VARCHAR2, A_MT VARCHAR2,A_MT_VERSION VARCHAR2) IS
   SELECT A.MT, A.MT_VERSION, A.MT_NR_MEASUR
   FROM UTPPPR A
   WHERE A.PP = A_PP
   AND A.VERSION = A_PP_VERSION
   AND A.PP_KEY1 = A_PP_KEY1
   AND A.PP_KEY2 = A_PP_KEY2
   AND A.PP_KEY3 = A_PP_KEY3
   AND A.PP_KEY4 = A_PP_KEY4
   AND A.PP_KEY5 = A_PP_KEY5
   AND A.PR = A_PR
   AND UNAPIGEN.VALIDATEVERSION('pr', A.PR, A.PR_VERSION) = A_PR_VERSION
   AND A.MT = A_MT
   
   
   AND UNAPIGEN.USEVERSION('mt', A.MT, A.MT_VERSION) = A_MT_VERSION;
L_PPPRMT_REC L_PPPRMT_CURSOR%ROWTYPE;

CURSOR L_SCPG_CURSOR(C_SC VARCHAR2, C_PG VARCHAR2, C_PGNODE NUMBER) IS
   SELECT NEVER_CREATE_METHODS
     FROM UTSCPG
    WHERE SC     = C_SC
      AND PG     = C_PG
      AND PGNODE = NVL(C_PGNODE,PGNODE);

CURSOR L_PP_CURSOR(C_PP VARCHAR2, C_PP_VERSION VARCHAR2, C_PP_KEY1 VARCHAR2, C_PP_KEY2 VARCHAR2,
                   C_PP_KEY3 VARCHAR2, C_PP_KEY4 VARCHAR2, C_PP_KEY5 VARCHAR2) IS
   SELECT NEVER_CREATE_METHODS
     FROM UTPP
    WHERE PP      = C_PP
      AND VERSION = C_PP_VERSION 
      AND PP_KEY1 = C_PP_KEY1
      AND PP_KEY2 = C_PP_KEY2
      AND PP_KEY3 = C_PP_KEY3
      AND PP_KEY4 = C_PP_KEY4
      AND PP_KEY5 = C_PP_KEY5;

   
   PROCEDURE ASSIGN(A_MT_TO_ASSIGN IN VARCHAR2) IS

   L_ROW      INTEGER;

   BEGIN
      FOR L_ROW IN 1..L_NR_OF_ROWS LOOP
         
         
         
         
         A_ASSIGN_DATE(L_TOT_NR_ROWS + L_ROW) := NVL(L_REF_DATE,CURRENT_TIMESTAMP);
         A_ASSIGNED_BY(L_TOT_NR_ROWS + L_ROW) := UNAPIGEN.P_USER;
         
         
         
         A_ME(L_TOT_NR_ROWS + L_ROW) := A_MT_TO_ASSIGN;
         A_MT_VERSION(L_TOT_NR_ROWS + L_ROW) := L_MT_VERSION(L_ROW);
         A_DESCRIPTION(L_TOT_NR_ROWS + L_ROW) := L_DESCRIPTION(L_ROW);
         A_VALUE_F(L_TOT_NR_ROWS + L_ROW) := L_VALUE_F(L_ROW);
         A_VALUE_S(L_TOT_NR_ROWS + L_ROW) := L_VALUE_S(L_ROW);
         A_UNIT(L_TOT_NR_ROWS + L_ROW) := L_UNIT(L_ROW);
         A_EXEC_START_DATE(L_TOT_NR_ROWS + L_ROW) := L_EXEC_START_DATE(L_ROW);
         A_EXEC_END_DATE(L_TOT_NR_ROWS + L_ROW) := L_EXEC_END_DATE(L_ROW);
         A_EXECUTOR(L_TOT_NR_ROWS + L_ROW) := L_EXECUTOR(L_ROW);
         A_LAB(L_TOT_NR_ROWS + L_ROW) := L_LAB(L_ROW);
         A_EQ(L_TOT_NR_ROWS + L_ROW) := L_EQ(L_ROW);
         A_EQ_VERSION(L_TOT_NR_ROWS + L_ROW) := L_EQ_VERSION(L_ROW);
         A_PLANNED_EXECUTOR(L_TOT_NR_ROWS + L_ROW) := L_PLANNED_EXECUTOR(L_ROW);
         A_PLANNED_EQ(L_TOT_NR_ROWS + L_ROW) := L_PLANNED_EQ(L_ROW);
         A_PLANNED_EQ_VERSION(L_TOT_NR_ROWS + L_ROW) := L_PLANNED_EQ_VERSION(L_ROW);
         A_MANUALLY_ENTERED(L_TOT_NR_ROWS + L_ROW) := L_MANUALLY_ENTERED(L_ROW);
         A_ALLOW_ADD(L_TOT_NR_ROWS + L_ROW) := L_ALLOW_ADD(L_ROW);
         A_MANUALLY_ADDED(L_TOT_NR_ROWS + L_ROW) := L_MANUALLY_ADDED(L_ROW);
         A_DELAY(L_TOT_NR_ROWS + L_ROW) := L_DELAY(L_ROW);
         A_DELAY_UNIT(L_TOT_NR_ROWS + L_ROW) := L_DELAY_UNIT(L_ROW);
         A_FORMAT(L_TOT_NR_ROWS + L_ROW) := L_FORMAT(L_ROW);
         A_ACCURACY(L_TOT_NR_ROWS + L_ROW) := L_ACCURACY(L_ROW);
         A_REAL_COST(L_TOT_NR_ROWS + L_ROW) := L_REAL_COST(L_ROW);
         A_REAL_TIME(L_TOT_NR_ROWS + L_ROW) := L_REAL_TIME(L_ROW);
         A_CALIBRATION(L_TOT_NR_ROWS + L_ROW) := L_CALIBRATION(L_ROW);
         A_CONFIRM_COMPLETE(L_TOT_NR_ROWS + L_ROW) := L_CONFIRM_COMPLETE(L_ROW);
         A_AUTORECALC(L_TOT_NR_ROWS + L_ROW) := L_AUTORECALC(L_ROW);
         A_ME_RESULT_EDITABLE(L_TOT_NR_ROWS + L_ROW) := L_ME_RESULT_EDITABLE(L_ROW);
         A_NEXT_CELL(L_TOT_NR_ROWS + L_ROW) := L_NEXT_CELL(L_ROW);
         A_SOP(L_TOT_NR_ROWS + L_ROW) := L_SOP(L_ROW);
         A_SOP_VERSION(L_TOT_NR_ROWS + L_ROW) := L_SOP_VERSION(L_ROW);
         A_PLAUS_LOW(L_TOT_NR_ROWS + L_ROW) := L_PLAUS_LOW(L_ROW);
         A_PLAUS_HIGH(L_TOT_NR_ROWS + L_ROW) := L_PLAUS_HIGH(L_ROW);
         A_WINSIZE_X(L_TOT_NR_ROWS + L_ROW) := L_WINSIZE_X(L_ROW);
         A_WINSIZE_Y(L_TOT_NR_ROWS + L_ROW) := L_WINSIZE_Y(L_ROW);
         A_REANALYSIS(L_TOT_NR_ROWS + L_ROW) := L_REANALYSIS(L_ROW);
         A_ME_CLASS(L_TOT_NR_ROWS + L_ROW) := L_ME_CLASS(L_ROW);
         A_LOG_HS(L_TOT_NR_ROWS + L_ROW) := L_LOG_HS(L_ROW);
         A_LOG_HS_DETAILS(L_TOT_NR_ROWS + L_ROW) := L_LOG_HS_DETAILS(L_ROW);
         A_LC(L_TOT_NR_ROWS + L_ROW) := L_LC(L_ROW);
         A_LC_VERSION(L_TOT_NR_ROWS + L_ROW) := L_LC_VERSION(L_ROW);
      END LOOP;
   END ASSIGN;

BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_NR_OF_ROWS, 0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NROFROWS;
      RAISE STPERROR;
   END IF;

   
   
   
   
   
   
   
   
   
   IF NVL(A_ST, ' ') = ' ' OR
      NVL(A_SC, ' ') = ' ' OR
      NVL(A_PP, ' ') = ' ' OR
      NVL(A_PR, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_NR_OF_ROWS := 0;
   L_TOT_NR_ROWS := 0;
   L_FILTER_FREQ := NVL(A_FILTER_FREQ, '1');
   L_SQLERRM := NULL;
   
   IF A_PGNODE = '0' THEN
      L_PGNODE := NULL;
   ELSE
      L_PGNODE := A_PGNODE;
   END IF;
   A_ST_VERSION := UNAPIGEN.VALIDATEVERSION('st', A_ST, A_ST_VERSION);
   A_PP_VERSION := UNAPIGEN.VALIDATEPPVERSION(A_PP, A_PP_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5);
   A_PR_VERSION := UNAPIGEN.VALIDATEVERSION('pr', A_PR, A_PR_VERSION);
   IF A_MT IS NOT NULL THEN
      L_PPPRMT_VERSION_USED := UNAPIGEN.VALIDATEVERSION('mt', A_MT, A_MT_VERSION_IN);
   END IF;

   
   
   
   L_NEVER_CREATE_METHODS := NULL;
   
   OPEN L_SCPG_CURSOR(A_SC, A_PP, L_PGNODE);
   FETCH L_SCPG_CURSOR INTO L_NEVER_CREATE_METHODS;
   CLOSE L_SCPG_CURSOR;
   IF L_NEVER_CREATE_METHODS IS NULL THEN
      
      OPEN L_PP_CURSOR(A_PP, A_PP_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5);
      FETCH L_PP_CURSOR INTO L_NEVER_CREATE_METHODS;
      CLOSE L_PP_CURSOR;
   END IF;
   
   IF L_NEVER_CREATE_METHODS = '1' THEN
      A_NR_OF_ROWS := 0;
      IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   L_RET_CODE := UNAPIPG.GETSUPPLIERANDCUSTOMER(A_PP_KEY1,
                                                A_PP_KEY2,
                                                A_PP_KEY3,
                                                A_PP_KEY4, 
                                                A_PP_KEY5, 
                                                L_SUPPLIER,
                                                L_CUSTOMER);
   
   
   
   
   
   
   L_OVR_RUL_MT_ASSG := FALSE;
   IF A_MT IS NOT NULL THEN
      
      OPEN L_PPPRMT_CURSOR (A_PP, A_PP_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, 
                            A_PR, A_PR_VERSION, A_MT, L_PPPRMT_VERSION_USED);
      FETCH L_PPPRMT_CURSOR
      INTO L_PPPRMT_REC;
      IF L_PPPRMT_CURSOR%FOUND AND
         L_PPPRMT_REC.MT IS NOT NULL THEN

         
         
         
         
         L_IGNORE_OTHER := '0';
         OPEN L_PRMT2_CURSOR(A_PR, A_PR_VERSION, L_PPPRMT_REC.MT);
         FETCH L_PRMT2_CURSOR
         INTO L_IGNORE_OTHER;
         CLOSE L_PRMT2_CURSOR;

         
         
         
         
         
         L_ASSIGN := FALSE;
         IF NVL(L_IGNORE_OTHER, '0') = '1' THEN
            
            OPEN L_SCME_CURSOR(A_PP, L_PGNODE, L_PPPRMT_REC.MT);
            FETCH L_SCME_CURSOR
            INTO L_OTHER_MENODE;

            IF L_SCME_CURSOR%FOUND THEN
               
               L_ASSIGN := FALSE;
            ELSE
               L_ASSIGN := TRUE;
            END IF;
            CLOSE L_SCME_CURSOR;
         ELSE
            L_ASSIGN := TRUE;
         END IF;
         
         
         
         
         
         IF L_ASSIGN THEN
            IF L_SUPPLIER <> ' ' OR
               L_CUSTOMER <> ' ' THEN
               OPEN L_SCMEALREADYASSIGNED_CURSOR (L_PPPRMT_REC.MT);
               FETCH L_SCMEALREADYASSIGNED_CURSOR
               INTO L_OTHER_MENODE;
               IF L_SCMEALREADYASSIGNED_CURSOR%FOUND THEN
                  
                  L_ASSIGN := FALSE;
               ELSE
                  L_ASSIGN := TRUE;
               END IF;
               CLOSE L_SCMEALREADYASSIGNED_CURSOR;
            END IF;
         END IF;

         IF L_ASSIGN THEN
            L_NR_OF_ROWS := 0;
            L_MT_NR_MEASUR := L_PPPRMT_REC.MT_NR_MEASUR;
            L_RET_CODE := UNAPIME.INITSCMETHOD(L_PPPRMT_REC.MT, L_PPPRMT_REC.MT_VERSION,
                                   0, A_SC, A_PP, 0,
                                   A_PR, 0, A_PR_VERSION, 
                                   L_MT_NR_MEASUR, L_REANALYSIS, L_MT_VERSION, L_DESCRIPTION,
                                   L_VALUE_F, L_VALUE_S, L_UNIT, L_EXEC_START_DATE,
                                   L_EXEC_END_DATE, L_EXECUTOR, L_LAB, L_EQ,  L_EQ_VERSION,
                                   L_PLANNED_EXECUTOR, L_PLANNED_EQ, L_PLANNED_EQ_VERSION,
                                   L_MANUALLY_ENTERED,
                                   L_ALLOW_ADD, L_ASSIGN_DATE, L_ASSIGNED_BY,
                                   L_MANUALLY_ADDED, L_DELAY, L_DELAY_UNIT,
                                   L_FORMAT, L_ACCURACY, L_REAL_COST,
                                   L_REAL_TIME, L_CALIBRATION, L_CONFIRM_COMPLETE,
                                   L_AUTORECALC, L_ME_RESULT_EDITABLE, L_NEXT_CELL, 
                                   L_SOP, L_SOP_VERSION, 
                                   L_PLAUS_LOW, L_PLAUS_HIGH,
                                   L_WINSIZE_X, L_WINSIZE_Y, 
                                   L_ME_CLASS, L_LOG_HS, L_LOG_HS_DETAILS,
                                   L_LC, L_LC_VERSION, L_NR_OF_ROWS);

            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               L_SQLERRM := 'mt='||L_PPPRMT_REC.MT ||
                      '#mt_version_in='||L_PPPRMT_REC.MT_VERSION ||
                      '#seq=0(hardc.)'||
                      '#sc=' || A_SC || '#pg=' || A_PP ||
                      '#pgnode=0(hardc.)' ||
                      '#pa=' || A_PR||
                      '#pr_version=' || A_PR_VERSION ||
                      '#panode=0(hardc.)' ||
                      '#mt_nr_measur=' || TO_CHAR(L_MT_NR_MEASUR) ||
                      '#InitScMethod#ErrorCode=' || TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            END IF;

            
            
            
            IF L_NR_OF_ROWS > 0 THEN
               ASSIGN(L_PPPRMT_REC.MT);
               L_TOT_NR_ROWS := L_TOT_NR_ROWS + L_NR_OF_ROWS;
            END IF;
         END IF;

         L_OVR_RUL_MT_ASSG := TRUE;
      END IF;
      CLOSE L_PPPRMT_CURSOR;
   END IF;
   
   
   
   
   IF NOT L_OVR_RUL_MT_ASSG THEN
      L_REF_DATE := A_REF_DATE;
      IF L_REF_DATE IS NULL THEN
         SELECT SAMPLING_DATE
         INTO L_REF_DATE
         FROM UTSC
         WHERE SC = A_SC;
      END IF;
      IF L_REF_DATE IS NULL THEN
         L_REF_DATE := CURRENT_TIMESTAMP;
      END IF;

      L_RET_CODE := UNAPIAUT.INITPRMTBUFFER (A_PR , A_PR_VERSION) ;

      
      
      
      FOR L_PRMT_REC IN L_PRMT_CURSOR(A_PR , A_PR_VERSION) LOOP
         IF NVL(L_PRMT_REC.IGNORE_OTHER, '0') = '1' THEN
            
            OPEN L_SCME_CURSOR(A_PP, L_PGNODE, L_PRMT_REC.MT);
            FETCH L_SCME_CURSOR
            INTO L_OTHER_MENODE;
   
            IF L_SCME_CURSOR%FOUND THEN
               
               L_ASSIGN := FALSE;
            ELSE
               L_ASSIGN := TRUE;
            END IF;
            CLOSE L_SCME_CURSOR;
         ELSE
            L_ASSIGN := TRUE;
         END IF;
         
         
         
         
         
         IF L_ASSIGN THEN
            IF L_SUPPLIER <> ' ' OR
               L_CUSTOMER <> ' ' THEN
               OPEN L_SCMEALREADYASSIGNED_CURSOR (L_PRMT_REC.MT);
               FETCH L_SCMEALREADYASSIGNED_CURSOR
               INTO L_OTHER_MENODE;
               IF L_SCMEALREADYASSIGNED_CURSOR%FOUND THEN
                  
                  L_ASSIGN := FALSE;
               ELSE
                  L_ASSIGN := TRUE;
               END IF;
               CLOSE L_SCMEALREADYASSIGNED_CURSOR;
            END IF;
         END IF;         
   
         IF L_ASSIGN THEN
            
            L_ASSIGN := FALSE;
            IF L_FILTER_FREQ = '0' THEN
               L_ASSIGN := TRUE;
            ELSIF L_FILTER_FREQ = '1' THEN
               
               
                              
               L_RET_CODE := UNAPIAUT.INITSTMTFREQBUFFER (A_ST, A_ST_VERSION, A_PR, A_PR_VERSION, L_PRMT_REC.MT, L_PRMT_REC.MT_VERSION) ;
               
               OPEN L_STMTFREQ_CURSOR(L_PRMT_REC.MT, L_PRMT_REC.MT_VERSION);
               FETCH L_STMTFREQ_CURSOR
               INTO L_FREQ_TP, L_FREQ_VAL, L_FREQ_UNIT, L_INVERT_FREQ,
                    L_LAST_SCHED, L_LAST_CNT, L_LAST_VAL;
               L_FREQ_FROM := 'st';
   
               IF L_STMTFREQ_CURSOR%NOTFOUND OR 
                  L_PRMT_REC.ST_BASED_FREQ='0' THEN
                  L_FREQ_FROM := 'pr';
                  L_FREQ_TP := L_PRMT_REC.FREQ_TP;
                  L_FREQ_VAL := L_PRMT_REC.FREQ_VAL;
                  L_FREQ_UNIT := L_PRMT_REC.FREQ_UNIT;
                  L_INVERT_FREQ := L_PRMT_REC.INVERT_FREQ;
                  L_LAST_SCHED := L_PRMT_REC.LAST_SCHED;
                  L_LAST_CNT := L_PRMT_REC.LAST_CNT;
                  L_LAST_VAL := L_PRMT_REC.LAST_VAL;
               END IF;
               CLOSE L_STMTFREQ_CURSOR;
   
               L_ASSIGN := TRUE;
               IF L_FREQ_TP = 'C' THEN
   
                  
                  
                  
                  L_SQL_STRING := 'BEGIN :l_ret_code := UNFREQ.'|| L_FREQ_UNIT ||
                      '(:a_sc, :a_st, :a_st_version, :a_pp, :a_pp_version, '||
                      ':a_pp_key1, :a_pp_key2, :a_pp_key3, :a_pp_key4, :a_pp_key5, ' || 
                      ':a_pr, :a_pr_version, :a_mt, :a_mt_version, ' ||
                      ':a_freq_val, :a_invert_freq,:a_ref_date, :a_last_sched, :a_last_cnt, :a_last_val); END;';
      
                  L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
      
                  DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':l_ret_code', L_RET_CODE);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_sc', A_SC, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st', A_ST, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st_version', A_ST_VERSION, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp', A_PP, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_version', A_PP_VERSION, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key1', A_PP_KEY1, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key2', A_PP_KEY2, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key3', A_PP_KEY3, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key4', A_PP_KEY4, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pp_key5', A_PP_KEY5, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pr', A_PR, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pr_version', A_PR_VERSION, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_mt', L_PRMT_REC.MT, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_mt_version', L_PRMT_REC.MT_VERSION, 20);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_freq_val', L_FREQ_VAL);
                  DBMS_SQL.BIND_VARIABLE_CHAR(L_DYN_CURSOR, ':a_invert_freq', L_INVERT_FREQ, 1);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_ref_date', L_REF_DATE);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_sched', L_LAST_SCHED);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_cnt', L_LAST_CNT);
                  DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_last_val', L_LAST_VAL, 40);
   
                  L_RESULT := DBMS_SQL.EXECUTE(L_DYN_CURSOR);
                  DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':l_ret_code', L_RET_CODE);
                  DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_sched', L_LAST_SCHED);
                  DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_cnt', L_LAST_CNT);
                  DBMS_SQL.VARIABLE_VALUE(L_DYN_CURSOR, ':a_last_val', L_LAST_VAL);
                  
                  DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      
                  IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                     L_ASSIGN := FALSE;
                  END IF;
               ELSE
                  IF NOT UNAPIAUT.EVALASSIGNMENTFREQ('sc', A_SC, '', 'pa', A_PR, '', 
                                                     L_FREQ_TP, L_FREQ_VAL,
                                                     L_FREQ_UNIT, L_INVERT_FREQ,
                                                     L_REF_DATE, L_LAST_SCHED,
                                                     L_LAST_CNT, L_LAST_VAL) THEN
                     L_ASSIGN := FALSE;
                  END IF;
               END IF;

               
               
               
               IF L_FREQ_FROM = 'st' THEN
                  
                  UPDATE UTSTMTFREQBUFFER
                  SET LAST_SCHED = L_LAST_SCHED,
                      LAST_SCHED_TZ = DECODE(L_LAST_SCHED, LAST_SCHED_TZ, LAST_SCHED_TZ, L_LAST_SCHED) ,
                      LAST_CNT = L_LAST_CNT,
                      LAST_VAL = L_LAST_VAL,
                      HANDLED = 'Y'
                  WHERE ST = A_ST
                    AND VERSION = A_ST_VERSION
                    AND PR = A_PR
                    AND PR_VERSION = A_PR_VERSION
                    AND MT = L_PRMT_REC.MT
                    AND MT_VERSION = L_PRMT_REC.MT_VERSION;

                  UPDATE UTPRMTBUFFER
                  SET LAST_SCHED = L_LAST_SCHED,
                      LAST_SCHED_TZ = DECODE(L_LAST_SCHED, LAST_SCHED_TZ, LAST_SCHED_TZ, L_LAST_SCHED),
                      LAST_CNT = L_LAST_CNT,
                      LAST_VAL = L_LAST_VAL,
                      HANDLED = 'Y'
                  WHERE PR = L_PRMT_REC.PR
                    AND VERSION = L_PRMT_REC.PR_VERSION
                    AND MT = L_PRMT_REC.MT
                    AND UNAPIGEN.VALIDATEVERSION('mt',MT,MT_VERSION) = UNAPIGEN.VALIDATEVERSION('mt',L_PRMT_REC.MT,L_PRMT_REC.MT_VERSION)
                    AND SEQ = L_PRMT_REC.SEQ;
                                 
               ELSIF L_PRMT_REC.ST_BASED_FREQ = '1' THEN
                  
                  
                  INSERT INTO UTSTMTFREQBUFFER(ST, VERSION, PR, PR_VERSION, MT, MT_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT,
                                         INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT,
                                         LAST_VAL, HANDLED)
                  VALUES(A_ST, A_ST_VERSION, A_PR, A_PR_VERSION, L_PRMT_REC.MT, L_PRMT_REC.MT_VERSION, L_FREQ_TP, L_FREQ_VAL,
                         L_FREQ_UNIT,L_INVERT_FREQ, L_LAST_SCHED, L_LAST_SCHED, L_LAST_CNT,
                         L_LAST_VAL, 'Y');

                  UPDATE UTPRMTBUFFER
                  SET LAST_SCHED = L_LAST_SCHED,
                      LAST_SCHED_TZ = DECODE(L_LAST_SCHED, LAST_SCHED_TZ, LAST_SCHED_TZ, L_LAST_SCHED),
                      LAST_CNT = L_LAST_CNT,
                      LAST_VAL = L_LAST_VAL,
                      HANDLED = 'Y'
                  WHERE PR = L_PRMT_REC.PR
                    AND VERSION = L_PRMT_REC.PR_VERSION
                    AND MT = L_PRMT_REC.MT
                    AND UNAPIGEN.VALIDATEVERSION('mt',MT,MT_VERSION) = UNAPIGEN.VALIDATEVERSION('mt',L_PRMT_REC.MT,L_PRMT_REC.MT_VERSION)
                    AND SEQ = L_PRMT_REC.SEQ;
                    
               ELSE               
                  UPDATE UTPRMTBUFFER
                  SET LAST_SCHED = L_LAST_SCHED,
                      LAST_SCHED_TZ = DECODE(L_LAST_SCHED, LAST_SCHED_TZ, LAST_SCHED_TZ, L_LAST_SCHED),
                      LAST_CNT = L_LAST_CNT,
                      LAST_VAL = L_LAST_VAL,
                      HANDLED = 'Y'
                  WHERE PR = L_PRMT_REC.PR
                    AND VERSION = L_PRMT_REC.PR_VERSION
                    AND MT = L_PRMT_REC.MT
                    AND UNAPIGEN.VALIDATEVERSION('mt',MT,MT_VERSION) = UNAPIGEN.VALIDATEVERSION('mt',L_PRMT_REC.MT,L_PRMT_REC.MT_VERSION)
                    AND SEQ = L_PRMT_REC.SEQ;
               END IF;
            END IF;
         END IF;
            
         IF L_ASSIGN THEN
         
            
            
            
            L_NR_OF_ROWS := 0;
            L_RET_CODE := UNAPIME.INITSCMETHOD(L_PRMT_REC.MT, 
                                    UNAPIGEN.VALIDATEVERSION('mt', L_PRMT_REC.MT, L_PRMT_REC.MT_VERSION), 
                                    L_PRMT_REC.SEQ, A_SC, A_PP, 0,
                                    A_PR, 0, A_PR_VERSION, NULL, L_REANALYSIS,
                                    L_MT_VERSION, L_DESCRIPTION,
                                    L_VALUE_F, L_VALUE_S, L_UNIT, L_EXEC_START_DATE,
                                    L_EXEC_END_DATE, L_EXECUTOR, L_LAB, L_EQ, L_EQ_VERSION,
                                    L_PLANNED_EXECUTOR, L_PLANNED_EQ, L_PLANNED_EQ_VERSION,
                                    L_MANUALLY_ENTERED,
                                    L_ALLOW_ADD, L_ASSIGN_DATE, L_ASSIGNED_BY,
                                    L_MANUALLY_ADDED, L_DELAY, L_DELAY_UNIT,
                                    L_FORMAT, L_ACCURACY, L_REAL_COST,
                                    L_REAL_TIME, L_CALIBRATION, L_CONFIRM_COMPLETE,
                                    L_AUTORECALC, L_ME_RESULT_EDITABLE, 
                                    L_NEXT_CELL, L_SOP, L_SOP_VERSION, 
                                    L_PLAUS_LOW, L_PLAUS_HIGH, 
                                    L_WINSIZE_X, L_WINSIZE_Y, 
                                    L_ME_CLASS, L_LOG_HS, L_LOG_HS_DETAILS,
                                    L_LC, L_LC_VERSION, L_NR_OF_ROWS);
   
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               L_SQLERRM := 'mt='||L_PRMT_REC.MT ||
                      '#mt_version_in='||L_PRMT_REC.MT_VERSION ||
                      '#seq='|| TO_CHAR(L_PRMT_REC.SEQ) ||
                      '#sc=' || A_SC || 
                      '#pg=' || A_PP ||
                      '#pgnode=0(hardc.)' ||
                      '#pa=' || A_PR||
                      '#pr_version=' || A_PR_VERSION ||
                      '#panode=0(hardc.)' ||
                      '#mt_nr_measur=' || TO_CHAR(L_MT_NR_MEASUR) ||
                      '#InitScMethod#ErrorCode=' || TO_CHAR(L_RET_CODE);
               RAISE STPERROR;
            END IF;
   
            
            
            
            IF L_NR_OF_ROWS > 0 THEN
               ASSIGN(L_PRMT_REC.MT);
               L_TOT_NR_ROWS := L_TOT_NR_ROWS + L_NR_OF_ROWS;
            END IF;
         END IF;
      END LOOP;
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN 
      RAISE STPERROR;
   END IF;

   
   
   
   
   IF L_TOT_NR_ROWS > A_NR_OF_ROWS THEN
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'InitScPaDetails','a_nr_of_rows (' || A_NR_OF_ROWS ||
             ') too small for required Method initialisation');
   END IF;

   A_NR_OF_ROWS := L_TOT_NR_ROWS;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('InitScPaDetails', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('InitScPaDetails', L_SQLERRM);   
   END IF;
   IF L_STMTFREQ_CURSOR%ISOPEN THEN
      CLOSE L_STMTFREQ_CURSOR;
   END IF;
   IF L_SCME_CURSOR%ISOPEN THEN
      CLOSE L_SCME_CURSOR;
   END IF;
   IF L_PPPRMT_CURSOR%ISOPEN THEN
      CLOSE L_PPPRMT_CURSOR;
   END IF;
   IF L_PRMT2_CURSOR%ISOPEN THEN
      CLOSE L_PRMT2_CURSOR;
   END IF;
   IF L_SCPG_CURSOR%ISOPEN THEN
      CLOSE L_SCPG_CURSOR;
   END IF;
   IF L_PP_CURSOR%ISOPEN THEN
      CLOSE L_PP_CURSOR;
   END IF;
   IF L_SCMEALREADYASSIGNED_CURSOR%ISOPEN THEN
      CLOSE L_SCMEALREADYASSIGNED_CURSOR;
   END IF;
   IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'InitScPaDetails'));
END INITSCPADETAILS;

FUNCTION SAVESCPARESULT                               
(A_ALARMS_HANDLED   IN     CHAR,                      
 A_SC               IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PG               IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PGNODE           IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_PA               IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PANODE           IN     UNAPIGEN.LONG_TABLE_TYPE,  
 A_VALUE_F          IN     UNAPIGEN.FLOAT_TABLE_TYPE, 
 A_VALUE_S          IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_UNIT             IN     UNAPIGEN.VC20_TABLE_TYPE,  
 A_FORMAT           IN     UNAPIGEN.VC40_TABLE_TYPE,  
 A_EXEC_END_DATE    IN OUT UNAPIGEN.DATE_TABLE_TYPE,  
 A_EXECUTOR         IN OUT UNAPIGEN.VC20_TABLE_TYPE,  
 A_MANUALLY_ENTERED IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_REANALYSIS       OUT    UNAPIGEN.NUM_TABLE_TYPE,   
 A_MODIFY_FLAG      IN OUT UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS       IN     NUMBER,                    
 A_MODIFY_REASON    IN     VARCHAR2)                  
RETURN NUMBER IS

L_LC                                 VARCHAR2(2);
L_LC_VERSION                         VARCHAR2(20);
L_SS                                 VARCHAR2(2);
L_LOG_HS                             CHAR(1);
L_LOG_HS_DETAILS                     CHAR(1);
L_ALLOW_MODIFY                       CHAR(1);
L_ACTIVE                             CHAR(1);
L_CURRENT_TIMESTAMP                            TIMESTAMP WITH TIME ZONE;
L_SEQ_NO                             INTEGER;
L_EXEC_START_DATE                    TIMESTAMP WITH TIME ZONE;
L_EXEC_END_DATE                      TIMESTAMP WITH TIME ZONE;
L_OLD_UNIT                           VARCHAR2(20);
L_CELL_UNIT                          VARCHAR2(20);
L_FORMAT                             VARCHAR2(40);
L_OLD_FORMAT                         VARCHAR2(40);
L_CELL_FORMAT                        VARCHAR2(40);
L_TD_INFO                            NUMBER(3);
L_TD_INFO_UNIT                       VARCHAR2(20);
L_REANALYSIS                         NUMBER(3);
L_VALUE_F                            NUMBER;
L_VALUE_F_IN                         NUMBER;
L_VALUE_S                            VARCHAR2(40);
L_VALUE_S_IN                         VARCHAR2(40);
L_OLD_VALUE_F                        NUMBER;
L_OLD_VALUE_S                        VARCHAR2(40);
L_CELL_VALUE_F                       FLOAT;
L_CELL_VALUE_S                       VARCHAR2(40);
L_CHECK                              VARCHAR2(2);
L_NEXT_CELL                          VARCHAR2(20);
L_PA_RECORD_OK                       BOOLEAN;
L_PA_HANDLED                         BOOLEAN;
L_COMPLETELY_SAVED                   BOOLEAN;
L_COMPLETELY_CHARTED                 BOOLEAN;
L_CHART_OK                           BOOLEAN;
L_DATE_CURSOR                        INTEGER;
L_DATE                               TIMESTAMP WITH TIME ZONE;
L_HS_DETAILS_SEQ_NR                  INTEGER;
L_PR_VERSION                         VARCHAR2(20);
L_ST                                 VARCHAR2(20);
L_ST_VERSION                         VARCHAR2(20);
L_CH                                 VARCHAR2(20);
L_DATAPOINT_SEQ                      NUMBER;
L_MEASURE_SEQ                        NUMBER;
L_CH_CONTEXT_KEY                     VARCHAR2(255);
L_DATAPOINT_LINK                     VARCHAR2(255);
L_NEW_CHART                          BOOLEAN;
L_COUNTER                            NUMBER;
L_CH_TAB                             UNAPIGEN.VC20_TABLE_TYPE;
L_DATAPOINT_SEQ_TAB                  UNAPIGEN.NUM_TABLE_TYPE;
L_MEASURE_SEQ_TAB                    UNAPIGEN.NUM_TABLE_TYPE;
L_X_VALUE_F_TAB                      UNAPIGEN.FLOAT_TABLE_TYPE;
L_X_VALUE_S_TAB                      UNAPIGEN.VC40_TABLE_TYPE;
L_X_VALUE_S                          VARCHAR2(2000);
L_X_VALUE_D_TAB                      UNAPIGEN.DATE_TABLE_TYPE;
L_DATAPOINT_VALUE_F_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
L_DATAPOINT_VALUE_S_TAB              UNAPIGEN.VC40_TABLE_TYPE;
L_DATAPOINT_LABEL_TAB                UNAPIGEN.VC255_TABLE_TYPE;
L_DATAPOINT_MARKER_TAB               UNAPIGEN.VC20_TABLE_TYPE;
L_DATAPOINT_COLOUR_TAB               UNAPIGEN.VC20_TABLE_TYPE;
L_DATAPOINT_LINK_TAB                 UNAPIGEN.VC255_TABLE_TYPE;
L_Z_VALUE_F_TAB                      UNAPIGEN.FLOAT_TABLE_TYPE;
L_Z_VALUE_S_TAB                      UNAPIGEN.VC40_TABLE_TYPE;
L_DATAPOINT_RANGE_TAB                UNAPIGEN.NUM_TABLE_TYPE;
L_SQC_AVG_TAB                        UNAPIGEN.FLOAT_TABLE_TYPE;
L_SQC_AVG_RANGE_TAB                  UNAPIGEN.FLOAT_TABLE_TYPE;
L_SQC_SIGMA_TAB                      UNAPIGEN.FLOAT_TABLE_TYPE;
L_SQC_SIGMA_RANGE_TAB                UNAPIGEN.FLOAT_TABLE_TYPE;
L_ACTIVE_TAB                         UNAPIGEN.CHAR1_TABLE_TYPE;
L_NR_OF_ROWS                         NUMBER;
L_LAST_COMMENT                       VARCHAR2(255);
L_X_LABEL                            VARCHAR2(60);
L_X_LABEL_BETWEEN_TILDES             VARCHAR2(60);
L_ME_LOG_HS_DETAILS                  CHAR(1);
L_Y_AXIS_UNIT                        VARCHAR2(20);
L_Y_AXIS_FORMAT                      VARCHAR2(20);
L_NR_OF_ROWS_IN                      NUMBER;
L_NR_OF_ROWS_OUT                     NUMBER;
L_WHERE_CLAUSE                       VARCHAR2(511);
L_NEXT_ROWS                          NUMBER;
L_SC_TAB                             UNAPIGEN.VC20_TABLE_TYPE;
L_PG_TAB                             UNAPIGEN.VC20_TABLE_TYPE;
L_PGNODE_TAB                         UNAPIGEN.LONG_TABLE_TYPE;
L_PA_TAB                             UNAPIGEN.VC20_TABLE_TYPE;
L_PANODE_TAB                         UNAPIGEN.LONG_TABLE_TYPE;
L_LAST_COMMENT_TAB                   UNAPIGEN.VC255_TABLE_TYPE;
L_SPEC1_TAB                          UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC2_TAB                          UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC3_TAB                          UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC4_TAB                          UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC5_TAB                          UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC6_TAB                          UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC7_TAB                          UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC8_TAB                          UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC9_TAB                          UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC10_TAB                         UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC11_TAB                         UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC12_TAB                         UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC13_TAB                         UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC14_TAB                         UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC15_TAB                         UNAPIGEN.FLOAT_TABLE_TYPE;
L_RULE1_VIOLATED_TAB                 UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE2_VIOLATED_TAB                 UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE3_VIOLATED_TAB                 UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE4_VIOLATED_TAB                 UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE5_VIOLATED_TAB                 UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE6_VIOLATED_TAB                 UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE7_VIOLATED_TAB                 UNAPIGEN.CHAR1_TABLE_TYPE;

L_CH_TITLE                           VARCHAR2(255);
L_CH_X_AXIS_TITLE                    VARCHAR2(255);
L_CH_Y_AXIS_TITLE                    VARCHAR2(255);
L_PA_OBJECT_KEY                      VARCHAR2(255);
L_CH_OBJECT_KEY                      VARCHAR2(255);
L_RECURSIVE_LEVEL                    CHAR(1);
L_SCPAOUTPUT_SC_TAB                  UNAPIGEN.VC20_TABLE_TYPE;
L_SCPAOUTPUT_PG_TAB                  UNAPIGEN.VC20_TABLE_TYPE;
L_SCPAOUTPUT_PGNODE_TAB              UNAPIGEN.LONG_TABLE_TYPE;
L_SCPAOUTPUT_PA_TAB                  UNAPIGEN.VC20_TABLE_TYPE;
L_SCPAOUTPUT_PANODE_TAB              UNAPIGEN.LONG_TABLE_TYPE;
L_SCPAOUTPUT_VALUE_F_TAB             UNAPIGEN.FLOAT_TABLE_TYPE;
L_SCPAOUTPUT_VALUE_S_TAB             UNAPIGEN.VC40_TABLE_TYPE;
L_SCPAOUTPUT_UNIT_TAB                UNAPIGEN.VC20_TABLE_TYPE;
L_SCPAOUTPUT_FORMAT_TAB              UNAPIGEN.VC40_TABLE_TYPE;
L_SCPAOUTPUT_EXEC_END_DATE_TAB       UNAPIGEN.DATE_TABLE_TYPE;
L_SCPAOUTPUT_EXECUTOR_TAB            UNAPIGEN.VC20_TABLE_TYPE;
L_SCPAOUTPUT_REANALYSIS_TAB          UNAPIGEN.NUM_TABLE_TYPE;
L_SCPAOUTPUT_MODIFY_FLAG_TAB         UNAPIGEN.NUM_TABLE_TYPE;

L_SCPG_PP_VERSION                    VARCHAR2(20);
L_SCPG_PP_KEY1                       VARCHAR2(20);
L_SCPG_PP_KEY2                       VARCHAR2(20);
L_SCPG_PP_KEY3                       VARCHAR2(20);
L_SCPG_PP_KEY4                       VARCHAR2(20);
L_SCPG_PP_KEY5                       VARCHAR2(20);
L_SCPG_CUSTOMER                      VARCHAR2(20);
L_SCPG_SUPPLIER                      VARCHAR2(20);
L_ORIG_AR_CHECK_MODE                 CHAR(1);
L_IGNORED_RET_CODE                   INTEGER;





                       
CURSOR L_SCMECELLINPUT_CURSOR(A_SC IN VARCHAR2,
                              A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                              A_PA IN VARCHAR2, A_PANODE IN NUMBER) IS
   
   
   SELECT '1' FIRSTUSE, B.PG, B.PGNODE, B.PA, B.PANODE, B.ME, B.MENODE, A.MT_VERSION, B.REANALYSIS, B.CELL, 
          B.FORMAT FORMAT, C.INPUT_TP, C.INPUT_SOURCE, C.INPUT_VERSION, C.INPUT_PG, C.INPUT_PGNODE, 
          C.INPUT_PP_VERSION, C.INPUT_PA, C.INPUT_PANODE, C.INPUT_PR_VERSION, C.INPUT_ME, 
          C.INPUT_MENODE, C.INPUT_MT_VERSION, C.INPUT_REANALYSIS
   FROM UTSCME A , UTSCMECELL B, UTSCMECELLINPUT C
   WHERE C.SC = A_SC
     AND C.INPUT_PANODE IS NULL 
     AND NVL(C.INPUT_PG, A_PG)  = A_PG
     AND C.SC = A.SC
     AND C.PG = A.PG
     AND C.PGNODE = A.PGNODE
     AND C.PA = A.PA
     AND C.PANODE = A.PANODE
     AND C.ME = A.ME
     AND C.MENODE = A.MENODE
     AND C.INPUT_TP = 'pr'
     AND C.INPUT_PA = A_PA
     AND NVL(A.SS, '@~') <> '@C'
     
     
     AND UNAPIAUT.SQLGETSCMEALLOWMODIFY(A.SC, A.PG, A.PGNODE, A.PA, A.PANODE, A.ME, A.MENODE, A.REANALYSIS) = '1'
     AND A.EXEC_END_DATE IS NULL
     AND C.SC = B.SC
     AND C.PG = B.PG
     AND C.PGNODE = B.PGNODE
     AND C.PA = B.PA
     AND C.PANODE = B.PANODE
     AND C.ME = B.ME
     AND C.MENODE = B.MENODE
     AND C.CELL = B.CELL
   UNION
   
   SELECT '0' FIRSTUSE, B.PG, B.PGNODE, B.PA, B.PANODE, B.ME, B.MENODE, A.MT_VERSION, B.REANALYSIS, B.CELL, 
          B.FORMAT FORMAT, C.INPUT_TP, C.INPUT_SOURCE, C.INPUT_VERSION, C.INPUT_PG, C.INPUT_PGNODE, 
          C.INPUT_PP_VERSION, C.INPUT_PA, C.INPUT_PANODE, C.INPUT_PR_VERSION, C.INPUT_ME, 
          C.INPUT_MENODE, C.INPUT_MT_VERSION, C.INPUT_REANALYSIS
   FROM UTSCME A , UTSCMECELL B, UTSCMECELLINPUT C
   WHERE C.SC = A_SC
     AND C.INPUT_PG = A_PG
     AND C.INPUT_PGNODE = A_PGNODE
     AND C.INPUT_PA = A_PA
     AND C.INPUT_PANODE = A_PANODE
     AND C.SC = A.SC
     AND C.PG = A.PG
     AND C.PGNODE = A.PGNODE
     AND C.PA = A.PA
     AND C.PANODE = A.PANODE
     AND C.ME = A.ME
     AND C.MENODE = A.MENODE
     AND C.INPUT_TP = 'pr'
     AND C.INPUT_PA = A_PA
     AND NVL(A.SS, '@~') <> '@C'
     
     
     AND UNAPIAUT.SQLGETSCMEALLOWMODIFY(A.SC, A.PG, A.PGNODE, A.PA, A.PANODE, A.ME, A.MENODE, A.REANALYSIS) = '1'
     AND A.EXEC_END_DATE IS NULL
     AND C.SC = B.SC
     AND C.PG = B.PG
     AND C.PGNODE = B.PGNODE
     AND C.PA = B.PA
     AND C.PANODE = B.PANODE
     AND C.ME = B.ME
     AND C.MENODE = B.MENODE
     AND C.CELL = B.CELL
  ORDER BY 1,3,5,7 DESC;

CURSOR C_FIRST_EMPTY_CELL (C_SC VARCHAR2, C_PG VARCHAR2, C_PGNODE VARCHAR2,
                     C_PA VARCHAR2, C_PANODE VARCHAR2,
                     C_ME VARCHAR2, C_MENODE VARCHAR2) IS
   SELECT CELL
   FROM UTSCMECELL
   WHERE SC = C_SC
     AND PG = C_PG
     AND PGNODE = C_PGNODE
     AND PA = C_PA
     AND PANODE = C_PANODE
     AND ME = C_ME
     AND MENODE = C_MENODE
     AND VALUE_S IS NULL
   ORDER BY CELLNODE;

CURSOR C_ASSIGNED_ME (C_SC VARCHAR2, C_PG VARCHAR2, C_PGNODE VARCHAR2,
                      C_PA VARCHAR2, C_PANODE VARCHAR2) IS
   SELECT ME, MENODE
   FROM UTSCME
   WHERE SC = C_SC
     AND PG = C_PG
     AND PGNODE = C_PGNODE
     AND PA = C_PA
     AND PANODE = C_PANODE
   ORDER BY PGNODE, PANODE;

CURSOR C_CY (C_PR VARCHAR2, C_PR_VERSION VARCHAR2, C_ST VARCHAR2, C_ST_VERSION VARCHAR2 ) IS
   SELECT CY, CY_VERSION
   FROM UTPRCYST
   WHERE PR = C_PR 
     AND VERSION = C_PR_VERSION
     AND NVL(ST, C_ST) = C_ST 
     AND NVL(DECODE(ST_VERSION, '~Current~',NULL, ST_VERSION), C_ST_VERSION) = C_ST_VERSION
   ORDER BY CY;
       
      

CURSOR C_X_LABEL( C_CY VARCHAR2, C_CY_VERSION VARCHAR2) IS
SELECT X_LABEL FROM UTCY WHERE
   CY = C_CY
   AND VERSION = UNAPIGEN.VALIDATEVERSION('cy', C_CY, C_CY_VERSION);

CURSOR C_Y_AXIS_UNIT( C_CH IN VARCHAR2) IS
SELECT Y_AXIS_UNIT FROM UTCH WHERE
   CH = C_CH;

CURSOR L_ST_CURSOR(C_SC VARCHAR2) IS
   SELECT ST, ST_VERSION 
   FROM UTSC
   WHERE SC = C_SC;
   
CURSOR L_CH_EXISTS_CURSOR(C_CH VARCHAR2) IS
   SELECT CH 
   FROM UTCH
   WHERE CH = C_CH;

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
L_SCPAOLD_REC UDSCPA%ROWTYPE;
L_SCPANEW_REC UDSCPA%ROWTYPE;

CURSOR L_CELL_OLD_CURSOR(C_SC VARCHAR2, 
                         C_PG VARCHAR2, C_PGNODE NUMBER,
                         C_PA VARCHAR2, C_PANODE NUMBER,
                         C_ME VARCHAR2, C_MENODE NUMBER,
                         C_CELL VARCHAR2) IS
   SELECT VALUE_F, VALUE_S, UNIT, FORMAT 
   FROM UTSCMECELL
   WHERE SC = C_SC
   AND PG = C_PG
   AND PGNODE = C_PGNODE
   AND PA = C_PA
   AND PANODE = C_PANODE
   AND ME = C_ME
   AND MENODE = C_MENODE
   AND CELL = C_CELL;

CURSOR L_SCME_CURSOR(C_SC VARCHAR2, 
                     C_PG VARCHAR2, C_PGNODE NUMBER,
                     C_PA VARCHAR2, C_PANODE NUMBER,
                     C_ME VARCHAR2, C_MENODE NUMBER) IS
   SELECT LOG_HS_DETAILS
   FROM UTSCME
   WHERE SC = C_SC
   AND PG = C_PG
   AND PGNODE = C_PGNODE
   AND PA = C_PA
   AND PANODE = C_PANODE
   AND ME = C_ME
   AND MENODE = C_MENODE;
   
CURSOR C_CH_TITLES ( C_CH IN VARCHAR2) IS
   SELECT CHART_TITLE, X_AXIS_TITLE, Y_AXIS_TITLE
   FROM UTCH
   WHERE CH = C_CH;      



CURSOR L_SCPA_CURSOR(C_SC VARCHAR2, C_PG VARCHAR2, C_PGNODE NUMBER,
                     C_PA VARCHAR2, C_PANODE NUMBER, C_PR_VERSION VARCHAR2,
                     C_PP_VERSION VARCHAR2, C_PP_KEY1 VARCHAR2, C_PP_KEY2 VARCHAR2,
                     C_PP_KEY3 VARCHAR2, C_PP_KEY4 VARCHAR2, C_PP_KEY5 VARCHAR2) IS
   SELECT PA.SC, PA.PG, PA.PGNODE, PA.PA, PA.PANODE, 
          PG.PP_KEY1, PG.PP_KEY2, PG.PP_KEY3, PG.PP_KEY4, PG.PP_KEY5
   FROM UTSCPA PA, UTSCPG PG
   WHERE PA.SC = C_SC
     
     AND (PA.PG,PA.PGNODE,PA.PA,PA.PANODE) NOT IN ((C_PG,C_PGNODE,C_PA,C_PANODE))
     
     AND PA.PA = C_PA
     
     
     
     AND PG.SC     = PA.SC
     AND PG.PG     = PA.PG
     AND PG.PGNODE = PA.PGNODE
     AND (PG.PG,PG.PP_VERSION,PG.PP_KEY1,PG.PP_KEY2,PG.PP_KEY3,PG.PP_KEY4,PG.PP_KEY5) NOT IN
           ((C_PG,C_PP_VERSION,C_PP_KEY1,C_PP_KEY2,C_PP_KEY3,C_PP_KEY4,C_PP_KEY5))
     
     AND 0 = (SELECT COUNT(*)
                FROM UTSCME ME 
               WHERE ME.SC              = PA.SC
                 AND ME.PG              = PA.PG
                 AND ME.PGNODE          = PA.PGNODE
                 AND ME.PA              = PA.PA
                 AND ME.PANODE          = PA.PANODE
                 AND NVL(ME.ACTIVE,'1') = '1'
                 AND NVL(ME.SS,'@~')    <> '@C')
     
     
     
     AND DECODE(PA.SS, NULL, '1', NVL(PA.ACTIVE,'1')) = '1'
     AND NVL(PA.SS,'@~') <> '@C'
   ORDER BY PA.PGNODE;
L_SCPA_REC UTSCPA%ROWTYPE;

CURSOR L_SCPAOUTPUT_CURSOR(C_SC VARCHAR2, 
                           C_PG VARCHAR2, C_PGNODE NUMBER,
                           C_PA VARCHAR2, C_PANODE NUMBER) IS
   SELECT PAOUT.SC, PAOUT.SAVE_PG, PAOUT.SAVE_PGNODE, PAOUT.SAVE_PA, PAOUT.SAVE_PANODE,
          PA.VALUE_S, PA.VALUE_F, PA.UNIT, PA.FORMAT
   FROM UTSCPA PA, UTSCPAOUTPUT PAOUT
   WHERE PAOUT.SC     = C_SC
     AND PAOUT.PG     = C_PG
     AND PAOUT.PGNODE = C_PGNODE
     AND PAOUT.PA     = C_PA
     AND PAOUT.PANODE = C_PANODE
     AND PAOUT.SC     = PA.SC
     AND PAOUT.SAVE_PG     = PA.PG
     AND PAOUT.SAVE_PGNODE = PA.PGNODE
     AND PAOUT.SAVE_PA     = PA.PA
     AND PAOUT.SAVE_PANODE = PA.PANODE;
L_SCPAOUTPUT_REC UTSCPAOUTPUT%ROWTYPE;

CURSOR L_SCPG_CURSOR(C_SC VARCHAR2, C_PG VARCHAR2, C_PGNODE NUMBER) IS
   SELECT PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5
   FROM UTSCPG
   WHERE SC     = C_SC
     AND PG     = C_PG
     AND PGNODE = C_PGNODE;
L_SCPG_REC UTSCPG%ROWTYPE;

   FUNCTION SUBSTITUTETILDES
   (A_TEXT           IN OUT  VARCHAR2,
    A_PA_OBJECT_KEY  IN      VARCHAR2,
    A_CH_OBJECT_KEY  IN      VARCHAR2)
   RETURN NUMBER IS
      L_TEXT         VARCHAR2(255);
      L_TEXT_PIECE   VARCHAR2(255);
      L_POS_A        INTEGER;
      L_POS_B        INTEGER;
      L_OUTPUT       VARCHAR2(255);
      L_OBJECT_TP    VARCHAR2(4);
      L_OBJECT_KEY   VARCHAR2(255);
      L_ASKED_VALUE  VARCHAR2(255);
   BEGIN
      L_TEXT     := A_TEXT;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;

      
      IF INSTR(L_TEXT,'@') > 0 THEN
         L_POS_B := INSTR(L_TEXT, '~', 1, 2);

         IF L_POS_B > 0 THEN
            WHILE (L_POS_B > 0) AND (L_RET_CODE = UNAPIGEN.DBERR_SUCCESS) LOOP
               IF (L_POS_B > 0) THEN
                  L_POS_A      := INSTR(L_TEXT, '~');
                  L_TEXT_PIECE := SUBSTR(L_TEXT, L_POS_A, L_POS_B - L_POS_A + 1);
               END IF;

               
               L_ASKED_VALUE := REPLACE(L_TEXT_PIECE, '~');
               L_OBJECT_TP := SUBSTR(L_ASKED_VALUE, 1, INSTR(L_ASKED_VALUE,'@',1)-1);
               IF L_OBJECT_TP = 'pa' THEN
                  L_OBJECT_KEY := A_PA_OBJECT_KEY;
               ELSIF L_OBJECT_TP = 'ch' THEN
                  L_OBJECT_KEY := A_CH_OBJECT_KEY;
               ELSE
                  
                  L_OBJECT_TP := 'pa';
                  L_OBJECT_KEY := A_PA_OBJECT_KEY;
               END IF;

               L_OUTPUT := L_TEXT_PIECE;
               L_RET_CODE := UNAPIGEN.SUBSTITUTEALLTILDESINTEXT(L_OBJECT_TP, L_OBJECT_KEY, L_OUTPUT);

               L_TEXT   := REPLACE(L_TEXT, L_TEXT_PIECE, L_OUTPUT);
               L_POS_B  := INSTR(L_TEXT, '~', 1, 2);
            END LOOP; 
         ELSE
            
            L_ASKED_VALUE := REPLACE(L_TEXT, '~');
            L_OBJECT_TP := SUBSTR(L_ASKED_VALUE, 1, INSTR(L_ASKED_VALUE,'@',1)-1);
            IF L_OBJECT_TP = 'pa' THEN
               L_OBJECT_KEY := A_PA_OBJECT_KEY;
            ELSIF L_OBJECT_TP = 'ch' THEN
               L_OBJECT_KEY := A_CH_OBJECT_KEY;
            ELSE
               
               L_OBJECT_TP := 'pa';
               L_OBJECT_KEY := A_PA_OBJECT_KEY;
            END IF;

            L_RET_CODE := UNAPIGEN.SUBSTITUTEALLTILDESINTEXT(L_OBJECT_TP, L_OBJECT_KEY, L_TEXT);
         END IF;
         A_TEXT := L_TEXT;
      END IF;

      RETURN(L_RET_CODE);
   END SUBSTITUTETILDES;

BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   L_SQLERRM := NULL;
   L_IGNORED_RET_CODE := UNAPIAUT.GETARCHECKMODE(L_ORIG_AR_CHECK_MODE);
   IF NVL(A_ALARMS_HANDLED, UNAPIGEN.ALARMS_NOT_HANDLED) 
      NOT IN (UNAPIGEN.ALARMS_NOT_HANDLED, UNAPIGEN.ALARMS_PARTIALLY_HANDLED, UNAPIGEN.ALARMS_ALREADY_HANDLED) THEN
      L_SQLERRM := 'Invalid value for alarms_handled flag '||NVL(A_ALARMS_HANDLED, 'EMPTY');
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;

   
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   L_COMPLETELY_CHARTED := TRUE;
   L_COMPLETELY_SAVED := TRUE;
   L_HS_DETAILS_SEQ_NR := 0;
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      
      L_PA_RECORD_OK := TRUE;          
      L_PA_HANDLED := TRUE;
      
      IF NVL(A_SC(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PG(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PGNODE(L_SEQ_NO), 0) = 0 OR
         NVL(A_PA(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_PANODE(L_SEQ_NO), 0) = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;

      ELSIF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_UPDATE THEN
         
         
         
         L_RET_CODE := UNAPIAUT.GETSCPAAUTHORISATION(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                                                     A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO), L_PR_VERSION, 
                                                     L_LC, L_LC_VERSION, L_SS, L_ALLOW_MODIFY,
                                                     L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
            L_RET_CODE <> UNAPIGEN.DBERR_NOTMODIFIABLE THEN
            A_MODIFY_FLAG(L_SEQ_NO) := L_RET_CODE;
            L_PA_RECORD_OK := FALSE;
         END IF;

      ELSIF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.DBERR_SUCCESS THEN
         
         
         
         L_PA_RECORD_OK := FALSE; 
         L_PA_HANDLED := FALSE;   

      ELSE
         
         
         
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INVALMODFLAG;
         RAISE STPERROR;

      END IF;

      
      
      
      IF NVL(A_MANUALLY_ENTERED(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MANUALLY_ENTERED;
         RAISE STPERROR;
      END IF;

      IF L_PA_RECORD_OK THEN
         
         
         
         SELECT EXEC_START_DATE, EXEC_END_DATE, FORMAT, REANALYSIS, TD_INFO, TD_INFO_UNIT, VALUE_F, VALUE_S
         INTO L_EXEC_START_DATE, L_EXEC_END_DATE, L_FORMAT, L_REANALYSIS, L_TD_INFO, L_TD_INFO_UNIT, L_OLD_VALUE_F, L_OLD_VALUE_S
         FROM UTSCPA
         WHERE SC = A_SC(L_SEQ_NO)
           AND PG = A_PG(L_SEQ_NO)
           AND PGNODE = A_PGNODE(L_SEQ_NO)
           AND PA = A_PA(L_SEQ_NO)
           AND PANODE = A_PANODE(L_SEQ_NO);

         IF L_EXEC_END_DATE IS NOT NULL THEN
            L_RET_CODE := UNAPIPA.REANALSCPARAMETER(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO),
                                         A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO),
                                         A_PANODE(L_SEQ_NO), 
                                         L_REANALYSIS, A_MODIFY_REASON);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;
            END IF;
         END IF;

         
         
         
         OPEN L_SCPAOLD_CURSOR(A_SC(L_SEQ_NO), 
                               A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), 
                               A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO));
         FETCH L_SCPAOLD_CURSOR
         INTO L_SCPAOLD_REC;
         CLOSE L_SCPAOLD_CURSOR;
         L_SCPANEW_REC := L_SCPAOLD_REC;
            
         
         
         
         IF A_FORMAT(L_SEQ_NO) IS NOT NULL THEN
            L_FORMAT := A_FORMAT(L_SEQ_NO);
         END IF;
         L_VALUE_F := A_VALUE_F(L_SEQ_NO);
         L_VALUE_S := A_VALUE_S(L_SEQ_NO);
         L_RET_CODE := UNAPIGEN.FORMATRESULT(L_VALUE_F, L_FORMAT, L_VALUE_S);

         
         
   
         
         
         
         L_EXEC_START_DATE := NVL(L_EXEC_START_DATE, L_CURRENT_TIMESTAMP);
         A_EXEC_END_DATE(L_SEQ_NO) := NVL(A_EXEC_END_DATE(L_SEQ_NO), L_CURRENT_TIMESTAMP);
         A_EXECUTOR(L_SEQ_NO) := NVL(A_EXECUTOR(L_SEQ_NO), UNAPIGEN.P_USER);
         A_REANALYSIS(L_SEQ_NO) := L_REANALYSIS;
   
         UPDATE UTSCPA
         SET VALUE_F = L_VALUE_F,
             VALUE_S = L_VALUE_S,
             UNIT = A_UNIT(L_SEQ_NO),
             FORMAT = L_FORMAT,
             EXEC_START_DATE = L_EXEC_START_DATE,          
             EXEC_START_DATE_TZ =  DECODE(L_EXEC_START_DATE, EXEC_START_DATE_TZ, EXEC_START_DATE_TZ, L_EXEC_START_DATE),          
             EXEC_END_DATE = A_EXEC_END_DATE(L_SEQ_NO),
             EXEC_END_DATE_TZ = A_EXEC_END_DATE(L_SEQ_NO),
        EXECUTOR = A_EXECUTOR(L_SEQ_NO),
             MANUALLY_ENTERED = A_MANUALLY_ENTERED(L_SEQ_NO),
             ALLOW_MODIFY='#'
         WHERE SC = A_SC(L_SEQ_NO)
           AND PG = A_PG(L_SEQ_NO)
           AND PGNODE = A_PGNODE(L_SEQ_NO)
           AND PA = A_PA(L_SEQ_NO)
           AND PANODE = A_PANODE(L_SEQ_NO)
         RETURNING VALUE_F, VALUE_S, UNIT, FORMAT, EXEC_START_DATE, EXEC_START_DATE_TZ, EXEC_END_DATE, EXEC_END_DATE_TZ, EXECUTOR, 
                   MANUALLY_ENTERED, ALLOW_MODIFY
         INTO L_SCPANEW_REC.VALUE_F, L_SCPANEW_REC.VALUE_S, L_SCPANEW_REC.UNIT, 
              L_SCPANEW_REC.FORMAT, L_SCPANEW_REC.EXEC_START_DATE, L_SCPANEW_REC.EXEC_START_DATE_TZ,
         L_SCPANEW_REC.EXEC_END_DATE, L_SCPANEW_REC.EXEC_END_DATE_TZ, 
              L_SCPANEW_REC.EXECUTOR, L_SCPANEW_REC.MANUALLY_ENTERED, L_SCPANEW_REC.ALLOW_MODIFY;

         
         
         
         L_EV_SEQ_NR := -1;
         L_EVENT_TP := 'PaResultUpdated';
         L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                         '#pg=' || A_PG(L_SEQ_NO) ||
                         '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) ||
                         '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                         '#reanalysis=' || TO_CHAR(L_REANALYSIS) ||
                         '#alarms_handled=' ||  NVL(A_ALARMS_HANDLED, UNAPIGEN.ALARMS_NOT_HANDLED) ||
                         '#pr_version=' || L_PR_VERSION;
                         
         L_RESULT := UNAPIEV.INSERTEVENT('SaveScPaResult', UNAPIGEN.P_EVMGR_NAME, 'pa', A_PA(L_SEQ_NO),
                                         L_LC, L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
         END IF;

         
         
         
         IF L_LOG_HS = '1' THEN
            IF ( NVL((L_OLD_VALUE_F <> L_VALUE_F), TRUE) AND NOT(L_OLD_VALUE_F IS NULL AND L_VALUE_F IS NULL) ) OR
               ( NVL((L_OLD_VALUE_S <> L_VALUE_S), TRUE) AND NOT(L_OLD_VALUE_S IS NULL AND L_VALUE_S IS NULL) ) THEN 
               INSERT INTO UTSCPAHS(SC, PG, PGNODE, PA, PANODE, WHO, WHO_DESCRIPTION, WHAT, 
                                    WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
               VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                      A_PANODE(L_SEQ_NO), UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                      'parameter "'||A_PA(L_SEQ_NO)||'" result is updated.', 
                      CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
            END IF;
         END IF;

         
         
         
         IF L_LOG_HS_DETAILS = '1' THEN
            UNAPIHSDETAILS.ADDSCPAHSDETAILS(L_SCPAOLD_REC, L_SCPANEW_REC, UNAPIGEN.P_TR_SEQ, 
                                            L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR);
         END IF;

         
         
         
         
         
         
         
         L_EVENT_TP := 'EvaluateMeDetails';

         
         L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK('1');

         L_VALUE_S_IN := L_VALUE_S ;
         L_VALUE_F_IN := L_VALUE_F ;

         FOR L_SCMECELLINPUT_REC IN
             L_SCMECELLINPUT_CURSOR(A_SC(L_SEQ_NO),
                                    A_PG(L_SEQ_NO),A_PGNODE(L_SEQ_NO),
                                    A_PA(L_SEQ_NO),A_PANODE(L_SEQ_NO)) LOOP

            IF L_SCMECELLINPUT_REC.FIRSTUSE = '0' THEN
               
               
               
               OPEN L_CELL_OLD_CURSOR(A_SC(L_SEQ_NO), 
                                      L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE,
                                      L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE,
                                      L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE,
                                      L_SCMECELLINPUT_REC.CELL);
               FETCH L_CELL_OLD_CURSOR INTO L_OLD_VALUE_F, L_OLD_VALUE_S, L_OLD_UNIT, L_OLD_FORMAT;
               IF L_CELL_OLD_CURSOR%NOTFOUND THEN
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
                  RAISE STPERROR;
               END IF;
               CLOSE L_CELL_OLD_CURSOR;

               
               
               
               L_CELL_UNIT := L_OLD_UNIT;
               L_CELL_FORMAT := L_OLD_FORMAT;
               L_VALUE_S := L_VALUE_S_IN;
               L_VALUE_F := L_VALUE_F_IN ;
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
               L_FORMAT := L_CELL_FORMAT;

               UPDATE UTSCMECELL
               SET VALUE_F = L_VALUE_F,
                   VALUE_S = L_VALUE_S,
                   UNIT = L_CELL_UNIT,
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
               SET INPUT_REANALYSIS = L_REANALYSIS
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
               
               L_EV_SEQ_NR := -1;
               L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) ||
                               '#pg=' || L_SCMECELLINPUT_REC.PG ||
                               '#pgnode=' || TO_CHAR(L_SCMECELLINPUT_REC.PGNODE) ||
                               '#pa=' || L_SCMECELLINPUT_REC.PA ||
                               '#panode=' || TO_CHAR(L_SCMECELLINPUT_REC.PANODE) ||
                               '#menode=' || TO_CHAR(L_SCMECELLINPUT_REC.MENODE) ||
                               '#cell=' || L_SCMECELLINPUT_REC.CELL || 
                               '#mt_version=' || L_SCMECELLINPUT_REC.MT_VERSION;

               L_RESULT := UNAPIEV.INSERTEVENT('SaveScPaResult', UNAPIGEN.P_EVMGR_NAME, 'me',
                                               L_SCMECELLINPUT_REC.ME, L_LC, L_LC_VERSION, L_SS,
                                               L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
               IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNAPIGEN.P_TXN_ERROR := L_RESULT;
                  RAISE STPERROR;
               END IF;
               
               OPEN L_SCME_CURSOR(A_SC(L_SEQ_NO), 
                                  L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE,
                                  L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE,
                                  L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE);
               FETCH L_SCME_CURSOR INTO L_ME_LOG_HS_DETAILS;
               IF L_SCME_CURSOR%NOTFOUND THEN
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
                  RAISE STPERROR;
               END IF;
               CLOSE L_SCME_CURSOR;

               
               
               
               IF L_ME_LOG_HS_DETAILS = '1' THEN
                  IF NVL((L_OLD_VALUE_F <> L_VALUE_F), TRUE) AND 
                     NOT(L_OLD_VALUE_F IS NULL AND L_VALUE_F IS NULL)  THEN 
                     L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
                     INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                                 TR_SEQ, EV_SEQ, SEQ, DETAILS)
                     VALUES(A_SC(L_SEQ_NO), L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE, 
                            L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE, 
                            L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE,
                            UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                            'method cell "'||L_SCMECELLINPUT_REC.CELL||'" is updated: property <value_f> changed value from "' || L_OLD_VALUE_F || '" to "' || L_VALUE_F || '".');
                  END IF;

                  IF NVL((L_OLD_VALUE_S <> L_VALUE_S), TRUE) AND 
                     NOT(L_OLD_VALUE_S IS NULL AND L_VALUE_S IS NULL)  THEN 
                     L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
                     INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                                 TR_SEQ, EV_SEQ, SEQ, DETAILS)
                     VALUES(A_SC(L_SEQ_NO), L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE, 
                            L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE, 
                            L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE,
                            UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                            'method cell "'||L_SCMECELLINPUT_REC.CELL||'" is updated: property <value_s> changed value from "' || L_OLD_VALUE_S || '" to "' || L_VALUE_S || '".');
                  END IF;

                  IF NVL((L_OLD_UNIT <> L_CELL_UNIT), TRUE) AND 
                     NOT(L_OLD_UNIT IS NULL AND L_CELL_UNIT IS NULL)  THEN 
                     L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
                     INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                                 TR_SEQ, EV_SEQ, SEQ, DETAILS)
                     VALUES(A_SC(L_SEQ_NO), L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE, 
                            L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE, 
                            L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE,
                            UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                            'method cell "'||L_SCMECELLINPUT_REC.CELL||'" is updated: property <unit> changed value from "' || L_OLD_UNIT || '" to "' || L_CELL_UNIT || '".');
                  END IF;

                  IF NVL((L_OLD_FORMAT <> L_FORMAT), TRUE) AND 
                     NOT(L_OLD_FORMAT IS NULL AND L_FORMAT IS NULL)  THEN 
                     L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
                     INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                                 TR_SEQ, EV_SEQ, SEQ, DETAILS)
                     VALUES(A_SC(L_SEQ_NO), L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE, 
                            L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE, 
                            L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE,
                            UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                            'method cell "'||L_SCMECELLINPUT_REC.CELL||'" is updated: property <format> changed value from "' || L_OLD_FORMAT || '" to "' || L_FORMAT || '".');
                  END IF;
               END IF;

            ELSE
               
               L_RET_CODE := UNAPIME2.EVALUATEMECELLINPUT(A_SC(L_SEQ_NO), 
                                L_SCMECELLINPUT_REC.PG, L_SCMECELLINPUT_REC.PGNODE,
                                L_SCMECELLINPUT_REC.PA, L_SCMECELLINPUT_REC.PANODE,
                                L_SCMECELLINPUT_REC.ME, L_SCMECELLINPUT_REC.MENODE,                                                          
                                L_SCMECELLINPUT_REC.REANALYSIS, L_SCMECELLINPUT_REC.CELL,
                                L_SCMECELLINPUT_REC.FORMAT, L_SCMECELLINPUT_REC.INPUT_TP, 
                                L_SCMECELLINPUT_REC.INPUT_SOURCE, 
                                L_SCMECELLINPUT_REC.INPUT_VERSION,
                                L_SCMECELLINPUT_REC.INPUT_PG, L_SCMECELLINPUT_REC.INPUT_PGNODE,
                                L_SCMECELLINPUT_REC.INPUT_PP_VERSION, 
                                L_SCMECELLINPUT_REC.INPUT_PA, L_SCMECELLINPUT_REC.INPUT_PANODE,
                                L_SCMECELLINPUT_REC.INPUT_PR_VERSION, 
                                L_SCMECELLINPUT_REC.INPUT_ME, L_SCMECELLINPUT_REC.INPUT_MENODE,
                                L_SCMECELLINPUT_REC.INPUT_MT_VERSION, 
                                L_REANALYSIS);
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

         
         
         
         
         FOR L_ASSIGNED_ME IN C_ASSIGNED_ME(A_SC(L_SEQ_NO), 
                              A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                              A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO)) LOOP
            OPEN C_FIRST_EMPTY_CELL(A_SC(L_SEQ_NO), 
                              A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                              A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                              L_ASSIGNED_ME.ME, L_ASSIGNED_ME.MENODE);
            FETCH C_FIRST_EMPTY_CELL INTO L_NEXT_CELL;
            IF C_FIRST_EMPTY_CELL%NOTFOUND THEN
               L_NEXT_CELL := NULL;
            END IF;
            CLOSE C_FIRST_EMPTY_CELL;

            UPDATE UTSCME
            SET NEXT_CELL = L_NEXT_CELL
            WHERE SC = A_SC(L_SEQ_NO) 
              AND PG = A_PG(L_SEQ_NO) AND PGNODE = A_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO) AND PANODE = A_PANODE(L_SEQ_NO)
              AND ME = L_ASSIGNED_ME.ME AND MENODE = L_ASSIGNED_ME.MENODE;
         END LOOP;

         
         
         
        OPEN L_SCPG_CURSOR(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO));
        FETCH L_SCPG_CURSOR INTO L_SCPG_PP_VERSION, L_SCPG_PP_KEY1, L_SCPG_PP_KEY2, 
                                L_SCPG_PP_KEY3, L_SCPG_PP_KEY4, L_SCPG_PP_KEY5;
        CLOSE L_SCPG_CURSOR;
                 
         OPEN L_ST_CURSOR(A_SC(L_SEQ_NO));
         FETCH L_ST_CURSOR INTO L_ST, L_ST_VERSION;
         CLOSE L_ST_CURSOR;
         L_DATAPOINT_LINK  := A_SC(L_SEQ_NO) || '#'|| A_PG(L_SEQ_NO) || '#' || A_PGNODE(L_SEQ_NO) || '#' || A_PA(L_SEQ_NO) || '#' || A_PANODE(L_SEQ_NO) || '#' || L_REANALYSIS;  
         FOR LC_CY IN C_CY (A_PA(L_SEQ_NO), L_PR_VERSION, L_ST , L_ST_VERSION ) LOOP
            
            L_CH_CONTEXT_KEY  := L_ST ||'#'|| A_PG(L_SEQ_NO) ||'#'|| L_SCPG_PP_KEY1 ||'#'|| L_SCPG_PP_KEY2 ||'#'|| L_SCPG_PP_KEY3 ||'#'|| L_SCPG_PP_KEY4 ||'#'|| L_SCPG_PP_KEY5 ||'#'|| A_PA(L_SEQ_NO);  
            L_CHART_OK := TRUE; 
            SAVEPOINT_UNILAB4; 
                               
                               
            
            L_RET_CODE := UNSQCASSIGN.SQCASSIGN(LC_CY.CY, L_CH_CONTEXT_KEY, L_DATAPOINT_LINK,
                                  L_CH, L_DATAPOINT_SEQ, L_MEASURE_SEQ);
            IF (L_RET_CODE = UNAPIGEN.DBERR_SUCCESS) AND (NVL(L_CH, ' ') <> ' ') THEN
               
               L_WHERE_CLAUSE := 'where sc='''||A_SC(L_SEQ_NO)||''' and pg ='''||A_PG(L_SEQ_NO)||''' and pgnode=' || A_PGNODE(L_SEQ_NO) || ' and pa='''||A_PA(L_SEQ_NO)||''' and panode=' || A_PANODE(L_SEQ_NO) ;
               L_NEXT_ROWS := 0;
               L_NR_OF_ROWS_OUT := 100;
               L_RET_CODE := UNAPIPAP.GETSCPACOMMENT
                   (L_SC_TAB,
                    L_PG_TAB,
                    L_PGNODE_TAB,
                    L_PA_TAB,
                    L_PANODE_TAB,
                    L_LAST_COMMENT_TAB,
                    L_NR_OF_ROWS_OUT,
                    L_WHERE_CLAUSE,
                    L_NEXT_ROWS);
               IF L_RET_CODE = UNAPIGEN.DBERR_GENFAIL THEN
                  L_CHART_OK := FALSE; 
                  IF A_MODIFY_FLAG(L_SEQ_NO) <= UNAPIGEN.DBERR_SUCCESS THEN  
                     A_MODIFY_FLAG(L_SEQ_NO) := UNAPIGEN.DBERR_GENFAIL;
                  END IF;                  
               END IF;
               IF L_RET_CODE =UNAPIGEN.DBERR_SUCCESS THEN
                  IF L_NR_OF_ROWS_OUT > 0 THEN
                     L_LAST_COMMENT := L_LAST_COMMENT_TAB(1);
                  END IF;
               END IF;

               
               OPEN L_CH_EXISTS_CURSOR(L_CH);
               FETCH L_CH_EXISTS_CURSOR INTO L_CH;
               IF L_CH_EXISTS_CURSOR%NOTFOUND THEN
                  L_NEW_CHART:= TRUE;
               ELSE
                  L_NEW_CHART := FALSE;
               END IF;
               CLOSE L_CH_EXISTS_CURSOR;
               IF L_NEW_CHART = TRUE  AND  L_CHART_OK = TRUE THEN
                  L_RET_CODE := UNAPICH.CREATECHART(LC_CY.CY , LC_CY.CY_VERSION, L_CH,
                                      L_CH_CONTEXT_KEY, CURRENT_TIMESTAMP, UNAPIGEN.P_USER, '');
                  IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                     IF A_MODIFY_FLAG(L_SEQ_NO) <= UNAPIGEN.DBERR_SUCCESS THEN  
                        A_MODIFY_FLAG(L_SEQ_NO) := L_RET_CODE;
                     END IF;                  
                     L_CHART_OK := FALSE;                   
                  ELSE         
                     OPEN C_CH_TITLES(L_CH);
                     FETCH C_CH_TITLES INTO L_CH_TITLE, L_CH_X_AXIS_TITLE, L_CH_Y_AXIS_TITLE;
                     IF C_CH_TITLES%NOTFOUND THEN
                        IF A_MODIFY_FLAG(L_SEQ_NO) <= UNAPIGEN.DBERR_SUCCESS THEN  
                           A_MODIFY_FLAG(L_SEQ_NO) := UNAPIGEN.DBERR_NORECORDS;
                        END IF;                  
                        L_CHART_OK := FALSE;
                     END IF;
                     CLOSE C_CH_TITLES;   

                     IF L_CHART_OK = TRUE THEN
                        
                        L_PA_OBJECT_KEY := A_SC(L_SEQ_NO)||'#'||
                                           A_PG(L_SEQ_NO)||'#'||A_PGNODE(L_SEQ_NO)||'#'||
                                           A_PA(L_SEQ_NO)||'#'||A_PANODE(L_SEQ_NO);
                        L_CH_OBJECT_KEY := L_CH;
                        L_RET_CODE := SUBSTITUTETILDES(L_CH_TITLE, L_PA_OBJECT_KEY, L_CH_OBJECT_KEY);
                        L_RET_CODE := SUBSTITUTETILDES(L_CH_X_AXIS_TITLE, L_PA_OBJECT_KEY, L_CH_OBJECT_KEY);
                        L_RET_CODE := SUBSTITUTETILDES(L_CH_Y_AXIS_TITLE, L_PA_OBJECT_KEY, L_CH_OBJECT_KEY);

                        UPDATE UTCH
                        SET CHART_TITLE  = L_CH_TITLE,
                            X_AXIS_TITLE = L_CH_X_AXIS_TITLE,
                            Y_AXIS_TITLE = L_CH_Y_AXIS_TITLE
                        WHERE CH = L_CH;
                     END IF;                                         
                  END IF;
               END IF;
               
               IF L_CHART_OK = TRUE THEN
                  OPEN C_X_LABEL (LC_CY.CY, LC_CY.CY_VERSION);
                  FETCH C_X_LABEL INTO L_X_LABEL;
                  CLOSE C_X_LABEL;
                 
                  OPEN C_Y_AXIS_UNIT (L_CH);
                  FETCH C_Y_AXIS_UNIT INTO L_Y_AXIS_UNIT;
                  CLOSE C_Y_AXIS_UNIT;
                  
                  IF INSTR(L_X_LABEL , '@') > 0 THEN 
                     IF (INSTR(L_X_LABEL , '~') > 0) AND  (INSTR(L_X_LABEL , '~', 1, 2) > 0) THEN
                        
                        L_PA_OBJECT_KEY := A_SC(L_SEQ_NO)||'#'||
                                           A_PG(L_SEQ_NO)||'#'||A_PGNODE(L_SEQ_NO)||'#'||
                                           A_PA(L_SEQ_NO)||'#'||A_PANODE(L_SEQ_NO);
                        L_CH_OBJECT_KEY := L_CH;

                        
                        L_X_VALUE_S := L_X_LABEL ;
                        L_RET_CODE := SUBSTITUTETILDES(L_X_VALUE_S, L_PA_OBJECT_KEY, L_CH_OBJECT_KEY);                        

                        L_X_VALUE_S_TAB(1) := SUBSTR(L_X_VALUE_S,1,40); 
                        L_X_VALUE_F_TAB(1) := NULL;
                        L_X_VALUE_D_TAB(1) := NULL;
                     ELSE
                         L_RET_CODE := UNAPIGEN.TILDESUBSTITUTION(
                                 'pa' , 
                                 A_SC(L_SEQ_NO) || '#'|| A_PG(L_SEQ_NO) || '#' || A_PGNODE(L_SEQ_NO) || '#' || A_PA(L_SEQ_NO) || '#' || A_PANODE(L_SEQ_NO),
                                 L_X_LABEL,
                                 L_X_VALUE_S, L_X_VALUE_F_TAB(1), L_X_VALUE_D_TAB(1)); 
                          L_X_VALUE_S_TAB(1) := SUBSTR(L_X_VALUE_S,1,40);
                     END IF;
                  ELSE
                     L_X_VALUE_S_TAB(1) := SUBSTR(L_X_LABEL,1,40);
                     L_X_VALUE_F_TAB(1) := NULL;
                     L_X_VALUE_D_TAB(1) := NULL;
                  END IF;
                  
                  IF (L_X_VALUE_D_TAB(1) IS NULL) THEN
                     L_X_VALUE_D_TAB(1) := A_EXEC_END_DATE(L_SEQ_NO);
                  END IF;
                  
                 L_RET_CODE := UNAPIGEN.TRANSFORMRESULT(L_VALUE_S,
                                                         L_VALUE_F,      
                                                         A_UNIT(L_SEQ_NO),
                                                         L_FORMAT,    
                                                         L_DATAPOINT_VALUE_S_TAB(1),    
                                                         L_DATAPOINT_VALUE_F_TAB(1),      
                                                         L_Y_AXIS_UNIT,    
                                                         L_Y_AXIS_FORMAT);
                  IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                     UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                     RAISE STPERROR;
                  END IF;

                  
                  L_CH_TAB(1) := L_CH;
                  L_DATAPOINT_SEQ_TAB(1) := L_DATAPOINT_SEQ;
                  L_MEASURE_SEQ_TAB(1) := L_MEASURE_SEQ;
                  L_DATAPOINT_LABEL_TAB(1) := L_LAST_COMMENT;
                  L_DATAPOINT_MARKER_TAB(1) := '';
                  L_DATAPOINT_COLOUR_TAB(1) := '';
                  L_DATAPOINT_LINK_TAB(1) := L_DATAPOINT_LINK;
                  L_Z_VALUE_F_TAB(1) := NULL;
                  L_Z_VALUE_S_TAB(1) := '';
                  L_DATAPOINT_RANGE_TAB(1) := NULL;
                  L_SQC_AVG_TAB(1) := NULL;
                  L_SQC_AVG_RANGE_TAB(1) := NULL;
                  L_SQC_SIGMA_TAB(1) := NULL;
                  L_SQC_SIGMA_RANGE_TAB(1) := NULL;
                  L_SPEC1_TAB(1) := NULL;
                  L_SPEC2_TAB(1) := NULL;
                  L_SPEC3_TAB(1) := NULL;
                  L_SPEC4_TAB(1) := NULL;
                  L_SPEC5_TAB(1) := NULL;
                  L_SPEC6_TAB(1) := NULL;
                  L_SPEC7_TAB(1) := NULL;
                  L_SPEC8_TAB(1) := NULL;
                  L_SPEC9_TAB(1) := NULL;
                  L_SPEC10_TAB(1) := NULL;
                  L_SPEC11_TAB(1) := NULL;
                  L_SPEC12_TAB(1) := NULL;
                  L_SPEC13_TAB(1) := NULL;
                  L_SPEC14_TAB(1) := NULL;
                  L_SPEC15_TAB(1) := NULL;
                  L_ACTIVE_TAB(1) := '1';  
                  L_RULE1_VIOLATED_TAB(1) := NULL;
                  L_RULE2_VIOLATED_TAB(1) := NULL;
                  L_RULE3_VIOLATED_TAB(1) := NULL;
                  L_RULE4_VIOLATED_TAB(1) := NULL;
                  L_RULE5_VIOLATED_TAB(1) := NULL;
                  L_RULE6_VIOLATED_TAB(1) := NULL;
                  L_RULE7_VIOLATED_TAB(1) := NULL;
                  L_NR_OF_ROWS := 1; 
              
                  L_RET_CODE := UNAPICH.SAVECHDATAPOINT
                   (L_CH_TAB, L_DATAPOINT_SEQ_TAB, L_MEASURE_SEQ_TAB, L_X_VALUE_F_TAB, L_X_VALUE_S_TAB,
                    L_X_VALUE_D_TAB, L_DATAPOINT_VALUE_F_TAB, L_DATAPOINT_VALUE_S_TAB, L_DATAPOINT_LABEL_TAB,
                    L_DATAPOINT_MARKER_TAB, L_DATAPOINT_COLOUR_TAB, L_DATAPOINT_LINK_TAB, L_Z_VALUE_F_TAB,
                    L_Z_VALUE_S_TAB, L_DATAPOINT_RANGE_TAB, L_SQC_AVG_TAB, L_SQC_AVG_RANGE_TAB,
                    L_SQC_SIGMA_TAB, L_SQC_SIGMA_RANGE_TAB, L_SPEC1_TAB, L_SPEC2_TAB, L_SPEC3_TAB,
                    L_SPEC4_TAB, L_SPEC5_TAB, L_SPEC6_TAB, L_SPEC7_TAB, L_SPEC8_TAB, L_SPEC9_TAB, 
                    L_SPEC10_TAB, L_SPEC11_TAB, L_SPEC12_TAB, L_SPEC13_TAB, L_SPEC14_TAB, L_SPEC15_TAB, 
                    L_ACTIVE_TAB, 
                    L_RULE1_VIOLATED_TAB, L_RULE2_VIOLATED_TAB, L_RULE3_VIOLATED_TAB, L_RULE4_VIOLATED_TAB, 
                    L_RULE5_VIOLATED_TAB, L_RULE6_VIOLATED_TAB, L_RULE7_VIOLATED_TAB,
                    L_NR_OF_ROWS, '');
                  IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                     IF A_MODIFY_FLAG(L_SEQ_NO) <= UNAPIGEN.DBERR_SUCCESS THEN  
                        A_MODIFY_FLAG(L_SEQ_NO) := L_RET_CODE;
                     END IF;
                     L_CHART_OK := FALSE; 
                  END IF;
                 IF L_CHART_OK = TRUE THEN
                     
                     L_RET_CODE := UNSQCCALC.SQCCALC(L_CH, L_DATAPOINT_SEQ, L_MEASURE_SEQ);
                     IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                        L_CHART_OK := FALSE; 
                        IF A_MODIFY_FLAG(L_SEQ_NO) <= UNAPIGEN.DBERR_SUCCESS THEN  
                           A_MODIFY_FLAG(L_SEQ_NO) := L_RET_CODE;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
            IF L_CHART_OK = FALSE THEN
               L_COMPLETELY_CHARTED := FALSE;
            END IF;
         END LOOP;

         
         
         
         L_RECURSIVE_LEVEL := ' ';
         
         
         IF UNAPIGEN.P_PP_KEY4PRODUCT IS NULL THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SETCONNECTION;    
            RAISE STPERROR;               
         END IF;
         
         
         
         
         
         
         IF P_SCPARESULT_RECURSIVE = '0' THEN
            DELETE FROM UTSCPAOUTPUT
            WHERE SC = A_SC(L_SEQ_NO)
              AND SAVE_PG = A_PG(L_SEQ_NO)
              AND SAVE_PGNODE = A_PGNODE(L_SEQ_NO)
              AND SAVE_PA = A_PA(L_SEQ_NO)
              AND SAVE_PANODE = A_PANODE(L_SEQ_NO)
              AND (PG <> A_PG(L_SEQ_NO) OR
                   PGNODE <> A_PGNODE(L_SEQ_NO) OR 
                   PA <> A_PA(L_SEQ_NO) OR
                   PANODE <> A_PANODE(L_SEQ_NO));
         END IF;         
         
         
         IF UNAPIGEN.P_PP_KEY_NR_OF_ROWS <> 0 THEN
            
            IF P_SCPARESULT_RECURSIVE = '0' THEN
               
               
               OPEN L_SCPG_CURSOR(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO));
               FETCH L_SCPG_CURSOR INTO L_SCPG_PP_VERSION, L_SCPG_PP_KEY1, L_SCPG_PP_KEY2, 
                                        L_SCPG_PP_KEY3, L_SCPG_PP_KEY4, L_SCPG_PP_KEY5;
               CLOSE L_SCPG_CURSOR;
               
               L_RET_CODE := UNAPIPG.GETSUPPLIERANDCUSTOMER(L_SCPG_PP_KEY1, L_SCPG_PP_KEY2, 
                                L_SCPG_PP_KEY3, L_SCPG_PP_KEY4, L_SCPG_PP_KEY5, 
                                L_SCPG_SUPPLIER, L_SCPG_CUSTOMER);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                  RAISE STPERROR;
               END IF;
               
               
               IF (L_SCPG_SUPPLIER <> ' ') OR (L_SCPG_CUSTOMER <> ' ') THEN
                  
                  BEGIN
                     INSERT INTO UTSCPAOUTPUT(SC, PG, PGNODE, PA, PANODE, 
                                              SAVE_PG, SAVE_PGNODE, SAVE_PA, SAVE_PANODE)
                     VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO), 
                            A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO));
                  EXCEPTION
                  WHEN DUP_VAL_ON_INDEX THEN
                     
                     
                     
                     NULL;
                  END;
               END IF;

               
               
               
               
               
               
               
               
               
               
               FOR L_SCPA_REC IN L_SCPA_CURSOR(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), 
                                               A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO), L_PR_VERSION,
                                               L_SCPG_PP_VERSION, L_SCPG_PP_KEY1, L_SCPG_PP_KEY2, 
                                               L_SCPG_PP_KEY3, L_SCPG_PP_KEY4, L_SCPG_PP_KEY5) LOOP
                  
                  L_RET_CODE := UNAPIPG.GETSUPPLIERANDCUSTOMER(L_SCPA_REC.PP_KEY1, L_SCPA_REC.PP_KEY2, 
                                   L_SCPA_REC.PP_KEY3, L_SCPA_REC.PP_KEY4, L_SCPA_REC.PP_KEY5, 
                                   L_SCPG_SUPPLIER, L_SCPG_CUSTOMER);
                  IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                     UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                     RAISE STPERROR;
                  END IF;
                  
                  
                  IF (L_SCPG_SUPPLIER <> ' ') OR (L_SCPG_CUSTOMER <> ' ') THEN
                     BEGIN
                        INSERT INTO UTSCPAOUTPUT(SC, PG, PGNODE, PA, PANODE, 
                                                 SAVE_PG, SAVE_PGNODE, SAVE_PA, SAVE_PANODE)
                        VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO), 
                               L_SCPA_REC.PG, L_SCPA_REC.PGNODE, L_SCPA_REC.PA, L_SCPA_REC.PANODE);
                     EXCEPTION
                     WHEN DUP_VAL_ON_INDEX THEN
                        
                        
                        
                        NULL;
                     END;
                  END IF;
               END LOOP;
               
               
              L_RECURSIVE_LEVEL := '0';
            END IF;
         END IF;
         
         
         
         IF L_RECURSIVE_LEVEL = '0' THEN
            P_SCPARESULT_RECURSIVE := '1';
         END IF;
         FOR L_SCPAOUTPUT_REC IN L_SCPAOUTPUT_CURSOR(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), 
                                                     A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO)) LOOP
            
            
            
            IF (    A_SC(L_SEQ_NO)     = L_SCPAOUTPUT_REC.SC
                AND A_PG(L_SEQ_NO)     = L_SCPAOUTPUT_REC.SAVE_PG
                AND A_PGNODE(L_SEQ_NO) = L_SCPAOUTPUT_REC.SAVE_PGNODE
                AND A_PA(L_SEQ_NO)     = L_SCPAOUTPUT_REC.SAVE_PA
                AND A_PANODE(L_SEQ_NO) = L_SCPAOUTPUT_REC.SAVE_PANODE) THEN
               NULL;
            ELSE
            
               
               L_RET_CODE := UNAPIGEN.TRANSFORMRESULT(A_VALUE_S(L_SEQ_NO), 
                                                      A_VALUE_F(L_SEQ_NO),      
                                                      A_UNIT(L_SEQ_NO),
                                                      A_FORMAT(L_SEQ_NO),    
                                                      L_SCPAOUTPUT_REC.VALUE_S,    
                                                      L_SCPAOUTPUT_REC.VALUE_F,      
                                                      L_SCPAOUTPUT_REC.UNIT,    
                                                      L_SCPAOUTPUT_REC.FORMAT);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                  RAISE STPERROR;
               END IF;
            
               L_SCPAOUTPUT_SC_TAB(1)            := L_SCPAOUTPUT_REC.SC;
               L_SCPAOUTPUT_PG_TAB(1)            := L_SCPAOUTPUT_REC.SAVE_PG;
               L_SCPAOUTPUT_PGNODE_TAB(1)        := L_SCPAOUTPUT_REC.SAVE_PGNODE;
               L_SCPAOUTPUT_PA_TAB(1)            := L_SCPAOUTPUT_REC.SAVE_PA;
               L_SCPAOUTPUT_PANODE_TAB(1)        := L_SCPAOUTPUT_REC.SAVE_PANODE;
               L_SCPAOUTPUT_VALUE_S_TAB(1)       := L_SCPAOUTPUT_REC.VALUE_S;
               L_SCPAOUTPUT_VALUE_F_TAB(1)       := L_SCPAOUTPUT_REC.VALUE_F;
               L_SCPAOUTPUT_UNIT_TAB(1)          := L_SCPAOUTPUT_REC.UNIT;
               L_SCPAOUTPUT_FORMAT_TAB(1)        := L_SCPAOUTPUT_REC.FORMAT;               
               L_SCPAOUTPUT_EXEC_END_DATE_TAB(1) := A_EXEC_END_DATE(L_SEQ_NO);
               L_SCPAOUTPUT_EXECUTOR_TAB(1)      := A_EXECUTOR(L_SEQ_NO);
               L_SCPAOUTPUT_REANALYSIS_TAB(1)    := NULL;
               L_SCPAOUTPUT_MODIFY_FLAG_TAB(1)   := UNAPIGEN.MOD_FLAG_UPDATE;
               L_RESULT := UNAPIPA.SAVESCPARESULT(
                              A_ALARMS_HANDLED, 
                              L_SCPAOUTPUT_SC_TAB, 
                              L_SCPAOUTPUT_PG_TAB, 
                              L_SCPAOUTPUT_PGNODE_TAB, 
                              L_SCPAOUTPUT_PA_TAB, 
                              L_SCPAOUTPUT_PANODE_TAB, 
                              L_SCPAOUTPUT_VALUE_F_TAB, 
                              L_SCPAOUTPUT_VALUE_S_TAB, 
                              L_SCPAOUTPUT_UNIT_TAB, 
                              L_SCPAOUTPUT_FORMAT_TAB, 
                              L_SCPAOUTPUT_EXEC_END_DATE_TAB, 
                              L_SCPAOUTPUT_EXECUTOR_TAB, 
                              A_MANUALLY_ENTERED, 
                              L_SCPAOUTPUT_REANALYSIS_TAB, 
                              L_SCPAOUTPUT_MODIFY_FLAG_TAB,
                              1, 
                              A_MODIFY_REASON);
               IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNAPIGEN.P_TXN_ERROR := L_RESULT;
                  RAISE STPERROR;
               END IF;
            END IF;
         END LOOP;
         
         IF L_RECURSIVE_LEVEL = '0' THEN
            P_SCPARESULT_RECURSIVE := '0';
         END IF;

         
         
         
         
         
      ELSE
         IF L_PA_HANDLED THEN
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

   
   L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK(L_ORIG_AR_CHECK_MODE);

   IF L_COMPLETELY_SAVED THEN
      IF L_COMPLETELY_CHARTED = TRUE THEN
         RETURN(UNAPIGEN.DBERR_SUCCESS);
      ELSE
         RETURN(UNAPIGEN.DBERR_PARTIALCHARTSAVE);
      END IF;
   ELSE
      RETURN(UNAPIGEN.DBERR_PARTIALSAVE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveScPaResult',SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('SaveScPaResult',L_SQLERRM);   
   END IF;
   IF C_FIRST_EMPTY_CELL%ISOPEN THEN
      CLOSE C_FIRST_EMPTY_CELL;
   END IF;
   IF L_SCPAOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCPAOLD_CURSOR;
   END IF;
   IF L_CELL_OLD_CURSOR%ISOPEN THEN
      CLOSE L_CELL_OLD_CURSOR;
   END IF;
   IF L_SCME_CURSOR%ISOPEN THEN
      CLOSE L_SCME_CURSOR;
   END IF;
   IF L_SCPA_CURSOR%ISOPEN THEN
      CLOSE L_SCPA_CURSOR;
   END IF;
   IF L_SCPAOUTPUT_CURSOR%ISOPEN THEN
      CLOSE L_SCPAOUTPUT_CURSOR;
   END IF;
   IF L_SCPG_CURSOR%ISOPEN THEN
      CLOSE L_SCPG_CURSOR;
   END IF;
   
   L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK(L_ORIG_AR_CHECK_MODE);
   
   P_SCPARESULT_RECURSIVE := '0';
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveScPaResult'));
END SAVESCPARESULT;

FUNCTION REANALSCPARAMETER                          
(A_SC               IN    VARCHAR2,                 
 A_PG               IN    VARCHAR2,                 
 A_PGNODE           IN    NUMBER,                   
 A_PA               IN    VARCHAR2,                 
 A_PANODE           IN    NUMBER,                   
 A_REANALYSIS       OUT   NUMBER,                   
 A_MODIFY_REASON    IN    VARCHAR2)                 
RETURN NUMBER IS

L_LC                          VARCHAR2(2);
L_LC_VERSION                  VARCHAR2(20);
L_OLD_VALUE_S                 VARCHAR2(20);
L_NEW_VALUE_S                 VARCHAR2(20);
L_OLD_SS                      VARCHAR2(2);
L_NEW_SS                      VARCHAR2(2);
L_TR_NO                       NUMBER(3);
L_LOG_HS                      CHAR(1);
L_LOG_HS_DETAILS              CHAR(1);
L_ALLOW_MODIFY                CHAR(1);
L_ACTIVE                      CHAR(1);
L_OLD_REANALYSIS              NUMBER(3);
L_NEW_REANALYSIS              NUMBER(3);
L_ME_REANALYSIS               NUMBER(3);
L_PA_EXEC_END_DATE            TIMESTAMP WITH TIME ZONE;
L_LC_SS_FROM                  VARCHAR2(2);
L_PREVIOUS_ALLOW_MODIFY_CHECK CHAR(1);
L_OBJECT_ID                   VARCHAR2(255);
L_HS_DETAILS_SEQ_NR           INTEGER;
L_OLD_VALID_SQC               CHAR(1);
L_PR_VERSION                  VARCHAR2(20);
L_PAOUTPUT_REANALYSIS         NUMBER(3);
L_IS_VALUE_S_UPDATED          BOOLEAN:=FALSE;
L_COUNT_EVENTS                INTEGER;
L_EV_DETAILS_LIKE             VARCHAR2(255);

CURSOR L_SCPA_CURSOR IS
   SELECT PR_VERSION, REANALYSIS, EXEC_END_DATE, LC, LC_VERSION
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

CURSOR L_SCME_CURSOR IS
   SELECT ME, MENODE, REANALYSIS
   FROM UTSCME
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE;

CURSOR L_LC_CURSOR(A_LC VARCHAR2, A_LC_VERSION VARCHAR2) IS
   SELECT NVL(SS_AFTER_REANALYSIS,'IE') SS_AFTER_REANALYSIS
   FROM UTLC
   WHERE LC = A_LC
     AND VERSION = A_LC_VERSION;

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

CURSOR L_CHDP_CURSOR( C_REANALYSIS VARCHAR2) IS
   SELECT /*+ RULE */ B.CH, B.ACTIVE
   FROM UTCH A, UTCHDP B
   WHERE B.DATAPOINT_LINK LIKE A_SC || '#' || 
                               A_PG || '#' || A_PGNODE || '#' || 
                               A_PA || '#' || A_PANODE || '#' ||C_REANALYSIS
     AND B.CH = A.CH
     AND A.ALLOW_MODIFY IN ('1', '#')
     AND NVL(UNAPIAUT.SQLGETCHALLOWMODIFY(B.CH),'0')='1' 
     AND A.LOG_HS_DETAILS='1'
   ORDER BY B.CH; 

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

   
   OPEN L_SCPA_CURSOR;
   FETCH L_SCPA_CURSOR
   INTO L_PR_VERSION, L_OLD_REANALYSIS, L_PA_EXEC_END_DATE, L_LC, L_LC_VERSION;
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

   L_RET_CODE := UNAPIPAP.SCPATRANSITIONAUTHORISED
                    (A_SC, A_PG, A_PGNODE, A_PA, A_PANODE,
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

      
      L_EVENT_TP := 'PaReanalysis';
      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'sc=' || A_SC ||
                      '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) ||
                      '#panode=' || TO_CHAR(A_PANODE) ||
                      '#old_reanalysis=' || TO_CHAR(L_OLD_REANALYSIS) ||
                      '#new_reanalysis=' || TO_CHAR(L_NEW_REANALYSIS) ||
                      '#tr_no=' || L_TR_NO ||
                      '#ss_from=' || L_OLD_SS ||
                      '#lc_ss_from='|| L_LC_SS_FROM ||
                      '#pr_version=' || L_PR_VERSION;
      L_RESULT := UNAPIEV.INSERTEVENT('ReanalScParameter', UNAPIGEN.P_EVMGR_NAME, 'pa', A_PA, L_LC,
                                      L_LC_VERSION, L_NEW_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
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

      
      
      
      FOR L_SCME IN L_SCME_CURSOR LOOP
         
         
         
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
         
         
         SELECT REANALYSIS
         INTO L_ME_REANALYSIS
         FROM UTSCME
         WHERE SC = A_SC
         AND PG = A_PG
         AND PGNODE = A_PGNODE
         AND PA = A_PA
         AND PANODE = A_PANODE
         AND ME = L_SCME.ME
         AND MENODE = L_SCME.MENODE;
         
         L_RESULT := UNAPIMEP.REANALSCMETHOD(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, L_SCME.ME,
                                             L_SCME.MENODE, L_ME_REANALYSIS, A_MODIFY_REASON);
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS AND
            L_RESULT <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
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
      
      
      
      
   
      
      
      
      
      
      
      
      UPDATE UTSCPA
         SET ALLOW_MODIFY='#',
             SS = L_NEW_SS,
             VALUE_F = NULL,
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
                VALID_LIMITSC, VALID_TARGETA, VALID_TARGETB, VALID_TARGETC, REANALYSIS, 
                PA_CLASS, ALLOW_MODIFY, SS
      INTO L_SCPANEW_REC.VALUE_F, L_SCPANEW_REC.VALUE_S, L_SCPANEW_REC.EXEC_START_DATE, L_SCPANEW_REC.EXEC_START_DATE_TZ,
           L_SCPANEW_REC.EXEC_END_DATE, L_SCPANEW_REC.EXEC_END_DATE_TZ, L_SCPANEW_REC.EXECUTOR, L_SCPANEW_REC.MANUALLY_ENTERED,
           L_SCPANEW_REC.VALID_SPECSA, L_SCPANEW_REC.VALID_SPECSB, L_SCPANEW_REC.VALID_SPECSC, 
           L_SCPANEW_REC.VALID_LIMITSA, L_SCPANEW_REC.VALID_LIMITSB, L_SCPANEW_REC.VALID_LIMITSC, 
           L_SCPANEW_REC.VALID_TARGETA, L_SCPANEW_REC.VALID_TARGETB, L_SCPANEW_REC.VALID_TARGETC, 
           L_SCPANEW_REC.REANALYSIS, L_SCPANEW_REC.PA_CLASS, L_SCPANEW_REC.ALLOW_MODIFY, 
           L_SCPANEW_REC.SS;
      A_REANALYSIS := L_NEW_REANALYSIS;

      
      
      
      L_RESULT := UNAPIMEP2.CLEARWHEREUSEDINMEDETAILS('pa', A_SC, A_PG, A_PGNODE, A_PA, A_PANODE,
                                                      NULL, NULL, L_OLD_REANALYSIS, L_NEW_REANALYSIS, A_MODIFY_REASON);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;                                         

      
      
      
      
      
   
      IF L_LOG_HS = '1' THEN
         INSERT INTO UTSCPAHS(SC, PG, PGNODE, PA, PANODE, WHO, WHO_DESCRIPTION, WHAT, 
                              WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, UNAPIGEN.P_USER, 
                UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP,
                'parameter "'||A_PA||'" reanalysed, status is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'||UNAPIGEN.SQLSSNAME(L_NEW_SS)||'" ['||L_NEW_SS||'].', 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
      
      L_HS_DETAILS_SEQ_NR := 0;
      IF L_LOG_HS_DETAILS = '1' THEN
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTSCPAHSDETAILS(SC, PG, PGNODE, PA, PANODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'parameter "'||A_PA||'" reanalysed, status is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'||UNAPIGEN.SQLSSNAME(L_NEW_SS)||'" ['||L_NEW_SS||'].');

         UNAPIHSDETAILS.ADDSCPAHSDETAILS(L_SCPAOLD_REC, L_SCPANEW_REC, UNAPIGEN.P_TR_SEQ, 
                                         L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR); 

         IF L_OLD_VALID_SQC IS NOT NULL THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCPAHSDETAILS(SC, PG, PGNODE, PA, PANODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                   'parameter "'||A_PA||'" is updated: property <valid_sqc> changed value from "' || L_OLD_VALID_SQC|| '" to "".');
         END IF;
      END IF;

     
     
     
     

      
      
    FOR L_CHDP_REC IN L_CHDP_CURSOR(L_OLD_REANALYSIS) LOOP
      
      
      IF L_CHDP_REC.ACTIVE <> '0' THEN
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTCHHSDETAILS(CH, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(L_CHDP_REC.CH, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                'chart "'||L_CHDP_REC.CH||'" is updated: property <active> changed value from "'||L_CHDP_REC.ACTIVE||'" to "0".');
      END IF;
    END LOOP;

    UPDATE /*+ RULE */ UTCHDP
    SET ACTIVE = '0' 
    WHERE (CH, DATAPOINT_LINK)
    IN (SELECT B.CH, B.DATAPOINT_LINK
      FROM UTCH A, UTCHDP B
      WHERE B.DATAPOINT_LINK = A_SC || '#' || 
                               A_PG || '#' || A_PGNODE || '#' || 
                               A_PA || '#' || A_PANODE || '#' || TO_CHAR(L_OLD_REANALYSIS) 
        AND B.CH = A.CH
        AND A.ALLOW_MODIFY IN ('1', '#')
        AND NVL(UNAPIAUT.SQLGETCHALLOWMODIFY(B.CH),'0')='1');
   END IF;

	IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
		RAISE STPERROR;
	END IF;

   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      L_OBJECT_ID := A_SC || A_PG || TO_CHAR(A_PGNODE) || A_PA || TO_CHAR(A_PANODE);
      UNAPIAUT.UPDATEAUTHORISATIONBUFFER('pa', L_OBJECT_ID, NULL, L_NEW_SS);
   END IF;
   
   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ReanalScParameter', SQLERRM);
   END IF;
   IF L_SCPA_CURSOR%ISOPEN THEN
      CLOSE L_SCPA_CURSOR;
   END IF;
   IF L_SCME_CURSOR%ISOPEN THEN
      CLOSE L_SCME_CURSOR;
   END IF;
   IF L_SCME_MAX_CURSOR%ISOPEN THEN
      CLOSE L_SCME_MAX_CURSOR;
   END IF;
   IF L_LC_CURSOR%ISOPEN THEN
      CLOSE L_LC_CURSOR;
   END IF;
   IF L_SCPAOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCPAOLD_CURSOR;
   END IF;
   IF L_SCPASQCOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCPASQCOLD_CURSOR;
   END IF;
   L_RET_CODE := UNAPIAUT.DISABLEARCHECK('0');
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ReanalScParameter'));
END REANALSCPARAMETER;

FUNCTION CONFIRMPAASSIGNMENT                           
(A_ALARMS_HANDLED   IN     CHAR,                       
 A_SC               IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_PG               IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_PGNODE           IN OUT UNAPIGEN.LONG_TABLE_TYPE,   
 A_PA               IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_PANODE           IN OUT UNAPIGEN.LONG_TABLE_TYPE,   
 A_PR_VERSION       IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_DESCRIPTION      IN     UNAPIGEN.VC40_TABLE_TYPE,   
 A_VALUE_F          IN     UNAPIGEN.FLOAT_TABLE_TYPE,  
 A_VALUE_S          IN     UNAPIGEN.VC40_TABLE_TYPE,   
 A_UNIT             IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_EXEC_START_DATE  IN     UNAPIGEN.DATE_TABLE_TYPE,   
 A_EXEC_END_DATE    IN OUT UNAPIGEN.DATE_TABLE_TYPE,   
 A_EXECUTOR         IN OUT UNAPIGEN.VC20_TABLE_TYPE,   
 A_PLANNED_EXECUTOR IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_MANUALLY_ENTERED IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_ASSIGN_DATE      IN     UNAPIGEN.DATE_TABLE_TYPE,   
 A_ASSIGNED_BY      IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_MANUALLY_ADDED   IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_FORMAT           IN     UNAPIGEN.VC40_TABLE_TYPE,   
 A_TD_INFO          IN     UNAPIGEN.NUM_TABLE_TYPE,    
 A_TD_INFO_UNIT     IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_CONFIRM_UID      IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_ALLOW_ANY_ME     IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_DELAY            IN     UNAPIGEN.NUM_TABLE_TYPE,    
 A_DELAY_UNIT       IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_MIN_NR_RESULTS   IN     UNAPIGEN.NUM_TABLE_TYPE,    
 A_CALC_METHOD      IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_CALC_CF          IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_ALARM_ORDER      IN     UNAPIGEN.VC3_TABLE_TYPE,    
 A_VALID_SPECSA     IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_VALID_SPECSB     IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_VALID_SPECSC     IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_VALID_LIMITSA    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_VALID_LIMITSB    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_VALID_LIMITSC    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_VALID_TARGETA    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_VALID_TARGETB    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_VALID_TARGETC    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_MT               IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_MT_VERSION       IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_MT_NR_MEASUR     IN     UNAPIGEN.NUM_TABLE_TYPE,    
 A_LOG_EXCEPTIONS   IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_PA_CLASS         IN     UNAPIGEN.VC2_TABLE_TYPE,    
 A_LOG_HS           IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_LOG_HS_DETAILS   IN     UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_LC               IN     UNAPIGEN.VC2_TABLE_TYPE,    
 A_LC_VERSION       IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_MODIFY_FLAG      IN OUT UNAPIGEN.NUM_TABLE_TYPE,    
 A_NR_OF_ROWS       IN     NUMBER,                     
 A_MODIFY_REASON    IN     VARCHAR2)                   
RETURN NUMBER IS

L_CONFIRM_ASSIGN              UNAPIGEN.CHAR1_TABLE_TYPE;
L_LOG_HS_DETAILS              UNAPIGEN.CHAR1_TABLE_TYPE;
L_HS_DETAILS_SEQ_NR           INTEGER;

CURSOR L_SCPG_CURSOR(C_SC VARCHAR2, C_PG VARCHAR2, C_PGNODE NUMBER) IS
   SELECT CONFIRM_ASSIGN, LOG_HS_DETAILS
   FROM UTSCPG
   WHERE SC = C_SC
     AND PG = C_PG
     AND PGNODE = C_PGNODE;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   FOR L_ROWS IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_SC(L_ROWS), ' ') = ' ' OR
         NVL(A_PG(L_ROWS), ' ') = ' ' OR
         NVL(A_PGNODE(L_ROWS), 0) = 0 OR
         NVL(A_PA(L_ROWS), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;

      OPEN L_SCPG_CURSOR(A_SC(L_ROWS), A_PG(L_ROWS), A_PGNODE(L_ROWS));
      FETCH L_SCPG_CURSOR
      INTO L_CONFIRM_ASSIGN(L_ROWS), L_LOG_HS_DETAILS(L_ROWS);

      IF L_SCPG_CURSOR%NOTFOUND THEN
         CLOSE L_SCPG_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR;
      END IF;
      CLOSE L_SCPG_CURSOR;

      
      
      
      IF NVL(L_CONFIRM_ASSIGN(L_ROWS), ' ') <> '1' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_CONFIRMASSIGN;
         RAISE STPERROR;
      END IF;

      
      
      
      UPDATE UTSCPG
      SET CONFIRM_ASSIGN = '0'
      WHERE SC = A_SC(L_ROWS)
        AND PG = A_PG(L_ROWS)
        AND PGNODE = A_PGNODE(L_ROWS);
   END LOOP;

   
   
   
   L_RET_CODE := UNAPIPA.SAVESCPARAMETER(A_ALARMS_HANDLED, A_SC, A_PG,
                                         A_PGNODE, A_PA, A_PANODE, A_PR_VERSION, 
                                         A_DESCRIPTION,
                                         A_VALUE_F, A_VALUE_S, A_UNIT,
                                         A_EXEC_START_DATE, A_EXEC_END_DATE,
                                         A_EXECUTOR, A_PLANNED_EXECUTOR,
                                         A_MANUALLY_ENTERED, A_ASSIGN_DATE,
                                         A_ASSIGNED_BY, A_MANUALLY_ADDED,
                                         A_FORMAT, A_TD_INFO,
                                         A_TD_INFO_UNIT, A_CONFIRM_UID,
                                         A_ALLOW_ANY_ME, A_DELAY,
                                         A_DELAY_UNIT,
                                         A_MIN_NR_RESULTS, A_CALC_METHOD,
                                         A_CALC_CF, A_ALARM_ORDER,
                                         A_VALID_SPECSA, A_VALID_SPECSB,
                                         A_VALID_SPECSC, A_VALID_LIMITSA,
                                         A_VALID_LIMITSB, A_VALID_LIMITSC,
                                         A_VALID_TARGETA, A_VALID_TARGETB,
                                         A_VALID_TARGETC, 
                                         A_MT, A_MT_VERSION, A_MT_NR_MEASUR,
                                         A_LOG_EXCEPTIONS, A_PA_CLASS, A_LOG_HS, A_LOG_HS_DETAILS, 
                                         A_LC, A_LC_VERSION, A_MODIFY_FLAG, A_NR_OF_ROWS,
                                         A_MODIFY_REASON);
   
   
   
   IF L_RET_CODE = UNAPIGEN.DBERR_PARTIALSAVE THEN
      FOR L_ROWS IN 1..A_NR_OF_ROWS LOOP
         IF A_MODIFY_FLAG(L_ROWS) > UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := A_MODIFY_FLAG(L_ROWS);
            RAISE STPERROR;
         END IF;
      END LOOP;
   ELSIF L_RET_CODE = UNAPIGEN.DBERR_PARTIALCHARTSAVE THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   
   
   L_EVENT_TP := 'PaAssignConfirmed';
   L_HS_DETAILS_SEQ_NR := 0;
   FOR L_ROWS IN 1..A_NR_OF_ROWS LOOP
      IF A_MODIFY_FLAG(L_ROWS) <= UNAPIGEN.DBERR_SUCCESS THEN
         L_EV_DETAILS := 'sc=' || A_SC(L_ROWS) || 
                         '#pg=' || A_PG(L_ROWS) || 
                         '#pgnode=' || TO_CHAR(A_PGNODE(L_ROWS)) || 
                         '#panode='|| TO_CHAR(A_PANODE(L_ROWS)) ||
                         '#pr_version=' || A_PR_VERSION(L_ROWS);
         L_EV_SEQ_NR := -1;
         L_RESULT := UNAPIEV.INSERTEVENT('ConfirmPaAssignment', UNAPIGEN.P_EVMGR_NAME,
                                         'pa', A_PA(L_ROWS), A_LC(L_ROWS), A_LC_VERSION(L_ROWS), '',
                                         L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
         END IF;
      END IF;

      
      
      
      IF L_LOG_HS_DETAILS(L_ROWS) = '1' THEN
         IF NVL((L_CONFIRM_ASSIGN(L_ROWS) <> '0'), TRUE) THEN 
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCPGHSDETAILS(SC, PG, PGNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC(L_ROWS), A_PG(L_ROWS), A_PGNODE(L_ROWS), UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                   'parameter group "'||A_PG(L_ROWS)||'" is updated: property <confirm_assign> changed value from "' || L_CONFIRM_ASSIGN(L_ROWS) || '" to "0".');
         END IF;
      END IF;
   END LOOP;

   
   
   
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_MODIFY_FLAG(L_SEQ_NO) < UNAPIGEN.DBERR_SUCCESS THEN
         A_MODIFY_FLAG(L_SEQ_NO) := UNAPIGEN.DBERR_SUCCESS;
      END IF;
   END LOOP;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ConfirmPaAssignment', SQLERRM);
   END IF;
   IF L_SCPG_CURSOR%ISOPEN THEN
      CLOSE L_SCPG_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ConfirmPaAssignment'));
END CONFIRMPAASSIGNMENT;

FUNCTION UPDATETRENDINFO                            
(A_SC               IN    VARCHAR2,                 
 A_PG               IN    VARCHAR2,                 
 A_PGNODE           IN    NUMBER,                   
 A_PA               IN    VARCHAR2,                 
 A_PANODE           IN    NUMBER,                   
 A_VALUE_F          IN    FLOAT,                    
 A_VALUE_S          IN    VARCHAR2,                 
 A_EXEC_END_DATE    IN    DATE,                     
 A_TD_INFO          IN    NUMBER,                   
 A_TD_INFO_UNIT     IN    VARCHAR2,                 
 A_REANALYSIS       IN    NUMBER)                   
RETURN NUMBER IS

L_ST            VARCHAR2(20);
L_ST_VERSION    VARCHAR2(20);
L_PR_VERSION    VARCHAR2(20);

CURSOR L_SC_CURSOR(C_SC VARCHAR2) IS
   SELECT ST, ST_VERSION
   FROM UTSC
   WHERE SC = C_SC;

CURSOR L_VERSION_CURSOR IS
   SELECT PR_VERSION 
   FROM UTSCPA
   WHERE SC     = A_SC
     AND PG     = A_PG
     AND PGNODE = A_PGNODE
     AND PA     = A_PA
     AND PANODE = A_PANODE;
  
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
      A_REANALYSIS IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_TD_INFO_UNIT, ' ') <> ' ' AND
      NVL(A_TD_INFO, 0) <> 0 THEN
      OPEN L_SC_CURSOR(A_SC);
      FETCH L_SC_CURSOR
      INTO L_ST, L_ST_VERSION;
      IF L_SC_CURSOR%NOTFOUND THEN
         CLOSE L_SC_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR;
      END IF;
      CLOSE L_SC_CURSOR;

      BEGIN
         INSERT INTO UTSCPATD(SC, PG, PGNODE, PA, PANODE, REANALYSIS, ST, ST_VERSION,
                              EXEC_END_DATE, EXEC_END_DATE_TZ, VALUE_F, VALUE_S)
         VALUES(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_REANALYSIS, L_ST, L_ST_VERSION,
                A_EXEC_END_DATE, A_EXEC_END_DATE, A_VALUE_F, A_VALUE_S);
      EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         
         
         
         
         
         UPDATE UTSCPATD
         SET EXEC_END_DATE = A_EXEC_END_DATE,
             EXEC_END_DATE_TZ =  DECODE(A_EXEC_END_DATE, EXEC_END_DATE_TZ, EXEC_END_DATE_TZ, A_EXEC_END_DATE),
             VALUE_F = A_VALUE_F,
             VALUE_S = A_VALUE_S
         WHERE SC = A_SC
         AND PG = A_PG
         AND PGNODE = A_PGNODE
         AND PA = A_PA
         AND PANODE = A_PANODE;
      END;

      OPEN L_VERSION_CURSOR;
      FETCH L_VERSION_CURSOR INTO L_PR_VERSION;
      IF L_VERSION_CURSOR%NOTFOUND THEN
         CLOSE L_VERSION_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_PRVERSION;
         RAISE STPERROR;
      END IF;
      CLOSE L_VERSION_CURSOR;
      
      
      
      
      L_EVENT_TP := 'TrendInfoUpdated';
      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'sc=' || A_SC || 
                      '#pg=' || A_PG || '#pgnode=' || TO_CHAR(A_PGNODE) || 
                      '#panode=' || TO_CHAR(A_PANODE) || 
                      '#reanalysis=' || TO_CHAR(A_REANALYSIS) || 
                      '#st=' || L_ST ||
                      '#td_info=' || TO_CHAR(A_TD_INFO) || 
                      '#td_info_unit=' || A_TD_INFO_UNIT ||
                      '#pr_version=' || L_PR_VERSION;

      L_RESULT := UNAPIEV.INSERTEVENT('UpdateTrendInfo', UNAPIGEN.P_EVMGR_NAME,
                                      'pa', A_PA, '', '', '',
                                      L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('UpdateTrendInfo', SQLERRM);
   END IF;
   IF L_SC_CURSOR%ISOPEN THEN
      CLOSE L_SC_CURSOR;
   END IF;
   IF L_VERSION_CURSOR%ISOPEN THEN
      CLOSE L_VERSION_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'UpdateTrendInfo'));
END UPDATETRENDINFO;

FUNCTION COPYAVAILABLEPARESULT                 
(A_SC               IN   VARCHAR2,             
 A_PG               IN   VARCHAR2,             
 A_PGNODE           IN   NUMBER,               
 A_PA               IN   VARCHAR2,             
 A_PANODE           IN   NUMBER)               
RETURN NUMBER IS

L_PP_VERSION                      VARCHAR2(20);
L_PP_KEY1                         VARCHAR2(20);
L_PP_KEY2                         VARCHAR2(20);
L_PP_KEY3                         VARCHAR2(20);
L_PP_KEY4                         VARCHAR2(20);
L_PP_KEY5                         VARCHAR2(20);
L_SUPPLIER                        VARCHAR2(20);
L_CUSTOMER                        VARCHAR2(20);
L_SEARCH_FOR_SOURCE               BOOLEAN;
L_SCAN_OUTPUT                     BOOLEAN;

L_SVALARMS_HANDLED                CHAR(1);
L_SVSC                            UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG                            UNAPIGEN.VC20_TABLE_TYPE;
L_SVPGNODE                        UNAPIGEN.LONG_TABLE_TYPE;
L_SVPA                            UNAPIGEN.VC20_TABLE_TYPE;
L_SVPANODE                        UNAPIGEN.LONG_TABLE_TYPE;
L_SVVALUE_F                       UNAPIGEN.FLOAT_TABLE_TYPE;
L_SVVALUE_S                       UNAPIGEN.VC40_TABLE_TYPE;
L_SVUNIT                          UNAPIGEN.VC20_TABLE_TYPE;
L_SVFORMAT                        UNAPIGEN.VC40_TABLE_TYPE;
L_SVEXEC_END_DATE                 UNAPIGEN.DATE_TABLE_TYPE;
L_SVEXECUTOR                      UNAPIGEN.VC20_TABLE_TYPE;
L_SVMANUALLY_ENTERED              UNAPIGEN.CHAR1_TABLE_TYPE;
L_SVREANALYSIS                    UNAPIGEN.NUM_TABLE_TYPE;
L_SVMODIFY_FLAG                   UNAPIGEN.NUM_TABLE_TYPE;
L_SVNR_OF_ROWS                    NUMBER;
L_OLD_VALID_SQC                   CHAR(1);
L_HS_DETAILS_SEQ_NR               INTEGER;
L_HOLD_RECURSIVE_FLAG             CHAR(1);

CURSOR L_SCPG_CURSOR(C_SC VARCHAR2, C_PG VARCHAR2, C_PGNODE NUMBER) IS
   SELECT PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5
   FROM UTSCPG
   WHERE SC = C_SC
     AND PG = C_PG
     AND PGNODE = C_PGNODE;

CURSOR L_SCPA_CURSOR(C_SC VARCHAR2, C_PG VARCHAR2, C_PGNODE NUMBER, C_PA VARCHAR2, C_PANODE NUMBER) IS
   SELECT *
   FROM UTSCPA
   WHERE SC = C_SC
     AND PG = C_PG
     AND PGNODE = C_PGNODE
     AND PA = C_PA
     AND PANODE = C_PANODE;
L_SCPA_REC    L_SCPA_CURSOR%ROWTYPE;  




CURSOR L_SCPASOURCE_CURSOR(C_TARGET_SC             VARCHAR2, 
                           C_TARGET_PG             VARCHAR2, 
                           C_TARGET_PGNODE         NUMBER,
                           C_TARGET_PA             VARCHAR2, 
                           C_TARGET_PANODE         NUMBER, 
                           C_TARGET_PR_VERSION     VARCHAR2,
                           C_TARGET_PP_VERSION     VARCHAR2, 
                           C_TARGET_PP_KEY1        VARCHAR2, 
                           C_TARGET_PP_KEY2        VARCHAR2,
                           C_TARGET_PP_KEY3        VARCHAR2, 
                           C_TARGET_PP_KEY4        VARCHAR2, 
                           C_TARGET_PP_KEY5        VARCHAR2) IS
   SELECT PA.SC, PA.PG, PA.PGNODE, PA.PA, PA.PANODE, 
          PA.VALUE_S, PA.VALUE_F, PA.UNIT, PA.FORMAT, PA.EXEC_END_DATE, PA.EXECUTOR
   FROM UTSCPA PA, UTSCPG PG
   WHERE PA.SC = C_TARGET_SC
     
     AND (PA.PG,PA.PGNODE,PA.PA,PA.PANODE) NOT IN ((C_TARGET_PG,C_TARGET_PGNODE,C_TARGET_PA,C_TARGET_PANODE))
     
     AND PA.PA = C_TARGET_PA
     
     
     
     AND PG.SC     = PA.SC
     AND PG.PG     = PA.PG
     AND PG.PGNODE = PA.PGNODE
     AND (PG.PG,PG.PP_VERSION,PG.PP_KEY1,PG.PP_KEY2,PG.PP_KEY3,PG.PP_KEY4,PG.PP_KEY5) NOT IN
           ((C_TARGET_PG,C_TARGET_PP_VERSION,C_TARGET_PP_KEY1,C_TARGET_PP_KEY2,C_TARGET_PP_KEY3,C_TARGET_PP_KEY4,C_TARGET_PP_KEY5))
     
     
     
     
     
     AND NVL(PA.ACTIVE,'1') = '1'
     AND NVL(PA.SS,'@~')    <> '@C'
     
     AND PA.EXEC_END_DATE IS NOT NULL
     
   ORDER BY UNAPIPG.SQLISSUPPLIERORCUSTOMERPP(PG.PP_KEY1, PG.PP_KEY2, PG.PP_KEY3, PG.PP_KEY4, PG.PP_KEY5),
            PA.PGNODE, 
            PA.PANODE;
L_SCPASOURCE_REC L_SCPASOURCE_CURSOR%ROWTYPE;

CURSOR L_SCPAOUTPUT_CURSOR(C_SC     VARCHAR2, 
                           C_PG     VARCHAR2, 
                           C_PGNODE NUMBER,
                           C_PA     VARCHAR2,
                           C_PANODE NUMBER) IS
   SELECT PA.*
   FROM UTSCPA PA, UTSCPAOUTPUT PAOUT
   WHERE PAOUT.SC          = C_SC
     AND PAOUT.SAVE_PG     = C_PG
     AND PAOUT.SAVE_PGNODE = C_PGNODE
     AND PAOUT.SAVE_PA     = C_PA
     AND PAOUT.SAVE_PANODE = C_PANODE
     AND PAOUT.SC          = PA.SC
     AND PAOUT.SAVE_PG     = PA.PG
     AND PAOUT.SAVE_PGNODE = PA.PGNODE
     AND PAOUT.SAVE_PA     = PA.PA
     AND PAOUT.SAVE_PANODE = PA.PANODE;
     
L_SCPAOUTPUT_REC L_SCPAOUTPUT_CURSOR%ROWTYPE;

CURSOR L_ANYME_CURSOR (C_SC VARCHAR2, 
                       C_PG VARCHAR2, C_PGNODE NUMBER,
                       C_PA VARCHAR2, C_PANODE NUMBER) IS
   SELECT MENODE
   FROM UTSCME
   WHERE SC     = C_SC
     AND PG     = C_PG
     AND PGNODE = C_PGNODE
     AND PA     = C_PA
     AND PANODE = C_PANODE
     
     AND DECODE(SS, NULL, '1', NVL(ACTIVE,'1')) = '1'
     AND NVL(SS,'@~')    <> '@C';
L_ANYME_REC      L_ANYME_CURSOR%ROWTYPE;
L_ORIG_AR_CHECK_MODE                 CHAR(1);
L_IGNORED_RET_CODE                   INTEGER;

BEGIN

   L_HOLD_RECURSIVE_FLAG := NULL;
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
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

   
   

   
   IF UNAPIGEN.P_PP_KEY4PRODUCT IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SETCONNECTION;    
      RAISE STPERROR;               
   END IF;

   
   OPEN L_SCPA_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE);
   FETCH L_SCPA_CURSOR
   INTO L_SCPA_REC;
   IF L_SCPA_CURSOR%NOTFOUND THEN
      CLOSE L_SCPA_CURSOR;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;
   CLOSE L_SCPA_CURSOR;

   
   
   
   L_SEARCH_FOR_SOURCE := TRUE;
   IF UNAPIGEN.P_PP_KEY_NR_OF_ROWS = 0 THEN
      L_SEARCH_FOR_SOURCE := FALSE;
   END IF;
      
   
   IF L_SEARCH_FOR_SOURCE THEN
      
      IF L_SCPA_REC.EXEC_END_DATE IS NOT NULL THEN
         L_SEARCH_FOR_SOURCE := FALSE;
      END IF;
   END IF;
   
   
   IF L_SEARCH_FOR_SOURCE THEN
      OPEN L_ANYME_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE);
      FETCH L_ANYME_CURSOR
      INTO L_ANYME_REC;
      IF L_ANYME_CURSOR%FOUND THEN
         L_SEARCH_FOR_SOURCE := FALSE;
      END IF;
      CLOSE L_ANYME_CURSOR;
   END IF;
   
   
   IF L_SEARCH_FOR_SOURCE THEN
      OPEN L_SCPG_CURSOR(A_SC, A_PG, A_PGNODE);
      FETCH L_SCPG_CURSOR
      INTO L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5;
      IF L_SCPG_CURSOR%NOTFOUND THEN
         CLOSE L_SCPG_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR;
      END IF;
      CLOSE L_SCPG_CURSOR;

      L_RET_CODE := UNAPIPG.GETSUPPLIERANDCUSTOMER(L_PP_KEY1,
                                                   L_PP_KEY2,
                                                   L_PP_KEY3,
                                                   L_PP_KEY4, 
                                                   L_PP_KEY5, 
                                                   L_SUPPLIER,
                                                   L_CUSTOMER);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
      END IF;

      IF L_SUPPLIER = ' ' AND
         L_CUSTOMER = ' ' THEN
         L_SEARCH_FOR_SOURCE := FALSE;
      END IF;
   END IF;

   L_SCAN_OUTPUT := TRUE; 
                          
                          
   IF L_SEARCH_FOR_SOURCE THEN   
                             
      
      
      
      OPEN L_SCPASOURCE_CURSOR (A_SC, A_PG, A_PGNODE, 
                                A_PA, A_PANODE, L_SCPA_REC.PR_VERSION,
                                L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, 
                                L_PP_KEY3, L_PP_KEY4, L_PP_KEY5);
      FETCH L_SCPASOURCE_CURSOR
      INTO L_SCPASOURCE_REC;
      IF L_SCPASOURCE_CURSOR%FOUND THEN
         L_SCAN_OUTPUT := FALSE;
         BEGIN
            INSERT INTO UTSCPAOUTPUT(SC, PG, PGNODE, PA, PANODE, 
                                     SAVE_PG, SAVE_PGNODE, SAVE_PA, SAVE_PANODE)
            VALUES(A_SC, L_SCPASOURCE_REC.PG, L_SCPASOURCE_REC.PGNODE, 
                   L_SCPASOURCE_REC.PA, L_SCPASOURCE_REC.PANODE,
                   A_PG, A_PGNODE,A_PA, A_PANODE);            
         EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            
            
            L_SCAN_OUTPUT := TRUE;
         END;            
      ELSE
         L_SCAN_OUTPUT := TRUE;
      END IF;
      CLOSE L_SCPASOURCE_CURSOR;
   END IF;

   
   
   
   
   IF L_SCPA_REC.EXEC_END_DATE IS NULL THEN
      IF L_SCAN_OUTPUT = FALSE THEN

         
         L_RET_CODE := UNAPIGEN.TRANSFORMRESULT(L_SCPASOURCE_REC.VALUE_S,
                                                L_SCPASOURCE_REC.VALUE_F,      
                                                L_SCPASOURCE_REC.UNIT,
                                                L_SCPASOURCE_REC.FORMAT,    
                                                L_SCPA_REC.VALUE_S,    
                                                L_SCPA_REC.VALUE_F,      
                                                L_SCPA_REC.UNIT,    
                                                L_SCPA_REC.FORMAT);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;

         L_SVNR_OF_ROWS := 1;
         L_SVALARMS_HANDLED := UNAPIGEN.ALARMS_NOT_HANDLED;
         L_SVSC(L_SVNR_OF_ROWS) := A_SC;
         L_SVPG(L_SVNR_OF_ROWS) := A_PG;
         L_SVPGNODE(L_SVNR_OF_ROWS) := A_PGNODE;
         L_SVPA(L_SVNR_OF_ROWS) := A_PA;
         L_SVPANODE(L_SVNR_OF_ROWS) := A_PANODE;
         L_SVVALUE_F(L_SVNR_OF_ROWS) := L_SCPA_REC.VALUE_F;
         L_SVVALUE_S(L_SVNR_OF_ROWS) := L_SCPA_REC.VALUE_S;
         L_SVUNIT(L_SVNR_OF_ROWS) := L_SCPA_REC.UNIT;
         L_SVFORMAT(L_SVNR_OF_ROWS) := L_SCPA_REC.FORMAT;   
         L_SVEXEC_END_DATE(L_SVNR_OF_ROWS) := L_SCPASOURCE_REC.EXEC_END_DATE;
         L_SVEXECUTOR(L_SVNR_OF_ROWS) := L_SCPASOURCE_REC.EXECUTOR;
         L_SVMANUALLY_ENTERED(L_SVNR_OF_ROWS) := '0';
         L_SVREANALYSIS(L_SVNR_OF_ROWS) := NULL;
         L_SVMODIFY_FLAG(L_SVNR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;

      ELSE
         L_SVNR_OF_ROWS := 0;
         L_SVALARMS_HANDLED := UNAPIGEN.ALARMS_NOT_HANDLED;
         FOR L_SCPAOUTPUT_REC IN L_SCPAOUTPUT_CURSOR(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE) LOOP

            
            L_RET_CODE := UNAPIGEN.TRANSFORMRESULT(L_SCPAOUTPUT_REC.VALUE_S,
                                                   L_SCPAOUTPUT_REC.VALUE_F,      
                                                   L_SCPAOUTPUT_REC.UNIT,
                                                   L_SCPAOUTPUT_REC.FORMAT,    
                                                   L_SCPA_REC.VALUE_S,    
                                                   L_SCPA_REC.VALUE_F,      
                                                   L_SCPA_REC.UNIT,    
                                                   L_SCPA_REC.FORMAT);
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;
            END IF;

            L_SVNR_OF_ROWS := L_SVNR_OF_ROWS + 1;
            L_SVSC(L_SVNR_OF_ROWS) := A_SC;
            L_SVPG(L_SVNR_OF_ROWS) := A_PG;
            L_SVPGNODE(L_SVNR_OF_ROWS) := A_PGNODE;
            L_SVPA(L_SVNR_OF_ROWS) := A_PA;
            L_SVPANODE(L_SVNR_OF_ROWS) := A_PANODE;
            L_SVVALUE_F(L_SVNR_OF_ROWS) := L_SCPA_REC.VALUE_F;
            L_SVVALUE_S(L_SVNR_OF_ROWS) := L_SCPA_REC.VALUE_S;
            L_SVUNIT(L_SVNR_OF_ROWS) := L_SCPA_REC.UNIT;
            L_SVFORMAT(L_SVNR_OF_ROWS) := L_SCPA_REC.FORMAT;   
            L_SVEXEC_END_DATE(L_SVNR_OF_ROWS) := L_SCPAOUTPUT_REC.EXEC_END_DATE;
            L_SVEXECUTOR(L_SVNR_OF_ROWS) := L_SCPAOUTPUT_REC.EXECUTOR;
            L_SVMANUALLY_ENTERED(L_SVNR_OF_ROWS) := '0';
            L_SVREANALYSIS(L_SVNR_OF_ROWS) := NULL;
            L_SVMODIFY_FLAG(L_SVNR_OF_ROWS) := UNAPIGEN.MOD_FLAG_UPDATE;
         END LOOP;         
      END IF;                                               

      IF L_SVNR_OF_ROWS > 0 THEN
         
         
         L_HOLD_RECURSIVE_FLAG := P_SCPARESULT_RECURSIVE;
         P_SCPARESULT_RECURSIVE := '1';

         L_IGNORED_RET_CODE := UNAPIAUT.GETARCHECKMODE(L_ORIG_AR_CHECK_MODE);
         
         L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK('1');

         
         L_RET_CODE := UNAPIPA.SAVESCPARESULT(L_SVALARMS_HANDLED, L_SVSC, L_SVPG,
                                              L_SVPGNODE, L_SVPA,
                                              L_SVPANODE, L_SVVALUE_F, L_SVVALUE_S,
                                              L_SVUNIT, L_SVFORMAT, L_SVEXEC_END_DATE,
                                              L_SVEXECUTOR, L_SVMANUALLY_ENTERED,
                                              L_SVREANALYSIS, L_SVMODIFY_FLAG,
                                              L_SVNR_OF_ROWS, '');
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
         
         L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK(L_ORIG_AR_CHECK_MODE);
         
         P_SCPARESULT_RECURSIVE := L_HOLD_RECURSIVE_FLAG;
         L_HOLD_RECURSIVE_FLAG := NULL;

      END IF;
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CopyAvailablePaResult',SQLERRM);
   END IF;
   IF L_SCPG_CURSOR%ISOPEN THEN
      CLOSE L_SCPG_CURSOR;
   END IF;
   IF L_SCPA_CURSOR%ISOPEN THEN
      CLOSE L_SCPA_CURSOR;
   END IF;
   IF L_ANYME_CURSOR%ISOPEN THEN
      CLOSE L_ANYME_CURSOR;
   END IF;
   IF L_SCPASOURCE_CURSOR%ISOPEN THEN
      CLOSE L_SCPASOURCE_CURSOR;
   END IF;
   IF L_SCPAOUTPUT_CURSOR%ISOPEN THEN
      CLOSE L_SCPAOUTPUT_CURSOR;
   END IF;
   
   IF L_ORIG_AR_CHECK_MODE IS NOT NULL THEN
      L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK(L_ORIG_AR_CHECK_MODE);
   END IF;   
   IF L_HOLD_RECURSIVE_FLAG IS NOT NULL THEN
      P_SCPARESULT_RECURSIVE := L_HOLD_RECURSIVE_FLAG;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CopyAvailablePaResult'));
END COPYAVAILABLEPARESULT;

BEGIN
   P_SCPARESULT_RECURSIVE := '0';
END UNAPIPA2;