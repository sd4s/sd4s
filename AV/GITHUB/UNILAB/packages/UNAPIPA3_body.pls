PACKAGE BODY Unapipa3 AS

L_SQLERRM                    VARCHAR2(255);
L_SQL_STRING                 VARCHAR2(2000);
L_WHERE_CLAUSE               VARCHAR2(1000);
L_EVENT_TP                   UTEV.EV_TP%TYPE;
L_TIMED_EVENT_TP             UTEVTIMED.EV_TP%TYPE;
L_RET_CODE                   NUMBER;
L_RESULT                     NUMBER;
L_FETCHED_ROWS               NUMBER;
L_EV_SEQ_NR                  NUMBER;
L_EV_DETAILS                 VARCHAR2(255);
L_ERRM                       VARCHAR2(255);
STPERROR                     EXCEPTION;


L_SQC_ON            VARCHAR2(40) DEFAULT NULL;
L_MAX_RISING        INTEGER DEFAULT 0;
L_MAX_FALLING       INTEGER DEFAULT 0;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_21.00');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION SAVESCPARAMETER                               
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

L_MT_VERSION                    VARCHAR2(20);
L_PR_VERSION                    VARCHAR2(20);
L_LC                            VARCHAR2(2);
L_LC_VERSION                    VARCHAR2(20);
L_SS                            VARCHAR2(2);
L_SS_TO                         VARCHAR2(2);
L_LOG_HS                        CHAR(1);
L_LOG_HS_DETAILS                CHAR(1);
L_ALLOW_MODIFY                  CHAR(1);
L_ACTIVE                        CHAR(1);
L_INSERT                        BOOLEAN;
L_PA_RECORD_OK                  BOOLEAN;
L_PA_HANDLED                    BOOLEAN;
CURR_ITEM                       INTEGER;
NEXT_ITEM                       INTEGER;
PREV_NODE                       NUMBER(9);
NEXT_NODE                       NUMBER(9);
NODE_STEP                       NUMBER(9);
L_SEQ_NO                        INTEGER;
L_LAST_SEQ_NO                   INTEGER;
NBR_OF_NODES_TO_CREATE          INTEGER;
L_COMPLETELY_SAVED              BOOLEAN;
L_COMPLETE_CHART_SAVED          BOOLEAN;
L_DELETED_NODE                  NUMBER(9);
L_DELAYED_TILL                  TIMESTAMP WITH TIME ZONE;
L_OLD_DELAY                     INTEGER;
L_OLD_DELAY_UNIT                VARCHAR2(20);
L_DELETE_CURSOR                 INTEGER;
L_REF_DATE                      TIMESTAMP WITH TIME ZONE;
L_PG_CONFIRM_ASSIGN             CHAR(1);
L_PG_PP_KEY1                    VARCHAR2(20);
L_PG_PP_KEY2                    VARCHAR2(20);
L_PG_PP_KEY3                    VARCHAR2(20);
L_PG_PP_KEY4                    VARCHAR2(20);
L_PG_PP_KEY5                    VARCHAR2(20);
L_SPEC_SET_NR                   INTEGER;
L_SPEC_SET                      CHAR(1);
L_USED_PG                       UNAPIGEN.VC20_TABLE_TYPE;
L_USED_PGNODE                   UNAPIGEN.LONG_TABLE_TYPE;
L_USED_PP_VERSION               UNAPIGEN.VC20_TABLE_TYPE;
L_HS_DETAILS_SEQ_NR             INTEGER;

L_SVPG_SEQ                      INTEGER;
L_SVPG_SC                       UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_PG                       UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_PGNODE                   UNAPIGEN.LONG_TABLE_TYPE;
L_SVPG_PP_VERSION               UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_PP_KEY1                  UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_PP_KEY2                  UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_PP_KEY3                  UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_PP_KEY4                  UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_PP_KEY5                  UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_DESCRIPTION              UNAPIGEN.VC40_TABLE_TYPE;
L_SVPG_VALUE_F                  UNAPIGEN.FLOAT_TABLE_TYPE;
L_SVPG_VALUE_S                  UNAPIGEN.VC40_TABLE_TYPE;
L_SVPG_UNIT                     UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_EXEC_START_DATE          UNAPIGEN.DATE_TABLE_TYPE;
L_SVPG_EXEC_END_DATE            UNAPIGEN.DATE_TABLE_TYPE;
L_SVPG_EXECUTOR                 UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_PLANNED_EXECUTOR         UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_MANUALLY_ENTERED         UNAPIGEN.CHAR1_TABLE_TYPE;
L_SVPG_ASSIGN_DATE              UNAPIGEN.DATE_TABLE_TYPE;
L_SVPG_ASSIGNED_BY              UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_MANUALLY_ADDED           UNAPIGEN.CHAR1_TABLE_TYPE;
L_SVPG_FORMAT                   UNAPIGEN.VC40_TABLE_TYPE;
L_SVPG_CONFIRM_ASSIGN           UNAPIGEN.CHAR1_TABLE_TYPE;
L_SVPG_ALLOW_ANY_PR             UNAPIGEN.CHAR1_TABLE_TYPE;
L_SVPG_NEVER_CREATE_METHODS     UNAPIGEN.CHAR1_TABLE_TYPE;
L_SVPG_DELAY                    UNAPIGEN.NUM_TABLE_TYPE;
L_SVPG_DELAY_UNIT               UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_PG_CLASS                 UNAPIGEN.VC2_TABLE_TYPE;
L_SVPG_LOG_HS                   UNAPIGEN.CHAR1_TABLE_TYPE;
L_SVPG_LOG_HS_DETAILS           UNAPIGEN.CHAR1_TABLE_TYPE;
L_SVPG_LC                       UNAPIGEN.VC2_TABLE_TYPE;
L_SVPG_LC_VERSION               UNAPIGEN.VC20_TABLE_TYPE;
L_SVPG_MODIFY_FLAG              UNAPIGEN.NUM_TABLE_TYPE;
L_ROW                           INTEGER;

L_LOW_LIMIT                     UNAPIGEN.FLOAT_TABLE_TYPE;
L_HIGH_LIMIT                    UNAPIGEN.FLOAT_TABLE_TYPE;
L_LOW_SPEC                      UNAPIGEN.FLOAT_TABLE_TYPE;
L_HIGH_SPEC                     UNAPIGEN.FLOAT_TABLE_TYPE;
L_LOW_DEV                       UNAPIGEN.FLOAT_TABLE_TYPE;
L_REL_LOW_DEV                   UNAPIGEN.CHAR1_TABLE_TYPE;
L_TARGET                        UNAPIGEN.FLOAT_TABLE_TYPE;
L_HIGH_DEV                      UNAPIGEN.FLOAT_TABLE_TYPE;
L_REL_HIGH_DEV                  UNAPIGEN.CHAR1_TABLE_TYPE;
L_INITSC                        VARCHAR2(20);
L_INITSCPG                      VARCHAR2(20);
L_INITSCPGNODE                  NUMBER(9);
L_INITSCPP_VERSION              VARCHAR2(20);
L_INITSCPA                      UNAPIGEN.VC20_TABLE_TYPE;
L_INITSCPANODE                  UNAPIGEN.LONG_TABLE_TYPE;
L_INITSCPR_VERSION              UNAPIGEN.VC20_TABLE_TYPE;

L_SVRES_SEQ                     INTEGER;
L_SVRES_SC                      UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_PG                      UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_PGNODE                  UNAPIGEN.LONG_TABLE_TYPE;
L_SVRES_PA                      UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_PANODE                  UNAPIGEN.LONG_TABLE_TYPE;
L_SVRES_VALUE_F                 UNAPIGEN.FLOAT_TABLE_TYPE;
L_SVRES_VALUE_S                 UNAPIGEN.VC40_TABLE_TYPE;
L_SVRES_UNIT                    UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_FORMAT                  UNAPIGEN.VC40_TABLE_TYPE;
L_SVRES_EXEC_END_DATE           UNAPIGEN.DATE_TABLE_TYPE;
L_SVRES_EXECUTOR                UNAPIGEN.VC20_TABLE_TYPE;
L_SVRES_MANUALLY_ENTERED        UNAPIGEN.CHAR1_TABLE_TYPE;
L_SVRES_REANALYSIS              UNAPIGEN.NUM_TABLE_TYPE;
L_SVRES_MODIFY_FLAG             UNAPIGEN.NUM_TABLE_TYPE;
L_CURRENT_TIMESTAMP                       TIMESTAMP WITH TIME ZONE;
L_PGDELAYED                     BOOLEAN;
L_COUNT                         INTEGER;

L_INITPG_PP_VERSION             UNAPIGEN.VC20_TABLE_TYPE;
L_INITPG_DESCRIPTION            UNAPIGEN.VC40_TABLE_TYPE;
L_INITPG_VALUE_F                UNAPIGEN.FLOAT_TABLE_TYPE;
L_INITPG_VALUE_S                UNAPIGEN.VC40_TABLE_TYPE;
L_INITPG_UNIT                   UNAPIGEN.VC20_TABLE_TYPE;
L_INITPG_EXEC_START_DATE        UNAPIGEN.DATE_TABLE_TYPE;
L_INITPG_EXEC_END_DATE          UNAPIGEN.DATE_TABLE_TYPE;
L_INITPG_EXECUTOR               UNAPIGEN.VC20_TABLE_TYPE;
L_INITPG_PLANNED_EXECUTOR       UNAPIGEN.VC20_TABLE_TYPE;
L_INITPG_MANUALLY_ENTERED       UNAPIGEN.CHAR1_TABLE_TYPE;
L_INITPG_ASSIGN_DATE            UNAPIGEN.DATE_TABLE_TYPE;
L_INITPG_ASSIGNED_BY            UNAPIGEN.VC20_TABLE_TYPE;
L_INITPG_MANUALLY_ADDED         UNAPIGEN.CHAR1_TABLE_TYPE;
L_INITPG_FORMAT                 UNAPIGEN.VC40_TABLE_TYPE;
L_INITPG_CONFIRM_ASSIGN         UNAPIGEN.CHAR1_TABLE_TYPE;
L_INITPG_ALLOW_ANY_PR           UNAPIGEN.CHAR1_TABLE_TYPE;
L_INITPG_NEVER_CREATE_METHODS   UNAPIGEN.CHAR1_TABLE_TYPE;
L_INITPG_DELAY                  UNAPIGEN.NUM_TABLE_TYPE;
L_INITPG_DELAY_UNIT             UNAPIGEN.VC20_TABLE_TYPE;
L_INITPG_REANALYSIS             UNAPIGEN.NUM_TABLE_TYPE;
L_INITPG_PG_CLASS               UNAPIGEN.VC2_TABLE_TYPE;
L_INITPG_LOG_HS                 UNAPIGEN.CHAR1_TABLE_TYPE;
L_INITPG_LOG_HS_DETAILS         UNAPIGEN.CHAR1_TABLE_TYPE;
L_INITPG_LC                     UNAPIGEN.VC2_TABLE_TYPE;
L_INITPG_LC_VERSION             UNAPIGEN.VC20_TABLE_TYPE;
L_INITPG_NR_OF_ROWS             NUMBER;
L_SLASHPG_INITIALISED           BOOLEAN;
L_ST                            VARCHAR2(20);
L_ST_VERSION                    VARCHAR2(20);
L_PG_LOG_HS                     CHAR(1);
L_PG_LOG_HS_DETAILS             CHAR(1);

CURSOR L_SCPG_CURSOR(A_SC IN VARCHAR2) IS
   SELECT 2 SEQ_NR,A.*
   FROM UTSCPG A
   WHERE A.SC = A_SC
   UNION
   SELECT 1 SEQ_NR,A.*
   FROM UTSCPG A
   WHERE A.SC = A_SC
   AND A.PG = '/'
   ORDER BY 1,4;
L_SCPG_REC         L_SCPG_CURSOR%ROWTYPE;

CURSOR L_SCPGNODE_CURSOR(A_SC IN VARCHAR2, A_PG IN VARCHAR2) IS
   SELECT PGNODE
   FROM UTSCPG
   WHERE SC = A_SC
     AND PG = A_PG
   ORDER BY PGNODE ;
L_SCPGNODE_REC         L_SCPGNODE_CURSOR%ROWTYPE;

CURSOR L_SCMEGK_CURSOR(A_SC IN VARCHAR2, A_PG IN VARCHAR2, A_PGNODE IN NUMBER)IS
   SELECT DISTINCT GK
   FROM UTSCMEGK
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE;

CURSOR L_PPVERSION_CURSOR(A_SC IN VARCHAR2, A_PG IN VARCHAR2, A_PGNODE IN NUMBER)IS
   SELECT PP_VERSION, LOG_HS, LOG_HS_DETAILS
   FROM UTSCPG
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE;

CURSOR L_SC_CURSOR(A_SC VARCHAR2) IS
   SELECT ST, ST_VERSION, SAMPLING_DATE
   FROM UTSC
   WHERE SC = A_SC;


CURSOR C_SYSTEM (A_SETTING_NAME VARCHAR2) IS
   SELECT SETTING_VALUE
   FROM UTSYSTEM
   WHERE SETTING_NAME = A_SETTING_NAME;

CURSOR L_SCPAOLD_CURSOR (A_SC IN VARCHAR2, 
                         A_PG IN VARCHAR2, A_PGNODE IN NUMBER,
                         A_PA IN VARCHAR2, A_PANODE IN NUMBER)IS
   SELECT A.*
   FROM UDSCPA A
   WHERE A.SC = A_SC
     AND A.PG = A_PG
     AND A.PGNODE = A_PGNODE
     AND A.PA = A_PA
     AND A.PANODE = A_PANODE;
L_SCPAOLD_REC UDSCPA%ROWTYPE;
L_SCPANEW_REC UDSCPA%ROWTYPE;

   FUNCTION INITSLASHPG(A_SC VARCHAR2) RETURN NUMBER IS
   BEGIN
      L_INITPG_NR_OF_ROWS := 1;

      L_RET_CODE := UNAPIPG.INITSCPARAMETERGROUP(
                              '/', '',                            
                              ' ', ' ', ' ', ' ', ' ',            
                              NULL,A_SC,
                              L_INITPG_PP_VERSION           ,
                              L_INITPG_DESCRIPTION          ,
                              L_INITPG_VALUE_F              ,
                              L_INITPG_VALUE_S              ,
                              L_INITPG_UNIT                 ,
                              L_INITPG_EXEC_START_DATE      ,
                              L_INITPG_EXEC_END_DATE        ,
                              L_INITPG_EXECUTOR             ,
                              L_INITPG_PLANNED_EXECUTOR     ,
                              L_INITPG_MANUALLY_ENTERED     ,
                              L_INITPG_ASSIGN_DATE          ,
                              L_INITPG_ASSIGNED_BY          ,
                              L_INITPG_MANUALLY_ADDED       ,
                              L_INITPG_FORMAT               ,
                              L_INITPG_CONFIRM_ASSIGN       ,
                              L_INITPG_ALLOW_ANY_PR         ,
                              L_INITPG_NEVER_CREATE_METHODS ,
                              L_INITPG_DELAY                ,
                              L_INITPG_DELAY_UNIT           ,
                              L_INITPG_REANALYSIS           ,
                              L_INITPG_PG_CLASS             ,
                              L_INITPG_LOG_HS               ,
                              L_INITPG_LOG_HS_DETAILS       ,
                              L_INITPG_LC                   ,
                              L_INITPG_LC_VERSION           ,
                              L_INITPG_NR_OF_ROWS           );
      L_SLASHPG_INITIALISED := TRUE;
      RETURN(L_RET_CODE);
   END INITSLASHPG;

BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   L_ERRM := NULL;
   IF NVL(A_ALARMS_HANDLED, UNAPIGEN.ALARMS_NOT_HANDLED)
      NOT IN (UNAPIGEN.ALARMS_NOT_HANDLED, UNAPIGEN.ALARMS_PARTIALLY_HANDLED, UNAPIGEN.ALARMS_ALREADY_HANDLED) THEN
      L_ERRM := 'Invalid value FOR alarms_handled flag'||NVL(A_ALARMS_HANDLED, 'EMPTY');
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;

   
   
   
   
   L_SVRES_SEQ := 0;
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   L_SLASHPG_INITIALISED := FALSE;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP

      
      
      
      
      IF NVL(A_PGNODE(L_SEQ_NO), 0) = 0 THEN

         OPEN L_SCPGNODE_CURSOR(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO));
         FETCH L_SCPGNODE_CURSOR
         INTO L_SCPGNODE_REC;

         IF L_SCPGNODE_CURSOR%FOUND THEN
            A_PGNODE(L_SEQ_NO) := L_SCPGNODE_REC.PGNODE;
         END IF;

         CLOSE L_SCPGNODE_CURSOR;

      END IF;

      L_SVPG_SEQ := 0;
      
      
      
      IF NVL(A_SC(L_SEQ_NO), ' ') <> ' ' AND
         NVL(A_PG(L_SEQ_NO), ' ') IN (' ', '/') AND
         NVL(A_PGNODE(L_SEQ_NO), 0) = 0 THEN

         
         
         
         OPEN L_SCPG_CURSOR(A_SC(L_SEQ_NO));
         FETCH L_SCPG_CURSOR
         INTO L_SCPG_REC;

         IF L_SCPG_CURSOR%NOTFOUND THEN

            IF NOT L_SLASHPG_INITIALISED THEN
               L_RET_CODE := INITSLASHPG(A_SC(L_SEQ_NO));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                  RAISE STPERROR;
               END IF;
            END IF;

            L_SVPG_SEQ                              := L_SVPG_SEQ + 1;
            L_SVPG_SC(L_SVPG_SEQ)                   := A_SC(L_SEQ_NO);
            L_SVPG_PG(L_SVPG_SEQ)                   := '/';
            L_SVPG_PGNODE(L_SVPG_SEQ)               := 0;
            L_SVPG_PP_VERSION(L_SVPG_SEQ)           := L_INITPG_PP_VERSION(1);
            L_SVPG_PP_KEY1(L_SVPG_SEQ)              := ' ';
            L_SVPG_PP_KEY2(L_SVPG_SEQ)              := ' ';
            L_SVPG_PP_KEY3(L_SVPG_SEQ)              := ' ';
            L_SVPG_PP_KEY4(L_SVPG_SEQ)              := ' ';
            L_SVPG_PP_KEY5(L_SVPG_SEQ)              := ' ';
            L_SVPG_DESCRIPTION(L_SVPG_SEQ)          := L_INITPG_DESCRIPTION(1);
            L_SVPG_VALUE_F(L_SVPG_SEQ)              := L_INITPG_VALUE_F(1);
            L_SVPG_VALUE_S(L_SVPG_SEQ)              := L_INITPG_VALUE_S(1);
            L_SVPG_UNIT(L_SVPG_SEQ)                 := L_INITPG_UNIT(1);
            L_SVPG_EXEC_START_DATE(L_SVPG_SEQ)      := L_INITPG_EXEC_START_DATE(1);
            L_SVPG_EXEC_END_DATE(L_SVPG_SEQ)        := L_INITPG_EXEC_END_DATE(1);
            L_SVPG_EXECUTOR(L_SVPG_SEQ)             := L_INITPG_EXECUTOR(1);
            L_SVPG_PLANNED_EXECUTOR(L_SVPG_SEQ)     := L_INITPG_PLANNED_EXECUTOR(1);
            L_SVPG_MANUALLY_ENTERED(L_SVPG_SEQ)     := L_INITPG_MANUALLY_ENTERED(1);
            L_SVPG_ASSIGN_DATE(L_SVPG_SEQ)          := L_INITPG_ASSIGN_DATE(1);
            L_SVPG_ASSIGNED_BY(L_SVPG_SEQ)          := L_INITPG_ASSIGNED_BY(1);
            L_SVPG_MANUALLY_ADDED(L_SVPG_SEQ)       := L_INITPG_MANUALLY_ADDED(1);
            L_SVPG_FORMAT(L_SVPG_SEQ)               := L_INITPG_FORMAT(1);
            L_SVPG_CONFIRM_ASSIGN(L_SVPG_SEQ)       := L_INITPG_CONFIRM_ASSIGN(1);
            L_SVPG_ALLOW_ANY_PR(L_SVPG_SEQ)         := L_INITPG_ALLOW_ANY_PR(1);
            L_SVPG_NEVER_CREATE_METHODS(L_SVPG_SEQ) := L_INITPG_NEVER_CREATE_METHODS(1);
            L_SVPG_DELAY(L_SVPG_SEQ)                := L_INITPG_DELAY(1);
            L_SVPG_DELAY_UNIT(L_SVPG_SEQ)           := L_INITPG_DELAY_UNIT(1);
            L_SVPG_PG_CLASS(L_SVPG_SEQ)             := L_INITPG_PG_CLASS(1);
            L_SVPG_LOG_HS(L_SVPG_SEQ)               := L_INITPG_LOG_HS(1);
            L_SVPG_LOG_HS_DETAILS(L_SVPG_SEQ)       := L_INITPG_LOG_HS_DETAILS(1);
            L_SVPG_LC(L_SVPG_SEQ)                   := L_INITPG_LC(1);
            L_SVPG_LC_VERSION(L_SVPG_SEQ)           := L_INITPG_LC_VERSION(1);
            L_SVPG_MODIFY_FLAG(L_SVPG_SEQ)          := UNAPIGEN.MOD_FLAG_INSERT;

         ELSIF L_SCPG_CURSOR%FOUND AND
               L_SCPG_REC.PG <> '/' THEN

            IF NOT L_SLASHPG_INITIALISED THEN
               L_RET_CODE := INITSLASHPG(A_SC(L_SEQ_NO));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
                  RAISE STPERROR;
               END IF;
            END IF;
            L_SVPG_SEQ                              := L_SVPG_SEQ + 1;
            L_SVPG_SC(L_SVPG_SEQ)                   := A_SC(L_SEQ_NO);
            L_SVPG_PG(L_SVPG_SEQ)                   := '/';
            L_SVPG_PGNODE(L_SVPG_SEQ)               := 0;
            L_SVPG_PP_VERSION(L_SVPG_SEQ)           := L_INITPG_PP_VERSION(1);
            L_SVPG_PP_KEY1(L_SVPG_SEQ)              := ' ';
            L_SVPG_PP_KEY2(L_SVPG_SEQ)              := ' ';
            L_SVPG_PP_KEY3(L_SVPG_SEQ)              := ' ';
            L_SVPG_PP_KEY4(L_SVPG_SEQ)              := ' ';
            L_SVPG_PP_KEY5(L_SVPG_SEQ)              := ' ';
            L_SVPG_DESCRIPTION(L_SVPG_SEQ)          := L_INITPG_DESCRIPTION(1);
            L_SVPG_VALUE_F(L_SVPG_SEQ)              := L_INITPG_VALUE_F(1);
            L_SVPG_VALUE_S(L_SVPG_SEQ)              := L_INITPG_VALUE_S(1);
            L_SVPG_UNIT(L_SVPG_SEQ)                 := L_INITPG_UNIT(1);
            L_SVPG_EXEC_START_DATE(L_SVPG_SEQ)      := L_INITPG_EXEC_START_DATE(1);
            L_SVPG_EXEC_END_DATE(L_SVPG_SEQ)        := L_INITPG_EXEC_END_DATE(1);
            L_SVPG_EXECUTOR(L_SVPG_SEQ)             := L_INITPG_EXECUTOR(1);
            L_SVPG_PLANNED_EXECUTOR(L_SVPG_SEQ)     := L_INITPG_PLANNED_EXECUTOR(1);
            L_SVPG_MANUALLY_ENTERED(L_SVPG_SEQ)     := L_INITPG_MANUALLY_ENTERED(1);
            L_SVPG_ASSIGN_DATE(L_SVPG_SEQ)          := L_INITPG_ASSIGN_DATE(1);
            L_SVPG_ASSIGNED_BY(L_SVPG_SEQ)          := L_INITPG_ASSIGNED_BY(1);
            L_SVPG_MANUALLY_ADDED(L_SVPG_SEQ)       := L_INITPG_MANUALLY_ADDED(1);
            L_SVPG_FORMAT(L_SVPG_SEQ)               := L_INITPG_FORMAT(1);
            L_SVPG_CONFIRM_ASSIGN(L_SVPG_SEQ)       := L_INITPG_CONFIRM_ASSIGN(1);
            L_SVPG_ALLOW_ANY_PR(L_SVPG_SEQ)         := L_INITPG_ALLOW_ANY_PR(1);
            L_SVPG_NEVER_CREATE_METHODS(L_SVPG_SEQ) := L_INITPG_NEVER_CREATE_METHODS(1);
            L_SVPG_DELAY(L_SVPG_SEQ)                := L_INITPG_DELAY(1);
            L_SVPG_DELAY_UNIT(L_SVPG_SEQ)           := L_INITPG_DELAY_UNIT(1);
            L_SVPG_PG_CLASS(L_SVPG_SEQ)             := L_INITPG_PG_CLASS(1);
            L_SVPG_LOG_HS(L_SVPG_SEQ)               := L_INITPG_LOG_HS(1);
            L_SVPG_LOG_HS_DETAILS(L_SVPG_SEQ)       := L_INITPG_LOG_HS_DETAILS(1);
            L_SVPG_LC(L_SVPG_SEQ)                   := L_INITPG_LC(1);
            L_SVPG_LC_VERSION(L_SVPG_SEQ)           := L_INITPG_LC_VERSION(1);
            L_SVPG_MODIFY_FLAG(L_SVPG_SEQ)          := UNAPIGEN.MOD_FLAG_INSERT;

            IF L_SCPG_REC.PGNODE >=2 THEN
               
               
               
               L_SVPG_SEQ                              := L_SVPG_SEQ + 1;
               L_SVPG_SC(L_SVPG_SEQ)                   := L_SCPG_REC.SC;
               L_SVPG_PG(L_SVPG_SEQ)                   := L_SCPG_REC.PG;
               L_SVPG_PGNODE(L_SVPG_SEQ)               := L_SCPG_REC.PGNODE;
               L_SVPG_PP_VERSION(L_SVPG_SEQ)           := L_INITPG_PP_VERSION(1);
               L_SVPG_PP_KEY1(L_SVPG_SEQ)              := ' ';
               L_SVPG_PP_KEY2(L_SVPG_SEQ)              := ' ';
               L_SVPG_PP_KEY3(L_SVPG_SEQ)              := ' ';
               L_SVPG_PP_KEY4(L_SVPG_SEQ)              := ' ';
               L_SVPG_PP_KEY5(L_SVPG_SEQ)              := ' ';
               L_SVPG_DESCRIPTION(L_SVPG_SEQ)          := L_INITPG_DESCRIPTION(1);
               L_SVPG_VALUE_F(L_SVPG_SEQ)              := L_INITPG_VALUE_F(1);
               L_SVPG_VALUE_S(L_SVPG_SEQ)              := L_INITPG_VALUE_S(1);
               L_SVPG_UNIT(L_SVPG_SEQ)                 := L_INITPG_UNIT(1);
               L_SVPG_EXEC_START_DATE(L_SVPG_SEQ)      := L_INITPG_EXEC_START_DATE(1);
               L_SVPG_EXEC_END_DATE(L_SVPG_SEQ)        := L_INITPG_EXEC_END_DATE(1);
               L_SVPG_EXECUTOR(L_SVPG_SEQ)             := L_INITPG_EXECUTOR(1);
               L_SVPG_PLANNED_EXECUTOR(L_SVPG_SEQ)     := L_INITPG_PLANNED_EXECUTOR(1);
               L_SVPG_MANUALLY_ENTERED(L_SVPG_SEQ)     := L_INITPG_MANUALLY_ENTERED(1);
               L_SVPG_ASSIGN_DATE(L_SVPG_SEQ)          := L_INITPG_ASSIGN_DATE(1);
               L_SVPG_ASSIGNED_BY(L_SVPG_SEQ)          := L_INITPG_ASSIGNED_BY(1);
               L_SVPG_MANUALLY_ADDED(L_SVPG_SEQ)       := L_INITPG_MANUALLY_ADDED(1);
               L_SVPG_FORMAT(L_SVPG_SEQ)               := L_INITPG_FORMAT(1);
               L_SVPG_CONFIRM_ASSIGN(L_SVPG_SEQ)       := L_INITPG_CONFIRM_ASSIGN(1);
               L_SVPG_ALLOW_ANY_PR(L_SVPG_SEQ)         := L_INITPG_ALLOW_ANY_PR(1);
               L_SVPG_NEVER_CREATE_METHODS(L_SVPG_SEQ) := L_INITPG_NEVER_CREATE_METHODS(1);
               L_SVPG_DELAY(L_SVPG_SEQ)                := L_INITPG_DELAY(1);
               L_SVPG_DELAY_UNIT(L_SVPG_SEQ)           := L_INITPG_DELAY_UNIT(1);
               L_SVPG_PG_CLASS(L_SVPG_SEQ)             := L_INITPG_PG_CLASS(1);
               L_SVPG_LOG_HS(L_SVPG_SEQ)               := L_INITPG_LOG_HS(1);
               L_SVPG_LOG_HS_DETAILS(L_SVPG_SEQ)       := L_INITPG_LOG_HS_DETAILS(1);
               L_SVPG_LC(L_SVPG_SEQ)                   := L_INITPG_LC(1);
               L_SVPG_LC_VERSION(L_SVPG_SEQ)           := L_INITPG_LC_VERSION(1);
               L_SVPG_MODIFY_FLAG(L_SVPG_SEQ)          := 0;
            END IF;
         ELSE
            L_USED_PG(L_SEQ_NO) := '/';
            L_USED_PGNODE(L_SEQ_NO) := L_SCPG_REC.PGNODE;
         END IF;
         CLOSE L_SCPG_CURSOR;
      ELSE
         L_USED_PG(L_SEQ_NO) := A_PG(L_SEQ_NO);
         L_USED_PGNODE(L_SEQ_NO) := A_PGNODE(L_SEQ_NO);
      END IF;

      IF L_SVPG_SEQ <> 0 THEN
         
         
         

         L_RET_CODE :=
            UNAPIPG.SAVESCPARAMETERGROUP(L_SVPG_SC,
                                         L_SVPG_PG, L_SVPG_PGNODE, L_SVPG_PP_VERSION,
                                         L_SVPG_PP_KEY1, L_SVPG_PP_KEY2, L_SVPG_PP_KEY3, L_SVPG_PP_KEY4, L_SVPG_PP_KEY5,
                                         L_SVPG_DESCRIPTION, L_SVPG_VALUE_F,
                                         L_SVPG_VALUE_S, L_SVPG_UNIT,
                                         L_SVPG_EXEC_START_DATE,
                                         L_SVPG_EXEC_END_DATE,
                                         L_SVPG_EXECUTOR, L_SVPG_PLANNED_EXECUTOR,
                                         L_SVPG_MANUALLY_ENTERED,
                                         L_SVPG_ASSIGN_DATE, L_SVPG_ASSIGNED_BY,
                                         L_SVPG_MANUALLY_ADDED, L_SVPG_FORMAT,
                                         L_SVPG_CONFIRM_ASSIGN,
                                         L_SVPG_ALLOW_ANY_PR, L_SVPG_NEVER_CREATE_METHODS, 
                                         L_SVPG_DELAY,
                                         L_SVPG_DELAY_UNIT, L_SVPG_PG_CLASS,
                                         L_SVPG_LOG_HS, L_SVPG_LOG_HS_DETAILS, 
                                         L_SVPG_LC, L_SVPG_LC_VERSION,
                                         L_SVPG_MODIFY_FLAG, L_SVPG_SEQ,
                                         'SaveScParameter DEFAULT / pg created');

         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            IF L_RET_CODE = UNAPIGEN.DBERR_PARTIALSAVE THEN
               FOR L_ROW IN 1..L_SVPG_SEQ LOOP
                  IF L_SVPG_MODIFY_FLAG(L_ROW) > UNAPIGEN.DBERR_SUCCESS THEN
                     UNAPIGEN.P_TXN_ERROR := L_SVPG_MODIFY_FLAG(L_ROW);
                     RAISE STPERROR;
                  END IF;
               END LOOP;
            ELSE
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;
            END IF;
         END IF;

         L_USED_PG(L_SEQ_NO) := '/';
         L_USED_PGNODE(L_SEQ_NO) := L_SVPG_PGNODE(1);
         A_PGNODE(L_SEQ_NO) := L_SVPG_PGNODE(1);
      END IF;
   END LOOP;

   
   
   
   

   
   
   
   CURR_ITEM := 1;
   WHILE CURR_ITEM <= A_NR_OF_ROWS LOOP
      IF A_MODIFY_FLAG(CURR_ITEM) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                      UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                      UNAPIGEN.MOD_FLAG_CREATE) THEN
         IF NVL(A_PANODE(CURR_ITEM), 0) <> 0 THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NEWNODENOTZERO;
            RAISE STPERROR;
         END IF;
         
         
         
         NEXT_ITEM := CURR_ITEM;
         NBR_OF_NODES_TO_CREATE := 0;
         WHILE (A_MODIFY_FLAG(NEXT_ITEM) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                             UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                             UNAPIGEN.MOD_FLAG_CREATE) AND
               NVL(A_SC(NEXT_ITEM), ' ') = NVL(A_SC(CURR_ITEM),' ') AND
               NVL(L_USED_PG(NEXT_ITEM), ' ') = NVL(L_USED_PG(CURR_ITEM),' ') AND
               NVL(L_USED_PGNODE(NEXT_ITEM), 0) = NVL(L_USED_PGNODE(CURR_ITEM),0))
         LOOP
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
            A_SC(NEXT_ITEM) = A_SC(CURR_ITEM) AND
            L_USED_PG(NEXT_ITEM) = L_USED_PG(CURR_ITEM) AND
            L_USED_PGNODE(NEXT_ITEM) = L_USED_PGNODE(CURR_ITEM) THEN

            NEXT_NODE := A_PANODE(NEXT_ITEM);
            SELECT NVL(MAX(PANODE), 0)
            INTO PREV_NODE
            FROM UTSCPA
            WHERE PANODE < NEXT_NODE
              AND SC = A_SC(CURR_ITEM)
              AND PG = L_USED_PG(CURR_ITEM)
              AND PGNODE = L_USED_PGNODE(CURR_ITEM);
            NODE_STEP :=
               TRUNC(ABS((NEXT_NODE - PREV_NODE)) / (NBR_OF_NODES_TO_CREATE + 1));

            IF NODE_STEP < 1 THEN
               UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NODELIMITOVERF;
               RAISE STPERROR;
            END IF;
         ELSE
            
            SELECT NVL(MAX(PANODE), 0)
            INTO PREV_NODE
            FROM UTSCPA
            WHERE SC = A_SC(CURR_ITEM)
              AND PG = L_USED_PG(CURR_ITEM)
              AND PGNODE = L_USED_PGNODE(CURR_ITEM);
            NODE_STEP := UNAPIGEN.DEFAULT_NODE_INTERVAL;
         END IF;
         
         
         
         FOR I IN 1..NBR_OF_NODES_TO_CREATE LOOP
            A_PANODE(CURR_ITEM + I - 1) := PREV_NODE + (NODE_STEP * I);
         END LOOP;

         CURR_ITEM := CURR_ITEM + NBR_OF_NODES_TO_CREATE;
      ELSE
         CURR_ITEM := CURR_ITEM + 1;
      END IF;
   END LOOP;

   
   
   
   L_COMPLETELY_SAVED := TRUE;
   L_COMPLETE_CHART_SAVED := TRUE;

   
   
   
   L_HS_DETAILS_SEQ_NR := 0;
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      L_PA_RECORD_OK := TRUE;          
      L_PA_HANDLED := TRUE;
      L_SS_TO := NULL;

      
      
      
      IF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                     UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                     UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                     UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU,
                                     UNAPIGEN.MOD_FLAG_CREATE) THEN
         IF NVL(A_PR_VERSION(L_SEQ_NO), ' ') = ' ' THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_PRVERSION;
            RAISE STPERROR;
         END IF;
      END IF;

      IF NVL(A_SC(L_SEQ_NO), ' ') = ' ' OR
         NVL(L_USED_PG(L_SEQ_NO), ' ') = ' ' OR
         NVL(L_USED_PGNODE(L_SEQ_NO), 0) = 0 OR
         NVL(A_PA(L_SEQ_NO), ' ') = ' ' THEN

         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      ELSIF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                        UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                        UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                        UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU,
                                        UNAPIGEN.MOD_FLAG_CREATE,
                                        UNAPIGEN.MOD_FLAG_UPDATE,
                                        UNAPIGEN.MOD_FLAG_DELETE) THEN
         
         
         
         L_PR_VERSION := A_PR_VERSION(L_SEQ_NO);
         L_RET_CODE :=
            UNAPIAUT.GETSCPAAUTHORISATION(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO),
                                          L_USED_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                                          L_PR_VERSION, L_LC, L_LC_VERSION, L_SS, L_ALLOW_MODIFY,
                                          L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
         IF L_RET_CODE = UNAPIGEN.DBERR_NOOBJECT THEN
            L_INSERT := TRUE;
         ELSIF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
            L_INSERT := FALSE;
         ELSE
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

      
      
      
      IF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                     UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                     UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                     UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU,
                                     UNAPIGEN.MOD_FLAG_CREATE,
                                     UNAPIGEN.MOD_FLAG_UPDATE) THEN
         IF NVL(A_TD_INFO(L_SEQ_NO), 0) <> 0 AND
            NVL(A_TD_INFO_UNIT(L_SEQ_NO), ' ') NOT IN
               ('SC', 'MI', 'HH', 'DD', 'WW', 'MM', 'YY') THEN
           UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_TDDELAY;
           RAISE STPERROR;

         ELSIF NVL(A_CONFIRM_UID(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_CONFIRMUSERID;
            RAISE STPERROR;

         ELSIF NVL(A_CALC_METHOD(L_SEQ_NO), ' ') NOT IN ('F','L','H','A','C','N') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_CALCMETHOD;
            RAISE STPERROR;

         ELSIF NVL(A_LOG_EXCEPTIONS(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_LOGEXCEPTIONS;
            RAISE STPERROR;

         ELSIF NVL(A_MANUALLY_ENTERED(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MANUALLY_ENTERED;
            RAISE STPERROR;

         ELSIF NVL(A_MANUALLY_ADDED(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_MANUALLYADDED;
            RAISE STPERROR;

         ELSIF NVL(A_ALLOW_ANY_ME(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_ALLOWANYME;
            RAISE STPERROR;
         ELSIF NVL(A_LOG_HS(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_LOGHS;
            RAISE STPERROR;
         ELSIF NVL(A_LOG_HS_DETAILS(L_SEQ_NO), ' ') NOT IN ('0', '1') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_LOGHSDETAILS;
            RAISE STPERROR;
         END IF;
      END IF;

      
      
      
      
      
      

      IF L_PA_RECORD_OK THEN
         SELECT CONFIRM_ASSIGN, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5 
         INTO L_PG_CONFIRM_ASSIGN, L_PG_PP_KEY1, L_PG_PP_KEY2, L_PG_PP_KEY3, L_PG_PP_KEY4, L_PG_PP_KEY5 
         FROM UTSCPG
         WHERE SC = A_SC(L_SEQ_NO)
           AND PG = L_USED_PG(L_SEQ_NO)
           AND PGNODE = L_USED_PGNODE(L_SEQ_NO);

         SELECT NVL(COUNT(OBJECT_TP),0)
         INTO L_COUNT
         FROM UTDELAY
         WHERE SC = A_SC(L_SEQ_NO)
           AND PG = L_USED_PG(L_SEQ_NO)
           AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
           AND OBJECT_TP = 'pg';
         IF L_COUNT = 0 THEN
            L_PGDELAYED := FALSE;
         ELSE
            L_PGDELAYED := TRUE;
         END IF;

         IF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                        UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                        UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                        UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU,
                                        UNAPIGEN.MOD_FLAG_CREATE,
                                        UNAPIGEN.MOD_FLAG_UPDATE) AND
            (NOT L_PGDELAYED) AND
            NVL(A_DELAY(L_SEQ_NO), 0) <> 0 THEN

            BEGIN
               SELECT DELAYED_FROM
               INTO L_REF_DATE
               FROM UTDELAY
               WHERE SC = A_SC(L_SEQ_NO)
                 AND PG = L_USED_PG(L_SEQ_NO)
                 AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
                 AND PA = A_PA(L_SEQ_NO)
                 AND PANODE = A_PANODE(L_SEQ_NO)
                 AND OBJECT_TP = 'pa';
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
      
      
      
      
      
      
      IF L_PA_RECORD_OK AND
         A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_UPDATE THEN

         
         
         
         IF L_INSERT THEN
            
            
            
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
            RAISE STPERROR;
         ELSE
            
            
            
            IF L_PGDELAYED THEN
               
               
               
               L_SS := '@D';
               L_SS_TO := '@D';
            ELSE
               
               
               
               SELECT DELAY, DELAY_UNIT
               INTO L_OLD_DELAY, L_OLD_DELAY_UNIT
               FROM UTSCPA
               WHERE SC = A_SC(L_SEQ_NO)
                 AND PG = L_USED_PG(L_SEQ_NO)
                 AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
                 AND PA = A_PA(L_SEQ_NO)
                 AND PANODE = A_PANODE(L_SEQ_NO);
               
               
               
               IF NVL(L_OLD_DELAY, 0) <> NVL(A_DELAY(L_SEQ_NO), 0) OR
                  NVL(L_OLD_DELAY_UNIT, ' ') <> NVL(A_DELAY_UNIT(L_SEQ_NO), ' ')
                  THEN
                  IF NVL(L_OLD_DELAY, 0) = 0 THEN
                     
                     
                     
                     IF NVL(A_DELAY(L_SEQ_NO), 0) <> 0 THEN
                        
                        
                        
                        
                        
                        L_SS_TO := '@D';
                        INSERT INTO UTDELAY(SC, PG, PGNODE, PA, PANODE, OBJECT_TP,
                                            DELAY, DELAY_UNIT, DELAYED_FROM, DELAYED_FROM_TZ,
                                            DELAYED_TILL, DELAYED_TILL_TZ)
                        VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO),
                               L_USED_PGNODE(L_SEQ_NO),
                               A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO), 'pa',
                               A_DELAY(L_SEQ_NO), A_DELAY_UNIT(L_SEQ_NO),
                               L_REF_DATE, L_REF_DATE, L_DELAYED_TILL, L_DELAYED_TILL);

                        L_EV_SEQ_NR := -1;
                        L_TIMED_EVENT_TP := 'PaActivate';
                        L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                                        '#pg=' || L_USED_PG(L_SEQ_NO) || 
                                        '#pgnode=' || TO_CHAR(L_USED_PGNODE(L_SEQ_NO)) ||
                                        '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) || 
                                        '#pr_version=' || L_PR_VERSION;
                        L_RESULT :=
                           UNAPIEV.INSERTTIMEDEVENT('SaveScParameter', UNAPIGEN.P_EVMGR_NAME,
                                                    'pa', A_PA(L_SEQ_NO), L_LC, L_LC_VERSION, 
                                                    L_SS, L_TIMED_EVENT_TP, L_EV_DETAILS, 
                                                    L_EV_SEQ_NR, L_DELAYED_TILL);
                        IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
                           UNAPIGEN.P_TXN_ERROR := L_RESULT;
                           RAISE STPERROR;
                        END IF;

                        
                        
                        
                        DELETE FROM UTDELAY
                        WHERE SC = A_SC(L_SEQ_NO)
                          AND PG = L_USED_PG(L_SEQ_NO)
                          AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
                          AND PA = A_PA(L_SEQ_NO)
                          AND PANODE = A_PANODE(L_SEQ_NO)
                          AND OBJECT_TP = 'me';

                        DELETE FROM UTEVTIMED
                        WHERE OBJECT_TP = 'me'
                          AND INSTR(EV_DETAILS, 'sc=' || A_SC(L_SEQ_NO)) <> 0
                          AND INSTR(EV_DETAILS, 'pg=' || L_USED_PG(L_SEQ_NO)) <> 0
                          AND INSTR(EV_DETAILS, 'pgnode=' ||
                                    TO_CHAR(L_USED_PGNODE(L_SEQ_NO))) <> 0
                          AND INSTR(EV_DETAILS, 'pa=' || A_PA(L_SEQ_NO)) <> 0
                          AND INSTR(EV_DETAILS, 'panode=' ||
                                    TO_CHAR(A_PANODE(L_SEQ_NO))) <> 0
                          AND EV_TP = 'MeActivate';
                     END IF;
                  ELSE
                     
                     
                     
                     IF NVL(A_DELAY(L_SEQ_NO), 0) = 0 THEN
                        
                        
                        
                        
                        
                        
                        
                        
                        DELETE FROM UTDELAY
                        WHERE SC = A_SC(L_SEQ_NO)
                        AND PG = L_USED_PG(L_SEQ_NO)
                        AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
                        AND PA = A_PA(L_SEQ_NO)
                        AND PANODE = A_PANODE(L_SEQ_NO)
                        AND OBJECT_TP = 'pa';

                        DELETE FROM UTEVTIMED
                        WHERE OBJECT_TP = 'pa'
                        AND OBJECT_ID = A_PA(L_SEQ_NO)
                        AND INSTR(EV_DETAILS, 'sc='||A_SC(L_SEQ_NO)) <> 0
                        AND INSTR(EV_DETAILS, 'pg='||L_USED_PG(L_SEQ_NO)) <> 0
                        AND INSTR(EV_DETAILS, 'pgnode=' ||
                                  TO_CHAR(L_USED_PGNODE(L_SEQ_NO))) <> 0
                        AND INSTR(EV_DETAILS, 'panode=' ||
                                  TO_CHAR(A_PANODE(L_SEQ_NO))) <> 0
                        AND EV_TP = 'PaActivate';

                        L_EV_SEQ_NR := -1;
                        L_TIMED_EVENT_TP := 'PaActivate';
                        L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                                        '#pg=' || L_USED_PG(L_SEQ_NO) || 
                                        '#pgnode=' || TO_CHAR(L_USED_PGNODE(L_SEQ_NO)) ||
                                        '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                                        '#pr_version=' || L_PR_VERSION;
                        L_RESULT :=
                           UNAPIEV.INSERTEVENT('SaveScParameter', UNAPIGEN.P_EVMGR_NAME,
                                               'pa', A_PA(L_SEQ_NO), L_LC, L_LC_VERSION, L_SS,
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
                            DELAYED_FROM_TZ =  DECODE(L_REF_DATE, DELAYED_FROM_TZ, DELAYED_FROM_TZ, L_REF_DATE),
                            DELAYED_TILL = L_DELAYED_TILL,
                            DELAYED_TILL_TZ = L_DELAYED_TILL
                        WHERE SC = A_SC(L_SEQ_NO)
                          AND PG = L_USED_PG(L_SEQ_NO)
                          AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
                          AND PA = A_PA(L_SEQ_NO)
                          AND PANODE = A_PANODE(L_SEQ_NO)
                          AND OBJECT_TP = 'pa';

                        L_EV_SEQ_NR := -1;
                        L_TIMED_EVENT_TP := 'PaActivate';
                        L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                                        '#pg=' || L_USED_PG(L_SEQ_NO) || 
                                        '#pgnode=' || TO_CHAR(L_USED_PGNODE(L_SEQ_NO)) ||
                                        '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) || 
                                        '#pr_version=' || L_PR_VERSION;
                        L_RESULT := UNAPIEV.UPDATETIMEDEVENT('pa', A_PA(L_SEQ_NO),
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

            
            
            
            OPEN L_SCPAOLD_CURSOR(A_SC(L_SEQ_NO), 
                                  A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), 
                                  A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO));
            FETCH L_SCPAOLD_CURSOR
            INTO L_SCPAOLD_REC;
            CLOSE L_SCPAOLD_CURSOR;
            L_SCPANEW_REC := L_SCPAOLD_REC;
            
            
            
            
            
            
            
            
            UPDATE UTSCPA
            SET DESCRIPTION      = A_DESCRIPTION(L_SEQ_NO),
                UNIT             = A_UNIT(L_SEQ_NO),
                EXEC_START_DATE  = NVL(A_EXEC_START_DATE(L_SEQ_NO),EXEC_START_DATE),
                EXEC_START_DATE_TZ  = NVL( DECODE(A_EXEC_START_DATE(L_SEQ_NO), EXEC_START_DATE_TZ, EXEC_START_DATE_TZ, A_EXEC_START_DATE(L_SEQ_NO)),EXEC_START_DATE_TZ),
                EXECUTOR         = A_EXECUTOR(L_SEQ_NO),
                PLANNED_EXECUTOR = A_PLANNED_EXECUTOR(L_SEQ_NO),
                MANUALLY_ENTERED = A_MANUALLY_ENTERED(L_SEQ_NO),
                ASSIGN_DATE      = A_ASSIGN_DATE(L_SEQ_NO),
                ASSIGN_DATE_TZ   = DECODE(A_ASSIGN_DATE(L_SEQ_NO), ASSIGN_DATE_TZ, ASSIGN_DATE_TZ, A_ASSIGN_DATE(L_SEQ_NO)) ,
                ASSIGNED_BY      = A_ASSIGNED_BY(L_SEQ_NO),
                MANUALLY_ADDED   = A_MANUALLY_ADDED(L_SEQ_NO),
                FORMAT           = A_FORMAT(L_SEQ_NO),
                TD_INFO          = A_TD_INFO(L_SEQ_NO),
                TD_INFO_UNIT     = A_TD_INFO_UNIT(L_SEQ_NO),
                CONFIRM_UID      = A_CONFIRM_UID(L_SEQ_NO),
                ALLOW_ANY_ME     = A_ALLOW_ANY_ME(L_SEQ_NO),
                DELAY            = A_DELAY(L_SEQ_NO),
                DELAY_UNIT       = A_DELAY_UNIT(L_SEQ_NO),
                MIN_NR_RESULTS   = A_MIN_NR_RESULTS(L_SEQ_NO),
                CALC_METHOD      = A_CALC_METHOD(L_SEQ_NO),
                CALC_CF          = A_CALC_CF(L_SEQ_NO),
                ALARM_ORDER      = A_ALARM_ORDER(L_SEQ_NO),
                VALID_SPECSA     = A_VALID_SPECSA(L_SEQ_NO),
                VALID_SPECSB     = A_VALID_SPECSB(L_SEQ_NO),
                VALID_SPECSC     = A_VALID_SPECSC(L_SEQ_NO),
                VALID_LIMITSA    = A_VALID_LIMITSA(L_SEQ_NO),
                VALID_LIMITSB    = A_VALID_LIMITSB(L_SEQ_NO),
                VALID_LIMITSC    = A_VALID_LIMITSC(L_SEQ_NO),
                VALID_TARGETA    = A_VALID_TARGETA(L_SEQ_NO),
                VALID_TARGETB    = A_VALID_TARGETB(L_SEQ_NO),
                VALID_TARGETC    = A_VALID_TARGETC(L_SEQ_NO),
                LOG_EXCEPTIONS   = A_LOG_EXCEPTIONS(L_SEQ_NO),
                PA_CLASS         = A_PA_CLASS(L_SEQ_NO),
                LOG_HS           = A_LOG_HS(L_SEQ_NO),
                LOG_HS_DETAILS   = A_LOG_HS_DETAILS(L_SEQ_NO),
                ALLOW_MODIFY     = '#'
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO)
            RETURNING DESCRIPTION, UNIT, EXEC_START_DATE, EXEC_START_DATE_TZ, EXECUTOR, PLANNED_EXECUTOR, 
                      MANUALLY_ENTERED, ASSIGN_DATE, ASSIGN_DATE_TZ, ASSIGNED_BY, MANUALLY_ADDED, FORMAT, 
                      TD_INFO, TD_INFO_UNIT, CONFIRM_UID, ALLOW_ANY_ME, DELAY, DELAY_UNIT, 
                      MIN_NR_RESULTS, CALC_METHOD, CALC_CF, ALARM_ORDER, VALID_SPECSA, 
                      VALID_SPECSB, VALID_SPECSC, VALID_LIMITSA, VALID_LIMITSB, VALID_LIMITSC, 
                      VALID_TARGETA, VALID_TARGETB, VALID_TARGETC, LOG_EXCEPTIONS, PA_CLASS, 
                      LOG_HS, LOG_HS_DETAILS, ALLOW_MODIFY
            INTO L_SCPANEW_REC.DESCRIPTION, L_SCPANEW_REC.UNIT, L_SCPANEW_REC.EXEC_START_DATE,  L_SCPANEW_REC.EXEC_START_DATE_TZ,
                 L_SCPANEW_REC.EXECUTOR, L_SCPANEW_REC.PLANNED_EXECUTOR, 
                 L_SCPANEW_REC.MANUALLY_ENTERED, L_SCPANEW_REC.ASSIGN_DATE, L_SCPANEW_REC.ASSIGN_DATE_TZ, 
                 L_SCPANEW_REC.ASSIGNED_BY, L_SCPANEW_REC.MANUALLY_ADDED, L_SCPANEW_REC.FORMAT, 
                 L_SCPANEW_REC.TD_INFO, L_SCPANEW_REC.TD_INFO_UNIT, L_SCPANEW_REC.CONFIRM_UID, 
                 L_SCPANEW_REC.ALLOW_ANY_ME, L_SCPANEW_REC.DELAY, L_SCPANEW_REC.DELAY_UNIT, 
                 L_SCPANEW_REC.MIN_NR_RESULTS, L_SCPANEW_REC.CALC_METHOD, L_SCPANEW_REC.CALC_CF, 
                 L_SCPANEW_REC.ALARM_ORDER, L_SCPANEW_REC.VALID_SPECSA, 
                 L_SCPANEW_REC.VALID_SPECSB, L_SCPANEW_REC.VALID_SPECSC, 
                 L_SCPANEW_REC.VALID_LIMITSA, L_SCPANEW_REC.VALID_LIMITSB, 
                 L_SCPANEW_REC.VALID_LIMITSC, L_SCPANEW_REC.VALID_TARGETA, 
                 L_SCPANEW_REC.VALID_TARGETB, L_SCPANEW_REC.VALID_TARGETC, 
                 L_SCPANEW_REC.LOG_EXCEPTIONS, L_SCPANEW_REC.PA_CLASS, L_SCPANEW_REC.LOG_HS, 
                 L_SCPANEW_REC.LOG_HS_DETAILS, L_SCPANEW_REC.ALLOW_MODIFY;

            
            
            
            IF (NVL(L_SCPAOLD_REC.VALUE_F, 0) <> NVL(A_VALUE_F(L_SEQ_NO), 0)) OR
               (L_SCPAOLD_REC.VALUE_F IS NULL AND A_VALUE_F(L_SEQ_NO) IS NOT NULL) OR
               (L_SCPAOLD_REC.VALUE_F IS NOT NULL AND A_VALUE_F(L_SEQ_NO) IS NULL) OR
               NVL(L_SCPAOLD_REC.VALUE_S, ' ') <> NVL(A_VALUE_S(L_SEQ_NO), ' ') THEN

               
               
               
               L_SVRES_SEQ := L_SVRES_SEQ + 1;
               L_SVRES_SC(L_SVRES_SEQ) := A_SC(L_SEQ_NO);
               L_SVRES_PG(L_SVRES_SEQ) := L_USED_PG(L_SEQ_NO);
               L_SVRES_PGNODE(L_SVRES_SEQ) := L_USED_PGNODE(L_SEQ_NO);
               L_SVRES_PA(L_SVRES_SEQ) := A_PA(L_SEQ_NO);
               L_SVRES_PANODE(L_SVRES_SEQ) := A_PANODE(L_SEQ_NO);
               L_SVRES_VALUE_F(L_SVRES_SEQ) := A_VALUE_F(L_SEQ_NO);
               L_SVRES_VALUE_S(L_SVRES_SEQ) := A_VALUE_S(L_SEQ_NO);
               L_SVRES_UNIT(L_SVRES_SEQ) := A_UNIT(L_SEQ_NO);
               L_SVRES_FORMAT(L_SVRES_SEQ) := A_FORMAT(L_SEQ_NO);
               L_SVRES_EXEC_END_DATE(L_SVRES_SEQ) := A_EXEC_END_DATE(L_SEQ_NO);
               L_SVRES_EXECUTOR(L_SVRES_SEQ) := A_EXECUTOR(L_SEQ_NO);
               L_SVRES_MANUALLY_ENTERED(L_SVRES_SEQ) :=
                                       A_MANUALLY_ENTERED(L_SEQ_NO);
               L_SVRES_MODIFY_FLAG(L_SVRES_SEQ) := UNAPIGEN.MOD_FLAG_UPDATE;
            END IF;

            
            
            
            L_EVENT_TP := 'ParameterUpdated';
         END IF;

      
      
      
      ELSIF L_PA_RECORD_OK AND
            A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                        UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                        UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                        UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU,
                                        UNAPIGEN.MOD_FLAG_CREATE) THEN

         IF NOT L_INSERT THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_PAALREADYEXIST;
            RAISE STPERROR;
         END IF;

         
         
         
         IF L_PGDELAYED THEN
            
            
            
            L_SS := '@D';
            L_SS_TO := '@D';
         ELSE
            
            
            
            IF NVL(A_DELAY(L_SEQ_NO), 0) <> 0 THEN
               
               
               
               
               
               L_SS_TO := '@D';
               INSERT INTO UTDELAY(SC, PG, PGNODE, PA, PANODE, OBJECT_TP,
                                   DELAY, DELAY_UNIT, DELAYED_FROM, DELAYED_FROM_TZ, DELAYED_TILL, DELAYED_TILL_TZ)
                VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO),
                       L_USED_PGNODE(L_SEQ_NO),
                       A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO), 'pa',
                       A_DELAY(L_SEQ_NO), A_DELAY_UNIT(L_SEQ_NO), L_REF_DATE, L_REF_DATE,
                       L_DELAYED_TILL, L_DELAYED_TILL);
               L_EV_SEQ_NR := -1;
               L_TIMED_EVENT_TP := 'PaActivate';
               L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                               '#pg=' || L_USED_PG(L_SEQ_NO) || 
                               '#pgnode=' || TO_CHAR(L_USED_PGNODE(L_SEQ_NO)) || 
                               '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                               '#pr_version=' || L_PR_VERSION;
               L_RESULT :=
                  UNAPIEV.INSERTTIMEDEVENT('SaveScParameter', UNAPIGEN.P_EVMGR_NAME,
                                           'pa', A_PA(L_SEQ_NO), L_LC, L_LC_VERSION, L_SS,
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

         
         
         
         INSERT INTO UTSCPA(SC, PG, PGNODE, PA, PANODE, PR_VERSION, DESCRIPTION, VALUE_F,
                            VALUE_S, UNIT,
                            EXEC_START_DATE, EXEC_START_DATE_TZ,
                            EXEC_END_DATE, EXEC_END_DATE_TZ, EXECUTOR, PLANNED_EXECUTOR,
                            MANUALLY_ENTERED, ASSIGN_DATE, ASSIGN_DATE_TZ, ASSIGNED_BY,
                            MANUALLY_ADDED, FORMAT, TD_INFO,
                            TD_INFO_UNIT, CONFIRM_UID, ALLOW_ANY_ME, DELAY,
                            DELAY_UNIT, MIN_NR_RESULTS, CALC_METHOD, CALC_CF,
                            ALARM_ORDER, VALID_SPECSA, VALID_SPECSB, VALID_SPECSC,
                            VALID_LIMITSA, VALID_LIMITSB, VALID_LIMITSC,
                            VALID_TARGETA, VALID_TARGETB, VALID_TARGETC,
                            LOG_EXCEPTIONS, REANALYSIS, PA_CLASS, LOG_HS, LOG_HS_DETAILS,
                            ALLOW_MODIFY, ACTIVE, LC, LC_VERSION)
          VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO),
                 A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO), L_PR_VERSION,
                 A_DESCRIPTION(L_SEQ_NO), NULL, NULL, A_UNIT(L_SEQ_NO),
                 A_EXEC_START_DATE(L_SEQ_NO), A_EXEC_START_DATE(L_SEQ_NO),
                 NULL, NULL, NULL, A_PLANNED_EXECUTOR(L_SEQ_NO),
                 A_MANUALLY_ENTERED(L_SEQ_NO), A_ASSIGN_DATE(L_SEQ_NO), A_ASSIGN_DATE(L_SEQ_NO),
                 A_ASSIGNED_BY(L_SEQ_NO), A_MANUALLY_ADDED(L_SEQ_NO),
                 A_FORMAT(L_SEQ_NO), A_TD_INFO(L_SEQ_NO),
                 A_TD_INFO_UNIT(L_SEQ_NO), A_CONFIRM_UID(L_SEQ_NO),
                 A_ALLOW_ANY_ME(L_SEQ_NO), A_DELAY(L_SEQ_NO),
                 A_DELAY_UNIT(L_SEQ_NO), A_MIN_NR_RESULTS(L_SEQ_NO),
                 A_CALC_METHOD(L_SEQ_NO), A_CALC_CF(L_SEQ_NO),
                 A_ALARM_ORDER(L_SEQ_NO), A_VALID_SPECSA(L_SEQ_NO),
                 A_VALID_SPECSB(L_SEQ_NO), A_VALID_SPECSC(L_SEQ_NO),
                 A_VALID_LIMITSA(L_SEQ_NO), A_VALID_LIMITSB(L_SEQ_NO),
                 A_VALID_LIMITSC(L_SEQ_NO), A_VALID_TARGETA(L_SEQ_NO),
                 A_VALID_TARGETB(L_SEQ_NO), A_VALID_TARGETC(L_SEQ_NO),
                 A_LOG_EXCEPTIONS(L_SEQ_NO), 0,
                 A_PA_CLASS(L_SEQ_NO), A_LOG_HS(L_SEQ_NO), A_LOG_HS_DETAILS(L_SEQ_NO),
                 '#', '0', L_LC, L_LC_VERSION);
         UNAPIAUT.UPDATELCINAUTHORISATIONBUFFER('pa', A_SC(L_SEQ_NO) || L_USED_PG(L_SEQ_NO) || TO_CHAR(L_USED_PGNODE(L_SEQ_NO)) ||
                                                A_PA(L_SEQ_NO) || TO_CHAR(A_PANODE(L_SEQ_NO)), '', L_LC, L_LC_VERSION);                 

         
         
         OPEN L_PPVERSION_CURSOR(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO));
         FETCH L_PPVERSION_CURSOR
         INTO L_INITSCPP_VERSION, L_PG_LOG_HS, L_PG_LOG_HS_DETAILS;
         CLOSE L_PPVERSION_CURSOR;
         L_USED_PP_VERSION(L_SEQ_NO) := L_INITSCPP_VERSION;

         
         
         
         FOR L_SPEC_SET_NR IN 1..3 LOOP
            L_SPEC_SET := NULL;
            IF L_SPEC_SET_NR = 1 THEN
               L_SPEC_SET := 'a';
            ELSIF L_SPEC_SET_NR = 2 THEN
               L_SPEC_SET := 'b';
            ELSE
               L_SPEC_SET := 'c';
            END IF;

            L_INITSC := A_SC(L_SEQ_NO);
            L_INITSCPG := L_USED_PG(L_SEQ_NO);
            L_INITSCPGNODE := L_USED_PGNODE(L_SEQ_NO);
            L_INITSCPA(1) := A_PA(L_SEQ_NO);
            L_INITSCPANODE(1) := A_PANODE(L_SEQ_NO);
            L_INITSCPR_VERSION(1) := L_PR_VERSION;
            L_RET_CODE :=
               UNAPIPA.INITSCPASPECS(L_SPEC_SET, L_INITSC, 
                                     L_INITSCPG, L_INITSCPGNODE, L_INITSCPP_VERSION,
                                     L_INITSCPA, L_INITSCPANODE, L_INITSCPR_VERSION,
                                     L_LOW_LIMIT, L_HIGH_LIMIT,
                                     L_LOW_SPEC, L_HIGH_SPEC,
                                     L_LOW_DEV, L_REL_LOW_DEV, L_TARGET,
                                     L_HIGH_DEV, L_REL_HIGH_DEV, 1);

            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
               L_RET_CODE <> UNAPIGEN.DBERR_NORECORDS AND
               L_RET_CODE <> UNAPIGEN.DBERR_NOOBJECT THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;
            ELSIF L_RET_CODE = UNAPIGEN.DBERR_NORECORDS THEN
               
               NULL;
            ELSIF L_RET_CODE = UNAPIGEN.DBERR_NOOBJECT THEN
               
               NULL;
            ELSIF L_LOW_LIMIT(1)  IS NOT NULL OR
                  L_HIGH_LIMIT(1) IS NOT NULL OR
                  L_LOW_SPEC(1)   IS NOT NULL OR
                  L_HIGH_SPEC(1)  IS NOT NULL OR
                  L_LOW_DEV(1)    IS NOT NULL OR
                  L_TARGET(1)     IS NOT NULL OR
                  L_HIGH_DEV(1)   IS NOT NULL THEN
               IF L_SPEC_SET = 'a' THEN
                  INSERT INTO UTSCPASPA(SC, PG, PGNODE, PA, PANODE, LOW_LIMIT,
                                        HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV,
                                        REL_LOW_DEV, TARGET, HIGH_DEV,
                                        REL_HIGH_DEV)
                  VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO),
                         L_USED_PGNODE(L_SEQ_NO), L_INITSCPA(1),
                         L_INITSCPANODE(1), L_LOW_LIMIT(1), L_HIGH_LIMIT(1),
                         L_LOW_SPEC(1), L_HIGH_SPEC(1), L_LOW_DEV(1),
                         L_REL_LOW_DEV(1), L_TARGET(1), L_HIGH_DEV(1),
                         L_REL_HIGH_DEV(1));
               ELSIF L_SPEC_SET = 'b' THEN
                  INSERT INTO UTSCPASPB(SC, PG, PGNODE, PA, PANODE, LOW_LIMIT,
                                        HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV,
                                        REL_LOW_DEV, TARGET, HIGH_DEV,
                                        REL_HIGH_DEV)
                  VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO),
                         L_USED_PGNODE(L_SEQ_NO), L_INITSCPA(1),
                         L_INITSCPANODE(1), L_LOW_LIMIT(1), L_HIGH_LIMIT(1),
                         L_LOW_SPEC(1), L_HIGH_SPEC(1), L_LOW_DEV(1),
                         L_REL_LOW_DEV(1), L_TARGET(1), L_HIGH_DEV(1),
                         L_REL_HIGH_DEV(1));
               ELSE
                  INSERT INTO UTSCPASPC(SC, PG, PGNODE, PA, PANODE, LOW_LIMIT,
                                        HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV,
                                        REL_LOW_DEV, TARGET, HIGH_DEV,
                                        REL_HIGH_DEV)
                  VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO),
                         L_USED_PGNODE(L_SEQ_NO), L_INITSCPA(1),
                         L_INITSCPANODE(1), L_LOW_LIMIT(1), L_HIGH_LIMIT(1),
                         L_LOW_SPEC(1), L_HIGH_SPEC(1), L_LOW_DEV(1),
                         L_REL_LOW_DEV(1), L_TARGET(1), L_HIGH_DEV(1),
                         L_REL_HIGH_DEV(1));
               END IF;
            END IF;
         END LOOP;                

         
         
         

         
         
         
         
         
         
         
         
         IF L_SQC_ON IS NULL THEN

            OPEN C_SYSTEM('ON_LINE_SQC');
            FETCH C_SYSTEM
            INTO L_SQC_ON;
            IF C_SYSTEM%NOTFOUND THEN
               L_SQC_ON := 'NO';
            END IF;
            CLOSE C_SYSTEM;

            OPEN C_SYSTEM('SQC_POINTS_RISING');
            FETCH C_SYSTEM
            INTO L_MAX_RISING;
            IF C_SYSTEM%NOTFOUND THEN
               L_MAX_RISING := 0;
            END IF;
            CLOSE C_SYSTEM;

            OPEN C_SYSTEM('SQC_POINTS_FALLING');
            FETCH C_SYSTEM
            INTO L_MAX_FALLING;
            IF C_SYSTEM%NOTFOUND THEN
               L_MAX_FALLING := 0;
            END IF;
            CLOSE C_SYSTEM;

         END IF;

         IF L_SQC_ON = 'YES' THEN
            BEGIN
               INSERT INTO UTSCPASQC
               (SC, PG, PGNODE, PA, PANODE, SQC_AVG, SQC_SIGMA, SQC_AVGR, SQC_UCLR, VALID_SQC)
               SELECT A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO),
                A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                MAX(DECODE(A.AU, 'unsqc_avg', A.VALUE, NULL)),
                MAX(DECODE(A.AU, 'unsqc_stdev', A.VALUE, NULL)),
                MAX(DECODE(A.AU, 'unsqc_avgr', A.VALUE, NULL)),
                MAX(DECODE(A.AU, 'unsqc_uclr', A.VALUE, NULL)),
                ' '
                FROM UTPPPRAU A
                WHERE PP = A_PG(L_SEQ_NO)
                AND VERSION = L_INITSCPP_VERSION
                AND PP_KEY1 = L_PG_PP_KEY1
                AND PP_KEY2 = L_PG_PP_KEY2
                AND PP_KEY3 = L_PG_PP_KEY3
                AND PP_KEY4 = L_PG_PP_KEY4
                AND PP_KEY5 = L_PG_PP_KEY5
                AND PR = A_PA(L_SEQ_NO)
                AND UNAPIGEN.VALIDATEVERSION('pr',PR,PR_VERSION) = A_PR_VERSION(L_SEQ_NO)
                AND A.AU IN ('unsqc_avg' ,'unsqc_stdev' ,'unsqc_avgr','unsqc_uclr')
                GROUP BY A.PP, A.PR;

               
               
               IF SQL%ROWCOUNT=0 THEN
                  IF (L_MAX_RISING > 0 OR L_MAX_FALLING>0) THEN

                     INSERT INTO UTSCPASQC
                     (SC, PG, PGNODE, PA, PANODE,
                      SQC_AVG, SQC_SIGMA, SQC_AVGR, SQC_UCLR, VALID_SQC)
                     VALUES
                     (A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                      NULL, NULL, NULL, NULL, NULL);

                  END IF;
               END IF;
            EXCEPTION
            WHEN INVALID_NUMBER THEN
               UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
               L_ERRM := 'sc=' || A_SC(L_SEQ_NO) ||
                         '#pg=' || A_PG(L_SEQ_NO) ||
                         '#pgnode=' || TO_CHAR(A_PGNODE(L_SEQ_NO)) ||
                         '#pa=' || A_PA(L_SEQ_NO)||
                         '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                         '#ErrorCode=' || TO_CHAR(SQLCODE) ||
                         '#Invalid SQC attribute (in ppprau)';
               RAISE STPERROR;
            END;
         END IF;
         
         
         
         IF A_VALUE_F(L_SEQ_NO) IS NOT NULL OR
            A_VALUE_S(L_SEQ_NO) IS NOT NULL THEN
            
            
            
            L_SVRES_SEQ := L_SVRES_SEQ + 1;
            L_SVRES_SC(L_SVRES_SEQ) := A_SC(L_SEQ_NO);
            L_SVRES_PG(L_SVRES_SEQ) := L_USED_PG(L_SEQ_NO);
            L_SVRES_PGNODE(L_SVRES_SEQ) := L_USED_PGNODE(L_SEQ_NO);
            L_SVRES_PA(L_SVRES_SEQ) := A_PA(L_SEQ_NO);
            L_SVRES_PANODE(L_SVRES_SEQ) := A_PANODE(L_SEQ_NO);
            L_SVRES_VALUE_F(L_SVRES_SEQ) := A_VALUE_F(L_SEQ_NO);
            L_SVRES_VALUE_S(L_SVRES_SEQ) := A_VALUE_S(L_SEQ_NO);
            L_SVRES_UNIT(L_SVRES_SEQ) := A_UNIT(L_SEQ_NO);
            L_SVRES_FORMAT(L_SVRES_SEQ) := A_FORMAT(L_SEQ_NO);
            L_SVRES_EXEC_END_DATE(L_SVRES_SEQ) := A_EXEC_END_DATE(L_SEQ_NO);
            L_SVRES_EXECUTOR(L_SVRES_SEQ) := A_EXECUTOR(L_SEQ_NO);
            L_SVRES_MANUALLY_ENTERED(L_SVRES_SEQ) := A_MANUALLY_ENTERED(L_SEQ_NO);
            L_SVRES_MODIFY_FLAG(L_SVRES_SEQ) := UNAPIGEN.MOD_FLAG_UPDATE;
         END IF;

         
         
         
         L_EVENT_TP := 'ParameterCreated';

      
      
      
      ELSIF L_PA_RECORD_OK AND
            A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_DELETE THEN

         
         IF UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTALLOWEDIN21CFR11;
            RAISE STPERROR;
         END IF;
         
         IF L_INSERT THEN
            
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
            RAISE STPERROR;

         
         
         
         ELSIF L_ACTIVE = '1' THEN
            
            
            
            IF L_PG_CONFIRM_ASSIGN = '0' THEN
 
 
               A_MODIFY_FLAG(L_SEQ_NO) := UNAPIGEN.DBERR_OPACTIVE;
               L_PA_RECORD_OK := FALSE;
               L_COMPLETELY_SAVED := FALSE;
            END IF;
         END IF;

         IF L_PA_RECORD_OK THEN
            
            
            
            DELETE FROM UTSCRD
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTRSCRD
            WHERE SC = A_SC(L_SEQ_NO)
              AND PG = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            
            
            
            L_DELETE_CURSOR := DBMS_SQL.OPEN_CURSOR;
            FOR L_SCMEGKDEL IN L_SCMEGK_CURSOR(A_SC(L_SEQ_NO),
                               L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO)) LOOP
               BEGIN
                  L_SQL_STRING := 'DELETE FROM utscmegk' || L_SCMEGKDEL.GK ||
                                 ' WHERE sc = ''' || REPLACE(A_SC(L_SEQ_NO), '''', '''''') ||  
                                 ''' AND pg=''' || REPLACE(L_USED_PG(L_SEQ_NO), '''', '''''') ||  
                                 ''' AND pgnode=' || L_USED_PGNODE(L_SEQ_NO) ||
                                 ' AND pa=''' || REPLACE(A_PA(L_SEQ_NO), '''', '''''') ||  
                                 ''' AND panode=' || A_PANODE(L_SEQ_NO) ;
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
              AND PG = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTRSCMECELLLISTOUTPUT
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTRSCMECELLOUTPUT
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTRSCMECELLINPUT
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTRSCMECELLLIST
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTRSCMECELL
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTRSCME
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCMECELLINPUT
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCMECELLOUTPUT
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCMECELLLIST
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCMECELLLISTOUTPUT
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCMECELL
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCMEHS
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCMEHSDETAILS
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCMEAU
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCME
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            
            
            
            DELETE FROM UTRSCPASQC
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTRSCPASPC
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTRSCPASPB
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTRSCPASPA
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTRSCPA
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCPASQC
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCPATD
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCPASPC
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCPASPB
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCPASPA
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCPAHS
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCPAHSDETAILS
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTSCPAAU
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE /*+ RULE */ FROM UTCHDP
                WHERE (CH, DATAPOINT_LINK)
                   IN (SELECT B.CH, B.DATAPOINT_LINK
                       FROM UTCH A, UTCHDP B
                       WHERE B.DATAPOINT_LINK LIKE 
                               A_SC(L_SEQ_NO) || '#' || L_USED_PG(L_SEQ_NO)|| '#' 
                               ||L_USED_PGNODE(L_SEQ_NO)|| '#' || A_PA(L_SEQ_NO)|| '#' 
                               ||A_PANODE(L_SEQ_NO)||'#%' 
                        AND B.CH = A.CH
                        AND A.ALLOW_MODIFY IN ('1', '#')
                        AND NVL(UNAPIAUT.SQLGETCHALLOWMODIFY(B.CH),'0')='1');                                          
 

           DELETE FROM UTSCPA
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            
            
            
            DELETE FROM UTDELAY
            WHERE SC     = A_SC(L_SEQ_NO)
              AND PG     = L_USED_PG(L_SEQ_NO)
              AND PGNODE = L_USED_PGNODE(L_SEQ_NO)
              AND PA     = A_PA(L_SEQ_NO)
              AND PANODE = A_PANODE(L_SEQ_NO);

            DELETE FROM UTEVTIMED
            WHERE OBJECT_TP = 'pa'
              AND OBJECT_ID = A_PA(L_SEQ_NO)
              AND INSTR(EV_DETAILS, 'sc=' || A_SC(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pg=' || L_USED_PG(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pgnode=' || TO_CHAR(L_USED_PGNODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'panode=' || TO_CHAR(A_PANODE(L_SEQ_NO))) <> 0;

            DELETE FROM UTEVTIMED
            WHERE INSTR(EV_DETAILS, 'sc=' || A_SC(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pg=' || L_USED_PG(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pgnode=' || TO_CHAR(L_USED_PGNODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'pa=' || A_PA(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'panode=' || TO_CHAR(A_PANODE(L_SEQ_NO))) <> 0;

            DELETE FROM UTEVRULESDELAYED
            WHERE OBJECT_TP = 'pa'
              AND OBJECT_ID = A_PA(L_SEQ_NO)
              AND INSTR(EV_DETAILS, 'sc=' || A_SC(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pg=' || L_USED_PG(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pgnode=' || TO_CHAR(L_USED_PGNODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'panode=' || TO_CHAR(A_PANODE(L_SEQ_NO))) <> 0;

            DELETE FROM UTEVRULESDELAYED
            WHERE INSTR(EV_DETAILS, 'sc=' || A_SC(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pg=' || L_USED_PG(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'pgnode=' || TO_CHAR(L_USED_PGNODE(L_SEQ_NO))) <> 0
              AND INSTR(EV_DETAILS, 'pa=' || A_PA(L_SEQ_NO)) <> 0
              AND INSTR(EV_DETAILS, 'panode=' || TO_CHAR(A_PANODE(L_SEQ_NO))) <> 0;

            L_DELETED_NODE := A_PANODE(L_SEQ_NO);
            A_PANODE(L_SEQ_NO) := 0;  

            
            
            
            L_EVENT_TP := 'ParameterDeleted';
         END IF;
      END IF;

      
      
      
      IF L_PA_RECORD_OK THEN
         L_EV_SEQ_NR := -1;
         IF A_MODIFY_FLAG(L_SEQ_NO) <> UNAPIGEN.MOD_FLAG_DELETE THEN
            L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                            '#pg=' || L_USED_PG(L_SEQ_NO) || 
                            '#pgnode=' || TO_CHAR(L_USED_PGNODE(L_SEQ_NO)) || 
                            '#panode=' || TO_CHAR(A_PANODE(L_SEQ_NO)) ||
                            '#pr_version=' || L_PR_VERSION;
         ELSE
            L_EV_DETAILS := 'sc=' || A_SC(L_SEQ_NO) || 
                            '#pg=' || L_USED_PG(L_SEQ_NO) || 
                            '#pgnode=' || TO_CHAR(L_USED_PGNODE(L_SEQ_NO)) || 
                            '#panode=' || TO_CHAR(L_DELETED_NODE) ||
                            '#pr_version=' || L_PR_VERSION;
         END IF;

         IF NVL(L_SS_TO, ' ') <> ' ' THEN
            L_EV_DETAILS := L_EV_DETAILS || '#ss_to=' || L_SS_TO;
         END IF;

         L_RESULT := UNAPIEV.INSERTEVENT('SaveScParameter', UNAPIGEN.P_EVMGR_NAME,
                                         'pa', A_PA(L_SEQ_NO), L_LC, L_LC_VERSION, L_SS,
                                         L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
         END IF;
      ELSE
         IF L_PA_HANDLED THEN
            L_COMPLETELY_SAVED := FALSE;
         END IF;
      END IF;

      
      
      
      IF L_PA_RECORD_OK AND L_LOG_HS <> A_LOG_HS(L_SEQ_NO) AND
         A_MODIFY_FLAG(L_SEQ_NO) <> UNAPIGEN.MOD_FLAG_DELETE THEN
         IF A_LOG_HS(L_SEQ_NO) = '1' THEN
            INSERT INTO UTSCPAHS(SC, PG, PGNODE, PA, PANODE, WHO, WHO_DESCRIPTION,
                                 WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO),
                   A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                   UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched ON', 
                   'Audit trail is turned on.', 
                   L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         ELSE
            INSERT INTO UTSCPAHS(SC, PG, PGNODE, PA, PANODE, WHO, WHO_DESCRIPTION,
                                 WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO),
                   A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                   UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched OFF', 
                   'Audit trail is turned off.', 
                   L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         END IF;
      END IF;

      
      
      
      IF L_PA_RECORD_OK AND L_LOG_HS_DETAILS <> A_LOG_HS_DETAILS(L_SEQ_NO) AND
         A_MODIFY_FLAG(L_SEQ_NO) <> UNAPIGEN.MOD_FLAG_DELETE THEN
         IF A_LOG_HS_DETAILS(L_SEQ_NO) = '1' THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCPAHSDETAILS(SC, PG, PGNODE, PA, PANODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'Audit trail is turned on.');
         ELSE
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCPAHSDETAILS(SC, PG, PGNODE, PA, PANODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'Audit trail is turned off.');
         END IF;
      END IF;

      IF L_PA_RECORD_OK AND (L_LOG_HS = '1' OR A_LOG_HS(L_SEQ_NO)='1') THEN
         IF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_DELETE THEN
            
            
            
            INSERT INTO UTSCPGHS(SC, PG, PGNODE, WHO, WHO_DESCRIPTION, WHAT,
                                 WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), UNAPIGEN.P_USER, 
                   UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                   'parameter "'||A_PA(L_SEQ_NO)||'" is deleted.', 
                   L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         ELSIF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                           UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                           UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                           UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU) THEN
            
            
            
            
            INSERT INTO UTSCPAHS(SC, PG, PGNODE, PA, PANODE, WHO, WHO_DESCRIPTION, WHAT,
                                 WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO),
                   A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                   NVL(A_ASSIGNED_BY(L_SEQ_NO), UNAPIGEN.P_USER), 
                   NVL(UNAPIGEN.SQLUSERDESCRIPTION(A_ASSIGNED_BY(L_SEQ_NO)), UNAPIGEN.P_USER_DESCRIPTION), 
                   L_EVENT_TP, 
                   'parameter "'||A_PA(L_SEQ_NO)||'" is created.', 
                   L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         ELSE
            
            
            
            INSERT INTO UTSCPAHS(SC, PG, PGNODE, PA, PANODE, WHO, WHO_DESCRIPTION, WHAT,
                                 WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
            VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO),
                   A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO),
                   UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                   'parameter "'||A_PA(L_SEQ_NO)||'" is updated.', 
                   L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
         END IF;
      END IF;

      IF L_PA_RECORD_OK AND (L_LOG_HS_DETAILS = '1' OR A_LOG_HS_DETAILS(L_SEQ_NO)='1') THEN
         IF A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_DELETE THEN
            
            
            
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCPGHSDETAILS(SC, PG, PGNODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC(L_SEQ_NO), A_PG(L_SEQ_NO), A_PGNODE(L_SEQ_NO), UNAPIGEN.P_TR_SEQ, 
                   L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'parameter "'||A_PA(L_SEQ_NO)||'" is deleted.');
         ELSIF A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_INSERT,
                                           UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                           UNAPIGEN.MOD_FLAG_INSERT_WITH_NODES,
                                           UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU) THEN
            
            
            
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCPAHSDETAILS(SC, PG, PGNODE, PA, PANODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                   'parameter "'||A_PA(L_SEQ_NO)||'" is created.');
         ELSE
            
            
            
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTSCPAHSDETAILS(SC, PG, PGNODE, PA, PANODE, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(A_SC(L_SEQ_NO), L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO), A_PA(L_SEQ_NO), 
                   A_PANODE(L_SEQ_NO), UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'parameter "'||A_PA(L_SEQ_NO)||'" is updated.');
            UNAPIHSDETAILS.ADDSCPAHSDETAILS(L_SCPAOLD_REC, L_SCPANEW_REC, UNAPIGEN.P_TR_SEQ, 
                                            L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR); 
         END IF;
      END IF;

      
      
      
      
      
      
      IF L_PA_RECORD_OK AND
         A_MODIFY_FLAG(L_SEQ_NO) IN (UNAPIGEN.MOD_FLAG_CREATE,
                                     UNAPIGEN.MOD_FLAG_INSERT_AND_CRAU,
                                     UNAPIGEN.MOD_FLAG_INSERT_NODES_AND_CRAU) THEN

         
         
         
         L_RET_CODE := UNAPIPAP.INITANDSAVESCPAATTRIBUTES(A_SC(L_SEQ_NO),
                                                          L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO),
                                                          A_PA(L_SEQ_NO), A_PANODE(L_SEQ_NO));
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;

         IF  A_MODIFY_FLAG(L_SEQ_NO) = UNAPIGEN.MOD_FLAG_CREATE THEN

            OPEN L_SC_CURSOR(A_SC(L_SEQ_NO));
            FETCH L_SC_CURSOR
            INTO L_ST, L_ST_VERSION, L_REF_DATE;
            IF L_SC_CURSOR%NOTFOUND THEN
               UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
               RAISE STPERROR;
            END IF;
            CLOSE L_SC_CURSOR;

            
            
            
            L_MT_VERSION := A_MT_VERSION(L_SEQ_NO);
            L_RET_CODE :=
               UNAPIPA.CREATESCPADETAILS(L_ST, L_ST_VERSION, L_USED_PG(L_SEQ_NO), 
                                         L_USED_PP_VERSION(L_SEQ_NO), 
                                         L_PG_PP_KEY1, L_PG_PP_KEY2, L_PG_PP_KEY3,
                                         L_PG_PP_KEY4, L_PG_PP_KEY5, 
                                         A_PA(L_SEQ_NO), 
                                         L_PR_VERSION, L_SEQ_NO, A_SC(L_SEQ_NO), 
                                         L_USED_PG(L_SEQ_NO), L_USED_PGNODE(L_SEQ_NO),
                                         A_PANODE(L_SEQ_NO), '1', L_REF_DATE,
                                         A_MT(L_SEQ_NO), L_MT_VERSION,
                                         A_MT_NR_MEASUR(L_SEQ_NO), 'ParameterCreated');
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;
            END IF;
         END IF;
      END IF;

   
   
   
   END LOOP;

   
   
   
   IF L_SVRES_SEQ <> 0 THEN
      L_RET_CODE :=
         UNAPIPA.SAVESCPARESULT(A_ALARMS_HANDLED, L_SVRES_SC, L_SVRES_PG,
                                L_SVRES_PGNODE, L_SVRES_PA, L_SVRES_PANODE,
                                L_SVRES_VALUE_F, L_SVRES_VALUE_S,
                                L_SVRES_UNIT, L_SVRES_FORMAT, L_SVRES_EXEC_END_DATE,
                                L_SVRES_EXECUTOR, L_SVRES_MANUALLY_ENTERED,
                                L_SVRES_REANALYSIS,
                                L_SVRES_MODIFY_FLAG,
                                L_SVRES_SEQ, A_MODIFY_REASON);
      IF L_RET_CODE = UNAPIGEN.DBERR_PARTIALSAVE THEN
         
         L_COMPLETELY_SAVED := FALSE;
         
         
         














      ELSIF L_RET_CODE = UNAPIGEN.DBERR_PARTIALCHARTSAVE THEN
         
         L_COMPLETELY_SAVED := FALSE;
         L_COMPLETE_CHART_SAVED := FALSE;
         
         
         





      ELSIF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         L_ERRM := 'sc(1)=' || L_SVRES_SC(1) || '#pg(1)=' || L_SVRES_PG(1) ||
                   '#pgnode(1)=' || TO_CHAR(L_SVRES_PGNODE(1)) ||
                   '#pa(1)=' || L_SVRES_PA(1)||
                   '#panode(1)=' || TO_CHAR(L_SVRES_PANODE(1)) ||
                   '#nr_of_rows=' || TO_CHAR(L_SVRES_SEQ) ||
                   '#SaveScPaResult#ErrorCode=' || TO_CHAR(L_RET_CODE);
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
               A_PANODE(L_SEQ_NO) = L_SVRES_PANODE(L_ROW) THEN
                  A_EXECUTOR(L_SEQ_NO) := L_SVRES_EXECUTOR(L_ROW);
                  A_EXEC_END_DATE(L_SEQ_NO) := L_SVRES_EXEC_END_DATE(L_ROW);
                  A_MODIFY_FLAG(L_SEQ_NO) := L_SVRES_MODIFY_FLAG(L_ROW);
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
      IF L_COMPLETE_CHART_SAVED THEN
         RETURN(UNAPIGEN.DBERR_PARTIALSAVE);
      ELSE
         RETURN(UNAPIGEN.DBERR_PARTIALCHARTSAVE);
      END IF;
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveScParameter',SQLERRM);
   END IF;
   IF L_ERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('SaveScParameter',L_ERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_DELETE_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_DELETE_CURSOR);
   END IF;
   IF L_SCPG_CURSOR%ISOPEN THEN
      CLOSE L_SCPG_CURSOR;
   END IF;
   IF L_SCPGNODE_CURSOR%ISOPEN THEN
      CLOSE L_SCPGNODE_CURSOR;
   END IF;
   IF L_SC_CURSOR%ISOPEN THEN
      CLOSE L_SC_CURSOR;
   END IF;
   IF L_SCPAOLD_CURSOR%ISOPEN THEN
      CLOSE L_SCPAOLD_CURSOR;
   END IF;
   IF L_PPVERSION_CURSOR%ISOPEN THEN
      CLOSE L_PPVERSION_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveScParameter'));
END SAVESCPARAMETER;

END UNAPIPA3;