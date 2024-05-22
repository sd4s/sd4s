FUNCTION INTCREATENEXTUNIQUECODEVALUE                        
(A_UC                  IN       VARCHAR2,                     --UC = Basic Mask
 A_FIELDTYPE_TAB       IN       UNAPIGEN.VC20_TABLE_TYPE,    
 A_FIELDNAMES_TAB      IN       UNAPIGEN.VC40_TABLE_TYPE,    
 A_FIELDVALUES_TAB     IN       UNAPIGEN.VC40_TABLE_TYPE,    
 A_NR_OF_ROWS          IN       NUMBER,                       --0                  
 A_REF_DATE            IN       DATE,                         -- lvd_ref_date   := CURRENT_TIMESTAMP;
 A_NEXT_VAL            OUT      VARCHAR2,                    
 A_EDIT_ALLOWED        OUT      CHAR,                        
 A_VALID_CF            OUT      VARCHAR2)                    
RETURN NUMBER IS

L_UC_STRUCTURE           VARCHAR2(255);
L_CURR_VAL               VARCHAR2(255);
L_EDIT_ALLOWED           CHAR(1);
L_VALID_CF               VARCHAR2(20);
L_UC_LOG_HS              CHAR(1);
L_SP_FLD_OR_CT           BOOLEAN;
L_CURR_POS               INTEGER;
L_CURR_FIELD             VARCHAR2(255);
L_END_POS                INTEGER;
L_Q_POS                  INTEGER;
L_FIELD_NAME             VARCHAR2(255);
L_QUALIFIER              VARCHAR2(255);
L_NEW_VAL                VARCHAR2(255);
L_REF_DATE               TIMESTAMP WITH TIME ZONE;
L_WEEK_NR                NUMBER(2);
L_YEAR_NR                NUMBER(4);
L_DAY_OF_WEEK            NUMBER(1);
L_VALUE                  VARCHAR2(40);
L_C_VAL                  VARCHAR2(255);
L_CURR_F_VAL             VARCHAR2(255);
L_NEW_F_VAL              VARCHAR2(255);
L_START_UC_STRU          INTEGER;
L_POS_UC_STRU            INTEGER;
L_UC_CURSOR              INTEGER;
L_START_PREV             INTEGER;
L_END_PREV               INTEGER;
L_END                    INTEGER;
L_NR_FIELDS              INTEGER;
L_BRACE_CNT              INTEGER;
L_CURR_VAL_BRACE         VARCHAR2(255);
L_NEW_CNT                NUMBER(6);
L_FIRST_DAY_OF_WEEK      TIMESTAMP WITH TIME ZONE;
L_PREVIOUS_WEEK_NR       NUMBER(2);
L_DAY                    TIMESTAMP WITH TIME ZONE;
L_COUNTER_LOCKNAME       VARCHAR2(30);
L_RQSCSEQ                INTEGER;
L_SDSCSEQ                NUMBER;
A_VERSION                VARCHAR2(20);
L_FOUND                  BOOLEAN;
L_COUNTER_EXISTS         VARCHAR2(20);
L_COUNTER_FOUND          BOOLEAN;
L_COUNTER                UNAPIGEN.CHAR1_TABLE_TYPE;
L_NEW_VAL_BEFORE_CT      VARCHAR2(255);
L_NEW_VAL_AFTER_CT       VARCHAR2(255);
L_OBJECT_COUNTER         NUMBER(6);


L_RQ                     VARCHAR2(20);
L_WS                     VARCHAR2(20);
L_SD                     VARCHAR2(20);
L_ST                     VARCHAR2(20);
L_RT                     VARCHAR2(20);
L_PT                     VARCHAR2(20);
L_WT                     VARCHAR2(20);
L_ST_VERSION             VARCHAR2(20);
L_RT_VERSION             VARCHAR2(20);
L_PT_VERSION             VARCHAR2(20);
L_WT_VERSION             VARCHAR2(20);


CURSOR C_UC (A_UC VARCHAR2, A_VERSION VARCHAR2) IS
   SELECT UC_STRUCTURE, CURR_VAL, EDIT_ALLOWED, VALID_CF, LOG_HS
   FROM UTUC
   WHERE UC = A_UC
   AND VERSION = A_VERSION;

CURSOR C_WEEK (A_REF_DATE TIMESTAMP WITH TIME ZONE) IS
   SELECT DAY_OF_YEAR,WEEK_NR
   FROM UTWEEKNR
   WHERE DAY_OF_YEAR <= TO_TIMESTAMP_TZ(TO_CHAR(L_REF_DATE,'DD/MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
   ORDER BY DAY_OF_YEAR DESC;

CURSOR C_RQSCSEQ(A_RQ VARCHAR2) IS
   SELECT NVL(OBJECT_COUNTER,0)+1
   FROM UTUCOBJECTCOUNTER
   WHERE OBJECT_TP = 'rq'
     AND OBJECT_ID = A_RQ;

CURSOR C_RQSCINITIALSEQ(A_RQ VARCHAR2) IS
   SELECT COUNT(SC)+1
   FROM UTRQSC
   WHERE RQ = A_RQ;

CURSOR C_SDSCSEQ(A_SD VARCHAR2) IS
   SELECT NVL(OBJECT_COUNTER,0)+1
   FROM UTUCOBJECTCOUNTER
   WHERE OBJECT_TP = 'sd'
     AND OBJECT_ID = A_SD;

CURSOR C_SDSCINITIALSEQ(A_SD VARCHAR2) IS
   SELECT COUNT(SC)+1
   FROM UTSDCELLSC
   WHERE SD = A_SD;

CURSOR C_UTCOUNTER_CURSOR (A_COUNTER VARCHAR2) IS
   SELECT COUNTER
   FROM UTCOUNTER
   WHERE COUNTER = A_COUNTER;

   PROCEDURE IMPOSEDIGITS (A_NEW_CNT IN NUMBER, A_QUALIFIER IN VARCHAR2, A_NEW_VAL IN OUT VARCHAR2) 
   IS
   L_NR_OF_DIGITS      INTEGER;
   BEGIN
         L_NR_OF_DIGITS := 0;
         BEGIN
            L_NR_OF_DIGITS := NVL(A_QUALIFIER,'0');
         EXCEPTION
         WHEN OTHERS THEN
            
            NULL;
         END;

         IF L_NR_OF_DIGITS = 0 THEN
            A_NEW_VAL := A_NEW_VAL || TO_CHAR(A_NEW_CNT);
         ELSE
            A_NEW_VAL := A_NEW_VAL || UNAPIGEN.CX_LPAD(TO_CHAR(A_NEW_CNT),
                                           GREATEST(LENGTH(TO_CHAR(A_NEW_CNT)),L_NR_OF_DIGITS),
                                           '0');
         END IF;
   END IMPOSEDIGITS;
--********************************************************************************************
--********************************************************************************************
--********************************************************************************************
BEGIN
   IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <>
      UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;
   IF NVL (A_UC, ' ') = ' ' THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJID;
      RAISE STPERROR;
   END IF;
   
   A_VERSION := UNVERSION.P_NO_VERSION;      
   
   IF A_VERSION IS NULL THEN
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_GENFAIL;
      RAISE STPERROR;
   END IF;

   OPEN C_UC (A_UC, A_VERSION);
   
   --SELECT UC_STRUCTURE, CURR_VAL, EDIT_ALLOWED, VALID_CF, LOG_HS  FROM UTUC  WHERE UC = 'Basic Mask' ;   --A_UC  AND VERSION = A_VERSION = 0;
   --{YYYY}{MM}{DD}-{test_counter1\DD}	0	{2021}{04}{28}-{001}	0		1
   
   FETCH C_UC
   INTO L_UC_STRUCTURE, L_CURR_VAL, L_EDIT_ALLOWED, L_VALID_CF, L_UC_LOG_HS;
   IF C_UC%NOTFOUND THEN
      CLOSE C_UC;
      UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOOBJECT;
      RAISE STPERROR;
   END IF;
   CLOSE C_UC;

   

   IF A_REF_DATE IS NOT NULL THEN
      L_REF_DATE := A_REF_DATE;
   ELSE
      L_REF_DATE := CURRENT_TIMESTAMP;
   END IF;

   FOR L_ROW IN 1..A_NR_OF_ROWS LOOP
      IF A_FIELDNAMES_TAB(L_ROW) = 'rq' THEN
         L_RQ := A_FIELDVALUES_TAB(L_ROW);
      ELSIF A_FIELDNAMES_TAB(L_ROW) = 'ws' THEN
         L_WS := A_FIELDVALUES_TAB(L_ROW);
      ELSIF A_FIELDNAMES_TAB(L_ROW) = 'sd' THEN
         L_SD := A_FIELDVALUES_TAB(L_ROW);
      ELSIF A_FIELDNAMES_TAB(L_ROW) = 'st' THEN
         L_ST := A_FIELDVALUES_TAB(L_ROW);
      ELSIF A_FIELDNAMES_TAB(L_ROW) = 'rt' THEN
         L_RT := A_FIELDVALUES_TAB(L_ROW);
      ELSIF A_FIELDNAMES_TAB(L_ROW) = 'wt' THEN
         L_WT := A_FIELDVALUES_TAB(L_ROW);
      ELSIF A_FIELDNAMES_TAB(L_ROW) = 'pt' THEN
         L_PT := A_FIELDVALUES_TAB(L_ROW);
      ELSIF A_FIELDNAMES_TAB(L_ROW) = 'st_version' THEN
         L_ST_VERSION := A_FIELDVALUES_TAB(L_ROW);
      ELSIF A_FIELDNAMES_TAB(L_ROW) = 'rt_version' THEN
         L_RT_VERSION := A_FIELDVALUES_TAB(L_ROW);
      ELSIF A_FIELDNAMES_TAB(L_ROW) = 'wt_version' THEN
         L_WT_VERSION := A_FIELDVALUES_TAB(L_ROW);
      ELSIF A_FIELDNAMES_TAB(L_ROW) = 'pt_version' THEN
         L_PT_VERSION := A_FIELDVALUES_TAB(L_ROW);
      END IF;
   END LOOP;
   IF (NVL(L_RQ, ' ') <> ' ') AND (NVL(L_RT, ' ') = ' ') THEN
      BEGIN
         SELECT RT, RT_VERSION
         INTO L_RT, L_RT_VERSION
         FROM UTRQ
         WHERE RQ = L_RQ;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         
         
         
         
         
         NULL;
      END;
   END IF;
   IF (NVL(L_WS, ' ') <> ' ') AND (NVL(L_WT, ' ') = ' ') THEN
      BEGIN
         SELECT WT, WT_VERSION
         INTO L_WT, L_WT_VERSION
         FROM UTWS
         WHERE WS = L_WS;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         
         
         
         
         
         NULL;
      END;
   END IF;
   IF (NVL(L_SD, ' ') <> ' ') AND (NVL(L_PT, ' ') = ' ') THEN
      BEGIN
         SELECT PT, PT_VERSION
         INTO L_PT, L_PT_VERSION
         FROM UTSD
         WHERE SD = L_SD;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         
         
         
         
         
         NULL;
      END;
   END IF;

   
   
   
   
   
   
   
   FOR LOOP_NR IN 1..2 LOOP
      L_CURR_POS := 1;
      L_NR_FIELDS := 0;
      
	  
	  --L_UC_STRUCTURE={YYYY}{MM}{DD}-{test_counter1\DD}
      WHILE L_CURR_POS < LENGTH(L_UC_STRUCTURE) LOOP
         L_FIELD_NAME := NULL;
         L_SP_FLD_OR_CT := FALSE;
         IF SUBSTR(L_UC_STRUCTURE,L_CURR_POS,1) = '{'  THEN
            L_SP_FLD_OR_CT := TRUE;
            L_END_POS := INSTR(L_UC_STRUCTURE, '}', L_CURR_POS + 1);          --{YYYY}
            IF (L_END_POS = 0) THEN
               UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_UCSTRUCTURE;
               RAISE STPERROR;
            END IF;
            L_NR_FIELDS := L_NR_FIELDS + 1;
            L_CURR_FIELD := SUBSTR(L_UC_STRUCTURE, L_CURR_POS + 1,
                                   L_END_POS - L_CURR_POS - 1);
            L_Q_POS := INSTR(L_CURR_FIELD, '\');                     --'
            IF L_Q_POS = 0 THEN
               L_FIELD_NAME := L_CURR_FIELD;
               L_QUALIFIER := '';
            ELSE
               L_FIELD_NAME := SUBSTR(L_CURR_FIELD, 1, L_Q_POS - 1);
               L_QUALIFIER := SUBSTR(L_CURR_FIELD, L_Q_POS + 1,
                                  LENGTH(L_CURR_FIELD)-L_Q_POS);
            END IF;
            
            IF LOOP_NR = 1 THEN
               L_NEW_VAL := L_NEW_VAL || '{';
            END IF;
         ELSE
            LOOP
               IF LOOP_NR = 1 THEN
                  L_NEW_VAL := L_NEW_VAL || SUBSTR(L_UC_STRUCTURE, L_CURR_POS, 1);
               END IF;
               L_CURR_POS := L_CURR_POS + 1;
               EXIT WHEN (SUBSTR(L_UC_STRUCTURE, L_CURR_POS, 1)= '{') OR
                         L_CURR_POS > LENGTH(L_UC_STRUCTURE);
            END LOOP;
            L_END_POS := L_CURR_POS - 1;
         END IF;

         
         IF (LOOP_NR = 1) AND L_SP_FLD_OR_CT THEN
            L_COUNTER(L_NR_FIELDS) := '0';

            IF L_FIELD_NAME = 'Y' THEN
               L_NEW_VAL := L_NEW_VAL || TO_CHAR(L_REF_DATE, 'Y');
            ELSIF L_FIELD_NAME = 'YY' THEN
               L_NEW_VAL := L_NEW_VAL || TO_CHAR(L_REF_DATE, 'RR');
            ELSIF L_FIELD_NAME = 'YYYY' THEN
               L_NEW_VAL := L_NEW_VAL || TO_CHAR(L_REF_DATE, 'YYYY');
            ELSIF L_FIELD_NAME = 'MM' THEN
               L_NEW_VAL := L_NEW_VAL || TO_CHAR(L_REF_DATE, 'MM');
            ELSIF L_FIELD_NAME = 'MMM' THEN
               L_NEW_VAL := L_NEW_VAL || TO_CHAR(L_REF_DATE, 'MON');
            ELSIF L_FIELD_NAME = 'DDD' THEN
               L_NEW_VAL := L_NEW_VAL || TO_CHAR(L_REF_DATE, 'DDD');
            ELSIF L_FIELD_NAME = 'DD' THEN
               L_NEW_VAL := L_NEW_VAL || TO_CHAR(L_REF_DATE, 'DD');
            ELSIF L_FIELD_NAME = 'hh' THEN
               L_NEW_VAL := L_NEW_VAL || TO_CHAR(L_REF_DATE, 'HH24');
            ELSIF L_FIELD_NAME = 'mm' THEN
               L_NEW_VAL := L_NEW_VAL || TO_CHAR(L_REF_DATE, 'MI');
            ELSIF L_FIELD_NAME = 'ss' THEN
               L_NEW_VAL := L_NEW_VAL || TO_CHAR(L_REF_DATE, 'SS');
            ELSIF L_FIELD_NAME = 'WW' THEN
               SELECT WEEK_NR
               INTO L_WEEK_NR
               FROM UTWEEKNR
               WHERE DAY_OF_YEAR = TO_TIMESTAMP_TZ(TO_CHAR(L_REF_DATE,'DD/MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR');
               L_NEW_VAL := L_NEW_VAL || LTRIM(TO_CHAR(L_WEEK_NR,'00'));
            ELSIF L_FIELD_NAME IN ('IY', 'IYY', 'IYYYY') THEN
               SELECT YEAR_NR
               INTO L_YEAR_NR
               FROM UTWEEKNR
               WHERE DAY_OF_YEAR = TO_TIMESTAMP_TZ(TO_CHAR(L_REF_DATE,'DD/MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR');
               IF L_FIELD_NAME = 'IYYYY' THEN
                  L_NEW_VAL := L_NEW_VAL || LTRIM(TO_CHAR(L_YEAR_NR,'0000'));
               ELSIF L_FIELD_NAME = 'IYY' THEN
                  L_NEW_VAL := L_NEW_VAL || SUBSTR(LTRIM(TO_CHAR(L_YEAR_NR,'0000')),-2);
               ELSIF L_FIELD_NAME = 'IY' THEN
                  L_NEW_VAL := L_NEW_VAL || SUBSTR(LTRIM(TO_CHAR(L_YEAR_NR,'0000')),-1);
               END IF;
            ELSIF L_FIELD_NAME = 'D' THEN
               SELECT DAY_OF_WEEK
               INTO L_DAY_OF_WEEK
               FROM UTWEEKNR
               WHERE DAY_OF_YEAR = TO_TIMESTAMP_TZ(TO_CHAR(L_REF_DATE,'DD/MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR');
               L_NEW_VAL := L_NEW_VAL || L_DAY_OF_WEEK;

            ELSIF L_FIELD_NAME = 'userid' THEN
               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(UNAPIGEN.P_USER, L_QUALIFIER);
               

            ELSIF L_FIELD_NAME = 'st' THEN
               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(L_ST, L_QUALIFIER);
               

            ELSIF L_FIELD_NAME = 'wt' THEN
               IF NVL(L_WT, ' ') = ' ' THEN
                  
                  L_WT :=  L_ST;
               END IF;
               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(L_WT, L_QUALIFIER);
               

            ELSIF SUBSTR(L_FIELD_NAME, 1, 4) = 'au->' THEN
               L_UC_CURSOR := DBMS_SQL.OPEN_CURSOR;
               L_SQL_STRING := 'SELECT value FROM utstau a ' ||
                               'WHERE a.st = :a_st '|| 
                               'AND a.version = UNAPIGEN.UseVersion(''st'',:a_st, :a_st_version) '|| 
                               'AND au = :a_au ORDER BY auseq'; 
               DBMS_SQL.PARSE(L_UC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_st', L_ST, 20);
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_st_version', L_ST_VERSION, 20);
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_au', SUBSTR(L_FIELD_NAME, 5), 20);
               DBMS_SQL.DEFINE_COLUMN(L_UC_CURSOR, 1, L_VALUE, 40);
               L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_UC_CURSOR);

               IF  L_RESULT <> 0 THEN
                  DBMS_SQL.COLUMN_VALUE(L_UC_CURSOR, 1, L_VALUE);
               ELSE
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NORECORDS;
                  RAISE STPERROR;
               END IF;

               DBMS_SQL.CLOSE_CURSOR(L_UC_CURSOR);

               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(L_VALUE, L_QUALIFIER);
               

            ELSIF SUBSTR(L_FIELD_NAME, 1, 6) = 'upau->' THEN
               L_UC_CURSOR := DBMS_SQL.OPEN_CURSOR;
               L_SQL_STRING := 'SELECT upau.value FROM utupau upau, utup up ' || 
                               'WHERE up.up = :a_up AND up.up = upau.up '|| 
                               'AND up.version_is_current  = ''1'' '|| 
                               'AND upau.au = :a_au  ORDER BY auseq'; 
               DBMS_SQL.PARSE(L_UC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_up', UNAPIGEN.P_CURRENT_UP, 20);
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_au', SUBSTR(L_FIELD_NAME, 7), 20);
               DBMS_SQL.DEFINE_COLUMN(L_UC_CURSOR, 1, L_VALUE, 40);
               L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_UC_CURSOR);

               IF  L_RESULT <> 0 THEN
                  DBMS_SQL.COLUMN_VALUE(L_UC_CURSOR, 1, L_VALUE);
               ELSE
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NORECORDS;
                  RAISE STPERROR;
               END IF;

               DBMS_SQL.CLOSE_CURSOR(L_UC_CURSOR);

               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(L_VALUE, L_QUALIFIER);
               

            ELSIF SUBSTR(L_FIELD_NAME, 1, 6) IN ('usau->','adau->') THEN
               L_UC_CURSOR := DBMS_SQL.OPEN_CURSOR;
               L_SQL_STRING := 'SELECT adau.value FROM utadau adau, utad ad ' || 
                               'WHERE ad.ad = :a_ad AND ad.ad = adau.ad ' || 
                               'AND ad.version_is_current  = ''1'' '|| 
                               'AND au = :a_au ORDER BY auseq'; 
               DBMS_SQL.PARSE(L_UC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_ad', UNAPIGEN.P_USER, 20);
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_au', SUBSTR(L_FIELD_NAME, 7), 20);
               DBMS_SQL.DEFINE_COLUMN(L_UC_CURSOR, 1, L_VALUE, 40);
               L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_UC_CURSOR);

               IF  L_RESULT <> 0 THEN
                  DBMS_SQL.COLUMN_VALUE(L_UC_CURSOR, 1, L_VALUE);
               ELSE
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NORECORDS;
                  RAISE STPERROR;
               END IF;

               DBMS_SQL.CLOSE_CURSOR(L_UC_CURSOR);

               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(L_VALUE, L_QUALIFIER);
               

            ELSIF L_FIELD_NAME = 'rt' THEN
               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(L_RT, L_QUALIFIER);
               

            ELSIF SUBSTR(L_FIELD_NAME, 1, 6) = 'rtau->' THEN
               L_UC_CURSOR := DBMS_SQL.OPEN_CURSOR;
               L_SQL_STRING := 'SELECT value FROM utrtau a ' ||
                               'WHERE a.rt = :a_rt '|| 
                               'AND a.version = UNAPIGEN.UseVersion(''rt'',:a_rt, :a_rt_version) '|| 
                               'AND au = :a_au ORDER BY auseq'; 
               DBMS_SQL.PARSE(L_UC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_rt', L_RT, 20);
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_rt_version', L_RT_VERSION, 20);
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_au', SUBSTR(L_FIELD_NAME, 7), 20);
               DBMS_SQL.DEFINE_COLUMN(L_UC_CURSOR, 1, L_VALUE, 40);
               L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_UC_CURSOR);

               IF  L_RESULT <> 0 THEN
                  DBMS_SQL.COLUMN_VALUE(L_UC_CURSOR, 1, L_VALUE);
               ELSE
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NORECORDS;
                  RAISE STPERROR;
               END IF;

               DBMS_SQL.CLOSE_CURSOR(L_UC_CURSOR);

               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(L_VALUE, L_QUALIFIER);
               

            ELSIF L_FIELD_NAME = 'rq' THEN
               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(L_RQ, L_QUALIFIER);
               

            ELSIF L_FIELD_NAME IN ('rq seq0','rq seq1') THEN
               OPEN C_RQSCSEQ(L_RQ);
               FETCH C_RQSCSEQ INTO L_RQSCSEQ;
               IF C_RQSCSEQ%NOTFOUND THEN
                  
                  
                  
                  
                  OPEN C_RQSCINITIALSEQ(L_RQ);
                  FETCH C_RQSCINITIALSEQ INTO L_RQSCSEQ;
                  IF C_RQSCINITIALSEQ%NOTFOUND THEN
                     L_RQSCSEQ := 1;
                  END IF;
                  CLOSE C_RQSCINITIALSEQ;
               END IF;
               CLOSE C_RQSCSEQ;

               
               
               UPDATE UTUCOBJECTCOUNTER
               SET OBJECT_COUNTER = L_RQSCSEQ
               WHERE OBJECT_TP = 'rq'
                 AND OBJECT_ID = L_RQ;
               
               IF SQL%ROWCOUNT < 1 THEN
                  INSERT INTO UTUCOBJECTCOUNTER(OBJECT_TP, OBJECT_ID, OBJECT_COUNTER)
                  VALUES('rq', L_RQ, L_RQSCSEQ);
               END IF;

               IF L_FIELD_NAME = 'rq seq0' THEN
                  L_RQSCSEQ := L_RQSCSEQ -1;
               END IF;

               IMPOSEDIGITS (L_RQSCSEQ , L_QUALIFIER , L_NEW_VAL);
               
               
            ELSIF L_FIELD_NAME = 'pt' THEN
               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(L_PT, L_QUALIFIER);
               
            ELSIF SUBSTR(L_FIELD_NAME, 1, 6) = 'ptau->' THEN
               L_UC_CURSOR := DBMS_SQL.OPEN_CURSOR;
               L_SQL_STRING := 'SELECT value FROM utptau a ' ||
                               'WHERE a.pt = :a_pt '|| 
                               'AND a.version = UNAPIGEN.UseVersion(''pt'',:a_pt, :a_pt_version) '|| 
                               'AND au = :a_au ORDER BY auseq'; 
               DBMS_SQL.PARSE(L_UC_CURSOR, L_SQL_STRING, DBMS_SQL.V7); 
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_pt', L_PT, 20);
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_pt_version', L_PT_VERSION, 20);
               DBMS_SQL.BIND_VARIABLE(L_UC_CURSOR, ':a_au', SUBSTR(L_FIELD_NAME, 7), 20);
               DBMS_SQL.DEFINE_COLUMN(L_UC_CURSOR, 1, L_VALUE, 40);
               L_RESULT := DBMS_SQL.EXECUTE_AND_FETCH(L_UC_CURSOR);

               IF  L_RESULT <> 0 THEN
                  DBMS_SQL.COLUMN_VALUE(L_UC_CURSOR, 1, L_VALUE);
               ELSE
                  UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NORECORDS;
                  RAISE STPERROR;
               END IF;

               DBMS_SQL.CLOSE_CURSOR(L_UC_CURSOR);

               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(L_VALUE, L_QUALIFIER);
               

            ELSIF L_FIELD_NAME = 'sd' THEN
               L_NEW_VAL := L_NEW_VAL || IMPOSE_QUALIFIER(L_SD, L_QUALIFIER);
               

            ELSIF L_FIELD_NAME IN ('sd seq0','sd seq1') THEN
               OPEN C_SDSCSEQ(L_SD);
               FETCH C_SDSCSEQ INTO L_SDSCSEQ;
               IF C_SDSCSEQ%NOTFOUND THEN
                  
                  
                  
                  
                  OPEN C_SDSCINITIALSEQ(L_SD);
                  FETCH C_SDSCINITIALSEQ INTO L_SDSCSEQ;
                  IF C_SDSCINITIALSEQ%NOTFOUND THEN
                     L_SDSCSEQ := 1;
                  END IF;
                  CLOSE C_SDSCINITIALSEQ;
               END IF;
               CLOSE C_SDSCSEQ;

               
               
               UPDATE UTUCOBJECTCOUNTER
               SET OBJECT_COUNTER = L_SDSCSEQ
               WHERE OBJECT_TP = 'sd'
                 AND OBJECT_ID = L_SD;
               
               IF SQL%ROWCOUNT < 1 THEN
                  INSERT INTO UTUCOBJECTCOUNTER(OBJECT_TP, OBJECT_ID, OBJECT_COUNTER)
                  VALUES('sd', L_SD, L_SDSCSEQ);
               END IF;

               IF L_FIELD_NAME = 'sd seq0' THEN
                  L_SDSCSEQ := L_SDSCSEQ -1;
               END IF;

               IMPOSEDIGITS (L_SDSCSEQ , L_QUALIFIER , L_NEW_VAL);
               
               
            ELSIF SUBSTR(L_FIELD_NAME, -5) IN (' seq0',' seq1') THEN
               
               
               
               L_FOUND := FALSE ;
               FOR L_ROW IN 1..A_NR_OF_ROWS LOOP
                  IF A_FIELDTYPE_TAB(L_ROW)||'.'||A_FIELDNAMES_TAB(L_ROW) = SUBSTR(L_FIELD_NAME,1, INSTR(L_FIELD_NAME,' ', -4)-1) THEN
                     UPDATE UTUCOBJECTCOUNTER
                     SET OBJECT_COUNTER = OBJECT_COUNTER+1
                     WHERE OBJECT_TP = SUBSTR(A_FIELDTYPE_TAB(L_ROW)||A_FIELDNAMES_TAB(L_ROW),1,20)
                       AND OBJECT_ID = SUBSTR(A_FIELDVALUES_TAB(L_ROW),1,20)
                     RETURNING OBJECT_COUNTER
                     INTO L_OBJECT_COUNTER;
                     
                     IF SQL%ROWCOUNT < 1 THEN
                        L_OBJECT_COUNTER := 1;
                        INSERT INTO UTUCOBJECTCOUNTER(OBJECT_TP, OBJECT_ID, OBJECT_COUNTER)
                        VALUES(SUBSTR(A_FIELDTYPE_TAB(L_ROW)||A_FIELDNAMES_TAB(L_ROW),1,20), SUBSTR(A_FIELDVALUES_TAB(L_ROW),1,20), L_OBJECT_COUNTER);
                     END IF;

                     IF SUBSTR(L_FIELD_NAME, -5) = ' seq0' THEN
                        L_OBJECT_COUNTER := L_OBJECT_COUNTER -1;
                     END IF;
                     L_FOUND := TRUE;
                     EXIT;
                  END IF;
               END LOOP;

               IF L_FOUND THEN
                  IMPOSEDIGITS (L_OBJECT_COUNTER , L_QUALIFIER , L_NEW_VAL);
                  
                  
               ELSE
                  
                  
                  
                  IF L_FIELD_NAME IS NOT NULL THEN
                     L_COUNTER(L_NR_FIELDS) := '1';
                  END IF;
               END IF;

            ELSIF L_FIELD_NAME IN ('DayCounter', 'WeekCounter', 'MonthCounter', 'YearCounter',
                                   'DayCounter1','WeekCounter1', 'MonthCounter1','YearCounter1', 
                                   'DayCounter2','WeekCounter2', 'MonthCounter2','YearCounter2', 
                                   'DayCounter3','WeekCounter3', 'MonthCounter3','YearCounter3', 
                                   'DayCounter4','WeekCounter4', 'MonthCounter4','YearCounter4'  
                                   ) THEN
               
               


               L_NEW_CNT := NULL;
               IF L_FIELD_NAME = 'DayCounter' THEN

                  UPDATE UTWEEKNR
                  SET DAY_CNT = NVL(DAY_CNT,0)+1
                  WHERE DAY_OF_YEAR = TO_TIMESTAMP_TZ(TO_CHAR(L_REF_DATE,'DD/MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING DAY_CNT INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'WeekCounter' THEN
                  

                  OPEN C_WEEK(L_REF_DATE);
                  L_PREVIOUS_WEEK_NR := NULL;
                  L_WEEK_NR          := NULL;
                  L_DAY              := NULL;
                  WHILE NVL(L_PREVIOUS_WEEK_NR,-1) = NVL(L_WEEK_NR, -1) LOOP
                     FETCH C_WEEK INTO L_DAY,L_WEEK_NR;
                     IF C_WEEK%NOTFOUND THEN
                        UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                        RAISE STPERROR;
                     END IF;
                     IF NVL(L_PREVIOUS_WEEK_NR,L_WEEK_NR) = L_WEEK_NR THEN
                        L_FIRST_DAY_OF_WEEK := L_DAY;
                        L_PREVIOUS_WEEK_NR  := L_WEEK_NR;
                     END IF;
                  END LOOP;
                  CLOSE C_WEEK;

                  UPDATE UTWEEKNR
                  SET WEEK_CNT = NVL(WEEK_CNT,0)+1
                  WHERE DAY_OF_YEAR = L_FIRST_DAY_OF_WEEK
                  RETURNING WEEK_CNT INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'MonthCounter' THEN

                  UPDATE UTYEARNR
                  SET MONTH_CNT = NVL(MONTH_CNT,0)+1
                  WHERE MONTH_OF_YEAR = TO_TIMESTAMP_TZ('01/'||TO_CHAR(L_REF_DATE,'MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING MONTH_CNT INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'YearCounter' THEN

                  UPDATE UTYEARNR
                  SET YEAR_CNT = NVL(YEAR_CNT,0)+1
                  WHERE MONTH_OF_YEAR = TO_TIMESTAMP_TZ('01/01/'||TO_CHAR(L_REF_DATE,'YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING YEAR_CNT INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;
               
               
             ELSIF L_FIELD_NAME = 'DayCounter1' THEN

                  UPDATE UTWEEKNR
                  SET DAY_CNT1 = NVL(DAY_CNT1,0)+1
                  WHERE DAY_OF_YEAR = TO_TIMESTAMP_TZ(TO_CHAR(L_REF_DATE,'DD/MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING DAY_CNT1 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'WeekCounter1' THEN
                  

                  OPEN C_WEEK(L_REF_DATE);
                  L_PREVIOUS_WEEK_NR := NULL;
                  L_WEEK_NR          := NULL;
                  L_DAY              := NULL;
                  WHILE NVL(L_PREVIOUS_WEEK_NR,-1) = NVL(L_WEEK_NR, -1) LOOP
                     FETCH C_WEEK INTO L_DAY,L_WEEK_NR;
                     IF C_WEEK%NOTFOUND THEN
                        UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                        RAISE STPERROR;
                     END IF;
                     IF NVL(L_PREVIOUS_WEEK_NR,L_WEEK_NR) = L_WEEK_NR THEN
                        L_FIRST_DAY_OF_WEEK := L_DAY;
                        L_PREVIOUS_WEEK_NR  := L_WEEK_NR;
                     END IF;
                  END LOOP;
                  CLOSE C_WEEK;

                  UPDATE UTWEEKNR
                  SET WEEK_CNT1 = NVL(WEEK_CNT1,0)+1
                  WHERE DAY_OF_YEAR = L_FIRST_DAY_OF_WEEK
                  RETURNING WEEK_CNT1 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'MonthCounter1' THEN

                  UPDATE UTYEARNR
                  SET MONTH_CNT1 = NVL(MONTH_CNT1,0)+1
                  WHERE MONTH_OF_YEAR = TO_TIMESTAMP_TZ('01/'||TO_CHAR(L_REF_DATE,'MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING MONTH_CNT1 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'YearCounter1' THEN

                  UPDATE UTYEARNR
                  SET YEAR_CNT1 = NVL(YEAR_CNT1,0)+1
                  WHERE MONTH_OF_YEAR = TO_TIMESTAMP_TZ('01/01/'||TO_CHAR(L_REF_DATE,'YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING YEAR_CNT1 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;
               
               ELSIF L_FIELD_NAME = 'DayCounter2' THEN

                  UPDATE UTWEEKNR
                  SET DAY_CNT2 = NVL(DAY_CNT2,0)+1
                  WHERE DAY_OF_YEAR = TO_TIMESTAMP_TZ(TO_CHAR(L_REF_DATE,'DD/MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING DAY_CNT2 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'WeekCounter2' THEN
                  

                  OPEN C_WEEK(L_REF_DATE);
                  L_PREVIOUS_WEEK_NR := NULL;
                  L_WEEK_NR          := NULL;
                  L_DAY              := NULL;
                  WHILE NVL(L_PREVIOUS_WEEK_NR,-1) = NVL(L_WEEK_NR, -1) LOOP
                     FETCH C_WEEK INTO L_DAY,L_WEEK_NR;
                     IF C_WEEK%NOTFOUND THEN
                        UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                        RAISE STPERROR;
                     END IF;
                     IF NVL(L_PREVIOUS_WEEK_NR,L_WEEK_NR) = L_WEEK_NR THEN
                        L_FIRST_DAY_OF_WEEK := L_DAY;
                        L_PREVIOUS_WEEK_NR  := L_WEEK_NR;
                     END IF;
                  END LOOP;
                  CLOSE C_WEEK;

                  UPDATE UTWEEKNR
                  SET WEEK_CNT2 = NVL(WEEK_CNT2,0)+1
                  WHERE DAY_OF_YEAR = L_FIRST_DAY_OF_WEEK
                  RETURNING WEEK_CNT2 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'MonthCounter2' THEN

                  UPDATE UTYEARNR
                  SET MONTH_CNT2 = NVL(MONTH_CNT2,0)+1
                  WHERE MONTH_OF_YEAR = TO_TIMESTAMP_TZ('01/'||TO_CHAR(L_REF_DATE,'MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING MONTH_CNT2 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'YearCounter2' THEN

                  UPDATE UTYEARNR
                  SET YEAR_CNT2 = NVL(YEAR_CNT2,0)+1
                  WHERE MONTH_OF_YEAR = TO_TIMESTAMP_TZ('01/01/'||TO_CHAR(L_REF_DATE,'YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING YEAR_CNT2 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;
                
               ELSIF L_FIELD_NAME = 'DayCounter3' THEN

                  UPDATE UTWEEKNR
                  SET DAY_CNT3 = NVL(DAY_CNT3,0)+1
                  WHERE DAY_OF_YEAR = TO_TIMESTAMP_TZ(TO_CHAR(L_REF_DATE,'DD/MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING DAY_CNT3 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'WeekCounter3' THEN
                  

                  OPEN C_WEEK(L_REF_DATE);
                  L_PREVIOUS_WEEK_NR := NULL;
                  L_WEEK_NR          := NULL;
                  L_DAY              := NULL;
                  WHILE NVL(L_PREVIOUS_WEEK_NR,-1) = NVL(L_WEEK_NR, -1) LOOP
                     FETCH C_WEEK INTO L_DAY,L_WEEK_NR;
                     IF C_WEEK%NOTFOUND THEN
                        UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                        RAISE STPERROR;
                     END IF;
                     IF NVL(L_PREVIOUS_WEEK_NR,L_WEEK_NR) = L_WEEK_NR THEN
                        L_FIRST_DAY_OF_WEEK := L_DAY;
                        L_PREVIOUS_WEEK_NR  := L_WEEK_NR;
                     END IF;
                  END LOOP;
                  CLOSE C_WEEK;

                  UPDATE UTWEEKNR
                  SET WEEK_CNT3 = NVL(WEEK_CNT3,0)+1
                  WHERE DAY_OF_YEAR = L_FIRST_DAY_OF_WEEK
                  RETURNING WEEK_CNT3 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'MonthCounter3' THEN

                  UPDATE UTYEARNR
                  SET MONTH_CNT3 = NVL(MONTH_CNT3,0)+1
                  WHERE MONTH_OF_YEAR = TO_TIMESTAMP_TZ('01/'||TO_CHAR(L_REF_DATE,'MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING MONTH_CNT3 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'YearCounter3' THEN

                  UPDATE UTYEARNR
                  SET YEAR_CNT3 = NVL(YEAR_CNT3,0)+1
                  WHERE MONTH_OF_YEAR = TO_TIMESTAMP_TZ('01/01/'||TO_CHAR(L_REF_DATE,'YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING YEAR_CNT3 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;
              
               ELSIF L_FIELD_NAME = 'DayCounter4' THEN

                  UPDATE UTWEEKNR
                  SET DAY_CNT4 = NVL(DAY_CNT4,0)+1
                  WHERE DAY_OF_YEAR = TO_TIMESTAMP_TZ(TO_CHAR(L_REF_DATE,'DD/MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING DAY_CNT4 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'WeekCounter4' THEN
                  

                  OPEN C_WEEK(L_REF_DATE);
                  L_PREVIOUS_WEEK_NR := NULL;
                  L_WEEK_NR          := NULL;
                  L_DAY              := NULL;
                  WHILE NVL(L_PREVIOUS_WEEK_NR,-1) = NVL(L_WEEK_NR, -1) LOOP
                     FETCH C_WEEK INTO L_DAY,L_WEEK_NR;
                     IF C_WEEK%NOTFOUND THEN
                        UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                        RAISE STPERROR;
                     END IF;
                     IF NVL(L_PREVIOUS_WEEK_NR,L_WEEK_NR) = L_WEEK_NR THEN
                        L_FIRST_DAY_OF_WEEK := L_DAY;
                        L_PREVIOUS_WEEK_NR  := L_WEEK_NR;
                     END IF;
                  END LOOP;
                  CLOSE C_WEEK;

                  UPDATE UTWEEKNR
                  SET WEEK_CNT4 = NVL(WEEK_CNT4,0)+1
                  WHERE DAY_OF_YEAR = L_FIRST_DAY_OF_WEEK
                  RETURNING WEEK_CNT4 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'MonthCounter4' THEN

                  UPDATE UTYEARNR
                  SET MONTH_CNT4 = NVL(MONTH_CNT4,0)+1
                  WHERE MONTH_OF_YEAR = TO_TIMESTAMP_TZ('01/'||TO_CHAR(L_REF_DATE,'MM/YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING MONTH_CNT4 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;

               ELSIF L_FIELD_NAME = 'YearCounter4' THEN

                  UPDATE UTYEARNR
                  SET YEAR_CNT4 = NVL(YEAR_CNT4,0)+1
                  WHERE MONTH_OF_YEAR = TO_TIMESTAMP_TZ('01/01/'||TO_CHAR(L_REF_DATE,'YYYY')||' 00:00:00 '||DBTIMEZONE, 'DD/MM/YYYY HH24:MI:SS TZR')
                  RETURNING YEAR_CNT4 INTO L_NEW_CNT;
                  IF SQL%ROWCOUNT=0 THEN
                     UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_OUTOFCALENDAR;
                     RAISE STPERROR;
                  END IF;
       
               
               END IF;

               IMPOSEDIGITS (L_NEW_CNT , L_QUALIFIER , L_NEW_VAL);
               
               

            ELSE 
               
               
               IF L_FIELD_NAME IS NOT NULL THEN
                  L_COUNTER(L_NR_FIELDS) := '1';
               END IF;
            END IF;

            
            IF L_FIELD_NAME IS NOT NULL THEN
               L_NEW_VAL := L_NEW_VAL || '}';
            END IF;
         END IF;

         
         IF (LOOP_NR = 2) AND L_SP_FLD_OR_CT THEN
            
            IF L_COUNTER(L_NR_FIELDS) = '1' THEN
               L_FOUND := FALSE ;
               FOR L_ROW IN 1..A_NR_OF_ROWS LOOP
                  IF A_FIELDNAMES_TAB(L_ROW) = L_FIELD_NAME THEN
                     
                     
                     
                     
                     
                     L_END_PREV   := INSTR(L_NEW_VAL, '{', 1, L_NR_FIELDS);
                     L_NEW_VAL_BEFORE_CT := SUBSTR(L_NEW_VAL, 1, L_END_PREV);
                     
                     L_START_PREV := INSTR(L_NEW_VAL, '}', 1, L_NR_FIELDS);
                     L_NEW_VAL_AFTER_CT := SUBSTR(L_NEW_VAL, L_START_PREV);
                     
                     L_NEW_VAL := L_NEW_VAL_BEFORE_CT ||
                                  IMPOSE_QUALIFIER(A_FIELDVALUES_TAB(L_ROW), L_QUALIFIER) ||
                                  L_NEW_VAL_AFTER_CT;
                     L_FOUND := TRUE;
                     EXIT;
                  END IF;
               END LOOP;
               IF L_FOUND = FALSE THEN
                  L_COUNTER_FOUND := FALSE;
                  OPEN C_UTCOUNTER_CURSOR(L_FIELD_NAME);
                  FETCH C_UTCOUNTER_CURSOR
                  INTO L_COUNTER_EXISTS;
                  L_COUNTER_FOUND := C_UTCOUNTER_CURSOR%FOUND;
                  CLOSE C_UTCOUNTER_CURSOR;

                  IF L_COUNTER_FOUND THEN
                     
                     
                     
                     
                     
                     IF NVL(L_QUALIFIER,' ') = ' ' THEN
                        
                        IF L_NR_FIELDS > 1 THEN
                           
                           L_START_PREV := INSTR(L_NEW_VAL, '{', 1, L_NR_FIELDS - 1);
                           L_END_PREV   := INSTR(L_NEW_VAL, '}', L_START_PREV + 1);
                           L_NEW_F_VAL  := SUBSTR(L_NEW_VAL, L_START_PREV + 1,
                                                   L_END_PREV - L_START_PREV - 1);
                           
                           IF L_CURR_VAL IS NOT NULL THEN
                              L_START_PREV := INSTR(L_CURR_VAL, '{', 1, L_NR_FIELDS - 1);
                              L_END_PREV   := INSTR(L_CURR_VAL, '}', L_START_PREV + 1);
                              L_CURR_F_VAL := SUBSTR(L_CURR_VAL, L_START_PREV + 1,
                                                     L_END_PREV - L_START_PREV - 1);
                           END IF;
                        
                        ELSE
                           
                           L_END := INSTR(L_NEW_VAL, '}', 1);
                           
                           L_START_PREV := INSTR(L_NEW_VAL, '{', L_END + 1);
                           L_END_PREV   := INSTR(L_NEW_VAL, '}', L_END + 1);
                           L_NEW_F_VAL  := SUBSTR(L_NEW_VAL, L_START_PREV + 1,
                                                   L_END_PREV - L_START_PREV - 1);
                           
                           IF L_CURR_VAL IS NOT NULL THEN
                              
                              L_END := INSTR(L_CURR_VAL, '}', 1);
                              
                              L_START_PREV := INSTR(L_CURR_VAL, '{', L_END + 1);
                              L_END_PREV   := INSTR(L_CURR_VAL, '}', L_END + 1);
                              L_CURR_F_VAL := SUBSTR(L_CURR_VAL, L_START_PREV + 1,
                                                     L_END_PREV - L_START_PREV - 1);
                           END IF;
                        END IF;
                     
                     ELSE
                        
                        L_START_UC_STRU:= INSTR(L_UC_STRUCTURE, '{' || L_QUALIFIER, 1, 1);
                        
                        IF (L_START_UC_STRU = 0) THEN
                           L_CURR_F_VAL := '';  
                           L_NEW_F_VAL  := '';
                        
                        ELSE
                           
                           L_POS_UC_STRU := 0;
                           L_BRACE_CNT := 0;
                           WHILE L_POS_UC_STRU < L_START_UC_STRU LOOP
                              L_POS_UC_STRU := INSTR(L_UC_STRUCTURE, '{',
                                                     L_POS_UC_STRU + 1);
                              L_BRACE_CNT := L_BRACE_CNT + 1;
                           END LOOP;
                           
                           L_START_PREV := INSTR(L_NEW_VAL, '{', 1, L_BRACE_CNT);
                           L_END_PREV   := INSTR(L_NEW_VAL, '}', L_START_PREV + 1);
                           L_NEW_F_VAL  := SUBSTR(L_NEW_VAL, L_START_PREV + 1,
                                                  L_END_PREV - L_START_PREV - 1);
                           
                           IF L_CURR_VAL IS NOT NULL THEN
                              L_START_PREV := INSTR(L_CURR_VAL, '{', 1, L_BRACE_CNT);
                              L_END_PREV   := INSTR(L_CURR_VAL, '}', L_START_PREV + 1);
                              L_CURR_F_VAL := SUBSTR(L_CURR_VAL, L_START_PREV + 1,
                                                     L_END_PREV - L_START_PREV - 1);
                           END IF;
                        END IF;
                     END IF;

                     
                     IF (L_CURR_F_VAL <> L_NEW_F_VAL) THEN
                        L_RESULT := RESETCOUNTER(L_FIELD_NAME);
                        IF L_RESULT <> 0 THEN
                           UNAPIGEN.P_TXN_ERROR := L_RESULT;
                           RAISE STPERROR;
                        END IF;
                     END IF;
                     
                     L_RESULT := CREATENEXTCOUNTERVALUE(L_FIELD_NAME, L_C_VAL);
                     IF L_RESULT <> 0 THEN
                        UNAPIGEN.P_TXN_ERROR := L_RESULT;
                        RAISE STPERROR;
                     END IF;
                     
                     
                     
                     
                     
                     L_END_PREV   := INSTR(L_NEW_VAL, '{', 1, L_NR_FIELDS);
                     L_NEW_VAL_BEFORE_CT := SUBSTR(L_NEW_VAL, 1, L_END_PREV);
                     
                     L_START_PREV := INSTR(L_NEW_VAL, '}', 1, L_NR_FIELDS);
                     L_NEW_VAL_AFTER_CT := SUBSTR(L_NEW_VAL, L_START_PREV);
                     
                     L_NEW_VAL := L_NEW_VAL_BEFORE_CT || L_C_VAL || L_NEW_VAL_AFTER_CT;
                  END IF;
               END IF;
            END IF;
         END IF;

         L_CURR_POS := L_END_POS + 1;
      END LOOP;
   END LOOP;

   
   L_CURR_VAL_BRACE := L_NEW_VAL;
   L_NEW_VAL := REPLACE(REPLACE(L_NEW_VAL,'}'),'{');

   A_EDIT_ALLOWED := L_EDIT_ALLOWED;
   A_NEXT_VAL := L_NEW_VAL;
   A_VALID_CF := L_VALID_CF;

   UPDATE UTUC
   SET CURR_VAL = L_CURR_VAL_BRACE
   WHERE UC = A_UC
   AND VERSION = A_VERSION;


  --SELECT * FROM UTUCAUDITTRAIL WHERE UC = 'Basic Mask';
/*
...
Basic Mask	0	20210301-005	01-03-2021 10.39.18.000000000 AM	01-03-2021 10.39.19.000000000 AM	UNILAB	Unilink	Unilink	94	21341	SYSTEM	ORACLEPROD	ORACLE.EXE (J005)	01-03-2021 10.38.54.000000000 AM	01-03-2021 10.39.18.000000000 AM CET	01-03-2021 10.39.19.000000000 AM CET	01-03-2021 10.38.54.000000000 AM CET
Basic Mask	0	20210301-006	01-03-2021 10.39.18.000000000 AM	01-03-2021 10.39.19.000000000 AM	UNILAB	Unilink	Unilink	94	21341	SYSTEM	ORACLEPROD	ORACLE.EXE (J005)	01-03-2021 10.38.54.000000000 AM	01-03-2021 10.39.18.000000000 AM CET	01-03-2021 10.39.19.000000000 AM CET	01-03-2021 10.38.54.000000000 AM CET
Basic Mask	0	20210301-007	01-03-2021 10.39.18.000000000 AM	01-03-2021 10.39.19.000000000 AM	UNILAB	Unilink	Unilink	94	21341	SYSTEM	ORACLEPROD	ORACLE.EXE (J005)	01-03-2021 10.38.54.000000000 AM	01-03-2021 10.39.18.000000000 AM CET	01-03-2021 10.39.19.000000000 AM CET	01-03-2021 10.38.54.000000000 AM CET
Basic Mask	0	20210301-008	01-03-2021 10.39.18.000000000 AM	01-03-2021 10.39.19.000000000 AM	UNILAB	Unilink	Unilink	94	21341	SYSTEM	ORACLEPROD	ORACLE.EXE (J005)	01-03-2021 10.38.54.000000000 AM	01-03-2021 10.39.18.000000000 AM CET	01-03-2021 10.39.19.000000000 AM CET	01-03-2021 10.38.54.000000000 AM CET
Basic Mask	0	20210119-001	19-01-2021 10.44.49.000000000 AM	19-01-2021 10.44.49.000000000 AM	UNILAB	Unilink	Unilink	269	711	SYSTEM	ORACLEPROD	ORACLE.EXE (J003)	19-01-2021 10.44.20.000000000 AM	19-01-2021 10.44.49.000000000 AM CET	19-01-2021 10.44.49.000000000 AM CET	19-01-2021 10.44.20.000000000 AM CET
*/   
   IF L_UC_LOG_HS = '1' THEN
      INSERT INTO UTUCAUDITTRAIL
      (UC, VERSION, CURR_VAL, REF_DATE, REF_DATE_TZ, LOGDATE, LOGDATE_TZ,
       US, CLIENT_ID, APPLIC,
       SID, SERIAL#, OSUSER, TERMINAL,  PROGRAM, LOGON_TIME, LOGON_TIME_TZ)
      SELECT A_UC, A_VERSION, A_NEXT_VAL, L_REF_DATE, L_REF_DATE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             UNAPIGEN.P_USER, UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME,
             SID, SERIAL#, OSUSER, TERMINAL, PROGRAM, LOGON_TIME, LOGON_TIME
      FROM V$SESSION
      WHERE AUDSID=USERENV('SESSIONID');
   END IF;

   IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS THEN
      RAISE STPERROR;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      UNAPIGEN.LOGERROR('CreateNextUniqueCodeValue', SQLERRM);
   END IF;
   IF C_UC%ISOPEN THEN
      CLOSE C_UC;
   END IF;
   IF C_RQSCSEQ%ISOPEN THEN
      CLOSE C_RQSCSEQ;
   END IF;
   IF C_WEEK%ISOPEN THEN
      CLOSE C_WEEK;
   END IF;
   IF C_RQSCINITIALSEQ%ISOPEN THEN
      CLOSE C_RQSCINITIALSEQ;
   END IF;
   IF C_UTCOUNTER_CURSOR%ISOPEN THEN
      CLOSE C_UTCOUNTER_CURSOR;
   END IF;
   IF DBMS_SQL.IS_OPEN(L_UC_CURSOR) THEN
      DBMS_SQL.CLOSE_CURSOR(L_UC_CURSOR);
   END IF;
   RETURN(UNAPIGEN.ABORTTXN(UNAPIGEN.P_TXN_ERROR,'CreateNextUniqueCodeValue'));
END INTCREATENEXTUNIQUECODEVALUE;