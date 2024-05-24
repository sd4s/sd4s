PACKAGE BODY unapira2 AS

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(4000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_RET_CODE        NUMBER;
STPERROR          EXCEPTION;
L_DYN_CURSOR      INTEGER;
L_RESULT          INTEGER;
L_GETTEXT         VARCHAR2(11000);


L_TABSTRUCT_NR_OF_ROWS    INTEGER;
L_TABSTRUCT_TABLE_NAME    UNAPIGEN.VC40_TABLE_TYPE;
L_TABSTRUCT_COLUMNS       UNAPIGEN.VC2000_TABLE_TYPE;

P_COL_TAB                 UNAPIGEN.VC2000_TABLE_TYPE;
P_COLID_TAB               UNAPIGEN.VC40_TABLE_TYPE;

P_CACHE_STRING1   UNAPIGEN.VC2000_TABLE_TYPE;
P_CACHE_STRING2   UNAPIGEN.VC2000_TABLE_TYPE;
P_CACHE_CHECK     UNAPIGEN.VC2000_TABLE_TYPE;
P_CACHE_ID        UNAPIGEN.VC40_TABLE_TYPE;
P_CACHE_COUNT     INTEGER;


L_OBJECT_TP       VARCHAR2(40);
L_OBJECT_ID       VARCHAR2(20);
L_VERSION         VARCHAR2(20);
L_PP_KEY1         VARCHAR2(20) DEFAULT ' ';
L_PP_KEY2         VARCHAR2(20) DEFAULT ' ';
L_PP_KEY3         VARCHAR2(20) DEFAULT ' ';
L_PP_KEY4         VARCHAR2(20) DEFAULT ' ';
L_PP_KEY5         VARCHAR2(20) DEFAULT ' ';
L_LAB             VARCHAR2(20) DEFAULT '-';

FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;











PROCEDURE U4DATAGETLINE      
IS
   L_SEP_POS     INTEGER;
   L_FIRST_TIME  BOOLEAN;
   L_READ_TEXT   VARCHAR2(2000);
   L_LEAVE_LOOP  BOOLEAN;
BEGIN
   
   
   
   L_FIRST_TIME := TRUE;

   LOOP
      L_LEAVE_LOOP := TRUE;
      L_READ_TEXT := NULL;

      UNAPIRA.L_EXCEPTION_STEP := 'Reading data from file';
      BEGIN
         UTL_FILE.GET_LINE(UNAPIRA.P_ARCH_FILE_HANDLE, L_READ_TEXT);
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         L_SQLERRM := 'Unexpected End Of File reached in '||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME;
         RAISE;
      END;

      UNAPIRA.L_EXCEPTION_STEP := 'U4DataGetLine: Joining splitted data returned from file';
      IF L_READ_TEXT IS NOT NULL THEN
         
         L_SEP_POS := INSTR(L_READ_TEXT,UNAPIRA.P_SEP, 1, 1);
         IF SUBSTR(L_READ_TEXT, L_SEP_POS-1, 1) = '*' THEN
            L_LEAVE_LOOP := FALSE;
            IF L_FIRST_TIME THEN
               L_GETTEXT := SUBSTR(L_READ_TEXT,1,L_SEP_POS-2)||SUBSTR(L_READ_TEXT,L_SEP_POS);
            ELSE
               
               L_GETTEXT := L_GETTEXT || SUBSTR(L_READ_TEXT,L_SEP_POS+1);
            END IF;
         ELSE
            IF L_FIRST_TIME THEN
               L_GETTEXT := L_READ_TEXT;
            ELSE
               
               L_GETTEXT := L_GETTEXT || SUBSTR(L_READ_TEXT, L_SEP_POS+1);
            END IF;
         END IF;
      ELSE
         L_GETTEXT := L_READ_TEXT;
      END IF;

      L_FIRST_TIME := FALSE;

      EXIT WHEN L_LEAVE_LOOP;
   END LOOP;

   
   
   
   
   

   UNAPIRA.L_EXCEPTION_STEP := SUBSTR('U4DataGetLine: Replace special characters in:' || L_GETTEXT, 1,2000);

   L_GETTEXT := REPLACE(REPLACE(REPLACE(L_GETTEXT,'''''',''''),
                                '<CR>', 
                                CHR(13)
                               ),
                        '<LF>', 
                        CHR(10)
                       );

   UNAPIRA.L_EXCEPTION_STEP := SUBSTR('U4DataGetLine: After replace special characters in:' || L_GETTEXT,1,2000);
EXCEPTION
WHEN UTL_FILE.INVALID_PATH THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataGetLine', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   RAISE;
WHEN UTL_FILE.INVALID_MODE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataGetLine', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   RAISE;
WHEN UTL_FILE.INVALID_FILEHANDLE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataGetLine', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   RAISE;
WHEN UTL_FILE.INVALID_OPERATION THEN
   
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataGetLine', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   RAISE;
WHEN UTL_FILE.READ_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataGetLine', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   RAISE;
WHEN UTL_FILE.WRITE_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataGetLine', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   RAISE;
WHEN UTL_FILE.INTERNAL_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataGetLine', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   RAISE;
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,200);
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataGetLine', L_SQLERRM, 'OTHERS',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataGetLine', L_SQLERRM, 'OTHERS',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   END IF;
   RAISE;
END U4DATAGETLINE;


PROCEDURE HANDLEINSERT            
(A_TABLE_NAME IN VARCHAR2)        
IS
   L_COLUMN_STRING1            VARCHAR2(2000);
   L_COLUMN_STRING2            VARCHAR2(2000);
   L_CHECK_STRING              VARCHAR2(2000);

   L_SC_FOUND                  BOOLEAN;
   L_SC                        VARCHAR2(20);
   L_SHORTCUT                  RAW(8);
   L_KEY_TP                    CHAR(2);
   L_REF_FOUND                 BOOLEAN;

   L_ROW                       INTEGER;
   L_NULL_CHAR1                CHAR(1);
   L_NULL_VC2                  VARCHAR2(2);
   L_NULL_VC20                 VARCHAR2(20);
   L_NULL_VC40                 VARCHAR2(40);
   L_NULL_VC255                VARCHAR2(255);
   L_NULL_VC511                VARCHAR2(511);
   L_NULL_DATE                 TIMESTAMP WITH TIME ZONE;
   L_DD_ARCHFILE               INTEGER;
   
   L_IGNORE                    BOOLEAN;
   
   L_POS        NUMBER;           
   L_STRING_UNTIL_TZ   VARCHAR2 (2000);  
   L_NAME_VAR_TSLTZ    VARCHAR2 (30);    
  
   
   TABLE_DOES_NOT_EXIST EXCEPTION;

   PRAGMA EXCEPTION_INIT(TABLE_DOES_NOT_EXIST, -942);
BEGIN
   UNAPIRA.L_EXCEPTION_STEP := 'Opening cursor';
   IF NOT DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
      L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   END IF;

   UNAPIRA.L_EXCEPTION_STEP := '(HandleInsert) Build-up SQL statement table='||A_TABLE_NAME||
                               '#object_tp='||L_OBJECT_TP||'#object_id='||L_OBJECT_ID||
                               '#version='||NVL(L_VERSION,'VERSION EMPTY');
   IF L_OBJECT_TP = 'pp' THEN
      UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#pp_key1='||L_PP_KEY1||'#pp_key2='||L_PP_KEY2||
                                  '#pp_key3='||L_PP_KEY3||'#pp_key4='||L_PP_KEY4||'#pp_key5='||L_PP_KEY5;
   ELSIF L_OBJECT_TP = 'eq' THEN
      UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#lab='||L_LAB;
   END IF;

   
   IF A_TABLE_NAME = 'utpdaxslt' THEN
      L_SQL_STRING := 'INSERT INTO utxslt';
   ELSE
      L_SQL_STRING := 'INSERT INTO '||A_TABLE_NAME;   
   END IF;

   
   L_REF_FOUND := FALSE ;

   IF P_CACHE_COUNT IS NULL THEN
      P_CACHE_COUNT := 0;
   END IF;

   FOR L_ROW IN 1 .. P_CACHE_COUNT LOOP
      IF (P_CACHE_ID(L_ROW) = A_TABLE_NAME) OR
         (P_CACHE_ID(L_ROW) = 'utxslt' AND A_TABLE_NAME='utpdaxslt')THEN
         L_COLUMN_STRING1  := P_CACHE_STRING1(L_ROW);
         L_COLUMN_STRING2  := P_CACHE_STRING2(L_ROW);
         L_CHECK_STRING    := P_CACHE_CHECK  (L_ROW);
         L_REF_FOUND       := TRUE ;
         EXIT;
      END IF;
   END LOOP;

   IF (NOT L_REF_FOUND) THEN
      

      L_COLUMN_STRING1 := ' ';
      L_COLUMN_STRING2 := ' ';
      L_CHECK_STRING := ' ';

      
      FOR L_COLUMNS_REC IN UNAPIRA.L_USER_TAB_COLUMNS_CURSOR(A_TABLE_NAME) LOOP
         
         
         
         L_IGNORE := FALSE;
         IF L_COLUMNS_REC.COLUMN_NAME = 'version_is_current' THEN
            FOR I IN 1..UNAPIGEN.L_NR_OF_TYPES LOOP
               IF UNAPIGEN.L_OBJECT_TYPES(I) = LOWER(SUBSTR(A_TABLE_NAME,3,2)) THEN
                  L_IGNORE := TRUE;
               END IF;
            END LOOP;
         END IF;

         IF NOT L_IGNORE THEN
            L_COLUMN_STRING1 := L_COLUMN_STRING1 || L_COLUMNS_REC.COLUMN_NAME || ',';
            L_CHECK_STRING := L_CHECK_STRING || ':' || L_COLUMNS_REC.COLUMN_NAME || ',';
            IF L_COLUMNS_REC.DATA_TYPE IN ('VARCHAR2','CHAR') THEN
               L_COLUMN_STRING2 := L_COLUMN_STRING2 || ':' || L_COLUMNS_REC.COLUMN_NAME || ',';
            ELSIF L_COLUMNS_REC.DATA_TYPE IN ('FLOAT','NUMBER') THEN
               L_COLUMN_STRING2 := L_COLUMN_STRING2 || 'TO_NUMBER(:' || L_COLUMNS_REC.COLUMN_NAME || '),';
            ELSIF SUBSTR(L_COLUMNS_REC.DATA_TYPE,1,9) = 'TIMESTAMP' THEN
               L_COLUMN_STRING2 := L_COLUMN_STRING2 || 'TO_TIMESTAMP_TZ(TRIM(:' || L_COLUMNS_REC.COLUMN_NAME || '),'''||UNAPIRA.P_TSTZ_FORMAT||'''),';
            ELSE
               
               L_COLUMN_STRING2 := L_COLUMN_STRING2 || ':' || L_COLUMNS_REC.COLUMN_NAME || ',';
            END IF;
         END IF;
      END LOOP;

      
      P_CACHE_COUNT := P_CACHE_COUNT + 1 ;
      P_CACHE_ID        (P_CACHE_COUNT)   := A_TABLE_NAME;
      P_CACHE_STRING1   (P_CACHE_COUNT)   := L_COLUMN_STRING1;
      P_CACHE_STRING2   (P_CACHE_COUNT)   := L_COLUMN_STRING2;
      P_CACHE_CHECK     (P_CACHE_COUNT)   := L_CHECK_STRING;
   END IF;
   
   IF L_COLUMN_STRING1 = ' ' THEN
      
      
      RAISE TABLE_DOES_NOT_EXIST;
   END IF;

   
   L_COLUMN_STRING1 := SUBSTR(L_COLUMN_STRING1, 1, LENGTH(L_COLUMN_STRING1)-1);
   L_COLUMN_STRING2 := SUBSTR(L_COLUMN_STRING2, 1, LENGTH(L_COLUMN_STRING2)-1);

   L_SQL_STRING := L_SQL_STRING || '(' || L_COLUMN_STRING1 || ') VALUES ('||L_COLUMN_STRING2 ||')';

   BEGIN
      UNAPIRA.L_EXCEPTION_STEP := '(HandleInsert) Parsing SQL statement table='||A_TABLE_NAME||
                                  '#object_tp='||L_OBJECT_TP||'#object_id='||L_OBJECT_ID||
                                  '#version='||NVL(L_VERSION,'VERSION EMPTY');
      IF L_OBJECT_TP = 'pp' THEN
         UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#pp_key1='||L_PP_KEY1||'#pp_key2='||L_PP_KEY2||
                                     '#pp_key3='||L_PP_KEY3||'#pp_key4='||L_PP_KEY4||'#pp_key5='||L_PP_KEY5;
      ELSIF L_OBJECT_TP = 'eq' THEN
         UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#lab='||L_LAB;
      END IF;

      DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 

      UNAPIRA.L_EXCEPTION_STEP := '(HandleInsert) Binding variables used in SQL statement table='||A_TABLE_NAME||
                                  '#object_tp='||L_OBJECT_TP||'#object_id='||L_OBJECT_ID||
                                  '#version='||NVL(L_VERSION,'VERSION EMPTY');
      IF L_OBJECT_TP = 'pp' THEN
         UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#pp_key1='||L_PP_KEY1||'#pp_key2='||L_PP_KEY2||
                                     '#pp_key3='||L_PP_KEY3||'#pp_key4='||L_PP_KEY4||'#pp_key5='||L_PP_KEY5;
      ELSIF L_OBJECT_TP = 'eq' THEN
         UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#lab='||L_LAB;
      END IF;

      
      FOR L_ROW IN 1..UNAPIRA.P_MAXCOLUMNSBYTABLE LOOP
         IF P_COLID_TAB(L_ROW) IS NOT NULL THEN
            IF INSTR(L_CHECK_STRING, ':'||P_COLID_TAB(L_ROW)||',') <> 0 THEN
               DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':'||P_COLID_TAB(L_ROW), P_COL_TAB(L_ROW));
               L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':'||P_COLID_TAB(L_ROW)||',' ,'');
            END IF;
         END IF;
      END LOOP;

      
      L_CHECK_STRING := REPLACE(L_CHECK_STRING, ' ', '');

      

      
      
      
      
      
      
      
      
      IF A_TABLE_NAME = 'utscmecell' THEN
         IF INSTR(L_CHECK_STRING, ':reanalysis')<>0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':reanalysis', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':reanalysis,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utscmecelllist' THEN
         IF INSTR(L_CHECK_STRING, ':reanalysis')<>0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':reanalysis', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':reanalysis,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utscmecellinput' THEN
         IF INSTR(L_CHECK_STRING, ':reanalysis')<>0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':reanalysis', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':reanalysis,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':input_reanalysis')<>0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':input_reanalysis', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':input_reanalysis,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utscmecelloutput' THEN
         IF INSTR(L_CHECK_STRING, ':reanalysis')<>0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':reanalysis', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':reanalysis,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':save_reanalysis')<>0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_reanalysis', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_reanalysis,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utscmecelllistoutput' THEN
         IF INSTR(L_CHECK_STRING, ':reanalysis')<>0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':reanalysis', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':reanalysis,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':save_reanalysis')<>0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_reanalysis', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_reanalysis,', '');
         END IF;
      
      ELSIF A_TABLE_NAME = 'utie' THEN
         IF INSTR(L_CHECK_STRING, ':align')<>0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':align', 'L');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':align,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':multi_select')<>0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':multi_select', '0');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':multi_select,', '');
         END IF;
      END IF;
      
      
      
      
      
      
      L_NULL_CHAR1 := NULL;
      L_NULL_VC2 := NULL;
      L_NULL_VC20 := NULL;
      L_NULL_VC40 := NULL;
      L_NULL_VC255 := NULL;
      L_NULL_DATE := NULL;
      IF A_TABLE_NAME = 'utlongtext' THEN
         IF INSTR(L_CHECK_STRING, ':obj_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':obj_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':obj_version,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utrq' THEN
         IF INSTR(L_CHECK_STRING, ':descr_doc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':descr_doc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':descr_doc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':lc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':rt_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':rt_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':rt_version,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrqau','utrqicau','utscau','utscicau','utscmeau','utscpaau',
                             'utscpgau','utwsau') THEN
         IF INSTR(L_CHECK_STRING, ':au_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':au_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':au_version,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrqgk','utscgk','utscmegk','utwsgk') THEN
         IF INSTR(L_CHECK_STRING, ':gk_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':gk_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':gk_version,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrqhs','utrqichs','utschs','utscichs','utscmehs','utscpahs',
                             'utscpghs','utwshs') THEN
         IF INSTR(L_CHECK_STRING, ':ev_seq') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':ev_seq', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':ev_seq,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':tr_seq') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':tr_seq', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':tr_seq,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':what_description') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':what_description', '-');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':what_description,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':who_description') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':who_description', '-');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':who_description,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrqic','utscic') THEN
         IF INSTR(L_CHECK_STRING, ':ip_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':ip_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':ip_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':lc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrqii','utscii') THEN
         IF INSTR(L_CHECK_STRING, ':ie_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':ie_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':ie_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':lc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrqpp','utrqppau') THEN
         IF INSTR(L_CHECK_STRING, ':au_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':au_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':au_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_version,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrscme','utscme') THEN
         IF INSTR(L_CHECK_STRING, ':eq_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':eq_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':eq_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':lc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':me_result_editable') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':me_result_editable', 2);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':me_result_editable,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':mt_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':mt_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':mt_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':planned_eq_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':planned_eq_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':planned_eq_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':sop_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':sop_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':sop_version,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrscmecell','utscmecell') THEN
         IF INSTR(L_CHECK_STRING, ':eq_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':eq_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':eq_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':unit') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':unit', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':unit,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrscmecellinput','utscmecellinput') THEN
         IF INSTR(L_CHECK_STRING, ':input_mt_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':input_mt_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':input_mt_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':input_pp_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':input_pp_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':input_pp_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':input_pr_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':input_pr_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':input_pr_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':input_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':input_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':input_version,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrscmecelllistoutput','utrscmecelloutput',
                             'utscmecelllistoutput' ,'utscmecelloutput' ) THEN
         IF INSTR(L_CHECK_STRING, ':save_eq_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_eq_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_eq_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':save_mt_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_mt_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_mt_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':save_pp_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_pp_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_pp_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':save_pr_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_pr_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_pr_version,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrscpa','utscpa') THEN
         IF INSTR(L_CHECK_STRING, ':lc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pr_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pr_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pr_version,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utrscpg','utscpg') THEN
         IF INSTR(L_CHECK_STRING, ':format') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':format', L_NULL_VC40);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':format,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':last_comment') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':last_comment', L_NULL_VC255);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':last_comment,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':lc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':never_create_methods') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':never_create_methods', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':never_create_methods,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_version,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utsc' THEN
         IF INSTR(L_CHECK_STRING, ':descr_doc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':descr_doc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':descr_doc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':lc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':st_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':st_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':st_version,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utscpatd' THEN
         IF INSTR(L_CHECK_STRING, ':st_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':st_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':st_version,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utws' THEN
         IF INSTR(L_CHECK_STRING, ':descr_doc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':descr_doc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':descr_doc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':lc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':wt_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':wt_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':wt_version,', '');
         END IF;
      
      ELSIF A_TABLE_NAME IN ('utad','utau','uteq','utie','utip','utlc','utmt','utpp','utpr',
                             'utrt','utst','utuc','utup','utwt') THEN
         IF INSTR(L_CHECK_STRING, ':auto_create_cells') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':auto_create_cells', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':auto_create_cells,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':descr_doc_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':descr_doc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':descr_doc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':effective_from') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':effective_from', TO_CHAR(CURRENT_TIMESTAMP,UNAPIRA.P_TSTZ_FORMAT));
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':effective_from,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':effective_till') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':effective_till', L_NULL_DATE);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':effective_till,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':eq_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':eq_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':eq_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':inherit_from_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':inherit_from_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':inherit_from_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':lc_lc_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc_lc_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc_lc_version,', '');
         ELSIF INSTR(L_CHECK_STRING, ':lc_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':me_result_editable') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':me_result_editable', '2');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':me_result_editable,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':never_create_methods') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':never_create_methods', '0');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':never_create_methods,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':operation_doc_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':operation_doc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':operation_doc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':rq_lc_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':rq_lc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':rq_lc_version,', '');
         ELSIF INSTR(L_CHECK_STRING, ':sc_lc_version') <> 0 THEN   
                                                                   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':sc_lc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':sc_lc_version,', '');
         ELSIF INSTR(L_CHECK_STRING, ':ws_lc_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':ws_lc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':ws_lc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':rq_uc_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':rq_uc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':rq_uc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':sc_uc_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':sc_uc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':sc_uc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':ws_uc_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':ws_uc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':ws_uc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':sop_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':sop_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':sop_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':unit') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':unit', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':unit,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':usage_doc_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':usage_doc_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':usage_doc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':version_is_current') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':version_is_current', '1');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':version_is_current,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utadau','utaulist','utausql','uteqau','uteqcalog',
                             'uteqcd','uteqct','uteqctold','uteqmr','utgkmelist','utgkmesql',
                             'utgkrqlist','utgkrqsql','utgkrtlist','utgkrtsql','utgksclist',
                             'utgkscsql','utgkstlist','utgkstsql','utgkwslist','utgkwssql',
                             'utieau','utielist','utiespin','utiesql','utipau','utipie',
                             'utipieau','utlcaf','utlcau','utlctr','utlcus','utmtau',
                             'utmtcelleq','utmtcelllist','utmtcellspin','utmtel','utmtmr',
                             'utppau','utppprau','utppspa','utppspb','utppspc','utprau',
                             'utprmtau','utrtau','utrtgk','utrtip','utrtipau','utrtpp',
                             'utrtppau','utrtst','utrtstau','utstau','utstgk','utstip','utstipau',
                             'utstmtfreq','utstpp','utstppau','utstprfreq','uttkpref','utucau',
                             'utucaudittrail','utupau','utupfa','utuppref','utuptk',
                             'utuptkdetails','utupus','utupusel','utupusfa','utupuspref',
                             'utupustk','utupustkdetails','utwtau','utwtrows') THEN
         IF INSTR(L_CHECK_STRING, ':au_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':au_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':au_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':eq_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':eq_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':eq_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':gk_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':gk_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':gk_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':ie_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':ie_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':ie_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':inherit_from') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':inherit_from', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':inherit_from,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':inherit_from_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':inherit_from_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':inherit_from_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':ip_version') <> 0 THEN   
                                                             
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':ip_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':ip_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':mt_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':mt_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':mt_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_version') <> 0 THEN   
                                                             
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pr_version') <> 0 THEN   
                                                             
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pr_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pr_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':st_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':st_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':st_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':us_version') <> 0 THEN   
                                                             
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':us_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':us_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':version,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utadhs','utauhs','uteqhs','utiehs','utiphs','utlchs','utmths',
                             'utpphs','utprhs','utrths','utsths','utuchs','utuphs','utwths') THEN
         IF INSTR(L_CHECK_STRING, ':ev_seq') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':ev_seq', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':ev_seq,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':tr_seq') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':tr_seq', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':tr_seq,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':what_description') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':what_description', '-');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':what_description,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':who_description') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':who_description', '-');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':who_description,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'uteqca' THEN
         IF INSTR(L_CHECK_STRING, ':mt_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':mt_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':mt_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':sop_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':sop_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':sop_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':st_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':st_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':st_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':version,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utgkme','utgkrq','utgkrt','utgksc','utgkst','utgkws','uttk') THEN
         IF INSTR(L_CHECK_STRING, ':active') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':active', '1');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':active,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':allow_modify') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':allow_modify', '0');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':allow_modify,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':effective_from') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':effective_from', TO_CHAR(CURRENT_TIMESTAMP,UNAPIRA.P_TSTZ_FORMAT));
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':effective_from,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':effective_till') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':effective_till', L_NULL_DATE);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':effective_till,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':gk_class') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':gk_class', L_NULL_VC2);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':gk_class,', '');
         ELSIF INSTR(L_CHECK_STRING, ':tk_class') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':tk_class', L_NULL_VC2);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':tk_class,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':last_comment') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':last_comment', L_NULL_VC255);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':last_comment,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':lc') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc', '@L');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':lc_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lc_version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lc_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':ss') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':ss', '@A');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':ss,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':value_list_tp') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':value_list_tp', 'E');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':value_list_tp,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':version_is_current') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':version_is_current', '1');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':version_is_current,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utmtcell' THEN
         IF INSTR(L_CHECK_STRING, ':input_mt_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':input_mt_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':input_mt_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':input_pp_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':input_pp_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':input_pp_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':input_pr_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':input_pr_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':input_pr_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':input_source_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':input_source_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':input_source_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':save_eq_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_eq_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_eq_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':save_id_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_id_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_id_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':save_mt_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_mt_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_mt_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':save_pp_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_pp_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_pp_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':save_pr_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_pr_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_pr_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':unit') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':unit', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':unit,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':version,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utobjects' THEN
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', 0);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utpppr','utprmt') THEN
         IF INSTR(L_CHECK_STRING, ':format') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':format', L_NULL_VC40);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':format,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':mt_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':mt_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':mt_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pr_version') <> 0 THEN   
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pr_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pr_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':unit') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':unit', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':unit,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':version,', '');
         END IF;
      ELSIF (A_TABLE_NAME LIKE 'utrtgk%') OR (A_TABLE_NAME LIKE 'utstgk%') THEN   
         
         IF INSTR(L_CHECK_STRING, ':version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':version', UNVERSION.P_NO_VERSION);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':version,', '');
         END IF;
      END IF;
      
      
      
      
      
      IF INSTR(L_CHECK_STRING, ':ar') <> 0 THEN
         FOR I IN 16..UNAPIGEN.P_DATADOMAINS LOOP
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':ar'||I, L_NULL_CHAR1);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':ar'||I||',', '');
         END LOOP;
      END IF;

      
      
      
      
      
      
      
      
      
      
      
      
      
      IF A_TABLE_NAME = 'utsc' THEN
         IF INSTR(L_CHECK_STRING, ':sd') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':sd', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':sd,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utscme', 'utrscme', 'utmelssavescmeresult', 'utmelssavescmethod') THEN
         IF INSTR(L_CHECK_STRING, ':lab') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lab', '-');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lab,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utscpg', 'utrscpg', 'utrqpp', 'utrqppau') THEN
         IF INSTR(L_CHECK_STRING, ':pp_key1') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key1', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key1,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key2') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key2', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key2,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key3') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key3', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key3,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key4') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key4', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key4,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key5') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key5', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key5,', '');
         END IF;
      
      ELSIF A_TABLE_NAME IN ('uteq','uteqau','uteqca','uteqcalog','uteqcd','uteqct','uteqctold','uteqcyct',
                             'uteqhs','uteqhsdetails','uteqmr','uteqtype','utlab') THEN
         IF INSTR(L_CHECK_STRING, ':lab') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':lab', '-');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':lab,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utassignfulltestplan','utcomparecustomer','utpp','utppau','utpphs','utpphsdetails',
                             'utpppr','utppprau','utppspa','utppspb','utppspc','utptcellpp','utrtpp',
                             'utrtppau','utstpp','utstppau','utstprfreq') THEN
         IF INSTR(L_CHECK_STRING, ':pp_key1') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key1', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key1,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key2') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key2', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key2,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key3') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key3', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key3,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key4') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key4', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key4,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key5') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key5', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key5,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utmtcelleqtype','utmt','uteqtype') THEN
         IF INSTR(L_CHECK_STRING, ':eq_tp') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':eq_tp', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':eq_tp,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utmtcell' THEN
         IF INSTR(L_CHECK_STRING, ':save_eq_tp') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':save_eq_tp', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':save_eq_tp,', '');
         END IF;
      END IF;

      
      
      
      
      
      L_NULL_VC511 := NULL;
      
      IF A_TABLE_NAME = 'utedtbl' THEN
         IF INSTR(L_CHECK_STRING, ':log_hs') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs', '1');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':log_hs_details') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':log_hs_details', '1');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':log_hs_details,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':where_clause') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':where_clause', L_NULL_VC511);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':where_clause,', '');
         END IF;
      ELSIF A_TABLE_NAME = 'utupusoutlooktasks' THEN
         IF INSTR(L_CHECK_STRING, ':icon_name') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':icon_name', L_NULL_VC255);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':icon_name,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':icon_nbr') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':icon_nbr', -1);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':icon_nbr,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':cmd_line') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':cmd_line', L_NULL_VC255);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':cmd_line,', '');
         END IF;
      END IF;

      
      
      
      
      
      
      IF A_TABLE_NAME IN ('utpdaxslt', 'utxslt') THEN
         
         
         IF INSTR(L_CHECK_STRING, ':usage_type') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':usage_type', 'imported f. archive');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':usage_type,', '');
         END IF;
      ELSIF A_TABLE_NAME IN ('utjournaldetails', 'utcataloguedetails') THEN
         IF INSTR(L_CHECK_STRING, ':object_version') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':object_version', L_NULL_VC20);
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':object_version,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key1') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key1', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key1,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key2') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key2', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key2,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key3') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key3', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key3,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key4') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key4', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key4,', '');
         END IF;
         IF INSTR(L_CHECK_STRING, ':pp_key5') <> 0 THEN
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':pp_key5', ' ');
            L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':pp_key5,', '');
         END IF;
      END IF;

      
      
      
      
                                                  
      LOOP
         L_POS := INSTR (L_CHECK_STRING, '_tz');
         EXIT WHEN (L_POS IS NULL OR L_POS = 0);

         L_STRING_UNTIL_TZ := SUBSTR(L_CHECK_STRING,1,L_POS-1);  
                  
         L_POS := INSTR (L_STRING_UNTIL_TZ, ':', -1);
         IF L_POS <> 0 THEN
            L_NAME_VAR_TSLTZ:= SUBSTR(L_STRING_UNTIL_TZ,L_POS+1);
                  
            FOR L_ROW IN 1..UNAPIRA.P_MAXCOLUMNSBYTABLE LOOP
               IF P_COLID_TAB(L_ROW) IS NOT NULL THEN
                  IF P_COLID_TAB(L_ROW) = L_NAME_VAR_TSLTZ THEN
                     DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':'||L_NAME_VAR_TSLTZ||'_tz', P_COL_TAB(L_ROW));
                     L_CHECK_STRING := REPLACE (L_CHECK_STRING, ':' || L_NAME_VAR_TSLTZ || '_tz,', '');
                     EXIT;
                  END IF;
               END IF;
            END LOOP;

            
            IF INSTR(L_CHECK_STRING, L_NAME_VAR_TSLTZ ||'_tz') <> 0 THEN
               DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, L_NAME_VAR_TSLTZ ||'_tz', ' ');
               L_CHECK_STRING := REPLACE(L_CHECK_STRING, ':' || L_NAME_VAR_TSLTZ ||'_tz,', '');
            END IF;
         END IF;
      END LOOP;      
      
      
      IF L_CHECK_STRING IS NOT NULL THEN                        
         
         L_SQLERRM := 'Not all columns found in data ! <'||SUBSTR(L_CHECK_STRING,1,120) || '>';
         RAISE STPERROR;
      END IF;
      UNAPIRA.L_EXCEPTION_STEP := '(HandleInsert) Executing in SQL statement table='||A_TABLE_NAME||
                                  '#object_tp='||L_OBJECT_TP||'#object_id='||L_OBJECT_ID||
                                  '#version='||NVL(L_VERSION,'VERSION EMPTY');
      IF L_OBJECT_TP = 'pp' THEN
         UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#pp_key1='||L_PP_KEY1||'#pp_key2='||L_PP_KEY2||
                                     '#pp_key3='||L_PP_KEY3||'#pp_key4='||L_PP_KEY4||'#pp_key5='||L_PP_KEY5;
      ELSIF L_OBJECT_TP = 'eq' THEN
         UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#lab='||L_LAB;
      END IF;

      
      IF A_TABLE_NAME = 'utshortcut' THEN
         
         BEGIN
            L_RET_CODE := DBMS_SQL.EXECUTE(L_DYN_CURSOR);
         EXCEPTION 
            WHEN DUP_VAL_ON_INDEX THEN
               FOR L_ROW IN 1..UNAPIRA.P_MAXCOLUMNSBYTABLE LOOP
                  IF P_COLID_TAB(L_ROW) = 'shortcut' THEN
                     L_SHORTCUT := P_COL_TAB(L_ROW);
                  END IF;
                  IF P_COLID_TAB(L_ROW) = 'key_tp' THEN
                     L_KEY_TP := P_COL_TAB(L_ROW);
                  END IF;
               END LOOP;

               IF L_KEY_TP = 'ss' THEN
                  UPDATE UTSS
                     SET SHORTCUT = NULL
                   WHERE SHORTCUT = L_SHORTCUT;
               ELSIF L_KEY_TP = 'au' THEN
                  UPDATE UTAU
                     SET SHORTCUT = NULL
                   WHERE SHORTCUT = L_SHORTCUT;
               ELSIF L_KEY_TP = 'bc' THEN
                  DELETE FROM UTSYSTEM
                   WHERE SETTING_NAME = 'PREAMBLE';
               ELSIF L_KEY_TP = 'lu' THEN
                  UPDATE UTLU
                     SET SHORTCUT = NULL
                   WHERE SHORTCUT = L_SHORTCUT;
               END IF;
         END;
      ELSIF A_TABLE_NAME = 'utss' THEN
         FOR L_ROW IN 1..UNAPIRA.P_MAXCOLUMNSBYTABLE LOOP
            IF P_COLID_TAB(L_ROW) = 'ss' THEN
               L_OBJECT_ID := P_COL_TAB(L_ROW) ;
            END IF;
         END LOOP;

         
         DELETE FROM UTSS
          WHERE SS = L_OBJECT_ID;

         
         L_RET_CODE := DBMS_SQL.EXECUTE(L_DYN_CURSOR);

         DELETE FROM UTSHORTCUT
          WHERE KEY_TP = 'ss'
            AND VALUE_S = L_OBJECT_ID;
      ELSIF A_TABLE_NAME = 'utlu' THEN
         
         FOR L_ROW IN 1..UNAPIRA.P_MAXCOLUMNSBYTABLE LOOP
            IF P_COLID_TAB(L_ROW) = 'lu' THEN
               L_OBJECT_ID := P_COL_TAB(L_ROW);
            END IF;
         END LOOP;

         DELETE FROM UTLU
          WHERE STRING_VAL = L_OBJECT_ID;

          
         L_RET_CODE := DBMS_SQL.EXECUTE(L_DYN_CURSOR);

         DELETE FROM UTSHORTCUT
          WHERE KEY_TP = 'lu'
            AND VALUE_S = L_OBJECT_ID;
      ELSIF A_TABLE_NAME = 'utau' THEN
         FOR L_ROW IN 1..UNAPIRA.P_MAXCOLUMNSBYTABLE LOOP
            IF P_COLID_TAB(L_ROW) = 'au' THEN
               L_OBJECT_ID := P_COL_TAB(L_ROW);
            END IF;
         END LOOP;

         DELETE FROM UTAU
          WHERE AU = L_OBJECT_ID
            AND VERSION = L_VERSION;

          
         L_RET_CODE := DBMS_SQL.EXECUTE(L_DYN_CURSOR);

         DELETE FROM UTSHORTCUT
          WHERE KEY_TP = 'au'
            AND VALUE_S = L_OBJECT_ID;
      ELSIF A_TABLE_NAME = 'utsystem' THEN
         DELETE FROM UTSYSTEM
          WHERE SETTING_NAME = 'PREAMBLE';

          
         L_RET_CODE := DBMS_SQL.EXECUTE(L_DYN_CURSOR);

         DELETE FROM UTSHORTCUT
          WHERE KEY_TP = 'bc';
      ELSE
         L_RET_CODE := DBMS_SQL.EXECUTE(L_DYN_CURSOR);
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE <> -942 THEN
            IF SQLCODE <> 1 THEN
               L_SQLERRM := SUBSTR(SQLERRM,1,200);
            END IF;
            UNAPIRA.L_EXCEPTION_STEP := '(HandleInsert) Major error('||TO_CHAR(SQLCODE)||') on table='||A_TABLE_NAME||
                                        '#object_tp='||L_OBJECT_TP||'#object_id='||L_OBJECT_ID||
                                        '#version='||NVL(L_VERSION,'VERSION EMPTY');
            IF L_OBJECT_TP = 'pp' THEN
               UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#pp_key1='||L_PP_KEY1||'#pp_key2='||L_PP_KEY2||
                                           '#pp_key3='||L_PP_KEY3||'#pp_key4='||L_PP_KEY4||'#pp_key5='||L_PP_KEY5;
            ELSIF L_OBJECT_TP = 'eq' THEN
               UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#lab='||L_LAB;
            END IF;
            UNAPIGEN.LOGERROR('HandleInsert',SUBSTR(L_SQL_STRING,1,255));
            UNAPIGEN.LOGERROR('HandleInsert',SUBSTR(L_SQL_STRING,256,255));
            RAISE;
         END IF;
   END;

   UNAPIRA.L_EXCEPTION_STEP := '(HandleInsert) Closing cursor,  table='||A_TABLE_NAME||
                               '#object_tp='||L_OBJECT_TP||'#object_id='||L_OBJECT_ID||
                               '#version='||NVL(L_VERSION,'VERSION EMPTY');
   IF L_OBJECT_TP = 'pp' THEN
      UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#pp_key1='||L_PP_KEY1||'#pp_key2='||L_PP_KEY2||
                                  '#pp_key3='||L_PP_KEY3||'#pp_key4='||L_PP_KEY4||'#pp_key5='||L_PP_KEY5;
   ELSIF L_OBJECT_TP = 'eq' THEN
      UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#lab='||L_LAB;
   END IF;

   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   
   
   
   
   IF A_TABLE_NAME IN ('utrqsc','utsdsc') THEN
      UNAPIRA.L_EXCEPTION_STEP := '(HandleInsert) Removing sc linked to this request/study before restore';
      
      L_SC_FOUND := FALSE;
      L_SC := NULL;

      FOR L_ROW IN 1..UNAPIRA.P_MAXCOLUMNSBYTABLE LOOP
         IF P_COLID_TAB(L_ROW)='sc' THEN
            L_SC := P_COL_TAB(L_ROW);
            L_SC_FOUND := TRUE;
            EXIT;
         END IF;
      END LOOP;

      IF L_SC_FOUND THEN
         UNAPIRA.L_EXCEPTION_STEP := '(HandleInsert) Removing sample '||L_SC;
         L_RET_CODE := UNAPIRASC.REMOVESCFROMDB(L_SC);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIRA.L_EXCEPTION_STEP := '(HandleInsert) RemoveScFromDB returned '||TO_CHAR(L_RET_CODE)||' for sample'||L_SC;
            RAISE STPERROR;
         END IF;
      ELSE
         UNAPIRA.L_EXCEPTION_STEP := '(HandleInsert) Major error sample column not found for utrqsc/utsdsc table !';
         RAISE STPERROR;
      END IF;
   END IF;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> -942 THEN
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
      END IF;
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      UNAPIRA.L_EXCEPTION_STEP := '(HandleInsert) Major error('|| TO_CHAR(SQLCODE)||') on table='||A_TABLE_NAME||
                                  '#object_tp='||L_OBJECT_TP||'#object_id='||L_OBJECT_ID||
                                  '#version='||NVL(L_VERSION,'VERSION EMPTY');
      IF L_OBJECT_TP = 'pp' THEN
         UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#pp_key1='||L_PP_KEY1||'#pp_key2='||L_PP_KEY2||
                                     '#pp_key3='||L_PP_KEY3||'#pp_key4='||L_PP_KEY4||'#pp_key5='||L_PP_KEY5;
      ELSIF L_OBJECT_TP = 'eq' THEN
         UNAPIRA.L_EXCEPTION_STEP := UNAPIRA.L_EXCEPTION_STEP||'#lab='||L_LAB;
      END IF;
      UNAPIGEN.LOGERROR('HandleInsert',L_SQL_STRING);
      FOR I IN 0..7 LOOP
         UNAPIGEN.LOGERROR('HandleInsert','SQL' || TO_CHAR(I) || '>' || SUBSTR(L_SQL_STRING,(250*I)+1,250));
      END LOOP ;

      RAISE;
   END IF;
END HANDLEINSERT;


PROCEDURE RESTOREROWFROMFILE                  
IS
   L_TABLE_NAME    VARCHAR2(30);
   L_SEP_POS       INTEGER;
   L_PREV_SEP_POS  INTEGER;
   L_LENGTH        INTEGER;
   L_COLUMN_STRUCT VARCHAR2(2000);
   L_COUNT_SEP     INTEGER;

   FUNCTION COLUMNID(A_COL_NUMBER IN NUMBER)
   RETURN VARCHAR2 IS
      L_START_POS  INTEGER;
      L_END_POS    INTEGER;
   BEGIN
      UNAPIRA.L_EXCEPTION_STEP := 'Looking for column  '||NVL(A_COL_NUMBER,0)||' in table '||L_TABLE_NAME;
      L_START_POS := 0;
      IF A_COL_NUMBER > 1 THEN
         L_START_POS := INSTR(L_COLUMN_STRUCT,UNAPIRA.P_SEP, 1, A_COL_NUMBER-1);
      END IF;
      L_START_POS := L_START_POS + 1;
      L_END_POS := 0;
      L_END_POS := INSTR(L_COLUMN_STRUCT,UNAPIRA.P_SEP, L_START_POS, 1);
      L_END_POS := L_END_POS - 1;

      IF L_END_POS > 0 THEN
         RETURN (SUBSTR(L_COLUMN_STRUCT, L_START_POS, L_END_POS-L_START_POS+1));
      ELSE
         RETURN (SUBSTR(L_COLUMN_STRUCT, L_START_POS));
      END IF;
   END COLUMNID;
BEGIN
   
   
   
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   
   UNAPIRA.L_EXCEPTION_STEP := 'Extracting table name';
   L_SEP_POS := INSTR(L_GETTEXT,UNAPIRA.P_SEP, 1, 1);
   L_TABLE_NAME := SUBSTR(L_GETTEXT, 1, L_SEP_POS-1);

   
   UNAPIRA.L_EXCEPTION_STEP := 'Find corresponding table struct for table '||L_TABLE_NAME;
   L_COLUMN_STRUCT := NULL;
   FOR L_ROW IN 1..L_TABSTRUCT_NR_OF_ROWS LOOP
      IF L_TABSTRUCT_TABLE_NAME(L_ROW) = L_TABLE_NAME THEN
         L_COLUMN_STRUCT := L_TABSTRUCT_COLUMNS(L_ROW);
      END IF;
   END LOOP;

   IF L_COLUMN_STRUCT IS NULL THEN
      L_SQLERRM := 'No table structure found for table '||L_TABLE_NAME;
      RAISE STPERROR;
   END IF;

   
   UNAPIRA.L_EXCEPTION_STEP := 'Initialise output array for table '||L_TABLE_NAME;
   FOR L_ROW IN 1..UNAPIRA.P_MAXCOLUMNSBYTABLE LOOP
      P_COL_TAB(L_ROW)   := NULL;
      P_COLID_TAB(L_ROW) := NULL;
   END LOOP;

   
   
   UNAPIRA.L_EXCEPTION_STEP := 'Dispatching values into variables for table '||L_TABLE_NAME;
   L_COUNT_SEP := 0;
   L_PREV_SEP_POS := L_SEP_POS;   
   LOOP
      L_SEP_POS := INSTR(L_GETTEXT, UNAPIRA.P_SEP, L_PREV_SEP_POS+1, 1);
      IF L_SEP_POS > (L_PREV_SEP_POS+1) THEN
         P_COL_TAB(L_COUNT_SEP+1) := REPLACE(SUBSTR(L_GETTEXT, L_PREV_SEP_POS+1, L_SEP_POS-L_PREV_SEP_POS-1),'<TAB>',CHR(9));
         P_COLID_TAB(L_COUNT_SEP+1) := COLUMNID(L_COUNT_SEP+1);
      ELSIF L_SEP_POS = 0 THEN   
         P_COL_TAB(L_COUNT_SEP+1) := REPLACE(SUBSTR(L_GETTEXT, L_PREV_SEP_POS+1),'<TAB>',CHR(9));
         P_COLID_TAB(L_COUNT_SEP+1) := COLUMNID(L_COUNT_SEP+1);
      ELSE   
         P_COL_TAB(L_COUNT_SEP+1) := NULL;
         P_COLID_TAB(L_COUNT_SEP+1) := COLUMNID(L_COUNT_SEP+1);
      END IF;

      L_PREV_SEP_POS := L_SEP_POS;
      L_COUNT_SEP := L_COUNT_SEP + 1;
      EXIT WHEN L_SEP_POS = 0;
   END LOOP;

   UNAPIRA.L_EXCEPTION_STEP := 'Insert a row for table '||L_TABLE_NAME;
   HANDLEINSERT(L_TABLE_NAME);
   UNAPIRA.L_EXCEPTION_STEP := NULL;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,200);
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreRowFromFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR', UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreRowFromFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR', UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   END IF;
   RAISE;
END RESTOREROWFROMFILE;


FUNCTION RESTOREFROMFILE                               
(A_ARCHIVE_TO       IN     VARCHAR2,                   
 A_ARCHIVE_FROM     IN     VARCHAR2,                   
 A_ARCHIVE_ID       IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_OBJECT_TP        IN     UNAPIGEN.VC40_TABLE_TYPE,   
 A_OBJECT_ID        IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_OBJECT_VERSION   IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_OBJECT_DETAILS   IN     UNAPIGEN.VC255_TABLE_TYPE,  
 A_ARCHIVED_ON      IN     UNAPIGEN.DATE_TABLE_TYPE,   
 A_NR_OF_ROWS       IN OUT NUMBER)                     
RETURN NUMBER  IS
   L_SEP_POS         INTEGER;
   L_NEXT_SEP_POS    INTEGER;
   L_RESTORE_OBJECT  BOOLEAN;
   L_OLD_DATE_FORMAT VARCHAR2(40);
   L_POS_GK_VERSION  INTEGER;
   L_POS_GKSEQ       INTEGER;

   L_TMP_TAB         UNAPIGEN.VC40_TABLE_TYPE;
   L_NR_OF_ROWS      NUMBER;
   L_REMOVE_OBJECT   BOOLEAN;

   
   A_PP_KEY1          VARCHAR2(20);
   A_PP_KEY2          VARCHAR2(20);
   A_PP_KEY3          VARCHAR2(20);
   A_PP_KEY4          VARCHAR2(20);
   A_PP_KEY5          VARCHAR2(20);
   A_LAB              VARCHAR2(20);
BEGIN
   
   
         
   
   

   
   
   
   L_SQLERRM                := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;
   L_OBJECT_TP              := NULL;
   L_OBJECT_ID              := NULL;
   L_VERSION                := NULL;
   L_PP_KEY1                := ' ';
   L_PP_KEY2                := ' ';
   L_PP_KEY3                := ' ';
   L_PP_KEY4                := ' ';
   L_PP_KEY5                := ' ';
   L_LAB                    := '-';
   A_PP_KEY1                := ' ';
   A_PP_KEY2                := ' ';
   A_PP_KEY3                := ' ';
   A_PP_KEY4                := ' ';
   A_PP_KEY5                := ' ';
   A_LAB                    := '-';

   
   
   
   
   
   OPEN UNAPIRA.C_SYSTEM('ARCHIVE_DIR');
   FETCH UNAPIRA.C_SYSTEM
   INTO UNAPIRA.P_FILE_DIR;
   IF UNAPIRA.C_SYSTEM%NOTFOUND THEN
      CLOSE UNAPIRA.C_SYSTEM;
      RETURN (UNAPIGEN.DBERR_SYSDEFAULTS);
   END IF;
   CLOSE UNAPIRA.C_SYSTEM;

   
   
   
   
   
   
   UNAPIRA.P_FILE_NAME := A_ARCHIVE_FROM;

   
   UNAPIRA.L_EXCEPTION_STEP := 'RestoreFromFile: Opening file in read mode directory='||UNAPIRA.P_FILE_DIR||
                               '#file='||UNAPIRA.P_FILE_NAME;
   UNAPIRA.P_ARCH_FILE_HANDLE := UTL_FILE.FOPEN(UNAPIRA.P_FILE_DIR, UNAPIRA.P_FILE_NAME, 'R');
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   
   
   
   UNAPIRA.L_EXCEPTION_STEP := 'RestoreFromFile: Reading [Information] section from file directory='||UNAPIRA.P_FILE_DIR||
                               '#file='||UNAPIRA.P_FILE_NAME;
   UTL_FILE.GET_LINE(UNAPIRA.P_ARCH_FILE_HANDLE, L_GETTEXT);
   IF L_GETTEXT <> '[Information]' THEN
      L_SQLERRM := 'No [Information] section found in archive file';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreFromFile', L_SQLERRM, 'OTHERS',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;

   
   UNAPIRA.P_ARCHIVE_TSTZ_FORMAT := NULL;
   LOOP
      UNAPIRA.L_EXCEPTION_STEP := 'Reading one line from directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME;
      UTL_FILE.GET_LINE(UNAPIRA.P_ARCH_FILE_HANDLE, L_GETTEXT);
      UNAPIRA.L_EXCEPTION_STEP := NULL;
      IF SUBSTR(L_GETTEXT, 1, 16) = 'archiver_version' THEN
         UNAPIRA.P_ARCHIVE_ARCHIVER_VERSION := SUBSTR(L_GETTEXT, INSTR(L_GETTEXT,UNAPIRA.P_SEP,1,1)+1);
      ELSIF SUBSTR(L_GETTEXT, 1, 11) = 'date_format' THEN
         UNAPIRA.P_ARCHIVE_TSTZ_FORMAT := SUBSTR(L_GETTEXT, INSTR(L_GETTEXT,UNAPIRA.P_SEP,1,1)+1);
      END IF;
      EXIT WHEN LTRIM(RTRIM(L_GETTEXT)) = '[Table structures]'; 
   END LOOP;

   IF UNAPIRA.P_ARCHIVE_TSTZ_FORMAT IS NULL THEN
      L_SQLERRM := 'No archive date format found in archive file';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreFromFile', L_SQLERRM, 'OTHERS',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;

   L_OLD_DATE_FORMAT := UNAPIRA.P_TSTZ_FORMAT;
   UNAPIRA.P_TSTZ_FORMAT := UNAPIRA.P_ARCHIVE_TSTZ_FORMAT;

   
   
   L_TABSTRUCT_NR_OF_ROWS := 0;
   LOOP
      U4DATAGETLINE;
      UNAPIRA.L_EXCEPTION_STEP :=SUBSTR('RestoreFromFile: Processing line until Table data...<<'||L_GETTEXT||'>>', 1,2000) ;
      IF SUBSTR(L_GETTEXT,1,2) IN ('ut','at') THEN
         L_TABSTRUCT_NR_OF_ROWS := L_TABSTRUCT_NR_OF_ROWS + 1;
         L_SEP_POS := INSTR(L_GETTEXT,UNAPIRA.P_SEP, 1, 1);
         L_TABSTRUCT_TABLE_NAME(L_TABSTRUCT_NR_OF_ROWS) := SUBSTR(L_GETTEXT, 1, L_SEP_POS-1);
         
         
         
         
         
         
         
         
         
         
         IF L_TABSTRUCT_TABLE_NAME(L_TABSTRUCT_NR_OF_ROWS) IN ('utstgk', 'utrtgk',
            'utscgk', 'utscmegk', 'utwsgk', 'utrqgk', 'utsdgk', 'utptgk') THEN
            L_POS_GK_VERSION := INSTR(L_GETTEXT, 'gk_version');
            L_POS_GKSEQ := INSTR(L_GETTEXT, 'gkseq');
            IF L_POS_GK_VERSION > 0 AND  L_POS_GK_VERSION > L_POS_GKSEQ THEN
               IF L_TABSTRUCT_TABLE_NAME(L_TABSTRUCT_NR_OF_ROWS) = 'utstgk' THEN
                  L_TABSTRUCT_COLUMNS(L_TABSTRUCT_NR_OF_ROWS) := REPLACE(UNAPIRA3.CONSTANT_ALLSTGKCOLUMNS, ', ', UNAPIRA.P_SEP);
               ELSIF L_TABSTRUCT_TABLE_NAME(L_TABSTRUCT_NR_OF_ROWS) = 'utrtgk' THEN
                  L_TABSTRUCT_COLUMNS(L_TABSTRUCT_NR_OF_ROWS) := REPLACE(UNAPIRA3.CONSTANT_ALLRTGKCOLUMNS, ', ', UNAPIRA.P_SEP);
               ELSIF L_TABSTRUCT_TABLE_NAME(L_TABSTRUCT_NR_OF_ROWS) = 'utscgk' THEN
                  L_TABSTRUCT_COLUMNS(L_TABSTRUCT_NR_OF_ROWS) := REPLACE(UNAPIRA3.CONSTANT_ALLSCGKCOLUMNS, ', ', UNAPIRA.P_SEP);
               ELSIF L_TABSTRUCT_TABLE_NAME(L_TABSTRUCT_NR_OF_ROWS) = 'utscmegk' THEN
                  L_TABSTRUCT_COLUMNS(L_TABSTRUCT_NR_OF_ROWS) := REPLACE(UNAPIRA3.CONSTANT_ALLSCMEGKCOLUMNS, ', ', UNAPIRA.P_SEP);
               ELSIF L_TABSTRUCT_TABLE_NAME(L_TABSTRUCT_NR_OF_ROWS) = 'utwsgk' THEN
                  L_TABSTRUCT_COLUMNS(L_TABSTRUCT_NR_OF_ROWS) := REPLACE(UNAPIRA3.CONSTANT_ALLWSGKCOLUMNS, ', ', UNAPIRA.P_SEP);
               ELSIF L_TABSTRUCT_TABLE_NAME(L_TABSTRUCT_NR_OF_ROWS) = 'utrqgk' THEN
                  L_TABSTRUCT_COLUMNS(L_TABSTRUCT_NR_OF_ROWS) := REPLACE(UNAPIRA3.CONSTANT_ALLRQGKCOLUMNS, ', ', UNAPIRA.P_SEP);
               ELSIF L_TABSTRUCT_TABLE_NAME(L_TABSTRUCT_NR_OF_ROWS) = 'utsdgk' THEN
                  L_TABSTRUCT_COLUMNS(L_TABSTRUCT_NR_OF_ROWS) := REPLACE(UNAPIRA3.CONSTANT_ALLSDGKCOLUMNS, ', ', UNAPIRA.P_SEP);
               ELSIF L_TABSTRUCT_TABLE_NAME(L_TABSTRUCT_NR_OF_ROWS) = 'utptgk' THEN
                  L_TABSTRUCT_COLUMNS(L_TABSTRUCT_NR_OF_ROWS) := REPLACE(UNAPIRA3.CONSTANT_ALLPTGKCOLUMNS, ', ', UNAPIRA.P_SEP);
               END IF;
            ELSE
               L_TABSTRUCT_COLUMNS(L_TABSTRUCT_NR_OF_ROWS) := SUBSTR(L_GETTEXT, L_SEP_POS+1);
            END IF;
         ELSE
            L_TABSTRUCT_COLUMNS(L_TABSTRUCT_NR_OF_ROWS) := SUBSTR(L_GETTEXT, L_SEP_POS+1);
         END IF;
      END IF;

      EXIT WHEN LTRIM(RTRIM(L_GETTEXT)) = '[Table data]'; 
   END LOOP;

   U4DATAGETLINE;
   UNAPIRA.L_EXCEPTION_STEP := SUBSTR('RestoreRowFromFile: Processing line until [EOF]...<<'||L_GETTEXT||'>>', 1,2000);
   
   LOOP
      EXIT WHEN L_GETTEXT = '[End of File]';

      IF SUBSTR(L_GETTEXT,1,1) = '[' THEN
         UNAPIRA.L_EXCEPTION_STEP := SUBSTR('RestoreFromFile: extracting object information from:'||L_GETTEXT, 1,2000);
         
         
         
         
         L_SEP_POS := INSTR(L_GETTEXT, UNAPIRA.P_INTERNAL_SEP, 1, 1);
         IF L_SEP_POS = 0 THEN
            L_SEP_POS := INSTR(L_GETTEXT, UNAPIRA.P_SEP, 1, 1);         
         END IF;
         
         
         
         
         
         L_NEXT_SEP_POS := L_SEP_POS;
         L_SEP_POS := 1;
         L_NR_OF_ROWS := 0;
         
         LOOP
            EXIT WHEN L_NEXT_SEP_POS = 0;
            L_NR_OF_ROWS := L_NR_OF_ROWS + 1;
            L_TMP_TAB(L_NR_OF_ROWS) := SUBSTR(L_GETTEXT, L_SEP_POS+1, L_NEXT_SEP_POS-(L_SEP_POS+1));
            L_SEP_POS := L_NEXT_SEP_POS;
            L_NEXT_SEP_POS := INSTR(L_GETTEXT, UNAPIRA.P_SEP, 1, L_NR_OF_ROWS+1);
         END LOOP;
         L_NR_OF_ROWS := L_NR_OF_ROWS + 1;
         L_TMP_TAB(L_NR_OF_ROWS) := SUBSTR(L_GETTEXT, L_SEP_POS+1, LENGTH(L_GETTEXT)-(L_SEP_POS+1));
         
         FOR I IN 1..L_NR_OF_ROWS LOOP
            IF I = 1 THEN
               L_OBJECT_TP := L_TMP_TAB(I);
            ELSIF I = 2 THEN
               L_OBJECT_ID := L_TMP_TAB(I);
            ELSIF I = 3 THEN
               L_VERSION := L_TMP_TAB(I);
            ELSIF I = 4 THEN
               IF L_OBJECT_TP = 'pp' THEN
                  L_PP_KEY1 := L_TMP_TAB(I);
               ELSIF L_OBJECT_TP = 'eq' THEN
                  L_LAB := L_TMP_TAB(I);
               END IF;
            ELSIF I = 5 THEN
               L_PP_KEY2 := L_TMP_TAB(I);
            ELSIF I = 6 THEN
               L_PP_KEY3 := L_TMP_TAB(I);
            ELSIF I = 7 THEN
               L_PP_KEY4 := L_TMP_TAB(I);
            ELSIF I = 8 THEN
               L_PP_KEY5 := L_TMP_TAB(I);
            END IF;
         END LOOP;
      ELSE
         EXIT;
      END IF;
      UNAPIRA.L_EXCEPTION_STEP := SUBSTR('RestoreFromFile: process object from:'||L_GETTEXT, 1,2000) ;

      IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;

      
      L_RESTORE_OBJECT := FALSE;

      
      FOR L_ROW IN 1..A_NR_OF_ROWS LOOP
         
         IF A_OBJECT_DETAILS(L_ROW) IS NOT NULL THEN
            UNAPIRA.PARSEOBJECTDETAILS(A_OBJECT_DETAILS(L_ROW), 
                                       A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5, A_LAB);
         END IF;
         
         L_REMOVE_OBJECT := FALSE;
         IF (NVL(A_NR_OF_ROWS,0) = 0) THEN  
            L_REMOVE_OBJECT := TRUE;
         ELSE
            IF (A_OBJECT_TP(L_ROW)=L_OBJECT_TP) THEN
               
               IF L_OBJECT_TP IN ('sc', 'rq', 'ws', 'sd', 'ch', 'jo', 'co', 'at') AND
                  A_OBJECT_ID(L_ROW)=L_OBJECT_ID THEN
                  
                  L_REMOVE_OBJECT := TRUE;
               
               ELSIF A_OBJECT_ID(L_ROW)=L_OBJECT_ID AND
                     NVL(A_OBJECT_VERSION(L_ROW),'0')=NVL(L_VERSION,NVL(A_OBJECT_VERSION(L_ROW),'0')) THEN
                  L_REMOVE_OBJECT := TRUE;
               END IF;            
            END IF;               
         END IF;
         
         IF L_REMOVE_OBJECT = TRUE THEN
            L_RESTORE_OBJECT := TRUE;
            
            IF A_OBJECT_TP(L_ROW)='sc' THEN
               L_RET_CODE := UNAPIRASC.REMOVESCFROMDB(A_OBJECT_ID(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveScFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#sc='||A_OBJECT_ID(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='rq' THEN
               L_RET_CODE := UNAPIRARQ.REMOVERQFROMDB(A_OBJECT_ID(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveRqFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#rq='||A_OBJECT_ID(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='ws' THEN
               L_RET_CODE := UNAPIRAWS.REMOVEWSFROMDB(A_OBJECT_ID(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveWsFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#ws='||A_OBJECT_ID(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='sd' THEN
               L_RET_CODE := UNAPIRASD.REMOVESDFROMDB(A_OBJECT_ID(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveSdFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#sd='||A_OBJECT_ID(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='ch' THEN
               L_RET_CODE := UNAPIRACH.REMOVECHFROMDB(A_OBJECT_ID(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveChFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#ch='||A_OBJECT_ID(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='st' THEN
               L_RET_CODE := UNAPIRAST.REMOVESTFROMDB(A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveStFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#st='||A_OBJECT_ID(L_ROW)||
                               '#version='||A_OBJECT_VERSION(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='pp' THEN
               IF (A_PP_KEY1 = L_PP_KEY1 AND A_PP_KEY2 = L_PP_KEY2 AND A_PP_KEY3 = L_PP_KEY3 AND 
                   A_PP_KEY4 = L_PP_KEY4 AND A_PP_KEY5 = L_PP_KEY5) THEN
                  L_RET_CODE := UNAPIRAPP.REMOVEPPFROMDB(A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW),
                                                        A_PP_KEY1, A_PP_KEY2, A_PP_KEY3, A_PP_KEY4, A_PP_KEY5);
                  IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                     L_SQLERRM := 'RemovePpFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#pp='||A_OBJECT_ID(L_ROW)||
                                  '#version='||A_OBJECT_VERSION(L_ROW)||'#pp_key1='||L_PP_KEY1||'#pp_key2='||L_PP_KEY2||
                                  '#pp_key3='||L_PP_KEY3||'#pp_key4='||L_PP_KEY4||'#pp_key5='||L_PP_KEY5;
                     RAISE STPERROR;
                  END IF;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='ip' THEN
               L_RET_CODE := UNAPIRAIP.REMOVEIPFROMDB(A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveIpFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#ip='||A_OBJECT_ID(L_ROW)||
                               '#version='||A_OBJECT_VERSION(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='ie' THEN
               L_RET_CODE := UNAPIRAIE.REMOVEIEFROMDB(A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveIeFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#ie='||A_OBJECT_ID(L_ROW)||
                               '#version='||A_OBJECT_VERSION(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='pr' THEN
               L_RET_CODE := UNAPIRAPR.REMOVEPRFROMDB(A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemovePrFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#pr='||A_OBJECT_ID(L_ROW)||
                               '#version='||A_OBJECT_VERSION(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='mt' THEN
               L_RET_CODE := UNAPIRAMT.REMOVEMTFROMDB(A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveMtFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#mt='||A_OBJECT_ID(L_ROW)||
                               '#version='||A_OBJECT_VERSION(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='eq' THEN
               IF (A_LAB = L_LAB) THEN
                  L_RET_CODE := UNAPIRAEQ.REMOVEEQFROMDB(A_OBJECT_ID(L_ROW), A_LAB);
                  IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                     L_SQLERRM := 'RemoveEqFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#eq='||A_OBJECT_ID(L_ROW)||
                                  '#lab='||A_LAB;
                     RAISE STPERROR;
                  END IF;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='rt' THEN
               L_RET_CODE := UNAPIRART.REMOVERTFROMDB(A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveRtFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#rt='||A_OBJECT_ID(L_ROW)||
                               '#version='||A_OBJECT_VERSION(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='wt' THEN
               L_RET_CODE := UNAPIRAWT.REMOVEWTFROMDB(A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveWtFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#wt='||A_OBJECT_ID(L_ROW)||
                               '#version='||A_OBJECT_VERSION(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='pt' THEN
               L_RET_CODE := UNAPIRAPT.REMOVEPTFROMDB(A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemovePtFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#pt='||A_OBJECT_ID(L_ROW)||
                               '#version='||A_OBJECT_VERSION(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='cy' THEN
               L_RET_CODE := UNAPIRACY.REMOVECYFROMDB(A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveCyFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#cy='||A_OBJECT_ID(L_ROW)||
                               '#version='||A_OBJECT_VERSION(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF SUBSTR(A_OBJECT_TP(L_ROW),1, 2) ='ly' THEN
               L_RET_CODE := UNAPIRALY.REMOVELYFROMDB(A_OBJECT_ID(L_ROW), SUBSTR(A_OBJECT_TP(L_ROW),3));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveLyFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#ly='||A_OBJECT_ID(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF SUBSTR(A_OBJECT_TP(L_ROW),1, 2) ='gk' THEN
               L_RET_CODE := UNAPIRAGK.REMOVEGKFROMDB(A_OBJECT_ID(L_ROW), SUBSTR(A_OBJECT_TP(L_ROW),3));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveGkFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#gk='||A_OBJECT_ID(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW) ='au' THEN
               L_RET_CODE := UNAPIRAAU.REMOVEAUFROMDB(A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveAuFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#au='||A_OBJECT_ID(L_ROW)||
                               '#version='||A_OBJECT_VERSION(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW) ='lc' THEN
               L_RET_CODE := UNAPIRALC.REMOVELCFROMDB(A_OBJECT_ID(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveLcFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#lc='||A_OBJECT_ID(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW)='jo' THEN
               L_RET_CODE := UNAPIRAJO.REMOVEJOFROMDB(A_OBJECT_ID(L_ROW));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveJoFromDB ret_code='||TO_CHAR(L_RET_CODE)||'#journal_nr='||A_OBJECT_ID(L_ROW);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW) = 'co' THEN
               
               L_RET_CODE := UNAPIRAT3.REMOVETP3FROMDB;
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveTp3FromDB ret_code='||TO_CHAR(L_RET_CODE);
                  RAISE STPERROR;
               END IF;
            ELSIF A_OBJECT_TP(L_ROW) = 'at' THEN
               
               L_RET_CODE := UNAPIRAAT.REMOVEATFROMDB;
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'RemoveAtFromDB ret_code='||TO_CHAR(L_RET_CODE);
                  RAISE STPERROR;
               END IF;
            
            
            END IF;
         END IF;
      END LOOP;

      LOOP
         U4DATAGETLINE;
         UNAPIRA.L_EXCEPTION_STEP := SUBSTR('RestoreRowFromFile: Processing line for RestoreRowFromFile...<<'||L_GETTEXT||'>>', 1,2000) ;

         IF SUBSTR(L_GETTEXT,1,2) IN ('ut','at') THEN
            IF L_RESTORE_OBJECT THEN
               BEGIN
                  RESTOREROWFROMFILE;
               EXCEPTION
               WHEN OTHERS THEN
                  

                  
                  LOOP
                     U4DATAGETLINE;
                     UNAPIRA.L_EXCEPTION_STEP := SUBSTR('RestoreRowFromFile: Skipping current section...last read:<<'||L_GETTEXT||'>>', 1,2000);
                     EXIT WHEN SUBSTR(L_GETTEXT,1,1) = '[';
                  END LOOP;
                  EXIT;
               END;
            END IF;
         ELSIF SUBSTR(L_GETTEXT,1,1) = '[' THEN
            EXIT;
         END IF;
      END LOOP;

      
      
      
      
      UNAPIGEN.U4COMMIT ;

      IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
   END LOOP;

   IF UTL_FILE.IS_OPEN (UNAPIRA.P_ARCH_FILE_HANDLE) THEN
      UTL_FILE.FCLOSE(UNAPIRA.P_ARCH_FILE_HANDLE);
   END IF;

   
   UNAPIRA.P_TSTZ_FORMAT := L_OLD_DATE_FORMAT;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN UTL_FILE.INVALID_PATH THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreFromFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
   
   UNAPIRA.P_TSTZ_FORMAT := L_OLD_DATE_FORMAT;
   RETURN(UNAPIGEN.DBERR_NOOBJECT);
WHEN UTL_FILE.INVALID_MODE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreFromFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
   
   UNAPIRA.P_TSTZ_FORMAT := L_OLD_DATE_FORMAT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
WHEN UTL_FILE.INVALID_FILEHANDLE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreFromFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
   
   UNAPIRA.P_TSTZ_FORMAT := L_OLD_DATE_FORMAT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
WHEN UTL_FILE.INVALID_OPERATION THEN
   
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreFromFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
   
   UNAPIRA.P_TSTZ_FORMAT := L_OLD_DATE_FORMAT;
   RETURN(UNAPIGEN.DBERR_NOOBJECT);
WHEN UTL_FILE.READ_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreFromFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   
   UNAPIRA.P_TSTZ_FORMAT := L_OLD_DATE_FORMAT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
WHEN UTL_FILE.WRITE_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreFromFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   
   UNAPIRA.P_TSTZ_FORMAT := L_OLD_DATE_FORMAT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
WHEN UTL_FILE.INTERNAL_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreFromFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   
   UNAPIRA.P_TSTZ_FORMAT := L_OLD_DATE_FORMAT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,200);
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreFromFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('RestoreFromFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   END IF;
   
   IF UTL_FILE.IS_OPEN (UNAPIRA.P_ARCH_FILE_HANDLE) THEN
      UTL_FILE.FCLOSE(UNAPIRA.P_ARCH_FILE_HANDLE);
   END IF;
   
   UNAPIRA.P_TSTZ_FORMAT := L_OLD_DATE_FORMAT;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END RESTOREFROMFILE;







FUNCTION RESTORE                                       
(A_ARCHIVE_TO       IN     VARCHAR2,                   
 A_ARCHIVE_FROM     IN     VARCHAR2,                   
 A_ARCHIVE_ID       IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_OBJECT_TP        IN     UNAPIGEN.VC40_TABLE_TYPE,   
 A_OBJECT_ID        IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_OBJECT_VERSION   IN     UNAPIGEN.VC20_TABLE_TYPE,   
 A_OBJECT_DETAILS   IN     UNAPIGEN.VC255_TABLE_TYPE,  
 A_ARCHIVED_ON      IN     UNAPIGEN.DATE_TABLE_TYPE,   
 A_NR_OF_ROWS       IN OUT NUMBER)                     
RETURN NUMBER  IS




   L_LOCKED       BOOLEAN;

   CURSOR L_OBJECTS_CURSOR(A_ARCHIVE_ID VARCHAR2) IS
      SELECT *
        FROM UAUTTOARCHIVE
       WHERE ARCHIVE_ID = A_ARCHIVE_ID;

   
   FUNCTION RESTOREOBJECTFROMDB
   (A_OBJECT_TP       IN VARCHAR2,
    A_OBJECT_ID       IN VARCHAR2,
    A_OBJECT_VERSION  IN VARCHAR2,
    A_OBJECT_DETAILS  IN VARCHAR2)
   RETURN NUMBER IS
      
      L_PP_KEY1          VARCHAR2(20);
      L_PP_KEY2          VARCHAR2(20);
      L_PP_KEY3          VARCHAR2(20);
      L_PP_KEY4          VARCHAR2(20);
      L_PP_KEY5          VARCHAR2(20);
      L_LAB              VARCHAR2(20);
   BEGIN
      IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;

      
      UNAPIRA.PARSEOBJECTDETAILS(A_OBJECT_DETAILS, 
                                 L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, L_LAB);

      IF A_OBJECT_TP = 'sc' THEN
         L_RET_CODE := UNAPIRASC.RESTORESCFROMDB(A_OBJECT_ID);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreScFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'rq' THEN
         L_RET_CODE := UNAPIRARQ.RESTORERQFROMDB(A_OBJECT_ID);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreRqFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'ws' THEN
         L_RET_CODE := UNAPIRAWS.RESTOREWSFROMDB(A_OBJECT_ID);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreWsFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'sd' THEN
         L_RET_CODE := UNAPIRASD.RESTORESDFROMDB(A_OBJECT_ID);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreSdFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'ch' THEN
         L_RET_CODE := UNAPIRACH.RESTORECHFROMDB(A_OBJECT_ID);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreChFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'st' THEN
         L_RET_CODE := UNAPIRAST.RESTORESTFROMDB(A_OBJECT_ID, A_OBJECT_VERSION);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreStFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'pp' THEN
         L_RET_CODE := UNAPIRAPP.RESTOREPPFROMDB(A_OBJECT_ID, A_OBJECT_VERSION, L_PP_KEY1, 
                                                 L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestorePpFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'ip' THEN
         L_RET_CODE := UNAPIRAIP.RESTOREIPFROMDB(A_OBJECT_ID, A_OBJECT_VERSION);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreIpFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'ie' THEN
         L_RET_CODE := UNAPIRAIE.RESTOREIEFROMDB(A_OBJECT_ID, A_OBJECT_VERSION);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreIeFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'pr' THEN
         L_RET_CODE := UNAPIRAPR.RESTOREPRFROMDB(A_OBJECT_ID, A_OBJECT_VERSION);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestorePrFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'mt' THEN
         L_RET_CODE := UNAPIRAMT.RESTOREMTFROMDB(A_OBJECT_ID, A_OBJECT_VERSION);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreMtFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'eq' THEN
         L_RET_CODE := UNAPIRAEQ.RESTOREEQFROMDB(A_OBJECT_ID, L_LAB);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreEqFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'rt' THEN
         L_RET_CODE := UNAPIRART.RESTORERTFROMDB(A_OBJECT_ID, A_OBJECT_VERSION);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreRtFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'wt' THEN
         L_RET_CODE := UNAPIRAWT.RESTOREWTFROMDB(A_OBJECT_ID, A_OBJECT_VERSION);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreWtFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'pt' THEN
         L_RET_CODE := UNAPIRAPT.RESTOREPTFROMDB(A_OBJECT_ID, A_OBJECT_VERSION);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestorePtFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'cy' THEN
         L_RET_CODE := UNAPIRACY.RESTORECYFROMDB(A_OBJECT_ID, A_OBJECT_VERSION);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreCyFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'au' THEN
         L_RET_CODE := UNAPIRAAU.RESTOREAUFROMDB(A_OBJECT_ID, A_OBJECT_VERSION);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreAuFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'lc' THEN
         L_RET_CODE := UNAPIRALC.RESTORELCFROMDB(A_OBJECT_ID);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreLcFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF SUBSTR(A_OBJECT_TP, 1, 2) = 'ly' THEN
         L_RET_CODE := UNAPIRALY.RESTORELYFROMDB(A_OBJECT_ID, SUBSTR(A_OBJECT_TP,3));
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreLyFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF SUBSTR(A_OBJECT_TP, 1, 2) = 'gk' THEN
         L_RET_CODE := UNAPIRAGK.RESTOREGKFROMDB(A_OBJECT_ID, SUBSTR(A_OBJECT_TP,3));
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreGkFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'jo' THEN
         L_RET_CODE := UNAPIRAJO.RESTOREJOFROMDB(A_OBJECT_ID);
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreJoFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'co' THEN
         
         L_RET_CODE := UNAPIRAT3.REMOVETP3FROMDB;
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RemoveTp3FromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
         L_RET_CODE := UNAPIRAT3.RESTORETP3FROMDB;
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreTp3FromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSIF A_OBJECT_TP = 'at' THEN
         
         L_RET_CODE := UNAPIRAAT.REMOVEATFROMDB;
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RemoveAtFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
         L_RET_CODE := UNAPIRAAT.RESTOREATFROMDB;
         IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
            L_SQLERRM := 'RestoreAtFromDB returned ' || L_RET_CODE;
            UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
            RAISE STPERROR;
         END IF;
      ELSE
         L_SQLERRM := 'RestoreObjectFromDB: Invalid datatype '||NVL(A_OBJECT_TP,'OBJECT_TP EMPTY')||'#'||
                      NVL(A_OBJECT_ID,'OBJECT_ID EMPTY')||'#'||NVL(A_OBJECT_VERSION,'VERSION EMPTY')||'#'||
                      NVL(A_OBJECT_DETAILS,'OBJECT_DETAILS EMPTY');
         RAISE STPERROR;
      END IF;

      IF UNAPIGEN.ENDTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;

      RETURN(L_RET_CODE);
   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIGEN.LOGERROR('RestoreObjectFromDB',L_SQLERRM);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIGEN.LOGERROR('RestoreObjectFromDB',L_SQLERRM);
      END IF;
      UNAPIGEN.LOGERROR('RestoreObjectFromDB','Could not Restore '||NVL(A_OBJECT_TP,'OBJECT_TP EMPTY')||'#'||
                        NVL(A_OBJECT_ID,'OBJECT_ID EMPTY')||'#'||NVL(A_OBJECT_VERSION,'VERSION EMPTY')||'#'||
                        NVL(A_OBJECT_DETAILS,'OBJECT_DETAILS EMPTY'));
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END RESTOREOBJECTFROMDB;
BEGIN
   L_LOCKED := FALSE;
   L_RET_CODE := UNAPIGEN.REQUESTLOCK('U4RADEF', '0', 1);
   IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
      UNAPIGEN.LOGERROR('Restore','RequestLock returned ' || L_RET_CODE);
      RETURN(L_RET_CODE);
   END IF;
   L_LOCKED := TRUE;

   
   IF NVL(A_ARCHIVE_TO, ' ') = 'DB' THEN
      IF NVL(A_NR_OF_ROWS, 0) <> 0 THEN
         FOR L_ROW IN 1..A_NR_OF_ROWS LOOP
            L_RET_CODE := RESTOREOBJECTFROMDB(A_OBJECT_TP(L_ROW), A_OBJECT_ID(L_ROW), A_OBJECT_VERSION(L_ROW), 
                                              A_OBJECT_DETAILS(L_ROW));
            IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.LOGERROR('Restore','RestoreObjectFromDB returned ' || L_RET_CODE);
               RAISE STPERROR;
            END IF;
         END LOOP;
      ELSE
         
         FOR L_OBJECTS_REC IN L_OBJECTS_CURSOR(A_ARCHIVE_ID(1)) LOOP
             L_RET_CODE := RESTOREOBJECTFROMDB(L_OBJECTS_REC.OBJECT_TP, L_OBJECTS_REC.OBJECT_ID, 
                                               L_OBJECTS_REC.VERSION, L_OBJECTS_REC.OBJECT_DETAILS);
             IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                UNAPIGEN.LOGERROR('Restore','RestoreObjectFromDB returned ' || L_RET_CODE);
                RAISE STPERROR;
             END IF;
         END LOOP;
      END IF;

      
      L_RET_CODE := UNAPIRA.CLOSEDBLINK('UNIARCH');
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         RAISE STPERROR;
      END IF;
   ELSIF NVL(A_ARCHIVE_TO, ' ') = 'FILE' THEN
      L_RET_CODE := RESTOREFROMFILE(A_ARCHIVE_TO,
                                    A_ARCHIVE_FROM,
                                    A_ARCHIVE_ID,
                                    A_OBJECT_TP,
                                    A_OBJECT_ID,
                                    A_OBJECT_VERSION,
                                    A_OBJECT_DETAILS,
                                    A_ARCHIVED_ON,
                                    A_NR_OF_ROWS);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.LOGERROR('Restore','RestoreFromFILE returned ' || L_RET_CODE);
         RAISE STPERROR;
      END IF;
   END IF;

   IF L_LOCKED THEN
      L_RET_CODE := UNAPIGEN.RELEASELOCK('U4RADEF', 1);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.LOGERROR('Restore','ReleaseLock returned ' || L_RET_CODE);
         RETURN(L_RET_CODE);
      END IF;
      L_LOCKED := FALSE;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,200);
      UNAPIGEN.LOGERROR('Restore',L_SQLERRM);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIGEN.LOGERROR('Restore',L_SQLERRM);
   END IF;
   IF L_LOCKED THEN
      L_RET_CODE := UNAPIGEN.RELEASELOCK('U4RADEF', 1);
      IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
         UNAPIGEN.LOGERROR('Restore','ReleaseLock returned ' || L_RET_CODE);
      END IF;
      L_LOCKED := FALSE;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END RESTORE;

END UNAPIRA2;