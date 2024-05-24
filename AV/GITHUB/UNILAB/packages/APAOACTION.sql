CREATE OR REPLACE PACKAGE        APAOACTION AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOACTION
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 17/09/2008
--   TARGET : Oracle 10.2.0
--  VERSION : av2.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 17/09/2008 | RS        | Created
-- 17/09/2008 | RS        | Added FindSpecTypeTemplate
--                        | Added GetStSpecType
--                        | Added FindPrTemplate
--                        | Added StApplyTemplate
--                        | Added PpApplyTemplate
--                        | Added PrApplyTemplate
--                        | Added StTriggerAllPps
--                        | Added PpTriggerSt
-- 05/11/2008 | RS        | Added StPpApplyInterspecFreq
--                        | Added ConvertUnilab2Interspec
--                        | Added PpPrApplyInterspecFreq
-- 12/11/2008 | RS        | Added SyncStPpFreqNotManual
--                        | Added SyncPpPrFreqNotManual
-- 26/11/2008 | RS        | Added StChangeSsToApproved
--                        | Added StPutAllPpToApproved
--                        | Added PpSyncLastCount
-- 10/12/2008 | RS        | Added StPpSyncLastCount
--                        | Added StSyncLastCount
--                        | Changed PpSyncLastCount
-- 11/03/2009 | RS        | Added MeGetPreviousResults (av2.2.C03)
-- 13/06/2009 | RS        | Added MeRemoveGk (function called by job to remove megk)
--                        | Added SetConnection
-- 12/05/2011 | RS        | Added WriteXML
-- 29/03/2016 | AF        | Altered FindSpecTypeTemplate
-- 12/04/2016 | AF        | Added function GetEmailReceipients
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
TYPE Template_Type IS RECORD(
    template   APAOGEN.PP_TYPE,
    version    APAOGEN.VERSION_TYPE,
    pp_key1    VARCHAR2(20),
    pp_key2    VARCHAR2(20),
    pp_key3    VARCHAR2(20),
    pp_key4    VARCHAR2(20),
    pp_key5    VARCHAR2(20));

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT APAOGEN.API_NAME_TYPE := 'apaoaction';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION ConvertUnilab2Interspec(avs_version IN VARCHAR2)
RETURN NUMBER;

--------------------------------------------------------------------------------
-- FUNCTION : FindSpecTypeTemplate
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Arie Frans Kok
-- REVIEWER :
--     DATE : xx/xx/20xx
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- xx/xx/20xx | XX        | Created
-- 29/03/2016 | AF        | Added extra argument avb_report_error
--------------------------------------------------------------------------------
FUNCTION FindSpecTypeTemplate (avs_st             IN  APAOGEN.ST_TYPE,
                               avs_st_version     IN  APAOGEN.VERSION_TYPE,
                               avs_spec_type      IN  VARCHAR2,
                               avb_correct_config OUT BOOLEAN,
                               avb_report_error   IN  BOOLEAN := FALSE )
RETURN Template_Type;

FUNCTION GetStSpecType (avs_st            IN APAOGEN.ST_TYPE,
                        avs_st_version    IN APAOGEN.VERSION_TYPE )
RETURN VARCHAR2;

FUNCTION FindPpTemplate (avs_pp            IN APAOGEN.PP_TYPE,
                         avs_pp_version    IN APAOGEN.VERSION_TYPE,
                         avs_pp_key1       IN VARCHAR2,
                         avs_pp_key2       IN VARCHAR2,
                         avs_pp_key3       IN VARCHAR2,
                         avs_pp_key4       IN VARCHAR2,
                         avs_pp_key5       IN VARCHAR2)
RETURN Template_Type;

FUNCTION FindPrTemplate (avs_pr            IN APAOGEN.PR_TYPE,
                         avs_pr_version    IN APAOGEN.VERSION_TYPE )
RETURN Template_Type;

FUNCTION StApplyTemplate(avs_st                 IN APAOGEN.ST_TYPE,
                         avs_st_version         IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PpApplyTemplate(avs_pp                 IN APAOGEN.PP_TYPE,
                         avs_pp_version         IN APAOGEN.VERSION_TYPE,
                         avs_pp_key1            IN VARCHAR2,
                         avs_pp_key2            IN VARCHAR2,
                         avs_pp_key3            IN VARCHAR2,
                         avs_pp_key4            IN VARCHAR2,
                         avs_pp_key5            IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PrApplyTemplate(avs_pr                 IN APAOGEN.PR_TYPE,
                         avs_pr_version         IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION StTriggerAllPps(avs_st                 IN APAOGEN.ST_TYPE,
                         avs_st_version         IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PpTriggerSt (avs_pp            IN APAOGEN.PP_TYPE,
                      avs_pp_version    IN APAOGEN.VERSION_TYPE,
                      avs_pp_key1       IN VARCHAR2,
                      avs_pp_key2       IN VARCHAR2,
                      avs_pp_key3       IN VARCHAR2,
                      avs_pp_key4       IN VARCHAR2,
                      avs_pp_key5       IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PrCreateMinor(avs_pr                 IN     APAOGEN.PR_TYPE,
                       avs_pr_version         IN     APAOGEN.VERSION_TYPE,
                       avs_tmp                IN     APAOGEN.PR_TYPE,
                       avs_pr_new_version     IN OUT APAOGEN.VERSION_TYPE,
                       avs_modify_reason      IN     APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION StPpApplyInterspecFreq(avs_st                 IN APAOGEN.ST_TYPE,
                                avs_st_version         IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PpPrApplyInterspecFreq(avs_pp            IN APAOGEN.PP_TYPE,
                                avs_pp_version    IN APAOGEN.VERSION_TYPE,
                                avs_pp_key1       IN VARCHAR2,
                                avs_pp_key2       IN VARCHAR2,
                                avs_pp_key3       IN VARCHAR2,
                                avs_pp_key4       IN VARCHAR2,
                                avs_pp_key5       IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SyncStPpFreqNotManual (avs_st            IN APAOGEN.ST_TYPE,
                                avs_st_version    IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SyncPpPrFreqNotManual (avs_pp            IN APAOGEN.PP_TYPE,
                                avs_pp_version    IN APAOGEN.VERSION_TYPE,
                                avs_pp_key1       IN VARCHAR2,
                                avs_pp_key2       IN VARCHAR2,
                                avs_pp_key3       IN VARCHAR2,
                                avs_pp_key4       IN VARCHAR2,
                                avs_pp_key5       IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION StChangeSsToApproved
RETURN APAOGEN.RETURN_TYPE;

FUNCTION StPutAllPpToApproved( avs_st            IN APAOGEN.ST_TYPE,
                               avs_st_version    IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION StSyncLastCount(avs_st            IN APAOGEN.ST_TYPE,
                         avs_st_version    IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION StPpSyncLastCount(avs_st            IN APAOGEN.ST_TYPE,
                           avs_st_version    IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION PpSyncLastCount(avs_pp            IN APAOGEN.PP_TYPE,
                         avs_pp_version    IN APAOGEN.VERSION_TYPE,
                         avs_pp_key1       IN VARCHAR2,
                         avs_pp_key2       IN VARCHAR2,
                         avs_pp_key3       IN VARCHAR2,
                         avs_pp_key4       IN VARCHAR2,
                         avs_pp_key5       IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION MeGetPreviousResults
RETURN APAOGEN.RETURN_TYPE;

FUNCTION SetConnection
RETURN APAOGEN.RETURN_TYPE;

FUNCTION MeRemoveGk(avs_gk IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION WriteXML(avs_sc   IN VARCHAR)
RETURN APAOGEN.RETURN_TYPE;

--------------------------------------------------------------------------------
-- FUNCTION : GetEmailReceipients
-- ABSTRACT : This function will get the e-mail adresses from users with the
--            attribute avMailing
--------------------------------------------------------------------------------
--   WRITER : A.F. Kok
-- REVIEWER :
--     DATE : 12/04/2016
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- 12/04/2016 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION GetEmailReceipients
RETURN VARCHAR2;

END APAOACTION;
/


CREATE OR REPLACE PACKAGE BODY APAOACTION AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOACTION
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 17/09/2008
--   TARGET : Oracle 10.2.0 / Unilab 6.3
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 17/09/2008 | RS        | Created
-- 17/09/2008 | RS        | Added FindSpecTypeTemplate
--                        | Added GetStSpecType
--                        | Added GetPpSpecType
--                        | Added FindPrTemplate
--                        | Added StCreateMinor
--                        | Added PpCreateMinor
--                        | Added PrCreateMinor
--                        | Added StApplyTemplate
--                        | Added PpApplyTemplate
--                        | Added PrApplyTemplate
--                        | Added StTriggerAllPps
--                        | Added PpTriggerSt
-- 07/10/2008 | RS        | Changed PrCreateMinor (minor version bug)
--                        | Changed PrApplyTemplate (minor version bug)
--                        | Changed SynchronizeStPp (pppr freqs)
-- 09/10/2008 | RS        | Changed SynchronizeStPp (pppr freqs)
-- 05/11/2008 | RS        | Added StPpApplyInterspecFreq
--                        | Added ConvertUnilab2Interspec
--                        | Added PpPrApplyInterspecFreq
--                        | Changed FindPpTemplate
-- 12/11/2008 | RS        | Changed SynchronizeStGk (all gk's from template will be synchronized)
--                        | Changed PrApplyTemplate (added comment)
--                        | Changed PpPrApplyInterspecFreq
--                        | Added SyncStPpFreqNotManual
--                        | Added SyncPpPrFreqNotManual
-- 26/11/2008 | RS        | Added StChangeSsToApproved
--                        | Changed StPpApplyInterspecFreq
--                        | Changed PpPrApplyInterspecFreq
--                        | Added StPutAllPpToApproved
--                        | Added PpSyncLastCount
-- 27/11/2008 | RS        | Changed PpSyncLastCount (removed bug last_cnt = NULL)
--                        | Changed SyncPpPrFreqNotManual (removed bug NULL value)
--                        | Changed StPpApplyInterspecFreq
--                        | Changed PpPrApplyInterspecFreq
-- 10/12/2008 | RS        | Changed StChangeSsToApproved
-- 11/03/2009 | RS        | Added MeGetPreviousResults (av2.2.C03)
-- 08/04/2009 | RS        | Changed PrCreateMinor (removed bug in version)
-- 23/04/2009 | RS        | Changed SyncPpPrFreqNotManual
-- 27/05/2009 | RS        | Changed SyncStPpFreqNotManual (return success if no cust.freq found)
--                        | Changed SyncPpPrFreqNotManual (return success if no cust.freq found)
--                        | Changed PpPrApplyInterspecFreq (added #p for samplesize)
--                        | Changed StChangeSsToApproved (added set effective from date to sysdate)
-- 28/05/2009 | RS        | Changed MeGetPreviousResults (bug value_s = null)
-- 03/06/2009 | RS        | Changed MeGetPreviousResults (optimized cursor, fixed format C)
-- 13/06/2009 | RS        | Added MeRemoveGk (function called by job to remove megk)
--                        | Added SetConnection
-- 10/12/2009 | RS        | Changed MeGetPreviousResults (bug if cell is of type Combo, List)
-- 23/12/2009 | RS        | Changed MeGetPreviousResults (bug if cell is of type Combo, List)
-- 17/03/2010 | RS        | Changed AddAuTopp (bug missing SynchronizePpAu)
--                        | Added pp_key1 to audittrail next to template/version
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
--                        | Changed DATE; INTO TIMESTAMP WITH TIME ZONE;
-- 12/05/2011 | RS        | Added WriteXML
-- 17/05/2011 | RS        | Added additional error handling to PpPrApplyInterspecFreq
-- 25/05/2011 | RS        | Changed function StChangeSsToApproved / Setconnection (errhandling user SYS)
-- 01/09/2011 | RS        | Added fucntion PpAssignedByTemplate
--                        | Changed function AddPpToSt(added pp to modify_reason)
--                        | Changed function PpPrApplyInterspecFreq(if st_version/pp_version mismatch -> no error)
--                        | Changed function StChangeSsToApproved(check on PpAssignedByTemplate)
-- 16/01/2013 | RS        | Changed function AddAuToSt (allow multiple au-values)
-- 23/04/2013 | RS        | Changed function FindSpecTypeTemplate (ppkey1 not filled)
-- 09/09/2013 | JR        | MeRemoveGk, replace current_timestamp by localtimestamp (resolving ORA-01878)
-- 09/09/2013 | JR        | MeRemoveGk, introduced a throttle counter so we limit the proces to 1000 records
-- 19/03/2015 | JR        | Changed MeGetPreviousResults, max_y calculation
-- 16/04/2015 | JR        | Changed MeGetPreviousResults, get results from utr*-tables or the 'old' way
-- 29/03/2016 | AF        | Altered function SynchronizeStpp (I1511-178)
-- 29/03/2016 | AF        | Altered function AddPpToSt (add pp_key1 argument)
-- 29/03/2016 | AF        | Altered function FindSpecTypeTemplate (I1511-178)
-- 29/03/2016 | AF        | Altered function StApplyTemplate (I1511-178)
-- 29/03/2016 | AF        | Altered function SynchronizeStAu (I1511-178)
-- 29/03/2016 | AF        | Altered function PpApplyTemplate (I1511-178)
-- 29/03/2016 | AF        | Altered function SynchronizePpAu (I1511-178)
-- 29/03/2016 | AF        | Altered function SyncStPpFreqNotManual (I1511-178)
-- 29/03/2016 | AF        | Altered function FindPpTemplate (I1511-178)
-- 12/04/2016 | AF        | Added function GetEmailReceipients
-- 13/04/2016 | AF        | Altered function SynchronizeStPpFreq
-- 28/04/2016 | AF        | Altered function FindPpTemplate
-- 23/08/2016 | JP        | Added object ID quoting in AddPpToSt, AddAuToStPp, AddIpToSt, AddAuToPp, AddPrToPp
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

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
FUNCTION PpAssignedByTemplate(avs_st          IN VARCHAR2,
                              avs_st_version  IN VARCHAR2,
                              avs_pp          IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpAssignedByTemplate';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

CURSOR lvq_pp_by_template(avs_st          IN VARCHAR2,
                          avs_st_version  IN VARCHAR2,
                          avs_pp          IN VARCHAR2) IS
   SELECT b.pp, MAX(version_is_current) version_is_current
     FROM utsths a, utpp b
    WHERE a.st = avs_st AND a.version = avs_st_version
      AND a.what_description LIKE 'sample type "' || a.st || '" parameter profiles are updated.'
      AND b.pp = avs_pp
      AND b.pp_key1 = a.st AND b.pp = substr(why, 5, instr(why, '>')-5)
 GROUP BY b.pp;

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN

   FOR lvr_pp_by_template IN lvq_pp_by_template(avs_st,
                                                avs_st_version,
                                                avs_pp) LOOP
      IF lvr_pp_by_template.version_is_current = 1
      THEN
         RETURN UNAPIGEN.DBERR_SUCCESS;
      ELSE
         RETURN UNAPIGEN.DBERR_NOCURRENTPPVERSION;
      END IF;
   END LOOP;

   RETURN UNAPIGEN.DBERR_GENFAIL ;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN NULL;
END PpAssignedByTemplate;

FUNCTION ConvertUnilab2Interspec(avs_version IN VARCHAR2)
RETURN NUMBER IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ConvertUnilab2Interspec';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
lvi_revision NUMBER;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   SELECT TO_NUMBER(LTRIM(SUBSTR(avs_version, 1, INSTR(avs_version,'.')-1), '0'))
     INTO lvi_revision
     FROM dual;

   RETURN lvi_revision;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN NULL;
END ConvertUnilab2Interspec;

--------------------------------------------------------------------------------
-- INTERNAL
--------------------------------------------------------------------------------
FUNCTION AddAuToSt(avs_st               IN APAOGEN.ST_TYPE,
                   avs_st_version       IN APAOGEN.VERSION_TYPE,
                   avs_au               IN APAOGEN.AU_TYPE,
                   avs_value            IN APAOGEN.AU_TYPE,
                   avs_modify_reason    IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.AddAuToSt';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_au(avs_st IN VARCHAR2,
              avs_au IN VARCHAR2) IS
  SELECT value
    FROM utstau
   WHERE st = avs_st AND version = avs_st_version
     AND au = avs_au;

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                    APAOGEN.RETURN_TYPE;
lvi_row                         INTEGER;
lvs_object_tp                   VARCHAR2(4);
lvs_object_id                   VARCHAR2(20);
lvs_object_version              VARCHAR2(20);
lvn_nr_of_rows                  NUMBER;
lvs_modify_reason               VARCHAR2(255);
lvs_au                          VARCHAR2(20);
lvs_au_version                  VARCHAR2(20);
lts_value_tab                   UNAPIGEN.VC40_TABLE_TYPE;

BEGIN

    lvs_object_tp       := 'st';
    lvs_object_id       := avs_st;
    lvs_object_version  := avs_st_version;
    lvs_au              := avs_au;
    lvs_au_version      := '';
    lvs_modify_reason   := avs_modify_reason;
    lvn_nr_of_rows := 1;
    --------------------------------------------------------------------------------
    -- Retrieve all existing values of stau avs_au
    --------------------------------------------------------------------------------
    FOR lvr_au IN lvq_au(avs_st, avs_au) LOOP
       lts_value_tab(lvn_nr_of_rows) := lvr_au.value;
       lvn_nr_of_rows := lvn_nr_of_rows + 1;
    END LOOP;
    --------------------------------------------------------------------
    -- Fill new values of stau avs_au
    --------------------------------------------------------------------------------
    lts_value_tab(lvn_nr_of_rows) := avs_value;
    --------------------------------------------------------------------
    -- Save the stau avs_au
    --------------------------------------------------------------------------------
    lvi_ret_code := UNAPIPRP.SAVE1OBJECTATTRIBUTE (lvs_object_tp,
                                                   lvs_object_id,
                                                   lvs_object_version,
                                                   lvs_au,
                                                   lvs_au_version,
                                                   lts_value_tab,
                                                   lvn_nr_of_rows,
                                                   lvs_modify_reason);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Assigning au <' || avs_au || '> to st <' || avs_st || '> failed. Function returned <' || lvi_ret_code || '>');
   END IF;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END AddAuToSt;

--------------------------------------------------------------------------------
-- FUNCTION : AddPpToSt
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
-- REVIEWER :
--     DATE : xx/xx/20xx
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- xx/xx/20xx | RS        | Created
-- 29/03/2016 | AF        | Added the pp_key1 argument
--------------------------------------------------------------------------------
FUNCTION AddPpToSt(avs_st               IN APAOGEN.ST_TYPE,
                   avs_st_version       IN APAOGEN.VERSION_TYPE,
                   avs_pp               IN APAOGEN.PP_TYPE,
                   avs_ppkey1           IN UTPP.PP_KEY1%TYPE,
                   avc_freq_tp          IN CHAR := 'A',
                   avn_freq_val         IN NUMBER := 0,
                   avs_freq_unit        IN VARCHAR2 := 'DD',
                   avc_invert_freq      IN CHAR := '0',
                   avs_modify_reason    IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.AddPpToSt';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code	                 APAOGEN.RETURN_TYPE;
lvs_st                          VARCHAR2(20);
lvs_version                     VARCHAR2(20);
lvn_nr_of_rows                  NUMBER;
lvs_where_clause                VARCHAR2(255);
lvn_next_rows                   NUMBER;
lvi_row                         INTEGER;
lts_st_tab                      Unapigen.VC20_TABLE_TYPE;
lts_version_tab                 Unapigen.VC20_TABLE_TYPE;
lts_description_tab             Unapigen.VC40_TABLE_TYPE;
lts_pp_tab                      Unapigen.VC20_TABLE_TYPE;
lts_pp_version_tab              Unapigen.VC20_TABLE_TYPE;
lts_pp_key1_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key2_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key3_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key4_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key5_tab                 Unapigen.VC20_TABLE_TYPE;
ltc_freq_tp_tab                 Unapigen.CHAR1_TABLE_TYPE;
ltn_freq_val_tab                Unapigen.NUM_TABLE_TYPE;
lts_freq_unit_tab               Unapigen.VC20_TABLE_TYPE;
ltc_invert_freq_tab             Unapigen.CHAR1_TABLE_TYPE;
ltd_last_sched_tab              Unapigen.DATE_TABLE_TYPE;
ltn_last_cnt_tab                Unapigen.NUM_TABLE_TYPE;
lts_last_val_tab                Unapigen.VC40_TABLE_TYPE;
ltc_inherit_au_tab              Unapigen.CHAR1_TABLE_TYPE;

BEGIN
   --------------------------------------------------------------------------------
   -- Get ip's assigned to st
   --------------------------------------------------------------------------------
   lvs_where_clause    := 'WHERE st = ''' || REPLACE (avs_st, '''', '''''') || ''' AND version = '''|| avs_st_version || '''';
   lvn_next_rows       := 0;
   lvn_nr_of_rows      := NULL;

   lvi_ret_code := Unapist.GETSTPARAMETERPROFILE(lts_st_tab,
                                                 lts_version_tab,
                                                 lts_pp_tab,
                                                 lts_pp_version_tab,
                                                 lts_pp_key1_tab,
                                                 lts_pp_key2_tab,
                                                 lts_pp_key3_tab,
                                                 lts_pp_key4_tab,
                                                 lts_pp_key5_tab,
                                                 lts_description_tab,
                                                 ltc_freq_tp_tab,
                                                 ltn_freq_val_tab,
                                                 lts_freq_unit_tab,
                                                 ltc_invert_freq_tab,
                                                 ltd_last_sched_tab,
                                                 ltn_last_cnt_tab,
                                                 lts_last_val_tab,
                                                 ltc_inherit_au_tab,
                                                 lvn_nr_of_rows,
                                                 lvs_where_clause,
                                                 lvn_next_rows);

   --------------------------------------------------------------------------------
   -- Add 1 to the total number of pp's
   --------------------------------------------------------------------------------
   IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      lvn_nr_of_rows := lvn_nr_of_rows + 1;
   ELSE
      lvn_nr_of_rows := 1;
   END IF;

   lvi_row := lvn_nr_of_rows;

   --------------------------------------------------------------------------------
   -- Add new pp to tabletypes
   --------------------------------------------------------------------------------
   lts_pp_tab(lvi_row)          := avs_pp;
   lts_pp_version_tab(lvi_row)  := '~Current~';
   lts_pp_key1_tab(lvi_row)     := avs_ppkey1;
   lts_pp_key2_tab(lvi_row)     := ' ';
   lts_pp_key3_tab(lvi_row)     := ' ';
   lts_pp_key4_tab(lvi_row)     := ' ';
   lts_pp_key5_tab(lvi_row)     := ' ';
   ltc_freq_tp_tab(lvi_row)     := avc_freq_tp;
   ltn_freq_val_tab(lvi_row)    := avn_freq_val;
   lts_freq_unit_tab(lvi_row)   := avs_freq_unit;
   ltc_invert_freq_tab(lvi_row) := avc_invert_freq;
   ltd_last_sched_tab(lvi_row)  := NULL;
   ltn_last_cnt_tab(lvi_row)    := 0;
   lts_last_val_tab(lvi_row)    := '';
   ltc_inherit_au_tab(lvi_row)  := '1';

   lvn_next_rows:= -1;
   --------------------------------------------------------------------------------
   -- Assign all pp's to st
   --------------------------------------------------------------------------------
   lvi_ret_code := Unapist.SAVESTPARAMETERPROFILE
                (avs_st,
                 avs_st_version,
                 lts_pp_tab,
                 lts_pp_version_tab,
                 lts_pp_key1_tab,
                 lts_pp_key2_tab,
                 lts_pp_key3_tab,
                 lts_pp_key4_tab,
                 lts_pp_key5_tab,
                 ltc_freq_tp_tab,
                 ltn_freq_val_tab,
                 lts_freq_unit_tab,
                 ltc_invert_freq_tab,
                 ltd_last_sched_tab,
                 ltn_last_cnt_tab,
                 lts_last_val_tab,
                 ltc_inherit_au_tab,
                 lvn_nr_of_rows,
                 lvn_next_rows,
                 'Pp <' || avs_pp || '> assigned.' || avs_modify_reason);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Assigning pp <' || avs_pp || '> to st <' || avs_st || '> failed. Function returned <' || lvi_ret_code || '>');
   END IF;

RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END AddPpToSt;

FUNCTION AddAuToStPp(avs_st               IN APAOGEN.ST_TYPE,
                     avs_st_version       IN APAOGEN.VERSION_TYPE,
                     avs_pp               IN APAOGEN.PP_TYPE,
                     avs_pp_version       IN APAOGEN.VERSION_TYPE,
                     avs_au               IN APAOGEN.AU_TYPE,
                     avs_value            IN APAOGEN.AU_TYPE,
                     avs_modify_reason    IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.AddAuToStPp';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
lvn_nr_of_rows                  NUMBER;
lvs_where_clause                VARCHAR2(511);
lts_st_tab                      Unapigen.VC20_TABLE_TYPE;
lts_version_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_tab                      Unapigen.VC20_TABLE_TYPE;
lts_pp_version_tab              Unapigen.VC20_TABLE_TYPE;
lts_pp_key1_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key2_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key3_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key4_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key5_tab                 Unapigen.VC20_TABLE_TYPE;
lts_au_tab                      Unapigen.VC20_TABLE_TYPE;
lts_au_version_tab              Unapigen.VC20_TABLE_TYPE;
lts_value_tab                   Unapigen.VC40_TABLE_TYPE;
lts_description_tab             Unapigen.VC40_TABLE_TYPE;
ltc_is_protected_tab            Unapigen.CHAR1_TABLE_TYPE;
ltc_single_valued_tab           Unapigen.CHAR1_TABLE_TYPE;
ltc_new_val_allowed_tab         Unapigen.CHAR1_TABLE_TYPE;
ltc_store_db_tab                Unapigen.CHAR1_TABLE_TYPE;
ltc_value_list_tp_tab           Unapigen.CHAR1_TABLE_TYPE;
ltc_run_mode_tab                Unapigen.CHAR1_TABLE_TYPE;
lts_service_tab                 Unapigen.VC255_TABLE_TYPE;
lts_cf_value_tab                Unapigen.VC20_TABLE_TYPE;

lvi_row                         INTEGER;
lvs_pp_key1                     VARCHAR2(20);
lvs_pp_key2                     VARCHAR2(20);
lvs_pp_key3                     VARCHAR2(20);
lvs_pp_key4                     VARCHAR2(20);
lvs_pp_key5                     VARCHAR2(20);

BEGIN

   lvs_where_clause  := 'WHERE st = ''' || REPLACE (avs_st, '''', '''''') || ''' AND version = '''|| avs_st_version || ''' ' ||
                          'AND pp = ''' || REPLACE (avs_pp, '''', '''''') || ''' AND pp_version = '''|| avs_pp_version || ''' ' ||
                          'AND pp_key1 = st';
   lvn_nr_of_rows    := NULL;

   lvi_ret_code := Unapist.GETSTPPATTRIBUTE(lts_st_tab,
                                            lts_version_tab,
                                            lts_pp_tab,
                                            lts_pp_version_tab,
                                            lts_pp_key1_tab,
                                            lts_pp_key2_tab,
                                            lts_pp_key3_tab,
                                            lts_pp_key4_tab,
                                            lts_pp_key5_tab,
                                            lts_au_tab,
                                            lts_au_version_tab,
                                            lts_value_tab,
                                            lts_description_tab,
                                            ltc_is_protected_tab,
                                            ltc_single_valued_tab,
                                            ltc_new_val_allowed_tab,
                                            ltc_store_db_tab,
                                            ltc_value_list_tp_tab,
                                            ltc_run_mode_tab,
                                            lts_service_tab,
                                            lts_cf_value_tab,
                                            lvn_nr_of_rows,
                                            lvs_where_clause);
   --------------------------------------------------------------------------------
   -- Add 1 to the total number of au's
   --------------------------------------------------------------------------------
   IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      lvn_nr_of_rows := lvn_nr_of_rows + 1;
   ELSE
      lvn_nr_of_rows := 1;
   END IF;
   --------------------------------------------------------------------------------
   -- Add new au to tabletypes
   --------------------------------------------------------------------------------
   lvi_row                    := lvn_nr_of_rows;
   lvs_pp_key1                := avs_st;
   lvs_pp_key2                := ' ';
   lvs_pp_key3                := ' ';
   lvs_pp_key4                := ' ';
   lvs_pp_key5                := ' ';
   lts_au_tab(lvi_row)        := avs_au;
   lts_value_tab(lvi_row)     := avs_value ;
   lts_au_version_tab(lvi_row):= '~Current~';

   lvi_ret_code := Unapist.SAVESTPPATTRIBUTE(avs_st,
                                             avs_st_version,
                                             avs_pp,
                                             avs_pp_version,
                                             lvs_pp_key1,
                                             lvs_pp_key2,
                                             lvs_pp_key3,
                                             lvs_pp_key4,
                                             lvs_pp_key5,
                                             lts_au_tab,
                                             lts_value_tab,
                                             lts_au_version_tab,
                                             lvn_nr_of_rows,
                                             avs_modify_reason);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Assigning au <' || avs_au || '> to st <' || avs_st || '> pp <' || avs_pp || '> failed. Function returned <' || lvi_ret_code || '>');
   END IF ;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END AddAuToStPp;

FUNCTION AddIpToSt(avs_st               IN APAOGEN.ST_TYPE,
                   avs_st_version       IN APAOGEN.VERSION_TYPE,
                   avs_ip               IN APAOGEN.IP_TYPE,
                   avc_is_protected     IN CHAR := '0',
                   avc_hidden           IN CHAR := '0',
                   avc_freq_tp          IN CHAR := 'A',
                   avn_freq_val         IN NUMBER := 0,
                   avs_freq_unit        IN VARCHAR2 := 'DD',
                   avc_invert_freq      IN CHAR := '0',
                   avs_modify_reason    IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.AddIpToSt';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
lvi_row                         INTEGER;
lvn_nr_of_rows                  NUMBER;
lvs_where_clause                VARCHAR2(255);
lvn_next_rows                   NUMBER;
lts_st_tab                      UNAPIGEN.VC20_TABLE_TYPE;
lts_version_tab                 UNAPIGEN.VC20_TABLE_TYPE;
lts_ip_tab                      UNAPIGEN.VC20_TABLE_TYPE;
lts_ip_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
lts_description_tab             UNAPIGEN.VC40_TABLE_TYPE;
ltc_is_protected_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_hidden_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
ltc_freq_tp_tab                 UNAPIGEN.CHAR1_TABLE_TYPE;
ltn_freq_val_tab                UNAPIGEN.NUM_TABLE_TYPE;
lts_freq_unit_tab               UNAPIGEN.VC20_TABLE_TYPE;
ltc_invert_freq_tab             UNAPIGEN.CHAR1_TABLE_TYPE;
ltd_last_sched_tab              UNAPIGEN.DATE_TABLE_TYPE;
ltn_last_cnt_tab                UNAPIGEN.NUM_TABLE_TYPE;
lts_last_val_tab                UNAPIGEN.VC40_TABLE_TYPE;
ltc_inherit_au_tab              UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
   --------------------------------------------------------------------------------
   -- Get ip's assigned to st
   --------------------------------------------------------------------------------
   lvs_where_clause    := 'WHERE st = ''' || REPLACE (avs_st, '''', '''''') || ''' AND version = '''|| avs_st_version || '''';
   lvn_next_rows       := 0;
   lvn_nr_of_rows      := NULL;

   lvi_ret_code := UNAPIST.GETSTINFOPROFILE
                (lts_st_tab,
                 lts_version_tab,
                 lts_ip_tab,
                 lts_ip_version_tab,
                 lts_description_tab,
                 ltc_is_protected_tab,
                 ltc_hidden_tab,
                 ltc_freq_tp_tab,
                 ltn_freq_val_tab,
                 lts_freq_unit_tab,
                 ltc_invert_freq_tab,
                 ltd_last_sched_tab,
                 ltn_last_cnt_tab,
                 lts_last_val_tab,
                 ltc_inherit_au_tab,
                 lvn_nr_of_rows,
                 lvs_where_clause,
                 lvn_next_rows);

   --------------------------------------------------------------------------------
   -- Add 1 to the total number of ip's
   --------------------------------------------------------------------------------
   IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      lvn_nr_of_rows := lvn_nr_of_rows + 1;
   ELSE
      lvn_nr_of_rows := 1;
   END IF;

   lvi_row := lvn_nr_of_rows;

   --------------------------------------------------------------------------------
   -- Add new ip to tabletypes
   --------------------------------------------------------------------------------
   lts_ip_tab(lvi_row)            := avs_ip;
   lts_ip_version_tab(lvi_row)    := '~Current~';
   ltc_is_protected_tab(lvi_row)  := avc_is_protected;
   ltc_hidden_tab(lvi_row)        := avc_hidden;
   ltc_freq_tp_tab(lvi_row)       := avc_freq_tp;
   ltn_freq_val_tab(lvi_row)      := avn_freq_val;
   lts_freq_unit_tab(lvi_row)     := avs_freq_unit;
   ltc_invert_freq_tab(lvi_row)   := avc_invert_freq;
   ltd_last_sched_tab(lvi_row)    := NULL;
   ltn_last_cnt_tab(lvi_row)      := 0;
   lts_last_val_tab(lvi_row)      := '';
   ltc_inherit_au_tab(lvi_row)    := '1';

   lvn_next_rows:= -1;
   --------------------------------------------------------------------------------
   -- Assign all ip's to st
   --------------------------------------------------------------------------------
   lvi_ret_code := Unapist.SAVESTINFOPROFILE (avs_st,
                                              avs_st_version,
                                              lts_ip_tab,
                                              lts_ip_version_tab,
                                              ltc_is_protected_tab,
                                              ltc_hidden_tab,
                                              ltc_freq_tp_tab,
                                              ltn_freq_val_tab,
                                              lts_freq_unit_tab,
                                              ltc_invert_freq_tab,
                                              ltd_last_sched_tab,
                                              ltn_last_cnt_tab,
                                              lts_last_val_tab,
                                              ltc_inherit_au_tab,
                                              lvn_nr_of_rows,
                                              lvn_next_rows,
                                              avs_modify_reason);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Assigning ip <' || avs_ip || '> to st <' || avs_st || '> failed. Function returned <' || lvi_ret_code || '>');
   END IF;

RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END AddIpToSt;

FUNCTION AddAuToPp(avs_pp               IN APAOGEN.PP_TYPE,
                   avs_pp_version       IN APAOGEN.VERSION_TYPE,
                   avs_pp_key1          IN VARCHAR2,
                   avs_pp_key2          IN VARCHAR2,
                   avs_pp_key3          IN VARCHAR2,
                   avs_pp_key4          IN VARCHAR2,
                   avs_pp_key5          IN VARCHAR2,
                   avs_au               IN APAOGEN.AU_TYPE,
                   avs_value            IN APAOGEN.AU_TYPE,
                   avs_modify_reason    IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.AddAuToPp';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
lvi_row                         INTEGER;
lvn_nr_of_rows                  NUMBER;

--Specific local variables
lts_pp_tab                      Unapigen.VC20_TABLE_TYPE;
lts_version_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key1_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key2_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key3_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key4_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key5_tab                 Unapigen.VC20_TABLE_TYPE;
lts_au_tab                      Unapigen.VC20_TABLE_TYPE;
lts_au_version_tab              Unapigen.VC20_TABLE_TYPE;
lts_value_tab                   Unapigen.VC40_TABLE_TYPE;
lts_description_tab             Unapigen.VC40_TABLE_TYPE;
ltc_is_protected_tab            Unapigen.CHAR1_TABLE_TYPE;
ltc_single_valued_tab           Unapigen.CHAR1_TABLE_TYPE;
ltc_new_val_allowed_tab         Unapigen.CHAR1_TABLE_TYPE;
ltc_store_db_tab                Unapigen.CHAR1_TABLE_TYPE;
ltc_value_list_tp_tab           Unapigen.CHAR1_TABLE_TYPE;
ltc_run_mode_tab                Unapigen.CHAR1_TABLE_TYPE;
lts_service_tab                 Unapigen.VC255_TABLE_TYPE;
lts_cf_value_tab                Unapigen.VC20_TABLE_TYPE;
lvs_where_clause                VARCHAR2(511);

BEGIN

   --------------------------------------------------------------------------------
   -- Get au's assigned to pp
   --------------------------------------------------------------------------------
   lvs_where_clause := 'WHERE pp      = ''' || REPLACE (avs_pp, '''', '''''')      || ''' ' ||
                         'AND version = ''' ||          avs_pp_version             || ''' ' ||
                         'AND pp_key1 = ''' || REPLACE (avs_pp_key1, '''', '''''') || ''' ' ||
                         'AND pp_key2 = ''' || REPLACE (avs_pp_key2, '''', '''''') || ''' ' ||
                         'AND pp_key3 = ''' || REPLACE (avs_pp_key3, '''', '''''') || ''' ' ||
                         'AND pp_key4 = ''' || REPLACE (avs_pp_key4, '''', '''''') || ''' ' ||
                         'AND pp_key5 = ''' || REPLACE (avs_pp_key5, '''', '''''') || '''';
   lvn_nr_of_rows   := NULL;

   lvi_ret_code := Unapippp.GETPPATTRIBUTE( lts_pp_tab,
                                            lts_version_tab,
                                            lts_pp_key1_tab,
                                            lts_pp_key2_tab,
                                            lts_pp_key3_tab,
                                            lts_pp_key4_tab,
                                            lts_pp_key5_tab,
                                            lts_au_tab,
                                            lts_au_version_tab,
                                            lts_value_tab,
                                            lts_description_tab,
                                            ltc_is_protected_tab,
                                            ltc_single_valued_tab,
                                            ltc_new_val_allowed_tab,
                                            ltc_store_db_tab,
                                            ltc_value_list_tp_tab,
                                            ltc_run_mode_tab,
                                            lts_service_tab,
                                            lts_cf_value_tab,
                                            lvn_nr_of_rows,
                                            lvs_where_clause);

   --------------------------------------------------------------------------------
   -- Add 1 to the total number of au's
   --------------------------------------------------------------------------------
   IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      lvn_nr_of_rows := lvn_nr_of_rows + 1;
   ELSE
      lvn_nr_of_rows := 1;
   END IF;

   lvi_row := lvn_nr_of_rows;

   --------------------------------------------------------------------------------
   -- Add new au to tabletypes
   --------------------------------------------------------------------------------
   lts_au_tab(lvi_row)    := avs_au;
   lts_value_tab(lvi_row) := avs_value;

   lvi_ret_code := UNAPIPPP.SAVEPPATTRIBUTE( avs_pp,
                                             avs_pp_version,
                                             avs_pp_key1,
                                             avs_pp_key2,
                                             avs_pp_key3,
                                             avs_pp_key4,
                                             avs_pp_key5,
                                             lts_au_tab,
                                             lts_au_version_tab,
                                             lts_value_tab,
                                             lvn_nr_of_rows,
                                             avs_modify_reason);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Assigning au <' || avs_au || '> to pp <' || avs_pp || '> failed. Function returned <' || lvi_ret_code || '>');
   END IF;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END AddAuToPp;

FUNCTION AddPrToPp(avs_pp               IN APAOGEN.PP_TYPE,
                   avs_pp_version       IN APAOGEN.VERSION_TYPE,
                   avs_pp_key1          IN VARCHAR2,
                   avs_pp_key2          IN VARCHAR2,
                   avs_pp_key3          IN VARCHAR2,
                   avs_pp_key4          IN VARCHAR2,
                   avs_pp_key5          IN VARCHAR2,
                   avs_pr               IN APAOGEN.PR_TYPE,
                   avr_template         IN TEMPLATE_TYPE,
                   avs_modify_reason    IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.AddPrToPp';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
lvi_row                         INTEGER;
lvn_nr_of_rows                  NUMBER;

lvs_where_clause                VARCHAR2(511);
lts_pp_tab                      Unapigen.VC20_TABLE_TYPE;
lts_version_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key1_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key2_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key3_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key4_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pp_key5_tab                 Unapigen.VC20_TABLE_TYPE;
lts_pr_tab                      Unapigen.VC20_TABLE_TYPE;
lts_pr_version_tab              Unapigen.VC20_TABLE_TYPE;
lts_description_tab             Unapigen.VC40_TABLE_TYPE;
lts_unit_tab                    Unapigen.VC20_TABLE_TYPE;
lts_format_tab                  Unapigen.VC40_TABLE_TYPE;
ltn_nr_measur_tab               Unapigen.NUM_TABLE_TYPE;
ltc_allow_add_tab               Unapigen.CHAR1_TABLE_TYPE;
ltc_is_pp_tab                   Unapigen.CHAR1_TABLE_TYPE;
ltc_freq_tp_tab                 Unapigen.CHAR1_TABLE_TYPE;
ltn_freq_val_tab                Unapigen.NUM_TABLE_TYPE;
lts_freq_unit_tab               Unapigen.VC20_TABLE_TYPE;
ltc_invert_freq_tab             Unapigen.CHAR1_TABLE_TYPE;
ltc_st_based_freq_tab           Unapigen.CHAR1_TABLE_TYPE;
ltd_last_sched_tab              Unapigen.DATE_TABLE_TYPE;
ltn_last_cnt_tab                Unapigen.NUM_TABLE_TYPE;
lts_last_val_tab                Unapigen.VC40_TABLE_TYPE;
ltc_inherit_au_tab              Unapigen.CHAR1_TABLE_TYPE;
ltn_delay_tab                   Unapigen.NUM_TABLE_TYPE;
lts_delay_unit_tab              Unapigen.VC20_TABLE_TYPE;
lts_mt_tab                      Unapigen.VC20_TABLE_TYPE;
lts_mt_version_tab              Unapigen.VC20_TABLE_TYPE;
ltn_mt_nr_measur_tab            Unapigen.NUM_TABLE_TYPE;

lvn_nr_of_rows_specs            NUMBER;
lvc_spec_set                    CHAR(1);
ltf_low_limit_tab               Unapigen.FLOAT_TABLE_TYPE;
ltf_high_limit_tab              Unapigen.FLOAT_TABLE_TYPE;
ltf_low_spec_tab                Unapigen.FLOAT_TABLE_TYPE;
ltf_high_spec_tab               Unapigen.FLOAT_TABLE_TYPE;
ltf_low_dev_tab                 Unapigen.FLOAT_TABLE_TYPE;
ltc_rel_low_dev_tab             Unapigen.CHAR1_TABLE_TYPE;
ltf_target_tab                  Unapigen.FLOAT_TABLE_TYPE;
ltf_high_dev_tab                Unapigen.FLOAT_TABLE_TYPE;
ltc_rel_high_dev_tab            Unapigen.CHAR1_TABLE_TYPE;

BEGIN

   --------------------------------------------------------------------------------
   -- Get pr's assigned to pp
   --------------------------------------------------------------------------------
   lvs_where_clause := 'WHERE pp      = ''' || REPLACE (avs_pp, '''', '''''')      || ''' ' ||
                         'AND version = ''' ||          avs_pp_version             || ''' ' ||
                         'AND pp_key1 = ''' || REPLACE (avs_pp_key1, '''', '''''') || ''' ' ||
                         'AND pp_key2 = ''' || REPLACE (avs_pp_key2, '''', '''''') || ''' ' ||
                         'AND pp_key3 = ''' || REPLACE (avs_pp_key3, '''', '''''') || ''' ' ||
                         'AND pp_key4 = ''' || REPLACE (avs_pp_key4, '''', '''''') || ''' ' ||
                         'AND pp_key5 = ''' || REPLACE (avs_pp_key5, '''', '''''') || '''';
   lvn_nr_of_rows   := NULL;

   lvi_ret_code := Unapipp.GETPPPARAMETER (lts_pp_tab,
                                           lts_version_tab,
                                           lts_pp_key1_tab,
                                           lts_pp_key2_tab,
                                           lts_pp_key3_tab,
                                           lts_pp_key4_tab,
                                           lts_pp_key5_tab,
                                           lts_pr_tab,
                                           lts_pr_version_tab,
                                           lts_description_tab,
                                           lts_unit_tab,
                                           lts_format_tab,
                                           ltn_nr_measur_tab,
                                           ltc_allow_add_tab,
                                           ltc_is_pp_tab,
                                           ltc_freq_tp_tab,
                                           ltn_freq_val_tab,
                                           lts_freq_unit_tab,
                                           ltc_invert_freq_tab,
                                           ltc_st_based_freq_tab,
                                           ltd_last_sched_tab,
                                           ltn_last_cnt_tab,
                                           lts_last_val_tab,
                                           ltc_inherit_au_tab,
                                           ltn_delay_tab,
                                           lts_delay_unit_tab,
                                           lts_mt_tab,
                                           lts_mt_version_tab,
                                           ltn_mt_nr_measur_tab,
                                           lvn_nr_of_rows,
                                           lvs_where_clause);

   --------------------------------------------------------------------------------
   -- Add 1 to the total number of pr's
   --------------------------------------------------------------------------------
   IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      --------------------------------------------------------------------------------
      -- Retrieve specs for current pp
      --------------------------------------------------------------------------------
      lvc_spec_set := 'a';
      lvi_ret_code := Unapipp.GETPPPARAMETERSPECS(lts_pp_tab,
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
                                                  lvc_spec_set,
                                                  lvn_nr_of_rows_specs,
                                                  lvs_where_clause);

      IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
         APAOGEN.LogError (lcs_function_name, 'Retrieving specifications of pp <' || avs_pp || '> failed. Function returned <' || lvi_ret_code || '>');
      END IF;
      lvn_nr_of_rows_specs := lvn_nr_of_rows_specs + 1;
      lvn_nr_of_rows := lvn_nr_of_rows + 1;
   ELSE
      lvn_nr_of_rows := 1;
   END IF;


   lvi_row := lvn_nr_of_rows;

   --------------------------------------------------------------------------------
   -- Add new pr to tabletypes
   --------------------------------------------------------------------------------
   SELECT nr_measur,
          unit,
          format,
          allow_add,
          is_pp,
          freq_tp,
          freq_val,
          freq_unit,
          invert_freq,
          st_based_freq,
          inherit_au,
          delay,
          delay_unit,
          mt,
          mt_version,
          mt_nr_measur
     INTO ltn_nr_measur_tab(lvi_row),
          lts_unit_tab(lvi_row),
          lts_format_tab(lvi_row),
          ltc_allow_add_tab(lvi_row),
          ltc_is_pp_tab(lvi_row),
          ltc_freq_tp_tab(lvi_row),
          ltn_freq_val_tab(lvi_row),
          lts_freq_unit_tab(lvi_row),
          ltc_invert_freq_tab(lvi_row),
          ltc_st_based_freq_tab(lvi_row),
          ltc_inherit_au_tab(lvi_row),
          ltn_delay_tab(lvi_row),
          lts_delay_unit_tab(lvi_row),
          lts_mt_tab(lvi_row),
          lts_mt_version_tab(lvi_row),
          ltn_mt_nr_measur_tab(lvi_row)
     FROM utpppr
    WHERE pp = avr_template.template
      AND version = avr_template.version
      AND pp_key1 = avr_template.pp_key1 AND pp_key2 = avr_template.pp_key2 AND pp_key3 = avr_template.pp_key3 AND pp_key4 = avr_template.pp_key4 AND pp_key5 = avr_template.pp_key5
      AND pr = avs_pr
      AND pr_version = '~Current~';

   lts_pr_tab(lvi_row)              := avs_pr;
   lts_pr_version_tab(lvi_row)      := '~Current~';

   ltd_last_sched_tab(lvi_row)      := NULL;
   ltn_last_cnt_tab(lvi_row)        := 0;
   lts_last_val_tab(lvi_row)        := '';

   lvi_row := lvn_nr_of_rows_specs;

   BEGIN
      SELECT low_limit,
             high_limit,
             low_spec,
             high_spec,
             low_dev,
             rel_low_dev,
             target,
             high_dev,
             rel_high_dev
        INTO ltf_low_limit_tab(lvi_row),
             ltf_high_limit_tab(lvi_row),
             ltf_low_spec_tab(lvi_row),
             ltf_high_spec_tab(lvi_row),
             ltf_low_dev_tab(lvi_row),
             ltc_rel_low_dev_tab(lvi_row),
             ltf_target_tab(lvi_row),
             ltf_high_dev_tab(lvi_row),
             ltc_rel_high_dev_tab(lvi_row)
        FROM utppspa
       WHERE pp = avr_template.template
         AND version = avr_template.version
         AND pp_key1 = avr_template.pp_key1 AND pp_key2 = avr_template.pp_key2 AND pp_key3 = avr_template.pp_key3 AND pp_key4 = avr_template.pp_key4 AND pp_key5 = avr_template.pp_key5
         AND pr = avs_pr
         AND pr_version = '~Current~';
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      --------------------------------------------------------------------------------
      -- No specs found for pr
      --------------------------------------------------------------------------------
      lvn_nr_of_rows_specs := lvn_nr_of_rows_specs - 1;
   END;
   --------------------------------------------------------------------------------
   -- Save pr's for current pp
   --------------------------------------------------------------------------------
   lvi_ret_code := Unapipp.SAVEPPPARAMETER (avs_pp,
                                            avs_pp_version,
                                            avs_pp_key1,
                                            avs_pp_key2,
                                            avs_pp_key3,
                                            avs_pp_key4,
                                            avs_pp_key5,
                                            lts_pr_tab,
                                            lts_pr_version_tab,
                                            ltn_nr_measur_tab,
                                            lts_unit_tab,
                                            lts_format_tab,
                                            ltc_allow_add_tab,
                                            ltc_is_pp_tab,
                                            ltc_freq_tp_tab,
                                            ltn_freq_val_tab,
                                            lts_freq_unit_tab,
                                            ltc_invert_freq_tab,
                                            ltc_st_based_freq_tab,
                                            ltd_last_sched_tab,
                                            ltn_last_cnt_tab,
                                            lts_last_val_tab,
                                            ltc_inherit_au_tab,
                                            ltn_delay_tab,
                                            lts_delay_unit_tab,
                                            lts_mt_tab,
                                            lts_mt_version_tab,
                                            ltn_mt_nr_measur_tab,
                                            lvn_nr_of_rows,
                                            avs_modify_reason);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Assigning pr <' || avs_pr || '> to pp <' || avs_pp || '> failed. Function returned <' || lvi_ret_code || '>');
   END IF;

   --------------------------------------------------------------------------------
   -- Save specs for current pp
   --------------------------------------------------------------------------------
   lvi_ret_code := Unapipp.SAVEPPPARAMETERSPECS(avs_pp,
                                                avs_pp_version,
                                                avs_pp_key1,
                                                avs_pp_key2,
                                                avs_pp_key3,
                                                avs_pp_key4,
                                                avs_pp_key5,
                                                lts_pr_tab,
                                                lts_pr_version_tab,
                                                lvc_spec_set,
                                                ltf_low_limit_tab,
                                                ltf_high_limit_tab,
                                                ltf_low_spec_tab,
                                                ltf_high_spec_tab,
                                                ltf_low_dev_tab,
                                                ltc_rel_low_dev_tab,
                                                ltf_target_tab,
                                                ltf_high_dev_tab,
                                                ltc_rel_high_dev_tab,
                                                lvn_nr_of_rows_specs,
                                                avs_modify_reason);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Saving specifications to pp <' || avs_pp || '> failed. Function returned <' || lvi_ret_code || '>');
   END IF;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END AddPrToPp;

FUNCTION RemAuFromSt(avs_st               IN APAOGEN.ST_TYPE,
                     avs_st_version       IN APAOGEN.VERSION_TYPE,
                     avs_au               IN APAOGEN.AU_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.RemAuFromSt';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

BEGIN

   DELETE
     FROM utstau
    WHERE st = avs_st
      AND version = avs_st_version
      AND au = avs_au;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END RemAuFromSt;

FUNCTION RemAuFromPp(avs_pp               IN APAOGEN.PP_TYPE,
                     avs_pp_version       IN APAOGEN.VERSION_TYPE,
                     avs_pp_key1          IN VARCHAR2,
                     avs_pp_key2          IN VARCHAR2,
                     avs_pp_key3          IN VARCHAR2,
                     avs_pp_key4          IN VARCHAR2,
                     avs_pp_key5          IN VARCHAR2,
                     avs_au               IN APAOGEN.AU_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.RemAuFromPp';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

BEGIN

   DELETE
     FROM utppau
    WHERE pp = avs_pp
      AND version = avs_pp_version
      AND pp_key1 = avs_pp_key1 AND pp_key2 = avs_pp_key2 AND pp_key3 = avs_pp_key3 AND pp_key4 = avs_pp_key4 AND pp_key5 = avs_pp_key5
      AND au = avs_au;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END RemAuFromPp;

FUNCTION SynchronizeStGk (avs_st            IN APAOGEN.ST_TYPE,
                          avs_st_version    IN APAOGEN.VERSION_TYPE,
                          avs_template      IN Template_Type,
                          avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.SynchronizeStGk';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
lvs_st                          VARCHAR2(20);
lvs_version                     VARCHAR2(20);
lvs_gk                          VARCHAR2(20);
lvs_gk_version                  VARCHAR2(20);
lvn_nr_of_rows                  NUMBER;
lvs_modify_reason               VARCHAR2(255);
lts_value_tab                   UNAPIGEN.VC40_TABLE_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_stgk(avs_st            IN VARCHAR2,
                avs_st_version    IN VARCHAR2,
                avs_tmp           IN VARCHAR2,
                avs_tmp_version   IN VARCHAR2) IS

SELECT DISTINCT st,version, gk, gk_version
  FROM utstgk
 WHERE st = avs_tmp AND version = avs_tmp_version
   AND gk NOT IN (SELECT APAOGEN.STRTOK(what_description, '"', 4)
                    FROM utsths
                   WHERE st = avs_st
                     AND version = avs_st_version
                     AND what = 'StGroupKeyUpdated');

CURSOR lvq_stgkvalues(avs_st            IN VARCHAR2,
                      avs_st_version    IN VARCHAR2,
                      avs_tmp           IN VARCHAR2,
                      avs_tmp_version   IN VARCHAR2,
                      avs_gk            IN VARCHAR2) IS

SELECT *
  FROM utstgk
 WHERE st = avs_tmp AND version = avs_tmp_version
   AND gk NOT IN (SELECT APAOGEN.STRTOK(what_description, '"', 4)
                    FROM utsths
                   WHERE st = avs_st
                     AND version = avs_st_version
                     AND what = 'StGroupKeyUpdated')
   AND gk = avs_gk;

BEGIN

    lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT;
    ---------------------------------------------------------------------------------------------
    -- Loop through all gk's of template
    ---------------------------------------------------------------------------------------------
    FOR lvr_stgk IN lvq_stgk(avs_st, avs_st_version, avs_template.template, avs_template.version) LOOP
      --------------------------------------------------------------------------------
      -- assign found gk's to st
      --------------------------------------------------------------------------------
      lvs_st             := avs_st;
      lvs_version        := avs_st_version;
      lvs_gk             := lvr_stgk.gk;
      lvs_gk_version     := lvr_stgk.gk_version;
      lvn_nr_of_rows     := 0;
      lvs_modify_reason  := avs_modify_reason;
      ---------------------------------------------------------------------------------------------
      -- Loop through all gkvalues of template
      ---------------------------------------------------------------------------------------------
      FOR lvr_stgkvalues IN lvq_stgkvalues(avs_st, avs_st_version, avs_template.template, avs_template.version, lvs_gk) LOOP
         lvn_nr_of_rows := lvn_nr_of_rows + 1;
         lts_value_tab(lvn_nr_of_rows) := lvr_stgkvalues.value;
      END LOOP;

      ---------------------------------------------------------------------------------------------
      -- Save current gk with gkvalues of template
      ---------------------------------------------------------------------------------------------
      lvi_ret_code := UNAPIST.SAVE1STGROUPKEY(lvs_st,
                                              lvs_version,
                                              lvs_gk,
                                              lvs_gk_version,
                                              lts_value_tab,
                                              lvn_nr_of_rows,
                                              lvs_modify_reason);

       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
          APAOGEN.LogError (lcs_function_name, 'Update of groupkey <' || lvs_gk || '> of st <' || lvs_st || '[' || lvs_version ||']> failed. Function returned <' || lvi_ret_code || '>');
       END IF;
    END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END SynchronizeStGk;

--------------------------------------------------------------------------------
-- FUNCTION : SynchronizeStAu
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
-- REVIEWER :
--     DATE : xx/xx/20xx
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- xx/xx/20xx | RS        | Created
-- 29/03/2016 | AF        | Exclude the attribute avCustInterspecTp
--------------------------------------------------------------------------------
FUNCTION SynchronizeStAu (avs_st            IN APAOGEN.ST_TYPE,
                          avs_st_version    IN APAOGEN.VERSION_TYPE,
                          avs_template      IN Template_Type,
                          avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.SynchronizeStAu';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code	                 APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_stau(avs_st            IN VARCHAR2,
                avs_st_version    IN VARCHAR2) IS
SELECT *
  FROM utstau
 WHERE st = avs_st AND version = avs_st_version
   AND au != 'avCustInterspecTp';

BEGIN

    lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT;
    ---------------------------------------------------------------------------------------------
    -- Loop through all au's of template
    ---------------------------------------------------------------------------------------------
    FOR lvr_stau IN lvq_stau(avs_template.template, avs_template.version) LOOP
        --------------------------------------------------------------------------------
        -- assign found au's to st
        --------------------------------------------------------------------------------
        lvi_ret_code := AddAuToSt(avs_st, avs_st_version,
                                  lvr_stau.au,
                                  lvr_stau.value,
                                  avs_modify_reason);
    END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END SynchronizeStAu;

--------------------------------------------------------------------------------
-- FUNCTION : SynchronizeStpp
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
-- REVIEWER :
--     DATE : xx/xx/20xx
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- xx/xx/20xx | RS        | Created
-- 29/03/2016 | AF        | Make sure only the Unilab specific parametergroups
--                          will be added from the template (pp_key1 = ' ')
--                          Removed the creation of new parametergroups for
--                          these pp
--------------------------------------------------------------------------------
FUNCTION SynchronizeStPp (avs_st            IN APAOGEN.ST_TYPE,
                          avs_st_version    IN APAOGEN.VERSION_TYPE,
                          avs_template      IN Template_Type,
                          avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.SynchronizeStPp';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code	                 APAOGEN.RETURN_TYPE;
lvs_version                     VARCHAR2(20);
lvs_cp_pp                       VARCHAR2(20);
lvs_cp_version                  VARCHAR2(20);
lvs_cp_pp_key1                  VARCHAR2(20);
lvs_cp_pp_key2                  VARCHAR2(20);
lvs_cp_pp_key3                  VARCHAR2(20);
lvs_cp_pp_key4                  VARCHAR2(20);
lvs_cp_pp_key5                  VARCHAR2(20);
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_stpp(avs_tmp            IN VARCHAR2,
                avs_tmp_version    IN VARCHAR2,
                avs_st             IN VARCHAR2,
                avs_st_version     IN VARCHAR2) IS
SELECT a.*
  FROM utstpp a, utpp b
 WHERE a.st = avs_tmp AND a.version = avs_tmp_version
   AND a.pp = b.pp
   AND a.pp_key1 = b.pp_key1 AND a.pp_key2 = b.pp_key2 AND a.pp_key3 = b.pp_key3 AND a.pp_key4 = b.pp_key4 AND a.pp_key5 = b.pp_key5
   AND a.pp_key1 = ' '
   AND b.pp NOT IN (SELECT pp FROM utstpp WHERE st = avs_st AND version = avs_st_version)
   AND b.version_is_current = 1;

CURSOR lvq_stppau(avs_tmp            IN VARCHAR2,
                  avs_tmp_version    IN VARCHAR2,
                  avs_st             IN VARCHAR2,
                  avs_st_version     IN VARCHAR2) IS
SELECT a.*
  FROM utstppau a, utpp b
 WHERE a.st = avs_tmp AND a.version = avs_tmp_version
   AND a.pp = b.pp
   AND a.pp_key1 = b.pp_key1 AND a.pp_key2 = b.pp_key2 AND a.pp_key3 = b.pp_key3 AND a.pp_key4 = b.pp_key4 AND a.pp_key5 = b.pp_key5
   AND a.pp_key1 = avs_tmp
   AND b.pp NOT IN (SELECT pp FROM utstpp WHERE st = avs_st AND version = avs_st_version)
   AND b.version_is_current = 1;

CURSOR lvq_pppr_freq(avs_tmp            IN VARCHAR2,
                     avs_tmp_version    IN VARCHAR2,
                     avs_st             IN VARCHAR2,
                     avs_st_version     IN VARCHAR2) IS
   SELECT UNAPIGEN.USEPPVERSION(d.pp, d.pp_version, d.st, d.pp_key2, d.pp_key3, d.pp_key4, d.pp_key5) ppversion, c.*
     FROM utstpp a, utpp b, utpppr c, utstpp d
    WHERE a.st = avs_tmp AND a.version = avs_tmp_version
      AND a.pp = b.pp
      AND a.pp_key1 = b.pp_key1 AND a.pp_key2 = b.pp_key2 AND a.pp_key3 = b.pp_key3 AND a.pp_key4 = b.pp_key4 AND a.pp_key5 = b.pp_key5
      AND a.pp_key1 = a.st
      AND b.pp IN (SELECT pp FROM utstpp WHERE st = avs_st AND version = avs_st_version)
      AND b.version_is_current = 1
      AND b.pp = c.pp AND b.version = c.version
      AND b.pp_key1 = c.pp_key1 AND b.pp_key2 = c.pp_key2 AND b.pp_key3 = c.pp_key3 AND b.pp_key4 = c.pp_key4 AND b.pp_key5 = c.pp_key5
      AND d.st = avs_st AND d.version = avs_st_version
      AND b.pp = d.pp
      AND d.pp_key1 = d.st AND b.pp_key2 = c.pp_key2 AND b.pp_key3 = c.pp_key3 AND b.pp_key4 = c.pp_key4 AND b.pp_key5 = c.pp_key5;

BEGIN

    lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT;

    ---------------------------------------------------------------------------------------------
    -- Loop through all pr's of template to synchronize frequencies
    ---------------------------------------------------------------------------------------------
    FOR lvr_pppr IN lvq_pppr_freq (avs_template.template, avs_template.version, avs_st, avs_st_version) LOOP

      ---------------------------------------------------------------------------------------------
      -- Synchronize freq with template
      ---------------------------------------------------------------------------------------------
      UPDATE utpppr
         SET freq_tp     = lvr_pppr.freq_tp,
             freq_unit   = lvr_pppr.freq_unit,
             freq_val    = lvr_pppr.freq_val,
             invert_freq = lvr_pppr.invert_freq
       WHERE pp = lvr_pppr.pp
         AND version = lvr_pppr.ppversion
         AND pp_key1 = avs_st
         AND pp_key2 = ' '
         AND pp_key3 = ' '
         AND pp_key4 = ' '
         AND pp_key5 = ' '
         AND pr = lvr_pppr.pr;

    END LOOP;

    ---------------------------------------------------------------------------------------------
    -- Loop through all stppau's of template
    ---------------------------------------------------------------------------------------------
    FOR lvr_stppau IN lvq_stppau(avs_template.template, avs_template.version, avs_st, avs_st_version) LOOP
      --------------------------------------------------------------------------------
      -- assign found au's to stpp
      --------------------------------------------------------------------------------
      lvi_ret_code := AddAuToStPp(avs_st, avs_st_version,
                                 lvr_stppau.pp, lvr_stppau.pp_version,
                                 lvr_stppau.au, lvr_stppau.value,
                                 avs_modify_reason);
    END LOOP;


    ---------------------------------------------------------------------------------------------
    -- Loop through all pp's of template
    ---------------------------------------------------------------------------------------------
    FOR lvr_stpp IN lvq_stpp(avs_template.template, avs_template.version, avs_st, avs_st_version) LOOP
       --------------------------------------------------------------------------------
       -- assign found pp's to st for which the pp_key1 is empty (or a space ==> so != st)
       --------------------------------------------------------------------------------
       lvi_ret_code := AddPpToSt(avs_st, avs_st_version,
                                 lvr_stpp.pp, ' ',
                                 lvr_stpp.freq_tp, lvr_stpp.freq_val, lvr_stpp.freq_unit, lvr_stpp.invert_freq,
                                 avs_modify_reason);
       IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
          APAOGEN.LogError (lcs_function_name, '(AddPpToSt) Adding pp <' || lvr_stpp.pp || 'to ST <'|| avs_st || '[' || avs_st_version || ']> failed. Function returned <' || lvi_ret_code || '>');
       END IF;
    END LOOP;

    RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END SynchronizeStpp;

--------------------------------------------------------------------------------
-- FUNCTION : SynchronizeStPpFreq
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : XX
-- REVIEWER :
--     DATE : xx/xx/20xx
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- xx/xx/20xx | AF        | Created
-- 13/04/2016 | AF        | Changed determining return value due to changed
--                          logic IS decides which PP to be added and not the
--                          template anymore. Existing PP in template but not in
--                          spec resolve in GENFAIL error which is not desired
--------------------------------------------------------------------------------
FUNCTION SynchronizeStPpFreq (avs_st            IN APAOGEN.ST_TYPE,
                              avs_st_version    IN APAOGEN.VERSION_TYPE,
                              avs_tmp           IN APAOGEN.ST_TYPE,
                              avs_tmp_version   IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.SynchronizeStPpFreq';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_tmppp(avs_st             IN VARCHAR2,
                 avs_st_version     IN VARCHAR2) IS
SELECT a.*
  FROM utstpp a, utpp b
 WHERE a.st = avs_st AND a.version = avs_st_version
   AND a.pp = b.pp
   AND a.pp_key1 = b.pp_key1 AND a.pp_key2 = b.pp_key2 AND a.pp_key3 = b.pp_key3 AND a.pp_key4 = b.pp_key4 AND a.pp_key5 = b.pp_key5
   AND a.pp_key1 = avs_st;

BEGIN

    lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT;
    ---------------------------------------------------------------------------------------------
    -- Loop through all stpp's of template
    ---------------------------------------------------------------------------------------------
    FOR lvr_tmppp IN lvq_tmppp(avs_tmp, avs_tmp_version) LOOP
       ---------------------------------------------------------------------------------------------
       -- Loop through all stpp's
       ---------------------------------------------------------------------------------------------
       UPDATE utstpp
          SET freq_tp      = lvr_tmppp.freq_tp,
              freq_val     = lvr_tmppp.freq_val,
              freq_unit    = lvr_tmppp.freq_unit,
              invert_freq  = lvr_tmppp.invert_freq
        WHERE st = avs_st AND version = avs_st_version
          AND pp = lvr_tmppp.pp;
    END LOOP;

    RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END SynchronizeStPpFreq;

--------------------------------------------------------------------------------
-- FUNCTION : SyncStPpFreqNotManual
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
-- REVIEWER :
--     DATE : xx/xx/20xx
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- xx/xx/20xx | RS        | Created
-- 29/03/2016 | AF        | Handle the extra argument in FindSpecTypeTemplate
--------------------------------------------------------------------------------
FUNCTION SyncStPpFreqNotManual (avs_st            IN APAOGEN.ST_TYPE,
                                avs_st_version    IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.SyncStPpFreqNotManual';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code	                 APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_tmppp(avs_st             IN VARCHAR2,
                 avs_st_version     IN VARCHAR2) IS
SELECT a.*
  FROM utstpp a, utpp b
 WHERE a.st = avs_st AND a.version = avs_st_version
   AND a.pp = b.pp
   AND a.pp_key1 = b.pp_key1 AND a.pp_key2 = b.pp_key2 AND a.pp_key3 = b.pp_key3 AND a.pp_key4 = b.pp_key4 AND a.pp_key5 = b.pp_key5
   AND a.pp_key1 = avs_st
   AND a.freq_tp = 'C' AND a.freq_unit != 'Manual';

lvr_template         Template_Type;
lvs_spectype         VARCHAR2(40);
lvb_correct_config   BOOLEAN;

BEGIN

   --------------------------------------------------------------------------------
   -- Find the spectype
   --------------------------------------------------------------------------------
   lvs_spectype := APAOACTION.GetStSpecType (avs_st, avs_st_version);
   --------------------------------------------------------------------------------
   -- Find the template
   --------------------------------------------------------------------------------
   lvr_template := APAOACTION.FindSpecTypeTemplate ( avs_st, avs_st_version, lvs_spectype, lvb_correct_config);

   IF lvr_template.template IS NULL THEN
      APAOGEN.LogError (lcs_function_name, 'No st-template found for <' || avs_st || '[' || avs_st_version || ']>');
      RETURN UNAPIGEN.DBERR_NOOBJECT;
   END IF;
   ---------------------------------------------------------------------------------------------
   -- Assumption : If we do not find a custom frequency, always return success
   --              Otherwise return the success of the update statement
   ---------------------------------------------------------------------------------------------
   lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
   ---------------------------------------------------------------------------------------------
   -- Loop through all stpp's of template
   ---------------------------------------------------------------------------------------------
   FOR lvr_tmppp IN lvq_tmppp(lvr_template.template, lvr_template.version) LOOP
       ---------------------------------------------------------------------------------------------
       -- Loop through all stpp's
       ---------------------------------------------------------------------------------------------
       UPDATE utstpp
          SET freq_tp      = lvr_tmppp.freq_tp,
              freq_val     = lvr_tmppp.freq_val,
              freq_unit    = lvr_tmppp.freq_unit,
              invert_freq  = lvr_tmppp.invert_freq
        WHERE st = avs_st AND version = avs_st_version
          AND pp = lvr_tmppp.pp;

       IF SQL%ROWCOUNT != 0 THEN
          lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
       ELSE
          lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
       END IF;

   END LOOP;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END SyncStPpFreqNotManual;

FUNCTION SynchronizeStIp (avs_st            IN APAOGEN.ST_TYPE,
                          avs_st_version    IN APAOGEN.VERSION_TYPE,
                          avs_template      IN Template_Type,
                          avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.SynchronizeStIp';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_ip(avs_tmp           IN VARCHAR2,
              avs_tmp_version   IN VARCHAR2,
              avs_st            IN VARCHAR2,
              avs_st_version    IN VARCHAR2) IS
SELECT *
  FROM utstip
 WHERE st = avs_tmp AND version = avs_tmp_version
   AND ip NOT IN (SELECT ip FROM utstip WHERE st = avs_st AND version = avs_st_version);

BEGIN

    lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT;
    ---------------------------------------------------------------------------------------------
    -- Loop through all ip's of template
    ---------------------------------------------------------------------------------------------
    FOR lvr_ip IN lvq_ip(avs_template.template, avs_template.version, avs_st, avs_st_version) LOOP
        --------------------------------------------------------------------------------
        -- assign found ip's to st
        --------------------------------------------------------------------------------
        lvi_ret_code := AddIpToSt(avs_st, avs_st_version,
                                  lvr_ip.ip,
                                  lvr_ip.is_protected, lvr_ip.hidden,
                                  lvr_ip.freq_tp, lvr_ip.freq_val, lvr_ip.freq_unit,
                                  lvr_ip.invert_freq,
                                  avs_modify_reason);
    END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END SynchronizeStIp;

--------------------------------------------------------------------------------
-- FUNCTION : SynchronizePpAu
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
-- REVIEWER :
--     DATE : xx/xx/20xx
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- xx/xx/20xx | RS        | Created
-- 29/03/2016 | AF        | Exclude the attribute avCustInterspecTp
--------------------------------------------------------------------------------
FUNCTION SynchronizePpAu (avs_pp            IN APAOGEN.PP_TYPE,
                          avs_pp_version    IN APAOGEN.VERSION_TYPE,
                          avs_pp_key1       IN VARCHAR2,
                          avs_pp_key2       IN VARCHAR2,
                          avs_pp_key3       IN VARCHAR2,
                          avs_pp_key4       IN VARCHAR2,
                          avs_pp_key5       IN VARCHAR2,
                          avs_template      IN Template_Type,
                          avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.SynchronizePpAu';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code	                 APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_ppau(avs_pp            IN VARCHAR2,
                avs_pp_version    IN VARCHAR2,
                avs_pp_key1       IN VARCHAR2,
                avs_pp_key2       IN VARCHAR2,
                avs_pp_key3       IN VARCHAR2,
                avs_pp_key4       IN VARCHAR2,
                avs_pp_key5       IN VARCHAR2) IS
SELECT *
  FROM utppau
 WHERE pp = avs_pp
   AND version = avs_pp_version
   AND pp_key1 = avs_pp_key1 AND pp_key2 = avs_pp_key2 AND pp_key3 = avs_pp_key3 AND pp_key4 = avs_pp_key4 AND pp_key5 = avs_pp_key5
   AND au != 'avCustInterspecTp';

BEGIN

    lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT;
    ---------------------------------------------------------------------------------------------
    -- Loop through all au's of template
    ---------------------------------------------------------------------------------------------
    FOR lvr_ppau IN lvq_ppau(avs_template.template, avs_template.version, avs_template.pp_key1, avs_template.pp_key2, avs_template.pp_key3, avs_template.pp_key4, avs_template.pp_key5) LOOP
        --------------------------------------------------------------------------------
        -- assign found au's to pp
        --------------------------------------------------------------------------------
        lvi_ret_code := AddAuToPp(avs_pp, avs_pp_version,
                                  avs_pp_key1,
                                  avs_pp_key2,
                                  avs_pp_key3,
                                  avs_pp_key4,
                                  avs_pp_key5,
                                  lvr_ppau.au,
                                  lvr_ppau.value,
                                  avs_modify_reason);
    END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END SynchronizePpAu;

FUNCTION SynchronizePpPr (avs_pp            IN APAOGEN.PP_TYPE,
                          avs_pp_version    IN APAOGEN.VERSION_TYPE,
                          avs_pp_key1       IN VARCHAR2,
                          avs_pp_key2       IN VARCHAR2,
                          avs_pp_key3       IN VARCHAR2,
                          avs_pp_key4       IN VARCHAR2,
                          avs_pp_key5       IN VARCHAR2,
                          avs_template_pp   IN OUT Template_Type,
                          avs_modify_reason IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.SynchronizePpPr';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
lvr_template_pp                 TEMPLATE_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_pppr_add(avs_pp            IN VARCHAR2,
                    avs_pp_version    IN VARCHAR2,
                    avs_pp_key1       IN VARCHAR2,
                    avs_pp_key2       IN VARCHAR2,
                    avs_pp_key3       IN VARCHAR2,
                    avs_pp_key4       IN VARCHAR2,
                    avs_pp_key5       IN VARCHAR2,
                    avs_tmp           IN VARCHAR2,
                    avs_tmp_version   IN VARCHAR2,
                    avs_tmp_key1      IN VARCHAR2,
                    avs_tmp_key2      IN VARCHAR2,
                    avs_tmp_key3      IN VARCHAR2,
                    avs_tmp_key4      IN VARCHAR2,
                    avs_tmp_key5      IN VARCHAR2
                   ) IS
SELECT *
  FROM utpppr
 WHERE pp = avs_tmp
   AND version = avs_tmp_version
   AND pp_key1 = avs_tmp_key1 AND pp_key2 = avs_tmp_key2 AND pp_key3 = avs_tmp_key3 AND pp_key4 = avs_tmp_key4 AND pp_key5 = avs_tmp_key5
   AND pr NOT IN (SELECT pr
                    FROM utpppr
                   WHERE pp = avs_pp
                     AND version = avs_pp_version
                     AND pp_key1 = avs_pp_key1 AND pp_key2 = avs_pp_key2 AND pp_key3 = avs_pp_key3 AND pp_key4 = avs_pp_key4 AND pp_key5 = avs_pp_key5);

CURSOR lvq_pr_not_on_tmp(avs_pp            IN VARCHAR2,
                         avs_pp_version    IN VARCHAR2,
                         avs_pp_key1       IN VARCHAR2,
                         avs_pp_key2       IN VARCHAR2,
                         avs_pp_key3       IN VARCHAR2,
                         avs_pp_key4       IN VARCHAR2,
                         avs_pp_key5       IN VARCHAR2,
                         avs_tmp           IN VARCHAR2,
                         avs_tmp_version   IN VARCHAR2,
                         avs_tmp_key1      IN VARCHAR2,
                         avs_tmp_key2      IN VARCHAR2,
                         avs_tmp_key3      IN VARCHAR2,
                         avs_tmp_key4      IN VARCHAR2,
                         avs_tmp_key5      IN VARCHAR2
                         ) IS
   SELECT *
     FROM utpppr
    WHERE pp = avs_pp
      AND version = avs_pp_version
      AND pp_key1 = avs_pp_key1 AND pp_key2 = avs_pp_key2 AND pp_key3 = avs_pp_key3 AND pp_key4 = avs_pp_key4 AND pp_key5 = avs_pp_key5
      AND pr NOT IN (SELECT pr
                       FROM utpppr
                      WHERE pp = avs_template_pp.template
                        AND version = avs_template_pp.version
                        AND pp_key1 = avs_template_pp.pp_key1 AND pp_key2 = avs_template_pp.pp_key2 AND pp_key3 = avs_template_pp.pp_key3 AND pp_key4 = avs_template_pp.pp_key4 AND pp_key5 = avs_template_pp.pp_key5)
 ORDER BY SEQ DESC;


BEGIN

    lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT;

    ---------------------------------------------------------------------------------------------
    -- Loop through all pr's of template to add missing pr's
    ---------------------------------------------------------------------------------------------
    FOR lvr_pppr IN lvq_pppr_add(avs_pp, avs_pp_version,
                                 avs_pp_key1 , avs_pp_key2, avs_pp_key3, avs_pp_key4, avs_pp_key5,
                                 avs_template_pp.template, avs_template_pp.version,
                                 avs_template_pp.pp_key1, avs_template_pp.pp_key2, avs_template_pp.pp_key3, avs_template_pp.pp_key4, avs_template_pp.pp_key5) LOOP
        --------------------------------------------------------------------------------
        -- assign found pr's to pp
        --------------------------------------------------------------------------------
        lvi_ret_code := AddPrToPp(avs_pp, avs_pp_version,
                                  avs_pp_key1,
                                  avs_pp_key2,
                                  avs_pp_key3,
                                  avs_pp_key4,
                                  avs_pp_key5,
                                  lvr_pppr.pr,
                                  avs_template_pp,
                                  avs_modify_reason);
    END LOOP;
    ---------------------------------------------------------------------------------------------
    -- Loop through all pr's not on template
    ---------------------------------------------------------------------------------------------
    FOR lvr_pr_not_on_tmp IN lvq_pr_not_on_tmp(avs_pp, avs_pp_version,
                                      avs_pp_key1 , avs_pp_key2, avs_pp_key3, avs_pp_key4, avs_pp_key5,
                                      avs_template_pp.template, avs_template_pp.version,
                                      avs_template_pp.pp_key1, avs_template_pp.pp_key2, avs_template_pp.pp_key3, avs_template_pp.pp_key4, avs_template_pp.pp_key5) LOOP
    ---------------------------------------------------------------------------------------------
    -- Set freq to N
    ---------------------------------------------------------------------------------------------
      UPDATE utpppr
         SET freq_tp = 'N'
       WHERE pp = lvr_pr_not_on_tmp.pp
         AND version = lvr_pr_not_on_tmp.version
         AND pp_key1 = lvr_pr_not_on_tmp.pp_key1
         AND pp_key2 = lvr_pr_not_on_tmp.pp_key2
         AND pp_key3 = lvr_pr_not_on_tmp.pp_key3
         AND pp_key4 = lvr_pr_not_on_tmp.pp_key4
         AND pp_key5 = lvr_pr_not_on_tmp.pp_key5
         AND pr = lvr_pr_not_on_tmp.pr;

    END LOOP;
    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END SynchronizePpPr;

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- FUNCTION : FindSpecTypeTemplate
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
-- REVIEWER :
--     DATE : xx/xx/20xx
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- xx/xx/20xx | RS        | Created
-- 29/03/2016 | AF        | Added the check whether only 1 specific and/or
--                          default template will be found. If not an email will
--                          be send
-- 29/03/2016 | AF        | Added extra argument avb_report_error
-- 29/03/2016 | AF        | Added extra argument avb_correct_config
--------------------------------------------------------------------------------
FUNCTION FindSpecTypeTemplate (avs_st             IN  APAOGEN.ST_TYPE,
                               avs_st_version     IN  APAOGEN.VERSION_TYPE,
                               avs_spec_type      IN  VARCHAR2,
                               avb_correct_config OUT BOOLEAN,
                               avb_report_error   IN  BOOLEAN := FALSE)
RETURN Template_Type IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.FindSpecTypeTemplate';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_template1(avs_st         IN VARCHAR2,
                     avs_version    IN VARCHAR2,
                     avs_spec_type  IN VARCHAR2) IS
   SELECT c.st, c.version
     FROM utstgkspec_type a, utstau b, utst c, utstgkspec_type d
    WHERE a.st = avs_st
      AND a.version = avs_version
      AND b.au = 'avCustInterspecTp'
      AND a.st LIKE b.value
      AND b.st = c.st AND b.version = c.version
      AND c.version_is_current = 1
      AND c.st = d.st AND c.version = d.version
      AND d.spec_type = a.spec_type
      AND d.spec_type = avs_spec_type;

CURSOR lvq_template2(avs_st         IN VARCHAR2,
                     avs_version    IN VARCHAR2,
                     avs_spec_type  IN VARCHAR2) IS
   SELECT c.st, c.version
     FROM utstgkspec_type a, utstau b, utst c, utstgkspec_type d
    WHERE a.st = avs_st
      AND a.version = avs_version
      AND b.au = 'avCustInterspecTp'
      AND b.value = '<default>'
      AND b.st = c.st AND b.version = c.version
      AND c.version_is_current = 1
      AND c.st = d.st AND c.version = d.version
      AND d.spec_type = a.spec_type
      AND d.spec_type = avs_spec_type;

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_template   Template_Type;

lvi_template1  PLS_INTEGER := 0;
lvi_template2  PLS_INTEGER := 0;

lvs_dummy1     APAOGEN.NAME_TYPE;
lvs_dummy2     APAOGEN.VERSION_TYPE;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
   procedure SendMail (avs_reason IN VARCHAR2) IS

   lvi_ret_code   APAOGEN.RETURN_TYPE;
   lvs_email      VARCHAR2(255) := NULL;
   lvs_subject    VARCHAR2(255);
   lts_text_tab   UNAPIGEN.VC255_TABLE_TYPE;
   lvn_nr_of_rows NUMBER;

   BEGIN
      --------------------------------------------------------------------------
      -- Get the e-mail adres from LimsAdministrator
      --------------------------------------------------------------------------
      BEGIN
         SELECT email
           INTO lvs_email
           FROM utad
          WHERE ad = 'LimsAdministrator';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
      END;

      --------------------------------------------------------------------------
      -- Only continue when an e-mail adres is found
      --------------------------------------------------------------------------
      IF lvs_email IS NOT NULL THEN
         lvs_subject := 'Configuration issue while searching for template on ST <'||avs_st||'['||avs_st_version||']> and spec_type <'||avs_spec_type||'>';

         lts_text_tab(1) := 'A configuration issue is found while searching for a template on ST <'||avs_st||'['||avs_st_version||']> and spec_type <'||avs_spec_type||'>';
         lts_text_tab(2) := 'Reason: '||avs_reason;
         lts_text_tab(3) := 'Manual intervention is needed!';
         lvn_nr_of_rows  := 3;

         lvi_ret_code := UNAPIGEN.SendMail(a_recipient  => lvs_email,
                                           a_subject    => lvs_subject,
                                           a_text_tab   => lts_text_tab,
                                           a_nr_of_rows => lvn_nr_of_rows);

         IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
            APAOGEN.LogError (lcs_function_name, 'SendMail failed to inform Configuration issue while searching for template on ST <'||avs_st||'['||avs_st_version||']> and spec_type <'||avs_spec_type||'>. Error: '||lvi_ret_code);
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE != 1 THEN
            APAOGEN.LogError (lcs_function_name, SQLERRM);
         END IF;
   END;

BEGIN
   -----------------------------------------------------------------------------
   -- Let find out whether the configuration for the template is correct
   -- Only 1 template must be found
   -- Of not inform the configurator
   -----------------------------------------------------------------------------
    OPEN lvq_template1(avs_st, avs_st_version, avs_spec_type);
   LOOP
      FETCH lvq_template1
       INTO lvs_dummy1, lvs_dummy2;

      EXIT WHEN lvq_template1%NOTFOUND;

      lvi_template1 := lvq_template1%ROWCOUNT;
   END LOOP;

   CLOSE lvq_template1;

    OPEN lvq_template2(avs_st, avs_st_version, avs_spec_type);
   LOOP
      FETCH lvq_template2
       INTO lvs_dummy1, lvs_dummy2;

      EXIT WHEN lvq_template2%NOTFOUND;

      lvi_template2 := lvq_template2%ROWCOUNT;
   END LOOP;

   CLOSE lvq_template2;

   IF avb_report_error THEN
      IF lvi_template1 > 1 THEN
         SendMail (avs_reason=>'For given sampletype, version and spec_type there are <'||lvi_template1||'> templates found where the value of attribute <avCustInterspecTp> is like the sampletype.');
      END IF;

      IF lvi_template2 != 1 THEN
         SendMail (avs_reason=>'For given sampletype, version and spec_type there are <'||lvi_template2||'> templates found where the value of attribute <avCustInterspecTp> is <default>');
      END IF;
   END IF;

   -----------------------------------------------------------------------------
   -- If no specific templates are found and more defaults ==> STOP!
   -- If more specific templates are found (whatever the defaults) ==> STOP!
   -----------------------------------------------------------------------------
   IF (lvi_template1 = 0 AND lvi_template2 != 1) OR (lvi_template1 > 1) THEN
      avb_correct_config := FALSE;
   ELSE
      avb_correct_config := TRUE;
   END IF;

  --------------------------------------------------------------------------------
  -- Look for template with template-au like st
  --------------------------------------------------------------------------------
  FOR lvr_template IN lvq_template1(avs_st, avs_st_version, avs_spec_type) LOOP
      lvs_template.template := lvr_template.st;
      lvs_template.version  := lvr_template.version;
      lvs_template.pp_key1 := lvr_template.st;
      RETURN lvs_template;
  END LOOP;

  --------------------------------------------------------------------------------
  -- Look for template with template-au = <default>
  --------------------------------------------------------------------------------
  FOR lvr_template IN lvq_template2(avs_st, avs_st_version, avs_spec_type) LOOP
      lvs_template.template := lvr_template.st;
      lvs_template.version  := lvr_template.version;
      lvs_template.pp_key1 := lvr_template.st;
      RETURN lvs_template;
  END LOOP;

  RETURN lvs_template;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;

  IF lvq_template1%ISOPEN THEN
     CLOSE lvq_template1;
  END IF;

  IF lvq_template2%ISOPEN THEN
     CLOSE lvq_template2;
  END IF;

  RETURN NULL;

END FindSpecTypeTemplate;

FUNCTION GetStSpecType (avs_st            IN APAOGEN.ST_TYPE,
                        avs_st_version    IN APAOGEN.VERSION_TYPE )
RETURN VARCHAR2 IS

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.GetStSpecType';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_spec_type(avs_st       IN VARCHAR2,
                     avs_version  IN VARCHAR2) IS
   SELECT spec_type
     FROM utstgkspec_type
    WHERE st = avs_st
      AND version = avs_version;

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_spec_type   APAOGEN.GKVALUE_TYPE;

BEGIN

  FOR lvr_spec_type IN lvq_spec_type(avs_st, avs_st_version) LOOP
      lvs_spec_type := lvr_spec_type.spec_type;
      RETURN lvs_spec_type;
  END LOOP;

  RETURN NULL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN NULL;

END GetStSpecType;

FUNCTION GetPpSpecType (avs_pp            IN APAOGEN.PP_TYPE,
                        avs_pp_version    IN APAOGEN.VERSION_TYPE,
                        avs_pp_key1       IN VARCHAR2,
                        avs_pp_key2       IN VARCHAR2,
                        avs_pp_key3       IN VARCHAR2,
                        avs_pp_key4       IN VARCHAR2,
                        avs_pp_key5       IN VARCHAR2)
RETURN VARCHAR2 IS

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.GetPpSpecType';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_st(avs_pp          IN VARCHAR2,
              avs_pp_version  IN APAOGEN.VERSION_TYPE,
              avs_pp_key1     IN VARCHAR2,
              avs_pp_key2     IN VARCHAR2,
              avs_pp_key3     IN VARCHAR2,
              avs_pp_key4     IN VARCHAR2,
              avs_pp_key5     IN VARCHAR2) IS
   --------------------------------------------------------------------------------
   -- All current sampletypes
   --------------------------------------------------------------------------------
   SELECT b.st, b.version
     FROM utstpp a, utst b
    WHERE a.st = b.st AND a.version = b.version
      AND b.st = a.pp_key1
      AND a.pp = avs_pp AND pp_version = avs_pp_version
      AND a.pp_key1 = avs_pp_key1 AND a.pp_key2 = avs_pp_key2 AND a.pp_key3 = avs_pp_key3 AND a.pp_key4 = avs_pp_key4 AND a.pp_key5 = avs_pp_key5
      AND b.version_is_current = 1
    UNION
   --------------------------------------------------------------------------------
   -- All sampletypes ordered by highest version to prevent "no records"
   --------------------------------------------------------------------------------
   SELECT b.st, b.version
     FROM utstpp a, utst b
    WHERE a.st = b.st AND a.version = b.version
      AND b.st = a.pp_key1
      AND a.pp = avs_pp AND pp_version = avs_pp_version
      AND a.pp_key1 = avs_pp_key1 AND a.pp_key2 = avs_pp_key2 AND a.pp_key3 = avs_pp_key3 AND a.pp_key4 = avs_pp_key4 AND a.pp_key5 = avs_pp_key5
    ORDER BY st, version DESC;

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_spec_type   APAOGEN.GKVALUE_TYPE;

BEGIN

  FOR lvr_st IN lvq_st(avs_pp, avs_pp_version, avs_pp_key1, avs_pp_key2, avs_pp_key3, avs_pp_key4, avs_pp_key5) LOOP
      lvs_spec_type := GetStSpecType(lvr_st.st, lvr_st.version);
      RETURN lvs_spec_type;
  END LOOP;

  RETURN NULL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN NULL;

END GetPpSpecType;

--------------------------------------------------------------------------------
-- FUNCTION : FindPpTemplate
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
-- REVIEWER :
--     DATE : xx/xx/20xx
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- xx/xx/20xx | RS        | Created
-- 29/03/2016 | AF        | Handle the extra argument in FindSpecTypeTemplate
-- 28/04/2016 | AF        | Situation could be handled where the PP has no
--                          parameters so an outer join with utpppr is added
--                          to cursor lvq_template
-- 28/04/2016 | AF        | A Template can only be used when the pp template is
--                          current
--------------------------------------------------------------------------------
FUNCTION FindPpTemplate (avs_pp            IN APAOGEN.PP_TYPE,
                         avs_pp_version    IN APAOGEN.VERSION_TYPE,
                         avs_pp_key1       IN VARCHAR2,
                         avs_pp_key2       IN VARCHAR2,
                         avs_pp_key3       IN VARCHAR2,
                         avs_pp_key4       IN VARCHAR2,
                         avs_pp_key5       IN VARCHAR2)
RETURN Template_Type IS

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.FindPpTemplate';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_spectype(avs_pp_key1            IN VARCHAR2) IS
SELECT st, version
  FROM utst
 WHERE st = avs_pp_key1
   AND version_is_current = 1 -- current version
 UNION
SELECT st, version
  FROM utst
 WHERE st = avs_pp_key1       -- or highest version
 ORDER BY version desc;

CURSOR lvq_template(avs_st            IN VARCHAR2,
                    avs_st_version    IN VARCHAR2,
                    avs_pp            IN VARCHAR2,
                    avs_pp_key1       IN VARCHAR2,
                    avs_pp_key2       IN VARCHAR2,
                    avs_pp_key3       IN VARCHAR2,
                    avs_pp_key4       IN VARCHAR2,
                    avs_pp_key5       IN VARCHAR2) IS
  SELECT b.pp, b.version, b.pp_key1, b.pp_key2, b.pp_key3, b.pp_key4, b.pp_key5
    FROM utstpp a, utpp b, utpppr c
   WHERE a.st = avs_st AND a.version = avs_st_version
     AND a.pp = avs_pp
     AND b.pp_key1 = avs_pp_key1 AND b.pp_key2 = avs_pp_key2 AND b.pp_key3 = avs_pp_key3 AND b.pp_key4 = avs_pp_key4 AND b.pp_key5 = avs_pp_key5
     AND b.version_is_current = '1'
     AND a.pp = b.pp AND b.pp = c.pp(+) AND b.version = c.version(+)
     AND b.pp_key1 = c.pp_key1(+) AND b.pp_key2 = c.pp_key2(+) AND b.pp_key3 = c.pp_key3(+) AND b.pp_key4 = c.pp_key4(+) AND b.pp_key5 = c.pp_key5(+);

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_template_st            Template_Type;
lvs_template_pp            Template_Type;
lvs_previous_major_version APAOGEN.VERSION_TYPE;
lvs_spectype               VARCHAR2(40);
lvb_correct_config         BOOLEAN;

BEGIN

   FOR lvr_spectype IN lvq_spectype(avs_pp_key1) LOOP

      lvs_spectype    := APAOACTION.GETSTSPECTYPE(lvr_spectype.st, lvr_spectype.version);
      lvs_template_st := APAOACTION.FINDSPECTYPETEMPLATE(lvr_spectype.st, lvr_spectype.version, lvs_spectype, lvb_correct_config);

      FOR lvr_template IN lvq_template(lvs_template_st.template, lvs_template_st.version,
                                       avs_pp,
                                       lvs_template_st.template, avs_pp_key2, avs_pp_key3, avs_pp_key4, avs_pp_key5) LOOP


         lvs_template_pp.template := lvr_template.pp;
         lvs_template_pp.version  := lvr_template.version;
         lvs_template_pp.pp_key1  := lvr_template.pp_key1;
         lvs_template_pp.pp_key2  := lvr_template.pp_key2;
         lvs_template_pp.pp_key3  := lvr_template.pp_key3;
         lvs_template_pp.pp_key4  := lvr_template.pp_key4;
         lvs_template_pp.pp_key5  := lvr_template.pp_key5;

      END LOOP;

      RETURN lvs_template_pp;

   END LOOP;

   RETURN lvs_template_pp;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN NULL;

END FindPpTemplate;

FUNCTION FindPrTemplate (avs_pr            IN APAOGEN.PR_TYPE,
                         avs_pr_version    IN APAOGEN.VERSION_TYPE )
RETURN Template_Type IS

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.FindPrTemplate';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_pr(avs_pr IN VARCHAR2, avs_pr_version IN VARCHAR2) IS
  SELECT b.pr, b.version
    FROM utprau a, utpr b
   WHERE b.pr != avs_pr
     AND a.pr =b.pr AND a.version = b.version
     AND a.value IN (SELECT value
                     FROM utprau
                    WHERE pr = avs_pr
                      AND version = avs_pr_version)
      AND au = 'interspec_orig_name'
      AND b.version_is_current = 1
ORDER BY b.pr, b.version desc;
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_template   Template_Type;

BEGIN

   FOR lvr_pr IN lvq_pr(avs_pr, avs_pr_version) LOOP
      lvs_template.template := lvr_pr.pr;
      lvs_template.version  := lvr_pr.version;
      RETURN lvs_template;
   END LOOP;

   RETURN lvs_template;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN NULL;

END FindPrTemplate;

FUNCTION StCreateMinor(avs_st                 IN APAOGEN.ST_TYPE,
                       avs_st_version         IN APAOGEN.VERSION_TYPE,
                       avs_st_new_version    OUT APAOGEN.VERSION_TYPE,
                       avs_modify_reason      IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.StCreateMinor';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_st               APAOGEN.ST_TYPE;
lvs_st_new_version   APAOGEN.VERSION_TYPE;
lvi_ret_code          APAOGEN.RETURN_TYPE;

BEGIN
    --------------------------------------------------------------------------------
    -- new st = old st
    --------------------------------------------------------------------------------
    lvs_st := avs_st;
    --------------------------------------------------------------------------------
    -- determine new minor version
    --------------------------------------------------------------------------------
    lvs_st_new_version := avs_st_version;
    lvi_ret_code := UNVERSION.GetNextMinorVersion(lvs_st_new_version);
    --------------------------------------------------------------------------------
    -- if succesfull create new minor version
    --------------------------------------------------------------------------------
    IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
       lvi_ret_code := Unapist.COPYSAMPLETYPE (avs_st,
                                               avs_st_version,
                                               lvs_st,
                                               lvs_st_new_version,
                                               avs_modify_reason);
       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
          APAOGEN.LogError (lcs_function_name, 'Creation of new minor revision <' || lvs_st_new_version || '> of st <' || avs_st || '> failed. Function returned <' || lvi_ret_code || '>');
       ELSE
          avs_st_new_version := lvs_st_new_version;
       END IF;

    END IF;

    RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END StCreateMinor;

FUNCTION PpCreateMinor(avs_pp                 IN APAOGEN.PP_TYPE,
                       avs_pp_version         IN APAOGEN.VERSION_TYPE,
                       avs_pp_key1            IN VARCHAR2,
                       avs_pp_key2            IN VARCHAR2,
                       avs_pp_key3            IN VARCHAR2,
                       avs_pp_key4            IN VARCHAR2,
                       avs_pp_key5            IN VARCHAR2,
                       avs_pp_new_version    OUT APAOGEN.VERSION_TYPE,
                       avs_modify_reason      IN APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.PpCreateMinor';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code          APAOGEN.RETURN_TYPE;
lvs_pp               APAOGEN.PP_TYPE;
lvs_pp_new_version   APAOGEN.VERSION_TYPE;
lvs_pp_key1          VARCHAR2(20);
lvs_pp_key2          VARCHAR2(20);
lvs_pp_key3          VARCHAR2(20);
lvs_pp_key4          VARCHAR2(20);
lvs_pp_key5          VARCHAR2(20);
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

BEGIN
    --------------------------------------------------------------------------------
    -- new pp = old pp
    --------------------------------------------------------------------------------
    lvs_pp        := avs_pp;
    lvs_pp_key1   := avs_pp_key1;
    lvs_pp_key2   := avs_pp_key2;
    lvs_pp_key3   := avs_pp_key3;
    lvs_pp_key4   := avs_pp_key4;
    lvs_pp_key5   := avs_pp_key5;
    --------------------------------------------------------------------------------
    -- determine new minor version
    --------------------------------------------------------------------------------
    lvs_pp_new_version := avs_pp_version;
    lvi_ret_code := UNVERSION.GetNextMinorVersion(lvs_pp_new_version);
    --------------------------------------------------------------------------------
    -- if succesfull create new minor version
    --------------------------------------------------------------------------------
    IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
       lvi_ret_code := UNAPIPP.CopyParameterProfile(avs_pp,
                                                    avs_pp_version,
                                                    avs_pp_key1,
                                                    avs_pp_key2,
                                                    avs_pp_key3,
                                                    avs_pp_key4,
                                                    avs_pp_key5,
                                                    lvs_pp,
                                                    lvs_pp_new_version,
                                                    lvs_pp_key1,
                                                    lvs_pp_key2,
                                                    lvs_pp_key3,
                                                    lvs_pp_key4,
                                                    lvs_pp_key5,
                                                    avs_modify_reason);

       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
          APAOGEN.LogError (lcs_function_name, 'Creation of new minor revision <' || lvs_pp_new_version || '> of pp <' || avs_pp || '> failed. Function returned <' || lvi_ret_code || '>');
       ELSE
          avs_pp_new_version := lvs_pp_new_version;
       END IF;

    END IF;

    RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END PpCreateMinor;

FUNCTION PrCreateMinor(avs_pr                 IN     APAOGEN.PR_TYPE,
                       avs_pr_version         IN     APAOGEN.VERSION_TYPE,
                       avs_tmp                IN     APAOGEN.PR_TYPE,
                       avs_pr_new_version     IN OUT APAOGEN.VERSION_TYPE,
                       avs_modify_reason      IN     APAOGEN.MODIFY_REASON_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.PrCreateMinor';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_pr               APAOGEN.PR_TYPE;
lvs_pr_new_version   APAOGEN.VERSION_TYPE;
lvi_ret_code          APAOGEN.RETURN_TYPE;

BEGIN
    --------------------------------------------------------------------------------
    -- determine new minor version
    --------------------------------------------------------------------------------
    lvs_pr_new_version := avs_pr_version;
    lvi_ret_code := UNVERSION.GetNextMinorVersion(lvs_pr_new_version);
    --------------------------------------------------------------------------------
    -- if succesfull create new minor version
    --------------------------------------------------------------------------------
    IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN

       lvs_pr:= avs_tmp;

       lvi_ret_code := Unapipr.COPYPARAMETER (avs_pr,
                                              avs_pr_version,
                                              lvs_pr,
                                              lvs_pr_new_version,
                                              avs_modify_reason);
       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
          APAOGEN.LogError (lcs_function_name, 'Creation of new minor revision <' || lvs_pr_new_version || '> of pr <' || avs_pr || '> failed. Function returned <' || lvi_ret_code || '>');
       ELSE
          avs_pr_new_version := lvs_pr_new_version;
       END IF;

    END IF;

    RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END PrCreateMinor;

--------------------------------------------------------------------------------
-- FUNCTION : StApplyTemplate
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
-- REVIEWER :
--     DATE : xx/xx/20xx
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- xx/xx/20xx | RS        | Created
-- 29/03/2016 | AF        | Removed the RemAuFromSt
-- 29/03/2016 | AF        | Handle the extra argument in FindSpecTypeTemplate
--------------------------------------------------------------------------------
FUNCTION StApplyTemplate(avs_st                 IN APAOGEN.ST_TYPE,
                         avs_st_version         IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.StApplyTemplate';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code	      APAOGEN.RETURN_TYPE;
lvr_template         Template_Type;
lvs_st_new_version   APAOGEN.VERSION_TYPE;
lvs_modify_reason    APAOGEN.MODIFY_REASON_TYPE;
lvs_description      VARCHAR2(40);
lvs_spectype         VARCHAr2(40);
lvb_correct_config   BOOLEAN;

BEGIN

   --------------------------------------------------------------------------------
   -- Find the spectype
   --------------------------------------------------------------------------------
   lvs_spectype := APAOACTION.GetStSpecType (avs_st, avs_st_version);
   --------------------------------------------------------------------------------
   -- Find the template
   --------------------------------------------------------------------------------
   lvr_template := APAOACTION.FindSpecTypeTemplate ( avs_st, avs_st_version, lvs_spectype, lvb_correct_config);

   IF lvr_template.template IS NULL THEN
      APAOGEN.LogError (lcs_function_name, 'No st-template found for <' || avs_st || '[' || avs_st_version || ']>');
      RETURN UNAPIGEN.DBERR_NOOBJECT;
   END IF;

   --------------------------------------------------------------------------------
   -- Create a new minor version
   --------------------------------------------------------------------------------
   lvs_modify_reason := 'Version created by <' || lcs_function_name || '> based on template ' || lvr_template.template || '[' || lvr_template.version || ']';
   lvi_ret_code := APAOACTION.StCreateMinor (avs_st, avs_st_version, lvs_st_new_version, lvs_modify_reason);
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Could not create new minor version for <' || avs_st || '[' || avs_st_version || ']>');
      RETURN lvi_ret_code;
   END IF;

   --------------------------------------------------------------------------------
   -- Synchronize st-attributes
   --------------------------------------------------------------------------------
   lvi_ret_code := SynchronizeStAu(avs_st, lvs_st_new_version, lvr_template, 'Synchronized by <' || lcs_function_name || '> based on template ' || lvr_template.template || '[' || lvr_template.version || ']');
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Could not synchronize stau for <' || avs_st || '[' || avs_st_version || ']> Function returned <' || lvi_ret_code || '>');
      RETURN lvi_ret_code;
   END IF;
   --------------------------------------------------------------------------------
   -- Synchronize st-groupkeys
   --------------------------------------------------------------------------------
   lvi_ret_code := SynchronizeStGk(avs_st, lvs_st_new_version, lvr_template, 'Synchronized by <' || lcs_function_name || '> based on template ' || lvr_template.template || '[' || lvr_template.version || ']');
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS AND lvi_ret_code != UNAPIGEN.DBERR_NOOBJECT THEN
      APAOGEN.LogError (lcs_function_name, 'Could not synchronize stgk for <' || avs_st || '[' || avs_st_version || ']> Function returned <' || lvi_ret_code || '>');
      RETURN lvi_ret_code;
   END IF;
   --------------------------------------------------------------------------------
   -- Synchronize stpp
   --------------------------------------------------------------------------------
   lvi_ret_code := SynchronizeStPp(avs_st, lvs_st_new_version, lvr_template, 'Synchronized by <' || lcs_function_name || '> based on template ' || lvr_template.template || '[' || lvr_template.version || '] pp_key1=' || lvr_template.pp_key1);
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS AND lvi_ret_code != UNAPIGEN.DBERR_NOOBJECT THEN
      APAOGEN.LogError (lcs_function_name, 'Could not synchronize stpp for <' || avs_st || '[' || avs_st_version || ']> Function returned <' || lvi_ret_code || '>');
      RETURN lvi_ret_code;
   END IF;
   --------------------------------------------------------------------------------
   -- Synchronize stpp freq
   --------------------------------------------------------------------------------
   lvi_ret_code := SynchronizeStPpFreq(avs_st, lvs_st_new_version, lvr_template.template, lvr_template.version);
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS AND lvi_ret_code != UNAPIGEN.DBERR_NOOBJECT THEN
      APAOGEN.LogError (lcs_function_name, 'Could not synchronize stpp freq for <' || avs_st || '[' || lvs_st_new_version || ']> Function returned <' || lvi_ret_code || '>');
      RETURN lvi_ret_code;
   END IF;
   --------------------------------------------------------------------------------
   -- Synchronize stip
   --------------------------------------------------------------------------------
   lvi_ret_code := SynchronizeStIp(avs_st, lvs_st_new_version, lvr_template, 'Synchronized by <' || lcs_function_name || '> based on template ' || lvr_template.template || '[' || lvr_template.version || '] pp_key1=' || lvr_template.pp_key1);
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS AND lvi_ret_code != UNAPIGEN.DBERR_NOOBJECT THEN
      APAOGEN.LogError (lcs_function_name, 'Could not synchronize stip for <' || avs_st || '[' || avs_st_version || ']>');
      RETURN lvi_ret_code;
   END IF;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END StApplyTemplate;

--------------------------------------------------------------------------------
-- FUNCTION : PpApplyTemplate
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
-- REVIEWER :
--     DATE : xx/xx/20xx
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- xx/xx/20xx | RS        | Created
-- 29/03/2016 | AF        | Removed the RemAuFromPp
--------------------------------------------------------------------------------
FUNCTION PpApplyTemplate(avs_pp            IN APAOGEN.PP_TYPE,
                         avs_pp_version    IN APAOGEN.VERSION_TYPE,
                         avs_pp_key1       IN VARCHAR2,
                         avs_pp_key2       IN VARCHAR2,
                         avs_pp_key3       IN VARCHAR2,
                         avs_pp_key4       IN VARCHAR2,
                         avs_pp_key5       IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.PpApplyTemplate';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code	      APAOGEN.RETURN_TYPE;
lvr_template         Template_Type;
lvs_pp_new_version   APAOGEN.VERSION_TYPE;
lvs_modify_reason    APAOGEN.MODIFY_REASON_TYPE;
lvs_description      VARCHAR2(40);

BEGIN

    --------------------------------------------------------------------------------
    -- Find the template
    --------------------------------------------------------------------------------
    lvr_template := APAOACTION.FindPpTemplate(avs_pp, avs_pp_version,
                                              avs_pp_key1,
                                              avs_pp_key2,
                                              avs_pp_key3,
                                              avs_pp_key4,
                                              avs_pp_key5);

    IF lvr_template.template IS NULL THEN
       APAOGEN.LogError (lcs_function_name, 'No pp-template found for <' || avs_pp || '[' || avs_pp_version || ']> pp_key1=' || avs_pp_key1);
       RETURN UNAPIGEN.DBERR_NOOBJECT;
    END IF;

    --------------------------------------------------------------------------------
    -- Create a new minor version
    --------------------------------------------------------------------------------
    lvs_modify_reason := 'Version created by <' || lcs_function_name || '> based on template ' || lvr_template.template || '[' || lvr_template.version || '] pp_key1=' || lvr_template.pp_key1;
    lvi_ret_code := APAOACTION.PpCreateMinor(avs_pp, avs_pp_version,
                                             avs_pp_key1,
                                             avs_pp_key2,
                                             avs_pp_key3,
                                             avs_pp_key4,
                                             avs_pp_key5,
                                             lvs_pp_new_version, lvs_modify_reason);
    IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
       APAOGEN.LogError (lcs_function_name, 'Could not create new minor version for <' || avs_pp || '[' || avs_pp_version || ']>');
       RETURN lvi_ret_code;
    END IF;
    --------------------------------------------------------------------------------
    -- Synchronize pp-attributes
    --------------------------------------------------------------------------------
    lvi_ret_code := SynchronizePpAu(avs_pp, lvs_pp_new_version,
                                    avs_pp_key1,
                                    avs_pp_key2,
                                    avs_pp_key3,
                                    avs_pp_key4,
                                    avs_pp_key5,
                                    lvr_template,
                                    'Synchronized by <' || lcs_function_name || '> based on template ' || lvr_template.template || '[' || lvr_template.version || '] pp_key1=' || lvr_template.pp_key1);
    IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
       APAOGEN.LogError (lcs_function_name, 'Could not synchronize ppau for <' || avs_pp || '[' || avs_pp_version || ']> Function returned <' || lvi_ret_code || '>');
       RETURN lvi_ret_code;
    END IF;
    --------------------------------------------------------------------------------
    -- Synchronize pp-parameters
    --------------------------------------------------------------------------------
    lvi_ret_code := SynchronizePpPr(avs_pp, lvs_pp_new_version,
                                    avs_pp_key1,
                                    avs_pp_key2,
                                    avs_pp_key3,
                                    avs_pp_key4,
                                    avs_pp_key5,
                                    lvr_template,
                                    'Synchronized by <' || lcs_function_name || '> based on template ' || lvr_template.template || '[' || lvr_template.version || '] pp_key1=' || lvr_template.pp_key1);
    IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
       APAOGEN.LogError (lcs_function_name, 'Could not synchronize pppr for <' || avs_pp || '[' || avs_pp_version || ']> Function returned <' || lvi_ret_code || '>');
       RETURN lvi_ret_code;
    END IF;

    RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END PpApplyTemplate;

FUNCTION PrApplyTemplate(avs_pr                 IN APAOGEN.PR_TYPE,
                         avs_pr_version         IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.PrApplyTemplate';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code          APAOGEN.RETURN_TYPE;
lvr_template         Template_Type;
lvs_pr_new_version   APAOGEN.VERSION_TYPE;
lvs_modify_reason    APAOGEN.MODIFY_REASON_TYPE;
lvs_description      VARCHAR2(40);

BEGIN

    --------------------------------------------------------------------------------
    -- Find the template
    --------------------------------------------------------------------------------
    lvr_template := APAOACTION.FindPrTemplate ( avs_pr, avs_pr_version);

    IF lvr_template.template IS NULL THEN
       APAOGEN.LogError (lcs_function_name, 'No pr-template found for <' || avs_pr || '[' || avs_pr_version || ']>');
       RETURN UNAPIGEN.DBERR_NOOBJECT;
    END IF;

    lvs_modify_reason := 'Version created by <' || lcs_function_name || '> based on template ' || lvr_template.template || '[' || lvr_template.version || '] pp_key1=' || lvr_template.pp_key1;
    lvs_pr_new_version := avs_pr_version;

    --------------------------------------------------------------------------------
    -- Create a new minor version
    --------------------------------------------------------------------------------
    lvi_ret_code := APAOACTION.PrCreateMinor (lvr_template.template, lvr_template.version, avs_pr, lvs_pr_new_version, lvs_modify_reason);
    IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
       APAOGEN.LogError (lcs_function_name, 'Could not create new minor version for <' || avs_pr || '[' || avs_pr_version || ']>');
       RETURN lvi_ret_code;
    END IF;

    --------------------------------------------------------------------------------
    -- Get description from current pr
    --------------------------------------------------------------------------------
    SELECT NVL(MAX(description), '-')
      INTO lvs_description
      FROM utpr
     WHERE pr = avs_pr
       AND version = avs_pr_version;

    --------------------------------------------------------------------------------
    -- Set description to new minor
    --------------------------------------------------------------------------------
    UPDATE utpr
       SET description = lvs_description
     WHERE pr = avs_pr
       AND version = lvs_pr_new_version;

    IF SQL%ROWCOUNT != 1 THEN
       APAOGEN.LogError (lcs_function_name, 'Could not synchronize description of parameter ' || avs_pr || '[' || avs_pr_version || '] to <' || avs_pr || '[' || lvs_pr_new_version || ']>');
       RETURN UNAPIGEN.DBERR_NOTFOUND;
    END IF;

    RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END PrApplyTemplate;


FUNCTION StTriggerAllPps(avs_st                 IN APAOGEN.ST_TYPE,
                         avs_st_version         IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.StTriggerAllPps';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_pp(avs_st          IN APAOGEN.ST_TYPE,
              avs_st_version  IN APAOGEN.VERSION_TYPE,
              avs_ss          IN APAOGEN.SS_TYPE) IS
 SELECT b.*
   FROM utstpp a, utpp b
  WHERE a.st = avs_st
    AND a.version = avs_st_version
    AND a.pp = b.pp
    AND a.pp_key1 = b.pp_key1
    AND a.pp_key2 = b.pp_key2
    AND a.pp_key3 = b.pp_key3
    AND a.pp_key4 = b.pp_key4
    AND a.pp_key5 = b.pp_key5
    AND UNAPIGEN.UsePpVersion(a.pp, a.pp_version, a.pp_key1, a.pp_key2, a.pp_key3, a.pp_key4, a.pp_key5) = b.version
    AND b.ss != avs_ss;
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code             APAOGEN.RETURN_TYPE;
lvs_ss                  APAOGEN.SS_TYPE;
lvs_modify_reason       APAOGEN.MODIFY_REASON_TYPE;

BEGIN

   SELECT NVL(MAX(ss), '-')
     INTO lvs_ss
     FROM utst
    WHERE st = avs_st
      AND version = avs_st_version;

   IF lvs_ss != '-' THEN

      lvs_modify_reason := 'Status changed by ' || lcs_function_name;

      FOR lvr_pp IN lvq_pp(avs_st, avs_st_version, lvs_ss) LOOP
         lvi_ret_code := UNAPIPPP.CHANGEPPSTATUS( lvr_pp.pp,
                                                  lvr_pp.version,
                                                  lvr_pp.pp_key1,
                                                  lvr_pp.pp_key2,
                                                  lvr_pp.pp_key3,
                                                  lvr_pp.pp_key4,
                                                  lvr_pp.pp_key5,
                                                  lvr_pp.ss,
                                                  lvs_ss,
                                                  lvr_pp.lc,
                                                  lvr_pp.lc_version,
                                                  lvs_modify_reason);

         IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
            APAOGEN.LogError (lcs_function_name, 'Could not change status for <' || lvr_pp.pp || '[' || lvr_pp.version || ']> into <' || lvs_ss || '>');
         END IF;

      END LOOP;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END StTriggerAllPps;

FUNCTION PpTriggerSt (avs_pp            IN APAOGEN.PP_TYPE,
                      avs_pp_version    IN APAOGEN.VERSION_TYPE,
                      avs_pp_key1       IN VARCHAR2,
                      avs_pp_key2       IN VARCHAR2,
                      avs_pp_key3       IN VARCHAR2,
                      avs_pp_key4       IN VARCHAR2,
                      avs_pp_key5       IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.PpTriggerSt';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_st(avs_pp            IN APAOGEN.PP_TYPE,
              avs_pp_version    IN APAOGEN.VERSION_TYPE,
              avs_pp_key1       IN VARCHAR2,
              avs_pp_key2       IN VARCHAR2,
              avs_pp_key3       IN VARCHAR2,
              avs_pp_key4       IN VARCHAR2,
              avs_pp_key5       IN VARCHAR2,
              avs_ss            IN VARCHAR2) IS
 SELECT c.*
   FROM utstpp a, utpp b, utst c
  WHERE b.pp = avs_pp AND b.version = avs_pp_version
    AND b.pp_key1 = avs_pp_key1 AND b.pp_key2 = avs_pp_key2 AND b.pp_key3 = avs_pp_key3 AND b.pp_key4 = avs_pp_key4 AND b.pp_key5 = avs_pp_key5
    AND a.pp = b.pp
    AND a.pp_key1 = b.pp_key1
    AND a.pp_key2 = b.pp_key2
    AND a.pp_key3 = b.pp_key3
    AND a.pp_key4 = b.pp_key4
    AND a.pp_key5 = b.pp_key5
    AND UNAPIGEN.UsePpVersion(a.pp, a.pp_version, a.pp_key1, a.pp_key2, a.pp_key3, a.pp_key4, a.pp_key5) = b.version
    AND c.ss != avs_ss
    AND a.st = c.st
    AND a.version = c.version;

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code             APAOGEN.RETURN_TYPE;
lvs_ss                  APAOGEN.SS_TYPE;
lvs_modify_reason       APAOGEN.MODIFY_REASON_TYPE;
lvi_count               NUMBER;
BEGIN

   SELECT NVL(MAX(ss), '-')
     INTO lvs_ss
     FROM utpp
    WHERE pp = avs_pp
      AND version = avs_pp_version
      AND pp_key1 = avs_pp_key1 AND pp_key2 = avs_pp_key2 AND pp_key3 = avs_pp_key3 AND pp_key4 = avs_pp_key4 AND pp_key5 = avs_pp_key5;

   IF lvs_ss != '-' THEN

      lvs_modify_reason := 'Status changed by ' || lcs_function_name;

      FOR lvr_st IN lvq_st(avs_pp, avs_pp_version, avs_pp_key1, avs_pp_key2, avs_pp_key3, avs_pp_key4, avs_pp_key5, lvs_ss) LOOP

       SELECT count(*)
         INTO lvi_count
         FROM utstpp a, utpp b
        WHERE a.st = lvr_st.st
          AND a.version = lvr_st.version
          AND a.pp = b.pp
          AND a.pp_key1 = b.pp_key1
          AND a.pp_key2 = b.pp_key2
          AND a.pp_key3 = b.pp_key3
          AND a.pp_key4 = b.pp_key4
          AND a.pp_key5 = b.pp_key5
          AND UNAPIGEN.UsePpVersion(a.pp, a.pp_version, a.pp_key1, a.pp_key2, a.pp_key3, a.pp_key4, a.pp_key5) = b.version
          AND b.ss != lvs_ss;

         IF lvi_count = 0 THEN

            lvi_ret_code := UNAPIPRP.ChangeObjectStatus('st',
                                                        lvr_st.st,
                                                        lvr_st.version,
                                                        lvr_st.ss,
                                                        lvs_ss,
                                                        lvr_st.lc,
                                                        lvr_st.lc_version,
                                                        lvs_modify_reason);

            IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
               APAOGEN.LogError (lcs_function_name, 'Could not change status for <' || lvr_st.st || '[' || lvr_st.version || ']> into <' || lvs_ss || '>');
            END IF;
         END IF;

      END LOOP;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END PpTriggerSt;

FUNCTION StPpApplyInterspecFreq(avs_st                 IN APAOGEN.ST_TYPE,
                                avs_st_version         IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Cursor
--------------------------------------------------------------------------------
CURSOR lvq_deliver(avs_part_no  IN VARCHAR2,
                   avn_revision IN NUMBER) IS
SELECT *
  FROM AVAO_INTERSPEC_STPP_FREQ
 WHERE part_no = avs_part_no
   AND revision = avn_revision
   AND limsheader = 'Deliver to'
   AND value = 'laboratory';

CURSOR lvq_freq_tp(avs_part_no  IN VARCHAR2,
                   avn_revision IN NUMBER,
                   avs_section  IN VARCHAR2,
                   avs_propertygroup IN VARCHAR2,
                   avs_property IN VARCHAR2) IS
SELECT *
  FROM AVAO_INTERSPEC_STPP_FREQ
 WHERE part_no = avs_part_no
   AND revision = avn_revision
   AND section = avs_section
   AND propertygroup = avs_propertygroup
   AND property = avs_property
   AND limsheader = 'freq_tp/freq_unit'; --'Interval type';

CURSOR lvq_freq_val(avs_part_no  IN VARCHAR2,
                    avn_revision IN NUMBER,
                    avs_section  IN VARCHAR2,
                    avs_propertygroup IN VARCHAR2,
                    avs_property IN VARCHAR2) IS
SELECT *
  FROM AVAO_INTERSPEC_STPP_FREQ
 WHERE part_no = avs_part_no
   AND revision = avn_revision
   AND section = avs_section
   AND propertygroup = avs_propertygroup
   AND property = avs_property
   AND limsheader = 'freq_val'; --'Sampling interval';

CURSOR lvq_freq_unit(avs_freq_unit IN VARCHAR2) IS
SELECT *
  FROM ATAO_IS_FREQ_CONV
 WHERE IS_FREQ_TP_FREQ_UNIT = avs_freq_unit
   AND OBJECTLINK = 'STPP';

CURSOR lvq_stpp(avs_st            IN APAOGEN.PP_TYPE,
                avs_st_version    IN APAOGEN.VERSION_TYPE) IS
SELECT pp
  FROM utstpp
 WHERE st = avs_st AND version = avs_st_version
   AND freq_tp = 'C' AND freq_unit = 'ScPgInterspec';
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.StPpApplyInterspecFreq';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code          APAOGEN.RETURN_TYPE;
lvs_modify_reason    APAOGEN.MODIFY_REASON_TYPE;
lvi_revision         NUMBER;
lvs_st_new_version   APAOGEN.VERSION_TYPE;

BEGIN

   --------------------------------------------------------------------------------
   -- Get Interspec revision of current Unilab version
   --------------------------------------------------------------------------------
   lvi_revision := APAOACTION.CONVERTUNILAB2INTERSPEC(avs_st_version);
   IF lvi_revision IS NULL THEN
      APAOGEN.LogError (lcs_function_name, 'Could not convert Unilab version <' || avs_st_version || '> into Interspec revision');
      RETURN UNAPIGEN.DBERR_GENFAIL;
   END IF;

   --------------------------------------------------------------------------------
   -- Create a new minor version
   --------------------------------------------------------------------------------
   lvs_modify_reason := 'Version created by <' || lcs_function_name || '> based on ' || avs_St || '[' || avs_st_version || ']';
   lvi_ret_code := APAOACTION.StCreateMinor (avs_st, avs_st_version, lvs_st_new_version, lvs_modify_reason);
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Could not create new minor version for <' || avs_st || '[' || avs_st_version || ']>');
      RETURN lvi_ret_code;
   END IF;

   --------------------------------------------------------------------------------
   -- Loop through Interspec properties for LIMS-header 'Deliver to' with value laboratory
   --------------------------------------------------------------------------------
   FOR lvr_deliver IN lvq_deliver(avs_st, lvi_revision) LOOP
      --------------------------------------------------------------------------------
      -- Loop through Interspec properties for LIMS-header 'Interval type'
      --------------------------------------------------------------------------------
      FOR lvr_freq_tp IN lvq_freq_tp(lvr_deliver.part_no,
                                     lvr_deliver.revision,
                                     lvr_deliver.section,
                                     lvr_deliver.propertygroup,
                                     lvr_deliver.property
                                     ) LOOP
         --------------------------------------------------------------------------------
         -- Find frequency mapping for value found
         --------------------------------------------------------------------------------
         FOR lvr_freq_unit IN lvq_freq_unit(lvr_freq_tp.value) LOOP
            FOR lvr_stpp IN lvq_stpp(avs_st,
                                     avs_st_version) LOOP
               --------------------------------------------------------------------------------
               -- Loop through Interspec properties for LIMS-header 'Sampling interval'
               --------------------------------------------------------------------------------
               FOR lvr_freq_val IN lvq_freq_val(lvr_deliver.part_no,
                                                lvr_deliver.revision,
                                                lvr_deliver.section,
                                                lvr_deliver.propertygroup,
                                                lvr_deliver.property
                                                ) LOOP
                  --------------------------------------------------------------------------------
                  -- Synchronize frequencies
                  --------------------------------------------------------------------------------
                  UPDATE utstpp
                     SET freq_val = lvr_freq_val.value,
                         freq_tp  = lvr_freq_unit.freq_tp,
                         freq_unit = lvr_freq_unit.freq_unit
                   WHERE st = avs_st
                     AND version = lvs_st_new_version
                     AND pp = lvr_stpp.pp;

                   IF SQL%ROWCOUNT != 0 THEN
                      lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
                   ELSE
                      lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
                      APAOGEN.LogError (lcs_function_name, 'Could not apply Interspec frequencies for <' || avs_st || '[' || lvs_st_new_version || ']>');
                  END IF;
               END LOOP;
            END LOOP;
         END LOOP;

      END LOOP;
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END StPpApplyInterspecFreq;

FUNCTION PpPrApplyInterspecFreq(avs_pp            IN APAOGEN.PP_TYPE,
                                avs_pp_version    IN APAOGEN.VERSION_TYPE,
                                avs_pp_key1       IN VARCHAR2,
                                avs_pp_key2       IN VARCHAR2,
                                avs_pp_key3       IN VARCHAR2,
                                avs_pp_key4       IN VARCHAR2,
                                avs_pp_key5       IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Cursor
--------------------------------------------------------------------------------
CURSOR lvq_deliver(avs_part_no  IN VARCHAR2,
                   avn_revision IN NUMBER) IS
SELECT *
  FROM AVAO_INTERSPEC_PPPR_FREQ
 WHERE part_no = avs_part_no
   AND revision = avn_revision
   AND limsheader = 'Responsibility'
   AND value = 'laboratory';

CURSOR lvq_freq_tp(avs_part_no         IN VARCHAR2,
                     avn_revision        IN NUMBER,
                     avs_section         IN VARCHAR2,
                     avs_propertygroup   IN VARCHAR2,
                     avs_property        IN VARCHAR2) IS
SELECT *
  FROM AVAO_INTERSPEC_PPPR_FREQ
 WHERE part_no = avs_part_no
   AND revision = avn_revision
   AND section = avs_section
   AND propertygroup = avs_propertygroup
   AND property = avs_property
   AND limsheader = 'freq_tp/freq_unit'; -- Samplingtype'

CURSOR lvq_freq_val(avs_part_no         IN VARCHAR2,
                    avn_revision        IN NUMBER,
                    avs_section         IN VARCHAR2,
                    avs_propertygroup   IN VARCHAR2,
                    avs_property        IN VARCHAR2) IS
SELECT *
  FROM AVAO_INTERSPEC_PPPR_FREQ
 WHERE part_no = avs_part_no
   AND revision = avn_revision
   AND section = avs_section
   AND propertygroup = avs_propertygroup
   AND property = avs_property
   AND limsheader = 'freq_val'; -- Sampling interval'

CURSOR lvq_sample_size(avs_part_no         IN VARCHAR2,
                       avn_revision        IN NUMBER,
                       avs_section         IN VARCHAR2,
                       avs_propertygroup   IN VARCHAR2,
                       avs_property        IN VARCHAR2) IS
SELECT *
  FROM AVAO_INTERSPEC_PPPR_FREQ
 WHERE part_no = avs_part_no
   AND revision = avn_revision
   AND section = avs_section
   AND propertygroup = avs_propertygroup
   AND property = avs_property
   AND limsheader = '#P'; -- Sampling size'


CURSOR lvq_freq_unit(avs_freq_unit IN VARCHAR2) IS
SELECT *
  FROM ATAO_IS_FREQ_CONV
 WHERE IS_FREQ_TP_FREQ_UNIT = avs_freq_unit
   AND OBJECTLINK = 'PPPR';

CURSOR lvq_pppr(avs_pp            IN APAOGEN.PP_TYPE,
                avs_pp_version    IN APAOGEN.VERSION_TYPE,
                avs_pp_key1       IN VARCHAR2,
                avs_pp_key2       IN VARCHAR2,
                avs_pp_key3       IN VARCHAR2,
                avs_pp_key4       IN VARCHAR2,
                avs_pp_key5       IN VARCHAR2,
                avs_test_method   IN VARCHAR2) IS
SELECT a.pp, a.version,
       a.pp_key1, a.pp_key2, a.pp_key3, a.pp_key4, a.pp_key5,
       b.pr, c.value test_method
  FROM utpppr a, utpr b, utprau c
 WHERE a.pp = avs_pp AND a.version = avs_pp_version
   AND a.pp_key1 = avs_pp_key1 AND a.pp_key2 = avs_pp_key2 AND a.pp_key3 = avs_pp_key3 AND a.pp_key4 = avs_pp_key4 AND a.pp_key5 = avs_pp_key5
   AND a.freq_tp = 'C' AND a.freq_unit = 'ScPaInterspec'
   AND a.pr = b.pr AND b.version_is_current = 1
   AND b.pr = c.pr AND b.version = c.version
   AND c.au = 'avTestMethod'
   AND c.value = avs_test_method;

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.PpPrApplyInterspecFreq';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code          APAOGEN.RETURN_TYPE;
lvs_modify_reason    APAOGEN.MODIFY_REASON_TYPE;
lvi_revision         NUMBER;
lvs_st               APAOGEN.ST_TYPE;
lvs_st_version       APAOGEN.VERSION_TYPE;
lvs_pp_new_version   APAOGEN.VERSION_TYPE;

BEGIN

   BEGIN
       SELECT st, version
         INTO lvs_st, lvs_st_version
         FROM utstpp
        WHERE pp = avs_pp
          AND version = avs_pp_version
          AND pp_key1 = avs_pp_key1 AND pp_key2 = avs_pp_key2 AND pp_key3 = avs_pp_key3 AND pp_key4 = avs_pp_key4 AND pp_key5 = avs_pp_key5;
   EXCEPTION
   WHEN OTHERS THEN
      --------------------------------------------------------------------------------
      -- If a pp has been assigned by custom code,the version/ pp_version might mismatch
      -- In that case there is no real problem. The pp will be ignorded by this function
      --------------------------------------------------------------------------------
      RETURN UNAPIGEN.DBERR_SUCCESS;
      --APAOGEN.LogError (lcs_function_name, 'No st found for pp =' || avs_pp || '[' || avs_pp_version || '] pp_key1=' || avs_pp_key1 || '#pp_key2=' || avs_pp_key2 || '#pp_key3=' || avs_pp_key3 || '#pp_key4=' || avs_pp_key4 || '#pp_key5=' || avs_pp_key5 || '.', FALSE, TRUE);
   END;

   --------------------------------------------------------------------------------
   -- Get Interspec revision of current Unilab version
   --------------------------------------------------------------------------------
   lvi_revision := APAOACTION.CONVERTUNILAB2INTERSPEC(lvs_st_version);
   IF lvi_revision IS NULL THEN
      APAOGEN.LogError (lcs_function_name, 'Could not convert Unilab version <' || lvs_st_version || '> into Interspec revision');
      RETURN UNAPIGEN.DBERR_GENFAIL;
   END IF;

   --------------------------------------------------------------------------------
   -- Create a new minor version
   --------------------------------------------------------------------------------
   lvs_modify_reason := 'Version created by <' || lcs_function_name || '> based on ' || avs_pp || '[' || avs_pp_version || '] pp_key1=' || avs_pp_key1;
   lvi_ret_code := APAOACTION.PpCreateMinor(avs_pp, avs_pp_version,
                                            avs_pp_key1,
                                            avs_pp_key2,
                                            avs_pp_key3,
                                            avs_pp_key4,
                                            avs_pp_key5,
                                            lvs_pp_new_version, lvs_modify_reason);
    IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
       APAOGEN.LogError (lcs_function_name, 'Could not create new minor version for <' || avs_pp || '[' || avs_pp_version || ']>');
       RETURN lvi_ret_code;
    END IF;

   --------------------------------------------------------------------------------
   -- First step: set sample based frequency default to 1
   --------------------------------------------------------------------------------
   UPDATE utpppr
      SET st_based_freq = 1
    WHERE pp = avs_pp AND version = lvs_pp_new_version
      AND pp_key1 = avs_pp_key1
      AND pp_key2 = avs_pp_key2
      AND pp_key3 = avs_pp_key3
      AND pp_key4 = avs_pp_key4
      AND pp_key5 = avs_pp_key5
      AND freq_tp NOT IN ('N', 'A');
   --------------------------------------------------------------------------------
   -- Loop through Interspec properties for LIMS-header 'Responsibility' with value laboratory
   --------------------------------------------------------------------------------
   FOR lvr_deliver IN lvq_deliver(lvs_st, lvi_revision) LOOP
      --------------------------------------------------------------------------------
      -- Loop through Interspec properties for LIMS-header 'Interval type'
      --------------------------------------------------------------------------------
      FOR lvr_freq_tp IN lvq_freq_tp(lvr_deliver.part_no,
                                     lvr_deliver.revision,
                                     lvr_deliver.section,
                                     lvr_deliver.propertygroup,
                                     lvr_deliver.property) LOOP
         --------------------------------------------------------------------------------
         -- Find frequency mapping
         --------------------------------------------------------------------------------
         FOR lvr_freq_unit IN lvq_freq_unit(lvr_freq_tp.value) LOOP
            --------------------------------------------------------------------------------
            -- Loop through Interspec properties for LIMS-header 'Sampling interval'
            --------------------------------------------------------------------------------
            FOR lvr_freq_val IN lvq_freq_val(lvr_deliver.part_no,
                                             lvr_deliver.revision,
                                             lvr_deliver.section,
                                             lvr_deliver.propertygroup,
                                             lvr_deliver.property
                                             ) LOOP
               --------------------------------------------------------------------------------
               -- Loop through Interspec properties for LIMS-header 'Sampling size'
               --------------------------------------------------------------------------------
               FOR lvr_sample_size IN lvq_sample_size(lvr_deliver.part_no,
                                                      lvr_deliver.revision,
                                                      lvr_deliver.section,
                                                      lvr_deliver.propertygroup,
                                                      lvr_deliver.property) LOOP
                  --------------------------------------------------------------------------------
                  -- Synchronize frequencies
                  --------------------------------------------------------------------------------
                  FOR lvr_pppr IN lvq_pppr(avs_pp, lvs_pp_new_version,
                                           avs_pp_key1,
                                           avs_pp_key2,
                                           avs_pp_key3,
                                           avs_pp_key4,
                                           avs_pp_key5,
                                           lvr_deliver.test_method) LOOP
                  UPDATE utpppr
                     SET freq_val = NVL(lvr_freq_val.value, 0),
                         freq_tp  = NVL(lvr_freq_unit.freq_tp, freq_tp),
                         freq_unit = NVL(lvr_freq_unit.freq_unit, freq_unit),
                         nr_measur = NVL(lvr_sample_size.value, nr_measur)
                   WHERE pp = lvr_pppr.pp AND version = lvr_pppr.version
                     AND pp_key1 = lvr_pppr.pp_key1 AND pp_key2 = lvr_pppr.pp_key2 AND pp_key3 = lvr_pppr.pp_key3 AND pp_key4 = lvr_pppr.pp_key4 AND pp_key5 = lvr_pppr.pp_key5
                     AND pr = lvr_pppr.pr AND pr_version = '~Current~';

                     IF SQL%ROWCOUNT != 0 THEN
                         lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
                     ELSE
                         lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
                         APAOGEN.LogError (lcs_function_name, 'Could not apply Interspec frequencies for <' || avs_pp || '[' || lvs_pp_new_version || ']>');
                     END IF;
                  END LOOP;
               END LOOP;
            END LOOP;
         END LOOP;
      END LOOP;
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END PpPrApplyInterspecFreq;

FUNCTION SyncPpPrFreqNotManual (avs_pp            IN APAOGEN.PP_TYPE,
                                avs_pp_version    IN APAOGEN.VERSION_TYPE,
                                avs_pp_key1       IN VARCHAR2,
                                avs_pp_key2       IN VARCHAR2,
                                avs_pp_key3       IN VARCHAR2,
                                avs_pp_key4       IN VARCHAR2,
                                avs_pp_key5       IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.SyncPpPrFreqNotManual';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_pppr (avs_pp            IN APAOGEN.PP_TYPE,
                 avs_pp_version    IN APAOGEN.VERSION_TYPE,
                 avs_pp_key1       IN VARCHAR2,
                 avs_pp_key2       IN VARCHAR2,
                 avs_pp_key3       IN VARCHAR2,
                 avs_pp_key4       IN VARCHAR2,
                 avs_pp_key5       IN VARCHAR2) IS
SELECT a.*
  FROM utpppr a, utpr b
 WHERE a.pp = avs_pp AND a.version = avs_pp_version
   AND a.pp_key1 = avs_pp_key1 AND a.pp_key2 = avs_pp_key2 AND a.pp_key3 = avs_pp_key3 AND a.pp_key4 = avs_pp_key4 AND a.pp_key5 = avs_pp_key5
   AND a.freq_tp = 'C' AND a.freq_unit != 'Manual'
   AND a.pr = b.pr AND b.version_is_current = 1;

lvr_template         Template_Type;
lvs_spectype         VARCHAR2(40);

BEGIN

   --------------------------------------------------------------------------------
   -- Find the template
   --------------------------------------------------------------------------------
   lvr_template := APAOACTION.FindPpTemplate(avs_pp, avs_pp_version,
                                             avs_pp_key1,
                                             avs_pp_key2,
                                             avs_pp_key3,
                                             avs_pp_key4,
                                             avs_pp_key5);

   IF lvr_template.template IS NULL THEN
      APAOGEN.LogError (lcs_function_name, 'No pp-template found for <' || avs_pp || '[' || avs_pp_version || ']>');
      RETURN UNAPIGEN.DBERR_NOOBJECT;
   END IF;
   ---------------------------------------------------------------------------------------------
   -- Assumption : If we do not find a custom frequency, always return success
   --              Otherwise return the success of the update statement
   ---------------------------------------------------------------------------------------------
   lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
   ---------------------------------------------------------------------------------------------
   -- Loop through all stpp's of template
   ---------------------------------------------------------------------------------------------
   FOR lvr_pppr IN lvq_pppr(lvr_template.template, lvr_template.version,
                            lvr_template.pp_key1, lvr_template.pp_key2, lvr_template.pp_key3, lvr_template.pp_key4, lvr_template.pp_key5) LOOP
       ---------------------------------------------------------------------------------------------
       -- Loop through all stpp's
       ---------------------------------------------------------------------------------------------
       UPDATE utpppr
          SET freq_tp      = lvr_pppr.freq_tp,
              freq_val     = NVL(lvr_pppr.freq_val, 0),
              freq_unit    = lvr_pppr.freq_unit,
              invert_freq  = lvr_pppr.invert_freq
        WHERE pp = avs_pp AND version = avs_pp_version
          AND pp_key1 = avs_pp_key1 AND pp_key2 = avs_pp_key2 AND pp_key3 = avs_pp_key3 AND pp_key4 = avs_pp_key4 AND pp_key5 = avs_pp_key5
          AND pr = lvr_pppr.pr AND pr_version = '~Current~';

       IF SQL%ROWCOUNT != 0 THEN
          lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
       ELSE
          lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
          APAOGEN.LogError (lcs_function_name, 'Could not synchronize pppr frequency for <' || avs_pp || '[' || avs_pp_version || ']>');
        END IF;

   END LOOP;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END SyncPpPrFreqNotManual;

FUNCTION SetConnection
RETURN APAOGEN.RETURN_TYPE IS

lvi_ret_code                    INTEGER;
lvs_client_id                   VARCHAR2(20);
lvs_us                          VARCHAR2(20);
lvs_password                    VARCHAR2(20);
lvs_applic                      VARCHAR2(8);
lvs_numeric_characters          VARCHAR2(2);
lvs_date_format                 VARCHAR2(255);
lvn_up                          NUMBER;
lvs_user_profile                VARCHAR2(40);
lvs_language                    VARCHAR2(20);
lvs_tk                          VARCHAR2(20);

BEGIN
   IF USER = 'SYS' THEN
      RETURN UNAPIGEN.DBERR_INVALIDUSER;
   END IF;
   lvs_client_id := 'JOB';
   lvs_us := USER;
   lvs_password := '';
   lvs_applic := 'Database';
   lvs_numeric_characters := 'DB';
   lvs_date_format := 'DDfx/fxMM/RR HH24fx:fxMI:SS';

   lvi_ret_code := UNAPIGEN.SetConnection
                      (lvs_client_id,
                       lvs_us,
                       lvs_password,
                       lvs_applic,
                       lvs_numeric_characters,
                       lvs_date_format,
                       lvn_up,
                       lvs_user_profile,
                       lvs_language,
                       lvs_tk);

RETURN lvi_ret_code;

END SetConnection;

FUNCTION StChangeSsToApproved
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_st_highest_version IS
   SELECT st, MAX(version) version, APAOACTION.ConvertUnilab2Interspec(MAX(version)) revision
     FROM utst a
    WHERE version IN (SELECT MAX(version) FROM UTST WHERE st = a.st)
      AND ss = 'CF'
    GROUP BY st, version;

CURSOR lvq_is_revision(avs_part_no  IN VARCHAR2,
                       avn_revision IN NUMBER) IS
   SELECT a.*
     FROM specification_header@interspec a,
          status@interspec b
    WHERE a.part_no = avs_part_no
      AND a.revision = avn_revision
      AND a.status = b.status
      AND b.status_type = 'CURRENT';

CURSOR lvq_stpp(avs_st          IN VARCHAR2,
                avs_st_version  IN VARCHAR2) IS
SELECT b.pp, b.pp_key1, b.pp_key2, b.pp_key3, b.pp_key4, b.pp_key5,
       MAX(b.version) max_version, SUBSTR(MAX(b.version), 1, LENGTH(MAX(b.version)) -3) major_version
  FROM utstpp a, utpp b
 WHERE a.st = avs_st AND a.version = avs_st_version
   AND a.pp_key1 = avs_st
   AND a.pp = b.pp
   AND a.pp_key1 = b.pp_key1
   AND a.pp_key2 = b.pp_key2
   AND a.pp_key3 = b.pp_key3
   AND a.pp_key4 = b.pp_key4
   AND a.pp_key5 = b.pp_key5
   GROUP BY b.pp, b.pp_key1, b.pp_key2, b.pp_key3, b.pp_key4, b.pp_key5;


CURSOR lvq_pp(avs_pp            IN APAOGEN.PP_TYPE,
              avs_max_version   IN APAOGEN.VERSION_TYPE,
              avs_major_version   IN APAOGEN.VERSION_TYPE,
              avs_pp_key1       IN VARCHAR2,
              avs_pp_key2       IN VARCHAR2,
              avs_pp_key3       IN VARCHAR2,
              avs_pp_key4       IN VARCHAR2,
              avs_pp_key5       IN VARCHAR2) IS
SELECT count(*) result
  FROM utpp
 WHERE pp = avs_pp
   AND pp_key1 = avs_pp_key1
   AND pp_key2 = avs_pp_key2
   AND pp_key3 = avs_pp_key3
   AND pp_key4 = avs_pp_key4
   AND pp_key5 = avs_pp_key5
   AND ((SUBSTR(version, 1, length(version) - 3) =  avs_major_version AND version_is_current = 1)
     OR (version = avs_max_version AND ss = 'CF'));

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.StChangeSsToApproved';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
lvs_object_tp                   VARCHAR2(4);
lvs_object_id                   VARCHAR2(20);
lvs_object_version              VARCHAR2(20);
lvs_old_ss                      VARCHAR2(2);
lvs_new_ss                      VARCHAR2(2);
lvs_object_lc                   VARCHAR2(2);
lvs_object_lc_version           VARCHAR2(20);
lvs_modify_reason               VARCHAR2(255);
lvi_assigned_by_template        APAOGEN.RETURN_TYPE ;
BEGIN

   --------------------------------------------------------------------------------
   -- Set Connection in order to make a status change
   --------------------------------------------------------------------------------
   lvi_ret_code := SetConnection();
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Could not setconnection for <' || USER || ' Function returned <' || lvi_Ret_code || '>');
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;
   --------------------------------------------------------------------------------
   -- Check for all st's with highest version 'CF'
   -- Get Interspec revision
   --------------------------------------------------------------------------------
   FOR lvr_st_highest_version IN lvq_st_highest_version LOOP
      --------------------------------------------------------------------------------
      -- Check Interspec for found revision : is status of statustype current ?
      --------------------------------------------------------------------------------
      FOR lvr_is_revision IN lvq_is_revision(lvr_st_highest_version.st, lvr_st_highest_version.revision) LOOP
         --------------------------------------------------------------------------------
         -- Assume we do found current versions for all pp's
         --------------------------------------------------------------------------------
         lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
         --------------------------------------------------------------------------------
         -- Loop through all pp's of found st's
         --------------------------------------------------------------------------------
         FOR lvr_stpp IN lvq_stpp(lvr_st_highest_version.st, lvr_st_highest_version.version) LOOP
            --------------------------------------------------------------------------------
            -- For all pp's check:
            -- 1 Is there a current version within the major pp's
            -- 2 Is the status of the max version of the pp 'CF'
            --------------------------------------------------------------------------------
            FOR lvr_pp IN lvq_pp(lvr_stpp.pp, lvr_stpp.max_version, lvr_stpp.major_version,
            lvr_stpp.pp_key1,lvr_stpp.pp_key2, lvr_stpp.pp_key3,lvr_stpp.pp_key4, lvr_stpp.pp_key5) LOOP
               --------------------------------------------------------------------------------
               -- Check if the pp has been assigned by custom code
               -- If it has, the pp has not been assigned by Interspec,
               -- In that case the revision / version might mismatch
               -- So we do not check the lvr_pp_result but only for a current version in Unilab
               --------------------------------------------------------------------------------
               lvi_assigned_by_template := PpAssignedByTemplate(lvr_st_highest_version.st,
                                                                lvr_st_highest_version.version,
                                                                lvr_stpp.pp);

               IF lvr_pp.result = 0 AND lvi_assigned_by_template != UNAPIGEN.DBERR_SUCCESS
               THEN
                  lvi_ret_code := UNAPIGEN.DBERR_NOOBJECT;
               END IF;
            END LOOP;
         END LOOP;
         --------------------------------------------------------------------------------
         -- Get additional info of st
         --------------------------------------------------------------------------------
         SELECT st, version, ss, lc, lc_version
           INTO lvs_object_id, lvs_object_version, lvs_old_ss, lvs_object_lc, lvs_object_lc_version
           FROM utst
          WHERE st = lvr_st_highest_version.st
            AND version = lvr_st_highest_version.version;
         --------------------------------------------------------------------------------
         -- Fill arguments
         --------------------------------------------------------------------------------
         lvs_object_tp := 'st';
         IF lvi_ret_code = UNAPIGEN.DBERR_NOOBJECT THEN
            --------------------------------------------------------------------------------
            -- Set status to 'To Configure'
            --------------------------------------------------------------------------------
            lvs_new_ss := 'TC';
            --------------------------------------------------------------------------------
            -- Add logging to uterror
            --------------------------------------------------------------------------------
            APAOGEN.LogError (lcs_function_name, 'Sampletype <' || lvr_st_highest_version.st || '[' || lvr_st_highest_version.version || ']> is not ready', FALSE, TRUE);
         ELSE
            --------------------------------------------------------------------------------
            -- Set status to 'Approved'
            --------------------------------------------------------------------------------
            lvs_new_ss := '@A';
         END IF;
         lvs_modify_reason := 'Status changed by ' || lcs_function_name;
         --------------------------------------------------------------------------------
         -- Set effective from to now
         --------------------------------------------------------------------------------
         UPDATE utst
            SET effective_from = CURRENT_TIMESTAMP
          WHERE st = lvs_object_id
            AND version = lvs_object_version;
         --------------------------------------------------------------------------------
         -- Change status of st
         --------------------------------------------------------------------------------
         lvi_ret_code := UNAPIPRP.CHANGEOBJECTSTATUS (lvs_object_tp,
                                                      lvs_object_id,
                                                      lvs_object_version,
                                                      lvs_old_ss,
                                                      lvs_new_ss,
                                                      lvs_object_lc,
                                                      lvs_object_lc_version,
                                                      lvs_modify_reason);
         IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
            APAOGEN.LogError (lcs_function_name, 'Could not change status to @A for <' || lvs_object_id || '[' || lvs_object_version || ']>');
         END IF;
      END LOOP;
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END StChangeSsToApproved;

FUNCTION StPutAllPpToApproved(avs_st            IN APAOGEN.ST_TYPE,
                              avs_st_version    IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_stpp(avs_st          IN VARCHAR2,
                avs_st_version  IN VARCHAR2) IS
SELECT b.pp, b.pp_key1, b.pp_key2, b.pp_key3, b.pp_key4, b.pp_key5,
       MAX(b.version) max_version, SUBSTR(MAX(b.version), 1, LENGTH(MAX(b.version)) -3) major_version,
       b.lc, b.lc_version
  FROM utstpp a, utpp b
 WHERE a.st = avs_st AND a.version = avs_st_version
   AND a.pp_key1 = avs_st
   AND a.pp = b.pp
   AND a.pp_key1 = b.pp_key1
   AND a.pp_key2 = b.pp_key2
   AND a.pp_key3 = b.pp_key3
   AND a.pp_key4 = b.pp_key4
   AND a.pp_key5 = b.pp_key5
   GROUP BY b.pp, b.pp_key1, b.pp_key2, b.pp_key3, b.pp_key4, b.pp_key5, b.lc, b.lc_version;


CURSOR lvq_pp(avs_pp            IN APAOGEN.PP_TYPE,
              avs_max_version   IN APAOGEN.VERSION_TYPE,
              avs_major_version   IN APAOGEN.VERSION_TYPE,
              avs_pp_key1       IN VARCHAR2,
              avs_pp_key2       IN VARCHAR2,
              avs_pp_key3       IN VARCHAR2,
              avs_pp_key4       IN VARCHAR2,
              avs_pp_key5       IN VARCHAR2) IS
SELECT count(*) result
  FROM utpp
 WHERE pp = avs_pp
   AND pp_key1 = avs_pp_key1
   AND pp_key2 = avs_pp_key2
   AND pp_key3 = avs_pp_key3
   AND pp_key4 = avs_pp_key4
   AND pp_key5 = avs_pp_key5
   AND version = avs_max_version AND ss = 'CF';

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.StPutAllPpToApproved';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
lvs_modify_reason               VARCHAR2(255);

BEGIN

   --------------------------------------------------------------------------------
   -- Loop through all pp's of found st's
   --------------------------------------------------------------------------------
   FOR lvr_stpp IN lvq_stpp(avs_st, avs_st_version) LOOP
      --------------------------------------------------------------------------------
      -- For all pp's check:
      -- 1 Is the status of the max version of the pp 'CF'
      --------------------------------------------------------------------------------
      FOR lvr_pp IN lvq_pp(lvr_stpp.pp, lvr_stpp.max_version, lvr_stpp.major_version,
      lvr_stpp.pp_key1,lvr_stpp.pp_key2, lvr_stpp.pp_key3,lvr_stpp.pp_key4, lvr_stpp.pp_key5) LOOP
         IF lvr_pp.result = 1 THEN
            lvs_modify_reason := 'Status changed by ' || lcs_function_name;
            --------------------------------------------------------------------------------
            -- Change status of pp to @A
            --------------------------------------------------------------------------------
            lvi_ret_code := UNAPIPPP.CHANGEPPSTATUS( lvr_stpp.pp,
                                                     lvr_stpp.max_version,
                                                     lvr_stpp.pp_key1,
                                                     lvr_stpp.pp_key2,
                                                     lvr_stpp.pp_key3,
                                                     lvr_stpp.pp_key4,
                                                     lvr_stpp.pp_key5,
                                                     'CF',
                                                     '@A',
                                                     lvr_stpp.lc,
                                                     lvr_stpp.lc_version,
                                                     lvs_modify_reason);

            IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
               APAOGEN.LogError (lcs_function_name, 'Could not change status to approved for <' || lvr_stpp.pp || '[' || lvr_stpp.max_version || ']>');
               RETURN lvi_ret_code;
            END IF;
         END IF;
      END LOOP;
   END LOOP;

   RETURN  UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END StPutAllPpToApproved;

FUNCTION StSyncLastCount(avs_st            IN APAOGEN.ST_TYPE,
                         avs_st_version    IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.StSyncLastCount';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
lvi_last_count                  NUMBER;
lvd_last_sched                  TIMESTAMP WITH TIME ZONE;

--------------------------------------------------------------------------------
-- Cursor
--------------------------------------------------------------------------------
CURSOR lvq_stpp(avs_st            IN VARCHAR2,
                avs_st_version    IN APAOGEN.VERSION_TYPE) IS
SELECT a.pp, a.freq_tp, freq_unit, freq_val
  FROM utstpp a
 WHERE a.st = avs_st AND a.version = avs_st_version;

CURSOR lvq_all_stpp(avs_st            IN VARCHAR2,
                    avs_freq_tp       IN VARCHAR2,
                    avc_freq_unit     IN CHAR,
                    avn_freq_val      IN NUMBER) IS
SELECT MAX(a.last_cnt) last_cnt, MIN(a.last_sched) last_sched
  FROM utstpp a, utst b
 WHERE a.st = avs_st
   AND a.st = b.st AND a.version = b.version
   AND b.version_is_current = 1
   AND a.freq_tp = avs_freq_tp
   AND a.freq_unit = avc_freq_unit
   AND a.freq_val = avn_freq_val
   AND (a.last_sched IS NOT NULL or a.last_cnt != 0);

CURSOR lvq_default_stpp(avs_st            IN VARCHAR2,
                        avs_freq_tp       IN VARCHAR2) IS
SELECT MAX(a.last_cnt) last_cnt, MIN(a.last_sched) last_sched
  FROM utstpp a, utst b
 WHERE a.st = avs_st
   AND a.st = b.st AND a.version = b.version
   AND b.version_is_current = 1
   AND a.freq_tp = avs_freq_tp
   AND (a.last_sched IS NOT NULL or a.last_cnt != 0);

BEGIN

   --------------------------------------------------------------------------------
   -- Loop through all stpp's of current st
   --------------------------------------------------------------------------------
   FOR lvr_stpp IN lvq_stpp(avs_st, avs_st_version) LOOP
      --------------------------------------------------------------------------------
      -- Loop through all stpp's with same freq_tp/unit/val as current stpp
      --------------------------------------------------------------------------------
      FOR lvr_all_stpp IN lvq_all_stpp(avs_st,
                                       lvr_stpp.freq_tp, lvr_stpp.freq_unit, lvr_stpp.freq_val) LOOP

         IF NOT ((lvr_all_stpp.last_cnt IS NULL) AND
                  (lvr_stpp.freq_val IS NULL)) THEN

            --------------------------------------------------------------------------------
            -- Get values from current version
            --------------------------------------------------------------------------------
            lvi_last_count := MOD(lvr_all_stpp.last_cnt, lvr_stpp.freq_val);
            lvd_last_sched := lvr_all_stpp.last_sched;

         ELSE
            --------------------------------------------------------------------------------
            -- Loop through all stpp's with same freq_tp as current stpp
            --------------------------------------------------------------------------------
            FOR lvr_default_stpp IN lvq_default_stpp(avs_st, lvr_stpp.freq_tp) LOOP

               --------------------------------------------------------------------------------
               -- Get values from default
               --------------------------------------------------------------------------------
               lvi_last_count := MOD(lvr_default_stpp.last_cnt, lvr_stpp.freq_val);
               lvd_last_sched := lvr_default_stpp.last_sched;

            END LOOP;
         END IF;

         --------------------------------------------------------------------------------
         -- Update the values on link
         --------------------------------------------------------------------------------
         UPDATE utstpp
            SET last_cnt = NVL(lvi_last_count, 0),
                last_sched = NVL(lvd_last_sched, last_sched)
          WHERE st = avs_st AND version = avs_st_version
            AND pp = lvr_stpp.pp;

         --------------------------------------------------------------------------------
         -- Catch errors
         --------------------------------------------------------------------------------
         IF SQL%ROWCOUNT != 0 THEN
            lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
            APAOGEN.LogError (lcs_function_name, 'Could not synchronize last_count for <' || avs_st || '[' || avs_st_version || ']>');
         END IF;

      END LOOP;
   END LOOP;

  RETURN  UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END StSyncLastCount;

FUNCTION StPpSyncLastCount(avs_st            IN APAOGEN.ST_TYPE,
                           avs_st_version    IN APAOGEN.VERSION_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.StPpSyncLastCount';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Cursor
--------------------------------------------------------------------------------
CURSOR lvq_stpp IS
  SELECT b.*
    FROM utstpp a, utpp b
   WHERE a.st = avs_st AND a.version = avs_st_version
     AND a.pp_key1 = avs_st
     AND a.pp = b.pp
     AND a.pp_key1 = b.pp_key1
     AND a.pp_key2 = b.pp_key2
     AND a.pp_key3 = b.pp_key3
     AND a.pp_key4 = b.pp_key4
     AND a.pp_key5 = b.pp_key5
     AND UNAPIGEN.UsePpVersion(a.pp, a.pp_version, a.pp_key1, a.pp_key2, a.pp_key3, a.pp_key4, a.pp_key5) = b.version;

BEGIN

   --------------------------------------------------------------------------------
   -- Loop through all pp's of current st
   --------------------------------------------------------------------------------
   FOR lvr_stpp IN lvq_stpp LOOP
      lvi_ret_code := APAOACTION.PPSYNCLASTCOUNT(lvr_stpp.pp, lvr_stpp.version, lvr_stpp.pp_key1, lvr_stpp.pp_key2, lvr_stpp.pp_key3, lvr_stpp.pp_key4, lvr_stpp.pp_key5);
   END LOOP;

   RETURN  UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END StPpSyncLastCount;

FUNCTION PpSyncLastCount(avs_pp            IN APAOGEN.PP_TYPE,
                         avs_pp_version    IN APAOGEN.VERSION_TYPE,
                         avs_pp_key1       IN VARCHAR2,
                         avs_pp_key2       IN VARCHAR2,
                         avs_pp_key3       IN VARCHAR2,
                         avs_pp_key4       IN VARCHAR2,
                         avs_pp_key5       IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Cursor
--------------------------------------------------------------------------------
CURSOR lvq_pppr(avs_pp            IN VARCHAR2,
                avs_pp_version    IN APAOGEN.VERSION_TYPE,
                avs_pp_key1       IN VARCHAR2,
                avs_pp_key2       IN VARCHAR2,
                avs_pp_key3       IN VARCHAR2,
                avs_pp_key4       IN VARCHAR2,
                avs_pp_key5       IN VARCHAR2) IS
SELECT a.pr, a.freq_tp, freq_unit, freq_val
  FROM utpppr a
 WHERE a.pp = avs_pp AND a.version = avs_pp_version
   AND a.pp_key1 = avs_pp_key1 AND a.pp_key2 = avs_pp_key2 AND a.pp_key3 = avs_pp_key3 AND a.pp_key4 = avs_pp_key4 AND a.pp_key5 = avs_pp_key5;

CURSOR lvq_all_pppr(avs_pp_key1       IN VARCHAR2,
                    avs_pp_key2       IN VARCHAR2,
                    avs_pp_key3       IN VARCHAR2,
                    avs_pp_key4       IN VARCHAR2,
                    avs_pp_key5       IN VARCHAR2,
                    avs_freq_tp       IN VARCHAR2,
                    avc_freq_unit     IN CHAR,
                    avn_freq_val      IN NUMBER) IS
SELECT MAX(a.last_cnt) last_cnt, MIN(a.last_sched) last_sched
  FROM utpppr a, utpp b
 WHERE a.pp = b.pp AND a.version = b.version
   AND a.pp_key1 = b.pp_key1 AND a.pp_key2 = b.pp_key2 AND a.pp_key3 = b.pp_key3 AND a.pp_key4 = b.pp_key4 AND a.pp_key5 = b.pp_key5
   AND b.pp_key1 = avs_pp_key1 AND b.pp_key2 = avs_pp_key2 AND b.pp_key3 = avs_pp_key3 AND b.pp_key4 = avs_pp_key4 AND b.pp_key5 = avs_pp_key5
   AND b.version_is_current = 1
   AND a.freq_tp = avs_freq_tp
   AND a.freq_unit = avc_freq_unit
   AND a.freq_val = avn_freq_val
   AND (a.last_sched IS NOT NULL or a.last_cnt != 0);

CURSOR lvq_default_pppr(avs_pp_key1       IN VARCHAR2,
                        avs_pp_key2       IN VARCHAR2,
                        avs_pp_key3       IN VARCHAR2,
                        avs_pp_key4       IN VARCHAR2,
                        avs_pp_key5       IN VARCHAR2,
                        avs_freq_tp       IN VARCHAR2) IS
SELECT MAX(a.last_cnt) last_cnt, MIN(a.last_sched) last_sched
  FROM utpppr a, utpp b
 WHERE a.pp = b.pp AND a.version = b.version
   AND a.pp_key1 = b.pp_key1 AND a.pp_key2 = b.pp_key2 AND a.pp_key3 = b.pp_key3 AND a.pp_key4 = b.pp_key4 AND a.pp_key5 = b.pp_key5
   AND b.pp_key1 = avs_pp_key1 AND b.pp_key2 = avs_pp_key2 AND b.pp_key3 = avs_pp_key3 AND b.pp_key4 = avs_pp_key4 AND b.pp_key5 = avs_pp_key5
   AND b.version_is_current = 1
   AND a.freq_tp = avs_freq_tp
   AND (a.last_sched IS NOT NULL or a.last_cnt != 0);

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.PpSyncLastCount';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
lvi_last_count                  NUMBER;
lvd_last_sched                  TIMESTAMP WITH TIME ZONE;

BEGIN

   --------------------------------------------------------------------------------
   -- Loop through all pppr's of current pp
   --------------------------------------------------------------------------------
   FOR lvr_pppr IN lvq_pppr(avs_pp, avs_pp_version,
                            avs_pp_key1, avs_pp_key2, avs_pp_key3, avs_pp_key4, avs_pp_key5) LOOP
      --------------------------------------------------------------------------------
      -- Loop through all pppr's with same freq_tp/unit/val as current pppr
      --------------------------------------------------------------------------------
      FOR lvr_all_pppr IN lvq_all_pppr(avs_pp_key1, avs_pp_key2, avs_pp_key3, avs_pp_key4, avs_pp_key5,
                                       lvr_pppr.freq_tp, lvr_pppr.freq_unit, lvr_pppr.freq_val) LOOP


         IF NOT ((lvr_all_pppr.last_cnt IS NULL) AND
                 (lvr_all_pppr.last_sched IS NULL)) THEN

            --------------------------------------------------------------------------------
            -- Get values from current version
            --------------------------------------------------------------------------------
            lvi_last_count := MOD(lvr_all_pppr.last_cnt, lvr_pppr.freq_val);
            lvd_last_sched := lvr_all_pppr.last_sched;

         ELSE
            --------------------------------------------------------------------------------
            -- Loop through all pppr's with same freq_tp as current pppr
            --------------------------------------------------------------------------------
            FOR lvr_default_pppr IN lvq_default_pppr(avs_pp_key1, avs_pp_key2, avs_pp_key3, avs_pp_key4, avs_pp_key5,
                                                     lvr_pppr.freq_tp) LOOP

               --------------------------------------------------------------------------------
               -- Get values from default
               --------------------------------------------------------------------------------
               lvi_last_count := MOD(lvr_default_pppr.last_cnt, lvr_pppr.freq_val);
               lvd_last_sched := lvr_default_pppr.last_sched;

            END LOOP;
         END IF;

         --------------------------------------------------------------------------------
         -- Update the values on link
         --------------------------------------------------------------------------------
          UPDATE utpppr
            SET last_cnt = NVL(lvi_last_count, 0),
                last_sched = NVL(lvd_last_sched, last_sched)
          WHERE pp = avs_pp AND version = avs_pp_version
            AND pp_key1 = avs_pp_key1 AND pp_key2 = avs_pp_key2 AND pp_key3 = avs_pp_key3 AND pp_key4 = avs_pp_key4 AND pp_key5 = avs_pp_key5
            AND pr = lvr_pppr.pr;

         --------------------------------------------------------------------------------
         -- Catch errors
         --------------------------------------------------------------------------------
         IF SQL%ROWCOUNT != 0 THEN
            lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
         ELSE
            lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
            APAOGEN.LogError (lcs_function_name, 'Could not synchronize last_count for <' || avs_pp || '[' || avs_pp_version || ']>');
         END IF;

      END LOOP;
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;

END PpSyncLastCount;

FUNCTION MeGetPreviousResults
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'MeGetPreviousResults';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;

lvf_value_f        FLOAT;
lvs_value_s        VARCHAR2(40);
lvs_format         VARCHAR2(20);
lvs_default_format VARCHAR2(20) := APAOGEN.GETSYSTEMSETTING('DEFAULT_FORMAT', 'F.2');
lvi_max_y         NUMBER := 0;

CURSOR lvq_cells IS
SELECT sc, pg, pgnode, pa, panode, me, menode,
       CASE WHEN INSTR(cell, '[') > 0 THEN SUBSTR(MAX(cell),0, INSTR(MAX(cell), '[', 1)-1) ELSE MAX(cell) END cell,
       MAX(value_f) value_f, MAX(value_s) value_s,
       CASE WHEN INSTR(cell, '[') > 0 THEN 1 ELSE 0 END LIST,
       SUBSTR(cell, INSTR(cell, '[', 1)+1, INSTR(cell, ',', 1) - INSTR(cell, '[', 1)-1) INDEX_X,
       SUBSTR(cell, INSTR(cell, ',', 1)+1, INSTR(cell, ']', 1) - INSTR(cell, ',', 1)-1) INDEX_Y
  FROM avao_scmecells_new
 WHERE sc = UNAPIEV.P_SC
   AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
   AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
   AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
   AND logdate = (SELECT   MAX(logdate)
                  FROM utscmehs a, utscmehsdetails b
                  WHERE a.sc = UNAPIEV.P_SC
                  AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
                  AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
                  AND a.me = UNAPIEV.P_ME AND a.menode = UNAPIEV.P_MENODE
                  AND a.sc = b.sc
                  AND a.pg = b.pg
                  AND a.pgnode = b.pgnode
                  AND a.pa = b.pa
                  AND a.panode = b.panode
                  AND a.me = b.me
                  AND a.menode = b.menode
                  AND a.what = 'MeDetailsUpdated'
                  AND a.tr_seq = b.tr_seq
                  AND b.details LIKE 'method cell%<value_s%')
GROUP BY sc, pg, pgnode, pa, panode, me, menode, cell
ORDER BY sc, pg, pgnode, pa, panode, me, menode, cell, index_y;

CURSOR lvq_rscmecell IS
   SELECT *
    FROM utrscmecell
    WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
         AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
         AND reanalysis = UNAPIEV.P_REANALYSIS - 1;

CURSOR lvq_rscmecelllist IS
   SELECT *
    FROM utrscmecelllist
    WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
         AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
         AND reanalysis = UNAPIEV.P_REANALYSIS - 1;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
lvi_scmecell NUMBER;
lvi_rscmecell NUMBER;
BEGIN
   SELECT COUNT(*) INTO lvi_scmecell FROM utscmecell
               WHERE sc = UNAPIEV.P_SC
                     AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                     AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                     AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE;
   SELECT COUNT(*) INTO lvi_rscmecell FROM utrscmecell
               WHERE sc = UNAPIEV.P_SC
                     AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                     AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                     AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE;
   --APAOGEN.LogError (lcs_function_name, 'ME : ' || UNAPIEV.P_ME || ', # in utscmecell ' || lvi_scmecell || ', # in utrscmecell ' || lvi_rscmecell || ', UNAPIEV.P_REANALYSIS: ' || UNAPIEV.P_REANALYSIS);

   --------------------------------------------------------------------------------
   -- Copy value_f/value_s from previous reanalysis
   --------------------------------------------------------------------------------
   -- 2 scenario's:
   -- 1) the old values are present in a utrsc* table
   -- 2) the 'old' values are not present in a utrsc* table and will be determined on audit trail records
   --------------------------------------------------------------------------------

   IF UNAPIEV.P_REANALYSIS > 0 THEN
     FOR lvr_rscmecell IN lvq_rscmecell LOOP
         UPDATE utscmecell
            SET value_f = lvr_rscmecell.value_f
              , value_s = lvr_rscmecell.value_s
         WHERE sc = lvr_rscmecell.sc
           AND pg = lvr_rscmecell.pg AND pgnode = lvr_rscmecell.pgnode
           AND pa = lvr_rscmecell.pa AND panode = lvr_rscmecell.panode
           AND me = lvr_rscmecell.me AND menode = lvr_rscmecell.menode
           AND cell = lvr_rscmecell.cell;
     END LOOP;

    ELSE
      -- Scenario 2, the old functionality
      FOR lvr_cells IN lvq_cells LOOP

         --------------------------------------------------------------------------------
         -- Initialize string and float values
         --------------------------------------------------------------------------------
         lvs_value_s := NULL;
         lvf_value_f := NULL;

         BEGIN
               SELECT NVL(MAX(format), lvs_default_format)
               INTO lvs_format
               FROM utscmecell
              WHERE sc = UNAPIEV.P_SC
                AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
                AND cell = lvr_cells.cell;

            --APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cells.cell || ' Format:' || lvs_format);

            BEGIN
                 lvs_value_s := lvr_cells.value_s;
                 lvf_value_f := TO_NUMBER(lvr_cells.value_s);
                 lvs_value_s := NULL;

                 --APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cells.cell || ' To_Number ' || lvr_cells.value_s || '=>' || lvf_value_f);

            EXCEPTION
                  WHEN OTHERS THEN
                 APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cells.cell || ' Error To_Number (' || lvr_cells.value_s || ')');
                 lvf_value_f := NULL;
                 --lvs_value_s := NULL;
            END ;

            lvi_ret_code := UNAPIGEN.FORMATRESULT(lvf_value_f,
                                                  lvs_format,
                                                  lvs_value_s);

            --APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cells.cell || ' Value_s (formatted):' || lvs_value_s);

            --------------------------------------------------------------------------------
            -- We do not deal with a table cell
            --------------------------------------------------------------------------------
            IF lvr_cells.list = 0 THEN
               --APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cells.cell || ' No table cell');

               UPDATE utscmecell
                  SET value_f = lvf_value_f,
                      value_s = lvs_value_s
                WHERE sc = UNAPIEV.P_SC
                  AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                  AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                  AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
                  AND cell = lvr_cells.cell;
            --------------------------------------------------------------------------------
            -- We do deal with a table cell
            --------------------------------------------------------------------------------
            ELSE
               --APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cells.cell || ' Table cell');

               UPDATE utscmecelllist
                  SET value_f = lvf_value_f,
                      value_s = lvs_value_s
                WHERE sc = UNAPIEV.P_SC
                  AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                  AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                  AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
                  AND cell = lvr_cells.cell
                  AND index_x = lvr_cells.index_x
                  AND index_y = lvr_cells.index_y;
               --------------------------------------------------------------------------------
               -- If no rows are updated, it means that the row is not present by default, so add it
               --------------------------------------------------------------------------------
               IF SQL%ROWCOUNT = 0 THEN
                  INSERT
                    INTO UTSCMECELLLIST (SC, PG, PGNODE, PA, PANODE, ME, MENODE, REANALYSIS, CELL, INDEX_X, INDEX_Y, VALUE_F, VALUE_S, SELECTED)
                  VALUES (UNAPIEV.P_SC,
                          UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                          UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                          UNAPIEV.P_ME, UNAPIEV.P_MENODE,
                          UNAPIEV.P_REANALYSIS,
                          lvr_cells.cell,
                          lvr_cells.index_x, lvr_cells.index_y,
                          lvf_value_f,
                          lvs_value_s,
                          0);

                  --APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cells.cell || ' Records added:' || SQL%ROWCOUNT);
                  --------------------------------------------------------------------------------
                  -- Determine the highest max_y value
                  --------------------------------------------------------------------------------
                  IF (lvr_cells.index_y + 1 > lvi_max_y) THEN
                     lvi_max_y := lvr_cells.index_y + 1;
                  END IF;

                  --------------------------------------------------------------------------------
                  -- Adjust the number of rows in the table cell for the updated cell
                  --------------------------------------------------------------------------------
                   UPDATE utscmecell
                      SET max_y = lvi_max_y
                    WHERE sc = UNAPIEV.P_SC
                      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                      AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
                      AND cell = lvr_cells.cell;
                  --APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cells.cell || ' Records updated:' || SQL%ROWCOUNT);
               END IF;
            END IF;
            --------------------------------------------------------------------------------
            -- If the value of the updated cell exists in the celllist, mark it as selected
            --------------------------------------------------------------------------------
            DELETE
              FROM utscmecelllist
             WHERE sc = UNAPIEV.P_SC
               AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
               AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
               AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
               AND cell = lvr_cells.cell
               AND (sc,pg,pgnode,pa,panode,me,menode,cell) IN (SELECT sc,
                                                                      pg, pgnode,
                                                                      pa, panode,
                                                                      me, menode,
                                                                      cell
                                                                 FROM utscmecell
                                                                WHERE sc = UNAPIEV.P_SC
                                                                  AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                                                                  AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                                                                  AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
                                                                  AND cell = lvr_cells.cell
                                                                  AND cell_tp IN ('L','C'));

            --APAOFUNCTIONS.LogInfo(lcs_function_name, lvr_cells.cell || ' Orignal selected values removed:' || SQL%ROWCOUNT);

         EXCEPTION
         WHEN OTHERS THEN
            NULL;
         END;

      END LOOP;
   END IF;

   IF UNAPIEV.P_REANALYSIS > 0 THEN
        FOR lvr_rscmecelllist IN lvq_rscmecelllist LOOP
         UPDATE utscmecelllist
            SET value_f = lvr_rscmecelllist.value_f
              , value_s = lvr_rscmecelllist.value_s
         WHERE sc = lvr_rscmecelllist.sc
           AND pg = lvr_rscmecelllist.pg AND pgnode = lvr_rscmecelllist.pgnode
           AND pa = lvr_rscmecelllist.pa AND panode = lvr_rscmecelllist.panode
           AND me = lvr_rscmecelllist.me AND menode = lvr_rscmecelllist.menode
           AND cell = lvr_rscmecelllist.cell
           AND index_x = lvr_rscmecelllist.index_x
           AND index_y = lvr_rscmecelllist.index_y;

     END LOOP;

   /*

      DELETE
        FROM utscmecelllist
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
         AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
         AND (sc,pg,pgnode,pa,panode,me,menode,cell) IN (SELECT sc,
                                                                pg, pgnode,
                                                                pa, panode,
                                                                me, menode,
                                                                cell
                                                           FROM utscmecell
                                                          WHERE sc = UNAPIEV.P_SC
                                                            AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                                                            AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                                                            AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
                                                            AND cell_tp IN ('L','C', 'D'));

      INSERT
        INTO utscmecelllist
      SELECT *
        FROM utrscmecelllist
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
         AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
         AND reanalysis = UNAPIEV.P_REANALYSIS - 1
         AND (sc,pg,pgnode,pa,panode,me,menode,cell) IN (SELECT sc,
                                                                pg, pgnode,
                                                                pa, panode,
                                                                me, menode,
                                                                cell
                                                           FROM utscmecell
                                                          WHERE sc = UNAPIEV.P_SC
                                                            AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
                                                            AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
                                                            AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
                                                            AND cell_tp IN ('L','C', 'D'));

      APAOFUNCTIONS.LogInfo(lcs_function_name, ' Selected values copied from previous reanalysis:' || SQL%ROWCOUNT);

      UPDATE utscmecelllist
         SET reanalysis = UNAPIEV.P_REANALYSIS
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
         AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE;
         */
   END IF;

   IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      --------------------------------------------------------------------------------
      -- Check if we did update any cell, if we did update audittrail
      --------------------------------------------------------------------------------
      lvi_ret_code := APAOFUNCTIONS.ADDSCMECOMMENT(UNAPIEV.P_SC,
                                                   UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                   UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                   UNAPIEV.P_ME, UNAPIEV.P_MENODE,
                                                   'Methodcell(s) filled with previous manually entered result by ' || lcs_function_name);
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;

END MeGetPreviousResults;

FUNCTION MeRemoveGk(avs_gk IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'MeRemoveGk';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_gk IS
SELECT a.sc, a.pg, a.pgnode, a.pa, a.panode, a.me, a.menode, b.exec_end_date + c.setting_value REMOVE_AT
  FROM utscmegkme_is_relevant a, utscme b, utsystem c
 WHERE a.sc = b.sc
   AND a.pg = b.pg AND a.pgnode = b.pgnode
   AND a.pa = b.pa AND a.panode = b.panode
   AND a.me = b.me AND a.menode = b.menode
   AND c.setting_name = avs_gk || '_DAYS';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
lts_value_tab    UNAPIGEN.VC40_TABLE_TYPE;
lvi_nr_of_rows   NUMBER;
lvs_gk_version   VARCHAR2(20);
lvi_counter      NUMBER;
lvi_total_ev     NUMBER;
BEGIN
   SELECT COUNT(*)
     INTO lvi_total_ev
     FROM UTEV;
   IF (lvi_total_ev > 100) THEN
      APAOGEN.LogError (lcs_function_name, 'UTEV containts too much records, so we quit : ' || lvi_total_ev );
      RETURN lvi_ret_code;
   END IF;

   --------------------------------------------------------------------------------
   -- SetConnection to be able to do api-calls
   --------------------------------------------------------------------------------
   lvi_ret_code := APAOACTION.SETCONNECTION();
   lvi_counter := 0;

   IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      --------------------------------------------------------------------------------
      -- Loop through all gk's
      --------------------------------------------------------------------------------
      FOR lvr_gk IN lvq_gk LOOP
         --------------------------------------------------------------------------------
         -- Check whether they should be removed or not
         --------------------------------------------------------------------------------
         IF lvr_gk.REMOVE_AT < LOCALTIMESTAMP THEN
            --------------------------------------------------------------------------------
            -- Initialize unapiev variables
            --------------------------------------------------------------------------------
            UNAPIEV.P_SC := lvr_gk.sc;
            UNAPIEV.P_PG := lvr_gk.pg;
            UNAPIEV.P_PGNODE := lvr_gk.pgnode;
            UNAPIEV.P_PA := lvr_gk.pa;
            UNAPIEV.P_PANODE := lvr_gk.panode;
            UNAPIEV.P_ME := lvr_gk.me;
            UNAPIEV.P_MENODE := lvr_gk.menode;

            lvs_gk_version := 0;
            lvi_nr_of_rows := 0;
            lvi_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC, UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                       UNAPIEV.P_PA, UNAPIEV.P_PANODE, UNAPIEV.P_ME,
                                                       UNAPIEV.P_MENODE, avs_gk, lvs_gk_version,
                                                       lts_value_tab, lvi_nr_of_rows, NULL);

            IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
               APAOGEN.LogError (lcs_function_name, 'Could deassign gk <' || avs_gk || ' for ' ||
                                                    '#sc=' || UNAPIEV.P_SC ||
                                                    '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
                                                    '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
                                                    '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE));
               RETURN lvi_ret_code;
            END IF;
            lvi_counter := lvi_counter + 1;

            IF lvi_counter > 499 THEN
               APAOGEN.LogError (lcs_function_name, 'Processed 500 records, so we have to quit');
                EXIT;
            END IF;

         END IF;
      END LOOP;
   END IF;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;

END MeRemoveGk;

FUNCTION WriteXML(avs_sc   IN VARCHAR)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name || '.WriteXML';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvi_ret_code                     APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

BEGIN

   lvi_ret_code:= APAO_XML.WRITETOXML(avs_sc);
   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN SQLCODE;
END WriteXML;

--------------------------------------------------------------------------------
-- FUNCTION : GetEmailReceipients
-- ABSTRACT : This function will get the e-mail adresses from users with the
--            attribute avMailing
--------------------------------------------------------------------------------
--   WRITER : A.F. Kok
-- REVIEWER :
--     DATE : 12/04/2016
--   TARGET :
--  VERSION : 6.4.x.x.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- 12/04/2016 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION GetEmailReceipients
RETURN VARCHAR2 IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'GetEmailReceipients';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_email IS
   SELECT b.email
     FROM utadau a, utad b
    WHERE a.ad = b.ad
      AND a.au = 'avMailing';

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvs_ret_code VARCHAR2(255) := NULL;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   FOR lvr_email IN lvq_email LOOP
      IF lvs_ret_code IS NULL THEN
         lvs_ret_code := lvr_email.email;
      ELSE
         lvs_ret_code := lvs_ret_code||';'||lvr_email.email;
      END IF;
   END LOOP;

   RETURN lvs_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN NULL;
END GetEmailReceipients;

END APAOACTION;
/
