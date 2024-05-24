PACKAGE BODY unapippp AS

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(4000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_EV_DETAILS      VARCHAR2(255);
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;

STPERROR          EXCEPTION;


L_AU_CURSOR                 INTEGER;
P_PPPRAU_CURSOR             INTEGER;
P_GETPPCOMMENT_CURSOR       INTEGER;
P_HS_CURSOR                 INTEGER;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION GETPPATTRIBUTE
(A_PP                     OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION                OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY1                OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY2                OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY3                OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY4                OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY5                OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_AU                     OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_AU_VERSION             OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_VALUE                  OUT   UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCRIPTION            OUT   UNAPIGEN.VC40_TABLE_TYPE,  
 A_IS_PROTECTED           OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SINGLE_VALUED          OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NEW_VAL_ALLOWED        OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_STORE_DB               OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_VALUE_LIST_TP          OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_RUN_MODE               OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SERVICE                OUT   UNAPIGEN.VC255_TABLE_TYPE, 
 A_CF_VALUE               OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_NR_OF_ROWS             IN OUT NUMBER,                   
 A_WHERE_CLAUSE           IN     VARCHAR2)                 
RETURN NUMBER IS

L_AU                  VARCHAR2(20);
L_AU_VERSION          VARCHAR2(20);
L_PP                  VARCHAR2(20);
L_VERSION             VARCHAR2(20);
L_PP_KEY1             VARCHAR2(20);
L_PP_KEY2             VARCHAR2(20);
L_PP_KEY3             VARCHAR2(20);
L_PP_KEY4             VARCHAR2(20);
L_PP_KEY5             VARCHAR2(20);
L_VALUE               VARCHAR2(40);
L_DESCRIPTION         VARCHAR2(40);
L_IS_PROTECTED        CHAR(1);
L_SINGLE_VALUED       CHAR(1);
L_NEW_VAL_ALLOWED     CHAR(1);
L_STORE_DB            CHAR(1);
L_VALUE_LIST_TP       CHAR(1);
L_RUN_MODE            CHAR(1);
L_SERVICE             VARCHAR2(255);
L_CF_VALUE            VARCHAR2(20);

BEGIN
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uvpp x '||
                     'WHERE au.version = x.version '||
                     'AND au.pp = x.pp '||
                     'AND au.pp = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || ''' ' || 
                     'AND x.pp_key1='' '' AND x.pp_key2='' '' AND x.pp_key3='' '' ' ||
                     'AND x.pp_key4='' '' AND x.pp_key5='' '' ' ||
                     'AND x.version_is_current = ''1'' '||
                     'ORDER BY au.auseq';      
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_SQL_STRING := 'SELECT au.pp, au.version, au.pp_key1, au.pp_key2, au.pp_key3, au.pp_key4, '||
                   'au.pp_key5, au.au, au.au_version, au.value FROM dd' ||
                    UNAPIGEN.P_DD || '.uvppau au '
                    || L_WHERE_CLAUSE;

   L_AU_CURSOR := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 1, L_PP, 20);
   DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 2, L_VERSION, 20);
   DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 3, L_PP_KEY1, 20);
   DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 4, L_PP_KEY2, 20);
   DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 5, L_PP_KEY3, 20);
   DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 6, L_PP_KEY4, 20);
   DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 7, L_PP_KEY5, 20);
   DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 8, L_AU, 20);
   DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 9, L_AU_VERSION, 20);
   DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 10, L_VALUE, 40);

   L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
   L_RESULT := DBMS_SQL.FETCH_ROWS(L_AU_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 1, L_PP);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 2, L_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 3, L_PP_KEY1);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 4, L_PP_KEY2);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 5, L_PP_KEY3);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 6, L_PP_KEY4);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 7, L_PP_KEY5);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 8, L_AU);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 9, L_AU_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 10, L_VALUE);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_PP(L_FETCHED_ROWS) := L_PP;
      A_VERSION(L_FETCHED_ROWS) := L_VERSION;
      A_PP_KEY1(L_FETCHED_ROWS) := L_PP_KEY1;
      A_PP_KEY2(L_FETCHED_ROWS) := L_PP_KEY2;
      A_PP_KEY3(L_FETCHED_ROWS) := L_PP_KEY3;
      A_PP_KEY4(L_FETCHED_ROWS) := L_PP_KEY4;
      A_PP_KEY5(L_FETCHED_ROWS) := L_PP_KEY5;
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
         A_IS_PROTECTED (L_FETCHED_ROWS) := L_IS_PROTECTED;
         A_SINGLE_VALUED (L_FETCHED_ROWS) := L_SINGLE_VALUED;
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

   DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE   
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF;
   A_NR_OF_ROWS := L_FETCHED_ROWS;

   RETURN(L_RET_CODE);

EXCEPTION
  WHEN OTHERS THEN
     L_SQLERRM := SQLERRM;
     UNAPIGEN.U4ROLLBACK;
     INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
     VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'GetPpAttribute', L_SQLERRM);
     UNAPIGEN.U4COMMIT;
     IF DBMS_SQL.IS_OPEN (L_AU_CURSOR) THEN
        DBMS_SQL.CLOSE_CURSOR (L_AU_CURSOR);
     END IF;
     IF UNAPIGEN.L_AUDET_CURSOR%ISOPEN THEN
        CLOSE UNAPIGEN.L_AUDET_CURSOR;
     END IF;
     RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPPATTRIBUTE;

FUNCTION GETPPPRATTRIBUTE
(A_PP                     IN    VARCHAR2,                  
 A_VERSION                IN    VARCHAR2,                  
 A_PP_KEY1                IN    VARCHAR2,                  
 A_PP_KEY2                IN    VARCHAR2,                  
 A_PP_KEY3                IN    VARCHAR2,                  
 A_PP_KEY4                IN    VARCHAR2,                  
 A_PP_KEY5                IN    VARCHAR2,                  
 A_PR                     OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_PR_VERSION             OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_AU                     OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_AU_VERSION             OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_VALUE                  OUT   UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCRIPTION            OUT   UNAPIGEN.VC40_TABLE_TYPE,  
 A_IS_PROTECTED           OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SINGLE_VALUED          OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NEW_VAL_ALLOWED        OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_STORE_DB               OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_VALUE_LIST_TP          OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_RUN_MODE               OUT   UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_SERVICE                OUT   UNAPIGEN.VC255_TABLE_TYPE, 
 A_CF_VALUE               OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_NR_OF_ROWS             IN OUT NUMBER,                   
 A_WHERE_CLAUSE           IN     VARCHAR2)                 
RETURN NUMBER IS

L_AU                        VARCHAR2(20);
L_AU_VERSION                VARCHAR2(20);
L_PR                        VARCHAR2(20);
L_PR_VERSION                VARCHAR2(20);
L_VALUE                     VARCHAR2(40);
L_DESCRIPTION               VARCHAR2(40);
L_IS_PROTECTED              CHAR(1);
L_SINGLE_VALUED             CHAR(1);
L_NEW_VAL_ALLOWED           CHAR(1);
L_STORE_DB                  CHAR(1);
L_VALUE_LIST_TP             CHAR(1);
L_RUN_MODE                  CHAR(1);
L_SERVICE                   VARCHAR2(255);
L_CF_VALUE                  VARCHAR2(20);
L_NEXT_ROWS_ENABLED         BOOLEAN;
L_AU_FETCHED                VARCHAR2(20);

BEGIN

  IF NVL(A_NR_OF_ROWS,0) = 0 THEN
     A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
  ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
     RETURN (UNAPIGEN.DBERR_NROFROWS);
  END IF;

  
  
  
  

  
  
  

  
  
  
  
  
  
  
    
  L_NEXT_ROWS_ENABLED := FALSE;
  IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
     L_WHERE_CLAUSE := 'WHERE pp= ''' || REPLACE(A_PP, '''', '''''') || 
                       ''' AND version = ''' || REPLACE(A_VERSION, '''', '''''') || 
                       ''' AND pp_key1 = ''' || REPLACE(A_PP_KEY1, '''', '''''') || 
                       ''' AND pp_key2 = ''' || REPLACE(A_PP_KEY2, '''', '''''') || 
                       ''' AND pp_key3 = ''' || REPLACE(A_PP_KEY3, '''', '''''') || 
                       ''' AND pp_key4 = ''' || REPLACE(A_PP_KEY4, '''', '''''') || 
                       ''' AND pp_key5 = ''' || REPLACE(A_PP_KEY5, '''', '''''') || 
                       ''' ORDER BY pp, pr_version, auseq';
  ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,3)) = 'PP=' THEN
     
     
     
     L_NEXT_ROWS_ENABLED := TRUE;
     L_WHERE_CLAUSE := 'WHERE '|| A_WHERE_CLAUSE;
     
  ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
     L_WHERE_CLAUSE := ' WHERE pp = ''' || REPLACE(A_PP, '''', '''''') || 
                       ''' AND version = ''' || REPLACE(A_VERSION, '''', '''''') || 
                       ''' AND pp_key1 = ''' || REPLACE(A_PP_KEY1, '''', '''''') || 
                       ''' AND pp_key2 = ''' || REPLACE(A_PP_KEY2, '''', '''''') || 
                       ''' AND pp_key3 = ''' || REPLACE(A_PP_KEY3, '''', '''''') || 
                       ''' AND pp_key4 = ''' || REPLACE(A_PP_KEY4, '''', '''''') || 
                       ''' AND pp_key5 = ''' || REPLACE(A_PP_KEY5, '''', '''''') || 
                       ''' AND pr = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                       ''' ORDER BY auseq';
  ELSE
     L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
  END IF;

  L_SQL_STRING := 'SELECT au.pr, au.pr_version, ' ||
                     'au.au, au.au_version, au.value '||
                     'FROM dd' || UNAPIGEN.P_DD || '.uvppprau au ' ||
                     L_WHERE_CLAUSE;

  IF NOT DBMS_SQL.IS_OPEN(P_PPPRAU_CURSOR) THEN
     P_PPPRAU_CURSOR := DBMS_SQL.OPEN_CURSOR;
     DBMS_SQL.PARSE(P_PPPRAU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
     DBMS_SQL.DEFINE_COLUMN(P_PPPRAU_CURSOR, 1, L_PR, 20);
     DBMS_SQL.DEFINE_COLUMN(P_PPPRAU_CURSOR, 2, L_PR_VERSION, 20);
     DBMS_SQL.DEFINE_COLUMN(P_PPPRAU_CURSOR, 3, L_AU, 20);
     DBMS_SQL.DEFINE_COLUMN(P_PPPRAU_CURSOR, 4, L_AU_VERSION, 20);
     DBMS_SQL.DEFINE_COLUMN(P_PPPRAU_CURSOR, 5, L_VALUE, 40);
     L_RESULT := DBMS_SQL.EXECUTE(P_PPPRAU_CURSOR);
  END IF;
  
  L_FETCHED_ROWS := 0;
  L_RESULT := DBMS_SQL.FETCH_ROWS(P_PPPRAU_CURSOR);
  L_PR := '';
  L_AU_FETCHED := NULL;
  
  LOOP
     EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
     DBMS_SQL.COLUMN_VALUE(P_PPPRAU_CURSOR, 1, L_PR);
     DBMS_SQL.COLUMN_VALUE(P_PPPRAU_CURSOR, 2, L_PR_VERSION);
     DBMS_SQL.COLUMN_VALUE(P_PPPRAU_CURSOR, 3, L_AU);
     DBMS_SQL.COLUMN_VALUE(P_PPPRAU_CURSOR, 4, L_AU_VERSION);
     DBMS_SQL.COLUMN_VALUE(P_PPPRAU_CURSOR, 5, L_VALUE);

     L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

     A_PR(L_FETCHED_ROWS) := L_PR;
     A_PR_VERSION(L_FETCHED_ROWS) := L_PR_VERSION;
     A_AU(L_FETCHED_ROWS) := L_AU;
     A_AU_VERSION(L_FETCHED_ROWS) := L_AU_VERSION;
     A_VALUE(L_FETCHED_ROWS) := L_VALUE;

     IF L_AU  <> NVL(L_AU_FETCHED, ' ') THEN 
        OPEN UNAPIGEN.L_AUDET_CURSOR(L_AU, L_AU_VERSION);
        FETCH UNAPIGEN.L_AUDET_CURSOR
        INTO L_DESCRIPTION, L_IS_PROTECTED, L_SINGLE_VALUED,
             L_NEW_VAL_ALLOWED, L_STORE_DB, L_VALUE_LIST_TP, L_RUN_MODE,
             L_SERVICE, L_CF_VALUE;
        IF UNAPIGEN.L_AUDET_CURSOR%NOTFOUND THEN
           L_AU_FETCHED := NULL;
        ELSE
           L_AU_FETCHED := L_AU;
        END IF;
        CLOSE UNAPIGEN.L_AUDET_CURSOR;
     END IF;
            
     IF L_AU_FETCHED IS NULL THEN
        
        
        
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
        A_IS_PROTECTED (L_FETCHED_ROWS) := L_IS_PROTECTED;
        A_SINGLE_VALUED (L_FETCHED_ROWS) := L_SINGLE_VALUED;
        A_NEW_VAL_ALLOWED(L_FETCHED_ROWS) := L_NEW_VAL_ALLOWED;
        A_STORE_DB(L_FETCHED_ROWS) := L_STORE_DB;
        A_VALUE_LIST_TP(L_FETCHED_ROWS) := L_VALUE_LIST_TP;
        A_RUN_MODE(L_FETCHED_ROWS) := L_RUN_MODE;
        A_SERVICE(L_FETCHED_ROWS) := L_SERVICE;
        A_CF_VALUE(L_FETCHED_ROWS) := L_CF_VALUE;
     END IF;

     IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
        L_RESULT := DBMS_SQL.FETCH_ROWS(P_PPPRAU_CURSOR);
     END IF;
  END LOOP;

  IF L_FETCHED_ROWS = 0 THEN
     L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
     DBMS_SQL.CLOSE_CURSOR(P_PPPRAU_CURSOR);
  ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
     L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
     A_NR_OF_ROWS := L_FETCHED_ROWS;
     DBMS_SQL.CLOSE_CURSOR(P_PPPRAU_CURSOR);
  ELSE   
     L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
     A_NR_OF_ROWS := L_FETCHED_ROWS;
  END IF;

  IF L_NEXT_ROWS_ENABLED = FALSE AND
     DBMS_SQL.IS_OPEN(P_PPPRAU_CURSOR) THEN
     DBMS_SQL.CLOSE_CURSOR(P_PPPRAU_CURSOR);
  END IF;

  RETURN(L_RET_CODE);

EXCEPTION
  WHEN OTHERS THEN
     L_SQLERRM := SQLERRM;
     UNAPIGEN.U4ROLLBACK;
     INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
     VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'GetPpPrAttribute', L_SQLERRM);
     UNAPIGEN.U4COMMIT;
     IF DBMS_SQL.IS_OPEN (P_PPPRAU_CURSOR) THEN
        DBMS_SQL.CLOSE_CURSOR (P_PPPRAU_CURSOR);
     END IF;
     IF UNAPIGEN.L_AUDET_CURSOR%ISOPEN THEN
        CLOSE UNAPIGEN.L_AUDET_CURSOR;
     END IF;
     RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPPPRATTRIBUTE;

FUNCTION SAVEPPATTRIBUTE
(A_PP                       IN        VARCHAR2,                 
 A_VERSION                  IN        VARCHAR2,                 
 A_PP_KEY1                  IN        VARCHAR2,                 
 A_PP_KEY2                  IN        VARCHAR2,                 
 A_PP_KEY3                  IN        VARCHAR2,                 
 A_PP_KEY4                  IN        VARCHAR2,                 
 A_PP_KEY5                  IN        VARCHAR2,                 
 A_AU                       IN        UNAPIGEN.VC20_TABLE_TYPE, 
 A_AU_VERSION               IN OUT    UNAPIGEN.VC20_TABLE_TYPE, 
 A_VALUE                    IN        UNAPIGEN.VC40_TABLE_TYPE, 
 A_NR_OF_ROWS               IN        NUMBER,                   
 A_MODIFY_REASON            IN        VARCHAR2)                 
RETURN NUMBER IS

L_ALLOW_MODIFY CHAR(1);
L_LOG_HS       CHAR(1);
L_ACTIVE       CHAR(1);
L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);

BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIPPP.GETPPAUTHORISATION(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3,
                                             A_PP_KEY4, A_PP_KEY5, L_LC, L_LC_VERSION, 
                                             L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPP
   SET ALLOW_MODIFY = '#'
    WHERE PP = A_PP
     AND VERSION = A_VERSION
     AND PP_KEY1 = A_PP_KEY1
     AND PP_KEY2 = A_PP_KEY2
     AND PP_KEY3 = A_PP_KEY3
     AND PP_KEY4 = A_PP_KEY4
     AND PP_KEY5 = A_PP_KEY5;
   IF SQL%ROWCOUNT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
      RAISE STPERROR;
   END IF;

   DELETE FROM UTPPAU
   WHERE PP=A_PP
   AND VERSION =A_VERSION
   AND PP_KEY1 =A_PP_KEY1
   AND PP_KEY2 =A_PP_KEY2
   AND PP_KEY3 =A_PP_KEY3
   AND PP_KEY4 =A_PP_KEY4
   AND PP_KEY5 =A_PP_KEY5;

   
   FOR I IN 1..A_NR_OF_ROWS LOOP
      INSERT INTO UTPPAU
      (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
       AU, AU_VERSION, AUSEQ, VALUE)
      VALUES
      (A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, 
       A_AU(I), NULL, I, A_VALUE(I));
   END LOOP;

   L_EVENT_TP := 'AttributesUpdated';
   L_EV_DETAILS := 'version='||A_VERSION||
                   '#pp_key1='||A_PP_KEY1||
                   '#pp_key2='||A_PP_KEY2||
                   '#pp_key3='||A_PP_KEY3||
                   '#pp_key4='||A_PP_KEY4||
                   '#pp_key5='||A_PP_KEY5;
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT ('SavePpAttribute',
               UNAPIGEN.P_EVMGR_NAME, 'pp', A_PP, L_LC, L_LC_VERSION, L_SS,
               L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') THEN
       INSERT INTO UTPPHS
       (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
        WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
        LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
       VALUES 
       (A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
        UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP ,
        'attributes for '||UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'||A_PP||'" are updated',
        CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ , L_EV_SEQ_NR); 
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SavePpAttribute', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SavePpAttribute'));
END SAVEPPATTRIBUTE;

FUNCTION SAVE1PPATTRIBUTE
(A_PP                       IN        VARCHAR2,                 
 A_VERSION                  IN        VARCHAR2,                 
 A_PP_KEY1                  IN        VARCHAR2,                 
 A_PP_KEY2                  IN        VARCHAR2,                 
 A_PP_KEY3                  IN        VARCHAR2,                 
 A_PP_KEY4                  IN        VARCHAR2,                 
 A_PP_KEY5                  IN        VARCHAR2,                 
 A_AU                       IN        VARCHAR2,                 
 A_AU_VERSION               IN OUT    VARCHAR2,                 
 A_VALUE                    IN        UNAPIGEN.VC40_TABLE_TYPE, 
 A_NR_OF_ROWS               IN        NUMBER,                   
 A_MODIFY_REASON            IN        VARCHAR2)                 
RETURN NUMBER IS

L_ALLOW_MODIFY CHAR(1);
L_AUSEQ        NUMBER;
L_LOG_HS       CHAR(1);
L_ACTIVE       CHAR(1);
L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIPPP.GETPPAUTHORISATION(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3,
                                             A_PP_KEY4, A_PP_KEY5, L_LC, L_LC_VERSION, 
                                             L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPP
   SET ALLOW_MODIFY = '#'
    WHERE PP = A_PP
     AND VERSION = A_VERSION
     AND PP_KEY1 = A_PP_KEY1
     AND PP_KEY2 = A_PP_KEY2
     AND PP_KEY3 = A_PP_KEY3
     AND PP_KEY4 = A_PP_KEY4
     AND PP_KEY5 = A_PP_KEY5;
   IF SQL%ROWCOUNT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
      RAISE STPERROR;
   END IF;

   DELETE FROM UTPPAU
   WHERE PP=A_PP
   AND VERSION =A_VERSION
   AND PP_KEY1 =A_PP_KEY1
   AND PP_KEY2 =A_PP_KEY2
   AND PP_KEY3 =A_PP_KEY3
   AND PP_KEY4 =A_PP_KEY4
   AND PP_KEY5 =A_PP_KEY5
   AND AU = A_AU;

   
   FOR I IN 1..A_NR_OF_ROWS LOOP
      INSERT INTO UTPPAU
      (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
       AU, AU_VERSION, AUSEQ, VALUE)
      VALUES
      (A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, 
       A_AU, NULL, I, A_VALUE(I));
   END LOOP;

   L_EVENT_TP := 'AttributesUpdated';
   L_EV_DETAILS := 'version='||A_VERSION||
                   '#pp_key1='||A_PP_KEY1||
                   '#pp_key2='||A_PP_KEY2||
                   '#pp_key3='||A_PP_KEY3||
                   '#pp_key4='||A_PP_KEY4||
                   '#pp_key5='||A_PP_KEY5;
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT ('Save1PpAttribute',
               UNAPIGEN.P_EVMGR_NAME, 'pp', A_PP, L_LC, L_LC_VERSION, L_SS,
               L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') THEN
       INSERT INTO UTPPHS
       (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
        WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
        LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
       VALUES 
       (A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
        UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP,
        'attributes for '||UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'||A_PP||'" are updated',
        CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ , L_EV_SEQ_NR); 
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('Save1PpAttribute', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'Save1PpAttribute'));
END SAVE1PPATTRIBUTE;

FUNCTION SAVEPPPRATTRIBUTE
(A_PP                       IN        VARCHAR2,                 
 A_VERSION                  IN        VARCHAR2,                 
 A_PP_KEY1                  IN        VARCHAR2,                 
 A_PP_KEY2                  IN        VARCHAR2,                 
 A_PP_KEY3                  IN        VARCHAR2,                 
 A_PP_KEY4                  IN        VARCHAR2,                 
 A_PP_KEY5                  IN        VARCHAR2,                 
 A_PR                       IN        VARCHAR2,                 
 A_PR_VERSION               IN        VARCHAR2,                 
 A_AU                       IN        UNAPIGEN.VC20_TABLE_TYPE, 
 A_AU_VERSION               IN OUT    UNAPIGEN.VC20_TABLE_TYPE, 
 A_VALUE                    IN        UNAPIGEN.VC40_TABLE_TYPE, 
 A_NR_OF_ROWS               IN        NUMBER,                   
 A_MODIFY_REASON            IN        VARCHAR2)                 
RETURN NUMBER IS

L_AU           VARCHAR2(20);
L_AU_VERSION   VARCHAR2(20);
L_VALUE        VARCHAR2(40);
L_ALLOW_MODIFY CHAR(1);
L_AUSEQ        NUMBER;
L_LOG_HS       CHAR(1);
L_ACTIVE       CHAR(1);
L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_OBJECT_ID    VARCHAR2(20);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIPPP.GETPPAUTHORISATION(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, 
                                             A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, L_LC, 
                                             L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPP
   SET ALLOW_MODIFY = '#'
    WHERE PP = A_PP
     AND VERSION = A_VERSION
     AND PP_KEY1 = A_PP_KEY1
     AND PP_KEY2 = A_PP_KEY2
     AND PP_KEY3 = A_PP_KEY3
     AND PP_KEY4 = A_PP_KEY4
     AND PP_KEY5 = A_PP_KEY5;
   IF SQL%ROWCOUNT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
      RAISE STPERROR;
   END IF;

   DELETE FROM UTPPPRAU 
   WHERE PP = A_PP
   AND VERSION = A_VERSION
   AND PP_KEY1 =A_PP_KEY1
   AND PP_KEY2 =A_PP_KEY2
   AND PP_KEY3 =A_PP_KEY3
   AND PP_KEY4 =A_PP_KEY4
   AND PP_KEY5 =A_PP_KEY5
   AND PR = A_PR;

   
   FOR I IN 1..A_NR_OF_ROWS LOOP
      INSERT INTO UTPPPRAU
      (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR, PR_VERSION,
       AU, AU_VERSION, AUSEQ, VALUE)
      VALUES
      (A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, A_PR, A_PR_VERSION,
       A_AU(I), NULL, I, A_VALUE(I));
   END LOOP;

   L_EVENT_TP := 'AttributesUpdated';
   L_EV_DETAILS := 'version='||A_VERSION||
                   '#pp_key1='||A_PP_KEY1||
                   '#pp_key2='||A_PP_KEY2||
                   '#pp_key3='||A_PP_KEY3||
                   '#pp_key4='||A_PP_KEY4||
                   '#pp_key5='||A_PP_KEY5;   
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT ('SavePpPrAttribute',
               UNAPIGEN.P_EVMGR_NAME, 'pp', A_PP, L_LC, L_LC_VERSION, L_SS,
               L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') THEN
       INSERT INTO UTPPHS
       (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
        WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
        LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
       VALUES 
       (A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
        UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP,
        'attributes for '||UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'||A_PP||
        '" used in object '||UNAPIGEN.GETOBJTPDESCRIPTION('pr')||' "'||A_PR||'" are updated',
        CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ , L_EV_SEQ_NR); 
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SavePpPrAttribute', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SavePpPrAttribute'));
END SAVEPPPRATTRIBUTE;

FUNCTION SAVE1PPPRATTRIBUTE
(A_PP                       IN        VARCHAR2,                 
 A_VERSION                  IN        VARCHAR2,                 
 A_PP_KEY1                  IN        VARCHAR2,                 
 A_PP_KEY2                  IN        VARCHAR2,                 
 A_PP_KEY3                  IN        VARCHAR2,                 
 A_PP_KEY4                  IN        VARCHAR2,                 
 A_PP_KEY5                  IN        VARCHAR2,                 
 A_PR                       IN        VARCHAR2,                 
 A_PR_VERSION               IN        VARCHAR2,                 
 A_AU                       IN        VARCHAR2,                 
 A_AU_VERSION               IN OUT    VARCHAR2,                 
 A_VALUE                    IN        UNAPIGEN.VC40_TABLE_TYPE, 
 A_NR_OF_ROWS               IN        NUMBER,                   
 A_MODIFY_REASON            IN        VARCHAR2)                 
RETURN NUMBER IS

L_AU           VARCHAR2(20);
L_AU_VERSION   VARCHAR2(20);
L_VALUE        VARCHAR2(40);
L_ALLOW_MODIFY CHAR(1);
L_AUSEQ        NUMBER;
L_LOG_HS       CHAR(1);
L_ACTIVE       CHAR(1);
L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_OBJECT_ID    VARCHAR2(20);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PP, ' ') = ' ' OR 
      NVL(A_PR, ' ') = ' ' OR
      NVL(A_AU, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' OR
      NVL(A_PR_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIPPP.GETPPAUTHORISATION(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, 
                                             A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, L_LC, 
                                             L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPP
   SET ALLOW_MODIFY = '#'
    WHERE PP = A_PP
     AND VERSION = A_VERSION
     AND PP_KEY1 = A_PP_KEY1
     AND PP_KEY2 = A_PP_KEY2
     AND PP_KEY3 = A_PP_KEY3
     AND PP_KEY4 = A_PP_KEY4
     AND PP_KEY5 = A_PP_KEY5;
   IF SQL%ROWCOUNT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
      RAISE STPERROR;
   END IF;

   DELETE FROM UTPPPRAU 
   WHERE PP = A_PP
   AND VERSION = A_VERSION
   AND PP_KEY1 =A_PP_KEY1
   AND PP_KEY2 =A_PP_KEY2
   AND PP_KEY3 =A_PP_KEY3
   AND PP_KEY4 =A_PP_KEY4
   AND PP_KEY5 =A_PP_KEY5
   AND PR = A_PR
   AND AU = A_AU;

   
   FOR I IN 1..A_NR_OF_ROWS LOOP
      INSERT INTO UTPPPRAU
      (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, PR, PR_VERSION,
       AU, AU_VERSION, AUSEQ, VALUE)
      VALUES
      (A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, A_PR, A_PR_VERSION,
       A_AU, NULL, I, A_VALUE(I));
   END LOOP;

   L_EVENT_TP := 'AttributesUpdated';
   L_EV_DETAILS := 'version='||A_VERSION||
                   '#pp_key1='||A_PP_KEY1||
                   '#pp_key2='||A_PP_KEY2||
                   '#pp_key3='||A_PP_KEY3||
                   '#pp_key4='||A_PP_KEY4||
                   '#pp_key5='||A_PP_KEY5;   
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT ('Save1PpPrAttribute',
               UNAPIGEN.P_EVMGR_NAME, 'pp', A_PP, L_LC, L_LC_VERSION, L_SS,
               L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') THEN
       INSERT INTO UTPPHS
       (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
        WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
        LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
       VALUES 
       (A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
        UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP,
        'attributes for '||UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'||A_PP||
        '" used in object '||UNAPIGEN.GETOBJTPDESCRIPTION('pr')||' "'||A_PR||'" are updated',
        CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ , L_EV_SEQ_NR); 
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('Save1PpPrAttribute', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'Save1PpPrAttribute'));
END SAVE1PPPRATTRIBUTE;

FUNCTION GETPPHISTORY
(A_PP               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY1          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY2          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY3          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY4          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY5          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_WHO              OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_WHO_DESCRIPTION  OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_WHAT             OUT     UNAPIGEN.VC60_TABLE_TYPE,  
 A_WHAT_DESCRIPTION OUT     UNAPIGEN.VC255_TABLE_TYPE, 
 A_LOGDATE          OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_WHY              OUT     UNAPIGEN.VC255_TABLE_TYPE, 
 A_TR_SEQ           OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_EV_SEQ           OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_WHERE_CLAUSE     IN      VARCHAR2)                  
RETURN NUMBER IS

L_NR_OF_ROWS_IN               INTEGER;
L_NR_OF_ROWS_OUT              INTEGER;


L_PP_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
L_VERSION_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY1_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY2_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY3_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY4_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_PP_KEY5_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
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
   L_RET_CODE := GETPPHISTORY(A_PP,
                              A_VERSION,
                              A_PP_KEY1,
                              A_PP_KEY2,
                              A_PP_KEY3,
                              A_PP_KEY4,
                              A_PP_KEY5,
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
          
          L_RET_CODE := GETPPHISTORY(L_PP_TAB,             
                                     L_VERSION_TAB,
                                     L_PP_KEY1_TAB,
                                     L_PP_KEY2_TAB,
                                     L_PP_KEY3_TAB,
                                     L_PP_KEY4_TAB,
                                     L_PP_KEY5_TAB,
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
             'GetPpHistory', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPPHISTORY;

FUNCTION GETPPHISTORY
(A_PP               OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY1          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY2          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY3          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY4          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY5          OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_WHO              OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_WHO_DESCRIPTION  OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_WHAT             OUT     UNAPIGEN.VC60_TABLE_TYPE,  
 A_WHAT_DESCRIPTION OUT     UNAPIGEN.VC255_TABLE_TYPE, 
 A_LOGDATE          OUT     UNAPIGEN.DATE_TABLE_TYPE,  
 A_WHY              OUT     UNAPIGEN.VC255_TABLE_TYPE, 
 A_TR_SEQ           OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_EV_SEQ           OUT     UNAPIGEN.NUM_TABLE_TYPE,   
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_WHERE_CLAUSE     IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS

L_PP                VARCHAR2(20);
L_VERSION           VARCHAR2(20);
L_PP_KEY1           VARCHAR2(20);
L_PP_KEY2           VARCHAR2(20);
L_PP_KEY3           VARCHAR2(20);
L_PP_KEY4           VARCHAR2(20);
L_PP_KEY5           VARCHAR2(20);
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
         L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uvpp x WHERE x.version_is_current = ''1'' '||
                           'AND hs.version = x.version '||  
                           'AND hs.pp = x.pp '||
                           'AND hs.pp =''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                           ''' AND hs.pp_key1='' '' AND hs.pp_key2='' '' AND hs.pp_key3='' ''' ||
                           ' AND hs.pp_key4='' '' AND hs.pp_key5='' ''' ||
                           ' ORDER BY hs.logdate DESC'; 
      ELSE
         L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
      END IF;

      
      L_WHERE_CLAUSE := REPLACE(REPLACE(L_WHERE_CLAUSE, 
                                        'logdate DESC', 
                                        'logdate DESC, hs.ROWID DESC'),
                                'LOGDATE DESC', 
                                'LOGDATE DESC, hs.ROWID DESC');

      IF DBMS_SQL.IS_OPEN(P_HS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(P_HS_CURSOR);
      END IF;
      P_HS_CURSOR := DBMS_SQL.OPEN_CURSOR;
      L_SQL_STRING := 'SELECT hs.pp, hs.version, hs.pp_key1, hs.pp_key2, hs.pp_key3, hs.pp_key4, hs.pp_key5, '||
                      'hs.who, hs.who_description, hs.what, hs.what_description, hs.logdate, hs.why, hs.tr_seq, hs.ev_seq '||
                      'FROM dd' || UNAPIGEN.P_DD || '.uvpphs hs ' ||
                      L_WHERE_CLAUSE;
      DBMS_SQL.PARSE(P_HS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 1, L_PP, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 2, L_VERSION, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 3, L_PP_KEY1, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 4, L_PP_KEY2, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 5, L_PP_KEY3, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 6, L_PP_KEY4, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 7, L_PP_KEY5, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 8, L_WHO, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 9, L_WHO_DESCRIPTION, 40);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR,10, L_WHAT, 60);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR,11, L_WHAT_DESCRIPTION, 255);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR,12, L_LOGDATE);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR,13, L_WHY, 255);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR,14, L_TR_SEQ);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR,15, L_EV_SEQ);
      L_RESULT := DBMS_SQL.EXECUTE(P_HS_CURSOR);
   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(P_HS_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 1, L_PP);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 2, L_VERSION);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 3, L_PP_KEY1);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 4, L_PP_KEY2);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 5, L_PP_KEY3);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 6, L_PP_KEY4);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 7, L_PP_KEY5);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 8, L_WHO);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 9, L_WHO_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR,10, L_WHAT);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR,11, L_WHAT_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR,12, L_LOGDATE);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR,13, L_WHY);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR,14, L_TR_SEQ);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR,15, L_EV_SEQ);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_PP(L_FETCHED_ROWS) := L_PP;
      A_VERSION(L_FETCHED_ROWS) := L_VERSION;
      A_PP_KEY1(L_FETCHED_ROWS) := L_PP_KEY1;
      A_PP_KEY2(L_FETCHED_ROWS) := L_PP_KEY2;
      A_PP_KEY3(L_FETCHED_ROWS) := L_PP_KEY3;
      A_PP_KEY4(L_FETCHED_ROWS) := L_PP_KEY4;
      A_PP_KEY5(L_FETCHED_ROWS) := L_PP_KEY5;
      A_WHO(L_FETCHED_ROWS) := L_WHO;
      A_WHO_DESCRIPTION(L_FETCHED_ROWS) := L_WHO_DESCRIPTION;
      A_WHAT(L_FETCHED_ROWS) := L_WHAT;
      A_WHAT_DESCRIPTION(L_FETCHED_ROWS) := L_WHAT_DESCRIPTION;
      A_LOGDATE(L_FETCHED_ROWS) := TO_CHAR(L_LOGDATE);
      A_WHY(L_FETCHED_ROWS) := L_WHY;
      A_TR_SEQ(L_FETCHED_ROWS) := L_TR_SEQ;
      A_EV_SEQ(L_FETCHED_ROWS) := L_EV_SEQ;

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
             'GetPpHistory', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(P_HS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(P_HS_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPPHISTORY;

FUNCTION SAVEPPHISTORY
(A_PP                IN        VARCHAR2,                   
 A_VERSION           IN        VARCHAR2,                   
 A_PP_KEY1           IN        VARCHAR2,                   
 A_PP_KEY2           IN        VARCHAR2,                   
 A_PP_KEY3           IN        VARCHAR2,                   
 A_PP_KEY4           IN        VARCHAR2,                   
 A_PP_KEY5           IN        VARCHAR2,                   
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

L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_SS                   VARCHAR2(2);
L_LOG_HS               CHAR(1);
L_ALLOW_MODIFY         CHAR(1);
L_ACTIVE               CHAR(1);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_NR_OF_ROWS, -1) < 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NROFROWS;
      RAISE STPERROR;
   END IF;

   IF NVL(A_PP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIPPP.GETPPAUTHORISATION(A_PP, A_VERSION, 
                                             A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, 
                                             L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      UPDATE UTPPHS
      SET WHY = A_WHY(L_SEQ_NO)
      WHERE PP = A_PP
        AND VERSION = A_VERSION
        AND PP_KEY1 = A_PP_KEY1
        AND PP_KEY2 = A_PP_KEY2
        AND PP_KEY3 = A_PP_KEY3
        AND PP_KEY4 = A_PP_KEY4
        AND PP_KEY5 = A_PP_KEY5
        AND WHO = A_WHO(L_SEQ_NO)
        AND WHO_DESCRIPTION = A_WHO_DESCRIPTION(L_SEQ_NO)
        AND TO_CHAR(LOGDATE) = A_LOGDATE(L_SEQ_NO)
        AND WHAT = A_WHAT(L_SEQ_NO)
        AND WHAT_DESCRIPTION = A_WHAT_DESCRIPTION(L_SEQ_NO)
        AND TR_SEQ = A_TR_SEQ(L_SEQ_NO)
        AND EV_SEQ = A_EV_SEQ(L_SEQ_NO);

      IF SQL%ROWCOUNT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
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
      UNAPIGEN.LOGERROR('SavePpHistory', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SavePpHistory'));
END SAVEPPHISTORY;

FUNCTION GETPPACCESS
(A_PP               IN      VARCHAR2,                  
 A_VERSION          IN      VARCHAR2,                  
 A_PP_KEY1          IN      VARCHAR2,                  
 A_PP_KEY2          IN      VARCHAR2,                  
 A_PP_KEY3          IN      VARCHAR2,                  
 A_PP_KEY4          IN      VARCHAR2,                  
 A_PP_KEY5          IN      VARCHAR2,                  
 A_DD               OUT     UNAPIGEN.VC3_TABLE_TYPE,    
 A_DATA_DOMAIN      OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_ACCESS_RIGHTS    OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NR_OF_ROWS       IN OUT  NUMBER)                    
RETURN NUMBER IS

L_DD_DESCRIPTION VARCHAR2(40);
L_AR             UNAPIGEN.CHAR1_TABLE_TYPE; 
L_DD             VARCHAR2(3);
L_DESCRIPTION    UNAPIGEN.VC40_TABLE_TYPE;
L_ROW            INTEGER;
L_DD_CURSOR      UNAPIGEN.CURSOR_REF_TYPE;
L_AR_CURSOR      UNAPIGEN.CURSOR_REF_TYPE;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_PP, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_NOOBJID);
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_NOOBJVERSION);
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      RETURN (UNAPIGEN.DBERR_NOPPKEYID);
   END IF;

   
   
   
   L_SQL_STRING:= 'SELECT dd, description FROM dd'||UNAPIGEN.P_DD||'.uvdd ORDER BY dd';
   OPEN L_DD_CURSOR FOR L_SQL_STRING;
   FOR I IN 1..UNAPIGEN.P_DATADOMAINS LOOP
      FETCH L_DD_CURSOR INTO L_DD, L_DD_DESCRIPTION;
      L_DESCRIPTION(L_DD) := L_DD_DESCRIPTION;
   END LOOP;
   CLOSE L_DD_CURSOR;

   L_SQL_STRING:= 
      'SELECT ar1, ar2, ar3, ar4, ar5, ar6, ar7, ar8, ar9, ar10, ar11, ar12, ar13, ar14, ar15, ar16, ' ||
      'ar17, ar18, ar19, ar20, ar21, ar22, ar23, ar24, ar25, ar26, ar27, ar28, ar29, ar30, ar31, ' ||
      'ar32, ar33, ar34, ar35, ar36, ar37, ar38, ar39, ar40, ar41, ar42, ar43, ar44, ar45, ar46, ' ||
      'ar47, ar48, ar49, ar50, ar51, ar52, ar53, ar54, ar55, ar56, ar57, ar58, ar59, ar60, ar61, ' ||
      'ar62, ar63, ar64, ar65, ar66, ar67, ar68, ar69, ar70, ar71, ar72, ar73, ar74, ar75, ar76, ' ||
      'ar77, ar78, ar79, ar80, ar81, ar82, ar83, ar84, ar85, ar86, ar87, ar88, ar89, ar90, ar91, ' ||
      'ar92, ar93, ar94, ar95, ar96, ar97, ar98, ar99, ar100, ar101, ar102, ar103, ar104, ar105, ' ||
      'ar106, ar107, ar108, ar109, ar110, ar111, ar112, ar113, ar114, ar115, ar116, ar117, ar118, ' ||
      'ar119, ar120, ar121, ar122, ar123, ar124, ar125, ar126, ar127, ar128 FROM udpp ' || 
      ' WHERE pp=:a_pp  AND version=:a_version AND pp_key1=:a_pp_key1 AND pp_key2=:a_pp_key2 '||
      ' AND pp_key3=:a_pp_key3 AND pp_key4=:a_pp_key4 AND pp_key5=:a_pp_key5';
   L_FETCHED_ROWS := 0;
   OPEN L_AR_CURSOR 
   FOR L_SQL_STRING
   USING A_PP, A_VERSION , A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5;
   LOOP
      FETCH L_AR_CURSOR INTO L_AR(1),L_AR(2),L_AR(3),L_AR(4),L_AR(5),L_AR(6),L_AR(7),L_AR(8),L_AR(9),
      L_AR(10),L_AR(11),L_AR(12),L_AR(13),L_AR(14),L_AR(15),L_AR(16),L_AR(17),L_AR(18),L_AR(19),
      L_AR(20),L_AR(21),L_AR(22),L_AR(23),L_AR(24),L_AR(25),L_AR(26),L_AR(27),L_AR(28),L_AR(29),
      L_AR(30),L_AR(31),L_AR(32),L_AR(33),L_AR(34),L_AR(35),L_AR(36),L_AR(37),L_AR(38),L_AR(39),
      L_AR(40),L_AR(41),L_AR(42),L_AR(43),L_AR(44),L_AR(45),L_AR(46),L_AR(47),L_AR(48),L_AR(49),
      L_AR(50),L_AR(51),L_AR(52),L_AR(53),L_AR(54),L_AR(55),L_AR(56),L_AR(57),L_AR(58),L_AR(59),
      L_AR(60),L_AR(61),L_AR(62),L_AR(63),L_AR(64),L_AR(65),L_AR(66),L_AR(67),L_AR(68),L_AR(69),
      L_AR(70),L_AR(71),L_AR(72),L_AR(73),L_AR(74),L_AR(75),L_AR(76),L_AR(77),L_AR(78),L_AR(79),
      L_AR(80),L_AR(81),L_AR(82),L_AR(83),L_AR(84),L_AR(85),L_AR(86),L_AR(87),L_AR(88),L_AR(89),
      L_AR(90),L_AR(91),L_AR(92),L_AR(93),L_AR(94),L_AR(95),L_AR(96),L_AR(97),L_AR(98),L_AR(99),
      L_AR(100),L_AR(101),L_AR(102),L_AR(103),L_AR(104),L_AR(105),L_AR(106),L_AR(107),L_AR(108),
      L_AR(109),L_AR(110),L_AR(111),L_AR(112),L_AR(113),L_AR(114),L_AR(115),L_AR(116),L_AR(117),
      L_AR(118),L_AR(119),L_AR(120),L_AR(121),L_AR(122),L_AR(123),L_AR(124),L_AR(125),L_AR(126),
      L_AR(127),L_AR(128);
      EXIT WHEN L_AR_CURSOR%NOTFOUND;
      
      FOR L_ROW IN 1..UNAPIGEN.P_DATADOMAINS LOOP
          L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
          A_DD(L_FETCHED_ROWS) := TO_CHAR(L_ROW);
          A_DATA_DOMAIN(L_FETCHED_ROWS) := L_DESCRIPTION(L_ROW);
          A_ACCESS_RIGHTS(L_FETCHED_ROWS) := L_AR(L_ROW);
          IF L_FETCHED_ROWS >= A_NR_OF_ROWS THEN
             EXIT;
          END IF;
      END LOOP;
      IF L_FETCHED_ROWS >= A_NR_OF_ROWS THEN
         EXIT;
      END IF;
   END LOOP;
   CLOSE L_AR_CURSOR;

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN NO_DATA_FOUND THEN
   IF L_DD_CURSOR%ISOPEN THEN
      CLOSE L_DD_CURSOR;
   END IF;
   IF L_AR_CURSOR%ISOPEN THEN
      CLOSE L_AR_CURSOR;
   END IF;
   RETURN(UNAPIGEN.DBERR_SYSDEFAULTS);
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   IF L_DD_CURSOR%ISOPEN THEN
      CLOSE L_DD_CURSOR;
   END IF;
   IF L_AR_CURSOR%ISOPEN THEN
      CLOSE L_AR_CURSOR;
   END IF;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
           'GetPpAccess', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPPACCESS;

FUNCTION SAVEPPACCESS
(A_PP                 IN     VARCHAR2,                  
 A_VERSION            IN     VARCHAR2,                  
 A_PP_KEY1            IN     VARCHAR2,                  
 A_PP_KEY2            IN     VARCHAR2,                  
 A_PP_KEY3            IN     VARCHAR2,                  
 A_PP_KEY4            IN     VARCHAR2,                  
 A_PP_KEY5            IN     VARCHAR2,                  
 A_DD                 IN     UNAPIGEN.VC3_TABLE_TYPE,   
 A_ACCESS_RIGHTS      IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NR_OF_ROWS         IN     NUMBER,                    
 A_MODIFY_REASON      IN     VARCHAR2)                  
RETURN NUMBER IS

L_ALLOW_MODIFY         CHAR(1);
L_LOG_HS               CHAR(1);
L_ACTIVE               CHAR(1);
L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_SS                   VARCHAR2(2);
L_AR_CURSOR            INTEGER;
L_WRITE_FOUND          BOOLEAN;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_NR_OF_ROWS, -1) < 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NROFROWS;
      RAISE STPERROR;
   END IF;

   IF NVL(A_PP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIPPP.GETPPAUTHORISATION(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, 
                                             A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, L_LC, 
                                             L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPP
   SET ALLOW_MODIFY = '#'
    WHERE PP = A_PP
     AND VERSION = A_VERSION
     AND PP_KEY1 = A_PP_KEY1
     AND PP_KEY2 = A_PP_KEY2
     AND PP_KEY3 = A_PP_KEY3
     AND PP_KEY4 = A_PP_KEY4
     AND PP_KEY5 = A_PP_KEY5;
   IF SQL%ROWCOUNT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
      RAISE STPERROR;
   END IF;

   
   
   
   
   L_SQL_STRING := '';
   L_WRITE_FOUND := FALSE;
   FOR L_CTR IN 1..A_NR_OF_ROWS LOOP

      IF NVL(A_ACCESS_RIGHTS(L_CTR), 'N') NOT IN ('R','W','N') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_AR;
         RAISE STPERROR;
      END IF;

      IF NVL(A_ACCESS_RIGHTS(L_CTR), 'N') = 'W' THEN
         L_WRITE_FOUND := TRUE;
      END IF;

      IF (NVL(TO_NUMBER(A_DD(L_CTR)), -1) < 0) OR (NVL(TO_NUMBER(A_DD(L_CTR)), -1) > UNAPIGEN.P_DATADOMAINS) THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_DD;
         RAISE STPERROR;
      END IF;

      L_SQL_STRING := L_SQL_STRING || ' ar' || A_DD(L_CTR) ||
                   '= ''' || NVL(A_ACCESS_RIGHTS(L_CTR), 'N') || '''';
      IF L_CTR <> A_NR_OF_ROWS THEN
        L_SQL_STRING :=  L_SQL_STRING || ',';
      END IF;
   END LOOP;

   
   IF NOT L_WRITE_FOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOWRITEACCESS;
      RAISE STPERROR;
   END IF;

   IF NVL(L_SQL_STRING, ' ')  = ' ' THEN
      
      
      
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NROFROWS;
      RAISE STPERROR;
   ELSE
            
      
      
      
      L_SQL_STRING := 
         'UPDATE utpp SET '|| L_SQL_STRING || 
         ' WHERE pp = :a_pp' || 
         ' AND version = :a_version' || 
         ' AND pp_key1 = :a_pp_key1' || 
         ' AND pp_key2 = :a_pp_key2' || 
         ' AND pp_key3 = :a_pp_key3' || 
         ' AND pp_key4 = :a_pp_key4' || 
         ' AND pp_key5 = :a_pp_key5';   

      
      
      
      L_AR_CURSOR := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE(L_AR_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

      DBMS_SQL.BIND_VARIABLE(L_AR_CURSOR, ':a_pp',        A_PP);
      DBMS_SQL.BIND_VARIABLE(L_AR_CURSOR, ':a_version',   A_VERSION);
      DBMS_SQL.BIND_VARIABLE(L_AR_CURSOR, ':a_pp_key1',   A_PP_KEY1);
      DBMS_SQL.BIND_VARIABLE(L_AR_CURSOR, ':a_pp_key2',   A_PP_KEY2);
      DBMS_SQL.BIND_VARIABLE(L_AR_CURSOR, ':a_pp_key3',   A_PP_KEY3);
      DBMS_SQL.BIND_VARIABLE(L_AR_CURSOR, ':a_pp_key4',   A_PP_KEY4);
      DBMS_SQL.BIND_VARIABLE(L_AR_CURSOR, ':a_pp_key5',   A_PP_KEY5);

      L_RESULT := DBMS_SQL.EXECUTE(L_AR_CURSOR);
      IF L_RESULT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
         RAISE STPERROR;
      END IF;

      DBMS_SQL.CLOSE_CURSOR(L_AR_CURSOR);

      
      
      
      L_EVENT_TP := 'AccessRightsUpdated';
      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'version='||A_VERSION||
                      '#pp_key1='||A_PP_KEY1||
                      '#pp_key2='||A_PP_KEY2||
                      '#pp_key3='||A_PP_KEY3||
                      '#pp_key4='||A_PP_KEY4||
                      '#pp_key5='||A_PP_KEY5;   
      L_RESULT := UNAPIEV.INSERTEVENT('SavePpAccess', UNAPIGEN.P_EVMGR_NAME, 'pp', A_PP, L_LC, 
                                      L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;

      IF L_LOG_HS = '1' THEN
         INSERT INTO UTPPHS(PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
                            WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
                            LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
                UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'access rights for '||UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'||
                A_PP||'" are updated',
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SavePpAccess', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_AR_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_AR_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SavePpAccess'));
END SAVEPPACCESS;

FUNCTION PPTRANSITIONAUTHORISED
(A_PP                 IN        VARCHAR2,     
 A_VERSION            IN        VARCHAR2,     
 A_PP_KEY1            IN        VARCHAR2,     
 A_PP_KEY2            IN        VARCHAR2,     
 A_PP_KEY3            IN        VARCHAR2,     
 A_PP_KEY4            IN        VARCHAR2,     
 A_PP_KEY5            IN        VARCHAR2,     
 A_LC                 IN OUT    VARCHAR2,     
 A_LC_VERSION         IN OUT    VARCHAR2,     
 A_OLD_SS             IN OUT    VARCHAR2,     
 A_NEW_SS             IN        VARCHAR2,     
 A_AUTHORISED_BY      IN        VARCHAR2,     
 A_LC_SS_FROM         OUT       VARCHAR2,     
 A_TR_NO              OUT       NUMBER,       
 A_ALLOW_MODIFY       OUT       CHAR,         
 A_ACTIVE             OUT       CHAR,         
 A_LOG_HS             OUT       CHAR)         
RETURN NUMBER IS

L_LC                  VARCHAR2(2);
L_LC_VERSION          VARCHAR2(20);
L_SS                  VARCHAR2(2);
L_OLD_ACTIVE          CHAR(1);
L_OLD_ALLOW_MODIFY    CHAR(1);
L_TR_OK               BOOLEAN;
L_RQ                  VARCHAR2(20);
L_LOCK_PP             VARCHAR2(20);

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

   IF NVL(A_PP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
      RAISE STPERROR;
   END IF;

   
   SELECT PP
   INTO L_LOCK_PP
   FROM UTPP
   WHERE PP = A_PP
   AND VERSION = A_VERSION
   AND PP_KEY1 = A_PP_KEY1
   AND PP_KEY2 = A_PP_KEY2
   AND PP_KEY3 = A_PP_KEY3
   AND PP_KEY4 = A_PP_KEY4
   AND PP_KEY5 = A_PP_KEY5
   FOR UPDATE;   

   L_RET_CODE := UNAPIPPP.GETPPAUTHORISATION(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, 
                                             A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, L_LC, 
                                             L_LC_VERSION, L_SS, L_OLD_ALLOW_MODIFY, 
                                             L_OLD_ACTIVE, A_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
      L_RET_CODE <> UNAPIGEN.DBERR_NOTMODIFIABLE THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
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
         L_TR_OK := FALSE;
      ELSE
      
         
         
         IF NVL(A_AUTHORISED_BY, UNAPIGEN.P_USER) = UNAPIGEN.P_DBA_NAME THEN
            L_TR_OK := TRUE;
         ELSE
            
            
            
            
            
            
            
            OPEN L_TRDYN_CURSOR (L_LC, L_LC_VERSION, L_SS, A_NEW_SS);
            LOOP
               FETCH L_TRDYN_CURSOR INTO  UNAPIAUT.P_LCTRUS_REC;
               IF L_TRDYN_CURSOR%NOTFOUND THEN
                  L_TR_OK := FALSE;
                  EXIT;
               ELSE
                  UNAPIAUT.P_OBJECT_TP      := 'pp';
                  UNAPIAUT.P_OBJECT_ID      := A_PP;
                  UNAPIAUT.P_OBJECT_VERSION := A_VERSION;                  
                  UNAPIAUT.P_LC             := L_LC;
                  UNAPIAUT.P_SS_FROM        := L_SS;
                  UNAPIAUT.P_LC_SS_FROM     := UNAPIAUT.P_LCTRUS_REC.SS_FROM;
                  UNAPIAUT.P_SS_TO          := A_NEW_SS;
                  UNAPIAUT.P_TR_NO          := UNAPIAUT.P_LCTRUS_REC.TR_NO;
                  UNAPIAUT.P_RQ             := NULL;
                  UNAPIAUT.P_CH             := NULL;
                  UNAPIAUT.P_SD             := NULL;
                  UNAPIAUT.P_SC             := NULL;
                  UNAPIAUT.P_WS             := NULL;
                  UNAPIAUT.P_PG             := NULL;    UNAPIAUT.P_PGNODE := NULL;
                  UNAPIAUT.P_PA             := NULL;    UNAPIAUT.P_PANODE := NULL;
                  UNAPIAUT.P_ME             := NULL;    UNAPIAUT.P_MENODE := NULL;
                  UNAPIAUT.P_IC             := NULL;    UNAPIAUT.P_ICNODE := NULL;
                  UNAPIAUT.P_II             := NULL;    UNAPIAUT.P_IINODE := NULL;
                  UNAPIAUT.P_PP_KEY1        := A_PP_KEY1;                  
                  UNAPIAUT.P_PP_KEY2        := A_PP_KEY2;                  
                  UNAPIAUT.P_PP_KEY3        := A_PP_KEY3;                  
                  UNAPIAUT.P_PP_KEY4        := A_PP_KEY4;                  
                  UNAPIAUT.P_PP_KEY5        := A_PP_KEY5;
                  UNAPIAUT.P_LAB            := NULL;
                  A_LC_SS_FROM := UNAPIAUT.P_LCTRUS_REC.SS_FROM;
                  A_TR_NO := UNAPIAUT.P_LCTRUS_REC.TR_NO;
                  L_TR_OK := UNACCESS.TRANSITIONAUTHORISED;
                  IF L_TR_OK THEN
                     EXIT;
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
      UNAPIGEN.LOGERROR('PpTransitionAuthorised', SQLERRM);
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
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'PpTransitionAuthorised'));
END PPTRANSITIONAUTHORISED;

FUNCTION CHANGEPPSTATUS
(A_PP                 IN        VARCHAR2, 
 A_VERSION            IN        VARCHAR2, 
 A_PP_KEY1            IN        VARCHAR2, 
 A_PP_KEY2            IN        VARCHAR2, 
 A_PP_KEY3            IN        VARCHAR2, 
 A_PP_KEY4            IN        VARCHAR2, 
 A_PP_KEY5            IN        VARCHAR2, 
 A_OLD_SS             IN        VARCHAR2, 
 A_NEW_SS             IN        VARCHAR2, 
 A_OBJECT_LC          IN        VARCHAR2, 
 A_OBJECT_LC_VERSION  IN        VARCHAR2, 
 A_MODIFY_REASON      IN        VARCHAR2) 
RETURN NUMBER IS

L_LC                    VARCHAR2(2);
L_LC_VERSION            VARCHAR2(20);
L_OLD_SS                VARCHAR2(2);
L_ALLOW_MODIFY          CHAR(1);
L_ACTIVE                CHAR(1);
L_LOG_HS                CHAR(1);
L_LC_SS_FROM            VARCHAR2(2);
L_TR_NO                 NUMBER(3);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIPPP.PPTRANSITIONAUTHORISED
                    (A_PP, A_VERSION, 
                     A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
                     L_LC, L_LC_VERSION, L_OLD_SS, A_NEW_SS,
                     UNAPIGEN.P_USER,
                     L_LC_SS_FROM, L_TR_NO, 
                     L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
                  
                     
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
      L_RET_CODE <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      UPDATE UTPP
      SET SS = A_NEW_SS,
          ALLOW_MODIFY = '#',
          ACTIVE = L_ACTIVE
       WHERE PP = A_PP
        AND VERSION = A_VERSION
        AND PP_KEY1 = A_PP_KEY1
        AND PP_KEY2 = A_PP_KEY2
        AND PP_KEY3 = A_PP_KEY3
        AND PP_KEY4 = A_PP_KEY4
        AND PP_KEY5 = A_PP_KEY5;
   
      IF SQL%ROWCOUNT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
         RAISE STPERROR;
      END IF;
   
      L_EVENT_TP := 'ObjectStatusChanged';
      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'version='||A_VERSION||
                      '#pp_key1='||A_PP_KEY1||
                      '#pp_key2='||A_PP_KEY2||
                      '#pp_key3='||A_PP_KEY3||
                      '#pp_key4='||A_PP_KEY4||
                      '#pp_key5='||A_PP_KEY5||
                      '#tr_no=' || L_TR_NO || 
                      '#ss_from=' || L_OLD_SS  ||
                      '#lc_ss_from='|| L_LC_SS_FROM ;
      L_RESULT := UNAPIEV.INSERTEVENT('ChangePpStatus', UNAPIGEN.P_EVMGR_NAME, 'pp', A_PP, L_LC, 
                                      L_LC_VERSION, A_NEW_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;
   
      IF L_LOG_HS = '1' THEN
         INSERT INTO UTPPHS(PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
                            WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
                            LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
                UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'status of '||UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'||A_PP||
                '" is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||
                '] to "'||UNAPIGEN.SQLSSNAME(A_NEW_SS)||'" ['||A_NEW_SS||'].', 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   UNAPIAUT.UPDATEAUTHORISATIONBUFFER('pp', A_PP||A_PP_KEY1||A_PP_KEY2||A_PP_KEY3||A_PP_KEY4||A_PP_KEY5, 
                                      A_VERSION, A_NEW_SS);

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ChangePpStatus', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ChangePpStatus'));
END CHANGEPPSTATUS;

FUNCTION INTERNALCHANGEPPSTATUS           
(A_PP                 IN        VARCHAR2, 
 A_VERSION            IN        VARCHAR2, 
 A_PP_KEY1            IN        VARCHAR2, 
 A_PP_KEY2            IN        VARCHAR2, 
 A_PP_KEY3            IN        VARCHAR2, 
 A_PP_KEY4            IN        VARCHAR2, 
 A_PP_KEY5            IN        VARCHAR2, 
 A_NEW_SS             IN        VARCHAR2, 
 A_MODIFY_REASON      IN        VARCHAR2) 
RETURN NUMBER IS

L_RET_CODE                    INTEGER;

L_OLD_SS                      VARCHAR2(2);
L_LC                          VARCHAR2(2);
L_LC_VERSION                  VARCHAR2(20);


L_SEQ_NR                      NUMBER;


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

   IF NVL(A_PP, ' ') = ' ' OR
      NVL(A_NEW_SS, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIPRP.CHECKELECSIGNATURE(A_NEW_SS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      L_SQLERRM := 'Status '||A_NEW_SS ||' does not exist or must be signed electronically !';
      RAISE STPERROR;
   END IF;   

   
   L_TMP_RETRIESWHENINTRANSITION := UNAPIEV.P_RETRIESWHENINTRANSITION;
   L_TMP_INTERVALWHENINTRANSITION := UNAPIEV.P_INTERVALWHENINTRANSITION;
   UNAPIEV.P_RETRIESWHENINTRANSITION  := 1;
   UNAPIEV.P_INTERVALWHENINTRANSITION := 0.2;   

   
   
   IF A_NEW_SS <> '@C' THEN
      L_RET_CODE := UNAPIPPP.CHANGEPPSTATUS (A_PP, A_VERSION, 
                                             A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
                                             L_OLD_SS, A_NEW_SS, L_LC, L_LC_VERSION, A_MODIFY_REASON);

   ELSIF A_NEW_SS = '@C' THEN
      L_RET_CODE := UNAPIPPP.CANCELPP (A_PP, A_VERSION,
                                       A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, A_MODIFY_REASON);      
   END IF;
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS; 
      
      L_SEQ_NR := NULL;
      L_RET_CODE := UNAPIEV.INSERTEVENT
                      (A_API_NAME          => 'InternalChangePpStatus',
                       A_EVMGR_NAME        => UNAPIGEN.P_EVMGR_NAME,
                       A_OBJECT_TP         => 'pp',
                       A_OBJECT_ID         => A_PP,
                       A_OBJECT_LC         => NULL,
                       A_OBJECT_LC_VERSION => NULL,
                       A_OBJECT_SS         => NULL,
                       A_EV_TP             => 'ObjectUpdated',
                       A_EV_DETAILS        => 'version='||A_VERSION||
                                              '#pp_key1='||A_PP_KEY1||
                                              '#pp_key2='||A_PP_KEY2||
                                              '#pp_key3='||A_PP_KEY3||
                                              '#pp_key4='||A_PP_KEY4||
                                              '#pp_key5='||A_PP_KEY5||
                                              '#ss_to='||A_NEW_SS,
                       A_SEQ_NR            => L_SEQ_NR);
   END IF;

   
   UNAPIEV.P_RETRIESWHENINTRANSITION  := L_TMP_RETRIESWHENINTRANSITION;
   UNAPIEV.P_INTERVALWHENINTRANSITION := L_TMP_INTERVALWHENINTRANSITION;      

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   UNAPIAUT.UPDATEAUTHORISATIONBUFFER('pp', A_PP||A_PP_KEY1||A_PP_KEY2||A_PP_KEY3||A_PP_KEY4||A_PP_KEY5, 
                                         A_VERSION, A_NEW_SS);

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
      UNAPIGEN.LOGERROR('InternalChangePpStatus', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'InternalChangePpStatus'));
END INTERNALCHANGEPPSTATUS;

FUNCTION CANCELPP
(A_PP                 IN        VARCHAR2, 
 A_VERSION            IN        VARCHAR2, 
 A_PP_KEY1            IN        VARCHAR2, 
 A_PP_KEY2            IN        VARCHAR2, 
 A_PP_KEY3            IN        VARCHAR2, 
 A_PP_KEY4            IN        VARCHAR2, 
 A_PP_KEY5            IN        VARCHAR2, 
 A_MODIFY_REASON      IN        VARCHAR2) 
RETURN NUMBER IS

L_LC                          VARCHAR2(2);
L_LC_VERSION                  VARCHAR2(20);
L_OLD_SS                      VARCHAR2(2);
L_ALLOW_MODIFY                CHAR(1);
L_ACTIVE                      CHAR(1);
L_LOG_HS                      CHAR(1);
L_LC_SS_FROM                  VARCHAR2(2);
L_TR_NO                       NUMBER(3);

L_OBJECT_ID                   VARCHAR2(255);
L_CURRENT_TIMESTAMP                     VARCHAR2(40);
L_NEW_SS                      VARCHAR2(2);
L_PREVIOUS_ALLOW_MODIFY_CHECK CHAR(1);


BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   L_LC := NULL;
   L_LC_VERSION := NULL;
   L_OLD_SS := NULL; 
   L_NEW_SS := '@C';
   L_RET_CODE := UNAPIPPP.PPTRANSITIONAUTHORISED
                    (A_PP, A_VERSION, 
                     A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
                     L_LC, L_LC_VERSION, L_OLD_SS, L_NEW_SS,
                     UNAPIGEN.P_USER,
                     L_LC_SS_FROM, L_TR_NO, 
                     L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
                  
                     
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
      L_RET_CODE <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      
      
      
      
      
      L_EVENT_TP := 'ObjectCanceled';
      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'version='||A_VERSION||
                      '#pp_key1='||A_PP_KEY1||
                      '#pp_key2='||A_PP_KEY2||
                      '#pp_key3='||A_PP_KEY3||
                      '#pp_key4='||A_PP_KEY4||
                      '#pp_key5='||A_PP_KEY5||
                      '#tr_no=' || L_TR_NO ||
                      '#ss_from=' || L_OLD_SS ||
                      '#lc_ss_from='|| L_LC_SS_FROM;
      L_RESULT := UNAPIEV.INSERTEVENT('CancelPp', UNAPIGEN.P_EVMGR_NAME,
                                      'pp', A_PP, L_LC, L_LC_VERSION, L_NEW_SS,
                                      L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;


      IF L_LOG_HS = '1' THEN
         INSERT INTO UTPPHS(PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
                            WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
                            LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
                UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'||A_PP||
                '" canceled, status is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||
                '] to "'||UNAPIGEN.SQLSSNAME(L_NEW_SS)||'" ['||L_NEW_SS||'].',                
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
      
      
      
      
      
      UPDATE UTPP
      SET SS = L_NEW_SS,
          ALLOW_MODIFY = '#',
          ACTIVE = L_ACTIVE
      WHERE PP = A_PP
        AND VERSION = A_VERSION
        AND PP_KEY1 = A_PP_KEY1
        AND PP_KEY2 = A_PP_KEY2
        AND PP_KEY3 = A_PP_KEY3
        AND PP_KEY4 = A_PP_KEY4
        AND PP_KEY5 = A_PP_KEY5;
   
      IF SQL%ROWCOUNT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
         RAISE STPERROR;
      END IF;
   
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   UNAPIAUT.UPDATEAUTHORISATIONBUFFER('pp', A_PP||A_PP_KEY1||A_PP_KEY2||A_PP_KEY3||A_PP_KEY4||A_PP_KEY5, 
                                      A_VERSION, '@C');

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CancelPp', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CancelPp'));
END CANCELPP;

FUNCTION CHANGEPPLIFECYCLE
(A_PP                 IN        VARCHAR2, 
 A_VERSION            IN        VARCHAR2, 
 A_PP_KEY1            IN        VARCHAR2, 
 A_PP_KEY2            IN        VARCHAR2, 
 A_PP_KEY3            IN        VARCHAR2, 
 A_PP_KEY4            IN        VARCHAR2, 
 A_PP_KEY5            IN        VARCHAR2, 
 A_OLD_LC             IN        VARCHAR2, 
 A_OLD_LC_VERSION     IN        VARCHAR2, 
 A_NEW_LC             IN        VARCHAR2, 
 A_NEW_LC_VERSION     IN        VARCHAR2, 
 A_MODIFY_REASON      IN        VARCHAR2) 
RETURN NUMBER IS

L_ALLOW_MODIFY         CHAR(1);
L_ACTIVE               CHAR(1);
L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_SS                   VARCHAR2(2);
L_LOG_HS               CHAR(1);
L_COUNT_US             NUMBER;
L_COUNT_LC             NUMBER;
L_LOCK_PP              VARCHAR2(20);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
      RAISE STPERROR;
   END IF;

   
   SELECT PP
   INTO L_LOCK_PP
   FROM UTPP
   WHERE PP = A_PP
   AND VERSION = A_VERSION
   AND PP_KEY1 = A_PP_KEY1
   AND PP_KEY2 = A_PP_KEY2
   AND PP_KEY3 = A_PP_KEY3
   AND PP_KEY4 = A_PP_KEY4
   AND PP_KEY5 = A_PP_KEY5
   FOR UPDATE;   

   L_RET_CODE := UNAPIPPP.GETPPAUTHORISATION(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, 
                                             A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, L_LC, 
                                             L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF (L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
       L_RET_CODE <> UNAPIGEN.DBERR_NOTMODIFIABLE) THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
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

   IF L_COUNT_LC = 0 THEN
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

      IF L_COUNT_US = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTAUTHORISED;
         RAISE STPERROR;
      END IF;
   END IF;

   UPDATE UTPP
   SET LC = A_NEW_LC,
       LC_VERSION = UNVERSION.P_NO_VERSION,    
       ALLOW_MODIFY = '#',
       SS = ''
   WHERE PP = A_PP
     AND VERSION = A_VERSION
     AND PP_KEY1 = A_PP_KEY1
     AND PP_KEY2 = A_PP_KEY2
     AND PP_KEY3 = A_PP_KEY3
     AND PP_KEY4 = A_PP_KEY4
     AND PP_KEY5 = A_PP_KEY5;

   IF SQL%ROWCOUNT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
      RAISE STPERROR;
   END IF;

   L_EVENT_TP := 'ObjectLifeCycleChanged';
   L_EV_DETAILS := 'version='||A_VERSION||
                   '#pp_key1='||A_PP_KEY1||
                   '#pp_key2='||A_PP_KEY2||
                   '#pp_key3='||A_PP_KEY3||
                   '#pp_key4='||A_PP_KEY4||
                   '#pp_key5='||A_PP_KEY5||
                   '#from_lc=' || L_LC || 
                   '#from_lc_version='|| L_LC_VERSION || 
                   '#ss_from=' || L_SS;
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('ChangePpLifeCycle', UNAPIGEN.P_EVMGR_NAME, 'pp', A_PP, A_NEW_LC, 
                                   UNVERSION.P_NO_VERSION, '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);    
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' OR A_MODIFY_REASON IS NOT NULL THEN
         INSERT INTO UTPPHS(PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
                            WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
                            LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
                UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'life cycle of '||UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'||
                A_PP||'" is changed from "'||UNAPIGEN.SQLLCNAME(A_OLD_LC)||'" ['||A_OLD_LC||
                '] to "'||UNAPIGEN.SQLLCNAME(A_NEW_LC)||'" ['||A_NEW_LC||'].',
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ChangePpLifeCycle',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ChangePpLifeCycle'));
END CHANGEPPLIFECYCLE;

FUNCTION PPELECTRONICSIGNATURE
(A_PP                 IN        VARCHAR2, 
 A_VERSION            IN        VARCHAR2, 
 A_PP_KEY1            IN        VARCHAR2, 
 A_PP_KEY2            IN        VARCHAR2, 
 A_PP_KEY3            IN        VARCHAR2, 
 A_PP_KEY4            IN        VARCHAR2, 
 A_PP_KEY5            IN        VARCHAR2, 
 A_AUTHORISED_BY      IN        VARCHAR2, 
 A_MODIFY_REASON      IN        VARCHAR2) 
RETURN NUMBER IS

L_ST_VERSION             VARCHAR2(20);
L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_SS                     VARCHAR2(2);
L_ALLOW_MODIFY           CHAR(1);
L_ACTIVE                 CHAR(1);
L_LOG_HS                 CHAR(1);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   L_RET_CODE := UNAPIPPP.GETPPAUTHORISATION(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, 
                                             A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
      L_RET_CODE <> UNAPIGEN.DBERR_NOTMODIFIABLE THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF A_AUTHORISED_BY IS NOT NULL THEN
      L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
 
      INSERT INTO UTPPHS(PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5, 
                         WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, 
                         LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5,
             A_AUTHORISED_BY, UNAPIGEN.SQLUSERDESCRIPTION(A_AUTHORISED_BY), 'ElectronicSignature', 
             'Last action of '||UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'||A_PP||
                   '" is signed electronically.',
             CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);

   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('PpElectronicSignature', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'PpElectronicSignature'));
END PPELECTRONICSIGNATURE;

FUNCTION UPDATEPPWHATDESCRIPTION
(A_PP                 IN       VARCHAR2,                  
 A_VERSION            IN       VARCHAR2,                  
 A_PP_KEY1            IN       VARCHAR2,                  
 A_PP_KEY2            IN       VARCHAR2,                  
 A_PP_KEY3            IN       VARCHAR2,                  
 A_PP_KEY4            IN       VARCHAR2,                  
 A_PP_KEY5            IN       VARCHAR2,                  
 A_WHAT               IN       VARCHAR2,                  
 A_WHAT_DESCRIPTION   IN       VARCHAR2,                  
 A_TR_SEQ             IN       NUMBER,                    
 A_EV_SEQ             IN       NUMBER)                    
RETURN NUMBER IS

L_LC                VARCHAR2(2);
L_LC_VERSION        VARCHAR2(20);
L_SS                VARCHAR2(2);
L_ALLOW_MODIFY      CHAR(1);
L_ACTIVE            CHAR(1);
L_LOG_HS            CHAR(1);

BEGIN








   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.P_TXN_ERROR THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIPPP.GETPPAUTHORISATION(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, 
                                             A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, L_LC, 
                                           L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   UPDATE UTPPHS
      SET WHAT_DESCRIPTION = A_WHAT_DESCRIPTION
   WHERE PP = A_PP
     AND VERSION = A_VERSION
     AND PP_KEY1 = A_PP_KEY1
     AND PP_KEY2 = A_PP_KEY2
     AND PP_KEY3 = A_PP_KEY3
     AND PP_KEY4 = A_PP_KEY4
     AND PP_KEY5 = A_PP_KEY5
     AND TR_SEQ = A_TR_SEQ;
        
   IF SQL%ROWCOUNT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('UpdatePpWhatDescription', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'UpdatePpWhatDescription'));
END UPDATEPPWHATDESCRIPTION;

FUNCTION GETPPAUTHORISATION                
(A_PP                  IN        VARCHAR2, 
 A_VERSION             IN        VARCHAR2, 
 A_PP_KEY1             IN        VARCHAR2, 
 A_PP_KEY2             IN        VARCHAR2, 
 A_PP_KEY3             IN        VARCHAR2, 
 A_PP_KEY4             IN        VARCHAR2, 
 A_PP_KEY5             IN        VARCHAR2, 
 A_LC                  OUT       VARCHAR2, 
 A_LC_VERSION          OUT       VARCHAR2, 
 A_SS                  OUT       VARCHAR2, 
 A_ALLOW_MODIFY        OUT       CHAR,     
 A_ACTIVE              OUT       CHAR,     
 A_LOG_HS              OUT       CHAR)     
RETURN NUMBER IS

L_ACTIVE                   CHAR(1);
L_SS                       VARCHAR2(2);
L_LC                       VARCHAR2(2);
L_LC_VERSION               VARCHAR2(20);
L_ALLOW_MODIFY             CHAR(1);
L_LOG_HS                   CHAR(1);
L_AR                       CHAR(1) := '0';
L_AR_VAL                   CHAR(1);
L_AH_CURSOR                INTEGER;
L_CURRENT_LC_VERSION       VARCHAR2(20);
L_DEFAULT_LOG_HS           CHAR(1);
L_RETRIES                  INTEGER;
L_OBJECT_ID                VARCHAR2(255);
L_NO_ALLOW_MODIFY_CHECK    CHAR(1);
L_NO_AR_CHECK              CHAR(1);

BEGIN

   L_RET_CODE := UNAPIGEN.EVALPPVERSION(A_PP, A_VERSION, 
                                        A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5 );

   UNAPIAUT.P_NOT_AUTHORISED := NULL;
   L_OBJECT_ID := A_PP || A_PP_KEY1 || A_PP_KEY2 || A_PP_KEY3 || A_PP_KEY4 || A_PP_KEY5;
   L_RET_CODE := UNAPIAUT.GETALLOWMODIFYCHECKMODE(L_NO_ALLOW_MODIFY_CHECK);
   L_RET_CODE := UNAPIAUT.GETARCHECKMODE(L_NO_AR_CHECK);
   FOR L_SEQ_NO IN 1..UNAPIGEN.PA_OBJECT_NR LOOP
      IF UNAPIGEN.PA_OBJECT_TP(L_SEQ_NO) = 'pp' AND
         UNAPIGEN.PA_OBJECT_ID(L_SEQ_NO) = L_OBJECT_ID AND
         UNAPIGEN.PA_OBJECT_VERSION(L_SEQ_NO) = A_VERSION THEN
         A_LC           := UNAPIGEN.PA_OBJECT_LC      (L_SEQ_NO);
         A_LC_VERSION   := UNAPIGEN.PA_OBJECT_LC_VERSION (L_SEQ_NO);
         A_SS           := UNAPIGEN.PA_OBJECT_SS      (L_SEQ_NO);
         A_ALLOW_MODIFY := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO);
         A_ACTIVE       := UNAPIGEN.PA_OBJECT_ACTIVE  (L_SEQ_NO);
         A_LOG_HS       := UNAPIGEN.PA_OBJECT_LOG_HS  (L_SEQ_NO);
         IF UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(L_SEQ_NO) = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK = '1' THEN
               RETURN(UNAPIGEN.DBERR_SUCCESS);
            END IF;
         END IF;
         RETURN (UNAPIGEN.PA_OBJECT_PRIV(L_SEQ_NO));
      END IF;
   END LOOP;

   UNAPIGEN.PA_OBJECT_NR := UNAPIGEN.PA_OBJECT_NR + 1;
   UNAPIGEN.PA_OBJECT_TP(UNAPIGEN.PA_OBJECT_NR) := 'pp';
   UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR) := L_OBJECT_ID;
   UNAPIGEN.PA_OBJECT_VERSION(UNAPIGEN.PA_OBJECT_NR) := A_VERSION;
   
   L_RETRIES := UNAPIEV.P_RETRIESWHENINTRANSITION;
   BEGIN
      LOOP
         

         SELECT LC, LC_VERSION, SS, ACTIVE, ALLOW_MODIFY, LOG_HS,  
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
         INTO L_LC, L_LC_VERSION, L_SS, L_ACTIVE, L_ALLOW_MODIFY, L_LOG_HS, L_AR_VAL
         FROM UDPP
         WHERE PP      = A_PP
           AND VERSION = A_VERSION
           AND PP_KEY1 = A_PP_KEY1
           AND PP_KEY2 = A_PP_KEY2
           AND PP_KEY3 = A_PP_KEY3
           AND PP_KEY4 = A_PP_KEY4
           AND PP_KEY5 = A_PP_KEY5;

         EXIT WHEN NVL(L_ALLOW_MODIFY,' ') <> '#';
         EXIT WHEN (L_AR_VAL = 'N') AND (L_NO_AR_CHECK = '0');
         EXIT WHEN L_RETRIES <= 0;
         L_RETRIES := L_RETRIES - 1;
         DBMS_LOCK.SLEEP(UNAPIEV.P_INTERVALWHENINTRANSITION);
      END LOOP;
      
      IF L_AR_VAL = 'W' THEN
         IF L_ALLOW_MODIFY = '1' THEN
            
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSIF L_ALLOW_MODIFY = '0' THEN
            IF L_NO_ALLOW_MODIFY_CHECK = '1' THEN
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
            ELSE
               UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOTMODIFIABLE;
               UNAPIAUT.P_NOT_AUTHORISED := 'pp NOTMODIFIABLE:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
            END IF;
         ELSIF L_ALLOW_MODIFY = '#' THEN
            
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_TRANSITION;
            UNAPIAUT.P_NOT_AUTHORISED := 'pp IN TRANSITION:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         ELSE
            UNAPIGEN.LOGERROR('GetPpAuthorisation','allow_modify has illegal value');
            RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetPpAuthorisation'));
         END IF;
      ELSIF L_AR_VAL = 'R' THEN
         IF L_NO_AR_CHECK = '1' THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_READONLY;
            UNAPIAUT.P_NOT_AUTHORISED := 'pp READONLY:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         END IF;
      ELSE
         IF L_NO_AR_CHECK = '1' THEN
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_NOACCESS;
            UNAPIAUT.P_NOT_AUTHORISED := 'pp NOACCESS:'||UNAPIGEN.PA_OBJECT_ID(UNAPIGEN.PA_OBJECT_NR);
         END IF;
      END IF;

      UNAPIGEN.PA_OBJECT_LC           (UNAPIGEN.PA_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION   (UNAPIGEN.PA_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS           (UNAPIGEN.PA_OBJECT_NR) := L_SS;
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY (UNAPIGEN.PA_OBJECT_NR) := L_ALLOW_MODIFY;
      UNAPIGEN.PA_OBJECT_ACTIVE       (UNAPIGEN.PA_OBJECT_NR) := L_ACTIVE;
      UNAPIGEN.PA_OBJECT_LOG_HS       (UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS;

      A_LC           := UNAPIGEN.PA_OBJECT_LC          (UNAPIGEN.PA_OBJECT_NR);
      A_LC_VERSION   := UNAPIGEN.PA_OBJECT_LC_VERSION  (UNAPIGEN.PA_OBJECT_NR);
      A_SS           := UNAPIGEN.PA_OBJECT_SS          (UNAPIGEN.PA_OBJECT_NR);
      A_ALLOW_MODIFY := UNAPIGEN.PA_OBJECT_ALLOW_MODIFY(UNAPIGEN.PA_OBJECT_NR);
      A_ACTIVE       := UNAPIGEN.PA_OBJECT_ACTIVE      (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS       := UNAPIGEN.PA_OBJECT_LOG_HS      (UNAPIGEN.PA_OBJECT_NR);

      RETURN (UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR));

   EXCEPTION
   WHEN NO_DATA_FOUND THEN

      
      SELECT DEF_LC, LOG_HS
      INTO L_LC, L_LOG_HS
      FROM UTOBJECTS
      WHERE OBJECT = 'pp';

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

      
      
      
      UNAPIGEN.PA_OBJECT_PRIV(UNAPIGEN.PA_OBJECT_NR) := UNAPIGEN.DBERR_SUCCESS;
      UNAPIGEN.PA_OBJECT_LC    (UNAPIGEN.PA_OBJECT_NR) := L_LC;
      UNAPIGEN.PA_OBJECT_LC_VERSION (UNAPIGEN.PA_OBJECT_NR) := L_LC_VERSION;
      UNAPIGEN.PA_OBJECT_SS    (UNAPIGEN.PA_OBJECT_NR) := '';
      UNAPIGEN.PA_OBJECT_ALLOW_MODIFY (UNAPIGEN.PA_OBJECT_NR) := '1';
      UNAPIGEN.PA_OBJECT_ACTIVE(UNAPIGEN.PA_OBJECT_NR) := '0';
      UNAPIGEN.PA_OBJECT_LOG_HS(UNAPIGEN.PA_OBJECT_NR) := L_LOG_HS;

      A_LC           := UNAPIGEN.PA_OBJECT_LC         (UNAPIGEN.PA_OBJECT_NR);
      A_LC_VERSION   := UNAPIGEN.PA_OBJECT_LC_VERSION (UNAPIGEN.PA_OBJECT_NR);
      A_SS           := UNAPIGEN.PA_OBJECT_SS         (UNAPIGEN.PA_OBJECT_NR);
      A_ALLOW_MODIFY := '#';
      A_ACTIVE       := UNAPIGEN.PA_OBJECT_ACTIVE     (UNAPIGEN.PA_OBJECT_NR);
      A_LOG_HS       := UNAPIGEN.PA_OBJECT_LOG_HS     (UNAPIGEN.PA_OBJECT_NR);

      RETURN (UNAPIGEN.DBERR_NOOBJECT);

   END;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('GetPpAuthorisation',SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'GetPpAuthorisation'));
END GETPPAUTHORISATION;
 
FUNCTION ADDPPCOMMENT
(A_PP                  IN        VARCHAR2, 
 A_VERSION             IN        VARCHAR2, 
 A_PP_KEY1             IN        VARCHAR2, 
 A_PP_KEY2             IN        VARCHAR2, 
 A_PP_KEY3             IN        VARCHAR2, 
 A_PP_KEY4             IN        VARCHAR2, 
 A_PP_KEY5             IN        VARCHAR2, 
 A_COMMENT             IN        VARCHAR2) 
RETURN NUMBER IS

L_ALLOW_MODIFY      CHAR(1);
L_LOG_HS            CHAR(1);
L_LC                VARCHAR2(2);
L_LC_VERSION        VARCHAR2(20);
L_ACTIVE            CHAR(1);
L_SS                VARCHAR2(2);

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.P_TXN_ERROR THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF A_PP_KEY1 IS NULL OR
      A_PP_KEY2 IS NULL OR
      A_PP_KEY3 IS NULL OR
      A_PP_KEY4 IS NULL OR
      A_PP_KEY5 IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIPPP.GETPPAUTHORISATION(A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, 
                                             A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, L_LC, 
                                             L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
   
   L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
   IF L_RET_CODE <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   INSERT INTO UTPPHS (PP, VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5,
                       WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
   VALUES (A_PP, A_VERSION, A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, 
           UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 
           'Comment', 'comment is added on '||UNAPIGEN.GETOBJTPDESCRIPTION('pp')||' "'|| A_PP||'"',
           CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_COMMENT, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR ); 

   UPDATE UTPP 
   SET LAST_COMMENT= A_COMMENT
   WHERE PP = A_PP
     AND VERSION = A_VERSION
     AND PP_KEY1 = A_PP_KEY1
     AND PP_KEY2 = A_PP_KEY2
     AND PP_KEY3 = A_PP_KEY3
     AND PP_KEY4 = A_PP_KEY4
     AND PP_KEY5 = A_PP_KEY5;
        
   IF SQL%ROWCOUNT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('AddPpComment', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'AddPpComment'));
END ADDPPCOMMENT;

FUNCTION GETPPCOMMENT
(A_PP               OUT       UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION          OUT       UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY1          OUT       UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY2          OUT       UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY3          OUT       UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY4          OUT       UNAPIGEN.VC20_TABLE_TYPE,  
 A_PP_KEY5          OUT       UNAPIGEN.VC20_TABLE_TYPE,  
 A_LAST_COMMENT     OUT       UNAPIGEN.VC255_TABLE_TYPE, 
 A_NR_OF_ROWS       IN OUT    NUMBER,                    
 A_WHERE_CLAUSE     IN        VARCHAR2,                  
 A_NEXT_ROWS        IN        NUMBER)                    
RETURN NUMBER IS

L_PP                VARCHAR2(20);
L_VERSION           VARCHAR2(20);
L_PP_KEY1           VARCHAR2(20);
L_PP_KEY2           VARCHAR2(20);
L_PP_KEY3           VARCHAR2(20);
L_PP_KEY4           VARCHAR2(20);
L_PP_KEY5           VARCHAR2(20);
L_LAST_COMMENT      VARCHAR2(255);
L_FROM_CLAUSE       VARCHAR2(255);

BEGIN

   IF NVL(A_NR_OF_ROWS, 0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_NEXT_ROWS, 0) NOT IN (-1, 0, 1) THEN
      RETURN(UNAPIGEN.DBERR_NEXTROWS);
   END IF;

   
   IF A_NEXT_ROWS = -1 THEN
      IF P_GETPPCOMMENT_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_GETPPCOMMENT_CURSOR);
         P_GETPPCOMMENT_CURSOR := NULL;
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_GETPPCOMMENT_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN
      
      IF P_GETPPCOMMENT_CURSOR IS NULL THEN
         L_SQL_STRING := 'SELECT a.pp, a.version, a.pp_key1, a.pp_key2, a.pp_key3, a.pp_key4, a.pp_key5, a.last_comment FROM ';
         L_FROM_CLAUSE := 'dd' || UNAPIGEN.P_DD || '.uvpp a ';

         
         L_WHERE_CLAUSE := ' ';
         IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
            RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
         ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
            L_WHERE_CLAUSE := 'WHERE a.pp = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                              ''' AND a.pp_key1 = '' '' AND a.pp_key2 = '' '' AND a.pp_key3 = '' '' '||
                              'AND a.pp_key4 = '' '' AND a.pp_key5 = '' '' '||
                              'AND a.version_is_current=''1''';
         ELSE
            L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
         END IF;

         L_SQL_STRING := L_SQL_STRING || L_FROM_CLAUSE || L_WHERE_CLAUSE;

         P_GETPPCOMMENT_CURSOR := DBMS_SQL.OPEN_CURSOR;

         DBMS_SQL.PARSE(P_GETPPCOMMENT_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

         DBMS_SQL.DEFINE_COLUMN(P_GETPPCOMMENT_CURSOR, 1, L_PP, 20);
         DBMS_SQL.DEFINE_COLUMN(P_GETPPCOMMENT_CURSOR, 2, L_VERSION, 20);
         DBMS_SQL.DEFINE_COLUMN(P_GETPPCOMMENT_CURSOR, 3, L_PP_KEY1, 20);
         DBMS_SQL.DEFINE_COLUMN(P_GETPPCOMMENT_CURSOR, 4, L_PP_KEY2, 20);
         DBMS_SQL.DEFINE_COLUMN(P_GETPPCOMMENT_CURSOR, 5, L_PP_KEY3, 20);
         DBMS_SQL.DEFINE_COLUMN(P_GETPPCOMMENT_CURSOR, 6, L_PP_KEY4, 20);
         DBMS_SQL.DEFINE_COLUMN(P_GETPPCOMMENT_CURSOR, 7, L_PP_KEY5, 20);
         DBMS_SQL.DEFINE_COLUMN(P_GETPPCOMMENT_CURSOR, 8, L_LAST_COMMENT, 255);

         L_RESULT := DBMS_SQL.EXECUTE(P_GETPPCOMMENT_CURSOR);
      END IF;
   END IF;
   
   L_RESULT := DBMS_SQL.FETCH_ROWS(P_GETPPCOMMENT_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(P_GETPPCOMMENT_CURSOR, 1, L_PP);
      DBMS_SQL.COLUMN_VALUE(P_GETPPCOMMENT_CURSOR, 2, L_VERSION);
      DBMS_SQL.COLUMN_VALUE(P_GETPPCOMMENT_CURSOR, 3, L_PP_KEY1);
      DBMS_SQL.COLUMN_VALUE(P_GETPPCOMMENT_CURSOR, 4, L_PP_KEY2);
      DBMS_SQL.COLUMN_VALUE(P_GETPPCOMMENT_CURSOR, 5, L_PP_KEY3);
      DBMS_SQL.COLUMN_VALUE(P_GETPPCOMMENT_CURSOR, 6, L_PP_KEY4);
      DBMS_SQL.COLUMN_VALUE(P_GETPPCOMMENT_CURSOR, 7, L_PP_KEY5);
      DBMS_SQL.COLUMN_VALUE(P_GETPPCOMMENT_CURSOR, 8, L_LAST_COMMENT);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_PP(L_FETCHED_ROWS) := L_PP;
      A_VERSION(L_FETCHED_ROWS) := L_VERSION;
      A_PP_KEY1(L_FETCHED_ROWS) := L_PP_KEY1;
      A_PP_KEY2(L_FETCHED_ROWS) := L_PP_KEY2;
      A_PP_KEY3(L_FETCHED_ROWS) := L_PP_KEY3;
      A_PP_KEY4(L_FETCHED_ROWS) := L_PP_KEY4;
      A_PP_KEY5(L_FETCHED_ROWS) := L_PP_KEY5;
      A_LAST_COMMENT(L_FETCHED_ROWS) := L_LAST_COMMENT;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_GETPPCOMMENT_CURSOR);
      END IF;

   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
       DBMS_SQL.CLOSE_CURSOR(P_GETPPCOMMENT_CURSOR);
       P_GETPPCOMMENT_CURSOR := NULL;
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_GETPPCOMMENT_CURSOR);
      P_GETPPCOMMENT_CURSOR := NULL;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'GetPpComment', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(P_GETPPCOMMENT_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(P_GETPPCOMMENT_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPPCOMMENT;


END UNAPIPPP;