create or replace PACKAGE BODY unapiaut AS

L_SQLERRM               VARCHAR2(255);
L_SQL_STRING            VARCHAR2(2000);
L_WHERE_CLAUSE          VARCHAR2(1000);
L_EVENT_TP              UTEV.EV_TP%TYPE;
L_RET_CODE              NUMBER;
L_RESULT                NUMBER;
L_FETCHED_ROWS          NUMBER;
L_EV_SEQ_NR             NUMBER;
STPERROR                EXCEPTION;
L_NO_ALLOW_MODIFY_CHECK BOOLEAN;
L_NO_AR_CHECK           BOOLEAN;

CURSOR C_SYSTEM (A_SETTING_NAME VARCHAR2) IS
   SELECT SETTING_VALUE
   FROM UTSYSTEM
   WHERE SETTING_NAME = A_SETTING_NAME;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION GETSDAUTHORISATION                 
(A_SD             IN        VARCHAR2,       
 A_PT_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_PT_VERSION     VARCHAR2(20);
L_LC             VARCHAR2(2);
L_LC_VERSION     VARCHAR2(20);
L_SS             VARCHAR2(2);
L_ALLOW_MODIFY   CHAR(1);
L_ACTIVE         CHAR(1);
L_LOG_HS         CHAR(1);
L_LOG_HS_DETAILS CHAR(1);
L_AR_VAL         CHAR(1);
L_SEQ_NO         NUMBER;
L_RETRIES        INTEGER;

BEGIN
   P_NOT_AUTHORISED := NULL;
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'sd' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = A_SD THEN
         A_PT_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;         
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;
   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'sd';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := A_SD;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT PT_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS, 
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_PT_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDSD 
         WHERE SD = A_SD;

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;
      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'sd NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'sd IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetSdAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetSdAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'sd READONLY:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'sd NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR) := L_PT_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 

      A_PT_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR);
      A_OBJECT_NR       := UNAPIGEN.PA_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      
      
      UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;

      
      SELECT DEF_LC, LOG_HS, LOG_HS_DETAILS
      INTO L_LC, L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'sd';

      BEGIN
         SELECT VERSION
         INTO L_LC_VERSION
         FROM UTLC
         WHERE LC = L_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (UNAPIGEN.DBERR_NOCURRENTLCVERSION);
      END;

      IF NVL(A_PT_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_PTVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR) := A_PT_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 

      A_PT_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR);
      A_ALLOW_MODIFY   := '#';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR);
      A_OBJECT_NR      := UNAPIGEN.PA_OBJECT_NR;
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR));
      END IF;
   END;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetSdAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetSdAuthorisation'));
END GETSDAUTHORISATION;

FUNCTION GETSDAUTHORISATION                 
(A_SD             IN        VARCHAR2,       
 A_PT_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETSDAUTHORISATION(A_SD, A_PT_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETSDAUTHORISATION;

FUNCTION GETRQAUTHORISATION                 
(A_RQ             IN        VARCHAR2,       
 A_RT_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_RT_VERSION     VARCHAR2(20);
L_LC             VARCHAR2(2);
L_LC_VERSION     VARCHAR2(20);
L_SS             VARCHAR2(2);
L_ALLOW_MODIFY   CHAR(1);
L_ACTIVE         CHAR(1);
L_LOG_HS         CHAR(1);
L_LOG_HS_DETAILS CHAR(1);
L_AR_VAL         CHAR(1);
L_SEQ_NO         NUMBER;
L_RETRIES        INTEGER;

BEGIN
   P_NOT_AUTHORISED := NULL;
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'rq' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = A_RQ THEN
         A_RT_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;
   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'rq';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := A_RQ;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT RT_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS, 
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_RT_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDRQ
         WHERE RQ = A_RQ;

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;
   
      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'rq NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'rq IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetRqAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetRqAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'rq READONLY:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'rq NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR) := L_RT_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 

      A_RT_VERSION      := UNAPIGEN.PA_OBJECT_VERSION         (UNAPIGEN.PA_OBJECT_NR);
      A_LC              := UNAPIGEN.PA_OBJECT_LC              (UNAPIGEN.PA_OBJECT_NR);
      A_LC_VERSION      := UNAPIGEN.PA_OBJECT_LC_VERSION      (UNAPIGEN.PA_OBJECT_NR);
      A_SS              := UNAPIGEN.PA_OBJECT_SS              (UNAPIGEN.PA_OBJECT_NR);
      A_ALLOW_MODIFY    := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY    (UNAPIGEN.PA_OBJECT_NR);
      A_ACTIVE          := UNAPIGEN.PA_OBJECT_ACTIVE          (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS          := UNAPIGEN.PA_OBJECT_LOG_HS          (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS_DETAILS  := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (UNAPIGEN.PA_OBJECT_NR);
      A_OBJECT_NR       := UNAPIGEN.PA_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      
      
      UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;

      
      SELECT DEF_LC, LOG_HS, LOG_HS_DETAILS
      INTO L_LC, L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'rq';

      BEGIN
         SELECT VERSION
         INTO L_LC_VERSION
         FROM UTLC
         WHERE LC = L_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (UNAPIGEN.DBERR_NOCURRENTLCVERSION);
      END;
      
      IF NVL(A_RT_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_RTVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR) := A_RT_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 

      A_RT_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (UNAPIGEN.PA_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC              (UNAPIGEN.PA_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (UNAPIGEN.PA_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS              (UNAPIGEN.PA_OBJECT_NR);
      A_ALLOW_MODIFY   := '#';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (UNAPIGEN.PA_OBJECT_NR);
      A_OBJECT_NR      := UNAPIGEN.PA_OBJECT_NR;

      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetRqAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetRqAuthorisation'));
END GETRQAUTHORISATION;

FUNCTION GETRQAUTHORISATION                 
(A_RQ             IN        VARCHAR2,       
 A_RT_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETRQAUTHORISATION(A_RQ, A_RT_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETRQAUTHORISATION;

FUNCTION GETSCAUTHORISATION                 
(A_SC             IN        VARCHAR2,       
 A_ST_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_ST_VERSION              VARCHAR2(20);
L_RT_VERSION_TMP          VARCHAR2(20);
L_PT_VERSION_TMP          VARCHAR2(20);
L_LC                      VARCHAR2(2);
L_LC_TMP                  VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_LC_VERSION_TMP          VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_SS_TMP                  VARCHAR2(2);
L_ALLOW_MODIFY            CHAR(1);
L_ALLOW_MODIFY_TMP        CHAR(1);
L_ACTIVE                  CHAR(1);
L_ACTIVE_TMP              CHAR(1);
L_LOG_HS                  CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_LOG_HS_TMP              CHAR(1);
L_LOG_HS_DETAILS_TMP      CHAR(1);
L_AR_VAL                  CHAR(1);
L_RQ                      VARCHAR2(20);
L_SD                      VARCHAR2(20);
L_SEQ_NO                  NUMBER;
L_OLD_OBJECT_NR           NUMBER;
L_RETRIES                 INTEGER;
L_RETRIESWHENINTRANSITION INTEGER;
L_AUTHORISATION           INTEGER;
L_RQAUTHORISATION_OK      BOOLEAN;
L_PARENT1_NR              INTEGER;
L_PARENT2_NR              INTEGER;

BEGIN

   P_NOT_AUTHORISED := NULL;
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'sc' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = A_SC THEN
         A_ST_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'sc';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := A_SC;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT ST_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS, 
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR, 
                RQ, SD
         INTO L_ST_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL, L_RQ, L_SD
         FROM UDSC
         WHERE SC = A_SC;

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            IF L_RQ IS NOT NULL OR
               L_SD IS NOT NULL THEN
               L_RQAUTHORISATION_OK := TRUE;
               IF L_RQ IS NOT NULL THEN
                  L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
                  UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
                  L_AUTHORISATION := GETRQAUTHORISATION (L_RQ, L_RT_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                                         L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, 
                                                         L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP,
                                                         L_PARENT1_NR);
                  UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
                  IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
                     (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
                     
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
                  ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
                     IF P_CASCADE_READONLY = 'YES' THEN
                        UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        L_RQAUTHORISATION_OK := FALSE;
                     ELSE
                        
                        
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
                           
                           
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;                  
                        ELSE
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                           L_RQAUTHORISATION_OK := FALSE;
                        END IF;
                     END IF ;
                  ELSE                    
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                     L_RQAUTHORISATION_OK := FALSE;
                  END IF;
               END IF;
               
               IF L_SD IS NOT NULL AND L_RQAUTHORISATION_OK THEN
                  L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
                  UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
                  L_AUTHORISATION := GETSDAUTHORISATION (L_SD, L_PT_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                                         L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, 
                                                         L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP,
                                                         L_PARENT2_NR);
                  UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
                  IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
                     (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
                     
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
                  ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
                     IF P_CASCADE_READONLY = 'YES' THEN
                        UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                     ELSE
                        
                        
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT2_NR) <> '0' THEN
                           
                           
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;                  
                        ELSE
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        END IF;
                     END IF ;
                  ELSE
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF;
            ELSE
               
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            END IF;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'sc NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'sc IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetScAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'sc READONLY:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'sc NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR)       := L_ST_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR)       := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR)       := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR)       := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR)       := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR)       := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR)       := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR)       := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR)       := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR)       := NVL(L_PARENT2_NR,-1); 

      A_ST_VERSION      := UNAPIGEN.PA_OBJECT_VERSION         (L_OLD_OBJECT_NR);
      A_LC              := UNAPIGEN.PA_OBJECT_LC              (L_OLD_OBJECT_NR);
      A_LC_VERSION      := UNAPIGEN.PA_OBJECT_LC_VERSION      (L_OLD_OBJECT_NR);
      A_SS              := UNAPIGEN.PA_OBJECT_SS              (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY    := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY    (L_OLD_OBJECT_NR);
      A_ACTIVE          := UNAPIGEN.PA_OBJECT_ACTIVE          (L_OLD_OBJECT_NR);
      A_LOG_HS          := UNAPIGEN.PA_OBJECT_LOG_HS          (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS  := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (L_OLD_OBJECT_NR);
      A_OBJECT_NR       := L_OLD_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      
      
      UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;

      
      SELECT DEF_LC, LOG_HS, LOG_HS_DETAILS
      INTO L_LC, L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'sc';

      BEGIN
         SELECT VERSION
         INTO L_LC_VERSION
         FROM UTLC
         WHERE LC = L_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (UNAPIGEN.DBERR_NOCURRENTLCVERSION);
      END;

      IF NVL(A_ST_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_STVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR) := A_ST_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS_DETAILS;
      
      
      
      
      
      
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 

      A_ST_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (UNAPIGEN.PA_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC              (UNAPIGEN.PA_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (UNAPIGEN.PA_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS              (UNAPIGEN.PA_OBJECT_NR);
      A_ALLOW_MODIFY   := '#';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (UNAPIGEN.PA_OBJECT_NR);
      A_OBJECT_NR       := UNAPIGEN.PA_OBJECT_NR;
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetScAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScAuthorisation'));
END GETSCAUTHORISATION;

FUNCTION GETSCAUTHORISATION                 
(A_SC             IN        VARCHAR2,       
 A_ST_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETSCAUTHORISATION(A_SC, A_ST_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETSCAUTHORISATION;

FUNCTION GETWSAUTHORISATION                 
(A_WS             IN        VARCHAR2,       
 A_WT_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_WT_VERSION     VARCHAR2(20);
L_LC             VARCHAR2(2);
L_LC_VERSION     VARCHAR2(20);
L_SS             VARCHAR2(2);
L_ALLOW_MODIFY   CHAR(1);
L_ACTIVE         CHAR(1);
L_LOG_HS         CHAR(1);
L_LOG_HS_DETAILS CHAR(1);
L_AR_VAL         CHAR(1);
L_SEQ_NO         NUMBER;
L_RETRIES        INTEGER;

BEGIN

   P_NOT_AUTHORISED := NULL;
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'ws' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = A_WS THEN
         A_WT_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;         
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'ws';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := A_WS;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT WT_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS, 
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_WT_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDWS 
         WHERE WS = A_WS;

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;

      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'ws NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'ws IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetWsAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetWsAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'ws READONLY:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'ws NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR) := L_WT_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 

      A_WT_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR);
      A_OBJECT_NR      := UNAPIGEN.PA_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      
      
      UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;

      
      SELECT DEF_LC, LOG_HS, LOG_HS_DETAILS
      INTO L_LC, L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'ws';

      BEGIN
         SELECT VERSION
         INTO L_LC_VERSION
         FROM UTLC
         WHERE LC = L_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (UNAPIGEN.DBERR_NOCURRENTLCVERSION);
      END;

      IF NVL(A_WT_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_WTVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR) := A_WT_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 

      A_WT_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR);
      A_ALLOW_MODIFY   := '#';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR);
      A_OBJECT_NR      := UNAPIGEN.PA_OBJECT_NR;
      
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetWsAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetWsAuthorisation'));
END GETWSAUTHORISATION;

FUNCTION GETWSAUTHORISATION                 
(A_WS             IN        VARCHAR2,       
 A_WT_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETWSAUTHORISATION(A_WS, A_WT_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETWSAUTHORISATION;

FUNCTION GETCHAUTHORISATION                 
(A_CH             IN        VARCHAR2,       
 A_CY_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_CY_VERSION     VARCHAR2(20);
L_LC             VARCHAR2(2);
L_LC_VERSION     VARCHAR2(20);
L_SS             VARCHAR2(2);
L_ALLOW_MODIFY   CHAR(1);
L_ACTIVE         CHAR(1);
L_LOG_HS         CHAR(1);
L_LOG_HS_DETAILS CHAR(1);
L_AR_VAL         CHAR(1);
L_SEQ_NO         NUMBER;
L_RETRIES        INTEGER;

BEGIN
   P_NOT_AUTHORISED := NULL;
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'ch' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = A_CH THEN
         A_CY_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;         
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;
   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'ch';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := A_CH;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT CY_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS, 
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_CY_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDCH 
         WHERE CH = A_CH;

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;
      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'ch NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'ch IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetchAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetchAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'ch READONLY:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'ch NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR) := L_CY_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 

      A_CY_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR);
      A_OBJECT_NR      := UNAPIGEN.PA_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      
      
      UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;

      
      SELECT DEF_LC, LOG_HS, LOG_HS_DETAILS
      INTO L_LC, L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'ch';

      BEGIN
         SELECT VERSION
         INTO L_LC_VERSION
         FROM UTLC
         WHERE LC = L_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (UNAPIGEN.DBERR_NOCURRENTLCVERSION);
      END;

      IF NVL(A_CY_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_CYVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR) := A_CY_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (UNAPIGEN.PA_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (UNAPIGEN.PA_OBJECT_NR) := -1; 

      A_CY_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (UNAPIGEN.PA_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (UNAPIGEN.PA_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (UNAPIGEN.PA_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (UNAPIGEN.PA_OBJECT_NR);
      A_ALLOW_MODIFY   := '#';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(UNAPIGEN.PA_OBJECT_NR);
      A_OBJECT_NR      := UNAPIGEN.PA_OBJECT_NR;
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR));
      END IF;
   END;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetChAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetChAuthorisation'));
END GETCHAUTHORISATION;

FUNCTION GETCHAUTHORISATION                 
(A_CH             IN        VARCHAR2,       
 A_CY_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETCHAUTHORISATION(A_CH, A_CY_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETCHAUTHORISATION;

FUNCTION GETSCICAUTHORISATION               
(A_SC             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_IP_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_IP_VERSION              VARCHAR2(20);
L_ST_VERSION_TMP          VARCHAR2(20);
L_LC                      VARCHAR2(2);
L_LC_TMP                  VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_LC_VERSION_TMP          VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_SS_TMP                  VARCHAR2(2);
L_ALLOW_MODIFY            CHAR(1);
L_ALLOW_MODIFY_TMP        CHAR(1);
L_ACTIVE                  CHAR(1);
L_ACTIVE_TMP              CHAR(1);
L_LOG_HS                  CHAR(1);
L_LOG_HS_TMP              CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_LOG_HS_DETAILS_TMP      CHAR(1);
L_AR_VAL                  CHAR(1);
L_AR_VAL_TMP              CHAR(1);
L_OLD_OBJECT_NR           NUMBER;
L_SEQ_NO                  NUMBER;
L_OBJECT_ID               VARCHAR2(255);
L_RETRIES                 INTEGER;
L_RETRIESWHENINTRANSITION INTEGER;
L_AUTHORISATION           INTEGER;
L_PARENT1_NR              INTEGER;
L_PARENT2_NR              INTEGER;

BEGIN

   P_NOT_AUTHORISED := NULL;
   L_OBJECT_ID := A_SC || A_IC || TO_CHAR(A_ICNODE);
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'ic' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = L_OBJECT_ID THEN
         A_IP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'ic';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := L_OBJECT_ID;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT IP_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS, 
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_IP_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDSCIC 
         WHERE SC     = A_SC
           AND IC     = A_IC
           AND ICNODE = A_ICNODE;

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
            UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
            L_AUTHORISATION := GETSCAUTHORISATION (A_SC, L_ST_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                                   L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, 
                                                   L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
            UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
            IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
               (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
               IF P_CASCADE_READONLY = 'YES' THEN
                  UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
               ELSE
                  
                  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
                     
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;                  
                     
                     IF UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR) <> -1 THEN  
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR)) <> '0' THEN
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        END IF;
                     END IF;
                     IF UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENT1_NR) <> -1 THEN 
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENT1_NR)) <> '0' THEN
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        END IF;
                     END IF;
                  ELSE
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF;
            ELSE
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'scic NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'scic IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetScIcAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScIcAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         
         L_AUTHORISATION := GETSCAUTHORISATION (A_SC, L_ST_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                                L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, 
                                                L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'scic READONLY:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'scic NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := L_IP_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR       := L_OLD_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
      UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
      L_AUTHORISATION := GETSCAUTHORISATION (A_SC, L_ST_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                             L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, L_LOG_HS_TMP, 
                                             L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
      UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
      IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
         (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
         
         
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
      ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
         IF P_CASCADE_READONLY = 'YES' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         ELSE
            
            
            IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;                  
               
               IF UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR) <> -1 THEN  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR)) <> '0' THEN
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF;
               IF UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENT1_NR) <> -1 THEN 
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENT1_NR)) <> '0' THEN
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         END IF;
      ELSE
         
         UNAPIGEN.PA_OBJECT_TP(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR)       := '';
         UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR)       := '';
         UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR)       := '';
         UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR)       := '';
         UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR)       := '';
         UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR)       := '';
         UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR)       := '';
         UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR)       := '';
         UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR)       := NVL(L_PARENT1_NR,-1); 
         UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR)       := NVL(L_PARENT2_NR,-1); 
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));      
      END IF;

      
      SELECT DEF_LC, LOG_HS, LOG_HS_DETAILS
      INTO L_LC, L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'ic';

      BEGIN
         SELECT VERSION
         INTO L_LC_VERSION
         FROM UTLC
         WHERE LC = L_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (UNAPIGEN.DBERR_NOCURRENTLCVERSION);
      END;

      IF NVL(A_IP_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_IPVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := A_IP_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := '#';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR       := L_OLD_OBJECT_NR;
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetScIcAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScIcAuthorisation'));
END GETSCICAUTHORISATION;

FUNCTION GETSCICAUTHORISATION               
(A_SC             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_IP_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETSCICAUTHORISATION(A_SC, A_IC, A_ICNODE, A_IP_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETSCICAUTHORISATION;

FUNCTION GETRQICAUTHORISATION               
(A_RQ             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_IP_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_IP_VERSION              VARCHAR2(20);
L_RT_VERSION_TMP          VARCHAR2(20);
L_LC                      VARCHAR2(2);
L_LC_TMP                  VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_LC_VERSION_TMP          VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_SS_TMP                  VARCHAR2(2);
L_ALLOW_MODIFY            CHAR(1);
L_ALLOW_MODIFY_TMP        CHAR(1);
L_ACTIVE                  CHAR(1);
L_ACTIVE_TMP              CHAR(1);
L_LOG_HS                  CHAR(1);
L_LOG_HS_TMP              CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_LOG_HS_DETAILS_TMP      CHAR(1);
L_AR_VAL                  CHAR(1);
L_AR_VAL_TMP              CHAR(1);
L_OLD_OBJECT_NR           NUMBER;
L_SEQ_NO                  NUMBER;
L_OBJECT_ID               VARCHAR2(255);
L_RETRIES                 INTEGER;
L_RETRIESWHENINTRANSITION INTEGER;
L_AUTHORISATION           INTEGER;
L_PARENT1_NR              INTEGER;
L_PARENT2_NR              INTEGER;

BEGIN

   P_NOT_AUTHORISED := NULL;
   L_OBJECT_ID := A_RQ || A_IC || TO_CHAR(A_ICNODE);
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'ic' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = L_OBJECT_ID THEN
         A_IP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'ic';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := L_OBJECT_ID;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT IP_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS,
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_IP_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDRQIC
         WHERE RQ     = A_RQ
           AND IC     = A_IC
           AND ICNODE = A_ICNODE;

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
            UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
            L_AUTHORISATION := GETRQAUTHORISATION(A_RQ, L_RT_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                                  L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, 
                                                  L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
            UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
            IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
               (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
               IF P_CASCADE_READONLY = 'YES' THEN
                  UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
               ELSE
                  
                  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
                     
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;                  
                  ELSE
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF ;
            ELSE
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'rqic NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'rqic IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetRqIcAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetRqIcAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         
         L_AUTHORISATION := GETRQAUTHORISATION(A_RQ, L_RT_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                                  L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, 
                                                  L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'rqic READONLY:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'rqic NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := L_IP_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC              (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS              (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY    (L_OLD_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;      
      UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
      L_AUTHORISATION := GETRQAUTHORISATION(A_RQ, L_RT_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                            L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, L_LOG_HS_TMP, 
                                            L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
      UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
      IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
         (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
         
         
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
      ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
         IF P_CASCADE_READONLY = 'YES' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         ELSE
            
            
            IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;                  
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         END IF;
      ELSE
         
         UNAPIGEN.PA_OBJECT_TP(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
         UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));      
      END IF;

      
      SELECT DEF_LC, LOG_HS, LOG_HS_DETAILS
      INTO L_LC, L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'rqic';

      BEGIN
         SELECT VERSION
         INTO L_LC_VERSION
         FROM UTLC
         WHERE LC = L_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (UNAPIGEN.DBERR_NOCURRENTLCVERSION);
      END;

      IF NVL(A_IP_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_IPVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := A_IP_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := '#';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR       := L_OLD_OBJECT_NR;
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetRqIcAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetRqIcAuthorisation'));
END GETRQICAUTHORISATION;

FUNCTION GETRQICAUTHORISATION               
(A_RQ             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_IP_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETRQICAUTHORISATION(A_RQ, A_IC, A_ICNODE, A_IP_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETRQICAUTHORISATION;

FUNCTION GETSDICAUTHORISATION               
(A_SD             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_IP_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_IP_VERSION              VARCHAR2(20);
L_PT_VERSION_TMP          VARCHAR2(20);
L_LC                      VARCHAR2(2);
L_LC_TMP                  VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_LC_VERSION_TMP          VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_SS_TMP                  VARCHAR2(2);
L_ALLOW_MODIFY            CHAR(1);
L_ALLOW_MODIFY_TMP        CHAR(1);
L_ACTIVE                  CHAR(1);
L_ACTIVE_TMP              CHAR(1);
L_LOG_HS                  CHAR(1);
L_LOG_HS_TMP              CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_LOG_HS_DETAILS_TMP      CHAR(1);
L_AR_VAL                  CHAR(1);
L_AR_VAL_TMP              CHAR(1);
L_OLD_OBJECT_NR           NUMBER;
L_SEQ_NO                  NUMBER;
L_OBJECT_ID               VARCHAR2(255);
L_RETRIES                 INTEGER;
L_RETRIESWHENINTRANSITION INTEGER;
L_AUTHORISATION           INTEGER;
L_PARENT1_NR              INTEGER;
L_PARENT2_NR              INTEGER;

BEGIN

   P_NOT_AUTHORISED := NULL;
   L_OBJECT_ID := A_SD || A_IC || TO_CHAR(A_ICNODE);
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'ic' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = L_OBJECT_ID THEN
         A_IP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'ic';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := L_OBJECT_ID;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT IP_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS,
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_IP_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDSDIC
         WHERE SD     = A_SD
           AND IC     = A_IC
           AND ICNODE = A_ICNODE;

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
            UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
            L_AUTHORISATION := GETSDAUTHORISATION(A_SD, L_PT_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                                  L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, 
                                                  L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
            UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
            IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
               (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
               IF P_CASCADE_READONLY = 'YES' THEN
                  UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
               ELSE
                  
                  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
                     
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;                  
                  ELSE
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF ;
            ELSE
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'sdic NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'sdic IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetSdIcAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetSdIcAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         
         L_AUTHORISATION := GETSDAUTHORISATION(A_SD, L_PT_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                               L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, 
                                               L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'sdic READONLY:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'SDIC NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := L_IP_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC              (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS              (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY    (L_OLD_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;      
      UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
      L_AUTHORISATION := GETSDAUTHORISATION(A_SD, L_PT_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                            L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, L_LOG_HS_TMP, 
                                            L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
      UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
      IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
         (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
         
         
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
      ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
         IF P_CASCADE_READONLY = 'YES' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         ELSE
            
            
            IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;                  
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         END IF;
      ELSE
         
         UNAPIGEN.PA_OBJECT_TP(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
         UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));      
      END IF;

      
      SELECT DEF_LC, LOG_HS, LOG_HS_DETAILS
      INTO L_LC, L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'sdic';

      BEGIN
         SELECT VERSION
         INTO L_LC_VERSION
         FROM UTLC
         WHERE LC = L_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (UNAPIGEN.DBERR_NOCURRENTLCVERSION);
      END;

      IF NVL(A_IP_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_IPVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := A_IP_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := '#';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR       := L_OLD_OBJECT_NR;
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetSdIcAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetSdIcAuthorisation'));
END GETSDICAUTHORISATION;

FUNCTION GETSDICAUTHORISATION               
(A_SD             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_IP_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETSDICAUTHORISATION(A_SD, A_IC, A_ICNODE, A_IP_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETSDICAUTHORISATION;

FUNCTION GETSCIIAUTHORISATION               
(A_SC             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_II             IN        VARCHAR2,       
 A_IINODE         IN        NUMBER,         
 A_IE_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_IE_VERSION              VARCHAR2(20);
L_IP_VERSION_TMP          VARCHAR2(20);
L_LC                      VARCHAR2(2);
L_LC_TMP                  VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_LC_VERSION_TMP          VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_SS_TMP                  VARCHAR2(2);
L_ALLOW_MODIFY            CHAR(1);
L_ALLOW_MODIFY_TMP        CHAR(1);
L_ACTIVE                  CHAR(1);
L_ACTIVE_TMP              CHAR(1);
L_LOG_HS                  CHAR(1);
L_LOG_HS_TMP              CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_LOG_HS_DETAILS_TMP      CHAR(1);
L_AR_VAL                  CHAR(1);
L_AR_VAL_TMP              CHAR(1);
L_OLD_OBJECT_NR           NUMBER;
L_SEQ_NO                  NUMBER;
L_OBJECT_ID               VARCHAR2(255);
L_RETRIES                 INTEGER;
L_RETRIESWHENINTRANSITION INTEGER;
L_AUTHORISATION           INTEGER;
L_PARENT1_NR              INTEGER;
L_PARENT2_NR              INTEGER;
L_PARENTSC_NR             INTEGER;
L_PARENTRQ_NR             INTEGER;
L_PARENTSD_NR             INTEGER;

BEGIN

   P_NOT_AUTHORISED := NULL;
   L_OBJECT_ID := A_SC || A_IC || TO_CHAR(A_ICNODE) || A_II || TO_CHAR(A_IINODE);
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'ii' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = L_OBJECT_ID THEN
         A_IE_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC              (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS              (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY    (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'ii';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := L_OBJECT_ID;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT IE_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS,
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_IE_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDSCII
         WHERE SC     = A_SC
           AND IC     = A_IC
           AND ICNODE = A_ICNODE
           AND II     = A_II
           AND IINODE = A_IINODE;

         EXIT WHEN L_LC IS NULL; 
         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;




      IF L_LC IS NULL THEN
         L_ALLOW_MODIFY :='1';
      END IF;
      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;

      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
            UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
            L_AUTHORISATION := GETSCICAUTHORISATION(A_SC, A_IC, A_ICNODE, L_IP_VERSION_TMP, L_LC_TMP, 
                                                    L_LC_VERSION_TMP, L_SS_TMP, L_ALLOW_MODIFY_TMP, 
                                                    L_ACTIVE_TMP, L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP,
                                                    L_PARENT1_NR);
            UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
            IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
               (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
               IF P_CASCADE_READONLY = 'YES' THEN
                  UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
               ELSE
                  
                  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
                     
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
                     
                     
                     L_PARENTSC_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
                     IF L_PARENTSC_NR <> -1 THEN  
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSC_NR) = '0' THEN 
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        ELSE
                           L_PARENTRQ_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENTSC_NR);
                           L_PARENTSD_NR := UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENTSC_NR);
                           IF L_PARENTRQ_NR <> -1 THEN
                              IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTRQ_NR) = '0' THEN 
                                 UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                              END IF;
                           END IF;
                           IF L_PARENTSD_NR <> -1 THEN
                              IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSD_NR) = '0' THEN 
                                 UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  ELSE
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF ;
            ELSE
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'scii NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'scii IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetScIiAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScIiAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'scii READONLY:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'scii NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := L_IE_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IE_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
      UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
      L_AUTHORISATION := GETSCICAUTHORISATION(A_SC, A_IC, A_ICNODE, L_IP_VERSION_TMP, L_LC_TMP, 
                                              L_LC_VERSION_TMP, L_SS_TMP, L_ALLOW_MODIFY_TMP, 
                                              L_ACTIVE_TMP, L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
      UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
      IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
         (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
         
         
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
      ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
         IF P_CASCADE_READONLY = 'YES' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         ELSE
            
            
            IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
               
               
               L_PARENTSC_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
               IF L_PARENTSC_NR <> -1 THEN  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSC_NR) <> '0' THEN 
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  ELSE
                     L_PARENTRQ_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENTSC_NR);
                     L_PARENTSD_NR := UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENTSC_NR);
                     IF L_PARENTRQ_NR <> -1 THEN
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTRQ_NR) = '0' THEN 
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        END IF;
                     END IF;
                     IF L_PARENTSD_NR <> -1 THEN
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSD_NR) = '0' THEN 
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         END IF ;
      ELSE
         
         UNAPIGEN.PA_OBJECT_TP(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
         UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));      
      END IF;

      
      
      SELECT LOG_HS, LOG_HS_DETAILS
      INTO L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'ii';

      IF NVL(A_IE_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_IEVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := A_IE_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IE_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC              (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS              (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := '1';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetScIiAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScIiAuthorisation'));
END GETSCIIAUTHORISATION;

FUNCTION GETSCIIAUTHORISATION               
(A_SC             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_II             IN        VARCHAR2,       
 A_IINODE         IN        NUMBER,         
 A_IE_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETSCIIAUTHORISATION(A_SC, A_IC, A_ICNODE, A_II, A_IINODE, A_IE_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETSCIIAUTHORISATION;

FUNCTION GETRQIIAUTHORISATION        
(A_RQ             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_II             IN        VARCHAR2,       
 A_IINODE         IN        NUMBER,         
 A_IE_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_IE_VERSION              VARCHAR2(20);
L_IP_VERSION_TMP          VARCHAR2(20);
L_LC                      VARCHAR2(2);
L_LC_TMP                  VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_LC_VERSION_TMP          VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_SS_TMP                  VARCHAR2(2);
L_ALLOW_MODIFY            CHAR(1);
L_ALLOW_MODIFY_TMP        CHAR(1);
L_ACTIVE                  CHAR(1);
L_ACTIVE_TMP              CHAR(1);
L_LOG_HS                  CHAR(1);
L_LOG_HS_TMP              CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_LOG_HS_DETAILS_TMP      CHAR(1);
L_AR_VAL                  CHAR(1);
L_AR_VAL_TMP              CHAR(1);
L_OLD_OBJECT_NR           NUMBER;
L_SEQ_NO                  NUMBER;
L_OBJECT_ID               VARCHAR2(255);
L_RETRIES                 INTEGER;
L_RETRIESWHENINTRANSITION INTEGER;
L_AUTHORISATION           INTEGER;
L_PARENT1_NR              INTEGER;
L_PARENT2_NR              INTEGER;
L_PARENTRQ_NR             INTEGER;

BEGIN

   P_NOT_AUTHORISED := NULL;
   L_OBJECT_ID := A_RQ || A_IC || TO_CHAR(A_ICNODE) || A_II || TO_CHAR(A_IINODE);
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'ii' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = L_OBJECT_ID THEN
         A_IE_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC              (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS              (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY    (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'ii';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := L_OBJECT_ID;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT IE_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS,
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_IE_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDRQII
         WHERE RQ     = A_RQ
           AND IC     = A_IC
           AND ICNODE = A_ICNODE
           AND II     = A_II
           AND IINODE = A_IINODE;

         EXIT WHEN L_LC IS NULL; 
         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;




      IF L_LC IS NULL THEN
         L_ALLOW_MODIFY :='1';
      END IF;
      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;

      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
            UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
            L_AUTHORISATION := GETRQICAUTHORISATION (A_RQ, A_IC, A_ICNODE, L_IP_VERSION_TMP, L_LC_TMP, 
                                                     L_LC_VERSION_TMP, L_SS_TMP, L_ALLOW_MODIFY_TMP, 
                                                     L_ACTIVE_TMP, L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP,
                                                     L_PARENT1_NR);
            UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
            IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
               (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
               IF P_CASCADE_READONLY = 'YES' THEN
                  UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
               ELSE
                  
                  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
                     
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
                     
                     
                     L_PARENTRQ_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
                     IF L_PARENTRQ_NR <> -1 THEN  
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTRQ_NR) = '0' THEN 
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        END IF;
                     END IF;
                  ELSE
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF ;
            ELSE
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'rqii NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'rqii IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetRqIiAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetRqIiAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'rqii READONLY:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'rqii NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := L_IE_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IE_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
      UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
      L_AUTHORISATION := GETRQICAUTHORISATION(A_RQ, A_IC, A_ICNODE, L_IP_VERSION_TMP, L_LC_TMP, 
                                              L_LC_VERSION_TMP, L_SS_TMP, L_ALLOW_MODIFY_TMP, 
                                              L_ACTIVE_TMP, L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
      UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
      IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
         (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
         
         
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
      ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
         IF P_CASCADE_READONLY = 'YES' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         ELSE
            
            
            IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
               
               
               L_PARENTRQ_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
               IF L_PARENTRQ_NR <> -1 THEN  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTRQ_NR) = '0' THEN 
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         END IF ;
      ELSE
         
         UNAPIGEN.PA_OBJECT_TP(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
         UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));      
      END IF;

      
      
      SELECT LOG_HS, LOG_HS_DETAILS
      INTO L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'rqii';

      IF NVL(A_IE_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_IEVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := A_IE_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IE_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC              (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS              (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := '1';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetRqIiAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetRqIiAuthorisation'));
END GETRQIIAUTHORISATION;

FUNCTION GETRQIIAUTHORISATION        
(A_RQ             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_II             IN        VARCHAR2,       
 A_IINODE         IN        NUMBER,         
 A_IE_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETRQIIAUTHORISATION(A_RQ, A_IC, A_ICNODE, A_II, A_IINODE, A_IE_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETRQIIAUTHORISATION;

FUNCTION GETSDIIAUTHORISATION        
(A_SD             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_II             IN        VARCHAR2,       
 A_IINODE         IN        NUMBER,         
 A_IE_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_IE_VERSION              VARCHAR2(20);
L_IP_VERSION_TMP          VARCHAR2(20);
L_LC                      VARCHAR2(2);
L_LC_TMP                  VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_LC_VERSION_TMP          VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_SS_TMP                  VARCHAR2(2);
L_ALLOW_MODIFY            CHAR(1);
L_ALLOW_MODIFY_TMP        CHAR(1);
L_ACTIVE                  CHAR(1);
L_ACTIVE_TMP              CHAR(1);
L_LOG_HS                  CHAR(1);
L_LOG_HS_TMP              CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_LOG_HS_DETAILS_TMP      CHAR(1);
L_AR_VAL                  CHAR(1);
L_AR_VAL_TMP              CHAR(1);
L_OLD_OBJECT_NR           NUMBER;
L_SEQ_NO                  NUMBER;
L_OBJECT_ID               VARCHAR2(255);
L_RETRIES                 INTEGER;
L_RETRIESWHENINTRANSITION INTEGER;
L_AUTHORISATION           INTEGER;
L_PARENT1_NR              INTEGER;
L_PARENT2_NR              INTEGER;
L_PARENTSD_NR             INTEGER;

BEGIN

   P_NOT_AUTHORISED := NULL;
   L_OBJECT_ID := A_SD || A_IC || TO_CHAR(A_ICNODE) || A_II || TO_CHAR(A_IINODE);
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'ii' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = L_OBJECT_ID THEN
         A_IE_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC              (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS              (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY    (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'ii';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := L_OBJECT_ID;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT IE_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS,
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_IE_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDSDII
         WHERE SD     = A_SD
           AND IC     = A_IC
           AND ICNODE = A_ICNODE
           AND II     = A_II
           AND IINODE = A_IINODE;

         EXIT WHEN L_LC IS NULL; 
         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;




      IF L_LC IS NULL THEN
         L_ALLOW_MODIFY :='1';
      END IF;
      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;

      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
            UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
            L_AUTHORISATION := GETSDICAUTHORISATION (A_SD, A_IC, A_ICNODE, L_IP_VERSION_TMP, L_LC_TMP, 
                                                     L_LC_VERSION_TMP, L_SS_TMP, L_ALLOW_MODIFY_TMP, 
                                                     L_ACTIVE_TMP, L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP,
                                                     L_PARENT1_NR);
            UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
            IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
               (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
               IF P_CASCADE_READONLY = 'YES' THEN
                  UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
               ELSE
                  
                  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
                     
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
                     
                     
                     L_PARENTSD_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
                     IF L_PARENTSD_NR <> -1 THEN  
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSD_NR) = '0' THEN 
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        END IF;
                     END IF;
                  ELSE
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF ;
            ELSE
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'sdii NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'sdii IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetSdIiAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetSdIiAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'sdii READONLY:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'sdii NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := L_IE_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IE_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
      UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
      L_AUTHORISATION := GETSDICAUTHORISATION(A_SD, A_IC, A_ICNODE, L_IP_VERSION_TMP, L_LC_TMP, 
                                              L_LC_VERSION_TMP, L_SS_TMP, L_ALLOW_MODIFY_TMP, 
                                              L_ACTIVE_TMP, L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
      UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
      IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
         (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
         
         
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
      ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
         IF P_CASCADE_READONLY = 'YES' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         ELSE
            
            
            IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
               
               
               L_PARENTSD_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
               IF L_PARENTSD_NR <> -1 THEN  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSD_NR) = '0' THEN 
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         END IF ;
      ELSE
         
         UNAPIGEN.PA_OBJECT_TP(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
         UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));      
      END IF;

      
      
      SELECT LOG_HS, LOG_HS_DETAILS
      INTO L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'sdii';

      IF NVL(A_IE_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_IEVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := A_IE_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_IE_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC              (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS              (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := '1';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetSdIiAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetSdIiAuthorisation'));
END GETSDIIAUTHORISATION;

FUNCTION GETSDIIAUTHORISATION        
(A_SD             IN        VARCHAR2,       
 A_IC             IN        VARCHAR2,       
 A_ICNODE         IN        NUMBER,         
 A_II             IN        VARCHAR2,       
 A_IINODE         IN        NUMBER,         
 A_IE_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETSDIIAUTHORISATION(A_SD, A_IC, A_ICNODE, A_II, A_IINODE, A_IE_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETSDIIAUTHORISATION;

FUNCTION GETSCPGAUTHORISATION               
(A_SC             IN        VARCHAR2,       
 A_PG             IN        VARCHAR2,       
 A_PGNODE         IN        NUMBER,         
 A_PP_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_PP_VERSION              VARCHAR2(20);
L_ST_VERSION_TMP          VARCHAR2(20);
L_LC                      VARCHAR2(2);
L_LC_TMP                  VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_LC_VERSION_TMP          VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_SS_TMP                  VARCHAR2(2);
L_ALLOW_MODIFY            CHAR(1);
L_ALLOW_MODIFY_TMP        CHAR(1);
L_ACTIVE                  CHAR(1);
L_ACTIVE_TMP              CHAR(1);
L_LOG_HS                  CHAR(1);
L_LOG_HS_TMP              CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_LOG_HS_DETAILS_TMP      CHAR(1);
L_AR_VAL                  CHAR(1);
L_AR_VAL_TMP              CHAR(1);
L_SEQ_NO                  NUMBER;
L_OBJECT_ID               VARCHAR2(255);
L_OLD_OBJECT_NR           NUMBER;
L_RETRIES                 INTEGER;
L_RETRIESWHENINTRANSITION INTEGER;
L_AUTHORISATION           INTEGER;
L_PARENT1_NR              INTEGER;
L_PARENT2_NR              INTEGER;

BEGIN

   P_NOT_AUTHORISED := NULL;
   L_OBJECT_ID := A_SC || A_PG || TO_CHAR(A_PGNODE);
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'pg' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = L_OBJECT_ID THEN
         A_PP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;         
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'pg';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := L_OBJECT_ID;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT PP_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS, 
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_PP_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDSCPG
         WHERE SC     = A_SC
           AND PG     = A_PG
           AND PGNODE = A_PGNODE;

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
            UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
            L_AUTHORISATION := GETSCAUTHORISATION (A_SC, L_ST_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                                   L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, 
                                                   L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
            UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
            IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
               (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
               IF P_CASCADE_READONLY = 'YES' THEN
                  UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
               ELSE
                  
                  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
                     
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
                     
                     IF UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR) <> -1 THEN  
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR)) <> '0' THEN
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        END IF;
                     END IF;
                     IF UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENT1_NR) <> -1 THEN 
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENT1_NR)) <> '0' THEN
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        END IF;
                     END IF;
                  ELSE
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF ;
            ELSE
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'pg NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'pg IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetScPgAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScPgAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'pg READONLY:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'pg NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := L_PP_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_PP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
      UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
      L_AUTHORISATION := GETSCAUTHORISATION (A_SC, L_ST_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                             L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, L_LOG_HS_TMP, 
                                             L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
      UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
      IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
         (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
         
         
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
      ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
         IF P_CASCADE_READONLY = 'YES' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         ELSE
            
            
            IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;                  
               
               IF UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR) <> -1 THEN  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR)) <> '0' THEN
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF;
               IF UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENT1_NR) <> -1 THEN 
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENT1_NR)) <> '0' THEN
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         END IF;
      ELSE
         
         UNAPIGEN.PA_OBJECT_TP(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
         UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));      
      END IF;

      
      SELECT DEF_LC, LOG_HS, LOG_HS_DETAILS
      INTO L_LC, L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'pg';

      BEGIN
         SELECT VERSION
         INTO L_LC_VERSION
         FROM UTLC
         WHERE LC = L_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (UNAPIGEN.DBERR_NOCURRENTLCVERSION);
      END;

      IF NVL(A_PP_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_PPVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := A_PP_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_PP_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := '#';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR       := L_OLD_OBJECT_NR;
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetScPgAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScPgAuthorisation'));
END GETSCPGAUTHORISATION;

FUNCTION GETSCPGAUTHORISATION               
(A_SC             IN        VARCHAR2,       
 A_PG             IN        VARCHAR2,       
 A_PGNODE         IN        NUMBER,         
 A_PP_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR          INTEGER;
BEGIN
   RETURN(GETSCPGAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PP_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETSCPGAUTHORISATION;

FUNCTION GETSCPAAUTHORISATION               
(A_SC             IN        VARCHAR2,       
 A_PG             IN        VARCHAR2,       
 A_PGNODE         IN        NUMBER,         
 A_PA             IN        VARCHAR2,       
 A_PANODE         IN        NUMBER,         
 A_PR_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_PR_VERSION              VARCHAR2(20);
L_PP_VERSION_TMP          VARCHAR2(20);
L_LC                      VARCHAR2(2);
L_LC_TMP                  VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_LC_VERSION_TMP          VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_SS_TMP                  VARCHAR2(2);
L_ALLOW_MODIFY            CHAR(1);
L_ALLOW_MODIFY_TMP        CHAR(1);
L_ACTIVE                  CHAR(1);
L_ACTIVE_TMP              CHAR(1);
L_LOG_HS                  CHAR(1);
L_LOG_HS_TMP              CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_LOG_HS_DETAILS_TMP      CHAR(1);
L_AR_VAL                  CHAR(1);
L_AR_VAL_TMP              CHAR(1);
L_SEQ_NO                  NUMBER;
L_OBJECT_ID               VARCHAR2(255);
L_OLD_OBJECT_NR           NUMBER;
L_RETRIES                 INTEGER;
L_RETRIESWHENINTRANSITION INTEGER;
L_AUTHORISATION           INTEGER;
L_PARENT1_NR              INTEGER;
L_PARENT2_NR              INTEGER;
L_PARENTSC_NR             INTEGER;
L_PARENTRQ_NR             INTEGER;
L_PARENTSD_NR             INTEGER;

BEGIN

   P_NOT_AUTHORISED := NULL;
   L_OBJECT_ID := A_SC || A_PG || TO_CHAR(A_PGNODE) || A_PA || TO_CHAR(A_PANODE);
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'pa' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = L_OBJECT_ID THEN
         A_PR_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC              (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS              (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY    (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;         
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'pa';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := L_OBJECT_ID;

   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT PR_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS,
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_PR_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_AR_VAL
         FROM UDSCPA
         WHERE SC     = A_SC
           AND PG     = A_PG
           AND PGNODE = A_PGNODE
           AND PA     = A_PA
           AND PANODE = A_PANODE;

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
            UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
            L_AUTHORISATION := GETSCPGAUTHORISATION (A_SC, A_PG, A_PGNODE, L_PP_VERSION_TMP, L_LC_TMP, 
                                                     L_LC_VERSION_TMP, L_SS_TMP, L_ALLOW_MODIFY_TMP, 
                                                     L_ACTIVE_TMP, L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP,
                                                     L_PARENT1_NR);
            UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
            IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
               (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
               IF P_CASCADE_READONLY = 'YES' THEN
                  UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
               ELSE
                  
                  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
                     
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
                     
                     
                     L_PARENTSC_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
                     IF L_PARENTSC_NR <> -1 THEN  
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSC_NR) <> '0' THEN 
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        ELSE
                           L_PARENTRQ_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENTSC_NR);
                           L_PARENTSD_NR := UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENTSC_NR);
                           IF L_PARENTRQ_NR <> -1 THEN
                              IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTRQ_NR) = '0' THEN 
                                 UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                              END IF;
                           END IF;
                           IF L_PARENTSD_NR <> -1 THEN
                              IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSD_NR) = '0' THEN 
                                 UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  ELSE
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF ;
            ELSE
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'pa NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'pa IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetScPaAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||
            NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScPaAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'pa READONLY:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'pa NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := L_PR_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_PR_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
      UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
      L_AUTHORISATION := GETSCPGAUTHORISATION (A_SC, A_PG, A_PGNODE, L_PP_VERSION_TMP, L_LC_TMP, 
                                               L_LC_VERSION_TMP, L_SS_TMP, L_ALLOW_MODIFY_TMP, 
                                               L_ACTIVE_TMP, L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP,
                                               L_PARENT1_NR);
      UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
      IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
         (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
         
         
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
      ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
         IF P_CASCADE_READONLY = 'YES' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         ELSE
            
            
            IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
               
               
               L_PARENTSC_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
               IF L_PARENTSC_NR <> -1 THEN  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSC_NR) <> '0' THEN 
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  ELSE
                     L_PARENTRQ_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENTSC_NR);
                     L_PARENTSD_NR := UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENTSC_NR);
                     IF L_PARENTRQ_NR <> -1 THEN
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTRQ_NR) = '0' THEN 
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        END IF;
                     END IF;
                     IF L_PARENTSD_NR <> -1 THEN
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSD_NR) = '0' THEN 
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         END IF ;
      ELSE
         
         UNAPIGEN.PA_OBJECT_TP(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
         UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));      
      END IF;

      
      SELECT DEF_LC, LOG_HS, LOG_HS_DETAILS
      INTO L_LC, L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'pa';

      BEGIN
         SELECT VERSION
         INTO L_LC_VERSION
         FROM UTLC
         WHERE LC = L_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (UNAPIGEN.DBERR_NOCURRENTLCVERSION);
      END;

      IF NVL(A_PR_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_PRVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := A_PR_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_PR_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := '#';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      
      
      
      
      
      IF UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetScPaAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScPaAuthorisation'));
END GETSCPAAUTHORISATION;

FUNCTION GETSCPAAUTHORISATION               
(A_SC             IN        VARCHAR2,       
 A_PG             IN        VARCHAR2,       
 A_PGNODE         IN        NUMBER,         
 A_PA             IN        VARCHAR2,       
 A_PANODE         IN        NUMBER,         
 A_PR_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  INTEGER;
BEGIN
   RETURN(GETSCPAAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_PR_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETSCPAAUTHORISATION;

FUNCTION GETSCMEAUTHORISATION        
(A_SC             IN        VARCHAR2,       
 A_PG             IN        VARCHAR2,       
 A_PGNODE         IN        NUMBER,         
 A_PA             IN        VARCHAR2,       
 A_PANODE         IN        NUMBER,         
 A_ME             IN        VARCHAR2,       
 A_MENODE         IN        NUMBER,         
 A_REANALYSIS     IN        NUMBER,                
 A_MT_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR,           
 A_OBJECT_NR      OUT       NUMBER)         
RETURN NUMBER IS

L_MT_VERSION              VARCHAR2(20);
L_PR_VERSION_TMP          VARCHAR2(20);
L_LC                      VARCHAR2(2);
L_LC_TMP                  VARCHAR2(2);
L_LC_VERSION              VARCHAR2(20);
L_LC_VERSION_TMP          VARCHAR2(20);
L_SS                      VARCHAR2(2);
L_SS_TMP                  VARCHAR2(2);
L_ALLOW_MODIFY            CHAR(1);
L_ALLOW_MODIFY_TMP        CHAR(1);
L_ACTIVE                  CHAR(1);
L_ACTIVE_TMP              CHAR(1);
L_LOG_HS                  CHAR(1);
L_LOG_HS_TMP              CHAR(1);
L_LOG_HS_DETAILS          CHAR(1);
L_LOG_HS_DETAILS_TMP      CHAR(1);
L_AR_VAL                  CHAR(1);
L_REANALYSIS              NUMBER(3);
L_SEQ_NO                  NUMBER;
L_OBJECT_ID               VARCHAR2(255);
L_OLD_OBJECT_NR           NUMBER;
L_RETRIES                 INTEGER;
L_RETRIESWHENINTRANSITION INTEGER;
L_AUTHORISATION           INTEGER;
L_PARENT1_NR              INTEGER;
L_PARENT2_NR              INTEGER;
L_PARENTSCPG_NR           INTEGER;
L_PARENTSC_NR             INTEGER;
L_PARENTRQ_NR             INTEGER;
L_PARENTSD_NR             INTEGER;

BEGIN
   UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiAut.GETSCMEAUTHORISATION','AUT-0: '||A_SC||' ME: '||A_ME||' start mt_version: '||A_MT_VERSION );

   P_NOT_AUTHORISED := NULL;
   L_OBJECT_ID := A_SC || A_PG || TO_CHAR(A_PGNODE)
                       || A_PA || TO_CHAR(A_PANODE)
                       || A_ME || TO_CHAR(A_MENODE);
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'me' AND UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = L_OBJECT_ID THEN
         A_MT_VERSION     := UNAPIGEN.PA_OBJECT_VERSION         (L_SEQ_NO);
         A_LC             := UNAPIGEN.PA_OBJECT_LC              (L_SEQ_NO);
         A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION      (L_SEQ_NO);
         A_SS             := UNAPIGEN.PA_OBJECT_SS              (L_SEQ_NO);
         A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY    (L_SEQ_NO);
         A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE          (L_SEQ_NO);
         A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS          (L_SEQ_NO);
         A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS  (L_SEQ_NO);
         A_OBJECT_NR      := L_SEQ_NO;    
         

              
         IF L_NO_ALLOW_MODIFY_CHECK AND UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
           
            UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiAut.GETSCMEAUTHORISATION','AUT-1: '||A_SC||' ME: '||A_ME||' in PA-OBJECT-NR-loop SEQ-NO, L_NO_ALLOW_MODIFY_CHECK=TRUE + PA_OBJECT_ALLOW_MODIFY=0, success ');
            
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
         
         UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiAut.GETSCMEAUTHORISATION','AUT-2: '||A_SC||' ME: '||A_ME||' in PA-OBJECT-NR-loop SEQ-NO, L_NO_ALLOW_MODIFY_CHECK=FALSE paobject-priv: '||UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO)||' success ');
         
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'me';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := L_OBJECT_ID;



   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   
   UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiAut.GETSCMEAUTHORISATION','AUT-3: '||A_SC||' ME: '||A_ME||' max aantal retries: '||l_retries||' UNAPIGEN.P_DD: '||UNAPIGEN.P_DD);
   
   BEGIN
      LOOP
         

         SELECT MT_VERSION, LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS, LOG_HS_DETAILS, REANALYSIS,
                DECODE(UNAPIGEN.P_DD, '1', AR1, '2', AR2, '3', AR3, '4', AR4, '5', AR5, '6', AR6, 
                       '7', AR7, '8', AR8, '9', AR9, '10', AR10, '11', AR11, '12', AR12, '13', AR13,
                       '14', AR14, '15', AR15, '16', AR16, '17', AR17, '18', AR18, '19', AR19, 
                       '20', AR20, '21', AR21, '22', AR22, '23', AR23, '24', AR24, '25', AR25, 
                       '26', AR26, '27', AR27, '28', AR28, '29', AR29, '30', AR30, '31', AR31, 
                       '32', AR32, '33', AR33, '34', AR34, '35', AR35, '36', AR36, '37', AR37, 
                       '38', AR38, '39', AR39, '40', AR40, '41', AR41, '42', AR42, '43', AR43, 
                       '44', AR44, '45', AR45, '46', AR46, '47', AR47, '48', AR48, '49', AR49,
                       '50', AR50, '51', AR51, '52', AR52, '53', AR53, '54', AR54, '55', AR55, 
                       '56', AR56, '57', AR57, '58', AR58, '59', AR59, '60', AR60, '61', AR61, 
                       '62', AR62, '63', AR63, '64', AR64, '65', AR65, '66', AR66, '67', AR67, 
                       '68', AR68, '69', AR69, '70', AR70, '71', AR71, '72', AR72, '73', AR73, 
                       '74', AR74, '75', AR75, '76', AR76, '77', AR77, '78', AR78, '79', AR79, 
                       '80', AR80, '81', AR81, '82', AR82, '83', AR83, '84', AR84, '85', AR85, 
                       '86', AR86, '87', AR87, '88', AR88, '89', AR89, '90', AR90, '91', AR91, 
                       '92', AR92, '93', AR93, '94', AR94, '95', AR95, '96', AR96, '97', AR97, 
                       '98', AR98, '99', AR99, '100', AR100, '101', AR101, '102', AR102, '103', AR103, 
                       '104', AR104, '105', AR105, '106', AR106, '107', AR107, '108', AR108, 
                       '109', AR109, '110', AR110, '111', AR111, '112', AR112, '113', AR113, 
                       '114', AR114, '115', AR115, '116', AR116, '117', AR117, '118', AR118, 
                       '119', AR119, '120', AR120, '121', AR121, '122', AR122, '123', AR123, 
                       '124', AR124, '125', AR125, '126', AR126, 
                       DECODE(UNAPIGEN.P_DD, '127', AR127, '128', AR128, 'W')) AR
         INTO L_MT_VERSION, L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, 
              L_LOG_HS_DETAILS, L_REANALYSIS, L_AR_VAL
         FROM UDSCME
         WHERE SC     = A_SC
           AND PG     = A_PG
           AND PGNODE = A_PGNODE
           AND PA     = A_PA
           AND PANODE = A_PANODE
           AND ME     = A_ME
           AND MENODE = A_MENODE;

         UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiAut.GETSCMEAUTHORISATION','AUT-4 IN LOOP NA select UDSCME: '||A_SC||' ME: '||A_ME||' MT_VERSION: '||l_mt_version||' lc: '||l_lc||' ss: '||l_ss||' active: '||l_active||' allow-modify: '||l_allow_modify ||' ar_val: '||l_ar_val);

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = FALSE);
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;

      UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiAut.GETSCMEAUTHORISATION','AUT-5 NA LOOP: '||A_SC||' ME: '||A_ME||' allow-modify: '||l_allow_modify ||' ar_val: '||l_ar_val);
      
      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      IF A_REANALYSIS IS NOT NULL AND
         A_REANALYSIS <> L_REANALYSIS THEN
            P_NOT_AUTHORISED := 'me is not the current one, actual reanalysis:'||TO_CHAR(L_REANALYSIS)||' <> a_reanalysis:'||TO_CHAR(A_REANALYSIS);
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTCURRENTMETHOD;
      ELSIF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
            UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
               L_AUTHORISATION := GETSCPAAUTHORISATION (A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, 
                                                        L_PR_VERSION_TMP, L_LC_TMP, L_LC_VERSION_TMP, 
                                                        L_SS_TMP, L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, 
                                                        L_LOG_HS_TMP, L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
            UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiAut.GETSCMEAUTHORISATION','AUT-6: '||A_SC||' ME: '||A_ME||' getSCPA-authorisation result: '||l_authorisation );
            
            UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
            IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
               (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
               IF P_CASCADE_READONLY = 'YES' THEN
                  UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
               ELSE
                  
                  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
                     
                     
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
                     
                     
                     L_PARENTSCPG_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
                     IF L_PARENTSCPG_NR <> -1 THEN  
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSCPG_NR) <> '0' THEN 
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        ELSE
                           L_PARENTSC_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
                           IF L_PARENTSC_NR <> -1 THEN  
                              IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSC_NR) <> '0' THEN 
                                 UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                              ELSE
                                 L_PARENTRQ_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENTSC_NR);
                                 L_PARENTSD_NR := UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENTSC_NR);
                                 IF L_PARENTRQ_NR <> -1 THEN
                                    IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTRQ_NR) = '0' THEN 
                                       UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                                    END IF;
                                 END IF;
                                 IF L_PARENTSD_NR <> -1 THEN
                                    IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSD_NR) = '0' THEN 
                                       UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                                    END IF;
                                 END IF;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  ELSE
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  END IF;
               END IF ;
            ELSE
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               P_NOT_AUTHORISED := 'me NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            P_NOT_AUTHORISED := 'me IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
            
            UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiAut.GETSCMEAUTHORISATION','AUT-6 ERROR allow-modify-check: '||A_SC||' ME: '||A_ME||' allow-modify: '||l_allow_modify ||' me IN TRANSITION (UNAPIGEN.DBERR_TRANSITION):'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR ));
           
         ELSE
            UNAPIGEN.LOGERROR('GetScMeAuthorisation','allow_modify for ' || 
            UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) ||' has illegal value ' ||NVL(L_ALLOW_MODIFY, 'NULL') );
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScMeAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            P_NOT_AUTHORISED := 'me READONLY:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            P_NOT_AUTHORISED := 'me NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := L_MT_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_MT_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR);
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      
      UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiAut.GETSCMEAUTHORISATION','AUT-7 KLAAR voor RETURN: '||A_SC||' ME: '||A_ME||' MT_VERSION: '||A_MT_VERSION||' return-waarde: '||UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));
      
      RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      L_OLD_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR;
      L_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
      UNAPIEV.P_RETRIESWHENINTRANSITION := 0;
      L_AUTHORISATION := GETSCPAAUTHORISATION (A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, L_PR_VERSION_TMP, 
                                               L_LC_TMP, L_LC_VERSION_TMP, L_SS_TMP, 
                                               L_ALLOW_MODIFY_TMP, L_ACTIVE_TMP, L_LOG_HS_TMP, 
                                               L_LOG_HS_DETAILS_TMP, L_PARENT1_NR);
                                               
      UNAPIGEN.LOGERROR('UnapiAut.GETSCMEAUTHORISATION','AUT-8 In EXCP: '||A_SC||' ME: '||A_ME||' na GETSCPAAUTHORISATION authrorisation: '||l_authorisation||' zie code/betekenis in APIGEN');
                                               
      UNAPIEV.P_RETRIESWHENINTRANSITION := L_RETRIESWHENINTRANSITION;
      IF (L_AUTHORISATION = UNAPIGEN.DBERR_SUCCESS    ) OR
         (L_AUTHORISATION = UNAPIGEN.DBERR_TRANSITION ) THEN
         
         
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
      ELSIF (L_AUTHORISATION = UNAPIGEN.DBERR_READONLY   ) THEN
         IF P_CASCADE_READONLY = 'YES' THEN
            UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         ELSE
            
            
            IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENT1_NR) <> '0' THEN
               
               
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
               
               
               L_PARENTSCPG_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
               IF L_PARENTSCPG_NR <> -1 THEN  
                  IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSCPG_NR) <> '0' THEN 
                     UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                  ELSE
                     L_PARENTSC_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENT1_NR);
                     IF L_PARENTSC_NR <> -1 THEN  
                        IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSC_NR) <> '0' THEN 
                           UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                        ELSE
                           L_PARENTRQ_NR := UNAPIGEN.PA_OBJECT_PARENT1_NR(L_PARENTSC_NR);
                           L_PARENTSD_NR := UNAPIGEN.PA_OBJECT_PARENT2_NR(L_PARENTSC_NR);
                           IF L_PARENTRQ_NR <> -1 THEN
                              IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTRQ_NR) = '0' THEN 
                                 UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                              END IF;
                           END IF;
                           IF L_PARENTSD_NR <> -1 THEN
                              IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_PARENTSD_NR) = '0' THEN 
                                 UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
            END IF;
         END IF ;
      ELSE
         
         UNAPIGEN.PA_OBJECT_TP(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ID(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) := UNAPIGEN.DBERR_NOTAUTHORISED;
         UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := '';
         UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
         UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 
         
         UNAPIGEN.LOGERROR('UnapiAut.GETSCMEAUTHORISATION','AUT-9 In-EXCP (not-success/readonly): '||A_SC||' ME: '||A_ME||' PRIV-old-object-nr: '||UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) );
         
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));      
      END IF;

      
      SELECT DEF_LC, LOG_HS, LOG_HS_DETAILS
      INTO L_LC, L_LOG_HS, L_LOG_HS_DETAILS
      FROM UTOBJECTS
      WHERE OBJECT = 'me';

      BEGIN
         SELECT VERSION
         INTO L_LC_VERSION
         FROM UTLC
         WHERE LC = L_LC
         AND VERSION_IS_CURRENT = '1';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (UNAPIGEN.DBERR_NOCURRENTLCVERSION);
      END;

      IF NVL(A_MT_VERSION, ' ') = ' ' THEN
         RETURN(UNAPIGEN.DBERR_MTVERSION);
      END IF;

      UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR) := A_MT_VERSION;
      UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY  (L_OLD_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR) := L_LOG_HS;
      UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR) := L_LOG_HS_DETAILS;
      UNAPIGEN.PA_OBJECT_PARENT1_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT1_NR,-1); 
      UNAPIGEN.PA_OBJECT_PARENT2_NR    (L_OLD_OBJECT_NR) := NVL(L_PARENT2_NR,-1); 

      A_MT_VERSION     := UNAPIGEN.PA_OBJECT_VERSION       (L_OLD_OBJECT_NR);
      A_LC             := UNAPIGEN.PA_OBJECT_LC            (L_OLD_OBJECT_NR);
      A_LC_VERSION     := UNAPIGEN.PA_OBJECT_LC_VERSION    (L_OLD_OBJECT_NR);
      A_SS             := UNAPIGEN.PA_OBJECT_SS            (L_OLD_OBJECT_NR);
      A_ALLOW_MODIFY   := '#';
      A_ACTIVE         := UNAPIGEN.PA_OBJECT_ACTIVE        (L_OLD_OBJECT_NR);
      A_LOG_HS         := UNAPIGEN.PA_OBJECT_LOG_HS        (L_OLD_OBJECT_NR);
      A_LOG_HS_DETAILS := UNAPIGEN.PA_OBJECT_LOG_HS_DETAILS(L_OLD_OBJECT_NR);
      A_OBJECT_NR      := L_OLD_OBJECT_NR;
      
      
      
      UNAPIGEN.LOGERROR('UnapiAut.GETSCMEAUTHORISATION','AUT-10 Einde-EXCP: '||A_SC||' ME: '||A_ME||' PRIV-old-object-nr: '||UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) );
      
      IF UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR) = UNAPIGEN.DBERR_SUCCESS THEN
         RETURN (UNAPIGEN.DBERR_NOOBJECT);
      ELSE
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_OLD_OBJECT_NR));
      END IF;
   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetScMeAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetScMeAuthorisation'));
END GETSCMEAUTHORISATION;

FUNCTION GETSCMEAUTHORISATION        
(A_SC             IN        VARCHAR2,       
 A_PG             IN        VARCHAR2,       
 A_PGNODE         IN        NUMBER,         
 A_PA             IN        VARCHAR2,       
 A_PANODE         IN        NUMBER,         
 A_ME             IN        VARCHAR2,       
 A_MENODE         IN        NUMBER,         
 A_REANALYSIS     IN        NUMBER,                
 A_MT_VERSION     IN  OUT   VARCHAR2,       
 A_LC             OUT       VARCHAR2,       
 A_LC_VERSION     OUT       VARCHAR2,       
 A_SS             OUT       VARCHAR2,       
 A_ALLOW_MODIFY   OUT       CHAR,           
 A_ACTIVE         OUT       CHAR,           
 A_LOG_HS         OUT       CHAR,           
 A_LOG_HS_DETAILS OUT       CHAR)           
RETURN NUMBER IS
L_TEMP_OBJECT_NR  NUMBER;
BEGIN
   RETURN(GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, A_REANALYSIS, A_MT_VERSION, A_LC, A_LC_VERSION, A_SS, A_ALLOW_MODIFY, A_ACTIVE, A_LOG_HS, A_LOG_HS_DETAILS, L_TEMP_OBJECT_NR));
END GETSCMEAUTHORISATION;

FUNCTION DISABLEALLOWMODIFYCHECK     
(A_FLAG          IN        CHAR)     
RETURN NUMBER IS

BEGIN

   IF A_FLAG = '1' THEN
      L_NO_ALLOW_MODIFY_CHECK := TRUE;     
   ELSE
      L_NO_ALLOW_MODIFY_CHECK := FALSE;        
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('DisableAllowModifyCheck',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'DisableAllowModifyCheck'));
END DISABLEALLOWMODIFYCHECK;

FUNCTION GETALLOWMODIFYCHECKMODE     
(A_FLAG          OUT       CHAR)     
RETURN NUMBER IS

BEGIN

   IF L_NO_ALLOW_MODIFY_CHECK THEN
      A_FLAG := '1';
   ELSE
      A_FLAG := '0';
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetAllowModifyCheckMode',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetAllowModifyCheckMode'));
END GETALLOWMODIFYCHECKMODE;

FUNCTION GETARCHECKMODE             
(A_FLAG          OUT       CHAR)     
RETURN NUMBER IS

BEGIN

   IF L_NO_AR_CHECK THEN
      A_FLAG := '1';
   ELSE
      A_FLAG := '0';
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetARCheckMode',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetARCheckMode'));
END GETARCHECKMODE;

FUNCTION DISABLEARCHECK              
(A_FLAG          IN        CHAR)     
RETURN NUMBER IS

BEGIN

   IF A_FLAG = '1' THEN
      L_NO_AR_CHECK := TRUE;     
   ELSE
      L_NO_AR_CHECK := FALSE;        
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('DisableARCheck',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'DisableARCheck'));
END DISABLEARCHECK;

FUNCTION EVALASSIGNMENTFREQ
(A_MAIN_OBJECT_TP             IN VARCHAR2,     
 A_MAIN_OBJECT_ID             IN VARCHAR2 ,    
 A_MAIN_OBJECT_VERSION        IN VARCHAR2 ,    
 A_OBJECT_TP                  IN VARCHAR2,     
 A_OBJECT_ID                  IN VARCHAR2,     
 A_OBJECT_VERSION             IN VARCHAR2,     
 A_FREQ_TP                    IN CHAR,         
 A_FREQ_VAL                   IN NUMBER,       
 A_FREQ_UNIT                  IN VARCHAR2,     
 A_INVERT_FREQ                IN CHAR,         
 A_REF_DATE                   IN DATE,         
 A_LAST_SCHED                 IN OUT DATE,     
 A_LAST_CNT                   IN OUT NUMBER,   
 A_LAST_VAL                   IN OUT VARCHAR2) 
RETURN BOOLEAN IS

L_CURR_DIFF       NUMBER;
L_INCREMENT       NUMBER;
L_II_CURSOR       INTEGER;
L_VALUE           VARCHAR2(2000);
L_INVERT_FREQ     CHAR(1);
L_LAST_SCHED      TIMESTAMP WITH TIME ZONE;
L_FREQ_VAL        NUMBER;
L_FIRST_DAY       TIMESTAMP WITH TIME ZONE;
L_FUNCTION_CURSOR INTEGER;
L_REF_DATE        TIMESTAMP WITH TIME ZONE;
L_PREV_WEEK_NR    INTEGER;
L_NEW_SCHED       TIMESTAMP WITH TIME ZONE;

CURSOR L_WEEK_CURSOR (A_LAST_SCHED IN TIMESTAMP WITH TIME ZONE, A_REF_DATE IN TIMESTAMP WITH TIME ZONE) IS
   SELECT DAY_OF_YEAR,WEEK_NR
   FROM   UTWEEKNR
   WHERE DAY_OF_YEAR >= (TO_TIMESTAMP_TZ(TO_CHAR(TRUNC(A_LAST_SCHED AT TIME ZONE DBTIMEZONE,'DD'),'DD/MM/YYYY HH24:MI:SS ')||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')AT TIME ZONE SESSIONTIMEZONE)
     AND DAY_OF_YEAR <= (TO_TIMESTAMP_TZ(TO_CHAR(TRUNC(A_REF_DATE AT TIME ZONE DBTIMEZONE,'DD'),'DD/MM/YYYY HH24:MI:SS ')||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')AT TIME ZONE SESSIONTIMEZONE)
   ORDER BY DAY_OF_YEAR;
L_WEEK_REC L_WEEK_CURSOR%ROWTYPE;

BEGIN









L_INVERT_FREQ := NVL(A_INVERT_FREQ,'0');
L_FIRST_DAY   := TO_TIMESTAMP_TZ('01/01/1970','DD/MM/YYYY');
L_LAST_SCHED  := NVL(A_LAST_SCHED, L_FIRST_DAY);
L_REF_DATE    := NVL(A_REF_DATE  , L_FIRST_DAY);

IF L_LAST_SCHED < L_FIRST_DAY THEN
   L_LAST_SCHED := L_FIRST_DAY;
END IF;

L_FREQ_VAL    := NVL(A_FREQ_VAL, 0);

IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
   DBMS_OUTPUT.PUT_LINE(A_MAIN_OBJECT_TP || ' / ' || A_MAIN_OBJECT_ID || ' / ' ||A_MAIN_OBJECT_VERSION || ' / ' ||
                        A_OBJECT_TP || ' / ' || A_OBJECT_ID || ' / ' || A_OBJECT_VERSION || ' / ' || A_FREQ_TP ||
                        ' / '|| A_FREQ_VAL || ' / ' || A_FREQ_UNIT ||
                        ' / '|| A_INVERT_FREQ || ' / ' || A_LAST_SCHED || ' / '||
                        A_LAST_CNT ||' / ' || A_LAST_VAL);
END IF;




IF NVL(A_FREQ_TP, 'A') IN ('A','O') THEN
   IF L_INVERT_FREQ = '0' THEN
      A_LAST_SCHED := CURRENT_TIMESTAMP;
      IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
      END IF;
      RETURN(TRUE);
   ELSE
      IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
      END IF;
      RETURN(FALSE);
   END IF;




ELSIF (A_FREQ_TP = 'N') OR
      ((A_FREQ_TP IN ('T', 'S')) AND (L_FREQ_VAL <= 0)) THEN
   IF L_INVERT_FREQ = '0' THEN
      IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
      END IF;
      RETURN(FALSE);
   ELSE
      A_LAST_SCHED := CURRENT_TIMESTAMP;
      IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
      END IF;
      RETURN(TRUE);
   END IF;




ELSIF A_FREQ_TP = 'T' THEN

   IF L_LAST_SCHED > L_REF_DATE THEN
      
      IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
         DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq last_sched > ref_date => FALSE');
      END IF;
      RETURN(FALSE);
   END IF;

   
   
   
   IF A_FREQ_UNIT = 'MI' THEN
      
      L_CURR_DIFF := (TO_DATE(TO_CHAR(L_REF_DATE,'DD/MM/RR HH24:MI:SS'),'DD/MM/RR HH24:MI:SS') - TRUNC(L_LAST_SCHED,'MI')) * 24 * 60;
      IF L_CURR_DIFF >= L_FREQ_VAL THEN
         IF L_INVERT_FREQ = '0' THEN
            L_INCREMENT := FLOOR(L_CURR_DIFF / L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := TRUNC(L_LAST_SCHED, 'MI') + (L_INCREMENT / (24 * 60));
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            L_INCREMENT := FLOOR(L_CURR_DIFF / L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := TRUNC(L_LAST_SCHED,'MI') + (L_INCREMENT / (24 * 60));
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   
   
   
   ELSIF A_FREQ_UNIT = 'HH' THEN
      L_CURR_DIFF := (TO_DATE(TO_CHAR(L_REF_DATE,'DD/MM/RR HH24:MI:SS'),'DD/MM/RR HH24:MI:SS') - TRUNC(L_LAST_SCHED,'HH')) * 24;
      IF L_CURR_DIFF >= L_FREQ_VAL THEN
         IF L_INVERT_FREQ = '0' THEN
            L_INCREMENT := FLOOR(L_CURR_DIFF/L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := TRUNC(L_LAST_SCHED,'HH') + (L_INCREMENT / 24);
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            L_INCREMENT := FLOOR(L_CURR_DIFF/L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := TRUNC(L_LAST_SCHED,'HH') + (L_INCREMENT / 24);
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   
   
   
   ELSIF A_FREQ_UNIT = 'DD' THEN
      L_CURR_DIFF := TO_DATE(TO_CHAR(L_REF_DATE,'DD/MM/RR HH24:MI:SS'),'DD/MM/RR HH24:MI:SS') - TRUNC(L_LAST_SCHED,'DD');
      IF L_CURR_DIFF >= L_FREQ_VAL THEN
         IF L_INVERT_FREQ = '0' THEN
            L_INCREMENT := FLOOR(L_CURR_DIFF/L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := TRUNC(L_LAST_SCHED,'DD') + L_INCREMENT;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            L_INCREMENT := FLOOR(L_CURR_DIFF/L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := TRUNC(L_LAST_SCHED,'DD') + L_INCREMENT;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   
   
   
   ELSIF A_FREQ_UNIT = 'WW' THEN 
      L_PREV_WEEK_NR := -1;
      L_CURR_DIFF := 0;
      FOR L_WEEK_REC IN L_WEEK_CURSOR(L_LAST_SCHED, L_REF_DATE) LOOP
         IF L_WEEK_REC.WEEK_NR <> L_PREV_WEEK_NR THEN
            L_CURR_DIFF := L_CURR_DIFF + 1;
            L_PREV_WEEK_NR := L_WEEK_REC.WEEK_NR;
            IF MOD(L_CURR_DIFF-1, L_FREQ_VAL) = 0 THEN
               L_NEW_SCHED := L_WEEK_REC.DAY_OF_YEAR;
            END IF;
         END IF;
      END LOOP;
      L_CURR_DIFF := L_CURR_DIFF - 1;

      IF L_CURR_DIFF >= L_FREQ_VAL THEN
         IF L_INVERT_FREQ = '0' THEN
            A_LAST_SCHED := L_NEW_SCHED;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            A_LAST_SCHED := L_NEW_SCHED;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   
   
   
   ELSIF A_FREQ_UNIT = 'MM' THEN
      L_CURR_DIFF := MONTHS_BETWEEN(L_REF_DATE, TRUNC(L_LAST_SCHED, 'MM'));
      IF L_CURR_DIFF >= L_FREQ_VAL THEN
         IF L_INVERT_FREQ = '0' THEN
            L_INCREMENT := FLOOR(L_CURR_DIFF / L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := ADD_MONTHS(TRUNC(L_LAST_SCHED, 'MM'), L_INCREMENT);
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            L_INCREMENT := FLOOR(L_CURR_DIFF / L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := ADD_MONTHS(TRUNC(L_LAST_SCHED, 'MM'), L_INCREMENT);
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   
   
   
   ELSIF A_FREQ_UNIT = 'MF' THEN
      L_CURR_DIFF := MONTHS_BETWEEN(TRUNC(L_REF_DATE,'DD'), TRUNC(L_LAST_SCHED,'DD'));
      IF L_CURR_DIFF >= L_FREQ_VAL THEN
         IF L_INVERT_FREQ = '0' THEN
            L_INCREMENT := FLOOR(L_CURR_DIFF / L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := ADD_MONTHS(TRUNC(L_LAST_SCHED,'DD'), L_INCREMENT);
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            L_INCREMENT := FLOOR(L_CURR_DIFF / L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := ADD_MONTHS(TRUNC(L_LAST_SCHED,'DD'), L_INCREMENT);
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   
   
   
   ELSIF A_FREQ_UNIT = 'YY' THEN
      L_CURR_DIFF := TO_NUMBER(TO_CHAR(L_REF_DATE, 'YYYY')) -
                     TO_NUMBER(TO_CHAR(TRUNC(L_LAST_SCHED,'YYYY'), 'YYYY'));
      IF L_CURR_DIFF >= L_FREQ_VAL THEN
         IF L_INVERT_FREQ = '0' THEN
            L_INCREMENT := FLOOR(L_CURR_DIFF / L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := ADD_MONTHS(TRUNC(L_LAST_SCHED,'YYYY'),
                                       L_INCREMENT * 12);
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            L_INCREMENT := FLOOR(L_CURR_DIFF/L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := ADD_MONTHS(TRUNC(L_LAST_SCHED, 'YYYY'),
                                       L_INCREMENT * 12);
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   
   
   
   ELSIF A_FREQ_UNIT = 'YF' THEN
      L_CURR_DIFF := TRUNC(MONTHS_BETWEEN(TRUNC(L_REF_DATE,'DD'), TRUNC(L_LAST_SCHED,'DD'))/12);
      IF L_CURR_DIFF >= L_FREQ_VAL THEN
         IF L_INVERT_FREQ = '0' THEN
            L_INCREMENT := FLOOR(L_CURR_DIFF / L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := ADD_MONTHS(TRUNC(L_LAST_SCHED,'DD'), L_INCREMENT * 12);
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            L_INCREMENT := FLOOR(L_CURR_DIFF/L_FREQ_VAL) * L_FREQ_VAL;
            A_LAST_SCHED := ADD_MONTHS(TRUNC(L_LAST_SCHED,'DD'), L_INCREMENT * 12);
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   END IF;




ELSIF A_FREQ_TP = 'S' THEN
   
   
   
   IF A_FREQ_UNIT = 'sc' THEN
      A_LAST_CNT := NVL(A_LAST_CNT,0) + 1;
      IF A_LAST_CNT >= L_FREQ_VAL THEN
         A_LAST_CNT := 0;
         IF L_INVERT_FREQ = '0' THEN
            A_LAST_SCHED := L_REF_DATE;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            A_LAST_SCHED := L_REF_DATE;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   
   
   
   ELSIF A_FREQ_UNIT = 'rq' THEN
      A_LAST_CNT := NVL(A_LAST_CNT,0) + 1;
      IF A_LAST_CNT >= L_FREQ_VAL THEN
         A_LAST_CNT := 0;
         IF L_INVERT_FREQ = '0' THEN
            A_LAST_SCHED := L_REF_DATE;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            A_LAST_SCHED := L_REF_DATE;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   
   
   
   ELSIF A_FREQ_UNIT = 'sd' THEN
      A_LAST_CNT := NVL(A_LAST_CNT,0) + 1;
      IF A_LAST_CNT >= L_FREQ_VAL THEN
         A_LAST_CNT := 0;
         IF L_INVERT_FREQ = '0' THEN
            A_LAST_SCHED := L_REF_DATE;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            A_LAST_SCHED := L_REF_DATE;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   
   
   
   ELSE
      
      L_SQL_STRING := 'SELECT iivalue'
                   || ' FROM ut' || A_MAIN_OBJECT_TP || 'ii'
                   || ' WHERE ' || A_MAIN_OBJECT_TP || '='''
                   || REPLACE(A_MAIN_OBJECT_ID, '''', '''''') || ''' AND ii =''' 
                   || REPLACE(A_FREQ_UNIT, '''', '''''') || ''''; 
      L_VALUE := ' ';
      BEGIN
         L_II_CURSOR := DBMS_SQL.OPEN_CURSOR;
         DBMS_SQL.PARSE(L_II_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         DBMS_SQL.DEFINE_COLUMN(L_II_CURSOR, 1, L_VALUE, 2000);
         L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_II_CURSOR);
         DBMS_SQL.COLUMN_VALUE(L_II_CURSOR, 1, L_VALUE);
         DBMS_SQL.CLOSE_CURSOR(L_II_CURSOR);
      EXCEPTION
      WHEN OTHERS THEN
         IF DBMS_SQL.IS_OPEN(L_II_CURSOR) THEN
            DBMS_SQL.CLOSE_CURSOR(L_II_CURSOR);
         END IF;
      END;

      IF L_VALUE <> NVL(A_LAST_VAL,' ') THEN
         A_LAST_CNT := NVL(A_LAST_CNT, 0) + 1;
         A_LAST_VAL := L_VALUE;
      END IF;
      IF NVL(A_LAST_CNT,0) >= L_FREQ_VAL THEN
         A_LAST_CNT := 0;
         IF L_INVERT_FREQ = '0' THEN
            A_LAST_SCHED := L_REF_DATE;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         ELSE
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         END IF;
      ELSE
         IF L_INVERT_FREQ = '0' THEN
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
            END IF;
            RETURN(FALSE);
         ELSE
            A_LAST_SCHED := L_REF_DATE;
            IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
               DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq TRUE');
            END IF;
            RETURN(TRUE);
         END IF;
      END IF;
   END IF;
ELSIF A_FREQ_TP = 'C' THEN
   
   
   
   
   IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
      DBMS_OUTPUT.PUT_LINE('Warning ! EvalAssignmentFreq called with custom freq function ! => FALSE');
   END IF;
   RETURN(FALSE);
ELSE
   IF UNAPIAUT.P_AUT_OUTPUT_ON THEN
      DBMS_OUTPUT.PUT_LINE('EvalAssignmentFreq FALSE');
   END IF;
   RETURN(FALSE);
END IF;

END EVALASSIGNMENTFREQ;

FUNCTION SQLCALCULATEDELAY 
(A_DELAY        IN NUMBER,     
 A_DELAY_UNIT   IN VARCHAR2,   
 A_REF_DATE     IN DATE)        
RETURN DATE IS
L_DELAYED_TILL  TIMESTAMP WITH TIME ZONE;
BEGIN
   L_RET_CODE := UNAPIAUT.CALCULATEDELAY(A_DELAY, A_DELAY_UNIT, A_REF_DATE, L_DELAYED_TILL);
   RETURN(L_DELAYED_TILL);
END SQLCALCULATEDELAY;

FUNCTION CALCULATEDELAY 
(A_DELAY        IN NUMBER,     
 A_DELAY_UNIT   IN VARCHAR2,   
 A_REF_DATE     IN DATE,       
 A_DELAYED_TILL OUT DATE)      
RETURN NUMBER IS

L_DELAY_VALUE  NUMBER;

BEGIN

   RETURN(CALCULATEDELAY(A_DELAY, A_DELAY_UNIT, A_REF_DATE, A_DELAYED_TILL , L_DELAY_VALUE));

END CALCULATEDELAY;

FUNCTION CALCULATEDELAY       
(A_DELAY        IN NUMBER, 
 A_DELAY_UNIT   IN VARCHAR2,
 A_REF_DATE     IN DATE,
 A_DELAYED_TILL OUT DATE,
 A_DELAY_VALUE  OUT NUMBER)
RETURN NUMBER IS

L_DELAY        INTEGER;
L_CURR_DIFF    INTEGER;
L_DELAYED_TILL TIMESTAMP WITH TIME ZONE;
L_PREV_WEEK_NR INTEGER;

CURSOR L_WEEK_ASC_CURSOR (A_DELAYED_FROM IN TIMESTAMP WITH TIME ZONE) IS
   SELECT DAY_OF_YEAR,WEEK_NR 
   FROM   UTWEEKNR
   WHERE DAY_OF_YEAR >= (TO_TIMESTAMP_TZ(TO_CHAR(TRUNC(A_DELAYED_FROM AT TIME ZONE DBTIMEZONE,'DD'),'DD/MM/YYYY HH24:MI:SS ')||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')AT TIME ZONE SESSIONTIMEZONE)
   ORDER BY DAY_OF_YEAR ASC;
L_WEEK_ASC_REC L_WEEK_ASC_CURSOR%ROWTYPE;

CURSOR L_WEEK_DESC_CURSOR (A_DELAYED_FROM IN TIMESTAMP WITH TIME ZONE) IS
   SELECT DAY_OF_YEAR,WEEK_NR 
   FROM   UTWEEKNR
   WHERE DAY_OF_YEAR <= (TO_TIMESTAMP_TZ(TO_CHAR(TRUNC(A_DELAYED_FROM AT TIME ZONE DBTIMEZONE,'DD'),'DD/MM/YYYY HH24:MI:SS ')||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')AT TIME ZONE SESSIONTIMEZONE)
   ORDER BY DAY_OF_YEAR DESC;
L_WEEK_DESC_REC L_WEEK_DESC_CURSOR%ROWTYPE;
L_REF_DATE      TIMESTAMP WITH TIME ZONE;

BEGIN

   L_REF_DATE := NVL(A_REF_DATE, CURRENT_TIMESTAMP);
   IF A_DELAY_UNIT = 'MI' THEN
      L_DELAYED_TILL := TRUNC(L_REF_DATE, 'MI') + (A_DELAY * ((1/24)/60));
   ELSIF A_DELAY_UNIT = 'HH' THEN
      L_DELAYED_TILL := TRUNC(L_REF_DATE, 'HH') + (A_DELAY * (1/24));
   ELSIF A_DELAY_UNIT = 'DD' THEN
      L_DELAYED_TILL := TRUNC(L_REF_DATE, 'DD') + A_DELAY;
   ELSIF A_DELAY_UNIT = 'MM' THEN
      L_DELAYED_TILL := ADD_MONTHS(TRUNC(L_REF_DATE,'MM'), A_DELAY);
   ELSIF A_DELAY_UNIT = 'MF' THEN
      L_DELAYED_TILL := ADD_MONTHS(TRUNC(L_REF_DATE,'DD'), A_DELAY);
   ELSIF A_DELAY_UNIT = 'YY' THEN 
      L_DELAYED_TILL := ADD_MONTHS(TRUNC(L_REF_DATE, 'YYYY'), A_DELAY*12);
   ELSIF A_DELAY_UNIT = 'YF' THEN 
      L_DELAYED_TILL := ADD_MONTHS(TRUNC(L_REF_DATE, 'DD'), A_DELAY*12);
   ELSIF A_DELAY_UNIT = 'WW' THEN
      L_DELAY := NVL(A_DELAY, 0);
      IF L_DELAY >= 0 THEN
         
         L_CURR_DIFF := 0;
         L_PREV_WEEK_NR := -1;
         FOR L_WEEK_ASC_REC IN L_WEEK_ASC_CURSOR(L_REF_DATE) LOOP
            IF L_WEEK_ASC_REC.WEEK_NR <> L_PREV_WEEK_NR THEN
               L_CURR_DIFF := L_CURR_DIFF + 1;
               L_DELAYED_TILL := L_WEEK_ASC_REC.DAY_OF_YEAR;
               L_PREV_WEEK_NR := L_WEEK_ASC_REC.WEEK_NR;
            END IF;
            EXIT WHEN L_CURR_DIFF-1 >= L_DELAY;         
         END LOOP;
         L_CURR_DIFF := L_CURR_DIFF - 1;

         IF L_CURR_DIFF < L_DELAY THEN
            RETURN(UNAPIGEN.DBERR_OUTOFCALENDAR);
         END IF;
      ELSE
         
         L_DELAY := -L_DELAY;

         L_CURR_DIFF := 0;
         L_PREV_WEEK_NR := -1;
         FOR L_WEEK_DESC_REC IN L_WEEK_DESC_CURSOR(L_REF_DATE) LOOP
            IF L_WEEK_DESC_REC.WEEK_NR <> L_PREV_WEEK_NR THEN
               L_CURR_DIFF := L_CURR_DIFF + 1;
               L_DELAYED_TILL := L_WEEK_DESC_REC.DAY_OF_YEAR;
               L_PREV_WEEK_NR := L_WEEK_DESC_REC.WEEK_NR;
            END IF;
            EXIT WHEN L_CURR_DIFF-1 >= L_DELAY;         
         END LOOP;
         L_CURR_DIFF := L_CURR_DIFF - 1;

         IF L_CURR_DIFF < L_DELAY THEN
            RETURN(UNAPIGEN.DBERR_OUTOFCALENDAR);
         END IF;
         
      END IF;
   ELSE 
      RETURN(UNAPIGEN.DBERR_DELAYUNIT);
   END IF;

   A_DELAYED_TILL := L_DELAYED_TILL;
   A_DELAY_VALUE := TO_DATE(TO_CHAR(L_DELAYED_TILL,'DD/MM/RR HH24:MI:SS'),'DD/MM/RR HH24:MI:SS') - TO_DATE(TO_CHAR(L_REF_DATE,'DD/MM/RR HH24:MI:SS'),'DD/MM/RR HH24:MI:SS');
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END CALCULATEDELAY;

PROCEDURE UPDATEAUTHORISATIONBUFFER       
(A_OBJECT_TP          IN        VARCHAR2, 
 A_OBJECT_ID          IN        VARCHAR2, 
 A_OBJECT_VERSION     IN        VARCHAR2, 
 A_NEW_SS             IN        VARCHAR2) 
IS

CURSOR L_SS_CURSOR IS
   SELECT ACTIVE, ALLOW_MODIFY
   FROM UTSS
   WHERE SS = A_NEW_SS;
L_SS_REC L_SS_CURSOR%ROWTYPE;

BEGIN
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = A_OBJECT_TP AND 
         UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = A_OBJECT_ID AND
         
         NVL(UNAPIGEN.PA_OBJECT_VERSION(L_SEQ_NO),' ') = NVL(A_OBJECT_VERSION,NVL(UNAPIGEN.PA_OBJECT_VERSION(L_SEQ_NO),' ')) THEN
         UNAPIGEN.PA_OBJECT_SS(L_SEQ_NO) := A_NEW_SS;

         OPEN L_SS_CURSOR;
         FETCH L_SS_CURSOR
         INTO L_SS_REC;
         IF L_SS_CURSOR%NOTFOUND THEN
            L_SS_REC.ACTIVE := '1';
            L_SS_REC.ALLOW_MODIFY := '0';
         END IF;
         CLOSE L_SS_CURSOR;
         
         UNAPIGEN.PA_OBJECT_ACTIVE(L_SEQ_NO) := L_SS_REC.ACTIVE;
         UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) := L_SS_REC.ALLOW_MODIFY;         
         
         
         UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO) := UNAPIGEN.DBERR_SUCCESS;         
         UNAPIGEN.LOGERRORNOREMOTEAPICALL('Unapiaut.UPDATEAUTHORISATIONBUFFER','AUTUP-1 OBJECT-ID: '||A_OBJECT_ID||' ACTIVE: '||L_SS_REC.ACTIVE||' ALLOW-MODIFY: '||l_ss_rec.allow_modify||' SS='||A_NEW_SS);
         EXIT;
         
      END IF;
   END LOOP;
EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   IF L_SS_CURSOR%ISOPEN THEN
      CLOSE L_SS_CURSOR;
   END IF;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'UpdateAuthorisationBuffer', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
END UPDATEAUTHORISATIONBUFFER;

PROCEDURE UPDATELCINAUTHORISATIONBUFFER    
(A_OBJECT_TP              IN        VARCHAR2,  
 A_OBJECT_ID              IN        VARCHAR2,  
 A_OBJECT_VERSION         IN        VARCHAR2,  
 A_NEW_OBJECT_LC          IN        VARCHAR2,  
 A_NEW_OBJECT_LC_VERSION  IN        VARCHAR2)  
IS


BEGIN
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = A_OBJECT_TP AND 
         UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = A_OBJECT_ID AND
         
         NVL(UNAPIGEN.PA_OBJECT_VERSION(L_SEQ_NO),' ') = NVL(A_OBJECT_VERSION,NVL(UNAPIGEN.PA_OBJECT_VERSION(L_SEQ_NO),' ')) THEN
         UNAPIGEN.PA_OBJECT_LC            (L_SEQ_NO) := A_NEW_OBJECT_LC;
         UNAPIGEN.PA_OBJECT_LC_VERSION    (L_SEQ_NO) := A_NEW_OBJECT_LC_VERSION;

         
         
         UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO) := UNAPIGEN.DBERR_SUCCESS;         
         EXIT;
         
      END IF;
   END LOOP;
EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'UpdateLcInAuthorisationBuffer', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
END UPDATELCINAUTHORISATIONBUFFER;

FUNCTION SQLGETSCMEALLOWMODIFY              
(A_SC             IN        VARCHAR2,       
 A_PG             IN        VARCHAR2,       
 A_PGNODE         IN        NUMBER,         
 A_PA             IN        VARCHAR2,       
 A_PANODE         IN        NUMBER,         
 A_ME             IN        VARCHAR2,       
 A_MENODE         IN        NUMBER,         
 A_REANALYSIS     IN        NUMBER)                
RETURN CHAR IS

L_REANALYSIS             NUMBER(3);
L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_SS                     VARCHAR2(2);
L_MT_VERSION             VARCHAR2(20);
L_ALLOW_MODIFY           CHAR(1);
L_LOG_HS                 CHAR(1);
L_LOG_HS_DETAILS         CHAR(1);
L_ACTIVE                 CHAR(1);
L_IGNORED_RET_CODE       INTEGER;
L_ORIG_AR_CHECK_MODE     INTEGER;

BEGIN
   L_IGNORED_RET_CODE := UNAPIAUT.GETARCHECKMODE(L_ORIG_AR_CHECK_MODE);
   L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK('1');
   L_RET_CODE := UNAPIAUT.GETSCMEAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, A_ME, A_MENODE, 
                                               A_REANALYSIS, L_MT_VERSION, L_LC, L_LC_VERSION, L_SS,
                                               L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);

   L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK(L_ORIG_AR_CHECK_MODE);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(NULL);
   END IF;

   RETURN(L_ALLOW_MODIFY);   

END SQLGETSCMEALLOWMODIFY;

FUNCTION SQLGETSCPAALLOWMODIFY              
(A_SC             IN        VARCHAR2,       
 A_PG             IN        VARCHAR2,       
 A_PGNODE         IN        NUMBER,         
 A_PA             IN        VARCHAR2,       
 A_PANODE         IN        NUMBER)         
RETURN CHAR IS

L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_SS                     VARCHAR2(2);
L_PR_VERSION             VARCHAR2(20);
L_ALLOW_MODIFY           CHAR(1);
L_LOG_HS                 CHAR(1);
L_LOG_HS_DETAILS         CHAR(1);
L_ACTIVE                 CHAR(1);
L_IGNORED_RET_CODE       INTEGER;
L_ORIG_AR_CHECK_MODE     INTEGER;
BEGIN

   L_IGNORED_RET_CODE := UNAPIAUT.GETARCHECKMODE(L_ORIG_AR_CHECK_MODE);
   L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK('1');
   L_RET_CODE := UNAPIAUT.GETSCPAAUTHORISATION(A_SC, A_PG, A_PGNODE, A_PA, A_PANODE, 
                                               L_PR_VERSION, L_LC, L_LC_VERSION, L_SS,
                                               L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);
   L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK(L_ORIG_AR_CHECK_MODE);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(NULL);
   END IF;

   RETURN(L_ALLOW_MODIFY);   

END SQLGETSCPAALLOWMODIFY;

FUNCTION SQLGETCHALLOWMODIFY                
(A_CH             IN        VARCHAR2)       
RETURN CHAR IS

L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_SS                     VARCHAR2(2);
L_CY_VERSION             VARCHAR2(20);
L_ALLOW_MODIFY           CHAR(1);
L_LOG_HS                 CHAR(1);
L_LOG_HS_DETAILS         CHAR(1);
L_ACTIVE                 CHAR(1);

BEGIN

   L_RET_CODE := UNAPIAUT.GETCHAUTHORISATION(A_CH, 
                                             L_CY_VERSION, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS, L_LOG_HS_DETAILS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(NULL);
   END IF;

   RETURN(L_ALLOW_MODIFY);   

END SQLGETCHALLOWMODIFY;

FUNCTION SQLGETOBJECTALLOWMODIFY            
(A_OBJECT_TP           IN        VARCHAR2,  
 A_OBJECT_ID           IN        VARCHAR2,  
 A_OBJECT_VERSION      IN        VARCHAR2)  
RETURN CHAR IS

L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_SS                     VARCHAR2(2);
L_PR_VERSION             VARCHAR2(20);
L_ALLOW_MODIFY           CHAR(1);
L_LOG_HS                 CHAR(1);
L_LOG_HS_DETAILS         CHAR(1);
L_ACTIVE                 CHAR(1);

BEGIN

L_RET_CODE := UNAPIGEN.GETAUTHORISATION(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION,
                                        L_LC, L_LC_VERSION, L_SS,
                                        L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(NULL);
   END IF;

   RETURN(L_ALLOW_MODIFY);   

END SQLGETOBJECTALLOWMODIFY;

PROCEDURE ADDORACLECBOHINT 
(A_SQL_STRING   IN OUT  VARCHAR2)      
IS
   L_SELECT_CLAUSE     VARCHAR2 (2000);
   L_FROM_CLAUSE       VARCHAR2 (2000);
   L_NEW_FROM_CLAUSE   VARCHAR2 (2000);
   L_WHERE_CLAUSE      VARCHAR2 (2000);
   L_FROM_KEYW_POS     NUMBER;
   L_WHERE_KEYW_POS    NUMBER;
   L_TABLE_START_POS   NUMBER;
   L_TABLE_END_POS     NUMBER;
   L_NESTEDLOOP_TABLE  VARCHAR2 (2000);
   L_FIELD             VARCHAR2 (2000);
BEGIN
   
   IF P_OPTIMIZER_MODE = 'RULE' THEN
      
      RETURN ;
   END IF ;

   IF INSTR (A_SQL_STRING, 'SELECT /*+ RULE */ ') <> 0 THEN 
      RETURN ;
   END IF  ;

   L_FROM_KEYW_POS := INSTR (UPPER (A_SQL_STRING), ' FROM ');
   L_SELECT_CLAUSE :=
                    LTRIM (RTRIM (SUBSTR (A_SQL_STRING, 1, L_FROM_KEYW_POS)));

   
   A_SQL_STRING := REPLACE(L_SELECT_CLAUSE, 'SELECT ', 'SELECT /*+ RULE */ ') || 
                   SUBSTR(A_SQL_STRING, L_FROM_KEYW_POS) ;

   RETURN ;

   

   
   
   L_WHERE_KEYW_POS :=
                     INSTR (UPPER (A_SQL_STRING), ' WHERE ', L_FROM_KEYW_POS);

   IF L_WHERE_KEYW_POS = 0 THEN 
      L_WHERE_KEYW_POS :=
                     INSTR (UPPER (A_SQL_STRING), ' ORDER ', L_FROM_KEYW_POS);
   END IF ;

   L_FROM_CLAUSE :=
      SUBSTR (A_SQL_STRING,
              L_FROM_KEYW_POS + 1,
              L_WHERE_KEYW_POS - L_FROM_KEYW_POS
             );
   L_FROM_CLAUSE := SUBSTR (L_FROM_CLAUSE, 6);
   L_WHERE_CLAUSE := SUBSTR (A_SQL_STRING, L_WHERE_KEYW_POS + 1);
   L_TABLE_START_POS := 1;
   L_TABLE_END_POS := INSTR (L_FROM_CLAUSE, ',');

   IF L_TABLE_END_POS = 0
   THEN
      
      RETURN ;
   END IF;

   L_NEW_FROM_CLAUSE :=
      LTRIM (RTRIM (SUBSTR (L_FROM_CLAUSE,
                            L_TABLE_START_POS,
                            L_TABLE_END_POS - L_TABLE_START_POS
                           )
                   )
            );

   
   L_NESTEDLOOP_TABLE := LTRIM (RTRIM (SUBSTR (L_NEW_FROM_CLAUSE, INSTR (L_NEW_FROM_CLAUSE, ' '))));

   
   WHILE L_TABLE_END_POS > 0
   LOOP
      L_TABLE_START_POS := L_TABLE_END_POS;
      L_TABLE_END_POS := INSTR (L_FROM_CLAUSE, ',', L_TABLE_START_POS + 1);

      IF L_TABLE_END_POS > 0
      THEN
         L_FIELD :=
            LTRIM (RTRIM (SUBSTR (L_FROM_CLAUSE,
                                  L_TABLE_START_POS + 1,
                                  L_TABLE_END_POS - (L_TABLE_START_POS + 1)
                                 )
                         )
                  );
      ELSE
         L_FIELD :=
                LTRIM (RTRIM (SUBSTR (L_FROM_CLAUSE, L_TABLE_START_POS + 1)));
      END IF;

      L_NEW_FROM_CLAUSE := L_FIELD || ', ' || L_NEW_FROM_CLAUSE;
   END LOOP;

   
   L_SELECT_CLAUSE :=
         'SELECT /*+ ORDERED USE_NL('
      || L_NESTEDLOOP_TABLE
      || ') */ '
      || SUBSTR (A_SQL_STRING, 8, L_FROM_KEYW_POS - 8);

   
   A_SQL_STRING := L_SELECT_CLAUSE || ' FROM ' || L_NEW_FROM_CLAUSE || ' ' || L_WHERE_CLAUSE;

   RETURN;
END ADDORACLECBOHINT;

FUNCTION INITRTSTBUFFER (A_RT IN VARCHAR2,                                                               
                         A_RT_VERSION IN VARCHAR2)
   RETURN NUMBER
IS
   CURSOR L_RTST_CURSOR (C_RT VARCHAR2, C_RT_VERSION VARCHAR2)
   IS
      SELECT   RT, VERSION, ST, ST_VERSION, SEQ, NR_PLANNED_SC, DELAY, DELAY_UNIT, FREQ_TP, FREQ_VAL, FREQ_UNIT,
               INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL, INHERIT_AU
          FROM UTRTST
         WHERE RT = C_RT AND VERSION = C_RT_VERSION
      ORDER BY SEQ;
BEGIN
   FOR L_REC IN L_RTST_CURSOR (A_RT, A_RT_VERSION)
   LOOP
      BEGIN
         INSERT INTO UTRTSTBUFFER
                     (RT, VERSION, ST, ST_VERSION, SEQ, NR_PLANNED_SC,
                      DELAY, DELAY_UNIT, FREQ_TP, FREQ_VAL, FREQ_UNIT,
                      INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL,
                      INHERIT_AU
                     )
              VALUES (L_REC.RT, L_REC.VERSION, L_REC.ST, L_REC.ST_VERSION, L_REC.SEQ, L_REC.NR_PLANNED_SC,
                      L_REC.DELAY, L_REC.DELAY_UNIT, L_REC.FREQ_TP, L_REC.FREQ_VAL, L_REC.FREQ_UNIT,
                      L_REC.INVERT_FREQ, L_REC.LAST_SCHED, L_REC.LAST_SCHED_TZ, L_REC.LAST_CNT, L_REC.LAST_VAL,
                      L_REC.INHERIT_AU
                     );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;                                          
      END;
   END LOOP;

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN OTHERS
   THEN
      UNAPIGEN.LOGERROR ('InitRtStBuffer', SQLERRM);
      RETURN (UNAPIGEN.DBERR_GENFAIL);
END INITRTSTBUFFER;

FUNCTION INITSTPPBUFFER (A_ST IN VARCHAR2,                                                               
                                          A_ST_VERSION IN VARCHAR2)
   RETURN NUMBER
IS
   CURSOR L_STPP_CURSOR (C_ST VARCHAR2, C_ST_VERSION VARCHAR2)
   IS
      SELECT   ST, VERSION, PP, PP_VERSION, SEQ, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ,
               LAST_CNT, LAST_VAL, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5
          FROM UTSTPP
         WHERE ST = C_ST AND VERSION = C_ST_VERSION
      ORDER BY SEQ;
BEGIN
   FOR L_REC IN L_STPP_CURSOR (A_ST, A_ST_VERSION)
   LOOP
      BEGIN
         INSERT INTO UTSTPPBUFFER
                     (ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2,
                      PP_KEY3, PP_KEY4, PP_KEY5, SEQ, FREQ_TP, FREQ_VAL,
                      FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT,
                      LAST_VAL
                     )
              VALUES (L_REC.ST, L_REC.VERSION, L_REC.PP, L_REC.PP_VERSION, L_REC.PP_KEY1, L_REC.PP_KEY2,
                      L_REC.PP_KEY3, L_REC.PP_KEY4, L_REC.PP_KEY5, L_REC.SEQ, L_REC.FREQ_TP, L_REC.FREQ_VAL,
                      L_REC.FREQ_UNIT, L_REC.INVERT_FREQ, L_REC.LAST_SCHED, L_REC.LAST_SCHED_TZ, L_REC.LAST_CNT,
                      L_REC.LAST_VAL
                     );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;                                          
      END;
   END LOOP;

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN OTHERS
   THEN
      UNAPIGEN.LOGERROR ('InitStPpBuffer', SQLERRM);
      RETURN (UNAPIGEN.DBERR_GENFAIL);
END INITSTPPBUFFER;

FUNCTION INITSTPRFREQBUFFER (
   A_ST           IN   VARCHAR2,                                                                         
   A_ST_VERSION   IN   VARCHAR2,                                                                         
   A_PP           IN   VARCHAR2,
   A_PP_VERSION   IN   VARCHAR2,
   A_PP_KEY1      IN   VARCHAR2,
   A_PP_KEY2      IN   VARCHAR2,
   A_PP_KEY3      IN   VARCHAR2,
   A_PP_KEY4      IN   VARCHAR2,
   A_PP_KEY5      IN   VARCHAR2,
   A_PR           IN   VARCHAR2,                                                                         
   A_PR_VERSION   IN   VARCHAR2
)
   RETURN NUMBER
IS
   CURSOR L_STPRFREQ_CURSOR (
      C_ST           VARCHAR2,
      C_ST_VERSION   VARCHAR2,
      C_PP           VARCHAR2,
      C_PP_VERSION   VARCHAR2,
      C_PP_KEY1      VARCHAR2,
      C_PP_KEY2      VARCHAR2,
      C_PP_KEY3      VARCHAR2,
      C_PP_KEY4      VARCHAR2,
      C_PP_KEY5      VARCHAR2,
      C_PR           VARCHAR2,
      C_PR_VERSION   VARCHAR2
   )
   IS
      SELECT ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR, PR_VERSION, FREQ_TP,
             FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL
        FROM UTSTPRFREQ
       WHERE ST = C_ST
         AND VERSION = C_ST_VERSION
         AND PP = C_PP
         AND NVL (PP_VERSION, '~Current~') = NVL (C_PP_VERSION, '~Current~')
         AND PP_KEY1 = C_PP_KEY1
         AND PP_KEY2 = C_PP_KEY2
         AND PP_KEY3 = C_PP_KEY3
         AND PP_KEY4 = C_PP_KEY4
         AND PP_KEY5 = C_PP_KEY5
         AND PR = C_PR
         AND NVL (PR_VERSION, '~Current~') = NVL (C_PR_VERSION, '~Current~');
BEGIN
   FOR L_REC IN L_STPRFREQ_CURSOR (A_ST,
                                   A_ST_VERSION,
                                   A_PP,
                                   A_PP_VERSION,
                                   A_PP_KEY1,
                                   A_PP_KEY2,
                                   A_PP_KEY3,
                                   A_PP_KEY4,
                                   A_PP_KEY5,
                                   A_PR,
                                   A_PR_VERSION
                                  )
   LOOP
      BEGIN
         INSERT INTO UTSTPRFREQBUFFER
                     (ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4,
                      PP_KEY5, PR, PR_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT,
                      INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL
                     )
              VALUES (A_ST, A_ST_VERSION, A_PP, L_REC.PP_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4,
                      A_PP_KEY5, A_PR, A_PR_VERSION, L_REC.FREQ_TP, L_REC.FREQ_VAL, L_REC.FREQ_UNIT,
                      L_REC.INVERT_FREQ, L_REC.LAST_SCHED, L_REC.LAST_SCHED_TZ, L_REC.LAST_CNT, L_REC.LAST_VAL
                     );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;                                          
      END;
   END LOOP;

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN OTHERS
   THEN
      UNAPIGEN.LOGERROR ('InitStPrFreqBuffer', SQLERRM);
      RETURN (UNAPIGEN.DBERR_GENFAIL);
END INITSTPRFREQBUFFER;

FUNCTION INITSTPRPPINPPFREQBUFFER (
   A_ST           IN   VARCHAR2,                                                                         
   A_ST_VERSION   IN   VARCHAR2,                                                                         
   A_PP           IN   VARCHAR2,
   A_PP_VERSION   IN   VARCHAR2,
   A_PP_KEY1      IN   VARCHAR2,
   A_PP_KEY2      IN   VARCHAR2,
   A_PP_KEY3      IN   VARCHAR2,
   A_PP_KEY4      IN   VARCHAR2,
   A_PP_KEY5      IN   VARCHAR2,
   A_PR           IN   VARCHAR2,                                                                         
   A_PR_VERSION   IN   VARCHAR2
)
   RETURN NUMBER
IS
   CURSOR L_STPRPPINPPFREQ_CURSOR (
      C_ST           VARCHAR2,
      C_ST_VERSION   VARCHAR2,
      C_PP           VARCHAR2,
      C_PP_VERSION   VARCHAR2,
      C_PP_KEY1      VARCHAR2,
      C_PP_KEY2      VARCHAR2,
      C_PP_KEY3      VARCHAR2,
      C_PP_KEY4      VARCHAR2,
      C_PP_KEY5      VARCHAR2,
      C_PR           VARCHAR2,
      C_PR_VERSION   VARCHAR2
   )
   IS
      SELECT ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR, PR_VERSION, FREQ_TP,
             FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL
        FROM UTSTPRFREQ
       WHERE ST = C_ST
         AND VERSION = C_ST_VERSION
         AND PP = C_PP
         AND PP_VERSION = C_PP_VERSION
         AND PP_KEY1 = C_PP_KEY1
         AND PP_KEY2 = C_PP_KEY2
         AND PP_KEY3 = C_PP_KEY3
         AND PP_KEY4 = C_PP_KEY4
         AND PP_KEY5 = C_PP_KEY5
         AND PR = C_PR
         AND PR_VERSION = C_PR_VERSION;
BEGIN
   FOR L_REC IN L_STPRPPINPPFREQ_CURSOR (A_ST,
                                         A_ST_VERSION,
                                         A_PP,
                                         A_PP_VERSION,
                                         A_PP_KEY1,
                                         A_PP_KEY2,
                                         A_PP_KEY3,
                                         A_PP_KEY4,
                                         A_PP_KEY5,
                                         A_PR,
                                         A_PR_VERSION
                                        )
   LOOP
      BEGIN
         INSERT INTO UTSTPRFREQBUFFER
                     (ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4,
                      PP_KEY5, PR, PR_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT,
                      INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL
                     )
              VALUES (A_ST, A_ST_VERSION, A_PP, L_REC.PP_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4,
                      A_PP_KEY5, A_PR, A_PR_VERSION, L_REC.FREQ_TP, L_REC.FREQ_VAL, L_REC.FREQ_UNIT,
                      L_REC.INVERT_FREQ, L_REC.LAST_SCHED, L_REC.LAST_SCHED_TZ, L_REC.LAST_CNT, L_REC.LAST_VAL
                     );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;                                          
      END;
   END LOOP;

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN OTHERS
   THEN
      UNAPIGEN.LOGERROR ('InitStPrPpInPpFreqBuffer', SQLERRM);
      RETURN (UNAPIGEN.DBERR_GENFAIL);
END INITSTPRPPINPPFREQBUFFER;

FUNCTION INITSTMTFREQBUFFER (
   A_ST           IN   VARCHAR2,                                                                         
   A_ST_VERSION   IN   VARCHAR2,                                                                         
   A_PR           IN   VARCHAR2,                                                                         
   A_PR_VERSION   IN   VARCHAR2,                                                                         
   A_MT           IN   VARCHAR2,
   A_MT_VERSION   IN   VARCHAR2
)
   RETURN NUMBER
IS
   CURSOR L_STMTFREQ_CURSOR (
      C_ST           VARCHAR2,
      C_ST_VERSION   VARCHAR2,
      C_PR           VARCHAR2,
      C_PR_VERSION   VARCHAR2,
      C_MT           VARCHAR2,
      C_MT_VERSION   VARCHAR2
   )
   IS
      SELECT ST, VERSION, PR, PR_VERSION, MT, MT_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED,
             LAST_SCHED_TZ, LAST_CNT, LAST_VAL
        FROM UTSTMTFREQ
       WHERE ST = C_ST
         AND VERSION = C_ST_VERSION
         AND PR = C_PR
         AND NVL (PR_VERSION, '~Current~') = NVL (C_PR_VERSION, '~Current~')
         AND MT = C_MT
         AND NVL (MT_VERSION, '~Current~') = NVL (C_MT_VERSION, '~Current~');
BEGIN
   FOR L_REC IN L_STMTFREQ_CURSOR (A_ST, A_ST_VERSION, A_PR, A_PR_VERSION, A_MT, A_MT_VERSION)
   LOOP
      BEGIN
         INSERT INTO UTSTMTFREQBUFFER
                     (ST, VERSION, PR, PR_VERSION, MT, MT_VERSION, FREQ_TP,
                      FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ,
                      LAST_CNT, LAST_VAL
                     )
              VALUES (A_ST, A_ST_VERSION, A_PR, L_REC.PR_VERSION, A_MT, L_REC.MT_VERSION, L_REC.FREQ_TP,
                      L_REC.FREQ_VAL, L_REC.FREQ_UNIT, L_REC.INVERT_FREQ, L_REC.LAST_SCHED, L_REC.LAST_SCHED_TZ,
                      L_REC.LAST_CNT, L_REC.LAST_VAL
                     );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;                                          
      END;
   END LOOP;

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN OTHERS
   THEN
      UNAPIGEN.LOGERROR ('InitStMtFreqBuffer', SQLERRM);
      RETURN (UNAPIGEN.DBERR_GENFAIL);
END INITSTMTFREQBUFFER;

FUNCTION INITPPPRBUFFER (
   A_PP           IN   VARCHAR2,
   A_PP_VERSION   IN   VARCHAR2,
   A_PP_KEY1      IN   VARCHAR2,
   A_PP_KEY2      IN   VARCHAR2,
   A_PP_KEY3      IN   VARCHAR2,
   A_PP_KEY4      IN   VARCHAR2,
   A_PP_KEY5      IN   VARCHAR2
)
   RETURN NUMBER
IS
   CURSOR L_PPPRFREQ_CURSOR (
      C_PP           VARCHAR2,
      C_PP_VERSION   VARCHAR2,
      C_PP_KEY1      VARCHAR2,
      C_PP_KEY2      VARCHAR2,
      C_PP_KEY3      VARCHAR2,
      C_PP_KEY4      VARCHAR2,
      C_PP_KEY5      VARCHAR2
   )
   IS
      SELECT A.SEQ, A.PP, A.VERSION PP_VERSION, A.PR, A.PR_VERSION, A.NR_MEASUR, A.DELAY, A.DELAY_UNIT, A.ALLOW_ADD,
             A.FREQ_TP, A.FREQ_VAL, A.FREQ_UNIT, A.INVERT_FREQ, A.ST_BASED_FREQ, A.LAST_SCHED, A.LAST_SCHED_TZ,
             A.LAST_CNT, A.LAST_VAL, A.INHERIT_AU, '0' INHERITED, A.PP_KEY1, A.PP_KEY2, A.PP_KEY3, A.PP_KEY4,
             A.PP_KEY5, A.MT, A.MT_VERSION
        FROM UTPPPR A
       WHERE A.PP = A_PP
         AND A.VERSION = C_PP_VERSION
         AND A.PP_KEY1 = C_PP_KEY1
         AND A.PP_KEY2 = C_PP_KEY2
         AND A.PP_KEY3 = C_PP_KEY3
         AND A.PP_KEY4 = C_PP_KEY4
         AND A.PP_KEY5 = C_PP_KEY5
         AND A.IS_PP = '0';
BEGIN
   FOR L_REC IN L_PPPRFREQ_CURSOR (A_PP, A_PP_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5)
   LOOP
      BEGIN
         INSERT INTO UTPPPRBUFFER
                     (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR,
                      PR_VERSION, SEQ, NR_MEASUR, DELAY, DELAY_UNIT, ALLOW_ADD,
                      IS_PP, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, ST_BASED_FREQ,
                      LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL, INHERIT_AU,
                      MT, MT_VERSION
                     )
              VALUES (L_REC.PP, L_REC.PP_VERSION, L_REC.PP_KEY1, L_REC.PP_KEY2, L_REC.PP_KEY3, L_REC.PP_KEY4, L_REC.PP_KEY5, L_REC.PR,
                      L_REC.PR_VERSION, L_REC.SEQ, L_REC.NR_MEASUR, L_REC.DELAY, L_REC.DELAY_UNIT, L_REC.ALLOW_ADD,
                      '0', L_REC.FREQ_TP, L_REC.FREQ_VAL, L_REC.FREQ_UNIT, L_REC.INVERT_FREQ, L_REC.ST_BASED_FREQ,
                      L_REC.LAST_SCHED, L_REC.LAST_SCHED_TZ, L_REC.LAST_CNT, L_REC.LAST_VAL, L_REC.INHERIT_AU,
                      L_REC.MT, L_REC.MT_VERSION
                     );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;                                          
      END;
   END LOOP;

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN OTHERS
   THEN
      UNAPIGEN.LOGERROR ('InitPpPrBuffer', SQLERRM);
      RETURN (UNAPIGEN.DBERR_GENFAIL);
END INITPPPRBUFFER;

FUNCTION INITPPINPPBUFFER (
   A_PP           IN   VARCHAR2,
   A_PP_VERSION   IN   VARCHAR2,
   A_PP_KEY1      IN   VARCHAR2,
   A_PP_KEY2      IN   VARCHAR2,
   A_PP_KEY3      IN   VARCHAR2,
   A_PP_KEY4      IN   VARCHAR2,
   A_PP_KEY5      IN   VARCHAR2
)
   RETURN NUMBER
IS
   CURSOR L_PPINPP_CURSOR (
      C_PP           VARCHAR2,
      C_PP_VERSION   VARCHAR2,
      C_PP_KEY1      VARCHAR2,
      C_PP_KEY2      VARCHAR2,
      C_PP_KEY3      VARCHAR2,
      C_PP_KEY4      VARCHAR2,
      C_PP_KEY5      VARCHAR2
   )
   IS
      SELECT A.PR PP, A.PR_VERSION PP_VERSION, A.PP PARENT_PP, A.VERSION PARENT_PP_VERSION, A.PP_KEY1 PARENT_PP_KEY1,
             A.PP_KEY2 PARENT_PP_KEY2, A.PP_KEY3 PARENT_PP_KEY3, A.PP_KEY4 PARENT_PP_KEY4, A.PP_KEY5 PARENT_PP_KEY5,
             A.SEQ, A.FREQ_TP, A.FREQ_VAL, A.FREQ_UNIT, A.INVERT_FREQ, A.LAST_SCHED, A.LAST_SCHED_TZ, A.LAST_CNT,
             A.LAST_VAL, A.ST_BASED_FREQ
        FROM UTPPPR A
       WHERE A.PP = A_PP
         AND A.VERSION = C_PP_VERSION
         AND A.PP_KEY1 = C_PP_KEY1
         AND A.PP_KEY2 = C_PP_KEY2
         AND A.PP_KEY3 = C_PP_KEY3
         AND A.PP_KEY4 = C_PP_KEY4
         AND A.PP_KEY5 = C_PP_KEY5
         AND A.IS_PP = '1';
BEGIN
   FOR L_REC IN L_PPINPP_CURSOR (A_PP, A_PP_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5)
   LOOP
      BEGIN
         INSERT INTO UTPPPRBUFFER
                     (PP, VERSION, PP_KEY1, PP_KEY2,
                      PP_KEY3, PP_KEY4, PP_KEY5, PR, PR_VERSION,
                      SEQ, IS_PP, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ,
                      ST_BASED_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL
                     )
              VALUES (L_REC.PARENT_PP, L_REC.PARENT_PP_VERSION, L_REC.PARENT_PP_KEY1, L_REC.PARENT_PP_KEY2,
                      L_REC.PARENT_PP_KEY3, L_REC.PARENT_PP_KEY4, L_REC.PARENT_PP_KEY5, L_REC.PP, L_REC.PP_VERSION,
                      L_REC.SEQ, '1', L_REC.FREQ_TP, L_REC.FREQ_VAL, L_REC.FREQ_UNIT, L_REC.INVERT_FREQ,
                      L_REC.ST_BASED_FREQ, L_REC.LAST_SCHED, L_REC.LAST_SCHED_TZ, L_REC.LAST_CNT, L_REC.LAST_VAL
                     );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;                                          
      END;
   END LOOP;

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN OTHERS
   THEN
      UNAPIGEN.LOGERROR ('InitPpInPpBuffer', SQLERRM);
      RETURN (UNAPIGEN.DBERR_GENFAIL);
END INITPPINPPBUFFER;

FUNCTION INITPRMTBUFFER (A_PR IN VARCHAR2, A_VERSION IN VARCHAR2)
   RETURN NUMBER
IS
   CURSOR L_PRMT_CURSOR (C_PR VARCHAR2, C_PR_VERSION VARCHAR2)
   IS
      SELECT   A.PR, A.VERSION, A.MT, A.MT_VERSION, A.SEQ, A.FREQ_TP, A.FREQ_VAL, A.FREQ_UNIT, A.INVERT_FREQ,
               A.ST_BASED_FREQ, A.LAST_SCHED, A.LAST_SCHED_TZ, A.LAST_CNT, A.LAST_VAL, A.IGNORE_OTHER
          FROM UTPRMT A
         WHERE A.PR = C_PR AND A.VERSION = C_PR_VERSION
      ORDER BY A.SEQ;
BEGIN
   FOR L_REC IN L_PRMT_CURSOR (A_PR, A_VERSION)
   LOOP
      BEGIN
         INSERT INTO UTPRMTBUFFER
                     (PR, VERSION, MT, MT_VERSION, SEQ, FREQ_TP, FREQ_VAL,
                      FREQ_UNIT, INVERT_FREQ, ST_BASED_FREQ, LAST_SCHED, LAST_SCHED_TZ,
                      LAST_CNT, LAST_VAL, IGNORE_OTHER
                     )
              VALUES (L_REC.PR, L_REC.VERSION, L_REC.MT, L_REC.MT_VERSION, L_REC.SEQ, L_REC.FREQ_TP, L_REC.FREQ_VAL,
                      L_REC.FREQ_UNIT, L_REC.INVERT_FREQ, L_REC.ST_BASED_FREQ, L_REC.LAST_SCHED, L_REC.LAST_SCHED_TZ,
                      L_REC.LAST_CNT, L_REC.LAST_VAL, L_REC.IGNORE_OTHER
                     );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;                                          
      END;
   END LOOP;

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN OTHERS
   THEN
      UNAPIGEN.LOGERROR ('InitPrMtBuffer', SQLERRM);
      RETURN (UNAPIGEN.DBERR_GENFAIL);
END INITPRMTBUFFER;

FUNCTION INITSTIPBUFFER (A_ST IN VARCHAR2, A_VERSION IN VARCHAR2)
   RETURN NUMBER
IS
   CURSOR L_STIP_CURSOR (C_ST VARCHAR2, C_ST_VERSION VARCHAR2)
   IS
		SELECT ST, VERSION, IP, IP_VERSION, SEQ, IS_PROTECTED, HIDDEN, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, 
		       LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL, INHERIT_AU
         FROM UTSTIP
         WHERE ST = C_ST AND VERSION = C_ST_VERSION
      ORDER BY SEQ;
BEGIN
   FOR L_REC IN L_STIP_CURSOR (A_ST, A_VERSION)
   LOOP
      BEGIN
         INSERT INTO UTSTIPBUFFER
                     ( ST, VERSION, IP, IP_VERSION, SEQ, IS_PROTECTED, HIDDEN, FREQ_TP, FREQ_VAL, FREQ_UNIT, 
                       INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL, INHERIT_AU)
              VALUES ( L_REC.ST, L_REC.VERSION, L_REC.IP, L_REC.IP_VERSION, L_REC.SEQ, L_REC.IS_PROTECTED, L_REC.HIDDEN, 
              			  L_REC.FREQ_TP, L_REC.FREQ_VAL, L_REC.FREQ_UNIT, L_REC.INVERT_FREQ, L_REC.LAST_SCHED, L_REC.LAST_SCHED_TZ, 
              			  L_REC.LAST_CNT, L_REC.LAST_VAL, L_REC.INHERIT_AU );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;                                          
      END;
   END LOOP;

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN OTHERS
   THEN
      UNAPIGEN.LOGERROR ('InitStIpBuffer', SQLERRM);
      RETURN (UNAPIGEN.DBERR_GENFAIL);
END INITSTIPBUFFER;

FUNCTION EVALFREQBUFFER
   RETURN NUMBER
IS
   CURSOR L_RTST_CURSOR
   IS
      SELECT   RT, VERSION, ST, ST_VERSION, SEQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL
          FROM UTRTSTBUFFER
         WHERE HANDLED = 'Y'
      ORDER BY RT, VERSION, ST, SEQ;                                             

   CURSOR L_STPP_CURSOR
   IS
      SELECT   ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, SEQ, LAST_SCHED,
               LAST_SCHED_TZ, LAST_CNT, LAST_VAL
          FROM UTSTPPBUFFER
         WHERE HANDLED = 'Y'
      ORDER BY ST, VERSION, PP, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, SEQ;

   
   CURSOR L_STPRFREQ_CURSOR
   IS
      SELECT   ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR, PR_VERSION, FREQ_TP,
               FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL
          FROM UTSTPRFREQBUFFER
         WHERE HANDLED = 'Y'
      ORDER BY ST, VERSION, PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR, PR_VERSION;

   
   CURSOR L_STMTFREQ_CURSOR
   IS
      SELECT   ST, VERSION, PR, PR_VERSION, MT, MT_VERSION, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED,
               LAST_SCHED_TZ, LAST_CNT, LAST_VAL
          FROM UTSTMTFREQBUFFER
         WHERE HANDLED = 'Y'
      ORDER BY ST, VERSION, PR, PR_VERSION, MT, MT_VERSION;                      

   CURSOR L_PRMTFREQ_CURSOR
   IS
      SELECT   PR, VERSION, MT, SEQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL
          FROM UTPRMTBUFFER
         WHERE HANDLED = 'Y'
      ORDER BY PR, VERSION, MT, SEQ;                                             

   CURSOR L_PPPR_CURSOR
   IS
      SELECT   PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR, SEQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT,
               LAST_VAL
          FROM UTPPPRBUFFER
         WHERE HANDLED = 'Y'
      ORDER BY PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR, SEQ;

   CURSOR L_STIP_CURSOR
   IS
      SELECT   ST, VERSION, IP, IP_VERSION, SEQ, IS_PROTECTED, HIDDEN, FREQ_TP, FREQ_VAL, FREQ_UNIT, 
               INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL, INHERIT_AU
  		    FROM UTSTIPBUFFER
         WHERE HANDLED = 'Y'
      ORDER BY ST, VERSION, IP, SEQ;


BEGIN
   FOR L_STMTFREQ_REC IN L_STMTFREQ_CURSOR
   LOOP
      BEGIN
         UPDATE UTSTMTFREQ
            SET LAST_SCHED = L_STMTFREQ_REC.LAST_SCHED,
                LAST_SCHED_TZ = L_STMTFREQ_REC.LAST_SCHED_TZ,
                LAST_CNT = L_STMTFREQ_REC.LAST_CNT,
                LAST_VAL = L_STMTFREQ_REC.LAST_VAL
          WHERE ST = L_STMTFREQ_REC.ST
            AND VERSION = L_STMTFREQ_REC.VERSION
            AND PR = L_STMTFREQ_REC.PR
            AND PR_VERSION = L_STMTFREQ_REC.PR_VERSION
            AND MT = L_STMTFREQ_REC.MT
            AND MT_VERSION = L_STMTFREQ_REC.MT_VERSION;

         IF SQL%ROWCOUNT = 0                                         
         THEN
            INSERT INTO UTSTMTFREQ
                        (ST, VERSION, PR, PR_VERSION,
                         MT, MT_VERSION, FREQ_TP,
                         FREQ_VAL, FREQ_UNIT, INVERT_FREQ,
                         LAST_SCHED, LAST_SCHED_TZ, LAST_CNT,
                         LAST_VAL
                        )
                 VALUES (L_STMTFREQ_REC.ST, L_STMTFREQ_REC.VERSION, L_STMTFREQ_REC.PR, L_STMTFREQ_REC.PR_VERSION,
                         L_STMTFREQ_REC.MT, L_STMTFREQ_REC.MT_VERSION, L_STMTFREQ_REC.FREQ_TP,
                         L_STMTFREQ_REC.FREQ_VAL, L_STMTFREQ_REC.FREQ_UNIT, L_STMTFREQ_REC.INVERT_FREQ,
                         L_STMTFREQ_REC.LAST_SCHED, L_STMTFREQ_REC.LAST_SCHED_TZ, L_STMTFREQ_REC.LAST_CNT,
                         L_STMTFREQ_REC.LAST_VAL
                        );
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            UNAPIGEN.LOGERROR ('EvalFreqBuffer', SQLERRM);
      END;
   END LOOP;
   
   
   DELETE UTSTMTFREQBUFFER;

   FOR L_PRMTFREQ_REC IN L_PRMTFREQ_CURSOR
   LOOP
      BEGIN
         UPDATE UTPRMT
            SET LAST_SCHED = L_PRMTFREQ_REC.LAST_SCHED,
                LAST_SCHED_TZ =
                             DECODE (L_PRMTFREQ_REC.LAST_SCHED,
                                     LAST_SCHED_TZ, LAST_SCHED_TZ,
                                     L_PRMTFREQ_REC.LAST_SCHED
                                    ),
                LAST_CNT = L_PRMTFREQ_REC.LAST_CNT,
                LAST_VAL = L_PRMTFREQ_REC.LAST_VAL
          WHERE PR = L_PRMTFREQ_REC.PR
            AND VERSION = L_PRMTFREQ_REC.VERSION
            AND MT = L_PRMTFREQ_REC.MT
            AND SEQ = L_PRMTFREQ_REC.SEQ;
      EXCEPTION
         WHEN OTHERS
         THEN
            UNAPIGEN.LOGERROR ('EvalFreqBuffer', SQLERRM);
      END;
   END LOOP;
   
   
   DELETE UTPRMTBUFFER;

   FOR L_STPRFREQ_REC IN L_STPRFREQ_CURSOR
   LOOP
      BEGIN
         UPDATE UTSTPRFREQ
            SET LAST_SCHED = L_STPRFREQ_REC.LAST_SCHED,
                LAST_SCHED_TZ = L_STPRFREQ_REC.LAST_SCHED_TZ,
                LAST_CNT = L_STPRFREQ_REC.LAST_CNT,
                LAST_VAL = L_STPRFREQ_REC.LAST_VAL
          WHERE ST = L_STPRFREQ_REC.ST
            AND VERSION = L_STPRFREQ_REC.VERSION
            AND PP = L_STPRFREQ_REC.PP
            AND PP_VERSION = L_STPRFREQ_REC.PP_VERSION
            AND PP_KEY1 = L_STPRFREQ_REC.PP_KEY1
            AND PP_KEY2 = L_STPRFREQ_REC.PP_KEY2
            AND PP_KEY3 = L_STPRFREQ_REC.PP_KEY3
            AND PP_KEY4 = L_STPRFREQ_REC.PP_KEY4
            AND PP_KEY5 = L_STPRFREQ_REC.PP_KEY5
            AND PR = L_STPRFREQ_REC.PR
            AND PR_VERSION = L_STPRFREQ_REC.PR_VERSION;

         IF SQL%ROWCOUNT = 0                                         
         THEN
            INSERT INTO UTSTPRFREQ
                        (ST, VERSION, PP, PP_VERSION,
                         PP_KEY1, PP_KEY2, PP_KEY3,
                         PP_KEY4, PP_KEY5, PR, PR_VERSION,
                         FREQ_TP, FREQ_VAL, FREQ_UNIT,
                         INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ,
                         LAST_CNT, LAST_VAL
                        )
                 VALUES (L_STPRFREQ_REC.ST, L_STPRFREQ_REC.VERSION, L_STPRFREQ_REC.PP, L_STPRFREQ_REC.PP_VERSION,
                         L_STPRFREQ_REC.PP_KEY1, L_STPRFREQ_REC.PP_KEY2, L_STPRFREQ_REC.PP_KEY3,
                         L_STPRFREQ_REC.PP_KEY4, L_STPRFREQ_REC.PP_KEY5, L_STPRFREQ_REC.PR, L_STPRFREQ_REC.PR_VERSION,
                         L_STPRFREQ_REC.FREQ_TP, L_STPRFREQ_REC.FREQ_VAL, L_STPRFREQ_REC.FREQ_UNIT,
                         L_STPRFREQ_REC.INVERT_FREQ, L_STPRFREQ_REC.LAST_SCHED, L_STPRFREQ_REC.LAST_SCHED_TZ,
                         L_STPRFREQ_REC.LAST_CNT, L_STPRFREQ_REC.LAST_VAL
                        );
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            UNAPIGEN.LOGERROR ('EvalFreqBuffer', SQLERRM);
      END;
   END LOOP;
   
   
   DELETE UTSTPRFREQBUFFER;
   
   FOR L_PPPR_REC IN L_PPPR_CURSOR
   LOOP
      BEGIN
         UPDATE UTPPPR
            SET LAST_SCHED = L_PPPR_REC.LAST_SCHED,
                LAST_SCHED_TZ = DECODE (L_PPPR_REC.LAST_SCHED, LAST_SCHED_TZ, LAST_SCHED_TZ, L_PPPR_REC.LAST_SCHED),
                LAST_CNT = L_PPPR_REC.LAST_CNT,
                LAST_VAL = L_PPPR_REC.LAST_VAL
          WHERE PP = L_PPPR_REC.PP
            AND VERSION = L_PPPR_REC.VERSION
            AND PP_KEY1 = L_PPPR_REC.PP_KEY1
            AND PP_KEY2 = L_PPPR_REC.PP_KEY2
            AND PP_KEY3 = L_PPPR_REC.PP_KEY3
            AND PP_KEY4 = L_PPPR_REC.PP_KEY4
            AND PP_KEY5 = L_PPPR_REC.PP_KEY5
            AND PR = L_PPPR_REC.PR
            AND SEQ = L_PPPR_REC.SEQ;
      EXCEPTION
         WHEN OTHERS
         THEN
            UNAPIGEN.LOGERROR ('EvalFreqBuffer', SQLERRM);
      END;
   END LOOP;
   
   
   DELETE UTPPPRBUFFER;
   
   FOR L_STPP_REC IN L_STPP_CURSOR
   LOOP
      BEGIN
         UPDATE UTSTPP
            SET LAST_SCHED = L_STPP_REC.LAST_SCHED,
                LAST_SCHED_TZ = L_STPP_REC.LAST_SCHED_TZ,
                LAST_CNT = L_STPP_REC.LAST_CNT,
                LAST_VAL = L_STPP_REC.LAST_VAL
          WHERE ST = L_STPP_REC.ST
            AND VERSION = L_STPP_REC.VERSION
            AND PP = L_STPP_REC.PP
            AND PP_VERSION = L_STPP_REC.PP_VERSION
            AND PP_KEY1 = L_STPP_REC.PP_KEY1
            AND PP_KEY2 = L_STPP_REC.PP_KEY2
            AND PP_KEY3 = L_STPP_REC.PP_KEY3
            AND PP_KEY4 = L_STPP_REC.PP_KEY4
            AND PP_KEY5 = L_STPP_REC.PP_KEY5
            AND SEQ = L_STPP_REC.SEQ;
      EXCEPTION
         WHEN OTHERS
         THEN
            UNAPIGEN.LOGERROR ('EvalFreqBuffer', SQLERRM);
      END;
   END LOOP;
   
   
   DELETE UTSTPPBUFFER;
   
   FOR L_RTST_REC IN L_RTST_CURSOR
   LOOP
      BEGIN
         UPDATE UTRTST
            SET LAST_SCHED = L_RTST_REC.LAST_SCHED,
                LAST_SCHED_TZ = DECODE (L_RTST_REC.LAST_SCHED, LAST_SCHED_TZ, LAST_SCHED_TZ, L_RTST_REC.LAST_SCHED),
                LAST_CNT = L_RTST_REC.LAST_CNT,
                LAST_VAL = L_RTST_REC.LAST_VAL
          WHERE RT = L_RTST_REC.RT AND VERSION = L_RTST_REC.VERSION 
            AND ST = L_RTST_REC.ST AND SEQ = L_RTST_REC.SEQ;
      EXCEPTION
         WHEN OTHERS
         THEN
            UNAPIGEN.LOGERROR ('EvalFreqBuffer', SQLERRM);
      END;
   END LOOP;
   
   
   DELETE UTRTSTBUFFER;
   
   FOR L_STIP_REC IN L_STIP_CURSOR
   LOOP
      BEGIN
         UPDATE UTSTIP
            SET FREQ_TP      = L_STIP_REC.FREQ_TP,        
					 FREQ_VAL      = L_STIP_REC.FREQ_VAL,
					 FREQ_UNIT     = L_STIP_REC.FREQ_UNIT,
					 INVERT_FREQ   = L_STIP_REC.INVERT_FREQ,
					 LAST_SCHED    = L_STIP_REC.LAST_SCHED,
					 LAST_SCHED_TZ = L_STIP_REC.LAST_SCHED_TZ,
					 LAST_CNT      = L_STIP_REC.LAST_CNT,
					 LAST_VAL      = L_STIP_REC.LAST_VAL
          WHERE ST = L_STIP_REC.ST AND VERSION = L_STIP_REC.VERSION 
            AND IP = L_STIP_REC.IP AND SEQ = L_STIP_REC.SEQ;
      EXCEPTION
         WHEN OTHERS
         THEN
            UNAPIGEN.LOGERROR ('EvalFreqBuffer', SQLERRM);
      END;
   END LOOP;
   
   
   DELETE UTSTIPBUFFER;
   
   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN OTHERS
   THEN
      UNAPIGEN.LOGERROR ('EvalFreqBuffer', SQLERRM);
      RETURN (UNAPIGEN.DBERR_GENFAIL);
END EVALFREQBUFFER;


BEGIN
   P_AUT_OUTPUT_ON := FALSE;
   L_NO_AR_CHECK   := FALSE;

   IF P_OPTIMIZER_MODE IS NULL THEN
       
      SELECT UPPER(VALUE)
      INTO P_OPTIMIZER_MODE
      FROM V$PARAMETER
      WHERE NAME = 'optimizer_mode' ;
   END IF ;
   
   P_CASCADE_READONLY := 'YES';
   OPEN C_SYSTEM('CASCADE_READONLY');
   FETCH C_SYSTEM
   INTO P_CASCADE_READONLY;
   IF C_SYSTEM%NOTFOUND THEN
      P_CASCADE_READONLY := 'YES';
   END IF;
   CLOSE C_SYSTEM;   
END UNAPIAUT;
/
