PACKAGE BODY unapieq AS

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(2000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_EV_DETAILS      VARCHAR2(255);
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
P_EQ_CURSOR       INTEGER;
STPERROR          EXCEPTION;







 





CURSOR C_SYSTEM (A_SETTING_NAME VARCHAR2) IS
   SELECT SETTING_VALUE
   FROM UTSYSTEM
   WHERE SETTING_NAME = A_SETTING_NAME;

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_21.01');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION GETEQUIPMENTLIST
(A_EQ                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_LAB                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_DESCRIPTION             OUT     UNAPIGEN.VC40_TABLE_TYPE,     
 A_SS                      OUT     UNAPIGEN.VC2_TABLE_TYPE,      
 A_CA_WARN_LEVEL           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_NR_OF_ROWS              IN OUT  NUMBER,                       
 A_WHERE_CLAUSE            IN      VARCHAR2,                     
 A_NEXT_ROWS               IN      NUMBER)                       
RETURN NUMBER IS

L_EQ                VARCHAR2(20);
L_LAB               VARCHAR2(20);
L_DESCRIPTION       VARCHAR2(40);
L_SS                VARCHAR2(2);
L_CA_WARN_LEVEL     CHAR(1);

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
      IF P_EQ_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_EQ_CURSOR);
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_EQ_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   IF NVL(A_NEXT_ROWS,0) = 0 THEN
      IF P_EQ_CURSOR IS NULL THEN
         
         P_EQ_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;
      
      IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
         L_WHERE_CLAUSE := 'ORDER BY eq, lab, version'; 
      ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
         L_WHERE_CLAUSE := 'WHERE version_is_current = ''1'' '||
                           'AND eq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                           ''' AND lab = ''-'' ORDER BY eq, lab, version';
      ELSE
         L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
      END IF;

      
      L_SQL_STRING := 'SELECT eq, lab, description, ss, ca_warn_level FROM dd' || UNAPIGEN.P_DD ||
                      '.uveq ' || L_WHERE_CLAUSE;

      DBMS_SQL.PARSE(P_EQ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

      
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 1, L_EQ, 20);
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 2, L_LAB, 20);
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 3, L_DESCRIPTION, 40);
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 4, L_SS, 2);
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_EQ_CURSOR, 5, L_CA_WARN_LEVEL, 1);

      L_RESULT := DBMS_SQL.EXECUTE(P_EQ_CURSOR);

   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(P_EQ_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 1, L_EQ);
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 2, L_LAB);
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 3, L_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 4, L_SS);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_EQ_CURSOR, 5, L_CA_WARN_LEVEL);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_EQ(L_FETCHED_ROWS)                := L_EQ;
      A_LAB(L_FETCHED_ROWS)               := L_LAB;
      A_DESCRIPTION(L_FETCHED_ROWS)       := L_DESCRIPTION;
      A_SS(L_FETCHED_ROWS)                := L_SS;
      A_CA_WARN_LEVEL(L_FETCHED_ROWS)     := L_CA_WARN_LEVEL;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_EQ_CURSOR);
      END IF;
   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
      DBMS_SQL.CLOSE_CURSOR(P_EQ_CURSOR);
      RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_EQ_CURSOR);
      A_NR_OF_ROWS  := L_FETCHED_ROWS;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
              'GetEquipmentList', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_EQ_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_EQ_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETEQUIPMENTLIST;

FUNCTION GETEQUIPMENT
(A_EQ                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_LAB                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_DESCRIPTION             OUT     UNAPIGEN.VC40_TABLE_TYPE,     
 A_SERIAL_NO               OUT     UNAPIGEN.VC255_TABLE_TYPE,    
 A_SUPPLIER                OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_LOCATION                OUT     UNAPIGEN.VC40_TABLE_TYPE,     
 A_INVEST_COST             OUT     UNAPIGEN.FLOAT_TABLE_TYPE,    
 A_INVEST_UNIT             OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_USAGE_COST              OUT     UNAPIGEN.FLOAT_TABLE_TYPE,    
 A_USAGE_UNIT              OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_INSTALL_DATE            OUT     UNAPIGEN.DATE_TABLE_TYPE,     
 A_IN_SERVICE_DATE         OUT     UNAPIGEN.DATE_TABLE_TYPE,     
 A_ACCESSORIES             OUT     UNAPIGEN.VC40_TABLE_TYPE,     
 A_OPERATION               OUT     UNAPIGEN.VC255_TABLE_TYPE,    
 A_OPERATION_DOC           OUT     UNAPIGEN.VC255_TABLE_TYPE,    
 A_USAGE                   OUT     UNAPIGEN.VC255_TABLE_TYPE,    
 A_USAGE_DOC               OUT     UNAPIGEN.VC255_TABLE_TYPE,    
 A_EQ_COMPONENT            OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_KEEP_CTOLD              OUT     UNAPIGEN.FLOAT_TABLE_TYPE,    
 A_KEEP_CTOLD_UNIT         OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_IS_TEMPLATE             OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_LOG_HS                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_ALLOW_MODIFY            OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_ACTIVE                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_CA_WARN_LEVEL           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_LC                      OUT     UNAPIGEN.VC2_TABLE_TYPE,      
 A_SS                      OUT     UNAPIGEN.VC2_TABLE_TYPE,      
 A_NR_OF_ROWS              IN OUT  NUMBER,                       
 A_WHERE_CLAUSE            IN      VARCHAR2)                     
RETURN NUMBER IS

L_EQ                       VARCHAR(20);
L_LAB                      VARCHAR(20);
L_DESCRIPTION              VARCHAR2(40);
L_SERIAL_NO                VARCHAR2(255);
L_SUPPLIER                 VARCHAR2(20);
L_LOCATION                 VARCHAR2(40);
L_INVEST_COST              NUMBER;
L_INVEST_UNIT              VARCHAR2(20);
L_USAGE_COST               NUMBER;
L_USAGE_UNIT               VARCHAR2(20);
L_INSTALL_DATE             TIMESTAMP WITH TIME ZONE;
L_IN_SERVICE_DATE          TIMESTAMP WITH TIME ZONE;
L_ACCESSORIES              VARCHAR2(40);
L_OPERATION                VARCHAR2(255);
L_OPERATION_DOC            VARCHAR2(255);
L_USAGE                    VARCHAR2(255);
L_USAGE_DOC                VARCHAR2(255);
L_EQ_COMPONENT             VARCHAR2(1);
L_KEEP_CTOLD               NUMBER;
L_KEEP_CTOLD_UNIT          VARCHAR2(20);
L_IS_TEMPLATE              CHAR(1);
L_LOG_HS                   CHAR(1);
L_ALLOW_MODIFY             CHAR(1);
L_ACTIVE                   CHAR(1);
L_CA_WARN_LEVEL            CHAR(1);
L_SS                       VARCHAR2(2);
L_LC                       VARCHAR2(2);

L_EQ_CURSOR                INTEGER;

BEGIN
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY eq, lab, version'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := 'WHERE version_is_current = ''1'' ' || 
                        'AND eq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' AND lab=''-'' ORDER BY eq, lab, version'; 
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_EQ_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'SELECT eq, lab, description, serial_no, supplier, location, ' ||
                   'invest_cost, invest_unit, usage_cost, usage_unit, install_date, ' ||
                   'in_service_date, accessories, operation, operation_doc, usage, usage_doc, ' ||
                   'eq_component, keep_ctold, keep_ctold_unit, ' ||
                   'is_template, log_hs, allow_modify, active, ca_warn_level, lc, ss FROM dd' ||
                    UNAPIGEN.P_DD || '.uveq ' || L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_EQ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      1, L_EQ, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      2, L_LAB, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      3, L_DESCRIPTION, 40);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      4, L_SERIAL_NO, 255);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      5, L_SUPPLIER, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      6, L_LOCATION, 40);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      7, L_INVEST_COST);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      8, L_INVEST_UNIT, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      9, L_USAGE_COST);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      10, L_USAGE_UNIT, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      11, L_INSTALL_DATE);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      12, L_IN_SERVICE_DATE);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      13, L_ACCESSORIES, 40);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      14, L_OPERATION, 255);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      15, L_OPERATION_DOC, 255);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      16, L_USAGE, 255);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      17, L_USAGE_DOC, 255);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      18, L_EQ_COMPONENT, 1);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      19, L_KEEP_CTOLD);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      20, L_KEEP_CTOLD_UNIT, 20);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_EQ_CURSOR, 21, L_IS_TEMPLATE, 1);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_EQ_CURSOR, 22, L_LOG_HS, 1);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_EQ_CURSOR, 23, L_ALLOW_MODIFY, 1);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_EQ_CURSOR, 24, L_ACTIVE, 1);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_EQ_CURSOR, 25, L_CA_WARN_LEVEL, 1);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      26, L_LC, 2);
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,      27, L_SS, 2);

   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_EQ_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      1,  L_EQ);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      2,  L_LAB);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      3,  L_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      4,  L_SERIAL_NO);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      5,  L_SUPPLIER);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      6,  L_LOCATION);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      7,  L_INVEST_COST);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      8,  L_INVEST_UNIT);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      9,  L_USAGE_COST);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      10, L_USAGE_UNIT);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      11, L_INSTALL_DATE);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      12, L_IN_SERVICE_DATE);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      13, L_ACCESSORIES);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      14, L_OPERATION);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      15, L_OPERATION_DOC);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      16, L_USAGE);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      17, L_USAGE_DOC);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      18, L_EQ_COMPONENT);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      19, L_KEEP_CTOLD);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      20, L_KEEP_CTOLD_UNIT);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_EQ_CURSOR, 21, L_IS_TEMPLATE);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_EQ_CURSOR, 22, L_LOG_HS);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_EQ_CURSOR, 23, L_ALLOW_MODIFY);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_EQ_CURSOR, 24, L_ACTIVE);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_EQ_CURSOR, 25, L_CA_WARN_LEVEL);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      26, L_LC);
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,      27, L_SS);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_EQ(L_FETCHED_ROWS)                   := L_EQ;
      A_LAB(L_FETCHED_ROWS)                  := L_LAB;
      A_DESCRIPTION(L_FETCHED_ROWS)          := L_DESCRIPTION;
      A_SERIAL_NO(L_FETCHED_ROWS)            := L_SERIAL_NO;
      A_SUPPLIER(L_FETCHED_ROWS)             := L_SUPPLIER;
      A_LOCATION(L_FETCHED_ROWS)             := L_LOCATION;
      A_INVEST_COST(L_FETCHED_ROWS)          := L_INVEST_COST;
      A_INVEST_UNIT(L_FETCHED_ROWS)          := L_INVEST_UNIT;
      A_USAGE_COST(L_FETCHED_ROWS)           := L_USAGE_COST;
      A_USAGE_UNIT(L_FETCHED_ROWS)           := L_USAGE_UNIT;
      A_INSTALL_DATE(L_FETCHED_ROWS)         := L_INSTALL_DATE;
      A_IN_SERVICE_DATE(L_FETCHED_ROWS)      := L_IN_SERVICE_DATE;
      A_ACCESSORIES(L_FETCHED_ROWS)          := L_ACCESSORIES;
      A_OPERATION(L_FETCHED_ROWS)            := L_OPERATION;
      A_OPERATION_DOC(L_FETCHED_ROWS)        := L_OPERATION_DOC;
      A_USAGE(L_FETCHED_ROWS)                := L_USAGE;
      A_USAGE_DOC(L_FETCHED_ROWS)            := L_USAGE_DOC;
      A_EQ_COMPONENT(L_FETCHED_ROWS)         := L_EQ_COMPONENT;
      A_KEEP_CTOLD(L_FETCHED_ROWS)           := L_KEEP_CTOLD;
      A_KEEP_CTOLD_UNIT(L_FETCHED_ROWS)      := L_KEEP_CTOLD_UNIT;
      A_IS_TEMPLATE(L_FETCHED_ROWS)          := L_IS_TEMPLATE;
      A_LOG_HS(L_FETCHED_ROWS)               := L_LOG_HS;
      A_ALLOW_MODIFY(L_FETCHED_ROWS)         := L_ALLOW_MODIFY;
      A_ACTIVE(L_FETCHED_ROWS)               := L_ACTIVE;
      A_CA_WARN_LEVEL(L_FETCHED_ROWS)        := L_CA_WARN_LEVEL;
      A_SS(L_FETCHED_ROWS)                   := L_SS;
      A_LC(L_FETCHED_ROWS)                   := L_LC;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQ_CURSOR);
      END IF;

   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_EQ_CURSOR);

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
              'GetEquipment', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (L_EQ_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_EQ_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETEQUIPMENT;

FUNCTION SAVEEQUIPMENT
(A_EQ                      IN      VARCHAR2,                     
 A_LAB                     IN      VARCHAR2,                     
 A_DESCRIPTION             IN      VARCHAR2,                     
 A_SERIAL_NO               IN      VARCHAR2,                     
 A_SUPPLIER                IN      VARCHAR2,                     
 A_LOCATION                IN      VARCHAR2,                     
 A_INVEST_COST             IN      NUMBER,                       
 A_INVEST_UNIT             IN      VARCHAR2,                     
 A_USAGE_COST              IN      NUMBER,                       
 A_USAGE_UNIT              IN      VARCHAR2,                     
 A_INSTALL_DATE            IN      DATE,                         
 A_IN_SERVICE_DATE         IN      DATE,                         
 A_ACCESSORIES             IN      VARCHAR2,                     
 A_OPERATION               IN      VARCHAR2,                     
 A_OPERATION_DOC           IN      VARCHAR2,                     
 A_USAGE                   IN      VARCHAR2,                     
 A_USAGE_DOC               IN      VARCHAR2,                     
 A_EQ_COMPONENT            IN      CHAR,                         
 A_KEEP_CTOLD              IN      NUMBER,                       
 A_KEEP_CTOLD_UNIT         IN      VARCHAR2,                     
 A_IS_TEMPLATE             IN      CHAR,                         
 A_LOG_HS                  IN      CHAR,                         
 A_CA_WARN_LEVEL           IN      CHAR,                         
 A_LC                      IN      VARCHAR2,                     
 A_MODIFY_REASON           IN      VARCHAR2)                     
RETURN NUMBER IS

A_VERSION               VARCHAR2(20);
L_LC                    VARCHAR2(2);
L_LC_VERSION            VARCHAR2(20);
L_SS                    VARCHAR2(2);
L_LOG_HS                CHAR(1);
L_CA_WARN_LEVEL         CHAR(1);
L_ALLOW_MODIFY          CHAR(1);
L_ACTIVE                CHAR(1);
L_INSERT                BOOLEAN;

BEGIN
   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_LAB, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_IS_TEMPLATE, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_TEMPLATE;
      RAISE STPERROR;
   END IF;

   IF NVL(A_LOG_HS, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_LOGHS;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIEQP.GETEQAUTHORISATION(A_EQ, A_LAB, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE = UNAPIGEN.DBERR_NOOBJECT THEN
      L_INSERT := TRUE;
   ELSIF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
      L_INSERT := FALSE;
   ELSE
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   IF L_INSERT THEN                   
      IF NVL(A_LC, ' ') <> ' ' THEN
         L_LC := A_LC;
      END IF;
      INSERT INTO UTEQ (EQ, LAB, VERSION, VERSION_IS_CURRENT, EFFECTIVE_FROM, EFFECTIVE_FROM_TZ, 
                   EFFECTIVE_TILL, EFFECTIVE_TILL_TZ, DESCRIPTION, 
                        SERIAL_NO, SUPPLIER, LOCATION,
                        INVEST_COST, INVEST_UNIT, USAGE_COST, USAGE_UNIT, INSTALL_DATE, INSTALL_DATE_TZ,
                        IN_SERVICE_DATE, IN_SERVICE_DATE_TZ, ACCESSORIES, OPERATION, OPERATION_DOC, USAGE, USAGE_DOC,
                        EQ_COMPONENT, KEEP_CTOLD, KEEP_CTOLD_UNIT, IS_TEMPLATE, CA_WARN_LEVEL, LOG_HS,
                        ALLOW_MODIFY, ACTIVE, LC, LC_VERSION)
      VALUES (A_EQ, A_LAB, A_VERSION, '1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL, NULL, A_DESCRIPTION, 
              A_SERIAL_NO, A_SUPPLIER, A_LOCATION,
              A_INVEST_COST, A_INVEST_UNIT, A_USAGE_COST, A_USAGE_UNIT,
              TO_TIMESTAMP_TZ(A_INSTALL_DATE), TO_TIMESTAMP_TZ(A_INSTALL_DATE), TO_TIMESTAMP_TZ(A_IN_SERVICE_DATE), TO_TIMESTAMP_TZ(A_IN_SERVICE_DATE), A_ACCESSORIES,
              A_OPERATION, A_OPERATION_DOC, A_USAGE, A_USAGE_DOC,
              A_EQ_COMPONENT, A_KEEP_CTOLD, A_KEEP_CTOLD_UNIT,
              A_IS_TEMPLATE, A_CA_WARN_LEVEL, A_LOG_HS, '#', L_ACTIVE, L_LC, L_LC_VERSION);
      L_EVENT_TP := 'ObjectCreated';
   ELSE                                
      UPDATE UTEQ
         SET DESCRIPTION              = A_DESCRIPTION,
             SERIAL_NO                = A_SERIAL_NO,
             SUPPLIER                 = A_SUPPLIER,
             LOCATION                 = A_LOCATION,
             INVEST_COST              = A_INVEST_COST,
             INVEST_UNIT              = A_INVEST_UNIT,
             USAGE_COST               = A_USAGE_COST,
             USAGE_UNIT               = A_USAGE_UNIT,
             INSTALL_DATE             = TO_TIMESTAMP_TZ(A_INSTALL_DATE),
             INSTALL_DATE_TZ          = DECODE(TO_TIMESTAMP_TZ(A_INSTALL_DATE), INSTALL_DATE_TZ, INSTALL_DATE_TZ, TO_TIMESTAMP_TZ(A_INSTALL_DATE)),
             IN_SERVICE_DATE          = TO_TIMESTAMP_TZ(A_IN_SERVICE_DATE),
             IN_SERVICE_DATE_TZ       = DECODE(TO_TIMESTAMP_TZ(A_IN_SERVICE_DATE), IN_SERVICE_DATE_TZ, IN_SERVICE_DATE_TZ, TO_TIMESTAMP_TZ(A_IN_SERVICE_DATE)),
             ACCESSORIES              = A_ACCESSORIES,
             OPERATION                = A_OPERATION,
             OPERATION_DOC            = A_OPERATION_DOC,
             USAGE                    = A_USAGE,
             USAGE_DOC                = A_USAGE_DOC,
             EQ_COMPONENT             = A_EQ_COMPONENT,
             KEEP_CTOLD               = A_KEEP_CTOLD,
             KEEP_CTOLD_UNIT          = A_KEEP_CTOLD_UNIT,
             IS_TEMPLATE              = A_IS_TEMPLATE,
             CA_WARN_LEVEL            = A_CA_WARN_LEVEL,
             LOG_HS                   = A_LOG_HS,
             LC                       = L_LC,
             ALLOW_MODIFY             = '#'
         WHERE VERSION = A_VERSION
           AND EQ = A_EQ
           AND LAB = A_LAB;
         L_EVENT_TP := 'ObjectUpdated';
   END IF;

   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'lab='||A_LAB||'#version='||A_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveEquipment', UNAPIGEN.P_EVMGR_NAME, 'eq', A_EQ, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF NVL(L_LOG_HS, ' ') <> A_LOG_HS THEN
      IF A_LOG_HS = '1' THEN
         INSERT INTO UTEQHS(EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, 
                            WHY, TR_SEQ, EV_SEQ)
         VALUES(A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched ON', 
                'Audit trail is turned on.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      ELSE
         INSERT INTO UTEQHS(EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, 
                            WHY, TR_SEQ, EV_SEQ)
         VALUES(A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched OFF', 
                'Audit trail is turned off.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   END IF;

   IF NVL(L_LOG_HS, ' ') = '1' THEN
      IF L_EVENT_TP = 'ObjectCreated' THEN
         INSERT INTO UTEQHS (EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, 
                             WHY, TR_SEQ, EV_SEQ)
         VALUES (A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                 'equipment "'||A_EQ||'" is created.', 
                 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      ELSE
         INSERT INTO UTEQHS (EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,  LOGDATE_TZ, 
                             WHY, TR_SEQ, EV_SEQ)
         VALUES (A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                 'equipment "'||A_EQ||'" is updated.', 
                 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   ELSE
      
      
      IF L_EVENT_TP = 'ObjectCreated' THEN
         INSERT INTO UTEQHS (EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, 
                             WHY, TR_SEQ, EV_SEQ)
         VALUES (A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                 'equipment "'||A_EQ||'" is created.', 
                 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
        UNAPIGEN.LOGERROR('SaveEquipment', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR, 'SaveEquipment'));
END SAVEEQUIPMENT;

FUNCTION DELETEEQUIPMENT
(A_EQ                      IN      VARCHAR2,                     
 A_LAB                     IN      VARCHAR2,                     
 A_MODIFY_REASON           IN      VARCHAR2)                     
RETURN NUMBER IS

A_VERSION      VARCHAR2(20);
L_ALLOW_MODIFY CHAR(1);
L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ACTIVE       CHAR(1);

BEGIN

   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EQ, ' ')= ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_LAB, ' ')= ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIEQP.GETEQAUTHORISATION(A_EQ, A_LAB, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   IF L_ACTIVE='1' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OPACTIVE;
      RAISE STPERROR;
   END IF;

   
   IF UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTALLOWEDIN21CFR11;
      RAISE STPERROR;
   END IF;

   DELETE FROM UTEQAU
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

   DELETE FROM UTEQHS
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;
     
   DELETE FROM UTEQ
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;
     
   DELETE FROM UTEQCT
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

   
   DELETE /*+ RULE */ FROM UTCHDP DP
   WHERE (CH, DATAPOINT_LINK)
      IN (SELECT B.CH, B.DATAPOINT_LINK
          FROM UTCH A, UTCHDP B
          WHERE B.DATAPOINT_LINK LIKE A_EQ ||  '#' || A_LAB || '#%'
          AND B.CH = A.CH
          AND A.ALLOW_MODIFY IN ('1', '#')
          AND NVL(UNAPIAUT.SQLGETCHALLOWMODIFY(B.CH),'0')='1'); 

   DELETE FROM UTEQCTOLD
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

   DELETE FROM UTEQMR
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

   DELETE FROM UTEQCA
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

   DELETE FROM UTEQCALOG
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

   DELETE FROM UTEQCD
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

   DELETE FROM UTEQCYCT
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

   DELETE FROM UTEQTYPE
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

   DELETE FROM UTEVTIMED
   WHERE OBJECT_TP = 'eq' 
     AND OBJECT_ID = A_EQ 
     AND INSTR(EV_DETAILS,'lab='||A_LAB||'#version='||A_VERSION) <> 0;

   DELETE FROM UTEVRULESDELAYED
   WHERE OBJECT_TP = 'eq' 
     AND OBJECT_ID = A_EQ 
     AND INSTR(EV_DETAILS,'lab='||A_LAB||'#version='||A_VERSION) <> 0;

   L_EVENT_TP := 'ObjectDeleted';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'lab='||A_LAB||'#version='||A_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('DeleteEquipment', UNAPIGEN.P_EVMGR_NAME, 'eq', A_EQ, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
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
        UNAPIGEN.LOGERROR('DeleteEquipment', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'DeleteEquipment'));
END DELETEEQUIPMENT;

FUNCTION GETEQCONSTANTS
(A_EQ                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_LAB                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_CT_NAME                 OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_CA                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_VALUE_S                 OUT     UNAPIGEN.VC40_TABLE_TYPE,     
 A_VALUE_F                 OUT     UNAPIGEN.FLOAT_TABLE_TYPE,    
 A_FORMAT                  OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_UNIT                    OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_NR_OF_ROWS              IN OUT  NUMBER,                       
 A_WHERE_CLAUSE            IN      VARCHAR2)                     
RETURN NUMBER IS

L_EQ                  VARCHAR2(20);
L_LAB                 VARCHAR2(20);
L_CA                  VARCHAR2(20);
L_CT_NAME             VARCHAR2(20);
L_VALUE_S             VARCHAR2(40);
L_VALUE_F             NUMBER;
L_FORMAT              VARCHAR2(20);
L_UNIT                VARCHAR2(20);
L_EQCT_CURSOR         INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY ct.seq'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uveq eq WHERE eq.version_is_current = ''1'' '||
                        'AND ct.version = eq.version '||
                        'AND ct.eq = eq.eq '||
                        'AND ct.eq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' AND eq.lab=''-'' ORDER BY ct.seq'; 
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_SQL_STRING := 'SELECT ct.eq, ct.lab, ct.ca, ct.ct_name, ct.value_s, ct.value_f, '||
                   'ct.format, ct.unit '||
                   'FROM dd' || UNAPIGEN.P_DD || '.uveqct ct ' || L_WHERE_CLAUSE;

   L_EQCT_CURSOR := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(L_EQCT_CURSOR,L_SQL_STRING,DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_EQCT_CURSOR, 1, L_EQ, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCT_CURSOR, 2, L_LAB, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCT_CURSOR, 3, L_CA, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCT_CURSOR, 4, L_CT_NAME, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCT_CURSOR, 5, L_VALUE_S, 40);
   DBMS_SQL.DEFINE_COLUMN(L_EQCT_CURSOR, 6, L_VALUE_F);
   DBMS_SQL.DEFINE_COLUMN(L_EQCT_CURSOR, 7, L_FORMAT, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCT_CURSOR, 8, L_UNIT, 20);
   L_RESULT := DBMS_SQL.EXECUTE(L_EQCT_CURSOR);

   L_FETCHED_ROWS := 0;
   L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQCT_CURSOR);

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_EQCT_CURSOR, 1, L_EQ);
      DBMS_SQL.COLUMN_VALUE(L_EQCT_CURSOR, 2, L_LAB);
      DBMS_SQL.COLUMN_VALUE(L_EQCT_CURSOR, 3, L_CA);
      DBMS_SQL.COLUMN_VALUE(L_EQCT_CURSOR, 4, L_CT_NAME);
      DBMS_SQL.COLUMN_VALUE(L_EQCT_CURSOR, 5, L_VALUE_S);
      DBMS_SQL.COLUMN_VALUE(L_EQCT_CURSOR, 6, L_VALUE_F);
      DBMS_SQL.COLUMN_VALUE(L_EQCT_CURSOR, 7, L_FORMAT);
      DBMS_SQL.COLUMN_VALUE(L_EQCT_CURSOR, 8, L_UNIT);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_EQ(L_FETCHED_ROWS)      := L_EQ;
      A_LAB(L_FETCHED_ROWS)     := L_LAB;
      A_CA(L_FETCHED_ROWS)      := L_CA;
      A_CT_NAME(L_FETCHED_ROWS) := L_CT_NAME;
      A_VALUE_S(L_FETCHED_ROWS) := L_VALUE_S;
      A_VALUE_F(L_FETCHED_ROWS) := L_VALUE_F;
      A_FORMAT(L_FETCHED_ROWS)  := L_FORMAT;
      A_UNIT(L_FETCHED_ROWS)    := L_UNIT;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQCT_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_EQCT_CURSOR);

   
   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF ;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'GetEqConstants', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   IF DBMS_SQL.IS_OPEN(L_EQCT_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_EQCT_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETEQCONSTANTS;


PROCEDURE SAVEEQCTWHEREUSEDASMECELLINPUT
(A_EQ                      IN      VARCHAR2,                    
 A_LAB                     IN      VARCHAR2,                    
 A_VERSION                 IN      VARCHAR2,                    
 A_CT_NAME                 IN      VARCHAR2,                    
 A_VALUE_S                 IN      VARCHAR2,                    
 A_VALUE_F                 IN      FLOAT,                       
 A_UNIT                    IN      VARCHAR2,                    
 A_FORMAT                  IN      VARCHAR2,                    
 A_HS_DETAILS_SEQ_NR       IN OUT  NUMBER)                      
IS

CURSOR L_CELL_OLD_CURSOR(C_SC   VARCHAR2, 
                         C_PG   VARCHAR2, C_PGNODE NUMBER,
                         C_PA   VARCHAR2, C_PANODE NUMBER,
                         C_ME   VARCHAR2, C_MENODE NUMBER,
                         C_CELL VARCHAR2) IS
   SELECT VALUE_S, VALUE_F, UNIT, FORMAT
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

L_OLD_CELL_VALUE_F       FLOAT;
L_OLD_CELL_VALUE_S       VARCHAR2(40);
L_OLD_CELL_UNIT          VARCHAR2(20);
L_OLD_CELL_FORMAT        VARCHAR2(40);
L_CELL_VALUE_F           FLOAT;
L_CELL_VALUE_S           VARCHAR2(40);
L_CELL_UNIT              VARCHAR2(20);
L_CELL_FORMAT            VARCHAR2(40);
L_ME_LOG_HS_DETAILS      CHAR(1);
L_ME_ALLOW_MODIFY        CHAR(1);

TYPE DYNCURTYP           IS REF CURSOR;   
L_DYNCUR_EQCT            DYNCURTYP ;
L_SC                     VARCHAR2(20);
L_PG                     VARCHAR2(20);
L_PGNODE                 NUMBER ;
L_PA                     VARCHAR2(20);
L_PANODE                 NUMBER ;
L_ME                     VARCHAR2(20);
L_MENODE                 NUMBER ;
L_MT_VERSION             VARCHAR2(20);
L_CELL                   VARCHAR2(20);
L_REANALYSIS             NUMBER ;
L_ALLOW_MODIFY           CHAR(1);

BEGIN

   A_HS_DETAILS_SEQ_NR := NVL(A_HS_DETAILS_SEQ_NR, 0);
   
   
   
   
   
   
   

   IF NOT P_USE_MEGKINEXECUTION4EQCTE THEN   
      L_SQL_STRING := 'SELECT a.sc, a.pg, a.pgnode, a.pa, a.panode, a.me, a.menode, b.mt_version, a.cell,  '
                  || '      NVL(b.allow_modify, ''#'') allow_modify, b.reanalysis reanalysis '
                  || 'FROM  utscmecell a, utscme b, utscmecellinput c '
                  || 'WHERE c.sc = b.sc '
                  || '  AND c.pg = b.pg '
                  || '   AND c.pgnode = b.pgnode '
                  || '  AND c.pa = b.pa '
                  || '  AND c.panode = b.panode '
                  || '  AND c.me = b.me '
                  || '  AND c.menode = b.menode '
                  || '  AND NVL(b.allow_modify, ''#'') <> ''0'' '
                  || '  AND c.input_tp = ''eq'' '
                  || '  AND c.input_source = :a_ct_name '
                  || '  AND b.exec_end_date IS NULL '
                  || '  AND c.sc = a.sc '
                  || '  AND c.pg = a.pg '
                  || '  AND c.pgnode = a.pgnode '
                  || '  AND c.pa = a.pa '
                  || '  AND c.panode = a.panode '
                  || '  AND c.me = a.me '
                  || '  AND c.menode = a.menode '
                  || '  AND c.cell = a.cell '
                  || '  AND UNAPIGEN.ValidateVersion(''eq'', a.eq, a.eq_version) = :a_version '
                  || '  AND a.eq = :a_eq '
                  || '  AND b.lab = :a_lab ' ;
      OPEN L_DYNCUR_EQCT FOR L_SQL_STRING USING A_CT_NAME, A_VERSION, A_EQ, A_LAB ;
   ELSE
      L_SQL_STRING := 'WITH active_methods AS '
                  || '     ( SELECT a.sc sc, '
                  || '              a.pg pg, '
                  || '              a.pgnode pgnode, '
                  || '              a.pa pa, '
                  || '              a.panode panode, '
                  || '              a.me me, '
                  || '              a.menode menode, '
                  || '              a.mt_version mt_version, '
                  || '              NVL( a.allow_modify, ''#'') allow_modify, '
                  || '              a.reanalysis reanalysis, '
                  || '              b.cell cell '
                  || '        FROM utscmegkinexecution c, '
                  || '             utscmecell b, '
                  || '             utscme a '
                  || '       WHERE UNAPIGEN.ValidateVersion(''eq'', b.eq, b.eq_version ) = :a_version '
                  || '         AND b.eq = :a_eq '
                  || '         and b.sc = a.sc '
                  || '         AND b.pg = a.pg '
                  || '         AND b.pgnode = a.pgnode '
                  || '         AND b.pa = a.pa '
                  || '         AND b.panode = a.panode '
                  || '         AND b.me = a.me '
                  || '         AND b.menode = a.menode '
                  || '         AND NVL( a.allow_modify,''#'' ) <> ''0'' '
                  || '         AND a.lab = :a_lab '
                  || '         and c.inexecution = ''1'' '
                  || '         and a.sc = c.sc '
                  || '         and a.pg = c.pg '
                  || '         and a.pgnode = c.pgnode '
                  || '         and a.pa = c.pa '
                  || '         and a.panode = c.panode '
                  || '         and a.me = c.me '
                  || '         and a.menode =  c.menode) '
                  || 'SELECT a.sc, a.pg, a.pgnode, a.pa, a.panode, a.me, a.menode, a.mt_version, a.cell,  '
                  || '         a.allow_modify, a.reanalysis reanalysis '
                  || '  FROM active_methods a, '
                  || '       utscmecellinput c '
                  || ' WHERE a.sc = c.sc '
                  || '   AND a.pg = c.pg '
                  || '   AND a.pgnode = c.pgnode '
                  || '   AND a.pa = c.pa '
                  || '   AND a.panode = c.panode '
                  || '   AND a.me = c.me '
                  || '   AND a.menode = c.menode '
                  || '   and c.cell = a.cell '
                  || '   AND c.input_tp = ''eq'' '
                  || '   AND c.input_source = :a_ct_name' ;
      OPEN L_DYNCUR_EQCT FOR L_SQL_STRING USING A_VERSION, A_EQ, A_LAB, A_CT_NAME ;
   END IF ;

   LOOP 
      FETCH L_DYNCUR_EQCT INTO L_SC, L_PG, L_PGNODE, L_PA, L_PANODE, 
                               L_ME, L_MENODE, L_MT_VERSION, L_CELL, L_ALLOW_MODIFY, L_REANALYSIS ; 
      EXIT WHEN L_DYNCUR_EQCT%NOTFOUND ;
     
      IF L_ALLOW_MODIFY = '#' THEN
         L_ME_ALLOW_MODIFY := UNAPIAUT.SQLGETSCMEALLOWMODIFY(L_SC, 
                                                         L_PG, L_PGNODE, 
                                                         L_PA, L_PANODE, 
                                                         L_ME, L_MENODE, 
                                                         L_REANALYSIS) ;
      ELSE 
         L_ME_ALLOW_MODIFY := L_ALLOW_MODIFY ;
      END IF ;

      IF L_ME_ALLOW_MODIFY = '1' THEN
         
         
         
         OPEN L_CELL_OLD_CURSOR(L_SC, 
                                L_PG, L_PGNODE,
                                L_PA, L_PANODE,
                                L_ME, L_MENODE,
                                L_CELL);
         FETCH L_CELL_OLD_CURSOR INTO L_OLD_CELL_VALUE_S, L_OLD_CELL_VALUE_F, 
                                      L_OLD_CELL_UNIT, L_OLD_CELL_FORMAT;
         IF L_CELL_OLD_CURSOR%NOTFOUND THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
            RAISE STPERROR;
         END IF;
         CLOSE L_CELL_OLD_CURSOR;
         L_CELL_UNIT    := L_OLD_CELL_UNIT;
         L_CELL_FORMAT  := L_OLD_CELL_FORMAT;

         
         
         
         L_RET_CODE := UNAPIGEN.TRANSFORMRESULT(A_VALUE_S,
                                                A_VALUE_F,      
                                                A_UNIT,
                                                A_FORMAT,    
                                                L_CELL_VALUE_S,    
                                                L_CELL_VALUE_F,      
                                                L_CELL_UNIT,    
                                                L_CELL_FORMAT);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;

         UPDATE UTSCMECELL
         SET VALUE_F = L_CELL_VALUE_F,
             VALUE_S = L_CELL_VALUE_S,
             UNIT = L_CELL_UNIT,
             FORMAT = L_CELL_FORMAT
          WHERE SC = L_SC
            AND PG = L_PG
            AND PGNODE = L_PGNODE
            AND PA = L_PA
            AND PANODE = L_PANODE
            AND ME = L_ME
            AND MENODE = L_MENODE
            AND CELL = L_CELL;
         IF SQL%ROWCOUNT = 0 THEN
            RAISE NO_DATA_FOUND;
         END IF;

         L_EV_SEQ_NR := -1;
         L_EV_DETAILS := 'mt_version='|| L_MT_VERSION ||
                         '#sc=' || L_SC ||
                         '#pg=' || L_PG ||
                         '#pgnode=' || TO_CHAR(L_PGNODE) ||
                         '#pa=' || L_PA ||
                         '#panode=' || TO_CHAR(L_PANODE) ||
                         '#menode=' || TO_CHAR(L_MENODE) ;

         L_RESULT := UNAPIEV.INSERTEVENT('SaveEqConstants', UNAPIGEN.P_EVMGR_NAME, 'me',
                                         L_ME, '', '', '', 
                                         'EvaluateMeDetails', L_EV_DETAILS, L_EV_SEQ_NR);
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RESULT;
            RAISE STPERROR;
         END IF;

         OPEN L_SCME_CURSOR(L_SC, L_PG, L_PGNODE, L_PA, L_PANODE, L_ME, L_MENODE);
         FETCH L_SCME_CURSOR INTO L_ME_LOG_HS_DETAILS;
         IF L_SCME_CURSOR%NOTFOUND THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
            RAISE STPERROR;
         END IF;
         CLOSE L_SCME_CURSOR;

         IF L_ME_LOG_HS_DETAILS = '1' THEN
            IF NVL((L_OLD_CELL_VALUE_S <> L_CELL_VALUE_S), TRUE) AND NOT(L_OLD_CELL_VALUE_S IS NULL AND L_CELL_VALUE_S IS NULL) THEN 
               A_HS_DETAILS_SEQ_NR := A_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                           TR_SEQ, EV_SEQ, SEQ, DETAILS)
               VALUES(L_SC, L_PG, L_PGNODE, L_PA, L_PANODE, L_ME, 
                      L_MENODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, A_HS_DETAILS_SEQ_NR,
                      'method cell "'||L_CELL||'" is updated: property <value_s> changed value from "'||L_OLD_CELL_VALUE_S||'" to "'||L_CELL_VALUE_S||'".');
            END IF;
            IF NVL((L_OLD_CELL_VALUE_F <> L_CELL_VALUE_F), TRUE) AND NOT(L_OLD_CELL_VALUE_F IS NULL AND L_CELL_VALUE_F IS NULL) THEN 
               A_HS_DETAILS_SEQ_NR := A_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                           TR_SEQ, EV_SEQ, SEQ, DETAILS)
               VALUES(L_SC, L_PG, L_PGNODE, L_PA, L_PANODE, L_ME, 
                      L_MENODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, A_HS_DETAILS_SEQ_NR,
                      'method cell "'||L_CELL||'" is updated: property <value_f> changed value from "'||TO_CHAR(L_OLD_CELL_VALUE_F)||'" to "'||TO_CHAR(L_CELL_VALUE_F)||'".');
            END IF;
            IF NVL((L_OLD_CELL_UNIT <> L_CELL_UNIT), TRUE) AND NOT(L_OLD_CELL_UNIT IS NULL AND L_CELL_UNIT IS NULL) THEN 
               A_HS_DETAILS_SEQ_NR := A_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                           TR_SEQ, EV_SEQ, SEQ, DETAILS)
               VALUES(L_SC, L_PG, L_PGNODE, L_PA, L_PANODE, L_ME, 
                      L_MENODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, A_HS_DETAILS_SEQ_NR,
                      'method cell "'||L_CELL||'" is updated: property <unit> changed value from "'||L_OLD_CELL_UNIT||'" to "'||L_CELL_UNIT||'".');
            END IF;
            IF NVL((L_OLD_CELL_FORMAT <> L_CELL_FORMAT), TRUE) AND NOT(L_OLD_CELL_FORMAT IS NULL AND L_CELL_FORMAT IS NULL) THEN 
               A_HS_DETAILS_SEQ_NR := A_HS_DETAILS_SEQ_NR + 1;
               INSERT INTO UTSCMEHSDETAILS(SC, PG, PGNODE, PA, PANODE, ME, MENODE, 
                                           TR_SEQ, EV_SEQ, SEQ, DETAILS)
               VALUES(L_SC, L_PG, L_PGNODE, L_PA, L_PANODE, L_ME, 
                      L_MENODE, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, A_HS_DETAILS_SEQ_NR,
                      'method cell "'||L_CELL||'" is updated: property <format> changed value from "'||L_OLD_CELL_FORMAT||'" to "'||L_CELL_FORMAT||'".');
            END IF;
         END IF;
      END IF;
   END LOOP;
   CLOSE L_DYNCUR_EQCT ; 
EXCEPTION
WHEN OTHERS THEN
   
   
   IF L_SCME_CURSOR%ISOPEN THEN
      CLOSE L_SCME_CURSOR;
   END IF;   
   IF L_CELL_OLD_CURSOR%ISOPEN THEN
      CLOSE L_CELL_OLD_CURSOR;
   END IF;
   IF L_DYNCUR_EQCT%ISOPEN THEN
      CLOSE L_DYNCUR_EQCT;
   END IF;

   RAISE;
END SAVEEQCTWHEREUSEDASMECELLINPUT;


PROCEDURE SAVEEQCTINCHART
(A_EQ                      IN      VARCHAR2,                    
 A_LAB                     IN      VARCHAR2,                    
 A_VERSION                 IN      VARCHAR2,                    
 A_CT_NAME                 IN      VARCHAR2,                    
 A_VALUE_S                 IN      VARCHAR2,                    
 A_VALUE_F                 IN      FLOAT,                       
 A_UNIT                    IN      VARCHAR2,                    
 A_FORMAT                  IN      VARCHAR2,                    
 A_CURRENT_TIMESTAMP                 IN      DATE)                        
IS

L_CH                     VARCHAR2(20);
L_DATAPOINT_SEQ          NUMBER;
L_MEASURE_SEQ            NUMBER;
L_CH_CONTEXT_KEY         VARCHAR2(255);
L_DATAPOINT_LINK         VARCHAR2(255);
L_NEW_CHART              BOOLEAN;
L_COUNTER                NUMBER;
L_CH_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_DATAPOINT_SEQ_TAB      UNAPIGEN.NUM_TABLE_TYPE;
L_MEASURE_SEQ_TAB        UNAPIGEN.NUM_TABLE_TYPE;
L_X_VALUE_F_TAB          UNAPIGEN.FLOAT_TABLE_TYPE;
L_X_VALUE_S_TAB          UNAPIGEN.VC40_TABLE_TYPE;
L_X_VALUE_D_TAB          UNAPIGEN.DATE_TABLE_TYPE;
L_DATAPOINT_VALUE_F_TAB  UNAPIGEN.FLOAT_TABLE_TYPE;
L_DATAPOINT_VALUE_S_TAB  UNAPIGEN.VC40_TABLE_TYPE;
L_DATAPOINT_LABEL_TAB    UNAPIGEN.VC255_TABLE_TYPE;
L_DATAPOINT_MARKER_TAB   UNAPIGEN.VC20_TABLE_TYPE;
L_DATAPOINT_COLOUR_TAB   UNAPIGEN.VC20_TABLE_TYPE;
L_DATAPOINT_LINK_TAB     UNAPIGEN.VC255_TABLE_TYPE;
L_Z_VALUE_F_TAB          UNAPIGEN.FLOAT_TABLE_TYPE;
L_Z_VALUE_S_TAB          UNAPIGEN.VC40_TABLE_TYPE;
L_DATAPOINT_RANGE_TAB    UNAPIGEN.NUM_TABLE_TYPE;
L_SQC_AVG_TAB            UNAPIGEN.FLOAT_TABLE_TYPE;
L_SQC_AVG_RANGE_TAB      UNAPIGEN.FLOAT_TABLE_TYPE;
L_SQC_SIGMA_TAB          UNAPIGEN.FLOAT_TABLE_TYPE;
L_SQC_SIGMA_RANGE_TAB    UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC1_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC2_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC3_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC4_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC5_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC6_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC7_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC8_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC9_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC10_TAB             UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC11_TAB             UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC12_TAB             UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC13_TAB             UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC14_TAB             UNAPIGEN.FLOAT_TABLE_TYPE;
L_SPEC15_TAB             UNAPIGEN.FLOAT_TABLE_TYPE;
L_ACTIVE_TAB             UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE1_VIOLATED_TAB     UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE2_VIOLATED_TAB     UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE3_VIOLATED_TAB     UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE4_VIOLATED_TAB     UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE5_VIOLATED_TAB     UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE6_VIOLATED_TAB     UNAPIGEN.CHAR1_TABLE_TYPE;
L_RULE7_VIOLATED_TAB     UNAPIGEN.CHAR1_TABLE_TYPE;

L_NR_OF_ROWS             NUMBER;
L_LAST_COMMENT           VARCHAR2(255);
L_X_LABEL                VARCHAR2(60);
L_Y_AXIS_UNIT            VARCHAR2(20);
L_Y_AXIS_FORMAT          VARCHAR2(20);

L_CHART_OK               BOOLEAN;
L_CH_TITLE               VARCHAR2(255);
L_CH_X_AXIS_TITLE        VARCHAR2(255);
L_CH_Y_AXIS_TITLE        VARCHAR2(255);
L_OBJECT_KEY             VARCHAR2(255);
L_NR_OF_ROWS_IN          NUMBER;
L_NR_OF_ROWS_OUT         NUMBER;
L_WHERE_CLAUSE           VARCHAR2(511);
L_NEXT_ROWS              NUMBER;
L_EQ_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
L_LAB_TAB                UNAPIGEN.VC20_TABLE_TYPE;
L_LAST_COMMENT_TAB       UNAPIGEN.VC255_TABLE_TYPE;
 
CURSOR C_CY (A_EQ         VARCHAR2, 
             A_LAB        VARCHAR2,
             A_EQ_VERSION VARCHAR2,
             A_CT_NAME    VARCHAR2) IS
   SELECT CY, UNAPIGEN.VALIDATEVERSION('cy', CY, CY_VERSION) CY_VERSION
   FROM UTEQCYCT A
   WHERE NVL(CT_NAME, A_CT_NAME) = A_CT_NAME 
     AND NVL(EQ, A_EQ) =A_EQ 
     AND NVL(LAB, A_LAB) =A_LAB
     AND CY IN (SELECT CY FROM UTCY WHERE VERSION_IS_CURRENT = '1') 
   ORDER BY CY, CY_VERSION;

CURSOR C_X_LABEL(A_CY IN VARCHAR2) IS
   SELECT X_LABEL 
   FROM UTCY 
   WHERE CY = A_CY;

CURSOR C_Y_AXIS_UNIT(A_CH IN VARCHAR2) IS
   SELECT Y_AXIS_UNIT
   FROM UTCH 
   WHERE CH = A_CH;
   
CURSOR L_CH_EXISTS_CURSOR(C_CH VARCHAR2) IS
   SELECT CH 
   FROM UTCH
   WHERE CH = C_CH;
   
CURSOR C_CH_TITLES ( C_CH IN VARCHAR2) IS
   SELECT CHART_TITLE, X_AXIS_TITLE, Y_AXIS_TITLE
   FROM UTCH
   WHERE CH = C_CH;  

BEGIN

   L_DATAPOINT_LINK  := A_EQ || '#' || A_LAB || '#' || A_VERSION || '#' || A_CT_NAME || '#' || TO_CHAR(A_CURRENT_TIMESTAMP, 'DD/MM/YYYY HH24:MI:SS');  
   FOR LC_CY IN C_CY (A_EQ, A_LAB, A_VERSION, A_CT_NAME) LOOP
      
      L_CH_CONTEXT_KEY  := A_EQ || '#' || A_LAB || '#' || A_CT_NAME;  
      
      L_RET_CODE := UNSQCASSIGN.SQCASSIGN(LC_CY.CY, L_CH_CONTEXT_KEY, L_DATAPOINT_LINK,
                                          L_CH, L_DATAPOINT_SEQ, L_MEASURE_SEQ);
      IF (L_RET_CODE = UNAPIGEN.DBERR_SUCCESS) AND (NVL(L_CH, ' ') <> ' ') THEN
         
         L_WHERE_CLAUSE := 'where eq='''||A_EQ||
                           ''' and lab='''|| A_LAB || 
                           ''' and version='''|| A_VERSION || '''';
         L_NEXT_ROWS := 0;
         L_NR_OF_ROWS_OUT := 100;
         L_RET_CODE := UNAPIEQP.GETEQCOMMENT(L_EQ_TAB,
                                             L_LAB_TAB,
                                             L_LAST_COMMENT_TAB,
                                             L_NR_OF_ROWS_OUT,
                                             L_WHERE_CLAUSE,
                                             L_NEXT_ROWS);
         IF L_RET_CODE = UNAPIGEN.DBERR_GENFAIL THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
         IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS THEN
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
         IF L_NEW_CHART = TRUE THEN
            L_RET_CODE := UNAPICH.CREATECHART(LC_CY.CY , LC_CY.CY_VERSION, L_CH,
                                              L_CH_CONTEXT_KEY, CURRENT_TIMESTAMP, UNAPIGEN.P_USER, '');
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
               RAISE STPERROR;                  
            ELSE    
               L_CHART_OK := FALSE;     
               OPEN C_CH_TITLES(L_CH);
               FETCH C_CH_TITLES INTO L_CH_TITLE, L_CH_X_AXIS_TITLE, L_CH_Y_AXIS_TITLE;

               IF C_CH_TITLES%FOUND THEN
                L_CHART_OK := TRUE;
               END IF;

               CLOSE C_CH_TITLES;   

               IF L_CHART_OK = TRUE THEN
                  L_OBJECT_KEY :=  A_EQ || '#' || A_LAB || '#' || A_VERSION || '#' || A_CT_NAME ;

                  L_RET_CODE := UNAPIGEN.SUBSTITUTEALLTILDESINTEXT( 'eqct', L_OBJECT_KEY, L_CH_TITLE) ;
                  L_RET_CODE := UNAPIGEN.SUBSTITUTEALLTILDESINTEXT( 'eqct', L_OBJECT_KEY, L_CH_X_AXIS_TITLE) ;
                  L_RET_CODE := UNAPIGEN.SUBSTITUTEALLTILDESINTEXT( 'eqct', L_OBJECT_KEY, L_CH_Y_AXIS_TITLE) ;

                  UPDATE UTCH
                  SET CHART_TITLE  = L_CH_TITLE,
                      X_AXIS_TITLE  = L_CH_X_AXIS_TITLE,
                      Y_AXIS_TITLE  = L_CH_Y_AXIS_TITLE
                  WHERE CH = L_CH;
               END IF;
            END IF;                       
         END IF;

         OPEN C_X_LABEL (LC_CY.CY);
         FETCH C_X_LABEL INTO L_X_LABEL;
         CLOSE C_X_LABEL;

         OPEN C_Y_AXIS_UNIT (L_CH);
         FETCH C_Y_AXIS_UNIT INTO L_Y_AXIS_UNIT;
         CLOSE C_Y_AXIS_UNIT;

         L_X_VALUE_D_TAB(1) := A_CURRENT_TIMESTAMP;
         L_X_VALUE_S_TAB(1) := TO_CHAR(A_CURRENT_TIMESTAMP, UNAPIGEN.P_DATEFORMAT);
         L_X_VALUE_F_TAB(1) := NULL;

         L_RET_CODE := UNAPIGEN.TRANSFORMRESULT(A_VALUE_S,
                                                A_VALUE_F,      
                                                A_UNIT,
                                                A_FORMAT,    
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
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;

         
         L_RET_CODE := UNSQCCALC.SQCCALC(L_CH, L_DATAPOINT_SEQ, L_MEASURE_SEQ);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      END IF;
   END LOOP;
END SAVEEQCTINCHART;

FUNCTION SAVEEQCONSTANTS
(A_EQ                      IN      VARCHAR2,                    
 A_LAB                     IN      VARCHAR2,                    
 A_CT_NAME                 IN      UNAPIGEN.VC20_TABLE_TYPE,    
 A_CA                      IN      UNAPIGEN.VC20_TABLE_TYPE,    
 A_VALUE_S                 IN      UNAPIGEN.VC40_TABLE_TYPE,    
 A_VALUE_F                 IN      UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_FORMAT                  IN      UNAPIGEN.VC20_TABLE_TYPE,    
 A_UNIT                    IN      UNAPIGEN.VC20_TABLE_TYPE,    
 A_NR_OF_ROWS              IN      NUMBER,                      
 A_MODIFY_REASON           IN      VARCHAR2)                    
RETURN NUMBER IS

A_VERSION                VARCHAR2(20);
L_CURRENT_TIMESTAMP                TIMESTAMP WITH TIME ZONE;
L_ALLOW_MODIFY           CHAR(1);
L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_SS                     VARCHAR2(2);
L_LOG_HS                 CHAR(1);
L_ACTIVE                 CHAR(1);
L_HS_DETAILS_SEQ_NR      INTEGER;
L_ORIG_AR_CHECK_MODE     CHAR(1);
L_IGNORED_RET_CODE       INTEGER;

BEGIN

   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_LAB, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   L_HS_DETAILS_SEQ_NR := 0;
   L_RET_CODE := UNAPIEQP.GETEQAUTHORISATION(A_EQ, A_LAB, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   DELETE FROM UTEQCT
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION;

   IF SQL%ROWCOUNT > 0 THEN
      L_EVENT_TP := 'EqConstantsUpdated';
   ELSE
      L_EVENT_TP := 'EqConstantsCreated';
   END IF;

   
   
   
   

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_CT_NAME(L_SEQ_NO) IS NULL THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;

      INSERT INTO UTEQCT(EQ, LAB, VERSION, SEQ, CT_NAME, CA, VALUE_S, VALUE_F, FORMAT, UNIT)
      VALUES(A_EQ, A_LAB, A_VERSION, L_SEQ_NO, A_CT_NAME(L_SEQ_NO), A_CA(L_SEQ_NO), A_VALUE_S(L_SEQ_NO),
             A_VALUE_F(L_SEQ_NO), A_FORMAT(L_SEQ_NO), A_UNIT(L_SEQ_NO));
      INSERT INTO UTEQCTOLD(EQ, LAB, VERSION, SEQ, EXEC_START_DATE, EXEC_START_DATE_TZ, CT_NAME, CA, VALUE_S, VALUE_F, FORMAT, UNIT)
      VALUES(A_EQ, A_LAB, A_VERSION, L_SEQ_NO, L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_CT_NAME(L_SEQ_NO), A_CA(L_SEQ_NO), 
             A_VALUE_S(L_SEQ_NO), A_VALUE_F(L_SEQ_NO), A_FORMAT(L_SEQ_NO), A_UNIT(L_SEQ_NO));

      L_IGNORED_RET_CODE := UNAPIAUT.GETARCHECKMODE(L_ORIG_AR_CHECK_MODE);
      
      L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK('1');
      
      SAVEEQCTWHEREUSEDASMECELLINPUT(A_EQ, A_LAB, A_VERSION, A_CT_NAME(L_SEQ_NO), 
                                     A_VALUE_S(L_SEQ_NO), A_VALUE_F(L_SEQ_NO),      
                                     A_UNIT(L_SEQ_NO), A_FORMAT(L_SEQ_NO), L_HS_DETAILS_SEQ_NR);
      
      SAVEEQCTINCHART(A_EQ, A_LAB, A_VERSION, A_CT_NAME(L_SEQ_NO),
                      A_VALUE_S(L_SEQ_NO), A_VALUE_F(L_SEQ_NO),      
                      A_UNIT(L_SEQ_NO), A_FORMAT(L_SEQ_NO), L_CURRENT_TIMESTAMP);

      
      L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK(L_ORIG_AR_CHECK_MODE);
      
   END LOOP;

   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'lab=' || A_LAB || '#version='||A_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveEqConstants', UNAPIGEN.P_EVMGR_NAME,
                                   'eq', A_EQ, '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   UPDATE UTEQ
   SET ALLOW_MODIFY='#'
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION;

   
   IF NVL(L_LOG_HS, ' ') = '1' THEN
      INSERT INTO UTEQHS (EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,  LOGDATE_TZ,
                          WHY, TR_SEQ, EV_SEQ)
      VALUES (A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'equipment "'||A_EQ||'" constants are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveEqConstants', SQLERRM);
   END IF;
   
   IF L_ORIG_AR_CHECK_MODE IS NOT NULL THEN
      L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK(L_ORIG_AR_CHECK_MODE);
   END IF;   
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveEqConstants'));
END SAVEEQCONSTANTS;

FUNCTION SAVE1EQCONSTANT
(A_EQ                      IN      VARCHAR2,                    
 A_LAB                     IN      VARCHAR2,                    
 A_CT_NAME                 IN      VARCHAR2,                    
 A_CA                      IN      VARCHAR2,                    
 A_VALUE_S                 IN      VARCHAR2,                    
 A_VALUE_F                 IN      NUMBER,                      
 A_FORMAT                  IN      VARCHAR2,                    
 A_UNIT                    IN      VARCHAR2,                    
 A_MODIFY_REASON           IN      VARCHAR2)                    
RETURN NUMBER IS

A_VERSION                VARCHAR2(20);
L_CURRENT_TIMESTAMP                TIMESTAMP WITH TIME ZONE;
L_SEQ                    NUMBER;
L_ALLOW_MODIFY           CHAR(1);
L_LC                     VARCHAR2(2);
L_LC_VERSION             VARCHAR2(20);
L_SS                     VARCHAR2(2);
L_LOG_HS                 CHAR(1);
L_ACTIVE                 CHAR(1);
L_HS_DETAILS_SEQ_NR      INTEGER;
L_ORIG_AR_CHECK_MODE     CHAR(1);
L_IGNORED_RET_CODE       INTEGER;

CURSOR L_EQCT_CURSOR IS
   SELECT SEQ
   FROM UTEQCT
   WHERE VERSION = A_VERSION
     AND LAB = A_LAB
     AND EQ = A_EQ
     AND CT_NAME = A_CT_NAME;

BEGIN

   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EQ, ' ') = ' ' OR
      NVL(A_LAB, ' ') = ' '  OR
      NVL(A_CT_NAME, ' ') = ' '  THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
   L_HS_DETAILS_SEQ_NR := 0;
   L_RET_CODE := UNAPIEQP.GETEQAUTHORISATION(A_EQ, A_LAB, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   
   
   
   
   
   

   UPDATE UTEQ
   SET ALLOW_MODIFY = '#'
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   
   OPEN L_EQCT_CURSOR;
   FETCH L_EQCT_CURSOR
   INTO L_SEQ;
   IF L_EQCT_CURSOR%FOUND THEN
      
      UPDATE UTEQCT
      SET CA = A_CA,
          VALUE_S = A_VALUE_S,
          VALUE_F = A_VALUE_F,
          FORMAT = A_FORMAT,
          UNIT = A_UNIT
      WHERE EQ = A_EQ
        AND LAB = A_LAB
        AND VERSION = A_VERSION
        AND CT_NAME = A_CT_NAME
        AND SEQ = L_SEQ;

      L_EVENT_TP := 'Eq1ConstantUpdated';
   ELSE
      
      SELECT NVL(MAX(SEQ), 0) + 1
      INTO L_SEQ
      FROM UTEQCT
      WHERE EQ = A_EQ
        AND LAB = A_LAB
        AND VERSION = A_VERSION;

      INSERT INTO UTEQCT(EQ, LAB, VERSION, SEQ, CT_NAME, CA, VALUE_S, VALUE_F, FORMAT, UNIT)
      VALUES(A_EQ, A_LAB, A_VERSION, L_SEQ, A_CT_NAME, A_CA, A_VALUE_S, A_VALUE_F, A_FORMAT, A_UNIT);

      L_EVENT_TP := 'Eq1ConstantCreated';
   END IF;
   
   
   INSERT INTO UTEQCTOLD(EQ, LAB, VERSION, SEQ, EXEC_START_DATE, EXEC_START_DATE_TZ, CT_NAME, CA,  VALUE_S, VALUE_F, FORMAT, UNIT)
   VALUES(A_EQ, A_LAB, A_VERSION, L_SEQ, L_CURRENT_TIMESTAMP, L_CURRENT_TIMESTAMP, A_CT_NAME, A_CA, A_VALUE_S,
          A_VALUE_F, A_FORMAT, A_UNIT);

   
   
   
   
   
   
   
   L_IGNORED_RET_CODE := UNAPIAUT.GETARCHECKMODE(L_ORIG_AR_CHECK_MODE);
   
   L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK('1');
   SAVEEQCTWHEREUSEDASMECELLINPUT(A_EQ, A_LAB, A_VERSION, A_CT_NAME, 
                                  A_VALUE_S, A_VALUE_F,      
                                  A_UNIT, A_FORMAT, L_HS_DETAILS_SEQ_NR);
      
   SAVEEQCTINCHART(A_EQ, A_LAB, A_VERSION, A_CT_NAME,
                   A_VALUE_S, A_VALUE_F,      
                   A_UNIT, A_FORMAT, L_CURRENT_TIMESTAMP);

   
   L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK(L_ORIG_AR_CHECK_MODE);

   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'lab=' || A_LAB || '#version=' || A_VERSION || '#ct=' || A_CT_NAME;
   L_RESULT := UNAPIEV.INSERTEVENT('Save1EqConstant', UNAPIGEN.P_EVMGR_NAME,
                                   'eq', A_EQ, '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   
   IF NVL(L_LOG_HS, ' ') = '1' THEN
      INSERT INTO UTEQHS (EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,  LOGDATE_TZ,
                          WHY, TR_SEQ, EV_SEQ)
      VALUES (A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'equipment "'||A_EQ||'" constant "'||A_CT_NAME||'" is updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('Save1EqConstant', SQLERRM);
   END IF;
   IF L_ORIG_AR_CHECK_MODE IS NOT NULL THEN
      L_IGNORED_RET_CODE := UNAPIAUT.DISABLEARCHECK(L_ORIG_AR_CHECK_MODE);
   END IF;   
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'Save1EqConstant'));
END SAVE1EQCONSTANT;

FUNCTION GETOLDEQCONSTANTLIST
(A_EQ                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_LAB                     OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_EXEC_START_DATE         OUT      UNAPIGEN.DATE_TABLE_TYPE,    
 A_CT_NAME                 OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_CA                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_VALUE_S                 OUT      UNAPIGEN.VC40_TABLE_TYPE,    
 A_VALUE_F                 OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_FORMAT                  OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_UNIT                    OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_NR_OF_ROWS              IN OUT   NUMBER,                      
 A_WHERE_CLAUSE            IN       VARCHAR2,                    
 A_NEXT_ROWS               IN       NUMBER)                      
RETURN NUMBER IS

L_EQ                VARCHAR2(20);
L_LAB               VARCHAR2(20);
L_EXEC_START_DATE   TIMESTAMP WITH TIME ZONE;
L_CT_NAME           VARCHAR2(20);
L_VALUE_S           VARCHAR2(20);
L_VALUE_F           NUMBER;
L_CA                VARCHAR2(20);
L_FORMAT            VARCHAR2(20);
L_UNIT              VARCHAR2(20);

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
      IF P_EQ_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_EQ_CURSOR);
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_EQ_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   IF NVL(A_NEXT_ROWS,0) = 0 THEN
      IF P_EQ_CURSOR IS NULL THEN
         
         P_EQ_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;
      
      IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
         L_WHERE_CLAUSE := 'ORDER BY ctold.eq, ctold.lab, ctold.version, ctold.ca, ctold.exec_start_date DESC, ctold.seq'; 
      ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
         L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uveq eq WHERE eq.version_is_current = ''1'' '||
                           'AND ctold.version = eq.version '||
                           'AND ctold.eq = eq.eq '||
                           'AND ctold.lab = eq.lab '||
                           'AND ctold.eq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                           ''' AND eq.lab=''-'' ORDER BY ctold.ca, ctold.exec_start_date DESC, ctold.seq';
      ELSE
         L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
      END IF;

      
      L_SQL_STRING := 'SELECT ctold.eq, ctold.lab, ctold.exec_start_date, ctold.ct_name, ctold.ca, ctold.value_s, '||
                      'ctold.value_f, ctold.format, ctold.unit FROM dd' || 
                      UNAPIGEN.P_DD || '.uveqctold ctold ' || L_WHERE_CLAUSE;

      DBMS_SQL.PARSE(P_EQ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

      
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 1, L_EQ, 20);
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 2, L_LAB, 20);
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 3, L_EXEC_START_DATE);
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 4, L_CT_NAME, 20);
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 5, L_CA, 20);
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 6, L_VALUE_S, 40);
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 7, L_VALUE_F);
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 8, L_FORMAT, 20);
      DBMS_SQL.DEFINE_COLUMN(P_EQ_CURSOR, 9, L_UNIT, 20);

      L_RESULT := DBMS_SQL.EXECUTE(P_EQ_CURSOR);

   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(P_EQ_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 1, L_EQ);
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 2, L_LAB);
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 3, L_EXEC_START_DATE);
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 4, L_CT_NAME);
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 5, L_CA);
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 6, L_VALUE_S);
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 7, L_VALUE_F);
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 8, L_FORMAT);
      DBMS_SQL.COLUMN_VALUE(P_EQ_CURSOR, 9, L_UNIT);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_EQ(L_FETCHED_ROWS)              := L_EQ;
      A_LAB(L_FETCHED_ROWS)             := L_LAB;
      A_EXEC_START_DATE(L_FETCHED_ROWS) := L_EXEC_START_DATE;
      A_CT_NAME(L_FETCHED_ROWS)         := L_CT_NAME;
      A_CA(L_FETCHED_ROWS)              := L_CA;
      A_VALUE_S(L_FETCHED_ROWS)         := L_VALUE_S;
      A_VALUE_F(L_FETCHED_ROWS)         := L_VALUE_F;
      A_FORMAT(L_FETCHED_ROWS)          := L_FORMAT;
      A_UNIT(L_FETCHED_ROWS)            := L_UNIT;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_EQ_CURSOR);
      END IF;
   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
      DBMS_SQL.CLOSE_CURSOR(P_EQ_CURSOR);
      RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_EQ_CURSOR);
      A_NR_OF_ROWS  := L_FETCHED_ROWS;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
              'GetOldEqConstantList', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_EQ_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_EQ_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETOLDEQCONSTANTLIST;

FUNCTION GETEQMEASUREMENTRANGES
(A_EQ                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_LAB                     OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_COMPONENT               OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_L_DETECTION_LIMIT       OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_L_DETERM_LIMIT          OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_H_DETERM_LIMIT          OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_H_DETECTION_LIMIT       OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_UNIT                    OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_NR_OF_ROWS              IN OUT   NUMBER,                      
 A_WHERE_CLAUSE            IN       VARCHAR2)                    
RETURN NUMBER IS

L_EQ                      VARCHAR2(20);
L_LAB                     VARCHAR2(20);
L_COMPONENT               VARCHAR2(20);
L_L_DETECTION_LIMIT       NUMBER;
L_L_DETERM_LIMIT          NUMBER;
L_H_DETERM_LIMIT          NUMBER;
L_H_DETECTION_LIMIT       NUMBER;
L_UNIT                    VARCHAR2(20);

L_EQMR_CURSOR             INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY mr.seq'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uveq eq WHERE eq.version_is_current = ''1'' '||
                        'AND mr.version = eq.version ' ||
                        'AND mr.eq = eq.eq ' ||
                        'AND mr.lab = eq.lab ' ||
                        'AND mr.eq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' AND mr.lab=''-'' ORDER BY mr.seq'; 
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_SQL_STRING := 'SELECT mr.eq, mr.lab, mr.component, mr.l_detection_limit, mr.l_determ_limit, '||
                   'mr.h_determ_limit, mr.h_detection_limit, mr.unit '||
                   'FROM dd' || UNAPIGEN.P_DD || '.uveqmr mr ' || L_WHERE_CLAUSE;

   L_EQMR_CURSOR := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(L_EQMR_CURSOR,L_SQL_STRING,DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_EQMR_CURSOR, 1, L_EQ, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQMR_CURSOR, 2, L_LAB, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQMR_CURSOR, 3, L_COMPONENT, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQMR_CURSOR, 4, L_L_DETECTION_LIMIT);
   DBMS_SQL.DEFINE_COLUMN(L_EQMR_CURSOR, 5, L_L_DETERM_LIMIT);
   DBMS_SQL.DEFINE_COLUMN(L_EQMR_CURSOR, 6, L_H_DETERM_LIMIT);
   DBMS_SQL.DEFINE_COLUMN(L_EQMR_CURSOR, 7, L_H_DETECTION_LIMIT);
   DBMS_SQL.DEFINE_COLUMN(L_EQMR_CURSOR, 8, L_UNIT, 20);

   L_RESULT := DBMS_SQL.EXECUTE(L_EQMR_CURSOR);

   L_FETCHED_ROWS := 0;
   L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQMR_CURSOR);

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_EQMR_CURSOR, 1, L_EQ);
      DBMS_SQL.COLUMN_VALUE(L_EQMR_CURSOR, 2, L_LAB);
      DBMS_SQL.COLUMN_VALUE(L_EQMR_CURSOR, 3, L_COMPONENT);
      DBMS_SQL.COLUMN_VALUE(L_EQMR_CURSOR, 4, L_L_DETECTION_LIMIT);
      DBMS_SQL.COLUMN_VALUE(L_EQMR_CURSOR, 5, L_L_DETERM_LIMIT);
      DBMS_SQL.COLUMN_VALUE(L_EQMR_CURSOR, 6, L_H_DETERM_LIMIT);
      DBMS_SQL.COLUMN_VALUE(L_EQMR_CURSOR, 7, L_H_DETECTION_LIMIT);
      DBMS_SQL.COLUMN_VALUE(L_EQMR_CURSOR, 8, L_UNIT);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_EQ(L_FETCHED_ROWS)                    := L_EQ;
      A_LAB(L_FETCHED_ROWS)                   := L_LAB;
      A_COMPONENT(L_FETCHED_ROWS)             := L_COMPONENT;
      A_L_DETECTION_LIMIT(L_FETCHED_ROWS)     := L_L_DETECTION_LIMIT;
      A_L_DETERM_LIMIT(L_FETCHED_ROWS)        := L_L_DETERM_LIMIT;
      A_H_DETERM_LIMIT(L_FETCHED_ROWS)        := L_H_DETERM_LIMIT;
      A_H_DETECTION_LIMIT(L_FETCHED_ROWS)     := L_H_DETECTION_LIMIT;
      A_UNIT(L_FETCHED_ROWS)                  := L_UNIT;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQMR_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_EQMR_CURSOR);

   
   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF ;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'GetEqMeasurementRanges', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   IF DBMS_SQL.IS_OPEN(L_EQMR_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_EQMR_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETEQMEASUREMENTRANGES;

FUNCTION SAVEEQMEASUREMENTRANGES
(A_EQ                      IN       VARCHAR2,                    
 A_LAB                     IN       VARCHAR2,                    
 A_COMPONENT               IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_L_DETECTION_LIMIT       IN       UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_L_DETERM_LIMIT          IN       UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_H_DETERM_LIMIT          IN       UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_H_DETECTION_LIMIT       IN       UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_UNIT                    IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_NR_OF_ROWS              IN       NUMBER,                      
 A_MODIFY_REASON           IN       VARCHAR2)                    
RETURN NUMBER IS

A_VERSION      VARCHAR2(20);
L_ALLOW_MODIFY CHAR(1);
L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ACTIVE       CHAR(1);

BEGIN

   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_LAB, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIEQP.GETEQAUTHORISATION(A_EQ, A_LAB, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTEQ
   SET ALLOW_MODIFY='#'
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION ;

   DELETE FROM UTEQMR
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION;

   IF SQL%ROWCOUNT > 0 THEN
      L_EVENT_TP := 'EqMeasurementRangesUpdated';
   ELSE
      L_EVENT_TP := 'EqMeasurementRangesCreated';
   END IF;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_COMPONENT(L_SEQ_NO) IS NULL THEN
         L_RET_CODE := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;

      INSERT INTO UTEQMR(EQ, LAB, VERSION, SEQ, COMPONENT, L_DETECTION_LIMIT, L_DETERM_LIMIT,
                         H_DETECTION_LIMIT, H_DETERM_LIMIT, UNIT)
      VALUES(A_EQ, A_LAB, A_VERSION, L_SEQ_NO, A_COMPONENT(L_SEQ_NO), A_L_DETECTION_LIMIT(L_SEQ_NO),
             A_L_DETERM_LIMIT(L_SEQ_NO), A_H_DETERM_LIMIT(L_SEQ_NO), A_H_DETECTION_LIMIT(L_SEQ_NO), A_UNIT(L_SEQ_NO));
   END LOOP;

   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'lab=' || A_LAB || '#version=' || A_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveEqMeasurementRanges', UNAPIGEN.P_EVMGR_NAME, 'eq', A_EQ,
                                   '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF NVL(L_LOG_HS, ' ') = '1' THEN
      INSERT INTO UTEQHS (EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,  LOGDATE_TZ,
                          WHY, TR_SEQ, EV_SEQ)
      VALUES (A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'equipment "'||A_EQ||'" measurement ranges are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('SaveEqMeasurementRanges', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveEqMeasurementRanges'));
END SAVEEQMEASUREMENTRANGES;

FUNCTION GETEQCALIBRATION
(A_EQ                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_LAB                     OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_CA                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_DESCRIPTION             OUT      UNAPIGEN.VC40_TABLE_TYPE,    
 A_SOP                     OUT      UNAPIGEN.VC40_TABLE_TYPE,    
 A_ST                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_MT                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_CAL_VAL                 OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_CAL_COST                OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_CAL_TIME_VAL            OUT      UNAPIGEN.NUM_TABLE_TYPE,     
 A_CAL_TIME_UNIT           OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_FREQ_TP                 OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_FREQ_VAL                OUT      UNAPIGEN.NUM_TABLE_TYPE,     
 A_FREQ_UNIT               OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_INVERT_FREQ             OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_LAST_SCHED              OUT      UNAPIGEN.DATE_TABLE_TYPE,    
 A_LAST_VAL                OUT      UNAPIGEN.VC40_TABLE_TYPE,    
 A_LAST_CNT                OUT      UNAPIGEN.NUM_TABLE_TYPE,     
 A_SUSPEND                 OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_GRACE_VAL               OUT      UNAPIGEN.NUM_TABLE_TYPE,     
 A_GRACE_UNIT              OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_SC                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_PG                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_PGNODE                  OUT      UNAPIGEN.LONG_TABLE_TYPE,    
 A_PA                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_PANODE                  OUT      UNAPIGEN.LONG_TABLE_TYPE,    
 A_ME                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    
 A_MENODE                  OUT      UNAPIGEN.LONG_TABLE_TYPE,    
 A_REANALYSIS              OUT      UNAPIGEN.NUM_TABLE_TYPE,     
 A_CA_WARN_LEVEL           OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_NR_OF_ROWS              IN OUT   NUMBER,                      
 A_WHERE_CLAUSE            IN       VARCHAR2)                    
RETURN NUMBER IS

L_EQ                 VARCHAR2(20);
L_LAB                VARCHAR2(20);
L_CA                 VARCHAR2(20);
L_DESCRIPTION        VARCHAR2(40);
L_SOP                VARCHAR2(40);
L_ST                 VARCHAR2(20);
L_MT                 VARCHAR2(20);
L_CAL_VAL            NUMBER;
L_CAL_COST           VARCHAR2(20);
L_CAL_TIME_VAL       NUMBER;
L_CAL_TIME_UNIT      VARCHAR2(20);
L_FREQ_TP            CHAR(1);
L_FREQ_VAL           NUMBER;
L_FREQ_UNIT          VARCHAR2(20);
L_INVERT_FREQ        CHAR(1);
L_LAST_SCHED         TIMESTAMP WITH TIME ZONE;
L_LAST_VAL           VARCHAR2(40);
L_LAST_CNT           NUMBER;
L_SUSPEND            CHAR(1);
L_GRACE_VAL          NUMBER;
L_GRACE_UNIT         VARCHAR2(20);
L_SC                 VARCHAR2(20);
L_PG                 VARCHAR2(20);
L_PGNODE             NUMBER(9);
L_PA                 VARCHAR2(20);
L_PANODE             NUMBER(9);
L_ME                 VARCHAR2(20);
L_MENODE             NUMBER(9);
L_CA_WARN_LEVEL      CHAR(1);
L_EQCA_CURSOR        INTEGER;

CURSOR L_SCME_CURSOR (A_SC VARCHAR2, A_PG VARCHAR2, A_PGNODE NUMBER, 
                                     A_PA VARCHAR2, A_PANODE NUMBER,
                                     A_ME VARCHAR2, A_MENODE NUMBER) IS
   SELECT REANALYSIS 
   FROM UTSCME
   WHERE SC = A_SC
     AND PG = A_PG
     AND PGNODE = A_PGNODE
     AND PA = A_PA
     AND PANODE = A_PANODE
     AND ME = A_ME
     AND MENODE = A_MENODE;
L_SCME_REC   L_SCME_CURSOR%ROWTYPE;

BEGIN

   
      
   
   
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY ca.seq'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uveq eq WHERE eq.version_is_current = ''1'' '||
                        'AND ca.version = eq.version '||
                        'AND ca.lab = eq.lab '||
                        'AND ca.eq = eq.eq '||
                        'AND ca.eq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' AND ca.lab = ''-'' ORDER BY ca.seq'; 
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_SQL_STRING := 'SELECT ca.eq, ca.lab, ca.ca, ca.description, ca.sop, ca.st, ca.mt, ca.cal_val, ca.cal_cost,'||
                   'ca.cal_time_val, ca.cal_time_unit, ca.freq_tp, ca.freq_val, ca.freq_unit, ca.invert_freq,'||
                   'ca.last_sched, ca.last_val, ca.last_cnt, ca.suspend, ca.grace_val, ca.grace_unit,'||
                   'ca.sc, ca.pg, ca.pgnode, ca.pa, ca.panode, ca.me, ca.menode, ca.ca_warn_level '||
                   'FROM dd' || UNAPIGEN.P_DD || '.uveqca ca ' || L_WHERE_CLAUSE;

   L_EQCA_CURSOR := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(L_EQCA_CURSOR,L_SQL_STRING,DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      1, L_EQ, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      2, L_LAB, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      3, L_CA, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      4, L_DESCRIPTION, 40);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      5, L_SOP, 40);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      6, L_ST, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      7, L_MT, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      8, L_CAL_VAL);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      9, L_CAL_COST, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      10, L_CAL_TIME_VAL);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      11, L_CAL_TIME_UNIT, 20);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_EQCA_CURSOR, 12, L_FREQ_TP, 1);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      13, L_FREQ_VAL);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      14, L_FREQ_UNIT, 20);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_EQCA_CURSOR, 15, L_INVERT_FREQ, 1);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      16, L_LAST_SCHED);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      17, L_LAST_VAL, 40);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      18, L_LAST_CNT);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_EQCA_CURSOR, 19, L_SUSPEND, 1);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      20, L_GRACE_VAL);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      21, L_GRACE_UNIT, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      22, L_SC, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      23, L_PG, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      24, L_PGNODE);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      25, L_PA, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      26, L_PANODE);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      27, L_ME, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCA_CURSOR,      28, L_MENODE);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_EQCA_CURSOR, 29, L_CA_WARN_LEVEL, 1);

   L_RESULT := DBMS_SQL.EXECUTE(L_EQCA_CURSOR);

   L_FETCHED_ROWS := 0;
   L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQCA_CURSOR);

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      1, L_EQ);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      2, L_LAB);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      3, L_CA);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      4, L_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      5, L_SOP);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      6, L_ST);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      7, L_MT);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      8, L_CAL_VAL);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      9, L_CAL_COST);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      10, L_CAL_TIME_VAL);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      11, L_CAL_TIME_UNIT);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_EQCA_CURSOR, 12, L_FREQ_TP);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      13, L_FREQ_VAL);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      14, L_FREQ_UNIT);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_EQCA_CURSOR, 15, L_INVERT_FREQ);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      16, L_LAST_SCHED);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      17, L_LAST_VAL);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      18, L_LAST_CNT);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_EQCA_CURSOR, 19, L_SUSPEND);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      20, L_GRACE_VAL);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      21, L_GRACE_UNIT);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      22, L_SC);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      23, L_PG);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      24, L_PGNODE);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      25, L_PA);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      26, L_PANODE);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      27, L_ME);
      DBMS_SQL.COLUMN_VALUE(L_EQCA_CURSOR,      28, L_MENODE);
      DBMS_SQL.COLUMN_VALUE_CHAR(L_EQCA_CURSOR, 29, L_CA_WARN_LEVEL);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_EQ(L_FETCHED_ROWS)            := L_EQ;
      A_LAB(L_FETCHED_ROWS)           := L_LAB;
      A_CA(L_FETCHED_ROWS)            := L_CA;
      A_DESCRIPTION(L_FETCHED_ROWS)   := L_DESCRIPTION;
      A_SOP(L_FETCHED_ROWS)           := L_SOP;
      A_ST(L_FETCHED_ROWS)            := L_ST;
      A_MT(L_FETCHED_ROWS)            := L_MT;
      A_CAL_VAL(L_FETCHED_ROWS)       := L_CAL_VAL;
      A_CAL_COST(L_FETCHED_ROWS)      := L_CAL_COST;
      A_CAL_TIME_VAL(L_FETCHED_ROWS)  := L_CAL_TIME_VAL;
      A_CAL_TIME_UNIT(L_FETCHED_ROWS) := L_CAL_TIME_UNIT;
      A_FREQ_TP(L_FETCHED_ROWS)       := L_FREQ_TP;
      A_FREQ_VAL(L_FETCHED_ROWS)      := L_FREQ_VAL;
      A_FREQ_UNIT(L_FETCHED_ROWS)     := L_FREQ_UNIT;
      A_INVERT_FREQ(L_FETCHED_ROWS)   := L_INVERT_FREQ;
      A_LAST_SCHED(L_FETCHED_ROWS)    := L_LAST_SCHED;
      A_LAST_VAL(L_FETCHED_ROWS)      := L_LAST_VAL;
      A_LAST_CNT(L_FETCHED_ROWS)      := L_LAST_CNT;
      A_SUSPEND(L_FETCHED_ROWS)       := L_SUSPEND;
      A_GRACE_VAL(L_FETCHED_ROWS)     := L_GRACE_VAL;
      A_GRACE_UNIT(L_FETCHED_ROWS)    := L_GRACE_UNIT;
      A_SC(L_FETCHED_ROWS)            := L_SC;
      A_PG(L_FETCHED_ROWS)            := L_PG;
      A_PGNODE(L_FETCHED_ROWS)        := L_PGNODE;
      A_PA(L_FETCHED_ROWS)            := L_PA;
      A_PANODE(L_FETCHED_ROWS)        := L_PANODE;
      A_ME(L_FETCHED_ROWS)            := L_ME;
      A_MENODE(L_FETCHED_ROWS)        := L_MENODE;
      
      IF L_MENODE IS NOT NULL THEN
         OPEN L_SCME_CURSOR(L_SC, L_PG, L_PGNODE, L_PA, L_PANODE, L_ME, L_MENODE);
         FETCH L_SCME_CURSOR
         INTO L_SCME_REC;
         CLOSE L_SCME_CURSOR;
         A_REANALYSIS(L_FETCHED_ROWS) := L_SCME_REC.REANALYSIS;
      ELSE
         A_REANALYSIS(L_FETCHED_ROWS) := NULL;         
      END IF;
      
      A_CA_WARN_LEVEL(L_FETCHED_ROWS) := L_CA_WARN_LEVEL;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQCA_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_EQCA_CURSOR);

   
   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF ;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'GetEqCalibration', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   IF DBMS_SQL.IS_OPEN(L_EQCA_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_EQCA_CURSOR);
   END IF;
   IF L_SCME_CURSOR%ISOPEN THEN
      CLOSE L_SCME_CURSOR;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETEQCALIBRATION;

FUNCTION SAVEEQCALIBRATION
(A_EQ                      IN       VARCHAR2,                    
 A_LAB                     IN       VARCHAR2,                    
 A_CA                      IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_DESCRIPTION             IN       UNAPIGEN.VC40_TABLE_TYPE,    
 A_SOP                     IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_ST                      IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_MT                      IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_CAL_VAL                 IN       UNAPIGEN.FLOAT_TABLE_TYPE,   
 A_CAL_COST                IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_CAL_TIME_VAL            IN       UNAPIGEN.NUM_TABLE_TYPE,     
 A_CAL_TIME_UNIT           IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_FREQ_TP                 IN       UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_FREQ_VAL                IN       UNAPIGEN.NUM_TABLE_TYPE,     
 A_FREQ_UNIT               IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_INVERT_FREQ             IN       UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_LAST_SCHED              IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_LAST_VAL                IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_LAST_CNT                IN       UNAPIGEN.NUM_TABLE_TYPE,     
 A_SUSPEND                 IN       UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_GRACE_VAL               IN       UNAPIGEN.NUM_TABLE_TYPE,     
 A_GRACE_UNIT              IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_SC                      IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_PG                      IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_PGNODE                  IN       UNAPIGEN.LONG_TABLE_TYPE,    
 A_PA                      IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_PANODE                  IN       UNAPIGEN.LONG_TABLE_TYPE,    
 A_ME                      IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_MENODE                  IN       UNAPIGEN.LONG_TABLE_TYPE,    
 A_REANALYSIS              IN       UNAPIGEN.NUM_TABLE_TYPE,     
 A_CA_WARN_LEVEL           IN       UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_NR_OF_ROWS              IN       NUMBER,                      
 A_MODIFY_REASON           IN       VARCHAR2)                    
RETURN NUMBER IS

A_VERSION              VARCHAR2(20);
L_ALLOW_MODIFY         CHAR(1);
L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_SS                   VARCHAR2(2);
L_LOG_HS               CHAR(1);
L_ACTIVE               CHAR(1);
L_EQCA_FOUND           BOOLEAN;
L_EQCA_NOTFOUND        BOOLEAN_TABLE_TYPE;
L_OLD_CA_WARN_LEVEL    CHAR(1);
L_MAX_EQCA_WARN_LEVEL  CHAR(1);

CURSOR L_EQCA_CURSOR(A_EQ VARCHAR2, A_LAB VARCHAR2, A_VERSION VARCHAR2) IS
   SELECT * 
   FROM UTEQCA
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

CURSOR L_EQ_WARN_LEVEL_CURSOR(A_EQ VARCHAR2, A_LAB VARCHAR2, A_VERSION VARCHAR2) IS
   SELECT NVL(CA_WARN_LEVEL, '0') CA_WARN_LEVEL
   FROM UTEQ
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

CURSOR L_MAX_EQCA_WARN_LEVEL_CURSOR (A_EQ VARCHAR2, A_LAB VARCHAR2, A_VERSION VARCHAR2) IS
   SELECT NVL(MAX(CA_WARN_LEVEL), '0') MAX_EQCA_WARN_LEVEL
   FROM UTEQCA
   WHERE VERSION = A_VERSION
     AND EQ = A_EQ
     AND LAB = A_LAB;

BEGIN

   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   
      
   
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_LAB, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIEQP.GETEQAUTHORISATION(A_EQ, A_LAB, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTEQ
   SET ALLOW_MODIFY='#'
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION;

   IF SQL%ROWCOUNT > 0 THEN
      L_EVENT_TP := 'EqCalibrationUpdated';
   ELSE
      L_EVENT_TP := 'EqCalibrationCreated';
   END IF;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_CA(L_SEQ_NO) IS NULL THEN
         L_RET_CODE := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;
      IF A_FREQ_TP(L_SEQ_NO) IN ('C','T','S') THEN
         IF A_FREQ_UNIT(L_SEQ_NO) IS NULL THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_FREQUNIT;
            RAISE STPERROR;
         ELSIF A_FREQ_TP(L_SEQ_NO) = 'T' AND
            A_FREQ_UNIT(L_SEQ_NO) NOT IN ('MI','HH','DD','WW','MM','YY','MF','YF') THEN
            UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_FREQUNIT;
            RAISE STPERROR;
         END IF;
      END IF;
      L_EQCA_NOTFOUND(L_SEQ_NO) := TRUE;

   END LOOP;

   FOR L_EQCA_REC IN L_EQCA_CURSOR(A_EQ, A_LAB, A_VERSION) LOOP
      L_EQCA_FOUND := FALSE;
      FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
         IF L_EQCA_REC.CA = A_CA(L_SEQ_NO) THEN
            L_EQCA_NOTFOUND(L_SEQ_NO) := FALSE;
            L_EQCA_FOUND := TRUE;
            EXIT;
         END IF;
      END LOOP;

      IF NOT L_EQCA_FOUND THEN
         DELETE FROM UTEQCA
         WHERE EQ = A_EQ
           AND LAB = A_LAB
           AND VERSION = A_VERSION            
           AND CA = L_EQCA_REC.CA;
      END IF;
   END LOOP;

   
   
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF L_EQCA_NOTFOUND(L_SEQ_NO) THEN
         INSERT INTO UTEQCA(EQ, LAB, VERSION, CA, DESCRIPTION, SEQ, SOP, ST, MT, CAL_VAL, CAL_COST,
                            CAL_TIME_VAL, CAL_TIME_UNIT, FREQ_TP, FREQ_VAL, FREQ_UNIT,
                            INVERT_FREQ, LAST_SCHED, LAST_VAL, LAST_CNT, SUSPEND, GRACE_VAL,
                            GRACE_UNIT)
            SELECT A_EQ, A_LAB, A_VERSION, A_CA(L_SEQ_NO), A_DESCRIPTION(L_SEQ_NO), NVL(MAX(SEQ), 0)+1, A_SOP(L_SEQ_NO),
                   A_ST(L_SEQ_NO), A_MT(L_SEQ_NO), A_CAL_VAL(L_SEQ_NO),
                   A_CAL_COST(L_SEQ_NO), A_CAL_TIME_VAL(L_SEQ_NO), A_CAL_TIME_UNIT(L_SEQ_NO),
                   A_FREQ_TP(L_SEQ_NO), A_FREQ_VAL(L_SEQ_NO), A_FREQ_UNIT(L_SEQ_NO),
                   A_INVERT_FREQ(L_SEQ_NO), A_LAST_SCHED(L_SEQ_NO),
                   A_LAST_VAL(L_SEQ_NO),A_LAST_CNT(L_SEQ_NO), A_SUSPEND(L_SEQ_NO),
                   A_GRACE_VAL(L_SEQ_NO), A_GRACE_UNIT(L_SEQ_NO)
            FROM UTEQCA 
            WHERE VERSION = A_VERSION
              AND EQ = A_EQ
              AND LAB = A_LAB;
      ELSE
         UPDATE UTEQCA
         SET DESCRIPTION = A_DESCRIPTION(L_SEQ_NO),
             SOP = A_SOP(L_SEQ_NO),
             ST = A_ST(L_SEQ_NO),
             MT = A_MT(L_SEQ_NO),
             CAL_VAL = A_CAL_VAL(L_SEQ_NO),
             CAL_COST = A_CAL_COST(L_SEQ_NO),
             CAL_TIME_VAL = A_CAL_TIME_VAL(L_SEQ_NO),
             CAL_TIME_UNIT = A_CAL_TIME_UNIT(L_SEQ_NO),
             FREQ_TP = A_FREQ_TP(L_SEQ_NO),
             FREQ_VAL = A_FREQ_VAL(L_SEQ_NO),
             FREQ_UNIT = A_FREQ_UNIT(L_SEQ_NO),
             INVERT_FREQ = A_INVERT_FREQ(L_SEQ_NO),
             LAST_SCHED = A_LAST_SCHED(L_SEQ_NO),
             LAST_SCHED_TZ =  DECODE(A_LAST_SCHED(L_SEQ_NO), LAST_SCHED_TZ, LAST_SCHED_TZ, A_LAST_SCHED(L_SEQ_NO)),
             LAST_VAL = A_LAST_VAL(L_SEQ_NO),
             LAST_CNT = A_LAST_CNT(L_SEQ_NO),
             SUSPEND = A_SUSPEND(L_SEQ_NO),             
             GRACE_VAL = A_GRACE_VAL(L_SEQ_NO),
             GRACE_UNIT = A_GRACE_UNIT(L_SEQ_NO)
         WHERE EQ = A_EQ
           AND LAB = A_LAB
           AND VERSION = A_VERSION
           AND CA = A_CA(L_SEQ_NO);
      END IF;
   END LOOP;
   
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'lab=' || A_LAB || '#version=' || A_VERSION;   
   L_RESULT := UNAPIEV.INSERTEVENT('SaveEqCalibration', UNAPIGEN.P_EVMGR_NAME, 'eq', A_EQ, 
                                   '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;
   
   IF NVL(L_LOG_HS, ' ') = '1' THEN
      INSERT INTO UTEQHS (EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ,
                          WHY, TR_SEQ, EV_SEQ)
      VALUES (A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'equipment "'||A_EQ||'" interventions are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;
   
   
   DELETE FROM UTEQCALOG
   WHERE CA NOT IN (SELECT CA FROM UTEQCA WHERE VERSION=A_VERSION AND EQ=A_EQ AND LAB=A_LAB)
     AND EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION;

   
   OPEN L_EQ_WARN_LEVEL_CURSOR(A_EQ, A_LAB, A_VERSION);
   FETCH L_EQ_WARN_LEVEL_CURSOR
   INTO L_OLD_CA_WARN_LEVEL;
   CLOSE L_EQ_WARN_LEVEL_CURSOR;
   
   OPEN L_MAX_EQCA_WARN_LEVEL_CURSOR(A_EQ, A_LAB, A_VERSION);
   FETCH L_MAX_EQCA_WARN_LEVEL_CURSOR
   INTO L_MAX_EQCA_WARN_LEVEL;
   CLOSE L_MAX_EQCA_WARN_LEVEL_CURSOR;

   UPDATE UTEQ
   SET CA_WARN_LEVEL = L_MAX_EQCA_WARN_LEVEL
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION
     AND NVL(CA_WARN_LEVEL,0) <> L_MAX_EQCA_WARN_LEVEL;
   
   
   L_EV_SEQ_NR := -1;
   L_EVENT_TP := 'EqWarnLevelChanged';   
   L_EV_DETAILS := 'lab=' || A_LAB ||
                   '#version=' || A_VERSION ||
                   '#old_ca_warn_level=' || L_OLD_CA_WARN_LEVEL || 
                   '#new_ca_warn_level=' || L_MAX_EQCA_WARN_LEVEL;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveEqCalibration', UNAPIGEN.P_EVMGR_NAME, 'eq', A_EQ, 
                                   '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
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
         UNAPIGEN.LOGERROR('SaveEqCalibration', SQLERRM);
      END IF;
      IF L_EQ_WARN_LEVEL_CURSOR%ISOPEN THEN
         CLOSE L_EQ_WARN_LEVEL_CURSOR;
      END IF;
      IF L_MAX_EQCA_WARN_LEVEL_CURSOR%ISOPEN THEN
         CLOSE L_MAX_EQCA_WARN_LEVEL_CURSOR;
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveEqCalibration'));
END SAVEEQCALIBRATION;

FUNCTION GETEQCOMMUNICATION
(A_EQ                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_LAB                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_CD                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_SETTING_NAME            OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_SETTING_VALUE           OUT     UNAPIGEN.VC255_TABLE_TYPE,    
 A_SETTING_SEQ             OUT     UNAPIGEN.NUM_TABLE_TYPE,      
 A_NR_OF_ROWS              IN OUT  NUMBER,                       
 A_WHERE_CLAUSE            IN      VARCHAR2)                     
RETURN NUMBER IS

L_EQ                  VARCHAR2(20);
L_LAB                 VARCHAR2(20);
L_CD                  VARCHAR2(20);
L_SETTING_NAME        VARCHAR2(20);
L_SETTING_VALUE       VARCHAR2(255);
L_SETTING_SEQ         NUMBER;
L_EQCD_CURSOR         INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY cd.cd, cd.setting_seq'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uveq eq WHERE eq.version_is_current = ''1'' '||
                        'AND cd.version = eq.version '||
                        'AND cd.eq = eq.eq '||
                        'AND cd.lab = eq.lab '||
                        'AND cd.eq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' AND cd.lab=''-'' ORDER BY cd.cd, cd.setting_seq'; 
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_SQL_STRING := 'SELECT cd.eq, cd.lab, cd.cd, cd.setting_name, cd.setting_value, cd.setting_seq '||
                   'FROM dd' || UNAPIGEN.P_DD || '.uveqcd cd ' || L_WHERE_CLAUSE;

   L_EQCD_CURSOR := DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(L_EQCD_CURSOR,L_SQL_STRING,DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_EQCD_CURSOR, 1, L_EQ, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCD_CURSOR, 2, L_LAB, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCD_CURSOR, 3, L_CD, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCD_CURSOR, 4, L_SETTING_NAME, 20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCD_CURSOR, 5, L_SETTING_VALUE, 255);
   DBMS_SQL.DEFINE_COLUMN(L_EQCD_CURSOR, 6, L_SETTING_SEQ);
   L_RESULT := DBMS_SQL.EXECUTE(L_EQCD_CURSOR);

   L_FETCHED_ROWS := 0;
   L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQCD_CURSOR);

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_EQCD_CURSOR, 1, L_EQ);
      DBMS_SQL.COLUMN_VALUE(L_EQCD_CURSOR, 2, L_LAB);
      DBMS_SQL.COLUMN_VALUE(L_EQCD_CURSOR, 3, L_CD);
      DBMS_SQL.COLUMN_VALUE(L_EQCD_CURSOR, 4, L_SETTING_NAME);
      DBMS_SQL.COLUMN_VALUE(L_EQCD_CURSOR, 5, L_SETTING_VALUE);
      DBMS_SQL.COLUMN_VALUE(L_EQCD_CURSOR, 6, L_SETTING_SEQ);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_EQ(L_FETCHED_ROWS)            := L_EQ;
      A_LAB(L_FETCHED_ROWS)           := L_LAB;
      A_CD(L_FETCHED_ROWS)            := L_CD;
      A_SETTING_NAME(L_FETCHED_ROWS)  := L_SETTING_NAME;
      A_SETTING_VALUE(L_FETCHED_ROWS) := L_SETTING_VALUE;
      A_SETTING_SEQ(L_FETCHED_ROWS)   := L_SETTING_SEQ;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQCD_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_EQCD_CURSOR);

   
   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF ;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'GetEqCommunication', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   IF DBMS_SQL.IS_OPEN(L_EQCD_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_EQCD_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETEQCOMMUNICATION;

FUNCTION SAVEEQCOMMUNICATION
(A_EQ                      IN      VARCHAR2,                    
 A_LAB                     IN      VARCHAR2,                    
 A_CD                      IN      UNAPIGEN.VC20_TABLE_TYPE,    
 A_SETTING_NAME            IN      UNAPIGEN.VC20_TABLE_TYPE,    
 A_SETTING_VALUE           IN      UNAPIGEN.VC255_TABLE_TYPE,   
 A_SETTING_SEQ             IN      UNAPIGEN.NUM_TABLE_TYPE,     
 A_NR_OF_ROWS              IN      NUMBER,                      
 A_MODIFY_REASON           IN      VARCHAR2)                    
RETURN NUMBER IS

A_VERSION      VARCHAR2(20);
L_ALLOW_MODIFY CHAR(1);
L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ACTIVE       CHAR(1);

BEGIN

   
   A_VERSION := UNVERSION.P_NO_VERSION;
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_EQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_LAB, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIEQP.GETEQAUTHORISATION(A_EQ, A_LAB, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTEQ
   SET ALLOW_MODIFY = '#'
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION;

   DELETE FROM UTEQCD
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION;

   IF SQL%ROWCOUNT > 0 THEN
      L_EVENT_TP := 'EqCommunicationUpdated';
   ELSE
      L_EVENT_TP := 'EqCommunicationCreated';
   END IF;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_CD(L_SEQ_NO) IS NULL OR
         A_SETTING_NAME(L_SEQ_NO) IS NULL THEN
         L_RET_CODE := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;

      INSERT INTO UTEQCD(EQ, LAB, VERSION, CD, SETTING_NAME, SETTING_VALUE, SETTING_SEQ)
      VALUES(A_EQ, A_LAB, A_VERSION, A_CD(L_SEQ_NO), A_SETTING_NAME(L_SEQ_NO), A_SETTING_VALUE(L_SEQ_NO),
             L_SEQ_NO);
   END LOOP;

   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'lab=' || A_LAB || '#version=' || A_VERSION;
   L_RESULT := UNAPIEV.INSERTEVENT('SaveEqCommunication', UNAPIGEN.P_EVMGR_NAME, 'eq', A_EQ, 
                                   '', '', '', L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF NVL(L_LOG_HS, ' ') = '1' THEN
      INSERT INTO UTEQHS (EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE,  LOGDATE_TZ,
                          WHY, TR_SEQ, EV_SEQ)
      VALUES (A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'equipment "'||A_EQ||'" communication settings are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('SaveEqCommunication', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveEqCommunication'));
END SAVEEQCOMMUNICATION;

FUNCTION GETCDENTRIES
(A_CD                      OUT    UNAPIGEN.VC20_TABLE_TYPE,   
 A_SETTING_NAME            OUT    UNAPIGEN.VC20_TABLE_TYPE,   
 A_SETTING_VALUE           OUT    UNAPIGEN.VC255_TABLE_TYPE,  
 A_NR_OF_ROWS              IN OUT NUMBER,                     
 A_WHERE_CLAUSE            IN     VARCHAR2)                   
RETURN NUMBER IS

L_CD            VARCHAR2(20);
L_SETTING_NAME  VARCHAR2(20);
L_SETTING_VALUE VARCHAR2(255);
L_CDE_CURSOR    INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := ' ORDER BY setting_seq'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := 'WHERE cd = ''' || A_WHERE_CLAUSE || 
                        ''' ORDER BY setting_seq';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;
   L_CDE_CURSOR := DBMS_SQL.OPEN_CURSOR;

   L_SQL_STRING := 'SELECT cd, setting_name, setting_value '||
                   'FROM dd' || UNAPIGEN.P_DD || '.uvcd ' || L_WHERE_CLAUSE;
   DBMS_SQL.PARSE(L_CDE_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_CDE_CURSOR, 1, L_CD, 20);
   DBMS_SQL.DEFINE_COLUMN(L_CDE_CURSOR, 2, L_SETTING_NAME, 20);
   DBMS_SQL.DEFINE_COLUMN(L_CDE_CURSOR, 3, L_SETTING_VALUE, 255);
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_CDE_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_CDE_CURSOR, 1, L_CD);
      DBMS_SQL.COLUMN_VALUE(L_CDE_CURSOR, 2, L_SETTING_NAME);
      DBMS_SQL.COLUMN_VALUE(L_CDE_CURSOR, 3, L_SETTING_VALUE);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_CD(L_FETCHED_ROWS) := L_CD;
      A_SETTING_NAME(L_FETCHED_ROWS) := L_SETTING_NAME;
      A_SETTING_VALUE(L_FETCHED_ROWS) := L_SETTING_VALUE;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_CDE_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_CDE_CURSOR);

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   UNAPIGEN.LOGERROR('GetCdEntries', SQLERRM);
   IF DBMS_SQL.IS_OPEN (L_CDE_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR (L_CDE_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETCDENTRIES;

FUNCTION GETCOMPONENTLIST
(A_COMPONENT        OUT    UNAPIGEN.VC20_TABLE_TYPE,   
 A_NR_OF_ROWS       IN OUT NUMBER,                     
 A_WHERE_CLAUSE     IN     VARCHAR2)                   
RETURN NUMBER IS

L_COMPONENT     VARCHAR2(20);
L_COMP_CURSOR    INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   L_COMP_CURSOR := DBMS_SQL.OPEN_CURSOR;
   
   L_WHERE_CLAUSE := A_WHERE_CLAUSE ; 

   L_SQL_STRING := 'SELECT component ' ||
                   'FROM dd' || UNAPIGEN.P_DD || '.uvmtmr ' || L_WHERE_CLAUSE ||
                   ' UNION ' ||
                   'SELECT DISTINCT component ' ||
                   'FROM dd' || UNAPIGEN.P_DD || '.uveqmr ' || L_WHERE_CLAUSE || ' ORDER BY 1';
            
   DBMS_SQL.PARSE(L_COMP_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_COMP_CURSOR, 1, L_COMPONENT, 20);
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_COMP_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_COMP_CURSOR, 1, L_COMPONENT);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_COMPONENT(L_FETCHED_ROWS) := L_COMPONENT;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_COMP_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_COMP_CURSOR);

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   UNAPIGEN.LOGERROR('GetComponentList', SQLERRM);
   IF DBMS_SQL.IS_OPEN (L_COMP_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR (L_COMP_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETCOMPONENTLIST;

FUNCTION STARTINSTRUMENT
(A_EQ                      IN    VARCHAR2,                    
 A_LAB                     IN    VARCHAR2)                    
RETURN NUMBER IS
A_VERSION   VARCHAR2(20);
BEGIN
   
   A_VERSION := UNVERSION.P_NO_VERSION;

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
   IF L_RET_CODE <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   INSERT INTO UTEQHS(EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, 
                      WHY, TR_SEQ, EV_SEQ)
   VALUES(A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 
          'Instrument "'|| A_EQ ||'" is started.', 'Instrument "'|| A_EQ ||'" is started.', 
          CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '', UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

END STARTINSTRUMENT;

FUNCTION STOPINSTRUMENT
(A_EQ                      IN    VARCHAR2,                    
 A_LAB                     IN    VARCHAR2)                    
RETURN NUMBER IS
A_VERSION   VARCHAR2(20);
BEGIN
  
   A_VERSION := UNVERSION.P_NO_VERSION;

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETNEXTEVENTSEQNR(L_EV_SEQ_NR);
   IF L_RET_CODE <> 0 THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   INSERT INTO UTEQHS(EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, 
                      WHY, TR_SEQ, EV_SEQ)
   VALUES(A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 
          'Instrument "'|| A_EQ ||'" is stopped.', 'Instrument "'|| A_EQ ||'" is stopped.', 
          CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '', UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

END STOPINSTRUMENT;

FUNCTION GETEQCHARTTYPE
(A_EQ                    OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_LAB                   OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_CY                    OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_CY_VERSION            OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_CT_NAME               OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_NR_OF_ROWS            IN OUT   NUMBER,                    
 A_WHERE_CLAUSE          IN       VARCHAR2)                  
RETURN NUMBER IS

L_EQ                VARCHAR2(20);
L_LAB               VARCHAR2(20);
L_VERSION           VARCHAR2(20);
L_CY                VARCHAR2(20);
L_CY_VERSION        VARCHAR2(20);
L_CT_NAME           VARCHAR2(20);

L_EQ_CURSOR         INTEGER;

BEGIN
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY eq, lab, version, cy, cy_version, ct_name'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
   L_WHERE_CLAUSE :=   ', dd'||UNAPIGEN.P_DD||'.uveq eq WHERE eq.version_is_current = ''1'' '||
                       'AND eqct.version = eq.version '||
                       'AND eqct.eq = eq.eq '||
                       'AND eqct.lab = eq.lab '||
                       'AND eqct.eq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                       ''' AND eqct.lab=''-'' ORDER BY cy, cy_version, ct_name'; 
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;
   
   L_EQ_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'SELECT eqct.eq, eqct.lab, eqct.version, eqct.cy, eqct.cy_version, eqct.ct_name ' ||
                   'FROM dd' || UNAPIGEN.P_DD || '.uveqcyct eqct ' || L_WHERE_CLAUSE;
            
   DBMS_SQL.PARSE(L_EQ_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,       1 ,     L_EQ         ,     20); 
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,       2 ,     L_LAB        ,     20); 
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,       3 ,     L_VERSION    ,     20); 
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,       4 ,     L_CY         ,     20); 
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,       5 ,     L_CY_VERSION ,     20); 
   DBMS_SQL.DEFINE_COLUMN(L_EQ_CURSOR,       6 ,     L_CT_NAME    ,     20); 
                                                             

   L_RESULT := DBMS_SQL.EXECUTE(L_EQ_CURSOR);
   L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQ_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,       1 ,     L_EQ          );
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,       2 ,     L_LAB         );
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,       3 ,     L_VERSION     );
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,       4 ,     L_CY          );
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,       5 ,     L_CY_VERSION  );
      DBMS_SQL.COLUMN_VALUE(L_EQ_CURSOR,       6 ,     L_CT_NAME     );
 
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
     
      A_EQ            (L_FETCHED_ROWS) := L_EQ          ;
      A_LAB           (L_FETCHED_ROWS) := L_LAB         ;
      A_CY            (L_FETCHED_ROWS) := L_CY          ;
      A_CY_VERSION    (L_FETCHED_ROWS) := L_CY_VERSION  ;
      A_CT_NAME       (L_FETCHED_ROWS) := L_CT_NAME     ;
      
      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQ_CURSOR);
      END IF;
   END LOOP;
   
   DBMS_SQL.CLOSE_CURSOR(L_EQ_CURSOR);

   IF L_FETCHED_ROWS = 0 THEN
      RETURN(UNAPIGEN.DBERR_NORECORDS);
   END IF;

   A_NR_OF_ROWS := L_FETCHED_ROWS;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
           'GetEqChartType', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   IF DBMS_SQL.IS_OPEN (L_EQ_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR (L_EQ_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETEQCHARTTYPE;

FUNCTION SAVEEQCHARTTYPE
(A_EQ                     IN    VARCHAR2,                       
 A_LAB                    IN    VARCHAR2,                       
 A_CY                     IN    UNAPIGEN.VC20_TABLE_TYPE,     
 A_CY_VERSION             IN    UNAPIGEN.VC20_TABLE_TYPE,     
 A_CT_NAME                IN    UNAPIGEN.VC20_TABLE_TYPE,     
 A_NR_OF_ROWS             IN    NUMBER,                       
 A_MODIFY_REASON          IN    VARCHAR2)                      
RETURN NUMBER IS
L_CY_VERSION     VARCHAR2(20);
A_VERSION        VARCHAR2(20);
L_LC             VARCHAR2(2);
L_LC_VERSION     VARCHAR2(20);
L_SS             VARCHAR2(2);
L_LOG_HS         CHAR(1);
L_ALLOW_MODIFY   CHAR(1);
L_ACTIVE         CHAR(1);
L_INSERT         BOOLEAN;
L_ERROR        EXCEPTION;
BEGIN
   
   A_VERSION := UNVERSION.P_NO_VERSION;
   
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE L_ERROR;
   END IF;
   
   IF NVL(A_EQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  L_ERROR;
   END IF;

   IF NVL(A_LAB, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  L_ERROR;
   END IF;

   L_RET_CODE := UNAPIEQP.GETEQAUTHORISATION(A_EQ, A_LAB, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
   END IF;
   
   UPDATE UTEQ
   SET ALLOW_MODIFY = '#'
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION;
     
   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE  STPERROR ;
   END IF;
   
   DELETE UTEQCYCT
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION;
  
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_CY(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE  STPERROR ;
      END IF;
      INSERT INTO UTEQCYCT (EQ, LAB, VERSION, CY, CY_VERSION, CT_NAME)
      VALUES (A_EQ, A_LAB, A_VERSION, A_CY(L_SEQ_NO), A_CY_VERSION(L_SEQ_NO), A_CT_NAME(L_SEQ_NO));
   END LOOP;
   
   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'lab=' || A_LAB || '#version=' || A_VERSION;
   L_RET_CODE := UNAPIEV.INSERTEVENT('SaveEqChartType',UNAPIGEN.P_EVMGR_NAME, 'eq', A_EQ, 
                                     L_LC, L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS,
                                     L_EV_SEQ_NR);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
   IF L_LOG_HS = '1' THEN
      INSERT INTO UTEQHS (EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                          WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'equipment "'||A_EQ||'" chart types are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveEqChartType',SQLERRM);
   END IF ;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveEqChartType'));
END SAVEEQCHARTTYPE;

FUNCTION GETEQCHARTLIST
(A_EQ                IN       VARCHAR2,                  
 A_LAB               IN       VARCHAR2,                  
 A_CH                OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_CY                OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_CY_VERSION        OUT      UNAPIGEN.VC20_TABLE_TYPE,  
 A_DESCRIPTION       OUT      UNAPIGEN.VC40_TABLE_TYPE,  
 A_CREATION_DATE     OUT      UNAPIGEN.DATE_TABLE_TYPE,  
 A_CH_CONTEXT_KEY    OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_VISUAL_CF         OUT      UNAPIGEN.VC255_TABLE_TYPE, 
 A_SS                OUT      UNAPIGEN.VC2_TABLE_TYPE,   
 A_NR_OF_ROWS        IN OUT   NUMBER)                    

RETURN NUMBER IS
 L_CH                VARCHAR2(20);
 L_CY                VARCHAR2(20);
 L_CY_VERSION        VARCHAR2(20);
 L_DESCRIPTION       VARCHAR2(40);
 L_CREATION_DATE     TIMESTAMP WITH TIME ZONE;
 L_CH_CONTEXT_KEY    VARCHAR2(255);
 L_VISUAL_CF         VARCHAR2(255);
 L_SS                VARCHAR2(2);
 L_EQCH_CURSOR       INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS, 0) = 0 THEN
   A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
   RETURN(UNAPIGEN.DBERR_NROFROWS);
   END IF;

 
   
      
   L_WHERE_CLAUSE := 'WHERE a.ch_context_key like ''' || A_EQ || '#'|| A_LAB || '#%''';

   L_EQCH_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'SELECT a.ch, a.cy, a.cy_version, a.description, a.creation_date, a.ch_context_key, a.visual_cf, a.ss ' ||
                   ' FROM dd' || UNAPIGEN.P_DD ||
                   '.uvch a '|| L_WHERE_CLAUSE  ||
                   ' and  a.creation_date = '||
                   '  ( select max(b.creation_date) from dd' || UNAPIGEN.P_DD ||
                   '.uvch b where'||
                   '    b.ch_context_key = a.ch_context_key and'||
                   '    b.cy = a.cy )';

   DBMS_SQL.PARSE(L_EQCH_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   DBMS_SQL.DEFINE_COLUMN(L_EQCH_CURSOR,  1,   L_CH               ,  20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCH_CURSOR,  2,   L_CY               ,  20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCH_CURSOR,  3,   L_CY_VERSION       ,  20);
   DBMS_SQL.DEFINE_COLUMN(L_EQCH_CURSOR,  4,   L_DESCRIPTION      ,  40);
   DBMS_SQL.DEFINE_COLUMN(L_EQCH_CURSOR,  5,   L_CREATION_DATE         );
   DBMS_SQL.DEFINE_COLUMN(L_EQCH_CURSOR,  6,   L_CH_CONTEXT_KEY   , 255);
   DBMS_SQL.DEFINE_COLUMN(L_EQCH_CURSOR,  7,   L_VISUAL_CF        , 255);
   DBMS_SQL.DEFINE_COLUMN(L_EQCH_CURSOR,  8,   L_SS               ,  2 );

   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_EQCH_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(L_EQCH_CURSOR, 1   , L_CH             );
      DBMS_SQL.COLUMN_VALUE(L_EQCH_CURSOR, 2   , L_CY             );
      DBMS_SQL.COLUMN_VALUE(L_EQCH_CURSOR, 3   , L_CY_VERSION     );
      DBMS_SQL.COLUMN_VALUE(L_EQCH_CURSOR, 4   , L_DESCRIPTION    );
      DBMS_SQL.COLUMN_VALUE(L_EQCH_CURSOR, 5   , L_CREATION_DATE  );
      DBMS_SQL.COLUMN_VALUE(L_EQCH_CURSOR, 6   , L_CH_CONTEXT_KEY );
      DBMS_SQL.COLUMN_VALUE(L_EQCH_CURSOR, 7   , L_VISUAL_CF      );      
      DBMS_SQL.COLUMN_VALUE(L_EQCH_CURSOR, 8   , L_SS             );

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_CH             (L_FETCHED_ROWS) := L_CH               ;
      A_CY             (L_FETCHED_ROWS) := L_CY               ;
      A_CY_VERSION     (L_FETCHED_ROWS) := L_CY_VERSION       ;
      A_DESCRIPTION    (L_FETCHED_ROWS) := L_DESCRIPTION      ;
      A_CREATION_DATE  (L_FETCHED_ROWS) := L_CREATION_DATE    ;
      A_CH_CONTEXT_KEY (L_FETCHED_ROWS) := L_CH_CONTEXT_KEY   ;
      A_VISUAL_CF      (L_FETCHED_ROWS) := L_VISUAL_CF        ;
      A_SS             (L_FETCHED_ROWS) := L_SS               ;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_EQCH_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_EQCH_CURSOR);

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
              'GetEqChartList', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN(L_EQCH_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_EQCH_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETEQCHARTLIST;

FUNCTION GETEQUIPMENTTYPE
(A_EQ                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_LAB                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_EQ_TP                   OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_NR_OF_ROWS              IN OUT  NUMBER,                       
 A_WHERE_CLAUSE            IN      VARCHAR2)                     
RETURN NUMBER IS

L_EQ                  VARCHAR2(20);
L_LAB                 VARCHAR2(20);
L_EQ_TP               VARCHAR2(20);
L_EQTP_CURSOR         UNAPIGEN.CURSOR_REF_TYPE;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY tp.eq_tp, tp.lab, tp.seq'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uveq eq WHERE eq.version_is_current = ''1'' '||
                        'AND tp.version = eq.version '||
                        'AND tp.eq = eq.eq '||
                        'AND tp.lab = eq.lab '||
                        'AND tp.eq = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' AND tp.lab=''-'' ORDER BY tp.eq, tp.lab, tp.seq'; 
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_SQL_STRING := 'SELECT tp.eq, tp.lab, tp.eq_tp '||
                   'FROM dd' || UNAPIGEN.P_DD || '.uveqtype tp ' || L_WHERE_CLAUSE;

   OPEN L_EQTP_CURSOR FOR L_SQL_STRING;
   
   L_FETCHED_ROWS := 0;
   LOOP
      FETCH L_EQTP_CURSOR 
      INTO L_EQ, L_LAB, L_EQ_TP;
      
      EXIT WHEN L_EQTP_CURSOR%NOTFOUND;
      
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_EQ(L_FETCHED_ROWS)            := L_EQ;
      A_LAB(L_FETCHED_ROWS)           := L_LAB;
      A_EQ_TP(L_FETCHED_ROWS)         := L_EQ_TP;
      EXIT WHEN L_FETCHED_ROWS >= A_NR_OF_ROWS;
   
   END LOOP;
   
   CLOSE L_EQTP_CURSOR;
   
   
   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
   ELSE
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF ;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'GetEquipmentType', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   IF L_EQTP_CURSOR%ISOPEN  THEN
      CLOSE L_EQTP_CURSOR;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETEQUIPMENTTYPE;

FUNCTION SAVEEQUIPMENTTYPE
(A_EQ                      IN      VARCHAR2,                    
 A_LAB                     IN      VARCHAR2,                    
 A_EQ_TP                   IN      UNAPIGEN.VC20_TABLE_TYPE,    
 A_NR_OF_ROWS              IN      NUMBER,                      
 A_MODIFY_REASON           IN      VARCHAR2)                    
RETURN NUMBER IS

L_CY_VERSION     VARCHAR2(20);
A_VERSION        VARCHAR2(20);
L_LC             VARCHAR2(2);
L_LC_VERSION     VARCHAR2(20);
L_SS             VARCHAR2(2);
L_LOG_HS         CHAR(1);
L_ALLOW_MODIFY   CHAR(1);
L_ACTIVE         CHAR(1);
L_INSERT         BOOLEAN;
L_ERROR        EXCEPTION;
BEGIN
   
   A_VERSION := UNVERSION.P_NO_VERSION;
   
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE L_ERROR;
   END IF;
   
   IF NVL(A_EQ, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  L_ERROR;
   END IF;

   IF NVL(A_LAB, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE  L_ERROR;
   END IF;

   L_RET_CODE := UNAPIEQP.GETEQAUTHORISATION(A_EQ, A_LAB, L_LC, L_LC_VERSION, L_SS,
                                             L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
         UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
         RAISE STPERROR;
   END IF;
   
   UPDATE UTEQ
   SET ALLOW_MODIFY = '#'
   WHERE EQ = A_EQ
     AND LAB = A_LAB
     AND VERSION = A_VERSION;
     
   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE  STPERROR ;
   END IF;
   
   DELETE UTEQTYPE
   WHERE EQ = A_EQ
     AND LAB = A_LAB;
  
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_EQ_TP(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
         RAISE  STPERROR ;
      END IF;
      INSERT INTO UTEQTYPE (EQ, LAB, VERSION, EQ_TP, SEQ)
      VALUES (A_EQ, A_LAB, A_VERSION, A_EQ_TP(L_SEQ_NO), L_SEQ_NO);
   END LOOP;
   
   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_EV_DETAILS := 'lab=' || A_LAB || '#version=' || A_VERSION;
   L_RET_CODE := UNAPIEV.INSERTEVENT('SaveEquipmentType',UNAPIGEN.P_EVMGR_NAME, 'eq', A_EQ, 
                                     L_LC, L_LC_VERSION, L_SS, L_EVENT_TP, L_EV_DETAILS,
                                     L_EV_SEQ_NR);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;
   IF L_LOG_HS = '1' THEN
      INSERT INTO UTEQHS (EQ, LAB, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                          WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_EQ, A_LAB, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'equipment "'||A_EQ||'" equipment types are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SaveEquipmentType',SQLERRM);
   END IF ;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveEquipmentType'));
END SAVEEQUIPMENTTYPE;

FUNCTION GETLAB
(A_LAB                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     
 A_NR_OF_ROWS              IN OUT  NUMBER,                       
 A_WHERE_CLAUSE            IN      VARCHAR2)                     
RETURN NUMBER IS
   L_LAB                      VARCHAR(20);
   L_LAB_CURSOR               INTEGER;
BEGIN
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY lab'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := 'WHERE lab = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || ''' ORDER BY lab'; 
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_LAB_CURSOR := DBMS_SQL.OPEN_CURSOR;
   L_SQL_STRING := 'SELECT lab FROM dd' || UNAPIGEN.P_DD || '.uvlab ' || L_WHERE_CLAUSE;
   DBMS_SQL.PARSE(L_LAB_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
   DBMS_SQL.DEFINE_COLUMN(L_LAB_CURSOR, 1, L_LAB, 20);
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_LAB_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_LAB_CURSOR, 1, L_LAB);
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_LAB(L_FETCHED_ROWS) := L_LAB;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_LAB_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_LAB_CURSOR);

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
              'GetLab', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (L_LAB_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_LAB_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETLAB;

END UNAPIEQ;