CREATE OR REPLACE PACKAGE        APAOFUNCTIONS AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOFUNCTIONS
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 15/03/2007
--   TARGET : Oracle 10.2.0 / Unilab 6.1 sp1 Hotfix 4
--  VERSION : av2.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 15/03/2007 | RS        | mp20061205 Vredestein scope customisaties Unilab v05.doc
--                        | Created
-- 12/04/2007 | RS     | Added ReCheckPa
-- 01/06/2007 | RS     | Changed CopySpecs
-- 15/06/2007 | RS        | V1.2 RS20070615 Technische omschrijving customisaties Unilab.doc
--             | Added DeletePg
--             | Added DeleteEmptyPg
--             | Added DeleteEmptySc
-- 19/07/2007 | AF        | Changed function AssignParameter
-- 10/06/2008 | RS        | Changed function AssignParameter
--                        | Added AddValueToRqGk
--                        | Added RemValueFromRqGk
--                        | Added AddValueToMeGk
--                        | Added RemValueFromMeGk
--                        | Added ReCheckRq
-- 11/06/2008 | RS        | Added LogInfo
-- 25/06/2008 | RS        | Added AddRqComment
--                        | Added AddScComment
--                        | Added AddScPgComment
--                        | Added AddScPaComment
--                        | Added AddScMeComment
-- 06/08/2008 | RS        | Added SaveScIi
--                        | Added CopyRqIiToScIi
-- 25/03/2009 | RS        | Added RecheckRqIc
--                        | Added RecheckScIc
-- 13/02/2013 | RS        | Added Update_LookAndFeel
-- 09/12/2013 | JR        | Added IiCopyIiValue
--                        | Added AddValueToScGk
--                        | Added RemValueFromScGk
--                        | Added SavePartNoAsScGk
-- 12/07/2016 | JP        | Added FillRelatedFields/Sc/Rq
-- 19/08/2016  | JP       | Additional arguments for AssignParameter
-- 20/07/2017 | JR        | Added RecheckWs
-- 16/11/2017 | JR        | Added SaveScAu, Alterd CopyRqIiToScIi (I1711-069-Attribute-save-II_A01)
-- 02/04/2019 | DH        | Added Split_VC and AssignMethod
-- 18/01/2019 | DH        | Added AssignMethod
-- 30/01/2019 | DH        | Add SplitString funtion
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
type values_r is record (vc255 varchar2(255));
   type values_t is table of values_r;  
--
TYPE split_r_tp IS RECORD (vc300 VARCHAR2(300));
--  
--
TYPE split_t_tp IS TABLE OF split_r_tp;
--

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
PROCEDURE LogInfo(avs_function_name  IN VARCHAR2,
                  avs_message        IN VARCHAR2);

FUNCTION AddScMeComment( avs_sc           IN  VARCHAR2,
                         avs_pg           IN  VARCHAR2, avn_pgnode       IN  NUMBER,
                         avs_pa           IN  VARCHAR2, avn_panode       IN  NUMBER,
                         avs_me           IN  VARCHAR2, avn_menode       IN  NUMBER,
                         avs_comment      IN  VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION AddScPaComment( avs_sc           IN  VARCHAR2,
                         avs_pg           IN  VARCHAR2, avn_pgnode       IN  NUMBER,
                         avs_pa           IN  VARCHAR2, avn_panode       IN  NUMBER,
                         avs_comment      IN  VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION AddScPgComment( avs_sc           IN  VARCHAR2,
                         avs_pg           IN  VARCHAR2, avn_pgnode       IN  NUMBER,
                         avs_comment      IN  VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION AddScComment  ( avs_sc           IN  VARCHAR2,
                         avs_comment      IN  VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION AddRqComment  ( avs_rq           IN  VARCHAR2,
                         avs_comment      IN  VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION CreateSample( avs_sc       IN OUT VARCHAR,
         avs_st       IN    VARCHAR2,
        avs_create_ic       IN     VARCHAR2,
        avs_create_pg       IN     VARCHAR2,
                       avs_modify_reason   IN    APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION DeleteEmptySc (avs_sc            IN APAOGEN.NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION DeleteEmptyPg (avs_sc            IN APAOGEN.NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION DeletePg (avs_sc            IN APAOGEN.NAME_TYPE,
                   avs_pg            IN APAOGEN.NAME_TYPE, avn_pgnode IN APAOGEN.NODE_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION AssignParametergroup (avs_sc            IN APAOGEN.NAME_TYPE,
                               avs_pg            IN APAOGEN.NAME_TYPE, avn_pgnode IN OUT APAOGEN.NODE_TYPE,
                               avs_pp_key1   IN APAOGEN.NAME_TYPE,
                               avs_pp_key2   IN APAOGEN.NAME_TYPE,
                               avs_pp_key3   IN APAOGEN.NAME_TYPE,
                               avs_pp_key4   IN APAOGEN.NAME_TYPE,
                               avs_pp_key5   IN APAOGEN.NAME_TYPE,
                               avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE,
                               avs_init         IN BOOLEAN DEFAULT TRUE,
                               avn_seq          IN NUMBER DEFAULT 1,
                               avs_pp_version      IN VARCHAR DEFAULT 'CURRENT')
RETURN APAOGEN.RETURN_TYPE;

FUNCTION AssignParameter (avs_sc             IN APAOGEN.NAME_TYPE,
                          avs_pg             IN APAOGEN.NAME_TYPE, avn_pgnode       IN APAOGEN.NODE_TYPE, avs_pp_version       IN APAOGEN.VERSION_TYPE,
                          avs_pp_key1         IN APAOGEN.NAME_TYPE,
                          avs_pp_key2         IN APAOGEN.NAME_TYPE,
                          avs_pp_key3         IN APAOGEN.NAME_TYPE,
                          avs_pp_key4         IN APAOGEN.NAME_TYPE,
                          avs_pp_key5         IN APAOGEN.NAME_TYPE,
                          avs_pa             IN APAOGEN.NAME_TYPE, avn_panode         OUT APAOGEN.NODE_TYPE, avs_pr_version       IN APAOGEN.VERSION_TYPE,
                          avs_modify_reason  IN APAOGEN.MODIFY_REASON_TYPE,
                          avb_with_details   IN BOOLEAN := TRUE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION CopySpecs(avs_pp             IN APAOGEN.NAME_TYPE,
                   avs_version    IN VARCHAR2,
                   avs_ppkey1         IN VARCHAR2,
                   avs_ppkey2         IN VARCHAR2,
                   avs_ppkey3         IN VARCHAR2,
                   avs_ppkey4         IN VARCHAR2,
                   avs_ppkey5         IN VARCHAR2,
                   avc_spec_set    IN CHAR,
                   avs_sc             IN APAOGEN.NAME_TYPE,
                   avs_pg             IN APAOGEN.NAME_TYPE, avn_pgnode IN APAOGEN.NODE_TYPE,
                   avs_pa             IN APAOGEN.NAME_TYPE, avn_panode IN APAOGEN.NODE_TYPE,
                   avs_modify_reason  IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RecheckMe(avs_sc IN VARCHAR,
       avs_pg IN VARCHAR2, avs_pgnode IN VARCHAR2,
       avs_pa IN VARCHAR2, avs_panode IN VARCHAR2,
       avs_me IN VARCHAR2, avs_menode IN VARCHAR2,
       avs_mt_version IN VARCHAR2,
       avs_lc IN VARCHAR2,
       avs_lc_version IN VARCHAR2,
       avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RecheckPa(avs_sc IN VARCHAR,
       avs_pg IN VARCHAR2, avs_pgnode IN VARCHAR2,
       avs_pa IN VARCHAR2, avs_panode IN VARCHAR2,
       avs_pr_version IN VARCHAR2,
       avs_lc IN VARCHAR2,
       avs_lc_version IN VARCHAR2,
       avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RecheckPg(avs_sc IN VARCHAR,
       avs_pg IN VARCHAR2, avs_pgnode IN VARCHAR2,
       avs_pp_version IN VARCHAR2,
       avs_lc IN VARCHAR2,
       avs_lc_version IN VARCHAR2,
       avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RecheckSc(avs_sc IN VARCHAR,
       avs_st_version IN VARCHAR2,
       avs_lc IN VARCHAR2,
       avs_lc_version IN VARCHAR2,
       avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RecheckRq(avs_rq IN VARCHAR,
       avs_rt_version IN VARCHAR2,
       avs_lc IN VARCHAR2,
       avs_lc_version IN VARCHAR2,
       avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RecheckRqIc(avs_rq IN VARCHAR,
                     avs_ic IN VARCHAR,
                     avs_icnode IN VARCHAR2,
                     avs_ip_version IN VARCHAR2,
                     avs_lc IN VARCHAR2,
                     avs_lc_version IN VARCHAR2,
                     avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RecheckScIc(avs_sc IN VARCHAR,
                     avs_ic IN VARCHAR,
                     avs_icnode IN VARCHAR2,
                     avs_ip_version IN VARCHAR2,
                     avs_lc IN VARCHAR2,
                     avs_lc_version IN VARCHAR2,
                     avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RecheckWs(avs_ws IN VARCHAR,
     avs_lc IN VARCHAR2,
     avs_lc_version IN VARCHAR2,
     avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION EvalAssignmentfreq(avs_sc IN APAOGEN.NAME_TYPE,
                            avs_pp IN APAOGEN.NAME_TYPE)
RETURN BOOLEAN;

FUNCTION AddValueToRqGk(avs_rq    IN APAOGEN.NAME_TYPE,
                        avs_gk    IN APAOGEN.GK_TYPE,
                        avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RemValueFromRqGk(avs_rq    IN APAOGEN.NAME_TYPE,
                          avs_gk    IN APAOGEN.GK_TYPE,
                          avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION AddValueToMeGk(avs_sc    IN APAOGEN.NAME_TYPE,
                        avs_pg    IN APAOGEN.NAME_TYPE, avn_pgnode    IN APAOGEN.NODE_TYPE,
                        avs_pa    IN APAOGEN.NAME_TYPE, avn_panode    IN APAOGEN.NODE_TYPE,
                        avs_me    IN APAOGEN.NAME_TYPE, avn_menode    IN APAOGEN.NODE_TYPE,
                        avs_gk    IN APAOGEN.GK_TYPE,
                        avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RemValueFromMeGk(avs_sc    IN APAOGEN.NAME_TYPE,
                          avs_pg    IN APAOGEN.NAME_TYPE, avn_pgnode    IN APAOGEN.NODE_TYPE,
                          avs_pa    IN APAOGEN.NAME_TYPE, avn_panode    IN APAOGEN.NODE_TYPE,
                          avs_me    IN APAOGEN.NAME_TYPE, avn_menode    IN APAOGEN.NODE_TYPE,
                          avs_gk    IN APAOGEN.GK_TYPE,
                          avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SaveScIi(avs_sc    IN APAOGEN.NAME_TYPE,
                  avs_ic    IN APAOGEN.NAME_TYPE, avn_icnode    IN APAOGEN.NODE_TYPE,
                  avs_ii    IN APAOGEN.NAME_TYPE, avn_iinode    IN APAOGEN.NODE_TYPE,
                  avs_value IN APAOGEN.IIVALUE_TYPE,
                  avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE;


FUNCTION SaveScMeCellValue(avs_sc           IN APAOGEN.NAME_TYPE,
                          avs_pg            IN APAOGEN.NAME_TYPE, avn_pgnode    IN APAOGEN.NODE_TYPE,
                          avs_pa            IN APAOGEN.NAME_TYPE, avn_panode    IN APAOGEN.NODE_TYPE,
                          avs_me            IN APAOGEN.NAME_TYPE, avn_menode    IN APAOGEN.NODE_TYPE,
                          avs_cell          IN APAOGEN.NAME_TYPE,
                          avn_index_x       IN NUMBER,
                          avn_index_y       IN NUMBER,
                          avs_value_f       IN FLOAT,
                          avs_value_s       IN VARCHAR,
                          avn_reanalysis    IN OUT NUMBER,
                          avc_selected      IN CHAR DEFAULT 0)
RETURN APAOGEN.RETURN_TYPE;


FUNCTION SaveScAu(avs_sc    IN APAOGEN.NAME_TYPE,
                  avs_au    IN APAOGEN.NAME_TYPE,
                  avs_value IN APAOGEN.IIVALUE_TYPE,
                  avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION CopyRqIiToScIi(avs_rq    IN APAOGEN.NAME_TYPE,
                        avs_sc    IN APAOGEN.NAME_TYPE,
                        avs_ic    IN APAOGEN.NAME_TYPE, avn_icnode    IN APAOGEN.NODE_TYPE,
                        avs_ii    IN APAOGEN.NAME_TYPE, avn_iinode    IN APAOGEN.NODE_TYPE,
                        avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION Update_LookAndFeel
RETURN APAOGEN.RETURN_TYPE;

FUNCTION IiCopyIiValue(avs_au VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION AddValueToScGk(avs_sc    IN APAOGEN.NAME_TYPE,
                        avs_gk    IN APAOGEN.GK_TYPE,
                        avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION RemValueFromScGk(avs_sc    IN APAOGEN.NAME_TYPE,
                          avs_gk    IN APAOGEN.GK_TYPE,
                          avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SavePartNoAsScGk
RETURN APAOGEN.RETURN_TYPE;

FUNCTION FillRelatedFields (a_object_tp  IN VARCHAR2,
                            a_object_key IN APAOGEN.NAME_TYPE,
                            a_ii         IN APAOGEN.NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION FillRelatedFieldsSc (avs_sc IN APAOGEN.NAME_TYPE,
                              avs_ii IN APAOGEN.NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION FillRelatedFieldsRq (avs_rq IN APAOGEN.NAME_TYPE,
                              avs_ii IN APAOGEN.NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE;

--Added by DH
FUNCTION AssignMethod(avs_sc             IN APAOGEN.NAME_TYPE,
                      avs_pg             IN APAOGEN.NAME_TYPE, avn_pgnode     IN APAOGEN.NODE_TYPE, avs_pp_version      IN APAOGEN.VERSION_TYPE,
                      avs_pp_key1        IN APAOGEN.NAME_TYPE,
                      avs_pp_key2        IN APAOGEN.NAME_TYPE,
                      avs_pp_key3        IN APAOGEN.NAME_TYPE,
                      avs_pp_key4        IN APAOGEN.NAME_TYPE,
                      avs_pp_key5        IN APAOGEN.NAME_TYPE,
                      avs_pa             IN APAOGEN.NAME_TYPE, avn_panode   IN APAOGEN.NODE_TYPE, avs_pr_version      IN APAOGEN.VERSION_TYPE,
                      avs_me             IN APAOGEN.NAME_TYPE, avn_menode   OUT APAOGEN.NODE_TYPE, avs_mt_version      IN APAOGEN.VERSION_TYPE,
                      avn_reanalysis    OUT APAOGEN.NODE_TYPE,
                      avs_modify_reason  IN APAOGEN.MODIFY_REASON_TYPE,
                      avb_with_details   IN BOOLEAN := TRUE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION split_vc_sql (delimited_txt VARCHAR2, delimiter VARCHAR2)
RETURN split_t_tp PIPELINED;

FUNCTION SplitVC (a_delimited_txt IN VARCHAR2, a_delimiter IN VARCHAR2, a_result_tab UNAPIGEN.VC255_TABLE_TYPE)
RETURN NUMBER;


END APAOFUNCTIONS;
/


CREATE OR REPLACE PACKAGE BODY        APAOFUNCTIONS AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOFUNCTIONS
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 15/03/2007
--   TARGET : Oracle 10.2.0 / Unilab 6.3
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 15/03/2007 | RS        | mp20061205 Vredestein scope customisaties Unilab v05.doc
--                        | Created
-- 12/04/2007 | RS      | Added ReCheckPa
-- 01/06/2007 | RS      | Changed CopySpecs
-- 15/06/2007 | RS        | V1.2 RS20070615 Technische omschrijving customisaties Unilab.doc
--             | Added DeletePg
--             | Added DeleteEmptyPg
--             | Added DeleteEmptySc
-- 19/07/2007 | AF        | Changed function AssignParameter
-- 10/06/2008 | RS        | Changed function AssignParameter
--                        | Added AddValueToRqGk
--                        | Added RemValueFromRqGk
--                        | Added AddValueToMeGk
--                        | Added RemValueFromMeGk
--                        | Added ReCheckRq
-- 11/06/2008 | RS        | Added LogInfo
-- 25/06/2008 | RS        | Added AddRqComment
--                        | Added AddScComment
--                        | Added AddScPgComment
--                        | Added AddScPaComment
--                        | Added AddScMeComment
-- 25/06/2008 | RS        | Changed API-calls AddComment into APAOFUNCTIONS.AddComment
-- 06/08/2008 | RS        | Added SaveScIi
--                        | Added CopyRqIiToScIi
-- 25/03/2009 | RS        | Added RecheckRqIc
--                        | Added RecheckScIc
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
--                        | Changed DATE; INTO TIMESTAMP WITH TIME ZONE;
-- 13/02/2012 | RS        | Added Update_LookAndFeel
--                        | Changed AddRqComment
--                        | Changed AddScComment
--                        | Changed AddScPgComment
--                        | Changed AddScPaComment
--                        | Changed AddScMeComment
--             | Changed EvalAssignmentfreq
--                 | Added IiCopyIiValue
--                        | Added AddValueToScGk
--                        | Added RemValueFromScGk
--                        | Added SavePartNoAsScGk
-- 12/07/2016 | JP        | Added FillRelatedFields/Sc/Rq
-- 14/07/2016 | JP        | Modified IiValueAllowed
-- 19/08/2016 | JP        | Additional arguments for AssignParameter
-- 23/08/2016 | JP        | Added object ID quoting in CopySpecs
-- 20/07/2017 | JR        | Added RecheckWs
-- 16/11/2017 | JR        | Added SaveScAu, Altered CopyRqIiToScIi (I1711-069-Attribute-save-II_A01)
--                        | Added DefaultSite
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT APAOGEN.API_NAME_TYPE := 'APAOFUNCTIONS';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
PROCEDURE LogInfo(avs_function_name  IN VARCHAR2,
                  avs_message        IN VARCHAR2)
IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'LogInfo';

BEGIN

   IF APAOGEN.GETSYSTEMSETTING('LOG_INFO', 0) = '1' THEN
      APAOGEN.LogError (avs_function_name, avs_message, FALSE, FALSE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
END LogInfo;

FUNCTION AddScMeComment( avs_sc           IN  VARCHAR2,
                         avs_pg           IN  VARCHAR2, avn_pgnode       IN  NUMBER,
                         avs_pa           IN  VARCHAR2, avn_panode       IN  NUMBER,
                         avs_me           IN  VARCHAR2, avn_menode       IN  NUMBER,
                         avs_comment      IN  VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AddScMeComment';
CURSOR lvq_seq IS
SELECT *
  FROM utscme
 WHERE sc = avs_sc
   AND pg = avs_pg AND pgnode = avn_pgnode
   AND pa = avs_pa AND panode = avn_panode
   AND me = avs_me AND menode = avn_menode;

lvn_tr_seq  NUMBER;
lvn_ev_seq  NUMBER;
lvi_ret_code   APAOGEN.RETURN_TYPE;

BEGIN

   lvi_ret_code := UNAPIGEN.GETTXNID (lvn_tr_seq);
   lvi_ret_code := UNAPIGEN.GETNEXTEVENTSEQNR(lvn_ev_seq);

   FOR lvr_seq IN lvq_seq LOOP
      INSERT
        INTO utscmehs (sc, pg, pgnode, pa, panode, me, menode,
                       who, who_description,
                       what, what_description,
                       logdate,
                       why,
                       tr_seq, ev_seq)
      VALUES (lvr_seq.sc,
              lvr_seq.pg, lvr_seq.pgnode,
              lvr_seq.pa, lvr_seq.panode,
              lvr_seq.me, lvr_seq.menode,
              'UNILAB', 'Unilab 4 Supervisor',
              'CustomComment', 'Custom comment added by ' || lcs_function_name,
              CURRENT_TIMESTAMP,
              avs_comment,
              lvn_tr_seq, lvn_ev_seq);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

END AddScMeComment;

FUNCTION AddScPaComment( avs_sc           IN  VARCHAR2,
                         avs_pg           IN  VARCHAR2, avn_pgnode       IN  NUMBER,
                         avs_pa           IN  VARCHAR2, avn_panode       IN  NUMBER,
                         avs_comment      IN  VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AddScPaComment';
CURSOR lvq_seq IS
SELECT *
  FROM utscpa
 WHERE sc = avs_sc
   AND pg = avs_pg AND pgnode = avn_pgnode
   AND pa = avs_pa AND panode = avn_panode;

lvn_tr_seq  NUMBER;
lvn_ev_seq  NUMBER;
lvi_ret_code   APAOGEN.RETURN_TYPE;

BEGIN

   lvi_ret_code := UNAPIGEN.GETTXNID (lvn_tr_seq);
   lvi_ret_code := UNAPIGEN.GETNEXTEVENTSEQNR(lvn_ev_seq);

   FOR lvr_seq IN lvq_seq LOOP
      INSERT
        INTO utscpahs (sc, pg, pgnode, pa, panode,
                       who, who_description,
                       what, what_description,
                       logdate,
                       why,
                       tr_seq, ev_seq)
      VALUES (lvr_seq.sc,
              lvr_seq.pg, lvr_seq.pgnode,
              lvr_seq.pa, lvr_seq.panode,
              'UNILAB', 'Unilab 4 Supervisor',
              'CustomComment', 'Custom comment added by ' || lcs_function_name,
              CURRENT_TIMESTAMP,
              avs_comment,
              lvn_tr_seq, lvn_ev_seq);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

END AddScPaComment;

FUNCTION AddScPgComment( avs_sc           IN  VARCHAR2,
                         avs_pg           IN  VARCHAR2, avn_pgnode       IN  NUMBER,
                         avs_comment      IN  VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AddScPgComment';
CURSOR lvq_seq IS
SELECT *
  FROM utscpg
 WHERE sc = avs_sc
   AND pg = avs_pg AND pgnode = avn_pgnode;

lvn_tr_seq  NUMBER;
lvn_ev_seq  NUMBER;
lvi_ret_code   APAOGEN.RETURN_TYPE;

BEGIN

   lvi_ret_code := UNAPIGEN.GETTXNID (lvn_tr_seq);
   lvi_ret_code := UNAPIGEN.GETNEXTEVENTSEQNR(lvn_ev_seq);

   FOR lvr_seq IN lvq_seq LOOP
      INSERT
        INTO utscpghs (sc, pg, pgnode,
                       who, who_description,
                       what, what_description,
                       logdate,
                       why,
                       tr_seq, ev_seq)
      VALUES (lvr_seq.sc,
              lvr_seq.pg, lvr_seq.pgnode,
              'UNILAB', 'Unilab 4 Supervisor',
              'CustomComment', 'Custom comment added by ' || lcs_function_name,
              CURRENT_TIMESTAMP,
              avs_comment,
              lvn_tr_seq, lvn_ev_seq);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

END AddScPgComment;

FUNCTION AddScComment  ( avs_sc           IN  VARCHAR2,
                         avs_comment      IN  VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AddScComment';
CURSOR lvq_seq IS
SELECT *
  FROM utsc
 WHERE sc = avs_sc;

lvn_tr_seq  NUMBER;
lvn_ev_seq  NUMBER;
lvi_ret_code   APAOGEN.RETURN_TYPE;

BEGIN

   lvi_ret_code := UNAPIGEN.GETTXNID (lvn_tr_seq);
   lvi_ret_code := UNAPIGEN.GETNEXTEVENTSEQNR(lvn_ev_seq);

   FOR lvr_seq IN lvq_seq LOOP
      INSERT
        INTO utschs   (sc,
                       who, who_description,
                       what, what_description,
                       logdate,
                       why,
                       tr_seq, ev_seq)
      VALUES (lvr_seq.sc,
              'UNILAB', 'Unilab 4 Supervisor',
              'CustomComment', 'Custom comment added by ' || lcs_function_name,
              CURRENT_TIMESTAMP,
              avs_comment,
              lvn_tr_seq, lvn_ev_seq);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

END AddScComment;

FUNCTION AddRqComment  ( avs_rq           IN  VARCHAR2,
                         avs_comment      IN  VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AddRqComment';
CURSOR lvq_seq IS
SELECT *
  FROM utrq
 WHERE rq = avs_rq;

lvn_tr_seq  NUMBER;
lvn_ev_seq  NUMBER;
lvi_ret_code   APAOGEN.RETURN_TYPE;

BEGIN

   lvi_ret_code := UNAPIGEN.GETTXNID (lvn_tr_seq);
   lvi_ret_code := UNAPIGEN.GETNEXTEVENTSEQNR(lvn_ev_seq);

   FOR lvr_seq IN lvq_seq LOOP
      INSERT
        INTO utrqhs   (rq,
                       who, who_description,
                       what, what_description,
                       logdate,
                       why,
                       tr_seq, ev_seq)
      VALUES (lvr_seq.rq,
              'UNILAB', 'Unilab 4 Supervisor',
              'CustomComment', 'Custom comment added by ' || lcs_function_name,
              CURRENT_TIMESTAMP,
              avs_comment,
              lvn_tr_seq, lvn_ev_seq);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

END AddRqComment;

FUNCTION RecheckMe(avs_sc IN VARCHAR,
       avs_pg IN VARCHAR2, avs_pgnode IN VARCHAR2,
       avs_pa IN VARCHAR2, avs_panode IN VARCHAR2,
       avs_me IN VARCHAR2, avs_menode IN VARCHAR2,
       avs_mt_version IN VARCHAR2,
       avs_lc IN VARCHAR2,
       avs_lc_version IN VARCHAR2,
       avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RecheckMe';

lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code    APAOGEN.RETURN_TYPE;
lvs_object_tp     VARCHAR2(4);
lvs_ev_tp         VARCHAR2(60);
lvs_ev_details    VARCHAR2(255);
lvn_seq_nr      APAOGEN.COUNTER_TYPE;

BEGIN

 lvs_object_tp  := 'me';
   lvs_ev_tp      := 'MethodUpdated';
   lvs_ev_details := 'sc='||avs_sc||'#'||
                     'pg='||avs_pg||'#'||'pgnode='||TO_NUMBER(avs_pgnode)||'#'||
                     'pa='||avs_pa||'#'||'panode='||TO_NUMBER(avs_panode)||'#'||
                     'menode='||TO_NUMBER(avs_menode) ||'#'||
        'mt_version=' || avs_mt_version;
   lvn_seq_nr     := 1;
   lvi_ret_code   := UNAPIEV.InsertEvent (lcs_function_name,
                                          UNAPIGEN.P_EVMGR_NAME,
                                          lvs_object_tp,
                                          avs_me,
                                          avs_lc,
                                          avs_lc_version,
                                          avs_ss,
                                          lvs_ev_tp,
                                          lvs_ev_details,
                                          lvn_seq_nr);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Could not insert new event! <' || lvs_ev_details || '>';
      RAISE APAOGEN.API_FAILED;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN lvi_ret_code;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RecheckMe;

FUNCTION RecheckPa(avs_sc IN VARCHAR,
       avs_pg IN VARCHAR2, avs_pgnode IN VARCHAR2,
       avs_pa IN VARCHAR2, avs_panode IN VARCHAR2,
       avs_pr_version IN VARCHAR2,
       avs_lc IN VARCHAR2,
       avs_lc_version IN VARCHAR2,
       avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RecheckPa';

lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code    APAOGEN.RETURN_TYPE;
lvs_object_tp     VARCHAR2(4);
lvs_ev_tp         VARCHAR2(60);
lvs_ev_details    VARCHAR2(255);
lvn_seq_nr      APAOGEN.COUNTER_TYPE;

BEGIN

 lvs_object_tp  := 'pa';
   lvs_ev_tp      := 'ParameterUpdated';
   lvs_ev_details := 'sc='||avs_sc||'#'||
                     'pg='||avs_pg||'#'||'pgnode='||TO_NUMBER(avs_pgnode)||'#'||
                     'panode='||TO_NUMBER(avs_panode) ||'#'||
        'pr_version=' || avs_pr_version;
   lvn_seq_nr     := 1;
   lvi_ret_code   := UNAPIEV.InsertEvent (lcs_function_name,
                                          UNAPIGEN.P_EVMGR_NAME,
                                          lvs_object_tp,
                                          avs_pa,
                                          avs_lc,
                                          avs_lc_version,
                                          avs_ss,
                                          lvs_ev_tp,
                                          lvs_ev_details,
                                          lvn_seq_nr);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Could not insert new event! <' || lvs_ev_details || '>';
      RAISE APAOGEN.API_FAILED;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN lvi_ret_code;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RecheckPa;

FUNCTION RecheckPg(avs_sc IN VARCHAR,
       avs_pg IN VARCHAR2, avs_pgnode IN VARCHAR2,
       avs_pp_version IN VARCHAR2,
       avs_lc IN VARCHAR2,
       avs_lc_version IN VARCHAR2,
       avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RecheckPg';

lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code    APAOGEN.RETURN_TYPE;
lvs_object_tp     VARCHAR2(4);
lvs_ev_tp         VARCHAR2(60);
lvs_ev_details    VARCHAR2(255);
lvn_seq_nr      APAOGEN.COUNTER_TYPE;

BEGIN

 lvs_object_tp  := 'pg';
   lvs_ev_tp      := 'ParameterGroupUpdated';
   lvs_ev_details := 'sc='||avs_sc||'#'||
                     'pgnode='||TO_NUMBER(avs_pgnode) ||'#'||
        'pp_version=' || avs_pp_version;
   lvn_seq_nr     := 1;
   lvi_ret_code   := UNAPIEV.InsertEvent (lcs_function_name,
                                          UNAPIGEN.P_EVMGR_NAME,
                                          lvs_object_tp,
                                          avs_pg,
                                          avs_lc,
                                          avs_lc_version,
                                          avs_ss,
                                          lvs_ev_tp,
                                          lvs_ev_details,
                                          lvn_seq_nr);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Could not insert new event! <' || lvs_ev_details || '>';
      RAISE APAOGEN.API_FAILED;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN lvi_ret_code;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RecheckPg;

FUNCTION RecheckSc(avs_sc IN VARCHAR,
       avs_st_version IN VARCHAR2,
       avs_lc IN VARCHAR2,
       avs_lc_version IN VARCHAR2,
       avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RecheckSc';

lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code    APAOGEN.RETURN_TYPE;
lvs_object_tp     VARCHAR2(4);
lvs_ev_tp         VARCHAR2(60);
lvs_ev_details    VARCHAR2(255);
lvn_seq_nr      APAOGEN.COUNTER_TYPE;

BEGIN

 lvs_object_tp  := 'sc';
   lvs_ev_tp      := 'SampleUpdated';
   lvs_ev_details := 'sc='||avs_sc||'#'||
                     'st_version=' || avs_st_version;
   lvn_seq_nr     := 1;
   lvi_ret_code   := UNAPIEV.InsertEvent (lcs_function_name,
                                          UNAPIGEN.P_EVMGR_NAME,
                                          lvs_object_tp,
                                          avs_sc,
                                          avs_lc,
                                          avs_lc_version,
                                          avs_ss,
                                          lvs_ev_tp,
                                          lvs_ev_details,
                                          lvn_seq_nr);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Could not insert new event! <' || lvs_ev_details || '>';
      RAISE APAOGEN.API_FAILED;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN lvi_ret_code;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RecheckSc;

FUNCTION RecheckRq(avs_rq IN VARCHAR,
       avs_rt_version IN VARCHAR2,
       avs_lc IN VARCHAR2,
       avs_lc_version IN VARCHAR2,
       avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RecheckRq';

lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code    APAOGEN.RETURN_TYPE;
lvs_object_tp     VARCHAR2(4);
lvs_ev_tp         VARCHAR2(60);
lvs_ev_details    VARCHAR2(255);
lvn_seq_nr      APAOGEN.COUNTER_TYPE;

BEGIN

 lvs_object_tp  := 'rq';
   lvs_ev_tp      := 'RequestUpdated';
   lvs_ev_details := 'rq='||avs_rq||'#'||
                     'rt_version=' || avs_rt_version;
   lvn_seq_nr     := 1;
   lvi_ret_code   := UNAPIEV.InsertEvent (lcs_function_name,
                                          UNAPIGEN.P_EVMGR_NAME,
                                          lvs_object_tp,
                                          avs_rq,
                                          avs_lc,
                                          avs_lc_version,
                                          avs_ss,
                                          lvs_ev_tp,
                                          lvs_ev_details,
                                          lvn_seq_nr);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Could not insert new event! <' || lvs_ev_details || '>';
      RAISE APAOGEN.API_FAILED;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN lvi_ret_code;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RecheckRq;


FUNCTION RecheckRqIc(avs_rq IN VARCHAR,
         avs_ic IN VARCHAR,
         avs_icnode IN VARCHAR2,
                     avs_ip_version IN VARCHAR2,
         avs_lc IN VARCHAR2,
         avs_lc_version IN VARCHAR2,
         avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RecheckRqIc';

lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code    APAOGEN.RETURN_TYPE;
lvs_object_tp     VARCHAR2(4);
lvs_ev_tp         VARCHAR2(60);
lvs_ev_details    VARCHAR2(255);
lvn_seq_nr      APAOGEN.COUNTER_TYPE;

BEGIN

 lvs_object_tp  := 'rqic';
   lvs_ev_tp      := 'RqInfoFieldValuesChanged';
   lvs_ev_details := 'rq='||avs_rq||'#'||
                     'icnode=' || avs_icnode || '#' ||
                     'ip_version=' || avs_ip_version;
   lvn_seq_nr     := 1;
   lvi_ret_code   := UNAPIEV.InsertEvent (lcs_function_name,
                                          UNAPIGEN.P_EVMGR_NAME,
                                          lvs_object_tp,
                                          avs_ic,
                                          avs_lc,
                                          avs_lc_version,
                                          avs_ss,
                                          lvs_ev_tp,
                                          lvs_ev_details,
                                          lvn_seq_nr);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Could not insert new event! <' || lvs_ev_details || '>';
      RAISE APAOGEN.API_FAILED;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN lvi_ret_code;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RecheckRqIc;

FUNCTION RecheckScIc(avs_sc IN VARCHAR,
         avs_ic IN VARCHAR,
         avs_icnode IN VARCHAR2,
                     avs_ip_version IN VARCHAR2,
         avs_lc IN VARCHAR2,
         avs_lc_version IN VARCHAR2,
         avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RecheckScIc';

lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code    APAOGEN.RETURN_TYPE;
lvs_object_tp     VARCHAR2(4);
lvs_ev_tp         VARCHAR2(60);
lvs_ev_details    VARCHAR2(255);
lvn_seq_nr      APAOGEN.COUNTER_TYPE;

BEGIN

 lvs_object_tp  := 'ic';
   lvs_ev_tp      := 'InfoFieldValuesChanged';
   lvs_ev_details := 'sc='||avs_sc||'#'||
                     'icnode=' || avs_icnode || '#' ||
                     'ip_version=' || avs_ip_version;
   lvn_seq_nr     := 1;
   lvi_ret_code   := UNAPIEV.InsertEvent (lcs_function_name,
                                          UNAPIGEN.P_EVMGR_NAME,
                                          lvs_object_tp,
                                          avs_ic,
                                          avs_lc,
                                          avs_lc_version,
                                          avs_ss,
                                          lvs_ev_tp,
                                          lvs_ev_details,
                                          lvn_seq_nr);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Could not insert new event! <' || lvs_ev_details || '>';
      RAISE APAOGEN.API_FAILED;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN lvi_ret_code;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RecheckScIc;

FUNCTION RecheckWs(avs_ws IN VARCHAR,
     avs_lc IN VARCHAR2,
     avs_lc_version IN VARCHAR2,
     avs_ss IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RecheckWs';

lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code    APAOGEN.RETURN_TYPE;
lvs_object_tp     VARCHAR2(4);
lvs_ev_tp         VARCHAR2(60);
lvs_ev_details    VARCHAR2(255);
lvn_seq_nr      APAOGEN.COUNTER_TYPE;

BEGIN

 lvs_object_tp  := 'ws';
  --lvs_ev_tp      := 'WorksheetUpdated';
    lvs_ev_tp      := 'WsDetailsUpdated';
 lvs_ev_details := 'ws='||avs_ws||'#'|| 'lc=' || avs_lc ||'#'||  ' lc_version=' || avs_lc_version;
 lvn_seq_nr     := 1;
 lvi_ret_code   := UNAPIEV.InsertEvent (lcs_function_name,
                                          UNAPIGEN.P_EVMGR_NAME,
                                          lvs_object_tp,
                                          avs_ws,
                                          avs_lc,
                                          avs_lc_version,
                                          avs_ss,
                                          lvs_ev_tp,
                                          lvs_ev_details,
                                          lvn_seq_nr);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Could not insert new event! <' || lvs_ev_details || '>';
      RAISE APAOGEN.API_FAILED;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN lvi_ret_code;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RecheckWs;

FUNCTION CreateSample( avs_sc      IN OUT VARCHAR,
          avs_st      IN    VARCHAR2,
         avs_create_ic       IN     VARCHAR2,
         avs_create_pg       IN     VARCHAR2,
                      avs_modify_reason   IN    APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'CreateSample';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvi_row              INTEGER;

lvs_st_version             VARCHAR2(20);
lvd_ref_date               TIMESTAMP WITH TIME ZONE;
lvs_userid                 VARCHAR2(40);
lvi_nr_of_rows             NUMBER;
lts_fieldtype_tab_tab      UNAPIGEN.VC20_TABLE_TYPE;
lts_fieldnames_tab_tab     UNAPIGEN.VC20_TABLE_TYPE;
lts_fieldvalues_tab_tab    UNAPIGEN.VC40_TABLE_TYPE;

BEGIN

 lvs_st_version  := '';
 lvd_ref_date   := CURRENT_TIMESTAMP;
 lvs_userid    := USER;
 lvi_nr_of_rows  := 0;

 lvi_ret_code := UNAPISC.CREATESAMPLE( avs_st,
                           lvs_st_version,
               avs_sc,
                           lvd_ref_date,
                         avs_create_ic,
                         avs_create_pg,
                         lvs_userid,
                         lts_fieldtype_tab_tab,
                         lts_fieldnames_tab_tab,
                         lts_fieldvalues_tab_tab,
                         lvi_nr_of_rows,
                         avs_modify_reason);

   ----------------------------------------------------------------------------
   --give an errormassage when the creation of the sample has failed
   ----------------------------------------------------------------------------
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'CreateSample failed. Return code:' || lvi_ret_code;
      APAOGEN.LogError(lcs_function_name, 'CreateSample: sc=' || avs_sc || ',st=' || avs_st || ',cic=' || avs_create_ic || ',cpg=' || avs_create_pg || ',mr=' || avs_modify_reason);
      RAISE APAOGEN.API_FAILED;
   END IF;

   RETURN (lvi_ret_code);
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN (lvi_ret_code);
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
        APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN (UNAPIGEN.DBERR_GENFAIL);
END CreateSample;

FUNCTION AssignParametergroup (avs_sc            IN APAOGEN.NAME_TYPE,
                               avs_pg            IN APAOGEN.NAME_TYPE, avn_pgnode IN OUT APAOGEN.NODE_TYPE,
                               avs_pp_key1   IN APAOGEN.NAME_TYPE,
                               avs_pp_key2   IN APAOGEN.NAME_TYPE,
                               avs_pp_key3   IN APAOGEN.NAME_TYPE,
                               avs_pp_key4   IN APAOGEN.NAME_TYPE,
                               avs_pp_key5   IN APAOGEN.NAME_TYPE,
                               avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE,
                               avs_init         IN BOOLEAN DEFAULT TRUE,
                               avn_seq          IN NUMBER DEFAULT 1,
                               avs_pp_version      IN VARCHAR DEFAULT 'CURRENT') -- CURRENT = use current version, otherwise use supplied version, format: XXXX.XX e.g. 0001.01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name    CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AssignParametergroup';

lvi_nr_of_rows         APAOGEN.COUNTER_TYPE;
lvs_pp_version_in      APAOGEN.VERSION_TYPE;
lts_pp_version         UNAPIGEN.VC20_TABLE_TYPE;
lts_pp_key1      UNAPIGEN.VC20_TABLE_TYPE;
lts_pp_key2      UNAPIGEN.VC20_TABLE_TYPE;
lts_pp_key3      UNAPIGEN.VC20_TABLE_TYPE;
lts_pp_key4      UNAPIGEN.VC20_TABLE_TYPE;
lts_pp_key5      UNAPIGEN.VC20_TABLE_TYPE;
lts_description        UNAPIGEN.VC40_TABLE_TYPE;
ltf_value              UNAPIGEN.FLOAT_TABLE_TYPE;
lts_value              UNAPIGEN.VC40_TABLE_TYPE;
lts_unit               UNAPIGEN.VC20_TABLE_TYPE;
ltd_exec_start_date    UNAPIGEN.DATE_TABLE_TYPE;
ltd_exec_end_date      UNAPIGEN.DATE_TABLE_TYPE;
lts_executor           UNAPIGEN.VC20_TABLE_TYPE;
lts_planned_executor   UNAPIGEN.VC20_TABLE_TYPE;
ltc_manually_entered   UNAPIGEN.CHAR1_TABLE_TYPE;
ltd_assign_date        UNAPIGEN.DATE_TABLE_TYPE;
lts_assigned_by        UNAPIGEN.VC20_TABLE_TYPE;
ltc_manually_added     UNAPIGEN.CHAR1_TABLE_TYPE;
lts_format             UNAPIGEN.VC40_TABLE_TYPE;
ltc_confirm_assign     UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_allow_any_pr       UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_never_create_methods   UNAPIGEN.CHAR1_TABLE_TYPE;
ltn_delay              UNAPIGEN.NUM_TABLE_TYPE;
lts_delay_unit         UNAPIGEN.VC20_TABLE_TYPE;
ltn_reanalysis         UNAPIGEN.NUM_TABLE_TYPE;
lts_name_class         UNAPIGEN.VC2_TABLE_TYPE;
ltc_log_hs             UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_log_hs_details     UNAPIGEN.CHAR1_TABLE_TYPE;
lts_lc                 UNAPIGEN.VC2_TABLE_TYPE;
lts_lc_version         UNAPIGEN.VC20_TABLE_TYPE;
lvi_row                APAOGEN.COUNTER_TYPE;
lvs_sqlerrm            APAOGEN.ERROR_MSG_TYPE;
lts_sc                 UNAPIGEN.VC20_TABLE_TYPE;
lts_pg                 UNAPIGEN.VC20_TABLE_TYPE;
ltn_pgnode             UNAPIGEN.LONG_TABLE_TYPE;
ltn_modify_flag        UNAPIGEN.NUM_TABLE_TYPE;
lvi_ret_code           INTEGER;
lvn_seq                NUMBER;
lvs_where_clause        VARCHAR2(511);

BEGIN
   ----------------------------------------------------------------------------
   -- Get nmr. of records and get info about parametergroup from database
   ----------------------------------------------------------------------------
   APAO_OUTDOOR.LogError(lcs_function_name, 'Begin ' || lcs_function_name);
   lvn_seq         := 1;
   lvi_nr_of_rows  := NULL;
   lvs_pp_version_in := NULL;
    
   IF avs_init THEN
     lvi_ret_code   := UNAPIPG.INITSCPARAMETERGROUP (avs_pg,
                                             lvs_pp_version_in,
                                             avs_pp_key1, avs_pp_key2, avs_pp_key3, avs_pp_key4, avs_pp_key5,
                                             lvn_seq,
                                             avs_sc,
                                             lts_pp_version,
                                             lts_description,
                                             ltf_value,
                                             lts_value,
                                             lts_unit,
                                             ltd_exec_start_date,
                                             ltd_exec_end_date,
                                             lts_executor,
                                             lts_planned_executor,
                                             ltc_manually_entered,
                                             ltd_assign_date,
                                             lts_assigned_by,
                                             ltc_manually_added,
                                             lts_format,
                                             ltc_confirm_assign,
                                             ltc_allow_any_pr,
                                             ltc_never_create_methods,
                                             ltn_delay,
                                             lts_delay_unit,
                                             ltn_reanalysis,
                                             lts_name_class,
                                             ltc_log_hs,
                                             ltc_log_hs_details,
                                             lts_lc,
                                             lts_lc_version,
                                             lvi_nr_of_rows);
  
     ----------------------------------------------------------------------------
     --give an errormassage when the initialization of the parametergroup has failed
     ----------------------------------------------------------------------------
     IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
        lvs_sqlerrm := 'Initialization of parametergroup <' || avs_pg || '> failed. Returncode = ' || lvi_ret_code;
        RAISE APAOGEN.API_FAILED;
     END IF;
   --ELSE   
   --TW: Alternate way of handling PG creation, to make it possible to assign parameter groups  that are not configured (just like assign any pg in configurator)
   -- Get the parameter profile based on where clause to fill savescparametergroup function with
--   lvs_pp_version_clause := 'version_is_current = ''1''';
--   IF avs_pp_version <> 'CURRENT' THEN
--     lvs_pp_version_clause := 'version = ' || avs_pp_version ;
--   END IF;
--   lvs_where_clause   := 'WHERE PP = ' || avs_pg || ' AND ' || lvs_pp_version_clause;
--   lvi_nr_of_rows     := NULL;
--         DECLARE
--      -- General local variables
--      l_ret_code                  INTEGER;
--      l_row                       INTEGER;
--         
--      -- Specific local variables
--      l_nr_of_rows                NUMBER;
--      l_pp_tab                    Unapigen.VC20_TABLE_TYPE;
--      l_version_tab               Unapigen.VC20_TABLE_TYPE;
--      lts_pp_key1_tab               Unapigen.VC20_TABLE_TYPE;
--      lts_pp_key2_tab               Unapigen.VC20_TABLE_TYPE;
--      lts_pp_key3_tab               Unapigen.VC20_TABLE_TYPE;
--      lts_pp_key4_tab               Unapigen.VC20_TABLE_TYPE;
--      lts_pp_key5_tab               Unapigen.VC20_TABLE_TYPE;
--      l_version_is_current_tab    Unapigen.CHAR1_TABLE_TYPE;
--      l_effective_from_tab        Unapigen.DATE_TABLE_TYPE;
--      l_effective_till_tab        Unapigen.DATE_TABLE_TYPE;
--      l_description_tab           Unapigen.VC40_TABLE_TYPE;
--      l_description2_tab          Unapigen.VC40_TABLE_TYPE;
--      l_unit_tab                  Unapigen.VC20_TABLE_TYPE;
--      l_format_tab                Unapigen.VC40_TABLE_TYPE;
--      l_confirm_assign_tab        Unapigen.CHAR1_TABLE_TYPE;
--      l_allow_any_pr_tab          Unapigen.CHAR1_TABLE_TYPE;
--      l_never_create_methods_tab  Unapigen.CHAR1_TABLE_TYPE;
--      l_delay_tab                 Unapigen.NUM_TABLE_TYPE;
--      l_delay_unit_tab            Unapigen.VC20_TABLE_TYPE;
--      l_is_template_tab           Unapigen.CHAR1_TABLE_TYPE;
--      l_sc_lc_tab                 Unapigen.VC2_TABLE_TYPE;
--      l_sc_lc_version_tab         Unapigen.VC20_TABLE_TYPE;
--      l_inherit_au_tab            Unapigen.CHAR1_TABLE_TYPE;
--      l_pp_class_tab              Unapigen.VC2_TABLE_TYPE;
--      l_log_hs_tab                Unapigen.CHAR1_TABLE_TYPE;
--      l_allow_modify_tab          Unapigen.CHAR1_TABLE_TYPE;
--      l_active_tab                Unapigen.CHAR1_TABLE_TYPE;
--      l_lc_tab                    Unapigen.VC2_TABLE_TYPE;
--      l_lc_version_tab            Unapigen.VC20_TABLE_TYPE;
--      l_ss_tab                    Unapigen.VC2_TABLE_TYPE;
--        
--    BEGIN 
--        
--      -- IN and IN OUT arguments
--      
--      
--        
--      l_ret_code       := Unapipp.GETPARAMETERPROFILE
--                       (l_pp_tab,
--                        l_version_tab,
--                        l_pp_key1_tab,
--                        l_pp_key2_tab,
--                        l_pp_key3_tab,
--                        l_pp_key4_tab,
--                        l_pp_key5_tab,
--                        l_version_is_current_tab,
--                        l_effective_from_tab,
--                        l_effective_till_tab,
--                        l_description_tab,
--                        l_description2_tab,
--                        l_unit_tab,
--                        l_format_tab,
--                        l_confirm_assign_tab,
--                        l_allow_any_pr_tab,
--                        l_never_create_methods_tab,
--                        l_delay_tab,
--                        l_delay_unit_tab,
--                        l_is_template_tab,
--                        l_sc_lc_tab,
--                        l_sc_lc_version_tab,
--                        l_inherit_au_tab,
--                        l_pp_class_tab,
--                        l_log_hs_tab,
--                        l_allow_modify_tab,
--                        l_active_tab,
--                        l_lc_tab,
--                        l_lc_version_tab,
--                        l_ss_tab,
--                        l_nr_of_rows,
--                        l_where_clause);
--         
--      IF l_ret_code <>  Unapigen.DBERR_SUCCESS THEN
--         DBMS_OUTPUT.PUT_LINE('Failed:'|| l_ret_code);
--      ELSE
--         DBMS_OUTPUT.PUT_LINE('Successfully executed');
--         --  OUT and IN OUT simple arguments
--         DBMS_OUTPUT.PUT_LINE('l_nr_of_rows='||l_nr_of_rows);
--         --  OUT and IN OUT array arguments
--         FOR  l_row IN 1..l_nr_of_rows LOOP
--             DBMS_OUTPUT.PUT_LINE('l_pp_tab('||l_row||')='||l_pp_tab(l_row));
--         END  LOOP;
--      END IF;
--    END;
   END IF;

   ----------------------------------------------------------------------------
   --Save the parametergroup with the initialised arguments and variables
   ----------------------------------------------------------------------------

   lvi_row                   := 1;
   lts_sc          (lvi_row) := avs_sc;
   lts_pg          (lvi_row) := avs_pg;
   ltn_pgnode      (lvi_row) := NULL;
   lts_pp_key1     (lvi_row) := avs_pp_key1;
   lts_pp_key2     (lvi_row) := avs_pp_key2;
   lts_pp_key3     (lvi_row) := avs_pp_key3;
   lts_pp_key4     (lvi_row) := avs_pp_key4;
   lts_pp_key5     (lvi_row) := avs_pp_key5;
   ltn_modify_flag (lvi_row) := UNAPIGEN.MOD_FLAG_CREATE;

   lvi_ret_code              := UNAPIPG.SAVESCPARAMETERGROUP ( lts_sc,
                                             lts_pg,
                                             ltn_pgnode,
                                             lts_pp_version,
                                             lts_pp_key1,
                                             lts_pp_key2,
                                             lts_pp_key3,
                                             lts_pp_key4,
                                             lts_pp_key5,
                                             lts_description,
                                             ltf_value,
                                             lts_value,
                                             lts_unit,
                                             ltd_exec_start_date,
                                             ltd_exec_end_date,
                                             lts_executor,
                                             lts_planned_executor,
                                             ltc_manually_entered,
                                             ltd_assign_date,
                                             lts_assigned_by,
                                             ltc_manually_added,
                                             lts_format,
                                             ltc_confirm_assign,
                                             ltc_allow_any_pr,
                                             ltc_never_create_methods,
                                             ltn_delay,
                                             lts_delay_unit,
                                             lts_name_class,
                                             ltc_log_hs,
                                             ltc_log_hs_details,
                                             lts_lc,
                                             lts_lc_version,
                                             ltn_modify_flag,
                                             lvi_nr_of_rows,
                                             avs_modify_reason);

   ----------------------------------------------------------------------------
   --give an errormassage when the initialise of the pg has failed
   ----------------------------------------------------------------------------
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Assignment of parametergroup in database failed ! Returncode=' || lvi_ret_code;
      RAISE APAOGEN.API_FAILED;
   END IF;

   avn_pgnode := ltn_pgnode (lvi_nr_of_rows);
  APAO_OUTDOOR.LogError(lcs_function_name, 'End ' || lcs_function_name);
   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN (lvi_ret_code);
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
        APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN (UNAPIGEN.DBERR_GENFAIL);
END AssignParametergroup;

FUNCTION DeleteEmptySc (avs_sc            IN APAOGEN.NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name    CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'DeleteEmptySc';
lvi_ret_code           INTEGER;
lvi_count      NUMBER;

CURSOR lvq_sc IS
 SELECT sc
   FROM utsc
  WHERE sc = avs_sc
    AND (sc) NOT IN (SELECT sc
           FROM utscpg
          WHERE sc = avs_sc);
BEGIN
 ----------------------------------------------------------------------------
   -- Assume we have nothing to remove
   ----------------------------------------------------------------------------
 lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT;
 ----------------------------------------------------------------------------
   -- Loop through parametergroups to delete
   ----------------------------------------------------------------------------
   FOR lvr_sc IN lvq_sc LOOP
  lvi_ret_code := DeleteSc(lvr_sc.sc);
 END LOOP;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
        APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN (UNAPIGEN.DBERR_GENFAIL);
END DeleteEmptySc;

FUNCTION DeleteEmptyPg (avs_sc            IN APAOGEN.NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name    CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'DeleteEmptyPg';
lvi_ret_code           INTEGER;
lvi_count      NUMBER;

CURSOR lvq_pg IS
 SELECT sc ,pg, pgnode
   FROM utscpg
  WHERE sc = avs_sc
    AND (sc, pg, pgnode) NOT IN (SELECT sc, pg, pgnode
               FROM utscpa
              WHERE sc = avs_sc);
BEGIN
 ----------------------------------------------------------------------------
   -- Assume we have nothing to remove
   ----------------------------------------------------------------------------
 lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT;
 ----------------------------------------------------------------------------
   -- Loop through parametergroups to delete
   ----------------------------------------------------------------------------
   FOR lvr_pg IN lvq_pg LOOP
  lvi_ret_code := APAOFUNCTIONS.DeletePg(lvr_pg.sc, lvr_pg.pg, lvr_pg.pgnode);
 END LOOP;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
        APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN (UNAPIGEN.DBERR_GENFAIL);
END DeleteEmptyPg;

FUNCTION DeletePg (avs_sc            IN APAOGEN.NAME_TYPE,
                   avs_pg            IN APAOGEN.NAME_TYPE, avn_pgnode IN APAOGEN.NODE_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name    CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'DeletePg';
lvi_ret_code           INTEGER;
lvi_count      NUMBER;
BEGIN
 ----------------------------------------------------------------------------
   -- First check if we deal with an empty parametergroup
   ----------------------------------------------------------------------------
   SELECT COUNT(*)
     INTO lvi_count
     FROM utscpa
    WHERE sc = avs_sc
    AND pg = avs_pg AND pgnode = avn_pgnode;
 ----------------------------------------------------------------------------
   -- Exit function if we found parameter(s)
   ----------------------------------------------------------------------------
 IF lvi_count > 0 THEN
  RETURN UNAPIGEN.DBERR_SUCCESS;
 END IF;
   ----------------------------------------------------------------------------
   -- 21CFR11 thus we have to delete it with Oracle statements
   ----------------------------------------------------------------------------
   ----------------------------------------------------------------------------
   -- Delete current parametergroup
   ----------------------------------------------------------------------------
   DELETE
   FROM utscpg
  WHERE sc = avs_sc
    AND pg = avs_pg AND pgnode = avn_pgnode;
 ----------------------------------------------------------------------------
   -- Delete attributes of the current parametergroup
   ----------------------------------------------------------------------------
 DELETE
   FROM utscpgau
  WHERE sc = avs_sc
    AND pg = avs_pg AND pgnode = avn_pgnode;
 ---------------------------------------------------------------------------
   -- Delete the auditrail of the current parametergroup
   ----------------------------------------------------------------------------
 DELETE
   FROM utscpghs
  WHERE sc = avs_sc
    AND pg = avs_pg AND pgnode = avn_pgnode;

 DELETE
   FROM utscpghsdetails
  WHERE sc = avs_sc
    AND pg = avs_pg AND pgnode = avn_pgnode;

 --------------------------------------------------------------------------------
 -- Add comment to sample that this pg has been deleted
 --------------------------------------------------------------------------------
 lvi_ret_code := APAOFUNCTIONS.AddScComment( avs_sc, 'Parametergroup <' || avs_pg || '> has been deleted');

 RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
        APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN (UNAPIGEN.DBERR_GENFAIL);
END DeletePg;

FUNCTION AssignParameter (avs_sc             IN APAOGEN.NAME_TYPE,
                          avs_pg             IN APAOGEN.NAME_TYPE, avn_pgnode       IN APAOGEN.NODE_TYPE, avs_pp_version       IN APAOGEN.VERSION_TYPE,
                          avs_pp_key1         IN APAOGEN.NAME_TYPE,
                          avs_pp_key2         IN APAOGEN.NAME_TYPE,
                          avs_pp_key3         IN APAOGEN.NAME_TYPE,
                          avs_pp_key4         IN APAOGEN.NAME_TYPE,
                          avs_pp_key5         IN APAOGEN.NAME_TYPE,
                          avs_pa             IN APAOGEN.NAME_TYPE, avn_panode         OUT APAOGEN.NODE_TYPE, avs_pr_version       IN APAOGEN.VERSION_TYPE,
                          avs_modify_reason  IN APAOGEN.MODIFY_REASON_TYPE,
                          avb_with_details   IN BOOLEAN := TRUE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name ||'.AssignParameter';

lvn_seq              APAOGEN.COUNTER_TYPE;
lts_pr_version       UNAPIGEN.VC20_TABLE_TYPE;
lvi_nr_of_rows       APAOGEN.COUNTER_TYPE;
lvi_row              APAOGEN.COUNTER_TYPE;
lvs_sqlerrm          APAOGEN.ERROR_MSG_TYPE;
lvc_alarms_handled   APAOGEN.FLAG_TYPE;
lts_sc               UNAPIGEN.VC20_TABLE_TYPE;
lts_pg               UNAPIGEN.VC20_TABLE_TYPE;
ltn_pgnode           UNAPIGEN.LONG_TABLE_TYPE;
lts_pa               UNAPIGEN.VC20_TABLE_TYPE;
ltn_panode           UNAPIGEN.LONG_TABLE_TYPE;
ltn_modify_flag      UNAPIGEN.NUM_TABLE_TYPE;
lts_description      UNAPIGEN.VC40_TABLE_TYPE;
ltf_value            UNAPIGEN.FLOAT_TABLE_TYPE;
lts_value_s          UNAPIGEN.VC40_TABLE_TYPE;
lts_unit             UNAPIGEN.VC20_TABLE_TYPE;
ltd_exec_start_date  UNAPIGEN.DATE_TABLE_TYPE;
ltd_exec_end_date    UNAPIGEN.DATE_TABLE_TYPE;
lts_executor         UNAPIGEN.VC20_TABLE_TYPE;
lts_planned_executor UNAPIGEN.VC20_TABLE_TYPE;
ltc_manually_entered UNAPIGEN.CHAR1_TABLE_TYPE;
ltd_assign_date      UNAPIGEN.DATE_TABLE_TYPE;
lts_assigned_by      UNAPIGEN.VC20_TABLE_TYPE;
ltc_manually_added   UNAPIGEN.CHAR1_TABLE_TYPE;
lts_format           UNAPIGEN.VC40_TABLE_TYPE;
ltn_td_info          UNAPIGEN.NUM_TABLE_TYPE;
lts_td_info_unit     UNAPIGEN.VC20_TABLE_TYPE;
ltc_confirm_uid      UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_allow_any_me     UNAPIGEN.CHAR1_TABLE_TYPE;
ltn_delay            UNAPIGEN.NUM_TABLE_TYPE;
lts_delay_unit       UNAPIGEN.VC20_TABLE_TYPE;
ltn_min_nr_results   UNAPIGEN.NUM_TABLE_TYPE;
ltc_calc_parameter   UNAPIGEN.CHAR1_TABLE_TYPE;
lts_calc_cf          UNAPIGEN.VC20_TABLE_TYPE;
lts_alarm_order      UNAPIGEN.VC3_TABLE_TYPE;
ltc_valid_specsa     UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_valid_specsb     UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_valid_specsc     UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_valid_limitsa    UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_valid_limitsb    UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_valid_limitsc    UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_valid_targeta    UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_valid_targetb    UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_valid_targetc    UNAPIGEN.CHAR1_TABLE_TYPE;
lts_mt               UNAPIGEN.VC20_TABLE_TYPE;
lts_mt_version       UNAPIGEN.VC20_TABLE_TYPE;
ltn_mt_nr_measur     UNAPIGEN.NUM_TABLE_TYPE;
ltc_log_exceptions   UNAPIGEN.CHAR1_TABLE_TYPE;
ltn_reanalysis       UNAPIGEN.NUM_TABLE_TYPE;
lts_pa_class         UNAPIGEN.VC2_TABLE_TYPE;
ltc_log_hs           UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_log_hs_details   UNAPIGEN.CHAR1_TABLE_TYPE;
lts_lc               UNAPIGEN.VC2_TABLE_TYPE;
lts_lc_version       UNAPIGEN.VC20_TABLE_TYPE;
lvi_ret_code         APAOGEN.RETURN_TYPE;

BEGIN
   ----------------------------------------------------------------------------
   --Get nmr. of records and get info about parameter from database
   ----------------------------------------------------------------------------
   lvi_nr_of_rows     := NULL;
   lvi_ret_code       := UNAPIPA.INITSCPARAMETER (avs_pa,
                                                  avs_pr_version,
                                                  lvn_seq,
                                                  avs_sc,
                                                  avs_pg,
                                                  avn_pgnode,
                                                  avs_pp_version,
                                                  avs_pp_key1,
                                                  avs_pp_key2,
                                                  avs_pp_key3,
                                                  avs_pp_key4,
                                                  avs_pp_key5,
                                                  lts_pr_version,
                                                  lts_description,
                                                  ltf_value,
                                                  lts_value_s,
                                                  lts_unit,
                                                  ltd_exec_start_date,
                                                  ltd_exec_end_date,
                                                  lts_executor,
                                                  lts_planned_executor,
                                                  ltc_manually_entered,
                                                  ltd_assign_date,
                                                  lts_assigned_by,
                                                  ltc_manually_added,
                                                  lts_format,
                                                  ltn_td_info,
                                                  lts_td_info_unit,
                                                  ltc_confirm_uid,
                                                  ltc_allow_any_me,
                                                  ltn_delay,
                                                  lts_delay_unit,
                                                  ltn_min_nr_results,
                                                  ltc_calc_parameter,
                                                  lts_calc_cf,
                                                  lts_alarm_order,
                                                  ltc_valid_specsa,
                                                  ltc_valid_specsb,
                                                  ltc_valid_specsc,
                                                  ltc_valid_limitsa,
                                                  ltc_valid_limitsb,
                                                  ltc_valid_limitsc,
                                                  ltc_valid_targeta,
                                                  ltc_valid_targetb,
                                                  ltc_valid_targetc,
                                                  lts_mt,
                                                  lts_mt_version,
                                                  ltn_mt_nr_measur,
                                                  ltc_log_exceptions,
                                                  ltn_reanalysis,
                                                  lts_pa_class,
                                                  ltc_log_hs,
                                                  ltc_log_hs_details,
                                                  lts_lc,
                                                  lts_lc_version,
                                                  lvi_nr_of_rows);
   ----------------------------------------------------------------------------
   --give an errormassage when the initialise of the pg has failed
   ----------------------------------------------------------------------------
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Initialization of parameter failed';
      RAISE APAOGEN.API_FAILED;
   END IF;

   ----------------------------------------------------------------------------
   --Save the parameter with the initialised arguments and variables
   ----------------------------------------------------------------------------
   lvc_alarms_handled        := '0';
   lvi_row                   := 1;
   lts_sc          (lvi_row) := avs_sc;
   lts_pg          (lvi_row) := avs_pg;
   ltn_pgnode      (lvi_row) := avn_pgnode;
   lts_pa          (lvi_row) := avs_pa;
   ltn_panode      (lvi_row) := NULL;

   IF avb_with_details THEN
      ltn_modify_flag (lvi_row) := UNAPIGEN.MOD_FLAG_CREATE;
   ELSE
      ltn_modify_flag (lvi_row) := UNAPIGEN.MOD_FLAG_INSERT;
   END IF;

   lvi_ret_code              := UNAPIPA.SAVESCPARAMETER (lvc_alarms_handled,
                                                         lts_sc,
                                                         lts_pg,
                                                         ltn_pgnode,
                                                         lts_pa,
                                                         ltn_panode,
                                                         lts_pr_version,
                                                         lts_description,
                                                         ltf_value,
                                                         lts_value_s,
                                                         lts_unit,
                                                         ltd_exec_start_date,
                                                         ltd_exec_end_date,
                                                         lts_executor,
                                                         lts_planned_executor,
                                                         ltc_manually_entered,
                                                         ltd_assign_date,
                                                         lts_assigned_by,
                                                         ltc_manually_added,
                                                         lts_format,
                                                         ltn_td_info,
                                                         lts_td_info_unit,
                                                         ltc_confirm_uid,
                                                         ltc_allow_any_me,
                                                         ltn_delay,
                                                         lts_delay_unit,
                                                         ltn_min_nr_results,
                                                         ltc_calc_parameter,
                                                         lts_calc_cf,
                                                         lts_alarm_order,
                                                         ltc_valid_specsa,
                                                         ltc_valid_specsb,
                                                         ltc_valid_specsc,
                                                         ltc_valid_limitsa,
                                                         ltc_valid_limitsb,
                                                         ltc_valid_limitsc,
                                                         ltc_valid_targeta,
                                                         ltc_valid_targetb,
                                                         ltc_valid_targetc,
                                                         lts_mt,
                                                         lts_mt_version,
                                                         ltn_mt_nr_measur,
                                                         ltc_log_exceptions,
                                                         lts_pa_class,
                                                         ltc_log_hs,
                                                         ltc_log_hs_details,
                                                         lts_lc,
                                                         lts_lc_version,
                                                         ltn_modify_flag,
                                                         lvi_nr_of_rows,
                                                         avs_modify_reason);
   ----------------------------------------------------------------------------
   --give an errormassage when the initialise of the pg has failed
   ----------------------------------------------------------------------------
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'UNAPIPA.SAVESCPARAMETER failed for <'||avs_sc||'><'||avs_pg||'><'||avn_pgnode||'><'||avs_pa||'>. Errorcode: ' || lvi_ret_code;
      RAISE APAOGEN.API_FAILED;
   END IF;

   avn_panode := ltn_panode (lvi_nr_of_rows);

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN (lvi_ret_code);
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
        APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN (UNAPIGEN.DBERR_GENFAIL);
END AssignParameter;

FUNCTION CopySpecs(avs_pp             IN APAOGEN.NAME_TYPE,
                   avs_version        IN VARCHAR2,
                   avs_ppkey1         IN VARCHAR2,
                   avs_ppkey2         IN VARCHAR2,
                   avs_ppkey3         IN VARCHAR2,
                   avs_ppkey4         IN VARCHAR2,
                   avs_ppkey5         IN VARCHAR2,
                   avc_spec_set    IN CHAR,
                   avs_sc             IN APAOGEN.NAME_TYPE,
                   avs_pg             IN APAOGEN.NAME_TYPE, avn_pgnode IN APAOGEN.NODE_TYPE,
                   avs_pa             IN APAOGEN.NAME_TYPE, avn_panode IN APAOGEN.NODE_TYPE,
                   avs_modify_reason  IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name  CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'CopySpecs';

lvs_sqlerrm      APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code     APAOGEN.RETURN_TYPE;
lvi_row            INTEGER;
lvi_row2            INTEGER;

--Specific local variables GetSpecs
lts_pp_tab           UNAPIGEN.VC20_TABLE_TYPE;
lts_version_tab      UNAPIGEN.VC20_TABLE_TYPE;
lts_pp_key1_tab      UNAPIGEN.VC20_TABLE_TYPE;
lts_pp_key2_tab      UNAPIGEN.VC20_TABLE_TYPE;
lts_pp_key3_tab      UNAPIGEN.VC20_TABLE_TYPE;
lts_pp_key4_tab      UNAPIGEN.VC20_TABLE_TYPE;
lts_pp_key5_tab      UNAPIGEN.VC20_TABLE_TYPE;
lts_pr_tab           UNAPIGEN.VC20_TABLE_TYPE;
lts_pr_version_tab   UNAPIGEN.VC20_TABLE_TYPE;
lvs_where_clause     VARCHAR2(511);
--Specific local variables SaveSpecs
lvi_nr_of_rows       NUMBER;
lts_sc_tab           UNAPIGEN.VC20_TABLE_TYPE;
lts_pg_tab           UNAPIGEN.VC20_TABLE_TYPE;
ltn_pgnode_tab       UNAPIGEN.LONG_TABLE_TYPE;
lts_pa_tab           UNAPIGEN.VC20_TABLE_TYPE;
ltn_panode_tab       UNAPIGEN.LONG_TABLE_TYPE;
ltf_low_limit_tab    UNAPIGEN.FLOAT_TABLE_TYPE;
ltf_high_limit_tab   UNAPIGEN.FLOAT_TABLE_TYPE;
ltf_low_spec_tab     UNAPIGEN.FLOAT_TABLE_TYPE;
ltf_high_spec_tab    UNAPIGEN.FLOAT_TABLE_TYPE;
ltf_low_dev_tab      UNAPIGEN.FLOAT_TABLE_TYPE;
ltc_rel_low_dev_tab  UNAPIGEN.CHAR1_TABLE_TYPE;
ltf_target_tab       UNAPIGEN.FLOAT_TABLE_TYPE;
ltf_high_dev_tab     UNAPIGEN.FLOAT_TABLE_TYPE;
ltc_rel_high_dev_tab UNAPIGEN.CHAR1_TABLE_TYPE;
ltn_modify_flag_tab  UNAPIGEN.NUM_TABLE_TYPE;

BEGIN

 lvi_nr_of_rows  := NULL;
 lvs_where_clause  := 'WHERE pp      = ''' || REPLACE (avs_pp    , '''', '''''')  ||
         ''' AND version = ''' ||          avs_version                ||
         ''' AND pp_key1 = ''' || REPLACE (avs_ppkey1, '''', '''''')  ||
         ''' AND pp_key2 = ''' || REPLACE (avs_ppkey2, '''', '''''')  ||
         ''' AND pp_key3 = ''' || REPLACE (avs_ppkey3, '''', '''''')  ||
         ''' AND pp_key4 = ''' || REPLACE (avs_ppkey4, '''', '''''')  ||
         ''' AND pp_key5 = ''' || REPLACE (avs_ppkey5, '''', '''''')  ||
         ''' AND pr      = ''' || REPLACE (avs_pa  , '''', '''''')  ||
         '''';
 --------------------------------------------------------------------------------
 -- Get specs for avs_pp
 --------------------------------------------------------------------------------
 lvi_ret_code := UNAPIPP.GETPPPARAMETERSPECS (lts_pp_tab,
                            lts_version_tab,
                            lts_pp_key1_tab,
                            lts_pp_key2_tab,
                            lts_pp_key3_tab,
                            lts_pp_key4_tab,
                            lts_pp_key5_tab,
                            lts_pr_tab,
                            lts_pr_version_tab,
                            ltf_low_limit_tab,
                            ltf_high_limit_tab,
                            ltf_low_spec_tab,
                            ltf_high_spec_tab,
                            ltf_low_dev_tab,
                            ltc_rel_low_dev_tab,
                            ltf_target_tab,
                            ltf_high_dev_tab,
                            ltc_rel_high_dev_tab,
                            avc_spec_set,
                            lvi_nr_of_rows,
                            lvs_where_clause);

 IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS AND lvi_nr_of_rows > 0 THEN
  --------------------------------------------------------------------------------
  -- Ok, spec found for avs_pp, avs_ppkey1, avs_ppkey2, avs_ppkey3, avs_ppkey4, avs_ppkey5
  --------------------------------------------------------------------------------
  lvi_row2 := 0;
  FOR lvi_row IN 1..lvi_nr_of_rows LOOP
   --------------------------------------------------------------------------------
   -- Ok, also spec found for avs_pa
   --------------------------------------------------------------------------------
   IF lts_pr_tab(lvi_row)      = avs_pa AND
            lts_pp_key1_tab(lvi_row) = avs_ppkey1 AND
            lts_pp_key2_tab(lvi_row) = avs_ppkey2 AND
            lts_pp_key3_tab(lvi_row) = avs_ppkey3 AND
            lts_pp_key4_tab(lvi_row) = avs_ppkey4 AND
            lts_pp_key5_tab(lvi_row) = avs_ppkey5 THEN
       --------------------------------------------------------------------------------
     -- Fill new array
     --------------------------------------------------------------------------------
     lvi_row2 := lvi_row2 + 1;
       lts_sc_tab(lvi_row2)    := avs_sc;
       lts_pg_tab(lvi_row2)    := avs_pg;
       ltn_pgnode_tab(lvi_row2)   := avn_pgnode;
       lts_pa_tab(lvi_row2)    := avs_pa;
       ltn_panode_tab(lvi_row2)   := avn_panode;
           ltf_low_limit_tab(lvi_row2)  := ltf_low_limit_tab(lvi_row);
           ltf_high_limit_tab(lvi_row2)  := ltf_high_limit_tab(lvi_row);
           ltf_low_spec_tab(lvi_row2)  := ltf_low_spec_tab(lvi_row);
           ltf_high_spec_tab(lvi_row2)  := ltf_high_spec_tab(lvi_row);
           ltf_low_dev_tab(lvi_row2)   := ltf_low_dev_tab(lvi_row);
           ltc_rel_low_dev_tab(lvi_row2) := ltc_rel_low_dev_tab(lvi_row);
           ltf_target_tab(lvi_row2)   := ltf_target_tab(lvi_row);
           ltf_high_dev_tab(lvi_row2)  := ltf_high_dev_tab(lvi_row);
           ltc_rel_high_dev_tab(lvi_row2):= ltc_rel_high_dev_tab(lvi_row);
       ltn_modify_flag_tab(lvi_row2) := UNAPIGEN.MOD_FLAG_INSERT;
   END IF;
  END LOOP;

  lvi_nr_of_rows := lvi_row2;
  --------------------------------------------------------------------------------
  -- Save specs to avs_pg
  --------------------------------------------------------------------------------
  lvi_ret_code := UNAPIPA.SAVESCPASPECS (avc_spec_set,
                           lts_sc_tab,
                           lts_pg_tab,
                           ltn_pgnode_tab,
                           lts_pa_tab,
                           ltn_panode_tab,
                           ltf_low_limit_tab,
                           ltf_high_limit_tab,
                           ltf_low_spec_tab,
                           ltf_high_spec_tab,
                           ltf_low_dev_tab,
                           ltc_rel_low_dev_tab,
                           ltf_target_tab,
                           ltf_high_dev_tab,
                           ltc_rel_high_dev_tab,
                           ltn_modify_flag_tab,
                           lvi_nr_of_rows,
                           avs_modify_reason);

lvs_sqlerrm := 'Saving specset ' || avc_spec_set || ' of ' || avs_pp || ' to sc <' || avs_sc || '> pg <' || avs_pg  || '> pa <' || avs_pa  || '>.';
APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);

    IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
   lvs_sqlerrm := 'Saving specset ' || avc_spec_set || ' of ' || avs_pp || ' to sc <' || avs_sc || '> pg <' || avs_pg  || '> pa <' || avs_pa  || '> failed. Return code :<' || lvi_ret_code || '>.';
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
 ELSE
  lvs_sqlerrm := 'Retrieving specset ' || avc_spec_set || ' of ' || avs_pp || ' failed. Return code :<' || lvi_ret_code || '>.';
  --APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
 END IF;

   RETURN lvi_ret_code;

EXCEPTION
WHEN APAOGEN.API_FAILED THEN
   APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   RETURN (lvi_ret_code);
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
        APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN (UNAPIGEN.DBERR_GENFAIL);
END CopySpecs;

FUNCTION EvalAssignmentfreq(avs_sc IN APAOGEN.NAME_TYPE,
                            avs_pp IN APAOGEN.NAME_TYPE)
RETURN BOOLEAN IS

lcs_function_name    CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'EvalAssignmentfreq';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvb_ret_code     BOOLEAN;
lvi_row                    INTEGER;
--Specific local variables
lvs_main_object_tp         VARCHAR2(2);
lvs_main_object_id         VARCHAR2(20);
lvs_main_object_version    VARCHAR2(20);
lvs_object_tp              VARCHAR2(4);
lvs_object_id              VARCHAR2(20);
lvs_object_version         VARCHAR2(20);
lvc_freq_tp                CHAR(1);
lvi_freq_val               NUMBER;
lvs_freq_unit              VARCHAR2(20);
lvc_invert_freq            CHAR(1);
lvd_ref_date               TIMESTAMP WITH TIME ZONE;
lvd_last_sched             TIMESTAMP WITH TIME ZONE;
lvi_last_cnt               NUMBER;
lvs_last_val               VARCHAR2(40);

BEGIN

 BEGIN
   SELECT b.sc, b.st_version,
      a.freq_tp, a.freq_val, a.freq_unit, a.invert_freq,
      a.last_sched, a.last_cnt, a.last_val
    INTO lvs_main_object_id, lvs_main_object_version,
         lvc_freq_tp, lvi_freq_val, lvs_freq_unit, lvc_invert_freq,
       lvd_last_sched, lvi_last_cnt, lvs_last_val
    FROM utstpp a, utsc b
   WHERE b.sc = avs_sc
     AND a.st = b.st
     AND a.version = b.st_version
     AND a.pp = avs_pp;

  EXCEPTION
  WHEN NO_DATA_FOUND THEN
     RETURN FALSE;
  END;

 lvs_main_object_tp  := 'sc';
 lvs_object_tp    := ''; --currently not used
 lvs_object_id    := ''; --currently not used
 lvs_object_version  := ''; --currently not used
 lvd_ref_date    := CURRENT_TIMESTAMP;

 lvb_ret_code := UNAPIAUT.EVALASSIGNMENTFREQ(lvs_main_object_tp,
                           lvs_main_object_id,
                           lvs_main_object_version,
                           lvs_object_tp,
                           lvs_object_id,
                           lvs_object_version,
                           lvc_freq_tp,
                           lvi_freq_val,
                           lvs_freq_unit,
                           lvc_invert_freq,
                           lvd_ref_date,
                           lvd_last_sched,
                           lvi_last_cnt,
                           lvs_last_val);

   RETURN lvb_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
        APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN FALSE;
END EvalAssignmentfreq;

FUNCTION AddValueToRqGk(avs_rq    IN APAOGEN.NAME_TYPE,
                        avs_gk    IN APAOGEN.GK_TYPE,
                        avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AddValueToRqGk';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;

lvs_gk_version      VARCHAR2(20) := '';
lvt_value_tab       UNAPIGEN.VC40_TABLE_TYPE;
lvi_nr_of_rows      NUMBER;
lvs_modify_reason   APAOGEN.MODIFY_REASON_TYPE;

CURSOR lvq_gk(avs_rq IN VARCHAR2,
              avs_gk IN VARCHAR2) IS
  SELECT value
    FROM utrqgk
   WHERE rq = avs_rq
     AND gk = avs_gk;

BEGIN

   lvi_nr_of_rows := 1;
   --------------------------------------------------------------------------------
   -- Retrieve all existing values of rqgk avs_gk
   --------------------------------------------------------------------------------
   FOR lvr_gk IN lvq_gk(avs_rq, avs_gk) LOOP
      lvt_value_tab(lvi_nr_of_rows) := lvr_gk.value;
      lvi_nr_of_rows := lvi_nr_of_rows + 1;
   END LOOP;
   --------------------------------------------------------------------
   -- Fill new values of rqgk avs_gk
   --------------------------------------------------------------------------------
   lvt_value_tab(lvi_nr_of_rows) := avs_value;
   --------------------------------------------------------------------
   -- Fill modify reason
   --------------------------------------------------------------------------------
   lvs_modify_reason := 'Groupkey assigned by ' || lcs_function_name;
   --------------------------------------------------------------------
   -- Save the rqgk avs_gk
   --------------------------------------------------------------------------------
   lvi_ret_code := UNAPIRQP.SAVE1RQGROUPKEY(avs_rq,
                                            avs_gk,
                                            lvs_gk_version,
                                            lvt_value_tab,
                                            lvi_nr_of_rows,
                                            lvs_modify_reason);
   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Assignment of rqgk "' || avs_gk || '" with value "' || avs_value || '" failed for "' || avs_rq || '". Returncode <' || lvi_ret_code || '>';
      APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END AddValueToRqGk;

FUNCTION RemValueFromRqGk(avs_rq    IN APAOGEN.NAME_TYPE,
                          avs_gk    IN APAOGEN.GK_TYPE,
                          avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RemValueFromRqGk';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;

lvt_gk              UNAPIGEN.VC20_TABLE_TYPE;
lvt_gk_version      UNAPIGEN.VC20_TABLE_TYPE;
lvt_value           UNAPIGEN.VC40_TABLE_TYPE;
lvi_nr_of_rows      NUMBER;
lvs_modify_reason   APAOGEN.MODIFY_REASON_TYPE;

CURSOR lvq_gk(avs_rq    IN VARCHAR2) IS
  SELECT gk, value
    FROM utrqgk
   WHERE rq = avs_rq;

BEGIN

   lvi_nr_of_rows := 0;
   --------------------------------------------------------------------------------
   -- Retrieve all existing values of rqgk avs_gk
   --------------------------------------------------------------------------------
   FOR lvr_gk IN lvq_gk(avs_rq) LOOP
      IF lvr_gk.gk != avs_gk OR lvr_gk.value != avs_value THEN
        lvi_nr_of_rows                 := lvi_nr_of_rows + 1;
        lvt_gk(lvi_nr_of_rows)         := lvr_gk.gk;
        lvt_gk_version(lvi_nr_of_rows) := '';
        lvt_value(lvi_nr_of_rows)      := lvr_gk.value;
      END IF;
   END LOOP;
   --------------------------------------------------------------------
   -- Fill modify reason
   --------------------------------------------------------------------------------
   lvs_modify_reason := 'Groupkey updated by ' || lcs_function_name;
   --------------------------------------------------------------------
   -- Save the rqgk avs_gk
   --------------------------------------------------------------------------------
   lvi_ret_code := UNAPIRQP.SAVERQGROUPKEY( avs_rq,
                                            lvt_gk,
                                            lvt_gk_version,
                                            lvt_value,
                                            lvi_nr_of_rows,
                                            lvs_modify_reason);
   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Removal of rqgk "' || avs_gk || '" with value "' || avs_value || '" failed for "' || avs_rq || '". Returncode <' || lvi_ret_code || '>';
      APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END RemValueFromRqGk;

FUNCTION AddValueToMeGk(avs_sc    IN APAOGEN.NAME_TYPE,
                        avs_pg    IN APAOGEN.NAME_TYPE, avn_pgnode    IN APAOGEN.NODE_TYPE,
                        avs_pa    IN APAOGEN.NAME_TYPE, avn_panode    IN APAOGEN.NODE_TYPE,
                        avs_me    IN APAOGEN.NAME_TYPE, avn_menode    IN APAOGEN.NODE_TYPE,
                        avs_gk    IN APAOGEN.GK_TYPE,
                        avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AddValueToMeGk';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;

lvs_gk_version      VARCHAR2(20) := '';
lvt_value_tab       UNAPIGEN.VC40_TABLE_TYPE;
lvi_nr_of_rows      NUMBER;
lvs_modify_reason   APAOGEN.MODIFY_REASON_TYPE;

CURSOR lvq_gk(avs_sc IN VARCHAR2,
              avs_pg IN VARCHAR2, avn_pgnode IN NUMBER,
              avs_pa IN VARCHAR2, avn_panode IN NUMBER,
              avs_me IN VARCHAR2, avn_menode IN NUMBER,
              avs_gk IN VARCHAR2) IS
  SELECT value
    FROM utscmegk
   WHERE sc = avs_sc
     AND pg = avs_pg AND pgnode = avn_pgnode
     AND pa = avs_pa AND panode = avn_panode
     AND me = avs_me AND menode = avn_menode
     AND gk = avs_gk;

BEGIN

   lvi_nr_of_rows := 1;
   --------------------------------------------------------------------------------
   -- Retrieve all existing values of megk avs_gk
   --------------------------------------------------------------------------------
   FOR lvr_gk IN lvq_gk(avs_sc,
                        avs_pg, avn_pgnode,
                        avs_pa, avn_panode,
                        avs_me, avn_menode,
                        avs_gk) LOOP
      lvt_value_tab(lvi_nr_of_rows) := lvr_gk.value;
      lvi_nr_of_rows := lvi_nr_of_rows + 1;
   END LOOP;
   --------------------------------------------------------------------
   -- Fill new values of megk avs_gk
   --------------------------------------------------------------------------------
   lvt_value_tab(lvi_nr_of_rows) := avs_value;
   --------------------------------------------------------------------
   -- Fill modify reason
   --------------------------------------------------------------------------------
   lvs_modify_reason := 'Groupkey assigned by ' || lcs_function_name;
   --------------------------------------------------------------------
   -- Save the rqgk avs_gk
   --------------------------------------------------------------------------------
   lvi_ret_code := UNAPIMEP.SAVE1SCMEGROUPKEY(avs_sc,
                                              avs_pg, avn_pgnode,
                                              avs_pa, avn_panode,
                                              avs_me, avn_menode,
                                              avs_gk,
                                              lvs_gk_version,
                                              lvt_value_tab,
                                              lvi_nr_of_rows,
                                              lvs_modify_reason);
   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Assignment of megk "' || avs_gk || '" with value "' || avs_value || '" failed for "' || avs_sc || '#' || avs_pg || '#' || avn_pgnode  || '#' || avs_pa || '#' || avn_panode || '#' || avs_me || '#' || avn_menode || '". Returncode <' || lvi_ret_code || '>';
      APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END AddValueToMeGk;

FUNCTION RemValueFromMeGk(avs_sc    IN APAOGEN.NAME_TYPE,
                          avs_pg    IN APAOGEN.NAME_TYPE, avn_pgnode    IN APAOGEN.NODE_TYPE,
                          avs_pa    IN APAOGEN.NAME_TYPE, avn_panode    IN APAOGEN.NODE_TYPE,
                          avs_me    IN APAOGEN.NAME_TYPE, avn_menode    IN APAOGEN.NODE_TYPE,
                          avs_gk    IN APAOGEN.GK_TYPE,
                          avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RemValueFromMeGk';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;

lvt_gk              UNAPIGEN.VC20_TABLE_TYPE;
lvt_gk_version      UNAPIGEN.VC20_TABLE_TYPE;
lvt_value           UNAPIGEN.VC40_TABLE_TYPE;
lvi_nr_of_rows      NUMBER;
lvs_modify_reason   APAOGEN.MODIFY_REASON_TYPE;

CURSOR lvq_gk(avs_sc IN VARCHAR2,
              avs_pg IN VARCHAR2, avn_pgnode IN NUMBER,
              avs_pa IN VARCHAR2, avn_panode IN NUMBER,
              avs_me IN VARCHAR2, avn_menode IN NUMBER,
              avs_gk IN VARCHAR2) IS
  SELECT gk, value
    FROM utscmegk
   WHERE sc = avs_sc
     AND pg = avs_pg AND pgnode = avn_pgnode
     AND pa = avs_pa AND panode = avn_panode
     AND me = avs_me AND menode = avn_menode
     AND gk = avs_gk;

BEGIN

   lvi_nr_of_rows := 0;
   --------------------------------------------------------------------------------
   -- Retrieve all existing values of megk avs_gk
   --------------------------------------------------------------------------------
   FOR lvr_gk IN lvq_gk(avs_sc,
                        avs_pg, avn_pgnode,
                        avs_pa, avn_panode,
                        avs_me, avn_menode,
                        avs_gk) LOOP
      IF lvr_gk.gk != avs_gk OR lvr_gk.value != avs_value THEN
        lvi_nr_of_rows                 := lvi_nr_of_rows + 1;
        lvt_gk(lvi_nr_of_rows)         := lvr_gk.gk;
        lvt_gk_version(lvi_nr_of_rows) := '';
        lvt_value(lvi_nr_of_rows)      := lvr_gk.value;
      END IF;
   END LOOP;
   --------------------------------------------------------------------
   -- Fill modify reason
   --------------------------------------------------------------------------------
   lvs_modify_reason := 'Groupkey updated by ' || lcs_function_name;
   --------------------------------------------------------------------
   -- Save the rqgk avs_gk
   --------------------------------------------------------------------------------
   lvi_ret_code := UNAPIMEP.SAVESCMEGROUPKEY(avs_sc,
                                             avs_pg, avn_pgnode,
                                             avs_pa, avn_panode,
                                             avs_me, avn_menode,
                                             lvt_gk,
                                             lvt_gk_version,
                                             lvt_value,
                                             lvi_nr_of_rows,
                                             lvs_modify_reason);
   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Removal of megk "' || avs_gk || '" with value "' || avs_value || '" failed for "' || avs_sc || '#' || avs_pg || '#' || avn_pgnode  || '#' || avs_pa || '#' || avn_panode || '#' || avs_me || '#' || avn_menode || '". Returncode <' || lvi_ret_code || '>';
      APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END RemValueFromMeGk;

FUNCTION SaveScIi(avs_sc    IN APAOGEN.NAME_TYPE,
                  avs_ic    IN APAOGEN.NAME_TYPE, avn_icnode    IN APAOGEN.NODE_TYPE,
                  avs_ii    IN APAOGEN.NAME_TYPE, avn_iinode    IN APAOGEN.NODE_TYPE,
                  avs_value IN APAOGEN.IIVALUE_TYPE,
                  avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SaveScIi';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;

lvi_row                         INTEGER;
lvi_nr_of_rows                  NUMBER;

lts_sc_tab                      UNAPIGEN.VC20_TABLE_TYPE;
lts_ic_tab                      UNAPIGEN.VC20_TABLE_TYPE;
ltn_icnode_tab                  UNAPIGEN.LONG_TABLE_TYPE;
lts_ii_tab                      UNAPIGEN.VC20_TABLE_TYPE;
ltn_iinode_tab                  UNAPIGEN.LONG_TABLE_TYPE;
lts_iivalue_tab                 UNAPIGEN.VC2000_TABLE_TYPE;
lts_modify_flag_tab             UNAPIGEN.NUM_TABLE_TYPE;

BEGIN
  lvi_nr_of_rows := 1;

  FOR lvi_row IN 1..lvi_nr_of_rows LOOP
    lts_sc_tab(lvi_row)            := avs_sc;
    lts_ic_tab(lvi_row)            := avs_ic;
    ltn_icnode_tab(lvi_row)        := avn_icnode;
    lts_ii_tab(lvi_row)            := avs_ii;
    ltn_iinode_tab(lvi_row)        := avn_iinode;
    lts_iivalue_tab(lvi_row)       := avs_value;
    lts_modify_flag_tab(lvi_row)   := UNAPIGEN.MOD_FLAG_UPDATE;
  END LOOP;

  lvi_ret_code := UNAPIIC.SAVESCIIVALUE (lts_sc_tab,
                                         lts_ic_tab,
                                         ltn_icnode_tab,
                                         lts_ii_tab,
                                         ltn_iinode_tab,
                                         lts_iivalue_tab,
                                         lts_modify_flag_tab,
                                         lvi_nr_of_rows,
                                         avs_modify_reason);

   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Saving infofield  "' || avs_ii || '" with value "' || avs_value || '" failed for "' || avs_sc || '#' || avs_ic || '#' || avs_ii || '". Returncode <' || lvi_ret_code || '>';
      APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END SaveScIi;

FUNCTION SaveScAu(avs_sc    IN APAOGEN.NAME_TYPE,
                  avs_au    IN APAOGEN.NAME_TYPE,
                  avs_value IN APAOGEN.IIVALUE_TYPE,
                  avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SaveScAu';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;

lvi_nr_of_rows              NUMBER;
lvs_where_clause            VARCHAR2(255);
lts_sc_tab                  UNAPIGEN.VC20_TABLE_TYPE;
lts_au_tab                  UNAPIGEN.VC20_TABLE_TYPE;
lts_au_version_tab          UNAPIGEN.VC20_TABLE_TYPE;
lts_value_tab               UNAPIGEN.VC40_TABLE_TYPE;
lts_description_tab         UNAPIGEN.VC40_TABLE_TYPE;
lts_is_protected_tab        UNAPIGEN.CHAR1_TABLE_TYPE;
lts_single_valued_tab       UNAPIGEN.CHAR1_TABLE_TYPE;
lts_new_val_allowed_tab     UNAPIGEN.CHAR1_TABLE_TYPE;
lts_store_db_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
lts_value_list_tp_tab       UNAPIGEN.CHAR1_TABLE_TYPE;
lts_run_mode_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
lts_service_tab             UNAPIGEN.VC255_TABLE_TYPE;
lts_cf_value_tab            UNAPIGEN.VC20_TABLE_TYPE;
lvb_changed                 BOOLEAN := FALSE;


BEGIN
  lvi_nr_of_rows := NULL;
  lvs_where_clause := 'WHERE sc = ''' || avs_sc || '''';
  lvi_ret_code       := UNAPISCP.GETSCATTRIBUTE
                   (lts_sc_tab,
                    lts_au_tab,
                    lts_au_version_tab,
                    lts_value_tab,
                    lts_description_tab,
                    lts_is_protected_tab,
                    lts_single_valued_tab,
                    lts_new_val_allowed_tab,
                    lts_store_db_tab,
                    lts_value_list_tp_tab,
                    lts_run_mode_tab,
                    lts_service_tab,
                    lts_cf_value_tab,
                    lvi_nr_of_rows,
                    lvs_where_clause);
   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Getting attributes for ' || avs_sc || 'Failed. Returncode <' || lvi_ret_code || '>';
      APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN lvi_ret_code;
   END IF;

  FOR lvi_row IN 1..lvi_nr_of_rows LOOP
    IF lts_au_tab(lvi_row) = avs_au THEN
        lts_value_tab(lvi_row) := avs_value;
        lvb_changed := TRUE;
    END IF;
  END LOOP;
  IF NOT lvb_changed THEN
    lvi_nr_of_rows := lvi_nr_of_rows + 1;
    lts_au_tab(lvi_nr_of_rows)          := avs_au;
    lts_au_version_tab(lvi_nr_of_rows)  := NULL;
    lts_value_tab(lvi_nr_of_rows)       := avs_value;
    lvb_changed := TRUE;
  END IF;

  IF lvb_changed THEN
      lvi_ret_code := UNAPISCP.SAVESCATTRIBUTE
                       (avs_sc,
                        lts_au_tab,
                        lts_au_version_tab,
                        lts_value_tab,
                        lvi_nr_of_rows,
                        avs_modify_reason);

       IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
          lvs_sqlerrm := 'Saving attribute  "' || avs_au || '" with value "' || avs_value || '" failed for "' || avs_sc || '". Returncode <' || lvi_ret_code || '>';
          APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
          RETURN lvi_ret_code;
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
END SaveScAu;


FUNCTION SaveScMeCellValue(avs_sc           IN APAOGEN.NAME_TYPE,
                          avs_pg            IN APAOGEN.NAME_TYPE, avn_pgnode    IN APAOGEN.NODE_TYPE,
                          avs_pa            IN APAOGEN.NAME_TYPE, avn_panode    IN APAOGEN.NODE_TYPE,
                          avs_me            IN APAOGEN.NAME_TYPE, avn_menode    IN APAOGEN.NODE_TYPE,
                          avs_cell          IN APAOGEN.NAME_TYPE,
                          avn_index_x       IN NUMBER,
                          avn_index_y       IN NUMBER,
                          avs_value_f       IN FLOAT,
                          avs_value_s       IN VARCHAR,
                          avn_reanalysis    IN OUT NUMBER,
                          avc_selected      IN CHAR DEFAULT 0)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SaveScMeCellValue';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;

lvi_row                         INTEGER;
lvi_nr_of_rows                  NUMBER;

lts_sc_tab                      UNAPIGEN.VC20_TABLE_TYPE;
lts_pg_tab                      UNAPIGEN.VC20_TABLE_TYPE;
ltn_pgnode_tab                  UNAPIGEN.LONG_TABLE_TYPE;
lts_pa_tab                      UNAPIGEN.VC20_TABLE_TYPE;
ltn_panode_tab                  UNAPIGEN.LONG_TABLE_TYPE;
lts_me_tab                      UNAPIGEN.VC20_TABLE_TYPE;
ltn_menode_tab                  UNAPIGEN.LONG_TABLE_TYPE;
ltn_reanalysis_tab              UNAPIGEN.NUM_TABLE_TYPE;
lts_cell_tab                    UNAPIGEN.VC20_TABLE_TYPE;
ltn_index_x                     UNAPIGEN.NUM_TABLE_TYPE;
ltn_index_y                     UNAPIGEN.NUM_TABLE_TYPE;
lts_value_f_tab                 UNAPIGEN.FLOAT_TABLE_TYPE;
lts_value_s_tab                 UNAPIGEN.VC40_TABLE_TYPE;
ltc_selected                    UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
  lvi_nr_of_rows := 1;

  FOR lvi_row IN 1..lvi_nr_of_rows LOOP
--    lts_sc_tab(lvi_row)      := avs_sc;
--    lts_pg_tab(lvi_row)      := avs_pg;
--    ltn_pgnode_tab(lvi_row)  := avn_pgnode;
--    lts_pa_tab(lvi_row)      := avs_pa;
--    ltn_panode_tab(lvi_row)  := avn_panode;
--    lts_me_tab(lvi_row)      := avs_me;
--    ltn_menode_tab(lvi_row)  := avn_menode;
--    ltn_reanalysis_tab(lvi_row):= avn_reanalysis;
    lts_cell_tab(lvi_row)    := avs_cell;
    ltn_index_x (lvi_row)    := avn_index_x;
    ltn_index_y (lvi_row)    := avn_index_y;
    lts_value_f_tab(lvi_row) := avs_value_f;
    lts_value_s_tab(lvi_row) := avs_value_s;
    ltc_selected(lvi_row)    := avc_selected;
    
  END LOOP;

  lvi_ret_code := UNAPIME.SaveScMeCellValues(avs_sc,
                                            avs_pg,  avn_pgnode,
                                            avs_pa,  avn_panode,
                                            avs_me,  avn_menode,
                                            avn_reanalysis,
                                            lts_cell_tab,
                                            ltn_index_x,
                                            ltn_index_y,
                                            lts_value_f_tab,
                                            lts_value_s_tab,
                                            ltc_selected,
                                            1, 
                                            -1);

   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Saving method cell value  "' || avs_me || '" with value_f "' || avs_value_f || ' or value_s ' || avs_value_s || '" failed for " sc: ' || avs_sc || '# pg: ' || avs_pg || '# p: ' || avs_pa || '". Returncode <' || lvi_ret_code || '>';
      APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END SaveScMeCellValue;

--------------------------------------------------------------------------------
-- This function checks whether a given infofield value is allowed for a given sample,
-- based on the list/SQL values associated with the infofield.
FUNCTION IiValueAllowed (a_value      IN APAOGEN.IIVALUE_TYPE,
                         a_sc         IN APAOGEN.NAME_TYPE,
                         a_ie         IN APAOGEN.NAME_TYPE,
                         a_ie_version IN APAOGEN.VERSION_TYPE)
RETURN BOOLEAN
IS
   lcs_function_name CONSTANT VARCHAR2 (30) := 'IiValueAllowed';
   l_count           INTEGER;
   l_utiesql_cursor  INTEGER;
   l_result          NUMBER;
   l_sql_string      VARCHAR2 (10000);
   l_dsp_tp          utie.dsp_tp%TYPE;
   l_look_up_ptr     utie.look_up_ptr%TYPE;
   l_sqltext         utiesql.sqltext%TYPE;
   l_found           BOOLEAN := FALSE;
BEGIN

   SELECT dsp_tp, look_up_ptr
      INTO l_dsp_tp, l_look_up_ptr
      FROM utie
      WHERE ie = a_ie
        AND version = a_ie_version;

   IF l_dsp_tp NOT IN ('L', 'D') THEN -- Listbox, Dropdown list.
      RETURN TRUE; -- Not a restrictive control, allow any value.
   END IF;

   IF l_look_up_ptr = 'utielist' THEN

      SELECT COUNT (*)
         INTO l_count
         FROM utielist
         WHERE ie = a_ie
           AND version = a_ie_version
           AND VALUE = a_value;
      IF l_count > 0 THEN
         RETURN TRUE; -- Value found in utielist.
      ELSE
         RETURN FALSE; -- Value not found in utielist.
      END IF;

   ELSIF l_look_up_ptr = 'utiesql' THEN

      FOR sqltext IN (SELECT sqltext
                      FROM utiesql
                      WHERE ie      = a_ie
                        AND version = a_ie_version
                        AND sqltext IS NOT NULL
                      ORDER BY seq) LOOP
         l_sql_string := l_sql_string || ' ' || sqltext.sqltext;
      END LOOP;

      l_sql_string := REPLACE (l_sql_string, '~ii@', '~scii@') ; -- Resolve inconsistency between client and server tilde-substitution.
      l_result := UNAPIGEN.SubstituteAllTildesInText ('sc', a_sc, l_sql_string) ;

      l_utiesql_cursor := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE (l_utiesql_cursor, l_sql_string, DBMS_SQL.V7);
      DBMS_SQL.DEFINE_COLUMN (l_utiesql_cursor, 1, l_sqltext, 255);
      l_result := DBMS_SQL.EXECUTE_AND_FETCH (l_utiesql_cursor);
      LOOP
         EXIT WHEN (l_result = 0) OR (l_found = TRUE);
         DBMS_SQL.COLUMN_VALUE (l_utiesql_cursor, 1, l_sqltext);
         IF l_sqltext = a_value THEN
            l_found := TRUE;
         END IF;
         l_result := DBMS_SQL.FETCH_ROWS (l_utiesql_cursor);
      END LOOP;
      DBMS_SQL.CLOSE_CURSOR (l_utiesql_cursor);
      IF l_found THEN
         RETURN TRUE; -- Value found in list generated by utiesql.
      ELSE
         RETURN FALSE; -- Value not found in list generated by utiesql.
      END IF;

   ELSE

      RETURN TRUE; -- No predefined list, allow any value.

   END IF;

EXCEPTION
   WHEN OTHERS THEN
      UNAPIGEN.LogError (lcs_function_name, SUBSTR (SQLERRM, 0, 255));
      IF DBMS_SQL.IS_OPEN (l_utiesql_cursor) THEN
         DBMS_SQL.CLOSE_CURSOR (l_utiesql_cursor);
      END IF;
      RETURN FALSE;
END IiValueAllowed;

-- When a given value is not allowed for the 'site' infofield,
-- this function will attempt to find an alternative site where it *is* allowed.
FUNCTION DefaultSite (avs_site         IN  APAOGEN.IIVALUE_TYPE,
                      a_sc             IN  APAOGEN.NAME_TYPE,
                      a_ie             IN  APAOGEN.NAME_TYPE,
                      a_ie_version     IN  APAOGEN.VERSION_TYPE,
                      avs_default_site OUT APAOGEN.IIVALUE_TYPE)
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'DefaultSite';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;

BEGIN

   -- First try to find a site where this value is allowed within the same region.
   FOR site IN (SELECT site
                FROM ataoregion
                WHERE region = (SELECT region FROM ataoregion WHERE site = avs_site)
                ORDER BY ranking) LOOP
      IF IiValueAllowed (site.site, a_sc, a_ie, a_ie_version) THEN
         avs_default_site := site.site;
         RETURN TRUE;
      END IF;
   END LOOP;

   -- Next try to find a site globally.
   FOR site IN (SELECT site
                FROM ataoregion
                ORDER BY ranking) LOOP
      IF IiValueAllowed (site.site, a_sc, a_ie, a_ie_version) THEN
         avs_default_site := site.site;
         RETURN TRUE;
      END IF;
   END LOOP;

   UNAPIGEN.LogError (lcs_function_name, 'No default found for site '||avs_site||'.');
   RETURN FALSE;

EXCEPTION
   WHEN OTHERS THEN
      UNAPIGEN.LogError (lcs_function_name, SUBSTR (SQLERRM, 0, 255));
      RETURN FALSE;

END DefaultSite;

FUNCTION CopyRqIiToScIi (avs_rq    IN APAOGEN.NAME_TYPE,
                         avs_sc    IN APAOGEN.NAME_TYPE,
                         avs_ic    IN APAOGEN.NAME_TYPE, avn_icnode    IN APAOGEN.NODE_TYPE,
                         avs_ii    IN APAOGEN.NAME_TYPE, avn_iinode    IN APAOGEN.NODE_TYPE,
                         avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'CopyRqIiToScIi';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE := UNAPIGEN.DBERR_SUCCESS;
lvs_default_site    APAOGEN.IIVALUE_TYPE;

-- If the fields are dates, convert the format between rq and sc.
CURSOR lvq_ii IS
SELECT r.rq, s.sc, s.ic, s.icnode, s.ii, s.iinode, s.ie_version,
       DECODE (r.dsp_tp, 'G', TO_CHAR (TO_DATE (r.iivalue, SUBSTR (NVL (ri.format, 'DDDfx/fxMM/RR HH24fx:fxMI:SS'), 2)),
                                                           SUBSTR (NVL (si.format, 'DDDfx/fxMM/RR HH24fx:fxMI:SS'), 2)), r.iivalue) AS iivalue
       , ri.valid_cf
       , si.ievalue
  FROM utscii s, utrqii r, utie si, utie ri
 WHERE s.sc = avs_sc
   AND s.ic = avs_ic AND s.icnode = avn_icnode
   AND s.ii = avs_ii AND s.iinode = avn_iinode
   AND r.rq = avs_rq
   AND s.ii = r.ii
   AND s.ii = si.ie
   AND s.ie_version = si.version
   AND r.ii = ri.ie
   AND r.ie_version = ri.version;

-- The next query will copy over some infofields that differ in name
-- between request and sample. An ie attribute is used to control which
-- fields are copied.
CURSOR lvq_ii2 IS
SELECT r.rq, s.sc, s.ic, s.icnode, s.ii, s.iinode, s.ie_version,
       DECODE (r.dsp_tp, 'G', TO_CHAR (TO_DATE (r.iivalue, SUBSTR (NVL (ri.format, 'DDDfx/fxMM/RR HH24fx:fxMI:SS'), 2)),
                                                           SUBSTR (NVL (si.format, 'DDDfx/fxMM/RR HH24fx:fxMI:SS'), 2)), r.iivalue) AS iivalue
       , ri.valid_cf
       , si.ievalue
  FROM utscii s, utrqii r, utieau i, utie si, utie ri
 WHERE s.sc = avs_sc
   AND r.rq = avs_rq
   AND s.ii = i.ie
   AND s.ie_version = i.version
   AND i.au = 'avCustRqIiCopyFrom'
   AND r.ii = i.value
   AND s.ii = si.ie
   AND s.ie_version = si.version
   AND r.ii = ri.ie
   AND r.ie_version = ri.version;

BEGIN
   FOR lvr_ii IN lvq_ii LOOP
      IF IiValueAllowed (lvr_ii.iivalue, lvr_ii.sc, lvr_ii.ii, lvr_ii.ie_version) THEN
        -- Be Aware! First the attributes and after that the infofield!
         IF lvr_ii.valid_cf = 'SaveAsAttribute'  OR lvr_ii.valid_cf = 'SaveAsAuAndSaveIc' THEN
             lvi_ret_code := APAOFUNCTIONS.SaveScAu (lvr_ii.sc,
                                                     lvr_ii.ievalue,
                                                     lvr_ii.iivalue,
                                                     avs_modify_reason);
         END IF;
         lvi_ret_code := APAOFUNCTIONS.SaveScIi (lvr_ii.sc,
                                                 lvr_ii.ic, lvr_ii.icnode,
                                                 lvr_ii.ii, lvr_ii.iinode,
                                                 lvr_ii.iivalue,
                                                 avs_modify_reason);
      ELSIF ( lvr_ii.ii = 'avScSite' AND DefaultSite (lvr_ii.iivalue, lvr_ii.sc, lvr_ii.ii, lvr_ii.ie_version, lvs_default_site) ) THEN
         lvi_ret_code := APAOFUNCTIONS.SaveScIi (lvr_ii.sc,
                                                 lvr_ii.ic, lvr_ii.icnode,
                                                 lvr_ii.ii, lvr_ii.iinode,
                                                 lvs_default_site,
                                                 avs_modify_reason);
      END IF;
      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         EXIT; -- SaveScIi should already have logged an error.
      END IF ;
    END LOOP;

   FOR lvr_ii2 IN lvq_ii2 LOOP
      IF IiValueAllowed (lvr_ii2.iivalue, lvr_ii2.sc, lvr_ii2.ii, lvr_ii2.ie_version) THEN
         -- Be Aware! First the attributes and after that the infofield!
         IF lvr_ii2.valid_cf = 'SaveAsAttribute'  OR lvr_ii2.valid_cf = 'SaveAsAuAndSaveIc' THEN
             lvi_ret_code := APAOFUNCTIONS.SaveScAu (lvr_ii2.sc,
                                                     lvr_ii2.ievalue,
                                                     lvr_ii2.iivalue,
                                                     avs_modify_reason);
         END IF;
         lvi_ret_code := APAOFUNCTIONS.SaveScIi (lvr_ii2.sc,
                                                 lvr_ii2.ic, lvr_ii2.icnode,
                                                 lvr_ii2.ii, lvr_ii2.iinode,
                                                 lvr_ii2.iivalue,
                                                 avs_modify_reason);
      ELSIF ( lvr_ii2.ii = 'avScSite' AND DefaultSite (lvr_ii2.iivalue, lvr_ii2.sc, lvr_ii2.ii, lvr_ii2.ie_version, lvs_default_site) ) THEN
         lvi_ret_code := APAOFUNCTIONS.SaveScIi (lvr_ii2.sc,
                                                 lvr_ii2.ic, lvr_ii2.icnode,
                                                 lvr_ii2.ii, lvr_ii2.iinode,
                                                 lvs_default_site,
                                                 avs_modify_reason);
      END IF;
      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         EXIT; -- SaveScIi should already have logged an error.
      END IF ;
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END CopyRqIiToScIi;

FUNCTION Update_LookAndFeel
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'Update_LookAndFeel';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_up IS
  SELECT up
    FROM utup;

CURSOR lvq_us(avs_up IN VARCHAR2) IS
  SELECT a.us, b.setting_value DBA
    FROM utupus a, utsystem b
   WHERE a.up = avs_up
     AND b.setting_name = 'LIMSADMIN_NAME'
     AND a.us != b.setting_value;

lvi_ret_code APAOGEN.RETURN_TYPE;

BEGIN

   FOR lvr_up IN lvq_up LOOP
      FOR lvr_us IN lvq_us(lvr_up.up) LOOP
         lvi_ret_code := APAOGEN.EXECUTESQL('DELETE FROM UTUPUSOUTLOOKPAGES WHERE up = ''' || lvr_up.up || ''' AND us = ''' || lvr_us.us || '''');
         lvi_ret_code := APAOGEN.EXECUTESQL('DELETE FROM UTUPUSOUTLOOKTASKS WHERE up = ''' || lvr_up.up || ''' AND us = ''' || lvr_us.us || '''');
         lvi_ret_code := APAOGEN.EXECUTESQL('INSERT INTO UTUPUSOUTLOOKPAGES SELECT up, ''' || lvr_us.us ||''', seq, page_id, page_description, page_tp, active FROM UTUPUSOUTLOOKPAGES WHERE up = ''' || lvr_up.up || ''' AND us = ''' || lvr_us.DBA || '''');
         lvi_ret_code := APAOGEN.EXECUTESQL('INSERT INTO UTUPUSOUTLOOKTASKS SELECT up, ''' || lvr_us.us ||''', page_id, seq, tk, tk_tp, description, icon_name, icon_nbr, cmd_line, active FROM UTUPUSOUTLOOKTASKS WHERE up = ''' || lvr_up.up || ''' AND us = ''' || lvr_us.DBA || '''');
      END LOOP;
   END LOOP;

   RETURN 0;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN SQLERRM;

END Update_LookAndFeel;


FUNCTION IiCopyIiValue(avs_au VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'IiCopyIiValue';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_ii IS
SELECT b.sc, b.ic, b.icnode, b.ii , b.iinode, c.iivalue
  FROM utipieau a, utscii b, utscii c
 WHERE a.ip = UNAPIEV.P_IC AND a.version = UNAPIEV.P_IP_VERSION AND a.ie = UNAPIEV.P_II AND a.ie_version = '~Current~'
   AND b.sc = UNAPIEV.P_SC AND b.sc = c.sc AND c.icnode = UNAPIEV.P_ICNODE AND c.iinode = UNAPIEV.P_IINODE
   AND b.ic = APAOGEN.STRTOK(value, ';', 1)
   AND b.ii = APAOGEN.STRTOK(value, ';', 2)
   AND a.au = avs_au;

lvi_ret_code APAOGEN.RETURN_TYPE;

BEGIN

   FOR lvr_ii IN lvq_ii LOOP
      lvi_ret_code := SaveScIi(lvr_ii.sc,
                               lvr_ii.ic, lvr_ii.icnode,
                               lvr_ii.ii, lvr_ii.iinode,
                               lvr_ii.iivalue,
                               'Infofield updated by <' || lcs_function_name || '>');
   END LOOP;

   RETURN 0;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN SQLERRM;

END IiCopyIiValue;


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

   lvi_nr_of_rows := 1;
   --------------------------------------------------------------------------------
   -- Retrieve all existing values of scgk avs_gk
   --------------------------------------------------------------------------------
   FOR lvr_gk IN lvq_gk(avs_sc, avs_gk) LOOP
      lvt_value_tab(lvi_nr_of_rows) := lvr_gk.value;
      lvi_nr_of_rows := lvi_nr_of_rows + 1;
   END LOOP;
   --------------------------------------------------------------------
   -- Fill new values of rqgk avs_gk
   --------------------------------------------------------------------------------
   lvt_value_tab(lvi_nr_of_rows) := avs_value;
   --------------------------------------------------------------------
   -- Fill modify reason
   --------------------------------------------------------------------------------
   lvs_modify_reason := 'Groupkey assigned by ' || lcs_function_name;
   --------------------------------------------------------------------
   -- Save the rqgk avs_gk
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

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END AddValueToScGk;

FUNCTION RemValueFromScGk(avs_sc    IN APAOGEN.NAME_TYPE,
                          avs_gk    IN APAOGEN.GK_TYPE,
                          avs_value IN APAOGEN.GKVALUE_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RemValueFromScGk';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;

lvt_gk              UNAPIGEN.VC20_TABLE_TYPE;
lvt_gk_version      UNAPIGEN.VC20_TABLE_TYPE;
lvt_value           UNAPIGEN.VC40_TABLE_TYPE;
lvi_nr_of_rows      NUMBER;
lvs_modify_reason   APAOGEN.MODIFY_REASON_TYPE;

CURSOR lvq_gk(avs_sc    IN VARCHAR2) IS
  SELECT gk, value
    FROM utscgk
   WHERE sc = avs_sc;

BEGIN

   lvi_nr_of_rows := 0;
   --------------------------------------------------------------------------------
   -- Retrieve all existing values of scgk avs_gk
   --------------------------------------------------------------------------------
   FOR lvr_gk IN lvq_gk(avs_sc) LOOP
      IF lvr_gk.gk != avs_gk OR lvr_gk.value != avs_value THEN
        lvi_nr_of_rows                 := lvi_nr_of_rows + 1;
        lvt_gk(lvi_nr_of_rows)         := lvr_gk.gk;
        lvt_gk_version(lvi_nr_of_rows) := '';
        lvt_value(lvi_nr_of_rows)      := lvr_gk.value;
      END IF;
   END LOOP;
   --------------------------------------------------------------------
   -- Fill modify reason
   --------------------------------------------------------------------------------
   lvs_modify_reason := 'Groupkey updated by ' || lcs_function_name;
   --------------------------------------------------------------------
   -- Save the rqgk avs_gk
   --------------------------------------------------------------------------------
   lvi_ret_code := UNAPISCP.SAVESCGROUPKEY( avs_sc,
                                            lvt_gk,
                                            lvt_gk_version,
                                            lvt_value,
                                            lvi_nr_of_rows,
                                            lvs_modify_reason);
   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'Removal of scgk "' || avs_gk || '" with value "' || avs_value || '" failed for "' || avs_sc || '". Returncode <' || lvi_ret_code || '>';
      APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END RemValueFromScGk;


FUNCTION SavePartNoAsScGk
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SavePartNoAsScGk';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;
lvi_count           NUMBER;

CURSOR lvq_gk IS
SELECT *
  FROM utscgkpart_no
 WHERE sc = UNAPIEV.P_SC;

CURSOR lvq_partno IS
SELECT DISTINCT iivalue
  FROM utscii a, utie b
 WHERE a.sc = UNAPIEV.P_SC
   AND a.ii = b.ie ANd a.ie_version = b.version
   AND b.valid_cf = 'PartNoCopyAndLookup'
   AND a.iivalue IS NOT NULL
 ORDER BY a.iivalue;

BEGIN

  SELECT COUNT(*)
    INTO lvi_count
    FROM utscii a, utie b
   WHERE a.sc = UNAPIEV.P_SC
     AND a.ic = UNAPIEV.P_IC AND a.icnode = UNAPIEV.P_ICNODE
     AND a.ii = UNAPIEV.P_II AND a.iinode = UNAPIEV.P_IINODE
     AND a.ii = b.ie ANd a.ie_version = b.version
     AND b.valid_cf = 'PartNoCopyAndLookup';

  IF lvi_count = 1 THEN
      FOR lvr_gk IN lvq_gk LOOP
         lvi_ret_code := APAOFUNCTIONS.REMVALUEFROMSCGK(UNAPIEV.P_SC, 'PART_NO', lvr_gk.part_no);
      END LOOP;

      FOR lvr_partno IN lvq_partno LOOP
         lvi_ret_code := APAOFUNCTIONS.ADDVALUETOSCGK(UNAPIEV.P_SC, 'PART_NO', lvr_partno.iivalue);
      END LOOP;
  END IF;

  RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END SavePartNoAsScGk;

FUNCTION FillRelatedFields (a_object_tp  IN VARCHAR2,
                            a_object_key IN APAOGEN.NAME_TYPE,
                            a_ii         IN APAOGEN.NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'FillRelatedFields';
BEGIN
   IF a_object_tp = 'sc' THEN
      RETURN FillRelatedFieldsSc (a_object_key, a_ii) ;
   ELSIF a_object_tp = 'rq' THEN
      RETURN FillRelatedFieldsRq (a_object_key, a_ii) ;
   ELSE
      APAOGEN.LogError (lcs_function_name, 'Unsupported object type '||a_object_tp||' for object '||a_object_key||', infofield '||a_ii||'.');
   END IF;
END FillRelatedFields;

--------------------------------------------------------------------------------
FUNCTION FillRelatedFieldsSc (avs_sc IN APAOGEN.NAME_TYPE,
                              avs_ii IN APAOGEN.NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'FillRelatedFieldsSc';
   lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
   lvi_ret_code       APAOGEN.RETURN_TYPE;
   lvi_utiesql_cursor INTEGER;
   lvi_result         NUMBER;
   lvs_sql_query      VARCHAR2 (10000);
   lvs_sqltext        utiesql.sqltext%TYPE;

   -- SaveScIiValue
   l_nr_of_rows      NUMBER := 0;
   l_sc_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_ic_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_icnode_tab      UNAPIGEN.LONG_TABLE_TYPE;
   l_ii_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_iinode_tab      UNAPIGEN.LONG_TABLE_TYPE;
   l_iivalue_tab     UNAPIGEN.VC2000_TABLE_TYPE;
   l_modify_flag_tab UNAPIGEN.NUM_TABLE_TYPE;

   CURSOR c_relatedfield IS
      SELECT related.sc, related.ic, related.icnode, related.ii, related.iinode, related.ie_version, related.iivalue
      FROM utscii changed, utieau, utscii related, utie
      WHERE changed.sc         = avs_sc
        AND changed.ii         = avs_ii
        AND utieau.ie          = changed.ii
        AND utieau.version     = changed.ie_version
        AND au                 = 'relatedfield'
        AND related.sc         = changed.sc
        AND related.ic         = changed.ic
        AND related.icnode     = changed.icnode
        AND related.ii         = value
        AND related.ii         = utie.ie
        AND related.ie_version = utie.version
        AND look_up_ptr        = 'utiesql'
      ORDER BY auseq;

BEGIN

   -- Iterate through the ii's with 'FillRelatedFields'.
   FOR r_relatedfield IN c_relatedfield LOOP

      lvs_sql_query := '' ;
      FOR sqltext IN (SELECT sqltext
                      FROM utiesql
                      WHERE ie      = r_relatedfield.ii
                        AND version = r_relatedfield.ie_version
                        AND sqltext IS NOT NULL
                      ORDER BY seq) LOOP
          lvs_sql_query := lvs_sql_query || ' ' || sqltext.sqltext;
      END LOOP;
      lvs_sql_query := REPLACE (lvs_sql_query, '~ii@', '~scii@') ; -- Resolve inconsistency between client and server tilde-substitution.
      lvi_result := UNAPIGEN.SubstituteAllTildesInText ('sc', avs_sc, lvs_sql_query) ;
      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         APAOGEN.LogError (lcs_function_name, 'SubstituteAllTildesInText returned '||lvi_ret_code||' for '||avs_sc||', lvs_sql_query = '||lvs_sql_query||'.');
      ELSE
         IF TRIM (lvs_sql_query) IS NULL THEN
            lvs_sqltext := '';
            APAOGEN.LogError (lcs_function_name, 'sc = ' ||avs_sc||', ii = '||avs_ii||', related = '||r_relatedfield.ii||', no SQL query defined!');
         ELSE

            lvi_utiesql_cursor := DBMS_SQL.OPEN_CURSOR;
            DBMS_SQL.PARSE (lvi_utiesql_cursor, lvs_sql_query, DBMS_SQL.V7);
            DBMS_SQL.DEFINE_COLUMN (lvi_utiesql_cursor, 1, lvs_sqltext, 255);
            lvi_result := DBMS_SQL.EXECUTE_AND_FETCH (lvi_utiesql_cursor);
            DBMS_SQL.COLUMN_VALUE (lvi_utiesql_cursor, 1, lvs_sqltext);
            DBMS_SQL.CLOSE_CURSOR (lvi_utiesql_cursor);

            IF ( lvs_sqltext IS NULL     AND r_relatedfield.iivalue IS NOT NULL ) OR
               ( lvs_sqltext IS NOT NULL AND r_relatedfield.iivalue IS NULL     ) OR
               ( lvs_sqltext <> r_relatedfield.iivalue                          )
            THEN
               l_nr_of_rows := l_nr_of_rows + 1;
               l_sc_tab          (l_nr_of_rows) := r_relatedfield.sc ;
               l_ic_tab          (l_nr_of_rows) := r_relatedfield.ic ;
               l_icnode_tab      (l_nr_of_rows) := r_relatedfield.icnode ;
               l_ii_tab          (l_nr_of_rows) := r_relatedfield.ii ;
               l_iinode_tab      (l_nr_of_rows) := r_relatedfield.iinode ;
               l_iivalue_tab     (l_nr_of_rows) := lvs_sqltext ;
               l_modify_flag_tab (l_nr_of_rows) := UNAPIGEN.MOD_FLAG_UPDATE ;
               APAOFUNCTIONS.LogInfo (lcs_function_name, 'sc = ' ||avs_sc||', ii = '||avs_ii||', related = '||r_relatedfield.ii||', old = '||r_relatedfield.iivalue||', new = '||lvs_sqltext||', query = '||lvs_sql_query||'.');
            END IF ;
         END IF;
      END IF;
   END LOOP;

   IF l_nr_of_rows > 0 THEN

      lvi_ret_code := UNAPIIC.SaveScIiValue
                         (l_sc_tab,
                          l_ic_tab,
                          l_icnode_tab,
                          l_ii_tab,
                          l_iinode_tab,
                          l_iivalue_tab,
                          l_modify_flag_tab,
                          l_nr_of_rows,
                          lcs_function_name) ;
      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         APAOGEN.LogError (lcs_function_name, 'SaveScIiValue ('||l_nr_of_rows||' rows) returned '||lvi_ret_code||' for '||avs_sc||'.');
      END IF;

      -- Recursively fill related fields; the chain ends when no fields get changed.
      FOR l_row IN 1..l_nr_of_rows LOOP
         lvi_ret_code := FillRelatedFieldsSc (l_sc_tab (l_row), l_ii_tab (l_row)) ;
      END LOOP ;

   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END FillRelatedFieldsSc;

--------------------------------------------------------------------------------
FUNCTION FillRelatedFieldsRq (avs_rq IN APAOGEN.NAME_TYPE,
                              avs_ii IN APAOGEN.NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'FillRelatedFieldsRq';
   lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
   lvi_ret_code       APAOGEN.RETURN_TYPE;
   lvi_utiesql_cursor INTEGER;
   lvi_result         NUMBER;
   lvs_sql_query      VARCHAR2 (10000);
   lvs_sqltext        utiesql.sqltext%TYPE;

   -- SaveRqIiValue
   l_nr_of_rows      NUMBER := 0;
   l_rq_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_ic_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_icnode_tab      UNAPIGEN.LONG_TABLE_TYPE;
   l_ii_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_iinode_tab      UNAPIGEN.LONG_TABLE_TYPE;
   l_iivalue_tab     UNAPIGEN.VC2000_TABLE_TYPE;
   l_modify_flag_tab UNAPIGEN.NUM_TABLE_TYPE;

   CURSOR c_relatedfield IS
      SELECT related.rq, related.ic, related.icnode, related.ii, related.iinode, related.ie_version, related.iivalue
      FROM utrqii changed, utieau, utrqii related, utie
      WHERE changed.rq         = avs_rq
        AND changed.ii         = avs_ii
        AND utieau.ie          = changed.ii
        AND utieau.version     = changed.ie_version
        AND au                 = 'relatedfield'
        AND related.rq         = changed.rq
        AND related.ic         = changed.ic
        AND related.icnode     = changed.icnode
        AND related.ii         = value
        AND related.ii         = utie.ie
        AND related.ie_version = utie.version
        AND look_up_ptr        = 'utiesql'
      ORDER BY auseq;

BEGIN

   -- Iterate through the ii's with 'FillRelatedFields'.
   FOR r_relatedfield IN c_relatedfield LOOP

      lvs_sql_query := '' ;
      FOR sqltext IN (SELECT sqltext
                      FROM utiesql
                      WHERE ie      = r_relatedfield.ii
                        AND version = r_relatedfield.ie_version
                        AND sqltext IS NOT NULL
                      ORDER BY seq) LOOP
          lvs_sql_query := lvs_sql_query || ' ' || sqltext.sqltext;
      END LOOP;
      lvs_sql_query := REPLACE (lvs_sql_query, '~ii@', '~rqii@') ; -- Resolve inconsistency between client and server tilde-substitution.
      lvi_result := UNAPIGEN.SubstituteAllTildesInText ('rq', avs_rq, lvs_sql_query) ;
      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         APAOGEN.LogError (lcs_function_name, 'SubstituteAllTildesInText returned '||lvi_ret_code||' for '||avs_rq||', lvs_sql_query = '||lvs_sql_query||'.');
      ELSE
         IF TRIM (lvs_sql_query) IS NULL THEN
            lvs_sqltext := '';
            APAOGEN.LogError (lcs_function_name, 'rq = ' ||avs_rq||', ii = '||avs_ii||', related = '||r_relatedfield.ii||', no SQL query defined!');
         ELSE

            lvi_utiesql_cursor := DBMS_SQL.OPEN_CURSOR;
            DBMS_SQL.PARSE (lvi_utiesql_cursor, lvs_sql_query, DBMS_SQL.V7);
            DBMS_SQL.DEFINE_COLUMN (lvi_utiesql_cursor, 1, lvs_sqltext, 255);
            lvi_result := DBMS_SQL.EXECUTE_AND_FETCH (lvi_utiesql_cursor);
            DBMS_SQL.COLUMN_VALUE (lvi_utiesql_cursor, 1, lvs_sqltext);
            DBMS_SQL.CLOSE_CURSOR (lvi_utiesql_cursor);

            IF ( lvs_sqltext IS NULL     AND r_relatedfield.iivalue IS NOT NULL ) OR
               ( lvs_sqltext IS NOT NULL AND r_relatedfield.iivalue IS NULL     ) OR
               ( lvs_sqltext <> r_relatedfield.iivalue                          )
            THEN
               l_nr_of_rows := l_nr_of_rows + 1;
               l_rq_tab          (l_nr_of_rows) := r_relatedfield.rq ;
               l_ic_tab          (l_nr_of_rows) := r_relatedfield.ic ;
               l_icnode_tab      (l_nr_of_rows) := r_relatedfield.icnode ;
               l_ii_tab          (l_nr_of_rows) := r_relatedfield.ii ;
               l_iinode_tab      (l_nr_of_rows) := r_relatedfield.iinode ;
               l_iivalue_tab     (l_nr_of_rows) := lvs_sqltext ;
               l_modify_flag_tab (l_nr_of_rows) := UNAPIGEN.MOD_FLAG_UPDATE ;
               APAOFUNCTIONS.LogInfo (lcs_function_name, 'rq = ' ||avs_rq||', ii = '||avs_ii||', related = '||r_relatedfield.ii||', iivalue = '||lvs_sqltext||', query = '||lvs_sql_query||'.');
            END IF ;
         END IF;
      END IF;
   END LOOP;

   IF l_nr_of_rows > 0 THEN
      lvi_ret_code := UNAPIRQ.SaveRqIiValue
                         (l_rq_tab,
                          l_ic_tab,
                          l_icnode_tab,
                          l_ii_tab,
                          l_iinode_tab,
                          l_iivalue_tab,
                          l_modify_flag_tab,
                          l_nr_of_rows,
                          lcs_function_name) ;
      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         APAOGEN.LogError (lcs_function_name, 'SaveRqIiValue ('||l_nr_of_rows||' rows) returned '||lvi_ret_code||' for '||avs_rq||'.');
      END IF;

      -- Recursively fill related fields; the chain ends when no fields get changed.
      FOR l_row IN 1..l_nr_of_rows LOOP
         lvi_ret_code := FillRelatedFieldsRq (l_rq_tab (l_row), l_ii_tab (l_row)) ;
      END LOOP ;

   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END FillRelatedFieldsRq;

FUNCTION AssignMethod(avs_sc             IN APAOGEN.NAME_TYPE,
                      avs_pg             IN APAOGEN.NAME_TYPE, avn_pgnode     IN APAOGEN.NODE_TYPE, avs_pp_version      IN APAOGEN.VERSION_TYPE,
                      avs_pp_key1        IN APAOGEN.NAME_TYPE,
                      avs_pp_key2        IN APAOGEN.NAME_TYPE,
                      avs_pp_key3        IN APAOGEN.NAME_TYPE,
                      avs_pp_key4        IN APAOGEN.NAME_TYPE,
                      avs_pp_key5        IN APAOGEN.NAME_TYPE,
                      avs_pa             IN APAOGEN.NAME_TYPE, avn_panode   IN APAOGEN.NODE_TYPE, avs_pr_version      IN APAOGEN.VERSION_TYPE,
                      avs_me             IN APAOGEN.NAME_TYPE, avn_menode   OUT APAOGEN.NODE_TYPE, avs_mt_version      IN APAOGEN.VERSION_TYPE,
                      avn_reanalysis    OUT APAOGEN.NODE_TYPE,
                      avs_modify_reason  IN APAOGEN.MODIFY_REASON_TYPE,
                      avb_with_details   IN BOOLEAN := TRUE)
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name ||'.AssignMethod';

  -- General local variables
  l_ret_code                  INTEGER;
  l_row                       INTEGER;
   
  -- Specific local variables
  l_mt                        VARCHAR2(20);
  l_mt_version_in             VARCHAR2(20);
  l_seq                       NUMBER;
  l_sc                        VARCHAR2(20);
  l_pg                        VARCHAR2(20);
  l_pgnode                    NUMBER;
  l_pa                        VARCHAR2(20);
  l_panode                    NUMBER;
  l_pr_version                VARCHAR2(20);
  l_mt_nr_measur              NUMBER;
  l_nr_of_rows                NUMBER;
  l_reanalysis_tab            UNAPIGEN.NUM_TABLE_TYPE;
  l_mt_version_tab            UNAPIGEN.VC20_TABLE_TYPE;
  l_description_tab           UNAPIGEN.VC40_TABLE_TYPE;
  l_value_f_tab               UNAPIGEN.FLOAT_TABLE_TYPE;
  l_value_s_tab               UNAPIGEN.VC40_TABLE_TYPE;
  l_unit_tab                  UNAPIGEN.VC20_TABLE_TYPE;
  l_exec_start_date_tab       UNAPIGEN.DATE_TABLE_TYPE;
  l_exec_end_date_tab         UNAPIGEN.DATE_TABLE_TYPE;
  l_executor_tab              UNAPIGEN.VC20_TABLE_TYPE;
  l_lab_tab                   UNAPIGEN.VC20_TABLE_TYPE;
  l_eq_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_eq_version_tab            UNAPIGEN.VC20_TABLE_TYPE;
  l_planned_executor_tab      UNAPIGEN.VC20_TABLE_TYPE;
  l_planned_eq_tab            UNAPIGEN.VC20_TABLE_TYPE;
  l_planned_eq_version_tab    UNAPIGEN.VC20_TABLE_TYPE;
  l_manually_entered_tab      UNAPIGEN.CHAR1_TABLE_TYPE;
  l_allow_add_tab             UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_assign_date_tab           UNAPIGEN. DATE_TABLE_TYPE;
  l_assigned_by_tab           UNAPIGEN.VC20_TABLE_TYPE;
  l_manually_added_tab        UNAPIGEN.CHAR1_TABLE_TYPE;
  l_delay_tab                 UNAPIGEN.NUM_TABLE_TYPE;
  l_delay_unit_tab            UNAPIGEN.VC20_TABLE_TYPE;
  l_format_tab                UNAPIGEN.VC40_TABLE_TYPE;
  l_accuracy_tab              UNAPIGEN.FLOAT_TABLE_TYPE;
  l_real_cost_tab             UNAPIGEN.VC40_TABLE_TYPE;
  l_real_time_tab             UNAPIGEN.VC40_TABLE_TYPE;
  l_calibration_tab           UNAPIGEN. CHAR1_TABLE_TYPE;
  l_confirm_complete_tab      UNAPIGEN.CHAR1_TABLE_TYPE;
  l_autorecalc_tab            UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_me_result_editable_tab    UNAPIGEN.CHAR1_TABLE_TYPE;
  l_next_cell_tab             UNAPIGEN.VC20_TABLE_TYPE;
  l_sop_tab                   UNAPIGEN.VC40_TABLE_TYPE;
  l_sop_version_tab           UNAPIGEN.VC20_TABLE_TYPE;
  l_plaus_low_tab             UNAPIGEN.FLOAT_TABLE_TYPE;
  l_plaus_high_tab            UNAPIGEN.FLOAT_TABLE_TYPE;
  l_winsize_x_tab             UNAPIGEN.NUM_TABLE_TYPE;
  l_winsize_y_tab             UNAPIGEN.NUM_TABLE_TYPE;
  l_me_class_tab              UNAPIGEN.VC2_TABLE_TYPE;
  l_log_hs_tab                UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_log_hs_details_tab        UNAPIGEN.CHAR1_TABLE_TYPE;
  l_lc_tab                    UNAPIGEN.VC2_TABLE_TYPE;
  l_lc_version_tab            UNAPIGEN.VC20_TABLE_TYPE;
   
  -- Specific local variables
  l_alarms_handled            CHAR(1);
  l_modify_reason             VARCHAR2(255);
  l_sc_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_pg_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_pgnode_tab                UNAPIGEN.LONG_TABLE_TYPE;
  l_pa_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_panode_tab                UNAPIGEN.LONG_TABLE_TYPE;
  l_me_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_menode_tab                UNAPIGEN.LONG_TABLE_TYPE;
  l_modify_flag_tab           UNAPIGEN.NUM_TABLE_TYPE;
  
  lvs_sqlerrm VARCHAR2(255);
BEGIN
   
  -- IN and IN OUT arguments
  l_mt             := avs_me;
  l_mt_version_in  := avs_mt_version;
  l_seq            := NULL;
  l_sc             := avs_sc;
  l_pg             := avs_pg;
  l_pgnode         := avn_pgnode;
  l_pa             := avs_pa;
  l_panode         := avn_panode;
  l_pr_version     := avs_pr_version;
  l_mt_nr_measur   := 1;
  l_nr_of_rows     := NULL;
   
  l_ret_code       := UNAPIME.INITSCMETHOD
                   (l_mt,
                    l_mt_version_in,
                    l_seq,
                    l_sc,
                    l_pg,
                    l_pgnode,
                    l_pa,
                    l_panode,
                    l_pr_version,
                    l_mt_nr_measur,
                    l_reanalysis_tab,
                    l_mt_version_tab,
                    l_description_tab,
                    l_value_f_tab,
                    l_value_s_tab,
                    l_unit_tab,
                    l_exec_start_date_tab,
                    l_exec_end_date_tab,
                    l_executor_tab,
                    l_lab_tab,
                    l_eq_tab,
                    l_eq_version_tab,
                    l_planned_executor_tab,
                    l_planned_eq_tab,
                    l_planned_eq_version_tab,
                    l_manually_entered_tab,
                    l_allow_add_tab,
                    l_assign_date_tab,
                    l_assigned_by_tab,
                    l_manually_added_tab,
                    l_delay_tab,
                    l_delay_unit_tab,
                    l_format_tab,
                    l_accuracy_tab,
                    l_real_cost_tab,
                    l_real_time_tab,
                    l_calibration_tab,
                    l_confirm_complete_tab,
                    l_autorecalc_tab,
                    l_me_result_editable_tab,
                    l_next_cell_tab,
                    l_sop_tab,
                    l_sop_version_tab,
                    l_plaus_low_tab,
                    l_plaus_high_tab,
                    l_winsize_x_tab,
                    l_winsize_y_tab,
                    l_me_class_tab,
                    l_log_hs_tab,
                    l_log_hs_details_tab,
                    l_lc_tab,
                    l_lc_version_tab,
                    l_nr_of_rows);
   
  IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
     
      FOR l_row IN 1..l_nr_of_rows LOOP
         l_sc_tab(l_row) := avs_sc;
         l_pg_tab(l_row) := avs_pg;
         l_pgnode_tab(l_row) := avn_pgnode;
         l_pa_tab(l_row) := avs_pa;
         l_panode_tab(l_row) := avn_panode;
         l_me_tab(l_row) := l_mt;
         l_menode_tab(l_row) := NULL;
         l_reanalysis_tab(l_row) := 0;
         l_mt_version_tab(l_row) := avs_mt_version;         
         l_modify_flag_tab(l_row) := UNAPIGEN.MOD_FLAG_UPDATE; --TW: change assigned value, to fix ERRNUM 35
      END LOOP;
      
      l_ret_code       := UNAPIME.SAVESCMETHOD
                       (l_alarms_handled,
                        l_sc_tab,
                        l_pg_tab,
                        l_pgnode_tab,
                        l_pa_tab,
                        l_panode_tab,
                        l_me_tab,
                        l_menode_tab,
                        l_reanalysis_tab,
                        l_mt_version_tab,
                        l_description_tab,
                        l_value_f_tab,
                        l_value_s_tab,
                        l_unit_tab,
                        l_exec_start_date_tab,
                        l_exec_end_date_tab,
                        l_executor_tab,
                        l_lab_tab,
                        l_eq_tab,
                        l_eq_version_tab,
                        l_planned_executor_tab,
                        l_planned_eq_tab,
                        l_planned_eq_version_tab,
                        l_manually_entered_tab,
                        l_allow_add_tab,
                        l_assign_date_tab,
                        l_assigned_by_tab,
                        l_manually_added_tab,
                        l_delay_tab,
                        l_delay_unit_tab,
                        l_format_tab,
                        l_accuracy_tab,
                        l_real_cost_tab,
                        l_real_time_tab,
                        l_calibration_tab,
                        l_confirm_complete_tab,
                        l_autorecalc_tab,
                        l_me_result_editable_tab,
                        l_next_cell_tab,
                        l_sop_tab,
                        l_sop_version_tab,
                        l_plaus_low_tab,
                        l_plaus_high_tab,
                        l_winsize_x_tab,
                        l_winsize_y_tab,
                        l_me_class_tab,
                        l_log_hs_tab,
                        l_log_hs_details_tab,
                        l_lc_tab,
                        l_lc_version_tab,
                        l_modify_flag_tab,
                        l_nr_of_rows,
                        l_modify_reason);       
                        
     avn_menode := l_menode_tab(l_nr_of_rows);
     avn_reanalysis := l_reanalysis_tab(l_nr_of_rows);
  END IF;
  
  RETURN l_ret_code;
EXCEPTION  
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END AssignMethod;

FUNCTION split_vc_sql (delimited_txt VARCHAR2, delimiter VARCHAR2)
RETURN split_t_tp PIPELINED
IS
  t_res split_t_tp;
  l_row split_r_tp;
  l_cnt NUMBER := 0;
BEGIN
  FOR l_t IN (with t as (SELECT delimited_txt as txt FROM dual)
                         -- end of sample data
                             SELECT REGEXP_SUBSTR (txt, '[^'||delimiter||']+', 1, level) res
                             FROM t
                             CONNECT BY LEVEL <= length(regexp_replace(txt,'[^'||delimiter||']*'))+1) LOOP    
    l_row.vc300 := l_t.res;
    PIPE ROW (l_row);
  END LOOP;  
  --RETURN t_res;
END split_vc_sql;
--

FUNCTION SplitVC (a_delimited_txt IN VARCHAR2, a_delimiter IN VARCHAR2, a_result_tab UNAPIGEN.VC255_TABLE_TYPE)
RETURN NUMBER
IS
  lts_result_tab             UNAPIGEN.VC255_TABLE_TYPE;
BEGIN
  FOR l_line IN (select * 
                     from table(split_vc_sql(a_delimited_txt, a_delimiter))
                     ) LOOP
      NULL;
  END LOOP;
  RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
  WHEN OTHERS THEN
    RETURN SQLCODE;
END;
--

END APAOFUNCTIONS;
/
