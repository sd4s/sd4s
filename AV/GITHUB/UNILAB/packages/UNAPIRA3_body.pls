PACKAGE BODY unapira3 AS

L_SQLERRM         VARCHAR2(255);
L_SQL_STRING      VARCHAR2(2000);
L_WHERE_CLAUSE    VARCHAR2(1000);
L_RET_CODE        NUMBER;
STPERROR          EXCEPTION;
L_DYN_CURSOR      INTEGER;
L_RESULT          INTEGER;
L_SEP             CHAR(1);


L_TABSTRUCT_NR_OF_ROWS    INTEGER;
L_TABSTRUCT_TABLE_NAME    UNAPIGEN.VC40_TABLE_TYPE;
L_TABSTRUCT_COLUMNS       UNAPIGEN.VC2000_TABLE_TYPE;








FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GETVERSION;

FUNCTION LISTALLCOLUMNS               
(A_TABLE_NAME IN VARCHAR2)            
RETURN VARCHAR2 IS
   L_STRING     VARCHAR2(2000);
   L_LENGTH     INTEGER;
   L_IGNORE     BOOLEAN;
BEGIN
   L_STRING := '';
   FOR L_USER_TAB_COLUMNS_REC IN UNAPIRA.L_USER_TAB_COLUMNS_CURSOR(A_TABLE_NAME) LOOP
      
      
      
      L_IGNORE := FALSE;
      IF L_USER_TAB_COLUMNS_REC.COLUMN_NAME = 'version_is_current' THEN
         FOR I IN 1..UNAPIGEN.L_NR_OF_TYPES LOOP
            IF UNAPIGEN.L_OBJECT_TYPES(I) = LOWER(SUBSTR(A_TABLE_NAME,3,2)) THEN
               L_IGNORE := TRUE;
            END IF;
         END LOOP;
      END IF;
      
      IF NOT L_IGNORE THEN
         IF L_STRING IS NULL THEN
            L_STRING := L_USER_TAB_COLUMNS_REC.COLUMN_NAME || UNAPIRA.P_SEP;
         ELSE
            L_STRING := L_STRING || L_USER_TAB_COLUMNS_REC.COLUMN_NAME || UNAPIRA.P_SEP;
         END IF;
      END IF;
   END LOOP;
   
   L_LENGTH := LENGTH(L_STRING);
   IF L_LENGTH > 0 THEN
      L_STRING := SUBSTR(L_STRING,1,L_LENGTH-1);
   END IF;

   RETURN(L_STRING);
END LISTALLCOLUMNS;


FUNCTION REMOVEONLY                 
(A_ARCHIVE_ID    IN VARCHAR2)       
RETURN NUMBER IS
   L_STRING             VARCHAR2(255);
   L_ARCHIVE_ID         VARCHAR2(40);
   L_PARTIAL_ARCHIVE    BOOLEAN;

   L_TOARCHIVE_REC      UNAPIRA.C_TOARCHIVE_CURSOR%ROWTYPE;

   
   L_PP_KEY1          VARCHAR2(20);
   L_PP_KEY2          VARCHAR2(20);
   L_PP_KEY3          VARCHAR2(20);
   L_PP_KEY4          VARCHAR2(20);
   L_PP_KEY5          VARCHAR2(20);
   L_LAB              VARCHAR2(20);

   CURSOR L_ORACLE_VERSION_CURSOR IS
      SELECT VERSION
        FROM SYS.PRODUCT_COMPONENT_VERSION
       WHERE INSTR(PRODUCT,'Oracle') <> 0;
   L_ORACLE_VERSION_REC L_ORACLE_VERSION_CURSOR%ROWTYPE;
BEGIN
   L_SQLERRM := NULL;
   L_PARTIAL_ARCHIVE := FALSE;

   IF A_ARCHIVE_ID IS NULL THEN
      L_ARCHIVE_ID := 'u4ar' || TO_CHAR(UNAPIRA.P_CURR_DATE, 'RRMMDD');
   ELSE
      L_ARCHIVE_ID := A_ARCHIVE_ID;
   END IF;

   UNAPIRA.L_EXCEPTION_STEP :='Removing Data for ' || L_ARCHIVE_ID;
   OPEN UNAPIRA.C_TOARCHIVE_CURSOR('FILE', L_ARCHIVE_ID);
   LOOP
      BEGIN
         
         
         
         
         
         FETCH UNAPIRA.C_TOARCHIVE_CURSOR INTO L_TOARCHIVE_REC;
         IF UNAPIRA.C_TOARCHIVE_CURSOR%NOTFOUND THEN
            EXIT;
         END IF;
      
         
         UNAPIRA.PARSEOBJECTDETAILS(L_TOARCHIVE_REC.OBJECT_DETAILS, 
                                    L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, L_LAB);

         
         IF NVL(L_TOARCHIVE_REC.DELETE_FLAG, '0') = '1' THEN
            
            IF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'rq' THEN
               L_RET_CODE := UNAPIRARQ.REMOVERQFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Rq not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'sc' THEN
               L_RET_CODE := UNAPIRASC.REMOVESCFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Sc not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ws' THEN
               L_RET_CODE := UNAPIRAWS.REMOVEWSFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ws not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'sd' THEN
               L_RET_CODE := UNAPIRASD.REMOVESDFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Sd not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ch' THEN
               L_RET_CODE := UNAPIRACH.REMOVECHFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ch not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'st' THEN
               L_RET_CODE := UNAPIRAST.REMOVESTFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'St not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'pp' THEN
               L_RET_CODE := UNAPIRAPP.REMOVEPPFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION,
                                                     L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Pp not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION||
                               '#pp_key1='||L_PP_KEY1||'#pp_key2='||L_PP_KEY2||'#pp_key3='||L_PP_KEY3||
                               '#pp_key4='||L_PP_KEY4||'#pp_key5='||L_PP_KEY5;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ip' THEN
               L_RET_CODE := UNAPIRAIP.REMOVEIPFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ip not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ie' THEN
               L_RET_CODE := UNAPIRAIE.REMOVEIEFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ie not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'pr' THEN
               L_RET_CODE := UNAPIRAPR.REMOVEPRFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Pr not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'mt' THEN
               L_RET_CODE := UNAPIRAMT.REMOVEMTFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Mt not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'eq' THEN
               L_RET_CODE := UNAPIRAEQ.REMOVEEQFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_LAB);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Eq not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#lab='||L_LAB;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'rt' THEN
               L_RET_CODE := UNAPIRART.REMOVERTFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Rt not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'wt' THEN
               L_RET_CODE := UNAPIRAWT.REMOVEWTFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Wt not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'pt' THEN
               L_RET_CODE := UNAPIRAPT.REMOVEPTFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Pt not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'cy' THEN
               L_RET_CODE := UNAPIRACY.REMOVECYFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Cy not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(SUBSTR(L_TOARCHIVE_REC.OBJECT_TP,1,2), ' ') = 'ly' THEN
               L_RET_CODE := UNAPIRALY.REMOVELYFROMDB(L_TOARCHIVE_REC.OBJECT_ID, SUBSTR(L_TOARCHIVE_REC.OBJECT_TP,3));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ly not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(SUBSTR(L_TOARCHIVE_REC.OBJECT_TP,1,2), ' ') = 'lc' THEN
               L_RET_CODE := UNAPIRALC.REMOVELCFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Lc not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(SUBSTR(L_TOARCHIVE_REC.OBJECT_TP,1,2), ' ') = 'gk' THEN
               L_RET_CODE := UNAPIRAGK.REMOVEGKFROMDB(L_TOARCHIVE_REC.OBJECT_ID, SUBSTR(L_TOARCHIVE_REC.OBJECT_TP,3));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Gk not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'jo' THEN
               L_RET_CODE := UNAPIRAJO.REMOVEJOFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Journal not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'au' THEN
               L_RET_CODE := UNAPIRAAU.REMOVEAUFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Au not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'co' THEN
               
               L_RET_CODE := UNAPIRAT3.REMOVETP3FROMDB;
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Co not removed';
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'at' THEN
               
               L_RET_CODE := UNAPIRAAT.REMOVEATFROMDB;
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'At not removed';
                  RAISE STPERROR;
               END IF;
            ELSE
               L_SQLERRM := 'ArchiveToFile: Invalid datatype '||NVL(L_TOARCHIVE_REC.OBJECT_TP,'OBJECT_TP EMPTY')||'#'||
                            NVL(L_TOARCHIVE_REC.OBJECT_ID,'OBJECT_ID EMPTY')||'#'||
                            NVL(L_TOARCHIVE_REC.VERSION,'VERSION EMPTY')||'#'||
                            NVL(L_TOARCHIVE_REC.OBJECT_DETAILS,'OBJECT_DETAILS EMPTY');
               RAISE STPERROR;
            END IF;
         END IF;

         
         UPDATE UTTOARCHIVE
         SET HANDLED_OK = '1'
         WHERE  ARCHIVE_TO              = 'FILE'
            AND ARCHIVE_ID              = L_ARCHIVE_ID
            AND OBJECT_TP               = L_TOARCHIVE_REC.OBJECT_TP
            AND OBJECT_ID               = L_TOARCHIVE_REC.OBJECT_ID
            AND NVL(VERSION,' ')        = NVL(L_TOARCHIVE_REC.VERSION,' ')
            AND NVL(OBJECT_DETAILS,' ') = NVL(L_TOARCHIVE_REC.OBJECT_DETAILS,' ');

         IF SQL%ROWCOUNT = 0 THEN
            L_SQLERRM := 'No record in uttoarchive ! for archive_to=FILE#archive_id='||L_ARCHIVE_ID||
                         '#object_tp='||NVL(L_TOARCHIVE_REC.OBJECT_TP,'OBJECT_TP EMPTY')||
                         '#object_id='||NVL(L_TOARCHIVE_REC.OBJECT_ID,'OBJECT_ID EMPTY')||
                         '#version='||NVL(L_TOARCHIVE_REC.VERSION,'VERSION EMPTY')||
                         '#object_details='||NVL(L_TOARCHIVE_REC.OBJECT_DETAILS,'OBJECT_DETAILS EMPTY');
            RAISE STPERROR;
         END IF;
         
         
         UNAPIGEN.U4COMMIT;
         
         
         CLOSE UNAPIRA.C_TOARCHIVE_CURSOR;
         OPEN UNAPIRA.C_TOARCHIVE_CURSOR('FILE', L_ARCHIVE_ID);
      
      EXCEPTION
      WHEN OTHERS THEN
         IF UNAPIRA.C_TOARCHIVE_CURSOR%ISOPEN THEN
            CLOSE UNAPIRA.C_TOARCHIVE_CURSOR;
         END IF;
         L_PARTIAL_ARCHIVE := TRUE;
         IF SQLCODE <> 1 THEN
            L_SQLERRM := SUBSTR(SQLERRM,1,200);
            UNAPIRA.UTLFILEEXCEPTIONHANDLER('RemoveOnly', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
         ELSIF L_SQLERRM IS NOT NULL THEN
            UNAPIRA.UTLFILEEXCEPTIONHANDLER('RemoveOnly', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
         END IF;
      END;
   END LOOP;
   CLOSE UNAPIRA.C_TOARCHIVE_CURSOR;

   IF L_PARTIAL_ARCHIVE THEN
      UNAPIRA.L_EXCEPTION_STEP := NULL;
      L_SQLERRM := 'Not all objects in archive control table (uttoarchive) have been removed';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('RemoveOnly', L_SQLERRM, 'OTHERS',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   ELSE
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
EXCEPTION
WHEN OTHERS THEN
   IF UNAPIRA.C_TOARCHIVE_CURSOR%ISOPEN THEN
      CLOSE UNAPIRA.C_TOARCHIVE_CURSOR;
   END IF;
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,200);
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('RemoveOnly', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('RemoveOnly', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END REMOVEONLY;


FUNCTION WRITETOFILE                
(A_ARCHIVE_ID    IN VARCHAR2)       
RETURN NUMBER IS
   L_STRING       VARCHAR2(255);
   L_PARTIAL_ARCHIVE    BOOLEAN;

   
   L_PP_KEY1          VARCHAR2(20);
   L_PP_KEY2          VARCHAR2(20);
   L_PP_KEY3          VARCHAR2(20);
   L_PP_KEY4          VARCHAR2(20);
   L_PP_KEY5          VARCHAR2(20);
   L_LAB              VARCHAR2(20);

   CURSOR L_ORACLE_VERSION_CURSOR IS
      SELECT VERSION
        FROM SYS.PRODUCT_COMPONENT_VERSION
       WHERE INSTR(PRODUCT,'Oracle') <> 0;
   L_ORACLE_VERSION_REC L_ORACLE_VERSION_CURSOR%ROWTYPE;
BEGIN
   L_SQLERRM := NULL;
   L_PARTIAL_ARCHIVE := FALSE;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   
   
   
   
   
   OPEN UNAPIRA.C_SYSTEM('ARCHIVE_DIR');
   FETCH UNAPIRA.C_SYSTEM
   INTO UNAPIRA.P_FILE_DIR;
   IF UNAPIRA.C_SYSTEM%NOTFOUND THEN
      CLOSE UNAPIRA.C_SYSTEM;
      RETURN (UNAPIGEN.DBERR_SYSDEFAULTS);
   END IF;
   CLOSE UNAPIRA.C_SYSTEM;

   
   IF A_ARCHIVE_ID IS NULL THEN
      UNAPIRA.P_FILE_NAME := 'u4ar' || TO_CHAR(UNAPIRA.P_CURR_DATE, 'RRMMDD');
   ELSE
      UNAPIRA.P_FILE_NAME := A_ARCHIVE_ID;
   END IF;

   
   IF NOT UNAPIRA.P_DBMS_OUTPUT THEN
      UNAPIRA.L_EXCEPTION_STEP := 'Opening file in write mode directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME;
      UNAPIRA.P_ARCH_FILE_HANDLE := UTL_FILE.FOPEN (UNAPIRA.P_FILE_DIR, UNAPIRA.P_FILE_NAME, 'W');
      UNAPIRA.L_EXCEPTION_STEP := NULL;
   END IF;

   
   
   
   UNAPIRA.L_EXCEPTION_STEP := 'Writing [information] section to file directory='||UNAPIRA.P_FILE_DIR||
                               '#file='||UNAPIRA.P_FILE_NAME;
   UNAPIRA3.U4DATAPUTLINE( '[Information]', '0');
   UNAPIRA3.U4DATAPUTLINE( 'archive_id' || UNAPIRA.P_SEP || UNAPIRA.P_FILE_NAME, '0');
   UNAPIRA3.U4DATAPUTLINE( 'archive_date' || UNAPIRA.P_SEP || UNAPIRA.P_CURR_DATE_STRING, '0');
   
   OPEN UNAPIRA.C_SYSTEM('VERSION');
   FETCH UNAPIRA.C_SYSTEM
   INTO L_STRING;
   IF UNAPIRA.C_SYSTEM%NOTFOUND THEN
      L_STRING := '';
   END IF;
   CLOSE UNAPIRA.C_SYSTEM;
   UNAPIRA3.U4DATAPUTLINE( 'unilab_version' || UNAPIRA.P_SEP || L_STRING, '0');
   UNAPIRA3.U4DATAPUTLINE( 'archiver_version' || UNAPIRA.P_SEP || UNAPIRA.P_ARCHIVER_VERSION, '0');
   UNAPIRA3.U4DATAPUTLINE( 'userid' || UNAPIRA.P_SEP || USER, '0'); 
   
   OPEN L_ORACLE_VERSION_CURSOR;
   FETCH L_ORACLE_VERSION_CURSOR
   INTO L_ORACLE_VERSION_REC;
   IF L_ORACLE_VERSION_CURSOR%NOTFOUND THEN
      L_STRING := 'Undefined ! (not in sys.product_component_version)';
      UNAPIRA3.U4DATAPUTLINE( 'DBMS_version' || UNAPIRA.P_SEP || L_STRING, '0');
   ELSE
      UNAPIRA3.U4DATAPUTLINE( 'DBMS_version' || UNAPIRA.P_SEP || L_ORACLE_VERSION_REC.VERSION, '0');
   END IF;
   CLOSE L_ORACLE_VERSION_CURSOR;
   
   UNAPIRA3.U4DATAPUTLINE( 'LANGUAGE' || UNAPIRA.P_SEP || USERENV('LANGUAGE'), '0');
   
   UNAPIRA3.U4DATAPUTLINE( 'DECIMAL CHARACTER' || UNAPIRA.P_SEP || TO_CHAR(0.0,'D'), '0');
   UNAPIRA3.U4DATAPUTLINE( 'date_format' || UNAPIRA.P_SEP || UNAPIRA.P_TSTZ_FORMAT, '0');
   UNAPIRA3.U4DATAPUTLINE( '', '0');

   
   
   
   UNAPIRA.L_EXCEPTION_STEP := 'Writing [Index] section to file directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME;
   UNAPIRA3.U4DATAPUTLINE( '[Index]', '0');

   
   L_PUTTEXT := 'object_tp' || UNAPIRA.P_SEP || 'object_id' || UNAPIRA.P_SEP || 'object_version' || UNAPIRA.P_SEP || 
                'object_details' || UNAPIRA.P_SEP || 'copy_flag' || UNAPIRA.P_SEP || 'delete_flag' || UNAPIRA.P_SEP || 
                'archive_id' || UNAPIRA.P_SEP || 'archive_to' || UNAPIRA.P_SEP || 'archive_on';
   UNAPIRA3.U4DATAPUTLINE( '[' || L_PUTTEXT || ']', '0');
   FOR L_REC IN UNAPIRA.C_TOARCHIVE_CURSOR('FILE', UNAPIRA.P_FILE_NAME) LOOP
      IF NVL(L_REC.COPY_FLAG, '0') = '1' THEN
         L_PUTTEXT := L_REC.OBJECT_TP || UNAPIRA.P_SEP || L_REC.OBJECT_ID || UNAPIRA.P_SEP  || L_REC.VERSION || 
                      UNAPIRA.P_SEP || L_REC.OBJECT_DETAILS || UNAPIRA.P_SEP || L_REC.COPY_FLAG || 
                      UNAPIRA.P_SEP || L_REC.DELETE_FLAG || UNAPIRA.P_SEP || L_REC.ARCHIVE_ID || 
                      UNAPIRA.P_SEP || L_REC.ARCHIVE_TO || UNAPIRA.P_SEP || TO_CHAR(L_REC.ARCHIVE_ON, UNAPIRA.P_TSTZ_FORMAT);
         UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
      END IF;
   END LOOP;
   
   
   UNAPIRA3.U4DATAPUTLINE( ' ', '0');

   
   
   
   
   UNAPIRA.L_EXCEPTION_STEP := 'Writing [Table structures] section to file directory='||UNAPIRA.P_FILE_DIR||
                               '#file='||UNAPIRA.P_FILE_NAME;
   L_PUTTEXT := '[Table structures]';
   UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   UNAPIRAOP.WRITEOPERATIONALSTRUCTURES;
   UNAPIRACO.WRITECONFIGURATIONSTRUCTURES;
   UNAPIRA3.U4DATAPUTLINE( '', '0');

   
   
   
   UNAPIRA.L_EXCEPTION_STEP := 'Writing [Table structures group keys] section to file directory='||UNAPIRA.P_FILE_DIR||
                               '#file='||UNAPIRA.P_FILE_NAME;
   L_PUTTEXT := '[Table structures group keys]';
   UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');

   
   FOR L_REC IN UNAPIRA.L_ALLSCGK_TABLES_CURSOR LOOP
      IF L_REC.TABLE_NAME = 'utscgk' THEN
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || REPLACE(CONSTANT_ALLSCGKCOLUMNS, ', ', UNAPIRA.P_SEP);
      ELSIF L_REC.TABLE_NAME = 'utscmegk' THEN
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || REPLACE(CONSTANT_ALLSCMEGKCOLUMNS, ', ', UNAPIRA.P_SEP);
      ELSE
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      END IF;
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   FOR L_REC IN UNAPIRA.L_ALLRQGK_TABLES_CURSOR LOOP
      IF L_REC.TABLE_NAME = 'utrqgk' THEN
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || REPLACE(CONSTANT_ALLRQGKCOLUMNS, ', ', UNAPIRA.P_SEP);
      ELSE
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      END IF;
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   FOR L_REC IN UNAPIRA.L_ALLSTGK_TABLES_CURSOR LOOP
      IF L_REC.TABLE_NAME = 'utstgk' THEN
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || REPLACE(CONSTANT_ALLSTGKCOLUMNS, ', ', UNAPIRA.P_SEP);
      ELSE
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      END IF;
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   FOR L_REC IN UNAPIRA.L_ALLRTGK_TABLES_CURSOR LOOP
      IF L_REC.TABLE_NAME = 'utrtgk' THEN
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || REPLACE(CONSTANT_ALLRTGKCOLUMNS, ', ', UNAPIRA.P_SEP);
      ELSE
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      END IF;
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   FOR L_REC IN UNAPIRA.L_ALLWSGK_TABLES_CURSOR LOOP
      IF L_REC.TABLE_NAME = 'utwsgk' THEN
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || REPLACE(CONSTANT_ALLWSGKCOLUMNS, ', ', UNAPIRA.P_SEP);
      ELSE
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      END IF;
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   FOR L_REC IN UNAPIRA.L_ALLSDGK_TABLES_CURSOR LOOP
      IF L_REC.TABLE_NAME = 'utsdgk' THEN
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || REPLACE(CONSTANT_ALLSDGKCOLUMNS, ', ', UNAPIRA.P_SEP);
      ELSE
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      END IF;
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   FOR L_REC IN UNAPIRA.L_ALLPTGK_TABLES_CURSOR LOOP
      IF L_REC.TABLE_NAME = 'utptgk' THEN
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || REPLACE(CONSTANT_ALLPTGKCOLUMNS, ', ', UNAPIRA.P_SEP);
      ELSE
         L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      END IF;
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   UNAPIRA3.U4DATAPUTLINE( '', '0');

   
   
   
   UNAPIRA.L_EXCEPTION_STEP := 'Writing [Table structures custom tables] section to file directory='||UNAPIRA.P_FILE_DIR||
                               '#file='||UNAPIRA.P_FILE_NAME;
   L_PUTTEXT := '[Table structures custom tables]';
   UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   
   FOR L_REC IN UNAPIRA.L_ALLSCCUSTOM_TABLES_CURSOR LOOP
      L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   FOR L_REC IN UNAPIRA.L_ALLRQCUSTOM_TABLES_CURSOR LOOP
      L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   FOR L_REC IN UNAPIRA.L_ALLWSCUSTOM_TABLES_CURSOR LOOP
      L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   FOR L_REC IN UNAPIRA.L_ALLSDCUSTOM_TABLES_CURSOR LOOP
      L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   FOR L_REC IN UNAPIRA.L_ALLCHCUSTOM_TABLES_CURSOR LOOP
      L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   FOR L_REC IN UNAPIRA.L_ALLATCUSTOM_TABLES_CURSOR LOOP
      L_PUTTEXT := L_REC.TABLE_NAME || UNAPIRA.P_SEP || LISTALLCOLUMNS(L_REC.TABLE_NAME);
      UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');
   END LOOP;
   UNAPIRA3.U4DATAPUTLINE( '', '0');

   
   
   
   UNAPIRA.L_EXCEPTION_STEP := 'Writing [Table data] section to file directory='||UNAPIRA.P_FILE_DIR||
                               '#file='||UNAPIRA.P_FILE_NAME;
   L_PUTTEXT := '[Table data]';
   U4DATAPUTLINE(L_PUTTEXT, '0');
   FOR L_TOARCHIVE_REC IN UNAPIRA.C_TOARCHIVE_CURSOR('FILE', UNAPIRA.P_FILE_NAME) LOOP
      BEGIN
         
         UNAPIRA.PARSEOBJECTDETAILS(L_TOARCHIVE_REC.OBJECT_DETAILS, 
                                    L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5, L_LAB);

         
         
         
         IF NVL(L_TOARCHIVE_REC.COPY_FLAG, '0') = '1' THEN
            
            IF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'rq' THEN
               L_PUTTEXT := '['|| L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID ||']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRARQ.ARCHIVERQTOFILE(L_TOARCHIVE_REC.OBJECT_ID);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Rq not archived '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'sc' THEN
               L_PUTTEXT := '['|| L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID ||']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRASC.ARCHIVESCTOFILE(L_TOARCHIVE_REC.OBJECT_ID);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Sc not archived '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ws' THEN
               L_PUTTEXT := '['|| L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID ||']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAWS.ARCHIVEWSTOFILE(L_TOARCHIVE_REC.OBJECT_ID);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ws not archived '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'sd' THEN
               L_PUTTEXT := '['|| L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID ||']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRASD.ARCHIVESDTOFILE(L_TOARCHIVE_REC.OBJECT_ID);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Sd not archived '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ch' THEN
               L_PUTTEXT := '['|| L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID ||']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRACH.ARCHIVECHTOFILE(L_TOARCHIVE_REC.OBJECT_ID);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ch not archived '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'st' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAST.ARCHIVESTTOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'St not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'wt' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAWT.ARCHIVEWTTOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Wt not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
              END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'pp' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || L_SEP || L_PP_KEY1 || L_SEP || L_PP_KEY2 || 
                            L_SEP || L_PP_KEY3 || L_SEP || L_PP_KEY4 || L_SEP || L_PP_KEY5 || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAPP.ARCHIVEPPTOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION,
                                                      L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Pp not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION||
                               '#pp_key1='||L_PP_KEY1||'#pp_key2='||L_PP_KEY2||'#pp_key3='||L_PP_KEY3||
                               '#pp_key4='||L_PP_KEY4||'#pp_key5='||L_PP_KEY5;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ip' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAIP.ARCHIVEIPTOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ip not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ie' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAIE.ARCHIVEIETOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ie not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'pr' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAPR.ARCHIVEPRTOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Pr not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'mt' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAMT.ARCHIVEMTTOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Mt not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'eq' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || L_SEP || L_LAB || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAEQ.ARCHIVEEQTOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_LAB);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Eq not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#lab='||L_LAB;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'rt' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRART.ARCHIVERTTOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Rt not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'pt' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAPT.ARCHIVEPTTOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Pt not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'cy' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRACY.ARCHIVECYTOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Cy not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'au' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAAU.ARCHIVEAUTOFILE(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Au not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'lc' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRALC.ARCHIVELCTOFILE(L_TOARCHIVE_REC.OBJECT_ID);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Lc not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(SUBSTR(L_TOARCHIVE_REC.OBJECT_TP, 1, 2), ' ') = 'ly' THEN
               L_PUTTEXT := '['|| L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID ||']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRALY.ARCHIVELYTOFILE(L_TOARCHIVE_REC.OBJECT_ID, SUBSTR(L_TOARCHIVE_REC.OBJECT_TP, 3));
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ly not archived '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(SUBSTR(L_TOARCHIVE_REC.OBJECT_TP, 1, 2), ' ') = 'gk' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || 
                            L_SEP || L_TOARCHIVE_REC.VERSION || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAGK.ARCHIVEGKTOFILE(L_TOARCHIVE_REC.OBJECT_ID, SUBSTR(L_TOARCHIVE_REC.OBJECT_TP, 3));
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Gk not archived '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'jo' THEN
               L_PUTTEXT := '[' || L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID || ']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAJO.ARCHIVEJOTOFILE(L_TOARCHIVE_REC.OBJECT_ID);
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Jo not archived '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
              END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'co' THEN
               L_PUTTEXT := '['|| L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID ||']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAT3.ARCHIVETP3TOFILE;
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Co not archived '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'at' THEN
               L_PUTTEXT := '['|| L_TOARCHIVE_REC.OBJECT_TP || L_SEP || L_TOARCHIVE_REC.OBJECT_ID ||']';
               U4DATAPUTLINE(L_PUTTEXT, '0');
               
               
               L_RET_CODE := UNAPIRAAT.ARCHIVEATTOFILE;
               
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'At not archived '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSE
               L_SQLERRM := 'Invalid datatype '||NVL(L_TOARCHIVE_REC.OBJECT_TP,'OBJECT_TP EMPTY')||'#'||
                            NVL(L_TOARCHIVE_REC.OBJECT_ID,'OBJECT_ID EMPTY')||'#'||
                            NVL(L_TOARCHIVE_REC.VERSION,'VERSION EMPTY')||'#'||
                            NVL(L_TOARCHIVE_REC.OBJECT_DETAILS,'OBJECT_DETAILS EMPTY');
               RAISE STPERROR;
            END IF;
         END IF;

         
         
         
         IF NVL(L_TOARCHIVE_REC.DELETE_FLAG, '0') = '1' THEN
            
            IF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'rq' THEN
               L_RET_CODE := UNAPIRARQ.REMOVERQFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Rq not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'sc' THEN
               L_RET_CODE := UNAPIRASC.REMOVESCFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Sc not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ws' THEN
               L_RET_CODE := UNAPIRAWS.REMOVEWSFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ws not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'sd' THEN
               L_RET_CODE := UNAPIRASD.REMOVESDFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Sd not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ch' THEN
               L_RET_CODE := UNAPIRACH.REMOVECHFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ch not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'st' THEN
               L_RET_CODE := UNAPIRAST.REMOVESTFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'St not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'pp' THEN
               L_RET_CODE := UNAPIRAPP.REMOVEPPFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION,
                                                     L_PP_KEY1, L_PP_KEY2, L_PP_KEY3, L_PP_KEY4, L_PP_KEY5);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Pp not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION||
                               '#pp_key1='||L_PP_KEY1||'#pp_key2='||L_PP_KEY2||'#pp_key3='||L_PP_KEY3||
                               '#pp_key4='||L_PP_KEY4||'#pp_key5='||L_PP_KEY5;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ip' THEN
               L_RET_CODE := UNAPIRAIP.REMOVEIPFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ip not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'ie' THEN
               L_RET_CODE := UNAPIRAIE.REMOVEIEFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ie not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'pr' THEN
               L_RET_CODE := UNAPIRAPR.REMOVEPRFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Pr not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'mt' THEN
               L_RET_CODE := UNAPIRAMT.REMOVEMTFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Mt not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'eq' THEN
               L_RET_CODE := UNAPIRAEQ.REMOVEEQFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_LAB);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Eq not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#lab='||L_LAB;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'rt' THEN
               L_RET_CODE := UNAPIRART.REMOVERTFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Rt not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'wt' THEN
               L_RET_CODE := UNAPIRAWT.REMOVEWTFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Wt not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'pt' THEN
               L_RET_CODE := UNAPIRAPT.REMOVEPTFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Pt not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'cy' THEN
               L_RET_CODE := UNAPIRACY.REMOVECYFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Cy not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'lc' THEN
               L_RET_CODE := UNAPIRALC.REMOVELCFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Lc not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(SUBSTR(L_TOARCHIVE_REC.OBJECT_TP,1,2), ' ') = 'ly' THEN
               L_RET_CODE := UNAPIRALY.REMOVELYFROMDB(L_TOARCHIVE_REC.OBJECT_ID, SUBSTR(L_TOARCHIVE_REC.OBJECT_TP,3));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Ly not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(SUBSTR(L_TOARCHIVE_REC.OBJECT_TP,1,2), ' ') = 'gk' THEN
               L_RET_CODE := UNAPIRAGK.REMOVEGKFROMDB(L_TOARCHIVE_REC.OBJECT_ID, SUBSTR(L_TOARCHIVE_REC.OBJECT_TP,3));
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Gk not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'jo' THEN
               L_RET_CODE := UNAPIRAJO.REMOVEJOFROMDB(L_TOARCHIVE_REC.OBJECT_ID);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Jo not removed '||L_TOARCHIVE_REC.OBJECT_ID;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'au' THEN
               L_RET_CODE := UNAPIRAAU.REMOVEAUFROMDB(L_TOARCHIVE_REC.OBJECT_ID, L_TOARCHIVE_REC.VERSION);
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Au not removed '||L_TOARCHIVE_REC.OBJECT_ID||'#version='||L_TOARCHIVE_REC.VERSION;
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'co' THEN
               
               L_RET_CODE := UNAPIRAT3.REMOVETP3FROMDB;
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'Co not removed ';
                  RAISE STPERROR;
               END IF;
            ELSIF NVL(L_TOARCHIVE_REC.OBJECT_TP, ' ') = 'at' THEN
               
               L_RET_CODE := UNAPIRAAT.REMOVEATFROMDB;
               IF L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS THEN
                  L_SQLERRM := 'At not removed ';
                  RAISE STPERROR;
               END IF;
            ELSE
               L_SQLERRM := 'ArchiveToFile: Invalid datatype'||NVL(L_TOARCHIVE_REC.OBJECT_TP,'OBJECT_TP EMPTY')||'#'||
                            NVL(L_TOARCHIVE_REC.OBJECT_ID,'OBJECT_ID EMPTY')||'#'||
                            NVL(L_TOARCHIVE_REC.VERSION,'VERSION EMPTY')||'#'||
                            NVL(L_TOARCHIVE_REC.OBJECT_DETAILS,'OBJECT_DETAILS EMPTY');
               RAISE STPERROR;
            END IF;
         END IF;

         
         UPDATE UTTOARCHIVE
         SET HANDLED_OK = '1'
         WHERE ARCHIVE_TO              = 'FILE'
           AND ARCHIVE_ID              = UNAPIRA.P_FILE_NAME
           AND OBJECT_TP               = L_TOARCHIVE_REC.OBJECT_TP
           AND OBJECT_ID               = L_TOARCHIVE_REC.OBJECT_ID
           AND NVL(VERSION,' ')        = NVL(L_TOARCHIVE_REC.VERSION,' ')
           AND NVL(OBJECT_DETAILS,' ') = NVL(L_TOARCHIVE_REC.OBJECT_DETAILS,' ');

         IF SQL%ROWCOUNT = 0 THEN
            L_SQLERRM := 'No record in uttoarchive ! for archive_to=FILE#archive_id='||UNAPIRA.P_FILE_NAME||
                         '#object_tp='||NVL(L_TOARCHIVE_REC.OBJECT_TP,'OBJECT_TP EMPTY')||
                         '#object_id='||NVL(L_TOARCHIVE_REC.OBJECT_ID,'OBJECT_ID EMPTY')||
                         '#version='||NVL(L_TOARCHIVE_REC.VERSION,'VERSION EMPTY')||
                         '#object_details='||NVL(L_TOARCHIVE_REC.OBJECT_DETAILS,'OBJECT_DETAILS EMPTY');
            RAISE STPERROR;
         END IF;
         
         
         
         UNAPIGEN.U4COMMIT;
      
      EXCEPTION
      WHEN UTL_FILE.INVALID_PATH THEN
         L_PARTIAL_ARCHIVE := TRUE;
         L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
      WHEN UTL_FILE.INVALID_MODE THEN
         L_PARTIAL_ARCHIVE := TRUE;
         L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
      WHEN UTL_FILE.INVALID_FILEHANDLE THEN
         L_PARTIAL_ARCHIVE := TRUE;
         L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
      WHEN UTL_FILE.INVALID_OPERATION THEN
         
         L_PARTIAL_ARCHIVE := TRUE;
         L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
      WHEN UTL_FILE.READ_ERROR THEN
         L_PARTIAL_ARCHIVE := TRUE;
         L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
      WHEN UTL_FILE.WRITE_ERROR THEN
         L_PARTIAL_ARCHIVE := TRUE;
         L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
      WHEN UTL_FILE.INTERNAL_ERROR THEN
         L_PARTIAL_ARCHIVE := TRUE;
         L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
      WHEN OTHERS THEN
         L_PARTIAL_ARCHIVE := TRUE;
         IF SQLCODE <> 1 THEN
            L_SQLERRM := SUBSTR(SQLERRM,1,200);
            UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
         ELSIF L_SQLERRM IS NOT NULL THEN
            UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
         END IF;
         
      END;
   END LOOP;

   L_PUTTEXT := '[End of File]';
   UNAPIRA3.U4DATAPUTLINE( L_PUTTEXT, '0');

   
   IF NOT UNAPIRA.P_DBMS_OUTPUT THEN
      UTL_FILE.FCLOSE(UNAPIRA.P_ARCH_FILE_HANDLE);
   END IF;

   IF L_PARTIAL_ARCHIVE THEN
      UNAPIRA.L_EXCEPTION_STEP := NULL;
      L_SQLERRM := 'Not all objects in archive control table (uttoarchive) have been archived';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'OTHERS',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   ELSE
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
EXCEPTION
WHEN UTL_FILE.INVALID_PATH THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_NOOBJECT);
WHEN UTL_FILE.INVALID_MODE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
WHEN UTL_FILE.INVALID_FILEHANDLE THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
WHEN UTL_FILE.INVALID_OPERATION THEN
   
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_NOOBJECT);
WHEN UTL_FILE.READ_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
WHEN UTL_FILE.WRITE_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
WHEN UTL_FILE.INTERNAL_ERROR THEN
   L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
   UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      L_SQLERRM := SUBSTR(SQLERRM,1,200);
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   ELSIF L_SQLERRM IS NOT NULL THEN
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('WriteToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END WRITETOFILE;







PROCEDURE U4DATAPUTLINE              
 (A_TEXT      IN   VARCHAR2,         
  A_DATA_ROW  IN   CHAR)              
IS
   L_SEP_POS     INTEGER;
   L_TABLE_NAME  VARCHAR2(30);
   L_FROM        INTEGER;
   L_WRITE_TEXT  VARCHAR2(2000);
   L_FULL_TEXT   VARCHAR2(11000); 
                                  
                                  
                                  
BEGIN
   
   
   
   
   

   IF A_DATA_ROW = '1' THEN
      L_FULL_TEXT := REPLACE(
                        REPLACE(
                           REPLACE(
                              REPLACE(
                                 REPLACE(A_TEXT,'''',''''''),
                                 CHR(13),
                                 UNAPIRA.P_REPL_CR
                                ),
                              CHR(10),
                              UNAPIRA.P_REPL_LF
                             ),
                           CHR(9), 
                           '<TAB>'
                          ),
                        UNAPIRA.P_INTERNAL_SEP,UNAPIRA.P_SEP
                       );
   ELSE
      L_FULL_TEXT := REPLACE(A_TEXT,UNAPIRA.P_INTERNAL_SEP,UNAPIRA.P_SEP);
   END IF;
   
   IF UNAPIRA.P_DBMS_OUTPUT THEN
      IF LENGTH(L_FULL_TEXT) <= 255 THEN
         L_PUTTEXT := L_FULL_TEXT;
         UNAPIRA.L_EXCEPTION_STEP := 'Writing table data to DBMS_OUTPUT, length='||TO_CHAR(LENGTH(L_PUTTEXT));
         
         
         DBMS_OUTPUT.PUT_LINE(L_PUTTEXT);
         UNAPIRA.L_EXCEPTION_STEP := NULL;
      ELSE
         
         UNAPIRA.L_EXCEPTION_STEP := 'splitting data before writing to dbms_output';
         L_SEP_POS := INSTR(L_FULL_TEXT, UNAPIRA.P_SEP, 1, 1);
         L_TABLE_NAME := SUBSTR(L_FULL_TEXT, 1, L_SEP_POS-1); 
         L_FROM := L_SEP_POS+1;
         
         LOOP
            IF LENGTH(SUBSTR(L_FULL_TEXT,L_FROM))+LENGTH(L_TABLE_NAME)+2 > 205 THEN
               L_WRITE_TEXT := L_TABLE_NAME || '*' || UNAPIRA.P_SEP || SUBSTR(L_FULL_TEXT, L_FROM, 205);
               L_FROM := L_FROM + 205;
            ELSE
               L_WRITE_TEXT := L_TABLE_NAME || UNAPIRA.P_SEP || SUBSTR(L_FULL_TEXT, L_FROM);
               L_FROM := NULL;
            END IF;

            UNAPIRA.L_EXCEPTION_STEP := 'Splitted data writing to file, length='||TO_CHAR(LENGTH(L_WRITE_TEXT))||
                                        '#table_name='||L_TABLE_NAME;
            DBMS_OUTPUT.PUT_LINE( L_WRITE_TEXT);
            UNAPIRA.L_EXCEPTION_STEP := NULL;

            EXIT WHEN L_FROM IS NULL;
         END LOOP;
      END IF;
   ELSE
      IF LENGTH(L_FULL_TEXT) <= 1000 THEN
         L_PUTTEXT := L_FULL_TEXT;
         UNAPIRA.L_EXCEPTION_STEP := 'Writing table data to file, length='||TO_CHAR(LENGTH(L_PUTTEXT));
         
         
         UTL_FILE.PUT_LINE(UNAPIRA.P_ARCH_FILE_HANDLE, L_PUTTEXT);
         UNAPIRA.L_EXCEPTION_STEP := NULL;
      ELSE
         
         UNAPIRA.L_EXCEPTION_STEP := 'splitting data before writing to file';
         L_SEP_POS := INSTR(L_FULL_TEXT, UNAPIRA.P_SEP, 1, 1);
         L_TABLE_NAME := SUBSTR(L_FULL_TEXT, 1, L_SEP_POS-1); 
         L_FROM := L_SEP_POS+1;
         LOOP
            IF LENGTH(SUBSTR(L_FULL_TEXT,L_FROM))+LENGTH(L_TABLE_NAME)+2 > 950 THEN
               L_WRITE_TEXT := L_TABLE_NAME || '*' || UNAPIRA.P_SEP || SUBSTR(L_FULL_TEXT, L_FROM, 950);
               L_FROM := L_FROM + 950;
            ELSE
               L_WRITE_TEXT := L_TABLE_NAME || UNAPIRA.P_SEP || SUBSTR(L_FULL_TEXT, L_FROM);
               L_FROM := NULL;
            END IF;

            UNAPIRA.L_EXCEPTION_STEP := 'Splitted data writing to file, length='||TO_CHAR(LENGTH(L_WRITE_TEXT))||
                                        '#table_name='||L_TABLE_NAME;
            UTL_FILE.PUT_LINE(UNAPIRA.P_ARCH_FILE_HANDLE, L_WRITE_TEXT);
            UNAPIRA.L_EXCEPTION_STEP := NULL;

            EXIT WHEN L_FROM IS NULL;
         END LOOP;
      END IF;
   END IF;
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataPutLine', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   WHEN UTL_FILE.INVALID_MODE THEN
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataPutLine', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataPutLine', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataPutLine', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   WHEN UTL_FILE.READ_ERROR THEN
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataPutLine', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   WHEN UTL_FILE.WRITE_ERROR THEN
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataPutLine', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataPutLine', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataPutLine', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('U4DataPutLine', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_DO_NOT_CLOSE_CURSOR);
   END IF;
END U4DATAPUTLINE;


FUNCTION ARCHIVESTGKTOFILE                 
(A_ST IN VARCHAR2,                         
 A_VERSION IN VARCHAR2)                    
RETURN NUMBER IS
   L_ST                VARCHAR2(20);
   L_VERSION           VARCHAR2(20);
   L_GK                VARCHAR2(20);
   L_GK_VERSION        VARCHAR2(20);
   L_GKSEQ             NUMBER(3);
   L_VALUE             VARCHAR2(40);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;
   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLSTGK_TABLES_CURSOR LOOP
      IF L_TABLE_REC.TABLE_NAME = 'utstgk' THEN
          L_SQL_STRING := 'SELECT '||CONSTANT_ALLSTGKCOLUMNS||' FROM '||L_TABLE_REC.TABLE_NAME||' '||
                          'WHERE st=:a_st AND version=:a_version';
          DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
          DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st', A_ST);
          DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_version', A_VERSION);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_ST, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_VERSION, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_GK, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 4, L_GK_VERSION, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 5, L_GKSEQ);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 6, L_VALUE, 40);
          L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

          LOOP
             EXIT WHEN L_RESULT = 0;

             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_ST);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_VERSION);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_GK);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 4, L_GK_VERSION);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 5, L_GKSEQ);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 6, L_VALUE);
             L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_ST || L_SEP || L_VERSION || L_SEP || 
                          L_GK || L_SEP || L_GK_VERSION || L_SEP || L_GKSEQ || L_SEP || L_VALUE;

             UNAPIRA.L_EXCEPTION_STEP := 'Writing utstgk record to file';
             U4DATAPUTLINE(L_PUTTEXT);
             UNAPIRA.L_EXCEPTION_STEP := NULL;

             L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
          END LOOP;
      ELSE
         IF SUBSTR(L_TABLE_REC.TABLE_NAME,1,6) = 'utstgk' THEN
             L_SQL_STRING := 'SELECT '|| SUBSTR(L_TABLE_REC.TABLE_NAME,7) ||
                             ', st, version FROM '||L_TABLE_REC.TABLE_NAME||' '||
                             'WHERE st=:a_st AND version=:a_version';
             DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
             DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_st', A_ST);
             DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_version', A_VERSION);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_VALUE, 40);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_ST, 20);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_VERSION, 20);
             L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

             LOOP
                EXIT WHEN L_RESULT = 0;

                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_VALUE);
                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_ST);
                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_VERSION);

                L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_VALUE || L_SEP || L_ST || L_SEP || L_VERSION;

                UNAPIRA.L_EXCEPTION_STEP := 'Writing '||L_TABLE_REC.TABLE_NAME||' record to file';
                U4DATAPUTLINE(L_PUTTEXT);
                UNAPIRA.L_EXCEPTION_STEP := NULL;

                L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
             END LOOP;
         END IF;
      END IF;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStGkToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStGkToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveStGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVESTGKTOFILE;


FUNCTION ARCHIVERTGKTOFILE        
(A_RT      IN VARCHAR2,           
 A_VERSION IN VARCHAR2)            
RETURN NUMBER IS
   L_RT                VARCHAR2(20);
   L_VERSION           VARCHAR2(20);
   L_GK                VARCHAR2(20);
   L_GK_VERSION        VARCHAR2(20);
   L_GKSEQ             NUMBER(3);
   L_VALUE             VARCHAR2(40);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLRTGK_TABLES_CURSOR LOOP
      IF L_TABLE_REC.TABLE_NAME = 'utrtgk' THEN
          L_SQL_STRING := 'SELECT '||CONSTANT_ALLRTGKCOLUMNS||' FROM '||L_TABLE_REC.TABLE_NAME||' '||
                          'WHERE rt=:a_rt AND version=:a_version';
          DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
          DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_rt', A_RT);
          DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_version', A_VERSION);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_RT, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_VERSION, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_GK, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 4, L_GK_VERSION, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 5, L_GKSEQ);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 6, L_VALUE, 40);
          L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

          LOOP
             EXIT WHEN L_RESULT = 0;

             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_RT);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_VERSION);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_GK);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 4, L_GK_VERSION);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 5, L_GKSEQ);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 6, L_VALUE);
             L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_RT || L_SEP ||L_VERSION || L_SEP || 
                          L_GK || L_SEP || L_GK_VERSION || L_SEP || L_GKSEQ || L_SEP || L_VALUE;

             UNAPIRA.L_EXCEPTION_STEP := 'Writing utrtgk record to file';
             U4DATAPUTLINE(L_PUTTEXT);
             UNAPIRA.L_EXCEPTION_STEP := NULL;

             L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
          END LOOP;
      ELSE
         IF SUBSTR(L_TABLE_REC.TABLE_NAME,1,6) = 'utrtgk' THEN
             L_SQL_STRING := 'SELECT '|| SUBSTR(L_TABLE_REC.TABLE_NAME,7) ||
                             ', rt, version FROM '||L_TABLE_REC.TABLE_NAME||' '||
                             'WHERE rt=:a_rt and version=:a_version';
             DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
             DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_rt', A_RT);
             DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_version', A_VERSION);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_VALUE, 40);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_RT, 20);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_VERSION, 20);
             L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

             LOOP
                EXIT WHEN L_RESULT = 0;

                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_VALUE);
                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_RT);
                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_VERSION);

                L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_VALUE || L_SEP || L_RT|| L_SEP || L_VERSION;

                UNAPIRA.L_EXCEPTION_STEP := 'Writing '||L_TABLE_REC.TABLE_NAME||' record to file';
                U4DATAPUTLINE(L_PUTTEXT);
                UNAPIRA.L_EXCEPTION_STEP := NULL;

                L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
             END LOOP;
         END IF;
      END IF;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRtGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRtGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRtGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRtGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRtGkToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRtGkToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRtGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRtGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRtGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVERTGKTOFILE;


FUNCTION ARCHIVESCGKTOFILE        
(A_SC IN VARCHAR2)                
RETURN NUMBER IS
   L_SC                VARCHAR2(20);
   L_PG                VARCHAR2(20);
   L_PGNODE            NUMBER(9);
   L_PA                VARCHAR2(20);
   L_PANODE            NUMBER(9);
   L_ME                VARCHAR2(20);
   L_MENODE            NUMBER(9);
   L_GK                VARCHAR2(20);
   L_GK_VERSION        VARCHAR2(20);
   L_GKSEQ             NUMBER(3);
   L_VALUE             VARCHAR2(40);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLSCGK_TABLES_CURSOR LOOP
      IF L_TABLE_REC.TABLE_NAME = 'utscgk' THEN
          L_SQL_STRING := 'SELECT '||CONSTANT_ALLSCGKCOLUMNS||' FROM '||L_TABLE_REC.TABLE_NAME||' '||
                          'WHERE sc=:a_sc';
          DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
          DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_sc', A_SC);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_SC, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_GK, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_GK_VERSION, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 4, L_GKSEQ);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 5, L_VALUE, 40);
          L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

          LOOP
             EXIT WHEN L_RESULT = 0;

             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_SC);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_GK);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_GK_VERSION);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 4, L_GKSEQ);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 5, L_VALUE);

             L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_SC || L_SEP || 
                          L_GK || L_SEP || L_GK_VERSION || L_SEP || L_GKSEQ || L_SEP || L_VALUE;

             UNAPIRA.L_EXCEPTION_STEP := 'Writing utscgk record to file';
             U4DATAPUTLINE(L_PUTTEXT);
             UNAPIRA.L_EXCEPTION_STEP := NULL;

             L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
          END LOOP;
      ELSIF L_TABLE_REC.TABLE_NAME = 'utscmegk' THEN
         L_SQL_STRING := 'SELECT '||CONSTANT_ALLSCMEGKCOLUMNS||' FROM '
                         ||L_TABLE_REC.TABLE_NAME||' WHERE sc=:a_sc';
         DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_sc', A_SC);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_SC, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_PG, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_PGNODE);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 4, L_PA, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 5, L_PANODE);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 6, L_ME, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 7, L_MENODE);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 8, L_GK, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 9, L_GK_VERSION, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 10, L_GKSEQ);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 11, L_VALUE, 40);
         L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

         LOOP
            EXIT WHEN L_RESULT = 0;

            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_SC);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_PG);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_PGNODE);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 4, L_PA);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 5, L_PANODE);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 6, L_ME);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 7, L_MENODE);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 8, L_GK);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 9, L_GK_VERSION);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 10, L_GKSEQ);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 11, L_VALUE);

            L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP ||
            L_SC || L_SEP ||
            L_PG || L_SEP || L_PGNODE || L_SEP ||
            L_PA || L_SEP || L_PANODE || L_SEP ||
            L_ME || L_SEP || L_MENODE || L_SEP ||
            L_GK || L_SEP || L_GK_VERSION || L_SEP ||
            L_GKSEQ || L_SEP || L_VALUE;

            UNAPIRA.L_EXCEPTION_STEP := 'Writing utscmegk record to file';
            U4DATAPUTLINE(L_PUTTEXT);
            UNAPIRA.L_EXCEPTION_STEP := NULL;

            L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
         END LOOP;
      ELSE
         IF SUBSTR(L_TABLE_REC.TABLE_NAME,1,6) = 'utscgk' THEN
             L_SQL_STRING := 'SELECT '|| SUBSTR(L_TABLE_REC.TABLE_NAME,7) ||
                             ', sc FROM '||L_TABLE_REC.TABLE_NAME||' '||
                             'WHERE sc=:a_sc';
             DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
             DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_sc', A_SC);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_VALUE, 40);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_SC, 20);
             L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

             LOOP
                EXIT WHEN L_RESULT = 0;

                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_VALUE);
                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_SC);

                L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_VALUE || L_SEP || L_SC;

                UNAPIRA.L_EXCEPTION_STEP := 'Writing '||L_TABLE_REC.TABLE_NAME||' record to file';
                U4DATAPUTLINE(L_PUTTEXT);
                UNAPIRA.L_EXCEPTION_STEP := NULL;

                L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
             END LOOP;
         ELSIF SUBSTR(L_TABLE_REC.TABLE_NAME,1,8) = 'utscmegk' THEN
            L_SQL_STRING := 'SELECT '|| SUBSTR(L_TABLE_REC.TABLE_NAME,9) ||
                            ', sc, pg, pgnode, pa, panode, me, menode FROM '
                            ||L_TABLE_REC.TABLE_NAME||' WHERE sc=:a_sc';
            DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
            DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_sc', A_SC);
            DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_VALUE, 40);
            DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_SC, 20);
            DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_PG, 20);
            DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 4, L_PGNODE);
            DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 5, L_PA, 20);
            DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 6, L_PANODE);
            DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 7, L_ME, 20);
            DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 8, L_MENODE);
            L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

            LOOP
               EXIT WHEN L_RESULT = 0;

               DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_VALUE);
               DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_SC);
               DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_PG);
               DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 4, L_PGNODE);
               DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 5, L_PA);
               DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 6, L_PANODE);
               DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 7, L_ME);
               DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 8, L_MENODE);

               L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_VALUE || L_SEP || L_SC || L_SEP ||
                            L_PG || L_SEP || L_PGNODE || L_SEP || L_PA || L_SEP || L_PANODE || L_SEP ||
                            L_ME || L_SEP || L_MENODE ;

               UNAPIRA.L_EXCEPTION_STEP := 'Writing '||L_TABLE_REC.TABLE_NAME||' record to file';
               U4DATAPUTLINE(L_PUTTEXT);
               UNAPIRA.L_EXCEPTION_STEP := NULL;

               L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
            END LOOP;
         END IF;
      END IF;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScGkToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScGkToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVESCGKTOFILE;


FUNCTION ARCHIVESCCUSTOMTOFILE    
(A_SC IN VARCHAR2)                
RETURN NUMBER IS
   L_SEP_STRING  VARCHAR2(20);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_SEP_STRING := '||CHR('||ASCII(L_SEP)||')||';

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLSCCUSTOM_TABLES_CURSOR LOOP
      L_SQL_STRING := 'SELECT ';

      FOR L_COLUMNS_REC IN UNAPIRA.L_USER_TAB_COLUMNS_CURSOR(L_TABLE_REC.TABLE_NAME) LOOP
         IF L_COLUMNS_REC.DATA_TYPE IN ('VARCHAR2','CHAR') THEN
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING;
         ELSIF L_COLUMNS_REC.DATA_TYPE IN ('FLOAT','NUMBER') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' ||L_COLUMNS_REC.COLUMN_NAME || ')' || L_SEP_STRING;
         ELSIF (SUBSTR(L_COLUMNS_REC.DATA_TYPE,1,9) = 'TIMESTAMP') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' ||L_COLUMNS_REC.COLUMN_NAME || ',''' ||
                            UNAPIRA.P_TSTZ_FORMAT || ''')' || L_SEP_STRING;
         ELSE
            
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING;
         END IF;
      END LOOP;

      
      L_SQL_STRING := SUBSTR(L_SQL_STRING, 1, LENGTH(L_SQL_STRING)-(LENGTH(L_SEP_STRING)));

      L_SQL_STRING := L_SQL_STRING||' FROM '||L_TABLE_REC.TABLE_NAME||' WHERE sc=:a_sc';

      DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_sc', A_SC);
      DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_PUTTEXT, 4000);
      L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

      LOOP
         EXIT WHEN L_RESULT = 0;

         DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_PUTTEXT);

         L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_PUTTEXT ;

         UNAPIRA.L_EXCEPTION_STEP := 'Writing atsc... record to file';
         U4DATAPUTLINE(L_PUTTEXT);
         UNAPIRA.L_EXCEPTION_STEP := NULL;

         L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
      END LOOP;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScCustomToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScCustomToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVESCCUSTOMTOFILE;


FUNCTION ARCHIVEWSGKTOFILE        
(A_WS IN VARCHAR2)                
RETURN NUMBER IS
   L_WS                VARCHAR2(20);
   L_PG                VARCHAR2(20);
   L_PGNODE            NUMBER(9);
   L_PA                VARCHAR2(20);
   L_PANODE            NUMBER(9);
   L_ME                VARCHAR2(20);
   L_MENODE            NUMBER(9);
   L_GK                VARCHAR2(20);
   L_GK_VERSION        VARCHAR2(20);
   L_GKSEQ             NUMBER(3);
   L_VALUE             VARCHAR2(40);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLWSGK_TABLES_CURSOR LOOP
      IF L_TABLE_REC.TABLE_NAME = 'utwsgk' THEN
          L_SQL_STRING := 'SELECT '||CONSTANT_ALLWSGKCOLUMNS||' FROM '||L_TABLE_REC.TABLE_NAME||' '||
                          'WHERE ws=:a_ws';
          DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
          DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_ws', A_WS);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_WS, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_GK, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_GK_VERSION, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 4, L_GKSEQ);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 5, L_VALUE, 40);
          L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

          LOOP
             EXIT WHEN L_RESULT = 0;

             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_WS);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_GK);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_GK_VERSION);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 4, L_GKSEQ);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 5, L_VALUE);

             L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_WS || L_SEP || 
                          L_GK || L_SEP || L_GK_VERSION || L_SEP || L_GKSEQ || L_SEP || L_VALUE;

             UNAPIRA.L_EXCEPTION_STEP := 'Writing utwsgk record to file';
             U4DATAPUTLINE(L_PUTTEXT);
             UNAPIRA.L_EXCEPTION_STEP := NULL;

             L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
          END LOOP;
      ELSE
         IF SUBSTR(L_TABLE_REC.TABLE_NAME,1,6) = 'utwsgk' THEN
             L_SQL_STRING := 'SELECT '|| SUBSTR(L_TABLE_REC.TABLE_NAME,7) ||
                             ', ws FROM '||L_TABLE_REC.TABLE_NAME||' '||
                             'WHERE ws=:a_ws';
             DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
             DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_ws', A_WS);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_VALUE, 40);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_WS, 20);
             L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

             LOOP
                EXIT WHEN L_RESULT = 0;

                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_VALUE);
                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_WS);

                L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_VALUE || L_SEP || L_WS;

                UNAPIRA.L_EXCEPTION_STEP := 'Writing '||L_TABLE_REC.TABLE_NAME||' record to file';
                U4DATAPUTLINE(L_PUTTEXT);
                UNAPIRA.L_EXCEPTION_STEP := NULL;

                L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
             END LOOP;
         END IF;
      END IF;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsGkToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsGkToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVEWSGKTOFILE;


FUNCTION ARCHIVEWSCUSTOMTOFILE    
(A_WS IN VARCHAR2)                
RETURN NUMBER IS
   L_SEP_STRING  VARCHAR2(20);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_SEP_STRING := '||CHR('||ASCII(L_SEP)||')||';

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLWSCUSTOM_TABLES_CURSOR LOOP
      L_SQL_STRING := 'SELECT ';

      FOR L_COLUMNS_REC IN UNAPIRA.L_USER_TAB_COLUMNS_CURSOR(L_TABLE_REC.TABLE_NAME) LOOP
         IF L_COLUMNS_REC.DATA_TYPE IN ('VARCHAR2','CHAR') THEN
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING;
         ELSIF L_COLUMNS_REC.DATA_TYPE IN ('FLOAT','NUMBER') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' ||L_COLUMNS_REC.COLUMN_NAME || ')' || L_SEP_STRING;
         ELSIF (SUBSTR(L_COLUMNS_REC.DATA_TYPE,1,9) = 'TIMESTAMP') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' ||L_COLUMNS_REC.COLUMN_NAME || ',''' ||
                            UNAPIRA.P_TSTZ_FORMAT || ''')' || L_SEP_STRING;
         ELSE
            
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING;
         END IF;
      END LOOP;

      
      L_SQL_STRING := SUBSTR(L_SQL_STRING, 1, LENGTH(L_SQL_STRING)-(LENGTH(L_SEP_STRING)));

      L_SQL_STRING := L_SQL_STRING||' FROM '||L_TABLE_REC.TABLE_NAME||' WHERE ws=:a_ws';

      DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_ws', A_WS);
      DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_PUTTEXT, 4000);
      L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

      LOOP
         EXIT WHEN L_RESULT = 0;

         DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_PUTTEXT);

         L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_PUTTEXT ;

         UNAPIRA.L_EXCEPTION_STEP := 'Writing atws... record to file';
         U4DATAPUTLINE(L_PUTTEXT);
         UNAPIRA.L_EXCEPTION_STEP := NULL;

         L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
      END LOOP;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsCustomToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsCustomToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveWsCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVEWSCUSTOMTOFILE;


FUNCTION ARCHIVEATCUSTOMTOFILE    
RETURN NUMBER IS
   L_SEP_STRING  VARCHAR2(20);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_SEP_STRING := '||CHR('||ASCII(L_SEP)||')||';

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLATCUSTOM_TABLES_CURSOR LOOP
      L_SQL_STRING := 'SELECT ';

      FOR L_COLUMNS_REC IN UNAPIRA.L_USER_TAB_COLUMNS_CURSOR(L_TABLE_REC.TABLE_NAME) LOOP
         IF L_COLUMNS_REC.DATA_TYPE IN ('VARCHAR2','CHAR') THEN
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING;
         ELSIF L_COLUMNS_REC.DATA_TYPE IN ('FLOAT','NUMBER') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' ||L_COLUMNS_REC.COLUMN_NAME || ')' || L_SEP_STRING;
         ELSIF (SUBSTR(L_COLUMNS_REC.DATA_TYPE,1,9) = 'TIMESTAMP') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' || L_COLUMNS_REC.COLUMN_NAME || ',''' ||
                            UNAPIRA.P_TSTZ_FORMAT || ''')' || L_SEP_STRING;
         ELSE
            
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING;
         END IF;
      END LOOP;

      
      L_SQL_STRING := SUBSTR(L_SQL_STRING, 1, LENGTH(L_SQL_STRING)-(LENGTH(L_SEP_STRING)));

      L_SQL_STRING := L_SQL_STRING || ' FROM '||L_TABLE_REC.TABLE_NAME;

      DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_PUTTEXT, 4000);
      L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

      LOOP
         EXIT WHEN L_RESULT = 0;

         DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_PUTTEXT);

         L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_PUTTEXT ;

         UNAPIRA.L_EXCEPTION_STEP := 'Writing at%... record to file';
         U4DATAPUTLINE(L_PUTTEXT);
         UNAPIRA.L_EXCEPTION_STEP := NULL;

         L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
      END LOOP;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveAtCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveAtCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveAtCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveScCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveAtCustomToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveAtCustomToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveAtCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveAtCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveAtCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVEATCUSTOMTOFILE;


FUNCTION ARCHIVERQGKTOFILE     
(A_RQ IN VARCHAR2)             
RETURN NUMBER IS
   L_RQ                VARCHAR2(20);
   L_GK                VARCHAR2(20);
   L_GK_VERSION        VARCHAR2(20);
   L_GKSEQ             NUMBER(3);
   L_VALUE             VARCHAR2(40);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLRQGK_TABLES_CURSOR LOOP
      IF L_TABLE_REC.TABLE_NAME = 'utrqgk' THEN
         L_SQL_STRING := 'SELECT '||CONSTANT_ALLRQGKCOLUMNS||' FROM '||L_TABLE_REC.TABLE_NAME||' '||
                         'WHERE rq=:a_rq';
         DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_rq', A_RQ);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_RQ, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_GK, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_GK_VERSION, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 4, L_GKSEQ);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 5, L_VALUE, 40);
         L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

         LOOP
            EXIT WHEN L_RESULT = 0;

            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_RQ);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_GK);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_GK_VERSION);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 4, L_GKSEQ);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 5, L_VALUE);

            L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_RQ || L_SEP || 
                         L_GK || L_SEP || L_GK_VERSION || L_SEP || L_GKSEQ || L_SEP || L_VALUE;

            UNAPIRA.L_EXCEPTION_STEP := 'Writing utrqgk record to file';
            U4DATAPUTLINE(L_PUTTEXT);
            UNAPIRA.L_EXCEPTION_STEP := NULL;

            L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
         END LOOP;
      ELSE
         L_SQL_STRING := 'SELECT '|| SUBSTR(L_TABLE_REC.TABLE_NAME,7) ||
                         ', rq FROM '||L_TABLE_REC.TABLE_NAME||' '||
                         'WHERE rq=:a_rq';
         DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_rq', A_RQ);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_VALUE, 40);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_RQ, 20);
         L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

         LOOP
            EXIT WHEN L_RESULT = 0;

            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_VALUE);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_RQ);

            L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_VALUE || L_SEP || L_RQ;

            UNAPIRA.L_EXCEPTION_STEP := 'Writing '||L_TABLE_REC.TABLE_NAME||' record to file';
            U4DATAPUTLINE(L_PUTTEXT);
            UNAPIRA.L_EXCEPTION_STEP := NULL;

            L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
         END LOOP;
      END IF;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqGkToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqGkToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVERQGKTOFILE;


FUNCTION ARCHIVERQCUSTOMTOFILE    
(A_RQ IN VARCHAR2)                
RETURN NUMBER IS
   L_SEP_STRING   VARCHAR2(20);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_SEP_STRING := '||CHR('||ASCII(L_SEP)||')||';

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLRQCUSTOM_TABLES_CURSOR LOOP
      L_SQL_STRING := 'SELECT ';

      FOR L_COLUMNS_REC IN UNAPIRA.L_USER_TAB_COLUMNS_CURSOR(L_TABLE_REC.TABLE_NAME) LOOP
         IF L_COLUMNS_REC.DATA_TYPE IN ('VARCHAR2','CHAR') THEN
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING ;
         ELSIF L_COLUMNS_REC.DATA_TYPE IN ('FLOAT','NUMBER') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' ||L_COLUMNS_REC.COLUMN_NAME || ')' || L_SEP_STRING;
         ELSIF (SUBSTR(L_COLUMNS_REC.DATA_TYPE,1,9) = 'TIMESTAMP') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' || L_COLUMNS_REC.COLUMN_NAME || ',''' ||
                            UNAPIRA.P_TSTZ_FORMAT || ''')' || L_SEP_STRING;
         ELSE
            
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING;
         END IF;
      END LOOP;

      
      L_SQL_STRING := SUBSTR(L_SQL_STRING, 1, LENGTH(L_SQL_STRING)-(LENGTH(L_SEP_STRING)));

      L_SQL_STRING := L_SQL_STRING||' FROM '||L_TABLE_REC.TABLE_NAME||' WHERE rq=:a_rq';
      DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_rq', A_RQ);
      DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_PUTTEXT, 4000);
      L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

      LOOP
         EXIT WHEN L_RESULT = 0;

         DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_PUTTEXT);

         L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_PUTTEXT;

         UNAPIRA.L_EXCEPTION_STEP := 'Writing atrq... record to file';
         U4DATAPUTLINE(L_PUTTEXT);
         UNAPIRA.L_EXCEPTION_STEP := NULL;

         L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
      END LOOP;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqCustomToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqCustomToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveRqCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVERQCUSTOMTOFILE;


FUNCTION ARCHIVESDGKTOFILE     
(A_SD IN VARCHAR2)             
RETURN NUMBER IS
   L_SD                VARCHAR2(20);
   L_GK                VARCHAR2(20);
   L_GK_VERSION        VARCHAR2(20);
   L_GKSEQ             NUMBER(3);
   L_VALUE             VARCHAR2(40);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLSDGK_TABLES_CURSOR LOOP
      IF L_TABLE_REC.TABLE_NAME = 'utsdgk' THEN
         L_SQL_STRING := 'SELECT '||CONSTANT_ALLSDGKCOLUMNS||' FROM '||L_TABLE_REC.TABLE_NAME||' '||
                         'WHERE sd=:a_sd';
         DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_sd', A_SD);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_SD, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_GK, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_GK_VERSION, 20);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 4, L_GKSEQ);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 5, L_VALUE, 40);
         L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

         LOOP
            EXIT WHEN L_RESULT = 0;

            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_SD);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_GK);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_GK_VERSION);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 4, L_GKSEQ);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 5, L_VALUE);

            L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_SD || L_SEP || 
                         L_GK || L_SEP || L_GK_VERSION || L_SEP || L_GKSEQ || L_SEP || L_VALUE;

            UNAPIRA.L_EXCEPTION_STEP := 'Writing utsdgk record to file';
            U4DATAPUTLINE(L_PUTTEXT);
            UNAPIRA.L_EXCEPTION_STEP := NULL;

            L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
         END LOOP;
      ELSE
         L_SQL_STRING := 'SELECT '|| SUBSTR(L_TABLE_REC.TABLE_NAME,7) ||
                         ', sd FROM '||L_TABLE_REC.TABLE_NAME||' '||
                         'WHERE sd=:a_sd';
         DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
         DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_sd', A_SD);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_VALUE, 40);
         DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_SD, 20);
         L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

         LOOP
            EXIT WHEN L_RESULT = 0;

            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_VALUE);
            DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_SD);

            L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_VALUE || L_SEP || L_SD;

            UNAPIRA.L_EXCEPTION_STEP := 'Writing '||L_TABLE_REC.TABLE_NAME||' record to file';
            U4DATAPUTLINE(L_PUTTEXT);
            UNAPIRA.L_EXCEPTION_STEP := NULL;

            L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
         END LOOP;
      END IF;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdGkToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdGkToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVESDGKTOFILE;


FUNCTION ARCHIVESDCUSTOMTOFILE    
(A_SD IN VARCHAR2)                
RETURN NUMBER IS
   L_SEP_STRING   VARCHAR2(20);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_SEP_STRING := '||CHR('||ASCII(L_SEP)||')||';

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLSDCUSTOM_TABLES_CURSOR LOOP
      L_SQL_STRING := 'SELECT ';

      FOR L_COLUMNS_REC IN UNAPIRA.L_USER_TAB_COLUMNS_CURSOR(L_TABLE_REC.TABLE_NAME) LOOP
         IF L_COLUMNS_REC.DATA_TYPE IN ('VARCHAR2','CHAR') THEN
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING ;
         ELSIF L_COLUMNS_REC.DATA_TYPE IN ('FLOAT','NUMBER') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' ||L_COLUMNS_REC.COLUMN_NAME || ')' || L_SEP_STRING;
         ELSIF (SUBSTR(L_COLUMNS_REC.DATA_TYPE,1,9) = 'TIMESTAMP') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' || L_COLUMNS_REC.COLUMN_NAME || ',''' ||
                            UNAPIRA.P_TSTZ_FORMAT || ''')' || L_SEP_STRING;
         ELSE
            
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING;
         END IF;
      END LOOP;

      
      L_SQL_STRING := SUBSTR(L_SQL_STRING, 1, LENGTH(L_SQL_STRING)-(LENGTH(L_SEP_STRING)));

      L_SQL_STRING := L_SQL_STRING||' FROM '||L_TABLE_REC.TABLE_NAME||' WHERE sd=:a_sd';
      DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_sd', A_SD);
      DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_PUTTEXT, 4000);
      L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

      LOOP
         EXIT WHEN L_RESULT = 0;

         DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_PUTTEXT);

         L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_PUTTEXT;

         UNAPIRA.L_EXCEPTION_STEP := 'Writing atsd... record to file';
         U4DATAPUTLINE(L_PUTTEXT);
         UNAPIRA.L_EXCEPTION_STEP := NULL;

         L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
      END LOOP;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdCustomToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdCustomToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveSdCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVESDCUSTOMTOFILE;


FUNCTION ARCHIVEPTGKTOFILE        
(A_PT      IN VARCHAR2,           
 A_VERSION IN VARCHAR2)            
RETURN NUMBER IS
   L_PT                VARCHAR2(20);
   L_VERSION           VARCHAR2(20);
   L_GK                VARCHAR2(20);
   L_GK_VERSION        VARCHAR2(20);
   L_GKSEQ             NUMBER(3);
   L_VALUE             VARCHAR2(40);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLPTGK_TABLES_CURSOR LOOP
      IF L_TABLE_REC.TABLE_NAME = 'utptgk' THEN
          L_SQL_STRING := 'SELECT '||CONSTANT_ALLPTGKCOLUMNS||' FROM '||L_TABLE_REC.TABLE_NAME||' '||
                          'WHERE pt=:a_pt AND version=:a_version';
          DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
          DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pt', A_PT);
          DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_version', A_VERSION);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_PT, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_VERSION, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_GK, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 4, L_GK_VERSION, 20);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 5, L_GKSEQ);
          DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 6, L_VALUE, 40);
          L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

          LOOP
             EXIT WHEN L_RESULT = 0;

             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_PT);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_VERSION);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_GK);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 4, L_GK_VERSION);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 5, L_GKSEQ);
             DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 6, L_VALUE);
             L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_PT || L_SEP ||L_VERSION || L_SEP || 
                          L_GK || L_SEP || L_GK_VERSION || L_SEP || L_GKSEQ || L_SEP || L_VALUE;

             UNAPIRA.L_EXCEPTION_STEP := 'Writing utptgk record to file';
             U4DATAPUTLINE(L_PUTTEXT);
             UNAPIRA.L_EXCEPTION_STEP := NULL;

             L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
          END LOOP;
      ELSE
         IF SUBSTR(L_TABLE_REC.TABLE_NAME,1,6) = 'utptgk' THEN
             L_SQL_STRING := 'SELECT '|| SUBSTR(L_TABLE_REC.TABLE_NAME,7) ||
                             ', pt, version FROM '||L_TABLE_REC.TABLE_NAME||' '||
                             'WHERE pt=:a_pt and version=:a_version';
             DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
             DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_pt', A_PT);
             DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_version', A_VERSION);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_VALUE, 40);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 2, L_PT, 20);
             DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 3, L_VERSION, 20);
             L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

             LOOP
                EXIT WHEN L_RESULT = 0;

                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_VALUE);
                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 2, L_PT);
                DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 3, L_VERSION);

                L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_VALUE || L_SEP || L_PT|| L_SEP || L_VERSION;

                UNAPIRA.L_EXCEPTION_STEP := 'Writing '||L_TABLE_REC.TABLE_NAME||' record to file';
                U4DATAPUTLINE(L_PUTTEXT);
                UNAPIRA.L_EXCEPTION_STEP := NULL;

                L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
             END LOOP;
         END IF;
      END IF;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchivePtGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchivePtGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchivePtGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchivePtGkToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchivePtGkToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchivePtGkToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchivePtGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchivePtGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchivePtGkToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVEPTGKTOFILE;


FUNCTION ARCHIVECHCUSTOMTOFILE    
(A_CH IN VARCHAR2)                
RETURN NUMBER IS
   L_SEP_STRING  VARCHAR2(20);
BEGIN
   L_SQLERRM := NULL;
   UNAPIRA.L_EXCEPTION_STEP := NULL;

   L_SEP_STRING := '||CHR('||ASCII(L_SEP)||')||';

   L_DYN_CURSOR := DBMS_SQL.OPEN_CURSOR;
   FOR L_TABLE_REC IN UNAPIRA.L_ALLCHCUSTOM_TABLES_CURSOR LOOP
      L_SQL_STRING := 'SELECT ';

      FOR L_COLUMNS_REC IN UNAPIRA.L_USER_TAB_COLUMNS_CURSOR(L_TABLE_REC.TABLE_NAME) LOOP
         IF L_COLUMNS_REC.DATA_TYPE IN ('VARCHAR2','CHAR') THEN
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING;
         ELSIF L_COLUMNS_REC.DATA_TYPE IN ('FLOAT','NUMBER') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' ||L_COLUMNS_REC.COLUMN_NAME || ')' || L_SEP_STRING;
         ELSIF (SUBSTR(L_COLUMNS_REC.DATA_TYPE,1,9) = 'TIMESTAMP') THEN
            L_SQL_STRING := L_SQL_STRING || 'TO_CHAR(' ||L_COLUMNS_REC.COLUMN_NAME || ',''' ||
                            UNAPIRA.P_TSTZ_FORMAT || ''')' || L_SEP_STRING;
         ELSE
            
            L_SQL_STRING := L_SQL_STRING || L_COLUMNS_REC.COLUMN_NAME || L_SEP_STRING;
         END IF;
      END LOOP;

      
      L_SQL_STRING := SUBSTR(L_SQL_STRING, 1, LENGTH(L_SQL_STRING)-(LENGTH(L_SEP_STRING)));

      L_SQL_STRING := L_SQL_STRING||' FROM '||L_TABLE_REC.TABLE_NAME||' WHERE ch=:a_ch';

      DBMS_SQL.PARSE(L_DYN_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
      DBMS_SQL.BIND_VARIABLE(L_DYN_CURSOR, ':a_ch', A_CH);
      DBMS_SQL.DEFINE_COLUMN(L_DYN_CURSOR, 1, L_PUTTEXT, 4000);
      L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_DYN_CURSOR);

      LOOP
         EXIT WHEN L_RESULT = 0;

         DBMS_SQL.COLUMN_VALUE(L_DYN_CURSOR, 1, L_PUTTEXT);

         L_PUTTEXT := L_TABLE_REC.TABLE_NAME || L_SEP || L_PUTTEXT ;

         UNAPIRA.L_EXCEPTION_STEP := 'Writing atch... record to file';
         U4DATAPUTLINE(L_PUTTEXT);
         UNAPIRA.L_EXCEPTION_STEP := NULL;

         L_RESULT := DBMS_SQL.FETCH_ROWS(L_DYN_CURSOR);
      END LOOP;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid path';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveChCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_PATH',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.INVALID_MODE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid mode';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveChCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_MODE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid filehandle';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveChCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_FILEHANDLE',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INVALID_OPERATION THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Invalid operation';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveChCustomToFile', L_SQLERRM, 'UTL_FILE.INVALID_OPERATION',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_NOOBJECT);
   WHEN UTL_FILE.READ_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Read error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveChCustomToFile', L_SQLERRM, 'UTL_FILE.READ_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.WRITE_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Write error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveChCustomToFile', L_SQLERRM, 'UTL_FILE.WRITE_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      L_SQLERRM := 'directory='||UNAPIRA.P_FILE_DIR||'#file='||UNAPIRA.P_FILE_NAME ||':Internal error';
      UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveChCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(L_DYN_CURSOR) THEN
         DBMS_SQL.CLOSE_CURSOR(L_DYN_CURSOR);
      END IF;
      IF SQLCODE <> 1 THEN
         L_SQLERRM := SUBSTR(SQLERRM,1,200);
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveChCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      ELSIF L_SQLERRM IS NOT NULL THEN
         UNAPIRA.UTLFILEEXCEPTIONHANDLER('ArchiveChCustomToFile', L_SQLERRM, 'UTL_FILE.INTERNAL_ERROR',UNAPIRA.P_CLOSE_CURSOR);
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
END ARCHIVECHCUSTOMTOFILE;


FUNCTION ARCHIVETOFILE              
(A_ARCHIVE_ID    IN VARCHAR2)       
RETURN NUMBER IS
   L_NR_TO_COPY INTEGER;
   L_RET_CODE   INTEGER;
BEGIN
   
   

   SELECT COUNT(*)
     INTO L_NR_TO_COPY
     FROM UTTOARCHIVE
    WHERE ARCHIVE_ID = A_ARCHIVE_ID
      AND COPY_FLAG = '1';

   IF L_NR_TO_COPY = 0 THEN
      
      L_RET_CODE := REMOVEONLY  (A_ARCHIVE_ID);
   ELSE
      L_RET_CODE := WRITETOFILE (A_ARCHIVE_ID);
   END IF;

   RETURN(L_RET_CODE);
END ARCHIVETOFILE;




BEGIN
   L_SEP:=UNAPIRA.P_INTERNAL_SEP;
END UNAPIRA3;