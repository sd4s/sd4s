PACKAGE BODY unapiprp AS

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(4000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;

STPERROR          EXCEPTION;


L_AU_CURSOR                 INTEGER;
P_USEDOBJAU_CURSOR          INTEGER;
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

FUNCTION GETOBJECTATTRIBUTE
(A_OBJECT_TP              IN    VARCHAR2,                  
 A_OBJECT_ID              OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_OBJECT_VERSION         OUT   UNAPIGEN.VC20_TABLE_TYPE,  
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
L_OBJECT_ID           VARCHAR2(20);
L_OBJECT_VERSION      VARCHAR2(20);
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
L_BIND_RT_SELECTION   BOOLEAN;
L_BIND_ST_SELECTION   BOOLEAN;

BEGIN
  L_BIND_RT_SELECTION:= FALSE;
  L_BIND_ST_SELECTION:= FALSE;
  IF NVL(A_NR_OF_ROWS,0) = 0 THEN
     A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
  ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
     RETURN (UNAPIGEN.DBERR_NROFROWS);
  END IF;

  IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
     RETURN (UNAPIGEN.DBERR_NOOBJTP);
  END IF;

  IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
     RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
  ELSIF A_WHERE_CLAUSE = 'SELECTION' THEN
     
     IF NVL(A_OBJECT_TP, ' ') NOT IN ('st', 'rt') THEN
        RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
     ELSIF A_OBJECT_TP = 'rt' THEN
        IF UNAPIRT.P_SELECTION_CLAUSE IS NOT NULL THEN
           IF INSTR(UPPER(UNAPIRT.P_SELECTION_CLAUSE), ' WHERE ') <> 0 THEN       
              L_WHERE_CLAUSE := ','||UNAPIRT.P_SELECTION_CLAUSE|| 
                                ' AND a.rt = au.rt AND a.version = au.version ORDER BY au.rt, au.version, au.auseq'; 
           ELSE
              L_WHERE_CLAUSE := ','||UNAPIRT.P_SELECTION_CLAUSE|| 
                                ' WHERE a.rt = au.rt AND a.version = au.version ORDER BY au.rt, au.version, au.auseq'; 
           END IF;
           L_BIND_RT_SELECTION := TRUE;
        ELSE
           L_WHERE_CLAUSE := 'ORDER BY au.rt, au.version, au.auseq'; 
        END IF;
     ELSIF A_OBJECT_TP = 'st' THEN
        IF UNAPIST.P_SELECTION_CLAUSE IS NOT NULL THEN
           IF INSTR(UPPER(UNAPIST.P_SELECTION_CLAUSE), ' WHERE ') <> 0 THEN       
              L_WHERE_CLAUSE := ','||UNAPIST.P_SELECTION_CLAUSE|| 
                                ' AND a.st = au.st AND a.version = au.version ORDER BY au.st, au.version, au.auseq'; 
           ELSE
              L_WHERE_CLAUSE := ','||UNAPIST.P_SELECTION_CLAUSE|| 
                                ' WHERE a.st = au.st AND a.version = au.version ORDER BY au.st, au.version, au.auseq'; 
           END IF;
           L_BIND_ST_SELECTION := TRUE;
        ELSE
           L_WHERE_CLAUSE := 'ORDER BY au.st, au.version, au.auseq'; 
        END IF;
     END IF;
  ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
     L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uv'||A_OBJECT_TP||' x '||
                    'WHERE au.version = x.version '||
                    'AND au.'||A_OBJECT_TP||' = x.'||A_OBJECT_TP||' '||
                    'AND au.'|| A_OBJECT_TP || ' = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || ''' ' || 
                    'AND x.version_is_current = ''1'' '||
                    'ORDER BY au.auseq';      
  ELSE
     L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
  END IF;

  L_SQL_STRING := 'SELECT au.' || A_OBJECT_TP || ', au.version, au.au, au.au_version, au.value FROM dd' ||
                   UNAPIGEN.P_DD || '.uv' || A_OBJECT_TP || 'au au '
                   || L_WHERE_CLAUSE;

  IF NOT DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
     L_AU_CURSOR := DBMS_SQL.OPEN_CURSOR;
     DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      IF L_BIND_ST_SELECTION THEN
         FOR L_X IN 1..UNAPIST.P_SELECTION_VAL_TAB.COUNT() LOOP
            DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':col_val'||L_X , UNAPIST.P_SELECTION_VAL_TAB(L_X)); 
         END LOOP;
      ELSIF L_BIND_RT_SELECTION THEN
         FOR L_X IN 1..UNAPIRT.P_SELECTION_VAL_TAB.COUNT() LOOP
            DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':col_val'||L_X , UNAPIRT.P_SELECTION_VAL_TAB(L_X)); 
         END LOOP;
      END IF;

     DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 1, L_OBJECT_ID, 20);
     DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 2, L_OBJECT_VERSION, 20);
     DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 3, L_AU, 20);
     DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 4, L_AU_VERSION, 20);
     DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 5, L_VALUE, 40);

     L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
  END IF;
  
  L_RESULT := DBMS_SQL.FETCH_ROWS(L_AU_CURSOR);
  L_FETCHED_ROWS := 0;

  LOOP
     EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 1, L_OBJECT_ID);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 2, L_OBJECT_VERSION);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 3, L_AU);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 4, L_AU_VERSION);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 5, L_VALUE);

     L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

     A_OBJECT_ID(L_FETCHED_ROWS) := L_OBJECT_ID;
     A_OBJECT_VERSION(L_FETCHED_ROWS) := L_OBJECT_VERSION;
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
     VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'GetObjectAttribute', L_SQLERRM);
     INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
     VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'GetObjectAttribute', SUBSTR(L_SQL_STRING,1,200));
     IF LENGTH(L_SQL_STRING)>200 THEN
        INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
        VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'GetObjectAttribute', SUBSTR(L_SQL_STRING,201,200));
     END IF;
     UNAPIGEN.U4COMMIT;
     IF DBMS_SQL.IS_OPEN (L_AU_CURSOR) THEN
        DBMS_SQL.CLOSE_CURSOR (L_AU_CURSOR);
     END IF;
     IF UNAPIGEN.L_AUDET_CURSOR%ISOPEN THEN
        CLOSE UNAPIGEN.L_AUDET_CURSOR;
     END IF;
     RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETOBJECTATTRIBUTE;

FUNCTION GETUSEDOBJECTATTRIBUTE
(A_OBJECT_TP              IN    VARCHAR2,                  
 A_USED_OBJECT_TP         IN    VARCHAR2,                  
 A_OBJECT_ID              IN    VARCHAR2,                  
 A_OBJECT_VERSION         IN    VARCHAR2,                  
 A_USED_OBJECT_ID         OUT   UNAPIGEN.VC20_TABLE_TYPE,  
 A_USED_OBJECT_VERSION    OUT   UNAPIGEN.VC20_TABLE_TYPE,  
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
L_USED_OBJECT_ID            VARCHAR2(20);
L_USED_OBJECT_VERSION       VARCHAR2(20);
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

  IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
     RETURN (UNAPIGEN.DBERR_NOOBJTP);
  END IF;

  IF NVL(A_USED_OBJECT_TP, ' ') = ' ' THEN
     RETURN (UNAPIGEN.DBERR_NOOBJTP);
  END IF;
    
  L_NEXT_ROWS_ENABLED := FALSE;
  IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
     L_WHERE_CLAUSE := 'WHERE '|| A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                       ''' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || 
                       ''' ORDER BY '|| A_USED_OBJECT_TP ||','|| A_USED_OBJECT_TP ||'_version, auseq';
  ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,3)) = UPPER(A_OBJECT_TP)||'=' THEN
     
     
     
     L_NEXT_ROWS_ENABLED := TRUE;
     L_WHERE_CLAUSE := 'WHERE '|| A_WHERE_CLAUSE;
     
  ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
     L_WHERE_CLAUSE := ' WHERE '|| A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                       ''' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || 
                       ''' AND ' || A_USED_OBJECT_TP || ' = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                       ''' ORDER BY auseq';
  ELSE
     L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
  END IF;

  L_SQL_STRING := 'SELECT au.' || A_USED_OBJECT_TP || ', au.' || A_USED_OBJECT_TP || '_version, ' ||
                     'au.au, au.au_version, au.value FROM dd' || UNAPIGEN.P_DD || '.uv' ||
                     A_OBJECT_TP || A_USED_OBJECT_TP || 'au au '
                     || L_WHERE_CLAUSE;

  IF NOT DBMS_SQL.IS_OPEN(P_USEDOBJAU_CURSOR) THEN
     P_USEDOBJAU_CURSOR := DBMS_SQL.OPEN_CURSOR;
     DBMS_SQL.PARSE(P_USEDOBJAU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
     DBMS_SQL.DEFINE_COLUMN(P_USEDOBJAU_CURSOR, 1, L_USED_OBJECT_ID, 20);
     DBMS_SQL.DEFINE_COLUMN(P_USEDOBJAU_CURSOR, 2, L_USED_OBJECT_VERSION, 20);
     DBMS_SQL.DEFINE_COLUMN(P_USEDOBJAU_CURSOR, 3, L_AU, 20);
     DBMS_SQL.DEFINE_COLUMN(P_USEDOBJAU_CURSOR, 4, L_AU_VERSION, 20);
     DBMS_SQL.DEFINE_COLUMN(P_USEDOBJAU_CURSOR, 5, L_VALUE, 40);
     L_RESULT := DBMS_SQL.EXECUTE(P_USEDOBJAU_CURSOR);
  END IF;
  
  L_FETCHED_ROWS := 0;
  L_RESULT := DBMS_SQL.FETCH_ROWS(P_USEDOBJAU_CURSOR);
  L_USED_OBJECT_ID := '';
  L_AU_FETCHED := NULL;
  
  LOOP
     EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
     DBMS_SQL.COLUMN_VALUE(P_USEDOBJAU_CURSOR, 1, L_USED_OBJECT_ID);
     DBMS_SQL.COLUMN_VALUE(P_USEDOBJAU_CURSOR, 2, L_USED_OBJECT_VERSION);
     DBMS_SQL.COLUMN_VALUE(P_USEDOBJAU_CURSOR, 3, L_AU);
     DBMS_SQL.COLUMN_VALUE(P_USEDOBJAU_CURSOR, 4, L_AU_VERSION);
     DBMS_SQL.COLUMN_VALUE(P_USEDOBJAU_CURSOR, 5, L_VALUE);

     L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

     A_USED_OBJECT_ID(L_FETCHED_ROWS) := L_USED_OBJECT_ID;
     A_USED_OBJECT_VERSION(L_FETCHED_ROWS) := L_USED_OBJECT_VERSION;
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
        L_RESULT := DBMS_SQL.FETCH_ROWS(P_USEDOBJAU_CURSOR);
     END IF;
  END LOOP;

  IF L_FETCHED_ROWS = 0 THEN
     L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
     DBMS_SQL.CLOSE_CURSOR(P_USEDOBJAU_CURSOR);
  ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
     L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
     A_NR_OF_ROWS := L_FETCHED_ROWS;
     DBMS_SQL.CLOSE_CURSOR(P_USEDOBJAU_CURSOR);
  ELSE   
     L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
     A_NR_OF_ROWS := L_FETCHED_ROWS;
  END IF;

  IF L_NEXT_ROWS_ENABLED = FALSE AND
     DBMS_SQL.IS_OPEN(P_USEDOBJAU_CURSOR) THEN
     DBMS_SQL.CLOSE_CURSOR(P_USEDOBJAU_CURSOR);
  END IF;

  RETURN(L_RET_CODE);

EXCEPTION
  WHEN OTHERS THEN
     L_SQLERRM := SQLERRM;
     UNAPIGEN.U4ROLLBACK;
     INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
     VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
             'GetUsedObjectAttribute', L_SQLERRM);
     UNAPIGEN.U4COMMIT;
     IF DBMS_SQL.IS_OPEN (P_USEDOBJAU_CURSOR) THEN
        DBMS_SQL.CLOSE_CURSOR (P_USEDOBJAU_CURSOR);
     END IF;
     IF UNAPIGEN.L_AUDET_CURSOR%ISOPEN THEN
        CLOSE UNAPIGEN.L_AUDET_CURSOR;
     END IF;
     RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETUSEDOBJECTATTRIBUTE;

FUNCTION SAVEOBJECTATTRIBUTE
(A_OBJECT_TP                IN        VARCHAR2,                 
 A_OBJECT_ID                IN        VARCHAR2,                 
 A_OBJECT_VERSION           IN        VARCHAR2,                 
 A_AU                       IN        UNAPIGEN.VC20_TABLE_TYPE, 
 A_AU_VERSION               IN OUT    UNAPIGEN.VC20_TABLE_TYPE, 
 A_VALUE                    IN        UNAPIGEN.VC40_TABLE_TYPE, 
 A_NR_OF_ROWS               IN        NUMBER,                   
 A_MODIFY_REASON            IN        VARCHAR2)                 
RETURN NUMBER IS

L_AU           VARCHAR2(20);
L_AU_VERSION   VARCHAR2(20);
L_VALUE        VARCHAR2(40);
L_AU_CURSOR    INTEGER;
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

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, L_LC, 
                                           L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   L_AU_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'UPDATE ut' || A_OBJECT_TP ||
                   ' SET allow_modify = ''#''' ||
                   ' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                   ''' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
   IF L_RESULT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;

   L_SQL_STRING := ' DELETE FROM ut' || A_OBJECT_TP || 'au' ||
                      ' WHERE ' || A_OBJECT_TP || '=''' || REPLACE(A_OBJECT_ID, '''', '''''') || '''' || 
                      ' AND version =''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);

   
   L_SQL_STRING := 'INSERT INTO ut' || A_OBJECT_TP || 'au' ||
                   '('|| A_OBJECT_TP || ', version, au, au_version, auseq, value)' ||
                   ' VALUES (:d_object_id, :d_object_version, :d_au, :d_au_version, :d_seq, :d_value)';

   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   FOR I IN 1..A_NR_OF_ROWS LOOP
      L_AU := A_AU(I);
      
      L_AU_VERSION := NULL;
      L_VALUE := A_VALUE(I);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_object_id', A_OBJECT_ID);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_object_version', A_OBJECT_VERSION);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_au', L_AU);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_au_version', L_AU_VERSION);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_seq', I);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_value', L_VALUE);

      L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
      IF L_RESULT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
         DBMS_SQL.CLOSE_CURSOR (L_AU_CURSOR);    
         RAISE STPERROR;
      END IF;
   END LOOP;

   L_EVENT_TP := 'AttributesUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT ('SaveObjectAttribute',
               UNAPIGEN.P_EVMGR_NAME, A_OBJECT_TP, A_OBJECT_ID, L_LC, L_LC_VERSION, L_SS,
               L_EVENT_TP, 'version='||A_OBJECT_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      DBMS_SQL.CLOSE_CURSOR (L_AU_CURSOR);
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') THEN
       L_SQL_STRING := 'INSERT INTO ut' || A_OBJECT_TP || 'hs' ||
                       ' (' || A_OBJECT_TP || ', version, who, who_description, what, '|| 
                          'what_description, logdate, logdate_tz, why, tr_seq, ev_seq)' ||
                       ' VALUES (''' || REPLACE(A_OBJECT_ID, '''', '''''') ||  
                       ''', ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') ||  
                       ''', ''' || REPLACE(UNAPIGEN.P_USER, '''', '''''') ||  
                       ''', ''' || REPLACE(UNAPIGEN.P_USER_DESCRIPTION, '''', '''''') ||  
                       ''', ''' || L_EVENT_TP || 
                       ''', ''attributes for '||UNAPIGEN.GETOBJTPDESCRIPTION(A_OBJECT_TP)||' "'||
                            REPLACE(A_OBJECT_ID, '''', '''''')||'" are updated'', ' || 
                       'CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''' ||
                       REPLACE(A_MODIFY_REASON, '''', '''''') ||  
                       ''', '   || UNAPIGEN.P_TR_SEQ || 
                       ', '     || L_EV_SEQ_NR || ')'; 
       DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
       L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
   END IF;

   DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveObjectAttribute', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveObjectAttribute'));
END SAVEOBJECTATTRIBUTE;

FUNCTION SAVE1OBJECTATTRIBUTE
(A_OBJECT_TP                IN        VARCHAR2,                 
 A_OBJECT_ID                IN        VARCHAR2,                 
 A_OBJECT_VERSION           IN        VARCHAR2,                 
 A_AU                       IN        VARCHAR2,                 
 A_AU_VERSION               IN OUT    VARCHAR2,                 
 A_VALUE                    IN        UNAPIGEN.VC40_TABLE_TYPE, 
 A_NR_OF_ROWS               IN        NUMBER,                   
 A_MODIFY_REASON            IN        VARCHAR2)                 
RETURN NUMBER IS

L_AU           VARCHAR2(20);
L_AU_VERSION   VARCHAR2(20);
L_VALUE        VARCHAR2(40);
L_AU_CURSOR    INTEGER;
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

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF NVL(A_AU, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, L_LC, 
                                           L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   L_AU_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'UPDATE ut' || A_OBJECT_TP ||
                   ' SET allow_modify = ''#''' ||
                   ' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                   ''' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
   IF L_RESULT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;

   L_SQL_STRING := ' DELETE FROM ut' || A_OBJECT_TP || 'au' ||
                      ' WHERE ' || A_OBJECT_TP || '=''' || REPLACE(A_OBJECT_ID, '''', '''''') || '''' || 
                      ' AND version =''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || '''' || 
                      ' AND au =''' || REPLACE(A_AU, '''', '''''') || ''''; 
   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);

   
   L_SQL_STRING := 'INSERT INTO ut' || A_OBJECT_TP || 'au' ||
                   '('|| A_OBJECT_TP || ', version, au, au_version, auseq, value)' ||
                   ' VALUES (:d_object_id, :d_object_version, :d_au, :d_au_version, :d_seq, :d_value)';

   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   FOR I IN 1..A_NR_OF_ROWS LOOP
      L_AU := A_AU;
      
      L_AU_VERSION := NULL;
      L_VALUE := A_VALUE(I);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_object_id', A_OBJECT_ID);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_object_version', A_OBJECT_VERSION);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_au', L_AU);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_au_version', L_AU_VERSION);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_seq', I);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_value', L_VALUE);

      L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
      IF L_RESULT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
         DBMS_SQL.CLOSE_CURSOR (L_AU_CURSOR);    
         RAISE STPERROR;
      END IF;
   END LOOP;

   L_EVENT_TP := 'AttributesUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT ('Save1ObjectAttribute',
               UNAPIGEN.P_EVMGR_NAME, A_OBJECT_TP, A_OBJECT_ID, L_LC, L_LC_VERSION, L_SS,
               L_EVENT_TP, 'version='||A_OBJECT_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      DBMS_SQL.CLOSE_CURSOR (L_AU_CURSOR);
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') THEN
       L_SQL_STRING := 'INSERT INTO ut' || A_OBJECT_TP || 'hs' ||
                       ' (' || A_OBJECT_TP || ', version, who, who_description, what, '|| 
                          'what_description, logdate, logdate_tz, why, tr_seq, ev_seq)' ||
                       ' VALUES (''' || REPLACE(A_OBJECT_ID, '''', '''''') ||  
                       ''', ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') ||  
                       ''', ''' || REPLACE(UNAPIGEN.P_USER, '''', '''''') ||  
                       ''', ''' || REPLACE(UNAPIGEN.P_USER_DESCRIPTION, '''', '''''') ||  
                       ''', ''' || L_EVENT_TP || 
                       ''', ''attributes for '||UNAPIGEN.GETOBJTPDESCRIPTION(A_OBJECT_TP)||' "'||
                            REPLACE(A_OBJECT_ID, '''', '''''')||'" are updated'', ' || 
                       'CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''' ||
                       REPLACE(A_MODIFY_REASON, '''', '''''') ||  
                       ''', '   || UNAPIGEN.P_TR_SEQ || 
                       ', '     || L_EV_SEQ_NR || ')'; 
       DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
       L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
   END IF;

   DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('Save1ObjectAttribute', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'Save1ObjectAttribute'));
END SAVE1OBJECTATTRIBUTE;

FUNCTION SAVEUSEDOBJECTATTRIBUTE
(A_OBJECT_TP                IN        VARCHAR2,                 
 A_USED_OBJECT_TP           IN        VARCHAR2,                 
 A_OBJECT_ID                IN        VARCHAR2,                 
 A_OBJECT_VERSION           IN        VARCHAR2,                 
 A_USED_OBJECT_ID           IN        VARCHAR2,                 
 A_USED_OBJECT_VERSION      IN        VARCHAR2,                 
 A_AU                       IN        UNAPIGEN.VC20_TABLE_TYPE, 
 A_AU_VERSION               IN OUT    UNAPIGEN.VC20_TABLE_TYPE, 
 A_VALUE                    IN        UNAPIGEN.VC40_TABLE_TYPE, 
 A_NR_OF_ROWS               IN        NUMBER,                   
 A_MODIFY_REASON            IN        VARCHAR2)                 
RETURN NUMBER IS

L_AU           VARCHAR2(20);
L_AU_VERSION   VARCHAR2(20);
L_VALUE        VARCHAR2(40);
L_AU_CURSOR    INTEGER;
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

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_USED_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, L_LC, 
                                           L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   L_AU_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'UPDATE ut' || A_OBJECT_TP ||
                   ' SET allow_modify = ''#''' ||
                   ' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                   ''' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
   IF L_RESULT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;

   L_SQL_STRING := 'DELETE FROM ut' || A_OBJECT_TP || A_USED_OBJECT_TP || 'au ' ||
                   'WHERE ' || A_OBJECT_TP || '=''' || REPLACE(A_OBJECT_ID, '''', '''''') || '''' || 
                   ' AND version =''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || '''' || 
                   ' AND ' || A_USED_OBJECT_TP || '=''' || REPLACE(A_USED_OBJECT_ID, '''', '''''') || '''';
                   
   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);

   
   L_SQL_STRING := 'INSERT INTO ut' || A_OBJECT_TP || A_USED_OBJECT_TP || 'au' ||
                   '('|| A_OBJECT_TP || ', version, ' || A_USED_OBJECT_TP ||
                   ', ' || A_USED_OBJECT_TP || '_version, au, au_version,  auseq, value)' ||
                   ' VALUES (:d_object_id, :d_object_version, :d_used_object_id, ' || 
                   ' :d_used_object_version, :d_au, :d_au_version, :d_seq, :d_value)';

   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_object_id', A_OBJECT_ID);
   DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_object_version', A_OBJECT_VERSION);
   DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_used_object_id', A_USED_OBJECT_ID);
   DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_used_object_version', A_USED_OBJECT_VERSION);

   FOR I IN 1..A_NR_OF_ROWS LOOP
      L_AU := A_AU(I);
      
      L_AU_VERSION := NULL;
      L_VALUE := A_VALUE(I);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_au', L_AU);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_au_version', L_AU_VERSION);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_seq', I);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_value', L_VALUE);

      L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
      IF L_RESULT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
         DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
         RAISE STPERROR;
      END IF;
   END LOOP;

   L_EVENT_TP := 'AttributesUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT ('SaveUsedObjectAttribute',
               UNAPIGEN.P_EVMGR_NAME, A_OBJECT_TP, A_OBJECT_ID, L_LC, L_LC_VERSION, L_SS,
               L_EVENT_TP, 'version='||A_OBJECT_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') THEN
       L_SQL_STRING := 'INSERT INTO ut' || A_OBJECT_TP || 'hs' ||
                       ' (' || A_OBJECT_TP || ', version, who, who_description, what, '||
                          'what_description, logdate, logdate_tz, why, tr_seq, ev_seq)' ||
                       ' VALUES (''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                       ''', ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || 
                       ''', ''' || REPLACE(UNAPIGEN.P_USER, '''', '''''') || 
                       ''', ''' || REPLACE(UNAPIGEN.P_USER_DESCRIPTION, '''', '''''') || 
                       ''', ''' || L_EVENT_TP||' '|| REPLACE(A_USED_OBJECT_ID, '''', '''''') ||' '||A_USED_OBJECT_VERSION||
                       ''', ''attributes for '||UNAPIGEN.GETOBJTPDESCRIPTION(A_USED_OBJECT_TP)||' "'||
                       REPLACE(A_USED_OBJECT_ID, '''', '''''') ||'" used in object '||
                            UNAPIGEN.GETOBJTPDESCRIPTION(A_OBJECT_TP)||' "'|| REPLACE(A_OBJECT_ID, '''', '''''') ||'" are updated'', ' ||
                       'CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''' ||
                       REPLACE(A_MODIFY_REASON, '''', '''''') || 
                       ''', ' || UNAPIGEN.P_TR_SEQ || 
                       ', ' || L_EV_SEQ_NR || ')'; 
       DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
       L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
   END IF;

   DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveUsedObjectAttribute', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveUsedObjectAttribute'));
END SAVEUSEDOBJECTATTRIBUTE;

FUNCTION SAVE1USEDOBJECTATTRIBUTE
(A_OBJECT_TP                IN        VARCHAR2,                 
 A_USED_OBJECT_TP           IN        VARCHAR2,                 
 A_OBJECT_ID                IN        VARCHAR2,                 
 A_OBJECT_VERSION           IN        VARCHAR2,                 
 A_USED_OBJECT_ID           IN        VARCHAR2,                 
 A_USED_OBJECT_VERSION      IN        VARCHAR2,                 
 A_AU                       IN        VARCHAR2,                 
 A_AU_VERSION               IN OUT    VARCHAR2,                 
 A_VALUE                    IN        UNAPIGEN.VC40_TABLE_TYPE, 
 A_NR_OF_ROWS               IN        NUMBER,                   
 A_MODIFY_REASON            IN        VARCHAR2)                 
RETURN NUMBER IS

L_AU           VARCHAR2(20);
L_AU_VERSION   VARCHAR2(20);
L_VALUE        VARCHAR2(40);
L_AU_CURSOR    INTEGER;
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

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_USED_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF NVL(A_AU, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, L_LC, 
                                           L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   L_AU_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'UPDATE ut' || A_OBJECT_TP ||
                   ' SET allow_modify = ''#''' ||
                   ' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                   ''' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
   IF L_RESULT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;

   L_SQL_STRING := 'DELETE FROM ut' || A_OBJECT_TP || A_USED_OBJECT_TP || 'au ' ||
                   'WHERE ' || A_OBJECT_TP || '=''' || REPLACE(A_OBJECT_ID, '''', '''''') || '''' || 
                   ' AND version =''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || '''' || 
                   ' AND ' || A_USED_OBJECT_TP || '=''' || REPLACE(A_USED_OBJECT_ID, '''', '''''') || '''' ||
                   
                   ' AND au =''' || REPLACE(A_AU, '''', '''''') || ''''; 

   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);

   
   L_SQL_STRING := 'INSERT INTO ut' || A_OBJECT_TP || A_USED_OBJECT_TP || 'au' ||
                   '('|| A_OBJECT_TP || ', version, ' || A_USED_OBJECT_TP ||
                   ', ' || A_USED_OBJECT_TP || '_version, au, au_version,  auseq, value)' ||
                   ' VALUES (:d_object_id, :d_object_version, :d_used_object_id, ' || 
                   ' :d_used_object_version, :d_au, :d_au_version, :d_seq, :d_value)';

   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_object_id', A_OBJECT_ID);
   DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_object_version', A_OBJECT_VERSION);
   DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_used_object_id', A_USED_OBJECT_ID);
   DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_used_object_version', A_USED_OBJECT_VERSION);

   FOR I IN 1..A_NR_OF_ROWS LOOP
      L_AU := A_AU;
      
      L_AU_VERSION := NULL;
      L_VALUE := A_VALUE(I);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_au', L_AU);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_au_version', L_AU_VERSION);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_seq', I);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_value', L_VALUE);

      L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
      IF L_RESULT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
         DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
         RAISE STPERROR;
      END IF;
   END LOOP;

   L_EVENT_TP := 'AttributesUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT ('Save1UsedObjectAttribute',
               UNAPIGEN.P_EVMGR_NAME, A_OBJECT_TP, A_OBJECT_ID, L_LC, L_LC_VERSION, L_SS,
               L_EVENT_TP, 'version='||A_OBJECT_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') THEN
       L_SQL_STRING := 'INSERT INTO ut' || A_OBJECT_TP || 'hs' ||
                       ' (' || A_OBJECT_TP || ', version, who, who_description, what, '||
                          'what_description, logdate, logdate_tz, why, tr_seq, ev_seq)' ||
                       ' VALUES (''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                       ''', ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || 
                       ''', ''' || REPLACE(UNAPIGEN.P_USER, '''', '''''') || 
                       ''', ''' || REPLACE(UNAPIGEN.P_USER_DESCRIPTION, '''', '''''') || 
                       ''', ''' || L_EVENT_TP||' '|| REPLACE(A_USED_OBJECT_ID, '''', '''''') ||' '||A_USED_OBJECT_VERSION||
                       ''', ''attributes for '||UNAPIGEN.GETOBJTPDESCRIPTION(A_USED_OBJECT_TP)||' "'||
                       REPLACE(A_USED_OBJECT_ID, '''', '''''') ||'" used in object '||
                            UNAPIGEN.GETOBJTPDESCRIPTION(A_OBJECT_TP)||' "'|| REPLACE(A_OBJECT_ID, '''', '''''') ||'" are updated'', ' ||
                       'CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''' ||
                       REPLACE(A_MODIFY_REASON, '''', '''''') || 
                       ''', ' || UNAPIGEN.P_TR_SEQ || 
                       ', ' || L_EV_SEQ_NR || ')'; 
       DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
       L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
   END IF;

   DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('Save1UsedObjectAttribute', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'Save1UsedObjectAttribute'));
END SAVE1USEDOBJECTATTRIBUTE;

FUNCTION GETOBJECTHISTORY
(A_OBJECT_TP        IN      VARCHAR2,                  
 A_OBJECT_ID        OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_OBJECT_VERSION   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
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


L_OBJECT_ID_TAB               UNAPIGEN.VC20_TABLE_TYPE;
L_OBJECT_VERSION_TAB          UNAPIGEN.VC20_TABLE_TYPE;
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
   L_RET_CODE := GETOBJECTHISTORY(A_OBJECT_TP,
                                  A_OBJECT_ID,
                                  A_OBJECT_VERSION,
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
          
          L_RET_CODE := GETOBJECTHISTORY(A_OBJECT_TP,             
                                         L_OBJECT_ID_TAB,
                                         L_OBJECT_VERSION_TAB,
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
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
              'GetObjectHistory', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETOBJECTHISTORY;

FUNCTION GETOBJECTHISTORY
(A_OBJECT_TP        IN      VARCHAR2,                  
 A_OBJECT_ID        OUT     UNAPIGEN.VC20_TABLE_TYPE,  
 A_OBJECT_VERSION   OUT     UNAPIGEN.VC20_TABLE_TYPE,  
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

L_OBJECT_ID               VARCHAR2(20);
L_OBJECT_VERSION          VARCHAR2(20);
L_WHO                     VARCHAR2(20);
L_WHO_DESCRIPTION         VARCHAR2(40);
L_WHAT                    VARCHAR2(60);
L_WHAT_DESCRIPTION        VARCHAR2(255);
L_LOGDATE                 TIMESTAMP WITH TIME ZONE;
L_WHY                     VARCHAR2(255);
L_TR_SEQ                  NUMBER;
L_EV_SEQ                  NUMBER;

BEGIN

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      RETURN(UNAPIGEN.DBERR_NOOBJTP);
   END IF;

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
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
            L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uv'||A_OBJECT_TP||' x WHERE x.version_is_current = ''1'' '||
                              'AND hs.version = x.version '||  
                              'AND hs.'||A_OBJECT_TP||' = x.'||A_OBJECT_TP||' '||
                              'AND hs.' || A_OBJECT_TP || '=''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                              ''' ORDER BY hs.logdate DESC'; 
      ELSE
         L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
      END IF;

      
      L_WHERE_CLAUSE := REPLACE(REPLACE(L_WHERE_CLAUSE, 
                                        'logdate DESC', 
                                        'logdate DESC'),
                                'LOGDATE DESC', 
                                'LOGDATE DESC');

      IF DBMS_SQL.IS_OPEN(P_HS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(P_HS_CURSOR);
      END IF;
      P_HS_CURSOR := DBMS_SQL.OPEN_CURSOR;
      L_SQL_STRING := 'SELECT hs.' || A_OBJECT_TP || ', hs.version, hs.who, hs.who_description, '||
                      'hs.what, hs.what_description, hs.logdate, hs.why, hs.tr_seq, hs.ev_seq '||
                      'FROM dd' || UNAPIGEN.P_DD || '.uv'|| A_OBJECT_TP || 'hs hs '
                       || L_WHERE_CLAUSE;
      DBMS_SQL.PARSE(P_HS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 1, L_OBJECT_ID, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 2, L_OBJECT_VERSION, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 3, L_WHO, 20);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 4, L_WHO_DESCRIPTION, 40);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 5, L_WHAT, 60);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 6, L_WHAT_DESCRIPTION, 255);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 7, L_LOGDATE);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 8, L_WHY, 255);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 9, L_TR_SEQ);
      DBMS_SQL.DEFINE_COLUMN(P_HS_CURSOR, 10, L_EV_SEQ);
      L_RESULT := DBMS_SQL.EXECUTE(P_HS_CURSOR);
   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(P_HS_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 1, L_OBJECT_ID);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 2, L_OBJECT_VERSION);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 3, L_WHO);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 4, L_WHO_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 5, L_WHAT);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 6, L_WHAT_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 7, L_LOGDATE);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 8, L_WHY);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 9, L_TR_SEQ);
      DBMS_SQL.COLUMN_VALUE(P_HS_CURSOR, 10, L_EV_SEQ);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_OBJECT_ID(L_FETCHED_ROWS) := L_OBJECT_ID;
      A_OBJECT_VERSION(L_FETCHED_ROWS) := L_OBJECT_VERSION;
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
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
              'GetObjectHistory', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_HS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_HS_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETOBJECTHISTORY;

FUNCTION SAVEOBJECTHISTORY
(A_OBJECT_TP         IN        VARCHAR2,                   
 A_OBJECT_ID         IN        VARCHAR2,                   
 A_OBJECT_VERSION    IN        VARCHAR2,                   
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

L_OBJECT_TP        VARCHAR2(20);
L_VALUE            VARCHAR2(40);
L_HS_CURSOR        INTEGER;
L_ALLOW_MODIFY     CHAR(1);
L_LOG_HS           CHAR(1);
L_LC               VARCHAR2(2);
L_LC_VERSION       VARCHAR2(20);
L_SS               VARCHAR2(2);
L_ACTIVE           CHAR(1);

BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, L_LC, 
                                           L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   L_HS_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR I IN 1..A_NR_OF_ROWS LOOP
      L_SQL_STRING := 'UPDATE ut' || A_OBJECT_TP || 'hs' ||
                      ' SET why = ''' || REPLACE(A_WHY(I), '''', '''''') ||  
                      ''' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                      ''' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || 
                      ''' AND who  = ''' || REPLACE(A_WHO(I), '''', '''''') || 
                      ''' AND who_description  = ''' || REPLACE(A_WHO_DESCRIPTION(I), '''', '''''') || 
                      ''' AND TO_CHAR(logdate) =''' ||  A_LOGDATE(I) ||
                      ''' AND what = ''' || REPLACE(A_WHAT(I), '''', '''''') || 
                      ''' AND what_description  = ''' || REPLACE(A_WHAT_DESCRIPTION(I), '''', '''''') || 
                      ''' AND tr_seq = ' || A_TR_SEQ(I) || 
                      '   AND ev_seq = ' || A_EV_SEQ(I);

      DBMS_SQL.PARSE(L_HS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      L_RESULT := DBMS_SQL.EXECUTE(L_HS_CURSOR);

      IF L_RESULT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
         DBMS_SQL.CLOSE_CURSOR(L_HS_CURSOR);
         RAISE STPERROR;
      END IF;
   END LOOP;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   DBMS_SQL.CLOSE_CURSOR(L_HS_CURSOR);
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveObjectHistory', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN (L_HS_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR (L_HS_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveObjectHistory'));
END SAVEOBJECTHISTORY;

FUNCTION GETOBJECTACCESS
(A_OBJECT_TP         IN      VARCHAR2,                  
 A_OBJECT_ID         IN      VARCHAR2,                  
 A_OBJECT_VERSION    IN      VARCHAR2,                  
 A_DD                OUT     UNAPIGEN.VC3_TABLE_TYPE,    
 A_DATA_DOMAIN       OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_ACCESS_RIGHTS     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NR_OF_ROWS        IN OUT  NUMBER)                    
RETURN NUMBER IS

L_DD_DESCRIPTION VARCHAR2(40);
L_OBJECT_AR      CHAR(1); 
L_AR             UNAPIGEN.CHAR1_TABLE_TYPE; 
L_DD             VARCHAR2(3);
L_DESCRIPTION    UNAPIGEN.VC40_TABLE_TYPE;
L_ROW            INTEGER;

CURSOR L_OBJECT_AR_CURSOR (A_OBJECT_TP VARCHAR2) IS
SELECT AR
FROM UTOBJECTS
WHERE  OBJECT = A_OBJECT_TP;

L_DD_CURSOR  UNAPIGEN.CURSOR_REF_TYPE;
L_AR_CURSOR  UNAPIGEN.CURSOR_REF_TYPE;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      RETURN (UNAPIGEN.DBERR_NOOBJTP);
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      RETURN (UNAPIGEN.DBERR_NOOBJID);
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      RETURN (UNAPIGEN.DBERR_NOOBJVERSION);
   END IF;

   
   
   
   OPEN L_OBJECT_AR_CURSOR(A_OBJECT_TP);
   FETCH L_OBJECT_AR_CURSOR 
   INTO L_OBJECT_AR;
   CLOSE L_OBJECT_AR_CURSOR;
   
   IF L_OBJECT_AR <> '1' THEN
      RETURN (UNAPIGEN.DBERR_NORECORDS);
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
      'ar119, ar120, ar121, ar122, ar123, ar124, ar125, ar126, ar127, ar128 ' ||
      'FROM ud' || A_OBJECT_TP ||
      ' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || ''''|| 
      ' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || '''';             
   L_FETCHED_ROWS := 0;
   OPEN L_AR_CURSOR FOR L_SQL_STRING;
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
   IF L_OBJECT_AR_CURSOR%ISOPEN THEN
      CLOSE L_OBJECT_AR_CURSOR;
   END IF;
   RETURN(UNAPIGEN.DBERR_SYSDEFAULTS);
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   IF L_DD_CURSOR%ISOPEN THEN
      CLOSE L_DD_CURSOR;
   END IF;
   IF L_OBJECT_AR_CURSOR%ISOPEN THEN
      CLOSE L_OBJECT_AR_CURSOR;
   END IF;
   IF L_AR_CURSOR%ISOPEN THEN
      CLOSE L_AR_CURSOR;
   END IF;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
          'GetObjectAccess', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETOBJECTACCESS;

FUNCTION SAVEOBJECTACCESS
(A_OBJECT_TP          IN     VARCHAR2,                  
 A_OBJECT_ID          IN     VARCHAR2,                  
 A_OBJECT_VERSION     IN     VARCHAR2,                  
 A_DD                 IN     UNAPIGEN.VC3_TABLE_TYPE,   
 A_ACCESS_RIGHTS      IN     UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NR_OF_ROWS         IN     NUMBER,                    
 A_MODIFY_REASON      IN     VARCHAR2)                  
RETURN NUMBER IS

L_ALLOW_MODIFY   CHAR(1);
L_LOG_HS         CHAR(1);
L_ACTIVE         CHAR(1);
L_LC             VARCHAR2(2);
L_LC_VERSION     VARCHAR2(20);
L_SS             VARCHAR2(2);
L_OBJECT_CURSOR  INTEGER;
L_WRITE_FOUND    BOOLEAN;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF NVL(A_NR_OF_ROWS, -1) < 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NROFROWS;
      RAISE STPERROR;
   END IF;

   
   
   
   L_RET_CODE := UNAPIGEN.GETAUTHORISATION(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, L_LC, 
                                           L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   L_OBJECT_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'UPDATE ut' || A_OBJECT_TP ||
                   ' SET allow_modify = ''#''' ||
                   ' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                   ''' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
   DBMS_SQL.PARSE(L_OBJECT_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   L_RESULT := DBMS_SQL.EXECUTE(L_OBJECT_CURSOR);
   IF L_RESULT = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
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
      L_SQL_STRING := 'UPDATE ut' || A_OBJECT_TP || 
                      ' SET ' || L_SQL_STRING ||
                      ' WHERE '|| A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                      ''' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || 
                      ''''; 
      
      
      
      DBMS_SQL.PARSE(L_OBJECT_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      L_RESULT := DBMS_SQL.EXECUTE(L_OBJECT_CURSOR);

      IF L_RESULT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
         RAISE STPERROR;
      END IF;

      
      
      
      L_EVENT_TP := 'AccessRightsUpdated';
      L_EV_SEQ_NR := -1;
      L_RESULT := UNAPIEV.INSERTEVENT('SaveObjectAccess',
                                      UNAPIGEN.P_EVMGR_NAME,
                                      A_OBJECT_TP, A_OBJECT_ID, L_LC, L_LC_VERSION, L_SS,
                                      L_EVENT_TP, 'version='||A_OBJECT_VERSION, L_EV_SEQ_NR);
      IF L_RESULT <>UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
         RAISE STPERROR;
      END IF;

      IF L_LOG_HS = '1' THEN
         L_SQL_STRING := 'INSERT INTO ut' || A_OBJECT_TP || 'hs' ||
                         ' (' || A_OBJECT_TP || ', version, who, who_description, what, '||
                            'what_description, logdate, logdate_tz, why, tr_seq, ev_seq)' ||
                         ' VALUES (''' || REPLACE(A_OBJECT_ID, '''', '''''') ||  
                         ''', ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') ||  
                         ''', ''' || REPLACE(UNAPIGEN.P_USER, '''', '''''') || 
                         ''', ''' || REPLACE(UNAPIGEN.P_USER_DESCRIPTION, '''', '''''') || 
                         ''', ''' || L_EVENT_TP || 
                         ''', ''access rights for '||UNAPIGEN.GETOBJTPDESCRIPTION(A_OBJECT_TP)||' "'||
                               REPLACE(A_OBJECT_ID, '''', '''''') ||'" are updated'', ' || 
                         'CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''' ||
                         REPLACE(A_MODIFY_REASON, '''', '''''') ||  
                         ''', '   || UNAPIGEN.P_TR_SEQ || 
                         ', '     || L_EV_SEQ_NR || ')';

         DBMS_SQL.PARSE(L_OBJECT_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

         L_RESULT := DBMS_SQL.EXECUTE(L_OBJECT_CURSOR);
         IF L_RESULT = 0 THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
            RAISE STPERROR;
         END IF;
      END IF;
   END IF;
   DBMS_SQL.CLOSE_CURSOR(L_OBJECT_CURSOR);

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveObjectAccess', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_OBJECT_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_OBJECT_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveObjectAccess'));
END SAVEOBJECTACCESS;

FUNCTION OBJECTTRANSITIONAUTHORISED
(A_OBJECT_TP          IN        VARCHAR2,     
 A_OBJECT_ID          IN        VARCHAR2,     
 A_OBJECT_VERSION     IN        VARCHAR2,     
 A_LC                 IN OUT    VARCHAR2,     
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
L_LOCK_OBJECT         VARCHAR2(20);

L_LC_SS_FROM          VARCHAR2(2);
L_TR_NO               NUMBER(3);
L_RNDSUITE_CURSOR     NUMBER;
L_USE_UNILAB_LOGIC    CHAR(1);

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

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   
   EXECUTE IMMEDIATE 'SELECT '||A_OBJECT_TP ||' FROM ut'||A_OBJECT_TP||
                     ' WHERE '||A_OBJECT_TP ||'=:a_object_id'||
                     ' AND version=:a_object_version FOR UPDATE'      
   INTO L_LOCK_OBJECT
   USING A_OBJECT_ID, A_OBJECT_VERSION;
   
   L_RET_CODE := UNAPIGEN.GETAUTHORISATION
                   (A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, L_LC, L_LC_VERSION, L_SS,
                    L_OLD_ALLOW_MODIFY, L_OLD_ACTIVE, A_LOG_HS);

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
      A_LC := L_LC;
   ELSE
      
      IF A_LC <> NVL(L_LC, '####') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OBJECTLCMATCH;
         RAISE STPERROR;
      END IF;
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

   
    IF UNAPIGEN.P_RNDSUITESESSION = '1' THEN
     L_RNDSUITE_CURSOR := DBMS_SQL.OPEN_CURSOR;
     L_SQL_STRING := 'BEGIN :l_ret_code := RNDAPISO.ObjectTransitionAuthorised(:a_object_tp, :a_object_id, :a_object_version, :l_lc, :l_lc_version, :l_ss, :a_new_ss, :UNAPIGEN.P_CURRENT_UP, NVL(:a_authorised_by, :UNAPIGEN.P_USER), :l_use_unilab_logic, :l_lc_ss_from, :l_tr_no); END;';

     DBMS_SQL.PARSE(L_RNDSUITE_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':l_ret_code', L_RET_CODE);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':a_object_tp', A_OBJECT_TP);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':a_object_id', A_OBJECT_ID);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':a_object_version', A_OBJECT_VERSION);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':l_lc', L_LC);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':l_lc_version', L_LC_VERSION);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':l_ss', L_SS);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':a_new_ss', A_NEW_SS);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':UNAPIGEN.P_CURRENT_UP', UNAPIGEN.P_CURRENT_UP);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':a_authorised_by', A_AUTHORISED_BY);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':UNAPIGEN.P_USER', UNAPIGEN.P_USER);
     DBMS_SQL.BIND_VARIABLE_CHAR (L_RNDSUITE_CURSOR, ':l_use_unilab_logic', L_USE_UNILAB_LOGIC, 1);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':l_lc_ss_from', L_LC_SS_FROM, 2);
     DBMS_SQL.BIND_VARIABLE(L_RNDSUITE_CURSOR, ':l_tr_no', L_TR_NO);
     L_RESULT := DBMS_SQL.EXECUTE(L_RNDSUITE_CURSOR);
     DBMS_SQL.VARIABLE_VALUE(L_RNDSUITE_CURSOR, ':l_ret_code', L_RET_CODE);
     DBMS_SQL.VARIABLE_VALUE_CHAR(L_RNDSUITE_CURSOR, ':l_use_unilab_logic', L_USE_UNILAB_LOGIC);
     DBMS_SQL.VARIABLE_VALUE(L_RNDSUITE_CURSOR, ':l_lc_ss_from', L_LC_SS_FROM);
     DBMS_SQL.VARIABLE_VALUE(L_RNDSUITE_CURSOR, ':l_tr_no', L_TR_NO);
     DBMS_SQL.CLOSE_CURSOR(L_RNDSUITE_CURSOR);

      L_TR_OK := (L_RET_CODE = UNAPIGEN.DBERR_SUCCESS);
      IF L_TR_OK AND L_USE_UNILAB_LOGIC <> '1' THEN
         A_LC_SS_FROM := L_LC_SS_FROM;
         A_TR_NO := L_TR_NO;
      END IF;
   END IF;

   IF UNAPIGEN.P_RNDSUITESESSION <> '1' OR L_USE_UNILAB_LOGIC = '1' THEN
     
      
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
                     UNAPIAUT.P_OBJECT_TP      := A_OBJECT_TP;
                     UNAPIAUT.P_OBJECT_ID      := A_OBJECT_ID;
                     UNAPIAUT.P_OBJECT_VERSION := A_OBJECT_VERSION;
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
   END IF;

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
      UNAPIGEN.LOGERROR('ObjectTransitionAuthorised', SQLERRM);
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
   IF DBMS_SQL.IS_OPEN( L_RNDSUITE_CURSOR ) THEN
      DBMS_SQL.CLOSE_CURSOR( L_RNDSUITE_CURSOR );
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ObjectTransitionAuthorised'));
END OBJECTTRANSITIONAUTHORISED;

FUNCTION CHANGEOBJECTSTATUS
(A_OBJECT_TP          IN        VARCHAR2, 
 A_OBJECT_ID          IN        VARCHAR2, 
 A_OBJECT_VERSION     IN        VARCHAR2, 
 A_OLD_SS             IN        VARCHAR2, 
 A_NEW_SS             IN        VARCHAR2, 
 A_OBJECT_LC          IN        VARCHAR2, 
 A_OBJECT_LC_VERSION  IN        VARCHAR2, 
 A_MODIFY_REASON      IN        VARCHAR2) 
RETURN NUMBER IS

L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_OLD_SS                 VARCHAR2(2);
L_ALLOW_MODIFY           CHAR(1);
L_ACTIVE                 CHAR(1);
L_LOG_HS                 CHAR(1);
L_LC_SS_FROM             VARCHAR2(2);
L_TR_NO                  NUMBER(3);
L_SS_CURSOR              INTEGER;
L_LC_VERSION_CURSOR      INTEGER;

BEGIN

   
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   L_LC_VERSION_CURSOR := DBMS_SQL.OPEN_CURSOR;
   IF A_OBJECT_TP = 'lc' THEN
      L_SQL_STRING := 'SELECT nvl(lc_lc_version,'''') ' ||
                      'FROM dd' || UNAPIGEN.P_DD || '.uv'|| A_OBJECT_TP || 
                      ' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || '''' || 
                      ' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
   ELSE
      L_SQL_STRING := 'SELECT nvl(lc_version,'''') ' ||
                      'FROM dd' || UNAPIGEN.P_DD || '.uv'|| A_OBJECT_TP || 
                      ' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || '''' || 
                      ' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
   END IF;
   DBMS_SQL.PARSE(L_LC_VERSION_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   DBMS_SQL.DEFINE_COLUMN(L_LC_VERSION_CURSOR, 1, L_LC_VERSION, 20);
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_LC_VERSION_CURSOR);
   IF L_RESULT <> 0 THEN
      DBMS_SQL.COLUMN_VALUE(L_LC_VERSION_CURSOR, 1, L_LC_VERSION);
   END IF;
   DBMS_SQL.CLOSE_CURSOR(L_LC_VERSION_CURSOR);

   L_LC := A_OBJECT_LC;
   L_OLD_SS := A_OLD_SS; 
   L_RET_CODE := UNAPIPRP.OBJECTTRANSITIONAUTHORISED
                 (A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION,
                  L_LC, L_OLD_SS, A_NEW_SS,
                  UNAPIGEN.P_USER,
                  L_LC_SS_FROM, L_TR_NO, 
                  L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF (L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
       L_RET_CODE <> UNAPIGEN.DBERR_NOTMODIFIABLE) THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
   
   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      L_SS_CURSOR := DBMS_SQL.OPEN_CURSOR;
   
      L_SQL_STRING := 'UPDATE ut' || A_OBJECT_TP ||
                      ' SET ss = ''' || A_NEW_SS || 
                      ''', allow_modify = ''#''' ||
                      ', active = ''' || L_ACTIVE || 
                      ''' WHERE '|| A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                      ''' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 

      DBMS_SQL.PARSE(L_SS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      L_RESULT := DBMS_SQL.EXECUTE(L_SS_CURSOR);
   
      IF L_RESULT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
         RAISE STPERROR;
      END IF;
   
      L_EVENT_TP := 'ObjectStatusChanged';
      L_EV_SEQ_NR := -1;
      L_RESULT := UNAPIEV.INSERTEVENT('ChangeObjectStatus',
                                      UNAPIGEN.P_EVMGR_NAME, A_OBJECT_TP,
                                      A_OBJECT_ID, L_LC, L_LC_VERSION, A_NEW_SS, L_EVENT_TP,
                                      'version='||A_OBJECT_VERSION||'#tr_no='||L_TR_NO||
                                      '#ss_from='||L_OLD_SS||'#lc_ss_from='||L_LC_SS_FROM,
                                      L_EV_SEQ_NR);
      IF L_RESULT <>0 THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
      END IF;
   
      IF L_LOG_HS = '1' THEN
         L_SQL_STRING :=
                   'INSERT INTO ut' || A_OBJECT_TP || 'hs' || 
                   '(' || A_OBJECT_TP || ', version, who, who_description, what, '||
                     'what_description, logdate, logdate_tz, why, tr_seq, ev_seq)' ||
                   ' VALUES (''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                   ''', ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || 
                   ''', ''' || REPLACE(UNAPIGEN.P_USER, '''', '''''') || 
                   ''', ''' || REPLACE(UNAPIGEN.P_USER_DESCRIPTION, '''', '''''') || 
                   ''', ''' || L_EVENT_TP || 
                   ''', ''status of '||UNAPIGEN.GETOBJTPDESCRIPTION(A_OBJECT_TP)||' "'|| REPLACE(A_OBJECT_ID, '''', '''''') ||
                        '" is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'||UNAPIGEN.SQLSSNAME(A_NEW_SS)||
                        '" ['||A_NEW_SS||'].'', ' ||
                   'CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''' ||
                   REPLACE(A_MODIFY_REASON, '''', '''''') || 
                   ''', '   || UNAPIGEN.P_TR_SEQ || 
                   ', '     || L_EV_SEQ_NR || ')'; 
   
         DBMS_SQL.PARSE(L_SS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   
         L_RESULT := DBMS_SQL.EXECUTE(L_SS_CURSOR);
   
         IF L_RESULT = 0 THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
            RAISE STPERROR;
         END IF;
      END IF;
   
      DBMS_SQL.CLOSE_CURSOR(L_SS_CURSOR);
   END IF;
   
   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   UNAPIAUT.UPDATEAUTHORISATIONBUFFER(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, A_NEW_SS);

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN 
      UNAPIGEN.LOGERROR('ChangeObjectStatus', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_SS_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_SS_CURSOR);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_LC_VERSION_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_LC_VERSION_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ChangeObjectStatus'));
END CHANGEOBJECTSTATUS;

FUNCTION INTERNALCHANGEOBJECTSTATUS       
(A_OBJECT_TP          IN        VARCHAR2, 
 A_OBJECT_ID          IN        VARCHAR2, 
 A_OBJECT_VERSION     IN        VARCHAR2, 
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

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' OR
      NVL(A_NEW_SS, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
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
      L_RET_CODE := UNAPIPRP.CHANGEOBJECTSTATUS (A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, L_OLD_SS, A_NEW_SS, L_LC, L_LC_VERSION, A_MODIFY_REASON);

   ELSIF A_NEW_SS = '@C' THEN
      L_RET_CODE := UNAPIPRP.CANCELOBJECT (A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, A_MODIFY_REASON);      
   END IF;
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_SUCCESS; 
      
      L_SEQ_NR := NULL;
      L_RET_CODE := UNAPIEV.INSERTEVENT
                      (A_API_NAME          => 'InternalChangeObjectStatus',
                       A_EVMGR_NAME        => UNAPIGEN.P_EVMGR_NAME,
                       A_OBJECT_TP         => A_OBJECT_TP,
                       A_OBJECT_ID         => A_OBJECT_ID,
                       A_OBJECT_LC         => NULL,
                       A_OBJECT_LC_VERSION => NULL,
                       A_OBJECT_SS         => NULL,
                       A_EV_TP             => 'ObjectUpdated',
                       A_EV_DETAILS        => 'version='||A_OBJECT_VERSION||'#ss_to='||A_NEW_SS,
                       A_SEQ_NR            => L_SEQ_NR);
   END IF;
   
   UNAPIEV.P_RETRIESWHENINTRANSITION  := L_TMP_RETRIESWHENINTRANSITION;
   UNAPIEV.P_INTERVALWHENINTRANSITION := L_TMP_INTERVALWHENINTRANSITION;      

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   UNAPIAUT.UPDATEAUTHORISATIONBUFFER(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, A_NEW_SS);

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
      UNAPIGEN.LOGERROR('InternalChangeObjectStatus', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('InternalChangeObjectStatus', L_SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'InternalChangeObjectStatus'));
END INTERNALCHANGEOBJECTSTATUS;

FUNCTION CHECKELECSIGNATURE             
(A_SS_TO       IN VARCHAR2)             
RETURN NUMBER IS

L_SETTING_VALUE                VARCHAR2(255);
L_NEW_SS                       VARCHAR2(2);

BEGIN

   
   BEGIN
      SELECT SETTING_VALUE
      INTO L_SETTING_VALUE
      FROM UTSYSTEM
      WHERE SETTING_NAME = 'STATES_TO_SIGN_OFF'
      AND INSTR(SETTING_VALUE, A_SS_TO) <> 0;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RETURN(UNAPIGEN.P_TXN_ERROR);
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      
      NULL;
   END;

   BEGIN
      SELECT SS
      INTO L_NEW_SS
      FROM UTSS
      WHERE SS = A_SS_TO;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOSS;
      RETURN(UNAPIGEN.P_TXN_ERROR);
   END;
   RETURN(UNAPIGEN.DBERR_SUCCESS);   
END CHECKELECSIGNATURE;

FUNCTION CANCELOBJECT
(A_OBJECT_TP          IN        VARCHAR2, 
 A_OBJECT_ID          IN        VARCHAR2, 
 A_OBJECT_VERSION     IN        VARCHAR2, 
 A_MODIFY_REASON      IN        VARCHAR2) 
RETURN NUMBER IS

L_LC                          VARCHAR2(2);
L_LC_VERSION                  VARCHAR2(20);
L_OLD_SS                      VARCHAR2(2);
L_NEW_SS                      VARCHAR2(2);
L_ALLOW_MODIFY                CHAR(1);
L_ACTIVE                      CHAR(1);
L_LOG_HS                      CHAR(1);
L_LC_SS_FROM                  VARCHAR2(2);
L_TR_NO                       NUMBER(3);
L_CURRENT_TIMESTAMP                     VARCHAR2(40);
L_SS_CURSOR                   INTEGER;
L_LC_VERSION_CURSOR           INTEGER;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   L_LC_VERSION_CURSOR := DBMS_SQL.OPEN_CURSOR;
   IF A_OBJECT_TP = 'lc' THEN
      L_SQL_STRING := 'SELECT nvl(lc_lc_version,'''') ' ||
                      'FROM dd' || UNAPIGEN.P_DD || '.uv'|| A_OBJECT_TP || 
                      ' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || '''' || 
                      ' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
   ELSE
      L_SQL_STRING := 'SELECT nvl(lc_version,'''') ' ||
                      'FROM dd' || UNAPIGEN.P_DD || '.uv'|| A_OBJECT_TP || 
                      ' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || '''' || 
                      ' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
   END IF;
   
   DBMS_SQL.PARSE(L_LC_VERSION_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   DBMS_SQL.DEFINE_COLUMN(L_LC_VERSION_CURSOR, 1, L_LC_VERSION, 20);
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_LC_VERSION_CURSOR);
   IF L_RESULT <> 0 THEN
      DBMS_SQL.COLUMN_VALUE(L_LC_VERSION_CURSOR, 1, L_LC_VERSION);
   END IF;
   DBMS_SQL.CLOSE_CURSOR(L_LC_VERSION_CURSOR);

   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   L_LC := NULL;
   L_OLD_SS := NULL; 
   L_NEW_SS := '@C';
   L_RET_CODE := UNAPIPRP.OBJECTTRANSITIONAUTHORISED
                 (A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, 
                  L_LC, L_OLD_SS, L_NEW_SS,
                  UNAPIGEN.P_USER,
                  L_LC_SS_FROM, L_TR_NO, 
                  L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
                  
                     
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
      L_RET_CODE <> UNAPIGEN.DBERR_NOTAUTHORISED THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      L_SS_CURSOR := DBMS_SQL.OPEN_CURSOR;
   
      L_SQL_STRING := 'UPDATE ut' || A_OBJECT_TP ||
                      ' SET ss = ''' || L_NEW_SS || 
                      ''', allow_modify = ''#''' ||
                      ', active = ''' || L_ACTIVE || 
                      ''' WHERE '|| A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                      ''' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
   
      DBMS_SQL.PARSE(L_SS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      L_RESULT := DBMS_SQL.EXECUTE(L_SS_CURSOR);
   
      IF L_RESULT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
         RAISE STPERROR;
      END IF;
   
      L_EVENT_TP := 'ObjectCanceled';
      L_EV_SEQ_NR := -1;
      L_RESULT := UNAPIEV.INSERTEVENT('CancelObject',
                                      UNAPIGEN.P_EVMGR_NAME, A_OBJECT_TP,
                                      A_OBJECT_ID, L_LC, L_LC_VERSION, L_NEW_SS, L_EVENT_TP,
                                      'version='||A_OBJECT_VERSION||'#tr_no='||L_TR_NO||
                                      '#ss_from='||L_OLD_SS||'#lc_ss_from='||L_LC_SS_FROM,
                                      L_EV_SEQ_NR);
      IF L_RESULT <>0 THEN
         UNAPIGEN.P_TXN_ERROR := L_RESULT;
      END IF;
   
      IF L_LOG_HS = '1' THEN
         L_SQL_STRING :=
                   'INSERT INTO ut' || A_OBJECT_TP || 'hs' ||
                   '(' || A_OBJECT_TP || ', version, who, who_description, what, '||
                     'what_description, logdate, logdate_tz, why, tr_seq, ev_seq)' ||
                   ' VALUES (''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                   ''', ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || 
                   ''', ''' || REPLACE(UNAPIGEN.P_USER, '''', '''''') || 
                   ''', ''' || REPLACE(UNAPIGEN.P_USER_DESCRIPTION, '''', '''''') || 
                   ''', ''' || L_EVENT_TP || 
                   ''', ''' || UNAPIGEN.GETOBJTPDESCRIPTION(A_OBJECT_TP)||' "'|| REPLACE(A_OBJECT_ID, '''', '''''') ||
                        '" canceled, status is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'
                        ||UNAPIGEN.SQLSSNAME(L_NEW_SS)||'" ['||L_NEW_SS||'].'', '||
                   'CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''' ||
                   REPLACE(A_MODIFY_REASON, '''', '''''') || 
                   ''', '   || UNAPIGEN.P_TR_SEQ || 
                   ', '     || L_EV_SEQ_NR || ')'; 

         DBMS_SQL.PARSE(L_SS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   
         L_RESULT := DBMS_SQL.EXECUTE(L_SS_CURSOR);
   
         IF L_RESULT = 0 THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
            RAISE STPERROR;
         END IF;
      END IF;
   
      DBMS_SQL.CLOSE_CURSOR(L_SS_CURSOR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   UNAPIAUT.UPDATEAUTHORISATIONBUFFER(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, '@C');
   
   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN 
      UNAPIGEN.LOGERROR('CancelObject', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_SS_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_SS_CURSOR);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_LC_VERSION_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_LC_VERSION_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'CancelObject'));
END CANCELOBJECT;

FUNCTION CHANGEOBJECTLIFECYCLE
(A_OBJECT_TP          IN        VARCHAR2, 
 A_OBJECT_ID          IN        VARCHAR2, 
 A_OBJECT_VERSION     IN        VARCHAR2, 
 A_OLD_LC             IN        VARCHAR2, 
 A_OLD_LC_VERSION     IN        VARCHAR2, 
 A_NEW_LC             IN        VARCHAR2, 
 A_NEW_LC_VERSION     IN        VARCHAR2, 
 A_MODIFY_REASON      IN        VARCHAR2) 
RETURN NUMBER IS

L_LC_CURSOR              INTEGER;
L_LC_VERSION_CURSOR      INTEGER;
L_COUNT_US               NUMBER;
L_COUNT_LC               NUMBER;
L_ALLOW_MODIFY           CHAR(1);
L_LOG_HS                 CHAR(1);
L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_SS                     VARCHAR2(2);
L_ACTIVE                 CHAR(1);
L_LOCK_OBJECT            VARCHAR2(20);

BEGIN
   
   
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   
   EXECUTE IMMEDIATE 'SELECT '||A_OBJECT_TP ||' FROM ut'||A_OBJECT_TP||
                     ' WHERE '||A_OBJECT_TP ||'=:a_object_id'||
                     ' AND version=:a_object_version FOR UPDATE'      
   INTO L_LOCK_OBJECT
   USING A_OBJECT_ID, A_OBJECT_VERSION;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, L_LC, 
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

   L_LC_CURSOR := DBMS_SQL.OPEN_CURSOR;
   IF UNAPIGEN.P_TXN_ERROR = UNAPIGEN.DBERR_SUCCESS THEN
      IF A_OBJECT_TP = 'lc' THEN
         L_SQL_STRING := 'UPDATE ut' || A_OBJECT_TP || ' SET  ' ||
                         ' lc_lc = ''' || A_NEW_LC || ''', lc_lc_version = ''' || UNVERSION.P_NO_VERSION ||     
                         ''', allow_modify = ''#'', ss = '''' ' ||
                         ' WHERE '|| A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || '''' || 
                         ' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
      ELSE
         L_SQL_STRING := 'UPDATE ut' || A_OBJECT_TP || ' SET  ' ||
                         ' lc = ''' || A_NEW_LC || ''', lc_version = ''' || UNVERSION.P_NO_VERSION ||     
                         ''', allow_modify = ''#'', ss = '''' ' ||
                         ' WHERE '|| A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || '''' || 
                         ' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || ''''; 
      END IF;

      DBMS_SQL.PARSE(L_LC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      L_RESULT := DBMS_SQL.EXECUTE(L_LC_CURSOR);

      IF L_RESULT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
         RAISE STPERROR;
      END IF;
   END IF;

   L_EV_SEQ_NR := -1;
   L_EVENT_TP := 'ObjectLifeCycleChanged';
   L_RESULT := UNAPIEV.INSERTEVENT('ChangeObjectLifeCycle',
                                   UNAPIGEN.P_EVMGR_NAME, A_OBJECT_TP, A_OBJECT_ID, 
                                   A_NEW_LC, UNVERSION.P_NO_VERSION, '', L_EVENT_TP,    
                                   'version='||A_OBJECT_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;
 
   IF L_LOG_HS = '1' OR A_MODIFY_REASON IS NOT NULL THEN
      L_SQL_STRING := 'INSERT INTO ut' || A_OBJECT_TP || 'hs' || 
                      '(' || A_OBJECT_TP || ', version, who, who_description, what, '||
                        'what_description, logdate, logdate_tz, why, tr_seq, ev_seq)' ||
                      ' VALUES (''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                      ''', ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || 
                      ''', ''' || REPLACE(UNAPIGEN.P_USER, '''', '''''') || 
                      ''', ''' || REPLACE(UNAPIGEN.P_USER_DESCRIPTION, '''', '''''') || 
                      ''', ''' || L_EVENT_TP || 
                      ''', ''life cycle of '||UNAPIGEN.GETOBJTPDESCRIPTION(A_OBJECT_TP)||' "'||
                            REPLACE(A_OBJECT_ID, '''', '''''') ||'" is changed from "'||UNAPIGEN.SQLLCNAME(A_OLD_LC)||'" ['||A_OLD_LC||
                           '] to "'||UNAPIGEN.SQLLCNAME(A_NEW_LC)||'" ['||A_NEW_LC||'].'', ' ||
                      'CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''' ||
                      REPLACE(A_MODIFY_REASON, '''', '''''') || 
                      ''', '   || UNAPIGEN.P_TR_SEQ || 
                      ', '     || L_EV_SEQ_NR || ')'; 

      DBMS_SQL.PARSE(L_LC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

      L_RESULT := DBMS_SQL.EXECUTE(L_LC_CURSOR);
      IF L_RESULT =0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
         RAISE STPERROR;
      END IF;

   END IF;

   DBMS_SQL.CLOSE_CURSOR(L_LC_CURSOR);

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;








   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN NO_DATA_FOUND THEN
   
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.DBERR_SUCCESS,'ChangeObjectLifeCycle'));
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('ChangeObjectLifeCycle',SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_LC_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_LC_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'ChangeObjectLifeCycle'));
END CHANGEOBJECTLIFECYCLE;

FUNCTION GETUSEDOBJECT     
(A_OBJECT_TP                  IN     VARCHAR2,                  
 A_USED_OBJECT_TP             IN     VARCHAR2,                  
 A_OBJECT_ID                  IN     VARCHAR2,                  
 A_OBJECT_ID_VERSION          IN     VARCHAR2,                  
 A_USED_OBJECT_ID             OUT    UNAPIGEN.VC20_TABLE_TYPE,  
 A_USED_OBJECT_ID_VERSION     OUT    UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCRIPTION                OUT    UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS                 IN OUT NUMBER,                    
 A_WHERE_CLAUSE               IN     VARCHAR2)                  
RETURN NUMBER IS

L_USED_OBJECT_ID            VARCHAR2(20);
L_USED_OBJECT_ID_VERSION    VARCHAR2(20);
L_DESCRIPTION               VARCHAR2(40);
L_OBJ_CURSOR                INTEGER;
L_DESCR_CURSOR              INTEGER;
L_DESCR_SQL_STRING          VARCHAR2(200);
L_DESCR_RESULT              NUMBER;

BEGIN

  IF NVL(A_NR_OF_ROWS,0) = 0 THEN
     A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
  ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
     RETURN (UNAPIGEN.DBERR_NROFROWS);
  END IF;

  IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
     RETURN (UNAPIGEN.DBERR_NOOBJTP);
  END IF;

  IF NVL(A_USED_OBJECT_TP, ' ') = ' ' THEN
     RETURN (UNAPIGEN.DBERR_NOOBJTP);
  END IF;

  IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
     RETURN (UNAPIGEN.DBERR_NOOBJID);
  END IF;

  IF NVL(A_OBJECT_ID_VERSION, ' ') = ' ' THEN
     RETURN (UNAPIGEN.DBERR_NOOBJVERSION);
  END IF;

  IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
     L_WHERE_CLAUSE := ' WHERE '|| A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                       ''' AND version = ''' || REPLACE(A_OBJECT_ID_VERSION, '''', '''''') ||      
                       ''' ORDER BY seq';
  ELSIF
     UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
     L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uv'||A_USED_OBJECT_TP||' y WHERE y.version_is_current = ''1'' '||
                       'AND x.'||A_USED_OBJECT_TP||'_version = y.version '||
                       'AND x.'||A_USED_OBJECT_TP||' = y.'||A_USED_OBJECT_TP||' '||
                       'AND x.'|| A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                       ''' AND x.version = ''' || REPLACE(A_OBJECT_ID_VERSION, '''', '''''') ||      
                       ''' AND x.'|| A_USED_OBJECT_TP || ' = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                       ''' ORDER BY x.seq'; 
  ELSE
     L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
  END IF;

  L_SQL_STRING := 'SELECT x.' || A_USED_OBJECT_TP || ', x.' || A_USED_OBJECT_TP || '_version ' ||
                  'FROM dd' || UNAPIGEN.P_DD || '.uv' ||
                  A_OBJECT_TP || A_USED_OBJECT_TP || ' x'
                  || L_WHERE_CLAUSE;

  L_OBJ_CURSOR := DBMS_SQL.OPEN_CURSOR;
  L_DESCR_CURSOR := DBMS_SQL.OPEN_CURSOR;
  
  DBMS_SQL.PARSE(L_OBJ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
  DBMS_SQL.DEFINE_COLUMN(L_OBJ_CURSOR, 1, L_USED_OBJECT_ID, 20);
  DBMS_SQL.DEFINE_COLUMN(L_OBJ_CURSOR, 2, L_USED_OBJECT_ID_VERSION, 20);
  L_RESULT := DBMS_SQL.EXECUTE(L_OBJ_CURSOR);

  L_FETCHED_ROWS := 0;
  L_RESULT := DBMS_SQL.FETCH_ROWS(L_OBJ_CURSOR);

  LOOP
     EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
     DBMS_SQL.COLUMN_VALUE(L_OBJ_CURSOR, 1, L_USED_OBJECT_ID);
     DBMS_SQL.COLUMN_VALUE(L_OBJ_CURSOR, 2, L_USED_OBJECT_ID_VERSION);

     L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

     A_USED_OBJECT_ID(L_FETCHED_ROWS) := L_USED_OBJECT_ID;
     A_USED_OBJECT_ID_VERSION(L_FETCHED_ROWS) := L_USED_OBJECT_ID_VERSION;

     
     
     
     IF A_USED_OBJECT_TP = 'ie' THEN
        L_DESCR_SQL_STRING := 'SELECT dsp_title' ;
     ELSE
        L_DESCR_SQL_STRING := 'SELECT description' ;
     END IF;
     L_DESCR_SQL_STRING := L_DESCR_SQL_STRING ||
                           ' FROM dd' || UNAPIGEN.P_DD  || '.uv' ||
                           A_USED_OBJECT_TP || ' WHERE '|| 
                           A_USED_OBJECT_TP || ' = '''  || REPLACE(L_USED_OBJECT_ID , '''', '''''')|| 
                           ''' AND version = ''' || REPLACE(L_USED_OBJECT_ID_VERSION , '''', '''''')|| '''' ; 
     
     DBMS_SQL.PARSE(L_DESCR_CURSOR, L_DESCR_SQL_STRING, DBMS_SQL.V7); 
     DBMS_SQL.DEFINE_COLUMN(L_DESCR_CURSOR, 1, L_DESCRIPTION, 40);
     L_DESCR_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DESCR_CURSOR);
     IF L_DESCR_RESULT > 0 THEN
        DBMS_SQL.COLUMN_VALUE(L_DESCR_CURSOR, 1, L_DESCRIPTION);
        A_DESCRIPTION(L_FETCHED_ROWS) := L_DESCRIPTION;
     ELSE
        A_DESCRIPTION(L_FETCHED_ROWS) := NULL;
     END IF;
     
     IF L_RESULT < A_NR_OF_ROWS THEN
        L_RESULT := DBMS_SQL.FETCH_ROWS(L_OBJ_CURSOR);
     END IF;
  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(L_DESCR_CURSOR);
  DBMS_SQL.CLOSE_CURSOR(L_OBJ_CURSOR);

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
             'GetUsedObject', L_SQLERRM);
     UNAPIGEN.U4COMMIT;
     IF DBMS_SQL.IS_OPEN (L_OBJ_CURSOR) THEN
        DBMS_SQL.CLOSE_CURSOR (L_OBJ_CURSOR);
     END IF;
     IF DBMS_SQL.IS_OPEN (L_DESCR_CURSOR) THEN
        DBMS_SQL.CLOSE_CURSOR (L_DESCR_CURSOR);
     END IF;
     RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETUSEDOBJECT;

FUNCTION OBJECTELECTRONICSIGNATURE
(A_OBJECT_TP          IN        VARCHAR2, 
 A_OBJECT_ID          IN        VARCHAR2, 
 A_OBJECT_VERSION     IN        VARCHAR2, 
 A_AUTHORISED_BY      IN        VARCHAR2, 
 A_MODIFY_REASON      IN        VARCHAR2) 
RETURN NUMBER IS

L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_LOG_HS       CHAR(1);
L_SS_CURSOR    INTEGER;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   L_RET_CODE := UNAPIGEN.GETAUTHORISATION(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, L_LC, 
                                           L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS AND
      L_RET_CODE <> UNAPIGEN.DBERR_NOTMODIFIABLE THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   L_SS_CURSOR := DBMS_SQL.OPEN_CURSOR;
   IF A_AUTHORISED_BY IS NOT NULL THEN
      L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
 
      L_SQL_STRING :=
                'INSERT INTO ut' || A_OBJECT_TP || 'hs' ||
                '(' || A_OBJECT_TP || ', version, who, who_description, what, '||
                  'what_description, logdate, logdate_tz, why, tr_seq, ev_seq)' ||
                ' VALUES (''' || REPLACE(A_OBJECT_ID, '''', '''''') || 
                ''', ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || 
                ''', ''' || REPLACE(A_AUTHORISED_BY, '''', '''''') || 
                ''', ''' || REPLACE(UNAPIGEN.SQLUSERDESCRIPTION(A_AUTHORISED_BY), '''', '''''') ||
                ''', ''ElectronicSignature'', '||
                '''Last action of '||UNAPIGEN.GETOBJTPDESCRIPTION(A_OBJECT_TP)||' "'|| REPLACE(A_OBJECT_ID, '''', '''''') ||
                   '" is signed electronically.'', ' ||
                'CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ''' ||
                REPLACE(A_MODIFY_REASON, '''', '''''') || 
                ''', '   || UNAPIGEN.P_TR_SEQ || 
                ', '     || L_EV_SEQ_NR || ')'; 

      DBMS_SQL.PARSE(L_SS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

      L_RESULT := DBMS_SQL.EXECUTE(L_SS_CURSOR);

      IF L_RESULT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
         RAISE STPERROR;
      END IF;
   END IF;
   DBMS_SQL.CLOSE_CURSOR(L_SS_CURSOR);

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   
   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN 
      UNAPIGEN.LOGERROR('ObjectElectronicSignature', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_SS_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_SS_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'ObjectElectronicSignature'));
END OBJECTELECTRONICSIGNATURE;

FUNCTION UPDATEOBJWHATDESCRIPTION
(A_OBJECT_TP         IN        VARCHAR2,                   
 A_OBJECT_ID         IN        VARCHAR2,                   
 A_OBJECT_VERSION    IN        VARCHAR2,                   
 A_WHAT              IN        VARCHAR2,                   
 A_WHAT_DESCRIPTION  IN        VARCHAR2,                   
 A_TR_SEQ            IN        NUMBER,                     
 A_EV_SEQ            IN        NUMBER)                     
RETURN NUMBER IS

L_LC                VARCHAR2(2);
L_LC_VERSION        VARCHAR2(20);
L_SS                VARCHAR2(2);
L_ALLOW_MODIFY      CHAR(1);
L_ACTIVE            CHAR(1);
L_LOG_HS            CHAR(1);
L_DESCR_CURSOR      INTEGER;

BEGIN








   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.P_TXN_ERROR THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_TP, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJTP;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_ID, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_OBJECT_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF NVL(A_TR_SEQ, 0) = 0 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_TRSEQ;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION(A_OBJECT_TP, A_OBJECT_ID, A_OBJECT_VERSION, L_LC, 
                                           L_LC_VERSION, L_SS, L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   L_DESCR_CURSOR := DBMS_SQL.OPEN_CURSOR;

   
   L_SQL_STRING :=
        'UPDATE ut' || A_OBJECT_TP || 'hs' ||
        ' SET what_description = ''' || REPLACE(A_WHAT_DESCRIPTION, '''', '''''') || '''' || 
        ' WHERE ' || A_OBJECT_TP || ' = ''' || REPLACE(A_OBJECT_ID, '''', '''''') || '''' || 
        ' AND version = ''' || REPLACE(A_OBJECT_VERSION, '''', '''''') || '''' || 
        ' AND tr_seq = ' || A_TR_SEQ;
        
   DBMS_SQL.PARSE(L_DESCR_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   L_RESULT := DBMS_SQL.EXECUTE(L_DESCR_CURSOR);
   
   DBMS_SQL.CLOSE_CURSOR(L_DESCR_CURSOR);

   IF L_RESULT = 0 THEN
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
      UNAPIGEN.LOGERROR('UpdateObjWhatDescription', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_DESCR_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_DESCR_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'UpdateObjWhatDescription'));
END UPDATEOBJWHATDESCRIPTION;

END UNAPIPRP;