create or replace PACKAGE BODY        UNCONDITION AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : UNCONDITION
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 06/02/2007
--   TARGET : Oracle 10.2.0 / Unilab 6.3
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 06/02/2007 | RS        | Created
-- 07/03/2007 | RS        | Changed WachtOpAndereMe
-- 28/03/2007 | RS        | Changed NewObjFromInterspcA : 1 systemsetting
-- 28/03/2007 | RS        | Changed NewObjFromInterspcE : 1 systemsetting
-- 13/04/2007 | RS        | Changed ME_CO6
-- 15/06/2007 | RS        | Changed ME_C07 : methodcell has to be of type checkbox
-- 25/01/2008 | RS        | Changed PA_C14 (av1.2.C08)
--                        | Changed SC_A02 (av1.2.C10)
-- 01/02/2008 | RS        | Added internal function OneSavePaOS     (av1.2.C04)
--                        | Added internal function OneSavePaOSConf (av1.2.C04)
--                        | Added internal function OneSavePaOWConf (av1.2.C04)
--                        | Changed PA_C14 : Added check on OneSavePaOSConf (av1.2.C04)
--                        | Changed PA_C08 : Added check on OneSavePaOS     (av1.2.C04)
--                        | Changed PA_C06 : Added check on OneSavePaOWConf (av1.2.C04)
-- 01/02/2008 | RS        | Added function ME_C13   (av1.2.C09)
--                        | Changed function ME_C09 (av1.2.C09)
-- 05/02/2008 | RS        | Changed internal function OneSavePaOSConf (av1.2.C04)
--                        | Changed internal function OneSavePaOWConf (av1.2.C04)
-- 06/02/2008 | RS        | Added function RQ_C01  (av2.0.C05)
--                        | Added function RQ_C02  (av2.0.C05)
--                        | Added function RQ_C03  (av2.0.C05)
--                        | Added function RQ_C04  (av2.0.C05)
--                        | Added function RQ_C05  (av2.0.C05)
--                        | Added function RQ_C06  (av2.0.C05)
--                        | Added function RQ_C07  (av2.0.C05)
--                        | Added function RQ_C08  (av2.0.C05)
--                        | Added function RQ_C10  (av2.0.C05)
--                        | Added function RQ_C11  (av2.0.C05)
--                        | Added function RQ_C12  (av2.0.C05)
--                        | Added function RQ_C13  (av2.0.C05)
--                        | Added function RQ_C14  (av2.0.C05)
--                        | Changed function ME_C13 (av1.2.C09)
-- 15/02/2008 | RS        | Changed function PA_C10 (av1.2.C04)
--                        | Changed function RQ_C14  (av2.0.C05)
-- 19/02/2008 | RS        | Changed function PA_C10 (av1.2.C04)
-- 06/03/2008 | RS        | Changed function ME_C08 (av1.2.C09)
--                        | Changed function ME_C09 (av1.2.C09)
-- 12/03/2008 | RS        | Changed function ME_C09 (av1.2.C09)
-- 02/04/2008 | RS        | Changed function PA_C05 (ignore MeReanalysis)
--                        | Changed function ME_C06 (if me has finished waiting on all methods then true)
--                        | Renamed function Monster_Gepland into Planned
--                        | Changed function Planned
--                        | Added function PA_C15
--                        | Changed function PA_C05 (added all me @C/CM)
-- 09/04/2008 | RS        | Changed function ME_C11 (av2.0.C08)
-- 17/04/2008 | RS        | Changed function PA_C04 (removed bug result out of spec)
--                        | Changed function SC_C02 (au : intial --> initial)
--                        | Changed function SC_C04 (check if pa are available: if not, no succes)
--                        | Changed functions RqPlanned
--                        | Added function SC_C14 (av2.0.C02)
--                        | Changed functions SC_C03 (av2.0.C02)
--                        | Changed functions RQ_C06 (av2.0.C03)
--                        | Added function PA_C16  (av2.0.C07)
-- 28/05/2008 | RS        | Changed function SC_C03 (av2.0.C03)
--                        | Changed function RQ_C06 (av2.0.C05)
--                        | Altered function RqPlanned
--                        | Altered function PA_C16
-- 03/06/2008 | RS        | Altered all SC, PA conditions: implemented APAOCONDITION
-- 03/06/2008 | HVB       | HVB1: Altered all SC  conditions C07 and C09 to reflect new OW status
-- 04/06/2008 | HVB       | HVB2: Added PA_C18 and PA_C19 for direct confirmation
-- 10/06/2008 | RS        | Changed function SC_C02
-- 12/06/2008 | HVB       | HVB3: Changed RQ_C06
-- 06/08/2008 | RS        | Changed SC_C04: Renamed scAllScFinished into scAllPaFinished
-- 27/09/2008 | RS        | Added function ST_C01
--                        | Added function ST_C02
--                        | Added function ST_C03
--                        | Added function ST_C04
--                        | Added function ST_C05
--                        | Added function ST_C06
--                        | Added function ST_C07
--                        | Added function ST_C09
--                        | Added function PP_C01
--                        | Added function PP_C02
--                        | Added function PP_C03
--                        | Added function PP_C04
--                        | Added function PP_C05
-- 21/10/2008 | RS        | Added function PR_C01
--                        | Added function PR_C02
--                        | Added function PR_C03
--                        | Added function PR_C04
-- 14/10/2008 | RS        | Changed function ST_C01 (not true for template)
--                        | Changed function ST_C02 (not true for template)
--                        | Changed function ST_C03 (not true for template)
--                        | Changed function ST_C04 (not true for template)
--                        | Changed function ST_C05 (not true for template)
--                        | Changed function ST_C06 (not true for template)
--                        | Changed function ST_C07 (not true for template)
-- 16/10/2008 | RS        | Changed function PP_C01 (not true for template)
--                        | Changed function PP_C02 (not true for template)
--                        | Changed function PP_C03 (not true for template)
--                        | Changed function PP_C04 (not true for template)
--                        | Changed function PP_C05 (not true for template)
--                        | Changed function PR_C01 (not true for template)
--                        | Changed function PR_C02 (not true for template)
--                        | Changed function PR_C03 (not true for template)
--                        | Changed function PR_C04 (not true for template + implementation)
-- 05/11/2008 | RS        | Added function PR_C01
--                        | Added function PR_C02
--                        | Added function PR_C03
--                        | Added function PR_C04
--                        | Changed function ST_C03
-- 26/11/2008 | RS        | Changed function PP_C05
-- 03/12/2008  | RS       | Added function ME_C14
-- 10/12/2008  | RS       | Changed function ST_C04
--                        | Changed function ST_C05
-- 11/02/2009 | RS        | Added function RQ_C05
-- 25/03/2009 | RS        | Added function IC_C01
-- 08/04/2009 | RS        | Changed function PR_C01 (removed ISTEMPLATE)
--                        | Changed function PR_C02 (removed ISTEMPLATE)
--                        | Changed function PR_C03 (removed ISTEMPLATE)
--                        | Changed function PR_C04 (removed ISTEMPLATE)
--                        | Changed function IC_C01
-- 17/03/2010 | RS        | Added function ST_C08
--                        | Changed function ST_C01 (added StUseTemplate)
--                        | Added function PP_C06
--                        | Changed function PP_C01 (added PpUseTemplate)
--                        | Added function RQ_C16
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
--                        | Changed ME_C11 (determine interval with timestamps)
-- 12/05/2011 | RS        | Added function IC_C02
--                        | Added function SC_C15
-- 13/02/2013 | RS        | Added functions PaResultAvailable, PaAllMeFinished
--                        | Changed function SC_C15
--                        | Added function RQ_C17
-- 29/03/2016 | AF        | Added function PP_C07 (I1511-178)
-- 29/03/2016 | AF        | Altered function PP_C04 (I1511-178)
-- 29/03/2016 | AF        | Altered function ST_C06  (I1511-178)
-- 29/03/2016 | AF        | Altered function ST_C01 (I1511-178)
-- 29/03/2016 | AF        | Altered function ST_C08 (I1511-178)
-- 28/04/2016 | AF        | Altered function ST_C07
-- 12/05/2016 | JR        | Changed function RQ_C17 (I1604-023)
-- 23/06/2016 | JR        | Added function SC_C16 (ERULG101C)
-- 15/12/2016 | JR        | Added function SC_C17 (I1610-488)
-- 20/07/2017 | JR        | Added PA_C20, PA_C21, RQ_C18, WS_C02, WS_C03, WS_C04
--                        | Altered PA_C04A (I1705-020 Extra request status)
-- 25/07/2017 | JR        | Altered WS_C02 (I1705-020 Extra request status)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT APAOGEN.API_NAME_TYPE := 'uncondition';
ics_ss_completed                 CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_completed');
ics_ss_cancelled                 CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_cancelled');
ics_ss_out_of_warning_conf       CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('ss_out_of_warning_conf');
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
-- This function returns true if the object comes from Interspec, and is no generic sampletype.
--------------------------------------------------------------------------------
FUNCTION NewObjFromInterspc
RETURN NUMBER IS
   l_count NUMBER;
   CURSOR l_generic_cursor IS
      SELECT COUNT(stgk.st)
        FROM utstgk stgk, utsystem
       WHERE stgk.st      = UNAPIEV.P_EV_REC.OBJECT_ID
         AND stgk.version = UNAPIEV.P_VERSION
         AND stgk.value   = 'Yes'
         AND stgk.gk      = utsystem.setting_value
         AND utsystem.setting_name = 'STGK ID Generic St';
BEGIN
   IF UNAPIEV.P_EV_REC.APPLIC = 'Interspc' THEN
      IF UNAPIEV.P_EV_REC.object_tp = 'st' THEN
         OPEN l_generic_cursor;
         FETCH l_generic_cursor INTO l_count;
         CLOSE l_generic_cursor;
         IF l_count <> 0 THEN
            RETURN(UNAPIGEN.DBERR_GENFAIL);
         END IF;
      END IF;
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);

END NewObjFromInterspc;

FUNCTION NewObjFromInterspcA
RETURN NUMBER IS
   l_count NUMBER;
  lvs_change_ss_st        VARCHAR2(20);

   CURSOR l_generic_cursor IS
      SELECT COUNT(stgk.st)
        FROM utstgk stgk, utsystem
       WHERE stgk.st      = UNAPIEV.P_EV_REC.OBJECT_ID
         AND stgk.version = UNAPIEV.P_VERSION
         AND stgk.value   = 'Yes'
         AND stgk.gk      = utsystem.setting_value
         AND utsystem.setting_name = 'STGK ID Generic St';
BEGIN
  lvs_change_ss_st := APAOGEN.GetSystemSetting('APPROVE_INTERSPEC','NO');
  IF lvs_change_ss_st = 'YES' THEN
     IF UNAPIEV.P_EV_REC.APPLIC = 'Interspc' THEN
        IF UNAPIEV.P_EV_REC.object_tp = 'st' THEN
           OPEN l_generic_cursor;
           FETCH l_generic_cursor INTO l_count;
           CLOSE l_generic_cursor;
           IF l_count <> 0 THEN
              RETURN(UNAPIGEN.DBERR_GENFAIL);
           END IF;
        END IF;
        RETURN(UNAPIGEN.DBERR_SUCCESS);
     ELSE
        RETURN(UNAPIGEN.DBERR_GENFAIL);
     END IF;
  ELSE
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
END NewObjFromInterspcA;

FUNCTION NewObjFromInterspcE
RETURN NUMBER IS
   l_count NUMBER;
   lvs_change_ss_st       VARCHAR2(20);

   CURSOR l_generic_cursor IS
      SELECT COUNT(stgk.st)
        FROM utstgk stgk, utsystem
       WHERE stgk.st      = UNAPIEV.P_EV_REC.OBJECT_ID
         AND stgk.version = UNAPIEV.P_VERSION
         AND stgk.value   = 'Yes'
         AND stgk.gk      = utsystem.setting_value
         AND utsystem.setting_name = 'STGK ID Generic St';
BEGIN
  lvs_change_ss_st := APAOGEN.GetSystemSetting('APPROVE_INTERSPEC','NO');
  IF lvs_change_ss_st = 'NO' THEN
     IF UNAPIEV.P_EV_REC.APPLIC = 'Interspc' THEN
        IF UNAPIEV.P_EV_REC.object_tp = 'st' THEN
           OPEN l_generic_cursor;
           FETCH l_generic_cursor INTO l_count;
           CLOSE l_generic_cursor;
           IF l_count <> 0 THEN
              RETURN(UNAPIGEN.DBERR_GENFAIL);
           END IF;
        END IF;
        RETURN(UNAPIGEN.DBERR_SUCCESS);
     ELSE
        RETURN(UNAPIGEN.DBERR_GENFAIL);
     END IF;
   ELSE
    RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
END NewObjFromInterspcE;

--------------------------------------------------------------------------------
-- This function returns true if the object comes from Interspec, and is a generic sampletype.
--------------------------------------------------------------------------------
FUNCTION NewGenStFromInterspc
RETURN NUMBER IS
   l_count NUMBER;

   CURSOR l_generic_cursor IS
      SELECT COUNT(stgk.st)
        FROM utstgk stgk, utsystem
       WHERE stgk.st      = UNAPIEV.P_EV_REC.OBJECT_ID
         AND stgk.version = UNAPIEV.P_VERSION
         AND stgk.value   = 'Yes'
         AND stgk.gk      = utsystem.setting_value
         AND utsystem.setting_name = 'STGK ID Generic St';
BEGIN

   IF UNAPIEV.P_EV_REC.APPLIC = 'Interspc' THEN
      IF UNAPIEV.P_EV_REC.object_tp = 'st' THEN
         OPEN l_generic_cursor;
         FETCH l_generic_cursor INTO l_count;
         CLOSE l_generic_cursor;
         IF l_count <> 0 THEN
            RETURN(UNAPIGEN.DBERR_SUCCESS);
         END IF;
      END IF;
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   ELSE
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;

END NewGenStFromInterspc;
--------------------------------------------------------------------------------
-- START OF CONDITIONS
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------
FUNCTION OnlyManual
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'OnlyManual';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- This function always returns an error, to avoid automatic transitions
--------------------------------------------------------------------------------
BEGIN

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END OnlyManual;

--------------------------------------------------------------------------------
-- Opdracht C5
--------------------------------------------------------------------------------
FUNCTION RQ_C05
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C05';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.RQAVON1SC AND APAOCONDITION.RQONESCAV THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;


   RETURN(OnlyManual);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C05;
--------------------------------------------------------------------------------
-- Opdracht C6
--------------------------------------------------------------------------------
FUNCTION RQ_C06
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C06';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

-- HVB3: Commented out old code
--   IF APAOCONDITION.RQMANUALAVRQ AND APAOCONDITION.RQWAITFOROTHERRQ THEN
--      RETURN(UNAPIGEN.DBERR_SUCCESS);
--   END IF;

-- HVB3: New block including NOT RQWAITFOROTHERRQ
   IF APAOCONDITION.RQMANUALAVRQ AND NOT APAOCONDITION.RQWAITFOROTHERRQ THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;


   RETURN(OnlyManual);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C06;

--------------------------------------------------------------------------------
-- RQ_C07 True is
--------------------------------------------------------------------------------
FUNCTION RQ_C07
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C07';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.RQWAITFORINITIAL THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;


   RETURN(OnlyManual);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C07;
--------------------------------------------------------------------------------
-- Opdracht C8
--------------------------------------------------------------------------------
FUNCTION RQ_C08
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C08';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.RQALLSCAV THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(OnlyManual);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C08;

--------------------------------------------------------------------------------
-- Opdracht C9
--------------------------------------------------------------------------------
FUNCTION RQ_C09
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C09';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
BEGIN

   IF NOT APAOCONDITION.RQISVALIDATIONRQ AND APAOCONDITION.RQALLSCFINISHED THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C09;

--------------------------------------------------------------------------------
-- Opdracht C10
--------------------------------------------------------------------------------
FUNCTION RQ_C10
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C10';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.RQISVALIDATIONRQ AND APAOCONDITION.RQALLSCFINISHED THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C10;

--------------------------------------------------------------------------------
-- Opdracht C11
--------------------------------------------------------------------------------
FUNCTION RQ_C11
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C11';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.RQONESCAV THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C11;

--------------------------------------------------------------------------------
-- Opdracht C14
--------------------------------------------------------------------------------
FUNCTION RQ_C14
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C14';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN
   IF NOT APAOCONDITION.RQMANUALAVRQ AND NOT APAOCONDITION.RQWAITFORVALIDATIONRQ AND APAOCONDITION.RQALLSCAV THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C14;

--------------------------------------------------------------------------------
-- Opdracht C15
--------------------------------------------------------------------------------
FUNCTION RQ_C15
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C15';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN
-- HVB3: Commented out old code
---   IF NOT APAOCONDITION.RQMANUALAVRQ AND NOT APAOCONDITION.RQWAITFOROTHERRQ THEN
---      RETURN(UNAPIGEN.DBERR_SUCCESS);
---   END IF;

-- HVB3: Added condition on rqwaitforinitial
   IF NOT APAOCONDITION.RQMANUALAVRQ AND NOT APAOCONDITION.RQWAITFOROTHERRQ AND APAOCONDITION.RQWAITFORINITIAL THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C15;
--------------------------------------------------------------------------------
-- Opdracht C16
--------------------------------------------------------------------------------
FUNCTION RQ_C16
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C16';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN


   IF APAOCONDITION.RqOneScOSConf AND
      APAOCONDITION.RQALLSCFINISHED THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C16;
--------------------------------------------------------------------------------
-- Opdracht C17
--------------------------------------------------------------------------------
-- 01/10/2015 | JR | changed, RqRtIsOutdoor replaced by the more generic generic RqToAvailable
FUNCTION RQ_C17
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C17';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN
   --IF APAOCONDITION.RqRtIsOutdoor THEN
   IF APAOCONDITION.RqToAvailable THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C17;

FUNCTION RQ_C18
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_C18';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN
   IF Unapiev.P_EV_REC.EV_TP = 'RqGroupKeyUpdated' THEN 
      RETURN UNAPIGEN.DBERR_GENFAIL; 
      --not a failure, but this code is commonly used for �false� in conditions. 
   END IF;

   IF APAOCONDITION.paOnePaTV THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_C18;

--------------------------------------------------------------------------------
-- Monster C1
--------------------------------------------------------------------------------
FUNCTION SC_C01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C01';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C01;

--------------------------------------------------------------------------------
-- Monster C2
--------------------------------------------------------------------------------
FUNCTION SC_C02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C02';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;
lvi_count           NUMBER;
BEGIN

   IF APAOCONDITION.SCINITIALTOPLANNED THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C02;

--------------------------------------------------------------------------------
-- Monster C3
--------------------------------------------------------------------------------
FUNCTION SC_C03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C03';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF NOT APAOCONDITION.ScManualAvSc AND APAOCONDITION.ScHasRq AND NOT APAOCONDITION.RqPlanned THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(OnlyManual);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C03;

--------------------------------------------------------------------------------
-- Monster C4
--------------------------------------------------------------------------------
FUNCTION SC_C04
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C04';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;

BEGIN

   IF APAOCONDITION.SCALLPAFINISHED THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C04;

--------------------------------------------------------------------------------
-- Monster C5
--------------------------------------------------------------------------------
FUNCTION SC_C05
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C05';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.SCONEPAOWCONF THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C05;

--------------------------------------------------------------------------------
-- Monster C6
--------------------------------------------------------------------------------
FUNCTION SC_C06
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C06';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;

BEGIN

   IF APAOCONDITION.SCONEPAOS THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C06;

--------------------------------------------------------------------------------
-- Monster C7
--------------------------------------------------------------------------------
FUNCTION SC_C07
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C07';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN


---HVB1   IF NOT APAOCONDITION.SCONEPAOS AND APAOCONDITION.SCONEPAAV THEN
---HVB1      RETURN UNAPIGEN.DBERR_SUCCESS;
---HVB1   END IF;

---HVB1: Replace above by:
   IF NOT APAOCONDITION.scOnePaOS AND NOT APAOCONDITION.scOnePaOW AND APAOCONDITION.SCONEPAAV THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;


   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C07;

--------------------------------------------------------------------------------
-- Monster C8
--------------------------------------------------------------------------------
FUNCTION SC_C08
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C08';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;

BEGIN

   IF APAOCONDITION.SCONEPAAV THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C08;

--------------------------------------------------------------------------------
-- Monster C9
--------------------------------------------------------------------------------
FUNCTION SC_C09
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C09';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

---HVB1   IF APAOCONDITION.SCONEPAOW THEN
---HVB1      RETURN UNAPIGEN.DBERR_SUCCESS;
---HVB1   END IF;

---HVB1: Replace above by:
    IF APAOCONDITION.scOnePaOW AND NOT APAOCONDITION.scOnePaOS THEN
        RETURN UNAPIGEN.DBERR_SUCCESS;
        END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C09;

--------------------------------------------------------------------------------
-- Monster C10
--------------------------------------------------------------------------------
FUNCTION SC_C10
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C10';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;
lvi_counter2      APAOGEN.COUNTER_TYPE;
lvi_totcounter    APAOGEN.COUNTER_TYPE;

BEGIN

   IF APAOCONDITION.SCONEPAOSCONF THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C10;

--------------------------------------------------------------------------------
-- Monster C11
-- Check whether or not freq UAbased has been assigned succesfully
--------------------------------------------------------------------------------
FUNCTION SC_C11
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C11';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.SCUABASEDERROR THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   ELSE
      RETURN UNAPIGEN.DBERR_GENFAIL;
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C11;

--------------------------------------------------------------------------------
-- Monster C12
-- not used
--------------------------------------------------------------------------------
FUNCTION SC_C12
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C12';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C12;

--------------------------------------------------------------------------------
-- Monster C13
-- not used
--------------------------------------------------------------------------------
FUNCTION SC_C13
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C13';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C13;
--------------------------------------------------------------------------------
-- Monster C14
--------------------------------------------------------------------------------
FUNCTION SC_C14
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C14';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.RqPlanned THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C14;

FUNCTION SC_C15
RETURN APAOGEN.RETURN_TYPE IS


lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C15';
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_count         NUMBER;
lvi_filled        NUMBER;
lvi_total         NUMBER;
BEGIN

   SELECT count(*)
     INTO lvi_count
     FROM utscic
    WHERE sc = UNAPIEV.P_SC AND ic = 'avBoughtPibs';

   SELECT SUM(DECODE(iivalue, NULL, 0, 1)), COUNT(*)
     INTO lvi_filled, lvi_total
     FROM utscii
    WHERE sc = UNAPIEV.P_SC
      AND ic = 'avBoughtPibs';

    IF lvi_total = lvi_filled AND
       lvi_count = 1 THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   ELSE
      RETURN UNAPIGEN.DBERR_GENFAIL;
   END IF;


EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C15;

--------------------------------------------------------------------------------
-- Parametergroup C1
-- Automatisch, na creatie
--------------------------------------------------------------------------------
FUNCTION PG_C01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_C01';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PG_C01;

--------------------------------------------------------------------------------
-- Parametergroup C2
-- Automatisch, na creatie, indien het monster de status ¿Planned¿ heeft
--------------------------------------------------------------------------------
FUNCTION PG_C02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_C02';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.RQORSCPLANNED THEN
      lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
   ELSE
      lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END IF;

   RETURN (lvi_ret_code);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PG_C02;

--------------------------------------------------------------------------------
-- Parametergroup C3
-- Automatisch, na creatie, indien het monster niet de status ¿Planned¿ heeft
--------------------------------------------------------------------------------
FUNCTION PG_C03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_C03';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

  --------------------------------------------------------------------------------
  -- indien het monster niet de status ¿Planned¿ heeft
  --------------------------------------------------------------------------------
  IF NOT APAOCONDITION.RQORSCPLANNED THEN
    lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
   ELSE
    lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
  END IF;

  RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PG_C03;

--------------------------------------------------------------------------------
-- Parametergroup C4
-- Automatisch, als alle parameters een van de volgende statussen hebben:
-- o  Completed
-- o  Out of warning confirmed
-- o  Out of spec confirmed
-- o  Cancelled
--------------------------------------------------------------------------------
FUNCTION PG_C04
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_C04';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;
lvi_totcounter    APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT (*),
          COUNT (DECODE (ss, ics_ss_completed         ,1,
                        ics_ss_out_of_warning_conf  ,1,
                             ics_ss_out_of_spec_conf    ,1,
                             ics_ss_cancelled         ,1))
     INTO lvi_totcounter, lvi_counter1
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE;

   IF lvi_totcounter = lvi_counter1 THEN
      lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
   ELSE
      lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END IF;

   RETURN (lvi_ret_code);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PG_C04;

--------------------------------------------------------------------------------
-- Parametergroup C5
-- Automatisch, als ten minste 1 parameter de status ¿Available¿ heeft
--------------------------------------------------------------------------------
FUNCTION PG_C05
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_C05';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT (DECODE (ss,ics_ss_available  ,1))
     INTO lvi_counter1
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE;

   IF lvi_counter1 > 0 THEN
      lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
   ELSE
      lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END IF;

   RETURN (lvi_ret_code);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PG_C05;

--------------------------------------------------------------------------------
-- Parametergroup C6
-- Automatisch, (vanuit elke status), na het schrappen van de parametergroup.
--------------------------------------------------------------------------------
FUNCTION PG_C06
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_C06';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PG_C06;

--------------------------------------------------------------------------------
-- Parameter C1
--------------------------------------------------------------------------------
FUNCTION PA_C01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C01';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C01;

--------------------------------------------------------------------------------
-- Parameter C2
--------------------------------------------------------------------------------
FUNCTION PA_C02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C02';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.RQORSCPLANNED THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C02;

--------------------------------------------------------------------------------
-- Parameter C3
--------------------------------------------------------------------------------
FUNCTION PA_C03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C03';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

  IF NOT APAOCONDITION.RQORSCPLANNED THEN
     RETURN UNAPIGEN.DBERR_SUCCESS;
  END IF;

  RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C03;

--------------------------------------------------------------------------------
-- Parameter C4
--------------------------------------------------------------------------------
FUNCTION PA_C04
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C04';
lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code            APAOGEN.RETURN_TYPE;

BEGIN

  IF APAOCONDITION.PaAllMeFinished AND APAOCONDITION.paResultAvailable THEN
     RETURN (UNAPIGEN.DBERR_SUCCESS);
  END IF;

  RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C04;

FUNCTION PaResultAvailable
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PaResultAvailable';
lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code            APAOGEN.RETURN_TYPE;

BEGIN

  IF APAOCONDITION.paResultAvailable THEN
     RETURN (UNAPIGEN.DBERR_SUCCESS);
  END IF;

  RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PaResultAvailable;

FUNCTION PaAllMeFinished
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PaAllMeFinished';
lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code            APAOGEN.RETURN_TYPE;

BEGIN

  IF APAOCONDITION.PaAllMeFinished THEN
     RETURN (UNAPIGEN.DBERR_SUCCESS);
  END IF;

  RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PaAllMeFinished;

FUNCTION PA_C04A
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C04A';
lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code            APAOGEN.RETURN_TYPE;

BEGIN

  IF APAOCONDITION.PaAllMeFinished
	AND APAOCONDITION.paResultAvailable
	AND APAOCONDITION.PABINNENSPECIFICATIE
	AND APAOCONDITION.PABINNENWAARSCHUWING
	AND NOT APAOCONDITION.PAONELINKEDPAOS
	AND NOT APAOCONDITION.PAONELINKEDPAOW
	AND NOT APAOCONDITION.PAONELINKEDPAOSCONF
	AND NOT APAOCONDITION.PAONELINKEDPAOWCONF
	AND NOT APAOCONDITION.RQISVALIDATIONRQ
  THEN
     RETURN (UNAPIGEN.DBERR_SUCCESS);
  END IF;

  RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C04A;
--------------------------------------------------------------------------------
-- Parameter C5
--------------------------------------------------------------------------------
FUNCTION PA_C05
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C05';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF NOT APAOCONDITION.PaAllMeFinished THEN
      --------------------------------------------------------------------------------
      -- Force a custom reanalyse to save the current status of the parameter in
      -- the reanalysisdetails in stead of the status of the parameter
      -- after the reanalysis (always available)
      --------------------------------------------------------------------------------
      IF APAOCONDITION.PACUSTOMREANALYSIS THEN
         RETURN (UNAPIGEN.DBERR_SUCCESS);
      END IF;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C05;

--------------------------------------------------------------------------------
-- Parameter C6
--------------------------------------------------------------------------------
FUNCTION PA_C06
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C06';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

  IF APAOCONDITION.PaAllMeFinished AND APAOCONDITION.paOneLinkedPaOW AND NOT APAOCONDITION.PASKIPOUTOFWARNING THEN
     RETURN (UNAPIGEN.DBERR_SUCCESS);
  END IF;

  RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C06;

--------------------------------------------------------------------------------
-- Parameter C7
--------------------------------------------------------------------------------
FUNCTION PA_C07
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C07';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.PaAllMeFinished AND APAOCONDITION.paBinnenSpecificatie AND APAOCONDITION.paBuitenWaarschuwing AND NOT APAOCONDITION.PASKIPOUTOFWARNING THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C07;

--------------------------------------------------------------------------------
-- Parameter C8
--------------------------------------------------------------------------------
FUNCTION PA_C08
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C08';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

    IF APAOCONDITION.PaAllMeFinished AND APAOCONDITION.paOneLinkedPaOS AND NOT APAOCONDITION.PASKIPOUTOFSPEC THEN
       RETURN (UNAPIGEN.DBERR_SUCCESS);
    END IF;

    RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C08;

--------------------------------------------------------------------------------
-- Parameter C9
--------------------------------------------------------------------------------
FUNCTION PA_C09
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C09';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.PaAllMeFinished AND APAOCONDITION.PaBuitenSpecificatie AND NOT APAOCONDITION.PASKIPOUTOFSPEC THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C09;

--------------------------------------------------------------------------------
-- Parameter C10
--------------------------------------------------------------------------------
FUNCTION PA_C10
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C10';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF INSTR (UNAPIEV.P_EV_REC.EV_DETAILS, 'duplo') > 0 AND APAOCONDITION.paOneLinkedPaOSConf THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C10;

--------------------------------------------------------------------------------
-- Parameter C11
--------------------------------------------------------------------------------
FUNCTION PA_C11
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C11';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF INSTR (UNAPIEV.P_EV_REC.EV_DETAILS, 'duplo') > 0 AND APAOCONDITION.paOneLinkedPaOWConf THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C11;

--------------------------------------------------------------------------------
-- Parameter C12
-- = PA_C5
--------------------------------------------------------------------------------
FUNCTION PA_C12
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C12';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.paOneLinkedPaOWConf THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C12;

--------------------------------------------------------------------------------
-- Parameter C13
--------------------------------------------------------------------------------
FUNCTION PA_C13
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C13';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.paOneLinkedPaOSConf THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C13;

--------------------------------------------------------------------------------
-- Parameter C14
--------------------------------------------------------------------------------
FUNCTION PA_C14
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C14';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.paAllMeFinished AND APAOCONDITION.paOneLinkedPaOs AND APAOCONDITION.paSkipOutOfSpec THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C14;

FUNCTION PA_C15
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C15';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;

BEGIN

   IF APAOCONDITION.paAllMeCancelled THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C15;

FUNCTION PA_C16
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C16';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_count1          NUMBER;
lvi_count2          NUMBER;
lvi_count3          NUMBER;
lvi_count4          NUMBER;

BEGIN
   --------------------------------------------------------------------------------
   -- Current parameter has a value_f
   --------------------------------------------------------------------------------
   SELECT count(*)
     INTO lvi_count1
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
      AND VALUE_F IS NOT NULL;
   --------------------------------------------------------------------------------
   -- Count methods of current parameter have a status completed or @C
   --------------------------------------------------------------------------------
   SELECT COUNT(*),
          SUM(DECODE(ss, ics_ss_completed, 1,
                         ics_ss_cancelled, 1, 0))
     INTO lvi_count2, lvi_count3
     FROM utscme
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;
   --------------------------------------------------------------------------------
   -- Count methods of current parameter have a status completed and value_f is not null
   --------------------------------------------------------------------------------
   SELECT count(*)
     INTO lvi_count4
     FROM utscme
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
      AND ss = ics_ss_completed
      AND value_f IS NOT NULL;

   IF lvi_count1 > 0 AND lvi_count2 = lvi_count3 AND lvi_count2 > 0 AND lvi_count4 = 0 THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL ;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C16;

--------------------------------------------------------------------------------
-- Parameter C17
--------------------------------------------------------------------------------
FUNCTION PA_C17
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C17';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.paAllMeFinished AND APAOCONDITION.paOneLinkedPaOW AND APAOCONDITION.paSkipOutOfWarning THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C17;

--------------------------------------------------------------------------------
-- Parameter C18 copy from C07 (HVB2)
--------------------------------------------------------------------------------
FUNCTION PA_C18
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C18';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.PaAllMeFinished AND APAOCONDITION.paBinnenSpecificatie AND APAOCONDITION.paBuitenWaarschuwing AND APAOCONDITION.PASKIPOUTOFWARNING THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C18;

--------------------------------------------------------------------------------
-- Parameter C19 copy from C09 (HVB2)
--------------------------------------------------------------------------------
FUNCTION PA_C19
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C19';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.PaAllMeFinished AND APAOCONDITION.PaBuitenSpecificatie AND APAOCONDITION.PASKIPOUTOFSPEC THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C19;

FUNCTION PA_C20
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C20';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.RqIsValidationRq AND APAOCONDITION.PaAllMeFinished AND APAOCONDITION.PaResultAvailable THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C20;

FUNCTION PA_C21
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_C21';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvi_counterRqCompleted  APAOGEN.COUNTER_TYPE;

BEGIN
	------------------------------------------------------------------------------------
	-- Check if the Request is Completed'
	------------------------------------------------------------------------------------
	SELECT COUNT(t2.ss)
	  INTO lvi_counterRqCompleted
	  FROM utrqsc  t1
	 	 , utrq    t2
	  WHERE t1.sc = UNAPIEV.P_SC
	    AND t1.rq = t2.rq
		AND t2.ss = ics_ss_completed;

	IF lvi_counterRqCompleted > 0 THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PA_C21;

--------------------------------------------------------------------------------
-- Methode C1
-- Automatisch, na creatie, indien het opdracht/monster de status ¿Planned¿ heeft
--------------------------------------------------------------------------------
FUNCTION ME_C01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C01';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.RQORSCPLANNED THEN
      lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
   ELSE
      lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
   END IF;

   RETURN (lvi_ret_code);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C01;

--------------------------------------------------------------------------------
-- Methode C2
-- Automatisch, na creatie, indien het monster niet de status ¿Planned¿ heeft
-- en de methode moet niet wachten op een andere methode
--------------------------------------------------------------------------------
FUNCTION ME_C02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C02';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;

BEGIN

    --------------------------------------------------------------------------------
  -- indien het opdracht/monster niet de status ¿Planned¿ heeft
  --------------------------------------------------------------------------------
   IF NOT APAOCONDITION.RQORSCPLANNED THEN
      --------------------------------------------------------------------------------
     -- de methode moet niet wachten op een andere methode
     --------------------------------------------------------------------------------
     IF NOT APAOCONDITION.MEWACHTOPANDEREME THEN
        lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
     ELSE
        lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
     END IF;
  ELSE
    lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
  END IF;

  RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C02;

--------------------------------------------------------------------------------
-- Methode C3
-- Automatisch, na creatie, indien het opdracht/monster niet de status ¿Planned¿ heeft
-- maar de methode moet wachten op een andere methode
--------------------------------------------------------------------------------
FUNCTION ME_C03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C03';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;

BEGIN

  --------------------------------------------------------------------------------
  -- indien het opdracht/monster niet de status ¿Planned¿ heeft
  --------------------------------------------------------------------------------
  IF NOT APAOCONDITION.RQORSCPLANNED THEN
      --------------------------------------------------------------------------------
     -- de methode moet wachten op een andere methode
     --------------------------------------------------------------------------------
     lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
   ELSE
    lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
  END IF;

  RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C03;

--------------------------------------------------------------------------------
-- Methode C4
--  Automatisch, na creatie, indien het opdracht/monster niet de status ¿Planned¿ heeft
-- en de methode moet wel wachten op een andere methode
-- = ME_C3
--------------------------------------------------------------------------------
FUNCTION ME_C04
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C04';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   RETURN(ME_C03);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C04;

--------------------------------------------------------------------------------
-- Methode C5
-- Automatisch, na creatie, indien het monster niet de status ¿Planned¿ heeft
-- en de methode moet niet wachten op een andere methode
-- = ME_C2
--------------------------------------------------------------------------------
FUNCTION ME_C05
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C05';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   RETURN(ME_C02);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C05;

--------------------------------------------------------------------------------
-- Methode C6
-- Automatisch, na completion van de methode waarop wordt gewacht
--------------------------------------------------------------------------------
FUNCTION ME_C06
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C06';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvi_counterPaAvailable APAOGEN.COUNTER_TYPE;
lvi_counterPaFinished  APAOGEN.COUNTER_TYPE;
lvi_counterPgAvailable APAOGEN.COUNTER_TYPE;
lvi_counterPgFinished  APAOGEN.COUNTER_TYPE;
lvi_counterScAvailable APAOGEN.COUNTER_TYPE;
lvi_counterScFinished  APAOGEN.COUNTER_TYPE;

BEGIN
  --------------------------------------------------------------------------------
  -- Zijn methodes binnen hetzelfde Pa aanwezig
  --------------------------------------------------------------------------------
  SELECT COUNT(*)
     INTO lvi_counterPaAvailable
     FROM utscmeau a, utscme b
    WHERE a.sc = UNAPIEV.P_SC
      AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
      AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
      AND a.me = UNAPIEV.P_ME AND a.menode = UNAPIEV.P_MENODE
      AND a.au = ics_au_wait_for
      AND b.sc = a.sc
      AND b.pg = a.pg AND b.pgnode = a.pgnode
      AND b.pa = a.pa AND b.panode = a.panode
      AND b.me = a.value;
  --------------------------------------------------------------------------------
  -- Zijn methodes binnen hetzelfde Pa aanwezig in ss IR,@C of CM
  --------------------------------------------------------------------------------
  SELECT COUNT(*)
     INTO lvi_counterPaFinished
     FROM utscmeau a, utscme b
    WHERE a.sc = UNAPIEV.P_SC
      AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
      AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
      AND a.me = UNAPIEV.P_ME AND a.menode = UNAPIEV.P_MENODE
      AND a.au = ics_au_wait_for
      AND b.sc = a.sc
      AND b.pg = a.pg AND b.pgnode = a.pgnode
      AND b.pa = a.pa AND b.panode = a.panode
      AND b.me = a.value
      AND b.ss IN (ics_ss_completed,
               ics_ss_irrelevant,
                 ics_ss_cancelled);

  --------------------------------------------------------------------------------
  -- Er zijn methodes binnen hetzelfde Pa aanwezig (lvi_counterPaAvailable > 0)
  -- En de status van deze methodes is IR,@C of CM (lvi_counterPaFinished = lvi_counterPaAvailable)
  --------------------------------------------------------------------------------
   IF lvi_counterPaAvailable > 0 AND
      lvi_counterPaFinished = lvi_counterPaAvailable THEN
      lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
   ELSIF lvi_counterPaAvailable > 0 THEN
    lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
   ELSE
     --------------------------------------------------------------------------------
     -- Zijn methodes binnen hetzelfde Pg aanwezig
     --------------------------------------------------------------------------------
     SELECT COUNT(*)
        INTO lvi_counterPgAvailable
        FROM utscmeau a, utscme b
       WHERE a.sc = UNAPIEV.P_SC
         AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
         AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
         AND a.me = UNAPIEV.P_ME AND a.menode = UNAPIEV.P_MENODE
         AND a.au = ics_au_wait_for
         AND b.sc = a.sc
         AND b.pg = a.pg AND a.pgnode = b.pgnode
         AND b.me = a.value;
    --------------------------------------------------------------------------------
    -- Indien niet aanwezig dan wordt uitgegaan van methodes buiten het Pa (Pg niveau)
    --------------------------------------------------------------------------------
    SELECT COUNT(*)
       INTO lvi_counterPgFinished
       FROM utscmeau a, utscme b
      WHERE a.sc = UNAPIEV.P_SC
        AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
        AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
        AND a.me = UNAPIEV.P_ME AND a.menode = UNAPIEV.P_MENODE
        AND a.au = ics_au_wait_for
        AND b.sc = a.sc
        AND b.pg = a.pg AND a.pgnode = b.pgnode
        AND b.me = a.value
        AND b.ss IN (ics_ss_completed,
                     ics_ss_irrelevant,
                     ics_ss_cancelled);

       --------------------------------------------------------------------------------
       -- Er zijn methodes binnen hetzelfde Pg aanwezig (lvi_counterPgAvailable > 0)
       -- En de status van deze methodes is IR,@C of CM (lvi_counterPgFinished = lvi_counterPgAvailable)
       --------------------------------------------------------------------------------
       IF lvi_counterPgAvailable > 0 AND
           lvi_counterPgFinished = lvi_counterPgAvailable THEN
           lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
       ELSIF lvi_counterPgAvailable > 0 THEN
          lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
       ELSE
           --------------------------------------------------------------------------------
           -- Zijn methodes binnen hetzelfde Sc aanwezig
           --------------------------------------------------------------------------------
           SELECT COUNT(*)
              INTO lvi_counterScAvailable
              FROM utscmeau a, utscme b
             WHERE a.sc = UNAPIEV.P_SC
               AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
               AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
               AND a.me = UNAPIEV.P_ME AND a.menode = UNAPIEV.P_MENODE
               AND a.au = ics_au_wait_for
               AND b.sc = a.sc
               AND b.me = a.value;
          --------------------------------------------------------------------------------
          -- Indien niet aanwezig dan wordt uitgegaan van methodes buiten het Pa (Sc niveau)
          --------------------------------------------------------------------------------
          SELECT COUNT(*)
             INTO lvi_counterScFinished
             FROM utscmeau a, utscme b
            WHERE a.sc = UNAPIEV.P_SC
              AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
              AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
              AND a.me = UNAPIEV.P_ME AND a.menode = UNAPIEV.P_MENODE
              AND a.au = ics_au_wait_for
              AND b.sc = a.sc
              AND b.me = a.value
              AND b.ss IN (ics_ss_completed,
                           ics_ss_irrelevant,
                           ics_ss_cancelled);

          --------------------------------------------------------------------------------
          -- Er zijn methodes binnen hetzelfde Sc aanwezig (lvi_counterScAvailable > 0)
          -- En de status van deze methodes is IR,@C of CM (lvi_counterScFinished = lvi_counterScAvailable)
          --------------------------------------------------------------------------------
          IF lvi_counterScAvailable > 0 AND
              lvi_counterScFinished = lvi_counterScAvailable THEN
              lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
          ELSIF lvi_counterScAvailable > 0 THEN
             lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
          ELSE
             lvi_ret_code := UNAPIGEN.DBERR_GENFAIL;
          END IF;
       END IF;
   END IF;

   RETURN (lvi_ret_code);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C06;

--------------------------------------------------------------------------------
-- Methode C7
-- Automatically, if methodcell "mtcell_in_execution" has been checked
-- (name of the cell has been configured in addon table ATAOCONTSTANT).
-- Methodcell should be a checkbox
--------------------------------------------------------------------------------
FUNCTION ME_C07
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C07';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;

BEGIN

  SELECT COUNT (*)
     INTO lvi_counter1
     FROM utscmecell
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
      AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
      AND cell = ics_mtcell_in_execution
      AND cell_tp = 'B'
      AND (value_f = 1 OR value_s = 1);

   IF lvi_counter1 > 0 THEN
     RETURN (UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN (UNAPIGEN.DBERR_GENFAIL);
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C07;

--------------------------------------------------------------------------------
-- Methode C8
-- Automatisch, na completion van de methode
--------------------------------------------------------------------------------
FUNCTION ME_C08
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C08';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.MERESULTAVAILABLE THEN
    RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C08;

--------------------------------------------------------------------------------
-- Methode C9
-- = Automatisch, na custom event 'hours2wait'
--------------------------------------------------------------------------------
FUNCTION ME_C09
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C09';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF INSTR (UNAPIEV.P_EV_REC.EV_DETAILS, 'hours2wait') > 0 THEN
    RETURN (UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN UNAPIGEN.DBERR_GENFAIL;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C09;

--------------------------------------------------------------------------------
-- Methode C10
-- Automatisch, na her-analyse
--------------------------------------------------------------------------------
FUNCTION ME_C10
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C10';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

  IF UNAPIEV.P_EV_REC.ev_tp = 'PaReanalysis' OR
    UNAPIEV.P_EV_REC.ev_tp = 'MeReanalysis' THEN
      RETURN (UNAPIGEN.DBERR_SUCCESS);
   ELSE
      RETURN (UNAPIGEN.DBERR_NOOBJECT);
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C10;

--------------------------------------------------------------------------------
-- Methode C11
-- Automatisch, (vanuit elke status), nadat het resultaat op
-- parameter-niveau is ingevoerd
--------------------------------------------------------------------------------
FUNCTION ME_C11
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C11';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvi_delta         FLOAT;

BEGIN

   --------------------------------------------------------------------------------
   -- Retrieve delta between exec_end_date and CURRENT_TIMESTAMP to prevent unneccessary status changes
   --------------------------------------------------------------------------------
    SELECT (CAST(CURRENT_TIMESTAMP as date) - CAST(exec_end_date as date)) * 24 * 60 * 60
     INTO lvi_delta
     FROM utscpa
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;

   --------------------------------------------------------------------------------
   -- Difference should be less than 5 seconds
   --------------------------------------------------------------------------------
   IF (lvi_delta > 5) THEN
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;

   IF APAOCONDITION.PARESULTAVAILABLE AND NOT APAOCONDITION.MERESULTAVAILABLE THEN
    RETURN (UNAPIGEN.DBERR_SUCCESS);
  END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C11;

--------------------------------------------------------------------------------
-- Methode C12
-- Automatisch, (vanuit elke status), na het schrappen van de methode
--------------------------------------------------------------------------------
FUNCTION ME_C12
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C12';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C12;

--------------------------------------------------------------------------------
-- Methode C13
-- Automatisch, indien de mtcell hours2wait aanwezig is en
-- ME_C02 = true of ME_C06 = true
--------------------------------------------------------------------------------
FUNCTION ME_C13
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C13';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvi_count         NUMBER;

BEGIN

   IF ME_C02 != UNAPIGEN.DBERR_SUCCESS AND ME_C06 != UNAPIGEN.DBERR_SUCCESS THEN
      RETURN UNAPIGEN.DBERR_GENFAIL;
   END IF;
   --------------------------------------------------------------------------------
   -- Check for cell hours2wait
   --------------------------------------------------------------------------------
   SELECT COUNT(*)
     INTO lvi_count
     FROM utmtcell
    WHERE mt = UNAPIEV.P_ME AND version = UNAPIEV.P_MT_VERSION
      AND cell = ics_mtcell_hours2wait;
   --------------------------------------------------------------------------------
   -- Cell hours2wait is available => success
   --------------------------------------------------------------------------------
   IF lvi_count > 0 THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   ELSE
      RETURN UNAPIGEN.DBERR_GENFAIL;
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C13;

--------------------------------------------------------------------------------
-- Methode C14
-- Automatically once the sample has been cancelled
--------------------------------------------------------------------------------
FUNCTION ME_C14
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_C14';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   --------------------------------------------------------------------------------
   -- Return success if the current sample is cancelled
   --------------------------------------------------------------------------------
   IF APAOCONDITION.MESCISCANCELLED THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   ELSE
      RETURN UNAPIGEN.DBERR_GENFAIL;
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ME_C14;

--------------------------------------------------------------------------------
-- FUNCTION : ST_C01
-- ABSTRACT :
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
-- 29/03/2016 | AF        | Added check whether the template configuration is
--                          correct
--------------------------------------------------------------------------------
FUNCTION ST_C01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_C01';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.StCorrectTemplateConfig AND
      NOT APAOCONDITION.STISTEMPLATE AND
      APAOCONDITION.STNEWFROMINTERSPEC AND
      NOT APAOCONDITION.STFIRSTMAJOR AND
      NOT APAOCONDITION.STUSETEMPLATE THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ST_C01;

--------------------------------------------------------------------------------
-- Sampletype C02
--------------------------------------------------------------------------------
FUNCTION ST_C02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_C02';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF NOT APAOCONDITION.STISTEMPLATE AND
      APAOCONDITION.STNEWFROMINTERSPEC AND
      APAOCONDITION.STFIRSTMAJOR THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ST_C02;
--------------------------------------------------------------------------------
-- Sampletype C03
--------------------------------------------------------------------------------
FUNCTION ST_C03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_C03';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

  IF NOT APAOCONDITION.STISTEMPLATE AND
      APAOCONDITION.STHASCUSTOMFREQ AND
      (APAOCONDITION.STCREATEDBYUNDIFF OR APAOCONDITION.STCREATEDBYSTAPPLYTEMPLATE) THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ST_C03;
--------------------------------------------------------------------------------
-- Sampletype C04
--------------------------------------------------------------------------------
FUNCTION ST_C04
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_C04';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF NOT APAOCONDITION.STISTEMPLATE AND
      APAOCONDITION.STTEMPLATEHASMANUALFREQ AND
      (APAOCONDITION.STCREATEDBYUNDIFF OR APAOCONDITION.STCREATEDBYSTAPPLYTEMPLATE OR APAOCONDITION.STCREATEDBYSTPPAPPLYISFREQ) THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ST_C04;
--------------------------------------------------------------------------------
-- Sampletype C05
--------------------------------------------------------------------------------
FUNCTION ST_C05
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_C05';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF NOT APAOCONDITION.STISTEMPLATE AND
      NOT APAOCONDITION.STTEMPLATEHASMANUALFREQ AND
      (APAOCONDITION.STCREATEDBYUNDIFF OR APAOCONDITION.STCREATEDBYSTAPPLYTEMPLATE OR APAOCONDITION.STCREATEDBYSTPPAPPLYISFREQ) THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ST_C05;

--------------------------------------------------------------------------------
-- FUNCTION : ST_C06
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
-- xx/xx/20xx | AF        | Created
-- 10/03/2016 | AF        | Implemented function
--------------------------------------------------------------------------------
FUNCTION ST_C06
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_C06';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.STISTEMPLATE THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ST_C06;

--------------------------------------------------------------------------------
-- FUNCTION : ST_C07
-- ABSTRACT : This function returns SUCCESS when the sample type is not created
--            from Interspec
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
-- 28/04/2016 | AF        | Rewritten code
--------------------------------------------------------------------------------
FUNCTION ST_C07
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_C07';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE := UNAPIGEN.DBERR_GENFAIL;

BEGIN
   -----------------------------------------------------------------------------
   -- Check whether active sampletype is not from Interspec
   -----------------------------------------------------------------------------
   IF NOT APAOCONDITION.StNewFromInterspec THEN
      lvi_ret_code := UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ST_C07;

--------------------------------------------------------------------------------
-- FUNCTION : ST_C08
-- ABSTRACT :
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
-- 29/03/2016 | AF        | Added check whether the template configuration is
--                          correct
--------------------------------------------------------------------------------
FUNCTION ST_C08
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_C08';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.StCorrectTemplateConfig AND
      NOT APAOCONDITION.STISTEMPLATE AND
      APAOCONDITION.STNEWFROMINTERSPEC AND
      NOT APAOCONDITION.STFIRSTMAJOR AND
      APAOCONDITION.STUSETEMPLATE THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ST_C08;
--------------------------------------------------------------------------------
-- Sampletype C09
--------------------------------------------------------------------------------
FUNCTION ST_C09
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_C09';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

  RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END ST_C09;

--------------------------------------------------------------------------------
-- Parameterprofile C01
--------------------------------------------------------------------------------
FUNCTION PP_C01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_C01';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF NOT APAOCONDITION.PPISTEMPLATE AND
      APAOCONDITION.PPNEWFROMINTERSPEC AND
      NOT APAOCONDITION.PPFIRSTMAJOR AND
      NOT APAOCONDITION.PPUSETEMPLATE THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PP_C01;

--------------------------------------------------------------------------------
-- Parameterprofile C02
--------------------------------------------------------------------------------
FUNCTION PP_C02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_C02';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF NOT APAOCONDITION.PPISTEMPLATE AND
      APAOCONDITION.PPNEWFROMINTERSPEC AND
      APAOCONDITION.PPFIRSTMAJOR THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PP_C02;

--------------------------------------------------------------------------------
-- Parameterprofile C03
--------------------------------------------------------------------------------
FUNCTION PP_C03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_C03';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF NOT APAOCONDITION.PPISTEMPLATE AND
      APAOCONDITION.PPHASCUSTOMFREQ AND
      (APAOCONDITION.PPCREATEDBYUNDIFF OR APAOCONDITION.PPCREATEDBYPPAPPLYTEMPLATE OR APAOCONDITION.PPCREATEDBYSTAPPLYTEMPLATE) THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PP_C03;

--------------------------------------------------------------------------------
-- FUNCTION : PP_C04
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
-- xx/xx/20xx | AF        | Created
-- 10/03/2016 | AF        | Rewritten function
--------------------------------------------------------------------------------
FUNCTION PP_C04
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_C04';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.PPNEWFROMINTERSPEC AND NOT APAOCONDITION.PpInTemplateWithPpKey1 THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PP_C04;

--------------------------------------------------------------------------------
-- Parameterprofile C05
--------------------------------------------------------------------------------
FUNCTION PP_C05
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_C05';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF NOT APAOCONDITION.PPISTEMPLATE AND
      (APAOCONDITION.PPCREATEDBYUNDIFF OR APAOCONDITION.PPCREATEDBYPPAPPLYTEMPLATE OR APAOCONDITION.PPCREATEDBYSTAPPLYTEMPLATE OR APAOCONDITION.PPCREATEDBYPPPRAPPLYISFREQ ) THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PP_C05;

--------------------------------------------------------------------------------
-- Parameterprofile C06
--------------------------------------------------------------------------------
FUNCTION PP_C06
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_C06';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF NOT APAOCONDITION.PPISTEMPLATE AND
      APAOCONDITION.PPNEWFROMINTERSPEC AND
      NOT APAOCONDITION.PPFIRSTMAJOR AND
      APAOCONDITION.PPUSETEMPLATE THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PP_C06;

--------------------------------------------------------------------------------
-- FUNCTION : PP_C07
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
-- xx/xx/20xx | AF        | Created
-- 29/03/2016 | AF        | Rewritten function
--------------------------------------------------------------------------------
FUNCTION PP_C07
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_C07';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF NOT APAOCONDITION.PPISTEMPLATE AND
      APAOCONDITION.PPNEWFROMINTERSPEC AND
      APAOCONDITION.PpInTemplateWithPpKey1 THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PP_C07;

--------------------------------------------------------------------------------
-- Parameter C01
--------------------------------------------------------------------------------
FUNCTION PR_C01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PR_C01';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF UNAPIEV.P_EV_REC.object_tp = 'pr' THEN

      IF APAOCONDITION.PRNEWFROMINTERSPEC AND
         APAOCONDITION.PRHASTEMPLATE THEN
         RETURN UNAPIGEN.DBERR_SUCCESS;
      END IF;

   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PR_C01;
--------------------------------------------------------------------------------
-- Parameter C02
--------------------------------------------------------------------------------
FUNCTION PR_C02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PR_C02';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF UNAPIEV.P_EV_REC.object_tp = 'pr' THEN

     IF APAOCONDITION.PRNEWFROMINTERSPEC AND
        NOT APAOCONDITION.PRHASTEMPLATE  THEN
        RETURN UNAPIGEN.DBERR_SUCCESS;
     END IF;

   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PR_C02;

--------------------------------------------------------------------------------
-- Parameter C03
--------------------------------------------------------------------------------
FUNCTION PR_C03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PR_C03';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF UNAPIEV.P_EV_REC.object_tp = 'pr' THEN

      IF APAOCONDITION.PRCREATEDBYPRAPPLYTEMPLATE THEN
         RETURN UNAPIGEN.DBERR_SUCCESS;
      END IF;

   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PR_C03;

--------------------------------------------------------------------------------
-- Parameter C04
--------------------------------------------------------------------------------
FUNCTION PR_C04
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PR_C04';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.PRCREATEDBYPRNEWMINOR THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END PR_C04;

--------------------------------------------------------------------------------
-- Infocard C01
--------------------------------------------------------------------------------
FUNCTION IC_C01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'IC_C01';
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;

BEGIN

   --------------------------------------------------------------------------------
   -- Do we deal with a requestinfocard
   --------------------------------------------------------------------------------
   IF APAOGEN.eventtriggered ('RqInfoFieldValuesChanged') THEN
      --------------------------------------------------------------------------------
      -- Condition triggered by request
      --------------------------------------------------------------------------------
      RETURN UNAPIGEN.DBERR_SUCCESS;
   ELSIF APAOGEN.eventtriggered ('InfoFieldValuesChanged') THEN
      --------------------------------------------------------------------------------
      -- Condition triggered by sample
      --------------------------------------------------------------------------------
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   --------------------------------------------------------------------------------
   -- We do not deal with a request or sample infocard
   --------------------------------------------------------------------------------
   RETURN (UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END IC_C01;

--------------------------------------------------------------------------------
-- Infocard C02
--------------------------------------------------------------------------------
FUNCTION IC_C02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'IC_C02';
lvi_ret_code      APAOGEN.RETURN_TYPE;
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;

BEGIN

   IF APAOCONDITION.ICTOPIBS THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   ELSE
      RETURN UNAPIGEN.DBERR_GENFAIL;
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END IC_C02;

--------------------------------------------------------------------------------
-- Check if more than 1 PA' s with attribute Destructive and value 1 are present
--------------------------------------------------------------------------------
FUNCTION SC_C16
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C16';
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

   IF APAOCONDITION.ScDestructiveError THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   ELSE
      RETURN UNAPIGEN.DBERR_GENFAIL;
   END IF;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C16;

--------------------------------------------------------------------------------
-- Monster C17
--------------------------------------------------------------------------------
FUNCTION SC_C17
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_C17';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;
lvi_count           NUMBER;
BEGIN

   IF APAOCONDITION.ScPlannedToAvailable THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   RETURN(UNAPIGEN.DBERR_GENFAIL);

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_C17;

FUNCTION WS_C02
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WS_C02';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvi_count NUMBER;

BEGIN
	-----------------------------------------------------------
	-- For the SC’s belonging to the WS
	-- With a PA with a ME which equals to the WS groupkey avTestmethod
	-- If one PA with state ‘To Validate’ return TRUE else FALSE
	-----------------------------------------------------------
      SELECT COUNT(pa.ss)
      INTO lvi_count
	  FROM UTWSSC   ws
		 , UTSCPA   pa
		 , UTSCME   me
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
		AND ws.ws = wsgk.ws
		AND pa.ss = 'TV';

	IF (lvi_count > 0) THEN
		RETURN UNAPIGEN.DBERR_SUCCESS;
	END IF;
    RETURN UNAPIGEN.DBERR_GENFAIL;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WS_C02;

FUNCTION WS_C03
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WS_C03';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvi_count NUMBER;

BEGIN
	IF APAOCONDITION.paOnePaTV THEN
		RETURN UNAPIGEN.DBERR_SUCCESS;
	END IF;
    RETURN UNAPIGEN.DBERR_GENFAIL;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WS_C03;

FUNCTION WS_C04
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WS_C04';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvi_total NUMBER;
lvi_count NUMBER;

BEGIN
	-----------------------------------------------------------
	-- If all PA' shave state Completed or Cancelled return TRUE
	-----------------------------------------------------------
	SELECT COUNT(pa.ss)
	   ,  SUM(DECODE(pa.ss, 'CM', 1,
							'@C', 1, 0))
		  INTO lvi_total, lvi_count
		  FROM UTWSSC   ws
			 , UTSCPA   pa
		  WHERE ws.ws = UNAPIEV.P_WS
			AND pa.sc = ws.sc;

	IF (lvi_total > 0) AND (lvi_total = lvi_count) THEN
		RETURN UNAPIGEN.DBERR_SUCCESS;
	END IF;
    RETURN UNAPIGEN.DBERR_GENFAIL;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WS_C04;

FUNCTION GetVersion
  RETURN VARCHAR2
IS
BEGIN
  RETURN('06.07.00.00_13.00');
EXCEPTION
  WHEN OTHERS THEN
	 RETURN (NULL);
END GetVersion;


END UNCONDITION;