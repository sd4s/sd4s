create or replace PACKAGE BODY        UNACTION AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : UNACTION
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
-- 14/02/2007 | RS        | Created
-- 07/03/2007 | RS        | Changed PA_A01
-- 07/03/2007 | RS        | Added ME_A01
-- 07/03/2007 | RS        | Added PG_A02
-- 07/03/2007 | RS        | Added PG_A03
-- 29/03/2007 | RS        | Changed PG_A01 (removed version = ~Current~)
-- 29/03/2007 | RS        | Changed PA_A02 (removed version = ~Current~)
-- 10/04/2007 | RS        | Added ClearPaResultRenanal
-- 10/04/2007 | RS        | Added ME_A02
-- 12/04/2007 | RS        | Changed SC_A01
-- 29/05/2007 | RS        | Added ME_A03
-- 29/05/2007 | RS        | Changed ClearPaResultRenanal
-- 05/06/2007 | RS        | Changed PA_A01 (use querie i.s.o. api-calls)
-- 19/07/2007 | AF        | Added PG_A04
-- 01/08/2007 | RS        | Bugfix PG_A04 (added st_version on utstpp)
-- 21/11/2007 | RS        | Added SC_A02
-- 21/11/2007 | RS        | Added ME_A04
-- 18/12/2007 | RS        | Added ME_A05
-- 11/01/2008 | RS        | Added MTCELLLIST
-- 18/01/2008 | RS        | Changed ME_A05
-- 24/01/2008 | RS        | Changed ME_A05 (av1.2.C02)
-- 25/01/2008 | RS        | Changed PG_A02 (av1.2.C05)
--                        | Changed PG_A03 (av1.2.C05)
--                        | Added CreateMeCells (av1.2.C07)
-- 30/01/2008 | RS        | Changed ME_A05 (av1.2.C02)
-- 01/02/2008 | RS        | Added ME_A06 (av1.2.C09)
-- 06/02/2008 | RS        | Added function RQ_A01  (av2.0.C05)
-- 14/02/2008 | RS        | Changed ME_A06 (av1.2.C09)
--                        | Changed ME_A05 (av1.2.C02/C11)
--                        | Added ME_A07 (av1.2.C12)
-- 15/02/2008 | RS        | Changed ME_A07 (av1.2.C12)
--                        | Added PA_A03 (av1.2.C04)
--                        | Added RQ_A02 (av2.0.C05)
-- 19/02/2008 | RS        | Changed ME_A07 (av1.2.C12)
-- 06/03/2008 | RS        | Changed ME_A06 (av1.2.C09)
--                        | Added ME_A08 (av1.2.C09)
--                        | Added PA_A04
-- 26/03/2008 | RS        | Changed MTCELLLIST
-- 02/04/2008 | RS        | Changed ME_A07 (av1.2.C12) - do not overwrite values
--                        | Changed CreateMeCells - added logging
--                        | Changed ME_A08 (av1.2.C09) - changed event EvaluateMeDetails
--                        | Added ME_A09
-- 17/04/2008 | RS        | Added RQ_A03 (av2.0.C03)
--                        | Added ME_A10 (av2.0.C07)
-- 29/05/2008 | RS        | Added PA_A05
--                        | Renamed ClearPaResultRenanal into ReanalysePa
-- 03/06/2008 | RS        | Changed ME_A09
--                        | Changed ME_A10
--                        | Added PG_A05
--                        | Added ME_A11
-- 10/06/2008 | RS        | Added RQ_A04
--                        | Added RQ_A05
-- 11/06/2008 | RS        | Added ME_A05
-- 12/06/2008 | HVB       | Added Comment
-- 25/06/2008 | RS        | Changed API-calls AddComment into APAOFUNCTIONS.AddComment
-- 06/08/2008 | RS        | Changed ME_A03 ( added au avCustCreateImportId)
--                        | Added SYS_A01
--                        | Added II_A01
-- 17/09/2008 | HVB       | HVB01: Changed PA_A04. Also writing avTestMethodDesc
-- 26/09/2008 | RS        | Added ST_A01
--                        | Added 3
--                        | Added ST_A03
--                        | Added ST_A04
--                        | Added ST_A09
--                        | Added ST_A10
--                        | Added PP_A01
--                        | Added PP_A02
--                        | Added PP_A03
--                        | Added PP_A04
--                        | Added PP_A05
-- 01/10/2008 | RS        | Added PR_A01
--                        | Added PR_A02
-- 05/11/2008 | RS        | Changed ST_A03
-- 26/11/2008 | RS        | Added ST_A08
-- 10/12/2008 | RS        | Changed ST_A04
-- 21/01/2009 | RS        | Added ME_A13
--                        | Changed ME_A07 (av2.2.C01)
--                        | Added DeleteMeCells (av2.2.C02)
--                        | Added ME_A14 (av2.2.C02)
-- 11/02/2009 | RS        | Added ME_A15
--                        | Changed ME_A07
--                        | Changed ME_A14
-- 11/03/2009 | RS        | Changed ME_A13 (av2.2.C03)
--                        | Removed ME_A14 (av2.2.C03)
--                        | Removed ME_A13
-- 25/03/2009 | RS        | Added RQ_A06
--                        | Added SC_A03
-- 12/05/2009 | HVB       | Changed RQ_A05: TRIM responsible
--            |           | Marker HVB01
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
--                        | Changed DATE; INTO TIMESTAMP WITH TIME ZONE;
--                        | Changed SendMail into new version from Siemens
-- 17/03/2010 | RS        | Changed StGkPpKeysOnStPpAss (Upgrade Interface Interspec - Unilab V6.4)
--                        | Removed MTCELLLIST
-- 12/05/2011 | RS        | Added IC_A01
-- 13/02/2013 | RS        | Changed ME_A09 : Fill exec_end_date of parameter
--                               | Added RQ_A07
--                        | Added WS_A01
--                                               | Added WS_A02
--                                               | Added WS_A03
--                        | Added RQ_A08
--                        | Added WS_A04
--                        | Added RQ_A09
--                        | Added WS_A05
--                        | Changed PG_A03
--                        | Removed PG_A03_2
--                        | Removed RR_TEST
-- 13/03/2013  | RS       | Changed PG_A03 (create samples via job)
--      /2015  | MV       | Added LogTransition
-- 07/07/2015  | JR       | Changed LogTransition, I1504-067-Update-of-the-Real-time-field-of-a-method
-- 09/07/2015  | JR       | Changed PA_A04, I1506-161-geen UA-avTestMethod
-- 24/09/2015  | JR       | Changed LogTransition, only save if retrieval succeeded
-- 24/09/2015  | JR       | Changed PA_A04, get PA description from MEcelllistoutput, I1509-095
-- 28/01/2016  | JR       | Changed LogTransition, and added ME_A16
-- 11/02/2016  | JR       | Changed changed ME_A16, now also register real_cost
-- 29/03/2016  | AF       | Altered function ST_A10
-- 29/03/2016  | AF       | Added function PP_A10
-- 23/06/2016  | JR       | Added function SC_A04 and SC_A05 (ERULG101C)
-- 23/06/2016  | JP/JR    | Added function ME_A17 (ERULG001D)
-- 23/06/2016  | JP/JR    | Added functions CO_A01, CO_A02 (ERULG202)
-- 30/06/2016  | JR       | Added function RQ_A10 (ERULG013C)
-- 30/06/2016  | JR       | Added function SC_A06 (ERULG013C)
-- 13/07/2016  | JP       | Altered functions SC_A06 and RQ_A10 (ERULG013C)
-- 19/08/2016  | JP       | Additional arguments for APAOFUNCTIONS.AssignParameter (PA_A02, PG_A04)
--             |          | Corrected error logging in ME_A16
-- 23/08/2016  | JP       | Added object ID quoting in ME_A16, StGkPpKeysOnStPpAss and LogTransition
--             |          | Corrected SC_A06 to ignore samples that don't have a date5 infofield.
-- 01/09/2016  | JR       | Altered function SC_A04 (ERULG101C)
-- 09/02/2017  | JR       | Added function PG_A06 (I1612-371)
-- 16/03/2017  | JR       | Altered function PG_A06 (I1612-371)
-- 20/07/2017  | JR       | Added function PA_A08, RQ_A11 (I1705-020 Extra request status)
--                        | Added function SC_A07, WS_A06 (I1705-020 Extra request status)
-- 31/05/2021  | PS       | Added function SC_A08 (fill SC/II-PI-start-date tbv Indoor-testing KPI-tijden)
-- 05-07-2021  | PS       | Added function ME_A19 (find FEA-simulation-errors and mail to users) 
-- 21-10-2021  | PS       | Modify function RQ_A08 (add exception-handler fetch-out-of-sequence after cancel-RQ/WS)
-- 25-10-2021  | PS       | Modify function RQ_A08 (replace cancelws-proc by local-implementation without cancel-utscme)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT APAOGEN.API_NAME_TYPE := 'UNACTION';
ics_au_cust_pp_type              CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('au_custpptype');
ics_au_cust_description          CONSTANT APAOGEN.NAME_TYPE     := APAOCONSTANT.GetConstString ('au_customer_description');
ics_au_wait_for                  CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('au_wait_for');
ics_au_createpgmultiple          CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('au_createpgmultiple');
ics_au_createpamultiple          CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('au_createpamultiple');
ics_au_specification             CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('au_specification');
ics_auvalue_master               CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('auvalue_master');
ics_auvalue_slave                CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('auvalue_slave');
ics_mtcell_hours2wait            CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('mtcell_hours2wait');
ics_mtcell_timerCompleted        CONSTANT APAOGEN.NAME_TYPE      := APAOCONSTANT.GetConstString ('mtcell_timerCompleted');
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
P_SMTP_SERVER     VARCHAR2(255);
P_SMTP_DOMAIN     VARCHAR2(255);
P_SMTP_SENDER     VARCHAR2(255);

l_sql_string      VARCHAR2(2000);
l_result          NUMBER;
l_sqlerrm         VARCHAR2(255);
l_ret_code        NUMBER;

StpError          EXCEPTION;

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- INTERNAL FUNCTIONS
--------------------------------------------------------------------------------
PROCEDURE TraceError
(a_api_name     IN        VARCHAR2,    /* VC40_TYPE */
 a_error_msg    IN        VARCHAR2)    /* VC255_TYPE */
IS
PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
   --autonomous transaction used here
   --UNAPIGEN.LogError is also an autonomous transaction but may rollback the current transaction
   INSERT INTO uterror(client_id, applic, who, logdate, api_name, error_msg)
   VALUES (UNAPIGEN.P_CLIENT_ID, SUBSTR(UNAPIGEN.P_APPLIC_NAME,1,8), NVL(UNAPIGEN.P_USER,USER), CURRENT_TIMESTAMP,
           SUBSTR(a_api_name,1,40), SUBSTR(a_error_msg,1,255));
   COMMIT;
END TraceError;

FUNCTION GenerateNextCodemask (avs_code_mask IN  VARCHAR2)
RETURN VARCHAR2 IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'GenerateNextCodemask';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;

lvs_st           VARCHAR2(20);
lvs_st_version   VARCHAR2(20);
lvs_rt           VARCHAR2(20);
lvs_rt_version   VARCHAR2(20);
lvs_rq           VARCHAR2(20);
lvd_ref_date     TIMESTAMP WITH TIME ZONE;
lvs_next_val     VARCHAR2(255);
lvs_edit_allowed CHAR(1);
lvs_valid_cf     VARCHAR2(20);
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN

   lvs_st := '';
   lvs_st_version := '';
   lvs_rt := '';
   lvs_rt_version := '';
   lvs_rq := '';
   lvd_ref_date := CURRENT_TIMESTAMP;

   lvi_ret_code := UNAPIUC.CREATENEXTUNIQUECODEVALUE
                   (avs_code_mask,
                    lvs_st,
                    lvs_st_version,
                    lvs_rt,
                    lvs_rt_version,
                    lvs_rq,
                    lvd_ref_date,
                    lvs_next_val,
                    lvs_edit_allowed,
                    lvs_valid_cf);

   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'GenerateNextCodemask failed. Returncode <' || lvi_ret_code || '>';
        APAOGEN.LogError (lcs_function_name, SQLERRM);
       RETURN NULL;
   END IF;

   RETURN lvs_next_val;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN SQLCODE;
END GenerateNextCodemask;

--------------------------------------------------------------------------------
-- START OF CUSTOMIZATION
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------
FUNCTION SYS_A01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SYS_A01';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvi_nr_of_rows     NUMBER;
lvs_modify_reason  VARCHAR2(255);
lts_value_tab      UNAPIGEN.VC40_TABLE_TYPE;

lvs_allow_modify   UTPP.ALLOW_MODIFY%TYPE;
lvs_version        UTAU.VERSION%TYPE;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_au IS
SELECT au, version
  FROM utau
 WHERE au = 'avAssignFreqTp'
   AND version_is_current = 1;

CURSOR lvq_pppr IS
SELECT pp, version,
       pp_key1, pp_key2, pp_key3, pp_key4, pp_key5,
       pr, pr_version, freq_tp
  FROM utpppr
 WHERE pp = UNAPIEV.P_EV_REC.OBJECT_ID
   AND version = UNAPIEV.P_VERSION;

CURSOR lvq_prmt IS
SELECT pr, version,
       mt, mt_version, freq_tp
  FROM utprmt
 WHERE pr = UNAPIEV.P_EV_REC.OBJECT_ID
   AND version = UNAPIEV.P_VERSION;

BEGIN

   --------------------------------------------------------------------------------
   -- Only for configuration parameterprofiles
   --------------------------------------------------------------------------------
   IF UNAPIEV.p_ev_rec.object_tp = 'pp' THEN
      --------------------------------------------------------------------------------
      -- Loop through list of attributes
      --------------------------------------------------------------------------------
      FOR lvr_au IN lvq_au LOOP
         --------------------------------------------------------------------------------
         -- Fill arguments
         --------------------------------------------------------------------------------
         lvi_nr_of_rows    := 1;
         lvs_modify_reason := 'Attribute assigned by ' || lcs_function_name;
         --------------------------------------------------------------------------------
         -- Loop through all parameters assigned to this parameterprofile
         --------------------------------------------------------------------------------
         FOR lvr_pppr IN lvq_pppr LOOP
            --------------------------------------------------------------------------------
            -- Get current allow_modify
            -- (DisableAllowModifyCheck does not work on this level)
            --------------------------------------------------------------------------------
            SELECT NVL(MAX(allow_modify), '0')
              INTO lvs_allow_modify
              FROM utpp
             WHERE pp = lvr_pppr.pp AND version = lvr_pppr.version;
            --------------------------------------------------------------------------------
            -- Set au_value to freq_tp
            --------------------------------------------------------------------------------
            lts_value_tab(1)  := lvr_pppr.freq_tp;
            --------------------------------------------------------------------------------
            -- Allow this object to be modified
            -- (DisableAllowModifyCheck does not work on this level)
            --------------------------------------------------------------------------------
            UPDATE utpp
               SET allow_modify = 1
             WHERE pp = lvr_pppr.pp AND version = lvr_pppr.version;
            --------------------------------------------------------------------------------
            -- Save attribute
            --------------------------------------------------------------------------------
            lvi_ret_code := UNAPIPPP.SAVE1PPPRATTRIBUTE(lvr_pppr.pp,
                                                        lvr_pppr.version,
                                                        lvr_pppr.pp_key1,
                                                        lvr_pppr.pp_key2,
                                                        lvr_pppr.pp_key3,
                                                        lvr_pppr.pp_key4,
                                                        lvr_pppr.pp_key5,
                                                        lvr_pppr.pr,
                                                        lvr_pppr.pr_version,
                                                        lvr_au.au,
                                                        lvr_au.version,
                                                        lts_value_tab,
                                                        lvi_nr_of_rows,
                                                        lvs_modify_reason);
            IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
                APAOGEN.LogError (lcs_function_name, 'Error while saving attribute <' || lvr_au.au || '> on link pp-pr <' || lvr_pppr.pp || '-' || lvr_pppr.pr || '> Function returned: <' || lvi_ret_code || '>');
            END IF;
            --------------------------------------------------------------------------------
            -- Reset the allow_modify flag of this object to the original value
            -- (DisableAllowModifyCheck does not work on this level)
            --------------------------------------------------------------------------------
            UPDATE utpp
               SET allow_modify = lvs_allow_modify
             WHERE pp = lvr_pppr.pp AND version = lvr_pppr.version;
         END LOOP;
      END LOOP;
   --------------------------------------------------------------------------------
   -- Only for configuration parameters
   --------------------------------------------------------------------------------
   ELSIF UNAPIEV.p_ev_rec.object_tp = 'pr' THEN
      --------------------------------------------------------------------------------
      -- Loop through list of attributes
      --------------------------------------------------------------------------------
      FOR lvr_au IN lvq_au LOOP
         --------------------------------------------------------------------------------
         -- Fill arguments
         --------------------------------------------------------------------------------
         lvi_nr_of_rows    := 1;
         lvs_modify_reason := 'Attribute assigned by ' || lcs_function_name;
         --------------------------------------------------------------------------------
         -- Loop through all methods assigned to this parameter
         --------------------------------------------------------------------------------
         FOR lvr_prmt IN lvq_prmt LOOP
            --------------------------------------------------------------------------------
            -- Get current allow_modify
            -- (DisableAllowModifyCheck does not work on this level)
            --------------------------------------------------------------------------------
            SELECT NVL(MAX(allow_modify), '0')
              INTO lvs_allow_modify
              FROM utpr
             WHERE pr = lvr_prmt.pr AND version = lvr_prmt.version;
            --------------------------------------------------------------------------------
            -- Set au_value to freq_tp
            --------------------------------------------------------------------------------
            lts_value_tab(1)  := lvr_prmt.freq_tp;
            --------------------------------------------------------------------------------
            -- Allow this object to be modified
            -- (DisableAllowModifyCheck does not work on this level)
            --------------------------------------------------------------------------------
            UPDATE utpr
               SET allow_modify = 1
             WHERE pr = lvr_prmt.pr AND version = lvr_prmt.version;
            --------------------------------------------------------------------------------
            -- Save attribute
            --------------------------------------------------------------------------------
            lvs_version := lvr_au.version;
            lvi_ret_code := UNAPIPRP.Save1UsedObjectAttribute('pr',
                                                              'mt',
                                                              lvr_prmt.pr,
                                                              lvr_prmt.version,
                                                              lvr_prmt.mt,
                                                              lvr_prmt.mt_version,
                                                              lvr_au.au,
                                                              lvs_version,
                                                              lts_value_tab,
                                                              lvi_nr_of_rows,
                                                              lvs_modify_reason);
            IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
                APAOGEN.LogError (lcs_function_name, 'Error while saving attribute <' || lvr_au.au || '> on link pr-mt <' || lvr_prmt.pr || '-' || lvr_prmt.mt || '> Function returned: <' || lvi_ret_code || '>');
            END IF;
            --------------------------------------------------------------------------------
            -- Reset the allow_modify flag of this object to the original value
            -- (DisableAllowModifyCheck does not work on this level)
            --------------------------------------------------------------------------------
            UPDATE utpr
               SET allow_modify = lvs_allow_modify
             WHERE pr = lvr_prmt.pr AND version = lvr_prmt.version;
         END LOOP;
      END LOOP;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END SYS_A01;

--------------------------------------------------------------------------------
-- CO_A01: If a previous version exists which is a template, then this version
-- will become the template, and all previous versions will no longer be templates.
-- The action has been tested on the transition from @E to @A (ev_tp ObjectStatusChanged),
-- i.e. at the same time that version_is_current becomes set.
-- The action can be deployed in any configuration life cycle. (RT, ST, PP...)
--------------------------------------------------------------------------------
FUNCTION CO_A01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'CO_A01';

lvs_sql      VARCHAR2(2000);
lvs_id       VARCHAR2(2000);
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
lvi_count    INTEGER;
lvi_step     INTEGER;

BEGIN

   IF UNAPIEV.P_EV_REC.OBJECT_TP <> 'au' THEN -- au's don't have the is_template flag.

      -- This is implemented through UPDATE statements because the SaveObjectType API's are object type specific.

      IF UNAPIEV.P_EV_REC.OBJECT_TP <> 'pp' THEN
         lvs_id := UNAPIEV.P_EV_REC.OBJECT_TP||' = '''||UNAPIEV.P_EV_REC.OBJECT_ID||'''';
      ELSE
         lvs_id := 'pp = '''||UNAPIEV.P_EV_REC.OBJECT_ID||''' AND pp_key1 = '''||UNAPIEV.P_PP_KEY1||''''
                                                          ||' AND pp_key2 = '''||UNAPIEV.P_PP_KEY2||''''
                                                          ||' AND pp_key3 = '''||UNAPIEV.P_PP_KEY3||''''
                                                          ||' AND pp_key4 = '''||UNAPIEV.P_PP_KEY4||''''
                                                          ||' AND pp_key5 = '''||UNAPIEV.P_PP_KEY5||'''';
      END IF;

      lvi_step := 1;
      lvs_sql := 'SELECT COUNT (*) FROM ut'||UNAPIEV.P_EV_REC.OBJECT_TP||' WHERE '||lvs_id||' AND is_template = 1';
      EXECUTE IMMEDIATE lvs_sql INTO lvi_count;

      IF lvi_count > 0 THEN

         --APAOGEN.LogError (lcs_function_name, UNAPIEV.P_EV_REC.OBJECT_TP||' '||lvs_id||' ('||UNAPIEV.P_VERSION||') becomes current, '||lvi_count||' others are no longer current.');

         -- Switch off all template flags...
         lvi_step := 2;
         lvs_sql := 'UPDATE ut'||UNAPIEV.P_EV_REC.OBJECT_TP||' SET is_template = 0 WHERE '||lvs_id||' AND is_template = 1';
         EXECUTE IMMEDIATE lvs_sql;

         -- ... except for this version.
         lvi_step := 3;
         lvs_sql := 'UPDATE ut'||UNAPIEV.P_EV_REC.OBJECT_TP||' SET is_template = 1 WHERE '||lvs_id||' AND version = '||UNAPIEV.P_VERSION;
         EXECUTE IMMEDIATE lvs_sql;

      END IF;

   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SUBSTR ('Exception in step '||lvi_step||' ('||UNAPIEV.P_EV_REC.OBJECT_TP||' '||UNAPIEV.P_EV_REC.OBJECT_ID||'): '||SQLERRM, 1, 255));
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;
END CO_A01;

--------------------------------------------------------------------------------
-- CO_A02: this action acts on any configuration object. It toggles the object's template flag,
-- then sends an ObjectUpdated event to re-evaluate the life cycle.
--------------------------------------------------------------------------------
FUNCTION CO_A02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'CO_A02';

lvs_sqlerrm    APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code   APAOGEN.RETURN_TYPE;
lvs_ev_details utev.ev_details%TYPE;
lvs_sql        VARCHAR2(2000);
lvs_id         VARCHAR2(2000);
lvn_ev_seq_nr  NUMBER;
lvi_step       INTEGER;

BEGIN

   IF UNAPIEV.P_EV_REC.OBJECT_TP <> 'pp' THEN
      lvs_id := UNAPIEV.P_EV_REC.OBJECT_TP||' = '''||UNAPIEV.P_EV_REC.OBJECT_ID||'''';
      lvs_ev_details := 'version='||UNAPIEV.P_VERSION;
   ELSE
      lvs_id := 'pp = '''||UNAPIEV.P_EV_REC.OBJECT_ID||''' AND pp_key1 = '''||UNAPIEV.P_PP_KEY1||''''
                                                       ||' AND pp_key2 = '''||UNAPIEV.P_PP_KEY2||''''
                                                       ||' AND pp_key3 = '''||UNAPIEV.P_PP_KEY3||''''
                                                       ||' AND pp_key4 = '''||UNAPIEV.P_PP_KEY4||''''
                                                       ||' AND pp_key5 = '''||UNAPIEV.P_PP_KEY5||'''';
      lvs_ev_details := 'version='||UNAPIEV.P_VERSION||'#pp_key1='||UNAPIEV.P_PP_KEY1
                                                     ||'#pp_key2='||UNAPIEV.P_PP_KEY2
                                                     ||'#pp_key3='||UNAPIEV.P_PP_KEY3
                                                     ||'#pp_key4='||UNAPIEV.P_PP_KEY4
                                                     ||'#pp_key5='||UNAPIEV.P_PP_KEY5;
   END IF;

   lvi_step := 1;
   lvs_sql := 'UPDATE ut'||UNAPIEV.P_EV_REC.OBJECT_TP||
              ' SET is_template = DECODE (is_template, ''1'', ''0'', ''0'', ''1'')'||
              ' WHERE '||lvs_id||' AND version = '''||UNAPIEV.P_VERSION||'''';
   EXECUTE IMMEDIATE lvs_sql;
   --APAOGEN.LogError (lcs_function_name, 'Updated ' || UNAPIEV.P_EV_REC.OBJECT_TP || ' ' || lvs_id || '.') ;

   lvi_step       := 2;
   lvn_ev_seq_nr  := -1;
   lvi_ret_code := UNAPIEV.InsertEvent (lcs_function_name, UNAPIGEN.P_EVMGR_NAME, UNAPIEV.P_EV_REC.OBJECT_TP,
                                        UNAPIEV.P_EV_REC.OBJECT_ID, '', '', '', 'ObjectUpdated', lvs_ev_details,
                                        lvn_ev_seq_nr) ;
   --APAOGEN.LogError (lcs_function_name, 'Inserted event for ' || UNAPIEV.P_EV_REC.OBJECT_TP || ' ' || UNAPIEV.P_EV_REC.OBJECT_ID || ', returned '||lvi_ret_code||'.') ;

   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'InsertEvent for ' || UNAPIEV.P_EV_REC.OBJECT_TP || ' ' || UNAPIEV.P_EV_REC.OBJECT_ID || ' returned ' || l_ret_code || '.') ;
   END IF ;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SUBSTR ('Exception in step '||lvi_step||': '||SQLERRM, 1, 255));
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;
END CO_A02;

FUNCTION II_A01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'II_A01';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvs_modify_reason  VARCHAR2(255);
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_ii IS
SELECT a.rq, b.sc, b.ic, b.icnode, b.ii, b.iinode
  FROM utrqsc a, utscii b
 WHERE b.sc = UNAPIEV.P_SC
   AND b.ic = UNAPIEV.P_IC AND icnode = UNAPIEV.P_ICNODE
   AND b.ii = UNAPIEV.P_II AND iinode = UNAPIEV.P_IINODE
   AND a.sc = b.sc;

BEGIN

   --------------------------------------------------------------------------------
   -- Only for configuration parameterprofiles
   --------------------------------------------------------------------------------
   FOR lvr_ii IN lvq_ii LOOP
      lvi_ret_code := APAOFUNCTIONS.COPYRQIITOSCII(lvr_ii.rq,
                                                   lvr_ii.sc,
                                                   lvr_ii.ic, lvr_ii.icnode,
                                                   lvr_ii.ii, lvr_ii.iinode,
                                                   'Copied by ' || lcs_function_name );
      IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
         APAOGEN.LogError (lcs_function_name, 'Error while copying infofield  <' || lvr_ii.ii || '> from <' || lvr_ii.rq || '> to <' || lvr_ii.sc || '> Function returned: <' || lvi_ret_code || '>');
      END IF;
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END II_A01;

--------------------------------------------------------------------------------
-- RQ_A01: Generate and fill RQGK's "WaitFor" and "WaitForInitial" using BOM explosion in interspec.
--------------------------------------------------------------------------------
FUNCTION RQ_A01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A01';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

   RETURN APAOTRIALS.RQ_A01;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A01;


--------------------------------------------------------------------------------
-- RQ_A02: Removes RQGK "WaitFor" on the requests that were waiting on this one
--------------------------------------------------------------------------------
FUNCTION RQ_A02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A02';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

   RETURN APAOTRIALS.RQ_A02;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A02;


--------------------------------------------------------------------------------
-- RQ_A03: Generats an event on all underlying sc's and me's for reevaluating life cycle
--------------------------------------------------------------------------------
FUNCTION RQ_A03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A03';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_me_check IS
    SELECT a.sc,
           a.pg, a.pgnode,
           a.pa, a.panode,
           a.me, a.menode,
           a.mt_version,
           a.lc, a.lc_version,
           a.ss
      FROM utscme a, utrqsc b
     WHERE b.rq = UNAPIEV.P_RQ
       AND a.sc = b.sc;

CURSOR lvq_sc_check IS
    SELECT a.sc,
           a.st_version,
           a.lc, a.lc_version,
           a.ss
      FROM utsc a, utrqsc b
     WHERE b.rq = UNAPIEV.P_RQ
       AND a.sc = b.sc;

BEGIN

   --------------------------------------------------------------------------------
   -- Recheck all samples of current request
   --------------------------------------------------------------------------------
   FOR lvr_sc_check IN lvq_sc_check LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckSc( lvr_sc_check.sc,
                                                   lvr_sc_check.st_version,
                                                   lvr_sc_check.lc,
                                                   lvr_sc_check.lc_version,
                                                   lvr_sc_check.ss);
   END LOOP;
   --------------------------------------------------------------------------------
   -- Recheck all methods of current request
   --------------------------------------------------------------------------------
   FOR lvr_me_check IN lvq_me_check LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckMe( lvr_me_check.sc,
                                                   lvr_me_check.pg, lvr_me_check.pgnode,
                                                   lvr_me_check.pa, lvr_me_check.panode,
                                                   lvr_me_check.me, lvr_me_check.menode,
                                                   lvr_me_check.mt_version,
                                                   lvr_me_check.lc,
                                                   lvr_me_check.lc_version,
                                                   lvr_me_check.ss);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A03;

--------------------------------------------------------------------------------
-- RQ_A04: Recheck all samples of current request
--------------------------------------------------------------------------------


FUNCTION RQ_A04
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A04';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_rq_check IS
    SELECT rq,
           rt_version,
           lc, lc_version,
           ss
      FROM utrq
     WHERE rq = UNAPIEV.P_RQ;

BEGIN

   FOR lvr_rq_check IN lvq_rq_check LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckRq( lvr_rq_check.rq,
                                                   lvr_rq_check.rt_version,
                                                   lvr_rq_check.lc,
                                                   lvr_rq_check.lc_version,
                                                   lvr_rq_check.ss);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A04;


   --------------------------------------------------------------------------------
   -- RQ_A05: Copies RT: planned responsible -> SQ responsible
   --------------------------------------------------------------------------------

FUNCTION RQ_A05
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A05';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvs_responsible    VARCHAR2(20);

BEGIN
    SELECT NVL(MAX(planned_responsible), '-')
      INTO lvs_responsible
      FROM utrt a, utrq b
     WHERE a.rt = b.rt
       AND a.version = b.rt_version
       AND b.rq = UNAPIEV.P_RQ;

   IF lvs_responsible != '-' THEN
      UPDATE utrq
---HVB01         SET responsible = lvs_responsible
         SET responsible = TRIM(lvs_responsible)   ---HVB01
       WHERE rq = UNAPIEV.P_RQ
         AND responsible IS NULL;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A05;

   --------------------------------------------------------------------------------
   -- RQ_A06: Recheck ic of this rq
   --------------------------------------------------------------------------------

FUNCTION RQ_A06
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A06';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_rqic IS
SELECT rq, ic, icnode, ip_version, lc, lc_version, ss
  FROM utrqic
 WHERE rq = UNAPIEV.P_RQ;
BEGIN

   FOR lvr_rqic IN lvq_rqic LOOP
      --------------------------------------------------------------------------------
      -- Recheck all ic of this rq
      --------------------------------------------------------------------------------
      lvi_ret_code := APAOFUNCTIONS.RECHECKRQIC(UNAPIEV.P_RQ,
                                                lvr_rqic.ic, lvr_rqic.icnode,
                                                lvr_rqic.ip_version,
                                                lvr_rqic.lc, lvr_rqic.lc_version,
                                                lvr_rqic.ss);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A06;


FUNCTION RQ_A08
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- RQ_A08: Recheck all worksheets of current request, nadat RQ gecancelled is.
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A08';
--
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
--
fetch_out_of_sequence EXCEPTION;
PRAGMA EXCEPTION_INIT ( fetch_out_of_sequence, -1002);
l_last_ws             VARCHAR2(20);
--copy global-variables from unapiwsp (waarin cancelws-procedure in zit)
L_EVENT_TP                    UTEV.EV_TP%TYPE;
L_EV_SEQ_NR                   NUMBER;
L_EV_DETAILS                  VARCHAR2(255);
A_MODIFY_REASON               VARCHAR2(255);
--
L_CURRENT_TIMESTAMP           VARCHAR2(40);
L_PREVIOUS_ALLOW_MODIFY_CHECK CHAR(1);
--
L_LC                          VARCHAR2(2);
L_LC_VERSION                  VARCHAR2(20);
L_OLD_SS                      VARCHAR2(2);
L_NEW_SS                      VARCHAR2(2);
L_ALLOW_MODIFY                CHAR(1);
L_ACTIVE                      CHAR(1);
L_LOG_HS                      CHAR(1);
L_LOG_HS_DETAILS              CHAR(1);
L_LC_SS_FROM                  VARCHAR2(2);
L_TR_NO                       NUMBER(3);
L_HS_DETAILS_SEQ_NR           INTEGER;
L_WT_VERSION                  VARCHAR2(20);
L_NEW_EXEC_START_DATE         TIMESTAMP WITH TIME ZONE;
L_NEW_EXEC_END_DATE           TIMESTAMP WITH TIME ZONE;
L_NEW_EXEC_START_DATE_TZ      TIMESTAMP WITH TIME ZONE;
L_NEW_EXEC_END_DATE_TZ        TIMESTAMP WITH TIME ZONE;
--
CURSOR lvq_ws_check IS
SELECT ws.ws
FROM utwsgkrequestcode  ws
WHERE ws.requestcode = UNAPIEV.P_RQ
ORDER by ws.ws
;
--
CURSOR L_VERSION_CURSOR (l_ws varchar2)
IS
SELECT WT_VERSION 
FROM UTWS
WHERE WS = l_ws
;
BEGIN
   --
   --laat proces 15sec wachten, zodat cancel-rq klaar is, voordat we eventueel openstaande WS
   --gaan cancellen. Als deze processen samen lopen, levert dit conflicten op bij cancellen van UTSCME.
   --DBMS_LOCK.SLEEP(15);
   --
   FOR lvr_ws_check IN lvq_ws_check 
   LOOP
     l_last_ws       := lvr_ws_check.ws;
     A_MODIFY_REASON := 'Cancelled by ' || lcs_function_name;
     --PS: oorspronkelijk aanroep (incl. cancel-UTSCME):
     --l_ret_code := UNAPIWSP.CANCELWS(lvr_ws_check.ws, A_MODIFY_REASON);
     --start transactie.
     IF UNAPIGEN.BEGINTXN(UNAPIGEN.P_SINGLE_API_TXN) <> UNAPIGEN.DBERR_SUCCESS 
     THEN RAISE STPERROR;
     END IF;
     --
     L_CURRENT_TIMESTAMP := CURRENT_TIMESTAMP;
     L_LC := NULL;
     L_LC_VERSION := NULL;
     L_OLD_SS := NULL; 
     L_NEW_SS := '@C';
     --
     UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiWSP.CancelWs','WS-2: '||l_last_ws||' voor UNAPIWSP.WSTRANSITIONAUTHORISED');
     --
     /*
     A_WS                IN      VARCHAR2,     
     A_LC                IN OUT  VARCHAR2,     
     A_LC_VERSION        IN OUT  VARCHAR2,     
     A_OLD_SS            IN OUT  VARCHAR2,     
     A_NEW_SS            IN      VARCHAR2,     
     A_AUTHORISED_BY     IN      VARCHAR2,     
     A_LC_SS_FROM        OUT     VARCHAR2,     
     A_TR_NO             OUT     NUMBER,       
     A_ALLOW_MODIFY      OUT     CHAR,         
     A_ACTIVE            OUT     CHAR,         
     A_LOG_HS            OUT     CHAR,         
     A_LOG_HS_DETAILS    OUT     CHAR
     */
     L_RET_CODE := UNAPIWSP.WSTRANSITIONAUTHORISED(A_WS=>l_last_ws
                                                  ,A_LC=>L_LC
                                                  ,A_LC_VERSION=>L_LC_VERSION
                                                  ,A_OLD_SS=>L_OLD_SS
                                                  ,A_NEW_SS=>L_NEW_SS
                                                  ,A_AUTHORISED_BY=>UNAPIGEN.P_USER
                                                  ,A_LC_SS_FROM=>L_LC_SS_FROM
                                                  ,A_TR_NO=>L_TR_NO
                                                  ,A_ALLOW_MODIFY=>L_ALLOW_MODIFY
                                                  ,A_ACTIVE=>L_ACTIVE
                                                  ,A_LOG_HS=>L_LOG_HS
                                                  ,A_LOG_HS_DETAILS=>L_LOG_HS_DETAILS
                                                  );
     UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiWSP.CancelWs','WS-3: '||l_last_ws||' na UNAPIWSP.WSTRANSITIONAUTHORISED ret-code: '||l_ret_code);
     --
     IF  L_RET_CODE <> UNAPIGEN.DBERR_SUCCESS 
     AND L_RET_CODE <> UNAPIGEN.DBERR_NOTAUTHORISED 
     THEN  UNAPIGEN.P_TXN_ERROR := L_RET_CODE;
           RAISE STPERROR;
     END IF;
     --
     IF L_RET_CODE = UNAPIGEN.DBERR_SUCCESS 
     THEN
      OPEN L_VERSION_CURSOR(l_last_ws);
      FETCH L_VERSION_CURSOR INTO L_WT_VERSION;
      IF L_VERSION_CURSOR%NOTFOUND THEN
         CLOSE L_VERSION_CURSOR;
         UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_WTVERSION;
         RAISE STPERROR;
      END IF;
      CLOSE L_VERSION_CURSOR;
      --
      L_EVENT_TP := 'WsCanceled';
      L_EV_SEQ_NR := -1;
      L_EV_DETAILS := 'tr_no=' || L_TR_NO ||
                      '#ss_from=' || L_OLD_SS ||
                      '#lc_ss_from='|| L_LC_SS_FROM ||
                      '#wt_version=' || L_WT_VERSION;
      --
      UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiWSP.CancelWs','WS-4: '||l_last_ws||' voor UNAPIEV.INSERTEVENT CancelWs, event-tp: '||l_event_tp);
      --
      L_RESULT := UNAPIEV.INSERTEVENT('CancelWs', UNAPIGEN.P_EVMGR_NAME,
                                      'ws', l_last_ws, L_LC, L_LC_VERSION, L_NEW_SS,
                                      L_EVENT_TP, L_EV_DETAILS, L_EV_SEQ_NR);
      --                                 
      UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiWSP.CancelWs','WS-5: '||l_last_ws||' na UNAPIEV.INSERTEVENT CancelWs result: '||l_result);
      --
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS 
      THEN UNAPIGEN.P_TXN_ERROR := L_RESULT;
           RAISE STPERROR;
      END IF; 
      --      
      IF L_LOG_HS = '1' 
      THEN
         INSERT INTO UTWSHS(WS, WHO, WHO_DESCRIPTION, WHAT, WHAT_DESCRIPTION, LOGDATE, LOGDATE_TZ, WHY, TR_SEQ, EV_SEQ)
         VALUES(l_last_ws, UNAPIGEN.P_USER, UNAPIGEN.P_USER_DESCRIPTION, L_EVENT_TP, 
                'worksheet "'||l_last_ws||'" canceled, status is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'||UNAPIGEN.SQLSSNAME(L_NEW_SS)||'" ['||L_NEW_SS||'].', 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, A_MODIFY_REASON, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR);
      END IF;
      --
      L_HS_DETAILS_SEQ_NR := 0;
      IF L_LOG_HS_DETAILS = '1' 
      THEN
         L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
         INSERT INTO UTWSHSDETAILS(WS, TR_SEQ, EV_SEQ, SEQ, DETAILS)
         VALUES(l_last_ws, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR, 
                'worksheet "'||l_last_ws||'" canceled, status is changed from "'||UNAPIGEN.SQLSSNAME(L_OLD_SS)||'" ['||L_OLD_SS||'] to "'||UNAPIGEN.SQLSSNAME(L_NEW_SS)||'" ['||L_NEW_SS||'].');
      END IF;
      --
      UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiWSP.CancelWs','WS-6: '||l_last_ws||' voor UNAPIAUT.GETALLOWMODIFYCHECKMODE previous-allow-modify-check: '||L_PREVIOUS_ALLOW_MODIFY_CHECK);
      L_RESULT := UNAPIAUT.GETALLOWMODIFYCHECKMODE(L_PREVIOUS_ALLOW_MODIFY_CHECK);
      UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiWSP.CancelWs','WS-7: '||l_last_ws||' na UNAPIAUT.GETALLOWMODIFYCHECKMODE result: '||l_result);
      --
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS 
      THEN UNAPIGEN.P_TXN_ERROR := L_RESULT;
           RAISE STPERROR;
      END IF;
      --
      IF L_PREVIOUS_ALLOW_MODIFY_CHECK = '0' 
      THEN
         L_RESULT := UNAPIAUT.DISABLEALLOWMODIFYCHECK('1');
         IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS 
         THEN UNAPIGEN.P_TXN_ERROR := L_RESULT;
              RAISE STPERROR;
         END IF;
      END IF;
      L_RESULT := UNAPIAUT.DISABLEALLOWMODIFYCHECK(L_PREVIOUS_ALLOW_MODIFY_CHECK);
      --
      UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiWSP.CancelWs','WS-11a WSME: '||l_last_ws||' na UNAPIAUT.DISABLEALLOWMODIFYCHECK, result: '||l_result);
      --
      IF L_RESULT <> UNAPIGEN.DBERR_SUCCESS 
      THEN UNAPIGEN.P_TXN_ERROR := L_RESULT;
           RAISE STPERROR;
      END IF;
      --
      UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiWSP.CancelWs','WS-11b: '||l_last_ws||' voor update UTWS allow-modify=#');
      --
      UPDATE UTWS
      SET SS = L_NEW_SS,
          ALLOW_MODIFY = '#',
          ACTIVE = L_ACTIVE,
          EXEC_START_DATE = NVL(EXEC_START_DATE, L_CURRENT_TIMESTAMP),
          EXEC_START_DATE_TZ = NVL(EXEC_START_DATE, L_CURRENT_TIMESTAMP),
          EXEC_END_DATE = NVL(EXEC_END_DATE, L_CURRENT_TIMESTAMP),
          EXEC_END_DATE_TZ = NVL(EXEC_END_DATE, L_CURRENT_TIMESTAMP)
      WHERE WS = l_last_ws
      RETURNING EXEC_START_DATE, EXEC_START_DATE_TZ, EXEC_END_DATE, EXEC_END_DATE_TZ 
      INTO L_NEW_EXEC_START_DATE, L_NEW_EXEC_START_DATE_TZ, L_NEW_EXEC_END_DATE, L_NEW_EXEC_END_DATE_TZ
      ;
      IF SQL%ROWCOUNT = 0 
      THEN UNAPIGEN.P_TXN_ERROR := UNAPIGEN.DBERR_NOTFOUND;
           RAISE STPERROR;
      END IF;
      UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiWSP.CancelWs','WS-11c: '||l_last_ws||' na update UTWS allow-modify=#');
      IF L_LOG_HS_DETAILS = '1' 
      THEN        
         IF L_NEW_EXEC_START_DATE = L_CURRENT_TIMESTAMP 
         THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTWSHSDETAILS(WS, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(l_last_ws, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'worksheet "'||l_last_ws||'" is updated: property <exec_start_date_tz> changed value from "" to "' || TO_CHAR(L_NEW_EXEC_START_DATE_TZ) || '".');
         END IF;
         --
         IF L_NEW_EXEC_END_DATE = L_CURRENT_TIMESTAMP 
         THEN
            L_HS_DETAILS_SEQ_NR := L_HS_DETAILS_SEQ_NR + 1;
            INSERT INTO UTWSHSDETAILS(WS, TR_SEQ, EV_SEQ, SEQ, DETAILS)
            VALUES(l_last_ws, UNAPIGEN.P_TR_SEQ, L_EV_SEQ_NR, L_HS_DETAILS_SEQ_NR,
                   'worksheet "'||l_last_ws||'" is updated: property <exec_end_date_tz> changed value from "" to "' || TO_CHAR(L_NEW_EXEC_END_DATE_TZ) || '".');
         END IF;
      END IF;  --log-hs-details=1
     END IF;  --l-ret-code 
     --   
     IF UNAPIGEN.ENDTXN <> UNAPIGEN.DBERR_SUCCESS 
     THEN RAISE STPERROR;
     END IF;
     --
     UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiWSP.CancelWs','WS-12: '||l_last_ws||' voor UNAPIAUT.UPDATEAUTHORISATIONBUFFER @C');
     UNAPIAUT.UPDATEAUTHORISATIONBUFFER('ws', l_last_ws, NULL, '@C');
     UNAPIGEN.LOGERRORNOREMOTEAPICALL('UnapiWSP.CancelWs','WS-13 KLAAR: '||l_last_ws||' na UNAPIAUT.UPDATEAUTHORISATIONBUFFER voor WS naar @C, voor return: '||L_RET_CODE);
     --
   END LOOP;  --HOOFDLOOP: lvr_ws_check
   --
   RETURN UNAPIGEN.DBERR_SUCCESS;
   --
EXCEPTION
  WHEN FETCH_OUT_OF_SEQUENCE
  THEN 
    --we gaan ervan uit dat alle ws goed afgehandeld zijn, en returnen een SUCCESS, 
    --en geven daarmee impliciet een COMMIT op de hele transactie.
    APAOFUNCTIONS.LogInfo(avs_function_name=>lcs_function_name
                         ,avs_message=>'RQ_A08:FETCH-OUT-OF-SEQUENCE RQ='||UNAPIEV.P_RQ||' NA verwerking van ws: '||l_last_ws||' RETURN=SUCCESS' ); 
    RETURN UNAPIGEN.DBERR_SUCCESS;
  WHEN OTHERS 
  THEN
    IF SQLCODE != 1 
    THEN APAOGEN.LogError (lcs_function_name, SQLERRM);
    END IF;
    IF L_VERSION_CURSOR%ISOPEN THEN
      CLOSE L_VERSION_CURSOR;
    END IF;
    RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A08
;

FUNCTION RQ_A09
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A09';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_scpa IS
  SELECT b.sc, b.pg, b.pgnode, b.pa, b.panode, b.ss, b.lc, b.lc_version
    FROM utrqsc a,
         utscpa b
   WHERE a.rq = UNAPIEV.P_RQ
     AND a.sc = b.sc;

BEGIN

    FOR lvr_scpa IN lvq_scpa LOOP
         l_ret_code       := UNAPIPAP.CHANGESCPASTATUS
                   (lvr_scpa.sc,
                    lvr_scpa.pg,lvr_scpa.pgnode,
                    lvr_scpa.pa,lvr_scpa.panode,
                    lvr_scpa.ss,
                    'AV',
                    lvr_scpa.lc,
                    lvr_scpa.lc_version,
                    'Status changed by ' || lcs_function_name);

    END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A09;

----------------------------------------------------------------------------------------
-- RQ_A10: storing the availability date of a request (date5 field). The related info-field should be filled and the related fields should be triggered.
----------------------------------------------------------------------------------------
FUNCTION RQ_A10
RETURN APAOGEN.RETURN_TYPE IS

   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A10';
   lvi_ret_code       APAOGEN.RETURN_TYPE;

   -- SaveRqIiValue
   l_nr_of_rows     NUMBER := 1;
   l_rq_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_ic_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_icnode_tab      UNAPIGEN.LONG_TABLE_TYPE;
   l_ii_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_iinode_tab      UNAPIGEN.LONG_TABLE_TYPE;
   l_iivalue_tab     UNAPIGEN.VC2000_TABLE_TYPE;
   l_modify_flag_tab UNAPIGEN.NUM_TABLE_TYPE;

BEGIN

   -- Find the field that corresponds with date5.
   -- The MIN () functions are there in case there multiple infofields save to date5 (which is not a good idea but it still shouldn't lead to a SQL error).
   SELECT MIN (rq), MIN (ic), MIN (icnode), MIN (ii), MIN (iinode), MIN (TO_CHAR (SYSDATE, SUBSTR (NVL (format, 'DD/MON/YYYY HH24:MI:SS'), 2))), MIN (UNAPIGEN.MOD_FLAG_UPDATE)
   INTO l_rq_tab          (1),
        l_ic_tab          (1),
        l_icnode_tab      (1),
        l_ii_tab          (1),
        l_iinode_tab      (1),
        l_iivalue_tab     (1),
        l_modify_flag_tab (1)
   FROM utrqii, utie
   WHERE ii         = ie
     AND ie_version = version
     AND rq         = UNAPIEV.P_RQ
     AND def_val_tp = 'S'
     AND ievalue    = 'date5';

   -- Save the infofield; the event rule will take care of date5.
   lvi_ret_code := UNAPIRQ.SaveRqIiValue
                      (l_rq_tab,
                       l_ic_tab,
                       l_icnode_tab,
                       l_ii_tab,
                       l_iinode_tab,
                       l_iivalue_tab,
                       l_modify_flag_tab,
                       l_nr_of_rows,
                       lcs_function_name);
   IF  lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'SaveRqIiValue returned ' || lvi_ret_code || ' for ' || UNAPIEV.P_RQ || '.');
   END IF;

   lvi_ret_code := APAOFUNCTIONS.FillRelatedFields ('rq', UNAPIEV.P_RQ, l_ii_tab (1)) ;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != 1 THEN
         APAOGEN.LogError (lcs_function_name, SQLERRM);
      END IF;
      RETURN UNAPIGEN.DBERR_GENFAIL;

END RQ_A10;

--------------------------------------------------------------------------------
-- RQ_A11: Generates event for reevaluate PA's and WS's
--------------------------------------------------------------------------------
FUNCTION RQ_A11
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A11';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_pa_check IS
 SELECT pa.sc,
     pa.pg, pa.pgnode,
     pa.pa, pa.panode,
     pa.pr_version,
     pa.lc, pa.lc_version,
     pa.ss
   FROM utrqsc   rq
   , utscpa   pa
   WHERE rq.rq = UNAPIEV.P_RQ
  AND pa.sc = rq.sc
  AND pa.ss NOT IN ('@P', '@C');

CURSOR lvq_ws IS
SELECT DISTINCT ws.ws, lc, lc_version, ss
  FROM utrqsc rq
     , utwssc wssc
     , utws   ws
  WHERE rq.rq = UNAPIEV.P_RQ
    AND wssc.sc = rq.sc
    AND ws.ws = wssc.ws;

BEGIN
 FOR lvr_pa_check IN lvq_pa_check LOOP
 lvi_ret_code   := APAOFUNCTIONS.RecheckPa( lvr_pa_check.sc,
                                           lvr_pa_check.pg, lvr_pa_check.pgnode,
             lvr_pa_check.pa, lvr_pa_check.panode,
                                           lvr_pa_check.pr_version,
                                           lvr_pa_check.lc,
                                           lvr_pa_check.lc_version,
                                           lvr_pa_check.ss);
   END LOOP;

   FOR lvr_ws IN lvq_ws LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckWs( lvr_ws.ws,
                            lvr_ws.lc,
                            lvr_ws.lc_version,
                            lvr_ws.ss);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A11;


   --------------------------------------------------------------------------------
   -- SC_A01: Generates event for underlying objects to reevaluate status
   --------------------------------------------------------------------------------


FUNCTION SC_A01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_A01';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_me_check IS
    SELECT sc,
             pg, pgnode,
             pa, panode,
             me, menode,
             mt_version,
             lc, lc_version,
             ss
      FROM utscme
     WHERE sc = UNAPIEV.P_SC;

CURSOR lvq_pa_check IS
    SELECT sc,
             pg, pgnode,
             pa, panode,
             pr_version,
             lc, lc_version,
             ss
      FROM utscpa
     WHERE sc = UNAPIEV.P_SC
       AND (sc,pg,pgnode,pa,panode) NOT IN (SELECT sc, pg, pgnode, pa, panode
                                                           FROM utscme
                                                         WHERE sc = UNAPIEV.P_SC);

CURSOR lvq_pg_check IS
    SELECT sc,
             pg, pgnode,
             pp_version,
             lc, lc_version,
             ss
      FROM utscpg
     WHERE sc = UNAPIEV.P_SC
       AND (sc,pg,pgnode) NOT IN (SELECT sc, pg, pgnode
                                                           FROM utscpa
                                                         WHERE sc = UNAPIEV.P_SC);

BEGIN


    --------------------------------------------------------------------------------
    -- Recheck all parametergroups of current sample
    --------------------------------------------------------------------------------
   FOR lvr_pg_check IN lvq_pg_check LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckPg( lvr_pg_check.sc,
                                                          lvr_pg_check.pg, lvr_pg_check.pgnode,
                                                          lvr_pg_check.pp_version,
                                                                  lvr_pg_check.lc,
                                                       lvr_pg_check.lc_version,
                                                       lvr_pg_check.ss);
    END LOOP;
   --------------------------------------------------------------------------------
    -- Recheck all parameters of current sample
    --------------------------------------------------------------------------------
   FOR lvr_pa_check IN lvq_pa_check LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckPa( lvr_pa_check.sc,
                                                          lvr_pa_check.pg, lvr_pa_check.pgnode,
                                                          lvr_pa_check.pa, lvr_pa_check.panode,
                                                          lvr_pa_check.pr_version,
                                                                  lvr_pa_check.lc,
                                                       lvr_pa_check.lc_version,
                                                       lvr_pa_check.ss);
    END LOOP;
   --------------------------------------------------------------------------------
    -- Recheck all methods of current sample
    --------------------------------------------------------------------------------
   FOR lvr_me_check IN lvq_me_check LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckMe( lvr_me_check.sc,
                                                          lvr_me_check.pg, lvr_me_check.pgnode,
                                                          lvr_me_check.pa, lvr_me_check.panode,
                                                          lvr_me_check.me, lvr_me_check.menode,
                                                                  lvr_me_check.mt_version,
                                                                  lvr_me_check.lc,
                                                       lvr_me_check.lc_version,
                                                       lvr_me_check.ss);
    END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END SC_A01;

   --------------------------------------------------------------------------------
   -- SC_A02: Copies SC groupkeys -> ME groupkeys. DO NOT USE THIS CODE. THIS IS THE WRONG PLACE
   --------------------------------------------------------------------------------


FUNCTION SC_A02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_A02';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

   RETURN APAOEVRULES.INHERIT_SCGK(UNAPIEV.P_SC);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END SC_A02;

   --------------------------------------------------------------------------------
   -- SC_A03: Recheck ic of this sc
   --------------------------------------------------------------------------------
FUNCTION SC_A03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_A03';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_scic IS
SELECT sc, ic, icnode, ip_version, lc, lc_version, ss
  FROM utscic
 WHERE sc = UNAPIEV.P_SC;
BEGIN

   FOR lvr_scic IN lvq_scic LOOP
      --------------------------------------------------------------------------------
      -- Recheck all ic of this sc
      --------------------------------------------------------------------------------
      lvi_ret_code := APAOFUNCTIONS.RECHECKSCIC(UNAPIEV.P_SC,
                                                lvr_scic.ic, lvr_scic.icnode,
                                                lvr_scic.ip_version,
                                                lvr_scic.lc, lvr_scic.lc_version,
                                                lvr_scic.ss);
   END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END SC_A03;

FUNCTION SC_A04
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_A04';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvs_modify_reason  VARCHAR2(255);

BEGIN
  lvs_modify_reason := 'Could not assign methods as no correct sample attributes found';

  l_ret_code       := UNAPISCP.ADDSCCOMMENT(UNAPIEV.P_SC, lvs_modify_reason);
  IF (l_ret_code <> 0) THEN
        APAOGEN.LogError (lcs_function_name, 'UNACTION-SCA04 l_ret_code (2): ' || l_ret_code);
  END IF;
  RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END SC_A04;

FUNCTION SC_A05
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_A05';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvs_modify_reason  VARCHAR2(255);

CURSOR lvq_scpg IS
 SELECT pg, pgnode
   FROM utscpg
  WHERE sc = UNAPIEV.P_SC;

BEGIN
  lvs_modify_reason := 'Multiple destructive test procedures assigned to sample';
  l_ret_code       := UNAPISCP.ADDSCCOMMENT(UNAPIEV.P_SC, lvs_modify_reason);
  FOR lvr_scpg IN lvq_scpg LOOP
 l_ret_code     := UNAPIPGP.CANCELSCPG (UNAPIEV.P_SC, lvr_scpg.pg, lvr_scpg.pgnode, lvs_modify_reason);
  END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END SC_A05;

----------------------------------------------------------------------------------------
-- SC_A06: storing the availability date of a sample (date5 field). The related info-field should be filled and the related fields should be triggered.
----------------------------------------------------------------------------------------
FUNCTION SC_A06
RETURN APAOGEN.RETURN_TYPE IS

   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_A06';
   lvi_ret_code       APAOGEN.RETURN_TYPE;

   -- SaveScIiValue
   l_nr_of_rows     NUMBER := 1;
   l_sc_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_ic_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_icnode_tab      UNAPIGEN.LONG_TABLE_TYPE;
   l_ii_tab          UNAPIGEN.VC20_TABLE_TYPE;
   l_iinode_tab      UNAPIGEN.LONG_TABLE_TYPE;
   l_iivalue_tab     UNAPIGEN.VC2000_TABLE_TYPE;
   l_modify_flag_tab UNAPIGEN.NUM_TABLE_TYPE;

BEGIN

   -- Find the field that corresponds with date5.
   -- The MIN () functions are there in case there multiple infofields save to date5 (which is not a good idea but it still shouldn't lead to a SQL error).
   SELECT MIN (sc), MIN (ic), MIN (icnode), MIN (ii), MIN (iinode), MIN (TO_CHAR (SYSDATE, SUBSTR (NVL (format, 'DD/MON/YYYY HH24:MI:SS'), 2))), MIN (UNAPIGEN.MOD_FLAG_UPDATE)
   INTO l_sc_tab          (1),
        l_ic_tab          (1),
        l_icnode_tab      (1),
        l_ii_tab          (1),
        l_iinode_tab      (1),
        l_iivalue_tab     (1),
        l_modify_flag_tab (1)
   FROM utscii, utie
   WHERE ii         = ie
     AND ie_version = version
     AND sc         = UNAPIEV.P_SC
     AND def_val_tp = 'S'
     AND ievalue    = 'date5';

  IF l_sc_tab (1) IS NOT NULL THEN -- MIN () always returns 1 row, even when 0 rows found.

     -- Save the infofield; the event rule will take care of date5.
     lvi_ret_code := UNAPIIC.SaveScIiValue
                        (l_sc_tab,
                         l_ic_tab,
                         l_icnode_tab,
                         l_ii_tab,
                         l_iinode_tab,
                         l_iivalue_tab,
                         l_modify_flag_tab,
                         l_nr_of_rows,
                         lcs_function_name);
     IF  lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
        APAOGEN.LogError (lcs_function_name, 'SaveScIiValue returned ' || lvi_ret_code || ' for ' || UNAPIEV.P_SC || '.');
     END IF;

     lvi_ret_code := APAOFUNCTIONS.FillRelatedFields ('sc', UNAPIEV.P_SC, l_ii_tab (1)) ;

   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != 1 THEN
         APAOGEN.LogError (lcs_function_name, SQLERRM);
      END IF;
      RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_A06;

--------------------------------------------------------------------------------
-- SC_A07: Generates event for reevaluate WS
--------------------------------------------------------------------------------
FUNCTION SC_A07
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_A07';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

l_lc             VARCHAR2(2);
l_lc_version     VARCHAR2(20);

CURSOR lvq_ws IS
 SELECT ws.ws, ws.ss, ws.lc, ws.lc_version
   FROM utsc     sc
      , utwssc   wssc
      , utws     ws
 WHERE sc.sc  = UNAPIEV.P_SC
   AND wssc.sc = sc.sc
   AND wssc.ws = ws.ws;

BEGIN
    FOR lvr_ws IN lvq_ws LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckWs( lvr_ws.ws,
                            lvr_ws.lc,
                            lvr_ws.lc_version,
                            lvr_ws.ss);
  APAOGEN.LogError (lcs_function_name, 'Debug-JR, SC:' || UNAPIEV.P_SC || ', RecheckWS: ' || lvr_ws.ws || ', rtc: ' || lvi_ret_code);
    END LOOP;
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END SC_A07;

----------------------------------------------------------------------------------------
-- SC_A08: storing the SYSDATE of the moment a sample is changed to ORDERED. 
--         The related info-field should be filled and the related fields (TARGET-START-DATE, END-DATE(PI) should be triggered.
----------------------------------------------------------------------------------------
FUNCTION SC_A08
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'SC_A08';
lvi_ret_code       APAOGEN.RETURN_TYPE;
-- SaveScIiValue
l_nr_of_rows     NUMBER := 1;
l_sc_tab          UNAPIGEN.VC20_TABLE_TYPE;
l_ic_tab          UNAPIGEN.VC20_TABLE_TYPE;
l_icnode_tab      UNAPIGEN.LONG_TABLE_TYPE;
l_ii_tab          UNAPIGEN.VC20_TABLE_TYPE;
l_iinode_tab      UNAPIGEN.LONG_TABLE_TYPE;
l_iivalue_tab     UNAPIGEN.VC2000_TABLE_TYPE;
l_modify_flag_tab UNAPIGEN.NUM_TABLE_TYPE;
--
BEGIN
   -- Find the field that corresponds with date5.
   -- The MIN () functions are there in case there multiple infofields save to date5 (which is not a good idea but it still shouldn't lead to a SQL error).
   --Zodra SAMPLE wordt aangemaakt, wordt er ook een IC met bijbehorende InformationFields=II aangemaakt.
   --De waarde van avScTtPerfIndStart (=PI-START-DATE, FIFO) hoeft dan alleen nog maar geUPDATE te worden.
   SELECT MIN (II.sc)   sc_tab
   , MIN (II.ic)        ic_tab
   , MIN (II.icnode)    icnode_tab
   , MIN (II.ii)        ii_tab
   , MIN (II.iinode)    iinode_tab
   , MIN (TO_CHAR (SYSDATE, SUBSTR (NVL (IE.format, 'DD/MON/YYYY HH24:MI:SS'), 2)))  iivalue_tab
   , MIN (UNAPIGEN.MOD_FLAG_UPDATE)  modify_flag_tab
   INTO l_sc_tab(1)
   ,    l_ic_tab(1)
   ,     l_icnode_tab(1)
   ,     l_ii_tab(1)
   ,     l_iinode_tab(1)
   ,     l_iivalue_tab(1)
   ,     l_modify_flag_tab(1)
   FROM utscii II
   ,    utie   IE
   WHERE II.ii         = IE.ie
   AND   II.ie_version = IE.version
   AND   II.sc = UNAPIEV.P_SC
   AND   II.II = 'avScTtPerfIndStart'
   ;
  --
  IF l_sc_tab (1) IS NOT NULL THEN -- MIN () always returns 1 row, even when 0 rows found.
     -- Save the infofield; 
	 --Obv de key-attributen wordt er een UPDATE gedaan van de VALUE !!
	 --Hierna wordt UNAPIEV.INSERTINFOFIELDEVENT('SaveScIiValue') ingeschoten, Waarom?
	 --En wordt er nog een event UNAPIEV.INSERTEVENT('SaveScIiValue') aangemaakt, Waarom?
	 --
	 --A_SC               IN     UNAPIGEN.VC20_TABLE_TYPE,      
 	 --A_IC               IN     UNAPIGEN.VC20_TABLE_TYPE,      
 	 --A_ICNODE           IN OUT UNAPIGEN.LONG_TABLE_TYPE,      
 	 --A_II               IN     UNAPIGEN.VC20_TABLE_TYPE,      
 	 --A_IINODE           IN OUT UNAPIGEN.LONG_TABLE_TYPE,      
 	 --A_IIVALUE          IN     UNAPIGEN.VC2000_TABLE_TYPE,    
 	 --A_MODIFY_FLAG      IN OUT UNAPIGEN.NUM_TABLE_TYPE,       
 	 --A_NR_OF_ROWS       IN     NUMBER,                        
 	 --A_MODIFY_REASON    IN     VARCHAR2)
	 --
     lvi_ret_code := UNAPIIC.SaveScIiValue
                        (A_SC=>l_sc_tab
                        ,A_IC=>l_ic_tab
                        ,A_ICNODE=>l_icnode_tab
                        ,A_II=>l_ii_tab
                        ,A_IINODE=>l_iinode_tab
                        ,A_IIVALUE=>l_iivalue_tab
                        ,A_MODIFY_FLAG=>l_modify_flag_tab
                        ,A_NR_OF_ROWS=>l_nr_of_rows
                        ,A_MODIFY_REASON=>lcs_function_name
						);
     --
     IF  lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS 
	 THEN APAOGEN.LogError (lcs_function_name, 'SaveScIiValue returned ' || lvi_ret_code || ' for ' || UNAPIEV.P_SC || '.');
     END IF;
	 --
     --Vul de gerelateerde InformationFields !!
	 --Functie roept in geval van een 'sc' functie FillRelatedFieldsSc (a_object_key, a_ii) aan.
	 --
	 --SELECT related.sc, related.ic, related.icnode, related.ii, related.iinode, related.ie_version, related.iivalue
     -- FROM utscii changed
	 -- ,    utieau
	 -- ,    utscii related
	 -- ,    utie
     -- WHERE changed.sc         = avs_sc
     --   AND changed.ii         = avs_ii
     --   AND utieau.ie          = changed.ii
     --   AND utieau.version     = changed.ie_version
     --   AND utieau.au          = 'relatedfield'
     --   AND related.sc         = changed.sc
     --   AND related.ic         = changed.ic
     --   AND related.icnode     = changed.icnode
     --   AND related.ii         = utieau.value
     --   AND related.ii         = utie.ie
     --   AND related.ie_version = utie.version
     --   AND utie.look_up_ptr   = 'utiesql'
	 --
	 --functie-parameters, obv van SC + II van gewijzigde-II worden gerelateerde II gezocht.
	 --a_object_tp  IN VARCHAR2,
     --a_object_key IN APAOGEN.NAME_TYPE,
     --a_ii         IN APAOGEN.NAME_TYPE)
	 --
     lvi_ret_code := APAOFUNCTIONS.FillRelatedFields(a_object_tp=>'sc'
	                                                ,a_object_key=>UNAPIEV.P_SC
													,a_ii=>l_ii_tab(1)
													);
													
     --
   END IF;
   --
   RETURN UNAPIGEN.DBERR_SUCCESS;
   --
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != 1 THEN
         APAOGEN.LogError (lcs_function_name, SQLERRM);
      END IF;
      RETURN UNAPIGEN.DBERR_GENFAIL;

END SC_A08;

   --------------------------------------------------------------------------------
   -- PG_A01: Add number of parameter group as configured in STPPUA avCustCreatePgMult.
   --         HVB: Is code incorrect in case of PPKEYS? Missing in first lookup
   --------------------------------------------------------------------------------


FUNCTION PG_A01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_A01';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvn_pgnode             APAOGEN.NODE_TYPE;
lvi_count            NUMBER;
lvi_nbr_of_pp        NUMBER;

lvs_pp_key1         APAOGEN.NAME_TYPE;
lvs_pp_key2         APAOGEN.NAME_TYPE;
lvs_pp_key3         APAOGEN.NAME_TYPE;
lvs_pp_key4         APAOGEN.NAME_TYPE;
lvs_pp_key5         APAOGEN.NAME_TYPE;

BEGIN

    --------------------------------------------------------------------------------
    -- Retrieve number of parametergroups to be assigned to current sample
    --------------------------------------------------------------------------------
    SELECT NVL(MAX(b.value) - 1, 0)
      INTO lvi_nbr_of_pp
      FROM utsc a, utstppau b
     WHERE a.sc             = UNAPIEV.P_SC
         AND a.st             = b.st
       AND b.pp             = UNAPIEV.P_PG
       AND a.st             = b.st
       AND a.st_version     = b.version
       AND b.au             = ics_au_createpgmultiple;

    IF lvi_nbr_of_pp > 0 THEN
        --------------------------------------------------------------------------------
        -- This action should only be executed for the first parametergroup !!!
        --------------------------------------------------------------------------------
        SELECT COUNT(*)
          INTO lvi_count
          FROM utscpg
         WHERE sc = UNAPIEV.P_SC
           AND pg = UNAPIEV.P_PG;
        --------------------------------------------------------------------------------
        -- Assign parametergroup to current sample
        --------------------------------------------------------------------------------
        IF lvi_count = 1 THEN
            FOR lvi_row IN 1..lvi_nbr_of_pp LOOP
                --------------------------------------------------------------------------------
                -- Retrieve keys of current parametergroup
                --------------------------------------------------------------------------------
                SELECT pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
                  INTO lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5
                  FROM utscpg
                 WHERE sc = UNAPIEV.P_SC
                   AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE;

               lvi_ret_code := APAOFUNCTIONS.AssignParametergroup( UNAPIEV.P_SC,
                                                                                      UNAPIEV.P_PG, lvn_pgnode,
                                                                                     lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5,
                                                                                     'Created by lifecycleaction ' || lcs_function_name || '.');
            END LOOP;
        END IF;
    END IF;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN INVALID_NUMBER THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, 'The value of attribute <' || ics_au_createpgmultiple || '> should be numeric' );
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END PG_A01;

   --------------------------------------------------------------------------------
   -- PG_A02: Regular Release : Expiration.
   ---          When time is passed since last logon and is > STAU: acCustExpiration (months)
   ---          all parameters are assigned on current sample. No planned sample created
   --------------------------------------------------------------------------------


FUNCTION PG_A02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_A02';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

    lvi_ret_code := APAOREGULARRELEASE.EXPIRATION(UNAPIEV.P_SC, 'Assigned by ' || lcs_function_name || ' [sc = <' || UNAPIEV.P_SC || '> pg = <' || UNAPIEV.P_PG || '>].' );
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END PG_A02;

   --------------------------------------------------------------------------------
   -- PG_A03: Regular Release : TimeCountBased
   ---          Logs on a new sample in status @P according to configured frequencies
   ---          other than Time or count based on STPP
   --------------------------------------------------------------------------------
FUNCTION PG_A03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_A03';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

   -- RS20130313 - handle via job
   INSERT
     INTO ATAOREGULARRELEASE_PLANNED (sc, pg, pgnode)
   VALUES (UNAPIEV.P_SC, UNAPIEV.P_PG, UNAPIEV.P_PGNODE);

   --RS20130221 RETURN UNAPIGEN.DBERR_SUCCESS;

   -- RS20130313 - handle via job
   --lvi_ret_code := APAOREGULARRELEASE.TIMECOUNTBASED(UNAPIEV.P_SC, 'Assigned by ' || lcs_function_name || ' [sc = <' || UNAPIEV.P_SC || '> pg = <' || UNAPIEV.P_PG || '>].' );
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END PG_A03;

   --------------------------------------------------------------------------------
   -- PG_A04: CoA:
   --          Takes parameters out of other parameter profiles if PPPRAU: "CoA" = "Y"
   --          and overwrites description in case PPPRAU-description. The names for the UA's
   --          are configuratble in de ATOACONSTANT table.
   --          also spec limits are copied
   --------------------------------------------------------------------------------

FUNCTION PG_A04
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_A04';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_add_pa (avs_st IN VARCHAR2, avs_st_version IN VARCHAR2) IS
   SELECT c.pp original_pp, c.version original_pp_version, c.pp_key1 original_pp_key1,
               c.pp_key2 original_pp_key2, c.pp_key3 original_pp_key3,
               c.pp_key4 original_pp_key4, c.pp_key5 original_pp_key5,
               c.seq original_seq, e.pr, e.version pr_version, NVL(f.value,'Do Nothing') description
     FROM utstpp a, utpp b, utpppr c, utppprau d, utpr e, utppprau f
    WHERE a.st = avs_st
      AND a.version = avs_st_version
      AND a.pp <> UNAPIEV.P_PG
      AND a.pp = b.pp
      AND a.pp_key1 = avs_st
      AND b.version_is_current = '1'
      AND b.version = c.version
      AND a.pp = c.pp
      AND a.pp_key1 = c.pp_key1
      AND a.pp_key1 = b.pp_key1
      AND a.pp = d.pp
      AND a.pp_key1 = d.pp_key1
      AND b.version = d.version
      AND d.au = 'CoA'
      AND d.value = 'Y'
      AND c.pr_version = '~Current~'
      AND d.pr_version = '~Current~'
      AND c.pr = d.pr
      AND c.pr = e.pr
      AND e.version_is_current = '1'
      AND c.pp = f.pp (+)
      AND c.version = f.version (+)
      AND c.pr = f.pr (+)
      AND f.pr_version (+) = '~Current~'
      AND c.pp_key1 = f.pp_key1 (+)
      AND f.au(+) = ics_au_cust_description
    ORDER BY a.seq ASC, c.seq ASC;

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;

lvi_count           PLS_INTEGER;
lvs_st              APAOGEN.NAME_TYPE;
lvs_st_version      APAOGEN.VERSION_TYPE;
lvn_panode          APAOGEN.NODE_TYPE;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   -----------------------------------------------------------------------------
   -- Check if attribute is present if not leave function
   -----------------------------------------------------------------------------
   SELECT COUNT(*)
     INTO lvi_count
     FROM utppau
    WHERE pp = UNAPIEV.P_PG
      AND au = ics_au_cust_pp_type;

   IF lvi_count = 0 THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;

   -----------------------------------------------------------------------------
   -- Get the sampletype from active sample
   -----------------------------------------------------------------------------
   SELECT st, st_version
     INTO lvs_st, lvs_st_version
     FROM utsc
    WHERE sc = UNAPIEV.P_SC;

   FOR lvr_add_pa IN lvq_add_pa (avs_st=>lvs_st, avs_st_version=>lvs_st_version) LOOP
      --------------------------------------------------------------------------
      -- Make sure the panode is always empty
      --------------------------------------------------------------------------
      lvn_panode := NULL;

      lvi_ret_code := APAOFUNCTIONS.AssignParameter
                                (avs_sc           =>UNAPIEV.P_SC,
                                 avs_pg           =>UNAPIEV.P_PG, avn_pgnode=>UNAPIEV.P_PGNODE, avs_pp_version=>lvr_add_pa.original_pp_version,
                                 avs_pp_key1  =>lvr_add_pa.original_pp_key1,
                                 avs_pp_key2  =>lvr_add_pa.original_pp_key2,
                                 avs_pp_key3  =>lvr_add_pa.original_pp_key3,
                                 avs_pp_key4  =>lvr_add_pa.original_pp_key4,
                                 avs_pp_key5  =>lvr_add_pa.original_pp_key5,
                                 avs_pa           =>lvr_add_pa.pr, avn_panode=>lvn_panode, avs_pr_version=>lvr_add_pa.pr_version,
                                 avs_modify_reason=>'Created by lifecycleaction ' || lcs_function_name || '.',
                                 avb_with_details => FALSE);

      --------------------------------------------------------------------------
      -- Check if we have to update the description
      --------------------------------------------------------------------------
      IF lvr_add_pa.description <> 'Do Nothing' THEN
         UPDATE utscpa
            SET description = lvr_add_pa.description
          WHERE sc = UNAPIEV.P_SC
            AND pg = UNAPIEV.P_PG  AND pgnode = UNAPIEV.P_PGNODE
            AND pa = lvr_add_pa.pr AND panode = lvn_panode;
      END IF;

      --------------------------------------------------------------------------
      -- Add the specifications
      --------------------------------------------------------------------------
      INSERT
        INTO utscpaspa (sc, pg, pgnode, pa, panode,
                        low_limit, high_limit, low_spec, high_spec,
                        low_dev, rel_low_dev, target, high_dev, rel_high_dev)
      SELECT UNAPIEV.P_SC, UNAPIEV.P_PG, UNAPIEV.P_PGNODE, lvr_add_pa.pr, lvn_panode,
             low_limit, high_limit, low_spec, high_spec,
             low_dev, rel_low_dev, target, high_dev, rel_high_dev
        FROM utppspa
       WHERE pp      = lvr_add_pa.original_pp
         AND version = lvr_add_pa.original_pp_version
         AND pp_key1 = lvr_add_pa.original_pp_key1
         AND pr      = lvr_add_pa.pr
         AND seq     = lvr_add_pa.original_seq;

      INSERT
        INTO utscpaspb (sc, pg, pgnode, pa, panode,
                        low_limit, high_limit, low_spec, high_spec,
                        low_dev, rel_low_dev, target, high_dev, rel_high_dev)
      SELECT UNAPIEV.P_SC, UNAPIEV.P_PG, UNAPIEV.P_PGNODE, lvr_add_pa.pr, lvn_panode,
             low_limit, high_limit, low_spec, high_spec,
             low_dev, rel_low_dev, target, high_dev, rel_high_dev
        FROM utppspb
       WHERE pp      = lvr_add_pa.original_pp
         AND version = lvr_add_pa.original_pp_version
         AND pp_key1 = lvr_add_pa.original_pp_key1
         AND pr      = lvr_add_pa.pr
         AND seq     = lvr_add_pa.original_seq;

      INSERT
        INTO utscpaspc (sc, pg, pgnode, pa, panode,
                        low_limit, high_limit, low_spec, high_spec,
                        low_dev, rel_low_dev, target, high_dev, rel_high_dev)
      SELECT UNAPIEV.P_SC, UNAPIEV.P_PG, UNAPIEV.P_PGNODE, lvr_add_pa.pr, lvn_panode,
             low_limit, high_limit, low_spec, high_spec,
             low_dev, rel_low_dev, target, high_dev, rel_high_dev
        FROM utppspc
       WHERE pp      = lvr_add_pa.original_pp
         AND version = lvr_add_pa.original_pp_version
         AND pp_key1 = lvr_add_pa.original_pp_key1
         AND pr      = lvr_add_pa.pr
         AND seq     = lvr_add_pa.original_seq;
   END LOOP;

   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SUBSTR ('sc='||UNAPIEV.P_SC||', pg= '||UNAPIEV.P_PG||': '||SQLERRM, 1, 255));
   END IF;

   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;
END PG_A04;

--------------------------------------------------------------------------------
-- PG_A05: Updates SCGK: Context with value "Release"
--------------------------------------------------------------------------------

FUNCTION PG_A05
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_A05';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN

   lvi_ret_code := AssignGroupKey('scgk', 'Context', 'Release');
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := SUBSTR ('AssignGroupKey <Context> failed for ' ||
                        '<' || UNAPIEV.P_SC || '><' ||
                        '<' || UNAPIEV.P_PG || '><' || TO_CHAR (UNAPIEV.P_PGNODE) || '>' ||
                        '<' || UNAPIEV.P_PA || '><' || TO_CHAR (UNAPIEV.P_PANODE) || '>' ||
                        '<' || UNAPIEV.P_ME || '><' || TO_CHAR (UNAPIEV.P_MENODE) ||
                        '>. Errorcode: ' || lvi_ret_code, 1, 255);
      APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;

   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;
END PG_A05;

--------------------------------------------------------------------------------
-- PG_A06: When the PG change state to Completed, the avTestMethod and avTestMethodDesc attributes
-- of the PG must be copied to the underlying PA’s.
--------------------------------------------------------------------------------

FUNCTION PG_A06
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PG_A06';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_ppau IS
 SELECT t2.*
  FROM utscpg   t1
     , utppau   t2
  WHERE t1.sc = UNAPIEV.P_SC
    AND t1.pg = UNAPIEV.P_PG
    AND t1.pg = t2.pp
    AND t1.pp_version = t2.version
    AND t1.pp_key1 = t2.pp_key1
    AND t1.pp_key2 = t2.pp_key2
    AND t1.pp_key3 = t2.pp_key3
    AND t1.pp_key4 = t2.pp_key4
    AND t1.pp_key5 = t2.pp_key5
    AND t2.au IN ('avTestMethod', 'avTestMethodDesc');

CURSOR lvq_pa IS
 SELECT pa, panode
  FROM utscpa
  WHERE sc = UNAPIEV.P_SC
    AND pg = UNAPIEV.P_PG;
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
lvi_nr_of_rows     NUMBER;
lvs_modify_reason  VARCHAR2(255);
lts_value_tab      UNAPIGEN.VC40_TABLE_TYPE;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
 ----------------------------------------------------------------------------
 -- Itterate over the PP attributes avTestMethod and avTestMethodDesc
 ----------------------------------------------------------------------------
 FOR lvr_ppau IN lvq_ppau LOOP
  ------------------------------------------------------------------------
  -- Itterate over the PA's and add the attributes
  ------------------------------------------------------------------------
  FOR lvr_pa IN lvq_pa LOOP
   lvi_nr_of_rows    := 1;
   lts_value_tab(1)  := lvr_ppau.value;
   lvs_modify_reason := 'Attribute ' || lvr_ppau.au || ' copied from ' || lvr_ppau.pp || '.';
   ------------------------------------------------------------------------
   -- Save attribute
   ------------------------------------------------------------------------
   lvi_ret_code := UNAPIPAP.SAVE1SCPAATTRIBUTE(UNAPIEV.P_SC,
              UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
              lvr_pa.pa, lvr_pa.panode,
              lvr_ppau.au,
              lvr_ppau.au_version,
              lts_value_tab,
              lvi_nr_of_rows,
              lvs_modify_reason);

   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
     lvs_sqlerrm := SUBSTR ('SAVE1SCPAATTRIBUTE failed for ' ||
        '<' || UNAPIEV.P_SC || '><' ||
        '<' || UNAPIEV.P_PG || '><' || TO_CHAR (UNAPIEV.P_PGNODE) || '>' ||
        '<' || lvr_pa.pa || '><' || TO_CHAR (lvr_pa.panode) || '>' || ' Errorcode: ' || lvi_ret_code, 1, 255);
    APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
   END IF;
  END LOOP; -- end lvr_pa
 END LOOP; -- end lvr_ppau

    -----------------------------------------------------------------------------
    -- Always return success in an action
    -----------------------------------------------------------------------------
    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;

   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;
END PG_A06;

--------------------------------------------------------------------------------
-- PA_A01: Master-slave on specifications. Copies specifications from the "master"
--         parameter group to the "slave" parameter group. "master" and "slave" are
--         Identified by UA's on the parameter profile
--------------------------------------------------------------------------------

FUNCTION PA_A01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_A01';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvi_count            NUMBER;
lvs_statement        VARCHAR2(2000);

CURSOR lvq_masterA IS
SELECT d.low_limit || ''',''' || d.high_limit || ''',''' || d.low_spec || ''',''' || d.high_spec || ''',''' || d.low_dev || ''',''' || d.rel_low_dev || ''',''' || d.target || ''',''' || d.high_dev || ''',''' || d.rel_high_dev  || ''')' statement,
         'Specset A copied from pp <' || d.pp || ' [' || d.pp_key1 || '] >' commentaar
  FROM utsc a, utstpp b, utpp c, utppspa d, utppau e
 WHERE a.sc             = UNAPIEV.P_SC
   AND d.pr             = UNAPIEV.P_PA
   AND b.st             = a.st
   AND b.version         = a.st_version
   AND c.pp_key1         = a.st
   AND b.pp             = c.pp
   AND d.pp             = c.pp
   AND d.version         = c.version
   AND c.version_is_current = 1
   AND d.pp_key1 = c.pp_key1 AND d.pp_key2 = c.pp_key2 AND d.pp_key3 = c.pp_key3 AND d.pp_key4 = c.pp_key4 AND d.pp_key5 = c.pp_key5
   AND e.pp = c.pp AND e.version = c.version
   AND e.pp_key1 = c.pp_key1 AND e.pp_key2 = c.pp_key2 AND e.pp_key3 = c.pp_key3 AND e.pp_key4 = c.pp_key4 AND e.pp_key5 = c.pp_key5
   AND e.au = ics_au_specification
   AND e.value = ics_auvalue_master;

CURSOR lvq_masterB IS
SELECT d.low_limit || ''',''' || d.high_limit || ''',''' || d.low_spec || ''',''' || d.high_spec || ''',''' || d.low_dev || ''',''' || d.rel_low_dev || ''',''' || d.target || ''',''' || d.high_dev || ''',''' || d.rel_high_dev  || ''')' statement,
         'Specset B copied from pp <' || d.pp || ' [' || d.pp_key1 || '] >' commentaar
  FROM utsc a, utstpp b, utpp c, utppspb d, utppau e
 WHERE a.sc             = UNAPIEV.P_SC
   AND d.pr             = UNAPIEV.P_PA
   AND b.st             = a.st
   AND b.version         = a.st_version
   AND c.pp_key1         = a.st
   AND b.pp             = c.pp
   AND d.pp             = c.pp
   AND d.version         = c.version
   AND c.version_is_current = 1
   AND d.pp_key1 = c.pp_key1 AND d.pp_key2 = c.pp_key2 AND d.pp_key3 = c.pp_key3 AND d.pp_key4 = c.pp_key4 AND d.pp_key5 = c.pp_key5
   AND e.pp = c.pp AND e.version = c.version
   AND e.pp_key1 = c.pp_key1 AND e.pp_key2 = c.pp_key2 AND e.pp_key3 = c.pp_key3 AND e.pp_key4 = c.pp_key4 AND e.pp_key5 = c.pp_key5
   AND e.au = ics_au_specification
   AND e.value = ics_auvalue_master;

CURSOR lvq_masterC IS
SELECT d.low_limit || ''',''' || d.high_limit || ''',''' || d.low_spec || ''',''' || d.high_spec || ''',''' || d.low_dev || ''',''' || d.rel_low_dev || ''',''' || d.target || ''',''' || d.high_dev || ''',''' || d.rel_high_dev  || ''')' statement,
         'Specset C copied from pp <' || d.pp || ' [' || d.pp_key1 || '] >' commentaar
  FROM utsc a, utstpp b, utpp c, utppspc d, utppau e
 WHERE a.sc             = UNAPIEV.P_SC
   AND d.pr             = UNAPIEV.P_PA
   AND b.st             = a.st
   AND b.version         = a.st_version
   AND c.pp_key1         = a.st
   AND b.pp             = c.pp
   AND d.pp             = c.pp
   AND d.version         = c.version
   AND c.version_is_current = 1
   AND d.pp_key1 = c.pp_key1 AND d.pp_key2 = c.pp_key2 AND d.pp_key3 = c.pp_key3 AND d.pp_key4 = c.pp_key4 AND d.pp_key5 = c.pp_key5
   AND e.pp = c.pp AND e.version = c.version
   AND e.pp_key1 = c.pp_key1 AND e.pp_key2 = c.pp_key2 AND e.pp_key3 = c.pp_key3 AND e.pp_key4 = c.pp_key4 AND e.pp_key5 = c.pp_key5
   AND e.au = ics_au_specification
   AND e.value = ics_auvalue_master;

BEGIN
    --------------------------------------------------------------------------------
    -- Check if the parametergroup of current parameter has been defined as 'slave'
    --------------------------------------------------------------------------------
    SELECT count(*)
      INTO lvi_count
     FROM utppau a, utscpg b
    WHERE b.sc = UNAPIEV.P_SC
      AND b.pg = UNAPIEV.P_PG
      AND a.version = b.pp_version
      AND a.pp_key1 = b.pp_key1 AND a.pp_key2 = b.pp_key2 AND a.pp_key3 = b.pp_key3 AND a.pp_key4 = b.pp_key4 AND a.pp_key5 = b.pp_key5
      AND au = ics_au_specification
      and value = ics_auvalue_slave;
    --------------------------------------------------------------------------------
    -- Not defined as 'slave' --> return success
    --------------------------------------------------------------------------------
    IF lvi_count = 0 THEN
        RETURN UNAPIGEN.DBERR_SUCCESS;
    END IF;
    --------------------------------------------------------------------------------
    -- Copy master specset A to slave
    --------------------------------------------------------------------------------
    FOR lvr_master IN lvq_masterA LOOP
        --------------------------------------------------------------------------------
        -- Step 1: delete specs of slave
        --------------------------------------------------------------------------------
        DELETE
          FROM utscpaspa
         WHERE sc = UNAPIEV.P_SC
           AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
           AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;
        --------------------------------------------------------------------------------
        -- Step 2: built insert statement
        --------------------------------------------------------------------------------
        lvs_statement := 'INSERT INTO UTSCPASPA (SC, PG, PGNODE, PA, PANODE, LOW_LIMIT, HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV, REL_LOW_DEV, TARGET, HIGH_DEV, REL_HIGH_DEV) VALUES (''';
        lvs_statement := lvs_statement || UNAPIEV.P_SC || ''', ''' || UNAPIEV.P_PG || ''', ''' || UNAPIEV.P_PGNODE || ''', ''' || UNAPIEV.P_PA || ''', ''' || UNAPIEV.P_PANODE || ''',''';
        lvs_statement := lvs_statement || lvr_master.statement;
        --------------------------------------------------------------------------------
        -- Step 3: execute statement
        --------------------------------------------------------------------------------
        lvi_ret_code := APAOGEN.EXECUTESQL(lvs_statement);
        --------------------------------------------------------------------------------
        -- Step 4: add comment to the audittrail of the parameter
        --------------------------------------------------------------------------------
        IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
            lvi_ret_code := APAOFUNCTIONS.ADDSCPACOMMENT(UNAPIEV.P_SC,
                                                         UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                         UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                         lvr_master.commentaar);
        END IF;
    END LOOP;
    --------------------------------------------------------------------------------
    -- Copy master specset B to slave
    --------------------------------------------------------------------------------
    FOR lvr_master IN lvq_masterB LOOP
        --------------------------------------------------------------------------------
        -- Step 1: delete specs of slave
        --------------------------------------------------------------------------------
        DELETE
          FROM utscpaspb
         WHERE sc = UNAPIEV.P_SC
           AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
           AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;
        --------------------------------------------------------------------------------
        -- Step 2: built insert statement
        --------------------------------------------------------------------------------
        lvs_statement := 'INSERT INTO UTSCPASPB (SC, PG, PGNODE, PA, PANODE, LOW_LIMIT, HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV, REL_LOW_DEV, TARGET, HIGH_DEV, REL_HIGH_DEV) VALUES (''';
        lvs_statement := lvs_statement || UNAPIEV.P_SC || ''', ''' || UNAPIEV.P_PG || ''', ''' || UNAPIEV.P_PGNODE || ''', ''' || UNAPIEV.P_PA || ''', ''' || UNAPIEV.P_PANODE || ''',''';
        lvs_statement := lvs_statement || lvr_master.statement;
        --------------------------------------------------------------------------------
        -- Step 3: execute statement
        --------------------------------------------------------------------------------
        lvi_ret_code := APAOGEN.EXECUTESQL(lvs_statement);
        --------------------------------------------------------------------------------
        -- Step 4: add comment to the audittrail of the parameter
        --------------------------------------------------------------------------------
        IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
            lvi_ret_code := APAOFUNCTIONS.ADDSCPACOMMENT(UNAPIEV.P_SC,
                                                         UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                         UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                         lvr_master.commentaar);
        END IF;
    END LOOP;
    --------------------------------------------------------------------------------
    -- Copy master specset C to slave
    --------------------------------------------------------------------------------
    FOR lvr_master IN lvq_masterC LOOP
        --------------------------------------------------------------------------------
        -- Step 1: delete specs of slave
        --------------------------------------------------------------------------------
        DELETE
          FROM utscpaspc
         WHERE sc = UNAPIEV.P_SC
           AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
           AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;
        --------------------------------------------------------------------------------
        -- Step 2: built insert statement
        --------------------------------------------------------------------------------
        lvs_statement := 'INSERT INTO UTSCPASPC (SC, PG, PGNODE, PA, PANODE, LOW_LIMIT, HIGH_LIMIT, LOW_SPEC, HIGH_SPEC, LOW_DEV, REL_LOW_DEV, TARGET, HIGH_DEV, REL_HIGH_DEV) VALUES (''';
        lvs_statement := lvs_statement || UNAPIEV.P_SC || ''', ''' || UNAPIEV.P_PG || ''', ''' || UNAPIEV.P_PGNODE || ''', ''' || UNAPIEV.P_PA || ''', ''' || UNAPIEV.P_PANODE || ''',''';
        lvs_statement := lvs_statement || lvr_master.statement;
        --------------------------------------------------------------------------------
        -- Step 3: execute statement
        --------------------------------------------------------------------------------
        lvi_ret_code := APAOGEN.EXECUTESQL(lvs_statement);
        --------------------------------------------------------------------------------
        -- Step 4: add comment to the audittrail of the parameter
        --------------------------------------------------------------------------------
        IF lvi_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
            lvi_ret_code := APAOFUNCTIONS.ADDSCPACOMMENT(UNAPIEV.P_SC,
                                                         UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                         UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                         lvr_master.commentaar);
        END IF;
    END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END PA_A01;


--------------------------------------------------------------------------------
-- PA_A02: #P: Equal to this standard unilab functionality. Based on PPPR UA, the
--             number of assigned parameters can be adjusted.
--------------------------------------------------------------------------------

FUNCTION PA_A02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_A02';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvs_pp_version   APAOGEN.VERSION_TYPE;
lvs_pp_key1       APAOGEN.NAME_TYPE;
lvs_pp_key2       APAOGEN.NAME_TYPE;
lvs_pp_key3       APAOGEN.NAME_TYPE;
lvs_pp_key4       APAOGEN.NAME_TYPE;
lvs_pp_key5       APAOGEN.NAME_TYPE;
lvs_pr_version    APAOGEN.VERSION_TYPE;
lvn_panode        APAOGEN.NODE_TYPE;
lvi_count            NUMBER;
lvi_nbr_of_pr      NUMBER;
BEGIN

    --------------------------------------------------------------------------------
    -- Retrieve number of parameters to be assigned to current parametergroup
    --------------------------------------------------------------------------------
    SELECT NVL(MAX(b.value) - 1, 0)
      INTO lvi_nbr_of_pr
      FROM utscpg a, utppprau b
     WHERE a.sc                = UNAPIEV.P_SC
         AND a.pg             = UNAPIEV.P_PG
         AND a.pg             = b.pp
       AND b.pr             = UNAPIEV.P_PA
       AND a.pg             = b.pp
       AND a.pp_version     = b.version
       AND b.au             = ics_au_createpamultiple;

    IF lvi_nbr_of_pr > 0 THEN
        --------------------------------------------------------------------------------
        -- This action should only be executed for the first parameter !!!
        --------------------------------------------------------------------------------
        SELECT COUNT(*)
          INTO lvi_count
          FROM utscpa
         WHERE sc = UNAPIEV.P_SC
           AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
           AND pa = UNAPIEV.P_PA;
        --------------------------------------------------------------------------------
        -- Assign parameter to current parametergroup
        --------------------------------------------------------------------------------
        IF lvi_count = 1 THEN

            --------------------------------------------------------------------------------
            -- Retrieve version and keys of current parametergroup
            --------------------------------------------------------------------------------
            SELECT pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
              INTO lvs_pp_version, lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5
              FROM utscpg
             WHERE sc = UNAPIEV.P_SC
               AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE;

            --------------------------------------------------------------------------------
            -- Retrieve current version of parameter
            --------------------------------------------------------------------------------
            SELECT version
              INTO lvs_pr_version
              FROM utpr
             WHERE pr = UNAPIEV.P_PA AND version_is_current = '1';

            FOR lvi_row IN 1..lvi_nbr_of_pr LOOP
               lvi_ret_code := APAOFUNCTIONS.AssignParameter
                                        ( UNAPIEV.P_SC,
                                          UNAPIEV.P_PG, UNAPIEV.P_PGNODE, lvs_pp_version,
                                          lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5,
                                          UNAPIEV.P_PA, lvn_panode, lvs_pr_version,
                                          'Created by lifecycleaction ' || lcs_function_name || '.');
            END LOOP;
        END IF;
    END IF;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN INVALID_NUMBER THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, 'The value of attribute <' || ics_au_createpamultiple || '> should be numeric' );
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END PA_A02;

--------------------------------------------------------------------------------
-- PA_A03: Generates event "ParameterUpdated" for PA's filled from underlying MT's.
--------------------------------------------------------------------------------

FUNCTION PA_A03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_A03';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
--Specific local variables
--------------------------------------------------------------------------------
lvs_api_name                    VARCHAR2(40);
lvs_evmgr_name                  VARCHAR2(20);
lvs_object_tp                   VARCHAR2(4);
lvs_object_id                   VARCHAR2(20);
lvs_object_lc                   VARCHAR2(2);
lvs_object_lc_version           VARCHAR2(20);
lvs_object_ss                   VARCHAR2(2);
lvs_ev_tp                       VARCHAR2(60);
lvs_ev_details                  VARCHAR2(255);
lvi_seq_nr                      NUMBER;

CURSOR lvq_pa IS
SELECT c.sc, c.pg, c.pgnode, c.pa, c.panode, c.pr_version, c.lc, c.lc_version, c.ss
  FROM utscpa a, utscmecelloutput b, utscpa c
 WHERE a.sc = UNAPIEV.P_SC
   AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
   AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
   AND a.sc = b.sc
   AND b.save_pg = a.pg AND b.save_pgnode = a.pgnode
   AND b.save_pa = a.pa AND b.save_panode = a.panode
   AND b.sc = c.sc
   AND b.pg = c.pg AND b.pgnode = c.pgnode
   AND b.pa = c.pa AND b.panode = c.panode;

BEGIN

    FOR lvr_pa IN lvq_pa LOOP
       --------------------------------------------------------------------------------
       -- IN and IN OUT arguments
       --------------------------------------------------------------------------------
       lvs_api_name           := lcs_function_name;
       lvs_evmgr_name         := '';
       lvs_object_tp          := 'pa';
       lvs_ev_tp              := 'ParameterUpdated';
       lvs_object_id          := lvr_pa.pa;
       lvs_object_lc          := lvr_pa.lc;
       lvs_object_lc_version  := lvr_pa.lc_version;
       lvs_object_ss          := lvr_pa.ss;
       lvi_seq_nr             := NULL;
       lvs_ev_details         := 'sc=' || lvr_pa.sc ||
                                 '#pg=' || lvr_pa.pg || '#pgnode=' || lvr_pa.pgnode ||
                                 '#panode=' || lvr_pa.panode ||
                                 '#pr_version=' || lvr_pa.pr_version ||
                                 '#duplo';

       lvi_ret_code := UNAPIEV.INSERTEVENT (lvs_api_name,
                                            lvs_evmgr_name,
                                            lvs_object_tp,
                                            lvs_object_id,
                                            lvs_object_lc,
                                            lvs_object_lc_version,
                                            lvs_object_ss,
                                            lvs_ev_tp,
                                            lvs_ev_details,
                                            lvi_seq_nr);
    END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END PA_A03;


--------------------------------------------------------------------------------
-- PA_A04: Copies UA avTestMethod (with values) from currect Pa to all Pa's created from underlying MT's.
-- HVB01:  also copy UA avTestMethodDesc (with values) from currect Pa to all Pa's created from underlying MT's.
--------------------------------------------------------------------------------

FUNCTION PA_A04
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_A04';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvi_nr_of_rows     NUMBER;
lvs_modify_reason  VARCHAR2(255);
lts_value_tab      UNAPIGEN.VC40_TABLE_TYPE;

CURSOR lvq_paau IS
SELECT a.pa, c.au, c.value, c.au_version
  FROM utscpa a, utscmecelloutput b, utscpaau c
 WHERE a.sc = UNAPIEV.P_SC
   AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
   AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
   AND a.sc = b.sc
   AND b.save_pg = a.pg AND b.save_pgnode = a.pgnode
   AND b.save_pa = a.pa AND b.save_panode = a.panode
   AND b.sc = c.sc
   AND b.pg = c.pg AND b.pgnode = c.pgnode
   AND b.pa = c.pa AND b.panode = c.panode
   AND c.au IN ('avTestMethod', 'avTestMethodDesc')
UNION
 -- JR: I1506-161-geen UA-avTestMethod
SELECT a.pa, c.au, c.value, c.au_version
  FROM utscpa a, utscmecelllistoutput b, utscpaau c
 WHERE a.sc = UNAPIEV.P_SC
   AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
   AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
   AND a.sc = b.sc
   AND b.save_pg = a.pg AND b.save_pgnode = a.pgnode
   AND b.save_pa = a.pa AND b.save_panode = a.panode
   AND b.sc = c.sc
   AND b.pg = c.pg AND b.pgnode = c.pgnode
   AND b.pa = c.pa AND b.panode = c.panode
   AND c.au IN ('avTestMethod', 'avTestMethodDesc');

--HVB01   Replaced
--   AND c.au = 'avTestMethod';
--by
--   AND c.au IN ('avTestMethod', 'avTestMethodDesc');

-- 24/09/2015  | JR       | Changed PA_A04, get PA description from MEcelllistoutput, I1509-095
-- We 'are' now in the LC of a newly created PA and want to get a full/new PA description
-- this description is in a method cell list output which is in an other PA (higher level).
-- We can 'find' the higher/other PA through the save_ attributes in the utscmecelllistoutput table
-- We already know the ME, but we have to detmine the used version, than the last step
-- get the full description from the ME configuration, the description is stored in the 3rd column
-- of a mecelllistoutput, the 1st column is used for the PA creation name, the 3rd column contains the
-- desired PA description (index = 2)
  CURSOR lvq_mecelldesc IS
 SELECT a.pa, b.me, c.mt_version, sub.padesc
   FROM utscpa a
   , utscmecelllistoutput b
   , utscme c
   , (SELECT a.mt, a.version, a.value_s AS Pa , b.value_s AS PaDesc
     FROM utmtcelllist a, utmtcelllist b
    WHERE a.mt      = b.mt
      AND a.version = b.version
      AND a.cell    = b.cell
      AND a.index_y = b.index_y
      AND a.index_x = 0
      AND b.index_x = 2) sub
     WHERE a.sc = UNAPIEV.P_SC
    AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
    AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE
    AND a.sc = b.sc
    AND b.save_pg = a.pg AND b.save_pgnode = a.pgnode
    AND b.save_pa = a.pa AND b.save_panode = a.panode
    AND c.sc = b.sc
    AND c.pg = b.pg AND c.pgnode = b.pgnode
    AND c.pa = b.pa AND c.panode = b.panode
    AND sub.mt = b.me
    AND sub.version = mt_version
    AND sub.pa = a.pa;

BEGIN
    --------------------------------------------------------------------------------
    -- Get all pa-attributes which are linked to the current parameter via the original parameter
    --------------------------------------------------------------------------------
    FOR lvr_paau IN lvq_paau LOOP
        --------------------------------------------------------------------------------
        -- Fill arguments
        --------------------------------------------------------------------------------
        lvi_nr_of_rows    := 1;
        lts_value_tab(1)  := lvr_paau.value;
        lvs_modify_reason := 'Attribute ' || lvr_paau.au || ' copied from ' || lvr_paau.pa || '.';
        --------------------------------------------------------------------------------
        -- Save attribute
        --------------------------------------------------------------------------------
        lvi_ret_code := UNAPIPAP.SAVE1SCPAATTRIBUTE(UNAPIEV.P_SC,
                                                    UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                    UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                    lvr_paau.au,
                                                    lvr_paau.au_version,
                                                    lts_value_tab,
                                                    lvi_nr_of_rows,
                                                    lvs_modify_reason);
    END LOOP;

 FOR lvr_mecelldesc IN lvq_mecelldesc LOOP
  UPDATE utscpa a
     SET description =  lvr_mecelldesc.padesc
   WHERE a.sc = UNAPIEV.P_SC
     AND a.pg = UNAPIEV.P_PG AND a.pgnode = UNAPIEV.P_PGNODE
     AND a.pa = UNAPIEV.P_PA AND a.panode = UNAPIEV.P_PANODE;
 END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END PA_A04;

--------------------------------------------------------------------------------
-- PA_A05: Experimental action to remove GK 'mtProgress'. Not used Yet as system crashes.
--------------------------------------------------------------------------------

FUNCTION PA_A05
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_A05';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_me IS
SELECT sc,
       pg, pgnode,
       pa, panode,
       me, menode
  FROM utscmegk
 WHERE sc = UNAPIEV.P_SC
   AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
   AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
   AND gk = 'mtProgress';

BEGIN

   FOR lvr_me IN lvq_me LOOP
       DELETE
         FROM utscmegk
        WHERE sc = lvr_me.sc
          AND pg = lvr_me.PG AND pgnode = lvr_me.PGNODE
          AND pa = lvr_me.PA AND panode = lvr_me.PANODE
          AND gk = 'mtProgress';

       DELETE
         FROM utscmegkmtprogress
        WHERE sc = lvr_me.sc
          AND pg = lvr_me.PG AND pgnode = lvr_me.PGNODE
          AND pa = lvr_me.PA AND panode = lvr_me.PANODE;
       /*
       lvi_ret_code := APAOCONDITION.REMVALUEFROMMEGK(lvr_me.sc,
                                                      lvr_me.pg, lvr_me.pgnode,
                                                      lvr_me.pa, lvr_me.panode,
                                                      lvr_me.me, lvr_me.menode,
                                                      'mtProgress',
                                                      NULL);

       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
          APAOGEN.LogError (lcs_function_name, 'RemValueToMeGk failed for <' || lvr_me.sc || '#' || lvr_me.pg || '#' || lvr_me.pgnode  || '#' || lvr_me.pa || '#' || lvr_me.panode || '#' || lvr_me.me || '#' || lvr_me.menode || '". Returncode <' || lvi_ret_code || '> Function returned :' || lvi_ret_code || '.');
       END IF;
       */
   END LOOP;
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END PA_A05;

--------------------------------------------------------------------------------
-- PA_A08: Generates event for reevaluate WS
--------------------------------------------------------------------------------
FUNCTION PA_A08
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PA_A08';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

Cl_ws             VARCHAR2(20);
l_old_ss         VARCHAR2(2);
l_new_ss         VARCHAR2(2);
l_lc             VARCHAR2(2);
l_lc_version     VARCHAR2(20);

CURSOR lvq_ws IS
 SELECT ws.ws, ws.ss, ws.lc, ws.lc_version
   FROM UTSCPA   pa
      , utwssc   wssc
      , utws     ws
 WHERE pa.sc  = UNAPIEV.P_SC
   AND pa.pg  = UNAPIEV.P_PG
   AND pa.pgnode = UNAPIEV.P_PGNODE
   AND pa.pa  = UNAPIEV.P_PA
   AND pa.panode = UNAPIEV.P_PANODE
   AND wssc.sc = pa.sc
   AND wssc.ws = ws.ws;

BEGIN
    FOR lvr_ws IN lvq_ws LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckWs( lvr_ws.ws,
                            lvr_ws.lc,
                            lvr_ws.lc_version,
                            lvr_ws.ss);
  APAOGEN.LogError (lcs_function_name, 'Debug-JR, SC:' || UNAPIEV.P_SC || ', PA:' || UNAPIEV.P_PA || ', RecheckWS: ' || lvr_ws.ws || ', rtc: ' || lvi_ret_code);
    END LOOP;
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END PA_A08;
--------------------------------------------------------------------------------
-- ME_A01: Reevalute life cycle of the current method (raise methodUpdated)
--------------------------------------------------------------------------------

FUNCTION ME_A01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A01';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_me_check IS
    SELECT sc,
             pg, pgnode,
             pa, panode,
             me, menode,
             mt_version,
             lc, lc_version,
             ss
      FROM utscme
     WHERE sc = UNAPIEV.P_SC
       AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
       AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
       AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE;

BEGIN

    --------------------------------------------------------------------------------
    -- Recheck all methods of current method
    --------------------------------------------------------------------------------
   FOR lvr_me_check IN lvq_me_check LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckMe( lvr_me_check.sc,
                                                          lvr_me_check.pg, lvr_me_check.pgnode,
                                                          lvr_me_check.pa, lvr_me_check.panode,
                                                          lvr_me_check.me, lvr_me_check.menode,
                                                                  lvr_me_check.mt_version,
                                                                  lvr_me_check.lc,
                                                       lvr_me_check.lc_version,
                                                       lvr_me_check.ss);
    END LOOP;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A01;



--------------------------------------------------------------------------------
-- ME_A02: Copies MT-eq_tp naar ME "planned_eq"
-------------------------------------------------------------------------------

FUNCTION ME_A02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A02';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvs_eq                APAOGEN.NAME_TYPE;

BEGIN

    SELECT NVL(MAX(eq_tp),'-')
      INTO lvs_eq
      FROM utmt a, utscme b
     WHERE a.mt = b.me
       AND a.version = b.mt_version
       AND b.sc = UNAPIEV.P_SC
       AND b.pg = UNAPIEV.P_PG AND b.pgnode = UNAPIEV.P_PGNODE
       AND b.pa = UNAPIEV.P_PA AND b.panode = UNAPIEV.P_PANODE
       AND b.me = UNAPIEV.P_ME AND b.menode = UNAPIEV.P_MENODE;

    IF lvs_eq != '-' THEN
        UPDATE utscme
           SET planned_eq = lvs_eq
         WHERE sc = UNAPIEV.P_SC
           AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
           AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
           AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE;
    END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A02;


--------------------------------------------------------------------------------
-- ME_A03: Created a GK: ImportId with code mask "ImportId", when ua ImportID
-- or avCustCreateImportId is configured on MT
-------------------------------------------------------------------------------

FUNCTION ME_A03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A03';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvs_value            VARCHAR2(255);
lvi_count            NUMBER;

BEGIN

    SELECT COUNT(*)
      INTO lvi_count
      FROM utmtau
     WHERE mt = UNAPIEV.P_ME
       AND version = UNAPIEV.P_MT_VERSION
       AND au IN ('avImportId','avCustCreateImportId');

    IF lvi_count > 0 THEN
        lvs_value := GenerateNextCodemask('ImportId');
--        lvi_ret_code := AssignGroupKey('megk', 'ImportId', lvs_value);
        
        
        if substr(UNAPIEV.P_ME, 1, 3) = 'SX1'
        and UNAPIEV.P_REANALYSIS <> '0'
        then
            lvi_ret_code := AssignGroupKey('megk', 'ImportId', lvs_value||'R');
        else
            lvi_ret_code := AssignGroupKey('megk', 'ImportId', lvs_value);
        end if;
    END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A03;


--------------------------------------------------------------------------------
-- ME_A04: Copies SC groupkeys that are defined as ME-groupkey to the ME.
--         This does not work for SCGK's that are generated by an gk-assignment
--         for automatically created samples.
-------------------------------------------------------------------------------

FUNCTION ME_A04
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A04';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

   RETURN APAOEVRULES.INHERIT_SCGK(UNAPIEV.P_SC,
                                   UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                   UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                   UNAPIEV.P_ME, UNAPIEV.P_MENODE);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A04;



--------------------------------------------------------------------------------
-- ME_A05: Copies MTUA's and PRUA's to MTGK when these have identical names.
-------------------------------------------------------------------------------
FUNCTION ME_A05
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A05';
--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvs_value        VARCHAR2(255);
lvs_gk_version  VARCHAR2(20);
lts_value       UNAPIGEN.VC40_TABLE_TYPE;
lvi_nr_of_rows  NUMBER;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_gk IS
SELECT DISTINCT a.gk, a.version
  FROM utgkme a, utmtau b
 WHERE a.gk = b.au
   AND a.version_is_current = 1
   AND b.mt = UNAPIEV.P_ME AND b.VERSION = UNAPIEV.P_MT_VERSION
UNION
SELECT DISTINCT a.gk, a.version
  FROM utgkme a, utprau b, utpr c
 WHERE a.gk = b.au
   AND a.version_is_current = 1
   AND b.pr = c.pr
   AND b.pr = UNAPIEV.P_PA AND b.version = c.version
   AND c.version_is_current = 1;

CURSOR lvq_value(avs_au IN VARCHAR2) IS
SELECT b.value
  FROM utgkme a, utmtau b
 WHERE a.gk = b.au
   AND a.version_is_current = 1
   AND b.mt = UNAPIEV.P_ME AND b.VERSION = UNAPIEV.P_MT_VERSION
   AND b.au = avs_au
UNION
SELECT b.value
  FROM utgkme a, utprau b, utpr c
 WHERE a.gk = b.au
   AND a.version_is_current = 1
   AND b.pr = c.pr
   AND b.pr = UNAPIEV.P_PA AND b.version = c.version
   AND c.version_is_current = 1
   AND b.au = avs_au;

BEGIN
    APAOFUNCTIONS.LogInfo(lcs_function_name, 'Start of <' || lcs_function_name || '> for ' ||
                                             '#sc=' || UNAPIEV.P_SC ||
                                             '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
                                             '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
                                             '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE));
    --------------------------------------------------------------------------------
    -- Loop through all megk to be assigned
    --------------------------------------------------------------------------------
    FOR lvr_gk IN lvq_gk LOOP
        APAOFUNCTIONS.LogInfo(lcs_function_name, 'Checking for ' || lvr_gk.gk);

        lvi_nr_of_rows := 0;
        --------------------------------------------------------------------------------
        -- Loop through all values of the groupkey
        --------------------------------------------------------------------------------
        FOR lvr_value IN lvq_value(lvr_gk.gk) LOOP
            APAOFUNCTIONS.LogInfo(lcs_function_name, 'Found value <' || lvr_value.value || '> for ' || lvr_gk.gk);
            lvi_nr_of_rows := lvi_nr_of_rows + 1;
            lts_value(lvi_nr_of_rows) := lvr_value.value;
        END LOOP;

        APAOFUNCTIONS.LogInfo(lcs_function_name, 'Saving megk for ' ||
                                                 '#sc=' || UNAPIEV.P_SC ||
                                                 '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
                                                 '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
                                                 '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE));
        --------------------------------------------------------------------------------
        -- Finally save the groupkey with all values at once
        --------------------------------------------------------------------------------
        lvi_ret_code := UNAPIMEP.Save1ScMeGroupkey(UNAPIEV.P_SC,
                                                   UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                   UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                   UNAPIEV.P_ME, UNAPIEV.P_MENODE,
                                                   lvr_gk.gk, lvr_gk.version, lts_value,
                                                   lvi_nr_of_rows, 'Added by ' || lcs_function_name);
        --------------------------------------------------------------------------------
        -- In case of an error add a comment to the method
        --------------------------------------------------------------------------------
        IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
            lvi_ret_code := APAOFUNCTIONS.ADDSCMECOMMENT(UNAPIEV.P_SC,
                                                         UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                         UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                         UNAPIEV.P_ME, UNAPIEV.P_MENODE,
                                                         'Action ' || lcs_function_name || ' failed for gk <' || lvr_gk.gk || '>. Return code = ' || lvi_ret_code || '.');

        END IF;
    END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A05;

--------------------------------------------------------------------------------
-- ME_A06: Automically completes the method, without user interaction on a method
--
-------------------------------------------------------------------------------
FUNCTION ME_A06
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A06';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

lvi_count          NUMBER;
lvf_hours2wait     APAOGEN.VALUE_F_TYPE;
--------------------------------------------------------------------------------
--Specific local variables
--------------------------------------------------------------------------------
lvs_api_name                    VARCHAR2(40);
lvs_evmgr_name                  VARCHAR2(20);
lvs_object_tp                   VARCHAR2(4);
lvs_object_id                   VARCHAR2(20);
lvs_object_lc                   VARCHAR2(2);
lvs_object_lc_version           VARCHAR2(20);
lvs_object_ss                   VARCHAR2(2);
lvs_ev_tp                       VARCHAR2(60);
lvs_ev_details                  VARCHAR2(255);
lvi_seq_nr                      NUMBER;
lvd_execute_at                  TIMESTAMP WITH TIME ZONE;

BEGIN

   --------------------------------------------------------------------------------
   -- Check for cell hours2wait
   --------------------------------------------------------------------------------
   SELECT COUNT(*)
     INTO lvi_count
     FROM utmtcell
    WHERE mt = UNAPIEV.P_ME AND version = UNAPIEV.P_MT_VERSION
      AND cell = ics_mtcell_hours2wait;
   --------------------------------------------------------------------------------
   -- Cell hours2wait is not available
   --------------------------------------------------------------------------------
   IF lvi_count = 0 THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;
   --------------------------------------------------------------------------------
   -- Retrieve value_f of cell hours2wait (null = 0)
   --------------------------------------------------------------------------------
   SELECT NVL(MAX(value_f), 0)
     INTO lvf_hours2wait
     FROM utmtcell
    WHERE mt = UNAPIEV.P_ME AND version = UNAPIEV.P_MT_VERSION
      AND cell = ics_mtcell_hours2wait;

   SELECT me, lc, lc_version, ss
     INTO lvs_object_id, lvs_object_lc, lvs_object_lc_version, lvs_object_ss
     FROM utscme
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
      AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE;
    --------------------------------------------------------------------------------
    -- IN and IN OUT arguments
    --------------------------------------------------------------------------------
    lvs_api_name := lcs_function_name;
    lvs_evmgr_name := '';
    lvs_object_tp := 'me';
    lvs_ev_tp := 'MethodUpdated';
    lvi_seq_nr := NULL;
    lvs_ev_details := 'sc=' || UNAPIEV.P_SC ||
                      '#pg=' || UNAPIEV.P_PG || '#pgnode= ' || UNAPIEV.P_PGNODE ||
                      '#pa=' || UNAPIEV.P_PA || '#panode= ' || UNAPIEV.P_PANODE ||
                      '#menode= ' || UNAPIEV.P_MENODE ||
                      '#mt_version=' || UNAPIEV.P_MT_VERSION ||
                      '#hours2wait';
    --------------------------------------------------------------------------------
    -- Determine execution time
    --------------------------------------------------------------------------------
    lvd_execute_at := CURRENT_TIMESTAMP + lvf_hours2wait/24;
    --------------------------------------------------------------------------------
    -- if lvf_hours2wait = 0 insert an event
    --------------------------------------------------------------------------------
    IF lvf_hours2wait = 0 THEN
       --------------------------------------------------------------------------------
       -- Insert custom event
       --------------------------------------------------------------------------------
       lvi_ret_code := UNAPIEV.INSERTEVENT (lvs_api_name,
                                            lvs_evmgr_name,
                                            lvs_object_tp,
                                            lvs_object_id,
                                            lvs_object_lc,
                                            lvs_object_lc_version,
                                            lvs_object_ss,
                                            lvs_ev_tp,
                                            lvs_ev_details,
                                            lvi_seq_nr);

    --------------------------------------------------------------------------------
    -- if lvf_hours2wait > 0 insert a timed event
    --------------------------------------------------------------------------------
    ELSE
       --------------------------------------------------------------------------------
       -- Set timed event
       --------------------------------------------------------------------------------
       lvi_ret_code := UNAPIEV.INSERTTIMEDEVENT ( lvs_api_name,
                                                  lvs_evmgr_name,
                                                  lvs_object_tp,
                                                  lvs_object_id,
                                                  lvs_object_lc,
                                                  lvs_object_lc_version,
                                                  lvs_object_ss,
                                                  lvs_ev_tp,
                                                  lvs_ev_details,
                                                  lvi_seq_nr,
                                                  lvd_execute_at);
   END IF;
    --------------------------------------------------------------------------------
    -- Log execution time to method cell
    --------------------------------------------------------------------------------
    UPDATE utscmecell
       SET value_s = TO_CHAR(lvd_execute_at, 'DD/MM/YYYY HH24:MI:SS')
     WHERE sc = UNAPIEV.P_SC
       AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
       AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
       AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
       AND cell = ics_mtcell_timerCompleted;
    --------------------------------------------------------------------------------
    -- Log execution time to audittrail of method
    --------------------------------------------------------------------------------
    lvi_ret_code := APAOFUNCTIONS.ADDSCMECOMMENT(UNAPIEV.P_SC,
                                                 UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                 UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                 UNAPIEV.P_ME, UNAPIEV.P_MENODE,
                                                 'The auto-completion date of this method is ' || TO_CHAR(lvd_execute_at, 'DD/MM/YYYY HH24:MI:SS'));

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A06;

--------------------------------------------------------------------------------
-- ME_A07: Call APAOEVRULES.meCustomSQL
-------------------------------------------------------------------------------
FUNCTION ME_A07
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A07';

lvs_sqlerrm          APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code         APAOGEN.RETURN_TYPE;

BEGIN

   lvi_ret_code := APAOEVRULES.meCustomSQL;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;
END ME_A07;


--------------------------------------------------------------------------------
-- ME_A08: Completes an automated MT-sheet
-------------------------------------------------------------------------------
FUNCTION ME_A08
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A08';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

lvi_count          NUMBER;
lvf_hours2wait     APAOGEN.VALUE_F_TYPE;
--------------------------------------------------------------------------------
--Specific local variables
--------------------------------------------------------------------------------
lvs_api_name                    VARCHAR2(40);
lvs_evmgr_name                  VARCHAR2(20);
lvs_object_tp                   VARCHAR2(4);
lvs_object_id                   VARCHAR2(20);
lvs_object_lc                   VARCHAR2(2);
lvs_object_lc_version           VARCHAR2(20);
lvs_object_ss                   VARCHAR2(2);
lvs_ev_tp                       VARCHAR2(60);
lvs_ev_details                  VARCHAR2(255);
lvi_seq_nr                      NUMBER;
lvd_execute_at                  TIMESTAMP WITH TIME ZONE;

BEGIN
   --------------------------------------------------------------------------------
   -- Check for cell hours2wait
   --------------------------------------------------------------------------------
   SELECT COUNT(*)
     INTO lvi_count
     FROM utmtcell
    WHERE mt = UNAPIEV.P_ME AND version = UNAPIEV.P_MT_VERSION
      AND cell = ics_mtcell_hours2wait;
   --------------------------------------------------------------------------------
   -- Cell hours2wait is not available
   --------------------------------------------------------------------------------
   IF lvi_count = 0 THEN
      RETURN UNAPIGEN.DBERR_SUCCESS;
   END IF;
   --------------------------------------------------------------------------------
   -- Set method result = 'Completed' and fill exec_end_date
   --------------------------------------------------------------------------------
   UPDATE utscme
       SET exec_end_date = CURRENT_TIMESTAMP,
           value_s = 'Completed'
     WHERE sc = UNAPIEV.P_SC
       AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
       AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
       AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE;
    --------------------------------------------------------------------------------
    -- IN and IN OUT arguments
    --------------------------------------------------------------------------------
    lvs_api_name := lcs_function_name;
    lvs_evmgr_name := '';
    lvs_object_id  := UNAPIEV.P_ME;
    lvs_object_tp := 'me';
    lvs_ev_tp := 'EvaluateMeDetails';
    lvi_seq_nr := NULL;
    lvs_ev_details := 'sc=' || UNAPIEV.P_SC ||
                      '#pg=' || UNAPIEV.P_PG || '#pgnode= ' || UNAPIEV.P_PGNODE ||
                      '#pa=' || UNAPIEV.P_PA || '#panode= ' || UNAPIEV.P_PANODE ||
                      '#me=' || UNAPIEV.P_ME || '#menode= ' || UNAPIEV.P_MENODE ||
                      '#completed=1' ||
                      '#mt_version=' || UNAPIEV.P_MT_VERSION ||
                      '#hours2wait';

   --------------------------------------------------------------------------------
   -- Insert custom event Method updated
   --------------------------------------------------------------------------------
   lvi_ret_code := UNAPIEV.INSERTEVENT (lvs_api_name,
                                         lvs_evmgr_name,
                                         lvs_object_tp,
                                         lvs_object_id,
                                         lvs_object_lc,
                                         lvs_object_lc_version,
                                         lvs_object_ss,
                                         lvs_ev_tp,
                                         lvs_ev_details,
                                         lvi_seq_nr);

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A08;

--------------------------------------------------------------------------------
-- ME_A09: Fill value "Cancelled" as result and fill exec_end_date to be able to cancel a method
--         nr-of-results is chanced to force a recalculation.
--        HVB: This is probably not bullit proof, but will be OK for realistic situations
-------------------------------------------------------------------------------
FUNCTION ME_A09
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A09';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN
   --------------------------------------------------------------------------------
   -- Set method result = 'Cancelled' and fill exec_end_date
   --------------------------------------------------------------------------------
   UPDATE utscme
       SET exec_end_date = CURRENT_TIMESTAMP,
           value_s = 'Cancelled'
     WHERE sc = UNAPIEV.P_SC
       AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
       AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
       AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
       AND value_s IS NULL AND VALUE_F IS NULL;

   --------------------------------------------------------------------------------
   -- Decrease min number of results to force a recalculation of the parameter result
   --------------------------------------------------------------------------------
   UPDATE utscpa
      SET value_s = NULL,
          --value_f = NULL,  -- do not update the value_f, because of condition PA_C16
          exec_end_date =  CURRENT_TIMESTAMP, -- RS20110914
          min_nr_results = min_nr_results - 1
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A09;


--------------------------------------------------------------------------------
-- ME_A10: Recalculates the parameter result again is methods exist that have a value
--         Used for cancelling method.
-------------------------------------------------------------------------------
FUNCTION ME_A10
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A10';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvi_count1         NUMBER;
lvi_count2         NUMBER;
lvi_methods        NUMBER;
lvc_result         CHAR(1);

BEGIN
   --------------------------------------------------------------------------------
   -- Current method has a value_f (this means meant a part of pa-result)
   --------------------------------------------------------------------------------
   SELECT count(*)
     INTO lvi_count1
     FROM utscme
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
      AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE
      AND VALUE_F IS NOT NULL;
   --------------------------------------------------------------------------------
   -- Other methods of current parameter have a value_f (this means meant a part of pa-result)
   --------------------------------------------------------------------------------
   SELECT count(*)
     INTO lvi_count2
     FROM utscme
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
      AND me != UNAPIEV.P_ME AND menode != UNAPIEV.P_MENODE
      AND VALUE_F IS NOT NULL;
   --------------------------------------------------------------------------------
   -- Recalculate the parameterresult
   --------------------------------------------------------------------------------
   IF lvi_count1 > 0 AND lvi_count2 > 0 THEN
      /*
      SELECT COUNT(*)
        INTO lvi_methods
        FROM utscme
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
         AND ss != '@C';

      UPDATE utscpa
         SET min_nr_results = lvi_methods
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;
      */
      lvi_ret_code := UNAPIPAP.EVALPACALCULATION (UNAPIEV.P_SC,
                                                  UNAPIEV.P_PG,
                                                  UNAPIEV.P_PGNODE,
                                                  UNAPIEV.P_PA,
                                                  UNAPIEV.P_PANODE,
                                                  lvc_result);

       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
          APAOGEN.LogError (lcs_function_name, 'EvalPaCalculation (' || UNAPIEV.P_NR_RESULTS || ') returned :' || lvi_ret_code || '.');
       END IF;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A10;

--------------------------------------------------------------------------------
-- ME_A11: In development. Creates a GK mt-progress on all other methods under the parameter
-------------------------------------------------------------------------------
FUNCTION ME_A11
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A11';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_me IS
  SELECT sc,
         pg, pgnode,
         pa, panode,
         me, menode
    FROM utscme
   WHERE sc = UNAPIEV.P_SC
     AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
     AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
     AND ss IN ('AV', 'WA');

lvs_value        VARCHAR2(255);
lvs_gk_version  VARCHAR2(20);
lts_value       UNAPIGEN.VC40_TABLE_TYPE;
lvi_nr_of_rows  NUMBER;
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

BEGIN

   --------------------------------------------------------------------------------
   -- Loop through all methods in status available/wait
   --------------------------------------------------------------------------------
   FOR lvr_me IN lvq_me LOOP
       lvi_ret_code:= APAOFUNCTIONS.ADDVALUETOMEGK(lvr_me.sc,
                                                   lvr_me.pg, lvr_me.pgnode,
                                                   lvr_me.pa, lvr_me.panode,
                                                   lvr_me.me, lvr_me.menode,
                                                   'mtProgress',
                                                   SUBSTR(UNAPIEV.P_ME, 1, 5));
       IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
          APAOGEN.LogError (lcs_function_name, 'AddValueToMeGk failed for <' || lvr_me.sc || '#' || lvr_me.pg || '#' || lvr_me.pgnode  || '#' || lvr_me.pa || '#' || lvr_me.panode || '#' || lvr_me.me || '#' || lvr_me.menode || '". Returncode <' || lvi_ret_code || '> Function returned :' || lvi_ret_code || '.');
       END IF;
   END LOOP;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS;
END ME_A11;


--------------------------------------------------------------------------------
-- ME_A12 Increase min number of results to force a recalculation of the parameter result
--------------------------------------------------------------------------------
FUNCTION ME_A12
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A12';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN
   --------------------------------------------------------------------------------
   -- Increase min number of results to force a recalculation of the parameter result
   --------------------------------------------------------------------------------
   UPDATE utscpa
      SET value_s = NULL,
          value_f = NULL,
          exec_end_date =  NULL,
          min_nr_results = min_nr_results + 1
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A12;

FUNCTION ME_A15
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A15';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE := UNAPIGEN.DBERR_GENFAIL;

BEGIN
   --------------------------------------------------------------------------------
   -- Delete current methodcells
   --------------------------------------------------------------------------------
   lvi_ret_code := DeleteMeCells;
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'DeleteMeCells failed for <' || UNAPIEV.P_SC || '#' || UNAPIEV.P_PG || '#' || UNAPIEV.P_PGNODE  || '#' || UNAPIEV.P_PA || '#' || UNAPIEV.P_PANODE || '#' || UNAPIEV.P_ME || '#' || UNAPIEV.P_MENODE || '". Returncode <' || lvi_ret_code || '> Function returned :' || lvi_ret_code || '.');
   END IF;
   --------------------------------------------------------------------------------
   -- Create methodcells to trigger default values
   --------------------------------------------------------------------------------
   lvi_ret_code := CreateMeCells;
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'CreateMeCells failed for <' || UNAPIEV.P_SC || '#' || UNAPIEV.P_PG || '#' || UNAPIEV.P_PGNODE  || '#' || UNAPIEV.P_PA || '#' || UNAPIEV.P_PANODE || '#' || UNAPIEV.P_ME || '#' || UNAPIEV.P_MENODE || '". Returncode <' || lvi_ret_code || '> Function returned :' || lvi_ret_code || '.');
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A15;

FUNCTION ME_A16
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A16';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE := UNAPIGEN.DBERR_GENFAIL;
lvs_real_time        VARCHAR2(40);
lvs_real_cost        VARCHAR2(40);
l_nr_of_rows                NUMBER;
l_where_clause              VARCHAR2(511);
l_alarms_handled            CHAR(1);
l_modify_reason             VARCHAR2(255);


  l_sc_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_pg_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_pgnode_tab                UNAPIGEN.LONG_TABLE_TYPE;
  l_pa_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_panode_tab                UNAPIGEN.LONG_TABLE_TYPE;
  l_me_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_menode_tab                UNAPIGEN.LONG_TABLE_TYPE;
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
  l_allow_modify_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
  l_ar_tab                    UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_active_tab                UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_lc_tab                    UNAPIGEN.VC2_TABLE_TYPE;
  l_lc_version_tab            UNAPIGEN.VC20_TABLE_TYPE;
  l_ss_tab                    UNAPIGEN.VC2_TABLE_TYPE;
  l_reanalysedresult_tab      UNAPIGEN.CHAR1_TABLE_TYPE;
  l_modify_flag_tab           UNAPIGEN.NUM_TABLE_TYPE;

BEGIN

    -- I1504-067-Update-of-the-Real-time-field-of-a-method
    IF (unapiev.p_ev_rec.object_tp = 'me') THEN
        --IF (unapiev.p_ss_from = 'AV' AND unapiev.p_ev_rec.object_ss = 'CM') THEN
            lvs_real_time := NULL;
            lvs_real_cost := NULL;
            -- if AV -> CM, then real_time = est_time
            BEGIN
                SELECT est_time
                  INTO lvs_real_time
                  FROM utmt
                  WHERE mt = unapiev.p_me
                    AND est_time IS NOT NULL
                    AND version_is_current = '1';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

            BEGIN
                SELECT est_cost
                  INTO lvs_real_cost
                  FROM utmt
                  WHERE mt = unapiev.p_me
                    AND est_cost IS NOT NULL
                    AND version_is_current = '1';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

        --END IF;
    END IF;

    IF (lvs_real_time IS NOT NULL) THEN
      l_alarms_handled := '1';
      l_modify_reason  := lcs_function_name || ', calc real_time';
      l_nr_of_rows     := 1;
      l_where_clause   := 'WHERE sc = ''' || unapiev.p_sc                         || ''''||
                            ' AND pg = '''|| REPLACE (unapiev.p_pg, '''', '''''') || ''' AND pgnode = '|| unapiev.p_pgnode ||
                            ' AND pa = '''|| REPLACE (unapiev.p_pa, '''', '''''') || ''' AND panode = '|| unapiev.p_panode ||
                            ' AND me = '''|| REPLACE (unapiev.p_me, '''', '''''') || ''' AND menode = '|| unapiev.p_menode;
      l_nr_of_rows     := NULL;

      l_ret_code       := UNAPIME.GETSCMETHOD
                       (l_sc_tab,
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
                        l_allow_modify_tab,
                        l_ar_tab,
                        l_active_tab,
                        l_lc_tab,
                        l_lc_version_tab,
                        l_ss_tab,
                        l_reanalysedresult_tab,
                        l_nr_of_rows,
                        l_where_clause);
        IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
          lvs_sqlerrm := 'GETSCMETHOD failed. Returncode <' || l_ret_code || '>';
           APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
        ELSE
          FOR l_row IN 1..l_nr_of_rows LOOP
               --APAOGEN.LogError (lcs_function_name, 'sc: ' || l_sc_tab(l_row) || ', in loop');
             l_real_time_tab(l_row)     := lvs_real_time;
             l_real_cost_tab(l_row)     := lvs_real_cost;
             l_modify_flag_tab(l_row)     := UNAPIGEN.MOD_FLAG_UPDATE;
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

           IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
              lvs_sqlerrm := 'SAVESCMETHOD failed. Returncode <' || l_ret_code || '>';
                APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
           END IF;

        END IF;
    END IF;
    RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A16;

--------------------------------------------------------------------------------
FUNCTION ME_A17
RETURN APAOGEN.RETURN_TYPE IS

   --------------------------------------------------------------------------------
   -- This function sets utscme.lab to the proper value.
   -- In order of preference this value is:
   -- 1) the value of pp_key2 of parameter group.
   -- 2) the value of the ppau avSite of the parameter profile.
   -- 3) the value of the scgk site of sample.
   -- 4) decided by standard (based on method equipment)
   -- 5) - (because NULL can't be selected in the groupkey bar)
   -------------------------------------------------------------------------------

   lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A17';
   lvi_step                   INTEGER;
   lvi_ret_code               INTEGER;
   lvs_lab                    UTSCME.lab%TYPE;
   lvs_au_version             UTSCPGAU.au_version%TYPE;
   lvt_value_tab              UNAPIGEN.VC40_TABLE_TYPE;

BEGIN

   lvi_step := 1 ;
   SELECT REPLACE (pp_key2, ' ', NULL)
      INTO lvs_lab
      FROM utscpg
      WHERE sc     = UNAPIEV.P_SC
        AND pg     = UNAPIEV.P_PG
        AND pgnode = UNAPIEV.P_PGNODE;

   IF lvs_lab IS NULL THEN
      lvi_step := 2 ;
      BEGIN
         SELECT SUBSTR (value, 1, 20)
            INTO lvs_lab
            FROM utppau
            WHERE au = 'avSite'
              AND (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) =
                  (SELECT pg, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
                   FROM utscpg
                   WHERE sc     = UNAPIEV.P_SC
                     AND pg     = UNAPIEV.P_PG
                     AND pgnode = UNAPIEV.P_PGNODE);
      EXCEPTION WHEN NO_DATA_FOUND THEN
         lvi_step := 3 ;
      END;
   END IF;

   IF lvs_lab IS NULL THEN
      lvi_step := 4 ;
      BEGIN
         SELECT SUBSTR (site, 1, 20)
            INTO lvs_lab
            FROM utscgksite
            WHERE sc = UNAPIEV.P_SC;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         lvi_step := 5 ;
      END;
   END IF;

   IF lvs_lab IS NULL THEN
      lvi_step := 6 ;
      BEGIN
         SELECT lab
            INTO lvs_lab
            FROM utscme
            WHERE sc     = UNAPIEV.P_SC
              AND pg     = UNAPIEV.P_PG
              AND pgnode = UNAPIEV.P_PGNODE
              AND pa     = UNAPIEV.P_PA
              AND panode = UNAPIEV.P_PANODE
              AND me     = UNAPIEV.P_ME
              AND menode = UNAPIEV.P_MENODE;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         lvi_step := 7 ;
      END;
   END IF;

   lvi_step := 8 ;
   UPDATE utscme
      SET lab = NVL (lvs_lab, '-')
   WHERE sc = UNAPIEV.P_SC
     AND pg = UNAPIEV.P_PG AND pgnode = UNAPIEV.P_PGNODE
     AND pa = UNAPIEV.P_PA AND panode = UNAPIEV.P_PANODE
     AND me = UNAPIEV.P_ME AND menode = UNAPIEV.P_MENODE;

   -- The resulting lab is also set as an attribute at the scpg level,
   -- for overview and reporting purposes.
   lvi_step := 9 ;
   lvt_value_tab (1) := lvs_lab;
   lvi_ret_code := UNAPIPGP.Save1ScPgAttribute (UNAPIEV.P_SC,
                                                UNAPIEV.P_PG,
                                                UNAPIEV.P_PGNODE,
                                                'avSite',
                                                lvs_au_version,
                                                lvt_value_tab,
                                                1,
                                                lcs_function_name);
   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'Save1ScPgAttribute returned '||lvi_ret_code||' for sc '||UNAPIEV.P_SC||', pg '||UNAPIEV.P_PG||', avSite '||lvs_lab||'.');
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SUBSTR ('Exception in step '||lvi_step||': '||SQLERRM, 1, 255));
   END IF;
   RETURN UNAPIGEN.DBERR_SUCCESS; -- Return success so as not to block other actions.
END ME_A17;

FUNCTION ME_A18
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A18';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvs_value            VARCHAR2(255);
lvi_count            NUMBER;

BEGIN

    SELECT COUNT(*)
      INTO lvi_count
      FROM utmtau
     WHERE mt = UNAPIEV.P_ME
       AND version = UNAPIEV.P_MT_VERSION
       AND au IN ('avImportId','avCustCreateImportId');

    IF lvi_count > 0 THEN
        lvs_value := GenerateNextCodemask('ImportId');
        
--      APAOGEN.LogError (lcs_function_name, 'JBK - ME: '||UNAPIEV.P_ME);
--      APAOGEN.LogError (lcs_function_name, 'JBK - Val: '||lvs_value);
      
        if substr(UNAPIEV.P_ME, 1, 1) = 'S'
        then
            lvi_ret_code := AssignGroupKey('megk', 'ImportId', lvs_value||'R');
        else
            lvi_ret_code := AssignGroupKey('megk', 'ImportId', lvs_value);
        end if;
    END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A18;

FUNCTION ME_A19 
RETURN APAOGEN.RETURN_TYPE IS
--Functie om IMPORT-ERRORS voor FEA-SIMULATION-RESULTS te signaleren en deze
--naar betrokken medewerkers te mailen.
--FUNCTIE WORDT VANUIT LC AANGEROEPEN INDIEN LC=M1 DE STATUS VERANDERD NAAR ERROR !!!
--OP DIT MOMENT ZIJN ALLE ME-PK-ATTRIBUTEN IN UNAPIEV GEVULD...
--
--Dit wordt geconfigureerd vanuit de stuur-tabel ATAOFEAERRORMAIL.
--Er wordt alleen gechecked op errors op METHOD-LEVEL voor de methods SX000A/B/C en SX100A.
--Alleen bij een status-overgang naar een ERROR/ER-STATUS wordt er gecontroleerd of er een mail-rule bestaat.
--Vervolgens wordt gecontroleerd of deze matched met de ERROR in de UTSCMEHS.WHY tabel.
--Indien dit het geval wordt er mail verstuurd naar de muteerder (indien MAIL_REC_USER_ID = 1)
--en evt. naar extra administrators via de losse recipients-attributen.
--
--Let op: Zet SYSTEM-SETTING "LOG_INFO" in UTSYSTEM op waarde=1, daarmee krijgen we LOG-INFO in de UTERROR !!!
--
--unapiev_p_sc   varchar2(100) := 'MVE1910089T11' ;
--unapiev_p_pg   varchar2(100) := 'Simulations (misc.)' ;
--unapiev_p_pa   varchar2(100) := 'ST749AX' ;
--unapiev_p_me   varchar2(100) := 'SX000A' ;
--ics_package_name   varchar2(100) := 'test-peter-ME-A19' ;
--
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ME_A19';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;
lvs_value            VARCHAR2(255);
lvi_count            NUMBER;
--
l_who         utscmehs.who%type;
l_why         utscmehs.why%type;
--
l_created_by  varchar2(100);
--MAIL-SETTINGS
l_recipient_sc_user  VARCHAR2(2000 CHAR) ;
l_recipient_eq_user  VARCHAR2(2000 CHAR) ;
l_recipients      VARCHAR2(2000 CHAR) ;
l_subject         VARCHAR2(255 CHAR)  ;
l_buffer          unapigen.vc255_table_type;
l_index           NUMBER;
--
l_mail_tot_teller  number;
l_mail_ok_teller   number;
l_recipient_admin_user varchar2(2000 char);
l_recipient_test_user  varchar2(2000 char);
--
l_retval           NUMBER;
--
BEGIN
  --init:
  l_mail_tot_teller := 0;    --aantal rules waarvoor mail verzonden moet worden
  l_mail_ok_teller  := 0;    --aantal goedverzonden mail 
  --ME.SS=ER geworden !!!
  --avs_function_name  
  --avs_message 
  APAOFUNCTIONS.LogInfo(avs_function_name=>lcs_function_name
                       ,avs_message=> 'Mail AUDIT-ERROR for ' ||
                                      '#sc=' || UNAPIEV.P_SC ||
                                      '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
                                      '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
                                      '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE));
  --We gaan op zoek naar een de AUDIT-REGEL IN UTMEHS die vanuit een ME-STATUS-OVERGANG en halen de WHY op !!!
  --Dit kan willekeurige STATUS-OVERGANG zijn, MAAR aangezien deze ACTION alleen wordt aangeroepen
  --vanuit de LIFECYCLE-OVERGANG van IE/AV naar ER is de LAATSTE/MEEST RECENTE MESTATUSCHANGED degene met de ERROR-MESSAGE.
  FOR R_ME in (SELECT sc,pg,pgnode,pa,panode,me,menode,who,what,what_description,why,logdate
               FROM utscmehs  me
               WHERE me.sc     = UNAPIEV.P_SC
               and   me.pg     = UNAPIEV.P_PG
               and   me.pgnode = UNAPIEV.P_PGNODE
               and   me.pa     = UNAPIEV.P_PA
               and   me.panode = UNAPIEV.P_PANODE
               and   me.me     = UNAPIEV.P_ME
               and   me.menode = UNAPIEV.P_MENODE
               --and   me like me_fea.error_search_method 
               AND   me.WHAT like 'MeStatusChanged' 
               AND   me.logdate = (select max(me1.logdate)
                                   FROM utscmehs  me1
                                   WHERE me1.sc     = me.sc
                                   and   me1.pg     = me.pg
                                   and   me1.pgnode = me.pgnode
                                   and   me1.pa     = me.pa
                                   and   me1.panode = me.panode
                                   and   me1.me     = me.me
                                   and   me1.menode = me.menode
                                   AND   me1.WHAT like 'MeStatusChanged' 
                                  )
              )
              -- AND   WHAT_DESCRIPTION LIKE 'status%to "Error" [ER]%'
              --ORDER BY me.logdate desc
  LOOP
    --dbms_output.put_line('In loop r_me: ' ||r_me.sc||'-'||r_me.pg||'-'||r_me.pa||'-'||r_me.me||'-'||r_me.why||'-'||r_me.logdate);
    --dbms_output.put_line('r_me.what_description: ' ||r_me.what_description);
    --
    FOR R_FEA IN (select fea.ID
                  ,fea.ERROR_SEARCH_METHOD
                  ,fea.ERROR_SEARCH_WHAT_DESCRIPTION
                  ,fea.ERROR_MESSAGE
                  ,fea.MAIL_REC_SC_USER_IND   
                  ,fea.MAIL_REC_EQ_USER_IND
                  ,fea.MAIL_REC_ADDITIONAL_GROUP
                  ,fea.MAIL_REC_ADMIN_USER      
                  ,fea.MAIL_REC_TEST_USER       
                  ,fea.MAIL_SUBJECT             
                  ,fea.MAIL_ADDITIONAL_TXT
                  from ATAOFEAERRORMAIL  fea
                  where ACTIVE=1
				  AND   R_ME.me               LIKE  fea.ERROR_SEARCH_METHOD
				  AND   R_ME.what_description LIKE  NVL(fea.ERROR_SEARCH_WHAT_DESCRIPTION,'%')
				  AND   R_ME.why              LIKE  fea.ERROR_MESSAGE
				 )
    LOOP
      l_mail_tot_teller := l_mail_tot_teller + 1;
      --dbms_output.put_line('In loop FEA: '||'-'||r_FEA.id||'-'||r_fea.error_message);
	    --We halen alle CONFIG-regels op die aan criteria voldoen, handelen deze per stuk af.
      --Indien MUTEER-USER-IND = YES, dan zet user op verzendlijst  
      if r_fea.mail_rec_sc_user_ind = '1'
      then  
	      --haal email-adres van REQUEST-SAMPLE-OWNER op.
        --let op: doordat alleen partno van userid zelf geselecteerd kunnen worden bij aanmaken sample
        --wijzigt gebruiker vantevoren het userid van SAMPLE in een '%' OF in USERID van wie het PARTNO is.
        --Dit is niet de USER van REQUEST, dus nemen we ALTIJD de request-USERID om een mail naartoe te sturen.
        begin
          select distinct rq.created_by
          into l_created_by
          from utrq rq
          ,    utsc sc
          where sc.sc = r_me.sc
          and   sc.rq = rq.rq
          ;
          /*
          select distinct ad.email
          into l_recipient_sc_user
          from utad ad
          ,    utsc sc
          where sc.sc     = r_me.sc
          and   ad.ad     = sc.created_by
          and   ad.ad     <> '%' 
          and   ad.email  is not null
          and   rownum    = 1
          ;
          */
          if l_created_by is not null
          then
            select distinct ad.email
            into l_recipient_sc_user
            from utad ad
            where ad.ad     = l_created_by
            and   ad.ad     <> '%' 
            and   ad.email  is not null
            ;
          else
            l_recipient_sc_user := NULL;
          end if;
        exception
          when others
          then l_recipient_sc_user := NULL;
		    end;
      end if;
      --
      if r_fea.mail_rec_eq_user_ind = '1'
      then  
	      --haal email-adres van EQUIPEMENT-OWNER op.
        --De LISTAGG zet alleen ";" TUSSEN de opgehaalde waardes op. Dus niet op het eind, en als er maar 1 record wordt opgehaald dan ook geen ";".
        begin
          select LISTAGG(eqau.value,';' ) WITHIN GROUP (ORDER BY EQAU.VALUE) 
          into l_recipient_eq_user
          from uteqau   eqau
          ,    uteq     eq
          ,    uteqtype tp
          ,    utscme   me
          where me.sc         = r_me.sc
          and   me.pg         = r_me.pg
          and   me.pgnode     = r_me.pgnode
          and   me.pa         = r_me.pa
          and   me.panode     = r_me.panode
          and   me.me         = r_me.me
          and   me.menode     = r_me.menode
          and   tp.lab        = me.lab
          and   tp.eq_tp      = me.planned_eq
          --and   me.me         like 'SX%00A'
          and   eq.lab        = tp.lab
          and   eq.eq         = tp.eq
          and   eqau.eq       = eq.eq
          and   eqau.lab      = eq.lab
          and   eqau.au       = 'avCustEmail'
          and   eqau.value is not null
          ;
        exception
          when others
          then l_recipient_eq_user := NULL;
		    end;
      end if;

	    SELECT l_recipient_sc_user ||DECODE(l_recipient_eq_user,null, '', ';'||l_recipient_eq_user)
                                 ||DECODE(r_fea.MAIL_REC_ADDITIONAL_GROUP,null, '', ';'||r_fea.MAIL_REC_ADDITIONAL_GROUP)
	                               ||DECODE(r_fea.MAIL_REC_ADMIN_USER, null, '', ';'||r_fea.MAIL_REC_ADMIN_USER)
                                 ||DECODE(r_fea.MAIL_REC_TEST_USER, null, '', ';'||r_fea.MAIL_REC_TEST_USER) 
      INTO L_RECIPIENTS 
      FROM DUAL;
      --
      if substr(l_recipients,1,1) = ';'
      then  l_recipients := substr(l_recipients,2);
      end if;                                
      --else
 	    --neem evt. de overige recipients op in verzendlijst:
	    --if r_fea.MAIL_REC_ADDITIONAL_GROUP is not null
	    --then
      --	  SELECT  DECODE(r_fea.MAIL_REC_ADDITIONAL_GROUP,null, '', r_fea.MAIL_REC_ADDITIONAL_GROUP)
      --                      ||DECODE(r_fea.MAIL_REC_ADMIN_USER, null, '', ','||r_fea.MAIL_REC_ADMIN_USER)
      --	              ||DECODE(r_fea.MAIL_REC_TEST_USER, null, '', ','||r_fea.MAIL_REC_TEST_USER) INTO l_recipients  FROM DUAL;
      --elsif r_fea.MAIL_REC_ADMIN_USER is not null
      --then
      --		  SELECT  DECODE(r_fea.MAIL_REC_ADMIN_USER, null, '', r_fea.MAIL_REC_ADMIN_USER)
      --	              ||DECODE(r_fea.MAIL_REC_TEST_USER, null, '', ','||r_fea.MAIL_REC_TEST_USER) INTO l_recipients  FROM DUAL;
      --    else
      --	  SELECT  DECODE(r_fea.MAIL_REC_TEST_USER, null, '', r_fea.MAIL_REC_TEST_USER) INTO l_recipients  FROM DUAL;  
      --end if ;
      --  end if;
      --Vul evt. subject aan:
      if r_fea.MAIL_SUBJECT is not null
      then l_subject := r_fea.MAIL_SUBJECT;
           l_subject := l_subject||': '||r_me.sc||'-'||r_me.pg||'-'||r_me.pa||'-'||r_me.me;
      else
           l_subject := r_me.sc||'-'||r_me.pg||'-'||r_me.pa||'-'||r_me.me;
      end if;
      --
      --VUL eerste regel van email: chr(13=CarriageRetrun.
      l_index := 1; 
      l_buffer(l_index) := r_me.why||chr(13);
	    --VUL tweede regel van email:
      l_index := 2; 
      l_buffer(l_index) := chr(13)||r_fea.MAIL_ADDITIONAL_TXT;
	    --
	    --dbms_output.put_line('RECIPIENTS: '||l_recipients);
	    --dbms_output.put_line('SUBJECT: '||l_subject);
	    --dbms_output.put_line('BUFFER: '||l_buffer(1));
	    --dbms_output.put_line('BUFFER: '||l_buffer(2));
      --send email  
      lvi_ret_code := unapiGen.SendMail(a_recipient  => l_recipients
                                       ,a_subject    => l_subject
                                       ,a_text_tab   => l_buffer
                                       ,a_nr_of_rows => l_index  );
      --
      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         APAOFUNCTIONS.LogInfo(avs_function_name=>lcs_function_name
                              ,avs_message=> 'FEA-SendMail faild to inform error SC <'||UNAPIEV.P_SC||'['||UNAPIEV.P_ME||']>  to recipients <'||l_recipients||'>. Error: '||lvi_ret_code 
                              );
      ELSE
        l_mail_ok_teller := l_mail_ok_teller + 1;
        APAOFUNCTIONS.LogInfo(avs_function_name=>lcs_function_name
                             ,avs_message=> 'Mail FEA-AUDIT-ERROR SEND SUCCESSFULL TO: ' ||l_recipients);
      END IF;
      --DBMS_OUTPUT.PUT_LINE('RESULT NA MAIL: '||l_retval);
      --
    END LOOP; --r_fea-RULES
    --
    --Indien er geen RULE is afgegaan, en er dus een ERROR is opgetreden waarvoor geen FEA-RULE is aangemaakt 
    --gaan we als laatste VANGNET alsnog een mail sturen naar de DISTINCT ADMIN/TEST-ACCOUNT uit FEA-CONFIG-TABEL.
    if  nvl(l_mail_tot_teller,0) = 0
    or  (   nvl(l_mail_tot_teller,0) > 0
        and nvl(l_mail_ok_teller,0) = 0 )
    then
      --we sturen nu algemene mail naar alle ADMIN/TEST-USERS...
      begin
        begin
          select LISTAGG(feaa.MAIL_REC_ADMIN_USER,';' ) WITHIN GROUP (ORDER BY feaa.MAIL_REC_ADMIN_USER)  col1
          into l_recipient_admin_user
          from  (select distinct fea.mail_rec_admin_user from ATAOFEAERRORMAIL  fea where ACTIVE = 1)  feaa
          ;
        exception
          when others
          then l_recipient_admin_user := 'mihar.ved@Apollotyres.com';
		    end;
        begin
          select LISTAGG(feaa.MAIL_REC_ADMIN_USER,';' ) WITHIN GROUP (ORDER BY feaa.MAIL_REC_ADMIN_USER)  col1
          into l_recipient_test_user
          from  (select distinct fea.mail_rec_admin_user from ATAOFEAERRORMAIL  fea where ACTIVE = 1)  feaa
          ;
        exception
          when others
          then l_recipient_test_user := 'peter.schepens@apollotyres.com';
		    end;
        l_recipients := l_recipient_admin_user;
        if l_recipient_test_user is not null
        then l_recipients := l_recipients ||';'||l_recipient_test_user;
        end if;
        if substr(l_recipients,1,1) = ';'
        then  l_recipients := substr(l_recipients,2);
        end if;   
        --Indien bij geen enkele active=1-rule een admin-email-account is ingevuld dan mail naar mihar !!!
        if l_recipients is null
        then l_recipients := 'mihar.ved@Apollotyres.com';
        end if;
        --      
      exception
        when others
        then l_recipients := 'mihar.ved@Apollotyres.com';
      end;
      --VUL eerste regel van email: chr(13=CarriageRetrun.
      l_index := 1; 
      l_buffer(l_index) := r_me.why||chr(13);
      l_subject := 'FEA-ALG-EXCP: GEEN FEA-CONFIG-RULE gevonden voor: '||r_me.sc||'-'||r_me.pg||'-'||r_me.pa||'-'||r_me.me;
	    --
	    --dbms_output.put_line('RECIPIENTS: '||l_recipients);
	    --dbms_output.put_line('SUBJECT: '||l_subject);
	    --dbms_output.put_line('BUFFER: '||l_buffer(1));
	    --dbms_output.put_line('BUFFER: '||l_buffer(2));
      --send email  
      lvi_ret_code := unapiGen.SendMail(a_recipient  => l_recipients
                                       ,a_subject    => l_subject
                                       ,a_text_tab   => l_buffer
                                       ,a_nr_of_rows => l_index  );
      --
      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         APAOFUNCTIONS.LogInfo(avs_function_name=>lcs_function_name
                              ,avs_message=> 'SendMail faild to inform error SC <'||UNAPIEV.P_SC||'['||UNAPIEV.P_ME||']>  to recipients <'||l_recipients||'>. Error: '||lvi_ret_code 
                              );
      ELSE
        l_mail_ok_teller := l_mail_ok_teller + 1;
        APAOFUNCTIONS.LogInfo(avs_function_name=>lcs_function_name
                             ,avs_message=> 'Mail NOT-FEA-RULE-DEFINED for AUDIT-ERROR SEND TO: SC <'||UNAPIEV.P_SC||'['||UNAPIEV.P_ME||']>  to recipients <'||l_recipients||'>');
      END IF;
      --
    end if;  --if geen fea-rule gevonden voor de foutmelding...
    --
  END LOOP; --r_me-STATUSCHANGE
  --
  --dbms_output.put_line('return-value: '||l_retval);		
  --
  RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END ME_A19;



--------------------------------------------------------------------------------
-- ReanalysePa. Forces reanalysis of parameter. NOT USED ANYMORE
--------------------------------------------------------------------------------
FUNCTION ReanalysePa
RETURN APAOGEN.RETURN_TYPE IS

   lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := 'ReanalysePa';
   lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
   lvi_ret_code            APAOGEN.RETURN_TYPE ;
   lvn_reanalysis          NUMBER;
   lvs_modify_reason       APAOGEN.MODIFY_REASON_TYPE;

BEGIN

   lvs_modify_reason := 'Reanalysis of the method';

    lvi_ret_code := UNAPIAUT.DisableAllowModifyCheck('1');

    lvi_ret_code := UNAPIPA2.ReanalScParameter    (UNAPIEV.P_SC,
                                                  UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                  UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                  lvn_reanalysis,
                                                  lvs_modify_reason);

    lvi_ret_code := UNAPIAUT.DisableAllowModifyCheck('0');

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE <> 1 THEN
         lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
          --APAOGEN.LogError (lcs_function_name, SQLERRM);
      END IF;
      RETURN UNAPIGEN.DBERR_SUCCESS ;

END ReanalysePa;

FUNCTION ST_A01
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_A01';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
lvs_st            APAOGEN.ST_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

   --------------------------------------------------------------------------------
   -- Get current st and version
   --------------------------------------------------------------------------------
   lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
   lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
   --------------------------------------------------------------------------------
   -- Synchronize with previous minor (UNDIFF)
   --------------------------------------------------------------------------------
   lvi_ret_code := SynchronizeAll;
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'SynchronozeAll failed for <' || lvs_st || '[' || lvs_version || ']');
   END IF;
   --------------------------------------------------------------------------------
   -- Get next minor version, in fact created by UNDIFF
   --------------------------------------------------------------------------------
   lvi_ret_code := UNVERSION.GetNextMinorVersion(lvs_version);
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'GetNextMinorVersion failed for <' || lvs_st || '[' || lvs_version || ']');
   END IF;
   --------------------------------------------------------------------------------
   -- Synchronize freqs on minor with template
   --------------------------------------------------------------------------------
   lvi_ret_Code := APAOACTION.SYNCSTPPFREQNOTMANUAL(lvs_st, lvs_version);
   IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
      APAOGEN.LogError (lcs_function_name, 'SyncSTPPFreqNotManual failed for <' || lvs_st || '[' || lvs_version || ']');
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END ST_A01;

FUNCTION ST_A02
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_A02';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
lvs_st            APAOGEN.ST_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

   lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
   lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

   lvi_ret_code := APAOACTION.STAPPLYTEMPLATE(lvs_st, lvs_version);
   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END ST_A02;

FUNCTION ST_A03
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_A03';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
lvs_st       APAOGEN.ST_TYPE;
lvs_version  APAOGEN.VERSION_TYPE;

BEGIN

   lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
   lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

   lvi_ret_code := APAOACTION.STPPAPPLYINTERSPECFREQ(lvs_st, lvs_version);

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END ST_A03;

FUNCTION ST_A04
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_A04';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
lvs_st         APAOGEN.ST_TYPE;
lvs_version    APAOGEN.VERSION_TYPE;

BEGIN


   lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
   lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

   lvi_ret_code := APAOACTION.STPPSYNCLASTCOUNT(lvs_st, lvs_version);
   lvi_ret_code := APAOACTION.STSYNCLASTCOUNT(lvs_st, lvs_version);

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END ST_A04;


FUNCTION ST_A08
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_A08';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
lvs_st         APAOGEN.ST_TYPE;
lvs_version    APAOGEN.VERSION_TYPE;

BEGIN

   lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
   lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

   lvi_ret_code := APAOACTION.STPUTALLPPTOAPPROVED(lvs_st, lvs_version);

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END ST_A08;


FUNCTION ST_A09
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_A09';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm    APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code   APAOGEN.RETURN_TYPE;
lvs_st         APAOGEN.ST_TYPE;
lvs_version    APAOGEN.VERSION_TYPE;

BEGIN

   lvs_st         := UNAPIEV.P_EV_REC.OBJECT_ID;
   lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END ST_A09;

--------------------------------------------------------------------------------
-- FUNCTION : ST_A10
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Rody Sparenberg
-- REVIEWER :
--     DATE : 26/09/2008
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
-- 26/09/2008 | RS        | Created
-- 29/03/2016 | AF        | Implemented the function to send an e-mail
--------------------------------------------------------------------------------
FUNCTION ST_A10
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ST_A10';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm    APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code   APAOGEN.RETURN_TYPE;

lvs_st         APAOGEN.ST_TYPE;
lvs_version    APAOGEN.VERSION_TYPE;
lvs_email      VARCHAR2(255) := NULL;
lvs_ss_name    UNILAB.UTSS.NAME%TYPE;
lvs_subject    VARCHAR2(255);
lts_text_tab   UNAPIGEN.VC255_TABLE_TYPE;
lvn_nr_of_rows NUMBER;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN
   -----------------------------------------------------------------------------
   -- Determine the sample type and version
   -----------------------------------------------------------------------------
   lvs_st      := UNAPIEV.P_EV_REC.OBJECT_ID;
   lvs_version := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

   -----------------------------------------------------------------------------
   -- Get the e-mail adresses to send the email to
   -----------------------------------------------------------------------------
   lvs_email := APAOACTION.GetEmailReceipients;

   -----------------------------------------------------------------------------
   -- Only continue when an e-mail adres is found
   -----------------------------------------------------------------------------
   IF lvs_email IS NOT NULL THEN
      --------------------------------------------------------------------------
      -- Try to get the name of the status to which the object is moved
      --------------------------------------------------------------------------
      BEGIN
         SELECT NVL(MAX(name), 'NAME_NOT_FOUND')
           INTO lvs_ss_name
           FROM UNILAB.utss
          WHERE ss = unapiev.p_ev_rec.object_ss;
      EXCEPTION
         WHEN OTHERS THEN
            lvs_ss_name := '';
      END;

      lvs_subject := 'ST <'||lvs_st||'['||lvs_version||']> changed to status <Error(ER)>';

      lts_text_tab(1) := 'Sample type <'||lvs_st||'['||lvs_version||']> changed to status <Error> with an unknown reason.';
      lts_text_tab(2) := 'Manual intervention is needed!';
      lvn_nr_of_rows  := 2;

      lvi_ret_code := UNAPIGEN.SendMail(a_recipient  => lvs_email,
                                        a_subject    => lvs_subject,
                                        a_text_tab   => lts_text_tab,
                                        a_nr_of_rows => lvn_nr_of_rows);

      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         APAOGEN.LogError (lcs_function_name, 'SendMail faild to inform ST <'||lvs_st||'['||lvs_version||']> changed to status <'||lvs_ss_name||' ('||unapiev.p_ev_rec.object_ss||')>. Error: '||lvi_ret_code);
      END IF;
   END IF;

   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END ST_A10;

FUNCTION PP_A01
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_A01';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);

BEGIN

   --------------------------------------------------------------------------------
   -- Get current pp and version and keys
   --------------------------------------------------------------------------------
   lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
   lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
   lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
   lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
   lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
   lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
   lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);
   --------------------------------------------------------------------------------
   -- Synchronize with previous minor (UNDIFF)
   --------------------------------------------------------------------------------
   lvi_ret_code := SynchronizeAll;
   --------------------------------------------------------------------------------
   -- Get next minor version, in fact created by UNDIFF
   --------------------------------------------------------------------------------
   lvi_ret_code := UNVERSION.GetNextMinorVersion(lvs_version);
   --------------------------------------------------------------------------------
   -- Synchronize freq of new minor with template
   --------------------------------------------------------------------------------
   lvi_ret_code := APAOACTION.SYNCPPPRFREQNOTMANUAL(lvs_pp, lvs_version, lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5);

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END PP_A01;

FUNCTION PP_A02
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_A02';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
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

  lvi_ret_code := APAOACTION.PPAPPLYTEMPLATE(lvs_pp, lvs_version, lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5);

  RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END PP_A02;

FUNCTION PP_A03
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_A03';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
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

  lvi_ret_code := APAOACTION.PPPRAPPLYINTERSPECFREQ(lvs_pp, lvs_version, lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5);

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END PP_A03;

FUNCTION PP_A04
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_A04';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
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

  lvi_ret_code := APAOACTION.PPSYNCLASTCOUNT(lvs_pp, lvs_version, lvs_pp_key1, lvs_pp_key2, lvs_pp_key3, lvs_pp_key4, lvs_pp_key5);

   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END PP_A04;

FUNCTION PP_A05
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_A05';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code      APAOGEN.RETURN_TYPE;

BEGIN

  RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END PP_A05;

--------------------------------------------------------------------------------
-- FUNCTION : PP_A10
-- ABSTRACT :
--------------------------------------------------------------------------------
--   WRITER : Arie Frans Kok
-- REVIEWER :
--     DATE : 10/03/2016
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
-- 26/09/2008 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION PP_A10
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PP_A10';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm    APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code   APAOGEN.RETURN_TYPE;

lvs_pp            APAOGEN.PP_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;
lvs_pp_key1       VARCHAR2(20);
lvs_pp_key2       VARCHAR2(20);
lvs_pp_key3       VARCHAR2(20);
lvs_pp_key4       VARCHAR2(20);
lvs_pp_key5       VARCHAR2(20);

lvs_email      VARCHAR2(255) := NULL;
lvs_ss_name    UNILAB.UTSS.NAME%TYPE;
lvs_subject    VARCHAR2(255);
lts_text_tab   UNAPIGEN.VC255_TABLE_TYPE;
lvn_nr_of_rows NUMBER;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN
   --------------------------------------------------------------------------------
   -- Get current pp and version and keys
   --------------------------------------------------------------------------------
   lvs_pp         := UNAPIEV.P_EV_REC.OBJECT_ID;
   lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
   lvs_pp_key1    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 2), 9);
   lvs_pp_key2    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 3), 9);
   lvs_pp_key3    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 4), 9);
   lvs_pp_key4    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 5), 9);
   lvs_pp_key5    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 6), 9);

   -----------------------------------------------------------------------------
   -- Get the e-mail adresses to send the email to
   -----------------------------------------------------------------------------
   lvs_email := APAOACTION.GetEmailReceipients;

   -----------------------------------------------------------------------------
   -- Only continue when an e-mail adres is found
   -----------------------------------------------------------------------------
   IF lvs_email IS NOT NULL THEN
      --------------------------------------------------------------------------
      -- Try to get the name of the status to which the object is moved
      --------------------------------------------------------------------------
      BEGIN
         SELECT NVL(MAX(name), 'NAME_NOT_FOUND')
           INTO lvs_ss_name
           FROM UNILAB.utss
          WHERE ss = unapiev.p_ev_rec.object_ss;
      EXCEPTION
         WHEN OTHERS THEN
            lvs_ss_name := '';
      END;

      lvs_subject := 'PP <'||lvs_pp||'['||lvs_version||']> with pp_key1 <'||lvs_pp_key1||'> changed to status <Error(ER)>';

      lts_text_tab(1) := 'Parametergroup <'||lvs_pp||'['||lvs_version||']> with pp_key1 <'||lvs_pp_key1||'> changed to status <Error>.';
      lts_text_tab(2) := 'Possible reason is that the parameter profile is configured in Interspec but is not present in the Unilab template.';
      lts_text_tab(3) := 'Manual intervention is needed!';
      lvn_nr_of_rows  := 3;

      lvi_ret_code := UNAPIGEN.SendMail(a_recipient  => lvs_email,
                                        a_subject    => lvs_subject,
                                        a_text_tab   => lts_text_tab,
                                        a_nr_of_rows => lvn_nr_of_rows);

      IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         APAOGEN.LogError (lcs_function_name, 'SendMail faild to inform PP <'||lvs_pp||'['||lvs_version||']> with pp_key1 <'||lvs_pp_key1||'> changed to status <'||lvs_ss_name||' ('||unapiev.p_ev_rec.object_ss||')>. Error: '||lvi_ret_code);
      END IF;
   END IF;

   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END PP_A10;

FUNCTION PR_A01
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PR_A01';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
lvs_pr            APAOGEN.PR_TYPE;
lvs_version       APAOGEN.VERSION_TYPE;

BEGIN

  lvs_pr         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);

  lvi_ret_code := APAOACTION.PRAPPLYTEMPLATE(lvs_pr, lvs_version);

  RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END PR_A01;

FUNCTION PR_A02
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'PR_A02';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm          APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code         APAOGEN.RETURN_TYPE;
lvs_pr               APAOGEN.PR_TYPE;
lvs_version          APAOGEN.VERSION_TYPE;
lvs_pr_new_version   APAOGEN.VERSION_TYPE;
lvs_modify_reason    APAOGEN.MODIFY_REASON_TYPE;
BEGIN

  lvs_pr         := UNAPIEV.P_EV_REC.OBJECT_ID;
  lvs_version    := SUBSTR(APAOGEN.STRTOK(UNAPIEV.P_EV_REC.EV_DETAILS, '#', 1), 9);
  lvs_modify_reason := 'Created by <' || lcs_function_name || '>';

  lvi_ret_code := APAOACTION.PRCREATEMINOR(lvs_pr, lvs_version, lvs_pr, lvs_pr_new_version, lvs_modify_reason);

  RETURN (UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   -----------------------------------------------------------------------------
   -- Always return success in an action
   -----------------------------------------------------------------------------
   RETURN UNAPIGEN.DBERR_SUCCESS;

END PR_A02;
--------------------------------------------------------------------------------
-- CreateMeCells created me-cells
--------------------------------------------------------------------------------
FUNCTION CreateMeCells
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'CreateMeCells';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;
lvi_count           APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT (*)
     INTO lvi_count
     FROM utscmecell
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG  AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA  AND panode = UNAPIEV.P_PANODE
      AND me = UNAPIEV.P_ME  AND menode = UNAPIEV.P_MENODE;
   ----------------------------------------------------------------------------
   -- if lvi_count > 0 the details have already been created
   ----------------------------------------------------------------------------
   IF lvi_count = 0 THEN
      lvi_ret_code := UNAPIME.CREATESCMEDETAILS (UNAPIEV.P_SC,
                                                 UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                 UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                 UNAPIEV.P_ME, UNAPIEV.P_MENODE,
                                                 UNAPIEV.P_REANALYSIS);

      IF lvi_ret_code NOT IN (UNAPIGEN.DBERR_SUCCESS, UNAPIGEN.DBERR_DETAILSEXIST) THEN
         lvs_sqlerrm := SUBSTR ('UNAPIME.CREATESCMEDETAILS failed for ' ||
                        '<' || UNAPIEV.P_SC || '><' ||
                        '<' || UNAPIEV.P_PG || '><' || TO_CHAR (UNAPIEV.P_PGNODE) || '>' ||
                        '<' || UNAPIEV.P_PA || '><' || TO_CHAR (UNAPIEV.P_PANODE) || '>' ||
                        '<' || UNAPIEV.P_ME || '><' || TO_CHAR (UNAPIEV.P_MENODE) ||
                        '>. Errorcode: ' || lvi_ret_code, 1, 255);
         APAOGEN.LogError (lcs_function_name, lvs_sqlerrm);
      ELSE
          lvi_ret_code := APAOFUNCTIONS.ADDSCMECOMMENT(UNAPIEV.P_SC,
                                                       UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                       UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                       UNAPIEV.P_ME, UNAPIEV.P_MENODE,
                                                       'Methodcells created by ' || lcs_function_name);
      END IF;
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN UNAPIGEN.DBERR_SUCCESS;
END CreateMeCells;

--------------------------------------------------------------------------------
-- DeleteMeCells deletes me-cells
--------------------------------------------------------------------------------
FUNCTION DeleteMeCells
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'DeleteMeCells';
lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code        APAOGEN.RETURN_TYPE;
lvi_count           APAOGEN.COUNTER_TYPE;

BEGIN

   SELECT COUNT (*)
     INTO lvi_count
     FROM utscmecell
    WHERE sc = UNAPIEV.P_SC
      AND pg = UNAPIEV.P_PG  AND pgnode = UNAPIEV.P_PGNODE
      AND pa = UNAPIEV.P_PA  AND panode = UNAPIEV.P_PANODE
      AND me = UNAPIEV.P_ME  AND menode = UNAPIEV.P_MENODE;
   ----------------------------------------------------------------------------
   -- if lvi_count > 0 the details have already been created
   ----------------------------------------------------------------------------
   IF lvi_count > 0 THEN

      DELETE FROM UTSCMECELL
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG  AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA  AND panode = UNAPIEV.P_PANODE
         AND me = UNAPIEV.P_ME  AND menode = UNAPIEV.P_MENODE;
      DELETE FROM UTSCMECELLINPUT
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG  AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA  AND panode = UNAPIEV.P_PANODE
         AND me = UNAPIEV.P_ME  AND menode = UNAPIEV.P_MENODE;
      DELETE FROM UTSCMECELLLIST
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG  AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA  AND panode = UNAPIEV.P_PANODE
         AND me = UNAPIEV.P_ME  AND menode = UNAPIEV.P_MENODE;
      DELETE FROM UTSCMECELLLISTOUTPUT
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG  AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA  AND panode = UNAPIEV.P_PANODE
         AND me = UNAPIEV.P_ME  AND menode = UNAPIEV.P_MENODE;
      DELETE FROM UTSCMECELLOUTPUT
       WHERE sc = UNAPIEV.P_SC
         AND pg = UNAPIEV.P_PG  AND pgnode = UNAPIEV.P_PGNODE
         AND pa = UNAPIEV.P_PA  AND panode = UNAPIEV.P_PANODE
         AND me = UNAPIEV.P_ME  AND menode = UNAPIEV.P_MENODE;

      lvi_ret_code := APAOFUNCTIONS.ADDSCMECOMMENT(UNAPIEV.P_SC,
                                                   UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                   UNAPIEV.P_PA, UNAPIEV.P_PANODE,
                                                   UNAPIEV.P_ME, UNAPIEV.P_MENODE,
                                                   'Methodcells deleted by ' || lcs_function_name);
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    APAOGEN.LogError (lcs_function_name, SQLERRM);
  END IF;
  RETURN UNAPIGEN.DBERR_SUCCESS;
END DeleteMeCells;

--------------------------------------------------------------------------------
-- IC_A01: Write XML for PIBS
--------------------------------------------------------------------------------
FUNCTION IC_A01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'IC_A01';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

   lvi_ret_code := APAOACTION.WRITEXML(UNAPIEV.P_SC);

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END IC_A01;

FUNCTION RQ_A07
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'RQ_A07';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

    lvi_ret_code := APAO_OUTDOOR.CREATEWS4RQ ( UNAPIEV.P_RQ, 'Changed by ' || lcs_function_name);

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END RQ_A07;


FUNCTION WS_A01
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WS_A01';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

    lvi_ret_code := APAO_OUTDOOR.CreateWsPrepOutdoor(UNAPIEV.P_WS, 'Changed by ' || lcs_function_name);

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WS_A01;

FUNCTION WS_A02
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WS_A02';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

    lvi_ret_code := APAO_OUTDOOR.CreateScTesting(UNAPIEV.P_WS, 'Changed by ' || lcs_function_name);

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WS_A02;

FUNCTION WS_A03
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WS_A03';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

BEGIN

    lvi_ret_code := APAO_OUTDOOR.CopyWtAu2WsGk(UNAPIEV.P_WS, 'Changed by ' || lcs_function_name);

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WS_A03;

FUNCTION WS_A04
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WS_A04';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_scpa IS
  SELECT e.sc, e.pg, e.pgnode, e.pa, e.panode, e.ss, e.lc, e.lc_version
    FROM utwsgkrequestcode a,
         utwsgkavtestmethod b,
         utrqsc c,
         utscpaau d, utscpa e
   WHERE a.ws = UNAPIEV.P_WS
     AND a.ws = b.ws
     AND a.requestcode = c.rq
     AND c.sc = d.sc AND d.au = 'avTestMethod' AND d.value = b.avtestmethod
     AND d.sc = e.sc
     AND d.pg = e.pg AND d.pgnode = e.pgnode
     AND d.pa = e.pa AND d.panode = e.panode;

BEGIN

    FOR lvr_scpa IN lvq_scpa LOOP
         l_ret_code       := UNAPIPAP.CHANGESCPASTATUS
                   (lvr_scpa.sc,
                    lvr_scpa.pg,lvr_scpa.pgnode,
                    lvr_scpa.pa,lvr_scpa.panode,
                    lvr_scpa.ss,
                    'CM',
                    lvr_scpa.lc,
                    lvr_scpa.lc_version,
                    'Status changed by ' || lcs_function_name);

    END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WS_A04;


FUNCTION WS_A05
RETURN APAOGEN.RETURN_TYPE IS

lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WS_A05';

lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

CURSOR lvq_scpa IS
  SELECT e.sc, e.pg, e.pgnode, e.pa, e.panode, e.ss, e.lc, e.lc_version
    FROM utwsgkrequestcode a,
         utwsgkavtestmethod b,
         utrqsc c,
         utscpaau d, utscpa e
   WHERE a.ws = UNAPIEV.P_WS
     AND a.ws = b.ws
     AND a.requestcode = c.rq
     AND c.sc = d.sc AND d.au = 'avTestMethod' AND d.value = b.avtestmethod
     AND d.sc = e.sc
     AND d.pg = e.pg AND d.pgnode = e.pgnode
     AND d.pa = e.pa AND d.panode = e.panode;

BEGIN

    FOR lvr_scpa IN lvq_scpa LOOP
         lvi_ret_code       := UNAPIPAP.CANCELSCPA
                   (lvr_scpa.sc,
                    lvr_scpa.pg,lvr_scpa.pgnode,
                    lvr_scpa.pa,lvr_scpa.panode,
                    'Cancelled by ' || lcs_function_name);

    END LOOP;

    RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WS_A05;

--------------------------------------------------------------------------------
-- WS_A06: Generates event for reevaluate WS
--------------------------------------------------------------------------------
FUNCTION WS_A06
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WS_A06';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

l_lc             VARCHAR2(2);
l_lc_version     VARCHAR2(20);

CURSOR lvq_ws IS
 SELECT ws, ss, lc, lc_version
   FROM utws
  WHERE ws = UNAPIEV.P_WS;

BEGIN
    FOR lvr_ws IN lvq_ws LOOP
        lvi_ret_code   := APAOFUNCTIONS.RecheckWs( lvr_ws.ws,
                            lvr_ws.lc,
                            lvr_ws.lc_version,
                            lvr_ws.ss);
  APAOGEN.LogError (lcs_function_name, 'Debug-JR,  RecheckWS: ' || lvr_ws.ws || ', rtc: ' || lvi_ret_code);
    END LOOP;
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WS_A06;

--------------------------------------------------------------------------------
-- WS_A07: Generates subsamples and assigns them to the Prep-ws ( = this ws)
--------------------------------------------------------------------------------
FUNCTION WS_A07
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WS_A07';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

l_lc             VARCHAR2(2);
l_lc_version     VARCHAR2(20);
BEGIN      
  lvi_ret_code   := APAO_OUTDOOR.CreateSubSamples(UNAPIEV.P_WS, 'Changed by ' || lcs_function_name);
  APAOGEN.LogError (lcs_function_name, 'Debug-DH, AOPA_OUTDOOR.CreateSubSamples(' || UNAPIEV.P_WS || ') returns:' || lvi_ret_code);
  RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WS_A07;

--------------------------------------------------------------------------------
-- WS_A08: Sends email to requester about planned state of the full request.
--------------------------------------------------------------------------------
FUNCTION WS_A08
RETURN APAOGEN.RETURN_TYPE IS
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WS_A08';
lvs_sqlerrm        APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code       APAOGEN.RETURN_TYPE;

l_lc             VARCHAR2(2);
l_lc_version     VARCHAR2(20);
BEGIN      
  lvi_ret_code   := APAO_OUTDOOR.NotifyRequester(UNAPIEV.P_WS, 'Changed by ' || lcs_function_name);
  APAOGEN.LogError (lcs_function_name, 'Debug-DH, AOPA_OUTDOOR.NotifyRequestor(' || UNAPIEV.P_WS || ') returns:' || lvi_ret_code);
  RETURN UNAPIGEN.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;
END WS_A08;
-- END OF CUSTOMIZATION
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- SynchronizeAll
--------------------------------------------------------------------------------
FUNCTION SynchronizeAll
RETURN NUMBER IS
BEGIN
   IF UNAPIEV.p_ev_rec.object_tp = 'pp' THEN
      l_ret_code := undiff.SynchronizeChildSpec;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         TraceError(ics_package_name || '.SynchronizeAll',
                'SynchronizeChildSpec returned: '||TO_CHAR(l_ret_code)||' for pp='||UNAPIEV.p_ev_rec.object_id);
      END IF;
      l_ret_code := undiff.SynchronizeDerivedSpec;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         TraceError(ics_package_name || '.SynchronizeAll',
                'SynchronizeDerivedSpec returned: '||TO_CHAR(l_ret_code)||' for pp='||UNAPIEV.p_ev_rec.object_id);
      END IF;
   ELSIF UNAPIEV.p_ev_rec.object_tp = 'st' THEN
      l_ret_code := undiff.SynchronizeDerivedSampletype;
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         TraceError(ics_package_name || '.SynchronizeAll',
                'SynchronizeDerivedSampletype returned: '||TO_CHAR(l_ret_code)||' for pp='||UNAPIEV.p_ev_rec.object_id);
      END IF;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := SQLERRM;
   TraceError(ics_package_name || '.SynchronizeAll', l_sqlerrm);
   RETURN (UNAPIGEN.DBERR_GENFAIL);
END SynchronizeAll;

-- --------------------------------------------------------------------------------
-- This action will assign the sample type group keys automatically
-- corresponding to the pp_key[1-5] of the parameter profiles
-- when parameter profiles are assigned to a sampe type
-- --------------------------------------------------------------------------------
--
-- The typical event rules that will be inserted are
-- Event rule 1 for
--    ev_tp= 'UsedObjectsUpdated'
--    object_tp= st
--    action= UNACTION_ORG.StGkPpKeysOnStPpAss

-- INSERT INTO utevrules (rule_nr,
--                        applic, dbapi_name, object_tp, object_id, object_lc,
--                        object_lc_version, object_ss, ev_tp, condition,
--                        af, af_delay, af_delay_unit, custom )
-- SELECT NVL(MAX(rule_nr),0)+1,
--        NULL, NULL, 'st', NULL, NULL,
--        NULL, NULL, 'UsedObjectsUpdated', NULL,
--        'UNACTION_ORG.StGkPpKeysOnStPpAss' , NULL, NULL, '1'
-- FROM utevrules
-- WHERE NOT EXISTS (SELECT 'X'
--                   FROM utevrules
--                   WHERE object_tp='st'
--                     AND ev_tp = 'UsedObjectUpdated'
--                     AND af='UNACTION_ORG.StGkPpKeysOnStPpAss')
-- HAVING NVL(MAX(rule_nr),0)+1 <> 1
-- /
-- COMMIT
-- /


FUNCTION StGkPpKeysOnStPpAss
   RETURN NUMBER
IS
   l_ref_cursor   UNAPIGEN.CURSOR_REF_TYPE;
   l_value_tab    UNAPIGEN.VC40_TABLE_TYPE;
   l_nr_of_rows   NUMBER;
   l_count_new    NUMBER;

   CURSOR l_utkeypp_cursor
   IS
        SELECT   seq, SUBSTR (key_name, 4) gk
          FROM   utkeypp
         WHERE   key_name LIKE 'gk.%'
      ORDER BY   seq;
BEGIN
   IF UNAPIEV.P_EV_REC.dbapi_name = 'SaveStParameterProfile'
   THEN
      FOR l_utkeypp_rec IN l_utkeypp_cursor
      LOOP
         IF l_utkeypp_cursor%ROWCOUNT = 1
         THEN
            --issue a savepoint after first fetch to avoid fetch of sequence on ROLLBACK TO SAVEPOINT;
            SAVEPOINT UNILAB4;
         END IF;

         EXECUTE IMMEDIATE   'SELECT COUNT(*) '
                          || 'FROM (SELECT DISTINCT pp_key'
                          || l_utkeypp_rec.seq
                          || 'FROM utstpp '
                          || 'WHERE st = REPLACE (:a_st, '''', '''''') '
                          || 'AND version = :a_version '
                          || 'AND pp_key'
                          || l_utkeypp_rec.seq
                          || ' <> '' '' '
                          || 'MINUS '
                          || 'SELECT DISTINCT value '
                          || 'FROM utstgk '
                          || 'WHERE st = REPLACE (:a_st, '''', '''''') '
                          || 'AND version = :a_version '
                          || 'AND gk = :a_gk)'
            INTO   l_count_new
            USING UNAPIEV.P_EV_REC.OBJECT_ID,
                  UNAPIEV.P_VERSION,
                  UNAPIEV.P_EV_REC.OBJECT_ID,
                  UNAPIEV.P_VERSION,
                  l_utkeypp_rec.gk;

         IF l_count_new > 0
         THEN
            OPEN l_ref_cursor FOR
                  'SELECT DISTINCT pp_key'
               || l_utkeypp_rec.seq
               || ' FROM utstpp'
               || ' WHERE st = REPLACE (:a_st, '''', '''''') '
               || ' AND version = :a_version '
               || ' AND pp_key'
               || l_utkeypp_rec.seq
               || ' <> '' '''
               || ' UNION '
               ||    --we only add values in this case, we don't delete values
                 'SELECT DISTINCT value'
               || ' FROM utstgk'
               || ' WHERE st = REPLACE (:a_st, '''', '''''')'
               || ' AND version = :a_version '
               || ' AND gk = :a_gk'
               USING UNAPIEV.P_EV_REC.OBJECT_ID,
                     UNAPIEV.P_VERSION,
                     UNAPIEV.P_EV_REC.OBJECT_ID,
                     UNAPIEV.P_VERSION,
                     l_utkeypp_rec.gk;

            --Note: BULK COLLECT may be used in Oracle 9 instead of a loop
            l_nr_of_rows := 0;

            LOOP
               l_nr_of_rows := l_nr_of_rows + 1;

               FETCH l_ref_cursor INTO   l_value_tab (l_nr_of_rows);

               EXIT WHEN l_ref_cursor%NOTFOUND;
            END LOOP;

            l_nr_of_rows := l_nr_of_rows - 1;

            CLOSE l_ref_cursor;

            l_ret_code :=
               SaveObjectGroupKey ('stgk',
                                   l_utkeypp_rec.gk,
                                   l_value_tab,
                                   l_nr_of_rows,
                                   UNAPIGEN.MOD_FLAG_INSERT);

            IF l_ret_code = UNAPIGEN.DBERR_TRANSITION
            THEN
               RETURN (UNAPIGEN.DBERR_TRANSITION);
            ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS
            THEN
               l_sqlerrm :=
                     'SaveObjectGroupKey#ret_code='
                  || l_ret_code
                  || ' for gk_tp=stgk#gk='
                  || l_utkeypp_rec.gk
                  || '#nr_of_rows='
                  || l_value_tab.COUNT;
               RAISE StpError;
            END IF;
         END IF;
      END LOOP;
   END IF;

   RETURN (UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
   WHEN OTHERS
   THEN
      IF SQLCODE <> 1
      THEN
         l_sqlerrm := SUBSTR (SQLERRM, 1, 255);
      END IF;

      TraceError ('UNACTION.StGkPpKeysOnStPpAss', l_sqlerrm);
      RETURN (UNAPIGEN.DBERR_GENFAIL);
END StGkPpKeysOnStPpAss;

------------------------------------------------------------------------------------------------
-- SendMail
------------------------------------------------------------------------------------------------
--General auxiliary function that can be used to send mail from within PL/SQL
--This function will only work on Oracle8.1
--where the Jserver option has been installed
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--General auxiliary function that can be used to send mail from within PL/SQL
--This function will only work on Oracle8.1
--where the Jserver option has been installed
FUNCTION SendMail(a_recipient        IN   VARCHAR2,                    /* VC40_TYPE */
                  a_subject          IN   VARCHAR2,                    /* VC255_TYPE */
                  a_text_tab         IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
                  a_nr_of_rows       IN   NUMBER)                      /* NUM_TYPE */
RETURN NUMBER IS

lRawData      RAW(32767);
l_connection  utl_smtp.connection;
l_row         INTEGER;
l_isopen      BOOLEAN DEFAULT FALSE;

    PROCEDURE send_header(a_connection IN OUT utl_smtp.connection, a_name IN VARCHAR2, a_header IN VARCHAR2) AS
    BEGIN
       utl_smtp.write_data(a_connection, a_name || ': ' || a_header || utl_tcp.CRLF);
    END;

   PROCEDURE send_raw_header(a_connection IN OUT utl_smtp.connection, a_name IN VARCHAR2, a_header IN VARCHAR2) AS
      l_raw RAW(32767);
   BEGIN
      l_raw := utl_raw.cast_to_raw(a_name || ': ' || a_header || utl_tcp.CRLF);
      utl_smtp.write_raw_data(a_connection, l_raw);
   END;

BEGIN

   l_connection := utl_smtp.open_connection(P_SMTP_SERVER);
   l_isopen := TRUE;

   utl_smtp.helo(l_connection, P_SMTP_DOMAIN);
   utl_smtp.mail(l_connection, 'unilab@compex.be');
   utl_smtp.rcpt(l_connection, a_recipient);
   utl_smtp.open_data(l_connection);
   send_header(l_connection, 'From',   P_SMTP_SENDER);
   send_header(l_connection, 'To',     a_recipient);
   send_raw_header(l_connection, 'Subject', a_subject);
   send_header(l_connection, 'Content-Type', UNAPIGEN.P_SMTP_CONTENT_TYPE);
   FOR l_row IN 1..a_nr_of_rows LOOP
      lRawData := utl_raw.cast_to_raw(utl_tcp.CRLF || a_text_tab(l_row));
      UTL_smtp.write_raw_data(l_connection, lRawData);
   END LOOP;
   utl_smtp.close_data(l_connection);
   utl_smtp.quit(l_connection);
   l_isopen := FALSE;

   RETURN(UNAPIGEN.DBERR_SUCCESS);


EXCEPTION
WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
   IF l_isopen THEN
      utl_smtp.quit(l_connection);
      l_isopen := FALSE;
   END IF;
   l_isopen := FALSE;
   l_sqlerrm := 'Failed to send mail due to the following error: ' || SUBSTR(SQLERRM,1,200);
   TraceError('SendMail', l_sqlerrm);
   TraceError('SendMail', SUBSTR('Used settings:smtp_server='||P_SMTP_SERVER||'#smtp_domain='||P_SMTP_DOMAIN||'#smtp_sender='||P_SMTP_SENDER||'#smtp_recipient='||a_recipient||'#Content-Type='||UNAPIGEN.P_SMTP_CONTENT_TYPE,1,255));
   RETURN(UNAPIGEN.DBERR_GENFAIL);
WHEN OTHERS THEN
   l_sqlerrm := SUBSTR(SQLERRM,1,255);
   TraceError('SendMail', l_sqlerrm);
   TraceError('SendMail', SUBSTR('Used settings:smtp_server='||P_SMTP_SERVER||'#smtp_domain='||P_SMTP_DOMAIN||'#smtp_sender='||P_SMTP_SENDER||'#smtp_recipient='||a_recipient||'#Content-Type='||UNAPIGEN.P_SMTP_CONTENT_TYPE,1,255));
   IF l_isopen THEN
      utl_smtp.quit(l_connection);
      l_isopen := FALSE;
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END SendMail;

----------------------------------------------------------------------------------------------
----                        ASSIGNMENT RULES FOR GROUPKEYS                                ----
----------------------------------------------------------------------------------------------
FUNCTION SaveObjectGroupKey
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2,                  /* VC20_TYPE */
 a_value           IN     VARCHAR2,                  /* VC40_TYPE */
 a_modify_flag     IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER IS

   --************************************************************************
   --PAY ATTENTION while modifying this code that it muts work for group keys
   --for which no definition exists
   --************************************************************************
   l_value_tab                    UNAPIGEN.VC40_TABLE_TYPE;
   l_nr_of_rows                   NUMBER;
   l_single_valued                CHAR(1);

   PROCEDURE SeparateConcatenatedString
   IS
      -- Variables for the position of the separator CHR(9) in the concatenated values-string
      l_chr9_pos       NUMBER;
      l_chr9_prev_pos  NUMBER;
   BEGIN
      l_chr9_pos      := 0;
      l_chr9_prev_pos := 0;
      l_chr9_pos := INSTR(a_value, CHR(9), 1, 1);
      IF l_chr9_pos <> 0 THEN
         l_nr_of_rows := 0;
         -- Get the values in the concatenated values-string
         LOOP
            EXIT WHEN l_chr9_pos = 0;
            l_nr_of_rows := l_nr_of_rows + 1;
            l_value_tab(l_nr_of_rows) := SUBSTR(a_value, l_chr9_prev_pos+1, l_chr9_pos-l_chr9_prev_pos-1);
            l_chr9_prev_pos := l_chr9_pos;
            l_chr9_pos := INSTR(a_value, CHR(9), 1, l_nr_of_rows+1);
         END LOOP;
         -- Get the last value in the concatenated values-string
         l_nr_of_rows := l_nr_of_rows + 1;
         l_value_tab(l_nr_of_rows) := SUBSTR(a_value, l_chr9_prev_pos+1);
      END IF;
   END SeparateConcatenatedString;
BEGIN
   l_nr_of_rows := 1;
   l_value_tab(1) := a_value;

   -- If the value comes from an infofield, it is possible that it is composed of multiple values,
   -- separated by CHR(9). If the gk is multivalued, these concatenated values have to be saved as
   -- different gk values.
   l_sql_string := 'SELECT single_valued FROM utgk'||SUBSTR(a_gk_tp,1,2)||' WHERE gk = '''||a_gk||'''';
   BEGIN
      EXECUTE IMMEDIATE l_sql_string
      INTO l_single_valued;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      --group key definition does not exist
      l_single_valued := '1';
   END;
   IF l_single_valued = '0' THEN
      SeparateConcatenatedString;
   END IF;
   RETURN(SaveObjectGroupKey(a_gk_tp, a_gk, l_value_tab, l_nr_of_rows, a_modify_flag));
END SaveObjectGroupKey;

FUNCTION SaveObjectGroupKey
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2,                  /* VC20_TYPE */
 a_value_tab       IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TAB_TYPE */
 a_nr_of_rows      IN     NUMBER,                    /* NUM_TYPE */
 a_modify_flag     IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER IS

a_gk_version                   VARCHAR2(20);
l_rq                           VARCHAR2(20);
l_sd                           VARCHAR2(20);
l_nr_of_rows                   NUMBER;
l_previous_allow_modify_check  CHAR(1);
l_in_transition                BOOLEAN;
l_tmp_retrieswhenintransition  INTEGER;
l_tmp_intervalwhenintransition NUMBER;
l_struct_created               CHAR(1);

CURSOR c_rq IS
   SELECT rq
     FROM UTSC
    WHERE sc = UNAPIEV.P_SC;

CURSOR c_sd IS
   SELECT sd
     FROM UTSC
    WHERE sc = UNAPIEV.P_SC;

CURSOR c_sc IS
   SELECT sc
     FROM UTRQSC
    WHERE rq = UNAPIEV.P_RQ
      AND UNAPIEV.P_EV_REC.OBJECT_TP IN ('rq','rqic','rqii')
   UNION ALL
   SELECT DISTINCT sc
     FROM UTWSSC
    WHERE ws = UNAPIEV.P_WS
      AND UNAPIEV.P_EV_REC.OBJECT_TP = 'ws'
   UNION ALL
      (SELECT DISTINCT sc
        FROM utsdsc
       WHERE sd = UNAPIEV.P_SD
         AND UNAPIEV.P_EV_REC.OBJECT_TP IN ('sd','sdic','sdii')
      UNION
      SELECT DISTINCT sc
        FROM utsdcellsc
       WHERE sd = UNAPIEV.P_SD
         AND UNAPIEV.P_EV_REC.OBJECT_TP IN ('sd','sdic','sdii')
         AND sc = NVL(UNAPIEV.P_SC, sc)); -- special case: sd event with sample code in details

CURSOR c_me IS
   SELECT sc, pg, pgnode, pa, panode, me, menode
     FROM UTSCME
    WHERE sc     = UNAPIEV.P_SC
      AND pg     = NVL(UNAPIEV.P_PG, pg)
      AND pgnode = NVL(UNAPIEV.P_PGNODE, pgnode)
      AND pa     = NVL(UNAPIEV.P_PA, pa)
      AND panode = NVL(UNAPIEV.P_PANODE, panode)
      AND me     = NVL(UNAPIEV.P_ME, me)
      AND menode = NVL(UNAPIEV.P_MENODE, menode)
      AND UNAPIEV.P_EV_REC.OBJECT_TP IN ('sc','pg','pa','ic','ii')
   UNION ALL
   SELECT sc, pg, pgnode, pa, panode, me, menode
     FROM UTSCME
    WHERE sc IN (SELECT sc FROM UTRQSC WHERE rq = UNAPIEV.P_RQ)
      AND UNAPIEV.P_EV_REC.OBJECT_TP IN ('rq','rqic','rqii')
   UNION ALL
   SELECT DISTINCT sc, pg, pgnode, pa, panode, me, menode
     FROM UTWSME
    WHERE ws = UNAPIEV.P_WS
      AND UNAPIEV.P_EV_REC.OBJECT_TP = 'ws'
   UNION ALL
      (SELECT DISTINCT sc, pg, pgnode, pa, panode, me, menode
         FROM UTSCME
        WHERE sc IN (SELECT DISTINCT sc FROM utsdsc WHERE sd = UNAPIEV.P_SD)
          AND UNAPIEV.P_EV_REC.OBJECT_TP IN ('sd','sdic','sdii')
       UNION
       SELECT DISTINCT sc, pg, pgnode, pa, panode, me, menode
         FROM UTSCME
        WHERE sc IN (SELECT sc FROM utsdcellsc WHERE sd = UNAPIEV.P_SD)
          AND UNAPIEV.P_EV_REC.OBJECT_TP IN ('sd','sdic','sdii'));

CURSOR c_ws IS
   SELECT DISTINCT ws
     FROM UTWSII
    WHERE sc     = UNAPIEV.P_SC
      AND ic     = UNAPIEV.P_IC
      AND icnode = UNAPIEV.P_ICNODE
      AND ii     = NVL(UNAPIEV.P_II, ii)
      AND iinode = NVL(UNAPIEV.P_IINODE, iinode)
      AND UNAPIEV.P_EV_REC.OBJECT_TP IN ('ic','ii')
   UNION ALL
   SELECT DISTINCT ws
     FROM UTWSME
    WHERE sc     = UNAPIEV.P_SC
      AND pg     = UNAPIEV.P_PG
      AND pgnode = UNAPIEV.P_PGNODE
      AND pa     = NVL(UNAPIEV.P_PA, pa)
      AND panode = NVL(UNAPIEV.P_PANODE, panode)
      AND me     = NVL(UNAPIEV.P_ME, me)
      AND menode = NVL(UNAPIEV.P_MENODE, me)
      AND UNAPIEV.P_EV_REC.OBJECT_TP IN ('pg','pa','me')
   UNION ALL
   SELECT DISTINCT ws
     FROM UTWSSC
    WHERE sc = UNAPIEV.P_SC
      AND UNAPIEV.P_EV_REC.OBJECT_TP = 'sc';

--CURSOR c_gksd IS
--   SELECT struct_created
--     FROM utgksd
--    WHERE gk = a_gk
--      AND version = a_gk_version;
--
--CURSOR c_gkrq IS
--   SELECT struct_created
--     FROM utgkrq
--    WHERE gk = a_gk
--      AND version = a_gk_version;
--
--CURSOR c_gksc IS
--   SELECT struct_created
--     FROM utgksc
--    WHERE gk = a_gk
--      AND version = a_gk_version;
--
--CURSOR c_gkme IS
--   SELECT struct_created
--     FROM utgkme
--    WHERE gk = a_gk
--      AND version = a_gk_version;
--
--CURSOR c_gkws IS
--   SELECT struct_created
--     FROM utgkws
--    WHERE gk = a_gk
--      AND version = a_gk_version;
--
--CURSOR c_gkrt IS
--   SELECT struct_created
--     FROM utgkrt
--    WHERE gk = a_gk
--      AND version = a_gk_version;
--
--CURSOR c_gkst IS
--   SELECT struct_created
--     FROM utgkst
--    WHERE gk = a_gk
--      AND version = a_gk_version;
--
--CURSOR c_gkpt IS
--   SELECT struct_created
--     FROM utgkpt
--    WHERE gk = a_gk
--      AND version = a_gk_version;

CURSOR c_rtst IS
   SELECT DISTINCT rt, version
     FROM utrtst
    WHERE st         = UNAPIEV.P_EV_REC.OBJECT_ID
      AND st_version = UNAPIEV.P_VERSION;

CURSOR c_strt IS
   SELECT DISTINCT st, st_version
     FROM utrtst
    WHERE rt      = UNAPIEV.P_EV_REC.OBJECT_ID
      AND version = UNAPIEV.P_VERSION;

CURSOR c_stpt IS
   SELECT DISTINCT st, st_version
     FROM utptcellst
    WHERE pt      = UNAPIEV.P_EV_REC.OBJECT_ID
      AND version = UNAPIEV.P_VERSION;

CURSOR c_ptst IS
   SELECT DISTINCT pt, version
     FROM utptcellst
    WHERE st         = UNAPIEV.P_EV_REC.OBJECT_ID
      AND st_version = UNAPIEV.P_VERSION;

BEGIN
   --************************************************************************
   --PAY ATTENTION while modifying this code that it muts work for group keys
   --for which no definition exists
   --************************************************************************


   -- SPECIAL CASE 1
   -- The UNAPIGEN.GetAuthorisation function doesn't check whether the allow_modify check is
   -- enabled or disabled. This function will lead to an error in the table uterror when you
   -- try to save a groupkey of a configurational object that is not modifiable !

   l_sqlerrm := NULL;

   -- SPECIAL CASE 2
   -- An object groupkey is linked with an infofield. If in one transaction events are triggered
   -- on both the object and the infofield, then they are both in transition and no action can
   -- be executed. For that reason, we postpone the action to the end of the event queue.
   l_in_transition := FALSE;

   --reduce the time-out for in-transition objects (retsored at the end) to 400 ms
   l_tmp_retrieswhenintransition := UNAPIEV.P_RETRIESWHENINTRANSITION;
   l_tmp_intervalwhenintransition := UNAPIEV.P_INTERVALWHENINTRANSITION;
   UNAPIEV.P_RETRIESWHENINTRANSITION  := 1;
   UNAPIEV.P_INTERVALWHENINTRANSITION := 0.4;

   /* TO BE REMOVED WHEN VERSION_CONTROL ON GROUPKEYS WILL BE SUPPORTED */
   a_gk_version := Unversion.P_NO_VERSION;
   IF a_gk_version IS NULL THEN
      l_sqlerrm := 'UNVERSION.P_NO_VERSION has no value';
      RAISE StpError;
   END IF;
   /* end of TO BE REMOVED WHEN VERSION_CONTROL ON GROUPKEYS WILL BE SUPPORTED */

   -- check the type of the modify flag
   IF a_modify_flag = UNAPIGEN.MOD_FLAG_INSERT THEN
      l_nr_of_rows := a_nr_of_rows;
   ELSIF a_modify_flag = UNAPIGEN.MOD_FLAG_DELETE THEN
      l_nr_of_rows := 0;
   END IF;

   -- disable allow modify check when not yet disabled
   l_ret_code := UNAPIAUT.GetAllowModifyCheckMode(l_previous_allow_modify_check);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      l_sqlerrm := 'GetAllowModifyCheckMode#errorcode='||l_ret_code;
      RAISE StpError;
   END IF;
   IF l_previous_allow_modify_check = '0' THEN
      l_ret_code := UNAPIAUT.DisableAllowModifyCheck('1');
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm := 'flag=1#DisableAllowModifyCheck#errorcode='||l_ret_code;
         RAISE StpError;
      END IF;
   END IF;

   -- check the type of the groupkey
   IF a_gk_tp = 'rqgk' THEN
--      OPEN c_gkrq;
--      FETCH c_gkrq INTO l_struct_created;
--      IF c_gkrq%NOTFOUND THEN
--         l_sqlerrm := UNAPIGEN.DBERR_NOOBJECT;
--         RAISE StpError;
--      END IF;
--      CLOSE c_gkrq;
--
--      IF l_struct_created = '1' THEN
         IF ((UNAPIEV.P_EV_REC.OBJECT_TP='rq') AND (UNAPIEV.P_EV_REC.EV_TP<>'RqGroupKeyUpdated')) OR
            (UNAPIEV.P_EV_REC.OBJECT_TP IN ('rqic','rqii')) THEN
         -- you already have the rq key
            -- save the groupkey
            l_ret_code := UNAPIRQP.Save1RqGroupKey(UNAPIEV.P_RQ, a_gk, a_gk_version, a_value_tab,
                                                   l_nr_of_rows, NULL);
            IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
               l_in_transition := TRUE;
            ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
               l_sqlerrm :=
                'Save1RqGroupKey#return=' || TO_CHAR(l_ret_code) || '#rq=' || UNAPIEV.P_RQ ||
                '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
               RAISE StpError;
            END IF;
         ELSIF UNAPIEV.P_EV_REC.OBJECT_TP IN ('sc','pg','pa','me','ic','ii') THEN
         -- you first have to fetch the rq key
            OPEN c_rq;
            FETCH c_rq INTO l_rq;
            IF c_rq%FOUND THEN
               -- save the groupkey
               l_ret_code := UNAPIRQP.Save1RqGroupKey(l_rq, a_gk, a_gk_version, a_value_tab,
                                                      l_nr_of_rows, NULL);
               IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
                  l_in_transition := TRUE;
               ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                  l_sqlerrm :=
                   'Save1RqGroupKey#return=' || TO_CHAR(l_ret_code) || '#rq=' || l_rq ||
                   '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
                  RAISE StpError;
               END IF;
            END IF;
            CLOSE c_rq;
         END IF;
--      END IF;
   ELSIF a_gk_tp = 'sdgk' THEN
--      OPEN c_gksd;
--      FETCH c_gksd INTO l_struct_created;
--      IF c_gksd%NOTFOUND THEN
--         l_sqlerrm := UNAPIGEN.DBERR_NOOBJECT;
--         RAISE StpError;
--      END IF;
--      CLOSE c_gksd;
--
--      IF l_struct_created = '1' THEN
         IF ((UNAPIEV.P_EV_REC.OBJECT_TP='sd') AND (UNAPIEV.P_EV_REC.EV_TP<>'SdGroupKeyUpdated')) OR
            (UNAPIEV.P_EV_REC.OBJECT_TP IN ('sdic','sdii')) THEN
            -- you already have the sd key
            -- save the groupkey
            l_ret_code := UNAPISDP.Save1SdGroupKey(UNAPIEV.P_SD, a_gk, a_gk_version, a_value_tab,
                                                   l_nr_of_rows, NULL);
            IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
               l_in_transition := TRUE;
            ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
               l_sqlerrm :=
                'Save1RqGroupKey#return=' || TO_CHAR(l_ret_code) || '#sd=' || UNAPIEV.P_SD ||
                '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
               RAISE StpError;
            END IF;
         ELSIF UNAPIEV.P_EV_REC.OBJECT_TP IN ('sc','pg','pa','me','ic','ii') THEN
         -- you first have to fetch the rq key
            OPEN c_sd;
            FETCH c_sd INTO l_sd;
            IF c_sd%FOUND THEN
               -- save the groupkey
               l_ret_code := UNAPISDP.Save1SdGroupKey(l_sd, a_gk, a_gk_version, a_value_tab,
                                                      l_nr_of_rows, NULL);
               IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
                  l_in_transition := TRUE;
               ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                  l_sqlerrm :=
                   'Save1SdGroupKey#return=' || TO_CHAR(l_ret_code) || '#sd=' || l_sd ||
                   '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
                  RAISE StpError;
               END IF;
            END IF;
            CLOSE c_sd;
         END IF;
--      END IF;

   ELSIF a_gk_tp = 'scgk' THEN
--      OPEN c_gksc;
--      FETCH c_gksc INTO l_struct_created;
--      IF c_gksc%NOTFOUND THEN
--         l_sqlerrm := UNAPIGEN.DBERR_NOOBJECT;
--         RAISE StpError;
--      END IF;
--      CLOSE c_gksc;
--
--      IF l_struct_created = '1' THEN
         IF ((UNAPIEV.P_EV_REC.OBJECT_TP='sc') AND (UNAPIEV.P_EV_REC.EV_TP<>'ScGroupKeyUpdated')) OR
            (UNAPIEV.P_EV_REC.OBJECT_TP IN ('pg','pa','me','ic','ii')) THEN
         -- you already have the sc key
            -- save the groupkey
            l_ret_code := UNAPISCP.Save1ScGroupKey(UNAPIEV.P_SC, a_gk, a_gk_version, a_value_tab,
                                                   l_nr_of_rows, NULL);
            IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
               l_in_transition := TRUE;
            ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
               l_sqlerrm :=
                'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) || '#sc=' || UNAPIEV.P_SC ||
                '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
               RAISE StpError;
            END IF;
         ELSIF UNAPIEV.P_EV_REC.OBJECT_TP IN ('rq','rqic','rqii','ws','sd', 'sdic', 'sdii') THEN
            -- you first have to fetch the sc key
            -- some study events are sent to the study but are containing the sample code
            -- in their details: SdCellSample...
            -- In that specific case the sample specified in the details will be used
            FOR c_sc_rec IN c_sc LOOP
               IF c_sc%ROWCOUNT = 1 THEN
                  --issue a savepoint after first fetch to avoid fetch of sequence on ROLLBACK TO SAVEPOINT;
                  SAVEPOINT UNILAB4;
               END IF;
               -- save the groupkey
               l_ret_code := UNAPISCP.Save1ScGroupKey(c_sc_rec.sc, a_gk, a_gk_version, a_value_tab,
                                                      l_nr_of_rows, NULL);
               IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
                  l_in_transition := TRUE;
               ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                  l_sqlerrm :=
                   'Save1ScGroupKey#return=' || TO_CHAR(l_ret_code) || '#sc=' || c_sc_rec.sc ||
                   '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
                  RAISE StpError;
               END IF;
            END LOOP;
         END IF;
--      END IF;

   ELSIF a_gk_tp = 'megk' THEN
--      OPEN c_gkme;
--      FETCH c_gkme INTO l_struct_created;
--      IF c_gkme%NOTFOUND THEN
--         l_sqlerrm := UNAPIGEN.DBERR_NOOBJECT;
--         RAISE StpError;
--      END IF;
--      CLOSE c_gkme;
--
--      IF l_struct_created = '1' THEN
         IF (UNAPIEV.P_EV_REC.OBJECT_TP='me') AND (UNAPIEV.P_EV_REC.EV_TP<>'MeGroupKeyUpdated') THEN
         -- you already have the me key
            -- save the groupkey
            l_ret_code := UNAPIMEP.Save1ScMeGroupKey(UNAPIEV.P_SC, UNAPIEV.P_PG, UNAPIEV.P_PGNODE,
                                                     UNAPIEV.P_PA, UNAPIEV.P_PANODE, UNAPIEV.P_ME,
                                                     UNAPIEV.P_MENODE, a_gk, a_gk_version,
                                                     a_value_tab, l_nr_of_rows, NULL);
            IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
               l_in_transition := TRUE;
            ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
               l_sqlerrm :=
                'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) || '#sc=' || UNAPIEV.P_SC ||
                '#pg=' || UNAPIEV.P_PG || '#pgnode=' || TO_CHAR(UNAPIEV.P_PGNODE) ||
                '#pa=' || UNAPIEV.P_PA || '#panode=' || TO_CHAR(UNAPIEV.P_PANODE) ||
                '#me=' || UNAPIEV.P_ME || '#menode=' || TO_CHAR(UNAPIEV.P_MENODE) ||
                '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
               RAISE StpError;
            END IF;
         ELSIF UNAPIEV.P_EV_REC.OBJECT_TP IN ('sc','pg','pa','ic','ii','rq','rqic','rqii','ws','sd','sdic','sdii') THEN
         -- you first have to fetch the me key
            FOR c_me_rec IN c_me LOOP
               IF c_me%ROWCOUNT = 1 THEN
                  --issue a savepoint after first fetch to avoid fetch of sequence on ROLLBACK TO SAVEPOINT;
                  SAVEPOINT UNILAB4;
               END IF;
               -- save the groupkey
               l_ret_code := UNAPIMEP.Save1ScMeGroupKey(c_me_rec.sc, c_me_rec.pg, c_me_rec.pgnode,
                                                        c_me_rec.pa, c_me_rec.panode, c_me_rec.me,
                                                        c_me_rec.menode, a_gk, a_gk_version,
                                                        a_value_tab, l_nr_of_rows, NULL);
               IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
                  l_in_transition := TRUE;
               ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                  l_sqlerrm :=
                   'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) || '#sc=' || c_me_rec.sc ||
                   '#pg=' || c_me_rec.pg || '#pgnode=' || TO_CHAR(c_me_rec.pgnode) ||
                   '#pa=' || c_me_rec.pa || '#panode=' || TO_CHAR(c_me_rec.panode) ||
                   '#me=' || c_me_rec.me || '#menode=' || TO_CHAR(c_me_rec.menode) ||
                   '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
                  RAISE StpError;
               END IF;
            END LOOP;
         END IF;
--      END IF;

   ELSIF a_gk_tp = 'wsgk' THEN
--      OPEN c_gkws;
--      FETCH c_gkws INTO l_struct_created;
--      IF c_gkws%NOTFOUND THEN
--         l_sqlerrm := UNAPIGEN.DBERR_NOOBJECT;
--         RAISE StpError;
--      END IF;
--      CLOSE c_gkws;
--
--      IF l_struct_created = '1' THEN
         IF (UNAPIEV.P_EV_REC.OBJECT_TP='ws') AND (UNAPIEV.P_EV_REC.EV_TP<>'WsGroupKeyUpdated') THEN
         -- you already have the ws key
            -- save the groupkey
            l_ret_code := UNAPIWSP.Save1WsGroupKey(UNAPIEV.P_WS, a_gk, a_gk_version, a_value_tab,
                                                   l_nr_of_rows, NULL);
            IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
               l_in_transition := TRUE;
            ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
               l_sqlerrm :=
                'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) || '#ws=' || UNAPIEV.P_WS ||
                '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
               RAISE StpError;
            END IF;
         ELSIF UNAPIEV.P_EV_REC.OBJECT_TP IN ('sc','pg','pa','me','ic','ii') THEN
         -- you first have to fetch the ws key
            FOR c_ws_rec IN c_ws LOOP
               IF c_ws%ROWCOUNT = 1 THEN
                  --issue a savepoint after first fetch to avoid fetch of sequence on ROLLBACK TO SAVEPOINT;
                  SAVEPOINT UNILAB4;
               END IF;
               -- save the groupkey
               l_ret_code := UNAPIWSP.Save1WsGroupKey(c_ws_rec.ws, a_gk, a_gk_version,
                                                      a_value_tab, l_nr_of_rows, NULL);
               IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
                  l_in_transition := TRUE;
               ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                  l_sqlerrm :=
                   'Save1ScMeGroupKey#return=' || TO_CHAR(l_ret_code) || '#ws=' || c_ws_rec.ws ||
                   '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
                  RAISE StpError;
               END IF;
            END LOOP;
         END IF;
--      END IF;

   ELSIF a_gk_tp = 'rtgk' THEN
--      OPEN c_gkrt;
--      FETCH c_gkrt INTO l_struct_created;
--      IF c_gkrt%NOTFOUND THEN
--         l_sqlerrm := UNAPIGEN.DBERR_NOOBJECT;
--         RAISE StpError;
--      END IF;
--      CLOSE c_gkrt;
--
--      IF l_struct_created = '1' THEN
         IF (UNAPIEV.P_EV_REC.OBJECT_TP='rt') AND (UNAPIEV.P_EV_REC.EV_TP<>'RtGroupKeyUpdated') THEN
         -- you already have the rt key
            -- save the groupkey
            l_ret_code := UNAPIRT.Save1RtGroupKey(UNAPIEV.P_EV_REC.OBJECT_ID, UNAPIEV.P_VERSION,
                                                  a_gk, a_gk_version, a_value_tab,
                                                  l_nr_of_rows, NULL);
            IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
               l_in_transition := TRUE;
            ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
               l_sqlerrm :=
                'Save1RtGroupKey#return=' || TO_CHAR(l_ret_code) ||
                '#rt=' || UNAPIEV.P_EV_REC.OBJECT_ID || '#rt_version=' || UNAPIEV.P_VERSION ||
                '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
               RAISE StpError;
            END IF;
         ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'st' THEN
         -- you first have to fetch the rt key
            FOR c_rtst_rec IN c_rtst LOOP
               IF c_rtst%ROWCOUNT = 1 THEN
                  --issue a savepoint after first fetch to avoid fetch of sequence on ROLLBACK TO SAVEPOINT;
                  SAVEPOINT UNILAB4;
               END IF;
               -- save the groupkey
               l_ret_code := UNAPIRT.Save1RtGroupKey(c_rtst_rec.rt, c_rtst_rec.version, a_gk,
                                                     a_gk_version, a_value_tab, l_nr_of_rows, NULL);
               IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
                  l_in_transition := TRUE;
               ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                  l_sqlerrm :=
                   'Save1RtGroupKey#return=' || TO_CHAR(l_ret_code) || '#rt=' || c_rtst_rec.rt ||
                   '#rt_version=' || c_rtst_rec.version ||
                   '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
                  RAISE StpError;
               END IF;
            END LOOP;
         END IF;
--      END IF;

   ELSIF a_gk_tp = 'stgk' THEN
--      OPEN c_gkst;
--      FETCH c_gkst INTO l_struct_created;
--      IF c_gkst%NOTFOUND THEN
--         l_sqlerrm := UNAPIGEN.DBERR_NOOBJECT;
--         RAISE StpError;
--      END IF;
--      CLOSE c_gkst;
--
--      IF l_struct_created = '1' THEN
         IF (UNAPIEV.P_EV_REC.OBJECT_TP='st') AND (UNAPIEV.P_EV_REC.EV_TP<>'StGroupKeyUpdated') THEN
         -- you already have the st key
            -- save the groupkey
            l_ret_code := UNAPIST.Save1StGroupKey(UNAPIEV.P_EV_REC.OBJECT_ID, UNAPIEV.P_VERSION,
                                                  a_gk, a_gk_version, a_value_tab,
                                                  l_nr_of_rows, NULL);
            IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
               l_in_transition := TRUE;
            ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
               l_sqlerrm :=
                'Save1StGroupKey#return=' || TO_CHAR(l_ret_code) ||
                '#st=' || UNAPIEV.P_EV_REC.OBJECT_ID || '#st_version=' || UNAPIEV.P_VERSION ||
                '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
               RAISE StpError;
            END IF;
         ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'rt' THEN
         -- you first have to fetch the st key
            FOR c_strt_rec IN c_strt LOOP
               IF c_strt%ROWCOUNT = 1 THEN
                  --issue a savepoint after first fetch to avoid fetch of sequence on ROLLBACK TO SAVEPOINT;
                  SAVEPOINT UNILAB4;
               END IF;
               -- save the groupkey
               l_ret_code := UNAPIST.Save1StGroupKey(c_strt_rec.st,
                                                     UNAPIGEN.UseVersion('st',c_strt_rec.st,c_strt_rec.st_version),
                                                     a_gk, a_gk_version, a_value_tab,
                                                     l_nr_of_rows, NULL);
               IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
                  l_in_transition := TRUE;
               ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                  l_sqlerrm :=
                   'Save1StGroupKey#return=' || TO_CHAR(l_ret_code) || '#st=' || c_strt_rec.st ||
                   '#st_version=' || UNAPIGEN.UseVersion('st',c_strt_rec.st,c_strt_rec.st_version) ||
                   '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
                  RAISE StpError;
               END IF;
            END LOOP;
         ELSIF UNAPIEV.P_EV_REC.OBJECT_TP = 'pt' THEN
         -- you first have to fetch the st key
            FOR c_stpt_rec IN c_stpt LOOP
               IF c_stpt%ROWCOUNT = 1 THEN
                  --issue a savepoint after first fetch to avoid fetch of sequence on ROLLBACK TO SAVEPOINT;
                  SAVEPOINT UNILAB4;
               END IF;
               -- save the groupkey
               l_ret_code := UNAPIST.Save1StGroupKey(c_stpt_rec.st,
                                                     UNAPIGEN.UseVersion('st',c_stpt_rec.st,c_stpt_rec.st_version),
                                                     a_gk, a_gk_version, a_value_tab,
                                                     l_nr_of_rows, NULL);
               IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
                  l_in_transition := TRUE;
               ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                  l_sqlerrm :=
                   'Save1StGroupKey#return=' || TO_CHAR(l_ret_code) || '#st=' || c_stpt_rec.st ||
                   '#st_version=' || UNAPIGEN.UseVersion('st',c_stpt_rec.st,c_stpt_rec.st_version) ||
                   '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
                  RAISE StpError;
               END IF;
            END LOOP;
         END IF;
--      END IF;

    ELSIF a_gk_tp = 'ptgk' THEN
--      OPEN c_gkpt;
--      FETCH c_gkpt INTO l_struct_created;
--      IF c_gkpt%NOTFOUND THEN
--         l_sqlerrm := UNAPIGEN.DBERR_NOOBJECT;
--         RAISE StpError;
--      END IF;
--      CLOSE c_gkpt;
--
--      IF l_struct_created = '1' THEN
         IF (UNAPIEV.P_EV_REC.OBJECT_TP='pt') AND (UNAPIEV.P_EV_REC.EV_TP<>'PtGroupKeyUpdated') THEN
         -- you already have the pt key
            -- save the groupkey
            l_ret_code := UNAPIPT.Save1PtGroupKey(UNAPIEV.P_PT, UNAPIEV.P_PT_VERSION, a_gk, a_gk_version,
                                                  a_value_tab, l_nr_of_rows, NULL);
            IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
               l_in_transition := TRUE;
            ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
               l_sqlerrm :=
                'Save1PtGroupKey#return=' || TO_CHAR(l_ret_code) || '#pt=' || UNAPIEV.P_PT ||
                '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
               RAISE StpError;
            END IF;
         ELSIF UNAPIEV.P_EV_REC.OBJECT_TP IN ('st') THEN
         -- you first have to fetch the pt key
            FOR c_ptst_rec IN c_ptst LOOP
               IF c_ptst%ROWCOUNT = 1 THEN
                  --issue a savepoint after first fetch to avoid fetch of sequence on ROLLBACK TO SAVEPOINT;
                  SAVEPOINT UNILAB4;
               END IF;
               -- save the groupkey
               l_ret_code := UNAPIPT.Save1PtGroupKey(c_ptst_rec.pt, c_ptst_rec.version, a_gk, a_gk_version,
                                                     a_value_tab, l_nr_of_rows, NULL);
               IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
                  l_in_transition := TRUE;
               ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS AND l_ret_code <> UNAPIGEN.DBERR_UNIQUEGK THEN
                  l_sqlerrm :=
                   'Save1PtGroupKey#return=' || TO_CHAR(l_ret_code) || '#pt=' || c_ptst_rec.pt ||
                   '#gk=' || a_gk || '#gk_version=' || a_gk_version || '#nr_of_rows=' || l_nr_of_rows;
                  RAISE StpError;
               END IF;
            END LOOP;
         END IF;
--      END IF;
   END IF;

   -- restore previous allow modify check mode
   l_ret_code := UNAPIAUT.DisableAllowModifyCheck(l_previous_allow_modify_check);
   IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      l_sqlerrm := 'DisableAllowModifyCheck#errorcode='||l_ret_code;
      RAISE StpError;
   END IF;

   --restore original time-out for in-transition objects
   UNAPIEV.P_RETRIESWHENINTRANSITION  := l_tmp_retrieswhenintransition;
   UNAPIEV.P_INTERVALWHENINTRANSITION := l_tmp_intervalwhenintransition;

   IF l_in_transition THEN
      RETURN(UNAPIGEN.DBERR_TRANSITION);
   ELSE
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   TraceError(ics_package_name || '.SaveObjectGroupKey', l_sqlerrm);
   IF c_rq%ISOPEN THEN
      CLOSE c_rq;
   END IF;
   IF c_sc%ISOPEN THEN
      CLOSE c_sc;
   END IF;
   IF c_me%ISOPEN THEN
      CLOSE c_me;
   END IF;
   IF c_ws%ISOPEN THEN
      CLOSE c_ws;
   END IF;
--   IF c_gkrq%ISOPEN THEN
--      CLOSE c_gkrq;
--   END IF;
--   IF c_gksd%ISOPEN THEN
--      CLOSE c_gksd;
--   END IF;
--   IF c_gksc%ISOPEN THEN
--      CLOSE c_gksc;
--   END IF;
--   IF c_gkme%ISOPEN THEN
--      CLOSE c_gkme;
--   END IF;
--   IF c_gkws%ISOPEN THEN
--      CLOSE c_gkws;
--   END IF;
--   IF c_gkrt%ISOPEN THEN
--      CLOSE c_gkrt;
--   END IF;
--   IF c_gkst%ISOPEN THEN
--      CLOSE c_gkst;
--   END IF;
--   IF c_gkpt%ISOPEN THEN
--      CLOSE c_gkpt;
--   END IF;
   IF c_rtst%ISOPEN THEN
      CLOSE c_rtst;
   END IF;
   IF c_strt%ISOPEN THEN
      CLOSE c_strt;
   END IF;
   IF c_ptst%ISOPEN THEN
      CLOSE c_ptst;
   END IF;
   --restore original time-out for in-transition objects
   UNAPIEV.P_RETRIESWHENINTRANSITION  := l_tmp_retrieswhenintransition;
   UNAPIEV.P_INTERVALWHENINTRANSITION := l_tmp_intervalwhenintransition;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END SaveObjectGroupKey;

FUNCTION AssignGroupKey
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2,                  /* VC20_TYPE */
 a_value           IN     VARCHAR2)                  /* VC40_TYPE */
RETURN NUMBER IS

BEGIN
   l_sqlerrm := NULL;

   -- Max length of a groupkey value is 40 characters
   l_ret_code := AssignGroupKey(a_gk_tp, a_gk, a_value, 1, 40);
   IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
      RETURN(UNAPIGEN.DBERR_TRANSITION);
   ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      l_sqlerrm := 'gk_tp='||a_gk_tp||
                   '#gk='||a_gk||
                   '#value='||a_value||
                   '#start_pos=1#length=40#AssignGroupKey#errorcode='||l_ret_code;
      RAISE StpError;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   TraceError(ics_package_name || '.AssignGroupKey', l_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END AssignGroupKey;

FUNCTION AssignGroupKey
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2,                  /* VC20_TYPE */
 a_value           IN     VARCHAR2,                  /* VC40_TYPE */
 a_start_pos       IN     NUMBER,                    /* NUM_TYPE */
 a_length          IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER IS

l_value_s                     VARCHAR2(2000);
--l_value_f                     NUMBER;
--l_value_d                     TIMESTAMP WITH TIME ZONE;

BEGIN
   l_sqlerrm := NULL;

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   -- check if we are expected to do tilde substitution
   IF INSTR(a_value,'~') <> 0 THEN
      -- tilde substitution
      l_value_s := a_value;
      l_ret_code := UNAPIGEN.SubstituteAllTildesInText
                                (UNAPIEV.P_EV_REC.OBJECT_TP,
                                 '~EV_REC~',
                                 l_value_s);
      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
         l_sqlerrm := 'obj_tp='||UNAPIEV.P_EV_REC.OBJECT_TP||
                      '#obj_key=~EV_REC~'||
                      '#asked_value='||a_value||
                      '#SubstituteAllTildesInText#errorcode='||l_ret_code;
         RAISE StpError;
      END IF;
   ELSE
      l_value_s := a_value;
   END IF;

   --Evaluate the expression when expression starts with an equal sign
   --Apply default conversion when the first sign is =
   --Will allow assignments like =TO_CHAR(CURRENT_TIMESTAMP,'DD/MM/YYYY')
   --May be combined with tilde substitution eventually
   IF SUBSTR(a_value, 1, 1) = '=' THEN
      BEGIN
         EXECUTE IMMEDIATE 'DECLARE l_result VARCHAR2(40); BEGIN :l_result :'||l_value_s||'; END;'
         USING OUT l_value_s;
      EXCEPTION
      WHEN OTHERS THEN
         l_sqlerrm := SUBSTR( 'Expression evaluation and conversion to VARCHAR2 failed for '||
                              l_value_s||
                              '#gk_tp='||a_gk_tp||
                              '#gk='||a_gk||
                              '#modify_flag='||UNAPIGEN.MOD_FLAG_INSERT||
                              '#SaveObjectGroupKey#errorcode='||SUBSTR(SQLERRM,1,100)
                             ,1, 200);
         RAISE StpError;
      END;
   END IF;

   -- get the requested part of the value
   l_value_s := SUBSTR(l_value_s, a_start_pos, a_length);

   -- save groupkey
   l_ret_code := SaveObjectGroupKey(a_gk_tp, a_gk, SUBSTR(l_value_s,1,40),
                                             UNAPIGEN.MOD_FLAG_INSERT);
   IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
      RETURN(UNAPIGEN.DBERR_TRANSITION);
   ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      l_sqlerrm := 'gk_tp='||a_gk_tp||
                   '#gk='||a_gk||
                   '#value='||SUBSTR(l_value_s,1,40)||
                   '#modify_flag='||UNAPIGEN.MOD_FLAG_INSERT||
                   '#SaveObjectGroupKey#errorcode='||l_ret_code;
      RAISE StpError;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   TraceError(ics_package_name || '.AssignGroupKey', l_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END AssignGroupKey;

FUNCTION DeAssignGroupKey
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER IS

BEGIN
   l_sqlerrm := NULL;

   ---------------------------------------------------------------------------------------------
   -- !!!
   -- It is a good practice to check if the event matches '%GroupKeyUpdated' when an action will
   -- be used in an event rule. It enables us to avoid loops in event rules.
   -- !!!
   ---------------------------------------------------------------------------------------------
   IF UNAPIEV.P_EV_REC.ev_tp LIKE '%GroupKeyUpdated' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;

   -- save groupkey
   l_ret_code := SaveObjectGroupKey(a_gk_tp, a_gk, '', UNAPIGEN.MOD_FLAG_DELETE);
   IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
      RETURN(UNAPIGEN.DBERR_TRANSITION);
   ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      l_sqlerrm := 'gk_tp='||a_gk_tp||
                   '#gk='||a_gk||
                   '#value=#modify_flag='||UNAPIGEN.MOD_FLAG_DELETE||
                   '#SaveObjectGroupKey#errorcode='||l_ret_code;
      RAISE StpError;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   TraceError(ics_package_name || '.DeAssignGroupKey', l_sqlerrm);
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END DeAssignGroupKey;

FUNCTION InitGroupKeyFromAttribute
(a_gk_tp           IN     VARCHAR2,                  /* VC4_TYPE */
 a_gk              IN     VARCHAR2,                  /* VC20_TYPE */
 a_object_tp       IN     VARCHAR2,                  /* VC4_TYPE */
 a_object_id       IN     VARCHAR2,                  /* VC20_TYPE */
 a_object_version  IN     VARCHAR2,                  /* VC20_TYPE */
 a_au              IN     VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER IS

l_value                       VARCHAR2(40);
l_au_cursor                   INTEGER;

BEGIN
   l_sqlerrm := NULL;

   -- get the value of the given object attribute
   l_sql_string := 'SELECT value FROM dd'||UNAPIGEN.P_DD||'.uv'||a_object_tp||'au WHERE '||
                   a_object_tp||' = '''||a_object_id||
                   ''' AND version = '''||a_object_version||
                   ''' AND au = '''||a_au||
                   ''' ORDER BY auseq';

   IF NOT DBMS_SQL.IS_OPEN(l_au_cursor) THEN
      l_au_cursor := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE(l_au_cursor, l_sql_string, DBMS_SQL.V7);
      DBMS_SQL.DEFINE_COLUMN(l_au_cursor, 1, l_value, 40);
      l_result := DBMS_SQL.EXECUTE(l_au_cursor);
   END IF;
   l_result := DBMS_SQL.FETCH_ROWS(l_au_cursor);
   DBMS_SQL.COLUMN_VALUE(l_au_cursor, 1, l_value);
   DBMS_SQL.CLOSE_CURSOR(l_au_cursor);

   IF l_result = 0 THEN
      l_sqlerrm := UNAPIGEN.DBERR_NORECORDS;
      RAISE StpError;
   END IF;

   -- assign groupkey
   l_ret_code := AssignGroupKey(a_gk_tp, a_gk, l_value, 1, 40);
   IF l_ret_code = UNAPIGEN.DBERR_TRANSITION THEN
      RETURN(UNAPIGEN.DBERR_TRANSITION);
   ELSIF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      l_sqlerrm := 'gk_tp='||a_gk_tp||
                   '#gk='||a_gk||
                   '#value='||l_value||
                   '#start_pos=1#length=40#AssignGroupKey#errorcode='||l_ret_code;
      RAISE StpError;
   END IF;

   RETURN(UNAPIGEN.DBERR_SUCCESS);

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE <> 1 THEN
      l_sqlerrm := SUBSTR(SQLERRM,1,255);
   END IF;
   TraceError(ics_package_name || '.InitGroupKeyFromAttribute', l_sqlerrm);
   IF DBMS_SQL.IS_OPEN (l_au_cursor) THEN
      DBMS_SQL.CLOSE_CURSOR (l_au_cursor);
   END IF;
   RETURN(UNAPIGEN.DBERR_GENFAIL);
END InitGroupKeyFromAttribute;

FUNCTION LogTransition
RETURN NUMBER
AS
    INTEGRITY_CONSTRAINT EXCEPTION;
    PRAGMA EXCEPTION_INIT(INTEGRITY_CONSTRAINT, -2291);
    lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'LogTransition';

    lvs_real_time VARCHAR2(40);
    lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
    CURSOR lvq_me IS
        SELECT sc, pg, pgnode, pa, panode, me, menode, reanalysis, value_f, value_s, unit,
               format, exec_end_date, executor, lab, eq, eq_version, manually_entered, real_cost
          FROM utscme
          WHERE sc = unapiev.p_sc
            AND pg = unapiev.p_pg AND pgnode = unapiev.p_pgnode
            AND pa = unapiev.p_pa AND panode = unapiev.p_panode
            AND me = unapiev.p_me AND menode = unapiev.p_menode
            AND reanalysis = unapiev.p_reanalysis;
 -- Specific local variables
 -- Specific local variables
  l_nr_of_rows                NUMBER;
  l_where_clause              VARCHAR2(511);
  l_alarms_handled            CHAR(1);
  l_modify_reason             VARCHAR2(255);

  l_sc_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_pg_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_pgnode_tab                UNAPIGEN.LONG_TABLE_TYPE;
  l_pa_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_panode_tab                UNAPIGEN.LONG_TABLE_TYPE;
  l_me_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_menode_tab                UNAPIGEN.LONG_TABLE_TYPE;
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
  l_allow_modify_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
  l_ar_tab                    UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_active_tab                UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_lc_tab                    UNAPIGEN.VC2_TABLE_TYPE;
  l_lc_version_tab            UNAPIGEN.VC20_TABLE_TYPE;
  l_ss_tab                    UNAPIGEN.VC2_TABLE_TYPE;
  l_reanalysedresult_tab      UNAPIGEN.CHAR1_TABLE_TYPE;
  l_modify_flag_tab           UNAPIGEN.NUM_TABLE_TYPE;

BEGIN
    CASE unapiev.p_ev_rec.object_tp
        WHEN 'ws' THEN
            INSERT INTO atwstrhs (ws, ss_from, ss_to, tr_on, tr_on_tz, tr_seq, ev_seq
            ) VALUES (
                unapiev.p_ws,
                unapiev.p_ss_from,
                unapiev.p_ev_rec.object_ss,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP,
                unapigen.p_tr_seq,
                unapiev.p_ev_rec.ev_seq
            );
        WHEN 'rq' THEN
            INSERT INTO atrqtrhs (rq, ss_from, ss_to, tr_on, tr_on_tz, tr_seq, ev_seq
            ) VALUES (
                unapiev.p_rq,
                unapiev.p_ss_from,
                unapiev.p_ev_rec.object_ss,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP,
                unapigen.p_tr_seq,
                unapiev.p_ev_rec.ev_seq
            );
        WHEN 'sc' THEN
            INSERT INTO atsctrhs (sc, ss_from, ss_to, tr_on, tr_on_tz, tr_seq, ev_seq
            ) VALUES (
                unapiev.p_sc,
                unapiev.p_ss_from,
                unapiev.p_ev_rec.object_ss,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP,
                unapigen.p_tr_seq,
                unapiev.p_ev_rec.ev_seq
            );
        WHEN 'pg' THEN
            INSERT INTO atpgtrhs (sc, pg, pgnode, ss_from, ss_to, tr_on, tr_on_tz, tr_seq, ev_seq
            ) VALUES (
                unapiev.p_sc,
                unapiev.p_pg,
                unapiev.p_pgnode,
                unapiev.p_ss_from,
                unapiev.p_ev_rec.object_ss,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP,
                unapigen.p_tr_seq,
                unapiev.p_ev_rec.ev_seq
            );
        WHEN 'pa' THEN
            INSERT INTO atpatrhs (sc, pg, pgnode, pa, panode, ss_from, ss_to, tr_on, tr_on_tz, tr_seq, ev_seq
            ) VALUES (
                unapiev.p_sc,
                unapiev.p_pg,
                unapiev.p_pgnode,
                unapiev.p_pa,
                unapiev.p_panode,
                unapiev.p_ss_from,
                unapiev.p_ev_rec.object_ss,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP,
                unapigen.p_tr_seq,
                unapiev.p_ev_rec.ev_seq
            );
        WHEN 'me' THEN
            INSERT INTO atmetrhs (sc, pg, pgnode, pa, panode, me, menode, ss_from, ss_to, tr_on, tr_on_tz, tr_seq, ev_seq
            ) VALUES (
                unapiev.p_sc,
                unapiev.p_pg,
                unapiev.p_pgnode,
                unapiev.p_pa,
                unapiev.p_panode,
                unapiev.p_me,
                unapiev.p_menode,
                unapiev.p_ss_from,
                unapiev.p_ev_rec.object_ss,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP,
                unapigen.p_tr_seq,
                unapiev.p_ev_rec.ev_seq
            );
        WHEN 'rqic' THEN
            INSERT INTO atrqictrhs (rq, ic, icnode, ss_from, ss_to, tr_on, tr_on_tz, tr_seq, ev_seq
            ) VALUES (
                unapiev.p_rq,
                unapiev.p_ic,
                unapiev.p_icnode,
                unapiev.p_ss_from,
                unapiev.p_ev_rec.object_ss,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP,
                unapigen.p_tr_seq,
                unapiev.p_ev_rec.ev_seq
            );
        WHEN 'ic' THEN
            INSERT INTO atictrhs (sc, ic, icnode, ss_from, ss_to, tr_on, tr_on_tz, tr_seq, ev_seq
            ) VALUES (
                unapiev.p_sc,
                unapiev.p_ic,
                unapiev.p_icnode,
                unapiev.p_ss_from,
                unapiev.p_ev_rec.object_ss,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP,
                unapigen.p_tr_seq,
                unapiev.p_ev_rec.ev_seq
            );
        ELSE
            INSERT INTO atobjecttrhs (object_tp, object_id, ss_from, ss_to, tr_on, tr_on_tz, tr_seq, ev_seq
            ) VALUES (
                unapiev.p_ev_rec.object_tp,
                unapiev.p_ev_rec.object_id,
                unapiev.p_ss_from,
                unapiev.p_ev_rec.object_ss,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP,
                unapigen.p_tr_seq,
                unapiev.p_ev_rec.ev_seq
            );
    END CASE;
    -- I1504-067-Update-of-the-Real-time-field-of-a-method
    IF (unapiev.p_ev_rec.object_tp = 'me') THEN
        --APAOFUNCTIONS.LogInfo (lcs_function_name, 'sc: ' || unapiev.p_sc || ', object_tp: '|| unapiev.p_ev_rec.object_tp || ', ss_from: '
        --||  unapiev.p_ss_from || ', ss_to: ' || unapiev.p_ss_to);
        IF (unapiev.p_ss_from = 'IE' AND unapiev.p_ev_rec.object_ss = 'CM') THEN
            -- if IE -> CM, then we have to calculate the real_time
            -- expressed in hour 'parts'/uur delen, for example:
            -- Vb.
            -- 0.6 betekent 0.6 x 1 uur (= 60 minuten) = 36 minuten
            -- 168 betekent 168 x 1 uur = 168 uur of 10.080 minuten
            lvs_real_time := NULL;
            BEGIN
              SELECT ROUND(ROUND((CAST(CURRENT_TIMESTAMP as DATE) - CAST(MAX(tr_on) as DATE)) * 1440) / 60, 20)
                INTO lvs_real_time
                FROM atmetrhs
                WHERE sc = unapiev.p_sc
                AND pg = unapiev.p_pg AND pgnode = unapiev.p_pgnode
                AND pa = unapiev.p_pa   AND panode = unapiev.p_panode
                AND me = unapiev.p_me   AND menode = unapiev.p_menode
                AND ss_to = 'IE' ;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NULL;
            END;

            --APAOGEN.LogError (lcs_function_name, 'sc: ' || unapiev.p_sc || ', ss_to: ' || unapiev.p_ss_to || ', lvs_real: ' || lvs_real_time);
            IF (lvs_real_time IS NOT NULL) THEN
              -- IN and IN OUT arguments
              l_alarms_handled := '1';
              l_modify_reason  := lcs_function_name || ', calc real_time';
              l_nr_of_rows     := 1;
               -- IN and IN OUT arguments
              l_where_clause   := 'WHERE sc = ''' || unapiev.p_sc                         || '''' ||
                                   ' AND pg = ''' || REPLACE (unapiev.p_pg, '''', '''''') || ''' AND pgnode = '|| unapiev.p_pgnode ||
                                   ' AND pa = ''' || REPLACE (unapiev.p_pa, '''', '''''') || ''' AND panode = '|| unapiev.p_panode ||
                                   ' AND me = ''' || REPLACE (unapiev.p_me, '''', '''''') || ''' AND menode = '|| unapiev.p_menode;
              l_nr_of_rows     := NULL;

              l_ret_code       := UNAPIME.GETSCMETHOD
                               (l_sc_tab,
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
                                l_allow_modify_tab,
                                l_ar_tab,
                                l_active_tab,
                                l_lc_tab,
                                l_lc_version_tab,
                                l_ss_tab,
                                l_reanalysedresult_tab,
                                l_nr_of_rows,
                                l_where_clause);
                IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
                  lvs_sqlerrm := 'GETSCMETHOD failed. Returncode <' || l_ret_code || '>';
                   APAOGEN.LogError (lcs_function_name, SQLERRM);
    ELSE
      FOR l_row IN 1..l_nr_of_rows LOOP
        --APAOGEN.LogError (lcs_function_name, 'sc: ' || l_sc_tab(l_row) || ', in loop');
      l_real_time_tab(l_row)     := lvs_real_time;
      l_modify_flag_tab(l_row)     := UNAPIGEN.MOD_FLAG_UPDATE;
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

       IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
       lvs_sqlerrm := 'SAVESCMETHOD failed. Returncode <' || l_ret_code || '>';
      APAOGEN.LogError (lcs_function_name, SQLERRM);
       END IF;

                END IF;
            END IF;
        END IF;
    END IF;
    RETURN unapigen.DBERR_SUCCESS;
EXCEPTION
WHEN INTEGRITY_CONSTRAINT THEN
    --Don't log when no parent key exists.
    RETURN unapigen.DBERR_SUCCESS;
WHEN OTHERS THEN
    IF SQLCODE <> 1 THEN
        APAOGEN.LogError('LogTransition', SQLERRM);
    END IF;
    RETURN SQLCODE;
END;

FUNCTION SetExecEndDate(
    a_value IN TIMESTAMP DEFAULT SYSTIMESTAMP
)
RETURN NUMBER
AS
BEGIN
    CASE unapiev.p_ev_rec.object_tp
        WHEN 'sc' THEN
            UPDATE utsc SET exec_end_date = a_value
            WHERE sc = unapiev.p_sc
            AND (a_value IS NULL OR exec_end_date IS NULL)
            AND NOT (a_value IS NULL AND exec_end_date IS NULL);
        ELSE
            NULL;
    END CASE;
    RETURN unapigen.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
    IF SQLCODE <> 1 THEN
        APAOGEN.LogError('SetExecEndDate', SQLERRM);
    END IF;
    RETURN SQLCODE;
END;

FUNCTION GetVersion 
  RETURN VARCHAR2 
IS 
BEGIN 
  RETURN('06.07.00.00_13.00'); 
EXCEPTION 
  WHEN OTHERS THEN 
  RETURN (NULL); 
END GetVersion; 


END UNACTION;
/
