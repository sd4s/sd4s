PACKAGE BODY unapipt AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;
L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(4000);
L_WHERE_CLAUSE    VARCHAR2(3000);
L_EVENT_TP        UTEV.EV_TP%TYPE;
L_RET_CODE        NUMBER;
L_RESULT          NUMBER;
L_FETCHED_ROWS    NUMBER;
L_EV_SEQ_NR       NUMBER;
STPERROR          EXCEPTION;


P_PT__CURSOR           INTEGER;
P_PTIP_CURSOR          INTEGER;
P_SELECTPT_CURSOR      INTEGER;
P_SELECTPTGK_CURSOR    INTEGER;
P_SELECTPTPROP_CURSOR  INTEGER;
L_PTGK_CURSOR          INTEGER;

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION GETPROTOCOLLIST
(A_PT                          OUT      UNAPIGEN.VC20_TABLE_TYPE, 
 A_VERSION                     OUT      UNAPIGEN.VC20_TABLE_TYPE, 
 A_VERSION_IS_CURRENT          OUT      UNAPIGEN.CHAR1_TABLE_TYPE,
 A_EFFECTIVE_FROM              OUT      UNAPIGEN.DATE_TABLE_TYPE, 
 A_EFFECTIVE_TILL              OUT      UNAPIGEN.DATE_TABLE_TYPE, 
 A_DESCRIPTION                 OUT      UNAPIGEN.VC40_TABLE_TYPE, 
 A_SS                          OUT      UNAPIGEN.VC2_TABLE_TYPE,  
 A_NR_OF_ROWS                  IN OUT   NUMBER,                   
 A_WHERE_CLAUSE                IN       VARCHAR2,                 
 A_NEXT_ROWS                   IN       NUMBER)                   
RETURN NUMBER IS

L_PT                          VARCHAR2(20);
L_VERSION                     VARCHAR2(20);
L_VERSION_IS_CURRENT          CHAR(1);
L_EFFECTIVE_FROM              TIMESTAMP WITH TIME ZONE;
L_EFFECTIVE_TILL              TIMESTAMP WITH TIME ZONE;
L_DESCRIPTION                 VARCHAR2(40);
L_SS                          VARCHAR2(2);

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
      IF P_PT__CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_PT__CURSOR);
         P_PT__CURSOR := NULL;
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_PT__CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN
      IF P_PT__CURSOR IS NULL THEN
         P_PT__CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;

      IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
         L_WHERE_CLAUSE := 'WHERE active = ''1'' ORDER BY pt, version'; 
      ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
         L_WHERE_CLAUSE := 'WHERE version_is_current = ''1'' ' || 
                           'AND pt = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                           ''' ORDER BY pt, version';
      ELSE
         L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
      END IF;

      L_SQL_STRING := 'SELECT pt, version, nvl(version_is_current,''0''), effective_from, '||
                      'effective_till, description, ss FROM dd' ||
                      UNAPIGEN.P_DD || '.uvpt ' || L_WHERE_CLAUSE;

      DBMS_SQL.PARSE(P_PT__CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

      DBMS_SQL.DEFINE_COLUMN(P_PT__CURSOR,      1,      L_PT,      20);
      DBMS_SQL.DEFINE_COLUMN(P_PT__CURSOR,      2,      L_VERSION, 20);
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_PT__CURSOR, 3,      L_VERSION_IS_CURRENT, 1);
      DBMS_SQL.DEFINE_COLUMN(P_PT__CURSOR,      4,      L_EFFECTIVE_FROM);
      DBMS_SQL.DEFINE_COLUMN(P_PT__CURSOR,      5,      L_EFFECTIVE_TILL);
      DBMS_SQL.DEFINE_COLUMN(P_PT__CURSOR,      6,      L_DESCRIPTION, 40);
      DBMS_SQL.DEFINE_COLUMN(P_PT__CURSOR,      7,      L_SS,      2);
      L_RESULT := DBMS_SQL.EXECUTE(P_PT__CURSOR);
   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(P_PT__CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(P_PT__CURSOR,      1,      L_PT);
      DBMS_SQL.COLUMN_VALUE(P_PT__CURSOR,      2,      L_VERSION);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_PT__CURSOR, 3,      L_VERSION_IS_CURRENT);
      DBMS_SQL.COLUMN_VALUE(P_PT__CURSOR,      4,      L_EFFECTIVE_FROM);
      DBMS_SQL.COLUMN_VALUE(P_PT__CURSOR,      5,      L_EFFECTIVE_TILL);
      DBMS_SQL.COLUMN_VALUE(P_PT__CURSOR,      6,      L_DESCRIPTION);
      DBMS_SQL.COLUMN_VALUE(P_PT__CURSOR,      7,      L_SS);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_PT                (L_FETCHED_ROWS) := L_PT;
      A_VERSION           (L_FETCHED_ROWS) := L_VERSION;
      A_VERSION_IS_CURRENT(L_FETCHED_ROWS) := L_VERSION_IS_CURRENT;
      A_EFFECTIVE_FROM    (L_FETCHED_ROWS) := L_EFFECTIVE_FROM;
      A_EFFECTIVE_TILL    (L_FETCHED_ROWS) := L_EFFECTIVE_TILL;
      A_DESCRIPTION       (L_FETCHED_ROWS) := L_DESCRIPTION;
      A_SS                (L_FETCHED_ROWS) := L_SS;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_PT__CURSOR);
      END IF;
   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
       DBMS_SQL.CLOSE_CURSOR(P_PT__CURSOR);
       P_PT__CURSOR := NULL;
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_PT__CURSOR);
      P_PT__CURSOR := NULL;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME,
                          ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
              'GetProtocolList', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_PT__CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_PT__CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPROTOCOLLIST;

FUNCTION GETPROTOCOL
(A_PT                   OUT  UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION              OUT  UNAPIGEN.VC20_TABLE_TYPE,  
 A_VERSION_IS_CURRENT   OUT  UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_EFFECTIVE_FROM       OUT  UNAPIGEN.DATE_TABLE_TYPE,  
 A_EFFECTIVE_TILL       OUT  UNAPIGEN.DATE_TABLE_TYPE,  
 A_DESCRIPTION          OUT  UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCRIPTION2         OUT  UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCR_DOC            OUT  UNAPIGEN.VC40_TABLE_TYPE,  
 A_DESCR_DOC_VERSION    OUT  UNAPIGEN.VC20_TABLE_TYPE,  
 A_IS_TEMPLATE          OUT  UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_CONFIRM_USERID       OUT  UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_NR_PLANNED_SD        OUT  UNAPIGEN.NUM_TABLE_TYPE,   
 A_FREQ_TP              OUT  UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_FREQ_VAL             OUT  UNAPIGEN.NUM_TABLE_TYPE,   
 A_FREQ_UNIT            OUT  UNAPIGEN.VC20_TABLE_TYPE,  
 A_INVERT_FREQ          OUT  UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LAST_SCHED           OUT  UNAPIGEN.DATE_TABLE_TYPE,  
 A_LAST_CNT             OUT  UNAPIGEN.NUM_TABLE_TYPE,   
 A_LAST_VAL             OUT  UNAPIGEN.VC40_TABLE_TYPE,  
 A_LABEL_FORMAT         OUT  UNAPIGEN.VC20_TABLE_TYPE,  
 A_PLANNED_RESPONSIBLE  OUT  UNAPIGEN.VC20_TABLE_TYPE,  
 A_SD_UC                OUT  UNAPIGEN.VC20_TABLE_TYPE,  
 A_SD_UC_VERSION        OUT  UNAPIGEN.VC20_TABLE_TYPE,  
 A_SD_LC                OUT  UNAPIGEN.VC2_TABLE_TYPE,   
 A_SD_LC_VERSION        OUT  UNAPIGEN.VC20_TABLE_TYPE,  
 A_INHERIT_AU           OUT  UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_INHERIT_GK           OUT  UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_PT_CLASS             OUT  UNAPIGEN.VC2_TABLE_TYPE,   
 A_LOG_HS               OUT  UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ALLOW_MODIFY         OUT  UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_ACTIVE               OUT  UNAPIGEN.CHAR1_TABLE_TYPE, 
 A_LC                   OUT  UNAPIGEN.VC2_TABLE_TYPE,   
 A_LC_VERSION           OUT  UNAPIGEN.VC20_TABLE_TYPE,  
 A_SS                   OUT  UNAPIGEN.VC2_TABLE_TYPE,   
 A_NR_OF_ROWS           IN OUT  NUMBER,                 
 A_WHERE_CLAUSE         IN   VARCHAR2)                  
RETURN NUMBER IS

L_PT                   VARCHAR2(20);
L_VERSION              VARCHAR2(20);
L_VERSION_IS_CURRENT   CHAR(1);
L_EFFECTIVE_FROM       TIMESTAMP WITH TIME ZONE;
L_EFFECTIVE_TILL       TIMESTAMP WITH TIME ZONE;
L_DESCRIPTION          VARCHAR2(40);
L_DESCRIPTION2         VARCHAR2(40);
L_DESCR_DOC            VARCHAR2(40);
L_DESCR_DOC_VERSION    VARCHAR2(20);
L_IS_TEMPLATE          CHAR(1);
L_CONFIRM_USERID       CHAR(1);
L_NR_PLANNED_SD        NUMBER;
L_FREQ_TP              CHAR(1);
L_FREQ_VAL             NUMBER;
L_FREQ_UNIT            VARCHAR2(20);
L_INVERT_FREQ          CHAR(1);
L_LAST_SCHED           TIMESTAMP WITH TIME ZONE;
L_LAST_CNT             NUMBER;
L_LAST_VAL             VARCHAR2(40);
L_LABEL_FORMAT         VARCHAR2(20);
L_PLANNED_RESPONSIBLE  VARCHAR2(20);
L_SD_UC                VARCHAR2(20);
L_SD_UC_VERSION        VARCHAR2(20);
L_SD_LC                VARCHAR2(2);
L_SD_LC_VERSION        VARCHAR2(20);
L_INHERIT_AU           CHAR(1);
L_INHERIT_GK           CHAR(1);
L_PT_CLASS             VARCHAR2(2);
L_LOG_HS               CHAR(1);
L_ALLOW_MODIFY         CHAR(1);
L_ACTIVE               CHAR(1);
L_LC                   VARCHAR2(2);
L_LC_VERSION           VARCHAR2(20);
L_SS                   VARCHAR2(2);

L_PT_CURSOR            INTEGER;
BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY pt, version'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := 'WHERE version_is_current = ''1'' '||
                        'AND pt = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' ORDER BY pt, version';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_PT_CURSOR := DBMS_SQL.OPEN_CURSOR;

   L_SQL_STRING := 'SELECT pt, version, nvl(version_is_current,''0''), effective_from, effective_till, description, ' ||
      'description2, descr_doc, descr_doc_version, is_template, confirm_userid, nr_planned_sd, freq_tp, freq_val, freq_unit, ' ||
      'invert_freq, last_sched, last_cnt, last_val, label_format, planned_responsible, sd_uc, sd_uc_version, ' ||
      'sd_lc, sd_lc_version, inherit_au, inherit_gk, pt_class, log_hs, allow_modify, active, lc, lc_version, ' ||
      'ss ' ||
      ' FROM dd' || UNAPIGEN.P_DD || '.uvpt ' || L_WHERE_CLAUSE;
   DBMS_SQL.PARSE(L_PT_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       1,   L_PT                  ,  20   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       2,   L_VERSION             ,  20   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PT_CURSOR,  3,   L_VERSION_IS_CURRENT  ,  1   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       4,   L_EFFECTIVE_FROM      );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       5,   L_EFFECTIVE_TILL      );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       6,   L_DESCRIPTION         ,  40   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       7,   L_DESCRIPTION2        ,  40   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       8,   L_DESCR_DOC           ,  40   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       9,   L_DESCR_DOC_VERSION   ,  20   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PT_CURSOR,  10,   L_IS_TEMPLATE        ,  1   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PT_CURSOR,  11,   L_CONFIRM_USERID     ,  1   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       12,   L_NR_PLANNED_SD      );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PT_CURSOR,  13,   L_FREQ_TP            ,  1   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       14,   L_FREQ_VAL           );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       15,   L_FREQ_UNIT          ,  20   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PT_CURSOR,  16,   L_INVERT_FREQ        ,  1   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       17,   L_LAST_SCHED         );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       18,   L_LAST_CNT           );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       19,   L_LAST_VAL           ,  40   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       20,   L_LABEL_FORMAT       ,  20   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       21,   L_PLANNED_RESPONSIBLE,  20   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       22,   L_SD_UC              ,  20   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       23,   L_SD_UC_VERSION      ,  20   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       24,   L_SD_LC              ,  2   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       25,   L_SD_LC_VERSION      ,  20   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PT_CURSOR,  26,   L_INHERIT_AU         ,  1   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PT_CURSOR,  27,   L_INHERIT_GK         ,  1   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       28,   L_PT_CLASS           ,  2   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PT_CURSOR,  29,   L_LOG_HS             ,  1   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PT_CURSOR,  30,   L_ALLOW_MODIFY       ,  1   );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PT_CURSOR,  31,   L_ACTIVE             ,  1   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       32,   L_LC                 ,  2   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       33,   L_LC_VERSION         ,  20   );
   DBMS_SQL.DEFINE_COLUMN(L_PT_CURSOR,       34,   L_SS                 ,  2   );
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_PT_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       1,   L_PT                  );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       2,   L_VERSION             );
   DBMS_SQL.COLUMN_VALUE_CHAR(L_PT_CURSOR,  3,   L_VERSION_IS_CURRENT  );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       4,   L_EFFECTIVE_FROM      );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       5,   L_EFFECTIVE_TILL      );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       6,   L_DESCRIPTION         );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       7,   L_DESCRIPTION2        );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       8,   L_DESCR_DOC           );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       9,   L_DESCR_DOC_VERSION   );
   DBMS_SQL.COLUMN_VALUE_CHAR(L_PT_CURSOR,  10,  L_IS_TEMPLATE         );
   DBMS_SQL.COLUMN_VALUE_CHAR(L_PT_CURSOR,  11,  L_CONFIRM_USERID      );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       12,  L_NR_PLANNED_SD       );
   DBMS_SQL.COLUMN_VALUE_CHAR(L_PT_CURSOR,  13,  L_FREQ_TP             );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       14,  L_FREQ_VAL            );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       15,  L_FREQ_UNIT           );
   DBMS_SQL.COLUMN_VALUE_CHAR(L_PT_CURSOR,  16,  L_INVERT_FREQ         );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       17,  L_LAST_SCHED          );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       18,  L_LAST_CNT            );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       19,  L_LAST_VAL            );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       20,  L_LABEL_FORMAT        );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       21,  L_PLANNED_RESPONSIBLE );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       22,  L_SD_UC               );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       23,  L_SD_UC_VERSION       );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       24,  L_SD_LC               );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       25,  L_SD_LC_VERSION       );
   DBMS_SQL.COLUMN_VALUE_CHAR(L_PT_CURSOR,  26,  L_INHERIT_AU          );
   DBMS_SQL.COLUMN_VALUE_CHAR(L_PT_CURSOR,  27,  L_INHERIT_GK          );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       28,  L_PT_CLASS            );
   DBMS_SQL.COLUMN_VALUE_CHAR(L_PT_CURSOR,  29,  L_LOG_HS              );
   DBMS_SQL.COLUMN_VALUE_CHAR(L_PT_CURSOR,  30,  L_ALLOW_MODIFY        );
   DBMS_SQL.COLUMN_VALUE_CHAR(L_PT_CURSOR,  31,  L_ACTIVE              );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       32,  L_LC                  );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       33,  L_LC_VERSION          );
   DBMS_SQL.COLUMN_VALUE(L_PT_CURSOR,       34,  L_SS                  );
   
   L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
   
   A_PT                   (L_FETCHED_ROWS) := L_PT ;
   A_VERSION              (L_FETCHED_ROWS) := L_VERSION ;
   A_VERSION_IS_CURRENT   (L_FETCHED_ROWS) := L_VERSION_IS_CURRENT ;
   A_EFFECTIVE_FROM       (L_FETCHED_ROWS) := L_EFFECTIVE_FROM ;
   A_EFFECTIVE_TILL       (L_FETCHED_ROWS) := L_EFFECTIVE_TILL ;
   A_DESCRIPTION          (L_FETCHED_ROWS) := L_DESCRIPTION ;
   A_DESCRIPTION2         (L_FETCHED_ROWS) := L_DESCRIPTION2 ;
   A_DESCR_DOC            (L_FETCHED_ROWS) := L_DESCR_DOC ;
   A_DESCR_DOC_VERSION    (L_FETCHED_ROWS) := L_DESCR_DOC_VERSION ;
   A_IS_TEMPLATE          (L_FETCHED_ROWS) := L_IS_TEMPLATE ;
   A_CONFIRM_USERID       (L_FETCHED_ROWS) := L_CONFIRM_USERID ;
   A_NR_PLANNED_SD        (L_FETCHED_ROWS) := L_NR_PLANNED_SD ;
   A_FREQ_TP              (L_FETCHED_ROWS) := L_FREQ_TP ;
   A_FREQ_VAL             (L_FETCHED_ROWS) := L_FREQ_VAL ;
   A_FREQ_UNIT            (L_FETCHED_ROWS) := L_FREQ_UNIT ;
   A_INVERT_FREQ          (L_FETCHED_ROWS) := L_INVERT_FREQ ;
   A_LAST_SCHED           (L_FETCHED_ROWS) := L_LAST_SCHED ;
   A_LAST_CNT             (L_FETCHED_ROWS) := L_LAST_CNT ;
   A_LAST_VAL             (L_FETCHED_ROWS) := L_LAST_VAL ;
   A_LABEL_FORMAT         (L_FETCHED_ROWS) := L_LABEL_FORMAT ;
   A_PLANNED_RESPONSIBLE  (L_FETCHED_ROWS) := L_PLANNED_RESPONSIBLE ;
   A_SD_UC                (L_FETCHED_ROWS) := L_SD_UC ;
   A_SD_UC_VERSION        (L_FETCHED_ROWS) := L_SD_UC_VERSION ;
   A_SD_LC                (L_FETCHED_ROWS) := L_SD_LC ;
   A_SD_LC_VERSION        (L_FETCHED_ROWS) := L_SD_LC_VERSION ;
   A_INHERIT_AU           (L_FETCHED_ROWS) := L_INHERIT_AU ;
   A_INHERIT_GK           (L_FETCHED_ROWS) := L_INHERIT_GK ;
   A_PT_CLASS             (L_FETCHED_ROWS) := L_PT_CLASS ;
   A_LOG_HS               (L_FETCHED_ROWS) := L_LOG_HS ;
   A_ALLOW_MODIFY         (L_FETCHED_ROWS) := L_ALLOW_MODIFY ;
   A_ACTIVE               (L_FETCHED_ROWS) := L_ACTIVE ;
   A_LC                   (L_FETCHED_ROWS) := L_LC ;
   A_LC_VERSION           (L_FETCHED_ROWS) := L_LC_VERSION ;
   A_SS                   (L_FETCHED_ROWS) := L_SS ;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_PT_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_PT_CURSOR);

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
              'GetProtocol', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (L_PT_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_PT_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPROTOCOL;


FUNCTION SELECTPROTOCOL
(A_COL_ID              IN   UNAPIGEN.VC40_TABLE_TYPE,     
 A_COL_TP              IN   UNAPIGEN.VC40_TABLE_TYPE,     
 A_COL_VALUE           IN   UNAPIGEN.VC40_TABLE_TYPE,     
 A_COL_NR_OF_ROWS      IN   NUMBER,                       
 A_PT                  OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_VERSION             OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_VERSION_IS_CURRENT  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_EFFECTIVE_FROM      OUT  UNAPIGEN.DATE_TABLE_TYPE,     
 A_EFFECTIVE_TILL      OUT  UNAPIGEN.DATE_TABLE_TYPE,     
 A_DESCRIPTION         OUT  UNAPIGEN.VC40_TABLE_TYPE,     
 A_DESCRIPTION2        OUT  UNAPIGEN.VC40_TABLE_TYPE,     
 A_DESCR_DOC           OUT  UNAPIGEN.VC40_TABLE_TYPE,     
 A_DESCR_DOC_VERSION   OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_IS_TEMPLATE         OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_CONFIRM_USERID      OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_NR_PLANNED_SD       OUT  UNAPIGEN.NUM_TABLE_TYPE,      
 A_FREQ_TP             OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_FREQ_VAL            OUT  UNAPIGEN.NUM_TABLE_TYPE,      
 A_FREQ_UNIT           OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_INVERT_FREQ         OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_LAST_SCHED          OUT  UNAPIGEN.DATE_TABLE_TYPE,     
 A_LAST_CNT            OUT  UNAPIGEN.NUM_TABLE_TYPE,      
 A_LAST_VAL            OUT  UNAPIGEN.VC40_TABLE_TYPE,     
 A_LABEL_FORMAT        OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_PLANNED_RESPONSIBLE OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_SD_UC               OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_SD_UC_VERSION       OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_SD_LC               OUT  UNAPIGEN.VC2_TABLE_TYPE,      
 A_SD_LC_VERSION       OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_INHERIT_AU          OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_INHERIT_GK          OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_PT_CLASS            OUT  UNAPIGEN.VC2_TABLE_TYPE,      
 A_LOG_HS              OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_ALLOW_MODIFY        OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_ACTIVE              OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_LC                  OUT  UNAPIGEN.VC2_TABLE_TYPE,      
 A_LC_VERSION          OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_SS                  OUT  UNAPIGEN.VC2_TABLE_TYPE,      
 A_NR_OF_ROWS          IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE     IN   VARCHAR2,                     
 A_NEXT_ROWS           IN   NUMBER)                       
RETURN NUMBER IS

L_COL_OPERATOR           UNAPIGEN.VC20_TABLE_TYPE;
L_COL_ANDOR              UNAPIGEN.VC3_TABLE_TYPE;

BEGIN

   FOR L_X IN 1..A_COL_NR_OF_ROWS LOOP
       L_COL_OPERATOR(L_X) := '=';
       L_COL_ANDOR(L_X) := 'AND';
   END LOOP;

   RETURN(UNAPIPT.SELECTPROTOCOL(A_COL_ID,
                               A_COL_TP,
                               A_COL_VALUE,
                               L_COL_OPERATOR,
                               L_COL_ANDOR,
                               A_COL_NR_OF_ROWS,
                               A_PT,
                               A_VERSION,
                               A_VERSION_IS_CURRENT,
                               A_EFFECTIVE_FROM,
                               A_EFFECTIVE_TILL,
                               A_DESCRIPTION,
                               A_DESCRIPTION2,
                               A_DESCR_DOC,
                               A_DESCR_DOC_VERSION,
                               A_IS_TEMPLATE,
                               A_CONFIRM_USERID,
                               A_NR_PLANNED_SD,
                               A_FREQ_TP,
                               A_FREQ_VAL,
                               A_FREQ_UNIT,
                               A_INVERT_FREQ,
                               A_LAST_SCHED,
                               A_LAST_CNT,
                               A_LAST_VAL,
                               A_LABEL_FORMAT,
                               A_PLANNED_RESPONSIBLE,
                               A_SD_UC,
                               A_SD_UC_VERSION,
                               A_SD_LC,
                               A_SD_LC_VERSION,
                               A_INHERIT_AU,
                               A_INHERIT_GK,
                               A_PT_CLASS,
                               A_LOG_HS,
                               A_ALLOW_MODIFY,
                               A_ACTIVE,
                               A_LC,
                               A_LC_VERSION,
                               A_SS,
                               A_NR_OF_ROWS,
                               A_ORDER_BY_CLAUSE,
                               A_NEXT_ROWS));              
END SELECTPROTOCOL;

FUNCTION SELECTPROTOCOL
(A_COL_ID              IN   UNAPIGEN.VC40_TABLE_TYPE,     
 A_COL_TP              IN   UNAPIGEN.VC40_TABLE_TYPE,     
 A_COL_VALUE           IN   UNAPIGEN.VC40_TABLE_TYPE,     
 A_COL_OPERATOR        IN   UNAPIGEN.VC20_TABLE_TYPE,     
 A_COL_ANDOR           IN   UNAPIGEN.VC3_TABLE_TYPE,      
 A_COL_NR_OF_ROWS      IN   NUMBER,                       
 A_PT                  OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_VERSION             OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_VERSION_IS_CURRENT  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_EFFECTIVE_FROM      OUT  UNAPIGEN.DATE_TABLE_TYPE,     
 A_EFFECTIVE_TILL      OUT  UNAPIGEN.DATE_TABLE_TYPE,     
 A_DESCRIPTION         OUT  UNAPIGEN.VC40_TABLE_TYPE,     
 A_DESCRIPTION2        OUT  UNAPIGEN.VC40_TABLE_TYPE,     
 A_DESCR_DOC           OUT  UNAPIGEN.VC40_TABLE_TYPE,     
 A_DESCR_DOC_VERSION   OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_IS_TEMPLATE         OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_CONFIRM_USERID      OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_NR_PLANNED_SD       OUT  UNAPIGEN.NUM_TABLE_TYPE,      
 A_FREQ_TP             OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_FREQ_VAL            OUT  UNAPIGEN.NUM_TABLE_TYPE,      
 A_FREQ_UNIT           OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_INVERT_FREQ         OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_LAST_SCHED          OUT  UNAPIGEN.DATE_TABLE_TYPE,     
 A_LAST_CNT            OUT  UNAPIGEN.NUM_TABLE_TYPE,      
 A_LAST_VAL            OUT  UNAPIGEN.VC40_TABLE_TYPE,     
 A_LABEL_FORMAT        OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_PLANNED_RESPONSIBLE OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_SD_UC               OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_SD_UC_VERSION       OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_SD_LC               OUT  UNAPIGEN.VC2_TABLE_TYPE,      
 A_SD_LC_VERSION       OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_INHERIT_AU          OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_INHERIT_GK          OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_PT_CLASS            OUT  UNAPIGEN.VC2_TABLE_TYPE,      
 A_LOG_HS              OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_ALLOW_MODIFY        OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_ACTIVE              OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    
 A_LC                  OUT  UNAPIGEN.VC2_TABLE_TYPE,      
 A_LC_VERSION          OUT  UNAPIGEN.VC20_TABLE_TYPE,     
 A_SS                  OUT  UNAPIGEN.VC2_TABLE_TYPE,      
 A_NR_OF_ROWS          IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE     IN   VARCHAR2,                     
 A_NEXT_ROWS           IN   NUMBER)                       
RETURN NUMBER IS

L_PT                             VARCHAR2(20);
L_VERSION                        VARCHAR2(20);
L_VERSION_IS_CURRENT             CHAR(1);
L_EFFECTIVE_FROM                 TIMESTAMP WITH TIME ZONE;
L_EFFECTIVE_TILL                 TIMESTAMP WITH TIME ZONE;
L_DESCRIPTION                    VARCHAR2(40);
L_DESCRIPTION2                   VARCHAR2(40);
L_DESCR_DOC                      VARCHAR2(40);
L_DESCR_DOC_VERSION              VARCHAR2(20);
L_IS_TEMPLATE                    CHAR(1);
L_CONFIRM_USERID                 CHAR(1);
L_NR_PLANNED_SD                  NUMBER;
L_FREQ_TP                        CHAR(1);
L_FREQ_VAL                       NUMBER;
L_FREQ_UNIT                      VARCHAR2(20);
L_INVERT_FREQ                    CHAR(1);
L_LAST_SCHED                     TIMESTAMP WITH TIME ZONE;
L_LAST_CNT                       NUMBER;
L_LAST_VAL                       VARCHAR2(40);
L_LABEL_FORMAT                   VARCHAR2(20);
L_PLANNED_RESPONSIBLE            VARCHAR2(20);
L_SD_UC                          VARCHAR2(20);
L_SD_UC_VERSION                  VARCHAR2(20);
L_SD_LC                          VARCHAR2(2);
L_SD_LC_VERSION                  VARCHAR2(20);
L_INHERIT_AU                     CHAR(1);
L_INHERIT_GK                     CHAR(1);
L_PT_CLASS                       VARCHAR2(2);
L_LOG_HS                         CHAR(1);
L_ALLOW_MODIFY                   CHAR(1);
L_ACTIVE                         CHAR(1);
L_LC                             VARCHAR2(2);
L_LC_VERSION                     VARCHAR2(20);
L_SS                             VARCHAR2(2);

L_ORDER_BY_CLAUSE                VARCHAR2(255);
L_FROM_CLAUSE                    VARCHAR2(255);
L_NEXT_PTGK_JOIN                 VARCHAR2(4);
L_NEXT_PT_JOIN                   VARCHAR2(4);
L_PT_CURSOR                      INTEGER;
L_COLUMN_HANDLED                 BOOLEAN_TABLE_TYPE;
L_ANYOR_PRESENT                  BOOLEAN;
L_COL_ANDOR                      VARCHAR2(3);
L_PREV_COL_TP                    VARCHAR2(40);
L_PREV_COL_ID                    VARCHAR2(40);
L_PREV_COL_INDEX                 INTEGER;
L_WHERE_CLAUSE4JOIN              VARCHAR2(1000);
L_LENGTH                         INTEGER;

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
      IF P_SELECTPT_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_SELECTPT_CURSOR);
         P_SELECTPT_CURSOR := NULL;
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;
   
   
   IF A_NEXT_ROWS = 1 THEN
      IF P_SELECTPT_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN
      P_SELECTION_VAL_TAB.DELETE;
      L_SQL_STRING := 'SELECT a.pt, a.version, nvl(a.version_is_current,''0''), a.effective_from, '||
         'a.effective_till, a.description, a.description2, a.descr_doc, a.descr_doc_version, a.is_template, a.confirm_userid, '||
         'a.nr_planned_sd, a.freq_tp, a.freq_val, a.freq_unit, a.invert_freq, a.last_sched, a.last_cnt, a.last_val, '||
         'a.label_format, a.planned_responsible, a.sd_uc, a.sd_uc_version, a.sd_lc, a.sd_lc_version, a.inherit_au, '||
         'a.inherit_gk, a.pt_class, a.log_hs, a.allow_modify, a.active, a.lc, a.lc_version, a.ss FROM ';
      L_FROM_CLAUSE := 'dd' || UNAPIGEN.P_DD || '.uvpt a ' ;

      
      L_WHERE_CLAUSE4JOIN := '';
      L_WHERE_CLAUSE := '';
      L_ANYOR_PRESENT := FALSE;

      FOR I IN 1..A_COL_NR_OF_ROWS LOOP
         L_COLUMN_HANDLED(I) := FALSE;
         IF LTRIM(RTRIM(UPPER(A_COL_ANDOR(I)))) = 'OR' AND
            NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
            L_ANYOR_PRESENT := TRUE;
         END IF;
         
         
         IF I<>1 THEN
            IF NVL(A_COL_TP(I), ' ') = NVL(A_COL_TP(I-1), ' ') AND
               NVL(A_COL_ID(I), ' ') = NVL(A_COL_ID(I-1), ' ') AND
               NVL(A_COL_OPERATOR(I), '=') = '=' AND
               NVL(A_COL_OPERATOR(I-1), '=') = '=' AND
               NVL(A_COL_ANDOR(I-1), 'AND') =  'AND' AND
               (NVL(A_COL_VALUE(I), ' ') <> ' ' OR NVL(A_COL_VALUE(I-1), ' ') <> ' ') THEN
               IF I> 2 AND A_COL_ANDOR(I-2) = 'OR' THEN
                  L_ANYOR_PRESENT := TRUE;
               END IF;
            END IF;
         END IF;         
      END LOOP;
      
      
      
      L_NEXT_PTGK_JOIN := 'a';
      L_NEXT_PT_JOIN := 'a';

      FOR I IN REVERSE 1..A_COL_NR_OF_ROWS LOOP
         IF NVL(LTRIM(A_COL_ID(I)), ' ') = ' ' THEN
            RETURN(UNAPIGEN.DBERR_SELCOLSINVALID);
         END IF;

         
         L_COL_ANDOR := 'AND';
         IF I<>1 THEN
            L_COL_ANDOR := A_COL_ANDOR(I-1);
         END IF;
         IF L_COL_ANDOR IS NULL THEN
            
            L_COL_ANDOR := 'AND';
         END IF;
         IF L_COLUMN_HANDLED(I) = FALSE THEN
            IF NVL(A_COL_TP(I), ' ') = 'ptgk' THEN
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utpt', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                   A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                   A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                   A_JOINTABLE_PREFIX => 'utptgk', A_JOINCOLUMN1 => 'pt', A_JOINCOLUMN2 => 'version', 
                                   A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                   A_NEXTTABLE_TOJOIN => L_NEXT_PTGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                   A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                   A_SQL_VAL_TAB => P_SELECTION_VAL_TAB);                 
               ELSIF INSTR(A_ORDER_BY_CLAUSE, 't'|| TO_CHAR(I)) <> 0 THEN
                  L_FROM_CLAUSE := L_FROM_CLAUSE || ', utptgk' || A_COL_ID(I) || ' t' || I;
                  L_COL_ANDOR := 'AND'; 
                  
                  L_WHERE_CLAUSE4JOIN := L_WHERE_CLAUSE4JOIN ||
                                    't' || I || '.pt(+) = a.pt AND t' || I || '.version(+) = a.version ' || L_COL_ANDOR || ' ';
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSE
               
               IF (LOWER(NVL(A_COL_ID(I),' ')) = 'version') AND (NVL(A_COL_VALUE(I),' ') = 'MAX') THEN
                  L_WHERE_CLAUSE := L_WHERE_CLAUSE || '(a.pt, a.' || A_COL_ID(I) || ') ' ||
                                    'IN (SELECT pt, MAX(' || A_COL_ID(I) || ') '|| 
                                        'FROM dd'|| UNAPIGEN.P_DD ||'.uvpt GROUP BY pt) '||
                                    L_COL_ANDOR|| ' '; 
               ELSIF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utpt', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                   A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                   A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                   A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                   A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                   A_NEXTTABLE_TOJOIN => L_NEXT_PT_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                   A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                   A_SQL_VAL_TAB => P_SELECTION_VAL_TAB);                 
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            END IF;      
         END IF;
      END LOOP;

      
      IF SUBSTR(L_WHERE_CLAUSE4JOIN, -4) = 'AND ' THEN
         L_WHERE_CLAUSE4JOIN := SUBSTR(L_WHERE_CLAUSE4JOIN, 1,
                                  LENGTH(L_WHERE_CLAUSE4JOIN)-4);
      END IF;
      
      
      IF SUBSTR(L_WHERE_CLAUSE, -4) = 'AND ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-4);
      END IF;
      IF UPPER(SUBSTR(L_WHERE_CLAUSE, -4)) = ' OR ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-3);
      END IF;
   
      IF L_WHERE_CLAUSE4JOIN IS NOT NULL THEN
         IF L_WHERE_CLAUSE IS NULL THEN
            L_WHERE_CLAUSE := ' WHERE ' || L_WHERE_CLAUSE4JOIN;
         ELSE
            L_WHERE_CLAUSE := ' WHERE (' || L_WHERE_CLAUSE4JOIN || ') AND ('||L_WHERE_CLAUSE||') ';
         END IF;
      ELSE
         IF L_WHERE_CLAUSE IS NOT NULL THEN
            L_WHERE_CLAUSE := ' WHERE '||L_WHERE_CLAUSE;
         ELSE
            L_WHERE_CLAUSE := ' ';
         END IF;
      END IF;
   
      IF NVL(A_ORDER_BY_CLAUSE, ' ') = ' ' THEN
         L_ORDER_BY_CLAUSE := ' ORDER BY a.pt, a.version';
      ELSE
         L_ORDER_BY_CLAUSE := A_ORDER_BY_CLAUSE; 
      END IF;

      L_SQL_STRING := L_SQL_STRING || L_FROM_CLAUSE || L_WHERE_CLAUSE || L_ORDER_BY_CLAUSE;
      P_SELECTION_CLAUSE := L_FROM_CLAUSE || L_WHERE_CLAUSE;

      IF P_SELECTPT_CURSOR IS NULL THEN
         P_SELECTPT_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;
      
      UNAPIAUT.ADDORACLECBOHINT (L_SQL_STRING) ;
      DBMS_SQL.PARSE(P_SELECTPT_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      FOR L_X IN 1..P_SELECTION_VAL_TAB.COUNT() LOOP
         DBMS_SQL.BIND_VARIABLE(P_SELECTPT_CURSOR, ':col_val'||L_X , P_SELECTION_VAL_TAB(L_X)); 
      END LOOP;
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      1 ,  L_PT                  , 20 ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      2 ,  L_VERSION             , 20 ); 
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTPT_CURSOR, 3 ,  L_VERSION_IS_CURRENT  , 1  ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      4 ,  L_EFFECTIVE_FROM           );
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      5 ,  L_EFFECTIVE_TILL           );
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      6 ,  L_DESCRIPTION         , 40 ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      7 ,  L_DESCRIPTION2        , 40 ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      8 ,  L_DESCR_DOC           , 40 ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      9 ,  L_DESCR_DOC_VERSION   , 20 ); 
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTPT_CURSOR, 10,  L_IS_TEMPLATE         , 1  ); 
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTPT_CURSOR, 11,  L_CONFIRM_USERID      , 1  ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      12,  L_NR_PLANNED_SD            );
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTPT_CURSOR, 13,  L_FREQ_TP             , 1  ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      14,  L_FREQ_VAL                 );
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      15,  L_FREQ_UNIT           , 20 ); 
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTPT_CURSOR, 16,  L_INVERT_FREQ         , 1  ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      17,  L_LAST_SCHED               );
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      18,  L_LAST_CNT                 );
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      19,  L_LAST_VAL            , 40 ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      20,  L_LABEL_FORMAT        , 20 ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      21,  L_PLANNED_RESPONSIBLE , 20 ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      22,  L_SD_UC               , 20 ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      23,  L_SD_UC_VERSION       , 20 );      
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      24,  L_SD_LC               , 2  );            
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      25,  L_SD_LC_VERSION       , 20 );      
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTPT_CURSOR, 26,  L_INHERIT_AU          , 1  ); 
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTPT_CURSOR, 27,  L_INHERIT_GK          , 1  ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      28,  L_PT_CLASS            ,  2   );
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTPT_CURSOR, 29,  L_LOG_HS              , 1  ); 
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTPT_CURSOR, 30,  L_ALLOW_MODIFY        , 1  ); 
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTPT_CURSOR, 31,  L_ACTIVE              , 1  ); 
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      32,  L_LC                  , 2  );  
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPT_CURSOR,      33,  L_LC_VERSION          , 20 ); 
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_SELECTPT_CURSOR, 34,  L_SS                  , 2  );  

      L_RESULT := DBMS_SQL.EXECUTE(P_SELECTPT_CURSOR);
   END IF;
   
   L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTPT_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       1 ,   L_PT                  );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       2 ,   L_VERSION             );
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTPT_CURSOR,  3 ,   L_VERSION_IS_CURRENT  );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       4 ,   L_EFFECTIVE_FROM      );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       5 ,   L_EFFECTIVE_TILL      );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       6 ,   L_DESCRIPTION         );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       7 ,   L_DESCRIPTION2        );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       8 ,   L_DESCR_DOC           );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       9 ,   L_DESCR_DOC_VERSION   );
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTPT_CURSOR,  10,   L_IS_TEMPLATE         );
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTPT_CURSOR,  11,   L_CONFIRM_USERID      );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       12,   L_NR_PLANNED_SD       );
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTPT_CURSOR,  13,   L_FREQ_TP             );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       14,   L_FREQ_VAL            );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       15,   L_FREQ_UNIT           );
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTPT_CURSOR,  16,   L_INVERT_FREQ         );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       17,   L_LAST_SCHED          );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       18,   L_LAST_CNT            );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       19,   L_LAST_VAL            );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       20,   L_LABEL_FORMAT        );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       21,   L_PLANNED_RESPONSIBLE );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       22,   L_SD_UC               );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       23,   L_SD_UC_VERSION       );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       24,   L_SD_LC               );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       25,   L_SD_LC_VERSION       ); 
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTPT_CURSOR,  26,   L_INHERIT_AU          );
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTPT_CURSOR,  27,   L_INHERIT_GK          );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       28,   L_PT_CLASS            );
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTPT_CURSOR,  29,   L_LOG_HS              );
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTPT_CURSOR,  30,   L_ALLOW_MODIFY        );
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTPT_CURSOR,  31,   L_ACTIVE              );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       32,   L_LC                  );
      DBMS_SQL.COLUMN_VALUE(P_SELECTPT_CURSOR,       33,   L_LC_VERSION          );
      DBMS_SQL.COLUMN_VALUE_CHAR(P_SELECTPT_CURSOR,  34,   L_SS                  );
      
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_PT                   (L_FETCHED_ROWS) := L_PT                     ;
      A_VERSION              (L_FETCHED_ROWS) := L_VERSION                ;
      A_VERSION_IS_CURRENT   (L_FETCHED_ROWS) := L_VERSION_IS_CURRENT     ;
      A_EFFECTIVE_FROM       (L_FETCHED_ROWS) := L_EFFECTIVE_FROM         ;
      A_EFFECTIVE_TILL       (L_FETCHED_ROWS) := L_EFFECTIVE_TILL         ;
      A_DESCRIPTION          (L_FETCHED_ROWS) := L_DESCRIPTION            ;
      A_DESCRIPTION2         (L_FETCHED_ROWS) := L_DESCRIPTION2           ;
      A_DESCR_DOC            (L_FETCHED_ROWS) := L_DESCR_DOC              ;
      A_DESCR_DOC_VERSION    (L_FETCHED_ROWS) := L_DESCR_DOC_VERSION      ;
      A_IS_TEMPLATE          (L_FETCHED_ROWS) := L_IS_TEMPLATE            ;
      A_CONFIRM_USERID       (L_FETCHED_ROWS) := L_CONFIRM_USERID         ;
      A_NR_PLANNED_SD        (L_FETCHED_ROWS) := L_NR_PLANNED_SD          ;
      A_FREQ_TP              (L_FETCHED_ROWS) := L_FREQ_TP                ;
      A_FREQ_VAL             (L_FETCHED_ROWS) := L_FREQ_VAL               ;
      A_FREQ_UNIT            (L_FETCHED_ROWS) := L_FREQ_UNIT              ;
      A_INVERT_FREQ          (L_FETCHED_ROWS) := L_INVERT_FREQ            ;
      A_LAST_SCHED           (L_FETCHED_ROWS) := L_LAST_SCHED             ;
      A_LAST_CNT             (L_FETCHED_ROWS) := L_LAST_CNT               ;
      A_LAST_VAL             (L_FETCHED_ROWS) := L_LAST_VAL               ;
      A_LABEL_FORMAT         (L_FETCHED_ROWS) := L_LABEL_FORMAT           ;
      A_PLANNED_RESPONSIBLE  (L_FETCHED_ROWS) := L_PLANNED_RESPONSIBLE    ;
      A_SD_UC                (L_FETCHED_ROWS) := L_SD_UC                  ;
      A_SD_UC_VERSION        (L_FETCHED_ROWS) := L_SD_UC_VERSION          ;
      A_SD_LC                (L_FETCHED_ROWS) := L_SD_LC                  ;
      A_SD_LC_VERSION        (L_FETCHED_ROWS) := L_SD_LC_VERSION          ;
      A_INHERIT_AU           (L_FETCHED_ROWS) := L_INHERIT_AU             ;
      A_INHERIT_GK           (L_FETCHED_ROWS) := L_INHERIT_GK             ;
      A_PT_CLASS             (L_FETCHED_ROWS) := L_PT_CLASS               ;
      A_LOG_HS               (L_FETCHED_ROWS) := L_LOG_HS                 ;
      A_ALLOW_MODIFY         (L_FETCHED_ROWS) := L_ALLOW_MODIFY           ;
      A_ACTIVE               (L_FETCHED_ROWS) := L_ACTIVE                 ;
      A_LC                   (L_FETCHED_ROWS) := L_LC                     ;
      A_LC_VERSION           (L_FETCHED_ROWS) := L_LC_VERSION             ;
      A_SS                   (L_FETCHED_ROWS) := L_SS                     ;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTPT_CURSOR);
      END IF;
   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
       DBMS_SQL.CLOSE_CURSOR(P_SELECTPT_CURSOR);
       P_SELECTPT_CURSOR := NULL;
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_SELECTPT_CURSOR);
      P_SELECTPT_CURSOR := NULL;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
              'SelectProtocol', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'SelectProtocol', '(SQL)'||SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));             
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_SELECTPT_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_SELECTPT_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END SELECTPROTOCOL;

FUNCTION SELECTPTGKVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_GK               IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS
L_COL_OPERATOR           UNAPIGEN.VC20_TABLE_TYPE;
L_COL_ANDOR              UNAPIGEN.VC3_TABLE_TYPE;
BEGIN
   FOR L_X IN 1..A_COL_NR_OF_ROWS LOOP
       L_COL_OPERATOR(L_X) := '=';
       L_COL_ANDOR(L_X) := 'AND';
   END LOOP;
   RETURN(UNAPIPT.SELECTPTGKVALUES(A_COL_ID,
                                    A_COL_TP,
                                    A_COL_VALUE,
                                    L_COL_OPERATOR,
                                    L_COL_ANDOR,
                                    A_COL_NR_OF_ROWS,
                                    A_GK,
                                    A_VALUE,
                                    A_NR_OF_ROWS,
                                    A_ORDER_BY_CLAUSE,
                                    A_NEXT_ROWS));
END SELECTPTGKVALUES;

FUNCTION SELECTPTGKVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_OPERATOR     IN      UNAPIGEN.VC20_TABLE_TYPE,  
 A_COL_ANDOR        IN      UNAPIGEN.VC3_TABLE_TYPE,   
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_GK               IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS

L_VALUE                          VARCHAR2(40);
L_ORDER_BY_CLAUSE                VARCHAR2(255);
L_FROM_CLAUSE                    VARCHAR2(500);
L_NEXT_PT_JOIN                   VARCHAR2(4);
L_NEXT_PTGK_JOIN                 VARCHAR2(4);
L_NEXT_SD_JOIN                   VARCHAR2(4);
L_NEXT_SDGK_JOIN                 VARCHAR2(4);
L_COLUMN_HANDLED                 BOOLEAN_TABLE_TYPE;
L_ANYOR_PRESENT                  BOOLEAN;
L_COL_ANDOR                      VARCHAR2(3);
L_PREV_COL_TP                    VARCHAR2(40);
L_PREV_COL_ID                    VARCHAR2(40);
L_PREV_COL_INDEX                 INTEGER;
L_WHERE_CLAUSE4JOIN              VARCHAR2(2000);
L_LENGTH                         INTEGER;
L_SQL_VAL_TAB                    VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

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
      IF P_SELECTPTGK_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_SELECTPTGK_CURSOR);
         P_SELECTPTGK_CURSOR := NULL;
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_SELECTPTGK_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;
   
   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN
   
      
      L_SQL_STRING := 'SELECT DISTINCT b.' || A_GK || ' FROM ';
      L_FROM_CLAUSE := 'dd' || UNAPIGEN.P_DD || '.uvpt a, utptgk' || A_GK || ' b';

      
      L_WHERE_CLAUSE4JOIN := 'a.pt = b.pt AND '||
                        'a.version = b.version AND '; 
      L_WHERE_CLAUSE := '';
      L_ANYOR_PRESENT := FALSE;
      FOR I IN 1..A_COL_NR_OF_ROWS LOOP
         L_COLUMN_HANDLED(I) := FALSE;
         IF LTRIM(RTRIM(UPPER(A_COL_ANDOR(I)))) = 'OR' AND
            NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
            L_ANYOR_PRESENT := TRUE;
         END IF;
         
         
         IF I<>1 THEN
            IF NVL(A_COL_TP(I), ' ') = NVL(A_COL_TP(I-1), ' ') AND
               NVL(A_COL_ID(I), ' ') = NVL(A_COL_ID(I-1), ' ') AND
               NVL(A_COL_OPERATOR(I), '=') = '=' AND
               NVL(A_COL_OPERATOR(I-1), '=') = '=' AND
               NVL(A_COL_ANDOR(I-1), 'AND') =  'AND' AND
               (NVL(A_COL_VALUE(I), ' ') <> ' ' OR NVL(A_COL_VALUE(I-1), ' ') <> ' ') THEN
               IF I> 2 AND A_COL_ANDOR(I-2) = 'OR' THEN
                  L_ANYOR_PRESENT := TRUE;
               END IF;
            END IF;
         END IF;         
      END LOOP;
      
      
      
      L_NEXT_PT_JOIN := 'a';
      L_NEXT_PTGK_JOIN := 'b';
      L_NEXT_SDGK_JOIN := 'sd';
      L_NEXT_SD_JOIN := 'sd';

      FOR I IN REVERSE 1..A_COL_NR_OF_ROWS LOOP
         IF NVL(LTRIM(A_COL_ID(I)), ' ') = ' ' THEN
            RETURN(UNAPIGEN.DBERR_SELCOLSINVALID);
         END IF;

         
         L_COL_ANDOR := 'AND';
         IF I<>1 THEN
            L_COL_ANDOR := A_COL_ANDOR(I-1);
         END IF;
         IF L_COL_ANDOR IS NULL THEN
            
            L_COL_ANDOR := 'AND';
         END IF;

         IF L_COLUMN_HANDLED(I) = FALSE THEN
            IF NVL(A_COL_TP(I), ' ') = 'ptgk' THEN 
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utpt', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => 'utptgk', A_JOINCOLUMN1 => 'pt', A_JOINCOLUMN2 => 'version', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_PTGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSIF NVL(A_COL_TP(I), ' ') = 'sdgk' THEN 
               IF INSTR(L_FROM_CLAUSE, '.uvsd sd') = 0 THEN
                  L_FROM_CLAUSE := L_FROM_CLAUSE || ', dd' || UNAPIGEN.P_DD || '.uvsd sd' ;
                  L_WHERE_CLAUSE4JOIN := L_WHERE_CLAUSE4JOIN || 'sd.pt = b.pt AND '|| 
                                    'sd.pt_version = b.version AND '; 
               ELSIF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsd', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => 'utsdgk', A_JOINCOLUMN1 => 'sd', A_JOINCOLUMN2 => '', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_SDGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_BASETABLE4GK_ALIAS => 'sd',
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSIF NVL(A_COL_TP(I), ' ') = 'sd' THEN 
               IF INSTR(L_FROM_CLAUSE, '.uvsd sd') = 0 THEN
                  L_FROM_CLAUSE := L_FROM_CLAUSE || ', dd' || UNAPIGEN.P_DD || '.uvsd sd' ;
                  L_WHERE_CLAUSE4JOIN := L_WHERE_CLAUSE4JOIN || 'sd.pt = b.pt AND '|| 
                                    'sd.pt_version = b.version AND '; 
               END IF;
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsd', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_SD_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_BASETABLE4GK_ALIAS => 'sd',
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSE 
               IF (LOWER(NVL(A_COL_ID(I),' ')) = 'version') AND (NVL(A_COL_VALUE(I),' ') = 'MAX') THEN
                  L_WHERE_CLAUSE := L_WHERE_CLAUSE || '(a.pt, a.' || A_COL_ID(I) || ') ' ||
                                    'IN (SELECT pt, MAX(' || A_COL_ID(I) || ') '|| 
                                        'FROM dd'|| UNAPIGEN.P_DD ||'.uvpt GROUP BY pt) '||
                                        L_COL_ANDOR|| ' '; 
               ELSIF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utpt', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                   A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                   A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                   A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                   A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                   A_NEXTTABLE_TOJOIN => L_NEXT_PT_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                   A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                   A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            END IF;
         END IF;
      END LOOP;
      
      
      IF SUBSTR(L_WHERE_CLAUSE4JOIN, -4) = 'AND ' THEN
         L_WHERE_CLAUSE4JOIN := SUBSTR(L_WHERE_CLAUSE4JOIN, 1,
                                  LENGTH(L_WHERE_CLAUSE4JOIN)-4);
      END IF;
      
      
      IF SUBSTR(L_WHERE_CLAUSE, -4) = 'AND ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-4);
      END IF;
      IF UPPER(SUBSTR(L_WHERE_CLAUSE, -4)) = ' OR ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-3);
      END IF;
      
      IF L_WHERE_CLAUSE4JOIN IS NOT NULL THEN
         IF L_WHERE_CLAUSE IS NULL THEN
            L_WHERE_CLAUSE := ' WHERE ' || L_WHERE_CLAUSE4JOIN;
         ELSE
            L_WHERE_CLAUSE := ' WHERE (' || L_WHERE_CLAUSE4JOIN || ') AND ('||L_WHERE_CLAUSE||') ';
         END IF;
      ELSE
         IF L_WHERE_CLAUSE IS NOT NULL THEN
            L_WHERE_CLAUSE := ' WHERE '||L_WHERE_CLAUSE;
         ELSE
            L_WHERE_CLAUSE := ' ';
         END IF;
      END IF;

      L_ORDER_BY_CLAUSE := NVL(A_ORDER_BY_CLAUSE, ' ORDER BY 1');

      L_SQL_STRING := L_SQL_STRING || L_FROM_CLAUSE || L_WHERE_CLAUSE || L_ORDER_BY_CLAUSE;

      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            
                      
      IF P_SELECTPTGK_CURSOR IS NULL THEN 
         P_SELECTPTGK_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;

      UNAPIAUT.ADDORACLECBOHINT (L_SQL_STRING) ;
      DBMS_SQL.PARSE(P_SELECTPTGK_CURSOR, L_SQL_STRING, DBMS_SQL.V7);    
      FOR L_X IN 1..L_SQL_VAL_TAB.COUNT() LOOP
         DBMS_SQL.BIND_VARIABLE(P_SELECTPTGK_CURSOR, ':col_val'||L_X , L_SQL_VAL_TAB(L_X)); 
      END LOOP;
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPTGK_CURSOR, 1, L_VALUE, 40);
      L_RESULT := DBMS_SQL.EXECUTE(P_SELECTPTGK_CURSOR);

   END IF;
   
   L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTPTGK_CURSOR);
   L_FETCHED_ROWS := 0;
   
   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;
      DBMS_SQL.COLUMN_VALUE(P_SELECTPTGK_CURSOR, 1, L_VALUE);
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
   
      A_VALUE(L_FETCHED_ROWS) := L_VALUE;
   
      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTPTGK_CURSOR);
      END IF;
   END LOOP;
   
   
   IF (L_FETCHED_ROWS = 0) THEN
       DBMS_SQL.CLOSE_CURSOR(P_SELECTPTGK_CURSOR);
       P_SELECTPTGK_CURSOR := NULL;
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_SELECTPTGK_CURSOR);
      P_SELECTPTGK_CURSOR := NULL;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
   
EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
              'SelectPtGkValues', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'SelectPtGkValues', '(SQL)'||SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));             
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQLERRM) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQLERRM, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_SELECTPTGK_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_SELECTPTGK_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END SELECTPTGKVALUES;

FUNCTION SELECTPTPROPVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_PROP             IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS
L_COL_OPERATOR           UNAPIGEN.VC20_TABLE_TYPE;
L_COL_ANDOR              UNAPIGEN.VC3_TABLE_TYPE;
BEGIN
FOR L_X IN 1..A_COL_NR_OF_ROWS LOOP
    L_COL_OPERATOR(L_X) := '=';
    L_COL_ANDOR(L_X) := 'AND';
END LOOP;
 RETURN(UNAPIPT.SELECTPTPROPVALUES(A_COL_ID,
                                 A_COL_TP,
                                 A_COL_VALUE,
                                 L_COL_OPERATOR,
                                 L_COL_ANDOR,
                                 A_COL_NR_OF_ROWS,
                                 A_PROP,
                                 A_VALUE,
                                 A_NR_OF_ROWS,
                                 A_ORDER_BY_CLAUSE,
                                 A_NEXT_ROWS));
END SELECTPTPROPVALUES;

FUNCTION SELECTPTPROPVALUES
(A_COL_ID           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_TP           IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_VALUE        IN      UNAPIGEN.VC40_TABLE_TYPE,  
 A_COL_OPERATOR     IN      UNAPIGEN.VC20_TABLE_TYPE,  
 A_COL_ANDOR        IN      UNAPIGEN.VC3_TABLE_TYPE,   
 A_COL_NR_OF_ROWS   IN      NUMBER,                    
 A_PROP             IN      VARCHAR2,                  
 A_VALUE            OUT     UNAPIGEN.VC40_TABLE_TYPE,  
 A_NR_OF_ROWS       IN OUT  NUMBER,                    
 A_ORDER_BY_CLAUSE  IN      VARCHAR2,                  
 A_NEXT_ROWS        IN      NUMBER)                    
RETURN NUMBER IS

L_VALUE                          VARCHAR2(40);
L_ORDER_BY_CLAUSE                VARCHAR2(255);
L_FROM_CLAUSE                    VARCHAR2(500);
L_NEXT_PT_JOIN                   VARCHAR2(4);
L_NEXT_PTGK_JOIN                 VARCHAR2(4);
L_NEXT_SD_JOIN                   VARCHAR2(4);
L_NEXT_SDGK_JOIN                 VARCHAR2(4);
L_COLUMN_HANDLED                 BOOLEAN_TABLE_TYPE;
L_ANYOR_PRESENT                  BOOLEAN;
L_COL_ANDOR                      VARCHAR2(3);
L_PREV_COL_TP                    VARCHAR2(40);
L_PREV_COL_ID                    VARCHAR2(40);
L_PREV_COL_INDEX                 INTEGER;
L_WHERE_CLAUSE4JOIN              VARCHAR2(2000);
L_LENGTH                         INTEGER;
L_SQL_VAL_TAB                    VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

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
      IF P_SELECTPTPROP_CURSOR IS NOT NULL THEN
         DBMS_SQL.CLOSE_CURSOR(P_SELECTPTPROP_CURSOR);
         P_SELECTPTPROP_CURSOR := NULL;
      END IF;
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   
   IF A_NEXT_ROWS = 1 THEN
      IF P_SELECTPTPROP_CURSOR IS NULL THEN
         RETURN(UNAPIGEN.DBERR_NOCURSOR);
      END IF;
   END IF;

   
   IF NVL(A_NEXT_ROWS,0) = 0 THEN
      L_SQL_STRING := 'SELECT DISTINCT a.' || A_PROP ||' FROM ';
      L_FROM_CLAUSE := 'dd' || UNAPIGEN.P_DD || '.uvpt a';

      
      L_WHERE_CLAUSE4JOIN := '';
      L_WHERE_CLAUSE := '';
      L_ANYOR_PRESENT := FALSE;
      FOR I IN 1..A_COL_NR_OF_ROWS LOOP
         L_COLUMN_HANDLED(I) := FALSE;
         IF LTRIM(RTRIM(UPPER(A_COL_ANDOR(I)))) = 'OR' AND
            NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
            L_ANYOR_PRESENT := TRUE;
         END IF;
         
         
         IF I<>1 THEN
            IF NVL(A_COL_TP(I), ' ') = NVL(A_COL_TP(I-1), ' ') AND
               NVL(A_COL_ID(I), ' ') = NVL(A_COL_ID(I-1), ' ') AND
               NVL(A_COL_OPERATOR(I), '=') = '=' AND
               NVL(A_COL_OPERATOR(I-1), '=') = '=' AND
               NVL(A_COL_ANDOR(I-1), 'AND') =  'AND' AND
               (NVL(A_COL_VALUE(I), ' ') <> ' ' OR NVL(A_COL_VALUE(I-1), ' ') <> ' ') THEN
               IF I> 2 AND A_COL_ANDOR(I-2) = 'OR' THEN
                  L_ANYOR_PRESENT := TRUE;
               END IF;
            END IF;
         END IF;         
      END LOOP;

      
      
      
      L_NEXT_SD_JOIN := 'sd';
      L_NEXT_SDGK_JOIN := 'sd';
      L_NEXT_PT_JOIN := 'a';
      L_NEXT_PTGK_JOIN := 'a';

      FOR I IN REVERSE 1..A_COL_NR_OF_ROWS LOOP
         IF NVL(LTRIM(A_COL_ID(I)), ' ') = ' ' THEN
            RETURN(UNAPIGEN.DBERR_SELCOLSINVALID);
        END IF;
         
         L_COL_ANDOR := 'AND';
         IF I<>1 THEN
            L_COL_ANDOR := A_COL_ANDOR(I-1);
         END IF;
         IF L_COL_ANDOR IS NULL THEN
            
            L_COL_ANDOR := 'AND';
         END IF;

         IF L_COLUMN_HANDLED(I) = FALSE THEN
            IF NVL(A_COL_TP(I), ' ') = 'ptgk' THEN 
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utpt', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => 'utptgk', A_JOINCOLUMN1 => 'pt', A_JOINCOLUMN2 => 'version', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_PTGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSIF NVL(A_COL_TP(I), ' ') = 'sdgk' THEN 
               IF INSTR(L_FROM_CLAUSE, '.uvsd sd') = 0 THEN
                 L_FROM_CLAUSE := L_FROM_CLAUSE || ', dd' || UNAPIGEN.P_DD || '.uvsd sd' ;
                 L_WHERE_CLAUSE4JOIN := L_WHERE_CLAUSE4JOIN || 'sd.pt = a.pt AND '|| 
                                   'sd.pt_version = a.version AND ';
               END IF;
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsd', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => 'utsdgk', A_JOINCOLUMN1 => 'sd', A_JOINCOLUMN2 => '', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_SDGK_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_BASETABLE4GK_ALIAS => 'sd',
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);                
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSIF NVL(A_COL_TP(I), ' ') = 'sd' THEN 
               IF INSTR(L_FROM_CLAUSE, '.uvsd sd') = 0 THEN
                 L_FROM_CLAUSE := L_FROM_CLAUSE || ', dd' || UNAPIGEN.P_DD || '.uvsd sd' ;
                 L_WHERE_CLAUSE4JOIN := L_WHERE_CLAUSE4JOIN || 'sd.pt = a.pt AND '|| 
                                   'sd.pt_version = a.version AND ';
               END IF;
               IF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utsd', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_SD_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,                  
                                 A_BASETABLE4GK_ALIAS => 'sd',
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            ELSE 
               IF (LOWER(NVL(A_COL_ID(I),' ')) = 'version') AND (NVL(A_COL_VALUE(I),' ') = 'MAX') THEN
                  L_WHERE_CLAUSE := L_WHERE_CLAUSE || '(a.pt, a.' || A_COL_ID(I) || ') ' ||
                                   'IN (SELECT pt, MAX(' || A_COL_ID(I) || ') '|| 
                                       'FROM dd'|| UNAPIGEN.P_DD ||'.uvpt GROUP BY pt) '||
                                       L_COL_ANDOR || ' ' ; 
               ELSIF NVL(A_COL_VALUE(I), ' ') <> ' ' THEN
                  UNAPIGEN.WHERECLAUSESTRINGBUILDER (A_BASE_TABLE => 'utpt', A_INDEX =>I, A_COL_TP => A_COL_TP(I), A_COL_ID => A_COL_ID(I),
                                 A_COL_VALUE => A_COL_VALUE(I), A_COL_OPERATOR => A_COL_OPERATOR(I),
                                 A_COL_ANDOR => L_COL_ANDOR, A_ANYOR_PRESENT => L_ANYOR_PRESENT,
                                 A_JOINTABLE_PREFIX => '', A_JOINCOLUMN1 => '', A_JOINCOLUMN2 => '', 
                                 A_PREV_COL_TP => L_PREV_COL_TP, A_PREV_COL_ID => L_PREV_COL_ID, A_PREV_COL_INDEX => L_PREV_COL_INDEX,
                                 A_NEXTTABLE_TOJOIN => L_NEXT_PT_JOIN, A_FROM_CLAUSE => L_FROM_CLAUSE,
                                 A_WHERE_CLAUSE4JOIN => L_WHERE_CLAUSE4JOIN, A_WHERE_CLAUSE => L_WHERE_CLAUSE,
                                 A_SQL_VAL_TAB => L_SQL_VAL_TAB);                  
               END IF;
               L_COLUMN_HANDLED(I) := TRUE; 
            END IF;
         END IF;
      END LOOP;

      
      IF SUBSTR(L_WHERE_CLAUSE4JOIN, -4) = 'AND ' THEN
         L_WHERE_CLAUSE4JOIN := SUBSTR(L_WHERE_CLAUSE4JOIN, 1,
                                  LENGTH(L_WHERE_CLAUSE4JOIN)-4);
      END IF;
      
      
      IF SUBSTR(L_WHERE_CLAUSE, -4) = 'AND ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-4);
      END IF;
      IF UPPER(SUBSTR(L_WHERE_CLAUSE, -4)) = ' OR ' THEN
         L_WHERE_CLAUSE := SUBSTR(L_WHERE_CLAUSE, 1,
                                  LENGTH(L_WHERE_CLAUSE)-3);
      END IF;
      
      IF L_WHERE_CLAUSE4JOIN IS NOT NULL THEN
         IF L_WHERE_CLAUSE IS NULL THEN
            L_WHERE_CLAUSE := ' WHERE ' || L_WHERE_CLAUSE4JOIN;
         ELSE
            L_WHERE_CLAUSE := ' WHERE (' || L_WHERE_CLAUSE4JOIN || ') AND ('||L_WHERE_CLAUSE||') ';
         END IF;
      ELSE
         IF L_WHERE_CLAUSE IS NOT NULL THEN
            L_WHERE_CLAUSE := ' WHERE '||L_WHERE_CLAUSE;
         ELSE
            L_WHERE_CLAUSE := ' ';
         END IF;
      END IF;

      L_ORDER_BY_CLAUSE := NVL(A_ORDER_BY_CLAUSE, ' ORDER BY 1');

      L_SQL_STRING := L_SQL_STRING || L_FROM_CLAUSE || L_WHERE_CLAUSE || L_ORDER_BY_CLAUSE;

      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            

      IF P_SELECTPTPROP_CURSOR IS NULL THEN 
         P_SELECTPTPROP_CURSOR := DBMS_SQL.OPEN_CURSOR;
      END IF;
      
      UNAPIAUT.ADDORACLECBOHINT (L_SQL_STRING) ;
      DBMS_SQL.PARSE(P_SELECTPTPROP_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      FOR L_X IN 1..L_SQL_VAL_TAB.COUNT() LOOP
         DBMS_SQL.BIND_VARIABLE(P_SELECTPTPROP_CURSOR, ':col_val'||L_X , L_SQL_VAL_TAB(L_X)); 
      END LOOP;
      DBMS_SQL.DEFINE_COLUMN(P_SELECTPTPROP_CURSOR, 1, L_VALUE, 40);
      L_RESULT := DBMS_SQL.EXECUTE(P_SELECTPTPROP_CURSOR);

   END IF;

   L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTPTPROP_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(P_SELECTPTPROP_CURSOR, 1, L_VALUE);
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;
      A_VALUE(L_FETCHED_ROWS) := L_VALUE;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_SELECTPTPROP_CURSOR);
      END IF;
   END LOOP;

   
   IF (L_FETCHED_ROWS = 0) THEN
       DBMS_SQL.CLOSE_CURSOR(P_SELECTPTPROP_CURSOR);
       P_SELECTPTPROP_CURSOR := NULL;
       RETURN(UNAPIGEN.DBERR_NORECORDS);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      DBMS_SQL.CLOSE_CURSOR(P_SELECTPTPROP_CURSOR);
      P_SELECTPTPROP_CURSOR := NULL;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      L_SQLERRM := SQLERRM;
      UNAPIGEN.U4ROLLBACK;
      INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
      VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
              'SelectPtPropValues', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQL_STRING) > ((L_LENGTH*(L_X-1))+1) ) THEN
            INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
            VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                   'SelectStPropValues', '(SQL)'||SUBSTR(L_SQL_STRING, (L_LENGTH*(L_X-1))+1, L_LENGTH));             
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      L_LENGTH := 200;
      FOR L_X IN 1..10 LOOP
         IF ( LENGTH(L_SQLERRM) > ((L_LENGTH*(L_X-1))+1) ) THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(L_SQLERRM, (L_LENGTH*(L_X-1))+1, L_LENGTH));
         ELSE
            EXIT;
         END IF;
      END LOOP;            
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (P_SELECTPTPROP_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (P_SELECTPTPROP_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END SELECTPTPROPVALUES;

FUNCTION GETPTINFOPROFILE
(A_PT               OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_VERSION          OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_IP               OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_IP_VERSION       OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_DESCRIPTION      OUT    UNAPIGEN.VC40_TABLE_TYPE,    
 A_IS_PROTECTED     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_HIDDEN           OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_FREQ_TP          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_FREQ_VAL         OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_FREQ_UNIT        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_INVERT_FREQ      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_LAST_SCHED       OUT    UNAPIGEN.DATE_TABLE_TYPE,    
 A_LAST_CNT         OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_LAST_VAL         OUT    UNAPIGEN.VC40_TABLE_TYPE,    
 A_INHERIT_AU       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_NR_OF_ROWS       IN OUT NUMBER,                      
 A_WHERE_CLAUSE     IN     VARCHAR2)                    
RETURN NUMBER IS

L_PT                             VARCHAR2(20);
L_VERSION                        VARCHAR2(20);
L_IP                             VARCHAR2(20);
L_IP_VERSION                     VARCHAR2(20);
L_DESCRIPTION                    VARCHAR2(40);
L_IS_PROTECTED                   CHAR(1);
L_HIDDEN                         CHAR(1);
L_FREQ_TP                        CHAR(1);
L_FREQ_VAL                       NUMBER;
L_FREQ_UNIT                      VARCHAR2(20);
L_INVERT_FREQ                    CHAR(1);
L_LAST_SCHED                     TIMESTAMP WITH TIME ZONE;
L_LAST_CNT                       NUMBER(5);
L_LAST_VAL                       VARCHAR2(40);
L_INHERIT_AU                     CHAR(1);
L_BIND_PT_SELECTION              BOOLEAN;
L_BIND_FIXED_PT_FLAG             BOOLEAN;

BEGIN

   L_BIND_PT_SELECTION := FALSE;
   L_BIND_FIXED_PT_FLAG := FALSE;
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY ptip.pt, ptip.version, ptip.seq'; 
   ELSIF A_WHERE_CLAUSE = 'SELECTION' THEN
      IF UNAPIPT.P_SELECTION_CLAUSE IS NOT NULL THEN 
         IF INSTR(UPPER(UNAPIPT.P_SELECTION_CLAUSE), 'WHERE') <> 0 THEN       
            L_WHERE_CLAUSE := ','||UNAPIPT.P_SELECTION_CLAUSE|| 
                              ' AND a.version = ptip.version AND a.pt = ptip.pt ORDER BY ptip.pt, ptip.version, ptip.seq'; 
         ELSE
            L_WHERE_CLAUSE := ','||UNAPIPT.P_SELECTION_CLAUSE|| 
                              ' WHERE a.version = ptip.version AND a.pt = ptip.pt ORDER BY ptip.pt, ptip.version, ptip.seq'; 
         END IF;
         L_BIND_PT_SELECTION := TRUE;
      ELSE
         L_WHERE_CLAUSE := 'ORDER BY ptip.pt, ptip.version, ptip.seq'; 
      END IF;      
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_BIND_FIXED_PT_FLAG := TRUE;
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uvpt pt WHERE pt.version_is_current = ''1'' '||
                        'AND ptip.version = pt.version '||
                        'AND ptip.pt = pt.pt '||
                        'AND ptip.pt = :pt_val ORDER BY ptip.seq';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   IF NOT DBMS_SQL.IS_OPEN(P_PTIP_CURSOR) THEN
      P_PTIP_CURSOR := DBMS_SQL.OPEN_CURSOR;

      L_SQL_STRING := 'SELECT ptip.pt, ptip.version, ptip.ip, ptip.ip_version, ptip.is_protected, '||
                      'ptip.hidden, ptip.freq_tp, ptip.freq_val, ptip.freq_unit, ptip.invert_freq, ' ||
                      'ptip.last_sched, ptip.last_cnt, ptip.last_val, ptip.inherit_au ' ||
                      'FROM dd'||UNAPIGEN.P_DD||'.uvptip ptip '|| L_WHERE_CLAUSE;

      DBMS_SQL.PARSE(P_PTIP_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      IF L_BIND_PT_SELECTION THEN
         FOR L_X IN 1..UNAPIPT.P_SELECTION_VAL_TAB.COUNT() LOOP
            DBMS_SQL.BIND_VARIABLE(P_PTIP_CURSOR, ':col_val'||L_X , UNAPIPT.P_SELECTION_VAL_TAB(L_X)); 
         END LOOP;
      ELSIF L_BIND_FIXED_PT_FLAG THEN
         DBMS_SQL.BIND_VARIABLE(P_PTIP_CURSOR, ':pt_val' , A_WHERE_CLAUSE); 
      END IF;

      DBMS_SQL.DEFINE_COLUMN(P_PTIP_CURSOR,      1,   L_PT,          20  );
      DBMS_SQL.DEFINE_COLUMN(P_PTIP_CURSOR,      2,   L_VERSION,     20  );
      DBMS_SQL.DEFINE_COLUMN(P_PTIP_CURSOR,      3,   L_IP,          20  );
      DBMS_SQL.DEFINE_COLUMN(P_PTIP_CURSOR,      4,   L_IP_VERSION,  20  );
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_PTIP_CURSOR, 5,   L_IS_PROTECTED,1   );
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_PTIP_CURSOR, 6,   L_HIDDEN,      1   );
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_PTIP_CURSOR, 7,   L_FREQ_TP,     1   );
      DBMS_SQL.DEFINE_COLUMN(P_PTIP_CURSOR,      8,   L_FREQ_VAL         );
      DBMS_SQL.DEFINE_COLUMN(P_PTIP_CURSOR,      9,   L_FREQ_UNIT,   20  );
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_PTIP_CURSOR, 10,  L_INVERT_FREQ, 1   );
      DBMS_SQL.DEFINE_COLUMN(P_PTIP_CURSOR,      11,  L_LAST_SCHED       );
      DBMS_SQL.DEFINE_COLUMN(P_PTIP_CURSOR,      12,  L_LAST_CNT         );
      DBMS_SQL.DEFINE_COLUMN(P_PTIP_CURSOR,      13,  L_LAST_VAL,    40  );
      DBMS_SQL.DEFINE_COLUMN_CHAR(P_PTIP_CURSOR, 14,  L_INHERIT_AU,  1   );
      L_RESULT := DBMS_SQL.EXECUTE(P_PTIP_CURSOR);
   END IF;
   
   L_RESULT := DBMS_SQL.FETCH_ROWS(P_PTIP_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(P_PTIP_CURSOR,      1,  L_PT);
      DBMS_SQL.COLUMN_VALUE(P_PTIP_CURSOR,      2,  L_VERSION);
      DBMS_SQL.COLUMN_VALUE(P_PTIP_CURSOR,      3,  L_IP);
      DBMS_SQL.COLUMN_VALUE(P_PTIP_CURSOR,      4,  L_IP_VERSION);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_PTIP_CURSOR, 5,  L_IS_PROTECTED);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_PTIP_CURSOR, 6,  L_HIDDEN);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_PTIP_CURSOR, 7,  L_FREQ_TP);
      DBMS_SQL.COLUMN_VALUE(P_PTIP_CURSOR,      8,  L_FREQ_VAL);
      DBMS_SQL.COLUMN_VALUE(P_PTIP_CURSOR,      9,  L_FREQ_UNIT);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_PTIP_CURSOR, 10, L_INVERT_FREQ);
      DBMS_SQL.COLUMN_VALUE(P_PTIP_CURSOR,      11, L_LAST_SCHED);
      DBMS_SQL.COLUMN_VALUE(P_PTIP_CURSOR,      12, L_LAST_CNT);
      DBMS_SQL.COLUMN_VALUE(P_PTIP_CURSOR,      13, L_LAST_VAL);
      DBMS_SQL.COLUMN_VALUE_CHAR(P_PTIP_CURSOR, 14, L_INHERIT_AU);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_PT           (L_FETCHED_ROWS) := L_PT;
      A_VERSION      (L_FETCHED_ROWS) := L_VERSION;
      A_IP           (L_FETCHED_ROWS) := L_IP;
      A_IP_VERSION   (L_FETCHED_ROWS) := L_IP_VERSION;
      A_IS_PROTECTED (L_FETCHED_ROWS) := L_IS_PROTECTED;
      A_HIDDEN       (L_FETCHED_ROWS) := L_HIDDEN;
      A_FREQ_TP      (L_FETCHED_ROWS) := L_FREQ_TP;
      A_FREQ_VAL     (L_FETCHED_ROWS) := L_FREQ_VAL;
      A_FREQ_UNIT    (L_FETCHED_ROWS) := L_FREQ_UNIT;
      A_INVERT_FREQ  (L_FETCHED_ROWS) := L_INVERT_FREQ;
      A_LAST_SCHED   (L_FETCHED_ROWS) := TO_CHAR(L_LAST_SCHED);
      A_LAST_CNT     (L_FETCHED_ROWS) := L_LAST_CNT;
      A_LAST_VAL     (L_FETCHED_ROWS) := L_LAST_VAL;
      A_INHERIT_AU   (L_FETCHED_ROWS) := L_INHERIT_AU;

      L_DESCRIPTION := NULL;
      L_SQL_STRING:=   'SELECT description '
                     ||'FROM dd'||UNAPIGEN.P_DD||'.uvip '
                     ||'WHERE version = NVL(UNAPIGEN.UseVersion(''ip'',:l_ip,:l_ip_version), '
                     ||                    'UNAPIGEN.UseVersion(''ip'',:l_ip,''*'')) '
                     ||'AND ip = :l_ip';
      BEGIN
         EXECUTE IMMEDIATE L_SQL_STRING 
         INTO L_DESCRIPTION
         USING L_IP, L_IP_VERSION, L_IP, L_IP;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            
            NULL;
      END;

      IF SQL%NOTFOUND THEN
         L_DESCRIPTION := L_IP;
      END IF;

      A_DESCRIPTION(L_FETCHED_ROWS) := L_DESCRIPTION;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(P_PTIP_CURSOR);
      END IF;
   END LOOP;

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
      DBMS_SQL.CLOSE_CURSOR(P_PTIP_CURSOR);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      DBMS_SQL.CLOSE_CURSOR(P_PTIP_CURSOR);
   ELSE
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
   END IF;

   IF A_WHERE_CLAUSE <> 'SELECTION' AND
      DBMS_SQL.IS_OPEN(P_PTIP_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(P_PTIP_CURSOR);
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
WHEN OTHERS THEN
   L_SQLERRM := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
   VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 
           'GetPtInfoProfile', L_SQLERRM);
   UNAPIGEN.U4COMMIT;
   IF DBMS_SQL.IS_OPEN (P_PTIP_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR (P_PTIP_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPTINFOPROFILE;


FUNCTION GETPTGROUPKEY
(A_PT                 OUT    UNAPIGEN.VC20_TABLE_TYPE,   
 A_VERSION            OUT    UNAPIGEN.VC20_TABLE_TYPE,   
 A_GK                 OUT    UNAPIGEN.VC20_TABLE_TYPE,   
 A_GK_VERSION         OUT    UNAPIGEN.VC20_TABLE_TYPE,   
 A_VALUE              OUT    UNAPIGEN.VC40_TABLE_TYPE,   
 A_DESCRIPTION        OUT    UNAPIGEN.VC40_TABLE_TYPE,   
 A_IS_PROTECTED       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_VALUE_UNIQUE       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_SINGLE_VALUED      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_NEW_VAL_ALLOWED    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_MANDATORY          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_VALUE_LIST_TP      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_DSP_ROWS           OUT    UNAPIGEN.NUM_TABLE_TYPE,    
 A_NR_OF_ROWS         IN OUT NUMBER,                     
 A_WHERE_CLAUSE       IN     VARCHAR2)                   
RETURN NUMBER IS

L_PT                             VARCHAR2(20);
L_VERSION                        VARCHAR2(20);
L_GK                             VARCHAR2(20);
L_GK_VERSION                     VARCHAR2(20);
L_VALUE                          VARCHAR2(40);
L_DESCRIPTION                    VARCHAR2(40);
L_IS_PROTECTED                   CHAR(1);
L_VALUE_UNIQUE                   CHAR(1);
L_SINGLE_VALUED                  CHAR(1);
L_NEW_VAL_ALLOWED                CHAR(1);
L_MANDATORY                      CHAR(1);
L_VALUE_LIST_TP                  CHAR(1);
L_DSP_ROWS                       NUMBER(3);
L_BIND_PT_SELECTION              BOOLEAN;
L_BIND_FIXED_PT_FLAG             BOOLEAN;
L_GKDEF_REC                      UNAPIGK.GKDEFINITIONREC;
L_TEMP_RET_CODE                  INTEGER;

BEGIN
   L_BIND_PT_SELECTION := FALSE;
   L_BIND_FIXED_PT_FLAG := FALSE;
   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := ' ORDER BY gk.pt, gk.version, gk.gkseq';
   ELSIF A_WHERE_CLAUSE = 'SELECTION' THEN
      IF UNAPIPT.P_SELECTION_CLAUSE IS NOT NULL THEN 
         IF INSTR(UPPER(UNAPIPT.P_SELECTION_CLAUSE), 'WHERE') <> 0 THEN       
            L_WHERE_CLAUSE := ','||UNAPIPT.P_SELECTION_CLAUSE|| 
                              ' AND a.version = gk.version AND a.pt = gk.pt ORDER BY gk.pt, gk.version, gk.gkseq'; 
         ELSE
            L_WHERE_CLAUSE := ','||UNAPIPT.P_SELECTION_CLAUSE|| 
                              ' WHERE a.version = gk.version AND a.pt = gk.pt ORDER BY gk.pt, gk.version, gk.gkseq'; 
         END IF;
         L_BIND_PT_SELECTION := TRUE;
      ELSE
         L_WHERE_CLAUSE := 'ORDER BY gk.pt, gk.version, gk.gkseq'; 
      END IF;      
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_BIND_FIXED_PT_FLAG := TRUE;
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uvpt pt WHERE pt.version_is_current = ''1'' '||
                        'AND gk.version = pt.version '||
                        'AND gk.pt = pt.pt '||
                        'AND gk.pt = :pt_val ORDER BY gk.gkseq';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   IF NOT DBMS_SQL.IS_OPEN(L_PTGK_CURSOR) THEN
      
      L_TEMP_RET_CODE := UNAPIGK.INITGROUPKEYDEFBUFFER('pt');
      IF L_TEMP_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE_APPLICATION_ERROR(-20000, 'InitGroupKeyDefBuffer failed with ret_code='||L_TEMP_RET_CODE||' for a_gk_tp=pt');   
      END IF;

      L_PTGK_CURSOR := DBMS_SQL.OPEN_CURSOR;
      L_SQL_STRING := 'SELECT gk.pt, gk.version, gk.gk, gk.gk_version, gk.value ' ||
                      'FROM dd'|| UNAPIGEN.P_DD ||'.uvptgk gk '|| L_WHERE_CLAUSE;

      DBMS_SQL.PARSE(L_PTGK_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      IF L_BIND_FIXED_PT_FLAG THEN
         DBMS_SQL.BIND_VARIABLE(L_PTGK_CURSOR, ':pt_val' , A_WHERE_CLAUSE); 
      ELSIF L_BIND_PT_SELECTION THEN
         FOR L_X IN 1..UNAPIPT.P_SELECTION_VAL_TAB.COUNT() LOOP
            DBMS_SQL.BIND_VARIABLE(L_PTGK_CURSOR, ':col_val'||L_X , UNAPIPT.P_SELECTION_VAL_TAB(L_X)); 
         END LOOP;
      END IF;

      DBMS_SQL.DEFINE_COLUMN(L_PTGK_CURSOR, 1, L_PT, 20);
      DBMS_SQL.DEFINE_COLUMN(L_PTGK_CURSOR, 2, L_VERSION, 20);
      DBMS_SQL.DEFINE_COLUMN(L_PTGK_CURSOR, 3, L_GK, 20);
      DBMS_SQL.DEFINE_COLUMN(L_PTGK_CURSOR, 4, L_GK_VERSION, 20);
      DBMS_SQL.DEFINE_COLUMN(L_PTGK_CURSOR, 5, L_VALUE, 40);
      L_RESULT := DBMS_SQL.EXECUTE(L_PTGK_CURSOR);
   END IF;
  
   L_RESULT := DBMS_SQL.FETCH_ROWS(L_PTGK_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_PTGK_CURSOR, 1, L_PT);
      DBMS_SQL.COLUMN_VALUE(L_PTGK_CURSOR, 2, L_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_PTGK_CURSOR, 3, L_GK);
      DBMS_SQL.COLUMN_VALUE(L_PTGK_CURSOR, 4, L_GK_VERSION);
      DBMS_SQL.COLUMN_VALUE(L_PTGK_CURSOR, 5, L_VALUE);

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_PT         (L_FETCHED_ROWS) := L_PT;
      A_VERSION    (L_FETCHED_ROWS) := L_VERSION;
      A_GK         (L_FETCHED_ROWS) := L_GK;
      A_GK_VERSION (L_FETCHED_ROWS) := L_GK_VERSION;
      A_VALUE      (L_FETCHED_ROWS) := L_VALUE;

      
      BEGIN
         L_GKDEF_REC := UNAPIGK.P_GK_DEF_BUFFER(L_GK);
         A_DESCRIPTION(L_FETCHED_ROWS) := L_GKDEF_REC.DESCRIPTION;
         A_IS_PROTECTED(L_FETCHED_ROWS) := L_GKDEF_REC.IS_PROTECTED;
         A_VALUE_UNIQUE(L_FETCHED_ROWS) := L_GKDEF_REC.VALUE_UNIQUE;
         A_SINGLE_VALUED(L_FETCHED_ROWS) := L_GKDEF_REC.SINGLE_VALUED;
         A_NEW_VAL_ALLOWED(L_FETCHED_ROWS) := L_GKDEF_REC.NEW_VAL_ALLOWED;
         A_MANDATORY(L_FETCHED_ROWS) := L_GKDEF_REC.MANDATORY;
         A_VALUE_LIST_TP(L_FETCHED_ROWS) := L_GKDEF_REC.VALUE_LIST_TP;
         A_DSP_ROWS(L_FETCHED_ROWS) := L_GKDEF_REC.DSP_ROWS;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         
         
         
         A_DESCRIPTION(L_FETCHED_ROWS)     := L_GK;
         A_IS_PROTECTED(L_FETCHED_ROWS)    := '1';
         A_VALUE_UNIQUE(L_FETCHED_ROWS)    := '0';
         A_SINGLE_VALUED(L_FETCHED_ROWS)   := '1';
         A_NEW_VAL_ALLOWED(L_FETCHED_ROWS) := '1';
         A_MANDATORY(L_FETCHED_ROWS)       := '0';
         A_VALUE_LIST_TP(L_FETCHED_ROWS)   := 'F';
         A_DSP_ROWS(L_FETCHED_ROWS)        := 10;      
      END;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_PTGK_CURSOR);
      END IF;
   END LOOP;

   IF L_FETCHED_ROWS = 0 THEN
      L_RET_CODE := UNAPIGEN.DBERR_NORECORDS;
      DBMS_SQL.CLOSE_CURSOR(L_PTGK_CURSOR);
   ELSIF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
      DBMS_SQL.CLOSE_CURSOR(L_PTGK_CURSOR);
   ELSE   
      L_RET_CODE := UNAPIGEN.DBERR_SUCCESS;
      A_NR_OF_ROWS := L_FETCHED_ROWS;
   END IF;

   IF A_WHERE_CLAUSE <> 'SELECTION' AND
      DBMS_SQL.IS_OPEN(L_PTGK_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_PTGK_CURSOR);
   END IF;

   IF NOT DBMS_SQL.IS_OPEN(L_PTGK_CURSOR) THEN
      L_TEMP_RET_CODE := UNAPIGK.CLOSEGROUPKEYDEFBUFFER('pt');
      IF L_TEMP_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE_APPLICATION_ERROR(-20000, 'CloseGroupKeyDefBuffer failed with ret_code='||L_TEMP_RET_CODE||' for a_gk_tp=pt');   
      END IF;
   END IF;

   RETURN(L_RET_CODE);

EXCEPTION
  WHEN OTHERS THEN
     L_SQLERRM := SQLERRM;
     UNAPIGEN.U4ROLLBACK;
     INSERT INTO UTERROR(CLIENT_ID, APPLIC, WHO, LOGDATE, LOGDATE_TZ, API_NAME, ERROR_MSG)
     VALUES (UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'GetPtGroupKey', L_SQLERRM);
     UNAPIGEN.U4COMMIT;
     IF DBMS_SQL.IS_OPEN (L_PTGK_CURSOR) THEN
        DBMS_SQL.CLOSE_CURSOR (L_PTGK_CURSOR);
     END IF;
      L_RET_CODE := UNAPIGK.CLOSEGROUPKEYDEFBUFFER('pt');
      
     RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPTGROUPKEY;

FUNCTION SAVEPROTOCOL
(A_PT                  IN  VARCHAR2,                  
 A_VERSION             IN  VARCHAR2,                  
 A_VERSION_IS_CURRENT  IN  CHAR,                      
 A_EFFECTIVE_FROM      IN  DATE,                      
 A_EFFECTIVE_TILL      IN  DATE,                      
 A_DESCRIPTION         IN  VARCHAR2,                  
 A_DESCRIPTION2        IN  VARCHAR2,                  
 A_DESCR_DOC           IN  VARCHAR2,                  
 A_DESCR_DOC_VERSION   IN  VARCHAR2,                  
 A_IS_TEMPLATE         IN  CHAR,                      
 A_CONFIRM_USERID      IN  CHAR,                      
 A_NR_PLANNED_SD       IN  NUMBER,                    
 A_FREQ_TP             IN  CHAR,                      
 A_FREQ_VAL            IN  NUMBER,                    
 A_FREQ_UNIT           IN  VARCHAR2,                  
 A_INVERT_FREQ         IN  CHAR,                      
 A_LAST_SCHED          IN  DATE,                      
 A_LAST_CNT            IN  NUMBER,                    
 A_LAST_VAL            IN  VARCHAR2,                  
 A_LABEL_FORMAT        IN  VARCHAR2,                  
 A_PLANNED_RESPONSIBLE IN  VARCHAR2,                  
 A_SD_UC               IN  VARCHAR2,                  
 A_SD_UC_VERSION       IN  VARCHAR2,                  
 A_SD_LC               IN  VARCHAR2,                  
 A_SD_LC_VERSION       IN  VARCHAR2,                  
 A_INHERIT_AU          IN  CHAR,                      
 A_INHERIT_GK          IN  CHAR,                      
 A_PT_CLASS            IN  VARCHAR2,                  
 A_LOG_HS              IN  CHAR,                      
 A_LC                  IN  VARCHAR2,                  
 A_LC_VERSION          IN  VARCHAR2,                  
 A_MODIFY_REASON       IN  VARCHAR2)                  
RETURN NUMBER IS

L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_INSERT       BOOLEAN;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PT, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   IF NVL(A_IS_TEMPLATE, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_TEMPLATE;
      RAISE STPERROR;
   END IF;

   IF NVL(A_CONFIRM_USERID, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_CONFIRMUSERID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_FREQ_TP, ' ') NOT IN ('A','S','T','C','N') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_FREQTP;
      RAISE STPERROR;
   END IF;

   IF A_FREQ_TP IN ('C','T','S') THEN
      IF A_FREQ_UNIT IS NULL THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_FREQUNIT;
         RAISE STPERROR;         
      ELSIF A_FREQ_TP = 'T' AND
         A_FREQ_UNIT NOT IN ('MI','HH','DD','WW','MM','YY','MF','YF') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_FREQUNIT;
         RAISE STPERROR;         
      END IF;
   END IF;

   IF NVL(A_INVERT_FREQ, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INVERTFREQ;
      RAISE STPERROR;
   END IF;

   IF NVL(A_INHERIT_AU, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INHERITAU;
      RAISE STPERROR;
   END IF;

   IF NVL(A_INHERIT_GK, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INHERITGK;
      RAISE STPERROR;
   END IF;

   IF NVL(A_LOG_HS, ' ') NOT IN ('1','0') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_LOGHS;
      RAISE STPERROR;
   END IF;


   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('pt', A_PT, A_VERSION, L_LC, L_LC_VERSION, L_SS,
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
      IF NVL(A_LC_VERSION, ' ') <> ' ' THEN
         L_LC_VERSION := A_LC_VERSION;
      END IF;
      INSERT INTO UTPT(PT, VERSION, EFFECTIVE_FROM, EFFECTIVE_FROM_TZ, EFFECTIVE_TILL, EFFECTIVE_TILL_TZ, DESCRIPTION, DESCRIPTION2,
         DESCR_DOC, DESCR_DOC_VERSION, IS_TEMPLATE, CONFIRM_USERID, NR_PLANNED_SD, FREQ_TP, FREQ_VAL, FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ,
         LAST_CNT, LAST_VAL, LABEL_FORMAT, PLANNED_RESPONSIBLE, SD_UC, SD_UC_VERSION, SD_LC, SD_LC_VERSION, INHERIT_AU,
         INHERIT_GK, PT_CLASS, LOG_HS, ALLOW_MODIFY, ACTIVE, LC, LC_VERSION)
      VALUES(A_PT, A_VERSION, A_EFFECTIVE_FROM, A_EFFECTIVE_FROM, A_EFFECTIVE_TILL, A_EFFECTIVE_TILL, A_DESCRIPTION, 
         A_DESCRIPTION2, A_DESCR_DOC, A_DESCR_DOC_VERSION, A_IS_TEMPLATE, A_CONFIRM_USERID, A_NR_PLANNED_SD, A_FREQ_TP, 
         NVL(A_FREQ_VAL,0), A_FREQ_UNIT, A_INVERT_FREQ, A_LAST_SCHED, A_LAST_SCHED, NVL(A_LAST_CNT,0), A_LAST_VAL, A_LABEL_FORMAT, 
         A_PLANNED_RESPONSIBLE, A_SD_UC, A_SD_UC_VERSION, A_SD_LC, A_SD_LC_VERSION, A_INHERIT_AU, A_INHERIT_GK, 
         A_PT_CLASS, A_LOG_HS, '#', '0', A_LC, A_LC_VERSION);
      L_EVENT_TP := 'ObjectCreated';
   ELSE                             
      UPDATE UTPT
      SET EFFECTIVE_FROM        = DECODE(EFFECTIVE_TILL, NULL, A_EFFECTIVE_FROM, EFFECTIVE_FROM),
          EFFECTIVE_FROM_TZ    = DECODE(EFFECTIVE_TILL, NULL,  DECODE(A_EFFECTIVE_FROM, EFFECTIVE_FROM_TZ, EFFECTIVE_FROM_TZ, A_EFFECTIVE_FROM), EFFECTIVE_FROM_TZ),
          DESCRIPTION           = A_DESCRIPTION        ,
          DESCRIPTION2          = A_DESCRIPTION2       ,
          DESCR_DOC             = A_DESCR_DOC          ,
          DESCR_DOC_VERSION     = A_DESCR_DOC_VERSION  ,
          IS_TEMPLATE           = A_IS_TEMPLATE        ,
          CONFIRM_USERID        = A_CONFIRM_USERID     ,
          NR_PLANNED_SD         = A_NR_PLANNED_SD      ,
          FREQ_TP               = A_FREQ_TP            ,
          FREQ_VAL              = A_FREQ_VAL           ,
          FREQ_UNIT             = A_FREQ_UNIT          ,
          INVERT_FREQ           = A_INVERT_FREQ        ,
          LAST_SCHED            = A_LAST_SCHED         ,
          LAST_SCHED_TZ         =  DECODE(A_LAST_SCHED, LAST_SCHED_TZ, LAST_SCHED_TZ, A_LAST_SCHED)         ,
          LAST_CNT              = A_LAST_CNT           ,
          LAST_VAL              = A_LAST_VAL           ,
          LABEL_FORMAT          = A_LABEL_FORMAT       ,
          PLANNED_RESPONSIBLE   = A_PLANNED_RESPONSIBLE,
          SD_UC                 = A_SD_UC              ,
          SD_UC_VERSION         = A_SD_UC_VERSION      ,
          SD_LC                 = A_SD_LC              ,
          SD_LC_VERSION         = A_SD_LC_VERSION      ,
          INHERIT_AU            = A_INHERIT_AU         ,
          INHERIT_GK            = A_INHERIT_GK         ,
          PT_CLASS              = A_PT_CLASS         ,
          LOG_HS                = A_LOG_HS             ,
          ALLOW_MODIFY          = '#'       ,
          LC                    = A_LC       ,          
          LC_VERSION            = A_LC_VERSION        
        WHERE PT = A_PT
        AND VERSION = A_VERSION;
      L_EVENT_TP := 'ObjectUpdated';
   END IF;

   L_EV_SEQ_NR := -1;
   L_RESULT :=
         UNAPIEV.INSERTEVENT('SaveProtocol', UNAPIGEN.P_EVMGR_NAME, 'pt', A_PT, L_LC, L_LC_VERSION, 
                             L_SS, L_EVENT_TP, 'version='||A_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF NVL(L_LOG_HS, ' ') <> A_LOG_HS THEN
      IF A_LOG_HS = '1' THEN
         INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                             WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched ON', 
                 'Audit trail is turned on.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      ELSE
         INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                             WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 'History switched OFF', 
                 'Audit trail is turned off.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
   END IF;

   IF NVL(L_LOG_HS, ' ') = '1' THEN
      IF L_EVENT_TP = 'ObjectCreated' THEN
         INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                             WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                 'protocol "'||A_PT||'" is created.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, 
                 L_EV_SEQ_NR);
      ELSE
         INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                             WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                 'protocol "'||A_PT||'" is updated.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, 
                 L_EV_SEQ_NR);
      END IF;
   ELSE
      
      
      IF L_EVENT_TP = 'ObjectCreated' THEN
         INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                             WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                 'protocol "'||A_PT||'" is created.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, 
                 L_EV_SEQ_NR);
      END IF;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
        UNAPIGEN.LOGERROR('SaveProtocol', SQLERRM);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SaveProtocol'));
END SAVEPROTOCOL;

FUNCTION DELETEPROTOCOL
(A_PT            IN  VARCHAR2,          
 A_VERSION       IN  VARCHAR2,          
 A_MODIFY_REASON IN  VARCHAR2)          
RETURN NUMBER IS

L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_LC           CHAR(2);
L_LC_VERSION   CHAR(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_PT_CURSOR    INTEGER;

CURSOR L_PTD_CURSOR IS
SELECT DISTINCT GK
FROM UTPTGK
WHERE VERSION = A_VERSION
  AND PT = A_PT;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PT, ' ')= ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ')= ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('pt', A_PT, A_VERSION, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   
   IF UNAPIGEN.ISSYSTEM21CFR11COMPLIANT = UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTALLOWEDIN21CFR11;
      RAISE STPERROR;
   END IF;

   DELETE FROM UTPTAU
   WHERE PT = A_PT
     AND VERSION = A_VERSION;

   DELETE FROM UTPTHS
   WHERE PT = A_PT
     AND VERSION = A_VERSION;

   L_PT_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_PTG IN L_PTD_CURSOR LOOP
      BEGIN
         L_SQL_STRING := ' DELETE FROM utptgk' || L_PTG.GK ||
                         ' WHERE version = ''' || REPLACE(A_VERSION, '''', '''''') || '''' || 
                         ' AND pt = ''' || REPLACE(A_PT, '''', '''''') || ''''; 
         DBMS_SQL.PARSE(L_PT_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         L_RESULT := DBMS_SQL.EXECUTE(L_PT_CURSOR);
      EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE = -942 THEN
            NULL; 
         ELSE
            RAISE;
         END IF;
      END;
   END LOOP;
   
   DELETE FROM UTPTGK
   WHERE PT = A_PT
     AND VERSION = A_VERSION;

   DELETE FROM UTPTIP
   WHERE PT = A_PT
     AND VERSION = A_VERSION;
     
   DELETE FROM UTPTIPAU
   WHERE PT = A_PT
     AND VERSION = A_VERSION;
     
   DELETE FROM UTPTCS
   WHERE PT = A_PT
     AND VERSION = A_VERSION;
     
   DELETE FROM UTPTCSCN
   WHERE PT = A_PT
     AND VERSION = A_VERSION;
     
   DELETE FROM UTPTCELLIP
   WHERE PT = A_PT
     AND VERSION = A_VERSION;

   DELETE FROM UTPTCELLPP
   WHERE PT = A_PT
     AND VERSION = A_VERSION;

   DELETE FROM UTPTCELLST
   WHERE PT = A_PT
     AND VERSION = A_VERSION;

   DELETE FROM UTPTCELLSTAU
   WHERE PT = A_PT
     AND VERSION = A_VERSION;

   DELETE FROM UTEVTIMED
   WHERE (OBJECT_TP='pt' AND OBJECT_ID=A_PT AND INSTR(EV_DETAILS,'version='||A_VERSION)<>0);

   DELETE FROM UTEVRULESDELAYED
   WHERE (OBJECT_TP='pt' AND OBJECT_ID=A_PT AND INSTR(EV_DETAILS,'version='||A_VERSION)<>0);

   DELETE FROM UTPT
   WHERE PT = A_PT
     AND VERSION = A_VERSION;

   L_EVENT_TP := 'ObjectDeleted';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('DeleteProtocol',UNAPIGEN.P_EVMGR_NAME, 'pt', A_PT, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, 'version='||A_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   DBMS_SQL.CLOSE_CURSOR(L_PT_CURSOR);
   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
        UNAPIGEN.LOGERROR('DeleteProtocol', SQLERRM);
      END IF;
      IF DBMS_SQL.IS_OPEN (L_PT_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_PT_CURSOR);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'DeleteProtocol'));
END DELETEPROTOCOL;

FUNCTION SAVEPTINFOPROFILE
(A_PT               IN    VARCHAR2,                    
 A_VERSION          IN    VARCHAR2,                    
 A_IP               IN    UNAPIGEN.VC20_TABLE_TYPE,    
 A_IP_VERSION       IN    UNAPIGEN.VC20_TABLE_TYPE,    
 A_IS_PROTECTED     IN    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_HIDDEN           IN    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_FREQ_TP          IN    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_FREQ_VAL         IN    UNAPIGEN.NUM_TABLE_TYPE,     
 A_FREQ_UNIT        IN    UNAPIGEN.VC20_TABLE_TYPE,    
 A_INVERT_FREQ      IN    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_LAST_SCHED       IN    UNAPIGEN.DATE_TABLE_TYPE,    
 A_LAST_CNT         IN    UNAPIGEN.NUM_TABLE_TYPE,     
 A_LAST_VAL         IN    UNAPIGEN.VC40_TABLE_TYPE,    
 A_INHERIT_AU       IN    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_NR_OF_ROWS       IN    NUMBER,                      
 A_MODIFY_REASON    IN    VARCHAR2)                    
RETURN NUMBER IS

L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_SEQ_NO       NUMBER;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PT, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('pt', A_PT, A_VERSION, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPT
   SET ALLOW_MODIFY = '#'
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   DELETE UTPTIP
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_IP(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;

      IF NVL(A_FREQ_TP(L_SEQ_NO), ' ') NOT IN ('A','S','T','C','N') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_FREQTP;
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

      IF NVL(A_INVERT_FREQ(L_SEQ_NO), ' ') NOT IN ('1','0') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INVERTFREQ;
         RAISE STPERROR;
      END IF;

      IF NVL(A_IS_PROTECTED(L_SEQ_NO), '0') NOT IN ('2','1','0') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_PROTECTED;
         RAISE STPERROR;
      END IF;

      IF NVL(A_HIDDEN(L_SEQ_NO), '0') NOT IN ('2','1','0') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_HIDDEN;
         RAISE STPERROR;
      END IF;

      IF NVL(A_INHERIT_AU(L_SEQ_NO), ' ') NOT IN ('2','1','0') THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_INHERITAU;
         RAISE STPERROR;
      END IF;

      INSERT INTO UTPTIP (PT, VERSION, IP, IP_VERSION, SEQ, IS_PROTECTED, HIDDEN, FREQ_TP, FREQ_VAL,
                          FREQ_UNIT, INVERT_FREQ, LAST_SCHED, LAST_SCHED_TZ, LAST_CNT, LAST_VAL, INHERIT_AU)
      VALUES (A_PT, A_VERSION, A_IP(L_SEQ_NO), A_IP_VERSION(L_SEQ_NO), L_SEQ_NO, 
              A_IS_PROTECTED(L_SEQ_NO), A_HIDDEN(L_SEQ_NO),A_FREQ_TP(L_SEQ_NO), A_FREQ_VAL(L_SEQ_NO),
              A_FREQ_UNIT(L_SEQ_NO), A_INVERT_FREQ(L_SEQ_NO),
              TO_TIMESTAMP_TZ(A_LAST_SCHED(L_SEQ_NO)), TO_TIMESTAMP_TZ(A_LAST_SCHED(L_SEQ_NO)), A_LAST_CNT(L_SEQ_NO),
              A_LAST_VAL(L_SEQ_NO), A_INHERIT_AU(L_SEQ_NO));
   END LOOP;

   
   
   DELETE FROM UTPTIPAU
   WHERE VERSION = A_VERSION
     AND PT = A_PT
     AND (IP, NVL(IP_VERSION, '~Current~')) NOT IN (SELECT IP, NVL(IP_VERSION, '~Current~') 
                                                      FROM UTPTIP 
                                                     WHERE VERSION = A_VERSION 
                                                       AND PT = A_PT);

   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SavePtInfoProfile', UNAPIGEN.P_EVMGR_NAME, 'pt', A_PT, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, 'version='||A_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                          WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'protocol "'||A_PT||'" info profiles are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('SavePtInfoProfile', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SavePtInfoProfile'));
END SAVEPTINFOPROFILE;

FUNCTION SAVEPTGROUPKEY
(A_PT                 IN       VARCHAR2,                   
 A_VERSION            IN       VARCHAR2,                   
 A_GK                 IN       UNAPIGEN.VC20_TABLE_TYPE,   
 A_GK_VERSION         IN OUT   UNAPIGEN.VC20_TABLE_TYPE,   
 A_VALUE              IN       UNAPIGEN.VC40_TABLE_TYPE,   
 A_NR_OF_ROWS         IN       NUMBER,                     
 A_MODIFY_REASON      IN       VARCHAR2)                   
RETURN NUMBER IS

L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_PT_CURSOR    NUMBER;
L_LAST_SEQ     INTEGER;
L_GK_HANDLE    BOOLEAN_TABLE_TYPE;
L_GK_FOUND     BOOLEAN;
L_SKIP         BOOLEAN;

TABLE_DOES_NOT_EXIST EXCEPTION;
PRAGMA EXCEPTION_INIT (TABLE_DOES_NOT_EXIST, -942);


CURSOR L_GK_CURSOR IS
SELECT GK, GK_VERSION, VALUE, GKSEQ
FROM UTPTGK
WHERE VERSION = A_VERSION
  AND PT = A_PT
ORDER BY GKSEQ;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PT, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_GK(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;
      L_GK_HANDLE(L_SEQ_NO) := TRUE;
   END LOOP;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('pt', A_PT, A_VERSION, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPT
   SET ALLOW_MODIFY = '#'
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   L_LAST_SEQ := 499;
   L_PT_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_PTGK IN L_GK_CURSOR LOOP
      L_GK_FOUND := FALSE;
      FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
         
         IF L_PTGK.GK = A_GK(L_SEQ_NO) AND
            ( (L_PTGK.VALUE = A_VALUE(L_SEQ_NO)) OR
              (L_PTGK.VALUE IS NULL AND A_VALUE(L_SEQ_NO) IS NULL)) THEN
            L_GK_HANDLE(L_SEQ_NO) := FALSE;
            L_GK_FOUND := TRUE;
            EXIT;
         END IF;
      END LOOP;

      IF NOT L_GK_FOUND THEN
         
         DELETE FROM UTPTGK
         WHERE VERSION = A_VERSION
           AND PT = A_PT
           AND GK = L_PTGK.GK
           AND VALUE = L_PTGK.VALUE;

         IF L_PTGK.VALUE IS NULL THEN
            DELETE FROM UTPTGK
            WHERE VERSION = A_VERSION
              AND PT = A_PT
              AND GK = L_PTGK.GK
              AND VALUE IS NULL;
         END IF;            

         L_SQL_STRING := 'DELETE FROM utptgk' || L_PTGK.GK ||
                         ' WHERE pt = :pt AND version = :version AND ' || 
                         L_PTGK.GK || '= :value '; 
         BEGIN
            DBMS_SQL.PARSE(L_PT_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':pt' , A_PT); 
            DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':version' , A_VERSION); 
            DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':value' , L_PTGK.VALUE); 
            L_RESULT := DBMS_SQL.EXECUTE(L_PT_CURSOR);
         EXCEPTION
         WHEN TABLE_DOES_NOT_EXIST THEN
            
            
            NULL;
         END;
      ELSE
         L_LAST_SEQ := L_PTGK.GKSEQ;
      END IF;
   END LOOP;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF L_GK_HANDLE(L_SEQ_NO) THEN
         L_SKIP := FALSE;
         IF NVL(A_VALUE(L_SEQ_NO), ' ') <> ' ' THEN
            L_SQL_STRING := 'INSERT INTO utptgk' || A_GK(L_SEQ_NO) ||
                            ' ('||A_GK(L_SEQ_NO)||', pt, version)'||
                            ' VALUES (:value, :pt, :version) ';  
            BEGIN
               DBMS_SQL.PARSE(L_PT_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
               DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':value' , A_VALUE(L_SEQ_NO)); 
               DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':pt' , A_PT); 
               DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':version' , A_VERSION); 
               L_RESULT := DBMS_SQL.EXECUTE(L_PT_CURSOR);
            EXCEPTION
            WHEN TABLE_DOES_NOT_EXIST THEN
               
               
               NULL;
            WHEN DUP_VAL_ON_INDEX THEN
               L_SKIP := TRUE;
            END;
         END IF;

         IF NOT L_SKIP THEN
            L_LAST_SEQ := L_LAST_SEQ + 1;

            
            INSERT INTO UTPTGK (PT, VERSION, GK, GK_VERSION, GKSEQ, VALUE)
            VALUES(A_PT, A_VERSION, A_GK(L_SEQ_NO), NULL, L_LAST_SEQ, A_VALUE(L_SEQ_NO));
         END IF;

      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_PT_CURSOR);

   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SavePtGroupKey', UNAPIGEN.P_EVMGR_NAME, 'pt', A_PT, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, 'version='||A_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') AND (UNAPIGEN.P_LOG_GK_HS = '1') THEN
      INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                          WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'protocol "'||A_PT||'" group keys are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   IF DBMS_SQL.IS_OPEN (L_PT_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR (L_PT_CURSOR);
   END IF;
   UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_UNIQUEGK;
   
   
   L_RESULT := UNAPIGEN.ENDTXN;
   RETURN(UNAPIGEN.P_TXN_ERROR);
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('SavePtGroupKey', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('SavePtGroupKey', L_SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN (L_PT_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR (L_PT_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SavePtGroupKey'));
END SAVEPTGROUPKEY;

FUNCTION SAVE1PTGROUPKEY
(A_PT                 IN       VARCHAR2,                   
 A_VERSION            IN       VARCHAR2,                   
 A_GK                 IN       VARCHAR2,                   
 A_GK_VERSION         IN OUT   VARCHAR2,                   
 A_VALUE              IN       UNAPIGEN.VC40_TABLE_TYPE,   
 A_NR_OF_ROWS         IN       NUMBER,                     
 A_MODIFY_REASON      IN       VARCHAR2)                   
RETURN NUMBER IS

L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_PT_CURSOR    NUMBER;
L_LAST_SEQ     INTEGER;
L_GK_HANDLE    BOOLEAN_TABLE_TYPE;
L_GK_FOUND     BOOLEAN;
L_SKIP         BOOLEAN;

TABLE_DOES_NOT_EXIST EXCEPTION;
PRAGMA EXCEPTION_INIT (TABLE_DOES_NOT_EXIST, -942);


CURSOR L_GK_CURSOR IS
SELECT VALUE, GKSEQ
FROM UTPTGK
WHERE VERSION = A_VERSION
  AND PT = A_PT
  AND GK = A_GK
ORDER BY GKSEQ;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PT, ' ') = ' ' OR
      NVL(A_GK, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      L_GK_HANDLE(L_SEQ_NO) := TRUE;
   END LOOP;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('pt', A_PT, A_VERSION, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPT
   SET ALLOW_MODIFY = '#'
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   L_LAST_SEQ := 499;
   L_PT_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_PTGK IN L_GK_CURSOR LOOP
      L_GK_FOUND := FALSE;
      FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
         IF L_PTGK.VALUE = A_VALUE(L_SEQ_NO) OR
            (L_PTGK.VALUE IS NULL AND A_VALUE(L_SEQ_NO) IS NULL) THEN
            L_GK_HANDLE(L_SEQ_NO) := FALSE;
            L_GK_FOUND := TRUE;
            EXIT;
         END IF;
      END LOOP;

      IF NOT L_GK_FOUND THEN
         
         DELETE FROM UTPTGK
         WHERE VERSION = A_VERSION
           AND PT = A_PT
           AND GK = A_GK
           AND VALUE = L_PTGK.VALUE;

         IF L_PTGK.VALUE IS NULL THEN
            DELETE FROM UTPTGK
            WHERE VERSION = A_VERSION
              AND PT = A_PT
              AND GK = A_GK
              AND VALUE IS NULL;
         END IF;            

         L_SQL_STRING := 'DELETE FROM utptgk' || A_GK ||
                         ' WHERE pt = :pt AND version = :version AND ' || 
                         A_GK || '= :value '; 
         BEGIN
            DBMS_SQL.PARSE(L_PT_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':pt' , A_PT); 
            DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':version' , A_VERSION); 
            DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':value' , L_PTGK.VALUE); 
            L_RESULT := DBMS_SQL.EXECUTE(L_PT_CURSOR);
         EXCEPTION
         WHEN TABLE_DOES_NOT_EXIST THEN
            
            
            NULL;
         END;
      ELSE      
         L_LAST_SEQ := L_PTGK.GKSEQ;
      END IF;
   END LOOP;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF L_GK_HANDLE(L_SEQ_NO) THEN
         L_SKIP := FALSE; 
         IF NVL(A_VALUE(L_SEQ_NO), ' ') <> ' ' THEN
            L_SQL_STRING := 'INSERT INTO utptgk' || A_GK ||
                            ' ('||A_GK||', pt, version)'||
                            ' VALUES (:value, :pt, :version) ';  
            BEGIN
               DBMS_SQL.PARSE(L_PT_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
               DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':value' , A_VALUE(L_SEQ_NO)); 
               DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':pt' , A_PT); 
               DBMS_SQL.BIND_VARIABLE(L_PT_CURSOR, ':version' , A_VERSION); 
               L_RESULT := DBMS_SQL.EXECUTE(L_PT_CURSOR);
            EXCEPTION
            WHEN TABLE_DOES_NOT_EXIST THEN
               
               
               NULL;
            WHEN DUP_VAL_ON_INDEX THEN
               L_SKIP := TRUE;
            END;
         END IF;

         IF NOT L_SKIP THEN
            L_LAST_SEQ := L_LAST_SEQ + 1;

            
            INSERT INTO UTPTGK (PT, VERSION, GK, GK_VERSION, GKSEQ, VALUE)
            VALUES(A_PT, A_VERSION, A_GK, NULL, L_LAST_SEQ, A_VALUE(L_SEQ_NO));
         END IF;
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_PT_CURSOR);

   L_EVENT_TP := 'PtGroupKeyUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('Save1PtGroupKey', UNAPIGEN.P_EVMGR_NAME, 'pt', A_PT, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, 'version='||A_VERSION||'#gk='||A_GK||'#gk_version='||A_GK_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF (L_LOG_HS = '1') AND (UNAPIGEN.P_LOG_GK_HS = '1') THEN
      INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                          WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, 
              L_EVENT_TP, 
              'protocol type "'||A_PT||'" group key "'||A_GK||'" is created or updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
   IF DBMS_SQL.IS_OPEN (L_PT_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR (L_PT_CURSOR);
   END IF;
   UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_UNIQUEGK;
   
    UPDATE UTPT
      SET ALLOW_MODIFY = '1' 
    WHERE PT = A_PT
    AND VERSION = A_VERSION;
   
   
   L_RESULT := UNAPIGEN.ENDTXN;
   RETURN(UNAPIGEN.P_TXN_ERROR);
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('Save1PtGroupKey', SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('Save1PtGroupKey', L_SQLERRM);
   END IF;
   IF DBMS_SQL.IS_OPEN (L_PT_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR (L_PT_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'Save1PtGroupKey'));
END SAVE1PTGROUPKEY;

FUNCTION GETPTCONDITIONSET
(A_PT             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_VERSION        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PTROW          OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_CS             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_DESCRIPTION    OUT    UNAPIGEN.VC40_TABLE_TYPE,    
 A_NR_OF_ROWS     IN OUT NUMBER,                      
 A_WHERE_CLAUSE   IN     VARCHAR2)                    
RETURN NUMBER IS

L_PT             VARCHAR2(20);
L_VERSION        VARCHAR2(20);
L_PTROW          NUMBER;
L_CS             VARCHAR2(20);
L_DESCRIPTION    VARCHAR2(40);
L_PTCS_CURSOR    INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY ptcs.pt, ptcs.version, ptcs.ptrow'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uvpt pt WHERE pt.version_is_current = ''1'' '||
                        'AND ptcs.version = pt.version '||
                        'AND ptcs.pt = pt.pt '||
                        'AND ptcs.pt = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' ORDER BY ptcs.ptrow';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_PTCS_CURSOR := DBMS_SQL.OPEN_CURSOR;

   L_SQL_STRING := 'SELECT ptcs.pt, ptcs.version, ptcs.ptrow, ptcs.cs, ptcs.description '||
                    'FROM dd'||UNAPIGEN.P_DD||'.uvptcs ptcs '|| L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_PTCS_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_PTCS_CURSOR, 1, L_PT,          20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCS_CURSOR, 2, L_VERSION,     20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCS_CURSOR, 3, L_PTROW          );
   DBMS_SQL.DEFINE_COLUMN(L_PTCS_CURSOR, 4, L_CS,          20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCS_CURSOR, 5, L_DESCRIPTION, 40);
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_PTCS_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_PTCS_CURSOR,    1,     L_PT          );
      DBMS_SQL.COLUMN_VALUE(L_PTCS_CURSOR,    2,     L_VERSION     );
      DBMS_SQL.COLUMN_VALUE(L_PTCS_CURSOR,    3,     L_PTROW       );
      DBMS_SQL.COLUMN_VALUE(L_PTCS_CURSOR,    4,     L_CS          );
      DBMS_SQL.COLUMN_VALUE(L_PTCS_CURSOR,    5,     L_DESCRIPTION );

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_PT          (L_FETCHED_ROWS) := L_PT         ;
      A_VERSION     (L_FETCHED_ROWS) := L_VERSION    ;
      A_PTROW       (L_FETCHED_ROWS) := L_PTROW      ;
      A_CS          (L_FETCHED_ROWS) := L_CS         ;
      A_DESCRIPTION (L_FETCHED_ROWS) := L_DESCRIPTION;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_PTCS_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_PTCS_CURSOR);

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
              'GetPtConditionSet', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (L_PTCS_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_PTCS_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPTCONDITIONSET;

FUNCTION SAVEPTCONDITIONSET
(A_PT             IN    VARCHAR2,                   
 A_VERSION        IN    VARCHAR2,                   
 A_PTROW          IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_CS             IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_NR_OF_ROWS     IN    NUMBER,                     
 A_MODIFY_REASON  IN    VARCHAR2)                   
RETURN NUMBER  IS

L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_SEQ_NO       NUMBER;
L_DESCRIPTION  VARCHAR2(40);
A_CS_VERSION   VARCHAR2(20);

CURSOR L_CSCN_CURSOR(C_CS VARCHAR2) IS
SELECT CN, CNSEQ, VALUE
FROM UTCSCN
WHERE CS = C_CS;

L_CSCN_REC       L_CSCN_CURSOR%ROWTYPE;
   
CURSOR L_PCS_CURSOR(C_CS VARCHAR2) IS
SELECT DESCRIPTION
FROM UTCS
WHERE CS = C_CS;

BEGIN
   
   A_CS_VERSION := UNVERSION.P_NO_VERSION;
   IF A_CS_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;
   

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PT, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('pt', A_PT, A_VERSION, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPT
   SET ALLOW_MODIFY = '#'
   WHERE PT = A_PT 
     AND VERSION = A_VERSION;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   DELETE UTPTCS
   WHERE PT = A_PT 
     AND VERSION = A_VERSION;
     
   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF NVL(A_CS(L_SEQ_NO), ' ') = ' ' OR 
         A_PTROW(L_SEQ_NO) IS NULL THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;
      
      OPEN L_PCS_CURSOR(A_CS(L_SEQ_NO));
      FETCH L_PCS_CURSOR INTO L_DESCRIPTION;
      CLOSE L_PCS_CURSOR;
      
      INSERT INTO UTPTCS (PT, VERSION, PTROW, CS, DESCRIPTION)
      VALUES (A_PT, A_VERSION, A_PTROW(L_SEQ_NO), A_CS(L_SEQ_NO), L_DESCRIPTION);
      
   END LOOP;

   DELETE UTPTCSCN 
   WHERE PT = A_PT
   AND VERSION = A_VERSION
   AND CS NOT IN (SELECT CS
                  FROM UTPTCS 
                  WHERE PT = A_PT 
                  AND VERSION = A_VERSION);

   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SavePtConditionSet', UNAPIGEN.P_EVMGR_NAME, 'pt', A_PT, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, 'version='||A_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                          WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'protocol "'||A_PT||'" Condition Sets are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('SavePtConditionSet', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SavePtConditionSet'));
END SAVEPTCONDITIONSET;

FUNCTION GETPTTIMEPOINT
(A_PT                   OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_VERSION              OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PTCOLUMN             OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_TP                   OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_TP_UNIT              OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_ALLOW_UPFRONT        OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_ALLOW_UPFRONT_UNIT   OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_ALLOW_OVERDUE        OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_ALLOW_OVERDUE_UNIT   OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_NR_OF_ROWS           IN OUT NUMBER,                      
 A_WHERE_CLAUSE         IN     VARCHAR2)                    
RETURN NUMBER IS

L_PT                  VARCHAR2(20);
L_VERSION             VARCHAR2(20);
L_PTCOLUMN            NUMBER;
L_TP                  VARCHAR2(20);
L_TP_UNIT             VARCHAR2(20);
L_ALLOW_UPFRONT       NUMBER;
L_ALLOW_UPFRONT_UNIT  VARCHAR2(20);
L_ALLOW_OVERDUE       NUMBER;
L_ALLOW_OVERDUE_UNIT  VARCHAR2(20);
L_PTTP_CURSOR    INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY pttp.pt, pttp.version, pttp.ptcolumn'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uvpt pt WHERE pt.version_is_current = ''1'' '||
                        'AND pttp.version = pt.version '||
                        'AND pttp.pt = pt.pt '||
                        'AND pttp.pt = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' ORDER BY pttp.ptcolumn';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_PTTP_CURSOR := DBMS_SQL.OPEN_CURSOR;

   L_SQL_STRING := 'SELECT pttp.pt, pttp.version, pttp.ptcolumn, pttp.tp, pttp.tp_unit, '||
                   'allow_upfront, allow_upfront_unit, allow_overdue, allow_overdue_unit ' ||
                    'FROM dd'||UNAPIGEN.P_DD||'.uvpttp pttp '|| L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_PTTP_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_PTTP_CURSOR, 1, L_PT                   ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTTP_CURSOR, 2, L_VERSION              ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTTP_CURSOR, 3, L_PTCOLUMN                   );
   DBMS_SQL.DEFINE_COLUMN(L_PTTP_CURSOR, 4, L_TP                   ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTTP_CURSOR, 5, L_TP_UNIT              ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTTP_CURSOR, 6, L_ALLOW_UPFRONT              );
   DBMS_SQL.DEFINE_COLUMN(L_PTTP_CURSOR, 7, L_ALLOW_UPFRONT_UNIT   ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTTP_CURSOR, 8, L_ALLOW_OVERDUE              );
   DBMS_SQL.DEFINE_COLUMN(L_PTTP_CURSOR, 9, L_ALLOW_OVERDUE_UNIT   ,   20);
                                                                             
 
 L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_PTTP_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_PTTP_CURSOR, 1, L_PT                 );
      DBMS_SQL.COLUMN_VALUE(L_PTTP_CURSOR, 2, L_VERSION            );
      DBMS_SQL.COLUMN_VALUE(L_PTTP_CURSOR, 3, L_PTCOLUMN           );
      DBMS_SQL.COLUMN_VALUE(L_PTTP_CURSOR, 4, L_TP                 );
      DBMS_SQL.COLUMN_VALUE(L_PTTP_CURSOR, 5, L_TP_UNIT            );
      DBMS_SQL.COLUMN_VALUE(L_PTTP_CURSOR, 6, L_ALLOW_UPFRONT      );
      DBMS_SQL.COLUMN_VALUE(L_PTTP_CURSOR, 7, L_ALLOW_UPFRONT_UNIT );
      DBMS_SQL.COLUMN_VALUE(L_PTTP_CURSOR, 8, L_ALLOW_OVERDUE      );
      DBMS_SQL.COLUMN_VALUE(L_PTTP_CURSOR, 9, L_ALLOW_OVERDUE_UNIT );

      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_PT                     (L_FETCHED_ROWS) := L_PT                ;
      A_VERSION                (L_FETCHED_ROWS) := L_VERSION           ;
      A_PTCOLUMN               (L_FETCHED_ROWS) := L_PTCOLUMN          ;
      A_TP                     (L_FETCHED_ROWS) := L_TP                ;
      A_TP_UNIT                (L_FETCHED_ROWS) := L_TP_UNIT           ;
      A_ALLOW_UPFRONT          (L_FETCHED_ROWS) := L_ALLOW_UPFRONT     ;
      A_ALLOW_UPFRONT_UNIT     (L_FETCHED_ROWS) := L_ALLOW_UPFRONT_UNIT;
      A_ALLOW_OVERDUE          (L_FETCHED_ROWS) := L_ALLOW_OVERDUE     ;
      A_ALLOW_OVERDUE_UNIT     (L_FETCHED_ROWS) := L_ALLOW_OVERDUE_UNIT;
                                                    
      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_PTTP_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_PTTP_CURSOR);

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
              'GetPtTimePoint', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (L_PTTP_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_PTTP_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPTTIMEPOINT;

FUNCTION SAVEPTTIMEPOINT
(A_PT                   IN    VARCHAR2,                   
 A_VERSION              IN    VARCHAR2,                   
 A_PTCOLUMN             IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_TP                   IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_TP_UNIT              IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_ALLOW_UPFRONT        IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_ALLOW_UPFRONT_UNIT   IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_ALLOW_OVERDUE        IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_ALLOW_OVERDUE_UNIT   IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_NR_OF_ROWS           IN    NUMBER,                     
 A_MODIFY_REASON        IN    VARCHAR2)                   
RETURN NUMBER IS

L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_SEQ_NO       NUMBER;

CURSOR L_PCS_CURSOR(C_CS VARCHAR2) IS
SELECT DESCRIPTION
FROM UTCS
WHERE CS = C_CS;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PT, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;


   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('pt', A_PT, A_VERSION, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPT
   SET ALLOW_MODIFY = '#'
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   DELETE UTPTTP
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
   
   IF A_PTCOLUMN(L_SEQ_NO) IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID ;
      RAISE STPERROR;
   END IF;
   
   IF A_TP(L_SEQ_NO) IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NULLTIMEPOINT ;
      RAISE STPERROR;
   END IF;
 
   IF A_TP_UNIT(L_SEQ_NO) NOT IN ('MI','HH','DD','WW','MM','YY','MF','YF') THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_TPUNIT;
      RAISE STPERROR;         
   END IF;
    
      INSERT INTO UTPTTP (PT, VERSION, PTCOLUMN, TP, TP_UNIT, ALLOW_UPFRONT, ALLOW_UPFRONT_UNIT, 
                           ALLOW_OVERDUE, ALLOW_OVERDUE_UNIT)
      VALUES (A_PT, A_VERSION, A_PTCOLUMN(L_SEQ_NO), A_TP(L_SEQ_NO), A_TP_UNIT(L_SEQ_NO), 
               A_ALLOW_UPFRONT(L_SEQ_NO), A_ALLOW_UPFRONT_UNIT(L_SEQ_NO), A_ALLOW_OVERDUE(L_SEQ_NO), 
               A_ALLOW_OVERDUE_UNIT(L_SEQ_NO));
   END LOOP;

   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SavePtTimePoint', UNAPIGEN.P_EVMGR_NAME, 'pt', A_PT, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, 'version='||A_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                          WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'protocol "'||A_PT||'" Time points are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('SavePtTimePoint', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SavePtTimePoint'));
END SAVEPTTIMEPOINT;

FUNCTION GETPTCELLSAMPLETYPE
(A_PT             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_VERSION        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PTROW          OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_PTCOLUMN       OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_SEQ            OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_ST             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_ST_VERSION     OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_DESCRIPTION    OUT    UNAPIGEN.VC40_TABLE_TYPE,    
 A_NR_PLANNED_SC  OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_SC_LC          OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_SC_LC_VERSION  OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_SC_UC          OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_SC_UC_VERSION  OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_ADD_STPP       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_ADD_STIP       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_NR_SC_MAX      OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_INHERIT_AU     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   
 A_NR_OF_ROWS     IN OUT NUMBER,                      
 A_WHERE_CLAUSE   IN     VARCHAR2)                    
RETURN NUMBER IS

L_PT             VARCHAR2(20);
L_VERSION        VARCHAR2(20);
L_PTROW          NUMBER;
L_PTCOLUMN       NUMBER;
L_SEQ            NUMBER;
L_ST             VARCHAR2(20);
L_ST_VERSION     VARCHAR2(20);
L_NR_PLANNED_SC  NUMBER;
L_SC_LC          VARCHAR2(20);
L_SC_LC_VERSION  VARCHAR2(20);
L_SC_UC          VARCHAR2(20);
L_SC_UC_VERSION  VARCHAR2(20);
L_ADD_STPP       CHAR(1);
L_ADD_STIP       CHAR(1);
L_NR_SC_MAX      NUMBER;
L_INHERIT_AU     CHAR(1);

L_PTCELLST_CURSOR    INTEGER;
 
BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY ptcellst.pt, ptcellst.version, ptcellst.ptrow, ptcellst.ptcolumn'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uvpt pt WHERE pt.version_is_current = ''1'' '||
                        'AND ptcellst.version = pt.version '||
                        'AND ptcellst.pt = pt.pt '||
                        'AND ptcellst.pt = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' ORDER BY ptcellst.ptcolumn';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_PTCELLST_CURSOR := DBMS_SQL.OPEN_CURSOR;

   L_SQL_STRING := 'SELECT ptcellst.pt, ptcellst.version, ptcellst.ptrow, ptcellst.ptcolumn, ptcellst.seq, ptcellst.st,' ||
                   '  ptcellst.st_version, ptcellst.nr_planned_sc, ptcellst.sc_lc, ptcellst.sc_lc_version, ' ||
                   '  ptcellst.sc_uc, ptcellst.sc_uc_version, ptcellst.add_stpp, ptcellst.add_stip, ' ||
                   '  ptcellst.nr_sc_max, ptcellst.inherit_au' ||
                   ' FROM dd'||UNAPIGEN.P_DD||'.uvptcellst ptcellst '|| L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_PTCELLST_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      1,  L_PT              ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      2,  L_VERSION         ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      3,  L_PTROW                 );
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      4,  L_PTCOLUMN              );
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      5,  L_SEQ                   );
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      6,  L_ST              ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      7,  L_ST_VERSION      ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      8,  L_NR_PLANNED_SC         );
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      9,  L_SC_LC           ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      10, L_SC_LC_VERSION   ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      11, L_SC_UC           ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      12, L_SC_UC_VERSION   ,   20);
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PTCELLST_CURSOR, 13, L_ADD_STPP        ,   1 );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PTCELLST_CURSOR, 14, L_ADD_STIP        ,   1 );
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLST_CURSOR,      15, L_NR_SC_MAX             );
   DBMS_SQL.DEFINE_COLUMN_CHAR(L_PTCELLST_CURSOR, 16, L_INHERIT_AU      ,   1 );
                                                                          
 
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_PTCELLST_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      1,  L_PT            );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      2,  L_VERSION       );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      3,  L_PTROW         );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      4,  L_PTCOLUMN      );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      5,  L_SEQ           );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      6,  L_ST            );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      7,  L_ST_VERSION    );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      8,  L_NR_PLANNED_SC );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      9,  L_SC_LC         );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      10, L_SC_LC_VERSION );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      11, L_SC_UC         );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      12, L_SC_UC_VERSION );
      DBMS_SQL.COLUMN_VALUE_CHAR(L_PTCELLST_CURSOR, 13, L_ADD_STPP      );
      DBMS_SQL.COLUMN_VALUE_CHAR(L_PTCELLST_CURSOR, 14, L_ADD_STIP      );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLST_CURSOR,      15, L_NR_SC_MAX     );
      DBMS_SQL.COLUMN_VALUE_CHAR(L_PTCELLST_CURSOR, 16, L_INHERIT_AU    );
                                                                   
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_PT                (L_FETCHED_ROWS) := L_PT           ;
      A_VERSION           (L_FETCHED_ROWS) := L_VERSION      ;
      A_PTROW             (L_FETCHED_ROWS) := L_PTROW        ;
      A_PTCOLUMN          (L_FETCHED_ROWS) := L_PTCOLUMN     ;
      A_SEQ               (L_FETCHED_ROWS) := L_SEQ          ;
      A_ST                (L_FETCHED_ROWS) := L_ST           ;
      A_ST_VERSION        (L_FETCHED_ROWS) := L_ST_VERSION   ;
      A_NR_PLANNED_SC     (L_FETCHED_ROWS) := L_NR_PLANNED_SC;
      A_SC_LC             (L_FETCHED_ROWS) := L_SC_LC        ;
      A_SC_LC_VERSION     (L_FETCHED_ROWS) := L_SC_LC_VERSION;
      A_SC_UC             (L_FETCHED_ROWS) := L_SC_UC        ;
      A_SC_UC_VERSION     (L_FETCHED_ROWS) := L_SC_UC_VERSION;
      A_ADD_STPP          (L_FETCHED_ROWS) := L_ADD_STPP     ;
      A_ADD_STIP          (L_FETCHED_ROWS) := L_ADD_STIP     ;
      A_NR_SC_MAX         (L_FETCHED_ROWS) := L_NR_SC_MAX    ;
      A_INHERIT_AU        (L_FETCHED_ROWS) := L_INHERIT_AU   ;
                                                
      L_SQL_STRING:=   'SELECT description '
                     ||'FROM dd'||UNAPIGEN.P_DD||'.uvst '
                     ||'WHERE version = NVL(UNAPIGEN.UseVersion(''st'',:l_st,:l_st_version), '
                     ||                    'UNAPIGEN.UseVersion(''st'',:l_st,''*'')) '
                     ||'AND st = :l_st';
      BEGIN
         EXECUTE IMMEDIATE L_SQL_STRING 
         INTO A_DESCRIPTION(L_FETCHED_ROWS)
         USING L_ST, L_ST_VERSION, L_ST, L_ST;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            
            NULL;
      END;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_PTCELLST_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_PTCELLST_CURSOR);

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
              'GetPtCellSampleType', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (L_PTCELLST_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_PTCELLST_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPTCELLSAMPLETYPE;


FUNCTION SAVEPTCELLSAMPLETYPE
(A_PT            IN    VARCHAR2,                   
 A_VERSION       IN    VARCHAR2,                   
 A_PTROW         IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_PTCOLUMN      IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_SEQ           IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_ST            IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_ST_VERSION    IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_NR_PLANNED_SC IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_SC_LC         IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_SC_LC_VERSION IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_SC_UC         IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_SC_UC_VERSION IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_ADD_STPP      IN    UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_ADD_STIP      IN    UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_NR_SC_MAX     IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_INHERIT_AU    IN    UNAPIGEN.CHAR1_TABLE_TYPE,  
 A_NR_OF_ROWS    IN    NUMBER,                     
 A_MODIFY_REASON IN    VARCHAR2)                   
RETURN NUMBER  IS

L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_SEQ_NO       NUMBER;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PT, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('pt', A_PT, A_VERSION, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPT
   SET ALLOW_MODIFY = '#'
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   DELETE UTPTCELLST
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_PTROW(L_SEQ_NO) IS NULL OR
         A_PTCOLUMN(L_SEQ_NO) IS NULL OR
         A_SEQ(L_SEQ_NO) IS NULL OR
         NVL(A_ST(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;
      
      INSERT INTO UTPTCELLST (PT, VERSION, PTROW, PTCOLUMN, SEQ, ST, ST_VERSION, NR_PLANNED_SC, SC_LC, 
            SC_LC_VERSION, SC_UC, SC_UC_VERSION, ADD_STPP, ADD_STIP, NR_SC_MAX, INHERIT_AU)
      VALUES (A_PT, A_VERSION, A_PTROW(L_SEQ_NO), A_PTCOLUMN(L_SEQ_NO), A_SEQ(L_SEQ_NO), A_ST(L_SEQ_NO), 
         A_ST_VERSION(L_SEQ_NO), A_NR_PLANNED_SC(L_SEQ_NO), A_SC_LC(L_SEQ_NO), A_SC_LC_VERSION(L_SEQ_NO), 
         A_SC_UC(L_SEQ_NO), A_SC_UC_VERSION(L_SEQ_NO), A_ADD_STPP(L_SEQ_NO), A_ADD_STIP(L_SEQ_NO), 
         A_NR_SC_MAX(L_SEQ_NO), A_INHERIT_AU(L_SEQ_NO));
   END LOOP;

   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SavePtCellst', UNAPIGEN.P_EVMGR_NAME, 'pt', A_PT, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, 'version='||A_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                          WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'protocol "'||A_PT||'" Cell Sample types are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('SavePtCellSampleType', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SavePtCellSampleType'));
END SAVEPTCELLSAMPLETYPE;

FUNCTION GETPTCELLINFOPROFILE
(A_PT             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_VERSION        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PTROW          OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_PTCOLUMN       OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_SEQ            OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_IP             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_IP_VERSION     OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_DESCRIPTION    OUT    UNAPIGEN.VC40_TABLE_TYPE,    
 A_NR_OF_ROWS     IN OUT NUMBER,                      
 A_WHERE_CLAUSE   IN     VARCHAR2)                    
RETURN NUMBER IS

L_PT             VARCHAR2(20);
L_VERSION        VARCHAR2(20);
L_PTROW          NUMBER;
L_PTCOLUMN       NUMBER;
L_SEQ            NUMBER;
L_IP             VARCHAR2(20);
L_IP_VERSION     VARCHAR2(20);

L_PTCELLIP_CURSOR    INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY ptcellip.pt, ptcellip.version, ptcellip.ptrow, ptcellip.ptcolumn'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uvpt pt WHERE pt.version_is_current = ''1'' '||
                        'AND ptcellip.version = pt.version '||
                        'AND ptcellip.pt = pt.pt '||
                        'AND ptcellip.pt = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' ORDER BY ptcellip.ptcolumn';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_PTCELLIP_CURSOR := DBMS_SQL.OPEN_CURSOR;

   L_SQL_STRING := 'SELECT ptcellip.pt, ptcellip.version, ptcellip.ptrow, ptcellip.ptcolumn, ptcellip.seq, ptcellip.ip,' ||
                   '  ptcellip.ip_version' ||
                   ' FROM dd'||UNAPIGEN.P_DD||'.uvptcellip ptcellip '|| L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_PTCELLIP_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_PTCELLIP_CURSOR,      1,  L_PT              ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLIP_CURSOR,      2,  L_VERSION         ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLIP_CURSOR,      3,  L_PTROW                 );
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLIP_CURSOR,      4,  L_PTCOLUMN              );
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLIP_CURSOR,      5,  L_SEQ                   );
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLIP_CURSOR,      6,  L_IP               ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLIP_CURSOR,      7,  L_IP_VERSION      ,   20);                                                                          
 
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_PTCELLIP_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_PTCELLIP_CURSOR,      1,  L_PT            );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLIP_CURSOR,      2,  L_VERSION       );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLIP_CURSOR,      3,  L_PTROW         );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLIP_CURSOR,      4,  L_PTCOLUMN      );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLIP_CURSOR,      5,  L_SEQ           );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLIP_CURSOR,      6,  L_IP            );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLIP_CURSOR,      7,  L_IP_VERSION    );
                                                                   
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_PT                (L_FETCHED_ROWS) := L_PT           ;
      A_VERSION           (L_FETCHED_ROWS) := L_VERSION      ;
      A_PTROW             (L_FETCHED_ROWS) := L_PTROW        ;
      A_PTCOLUMN          (L_FETCHED_ROWS) := L_PTCOLUMN     ;
      A_SEQ               (L_FETCHED_ROWS) := L_SEQ          ;
      A_IP                (L_FETCHED_ROWS) := L_IP           ;
      A_IP_VERSION        (L_FETCHED_ROWS) := L_IP_VERSION   ;
                                                
      L_SQL_STRING:=   'SELECT description '
                     ||'FROM dd'||UNAPIGEN.P_DD||'.uvip '
                     ||'WHERE version = NVL(UNAPIGEN.UseVersion(''ip'',:l_ip,:l_ip_version), '
                     ||                    'UNAPIGEN.UseVersion(''ip'',:l_ip,''*'')) '
                     ||'AND ip = :l_ip';
      BEGIN
         EXECUTE IMMEDIATE L_SQL_STRING 
         INTO A_DESCRIPTION(L_FETCHED_ROWS)
         USING L_IP, L_IP_VERSION, L_IP, L_IP;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            
            NULL;
      END;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_PTCELLIP_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_PTCELLIP_CURSOR);

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
              'GetPtCellInfoProfile', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (L_PTCELLIP_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_PTCELLIP_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPTCELLINFOPROFILE;

FUNCTION SAVEPTCELLINFOPROFILE
(A_PT            IN    VARCHAR2,                   
 A_VERSION       IN    VARCHAR2,                   
 A_PTROW         IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_PTCOLUMN      IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_SEQ           IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_IP            IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_IP_VERSION    IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_NR_OF_ROWS     IN    NUMBER,                     
 A_MODIFY_REASON  IN    VARCHAR2)                   
RETURN NUMBER  IS

L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_SEQ_NO       NUMBER;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PT, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('pt', A_PT, A_VERSION, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPT
   SET ALLOW_MODIFY = '#'
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   DELETE UTPTCELLIP
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_PTROW(L_SEQ_NO) IS NULL OR
         A_PTCOLUMN(L_SEQ_NO) IS NULL OR
         A_SEQ(L_SEQ_NO) IS NULL OR
         NVL(A_IP(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;
      
      INSERT INTO UTPTCELLIP (PT, VERSION, PTROW, PTCOLUMN, SEQ, IP, IP_VERSION)
      VALUES (A_PT, A_VERSION, A_PTROW(L_SEQ_NO), A_PTCOLUMN(L_SEQ_NO), A_SEQ(L_SEQ_NO), 
               A_IP(L_SEQ_NO), A_IP_VERSION(L_SEQ_NO));
   END LOOP;

   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SavePtCellIp', UNAPIGEN.P_EVMGR_NAME, 'pt', A_PT, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, 'version='||A_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                          WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'protocol "'||A_PT||'" cell infoprofiles are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('SavePtCellInfoProfile', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SavePtCellInfoProfile'));
END SAVEPTCELLINFOPROFILE;

FUNCTION GETPTCELLPARAMETERPROFILE
(A_PT             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_VERSION        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PTROW          OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_PTCOLUMN       OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_SEQ            OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_PP             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_VERSION     OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY1        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY2        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY3        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY4        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PP_KEY5        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_DESCRIPTION    OUT    UNAPIGEN.VC40_TABLE_TYPE,    
 A_NR_OF_ROWS     IN OUT NUMBER,                      
 A_WHERE_CLAUSE   IN     VARCHAR2)                    
RETURN NUMBER IS

L_PT             VARCHAR2(20);
L_VERSION        VARCHAR2(20);
L_PTROW          NUMBER;
L_PTCOLUMN       NUMBER;
L_SEQ            NUMBER;
L_PP             VARCHAR2(20);
L_PP_VERSION     VARCHAR2(20);
L_PP_KEY1        VARCHAR2(20);
L_PP_KEY2        VARCHAR2(20);
L_PP_KEY3        VARCHAR2(20);
L_PP_KEY4        VARCHAR2(20);
L_PP_KEY5        VARCHAR2(20);

L_PTCELLPP_CURSOR    INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY ptcellpp.pt, ptcellpp.version, ptcellpp.ptrow, ptcellpp.ptcolumn'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uvpt pt WHERE pt.version_is_current = ''1'' '||
                        'AND ptcellpp.version = pt.version '||
                        'AND ptcellpp.pt = pt.pt '||
                        'AND ptcellpp.pt = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' ORDER BY ptcellpp.ptcolumn';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_PTCELLPP_CURSOR := DBMS_SQL.OPEN_CURSOR;

   L_SQL_STRING := 'SELECT ptcellpp.pt, ptcellpp.version, ptcellpp.ptrow, ptcellpp.ptcolumn, ptcellpp.seq, ptcellpp.pp,' ||
                   '  ptcellpp.pp_version, ptcellpp.pp_key1, ptcellpp.pp_key2, ptcellpp.pp_key3, ptcellpp.pp_key4, ptcellpp.pp_key5' ||
                   ' FROM dd'||UNAPIGEN.P_DD||'.uvptcellpp ptcellpp '|| L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_PTCELLPP_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,      1,  L_PT              ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,      2,  L_VERSION         ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,      3,  L_PTROW                 );
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,      4,  L_PTCOLUMN              );
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,      5,  L_SEQ                   );
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,      6,  L_PP              ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,      7,  L_PP_VERSION      ,   20);                                                                          
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,      8,  L_PP_KEY1         ,   20);                                                                          
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,      9,  L_PP_KEY2         ,   20);                                                                          
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,     10,  L_PP_KEY3         ,   20);                                                                          
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,     11,  L_PP_KEY4         ,   20);                                                                          
   DBMS_SQL.DEFINE_COLUMN(L_PTCELLPP_CURSOR,     12,  L_PP_KEY5         ,   20);                                                                          
 
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_PTCELLPP_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,      1,  L_PT            );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,      2,  L_VERSION       );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,      3,  L_PTROW         );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,      4,  L_PTCOLUMN      );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,      5,  L_SEQ           );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,      6,  L_PP            );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,      7,  L_PP_VERSION    );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,      8,  L_PP_KEY1       );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,      9,  L_PP_KEY2       );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,     10,  L_PP_KEY3       );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,     11,  L_PP_KEY4       );
      DBMS_SQL.COLUMN_VALUE(L_PTCELLPP_CURSOR,     12,  L_PP_KEY5       );
                                                                   
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_PT                (L_FETCHED_ROWS) := L_PT           ;
      A_VERSION           (L_FETCHED_ROWS) := L_VERSION      ;
      A_PTROW             (L_FETCHED_ROWS) := L_PTROW        ;
      A_PTCOLUMN          (L_FETCHED_ROWS) := L_PTCOLUMN     ;
      A_SEQ               (L_FETCHED_ROWS) := L_SEQ          ;
      A_PP                (L_FETCHED_ROWS) := L_PP           ;
      A_PP_VERSION        (L_FETCHED_ROWS) := L_PP_VERSION   ;
      A_PP_KEY1           (L_FETCHED_ROWS) := L_PP_KEY1      ;
      A_PP_KEY2           (L_FETCHED_ROWS) := L_PP_KEY2      ;
      A_PP_KEY3           (L_FETCHED_ROWS) := L_PP_KEY3      ;
      A_PP_KEY4           (L_FETCHED_ROWS) := L_PP_KEY4      ;
      A_PP_KEY5           (L_FETCHED_ROWS) := L_PP_KEY5      ;
                                                
      A_DESCRIPTION(L_FETCHED_ROWS) := NULL;
      L_SQL_STRING:=   'SELECT description '
                     ||'FROM dd'||UNAPIGEN.P_DD||'.uvpp '
                     ||'WHERE version = NVL(UNAPIGEN.UsePpVersion(:l_pp,:l_pp_version, :l_pp_key1, :l_pp_key2, :l_pp_key3, :l_pp_key4, :l_pp_key5), '
                     ||                    'UNAPIGEN.UsePpVersion(:l_pp,''*'', :l_pp_key1, :l_pp_key2, :l_pp_key3, :l_pp_key4, :l_pp_key5)) '
                     ||'AND pp = :l_pp '
                     ||'AND pp_key1 = :l_pp_key1 '
                     ||'AND pp_key2 = :l_pp_key2 '
                     ||'AND pp_key3 = :l_pp_key3 '
                     ||'AND pp_key4 = :l_pp_key4 '
                     ||'AND pp_key5 = :l_pp_key5';
      BEGIN
         EXECUTE IMMEDIATE L_SQL_STRING 
         INTO A_DESCRIPTION(L_FETCHED_ROWS)
         USING L_PP, L_PP_VERSION, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5,
               L_PP, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5,
               L_PP, L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            
            NULL;
      END;

      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_PTCELLPP_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_PTCELLPP_CURSOR);

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
              'GetPtCellParameterProfile', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (L_PTCELLPP_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_PTCELLPP_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPTCELLPARAMETERPROFILE;

FUNCTION SAVEPTCELLPARAMETERPROFILE
(A_PT            IN    VARCHAR2,                   
 A_VERSION       IN    VARCHAR2,                   
 A_PTROW         IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_PTCOLUMN      IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_SEQ           IN    UNAPIGEN.NUM_TABLE_TYPE,    
 A_PP            IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_PP_VERSION    IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_PP_KEY1       IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_PP_KEY2       IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_PP_KEY3       IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_PP_KEY4       IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_PP_KEY5       IN    UNAPIGEN.VC20_TABLE_TYPE,   
 A_NR_OF_ROWS    IN    NUMBER,                     
 A_MODIFY_REASON IN    VARCHAR2)                   
RETURN NUMBER  IS

L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_SEQ_NO       NUMBER;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PT, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('pt', A_PT, A_VERSION, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPT
   SET ALLOW_MODIFY = '#'
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   DELETE UTPTCELLPP
   WHERE VERSION = A_VERSION
     AND PT = A_PT;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_PTROW(L_SEQ_NO) IS NULL OR
         A_PTCOLUMN(L_SEQ_NO) IS NULL OR
         A_SEQ(L_SEQ_NO) IS NULL OR
         NVL(A_PP(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;

      IF A_PP_KEY1(L_SEQ_NO) IS NULL OR
         A_PP_KEY2(L_SEQ_NO) IS NULL OR
         A_PP_KEY3(L_SEQ_NO) IS NULL OR
         A_PP_KEY4(L_SEQ_NO) IS NULL OR
         A_PP_KEY5(L_SEQ_NO) IS NULL THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOPPKEYID;
         RAISE STPERROR;
      END IF;
      
      INSERT INTO UTPTCELLPP (PT, VERSION, PTROW, PTCOLUMN, SEQ, 
                              PP, PP_VERSION, PP_KEY1, PP_KEY2, PP_KEY3, PP_KEY4, PP_KEY5)
      VALUES (A_PT, A_VERSION, A_PTROW(L_SEQ_NO), A_PTCOLUMN(L_SEQ_NO), A_SEQ(L_SEQ_NO), 
               A_PP(L_SEQ_NO), A_PP_VERSION(L_SEQ_NO), A_PP_KEY1(L_SEQ_NO), A_PP_KEY2(L_SEQ_NO),
               A_PP_KEY3(L_SEQ_NO), A_PP_KEY4(L_SEQ_NO), A_PP_KEY5(L_SEQ_NO));
   END LOOP;

   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SavePtCellPp', UNAPIGEN.P_EVMGR_NAME, 'pt', A_PT, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, 'version='||A_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                          WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'protocol "'||A_PT||'" cell parameter profiles are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('SavePtCellParameterProfile', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SavePtCellParameterProfile'));
END SAVEPTCELLPARAMETERPROFILE;

FUNCTION GETPTCSCONDITION
(A_PT             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_VERSION        OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_PTROW          OUT    UNAPIGEN.NUM_TABLE_TYPE,     
 A_CS             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_CN             OUT    UNAPIGEN.VC20_TABLE_TYPE,    
 A_VALUE          OUT    UNAPIGEN.VC40_TABLE_TYPE,    
 A_NR_OF_ROWS     IN OUT NUMBER,                      
 A_WHERE_CLAUSE   IN     VARCHAR2)                    
RETURN NUMBER IS

L_PT             VARCHAR2(20);
L_VERSION        VARCHAR2(20);
L_PTROW          NUMBER;
L_CS             VARCHAR2(20);
L_CN             VARCHAR2(20);
L_VALUE          VARCHAR2(40);

L_PTCSCN_CURSOR    INTEGER;

BEGIN

   IF NVL(A_NR_OF_ROWS,0) = 0 THEN
      A_NR_OF_ROWS := UNAPIGEN.P_DEFAULT_CHUNK_SIZE;
   ELSIF A_NR_OF_ROWS < 0 OR A_NR_OF_ROWS > UNAPIGEN.P_MAX_CHUNK_SIZE THEN
      RETURN (UNAPIGEN.DBERR_NROFROWS);
   END IF;

   IF NVL(A_WHERE_CLAUSE, ' ') = ' ' THEN
      L_WHERE_CLAUSE := 'ORDER BY ptcscn.pt, ptcscn.version, ptcscn.ptrow, ptcscn.cs, ptcscn.cnseq'; 
   ELSIF UPPER(SUBSTR(A_WHERE_CLAUSE,1,6)) <> 'WHERE ' THEN
      L_WHERE_CLAUSE := ', dd'||UNAPIGEN.P_DD||'.uvpt pt WHERE pt.version_is_current = ''1'' '||
                        'AND  ptcscn.version = pt.version '||
                        'AND  ptcscn.pt = pt.pt '||
                        'AND  ptcscn.pt = ''' || REPLACE(A_WHERE_CLAUSE, '''', '''''') || 
                        ''' ORDER BY  ptcscn.ptrow';
   ELSE
      L_WHERE_CLAUSE := A_WHERE_CLAUSE; 
   END IF;

   L_PTCSCN_CURSOR := DBMS_SQL.OPEN_CURSOR;

   L_SQL_STRING := 'SELECT ptcscn.pt, ptcscn.version, ptcscn.ptrow, ptcscn.cs, ptcscn.cn, ptcscn.value ' ||
                   'FROM dd'||UNAPIGEN.P_DD||'.uvptcscn ptcscn '|| L_WHERE_CLAUSE;

   DBMS_SQL.PARSE(L_PTCSCN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

   DBMS_SQL.DEFINE_COLUMN(L_PTCSCN_CURSOR,      1,  L_PT         ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCSCN_CURSOR,      2,  L_VERSION    ,   20);
   DBMS_SQL.DEFINE_COLUMN(L_PTCSCN_CURSOR,      3,  L_PTROW             );
   DBMS_SQL.DEFINE_COLUMN(L_PTCSCN_CURSOR,      4,  L_CS         ,   20 );
   DBMS_SQL.DEFINE_COLUMN(L_PTCSCN_CURSOR,      5,  L_CN         ,   20 );
   DBMS_SQL.DEFINE_COLUMN(L_PTCSCN_CURSOR,      6,  L_VALUE      ,   40);                                                                          
 
   L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_PTCSCN_CURSOR);
   L_FETCHED_ROWS := 0;

   LOOP
      EXIT WHEN L_RESULT = 0 OR L_FETCHED_ROWS >= A_NR_OF_ROWS;

      DBMS_SQL.COLUMN_VALUE(L_PTCSCN_CURSOR,      1,  L_PT         );
      DBMS_SQL.COLUMN_VALUE(L_PTCSCN_CURSOR,      2,  L_VERSION    );
      DBMS_SQL.COLUMN_VALUE(L_PTCSCN_CURSOR,      3,  L_PTROW      );
      DBMS_SQL.COLUMN_VALUE(L_PTCSCN_CURSOR,      4,  L_CS         );
      DBMS_SQL.COLUMN_VALUE(L_PTCSCN_CURSOR,      5,  L_CN         );
      DBMS_SQL.COLUMN_VALUE(L_PTCSCN_CURSOR,      6,  L_VALUE      );
                                                                   
      L_FETCHED_ROWS := L_FETCHED_ROWS + 1;

      A_PT            (L_FETCHED_ROWS) := L_PT        ;
      A_VERSION       (L_FETCHED_ROWS) := L_VERSION   ;
      A_PTROW         (L_FETCHED_ROWS) := L_PTROW     ;
      A_CS            (L_FETCHED_ROWS) := L_CS        ;
      A_CN            (L_FETCHED_ROWS) := L_CN        ;
      A_VALUE         (L_FETCHED_ROWS) := L_VALUE     ;
                                                
      IF L_FETCHED_ROWS < A_NR_OF_ROWS THEN
         L_RESULT := DBMS_SQL.FETCH_ROWS(L_PTCSCN_CURSOR);
      END IF;
   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(L_PTCSCN_CURSOR);

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
              'GetPtCsCondition', L_SQLERRM);
      UNAPIGEN.U4COMMIT;
      IF DBMS_SQL.IS_OPEN (L_PTCSCN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR (L_PTCSCN_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END GETPTCSCONDITION;

FUNCTION SAVEPTCSCONDITION
(A_PT             IN    VARCHAR2,                    
 A_VERSION        IN    VARCHAR2,                    
 A_PTROW          IN    UNAPIGEN.NUM_TABLE_TYPE,     
 A_CS             IN    UNAPIGEN.VC20_TABLE_TYPE,    
 A_CN             IN    UNAPIGEN.VC20_TABLE_TYPE,    
 A_VALUE          IN    UNAPIGEN.VC40_TABLE_TYPE,    
 A_NR_OF_ROWS     IN    NUMBER,                      
 A_MODIFY_REASON  IN    VARCHAR2)                    
RETURN NUMBER IS

L_LC           VARCHAR2(2);
L_LC_VERSION   VARCHAR2(20);
L_SS           VARCHAR2(2);
L_LOG_HS       CHAR(1);
L_ALLOW_MODIFY CHAR(1);
L_ACTIVE       CHAR(1);
L_SEQ_NO       NUMBER;

BEGIN

   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   IF NVL(A_PT, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;

   IF NVL(A_VERSION, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJVERSION;
      RAISE STPERROR;
   END IF;

   L_RET_CODE := UNAPIGEN.GETAUTHORISATION('pt', A_PT, A_VERSION, L_LC, L_LC_VERSION, L_SS,
                                           L_ALLOW_MODIFY, L_ACTIVE, L_LOG_HS);

   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
      RAISE STPERROR;
   END IF;

   UPDATE UTPT
   SET ALLOW_MODIFY = '#'
   WHERE PT = A_PT
   AND VERSION = A_VERSION;

   IF SQL%ROWCOUNT < 1 THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR ;
   END IF;

   DELETE UTPTCSCN
   WHERE PT = A_PT
   AND VERSION = A_VERSION;

   FOR L_SEQ_NO IN 1..A_NR_OF_ROWS LOOP
      IF A_PTROW(L_SEQ_NO) IS NULL OR
         NVL(A_CS(L_SEQ_NO), ' ') = ' ' OR
         NVL(A_CN(L_SEQ_NO), ' ') = ' ' THEN
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
         RAISE STPERROR;
      END IF;
      
      INSERT INTO UTPTCSCN (PT, VERSION, PTROW, CS, CN, CNSEQ, VALUE)
      VALUES (A_PT, A_VERSION, A_PTROW(L_SEQ_NO), A_CS(L_SEQ_NO), A_CN(L_SEQ_NO),
              L_SEQ_NO, A_VALUE(L_SEQ_NO));
   END LOOP;

   L_EVENT_TP := 'UsedObjectsUpdated';
   L_EV_SEQ_NR := -1;
   L_RESULT := UNAPIEV.INSERTEVENT('SavePtCsCondition', UNAPIGEN.P_EVMGR_NAME, 'pt', A_PT, L_LC, 
                                   L_LC_VERSION, L_SS, L_EVENT_TP, 'version='||A_VERSION, L_EV_SEQ_NR);
   IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS  THEN
      UNAPIGEN.P_TXN_ERROR := L_RESULT;
      RAISE STPERROR;
   END IF;

   IF L_LOG_HS = '1' THEN
      INSERT INTO UTPTHS (PT, VERSION, WHO, WHO_DESCRIPTION, WHAT, 
                          WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
      VALUES (A_PT, A_VERSION, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
              'protocol "'||A_PT||'" cell condition values are updated.', 
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         UNAPIGEN.LOGERROR('SavePtCsCondition', SQLERRM);
      END IF;
      RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'SavePtCsCondition'));
END SAVEPTCSCONDITION;

END UNAPIPT;