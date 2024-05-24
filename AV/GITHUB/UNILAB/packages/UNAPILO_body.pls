PACKAGE BODY unapilo AS

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(2000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
STPERROR          EXCEPTION;


P_LO_CURSOR      INTEGER;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION GETLOCATION
(A_LO                OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_DESCRIPTION       OUT  UNAPIGEN.VC40_TABLE_TYPE,     
 A_DESCRIPTION2      OUT  UNAPIGEN.VC40_TABLE_TYPE,     
 A_NR_SC_MAX         OUT  UNAPIGEN.NUM_TABLE_TYPE,       
 A_CURR_NR_SC        OUT  UNAPIGEN.NUM_TABLE_TYPE,       
 A_IS_TEMPLATE       OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_NR_OF_ROWS        IN OUT  NUMBER,                    
 A_WHERE_CLAUSE      IN   VARCHAR2)                     
RETURN NUMBER IS
L_LO             VARCHAR2(20);
L_DESCRIPTION    VARCHAR2(40);
L_DESCRIPTION2   VARCHAR2(40);
L_NR_SC_MAX      NUMBER;
L_CURR_NR_SC     NUMBER;
L_IS_TEMPLATE    CHAR(1);

L_LO_CURSOR      INTEGER;
BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY lo'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := 'WHERE lo = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' ORDER BY lo';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_LO_CURSOR := DBMS_SQL.OPEN_CURSOR;

   L_SQL_STRING := 'SELECT lo, description, description2, nr_sc_max, curr_nr_sc, is_template ' ||
      ' FROM dd' || UNAPIGEN.P_DD || '.uvlo ' || L_WHERE_CLAUSE;
   DBMS_SQL.PARSE(L_LO_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_LO_CURSOR,       1,   L_LO                ,  20   );
   DBMS_SQL.DEFINE_COLUMN(L_LO_CURSOR,       2,   L_DESCRIPTION       ,  40   );
   DBMS_SQL.DEFINE_COLUMN(L_LO_CURSOR,       3,   L_DESCRIPTION2      ,  40   );
   DBMS_SQL.DEFINE_COLUMN(L_LO_CURSOR,       4,   L_NR_SC_MAX         );
   DBMS_SQL.DEFINE_COLUMN(L_LO_CURSOR,       5,   L_CURR_NR_SC        );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_LO_CURSOR,  6,   L_IS_TEMPLATE       ,  1   );
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_LO_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_LO_CURSOR,       1,   L_LO              );
      DBMS_SQL.COLUMN_VALUE(L_LO_CURSOR,       2,   L_DESCRIPTION     );
      DBMS_SQL.COLUMN_VALUE(L_LO_CURSOR,       3,   L_DESCRIPTION2    );
      DBMS_SQL.COLUMN_VALUE(L_LO_CURSOR,       4,   L_NR_SC_MAX       );
      DBMS_SQL.COLUMN_VALUE(L_LO_CURSOR,       5,   L_CURR_NR_SC      );
      DBMS_SQL.COLUMN_VALUE_CHAR(L_LO_CURSOR,  6,   L_IS_TEMPLATE     );
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_LO             (L_FETCHED_ROWS) := L_LO ;
      A_DESCRIPTION    (L_FETCHED_ROWS) := L_DESCRIPTION ;
      A_DESCRIPTION2   (L_FETCHED_ROWS) := L_DESCRIPTION2 ;
      A_NR_SC_MAX      (L_FETCHED_ROWS) := L_NR_SC_MAX ;
      A_CURR_NR_SC     (L_FETCHED_ROWS) := L_CURR_NR_SC ;
      A_IS_TEMPLATE    (L_FETCHED_ROWS) := L_IS_TEMPLATE ;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_LO_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_LO_CURSOR);

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
              'GetLocation', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (L_LO_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_LO_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETLOCATION;


FUNCTION SAVELOCATION
(A_LO               IN    VARCHAR2,  
 A_DESCRIPTION      IN    VARCHAR2,  
 A_DESCRIPTION2     IN    VARCHAR2,  
 A_NR_SC_MAX        IN    NUMBER,    
 A_CURR_NR_SC       IN    NUMBER,    
 A_IS_TEMPLATE      IN    CHAR,      
 A_MODIFY_REASON    IN    VARCHAR2)  
RETURN NUMBER IS

L_COUNT        NUMBER;
L_INSERT       BOOLEAN;

CURSOR LC_LO(C_LO VARCHAR2) IS
SELECT COUNT(*) FROM UTLO WHERE LO = C_LO;

BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_LO, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;
   
   OPEN LC_LO(A_LO);
   FETCH LC_LO INTO L_COUNT;
   CLOSE LC_LO;
   
   IF L_COUNT = 0 THEN
      L_INSERT := TRUE;
   ELSE
      L_INSERT := FALSE;
   END IF;

   IF L_INSERT THEN                
      INSERT INTO UTLO(LO, DESCRIPTION, DESCRIPTION2, NR_SC_MAX, CURR_NR_SC, IS_TEMPLATE)
      VALUES(A_LO, A_DESCRIPTION, A_DESCRIPTION2, A_NR_SC_MAX, A_CURR_NR_SC, A_IS_TEMPLATE);
      L_EVENT_TP := 'ObjectCreated';
   ELSE                             
      UPDATE UTLO
      SET DESCRIPTION           = A_DESCRIPTION ,
          DESCRIPTION2          = A_DESCRIPTION2,
          NR_SC_MAX             = A_NR_SC_MAX,
          CURR_NR_SC            = A_CURR_NR_SC,
          IS_TEMPLATE           = A_IS_TEMPLATE
      WHERE LO = A_LO;
       L_EVENT_TP := 'ObjectUpdated';
   END IF;

   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveLocation', UNAPIGEN.P_EVMGR_NAME, 'lo', A_LO, '', '', '', 
          L_EVENT_TP, '', L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
        UNAPIGEN.LOGERROR('SaveLocation', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveLocation'));
END SAVELOCATION;

FUNCTION DELETELOCATION
(A_LO            IN  VARCHAR2,            
 A_MODIFY_REASON IN  VARCHAR2)            
RETURN NUMBER IS
BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_LO, ' ')= ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   IF UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTALLOWEDIN21CFR11;
      RAISE STPERROR;
   END IF;

   DELETE FROM UTLOAU
   WHERE LO = A_LO;

   DELETE FROM UTLOCS
   WHERE  LO = A_LO;

   DELETE FROM UTLO
   WHERE LO = A_LO;

   L_EVENT_TP := 'ObjectDeleted';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('DeleteLocation', UNAPIGEN.P_EVMGR_NAME, 'lo', A_LO, '', 
                                   '', '', L_EVENT_TP, '', L_EV_SEQ_NR);

   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
        UNAPIGEN.LOGERROR('DeleteLocation', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'DeleteLocation'));
END DELETELOCATION;

FUNCTION GETLOATTRIBUTE
(A_LO                     OUT   UNAPIGEN.VC20_TABLE_TYPE,  
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
L_LO             VARCHAR2(20);
L_AU_CURSOR      INTEGER;
BEGIN
  IF NVL(A_NR_OF_ROWS,0) = 0 THEN
     A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
  ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
     RETURN (UNAPIGEN.DBERR_NROFROWS);
  END IF;

  IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
     RETURN(UNAPIGEN.DBERR_WHERECLAUSE);
  ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
     L_WHERE_CLAUSE := 'WHERE lo =  ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || ''' ' || 
                    ' ORDER BY auseq';      
  ELSE
     L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
  END IF;

  L_SQL_STRING := 'SELECT lo, au, au_version, value FROM dd' ||
                   UNAPIGEN.P_DD || '.uvloau '
                   || L_WHERE_CLAUSE;

  IF NOT DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
     L_AU_CURSOR := DBMS_SQL.OPEN_CURSOR;
     DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

     DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 1, L_LO, 20);
     DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 2, L_AU, 20);
     DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 3, L_AU_VERSION, 20);
     DBMS_SQL.DEFINE_COLUMN(L_AU_CURSOR, 4, L_VALUE, 40);

     L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);
  END IF;
  
  L_RESULT := DBMS_SQL.FETCH_ROWS(L_AU_CURSOR);
  L_FETCHED_ROWS := 0;

  LOOP
     EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 1, L_LO);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 2, L_AU);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 3, L_AU_VERSION);
     DBMS_SQL.COLUMN_VALUE(L_AU_CURSOR, 4, L_VALUE);

     L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

     A_LO(L_FETCHED_ROWS) := L_LO;
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

   IF DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
   END IF;
   RETURN(L_RET_CODE);

EXCEPTION
  WHEN OTHERS THEN
     L_SQLERRM := SQLERRM;
     UNAPIGEN.U4ROLLBACK;
     INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
     VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'GetLoAttribute', L_SQLERRM);
     INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
     VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'GetLoAttribute', SUBSTR(L_SQL_STRING,1,200));
     IF LENGTH(L_SQL_STRING)>200 THEN
        INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
        VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                'GetLoAttribute', SUBSTR(L_SQL_STRING,201,200));
     END IF;
     UNAPIGEN.U4COMMIT;
     IF DBMS_SQL.IS_OPEN (L_AU_CURSOR) THEN
        DBMS_SQL.CLOSE_CURSOR (L_AU_CURSOR);
     END IF;
     IF UNAPIGEN.L_AUDET_CURSOR%ISOPEN THEN
        CLOSE UNAPIGEN.L_AUDET_CURSOR;
     END IF;
     RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETLOATTRIBUTE;

FUNCTION SAVELOATTRIBUTE
(A_LO                       IN        VARCHAR2,                 
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
L_LO           VARCHAR2(20);

BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_LO, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_SQL_STRING := ' DELETE FROM utloau' ||
                      ' WHERE lo=''' || REPLACE(A_LO, '''', '''''') || '''' ; 
 
   L_AU_CURSOR := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   L_RESULT := DBMS_SQL.EXECUTE(L_AU_CURSOR);

   
   L_SQL_STRING := 'INSERT INTO utloau' ||
                   '(lo, au, au_version, auseq, value)' ||
                   ' VALUES (:d_lo,  :d_au, :d_au_version, :d_seq, :d_value)';

   DBMS_SQL.PARSE(L_AU_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   FOR I IN 1..A_NR_OF_ROWS LOOP
      L_AU := A_AU(I);
      
      L_AU_VERSION := NULL;
      L_VALUE := A_VALUE(I);
      DBMS_SQL.BIND_VARIABLE(L_AU_CURSOR, ':d_lo', A_LO);
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

   DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);

   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveLoAttribute', UNAPIGEN.P_EVMGR_NAME, 'lo', A_LO, '', 
                                   '', '', L_EVENT_TP, '', L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
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
      UNAPIGEN.LOGERROR('SaveLoAttribute', SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN(L_AU_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_AU_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveLoAttribute'));
END SAVELOATTRIBUTE;

FUNCTION GETLOCONDITIONSET
(A_LO             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_CS             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_DESCRIPTION    OUT    UNAPIGEN.VC40_TABLE_TYPE,    
 A_NR_OF_ROWS     IN OUT NUMBER,                      
 A_WHERE_CLAUSE   IN     VARCHAR2)                    
RETURN NUMBER IS

L_CS          VARCHAR2(20);
L_LO          VARCHAR2(20);
L_DESCRIPTION NUMBER;
L_LOCS_CURSOR INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY lo, seq'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ' WHERE lo = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' ORDER BY seq';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_LOCS_CURSOR := DBMS_SQL.OPEN_CURSOR;

   L_SQL_STRING := 'SELECT lo, cs ' ||
                    'FROM dd' || UNAPIGEN.P_DD || '.uvlocs '|| L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_LOCS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_LOCS_CURSOR,      1,  L_LO       ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_LOCS_CURSOR,      2,  L_CS       ,   20);
  
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_LOCS_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_LOCS_CURSOR,   1,  L_LO    );
      DBMS_SQL.COLUMN_VALUE(L_LOCS_CURSOR,   2,  L_CS    );
                                                                  
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_LO(L_FETCHED_ROWS) := L_LO;
      A_CS(L_FETCHED_ROWS) := L_CS;
      
      L_SQL_STRING:=   'SELECT description '
                     ||'FROM dd'||UNAPIGEN.P_DD||'.uvcs '
                     ||'WHERE cs = :l_cs';
      BEGIN
         EXECUTE IMMEDIATE L_SQL_STRING 
         INTO A_DESCRIPTION(L_FETCHED_ROWS)
         USING L_CS;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            
            NULL;
      END;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_LOCS_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_LOCS_CURSOR);

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
           'GetLoConditionSet', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   IF DBMS_SQL.IS_OPEN (L_LOCS_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR (L_LOCS_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETLOCONDITIONSET;

FUNCTION SAVELOCONDITIONSET
(A_LO            IN    VARCHAR2,                      
 A_CS            IN    UNAPIGEN.VC20_TABLE_TYPE,      
 A_NR_OF_ROWS    IN    NUMBER,                        
 A_MODIFY_REASON IN    VARCHAR2)                      
RETURN NUMBER IS

L_COUNT        NUMBER;
L_SEQ_NO       NUMBER;

CURSOR L_UTCS_CURSOR(C_CS VARCHAR2) IS
SELECT COUNT(*) 
FROM UTCS 
WHERE CS = C_CS;

CURSOR L_UTLO_CURSOR(C_LO VARCHAR2) IS
SELECT COUNT(*) 
FROM UTLO 
WHERE LO = C_LO;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_LO, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   
   OPEN L_UTLO_CURSOR(A_LO);
   FETCH L_UTLO_CURSOR 
   INTO L_COUNT;
   CLOSE L_UTLO_CURSOR;
   IF L_COUNT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
       RAISE STPERROR;
   END IF;

   DELETE UTLOCS
   WHERE LO = A_LO;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP   
      IF NVL(A_CS(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;

         
      OPEN L_UTCS_CURSOR(A_CS(L_SEQ_NO));
      FETCH L_UTCS_CURSOR 
      INTO L_COUNT;
      CLOSE L_UTCS_CURSOR;
      IF L_COUNT = 0 THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE STPERROR;
      END IF;

      INSERT INTO UTLOCS (LO, CS, SEQ)
      VALUES (A_LO, A_CS(L_SEQ_NO), L_SEQ_NO);
   END LOOP;

   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveLoConditionSet', UNAPIGEN.P_EVMGR_NAME, 'lo', A_LO, '', 
                                   '', '', L_EVENT_TP, '', L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveLoConditionSet', SQLERRM);
   END IF;
   IF L_UTLO_CURSOR%ISOPEN THEN
      CLOSE L_UTLO_CURSOR;
   END IF;
   IF L_UTCS_CURSOR%ISOPEN THEN
      CLOSE L_UTCS_CURSOR;
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveLoConditionSet'));
END SAVELOCONDITIONSET;

END UNAPILO;