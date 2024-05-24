---------------------------------------------------------------------------
-- $Workfile: PA_LIMSCfg.sql $
--      Type: Package Body
--   $Author: Fe $
--            COMPEX N.V.
----------------------------------------------------------------------------
--  Abstract: Functions and procedures for the interface between Interspec 
--            and Unilab.
--
--            REMARK 1: Do not use 'SELECT *' to select from an Unilab table, 
--            but always specify the column names. If they are not specified,
--            errors can occur when the column order of a table differs on
--            the Unilab databases.
--
--            REMARK 2: Do not directly use an Unilab api in a 'SELECT'- or 
--            'WHERE'-clause of a query in an Interspec package. If the packages
--            have public synonyms, and if the link connects to another Unilab
--            database as before the re-creation, this kind of Unilab api call
--            invalidates the Interspec packages.
--            The only mechanism that does not invalidate the packages, is to
--            create an Unilab view that uses the Unilab api.  
--
--            REMARK 3: Do not select from Unilab tables, but from Unilab views.
--            This is necessary since every user can be used in the 
--            database link.
--
--            REMARK 4: When both databases are unicode (CHARACTER_SET = AL32UTF8, 
--            NLS_LENGTH_SEMANTICS = CHAR), then watch out with selecting data of
--            datatype CHAR through the link. A column of type CHAR(1) at Unilab
--            side, becomes CHAR(4) at Interspec side. You have to SUBSTR
--            explicitely before assigning the value to a local variable.
--            For more info, cfr. Oracle bugs 2928548, and 2749304.
--            E.g. the selects from uvpppr_pr_specx, uvstpp_pp_specx.
--            Bugs 3924838 and 3250027 are also related to that problem
----------------------------------------------------------------------------
-- Functions:
-- 1.  f_TransferCfgAu
-- 2.  f_TransferCfgPr
-- 3.  f_TransferCfgAllPr
-- 4.  f_TransferCfgMt
-- 5.  f_TransferCfgAllMt
-- 6.  f_TransferCfgPrMt
-- 7.  f_TransferCfgAllPrMt
-- 8.  f_TransferCfgGkSt
-- 9.  f_TransferCfgAllGkSt
-- 10. f_TransferCfg
-- 11. f_TransferAllCfg
-- 12. f_TransferAllCfgInternal
-- 13. f_GetIUIVersion
----------------------------------------------------------------------------
-- Versions:
-- speCX ver  Date         Author          Description
-- ---------  -----------  --------------  ---------------------------------
-- 2.2.1      10/07/2001   CL              Bug: A parameter in Unilab that
--                                         consist of a property +
--                                         an attribute in speCX, will
--                                         not be updated if the description
--                                         of the attribute of property
--                                         changes in speCX
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.3.0      15/07/2001   CL              New release
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.3.0      15/07/2001   CL              Release 2.3.0
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.3.1     ....
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 5.0        20/08/2003   RF              Release 5.0
--                                         Since Unilab 5.0 SP2 can handle versions,
--                                         effective_dates, and multiple plants, a new design has been
--                                         made ("RFD0309021-DS DB API Interspec-Unilab interface.doc"
--                                         in the Unilab 5.0 SP2 URS folder). Please check this
--                                         design for more detailed information of the modifications.
----------------------------------------------------------------------------



CREATE OR REPLACE PACKAGE BODY 
----------------------------------------------------------------------------
-- $Revision: 3 $
--  $Modtime: 26/04/10 16:42 $
----------------------------------------------------------------------------
PA_LIMSCFG IS

   -- Global variable contains the flag if all plants that have the same connection string 
   -- and language id as the given plant have to be handled at once or not
   g_handle_similar       BOOLEAN DEFAULT FALSE;

   -- Global arrays contain the parameters that have been transferred effectively to Unilab, 
   -- to be able to change their status afterwards
   g_pr_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
   g_version_tab          UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
   g_pr_nr_of_rows        NUMBER;

   FUNCTION f_GetIUIVersion
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the version of the Interspec-Unilab interface
      -- ** Return **
      -- The version of the Interspec-Unilab interface
      ------------------------------------------------------------------------------
      -- General variables
   BEGIN
      RETURN('06.04.00.00_00.00');
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unable to get the version of the Interspec-Unilab interface : '||SQLERRM);
         RETURN (NULL);
   END f_GetIUIVersion;

   FUNCTION f_GetObjectVersion(
      a_tp IN VARCHAR2,
      a_id IN VARCHAR2
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the highest existing major version of the given object
      -- ** Return **
      -- The highest existing major version of the given object
      ------------------------------------------------------------------------------
      -- General variables
      l_ret_code  INTEGER;
      l_object    VARCHAR2(255);
      l_version   VARCHAR2(20);
   BEGIN
      l_object := a_tp||' "'||a_id||'"';

      -- Get the version
      l_ret_code := UNVERSION.GETHIGHESTMAJORVERSION@LNK_LIMS(a_tp,a_id, l_version);
      IF l_version IS NULL OR 
         INSTR(l_version, '.')=0 THEN --no dot in version string
         -- First time the object is transferred to Unilab
         l_ret_code := UNVERSION.GETNEXTMAJORVERSION@LNK_LIMS(l_version);
      ELSE
         -- Get the lowest minor version of this major version
         l_version := SUBSTR(l_version, 1, INSTR(l_version,'.')-1) ||
                      '.'||
                      SUBSTR(UNVERSION.SQLGETNEXTMAJORVERSION@LNK_LIMS(l_version), 
                             INSTR(UNVERSION.SQLGETNEXTMAJORVERSION@LNK_LIMS(l_version),'.') +1);
      END IF;
      RETURN(l_version);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unable to get the version of '||l_object||' : '||SQLERRM);
         RETURN (NULL);
   END f_GetObjectVersion;

   FUNCTION f_TransferCfgAu(
      a_Au         IN VARCHAR2,
      a_version    IN VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer an attribute from Interspec to Unilab.
      -- ** Parameters **
      -- a_au      : attribute to transfer
      -- a_version : version of the attribute
      -- ** Return **
      -- TRUE: The transfer of the attribute has succeeded.
      -- FALSE : The transfer of the attribute has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsCfg';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferCfgAu';
      l_object       VARCHAR2(255);

      -- Specific local variables for the 'GetAttribute' API
      l_return_value_get       NUMBER;
      l_nr_of_rows             NUMBER                           := 999;
      l_where_clause           VARCHAR2(255);
      l_au_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_is_current_tab UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_effective_from_tab     UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_effective_till_tab     UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_description_tab        UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description2_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_is_protected_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_single_valued_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_new_val_allowed_tab    UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_store_db_tab           UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_shortcut_tab           UNAPIGEN.RAW8_TABLE_TYPE@LNK_LIMS;
      l_value_list_tp_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_default_value_tab      UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_run_mode_tab           UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_service_tab            UNAPIGEN.VC255_TABLE_TYPE@LNK_LIMS;
      l_cf_value_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_au_class_tab           UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_log_hs_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_allow_modify_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_active_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_lc_tab                 UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_lc_version_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_ss_tab                 UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'SaveAttribute' API
      l_return_value_save     NUMBER;
      l_au                    VARCHAR2(20);
      l_version               VARCHAR2(20);
      l_version_is_current    CHAR(1);
      l_effective_from        DATE;
      l_effective_till        DATE;
      l_description           VARCHAR2(40);
      l_description2          VARCHAR2(40);
      l_is_protected          CHAR(1);
      l_single_valued         CHAR(1);
      l_new_val_allowed       CHAR(1);
      l_store_db              CHAR(1);
      l_inherit_au            CHAR(1);
      l_shortcut              RAW(8);
      l_value_list_tp         CHAR(1);
      l_default_value         VARCHAR2(40);
      l_run_mode              CHAR(1);
      l_service               VARCHAR2(255);
      l_cf_value              VARCHAR2(20);
      l_au_class              VARCHAR2(2);
      l_log_hs                CHAR(1);
      l_lc                    VARCHAR2(2);
      l_lc_version            VARCHAR2(20);
      l_modify_reason         VARCHAR2(255);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Au||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'attribute "'||a_Au||'" | version='||a_version;

      -- Fill in the parameters to get the standard attributes of the attribute
      l_where_clause := 'WHERE au='''||REPLACE(a_au,'''','''''')||''' AND version = '''||
                        a_version||''' ORDER BY au, version';
      -- Get the standard attributes of the attribute
      l_return_value_get := UNAPIAU.GETATTRIBUTE@LNK_LIMS(l_au_tab, l_version_tab, l_version_is_current_tab, 
                               l_effective_from_tab, l_effective_till_tab, l_description_tab, l_description2_tab, 
                               l_is_protected_tab, l_single_valued_tab, l_new_val_allowed_tab, l_store_db_tab, 
                               l_inherit_au_tab, l_shortcut_tab, l_value_list_tp_tab, l_default_value_tab, 
                               l_run_mode_tab, l_service_tab, l_cf_value_tab, l_au_class_tab, l_log_hs_tab,
                               l_allow_modify_tab, l_active_tab, l_lc_tab, l_lc_version_tab, l_ss_tab, 
                               l_nr_of_rows, l_where_clause);
      -- Check if the attribute exists in Unilab.  If the attribute is not found,
      -- then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- Fill in the parameters to save the standard attributes of the attribute
         l_au                 := a_Au;
         l_version            := a_version;
         l_version_is_current := NULL;
         l_effective_from     := NULL;
         l_effective_till     := NULL;
         l_modify_reason      := 'Imported attribute "'||a_Au||'" from Interspec.';
         l_description        := a_Au;
         l_description2       := '';
         l_is_protected       := '0';
         l_single_valued      := '0';
         l_new_val_allowed    := '1';
         l_store_db           := '0';
         l_inherit_au         := '1';
         l_shortcut           := NULL;
         l_value_list_tp      := 'F';
         l_default_value      := '';
         l_run_mode           := 'N';
         l_service            := '';
         l_cf_value           := '';
         l_au_class           := '';
         l_log_hs             := '1';
         -- take default lc
         BEGIN
            SELECT uvobjects.def_lc, uvlc.version
            INTO l_lc, l_lc_version
            FROM UVOBJECTS@LNK_LIMS, UVLC@LNK_LIMS
            WHERE uvobjects.object = 'au'
            AND   uvobjects.def_lc = uvlc.lc
            AND   uvlc.version_is_current = '1';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            -- Log an error to ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'No current version found for the default attribute lifecycle.');
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END;
         BEGIN
            -- Save the standard attributes of the attribute
            l_return_value_save :=
                  UNAPIAU.SAVEATTRIBUTE@LNK_LIMS(l_au, l_version, l_version_is_current, l_effective_from,
                     l_effective_till, l_description, l_description2, l_is_protected, l_single_valued, 
                     l_new_val_allowed, l_store_db, l_inherit_au, l_shortcut, l_value_list_tp, l_default_value,
                     l_run_mode, l_service, l_cf_value, l_au_class, l_log_hs, l_lc, l_lc_version, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged,
            -- otherwise the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save '||l_object||' (General failure! Error Code: '||l_return_value_save||
                                ' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save '||l_object||' (Error code : '||l_return_value_save||').');
               END IF;

               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to save '||l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_object||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferCfgAu;

   FUNCTION f_TransferCfgPr(
      a_pr                    IN     VARCHAR2,
      a_version               IN OUT VARCHAR2,
      a_description           IN     VARCHAR2,
      a_template              IN     VARCHAR2,
      a_property              IN     VARCHAR2,
      a_newminor              IN     CHAR,
      a_property_is_historic  IN     NUMBER
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer a parameter definition from Interspec to Unilab.
      -- ** Parameters **
      -- a_pr          : parameter definition to transfer
      -- a_version     : version of the parameter definition
      -- a_description : description of the parameter definition
      -- a_template    : template for the parameter definition
      -- a_property    : property from which the parameter definition has been derived
      -- a_newminor    : flag indicating if a new minor version has to be created to save modified used objects
      -- ** Return **
      -- TRUE: The transfer of the parameter definition has succeeded.
      -- FALSE : The transfer of the parameter definition has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname     CONSTANT VARCHAR2(12)                      := 'LimsCfg';
      l_method        CONSTANT VARCHAR2(32)                      := 'f_TransferCfgPr';
      l_object        VARCHAR2(255);

      -- General Variables
      l_a_Template             VARCHAR2(20);
      l_a_Template_version     VARCHAR2(20);
      l_a_description          VARCHAR2(40);
      l_au_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab              UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'GetParameter' API
      l_return_value_get_tmp   INTEGER;
      l_return_value_get       INTEGER;
      l_nr_of_rows             NUMBER                            := 999;
      l_where_clause           VARCHAR2(255);
      l_pr_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_is_current_tab UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_effective_from_tab     UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_effective_till_tab     UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_description_tab        UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description2_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_unit_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_format_tab             UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_td_info_tab            UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_td_info_unit_tab       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_confirm_uid_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_def_val_tp_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_def_au_level_tab       UNAPIGEN.VC4_TABLE_TYPE@LNK_LIMS;
      l_def_val_tab            UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_allow_any_mt_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_delay_tab              UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_delay_unit_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_min_nr_results_tab     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_calc_method_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_calc_cf_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_alarm_order_tab        UNAPIGEN.VC3_TABLE_TYPE@LNK_LIMS;
      l_seta_specs_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_seta_limits_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_seta_target_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_setb_specs_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_setb_limits_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_setb_target_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_setc_specs_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_setc_limits_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_setc_target_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_is_template_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_log_exceptions_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_sc_lc_tab              UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_sc_lc_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_pr_class_tab           UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_log_hs_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_allow_modify_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_active_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_lc_tab                 UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_lc_version_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_ss_tab                 UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'CopyParameter' API
      l_return_value_copy       INTEGER;
      l_return_value_deleteprmt BOOLEAN;

      -- Specific local variables for the 'SaveParameter' API
      l_return_value_save      INTEGER;
      l_pr                     VARCHAR2(20);
      l_version                VARCHAR2(20);
      l_version_is_current     CHAR(1);
      l_effective_from         DATE;
      l_effective_till         DATE;
      l_description            VARCHAR2(40);
      l_description2           VARCHAR2(40);
      l_unit                   VARCHAR2(20);
      l_format                 VARCHAR2(40);
      l_td_info                NUMBER;
      l_td_info_unit           VARCHAR2(20);
      l_confirm_uid            CHAR(1);
      l_def_val_tp             CHAR(1);
      l_def_au_level           VARCHAR2(4);
      l_def_val                VARCHAR2(40);
      l_allow_any_mt           CHAR(1);
      l_delay                  NUMBER;
      l_delay_unit             VARCHAR2(20);
      l_min_nr_results         NUMBER;
      l_calc_method            CHAR(1);
      l_calc_cf                VARCHAR2(20);
      l_alarm_order            VARCHAR2(3);
      l_seta_specs             VARCHAR2(20);
      l_seta_limits            VARCHAR2(20);
      l_seta_target            VARCHAR2(20);
      l_setb_specs             VARCHAR2(20);
      l_setb_limits            VARCHAR2(20);
      l_setb_target            VARCHAR2(20);
      l_setc_specs             VARCHAR2(20);
      l_setc_limits            VARCHAR2(20);
      l_setc_target            VARCHAR2(20);
      l_is_template            CHAR(1);
      l_log_exceptions         CHAR(1);
      l_sc_lc                  VARCHAR2(2);
      l_sc_lc_version          VARCHAR2(20);
      l_inherit_au             CHAR(1);
      l_pr_class               VARCHAR2(2);
      l_log_hs                 CHAR(1);
      l_lc                     VARCHAR2(2)        DEFAULT NULL;
      l_lc_version             VARCHAR2(20)       DEFAULT NULL;
      l_modify_reason          VARCHAR2(255);

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_pr_lc                  VARCHAR2(2);
      l_pr_lc_version          VARCHAR2(20);
      l_pr_ss                  VARCHAR2(2);
      l_pr_log_hs              CHAR(1);
      l_pr_allow_modify        CHAR(1);
      l_pr_active              CHAR(1);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_pr||' | '||a_version, a_description, 
                      a_template||' | '||a_property||' | '||a_newminor, PA_LIMS.c_Msg_Started);
      -- Convert the arguments to their maximum length
      l_a_description := SUBSTR(a_description, 1, 40);
      l_a_Template := a_Template;
      -- Initializing variables
      l_object := 'parameter "'||a_pr||'" | version='||a_version||' | description="'||l_a_description||'"';

      -- Fill in the parameters to get the standard attributes of the parameter definition
      l_where_clause := 'WHERE pr='''||REPLACE(a_pr,'''','''''')||''' AND version = '''||
                        a_version||''' ORDER BY pr, version';
      -- Get the standard attributes of the parameter definition
      l_return_value_get := UNAPIPR.GETPARAMETER@LNK_LIMS(l_pr_tab, l_version_tab, l_version_is_current_tab,
                               l_effective_from_tab, l_effective_till_tab, l_description_tab, l_description2_tab,
                               l_unit_tab, l_format_tab, l_td_info_tab, l_td_info_unit_tab, l_confirm_uid_tab,
                               l_def_val_tp_tab, l_def_au_level_tab, l_def_val_tab, l_allow_any_mt_tab, l_delay_tab,
                               l_delay_unit_tab, l_min_nr_results_tab, l_calc_method_tab, l_calc_cf_tab, 
                               l_alarm_order_tab, l_seta_specs_tab, l_seta_limits_tab, l_seta_target_tab,
                               l_setb_specs_tab, l_setb_limits_tab, l_setb_target_tab, l_setc_specs_tab,
                               l_setc_limits_tab, l_setc_target_tab, l_is_template_tab, l_log_exceptions_tab,
                               l_sc_lc_tab, l_sc_lc_version_tab, l_inherit_au_tab, l_pr_class_tab, l_log_hs_tab,
                               l_allow_modify_tab, l_active_tab, l_lc_tab, l_lc_version_tab, l_ss_tab, l_nr_of_rows,
                               l_where_clause);
      -- Check if the parameter definition exists in Unilab.
      -- If the parameter definition is not found then it must be created.
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- Check if the parameter definition must be based on a template
         IF NOT l_a_Template IS NULL THEN
            -- Fill in the parameters to get the standard attributes of the parameter definition template
            l_where_clause := l_a_Template;
            -- Get the standard attributes of the parameter definition template
            l_return_value_get_tmp := UNAPIPR.GETPARAMETER@LNK_LIMS(l_pr_tab, l_version_tab, l_version_is_current_tab,
                                         l_effective_from_tab, l_effective_till_tab, l_description_tab, 
                                         l_description2_tab, l_unit_tab, l_format_tab, l_td_info_tab, 
                                         l_td_info_unit_tab, l_confirm_uid_tab, l_def_val_tp_tab, l_def_au_level_tab,
                                         l_def_val_tab, l_allow_any_mt_tab, l_delay_tab, l_delay_unit_tab,
                                         l_min_nr_results_tab, l_calc_method_tab, l_calc_cf_tab, l_alarm_order_tab,
                                         l_seta_specs_tab, l_seta_limits_tab, l_seta_target_tab, l_setb_specs_tab,
                                         l_setb_limits_tab, l_setb_target_tab, l_setc_specs_tab, l_setc_limits_tab,
                                         l_setc_target_tab, l_is_template_tab, l_log_exceptions_tab, l_sc_lc_tab,
                                         l_sc_lc_version_tab, l_inherit_au_tab, l_pr_class_tab, l_log_hs_tab,
                                         l_allow_modify_tab, l_active_tab, l_lc_tab, l_lc_version_tab, l_ss_tab,
                                         l_nr_of_rows, l_where_clause);
            -- The template doesn't exist
            IF l_return_value_get_Tmp <> PA_LIMS.DBERR_SUCCESS THEN
               -- The parameter definition will not be transferred
               IF PA_LIMS.f_GetSettingValue('TMP Master PR') = 1 THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'The parameter template "'||l_a_Template||'" doesn''t exist (The '||l_object||
                                ' is not transferred.).');
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               -- The parameter definition will be transferred
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'The parameter template "'||l_a_Template||'" doesn''t exist  (The '||l_object||
                                ' is transferred.).');
                  l_a_Template := NULL;
               END IF;
            ELSE
               -- Fill in the parameters to save the standard attributes of the parameter definition
               -- if there is a parameter definition template
               l_a_Template_version := l_version_tab(l_nr_of_rows);
               l_version_is_current := NULL;
               l_effective_from     := TO_DATE(l_effective_from_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat);
               l_effective_till     := TO_DATE(l_effective_till_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat);
               l_description        := NVL(l_a_description, l_description_tab(l_nr_of_rows));
               l_description2       := l_description2_tab(l_nr_of_rows);
               l_unit               := l_unit_tab(l_nr_of_rows);
               l_format             := l_format_tab(l_nr_of_rows);
               l_td_info            := l_td_info_tab(l_nr_of_rows);
               l_td_info_unit       := l_td_info_unit_tab(l_nr_of_rows);
               l_confirm_uid        := l_confirm_uid_tab(l_nr_of_rows);
               l_def_val_tp         := l_def_val_tp_tab(l_nr_of_rows);
               l_def_au_level       := l_def_au_level_tab(l_nr_of_rows);
               l_def_val            := l_def_val_tab(l_nr_of_rows);
               l_allow_any_mt       := l_allow_any_mt_tab(l_nr_of_rows);
               l_delay              := l_delay_tab(l_nr_of_rows);
               l_delay_unit         := l_delay_unit_tab(l_nr_of_rows);
               l_min_nr_results     := l_min_nr_results_tab(l_nr_of_rows);
               l_calc_method        := l_calc_method_tab(l_nr_of_rows);
               l_calc_cf            := l_calc_cf_tab(l_nr_of_rows);
               l_alarm_order        := l_alarm_order_tab(l_nr_of_rows);
               l_seta_specs         := l_seta_specs_tab(l_nr_of_rows);
               l_seta_limits        := l_seta_limits_tab(l_nr_of_rows);
               l_seta_target        := l_seta_target_tab(l_nr_of_rows);
               l_setb_specs         := l_setb_specs_tab(l_nr_of_rows);
               l_setb_limits        := l_setb_limits_tab(l_nr_of_rows);
               l_setb_target        := l_setb_target_tab(l_nr_of_rows);
               l_setc_specs         := l_setc_specs_tab(l_nr_of_rows);
               l_setc_limits        := l_setc_limits_tab(l_nr_of_rows);
               l_setc_target        := l_setc_target_tab(l_nr_of_rows);
               l_is_template        := '0';
               l_log_exceptions     := l_log_exceptions_tab(l_nr_of_rows);
               l_sc_lc              := l_sc_lc_tab(l_nr_of_rows);
               l_sc_lc_version      := l_sc_lc_version_tab(l_nr_of_rows);
               l_inherit_au         := l_inherit_au_tab(l_nr_of_rows);
               l_pr_class           := l_pr_class_tab(l_nr_of_rows);
               l_log_hs             := l_log_hs_tab(l_nr_of_rows);
               l_lc                 := l_lc_tab(l_nr_of_rows);
               l_lc_version         := l_lc_version_tab(l_nr_of_rows);
               l_modify_reason      := 'Imported parameter "'||a_pr||'" from Interspec (template : '||
                                       l_a_Template||').';
            END IF;
         END IF;

         -- Check if the default values for the parameters have to be set
         IF l_a_Template IS NULL THEN
            -- Fill in the parameters to save the standard attributes of the parameter definition
            -- if there is no parameter definition template
            l_version_is_current := NULL;
            l_effective_from     := NULL;
            l_effective_till     := NULL;
            l_description        := l_a_description;
            l_unit               := '%';
            l_format             := 'R0.01';
            l_td_info            := 0;
            l_td_info_unit       := 'DD';
            l_confirm_uid        := '0';
            l_def_val_tp         := 'F';
            l_allow_any_mt       := '1';
            l_delay              := 0;
            l_delay_unit         := 'DD';
            l_min_nr_results     := 2;
            l_calc_method        := 'A';
            l_alarm_order        := 'abc';
            l_is_template        := '0';
            l_log_exceptions     := '0';
            l_inherit_au         := '1';
            l_log_hs             := '1';
            l_modify_reason      := 'Imported parameter "'||a_pr||'" from Interspec (no template has been used).';
         END IF;
         -- The parameter definition template lifecycle OR the parameter definition template itself is empty
         -- => take default lc
         IF l_lc IS NULL THEN
            BEGIN
               SELECT uvobjects.def_lc, uvlc.version
               INTO l_lc, l_lc_version
               FROM UVOBJECTS@LNK_LIMS, UVLC@LNK_LIMS
               WHERE uvobjects.object = 'pr'
               AND   uvobjects.def_lc = uvlc.lc
               AND   uvlc.version_is_current = '1';
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                             'No current version found for the default parameter lifecycle.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END;
         END IF;
         -- Fill in the parameters to save the standard attributes of the parameter definition
         l_pr            := a_pr;
         l_version       := a_version;
         BEGIN
            IF a_property_is_historic = 1 THEN
               l_effective_from := PA_LIMS.g_effective_from_date4historic;
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'effective from set to NEVER');               
            END IF;
            --copy from template when template available and global setting set
            IF PA_LIMS.g_use_template_details = '1' AND
               l_a_Template IS NOT NULL AND
               l_a_Template_version IS NOT NULL THEN
               l_return_value_copy := UNAPIPR.CopyParameter@LNK_LIMS(l_a_Template, l_a_Template_version, l_pr, l_version, '');
               IF l_return_value_copy <> PA_LIMS.DBERR_SUCCESS THEN
                  IF l_return_value_copy = PA_LIMS.DBERR_GENFAIL THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save the standard attributes of '||l_object||' (General failure! Error Code: '||
                                   l_return_value_copy||' | Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                  ELSE
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save the standard attributes of '||l_object||' (Error code : '||
                                   l_return_value_copy||').');
                  END IF;

                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted );
                  RETURN (FALSE);
               ELSE
                  --copy was successfull
                  --Delete all records of prmt and prmtau for that pr
                  --These entries will be used only when transfering the prmt entries to determine the assignement frequencies
                  l_return_value_deleteprmt := f_DeleteAllPrMt(l_pr, l_version);
                  IF l_return_value_deleteprmt <> TRUE THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to delete all prmt entries after copy of '||l_object);
                  END IF;               
               END IF;
            END IF;
            -- Save the standard attributes of the parameter definition
            l_return_value_save := UNAPIPR.SaveParameter@LNK_LIMS(l_pr, l_version, l_version_is_current, 
                                      l_effective_from, l_effective_till, l_description, l_description2, l_unit,
                                      l_format, l_td_info, l_td_info_unit, l_confirm_uid, l_def_val_tp, 
                                      l_def_au_level, l_def_val, l_allow_any_mt, l_delay, l_delay_unit, 
                                      l_min_nr_results, l_calc_method, l_calc_cf, l_alarm_order, l_seta_specs,
                                      l_seta_limits, l_seta_target, l_setb_specs, l_setb_limits, l_setb_target,
                                      l_setc_specs, l_setc_limits, l_setc_target, l_is_template, l_log_exceptions,
                                      l_sc_lc, l_sc_lc_version, l_inherit_au, l_pr_class, l_log_hs, l_lc,
                                      l_lc_version, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the standard attributes of '||l_object||' (General failure! Error Code: '||
                                l_return_value_save||' | Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the standard attributes of '||l_object||' (Error code : '||
                                l_return_value_save||').');
               END IF;

               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted );
               RETURN (FALSE);
            END IF;

            -- Append an attribute with value = interspec id of the property
            l_au_tab(1)    := PA_LIMS.c_au_orig_name;
            l_value_tab(1) := a_property;
            IF NOT PA_LIMSSPC.f_TransferSpcAu('pr', a_pr, a_version, l_au_tab, l_value_tab, 1) THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the standard attributes of '||l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      -- When the parameter definition is already in Unilab, it must be checked if it has been updated
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         -- Check if the description has been updated. This has only to be checked if the newminor flag is '0',
         -- because in the other case the description parameter has not been set.
         IF (a_newminor = '0') AND 
            (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_a_description,l_description_tab(l_nr_of_rows))=1 OR l_a_description IS NULL) THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Nothing happened: '||PA_LIMS.c_Msg_Ended);
            RETURN (TRUE);
         END IF;

         BEGIN
            --We do not create a major version systematically like mentioned in the new design started in 611HF
            --this function is called with the flag a_newminor set to 1 in very specific cases.
            --It is the case when the template is containing the interspec_orig_name attribute.
            --In that very specific case: we try to modify actual version when modifiable
            --and create a new minor version in the case the version is not modifiable.
            --That last point is a little bit in contradiction with the new concept but we keep it for backaward compatibility and avoid problems.
            --It is not expected that it would be necessary to create a minor version.
            --Feedback from users/testers should come with a very clear case if this is happening too frequently in their configuration
            --
            IF a_newminor = '1' THEN            
               -- Get the authorisation of the parameter definition
               l_ret_code := UNAPIGEN.GETAUTHORISATION@LNK_LIMS('pr', a_pr, a_version, l_pr_lc, l_pr_lc_version, l_pr_ss,
                                                                l_pr_allow_modify, l_pr_active, l_pr_log_hs);
               IF l_ret_code NOT IN (PA_LIMS.DBERR_SUCCESS,PA_LIMS.DBERR_NOTMODIFIABLE) THEN
                  IF l_ret_code = PA_LIMS.DBERR_GENFAIL THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to get the authorisation of '||l_object||' (General failure! Error Code: '||
                                   l_ret_code||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                  ELSE
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to get the authorisation of '||l_object||' (Error code : '||l_ret_code||').');
                  END IF;

                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               -- Check if a new minor version has to be created to save modified used objects
               ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
                  -- 
                  -- Copy highest major version to next major version
                  -- Fill in the parameters to save the standard attributes of the parameter definition
                  --
                  -- we should better clean up the name of the argument a_newminor since it is no more creating
                  -- minor version but always major versions (left for backward compatibility reason if someone
                  -- has named arguments in custom code)
                  --
                  -- This is necessary since the interface is using the highest major version as the refrence
                  -- to see if the parameter has been changed.
                  --
                  -- If a user is creating a new major version in Unilab, the system will should fall back
                  -- on its feet and not generate a new version on every run of the configuration transfer
                  -- (one or two times is acceptable - not every time as it was detected as a problem on the alpha4 test version on version 6.3)
                  -- (in version alpha4, we tried to generate minor versions but it was keeping generating new minor version on every run of the transfer of the configuration)
                  --
                  a_version := NULL;
                  l_ret_code      := UNVERSION.GetHighestMajorVersion@LNK_LIMS('pr', a_pr, a_version);
                  l_pr            := a_pr;
                  l_version       := a_version;
                  l_ret_code      := UNVERSION.GetNextMajorVersion@LNK_LIMS(l_version);
                  l_modify_reason := 'Imported a new version of parameter "'||l_pr||'" from Interspec.';
                  -- Create a new minor version of the parameter definition
                  l_return_value_save := UNAPIPR.CopyParameter@LNK_LIMS(a_pr, a_version, l_pr, l_version, l_modify_reason);
                  -- If the error is a general failure then the SQLERRM must be logged, otherwise
                  -- the error code is the Unilab error
                  IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
                     IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to save a new version of '||l_object||' (General failure! Error Code: '||
                                      l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                     ELSE
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to save a new version of '||l_object||' (Error code : '||l_return_value_save||').');
                     END IF;

                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
                  END IF;
                  -- Return the new version to the calling API
                  a_version := l_version;
               END IF;                                    
            ELSE
               -- Fill in the parameters to save the standard attributes of the parameter definition
               l_pr            := a_pr;
               l_version       := a_version;
               l_ret_code      := UNVERSION.GETNEXTMAJORVERSION@LNK_LIMS(l_version);
               l_modify_reason := 'Imported a new version of parameter "'||l_pr||'" from Interspec.';
               -- Create a new minor version of the parameter definition
               l_return_value_save := UNAPIPR.COPYPARAMETER@LNK_LIMS(a_pr, a_version, l_pr, l_version, l_modify_reason);
               -- If the error is a general failure then the SQLERRM must be logged, otherwise
               -- the error code is the Unilab error
               IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
                  IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save a new version of '||l_object||' (General failure! Error Code: '||
                                   l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                  ELSE
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save a new version of '||l_object||' (Error code : '||l_return_value_save||').');
                  END IF;

                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               END IF;
               -- Return the new version to the calling API
               a_version := l_version;
            END IF;
            
            -- In case the description had been changed, it has to be modified in the new version
            IF (a_newminor = '0') THEN
               -- Fill in the parameters to save the standard attributes of the parameter definition
               l_pr                 := a_pr;
               l_version            := a_version;
               l_version_is_current := NULL;
               l_effective_from     := TO_DATE(l_effective_from_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat);
               l_effective_till     := TO_DATE(l_effective_till_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat);
               l_description        := NVL(l_a_description, l_description_tab(l_nr_of_rows));
               l_description2       := l_description2_tab(l_nr_of_rows);
               l_unit               := l_unit_tab(l_nr_of_rows);
               l_format             := l_format_tab(l_nr_of_rows);
               l_td_info            := l_td_info_tab(l_nr_of_rows);
               l_td_info_unit       := l_td_info_unit_tab(l_nr_of_rows);
               l_confirm_uid        := l_confirm_uid_tab(l_nr_of_rows);
               l_def_val_tp         := l_def_val_tp_tab(l_nr_of_rows);
               l_def_au_level       := l_def_au_level_tab(l_nr_of_rows);
               l_def_val            := l_def_val_tab(l_nr_of_rows);
               l_allow_any_mt       := l_allow_any_mt_tab(l_nr_of_rows);
               l_delay              := l_delay_tab(l_nr_of_rows);
               l_delay_unit         := l_delay_unit_tab(l_nr_of_rows);
               l_min_nr_results     := l_min_nr_results_tab(l_nr_of_rows);
               l_calc_method        := l_calc_method_tab(l_nr_of_rows);
               l_calc_cf            := l_calc_cf_tab(l_nr_of_rows);
               l_alarm_order        := l_alarm_order_tab(l_nr_of_rows);
               l_seta_specs         := l_seta_specs_tab(l_nr_of_rows);
               l_seta_limits        := l_seta_limits_tab(l_nr_of_rows);
               l_seta_target        := l_seta_target_tab(l_nr_of_rows);
               l_setb_specs         := l_setb_specs_tab(l_nr_of_rows);
               l_setb_limits        := l_setb_limits_tab(l_nr_of_rows);
               l_setb_target        := l_setb_target_tab(l_nr_of_rows);
               l_setc_specs         := l_setc_specs_tab(l_nr_of_rows);
               l_setc_limits        := l_setc_limits_tab(l_nr_of_rows);
               l_setc_target        := l_setc_target_tab(l_nr_of_rows);
               l_is_template        := '0';
               l_log_exceptions     := l_log_exceptions_tab(l_nr_of_rows);
               l_sc_lc              := l_sc_lc_tab(l_nr_of_rows);
               l_sc_lc_version      := l_sc_lc_version_tab(l_nr_of_rows);
               l_inherit_au         := l_inherit_au_tab(l_nr_of_rows);
               l_pr_class           := l_pr_class_tab(l_nr_of_rows);
               l_log_hs             := l_log_hs_tab(l_nr_of_rows);
               l_lc                 := l_lc_tab(l_nr_of_rows);
               l_lc_version         := l_lc_version_tab(l_nr_of_rows);
               l_modify_reason      := 'Imported modified standard attributes of parameter "'||l_pr||
                                       '" from Interspec.';
               BEGIN
                  IF a_property_is_historic = 1 THEN
                     l_effective_from := PA_LIMS.g_effective_from_date4historic;
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'effective from set to NEVER');
                  END IF;
                  -- Save the standard attributes of the parameter definition
                  l_return_value_save := UNAPIPR.SAVEPARAMETER@LNK_LIMS(l_pr, l_version, l_version_is_current,
                                            l_effective_from, l_effective_till, l_description, l_description2, l_unit,
                                            l_format, l_td_info, l_td_info_unit, l_confirm_uid, l_def_val_tp,
                                            l_def_au_level, l_def_val, l_allow_any_mt, l_delay, l_delay_unit,
                                            l_min_nr_results, l_calc_method, l_calc_cf, l_alarm_order, l_seta_specs,
                                            l_seta_limits, l_seta_target, l_setb_specs, l_setb_limits, l_setb_target,
                                            l_setc_specs, l_setc_limits, l_setc_target, l_is_template, 
                                            l_log_exceptions, l_sc_lc, l_sc_lc_version, l_inherit_au, l_pr_class,
                                            l_log_hs, l_lc, l_lc_version, l_modify_reason);
                  -- If the error is a general failure then the SQLERRM must be logged, otherwise
                  -- the error code is the Unilab error
                  IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
                     IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to save the modified standard attributes of '||l_object||
                                      ' (General failure! Error Code: '||l_return_value_save||' Error Msg:'||
                                      UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                     ELSE
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to save the modified standard attributes of '||l_object||
                                      ' (Error code : '||l_return_value_save||').');
                     END IF;

                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     -- Log an error in ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save the modified standard attributes of '||l_object||' : '||SQLERRM);
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
               END;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save a new version of '||l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      ELSE
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to retrieve the standard attributes of '||l_object||' (error code : '||l_return_value_get||').');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Add parameter definition to array, to send an event afterwards
      g_pr_nr_of_rows := g_pr_nr_of_rows + 1;
      g_pr_tab(g_pr_nr_of_rows) := a_pr;
      g_version_tab(g_pr_nr_of_rows) := a_version;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_pr||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_object||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferCfgPr;

   FUNCTION f_TransferCfgAllPr
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The parameter definitions are properties in Interspec. The function
      -- transfers all properties to Unilab if they have the following
      -- characteristics:
      --    - The property is not historic (status = 0).
      --    - The property belongs to a property group.
      --    - The property group is not historic (status = 0).
      --    - The property group has a display format that is set up for LIMS.
      --    - If preference setting 'Transfer All Cfg' = 0:
      --      the display format is used in a specification that is in the queue 
      --      to transfer (table itlimsjob).
      -- ** Return **
      -- TRUE: The transfer of all the properties has succeeded.
      -- FALSE : The transfer of one or more properties has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'LimsCfg';
      l_method      CONSTANT VARCHAR2(32) := 'f_TransferCfgAllPr';

      -- General variables
      l_result               BOOLEAN      DEFAULT TRUE;
      l_PR_Template          VARCHAR2(20);
      l_MT_Template          VARCHAR2(20);
      l_PrID                 VARCHAR2(20);
      l_pr_version           VARCHAR2(20);
      l_pr_version2          VARCHAR2(20);
      l_prmt_tab             UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_prmt_version_tab     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_desc              VARCHAR2(40);
      l_sp_revision          NUMBER;

      -- Cursor to get the properties that have to be send to Unilab as a parameter definition:
      -- preference setting 'Transfer All Cfg' = 1
      CURSOR l_AllPrToTransfer_cursor(c_plant plant.plant%TYPE)
      IS
         SELECT DISTINCT pr.property,
                         f_sph_descr(1, pr.property, 0) sp_desc,
                         pr.status property_is_historic
                    FROM property_group pg,
                         property pr,
                         property_group_list pgpr,
                         property_group_display pgly,
                         itlimsconfly lm
                   WHERE pg.status = 0
                     AND pr.status IN (0, PA_LIMS.g_tr_historic_prop)  --historic properties can be transferred depending on the setting: Transfer Hist Prop
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = pr.property
                     AND pgly.property_group = pgpr.property_group
                     AND pgly.display_format = lm.layout_id
                     AND lm.un_object IN ('PR', 'PPPR');

      -- Cursor to get the properties that have to be send to Unilab as a parameter definition:
      -- preference setting 'Transfer All Cfg' = 0
      CURSOR l_PrToTransfer_cursor(c_plant plant.plant%TYPE)
      IS
         SELECT DISTINCT pr.property,
                         f_sph_descr(1, pr.property, 0) sp_desc,
                         pr.status property_is_historic
                    FROM property_group pg,
                         property pr,
                         ivpgpr pgpr,
                         itlimsconfly lm,
                         ivlimsjob ls
                   WHERE pgpr.property_group IS NOT NULL
                     AND pgpr.property IS NOT NULL
                     AND pg.status = 0  --is not historic (historic => status=1)
                     AND pr.status IN (0, PA_LIMS.g_tr_historic_prop)  --historic properties can be transferred depending on the setting: Transfer Hist Prop
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = pr.property
                     AND pgpr.display_format = lm.layout_id
                     AND pgpr.display_format_rev = lm.layout_rev
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pgpr.part_no = ls.part_no
                     AND pgpr.revision = ls.revision
                     AND pgpr.type = 1 -- (is a property group)
                     AND pgpr.attribute = 0 -- (0 => has no attributes)
                     AND ls.plant = c_plant;

      -- Cursor to get the properties that have to be send to Unilab as a parameter definition:
      -- preference setting 'Transfer All Cfg' = 0
      -- handle also all plants that have the same connection string and language id as the given plant
      CURSOR l_SimilarPrToTransfer_cursor(c_plant plant.plant%TYPE)
      IS
         SELECT DISTINCT pr.property,
                         f_sph_descr(1, pr.property, 0) sp_desc,
                         pr.status property_is_historic                         
                    FROM property_group pg,
                         property pr,
                         ivpgpr pgpr,
                         itlimsconfly lm,
                         ivlimsjob ls,
                         itlimsplant pl
                   WHERE pgpr.property_group IS NOT NULL
                     AND pgpr.property IS NOT NULL
                     AND pg.status = 0 --is not historic (historic => status=1)
                     AND pr.status IN (0, PA_LIMS.g_tr_historic_prop)  --historic properties can be transferred depending on the setting: Transfer Hist Prop
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = pr.property
                     AND pgpr.display_format = lm.layout_id
                     AND pgpr.display_format_rev = lm.layout_rev
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pgpr.part_no = ls.part_no
                     AND pgpr.revision = ls.revision
                     AND pgpr.type = 1 -- (is a property group)
                     AND pgpr.attribute = 0 -- (0 => property has no attributes)
                     AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                             (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                                FROM itlimsplant pl2
                               WHERE pl2.plant = c_plant)
                     AND pl.plant = ls.plant;

      -- @@CL V2.2.1
      -- Cursor to get the combinations (property+attribute) that have
      -- to be send to Unilab as a parameter definition:
      -- preference setting 'Transfer All Cfg' = 1
      CURSOR l_AllPrAtToTransfer_cursor(c_Plant plant.plant%TYPE)
      IS
         SELECT DISTINCT pr.property,
                         f_sph_descr(1, pr.property, 0) sp_desc,
                         prat.attribute,
                         f_ath_descr(1, prat.attribute,0) at_desc,
                         pr.status property_is_historic                         
                    FROM property_group pg,
                         property pr,
                         property_group_list pgpr,
                         property_group_display pgly,
                         attribute_property prat,
                         itlimsconfly lm
                   WHERE pg.status = 0 --is not historic (historic => status=1)
                     AND pr.status IN (0, PA_LIMS.g_tr_historic_prop)  --historic properties can be transferred depending on the setting: Transfer Hist Prop
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = pr.property
                     AND pgly.property_group = pgpr.property_group
                     AND prat.property = pgpr.property
                     AND pgly.display_format = lm.layout_id
                     AND lm.un_object IN ('PR', 'PPPR');
      -- @@CL V2.2.1

      -- Cursor to get the combinations (property+attribute) that have
      -- to be send to Unilab as a parameter definition:
      -- preference setting 'Transfer All Cfg' = 0
      CURSOR l_PrAtToTransfer_cursor(c_Plant plant.plant%TYPE)
      IS
         SELECT DISTINCT pr.property,
                         f_sph_descr(1, pr.property, 0) sp_desc,
                         pgpr.attribute,
                         f_ath_descr(1, pgpr.attribute,0) at_desc,
                         pr.status property_is_historic                                                  
                    FROM property_group pg,
                         property pr,
                         ivpgpr pgpr,
                         itlimsconfly lm,
                         ivlimsjob ls
                   WHERE pgpr.property_group IS NOT NULL
                     AND pgpr.property IS NOT NULL
                     AND pg.status = 0 --is not historic (historic => status=1)
                     AND pr.status IN (0, PA_LIMS.g_tr_historic_prop)  --historic properties can be transferred depending on the setting: Transfer Hist Prop
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = pr.property
                     AND pgpr.display_format = lm.layout_id
                     AND pgpr.display_format_rev = lm.layout_rev
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pgpr.part_no = ls.part_no
                     AND pgpr.revision = ls.revision
                     AND pgpr.type = 1 -- (is a property group)
                     AND pgpr.attribute <> 0 -- (<>0 => property has attributes)
                     AND ls.plant = c_plant;   

      -- Cursor to get the combinations (property+attribute) that have
      -- to be send to Unilab as a parameter definition:
      -- preference setting 'Transfer All Cfg' = 0
      -- handle also all plants that have the same connection string and language id as the given plant
      CURSOR l_SimilarPrAtToTransfer_cursor(c_Plant plant.plant%TYPE)
      IS
         SELECT DISTINCT pr.property,
                         f_sph_descr(1, pr.property, 0) sp_desc,
                         pgpr.attribute,
                         f_ath_descr(1, pgpr.attribute,0) at_desc,
                         pr.status property_is_historic
                    FROM property_group pg,
                         property pr,
                         ivpgpr pgpr,
                         itlimsconfly lm,
                         ivlimsjob ls,
                         itlimsplant pl
                   WHERE pgpr.property_group IS NOT NULL
                     AND pgpr.property IS NOT NULL
                     AND pg.status = 0 --is not historic (historic => status=1)
                     AND pr.status IN (0, PA_LIMS.g_tr_historic_prop)  --historic properties can be transferred depending on the setting: Transfer Hist Prop
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = pr.property
                     AND pgpr.display_format = lm.layout_id
                     AND pgpr.display_format_rev = lm.layout_rev
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pgpr.part_no = ls.part_no
                     AND pgpr.revision = ls.revision
                     AND pgpr.type = 1 -- (is a property group)
                     AND pgpr.attribute <> 0 -- (<>0 => property has attributes)
                     AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                             (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                                FROM itlimsplant pl2
                               WHERE pl2.plant = c_plant)
                     AND pl.plant = ls.plant;   

      PROCEDURE HandleAllPr(a_property IN NUMBER, a_description IN VARCHAR2, 
                            a_property_is_historic IN CHAR, a_template_pr IN VARCHAR2) IS
      BEGIN
         -- Generate the parameter definition id, version and description,
         -- based on the highest revision of the property
         l_sp_revision := PA_LIMS.f_GetHighestRevision('property', a_property);
         l_PrId := PA_LIMS.f_GetPrId(a_property, l_sp_revision, 0, a_description, l_pr_desc);
         l_pr_version := f_GetObjectVersion('pr',l_prid);
         l_pr_version2 := f_GetObjectVersion('mt',l_prid);

         -- Transfer the parameter definition
         IF f_TransferCfgPr(l_PrId, l_pr_version, l_pr_desc, l_PR_Template, a_property, '0', a_property_is_historic) THEN
            -- Check if a method definition has to be created, based on the parameter definition
            IF PA_LIMS.f_GetSettingValue('MT Based On PR') = '1' THEN
               -- Transfer the method definition with the same name as the parameter definition
               IF f_TransferCfgMt(l_PrId, l_pr_version2, l_pr_desc, l_MT_Template, a_property, '0') THEN
                  -- Only execute the next step if 'Transfer Cfg MT' = 0, in the other case the method 
                  -- based on the parameter is attached in the f_TransferCfgAllPrMt function
                  IF PA_LIMS.f_GetSettingValue('Transfer Cfg MT') = '0' THEN
                     l_prmt_tab(1) := l_PrId;
                     -- Generate the version of the method definition for the link
                     l_prmt_version_tab(1) := '~Current~';
                     -- Transfer the link between the method definition and the parameter definition
                     IF f_TransferCfgPrMt(l_PrId, l_pr_version, l_prmt_tab, l_prmt_version_tab, 1, a_template_pr) THEN
                        -- Not all links between method definitions and parameter definitions are transferred
                        COMMIT;
                     ELSE
                        ROLLBACK;
                        l_result := FALSE;
                     END IF;
                  END IF;
               ELSE
                  -- Not all method definitions are transferred
                  ROLLBACK;
                  l_result := FALSE;
               END IF;
            ELSE
               COMMIT;
            END IF;
         ELSE
            -- Not all parameter definitions are transferred
            ROLLBACK;
            l_result := FALSE;
         END IF;

         IF PA_LIMS.f_GetSettingValue('Transfer Cfg MT') = '1' THEN
            -- Transfer all the links between the test methods and the properties to Unilab.
            IF NOT f_TransferCfgAllPrMt(l_PrId, a_property, 0, a_template_pr) THEN
               l_result := FALSE;
            END IF;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer property "'||a_property||
                          '" | description="'||a_description||'" to Unilab: '||SQLERRM);
            -- Not all properties are transferred
            ROLLBACK;
            l_result := FALSE;
      END HandleAllPr;
      
      PROCEDURE HandleAllPrAt(a_property IN NUMBER, a_attribute IN NUMBER, a_description IN VARCHAR2,
                              a_property_is_historic IN CHAR, a_template_pr IN VARCHAR2) IS
      BEGIN
         -- Generate the parameter definition id, version and description,
         -- based on the highest revision of the property
         l_sp_revision := PA_LIMS.f_GetHighestRevision('property', a_property);
         l_PrId := PA_LIMS.f_GetPrId(a_property, l_sp_revision, a_attribute, a_description, l_pr_desc);
         l_pr_version := f_GetObjectVersion('pr',l_prid);
         l_pr_version2 := f_GetObjectVersion('mt',l_prid);

         -- Transfer the parameter definition
         IF f_TransferCfgPr(l_PrId, l_pr_version, l_pr_desc, l_PR_Template, RPAD(a_property,10,' ')||a_attribute, '0', a_property_is_historic) THEN
            -- Check if a method definition has to be created, based on the parameter definition
            IF PA_LIMS.f_GetSettingValue('MT Based On PR') = '1' THEN
               -- Transfer the method definition with the same name as the parameter definition
               IF f_TransferCfgMt(l_PrId, l_pr_version2, l_pr_desc, l_MT_Template, RPAD(a_property,10,' ')||a_attribute, 
                                  '0') THEN
                  -- Only execute the next step if 'Transfer Cfg MT' = 0, in the other case the method 
                  -- based on the parameter is attached in the f_TransferCfgAllPrMt function
                  IF PA_LIMS.f_GetSettingValue('Transfer Cfg MT') = '0' THEN
                     l_prmt_tab(1) := l_PrId;
                     -- Generate the version of the method definition for the link
                     l_prmt_version_tab(1) := '~Current~';
                     -- Transfer the link between the method definition and the parameter definition
                     IF f_TransferCfgPrMt(l_PrId, l_pr_version, l_prmt_tab, l_prmt_version_tab, 1, a_template_pr) THEN
                        -- Not all links between method definitions and parameter definitions are transferred
                        COMMIT;
                     ELSE
                        ROLLBACK;
                        l_result := FALSE;
                     END IF;
                  END IF;
               ELSE
                  -- Not all method definitions are transferred
                  ROLLBACK;
                  l_result := FALSE;
               END IF;
            ELSE
               COMMIT;
            END IF;
         ELSE
            -- Not all parameter definitions are transferred
            ROLLBACK;
            l_result := FALSE;
         END IF;

         IF PA_LIMS.f_GetSettingValue('Transfer Cfg MT') = '1' THEN
            -- Transfer all the links between the test methods and the properties to Unilab.
            IF NOT f_TransferCfgAllPrMt(l_PrId, a_property, a_attribute, a_template_pr) THEN
               l_result := FALSE;
            END IF;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer property "'||a_property||
                          '" | attribute="'||a_attribute||'" | description="'||
                          l_pr_desc||'" to Unilab: '||SQLERRM);
            -- Not all properties are transferred
            ROLLBACK;
            l_result := FALSE;
      END HandleAllPrAt;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);

      -- Start the remote transaction
      IF NOT PA_LIMS.f_StartRemoteTransaction THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Get the templates for the parameter definitions and method definitions
      l_PR_Template := PA_LIMS.f_GetTemplate('PR', NULL);
      l_MT_Template := PA_LIMS.f_GetTemplate('MT', NULL);

      -- Transfer the parameter definitions to Unilab
      -- Check if all configuration data has to be transferred
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Transfer property => parameter definitions');
      IF PA_LIMS.f_GetSettingValue('Transfer All Cfg') = '1' THEN
         FOR l_AllPrToTransfer_rec IN l_AllPrToTransfer_cursor(PA_LIMS.f_ActivePlant) LOOP
            HandleAllPr(l_AllPrToTransfer_Rec.property, l_AllPrToTransfer_rec.sp_desc, l_AllPrToTransfer_rec.property_is_historic, l_PR_Template);
         END LOOP;
      ELSE
         IF g_handle_similar THEN
            FOR l_SimilarPrToTransfer_rec IN l_SimilarPrToTransfer_cursor(PA_LIMS.f_ActivePlant) LOOP
               HandleAllPr(l_SimilarPrToTransfer_Rec.property, l_SimilarPrToTransfer_rec.sp_desc, l_SimilarPrToTransfer_rec.property_is_historic, l_PR_Template);
            END LOOP;
         ELSE
            FOR l_PrToTransfer_rec IN l_PrToTransfer_cursor(PA_LIMS.f_ActivePlant) LOOP
               HandleAllPr(l_PrToTransfer_Rec.property, l_PrToTransfer_rec.sp_desc, l_PrToTransfer_rec.property_is_historic, l_PR_Template);
            END LOOP;
         END IF;
      END IF;

      -- Transfer the parameter definitions to Unilab (property + attribute = parameter definition)
      -- Check if all configuration data has to be transferred
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Transfer property+attribute => parameter definitions');
      IF PA_LIMS.f_GetSettingValue('Transfer All Cfg') = '1' THEN
         FOR l_AllPrAtToTransfer_rec IN l_AllPrAtToTransfer_cursor(PA_LIMS.f_ActivePlant) LOOP
            HandleAllPrAt(l_AllPrAtToTransfer_Rec.Property, l_AllPrAtToTransfer_Rec.Attribute,
                          l_AllPrAtToTransfer_Rec.sp_desc||' '||l_AllPrAtToTransfer_Rec.at_desc, 
                          l_AllPrAtToTransfer_Rec.property_is_historic, l_PR_Template);
         END LOOP;
      ELSE
         IF g_handle_similar THEN
            FOR l_SimilarPrAtToTransfer_rec IN l_SimilarPrAtToTransfer_cursor(PA_LIMS.f_ActivePlant) LOOP
               HandleAllPrAt(l_SimilarPrAtToTransfer_Rec.Property, l_SimilarPrAtToTransfer_Rec.Attribute,
                             l_SimilarPrAtToTransfer_Rec.sp_desc||' '||l_SimilarPrAtToTransfer_Rec.at_desc,
                             l_SimilarPrAtToTransfer_Rec.property_is_historic, l_PR_Template);
            END LOOP;
         ELSE
            FOR l_PrAtToTransfer_rec IN l_PrAtToTransfer_cursor(PA_LIMS.f_ActivePlant) LOOP
               HandleAllPrAt(l_PrAtToTransfer_Rec.Property, l_PrAtToTransfer_Rec.Attribute,
                             l_PrAtToTransfer_Rec.sp_desc||' '||l_PrAtToTransfer_Rec.at_desc,
                             l_PrAtToTransfer_Rec.property_is_historic, l_PR_Template);
            END LOOP;
         END IF;
      END IF;

      -- End the remote transaction
      IF NOT PA_LIMS.f_EndRemoteTransaction THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;
      COMMIT;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (l_result);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the parameters for plant "'||PA_LIMS.f_ActivePlant||'" : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         -- End the remote transaction
         IF NOT PA_LIMS.f_EndRemoteTransaction THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         END IF;
         ROLLBACK;
         RETURN (FALSE);
   END f_TransferCfgAllPr;

   FUNCTION f_TransferCfgMt(
      a_mt           IN     VARCHAR2,
      a_version      IN OUT VARCHAR2,
      a_description  IN     VARCHAR2,
      a_template     IN     VARCHAR2,
      a_test_method  IN     VARCHAR2,
      a_newminor     IN     CHAR
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer a method definition in Interspec to Unilab.
      -- ** Parameters **
      -- a_mt          : method definition to transfer
      -- a_version     : version of the method definition
      -- a_description : description of the method definition
      -- a_template    : template for the method definition
      -- a_test_method : test method from which the method definition has been derived
      -- a_newminor    : flag indicating if a new minor version has to be created to save modified used objects
      -- ** Return **
      -- TRUE: The transfer of the method definition has succeeded.
      -- FALSE : The transfer of the method definition has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname     CONSTANT VARCHAR2(12)                      := 'LimsCfg';
      l_method        CONSTANT VARCHAR2(32)                      := 'f_TransferCfgMt';
      l_object        VARCHAR2(255);

      -- General Variables
      l_a_description          VARCHAR2(40);
      l_a_Template             VARCHAR2(20);
      l_a_Template_version     VARCHAR2(20);
      l_au_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab              UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'GetMethod' API
      l_return_value_get_tmp   INTEGER;
      l_return_value_get       INTEGER;
      l_nr_of_rows             NUMBER                            := 999;
      l_where_clause           VARCHAR2(255);
      l_mt_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_is_current_tab UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_effective_from_tab     UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_effective_till_tab     UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_description_tab        UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description2_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_unit_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_est_cost_tab           UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_est_time_tab           UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_accuracy_tab           UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_is_template_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_calibration_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_autorecalc_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_confirm_complete_tab   UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_auto_create_cells_tab  UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_me_result_editable_tab UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_executor_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_eq_tp_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_sop_tab                UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_sop_version_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_plaus_low_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_plaus_high_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_winsize_x_tab          UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_winsize_y_tab          UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_sc_lc_tab              UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_sc_lc_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_def_val_tp_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_def_au_level_tab       UNAPIGEN.VC4_TABLE_TYPE@LNK_LIMS;
      l_def_val_tab            UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_format_tab             UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_mt_class_tab           UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_log_hs_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_allow_modify_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_active_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_lc_tab                 UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_lc_version_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_ss_tab                 UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'CopyMethod' API
      l_return_value_copy      INTEGER;

      -- Specific local variables for the 'SaveMethod' API
      l_return_value_save      INTEGER;
      l_mt                     VARCHAR2(20);
      l_version                VARCHAR2(20);
      l_version_is_current     CHAR(1);
      l_effective_from         DATE;
      l_effective_till         DATE;
      l_description            VARCHAR2(40);
      l_description2           VARCHAR2(40);
      l_unit                   VARCHAR2(20);
      l_est_cost               VARCHAR2(40);
      l_est_time               VARCHAR2(40);
      l_accuracy               NUMBER;
      l_is_template            CHAR(1);
      l_calibration            CHAR(1);
      l_autorecalc             CHAR(1);
      l_confirm_complete       CHAR(1);
      l_auto_create_cells      CHAR(1);
      l_me_result_editable     CHAR(1);
      l_executor               VARCHAR2(20);
      l_eq_tp                  VARCHAR2(20);
      l_sop                    VARCHAR2(40);
      l_sop_version            VARCHAR2(20);
      l_plaus_low              NUMBER;
      l_plaus_high             NUMBER;
      l_winsize_x              NUMBER;
      l_winsize_y              NUMBER;
      l_sc_lc                  VARCHAR2(2);
      l_sc_lc_version          VARCHAR2(20);
      l_def_val_tp             CHAR(1);
      l_def_au_level           VARCHAR2(4);
      l_def_val                CHAR(1);
      l_format                 VARCHAR2(40);
      l_inherit_au             CHAR(1);
      l_mt_class               VARCHAR2(2);
      l_log_hs                 CHAR(1);
      l_lc                     VARCHAR2(2);
      l_lc_version             VARCHAR2(20);
      l_modify_reason          VARCHAR2(255);

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_mt_lc                  VARCHAR2(2);
      l_mt_lc_version          VARCHAR2(20);
      l_mt_ss                  VARCHAR2(2);
      l_mt_log_hs              CHAR(1);
      l_mt_allow_modify        CHAR(1);
      l_mt_active              CHAR(1);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Mt||' | '||a_version, a_description,
                      a_template||' | '||a_test_method||' | '||a_newminor, PA_LIMS.c_Msg_Started);
      -- Convert the arguments to their maximum length
      l_a_description := SUBSTR(a_description, 1, 40);
      l_a_Template := a_Template;
      -- Initializing variables
      l_object := 'method "'||a_Mt||'" | version='||a_version||' | description="'||l_a_description||'"';

      -- Fill in the parameters to get the standard attributes of the method definition
      l_where_clause := 'WHERE mt='''||REPLACE(a_mt,'''','''''')||''' AND version = '''||
                        a_version||''' ORDER BY mt, version';
      -- Get the standard attributes of the method definition
      l_return_value_get := UNAPIMT.GETMETHOD@LNK_LIMS(l_mt_tab, l_version_tab, l_version_is_current_tab,
                               l_effective_from_tab, l_effective_till_tab, l_description_tab, l_description2_tab,
                               l_unit_tab, l_est_cost_tab, l_est_time_tab, l_accuracy_tab, l_is_template_tab,
                               l_calibration_tab, l_autorecalc_tab, l_confirm_complete_tab, l_auto_create_cells_tab,
                               l_me_result_editable_tab, l_executor_tab, l_eq_tp_tab, l_sop_tab, l_sop_version_tab,
                               l_plaus_low_tab, l_plaus_high_tab, l_winsize_x_tab, l_winsize_y_tab, l_sc_lc_tab,
                               l_sc_lc_version_tab, l_def_val_tp_tab, l_def_au_level_tab, l_def_val_tab,
                               l_format_tab, l_inherit_au_tab, l_mt_class_tab, l_log_hs_tab, l_allow_modify_tab,
                               l_active_tab, l_lc_tab, l_lc_version_tab, l_ss_tab, l_nr_of_rows, l_where_clause);
      -- Check if the method definition exists in Unilab.
      -- If the method definition is not found then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- Check if the method definition must be based on a template
         IF NOT l_a_Template IS NULL THEN
            -- Fill in the parameters to get the standard attributes of the method definition template
            l_where_clause := l_a_Template;
            -- Get the standard attributes of the parameter definition template
            l_return_value_get_tmp := UNAPIMT.GETMETHOD@LNK_LIMS(l_mt_tab, l_version_tab, l_version_is_current_tab,
                                         l_effective_from_tab, l_effective_till_tab, l_description_tab, 
                                         l_description2_tab, l_unit_tab, l_est_cost_tab, l_est_time_tab, 
                                         l_accuracy_tab, l_is_template_tab, l_calibration_tab, l_autorecalc_tab,
                                         l_confirm_complete_tab, l_auto_create_cells_tab, l_me_result_editable_tab,
                                         l_executor_tab, l_eq_tp_tab, l_sop_tab, l_sop_version_tab, l_plaus_low_tab,
                                         l_plaus_high_tab, l_winsize_x_tab, l_winsize_y_tab, l_sc_lc_tab, 
                                         l_sc_lc_version_tab, l_def_val_tp_tab, l_def_au_level_tab, l_def_val_tab,
                                         l_format_tab, l_inherit_au_tab, l_mt_class_tab, l_log_hs_tab, 
                                         l_allow_modify_tab, l_active_tab, l_lc_tab, l_lc_version_tab, l_ss_tab,
                                         l_nr_of_rows, l_where_clause);
            -- The template doesn't exist
            IF l_return_value_get_Tmp <> PA_LIMS.DBERR_SUCCESS THEN
               -- The method definition will not be transferred
               IF PA_LIMS.f_GetSettingValue('TMP Master MT') = 1 THEN
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'The method template "'||l_a_Template||'" doesn''t exist. (The '||l_object||
                                ' is not transferred.)');
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               -- The method definition will be transferred
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                                'The method template "'||l_a_Template||'" doesn''t exist. (The '||l_object||' is transferred.)');
                  l_a_Template := NULL;
               END IF;
            ELSE
               -- Fill in the parameters to save the standard attributes of the method definition
               -- if there is a method definition template
               l_a_Template_version := l_version_tab(l_nr_of_rows);
               l_version_is_current := NULL;
               l_effective_from     := TO_DATE(l_effective_from_tab(l_nr_of_rows),PA_LIMS.f_getdateformat);
               l_effective_till     := TO_DATE(l_effective_till_tab(l_nr_of_rows),PA_LIMS.f_getdateformat);
               l_description        := NVL(l_a_description, l_description_tab(l_nr_of_rows));
               l_description2       := l_description2_tab(l_nr_of_rows);
               l_unit               := l_unit_tab(l_nr_of_rows);
               l_est_cost           := l_est_cost_tab(l_nr_of_rows);
               l_est_time           := l_est_time_tab(l_nr_of_rows);
               l_accuracy           := l_accuracy_tab(l_nr_of_rows);
               l_is_template        := '0';
               l_calibration        := l_calibration_tab(l_nr_of_rows);
               l_autorecalc         := l_autorecalc_tab(l_nr_of_rows);
               l_confirm_complete   := l_confirm_complete_tab(l_nr_of_rows);
               l_auto_create_cells  := l_auto_create_cells_tab(l_nr_of_rows);
               l_me_result_editable := l_me_result_editable_tab(l_nr_of_rows);
               l_executor           := l_executor_tab(l_nr_of_rows);
               l_eq_tp              := l_eq_tp_tab(l_nr_of_rows);
               l_sop                := l_sop_tab(l_nr_of_rows);
               l_sop_version        := l_sop_version_tab(l_nr_of_rows);
               l_plaus_low          := l_plaus_low_tab(l_nr_of_rows);
               l_plaus_high         := l_plaus_high_tab(l_nr_of_rows);
               l_winsize_x          := l_winsize_x_tab(l_nr_of_rows);
               l_winsize_y          := l_winsize_y_tab(l_nr_of_rows);
               l_sc_lc              := l_sc_lc_tab(l_nr_of_rows);
               l_sc_lc_version      := l_sc_lc_version_tab(l_nr_of_rows);
               l_inherit_au         := l_inherit_au_tab(l_nr_of_rows);
               l_def_val_tp         := l_def_val_tp_tab(l_nr_of_rows);
               l_def_au_level       := l_def_au_level_tab(l_nr_of_rows);
               l_def_val            := l_def_val_tab(l_nr_of_rows);
               l_format             := l_format_tab(l_nr_of_rows);
               l_inherit_au         := l_inherit_au_tab(l_nr_of_rows);
               l_mt_class           := l_mt_class_tab(l_nr_of_rows);
               l_log_hs             := l_log_hs_tab(l_nr_of_rows);
               l_lc                 := l_lc_tab(l_nr_of_rows);
               l_lc_version         := l_lc_version_tab(l_nr_of_rows);
               l_modify_reason      := 'Imported method "'||a_mt||'" from Interspec (template : '||l_a_Template||').';
            END IF;
         END IF;

         -- Check if the default values for the parameters have to be set
         IF l_a_Template IS NULL THEN
            -- Fill in the parameters to save the standard attributes of the method definition
            -- if there is no method definition template
            l_version_is_current := NULL;
            l_effective_from     := NULL;
            l_effective_till     := NULL;
            l_description        := l_a_description;
            l_unit               := '%';
            l_est_cost           := '100';
            l_est_time           := '10';
            l_accuracy           := 1;
            l_is_template        := '0';
            l_calibration        := '0';
            l_autorecalc         := '1';
            l_confirm_complete   := '0';
            l_auto_create_cells  := '1';
            l_me_result_editable := '0';
            l_executor           := USER;
            l_winsize_x          := 0;
            l_winsize_y          := 0;
            l_inherit_au         := 0;
            l_def_val_tp         := 'F';
            l_format             := 'R0.01';
            l_log_hs             := '1';
            l_modify_reason      := 'Imported method "'||a_mt||'" from Interspec (no template has been used).';
         END IF;
         -- The method definition template lifecycle OR the method definition template itself is empty
         -- => take default lc
         IF l_lc IS NULL THEN
            BEGIN
               SELECT uvobjects.def_lc, uvlc.version
               INTO l_lc, l_lc_version
               FROM UVOBJECTS@LNK_LIMS, UVLC@LNK_LIMS
               WHERE uvobjects.object = 'mt'
               AND   uvobjects.def_lc = uvlc.lc
               AND   uvlc.version_is_current = '1';
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                             'No current version found for the default method lifecycle.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END;
         END IF;
         -- Fill in the parameters to save the standard attributes of the method definition
         l_mt            := a_Mt;
         l_version       := a_version;
         BEGIN
            --copy from template when template available and global setting set
            IF PA_LIMS.g_use_template_details = '1' AND
               l_a_Template IS NOT NULL AND
               l_a_Template_version IS NOT NULL THEN
               l_return_value_copy := UNAPIMT.CopyMethod@LNK_LIMS(l_a_Template, l_a_Template_version, l_mt, l_version, '');
               IF l_return_value_copy <> PA_LIMS.DBERR_SUCCESS THEN
                  IF l_return_value_copy = PA_LIMS.DBERR_GENFAIL THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save the standard attributes of '||l_object||' (General failure! Error Code: '||
                                   l_return_value_copy||' | Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                  ELSE
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save the standard attributes of '||l_object||' (Error code : '||
                                   l_return_value_copy||').');
                  END IF;

                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted );
                  RETURN (FALSE);
               END IF;
            END IF;
            -- Save the standard attributes of the method definition
            l_return_value_save := UNAPIMT.SAVEMETHOD@LNK_LIMS(l_mt, l_version, l_version_is_current, 
                                      l_effective_from, l_effective_till, l_description, l_description2, l_unit,
                                      l_est_cost, l_est_time, l_accuracy, l_is_template, l_calibration, l_autorecalc,
                                      l_confirm_complete, l_auto_create_cells, l_me_result_editable, l_executor,
                                      l_eq_tp, l_sop, l_sop_version, l_plaus_low, l_plaus_high, l_winsize_x, 
                                      l_winsize_y, l_sc_lc, l_sc_lc_version, l_def_val_tp, l_def_au_level, l_def_val,
                                      l_format, l_inherit_au, l_mt_class, l_log_hs, l_lc, l_lc_version, 
                                      l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the standard attributes of '||l_object||' (General failure! Error Code: '||
                                l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the standard attributes of '||l_object||' (Error code : '||
                                l_return_value_save||').');
               END IF;

               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Append an attribute with value = interspec id of the test method
            l_au_tab(1)    := PA_LIMS.c_au_orig_name;
            l_value_tab(1) := a_test_method;
            IF NOT PA_LIMSSPC.f_TransferSpcAu('mt', a_mt, a_version, l_au_tab, l_value_tab, 1) THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                             'Unable to save the standard attributes of '||l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      -- When the test method is already in Unilab, it must be checked if it has been updated
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         -- Check if the description has been updated. This has only to be checked if the newminor flag is '0',
         -- because in the other case the description parameter has not been set.
         IF (a_newminor = '0') AND 
            (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_a_description, l_description_tab(l_nr_of_rows))=1 OR a_description IS NULL) THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Nothing happened: '||PA_LIMS.c_Msg_Ended);
            RETURN (TRUE);
         END IF;

         BEGIN
            --We do not create a major version systematically like mentioned in the new design started in 611HF
            --this function is called with the flag a_newminor set to 1 in very specific cases.
            --It is the case when the template is containing the interspec_orig_name attribute.
            --In that very specific case: we try to modify actual version when modifiable
            --and create a new minor version in the case the version is not modifiable.
            --That last point is a little bit in contradiction with the new concept but we keep it for backaward compatibility and avoid problems.
            --It is not expected that it would be necessary to create a minor version.
            --Feedback from users/testers should come with a very clear case if this is happening too frequently in their configuration
            --
            IF a_newminor = '1' THEN            
               -- Get the authorisation of the method definition
               l_ret_code := UNAPIGEN.GETAUTHORISATION@LNK_LIMS('mt', a_mt, a_version, l_mt_lc, l_mt_lc_version, l_mt_ss,
                                                                l_mt_allow_modify, l_mt_active, l_mt_log_hs);
               IF l_ret_code NOT IN (PA_LIMS.DBERR_SUCCESS,PA_LIMS.DBERR_NOTMODIFIABLE) THEN
                  IF l_ret_code = PA_LIMS.DBERR_GENFAIL THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to get the authorisation of '||l_object||' (General failure! Error Code: '||l_ret_code||
                                   ' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                  ELSE
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to get the authorisation of '||l_object||' (Error code : '||l_ret_code||').');
                  END IF;
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               -- Check if a new minor version has to be created to save modified used objects
               ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
                  -- 
                  -- Copy highest major version to next major version
                  -- Fill in the parameters to save the standard attributes of the method definition
                  --
                  -- we should better clean up the name of the argument a_newminor since it is no more creating
                  -- minor version but always major versions (left for backward compatibility reason if someone
                  -- has named arguments in custom code)
                  --
                  -- This is necessary since the interface is using the highest major version as the refrence
                  -- to see if the method has been changed.
                  --
                  -- If a user is creating a new major version in Unilab, the system will should fall back
                  -- on its feet and not generate a new version on every run of the configuration transfer
                  -- (one or two times is acceptable - not every time as it was detected as a problem on the alpha4 test version on version 6.3)
                  -- (in version alpha4, we tried to generate minor versions but it was keeping generating new minor version on every run of the transfer of the configuration)
                  --
                  a_version := NULL;
                  l_ret_code      := UNVERSION.GetHighestMajorVersion@LNK_LIMS('mt', a_Mt, a_version);
                  l_mt            := a_Mt;
                  l_version       := a_version;
                  l_ret_code      := UNVERSION.GetNextMajorVersion@LNK_LIMS(l_version);
                  l_modify_reason := 'Imported a new version of method "'||a_mt||'" from Interspec.';
                  -- Create a new minor version of the method definition
                  l_return_value_save := UNAPIMT.COPYMETHOD@LNK_LIMS(a_mt, a_version, l_mt, l_version, l_modify_reason);
                  -- If the error is a general failure then the SQLERRM must be logged, otherwise
                  -- the error code is the Unilab error
                  IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
                     IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to save a new version of '||l_object||' (General failure! Error Code: '||
                                      l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                     ELSE
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to save a new version of '||l_object||' (Error code : '||l_return_value_save||').');
                     END IF;

                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
                  END IF;
                  -- Return the new version to the calling API
                  a_version := l_version;
               END IF;
            ELSE
               -- Fill in the parameters to save the standard attributes of the method definition
               l_mt            := a_Mt;
               l_version       := a_version;
               l_ret_code      := UNVERSION.GETNEXTMAJORVERSION@LNK_LIMS(l_version);
               l_modify_reason := 'Imported a new version of method "'||a_mt||'" from Interspec.';
               -- Create a new minor version of the method definition
               l_return_value_save := UNAPIMT.COPYMETHOD@LNK_LIMS(a_mt, a_version, l_mt, l_version, l_modify_reason);
               -- If the error is a general failure then the SQLERRM must be logged, otherwise
               -- the error code is the Unilab error
               IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
                  IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save a new version of '||l_object||' (General failure! Error Code: '||
                                   l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                  ELSE
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save a new version of '||l_object||' (Error code : '||l_return_value_save||').');
                  END IF;
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               END IF;
               -- Return the new version to the calling API
               a_version := l_version;
            END IF;
            
            -- In case the description had been changed, it has to be modified in the new version
            IF (a_newminor = '0') THEN
               -- Fill in the parameters to save the standard attributes of the method definition
               l_mt                 := a_Mt;
               l_version            := a_version;
               l_version_is_current := NULL;
               l_effective_from     := TO_DATE(l_effective_from_tab(l_nr_of_rows),PA_LIMS.f_getdateformat);
               l_effective_till     := TO_DATE(l_effective_till_tab(l_nr_of_rows),PA_LIMS.f_getdateformat);
               l_description        := NVL(l_a_description, l_description_tab(l_nr_of_rows));
               l_description2       := l_description2_tab(l_nr_of_rows);
               l_unit               := l_unit_tab(l_nr_of_rows);
               l_est_cost           := l_est_cost_tab(l_nr_of_rows);
               l_est_time           := l_est_time_tab(l_nr_of_rows);
               l_accuracy           := l_accuracy_tab(l_nr_of_rows);
               l_is_template        := '0';
               l_calibration        := l_calibration_tab(l_nr_of_rows);
               l_autorecalc         := l_autorecalc_tab(l_nr_of_rows);
               l_confirm_complete   := l_confirm_complete_tab(l_nr_of_rows);
               l_auto_create_cells  := l_auto_create_cells_tab(l_nr_of_rows);
               l_me_result_editable := l_me_result_editable_tab(l_nr_of_rows);
               l_executor           := l_executor_tab(l_nr_of_rows);
               l_eq_tp              := l_eq_tp_tab(l_nr_of_rows);
               l_sop                := l_sop_tab(l_nr_of_rows);
               l_sop_version        := l_sop_version_tab(l_nr_of_rows);
               l_plaus_low          := l_plaus_low_tab(l_nr_of_rows);
               l_plaus_high         := l_plaus_high_tab(l_nr_of_rows);
               l_winsize_x          := l_winsize_x_tab(l_nr_of_rows);
               l_winsize_y          := l_winsize_y_tab(l_nr_of_rows);
               l_sc_lc              := l_sc_lc_tab(l_nr_of_rows);
               l_sc_lc_version      := l_sc_lc_version_tab(l_nr_of_rows);
               l_inherit_au         := l_inherit_au_tab(l_nr_of_rows);
               l_def_val_tp         := l_def_val_tp_tab(l_nr_of_rows);
               l_def_au_level       := l_def_au_level_tab(l_nr_of_rows);
               l_def_val            := l_def_val_tab(l_nr_of_rows);
               l_format             := l_format_tab(l_nr_of_rows);
               l_inherit_au         := l_inherit_au_tab(l_nr_of_rows);
               l_mt_class           := l_mt_class_tab(l_nr_of_rows);
               l_log_hs             := l_log_hs_tab(l_nr_of_rows);
               l_lc                 := l_lc_tab(l_nr_of_rows);
               l_lc_version         := l_lc_version_tab(l_nr_of_rows);
               l_modify_reason      := 'Imported modified standard attributes of method "'||a_mt||'" from Interspec.';
               BEGIN
                  -- Save the standard attributes of the method definition
                  l_return_value_save := UNAPIMT.SAVEMETHOD@LNK_LIMS(l_mt, l_version, l_version_is_current,
                                            l_effective_from, l_effective_till, l_description, l_description2,
                                            l_unit, l_est_cost, l_est_time, l_accuracy, l_is_template, l_calibration,
                                            l_autorecalc, l_confirm_complete, l_auto_create_cells, 
                                            l_me_result_editable, l_executor, l_eq_tp, l_sop, l_sop_version, 
                                            l_plaus_low, l_plaus_high, l_winsize_x, l_winsize_y, l_sc_lc, 
                                            l_sc_lc_version, l_def_val_tp, l_def_au_level, l_def_val, l_format,
                                            l_inherit_au, l_mt_class, l_log_hs, l_lc, l_lc_version, l_modify_reason);
                  -- If the error is a general failure then the SQLERRM must be logged, otherwise
                  -- the error code is the Unilab error
                  IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
                     IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to save the modified standard attributes of '||l_object||
                                      ' (General failure! Error Code: '||l_return_value_save||' Error Msg:'||
                                      UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                     ELSE
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to save the modified standard attributes of '||l_object||
                                      ' (Error code : '||l_return_value_save||').');
                     END IF;

                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     -- Log an error in ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save the modified standard attributes of '||l_object||' : '||SQLERRM);
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
               END;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save a new version of '||l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      ELSE
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to retrieve the standard attributes of '||l_object||' (Error code : '||l_return_value_get||').');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;
      
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_mt||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_object||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferCfgMt;

   FUNCTION f_TransferCfgAllMt
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The method definitions are test methods in Interspec. The function
      -- transfers all test methods to Unilab if they have the following
      -- characteristics:
      --    - The test method is not historic (status = 0)
      --    - The test method belongs to a property.
      --    - The property is not historic (status = 0)
      --    - The property belongs to a property group
      --    - The property group is not historic (status = 0)
      --    - The property group has a display format that is set up for LIMS
      --    - If preference setting 'Transfer All Cfg' = 0:
      --      the display format is used in a specification that is in the queue 
      --      to transfer (table itlimsjob).
      -- ** Return **
      -- TRUE: The transfer of all the method definitions has succeeded.
      -- FALSE : The transfer of all the method definitions has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'LimsCfg';
      l_method      CONSTANT VARCHAR2(32) := 'f_TransferCfgAllMt';

      -- General variables
      l_result               BOOLEAN      DEFAULT TRUE;
      l_Template             VARCHAR2(20);
      l_MtId                 VARCHAR2(20);
      l_mt_version           VARCHAR2(20);
      l_mt_desc              VARCHAR2(40);
      l_tm_revision          NUMBER;

      -- Cursors to get all the test methods that have to be send to Unilab as a method definition:
      -- preference setting 'Transfer All Cfg' = 1
      CURSOR l_AllMtToTransfer_cursor(c_plant plant.plant%TYPE)
      IS
         SELECT DISTINCT mt.test_method,
                         f_mth_descr(1, mt.test_method, 0) tm_desc,
                         pr.status property_is_historic
                    FROM property_group pg,
                         property pr,
                         test_method mt,
                         property_group_list pgpr,
                         property_test_method prtm,
                         property_group_display pgly,
                         itlimsconfly lm
                   WHERE pg.status = 0 --is not historic (historic => status=1)
                     AND pr.status IN (0, PA_LIMS.g_tr_historic_prop)  --historic properties can be transferred depending on the setting: Transfer Hist Prop
                     AND mt.status = 0 --is not historic (historic => status=1)
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = pr.property
                     AND prtm.property = pgpr.property
                     AND prtm.test_method = mt.test_method
                     AND pgly.property_group = pgpr.property_group
                     AND pgly.display_format = lm.layout_id
                     AND lm.un_object IN ('PR', 'PPPR');

      -- Cursors to get all the test methods that have to be send to Unilab as a method definition:
      -- preference setting 'Transfer All Cfg' = 0
      CURSOR l_MtToTransfer_cursor(c_plant plant.plant%TYPE)
      IS
         SELECT DISTINCT mt.test_method,
                         f_mth_descr(1, mt.test_method, 0) tm_desc,
                         pr.status property_is_historic
                    FROM property_group pg,
                         property pr,
                         test_method mt,
                         ivpgpr pgpr,
                         itlimsconfly lm,
                         ivlimsjob ls
                   WHERE pgpr.property_group IS NOT NULL
                     AND pgpr.property IS NOT NULL
                     AND pgpr.test_method IS NOT NULL
                     AND pg.status = 0 --is not historic (historic => status=1)
                     AND pr.status IN (0, PA_LIMS.g_tr_historic_prop)  --historic properties can be transferred depending on the setting: Transfer Hist Prop
                     AND mt.status = 0 --is not historic (historic => status=1)
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = pr.property
                     AND pgpr.test_method = mt.test_method
                     AND pgpr.display_format = lm.layout_id
                     AND pgpr.display_format_rev = lm.layout_rev
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pgpr.part_no = ls.part_no
                     AND pgpr.revision = ls.revision
                     AND pgpr.type = 1  -- section is a property group
                     AND ls.plant = c_plant;

      -- Cursors to get all the test methods that have to be send to Unilab as a method definition:
      -- preference setting 'Transfer All Cfg' = 0
      -- handle also all plants that have the same connection string and language id as the given plant
      CURSOR l_SimilarMtToTransfer_cursor(c_plant plant.plant%TYPE)
      IS
         SELECT DISTINCT mt.test_method,
                         f_mth_descr(1, mt.test_method, 0) tm_desc,
                         pr.status property_is_historic
                    FROM property_group pg,
                         property pr,
                         test_method mt,
                         ivpgpr pgpr,
                         itlimsconfly lm,
                         ivlimsjob ls,
                         itlimsplant pl
                   WHERE pgpr.property_group IS NOT NULL
                     AND pgpr.property IS NOT NULL
                     AND pgpr.test_method IS NOT NULL
                     AND pg.status = 0 --is not historic (historic => status=1)
                     AND pr.status IN (0, PA_LIMS.g_tr_historic_prop)  --historic properties can be transferred depending on the setting: Transfer Hist Prop
                     AND mt.status = 0 --is not historic (historic => status=1)
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = pr.property
                     AND pgpr.test_method = mt.test_method
                     AND pgpr.display_format = lm.layout_id
                     AND pgpr.display_format_rev = lm.layout_rev
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pgpr.part_no = ls.part_no
                     AND pgpr.revision = ls.revision
                     AND pgpr.type = 1 -- section is a property group
                     AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                             (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                                FROM itlimsplant pl2
                               WHERE pl2.plant = c_plant)
                     AND pl.plant = ls.plant;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);

      -- Start the remote transaction
      IF NOT PA_LIMS.f_StartRemoteTransaction THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Get the template for the method definitions
      l_Template := PA_LIMS.f_GetTemplate('MT', NULL);

      -- Transfer the method definitions to Unilab
      -- Check if all configuration data has to be transferred
      IF PA_LIMS.f_GetSettingValue('Transfer All Cfg') = '1' THEN
         FOR l_AllMtToTransfer_rec IN l_AllMtToTransfer_cursor(PA_LIMS.f_ActivePlant) LOOP
            BEGIN
               -- Generate the method definition id, version and description,
               -- based on the highest revision of the test method
               l_tm_revision := PA_LIMS.f_GetHighestRevision('test_method', l_AllMtToTransfer_Rec.test_method);
               l_MtId := PA_LIMS.f_GetMtId(l_AllMtToTransfer_Rec.test_method, l_tm_revision,
                            l_AllMtToTransfer_rec.tm_desc, l_mt_desc);
               l_mt_version := f_GetObjectVersion('mt',l_mtid);

               -- Transfer the method definition
               IF f_TransferCfgMt(l_MtId, l_mt_version, l_mt_desc, l_Template, l_AllMtToTransfer_Rec.test_method,
                                  '0') THEN
                  COMMIT;
               ELSE
                  -- Not all method definitions are transferred
                  ROLLBACK;
                  l_result := FALSE;
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  -- Log an error in ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to transfer test method "'||l_AllMtToTransfer_Rec.test_method||
                                '" | description="'||l_AllMtToTransfer_rec.tm_desc||'" to Unilab: '||SQLERRM);
                  -- Not all method definitions are transferred
                  ROLLBACK;
                  l_result := FALSE;
            END;
         END LOOP;
      ELSE
         IF g_handle_similar THEN
            FOR l_SimilarMtToTransfer_rec IN l_SimilarMtToTransfer_cursor(PA_LIMS.f_ActivePlant) LOOP
               BEGIN
                  -- Generate the method definition id, version and description,
                  -- based on the highest revision of the test method
                  l_tm_revision := PA_LIMS.f_GetHighestRevision('test_method', l_SimilarMtToTransfer_Rec.test_method);
                  l_MtId := PA_LIMS.f_GetMtId(l_SimilarMtToTransfer_Rec.test_method, l_tm_revision,
                               l_SimilarMtToTransfer_rec.tm_desc, l_mt_desc);
                  l_mt_version := f_GetObjectVersion('mt',l_mtid);

                  -- Transfer the method definition
                  IF f_TransferCfgMt(l_MtId, l_mt_version, l_mt_desc, l_Template, 
                                     l_SimilarMtToTransfer_Rec.test_method, '0') THEN
                     COMMIT;
                  ELSE
                     -- Not all method definitions are transferred
                     ROLLBACK;
                     l_result := FALSE;
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     -- Log an error in ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to transfer test method "'||l_SimilarMtToTransfer_Rec.test_method||
                                   '" | description="'||l_SimilarMtToTransfer_rec.tm_desc||'" to Unilab: '||SQLERRM);
                     -- Not all methods are transferred
                     ROLLBACK;
                     l_result := FALSE;
               END;
            END LOOP;
         ELSE
            FOR l_MtToTransfer_rec IN l_MtToTransfer_cursor(PA_LIMS.f_ActivePlant) LOOP
               BEGIN
                  -- Generate the method definition id, version and description,
                  -- based on the highest revision of the test method
                  l_tm_revision := PA_LIMS.f_GetHighestRevision('test_method', l_MtToTransfer_Rec.test_method);
                  l_MtId := PA_LIMS.f_GetMtId(l_MtToTransfer_Rec.test_method, l_tm_revision,
                               l_MtToTransfer_rec.tm_desc, l_mt_desc);
                  l_mt_version := f_GetObjectVersion('mt',l_mtid);

                  -- Transfer the method definition
                  IF f_TransferCfgMt(l_MtId, l_mt_version, l_mt_desc, l_Template, l_MtToTransfer_Rec.test_method,
                                     '0') THEN
                     COMMIT;
                  ELSE
                     -- Not all method definitions are transferred
                     ROLLBACK;
                     l_result := FALSE;
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     -- Log an error in ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to transfer test method "'||l_MtToTransfer_Rec.test_method||
                                   '" | description="'||l_MtToTransfer_rec.tm_desc||'" to Unilab: '||SQLERRM);
                     -- Not all methods are transferred
                     ROLLBACK;
                     l_result := FALSE;
               END;
            END LOOP;
         END IF;
      END IF;

      -- End the remote transaction
      IF NOT PA_LIMS.f_EndRemoteTransaction THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;
      COMMIT;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (l_result);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the methods for plant "'||PA_LIMS.f_ActivePlant||'": "'||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         -- End the remote transaction
         IF NOT PA_LIMS.f_EndRemoteTransaction THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,PA_LIMS.c_Msg_Aborted);
         END IF;
         ROLLBACK;
         RETURN (FALSE);
   END f_TransferCfgAllMt;

   PROCEDURE InitPrMtAssignFreqFromTemplate(
      a_template_pr              IN     VARCHAR2,
      a_mt                       IN     VARCHAR2,
      a_nr_measur                OUT    NUMBER,
      a_unit                     OUT    VARCHAR2,
      a_format                   OUT    VARCHAR2,
      a_allow_add                OUT    CHAR,
      a_ignore_other             OUT    CHAR,
      a_accuracy                 OUT    NUMBER,
      a_freq_tp                  OUT    CHAR,
      a_freq_val                 OUT    NUMBER,
      a_freq_unit                OUT    VARCHAR2,
      a_invert_freq              OUT    CHAR,
      a_st_based_freq            OUT    CHAR,
      a_last_sched               OUT    DATE,
      a_last_cnt                 OUT    NUMBER, 
      a_last_val                 OUT    VARCHAR2,
      a_inherit_au               OUT    CHAR)
   IS
      ----------------------------------------------------------------------------------------------------------
      -- ** Purpose **
      -- Fetch prmt link from matching entry in the template pr
      -- ** Note **
      -- This is a first implementation, it will first try to find a mt with the mt id 
      -- When no matching id is found the assignment frequency of the first mt found is used
      --When the template does not contain anything hardcoded values are used (corresponding to frequency Always)
      ----------------------------------------------------------------------------------------------------------
   CURSOR l_first_matching_mt_cursor IS
      SELECT nr_measur, unit, format, allow_add, ignore_other, accuracy,  
             freq_tp, freq_val, freq_unit, invert_freq, st_based_freq,
             last_cnt, last_val, inherit_au
      FROM uvprmt@LNK_LIMS
      WHERE (pr, version) =
           (SELECT pr, version 
            FROM uvpr@LNK_LIMS 
            WHERE pr=a_template_pr 
            AND version_is_current='1')
      AND mt= a_mt
      ORDER BY seq;
   CURSOR l_first_mt_cursor IS
      SELECT nr_measur, unit, format, allow_add, ignore_other, accuracy,  
             freq_tp, freq_val, freq_unit, invert_freq, st_based_freq,
             last_cnt, last_val, inherit_au
      FROM uvprmt@LNK_LIMS
      WHERE (pr, version) =
           (SELECT pr, version 
            FROM uvpr@LNK_LIMS 
            WHERE pr=a_template_pr 
            AND version_is_current='1')
      ORDER BY seq;
      
   BEGIN
      IF PA_LIMS.g_use_template_details = '1' AND
         a_template_pr IS NOT NULL THEN
         OPEN l_first_matching_mt_cursor;
         FETCH l_first_matching_mt_cursor
         INTO a_nr_measur, a_unit, a_format, a_allow_add, a_ignore_other, a_accuracy,
              a_freq_tp, a_freq_val, a_freq_unit, a_invert_freq, a_st_based_freq,
              a_last_cnt, a_last_val, a_inherit_au;         
         IF l_first_matching_mt_cursor%NOTFOUND THEN
            CLOSE l_first_matching_mt_cursor;
            OPEN l_first_mt_cursor;
            FETCH l_first_mt_cursor
            INTO a_nr_measur, a_unit, a_format, a_allow_add, a_ignore_other, a_accuracy,
              a_freq_tp, a_freq_val, a_freq_unit, a_invert_freq, a_st_based_freq,
              a_last_cnt, a_last_val, a_inherit_au;
            IF l_first_mt_cursor%NOTFOUND THEN
               a_nr_measur    := 1;
               a_unit         := NULL;
               a_format       := NULL;
               a_allow_add    := '1';
               a_allow_add    := '1';
               a_ignore_other := '0';               
               a_accuracy     := 1;               
               a_freq_tp     := 'A';
               a_freq_val    := 0;
               a_freq_unit   := 'DD';
               a_invert_freq := '0';
               a_st_based_freq := '0';
               a_last_cnt    := 0;
               a_last_val    := '';
               a_last_sched  := NULL;
               a_inherit_au  := '1';
            END IF;
            CLOSE l_first_mt_cursor;
         ELSE
            CLOSE l_first_matching_mt_cursor;
         END IF;
         --last_sched was a problem in other places of the interface, we avoid also the problem here
         a_last_sched := NULL;
      ELSE
         a_nr_measur    := 1;
         a_unit         := NULL;
         a_format       := NULL;
         a_allow_add    := '1';
         a_allow_add    := '1';
         a_ignore_other := '0';               
         a_accuracy     := 1;               
         a_freq_tp     := 'A';
         a_freq_val    := 0;
         a_freq_unit   := 'DD';
         a_invert_freq := '0';
         a_st_based_freq := '0';
         a_last_cnt    := 0;
         a_last_val    := '';
         a_last_sched  := NULL;
         a_inherit_au  := '1';
      END IF;
   END InitPrMtAssignFreqFromTemplate;

   FUNCTION f_TransferCfgPrMt(
      a_pr          IN     VARCHAR2,
      a_version     IN OUT VARCHAR2,
      a_mt          IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_mt_version  IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows  IN     NUMBER,
      a_template_pr IN     VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer the link between the method definition and the parameter definition
      -- ** Parameters **
      -- a_pr           : parameter definition
      -- a_version      : version of the parameter definition
      -- a_mt           : method definition assigned to the parameter definition
      -- a_mt_version   : version of the method definition
      -- a_nr_of_rows   : number of method definitions to save
      -- ** Return **
      -- TRUE: The transfer of the link has succeeded.
      -- FALSE : The transfer of the link has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12)                      := 'LimsCfg';
      l_method      CONSTANT VARCHAR2(32)                      := 'f_TransferCfgPrMt';
      l_object      VARCHAR2(255);
      l_objects     VARCHAR2(255);

      -- General variables
      l_row                  INTEGER;
      l_insert               BOOLEAN                           DEFAULT FALSE;
      l_newversion           BOOLEAN                           DEFAULT FALSE;
      l_version              VARCHAR2(20);
      l_modified             BOOLEAN                           DEFAULT FALSE;
      l_remove_tab           UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_new_tab              UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the API's 'GetPrMethod' and 'SavePrMethod'
      l_return_value_get     INTEGER;
      l_nr_of_rows           NUMBER                            := 999;
      l_where_clause         VARCHAR2(255);
      l_pr_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_version_tab       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_version_tab       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_description_tab      UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_nr_measur_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_unit_tab             UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_format_tab           UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_allow_add_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_ignore_other_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_accuracy_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_freq_tp_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_val_tab         UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_unit_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_invert_freq_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_st_based_freq_tab    UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_last_sched_tab       UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_last_cnt_tab         UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_last_val_tab         UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_return_value_save    INTEGER;
      l_pr                   VARCHAR2(20);
      l_pr_version           VARCHAR2(20);
      l_modify_reason        VARCHAR2(255);
      l_nr_of_rows_save      NUMBER;

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_pr_lc                  VARCHAR2(2);
      l_pr_lc_version          VARCHAR2(20);
      l_pr_ss                  VARCHAR2(2);
      l_pr_log_hs              CHAR(1);
      l_pr_allow_modify        CHAR(1);
      l_pr_active              CHAR(1);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Pr||' | '||a_version, a_nr_of_rows, NULL,
                      PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'parameter "'||a_pr||'" | version='||a_version;
      IF a_nr_of_rows>0 THEN
         --pass first array element as information in case of tracing
         l_objects := 'the link for pr/mt method(1)="'||a_Mt(1)||'" | version(1)='||a_mt_version(1)||' and '||l_object;
      ELSE
         l_objects := 'the link for method with nr_of_rows=0 in mt array';
      END IF;
      l_nr_of_rows_save := 0;
      FOR a_row IN 1..a_nr_of_rows LOOP
         l_new_tab(a_row) := '1';
      END LOOP;

      -- Fill in the parameters to get the standard attributes of the link
      -- between the method definitions and the parameter definition.
      l_nr_of_rows := 999;
      l_where_clause := 'WHERE pr='''||REPLACE(a_pr,'''','''''')||''' AND version = '''||
                        a_version||''' ORDER BY seq';
      -- Get the standard attributes of the link between the method definitions and the parameter definition.
      l_return_value_get := UNAPIPR.GETPRMETHOD@LNK_LIMS(l_pr_tab, l_pr_version_tab, l_mt_tab, l_mt_version_tab,
                               l_description_tab, l_nr_measur_tab, l_unit_tab, l_format_tab, l_allow_add_tab,
                               l_ignore_other_tab, l_accuracy_tab, l_freq_tp_tab, l_freq_val_tab, l_freq_unit_tab,
                               l_invert_freq_tab, l_st_based_freq_tab, l_last_sched_tab, l_last_cnt_tab,
                               l_last_val_tab, l_inherit_au_tab, l_nr_of_rows, l_where_clause);
      -- Check if a link between method definitions and the parameter definition exists in Unilab
      -- If no link is found then it must be created.
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- When there are no records found, l_nr_of_rows=100. That's why it is reset to 0.
         l_nr_of_rows := 0;
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         FOR l_row IN 1..l_nr_of_rows LOOP
            -- Mark the old method definitions that have to be removed
            -- Initialize variable
            l_remove_tab(l_row) := '1';
            FOR a_row IN 1..a_nr_of_rows LOOP
               IF (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_mt_tab(l_row),a_mt(a_row))                 = 1) AND
                  (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_mt_version_tab(l_row),a_mt_version(a_row)) = 1) THEN
                  l_remove_tab(l_row) := '0';
                  l_new_tab(a_row) := '0';
                  --please do not exit for duplicates - otherwise it will generate a new version at Unilab side finally
                  --EXIT;
               END IF;
            END LOOP;
            -- Remove the old method definitions
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_remove_tab(l_row),'0') = 1 THEN
               l_nr_of_rows_save := l_nr_of_rows_save + 1;
               l_mt_tab(l_nr_of_rows_save)         := l_mt_tab(l_row);
               l_mt_version_tab(l_nr_of_rows_save) := l_mt_version_tab(l_row);
               l_nr_measur_tab(l_nr_of_rows_save)  := l_nr_measur_tab(l_row);
               l_unit_tab(l_nr_of_rows_save)       := l_unit_tab(l_row);
               l_format_tab(l_nr_of_rows_save)     := l_format_tab(l_row);
               l_allow_add_tab(l_nr_of_rows_save)  := l_allow_add_tab(l_row);
               l_ignore_other_tab(l_nr_of_rows_save) := l_ignore_other_tab(l_row);
               l_accuracy_tab(l_nr_of_rows_save)   := l_accuracy_tab(l_row);
               l_freq_tp_tab(l_nr_of_rows_save)    := l_freq_tp_tab(l_row);
               l_freq_val_tab(l_nr_of_rows_save)   := l_freq_val_tab(l_row);
               l_freq_unit_tab(l_nr_of_rows_save)  := l_freq_unit_tab(l_row);
               l_invert_freq_tab(l_nr_of_rows_save):= l_invert_freq_tab(l_row);
               l_st_based_freq_tab(l_nr_of_rows_save) := l_st_based_freq_tab(l_row);
               l_last_sched_tab(l_nr_of_rows_save) := l_last_sched_tab(l_row);
               l_last_cnt_tab(l_nr_of_rows_save)   := l_last_cnt_tab(l_row);
               l_last_val_tab(l_nr_of_rows_save)   := l_last_val_tab(l_row);
               l_inherit_au_tab(l_nr_of_rows_save) := l_inherit_au_tab(l_row);
            ELSE
               -- A new minor version only has to be created if something has been modified eg. method definitions removed
               l_modified := TRUE;
            END IF;
         END LOOP;
      ELSE
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to retrieve the standard attributes of the link between the methods and '||
                       l_object||' (Error code : '||l_return_value_get||').');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      FOR a_row IN 1..a_nr_of_rows LOOP
         -- Add the new method definitions
         IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_new_tab(a_row),'1') = 1 THEN
            l_nr_of_rows_save := l_nr_of_rows_save + 1;
            l_mt_tab(l_nr_of_rows_save)         := a_mt(a_row);
            l_mt_version_tab(l_nr_of_rows_save) := a_mt_version(a_row);
            InitPrMtAssignFreqFromTemplate(a_template_pr, a_mt(a_row),
                                           l_nr_measur_tab(l_nr_of_rows_save), l_unit_tab(l_nr_of_rows_save), 
                                           l_format_tab(l_nr_of_rows_save), l_allow_add_tab(l_nr_of_rows_save),
                                           l_ignore_other_tab(l_nr_of_rows_save), l_accuracy_tab(l_nr_of_rows_save),
                                           l_freq_tp_tab(l_nr_of_rows_save), l_freq_val_tab(l_nr_of_rows_save), l_freq_unit_tab(l_nr_of_rows_save),
                                           l_invert_freq_tab(l_nr_of_rows_save), l_st_based_freq_tab(l_nr_of_rows_save), l_last_sched_tab(l_nr_of_rows_save),
                                           l_last_cnt_tab(l_nr_of_rows_save), l_last_val_tab(l_nr_of_rows_save), 
                                           l_inherit_au_tab(l_nr_of_rows_save));
            
            -- A new version only has to be created if something has been modified eg. method definitions added
            l_modified := TRUE;
         END IF;
      END LOOP;

      -- Get the authorisation of the parameter definition
      l_ret_code := UNAPIGEN.GETAUTHORISATION@LNK_LIMS('pr', a_pr, a_version, l_pr_lc, l_pr_lc_version, l_pr_ss,
                                                       l_pr_allow_modify, l_pr_active, l_pr_log_hs);
      IF l_ret_code = PA_LIMS.DBERR_SUCCESS THEN
         -- Modifiable, method definitions can immediately be assigned
         l_insert := TRUE;
      ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
         IF l_modified THEN
            -- Not modifiable and method definitions have been added/removed
            -- => new version has to be created before method definitions can be assigned
            l_newversion := TRUE;
         END IF;
      ELSIF l_ret_code <> PA_LIMS.DBERR_SUCCESS THEN
         IF l_ret_code = PA_LIMS.DBERR_GENFAIL THEN
            -- Log an error to ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to get the authorisation of '||l_object||' (General failure! Error Code: '||
                          l_ret_code||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
         ELSE
            -- Log an error to ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to get the authorisation of '||l_object||' (Error code : '||l_ret_code||').');
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- If the parameter definition is not modifiable, a new version has to be created.
      IF l_newversion THEN
         l_version := a_version;
         /* is_historic is passed as 0 - creating an historic parameter in Unilab for an historic method */
         /* is not a case that must be supported since historic methods are not transferred */
         IF NOT f_TransferCfgPr(a_pr, l_version, NULL, NULL, NULL, '1', 0) THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
         a_version := l_version;
      END IF;

      -- Assign the new method definition
      IF (l_modified) THEN
         -- Fill in the parameters to save the standard attributes of the link
         -- between the method definitions and the parameter definition.
         l_modify_reason := 'Imported the link between the methods and parameter "'||
                            a_pr||'" from Interspec.';
         BEGIN
            -- Save the standard attributes of the link between the method definitions and the parameter definition.
            l_return_value_save := UNAPIPR.SAVEPRMETHOD@LNK_LIMS(a_pr, a_version, l_mt_tab, l_mt_version_tab,
                                      l_nr_measur_tab, l_unit_tab, l_format_tab, l_allow_add_tab, l_ignore_other_tab,
                                      l_accuracy_tab, l_freq_tp_tab, l_freq_val_tab, l_freq_unit_tab,
                                      l_invert_freq_tab, l_st_based_freq_tab, l_last_sched_tab, l_last_cnt_tab,
                                      l_last_val_tab, l_inherit_au_tab, l_nr_of_rows_save, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the standard attributes of '||l_objects||' (General failure! Error Code: '||
                                l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                                'Unable to save the standard attributes of '||l_objects||' (Error code : '||
                                l_return_value_save||').');
               END IF;

               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the standard attributes of '||l_objects||': '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      -- The link between the method definition and the parameter definition is already in Unilab.
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,'Nothing happened: '||PA_LIMS.c_Msg_Ended);
         RETURN (TRUE);
      END IF;

      -- Tracing
      IF a_nr_of_rows <0 THEN
         PA_LIMS.p_Trace(l_classname, l_method, a_pr||' | '||a_version, 'mt(1):'||a_mt(1)||' | '||a_mt_version(1), NULL, 
                         PA_LIMS.c_Msg_Ended);
      ELSE
         PA_LIMS.p_Trace(l_classname, l_method, a_pr||' | '||a_version, 'nr_of_rows in mt array=0', NULL, 
                      PA_LIMS.c_Msg_Ended);
      END IF;
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_objects||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferCfgPrMt;

   FUNCTION f_DeleteAllPrMt(
      a_pr          IN     VARCHAR2,
      a_version     IN     VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Delete all methods on the link for the specified parameter definition
      -- ** Parameters **
      -- a_pr           : parameter definition
      -- a_version      : version of the parameter definition
      -- ** Return **
      -- TRUE: The transfer of the link has succeeded.
      -- FALSE : The transfer of the link has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12)                      := 'LimsCfg';
      l_method      CONSTANT VARCHAR2(32)                      := 'f_DeleteAllPrMt';
      l_object      VARCHAR2(255);
      l_objects     VARCHAR2(255);

      -- Specific local variables for the API 'SavePrMethod'
      l_return_value_get     INTEGER;
      l_nr_of_rows           NUMBER;
      l_where_clause         VARCHAR2(255);
      l_pr_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_version_tab       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_version_tab       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_description_tab      UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_nr_measur_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_unit_tab             UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_format_tab           UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_allow_add_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_ignore_other_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_accuracy_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_freq_tp_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_val_tab         UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_unit_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_invert_freq_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_st_based_freq_tab    UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_last_sched_tab       UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_last_cnt_tab         UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_last_val_tab         UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_return_value_save    INTEGER;
      l_pr                   VARCHAR2(20);
      l_pr_version           VARCHAR2(20);
      l_modify_reason        VARCHAR2(255);
      l_nr_of_rows_save      NUMBER;

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Pr||' | '||a_version, NULL, NULL,
                      PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'parameter "'||a_pr||'" | version='||a_version;
      l_objects := 'the link for method with nr_of_rows=0 in mt array';
      l_nr_of_rows_save := 0;

      BEGIN
         -- Save the standard attributes of the link between the method definitions and the parameter definition.
         l_return_value_save := UNAPIPR.SAVEPRMETHOD@LNK_LIMS(a_pr, a_version, l_mt_tab, l_mt_version_tab,
                                   l_nr_measur_tab, l_unit_tab, l_format_tab, l_allow_add_tab, l_ignore_other_tab,
                                   l_accuracy_tab, l_freq_tp_tab, l_freq_val_tab, l_freq_unit_tab,
                                   l_invert_freq_tab, l_st_based_freq_tab, l_last_sched_tab, l_last_cnt_tab,
                                   l_last_val_tab, l_inherit_au_tab, l_nr_of_rows_save, l_modify_reason);
         -- If the error is a general failure then the SQLERRM must be logged, otherwise
         -- the error code is the Unilab error
         IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
            IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the standard attributes of '||l_objects||' (General failure! Error Code: '||
                             l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
            ELSE
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                             'Unable to save the standard attributes of '||l_objects||' (Error code : '||
                             l_return_value_save||').');
            END IF;

            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to save the standard attributes of '||l_objects||': '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_pr||' | '||a_version, 'nr_of_rows in mt array=0', NULL, 
                      PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_objects||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_DeleteAllPrMt;

   FUNCTION f_TransferCfgAllPrMt(
      a_PrId                  IN VARCHAR2,
      a_Property              IN property.property%TYPE,
      a_attribute             IN attribute.attribute%TYPE,
      a_template_pr           IN VARCHAr2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The links between test methods and properties are links between method
      -- definitions and parameter definitions in Unilab. The function
      -- transfers all links to Unilab if they have the following characteristics:
      --    - The test method is not historic (status = 0).
      --    - The test method belongs to a property.
      --    - The property is not historic (status = 0).
      --    - The property belongs to a property group.
      --    - The property group is not historic (status = 0).
      --    - The property group has a display format that is set up for LIMS
      --    - If preference setting 'Transfer All Cfg' = 0:
      --      the display format is used in a specification that is in the queue 
      --      to transfer (table itlimsjob).
      -- ** Parameters **
      -- a_prid                : parameter definition
      -- a_property            : property from which the parameter definition has been derived
      -- ** Return **
      -- TRUE: The transfer of all the links between a property and a method has succeeded.
      -- FALSE : The transfer of all the links between a property and a method has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'LimsCfg';
      l_method      CONSTANT VARCHAR2(32) := 'f_TransferCfgAllPrMt';

      -- General variables
      l_result               BOOLEAN      DEFAULT TRUE;
      l_pr_version           VARCHAR2(20);
      l_pr_desc              VARCHAR2(40);
      l_sp_revision          NUMBER;
      l_MtId                 VARCHAR2(20);
      l_mt_desc              VARCHAR2(40);
      l_tm_revision          NUMBER;
      l_prmt_tab             UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_prmt_version_tab     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_prmt_nr_of_rows      NUMBER;

      -- Cursors to get all the links between test methods and properties that have to be send to Unilab
      -- as a link between a method definition and a parameter definition:
      -- preference setting 'Transfer All Cfg' = 1
      CURSOR l_AllPrMtToTransfer_cursor(c_property property.property%TYPE, 
                                        c_attribute attribute.attribute%TYPE) 
      IS
         --methods without attributes
         SELECT DISTINCT mt.test_method,
                         f_mth_descr(1, mt.test_method, 0) mt_desc
                    FROM property_group pg,
                         property pr,
                         test_method mt,
                         property_group_list pgpr,
                         property_test_method prtm,
                         property_group_display pgly,
                         itlimsconfly lm
                   WHERE pg.status = 0
                     AND pr.status = 0
                     AND mt.status = 0
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = pr.property
                     AND prtm.property = pgpr.property
                     AND prtm.test_method = mt.test_method
                     AND pgly.property_group = pgpr.property_group
                     AND pgly.display_format = lm.layout_id                     
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pr.property = c_property 
         UNION
         --IMPORTANT to make a UNION since same method can be used in a property group 
         -- in combination with an attribute and in another without an attribute
         --
         --methods with attributes
         SELECT DISTINCT mt.test_method,
                         f_mth_descr(1, mt.test_method, 0) mt_desc
                    FROM property_group pg,
                         property pr,
                         test_method mt,
                         property_group_list pgpr,
                         property_test_method prtm,
                         attribute_property prat,
                         property_group_display pgly,
                         itlimsconfly lm
                   WHERE pg.status = 0
                     AND pr.status = 0
                     AND mt.status = 0
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = pr.property
                     AND prtm.property = pgpr.property
                     AND prtm.test_method = mt.test_method
                     AND prat.property = pgpr.property
                     AND prat.attribute = c_attribute
                     AND pgly.property_group = pgpr.property_group
                     AND pgly.display_format = lm.layout_id
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pr.property = c_property
                ORDER BY 1;

      -- Cursors to get all the links between test methods and properties that have to be send to Unilab
      -- as a link between a method definition and a parameter definition:
      -- preference setting 'Transfer All Cfg' = 0
      CURSOR l_PrMtToTransfer_cursor(c_plant plant.plant%TYPE, 
                                     c_property property.property%TYPE, 
                                     c_attribute attribute.attribute%TYPE) 
      IS
         --methods without attributes
         SELECT DISTINCT mt.test_method,
                         f_mth_descr(1, mt.test_method, 0) mt_desc
                    FROM property_group pg,
                         test_method mt,
                         ivpgpr pgpr,
                         itlimsconfly lm,
                         ivlimsjob ls
                   WHERE pgpr.property_group IS NOT NULL
                     AND pgpr.test_method IS NOT NULL
                     AND pg.status = 0
                     AND mt.status = 0
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = c_property
                     AND pgpr.test_method = mt.test_method
                     AND pgpr.display_format = lm.layout_id
                     AND pgpr.display_format_rev = lm.layout_rev
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pgpr.part_no = ls.part_no
                     AND pgpr.revision = ls.revision
                     AND pgpr.type = 1
                     AND pgpr.attribute = 0
                     AND ls.plant = c_plant
         UNION
         --IMPORTANT to make a UNION since same method can be used in a property group/specification section 
         -- in combination with an attribute and in another without an attribute
         --
         --methods with attributes
         SELECT DISTINCT mt.test_method,
                         f_mth_descr(1, mt.test_method, 0) mt_desc
                    FROM property_group pg,
                         test_method mt,
                         ivpgpr pgpr,
                         itlimsconfly lm,
                         ivlimsjob ls
                   WHERE pgpr.property_group IS NOT NULL
                     AND pgpr.test_method IS NOT NULL
                     AND pg.status = 0
                     AND mt.status = 0
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = c_property
                     AND pgpr.test_method = mt.test_method
                     AND pgpr.display_format = lm.layout_id
                     AND pgpr.display_format_rev = lm.layout_rev
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pgpr.part_no = ls.part_no
                     AND pgpr.revision = ls.revision
                     AND pgpr.type = 1
                     AND pgpr.attribute <> 0
                     AND pgpr.attribute = c_attribute
                     AND ls.plant = c_plant         ORDER BY 1;

      -- Cursors to get all the links between test methods and properties that have to be send to Unilab
      -- as a link between a method definition and a parameter definition:
      -- preference setting 'Transfer All Cfg' = 0
      -- handle also all plants that have the same connection string and language id as the given plant
      CURSOR l_SimilarPrMtToTransfer_cursor(c_plant plant.plant%TYPE, 
                                            c_property property.property%TYPE,
                                            c_attribute attribute.attribute%TYPE) 
      IS
         SELECT DISTINCT mt.test_method,
                         f_mth_descr(1, mt.test_method, 0) mt_desc
                    FROM property_group pg,
                         test_method mt,
                         ivpgpr pgpr,
                         itlimsconfly lm,
                         ivlimsjob ls,
                         itlimsplant pl
                   WHERE pgpr.property_group IS NOT NULL
                     AND pgpr.test_method IS NOT NULL
                     AND pg.status = 0
                     AND mt.status = 0
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = c_property
                     AND pgpr.test_method = mt.test_method
                     AND pgpr.display_format = lm.layout_id
                     AND pgpr.display_format_rev = lm.layout_rev
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pgpr.part_no = ls.part_no
                     AND pgpr.revision = ls.revision
                     AND pgpr.type = 1
                     AND pgpr.attribute = 0
                     AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                             (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                                FROM itlimsplant pl2
                               WHERE pl2.plant = c_plant)
                     AND pl.plant = ls.plant
         UNION
         --IMPORTANT to make a UNION since same method can be used in a property group/specification section 
         -- in combination with an attribute and in another without an attribute
         --
         --methods with attributes
         SELECT DISTINCT mt.test_method,
                         f_mth_descr(1, mt.test_method, 0) mt_desc
                    FROM property_group pg,
                         test_method mt,
                         ivpgpr pgpr,
                         itlimsconfly lm,
                         ivlimsjob ls,
                         itlimsplant pl
                   WHERE pgpr.property_group IS NOT NULL
                     AND pgpr.test_method IS NOT NULL
                     AND pg.status = 0
                     AND mt.status = 0
                     AND pgpr.property_group = pg.property_group
                     AND pgpr.property = c_property
                     AND pgpr.test_method = mt.test_method
                     AND pgpr.display_format = lm.layout_id
                     AND pgpr.display_format_rev = lm.layout_rev
                     AND lm.un_object IN ('PR', 'PPPR')
                     AND pgpr.part_no = ls.part_no
                     AND pgpr.revision = ls.revision
                     AND pgpr.type = 1
                     AND pgpr.attribute <> 0
                     AND pgpr.attribute = c_attribute
                     AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                             (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                                FROM itlimsplant pl2
                               WHERE pl2.plant = c_plant)
                     AND pl.plant = ls.plant
         ORDER BY 1;

      PROCEDURE HandleAllPrMt(c_test_method IN NUMBER, c_tm_desc IN VARCHAR2) IS
      BEGIN 
         -- Generate the method definition id, version and description,
         -- based on the highest revision of the test method
         l_tm_revision := PA_LIMS.f_GetHighestRevision('test_method', c_test_method);
         l_MtId := PA_LIMS.f_GetMtId(c_test_method, l_tm_revision, c_tm_desc, l_mt_desc);

         -- Add the method definition to an array, the transfer will be done at the end.
         l_prmt_nr_of_rows := l_prmt_nr_of_rows + 1;
         l_prmt_tab(l_prmt_nr_of_rows)          := l_mtid;
         -- Generate the version of the method definition for the link
         l_prmt_version_tab(l_prmt_nr_of_rows)  := '~Current~';
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer the link between method "'||l_mtid||
                          '" | version=~Current~ and parameter "'||a_Prid||'" | version='||l_Pr_version||
                          ' : '||SQLERRM);
            -- Not all links between test methods and properties are transferred
            ROLLBACK;
            l_result := FALSE;
      END HandleAllPrMt;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_PrId, a_property, NULL, PA_LIMS.c_Msg_Started);

      -- Start the remote transaction
--      IF NOT PA_LIMS.f_StartRemoteTransaction THEN
--         -- Tracing
--         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
--         RETURN (FALSE);
--      END IF;
      
      -- Initialize variables
      l_pr_version := f_GetObjectVersion('pr',a_prid);
      l_prmt_nr_of_rows := 0;

      -- Transfer the links between the method definitions and the parameter definitions to Unilab
      -- Check if all configuration data has to be transferred
      IF PA_LIMS.f_GetSettingValue('Transfer All Cfg') = '1' THEN
         FOR l_AllPrMtToTransfer_rec IN l_AllPrMtToTransfer_cursor(a_property, a_attribute) LOOP
            HandleAllPrMt(l_AllPrMtToTransfer_Rec.test_method, l_AllPrMtToTransfer_Rec.mt_desc);
         END LOOP;
      ELSE
         IF g_handle_similar THEN
            FOR l_SimilarPrMtToTransfer_rec IN l_SimilarPrMtToTransfer_cursor(PA_LIMS.f_ActivePlant, a_property, a_attribute) LOOP
               HandleAllPrMt(l_SimilarPrMtToTransfer_Rec.test_method, l_SimilarPrMtToTransfer_Rec.mt_desc);
            END LOOP;
         ELSE
            FOR l_PrMtToTransfer_rec IN l_PrMtToTransfer_cursor(PA_LIMS.f_ActivePlant, a_property, a_attribute) LOOP
               HandleAllPrMt(l_PrMtToTransfer_Rec.test_method, l_PrMtToTransfer_Rec.mt_desc);
            END LOOP;
         END IF;
      END IF;

      -- Execute once for the last parameter definition
      --
      -- This step has to be repeated here, because if it is not in the mt list anymore, it will be removed from the pr.
      IF (PA_LIMS.f_GetSettingValue('MT Based On PR') = '1') THEN
         -- Add the method definition to an array, the transfer will be done at the end.
         l_prmt_nr_of_rows := l_prmt_nr_of_rows + 1;
         l_prmt_tab(l_prmt_nr_of_rows)          := a_PrId;
         -- Generate the version of the method definition for the link
         l_prmt_version_tab(l_prmt_nr_of_rows)  := '~Current~';
      END IF;
      -- Transfer the link between the method definition and the parameter definition
      IF f_TransferCfgPrMt(a_PrId, l_pr_version, l_prmt_tab, l_prmt_version_tab, l_prmt_nr_of_rows, a_template_pr) THEN
         -- Not all links between test methods and properties are transferred
         COMMIT;
      ELSE
         ROLLBACK;
         l_result := FALSE;
      END IF;

      -- End the remote transaction
--      IF NOT PA_LIMS.f_EndRemoteTransaction THEN
--         -- Tracing
--         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
--         RETURN (FALSE);
--      END IF;
      COMMIT;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (l_result);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the links between methods and parameters for plant "'||
                       PA_LIMS.f_ActivePlant||'" : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         -- End the remote transaction
--         IF NOT PA_LIMS.f_EndRemoteTransaction THEN
--            -- Tracing
--            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
--         END IF;
         ROLLBACK;
         RETURN (FALSE);
   END f_TransferCfgAllPrMt;

   FUNCTION f_TransferCfgGkSt(
      a_gk             IN VARCHAR2,
      a_description    IN VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer a groupkey for a sampletype from Interspec to Unilab
      -- ** Parameters **
      -- a_gk          : groupkey for a sampletype
      -- a_description : description of the groupkey
      -- ** Return **
      -- TRUE: The transfer of the groupkey has succeeded.
      -- FALSE : The transfer of the groupkey has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsCfg';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferCfgGkSt';
      l_object       VARCHAR2(255);

      -- General variables
      l_a_description         VARCHAR2(40);

      -- Specific local variables for the 'GetGroupKeySt' API
      l_return_value_get      INTEGER;
      l_nr_of_rows            NUMBER                            := 999;
      l_where_clause          VARCHAR2(255);
      l_gk_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_description_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_is_protected_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_unique_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_single_valued_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_new_val_allowed_tab   UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_mandatory_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_struct_created_tab    UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_inherit_gk_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_list_tp_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_default_value_tab     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_dsp_rows_tab          UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_val_length_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_val_start_tab         UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_assign_tp_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_assign_id_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_q_tp_tab              UNAPIGEN.CHAR2_TABLE_TYPE@LNK_LIMS;
      l_q_id_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_q_check_au_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_q_au_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'SaveGroupKeySt' API
      l_return_value_save     INTEGER;
      l_gk                    VARCHAR2(20);
      l_description           VARCHAR2(40);
      l_is_protected          CHAR(1);
      l_value_unique          CHAR(1);
      l_single_valued         CHAR(1);
      l_new_val_allowed       CHAR(1);
      l_mandatory             CHAR(1);
      l_struct_created        CHAR(1);
      l_inherit_gk            CHAR(1);
      l_value_list_tp         CHAR(1);
      l_default_value         VARCHAR2(40);
      l_dsp_rows              NUMBER;
      l_val_length            NUMBER;
      l_val_start             NUMBER;
      l_assign_tp             CHAR(1);
      l_assign_id             VARCHAR2(20);
      l_q_tp                  CHAR(2);
      l_q_id                  VARCHAR2(20);
      l_q_check_au            CHAR(1);
      l_q_au                  VARCHAR2(20);
      l_modify_reason         VARCHAR2(255);
      l_value_tab             UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_sqltext_tab           UNAPIGEN.VC255_TABLE_TYPE@LNK_LIMS;

      -- Cursor to get the sql-statement of the groupkey
      CURSOR l_sql_cursor (c_gk VARCHAR2)
      IS
         SELECT sqltext
           FROM UVGKSTSQL@LNK_LIMS
          WHERE gk = c_gk
          ORDER BY seq;

     -- Cursor to get all possible values of the groupkey
     CURSOR l_list_cursor (c_gk VARCHAR2)
     IS
        SELECT value
          FROM UVGKSTLIST@LNK_LIMS
         WHERE gk = c_gk
         ORDER BY seq;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_gk, a_description, NULL, PA_LIMS.c_Msg_Started);
      -- Convert the arguments to their maximum length
      l_a_description := SUBSTR(a_description, 1, 40);
      -- Initializing variables
      l_object := 'sample type groupkey "'||a_Gk||'" | description="'||l_a_description||'"';

      -- Fill in the parameters to get the standard attributes of the groupkey
      l_where_clause := a_gk;
      -- Get the standard attributes of the groupkey
      l_return_value_get := UNAPIGK.GETGROUPKEYST@LNK_LIMS(l_gk_tab, l_description_tab, l_is_protected_tab,
                               l_value_unique_tab, l_single_valued_tab, l_new_val_allowed_tab, l_mandatory_tab,
                               l_struct_created_tab, l_inherit_gk_tab, l_value_list_tp_tab, l_default_value_tab,
                               l_dsp_rows_tab, l_val_length_tab, l_val_start_tab, l_assign_tp_tab, l_assign_id_tab,
                               l_q_tp_tab, l_q_id_tab, l_q_check_au_tab, l_q_au_tab, l_nr_of_rows,l_where_clause);
      -- Check if the groupkey exists in Unilab. If the groupkey is
      -- not found then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- Fill in the parameters to save the standard attributes of the groupkey
         l_gk              := a_gk;
         l_description     := l_a_description;
         l_modify_reason   := 'Imported sample type groupkey "'||a_gk||'" from Interspec.';
         l_is_protected    := '0';
         l_value_unique    := '0';
         l_single_valued   := '0';
         l_new_val_allowed := '1';
         l_mandatory       := '0';
         l_struct_created  := '0';
         l_inherit_gk      := '0';
         l_value_list_tp   := 'F';
         l_default_value   := '';
         l_dsp_rows        := 10;
         l_val_length      := 20;
         l_val_start       := 1;
         l_nr_of_rows      := 1;
         l_assign_tp       := '';
         l_q_tp            := '';
         l_q_id            := '';
         l_q_check_au      := '';
         l_q_au            := '';
         FOR l_row IN 1 .. l_nr_of_rows LOOP
            l_value_tab(l_row) := '';
            l_sqltext_tab(l_row) := '';
         END LOOP;
         BEGIN
            -- Save the standard attributes of the groupkey
            l_return_value_save := UNAPIGK.SAVEGROUPKEYST@LNK_LIMS(l_gk, l_description, l_is_protected, 
                                      l_value_unique, l_single_valued, l_new_val_allowed, l_mandatory, 
                                      l_struct_created, l_inherit_gk, l_value_list_tp, l_default_value, l_dsp_rows,
                                      l_val_length, l_val_start, l_assign_tp, l_assign_id, l_q_tp, l_q_id, 
                                      l_q_check_au, l_q_au, l_value_tab, l_sqltext_tab, l_nr_of_rows, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save '||l_object||' (General failure! Error Code: '||l_return_value_save||
                                ' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save '||l_object||' (Error code : '||l_return_value_save||').');
               END IF;

               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                             'Unable to save '||l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted );
               RETURN (FALSE);
         END;
      -- When the groupkey is already in Unilab, it must be checked if it has been updated
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         -- Check if the description has been updated
         IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_description_tab(l_nr_of_rows), l_a_description) = 1 THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Nothing happened: '||PA_LIMS.c_Msg_Ended);
            RETURN (TRUE);
         END IF;

         -- Fill in the parameters to save the standard attributes of the groupkey
         l_gk                        := a_gk;
         l_description               := l_a_description;
         l_modify_reason             := 'Imported modified standard attributes of sample type groupkey "'||a_gk||
                                        '" from Interspec.';
         l_is_protected              := l_is_protected_tab(l_nr_of_rows);
         l_value_unique              := l_value_unique_tab(l_nr_of_rows);
         l_single_valued             := l_single_valued_tab(l_nr_of_rows);
         l_new_val_allowed           := l_new_val_allowed_tab(l_nr_of_rows);
         l_mandatory                 := l_mandatory_tab(l_nr_of_rows);
         l_struct_created            := l_struct_created_tab(l_nr_of_rows);
         l_inherit_gk                := l_inherit_gk_tab(l_nr_of_rows);
         l_value_list_tp             := l_value_list_tp_tab(l_nr_of_rows);
         l_default_value             := l_default_value_tab(l_nr_of_rows);
         l_dsp_rows                  := l_dsp_rows_tab(l_nr_of_rows);
         l_val_length                := l_val_length_tab(l_nr_of_rows);
         l_val_start                 := l_val_start_tab(l_nr_of_rows);
         l_assign_tp                 := l_assign_tp_tab(l_nr_of_rows);
         l_assign_id                 := l_assign_id_tab(l_nr_of_rows);
         l_q_tp                      := l_q_tp_tab(l_nr_of_rows);
         l_q_id                      := l_q_id_tab(l_nr_of_rows);
         l_q_check_au                := l_q_check_au_tab(l_nr_of_rows);
         l_q_au                      := l_q_au_tab(l_nr_of_rows);
         l_nr_of_rows                := 0;
         IF l_value_list_tp = 'Q' THEN
            FOR l_sql_rec IN l_sql_cursor(a_gk) LOOP
               l_nr_of_rows := l_nr_of_rows + 1;
               l_sqltext_tab(l_nr_of_rows) := l_sql_rec.sqltext;
            END LOOP;
         ELSIF l_value_list_tp = 'F' THEN
            FOR l_list_rec IN l_list_cursor(a_gk) LOOP
               l_nr_of_rows := l_nr_of_rows + 1;
               l_value_tab(l_nr_of_rows) := l_list_rec.value;
            END LOOP;
         END IF;
         BEGIN
            -- Save the standard attributes of the groupkey
            l_return_value_save := UNAPIGK.SAVEGROUPKEYST@LNK_LIMS(l_gk, l_description, l_is_protected, 
                                      l_value_unique, l_single_valued, l_new_val_allowed, l_mandatory, 
                                      l_struct_created, l_inherit_gk, l_value_list_tp, l_default_value, l_dsp_rows,
                                      l_val_length, l_val_start, l_assign_tp, l_assign_id, l_q_tp, l_q_id, 
                                      l_q_check_au, l_q_au, l_value_tab, l_sqltext_tab, l_nr_of_rows, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the modified description of '||l_object||' (General failure! Error Code: '||
                                l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the modified description of '||l_object||' (Error code : '||
                                l_return_value_save||').');
               END IF;

               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the modified description of '||l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted );
               RETURN (FALSE);
         END;
      ELSE
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to retrieve the standard attributes of '||l_object||' (Error code : '||l_return_value_get||').');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_object||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferCfgGkSt;

   FUNCTION f_TransferCfgAllGkSt
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The groupkeys for a sampletype are keywords in Interspec. The function
      -- transfers all keywords to Unilab if they have the following characteristics:
      --    - The keyword is not historic (status = 0).
      --    - The keyword belongs to a specification
      -- ** Return **
      -- TRUE: The transfer of all the keywords has succeeded.
      -- FALSE : The transfer of all the keywords has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'LimsCfg';
      l_method      CONSTANT VARCHAR2(32) := 'f_TransferCfgAllGkSt';

      -- General variables
      l_result               BOOLEAN      DEFAULT TRUE;
      l_gkId                 VARCHAR2(20);

      -- Cursor to get all the keywords that have to be send to Unilab as a groupkey
      CURSOR l_GkStToTransfer_cursor
      IS
         SELECT DISTINCT kw.kw_id, kw.description
           FROM itkw kw, specification_kw speckw
          WHERE kw.kw_id = speckw.kw_id;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);

      -- Start the remote transaction
      IF NOT PA_LIMS.f_StartRemoteTransaction THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted );
         RETURN (FALSE);
      END IF;

      -- Transfer all the groupkeys to Unilab
      FOR l_GkStToTransfer_rec IN l_GkStToTransfer_cursor LOOP
         BEGIN
            -- Generate the groupkey id
            l_gkId := PA_LIMS.f_GetGkId(l_GkStToTransfer_rec.description);

            -- Transfer the groupkey
            IF f_TransferCfgGkSt(l_gkId, l_GkStToTransfer_rec.description) THEN
               -- Not all groupkeys are transferred
               COMMIT;
            ELSE
               ROLLBACK;
               l_result := FALSE;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer keyword "'||l_gkId||'" | description="'||
                             l_GkStToTransfer_rec.description||'" to Unilab: '||SQLERRM);
               -- Not all groupkeys are transferred
               ROLLBACK;
               l_result := FALSE;
         END;
      END LOOP;

      -- Set the pp keys
      IF NOT PA_LIMS.f_SetPpKeys(NULL, NULL, NULL) THEN
         -- Log an error to ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to set the parameterprofile keys.');
         l_result := FALSE;
      END IF;

      -- Transfer the groupkeys for the pp_keys to Unilab
      FOR i IN 1..5 LOOP
         BEGIN
            -- Check if the pp_key name is not null
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(PA_LIMS.g_pp_key_name(i), NULL) = 0 THEN
               -- Generate the groupkey id
               l_gkId := PA_LIMS.f_GetGkId(PA_LIMS.g_pp_key_name(i));
               -- Transfer the groupkey
               IF f_TransferCfgGkSt(l_gkId, PA_LIMS.g_pp_key_name(i)) THEN
                  -- Groupkey is not transferred
                  COMMIT;
               ELSE
                  ROLLBACK;
                  l_result := FALSE;
               END IF;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer "'||l_gkId||'" | description="'||PA_LIMS.g_pp_key_name(i)||
                             '" to Unilab: '||SQLERRM);
               -- Groupkey is not transferred
               ROLLBACK;
               l_result := FALSE;
         END;
      END LOOP;

      -- End the remote transaction
      IF NOT PA_LIMS.f_EndRemoteTransaction THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;
      COMMIT;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);      
      RETURN (l_result);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the keywords for plant "'||PA_LIMS.f_ActivePlant||'" : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         -- End the remote transaction
         IF NOT PA_LIMS.f_EndRemoteTransaction THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         END IF;
         ROLLBACK;
         RETURN (FALSE);
   END f_TransferCfgAllGkSt;

   FUNCTION f_TransferCfg
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer the configuration from Interspec to Unilab for the active
      -- plant. The configuration consists of:
      --    - The parameter definitions
      --    - The method definitions
      --    - The link between the method definitions and the parameter definitions
      --    - The groupkeys for a sampletype
      -- ** Return **
      -- TRUE: The transfer of the configuration has succeeded.
      -- FALSE : The transfer of the configuration has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'LimsCfg';
      l_method      CONSTANT VARCHAR2(32) := 'f_TransferCfg';

      -- General variables
      l_return_value         BOOLEAN;
      l_result               BOOLEAN      DEFAULT TRUE;

      --Specific local variables for InsertEvent
      l_ev_tp                       VARCHAR2(60);
      l_ev_details                  VARCHAR2(255);
      l_seq_nr                      NUMBER;
      l_ret_code                    INTEGER;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Initialize variables
      g_pr_nr_of_rows := 0;

      IF PA_LIMS.f_GetSettingValue('Transfer Cfg MT') = '1' THEN
         -- Transfer all the test methods to Unilab
         l_return_value := f_TransferCfgAllMt;
         IF NOT l_return_value THEN
            l_result := FALSE;
         END IF;
      END IF;

      -- Transfer all the properties to Unilab
      l_return_value := f_TransferCfgAllPr;
      IF NOT l_return_value THEN
         l_result := FALSE;
      END IF;

      -- Set the transferred parameter definitions to Approved
      FOR i IN 1..g_pr_nr_of_rows LOOP
         l_ev_tp := 'ObjectUpdated';               
         l_ev_details := 'version='||g_version_tab(i)||'#InterspecFinishedSaving';
         l_seq_nr := NULL;               
         l_ret_code := UNAPIEV.INSERTEVENT@LNK_LIMS
                     ('ChangePrStatus', '', 'pr', g_pr_tab(i), '',
                      '', '', l_ev_tp, l_ev_details, l_seq_nr);
         IF l_ret_code <> 0 THEN
             PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                           'InsertEvent for pr "'||g_pr_tab(i)||'" failed: '||l_ret_code);
         END IF;
      END LOOP;

      -- Transfer all the keywords to Unilab
      l_return_value := f_TransferCfgAllGkSt;
      IF NOT l_return_value THEN
         l_result := FALSE;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (l_result);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error to ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the configuration from Interspec to Unilab for plant "'||
                       PA_LIMS.f_ActivePlant||'": '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferCfg;

   FUNCTION f_TransferAllCfg(
      a_plant       IN VARCHAR2 DEFAULT NULL
   )
      RETURN NUMBER
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- IF parameter a_plant is not filled in THEN
      --    the procedure transfers the configuration from Interspec to Unilab
      --    for all the plants for which a connection string is configured.
      -- ELSE
      --    the procedure transfers only the configuration for that plant.
      -- END IF
      -- ** Parameters **
      -- a_plant : plant to which the configuration has to be transferred
      -- ** Return **
      -- TRUE: The transfer of the configuration has succeeded.
      -- FALSE : The transfer of the configuration has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'LimsCfg';
      l_method      CONSTANT VARCHAR2(32) := 'f_TransferAllCfg';

      -- General variables
      l_result      NUMBER                DEFAULT 1;
      l_lang_id     NUMBER(2);
      l_same        BOOLEAN               DEFAULT FALSE;
      l_job_nr      INTEGER;

      -- Cursor to get all the configured plants
      CURSOR l_plants_cursor
      IS
         SELECT plant, connect_string, lang_id, lang_id_4id
           FROM itlimsplant;

      -- Cursor to get the given plant
      CURSOR l_plant_cursor(c_plant plant.plant%TYPE)
      IS
         SELECT plant, connect_string, lang_id, lang_id_4id
           FROM itlimsplant
          WHERE plant = c_plant;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_plant, NULL, NULL, PA_LIMS.c_Msg_Started);

      -- Transfer the configuration for all the configured plants
      IF a_plant IS NULL THEN
         --Somebody pressed the TransferCOnfiguration button
         --this will no more perform the transfert immediately but wake-up the job
         --to run as fast as possible
         BEGIN
            SELECT job
            INTO l_job_nr
            FROM sys.DBA_JOBS
            WHERE what LIKE PA_LIMS.c_JobStringToSearch;
            DBMS_JOB.NEXT_DATE (l_job_nr, SYSDATE);
            l_result := 1;
            COMMIT;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer all the configuration from Interspec to Unilab: The job "'||PA_LIMS.c_JobStringToSearch||'" is not running');
            l_result := 0;
         END;
         
      -- Transfer the configuration for a specific plant
      ELSE
         l_result := f_TransferAllCfgInternal(a_plant);
      END IF;

      IF l_result = 1 THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
      END IF;
      RETURN(l_result);
   EXCEPTION
      WHEN OTHERS THEN
         -- Close the connection for the plant
         IF NOT PA_LIMS.f_CloseLimsConnection THEN
            PA_LIMS.p_Log(PA_LIMS.c_Source,  PA_LIMS.c_Applic, 'Unable to close the connection.');
         END IF;
         -- Log an error to ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unable to transfer all the configuration from Interspec to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         -- Clear the global arrays
         PA_LIMSSPC.g_nr_of_plants := 0;
         RETURN (0);
   END f_TransferAllCfg;

   FUNCTION f_TransferAllCfgInternal(
      a_plant       IN VARCHAR2 DEFAULT NULL
   )
      RETURN NUMBER
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- IF parameter a_plant is not filled in THEN
      --    the procedure transfers the configuration from Interspec to Unilab
      --    for all the plants for which a connection string is configured.
      -- ELSE
      --    the procedure transfers only the configuration for that plant.
      -- END IF
      -- ** Parameters **
      -- a_plant : plant to which the configuration has to be transferred
      -- ** Return **
      -- TRUE: The transfer of the configuration has succeeded.
      -- FALSE : The transfer of the configuration has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'LimsCfg';
      l_method      CONSTANT VARCHAR2(32) := 'f_TransferAllCfgInternal';

      -- General variables
      l_result      NUMBER                DEFAULT 1;
      l_lang_id     NUMBER(2);
      l_same        BOOLEAN               DEFAULT FALSE;

      -- Cursor to get all the configured plants
      CURSOR l_plants_cursor
      IS
         SELECT plant, connect_string, lang_id, lang_id_4id
           FROM itlimsplant;

      -- Cursor to get the given plant
      CURSOR l_plant_cursor(c_plant plant.plant%TYPE)
      IS
         SELECT plant, connect_string, lang_id, lang_id_4id
           FROM itlimsplant
          WHERE plant = c_plant;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_plant, NULL, NULL, PA_LIMS.c_Msg_Started);

      -- Transfer the configuration for all the configured plants
      IF a_plant IS NULL THEN
         g_handle_similar := TRUE;
         
         FOR l_plants_rec IN l_plants_cursor LOOP
            -- Check if a plant with the same connection string and language id has already been handled
            -- Loop all handled plants
            FOR i IN 1..PA_LIMSSPC.g_nr_of_plants LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_plants_rec.connect_string,PA_LIMSSPC.g_connect_string_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plants_rec.lang_id,PA_LIMSSPC.g_lang_id_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plants_rec.lang_id_4id,PA_LIMSSPC.g_lang_id_4id_tab(i)) = 1 THEN
                  l_same := TRUE;
                  EXIT;
               END IF;
            END LOOP;

            -- Add the info to the global arrays
            PA_LIMSSPC.g_nr_of_plants := PA_LIMSSPC.g_nr_of_plants + 1;
            PA_LIMSSPC.g_plant_tab(PA_LIMSSPC.g_nr_of_plants)          := l_plants_rec.plant;
            PA_LIMSSPC.g_connect_string_tab(PA_LIMSSPC.g_nr_of_plants) := l_plants_rec.connect_string;
            PA_LIMSSPC.g_lang_id_tab(PA_LIMSSPC.g_nr_of_plants)        := l_plants_rec.lang_id;
            PA_LIMSSPC.g_lang_id_4id_tab(PA_LIMSSPC.g_nr_of_plants)    := l_plants_rec.lang_id_4id;

            -- This plant has already been handled
            IF (l_same) THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 
                               'Nothing happened for plant "'||l_plants_rec.plant||'"');
               -- Re-initialize variable
               l_same := FALSE;
            -- This plant has not been handled yet
            ELSE
               -- Setup the connection for the plant
               IF NOT PA_LIMS.f_SetupLimsConnection(l_plants_rec.plant) THEN
                  l_result := 0;
               ELSE
                  -- Set the language in interspec 5.1 (exception handler necessary for compatibilty with 6.3)
                  -- pa_cnstnt.l_language := l_plants_rec.lang_id;
                  BEGIN EXECUTE IMMEDIATE 'BEGIN pa_cnstnt.l_language := :lang_id; END;'
                        USING l_plants_rec.lang_id;
                  EXCEPTION WHEN OTHERS THEN NULL; END;
                  --Modified in 6.1 sp1 (exception handler necessary for backward compatibility interspc 5.1)
                  BEGIN EXECUTE IMMEDIATE 'BEGIN iapiGeneral.SESSION.SETTINGS.LanguageId := :lang_id; END;'
                        USING l_plants_rec.lang_id;
                  EXCEPTION WHEN OTHERS THEN NULL; END;

                  -- Transfer the configuration for the plant
                  IF NOT f_TransferCfg THEN
                     l_result := 0;
                  END IF;
                  
                  -- Run the NewVersion Manager, to make the newly created objects current
                  PA_SPECXINTERFACE.P_NEWVERSIONMGR@LNK_LIMS;
                  
                  -- Close the connection for the plant
                  IF NOT Pa_Lims.f_CloseLimsConnection THEN
                     l_result := 0;
                  END IF;
               END IF;
            END IF;
         END LOOP;
         
         g_handle_similar := FALSE;
      -- Transfer the configuration for a specific plant
      ELSE
         FOR l_plant_rec IN l_plant_cursor(a_plant) LOOP
            l_lang_id := l_plant_rec.lang_id;

            -- Check if a plant with the same connection string and language id has already been handled
            -- Loop all handled plants
            FOR i IN 1..PA_LIMSSPC.g_nr_of_plants LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_plant_rec.connect_string,PA_LIMSSPC.g_connect_string_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plant_rec.lang_id,PA_LIMSSPC.g_lang_id_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plant_rec.lang_id_4id,PA_LIMSSPC.g_lang_id_4id_tab(i)) = 1 THEN
                  l_same := TRUE;
                  EXIT;
               END IF;
            END LOOP;

            -- Add the info to the global arrays
            PA_LIMSSPC.g_nr_of_plants := PA_LIMSSPC.g_nr_of_plants + 1;
            PA_LIMSSPC.g_plant_tab(PA_LIMSSPC.g_nr_of_plants)          := a_plant;
            PA_LIMSSPC.g_connect_string_tab(PA_LIMSSPC.g_nr_of_plants) := l_plant_rec.connect_string;
            PA_LIMSSPC.g_lang_id_tab(PA_LIMSSPC.g_nr_of_plants)        := l_plant_rec.lang_id;
            PA_LIMSSPC.g_lang_id_4id_tab(PA_LIMSSPC.g_nr_of_plants)    := l_plant_rec.lang_id_4id;
         END LOOP;

         -- This plant has already been handled
         IF (l_same) THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Nothing happened for plant "'||a_plant||'"');
            -- Re-initialize variable
            l_same := FALSE;
         -- This plant has not been handled yet
         ELSE
            -- Setup the connection for the plant
            IF NOT PA_LIMS.f_SetupLimsConnection(a_plant) THEN
               l_result := 0;
            ELSE
               -- Set the language in interspec 5.1 (exception handler necessary for compatibilty with 6.3)
               --pa_cnstnt.l_language := l_lang_id;
               BEGIN EXECUTE IMMEDIATE 'BEGIN pa_cnstnt.l_language := :lang_id; END;'
                     USING l_lang_id;
               EXCEPTION WHEN OTHERS THEN NULL; END;               
               --Modified in 6.1 sp1 (exception handler necessary for backward compatibility interspc 5.1)
               BEGIN EXECUTE IMMEDIATE 'BEGIN iapiGeneral.SESSION.SETTINGS.LanguageId := :lang_id; END;'
                     USING l_lang_id;
               EXCEPTION WHEN OTHERS THEN NULL; END;

               -- Transfer the configuration for the plant
               IF NOT f_TransferCfg THEN
                  l_result := 0;
               END IF;

               -- Run the NewVersion Manager, to make the newly created objects current
               PA_SPECXINTERFACE.P_NEWVERSIONMGR@LNK_LIMS;

               -- Close the connection for the plant
               IF NOT Pa_Lims.f_CloseLimsConnection THEN
                  --DBMS_OUTPUT.PUT_LINE('f_TransferCfgAllGkSt:TRUE');
                  l_result := 0;
               END IF;
            END IF;
         END IF;
      END IF;

      -- Clear the global arrays
      PA_LIMSSPC.g_nr_of_plants := 0;

      IF l_result = 1 THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
      END IF;
      RETURN(l_result);
   EXCEPTION
      WHEN OTHERS THEN
         -- Close the connection for the plant
         IF NOT PA_LIMS.f_CloseLimsConnection THEN
            PA_LIMS.p_Log(PA_LIMS.c_Source,  PA_LIMS.c_Applic, 'Unable to close the connection.');
         END IF;
         -- Log an error to ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unable to transfer all the configuration from Interspec to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         -- Clear the global arrays
         PA_LIMSSPC.g_nr_of_plants := 0;
         RETURN (0);
   END f_TransferAllCfgInternal;

END PA_LIMSCFG;
/
