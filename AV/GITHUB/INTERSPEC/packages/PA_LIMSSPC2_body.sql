---------------------------------------------------------------------------
-- $Workfile: PA_LIMSSpc2.sql $
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
-- 1.  f_TransferSpcAu
-- 2.  f_TransferSpcPpAu
-- 3.  f_TransferSpcAllStAu
-- 4.  f_TransferSpcAllStAu_AttachSp
-- 5.  f_TransferSpcStGk
-- 6.  f_DeleteSpcStGk
-- 7.  f_TransferSpcAllStGk
-- 8.  f_TransferSpcUsedAu
-- 9.  f_TransferSpcStPpAu
-- 10.  f_TransferSpcPpPrAu
-- 11. f_TransferSpcAllPpPrAu
-- 12. f_TransferSpcAllPpPrAu_AttSp
-- 13. f_GetIUIVersion
----------------------------------------------------------------------------
-- Versions:
-- speCX ver  Date         Author          Description
-- ---------  -----------  --------------  ---------------------------------
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
-- $Revision: 2 $
--  $Modtime: 26/04/10 15:05 $
----------------------------------------------------------------------------
PA_LIMSSPC2 IS

   -- Declare types
   TYPE Au_type IS RECORD(
      Id               VARCHAR2(20),
      SectionId        VARCHAR2(20),
      SubSectionId     VARCHAR2(20),
      Propertygroup    VARCHAR2(20),
      Property         VARCHAR2(20),
      Attribute        VARCHAR2(20),
      Is_Col           VARCHAR2(25),
      Counter          NUMBER  DEFAULT 1);
   TYPE l_table_Au_Type IS TABLE OF Au_type INDEX BY BINARY_INTEGER;
   TYPE VC20_MATRIX_TYPE IS TABLE OF UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS INDEX BY BINARY_INTEGER;
   TYPE VC40_MATRIX_TYPE IS TABLE OF UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS INDEX BY BINARY_INTEGER;
   
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

   FUNCTION f_TransferSpcAu(
      a_tp          IN     VARCHAR2,
      a_id          IN     VARCHAR2,
      a_version     IN OUT VARCHAR2,
      a_Au_tab      IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_Value_tab   IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows  IN     NUMBER
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer an object attribute from Interspec to Unilab
      -- ** Parameters **
      -- a_tp         : type of the object
      -- a_id         : id of the object
      -- a_version    : version of the object
      -- a_au_tab     : array of attributes
      -- a_value_tab  : array of values of the attributes
      -- a_nr_of_rows : number of rows
      -- ** Return **
      -- TRUE  : The transfer of the attibute has succeeded.
      -- FALSE : The transfer of the attribute has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcAu';
      l_object       VARCHAR2(255);
      l_objects      VARCHAR2(255);

      -- General variables
      l_at_revision           NUMBER;
      l_a_au_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_insert                BOOLEAN                           DEFAULT FALSE;
      l_newminor              BOOLEAN                           DEFAULT FALSE;
      l_newminor4value        BOOLEAN                           DEFAULT FALSE;
      l_version               VARCHAR2(20);
      l_a_value_tab           UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'GetObjectAttribute' API
      l_return_value_get      NUMBER;
      l_where_clause          VARCHAR2(255);
      l_nr_of_rows            NUMBER;
      l_object_tp             VARCHAR2(4);
      l_object_id_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_object_version_tab    UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_au_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_au_version_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab             UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_is_protected_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_single_valued_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_new_val_allowed_tab   UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_store_db_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_list_tp_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_run_mode_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_service_tab           UNAPIGEN.VC255_TABLE_TYPE@LNK_LIMS;
      l_cf_value_tab          UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'SaveObjectAttribute' API
      l_return_value_save     NUMBER;
      l_object_id             VARCHAR2(20);
      l_object_version        VARCHAR2(20);
      l_modify_reason         VARCHAR2(255);

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_obj_lc                 VARCHAR2(2);
      l_obj_lc_version         VARCHAR2(20);
      l_obj_ss                 VARCHAR2(2);
      l_obj_log_hs             CHAR(1);
      l_obj_allow_modify       CHAR(1);
      l_obj_active             CHAR(1);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_tp||' | '||a_id||' | '||a_version, NULL, NULL,
                      PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := a_tp||' "'||a_id||'" | version='||a_version;
      l_objects := 'the link between the attributes and '||l_object;

      -- This function may not be used for a parameterprofile object: use f_TransferSpcPpAu
      IF a_tp = 'pp' THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       l_method||' may not be used for a parameterprofile - '||
                       'use the function PA_LIMSSPC.f_TransferSpcPpAu instead');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      FOR i IN 1..a_nr_of_rows LOOP
         -- Convert the arguments to their maximum length
         l_a_value_tab(i) := SUBSTR(a_value_tab(i), 1, 40);
         -- Generate the attribute version based on the highest revision of the attribute
         l_at_revision := PA_LIMS.f_GetHighestRevision('attribute', a_au_tab(i));
         l_a_au_version_tab(i) := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('au', a_au_tab(i), l_at_revision);
      
         -- Transfer the attribute
         IF NOT PA_LIMSCFG.f_TransferCfgAu(a_au_tab(i), l_a_au_version_tab(i)) THEN
           -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
      END LOOP;

      -- Fill in the parameters to get the standard attributes of the link between the attributes and the object
      l_object_tp := a_Tp;
      l_where_clause := 'WHERE '||l_object_tp||'='''||REPLACE(a_id,'''','''''')|| -- single quote handling required (and done) (just to be safe)
                        ''' AND version = '''||a_version||''' ORDER BY auseq';
      -- Get the standard attributes of the link between the attributes and the object
      l_return_value_get := UNAPIPRP.GETOBJECTATTRIBUTE@LNK_LIMS
                               (l_object_tp, l_object_id_tab, l_object_version_tab, l_au_tab, l_au_version_tab,
                                l_value_tab, l_description_tab, l_is_protected_tab, l_single_valued_tab,
                                l_new_val_allowed_tab, l_store_db_tab, l_value_list_tp_tab, l_run_mode_tab,
                                l_service_tab, l_cf_value_tab, l_nr_of_rows, l_where_clause);
      -- Check if a link between attributes and the object exists in Unilab.
      -- If no link is found, then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- When there are no records found, l_nr_ofrows=100. That's why it is reset to 0.
         l_nr_of_rows := 0;

         -- Get the authorisation of the object
         l_ret_code := UNAPIGEN.GETAUTHORISATION@LNK_LIMS(a_tp, a_id, a_version, l_obj_lc, l_obj_lc_version, l_obj_ss,
                                                          l_obj_allow_modify, l_obj_active, l_obj_log_hs);
         IF l_ret_code = PA_LIMS.DBERR_SUCCESS THEN
            -- Modifiable, attribute can immediately be assigned
            l_insert := TRUE;
         ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
            -- Not modifiable, new minor version has to be created before attribute can be assigend
            l_newminor := TRUE;
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
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         l_newminor := TRUE;

         -- Check if the link between the attributes and the object exists
         FOR i IN 1..a_nr_of_rows LOOP
            FOR l_row_counter IN 1 .. l_nr_of_rows LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_Au_tab(l_row_counter), a_au_tab(i)) = 1 THEN
                  l_newminor := FALSE;
                  IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_a_Value_tab(i), l_value_tab(l_row_counter)) = 0 THEN
                     l_newminor4value := TRUE;
                     l_value_tab(l_row_counter) := RTRIM(l_a_value_tab(i));
                     EXIT;
                  END IF;
               END IF;
            END LOOP;
         END LOOP;
      ELSE
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to retrieve the standard attributes of the link between the attributes and '||
                       l_object||' (Error code : '||l_return_value_get||').');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- If some new attributes have to be assigned, a new minor version of the 
      -- object has to be created.
      -- In fact the f_Transfer[Cfg|Spc]Xx evaluates if it is really necessary to create a new minor version.
      -- If not modifiable, a new minor version will be created; in the other case
      -- the given version will be modified.
      IF (l_newminor OR l_newminor4value) THEN
         l_version := a_version;
         IF l_object_tp = 'st' THEN
            IF NOT PA_LIMSSPC.f_TransferSpcSt(a_id, l_version, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
                                              NULL, '1') THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         ELSIF l_object_tp = 'pr' THEN
            /* is_historic is passed as 0 - we don't expect modifications on historic parameters */
            IF NOT PA_LIMSCFG.f_TransferCfgPr(a_id, l_version, NULL, NULL, NULL, '1', 0) THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         ELSIF l_object_tp = 'mt' THEN
            IF NOT PA_LIMSCFG.f_TransferCfgMt(a_id, l_version, NULL, NULL, NULL, '1') THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         END IF;
         a_version := l_version;
      END IF;

      -- Assign the new attribute
      IF (l_insert OR l_newminor) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the attributes and the object.
         l_object_tp                    := a_Tp;
         l_object_id                    := a_Id;
         l_object_version               := a_version;
         FOR i IN 1..a_nr_of_rows LOOP
            l_nr_of_rows                   := l_nr_of_rows + 1;
            l_au_tab(l_nr_of_rows)         := a_Au_tab(i);
            l_au_version_tab(l_nr_of_rows) := l_a_au_version_tab(i);
            l_value_tab(l_nr_of_rows)      := RTRIM(l_a_Value_tab(i));
         END LOOP;
         l_modify_reason                := 'Imported the link between the attributes and '||a_tp||
                                           ' "'||a_id||'" from Interspec.';
         BEGIN
            -- Save the standard attributes of the link between the attributes and the object.
            l_return_value_save := UNAPIPRP.SAVEOBJECTATTRIBUTE@LNK_LIMS(l_object_tp, l_object_id, l_object_version,
                                      l_au_tab, l_au_version_tab, l_value_tab, l_nr_of_rows, l_modify_reason);
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
                             'Unable to save the standard attributes of '||l_objects||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      -- The link between the attribute and the object is already in Unilab
      ELSIF (l_newminor4value) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the attribute and the object.
         l_object_tp        := a_Tp;
         l_object_id        := a_Id;
         l_object_version   := a_version;
         l_modify_reason    := 'Imported the update of the link between the attributes and '||a_tp||
                               ' "'||a_id||'" from Interspec.';
         BEGIN
            -- Save the standard attributes of the link between  the attribute and the object
            l_return_value_save := UNAPIPRP.SAVEOBJECTATTRIBUTE@LNK_LIMS(l_object_tp, l_object_id, l_object_version,
                                      l_au_tab, l_au_version_tab, l_value_tab, l_nr_of_rows, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the update of '||l_objects||' (General failure! Error Code: '||
                                l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the update of '||l_objects||' (Error code : '||l_return_value_save||').');
               END IF;
               
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the update of '||l_objects||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      END IF;
      
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_tp||' | '||a_id||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN(TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_objects||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcAu;

   FUNCTION f_TransferSpcPpAu(
      a_pp      IN     VARCHAR2,
      a_version IN OUT VARCHAR2,
      a_pp_key1 IN     VARCHAR2,
      a_pp_key2 IN     VARCHAR2,
      a_pp_key3 IN     VARCHAR2,
      a_pp_key4 IN     VARCHAR2,
      a_pp_key5 IN     VARCHAR2,
      a_Au      IN     VARCHAR2,
      a_Value   IN     VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer a parameterprofile attribute from Interspec to Unilab
      -- a_pp       : parameterprofile
      -- a_version  : version of the parameterprofile
      -- a_pp_key1  : key1 of the parameterprofile
      -- a_pp_key2  : key2 of the parameterprofile
      -- a_pp_key3  : key3 of the parameterprofile
      -- a_pp_key4  : key4 of the parameterprofile
      -- a_pp_key5  : key5 of the parameterprofile
      -- a_au       : attribute
      -- a_value    : value of the attribute
      -- ** Return **
      -- TRUE  : The transfer of the attibute has succeeded.
      -- FALSE : The transfer of the attribute has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcPpAu';
      l_object       VARCHAR2(255);
      l_objects      VARCHAR2(255);

      -- General variables
      l_at_revision           NUMBER;
      l_au_version            VARCHAR2(20);
      l_version               VARCHAR2(20);
      l_row                   NUMBER;
      l_insert                BOOLEAN                           DEFAULT FALSE;
      l_newminor              BOOLEAN                           DEFAULT FALSE;
      l_newminor4value        BOOLEAN                           DEFAULT FALSE;
      l_a_value               VARCHAR2(40);
      
      -- Specific local variables for the 'GetPpAttribute' API
      l_return_value_get      NUMBER;
      l_where_clause          VARCHAR2(255);
      l_nr_of_rows            NUMBER;
      l_pp_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_au_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_au_version_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab             UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_is_protected_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_single_valued_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_new_val_allowed_tab   UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_store_db_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_list_tp_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_run_mode_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_service_tab           UNAPIGEN.VC255_TABLE_TYPE@LNK_LIMS;
      l_cf_value_tab          UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'SavePpAttribute' API
      l_return_value_save     NUMBER;
      l_pp                    VARCHAR2(20);
      l_pp_version            VARCHAR2(20);
      l_pp_key1               VARCHAR2(20);
      l_pp_key2               VARCHAR2(20);
      l_pp_key3               VARCHAR2(20);
      l_pp_key4               VARCHAR2(20);
      l_pp_key5               VARCHAR2(20);
      l_modify_reason         VARCHAR2(255);

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_pp_lc                  VARCHAR2(2);
      l_pp_lc_version          VARCHAR2(20);
      l_pp_ss                  VARCHAR2(2);
      l_pp_log_hs              CHAR(1);
      l_pp_allow_modify        CHAR(1);
      l_pp_active              CHAR(1);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_pp||' | '||a_version, a_au, a_value, PA_LIMS.c_Msg_Started);
      PA_LIMS.p_Trace(l_classname, l_method, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4||' | '||a_pp_key5);
      -- Convert the arguments to their maximum length
      l_a_value := SUBSTR(a_value, 1, 40);
      -- Generate the attribute version based on the highest revision of the attribute
      l_at_revision := PA_LIMS.f_GetHighestRevision('attribute', a_au);
      l_au_version := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('au', a_au, l_at_revision);
      -- Initializing variables
      l_object := 'parameterprofile "'||a_pp||'" | version='||a_version||' | pp_keys="'||a_pp_key1||'"#"'||a_pp_key2||
                  '"#"'||a_pp_key3||'"#"'||a_pp_key4||'"#"'||a_pp_key5||'"';
      l_objects := 'the link between attribute "'||a_Au||'" and '||l_object;
      
      -- Transfer the attribute
      IF NOT PA_LIMSCFG.f_TransferCfgAu(a_au, l_au_version) THEN
        -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Fill in the parameters to get the standard attributes of the link between the attributes and the parameterprofile
      l_where_clause := 'WHERE pp='''||REPLACE(a_pp,'''','''''')||''' AND version='''||a_version||
                        ''' AND pp_key1='''||REPLACE(a_pp_key1,'''','''''')||
                        ''' AND pp_key2='''||REPLACE(a_pp_key2,'''','''''')||
                        ''' AND pp_key3='''||REPLACE(a_pp_key3,'''','''''')||
                        ''' AND pp_key4='''||REPLACE(a_pp_key4,'''','''''')||
                        ''' AND pp_key5='''||REPLACE(a_pp_key5,'''','''''')||''' ORDER BY auseq';
      -- Get the standard attributes of the link between the attributes and the parameterprofile
      l_return_value_get := UNAPIPPP.GETPPATTRIBUTE@LNK_LIMS(l_pp_tab, l_version_tab, l_pp_key1_tab, l_pp_key2_tab,
                               l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_au_tab, l_au_version_tab, l_value_tab,
                               l_description_tab, l_is_protected_tab, l_single_valued_tab, l_new_val_allowed_tab,
                               l_store_db_tab, l_value_list_tp_tab, l_run_mode_tab, l_service_tab, l_cf_value_tab,
                               l_nr_of_rows, l_where_clause);
      -- Check if the link between the attribute and the parameterprofile in Unilab exists
      -- If no link is found, then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- When there are no records found, l_nr_ofrows=100. That's why it is reset to 0.
         l_nr_of_rows := 0;
         
         -- Get the authorisation of the parameterprofile
         l_ret_code := UNAPIPPP.GETPPAUTHORISATION@LNK_LIMS(a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3,
                                                            a_pp_key4, a_pp_key5, l_pp_lc, l_pp_lc_version, l_pp_ss,
                                                            l_pp_allow_modify, l_pp_active, l_pp_log_hs);
         IF l_ret_code = PA_LIMS.DBERR_SUCCESS THEN
            -- Modifiable, attribute can immediately be assigned
            l_insert := TRUE;
         ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
            -- Not modifiable, new minor version has to be created before attribute can be assigend
            l_newminor := TRUE;
         ELSIF l_ret_code <> PA_LIMS.DBERR_SUCCESS THEN
            IF l_ret_code = PA_LIMS.DBERR_GENFAIL THEN
               -- Log an error to ITERROR
               PA_LIMS.p_log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to get the authorisation of '||l_object||' (General failure! Error Code: '||l_ret_code||
                             ' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
            ELSE
               -- Log an error to ITERROR
               PA_LIMS.p_log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to get the authorisation of '||l_object||' (Error code : '||l_ret_code||').');
            END IF;
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         l_newminor := TRUE;
         l_row := 0;

         -- Check if the link between the attribute and the parameterprofile exists
         FOR l_row_counter IN 1 .. l_nr_of_rows
         LOOP
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_Au_tab(l_row_counter), a_Au) = 1 THEN
               l_newminor := FALSE;
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_a_Value, l_value_tab(l_row_counter)) = 0 THEN
                  l_newminor4value := TRUE;
                  l_row := l_row_counter;
                  EXIT;
               END IF;
            END IF;
         END LOOP;
      ELSE
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to retrieve the standard attributes of the link between the attributes and '||
                       l_object||' (Error code : '||l_return_value_get||').');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- If some new attributes have to be assigned, a new minor version of the 
      -- parameterprofile has to be created.
      -- In fact the f_TransferSpcPp evaluates if it is really necessary to create a new minor version.
      -- If not modifiable, a new minor version will be created; in the other case
      -- the given version will be modified.
      IF (l_newminor OR l_newminor4value) THEN
         l_version := a_version;
         IF NOT PA_LIMSSPC.f_TransferSpcPp(a_pp, l_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5, 
                                           NULL, NULL, NULL, NULL, '1') THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
         a_version := l_version;
      END IF;

      -- Assign the new attribute
      IF (l_insert OR l_newminor) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the attributes and the parameterprofile.
         l_nr_of_rows                   := l_nr_of_rows + 1;
         l_pp                           := a_pp;
         l_pp_version                   := a_version;
         l_pp_key1                      := a_pp_key1;
         l_pp_key2                      := a_pp_key2;
         l_pp_key3                      := a_pp_key3;
         l_pp_key4                      := a_pp_key4;
         l_pp_key5                      := a_pp_key5;
         l_au_tab(l_nr_of_rows)         := a_Au;
         l_au_version_tab(l_nr_of_rows) := l_au_version;
         l_value_tab(l_nr_of_rows)      := RTRIM(l_a_Value);
         l_modify_reason                := 'Imported the link between attribute "'||a_Au||
                                           '" and parameterprofile "'||a_pp||'" from Interspec.';
         BEGIN
            -- Save the standard attributes of the link between the attributes and the parameterprofile.
            l_return_value_save := UNAPIPPP.SAVEPPATTRIBUTE@LNK_LIMS(l_pp, l_pp_version, l_pp_key1, l_pp_key2,
                                      l_pp_key3, l_pp_key4, l_pp_key5, l_au_tab, l_au_version_tab, l_value_tab,
                                      l_nr_of_rows, l_modify_reason);
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
                             'Unable to save the standard attributes of '||l_objects||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      -- The link between the attribute and the parameterprofile is already in Unilab
      ELSIF (l_newminor4value) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the attribute and the parameterprofile.
         l_pp               := a_pp;
         l_pp_version       := a_version;
         l_pp_key1          := a_pp_key1;
         l_pp_key2          := a_pp_key2;
         l_pp_key3          := a_pp_key3;
         l_pp_key4          := a_pp_key4;
         l_pp_key5          := a_pp_key5;
         l_value_tab(l_row) := RTRIM(l_a_Value);
         l_modify_reason    := 'Imported the update of the link between attribute "'||a_Au||
                               '" and parameterprofile "'||a_pp||'" from Interspec.';
         BEGIN
            -- Save the standard attributes of the link between the attribute and the parameterprofile
            l_return_value_save := UNAPIPPP.SAVEPPATTRIBUTE@LNK_LIMS(l_pp, l_pp_version, l_pp_key1, l_pp_key2,
                                      l_pp_key3, l_pp_key4, l_pp_key5, l_au_tab, l_au_version_tab, l_value_tab,
                                      l_nr_of_rows, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the update of '||l_objects||' (General failure! Error Code: '||
                                l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the update of '||l_objects||' (Error code : '||l_return_value_save||').');
               END IF;
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to save the update of '||l_objects||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      END IF;
      
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_pp||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN(TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_objects||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcPpAu;

   FUNCTION f_TransferSpcAllStAu(
      a_St         IN     VARCHAR2,
      a_version    IN OUT VARCHAR2,
      a_Part_No    IN     SPECIFICATION_HEADER.PART_NO%TYPE,
      a_Revision   IN     SPECIFICATION_HEADER.REVISION%TYPE
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The sampletype attributes are properties in Interspec. The function
      -- transfers all properties to Unilab if they have the following
      -- characteristics:
      --    - The property belongs to a property group.
      --    - The property group is used in the specification.
      --    - The property group uses a display format that is set up for LIMS.
      --      the fields in the display format are configured as user attributes
      --      for a sample type.
      -- ** Parameters **
      -- a_st       : sampletype
      -- a_version  : version of the sampletype
      -- a_part_no  : part_no of the specification
      -- a_revision : revision of the specification
      -- ** Return **
      -- TRUE  : The transfer of sampletype attributes has succeeded.
      -- FALSE : The transfer of sampletype attributes has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcAllStAu';
      l_object       VARCHAR2(255);
      l_objects      VARCHAR2(255);

      -- General variables
      l_au_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab      UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_nr_of_au       NUMBER;

      l_table_Au       l_table_Au_Type;
      l_table_index    NUMBER;
      l_NewAu          BOOLEAN;
      l_Au_index       NUMBER;
      l_Value          VARCHAR2(120);
      l_value_descr    VARCHAR2(40);
      -- Dynamic SQL
      l_cur_hdl        INTEGER;
      l_return_value   INTEGER;
      l_sql            DBMS_SQL.varchar2s;

      -- Cursor to get all the properties that have to be send to Unilab as a sampletype attribute
      CURSOR l_StAu_Cursor(
         c_Part_No    specification_prop.part_no%TYPE,
         c_Revision   specification_prop.revision%TYPE
      )
      IS
         SELECT ivpgpr.property_group, limsc.is_col, ivpgpr.section_id,
                ivpgpr.sub_section_id, ivpgpr.property, ivpgpr.attribute,
                PA_LIMS.f_GetStAuId(ivpgpr.display_format,ivpgpr.display_format_rev,
                   limsc.is_col,ivpgpr.property,ivpgpr.attribute) id
           FROM ivpgpr, itlimsconfly limsc
          WHERE ivpgpr.display_format = limsc.layout_id
            AND ivpgpr.display_format_rev = limsc.layout_rev
            AND ivpgpr.part_no = c_Part_No
            AND ivpgpr.revision = c_Revision
            AND limsc.un_object = 'ST'
            AND limsc.un_type = 'AU';
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, a_part_no||' | '||a_revision, NULL, 
                      PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'sample type "'||a_St||'" | version='||a_version;
      l_nr_of_au := 0;

      -- Set the table index
      l_table_index := 0;
      BEGIN
         -- Get all the sampletype attributes that have to be transferred. 
         -- The sampletype attributes are stored in a table, so it is possible
         -- to check if they have one value.
         FOR l_StAu_Rec IN l_StAu_Cursor(a_Part_No, a_Revision) LOOP
            l_NewAu := TRUE;

            -- Loop through the table to check if the sampletype attribute is already
            -- marked to be transferred
            FOR l_counter IN 1 .. l_table_index LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_table_Au(l_counter).Id, l_StAu_Rec.Id) = 1 THEN
                  l_NewAu := FALSE;
                  l_Au_index := l_counter;
               END IF;
            END LOOP;

            IF l_NewAu THEN
               -- Add a new line to the table
               l_table_index := l_table_index + 1;
               -- Save the information to the table
               l_table_Au(l_table_index).Id            := l_StAu_Rec.Id;
               l_table_Au(l_table_index).SectionId     := l_StAu_Rec.Section_id;
               l_table_Au(l_table_index).SubSectionId  := l_StAu_Rec.Sub_Section_id;
               l_table_Au(l_table_index).Propertygroup := l_StAu_Rec.Property_Group;
               l_table_Au(l_table_index).Property      := l_StAu_Rec.Property;
               l_table_Au(l_table_index).Attribute     := l_StAu_Rec.Attribute;
               l_table_Au(l_table_index).Is_Col        := l_StAu_Rec.Is_Col;
               l_table_Au(l_table_index).Counter       := 1;
            ELSE
               l_table_Au(l_Au_index).Counter          := l_table_Au(l_Au_index).Counter + 1;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error to ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to get the attributes that have to be transferred for the '||l_object||
                          ' to Unilab: '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      -- Loop through all the sampletype attributes that have to be transferred to Unilab.
      FOR l_counter IN 1 .. l_table_index LOOP
         -- Initializing variables
         l_objects := 'the sample type attribute "'||l_table_Au(l_counter).Id||'" of the '||l_object;
         -- Check if there is one value for the sampletype attribute
         IF l_table_Au(l_counter).Counter <> 1 THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer '||l_objects||' : The attribute has more than '||
                          'one value. (Sample type is transferred without the attribute)');
         ELSE
            -- Open the cursor
            l_cur_hdl := DBMS_SQL.OPEN_CURSOR;
            -- Create the dynamic select statement
            l_sql(1) :=    'SELECT '||l_table_Au(l_counter).Is_Col
                        || ' FROM SPECIFICATION_PROP ';
            l_sql(2) :=    ' WHERE part_no        = '''||a_Part_No
                        || ''' AND revision       = '''||a_Revision
                        || ''' AND property       = '||l_table_Au(l_counter).Property
                        || '   AND ';
            l_sql(3) :=    '       Property_group = '||l_table_Au(l_counter).Propertygroup
                        || '   AND section_id     = '||l_table_Au(l_counter).SectionId
                        || '   AND sub_section_id = '||l_table_Au(l_counter).SubSectionId
                        || '   AND attribute      = '||l_table_Au(l_counter).Attribute;
            -- Set the SQL statement
            DBMS_SQL.PARSE(l_cur_hdl, l_sql, 1, 3, FALSE, DBMS_SQL.NATIVE);
            -- Define the columns in the select statement
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 1, l_Value, 120);
            -- Execute the select statement, the function returns
            -- the number of rows that are fetched
            l_return_value := DBMS_SQL.EXECUTE_AND_FETCH(l_cur_hdl);
            IF l_return_value = 0 THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer '||l_objects||' : Unable to get the value of the attribute.');
               -- Close the cursor
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Get the value of the property
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 1, l_Value);
            -- Check if there is maximum one value
            l_return_value := DBMS_SQL.FETCH_ROWS(l_cur_hdl);
            IF l_return_value <> 0 THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer '||l_objects||
                             ' : The attribute has more than one value. (Sample type is not transferred)');
               -- Close the cursor
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- If the attribute is of type 'UOM', the description of the
            -- UOM should become the value of the attribute instead of the UOM_ID.
            IF l_table_Au(l_counter).is_col = 'UOM_ID' THEN
               BEGIN
                  SELECT SUBSTR(description,1,40)
                    INTO l_Value_descr
                    FROM uom
                   WHERE uom_id = l_Value;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     l_Value_descr := NULL;
               END;
            -- If the attribute is of type 'CHARACTERISTIC', the description of the
            -- CHARACTERISTIC should become the value of the attribute instead of the CHARACTERISTIC_ID.
            ELSIF l_table_Au(l_counter).is_col IN ('CHARACTERISTIC','CH_2','CH_3') THEN
               BEGIN
                  SELECT SUBSTR(description,1,40)
                    INTO l_Value_descr
                    FROM characteristic
                   WHERE characteristic_id = l_Value;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     l_Value_descr := NULL;
               END;
            -- If the attribute is of type 'test_method', the description of the
            -- test method should become the value of the attribute instead of the test_method_id.
            ELSIF l_table_Au(l_counter).is_col = 'test_method' THEN
               BEGIN
                  SELECT SUBSTR(description,1,40)
                    INTO l_Value_descr
                    FROM test_method
                   WHERE test_method = l_Value;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     l_Value_descr := NULL;
               END;
            ELSE
               l_value_descr := SUBSTR(l_Value,1,40);
            END IF;

            -- Save in arrays, the transfer happens later
            l_nr_of_au := l_nr_of_au + 1;
            l_au_tab(l_nr_of_au) := l_table_Au(l_counter).Id;
            l_value_tab(l_nr_of_au) := l_Value_descr;

            -- Close the cursor
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END IF;
      END LOOP;
      
      -- Execute only if necessary, this is only if there are objects to transfer.
      IF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_nr_of_au, 0) = 0) THEN
         -- Transfer the sampletype attributes
         BEGIN
            IF NOT f_TransferSpcAu('st', a_St, a_version, l_au_tab, l_value_tab, l_nr_of_au) THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer the sample type attributes of the '||l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the sample type attributes of the '||l_object||' : '||SQLERRM);
         -- Close the cursor if the cursor is still open
         IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcAllStAu;

   FUNCTION f_TransferSpcAllStAu_AttachSp(
      a_St                  IN     VARCHAR2,
      a_version             IN OUT VARCHAR2,
      a_sh_revision         IN     NUMBER,
      a_linked_Part_No      IN     specification_header.part_no%TYPE,
      a_linked_Revision     IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The sampletype attributes of the attached specification are 
      -- properties in Interspec. The function transfers all properties to 
      -- Unilab if they have the following characteristics:
      --    - The property belongs to a property group.
      --    - The property group is used in the specification.
      --    - The property group uses a display format that is set up for LIMS.
      --      The fields in the display format are configured as user attributes
      --      for a sample type.
      -- These properties are transferred as attributes on the link between the 
      -- parameterprofile and the sampletype, not as sampletype attributes.
      -- ** Parameters **
      -- a_St                : sampletype
      -- a_version           : version of the sampletype
      -- a_sh_revision       : revision of the specification, to base the parameterprofile version on
      -- a_linked_Part_No    : part_no of the linked specification
      -- a_linked_Revision   : revision of the linked specification
      -- ** Return **
      -- TRUE  : The transfer of the sampletype attributes of the attached
      --         specification has succeeded.
      -- FALSE : The transfer of the sampletype attributes of the attached
      --         specification has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcAllStAu_AttachSp';
      l_object       VARCHAR2(255);
      l_objects      VARCHAR2(255);

      -- General variables
      l_au_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab      UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_nr_of_au       NUMBER;
      l_PrevPg         NUMBER(6);
      l_PrevPp         VARCHAR2(20);
      l_PrevPpVersion  VARCHAR2(20);

      l_table_Au       l_table_Au_Type;
      l_table_index    NUMBER;
      l_NewAu          BOOLEAN;
      l_Au_index       NUMBER;
      l_StPp           VARCHAR2(20);
      l_stpp_version   VARCHAR2(20);
      l_pp_desc        VARCHAR2(40);
      l_pg_revision    NUMBER;
      l_Value_descr    VARCHAR2(40);
      -- Dynamic SQL
      l_cur_hdl        INTEGER;
      l_return_value   INTEGER;
      l_sql            DBMS_SQL.varchar2s;
      l_Value          VARCHAR2(120);

      -- Cursor to get all the properties that have to be send to Unilab as an attribute
      -- on the link between the parameterprofile and the sampletype
      CURSOR l_StAu_Cursor(
         c_Part_No    specification_prop.part_no%TYPE,
         c_Revision   specification_prop.revision%TYPE
      )
      IS
         SELECT ivpgpr.property_group, limsc.is_col, ivpgpr.section_id,
                ivpgpr.sub_section_id, ivpgpr.property, ivpgpr.attribute,
                PA_LIMS.f_GetStAuId(ivpgpr.display_format, ivpgpr.display_format_rev,
                   limsc.is_col, ivpgpr.property, ivpgpr.attribute) id
           FROM ivpgpr, itlimsconfly limsc
          WHERE ivpgpr.display_format = limsc.layout_id
            AND ivpgpr.display_format_rev = limsc.layout_rev
            AND ivpgpr.part_no = c_Part_No
            AND ivpgpr.revision = c_Revision
            AND limsc.un_object = 'ST'
            AND limsc.un_type = 'AU'
          ORDER BY ivpgpr.property_group, limsc.is_col;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, a_linked_part_no||' | '||a_linked_revision,
                      NULL, PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'sample type "'||a_St||'" | version='||a_version;
      l_nr_of_au      := 0;
      l_PrevPg        := -1;
      l_PrevPp        := ' ';
      l_PrevPpVersion := ' ';

      -- Set the table index
      l_table_index := 0;
      BEGIN
         -- Get all the attributes that have to be transferred. The attributes are 
         -- stored in a table, so it is possible to check if they have one value
         FOR l_StAu_Rec IN l_StAu_Cursor(a_linked_Part_No, a_linked_Revision) LOOP
            l_NewAu := TRUE;

            -- Loop through the table to check if the attribute is already
            -- marked to be transferred
            FOR l_counter IN 1 .. l_table_index LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_table_Au(l_counter).Id, l_StAu_Rec.Id) = 1 THEN
                  l_NewAu := FALSE;
                  l_Au_index := l_counter;
               END IF;
            END LOOP;

            IF l_NewAu THEN
               -- Add a new line to the table
               l_table_index := l_table_index + 1;
               -- Save the information to the table
               l_table_Au(l_table_index).Id            := l_StAu_Rec.Id;
               l_table_Au(l_table_index).SectionId     := l_StAu_Rec.Section_id;
               l_table_Au(l_table_index).SubSectionId  := l_StAu_Rec.Sub_Section_id;
               l_table_Au(l_table_index).Propertygroup := l_StAu_Rec.Property_Group;
               l_table_Au(l_table_index).Property      := l_StAu_Rec.Property;
               l_table_Au(l_table_index).Attribute     := l_StAu_Rec.Attribute;
               l_table_Au(l_table_index).Is_Col        := l_StAu_Rec.Is_Col;
               l_table_Au(l_table_index).Counter       := 1;
            ELSE
               l_table_Au(l_Au_index).Counter          := l_table_Au(l_Au_index).Counter + 1;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error to ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to get the attributes that have to be transferred for the '||l_object||
                          ' to Unilab: '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      -- Loop through all the attributes that have to be transferred to Unilab.
      FOR l_counter IN 1 .. l_table_index LOOP
         -- Initializing variables
         l_objects := 'the sample type attribute "'||l_table_Au(l_counter).Id||'" of the '||l_object;
         -- Check if there is one value for the attribute
         IF l_table_Au(l_counter).Counter <> 1 THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer '||l_objects||
                          ' : The attribute has more than one value. (Sample type is transferred without the attribute)');
         ELSE
            -- Generate the parameterprofile id, version and description, 
            -- based on the highest revision of the property group
            l_pg_revision := PA_LIMS.f_GetHighestRevision('property_group', l_table_Au(l_counter).Propertygroup);
            l_StPp := PA_LIMS.f_GetPpId(a_linked_Part_No, l_table_Au(l_counter).Propertygroup, 
                                        l_pg_revision, 
                                        f_pgh_descr(1,l_table_Au(l_counter).Propertygroup,0), 
                                        l_pp_desc);
            -- Generate the version of the parameterprofile for the link
            l_stpp_version := UNVERSION.GETMAJORVERSIONONLY@LNK_LIMS(
                                 UNVERSION.CONVERTINTERSPEC2UNILABPP@LNK_LIMS(l_stpp, PA_LIMS.g_pp_key(1), 
                                    PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                                    PA_LIMS.g_pp_key(5), a_sh_revision)
                              );

            -- Initialize variables on the first time the loop is run
            IF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, -1) = 1) THEN
               l_PrevPg        := l_table_Au(l_counter).Propertygroup;
               l_PrevPp        := l_stpp;
               l_PrevPpVersion := l_stpp_version;
               l_nr_of_au      := l_nr_of_au + 1;
            -- Only transfer when property group changes
            ELSIF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, l_table_Au(l_counter).Propertygroup) = 0) THEN
               BEGIN
                  IF NOT f_TransferSpcStPpAu(a_St, a_version, l_PrevPp, l_PrevPpVersion, 
                            PA_LIMS.g_pp_key(1), PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), 
                            PA_LIMS.g_pp_key(4), PA_LIMS.g_pp_key(5), l_au_tab, 
                            l_value_tab, l_nr_of_au) THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     -- Log an error in ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                                   'Unable to transfer the sample type attributes of the '||l_object||' : '||SQLERRM);
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
               END;
               l_PrevPg        := l_table_Au(l_counter).Propertygroup;
               l_PrevPp        := l_stpp;
               l_PrevPpVersion := l_stpp_version;
               l_nr_of_au      := 1;
            ELSE
               l_nr_of_au := l_nr_of_au + 1;
            END IF;

            -- Open the cursor
            l_cur_hdl := DBMS_SQL.OPEN_CURSOR;
            -- Create the dynamic select statement
            l_sql(1) :=    'SELECT '||l_table_Au(l_counter).Is_Col
                        || '  FROM SPECIFICATION_PROP ';
            l_sql(2) :=    ' WHERE part_no        = '''||a_linked_Part_No
                        || ''' AND revision       = '''||a_linked_Revision
                        || ''' AND property       = '||l_table_Au(l_counter).Property
                        || '   AND ';
            l_sql(3) :=    '       Property_group = '||l_table_Au(l_counter).Propertygroup
                        || '   AND section_id     = '||l_table_Au(l_counter).SectionId
                        || '   AND sub_section_id = '||l_table_Au(l_counter).SubSectionId
                        || '   AND attribute      = '||l_table_Au(l_counter).Attribute;
            -- Set the SQL statement
            DBMS_SQL.PARSE(l_cur_hdl, l_sql, 1, 3, FALSE, DBMS_SQL.NATIVE);
            -- Define the columns in the select statement
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 1, l_Value, 120);
            -- Execute the select statement, the function returns
            -- the number of rows that are fetched
            l_return_value := DBMS_SQL.EXECUTE_AND_FETCH(l_cur_hdl);
            IF l_return_value = 0 THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer '||l_objects||' : Unable to get the value of the attribute.');
               -- Close the cursor
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Get the value of the property
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 1, l_Value);
            -- Check if there is maximum one value
            l_return_value := DBMS_SQL.FETCH_ROWS(l_cur_hdl);
            IF l_return_value <> 0 THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer '||l_objects||
                             ' : The attribute has more than one value. '||'(Sample type is not transferred)');
               -- Close the cursor
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- If the attribute is of type 'UOM', the description of the
            -- UOM should become the value of the attribute instead of the UOM_ID.
            IF l_table_Au(l_counter).is_col = 'UOM_ID' THEN
               BEGIN
                  SELECT SUBSTR(description,1,40)
                    INTO l_Value_descr
                    FROM uom
                   WHERE uom_id = l_Value;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     l_Value_descr := NULL;
               END;
            -- If the attribute is of type 'CHARACTERISTIC', the description of the
            -- CHARACTERISTIC should become the value of the attribute instead of the CHARACTERISTIC_ID.
            ELSIF l_table_Au(l_counter).is_col IN ('CHARACTERISTIC','CH_2','CH_3') THEN
               BEGIN
                  SELECT SUBSTR(description,1,40)
                    INTO l_Value_descr
                    FROM characteristic
                   WHERE characteristic_id = l_Value;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     l_Value_descr := NULL;
               END;
            -- If the attribute is of type 'test_method', the description of the
            -- test method should become the value of the attribute instead of the test_method_id.
            ELSIF l_table_Au(l_counter).is_col = 'test_method' THEN
               BEGIN
                  SELECT SUBSTR(description,1,40)
                    INTO l_Value_descr
                    FROM test_method
                   WHERE test_method = l_Value;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     l_Value_descr := NULL;
               END;
            ELSE
               l_value_descr := SUBSTR(l_Value,1,40);
            END IF;

            -- Save in arrays, the transfer happens later
            l_au_tab(l_nr_of_au) := l_table_Au(l_counter).Id;
            l_value_tab(l_nr_of_au) := l_Value_descr;

            -- Close the cursor
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END IF;
      END LOOP;

      -- Execute once for the last propertygroup, but only if necessary.
      IF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, -1) = 0) THEN
         BEGIN
            IF NOT f_TransferSpcStPpAu(a_St, a_version, l_PrevPp, l_PrevPpVersion, 
                      PA_LIMS.g_pp_key(1), PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), 
                      PA_LIMS.g_pp_key(4), PA_LIMS.g_pp_key(5), l_au_tab, 
                      l_value_tab, l_nr_of_au) THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                             'Unable to transfer the sample type attributes of the '||l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      END IF;
      
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the sample type attributes of the '||l_object||' : '||SQLERRM);
         -- Close the cursor if the cursor is still open
         IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcAllStAu_AttachSp;

   FUNCTION f_TransferSpcStGk(
      a_st           IN     VARCHAR2,
      a_version      IN OUT VARCHAR2,
      a_gk           IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_gk_version   IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_value        IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows   IN     NUMBER
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer a sampletype groupkey and its value from Interspec to Unilab.
      -- ** Parameters **
      -- a_st           : sampletype
      -- a_version      : version of the sampletype
      -- a_gk           : groupkey
      -- a_gk_version   : groupkey version
      -- a_value        : value of the groupkey
      -- a_nr_of_rows   : number of groupkeys to save
      -- ** Return **
      -- TRUE  : The transfer of the group key and his value assigned
      --         to a sample type has succeeded.
      -- FALSE : The transfer of the group key and his value assigned
      --         to a sample type has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcStGk';
      l_object       VARCHAR2(255);

      -- General variables
      l_insert                BOOLEAN                           DEFAULT FALSE;
      l_newminor              BOOLEAN                           DEFAULT FALSE;
      l_version               VARCHAR2(20);
      l_copy                  BOOLEAN;

      -- Specific local variables for the 'GetStGroupKey' API
      l_return_value_get      NUMBER;
      l_nr_of_rows            NUMBER;
      l_where_clause          VARCHAR2(255);
      l_st_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_gk_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_gk_version_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab             UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_is_protected_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_unique_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_single_valued_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_new_val_allowed_tab   UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_mandatory_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_list_tp_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_dsp_rows_tab          UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'SaveStGroupKey' API
      l_return_value_save     NUMBER;
      l_modify_reason         VARCHAR2(255);

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_st_lc                  VARCHAR2(2);
      l_st_lc_version          VARCHAR2(20);
      l_st_ss                  VARCHAR2(2);
      l_st_log_hs              CHAR(1);
      l_st_allow_modify        CHAR(1);
      l_st_active              CHAR(1);
      
      -- Cursor to get the single_valued flag of the groupkey
      CURSOR l_single_valued_cursor(c_gk IN VARCHAR2)
      IS 
         SELECT single_valued
         FROM UVGKST@LNK_LIMS
         WHERE gk = c_gk;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, a_nr_of_rows, NULL, PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'sample type "'||a_St||'" | version='||a_version;

      -- Fill in the parameters to get the standard attributes of the link between the groupkeys and the sampletype.
      l_where_clause := 'WHERE st='''||REPLACE(a_st,'''','''''')||''' AND version = '''||a_version||''' ORDER BY gkseq';
      -- Get the standard attributes of the link between the groupkeys and the sampletype
      l_return_value_get := UNAPIST.GETSTGROUPKEY@LNK_LIMS(l_st_tab, l_version_tab, l_gk_tab, l_gk_version_tab,
                               l_value_tab, l_description_tab, l_is_protected_tab, l_value_unique_tab,
                               l_single_valued_tab, l_new_val_allowed_tab, l_mandatory_tab, l_value_list_tp_tab,
                               l_dsp_rows_tab, l_nr_of_rows, l_where_clause);
      -- Check if a link between groupkeys and the sampletype exists in Unilab.
      -- If no link is found, then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- When there are no records found, l_nr_of_rows=100. That's why it is reset to 0.
         l_nr_of_rows := 0;
      ELSIF l_return_value_get <> PA_LIMS.DBERR_SUCCESS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                   'Unable to retrieve the standard attributes of the link between the groupkeys and '||l_object||
                   ' (Error code : '||l_return_value_get||').');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Check the input: if the groupkey is singlevalued, it can only once be assigned to the sampletype.
      -- If multivalued, all values have to be different.
      -- This check has to be executed here, because in standard Unilab, it is done by the client application, not 
      -- in the API.
      -- Principle: loop the array with groupkeys, and copy the groupkeys and their versions and values to a local array, 
      -- but without the duplicates.
      FOR i IN 1..a_nr_of_rows LOOP
         l_copy := TRUE;
         -- Get the single_valued flag of the groupkey
         FOR l_rec IN l_single_valued_cursor(a_gk(i)) LOOP
            IF l_rec.single_valued = 1 THEN
               -- Loop the local array to check if this groupkey needs to be updated
               FOR j IN 1..l_nr_of_rows LOOP
                  IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(a_gk(i),l_gk_tab(j)) = 1 THEN 
                     l_copy := FALSE;
                     l_value_tab(j) := a_value(i);
                     EXIT;
                  END IF;
               END LOOP;
            ELSE
               -- Loop the local array to check if the value is a duplicate
               FOR j IN 1..l_nr_of_rows LOOP
                  IF (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(a_gk(i),l_gk_tab(j))=1) AND (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(a_value(i),l_value_tab(j))=1) THEN
                     l_copy := FALSE;
                     EXIT;
                  END IF;
               END LOOP;
            END IF;
         END LOOP;
         -- If no duplicate, or if multivalued, add to the local array
         IF l_copy THEN
            l_nr_of_rows := l_nr_of_rows + 1;
            l_gk_tab(l_nr_of_rows)         := a_gk(i);
            l_gk_version_tab(l_nr_of_rows) := a_gk_version(i);
            l_value_tab(l_nr_of_rows)      := a_value(i);
         END IF;
      END LOOP;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Number of rows without duplicates = '||l_nr_of_rows);

      -- Get the authorisation of the sample type
      l_ret_code := UNAPIGEN.GETAUTHORISATION@LNK_LIMS('st', a_st, a_version, l_st_lc, l_st_lc_version, l_st_ss,
                                                       l_st_allow_modify, l_st_active, l_st_log_hs);
      IF l_ret_code = PA_LIMS.DBERR_SUCCESS THEN
         -- Modifiable, groupkeys can immediately be assigned
         l_insert := TRUE;
      ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
         -- Not modifiable, new minor version has to be created before groupkey can be assigend
         l_newminor := TRUE;
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

      -- If the sampletype is not modifiable, a new minor version has to be created.
      -- In fact the f_TransferSpcSt evaluates if it is really necessary to create a new minor version.
      -- If not modifiable, a new minor version will be created; in the other case
      -- the given version will be modified.
      IF (l_newminor) THEN
         l_version := a_version;
         IF NOT PA_LIMSSPC.f_TransferSpcSt(a_st, l_version, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1') THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
         a_version := l_version;
      END IF;

      -- Fill in the parameters to save the standard attributes of the link 
      -- between the groupkeys and the sampletype.
      l_modify_reason := 'Imported the link between the group keys and sample type "'||a_st||'" from Interspec.';
      BEGIN
         -- Save the standard attributes of the link between the groupkeys and the sampletype.
         l_return_value_save := UNAPIST.SAVESTGROUPKEY@LNK_LIMS(a_st, a_version, l_gk_tab, l_gk_version_tab, l_value_tab, 
                                                                l_nr_of_rows, l_modify_reason);
         -- If the error is a general failure then the SQLERRM must be logged, otherwise
         -- the error code is the Unilab error
         IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
            IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
               ---------------------------------------------------------------------------------------
               -- The groupkey api's in Unilab 6.1.0 have been modified to handle the situation that 
               -- a gk table utstgkxxx does not exist. On creating the structures in Unilab, a copy
               -- will be executed so the records of gk xxx that are in utstgk are also in utstgkxxx.
               -- In fact the whole IF-case
               -- (IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(SUBSTR(UNRPCAPI.LASTERRORTEXT@LNK_LIMS,1,27),'Groupkey structures missing') = 1 THEN)
               -- can be removed, and the ELSIF can become IF.
               -- -> Unilab 6.1.0 punchlist (pdv-uni-10) - item 297
               -- BUT the code is kept for backward compatibility with Unilab 5.0 sp2 and sp3. If one
               -- fine day that shouldn't be necessary anymore, the code can be removed.
               ---------------------------------------------------------------------------------------

               -- Check if the table of the groupkey exists. (Note: it is not possible
               -- to create a table from a remote DB)
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(SUBSTR(UNRPCAPI.LASTERRORTEXT@LNK_LIMS,1,27),'Groupkey structures missing') = 1 THEN
                  FOR i IN 1..l_nr_of_rows LOOP
                     -- Insert manually the sample type group key values
                     PA_SPECXINTERFACE.P_SAVESTGKPARTIALLY@LNK_LIMS
                        (a_st, a_version, l_gk_tab(i), l_gk_version_tab(i), l_value_tab(i));
                  END LOOP;
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the standard attributes of the link between the groupkeys and '||l_object||
                                ' (General failure! Error Code: '||l_return_value_save||' Error Msg:'||
                                UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               END IF;
            ELSE
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the standard attributes of the link between the groupkeys and '||l_object||
                             ' (Error code : '||l_return_value_save||').');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to save the standard attributes of the link between the groupkeys and '||
                          l_object||' : '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unexpected error when transferring the link between the groupkeys and '||
                       l_object||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcStGk;

   FUNCTION f_DeleteSpcStGk(
      a_st           IN     VARCHAR2,
      a_version      IN OUT VARCHAR2,
      a_gk           IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_gk_version   IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_value        IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows   IN     NUMBER
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Delete a sampletype groupkey values from Unilab.
      -- ** Parameters **
      -- a_st           : sampletype
      -- a_version      : version of the sampletype
      -- a_gk           : groupkey
      -- a_gk_version   : groupkey version
      -- a_value        : value of the groupkey
      -- a_nr_of_rows   : number of groupkeys to save
      -- ** Return **
      -- TRUE  : The deletion of the group key values assigned
      --         to a sample type has succeeded.
      -- FALSE : The transfer of the group key values assigned
      --         to a sample type has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_DeleteSpcStGk';
      l_object       VARCHAR2(255);

      -- General variables
      l_insert                BOOLEAN                           DEFAULT FALSE;
      l_newminor              BOOLEAN                           DEFAULT FALSE;
      l_version               VARCHAR2(20);
      l_copy                  BOOLEAN;

      -- Specific local variables for the 'GetStGroupKey' API
      l_return_value_get      NUMBER;
      l_nr_of_rows            NUMBER;
      l_where_clause          VARCHAR2(255);
      l_st_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_gk_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_gk_version_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab             UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_is_protected_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_unique_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_single_valued_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_new_val_allowed_tab   UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_mandatory_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_list_tp_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_dsp_rows_tab          UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'SaveStGroupKey' API
      l_return_value_save     NUMBER;
      l_modify_reason         VARCHAR2(255);
      l_save_gk_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_save_gk_version_tab   UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_save_gk_value_tab     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_save_nr_of_rows       NUMBER;

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_st_lc                  VARCHAR2(2);
      l_st_lc_version          VARCHAR2(20);
      l_st_ss                  VARCHAR2(2);
      l_st_log_hs              CHAR(1);
      l_st_allow_modify        CHAR(1);
      l_st_active              CHAR(1);
      
      -- Cursor to get the single_valued flag of the groupkey
      CURSOR l_single_valued_cursor(c_gk IN VARCHAR2)
      IS 
         SELECT single_valued
         FROM UVGKST@LNK_LIMS
         WHERE gk = c_gk;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, a_nr_of_rows, NULL, PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'sample type "'||a_St||'" | version='||a_version;

      -- Fill in the parameters to get the standard attributes of the link between the groupkeys and the sampletype.
      l_where_clause := 'WHERE st='''||REPLACE(a_st,'''','''''')||''' AND version = '''||a_version||''' ORDER BY gkseq';
      -- Get the standard attributes of the link between the groupkeys and the sampletype
      l_return_value_get := UNAPIST.GETSTGROUPKEY@LNK_LIMS(l_st_tab, l_version_tab, l_gk_tab, l_gk_version_tab,
                               l_value_tab, l_description_tab, l_is_protected_tab, l_value_unique_tab,
                               l_single_valued_tab, l_new_val_allowed_tab, l_mandatory_tab, l_value_list_tp_tab,
                               l_dsp_rows_tab, l_nr_of_rows, l_where_clause);
      -- Check if a link between groupkeys and the sampletype exists in Unilab.
      -- If no link is found, then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- When there are no records found, l_nr_of_rows=100. That's why it is reset to 0.
         l_nr_of_rows := 0;
      ELSIF l_return_value_get <> PA_LIMS.DBERR_SUCCESS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                   'Unable to retrieve the standard attributes of the link between the groupkeys and '||l_object||
                   ' (Error code : '||l_return_value_get||').');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- scan the fetched array and suppress the values passed in the argument array
      l_save_nr_of_rows := 0;
      FOR l_fetched_nr IN 1..l_nr_of_rows LOOP
         --copy the value to the save array only when it must not be deleted
         l_copy := TRUE;
         FOR l_todelete_nr IN 1..a_nr_of_rows LOOP
             IF (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(a_gk(l_todelete_nr),l_gk_tab(l_fetched_nr)) = 1)AND 
                (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(a_value(l_todelete_nr),l_value_tab(l_fetched_nr)) = 1) THEN
                l_copy := FALSE;
                l_ret_code := UNAPIGEN.AddObjectComment@LNK_LIMS('st', a_st, a_version, 'group key "'||
                                                                 a_gk(l_todelete_nr)||'" value "'||a_value(l_todelete_nr)||
                                                                 ' deleted (plant is osbolete for Interpsec)');
                EXIT;
             END IF;
         END LOOP;
         IF l_copy THEN
            l_save_nr_of_rows := l_save_nr_of_rows + 1;
            l_save_gk_tab(l_save_nr_of_rows) := l_gk_tab(l_fetched_nr);
            l_save_gk_version_tab(l_save_nr_of_rows) := l_gk_version_tab(l_fetched_nr);
            l_save_gk_value_tab(l_save_nr_of_rows) := l_value_tab(l_fetched_nr);            
         END IF;
      END LOOP;
         
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Number of group keys to save = '||l_save_nr_of_rows);

      -- Get the authorisation of the sample type
      l_ret_code := UNAPIGEN.GETAUTHORISATION@LNK_LIMS('st', a_st, a_version, l_st_lc, l_st_lc_version, l_st_ss,
                                                       l_st_allow_modify, l_st_active, l_st_log_hs);
      IF l_ret_code = PA_LIMS.DBERR_SUCCESS THEN
         -- Modifiable, groupkeys can immediately be assigned
         l_insert := TRUE;
--      ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
--         -- Not modifiable, new minor version has to be created before groupkey can be assigend
--         l_newminor := TRUE;
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

--      -- If the sampletype is not modifiable, a new minor version has to be created.
--      -- In fact the f_TransferSpcSt evaluates if it is really necessary to create a new minor version.
--      -- If not modifiable, a new minor version will be created; in the other case
--      -- the given version will be modified.
--      IF (l_newminor) THEN
--         l_version := a_version;
--         IF NOT PA_LIMSSPC.f_TransferSpcSt(a_st, l_version, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1') THEN
--            -- Tracing
--            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
--            RETURN (FALSE);
--         END IF;
--         a_version := l_version;
--      END IF;

      -- Fill in the parameters to save the standard attributes of the link 
      -- between the groupkeys and the sampletype.
      l_modify_reason := 'Deleting obsolete plant group keys of sample type "'||a_st||'" version "'||a_version||'"from Interspec.';
      BEGIN
         -- Save the standard attributes of the link between the groupkeys and the sampletype.
         l_return_value_save := UNAPIST.SAVESTGROUPKEY@LNK_LIMS(a_st, a_version, l_save_gk_tab, l_save_gk_version_tab, 
                                                                l_save_gk_value_tab, l_save_nr_of_rows, l_modify_reason);
         -- If the error is a general failure then the SQLERRM must be logged, otherwise
         -- the error code is the Unilab error
         IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
            IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN

               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the groupkeys for '||l_object||
                             ' (General failure! Error Code: '||l_return_value_save||' Error Msg:'||
                             UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            ELSE
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the groupkeys for '||l_object||
                             ' (Error code : '||l_return_value_save||').');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to save the groupkeys for '||
                          l_object||' : '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unexpected error when deleting groupkeys on '||
                       l_object||' in Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_DeleteSpcStGk;

   FUNCTION f_TransferSpcAllStGk(
      a_st         IN     VARCHAR2,
      a_version    IN OUT VARCHAR2,
      a_Part_No    IN     specification_header.part_no%TYPE,
      a_Revision   IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The links between keywords and specifications are links between groupkeys 
      -- and sampletypes in Unilab. The function
      -- transfers all links to Unilab if they have the following characteristics:
      --    - The keyword is assigned to a specification.
      --      And properties with the following characteristics:
      --    - The property belongs to a property group.
      --    - The property group is used in the specification.
      --    - The property group uses a display format that is set up for LIMS.
      --    - There are fields of the display format configured as sample type
      --      groupkeys.
      -- ** Parameters **
      -- a_st        : sampletype
      -- a_version   : version of the sampletype
      -- a_part_no   : part_no of the specification
      -- a_revision  : revision of the specification
      -- ** Return **
      -- TRUE  : The transfer of the sample type groupkeys has succeeded.
      -- FALSE : The transfer of the sample type groupkeys  has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcAllStGk';
      l_object       VARCHAR2(255);
      l_objects      VARCHAR2(255);

      -- General variables
      l_gk_tab             UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_gk_version_tab     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab          UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_nr_of_rows         NUMBER;
      -- Dynamic SQL
      l_cur_hdl        INTEGER;
      l_return_value   INTEGER;
      l_sql            DBMS_SQL.varchar2s;
      l_Value          VARCHAR2(120);

      -- Cursor to get all the keywords that have to be send to Unilab as a sampletype groupkey
      CURSOR l_StGkToTransfer_Cursor(c_Part_No   specification_header.part_no%TYPE)
      IS
         SELECT kw.kw_id, kw.description, spckw.kw_value
           FROM specification_kw spckw, itkw kw
          WHERE spckw.kw_id = kw.kw_id
            AND part_no = c_Part_No;

      -- Cursor to get all the sampletype groupkeys
      CURSOR l_StGk_Cursor(c_Part_No    specification_prop.part_no%TYPE,
                           c_Revision   specification_prop.revision%TYPE)
      IS
         SELECT ivpgpr.property_group, limsc.is_col, ivpgpr.section_id,
                ivpgpr.sub_section_id, ivpgpr.property, ivpgpr.attribute,
                PA_LIMS.f_GetStGkID(
                   ivpgpr.display_format,
                   ivpgpr.display_format_rev,
                   limsc.is_col
                ) Id
           FROM ivpgpr, itlimsconfly limsc
          WHERE ivpgpr.display_format = limsc.layout_id
            AND ivpgpr.display_format_rev = limsc.layout_rev
            AND ivpgpr.part_no = c_Part_No
            AND ivpgpr.revision = c_Revision
            AND limsc.un_object = 'ST'
            AND limsc.un_type = 'GK';

      -- Cursor to get all plants that have the same connection string and language id as the given plant
      CURSOR l_plant_cursor(c_plant      plant.plant%TYPE, 
                            c_part_no    specification_header.part_no%TYPE)
      IS
         SELECT a.*
           FROM itlimsplant a, part_plant pp
          WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                    (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                       FROM itlimsplant b
                      WHERE b.plant = c_plant)
            AND a.plant = pp.plant
            AND pp.part_no = c_part_no;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, a_part_no||' | '||a_revision, NULL, 
                      PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'sample type "'||a_St||'" | version='||a_version;
      
      -- Set the table index
      l_nr_of_rows := 0;
      -- Transfer all the keywords of the specification to Unilab
      FOR l_StGkToTransfer_rec IN l_StGkToTransfer_Cursor(a_part_no) LOOP
         -- Add the sampletype groupkey to an array, the transfer will be done at the end.
         l_nr_of_rows := l_nr_of_rows + 1;
         -- Generate the sampletype groupkey id
         l_gk_tab(l_nr_of_rows)         := PA_LIMS.f_GetGkId(l_StGkToTransfer_rec.description);
         l_gk_version_tab(l_nr_of_rows) := NULL;
         l_value_tab(l_nr_of_rows)      := l_StGkToTransfer_rec.kw_value;
      END LOOP;

      -- Loop through all the sampletype groupkeys that have to be transferred. 
      FOR l_StGk_Rec IN l_StGk_Cursor(a_Part_No, a_Revision) LOOP
         -- Initializing variables
         l_objects := 'the sample type groupkey "'||l_StGk_Rec.ID||'" of the '||l_object;
         -- Open the cursor
         l_cur_hdl := DBMS_SQL.Open_Cursor;
         -- Create the dynamic Select statement
         l_sql(1) :=    'SELECT '||l_StGk_Rec.Is_Col
                     || ' FROM specification_prop ';
         l_sql(2) :=    ' WHERE part_no        = '''||a_Part_No
                     || ''' AND revision       = '''||a_Revision
                     || ''' AND property       = '||l_StGk_Rec.Property
                     || '   AND ';
         l_sql(3) :=    '       property_group = '||l_StGk_Rec.property_group
                     || '   AND section_id     = '||l_StGk_Rec.Section_Id
                     || '   AND sub_section_id = '||l_StGk_Rec.Sub_Section_Id
                     || '   AND attribute      = '||l_StGk_Rec.Attribute;
         -- Set the SQL statement
         DBMS_SQL.PARSE(l_cur_hdl, l_sql, 1, 3, FALSE, DBMS_SQL.NATIVE);
         -- Define the columns in the select statement
         DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 1, l_Value, 120);
         -- Execute the select statement, the function returns
         -- the number of rows that are fetched
         l_return_value := DBMS_SQL.EXECUTE_AND_FETCH(l_cur_hdl);

         IF l_return_value = 0 THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer '||l_objects||' : Unable to get the value of the groupkey.');
            -- Close the cursor
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;

         -- Get the value of the property
         DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 1, l_Value);
         -- Check if there is maximum 1 value
         l_return_value := DBMS_SQL.FETCH_ROWS(l_cur_hdl);

         -- When does this happen ?
         IF l_return_value <> 0 THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer '||l_objects||
                          ' : The groupkey has more than one value. (Sample type is not transferred)');
            -- Close the cursor
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;

         BEGIN
            -- Transfer the groupkey for the sampletype
            IF NOT PA_LIMSCFG.f_TransferCfgGkSt(l_StGk_Rec.Id, l_StGk_Rec.Id) THEN
               -- Close the cursor
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Add the sampletype groupkey to an array, the transfer will be done at the end.
            l_nr_of_rows := l_nr_of_rows + 1;
            l_gk_tab(l_nr_of_rows)         := l_StGk_Rec.Id;
            l_gk_version_tab(l_nr_of_rows) := NULL;
            l_value_tab(l_nr_of_rows)      := SUBSTR(l_value, 1, 40);
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer the sample type groupkeys of the '||l_object||' : '||SQLERRM);
               -- Close the cursor
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;

         -- Close the cursor
         DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
      END LOOP;

      -- Transfer the sampletype groupkey
      IF NOT f_TransferSpcStGk(a_st, a_version, l_gk_tab, l_gk_version_tab, l_value_tab, l_nr_of_rows) THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the groupkeys for the '||l_object||' : '||SQLERRM);
         -- Close the cursor if the cursor is still open
         IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcAllStGk;

   FUNCTION f_TransferSpcUsedAu(
      a_tp             IN     VARCHAR2,
      a_used_tp        IN     VARCHAR2,
      a_id             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_used_id        IN     VARCHAR2,
      a_used_version   IN     VARCHAR2,
      a_Au             IN     VARCHAR2,
      a_Value          IN     VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer a used object attribute from Unilab to Interspec
      -- ** Parameters **
      -- a_tp           : object type
      -- a_used_tp      : used object type
      -- a_id           : id of the object
      -- a_version      : version of the object
      -- a_used_id      : id of the used object assigned to the object
      -- a_used_version : version of the used object
      -- a_au           : attribute
      -- a_value        : value of the attribute
      -- ** Return **
      -- TRUE  : The transfer of the used object attibute has succeeded.
      -- FALSE : The transfer of the used object attribute has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname                    CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method                       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcUsedAu';
      l_object                       VARCHAR2(255);
      l_used_object                  VARCHAR2(255);
      l_objects                      VARCHAR2(255);

      -- General variables
      l_insert                       BOOLEAN                           DEFAULT FALSE;
      l_newminor                     BOOLEAN                           DEFAULT FALSE;
      l_newminor4value               BOOLEAN                           DEFAULT FALSE;
      l_version                      VARCHAR2(20);
      l_row                          NUMBER;
      l_at_revision                  NUMBER;
      l_au_version                   VARCHAR2(20);
      l_a_value                      VARCHAR2(40);

      -- Specific local variab       les for the 'GetUsedObjectAttribute' API
      l_return_value_get             NUMBER;
      l_where_clause                 VARCHAR2(255);
      l_nr_of_rows                   NUMBER;
      l_object_tp                    VARCHAR2(4);
      l_used_object_tp               VARCHAR2(4);
      l_object_id                    VARCHAR2(20);
      l_object_id_version            VARCHAR2(20);
      l_used_object_id_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_used_object_id_version_tab   UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_au_tab                       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_au_version_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab                    UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description_tab              UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_is_protected_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_single_valued_tab            UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_new_val_allowed_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_store_db_tab                 UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_list_tp_tab            UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_run_mode_tab                 UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_service_tab                  UNAPIGEN.VC255_TABLE_TYPE@LNK_LIMS;
      l_cf_value_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      
      -- Specific local variables for the 'SaveUsedObjectAttribute' API
      l_return_value_save            NUMBER;
      l_used_object_id               VARCHAR2(20);
      l_used_object_id_version       VARCHAR2(20);
      l_modify_reason                VARCHAR2(255);

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_obj_lc                 VARCHAR2(2);
      l_obj_lc_version         VARCHAR2(20);
      l_obj_ss                 VARCHAR2(2);
      l_obj_log_hs             CHAR(1);
      l_obj_allow_modify       CHAR(1);
      l_obj_active             CHAR(1);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_tp||' | '||a_id||' | '||a_version, 
                      a_used_tp||' | '||a_used_id||' | '||a_used_version, a_au||' | '||SUBSTR(a_value,1,15),
                      PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := a_tp||' "'||a_id||'" | version='||a_version;
      l_used_object := a_Used_Tp||' "'||a_Used_Id||'" | version='||a_used_version;
      l_objects := 'the link between attribute "'||a_Au||'" and '||l_object||' - '||l_used_object;

      -- Convert the arguments to their maximum length
      l_a_value := SUBSTR(a_value, 1, 40);
      -- This function may not be used for sampletype - parameterprofile attributes: use f_TransferSpcStPpAu
      IF a_tp = 'st' THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       l_method||' may not be used for sampletype - parameterprofile attributes:'||
                       ' use the function PA_LIMSSPC.f_TransferSpcStPpAu instead.');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      -- This function may not be used for parameterprofile - parameter attributes: use f_TransferSpcPpPrAu
      ELSIF a_tp = 'pp' THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       l_method||' may not be used for parameterprofile - parameter attributes:'||
                       ' use the function PA_LIMSSPC.f_TransferSpcPpPrAu instead.');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Generate the attribute version based on the highest revision of the attribute
      l_at_revision := PA_LIMS.f_GetHighestRevision('attribute', a_au);
      l_au_version := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('au', a_au, l_at_revision);
      -- Transfer the attibute
      IF NOT PA_LIMScfg.f_TransferCfgAu(a_au, l_au_version) THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Fill in the parameters to get the standard attributes of the link between the attributes
      -- and the object - used object 
      l_object_tp         := a_tp;
      l_used_object_tp    := a_used_tp;
      l_object_id         := a_id;
      l_object_id_version := a_version;
      l_where_clause      := 'WHERE '||l_object_tp||'='''||REPLACE(a_id,'''','''''')|| -- single quote handling required (and done) (just to be safe)
                             ''' AND version = '''||a_version||
                             ''' AND '||l_used_object_tp||'='''||REPLACE(a_used_id,'''','''''')|| -- single quote handling required (and done) (just to be safe)
                             ''' ORDER BY auseq';
      -- Get the standard attributes of the link between the attributes
      -- and the object - used object
      l_return_value_get := UNAPIPRP.GETUSEDOBJECTATTRIBUTE@LNK_LIMS(l_object_tp, l_used_object_tp, l_object_id,
                               l_object_id_version, l_used_object_id_tab, l_used_object_id_version_tab, l_au_tab,
                               l_au_version_tab, l_value_tab, l_description_tab, l_is_protected_tab, 
                               l_single_valued_tab, l_new_val_allowed_tab, l_store_db_tab, l_value_list_tp_tab,
                               l_run_mode_tab, l_service_tab, l_cf_value_tab, l_nr_of_rows, l_where_clause);
      -- Check if the link between the attribute and the object - used object exists in Unilab.
      -- If no link is found, then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- When there are no records found, l_nr_ofrows=100. That's why it is reset to 0.
         l_nr_of_rows := 0;

         -- Get the authorisation of the object
         l_ret_code := UNAPIGEN.GETAUTHORISATION@LNK_LIMS(a_tp, a_id, a_version, l_obj_lc, l_obj_lc_version, l_obj_ss,
                                                          l_obj_allow_modify, l_obj_active, l_obj_log_hs);
         IF l_ret_code = PA_LIMS.DBERR_SUCCESS THEN
            -- Modifiable, used attribute can immediately be assigned
            l_insert := TRUE;
         ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
            -- Not modifiable, new minor version has to be created before used attribute can be assigend
            l_newminor := TRUE;
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
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         l_newminor := TRUE;
         l_row := 0;

         -- Check if the link between the attribute and the object - used object exists
         FOR l_row_counter IN 1 .. l_nr_of_rows
         LOOP
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_au_tab(l_row_counter), a_Au) = 1 THEN
               l_newminor := FALSE;
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_value_tab(l_row_counter), l_a_value) = 0 THEN
                  l_newminor4value := TRUE;
                  l_row := l_row_counter;
                  EXIT;
               END IF;
            END IF;
         END LOOP;
      ELSE
         IF l_return_value_get = PA_LIMS.DBERR_GENFAIL THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to retrieve the standard attributes of the link between the attributes and '||l_object||
                          ' - '||l_used_object||' (General failure! Error Code: '||l_return_value_save||
                          ' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
         ELSE
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to retrieve the standard attributes of the link between the attributes and '||l_object||
                          ' - '||l_used_object||' (Error code : '||l_return_value_get||').');
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- If some new attributes have to be assigned, a new minor version of the 
      -- object has to be created.
      -- In fact the f_TransferCfg[Pr|Mt] evaluates if it is really necessary to create a new minor version.
      -- If not modifiable, a new minor version will be created; in the other case
      -- the given version will be modified.
      IF (l_newminor OR l_newminor4value) THEN
         l_version := a_version;
         IF l_object_tp = 'pr' THEN
            /* is_historic is passed as 0 - we don't expect modifications on historic parameters */
            IF NOT PA_LIMSCFG.f_TransferCfgPr(a_id, l_version, NULL, NULL, NULL, '1', 0) THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         ELSIF l_object_tp = 'mt' THEN
            IF NOT PA_LIMSCFG.f_TransferCfgMt(a_id, l_version, NULL, NULL, NULL, '1') THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         END IF;
         a_version := l_version;
      END IF;

      -- Assign the new attribute
      IF (l_insert OR l_newminor) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the attributes and the object - used object.
         l_nr_of_rows                   := l_nr_of_rows + 1;
         l_object_tp                    := a_tp;
         l_used_object_tp               := a_used_tp;
         l_object_id                    := a_id;
         l_object_id_version            := a_version;
         l_used_object_id               := a_used_id;
         l_used_object_id_version       := a_used_version;
         l_au_tab(l_nr_of_rows)         := a_au;
         l_au_version_tab(l_nr_of_rows) := l_au_version;
         l_value_tab(l_nr_of_rows)      := RTRIM(l_a_value);
         l_modify_reason                := 'Imported the link between attribute "'||a_Au||'" and '||a_tp||' "'||
                                           a_id||'" - '||a_used_tp||' "'||a_used_id||'" from Interspec.';
         -- Save the standard attributes of the link 
         -- between the attributes and the object - used object.
         BEGIN
            l_return_value_save := UNAPIPRP.SAVEUSEDOBJECTATTRIBUTE@LNK_LIMS(l_object_tp, l_used_object_tp, 
                                      l_object_id, l_object_id_version, l_used_object_id, l_used_object_id_version,
                                      l_au_tab, l_au_version_tab, l_value_tab, l_nr_of_rows, l_modify_reason);
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
                             'Unable to save the standard attributes of '||l_objects||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      -- The link between the attribute and the object - used object is already in Unilab
      ELSIF (l_newminor4value) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the attribute and the object - used object.
         l_object_tp                    := a_tp;
         l_used_object_tp               := a_used_tp;
         l_object_id                    := a_id;
         l_object_id_version            := a_version;
         l_used_object_id               := a_used_id;
         l_used_object_id_version       := a_used_version;
         l_value_tab(l_row)             := RTRIM(l_a_value);
         l_modify_reason                := 'Imported the update of the link between attribute "'||a_Au||'" and '||
                                           a_tp||' "'||a_id||'" - '||a_used_tp||' "'||a_used_id||'" from Interspec.';
         -- Save the standard attributes of the link 
         -- between the attribute and the object - used object.
         BEGIN
            l_return_value_save := UNAPIPRP.SAVEUSEDOBJECTATTRIBUTE@LNK_LIMS(l_object_tp, l_used_object_tp,
                                      l_object_id, l_object_id_version, l_used_object_id, l_used_object_id_version,
                                      l_au_tab, l_au_version_tab, l_value_tab, l_nr_of_rows, l_modify_reason
                                   );
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the update of '||l_objects||' (General failure! Error Code: '||
                                l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the update of '||l_objects||' (Error code : '||l_return_value_save||').');
               END IF;
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the update of '||l_objects||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_tp||' | '||a_id||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_objects||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcUsedAu;

   FUNCTION f_TransferSpcStPpAu(
      a_st             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_pp             IN     VARCHAR2,
      a_pp_version     IN     VARCHAR2,
      a_pp_key1        IN     VARCHAR2,
      a_pp_key2        IN     VARCHAR2,
      a_pp_key3        IN     VARCHAR2,
      a_pp_key4        IN     VARCHAR2,
      a_pp_key5        IN     VARCHAR2,
      a_Au_tab         IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_Value_tab      IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows     IN     NUMBER
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer a sampletype - parameterprofile attribute from Unilab to Interspec
      -- ** Parameters **
      -- a_st           : sampletype
      -- a_version      : version of the sampletype
      -- a_pp           : parameterprofile assigned to the sampletype
      -- a_pp_version   : version of the parameterprofile
      -- a_pp_key1      : key1 of the parameterprofile
      -- a_pp_key2      : key2 of the parameterprofile
      -- a_pp_key3      : key3 of the parameterprofile
      -- a_pp_key4      : key4 of the parameterprofile
      -- a_pp_key5      : key5 of the parameterprofile
      -- a_au_tab       : array of attributes
      -- a_value_tab    : array of values of the attributes
      -- a_nr_of_rows   : number of rows
      -- ** Return **
      -- TRUE  : The transfer of the sampletype - parameterprofile attibute has succeeded.
      -- FALSE : The transfer of the sampletype - parameterprofile attribute has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcStPpAu';
      l_object       VARCHAR2(255);
      l_used_object  VARCHAR2(255);
      l_objects      VARCHAR2(255);

      -- General variables
      l_insert                BOOLEAN                           DEFAULT FALSE;
      l_newminor              BOOLEAN                           DEFAULT FALSE;
      l_newminor4value        BOOLEAN                           DEFAULT FALSE;
      l_version               VARCHAR2(20);
      l_at_revision           NUMBER;
      l_a_au_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_a_value_tab           UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      
      -- Specific local variables for the 'GetStPpAttribute' API
      l_return_value_get      NUMBER;
      l_where_clause          VARCHAR2(255);
      l_nr_of_rows            NUMBER;
      l_st_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_st_version_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_version_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_au_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_au_version_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab             UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_is_protected_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_single_valued_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_new_val_allowed_tab   UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_store_db_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_list_tp_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_run_mode_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_service_tab           UNAPIGEN.VC255_TABLE_TYPE@LNK_LIMS;
      l_cf_value_tab          UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'SaveStPpAttribute' API
      l_return_value_save     NUMBER;
      l_st                    VARCHAR2(20);
      l_st_version            VARCHAR2(20);
      l_pp                    VARCHAR2(20);
      l_pp_version            VARCHAR2(20);
      l_pp_key1               VARCHAR2(20);
      l_pp_key2               VARCHAR2(20);
      l_pp_key3               VARCHAR2(20);
      l_pp_key4               VARCHAR2(20);
      l_pp_key5               VARCHAR2(20);
      l_modify_reason         VARCHAR2(255);

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_st_lc                  VARCHAR2(2);
      l_st_lc_version          VARCHAR2(20);
      l_st_ss                  VARCHAR2(2);
      l_st_log_hs              CHAR(1);
      l_st_allow_modify        CHAR(1);
      l_st_active              CHAR(1);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, a_pp||' | '||a_pp_version, NULL, 
                      PA_LIMS.c_Msg_Started);
      PA_LIMS.p_Trace(l_classname, l_method, a_pp_key1||' | '||a_pp_key2, a_pp_key3||' | '||a_pp_key4,
                      a_pp_key5, NULL);
      -- Initializing variables
      l_object := 'sample type "'||a_st||'" | version='||a_version;
      l_used_object := 'parameterprofile "'||a_pp||'" | version='||a_pp_version||' | pp_keys="'||a_pp_key1||'"#"'||
                       a_pp_key2||'"#"'||a_pp_key3||'"#"'||a_pp_key4||'"#"'||a_pp_key5||'"';
      l_objects := 'the link between the attributes and '||l_object||' - '||l_used_object;
      
      FOR i IN 1..a_nr_of_rows LOOP
         -- Convert the arguments to their maximum length
         l_a_value_tab(i) := SUBSTR(a_value_tab(i), 1, 40);
         -- Generate the attribute version based on the highest revision of the attribute
         l_at_revision := PA_LIMS.f_GetHighestRevision('attribute', a_au_tab(i));
         l_a_au_version_tab(i) := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('au', a_au_tab(i), l_at_revision);
         -- Transfer the attibute
         IF NOT PA_LIMScfg.f_TransferCfgAu(a_au_tab(i), l_a_au_version_tab(i)) THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
      END LOOP;

      -- Fill in the parameters to get the standard attributes of the link between the attributes
      -- and the sampletype - parameterprofile
      l_where_clause      := 'WHERE st='''||REPLACE(a_st,'''','''''')||''' AND version='''||a_version||
                             ''' AND pp='''||REPLACE(a_pp,'''','''''')||
                             ''' AND pp_key1='''||REPLACE(a_pp_key1,'''','''''')||
                             ''' AND pp_key2='''||REPLACE(a_pp_key2,'''','''''')||
                             ''' AND pp_key3='''||REPLACE(a_pp_key3,'''','''''')||
                             ''' AND pp_key4='''||REPLACE(a_pp_key4,'''','''''')||
                             ''' AND pp_key5='''||REPLACE(a_pp_key5,'''','''''')||''' ORDER BY auseq';
      -- Get the standard attributes of the link between the attributes
      -- and the sampletype - parameterprofile
      l_return_value_get := UNAPIST.GETSTPPATTRIBUTE@LNK_LIMS(l_st_tab, l_st_version_tab, l_pp_tab, l_pp_version_tab,
                               l_pp_key1_tab, l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_au_tab,
                               l_au_version_tab, l_value_tab, l_description_tab, l_is_protected_tab, 
                               l_single_valued_tab, l_new_val_allowed_tab, l_store_db_tab, l_value_list_tp_tab,
                               l_run_mode_tab, l_service_tab, l_cf_value_tab, l_nr_of_rows, l_where_clause);
      -- Check if the link between the attribute and the sampletype - parameterprofile exists in Unilab.
      -- If no link is found, then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- When there are no records found, l_nr_ofrows=100. That's why it is reset to 0.
         l_nr_of_rows := 0;

         -- Get the authorisation of the sample type
         l_ret_code := UNAPIGEN.GETAUTHORISATION@LNK_LIMS('st', a_st, a_version, l_st_lc, l_st_lc_version, l_st_ss,
                                                          l_st_allow_modify, l_st_active, l_st_log_hs);
         IF l_ret_code = PA_LIMS.DBERR_SUCCESS THEN
            -- Modifiable, used attribute can immediately be assigned
            l_insert := TRUE;
         ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
            -- Not modifiable, new minor version has to be created before used attribute can be assigend
            l_newminor := TRUE;
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
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         l_newminor := TRUE;

         -- Check if the link between the attributes and the sampletype - parameterprofile exists
         FOR i IN 1..a_nr_of_rows LOOP
            FOR l_row_counter IN 1 .. l_nr_of_rows LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_au_tab(l_row_counter), a_Au_tab(i)) = 1 THEN
                  l_newminor := FALSE;
                  IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_value_tab(l_row_counter), l_a_value_tab(i)) = 0 THEN
                     l_newminor4value := TRUE;
                     l_value_tab(l_row_counter) := RTRIM(l_a_value_tab(i));
                     EXIT;
                  END IF;
               END IF;
            END LOOP;
         END LOOP;
      ELSE
         IF l_return_value_get = PA_LIMS.DBERR_GENFAIL THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                'Unable to retrieve the standard attributes of the link between the attributes and '||l_object||' - '||
                l_used_object||' (General failure! Error Code: '||l_return_value_get||' Error Msg:'||
                UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
         ELSE
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                'Unable to retrieve the standard attributes of the link between the attributes and '||l_object||' - '||
                l_used_object||' (Error code : '||l_return_value_get||').');
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- If some new attributes have to be assigned, a new minor version of the 
      -- sampletype has to be created.
      -- In fact the f_TransferSpcSt evaluates if it is really necessary to create a new minor version.
      -- If not modifiable, a new minor version will be created; in the other case
      -- the given version will be modified.
      IF (l_newminor OR l_newminor4value) THEN
         l_version := a_version;
         IF NOT PA_LIMSSPC.f_TransferSpcSt(a_st, l_version, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1') THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
         a_version := l_version;
      END IF;

      -- Assign the new attribute
      IF (l_insert OR l_newminor) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the attributes and the sampletype - parameterprofile.
         l_st                           := a_st;
         l_st_version                   := a_version;
         l_pp                           := a_pp;
         l_pp_version                   := a_pp_version;
         l_pp_key1                      := a_pp_key1;
         l_pp_key2                      := a_pp_key2;
         l_pp_key3                      := a_pp_key3;
         l_pp_key4                      := a_pp_key4;
         l_pp_key5                      := a_pp_key5;
         FOR i IN 1..a_nr_of_rows LOOP
            l_nr_of_rows                   := l_nr_of_rows + 1;
            l_au_tab(l_nr_of_rows)         := a_au_tab(i);
            l_au_version_tab(l_nr_of_rows) := l_a_au_version_tab(i);
            l_value_tab(l_nr_of_rows)      := RTRIM(l_a_value_tab(i));
         END LOOP;
         l_modify_reason                := 'Imported the link between the attributes and sample type "'||
                                           a_st||'" - parameterprofile "'||a_pp||'" from Interspec.';
         -- Save the standard attributes of the link 
         -- between the attributes and the sampletype - parameterprofile.
         BEGIN
            l_return_value_save := UNAPIST.SAVESTPPATTRIBUTE@LNK_LIMS(l_st, l_st_version, l_pp, l_pp_version,
                                      l_pp_key1, l_pp_key2, l_pp_key3, l_pp_key4, l_pp_key5, l_au_tab, l_value_tab,
                                      l_au_version_tab, l_nr_of_rows, l_modify_reason);
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
                             'Unable to save the standard attributes of '||l_objects||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      -- The link between the attribute and the sampletype - parameterprofile is already in Unilab
      ELSIF (l_newminor4value) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the attribute and the sampletype - parameterprofile.
         l_st                           := a_st;
         l_st_version                   := a_version;
         l_pp                           := a_pp;
         l_pp_version                   := a_pp_version;
         l_pp_key1                      := a_pp_key1;
         l_pp_key2                      := a_pp_key2;
         l_pp_key3                      := a_pp_key3;
         l_pp_key4                      := a_pp_key4;
         l_pp_key5                      := a_pp_key5;
         l_modify_reason                := 'Imported the update of the link between the attributes '||
                                           'and sample type "'||a_st||'" - parameterprofile "'||a_pp||
                                           '" from Interspec.';
         -- Save the standard attributes of the link 
         -- between the attribute and the sampletype - parameterprofile.
         BEGIN
            l_return_value_save := UNAPIST.SAVESTPPATTRIBUTE@LNK_LIMS(l_st, l_st_version, l_pp, l_pp_version,
                                      l_pp_key1, l_pp_key2, l_pp_key3, l_pp_key4, l_pp_key5, l_au_tab, l_value_tab,
                                      l_au_version_tab, l_nr_of_rows, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the update of '||l_objects||' (General failure! Error Code: '||
                                l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the update of '||l_objects||' (Error code : '||l_return_value_save||').');
               END IF;
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the update of '||l_objects||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_objects||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcStPpAu;

   FUNCTION f_TransferSpcPpPrAu(
      a_pp             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_pp_key1        IN     VARCHAR2,
      a_pp_key2        IN     VARCHAR2,
      a_pp_key3        IN     VARCHAR2,
      a_pp_key4        IN     VARCHAR2,
      a_pp_key5        IN     VARCHAR2,
      a_pr             IN     VARCHAR2,
      a_pr_version     IN     VARCHAR2,
      a_au_tab         IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_value_tab      IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows     IN     NUMBER
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer a parameterprofile - parameter definition attribute from Interspec to Unilab
      -- ** Parameters **
      -- a_pp         : parameterprofile
      -- a_version    : version of the parameterprofile
      -- a_pp_key1    : key1 of the parameterprofile
      -- a_pp_key2    : key2 of the parameterprofile
      -- a_pp_key3    : key3 of the parameterprofile
      -- a_pp_key4    : key4 of the parameterprofile
      -- a_pp_key5    : key5 of the parameterprofile
      -- a_pr         : parameter definition assigned to the parameterprofile
      -- a_pr_version : version of the parameter definition
      -- a_au_tab     : array of attributes
      -- a_value_tab  : array of values of the attribute
      -- a_nr_of_rows : number of rows
      -- ** Return **
      -- TRUE  : The transfer of the parameterprofile - parameter definition attibute has succeeded.
      -- FALSE : The transfer of the parameterprofile - parameter definition attribute has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcPpPrAu';
      l_object       VARCHAR2(255);
      l_used_object  VARCHAR2(255);
      l_objects      VARCHAR2(255);

      -- General variables
      l_insert                BOOLEAN                           DEFAULT FALSE;
      l_newminor              BOOLEAN                           DEFAULT FALSE;
      l_newminor4value        BOOLEAN                           DEFAULT FALSE;
      l_version               VARCHAR2(20);
      l_at_revision           NUMBER;
      l_a_au_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_a_value_tab           UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      
      -- Specific local variables for the 'GetPpPrAttribute' API
      l_return_value_get      NUMBER;
      l_where_clause          VARCHAR2(255);
      l_nr_of_rows            NUMBER;
      l_pp                    VARCHAR2(20);
      l_pp_version            VARCHAR2(20);
      l_pp_key1               VARCHAR2(20);
      l_pp_key2               VARCHAR2(20);
      l_pp_key3               VARCHAR2(20);
      l_pp_key4               VARCHAR2(20);
      l_pp_key5               VARCHAR2(20);
      l_pr_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_version_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_au_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_au_version_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab             UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_is_protected_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_single_valued_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_new_val_allowed_tab   UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_store_db_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_list_tp_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_run_mode_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_service_tab           UNAPIGEN.VC255_TABLE_TYPE@LNK_LIMS;
      l_cf_value_tab          UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      
      -- Specific local variables for the 'SavePpPrAttribute' API
      l_return_value_save     NUMBER;
      l_pr                    VARCHAR2(20);
      l_pr_version            VARCHAR2(20);
      l_modify_reason         VARCHAR2(255);

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_pp_lc                  VARCHAR2(2);
      l_pp_lc_version          VARCHAR2(20);
      l_pp_ss                  VARCHAR2(2);
      l_pp_log_hs              CHAR(1);
      l_pp_allow_modify        CHAR(1);
      l_pp_active              CHAR(1);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Pp||' | '||a_version, a_Pr||' | '||a_pr_version,
                      NULL, PA_LIMS.c_Msg_Started);
      PA_LIMS.p_Trace(l_classname, l_method, a_pp_key1||' | '||a_pp_key2, a_pp_key3||' | '||a_pp_key4,
                      a_pp_key5, NULL);
      
      -- Initializing variables
      l_object := 'parameterprofile "'||a_pp||'" | version='||a_version||' | pp_keys="'||a_pp_key1||'"#"'||a_pp_key2||
                  '"#"'||a_pp_key3||'"#"'||a_pp_key4||'"#"'||a_pp_key5||'"';
      l_used_object := 'parameter "'||a_pr||'" | version='||a_pr_version;
      l_objects := 'the link between the attributes and '||l_object||' - '||l_used_object;

      FOR i IN 1..a_nr_of_rows LOOP
         -- Convert the arguments to their maximum length
         l_a_value_tab(i) := SUBSTR(a_value_tab(i), 1, 40);
         -- Generate the attribute version based on the highest revision of the attribute
         l_at_revision := PA_LIMS.f_GetHighestRevision('attribute', a_au_tab(i));
         l_a_au_version_tab(i) := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('au', a_au_tab(i), l_at_revision);

         -- Transfer the attibute
         IF NOT PA_LIMScfg.f_TransferCfgAu(a_au_tab(i), l_a_au_version_tab(i)) THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
      END LOOP;

      -- Fill in the parameters to get the standard attributes of the link between 
      -- the attributes and the parameterprofile - parameter definition
      l_where_clause := 'WHERE pp='''||REPLACE(a_pp,'''','''''')||''' AND version='''||a_version||
                        ''' AND pp_key1='''||REPLACE(a_pp_key1,'''','''''')||
                        ''' AND pp_key2='''||REPLACE(a_pp_key2,'''','''''')||
                        ''' AND pp_key3='''||REPLACE(a_pp_key3,'''','''''')||
                        ''' AND pp_key4='''||REPLACE(a_pp_key4,'''','''''')||
                        ''' AND pp_key5='''||REPLACE(a_pp_key5,'''','''''')||
                        ''' AND pr='''||REPLACE(a_pr,'''','''''')||''' ORDER BY auseq';
      -- Get the standard attributes of the link between 
      -- the attributes and the parameterprofile - parameter definition
      l_return_value_get := UNAPIPPP.GETPPPRATTRIBUTE@LNK_LIMS(l_pp, l_pp_version, l_pp_key1, l_pp_key2, l_pp_key3,
                               l_pp_key4, l_pp_key5, l_pr_tab, l_pr_version_tab, l_au_tab, l_au_version_tab,
                               l_value_tab, l_description_tab, l_is_protected_tab, l_single_valued_tab, 
                               l_new_val_allowed_tab, l_store_db_tab, l_value_list_tp_tab, l_run_mode_tab,
                               l_service_tab, l_cf_value_tab, l_nr_of_rows, l_where_clause);
      -- Check if the link between the attribute and the parameterprofile - parameter definition in Unilab exists
      -- If no link is found, then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- When there are no records found, l_nr_ofrows=100. That's why it is reset to 0.
         l_nr_of_rows := 0;

         -- Get the authorisation of the parameterprofile
         l_ret_code := UNAPIPPP.GETPPAUTHORISATION@LNK_LIMS(a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3,
                                                            a_pp_key4, a_pp_key5, l_pp_lc, l_pp_lc_version, l_pp_ss,
                                                            l_pp_allow_modify, l_pp_active, l_pp_log_hs);
         IF l_ret_code = PA_LIMS.DBERR_SUCCESS THEN
            -- Modifiable, used attribute can immediately be assigned
            l_insert := TRUE;
         ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
            -- Not modifiable, new minor version has to be created before used attribute can be assigend
            l_newminor := TRUE;
         ELSIF l_ret_code <> PA_LIMS.DBERR_SUCCESS THEN
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
         END IF;
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         l_newminor := TRUE;

         -- Check if the link between the attributes and the parameterprofile - parameter definition exists
         FOR i IN 1..a_nr_of_rows LOOP
            FOR l_row_counter IN 1 .. l_nr_of_rows LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_au_tab(l_row_counter), a_au_tab(i)) = 1 THEN
                  l_newminor := FALSE;
                  IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_value_tab(l_row_counter), l_a_value_tab(i)) = 0 THEN
                     l_newminor4value := TRUE;
                     l_value_tab(l_row_counter) := RTRIM(l_a_value_tab(i));
                     EXIT;
                  END IF;
               END IF;
            END LOOP;
         END LOOP;
      ELSE
         IF l_return_value_get = PA_LIMS.DBERR_GENFAIL THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
              'Unable to retrieve the standard attributes of the link between the attributes and '||l_object||' - '||
              l_used_object||' (General failure! Error Code: '||l_return_value_save||' Error Msg:'||
              UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
         ELSE
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
              'Unable to retrieve the standard attributes of the link between the attributes and '||l_object||' - '||
              l_used_object||' (Error code : '||l_return_value_get||').');
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- If some new attributes have to be assigned, a new minor version of the 
      -- parameterprofile has to be created.
      -- In fact the f_TransferSpcPp evaluates if it is really necessary to create a new minor version.
      -- If not modifiable, a new minor version will be created; in the other case
      -- the given version will be modified.
      IF (l_newminor OR l_newminor4value) THEN
         l_version := a_version;
         IF NOT PA_LIMSSPC.f_TransferSpcPp(a_pp, l_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, 
                                           a_pp_key5, NULL, NULL, NULL, NULL, '1') THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
         a_version := l_version;
      END IF;

      -- Assign the new attribute
      IF (l_insert OR l_newminor) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the attributes and the parameterprofile - parameter definition.
         l_pp                           := a_pp;
         l_pp_version                   := a_version;
         l_pp_key1                      := a_pp_key1;
         l_pp_key2                      := a_pp_key2;
         l_pp_key3                      := a_pp_key3;
         l_pp_key4                      := a_pp_key4;
         l_pp_key5                      := a_pp_key5;
         l_pr                           := a_pr;
         l_pr_version                   := a_pr_version;
         FOR i IN 1..a_nr_of_rows LOOP
            l_nr_of_rows                   := l_nr_of_rows + 1;
            l_au_tab(l_nr_of_rows)         := a_au_tab(i);
            l_au_version_tab(l_nr_of_rows) := l_a_au_version_tab(i);
            l_value_tab(l_nr_of_rows)      := RTRIM(l_a_value_tab(i));
         END LOOP;
         l_modify_reason                := 'Imported the link between the attributes '||
                                           ' and parameter profile "'||a_pp||'" - parameter "'||a_pr||
                                           '" from Interspec.';
         -- Save the standard attributes of the link 
         -- between the attributes and the parameterprofile - parameter definition.
         BEGIN
            l_return_value_save := UNAPIPPP.SAVEPPPRATTRIBUTE@LNK_LIMS(l_pp, l_pp_version, l_pp_key1, l_pp_key2,
                                      l_pp_key3, l_pp_key4, l_pp_key5, l_pr, l_pr_version, l_au_tab, 
                                      l_au_version_tab, l_value_tab, l_nr_of_rows, l_modify_reason);
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
                             'Unable to save the standard attributes of '||l_objects||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      -- The link between the attribute and the parameterprofile - parameter definition is already in Unilab
      ELSIF (l_newminor4value) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the attribute and the parameterprofile - parameter definition.
         l_pp                           := a_pp;
         l_pp_version                   := a_version;
         l_pp_key1                      := a_pp_key1;
         l_pp_key2                      := a_pp_key2;
         l_pp_key3                      := a_pp_key3;
         l_pp_key4                      := a_pp_key4;
         l_pp_key5                      := a_pp_key5;
         l_pr                           := a_pr;
         l_pr_version                   := a_pr_version;
         l_modify_reason                := 'Imported the update of the link between the attributes '||
                                           ' and parameter profile "'||a_pp||'" - parameter "'||a_pr||
                                           '" from Interspec.';
         -- Save the standard attributes of the link 
         -- between the attribute and the parameterprofile - parameter definition.
         BEGIN
            l_return_value_save := UNAPIPPP.SAVEPPPRATTRIBUTE@LNK_LIMS(l_pp, l_pp_version, l_pp_key1, l_pp_key2,
                                      l_pp_key3, l_pp_key4, l_pp_key5, l_pr, l_pr_version, l_au_tab, 
                                      l_au_version_tab, l_value_tab, l_nr_of_rows, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the update of '||l_objects||' (General failure! Error Code: '||
                                l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the update of '||l_objects||' (Error code : '||l_return_value_save||').');
               END IF;
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the update of '||l_objects||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Pp||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_objects||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcPpPrAu;

   FUNCTION f_TransferSpcAllPpPrAu(
      a_St                 IN     VARCHAR2,
      a_version            IN OUT VARCHAR2,
      a_sh_revision        IN     NUMBER,
      a_Part_No            IN     specification_header.part_no%TYPE,
      a_Revision           IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer the attributes of the link between the parameter definition and the
      -- parameterprofile to Unilab. (These are all the properties that are configured 
      -- as user defined attributes of a parameter)
      -- ** Parameters **
      -- a_st                : sampletype
      -- a_version           : version of the sampletype
      -- a_sh_revision       : revision of the specification, to base the parameterprofile version on
      -- a_part_no           : part_no of the specification
      -- a_revision          : revision of the specification
      -- ** Return **
      -- TRUE  : The transfer of the attributes has succeeded.
      -- FALSE : The transfer of the attributes has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname         CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method            CONSTANT VARCHAR2(32)                      := 'f_TransferSpcAllPpPrAu';
      l_object            VARCHAR2(255);

      -- General variables
      l_display_type_tab  VC20_MATRIX_TYPE;
      l_au_tab            VC20_MATRIX_TYPE;
      l_value_tab         VC40_MATRIX_TYPE;
      l_pr_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_nr_of_au          NUMBER;
      l_nr_of_pr          NUMBER;
      l_pr_index          NUMBER;
      l_PrevPg            NUMBER(6);
      l_PrevSc            NUMBER(8);
      l_PrevSsc           NUMBER(8);
      l_PrevPp            VARCHAR2(20);
      l_PrevPpVersion     VARCHAR2(20);
      l_frequnit          NUMBER;
      
      l_Property          NUMBER;
      l_Attribute         NUMBER;
      l_Value             VARCHAR2(120);
      l_Value_descr       VARCHAR2(40);
      l_StAuId            VARCHAR2(20);
      l_StPp              VARCHAR2(20);
      l_pp_version        VARCHAR2(20);
      l_pp_desc           VARCHAR2(40);
      l_pg_revision       NUMBER;
      l_PrId              VARCHAR2(20);
      l_pppr_version      VARCHAR2(20);
      l_pr_desc           VARCHAR2(40);
      l_sp_revision       NUMBER;
      l_sp_desc           VARCHAR2(130);
      l_linked_part_no    specification_header.part_no%TYPE;
      -- Dynamic SQL
      l_cur_hdl           INTEGER;
      l_return_value      INTEGER;
      l_sql               DBMS_SQL.varchar2s;

      -- Cursor to get all the links between the parameter definition and the parameterprofile
      -- that have a user defined attribute configured
      CURSOR l_GetPpPrAu_Cursor(
         c_Part_No    specification_prop.part_no%TYPE,
         c_Revision   specification_prop.revision%TYPE
      )
      IS
         SELECT DISTINCT ivpgpr.display_format, ivpgpr.display_format_rev,
                         ivpgpr.property_group, limsc.is_col,
                         ivpgpr.section_id, ivpgpr.sub_section_id,
                         f_pgh_descr(1, ivpgpr.property_group, 0) pg_desc
                    FROM itlimsconfly limsc, ivpgpr
                   WHERE ivpgpr.display_format = limsc.layout_id
                     AND ivpgpr.display_format_rev = limsc.layout_rev
                     AND ivpgpr.type = 1
                     AND ivpgpr.part_no = c_Part_No
                     AND ivpgpr.revision = c_Revision
                     AND limsc.un_object = 'PPPR'
                     AND limsc.un_type = 'AU'
                     ORDER BY ivpgpr.property_group, ivpgpr.section_id, ivpgpr.sub_section_id;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, a_sh_revision, a_part_no||' | '||a_revision,
                      PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object        := 'sample type "'||a_St||'" | version='||a_version;
      l_nr_of_au      := 0;
      l_nr_of_pr      := 0;
      l_PrevPg        := -1;
      l_PrevSc        := -1;
      l_PrevSsc       := -1;
      l_PrevPp        := ' ';
      l_PrevPpVersion := ' ';
      l_frequnit      := 0;
      l_pppr_version  := '~Current~';
      
      -- Assign all the properties that are defined as user attributes of the
      -- link between the parameter definition and the parameter profile
      --
      --This cursor is returning one record by property group and by au mapped with a ppprau
      -- (pr and value) are fetched later by (property group, section, subsection)
      FOR l_GetPpPrAu_Rec IN l_GetPpPrAu_Cursor(a_Part_No, a_Revision) LOOP
         -- Generate the parameterprofile id, version and description, 
         -- based on the highest revision of the property group
         l_pg_revision := PA_LIMS.f_GetHighestRevision('property_group', l_GetPpPrAu_Rec.property_group);
         -- Only for a linked specification, the parameterprofile description should start with the part_no
         IF a_st <> a_part_no THEN
            l_linked_part_no := a_part_no;
         END IF;
         l_StPp := PA_LIMS.f_GetPpId(l_linked_part_no, l_GetPpPrAu_Rec.property_group, l_pg_revision,
                                     l_GetPpPrAu_Rec.pg_desc, l_pp_desc);
         l_pp_version := UNVERSION.CONVERTINTERSPEC2UNILABPP@LNK_LIMS(l_stpp, 
                                                                      PA_LIMS.g_pp_key(1), PA_LIMS.g_pp_key(2), 
                                                                      PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                                                                      PA_LIMS.g_pp_key(5), a_sh_revision);

         -- Initialize variables on the first time the loop is run
         IF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, -1) = 1) THEN
            l_PrevPg        := l_GetPpPrAu_Rec.property_group;
            l_PrevSc        := l_GetPpPrAu_Rec.section_id;
            l_PrevSsc       := l_GetPpPrAu_Rec.sub_section_id;
            l_PrevPp        := l_stpp;
            l_PrevPpVersion := l_pp_version;
            l_nr_of_au      := l_nr_of_au + 1;
         -- Only transfer when property group/section or subsection changes
         ELSIF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, l_GetPpPrAu_Rec.property_group) = 0 OR
                PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevSc, l_GetPpPrAu_Rec.section_id) = 0 OR
                PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevSsc, l_GetPpPrAu_Rec.sub_section_id) = 0) THEN
            FOR i IN 1..l_nr_of_pr LOOP
               BEGIN
                  -- Transfer the attribute
                  IF NOT f_TransferSpcPpPrAu(l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), 
                        PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                        PA_LIMS.g_pp_key(5), l_pr_tab(i), l_pppr_version, l_au_tab(i), 
                        l_value_tab(i), l_nr_of_au) THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
                  END IF;
                  -- Update freq + unit
                  IF l_frequnit = 1 THEN
                     PA_SPECXINTERFACE.P_SAVEPPPRPROPERTY@LNK_LIMS
                        (l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), PA_LIMS.g_pp_key(2),
                         PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), PA_LIMS.g_pp_key(5),
                         l_pr_tab(i), l_pppr_version, 
                         l_display_type_tab(i), l_au_tab(i), l_value_tab(i), l_nr_of_au);
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     -- Log an error in ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to transfer the attributes of the link between parameter "'||l_pr_tab(i)||
                                   '" | version='||l_pppr_version||' and parameterprofile "'||l_PrevPp||
                                   '" | version='||l_PrevPpVersion);
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'pp_keys="'||PA_LIMS.g_pp_key(1)||'"#"'||
                                   PA_LIMS.g_pp_key(2)||'"#"'||PA_LIMS.g_pp_key(3)||'"#"'||PA_LIMS.g_pp_key(4)||'"#"'||
                                   PA_LIMS.g_pp_key(5)||'" : '||SQLERRM);
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
               END;
            END LOOP;
            
            l_PrevPg        := l_GetPpPrAu_Rec.property_group;
            l_PrevSc        := l_GetPpPrAu_Rec.section_id;
            l_PrevSsc       := l_GetPpPrAu_Rec.sub_section_id;            
            l_PrevPp        := l_stpp;
            l_PrevPpVersion := l_pp_version;
            l_nr_of_au      := 1;
            l_nr_of_pr      := 0;
         ELSE
            l_nr_of_au := l_nr_of_au + 1;
         END IF;

         -- Open the cursor
         l_cur_hdl := DBMS_SQL.Open_Cursor;
         -- Create the dynamic Select statement
         l_sql(1) :=    'SELECT p.property, sp.attribute, '||l_GetPpPrAu_Rec.is_col||' '||
                        'FROM specification_prop sp, property p ';
         l_sql(2) :=    'WHERE sp.property = p.property AND part_no = :a_Part_No '||
                        'AND revision = :a_Revision ';
         l_sql(3) :=    'AND property_group = :property_group '||
                        'AND section_id     = :section_id '||
                        'AND sub_section_id = :sub_section_id '||
                        'ORDER BY p.property, sp.attribute';
         -- Set the SQL statement
         DBMS_SQL.PARSE(l_cur_hdl, l_sql, 1, 3, FALSE, DBMS_SQL.NATIVE);
         -- Define the columns in the select statement
         DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 1, l_Property);
         DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 2, l_Attribute);
         DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 3, l_Value, 120);
         DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':a_Part_No', a_Part_No);
         DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':a_Revision', a_Revision);
         DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':property_group', l_GetPpPrAu_Rec.property_group);
         DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':section_id', l_GetPpPrAu_Rec.section_id);
         DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':sub_section_id', l_GetPpPrAu_Rec.sub_section_id);
         -- Execute the select statement, the function returns
         -- the number of rows that are fetched
         l_return_value := DBMS_SQL.EXECUTE_AND_FETCH(l_cur_hdl);
         IF l_return_value = 0 THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
               'Unable to transfer the attributes of the link between parameter and parameterprofile for ');
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, l_object||' (There is no attribute data.)');
            -- Close the cursor
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;

         -- Generate the attribute Id
         l_StAuId := PA_LIMS.f_GetStPpPrAuId(l_GetPpPrAu_Rec.display_format, l_GetPpPrAu_Rec.display_format_rev,
                                             l_GetPpPrAu_Rec.is_col);
         -- Check if the value has to be saved as pppr property frequency or unit
         IF l_StAuId IN ('U4','UOM') OR 
            l_GetPpPrAu_Rec.is_col = 'UOM_ID' THEN
            l_frequnit := 1;
         END IF;
         
         -- Initialize counter variables
         l_pr_index := 0;

         LOOP
            -- Get the value of the columns
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 1, l_Property);
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 2, l_Attribute);
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 3, l_Value);

            -- Generate the parameter definition id, version and description, 
            -- based on the highest revision of the property
            l_sp_revision := PA_LIMS.f_GetHighestRevision('property', l_Property);
            IF l_attribute = 0 THEN
               l_sp_desc := f_sph_descr(1,l_property,0);
            ELSE
               l_sp_desc := f_sph_descr(1,l_property,0)||' '||f_ath_descr(1,l_attribute,0);
            END IF;
            l_PrId := PA_LIMS.f_GetPrId(l_Property, l_sp_revision, l_attribute, l_sp_desc, l_pr_desc);

            -- Changed by EH on 25/02/2001. If the attribute is of type 'UOM', the description of the
            -- UOM should become the value of the attribute instead of the UOM_ID.
            IF l_GetPpPrAu_Rec.is_col = 'UOM_ID' THEN
               BEGIN
                  SELECT SUBSTR(description,1,40)
                    INTO l_Value_descr
                    FROM uom
                   WHERE uom_id = l_Value;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     l_Value_descr := NULL;
               END;
            -- Changed by AD on 4/11/2003. If the attribute is of type 'CHARACTERISTIC', the description of the
            -- CHARACTERISTIC should become the value of the attribute instead of the CHARACTERISTIC_ID.
            ELSIF l_GetPpPrAu_Rec.IS_COL IN ('CHARACTERISTIC','CH_2','CH_3') THEN
               BEGIN
                  SELECT SUBSTR(description,1,40)
                    INTO l_Value_descr
                    FROM characteristic
                   WHERE characteristic_id = l_Value;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     l_Value_descr := NULL;
               END;
            -- If the attribute is of type 'test_method', the description of the
            -- test method should become the value of the attribute instead of the test_method_id.
            ELSIF l_GetPpPrAu_Rec.IS_COL = 'test_method' THEN
               BEGIN
                  SELECT SUBSTR(description,1,40)
                    INTO l_Value_descr
                    FROM test_method
                   WHERE test_method = l_Value;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     l_Value_descr := NULL;
               END;
            ELSE
               l_value_descr := SUBSTR(l_Value,1,40);
            END IF;
            
            -- Save in arrays, the transfer happens later
            IF l_nr_of_au = 1 THEN
               l_nr_of_pr := l_nr_of_pr + 1;
               l_pr_tab(l_nr_of_pr) := l_PrId;
            END IF;
            l_pr_index := l_pr_index + 1;
            l_display_type_tab(l_pr_index)(l_nr_of_au) := SUBSTR(l_GetPpPrAu_Rec.is_col,1,20);
            l_au_tab(l_pr_index)(l_nr_of_au) := l_StAuId;
            l_value_tab(l_pr_index)(l_nr_of_au) := l_Value_descr;

            -- Get the values of the next property
            l_return_value := DBMS_SQL.FETCH_ROWS(l_cur_hdl);
            EXIT WHEN l_return_value = 0;
         END LOOP;
         -- Close the cursor
         DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
      END LOOP;

      -- Execute once for the last propertygroup, but only if necessary.
      IF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, -1) = 0) THEN
         FOR i IN 1..l_nr_of_pr LOOP
            BEGIN
               -- Transfer the attribute
               IF NOT f_TransferSpcPpPrAu(l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), 
                     PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                     PA_LIMS.g_pp_key(5), l_pr_tab(i), l_pppr_version, l_au_tab(i), 
                     l_value_tab(i), l_nr_of_au) THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               END IF;
               -- Update freq + unit
               IF l_frequnit = 1 THEN
                  PA_SPECXINTERFACE.P_SAVEPPPRPROPERTY@LNK_LIMS
                     (l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), PA_LIMS.g_pp_key(2),
                      PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), PA_LIMS.g_pp_key(5),
                      l_pr_tab(i), l_pppr_version, 
                      l_display_type_tab(i), l_au_tab(i), l_value_tab(i), l_nr_of_au);
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  -- Log an error in ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to transfer the attributes of the link between parameter "'||l_pr_tab(i)||
                                '" | version='||l_pppr_version||' and parameterprofile "'||l_PrevPp||
                                '" | version='||l_PrevPpVersion);
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'pp_keys="'||PA_LIMS.g_pp_key(1)||'"#"'||
                                PA_LIMS.g_pp_key(2)||'"#"'||PA_LIMS.g_pp_key(3)||'"#"'||PA_LIMS.g_pp_key(4)||'"#"'||
                                PA_LIMS.g_pp_key(5)||'" : '||SQLERRM);
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
            END;
         END LOOP;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
           'Unable to transfer the attributes of the link between parameter and parameterprofile for '||l_object||'.');
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
           SQLERRM);
         -- Close the cursor if the cursor is still open
         IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcAllPpPrAu;

   FUNCTION f_TransferSpcAllPpPrAu_AttSp(
      a_Part_No            IN     specification_header.part_no%TYPE,
      a_Revision           IN     specification_header.revision%TYPE,
      a_SectionId_tab      IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_SubSectionId_tab   IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows         IN     NUMBER,
      a_PropertyGroup      IN     specification_prop.property_group%TYPE,
      a_PpId               IN     VARCHAR2,
      a_pp_version         IN OUT VARCHAR2,
      a_pp_key1            IN     VARCHAR2,
      a_pp_key2            IN     VARCHAR2,
      a_pp_key3            IN     VARCHAR2,
      a_pp_key4            IN     VARCHAR2,
      a_pp_key5            IN     VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer the attributes of the link between the parameter definition and 
      -- the parameterprofile to Unilab 
      -- (This are all the properties that are configured as 
      -- user defined attributes of a parameter) for the merged specs
      -- a_st            : sampletype
      -- a_part_no       : part_no of the specification
      -- a_revision      : revision of the specification
      -- a_sectionid     : section of the specification
      -- a_subsectionid  : subsection of the specification
      -- a_propertygroup : propertygroup of the specification
      -- a_ppid          : parameterprofile
      -- a_pp_version    : version of the parameterprofile
      -- a_pp_key1       : pp_key1 of the parameterprofile
      -- a_pp_key2       : pp_key2 of the parameterprofile
      -- a_pp_key3       : pp_key3 of the parameterprofile
      -- a_pp_key4       : pp_key4 of the parameterprofile
      -- a_pp_key5       : pp_key5 of the parameterprofile
      -- ** Return **
      -- TRUE  : The transfer of the attributes has succeeded.
      -- FALSE : The transfer of the attributes has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc2';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcAllPpPrAu_AttSp';

      -- General variables
      l_display_type_tab  VC20_MATRIX_TYPE;
      l_au_tab            VC20_MATRIX_TYPE;
      l_value_tab         VC40_MATRIX_TYPE;
      l_pr_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_nr_of_au          NUMBER;
      l_nr_of_pr          NUMBER;
      l_pr_index          NUMBER;
      l_frequnit          NUMBER;

      l_Property       NUMBER;
      l_Attribute      NUMBER;
      l_Value          VARCHAR2(120);
      l_Value_descr    VARCHAR2(40);
      l_StAuId         VARCHAR2(20);
      l_StPp           VARCHAR2(20);
      l_PrId           VARCHAR2(20);
      l_pppr_version   VARCHAR2(20);
      l_pr_desc        VARCHAR2(40);
      l_sp_revision    NUMBER;
      l_sp_desc        VARCHAR2(130);
      -- Dynamic SQL
      l_cur_hdl        INTEGER;
      l_return_value   INTEGER;
      l_sql            DBMS_SQL.varchar2s;

      -- Cursor to get all the attributes of the link between the parameter definition and 
      -- the parameterprofile
      CURSOR l_GetPpPrAu_Cursor(
         c_Part_No         specification_prop.part_no%TYPE,
         c_Revision        specification_prop.revision%TYPE,
         c_SectionId       specification_section.section_id%TYPE,
         c_SubSectionId    specification_section.sub_section_id%TYPE,
         c_PropertyGroup   specification_prop.property_group%TYPE
      )
      IS
         SELECT DISTINCT ivpgpr.display_format, ivpgpr.display_format_rev,
                         limsc.is_col
                    FROM itlimsconfly limsc, ivpgpr
                   WHERE ivpgpr.display_format = limsc.layout_id
                     AND ivpgpr.display_format_rev = limsc.layout_rev
                     AND ivpgpr.type = 1
                     AND ivpgpr.property_group = c_PropertyGroup
                     AND ivpgpr.section_id = c_SectionId
                     AND ivpgpr.sub_section_id = c_SubSectionId
                     AND ivpgpr.part_no = c_Part_No
                     AND ivpgpr.revision = c_Revision
                     AND limsc.un_object = 'PPPR'
                     AND limsc.un_type = 'AU';
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Ppid||' | '||a_pp_version, NULL, NULL, PA_LIMS.c_Msg_Started);
      PA_LIMS.p_Trace(l_classname, l_method, a_pp_key1||' | '||a_pp_key2, a_pp_key3||' | '||a_pp_key4, a_pp_key5,
                      a_part_no||' | '||a_revision||' | '||a_nr_of_rows||' | '||a_propertygroup);
      FOR l_x IN 1..a_nr_of_rows LOOP
         PA_LIMS.p_Trace(l_classname, l_method, 'Index '||l_x||' | '||a_SectionId_tab(l_x)||' | '|| a_SubSectionId_tab(l_x), NULL,
                         NULL, NULL);
      END LOOP;

      FOR l_x IN 1..a_nr_of_rows LOOP

         -- Initializing variables
         l_nr_of_au      := 0;
         l_nr_of_pr      := 0;
         l_frequnit      := 0;
         l_pppr_version  := '~Current~';

         -- Assign all the properties that are defined as user attributes of the link between
         -- the parameter definition and the parameterprofile
         FOR l_GetPpPrAu_Rec IN l_GetPpPrAu_Cursor(a_Part_No, a_Revision, a_SectionId_tab(l_x), a_SubSectionId_tab(l_x), 
                                                   a_PropertyGroup) LOOP
            l_nr_of_au := l_nr_of_au + 1;

            -- Open the cursor
            l_cur_hdl := DBMS_SQL.OPEN_CURSOR;
            -- Create the dynamic Select statement
            l_sql(1) :=    'SELECT p.property, sp.attribute, '||l_GetPpPrAu_Rec.is_col
                        || ' FROM specification_prop sp, property p ';
            l_sql(2) :=    ' WHERE sp.property      = p.property AND part_no = '''||a_Part_No
                        || ''' AND revision         = '''||a_Revision
                        || ''' AND ';
            l_sql(3) :=    '       property_group   = '''||a_PropertyGroup
                        || ''' AND section_id       = '''||a_SectionId_tab(l_x)
                        || ''' AND sub_section_id   = '''||a_SubSectionId_tab(l_x)
                        || ''' ORDER BY p.property, sp.attribute';
            -- Set the SQL statement
            DBMS_SQL.PARSE(l_cur_hdl, l_sql, 1, 3, FALSE, DBMS_SQL.NATIVE);
            -- Define the columns in the select statement
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 1, l_Property);
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 2, l_Attribute);
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 3, l_Value, 120);
            -- Execute the select statement, the function returns
            -- the number of rows that are fetched
            l_return_value := DBMS_SQL.EXECUTE_AND_FETCH(l_cur_hdl);
            IF l_return_value = 0 THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                  'Unable to transfer the attributes of the link between parameter and parameterprofile for '||
                  'specification "'||a_part_no||'" | revision='||a_revision||' (There is no attribute data.)');
               -- Close the cursor
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Generate the attribute id
            l_StAuId := PA_LIMS.f_GetStPpPrAuId(l_GetPpPrAu_Rec.display_format, l_GetPpPrAu_Rec.display_format_rev,
                                                l_GetPpPrAu_Rec.is_col);
            -- Check if the value has to be saved as pppr property frequency or unit
            IF l_StAuId IN ('U4','UOM') OR 
               l_GetPpPrAu_Rec.is_col = 'UOM_ID' THEN
               l_frequnit := 1;
            END IF;

            -- Initialize counter variables
            l_pr_index := 0;

            LOOP
               -- Get the value of the columns
               DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 1, l_Property);
               DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 2, l_Attribute);
               DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 3, l_Value);

               -- Generate the parameter definition id, version and description, 
               -- based on the highest revision of the property
               l_StPp := a_PpId;
               l_sp_revision := PA_LIMS.f_GetHighestRevision('property', l_Property);
               IF l_attribute = 0 THEN
                  l_sp_desc := f_sph_descr(1,l_property,0);
               ELSE
                  l_sp_desc := f_sph_descr(1,l_property,0)||' '||f_ath_descr(1,l_attribute,0);
               END IF;
               l_PrId := PA_LIMS.f_GetPrId(l_Property, l_sp_revision, l_attribute, l_sp_desc, l_pr_desc);

               -- Changed by EH on 25/02/2001. If the attribute is of type 'UOM', the description of the 
               -- UOM should become the value of the attribute instead of the UOM_ID.
               IF l_GetPpPrAu_Rec.is_col = 'UOM_ID' THEN
                  BEGIN
                     SELECT SUBSTR(description,1,40)
                       INTO l_Value_descr
                       FROM uom
                      WHERE uom_id = l_Value;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        l_Value_descr := NULL;
                  END;
               -- If the attribute is of type 'CHARACTERISTIC', the description of the
               -- CHARACTERISTIC should become the value of the attribute instead of the CHARACTERISTIC_ID.
               ELSIF l_GetPpPrAu_Rec.is_col IN ('CHARACTERISTIC','CH_2','CH_3') THEN
                  BEGIN
                     SELECT SUBSTR(description,1,40)
                       INTO l_Value_descr
                       FROM characteristic
                      WHERE characteristic_id = l_Value;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        l_Value_descr := NULL;
                  END;
               -- If the attribute is of type 'test_method', the description of the
               -- test method should become the value of the attribute instead of the test_method_id.
               ELSIF l_GetPpPrAu_Rec.is_col = 'test_method' THEN
                  BEGIN
                     SELECT SUBSTR(description,1,40)
                       INTO l_Value_descr
                       FROM test_method
                      WHERE test_method = l_Value;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        l_Value_descr := NULL;
                  END;
               ELSE
                  l_value_descr := SUBSTR(l_Value,1,40);
               END IF;

               -- Save in arrays, the transfer happens later
               IF l_nr_of_au = 1 THEN
                  l_nr_of_pr := l_nr_of_pr + 1;
                  l_pr_tab(l_nr_of_pr) := l_PrId;
               END IF;
               l_pr_index := l_pr_index + 1;
               l_display_type_tab(l_pr_index)(l_nr_of_au) := SUBSTR(l_GetPpPrAu_Rec.is_col,1,20);
               l_au_tab(l_pr_index)(l_nr_of_au) := l_StAuId;
               l_value_tab(l_pr_index)(l_nr_of_au) := l_Value_descr;

               -- Get the values of the next property
               l_return_value := DBMS_SQL.FETCH_ROWS(l_cur_hdl);
               EXIT WHEN l_return_value = 0;
            END LOOP;
            -- Close the cursor
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END LOOP;

         -- Execute when something must be transferred
         IF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_nr_of_pr,0) = 0) AND (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_nr_of_au,0) = 0) THEN
            FOR i IN 1..l_nr_of_pr LOOP
               BEGIN
                  -- Transfer the attribute
                  IF NOT f_TransferSpcPpPrAu(l_StPp, a_pp_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4,
                                             a_pp_key5, l_pr_tab(i), l_pppr_version, 
                                             l_au_tab(i), l_value_tab(i), l_nr_of_au) THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
                  END IF;
                  -- Update freq + unit
                  IF l_frequnit = 1 THEN
                     PA_SPECXINTERFACE.P_SAVEPPPRPROPERTY@LNK_LIMS
                        (l_StPp, a_pp_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, 
                         a_pp_key5, l_pr_tab(i), l_pppr_version, 
                         l_display_type_tab(i), l_au_tab(i), l_value_tab(i), l_nr_of_au);
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     -- Log an error in ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to transfer the attributes of the link between parameter "'||l_pr_tab(i)||
                                   '" | version='||l_pppr_version||' and parameterprofile "'||l_StPp||'" | version='||
                                   a_pp_version||' | pp_keys="'||a_pp_key1||'"#"'||a_pp_key2||'"#"'||a_pp_key3||'"#"'||
                                   a_pp_key4||'"#"'||a_pp_key5||'" : '||SQLERRM);
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
               END;
            END LOOP;
         END IF;

      END LOOP;
      
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Ppid||' | '||a_pp_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
            'Unable to transfer the attributes of the link between parameter and parameterprofile for '||
            'specification "'||a_part_no||'" | revision='||a_revision||'.');
         -- Close the cursor if the cursor is still open
         IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcAllPpPrAu_AttSp;
END PA_LIMSSPC2;
/
