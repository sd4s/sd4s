PACKAGE BODY unapilk IS

L_SQLERRM                     VARCHAR2(255);
STPERROR                      EXCEPTION;
L_AUDSID_FOR_CURRENT_SESSION  NUMBER;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

PROCEDURE SHUFFLE                               
(A_INPUT     IN OUT UNAPIGEN.NUM_TABLE_TYPE,
 A_SIZE      IN NUMBER)
IS 
L_HULP1 UNAPIGEN.NUM_TABLE_TYPE;
L_HULP2 UNAPIGEN.NUM_TABLE_TYPE;
L_MAXINDEX NUMBER;
L_NB_LOOPS NUMBER;
L_IND      NUMBER;
L_IND2     NUMBER;

BEGIN
   L_MAXINDEX := 1;
   BEGIN
      LOOP
         L_HULP1(L_MAXINDEX) := A_INPUT(L_MAXINDEX);
         L_MAXINDEX := L_MAXINDEX + 1;
      END LOOP;
      EXCEPTION
       WHEN NO_DATA_FOUND THEN NULL;
       WHEN OTHERS THEN NULL;
   END;
   L_MAXINDEX := L_MAXINDEX -1;
   L_NB_LOOPS := FLOOR( L_MAXINDEX / (A_SIZE * 4));
   L_IND := 1;
   FOR I IN 1..L_NB_LOOPS LOOP
      FOR J IN 1..A_SIZE LOOP
         L_HULP2(L_IND) := L_HULP1( (I-1) * A_SIZE *4 + J + A_SIZE );
         L_IND := L_IND + 1;
      END LOOP;
      FOR J IN 1..A_SIZE LOOP
         L_HULP2(L_IND) := L_HULP1( (I-1) * A_SIZE *4 + J + 3 * A_SIZE );
         L_IND := L_IND + 1;
      END LOOP;
      FOR J IN 1..A_SIZE LOOP
         L_HULP2(L_IND) := L_HULP1( (I-1) * A_SIZE *4 + J + 2 * A_SIZE );
         L_IND := L_IND + 1;
      END LOOP;
      FOR J IN 1..A_SIZE LOOP
         L_HULP2(L_IND) := L_HULP1( (I-1) * A_SIZE *4 + J );
         L_IND := L_IND + 1;
      END LOOP;
   END LOOP;
   FOR J IN L_IND..L_MAXINDEX LOOP
      L_HULP2(J) := L_HULP1(J);
   END LOOP;
   A_INPUT := L_HULP2;
END SHUFFLE;

FUNCTION CREATEKEY                                           
(A_INPUTINFO   IN CHAR,
 A_KEY      OUT   CHAR)
RETURN BOOLEAN IS

L_KEYLONG UNAPIGEN.NUM_TABLE_TYPE;
L_KEYSHORT UNAPIGEN.NUM_TABLE_TYPE;
L_SOM NUMBER;
L_SOM1 NUMBER;
L_SOM2 NUMBER;
L_SOM3 NUMBER;
L_SCRAMBLE CHAR(20);
L_LETTER CHAR(1);
L_TEMP VARCHAR(20);
L_MULTIPLIER NUMBER;

BEGIN




   FOR I IN 1..200 LOOP
     L_LETTER := SUBSTR(A_INPUTINFO, I, 1);
     IF ASCIISTR(L_LETTER) = L_LETTER THEN
          L_KEYLONG(I) := ASCII( SUBSTR(A_INPUTINFO, I, 1));
      ELSE
      
       L_KEYLONG(I) := TO_NUMBER(SUBSTR(ASCIISTR(L_LETTER),2), 'XXXX');
      END IF;
   END LOOP;
   SHUFFLE(L_KEYLONG, 25);
   SHUFFLE(L_KEYLONG, 10);
   SHUFFLE(L_KEYLONG, 50);
   FOR I IN 1..10 LOOP
      L_SOM :=0;
      FOR J IN 1..27 LOOP
         L_SOM := L_SOM + L_KEYLONG( MOD((20 * I + J), 200) +1);
      END LOOP;
      L_KEYSHORT(I) := MOD( L_SOM + 14, 62 - MOD( I, 3));
   END LOOP;
   FOR I IN 0..4 LOOP
      L_SOM :=0;
      FOR J IN 3..61 LOOP
         L_SOM := L_SOM + L_KEYLONG( MOD((48 * I + J), 200) +1);
      END LOOP;
      L_KEYSHORT(11 + I) := MOD( L_SOM , 62 - MOD( I, 2));
   END LOOP;
   
   L_SOM1:= 0;
   FOR J IN 1..200 LOOP
      L_SOM1 := L_SOM1 + MOD(J * L_KEYLONG(J), 62) - 31;
   END LOOP;
   L_KEYSHORT(16) := MOD( ABS(L_SOM1),62);
   
   L_SOM1:= 0;
   FOR J IN 1..7 LOOP
      L_SOM1 := L_SOM1 + L_KEYSHORT(J);
   END LOOP;
   L_SOM2:= 0;
   FOR J IN 13..16 LOOP
      L_SOM2 := L_SOM2 + L_KEYSHORT(J);
   END LOOP;
   L_SOM3:= 0;
   FOR J IN 1..16 LOOP
      L_SOM3 := L_SOM3 + L_KEYSHORT(J);
   END LOOP;
   L_KEYSHORT(17) := MOD( ( MOD(L_SOM1 + 2,7) + MOD(L_SOM2, 11) + MOD(L_SOM3 + 1, 58) ), 62);
   
   
   L_SOM1:= 0;
   FOR J IN 2..11 LOOP
      L_SOM1 := L_SOM1 + L_KEYSHORT(J);
   END LOOP;
   L_SOM2:= 0;
   FOR J IN 7..15 LOOP
      L_SOM2 := L_SOM2 + L_KEYSHORT(J);
   END LOOP;
   L_SOM3:= 0;
   FOR J IN 1..17 LOOP
      L_SOM3 := L_SOM3 + L_KEYSHORT(J);
   END LOOP;
   L_KEYSHORT(18) := MOD( ( MOD(L_SOM1 + 3 ,11) + MOD(L_SOM2 + 4, 5) + MOD(L_SOM3 + 32, 71) ), 62);
   
   L_SOM1:= 0;
   FOR J IN 1..13 LOOP
      L_SOM1 := L_SOM1 + L_KEYSHORT(J);
   END LOOP;
   L_SOM2:= 0;
   FOR J IN 7..18 LOOP
      L_SOM2 := L_SOM2 + L_KEYSHORT(J);
   END LOOP;
   L_SOM3:= 0;
   FOR J IN 1..18 LOOP
      L_SOM3 := L_SOM3 + L_KEYSHORT(J);
   END LOOP;
   L_KEYSHORT(19) := MOD( ( MOD(L_SOM1 + 5,10) + MOD(L_SOM2 + 2, 6) + MOD(L_SOM3 + 44, 63) ), 62);
     
   L_SOM1:= 0;
   FOR J IN 1..19 LOOP
      L_SOM1 := L_SOM1 + L_KEYSHORT(J);
   END LOOP;
   L_KEYSHORT(20) := MOD( L_SOM1, 62);
   
   IF MOD(L_KEYSHORT(20),5) = 0 THEN
         L_MULTIPLIER := 43;
   ELSIF  MOD(L_KEYSHORT(20),5) =1 THEN
         L_MULTIPLIER := 41;
   ELSIF  MOD(L_KEYSHORT(20),5) =2 THEN
         L_MULTIPLIER := 47;
   ELSIF  MOD(L_KEYSHORT(20),5) =3 THEN
         L_MULTIPLIER := 37;
   ELSIF  MOD(L_KEYSHORT(20),5) =4 THEN
         L_MULTIPLIER := 29;
   END IF; 
   
   SHUFFLE(L_KEYSHORT, 5);
   SHUFFLE(L_KEYSHORT, 1);
   L_SCRAMBLE := CHR(97)||CHR(84)||CHR(56)||CHR(85)||CHR(49)||CHR(83)||CHR(111)||
                 CHR(119)||CHR(106)||CHR(110)||CHR(78)||CHR(119)||CHR(50)||CHR(102)||
                 CHR(57)||CHR(56)||CHR(107)||CHR(105)||CHR(101)||CHR(76); 
  
   L_KEYSHORT(1) := MOD( ( L_KEYSHORT(1) * L_MULTIPLIER + ASCII( SUBSTR(L_SCRAMBLE, 1, 1))), 62);
   IF (L_KEYSHORT(1) < 26) THEN
      L_TEMP := CHR(65 + L_KEYSHORT(1));
   ELSIF (L_KEYSHORT(1) <36) THEN
      L_TEMP := CHR(48 + L_KEYSHORT(1) - 26);
   ELSE  
      L_TEMP := CHR(97 + L_KEYSHORT(1) - 36);
   END IF;
   FOR J IN 2..19 LOOP
      L_KEYSHORT(J) := MOD( ( L_KEYSHORT(J) * L_MULTIPLIER + ASCII( SUBSTR(L_SCRAMBLE, J, 1))), 62);
       IF (L_KEYSHORT(J) < 26) THEN
         L_LETTER := CHR(65 + L_KEYSHORT(J));
      ELSIF (L_KEYSHORT(J) <36) THEN
         L_LETTER := CHR(48 + L_KEYSHORT(J) - 26);
      ELSE  
         L_LETTER := CHR(97 + L_KEYSHORT(J) - 36);
      END IF;
       L_TEMP := RTRIM(L_TEMP) || L_LETTER;
   END LOOP;
   L_SOM1:=0;
   FOR J IN 1 .. 19 LOOP
      L_SOM1 := L_SOM1 + ASCII( SUBSTR(L_TEMP, J, 1));
   END LOOP;
    L_LETTER := CHR(65 + MOD(L_SOM1, 26));
   L_TEMP := L_TEMP || L_LETTER;
  
   A_KEY := L_TEMP;
   RETURN TRUE;
EXCEPTION
WHEN OTHERS THEN
   RETURN FALSE;
END CREATEKEY;

FUNCTION CHECKLICENSEKEY              
(A_MAX_USERS           OUT NUMBER,    
 A_CURRENT_USERS       OUT NUMBER,    
 A_US                  IN VARCHAR2)   
RETURN BOOLEAN IS

L_KEY CHAR(20);
L_RETURNKEY CHAR(20);
L_INPUTSTRING CHAR(200);
L_IND NUMBER;
L_SUCCESS BOOLEAN;
BEGIN
EXECUTE IMMEDIATE 'SELECT key FROM utlicsecid'
INTO L_KEY;
EXECUTE IMMEDIATE 'SELECT UNAPIGEN.Cx_RPAD(lic_number,8,'' '') || UNAPIGEN.Cx_RPAD(Customer,40,'' '') || UNAPIGEN.Cx_RPAD(Site,40,'' '') || UNAPIGEN.Cx_RPAD(TO_CHAR(users),4,'' '') || UNAPIGEN.Cx_RPAD(RTRIM(modules),60,''#'') || UNAPIGEN.Cx_RPAD(NVL(expire_date, ''*''),11,''*'') FROM utlicsecid'
INTO L_INPUTSTRING ;
L_INPUTSTRING := UNAPIGEN.CX_RPAD(RTRIM(L_INPUTSTRING),200, '&');

L_SUCCESS := CREATEKEY(L_INPUTSTRING, L_RETURNKEY);
IF NOT L_SUCCESS THEN 
   RETURN FALSE;
END IF;
IF (L_RETURNKEY != L_KEY) THEN
   RETURN FALSE;
END IF;
BEGIN
   EXECUTE IMMEDIATE 'SELECT users FROM utlicsecid'
   INTO A_MAX_USERS;
   EXECUTE IMMEDIATE 'SELECT count(distinct(US)) FROM utlicusercnt where ((last_heartbeat > CURRENT_TIMESTAMP - (5/24)/60) AND (us != a_us))'
   INTO A_CURRENT_USERS;
   EXCEPTION
   WHEN OTHERS THEN 
      A_MAX_USERS := -1;
      A_CURRENT_USERS := -1;
   END;
RETURN TRUE;
EXCEPTION
WHEN OTHERS THEN
   RETURN FALSE;
END CHECKLICENSEKEY;

FUNCTION INSERTHEARTBEAT
( A_US                 IN VARCHAR2,    
  A_APPLIC             IN VARCHAR2,    
  A_LIC_CHECK_APPLIES  IN CHAR,        
  A_LOGON_DATE         IN NUMBER)      
RETURN NUMBER IS

L_MAX_USERS                   NUMBER;
L_CURRENT_USERS               NUMBER;
L_RET                         BOOLEAN;
L_RET_CODE                    NUMBER;
L_US                          VARCHAR2(20);
L_APPLIC                      VARCHAR2(8);
L_LIC_CHECK_APPLIES           CHAR(1);
L_LAST_HEARTBEAT              TIMESTAMP WITH TIME ZONE;
L_LOGON_DATE                  TIMESTAMP WITH TIME ZONE;
L_CURRENT_TIMESTAMP                     TIMESTAMP WITH TIME ZONE;
L_INTERNAL_CLIENT_ID          VARCHAR2(40);
L_AUDSID                      NUMBER;
L_ROWID                       ROWID;
L_APPLIC                      VARCHAR2(4);


L_APP_ID_TAB                  CXSAPILK.VC20_TABLE_TYPE;
L_APP_VERSION_TAB             CXSAPILK.VC20_TABLE_TYPE;
L_LOGON_STATION_TAB           CXSAPILK.VC40_TABLE_TYPE;
L_USER_SID_TAB                CXSAPILK.VC20_TABLE_TYPE;
L_USER_NAME_TAB               CXSAPILK.VC20_TABLE_TYPE;
L_NR_OF_ROWS                  NUMBER;
L_ERROR_CODE                  CXSAPILK.NUM_TABLE_TYPE;
L_ERROR_MESSAGE               VARCHAR2(255);

BEGIN

   L_SQLERRM := NULL;
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP; 
   
   IF NVL(A_US, ' ') <> UNAPIGEN.P_USER THEN
      L_SQLERRM := 'User specified in Heartbeat is not corresponding to the SetConnection user';
      RAISE STPERROR;
   END IF;






   
   IF NVL(A_LIC_CHECK_APPLIES, ' ') NOT IN ('0', '1') THEN
      L_SQLERRM := 'Lic_check_applies specified in Heartbeat is invalid='||A_LIC_CHECK_APPLIES;
      RAISE STPERROR;
   END IF;

   IF NVL(A_LOGON_DATE, -3) NOT IN (0, 1, -1, -2) THEN
      L_SQLERRM := 'Logon_date specified in Heartbeat is invalid='||A_LOGON_DATE;
      RAISE STPERROR;
   END IF;

   
   IF UNAPILK IS NULL THEN
      L_SQLERRM := 'ClientId is empty. Setconnection probably not performed in the current session or ClientId left empty';
      RAISE STPERROR;
   END IF;
   
   IF L_AUDSID_FOR_CURRENT_SESSION IS NULL THEN
      SELECT SYS.STANDARD.USERENV('SESSIONID')
      INTO L_AUDSID_FOR_CURRENT_SESSION
      FROM DUAL;
   END IF;
       
   
   
   
   
   
   
   

   L_APP_ID_TAB(1)        := 'IULC';
   L_APP_VERSION_TAB(1)   := '0607';
   L_LOGON_STATION_TAB(1) := UNAPILK;
   L_USER_SID_TAB(1)      := A_US;
   L_USER_NAME_TAB(1)     := A_US;
   L_NR_OF_ROWS           := 1;

   L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   IF (NVL(A_LOGON_DATE, 0) = 0) THEN

      L_RET_CODE := CXSAPILK.PINGLICENSE(L_APP_ID_TAB,
                                          L_APP_VERSION_TAB,
                                          L_LOGON_STATION_TAB,
                                          L_USER_SID_TAB,
                                          L_USER_NAME_TAB,
                                          L_NR_OF_ROWS,
                                          L_ERROR_CODE,
                                          L_ERROR_MESSAGE);
                                                               
   ELSIF (NVL(A_LOGON_DATE, 0) = -1) THEN
      
      L_RET_CODE := CXSAPILK.FREELICENSE(L_APP_ID_TAB,
                                          L_APP_VERSION_TAB,
                                          L_LOGON_STATION_TAB,
                                          L_USER_SID_TAB,
                                          L_USER_NAME_TAB,
                                          L_NR_OF_ROWS,
                                          L_ERROR_CODE,
                                          L_ERROR_MESSAGE);

   ELSIF (NVL(A_LOGON_DATE, 0) = -2) THEN 
      BEGIN
         L_RET_CODE := CXSAPILK.FREELICENSE(L_APP_ID_TAB,
                                             L_APP_VERSION_TAB,
                                             L_LOGON_STATION_TAB,
                                             L_USER_SID_TAB,
                                             L_USER_NAME_TAB,
                                             L_NR_OF_ROWS,
                                             L_ERROR_CODE,
                                             L_ERROR_MESSAGE);
      EXCEPTION
      WHEN OTHERS THEN
         IF ( SQLCODE = -20000 ) THEN
            RETURN (UNAPIGEN.DBERR_SUCCESS);
         END IF ;
      END ;                           
   ELSIF (NVL(A_LOGON_DATE, 0) = 1) THEN

      L_RET_CODE := CXSAPILK.GRANTLICENSE(L_APP_ID_TAB,
                                          L_APP_VERSION_TAB,
                                          L_LOGON_STATION_TAB,
                                          L_USER_SID_TAB,
                                          L_USER_NAME_TAB,
                                          L_NR_OF_ROWS,
                                          L_ERROR_CODE,
                                          L_ERROR_MESSAGE);
   END IF;
   
   IF L_RET_CODE IN (UNAPIGEN.DBERR_SUCCESS, CXSAPILK.DBERR_OK_NO_ALM) AND
      L_ERROR_CODE(1) <> UNAPIGEN.DBERR_SUCCESS THEN
      L_RET_CODE := L_ERROR_CODE(1);
   END IF;
   
   
   IF NVL(A_LOGON_DATE, 0) IN (0, 1) THEN
      IF (L_RET_CODE = CXSAPILK.DBERR_TOOMANYUSERS4ALM) AND
         A_US <> UNAPIGEN.P_DBA_NAME AND
         UNAPIGEN.ISEXTERNALDBAUSER <> UNAPIGEN.DBERR_SUCCESS THEN
         L_RET_CODE := CXSAPILK.DBERR_TOOMANYUSERS4ALM;         
      END IF;
   END IF;

   IF L_RET_CODE IN (UNAPIGEN.DBERR_SUCCESS,CXSAPILK.DBERR_OK_NO_ALM)  THEN
      UNAPIGEN.U4COMMIT;   
   ELSE
      UNAPIGEN.U4ROLLBACK; 
   END IF;
   
   
   IF (NVL(A_LOGON_DATE, 0) <> 1) THEN
      
      IF L_RET_CODE = CXSAPILK.DBERR_OK_NO_ALM THEN
         L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      END IF;
   END IF;
   RETURN (L_RET_CODE);
   
EXCEPTION
WHEN OTHERS THEN 
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('InsertHeartBeat',SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('InsertHeartBeat',L_SQLERRM);
   END IF;
   UNAPIGEN.U4ROLLBACK;
   RETURN (UNAPIGEN.DBERR_GENFAIL);
END INSERTHEARTBEAT;

FUNCTION GETINTERNALCODE
( A_INTERNAL_CODE      OUT FLOAT)
RETURN NUMBER IS
BEGIN
   
   A_INTERNAL_CODE := 123.456/SQRT(16);
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END GETINTERNALCODE;  


END UNAPILK;