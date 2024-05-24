CREATE OR REPLACE PACKAGE        APAOCONDITION AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOCONDITION
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 29/05/2008
--   TARGET : Oracle 10.2.0
--  VERSION : av2.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 29/05/2008 | RS        | Created
-- 06/08/2008 | RS        | Renamed scAllScFinished into scAllPaFinished
-- 17/09/2008 | RS        | Added PrNewFromInterspec
--                        | Added PpNewFromInterspec
--                        | Added StNewFromInterspec
--                        | Added StTemplateHasManualFreq
--                        | Added PpTemplateHasManualFreq
--                        | Added StHasManualFreq
--                        | Added PpHasManualFreq
--                        | Added StHasCustomFreq
--                        | Added PpHasCustomFreq
--                        | Added StCreatedByUNDIFF
--                        | Added PpCreatedByUNDIFF
--                        | Added PpStReevalTrigger
--                        | Added AutoConfigureSpecType
--                        | Added PrHasTemplate
--                        | Added StTriggerCurrentInInterspec
--                        | Added StInterspecStatusIsQr5
--                        | Added StAllPpsConfigured
-- 01/10/2008 | RS        | Added PrCreatedByPrNewMinor
--                        | Added PrCreatedByPrApplyTemplate
--                        | Added PrFirstMajor
-- 14/10/2008 | RS        | Added StIsTemplate
-- 16/10/2008 | RS        | Added PpIsTemplate
--                        | Added PrIsTemplate
-- 05/11/2008 | RS        | Added StTemplateHasCustomFreq
--                        | Added StCreatedByStPpApplyISFreq
--                        | Added PpTemplateHasCustomFreq
-- 12/11/2008 | RS        | Added PpCreatedByStApplyTemplate
--                        | Added PpCreatedByPpPrApplyISFreq
-- 03/12/2008 | RS        | Added ScUABasedError
--                        | Added MeScIsCancelled
-- 11/02/2009 | RS        | Added RqAvOn1Sc
-- 17/03/2010 | RS        | Added StUseTemplate
--                        | Added PpUseTemplate
--                        | Added RqOneScOSConf
-- 12/05/2011 | RS        | Added icToPIBS
-- 13/02/2013 | RS        | Added RqRtIsOutdoor
-- 29/03/2016 | AF        | Added PpInTemplateWithPpKey1
-- 29/03/2016 | AF        | Added StCorrectTemplateConfig
-- 12/05/2016 | JR	      | Added RqToAvailable
-- 23/06/2016 | JR        | Added ScDestructiveError (ERULG101C)
-- 15/12/2016 | JR        | Added function SC_C17 (I1610-488)
-- 20/07/2017 | JR        | Added function paOnePaTV (I1705-020)
-- 20-09-2021 | PS        | Altered function avCustToAvailable (related to RQ_C17, also check RQ.AU-attribute)
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

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION meWachtOpAndereMe
RETURN BOOLEAN;

FUNCTION RqPlanned
RETURN BOOLEAN;

FUNCTION RqOrScPlanned
RETURN BOOLEAN;

FUNCTION RqIsValidationRq
RETURN BOOLEAN;

FUNCTION RqManualAvRq
RETURN BOOLEAN;

FUNCTION RqWaitForOtherRq
RETURN BOOLEAN;

FUNCTION RqWaitForValidationRq
RETURN BOOLEAN;

FUNCTION RqWaitForInitial
RETURN BOOLEAN;

FUNCTION RqAllScAv
RETURN BOOLEAN;

FUNCTION RqOneScAv
RETURN BOOLEAN;

FUNCTION RqAvOn1Sc
RETURN BOOLEAN;

FUNCTION RqAllScFinished
RETURN BOOLEAN;

FUNCTION RqOneScOSConf
RETURN BOOLEAN;

FUNCTION paBuitenSpecificatie
RETURN BOOLEAN;

FUNCTION paBinnenSpecificatie
RETURN BOOLEAN;

FUNCTION paBuitenWaarschuwing
RETURN BOOLEAN;

FUNCTION paBinnenWaarschuwing
RETURN BOOLEAN;

FUNCTION paResultAvailable
RETURN BOOLEAN;

FUNCTION meResultAvailable
RETURN BOOLEAN;

FUNCTION paHasLinkedPa
RETURN BOOLEAN;

FUNCTION paOneLinkedPaOS
RETURN BOOLEAN;

FUNCTION paOneLinkedPaOW
RETURN BOOLEAN;

FUNCTION paOneLinkedPaOSConf
RETURN BOOLEAN;

FUNCTION paOneLinkedPaOWConf
RETURN BOOLEAN;

FUNCTION paOnePaTV
RETURN BOOLEAN;

FUNCTION paReanalysis
RETURN BOOLEAN;

FUNCTION meReanalysis
RETURN BOOLEAN;

FUNCTION paAllMeFinished
RETURN BOOLEAN;

FUNCTION paAllMeCancelled
RETURN BOOLEAN;

FUNCTION paSkipOutOfSpec
RETURN BOOLEAN;

FUNCTION PaSkipOutOfWarning
RETURN BOOLEAN;

FUNCTION PaCustomReanalysis
RETURN BOOLEAN;

FUNCTION scAllPaFinished
RETURN BOOLEAN;

FUNCTION scOnePaOWConf
RETURN BOOLEAN;

FUNCTION scOnePaOSConf
RETURN BOOLEAN;

FUNCTION scOnePaOS
RETURN BOOLEAN;

FUNCTION scOnePaOW
RETURN BOOLEAN;

FUNCTION scOnePaAv
RETURN BOOLEAN;

FUNCTION scInitialToPlanned
RETURN BOOLEAN;

FUNCTION ScManualAvSc
RETURN BOOLEAN;

FUNCTION ScHasRq
RETURN BOOLEAN;

FUNCTION ScUABasedError
RETURN BOOLEAN;

FUNCTION MeScIsCancelled
RETURN BOOLEAN;

FUNCTION PrNewFromInterspec
RETURN BOOLEAN;

FUNCTION PpNewFromInterspec
RETURN BOOLEAN;

FUNCTION StNewFromInterspec
RETURN BOOLEAN;

FUNCTION StTemplateHasManualFreq
RETURN BOOLEAN;

FUNCTION PpTemplateHasManualFreq
RETURN BOOLEAN;

FUNCTION StHasManualFreq
RETURN BOOLEAN;

FUNCTION PpHasManualFreq
RETURN BOOLEAN;

FUNCTION StTemplateHasCustomFreq
RETURN BOOLEAN;

FUNCTION StHasCustomFreq
RETURN BOOLEAN;

FUNCTION PpHasCustomFreq
RETURN BOOLEAN;

FUNCTION StCreatedByUNDIFF
RETURN BOOLEAN;

FUNCTION PpCreatedByUNDIFF
RETURN BOOLEAN;

FUNCTION PpStReevalTrigger
RETURN BOOLEAN;

FUNCTION AutoConfigureSpecType(avs_spec_type IN APAOGEN.GKVALUE_TYPE)
RETURN BOOLEAN;

FUNCTION PrHasTemplate
RETURN BOOLEAN;

FUNCTION StTriggerCurrentInInterspec
RETURN BOOLEAN;

FUNCTION StInterspecStatusIsQr5
RETURN BOOLEAN;

FUNCTION StAllPpsConfigured
RETURN BOOLEAN;

FUNCTION StFirstMajor
RETURN BOOLEAN;

FUNCTION StCreatedByStApplyTemplate
RETURN BOOLEAN;

FUNCTION PpCreatedByStApplyTemplate
RETURN BOOLEAN;

FUNCTION StCreatedByStPpApplyISFreq
RETURN BOOLEAN;

FUNCTION PpCreatedByPpPrApplyISFreq
RETURN BOOLEAN;

FUNCTION StIsTemplate
RETURN BOOLEAN;

FUNCTION PpIsTemplate
RETURN BOOLEAN;

FUNCTION PpFirstMajor
RETURN BOOLEAN;

FUNCTION PpCreatedByPpApplyTemplate
RETURN BOOLEAN;

FUNCTION PrIsTemplate
RETURN BOOLEAN;

FUNCTION PrFirstMajor
RETURN BOOLEAN;

FUNCTION PrCreatedByPrApplyTemplate
RETURN BOOLEAN;

FUNCTION PrCreatedByPrNewMinor
RETURN BOOLEAN;

FUNCTION PpTemplateHasCustomFreq
RETURN BOOLEAN;

FUNCTION StUseTemplate
RETURN BOOLEAN;

FUNCTION PpUseTemplate
RETURN BOOLEAN;

FUNCTION icToPIBS
RETURN BOOLEAN;

FUNCTION RqRtIsOutdoor
RETURN BOOLEAN;

FUNCTION RqToAvailable
RETURN BOOLEAN;

--------------------------------------------------------------------------------
-- FUNCTION : PpInTemplateWithPpKey1
-- ABSTRACT : This function checks whether the PP is present in a template with
--            a filled PP_KEY1
--------------------------------------------------------------------------------
--   WRITER : Arie Frans Kok
-- REVIEWER :
--     DATE : 29/03/2016
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
-- 29/03/2016 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION PpInTemplateWithPpKey1
RETURN BOOLEAN;

--------------------------------------------------------------------------------
-- FUNCTION : StCorrectTemplateConfig
-- ABSTRACT : This function checks whether the template configuration is correct
--------------------------------------------------------------------------------
--   WRITER : Arie Frans Kok
-- REVIEWER :
--     DATE : 31/03/2016
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
-- 31/03/2016 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION StCorrectTemplateConfig
RETURN BOOLEAN;

FUNCTION ScDestructiveError
RETURN BOOLEAN;

FUNCTION ScPlannedToAvailable
RETURN BOOLEAN;

END APAOCONDITION;
/


CREATE OR REPLACE PACKAGE BODY        APAOCONDITION AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOCONDITION
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 29/05/2008
--   TARGET : Oracle 10.2.0
--  VERSION : av2.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 29/05/2008 | RS        | Created
-- 06/08/2008 | RS        | Renamed scAllScFinished into scAllPaFinished
--                        | Changed RqAllScFinished : Added additional sc status SC, WC and @C
--                        | Renamed RqManualAvRq into RqManualAvRqGk
--                        | Added RqManualAvRq
-- 17/09/2008 | RS        | Added PrNewFromInterspec
--                        | Added PpNewFromInterspec
--                        | Added StNewFromInterspec
--                        | Added StTemplateHasManualFreq
--                        | Added PpTemplateHasManualFreq
--                        | Added StHasManualFreq
--                        | Added PpHasManualFreq
--                        | Added StHasCustomFreq
--                        | Added PpHasCustomFreq
--                        | Added StCreatedByUNDIFF
--                        | Added PpCreatedByUNDIFF
--                        | Added PpStReevalTrigger
--                        | Added AutoConfigureSpecType
--                        | Added PrHasTemplate
--                        | Added StTriggerCurrentInInterspec
--                        | Added StInterspecStatusIsQr5
--                        | Added StAllPpsConfigured
-- 01/10/2008 | RS        | Added PrCreatedByPrNewMinor
--                        | Added PrCreatedByPrApplyTemplate
--                        | Added PrFirstMajor
-- 14/10/2008 | RS        | Added StIsTemplate
-- 16/10/2008 | RS        | Added PpIsTemplate
--                        | Added PrIsTemplate
--                        | Changed StFirstMajor (only check on availability)
--                        | Changed PpFirstMajor (only check on availability)
--                        | Changed PrFirstMajor (only check on availability)
--                        | Changed StFirstMajor (!= st_version)
-- 05/11/2008 | RS        | Added StTemplateHasCustomFreq
--                        | Added StCreatedByStPpApplyISFreq
--                        | Added PpTemplateHasCustomFreq
-- 12/11/2008 | RS        | Changed StInterspecStatusIsQr5
--                        | Changed StFirstMajor (= no minor versions)
--                        | Changed PpFirstMajor (= no minor versions)
--                        | Changed PrFirstMajor (= no minor versions)
-- 12/11/2008 | RS        | Added PpCreatedByStApplyTemplate
--                        | Added PpCreatedByPpPrApplyISFreq
-- 03/12/2008 | RS        | Added ScUABasedError
--                        | Added MeScIsCancelled
-- 10/12/2008 | RS        | Changed PpCreatedByStApplyTemplate
-- 11/02/2009 | RS        | Added RqAvOn1Sc
--                        | Changed RqOneScAv (fixed functionname)
-- 17/03/2010 | RS        | Added StUseTemplate
--                        | Added PpUseTemplate
--                        | Added RqOneScOSConf
-- 12/05/2011 | RS        | Added icToPIBS
-- 13/02/2013 | RS        | Added RqRtIsOutdoor
-- 01/05/2015 | JR        | Changed RqRtIsOutdoor
-- 29/03/2016 | AF        | Added PpInTemplateWithPpKey1 (I1511-178)
-- 29/03/2016 | AF        | Added StCorrectTemplateConfig (I1511-178)
-- 29/03/2016 | AF        | Altered function StTemplateHasManualFreq (I1511-178)
-- 29/03/2016 | AF        | Altered function StTemplateHasCustomFreq (I1511-178)
-- 29/03/2016 | AF        | Altered function StUseTemplate (I1511-178)
-- 28/04/2016 | AF        | Altered function PpIsTemplate
-- 12/05/2016 | JR	      | Added RqToAvailable
-- 23/06/2016 | JR        | Added ScDestructiveError (ERULG101C)
-- 15/12/2016 | JR        | Added function ScPlannedToAvailable
-- 20/07/2017 | JR        | Added function paOnePaTV (I1705-020 Extra request status)
--                        | Altered functions RqIsValidationRq, ScAllPaFinished
-- 27/07/2017 | JR        | Altered function paOnePaTV (I1705-020 Extra request status)
-- 20-09-2021 | PS        | Altered function avCustToAvailable (related to RQ_C17, also check RQ.AU-attribute)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT APAOGEN.API_NAME_TYPE := 'apaocondition';
ics_ss_completed                 CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_completed');
ics_ss_cancelled                 CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_cancelled');
ics_ss_out_of_warning_conf       CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_out_of_warning_conf');
ics_ss_out_of_warning            CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_out_of_warning');
ics_ss_out_of_spec_conf          CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_out_of_spec_conf');
ics_ss_out_of_spec               CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_out_of_spec');
ics_ss_irrelevant                CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_irrelevant');
ics_ss_available                 CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_available');
ics_ss_planned                   CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_planned');
ics_au_wait_for                  CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('au_wait_for');
ics_mtcell_in_execution          CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('mtcell_in_execution');
ics_mtcell_hours2wait            CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('mtcell_hours2wait');
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- START OF INTERFACE FUNCTIONS
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Internal function
--------------------------------------------------------------------------------
FUNCTION meWachtOpAndereMe
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'meWachtOpAndereMe';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN
/*
   SELECT COUNT(*)
     INTO lvi_counter1
     FROM utscme a
    WHERE a.sc = UNAPIEV.P_SC
      AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
      AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
      AND a.me = UNAPIEV.P_ME AND a.menode = UNAPIEV.P_MENODE;

   IF lvi_counter1 = 0 THEN
      RETURN TRUE;
   END IF;
   */
    --------------------------------------------------------------------------------
  -- Check :
  -- 1. is the mtau ics_au_wait_for available
  -- 2. is the value of mtau ics_au_wait_for an available me
  -- 3. method status <> irrelevant or cancelled
  -------------------------------------------------------------------------------
   SELECT COUNT(*)
     INTO lvi_counter1
     FROM utscmeau a, utscme b
    WHERE a.sc = UNAPIEV.P_SC
      AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
      AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
      AND a.me = UNAPIEV.P_ME AND a.menode = UNAPIEV.P_MENODE
      AND a.au = ics_au_wait_for
      AND b.sc = a.sc
      AND b.me = a.value
      AND b.ss NOT IN (ics_ss_irrelevant, ics_ss_cancelled);

  IF lvi_counter1 > 0 THEN
    RETURN (TRUE);
   ELSE
    RETURN (FALSE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END meWachtOpAndereMe;
--------------------------------------------------------------------------------
-- Internal function
--------------------------------------------------------------------------------
FUNCTION RqPlanned
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqPlanned';
lvi_ret_code      APAOGEN.RETURN_TYPE;

lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;
BEGIN

  --------------------------------------------------------------------------------
  -- Request does have 5 different states for @P
  --------------------------------------------------------------------------------
  SELECT SUM (DECODE (a.ss, 'DV', 1,
                              'SU', 1,
                              'RJ', 1,
                              '@P', 1,
                              'RE' ,1, 0))
     INTO lvi_counter1
     FROM utrq a, utrqsc b
    WHERE a.rq = b.rq
      AND b.sc = UNAPIEV.P_SC;

  --------------------------------------------------------------------------------
  -- If request does have status Planned --> return TRUE
  --------------------------------------------------------------------------------
  IF lvi_counter1 > 0 THEN
      RETURN (TRUE);
   ELSE
      RETURN (FALSE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqPlanned;
--------------------------------------------------------------------------------
-- Internal function
--------------------------------------------------------------------------------
FUNCTION RqOrScPlanned
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqOrScPlanned';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN
  --------------------------------------------------------------------------------
  -- Sample does have 1 different state for @P
  --------------------------------------------------------------------------------
   SELECT COUNT (DECODE (ss,ics_ss_planned  ,1))
     INTO lvi_counter1
     FROM utsc
    WHERE sc = UNAPIEV.P_SC;

  --------------------------------------------------------------------------------
  -- If request or sample does status P --> return TRUE
  --------------------------------------------------------------------------------
  IF RqPlanned = TRUE OR lvi_counter1 > 0 THEN
      RETURN (TRUE);
   ELSE
      RETURN (FALSE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqOrScPlanned;

FUNCTION RqIsValidationRq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqIsValidationRq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN
  ------------------------------------------------------------
  -- If called from a PA condition we have to get the RQ first
  ------------------------------------------------------------
  IF UNAPIEV.P_EV_REC.object_tp = 'pa' THEN
	BEGIN
		SELECT rq
		  INTO UNAPIEV.P_RQ
		  FROM utrqsc
		 WHERE sc = UNAPIEV.P_SC;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			NULL;
	END;
  END IF;

  SELECT COUNT(*)
    INTO lvi_counter1
    FROM utrqgkvalidateresult
   WHERE rq = UNAPIEV.P_RQ
     AND validateresult = '1';

  IF lvi_counter1 > 0 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqIsValidationRq;

FUNCTION RqManualAvRq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqManualAvRq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN


  SELECT COUNT(*)
    INTO lvi_counter1
    FROM utrqau
   WHERE rq = UNAPIEV.P_RQ
     AND au = 'avCustRqManual2AV'
     AND value = '1';

  IF lvi_counter1 > 0 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqManualAvRq;

FUNCTION RqManualAvRqGk
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqManualAvRqGk';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN

  SELECT COUNT(*)
    INTO lvi_counter1
    FROM utrqgkmanual2available
   WHERE rq = UNAPIEV.P_RQ
     AND manual2available = '1';

  IF lvi_counter1 > 0 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqManualAvRqGk;

FUNCTION RqWaitForOtherRq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqWaitForOtherRq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT(*)
     INTO lvi_counter1
     FROM utrqgkwaitfor
    WHERE rq = UNAPIEV.P_RQ
      AND waitfor IS NOT NULL;

  IF lvi_counter1 > 0 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqWaitForOtherRq;

FUNCTION RqWaitForValidationRq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqWaitForValidationRq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT(*)
     INTO lvi_counter1
     FROM utrqgkwaitfor a, utrqgkvalidateresult b
    WHERE a.rq = UNAPIEV.P_RQ
      AND a.waitfor = b.rq
      AND b.validateresult = '1';

   IF lvi_counter1 > 0 THEN
      RETURN (TRUE);
   ELSE
      RETURN (FALSE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqWaitForValidationRq;

FUNCTION RqWaitForInitial
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqWaitForInitial';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT(*)
     INTO lvi_counter1
     FROM utrqgkwaitforinitial
    WHERE rq = UNAPIEV.P_RQ
      AND waitforinitial IS NOT NULL;

  IF lvi_counter1 > 0 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqWaitForInitial;

FUNCTION RqAllScAv
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqAllScAv';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;
lvi_counter2    APAOGEN.COUNTER_TYPE;

BEGIN

  SELECT COUNT(b.ss), SUM(DECODE(b.ss, 'AV', 1,
                                       '@C', 1, 0))
    INTO lvi_counter1, lvi_counter2
    FROM utrqsc a, utsc b
   WHERE a.rq = UNAPIEV.P_RQ
     AND a.sc = b.sc;

  IF lvi_counter1 = lvi_counter2 AND lvi_counter1 > 0 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqAllScAv;

FUNCTION RqOneScAv
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqOneScAv';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN

  SELECT SUM(DECODE(b.ss, 'AV', 1, 0))
    INTO lvi_counter1
    FROM utrqsc a, utsc b
   WHERE a.rq = UNAPIEV.P_RQ
     AND a.sc = b.sc;

  IF lvi_counter1 > 0 THEN
     RETURN (TRUE);
  END IF;

  RETURN (FALSE);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqOneScAv;


FUNCTION RqAvOn1Sc
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqAvOn1Sc';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN


  SELECT COUNT(*)
    INTO lvi_counter1
    FROM utrqau
   WHERE rq = UNAPIEV.P_RQ
     AND au = 'avCustRqAvOn1Sc'
     AND value = '1';

  IF lvi_counter1 > 0 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqAvOn1Sc;

FUNCTION RqAllScFinished
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqAllScFinished';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;
lvi_counter2    APAOGEN.COUNTER_TYPE;

BEGIN

  SELECT COUNT(b.ss), SUM(DECODE(b.ss, 'CM', 1,
                                       '@C', 1,
                                       'SC', 1,
                                       'WC', 1, 0))
    INTO lvi_counter1, lvi_counter2
    FROM utrqsc a, utsc b
   WHERE a.rq = UNAPIEV.P_RQ
     AND a.sc = b.sc;

  IF lvi_counter1 = lvi_counter2 AND lvi_counter1 > 0 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqAllScFinished;

FUNCTION RqOneScOSConf
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqOneScOSConf';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN

  SELECT SUM(DECODE(b.ss, 'SC', 1, 0))
    INTO lvi_counter1
    FROM utrqsc a, utsc b
   WHERE a.rq = UNAPIEV.P_RQ
     AND a.sc = b.sc;

  IF lvi_counter1 > 0 THEN
     RETURN (TRUE);
  END IF;

  RETURN (FALSE);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqOneScOSConf;

FUNCTION paBuitenSpecificatie
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paBuitenSpecificatie';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count1      APAOGEN.COUNTER_TYPE;
lvf_result      APAOGEN.VALUE_F_TYPE;
lvf_low       APAOGEN.VALUE_F_TYPE;
lvf_high        APAOGEN.VALUE_F_TYPE;
lvf_dev_low     APAOGEN.VALUE_F_TYPE;
lvf_dev_high    APAOGEN.VALUE_F_TYPE;
lvb_out_of_spec BOOLEAN;
lvb_out_of_target BOOLEAN;

BEGIN
  --------------------------------------------------------------------------------
  -- Retrieve value_f of current parameter
  --------------------------------------------------------------------------------
  SELECT value_f
    INTO lvf_result
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;
  --------------------------------------------------------------------------------
  -- Specificatie evaluatie
  -- Resulaten zijn buiten specificatie indien:
  --    Resultaat < Low spec (set A)
  --    Resultaat > High spec (set A)
  --    Resultaat < Target ¿ abs(low deviation (set A))
  --    Resultaat > Target + high deviation (set A)
  --------------------------------------------------------------------------------
  BEGIN
    SELECT NVL (low_spec, lvf_result), NVL (high_spec, lvf_result)
        INTO lvf_low, lvf_high
        FROM utscpaspa
      WHERE sc = UNAPIEV.P_SC
        AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
        AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;

    lvb_out_of_spec := lvf_result < lvf_low OR lvf_result > lvf_high;

   EXCEPTION
   WHEN NO_DATA_FOUND THEN
     --------------------------------------------------------------------------------
    --  Niet gevulde specificaties leiden niet tot
    --  buiten specificatie en/of buiten waarschuwingsgrenzen
    --------------------------------------------------------------------------------
      lvb_out_of_spec := FALSE;
   END;

  BEGIN
    SELECT NVL (target - ABS(low_dev), lvf_result), NVL (target + high_dev, lvf_result)
        INTO lvf_dev_low, lvf_dev_high
        FROM utscpaspa
      WHERE sc = UNAPIEV.P_SC
        AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
        AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;

    lvb_out_of_target := lvf_result < lvf_dev_low OR lvf_result > lvf_dev_high;

   EXCEPTION
   WHEN NO_DATA_FOUND THEN
     --------------------------------------------------------------------------------
    --  Niet gevulde specificaties leiden niet tot
    --  buiten specificatie en/of buiten waarschuwingsgrenzen
    --------------------------------------------------------------------------------
      lvb_out_of_target := FALSE;
   END;

  IF lvb_out_of_spec OR lvb_out_of_target THEN
    RETURN (TRUE);
   ELSE
    RETURN (FALSE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END paBuitenSpecificatie;

FUNCTION paBinnenSpecificatie
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paBinnenSpecificatie';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;

BEGIN

  RETURN (NOT paBuitenSpecificatie);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END paBinnenSpecificatie;

FUNCTION paBuitenWaarschuwing
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paBuitenWaarschuwing';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count1      APAOGEN.COUNTER_TYPE;
lvf_result      APAOGEN.VALUE_F_TYPE;
lvf_low       APAOGEN.VALUE_F_TYPE;
lvf_high        APAOGEN.VALUE_F_TYPE;
lvb_out_of_limit  BOOLEAN;
BEGIN
  --------------------------------------------------------------------------------
  -- Retrieve value_f of current parameter
  --------------------------------------------------------------------------------
  SELECT value_f
    INTO lvf_result
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;
  --------------------------------------------------------------------------------
  -- Specificatie evaluatie
  --  Resulaten zijn buiten waarschuwingsgrenzen indien:
  --    Resultaat < Low limit (set A)
  --    Resultaat > High limit (set A)
  --------------------------------------------------------------------------------
  BEGIN
    SELECT NVL (low_limit, lvf_result), NVL (high_limit, lvf_result)
        INTO lvf_low, lvf_high
        FROM utscpaspa
      WHERE sc = UNAPIEV.P_SC
        AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
        AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;

    lvb_out_of_limit := lvf_result < lvf_low OR lvf_result > lvf_high;

   EXCEPTION
   WHEN NO_DATA_FOUND THEN
     --------------------------------------------------------------------------------
    --  Niet gevulde specificaties leiden niet tot
    --  buiten specificatie en/of buiten waarschuwingsgrenzen
    --------------------------------------------------------------------------------
    lvb_out_of_limit := FALSE;
   END;

  IF lvb_out_of_limit THEN
    RETURN (TRUE);
   ELSE
    RETURN (FALSE);
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END paBuitenWaarschuwing;

FUNCTION paBinnenWaarschuwing
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paBinnenWaarschuwing';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;

BEGIN

  RETURN (NOT paBuitenWaarschuwing);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END paBinnenWaarschuwing;
--------------------------------------------------------------------------------
-- Internal function
--------------------------------------------------------------------------------
FUNCTION PaResultAvailable
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PaResultAvailable';
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_count1   APAOGEN.COUNTER_TYPE;

BEGIN
   SELECT COUNT (*)
     INTO lvi_count1
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
      AND (value_f IS NOT NULL OR value_s IS NOT NULL);

   RETURN (lvi_count1 = 1);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PaResultAvailable;

FUNCTION MeResultAvailable
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'MeResultAvailable';
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_count1   APAOGEN.COUNTER_TYPE;

BEGIN
   SELECT COUNT (*)
     INTO lvi_count1
     FROM utscme
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
      AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
      AND (value_f IS NOT NULL OR value_s IS NOT NULL);

   RETURN (lvi_count1 = 1);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END MeResultAvailable;

FUNCTION paHasLinkedPa
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paHasLinkedPa';
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_count1   APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT(*)
     INTO lvi_count1
     FROM utscpa a, utscmecelloutput b, utscpa c
    WHERE a.sc = UNAPIEV.P_SC
      AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
      AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
      AND a.sc = b.sc
      AND a.pg = b.pg AND a.pgnode = b.pgnode
      AND a.pa = b.pa AND a.panode = b.panode
      AND a.pa != b.save_pa AND a.panode != b.save_panode
      AND c.sc = a.sc
      AND c.pg = b.save_pg AND c.pgnode = b.save_pgnode
      AND c.pa = b.save_pa AND c.panode = b.save_panode;

   RETURN (lvi_count1 > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END paHasLinkedPa;

FUNCTION paOneLinkedPaOS
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paOneLinkedPaOS';
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_count1   APAOGEN.COUNTER_TYPE;

BEGIN

   IF NOT paHasLinkedPa THEN
      RETURN FALSE;
   END IF;

   SELECT SUM(DECODE(c.ss, 'OS', 1, 0))
     INTO lvi_count1
     FROM utscpa a, utscmecelloutput b, utscpa c
    WHERE a.sc = UNAPIEV.P_SC
      AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
      AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
      AND a.sc = b.sc
      AND a.pg = b.pg AND a.pgnode = b.pgnode
      AND a.pa = b.pa AND a.panode = b.panode
      AND a.pa != b.save_pa AND a.panode != b.save_panode
      AND c.sc = a.sc
      AND c.pg = b.save_pg AND c.pgnode = b.save_pgnode
      AND c.pa = b.save_pa AND c.panode = b.save_panode;

   RETURN (lvi_count1 > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END paOneLinkedPaOS;

FUNCTION paOneLinkedPaOW
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paOneLinkedPaOW';
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_count1   APAOGEN.COUNTER_TYPE;
lvi_count2   APAOGEN.COUNTER_TYPE;

BEGIN

   IF NOT paHasLinkedPa THEN
      RETURN FALSE;
   END IF;

   SELECT SUM(DECODE(c.ss, 'OS', 1, 0)), SUM(DECODE(c.ss, 'OW', 1, 0))
     INTO lvi_count1, lvi_count2
     FROM utscpa a, utscmecelloutput b, utscpa c
    WHERE a.sc = UNAPIEV.P_SC
      AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
      AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
      AND a.sc = b.sc
      AND a.pg = b.pg AND a.pgnode = b.pgnode
      AND a.pa = b.pa AND a.panode = b.panode
      AND a.pa != b.save_pa AND a.panode != b.save_panode
      AND c.sc = a.sc
      AND c.pg = b.save_pg AND c.pgnode = b.save_pgnode
      AND c.pa = b.save_pa AND c.panode = b.save_panode;

   RETURN (lvi_count1 = 0) AND (lvi_count2 > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END paOneLinkedPaOW;

FUNCTION paOneLinkedPaOSConf
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paOneLinkedPaOSConf';
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_count1   APAOGEN.COUNTER_TYPE;
lvi_count2   APAOGEN.COUNTER_TYPE;

BEGIN

   IF NOT paHasLinkedPa THEN
      RETURN FALSE;
   END IF;

   SELECT SUM(DECODE(c.ss, 'OS', 1, 'OW', 1, 0)), SUM(DECODE(c.ss, 'SC', 1, 0))
     INTO lvi_count1, lvi_count2
     FROM utscpa a, utscmecelloutput b, utscpa c
    WHERE a.sc = UNAPIEV.P_SC
      AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
      AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
      AND a.sc = b.sc
      AND a.pg = b.pg AND a.pgnode = b.pgnode
      AND a.pa = b.pa AND a.panode = b.panode
      AND a.pa != b.save_pa AND a.panode != b.save_panode
      AND c.sc = a.sc
      AND c.pg = b.save_pg AND c.pgnode = b.save_pgnode
      AND c.pa = b.save_pa AND c.panode = b.save_panode;

   RETURN (lvi_count1 = 0) AND (lvi_count2 > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END paOneLinkedPaOSConf;

FUNCTION paOneLinkedPaOWConf
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paOneLinkedPaOWConf';
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_count1   APAOGEN.COUNTER_TYPE;
lvi_count2   APAOGEN.COUNTER_TYPE;

BEGIN

   IF NOT paHasLinkedPa THEN
      RETURN FALSE;
   END IF;

   SELECT SUM(DECODE(c.ss, 'OS', 1, 'SC', 1, 'OW', 1, 0)), SUM(DECODE(c.ss, 'WC', 1, 0))
     INTO lvi_count1, lvi_count2
     FROM utscpa a, utscmecelloutput b, utscpa c
    WHERE a.sc = UNAPIEV.P_SC
      AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
      AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
      AND a.sc = b.sc
      AND a.pg = b.pg AND a.pgnode = b.pgnode
      AND a.pa = b.pa AND a.panode = b.panode
      AND a.pa != b.save_pa AND a.panode != b.save_panode
      AND c.sc = a.sc
      AND c.pg = b.save_pg AND c.pgnode = b.save_pgnode
      AND c.pa = b.save_pa AND c.panode = b.save_panode;

   RETURN (lvi_count1 = 0) AND (lvi_count2 > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END paOneLinkedPaOWConf;

---------------------------------------------------------------------------------------
-- For PA's belonging to an outdoor RQ
-- If there is at least 1 PA with the state ‘To Validate’ and all others PA have a state of Completed
-- or Cancelled then return TRUE else FALSE
---------------------------------------------------------------------------------------
FUNCTION paOnePaTV
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paOnePaTV';
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_total	 APAOGEN.COUNTER_TYPE;
lvi_count1   APAOGEN.COUNTER_TYPE;
lvi_count2   APAOGEN.COUNTER_TYPE;

BEGIN
  --------------------------------------------------------------------
  -- If request object
  --------------------------------------------------------------------
  IF UNAPIEV.p_ev_rec.object_tp = 'rq' THEN
	SELECT COUNT(pa.ss)
	    , SUM(DECODE(pa.ss, 'TV', 1, 0))
	    , SUM(DECODE(pa.ss, 'CM', 1,
							'@C', 1, 0))
	  INTO lvi_total, lvi_count1, lvi_count2
	  FROM utrqsc     rq
		 , utscpa     pa
	  WHERE rq.rq = UNAPIEV.P_RQ
		AND pa.sc = rq.sc;
	IF (lvi_total > 0) AND (lvi_count1 > 0) AND (lvi_total = lvi_count1 + lvi_count2) THEN
		RETURN (TRUE);
	END IF;

  --------------------------------------------------------------------
  -- If worksheet object
  --------------------------------------------------------------------
  ELSIF UNAPIEV.p_ev_rec.object_tp = 'ws' THEN
 	APAOGEN.LogError (lcs_function_name, 'Debug-JR,  RecheckWS: ' || UNAPIEV.P_WS);
	-----------------------------------------------------------
	-- For the SC’s belonging to the WS
	-- With a PA with a ME which equals to the WS groupkey avTestmethod
	-----------------------------------------------------------
	SELECT COUNT(pa.ss)
	    , SUM(DECODE(pa.ss, 'TV', 1, 0))
	    , SUM(DECODE(pa.ss, 'CM', 1,
							'@C', 1, 0))
		   INTO lvi_total, lvi_count1, lvi_count2
           FROM utwssc     ws
		      , utscpa     pa
			  , utscme     me
		      , utwsgkavTestMethod   wsgk
		      , utscmegkavTestMethod megk
		  WHERE ws.ws = UNAPIEV.P_WS
			AND pa.sc = ws.sc
		    AND me.sc = pa.sc
			AND me.pg = pa.pg   AND me.pgnode = pa.pgnode
    		AND me.pa = pa.pa   AND me.panode = pa.panode
			AND megk.sc = me.sc
			AND megk.pg = me.pg AND megk.pgnode = me.pgnode
			AND megk.pa = me.pa AND megk.panode = me.panode
			AND megk.me = me.me AND megk.menode	= me.menode
			AND megk.avtestmethod = wsgk.avtestmethod
			AND ws.ws = wsgk.ws;

	IF (lvi_total > 0) AND (lvi_count1 > 0) AND (lvi_total = lvi_count1 + lvi_count2) THEN
		RETURN (TRUE);
	END IF;

  END IF;
  RETURN (FALSE);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END paOnePaTV;

FUNCTION PaCustomReanalysis
RETURN BOOLEAN IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PaCustomReanalysis';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   BEGIN
      --------------------------------------------------------------------------------
      -- Save reanalysis details
      --------------------------------------------------------------------------------
      INSERT
        INTO utrscpa
      SELECT *
        FROM UTSCPA
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;

      --------------------------------------------------------------------------------
      -- Add commment
      --------------------------------------------------------------------------------
      lvi_ret_code := APAOFUNCTIONS.ADDSCPACOMMENT(UNAPIEV.P_SC,
                                                   UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                   UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                   'Custom reanalyse by ' || lcs_function_name);
      --------------------------------------------------------------------------------
      -- Simulate reanalyse
      --------------------------------------------------------------------------------
      UPDATE utscpa
         SET value_s = NULL,
             value_f = NULL,
             reanalysis = reanalysis + 1,
             exec_end_date =  NULL
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;

   EXCEPTION
     WHEN OTHERS THEN
        NULL;
   END;

   RETURN TRUE;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;

END PaCustomReanalysis;

FUNCTION paReanalysis
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paReanalysis';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;

BEGIN

  IF UNAPIEV.P_EV_REC.ev_tp = 'PaReanalysis' THEN
      RETURN TRUE;
  ELSE
      RETURN FALSE;
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;

END paReanalysis;

FUNCTION meReanalysis
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'meReanalysis';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;

BEGIN

  IF UNAPIEV.P_EV_REC.ev_tp = 'MeReanalysis' THEN
      RETURN TRUE;
  ELSE
      RETURN FALSE;
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;

END meReanalysis;

FUNCTION paAllMeFinished
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paAllMeFinished';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;

BEGIN

  SELECT COUNT(*)
    INTO lvi_count
    FROM utscme
   WHERE sc = UNAPIEV.P_SC
     AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
     AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
     AND ss NOT IN (ics_ss_completed, ics_ss_cancelled, ics_ss_irrelevant);

  RETURN (lvi_count = 0 );

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;

END paAllMeFinished;

FUNCTION paSkipOutOfSpec
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PaSkipOutOfSpec';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;

CURSOR lvq_pp(avs_au IN VARCHAR2) IS
  SELECT a.pp, a.version, a.au, a.value
    FROM utppau a, utscpg b
   WHERE b.sc = UNAPIEV.P_SC
     AND b.pg = UNAPIEV.P_PG   AND b.pgnode = UNAPIEV.P_PGNODE
     AND b.pg = a.pp           AND b.pp_version = a.version
     AND b.pp_key1 = a.pp_key1 AND b.pp_key2 = a.pp_key2 AND b.pp_key3 = a.pp_key3 AND b.pp_key4 = a.pp_key4 AND b.pp_key5 = a.pp_key5
     AND a.au = avs_au
  UNION
  SELECT a.pp, a.version, a.au, a.value
    FROM utppprau a, utscpg b
   WHERE b.sc = UNAPIEV.P_SC
     AND b.pg = UNAPIEV.P_PG   AND b.pgnode = UNAPIEV.P_PGNODE
     AND b.pg = a.pp           AND b.pp_version = a.version
     AND b.pp_key1 = a.pp_key1 AND b.pp_key2 = a.pp_key2 AND b.pp_key3 = a.pp_key3 AND b.pp_key4 = a.pp_key4 AND b.pp_key5 = a.pp_key5
     AND a.pr = UNAPIEV.P_PA
     AND a.au = avs_au;

BEGIN

   FOR lvr_pp IN lvq_pp('avCustSkipConfirmOOS') LOOP
      RETURN TRUE;
   END LOOP;

   RETURN FALSE;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;

END PaSkipOutOfSpec;

FUNCTION PaSkipOutOfWarning
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PaSkipOutOfWarning';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;

CURSOR lvq_pp(avs_au IN VARCHAR2) IS
  SELECT a.pp, a.version, a.au, a.value
    FROM utppau a, utscpg b
   WHERE b.sc = UNAPIEV.P_SC
     AND b.pg = UNAPIEV.P_PG   AND b.pgnode = UNAPIEV.P_PGNODE
     AND b.pg = a.pp           AND b.pp_version = a.version
     AND b.pp_key1 = a.pp_key1 AND b.pp_key2 = a.pp_key2 AND b.pp_key3 = a.pp_key3 AND b.pp_key4 = a.pp_key4 AND b.pp_key5 = a.pp_key5
     AND a.au = avs_au
  UNION
  SELECT a.pp, a.version, a.au, a.value
    FROM utppprau a, utscpg b
   WHERE b.sc = UNAPIEV.P_SC
     AND b.pg = UNAPIEV.P_PG   AND b.pgnode = UNAPIEV.P_PGNODE
     AND b.pg = a.pp           AND b.pp_version = a.version
     AND b.pp_key1 = a.pp_key1 AND b.pp_key2 = a.pp_key2 AND b.pp_key3 = a.pp_key3 AND b.pp_key4 = a.pp_key4 AND b.pp_key5 = a.pp_key5
     AND a.pr = UNAPIEV.P_PA
     AND a.au = avs_au;

BEGIN

   FOR lvr_pp IN lvq_pp('avCustSkipConfirmOOW') LOOP
      RETURN TRUE;
   END LOOP;

   RETURN FALSE;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;

END PaSkipOutOfWarning;

FUNCTION paAllMeCancelled
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'paAllMeCancelled';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count_total     APAOGEN.COUNTER_TYPE;
lvi_count_cancelled APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT(*),
          SUM(DECODE(ss, '@C', 1, 0))
     INTO lvi_count_total,
          lvi_count_cancelled
     FROM utscme
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;

   IF (lvi_count_total = lvi_count_cancelled) AND
      (lvi_count_cancelled > 0) THEN
      RETURN TRUE;
   END IF;

   RETURN FALSE ;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;

END paAllMeCancelled;

FUNCTION scAllPaFinished
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'scAllPaFinished';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;
lvi_totcounter    APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT (*),
          COUNT (DECODE (ss,  ics_ss_completed    ,1,
                              ics_ss_cancelled    ,1,
							  'TV'                ,1))	-- TV = To Validate
     INTO lvi_totcounter, lvi_counter1
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC;

   IF lvi_totcounter = lvi_counter1 AND lvi_totcounter > 0 THEN
      RETURN TRUE;
   END IF;

   RETURN FALSE;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;
END scAllPaFinished;

FUNCTION scOnePaOWConf
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'scOnePaOWConf';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;
lvi_counter2      APAOGEN.COUNTER_TYPE;
lvi_totcounter    APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT (*),
          COUNT (DECODE (ss, ics_ss_completed            ,1,
                             ics_ss_out_of_warning_conf  ,1,
                             ics_ss_cancelled            ,1)),
          COUNT (DECODE (ss, ics_ss_out_of_warning_conf  ,1))
     INTO lvi_totcounter, lvi_counter1, lvi_counter2
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC;

   IF lvi_totcounter = lvi_counter1 AND lvi_counter2 > 0 THEN
      RETURN TRUE;
   END IF;

   RETURN FALSE;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;
END scOnePaOWConf;

FUNCTION scOnePaOSConf
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'scOnePaOSConf';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;
lvi_counter2      APAOGEN.COUNTER_TYPE;
lvi_totcounter    APAOGEN.COUNTER_TYPE;

BEGIN
  SELECT COUNT (*),
          COUNT (DECODE (ss, ics_ss_completed            ,1,
                             ics_ss_out_of_warning_conf  ,1,
                             ics_ss_out_of_spec_conf     ,1,
                             ics_ss_cancelled            ,1)),
          COUNT (DECODE (ss, ics_ss_out_of_spec_conf     ,1))
     INTO lvi_totcounter, lvi_counter1, lvi_counter2
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC;

   IF lvi_totcounter = lvi_counter1 AND lvi_counter2 > 0 THEN
      RETURN TRUE;
   END IF;

   RETURN FALSE;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;
END scOnePaOSConf;

FUNCTION scOnePaOS
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'scOnePaOS';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT (DECODE (ss,ics_ss_out_of_spec  ,1))
     INTO lvi_counter1
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC;

   IF lvi_counter1 > 0 THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;
END scOnePaOS;

FUNCTION scOnePaOW
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'scOnePaOW';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT (DECODE (ss,ics_ss_out_of_warning  ,1))
     INTO lvi_counter1
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC;

   IF lvi_counter1 > 0 THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;
END scOnePaOW;

FUNCTION scOnePaAV
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'scOnePaAV';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT (DECODE (ss,ics_ss_available ,1))
     INTO lvi_counter1
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC;

   IF lvi_counter1 > 0 THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;
END scOnePaAV;

FUNCTION scInitialToPlanned
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'scInitialToPlanned';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;

BEGIN

    SELECT COUNT(*)
     INTO lvi_counter1
     FROM utstau a, utsc b
    WHERE a.st = b.st AND a.version = b.st_version
      AND b.sc = UNAPIEV.P_SC
      AND a.au = 'avCustSsFromInitial'
      AND a.value = '@P';

   IF lvi_counter1 > 0 THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;
END scInitialToPlanned;

FUNCTION ScManualAvScGk
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ScManualAvScGk';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN

  SELECT COUNT(*)
    INTO lvi_counter1
    FROM utscgkmanual2available
   WHERE sc = UNAPIEV.P_SC
     AND manual2available = '1';

  IF lvi_counter1 > 0 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END ScManualAvScGk;

FUNCTION ScManualAvSc
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ScManualAvSc';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN

  SELECT COUNT(*)
    INTO lvi_counter1
    FROM utscau
   WHERE sc = UNAPIEV.P_SC
     AND au = 'avCustScManual2AV'
     AND value = '1';

  IF lvi_counter1 > 0 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END ScManualAvSc;

FUNCTION ScHasRq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ScHasRq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter1    APAOGEN.COUNTER_TYPE;

BEGIN

  SELECT COUNT(*)
    INTO lvi_counter1
    FROM utrqsc
   WHERE sc = UNAPIEV.P_SC;

  IF lvi_counter1 > 0 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END ScHasRq;

FUNCTION ScUABasedError
RETURN BOOLEAN IS


lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ScUABasedError';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter_total    APAOGEN.COUNTER_TYPE;
lvi_counter_found    APAOGEN.COUNTER_TYPE;
lvb_uabased_conf_and_found BOOLEAN := FALSE;
lvb_pa_assigned            BOOLEAN := FALSE;

CURSOR lvq_mt(avs_pa IN VARCHAR2,
              avs_version IN VARCHAR2) IS
  SELECT mt
    FROM utprmt
   WHERE freq_tp = 'C' and freq_unit  = 'UAbased'
     AND pr = avs_pa AND version = avs_version;

CURSOR lvq_pa IS
   SELECT *
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC;

BEGIN

  lvi_counter_total := 0;
  -----------------------------------------------------------------------------
  -- Loop through all parameters of current sample
  -----------------------------------------------------------------------------
  FOR lvr_pa IN lvq_pa LOOP
      lvb_pa_assigned := TRUE;
      -----------------------------------------------------------------------------
      -- loop through all methods with frequency UAbased
      -----------------------------------------------------------------------------
      FOR lvr_mt IN lvq_mt(lvr_pa.pa, lvr_pa.pr_version) LOOP
          lvb_uabased_conf_and_found := TRUE;
          -----------------------------------------------------------------------------
          -- check if method has been assigned
          -----------------------------------------------------------------------------
          SELECT count(*)
            INTO lvi_counter_found
            FROM utscme
           WHERE sc = UNAPIEV.P_SC
             AND pg = lvr_pa.pg AND pgnode = lvr_pa.pgnode
             AND pa = lvr_pa.pa AND panode = lvr_pa.panode
             AND me = lvr_mt.mt;

           -----------------------------------------------------------------------------
           -- add nr of methods found to counter_total
           -----------------------------------------------------------------------------
           lvi_counter_total := lvi_counter_total + lvi_counter_found;

      END LOOP;
  END LOOP;

  IF NOT lvb_pa_assigned THEN
     RETURN (FALSE);
  END IF;

  IF NOT lvb_uabased_conf_and_found THEN
     RETURN (FALSE);
  END IF;

  -----------------------------------------------------------------------------
  -- if parameters has been assigned AND
  -- uabased frequency has been configured AND
  -- if we found at least 1 method, frequency uabased has been executed succesfully
  -----------------------------------------------------------------------------
  IF lvi_counter_total > 0 THEN
     RETURN (FALSE);
  ELSE
     RETURN (TRUE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END ScUABasedError;

FUNCTION MeScIsCancelled
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'MeScIsCancelled';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;

BEGIN

  SELECT COUNT(*)
    INTO lvi_count
    FROM utsc
   WHERE sc = UNAPIEV.P_SC AND ss = '@C';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END MeScIsCancelled;

FUNCTION PrNewFromInterspec
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PrNewFromInterspec';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pr            APAOGEN.PR_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_pr         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utprhs
   WHERE pr = lvs_pr AND version = lvs_version
     AND why LIKE 'Imported parameter "' || lvs_pr || '" from Interspec %';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PrNewFromInterspec;

FUNCTION PpNewFromInterspec
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpNewFromInterspec';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utpphs
   WHERE pp = lvs_pp AND version = lvs_version
     AND pp_key1 = lvs_pp_key1 AND pp_key2 = lvs_pp_key2 AND pp_key3 = lvs_pp_key3 AND pp_key4 = lvs_pp_key4 AND pp_key5 = lvs_pp_key5
     AND why LIKE 'Imported parameter profile "' || lvs_pp || '" from Interspec %';

  RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpNewFromInterspec;

FUNCTION StNewFromInterspec
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StNewFromInterspec';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_st            APAOGEN.ST_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utsths
   WHERE st = lvs_st AND version = lvs_version
     AND why LIKE 'Imported sample type "' || st || '" from Interspec %';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StNewFromInterspec;

--------------------------------------------------------------------------------
-- FUNCTION : StTemplateHasManualFreq
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
FUNCTION StTemplateHasManualFreq
RETURN BOOLEAN IS

lcs_function_name  CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StTemplateHasManualFreq';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_count          NUMBER;
lvs_st             APAOGEN.ST_TYPE;
lvs_version        APAOGEN.VERSION_TYPE;
lvs_template       APAOACTION.Template_Type;
lvs_spectype       VARCHAR2(40);
lvb_correct_config BOOLEAN;
BEGIN

  lvs_st       := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version  := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  lvs_spectype := APAOACTION.GETSTSPECTYPE(lvs_st, lvs_version);
  lvs_template := APAOACTION.FINDSPECTYPETEMPLATE (lvs_st, lvs_version, lvs_spectype, lvb_correct_config);


  SELECT COUNT(*)
    INTO lvi_count
    FROM utstpp
   WHERE st = lvs_template.template AND version = lvs_template.version
     AND freq_tp = 'C' AND freq_unit = 'Manual';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StTemplateHasManualFreq;

FUNCTION PpTemplateHasManualFreq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpTemplateHasManualFreq';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);
lvs_template      APAOACTION.TEMPLATE_TYPE;

CURSOR lvq_pp(avs_st          IN VARCHAR2,
              avs_st_version  IN VARCHAR2,
              avs_pp_key1     IN VARCHAR2,
              avs_pp_key2     IN VARCHAR2,
              avs_pp_key3     IN VARCHAR2,
              avs_pp_key4     IN VARCHAR2,
              avs_pp_key5     IN VARCHAR2) IS
SELECT pp, version,
       pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
  FROM utstpp
 WHERE st = avs_st
   AND version = avs_st_version
   AND pp_key1 = avs_pp_key1 AND pp_key2 = avs_pp_key2 AND pp_key3 = avs_pp_key3 AND pp_key4 = avs_pp_key4 AND pp_key5 = avs_pp_key5;

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  lvs_template := APAOACTION.FINDPPTEMPLATE ( lvs_pp, lvs_version, lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utstpp a, utpp b, utpppr c
   WHERE a.st = lvs_template.template AND a.version = lvs_template.version
     AND a.pp = lvs_pp
     AND b.pp_key1 = lvs_pp_key1 AND b.pp_key2 = lvs_pp_key2 AND b.pp_key3 = lvs_pp_key3 AND b.pp_key4 = lvs_pp_key4 AND b.pp_key5 = lvs_pp_key5
     AND b.version IN (SELECT MAX(d.version)
                         FROM utpp d
                        WHERE d.pp_key1 = b.pp
                          AND d.pp = b.pp_key1
                          AND d.version_is_current = 1
                        UNION
                       SELECT MAX(e.version)
                         FROM utpp e
                        WHERE e.pp_key1 = b.pp
                          AND e.pp = b.pp_key1
                          AND e.version_is_current IS NULL)
     AND a.pp = b.pp AND b.pp = c.pp AND b.version = c.version
     AND b.pp_key1 = c.pp_key1
     AND c.freq_tp = 'C' AND c.freq_unit = 'Manual';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpTemplateHasManualFreq;

FUNCTION StHasManualFreq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StHasManualFreq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_st            APAOGEN.ST_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utstpp
   WHERE st = lvs_st AND version = lvs_version
     AND freq_tp = 'C' AND freq_unit = 'Manual';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StHasManualFreq;

FUNCTION PpHasManualFreq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpHasManualFreq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utpppr
   WHERE pp = lvs_pp AND version = lvs_version
     AND pp_key1 = lvs_pp_key1 AND pp_key2 = lvs_pp_key2 AND pp_key3 = lvs_pp_key3 AND pp_key4 = lvs_pp_key4 AND pp_key5 = lvs_pp_key5
     AND freq_tp = 'C' AND freq_unit = 'Manual';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpHasManualFreq;

--------------------------------------------------------------------------------
-- FUNCTION : StTemplateHasCustomFreq
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
FUNCTION StTemplateHasCustomFreq
RETURN BOOLEAN IS

lcs_function_name  CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StTemplateHasCustomFreq';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_count          NUMBER;
lvs_st             APAOGEN.ST_TYPE;
lvs_version        APAOGEN.VERSION_TYPE;
lvs_template       APAOACTION.Template_Type;
lvs_spectype       VARCHAR2(40);
lvb_correct_config BOOLEAN;
BEGIN

  lvs_st       := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version  := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  lvs_spectype := APAOACTION.GETSTSPECTYPE(lvs_st, lvs_version);
  lvs_template := APAOACTION.FINDSPECTYPETEMPLATE (lvs_st, lvs_version, lvs_spectype, lvb_correct_config);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utstpp
   WHERE st = lvs_template.template AND version = lvs_template.version
     AND freq_tp = 'C' AND freq_unit != 'Manual';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StTemplateHasCustomFreq;

FUNCTION StHasCustomFreq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StHasCustomFreq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_st            APAOGEN.ST_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utstpp
   WHERE st = lvs_st AND version = lvs_version
     AND freq_tp = 'C' AND freq_unit != 'Manual';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StHasCustomFreq;

FUNCTION PpHasCustomFreq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpHasCustomFreq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utpppr
   WHERE pp = lvs_pp AND version = lvs_version
     AND pp_key1 = lvs_pp_key1 AND pp_key2 = lvs_pp_key2 AND pp_key3 = lvs_pp_key3 AND pp_key4 = lvs_pp_key4 AND pp_key5 = lvs_pp_key5
     AND freq_tp = 'C' AND freq_unit != 'Manual';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpHasCustomFreq;

FUNCTION StCreatedByUNDIFF
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StCreatedByUNDIFF';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_st            APAOGEN.ST_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utsths
   WHERE st = lvs_st AND version = lvs_version
     AND what = 'UNDIFF generated new version';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StCreatedByUNDIFF;

FUNCTION PpCreatedByUNDIFF
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpCreatedByUNDIFF';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utpphs
   WHERE pp = lvs_pp AND version = lvs_version
     AND what = 'UNDIFF generated new version(1)'
     AND pp_key1 = lvs_pp_key1 AND pp_key2 = lvs_pp_key2 AND pp_key3 = lvs_pp_key3 AND pp_key4 = lvs_pp_key4 AND pp_key5 = lvs_pp_key5;

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpCreatedByUNDIFF;

FUNCTION PpStReevalTrigger
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpStReevalTrigger';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;

BEGIN

  RETURN (FALSE);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpStReevalTrigger;

FUNCTION AutoConfigureSpecType(avs_spec_type IN APAOGEN.GKVALUE_TYPE)
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'AutoConfigureSpecType';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;

BEGIN

   SELECT COUNT(*)
     INTO lvi_count
     FROM utstau b, utst c, utstgkspec_type d
    WHERE b.au = 'avCustInterspecTp'
      AND b.st = c.st AND b.version = c.version
      AND c.version_is_current = 1
      AND c.st = d.st AND c.version = d.version
      AND d.spec_type = avs_spec_type;

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END AutoConfigureSpecType;

FUNCTION PrHasTemplate
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PrHasTemplate';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pr            APAOGEN.PR_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvr_template      APAOACTION.Template_Type;
BEGIN

  lvs_pr       := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version  := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  lvr_template := APAOACTION.FindPrTemplate (lvs_pr, lvs_version);

  RETURN (lvr_template.template IS NOT NULL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PrHasTemplate;

FUNCTION StTriggerCurrentInInterspec
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StTriggerCurrentInInterspec';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;

BEGIN

  RETURN (TRUE);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StTriggerCurrentInInterspec;

FUNCTION StInterspecStatusIsQr5
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StInterspecStatusIsQr5';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_st            APAOGEN.ST_TYPE;

BEGIN

  lvs_st       := UNAPIEV.P_EV_REC.OBJECT_ID;

  SELECT COUNT(*)
    INTO lvi_count
    FROM specification_header@interspec a, status@interspec b
   WHERE a.status = b.status
     AND b.sort_desc LIKE '%QR5%'
     AND a.part_no = lvs_st;

  RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StInterspecStatusIsQr5;

FUNCTION StAllPpsConfigured
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StAllPpsConfigured';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_st            APAOGEN.ST_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_st       := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version  := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utpp
   WHERE (pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, version) IN
         (SELECT b.pp, b.pp_key1, b.pp_key2, b.pp_key3, b.pp_key4, b.pp_key5, MAX(b.version)
            FROM utstpp a, utpp b
           WHERE a.st = lvs_st AND a.version = lvs_version
             AND a.pp = b.pp
             AND a.pp_key1 = b.pp_key1 AND a.pp_key2 = b.pp_key2 AND a.pp_key3 = b.pp_key3 AND a.pp_key4 = b.pp_key4 AND a.pp_key5 = b.pp_key5
        GROUP BY b.pp, b.pp_key1, b.pp_key2, b.pp_key3, b.pp_key4, b.pp_key5)
     AND ss NOT IN ('CF', '@A');

  RETURN (lvi_count = 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StAllPpsConfigured;

FUNCTION StFirstMajor
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StFirstMajor';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvs_st            APAOGEN.ST_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvi_count         NUMBER;

BEGIN

  lvs_st       := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version  := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  --------------------------------------------------------------------------------
  -- Does current st have minor versions ?
  --------------------------------------------------------------------------------
  SELECT COUNT(*)
    INTO lvi_count
    FROM utst
   WHERE st = lvs_st
     AND TO_NUMBER(SUBSTR(version, -2)) <> 0;

  RETURN (lvi_count = 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StFirstMajor;

FUNCTION StCreatedByStApplyTemplate
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StCreatedByStApplyTemplate';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_st            APAOGEN.ST_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utsths
   WHERE st = lvs_st AND version = lvs_version
     AND what = 'ObjectCreated'
     AND why LIKE 'Version created by <apaoaction.StApplyTemplate> based on template %';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StCreatedByStApplyTemplate;


FUNCTION PpCreatedByStApplyTemplate
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpCreatedByStApplyTemplate';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utpphs
    WHERE pp = lvs_pp AND version = lvs_version
      AND pp_key1 = lvs_pp_key1 AND pp_key2 = lvs_pp_key2 AND pp_key3 = lvs_pp_key3 AND pp_key4 = lvs_pp_key4 AND pp_key5 = lvs_pp_key5
      AND what = 'ObjectCreated'
      AND why LIKE 'Synchronized by <apaoaction.StApplyTemplate> based on template %';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpCreatedByStApplyTemplate;

FUNCTION StCreatedByStPpApplyISFreq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StCreatedByStPpApplyISFreq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_st            APAOGEN.ST_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utsths
   WHERE st = lvs_st AND version = lvs_version
     AND what = 'ObjectCreated'
     AND why LIKE 'Version created by <apaoaction.StPpApplyInterspecFreq> based on %';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StCreatedByStPpApplyISFreq;

FUNCTION PpCreatedByPpPrApplyISFreq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpCreatedByPpPrApplyISFreq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utpphs
   WHERE pp = lvs_pp AND version = lvs_version
     AND pp_key1 = lvs_pp_key1 AND pp_key2 = lvs_pp_key2 AND pp_key3 = lvs_pp_key3 AND pp_key4 = lvs_pp_key4 AND pp_key5 = lvs_pp_key5
     AND what = 'ObjectCreated'
     AND why LIKE 'Version created by <apaoaction.PpPrApplyInterspecFreq> based on %';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpCreatedByPpPrApplyISFreq;

FUNCTION StIsTemplate
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StIsTemplate';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_st            APAOGEN.ST_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  --APAOGEN.LogError (lcs_function_name, UNAPIEV.P_EV_REC.OBJECT_ID || '=>' || UNAPIEV.P_EV_REC.EV_DETAILS);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utstau
   WHERE st = lvs_st AND version = lvs_version
     AND au = 'avCustInterspecTp';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StIsTemplate;

--------------------------------------------------------------------------------
-- FUNCTION : PpIsTemplate
-- ABSTRACT : This function checks whether the given parameter profile is part
--            of a sampletype which is defined as a template
--------------------------------------------------------------------------------
--   WRITER : xx
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
-- 28/04/2016 | AF        | Solved a bug where the parameter profile version was
--                          equaled to the sampletype version
--------------------------------------------------------------------------------
FUNCTION PpIsTemplate
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpIsTemplate';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utstpp b, utstau c, utst d
   WHERE b.pp = lvs_pp
     AND b.pp_key1 = lvs_pp_key1 AND b.pp_key2 = lvs_pp_key2 AND b.pp_key3 = lvs_pp_key3 AND b.pp_key4 = lvs_pp_key4 AND b.pp_key5 = lvs_pp_key5
     AND b.st  = c.st AND b.version = c.version
     AND b.st = d.st AND b.version = d.version AND d.version_is_current = '1'
     AND au = 'avCustInterspecTp';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpIsTemplate;

FUNCTION PpFirstMajor
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpFirstMajor';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvi_count         NUMBER;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  --------------------------------------------------------------------------------
  -- Does current pp have minor versions ?
  --------------------------------------------------------------------------------
  SELECT COUNT(*)
    INTO lvi_count
    FROM utpp
   WHERE pp = lvs_pp
     AND pp_key1 = lvs_pp_key1 AND pp_key2 = lvs_pp_key2 AND pp_key3 = lvs_pp_key3 AND pp_key4 = lvs_pp_key4 AND pp_key5 = lvs_pp_key5
     AND TO_NUMBER(SUBSTR(version, -2)) <> 0;

  RETURN (lvi_count = 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpFirstMajor;

FUNCTION PpCreatedByPpApplyTemplate
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpCreatedByPpApplyTemplate';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utpphs
   WHERE pp = lvs_pp AND version = lvs_version
     AND pp_key1 = lvs_pp_key1 AND pp_key2 = lvs_pp_key2 AND pp_key3 = lvs_pp_key3 AND pp_key4 = lvs_pp_key4 AND pp_key5 = lvs_pp_key5
     AND what = 'ObjectCreated'
     AND why LIKE 'Version created by <apaoaction.PpApplyTemplate> based on template %';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpCreatedByPpApplyTemplate;


FUNCTION PrIsTemplate
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PrIsTemplate';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pr            APAOGEN.PR_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_pr         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utprau
   WHERE pr = lvs_pr AND version = lvs_version
     AND au = 'interspec_orig_name';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PrIsTemplate;

FUNCTION PrFirstMajor
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PrFirstMajor';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvs_pr            APAOGEN.PR_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvi_count         NUMBER;

BEGIN

  lvs_pr       := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version  := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  --------------------------------------------------------------------------------
  -- Does current pr have minor versions ?
  --------------------------------------------------------------------------------
  SELECT COUNT(*)
    INTO lvi_count
    FROM utpr
   WHERE pr = lvs_pr
     AND TO_NUMBER(SUBSTR(version, -2)) <> 0;

  RETURN (lvi_count = 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PrFirstMajor;

FUNCTION PrCreatedByPrApplyTemplate
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PrCreatedByPrApplyTemplate';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pr            APAOGEN.PR_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_pr         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utprhs
   WHERE pr = lvs_pr AND version = lvs_version
     AND what = 'ObjectCreated'
     AND why LIKE 'Version created by <apaoaction.PrApplyTemplate> based on template %';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PrCreatedByPrApplyTemplate;

FUNCTION PrCreatedByPrNewMinor
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PrCreatedByPrNewMinor';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pr            APAOGEN.PR_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_pr         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utprhs
   WHERE pr = lvs_pr AND version = lvs_version
     AND what = 'ObjectCreated'
     AND why = 'Created by <UNACTION.PR_A02>';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PrCreatedByPrNewMinor;

FUNCTION PpTemplateHasCustomFreq
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpTemplateHasCustomFreq';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);
lvs_template      APAOACTION.TEMPLATE_TYPE;

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  lvs_template := APAOACTION.FINDPPTEMPLATE ( lvs_pp, lvs_version, lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utpppr
   WHERE pp = lvs_template.template AND version = lvs_template.version
     AND pp_key1 = lvs_template.pp_key1 AND pp_key2 = lvs_template.pp_key2 AND pp_key3 = lvs_template.pp_key3 AND pp_key4 = lvs_template.pp_key4 AND pp_key5 = lvs_template.pp_key5
     AND freq_tp = 'C' AND freq_unit != 'Manual';

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpTemplateHasCustomFreq;

--------------------------------------------------------------------------------
-- FUNCTION : StUseTemplate
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
FUNCTION StUseTemplate
RETURN BOOLEAN IS

lcs_function_name  CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StUseTemplate';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_count          NUMBER;
lvs_st             APAOGEN.ST_TYPE;
lvs_version        APAOGEN.VERSION_TYPE;
lvs_template       APAOACTION.Template_Type;
lvs_spectype       VARCHAR2(40);
lvb_correct_config BOOLEAN;
BEGIN

  lvs_st       := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version  := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  lvs_spectype := APAOACTION.GETSTSPECTYPE(lvs_st, lvs_version);
  lvs_template := APAOACTION.FINDSPECTYPETEMPLATE (lvs_st, lvs_version, lvs_spectype, lvb_correct_config);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utstau
   WHERE st = lvs_template.template AND version = lvs_template.version
     AND au = 'avCustUseTemplate'
     AND value = 1;

   RETURN (lvi_count > 0);


EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END StUseTemplate;


FUNCTION PpUseTemplate
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpUseTemplate';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);
lvs_template      APAOACTION.Template_Type;

BEGIN

  lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
  lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
  lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
  lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
  lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

  lvs_template := APAOACTION.FINDPPTEMPLATE ( lvs_pp, lvs_version, lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5);

  SELECT COUNT(*)
    INTO lvi_count
    FROM utppau
   WHERE pp = lvs_template.template AND version = lvs_template.version
     AND pp_key1 = lvs_template.pp_key1 AND pp_key2 = lvs_template.pp_key2 AND pp_key3 = lvs_template.pp_key3 AND pp_key4 = lvs_template.pp_key4 AND pp_key5 = lvs_template.pp_key5
     AND au = 'avCustUseTemplate'
     AND value = 1;

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END PpUseTemplate;

FUNCTION icToPIBS
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'icToPIBS';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;

lvi_filled  NUMBER;
lvi_total   NUMBER;
BEGIN

   SELECT SUM(DECODE(iivalue, NULL, 0, 1)), COUNT(*)
     INTO lvi_filled, lvi_total
     FROM utscii
    WHERE sc = UNAPIEV.P_SC
      AND ic = UNAPIEV.P_IC AND icnode = UNAPIEV.P_ICNODE;

    IF lvi_total = lvi_filled THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END icToPIBS;

FUNCTION RqRtIsOutdoor
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqRtIsOutdoor';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;

CURSOR lvq_rt IS
SELECT rt
  FROM utrq
 WHERE rq = UNAPIEV.P_RQ;

BEGIN

  FOR lvr_rt IN lvq_rt LOOP
      --IF lvr_rt.rt = 'T-T: PCT Outdoor' THEN
      IF INSTR(lvr_rt.rt, 'T-T: PCT Outdoor') > 0 THEN
         RETURN (TRUE);
      ELSE
         RETURN (FALSE);
      END IF;
  END LOOP;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END RqRtIsOutdoor;

-- 12/05/2016 | JR        | Added RqToAvailable
FUNCTION RqToAvailable
RETURN BOOLEAN IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RqToAvailable';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_counter_rqau  APAOGEN.COUNTER_TYPE;
lvi_au_value      APAOGEN.AUVALUE_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;
BEGIN
  --INIT
  lvi_counter1 := 0;
  
  --Check if the CURRENT Request has an attribute avCustToAvailable
  BEGIN
    SELECT COUNT(*), au.value
    INTO lvi_counter_rqau, lvi_au_value
    FROM utrqau  au
    WHERE au.rq        = UNAPIEV.P_RQ            --'DSA2135004T'
    AND   au.au        = 'avCustToAvailable'
    GROUP by au.value
    ;
	--indien rqau bestaat dan overruled deze rtau-waarde.
	--Indien au-value = <null> dan result=FALSE, en kijken we niet verder naar rtau.
	if  lvi_counter_rqau    > 0
	and nvl(lvi_au_value,0) = 1
	then  lvi_counter1 := 1;   --TRUE
	else  lvi_counter1 := 0;   --FALSE
    end if;
    --	
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN 
      --Check in the CONFIGURATION on the CURRENT Request Type if the
      --attribute avCustToAvailable is present with the value 1
	  --If count=0 (if value=0, or AU not EXISTS) then RESULT=FALSE.
      SELECT COUNT(*)
	  INTO lvi_counter1
      FROM utrq   rq
      ,    utrtau au
      WHERE rq.rq         = UNAPIEV.P_RQ          --'DSA2135004T'
      AND   au.rt         = rq.rt
      AND   au.version    = rq.rt_version
      AND   au.au         = 'avCustToAvailable'
      AND   au.value      = '1'
      ;
  END;	
  --
  IF nvl(lvi_counter1,0) > 0 
  THEN  RETURN (TRUE);
  ELSE  RETURN (FALSE);
  END IF;
  --
EXCEPTION
  WHEN OTHERS 
  THEN
    IF SQLCODE != 1 
	THEN APAOGEN.LogError (lcs_function_name, SQLERRM);
    END IF;
    RETURN FALSE;
END RqToAvailable;

--------------------------------------------------------------------------------
-- FUNCTION : PpInTemplateWithPpKey1
-- ABSTRACT : This function checks whether the PP is present in a template with
--            a filled PP_KEY1
--------------------------------------------------------------------------------
--   WRITER : Arie Frans Kok
-- REVIEWER :
--     DATE : 29/03/2016
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
-- 29/03/2016 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION PpInTemplateWithPpKey1
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PpInTemplateWithPpKey1';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_template1 (avs_st IN VARCHAR2) IS
   SELECT c.st, c.version, a.spec_type
     FROM utstgkspec_type a, utstau b, utst c, utstgkspec_type d
    WHERE a.st = avs_st
      AND a.version = (SELECT CASE WHEN MAX(b.version) IS NULL THEN MAX(a.version) ELSE MAX(b.version) END
                         FROM utst a, utst b
                        WHERE a.st = avs_st AND NVL(a.version_is_current, '0') != 1
                          AND a.st = b.st(+) AND b.version_is_current(+) = '1')
      AND b.au = 'avCustInterspecTp'
      AND a.st LIKE b.value
      --AND (a.st LIKE b.value OR b.value = '<default>')
      AND b.st = c.st AND b.version = c.version
      AND c.version_is_current = 1
      AND c.st = d.st AND c.version = d.version
      AND d.spec_type = a.spec_type
      AND d.spec_type = (SELECT MAX(spec_type)
                           FROM utstgkspec_type
                          WHERE st = avs_st AND version = (SELECT CASE WHEN MAX(b.version) IS NULL THEN MAX(a.version) ELSE MAX(b.version) END
                                                             FROM utst a, utst b
                                                            WHERE a.st = avs_st AND NVL(a.version_is_current, '0') != 1
                                                              AND a.st = b.st(+) AND b.version_is_current(+) = '1'));

CURSOR lvq_template2 (avs_st IN VARCHAR2) IS
   SELECT c.st, c.version, a.spec_type
     FROM utstgkspec_type a, utstau b, utst c, utstgkspec_type d
    WHERE a.st = avs_st
      AND a.version = (SELECT CASE WHEN MAX(b.version) IS NULL THEN MAX(a.version) ELSE MAX(b.version) END
                         FROM utst a, utst b
                        WHERE a.st = avs_st AND NVL(a.version_is_current, '0') != 1
                          AND a.st = b.st(+) AND b.version_is_current(+) = '1')
      AND b.au = 'avCustInterspecTp'
      AND b.value = '<default>'
      AND b.st = c.st AND b.version = c.version
      AND c.version_is_current = 1
      AND c.st = d.st AND c.version = d.version
      AND d.spec_type = a.spec_type
      AND d.spec_type = (SELECT MAX(spec_type)
                           FROM utstgkspec_type
                          WHERE st = avs_st AND version = (SELECT CASE WHEN MAX(b.version) IS NULL THEN MAX(a.version) ELSE MAX(b.version) END
                                                             FROM utst a, utst b
                                                            WHERE a.st = avs_st AND NVL(a.version_is_current, '0') != 1
                                                              AND a.st = b.st(+) AND b.version_is_current(+) = '1'));

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);
lvs_template_st   APAOGEN.NAME_TYPE;
lvs_template_ver  APAOGEN.VERSION_TYPE;
lvb_found         BOOLEAN := FALSE;

BEGIN

   lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
   lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
   lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
   lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
   lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
   lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
   lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

   -----------------------------------------------------------------------------
   -- Get the template belonging to the sample for which this parametergroup is
   -- created
   -----------------------------------------------------------------------------
   -----------------------------------------------------------------------------
   -- Look for template with template-au like st
   -----------------------------------------------------------------------------
   FOR lvr_template IN lvq_template1(avs_st=>lvs_pp_key1) LOOP
      lvs_template_st  := lvr_template.st;
      lvs_template_ver := lvr_template.version;
      lvb_found        := TRUE;
      EXIT;
   END LOOP;

   -----------------------------------------------------------------------------
   -- Look for template with template-au = <default>
   -----------------------------------------------------------------------------
   FOR lvr_template IN lvq_template2(avs_st=>lvs_pp_key1) LOOP
      lvs_template_st  := lvr_template.st;
      lvs_template_ver := lvr_template.version;
      lvb_found        := TRUE;
      EXIT;
   END LOOP;

   -----------------------------------------------------------------------------
   -- Do the check only when a template is found
   -----------------------------------------------------------------------------
   IF lvb_found THEN
      SELECT COUNT(*)
        INTO lvi_count
        FROM utstpp
       WHERE st = lvs_template_st
         AND version = lvs_template_ver
         AND pp = lvs_pp
         AND pp_key1 = lvs_template_st;
   ELSE
      lvi_count := 0;
   END IF;

   RETURN (lvi_count > 0);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN FALSE;
END PpInTemplateWithPpKey1;

--------------------------------------------------------------------------------
-- FUNCTION : StCorrectTemplateConfig
-- ABSTRACT : This function checks whether the template configuration is correct
--------------------------------------------------------------------------------
--   WRITER : Arie Frans Kok
-- REVIEWER :
--     DATE : 31/03/2016
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
-- 31/03/2016 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION StCorrectTemplateConfig
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'StCorrectTemplateConfig';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvs_st             APAOGEN.ST_TYPE;
lvs_version        APAOGEN.VERSION_TYPE;
lvs_template       APAOACTION.Template_Type;
lvs_spectype       VARCHAR2(40);
lvb_correct_config BOOLEAN;

BEGIN

  lvs_st       := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version  := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  lvs_spectype := APAOACTION.GETSTSPECTYPE(lvs_st, lvs_version);
  lvs_template := APAOACTION.FINDSPECTYPETEMPLATE (lvs_st, lvs_version, lvs_spectype, lvb_correct_config, TRUE);

   RETURN (lvb_correct_config);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN FALSE;
END StCorrectTemplateConfig;

FUNCTION ScDestructiveError
RETURN BOOLEAN IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ScDestructiveError';
lvs_sqlerrm     APAOGEN.ERROR_MSG_TYPE;
lvi_counter_total    APAOGEN.COUNTER_TYPE;
lvi_counter_found    APAOGEN.COUNTER_TYPE;
lvb_destructive_found BOOLEAN := FALSE;
lvb_pa_assigned            BOOLEAN := FALSE;

CURSOR lvq_pa IS
   SELECT *
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC;

BEGIN
  lvi_counter_total := 0;
  -----------------------------------------------------------------------------
  -- Loop through all parameters of current sample
  -----------------------------------------------------------------------------
  FOR lvr_pa IN lvq_pa LOOP
      lvb_pa_assigned := TRUE;

	 SELECT count(*)
	   INTO lvi_counter_found
       FROM utprau
      WHERE pr = lvr_pa.pa AND version = lvr_pa.pr_version
        AND au = 'avDestructive' AND value = '1';

	 lvi_counter_total := lvi_counter_total + lvi_counter_found;
	 EXIT WHEN lvi_counter_total > 1;
  END LOOP;

  IF NOT lvb_pa_assigned THEN
     RETURN (FALSE);
  END IF;

  -----------------------------------------------------------------------------
  -- if we found more than 1 PA with avDestructive and value 1 we have an error
  -----------------------------------------------------------------------------
  IF lvi_counter_total > 1 THEN
     RETURN (TRUE);
  ELSE
     RETURN (FALSE);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN FALSE;
END ScDestructiveError;

FUNCTION ScPlannedToAvailable
RETURN BOOLEAN IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ScPlannedToAvailable';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;

BEGIN

    SELECT COUNT(*)
     INTO lvi_counter1
     FROM utstau a, utsc b
    WHERE a.st = b.st AND a.version = b.st_version
      AND b.sc = UNAPIEV.P_SC
      AND a.au = 'avCustSsFromInitial'
      AND a.value = 'AV';

   IF lvi_counter1 > 0 THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN FALSE;
END ScPlannedToAvailable;

END APAOCONDITION;
/
