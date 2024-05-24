PACKAGE BODY unapicy AS


L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(2000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
L_EV_DETAILS      VARCHAR2(255);


P_CY_CURSOR      INTEGER;

STPERROR       EXCEPTION;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION SAVECHARTTYPE
(A_CY                      IN    VARCHAR2,                    
 A_VERSION                 IN    VARCHAR2,                    
 A_VERSION_IS_CURRENT      IN    CHAR,                        
 A_EFFECTIVE_FROM          IN    DATE,                        
 A_EFFECTIVE_TILL          IN    DATE,                        
 A_DESCRIPTION             IN    VARCHAR2,                     
 A_DESCRIPTION2            IN    VARCHAR2,                     
 A_IS_TEMPLATE             IN    CHAR,                         
 A_CHART_TITLE             IN    VARCHAR2,                     
 A_X_AXIS_TITLE            IN    VARCHAR2,                     
 A_Y_AXIS_TITLE            IN    VARCHAR2,                     
 A_Y_AXIS_UNIT             IN    VARCHAR2,                     
 A_X_LABEL                 IN    VARCHAR2,                     
 A_DATAPOINT_CNT           IN    NUMBER,                       
 A_DATAPOINT_UNIT          IN    VARCHAR2,                     
 A_XR_MEASUREMENTS         IN    NUMBER,                       
 A_XR_MAX_CHARTS           IN    NUMBER,                       
 A_ASSIGN_CF               IN    VARCHAR2,                     
 A_CY_CALC_CF              IN    VARCHAR2,                     
 A_VISUAL_CF               IN    VARCHAR2,                     
 A_CH_LC                   IN    VARCHAR2,                     
 A_CH_LC_VERSION           IN    VARCHAR2,                     
 A_INHERIT_AU              IN    CHAR,                         
 A_CY_CLASS                IN    VARCHAR2,                     
 A_LOG_HS                  IN    CHAR,                         
 A_LC                      IN    VARCHAR2,                     
 A_LC_VERSION              IN    VARCHAR2,                     
 A_MODIFY_REASON           IN    VARCHAR2)                     
RETURN NUMBER IS
L_VALID_SQC_RULE1          VARCHAR2(255);
L_VALID_SQC_RULE2          VARCHAR2(255);
L_VALID_SQC_RULE3          VARCHAR2(255);
L_VALID_SQC_RULE4          VARCHAR2(255);
L_VALID_SQC_RULE5          VARCHAR2(255);
L_VALID_SQC_RULE6          VARCHAR2(255);
L_VALID_SQC_RULE7          VARCHAR2(255);

BEGIN
RETURN(UNAPICY.SAVECHARTTYPE(A_CY,
                             A_VERSION,
                             A_VERSION_IS_CURRENT,
                             A_EFFECTIVE_FROM,
                             A_EFFECTIVE_TILL,
                             A_DESCRIPTION,
                             A_DESCRIPTION2,
                             A_IS_TEMPLATE,
                             A_CHART_TITLE,
                             A_X_AXIS_TITLE,
                             A_Y_AXIS_TITLE,
                             A_Y_AXIS_UNIT,
                             A_X_LABEL,
                             A_DATAPOINT_CNT,
                             A_DATAPOINT_UNIT,
                             A_XR_MEASUREMENTS,
                             A_XR_MAX_CHARTS,
                             A_ASSIGN_CF,
                             A_CY_CALC_CF,
                             A_VISUAL_CF,
                             L_VALID_SQC_RULE1,
                             L_VALID_SQC_RULE2,
                             L_VALID_SQC_RULE3,
                             L_VALID_SQC_RULE4,
                             L_VALID_SQC_RULE5,
                             L_VALID_SQC_RULE6,
                             L_VALID_SQC_RULE7,
                             A_CH_LC,
                             A_CH_LC_VERSION,
                             A_INHERIT_AU,
                             A_CY_CLASS,
                             A_LOG_HS,
                             A_LC,
                             A_LC_VERSION,
                             A_MODIFY_REASON));
END SAVECHARTTYPE;

FUNCTION SAVECHARTTYPE
(A_CY                      IN    VARCHAR2,                    
 A_VERSION                 IN    VARCHAR2,                    
 A_VERSION_IS_CURRENT      IN    CHAR,                        
 A_EFFECTIVE_FROM          IN    DATE,                        
 A_EFFECTIVE_TILL          IN    DATE,                        
 A_DESCRIPTION             IN    VARCHAR2,                     
 A_DESCRIPTION2            IN    VARCHAR2,                     
 A_IS_TEMPLATE             IN    CHAR,                         
 A_CHART_TITLE             IN    VARCHAR2,                     
 A_X_AXIS_TITLE            IN    VARCHAR2,                     
 A_Y_AXIS_TITLE            IN    VARCHAR2,                     
 A_Y_AXIS_UNIT             IN    VARCHAR2,                     
 A_X_LABEL                 IN    VARCHAR2,                     
 A_DATAPOINT_CNT           IN    NUMBER,                       
 A_DATAPOINT_UNIT          IN    VARCHAR2,                     
 A_XR_MEASUREMENTS         IN    NUMBER,                       
 A_XR_MAX_CHARTS           IN    NUMBER,                       
 A_ASSIGN_CF               IN    VARCHAR2,                     
 A_CY_CALC_CF              IN    VARCHAR2,                     
 A_VISUAL_CF               IN    VARCHAR2,                     
 A_VALID_SQC_RULE1         IN    VARCHAR2,                     
 A_VALID_SQC_RULE2         IN    VARCHAR2,                     
 A_VALID_SQC_RULE3         IN    VARCHAR2,                     
 A_VALID_SQC_RULE4         IN    VARCHAR2,                     
 A_VALID_SQC_RULE5         IN    VARCHAR2,                     
 A_VALID_SQC_RULE6         IN    VARCHAR2,                     
 A_VALID_SQC_RULE7         IN    VARCHAR2,                     
 A_CH_LC                   IN    VARCHAR2,                     
 A_CH_LC_VERSION           IN    VARCHAR2,                     
 A_INHERIT_AU              IN    CHAR,                         
 A_CY_CLASS                IN    VARCHAR2,                     
 A_LOG_HS                  IN    CHAR,                         
 A_LC                      IN    VARCHAR2,                     
 A_LC_VERSION              IN    VARCHAR2,                     
 A_MODIFY_REASON           IN    VARCHAR2)                     
RETURN NUMBER IS

L_LC             VARCHAR2(2);
L_LC_VERSION     VARCHAR2(20);
L_SS             VARCHAR2(2);
L_LOG_HS         CHAR(1);
L_ALLOW_MODIFY   CHAR(1);
L_ACTIVE         CHAR(1);
L_INSERT         BOOLEAN;
L_DEF_AU_LEVEL   VARCHAR2(4);
L_CALC_CF        VARCHAR2(20);
L_ERROR          EXCEPTION;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE L_ERROR;
   END IF;

   IF NVL(A_CY, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  L_ERROR;
   END IF;

   IF NVL(A_LOG_HS, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_LOGHS;
      RAISE  L_ERROR ;
   END IF;

   IF NVL(A_INHERIT_AU, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INHERITAU;
      RAISE  L_ERROR ;
   END IF;

   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE L_ERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('cy', A_CY, A_VERSION, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE = UNAPIGEN.DBERR_NOOBJECT THEN
      L_INSERT := TRUE;
   ELSIF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      L_INSERT := FALSE;
   ELSE
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE L_ERROR;
   END IF;

   IF L_INSERT THEN              
      IF NVL(A_LC, ' ') <> ' ' THEN
         L_LC := A_LC;
      END IF;
      IF NVL(A_LC_VERSION, ' ') <> ' ' THEN
         L_LC_VERSION := A_LC_VERSION;
      END IF;
      INSERT INTO UTCY (CY, VERSION, EFFECTIVE_FROM,  EFFECTIVE_FROM_TZ, 
                       DESCRIPTION, DESCRIPTION2, IS_TEMPLATE,
                       CHART_TITLE, X_AXIS_TITLE, Y_AXIS_TITLE, Y_AXIS_UNIT, X_LABEL, DATAPOINT_CNT, DATAPOINT_UNIT,
                        XR_MEASUREMENTS, XR_MAX_CHARTS,
                        ASSIGN_CF, CY_CALC_CF, VISUAL_CF,
                        VALID_SQC_RULE1, VALID_SQC_RULE2, VALID_SQC_RULE3, VALID_SQC_RULE4, VALID_SQC_RULE5, VALID_SQC_RULE6, VALID_SQC_RULE7,
                        CH_LC, LC, LC_VERSION,
                        LOG_HS, ALLOW_MODIFY, ACTIVE,
                        INHERIT_AU, CY_CLASS)
      VALUES (A_CY, A_VERSION, A_EFFECTIVE_FROM,  A_EFFECTIVE_FROM, 
             A_DESCRIPTION, A_DESCRIPTION2, A_IS_TEMPLATE, 
             A_CHART_TITLE, A_X_AXIS_TITLE, A_Y_AXIS_TITLE, A_Y_AXIS_UNIT, 
             A_X_LABEL, A_DATAPOINT_CNT, A_DATAPOINT_UNIT,
              A_XR_MEASUREMENTS, A_XR_MAX_CHARTS,
              A_ASSIGN_CF, A_CY_CALC_CF, A_VISUAL_CF,
              A_VALID_SQC_RULE1, A_VALID_SQC_RULE2, A_VALID_SQC_RULE3, A_VALID_SQC_RULE4, A_VALID_SQC_RULE5, A_VALID_SQC_RULE6, A_VALID_SQC_RULE7,
              A_CH_LC, L_LC, L_LC_VERSION,
              A_LOG_HS, '#', L_ACTIVE,
              A_INHERIT_AU, A_CY_CLASS);
      L_EVENT_TP := 'ObjectCreated';
   ELSE                                   
      UPDATE UTCY
      SET EFFECTIVE_FROM    = DECODE(EFFECTIVE_TILL, NULL, A_EFFECTIVE_FROM, EFFECTIVE_FROM),
          EFFECTIVE_FROM_TZ = DECODE(EFFECTIVE_TILL, NULL, DECODE(A_EFFECTIVE_FROM, EFFECTIVE_FROM_TZ, EFFECTIVE_FROM_TZ, A_EFFECTIVE_FROM), EFFECTIVE_FROM_TZ),
          DESCRIPTION       = A_DESCRIPTION,
          DESCRIPTION2      = A_DESCRIPTION2,
          IS_TEMPLATE       = A_IS_TEMPLATE,
          CHART_TITLE       = A_CHART_TITLE,
          X_AXIS_TITLE      = A_X_AXIS_TITLE,
          Y_AXIS_TITLE      = A_Y_AXIS_TITLE,
          Y_AXIS_UNIT       = A_Y_AXIS_UNIT,
          X_LABEL           = A_X_LABEL,
          DATAPOINT_CNT     = A_DATAPOINT_CNT,
          DATAPOINT_UNIT    = A_DATAPOINT_UNIT,
          XR_MEASUREMENTS   = A_XR_MEASUREMENTS,
          XR_MAX_CHARTS     = A_XR_MAX_CHARTS,
          ASSIGN_CF         = A_ASSIGN_CF,
          CY_CALC_CF        = A_CY_CALC_CF,
          VISUAL_CF         = A_VISUAL_CF,
          VALID_SQC_RULE1   = A_VALID_SQC_RULE1,
          VALID_SQC_RULE2   = A_VALID_SQC_RULE2,
          VALID_SQC_RULE3   = A_VALID_SQC_RULE3,
          VALID_SQC_RULE4   = A_VALID_SQC_RULE4,
          VALID_SQC_RULE5   = A_VALID_SQC_RULE5,
          VALID_SQC_RULE6   = A_VALID_SQC_RULE6,
          VALID_SQC_RULE7   = A_VALID_SQC_RULE7,
          CH_LC             = A_CH_LC,
          LC                = L_LC,
          LC_VERSION        = L_LC_VERSION,
          LOG_HS            = A_LOG_HS,
          ALLOW_MODIFY      = '#',
          INHERIT_AU        = A_INHERIT_AU, 
          CY_CLASS          = A_CY_CLASS
      WHERE CY = A_CY
        AND VERSION = A_VERSION;
      L_EVENT_TP := 'ObjectUpdated';
   END IF;

   L_EV_SEQ_NR := -1;
   L_RET_CODE := UNAPIEV.INSERTEVENT('SaveChartType',UNAPIGEN.P_EVMGR_NAME, 'cy', A_CY,
                                     L_LC, L_LC_VERSION, L_SS, L_EVENT_TP, 'version='||A_VERSION,
                                     L_EV_SEQ_NR);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE  L_ERROR ;
   END IF;

   IF NVL(L_LOG_HS, ' ') <> A_LOG_HS THEN
      IF A_LOG_HS = '1' THEN
         INSERT INTO UTCYHS (CY, VERSION, WHO, WHO_DESCRIPTION, WHAT,
                             WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES (A_CY, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched ON',
                 'Audit trail is turned on.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      ELSE
         INSERT INTO UTCYHS (CY, VERSION, WHO, WHO_DESCRIPTION, WHAT,
                             WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES (A_CY, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched OFF',
                 'Audit trail is turned off.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   END IF;

   IF NVL(L_LOG_HS, ' ') = '1' THEN
      IF L_EVENT_TP = 'ObjectCreated'  THEN
         INSERT INTO UTCYHS (CY, VERSION, WHO, WHO_DESCRIPTION, WHAT,
                             WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES (A_CY, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP,
                 'chart type "'||A_CY||'" is created.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ,
                 L_EV_SEQ_NR);
      ELSE
         INSERT INTO UTCYHS (CY, VERSION, WHO, WHO_DESCRIPTION, WHAT,
                             WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES (A_CY, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP,
                 'chart type "'||A_CY||'" is updated.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ,
                 L_EV_SEQ_NR);
      END IF;
   ELSE
      
      
      IF L_EVENT_TP = 'ObjectCreated'  THEN
         INSERT INTO UTCYHS (CY, VERSION, WHO, WHO_DESCRIPTION, WHAT,
                             WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES (A_CY, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP,
                 'chart type "'||A_CY||'" is created.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ,
                 L_EV_SEQ_NR);
      END IF;   
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE L_ERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveChartType',SQLERRM);
   END IF ;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveChartType'));
END SAVECHARTTYPE;

FUNCTION DELETECHARTTYPE
(A_CY                  IN       VARCHAR2,    
 A_VERSION             IN       VARCHAR2,    
 A_MODIFY_REASON       IN       VARCHAR2)    
RETURN NUMBER
IS

L_CY_CURSOR      INTEGER;
L_ALLOW_MODIFY   CHAR(1);
L_ACTIVE         CHAR(1);
L_LOG_HS         CHAR(1);
L_LC             VARCHAR(2);
L_LC_VERSION     VARCHAR(20);
L_SS             VARCHAR2(2);

CURSOR L_PRCYST_CURSOR(C_CY VARCHAR2, C_VERSION VARCHAR2) IS
SELECT UTPRCYST.PR, UTPRCYST.VERSION, UTPR.LOG_HS, UTPR.LC, UTPR.LC_VERSION, UTPR.SS, UTPRCYST.ST
FROM   UTPR, UTPRCYST
WHERE  UTPRCYST.CY       = C_CY             AND
       UNAPIGEN.USEVERSION('cy',UTPRCYST.CY,UTPRCYST.CY_VERSION) = C_VERSION      AND
       UTPR.PR           = UTPRCYST.PR      AND
       UTPR.VERSION      = UTPRCYST.VERSION;

CURSOR L_EQCYCT_CURSOR(C_CY VARCHAR2, C_VERSION VARCHAR2) IS
SELECT UTEQCYCT.EQ, UTEQCYCT.VERSION, UTEQCYCT.LAB, UTEQ.LOG_HS, UTEQ.LC, UTEQ.LC_VERSION, UTEQ.SS
FROM   UTEQ, UTEQCYCT
WHERE  UTEQCYCT.CY       = C_CY             AND
       UNAPIGEN.USEVERSION('cy',UTEQCYCT.CY,UTEQCYCT.CY_VERSION) = C_VERSION      AND
       UTEQ.EQ           = UTEQCYCT.EQ      AND
       UTEQ.VERSION      = UTEQCYCT.VERSION;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF  NVL(A_CY, ' ')= ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  STPERROR ;
   END IF;

   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE  STPERROR ;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('cy', A_CY, A_VERSION, L_LC, L_LC_VERSION,
                                           L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE ;
      RAISE  STPERROR ;
   END IF ;

   
   IF UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTALLOWEDIN21CFR11;
      RAISE STPERROR;
   END IF;

   DELETE FROM UTCYAU
   WHERE CY = A_CY
     AND VERSION = A_VERSION;

   DELETE FROM UTCYHS
   WHERE CY = A_CY
     AND VERSION = A_VERSION;

   L_EVENT_TP := 'UsedObjectDeleted';
   L_EV_SEQ_NR := -1;
   FOR PR_REC IN L_PRCYST_CURSOR(A_CY, A_VERSION) LOOP
      DELETE FROM UTPRCYST
      WHERE CY         = A_CY
        AND UNAPIGEN.USEVERSION('cy',CY,CY_VERSION) = A_VERSION
        AND PR         = PR_REC.PR
        AND VERSION    = PR_REC.VERSION;

      L_RESULT := UNAPIEV.INSERTEVENT('DeleteChartType', UNAPIGEN.P_EVMGR_NAME, 'pr', 
                                      PR_REC.PR, PR_REC.LC, PR_REC.LC_VERSION, PR_REC.SS, 
                                      L_EVENT_TP, 'version='||PR_REC.VERSION, L_EV_SEQ_NR);
      IF L_RESULT <> 0 THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;

      IF PR_REC.LOG_HS = '1' THEN
         INSERT INTO UTPRHS(PR, VERSION, WHO, WHO_DESCRIPTION, 
                            WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES  (PR_REC.PR, PR_REC.VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 
                  L_EVENT_TP||' '||A_CY||' '||A_VERSION, 
                  'chart type "'||A_CY||'" is deleted and removed from parameter <<'||PR_REC.PR||'>> - sample type <<'||PR_REC.ST||'>>',
                  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   END LOOP;

   L_EVENT_TP := 'UsedObjectDeleted';
   L_EV_SEQ_NR := -1;
   FOR EQ_REC IN L_EQCYCT_CURSOR(A_CY, A_VERSION) LOOP
      DELETE FROM UTEQCYCT
      WHERE CY         = A_CY
        AND UNAPIGEN.USEVERSION('cy',CY,CY_VERSION) = A_VERSION
        AND EQ         = EQ_REC.EQ
        AND VERSION    = EQ_REC.VERSION;

      L_RESULT := UNAPIEV.INSERTEVENT('DeleteChartType', UNAPIGEN.P_EVMGR_NAME, 'eq', 
                                      EQ_REC.EQ, EQ_REC.LC, EQ_REC.LC_VERSION, EQ_REC.SS, 
                                      L_EVENT_TP, 'lab='||EQ_REC.LAB||'#version='||EQ_REC.VERSION, L_EV_SEQ_NR);
      IF L_RESULT <> 0 THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;

      IF EQ_REC.LOG_HS = '1' THEN
         INSERT INTO UTEQHS(EQ, VERSION, WHO, WHO_DESCRIPTION, 
                            WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES  (EQ_REC.EQ, EQ_REC.VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 
                  L_EVENT_TP||' '||A_CY||' '||A_VERSION, 
                  'chart type "'||A_CY||'" is deleted and removed from equipment <<'||EQ_REC.EQ||'>>',
                  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   END LOOP;

   DELETE FROM UTEVTIMED
   WHERE (OBJECT_TP='cy' AND OBJECT_ID=A_CY AND INSTR(EV_DETAILS,'version='||A_VERSION)<>0);

   DELETE FROM UTEVRULESDELAYED
   WHERE (OBJECT_TP='cy' AND OBJECT_ID=A_CY AND INSTR(EV_DETAILS,'version='||A_VERSION)<>0);

   DELETE FROM UTCY
   WHERE CY = A_CY
     AND VERSION = A_VERSION;

   L_EVENT_TP := 'ObjectDeleted';
   L_EV_SEQ_NR := -1;
   L_RET_CODE := UNAPIEV.INSERTEVENT('DeleteChartType', UNAPIGEN.P_EVMGR_NAME, 'cy',
                                     A_CY, L_LC, L_LC_VERSION, L_SS, L_EVENT_TP,
                                     'version='||A_VERSION, L_EV_SEQ_NR);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE ;
      RAISE  STPERROR ;
   END IF ;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('DeleteChartType',SQLERRM);
   END IF ;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'DeleteChartType'));
END DELETECHARTTYPE;

FUNCTION GETCHARTTYPE
(A_CY                    OUT  UNAPIGEN.VC20_TABLE_TYPE,    
 A_VERSION               OUT  UNAPIGEN.VC20_TABLE_TYPE,    
 A_VERSION_IS_CURRENT    OUT  UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_EFFECTIVE_FROM        OUT  UNAPIGEN.DATE_TABLE_TYPE,    
 A_EFFECTIVE_TILL        OUT  UNAPIGEN.DATE_TABLE_TYPE,    
 A_DESCRIPTION           OUT  UNAPIGEN.VC40_TABLE_TYPE,    
 A_DESCRIPTION2          OUT  UNAPIGEN.VC40_TABLE_TYPE,    
 A_IS_TEMPLATE           OUT  UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_CHART_TITLE           OUT  UNAPIGEN.VC255_TABLE_TYPE,   
 A_X_AXIS_TITLE          OUT  UNAPIGEN.VC255_TABLE_TYPE,   
 A_Y_AXIS_TITLE          OUT  UNAPIGEN.VC255_TABLE_TYPE,   
 A_Y_AXIS_UNIT           OUT  UNAPIGEN.VC20_TABLE_TYPE,    
 A_X_LABEL               OUT  UNAPIGEN.VC60_TABLE_TYPE,    
 A_DATAPOINT_CNT         OUT  UNAPIGEN.NUM_TABLE_TYPE,      
 A_DATAPOINT_UNIT        OUT  UNAPIGEN.VC20_TABLE_TYPE,    
 A_XR_MEASUREMENTS       OUT  UNAPIGEN.NUM_TABLE_TYPE,      
 A_XR_MAX_CHARTS         OUT  UNAPIGEN.NUM_TABLE_TYPE,      
 A_ASSIGN_CF             OUT  UNAPIGEN.VC255_TABLE_TYPE,   
 A_CY_CALC_CF            OUT  UNAPIGEN.VC255_TABLE_TYPE,   
 A_VISUAL_CF             OUT  UNAPIGEN.VC255_TABLE_TYPE,   
 A_CH_LC                 OUT  UNAPIGEN.VC2_TABLE_TYPE,     
 A_CH_LC_VERSION         OUT  UNAPIGEN.VC20_TABLE_TYPE,    
 A_INHERIT_AU            OUT  UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_CY_CLASS              OUT  UNAPIGEN.VC2_TABLE_TYPE,     
 A_LOG_HS                OUT  UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_ALLOW_MODIFY          OUT  UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_ACTIVE                OUT  UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_LC                    OUT  UNAPIGEN.VC2_TABLE_TYPE,     
 A_LC_VERSION            OUT  UNAPIGEN.VC20_TABLE_TYPE,    
 A_SS                    OUT  UNAPIGEN.VC2_TABLE_TYPE,     
 A_NR_OF_ROWS            IN OUT  NUMBER,                   
 A_WHERE_CLAUSE          IN   VARCHAR2)                    
RETURN NUMBER IS
L_VALID_SQC_RULE1_TAB          UNAPIGEN.VC255_TABLE_TYPE;
L_VALID_SQC_RULE2_TAB          UNAPIGEN.VC255_TABLE_TYPE;
L_VALID_SQC_RULE3_TAB          UNAPIGEN.VC255_TABLE_TYPE;
L_VALID_SQC_RULE4_TAB          UNAPIGEN.VC255_TABLE_TYPE;
L_VALID_SQC_RULE5_TAB          UNAPIGEN.VC255_TABLE_TYPE;
L_VALID_SQC_RULE6_TAB          UNAPIGEN.VC255_TABLE_TYPE;
L_VALID_SQC_RULE7_TAB          UNAPIGEN.VC255_TABLE_TYPE;
BEGIN
             RETURN(UNAPICY.GETCHARTTYPE(A_CY,
                                         A_VERSION,
                                         A_VERSION_IS_CURRENT,
                                         A_EFFECTIVE_FROM,
                                         A_EFFECTIVE_TILL,
                                         A_DESCRIPTION,
                                         A_DESCRIPTION2,
                                         A_IS_TEMPLATE,
                                         A_CHART_TITLE,
                                         A_X_AXIS_TITLE,
                                         A_Y_AXIS_TITLE,
                                         A_Y_AXIS_UNIT,
                                         A_X_LABEL,
                                         A_DATAPOINT_CNT,
                                         A_DATAPOINT_UNIT,
                                         A_XR_MEASUREMENTS,
                                         A_XR_MAX_CHARTS,
                                         A_ASSIGN_CF,
                                         A_CY_CALC_CF,
                                         A_VISUAL_CF,
                                         L_VALID_SQC_RULE1_TAB,
                                         L_VALID_SQC_RULE2_TAB,
                                         L_VALID_SQC_RULE3_TAB,
                                         L_VALID_SQC_RULE4_TAB,
                                         L_VALID_SQC_RULE5_TAB,
                                         L_VALID_SQC_RULE6_TAB,
                                         L_VALID_SQC_RULE7_TAB,
                                         A_CH_LC,
                                         A_CH_LC_VERSION,
                                         A_INHERIT_AU,
                                         A_CY_CLASS,
                                         A_LOG_HS,
                                         A_ALLOW_MODIFY,
                                         A_ACTIVE,
                                         A_LC,
                                         A_LC_VERSION,
                                         A_SS,
                                         A_NR_OF_ROWS,
                                         A_WHERE_CLAUSE));
END GETCHARTTYPE;

FUNCTION GETCHARTTYPE
(A_CY                      OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION                 OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION_IS_CURRENT      OUT      UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_EFFECTIVE_FROM          OUT      UNAPIGEN.DATE_TABLE_TYPE,  
 A_EFFECTIVE_TILL          OUT      UNAPIGEN.DATE_TABLE_TYPE,  
 A_DESCRIPTION             OUT      UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCRIPTION2            OUT      UNAPIGEN.VC40_TABLE_TYPE,  
 A_IS_TEMPLATE             OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_CHART_TITLE             OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_X_AXIS_TITLE            OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_Y_AXIS_TITLE            OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_Y_AXIS_UNIT             OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_X_LABEL                 OUT      UNAPIGEN.VC60_TABLE_TYPE,  
 A_DATAPOINT_CNT           OUT      UNAPIGEN.NUM_TABLE_TYPE,   
 A_DATAPOINT_UNIT          OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_XR_MEASUREMENTS         OUT      UNAPIGEN.NUM_TABLE_TYPE,   
 A_XR_MAX_CHARTS           OUT      UNAPIGEN.NUM_TABLE_TYPE,   
 A_ASSIGN_CF               OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_CY_CALC_CF              OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_VISUAL_CF               OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_VALID_SQC_RULE1         OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_VALID_SQC_RULE2         OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_VALID_SQC_RULE3         OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_VALID_SQC_RULE4         OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_VALID_SQC_RULE5         OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_VALID_SQC_RULE6         OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_VALID_SQC_RULE7         OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_CH_LC                   OUT      UNAPIGEN.VC2_TABLE_TYPE,   
 A_CH_LC_VERSION           OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_INHERIT_AU              OUT      UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_CY_CLASS                OUT      UNAPIGEN.VC2_TABLE_TYPE,   
 A_LOG_HS                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ALLOW_MODIFY            OUT      UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ACTIVE                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LC                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   
 A_LC_VERSION              OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_SS                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   
 A_NR_OF_ROWS              IN OUT   NUMBER,                    
 A_WHERE_CLAUSE            IN       VARCHAR2)                  
RETURN NUMBER IS
L_CY                       VARCHAR2(20);
L_VERSION                  VARCHAR2(20);
L_VERSION_IS_CURRENT       CHAR(1);
L_EFFECTIVE_FROM           TIMESTAMP WITH TIME ZONE;
L_EFFECTIVE_TILL           TIMESTAMP WITH TIME ZONE;
L_DESCRIPTION              VARCHAR2(40);
L_DESCRIPTION2             VARCHAR2(40);
L_IS_TEMPLATE              CHAR(1);
L_CHART_TITLE              VARCHAR2(255);
L_X_LABEL                  VARCHAR2(60);
L_DATAPOINT_CNT            NUMBER;
L_DATAPOINT_UNIT           VARCHAR2(20);
L_XR_MEASUREMENTS          NUMBER;
L_XR_MAX_CHARTS            NUMBER;
L_ASSIGN_CF                VARCHAR2(255);
L_VISUAL_CF                VARCHAR2(255);
L_VALID_SQC_RULE1          VARCHAR2(255);
L_VALID_SQC_RULE2          VARCHAR2(255);
L_VALID_SQC_RULE3          VARCHAR2(255);
L_VALID_SQC_RULE4          VARCHAR2(255);
L_VALID_SQC_RULE5          VARCHAR2(255);
L_VALID_SQC_RULE6          VARCHAR2(255);
L_VALID_SQC_RULE7          VARCHAR2(255);
L_CH_LC                    VARCHAR2(2);
L_CH_LC_VERSION            VARCHAR2(20);
L_INHERIT_AU               CHAR(1);
L_CY_CLASS                 VARCHAR2(2);
L_LOG_HS                   CHAR(1);
L_ALLOW_MODIFY             CHAR(1);
L_ACTIVE                   CHAR(1);
L_LC                       VARCHAR2(2);
L_LC_VERSION               VARCHAR2(20);
L_SS                       VARCHAR2(2);
L_CY_CALC_CF               VARCHAR2(255);
L_X_AXIS_TITLE             VARCHAR2(255);
L_Y_AXIS_TITLE             VARCHAR2(255);
L_Y_AXIS_UNIT              VARCHAR2(20);
L_CY_CURSOR                INTEGER;
BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY cy, version'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := 'WHERE version_is_current = ''1'' AND '||
                        'cy = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' ORDER BY cy, version';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_CY_CURSOR := DBMS_SQL.OPEN_CURSOR;

   L_SQL_STRING := 'SELECT cy, version, nvl(version_is_current,''0''), effective_from, effective_till, ' ||
      'description, description2, is_template, chart_title, x_label, datapoint_cnt, datapoint_unit, xr_measurements, ' ||
      'xr_max_charts, assign_cf, visual_cf, '||
      'valid_sqc_rule1, valid_sqc_rule2, valid_sqc_rule3, valid_sqc_rule4, valid_sqc_rule5, valid_sqc_rule6, valid_sqc_rule7, '||
      'ch_lc, ch_lc_version, inherit_au, cy_class, log_hs, allow_modify, ' ||
      'active, lc, lc_version, ss, cy_calc_cf, x_axis_title, y_axis_title, y_axis_unit' ||
      ' FROM dd' || UNAPIGEN.P_DD || '.uvcy ' || L_WHERE_CLAUSE;
   DBMS_SQL.PARSE(L_CY_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       1,   L_CY                ,  20   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       2,   L_VERSION           ,  20   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_CY_CURSOR,  3,   L_VERSION_IS_CURRENT,  1   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       4,   L_EFFECTIVE_FROM    );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       5,   L_EFFECTIVE_TILL    );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       6,   L_DESCRIPTION       ,  40   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       7,   L_DESCRIPTION2      ,  40   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_CY_CURSOR,  8,   L_IS_TEMPLATE       ,  1   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       9,   L_CHART_TITLE       ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       10,   L_X_LABEL          ,  60   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       11,   L_DATAPOINT_CNT    );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       12,   L_DATAPOINT_UNIT   ,  20   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       13,   L_XR_MEASUREMENTS  );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       14,   L_XR_MAX_CHARTS    );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       15,   L_ASSIGN_CF        ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       16,   L_VISUAL_CF        ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       17,   L_VALID_SQC_RULE1  ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       18,   L_VALID_SQC_RULE2  ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       19,   L_VALID_SQC_RULE3  ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       20,   L_VALID_SQC_RULE4  ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       21,   L_VALID_SQC_RULE5  ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       22,   L_VALID_SQC_RULE6  ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       23,   L_VALID_SQC_RULE7  ,  255   );   
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       24,   L_CH_LC            ,  2   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       25,   L_CH_LC_VERSION    ,  20   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_CY_CURSOR,  26,   L_INHERIT_AU       ,  1   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       27,   L_CY_CLASS         ,  2   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_CY_CURSOR,  28,   L_LOG_HS           ,  1   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_CY_CURSOR,  29,   L_ALLOW_MODIFY     ,  1   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_CY_CURSOR,  30,   L_ACTIVE           ,  1   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       31,   L_LC               ,  2   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       32,   L_LC_VERSION       ,  20   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       33,   L_SS               ,  2   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       34,   L_CY_CALC_CF       ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       35,   L_X_AXIS_TITLE     ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       36,   L_Y_AXIS_TITLE     ,  255   );
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR,       37,   L_Y_AXIS_UNIT      ,  20   );
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_CY_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      1,   L_CY                );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      2,   L_VERSION           );
      DBMS_SQL.COLUMN_VALUE_CHAR(L_CY_CURSOR, 3,   L_VERSION_IS_CURRENT);
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      4,   L_EFFECTIVE_FROM    );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      5,   L_EFFECTIVE_TILL    );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      6,   L_DESCRIPTION       );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      7,   L_DESCRIPTION2      );
      DBMS_SQL.COLUMN_VALUE_CHAR(L_CY_CURSOR, 8,   L_IS_TEMPLATE       );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      9,   L_CHART_TITLE       );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      10,  L_X_LABEL           );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      11,  L_DATAPOINT_CNT     );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      12,  L_DATAPOINT_UNIT    );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      13,  L_XR_MEASUREMENTS   );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      14,  L_XR_MAX_CHARTS     );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      15,  L_ASSIGN_CF         );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      16,  L_VISUAL_CF         );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      17,  L_VALID_SQC_RULE1   );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      18,  L_VALID_SQC_RULE2   );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      19,  L_VALID_SQC_RULE3   );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      20,  L_VALID_SQC_RULE4   );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      21,  L_VALID_SQC_RULE5   );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      22,  L_VALID_SQC_RULE6   );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      23,  L_VALID_SQC_RULE7   );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      24,  L_CH_LC             );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      25,  L_CH_LC_VERSION     );
      DBMS_SQL.COLUMN_VALUE_CHAR(L_CY_CURSOR, 26,  L_INHERIT_AU        );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      27,  L_CY_CLASS          );
      DBMS_SQL.COLUMN_VALUE_CHAR(L_CY_CURSOR, 28,  L_LOG_HS            );
      DBMS_SQL.COLUMN_VALUE_CHAR(L_CY_CURSOR, 29,  L_ALLOW_MODIFY      );
      DBMS_SQL.COLUMN_VALUE_CHAR(L_CY_CURSOR, 30,  L_ACTIVE            );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      31,  L_LC                );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      32,  L_LC_VERSION        );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      33,  L_SS                );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      34,  L_CY_CALC_CF        );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      35,  L_X_AXIS_TITLE      );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      36,  L_Y_AXIS_TITLE      );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR,      37,  L_Y_AXIS_UNIT       );
      
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      
      A_CY                  (L_FETCHED_ROWS) := L_CY ;
      A_VERSION             (L_FETCHED_ROWS) := L_VERSION ;
      A_VERSION_IS_CURRENT  (L_FETCHED_ROWS) := L_VERSION_IS_CURRENT ;
      A_EFFECTIVE_FROM      (L_FETCHED_ROWS) := L_EFFECTIVE_FROM ;
      A_EFFECTIVE_TILL      (L_FETCHED_ROWS) := L_EFFECTIVE_TILL ;
      A_DESCRIPTION         (L_FETCHED_ROWS) := L_DESCRIPTION ;
      A_DESCRIPTION2        (L_FETCHED_ROWS) := L_DESCRIPTION2 ;
      A_IS_TEMPLATE         (L_FETCHED_ROWS) := L_IS_TEMPLATE ;
      A_CHART_TITLE         (L_FETCHED_ROWS) := L_CHART_TITLE ;
      A_X_LABEL             (L_FETCHED_ROWS) := L_X_LABEL ;
      A_DATAPOINT_CNT       (L_FETCHED_ROWS) := L_DATAPOINT_CNT ;
      A_DATAPOINT_UNIT      (L_FETCHED_ROWS) := L_DATAPOINT_UNIT ;
      A_XR_MEASUREMENTS     (L_FETCHED_ROWS) := L_XR_MEASUREMENTS ;
      A_XR_MAX_CHARTS       (L_FETCHED_ROWS) := L_XR_MAX_CHARTS ;
      A_ASSIGN_CF           (L_FETCHED_ROWS) := L_ASSIGN_CF ;
      A_VISUAL_CF           (L_FETCHED_ROWS) := L_VISUAL_CF ;
      A_VALID_SQC_RULE1     (L_FETCHED_ROWS) := L_VALID_SQC_RULE1 ;
      A_VALID_SQC_RULE2     (L_FETCHED_ROWS) := L_VALID_SQC_RULE2 ;
      A_VALID_SQC_RULE3     (L_FETCHED_ROWS) := L_VALID_SQC_RULE3 ;
      A_VALID_SQC_RULE4     (L_FETCHED_ROWS) := L_VALID_SQC_RULE4 ;
      A_VALID_SQC_RULE5     (L_FETCHED_ROWS) := L_VALID_SQC_RULE5 ;
      A_VALID_SQC_RULE6     (L_FETCHED_ROWS) := L_VALID_SQC_RULE6 ;
      A_VALID_SQC_RULE7     (L_FETCHED_ROWS) := L_VALID_SQC_RULE7 ;      
      A_CH_LC               (L_FETCHED_ROWS) := L_CH_LC ;
      A_CH_LC_VERSION       (L_FETCHED_ROWS) := L_CH_LC_VERSION ;
      A_INHERIT_AU          (L_FETCHED_ROWS) := L_INHERIT_AU ;
      A_CY_CLASS            (L_FETCHED_ROWS) := L_CY_CLASS ;
      A_LOG_HS              (L_FETCHED_ROWS) := L_LOG_HS ;
      A_ALLOW_MODIFY        (L_FETCHED_ROWS) := L_ALLOW_MODIFY ;
      A_ACTIVE              (L_FETCHED_ROWS) := L_ACTIVE ;
      A_LC                  (L_FETCHED_ROWS) := L_LC ;
      A_LC_VERSION          (L_FETCHED_ROWS) := L_LC_VERSION ;
      A_SS                  (L_FETCHED_ROWS) := L_SS ;
      A_CY_CALC_CF          (L_FETCHED_ROWS) := L_CY_CALC_CF ;
      A_X_AXIS_TITLE        (L_FETCHED_ROWS) := L_X_AXIS_TITLE ;
      A_Y_AXIS_TITLE        (L_FETCHED_ROWS) := L_Y_AXIS_TITLE ;
      A_Y_AXIS_UNIT         (L_FETCHED_ROWS) := L_Y_AXIS_UNIT ;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_CY_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_CY_CURSOR);

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
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
              'GetChartType', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (L_CY_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_CY_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETCHARTTYPE;

FUNCTION GETCHARTTYPELIST
(A_CY                      OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION                 OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION_IS_CURRENT      OUT      UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_EFFECTIVE_FROM          OUT      UNAPIGEN.DATE_TABLE_TYPE,  
 A_EFFECTIVE_TILL          OUT      UNAPIGEN.DATE_TABLE_TYPE,  
 A_DESCRIPTION             OUT      UNAPIGEN.VC40_TABLE_TYPE,  
 A_SS                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   
 A_NR_OF_ROWS              IN OUT   NUMBER,                    
 A_WHERE_CLAUSE            IN       VARCHAR2,                  
 A_NEXT_ROWS               IN       NUMBER)                    
RETURN NUMBER
IS

L_CY                   VARCHAR2(20);
L_VERSION              VARCHAR2(20);
L_VERSION_IS_CURRENT   CHAR(1);
L_EFFECTIVE_FROM       TIMESTAMP WITH TIME ZONE;
L_EFFECTIVE_TILL       TIMESTAMP WITH TIME ZONE;
L_DESCRIPTION          VARCHAR2(40);
L_SS                   VARCHAR2(2);

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
      IF P_CY_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_CY_CURSOR);
         P_CY_CURSOR := NULL;
      END IF;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_CY_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN
      IF P_CY_CURSOR IS NULL THEN
         P_CY_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;

      IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
         L_WHERE_CLAUSE := 'WHERE active = ''1'' ORDER BY cy'; 
      ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
         L_WHERE_CLAUSE := 'WHERE cy = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') ||
                           ''' ORDER BY cy'; 
      ELSE
         L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
      END IF;
     
      L_SQL_STRING := 'SELECT cy, version, nvl(version_is_current,''0''), effective_from,' ||
                    'effective_till, description, ss '||
                      'FROM dd' || UNAPIGEN.P_DD || '.uvcy ' || L_WHERE_CLAUSE;
      DBMS_SQL.PARSE(P_CY_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

      DBMS_SQL.DEFINE_COLUMN(P_CY_CURSOR, 1, L_CY,           20);
      DBMS_SQL.DEFINE_COLUMN(P_CY_CURSOR, 2, L_VERSION,      20);      
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_CY_CURSOR, 3, L_VERSION_IS_CURRENT, 1);
      DBMS_SQL.DEFINE_COLUMN(P_CY_CURSOR, 4, L_EFFECTIVE_FROM);
      DBMS_SQL.DEFINE_COLUMN(P_CY_CURSOR, 5, L_EFFECTIVE_TILL);
      DBMS_SQL.DEFINE_COLUMN(P_CY_CURSOR, 6, L_DESCRIPTION,  40);
      DBMS_SQL.DEFINE_COLUMN(P_CY_CURSOR, 7, L_SS,            2);

      L_RESULT := DBMS_SQL.EXECUTE(P_CY_CURSOR);
   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(P_CY_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(P_CY_CURSOR, 1, L_CY);
      DBMS_SQL.COLUMN_VALUE(P_CY_CURSOR, 2, L_VERSION);   
      DBMS_SQL.COLUMN_VALUE_CHAR(P_CY_CURSOR, 3, L_VERSION_IS_CURRENT);
      DBMS_SQL.COLUMN_VALUE(P_CY_CURSOR, 4, L_EFFECTIVE_FROM);
      DBMS_SQL.COLUMN_VALUE(P_CY_CURSOR, 5, L_EFFECTIVE_TILL);    
      DBMS_SQL.COLUMN_VALUE(P_CY_CURSOR, 6, L_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(P_CY_CURSOR, 7, L_SS);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_CY                (L_FETCHED_ROWS)   := L_CY;
      A_VERSION           (L_FETCHED_ROWS)   := L_VERSION;  
      A_VERSION_IS_CURRENT(L_FETCHED_ROWS)   := L_VERSION_IS_CURRENT;     
      A_EFFECTIVE_FROM    (L_FETCHED_ROWS)   := L_EFFECTIVE_FROM; 
      A_EFFECTIVE_TILL    (L_FETCHED_ROWS)   := L_EFFECTIVE_TILL;
      A_DESCRIPTION       (L_FETCHED_ROWS)   := L_DESCRIPTION;
      A_SS                (L_FETCHED_ROWS)   := L_SS;      

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_CY_CURSOR);
      END IF;
   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
       DBMS_SQL.CLOSE_CURSOR(P_CY_CURSOR);
       P_CY_CURSOR := NULL;
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   END IF;

   IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_CY_CURSOR);
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
              'GetChartTypeList', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_CY_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_CY_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETCHARTTYPELIST;

FUNCTION GETCYSTYLE
(A_VISUAL_CF             OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_CY                    OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION               OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_PROP_NAME             OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_PROP_VALUE            OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_NR_OF_ROWS            IN OUT   NUMBER,                    
 A_WHERE_CLAUSE          IN       VARCHAR2)                  
RETURN NUMBER IS
   L_VISUAL_CF         VARCHAR2(255);
   L_CY                VARCHAR2(20);
   L_VERSION           VARCHAR2(20);
   L_PROP_NAME         VARCHAR2(20);
   L_PROP_VALUE        VARCHAR2(255);
   L_CY_CURSOR         INTEGER;
BEGIN
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;
 
   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;
 
   L_CY_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'SELECT a.visual_cf, a.cy, a.version, a.prop_name, a.prop_value ' ||
                   'FROM dd'|| UNAPIGEN.P_DD ||'.uvcystyle a '|| L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_CY_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR, 1, L_VISUAL_CF,   255);
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR, 2, L_CY,           20);
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR, 3, L_VERSION,      20);
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR, 4, L_PROP_NAME,    20);
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR, 5, L_PROP_VALUE,  255);
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_CY_CURSOR);
   L_FETCHED_ROWS := 0;
 
   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
 
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR, 1, L_VISUAL_CF );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR, 2, L_CY        );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR, 3, L_VERSION   );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR, 4, L_PROP_NAME );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR, 5, L_PROP_VALUE);
 
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_VISUAL_CF(L_FETCHED_ROWS)  := L_VISUAL_CF;
      A_CY(L_FETCHED_ROWS)         := L_CY;
      A_VERSION(L_FETCHED_ROWS)    := L_VERSION;
      A_PROP_NAME(L_FETCHED_ROWS)  := L_PROP_NAME;
      A_PROP_VALUE(L_FETCHED_ROWS) := L_PROP_VALUE;
  
      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_CY_CURSOR);
      END IF;
   END LOOP;
 
   DBMS_SQL.CLOSE_CURSOR(L_CY_CURSOR);

   IF L_FETCHED_ROWS = 0 THEN
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
     VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'GetCyStyle', L_SQLERRM);
     UNAPIGEN.U4COMMIT;
     IF DBMS_SQL.IS_OPEN (L_CY_CURSOR) THEN
        DBMS_SQL.CLOSE_CURSOR (L_CY_CURSOR);
     END IF;
     RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETCYSTYLE;

FUNCTION SAVECYSTYLE
(A_VISUAL_CF              IN    VARCHAR2,                       
 A_CY                     IN    VARCHAR2,                       
 A_VERSION                IN    VARCHAR2,                     
 A_PROP_NAME              IN    UNAPIGEN.VC20_TABLE_TYPE,     
 A_PROP_VALUE             IN    UNAPIGEN.VC255_TABLE_TYPE,    
 A_NR_OF_ROWS             IN    NUMBER,                       
 A_MODIFY_REASON          IN    VARCHAR2)                     
RETURN NUMBER IS
   L_ALLOW_MODIFY CHAR(1);
   L_LOG_HS       CHAR(1);
   L_ACTIVE       CHAR(1);
   L_LC           VARCHAR2(2);
   L_LC_VERSION   VARCHAR2(20);
   L_SS           VARCHAR2(2);
BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF (NVL(A_VISUAL_CF, ' ') = ' ') OR
      (NVL(A_CY       , ' ') = ' ') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF (NVL(A_VERSION, ' ') = ' ') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;




















   DELETE FROM UTCYSTYLE
   WHERE VISUAL_CF = A_VISUAL_CF
     AND CY        = A_CY
     AND VERSION   = A_VERSION;

   
   FOR I IN 1..A_NR_OF_ROWS LOOP
      INSERT INTO UTCYSTYLE(VISUAL_CF, CY, VERSION, SEQ, PROP_NAME, PROP_VALUE)
      VALUES(A_VISUAL_CF, A_CY, A_VERSION, I, A_PROP_NAME(I), A_PROP_VALUE(I));
   END LOOP;























   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveCyStyle', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveCyStyle'));
END SAVECYSTYLE;

FUNCTION GETCYSTYLELIST
(A_VISUAL_CF             OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_CY                    OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION               OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_PROP_NAME             OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_PROP_VALUE            OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_NR_OF_ROWS            IN OUT   NUMBER,                    
 A_WHERE_CLAUSE          IN       VARCHAR2)                  
RETURN NUMBER IS
   L_VISUAL_CF         VARCHAR2(255);
   L_CY                VARCHAR2(20);
   L_VERSION           VARCHAR2(20);
   L_PROP_NAME         VARCHAR2(20);
   L_PROP_VALUE        VARCHAR2(255);
   L_CY_CURSOR         INTEGER;
BEGIN
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;
 
   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;
 
   L_CY_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'SELECT a.visual_cf, a.cy, a.version, a.prop_name, a.prop_value ' ||
                   'FROM dd'|| UNAPIGEN.P_DD ||'.uvcystylelist a '|| L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_CY_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR, 1, L_VISUAL_CF,   255);
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR, 2, L_CY,           20);
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR, 3, L_VERSION,      20);
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR, 4, L_PROP_NAME,    20);
   DBMS_SQL.DEFINE_COLUMN(L_CY_CURSOR, 5, L_PROP_VALUE,  255);
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_CY_CURSOR);
   L_FETCHED_ROWS := 0;
 
   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
 
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR, 1, L_VISUAL_CF );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR, 2, L_CY        );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR, 3, L_VERSION   );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR, 4, L_PROP_NAME );
      DBMS_SQL.COLUMN_VALUE(L_CY_CURSOR, 5, L_PROP_VALUE);
 
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_VISUAL_CF(L_FETCHED_ROWS)  := L_VISUAL_CF;
      A_CY(L_FETCHED_ROWS)         := L_CY;
      A_VERSION(L_FETCHED_ROWS)    := L_VERSION;
      A_PROP_NAME(L_FETCHED_ROWS)  := L_PROP_NAME;
      A_PROP_VALUE(L_FETCHED_ROWS) := L_PROP_VALUE;
  
      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_CY_CURSOR);
      END IF;
   END LOOP;
 
   DBMS_SQL.CLOSE_CURSOR(L_CY_CURSOR);

   IF L_FETCHED_ROWS = 0 THEN
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
     VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'GetCyStyleList', L_SQLERRM);
     UNAPIGEN.U4COMMIT;
     IF DBMS_SQL.IS_OPEN (L_CY_CURSOR) THEN
        DBMS_SQL.CLOSE_CURSOR (L_CY_CURSOR);
     END IF;
     RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETCYSTYLELIST;

FUNCTION SAVECYSTYLELIST
(A_VISUAL_CF              IN    VARCHAR2,                       
 A_CY                     IN    VARCHAR2,                       
 A_VERSION                IN    VARCHAR2,                     
 A_PROP_NAME              IN    UNAPIGEN.VC20_TABLE_TYPE,     
 A_PROP_VALUE             IN    UNAPIGEN.VC255_TABLE_TYPE,    
 A_NR_OF_ROWS             IN    NUMBER,                       
 A_MODIFY_REASON          IN    VARCHAR2)                     
RETURN NUMBER IS
   L_ALLOW_MODIFY CHAR(1);
   L_LOG_HS       CHAR(1);
   L_ACTIVE       CHAR(1);
   L_LC           VARCHAR2(2);
   L_LC_VERSION   VARCHAR2(20);
   L_SS           VARCHAR2(2);
BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF (NVL(A_VISUAL_CF, ' ') = ' ') OR
      (NVL(A_CY       , ' ') = ' ') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF (NVL(A_VERSION, ' ') = ' ') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;




















   DELETE FROM UTCYSTYLELIST
   WHERE VISUAL_CF = A_VISUAL_CF
     AND CY        = A_CY
     AND VERSION   = A_VERSION;

   
   FOR I IN 1..A_NR_OF_ROWS LOOP
      INSERT INTO UTCYSTYLELIST(VISUAL_CF, CY, VERSION, SEQ, PROP_NAME, PROP_VALUE)
      VALUES(A_VISUAL_CF, A_CY, A_VERSION, I, A_PROP_NAME(I), A_PROP_VALUE(I));
   END LOOP;























   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveCyStyleList', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveCyStyleList'));
END SAVECYSTYLELIST;

END UNAPICY;