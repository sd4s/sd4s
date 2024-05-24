CREATE OR REPLACE PACKAGE BODY UNILAB.APAO_OUTDOOR AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_OUTDOOR
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 13/02/2013
--   TARGET : Oracle 10.2.0 / Unilab 6.4
--  VERSION :
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 13/02/2013 | RS        | Created
-- 18/01/2019 | DH        | Subsample algorithm
-- 30/01/2019 | DH        | Split Varchar funtion
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

CURSOR c_system (c_setting_name VARCHAR2) IS
   SELECT setting_value
   FROM utsystem
   WHERE setting_name = c_setting_name;

CURSOR l_jobs_cursor (c_search VARCHAR2) IS
   SELECT job_name, enabled, job_action
   FROM sys.dba_scheduler_jobs
   WHERE INSTR(UPPER(job_action), c_search) <> 0;


--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
PROCEDURE LogError(avs_func_name IN VARCHAR2,
                    avs_msg IN VARCHAR2,
                    avn_lvl IN INTEGER default 4) --0=no_logging, 1=error, 2=warning, 3=info, 4=debug
IS
    lvn_uterror_seq     INTEGER;
    lvn_log_lvl         NUMBER;
    lvs_log_lvl_descr   VARCHAR2(6);
BEGIN
  lvn_log_lvl:=TO_NUMBER(APAOGEN.GETSYSTEMSETTING('LOG_OUTDOOR_LVL', 0));
  IF avn_lvl <= lvn_log_lvl THEN --check whether to log this message
    SELECT UTERROR_SEQ.Nextval
      INTO lvn_uterror_seq
    from dual;

    CASE avn_lvl
      WHEN 1 THEN lvs_log_lvl_descr:='ERROR';
      WHEN 2 THEN lvs_log_lvl_descr:='WARN';
      WHEN 3 THEN lvs_log_lvl_descr:='INFO';
      WHEN 4 THEN lvs_log_lvl_descr:='DEBUG';
      ELSE lvs_log_lvl_descr:='UNKNOWN LOG LEVEL';
    END CASE;

    UNAPIGEN.LogError ( avs_func_name, LPAD(lvn_uterror_seq, 4, '0') || ' - ' || lvs_log_lvl_descr || ' - '|| avs_msg );
   END IF;


END LogError;

FUNCTION SplitVC (a_delimited_txt IN VARCHAR2,
    a_delimiter IN VARCHAR2,
    a_result_tab OUT UNAPIGEN.VC255_TABLE_TYPE)
  RETURN NUMBER
  IS
    lts_result_tab             UNAPIGEN.VC255_TABLE_TYPE;
    lvi_row                    NUMBER:=0;
  BEGIN
    FOR l_line IN (select *
                       from table(APAOFUNCTIONS.split_vc_sql(a_delimited_txt, a_delimiter))
                       ) LOOP
        lvi_row:=lvi_row+1;
        lts_result_tab(lvi_row):=l_line.VC300;
    END LOOP;
    a_result_tab:=lts_result_tab;
    RETURN UNAPIGEN.DBERR_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN SQLCODE;
  END SplitVC;
--

FUNCTION CopySc(avs_sc_from       IN VARCHAR2,
                avs_st_to         IN VARCHAR2,
                avs_sc_to         IN OUT VARCHAR2,
                avs_modify_reason IN VARCHAR2)
RETURN INTEGER IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name || '.CopySc';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code       INTEGER;
lvs_st_to_version  VARCHAR2(20);
lvd_ref_date       TIMESTAMP WITH TIME ZONE;
lvc_copy_ic        VARCHAR2(40);
lvc_copy_pg        VARCHAR2(40);
lvs_userid         VARCHAR2(40);

BEGIN
  lvs_st_to_version  :=  NULL;
  lvd_ref_date       := CURRENT_TIMESTAMP;
  lvc_copy_ic        := 'COPY IC COPY IIVALUE';
  lvc_copy_pg        := 'CREATE PG';
  lvs_userid         := USER;

  lvi_ret_code       := UNAPISC.COPYSAMPLE(avs_sc_from,
                                           avs_st_to,
                                           lvs_st_to_version,
                                           avs_sc_to,
                                           lvd_ref_date,
                                           lvc_copy_ic,
                                           lvc_copy_pg,
                                           lvs_userid,
                                           avs_modify_reason);
  RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    UNAPIGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END CopySc;

FUNCTION AddValueToScGk(avs_sc    IN APAOGEN.NAME_TYPE,
                        avs_gk    IN APAOGEN.GK_TYPE,
                        avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AddValueToScGk';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;

lvs_gk_version      VARCHAR2(20) := '';
lvt_value_tab       UNAPIGEN.VC40_TABLE_TYPE;
lvi_nr_of_rows      NUMBER;
lvs_modify_reason   APAOGEN.MODIFY_REASON_TYPE;

CURSOR lvq_gk(avs_sc IN VARCHAR2,
              avs_gk IN VARCHAR2) IS
  SELECT value
    FROM utscgk
   WHERE sc = avs_sc
     AND gk = avs_gk;

BEGIN
   IF avs_value IS NOT NULL THEN
       lvi_nr_of_rows := 1;
       --------------------------------------------------------------------------------
       -- Retrieve all existing values of scgk avs_gk
       --------------------------------------------------------------------------------
       FOR lvr_gk IN lvq_gk(avs_sc, avs_gk) LOOP
          lvt_value_tab(lvi_nr_of_rows) := lvr_gk.value;
          lvi_nr_of_rows := lvi_nr_of_rows + 1;
       END LOOP;
       --------------------------------------------------------------------
       -- Fill new values of scgk avs_gk
       --------------------------------------------------------------------------------
       lvt_value_tab(lvi_nr_of_rows) := avs_value;
       --------------------------------------------------------------------
       -- Fill modify reason
       --------------------------------------------------------------------------------
       lvs_modify_reason := 'Groupkey assigned by ' || lcs_function_name;
       --------------------------------------------------------------------
       -- Save the scgk avs_gk
       --------------------------------------------------------------------------------
       lvi_ret_code := UNAPISCP.SAVE1SCGROUPKEY(avs_sc,
                                                avs_gk,
                                                lvs_gk_version,
                                                lvt_value_tab,
                                                lvi_nr_of_rows,
                                                lvs_modify_reason);
       IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
          lvs_sqlerrm := 'Assignment of scgk "' || avs_gk || '" with value "' || avs_value || '" failed for "' || avs_sc || '". Returncode <' || lvi_ret_code || '>';
          APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
       END IF;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END AddValueToScGk;

--------------------------------------------------------------------------------
-- FUNCTION : Save1ScGk
-- ABSTRACT : This function will save 1 value for a given sample groukey
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
-- REVIEWER :
--     DATE : 12/09/2012
--   TARGET :
--  VERSION : 6.4
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : INTERNAL
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- 12/09/2012 | RS        | Created
--------------------------------------------------------------------------------
FUNCTION Save1ScGk(avs_sc              IN VARCHAR2,
                   avs_gk              IN VARCHAR2,
                   avs_value           IN VARCHAR2,
                   avs_modify_reason   IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'Save1ScGk';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm                APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code               APAOGEN.RETURN_TYPE;

lvi_nr_of_rows      NUMBER := 1;
lts_value_tab       UNAPIGEN.VC40_TABLE_TYPE;
lvs_gk_version      VARCHAR2(20);
--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
BEGIN

   FOR lvi_row IN 1..lvi_nr_of_rows LOOP
     lts_value_tab(lvi_row) := avs_value;
   END LOOP;

   lvi_ret_code := UNAPISCP.SAVE1SCGROUPKEY(avs_sc,
                                            avs_gk,
                                            lvs_gk_version,
                                            lts_value_tab,
                                            lvi_nr_of_rows,
                                            avs_modify_reason);
   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Saving groupkey <' || avs_gk || '> with value <' || avs_value || '> failed for <' || avs_sc || '>. Returncode <' || lvi_ret_code || '>';
      APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   END IF;

   RETURN lvi_ret_code;

EXCEPTION
WHEN NO_DATA_FOUND THEN
   RETURN NULL;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
        APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN NULL;
END Save1ScGk;

FUNCTION CreateWs(avs_ws            IN OUT VARCHAR2,
                  avs_wt            IN VARCHAR2,
                  avs_modify_reason IN VARCHAR2)
RETURN INTEGER IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name || '.CreateWs';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                    INTEGER;
-- Specific local variables
lvs_wt                          VARCHAR2(20);
lvs_wt_version                  VARCHAR2(20);
lvs_ws                          VARCHAR2(20);
lvd_ref_date                    TIMESTAMP WITH TIME ZONE;
lvs_userid                      VARCHAR2(40);
lvn_nr_of_rows                  NUMBER;
lvs_modify_reason               VARCHAR2(255);
lts_fieldtype_tab_tab           UNAPIGEN.VC20_TABLE_TYPE;
lts_fieldnames_tab_tab          UNAPIGEN.VC20_TABLE_TYPE;
lts_fieldvalues_tab_tab         UNAPIGEN.VC40_TABLE_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
BEGIN
  -- IN and IN OUT arguments
  lvs_ws             := avs_ws;
  lvs_wt             := avs_wt;
  lvs_wt_version     := NULL;
  lvd_ref_date       := CURRENT_TIMESTAMP;
  lvs_userid         := USER;
  lvs_modify_reason  := avs_modify_reason;
  -- array IN and IN  OUT arguments
  lvn_nr_of_rows     :=0;

  FOR lvn_row IN 1..lvn_nr_of_rows  LOOP
     lts_fieldtype_tab_tab(lvn_row)     := '';
     lts_fieldnames_tab_tab(lvn_row)    := '';
     lts_fieldvalues_tab_tab(lvn_row)   := '';
  END LOOP;
  lvi_ret_code := UNAPIWS.CREATEWORKSHEET
                   (lvs_wt,
                    lvs_wt_version,
                    lvs_ws,
                    lvd_ref_date,
                    lvs_userid,
                    lts_fieldtype_tab_tab,
                    lts_fieldnames_tab_tab,
                    lts_fieldvalues_tab_tab,
                    lvn_nr_of_rows,
                    lvs_modify_reason);

   avs_ws := lvs_ws;
   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    UNAPIGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END CreateWs;

FUNCTION GetCodemask4Ws(avs_rq IN VARCHAR2)
RETURN VARCHAR2 IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name || '.GetCodemask4Ws';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvn_rqwsnr                      NUMBER;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
BEGIN

    SELECT COUNT(*) + 1
      INTO lvn_rqwsnr
      FROM utws
     WHERE ws LIKE avs_rq || '%';

    RETURN avs_rq || '-' || lpad(lvn_rqwsnr, 3, '0');

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    UNAPIGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END GetCodemask4Ws;

FUNCTION Save1WsGK(avs_ws               IN VARCHAR2,
                   avs_gk               IN VARCHAR2,
                   avs_gkvalue          IN VARCHAR2,
                   avs_modify_reason    IN VARCHAR2,
                   avs_multiple         IN VARCHAR2 := NULL)
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name || '.Save1WsGK';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code             INTEGER;
lvs_ws                   VARCHAR2(20);
lvs_gk                   VARCHAR2(20);
lvs_gk_version           VARCHAR2(20);
lvi_nr_of_rows           NUMBER;
lvs_modify_reason        VARCHAR2(255);
lvt_value_tab            UNAPIGEN.VC40_TABLE_TYPE;

CURSOR lvq_gk(avs_ws IN VARCHAR2,
              avs_gk IN VARCHAR2) IS
  SELECT value
    FROM utwsgk
   WHERE ws = avs_ws
     AND gk = avs_gk;

BEGIN
  LogError(lcs_function_name, 'begin APAO_OUTDOOR.Save1WsGk');
  lvs_ws             := avs_ws;
  lvs_gk             := avs_gk;
  lvs_gk_version     := NULL;
  lvs_modify_reason  := avs_modify_reason;

   lvi_nr_of_rows := 1;
   --------------------------------------------------------------------------------
   -- Retrieve all existing values of wsgk avs_gk
   --------------------------------------------------------------------------------
   IF avs_multiple IS NOT NULL THEN
      FOR lvr_gk IN lvq_gk(avs_ws, avs_gk) LOOP
         lvt_value_tab(lvi_nr_of_rows) := lvr_gk.value;
         lvi_nr_of_rows := lvi_nr_of_rows + 1;
      END LOOP;
   END IF;
   --------------------------------------------------------------------
   -- Fill new values of wsgk avs_gk
   --------------------------------------------------------------------------------
   lvt_value_tab(lvi_nr_of_rows) := avs_gkvalue;
   lvi_ret_code       := UNAPIWSP.SAVE1WSGROUPKEY(lvs_ws,
                                                 lvs_gk,
                                                 lvs_gk_version,
                                                 lvt_value_tab,
                                                 lvi_nr_of_rows,
                                                 lvs_modify_reason);
  LogError(lcs_function_name, 'end APAO_OUTDOOR.Save1WsGk');
  RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    UNAPIGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END Save1WsGK;

FUNCTION CreateWs4Rq(avs_rq            IN VARCHAR2,
                     avs_modify_reason IN VARCHAR2)
RETURN INTEGER IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name || '.CreateWs4Rq';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                    INTEGER;
lvs_ws                          VARCHAR2(20);
lvn_rownr                       NUMBER;
lvn_ws_modify_flag              NUMBER := UNAPIGEN.MOD_FLAG_INSERT;
lvn_wsnr                        NUMBER;
lvn_sc_already_assigned         NUMBER;
lts_ws_tab                      UNAPIGEN.VC20_TABLE_TYPE; --to create prep-ws.
lvn_nr_of_rows                  INTEGER :=0;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_wt IS
    SELECT a.rq,a.sc, c.pr, d.wt wt,
            MIN( (
            SELECT MIN(a2.ws)
                          FROM utwsgkrequestcode a1,
                               utwsgkavtestmethod b1,
                               utwssc a2,
                               utprau c1,
                               utpr d1
                         WHERE a1.requestcode = a.rq
                           AND a1.ws = b1.ws
                           AND a2.ws=a1.ws
                           --AND a2.sc=a.sc
                           AND b1.avtestmethod = c1.value AND c1.au = 'avTestMethod'
                           AND c1.pr = d1.pr
                           AND c1.pr=c.pr
                           AND c1.version = d1.version AND d1.version_is_current = '1')) known_ws
      FROM utrqsc a,
           utscpa b,
           utprau c,
           utwt d
     WHERE a.rq = avs_rq AND c.au = 'avCustWt'
       AND a.sc = b.sc AND b.pa = c.pr AND b.pr_version = c.version AND c.value = d.wt
  GROUP BY a.rq,a.sc,c.pr,d.wt  -- in geval van Label testing ook een group by sc
  ORDER BY c.pr;


CURSOR lvq_wssc(avs_wt IN VARCHAR2, avs_pr IN VARCHAR2) IS
    SELECT distinct a.sc
      FROM utrqsc a,
           utscpa b,
           utprau c
     WHERE a.rq = avs_rq AND c.au = 'avCustWt'
       AND a.sc = b.sc AND b.pa = c.pr AND b.pr_version = c.version AND c.value = avs_wt
       AND c.pr = avs_pr
  ORDER BY a.sc;

CURSOR lvq_wsii2gk IS
    SELECT b.gk, LTRIM(RTRIM(SUBSTR(a.iivalue,1, 40))) value
      FROM utrqii a, utgkws b
     WHERE a.rq = avs_rq
       AND a.ii = b.gk
     UNION
    SELECT b.gk, LTRIM(RTRIM(SUBSTR(a.iivalue,1, 40))) value
      FROM utscii a, utgkws b, utrqsc c
     WHERE c.rq = avs_rq
       AND a.sc = c.sc
       AND a.ii = b.gk;

CURSOR lvq_paau2gk(avs_pa IN VARCHAR2) IS
  SELECT DISTINCT c.gk, b.value
    FROM utrqsc a, utscpaau b, utgkws c
   WHERE a.rq = avs_rq
     AND a.sc = b.sc AND b.pa = avs_pa
     AND b.au = c.gk
     AND c.gk NOT IN ('avTestMethod','avTestMethodDesc'); -- ignore these gk because they will result in multiple assignments

CURSOR lvq_paaau_testmethod(avs_sc IN VARCHAR2,
                            avs_pr IN VARCHAR2) IS
  SELECT a.value testmethod, b.value testmethoddesc
    FROM utscpaau a,
         utscpaau b
   WHERE a.sc = b.sc
     AND a.pg = b.pg AND a.pgnode = b.pgnode
     AND a.pa = b.pa AND a.panode = b.panode
     AND a.sc = avs_sc
     AND a.pa = avs_pr
     AND a.au = 'avTestMethod'
     AND b.au = 'avTestMethodDesc';

TYPE tp_ws4rq IS TABLE OF lvq_wt%ROWTYPE;
  t_ws4rq tp_ws4rq;
  lvr_wt lvq_wt%ROWTYPE;
  lvn_wt_cnt NUMBER; --counts the handled worksheets
BEGIN
  LogError(lcs_function_name, 'begin ' || lcs_function_name);
  lvn_wsnr := 0;
  lvn_wt_cnt:=0;
  OPEN lvq_wt;
  FETCH lvq_wt BULK COLLECT INTO t_ws4rq;
  CLOSE lvq_wt;

  --Loop until all events in EVENT-table are marked as handled.
  LOOP

    BEGIN
      EXIT WHEN t_ws4rq.COUNT<1; --no data found, no start of loop.
      lvn_wt_cnt:=lvn_wt_cnt+1;
      EXIT WHEN lvn_wt_cnt>999; --endless loop protection
      EXIT WHEN lvn_wt_cnt>t_ws4rq.COUNT; --normal end of loop
      lvr_wt:= t_ws4rq(lvn_wt_cnt);

      --FOR lvr_wt IN lvq_wt LOOP
      -- Get ws-codemask for rq
      --SAVEPOINT UNILAB4; --avoid fetch out of sequence

      IF NVL(lvr_wt.known_ws,'n/a')='n/a' THEN
         lvs_ws        := GetCodemask4Ws(avs_rq);
          -- Create worksheet
          lvi_ret_code  := CreateWs(lvs_ws, lvr_wt.wt, avs_modify_reason || ' (pr=' || lvr_wt.pr || ')');

          IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
             lvn_wsnr := lvn_wsnr + 1;
          END IF;



         lvi_ret_code := Save1WsGK(lvs_ws,
                                 'RequestCode',
                                 avs_rq,
                                 avs_modify_reason);

      ELSE

         lvs_ws:=lvr_wt.known_ws;

      END IF;

      --only add SC when not added yet
      -- Reset row-counter for eachworksheet

       SELECT count(decode(sc,lvr_wt.sc,1)), NVL(max(rownr),0)
              INTO lvn_sc_already_assigned, lvn_rownr
              FROM utwssc
             WHERE ws = lvs_ws;

      IF lvn_sc_already_assigned=0 THEN

      --FOR lvr_wssc IN lvq_wssc(lvr_wt.wt, lvr_wt.pr) LOOP SC is already fetched in level 1.
         -- Retrieve next row-counter
         lvn_rownr    := lvn_rownr + 1;
         -- Set modify_flag to insert
         lvn_ws_modify_flag := UNAPIGEN.MOD_FLAG_INSERT;
         -- Save sample to worksheet
         lvi_ret_code := UNAPIWS.SAVE1WSSCROW(lvs_ws,
                                              lvn_rownr,
                                              lvn_ws_modify_flag,
                                              lvr_wt.sc,
                                              avs_modify_reason);

         IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
            UNAPIGEN.LogError (lcs_function_name, 'Save1WsScRow returned ' || lvi_ret_code || ' for ws <' || lvs_ws || '>');
         END IF;
         -- Save TestMethod and TestMethodDesc to the ws
         FOR lvr_paaau_testmethod IN lvq_paaau_testmethod(lvr_wt.sc, lvr_wt.pr) LOOP
            lvi_ret_code := Save1WsGk(lvs_ws, 'avTestMethod',     lvr_paaau_testmethod.testmethod, avs_modify_reason);
            lvi_ret_code := Save1WsGk(lvs_ws, 'avTestMethodDesc', lvr_paaau_testmethod.testmethoddesc, avs_modify_reason);
         END LOOP;
         FOR lvr_paau2gk IN lvq_paau2gk(lvr_wt.pr) LOOP
            lvi_ret_code := Save1WsGk(lvs_ws, lvr_paau2gk.gk, lvr_paau2gk.value, avs_modify_reason);
         END LOOP;
      END IF; --DH: LOOP replaced by IF

      lvi_ret_code := Save1WsGk(lvs_ws, 'NumberOfVariants', lvn_rownr, avs_modify_reason);

      FOR lvr_wsii2gk IN lvq_wsii2gk LOOP
          lvi_ret_code := Save1WsGk(lvs_ws, lvr_wsii2gk.gk, lvr_wsii2gk.value, avs_modify_reason);
      END LOOP;

      lvn_nr_of_rows:=lvn_nr_of_rows+1;
      lts_ws_tab(lvn_nr_of_rows):=lvs_ws;
      --DH: create or update the prep ws if availlable.
      --lvi_ret_code:=CreateWsPrepOutdoor(lvs_ws, lvs_ws||' is updated');
      --modifying the WS-table will break the cursor. do this outside the loop;
    EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != 1 THEN
        UNAPIGEN.LogError (lcs_function_name, SQLERRM);
      END IF;
    END;
    OPEN lvq_wt;
    FETCH lvq_wt BULK COLLECT INTO t_ws4rq; --query the new situation. maybe 2 scs must be assigned to 1 ws!
    CLOSE lvq_wt;
   END LOOP;


   --lvi_ret_code:=CreateWsPrepOutdoor(lvs_ws, lvs_ws||' is updated');
      --modifying the WS-table will break the cursor.
      --TW 16may2019: commented out to prevent prep ws creation from happening too early
--   IF lvn_wsnr > 0 THEN
--     lvi_ret_code := UNAPIRQP.ADDRQCOMMENT(avs_rq, lvn_wsnr || ' worksheets created/updated');
--
--     FOR lvn_wsnr IN 1..lvn_nr_of_rows LOOP
--         lvi_ret_code:=CreateWsPrepOutdoor(lts_ws_tab(lvn_wsnr), lts_ws_tab(lvn_wsnr)||' is updated');
--     END LOOP;
--   END IF;


   LogError(lcs_function_name, 'end ' || lcs_function_name);
   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    UNAPIGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END CreateWs4Rq;

FUNCTION CreateWsPrepOutdoor(avs_ws            IN VARCHAR2,
                             avs_modify_reason IN VARCHAR2)
RETURN INTEGER IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name || '.CreateWsPrepOutdoor';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                    INTEGER;
lvs_ws                          VARCHAR2(20);
lvd_starttime                   DATE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_ws_codemask IS
SELECT a.requestcode,
       a.requestcode || '-' || MAX(c.subprogramid) ws,
       MAX(c.subprogramid) subprogramid,
       MAX(d.testvehicletype) testvehicletype,
       MAX(e.numberofvariants) numberofvariants,
       (SELECT COUNT(ws) FROM utws WHERE ws = a.requestcode || '-' || c.subprogramid) CREATED
  FROM utwsgkrequestcode a, utwsgkavtestmethod b, utwsgksubprogramid c, utwsgktestvehicletype d, utwsgknumberofvariants e
 WHERE a.ws = avs_ws
   AND a.ws = b.ws
   AND a.ws = c.ws(+)
   AND a.ws = d.ws(+)
   AND a.ws = e.ws(+)
   AND c.subprogramid IS NOT NULL
GROUP BY a.requestcode, c.subprogramid;

CURSOR lvq_wsgk2gk(avs_ws           IN VARCHAR2,
                   avs_rq           IN VARCHAR2,
                   avs_subprogramid IN VARCHAR2) IS
SELECT c.gk, MIN(c.value) value
  FROM utwsgkrequestcode a, utwsgksubprogramid b, utwsgk c,
       utws d, utwtau e, utgkws f
 WHERE a.requestcode = avs_rq AND b.subprogramid = avs_subprogramid -- search for ws within same rq with same subprogramid
   AND d.ws = avs_ws AND d.wt = e.wt AND d.wt_version = e.version AND f.gk = e.au -- search for valid wsgk also defined as wtau
   AND a.ws = b.ws
   AND a.ws = c.ws
   AND c.gk != 'opensheets' -- default gk, don't copy it
   --AND c.gk NOT IN ('NumberOfVariants') -- handled seperately
 GROUP BY c.gk;

/*
CURSOR lvq_wsgktestmethod2gk(avs_ws           IN VARCHAR2,
                             avs_rq           IN VARCHAR2,
                             avs_subprogramid IN VARCHAR2) IS
SELECT c.gk, c.value
  FROM utwsgkrequestcode a, utwsgksubprogramid b, utwsgk c,
       utws d, utwtau e, utgkws f
 WHERE a.requestcode = avs_rq AND b.subprogramid = avs_subprogramid -- search for ws within same rq with same subprogramid
   AND d.ws = avs_ws AND d.wt = e.wt AND d.wt_version = e.version AND f.gk = e.au -- search for valid wsgk also defined as wtau
   AND a.ws = b.ws
   AND a.ws = c.ws
   AND c.gk IN ('avTestMethod','avTestMethodDesc');
*/
BEGIN
    UNAPIGEN.LogError (lcs_function_name, 'start ' || lcs_function_name);
    lvd_starttime:=SYSDATE;
    FOR lvr_ws IN lvq_ws_codemask LOOP
       --SAVEPOINT UNILAB4; --avoid fetch out of sequence
       --------------------------------------------------------------------------------
       -- Create worksheet PCTOutdoorPrep
       --------------------------------------------------------------------------------
       IF lvr_ws.created = '0' THEN
          lvi_ret_code  := CreateWs(lvr_ws.ws, 'PCTOutdoorPrep', avs_modify_reason);
       END IF;
       --------------------------------------------------------------------------------
       -- Assign attributes of worksheettype as groupkey to the new created worksheet
       --------------------------------------------------------------------------------
       LogError (lcs_function_name, 'starttime: ' || SYSDATE || ' APAO_OUTDOOR.CopyWtAu2WsGk.' );
       lvi_ret_code := APAO_OUTDOOR.CopyWtAu2WsGk(lvr_ws.ws, avs_modify_reason);
       LogError (lcs_function_name, 'endtime: ' || SYSDATE || ' APAO_OUTDOOR.CopyWtAu2WsGk.' );
       --------------------------------------------------------------------------------
       -- Assign worksheetgroupkeyvalues of other worhsheets within the same request and
       -- same subprogramid as groupkey to the new created worksheet
       --------------------------------------------------------------------------------
       LogError (lcs_function_name, 'starttime: ' || SYSDATE || ' Save1WsGK in a loop.' );
       FOR lvr_wsgk2gk IN lvq_wsgk2gk(lvr_ws.ws,
                                      lvr_ws.requestcode,
                                      lvr_ws.subprogramid) LOOP
         IF lvr_wsgk2gk.gk = 'NumberOfVariants' THEN
            lvi_ret_code := Save1WsGK(lvr_ws.ws, lvr_wsgk2gk.gk, lvr_ws.numberofvariants, avs_modify_reason);
         ELSE
            lvi_ret_code := Save1WsGk(lvr_ws.ws, lvr_wsgk2gk.gk, lvr_wsgk2gk.value, avs_modify_reason);
         END IF;
       END LOOP;
       LogError (lcs_function_name, 'endtime: ' || SYSDATE || ' Save1WsGK in a loop.' );
       --------------------------------------------------------------------------------
       -- Assign worksheetgroupkeyvalues avTestMethod and avTestMethodDesc multiple times
       --------------------------------------------------------------------------------
       /*
       FOR lvr_wsgk2gk IN lvq_wsgktestmethod2gk(lvr_ws.ws,
                                                lvr_ws.requestcode,
                                                lvr_ws.subprogramid) LOOP
         lvi_ret_code := Save1WsGk(lvr_ws.ws, lvr_wsgk2gk.gk, lvr_wsgk2gk.value, avs_modify_reason, 'MULTIPLE_VALUES');
       END LOOP;
       */
       /*
       lvi_ret_code := Save1WsGK(lvr_ws.ws,
                                 'NumberOfVariants',
                                 lvr_ws.numberofvariants,
                                 avs_modify_reason);
       */
       --DH: add samples and methods to this prep-worksheet when necessary.
       lvi_ret_code := APAO_OUTDOOR.InsertWorksheetEvent(lvr_ws.ws, avs_modify_reason);

    END LOOP;

    UNAPIGEN.LogError (lcs_function_name, 'end ' || lcs_function_name);
    RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    UNAPIGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END CreateWsPrepOutdoor;

FUNCTION CreateSubSamples(avs_ws            IN VARCHAR2,
                         avs_modify_reason IN VARCHAR2)
--------------------------------------------------------------------------------
-- Created by DH 19-02-2019
-- Creates subsamples
--------------------------------------------------------------------------------
RETURN INTEGER IS
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name || '.CreateSubSamples';
BEGIN

    --Made Async.
    RETURN APAO_OUTDOOR.InsertWorksheetEvent(avs_ws, avs_modify_reason);


EXCEPTION
WHEN OTHERS THEN
  APAOGEN.LogError (lcs_function_name, 'Debug-DH, AOPA_OUTDOOR.CreateSubSamples(' || UNAPIEV.P_WS || ') Exception!');
  --
  IF SQLCODE != 1 THEN
    UNAPIGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END CreateSubSamples;


FUNCTION HandleCreateSubSamples(avs_ws            IN VARCHAR2,
                                avs_modify_reason IN VARCHAR2)
--------------------------------------------------------------------------------
-- Created by DH 18-01-2019, renamed 19-02-2019
-- Creates subsamples
--------------------------------------------------------------------------------
RETURN INTEGER IS

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name || '.HandleCreateSubSamples';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code             INTEGER := UNAPIGEN.DBERR_NORECORDS;
lvs_part_no              VARCHAR2(20); --to avoid clearing of data by additional call.
lvs_codemask_new_sc      VARCHAR2(20); --to build the code mask.
lts_au_tab         UNAPIGEN.VC20_TABLE_TYPE;
lts_au_version_tab UNAPIGEN.VC20_TABLE_TYPE;
lts_value_tab      UNAPIGEN.VC40_TABLE_TYPE;
lvs_ws                   VARCHAR2(20); --to avoid clearing of data by additional call.

lts_sub_sc_mounting_au        UNAPIGEN.VC20_TABLE_TYPE; --to get Wheelentity mmethod
lts_sub_sc_mounting_au_value  UNAPIGEN.VC20_TABLE_TYPE; --to get Wheelentity methodcell to update part_no for
lvn_sub_sc_mounting_cnt NUMBER;
lvn_sub_sc_mounting_reanalys  NUMBER;

lts_sub_sc_tab           UNAPIGEN.VC20_TABLE_TYPE; --to create the sub sample
ltn_sub_sc_created_tab   UNAPIGEN.NUM_TABLE_TYPE; --to know when to create new sub samples
lts_sub_st_tab           UNAPIGEN.VC20_TABLE_TYPE; --to create the sub sample
lts_part_no_tab          UNAPIGEN.VC40_TABLE_TYPE; --to assign the sub part no
lts_rq_tab               UNAPIGEN.VC20_TABLE_TYPE; --to assign the request code
ltn_set_size_tab         UNAPIGEN.NUM_TABLE_TYPE; --to know the amount of sc to create
lts_sub_pg_tab           UNAPIGEN.VC20_TABLE_TYPE; --to assign the sub group
lts_sub_ppversion_tab    UNAPIGEN.VC20_TABLE_TYPE; --to assign the sub group
lts_sub_pa_tab           UNAPIGEN.VC20_TABLE_TYPE; --to assign the sub parameter
lts_sub_prversion_tab    UNAPIGEN.VC20_TABLE_TYPE; --to assign the sub group
lts_sub_me_tab           UNAPIGEN.VC20_TABLE_TYPE; --to assign the sub method+cell
lts_sub_mtversion_tab    UNAPIGEN.VC20_TABLE_TYPE; --to assign the sub group
lts_super_sc_tab         UNAPIGEN.VC20_TABLE_TYPE; --points to original sc
lts_super_pg_tab         UNAPIGEN.VC40_TABLE_TYPE; --points to original pg#pgnode
lts_super_pa_tab         UNAPIGEN.VC40_TABLE_TYPE; --points to original pa#panode
lts_super_me_tab         UNAPIGEN.VC40_TABLE_TYPE; --points to original me#menode
lts_super_me_link_tab    UNAPIGEN.VC255_TABLE_TYPE; --points to original importId#sc#....#menode
lts_sub_progid_tab       UNAPIGEN.VC40_TABLE_TYPE; --holds the subprogram id
lts_position_tab         UNAPIGEN.VC255_TABLE_TYPE; --result of the split
lts_position_id_tab      UNAPIGEN.VC255_TABLE_TYPE; --position belonging to the sub-sc-tab array for the id
lvn_position_row         NUMBER;

lvn_subsc_rows           NUMBER;
lvn_subsc_row            NUMBER;
lvn_subsc_cnt            NUMBER;
lvn_subsc_offset         NUMBER; --number to add to the sc code for additional samples
lvs_sub_sc_id            VARCHAR2(20);
lvn_pgnode               NUMBER;
lvs_pp_version           VARCHAR2(20);
lvn_panode               NUMBER;
lvs_pr_version           VARCHAR2(20);
lvn_menode               NUMBER;
lvs_au_version           VARCHAR2(20);
lvn_ws_modify_flag       NUMBER := UNAPIGEN.MOD_FLAG_INSERT;
lvn_posnr                NUMBER;
lvn_sc_already_assigned  NUMBER;
lvn_max_ws_pos           NUMBER;
lvs_super_sc             VARCHAR2(20);
lvn_reanalysis           NUMBER;
lvn_cnt_subprogid        NUMBER;
lvn_cnt_ws               NUMBER;
lvn_cnt                  NUMBER;
lvn_sample_exists        NUMBER;
lvn_subsc_exists_in_ws   NUMBER;

lvd_start_datetime       DATE;
lvd_sub         DATE;
lvd_loop1_1   DATE;
lvd_loop1_2   DATE;
lvd_loop1_3   DATE;
lvd_loop1_4   DATE;
lvd_loop1_5   DATE;
lvd_loop2_1   DATE;
lvd_loop2_2   DATE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_rq_progid(avs_ws IN VARCHAR2) IS
SELECT a.requestcode, b.subprogramid
  FROM utwsgkrequestcode a,
       utwsgksubprogramid b
 WHERE a.ws = avs_ws
   AND a.ws = b.ws;

CURSOR lvq_worksheets_in_rq(avs_requestcode IN VARCHAR2,
                            avs_subprogramid IN VARCHAR2) IS
SELECT a.ws
  FROM utwsgksubprogramid a,
       utwsgkrequestcode b
 WHERE b.requestcode = avs_requestcode
   AND a.subprogramid = avs_subprogramid
   AND a.ws = b.ws;

CURSOR lvq_subprogid_details(avs_odws IN VARCHAR2) IS
SELECT a.avtestmethod,
       b.numberofrefs,
       c.refsetdesc,
       d.sc,
       e.testsetposition
       ,subprogram.SubProgramId
       ,TO_NUMBER(NVL(f.NumberOfVariants,'1')) NumberOfVariants
       ,COUNT(DISTINCT sub_method.SC) scs_already_created
     --if scs_already_created is less than nr_of_variants*(positions), create 1 subsample for each position.
     --  make sure to start the next counter of sub_sample at (total #variants)+1
     --  for example if 16 sub-samples are created for super_sample 1 (Y2.1.FL...Y2.4.FR):
     --  the new sub-sample must count (Y2.5.FL...Y2.5.FR) if the new #variants is 1.
     --  this is (4 variants*4 positions)/4 (created)+(1..#variants) and then (position1,...position x)
     --if scs_already_created is more than nr_of_variants*(positions), don't create
  FROM utwsgkavtestmethod a,
       utwsgknumberofrefs b,
       utwsgkrefsetdesc c,
       utwssc d,
       utwsgktestsetposition e,
       utwsgkNumberOfVariants f
       ,utwsgkSubProgramId subprogram
       ,utscmeau sub_method
 WHERE a.ws = avs_odws
   AND b.ws(+) = a.ws
   AND c.ws(+) = a.ws
   AND d.ws = a.ws
   AND e.ws(+) = a.ws
   AND f.ws(+) = a.ws
   AND subprogram.ws(+) = a.ws --to identify number of different subprograms
   AND sub_method.au(+)='avSuperSampleSc' --to identify sub-sample method
   AND sub_method.value(+)=d.sc --to identify sub-sample method
GROUP BY a.avtestmethod, --each testmethod needs 1..nr_of_variants*(positions) sub-samples
       b.numberofrefs, --each nr of refs needs 1..nr_of_variants*(positions) sub-samples
       c.refsetdesc, --each nr of refs needs 1..nr_of_variants*(positions) sub-samples
       d.sc, --each super sample needs 1..nr_of_variants*(positions) sub-samples
       e.testsetposition -- to the know positions (may vary by super_sample) for the sub-samples
       ,subprogram.SubProgramId --each subprogram sample needs 1..nr_of_variants*(positions) sub-samples
       ,f.NumberOfVariants --to know the nr_of_variants
ORDER BY scs_already_created DESC;

CURSOR lvq_part_no (avs_sc IN VARCHAR2, avs_subprog_id IN VARCHAR2) IS
SELECT ii.iivalue, substr(ii.ic,-2) as position,
       meau_1.*,
       meau_1.value as avCustSubSampleST,
       (select version from uvst where st=meau_1.value and version_is_current='1') avCustSubSampleSTVersion,
       meau_2.value as avCustSubSamplePP,
       (select version from utpp where pp=meau_2.value and pp_key1=meau_1.value and version_is_current='1') avCustSubSamplePPVersion,
       meau_3.value as avCustSubSamplePR,
       (select version from utpr where pr=meau_3.value and version_is_current='1') avCustSubSamplePRVersion,
       meau_4.value as avCustSubSampleMT,
       (select version from uvmt where mt=meau_4.value and version_is_current='1') avCustSubSampleMTVersion,
       NVL(megk_1.ImportId,'unknown ImportId') as MeLink,
       paau_1.value as SubProgramID
 FROM utscii ii
 JOIN utscmeau meau_1 on meau_1.sc=ii.sc and meau_1.au='avCustSubSampleST'
 JOIN utscmeau meau_2 on meau_2.sc=ii.sc
  and meau_2.sc=meau_1.sc
  and meau_2.pg=meau_1.pg
  and meau_2.pgnode=meau_1.pgnode
  and meau_2.pa=meau_1.pa
  and meau_2.panode=meau_1.panode
  and meau_2.me=meau_1.me
  and meau_2.menode=meau_1.menode
  and meau_2.au='avCustSubSamplePP' --mandatory au
 JOIN utscmeau meau_3 on meau_3.sc=ii.sc
  and meau_3.sc=meau_1.sc
  and meau_3.pg=meau_1.pg
  and meau_3.pgnode=meau_1.pgnode
  and meau_3.pa=meau_1.pa
  and meau_3.panode=meau_1.panode
  and meau_3.me=meau_1.me
  and meau_3.menode=meau_1.menode
  and meau_3.au='avCustSubSamplePR' --mandatory au
 JOIN utscmeau meau_4 on meau_4.sc=ii.sc
  and meau_4.sc=meau_1.sc
  and meau_4.pg=meau_1.pg
  and meau_4.pgnode=meau_1.pgnode
  and meau_4.pa=meau_1.pa
  and meau_4.panode=meau_1.panode
  and meau_4.me=meau_1.me
  and meau_4.menode=meau_1.menode
  and meau_4.au='avCustSubSampleMT' --mandatory au
 LEFT JOIN utscmegkImportId megk_1 on megk_1.sc=ii.sc
  and megk_1.sc=meau_1.sc
  and megk_1.pg=meau_1.pg
  and megk_1.pgnode=meau_1.pgnode
  and megk_1.pa=meau_1.pa
  and megk_1.panode=meau_1.panode
  and megk_1.me=meau_1.me
  and megk_1.menode=meau_1.menode
 JOIN utscpaau paau_1 on paau_1.sc=meau_1.sc
  and paau_1.pg=meau_1.pg
  and paau_1.pgnode=meau_1.pgnode
  and paau_1.pa=meau_1.pa
  and paau_1.panode=meau_1.panode
  and paau_1.au='SubProgramID'
  and paau_1.value=avs_subprog_id
 WHERE ii.sc=avs_sc
   AND ii.ii = 'avPartNoSingleTyre';


CURSOR lc_part_no_ii (avs_sc IN VARCHAR2)
IS
SELECT ic, icnode, ii, iinode
FROM utscii
WHERE SC=avs_sc
 AND IC='avScReqGen'
 AND II='avPartNo';

CURSOR lvq_mounting_partno_config (avs_sub_sc IN VARCHAR2) IS
  SELECT distinct au, value
    FROM utscau
  WHERE sc = avs_sub_sc
    AND au IN ('avMountingMethod', 'avMountingPartNo')
  ORDER BY au ASC;

BEGIN
    LogError(lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples Start.', 3);
    lvn_cnt_subprogid:=0;
    lvn_cnt_ws:=0;
    lvn_cnt:=0;
    lvn_subsc_rows:=0;
    lvn_subsc_offset:=0;
    lvd_start_datetime:=SYSDATE;
    lvs_ws:=avs_ws;
    ----------------------------------------------------------------------------
    -- Retrieve all occurances request/programid for current worksheet
    ----------------------------------------------------------------------------
    FOR lvr_rq_progid IN lvq_rq_progid(lvs_ws) LOOP --loop 1.1
        lvd_loop1_1:=SYSDATE;
        --LogError(lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop1.1 Start.');
        --SAVEPOINT UNILAB4; --avoid fetch out of sequence
        ----------------------------------------------------------------------------
        -- Retrieve all worksheets for these request/programid occurances
        ----------------------------------------------------------------------------
        --UNAPIGEN.LogError (lcs_function_name, LPAD(lvn_cnt, 4, '0') || 'Debug-TW,(' || lvs_ws || ') found programId: ' || lvr_rq_progid.subprogramid);
        lvn_cnt_subprogid:=lvn_cnt_subprogid+1;
        lvn_cnt:=lvn_cnt+1;
        --
        FOR lvr_worksheets_in_rq IN lvq_worksheets_in_rq(lvr_rq_progid.requestcode, lvr_rq_progid.subprogramid) LOOP --loop 1.2
            lvd_loop1_2:=SYSDATE;
            --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop1.2 Start.');
            ----------------------------------------------------------------------------
            --  Retrieve detailed information for these worksheets
            ----------------------------------------------------------------------------
            --
            FOR lvr_ws_details IN lvq_subprogid_details(lvr_worksheets_in_rq.ws) LOOP --loop 1.3 NOTE: lvr_worksheets_in_rq.ws contains the Outdoor-worksheet, avs_ws is the current prep-ws.
                lvd_loop1_3:=SYSDATE;
                --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop1.3 Start.');
                ----------------------------------------------------------------------------
                -- Retrieve all part_no (sample infofields) for the samples of the found requests
                ----------------------------------------------------------------------------
                lvi_ret_code:=SplitVC(lvr_ws_details.testsetposition, ';', lts_position_tab);
                --
                --LogError (lcs_function_name, ' (' || lvs_ws || ') sc+method:' ||
                  --lvr_ws_details.sc||'#'||lvr_ws_details.avtestmethod||' testsetsize:'||lts_position_tab.LAST||'('||lvr_ws_details.testsetposition||')');
               --
                FOR lvr_part_no IN lvq_part_no(lvr_ws_details.sc, lvr_rq_progid.subprogramid) LOOP --loop 1.4
                  --Only make a subsample for the position that is given in the testsetposition au/gk!
                    lvd_loop1_4:=SYSDATE;
                    --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop1.4 Start.');
                  FOR lvn_position_row IN lts_position_tab.FIRST..lts_position_tab.LAST LOOP --loop 1.5
                    lvd_loop1_5:=SYSDATE;
                    --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop1.5 Start.');
                  --
                    IF lts_position_tab(lvn_position_row) = lvr_part_no.position THEN
                    --
                      --
                      lvn_subsc_rows:=lvn_subsc_rows+1;
                      --                                                                (10) + . + Y2 + . + 12 + . + FL >>>> 19 chars left=1.
                      lts_sub_sc_tab(lvn_subsc_rows) :=  lvr_ws_details.sc
                         ||'.'|| SUBSTR(lvr_rq_progid.subprogramid,1,2); --first part to create the sub sample

                      ltn_sub_sc_created_tab (lvn_subsc_rows):=lvr_ws_details.scs_already_created; --existing of new SC's ??

                      lts_sub_st_tab(lvn_subsc_rows) :=  lvr_part_no.avCustSubSampleST;
                      lts_part_no_tab(lvn_subsc_rows):=  SUBSTR(lvr_part_no.iivalue,1,40); --to assign the sub part no
                      lts_rq_tab(lvn_subsc_rows):= lvr_rq_progid.requestcode; --to assign the request code (is 20 max)
                      lts_sub_pg_tab(lvn_subsc_rows) :=  lvr_part_no.avCustSubSamplePP; --to assign the sub group
                      lts_sub_pa_tab(lvn_subsc_rows) :=  lvr_part_no.avCustSubSamplePR; --to assign the sub parameter
                      lts_sub_me_tab(lvn_subsc_rows) :=  lvr_part_no.avCustSubSampleMT; --to assign the sub method+cell
                      --
                      lts_sub_ppversion_tab(lvn_subsc_rows):=lvr_part_no.avCustSubSamplePPVersion; --to assign the sub group
                      lts_sub_prversion_tab(lvn_subsc_rows):=lvr_part_no.avCustSubSamplePRVersion; --to assign the sub group
                      lts_sub_mtversion_tab(lvn_subsc_rows):=lvr_part_no.avCustSubSampleMTVersion; --to assign the sub group
                      --
                      --me link is: ImportId#super_sc#pp#pr#me
                      --
                      lts_super_me_link_tab(lvn_subsc_rows) :=  lvr_part_no.MeLink||'#'||lvr_part_no.SC||'#'||
                         lvr_part_no.PG||'#'||lvr_part_no.PGNODE||'#'||
                         lvr_part_no.PA||'#'||lvr_part_no.PANODE||'#'||
                         lvr_part_no.ME||'#'||lvr_part_no.MENODE; --points to original me

                      lts_super_sc_tab(lvn_subsc_rows) :=  lvr_part_no.SC;
                      lts_super_pg_tab(lvn_subsc_rows) :=  lvr_part_no.PG||'#'||lvr_part_no.PGNODE;
                      lts_super_pa_tab(lvn_subsc_rows) :=  lvr_part_no.PA||'#'||lvr_part_no.PANODE;
                      lts_super_me_tab(lvn_subsc_rows) :=  lvr_part_no.ME||'#'||lvr_part_no.MENODE;

                      lts_sub_progid_tab(lvn_subsc_rows) :=  lvr_part_no.SubProgramID; --holds the subprogram id

                      ltn_set_size_tab(lvn_subsc_rows):=1; --equal to nr of samples! lvr_ws_details.NumberOfVariants; --to know the amount of sc to create

                      lts_position_id_tab(lvn_subsc_rows):=lvr_part_no.position;

                    END IF; --loop 1.5 has a match with given position
                    --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop1.5 End. Started at: ' || lvd_loop1_5);
                  END LOOP; --loop 1.5 find given positions
                --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop1.4 End. Started at: ' || lvd_loop1_4);
                END LOOP; --loop 1.4 sample-info for 4 positions.
                --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop1.3 End. Started at: ' || lvd_loop1_3);
                ----------------------------------------------------------------------------
                -- Fill a temporary table with the information found
                ----------------------------------------------------------------------------
            END LOOP; --loop 1.3 through sub-program details
            --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop1.2 End. Started at: ' || lvd_loop1_2);
        END LOOP; --loop 1.2 through preparation worksheets.
        --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop1.1 End. Started at: ' || lvd_loop1_1);
    END LOOP; --loop 1.1 through sub-programs.

    FOR lvn_subsc_row IN 1..lvn_subsc_rows LOOP --loop 2.1        lvd_loop1_1:=SYSDATE;
        lvd_loop2_1:=SYSDATE;
        --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop2.1 Start.');
        ----------------------------------------------------------------------------
        -- Determine the number of samples in the sub program
        ----------------------------------------------------------------------------
        FOR lvn_subsc_cnt IN 1..ltn_set_size_tab(lvn_subsc_rows) LOOP --loop 2.2
        lvd_loop2_2:=SYSDATE;
        --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop2.2 Start.');
            --SAVEPOINT UNILAB4; --avoid fetch out of sequence
            ----------------------------------------------------------------------------
            -- Only when no samples are created yet for this Subprog/Variant/Position!!
            ----------------------------------------------------------------------------
            ----------------------------------------------------------------------------
            -- Determine the unique code of the new sample
            ----------------------------------------------------------------------------

            lvs_sub_sc_id:=lts_sub_sc_tab(lvn_subsc_row)||'.'||SUBSTR(lts_position_id_tab(lvn_subsc_row),1,2);
            --
            --LogError (lcs_function_name, ' AOPA_OUTDOOR.CreateSubSamples(' || lvs_ws || ') Sub SC:' ||
              --lvs_sub_sc_id);
            --
            --me link is: ImportId#super_sc#pp#pr#me
            --super sample is the super_me_link until the first '#' character;
            lvn_posnr :=INSTR(lts_super_me_link_tab(lvn_subsc_row),'#')+1;
            lvs_super_sc := SUBSTR(lts_super_me_link_tab(lvn_subsc_row),
                 lvn_posnr,
                 INSTR(lts_super_me_link_tab(lvn_subsc_row),'#',lvn_posnr) -lvn_posnr);



            ----------------------------------------------------------------------------
            -- Check if the sample has not been assigned yet to the worksheet
            ----------------------------------------------------------------------------
            SELECT count(decode(sc,lvs_sub_sc_id,1)), max(rownr)
              INTO lvn_sc_already_assigned, lvn_max_ws_pos
              FROM utwssc
             WHERE ws = lvs_ws;

            IF ( lvn_sc_already_assigned = 0 )
            OR ( ltn_sub_sc_created_tab (lvn_subsc_row) = 0 )
            --for example in case the variants 1,2 should in fact be added as variant 3,4
            THEN

               --Determine lvn_subsc_offset when sc_already_created>0
               --don't determin offset when already known.
               IF lvn_sc_already_assigned>0 AND lvn_subsc_offset=0 THEN

                 LogError (lcs_function_name, ' AOPA_OUTDOOR.CreateSubSamples(' || lvs_ws || ') WARNING Additional Sub SC:' ||
                  lvs_sub_sc_id);

                 FOR lvn_subsc_offset IN 1..99 LOOP

                   lvs_sub_sc_id:=lts_sub_sc_tab(lvn_subsc_row)||'.'||SUBSTR(lts_position_id_tab(lvn_subsc_row),1,2);

                   SELECT count(decode(sc,lvs_sub_sc_id,1))
                    INTO lvn_sc_already_assigned
                    FROM utwssc
                   WHERE ws = lvs_ws;

                   EXIT WHEN lvn_sc_already_assigned = 0;
                 END LOOP;

               END IF;

               ----------------------------------------------------------------------------
               -- Copy the sample to the new type, and copy the infocards but ignore the pg.s.
               ----------------------------------------------------------------------------
               lvi_ret_code := UNAPIGEN.BeginTransaction; --CopySC Transaction

               LogError (lcs_function_name, ' starttime: ' || SYSDATE || ' APAO_OUTDOOR.COPYSC sc <' || lvs_sub_sc_id);
               lvi_ret_code := APAO_OUTDOOR.COPYSC(lvs_super_sc, lts_sub_st_tab(lvn_subsc_row), lvs_sub_sc_id , avs_modify_reason);
               --LogError (lcs_function_name, ' endtime: ' || SYSDATE || ' APAO_OUTDOOR.COPYSC <' || lvs_sub_sc_id);

               --LogError (lcs_function_name, ' APAO_OUTDOOR.COPYSC from ' || lvs_super_sc || ' to '||lvs_sub_sc_id||' ret:' || lvi_ret_code);
               --translate 502 DBERR_SCALREADYEXIST into 912 DBERR_NOCURRENTSTVERSION when no version is found.
               IF lvi_ret_code = UNAPIGEN.DBERR_SCALREADYEXIST THEN
                  SELECT COUNT(1)
                    INTO lvn_sc_already_assigned
                    FROM UTST
                   WHERE ST=lts_sub_st_tab(lvn_subsc_row)
                     AND VERSION_IS_CURRENT = '1';
                  IF lvn_sc_already_assigned=0 THEN
                    lvi_ret_code := UNAPIGEN.DBERR_NOCURRENTSTVERSION;
                  END IF;
               END IF; --translate 502 error code

               IF (lvi_ret_code != UNAPIGEN.DBERR_SUCCESS) AND (lvi_ret_code != UNAPIGEN.DBERR_SCALREADYEXIST) THEN

                  --LogError (lcs_function_name, ' CopySample failed for sc <' || lvs_sub_sc_id || '> Function returned :' || lvi_ret_code);
                  lvn_cnt:=lvn_cnt+1;
                  lvi_ret_code := UNAPIGEN.SynchrEndTransaction; --End CopySC Transaction--this can disturb the cursors in the lifecycle actions.
                  --lvi_ret_code := UNAPIGEN.BeginTransaction;
               ELSE

                  lvi_ret_code := UNAPIGEN.SynchrEndTransaction; --End CopySC Transaction--this can disturb the cursors in the lifecycle actions.
                  --lvi_ret_code := UNAPIGEN.BeginTransaction;
                  ----------------------------------------------------------------------------
                  --Assign the sample to the worksheet and increase the sheet size by 1
                  --All underlaying objects should now be created and lifecycle actions should be ready.
                  ----------------------------------------------------------------------------

                  lvn_cnt:=lvn_cnt+1;

                  lvn_max_ws_pos := NVL(lvn_max_ws_pos,0)+1;

                  --LogError (lcs_function_name, ' Add sample <'|| lvs_sub_sc_id ||'> to worksheet  <' || lvs_ws || '> Returned no current version?:' || lvi_ret_code);

                  /*lvi_ret_code := UNAPIIC.AddScInfoDetails (lts_sub_st_tab(lvn_subsc_row),
                                                            NULL, --st_version
                                                            lvs_sub_sc_id,
                                                            'avScReqGen',
                                                            NULL, --ip version
                                                            NULL, --seq
                                                            avs_modify_reason);

                  lvn_cnt:=lvn_cnt+1;
                  UNAPIGEN.LogError (lcs_function_name, LPAD(lvn_cnt, 4, '0') || ' Add IC <avScReqGen> to sample <'|| lvs_sub_sc_id ||'> with return code:' || lvi_ret_code);*/


                  lvn_subsc_exists_in_ws := 0;
                  SELECT count(SC)
                    INTO lvn_subsc_exists_in_ws
                  FROM utwssc
                  WHERE ws = lvs_ws
                  AND sc = lvs_sub_sc_id;
                  --Simple check if SC already present in worksheet
                  --TODOway to prevent code from trying this in the first place?
                  IF lvn_subsc_exists_in_ws=0 THEN
                    INSERT
                      INTO utwssc (ws, rownr, sc)
                    VALUES (lvs_ws, lvn_max_ws_pos, lvs_sub_sc_id);

                     UPDATE utws
                      SET sc_counter = lvn_max_ws_pos,
                            max_rows = lvn_max_ws_pos
                      WHERE ws = lvs_ws;

                    --LogError (lcs_function_name, ' starttime: ' || SYSDATE || ' UNAPIRQ.SAVE1RQSAMPLE sc <' || lvs_sub_sc_id);
                    lvi_ret_code:=UNAPIRQ.SAVE1RQSAMPLE(
                      lts_rq_tab(lvn_subsc_row),
                      lvs_sub_sc_id,
                      CURRENT_TIMESTAMP,
                      'UNILAB',
                      avs_modify_reason);
                    --LogError (lcs_function_name, ' endtime: ' || SYSDATE || ' UNAPIRQ.SAVE1RQSAMPLE sc <' || lvs_sub_sc_id);
                    IF lvi_ret_code=UNAPIGEN.DBERR_SUCCESS THEN
                      UPDATE UTSC SET RQ=lts_rq_tab(lvn_subsc_row)
                      WHERE SC=lvs_sub_sc_id;
                    END IF;
                  END IF;
               END IF;
            END IF;


            --existence of SC in the WS at this point must be guaranteed
            SELECT rownr
              INTO lvn_max_ws_pos
              FROM utwssc
             WHERE ws = lvs_ws
               AND sc = lvs_sub_sc_id;

            --Update PartNo for this sample, this will trigger the update for the PART_NO groupkey.
            --see Event rule InfoFieldValueChanged AssignGroupKey('scgk', 'PART_NO', '~scii@avPartNo~', 1, 20)
            --LogError(lcs_function_name, ' Loop APAOFUNCTIONS.SaveScIi ' || lts_sub_me_tab(lvn_subsc_row) || ' for <' || lvs_sub_sc_id || '>, start ' || SYSDATE);
            FOR l_ii IN lc_part_no_ii(lvs_sub_sc_id) LOOP
               lvi_ret_code:=APAOFUNCTIONS.SaveScIi(lvs_sub_sc_id,
                  l_ii.ic    , l_ii.icnode    ,
                  l_ii.ii    , l_ii.iinode    ,
                  lts_part_no_tab(lvn_subsc_row),
                  avs_modify_reason);
            END LOOP;
            --LogError(lcs_function_name, ' Loop APAOFUNCTIONS.SaveScIi ' || lts_sub_me_tab(lvn_subsc_row) || ' for <' || lvs_sub_sc_id || '>, end ' || SYSDATE);

            SELECT COUNT(1), MAX(pgnode)
              INTO lvn_sc_already_assigned, lvn_pgnode
              FROM UTSCPG
             WHERE SC=lvs_sub_sc_id
               AND PG=lts_sub_pg_tab(lvn_subsc_row);

            IF lvn_sc_already_assigned=0 THEN
              ----------------------------------------------------------------------------
              -- Assign the necessary PG
              ----------------------------------------------------------------------------
              lvi_ret_code := UNAPIGEN.BeginTransaction;--AssignParametergroup Transaction
              lvd_sub:=SYSDATE;
              lvi_ret_code := APAOFUNCTIONS.AssignParametergroup(lvs_sub_sc_id,
                                                   lts_sub_pg_tab(lvn_subsc_row), lvn_pgnode,
                                                   lts_sub_st_tab(lvn_subsc_row), --NOTE: applies to Vredestein config only
                                                   ' ',' ',' ',' ',--NOTE: applies to Vredestein config only
                                                   avs_modify_reason||lts_super_me_link_tab(lvn_subsc_row) --may exceed 255 at very low risk
                                                   );
              --LogError (lcs_function_name, ' AssignParametergroup ' || lts_sub_pg_tab(lvn_subsc_row) || ' done for <' || lvs_sub_sc_id || '> the function took from ' || SYSDATE || ' to ' || lvd_sub);

               IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS  THEN

                  LogError (lcs_function_name, ' AssignParametergroup ' || lts_sub_pg_tab(lvn_subsc_row) || ' failed for sc <' || lvs_sub_sc_id || '> Function returned :' || lvi_ret_code);
                  LogError (lcs_function_name, ' AssignParametergroup was attempted with the following data: lvs_sub_sc_id: ' || lvs_sub_sc_id || ', ' ||
                                                                                                    'lts_sub_pg_tab: ' || lts_sub_pg_tab(lvn_subsc_row) || ', ' ||
                                                                                                    'lvn_pgnode: ' || lvn_pgnode  || ', ' ||
                                                                                                    'lts_sub_st_tab: ' || lts_sub_st_tab(lvn_subsc_row) || ', ' ||
                                                                                                    'avs_modify_reason: ' || avs_modify_reason || ', ' ||
                                                                                                    'lts_super_me_link_tab: ' || lts_super_me_link_tab(lvn_subsc_row));
                  lvi_ret_code := UNAPIGEN.SynchrEndTransaction;--End AssignParametergroup Transaction
               END IF;
            END IF;

            lvi_ret_code := UNAPIGEN.SynchrEndTransaction;--End AssignParametergroup Transaction? Seems like a loose end transaction call --warning:can make pg locked for modifications.

            SELECT COUNT(1), MAX(panode)
             INTO lvn_sc_already_assigned, lvn_panode
             FROM UTSCPA
            WHERE SC=lvs_sub_sc_id
              AND PG=lts_sub_pg_tab(lvn_subsc_row)
              AND PA=lts_sub_pa_tab(lvn_subsc_row);

          IF lvn_sc_already_assigned=0 THEN
             ----------------------------------------------------------------------------
             -- Assign the necessary PA
             ----------------------------------------------------------------------------
             --lvi_ret_code := UNAPIGEN.BeginTransaction;
             lvd_sub:=SYSDATE;
             lvi_ret_code := APAOFUNCTIONS.AssignParameter(lvs_sub_sc_id,
                                                     lts_sub_pg_tab(lvn_subsc_row),
                                                     lvn_pgnode,
                                                     lts_sub_ppversion_tab(lvn_subsc_row),
                                                     lts_sub_st_tab(lvn_subsc_row), --NOTE: applies to Vredestein config only
                                                     ' ',' ',' ',' ',--NOTE: applies to Vredestein config only
                                                     lts_sub_pa_tab(lvn_subsc_row),
                                                     lvn_panode,
                                                     lts_sub_prversion_tab(lvn_subsc_row),
                                                     avs_modify_reason||lts_super_me_link_tab(lvn_subsc_row), --may exceed 255 at very low risk
                                                     TRUE --The functional spec says to follow the basic config and add later if necessary.
                                                     );
              --LogError (lcs_function_name, ' AssignParameter ' || lts_sub_pa_tab(lvn_subsc_row) || ' done for <' || lvs_sub_sc_id || '> the function took from ' || SYSDATE || ' to ' || lvd_sub);
              IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN

                 LogError (lcs_function_name, ' AssignParameter failed for sc <' || lvs_sub_sc_id || '> Function returned :' || lvi_ret_code, 2);
                 --lvi_ret_code := UNAPIGEN.SynchrEndTransaction;

              END IF;
           --lvi_ret_code := UNAPIGEN.SynchrEndTransaction;
           END IF;

         SELECT COUNT(1), MAX(menode)
           INTO lvn_sc_already_assigned, lvn_menode
           FROM UTSCME
          WHERE SC=lts_sub_sc_tab(lvn_subsc_row)
            AND PG=lts_sub_pg_tab(lvn_subsc_row)
            AND PA=lts_sub_pa_tab(lvn_subsc_row)
            AND ME=lts_sub_me_tab(lvn_subsc_row);

            IF lvn_sc_already_assigned=0 THEN
              ----------------------------------------------------------------------------
              -- Assign the necessary ME
              ----------------------------------------------------------------------------
              --lvi_ret_code := UNAPIGEN.BeginTransaction;
              --LogError(lcs_function_name, ' AssignMethod ' || lts_sub_me_tab(lvn_subsc_row) || '  for <' || lvs_sub_sc_id || '> the function started: ' || SYSDATE);
              lvi_ret_code := APAOFUNCTIONS.AssignMethod(lvs_sub_sc_id,
                                                   lts_sub_pg_tab(lvn_subsc_row),
                                                   lvn_pgnode,
                                                   lts_sub_ppversion_tab(lvn_subsc_row),
                                                   lts_sub_st_tab(lvn_subsc_row), --NOTE: applies to Vredestein config only
                                                   ' ',' ',' ',' ',--NOTE: applies to Vredestein config only
                                                   lts_sub_pa_tab(lvn_subsc_row),
                                                   lvn_panode,
                                                   lts_sub_prversion_tab(lvn_subsc_row),
                                                   lts_sub_me_tab(lvn_subsc_row),
                                                   lvn_menode,
                                                   lts_sub_mtversion_tab(lvn_subsc_row),
                                                   lvn_reanalysis,
                                                   avs_modify_reason||lts_super_me_link_tab(lvn_subsc_row) --may exceed 255 at very low risk
                                                   );

              --LogError(lcs_function_name, ' AssignMethod ' || lts_sub_me_tab(lvn_subsc_row) || '  for <' || lvs_sub_sc_id || '> the function ended: ' || SYSDATE);
              IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN

                LogError (lcs_function_name, ' AssignMethod failed for sc <' || lvs_sub_sc_id || '> Function returned :' || lvi_ret_code, 2);
                --lvi_ret_code := UNAPIGEN.SynchrEndTransaction;

              END IF;
             --lvi_ret_code := UNAPIGEN.SynchrEndTransaction; warning:can make pa locked for changes by the pa lifecycle.
            END IF; --If Method not found

            SELECT COUNT(1), MAX(menode)
             INTO lvn_sc_already_assigned, lvn_menode
             FROM UTSCME
            WHERE SC=lvs_sub_sc_id
              AND PG=lts_sub_pg_tab(lvn_subsc_row)
              AND PA=lts_sub_pa_tab(lvn_subsc_row)
              AND ME=lts_sub_me_tab(lvn_subsc_row);

            IF lvn_menode IS NOT NULL THEN
              --
              --When Me is created or exists, assign the melink (N:1 link).
              --
              lts_au_tab(1)     := 'avSubSampleMeLink';
              lts_au_version_tab(1):=NULL;
              lts_value_tab(1)  := SUBSTR(lts_super_me_link_tab(lvn_subsc_row),1,INSTR(lts_super_me_link_tab(lvn_subsc_row),'#')-1);
              --
              lts_au_tab(2)     := 'avSuperSampleSc';
              lts_au_version_tab(2):=NULL;
              lts_value_tab(2)  := lts_super_sc_tab(lvn_subsc_row);
              --
              lts_au_tab(3)     := 'avSuperSamplePg';
              lts_au_version_tab(3):=NULL;
              lts_value_tab(3)  := lts_super_pg_tab(lvn_subsc_row);
              --
              lts_au_tab(4)     := 'avSuperSamplePa';
              lts_au_version_tab(4):=NULL;
              lts_value_tab(4)  := lts_super_pa_tab(lvn_subsc_row);
              --
              lts_au_tab(5)     := 'avSuperSampleMe';
              lts_au_version_tab(5):=NULL;
              lts_value_tab(5)  := lts_super_me_tab(lvn_subsc_row);
              --
              lts_au_tab(6)     := 'avSqlCurrentPartno';
              lts_au_version_tab(6):=NULL;
              lts_value_tab(6)  := lts_part_no_tab(lvn_subsc_row);

              lvi_ret_code := UNAPIMEP.SAVESCMEATTRIBUTE(lvs_sub_sc_id,
                                                  lts_sub_pg_tab(lvn_subsc_row), lvn_pgnode,
                                                  lts_sub_pa_tab(lvn_subsc_row), lvn_panode,
                                                  lts_sub_me_tab(lvn_subsc_row), lvn_menode,
                                                  lts_au_tab, lts_au_version_tab,
                                                  lts_value_tab,
                                                  6,
                                                  avs_modify_reason||lts_super_me_link_tab(lvn_subsc_row));
              --LogError (lcs_function_name, ' UNAPIMEP.SAVE1SCMEATTRIBUTE for <' || lvs_sub_sc_id || '> '||lts_value_tab(1)||' ret:' || lvi_ret_code);

              --Update Mounting Method Part_No MeCell
--              if lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN

--                lvn_sub_sc_mounting_cnt := 0;
--                FOR lvr_part_no_config IN lvq_mounting_partno_config(lvs_sub_sc_id) LOOP
--                  lvn_sub_sc_mounting_cnt := lvn_sub_sc_mounting_cnt+1;
--                  lts_sub_sc_mounting_au_value(lvn_sub_sc_mounting_cnt) := lvr_part_no_config.value;
--                END LOOP;
--                lvn_sub_sc_mounting_reanalys := 0;
--                lvi_ret_code := APAOFUNCTIONS.SaveScMeCellValue(lvs_sub_sc_id,
--                                                  lts_sub_pg_tab(lvn_subsc_row), lvn_pgnode,
--                                                  lts_sub_pa_tab(lvn_subsc_row), lvn_panode,
--                                                  lts_sub_me_tab(lvn_subsc_row), lvn_menode,
--                                                  'Part_No',
--                                                  264,
--                                                  100,
--                                                  NULL,
--                                                  lts_part_no_tab(lvn_subsc_row),
--                                                  lvn_sub_sc_mounting_reanalys);
                --TODO: implement APAO_FUNCTIONS.SaveScMeCell and use here instead of UPDATE statements
--                UPDATE utscmecell
--                  SET VALUE_S = lts_part_no_tab(lvn_subsc_row)
--                WHERE SC = lvs_sub_sc_id
--                  AND ME = 'TP800A1'  --TODO: get ME and CELL values from configuration attributes of WheelSetEntity via cursor lvq_mounting_partno_config, does not work properly at the moment so hard coded for now...
--                  AND CELL = 'Part_No';

--                UNAPIGEN.LogError (lcs_function_name, LPAD(lvn_cnt, 4, '0') || ' Debug UNAPIMEP.SaveScMeCellValue for <' || lvs_sub_sc_id || '>, --PG: ' || lts_sub_pg_tab(lvn_subsc_row)|| ' --PGNODE: ' || lvn_pgnode || ' --PA: ' || lts_sub_pa_tab(lvn_subsc_row) || ' --PANODE: ' || lvn_panode || ' --ME:' || lts_sub_me_tab(lvn_subsc_row)|| ' --MENODE: ' || lvn_menode || ' --CELL: Part_No --VALUE: ' || lts_part_no_tab(lvn_subsc_row) || ' ret:' || lvi_ret_code);
--                lvn_cnt:=lvn_cnt+1;
--              END IF;


              --
              --When Me is created or exists, assign the method to the worksheet.
              --
              SELECT COUNT(1)
               INTO lvn_sc_already_assigned
               FROM UTWSME
              WHERE WS=lvs_ws
                AND SC=lvs_sub_sc_id
                AND PG=lts_sub_pg_tab(lvn_subsc_row)
                AND PGNODE=lvn_pgnode
                AND PA=lts_sub_pa_tab(lvn_subsc_row)
                AND PANODE=lvn_panode
                AND ME=lts_sub_me_tab(lvn_subsc_row)
                AND MENODE=lvn_menode;

              IF lvn_sc_already_assigned=0 THEN

                INSERT INTO UTWSME(WS, ROWNR, SC,PG,PGNODE,PA,PANODE,ME,MENODE,REANALYSIS)
                VALUES(lvs_ws, lvn_max_ws_pos,
                  lvs_sub_sc_id,
                  lts_sub_pg_tab(lvn_subsc_row),     lvn_pgnode,
                  lts_sub_pa_tab(lvn_subsc_row),     lvn_panode,
                  lts_sub_me_tab(lvn_subsc_row),     lvn_menode,     lvn_reanalysis);
                  --NOTE: configure the worksheet-type PCTOutdoorPrep with the layout for the mounting method.
                --SAVEPOINT UNILAB4;
              END IF;
            END IF;
          --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop2.2 End. Started at: ' || lvd_loop2_2);
       END LOOP; --loop 2.2 for each set
       --LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples loop2.1 End. Started at: ' || lvd_loop2_1);
    END LOOP; --loop 2.1 For each sub sample

    LogError (lcs_function_name, ' (' || avs_ws || ') HandleCreateSubsamples End. Started at: ' || lvd_start_datetime, 3);
    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  LogError(lcs_function_name, 'AOPA_OUTDOOR.HandleCreateSubSamples(' || avs_ws || ') Exception!', 1);
  --
  IF SQLCODE != 1 THEN
    LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END HandleCreateSubSamples;

FUNCTION NotifyRequester(avs_ws            IN VARCHAR2,
                         avs_modify_reason IN VARCHAR2)
--------------------------------------------------------------------------------
-- Created by DH 18-01-2019
-- Creates subsamples
--------------------------------------------------------------------------------
RETURN INTEGER IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name || '.NotifyRequester';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code             INTEGER := UNAPIGEN.DBERR_NORECORDS;
lvs_part_no              VARCHAR2(20); --to avoid clearing of data by additional call.
lvs_codemask_new_sc      VARCHAR2(20); --to build the code mask.
lts_value_tab            UNAPIGEN.VC40_TABLE_TYPE;
lvs_ws                   VARCHAR2(20); --to avoid clearing of data by additional call.

lvs_creator_email        VARCHAR2(255);
lvs_recipient_email      VARCHAR2(255);
lvs_subject              VARCHAR2(255);
lvs_sqlerrm              VARCHAR2(255);
lvs_text_tab             UNAPIGEN.VC255_TABLE_TYPE;
lvi_nr_of_rows           INTEGER;

CURSOR c_mailtypes (avs_ws IN VARCHAR2) IS
SELECT UTRQ.RQ RequestCode, EMAIL as Recipients, 'Request '||WsRq.RequestCode||' is '||NVL(UTSS.Description, UTSS.Name) as subject
FROM UTAD
JOIN UTRQ ON UTAD.AD=UTRQ.Created_by
JOIN UTWSGKRequestCode WsRq ON WsRq.RequestCode=UTRQ.RQ
JOIN UTSS ON UTSS.SS = UTRQ.SS
WHERE WsRq.WS=avs_ws;

CURSOR c_lines (avs_rq IN VARCHAR2) IS
SELECT 'Test line for '||avs_rq||' '||Description||' '||RT||' '||RT_VERSION as Line
FROM UTRQ
WHERE RQ=avs_rq;

BEGIN


     lvs_creator_email   := 'UNILAB';
     lvs_recipient_email := ' ';

     FOR l_mail_rec IN c_mailtypes(avs_ws) LOOP

        lvs_recipient_email:=l_mail_rec.recipients;

        IF lvs_recipient_email IS NOT NULL THEN
          -- fill in the subject and mailbody texts
          lvs_subject := 'Alarm:'||l_mail_rec.subject;
          lvi_nr_of_rows:=0;
          FOR l_line_rec IN c_lines(l_mail_rec.RequestCode) LOOP
            lvi_nr_of_rows:=lvi_nr_of_rows+1;
            lvs_text_tab(lvi_nr_of_rows):=l_line_rec.line;
          END LOOP;

          IF lvi_nr_of_rows >0 THEN
            lvi_ret_code := AOSMTP.QueueMail(a_recipient  => lvs_recipient_email,
                                            a_subject    => lvs_subject,
                                            a_text_tab   => lvs_text_tab,
                                            a_nr_of_rows => lvi_nr_of_rows);

            IF lvi_ret_code <> Unapigen.DBERR_SUCCESS THEN
                 UNAPIGEN.LogError('AOSMTP.QueueMail', 'QueueMail failed for '||lvs_recipient_email);
            END IF;
          END IF;
       END IF;

     END LOOP;

     RETURN(Unapigen.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
  APAOGEN.LogError (lcs_function_name, 'Debug-DH, AOPA_OUTDOOR.NotifyRequestor(' || UNAPIEV.P_WS || ') Exception!');
  --
  IF SQLCODE != 1 THEN
    UNAPIGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END NotifyRequester;

FUNCTION CreateScTesting(avs_ws            IN VARCHAR2,
                         avs_modify_reason IN VARCHAR2)
RETURN INTEGER IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name || '.CreateScTesting';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                    INTEGER;
lvs_part_no                     VARCHAR2(20);
lvs_codemask_new_sc             VARCHAR2(20);
lts_value_tab                   UNAPIGEN.VC40_TABLE_TYPE;
lvn_ws_modify_flag              NUMBER := UNAPIGEN.MOD_FLAG_INSERT;
lvn_rownr                       NUMBER;
lvn_sc_already_assigned         NUMBER;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_rq_progid(avs_ws IN VARCHAR2) IS
SELECT a.requestcode, b.subprogramid
  FROM utwsgkrequestcode a,
       utwsgksubprogramid b
 WHERE a.ws = avs_ws
   AND a.ws = b.ws;

CURSOR lvq_worksheets_in_rq(avs_requestcode IN VARCHAR2,
                            avs_subprogramid IN VARCHAR2) IS
SELECT a.ws
  FROM utwsgksubprogramid a,
       utwsgkrequestcode b
 WHERE b.requestcode = avs_requestcode
   AND a.subprogramid = avs_subprogramid
   AND a.ws = b.ws;

CURSOR lvq_subprogid_details(avs_ws IN VARCHAR2) IS
SELECT a.avtestmethod,
       b.numberofrefs,
       c.refsetdesc,
       d.sc,
       e.testsetsize
  FROM utwsgkavtestmethod a,
       utwsgknumberofrefs b,
       utwsgkrefsetdesc c,
       utwssc d,
       utwsgktestsetsize e
 WHERE a.ws = avs_ws
   AND b.ws(+) = a.ws
   AND c.ws(+) = a.ws
   AND d.ws = a.ws
   AND e.ws(+) = a.ws;

CURSOR lvq_part_no (avs_sc          IN VARCHAR2) IS
SELECT iivalue
  FROM utscii
 WHERE sc = avs_sc
   AND ii = 'avPartNo';

CURSOR lvq_samplesinsubprogram IS
SELECT setdesc, MAX(samplesforthisavmethod) samplesforthisavmethod
  FROM ATAO_OUTDOOR
 GROUP
    BY setdesc;

CURSOR lvq_sc2create IS
SELECT TO_NUMBER(SUBSTR(codemask, -2)) seq, MAX(sc) sc, MAX(samplesinsubprogram) samplesinsubprogram, codemask
  FROM ATAO_OUTDOOR
 WHERE samplesinsubprogram IS NOT NULL
 GROUP
    BY codemask
 ORDER
    BY codemask;

CURSOR lvq_wsgk2paau (avs_ws          IN VARCHAR2,
                      avs_sc          IN VARCHAR2) IS
SELECT b.sc, b.pg, b.pgnode, b.pa, b.panode, b.au, b.au_version, a.value
  FROM utwsgk a, utscpaau b
 WHERE a.ws = avs_ws
   AND b.sc = avs_sc
   AND b.au = a.gk;

BEGIN
    ----------------------------------------------------------------------------
    -- Cleanup temporary data
    ----------------------------------------------------------------------------
    DELETE
      FROM ATAO_OUTDOOR;
    ----------------------------------------------------------------------------
    -- Retrieve all occurances request/programid for current worksheet
    ----------------------------------------------------------------------------
    FOR lvr_rq_progid IN lvq_rq_progid(avs_ws) LOOP
        ----------------------------------------------------------------------------
        -- Retrieve all worksheets for these request/programid occurances
        ----------------------------------------------------------------------------
        FOR lvr_worksheets_in_rq IN lvq_worksheets_in_rq(lvr_rq_progid.requestcode, lvr_rq_progid.subprogramid) LOOP
            ----------------------------------------------------------------------------
            --  Retrieve detailed information for these worksheets
            ----------------------------------------------------------------------------
            FOR lvr_ws_details IN lvq_subprogid_details(lvr_worksheets_in_rq.ws) LOOP
                ----------------------------------------------------------------------------
                -- Retrieve all part_no (sample infofields) for the samples of the found requests
                ----------------------------------------------------------------------------
                FOR lvr_part_no IN lvq_part_no(lvr_ws_details.sc) LOOP
                    lvs_part_no := lvr_part_no.iivalue;
                END LOOP;
                ----------------------------------------------------------------------------
                -- Fill a temporary table with the information found
                ----------------------------------------------------------------------------
                INSERT
                  INTO ATAO_OUTDOOR (SC, SETDESC, REFSETDESC,
                                     AVMETHOD, NUMBEROFREFS, RQ,
                                     SETSIZE, ISREFFORTHISAVMETHOD,
                                     SAMPLESFORTHISAVMETHOD,
                                     CODEMASK)
                VALUES (lvr_ws_details.sc, lvs_part_no,  lvr_ws_details.refsetdesc,
                        lvr_ws_details.avtestmethod, lvr_ws_details.numberofrefs, lvr_rq_progid.requestcode,
                        lvr_ws_details.testsetsize, 0, 1,
                        SUBSTR(lvr_ws_details.sc, 1,6) || '.' || lvr_rq_progid.subprogramid || '.' || SUBSTR(lvr_ws_details.sc, -2));
            END LOOP;
        END LOOP;
    END LOOP;

    ----------------------------------------------------------------------------
    -- For each record calculate "IsRefForThisMethod"
    ----------------------------------------------------------------------------
    UPDATE ATAO_OUTDOOR
       SET isrefforthisavmethod = 1
     WHERE setdesc = refsetdesc;
    ----------------------------------------------------------------------------
    -- For each record calculate "NumberOfRefs"
    ----------------------------------------------------------------------------
    UPDATE ATAO_OUTDOOR
       SET samplesforthisavmethod = numberofrefs
     WHERE isrefforthisavmethod = 1;
    ----------------------------------------------------------------------------
    -- For each record calculate the number of samples to be created
    ----------------------------------------------------------------------------
    FOR lvr_samplesinsubprogram IN lvq_samplesinsubprogram LOOP
        UPDATE ATAO_OUTDOOR
           SET samplesinsubprogram = lvr_samplesinsubprogram.samplesforthisavmethod
         WHERE setdesc = lvr_samplesinsubprogram.setdesc;
    END LOOP;

    FOR lvr_sc2create IN lvq_sc2create LOOP
        ----------------------------------------------------------------------------
        -- Determine the number of samples in the sub program
        ----------------------------------------------------------------------------
        FOR i IN 1..lvr_sc2create.samplesinsubprogram LOOP
            ----------------------------------------------------------------------------
            -- Determine the unique code of the new sample
            ----------------------------------------------------------------------------
            IF lvr_sc2create.samplesinsubprogram > 1 THEN
                lvs_codemask_new_sc := lvr_sc2create.codemask || '.' || i;
            ELSE
                lvs_codemask_new_sc := lvr_sc2create.codemask;
            END IF;
            ----------------------------------------------------------------------------
            -- Check if the sample has not been assigned yet to the worksheet
            ----------------------------------------------------------------------------
            SELECT count(*)
              INTO lvn_sc_already_assigned
              FROM utwssc
             WHERE ws = avs_ws AND sc = lvs_codemask_new_sc;

            lvn_ws_modify_flag := UNAPIGEN.MOD_FLAG_INSERT;

            IF lvn_sc_already_assigned = 0 THEN
                UPDATE utws
                   SET sc_counter = TO_NUMBER(SUBSTR(lvs_codemask_new_sc,-2)), max_rows = sc_counter
                 WHERE ws = avs_ws;
                ----------------------------------------------------------------------------
                -- Save sample to worksheet
                -- NOTE : First add the sample to the worksheet,
                --        so once the pr-mt frequency will be evaluated,
                --        all ws-info is available
                ----------------------------------------------------------------------------
                INSERT
                  INTO utwssc (ws, rownr, sc)
                VALUES (avs_ws, TO_NUMBER(SUBSTR(lvs_codemask_new_sc,-2)), lvs_codemask_new_sc);
            END IF;
            ----------------------------------------------------------------------------
            -- Create the sample as a copy of the original one (including au/gk; exlcluding pg/pa)
            -- We will use the st "T-T: PCT raw set" in all cases
            ----------------------------------------------------------------------------
            lvi_ret_code := APAO_OUTDOOR.COPYSC(lvr_sc2create.sc, 'T-T: PCT raw set', lvs_codemask_new_sc , avs_modify_reason);
            IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS AND
               lvi_ret_code != UNAPIGEN.DBERR_SCALREADYEXIST THEN
                UNAPIGEN.LogError (lcs_function_name, 'CopySample failed for sc <' || lvs_codemask_new_sc || '> Function returned :' || lvi_ret_code);
            END IF;
        END LOOP;
    END LOOP;
    ----------------------------------------------------------------------------
    -- At this moment a link will be created by groupkeys to link the new sample
    -- with the original one. If we do that just after the creation, the copysample
    -- api will also copy these groupkeys
    ----------------------------------------------------------------------------
    FOR lvr_sc2create IN lvq_sc2create LOOP
        ----------------------------------------------------------------------------
        -- Retermine the number of samples in the sub program
        ----------------------------------------------------------------------------
        FOR i IN 1..lvr_sc2create.samplesinsubprogram LOOP
            ----------------------------------------------------------------------------
            -- Redetermine the unique code of the new sample just created
            ----------------------------------------------------------------------------
            IF lvr_sc2create.samplesinsubprogram > 1 THEN
                lvs_codemask_new_sc := lvr_sc2create.codemask || '.' || i;
            ELSE
                lvs_codemask_new_sc := lvr_sc2create.codemask;
            END IF;
            ----------------------------------------------------------------------------
            -- Assign the groupkey rawDataSc to the new created sample
            ----------------------------------------------------------------------------
            lvi_ret_code := AddValueToScGk(lvr_sc2create.sc,
                                           'rawDataSc',
                                           lvs_codemask_new_sc);
            IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.LogError (lcs_function_name, 'Assign scgk <rawDataSc> with value <' || lvs_codemask_new_sc || '> failed for <' || lvr_sc2create.sc || '> Function returned :' || lvi_ret_code);
            END IF;
            ----------------------------------------------------------------------------
            -- Assign the groupkey variantSc to the original sample
            ----------------------------------------------------------------------------
            lvi_ret_code := AddValueToScGk(lvs_codemask_new_sc,
                                           'variantSc',
                                           lvr_sc2create.sc);
            IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
               UNAPIGEN.LogError (lcs_function_name, 'Assign scgk <variantSc>> with value <' || lvr_sc2create.sc || '> failed for <' || lvs_codemask_new_sc || '> Function returned :' || lvi_ret_code);
            END IF;

            FOR lvr_wsgk2paau IN lvq_wsgk2paau(avs_ws, lvs_codemask_new_sc) LOOP
               lts_value_tab(1)  := lvr_wsgk2paau.value;
               --------------------------------------------------------------------------------
               -- Save wsgk as paau
               --------------------------------------------------------------------------------
               lvi_ret_code := UNAPIPAP.SAVE1SCPAATTRIBUTE(lvr_wsgk2paau.sc,
                                                            lvr_wsgk2paau.pg, lvr_wsgk2paau.pgnode,
                                                            lvr_wsgk2paau.pa, lvr_wsgk2paau.panode,
                                                            lvr_wsgk2paau.au,
                                                            lvr_wsgk2paau.au_version,
                                                            lts_value_tab,
                                                            1,
                                                            avs_modify_reason);
            END LOOP;
        END LOOP;
    END LOOP;

    RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    UNAPIGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END CreateScTesting;


FUNCTION CopyWtAu2WsGk(avs_ws            IN VARCHAR2,
                       avs_modify_reason IN VARCHAR2)
RETURN INTEGER IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name || '.CopyWtAu2WsGk';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                    INTEGER;
lvs_ws                          VARCHAR2(20);
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_wtau2gk(avs_ws           IN VARCHAR2) IS
SELECT DISTINCT c.gk, b.value
  FROM utws a, utwtau b, utgkws c
 WHERE a.ws = avs_ws
   AND a.wt = b.wt AND a.wt_version = b.version
   AND b.au = c.gk;

BEGIN
    --------------------------------------------------------------------------------
    -- Assign attributes of worksheettype as groupkey to the new created worksheet
    --------------------------------------------------------------------------------
    FOR lvr_wtau2gk IN lvq_wtau2gk(avs_ws) LOOP
       lvi_ret_code := Save1WsGk(avs_ws, lvr_wtau2gk.gk, lvr_wtau2gk.value, avs_modify_reason);
    END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    UNAPIGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END CopyWtAu2WsGk;

--
--  Sync Event Mgr is used to perform data-synchronisation actions
--  this may be time-consuming. The Proc will be a scheduled job.
--
PROCEDURE OutdoorEventMgr
IS
  CURSOR cr_sync_events
  IS
  SELECT *
    FROM ATOUTDOOREVENTS
    WHERE HANDLED_ON IS NULL
    ORDER BY EVENT_NUM;
                        --1234567890123456789012345678901234567890
  c_api_name VARCHAR2(40):=ics_package_name||'.OutdoorEventMgr';
  l_ret_code NUMBER;
  l_sqlerrm VARCHAR2(255);
  l_trace_dbmsoutput BOOLEAN:= false;
  l_cnt NUMBER;

  l_client_id      VARCHAR2(20);
  l_us             VARCHAR2(20);
  l_password       VARCHAR2(20);
  l_applic         VARCHAR2(8);
  l_numeric_characters VARCHAR2(2);
  l_date_format    VARCHAR2(255);
  l_timezone    VARCHAR2(255);
  l_up             NUMBER;
  l_user_profile   VARCHAR2(40);
  l_language       VARCHAR2(20);
  l_tk             VARCHAR2(20);
  l_tm            TIMESTAMP;

  TYPE tp_events IS TABLE OF cr_sync_events%ROWTYPE;
  t_events tp_events;
  l_event cr_sync_events%ROWTYPE;
BEGIN
  l_client_id      := 'Win2012R2x64';
  l_us             := 'UNILAB';
  l_password       := 'moonflower';
  l_applic         := 'stdef';
  l_numeric_characters := 'DB';
  l_date_format    := 'DDfx/fxMM/RR HH24fx:fxMI:SS';
  l_timezone := 'Central Europe Standard Time';
  l_ret_code       := UNAPIGEN.SetConnection
                      (l_client_id,
                       l_us,
                       l_password,
                       l_applic,
                       l_numeric_characters,
                       l_date_format,
                       l_up,
                       l_user_profile,
                       l_language,
                       l_tk);
  IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
     UNAPIGEN.LogError (c_api_name, 'UNAPIGEN.SetConnection failed:'||l_ret_code);
     RETURN;
  END IF;

-- Commented out by JBK
--  UNAPIGEN.LogError (c_api_name, 'OutdoorEventMAnager run');

  OPEN cr_sync_events;
  FETCH cr_sync_events BULK COLLECT INTO t_events;
  CLOSE cr_sync_events;

  --Loop until all events in EVENT-table are marked as handled.
  LOOP

    BEGIN
      EXIT WHEN t_events.COUNT<1;
      l_event:= t_events(1);
      --Create DB structures for the request type if not existing
      IF l_event.OBJ_TP='WS' THEN
        UNAPIGEN.LogError (c_api_name, 'Execute HandleCreateSubSamples for WS: ' ||l_event.obj_id || ' obj_tp: '||l_event.obj_tp
                        ||' event: '||l_event.EVENT_NUM);
        --PS: VANAF 01-10-2020 aanroep van aanmaken subsamples aangezet !!!
        l_ret_code:=HandleCreateSubSamples(l_event.OBJ_ID, l_event.MODIFY_REASON);
        --
      ELSE

        l_sqlerrm:=SUBSTR('obj_tp:'||l_event.obj_tp
                        ||'/obj_id:'||l_event.obj_id
                        ||'/event:'||l_event.EVENT_NUM
                        ||' not supported!',1,255);

        UNAPIGEN.LogError (c_api_name, l_sqlerrm);

      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        l_sqlerrm:=SUBSTR(SQLERRM, 1, 255);
        l_sqlerrm:=SUBSTR('obj_tp:'||l_event.obj_tp
                        ||'/obj_id:'||l_event.obj_id
                        ||'/event:'||l_event.EVENT_NUM
                        ||'/err:'||l_sqlerrm,1,255);
        UNAPIGEN.LogError (c_api_name, l_sqlerrm);
        l_ret_code:=UNAPIGEN.DBERR_GENFAIL;
    END;

    UPDATE ATOUTDOOREVENTS
       SET HANDLED_ON=CURRENT_TIMESTAMP, HANDLING_ERRCODE=l_ret_code
      WHERE OBJ_TP=l_event.OBJ_TP
        AND OBJ_ID=l_event.OBJ_ID
        AND EVENT_NUM=l_event.EVENT_NUM;
    commit;

    OPEN cr_sync_events;
    FETCH cr_sync_events BULK COLLECT INTO t_events;
    l_cnt:=t_events.COUNT;
    CLOSE cr_sync_events;

  END LOOP;

  delete from ATOUTDOOREVENTS where handled_on<SYSDATE-90;

  delete from ATOUTDOOREVENTS where handled_on<SYSDATE-1 and handling_errcode=0;

  commit;

EXCEPTION
WHEN OTHERS THEN
  l_sqlerrm:=SUBSTR(SQLERRM, 1, 255);
  l_sqlerrm:=SUBSTR('Start of job:'||l_sqlerrm,1,255);
  UNAPIGEN.LogError (c_api_name, l_sqlerrm);
  l_ret_code:=UNAPIGEN.DBERR_GENFAIL;
END;

FUNCTION InsertWorksheetEvent(avs_obj_id IN VARCHAR2, avs_modify_reason VARCHAR2)
RETURN NUMBER
IS
  c_api_name VARCHAR2(40):= ics_package_name||'.InsertWorksheetEvent';
  l_event_num NUMBER;
  l_sqlerrm VARCHAR2(255);
BEGIN
    UNAPIGEN.LogError ('InsertWorksheetEvent', 'starttime: ' || ' APAO_OUTDOOR.InsertWorksheetEvent.' );
  SELECT AS_OUTDOOR_EVENT.NEXTVAL
    INTO l_event_num
    FROM DUAL;

  INSERT INTO ATOUTDOOREVENTS (
    EVENT_NUM ,
    EVENT_TYPE,
    OBJ_TP  ,
    OBJ_ID  ,
    MODIFY_REASON,
    CREATED_ON,
    HANDLED_ON ,
    HANDLING_ERRCODE)
    VALUES (l_event_num, 'CREATE_SUB_SC', 'WS', avs_obj_id, avs_modify_reason , CURRENT_TIMESTAMP, NULL, NULL);
    UNAPIGEN.LogError ('InsertWorksheetEvent', 'endtime: ' || SYSDATE || ' APAO_OUTDOOR.InsertWorksheetEvent.' );
  RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
  WHEN OTHERS THEN
    l_sqlerrm:=SUBSTR(SQLERRM,1,255);
    UNAPIGEN.LogError (c_api_name, l_sqlerrm);
    RETURN UNAPIGEN.DBERR_GENFAIL;
END;

FUNCTION StartJob
(a_name             IN VARCHAR2,
 a_first_run        IN VARCHAR2,
 a_interval         IN VARCHAR2,
 a_prc_name         IN VARCHAR2)
RETURN NUMBER IS
l_job            VARCHAR2(30);
l_enabled        VARCHAR2(5);
l_action         VARCHAR2(4000);
l_interval       NUMBER;
l_setting_value  VARCHAR2(40);
l_found          BOOLEAN;
l_leave_loop     BOOLEAN;
l_attempts       INTEGER;
l_date_cursor    INTEGER;
l_first_run      TIMESTAMP WITH TIME ZONE;
l_result         NUMBER;
l_start_date     VARCHAR2(255);
l_next_run       VARCHAR2(255);
l_session_timezone   VARCHAR2(64);
l_IsDBAUser      NUMBER;
l_sql_string     VARCHAR2(255);
l_sqlerrm        VARCHAR2(255);
StpError          EXCEPTION;
BEGIN
   Cxdba.syncnls;
   /*---------------------------------------------------------------------------*/
   /* Check if job exists                                                       */
   /* No functions provided to check if a job is existing in DBMS_JOB package   */
   /* ALL_JOBS and USER_JOBS views could not be used since they are referencing */
   /* the USER session as creator of the job !                                  */
   /*---------------------------------------------------------------------------*/
   OPEN l_jobs_cursor(a_prc_name);
   FETCH l_jobs_cursor
   INTO l_job,l_enabled,l_action ;
   l_found := l_jobs_cursor%FOUND;
   CLOSE l_jobs_cursor;

   l_IsDBAUser := UNAPIGEN.IsExternalDBAUser();

   /* When action required : check if authorised */
   /*--------------------------------------------*/
   IF (UNAPIGEN.IsUserAuthorised(UNAPIGEN.P_CURRENT_UP, UNAPIGEN.P_USER, 'database', 'startstopjobs') <> UNAPIGEN.DBERR_SUCCESS) AND
      l_IsDBAUser <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(UNAPIGEN.DBERR_EVMGRSTARTNOTAUTHORISED);
   END IF;
   -- set dbtimezone for jobs
      SELECT SESSIONTIMEZONE
        INTO l_session_timezone
        FROM DUAL;
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = DBTIMEZONE';

   IF l_found THEN
      IF UPPER(l_enabled) = 'FALSE' THEN
         /*-----------------*/
         /* Try to relaunch */
         /*-----------------*/
        DBMS_SCHEDULER.ENABLE(l_job);
      END IF;
   ELSE
      /*------------------------------------------*/
      /* The job has to be created                */
      /*------------------------------------------*/

      -- Find the first date to run the job
      IF a_first_run IS NOT NULL THEN
         l_date_cursor := DBMS_SQL.OPEN_CURSOR;
         l_sql_string := 'BEGIN :l_date := ' || a_first_run || '; END;';

         DBMS_SQL.PARSE(l_date_cursor, l_sql_string, DBMS_SQL.V7); -- NO single quote handling required
         DBMS_SQL.BIND_VARIABLE(l_date_cursor, ':l_date', l_first_run);
         l_result := DBMS_SQL.EXECUTE(l_date_cursor);
         DBMS_SQL.VARIABLE_VALUE(l_date_cursor, ':l_date', l_first_run);
         DBMS_SQL.CLOSE_CURSOR(l_date_cursor);
      ELSE
         l_first_run := CURRENT_TIMESTAMP;
      END IF;


    l_job := a_name;
         DBMS_SCHEDULER.CREATE_JOB(
             job_name          =>  '"' ||UNAPIGEN.P_DBA_NAME||'".'||l_job,
             job_class         => 'UNI_JC_OTHER_JOBS',
             job_type          => 'PLSQL_BLOCK',
             job_action        => a_prc_name,
             start_date        => l_first_run,
             repeat_interval   => a_interval ,
             enabled              => TRUE
        );
      DBMS_SCHEDULER.SET_ATTRIBUTE (
                    name           => l_job,
                    attribute      => 'restartable',
                    value          => TRUE);
   END IF;
   UNAPIGEN.U4COMMIT;

   /*----------------------------------------------------------------------*/
   /* Leave this function when Job effectively inserted into the job queue */
   /* or removed from the job queue                                        */
   /* To avoid double starts or double stops                               */
   /*----------------------------------------------------------------------*/
   l_leave_loop := FALSE;
   l_attempts := 0;
   WHILE NOT l_leave_loop LOOP
      l_attempts := l_attempts + 1;
      OPEN l_jobs_cursor(a_prc_name);
      FETCH l_jobs_cursor INTO l_job,l_enabled,l_action ;
      l_found := l_jobs_cursor%FOUND;
      CLOSE l_jobs_cursor;
      IF l_found THEN
         l_leave_loop := TRUE;
      ELSE
         IF l_attempts >= 30 THEN
            l_sqlerrm := a_name||' not stopped ! (timeout after 60 seconds)';
            Raise StpError;
         ELSE
            DBMS_LOCK.SLEEP(2);
         END IF;
      END IF;
   END LOOP;
         -- set the original session timezone
         EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';
   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
      UNAPIGEN.LogError ( ics_package_name||'.StartJob', l_sqlerrm );
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';
   END IF;
   UNAPIGEN.U4COMMIT;
   IF l_jobs_cursor%ISOPEN THEN
      CLOSE l_jobs_cursor;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END StartJob;




FUNCTION StopJob(a_prc_name IN VARCHAR2)
RETURN NUMBER IS
l_job            VARCHAR2(30);
l_enabled         VARCHAR2(5);
l_action         VARCHAR2(4000);
l_interval       NUMBER;
l_setting_value  VARCHAR2(40);
l_found          BOOLEAN;
l_leave_loop     BOOLEAN;
l_attempts       INTEGER;
l_IsDBAUser      INTEGER;
l_session_timezone   VARCHAR2(64);
l_sql_string     VARCHAR2(255);
l_sqlerrm        VARCHAR2(255);
StpError          EXCEPTION;
BEGIN
   /*---------------------------------------------------------------------------*/
   /* Check if job exists                                                       */
   /* No functions provided to check if a job is existing in DBMS_JOB package   */
   /* ALL_JOBS and USER_JOBS views could not be used since they are referencing */
   /* the USER session as creator of the job !                                  */
   /*---------------------------------------------------------------------------*/
   OPEN l_jobs_cursor(a_prc_name);
   FETCH l_jobs_cursor INTO l_job,l_enabled,l_action ;
   l_found := l_jobs_cursor%FOUND;
   CLOSE l_jobs_cursor;

   l_IsDBAUser := UNAPIGEN.IsExternalDBAUser();

   /* When action required : check if authorised */
   /*--------------------------------------------*/
   IF (UNAPIGEN.IsUserAuthorised(UNAPIGEN.P_CURRENT_UP, UNAPIGEN.P_USER, 'database', 'startstopjobs') <> UNAPIGEN.DBERR_SUCCESS) AND
      l_IsDBAUser <> UNAPIGEN.DBERR_SUCCESS THEN
      RETURN(UNAPIGEN.DBERR_EVMGRSTARTNOTAUTHORISED);
   END IF;
      -- set dbtimezone for jobs
      SELECT SESSIONTIMEZONE
        INTO l_session_timezone
        FROM DUAL;
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = DBTIMEZONE';
   IF l_found THEN
      /*-----------------------*/
      /* Try to remove the job */
      /*-----------------------*/
      DBMS_SCHEDULER.DROP_JOB(l_job);
   END IF;
   UNAPIGEN.U4COMMIT;
   /*----------------------------------------------------------------------*/
   /* Leave this function when Job effectively inserted into the job queue */
   /* or removed from the job queue                                        */
   /* To avoid double starts or double stops                               */
   /*----------------------------------------------------------------------*/
   l_leave_loop := FALSE;
   l_attempts := 0;
   WHILE NOT l_leave_loop LOOP
      l_attempts := l_attempts + 1;
      OPEN l_jobs_cursor(a_prc_name);
      FETCH l_jobs_cursor INTO l_job,l_enabled,l_action ;
      l_found := l_jobs_cursor%FOUND;
      CLOSE l_jobs_cursor;
      IF NOT l_found THEN
         l_leave_loop := TRUE;
      ELSE
         IF l_attempts >= 30 THEN
            l_sqlerrm := a_prc_name||' not stopped ! (timeout after 60 seconds)';
            Raise StpError;
         ELSE
            DBMS_LOCK.SLEEP(2);
         END IF;
      END IF;
   END LOOP;
         -- set the original session timezone
         EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';
   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
      UNAPIGEN.LogError ( ics_package_name||'.StopJob' , l_sqlerrm );
      -- set the original session timezone
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_session_timezone || '''';
   END IF;
   IF l_jobs_cursor%ISOPEN THEN
      CLOSE l_jobs_cursor;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END StopJob;

PROCEDURE StartOutdoorEventMgr
IS
  l_ret_code NUMBER;
  l_interval UTSYSTEM.SETTING_VALUE%TYPE;
BEGIN
  SELECT SETTING_VALUE
    INTO l_interval
    FROM UTSYSTEM
   WHERE UPPER(SETTING_NAME)=UPPER('OutdoorEvMr_Interval');
                                 -- 12345678901234567890

  DBMS_OUTPUT.PUT_LINE('Starting OutdoorEventMgr');
  l_ret_code:=StartJob('UNI_J_OutdoorEventMgr', l_interval, l_interval, UPPER(ics_package_name||'.OutdoorEventMgr;'));
  DBMS_OUTPUT.PUT_LINE('StartJob returned:'||l_ret_code);
  --'SYSDATE+(15/24/60)'
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM,1,255));
END;

PROCEDURE StopOutdoorEventMgr
IS
  l_ret_code NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Stopping OutdoorEventMgr');
  l_ret_code:=StopJob(UPPER(ics_package_name||'.OutdoorEventMgr;'));
  DBMS_OUTPUT.PUT_LINE('StopJob returned:'||l_ret_code);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM,1,255));
END;

END APAO_OUTDOOR;
/
