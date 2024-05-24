---------------------------------------------------------------------------
-- $Workfile: PA_LIMSSpc.sql $
--      Type: Package Body
--   $Author: Be328996 $
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
-- 1.  f_TransferSpcSt
-- 2.  f_TransferSpcPp
-- 3.  f_TransferSpcStPp
-- 4.  f_TransferSpcAllPpAndStPp
-- 5.  f_TransferSpcPpPr
-- 6.  f_TransferSpcAllPpPr
-- 7.  f_TransferSpcPpPrSp
-- 8.  f_TransferSpcAllPpPrSp
-- 9.  f_InheritLinkedSpc
-- 10. f_TransferSpc
-- 11. f_TransferASpc
-- 12. f_TransferAllSpc
-- 13. f_TransferUpdateAllSpc
-- 14. f_TransferUpdateASpc
-- 15. f_TransferAHistObs
-- 16. f_TransferAllHistObs
-- 17. f_GetIUIVersion
----------------------------------------------------------------------------
-- Versions:
-- speCX ver  Date         Author          Description
-- ---------  -----------  --------------  ---------------------------------
-- 2.2.1      03/05/2001   JB              - Specset extended to 'b' and 'c'
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.2.2      06/06/2001   JB              - Merge customer specs with standard spec
--                                           (including pppr-au's and specsets)
--                                         - When spec is customer spec and using
--                                           display formats with user-au's as st,
--                                           then these au's are stpp-au's for all
--                                           customer pp's
--                                         - TEMPORARILY :
--                                           Due to a bug (specset 'c' is a copy of
--                                           specset 'b') in standard db-api
--                                           'Unapist.CloneSampleType', a workaround
--                                           is made.
--                                           --> f_PatchTransferSpcAllPpPrSp
--                                           --> f_PatchTransferSpcStClone instead of
--                                               f_TransferSpcStClone
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.2.3      22/06/2001   JB              - In the function <f_TransferSpcAllStAu_AttachSp>
--                                           the cursor to get all the customer specs for the
--                                           generic spec is deleted. This was a bug!
--                                         - The function f_PatchTransferSpcStClone uses
--                                           now the (Unilab4 db) function
--                                           pa_SpecxInterface.f_Patch_ClonePP_specsetc to
--                                           get the workaround (see above).
--                                         - The cursor to check if the specification is
--                                           a customer specification fetch the attached
--                                           specification. But always take the
--                                           highest current revision if the attached
--                                           specification is a phantom
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.2.4      25/06/2001   JB              - In the function <f_InheritCustomerSpc>
--                                           the cursor to get all the customer specs for the
--                                           generic spec is deleted. This was a bug!
--                                         - In the function <f_InheritCustomerSpc>
--                                           the cursor to check if the generic propertygroup
--                                           is part of the customerpart is extended.
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.2.5      27/06/2001   JB              - In the function <f_TransferSpcAu> the length of
--                                           the au-value can be more than 40 characters. In
--                                           Specx, the length of a value can be 120 characters.
--                                           So, to avoid problems (error like ORA-06502: PL/SQL:
--                                           numeric or value error), the value will be trimmed
--                                           by using the function RTRIM.
--                                         - The test-logging in ITERROR in the function f_TransferSpcSt
--                                           is deleted: <Return value :x> with x normally equal to
--                                           0 was the returnvalue of the
--                                           dba-api UNAPIST.GETSTGROUPKEY.
--                                         - Remark : the logging in the Unilab table UTERROR
--                                           API_NAME = SaveStGroupKey
--                                           ERROR_MSG = ORA-00942: table or view does not exist
--                                           is not a error! In the function <f_TransferSpcStGk>
--                                           this error is expected and the saving of the gkvalue
--                                           is replaced by manually adding!
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.2.6      10/09/2001   CL              - Bug: The planned effective date can change after
--                                           the sample type is transferred to Unilab
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.3.0      15/07/2001   CL              Release 2.3.0
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.3.0.a    30/08/2001   CL              - The patch for the bug in the clone sample type is not
--                                           working for Unilab Version V4.2.1b (Error : 14). If this
--                                           patch fails the procedure doesn't stop.
-- 2.3.0.b    05/09/2001   PM              - Concatenation of partno + description pg changed.
-- 2.3.0 c    26/09/2001   CL              - The parameter template is not passed to the function
--                                           f_TransferCfgPr in the function f_InheritCustomerSpc
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--            19/03/2002   JB              - f_PatchTransferSpcAllPpPrSp removed : not in use anymore
--                                         - f_PatchTransferSpcStClone : argument renamed
--                                         - f_InheritCustomerSpc : argument removed
--                                         - f_TransferSpcAllPpPrAu_AttSp : argument removed
--                                           + stppau 'Revision' added when customer pp
--                                         - f_TransferSpcPp : before update of pp-pr's
--                                           remove the existing links between pp-pr's
--                                           Reason : changes in Specx : no changes in Unilab
--                                         - f_TransferASpc : check the current revision
--                                           of a sampletype in Unilab before transfer
--                                           Reason : current revision in Specx can be different
--                                           from the current revision in Unilab!
--                                         - f_TransferAllSpc : fetch all part's to be
--                                           transfered within a period of 14 days
--                                           Reason : when transfering went wrong,
--                                           the part didn't get a new transfer anymore
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--            09/12/2002   JB              New functions:
--                                         - f_TransferAHistObs : transfer 1 historic/obsolete spec
--                                         - f_TransferAllHistObs : job -> transfer all
--                                         - f_OrderStPp (INTERNAL) : order pp within st modified
--                                           1) always generic pp's (first part of pp description = st)
--                                           2) customer pp's alphabetically (first part of pp description
--                                              = customer part )
--                                           3) order of pp's within one group (generic or customer)
--                                              = order like in speCX
--
--                                         The new job "f_TransferAllHistObs" (freq = 5 min) works with
--                                         its own database link "LNK_LIMS_H" to avoid
--                                         locks when transfering current specs:
--                                         - f_SetUpLimsConnection_h
--                                         - f_StartRemoteTransaction_h
--                                         - f_EndRemoteTransaction_h
--                                         - f_GetStId_h
--                                         - f_RemoveDbLink_h
--
--                                         Modified functions:
--                                         - f_PatchTransferSpcStClone : OUT argument added
--                                         - f_TransferSpcPp : overrule temporarily pp.allow_modify
--                                         - f_TransferSpcStPp : link between (old) pp and st will be removed
--                                           to assign new version of pp
--                                         - f_TransferSpcAllPpAndStpp : propertygroups to transfer
--                                           will be ordered by speCX sequence +
--                                           before transfer : remove link between pp and st for current part
--                                         - f_TransferASpc (general transfer function):
--                                           * custom frequency won't be overruled in case of
--                                             in speCX the frequency-flag is 'A'
--                                             if 'N' => always Never
--                                           * The cloning of a st is reviewed and modified,
--                                             and after activating the new version will be the new version
--                                             (removing properties + -groups works now in Unilab!)
--                                           * The order of parameters (generic + custom pp's)
--                                             in Unilab = alphabetically now
--                                           * The order of parametergroups (see f_OrderStPp)
--                                             is modified
--                                         - f_TransferUpdateASpc : variabletype l_allow_modify is char(1)
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--            24/12/2002   JB/RK/AD        Solution for call #02-1963 added : f_TransferSpcPpPr
--                                         Problem:
--                                         The number of methods is set to 0 when the link
--                                         pp-pr-mt is interfaced from speCX to Unilab
--                                         Solution:
--                                         The method is filled in by the interface. The number
--                                         of methods is set to 0. This must be 1.
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--            14/02/2003   JB              Hotfix
--                                         --------Modified : f_TransferSpcStGk
--                                                            f_TransferSpcAllStGk
--                                         Problem1:
--                                         Old transfered keyword values (keyword in Interspec
--                                         = sampletype groupkey in Unilab) are not removed in Unilab
--                                         Problem2:
--                                         Removed keyword values (keyword in Interspec
--                                         = sampletype groupkey in Unilab) are not removed in Unilab
--                                         Solution:
--                                         Remove these old keywordvalues before transfer
--
--                                         --------Modified : f_TransferASpc
--                                         Problem:
--                                         Some of the spectypes may not be transfered to Unilab
--                                         Solution:
--                                         Configure in table <interspc_cfg> the forbidden spectypes
--                                         and check this table before transfer.
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--            25/02/2003   JB              Hotfix
--                                         --------Modified : f_TransferASpc
--                                         Problem (see call 03-0737)
--                                         When transfering a customer part, after activating the
--                                         cloned sampletype, the modifications are removed from the
--                                         existing sampletype. Because there is only an update
--                                         of customer profiles of the existing sampletype,
--                                         instead of both (cloned + existing) versions.
--                                         Check if there exists at this moment a cloned st
--                                         by checking sampletype attribute 'Cloned ST'
--                                         If true, transfer new or updated customer parameterprofiles
--                                         to existing (old version) and cloned (new version) sampletype
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.5.0      25/02/2003   FB              Implementation of itLimsJob_h
--                                         Upgrade to Unilab 5.0
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 5.0        20/08/2003   RF              Release 5.0
--                                         Since Unilab 5.0 SP2 can handle versions, 
--                                         effective_dates, and multiple plants, a new design has been
--                                         made ("RFD0309021-DS DB API Interspec-Unilab interface.doc"
--                                         in the Unilab 5.0 SP2 URS folder). Please check this 
--                                         design for more detailed information of the modifications.
---------------------------------------------------------------------------- 
-- 6.4        03/09/2013   SA              The same Part/Revision combination was returned multiple times 
--     from the cursor l_SimilarStTiTransfer_Cursor (c_plant),
--     when the same part Part/Revison was transferred for multiple plants with the same connection_string, 
--     lang_id, lang_id_4id, but with different priorities among the plants.
--
----------------------------------------------------------------------------



CREATE OR REPLACE PACKAGE BODY 
----------------------------------------------------------------------------
-- $Revision: K06.04.00.00_03.01 
--  $Modtime: 26/08/2014 15:00 $
----------------------------------------------------------------------------
PA_LIMSSPC IS

   --INTERNAL TYPE
   TYPE VC20_TABLE_TYPE   IS TABLE OF VARCHAR2(20)        INDEX BY BINARY_INTEGER;
   
   -- Cursor to get the value of the Unilab system setting 'STGK ID Generic St'
   CURSOR g_system_cursor(c_setting_name VARCHAR2)
   IS
      SELECT setting_value
        FROM UVSYSTEM@LNK_LIMS
       WHERE setting_name = c_setting_name;
     
   -- INTERNAL FUNCTION
   FUNCTION GetTemplete4PropertyGroup(
      c_Part_No         specification_header.part_no%TYPE,
      c_Revision        specification_header.revision%TYPE,
      c_PropertyGroup   specification_section.ref_id%TYPE,
      c_PgRevision      specification_section.ref_ver%TYPE 
   ) RETURN VARCHAR2 IS

   CURSOR l_PgLayout_Cursor(
      c_Part_No         specification_header.part_no%TYPE,
      c_Revision        specification_header.revision%TYPE,
      c_PropertyGroup   specification_section.ref_id%TYPE,
      c_PgRevision      specification_section.ref_ver%TYPE 
   )
   IS
      SELECT MAX(limsc.layout_id) layout_id
                 FROM itlimsconfly limsc,
                      specification_section sps
                WHERE sps.ref_id = c_PropertyGroup
                  AND sps.ref_ver = c_PgRevision
                  AND sps.part_no = c_Part_No
                  AND sps.revision = c_Revision
                  AND sps.type = 1
                  AND sps.display_format = limsc.layout_id
                  AND sps.display_format_rev = limsc.layout_rev
                  AND limsc.un_object IN ('PR', 'PPPR');
   l_layout_id          itlimsconfly.layout_id%TYPE;
   l_Template           VARCHAR2(20);  
   BEGIN
      l_Template := NULL;
      OPEN l_PgLayout_Cursor(c_Part_No, c_Revision, c_PropertyGroup, c_PgRevision);
      FETCH l_PgLayout_Cursor
      INTO l_layout_id;
      CLOSE l_PgLayout_Cursor;         
      l_Template := PA_LIMS.f_GetTemplate('LY', l_layout_id);
      RETURN (l_Template);
   END GetTemplete4PropertyGroup;

   -- INTERNAL FUNCTION
   FUNCTION f_OrderStPp(
      a_St                 IN  VARCHAR2,
      a_version            IN  VARCHAR2
   )
      RETURN BOOLEAN 
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- 05/11/2002
      -- Order the parameterprofiles within the sampletype:
      --    1) generic parameterprofiles come first
      --    2) linked parameterprofiles are sorted by pp_key
      --    3) linked parameterprofiles within one pp_key group are sorted alphabetically by part_no
      --       (first part of parameterprofile description = part_no of the linked specification)
      --    4) order of linked parameterprofiles within one part_no group (generic or linked) is 
      --       the order like in Interspec
      -- ** Parameters **
      -- a_st          : sampletype that has been transferred
      -- a_version     : version of the sampletype
      -- ** Return **
      -- TRUE  : The ordering of the parameterprofiles has succeeded.
      -- FALSE : The ordering of the parameterprofiles has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname          CONSTANT VARCHAR2(12)                := 'LimsSpc';
      l_method             CONSTANT VARCHAR2(32)                := 'f_OrderStPp';
      l_object             VARCHAR2(255);

      -- General variables
      l_changes            BOOLEAN                              DEFAULT FALSE;
      l_sql_string         VARCHAR2(4000);
      l_order_by_clause    VARCHAR2(255);
      l_nr_of_occurences   NUMBER;
      l_linked_key_index   NUMBER;
      l_linked_key         CHAR(1);
      l_stpp_cursor        UNAPIGEN.CURSOR_REF_TYPE@LNK_LIMS;
      l_stpp_rec           UVSTPP_PP_SPECX@LNK_LIMS%ROWTYPE;
      l_order_by           VARCHAR2(20);
      
      -- Specific local variables for the 'SaveStParameterprofile' API
      l_ret_code           INTEGER;
      l_nr_of_rows         NUMBER;
      l_next_rows          NUMBER                               DEFAULT -1;
      l_modify_reason      VARCHAR2(255);
      l_pp_tab             UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_version_tab     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_freq_tp_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_val_tab       UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_unit_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_invert_freq_tab    UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_last_sched_tab     UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_last_cnt_tab       UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_last_val_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_St||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'sample type "'||a_St||'" | version='||a_version;

      -- Get the sorting order
      FOR l_system_rec IN g_system_cursor('ORDER_STPP') LOOP
         IF l_system_rec.setting_value = 'ALPHABETICALLY' THEN
            l_order_by := 'description';
         ELSIF l_system_rec.setting_value = 'LIKE IN INTERSPEC' THEN
            l_order_by := ' ';
         END IF;
      END LOOP;
      
      -- Fill in the parameters to save the standard attributes of the link 
      -- between the parameterprofiles and the sampletype.
      l_nr_of_rows      := 0;
      l_modify_reason   := 'Imported the sorted links between the parameterprofiles and sample type "'||a_st||
                           '" from Interspec.';

      IF NVL(l_order_by, ' ') <> ' ' THEN
         -- ORDER ALPHABETICALLY according to the description
         -- Cursor to get all links between generic parameterprofiles and the sampletype
         l_sql_string:= 'SELECT pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, seq, '||
                        'freq_tp, freq_val, freq_unit, invert_freq, last_sched, last_cnt, last_val, inherit_au '||
                          'FROM UVSTPP_PP_SPECX@LNK_LIMS '||
                         'WHERE st      = '''||a_st||
                        ''' AND version = '''||a_version||''' ORDER BY '||l_order_by;
         -- Order the generic parameterprofiles
         OPEN l_stpp_cursor FOR l_sql_string;
         LOOP
            FETCH l_stpp_cursor INTO l_stpp_rec.pp, l_stpp_rec.pp_version, l_stpp_rec.pp_key1, l_stpp_rec.pp_key2, 
                                     l_stpp_rec.pp_key3, l_stpp_rec.pp_key4, l_stpp_rec.pp_key5, l_stpp_rec.seq,
                                     l_stpp_rec.freq_tp, l_stpp_rec.freq_val, l_stpp_rec.freq_unit, 
                                     l_stpp_rec.invert_freq, l_stpp_rec.last_sched, 
                                     l_stpp_rec.last_cnt, l_stpp_rec.last_val, l_stpp_rec.inherit_au;
            EXIT WHEN l_stpp_cursor%NOTFOUND;

            IF l_stpp_rec.seq <> (l_nr_of_rows+1) THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                               'The order of the parameterprofiles has to change.');
               l_changes := TRUE;
            END IF;
            l_nr_of_rows                    := l_nr_of_rows + 1;
            l_pp_tab(l_nr_of_rows)          := l_stpp_rec.pp;
            l_pp_version_tab(l_nr_of_rows)  := l_stpp_rec.pp_version;
            l_pp_key1_tab(l_nr_of_rows)     := l_stpp_rec.pp_key1;
            l_pp_key2_tab(l_nr_of_rows)     := l_stpp_rec.pp_key2;
            l_pp_key3_tab(l_nr_of_rows)     := l_stpp_rec.pp_key3;
            l_pp_key4_tab(l_nr_of_rows)     := l_stpp_rec.pp_key4;
            l_pp_key5_tab(l_nr_of_rows)     := l_stpp_rec.pp_key5;
            l_freq_tp_tab(l_nr_of_rows)     := SUBSTR(l_stpp_rec.freq_tp,1,1);
            l_freq_val_tab(l_nr_of_rows)    := l_stpp_rec.freq_val;
            l_freq_unit_tab(l_nr_of_rows)   := l_stpp_rec.freq_unit;
            l_invert_freq_tab(l_nr_of_rows) := SUBSTR(l_stpp_rec.invert_freq,1,1);
               -- INTERFACE BUG: 11/12/2002
               -- When fetching last_sched values, different from NULL, you will get following error:
               --    Unable to save the parameter profiles "" assigned to the sample type <a_st>.
               --    (General failure! Error Code: 1 Error Msg: ORA-01861: literal
               --     does not match format string)
               -- To avoid this date problem has been decided to set all last_sched values to NULL.
               -- This is not a problem because all frequencies are set to 'A' or to 'N' and
               -- when transferring a new version of a spec, the last_sched is always set to NULL.
            l_last_sched_tab(l_nr_of_rows)  := NULL;
            l_last_cnt_tab(l_nr_of_rows)    := l_stpp_rec.last_cnt;
            l_last_val_tab(l_nr_of_rows)    := l_stpp_rec.last_val;
            l_inherit_au_tab(l_nr_of_rows)  := SUBSTR(l_stpp_rec.inherit_au,1,1);
         END LOOP;
         CLOSE l_stpp_cursor;
      ELSE
         --ORDER LIKE IN INTERSPC
         --First all generic parameter profiles
         --All non generic profiles must be added after
         --
         -- Cursor to get all links between generic parameterprofiles and the sampletype
         l_sql_string:= 'SELECT pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, seq, '||
                        'freq_tp, freq_val, freq_unit, invert_freq, last_sched, last_cnt, last_val, inherit_au '||
                          'FROM UVSTPP_PP_SPECX@LNK_LIMS '||
                         'WHERE st      = '''||a_st||
                        ''' AND version = '''||a_version||''' ';
         l_nr_of_occurences := 1;
         LOOP
            l_linked_key_index := INSTR(PA_LIMS.g_linked_keys,'#',1,l_nr_of_occurences);
            EXIT WHEN l_linked_key_index = 0;
            -- To check if a parameterprofile is generic, all linked pp_keys have to be empty
            l_sql_string := l_sql_string||'AND key'||SUBSTR(PA_LIMS.g_linked_keys,l_linked_key_index+1,1)||'_set = ''0'' ';
            l_nr_of_occurences := l_nr_of_occurences + 1;
         END LOOP;
         l_sql_string := l_sql_string||'ORDER BY seq';
         -- Order the generic parameterprofiles
         OPEN l_stpp_cursor FOR l_sql_string;
         LOOP
            FETCH l_stpp_cursor INTO l_stpp_rec.pp, l_stpp_rec.pp_version, l_stpp_rec.pp_key1, l_stpp_rec.pp_key2, 
                                     l_stpp_rec.pp_key3, l_stpp_rec.pp_key4, l_stpp_rec.pp_key5, l_stpp_rec.seq,
                                     l_stpp_rec.freq_tp, l_stpp_rec.freq_val, l_stpp_rec.freq_unit, 
                                     l_stpp_rec.invert_freq, l_stpp_rec.last_sched, 
                                     l_stpp_rec.last_cnt, l_stpp_rec.last_val, l_stpp_rec.inherit_au;
            EXIT WHEN l_stpp_cursor%NOTFOUND;

            IF l_stpp_rec.seq <> (l_nr_of_rows+1) THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                               'The order of the generic parameterprofiles has to change.');
               l_changes := TRUE;
            END IF;
            l_nr_of_rows                    := l_nr_of_rows + 1;
            l_pp_tab(l_nr_of_rows)          := l_stpp_rec.pp;
            l_pp_version_tab(l_nr_of_rows)  := l_stpp_rec.pp_version;
            l_pp_key1_tab(l_nr_of_rows)     := l_stpp_rec.pp_key1;
            l_pp_key2_tab(l_nr_of_rows)     := l_stpp_rec.pp_key2;
            l_pp_key3_tab(l_nr_of_rows)     := l_stpp_rec.pp_key3;
            l_pp_key4_tab(l_nr_of_rows)     := l_stpp_rec.pp_key4;
            l_pp_key5_tab(l_nr_of_rows)     := l_stpp_rec.pp_key5;
            l_freq_tp_tab(l_nr_of_rows)     := SUBSTR(l_stpp_rec.freq_tp,1,1);
            l_freq_val_tab(l_nr_of_rows)    := l_stpp_rec.freq_val;
            l_freq_unit_tab(l_nr_of_rows)   := l_stpp_rec.freq_unit;
            l_invert_freq_tab(l_nr_of_rows) := SUBSTR(l_stpp_rec.invert_freq,1,1);
               -- INTERFACE BUG: 11/12/2002
               -- When fetching last_sched values, different from NULL, you will get following error:
               --    Unable to save the parameter profiles "" assigned to the sample type <a_st>.
               --    (General failure! Error Code: 1 Error Msg: ORA-01861: literal
               --     does not match format string)
               -- To avoid this date problem has been decided to set all last_sched values to NULL.
               -- This is not a problem because all frequencies are set to 'A' or to 'N' and
               -- when transferring a new version of a spec, the last_sched is always set to NULL.
            l_last_sched_tab(l_nr_of_rows)  := NULL;
            l_last_cnt_tab(l_nr_of_rows)    := l_stpp_rec.last_cnt;
            l_last_val_tab(l_nr_of_rows)    := l_stpp_rec.last_val;
            l_inherit_au_tab(l_nr_of_rows)  := SUBSTR(l_stpp_rec.inherit_au,1,1);
         END LOOP;
         CLOSE l_stpp_cursor;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                         'Number of generic parameterprofiles = '||l_nr_of_rows);

         -- Cursor to get all links between linked parameterprofiles and the sampletype
         IF PA_LIMS.g_linked_keys <> ' ' THEN
            l_sql_string:= 'SELECT pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, seq, '||
                           'freq_tp, freq_val, freq_unit, invert_freq, last_sched, last_cnt, last_val, inherit_au '||
                             'FROM UVSTPP_PP_SPECX@LNK_LIMS '||
                            'WHERE st      = '''||a_st||
                           ''' AND version = '''||a_version||''' AND (';
            l_nr_of_occurences := 1;
            l_order_by_clause := 'ORDER BY ';
            LOOP
               l_linked_key_index := INSTR(PA_LIMS.g_linked_keys,'#',1,l_nr_of_occurences);
               EXIT WHEN l_linked_key_index = 0;
               l_linked_key := SUBSTR(PA_LIMS.g_linked_keys,l_linked_key_index+1,1);
               -- To check if a parameterprofile is linked, at least one of the linked pp_keys has to be filled
               l_sql_string := l_sql_string||'key'||l_linked_key||'_set = ''1'' OR ';
               -- The linked parameterprofiles are sorted by pp_key
               l_order_by_clause := l_order_by_clause||' key'||l_linked_key||'_set DESC, ';
               l_nr_of_occurences := l_nr_of_occurences + 1;
            END LOOP;
            -- Remove last ' OR '
            l_sql_string := SUBSTR(l_sql_string, 1, LENGTH(l_sql_string)-4);
            l_sql_string := l_sql_string||') '||l_order_by_clause||
                               ' SUBSTR(description,1,INSTR(description,'' '')-1), seq';
            -- Order the linked parameterprofiles
            OPEN l_stpp_cursor FOR l_sql_string;
            LOOP
               FETCH l_stpp_cursor INTO l_stpp_rec.pp, l_stpp_rec.pp_version, l_stpp_rec.pp_key1, l_stpp_rec.pp_key2, 
                                        l_stpp_rec.pp_key3, l_stpp_rec.pp_key4, l_stpp_rec.pp_key5, l_stpp_rec.seq,
                                        l_stpp_rec.freq_tp, l_stpp_rec.freq_val, l_stpp_rec.freq_unit, 
                                        l_stpp_rec.invert_freq, l_stpp_rec.last_sched, 
                                        l_stpp_rec.last_cnt, l_stpp_rec.last_val, l_stpp_rec.inherit_au;
               EXIT WHEN l_stpp_cursor%NOTFOUND;

               IF l_stpp_rec.seq <> (l_nr_of_rows+1) THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                                  'The order of the linked parameterprofiles has to change.');
                  l_changes := TRUE;
               END IF;
               l_nr_of_rows                    := l_nr_of_rows + 1;
               l_pp_tab(l_nr_of_rows)          := l_stpp_rec.pp;
               l_pp_version_tab(l_nr_of_rows)  := l_stpp_rec.pp_version;
               l_pp_key1_tab(l_nr_of_rows)     := l_stpp_rec.pp_key1;
               l_pp_key2_tab(l_nr_of_rows)     := l_stpp_rec.pp_key2;
               l_pp_key3_tab(l_nr_of_rows)     := l_stpp_rec.pp_key3;
               l_pp_key4_tab(l_nr_of_rows)     := l_stpp_rec.pp_key4;
               l_pp_key5_tab(l_nr_of_rows)     := l_stpp_rec.pp_key5;
               l_freq_tp_tab(l_nr_of_rows)     := SUBSTR(l_stpp_rec.freq_tp,1,1);
               l_freq_val_tab(l_nr_of_rows)    := l_stpp_rec.freq_val;
               l_freq_unit_tab(l_nr_of_rows)   := l_stpp_rec.freq_unit;
               l_invert_freq_tab(l_nr_of_rows) := SUBSTR(l_stpp_rec.invert_freq,1,1);
                  -- INTERFACE BUG: 11/12/2002
                  -- When fetching last_sched values, different from NULL, you will get following error:
                  --    Unable to save the parameter profiles "" assigned to the sample type <a_st>.
                  --    (General failure! Error Code: 1 Error Msg: ORA-01861: literal
                  --     does not match format string)
                  -- To avoid this date problem has been decided to set all last_sched values to NULL.
                  -- This is not a problem because all frequencies are set to 'A' or to 'N' and
                  -- when transferring a new version of a spec, the last_sched is always set to NULL.
               l_last_sched_tab(l_nr_of_rows)  := NULL;
               l_last_cnt_tab(l_nr_of_rows)    := l_stpp_rec.last_cnt;
               l_last_val_tab(l_nr_of_rows)    := l_stpp_rec.last_val;
               l_inherit_au_tab(l_nr_of_rows)  := SUBSTR(l_stpp_rec.inherit_au,1,1);
            END LOOP;
            CLOSE l_stpp_cursor;
         END IF;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                      'Number of all parameterprofiles = '||l_nr_of_rows);

      IF l_nr_of_rows > 0 THEN
         IF l_changes THEN
            -- Save the standard attributes of the link 
            -- between the parameterprofiles and the sampletype.
            BEGIN
               l_ret_code := UNAPIST.SAVESTPARAMETERPROFILE@LNK_LIMS(a_st, a_version, l_pp_tab, l_pp_version_tab,
                                l_pp_key1_tab, l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab,
                                l_freq_tp_tab, l_freq_val_tab, l_freq_unit_tab, l_invert_freq_tab, l_last_sched_tab,
                                l_last_cnt_tab, l_last_val_tab, l_inherit_au_tab, l_nr_of_rows, l_next_rows,
                                l_modify_reason);
               -- If the error is a general failure then the SQLERRM must be logged, otherwise
               -- the error code is the Unilab error
               IF l_ret_code <> PA_LIMS.DBERR_SUCCESS THEN
                  IF l_ret_code = PA_LIMS.DBERR_GENFAIL THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                  'Unable to save the sorted links between the parameterprofiles and '||l_object||
                                  ' (General failure! Error Code: '||l_ret_code||' Error Msg:'||
                                  UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                  ELSE
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                  'Unable to save the sorted links between the parameterprofiles and '||l_object||
                                  ' (Error code : '||l_ret_code||').');
                  END IF;

                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  -- Log an error in ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the sorted links between the parameterprofiles and '||l_object||' : '||SQLERRM);
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
            END;
         ELSE
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Nothing happened.');
         END IF;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Close cursor if still open
         IF l_stpp_cursor%ISOPEN THEN
            CLOSE l_stpp_cursor;
         END IF;
         -- Log an error to ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to order the parameterprofiles within '||l_object||' : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN(FALSE);
   END f_OrderStPp;

   -- INTERNAL FUNCTION
   FUNCTION f_OrderPpPr(
      a_St                 IN  VARCHAR2,
      a_version            IN  VARCHAR2,
      a_pp_desc            IN  VARCHAR2,
      a_sh_revision        IN  NUMBER
   )
      RETURN BOOLEAN 
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Order the parameter definitions within the parameterprofiles of the 
      -- sampletype alphabetically on description.
      -- ** Parameters **
      -- a_st          : sampletype that has been transferred
      -- a_version     : version of the sampletype
      -- a_pp_desc     : if sent specification is generic then
      --                    empty
      --                 elsif sent specification is linked then
      --                    part_no of the specification
      --                    (= first part of parameterprofile description)
      --                 end if;
      -- a_sh_revision : revision of the property group
      -- ** Return **
      -- TRUE  : The ordering of the parameter definitions has succeeded.
      -- FALSE : The ordering of the parameter definitions has failed.
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname                    CONSTANT VARCHAR2(12)                := 'LimsSpc';
      l_method                       CONSTANT VARCHAR2(32)                := 'f_OrderPpPr';
      l_object                       VARCHAR2(255);

      -- General variables
      l_changes                      BOOLEAN                              DEFAULT FALSE;
      l_sql_string                   VARCHAR2(4000);
      l_sql_string2                  VARCHAR2(4000);
      l_nr_of_occurences             NUMBER;
      l_linked_key_index             NUMBER;
      l_stgenpp_cursor               UNAPIGEN.CURSOR_REF_TYPE@LNK_LIMS;
      l_stgenpp_rec                  UVSTPP_PP_SPECX@LNK_LIMS%ROWTYPE;
      l_getpppr_cursor               UNAPIGEN.CURSOR_REF_TYPE@LNK_LIMS;
      l_getpppr_rec                  UVPPPR_PR_SPECX@LNK_LIMS%ROWTYPE;
      l_order_by                     VARCHAR2(20);
      l_skip_pp_sort                 BOOLEAN;
    
      -- Specific local variables for the 'SavePpParameter' API
      l_ret_code                     INTEGER;
      l_pp                           VARCHAR2(20);
      l_version                      VARCHAR2(20);
      l_stpp_version                 VARCHAR2(20);
      l_pp_key1                      VARCHAR2(20);
      l_pp_key2                      VARCHAR2(20);
      l_pp_key3                      VARCHAR2(20);
      l_pp_key4                      VARCHAR2(20);
      l_pp_key5                      VARCHAR2(20);
      l_pr_tab                       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_version_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_nr_measur_tab                UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_unit_tab                     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_format_tab                   UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_allow_add_tab                UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_is_pp_tab                    UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_tp_tab                  UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_val_tab                 UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_unit_tab                UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_invert_freq_tab              UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_st_based_freq_tab            UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_last_sched_tab               UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_last_cnt_tab                 UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_last_val_tab                 UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab               UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_delay_tab                    UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_delay_unit_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_tab                       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_version_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_nr_measur_tab             UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_nr_of_rows                   NUMBER;
      l_modify_reason                VARCHAR2(255);

      -- Specific local variables for the 'GetPpParameterSpecs' API
      l_pp_tab                       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_tab                  UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab                  UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab                  UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab                  UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab                  UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab                  UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      -- For set a
      l_low_limit_a_get_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_limit_a_get_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_spec_a_get_tab           UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_spec_a_get_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_dev_a_get_tab            UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_low_dev_a_get_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_target_a_get_tab             UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_dev_a_get_tab           UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_high_dev_a_get_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      -- For set b
      l_low_limit_b_get_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_limit_b_get_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_spec_b_get_tab           UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_spec_b_get_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_dev_b_get_tab            UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_low_dev_b_get_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_target_b_get_tab             UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_dev_b_get_tab           UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_high_dev_b_get_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      -- For set c
      l_low_limit_c_get_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_limit_c_get_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_spec_c_get_tab           UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_spec_c_get_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_dev_c_get_tab            UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_low_dev_c_get_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_target_c_get_tab             UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_dev_c_get_tab           UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_high_dev_c_get_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_spec_set                     CHAR(1);
      l_where_clause                 VARCHAR2(511);

      -- Specific local variables for the 'SavePpParameterSpecs' API
      -- For set a
      l_low_limit_a_save_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_limit_a_save_tab        UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_spec_a_save_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_spec_a_save_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_dev_a_save_tab           UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_low_dev_a_save_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_target_a_save_tab            UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_dev_a_save_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_high_dev_a_save_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      -- For set b
      l_low_limit_b_save_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_limit_b_save_tab        UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_spec_b_save_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_spec_b_save_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_dev_b_save_tab           UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_low_dev_b_save_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_target_b_save_tab            UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_dev_b_save_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_high_dev_b_save_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      -- For set c
      l_low_limit_c_save_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_limit_c_save_tab        UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_spec_c_save_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_spec_c_save_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_dev_c_save_tab           UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_low_dev_c_save_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_target_c_save_tab            UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_dev_c_save_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_high_dev_c_save_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;

      -- Cursor to get all links between linked parameterprofiles (of this part_no) and the sampletype
      CURSOR lvq_getstlinkedpp(l_st VARCHAR2, l_version VARCHAR2, l_pp_desc VARCHAR2)
      IS
         SELECT pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
           FROM UVSTPP_PP_SPECX@LNK_LIMS
          WHERE st         = l_st
            AND version    = l_version
            AND description LIKE l_pp_desc||'%'
          ORDER BY seq;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_St||' | '||a_version, a_pp_desc, a_sh_revision, PA_LIMS.c_Msg_Started);

      -- Get the sorting order
      FOR l_system_rec IN g_system_cursor('ORDER_PPPR') LOOP
         IF l_system_rec.setting_value = 'ALPHABETICALLY' THEN
            l_order_by := 'description';
         ELSIF l_system_rec.setting_value = 'LIKE IN INTERSPEC' THEN
            l_order_by := 'seq';
         END IF;
      END LOOP;
      
      -- check if the sent specification was generic or linked
      IF a_pp_desc IS NULL THEN
         -- Cursor to get all links between generic parameterprofiles and the sampletype
         l_sql_string:= 'SELECT pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5 '||
                          'FROM UVSTPP_PP_SPECX@LNK_LIMS '||
                         'WHERE st      = '''||a_st||
                        ''' AND version = '''||a_version||''' ';
         l_nr_of_occurences := 1;
         LOOP
            l_linked_key_index := INSTR(PA_LIMS.g_linked_keys,'#',1,l_nr_of_occurences);
            EXIT WHEN l_linked_key_index = 0;
            -- To check if a parameterprofile is generic, all linked pp_keys have to be empty
            l_sql_string := l_sql_string||'AND key'||SUBSTR(PA_LIMS.g_linked_keys,l_linked_key_index+1,1)||'_set = ''0'' ';
            l_nr_of_occurences := l_nr_of_occurences + 1;
         END LOOP;
         l_sql_string := l_sql_string||'ORDER BY seq';
         -- Order the parameter definitions of the generic parameterprofiles
         OPEN l_stgenpp_cursor FOR l_sql_string;
         LOOP
            FETCH l_stgenpp_cursor INTO l_stgenpp_rec.pp, l_stgenpp_rec.pp_version, l_stgenpp_rec.pp_key1, 
                                        l_stgenpp_rec.pp_key2, l_stgenpp_rec.pp_key3,
                                        l_stgenpp_rec.pp_key4, l_stgenpp_rec.pp_key5;
            EXIT WHEN l_stgenpp_cursor%NOTFOUND;

            -- Initializing variables
            l_version := UNVERSION.CONVERTINTERSPEC2UNILABPP@LNK_LIMS(l_stgenpp_rec.pp, 
                             l_stgenpp_rec.pp_key1, l_stgenpp_rec.pp_key2, l_stgenpp_rec.pp_key3, 
                             l_stgenpp_rec.pp_key4, l_stgenpp_rec.pp_key5, a_sh_revision);
            l_object := 'parameterprofile "'||l_stgenpp_rec.pp||'" | version='||l_version||' | pp_keys="'||
                        l_stgenpp_rec.pp_key1||'"#"'||l_stgenpp_rec.pp_key2||'"#"'||l_stgenpp_rec.pp_key3||'"#"'||
                        l_stgenpp_rec.pp_key4||'"#"'||l_stgenpp_rec.pp_key5||'"';

            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                            '--- generic parameterprofile "'||l_stgenpp_rec.pp||'" version='||l_version||' ---');
               
            -- Get the specification data of the link between the parameter definitions and the parameterprofile (set a,b,c)
            FOR i IN 1..3 LOOP
               -- Fill in the parameters to get the specification data of the link 
               -- between the parameter definitions and the parameterprofile.
               l_nr_of_rows      := 1000 ; --instead of 0 to support more than 100 parameters by parameter profile
                                           --1000 is the default supported by Unilab Get functions
               l_where_clause := 'WHERE pp='''||REPLACE(l_stgenpp_rec.pp,'''','''''')||
                                 ''' AND version='''||l_version||
                                 ''' AND pp_key1='''||REPLACE(l_stgenpp_rec.pp_key1,'''','''''')||
                                 ''' AND pp_key2='''||REPLACE(l_stgenpp_rec.pp_key2,'''','''''')||
                                 ''' AND pp_key3='''||REPLACE(l_stgenpp_rec.pp_key3,'''','''''')||
                                 ''' AND pp_key4='''||REPLACE(l_stgenpp_rec.pp_key4,'''','''''')||
                                 ''' AND pp_key5='''||REPLACE(l_stgenpp_rec.pp_key5,'''','''''')||''' ORDER BY seq';
               -- Get the specification data
               l_skip_pp_sort := FALSE;
               IF i = 1 THEN
                  l_spec_set := 'a';
                  l_ret_code := UNAPIPP.GETPPPARAMETERSPECS@LNK_LIMS(l_pp_tab, l_version_tab, l_pp_key1_tab,
                                   l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_pr_tab, 
                                   l_pr_version_tab, l_low_limit_a_get_tab, l_high_limit_a_get_tab, 
                                   l_low_spec_a_get_tab, l_high_spec_a_get_tab, l_low_dev_a_get_tab, 
                                   l_rel_low_dev_a_get_tab, l_target_a_get_tab, l_high_dev_a_get_tab,
                                   l_rel_high_dev_a_get_tab, l_spec_set, l_nr_of_rows, l_where_clause);
               ELSIF i = 2 THEN
                  l_spec_set := 'b';
                  l_ret_code := UNAPIPP.GETPPPARAMETERSPECS@LNK_LIMS(l_pp_tab, l_version_tab, l_pp_key1_tab,
                                   l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_pr_tab,
                                   l_pr_version_tab, l_low_limit_b_get_tab, l_high_limit_b_get_tab,
                                   l_low_spec_b_get_tab, l_high_spec_b_get_tab, l_low_dev_b_get_tab,
                                   l_rel_low_dev_b_get_tab, l_target_b_get_tab, l_high_dev_b_get_tab,
                                   l_rel_high_dev_b_get_tab, l_spec_set, l_nr_of_rows, l_where_clause);
               ELSE 
                  l_spec_set := 'c';
                  l_ret_code := UNAPIPP.GETPPPARAMETERSPECS@LNK_LIMS(l_pp_tab, l_version_tab, l_pp_key1_tab,
                                   l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_pr_tab,
                                   l_pr_version_tab, l_low_limit_c_get_tab, l_high_limit_c_get_tab,
                                   l_low_spec_c_get_tab, l_high_spec_c_get_tab, l_low_dev_c_get_tab,
                                   l_rel_low_dev_c_get_tab, l_target_c_get_tab, l_high_dev_c_get_tab,
                                   l_rel_high_dev_c_get_tab, l_spec_set, l_nr_of_rows, l_where_clause);
               END IF;
               -- Check if specification data of a link between parameter definitions and the parameterprofile exists in Unilab
               IF l_ret_code <> PA_LIMS.DBERR_SUCCESS THEN
                  -- Log an error in ITERROR
                  --PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                  --              'Unable to retrieve the specification data of the link between the parameter '||
                  --              'definitions and '||l_object||' (Error code : '||l_ret_code||').');
                  -- Tracing
                  --PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  --RETURN (FALSE);
                  --
                  --commented out since UNDIFF can do its job before sorting (transaction in Interface is not OK)
                  --and introduce pp that will not be found with the major version
                  --These parameter profiles will not be sorted
                  --also there can be a parameter profile at the unilab side
                  --that has no parameter at all and GetPpParameters will return DBERR_NORECORD
                  --
                  l_skip_pp_sort := TRUE;
               END IF;
            END LOOP;
                           
            IF NOT l_skip_pp_sort THEN
               -- Fill in the parameters to save the standard attributes of the link 
               -- between the parameter definitions and the parameterprofile.
               l_nr_of_rows      := 0 ; 
               l_modify_reason   := 'Imported the sorted links between the parameter definitions and the '||
                                    'parameterprofile "'||l_stgenpp_rec.pp||'" from Interspec.';

               -- Order the parameter definitions of this generic parameterprofile
               l_sql_string2 := 'SELECT pr, pr_version, seq, nr_measur, delay, delay_unit, '||
                                '       allow_add, is_pp, freq_tp, freq_val, freq_unit, invert_freq, '||
                                '       st_based_freq, last_sched, last_cnt, last_val, inherit_au, '||
                                '       mt, mt_version, mt_nr_measur, unit, format '||
                                '  FROM UVPPPR_PR_SPECX@LNK_LIMS '||
                                ' WHERE pp        = '''||REPLACE(l_stgenpp_rec.pp,'''','''''')||
                                '''   AND version = '''||REPLACE(l_version,'''','''''')||
                                '''   AND pp_key1 = '''||REPLACE(l_stgenpp_rec.pp_key1,'''','''''')||
                                '''   AND pp_key2 = '''||REPLACE(l_stgenpp_rec.pp_key2,'''','''''')||
                                '''   AND pp_key3 = '''||REPLACE(l_stgenpp_rec.pp_key3,'''','''''')||
                                '''   AND pp_key4 = '''||REPLACE(l_stgenpp_rec.pp_key4,'''','''''')||
                                '''   AND pp_key5 = '''||REPLACE(l_stgenpp_rec.pp_key5,'''','''''')||
                                ''' ORDER BY '||l_order_by;
               OPEN l_getpppr_cursor FOR l_sql_string2;
               LOOP
                  FETCH l_getpppr_cursor INTO l_getpppr_rec.pr, l_getpppr_rec.pr_version, 
                     l_getpppr_rec.seq, l_getpppr_rec.nr_measur, l_getpppr_rec.delay,
                     l_getpppr_rec.delay_unit, l_getpppr_rec.allow_add, l_getpppr_rec.is_pp,
                     l_getpppr_rec.freq_tp, l_getpppr_rec.freq_val, l_getpppr_rec.freq_unit,
                     l_getpppr_rec.invert_freq, l_getpppr_rec.st_based_freq, l_getpppr_rec.last_sched,
                     l_getpppr_rec.last_cnt, l_getpppr_rec.last_val, l_getpppr_rec.inherit_au,
                     l_getpppr_rec.mt, l_getpppr_rec.mt_version, l_getpppr_rec.mt_nr_measur,
                     l_getpppr_rec.unit, l_getpppr_rec.format;
                  EXIT WHEN l_getpppr_cursor%NOTFOUND;
                  IF l_GetPpPr_rec.seq <> (l_nr_of_rows+1) THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                                     'The order of the parameter definitions has to change.');
                     l_changes := TRUE;
                  END IF;
                  l_nr_of_rows                       := l_nr_of_rows + 1;
                  l_pr_tab(l_nr_of_rows)             := l_GetPpPr_rec.pr;
                  l_pr_version_tab(l_nr_of_rows)     := l_GetPpPr_rec.pr_version;
                  l_nr_measur_tab(l_nr_of_rows)      := l_GetPpPr_rec.nr_measur;
                  l_unit_tab(l_nr_of_rows)           := l_GetPpPr_rec.unit;
                  l_format_tab(l_nr_of_rows)         := l_GetPpPr_rec.format;
                  l_allow_add_tab(l_nr_of_rows)      := SUBSTR(l_GetPpPr_rec.allow_add,1,1);
                  l_is_pp_tab(l_nr_of_rows)          := SUBSTR(l_GetPpPr_rec.is_pp,1,1);
                  l_freq_tp_tab(l_nr_of_rows)        := SUBSTR(l_GetPpPr_rec.freq_tp,1,1);
                  l_freq_val_tab(l_nr_of_rows)       := l_GetPpPr_rec.freq_val;
                  l_freq_unit_tab(l_nr_of_rows)      := l_GetPpPr_rec.freq_unit;
                  l_invert_freq_tab(l_nr_of_rows)    := SUBSTR(l_GetPpPr_rec.invert_freq,1,1);
                  l_st_based_freq_tab(l_nr_of_rows)  := SUBSTR(l_GetPpPr_rec.st_based_freq,1,1);
                     -- INTERFACE BUG: 11/12/2002
                     -- When fetching last_sched values, different from NULL, you will get following error:
                     --    Unable to save the parameter profiles "" assigned to the sample type <a_st>.
                     --    (General failure! Error Code: 1 Error Msg: ORA-01861: literal
                     --     does not match format string)
                     -- To avoid this date problem has been decided to set all last_sched values to NULL.
                     -- This is not a problem because all frequencies are set to 'A' or to 'N' and
                     -- when transferring a new version of a spec, the last_sched is always set to NULL.
                  l_last_sched_tab(l_nr_of_rows)     := NULL;
                  l_last_cnt_tab(l_nr_of_rows)       := l_GetPpPr_rec.last_cnt;
                  l_last_val_tab(l_nr_of_rows)       := l_GetPpPr_rec.last_val;
                  l_inherit_au_tab(l_nr_of_rows)     := SUBSTR(l_GetPpPr_rec.inherit_au,1,1);
                  l_delay_tab(l_nr_of_rows)          := l_GetPpPr_rec.delay;
                  l_delay_unit_tab(l_nr_of_rows)     := l_GetPpPr_rec.delay_unit;
                  l_mt_tab(l_nr_of_rows)             := l_GetPpPr_rec.mt;
                  l_mt_version_tab(l_nr_of_rows)     := l_GetPpPr_rec.mt_version;
                  l_mt_nr_measur_tab(l_nr_of_rows)   := l_GetPpPr_rec.mt_nr_measur;

                  -- Modify the sequence of the specification data, corresponding to the sequence of the parameter definition
                  -- For set a
                  l_low_limit_a_save_tab(l_nr_of_rows)          := l_low_limit_a_get_tab(l_GetPpPr_rec.seq);
                  l_high_limit_a_save_tab(l_nr_of_rows)         := l_high_limit_a_get_tab(l_GetPpPr_rec.seq);
                  l_low_spec_a_save_tab(l_nr_of_rows)           := l_low_spec_a_get_tab(l_GetPpPr_rec.seq);
                  l_high_spec_a_save_tab(l_nr_of_rows)          := l_high_spec_a_get_tab(l_GetPpPr_rec.seq);
                  l_low_dev_a_save_tab(l_nr_of_rows)            := l_low_dev_a_get_tab(l_GetPpPr_rec.seq);
                  l_rel_low_dev_a_save_tab(l_nr_of_rows)        := l_rel_low_dev_a_get_tab(l_GetPpPr_rec.seq);
                  l_target_a_save_tab(l_nr_of_rows)             := l_target_a_get_tab(l_GetPpPr_rec.seq);
                  l_high_dev_a_save_tab(l_nr_of_rows)           := l_high_dev_a_get_tab(l_GetPpPr_rec.seq);
                  l_rel_high_dev_a_save_tab(l_nr_of_rows)       := l_rel_high_dev_a_get_tab(l_GetPpPr_rec.seq);
                  -- For set b
                  l_low_limit_b_save_tab(l_nr_of_rows)          := l_low_limit_b_get_tab(l_GetPpPr_rec.seq);
                  l_high_limit_b_save_tab(l_nr_of_rows)         := l_high_limit_b_get_tab(l_GetPpPr_rec.seq);
                  l_low_spec_b_save_tab(l_nr_of_rows)           := l_low_spec_b_get_tab(l_GetPpPr_rec.seq);
                  l_high_spec_b_save_tab(l_nr_of_rows)          := l_high_spec_b_get_tab(l_GetPpPr_rec.seq);
                  l_low_dev_b_save_tab(l_nr_of_rows)            := l_low_dev_b_get_tab(l_GetPpPr_rec.seq);
                  l_rel_low_dev_b_save_tab(l_nr_of_rows)        := l_rel_low_dev_b_get_tab(l_GetPpPr_rec.seq);
                  l_target_b_save_tab(l_nr_of_rows)             := l_target_b_get_tab(l_GetPpPr_rec.seq);
                  l_high_dev_b_save_tab(l_nr_of_rows)           := l_high_dev_b_get_tab(l_GetPpPr_rec.seq);
                  l_rel_high_dev_b_save_tab(l_nr_of_rows)       := l_rel_high_dev_b_get_tab(l_GetPpPr_rec.seq);
                  -- For set c
                  l_low_limit_c_save_tab(l_nr_of_rows)          := l_low_limit_c_get_tab(l_GetPpPr_rec.seq);
                  l_high_limit_c_save_tab(l_nr_of_rows)         := l_high_limit_c_get_tab(l_GetPpPr_rec.seq);
                  l_low_spec_c_save_tab(l_nr_of_rows)           := l_low_spec_c_get_tab(l_GetPpPr_rec.seq);
                  l_high_spec_c_save_tab(l_nr_of_rows)          := l_high_spec_c_get_tab(l_GetPpPr_rec.seq);
                  l_low_dev_c_save_tab(l_nr_of_rows)            := l_low_dev_c_get_tab(l_GetPpPr_rec.seq);
                  l_rel_low_dev_c_save_tab(l_nr_of_rows)        := l_rel_low_dev_c_get_tab(l_GetPpPr_rec.seq);
                  l_target_c_save_tab(l_nr_of_rows)             := l_target_c_get_tab(l_GetPpPr_rec.seq);
                  l_high_dev_c_save_tab(l_nr_of_rows)           := l_high_dev_c_get_tab(l_GetPpPr_rec.seq);
                  l_rel_high_dev_c_save_tab(l_nr_of_rows)       := l_rel_high_dev_c_get_tab(l_GetPpPr_rec.seq);
               END LOOP;
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                               'Number of parameter definitions in generic parameterprofile "'||
                               l_stgenpp_rec.pp||'" = '||l_nr_of_rows);

               IF l_nr_of_rows > 0 THEN
                  IF l_changes THEN
                     -- Save the standard attributes of the link 
                     -- between the parameter definitions and the generic parameterprofile.
                     BEGIN
                        l_ret_code := UNAPIPP.SAVEPPPARAMETER@LNK_LIMS(l_stgenpp_rec.pp, l_version,
                                         l_stgenpp_rec.pp_key1, l_stgenpp_rec.pp_key2, 
                                         l_stgenpp_rec.pp_key3, l_stgenpp_rec.pp_key4,
                                         l_stgenpp_rec.pp_key5, l_pr_tab, l_pr_version_tab, l_nr_measur_tab,
                                         l_unit_tab, l_format_tab, l_allow_add_tab, l_is_pp_tab, l_freq_tp_tab,
                                         l_freq_val_tab, l_freq_unit_tab, l_invert_freq_tab, l_st_based_freq_tab,
                                         l_last_sched_tab, l_last_cnt_tab, l_last_val_tab, l_inherit_au_tab, 
                                         l_delay_tab, l_delay_unit_tab, l_mt_tab, l_mt_version_tab, l_mt_nr_measur_tab,
                                         l_nr_of_rows, l_modify_reason);
                        -- If the error is a general failure then the SQLERRM must be logged, otherwise
                        -- the error code is the Unilab error
                        IF l_ret_code <> PA_LIMS.DBERR_SUCCESS THEN
                           IF l_ret_code = PA_LIMS.DBERR_GENFAIL THEN
                              -- Log an error to ITERROR
                              PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                            'Unable to save the sorted links between the parameter definitions and '||
                                            l_object||' (General failure! Error Code: '||l_ret_code||' Error Msg:'||
                                            UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                           ELSE
                              -- Log an error to ITERROR
                              PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                            'Unable to save the sorted links between the parameter definitions and '||
                                            l_object||' (Error code : '||l_ret_code||').');
                           END IF;

                           -- Tracing
                           PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                           RETURN (FALSE);
                        END IF;

                        -- Save the standard attributes of the specification data of the link  
                        -- between the parameter definition and the parameterprofile
                        -- Fill in the parameters to save the standard attributes of the specification data  
                        -- of the link between the parameter definitions and the parameterprofile.
                        l_pp                      := l_stgenpp_rec.pp;
                        l_pp_key1                 := l_stgenpp_rec.pp_key1;
                        l_pp_key2                 := l_stgenpp_rec.pp_key2;
                        l_pp_key3                 := l_stgenpp_rec.pp_key3;
                        l_pp_key4                 := l_stgenpp_rec.pp_key4;
                        l_pp_key5                 := l_stgenpp_rec.pp_key5;
                        FOR i in 1..3 LOOP
                           -- Save the standard attributes of the specification data
                           IF i = 1 THEN
                              l_spec_set := 'a';
                              l_ret_code := UNAPIPP.SAVEPPPARAMETERSPECS@LNK_LIMS(l_pp, l_version, l_pp_key1, l_pp_key2,
                                               l_pp_key3, l_pp_key4, l_pp_key5, l_pr_tab, l_pr_version_tab, l_spec_set,
                                               l_low_limit_a_save_tab, l_high_limit_a_save_tab, l_low_spec_a_save_tab,
                                               l_high_spec_a_save_tab, l_low_dev_a_save_tab, l_rel_low_dev_a_save_tab,
                                               l_target_a_save_tab, l_high_dev_a_save_tab, l_rel_high_dev_a_save_tab,
                                               l_nr_of_rows, l_modify_reason);
                           ELSIF i = 2 THEN
                              l_spec_set := 'b';
                              l_ret_code := UNAPIPP.SAVEPPPARAMETERSPECS@LNK_LIMS(l_pp, l_version, l_pp_key1, l_pp_key2,
                                               l_pp_key3, l_pp_key4, l_pp_key5, l_pr_tab, l_pr_version_tab, l_spec_set,
                                               l_low_limit_b_save_tab, l_high_limit_b_save_tab, l_low_spec_b_save_tab,
                                               l_high_spec_b_save_tab, l_low_dev_b_save_tab, l_rel_low_dev_b_save_tab,
                                               l_target_b_save_tab, l_high_dev_b_save_tab, l_rel_high_dev_b_save_tab,
                                               l_nr_of_rows, l_modify_reason);
                           ELSE
                              l_spec_set := 'c';
                              l_ret_code := UNAPIPP.SAVEPPPARAMETERSPECS@LNK_LIMS(l_pp, l_version, l_pp_key1, l_pp_key2,
                                               l_pp_key3, l_pp_key4, l_pp_key5, l_pr_tab, l_pr_version_tab, l_spec_set,
                                               l_low_limit_c_save_tab, l_high_limit_c_save_tab, l_low_spec_c_save_tab,
                                               l_high_spec_c_save_tab, l_low_dev_c_save_tab, l_rel_low_dev_c_save_tab,
                                               l_target_c_save_tab, l_high_dev_c_save_tab, l_rel_high_dev_c_save_tab,
                                               l_nr_of_rows, l_modify_reason);
                           END IF;
                           -- If the error is a general failure then the SQLERRM must be logged, otherwise
                           -- the error code is the Unilab error
                           IF l_ret_code <> PA_LIMS.DBERR_SUCCESS THEN
                              IF l_ret_code = PA_LIMS.DBERR_GENFAIL THEN
                                 -- Log an error to ITERROR
                                 PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                               'Unable to save the specification data of the link between the '||
                                               'parameter definitions and '||l_object||' (General failure! Error Code: '||
                                               l_ret_code||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                              ELSE
                                 -- Log an error to ITERROR
                                 PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                               'Unable to save the specification data of the link between the '||
                                               'parameter definitions and '||l_object||' (Error code : '||l_ret_code||').');
                              END IF;
                              -- Tracing
                              PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                              RETURN (FALSE);
                           END IF;
                        END LOOP;
                     EXCEPTION
                        WHEN OTHERS THEN
                           -- Log an error in ITERROR
                           PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                         'Unable to save the sorted links between the parameter definitions and '||
                                         l_object||' : '||SQLERRM);
                           -- Tracing
                           PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                           RETURN (FALSE);
                     END;
                  ELSE
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Nothing happened.');
                  END IF;
               END IF;
            ELSE
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'pp not sorted - not in Unilab with the specified version');
            END IF;
         END LOOP;
         CLOSE l_stgenpp_cursor;
      ELSE
         -- Order the parameter definitions of the linked parameterprofiles (of this part_no)
         FOR lvq_getstlinkedpp_rec IN lvq_getstlinkedpp(a_st, a_version, a_pp_desc) LOOP
            -- Initializing variables
            l_version := UNVERSION.CONVERTINTERSPEC2UNILABPP@LNK_LIMS(lvq_getstlinkedpp_rec.pp, 
                            lvq_getstlinkedpp_rec.pp_key1, lvq_getstlinkedpp_rec.pp_key2, 
                            lvq_getstlinkedpp_rec.pp_key3, lvq_getstlinkedpp_rec.pp_key4, 
                            lvq_getstlinkedpp_rec.pp_key5, a_sh_revision);
            l_object := 'parameterprofile "'||lvq_getstlinkedpp_rec.pp||'" | version='||l_version||' | pp_keys="'||
                        lvq_getstlinkedpp_rec.pp_key1||'"#"'||lvq_getstlinkedpp_rec.pp_key2||'"#"'||
                        lvq_getstlinkedpp_rec.pp_key3||'"#"'||lvq_getstlinkedpp_rec.pp_key4||'"#"'||
                        lvq_getstlinkedpp_rec.pp_key5||'"';
            -- Generate the version of the parameterprofile for the link
            l_stpp_version := UNVERSION.GETMAJORVERSIONONLY@LNK_LIMS(l_version);

            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(lvq_getstlinkedpp_rec.pp_version, l_stpp_version) = 1 THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                  '--- linked parameterprofile "'||lvq_getstlinkedpp_rec.pp||'" version='||l_version||' ---');

               -- Get the specification data of the link between the parameter definitions and the parameterprofile (set a,b,c)
               l_skip_pp_sort := FALSE;
               FOR i IN 1..3 LOOP
                  -- Fill in the parameters to get the specification data of the link 
                  -- between the parameter definitions and the parameterprofile.
                  l_nr_of_rows := 0;
                  l_where_clause := 'WHERE pp='''||REPLACE(lvq_getstlinkedpp_rec.pp,'''','''''')||
                                    ''' AND version='''||l_version||
                                    ''' AND pp_key1='''||REPLACE(lvq_getstlinkedpp_rec.pp_key1,'''','''''')||
                                    ''' AND pp_key2='''||REPLACE(lvq_getstlinkedpp_rec.pp_key2,'''','''''')||
                                    ''' AND pp_key3='''||REPLACE(lvq_getstlinkedpp_rec.pp_key3,'''','''''')||
                                    ''' AND pp_key4='''||REPLACE(lvq_getstlinkedpp_rec.pp_key4,'''','''''')||
                                    ''' AND pp_key5='''||REPLACE(lvq_getstlinkedpp_rec.pp_key5,'''','''''')||''' ORDER BY seq';
                  -- Get the specification data
                  IF i = 1 THEN
                     l_spec_set := 'a';
                     l_ret_code := UNAPIPP.GETPPPARAMETERSPECS@LNK_LIMS(l_pp_tab, l_version_tab, l_pp_key1_tab,
                                      l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_pr_tab,
                                      l_pr_version_tab, l_low_limit_a_get_tab, l_high_limit_a_get_tab,
                                      l_low_spec_a_get_tab, l_high_spec_a_get_tab, l_low_dev_a_get_tab,
                                      l_rel_low_dev_a_get_tab, l_target_a_get_tab, l_high_dev_a_get_tab,
                                      l_rel_high_dev_a_get_tab, l_spec_set, l_nr_of_rows, l_where_clause);
                  ELSIF i = 2 THEN
                     l_spec_set := 'b';
                     l_ret_code := UNAPIPP.GETPPPARAMETERSPECS@LNK_LIMS(l_pp_tab, l_version_tab, l_pp_key1_tab,
                                      l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_pr_tab,
                                      l_pr_version_tab, l_low_limit_b_get_tab, l_high_limit_b_get_tab,
                                      l_low_spec_b_get_tab, l_high_spec_b_get_tab, l_low_dev_b_get_tab,
                                      l_rel_low_dev_b_get_tab, l_target_b_get_tab, l_high_dev_b_get_tab,
                                      l_rel_high_dev_b_get_tab, l_spec_set, l_nr_of_rows, l_where_clause);
                  ELSE 
                     l_spec_set := 'c';
                     l_ret_code := UNAPIPP.GETPPPARAMETERSPECS@LNK_LIMS(l_pp_tab, l_version_tab, l_pp_key1_tab,
                                      l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_pr_tab,
                                      l_pr_version_tab, l_low_limit_c_get_tab, l_high_limit_c_get_tab,
                                      l_low_spec_c_get_tab, l_high_spec_c_get_tab, l_low_dev_c_get_tab,
                                      l_rel_low_dev_c_get_tab, l_target_c_get_tab, l_high_dev_c_get_tab,
                                      l_rel_high_dev_c_get_tab, l_spec_set, l_nr_of_rows, l_where_clause);
                  END IF;
                  -- Check if specification data of a link between parameter definitions and the parameterprofile exists in Unilab
                  IF l_ret_code <> PA_LIMS.DBERR_SUCCESS THEN
                     ---- Log an error in ITERROR
                     --PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                     --              'Unable to retrieve the specification data of the link between the '||
                     --              'parameter definitions and '||l_object||' (Error code : '||l_ret_code||').');
                     -- Tracing
                     --PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     --RETURN (FALSE);
                     --
                     --commented out since UNDIFF can do its job before sorting (transaction in Interface is not OK)
                     --and introduce pp that will not be found with the major version
                     --These parameter profiles will not be sorted
                     --also there can be a parameter profile at the unilab side
                     --that has no parameter at all and GetPpParameters will return DBERR_NORECORD
                     --
                     l_skip_pp_sort := FALSE;
                  END IF;
               END LOOP;

               IF NOT l_skip_pp_sort THEN
                  -- Fill in the parameters to save the standard attributes of the link 
                  -- between the parameter definitions and the parameterprofile.
                  l_nr_of_rows      := 0;
                  l_modify_reason   := 'Imported the sorted links between the parameter definitions and the parameterprofile "'
                                       || lvq_getstlinkedpp_rec.pp
                                       ||'" from Interspec.';

                  -- Order the parameter definitions of this linked parameterprofile
                  l_sql_string2 := 'SELECT pr, pr_version, seq, nr_measur, delay, delay_unit, '||
                                   '       allow_add, is_pp, freq_tp, freq_val, freq_unit, invert_freq, '||
                                   '       st_based_freq, last_sched, last_cnt, last_val, inherit_au, '||
                                   '       mt, mt_version, mt_nr_measur, unit, format '||
                                   '  FROM UVPPPR_PR_SPECX@LNK_LIMS '||
                                   ' WHERE pp        = '''||REPLACE(lvq_getstlinkedpp_rec.pp,'''','''''')||
                                   '''   AND version = '''||REPLACE(l_version,'''','''''')||
                                   '''   AND pp_key1 = '''||REPLACE(lvq_getstlinkedpp_rec.pp_key1,'''','''''')||
                                   '''   AND pp_key2 = '''||REPLACE(lvq_getstlinkedpp_rec.pp_key2,'''','''''')||
                                   '''   AND pp_key3 = '''||REPLACE(lvq_getstlinkedpp_rec.pp_key3,'''','''''')||
                                   '''   AND pp_key4 = '''||REPLACE(lvq_getstlinkedpp_rec.pp_key4,'''','''''')||
                                   '''   AND pp_key5 = '''||REPLACE(lvq_getstlinkedpp_rec.pp_key5,'''','''''')||
                                   ''' ORDER BY '||l_order_by;
                  OPEN l_getpppr_cursor FOR l_sql_string2;
                  LOOP
                     FETCH l_getpppr_cursor INTO l_getpppr_rec.pr, l_getpppr_rec.pr_version, 
                        l_getpppr_rec.seq, l_getpppr_rec.nr_measur, l_getpppr_rec.delay,
                        l_getpppr_rec.delay_unit, l_getpppr_rec.allow_add, l_getpppr_rec.is_pp,
                        l_getpppr_rec.freq_tp, l_getpppr_rec.freq_val, l_getpppr_rec.freq_unit,
                        l_getpppr_rec.invert_freq, l_getpppr_rec.st_based_freq, l_getpppr_rec.last_sched,
                        l_getpppr_rec.last_cnt, l_getpppr_rec.last_val, l_getpppr_rec.inherit_au,
                        l_getpppr_rec.mt, l_getpppr_rec.mt_version, l_getpppr_rec.mt_nr_measur,
                        l_getpppr_rec.unit, l_getpppr_rec.format;
                     EXIT WHEN l_getpppr_cursor%NOTFOUND;
                     IF l_GetPpPr_rec.seq <> (l_nr_of_rows+1) THEN
                        -- Tracing
                        PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 
                                        'The order of the parameter definitions has to change.');
                        l_changes := TRUE;
                     END IF;
                     l_nr_of_rows                       := l_nr_of_rows + 1;
                     l_pr_tab(l_nr_of_rows)             := l_GetPpPr_rec.pr;
                     l_pr_version_tab(l_nr_of_rows)     := l_GetPpPr_rec.pr_version;
                     l_nr_measur_tab(l_nr_of_rows)      := l_GetPpPr_rec.nr_measur;
                     l_unit_tab(l_nr_of_rows)           := l_GetPpPr_rec.unit;
                     l_format_tab(l_nr_of_rows)         := l_GetPpPr_rec.format;
                     l_allow_add_tab(l_nr_of_rows)      := SUBSTR(l_GetPpPr_rec.allow_add,1,1);
                     l_is_pp_tab(l_nr_of_rows)          := SUBSTR(l_GetPpPr_rec.is_pp,1,1);
                     l_freq_tp_tab(l_nr_of_rows)        := SUBSTR(l_GetPpPr_rec.freq_tp,1,1);
                     l_freq_val_tab(l_nr_of_rows)       := l_GetPpPr_rec.freq_val;
                     l_freq_unit_tab(l_nr_of_rows)      := l_GetPpPr_rec.freq_unit;
                     l_invert_freq_tab(l_nr_of_rows)    := SUBSTR(l_GetPpPr_rec.invert_freq,1,1);
                     l_st_based_freq_tab(l_nr_of_rows)  := SUBSTR(l_GetPpPr_rec.st_based_freq,1,1);
                        -- INTERFACE BUG: 11/12/2002
                        -- When fetching last_sched values, different from NULL, you will get following error:
                        --    Unable to save the parameter profiles "" assigned to the sample type <a_st>.
                        --    (General failure! Error Code: 1 Error Msg: ORA-01861: literal
                        --     does not match format string)
                        -- To avoid this date problem has been decided to set all last_sched values to NULL.
                        -- This is not a problem because all frequencies are set to 'A' or to 'N' and
                        -- when transferring a new version of a spec, the last_sched is always set to NULL.
                     l_last_sched_tab(l_nr_of_rows)     := NULL;
                     l_last_cnt_tab(l_nr_of_rows)       := l_GetPpPr_rec.last_cnt;
                     l_last_val_tab(l_nr_of_rows)       := l_GetPpPr_rec.last_val;
                     l_inherit_au_tab(l_nr_of_rows)     := SUBSTR(l_GetPpPr_rec.inherit_au,1,1);
                     l_delay_tab(l_nr_of_rows)          := l_GetPpPr_rec.delay;
                     l_delay_unit_tab(l_nr_of_rows)     := l_GetPpPr_rec.delay_unit;
                     l_mt_tab(l_nr_of_rows)             := l_GetPpPr_rec.mt;
                     l_mt_version_tab(l_nr_of_rows)     := l_GetPpPr_rec.mt_version;
                     l_mt_nr_measur_tab(l_nr_of_rows)   := l_GetPpPr_rec.mt_nr_measur;

                     -- Modify the sequence of the specification data, corresponding to the sequence of the parameter definition
                     -- For set a
                     l_low_limit_a_save_tab(l_nr_of_rows)          := l_low_limit_a_get_tab(l_GetPpPr_rec.seq);
                     l_high_limit_a_save_tab(l_nr_of_rows)         := l_high_limit_a_get_tab(l_GetPpPr_rec.seq);
                     l_low_spec_a_save_tab(l_nr_of_rows)           := l_low_spec_a_get_tab(l_GetPpPr_rec.seq);
                     l_high_spec_a_save_tab(l_nr_of_rows)          := l_high_spec_a_get_tab(l_GetPpPr_rec.seq);
                     l_low_dev_a_save_tab(l_nr_of_rows)            := l_low_dev_a_get_tab(l_GetPpPr_rec.seq);
                     l_rel_low_dev_a_save_tab(l_nr_of_rows)        := l_rel_low_dev_a_get_tab(l_GetPpPr_rec.seq);
                     l_target_a_save_tab(l_nr_of_rows)             := l_target_a_get_tab(l_GetPpPr_rec.seq);
                     l_high_dev_a_save_tab(l_nr_of_rows)           := l_high_dev_a_get_tab(l_GetPpPr_rec.seq);
                     l_rel_high_dev_a_save_tab(l_nr_of_rows)       := l_rel_high_dev_a_get_tab(l_GetPpPr_rec.seq);
                     -- For set b
                     l_low_limit_b_save_tab(l_nr_of_rows)          := l_low_limit_b_get_tab(l_GetPpPr_rec.seq);
                     l_high_limit_b_save_tab(l_nr_of_rows)         := l_high_limit_b_get_tab(l_GetPpPr_rec.seq);
                     l_low_spec_b_save_tab(l_nr_of_rows)           := l_low_spec_b_get_tab(l_GetPpPr_rec.seq);
                     l_high_spec_b_save_tab(l_nr_of_rows)          := l_high_spec_b_get_tab(l_GetPpPr_rec.seq);
                     l_low_dev_b_save_tab(l_nr_of_rows)            := l_low_dev_b_get_tab(l_GetPpPr_rec.seq);
                     l_rel_low_dev_b_save_tab(l_nr_of_rows)        := l_rel_low_dev_b_get_tab(l_GetPpPr_rec.seq);
                     l_target_b_save_tab(l_nr_of_rows)             := l_target_b_get_tab(l_GetPpPr_rec.seq);
                     l_high_dev_b_save_tab(l_nr_of_rows)           := l_high_dev_b_get_tab(l_GetPpPr_rec.seq);
                     l_rel_high_dev_b_save_tab(l_nr_of_rows)       := l_rel_high_dev_b_get_tab(l_GetPpPr_rec.seq);
                     -- For set c
                     l_low_limit_c_save_tab(l_nr_of_rows)          := l_low_limit_c_get_tab(l_GetPpPr_rec.seq);
                     l_high_limit_c_save_tab(l_nr_of_rows)         := l_high_limit_c_get_tab(l_GetPpPr_rec.seq);
                     l_low_spec_c_save_tab(l_nr_of_rows)           := l_low_spec_c_get_tab(l_GetPpPr_rec.seq);
                     l_high_spec_c_save_tab(l_nr_of_rows)          := l_high_spec_c_get_tab(l_GetPpPr_rec.seq);
                     l_low_dev_c_save_tab(l_nr_of_rows)            := l_low_dev_c_get_tab(l_GetPpPr_rec.seq);
                     l_rel_low_dev_c_save_tab(l_nr_of_rows)        := l_rel_low_dev_c_get_tab(l_GetPpPr_rec.seq);
                     l_target_c_save_tab(l_nr_of_rows)             := l_target_c_get_tab(l_GetPpPr_rec.seq);
                     l_high_dev_c_save_tab(l_nr_of_rows)           := l_high_dev_c_get_tab(l_GetPpPr_rec.seq);
                     l_rel_high_dev_c_save_tab(l_nr_of_rows)       := l_rel_high_dev_c_get_tab(l_GetPpPr_rec.seq);
                  END LOOP;
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                                  'Number of parameter definitions in linked parameterprofile "'||lvq_getstlinkedpp_rec.pp||
                                  '" = '||l_nr_of_rows);

                  IF l_nr_of_rows > 0 THEN
                     IF l_changes THEN
                        -- Save the standard attributes of the link 
                        -- between the parameter definitions and the linked parameterprofile.
                        BEGIN
                           l_ret_code := UNAPIPP.SAVEPPPARAMETER@LNK_LIMS(lvq_getstlinkedpp_rec.pp, l_version, 
                                            lvq_getstlinkedpp_rec.pp_key1, lvq_getstlinkedpp_rec.pp_key2, 
                                            lvq_getstlinkedpp_rec.pp_key3, lvq_getstlinkedpp_rec.pp_key4,
                                            lvq_getstlinkedpp_rec.pp_key5, l_pr_tab, l_pr_version_tab, l_nr_measur_tab,
                                            l_unit_tab, l_format_tab, l_allow_add_tab, l_is_pp_tab, l_freq_tp_tab,
                                            l_freq_val_tab, l_freq_unit_tab, l_invert_freq_tab, l_st_based_freq_tab,
                                            l_last_sched_tab, l_last_cnt_tab, l_last_val_tab, l_inherit_au_tab, l_delay_tab,
                                            l_delay_unit_tab, l_mt_tab, l_mt_version_tab, l_mt_nr_measur_tab, l_nr_of_rows,
                                            l_modify_reason);
                           -- If the error is a general failure then the SQLERRM must be logged, otherwise
                           -- the error code is the Unilab error
                           IF l_ret_code <> PA_LIMS.DBERR_SUCCESS THEN
                              IF l_ret_code = PA_LIMS.DBERR_GENFAIL THEN
                                 -- Log an error to ITERROR
                                 PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                               'Unable to save the sorted links between the parameter definitions and '||
                                               l_object||' (General failure! Error Code: '||l_ret_code||' Error Msg:'||
                                               UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                              ELSE
                                 -- Log an error to ITERROR
                                 PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                               'Unable to save the sorted links between the parameter definitions and '||
                                               l_object||' (Error code : '||l_ret_code||').');
                              END IF;

                              -- Tracing
                              PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                              RETURN (FALSE);
                           END IF;

                           -- Save the standard attributes of the specification data of the link  
                           -- between the parameter definition and the parameterprofile
                           -- Fill in the parameters to save the standard attributes of the specification data  
                           -- of the link between the parameter definitions and the parameterprofile.
                           l_pp                      := lvq_getstlinkedpp_rec.pp;
                           l_pp_key1                 := lvq_getstlinkedpp_rec.pp_key1;
                           l_pp_key2                 := lvq_getstlinkedpp_rec.pp_key2;
                           l_pp_key3                 := lvq_getstlinkedpp_rec.pp_key3;
                           l_pp_key4                 := lvq_getstlinkedpp_rec.pp_key4;
                           l_pp_key5                 := lvq_getstlinkedpp_rec.pp_key5;
                           FOR i in 1..3 LOOP
                              -- Save the standard attributes of the specification data
                              IF i = 1 THEN
                                 l_spec_set := 'a';
                                 l_ret_code := UNAPIPP.SAVEPPPARAMETERSPECS@LNK_LIMS(l_pp, l_version, l_pp_key1, l_pp_key2,
                                                  l_pp_key3, l_pp_key4, l_pp_key5, l_pr_tab, l_pr_version_tab, l_spec_set,
                                                  l_low_limit_a_save_tab, l_high_limit_a_save_tab, l_low_spec_a_save_tab,
                                                  l_high_spec_a_save_tab, l_low_dev_a_save_tab, l_rel_low_dev_a_save_tab,
                                                  l_target_a_save_tab, l_high_dev_a_save_tab, l_rel_high_dev_a_save_tab,
                                                  l_nr_of_rows, l_modify_reason);
                              ELSIF i = 2 THEN
                                 l_spec_set := 'b';
                                 l_ret_code := UNAPIPP.SAVEPPPARAMETERSPECS@LNK_LIMS(l_pp, l_version, l_pp_key1, l_pp_key2,
                                                  l_pp_key3, l_pp_key4, l_pp_key5, l_pr_tab, l_pr_version_tab, l_spec_set,
                                                  l_low_limit_b_save_tab, l_high_limit_b_save_tab, l_low_spec_b_save_tab,
                                                  l_high_spec_b_save_tab, l_low_dev_b_save_tab, l_rel_low_dev_b_save_tab,
                                                  l_target_b_save_tab, l_high_dev_b_save_tab, l_rel_high_dev_b_save_tab,
                                                  l_nr_of_rows, l_modify_reason);
                              ELSE
                                 l_spec_set := 'c';
                                 l_ret_code := UNAPIPP.SAVEPPPARAMETERSPECS@LNK_LIMS(l_pp, l_version, l_pp_key1, l_pp_key2,
                                                  l_pp_key3, l_pp_key4, l_pp_key5, l_pr_tab, l_pr_version_tab, l_spec_set,
                                                  l_low_limit_c_save_tab, l_high_limit_c_save_tab, l_low_spec_c_save_tab,
                                                  l_high_spec_c_save_tab, l_low_dev_c_save_tab, l_rel_low_dev_c_save_tab,
                                                  l_target_c_save_tab, l_high_dev_c_save_tab, l_rel_high_dev_c_save_tab,
                                                  l_nr_of_rows, l_modify_reason);
                              END IF;
                              -- If the error is a general failure then the SQLERRM must be logged, otherwise
                              -- the error code is the Unilab error
                              IF l_ret_code <> PA_LIMS.DBERR_SUCCESS THEN
                                 IF l_ret_code = PA_LIMS.DBERR_GENFAIL THEN
                                    -- Log an error to ITERROR
                                    PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                                  'Unable to save the specification data of the link between the parameter '||
                                                  'definitions and '||l_object||' (General failure! Error Code: '||
                                                  l_ret_code||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                                 ELSE
                                    -- Log an error to ITERROR
                                    PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                                  'Unable to save the specification data of the link between the parameter '||
                                                  'definitions and '||l_object||' (Error code : '||l_ret_code||').');
                                 END IF;
                                 -- Tracing
                                 PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted );
                                 RETURN (FALSE);
                              END IF;
                           END LOOP;
                        EXCEPTION
                           WHEN OTHERS THEN
                              -- Log an error in ITERROR
                              PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                            'Unable to save the sorted links between the parameter definitions and '||
                                            l_object||' : '||SQLERRM);
                              -- Tracing
                              PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted );
                              RETURN (FALSE);
                        END;
                     ELSE
                        -- Tracing
                        PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Nothing happened.');
                     END IF;
                  END IF;
               ELSE
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'pp not sorted - not in Unilab with the specified version');
               END IF;
            END IF;
         END LOOP;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Close cursor if still open
         IF l_stgenpp_cursor%ISOPEN THEN
            CLOSE l_stgenpp_cursor;
         END IF;
         -- Log an error to ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to order the parameter definitions within the parameterprofiles in sampletype "'||
                       a_St||'" | version='||a_version||' : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN(FALSE);
   END f_OrderPpPr;

   -- INTERNAL FUNCTION
   FUNCTION f_ToBeTransferred(
      a_part_no     IN specification_header.part_no%TYPE,
      a_revision    IN specification_header.revision%TYPE,
      a_st          IN VARCHAR2,
      a_st_revision IN VARCHAR2
   )
      RETURN BOOLEAN 
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Check if a specification needs to be transferred. It has to on following 
      -- conditions:
      --       if it has propertygroups
      --    OR if it has no propertygroups, but a previous revision has 
      --          already been transferred (because that one did have propertygroups).
      -- ** Parameters **
      -- a_part_no     : part_no of the specification
      -- a_revision    : revision of the specification
      -- a_st          : sample type (generic part)
      -- a_st_revision : sample type revision (generic part revision)
      -- ** Return **
      -- TRUE  : The specification needs to be transferred.
      -- FALSE : The specification does not need to be transferred
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname          CONSTANT VARCHAR2(12)                := 'LimsSpc';
      l_method             CONSTANT VARCHAR2(32)                := 'f_ToBeTransferred';

      -- General variables
      l_nr_of_versions              NUMBER;
      l_nr_of_pg                    NUMBER;
      l_max_version                 VARCHAR2(20);
      l_previous_major_version      VARCHAR2(20);
      l_outside_range               VARCHAR2(20);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_part_no||' | '||a_revision, a_st, NULL, PA_LIMS.c_Msg_Started);

      -- Initialize variables
      l_nr_of_pg       := 0;
      l_nr_of_versions := 0;

      --verify if it has actually a property group
      SELECT COUNT(property_group)
        INTO l_nr_of_pg
        FROM ivpgpr, itlimsconfly limsc
       WHERE ivpgpr.type                IN (1,4)
         AND ivpgpr.display_format      = limsc.layout_id
         AND ivpgpr.display_format_rev  = limsc.layout_rev
         AND ivpgpr.part_no             = a_part_no
         AND ivpgpr.revision            = a_revision;

      PA_LIMS.p_Trace(l_classname, l_method, '#link to LIMS='||l_nr_of_pg, NULL, NULL, NULL);
      IF l_nr_of_pg = 0 THEN
         --the actual version of that specification is not linked with any LIMS property
         --but it might have been linked in a previous version
         --We have to transfer when it is still linked in the LIMS
         --Just checking the previous version in Interspec is not good since
         --not all versions are transferred to the LIMS
         --This check has to take place on the LIMS side
         --
         --For linked specs:
         --we have to check if the parameter profile to be transferred was present
         --in the highest version of the sample type
         --
         --For other specs:
         --A new version has to be created, the previous version will be scanned
         --

         IF a_part_no <> a_st THEN
            -- get the the highest existing version of the st in Unilab
            l_max_version := UNVERSION.ConvertInterspec2Unilab@LNK_LIMS('st', a_st, a_st_revision);
            PA_LIMS.p_Trace(l_classname, l_method, a_part_no||' | is a linked spec,','version scanned in Unilab ',l_max_version, '');
         ELSE
            -- get the the highest existing version of the st in Unilab
            l_max_version := UNVERSION.ConvertInterspec2Unilab@LNK_LIMS('st', a_st, a_st_revision);
            l_outside_range := REPLACE(UNVERSION.GETMAJORVERSIONONLY@LNK_LIMS(l_max_version),'*','%');

            SELECT MAX(version)
            INTO l_max_version
            FROM uvst@LNK_LIMS
            WHERE st = a_st
            AND version < l_max_version
            AND version NOT LIKE l_outside_range;
            PA_LIMS.p_Trace(l_classname, l_method, a_part_no||' | is NOT a linked spec,','version scanned in Unilab ',l_max_version, '');
         END IF;
           
            
         IF l_max_version IS NOT NULL THEN
            
            -- Set the pp keys
            IF NOT PA_LIMS.f_SetPpKeys(a_part_no, a_revision, a_st) THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to set the parameterprofile keys.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               -- End the remote transaction
               IF NOT PA_LIMS.f_EndRemoteTransaction THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               END IF;
               RETURN (FALSE);
            END IF;
            
            -- scan utstpp starting from the previous major version of the st 
            -- until the highest version
            -- to see if there is a pp corresponding to the specified part_no is present
            SELECT count(*) 
            INTO l_nr_of_versions
            FROM UVSTPP@LNK_LIMS
            WHERE st = a_st
            AND version = l_max_version
            AND pp_key1 = PA_LIMS.g_pp_key(1)
            AND pp_key2 = PA_LIMS.g_pp_key(2)
            AND pp_key3 = PA_LIMS.g_pp_key(3)
            AND pp_key4 = PA_LIMS.g_pp_key(4)
            AND pp_key5 = PA_LIMS.g_pp_key(5);
            PA_LIMS.p_Trace(l_classname, l_method, 'Number of links found in earlier versions',l_nr_of_versions,'','');
         END IF;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      
      IF (l_nr_of_pg > 0) OR (l_nr_of_versions > 0) THEN
         PA_LIMS.p_Trace(l_classname, l_method, a_part_no||' | '||a_revision, a_st, NULL, 'returning TRUE');
         RETURN(TRUE);
      ELSE
         PA_LIMS.p_Trace(l_classname, l_method, a_part_no||' | '||a_revision, a_st, NULL, 'returning FALSE');
         RETURN(FALSE);
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error to ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to check if the specification has to be transferred: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN(FALSE);
   END f_ToBeTransferred;

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
      RETURN('06.04.00.00_03.01');
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unable to get the version of the Interspec-Unilab interface : '||SQLERRM);
         RETURN (NULL);
   END f_GetIUIVersion;

   FUNCTION f_TransferSpcSt(
      a_St                IN     VARCHAR2,
      a_version           IN OUT VARCHAR2,
      a_effective_from    IN     DATE,
      a_Description       IN     VARCHAR2,
      a_description2      IN     VARCHAR2,
      a_shelf_life_val    IN     NUMBER,
      a_shelf_life_unit   IN     VARCHAR2,
      a_label_format      IN     VARCHAR2,
      a_default_priority  IN     NUMBER,
      a_Template          IN     VARCHAR2 DEFAULT NULL,
      a_newminor          IN     CHAR
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer a sample type from Interspec to Unilab.
      -- ** Parameters **
      -- a_st               : sampletype to transfer
      -- a_version          : version of the sampletype
      -- a_effective_from   : effective_from date of the sampletype
      -- a_description      : description of the sampletype
      -- a_description2     : description2 of the sampletype
      -- a_shelf_life_val   : shelf_life_value of the sampletype
      -- a_shelf_life_unit  : shelf_life_unit of the sampletype
      -- a_label_format     : label_format of the sampletype
      -- a_default_priority : default_priority of the sampletype
      -- a_Template         : template for the sampletype
      -- a_newminor         : flag indicating if a new minor version has to be created to save modified used objects
      -- ** Return **
      -- TRUE: The transfer of the specification has succeeded.
      -- FALSE: The transfer of the specification has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcSt';
      l_object       VARCHAR2(255);

      -- General variables
      l_a_Template             VARCHAR2(20);
      l_a_Template_version     VARCHAR2(20);
      l_a_description          VARCHAR2(40);
      l_a_description2         VARCHAR2(40);

      -- Specific local variables for the 'GetSampleType' API
      l_return_value_get       INTEGER;
      l_return_value_get_Tmp   INTEGER;
      l_nr_of_rows             NUMBER                            DEFAULT NULL;
      l_where_clause           VARCHAR2(255);
      l_st_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_is_current_tab UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_effective_from_tab     UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_effective_till_tab     UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_description_tab        UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description2_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_is_template_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_confirm_userid_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_shelf_life_val_tab     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_shelf_life_unit_tab    UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_nr_planned_sc_tab      UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_tp_tab            UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_val_tab           UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_unit_tab          UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_invert_freq_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_last_sched_tab         UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_last_cnt_tab           UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_last_val_tab           UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_priority_tab           UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_label_format_tab       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_descr_doc_tab          UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_descr_doc_version_tab  UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_allow_any_pp_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_sc_uc_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_sc_uc_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_sc_lc_tab              UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_sc_lc_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_inherit_gk_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_st_class_tab           UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_log_hs_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_allow_modify_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_active_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_lc_tab                 UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_lc_version_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_ss_tab                 UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'CopySampleType' API
      l_return_value_copy       INTEGER;
      l_return_value_deletestpp BOOLEAN;

      -- Specific local variables for the 'SaveSampleType' API
      l_return_value_save      INTEGER;
      l_st                     VARCHAR2(20);
      l_version                VARCHAR2(20);
      l_version_is_current     CHAR(1);
      l_effective_from         DATE;
      l_effective_till         DATE;
      l_description            VARCHAR2(40);
      l_description2           VARCHAR2(40);
      l_is_template            CHAR(1);
      l_confirm_userid         CHAR(1);
      l_shelf_life_val         NUMBER;
      l_shelf_life_unit        VARCHAR2(20);
      l_nr_planned_sc          NUMBER;
      l_freq_tp                CHAR(1);
      l_freq_val               NUMBER;
      l_freq_unit              VARCHAR2(20);
      l_invert_freq            CHAR(1);
      l_last_sched             DATE;
      l_last_cnt               NUMBER;
      l_last_val               VARCHAR2(40);
      l_priority               NUMBER;
      l_label_format           VARCHAR2(20);
      l_descr_doc              VARCHAR2(40);
      l_descr_doc_version      VARCHAR2(20);
      l_allow_any_pp           CHAR(1);
      l_sc_uc                  VARCHAR2(20);
      l_sc_uc_version          VARCHAR2(20);
      l_sc_lc                  VARCHAR2(2);
      l_sc_lc_version          VARCHAR2(20);
      l_inherit_au             CHAR(1);
      l_inherit_gk             CHAR(1);
      l_st_class               VARCHAR2(2);
      l_log_hs                 CHAR(1);
      l_lc                     VARCHAR2(2);
      l_lc_version             VARCHAR2(20);
      l_modify_reason          VARCHAR2(255);

      -- Specific local variables for the 'GetStGroupKey' API
      l_st_version_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_gk_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_gk_version_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab              UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_is_protected_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_unique_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_single_valued_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_new_val_allowed_tab    UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_mandatory_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_value_list_tp_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_dsp_rows_tab           UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;

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
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, a_description, a_effective_from, PA_LIMS.c_Msg_Started);
      PA_LIMS.p_Trace(l_classname, l_method, a_description2, a_shelf_life_val||' | '||a_shelf_life_unit,
                      a_label_format||' | '||a_default_priority||' | '||a_newminor, a_template);
      
      l_a_description := SUBSTR(a_description, 1, 40);
      l_a_description2 := SUBSTR(a_description2, 1, 40);
      l_a_Template := a_Template;
      -- Initializing variables
      l_object := 'sample type "'||a_St||'" | version='||a_version||' | description="'||l_a_description||'"';

      -- Fill in the parameters to get the standard attributes of the sampletype
      l_where_clause := 'WHERE st='''||REPLACE(a_st,'''','''''')||''' AND version = '''||
                        a_version||''' ORDER BY st, version';
      -- Get the standard attributes of the sampletype
      l_return_value_get := UNAPIST.GETSAMPLETYPE@LNK_LIMS(l_st_tab, l_version_tab, l_version_is_current_tab,
                               l_effective_from_tab, l_effective_till_tab, l_description_tab, l_description2_tab,
                               l_is_template_tab, l_confirm_userid_tab, l_shelf_life_val_tab, l_shelf_life_unit_tab,
                               l_nr_planned_sc_tab, l_freq_tp_tab, l_freq_val_tab, l_freq_unit_tab, l_invert_freq_tab,
                               l_last_sched_tab, l_last_cnt_tab, l_last_val_tab, l_priority_tab, l_label_format_tab,
                               l_descr_doc_tab, l_descr_doc_version_tab, l_allow_any_pp_tab, l_sc_uc_tab, 
                               l_sc_uc_version_tab, l_sc_lc_tab, l_sc_lc_version_tab, l_inherit_au_tab, l_inherit_gk_tab,
                               l_st_class_tab, l_log_hs_tab, l_allow_modify_tab, l_active_tab, l_lc_tab, l_lc_version_tab,
                               l_ss_tab, l_nr_of_rows, l_where_clause);
      -- Check if the sampletype exists in Unilab.  If the sampletype is not found,
      -- then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- Check if the sampletype must be based on a template
         IF NOT l_a_Template IS NULL THEN
            -- Fill in the parameters to get the standard attributes of the sampletype template
            l_where_clause := l_a_Template;
            -- Get the standard attributes of the sampletype template
            l_return_value_get_Tmp := UNAPIST.GETSAMPLETYPE@LNK_LIMS(l_st_tab, l_version_tab, l_version_is_current_tab,
                                         l_effective_from_tab, l_effective_till_tab, l_description_tab, l_description2_tab,
                                         l_is_template_tab, l_confirm_userid_tab, l_shelf_life_val_tab, l_shelf_life_unit_tab,
                                         l_nr_planned_sc_tab, l_freq_tp_tab, l_freq_val_tab, l_freq_unit_tab, 
                                         l_invert_freq_tab, l_last_sched_tab, l_last_cnt_tab, l_last_val_tab,
                                         l_priority_tab, l_label_format_tab, l_descr_doc_tab, l_descr_doc_version_tab,
                                         l_allow_any_pp_tab, l_sc_uc_tab, l_sc_uc_version_tab, l_sc_lc_tab,
                                         l_sc_lc_version_tab, l_inherit_au_tab, l_inherit_gk_tab, l_st_class_tab,
                                         l_log_hs_tab, l_allow_modify_tab, l_active_tab, l_lc_tab, l_lc_version_tab,
                                         l_ss_tab, l_nr_of_rows, l_where_clause);
            -- The template doesn't exist
            IF l_return_value_get_Tmp <> PA_LIMS.DBERR_SUCCESS THEN
               -- The sampletype will not be transferred
               IF PA_LIMS.f_GetSettingValue('TMP Master ST') = '1' THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'The sample type template "'||a_Template||'" doesn''t exist. (The '||l_object||
                                ' is not transferred)');
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               -- The sampletype will be transferred
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'The sample type template "'||a_Template||'" doesn''t exist. (The '||l_object||' is transferred)');
                  l_a_Template := NULL;
               END IF;
            ELSE
               -- Fill in the parameters to save the standard attributes of the sampletype
               -- if there is a sampletype template
               l_a_Template_version := l_version_tab(l_nr_of_rows);
               l_version_is_current := NULL;
               l_effective_till     := TO_DATE(l_effective_till_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat);
               l_description        := NVL(l_a_description, l_description_tab(l_nr_of_rows));
               l_description2       := NVL(l_a_description2, l_description2_tab(l_nr_of_rows));
               l_is_template        := '0';
               l_confirm_userid     := l_confirm_userid_tab(l_nr_of_rows);
               l_shelf_life_val     := NVL(a_shelf_life_val, l_shelf_life_val_tab(l_nr_of_rows));
               l_shelf_life_unit    := NVL(a_shelf_life_unit, l_shelf_life_unit_tab(l_nr_of_rows));
               l_nr_planned_sc      := l_nr_planned_sc_tab(l_nr_of_rows);
               l_freq_tp            := l_freq_tp_tab(l_nr_of_rows);
               l_freq_val           := l_freq_val_tab(l_nr_of_rows);
               l_freq_unit          := l_freq_unit_tab(l_nr_of_rows);
               l_invert_freq        := l_invert_freq_tab(l_nr_of_rows);
               l_last_sched         := TO_DATE(l_last_sched_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat);
               l_last_cnt           := l_last_cnt_tab(l_nr_of_rows);
               l_last_val           := l_last_val_tab(l_nr_of_rows);
               l_priority           := NVL(a_default_priority, l_priority_tab(l_nr_of_rows));
               l_label_format       := NVL(a_label_format, l_label_format_tab(l_nr_of_rows));
               l_descr_doc          := l_descr_doc_tab(l_nr_of_rows);
               l_descr_doc_version  := l_descr_doc_version_tab(l_nr_of_rows);
               l_allow_any_pp       := l_allow_any_pp_tab(l_nr_of_rows);
               l_sc_uc              := l_sc_uc_tab(l_nr_of_rows);
               l_sc_uc_version      := l_sc_uc_version_tab(l_nr_of_rows);
               l_sc_lc              := l_sc_lc_tab(l_nr_of_rows);
               l_sc_lc_version      := l_sc_lc_version_tab(l_nr_of_rows);
               l_inherit_au         := l_inherit_au_tab(l_nr_of_rows);
               l_inherit_gk         := l_inherit_gk_tab(l_nr_of_rows);
               l_st_class           := l_st_class_tab(l_nr_of_rows);
               l_log_hs             := l_log_hs_tab(l_nr_of_rows);
               l_lc                 := l_lc_tab(l_nr_of_rows);
               l_lc_version         := l_lc_version_tab(l_nr_of_rows);
               l_modify_reason      := 'Imported sample type "'||a_st||'" from Interspec (template : '||l_a_Template||').';
            END IF;
         END IF;

         -- Check if the default values for the sampletypes have to be set
         IF l_a_template IS NULL THEN
            -- Fill in the parameters to save the standard attributes of the sampletype
            -- if there is no sampletype template
            l_version_is_current := NULL;
            l_effective_till     := NULL;
            l_description        := l_a_description;
            l_description2       := l_a_description2;
            l_is_template        := '0';
            l_confirm_userid     := '0';
            l_shelf_life_val     := NVL(a_shelf_life_val, 6);
            l_shelf_life_unit    := NVL(a_shelf_life_unit, 'MM');
            l_nr_planned_sc      := 1;
            l_freq_tp            := 'A';
            l_freq_val           := 0;
            l_freq_unit          := 'DD';
            l_invert_freq        := '0';
            l_last_sched         := TRUNC(SYSDATE, 'DD');
            l_last_cnt           := 0;
            l_last_val           := '';
            l_priority           := NVL(a_default_priority, 1);
            l_label_format       := a_label_format;
            l_descr_doc          := '';
            l_descr_doc_version  := '';
            l_allow_any_pp       := '1';
            l_sc_uc              := '';
            l_sc_uc_version      := '';
            l_sc_lc              := '';
            l_sc_lc_version      := '';
            l_inherit_au         := '1';
            l_inherit_gk         := '0';
            l_st_class           := '';
            l_log_hs             := '1';
            l_modify_reason      := 'Imported sample type "'||a_st||'" from Interspec (no template has been used).';
         END IF;
         -- The sampletype template lifecycle OR the sampletype template itself is empty 
         -- => take default lc
         IF l_lc IS NULL THEN
            BEGIN
               SELECT uvobjects.def_lc, uvlc.version
               INTO l_lc, l_lc_version 
               FROM UVOBJECTS@LNK_LIMS, UVLC@LNK_LIMS
               WHERE uvobjects.object = 'st'
               AND   uvobjects.def_lc = uvlc.lc
               AND   uvlc.version_is_current = '1';
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'No current version found for the default sample type lifecycle.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END;
         END IF;
         -- Fill in the parameters to save the standard attributes of the sampletype
         l_st               := a_St;
         l_version          := a_version;
         l_effective_from   := a_effective_from;
         BEGIN
            --copy from template when template available and global setting set
            IF PA_LIMS.g_use_template_details = '1' AND
               l_a_Template IS NOT NULL AND
               l_a_Template_version IS NOT NULL THEN
               l_return_value_copy := UNAPIST.CopySampleType@LNK_LIMS(l_a_Template, l_a_Template_version, l_st, l_version, '');
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
                  --Delete all records of stpp and stppau for that sample type
                  --These entries will be used only when transfering the stpp entries to determine the assignement frequencies
                  l_return_value_deletestpp := f_DeleteAllStPp(l_st, l_version);
                  IF l_return_value_deletestpp <> TRUE THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to delete all stpp entries for '||l_object);
                  END IF;
               END IF;
            END IF;
            -- Save the standard attributes of the sampletype
            l_return_value_save := UNAPIST.SAVESAMPLETYPE@LNK_LIMS(l_st, l_version, l_version_is_current, l_effective_from,
                                      l_effective_till, l_description, l_description2, l_is_template, l_confirm_userid,
                                      l_shelf_life_val, l_shelf_life_unit, l_nr_planned_sc, l_freq_tp, l_freq_val,
                                      l_freq_unit, l_invert_freq, l_last_sched, l_last_cnt, l_last_val, l_priority,
                                      l_label_format, l_descr_doc, l_descr_doc_version, l_allow_any_pp, l_sc_uc, 
                                      l_sc_uc_version, l_sc_lc, l_sc_lc_version, l_inherit_au, l_inherit_gk, l_st_class,
                                      l_log_hs, l_lc, l_lc_version, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, 
            -- otherwise the error code is the Unilab error
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
            --Add an event in the event buffer to be sent at the end of the transfer
            PA_LIMS.g_evbuff_nr_of_rows := PA_LIMS.g_evbuff_nr_of_rows+1;
            PA_LIMS.g_evbufftab_object_tp(PA_LIMS.g_evbuff_nr_of_rows) := 'st';
            PA_LIMS.g_evbufftab_object_id(PA_LIMS.g_evbuff_nr_of_rows) := l_st;
            PA_LIMS.g_evbufftab_ev_details(PA_LIMS.g_evbuff_nr_of_rows) := 'version='||l_version||'#sub_ev_tp=TransferCompleted';
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the standard attributes of '||l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;

         -- If the sampletype is based on a template 
         -- then the group keys have to be transferred
         IF NOT l_a_Template IS NULL THEN
            -- Fill in the parameters to get the standard attributes of the link 
            -- between the sampletype groupkeys and the sampletype template.
            l_nr_of_rows   := NULL;
            l_where_clause := l_a_Template;
            -- Get the standard attributes of the link 
            -- between the sampletype groupkeys and the sampletype template.
            l_return_value_get := UNAPIST.GETSTGROUPKEY@LNK_LIMS(l_st_tab, l_st_version_tab, l_gk_tab, l_gk_version_tab,
                                     l_value_tab, l_description_tab, l_is_protected_tab, l_value_unique_tab,
                                     l_single_valued_tab, l_new_val_allowed_tab, l_mandatory_tab, l_value_list_tp_tab,
                                     l_dsp_rows_tab, l_nr_of_rows, l_where_clause);
            IF l_return_value_get <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
                   -- No links between sampletype groupkeys and the sampletype template exist.
                   -- Tracing
                   PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'No groupkeys to save: '||PA_LIMS.c_Msg_Ended);
                  RETURN (TRUE);
               ELSIF l_return_value_get = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                     'Unable to get the standard attributes of the link between the groupkeys and sample type template "'||
                     l_a_Template||' (General failure! Error Code: '||l_return_value_get||' Error Msg:'||
                     UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                     'Unable to get the standard attributes of the link between the groupkeys and sample type template "'||
                     l_a_Template||'" (Error code : '||l_return_value_get||').');
               END IF;
               
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Fill in the parameters to save the standard attributes of the link 
            -- between the sampletype groupkeys and the sampletype template.
            l_modify_reason   := 'Imported the links between the groupkeys and sample type "'||a_st||
                                 '" from Interspec (template : '||l_a_template||').';
            -- Save the standard attributes of the link 
            -- between the sampletype groupkeys and the sampletype.
            l_return_value_save := UNAPIST.SAVESTGROUPKEY@LNK_LIMS(a_St, l_version, l_gk_tab, l_gk_version_tab,
                                                                   l_value_tab, l_nr_of_rows, l_modify_reason);
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                     'Unable to save the standard attributes of the link between the groupkeys and sample type template "'||
                     l_a_Template||' (General failure! Error Code: '||l_return_value_save||' Error Msg:'||
                     UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                     'Unable to save the standard attributes of the link between the groupkeys and sample type template "'||
                     l_a_Template||'" (Error code : '||l_return_value_save||').');
               END IF;
               
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         END IF;
      -- When the sampletype is already in Unilab, it must be checked if it has been updated
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         -- Check if the one of the given parameters has been updated. This has only to be checked if the newminor flag is '0', 
         -- because in the other case the given parameters have not been set.
         IF (a_newminor = '0') AND
            (PA_LIMS_SPECX_TOOLS.COMPARE_DATE(a_effective_from,TO_DATE(l_effective_from_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat))=1 OR
             a_effective_from IS NULL) AND 
            (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_a_Description,l_description_tab(l_nr_of_rows))=1 OR l_a_description IS NULL) AND
            (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_a_description2,l_description2_tab(l_nr_of_rows))=1 OR l_a_description2 IS NULL) AND
            (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(a_shelf_life_val,l_shelf_life_val_tab(l_nr_of_rows))=1 OR a_shelf_life_val IS NULL) AND
            (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(a_shelf_life_unit,l_shelf_life_unit_tab(l_nr_of_rows))=1 OR a_shelf_life_unit IS NULL) AND
            (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(a_label_format,l_label_format_tab(l_nr_of_rows))=1 OR a_label_format IS NULL) AND
            (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(a_default_priority,l_priority_tab(l_nr_of_rows))=1 OR a_default_priority IS NULL) THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Nothing happened: '||PA_LIMS.c_Msg_Ended);
            RETURN (TRUE);
         END IF;

         BEGIN
            -- Get the authorisation of the sampletype
            l_ret_code := UNAPIGEN.GETAUTHORISATION@LNK_LIMS('st', a_st, a_version, l_st_lc, l_st_lc_version, l_st_ss,
                                                             l_st_allow_modify, l_st_active, l_st_log_hs);
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
               -- Fill in the parameters to save the standard attributes of the sampletype
               l_st                := a_St;
               l_version           := NULL;
               l_modify_reason     := 'Imported a new version of sample type "'||a_St||'" from Interspec.';
               -- Create a new minor version of the sampletype
               l_return_value_save := UNAPIST.COPYSAMPLETYPE@LNK_LIMS(a_st, a_version, l_st, l_version, l_modify_reason);
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
            
            -- In case one of the given parameters had been changed, it has to be modified in the new version
            IF (a_newminor = '0') THEN
               -- Fill in the parameters to save the standard attributes of the sampletype
               l_st                 := a_st;
               l_version            := a_version;
               l_version_is_current := NULL;
               l_effective_from     := NVL(a_effective_from,
                                           TO_DATE(l_effective_from_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat));
               l_effective_till     := TO_DATE(l_effective_till_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat);
               l_description        := NVL(l_a_description, l_description_tab(l_nr_of_rows));
               l_description2       := NVL(l_a_description2, l_description2_tab(l_nr_of_rows));
               l_is_template        := '0';
               l_confirm_userid     := l_confirm_userid_tab(l_nr_of_rows);
               l_shelf_life_val     := NVL(a_shelf_life_val, l_shelf_life_val_tab(l_nr_of_rows));
               l_shelf_life_unit    := NVL(a_shelf_life_unit, l_shelf_life_unit_tab(l_nr_of_rows));
               l_nr_planned_sc      := l_nr_planned_sc_tab(l_nr_of_rows);
               l_freq_tp            := l_freq_tp_tab(l_nr_of_rows);
               l_freq_val           := l_freq_val_tab(l_nr_of_rows);
               l_freq_unit          := l_freq_unit_tab(l_nr_of_rows);
               l_invert_freq        := l_invert_freq_tab(l_nr_of_rows);
               l_last_sched         := TO_DATE(l_last_sched_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat);
               l_last_cnt           := l_last_cnt_tab(l_nr_of_rows);
               l_last_val           := l_last_val_tab(l_nr_of_rows);
               l_priority           := NVL(a_default_priority, l_priority_tab(l_nr_of_rows));
               l_label_format       := NVL(a_label_format, l_label_format_tab(l_nr_of_rows));
               l_descr_doc          := l_descr_doc_tab(l_nr_of_rows);
               l_descr_doc_version  := l_descr_doc_version_tab(l_nr_of_rows);
               l_allow_any_pp       := l_allow_any_pp_tab(l_nr_of_rows);
               l_sc_uc              := l_sc_uc_tab(l_nr_of_rows);
               l_sc_uc_version      := l_sc_uc_version_tab(l_nr_of_rows);
               l_sc_lc              := l_sc_lc_tab(l_nr_of_rows);
               l_sc_lc_version      := l_sc_lc_version_tab(l_nr_of_rows);
               l_inherit_au         := l_inherit_au_tab(l_nr_of_rows);
               l_inherit_gk         := l_inherit_gk_tab(l_nr_of_rows);
               l_st_class           := l_st_class_tab(l_nr_of_rows);
               l_log_hs             := l_log_hs_tab(l_nr_of_rows);
               l_lc                 := l_lc_tab(l_nr_of_rows);
               l_lc_version         := l_lc_version_tab(l_nr_of_rows);
               l_modify_reason      := 'Imported modified standard attributes of sample type "'||a_St||'" from Interspec.';
               BEGIN
                  -- Save the standard attributes of the sampletype
                  l_return_value_save := UNAPIST.SAVESAMPLETYPE@LNK_LIMS(l_st, l_version, l_version_is_current,
                                            l_effective_from, l_effective_till, l_description, l_description2,
                                            l_is_template, l_confirm_userid, l_shelf_life_val, l_shelf_life_unit,
                                            l_nr_planned_sc, l_freq_tp, l_freq_val, l_freq_unit, l_invert_freq,
                                            l_last_sched, l_last_cnt, l_last_val, l_priority, l_label_format, l_descr_doc,
                                            l_descr_doc_version, l_allow_any_pp, l_sc_uc, l_sc_uc_version, l_sc_lc,
                                            l_sc_lc_version, l_inherit_au, l_inherit_gk, l_st_class, l_log_hs, l_lc,
                                            l_lc_version, l_modify_reason);
                  -- If the error is a general failure then the SQLERRM must be logged, 
                  -- otherwise the error code is the Unilab error
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
                    PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted );
                     RETURN (FALSE);
                  END IF;
                  --Add an event in the event buffer to be sent at the end of the transfer
                  PA_LIMS.g_evbuff_nr_of_rows := PA_LIMS.g_evbuff_nr_of_rows+1;
                  PA_LIMS.g_evbufftab_object_tp(PA_LIMS.g_evbuff_nr_of_rows) := 'st';
                  PA_LIMS.g_evbufftab_object_id(PA_LIMS.g_evbuff_nr_of_rows) := l_st;
                  PA_LIMS.g_evbufftab_ev_details(PA_LIMS.g_evbuff_nr_of_rows) := 'version='||l_version||'#sub_ev_tp=TransferCompleted';
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
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_object||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcSt;

   FUNCTION f_InheritLinkedSpc(
      a_sh_revision             IN     NUMBER,
      a_generic_Part_No         IN     specification_header.part_no%TYPE,   -- generic spec
      a_generic_Revision        IN     specification_header.revision%TYPE,  -- revision of the generic spec
      a_linked_Part_No          IN     specification_header.part_no%TYPE,   -- linked spec
      a_linked_Revision         IN     specification_header.revision%TYPE   -- revision of linked spec
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer the used objects (recursive) of the linked specification.
      -- ** Parameters **
      -- a_sh_revision       : revision of the specification, to base the parameterprofile version on
      -- a_generic_part_no   : part_no of the generic specification
      -- a_generic_revision  : revision of the generic specification
      -- a_linked_part_no    : part_no of the linked specification
      -- a_linked_revision   : revision of the linked specification
      -- ** Return **
      -- TRUE  : the transfer has succeeded.
      -- FALSE : the transfer has failed.
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname        CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method           CONSTANT VARCHAR2(32)                      := 'f_InheritLinkedSpc';

      -- General variables
      l_PP_Template      VARCHAR2(20);
      l_PpId             VARCHAR2(20);
      l_pp_version       VARCHAR2(20);
      l_pp_desc          VARCHAR2(40);
      l_pg_revision      NUMBER;
      l_PrId             VARCHAR2(20);
      l_pr_version       VARCHAR2(20);
      l_prmt_version     VARCHAR2(20);
      l_pppr_version     VARCHAR2(20);
      l_ppprmt_version   VARCHAR2(20);
      l_pr_desc          VARCHAR2(40);
      l_sp_revision      NUMBER;
      l_sp_desc          VARCHAR2(130);
      l_MtId             VARCHAR2(20);
      l_mt_desc          VARCHAR2(40);
      l_tm_revision      NUMBER;
      l_PR_Template      VARCHAR2(20);
      l_orig_name        VARCHAR2(40);
      l_PrevPg           NUMBER(6);
      l_PrevPgRev        NUMBER(4);
      l_PrevSc_tab       UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_PrevSsc_tab      UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_prop_tab         UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_att_tab          UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_PrevPp           VARCHAR2(20);
      l_PrevPpVersion    VARCHAR2(20);
      l_pr_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_version_tab   UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_version_tab   UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_nr_of_pr         NUMBER;
      l_pp_exists        BOOLEAN;
      l_temp_pp          VARCHAR2(20);

      -- Cursor to get all the properties that are present in the generic specification
      -- but not present in the linked specification
      CURSOR l_GetGenericProp_Cursor(
         c_Generic_Part_No     specification_header.part_no%TYPE,
         c_Generic_Revision    specification_header.revision%TYPE,
         c_linked_Part_No      specification_header.part_no%TYPE,
         c_linked_Revision     specification_header.revision%TYPE
      )
      IS
         SELECT DISTINCT pgpr.property, pgpr.property_group, pgpr.property_group_rev, 
                         pgpr.section_id, pgpr.sub_section_id,  
                         pgpr.test_method,
                         f_sph_descr(1, pgpr.property, 0) sp_desc,
                         f_ath_descr(1, pgpr.attribute, 0) at_desc,
                         pgpr.attribute, pgpr.sequence_no,
                         f_pgh_descr(1, pgpr.property_group, 0) pg_desc,
                         f_mth_descr(1, pgpr.test_method, 0) tm_desc
                    FROM ivpgpr pgpr, itlimsconfly limsc
                   WHERE pgpr.display_format = limsc.layout_id
                     AND pgpr.display_format_rev = limsc.layout_rev
                     AND limsc.un_object IN ('PR', 'PPPR')
                     AND pgpr.part_no = c_Generic_Part_No
                     AND pgpr.revision = c_Generic_Revision
                     AND (pgpr.property,pgpr.attribute) NOT IN
                               (SELECT property, attribute
                                  FROM specification_prop
                                 WHERE part_no = c_linked_Part_No
                                   AND revision = c_linked_Revision
                                   AND property_group = pgpr.property_group)
                ORDER BY pgpr.property_group, pgpr.section_id, pgpr.sub_section_id, pgpr.sequence_no;

      -- Cursor to get the information about the link between the property group 
      -- and the generic specification
--      CURSOR l_GetGenericDetail_Cursor(
--         c_Generic_Part_No         specification_header.part_no%TYPE,
--         c_Generic_Revision        specification_header.revision%TYPE,
--         c_PropertyGroup           specification_section.ref_id%TYPE
--      )
--      IS
--         SELECT DISTINCT sps.part_no, sps.section_id, sps.sub_section_id
--           FROM specification_prop spp, specification_section sps
--          WHERE spp.property_group = sps.ref_id
--            AND spp.part_no = sps.part_no
--            AND spp.revision = sps.revision
--            AND spp.section_id = sps.section_id
--            AND spp.sub_section_id = sps.sub_section_id
--            AND sps.part_no = c_Generic_Part_No
--            AND sps.revision = c_Generic_Revision
--            AND sps.ref_id = c_PropertyGroup
--            AND sps.type = 1
--            ORDER BY sps.section_id, sps.sub_section_id;

      -- Cursor to get all the links between parameter definitions and the parameter profile
--      CURSOR l_PpPrToTransfer_Cursor(
--         c_Part_No       specification_header.part_no%TYPE,
--         c_Revision      specification_header.revision%TYPE,
--         c_Sub_Section   specification_section.sub_section_id%TYPE,
--         c_Section       specification_section.section_id%TYPE,
--         c_Property      specification_prop.property%TYPE,
--         c_Attribute     specification_prop.attribute%TYPE
--      )
--      IS
--         SELECT DISTINCT ivpgpr.property_group, ivpgpr.property_group_rev,
--                         ivpgpr.property, ivpgpr.section_id,
--                         ivpgpr.sub_section_id, ivpgpr.test_method,
--                         f_sph_descr(1, ivpgpr.property, 0) sp_desc,
--                         f_ath_descr(1, ivpgpr.attribute, 0) at_desc,
--                         ivpgpr.attribute, ivpgpr.sequence_no
--                    FROM itlimsconfly limsc, ivpgpr
--                   WHERE ivpgpr.display_format = limsc.layout_id
--                     AND ivpgpr.display_format_rev = limsc.layout_rev
--                     AND ivpgpr.type = 1
--                     AND ivpgpr.sub_section_id = c_Sub_Section
--                     AND ivpgpr.section_id = c_Section
--                     AND ivpgpr.property = c_Property
--                     AND ivpgpr.attribute = c_Attribute
--                     AND ivpgpr.part_no = c_Part_No
--                     AND ivpgpr.revision = c_Revision
--                     AND limsc.un_object IN ('PR', 'PPPR')
--                ORDER BY ivpgpr.sequence_no;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_sh_revision, a_generic_part_no||' | '||a_generic_revision,
                      a_linked_part_no||' | '||a_linked_revision, PA_LIMS.c_Msg_Started);

      -- Check if the generic specification must inherit the properties of the linked specifications
      IF PA_LIMS.f_GetSettingValue('Inherit Linked Spc') = 0 THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
         RETURN (TRUE);
      END IF;

      -- Initialize variables
      l_nr_of_pr      := 0;
      l_PrevPg        := -1;
      l_PrevPgRev     := -1;
      l_PrevPp        := ' ';
      l_PrevPpVersion := ' ';
      l_pppr_version := '~Current~';

      -- Get all the properties that are linked to the generic specification,
      -- but NOT to the linked specification
      FOR l_GetGenericProp_Rec IN l_GetGenericProp_Cursor(a_generic_part_no, a_generic_Revision,
                                                          a_linked_Part_No, a_linked_Revision) LOOP
         BEGIN
            -- Generate the parameterprofile id, version and description, 
            -- based on the highest revision of the property group
            l_pg_revision := PA_LIMS.f_GetHighestRevision('property_group', l_GetGenericProp_Rec.property_group);
            l_PpId := PA_LIMS.f_GetPpId(a_linked_part_no, l_GetGenericProp_Rec.property_group, l_pg_revision,
                                        l_GetGenericProp_Rec.pg_desc, l_pp_desc);
            l_pp_version := UNVERSION.CONVERTINTERSPEC2UNILABPP@LNK_LIMS(l_ppid, PA_LIMS.g_pp_key(1), PA_LIMS.g_pp_key(2), 
                                                                         PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                                                                         PA_LIMS.g_pp_key(5), a_sh_revision);
            --This function can be called for a linked spec
            --that has no display format but some properties in 
            --its generic specificaction
            --In that case, the pp doesn't exist but the cursors will
            --return parameters that doesn't exist
            --Also, no attempt will be made to save these parameters 
            --on a non existing parameter profile which should lead to errors
            l_pp_exists := FALSE;
            BEGIN
               SELECT pp
               INTO l_temp_pp
               FROM uvpp@LNK_LIMS
               WHERE pp = l_PpId
               AND version = l_pp_version
               AND pp_key1 = PA_LIMS.g_pp_key(1)
               AND pp_key2 = PA_LIMS.g_pp_key(2)
               AND pp_key3 = PA_LIMS.g_pp_key(3)
               AND pp_key4 = PA_LIMS.g_pp_key(4)
               AND pp_key5 = PA_LIMS.g_pp_key(5);
               l_pp_exists := TRUE;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            END;
            IF l_pp_exists THEN --no processing at all when not existing
            
               -- Check if the method definition linked to the parameterprofile-parameter link has to be transferred
               -- Generate the method definition id, version and description, 
               -- based on the highest revision of the test method
               IF PA_LIMS.f_GetSettingValue('Transfer PPPR MT') = 1 THEN
                  l_tm_revision := PA_LIMS.f_GetHighestRevision('test_method', l_GetGenericProp_Rec.test_method);
                  l_MtId := PA_LIMS.f_GetMtId(l_GetGenericProp_Rec.test_method, l_tm_revision,
                               l_GetGenericProp_Rec.tm_desc, l_mt_desc);
                  l_ppprmt_version := '~Current~';
               ELSE
                  l_MtId := NULL;
                  l_tm_revision := NULL;
                  l_ppprmt_version := NULL;
               END IF;

               -- Generate the parameter definition id, version and description,
               -- based on the highest revision of the property
               l_sp_revision := PA_LIMS.f_GetHighestRevision('property', l_GetGenericProp_Rec.Property);
               IF l_GetGenericProp_Rec.Attribute = 0 THEN
                  l_sp_desc := l_GetGenericProp_Rec.sp_desc;
                  l_orig_name := l_GetGenericProp_Rec.Property;
               ELSE
                  l_sp_desc := l_GetGenericProp_Rec.sp_desc||' '||l_GetGenericProp_Rec.at_desc;
                  l_orig_name := RPAD(l_GetGenericProp_Rec.Property,10,' ')||l_GetGenericProp_Rec.Attribute;
               END IF;
               l_PrId := PA_LIMS.f_GetPrId(l_GetGenericProp_Rec.Property, l_sp_revision, l_GetGenericProp_Rec.Attribute,
                                           l_sp_desc, l_pr_desc);
               l_pr_version := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('pr', l_prid, l_sp_revision);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer the link between parameter definition "'||l_PrId||'" | version='||
                             l_pr_version||' | description="'||l_pr_desc||'" and parameterprofile "'||l_PpId||
                             '" | version='||l_pp_version||' | pp_keys= "'||PA_LIMS.g_pp_key(1)||'"#"'||
                             PA_LIMS.g_pp_key(2)||'"#"'||PA_LIMS.g_pp_key(3)||'"#"'||PA_LIMS.g_pp_key(4)||'"#"'||
                             PA_LIMS.g_pp_key(5)||'" | description="'||l_pp_desc||'" : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;

         IF l_pp_exists THEN --no processing at all when not existing
            -- Get the information about the link between the property group and the generic specification
--            FOR l_GetGenericDetail_Rec IN l_GetGenericDetail_Cursor(a_generic_part_no, a_generic_Revision,
--                                                                    l_GetGenericProp_Rec.property_group) LOOP
               BEGIN
                  -- Initialize variables on the first time the most outer loop is run
                  IF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, -1) = 1) THEN
                     l_PrevPg        := l_GetGenericProp_Rec.property_group;
                     l_PrevPgRev     := l_GetGenericProp_Rec.property_group_rev;
                     l_PrevPp        := l_PpId;
                     l_PrevPpVersion := l_pp_version;
                     l_nr_of_pr      := l_nr_of_pr + 1;
                  ELSIF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, l_GetGenericProp_Rec.property_group) = 0) THEN
                     -- Transfer the link between the parameter definition and the parameterprofile
                     l_PP_Template := GetTemplete4PropertyGroup(a_generic_Part_No, a_generic_Revision, l_PrevPg, l_PrevPgRev);
                     IF f_TransferSpcPpPr(l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), 
                                          PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                                          PA_LIMS.g_pp_key(5), l_pr_tab, l_pr_version_tab, 
                                          l_mt_tab, l_mt_version_tab, l_nr_of_pr, l_PP_Template) THEN
--                        FOR l_PpPrToTransfer_Rec IN l_PpPrToTransfer_Cursor(a_generic_part_no, 
--                                 a_generic_Revision, l_PrevSsc, l_PrevSc, l_prop_tab(l_nr_of_pr), l_att_tab(l_nr_of_pr)) LOOP
                           -- Transfer the specification data of all properties in a property group
                           IF NOT f_TransferSpcAllPpPrSp(l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), 
                                    PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                                    PA_LIMS.g_pp_key(5), a_generic_Part_No, a_generic_Revision, 
--                                    l_PpPrToTransfer_Rec.property_group, 
                                    l_PrevPg, 
                                    l_PrevSc_tab, l_PrevSsc_tab, 
                                    l_prop_tab, l_att_tab, l_nr_of_pr) THEN
                              -- Tracing
                              PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                              RETURN (FALSE);
                           END IF;
--                        END LOOP;
                     ELSE
                        -- Tracing
                        PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                        RETURN (FALSE);
                     END IF;

                     -- Transfer the attributes of the merged properties 
                     -- as attributes on the link between the parameter definition and the parameterprofile
                     IF NOT f_TransferSpcAllPpPrAu_AttSp(a_generic_Part_No, a_generic_Revision, l_PrevSc_tab,
                                l_PrevSsc_tab, l_nr_of_pr, l_PrevPg, l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), 
                                PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                                PA_LIMS.g_pp_key(5)) THEN
                        -- Tracing
                        PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                        RETURN (FALSE);
                     END IF;

                     l_PrevPg        := l_GetGenericProp_Rec.property_group;
                     l_PrevPgRev     := l_GetGenericProp_Rec.property_group_rev;
                     l_PrevPp        := l_PpId;
                     l_PrevPpVersion := l_pp_version;
                     l_nr_of_pr      := 1;
                  ELSE
                     l_nr_of_pr := l_nr_of_pr + 1;
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     -- Log an error in ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to transfer the link between parameter definition "'||l_PrId||'" | version='||
                                   l_pr_version||' | description="'||l_pr_desc||'" and parameterprofile "'||l_PpId||
                                   '" | version='||l_pp_version||' | pp_keys= "'||PA_LIMS.g_pp_key(1)||'"#"'||
                                   PA_LIMS.g_pp_key(2)||'"#"'||PA_LIMS.g_pp_key(3)||'"#"'||PA_LIMS.g_pp_key(4)||'"#"'||
                                   PA_LIMS.g_pp_key(5)||'" | description="'||l_pp_desc||'" : '||SQLERRM);
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
               END;
               
               l_pr_tab(l_nr_of_pr)           := l_PrID;
               l_pr_version_tab(l_nr_of_pr)   := l_pppr_version;
               l_mt_tab(l_nr_of_pr)           := l_MtId;
               l_mt_version_tab(l_nr_of_pr)   := l_ppprmt_version;
               l_PrevSc_tab(l_nr_of_pr)       := l_GetGenericProp_Rec.section_id;
               l_PrevSsc_tab(l_nr_of_pr)      := l_GetGenericProp_Rec.sub_section_id;
               l_prop_tab(l_nr_of_pr)         := l_GetGenericProp_Rec.property;
               l_att_tab(l_nr_of_pr)          := l_GetGenericProp_Rec.Attribute;
--            END LOOP;
         END IF;
      END LOOP;
      
      IF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, -1) = 0) THEN
         -- Transfer the link between the parameter definition and the parameterprofile
         l_PP_Template := GetTemplete4PropertyGroup(a_generic_Part_No, a_generic_Revision, l_PrevPg, l_PrevPgRev);
         IF f_TransferSpcPpPr(l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), 
                              PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                              PA_LIMS.g_pp_key(5), l_pr_tab, l_pr_version_tab, 
                              l_mt_tab, l_mt_version_tab, l_nr_of_pr, l_PP_Template) THEN
--            FOR l_PpPrToTransfer_Rec IN l_PpPrToTransfer_Cursor(a_generic_part_no, 
--                     a_generic_Revision, l_PrevSsc, l_PrevSc, l_prop_tab(l_nr_of_pr), l_att_tab(l_nr_of_pr)) LOOP
               -- Transfer the specification data of all properties in a property group
               IF NOT f_TransferSpcAllPpPrSp(l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), 
                        PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                        PA_LIMS.g_pp_key(5), a_generic_Part_No, a_generic_Revision, 
--                        l_PpPrToTransfer_Rec.property_group, 
                        l_PrevPg,
                        l_PrevSc_tab, l_PrevSsc_tab, 
                        l_prop_tab, l_att_tab, l_nr_of_pr) THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               END IF;
--            END LOOP;
         ELSE
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;

         -- Transfer the attributes of the merged properties 
         -- as attributes on the link between the parameter definition and the parameterprofile
         IF NOT f_TransferSpcAllPpPrAu_AttSp(a_generic_Part_No, a_generic_Revision,
                   l_PrevSc_tab, l_PrevSsc_tab, l_nr_of_pr, l_PrevPg, l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1),
                   PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4),
                   PA_LIMS.g_pp_key(5)) THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
      END IF;
      
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error to ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when inheriting from the linked specifications : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_InheritLinkedSpc;

   FUNCTION f_TransferSpcAu(
      a_tp           IN     VARCHAR2,
      a_id           IN     VARCHAR2,
      a_version      IN OUT VARCHAR2,
      a_Au_tab       IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_Value_tab    IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows   IN     NUMBER
   )
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN (PA_LIMSSPC2.f_TransferSpcAu(a_tp, a_id, a_version, a_au_tab, a_value_tab, a_nr_of_rows));
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
   BEGIN
      RETURN(PA_LIMSSPC2.f_TransferSpcPpAu(a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5,
                                           a_Au, a_Value));
   END f_TransferSpcPpAu;

   FUNCTION f_TransferSpcAllStAu(
      a_St         IN     VARCHAR2,
      a_version    IN OUT VARCHAR2,
      a_Part_No    IN     SPECIFICATION_HEADER.PART_NO%TYPE,
      a_Revision   IN     SPECIFICATION_HEADER.REVISION%TYPE
   )
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN(PA_LIMSSPC2.f_TransferSpcAllStAu(a_st, a_version, a_part_no, a_revision));
   END f_TransferSpcAllStAu;

   FUNCTION f_TransferSpcAllStAu_AttachSp(
      a_St                  IN     VARCHAR2,
      a_version             IN OUT VARCHAR2,
      a_sh_revision         IN     NUMBER,
      a_linked_Part_No    IN     specification_header.part_no%TYPE,
      a_linked_Revision   IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN(PA_LIMSSPC2.f_TransferSpcAllStAu_AttachSp(a_st, a_version, a_sh_revision, a_linked_part_no, 
                                                       a_linked_revision));
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
   BEGIN
      RETURN(PA_LIMSSPC2.f_TransferSpcStGk(a_st, a_version, a_gk, a_gk_version, a_value, a_nr_of_rows));
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
   BEGIN
      RETURN(PA_LIMSSPC2.f_DeleteSpcStGk(a_st, a_version, a_gk, a_gk_version, a_value, a_nr_of_rows));
   END f_DeleteSpcStGk;

   FUNCTION f_TransferSpcAllStGk(
      a_st         IN     VARCHAR2,
      a_version    IN OUT VARCHAR2,
      a_Part_No    IN     specification_header.part_no%TYPE,
      a_Revision   IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN
   IS
   BEGIN
      RETURN(PA_LIMSSPC2.f_TransferSpcAllStGk(a_st, a_version, a_part_no, a_revision));
   END f_TransferSpcAllStGk;

   FUNCTION f_TransferSpcPp(
      a_Pp             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_pp_key1        IN     VARCHAR2,
      a_pp_key2        IN     VARCHAR2,
      a_pp_key3        IN     VARCHAR2,
      a_pp_key4        IN     VARCHAR2,
      a_pp_key5        IN     VARCHAR2,
      a_effective_from IN     DATE,
      a_Description    IN     VARCHAR2,
      a_Template       IN     VARCHAR2 DEFAULT NULL,
      a_property_group IN     VARCHAR2,
      a_newminor       IN     CHAR
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      --  Transfer a parameter profile from Interspec to Unilab
      -- ** Parameters **
      -- a_pp             : parameterprofile to transfer
      -- a_version        : version of the parameterprofile
      -- a_pp_key1        : pp_key1 of the parameterprofile
      -- a_pp_key2        : pp_key2 of the parameterprofile
      -- a_pp_key3        : pp_key3 of the parameterprofile
      -- a_pp_key4        : pp_key4 of the parameterprofile
      -- a_pp_key5        : pp_key5 of the parameterprofile
      -- a_effective_from : effective_from date of the parameterprofile
      -- a_description    : description of the parameterprofile
      -- a_template       : template for the parameterprofile
      -- a_property_group : property group from which the parameterprofile has been derived
      -- a_newminor       : flag indicating if a new minor version has to be created to save modified used objects
      -- ** Return **
      -- TRUE  : The transfer of the parameter profile has succeeded.
      -- FALSE : The transfer of the parameter profile has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcPp';
      l_object       VARCHAR2(255);

      -- General variables
      l_a_Template             VARCHAR2(20);
      l_a_Template_version     VARCHAR2(20);
      l_a_Template_pp_key1     VARCHAR2(20);
      l_a_Template_pp_key2     VARCHAR2(20);
      l_a_Template_pp_key3     VARCHAR2(20);
      l_a_Template_pp_key4     VARCHAR2(20);
      l_a_Template_pp_key5     VARCHAR2(20);
      l_a_description          VARCHAR2(40);

      -- Specific local variables for the 'GetParameterProfile' API
      l_return_value_get       INTEGER;
      l_return_value_get_Tmp   INTEGER;
      l_nr_of_rows             NUMBER                            DEFAULT NULL;
      l_where_clause           VARCHAR2(255);
      l_pp_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_version_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_version_is_current_tab UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_effective_from_tab     UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_effective_till_tab     UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_description_tab        UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_description2_tab       UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_unit_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_format_tab             UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_confirm_assign_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_allow_any_pr_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_never_create_methods_tab UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_delay_tab              UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_delay_unit_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_is_template_tab        UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_sc_lc_tab              UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_sc_lc_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_pp_class_tab           UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_log_hs_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_allow_modify_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_active_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_lc_tab                 UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;
      l_lc_version_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_ss_tab                 UNAPIGEN.VC2_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'CopyParameterProfile' API
      l_return_value_copy       INTEGER;
      l_return_value_deletepppr BOOLEAN;

      -- Specific local variables for the 'SaveParameterProfile' API
      l_return_value_save      INTEGER;
      l_pp                     VARCHAR2(20);
      l_version                VARCHAR2(20);
      l_pp_key1                VARCHAR2(20);
      l_pp_key2                VARCHAR2(20);
      l_pp_key3                VARCHAR2(20);
      l_pp_key4                VARCHAR2(20);
      l_pp_key5                VARCHAR2(20);
      l_version_is_current     CHAR(1);
      l_effective_from         DATE;
      l_effective_till         DATE;
      l_description            VARCHAR2(40);
      l_description2           VARCHAR2(40);
      l_unit                   VARCHAR2(20);
      l_format                 VARCHAR2(40);
      l_confirm_assign         CHAR(1);
      l_allow_any_pr           CHAR(1);
      l_never_create_methods   CHAR(1);
      l_delay                  NUMBER;
      l_delay_unit             VARCHAR2(20);
      l_is_template            CHAR(1);
      l_sc_lc                  VARCHAR2(2);
      l_sc_lc_version          VARCHAR2(20);
      l_inherit_au             CHAR(1);
      l_pp_class               VARCHAR2(2);
      l_log_hs                 CHAR(1);
      l_lc                     VARCHAR2(2);
      l_lc_version             VARCHAR2(20);
      l_modify_reason          VARCHAR2(255);

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_pp_lc                  VARCHAR2(2);
      l_pp_lc_version          VARCHAR2(20);
      l_pp_ss                  VARCHAR2(2);
      l_pp_Log_hs              CHAR(1);
      l_pp_allow_modify        CHAR(1);
      l_pp_active              CHAR(1);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_pp||' | '||a_version, a_description, 'template='||a_template, PA_LIMS.c_Msg_Started);
      PA_LIMS.p_Trace(l_classname, l_method, a_pp_key1||' | '||a_pp_key2, a_pp_key3||' | '||a_pp_key4,
                      a_pp_key5||' | '||a_newminor, a_effective_from||' | '||a_property_group);
     
      l_a_Template := a_Template;
      l_a_description := SUBSTR(a_description, 1, 40);
      -- Initializing variables
      l_object := 'parameterprofile "'||a_Pp||'" | version='||a_version||' | pp_keys="'||a_pp_key1||'"#"'||a_pp_key2||'"#"'||
                  a_pp_key3||'"#"'||a_pp_key4||'"#"'||a_pp_key5||'" | description="'||l_a_description||'"';
      
      -- Fill in the parameters to get the standard attributes of the parameterprofile
      l_where_clause := 'WHERE pp='''||REPLACE(a_pp,'''','''''')||''' AND version='''||a_version||
                        ''' AND pp_key1='''||REPLACE(a_pp_key1,'''','''''')||
                        ''' AND pp_key2='''||REPLACE(a_pp_key2,'''','''''')||
                        ''' AND pp_key3='''||REPLACE(a_pp_key3,'''','''''')||
                        ''' AND pp_key4='''||REPLACE(a_pp_key4,'''','''''')||
                        ''' AND pp_key5='''||REPLACE(a_pp_key5,'''','''''')||
                        ''' ORDER BY pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, version';
      -- Get the standard attributes of the parameterprofile
      l_return_value_get := UNAPIPP.GETPARAMETERPROFILE@LNK_LIMS(l_pp_tab, l_pp_version_tab, l_pp_key1_tab,
                               l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_version_is_current_tab,
                               l_effective_from_tab, l_effective_till_tab, l_description_tab, l_description2_tab,
                               l_unit_tab, l_format_tab, l_confirm_assign_tab, l_allow_any_pr_tab, 
                               l_never_create_methods_tab, l_delay_tab, l_delay_unit_tab, l_is_template_tab, l_sc_lc_tab,
                               l_sc_lc_version_tab, l_inherit_au_tab, l_pp_class_tab, l_log_hs_tab, l_allow_modify_tab,
                               l_active_tab, l_lc_tab, l_lc_version_tab, l_ss_tab, l_nr_of_rows, l_where_clause);
      --PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Get pp for '||l_where_clause||'#ret_code='||l_return_value_get);
      -- Check if the parameterprofile exists in Unilab. 
      -- If the parameterprofile is not found then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- Check if the parameterprofile must be based on a template
         --PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'template '||l_a_Template);
         IF NOT l_a_Template IS NULL THEN
            -- Fill in the parameters to get the standard attributes of the parameterprofile template
            l_where_clause := l_a_template;
            -- Get the standard attributes of the parameterprofile template
            l_return_value_get_Tmp := UNAPIPP.GETPARAMETERPROFILE@LNK_LIMS(l_pp_tab, l_pp_version_tab, l_pp_key1_tab,
                                         l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, 
                                         l_version_is_current_tab, l_effective_from_tab, l_effective_till_tab,
                                         l_description_tab, l_description2_tab, l_unit_tab, l_format_tab, 
                                         l_confirm_assign_tab, l_allow_any_pr_tab, l_never_create_methods_tab,
                                         l_delay_tab, l_delay_unit_tab, l_is_template_tab, l_sc_lc_tab, l_sc_lc_version_tab,
                                         l_inherit_au_tab, l_pp_class_tab, l_log_hs_tab, l_allow_modify_tab,
                                         l_active_tab, l_lc_tab, l_lc_version_tab, l_ss_tab, l_nr_of_rows, l_where_clause);
            -- The template doesn't exist
            IF l_return_value_get_Tmp <> PA_LIMS.DBERR_SUCCESS THEN
               -- The parameterprofile will not be transferred
               IF PA_LIMS.f_GetSettingValue('TMP Master PP') = 1 THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'The parameterprofile template "'||a_Template||'" doesn''t exist. (The '||l_object||
                                ' is not transferred.)');
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               -- The parameterprofile will be transferred
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'The parameterprofile template "'||a_Template||'" doesn''t exist. (The '||l_object||
                                ' is transferred.)');
                  l_a_Template := NULL;
               END IF;
            ELSE
               -- Fill in the parameters to save the standard attributes of the parameterprofile
               -- if there is a parameterprofile template
               l_a_Template_version   := l_pp_version_tab(l_nr_of_rows);               
               l_a_Template_pp_key1   := l_pp_key1_tab(l_nr_of_rows);               
               l_a_Template_pp_key2   := l_pp_key2_tab(l_nr_of_rows);               
               l_a_Template_pp_key3   := l_pp_key3_tab(l_nr_of_rows);               
               l_a_Template_pp_key4   := l_pp_key4_tab(l_nr_of_rows);               
               l_a_Template_pp_key5   := l_pp_key5_tab(l_nr_of_rows);               
               l_version_is_current   := NULL;
               l_effective_till       := TO_DATE(l_effective_from_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat);
               l_description          := NVL(l_a_Description, l_description_tab(l_nr_of_rows));
               l_description2         := l_description2_tab(l_nr_of_rows);
               l_unit                 := l_unit_tab(l_nr_of_rows);
               l_format               := l_format_tab(l_nr_of_rows);
               l_confirm_assign       := l_confirm_assign_tab(l_nr_of_rows);
               l_allow_any_pr         := l_allow_any_pr_tab(l_nr_of_rows);
               l_never_create_methods := l_never_create_methods_tab(l_nr_of_rows);
               l_delay                := l_delay_tab(l_nr_of_rows);
               l_delay_unit           := l_delay_unit_tab(l_nr_of_rows);
               l_is_template          := '0';
               l_sc_lc                := l_sc_lc_tab(l_nr_of_rows);
               l_sc_lc_version        := l_sc_lc_version_tab(l_nr_of_rows);
               l_inherit_au           := l_inherit_au_tab(l_nr_of_rows);
               l_pp_class             := l_pp_class_tab(l_nr_of_rows);
               l_log_hs               := l_log_hs_tab(l_nr_of_rows);
               l_lc                   := l_lc_tab(l_nr_of_rows);
               l_lc_version           := l_lc_version_tab(l_nr_of_rows);
               l_modify_reason        := 'Imported parameter profile "'||a_pp||'" from Interspec (template : '||
                                         l_a_Template||').';
                --PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Template pp found:pp='||l_a_Template||'#version='||l_a_Template_version||'#pp_key1='||l_a_Template_pp_key1||
                --                '#pp_key2='||l_a_Template_pp_key2||'#pp_key3='||l_a_Template_pp_key3||'#pp_key4='||l_a_Template_pp_key4||'#pp_key5='||l_a_Template_pp_key5);
            END IF;
         END IF;

         -- Check if the default values for the parameterprofiles have to be set
         IF l_a_Template IS NULL THEN
            -- Fill in the parameters to save the standard attributes of the parameterprofile
            -- if there is no parameterprofile template
            l_version_is_current   := NULL;
            l_effective_till       := NULL;
            l_description          := l_a_Description;
            l_unit                 := '';
            l_format               := 'R0.01';
            l_confirm_assign       := '1';
            l_allow_any_pr         := '1';
            l_never_create_methods := '0';
            l_delay                := 0;
            l_delay_unit           := 'DD';
            l_is_template          := '0';
            l_sc_lc                := '';
            l_sc_lc_version        := '';
            l_inherit_au           := '1';
            l_pp_class             := '';
            l_log_hs               := '1';
            l_modify_reason        := 'Imported parameter profile "'||a_pp||'" from Interspec (no template has been used).';
         END IF;
         -- The parameterprofile template lifecycle OR the parameterprofile template itself is empty 
         -- => take default lc
         IF l_lc IS NULL THEN
            BEGIN
               SELECT uvobjects.def_lc, uvlc.version
               INTO l_lc, l_lc_version 
               FROM UVOBJECTS@LNK_LIMS, UVLC@LNK_LIMS
               WHERE uvobjects.object = 'pp'
               AND   uvobjects.def_lc = uvlc.lc
               AND   uvlc.version_is_current = '1';
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'No current version found for the default parameterprofile lifecycle.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END;
         END IF;
         -- Fill in the parameters to save the standard attributes of the parameterprofile
         l_pp            := a_pp;
         l_version       := a_version;
         l_pp_key1       := a_pp_key1;
         l_pp_key2       := a_pp_key2;
         l_pp_key3       := a_pp_key3;
         l_pp_key4       := a_pp_key4;
         l_pp_key5       := a_pp_key5;
         l_effective_from:= a_effective_from;
         BEGIN
            --copy from template when template available and global setting set
            IF PA_LIMS.g_use_template_details = '1' AND
               l_a_Template IS NOT NULL AND
               l_a_Template_version IS NOT NULL AND
               l_a_Template_pp_key1 IS NOT NULL AND
               l_a_Template_pp_key2 IS NOT NULL AND
               l_a_Template_pp_key3 IS NOT NULL AND
               l_a_Template_pp_key4 IS NOT NULL AND
               l_a_Template_pp_key5 IS NOT NULL THEN
               l_return_value_copy := UNAPIPP.CopyParameterProfile@LNK_LIMS(l_a_Template, l_a_Template_version, l_a_Template_pp_key1, l_a_Template_pp_key2, l_a_Template_pp_key3, l_a_Template_pp_key4, l_a_Template_pp_key5,
                                      l_pp, l_version, l_pp_key1, l_pp_key2, l_pp_key3, l_pp_key4, l_pp_key5, '');
               --PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'CopyPp for '||l_object||'#ret_code='||l_return_value_copy);
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
                  --Delete all records of pppr and ppprau for that pp
                  --These entries will be used only when transfering the pppr entries to determine the assignement frequencies
                  l_return_value_deletepppr := f_DeleteAllPpPr(l_pp, l_version, l_pp_key1, l_pp_key2, l_pp_key3, l_pp_key4, l_pp_key5);
                  IF l_return_value_deletepppr <> TRUE THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to delete all pppr entries for '||l_object);
                  END IF;               
               END IF;
            END IF;
            -- Save the standard attributes of the parameterprofile
            l_return_value_save := UNAPIPP.SAVEPARAMETERPROFILE@LNK_LIMS(l_pp, l_version, l_pp_key1, l_pp_key2, l_pp_key3,
                                      l_pp_key4, l_pp_key5, l_version_is_current, l_effective_from, l_effective_till,
                                      l_description, l_description2, l_unit, l_format, l_confirm_assign, l_allow_any_pr,
                                      l_never_create_methods, l_delay, l_delay_unit, l_is_template, l_sc_lc, l_sc_lc_version,
                                      l_inherit_au, l_pp_class, l_log_hs, l_lc, l_lc_version, l_modify_reason);
            --PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'SavePp for '||l_object||'#ret_code='||l_return_value_save);
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

            --Add an event in the event buffer to be sent at the end of the transfer
            PA_LIMS.g_evbuff_nr_of_rows := PA_LIMS.g_evbuff_nr_of_rows+1;
            PA_LIMS.g_evbufftab_object_tp(PA_LIMS.g_evbuff_nr_of_rows) := 'pp';
            PA_LIMS.g_evbufftab_object_id(PA_LIMS.g_evbuff_nr_of_rows) := l_pp;
            PA_LIMS.g_evbufftab_ev_details(PA_LIMS.g_evbuff_nr_of_rows) := 'version='||l_version||'#pp_key1='||l_pp_key1||'#pp_key2='||l_pp_key2||
                      '#pp_key3='||l_pp_key3||'#pp_key4='||l_pp_key4||'#pp_key5='||l_pp_key5||'#sub_ev_tp=TransferCompleted';

            -- Append an attribute with value = interspec id of the property group
            IF NOT f_TransferSpcPpAu(a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5, 
                                     PA_LIMS.c_au_orig_name, a_property_group) THEN
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
      -- When the parameterprofile is already in Unilab, it must be checked if it has been updated
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         -- Check if the description has been updated. This has only to be checked if the newminor flag is '0', 
         -- because in the other case the description parameter has not been set.
         IF (a_newminor = '0') AND
            (PA_LIMS_SPECX_TOOLS.COMPARE_DATE(a_effective_from,TO_DATE(l_effective_from_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat))=1 OR
             a_effective_from IS NULL) AND
            (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_a_Description,l_description_tab(l_nr_of_rows))=1 OR l_a_description IS NULL) THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Nothing happened: '||PA_LIMS.c_Msg_Ended);
            RETURN (TRUE);
         END IF;

         BEGIN
            -- Get the authorisation of the parameterprofile
            l_ret_code := UNAPIPPP.GETPPAUTHORISATION@LNK_LIMS(a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3,
                                                               a_pp_key4, a_pp_key5, l_pp_lc, l_pp_lc_version, l_pp_ss,
                                                               l_pp_allow_modify, l_pp_active, l_pp_Log_hs);
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
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted );
               RETURN (FALSE);
            -- Check if a new minor version has to be created to save modified used objects
            ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
               -- Fill in the parameters to save the standard attributes of the parameterprofile
               l_pp                   := a_pp;
               l_version              := NULL;
               l_pp_key1              := a_pp_key1;
               l_pp_key2              := a_pp_key2;
               l_pp_key3              := a_pp_key3;
               l_pp_key4              := a_pp_key4;
               l_pp_key5              := a_pp_key5;
               l_modify_reason        := 'Imported a new version of parameter profile "'||a_Pp||'" from Interspec.';
               -- Create a new minor version of the parameterprofile
               l_return_value_save :=
                     UNAPIPP.COPYPARAMETERPROFILE@LNK_LIMS(a_pp, a_version, a_pp_key1, a_pp_key2, 
                                                           a_pp_key3, a_pp_key4, a_pp_key5, 
                                                           l_pp, l_version, l_pp_key1, l_pp_key2, l_pp_key3,
                                                           l_pp_key4, l_pp_key5, l_modify_reason);
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
               -- Fill in the parameters to save the standard attributes of the parameterprofile
               l_pp                   := a_pp;
               l_version              := a_version;
               l_pp_key1              := a_pp_key1;
               l_pp_key2              := a_pp_key2;
               l_pp_key3              := a_pp_key3;
               l_pp_key4              := a_pp_key4;
               l_pp_key5              := a_pp_key5;
               l_version_is_current   := NULL;
               l_effective_from       := NVL(a_effective_from,
                                           TO_DATE(l_effective_from_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat));
               l_effective_till       := TO_DATE(l_effective_till_tab(l_nr_of_rows),PA_LIMS.f_GetDateFormat);
               l_description          := NVL(l_a_Description, l_description_tab(l_nr_of_rows));
               l_description2         := l_description2_tab(l_nr_of_rows);
               l_unit                 := l_unit_tab(l_nr_of_rows);
               l_format               := l_format_tab(l_nr_of_rows);
               l_confirm_assign       := l_confirm_assign_tab(l_nr_of_rows);
               l_allow_any_pr         := l_allow_any_pr_tab(l_nr_of_rows);
               l_never_create_methods := l_never_create_methods_tab(l_nr_of_rows);
               l_delay                := l_delay_tab(l_nr_of_rows);
               l_delay_unit           := l_delay_unit_tab(l_nr_of_rows);
               l_is_template          := '0';
               l_sc_lc                := l_sc_lc_tab(l_nr_of_rows);
               l_sc_lc_version        := l_sc_lc_version_tab(l_nr_of_rows);
               l_inherit_au           := l_inherit_au_tab(l_nr_of_rows);
               l_pp_class             := l_pp_class_tab(l_nr_of_rows);
               l_log_hs               := l_log_hs_tab(l_nr_of_rows);
               l_lc                   := l_lc_tab(l_nr_of_rows);
               l_lc_version           := l_lc_version_tab(l_nr_of_rows);
               l_modify_reason        := 'Imported modified standard attributes of parameter profile "'||a_pp||
                                         '" from Interspec.';
               BEGIN
                  -- Save the standard attributes of the parameterprofile
                  l_return_value_save := UNAPIPP.SAVEPARAMETERPROFILE@LNK_LIMS(l_pp, l_version, l_pp_key1, l_pp_key2,
                                            l_pp_key3, l_pp_key4, l_pp_key5, l_version_is_current, l_effective_from,
                                            l_effective_till, l_description, l_description2, l_unit, l_format, 
                                            l_confirm_assign, l_allow_any_pr, l_never_create_methods, l_delay,
                                            l_delay_unit, l_is_template, l_sc_lc, l_sc_lc_version, l_inherit_au,
                                            l_pp_class, l_log_hs, l_lc, l_lc_version, l_modify_reason);
                  -- If the error is a general failure then the SQLERRM must be logged, otherwise
                  -- the error code is the Unilab error
                  IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
                     IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to save the modified standard attributes of '||l_object||
                                      ' (General failure! Error Code: '||l_return_value_save||
                                      ' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
                     ELSE
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to save the modified standard attributes of '||l_object||' (Error code : '||
                                      l_return_value_save||').');
                     END IF;
                     
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
                  END IF;
                  --Add an event in the event buffer to be sent at the end of the transfer
                  PA_LIMS.g_evbuff_nr_of_rows := PA_LIMS.g_evbuff_nr_of_rows+1;
                  PA_LIMS.g_evbufftab_object_tp(PA_LIMS.g_evbuff_nr_of_rows) := 'pp';
                  PA_LIMS.g_evbufftab_object_id(PA_LIMS.g_evbuff_nr_of_rows) := l_pp;
                  PA_LIMS.g_evbufftab_ev_details(PA_LIMS.g_evbuff_nr_of_rows) := 'version='||l_version||'#pp_key1='||l_pp_key1||'#pp_key2='||l_pp_key2||
                            '#pp_key3='||l_pp_key3||'#pp_key4='||l_pp_key4||'#pp_key5='||l_pp_key5||'#sub_ev_tp=TransferCompleted';
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
      PA_LIMS.p_Trace(l_classname, l_method, a_pp||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring '||l_object||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcPp;

   PROCEDURE InitStPpAssignFreqFromTemplate(
      a_template_st              IN     VARCHAR2,
      a_pp                       IN     VARCHAR2,
      a_pp_key1                  IN     VARCHAR2,
      a_pp_key2                  IN     VARCHAR2,
      a_pp_key3                  IN     VARCHAR2, 
      a_pp_key4                  IN     VARCHAR2, 
      a_pp_key5                  IN     VARCHAR2,
      a_freq_tp                  OUT    CHAR,
      a_freq_val                 OUT    NUMBER,
      a_freq_unit                OUT    VARCHAR2,
      a_invert_freq              OUT    CHAR,
      a_last_sched               OUT    DATE,
      a_last_cnt                 OUT    NUMBER, 
      a_last_val                 OUT    VARCHAR2,
      a_inherit_au               OUT    CHAR)
   IS
      ----------------------------------------------------------------------------------------------------------
      -- ** Purpose **
      -- Fetch stpp link from matching entry in the template st
      -- ** Note **
      -- This is a first implementation, it will first try to find a pp with the pp id (no pp_key taken into account in this release)
      -- When no matching id is found the assignment frequency of the first pp found is used
      --When the template does not contain anything hardcoded values are used (corresponding to frequency Always)
      ----------------------------------------------------------------------------------------------------------
   CURSOR l_first_matching_pp_cursor IS
      SELECT freq_tp, freq_val, freq_unit, invert_freq, last_cnt, last_val, inherit_au
      FROM uvstpp@LNK_LIMS
      WHERE (st, version) = (SELECT st, version FROM uvst@LNK_LIMS WHERE st=a_template_st AND version_is_current='1')
      AND pp= a_pp
      ORDER BY seq;
   CURSOR l_first_pp_cursor IS
      SELECT freq_tp, freq_val, freq_unit, invert_freq, last_cnt, last_val, inherit_au
      FROM uvstpp@LNK_LIMS
      WHERE (st, version) = (SELECT st, version FROM uvst@LNK_LIMS WHERE st=a_template_st AND version_is_current='1')
      ORDER BY seq;
      
   BEGIN
      IF PA_LIMS.g_use_template_details = '1' AND
         a_template_st IS NOT NULL THEN
         OPEN l_first_matching_pp_cursor;
         FETCH l_first_matching_pp_cursor
         INTO a_freq_tp, a_freq_val, a_freq_unit, a_invert_freq, a_last_cnt, a_last_val, a_inherit_au;
         
         IF l_first_matching_pp_cursor%NOTFOUND THEN
            CLOSE l_first_matching_pp_cursor;
            OPEN l_first_pp_cursor;
            FETCH l_first_pp_cursor
            INTO a_freq_tp, a_freq_val, a_freq_unit, a_invert_freq, a_last_cnt, a_last_val, a_inherit_au;
            IF l_first_pp_cursor%NOTFOUND THEN
               a_freq_tp     := 'A';
               a_freq_val    := 0;
               a_freq_unit   := 'DD';
               a_invert_freq := '0';
               a_last_cnt    := 0;
               a_last_val    := '';
               a_last_sched := NULL;
               a_inherit_au := '1';
            END IF;
            CLOSE l_first_pp_cursor;
         ELSE
            CLOSE l_first_matching_pp_cursor;
         END IF;
         --last_sched was a problem in other places of the interface, we avoid also the problem here
         a_last_sched := NULL;
      ELSE
         a_freq_tp     := 'A';
         a_freq_val    := 0;
         a_freq_unit   := 'DD';
         a_invert_freq := '0';
         a_last_cnt    := 0;
         a_last_val    := '';
         a_last_sched := NULL;
         a_inherit_au := '1';
      END IF;
   END InitStPpAssignFreqFromTemplate;

   FUNCTION f_TransferSpcStPp(
      a_st            IN     VARCHAR2,
      a_version       IN OUT VARCHAR2,
      a_pp            IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_version    IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_key1       IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_key2       IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_key3       IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_key4       IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_key5       IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows    IN     NUMBER,
      a_template_st   IN     VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer the link between the parameter profile and the sample type
      -- ** Parameters **
      -- a_st           : sampletype
      -- a_version      : version of the sampletype
      -- a_pp           : parameterprofile assigned to the sampletype
      -- a_pp_version   : version of the parameterprofile
      -- a_pp_key1      : pp_key1 of th parameterprofile
      -- a_pp_key2      : pp_key2 of th parameterprofile
      -- a_pp_key3      : pp_key3 of th parameterprofile
      -- a_pp_key4      : pp_key4 of th parameterprofile
      -- a_pp_key5      : pp_key5 of th parameterprofile
      -- a_nr_of_rows   : number of parameterprofiles to save
      -- a_template_st  : template sample type
      -- ** Return **
      -- TRUE  : The transfer of the link has succeeded.
      -- FALSE : The transfer of the link has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcStPp';
      l_object       VARCHAR2(255);

      -- General variables
      l_version             VARCHAR2(20);
      l_insert              BOOLEAN                             DEFAULT FALSE;
      l_newminor            BOOLEAN                             DEFAULT FALSE;
      l_modified            BOOLEAN                             DEFAULT FALSE;
      l_already_assigned    BOOLEAN                             DEFAULT FALSE;
      l_remove_tab          UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      
      -- Specific local variables for the 'GetStParameterProfile' API
      -- BUG !!!
      -- When declaring l_nr_of_rows to NULL,
      -- db-api UNAPIST.GetStParameterProfile fetches always 100 (default_chunk_size) rows !
      -- SOLUTION: l_nr_of_rows := 999;
      l_return_value_get    NUMBER;
      l_number              NUMBER := 999;
      l_next_rows           NUMBER;
      l_where_clause        VARCHAR2(255);

      l_get_nr_of_rows          NUMBER;
      l_get_st_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_get_st_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_get_pp_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_get_pp_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_get_pp_key1_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_get_pp_key2_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_get_pp_key3_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_get_pp_key4_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_get_pp_key5_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_get_description_tab     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_get_freq_tp_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_get_freq_val_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_get_freq_unit_tab       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_get_invert_freq_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_get_last_sched_tab      UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_get_last_cnt_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_get_last_val_tab        UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_get_inherit_au_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      
      l_nr_of_rows          NUMBER;
      l_st_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_st_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_description_tab     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_freq_tp_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_val_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_unit_tab       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_invert_freq_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_last_sched_tab      UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_last_cnt_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_last_val_tab        UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'SaveStParameterProfile' API
      l_return_value_save   NUMBER;
      l_nr_of_rows_save     NUMBER;
      l_modify_reason       VARCHAR2(255);

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
      PA_LIMS.p_Trace(l_classname, l_method, a_St||' | '||a_version, a_nr_of_rows, NULL, PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'sample type "'||a_st||'" | version='||a_version;
      l_nr_of_rows_save := 0;

      -- Fill in the parameters to get the standard attributes of the link
      -- between the parameterprofiles and the sample type
      l_nr_of_rows     := 0;
      l_where_clause   := 'WHERE st='''||REPLACE(a_st,'''','''''')||''' AND version = '''||
                          a_version||''' ORDER BY seq';
      l_next_rows      := 0;
      l_get_nr_of_rows := l_number;
      -- Get the standard attributes of the link between the parameterprofiles and the sampletype.
      l_return_value_get := UNAPIST.GETSTPARAMETERPROFILE@LNK_LIMS(l_get_st_tab, l_get_st_version_tab, l_get_pp_tab, 
                               l_get_pp_version_tab, l_get_pp_key1_tab, l_get_pp_key2_tab, l_get_pp_key3_tab, 
                               l_get_pp_key4_tab, l_get_pp_key5_tab, l_get_description_tab, l_get_freq_tp_tab, 
                               l_get_freq_val_tab, l_get_freq_unit_tab, l_get_invert_freq_tab, l_get_last_sched_tab,
                               l_get_last_cnt_tab, l_get_last_val_tab, l_get_inherit_au_tab, l_get_nr_of_rows, 
                               l_where_clause, l_next_rows);
      -- Check if a link between property groups and the specification exists in Unilab.
      -- If no link is found, then it must be created
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- When there are no records found, l_get_nr_of_rows=100. That's why it is reset to 0.
         l_get_nr_of_rows := 0;
      ELSIF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         FOR l_row IN 1..l_get_nr_of_rows LOOP
            l_nr_of_rows := l_nr_of_rows + 1;
            l_st_tab(l_nr_of_rows)           := l_get_st_tab(l_row);
            l_st_version_tab(l_nr_of_rows)   := l_get_st_version_tab(l_row);
            l_pp_tab(l_nr_of_rows)           := l_get_pp_tab(l_row);
            l_pp_version_tab(l_nr_of_rows)   := l_get_pp_version_tab(l_row);
            l_pp_key1_tab(l_nr_of_rows)      := l_get_pp_key1_tab(l_row);
            l_pp_key2_tab(l_nr_of_rows)      := l_get_pp_key2_tab(l_row);
            l_pp_key3_tab(l_nr_of_rows)      := l_get_pp_key3_tab(l_row);
            l_pp_key4_tab(l_nr_of_rows)      := l_get_pp_key4_tab(l_row);
            l_pp_key5_tab(l_nr_of_rows)      := l_get_pp_key5_tab(l_row);
            l_description_tab(l_nr_of_rows)  := l_get_description_tab(l_row);
            l_freq_tp_tab(l_nr_of_rows)      := l_get_freq_tp_tab(l_row);
            l_freq_val_tab(l_nr_of_rows)     := l_get_freq_val_tab(l_row);
            l_freq_unit_tab(l_nr_of_rows)    := l_get_freq_unit_tab(l_row);
            l_invert_freq_tab(l_nr_of_rows)  := l_get_invert_freq_tab(l_row);
            l_last_sched_tab(l_nr_of_rows)   := l_get_last_sched_tab(l_row);
            l_last_cnt_tab(l_nr_of_rows)     := l_get_last_cnt_tab(l_row);
            l_last_val_tab(l_nr_of_rows)     := l_get_last_val_tab(l_row);
            l_inherit_au_tab(l_nr_of_rows)   := l_get_inherit_au_tab(l_row);
         END LOOP;

         LOOP
            EXIT WHEN l_get_nr_of_rows < l_number;

            l_next_rows  := 1;
            l_get_nr_of_rows := l_number;
            l_return_value_get := UNAPIST.GETSTPARAMETERPROFILE@LNK_LIMS(l_get_st_tab, l_get_st_version_tab, l_get_pp_tab, 
                          l_get_pp_version_tab, l_get_pp_key1_tab, l_get_pp_key2_tab, l_get_pp_key3_tab, 
                          l_get_pp_key4_tab, l_get_pp_key5_tab, l_get_description_tab, l_get_freq_tp_tab, 
                          l_get_freq_val_tab, l_get_freq_unit_tab, l_get_invert_freq_tab, l_get_last_sched_tab, 
                          l_get_last_cnt_tab, l_get_last_val_tab, l_get_inherit_au_tab, l_get_nr_of_rows, 
                          l_where_clause, l_next_rows);
            IF l_return_value_get <> PA_LIMS.DBERR_SUCCESS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                  'Unable to retrieve the standard attributes of the link between the parameterprofiles and '||l_object||
                  ' (Error code : '||l_return_value_get||').');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            ELSE
               FOR l_row IN 1..l_get_nr_of_rows LOOP
                  l_nr_of_rows := l_nr_of_rows + 1;
                  l_st_tab(l_nr_of_rows)           := l_get_st_tab(l_row);
                  l_st_version_tab(l_nr_of_rows)   := l_get_st_version_tab(l_row);
                  l_pp_tab(l_nr_of_rows)           := l_get_pp_tab(l_row);
                  l_pp_version_tab(l_nr_of_rows)   := l_get_pp_version_tab(l_row);
                  l_pp_key1_tab(l_nr_of_rows)      := l_get_pp_key1_tab(l_row);
                  l_pp_key2_tab(l_nr_of_rows)      := l_get_pp_key2_tab(l_row);
                  l_pp_key3_tab(l_nr_of_rows)      := l_get_pp_key3_tab(l_row);
                  l_pp_key4_tab(l_nr_of_rows)      := l_get_pp_key4_tab(l_row);
                  l_pp_key5_tab(l_nr_of_rows)      := l_get_pp_key5_tab(l_row);
                  l_description_tab(l_nr_of_rows)  := l_get_description_tab(l_row);
                  l_freq_tp_tab(l_nr_of_rows)      := l_get_freq_tp_tab(l_row);
                  l_freq_val_tab(l_nr_of_rows)     := l_get_freq_val_tab(l_row);
                  l_freq_unit_tab(l_nr_of_rows)    := l_get_freq_unit_tab(l_row);
                  l_invert_freq_tab(l_nr_of_rows)  := l_get_invert_freq_tab(l_row);
                  l_last_sched_tab(l_nr_of_rows)   := l_get_last_sched_tab(l_row);
                  l_last_cnt_tab(l_nr_of_rows)     := l_get_last_cnt_tab(l_row);
                  l_last_val_tab(l_nr_of_rows)     := l_get_last_val_tab(l_row);
                  l_inherit_au_tab(l_nr_of_rows)   := l_get_inherit_au_tab(l_row);
               END LOOP;
            END IF;
         END LOOP;
      
         l_next_rows      := -1;
         l_return_value_get := UNAPIST.GETSTPARAMETERPROFILE@LNK_LIMS(l_get_st_tab, l_get_st_version_tab, l_get_pp_tab, 
                          l_get_pp_version_tab, l_get_pp_key1_tab, l_get_pp_key2_tab, l_get_pp_key3_tab, 
                          l_get_pp_key4_tab, l_get_pp_key5_tab, l_get_description_tab, l_get_freq_tp_tab, 
                          l_get_freq_val_tab, l_get_freq_unit_tab, l_get_invert_freq_tab, l_get_last_sched_tab, 
                          l_get_last_cnt_tab, l_get_last_val_tab, l_get_inherit_au_tab, l_get_nr_of_rows, 
                          l_where_clause, l_next_rows);
         IF l_return_value_get <> PA_LIMS.DBERR_SUCCESS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
               'Unable to retrieve the standard attributes of the link between the parameterprofiles and '||l_object||
               ' (Error code : '||l_return_value_get||').');
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
      
         -- PRINCIPLE: This is some code very special for linked specifications.
         -- Because the parameterprofile version on the link is <x>.*, old versions
         -- stay assigned and have to be removed. All old parameterprofiles (coming from 
         -- an old revision of this linked specification, not the other parameterprofiles) 
         -- will be removed, and all new parameterprofiles (coming from this 
         -- linked specification) will be added.
         -- This is only for linked specifications, because for normal or generic specifications
         -- the parameterprofiles are newly assigned to each new sampletype.
         --
         -- Mark the old linked parameterprofiles, because they have to be removed
         FOR l_row IN 1..l_nr_of_rows LOOP
            -- Initialize variable
            l_remove_tab(l_row) := '0';
            -- The old linked parameterprofiles can be recognized because they have the same pp_keys as the new ones.
            -- All incoming new parameterprofiles have the same pp_keys => take the first one to compare
            IF (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_key1_tab(l_row),a_pp_key1(1)) = 1) AND
               (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_key2_tab(l_row),a_pp_key2(1)) = 1) AND
               (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_key3_tab(l_row),a_pp_key3(1)) = 1) AND
               (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_key4_tab(l_row),a_pp_key4(1)) = 1) AND
               (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_key5_tab(l_row),a_pp_key5(1)) = 1) THEN
               l_remove_tab(l_row) := '1';
            END IF;
         END LOOP;
         -- Remove the old linked parameterprofiles
         FOR l_row IN 1..l_nr_of_rows LOOP
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_remove_tab(l_row),'0') = 1 THEN
               l_nr_of_rows_save := l_nr_of_rows_save + 1;
               l_pp_tab(l_nr_of_rows_save)         := l_pp_tab(l_row);
               l_pp_version_tab(l_nr_of_rows_save) := l_pp_version_tab(l_row);
               l_pp_key1_tab(l_nr_of_rows_save)    := l_pp_key1_tab(l_row);
               l_pp_key2_tab(l_nr_of_rows_save)    := l_pp_key2_tab(l_row);
               l_pp_key3_tab(l_nr_of_rows_save)    := l_pp_key3_tab(l_row);
               l_pp_key4_tab(l_nr_of_rows_save)    := l_pp_key4_tab(l_row);
               l_pp_key5_tab(l_nr_of_rows_save)    := l_pp_key5_tab(l_row);
               l_freq_tp_tab(l_nr_of_rows_save)    := l_freq_tp_tab(l_row);
               l_freq_val_tab(l_nr_of_rows_save)   := l_freq_val_tab(l_row);
               l_freq_unit_tab(l_nr_of_rows_save)  := l_freq_unit_tab(l_row);
               l_invert_freq_tab(l_nr_of_rows_save):= l_invert_freq_tab(l_row);
               l_last_sched_tab(l_nr_of_rows_save) := l_last_sched_tab(l_row);
               l_last_cnt_tab(l_nr_of_rows_save)   := l_last_cnt_tab(l_row);
               l_last_val_tab(l_nr_of_rows_save)   := l_last_val_tab(l_row);
               l_inherit_au_tab(l_nr_of_rows_save) := l_inherit_au_tab(l_row);
            ELSE
               -- A new minor version only has to be created if something has been modified eg. parameterprofiles removed
               l_modified := TRUE;
            END IF;
         END LOOP;
      ELSE
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
            'Unable to retrieve the standard attributes of the link between the parameterprofiles and '||l_object||
            ' (Error code : '||l_return_value_get||').');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;
      
      IF PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(a_nr_of_rows,0) = 0 THEN
         -- A new minor version only has to be created if something has been modified eg. parameterprofiles added
         l_modified := TRUE;
      END IF;

      -- Get the authorisation of the sample type
      l_ret_code := UNAPIGEN.GETAUTHORISATION@LNK_LIMS('st', a_st, a_version, l_st_lc, l_st_lc_version, l_st_ss,
                                                       l_st_allow_modify, l_st_active, l_st_log_hs);
      IF l_ret_code = PA_LIMS.DBERR_SUCCESS THEN
         -- Modifiable, parameterprofiles can immediately be assigned
         l_insert := TRUE;
      ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
         IF l_modified THEN
            -- Not modifiable and parameterprofiles have been added/removed
            -- => new minor version has to be created before parameterprofile can be assigned
            l_newminor := TRUE;
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

      -- If the sampletype is not modifiable, a new minor version has to be created.
      -- In fact the f_TransferSpcSt evaluates if it is really necessary to create a new minor version.
      -- If not modifiable, a new minor version will be created; in the other case
      -- the given version will be modified.
      IF (l_newminor) THEN
         l_version := a_version;
         IF NOT f_TransferSpcSt(a_st, l_version, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1') THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
         a_version := l_version;
      END IF;

      IF l_modified THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the parameterprofiles and the sampletype.
         l_modify_reason                := 'Imported the link between the parameter profiles and sample type "'||
                                           a_st||'" from Interspec.';
         -- Add the new parameterprofiles
         FOR a_row IN 1..a_nr_of_rows LOOP
            l_already_assigned := FALSE;
            -- Check if the parameterprofile is not yet assigned
            FOR l_row IN 1..l_nr_of_rows_save LOOP
               IF (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_tab(l_row),a_pp(a_row)) = 1) AND 
                  (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_version_tab(l_row),a_pp_version(a_row)) = 1) AND 
                  (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_key1_tab(l_row),a_pp_key1(a_row)) = 1) AND 
                  (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_key2_tab(l_row),a_pp_key2(a_row)) = 1) AND 
                  (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_key3_tab(l_row),a_pp_key3(a_row)) = 1) AND 
                  (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_key4_tab(l_row),a_pp_key4(a_row)) = 1) AND 
                  (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_key5_tab(l_row),a_pp_key5(a_row)) = 1) THEN
                  l_already_assigned := TRUE;
                  EXIT;
               END IF;
            END LOOP;
            -- Only assign if not yet assigned
            IF NOT l_already_assigned THEN
               l_nr_of_rows_save                   := l_nr_of_rows_save + 1;
               l_pp_tab(l_nr_of_rows_save)         := a_pp(a_row);
               l_pp_version_tab(l_nr_of_rows_save) := a_pp_version(a_row);
               l_pp_key1_tab(l_nr_of_rows_save)    := a_pp_key1(a_row);
               l_pp_key2_tab(l_nr_of_rows_save)    := a_pp_key2(a_row);
               l_pp_key3_tab(l_nr_of_rows_save)    := a_pp_key3(a_row);
               l_pp_key4_tab(l_nr_of_rows_save)    := a_pp_key4(a_row);
               l_pp_key5_tab(l_nr_of_rows_save)    := a_pp_key5(a_row);
               InitStPpAssignFreqFromTemplate(a_template_st, a_pp(a_row), a_pp_key1(a_row), a_pp_key2(a_row), a_pp_key3(a_row), a_pp_key4(a_row), a_pp_key5(a_row),
                                              l_freq_tp_tab(l_nr_of_rows_save), l_freq_val_tab(l_nr_of_rows_save), l_freq_unit_tab(l_nr_of_rows_save),
                                              l_invert_freq_tab(l_nr_of_rows_save), l_last_sched_tab(l_nr_of_rows_save),
                                              l_last_cnt_tab(l_nr_of_rows_save), l_last_val_tab(l_nr_of_rows_save), l_inherit_au_tab(l_nr_of_rows_save));
               --l_freq_tp_tab(l_nr_of_rows_save)    := 'A';
               --l_freq_val_tab(l_nr_of_rows_save)   := 0;
               --l_freq_unit_tab(l_nr_of_rows_save)  := 'DD';
               --l_invert_freq_tab(l_nr_of_rows_save):= '0';
               --l_last_sched_tab(l_nr_of_rows_save) := NULL;
               --l_last_cnt_tab(l_nr_of_rows_save)   := 0;
               --l_last_val_tab(l_nr_of_rows_save)   := '';
               --l_inherit_au_tab(l_nr_of_rows_save) := '1';
            END IF;
         END LOOP;
         BEGIN
            -- Save the standard attributes of the link between the parameterprofiles and the sampletype.
            l_next_rows := -1;
            l_return_value_save := UNAPIST.SAVESTPARAMETERPROFILE@LNK_LIMS(a_st, a_version, l_pp_tab, l_pp_version_tab,
                                      l_pp_key1_tab, l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab,
                                      l_freq_tp_tab, l_freq_val_tab, l_freq_unit_tab, l_invert_freq_tab, l_last_sched_tab,
                                      l_last_cnt_tab, l_last_val_tab, l_inherit_au_tab, l_nr_of_rows_save, l_next_rows,
                                      l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the standard attributes of the link between the parameterprofiles and '||
                                l_object||' (General failure! Error Code: '||
                                l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the standard attributes of the link between the parameterprofiles and '||
                                l_object||' (Error code : '||l_return_value_save||').');
               END IF;

               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the standard attributes of the link between the parameterprofiles and '||
                             l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Nothing happened: '||PA_LIMS.c_Msg_Ended);
         RETURN (TRUE);
      END IF;
      
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_St||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring the link between the parameterprofiles and '||
                       l_object||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcStPp;

   FUNCTION f_DeleteAllStPp(
      a_st            IN     VARCHAR2,
      a_version       IN     VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Delete all stpp and stppau records
      -- ** Parameters **
      -- a_st           : sampletype
      -- a_version      : version of the sampletype
      -- ** Return **
      -- TRUE  : The transfer of the link has succeeded.
      -- FALSE : The transfer of the link has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_DeleteAllStPp';
      l_object       VARCHAR2(255);

      
      -- Specific local variables for the 'SaveStParameterProfile' API
      l_nr_of_rows_save          NUMBER := 999;
      l_next_rows           NUMBER := -1;
      l_where_clause        VARCHAR2(255);
      l_st_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_st_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_description_tab     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_freq_tp_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_val_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_unit_tab       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_invert_freq_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_last_sched_tab      UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_last_cnt_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_last_val_tab        UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_return_value_save   NUMBER;
      l_modify_reason       VARCHAR2(255);

   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_St||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'sample type "'||a_st||'" | version='||a_version;
      l_nr_of_rows_save := 0;

      BEGIN
         -- Save the standard attributes of the link between the parameterprofiles and the sampletype.
         l_return_value_save := UNAPIST.SAVESTPARAMETERPROFILE@LNK_LIMS(a_st, a_version, l_pp_tab, l_pp_version_tab,
                                   l_pp_key1_tab, l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab,
                                   l_freq_tp_tab, l_freq_val_tab, l_freq_unit_tab, l_invert_freq_tab, l_last_sched_tab,
                                   l_last_cnt_tab, l_last_val_tab, l_inherit_au_tab, l_nr_of_rows_save, l_next_rows,
                                   l_modify_reason);
         -- If the error is a general failure then the SQLERRM must be logged, otherwise
         -- the error code is the Unilab error
         IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
            IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the standard attributes of the link between the parameterprofiles and '||
                             l_object||' (General failure! Error Code: '||
                             l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
            ELSE
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to save the standard attributes of the link between the parameterprofiles and '||
                             l_object||' (Error code : '||l_return_value_save||').');
            END IF;

            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
         RETURN (TRUE);
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to save the standard attributes of the link between the parameterprofiles and '||
                          l_object||' : '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unexpected error when transferring the link between the parameterprofiles and '||
                       l_object||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_DeleteAllStPp;

   FUNCTION f_TransferSpcAllPpAndStPp(
      a_St                    IN     VARCHAR2,
      a_version               IN OUT VARCHAR2,
      a_sh_revision           IN     NUMBER,
      a_Part_No               IN     specification_header.part_no%TYPE,
      a_Revision              IN     specification_header.revision%TYPE,
      a_effective_from        IN     DATE,
      a_template_st           IN     VARCHAR2     
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      
      -- The links between property groups and specifications are links between 
      -- parameterprofiles and sampletypes in Unilab. The function
      -- transfers all parameterprofiles AND all links to Unilab if they have 
      -- the following characteristics:
      --    - The property group is used in the specification.
      --    - The property group has at least one property
      --    - A display format that is set up for LIMS is assigned to the
      --      property group of the specification.
      --    - There are fields of the display format configured as specification data
      --      or as user attributes of the parameterprofile
      -- ** Parameters **
      -- a_st               : sampletype
      -- a_version          : version of the sampletype
      -- a_sh_revision      : revision of the specification, to base the parameterprofile version on
      -- a_part_no          : part_no of the specification
      -- a_revision         : revision of the specification
      -- a_effective_from   : effective_from date of the parameterprofile
      -- ** Return **
      -- TRUE  : The transfer has succeeded
      -- FALSE : The transfer has failed.
      -- ** Remarks
      -- JB   28/05/2001  cursor 'l_PpToTransfer_Cursor' extended
      --                  check if property_group has properties in table SPECIFICATION_PROP
      --                  for this specification
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcAllPpAndStPp';

      -- General variables
      l_PpID               VARCHAR2(20);
      l_pp_version         VARCHAR2(20);
      l_pp_desc            VARCHAR2(40);
      l_pg_revision        NUMBER;
      l_Template           VARCHAR2(20);
      l_linked_part_no     specification_header.part_no%TYPE;
      l_pp_tab             UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_version_tab     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab        UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_nr_of_rows         NUMBER;

      -- Cursor to get all the property groups that have to be send to Unilab as a parameterprofile
      CURSOR l_PpToTransfer_Cursor(
         c_Part_No    specification_header.part_no%TYPE,
         c_Revision   specification_header.revision%TYPE
      )
      IS
         SELECT DISTINCT sps.ref_id, sps.ref_ver, sps.section_id,
                         sps.sub_section_id, limsc.layout_id,
                         sps.section_sequence_no
                    FROM specification_prop spp,
                         itlimsconfly limsc,
                         specification_section sps
                   WHERE spp.property_group = sps.ref_id
                     AND spp.part_no = sps.part_no
                     AND spp.revision = sps.revision
                     AND spp.section_id = sps.section_id
                     AND spp.sub_section_id = sps.sub_section_id
                     AND sps.part_no = c_Part_No
                     AND sps.revision = c_Revision
                     AND sps.type = 1
                     AND sps.display_format = limsc.layout_id
                     AND sps.display_format_rev = limsc.layout_rev
                     AND limsc.un_object IN ('PR', 'PPPR')
                   ORDER BY sps.section_sequence_no;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_St||' | '||a_version||' | '||a_sh_revision, a_part_no||' | '||a_revision,
                      a_effective_from, PA_LIMS.c_Msg_Started);

      -- Set the table index
      l_nr_of_rows := 0;
      -- Transfer all the parameterprofiles AND 
      -- the links between the parameterprofiles and the sampletypes to Unilab
      -- ****************************************************************
      -- 05/11/2002
      -- Propertygroups to transfer will be ordered by Interspec sequence
      FOR l_PpToTransfer_Rec IN l_PpToTransfer_Cursor(a_Part_No, a_Revision) LOOP
         BEGIN
            -- Generate the parameterprofile id, version and description, 
            -- based on the highest revision of the property group
            l_pg_revision := PA_LIMS.f_GetHighestRevision('property_group', l_PpToTransfer_Rec.ref_id);
            -- Only for a linked specification, the parameterprofile description should start with the part_no
            IF a_st <> a_part_no THEN
               l_linked_part_no := a_part_no;
            END IF;
            l_PpId := PA_LIMS.f_GetPpId(l_linked_part_no, l_PpToTransfer_Rec.ref_id, l_pg_revision,
                                        f_pgh_descr(1,l_PpToTransfer_Rec.ref_id,l_PpToTransfer_Rec.ref_ver), l_pp_desc);
            l_pp_version := UNVERSION.CONVERTINTERSPEC2UNILABPP@LNK_LIMS(l_ppid, PA_LIMS.g_pp_key(1), PA_LIMS.g_pp_key(2), 
                                                                         PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                                                                         PA_LIMS.g_pp_key(5), a_sh_revision);
            -- Get the template for the layouts
            l_Template := PA_LIMS.f_GetTemplate('LY', l_PpToTransfer_Rec.layout_id);

            -- Transfer the parameterprofile
            IF NOT f_TransferSpcPp(l_PpId, l_pp_version, PA_LIMS.g_pp_key(1), PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3), 
                                   PA_LIMS.g_pp_key(4), PA_LIMS.g_pp_key(5), a_effective_from, l_pp_desc, l_Template, 
                                   l_PpToTransfer_Rec.ref_id,'0') THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            ELSE
               -- Regenerate the version of the sampletype. The transfer of a parameterprofile with 
               -- pp_key Product filled in, will have caused the creation of a new minor version of the 
               -- sampletype if this sampletype was not modifiable (cfr. unapipp.SaveParameterProfile).
               a_version := UNVERSION.SQLGETHIGHESTMINORVERSION@LNK_LIMS('st', a_st, a_version);

               -- Add the parameterprofile to an array, the transfer will be done at the end.
               l_nr_of_rows := l_nr_of_rows + 1;
               l_pp_tab(l_nr_of_rows)          := l_ppid;
               -- Generate the version of the parameterprofile for the link
               l_pp_version_tab(l_nr_of_rows)  := UNVERSION.GETMAJORVERSIONONLY@LNK_LIMS(l_pp_version);
               l_pp_key1_tab(l_nr_of_rows)     := PA_LIMS.g_pp_key(1);
               l_pp_key2_tab(l_nr_of_rows)     := PA_LIMS.g_pp_key(2);
               l_pp_key3_tab(l_nr_of_rows)     := PA_LIMS.g_pp_key(3);
               l_pp_key4_tab(l_nr_of_rows)     := PA_LIMS.g_pp_key(4);
               l_pp_key5_tab(l_nr_of_rows)     := PA_LIMS.g_pp_key(5);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer parameterprofile "'||l_PpId||'" | version='||l_pp_version||
                             ' | pp_keys="'||PA_LIMS.g_pp_key(1)||'"#"'||PA_LIMS.g_pp_key(2)||'"#"'||PA_LIMS.g_pp_key(3)||
                             '"#"'||PA_LIMS.g_pp_key(4)||'"#"'||PA_LIMS.g_pp_key(5)||
                             '" or the link between parameterprofile "'||
                             l_PpId||'" | version='||l_pp_version_tab(l_nr_of_rows)||' | pp_keys="'||PA_LIMS.g_pp_key(1)||
                             '"#"'||PA_LIMS.g_pp_key(2)||'"#"'||PA_LIMS.g_pp_key(3)||'"#"'||PA_LIMS.g_pp_key(4)||'"#"'||
                             PA_LIMS.g_pp_key(5)||'" and sample type "'||a_St||'" | version='||a_version||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      END LOOP;

      -- Transfer the links between the parameterprofiles and the sampletype
      IF PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_nr_of_rows, 0) = 1 THEN
         -- Pass the pp_keys as arguments to the f_TransferSpcStPp api, to be able to identify the old parameterprofiles
         -- that have to be removed.
         l_pp_key1_tab(1) := PA_LIMS.g_pp_key(1);
         l_pp_key2_tab(1) := PA_LIMS.g_pp_key(2);
         l_pp_key3_tab(1) := PA_LIMS.g_pp_key(3);
         l_pp_key4_tab(1) := PA_LIMS.g_pp_key(4);
         l_pp_key5_tab(1) := PA_LIMS.g_pp_key(5);
      END IF;
      IF NOT f_TransferSpcStPp(a_St, a_version, l_pp_tab, l_pp_version_tab, l_pp_key1_tab, l_pp_key2_tab, 
                               l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_nr_of_rows, a_template_st) THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_St||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
            'Unable to transfer the parameterprofiles or the links between parameterprofiles and sample types for plant "'||
            PA_LIMS.f_ActivePlant||'" : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcAllPpAndStPp;

   FUNCTION f_ClearStPp(
      a_Part_No               IN     specification_header.part_no%TYPE  DEFAULT NULL,
      a_St                    IN     VARCHAR2,
      a_St_version            IN     VARCHAR2,
      a_ListOfObsoletePlants  IN     VC20_TABLE_TYPE,
      a_NrOfObsoletePlants    IN     INTEGER
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      
      -- The links between property groups and specifications are links between 
      -- parameterprofiles and sampletypes in Unilab. The function
      -- makes all parameterprofiles obsolete AND removes stpp links in Unilab if they have 
      -- the following characteristics:
      --    - The property group is used in the specification.
      --    - The property group has at least one property
      --    - A display format that is set up for LIMS is assigned to the
      --      property group of the specification.
      --    - There are fields of the display format configured as specification data
      --      or as user attributes of the parameterprofile
      -- ** Parameters **
      -- a_st               : sampletype
      -- a_version          : version of the sampletype
      -- a_sh_revision      : revision of the specification, to base the parameterprofile version on
      -- a_part_no          : part_no of the specification
      -- a_revision         : revision of the specification
      -- a_effective_from   : effective_from date of the parameterprofile
      -- ** Return **
      -- TRUE  : The transfer has succeeded
      -- FALSE : The transfer has failed.
      -- ** Remarks
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_ClearStPp';

      -- Cursor to get all the links between the parameterprofiles and the sampletype
      -- but filter out plants that are obsolete
      CURSOR l_GetStpp_Cursor(c_st VARCHAR2, c_version VARCHAR2, c_plant_seq NUMBER, c_part_no VARCHAR2, c_product_seq NUMBER)
      IS
         SELECT pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, 
                freq_tp, freq_val, freq_unit, invert_freq, last_sched, last_cnt, last_val, inherit_au,
                DECODE(c_plant_seq, 1, pp_key1, 2, pp_key2, 3, pp_key3, 4, pp_key4, 5, pp_key5, ' ') plant
           FROM UVSTPP@LNK_LIMS
          WHERE st      = c_st
            AND version = c_version
          ORDER BY seq;
          /*
            --This subquery is filtering out plants that are marked as obsolete for that part
            --only filter out product specif parameter profiles
            AND ( (DECODE(c_plant_seq, 1, pp_key1, 2, pp_key2, 3, pp_key3, 4, pp_key4, 5, pp_key5, ' ') = ' ') OR
                  (DECODE(c_plant_seq, 1, pp_key1, 2, pp_key2, 3, pp_key3, 4, pp_key4, 5, pp_key5, ' ') NOT IN
                                    (SELECT a.plant
                                       FROM itlimsplant a, part_plant pp
                                      WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                                               (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                                                  FROM itlimsplant b
                                                 WHERE b.plant = PA_LIMS.f_ActivePlant)
                                        AND a.plant = pp.plant
                                        AND pp.part_no = c_part_no
                                        AND pp.obsolete = '1')))            
          ORDER BY seq;
          */
          
      -- General variables
      l_plant_seq                  INTEGER;
      l_product_seq                INTEGER;
      l_keep_pp                    BOOLEAN;
      
      -- Specific local variables for the 'SaveStParameterProfile' API
      l_nr_of_rows                  NUMBER;
      l_return_value                NUMBER     DEFAULT 1;
      l_pp_tab                      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_version_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_freq_tp_tab                 UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_val_tab                UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_unit_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_invert_freq_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_last_sched_tab              UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_last_cnt_tab                UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_last_val_tab                UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab              UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_next_rows                   NUMBER := -1;
      l_modify_reason               VARCHAR2(255);

   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Part_No, a_St, a_St_version,  PA_LIMS.c_Msg_Started);
      --fecth 
      l_plant_seq := NULL;
      BEGIN
         SELECT seq
         INTO l_plant_seq
         FROM uvkeypp@LNK_LIMS
         WHERE key_name = 'gk.plant';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_plant_seq := NULL;
      END;
            
      IF l_plant_seq IS NULL THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'No pp_key corresponding to plant in Unilab');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         -- End the remote transaction
         IF NOT PA_LIMS.f_EndRemoteTransaction THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         END IF;
         RETURN (FALSE);      
      END IF;

      l_product_seq := NULL;
      BEGIN
         SELECT seq
         INTO l_product_seq
         FROM uvkeypp@LNK_LIMS
         WHERE key_name = 'st' AND key_tp = 'st';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_product_seq := NULL;
      END;
      
      -- Set the table index
      l_nr_of_rows := 0;
--      l_something_tobedeleted := FALSE;
      --important filtering taking place in the cursor: obsolete plant specific parameter profiles will be deleted
      FOR l_GetStPp_rec IN l_GetStpp_Cursor(a_St, a_St_version, l_plant_seq, a_part_no, l_product_seq) LOOP
         --check if the plant is obsolete
         l_keep_pp := TRUE;
         FOR l_plant_nr IN 1..a_NrOfObsoletePlants LOOP
            IF a_ListOfObsoletePlants(l_plant_nr) = l_GetStPp_rec.plant THEN
               l_keep_pp := FALSE;
               EXIT;
            END IF;
         END LOOP;

         IF l_keep_pp THEN
            l_nr_of_rows := l_nr_of_rows + 1;
            l_pp_tab (l_nr_of_rows)         := l_GetStPp_rec.pp;
            l_pp_version_tab (l_nr_of_rows) := l_GetStPp_rec.pp_version;
            l_pp_key1_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key1;
            l_pp_key2_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key2;
            l_pp_key3_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key3;
            l_pp_key4_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key4;
            l_pp_key5_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key5;
            l_freq_tp_tab (l_nr_of_rows)    := SUBSTR(l_GetStPp_rec.freq_tp,1,1);
            l_freq_val_tab (l_nr_of_rows)   := l_GetStPp_rec.freq_val;
            l_freq_unit_tab (l_nr_of_rows)  := l_GetStPp_rec.freq_unit;
            l_invert_freq_tab (l_nr_of_rows):= SUBSTR(l_GetStPp_rec.invert_freq,1,1);
            l_last_sched_tab (l_nr_of_rows) := l_GetStPp_rec.last_sched;
            l_last_cnt_tab (l_nr_of_rows)   := l_GetStPp_rec.last_cnt;
            l_last_val_tab (l_nr_of_rows)   := l_GetStPp_rec.last_val;
            l_inherit_au_tab (l_nr_of_rows) := SUBSTR(l_GetStPp_rec.inherit_au,1,1);
         END IF;
      END LOOP;
      
--      IF l_something_tobedeleted THEN
         --call savestparameterprofile with the new array
         -- Delete the link between the parameterprofiles and the sampletype
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the parameterprofiles and the sampletype.
         l_modify_reason := 'Removed the link between some parameter profiles and sample type "'||a_St||
                            '" because the plant "'||PA_LIMS.f_ActivePlant||'" became obsolete for that part.';
         BEGIN
            -- Save the standard attributes of the link between the parameterprofiles and the sampletype.
            l_return_value := UNAPIST.SAVESTPARAMETERPROFILE@LNK_LIMS(a_St, a_St_version, l_pp_tab, l_pp_version_tab,
                                 l_pp_key1_tab, l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_freq_tp_tab,
                                 l_freq_val_tab, l_freq_unit_tab, l_invert_freq_tab, l_last_sched_tab, l_last_cnt_tab,
                                 l_last_val_tab, l_inherit_au_tab, l_nr_of_rows, l_next_rows, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to remove the link between the parameterprofiles and st='||a_St||'#version='||a_St_version||
                                ' (General failure! Error Code: '||l_return_value||' Error Msg:'||
                                UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to remove the link between the parameterprofiles and st='||a_St||'#version='||a_St_version||
                                ' (Error code : '||l_return_value||').');
               END IF;

               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               -- End the remote transaction
               IF NOT PA_LIMS.f_EndRemoteTransaction THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               END IF;
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to remove the link between the parameterprofiles and st='||a_St||'#version='||a_St_version||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               -- End the remote transaction
               IF NOT PA_LIMS.f_EndRemoteTransaction THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               END IF;
               RETURN (FALSE);
         END;
--      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_St||' | '||a_St_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
            'Unable to transfer the parameterprofiles or the links between parameterprofiles and sample types for plant "'||
            PA_LIMS.f_ActivePlant||'" : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_ClearStPp;

   FUNCTION f_EnableStPp(
      a_Part_No            IN     specification_header.part_no%TYPE  DEFAULT NULL,
      a_St                 IN     VARCHAR2,
      a_St_version         IN     VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      
      -- The links between property groups and specifications are links between 
      -- parameterprofiles and sampletypes in Unilab. The function
      -- makes all parameterprofiles obsolete AND removes stpp links in Unilab if they have 
      -- the following characteristics:
      --    - The property group is used in the specification.
      --    - The property group has at least one property
      --    - A display format that is set up for LIMS is assigned to the
      --      property group of the specification.
      --    - There are fields of the display format configured as specification data
      --      or as user attributes of the parameterprofile
      -- ** Parameters **
      -- a_st               : sampletype
      -- a_version          : version of the sampletype
      -- a_sh_revision      : revision of the specification, to base the parameterprofile version on
      -- a_part_no          : part_no of the specification
      -- a_revision         : revision of the specification
      -- a_effective_from   : effective_from date of the parameterprofile
      -- ** Return **
      -- TRUE  : The transfer has succeeded
      -- FALSE : The transfer has failed.
      -- ** Remarks
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_EnableStPp';

      -- Cursor to get all the links between the parameterprofiles and the sampletype
      CURSOR l_GetStpp_Cursor(c_st VARCHAR2, c_version VARCHAR2, c_plant_seq NUMBER, c_part_no VARCHAR2, c_product_seq NUMBER)
      IS
         SELECT pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, 
                freq_tp, freq_val, freq_unit, invert_freq, last_sched, last_cnt, last_val, inherit_au, seq,
                '0' stpplist_to_extend
           FROM UVSTPP@LNK_LIMS
          WHERE st      = c_st
            AND version = c_version
         UNION
         --Reenable parameter profiles that are at least product and plant specific
         SELECT DISTINCT pp, '~Current~' pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, 
                'A' freq_tp, 1 freq_val, 'DD' freq_unit, '0' invert_freq, 
                NULL last_sched, 0 last_cnt, NULL last_val, '2' inherit_au, 1000+rownum seq,
                '1' stpplist_to_extend
           FROM UVPP@LNK_LIMS
          WHERE pp IN (SELECT DISTINCT pp 
                       FROM UVSTPP@LNK_LIMS
                       WHERE st      = c_st
                         AND version = c_version)
            --filter out the one returned by first part of query (record merge could not happen due to difference in freq info)
            AND (pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) NOT IN
                   (SELECT pp, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
                    FROM UVSTPP@LNK_LIMS
                    WHERE st      = c_st
                    AND version = c_version)
            AND version_is_current = '1'
            AND (DECODE(c_product_seq, 1, pp_key1, 2, pp_key2, 3, pp_key3, 4, pp_key4, 5, pp_key5, ' ') = c_st)
            AND (DECODE(c_plant_seq, 1, pp_key1, 2, pp_key2, 3, pp_key3, 4, pp_key4, 5, pp_key5, ' ') IN
                                    (SELECT a.plant
                                       FROM itlimsplant a, part_plant pp
                                      WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                                               (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                                                  FROM itlimsplant b
                                                 WHERE b.plant = PA_LIMS.f_ActivePlant)
                                        AND a.plant = pp.plant
                                        AND pp.part_no = c_part_no
                                        AND NVL(pp.obsolete, '0') = '0'))
          ORDER BY seq;

      -- General variables
      l_plant_seq                  INTEGER;
      l_product_seq                INTEGER;
      l_stpplist_to_extend         CHAR(1);
      
      -- Specific local variables for the 'SaveStParameterProfile' API
      l_nr_of_rows                  NUMBER;
      l_return_value                NUMBER     DEFAULT 1;
      l_pp_tab                      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_version_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_freq_tp_tab                 UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_val_tab                UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_unit_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_invert_freq_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_last_sched_tab              UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_last_cnt_tab                UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_last_val_tab                UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab              UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_next_rows                   NUMBER := -1;
      l_modify_reason               VARCHAR2(255);

   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Part_No, a_St, a_St_version,  PA_LIMS.c_Msg_Started);
      --fecth 
      l_plant_seq := NULL;
      BEGIN
         SELECT seq
         INTO l_plant_seq
         FROM uvkeypp@LNK_LIMS
         WHERE key_name = 'gk.plant';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_plant_seq := NULL;
      END;
      
      IF l_plant_seq IS NULL THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'No pp_key corresponding to plant in Unilab');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         -- End the remote transaction
         IF NOT PA_LIMS.f_EndRemoteTransaction THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         END IF;
         RETURN (FALSE);      
      END IF;

      l_product_seq := NULL;
      BEGIN
         SELECT seq
         INTO l_product_seq
         FROM uvkeypp@LNK_LIMS
         WHERE key_name = 'st' AND key_tp = 'st';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_product_seq := NULL;
      END;
      
      -- Set the table index
      l_nr_of_rows := 0;
      l_stpplist_to_extend := '0';
      --important filtering taking place in the cursor: obsolete plant specific parameter profiles will be deleted
      FOR l_GetStPp_rec IN l_GetStpp_Cursor(a_St, a_St_version, l_plant_seq, a_part_no, l_product_seq) LOOP
            l_nr_of_rows := l_nr_of_rows + 1;
            l_pp_tab (l_nr_of_rows)         := l_GetStPp_rec.pp;
            l_pp_version_tab (l_nr_of_rows) := l_GetStPp_rec.pp_version;
            l_pp_key1_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key1;
            l_pp_key2_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key2;
            l_pp_key3_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key3;
            l_pp_key4_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key4;
            l_pp_key5_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key5;
            l_freq_tp_tab (l_nr_of_rows)    := SUBSTR(l_GetStPp_rec.freq_tp,1,1);
            l_freq_val_tab (l_nr_of_rows)   := l_GetStPp_rec.freq_val;
            l_freq_unit_tab (l_nr_of_rows)  := l_GetStPp_rec.freq_unit;
            l_invert_freq_tab (l_nr_of_rows):= SUBSTR(l_GetStPp_rec.invert_freq,1,1);
            l_last_sched_tab (l_nr_of_rows) := l_GetStPp_rec.last_sched;
            l_last_cnt_tab (l_nr_of_rows)   := l_GetStPp_rec.last_cnt;
            l_last_val_tab (l_nr_of_rows)   := l_GetStPp_rec.last_val;
            l_inherit_au_tab (l_nr_of_rows) := SUBSTR(l_GetStPp_rec.inherit_au,1,1);
            IF l_GetStPp_rec.stpplist_to_extend = '1' THEN
               l_stpplist_to_extend := '1';
            END IF;
      END LOOP;
      
      IF l_stpplist_to_extend = '0' THEN
         --do not save since not modified
         PA_LIMS.p_Trace(l_classname, l_method, a_St||' | '||a_St_version, 'stpplist not modified', NULL, PA_LIMS.c_Msg_Ended);
         RETURN (TRUE);
      END IF;

      --call savestparameterprofile with the new array
      -- Delete the link between the parameterprofiles and the sampletype
      -- Fill in the parameters to save the standard attributes of the link 
      -- between the parameterprofiles and the sampletype.
      l_modify_reason := 'Reenabled the link between some parameter profiles and sample type "'||a_St||
                         '" because the plant "'||PA_LIMS.f_ActivePlant||'" | is no more obsolete for that part.';
      BEGIN
         -- Save the standard attributes of the link between the parameterprofiles and the sampletype.
         l_return_value := UNAPIST.SAVESTPARAMETERPROFILE@LNK_LIMS(a_St, a_St_version, l_pp_tab, l_pp_version_tab,
                              l_pp_key1_tab, l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_freq_tp_tab,
                              l_freq_val_tab, l_freq_unit_tab, l_invert_freq_tab, l_last_sched_tab, l_last_cnt_tab,
                              l_last_val_tab, l_inherit_au_tab, l_nr_of_rows, l_next_rows, l_modify_reason);
         -- If the error is a general failure then the SQLERRM must be logged, otherwise
         -- the error code is the Unilab error
         IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
            IF l_return_value = PA_LIMS.DBERR_GENFAIL THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to remove the link between the parameterprofiles and st='||a_St||'#version='||a_St_version||
                             ' (General failure! Error Code: '||l_return_value||' Error Msg:'||
                             UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
            ELSE
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to remove the link between the parameterprofiles and st='||a_St||'#version='||a_St_version||
                             ' (Error code : '||l_return_value||').');
            END IF;

            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            -- End the remote transaction
            IF NOT PA_LIMS.f_EndRemoteTransaction THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            END IF;
            RETURN (FALSE);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to remove the link between the parameterprofiles and st='||a_St||'#version='||a_St_version||' : '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            -- End the remote transaction
            IF NOT PA_LIMS.f_EndRemoteTransaction THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            END IF;
            RETURN (FALSE);
      END;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_St||' | '||a_St_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
            'Unable to transfer the parameterprofiles or the links between parameterprofiles and sample types for plant "'||
            PA_LIMS.f_ActivePlant||'" : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_EnableStPp;

   PROCEDURE InitPpPrAssignFreqFromTemplate(
      a_template_pp              IN     VARCHAR2,
      a_pr                       IN     VARCHAR2,
      a_unit                     OUT    VARCHAR2,
      a_format                   OUT    VARCHAR2,
      a_nr_measur                OUT    NUMBER,
      a_allow_add                OUT    CHAR,
      a_is_pp                    OUT    CHAR,
      a_freq_tp                  OUT    CHAR,
      a_freq_val                 OUT    NUMBER,
      a_freq_unit                OUT    VARCHAR2,
      a_invert_freq              OUT    CHAR,
      a_st_based_freq            OUT    CHAR,
      a_last_sched               OUT    DATE,
      a_last_cnt                 OUT    NUMBER, 
      a_last_val                 OUT    VARCHAR2,
      a_inherit_au               OUT    CHAR,
      a_delay                    OUT    NUMBER,
      a_delay_unit               OUT    VARCHAR2)
   IS
      ----------------------------------------------------------------------------------------------------------
      -- ** Purpose **
      -- Fetch stpp link from matching entry in the template st
      -- ** Note **
      -- This is a first implementation, it will first try to find a pp with the pp id (no pp_key taken into account in this release)
      -- When no matching id is found the assignment frequency of the first pp found is used
      --When the template does not contain anything hardcoded values are used (corresponding to frequency Always)
      ----------------------------------------------------------------------------------------------------------
   CURSOR l_first_matching_pr_cursor IS
      SELECT unit, format, nr_measur, allow_add, is_pp, 
             freq_tp, freq_val, freq_unit, invert_freq, st_based_freq,
             last_cnt, last_val, inherit_au, delay, delay_unit
      FROM uvpppr@LNK_LIMS
      WHERE (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) =
           (SELECT pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5 
            FROM uvpp@LNK_LIMS 
            WHERE pp=a_template_pp 
            AND version_is_current='1'
            AND pp_key1=' ' AND pp_key2=' ' AND pp_key3=' ' AND pp_key4=' ' AND pp_key5=' ')
      AND pr= a_pr
      ORDER BY seq;
   CURSOR l_first_pr_cursor IS
      SELECT unit, format, nr_measur, allow_add, is_pp, 
             freq_tp, freq_val, freq_unit, invert_freq, st_based_freq,
             last_cnt, last_val, inherit_au, delay, delay_unit
      FROM uvpppr@LNK_LIMS
      WHERE (pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5) =
           (SELECT pp, version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5 
            FROM uvpp@LNK_LIMS 
            WHERE pp=a_template_pp 
            AND version_is_current='1'
            AND pp_key1=' ' AND pp_key2=' ' AND pp_key3=' ' AND pp_key4=' ' AND pp_key5=' ')
      ORDER BY seq;
      
   BEGIN
      IF PA_LIMS.g_use_template_details = '1' AND
         a_template_pp IS NOT NULL THEN
         OPEN l_first_matching_pr_cursor;
         FETCH l_first_matching_pr_cursor
         INTO a_unit, a_format, a_nr_measur, a_allow_add, a_is_pp, a_freq_tp,
              a_freq_val, a_freq_unit, a_invert_freq, a_st_based_freq, a_last_cnt,
              a_last_val, a_inherit_au, a_delay, a_delay_unit;         
         IF l_first_matching_pr_cursor%NOTFOUND THEN
            CLOSE l_first_matching_pr_cursor;
            OPEN l_first_pr_cursor;
            FETCH l_first_pr_cursor
            INTO a_unit, a_format, a_nr_measur, a_allow_add, a_is_pp, a_freq_tp,
                 a_freq_val, a_freq_unit, a_invert_freq, a_st_based_freq, a_last_cnt,
                 a_last_val, a_inherit_au, a_delay, a_delay_unit;
            IF l_first_pr_cursor%NOTFOUND THEN
               a_unit        := '';
               a_format      := '';
               a_nr_measur   := 1;
               a_allow_add   := '1';
               a_is_pp       := '0';               
               a_freq_tp     := 'A';
               a_freq_val    := 0;
               a_freq_unit   := 'DD';
               a_invert_freq := '0';
               a_st_based_freq := '0';
               a_last_cnt    := 0;
               a_last_val    := '';
               a_last_sched  := NULL;
               a_inherit_au  := '1';
               a_delay       := 0;
               a_delay_unit  := 'DD';
            END IF;
            CLOSE l_first_pr_cursor;
         ELSE
            CLOSE l_first_matching_pr_cursor;
         END IF;
         --last_sched was a problem in other places of the interface, we avoid also the problem here
         a_last_sched := NULL;
      ELSE
         a_unit        := '';
         a_format      := '';
         a_nr_measur   := 1;
         a_allow_add   := '1';
         a_is_pp       := '0';               
         a_freq_tp     := 'A';
         a_freq_val    := 0;
         a_freq_unit   := 'DD';
         a_invert_freq := '0';
         a_st_based_freq := '0';
         a_last_cnt    := 0;
         a_last_val    := '';
         a_last_sched  := NULL;
         a_inherit_au  := '1';
         a_delay       := 0;
         a_delay_unit  := 'DD';
      END IF;
   END InitPpPrAssignFreqFromTemplate;   

   FUNCTION f_TransferSpcPpPr(
      a_pp             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_pp_key1        IN     VARCHAR2,
      a_pp_key2        IN     VARCHAR2,
      a_pp_key3        IN     VARCHAR2,
      a_pp_key4        IN     VARCHAR2,
      a_pp_key5        IN     VARCHAR2,
      a_pr_tab         IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pr_version_tab IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_mt_tab         IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_mt_version_tab IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows     IN     NUMBER,
      a_template_pp    IN     VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer the link between the parameter definition and the parameterprofile
      -- ** Parameters **
      -- a_pp             : parameterprofile
      -- a_version        : version of the parameterprofile
      -- a_pp_key1        : pp_key1 of the parameterprofile
      -- a_pp_key2        : pp_key2 of the parameterprofile
      -- a_pp_key3        : pp_key3 of the parameterprofile
      -- a_pp_key4        : pp_key4 of the parameterprofile
      -- a_pp_key5        : pp_key5 of the parameterprofile
      -- a_pr_tab         : array of parameter definitions assigned to the parameterprofile
      -- a_pr_version_tab : array of versions of the parameter definitions
      -- a_mt_tab         : array of method definitions assigned to the link between the 
      --                    parameter definition and the parameterprofile
      -- a_mt_version_tab : array of versions of the method definitions
      -- a_nr_of_rows     : number of rows
      -- ** Return **
      -- TRUE  : The transfer of the link has succeeded.
      -- FALSE : The transfer of the link has failed.
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcPpPr';
      l_object       VARCHAR2(255);
      l_objects      VARCHAR2(255);

      -- General variables
      l_version             VARCHAR2(20);
      l_insert              BOOLEAN                             DEFAULT FALSE;
      l_newminor            BOOLEAN                             DEFAULT FALSE;
      l_newminor4mtordesc   BOOLEAN                             DEFAULT FALSE;
      
      -- Specific local variables for the 'GetPpParameter' API
      l_return_value_get    INTEGER;
      l_nr_of_rows          NUMBER                            DEFAULT NULL;
      l_where_clause        VARCHAR2(255);
      l_pp_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_description_tab     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_unit_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_format_tab          UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_nr_measur_tab       UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_allow_add_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_is_pp_tab           UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_tp_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_val_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_unit_tab       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_invert_freq_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_st_based_freq_tab   UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_last_sched_tab      UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_last_cnt_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_last_val_tab        UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_delay_tab           UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_delay_unit_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_nr_measur_tab    UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'SavePpParameter' API
      l_return_value_save   INTEGER;
      l_pp                  VARCHAR2(20);
      l_pp_version          VARCHAR2(20);
      l_pp_key1             VARCHAR2(20);
      l_pp_key2             VARCHAR2(20);
      l_pp_key3             VARCHAR2(20);
      l_pp_key4             VARCHAR2(20);
      l_pp_key5             VARCHAR2(20);
      l_modify_reason       VARCHAR2(255);

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_pp_lc                  VARCHAR2(2);
      l_pp_lc_version          VARCHAR2(20);
      l_pp_ss                  VARCHAR2(2);
      l_pp_Log_hs              CHAR(1);
      l_pp_allow_modify        CHAR(1);
      l_pp_active              CHAR(1);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Pp||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Started);
      PA_LIMS.p_Trace(l_classname, l_method, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4||' | '||a_pp_key5);
      -- Initializing variables
      l_object := 'parameterprofile "'||a_pp||'" | version='||a_version||' | pp_keys="'||a_pp_key1||'"#"'||a_pp_key2||
                  '"#"'||a_pp_key3||'"#"'||a_pp_key4||'"#"'||a_pp_key5||'"';
      l_objects := 'the link between the parameter definitions and '||l_object;

      -- Fill in the parameters to get the standard attributes of the link 
      -- between the parameter definitions and the parameterprofile.
      l_where_clause := 'WHERE pp='''||REPLACE(a_pp,'''','''''')||''' AND version='''||a_version||
                        ''' AND pp_key1='''||REPLACE(a_pp_key1,'''','''''')||
                        ''' AND pp_key2='''||REPLACE(a_pp_key2,'''','''''')||
                        ''' AND pp_key3='''||REPLACE(a_pp_key3,'''','''''')||
                        ''' AND pp_key4='''||REPLACE(a_pp_key4,'''','''''')||
                        ''' AND pp_key5='''||REPLACE(a_pp_key5,'''','''''')||''' ORDER BY seq';
      -- Get the standard attributes of the link between the parameter definitions and the parameterprofile.
      l_return_value_get := UNAPIPP.GETPPPARAMETER@LNK_LIMS(l_pp_tab, l_pp_version_tab, l_pp_key1_tab, l_pp_key2_tab,
                               l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_pr_tab, l_pr_version_tab, l_description_tab,
                               l_unit_tab, l_format_tab, l_nr_measur_tab, l_allow_add_tab, l_is_pp_tab, l_freq_tp_tab,
                               l_freq_val_tab, l_freq_unit_tab, l_invert_freq_tab, l_st_based_freq_tab, l_last_sched_tab,
                               l_last_cnt_tab, l_last_val_tab, l_inherit_au_tab, l_delay_tab, l_delay_unit_tab, l_mt_tab,
                               l_mt_version_tab, l_mt_nr_measur_tab, l_nr_of_rows, l_where_clause);
      -- Check if a link between parameter definitions and the parameterprofile exists in Unilab
      -- If no link is found then it must be created.
      IF l_return_value_get = PA_LIMS.DBERR_NORECORDS THEN
         -- When there are no records found, l_nr_of_rows=100. That's why it is reset to 0.
         l_nr_of_rows := 0;

         -- Get the authorisation of the parameterprofile
         l_ret_code := UNAPIPPP.GETPPAUTHORISATION@LNK_LIMS(a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3,
                                                            a_pp_key4, a_pp_key5, l_pp_lc, l_pp_lc_version, l_pp_ss,
                                                            l_pp_allow_modify, l_pp_active, l_pp_Log_hs);
         IF l_ret_code = PA_LIMS.DBERR_SUCCESS THEN
            -- Modifiable, parameter definition can immediately be assigned
            l_insert := TRUE;
         ELSIF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
            -- Not modifiable, new minor version has to be created before parameter definition can be assigend
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

         -- Check if the link between the parameter definitions and the parameterprofile exists
         FOR i IN 1..a_nr_of_rows LOOP
            FOR l_row_counter IN 1 .. l_nr_of_rows LOOP
               IF (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pr_tab(l_row_counter),a_Pr_tab(i))                 = 1) AND
                  (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pr_version_tab(l_row_counter),a_pr_version_tab(i)) = 1) THEN
                  l_newminor := FALSE;
                  IF (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_mt_tab(l_row_counter),a_mt_tab(i))                 = 0) OR
                     (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_mt_version_tab(l_row_counter),a_mt_version_tab(i)) = 0) THEN
                     l_newminor4mtordesc := TRUE;
                     l_mt_tab(l_row_counter) := NVL(a_mt_tab(i), l_mt_tab(l_row_counter));
                     l_mt_version_tab(l_row_counter) := NVL(a_mt_version_tab(i), l_mt_version_tab(l_row_counter));
                     EXIT;
                  END IF;
               END IF;
            END LOOP;
         END LOOP;
      ELSE
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
           'Unable to retrieve the standard attributes of the link between the parameter definitions and '||l_object||
           ' (Error code : '||l_return_value_get||').');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;
      
      -- If some new parameter definitions have to be assigned, a new minor version of the 
      -- parameterprofile has to be created.
      -- In fact the f_TransferSpcPp evaluates if it is really necessary to create a new minor version.
      -- If not modifiable, a new minor version will be created; in the other case
      -- the given version will be modified.
      IF (l_newminor OR l_newminor4mtordesc) THEN
         l_version := a_version;
         IF NOT f_TransferSpcPp(a_pp, l_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5, NULL, NULL,
                                NULL, NULL, '1') THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
         a_version := l_version;
      END IF;

      -- Assign the new parameter definition
      IF (l_insert OR l_newminor) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the parameter definitions and the parameterprofile.
         l_pp                            := a_pp;
         l_pp_version                    := a_version;
         l_pp_key1                       := a_pp_key1;
         l_pp_key2                       := a_pp_key2;
         l_pp_key3                       := a_pp_key3;
         l_pp_key4                       := a_pp_key4;
         l_pp_key5                       := a_pp_key5;
         FOR i IN 1..a_nr_of_rows LOOP
            l_nr_of_rows                    := l_nr_of_rows + 1;
            l_pr_tab(l_nr_of_rows)          := a_Pr_tab(i);
            l_pr_version_tab(l_nr_of_rows)  := a_pr_version_tab(i);
            InitPpPrAssignFreqFromTemplate(a_template_pp, a_Pr_tab(i),
                                           l_unit_tab(l_nr_of_rows), l_format_tab(l_nr_of_rows), l_nr_measur_tab(l_nr_of_rows),
                                           l_allow_add_tab(l_nr_of_rows),l_is_pp_tab(l_nr_of_rows),                                           
                                           l_freq_tp_tab(l_nr_of_rows), l_freq_val_tab(l_nr_of_rows), l_freq_unit_tab(l_nr_of_rows),
                                           l_invert_freq_tab(l_nr_of_rows), l_st_based_freq_tab(l_nr_of_rows), l_last_sched_tab(l_nr_of_rows),
                                           l_last_cnt_tab(l_nr_of_rows), l_last_val_tab(l_nr_of_rows), 
                                           l_inherit_au_tab(l_nr_of_rows), l_delay_tab(l_nr_of_rows), l_delay_unit_tab(l_nr_of_rows));
            l_mt_tab(l_nr_of_rows)          := a_Mt_tab(i);
            l_mt_version_tab(l_nr_of_rows)  := a_mt_version_tab(i);
            IF a_Mt_tab(i) IS NULL THEN
               l_mt_nr_measur_tab(l_nr_of_rows) := 0;
            ELSE
               l_mt_nr_measur_tab(l_nr_of_rows) := 1;
            END IF;
         END LOOP;
         l_modify_reason                 := 'Imported the link between the parameter definitions'||
                                            ' and parameter profile "'||a_pp||'" from Interspec.';
         -----------------------------------------------------------------------
         -- Roald Klomp, Siemens Nederland N.V.
         -- 19-12-2002 11:51
         -- l_mt_nr_measur_tab(l_nr_of_rows) := 0;
         -- replaced with the code below.
         -- With this solution, this works the same as it works within standard Unilab.
         -----------------------------------------------------------------------
         BEGIN
            -- Save the standard attributes of the link between the parameter definitions and the parameterprofile.
            l_return_value_save := UNAPIPP.SAVEPPPARAMETER@LNK_LIMS(l_pp, l_pp_version, l_pp_key1, l_pp_key2, l_pp_key3,
                                      l_pp_key4, l_pp_key5, l_pr_tab, l_pr_version_tab, l_nr_measur_tab, l_unit_tab,
                                      l_format_tab, l_allow_add_tab, l_is_pp_tab, l_freq_tp_tab, l_freq_val_tab,
                                      l_freq_unit_tab, l_invert_freq_tab, l_st_based_freq_tab, l_last_sched_tab,
                                      l_last_cnt_tab, l_last_val_tab, l_inherit_au_tab, l_delay_tab, l_delay_unit_tab,
                                      l_mt_tab, l_mt_version_tab, l_mt_nr_measur_tab, l_nr_of_rows, l_modify_reason);
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
      -- The link between the parameter definition and the parameterprofile is already in Unilab.
      ELSIF (l_newminor4mtordesc) THEN
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the parameter definitions and the parameterprofile.
         l_pp                     := a_pp;
         l_pp_version             := a_version;
         l_pp_key1                := a_pp_key1;
         l_pp_key2                := a_pp_key2;
         l_pp_key3                := a_pp_key3;
         l_pp_key4                := a_pp_key4;
         l_pp_key5                := a_pp_key5;
         l_modify_reason          := 'Imported the update of the link between the parameter definitions'||
                                     ' and parameter profile "'||a_pp||'" from Interspec.';
         BEGIN
            -- Save the standard attributes of the link between the parameter definition 
            -- and the parameterprofile
            l_return_value_save := UNAPIPP.SAVEPPPARAMETER@LNK_LIMS(l_pp, l_pp_version, l_pp_key1, l_pp_key2, l_pp_key3,
                                      l_pp_key4, l_pp_key5, l_pr_tab, l_pr_version_tab, l_nr_measur_tab, l_unit_tab,
                                      l_format_tab, l_allow_add_tab, l_is_pp_tab, l_freq_tp_tab, l_freq_val_tab,
                                      l_freq_unit_tab, l_invert_freq_tab, l_st_based_freq_tab, l_last_sched_tab,
                                      l_last_cnt_tab, l_last_val_tab, l_inherit_au_tab, l_delay_tab, l_delay_unit_tab,
                                      l_mt_tab, l_mt_version_tab, l_mt_nr_measur_tab, l_nr_of_rows, l_modify_reason);
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
   END f_TransferSpcPpPr;

   FUNCTION f_DeleteAllPpPr(
      a_pp             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_pp_key1        IN     VARCHAR2,
      a_pp_key2        IN     VARCHAR2,
      a_pp_key3        IN     VARCHAR2,
      a_pp_key4        IN     VARCHAR2,
      a_pp_key5        IN     VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Delete all pppr and ppprau records
      -- ** Parameters **
      -- a_pp             : parameterprofile
      -- a_version        : version of the parameterprofile
      -- a_pp_key1        : pp_key1 of the parameterprofile
      -- a_pp_key2        : pp_key2 of the parameterprofile
      -- a_pp_key3        : pp_key3 of the parameterprofile
      -- a_pp_key4        : pp_key4 of the parameterprofile
      -- a_pp_key5        : pp_key5 of the parameterprofile
      -- ** Return **
      -- TRUE  : The transfer of the link has succeeded.
      -- FALSE : The transfer of the link has failed.
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_DeleteAllPpPr';
      l_object       VARCHAR2(255);
      l_objects      VARCHAR2(255);

      -- General variables
      l_version             VARCHAR2(20);
      l_insert              BOOLEAN                             DEFAULT FALSE;
      l_newminor            BOOLEAN                             DEFAULT FALSE;
      l_newminor4mtordesc   BOOLEAN                             DEFAULT FALSE;
      
      -- Specific local variables for the 'SavePpParameter' API
      l_nr_of_rows          NUMBER                            DEFAULT NULL;
      l_pr_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_description_tab     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_unit_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_format_tab          UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_nr_measur_tab       UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_allow_add_tab       UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_is_pp_tab           UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_tp_tab         UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_freq_val_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_freq_unit_tab       UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_invert_freq_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_st_based_freq_tab   UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_last_sched_tab      UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS;
      l_last_cnt_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_last_val_tab        UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      l_inherit_au_tab      UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_delay_tab           UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_delay_unit_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_nr_measur_tab    UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;

      l_return_value_save   INTEGER;
      l_modify_reason       VARCHAR2(255);

   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Pp||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Started);
      PA_LIMS.p_Trace(l_classname, l_method, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4||' | '||a_pp_key5);
      -- Initializing variables
      l_object := 'parameterprofile "'||a_pp||'" | version='||a_version||' | pp_keys="'||a_pp_key1||'"#"'||a_pp_key2||
                  '"#"'||a_pp_key3||'"#"'||a_pp_key4||'"#"'||a_pp_key5||'"';
      l_objects := 'the link between the parameter definitions and '||l_object;

      BEGIN
         l_nr_of_rows := 0;
         -- Save the standard attributes of the link between the parameter definitions and the parameterprofile.
         l_return_value_save := UNAPIPP.SAVEPPPARAMETER@LNK_LIMS(a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3,
                                   a_pp_key4, a_pp_key5, l_pr_tab, l_pr_version_tab, l_nr_measur_tab, l_unit_tab,
                                   l_format_tab, l_allow_add_tab, l_is_pp_tab, l_freq_tp_tab, l_freq_val_tab,
                                   l_freq_unit_tab, l_invert_freq_tab, l_st_based_freq_tab, l_last_sched_tab,
                                   l_last_cnt_tab, l_last_val_tab, l_inherit_au_tab, l_delay_tab, l_delay_unit_tab,
                                   l_mt_tab, l_mt_version_tab, l_mt_nr_measur_tab, l_nr_of_rows, l_modify_reason);
         -- If the error is a general failure then the SQLERRM must be logged, otherwise
         -- the error code is the Unilab error
         IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
            IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to delete all used parameters of '||l_objects||' (General failure! Error Code: '||
                             l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
            ELSE
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to delete all used parameters of '||l_objects||' (Error code : '||
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
                          'Unable to delete all used parameters of '||l_objects||' : '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

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
   END f_DeleteAllPpPr;

   FUNCTION f_TransferSpcPpPrSp(
      a_pp                 IN     VARCHAR2,
      a_version            IN OUT VARCHAR2,
      a_pp_key1            IN     VARCHAR2,
      a_pp_key2            IN     VARCHAR2,
      a_pp_key3            IN     VARCHAR2,
      a_pp_key4            IN     VARCHAR2,
      a_pp_key5            IN     VARCHAR2,
      a_pr_tab             IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pr_version_tab     IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_Low_Limit_tab      IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_High_Limit_tab     IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_Low_Spec_tab       IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_High_Spec_tab      IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_Low_Dev_tab        IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_Rel_Low_Dev_tab    IN     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS,
      a_Target_fl_tab      IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_High_dev_tab       IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_Rel_High_dev_tab   IN     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows         IN     NUMBER,
      a_specset            IN     CHAR
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer the specification data of the link between the parameter 
      -- definition and the parameterprofile
      -- ** Parameters **
      -- a_pp                : parameterprofile
      -- a_version           : version of the parameterprofile
      -- a_pp_key1           : pp_key1 of the parameterprofile
      -- a_pp_key2           : pp_key2 of the parameterprofile
      -- a_pp_key3           : pp_key3 of the parameterprofile
      -- a_pp_key4           : pp_key4 of the parameterprofile
      -- a_pp_key5           : pp_key5 of the parameterprofile
      -- a_pr_tab            : parameter definition assigned to the parameterprofile
      -- a_pr_version_tab    : version of the parameter definition
      -- a_low_limit_tab     : -
      -- a_high_limit_tab    :  |
      -- a_low_spec_tab      :  |
      -- a_high_spec_tab     :  |
      -- a_low_dev_tab       :   \ specification data of the link between the parameter
      -- a_rel_low_dev_tab   :   / definition and the parameterprofile
      -- a_target_fl_tab     :  |
      -- a_high_dev_tab      :  |
      -- a_rel_high_dev_tab  : - 
      -- a_specset           : a, b or c
      -- ** Return **
      -- TRUE  : The transfer of the specification data has succeeded.
      -- FALSE : The transfer of the specification data has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcPpPrSp';
      l_object       VARCHAR2(255);
      l_objects      VARCHAR2(255);

      -- General variables
      l_present             NUMBER;
      l_modified            NUMBER;
      
      -- Specific local variables for the 'GetPpParameterSpecs' API
      l_return_value_get    INTEGER;
      l_spec_set            CHAR(1);
      l_nr_of_rows          NUMBER                            DEFAULT NULL;
      l_where_clause        VARCHAR2(255);
      l_pp_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key1_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key2_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key3_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key4_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pp_key5_tab         UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_version_tab      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_low_limit_tab       UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_limit_tab      UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_spec_tab        UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_spec_tab       UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_low_dev_tab         UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_low_dev_tab     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_target_tab          UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_high_dev_tab        UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_rel_high_dev_tab    UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;

      -- Specific local variables for the 'SavePpParameterSpecs' API
      l_return_value_save   INTEGER;
      l_pp                  VARCHAR2(20);
      l_version             VARCHAR2(20);
      l_pp_key1             VARCHAR2(20);
      l_pp_key2             VARCHAR2(20);
      l_pp_key3             VARCHAR2(20);
      l_pp_key4             VARCHAR2(20);
      l_pp_key5             VARCHAR2(20);
      l_modify_reason       VARCHAR2(255);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Pp||' | '||a_version, NULL, a_specset, 
                      PA_LIMS.c_Msg_Started);
      PA_LIMS.p_Trace(l_classname, l_method, a_pp_key1||' | '||a_pp_key2, a_pp_key3||' | '||a_pp_key4, a_pp_key5, 
                      NULL);
      l_object := 'parameterprofile "'||a_Pp||'" | version='||a_version||' | pp_keys="'||a_pp_key1||'"#"'||a_pp_key2||
                  '"#"'||a_pp_key3||'"#"'||a_pp_key4||'"#"'||a_pp_key5||'"';
      l_objects := 'the link between the parameter definitions and '||l_object;
      -- Initialize variables
      l_modified := 0;

      l_nr_of_rows := 1000 ; -- NULL will restrict to 100 records

      -- Fill in the parameters to get the specification data of the link 
      -- between the parameter definitions and the parameterprofile.
      l_spec_set := LOWER(a_specset); -- OLD : only 'a'!
      l_where_clause := 'WHERE pp='''||REPLACE(a_pp,'''','''''')||''' AND version='''||a_version||
                        ''' AND pp_key1='''||REPLACE(a_pp_key1,'''','''''')||
                        ''' AND pp_key2='''||REPLACE(a_pp_key2,'''','''''')||
                        ''' AND pp_key3='''||REPLACE(a_pp_key3,'''','''''')||
                        ''' AND pp_key4='''||REPLACE(a_pp_key4,'''','''''')||
                        ''' AND pp_key5='''||REPLACE(a_pp_key5,'''','''''')||''' ORDER BY seq';
      -- Get the specification data of the link between the parameter definitions and the parameterprofile
      l_return_value_get := UNAPIPP.GETPPPARAMETERSPECS@LNK_LIMS(l_pp_tab, l_pp_version_tab, l_pp_key1_tab, l_pp_key2_tab,
                               l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_pr_tab, l_pr_version_tab, l_low_limit_tab,
                               l_high_limit_tab, l_low_spec_tab, l_high_spec_tab, l_low_dev_tab, l_rel_low_dev_tab,
                               l_target_tab, l_high_dev_tab, l_rel_high_dev_tab, l_spec_set, l_nr_of_rows, l_where_clause);
      -- Check if specification data of a link between parameter definitions and the parameterprofile exists in Unilab
      -- If no data is found then it must be created.
      IF l_return_value_get = PA_LIMS.DBERR_SUCCESS THEN
         -- Check if specification data of the link between the parameter definition and the parameterprofile exists
         FOR i IN 1..a_nr_of_rows LOOP
            FOR l_row_counter IN 1 .. l_nr_of_rows LOOP
               IF (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pr_tab(l_row_counter),a_pr_tab(i))                 = 1) AND
                  (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pr_version_tab(l_row_counter),a_pr_version_tab(i)) = 1) THEN
                  l_present := 1;

                  -- Check if the specification data has been updated
                  IF (PA_LIMS_SPECX_TOOLS.COMPARE_FLOAT(l_low_limit_tab(l_row_counter),a_Low_Limit_tab(i))=1 OR a_Low_Limit_tab(i) IS NULL) AND
                     (PA_LIMS_SPECX_TOOLS.COMPARE_FLOAT(l_high_limit_tab(l_row_counter),a_High_Limit_tab(i))=1 OR a_high_Limit_tab(i) IS NULL) AND 
                     (PA_LIMS_SPECX_TOOLS.COMPARE_FLOAT(l_low_spec_tab(l_row_counter),a_Low_Spec_tab(i))=1 OR a_Low_Spec_tab(i) IS NULL) AND 
                     (PA_LIMS_SPECX_TOOLS.COMPARE_FLOAT(l_high_spec_tab(l_row_counter),a_high_Spec_tab(i))=1 OR a_high_Spec_tab(i) IS NULL) AND 
                     (PA_LIMS_SPECX_TOOLS.COMPARE_FLOAT(l_low_dev_tab(l_row_counter),a_low_dev_tab(i))=1 OR a_low_dev_tab(i) IS NULL) AND 
                     (PA_LIMS_SPECX_TOOLS.COMPARE_FLOAT(l_rel_low_dev_tab(l_row_counter),a_Rel_Low_Dev_tab(i))=1 OR a_Rel_Low_Dev_tab(i) IS NULL) AND 
                     (PA_LIMS_SPECX_TOOLS.COMPARE_FLOAT(l_target_tab(l_row_counter),a_Target_fl_tab(i))=1 OR a_Target_fl_tab(i) IS NULL) AND 
                     (PA_LIMS_SPECX_TOOLS.COMPARE_FLOAT(l_high_dev_tab(l_row_counter),a_High_dev_tab(i))=1 OR a_High_dev_tab(i) IS NULL) AND 
                     (PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_rel_high_dev_tab(l_row_counter),a_Rel_High_dev_tab(i))=1 OR a_Rel_High_dev_tab(i) IS NULL) THEN
                     l_modified := l_modified + 1;
                  END IF;

                  l_pr_tab(l_row_counter)           := a_pr_tab(i);
                  l_pr_version_tab(l_row_counter)   := a_pr_version_tab(i);
                  l_low_limit_tab(l_row_counter)    := a_Low_Limit_tab(i);
                  l_high_limit_tab(l_row_counter)   := a_High_Limit_tab(i);
                  l_low_spec_tab(l_row_counter)     := a_Low_Spec_tab(i);
                  l_high_spec_tab(l_row_counter)    := a_High_Spec_tab(i);
                  l_low_dev_tab(l_row_counter)      := a_Low_Dev_tab(i);
                  l_rel_low_dev_tab(l_row_counter)  := a_Rel_Low_Dev_tab(i);
                  l_target_tab(l_row_counter)       := a_Target_fl_tab(i);
                  l_high_dev_tab(l_row_counter)     := a_High_dev_tab(i);
                  l_rel_high_dev_tab(l_row_counter) := a_Rel_High_dev_tab(i);
                  EXIT;
               END IF;
            END LOOP;
         END LOOP;
      ELSE
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
           'Unable to retrieve the specification data of the link between the parameter definitions and '||l_object||
           ' (Error code : '||l_return_value_get||').');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Assign the new specification data
      IF PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_present, 0) = 0 THEN
         -- Check if the specification data has been updated
         IF l_modified = a_nr_of_rows THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Nothing happened: '||PA_LIMS.c_Msg_Ended);
            RETURN (TRUE);
         END IF;

         -- Fill in the parameters to save the standard attributes of the specification data  
         -- of the link between the parameter definitions and the parameterprofile.
         l_pp                      := a_pp;
         l_version                 := a_version;
         l_pp_key1                 := a_pp_key1;
         l_pp_key2                 := a_pp_key2;
         l_pp_key3                 := a_pp_key3;
         l_pp_key4                 := a_pp_key4;
         l_pp_key5                 := a_pp_key5;
         l_modify_reason           := 'Imported the specification data of the link between the parameter definitions '||
                                      ' and parameter profile "'||a_pp||'" from Interspec.';
         BEGIN
            -- Save the standard attributes of the specification data of the link  
            -- between the parameter definition and the parameterprofile
            l_return_value_save := UNAPIPP.SAVEPPPARAMETERSPECS@LNK_LIMS(l_pp, l_version, l_pp_key1, l_pp_key2, l_pp_key3,
                                      l_pp_key4, l_pp_key5, l_pr_tab, l_pr_version_tab, l_spec_set, l_low_limit_tab,
                                      l_high_limit_tab, l_low_spec_tab, l_high_spec_tab, l_low_dev_tab, l_rel_low_dev_tab,
                                      l_target_tab, l_high_dev_tab, l_rel_high_dev_tab, l_nr_of_rows, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value_save <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value_save = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the specification data of '||l_objects||' (General failure! Error Code: '||
                                l_return_value_save||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save the specification data of '||l_objects||' (Error code : '||
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
                             'Unable to save the specification data of '||l_objects||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      ELSE
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
            'Unable to retrieve the specification data of the link between the parameter definitions and '||l_object||'.');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Pp||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                   'Unexpected error when transferring the specification data of '||l_objects||' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcPpPrSp;

   FUNCTION f_GetLIMSCol(
      a_LimsCol   IN itlimsconfly.un_id%TYPE,
      a_Ly        IN itlimsconfly.layout_id%TYPE,
      a_lyRev     IN itlimsconfly.layout_rev%TYPE,
      a_specset   IN CHAR
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the column name for a display format that has to be used
      -- for the LIMS value
      -- ** Parameters **
      -- a_limscol : column_name
      -- a_ly      : display format
      -- a_lyrev   : revision of the display format
      -- a_specset : set of specification data
      -- ** Return **
      -- The SpeCX column name
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_GetLIMSCol';

      -- General variables
      l_col_name   VARCHAR2(10) DEFAULT NULL;

      -- Cursor to get the column name in speCX for a certain Unilab column
      CURSOR l_getLimsCol_Cursor(
         c_LimsCol   itlimsconfly.un_id%TYPE,
         c_Ly        itlimsconfly.layout_id%TYPE,
         c_lyRev     itlimsconfly.layout_rev%TYPE,
         c_specset   CHAR
      )
      IS
         SELECT is_col
           FROM itlimsconfly
          WHERE un_id = c_LimsCol
            AND layout_id = c_ly
            AND layout_rev = c_lyRev
            AND un_type = 'PPSP'||c_specset
            AND un_object = 'PR';
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_limscol, a_ly||' | '||a_lyrev, a_specset, PA_LIMS.c_Msg_Started);

      -- Get the speCX column name
      FOR l_getLimsCol_Rec IN l_getLimsCol_Cursor(a_LimsCol, a_Ly, a_LyRev, a_specset) LOOP
         l_col_name := l_getLimsCol_Rec.is_col;
      END LOOP;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (l_col_name);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to get the Interspec column for the LIMS column "'||a_LimsCol||'" | specset='||
                       a_specset||' | display format="'||a_ly||'" | revision='||a_lyRev||' : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (NULL);
   END f_GetLIMSCol;

   FUNCTION f_TransferSpcAllPpPrSp(
      a_PpId               IN     VARCHAR2,
      a_version            IN OUT VARCHAR2,
      a_pp_key1            IN     VARCHAR2,
      a_pp_key2            IN     VARCHAR2,
      a_pp_key3            IN     VARCHAR2,
      a_pp_key4            IN     VARCHAR2,
      a_pp_key5            IN     VARCHAR2,
      a_Part_No            IN     specification_prop.part_no%TYPE,
      a_Revision           IN     specification_prop.revision%TYPE,
      a_PropertyGroup      IN     specification_prop.property_group%TYPE,
      a_SectionId_tab      IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_SubSectionId_tab   IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_Property_tab       IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_attribute_tab      IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows         IN     NUMBER
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer all the specification data of the link between the parameter definition
      -- and the parameterprofile.
      -- ** Parameters **
      -- a_ppid           : parameterprofile
      -- a_version        : version of the parameterprofile
      -- a_pp_key1        : pp_key1 of the parameterprofile
      -- a_pp_key2        : pp_key2 of the parameterprofile
      -- a_pp_key3        : pp_key3 of the parameterprofile
      -- a_pp_key4        : pp_key4 of the parameterprofile
      -- a_pp_key5        : pp_key5 of the parameterprofile
      -- a_part_no        : part_no of the specification
      -- a_revision       : revision of the specification
      -- a_sectionid      : section of the specification
      -- a_subsectionid   : subsection of the specfication
      -- a_propertygroup  : propertygroup of the specification
      -- a_property_tab   : array of the properties of the specification
      -- a_attribute_tab  : array of the attributes of the specification
      -- a_nr_of_rows     : number of rows
      -- ** Return **
      -- TRUE  : The transfer of the specification data has succeeded.
      -- FALSE : The transfer of the specification data has failed.
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcAllPpPrSp';
      l_object       VARCHAR2(255);

      -- General variables
      l_pr_tab            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pppr_version_tab  UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;

      l_PrId               VARCHAR2(20);
      l_pr_desc            VARCHAR2(40);
      l_sp_revision        NUMBER;
      l_sp_desc            VARCHAR2(130);
      l_Ly                 itlimsconfly.layout_id%TYPE;
      l_lyRev              itlimsconfly.layout_rev%TYPE;
      -- Variables for the column names for the different LIMS values
      l_col_Low_Limit      VARCHAR2(10);
      l_col_High_Limit     VARCHAR2(10);
      l_col_Low_Spec       VARCHAR2(10);
      l_col_High_Spec      VARCHAR2(10);
      l_col_Low_Dev        VARCHAR2(10);
      l_col_Rel_Low_Dev    VARCHAR2(10);
      l_col_Target_fl      VARCHAR2(10);
      l_col_High_dev       VARCHAR2(10);
      l_col_Rel_High_dev   VARCHAR2(10);
      -- Dynamic SQL
      l_cur_hdl            INTEGER;
      l_return_value       INTEGER;
      l_sql                DBMS_SQL.varchar2s;
      -- Into variables of the dynamic SQL
      l_Property           NUMBER(8);
      l_Low_Limit          FLOAT;
      l_High_Limit         FLOAT;
      l_Low_Spec           FLOAT;
      l_High_Spec          FLOAT;
      l_Low_Dev            FLOAT;
      l_Rel_Low_Dev        CHAR(1);
      l_Target_fl          FLOAT;
      l_High_dev           FLOAT;
      l_Rel_High_dev       CHAR(1);
      l_Low_Limit_tab      UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_High_Limit_tab     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_Low_Spec_tab       UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_High_Spec_tab      UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_Low_Dev_tab        UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_Rel_Low_Dev_tab    UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_Target_fl_tab      UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_High_dev_tab       UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS;
      l_Rel_High_dev_tab   UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;
      l_specset            CHAR(1);
      l_specset_tab        UNAPIGEN.VC1_TABLE_TYPE@LNK_LIMS;
      l_index              INTEGER;
      
      --optimalisation
      l_prev_sectionid     NUMBER(8);
      l_prev_subsectionid  NUMBER(8);

      -- Cursor to get the display format
      CURSOR l_GetLy_Cursor(
         c_Part_No         specification_prop.part_no%TYPE,
         c_Revision        specification_prop.revision%TYPE,
         c_SectionId       specification_section.section_id%TYPE,
         c_SubSectionId    specification_section.sub_section_id%TYPE,
         c_PropertyGroup   specification_prop.property_group%TYPE
      )
      IS
         SELECT DISTINCT sps.ref_id, sps.display_format,
                         sps.display_format_rev
                    FROM specification_section sps
                   WHERE sps.part_no = c_Part_No
                     AND sps.revision = c_Revision
                     AND sps.section_id = c_SectionId
                     AND sps.sub_section_id = c_SubSectionId
                     AND sps.ref_id = c_PropertyGroup
                     AND sps.type = 1;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Ppid||' | '||a_version, a_part_no||' | '||a_revision, NULL, 
                      PA_LIMS.c_Msg_Started);
      PA_LIMS.p_Trace(l_classname, l_method, a_pp_key1||' | '||a_pp_key2, a_pp_key3||' | '||a_pp_key4, a_pp_key5,
                      a_nr_of_rows);
      FOR l_x IN 1..a_nr_of_rows LOOP
         PA_LIMS.p_Trace(l_classname, l_method, 'Index '||l_x||' | '||a_SectionId_tab(l_x)||' | '|| a_SubSectionId_tab(l_x), NULL,
                         NULL, NULL);
      END LOOP;
      -- Initializing variables
      l_object := 'parameterprofile "'||a_PpID||'" | version='||a_version||' | pp_keys="'||a_pp_key1||'"#"'||a_pp_key2||
                  '"#"'||a_pp_key3||'"#"'||a_pp_key4||'"#"'||a_pp_key5||'"';
      
      -- Get the display format for the property group

      -- Different specsets are possible!
      l_specset_tab(1) := 'A';
      l_specset_tab(2) := 'B';
      l_specset_tab(3) := 'C';

      FOR l_index IN 1 .. 3 LOOP
         l_specset := l_specset_tab(l_index);
         l_prev_sectionid := -1;         
         l_prev_subsectionid := -1;         
         FOR i IN 1..a_nr_of_rows LOOP
            
            --optimized: display format can change when section or subsection is varying
            --the same property group can be spread across deifferent sub section in one section
            --or eve across different sections (don't know if it is current practice)
            IF l_prev_sectionid <> a_SectionId_tab(i) OR
               l_prev_subsectionid <> a_SubSectionId_tab(i) THEN
               FOR l_GetLy_Rec IN l_GetLy_Cursor(a_Part_No, a_Revision, a_SectionId_tab(i), a_SubSectionId_tab(i), a_PropertyGroup) LOOP
                  l_Ly := l_GetLy_Rec.Display_format;
                  l_lyRev := l_GetLy_Rec.Display_format_Rev;
               END LOOP;
               -- Get the column names for the different LIMS values
               l_col_Low_Limit    := f_GetLIMSCol('LOW_LIMIT_'||l_specset, l_Ly, l_lyRev, l_specset);
               l_col_High_Limit   := f_GetLIMSCol('HIGH_LIMIT_'||l_specset, l_Ly, l_lyRev, l_specset);
               l_col_Low_Spec     := f_GetLIMSCol('LOW_SPEC_'||l_specset, l_Ly, l_lyRev, l_specset);
               l_col_High_Spec    := f_GetLIMSCol('HIGH_SPEC_'||l_specset, l_Ly, l_lyRev, l_specset);
               l_col_Low_Dev      := f_GetLIMSCol('LOW_DEV_'||l_specset, l_Ly, l_lyRev, l_specset);
               l_col_Rel_Low_Dev  := f_GetLIMSCol('REL_LOW_DEV_'||l_specset, l_Ly, l_lyRev, l_specset);
               l_col_Target_fl    := f_GetLIMSCol('TARGET_'||l_specset, l_Ly, l_lyRev, l_specset);
               l_col_High_dev     := f_GetLIMSCol('HIGH_DEV_'||l_specset, l_Ly, l_lyRev, l_specset);
               l_col_Rel_High_dev := f_GetLIMSCol('REL_HIGH_DEV_'||l_specset, l_Ly, l_lyRev, l_specset);
               l_prev_sectionid := a_SectionId_tab(i);         
               l_prev_subsectionid := a_SubSectionId_tab(i);         
            END IF;

            -- Open the cursor
            l_cur_hdl := DBMS_SQL.OPEN_CURSOR;
            -- Create the dynamic Select statement
            l_sql(1) := 'SELECT PROPERTY,'||NVL(l_col_Low_Limit, '''''')||' ,'||NVL(l_col_High_Limit, '''''')||' ,'||
                        NVL(l_col_Low_Spec, '''''')||' ,'||NVL(l_col_High_Spec, '''''')||' ,'||
                        NVL(l_col_Low_Dev, '''''')||' ,'||NVL(l_col_Rel_Low_Dev, '0')||' ,'||NVL(l_col_Target_fl, '''''')||' ,'||
                        NVL(l_col_High_dev, '''''')||' ,'||NVL(l_col_Rel_High_dev, '0');
            l_sql(2) := ' FROM specification_prop '||
                        ' WHERE part_no        = :a_Part_No'||
                        ' AND revision       = :a_Revision'||
                        '   AND property       = :a_Property'||
                        ' AND ';
            l_sql(3) := '       property_group = :a_PropertyGroup'||
                        ' AND section_id     = :a_SectionID'||
                        ' AND sub_section_id = :a_SubSectionID'||
                        ' AND attribute      = :a_Attribute';

            -- Set the SQL statement
            DBMS_SQL.PARSE(l_cur_hdl, l_sql, 1, 3, FALSE, DBMS_SQL.NATIVE);
            -- Define the columns in the select statement
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 1, l_Property);
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 2, l_Low_Limit);
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 3, l_High_Limit);
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 4, l_Low_Spec);
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 5, l_High_Spec);
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 6, l_Low_Dev);
            DBMS_SQL.DEFINE_COLUMN_CHAR(l_cur_hdl, 7, l_Rel_Low_Dev, 1);
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 8, l_Target_fl);
            DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 9, l_High_dev);
            DBMS_SQL.DEFINE_COLUMN_CHAR(l_cur_hdl, 10, l_Rel_High_dev, 1);
            DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':a_Part_No', a_Part_No);
            DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':a_Revision', a_Revision);
            DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':a_Property', a_Property_tab(i));
            DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':a_PropertyGroup', a_PropertyGroup);
            DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':a_SectionID', a_SectionID_tab(i));
            DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':a_SubSectionID', a_SubSectionID_tab(i));
            DBMS_SQL.BIND_VARIABLE(l_cur_hdl, ':a_Attribute', a_Attribute_tab(i));
            -- Execute the select statement, the function returns
            -- the number of rows that are fetched
            l_return_value := DBMS_SQL.EXECUTE_AND_FETCH(l_cur_hdl);
            IF l_return_value = 0 THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer the specification data of the link between a parameter and '||l_object||
                             ' because the values can not be retrieved.');
               -- Close the cursor
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Get the value of the columns
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 1, l_Property);
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 2, l_Low_Limit);
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 3, l_High_Limit);
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 4, l_Low_Spec);
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 5, l_High_Spec);
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 6, l_Low_Dev);
            DBMS_SQL.COLUMN_VALUE_CHAR(l_cur_hdl, 7, l_Rel_Low_Dev);
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 8, l_Target_fl);
            DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 9, l_High_dev);
            DBMS_SQL.COLUMN_VALUE_CHAR(l_cur_hdl, 10, l_Rel_High_dev);
            l_Low_Limit_tab(i) := l_Low_Limit;
            l_High_Limit_tab(i) := l_High_Limit;
            l_Low_Spec_tab(i) := l_Low_Spec;
            l_High_Spec_tab(i) := l_High_Spec;
            l_Low_Dev_tab(i) := l_Low_Dev;
            l_Rel_Low_Dev_tab(i) := l_Rel_Low_Dev;
            l_Target_fl_tab(i) := l_Target_fl;
            l_High_dev_tab(i) := l_High_dev;
            l_Rel_High_dev_tab(i) := l_Rel_High_dev;
            
            -- Check if there is more than one value for the specification data
            l_return_value := DBMS_SQL.FETCH_ROWS(l_cur_hdl);
            IF l_return_value <> 0 THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer the specification data of the link between a parameter and '||l_object||
                             ' because the specification data has more than one value.');
               -- Close the cursor
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Generate the parameter definition id, version and description, 
            -- based on the highest revision of the property.
            l_sp_revision := PA_LIMS.f_GetHighestRevision('property', a_Property_tab(i));
            IF a_attribute_tab(i) = 0 THEN
               l_sp_desc := f_sph_descr(1,a_property_tab(i),0);
            ELSE
               l_sp_desc := f_sph_descr(1,a_property_tab(i),0)||' '||f_ath_descr(1,a_attribute_tab(i),0);
            END IF;
            l_PrId := PA_LIMS.f_GetPrId(a_Property_tab(i), l_sp_revision, a_attribute_tab(i), 
                                        l_sp_desc, l_pr_desc);

            -- Save in arrays, the transfer happens later
            l_pr_tab(i)           := l_PrId;
            l_pppr_version_tab(i) := '~Current~';

            -- Close the cursor
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END LOOP;

         -- Execute once, but only if necessary, this is only if there are objects to transfer.
         IF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(a_nr_of_rows, 0) = 0) THEN
            -- Transfer the specification data of the link between the parameter definition 
            -- and the parameterprofile
            BEGIN
               IF NOT f_TransferSpcPpPrSp(a_PpId, a_version, a_pp_key1, a_pp_key2, a_pp_key3, 
                                          a_pp_key4, a_pp_key5, l_pr_tab, l_pppr_version_tab, 
                                          l_Low_Limit_tab, l_High_Limit_tab, l_Low_Spec_tab, 
                                          l_High_Spec_tab, l_Low_Dev_tab, l_Rel_Low_Dev_tab, 
                                          l_Target_fl_tab, l_High_dev_tab, l_Rel_High_dev_tab, 
                                          a_nr_of_rows, l_specset) THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  -- Log an error in ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to transfer the specification data of the link between '||
                                ' the parameters and '||l_object||' : '||SQLERRM);
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
            END;
         END IF;
      END LOOP;
      
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Ppid||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
               'Unable to transfer the specification data of the links between the parameters and '||l_object||' : '||SQLERRM);
         -- Close the cursor if the cursor is still open
         IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcAllPpPrSp;

   FUNCTION f_TransferSpcAllPpPr(
      a_StId                IN     VARCHAR2,
      a_version             IN OUT VARCHAR2,
      a_sh_revision         IN     NUMBER,
      a_Part_No             IN     specification_header.part_no%TYPE,
      a_Revision            IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The links between properties and property groups (used in sections) are links 
      -- between parameter definitions and parameterprofiles in Unilab. The function
      -- transfers all links to Unilab if they have the following characteristics:
      --    - The property must belong to a property group
      --    - The property group must belong to the specification
      --    - The property group uses a display format that is set up for LIMS
      --      assigned to a parameter profile to Unilab.
      -- ** Parameters **
      -- a_st               : sampletype
      -- a_version          : version of the sampletype
      -- a_sh_revision      : revision of the specification, to base the parameterprofile version on
      -- a_part_no          : part_no of the specification
      -- a_revision         : revision of the specification
      -- ** Information **
      -- -  All properties assigned to a property group / single properties
      --    are transferred if the parameters are not filled in.
      -- ** Return **
      -- TRUE  : The transfer of the link has succeeded.
      -- FALSE : The transfer of the link has failed.
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname        CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method           CONSTANT VARCHAR2(32)                      := 'f_TransferSpcAllPpPr';

      -- General variables
      l_pr_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_pr_version_tab   UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_tab           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_mt_version_tab   UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_nr_of_pr         NUMBER;
      l_PrevPg           NUMBER(6);
      l_PrevPgRev        NUMBER(4);
      l_PrevPp           VARCHAR2(20);
      l_PrevPpVersion    VARCHAR2(20);
      l_PrevSc_tab       UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_PrevSsc_tab      UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_prop_tab         UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;
      l_att_tab          UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;

      l_PP_Template      VARCHAR2(20);
      l_PpId             VARCHAR2(20);
      l_pp_version       VARCHAR2(20);
      l_pp_desc          VARCHAR2(40);
      l_pg_revision      NUMBER;
      l_PrId             VARCHAR2(20);
      l_pr_version       VARCHAR2(20);
      l_pr_version2      VARCHAR2(20);
      l_prmt_version     VARCHAR2(20);
      l_pppr_version     VARCHAR2(20);
      l_pr_desc          VARCHAR2(40);
      l_sp_revision      NUMBER;
      l_sp_desc          VARCHAR2(130);
      l_MtId             VARCHAR2(20) DEFAULT NULL;
      l_ppprmt_version   VARCHAR2(20);
      l_mt_desc          VARCHAR2(40);
      l_tm_revision      NUMBER;
      l_PR_Template      VARCHAR2(20);
      l_MT_Template      VARCHAR2(20);
      l_orig_name        VARCHAR2(40);
      l_linked_part_no   specification_header.part_no%TYPE;

      -- Cursor to get all the links between properties and property groups that have to be send
      -- to Unilab as a link between a parameter definition and a parameterprofile.
      CURSOR l_PpPrToTransfer_Cursor(
         c_Part_No    specification_header.part_no%TYPE,
         c_Revision   specification_header.revision%TYPE
      )
      IS
         SELECT DISTINCT ivpgpr.property_group, ivpgpr.property_group_rev,
                         ivpgpr.property, ivpgpr.section_id,
                         ivpgpr.sub_section_id, ivpgpr.test_method,
                         f_sph_descr(1, ivpgpr.property, 0) sp_desc,
                         f_ath_descr(1, ivpgpr.attribute, 0) at_desc,
                         ivpgpr.attribute, ivpgpr.sequence_no,
                         f_pgh_descr(1, ivpgpr.property_group, 0) pg_desc,
                         f_mth_descr(1, ivpgpr.test_method, 0) tm_desc
                    FROM itlimsconfly limsc, ivpgpr
                   WHERE ivpgpr.display_format = limsc.layout_id
                     AND ivpgpr.display_format_rev = limsc.layout_rev
                     AND ivpgpr.type = 1
                     AND ivpgpr.part_no = c_Part_No
                     AND ivpgpr.revision = c_Revision
                     AND limsc.un_object IN ('PR', 'PPPR')
                ORDER BY ivpgpr.property_group, ivpgpr.section_id, 
                         ivpgpr.sub_section_id, ivpgpr.sequence_no;

   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_stid||' | '||a_version, a_sh_revision, a_part_no||' | '||a_revision,
                      PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_nr_of_pr      := 0;
      l_PrevPg        := -1;
      l_PrevPgRev     := -1;
      l_PrevPp        := ' ';
      l_PrevPpVersion := ' ';
      l_pppr_version  := '~Current~';

      -- Transfer all the links between the parameter definitions and the parameterprofile to Unilab
      FOR l_PpPrToTransfer_Rec IN l_PpPrToTransfer_Cursor(a_Part_No, a_Revision) LOOP
         BEGIN
            -- Generate the parameter profile id, version and description,
            -- based on the highest revision of the property group
            l_pg_revision := PA_LIMS.f_GetHighestRevision('property_group', l_PpPrToTransfer_Rec.property_group);
            -- Only for a linked specification, the parameterprofile description should start with the part_no
            IF a_stid <> a_part_no THEN
               l_linked_part_no := a_part_no;
            END IF;
            l_PpId := PA_LIMS.f_GetPpId(l_linked_part_no, l_PpPrToTransfer_Rec.property_group, l_pg_revision,
                                        l_PpPrToTransfer_Rec.pg_desc, l_pp_desc);
            l_pp_version := UNVERSION.CONVERTINTERSPEC2UNILABPP@LNK_LIMS(l_ppid, PA_LIMS.g_pp_key(1), PA_LIMS.g_pp_key(2), 
                                                                         PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), 
                                                                         PA_LIMS.g_pp_key(5), a_sh_revision);

            -- Initialize variables on the first time the loop is run
            IF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, -1) = 1) THEN
               l_PrevPg        := l_PpPrToTransfer_Rec.property_group;
               l_PrevPgRev     := l_PpPrToTransfer_Rec.property_group_rev;
               l_PrevPp        := l_PpId;
               l_PrevPpVersion := l_pp_version;
               l_nr_of_pr      := l_nr_of_pr + 1;
            -- Only transfer when property group changes
            ELSIF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, l_PpPrToTransfer_Rec.property_group) = 0) THEN
               -- Transfer the link between the parameter definition and the parameterprofile
               l_PP_Template := GetTemplete4PropertyGroup(a_part_no, a_Revision, l_PrevPg, l_PrevPgRev);
               IF f_TransferSpcPpPr(l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), PA_LIMS.g_pp_key(2), 
                                    PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), PA_LIMS.g_pp_key(5), 
                                    l_pr_tab, l_pr_version_tab, l_mt_tab, l_mt_version_tab, l_nr_of_pr, l_PP_Template) THEN
                  -- Transfer the specification data of the link between the parameter definition
                  -- and the parameterprofile
                  IF NOT f_TransferSpcAllPpPrSp(l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), 
                                                PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3),
                                                PA_LIMS.g_pp_key(4), PA_LIMS.g_pp_key(5), a_Part_No, 
                                                a_Revision,  l_PrevPg, 
                                                l_PrevSc_tab, l_PrevSsc_tab, 
                                                l_prop_tab, l_att_tab,
                                                l_nr_of_pr) THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     RETURN (FALSE);
                  END IF;
               ELSE
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               END IF;

               l_PrevPg        := l_PpPrToTransfer_Rec.property_group;
               l_PrevPgRev     := l_PpPrToTransfer_Rec.property_group_rev;
               l_PrevPp        := l_PpId;
               l_PrevPpVersion := l_pp_version;
               l_nr_of_pr      := 1;
            ELSE
               l_nr_of_pr := l_nr_of_pr + 1;
            END IF;
            
            -- Generate the parameter definition id, version and description,
            -- based on the highest revision of the property
            l_sp_revision := PA_LIMS.f_GetHighestRevision('property', l_PpPrToTransfer_Rec.Property);
            IF l_PpPrToTransfer_Rec.Attribute = 0 THEN
               l_sp_desc := l_PpPrToTransfer_Rec.sp_desc;
               l_orig_name := l_PpPrToTransfer_Rec.Property;
            ELSE
               l_sp_desc := l_PpPrToTransfer_Rec.sp_desc||' '||l_PpPrToTransfer_Rec.at_desc;
               l_orig_name := RPAD(l_PpPrToTransfer_Rec.Property,10,' ')||l_PpPrToTransfer_Rec.Attribute;
            END IF;
            l_PrID := PA_LIMS.f_GetPrID(l_PpPrToTransfer_Rec.Property, l_sp_revision, l_PpPrToTransfer_Rec.Attribute,
                                        l_sp_desc, l_pr_desc);
            l_pr_version := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('pr', l_prid, l_sp_revision);
            l_pr_version2 := l_pr_version;

            -- Check if the method definition linked to the parameterprofile-parameter link has to be transferred
            -- Generate the method definition id, version and description,
            -- based on the highest revision of the test method
            IF PA_LIMS.f_GetSettingValue('Transfer PPPR MT') = 1 THEN
               l_tm_revision := PA_LIMS.f_GetHighestRevision('test_method', l_PpPrToTransfer_Rec.test_method);
               l_MtId := PA_LIMS.F_GetMtID(l_PpPrToTransfer_Rec.test_method, l_tm_revision,
                            l_PpPrToTransfer_Rec.tm_desc, l_mt_desc);
               l_ppprmt_version := '~Current~';
            ELSE
               l_MtId := NULL;
               l_tm_revision := NULL;
               l_ppprmt_version := NULL;
            END IF;

            -- Save in arrays, the transfer happens later
            l_pr_tab(l_nr_of_pr)         := l_PrID;
            l_pr_version_tab(l_nr_of_pr) := l_pppr_version;
            l_mt_tab(l_nr_of_pr)         := l_MtId;
            l_mt_version_tab(l_nr_of_pr) := l_ppprmt_version;
            l_PrevSc_tab(l_nr_of_pr)     := l_PpPrToTransfer_Rec.section_id;
            l_PrevSsc_tab(l_nr_of_pr)    := l_PpPrToTransfer_Rec.sub_section_id;
            l_prop_tab(l_nr_of_pr)       := l_PpPrToTransfer_Rec.property;
            l_att_tab(l_nr_of_pr)        := l_PpPrToTransfer_Rec.attribute;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer the link between the parameters'||
                             ' and parameterprofile "'||l_PpID||'" | version='||l_pp_version||' | pp_keys="'||
                             PA_LIMS.g_pp_key(1)||'"#"'||PA_LIMS.g_pp_key(2)||'"#"'||PA_LIMS.g_pp_key(3)||'"#"'||
                             PA_LIMS.g_pp_key(4)||'"#"'||PA_LIMS.g_pp_key(5)||'" : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      END LOOP;
      
      -- Execute once for the last propertygroup, but only if necessary.
      IF (PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_PrevPg, -1) = 0) THEN
         BEGIN
            -- Transfer the link between the parameter definition and the parameterprofile
            l_PP_Template := GetTemplete4PropertyGroup(a_part_no, a_Revision, l_PrevPg, l_PrevPgRev);
            IF f_TransferSpcPpPr(l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), PA_LIMS.g_pp_key(2), 
                                 PA_LIMS.g_pp_key(3), PA_LIMS.g_pp_key(4), PA_LIMS.g_pp_key(5), 
                                 l_pr_tab, l_pr_version_tab, l_mt_tab, l_mt_version_tab, l_nr_of_pr, l_PP_Template) THEN
               -- Transfer the specification data of the link between the parameter definition
               -- and the parameterprofile
               IF NOT f_TransferSpcAllPpPrSp(l_PrevPp, l_PrevPpVersion, PA_LIMS.g_pp_key(1), 
                                             PA_LIMS.g_pp_key(2), PA_LIMS.g_pp_key(3),
                                             PA_LIMS.g_pp_key(4), PA_LIMS.g_pp_key(5), a_Part_No, 
                                             a_Revision, l_PrevPg, 
                                             l_PrevSc_tab, l_PrevSsc_tab, 
                                             l_prop_tab, l_att_tab,
                                             l_nr_of_pr) THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
               END IF;
            ELSE
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to transfer the link between the parameters'||
                             ' and parameterprofile "'||l_PpID||'" | version='||l_pp_version||' | pp_keys="'||
                             PA_LIMS.g_pp_key(1)||'"#"'||PA_LIMS.g_pp_key(2)||'"#"'||PA_LIMS.g_pp_key(3)||'"#"'||
                             PA_LIMS.g_pp_key(4)||'"#"'||PA_LIMS.g_pp_key(5)||'" : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
         END;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_stid||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the links between parameters and parameterprofiles for plant "'||
                       PA_LIMS.f_ActivePlant||'" : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_TransferSpcAllPpPr;

   FUNCTION f_GetStandardAuValue(
      a_StandardAu   IN VARCHAR2,
      a_Part_No      IN specification_header.part_no%TYPE,
      a_Revision     IN specification_header.revision%TYPE
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the value for a standard attribute of a sample type
      -- ** Parameters **
      -- a_standardau : standard attribute name
      -- a_part_no    : part_no of the specification
      -- a_revision   : revision of the specification 
      -- ** Return **
      -- The value for the standard attribute
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_GetStandardAuValue';

      -- General variables
      l_standardAuValueKW         VARCHAR2(40);
      l_standardAuValueProperty   VARCHAR2(40);
      l_counter                   NUMBER;
      -- Variable to save the values of the dynamic SQL
      l_Property                  NUMBER;
      l_Description               VARCHAR(60);
      l_Value                     VARCHAR2(120);
      -- Dynamic SQL
      l_cur_hdl                   INTEGER;
      l_return_value              INTEGER;
      l_sql                       DBMS_SQL.varchar2s;

      -- Cursor to get the value of the keyword that is configured as
      -- standard attribute
      CURSOR l_get_keyword_value_cursor(
         c_StandardAu   itlimsconfkw.un_id%TYPE,
         c_Part_No      specification_header.part_no%TYPE
      )
      IS
         SELECT kw_value
           FROM itlimsconfkw cfg, specification_kw kw
          WHERE kw.kw_id = cfg.kw_id
            AND un_id = c_StandardAu
            AND part_no = c_Part_No;

      -- Cursor to get the value of the property that is configured as
      -- standard attribute
      CURSOR l_get_property_value_cursor(
         c_StandardAu   itlimsconfkw.un_id%TYPE,
         c_Part_No      specification_header.part_no%TYPE,
         c_Revision     specification_header.revision%TYPE
      )
      IS
         SELECT limsc.is_col, limsc.property, ref_id, sps.section_id,
                sps.sub_section_id
           FROM specification_section sps,
                specification_prop spp,
                itlimsconfly limsc
          WHERE sps.part_no = spp.part_no
            AND sps.revision = spp.revision
            AND sps.section_id = spp.section_id
            AND sps.sub_section_id = spp.sub_section_id
            AND sps.display_format = limsc.layout_id
            AND sps.display_format_rev = limsc.layout_rev
            AND spp.property = limsc.property
            AND limsc.un_object = 'ST'
            AND limsc.un_type = 'STANDARD AU'
            AND limsc.un_id = c_StandardAu
            AND sps.part_no = c_Part_No
            AND sps.revision = c_Revision;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_part_no||' | '||a_revision, a_standardau, NULL, PA_LIMS.c_Msg_Started);

      -- Get the value of the keyword that is configured as standard attribute
      l_counter := 0;
      FOR l_get_keyword_value_rec IN l_get_keyword_value_cursor(a_StandardAu, a_Part_No) LOOP
         l_counter := l_counter + 1;
         l_standardAuValueKW := l_get_keyword_value_rec.kw_value;
      END LOOP;

      -- If there is more then one keyword configured for the standard attribute and
      -- the keywords are used in the specification
      IF l_counter > 1 THEN
         l_standardAuValueKW := NULL;
      END IF;

      -- Get the value of the property
      l_counter := 0;
      FOR l_get_property_value_rec IN l_get_property_value_cursor(a_StandardAu, a_Part_No, a_Revision) LOOP
         l_counter := l_counter + 1;
         -- Open the cursor
         l_cur_hdl := DBMS_SQL.Open_Cursor;
         -- Create the dynamic Select statement
         l_sql(1) := 'SELECT p.property, p.description, '||l_get_property_value_rec.is_col||
                     ' FROM specification_prop sp, property p ';
         l_sql(2) := ' WHERE sp.property    = p.property AND p.property = '||l_get_property_value_rec.property||
                     '   AND part_no        = '''||a_Part_No||
                     ''' AND revision       = '||a_Revision||
                     '   AND ';
         l_sql(3) := '       property_group = '||l_get_property_value_rec.ref_id||
                     '   AND section_id     = '||l_get_property_value_rec.section_id||
                     '   AND sub_section_id = '||l_get_property_value_rec.sub_section_id;
         -- Set the SQL statement
         DBMS_SQL.PARSE(l_cur_hdl, l_sql, 1, 3, FALSE, DBMS_SQL.NATIVE);
         -- Define the columns in the select statement
         DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 1, l_Property);
         DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 2, l_Description, 60);
         DBMS_SQL.DEFINE_COLUMN(l_cur_hdl, 3, l_Value, 120);
         -- Execute the select statement, the function returns
         -- the number of rows that are fetched
         l_return_value := DBMS_SQL.EXECUTE_AND_FETCH(l_cur_hdl);

         IF l_return_value = 0 THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to get the value of the property "'||l_Property||'".');
            -- Close the cursor
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         ELSE
            -- Transfer the specification data of all the links between 
            -- the properties and the property group
            LOOP
               -- Get the value of the columns
               DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 1, l_Property);
               DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 2, l_Description);
               DBMS_SQL.COLUMN_VALUE(l_cur_hdl, 3, l_Value);
               l_standardAuValueProperty := l_Value;
               -- Get the values of the next property
               l_return_value := DBMS_SQL.FETCH_ROWS(l_cur_hdl);
               EXIT WHEN l_return_value = 0;
            END LOOP;
         END IF;

         -- Close the cursor if not yet closed
         IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END IF;
      END LOOP;

      -- If there is more than one property configured for the standard attribute and
      -- the property is used in the specification
      IF l_counter > 1 THEN
         l_standardAuValueProperty := NULL;
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);

      IF PA_LIMS.f_GetSettingValue('Master Standard Au') = 'KEYWORD' THEN
         IF NOT l_standardAuValueKW IS NULL THEN
            RETURN (l_standardAuValueKW);
         ELSE
            RETURN (l_standardAuValueProperty);
         END IF;
      ELSE
         IF NOT l_standardAuValueProperty IS NULL THEN
            RETURN (l_standardAuValueProperty);
         ELSE
            RETURN (l_standardAuValueKW);
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to get the value of the standard attribute "'||a_StandardAu||'" for the specification "'||
                       a_Part_No||'" | revision='||a_revision||' : '||SQLERRM);
         -- Close the cursor if the cursor is still open
         IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
            DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (NULL);
   END f_GetStandardAuValue;

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
   BEGIN
      RETURN(PA_LIMSSPC2.f_TransferSpcUsedAu(a_tp, a_used_tp, a_id, a_version, a_used_id, a_used_version, a_au, a_value));
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
   BEGIN
      RETURN(PA_LIMSSPC2.f_TransferSpcStPpAu(a_st, a_version, a_pp, a_pp_version, a_pp_key1, a_pp_key2, a_pp_key3,
                                             a_pp_key4, a_pp_key5, a_au_tab, a_value_tab, a_nr_of_rows));
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
   BEGIN
      RETURN(PA_LIMSSPC2.f_TransferSpcPpPrAu(a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5,
                                             a_pr, a_pr_version, a_au_tab, a_value_tab,
                                             a_nr_of_rows));
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
   BEGIN
      RETURN(PA_LIMSSPC2.f_TransferSpcAllPpPrAu(a_st, a_version, a_sh_revision, a_part_no, a_revision));
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
   BEGIN
      RETURN(PA_LIMSSPC2.f_TransferSpcAllPpPrAu_AttSp(a_part_no, a_revision, a_SectionId_tab, a_SubSectionId_tab, a_nr_of_rows, 
                                                      a_propertygroup, a_ppid, a_pp_version, a_pp_key1, a_pp_key2, a_pp_key3, 
                                                      a_pp_key4, a_pp_key5));
   END f_TransferSpcAllPpPrAu_AttSp;

   FUNCTION f_ObsoletionTransitionPresent(
      a_st           IN     VARCHAR2,
      a_version      IN     VARCHAR2
   )
      RETURN BOOLEAN
   IS
   l_lc               VARCHAR2(20);
   l_ss_from          VARCHAR2(2);
   l_count            INTEGER;
   BEGIN
      BEGIN
         SELECT lc, ss
         INTO l_lc, l_ss_from
         FROM UVST@LNK_LIMS
         WHERE st = a_st
           AND version = a_version;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         BEGIN
            --can happen when a new revision is made in Interspec , and obsolete turned on
            --the spec is not transferred but the obsoletion must take place
            --(Bug AP00342746)
            SELECT lc, ss
            INTO l_lc, l_ss_from
            FROM UVST@LNK_LIMS
            WHERE st = a_st
              AND version = (SELECT MAX(version) 
                             FROM UVST@LNK_LIMS
                             WHERE st = a_st);         
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RETURN(FALSE);
         END;
      END;
      
      SELECT count(*)
      INTO l_count
      FROM UVLCTR@LNK_LIMS
      WHERE lc = l_lc
        AND ss_from IN (l_ss_from, '@@')
        AND condition = 'Obsolete4Interspec';
        
      IF l_count > 0 THEN
         RETURN(TRUE);
      ELSE
         RETURN(FALSE);
      END IF;      
   END;
   
   FUNCTION f_MakePartObsolete4Plant(
      a_Part_No    IN specification_header.part_no%TYPE,
      a_Revision   IN specification_header.revision%TYPE
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Make one specification obsolete in Unilab.
      -- ** Parameters **
      -- a_part_no   : part_no of the specification
      -- a_revision  : revision of the specification
      -- ** Return **
      -- TRUE : The specification is obsoleted Unilab
      -- FALSE: The specification is not obsoleted in Unilab
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_MakePartObsolete4Plant';
      l_object       VARCHAR2(255);

      -- General variables
      l_StId                        VARCHAR2(20);
      l_st_version                  VARCHAR2(20);
      l_sh_revision                 NUMBER;
      l_planned_effective_date      DATE             DEFAULT NULL;
      l_result                      BOOLEAN          DEFAULT TRUE;
      l_LinkedSpecification         BOOLEAN          DEFAULT FALSE;
      l_Generic_Part_No             VARCHAR2(20);
      l_Generic_Revision            NUMBER(8);
      l_Description                 VARCHAR2(60);
      l_ret                         NUMBER;
      l_nr_of_occurences            NUMBER;
      l_linked_key_index            NUMBER;
      l_linked_key                  CHAR(1);
      l_obsolete_part               CHAR(1);
      l_ret_code                    INTEGER;
      l_orig_version_is_current     CHAR(1);
      l_orig_allow_modify           CHAR(1);
      l_orig_active                 CHAR(1);
      l_plantgk_must_be_deleted     BOOLEAN;
      l_countplant_not_obsolete     INTEGER;
      l_list_of_obsolete_plants     VC20_TABLE_TYPE;
      l_nr_of_obsolete_plants       NUMBER;
      l_send_event                  BOOLEAN;
      l_ref_version                 VARCHAR2(20);

      -- Specific local variables for the 'SaveSystemDefault' API
      l_setting_name         VARCHAR2(20);
      l_update_setting       BOOLEAN                           DEFAULT TRUE;
      l_setting_name_tab     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_setting_value_tab    UNAPIGEN.VC255_TABLE_TYPE@LNK_LIMS;
      l_nr_of_rows           NUMBER;
      l_modify_reason        VARCHAR2(255);
      
      -- Specific local variables for the 'f_TransferSpcStGk' API
      l_gk_tab             UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_gk_version_tab     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab          UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      
      --Specific local variables for InsertEvent
      l_api_name                    VARCHAR2(40);
      l_evmgr_name                  VARCHAR2(20);
      l_object_tp                   VARCHAR2(4);
      l_object_id                   VARCHAR2(20);
      l_object_lc                   VARCHAR2(2);
      l_object_lc_version           VARCHAR2(20);
      l_object_ss                   VARCHAR2(2);
      l_ev_tp                       VARCHAR2(60);
      l_ev_details                  VARCHAR2(255);
      l_seq_nr                      NUMBER;

      -- Exceptions
      l_EXC_TRANSFER                EXCEPTION;

      -- Cursor to get the data of the specification
      CURSOR l_StToTransfer_Cursor(
         c_Part_No    specification_header.part_no%TYPE,
         c_Revision   specification_header.revision%TYPE
      )
      IS
         SELECT sph.part_no, sph.revision, sph.planned_effective_date,
                f_part_descr(1, sph.part_no) description, sph.class3_id
           FROM specification_header sph
          WHERE sph.part_no  = c_Part_No
            AND sph.revision = c_Revision;

      -- Cursor to check if the specification is a linked specification
      CURSOR l_LinkedSpec_Cursor(
         c_Part_No         specification_header.part_no%TYPE,
         c_Revision        specification_header.revision%TYPE,
         c_KwIdGenericSp   itkw.kw_id%TYPE
      )
      IS
         SELECT asp.attached_part_no,
                DECODE(
                   asp.attached_revision,
                   0, F_Rev_Part_Phantom(asp.attached_part_no, 0), -- the attached specification is a phantom (Always take the highest current revision)
                   asp.attached_revision
                ) attached_revision
           FROM specification_kw spk, attached_specification asp
          WHERE spk.part_no = asp.attached_part_no
            AND kw_id = c_KwIdGenericSp
            AND asp.part_no = c_Part_No
            AND asp.revision = c_Revision;

      -- Cursor to get all existing versions of the sampletype in Unilab
      CURSOR l_st_versions_cursor(c_st VARCHAR2)
      IS
         SELECT version
         FROM UVST@LNK_LIMS
         WHERE st = c_st
         ORDER BY version DESC;

      -- Cursor to get the revision of the generic specification from Interspec and Unilab
      CURSOR l_GenericSpec_Cursor(c_Part_No   specification_header.part_no%TYPE)
      IS
         SELECT revision
           FROM specification_header
          WHERE part_no = c_Part_No
            AND status = 4; -- current !

      -- Cursor to get the revision of the generic specification from Unilab
      CURSOR l_GenericSpecUnilab_Cursor(c_Part_No   specification_header.part_no%TYPE)
      IS
         SELECT revision, status
           FROM specification_header
          WHERE part_no = c_Part_No
       ORDER BY revision DESC;

      -- Cursor to check if a higher generic revision than the current exists
      CURSOR l_HighestGenRevision_Cursor (c_generic_part_no    specification_header.part_no%TYPE,
                                          c_generic_revision   specification_header.revision%TYPE)
      IS
         SELECT COUNT(*) nr
           FROM specification_header
          WHERE part_no  = c_generic_part_no
            AND revision > c_generic_revision; 

      -- Cursor to check if the type of the specification can be transferred 
      CURSOR lvq_getspecs
      IS
         SELECT *
           FROM interspc_cfg
          WHERE section = 'U4 INTERFACE'
            AND parameter like 'SPECTYPE%'
          ORDER BY parameter;

      -- Cursor to get the part_type of the specification
      CURSOR lvq_getspectype (c_Part_No specification_header.part_no%TYPE)
      IS
         SELECT *
           FROM part
          WHERE part_no = c_Part_No;
           
     -- Cursor to get the description of the value of the Interspec system setting 'KW ID Generic Spc'
     CURSOR l_kw_cursor(c_kw_id NUMBER)
     IS
        SELECT description
          FROM itkw
         WHERE kw_id = c_kw_id;

      -- Cursor to get all plants that have the same connection string and language id's as the given plant
      -- and that are marked as obsolete
      CURSOR l_partobsoleteplants_cursor(c_plant      plant.plant%TYPE, 
                                         c_part_no    specification_header.part_no%TYPE)
      IS
         SELECT a.*
           FROM itlimsplant a, part_plant pp
          WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                   (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                      FROM itlimsplant b
                     WHERE b.plant = c_plant)
            AND a.plant = pp.plant
            AND pp.part_no = c_part_no
            AND pp.obsolete = '1';

      -- Cursor to check if a specification is a generic specification
      CURSOR l_gen_cursor(c_part_no   specification_header.part_no%TYPE)
      IS
         SELECT part_no
           FROM interspc_cfg cfg, specification_kw kw
          WHERE cfg.section        = 'U4 INTERFACE'
            AND cfg.parameter      = 'KW ID Generic Spc'
            AND cfg.parameter_data = kw.kw_id
            AND kw.kw_value        = 'Yes'
            AND kw.part_no         = c_part_no;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Part_No||' | '||a_Revision, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'part_no "'||a_part_no||'" | revision='||a_revision;
      

/* TO REVIEW START */
      -- Check if a specification is a generic specification
      FOR l_gen_rec IN l_gen_cursor(a_part_no) LOOP
         -- Set the value of the Unilab system setting 'STGK ID Generic St', if it does not correspond
         -- anymore with the value of the Interspec setting 'KW ID Generic Spc'.
         l_setting_name := 'STGK ID Generic St';
         l_nr_of_rows := 1;
         -- Get the Interspec setting
         FOR l_kw_rec IN l_kw_cursor(PA_LIMS.f_GetSettingValue('KW ID Generic Spc')) LOOP
            l_setting_value_tab(l_nr_of_rows) := PA_LIMS.f_GetGkId(l_kw_rec.description);
            -- Get the Unilab setting
            FOR l_system_rec IN g_system_cursor(l_setting_name) LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_system_rec.setting_value, PA_LIMS.f_GetGkId(l_kw_rec.description)) = 1 THEN
                  l_update_setting := FALSE;
               END IF;
            END LOOP;
         END LOOP;
      END LOOP;
/* TO REVIEW END */

      -- Set the default values for the generic specification. These default
      -- values are only overruled if there is a linked specification
      l_Generic_Part_No  := a_Part_No;
      l_Generic_Revision := a_Revision;

      -- Check if the specification is a linked specification
      FOR l_LinkedSpec_Rec IN l_LinkedSpec_Cursor(a_Part_No, a_Revision, PA_LIMS.f_GetSettingValue('KW ID Generic Spc')) LOOP
         -- Indicate that it's a linked specification
         l_LinkedSpecification := TRUE;

         -- Overrule the default values for the generic specification
         l_Generic_Part_No  := l_LinkedSpec_Rec.Attached_Part_No;
         l_Generic_Revision := -1;

         -- Loop all Unilab versions of this specification
         FOR l_st_versions_rec IN l_st_versions_cursor(l_Generic_Part_No) LOOP
            -- When a linked specification, get the revision of the attached generic specification,
            -- not the attached revision!
            -- Retrieve the revision of the linked specification as known by
            -- Interspec and Unilab.
            FOR l_GenericSpec_Rec IN l_GenericSpec_Cursor(l_Generic_Part_No) LOOP
               IF UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_Generic_Part_No, l_GenericSpec_Rec.revision) 
                  = l_st_versions_rec.version THEN
                     l_Generic_Revision := l_GenericSpec_Rec.Revision;
               END IF;
            END LOOP;

            -- Fetch current revision in Unilab !
            IF l_Generic_Revision = -1 THEN
               -- Get the revision number out of Unilab (do not look in Interspec)
               FOR l_GenericSpecUnilab_Rec IN l_GenericSpecUnilab_Cursor(l_Generic_Part_No) LOOP
                  IF UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_Generic_Part_No, l_GenericSpecUnilab_Rec.revision) 
                     = l_st_versions_rec.version THEN
                     l_Generic_Revision := l_GenericSpecUnilab_Rec.revision;
                  END IF;
               END LOOP;
            END IF;
         END LOOP;

         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                         'Linked specification of generic specification "'||l_Generic_Part_No||'" | revision='||
                         l_Generic_Revision);

         -- If spec doesn't need to be transferred, then following loggings are rather confusing.
         IF f_ToBeTransferred(a_part_no, a_revision, SUBSTR(l_Generic_Part_No,1,20), l_Generic_Revision) THEN
            -- Check if the generic specification was found. If not the user is trying to transfer a 
            -- linked specification before the generic specification was sent, this is not allowed !
            IF l_Generic_Revision = -1 THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to find in Unilab the generic specification with part_no "'||l_generic_part_no||
                             '" of linked specification with '||l_object||'.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Check if a higher generic revision than the current exists. If so, warn the user.
            FOR l_HighestGenRevision_rec IN l_HighestGenRevision_Cursor(l_generic_part_no,l_generic_revision) LOOP
               IF l_HighestGenRevision_rec.nr > 0 THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Linked specification with '||l_object||
                                ' will be attached to the current generic specification with part_no "'||l_generic_part_no||
                                '" | revision='||l_generic_revision||
                                '. Be aware that a higher revision of this generic specification already exists.');
               END IF;
            END LOOP;
         END IF;
      END LOOP;
      
      BEGIN
         -- Generate the sampletype id and version, and the parameterprofile version
         l_StId := SUBSTR(l_Generic_Part_No, 1, 20);
         l_st_version := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_stid, l_Generic_Revision);
         -- For linked specs, the pp_version has to be derived from the revision of the
         -- linked specification, not from the revision of the generic specification
         IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_generic_part_no, a_part_no) = 1 THEN
            l_sh_revision := l_Generic_revision;
         ELSE
            l_sh_revision := a_revision;
         END IF;
         
         -- Check if spec needs to be transferred
         IF f_ToBeTransferred(a_part_no, a_revision, l_StId, l_Generic_Revision) THEN
            -- Log the contents of the sampletype
            PA_LIMS.p_TraceSt(l_StId, l_st_version);

            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Sample type "'||l_stid||'" | version='||l_st_version);

            --check in its life cycle that the transition from the actual status to any status and back to the original status with special conditions:Obsolete4Interspec
            IF NOT f_ObsoletionTransitionPresent(l_stid,l_st_version) THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Sample type marked for obsoletion but life cycle is not ok in Unilab for obsoletion. skipping.');
               -- we do nothing, do not log anything and mark as updated
               --will be hard to trace, but no other options
               RETURN (TRUE);               
            END IF;

            -------------------------------------------------------------------------
            -- BEGIN 05/11/2002

            -- Set the pp keys
            IF NOT PA_LIMS.f_SetPpKeys(a_part_no, a_revision, l_StId) THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to set the parameterprofile keys.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Find the plant pp_key can be found for all specs
            -- Initialize variable
            l_nr_of_rows := 0;
            l_nr_of_obsolete_plants := 0;
            FOR i IN 1..5 LOOP
               -- Check if this pp_key is the plant pp_key
               IF INSTR(LOWER(PA_LIMS.g_pp_key_name(i)),'plant') > 0 THEN
                  -- Delete sampletype groupkey with value = <plant> 
                  -- for all plants that have the same connection string and language id as the active plant
                  --and that are marked as obsolete
                  FOR l_plant_rec IN l_partobsoleteplants_cursor(PA_LIMS.f_ActivePlant, a_part_no) LOOP
                  
                     --the plant has been marked as obsolete for a specific part
                     --but when we have a linked specification
                     --we have to check that plant is not still effective
                     --in its generic spec or in any of the linked specifications
                     --linked to that generic specification
                     l_plantgk_must_be_deleted := TRUE;
                     IF l_LinkedSpecification THEN
                        --check in generic spec
                        SELECT COUNT(*) 
                        INTO l_countplant_not_obsolete
                        FROM part_plant pp
                        WHERE pp.plant = l_plant_rec.plant
                          AND pp.part_no = l_Generic_Part_No
                          AND NVL(pp.obsolete,'0') <> '1';
                        
                        IF l_countplant_not_obsolete > 0 THEN
                           l_plantgk_must_be_deleted := FALSE;
                        ELSE
                           --check in all other attached spec linked to the same generic spec
                           --that are transferred to the lims
                           --only the last transferred version is taken into consideration
                           SELECT COUNT(*) 
                           INTO l_countplant_not_obsolete
                           FROM part_plant pp, attached_specification asp
                           WHERE pp.plant = l_plant_rec.plant
                             AND pp.part_no = asp.part_no
                             AND asp.attached_part_no = l_Generic_Part_No         
                             --is not 100% correct but is working in 99% of the case and can be wrapped (to review)
                             AND asp.revision IN (SELECT MAX(asp2.revision)
                                                  FROM attached_specification asp2
                                                  WHERE asp2.part_no = asp.part_no)
                             --sorry, we have to scan itlimsjob_h also because cargill is cleaning up its itlimsjob
--                             AND asp.revision IN GREATEST( 
--                                                       (SELECT MAX(revision) revision
--                                                        FROM itlimsjob job
--                                                        WHERE job.part_no = asp.part_no
--                                                        AND job.plant = pp.plant
--                                                        AND date_transferred IS NOT NULL),                                                        
--                                                       (SELECT MAX(revision) revision
--                                                        FROM itlimsjob_h job
--                                                        WHERE job.part_no = asp.part_no
--                                                        AND job.plant = pp.plant
--                                                        AND date_transferred IS NOT NULL))
                             AND NVL(pp.obsolete,'0') <> '1';
                           IF l_countplant_not_obsolete > 0 THEN
                              l_plantgk_must_be_deleted := FALSE;
                           END IF;
                        END IF;
                     END IF;                     
                     IF l_plantgk_must_be_deleted THEN
                        -- add the plant to the list of plants that must be deleted
                        l_nr_of_obsolete_plants := l_nr_of_obsolete_plants + 1;
                        l_list_of_obsolete_plants(l_nr_of_obsolete_plants) := l_plant_rec.plant;
                        -- Add the sampletype groupkey to an array, the transfer will be done at the end.
                        l_nr_of_rows := l_nr_of_rows + 1;
                        -- Generate the sampletype groupkey id
                        l_gk_tab(l_nr_of_rows)         := PA_LIMS.f_GetGkId(PA_LIMS.g_pp_key_name(i));
                        l_gk_version_tab(l_nr_of_rows) := NULL;
                        l_value_tab(l_nr_of_rows)      := l_plant_rec.plant;
                     END IF;
                  END LOOP;
               END IF;
            END LOOP;            

            --search for the reference version
            -- when there is a current version => that version is used
            -- in other case, look for the highest version with an affective_till filled in
            -- when no version is found, all versions will be concerned => lowest version used as reference
            -- when such a version is found, all higher versions will be concerned
            l_ref_version := NULL;
            SELECT MAX(DECODE(version_is_current,'1', version))
            INTO l_ref_version
            FROM UVST@LNK_LIMS            
            WHERE st = l_StId;
            
            IF l_ref_version IS NULL THEN
               SELECT MAX(version)
               INTO l_ref_version
               FROM UVST@LNK_LIMS            
               WHERE st = l_StId
               AND effective_till IS NOT NULL;
               
               IF l_ref_version IS NULL THEN
                  --no current version, no version that has ever teminated its version life => all versions concerned
                  SELECT MIN(version)
                  INTO l_ref_version
                  FROM UVST@LNK_LIMS            
                  WHERE st = l_StId;
               ELSE
                  --lowest version after the highest effective_till version
                  SELECT MIN(version)
                  INTO l_ref_version
                  FROM UVST@LNK_LIMS            
                  WHERE st = l_StId
                  AND version > l_ref_version;               
               END IF;
            END IF;
            FOR l_st_rec IN (SELECT st, version
                             FROM UVST@LNK_LIMS
                             WHERE st = l_StId
                             AND version >= l_ref_version) LOOP             
               
               --l_ret_code := UNAPIAUT.DisableAllowModifyCheck@LNK_LIMS('1');
               --DisbaleAllowModifyCheck does not work with configuratinal objects
               --
               --we have to be dirty here
               PA_SPECXINTERFACE.InhibitStStatusControl@LNK_LIMS(l_st_rec.st, l_st_rec.version, l_orig_version_is_current, l_orig_allow_modify, l_orig_active);
               -- Delete the sampletype groupkey
               IF NOT f_DeleteSpcStGk(l_st_rec.st, l_st_rec.version, l_gk_tab, l_gk_version_tab, l_value_tab, l_nr_of_rows) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;

               -- Delete the parameterprofiles of the sampletype and 
               -- the link between the parameterprofiles and the sampletype
               IF NOT f_ClearStPp(a_part_no, l_st_rec.st, l_st_rec.version, l_list_of_obsolete_plants, l_nr_of_obsolete_plants) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;

               --insert a specific event indicating the obsolescence of the plant
               FOR l_plant_rec IN l_partobsoleteplants_cursor(PA_LIMS.f_ActivePlant, a_part_no) LOOP
                  --plant must be in the list builded in previous steps
                  l_send_event := TRUE;
                  FOR l_plant_nr IN 1..l_nr_of_obsolete_plants LOOP
                     IF l_list_of_obsolete_plants(l_plant_nr) = l_plant_rec.plant THEN
                        l_send_event := TRUE;
                        EXIT;
                     END IF;
                  END LOOP;
                  IF l_send_event THEN                  
                     l_api_name := 'f_MakePartObsolete4Plant';               
                     l_evmgr_name := '';
                     l_object_tp := 'st';
                     l_object_id := l_st_rec.st;               
                     l_object_lc := '';               
                     l_object_lc_version := '';               
                     l_object_ss := '';               
                     l_ev_tp := 'ObjectUpdated';               
                     l_ev_details := 'version='||l_st_rec.version||
                                     '#sub_ev_tp=PlantObsolete'||
                                     '#part_no='||a_part_no||
                                     '#revision='||a_revision||
                                     '#plant='||l_plant_rec.plant;
                     l_seq_nr := NULL;               
                     l_ret := UNAPIEV.InsertEvent@LNK_LIMS
                                  (l_api_name,
                                   l_evmgr_name,
                                   l_object_tp,
                                   l_object_id,
                                   l_object_lc,
                                   l_object_lc_version,
                                   l_object_ss,
                                   l_ev_tp,
                                   l_ev_details,
                                   l_seq_nr);
                     IF l_ret <> 0 THEN
                         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'InsertEvent for sub-ev-tp=PlantObsolete failed ret='||l_ret);
                     END IF;
                  END IF;
               END LOOP;
               
               --end of dirty part
               PA_SPECXINTERFACE.RestoreStStatusControl@LNK_LIMS(l_st_rec.st, l_st_rec.version, l_orig_version_is_current, l_orig_allow_modify, l_orig_active);

            END LOOP;
            --l_ret_code := UNAPIAUT.DisableAllowModifyCheck@LNK_LIMS('0');
            --does not work for configurational objects
            
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            l_result := FALSE;
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer the specification with '||l_object||
                          ' for plant "'||PA_LIMS.f_ActivePlant||'" (Error code : '||SQLERRM||').');
      END;

      IF l_result THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
      END IF;

      RETURN (l_result);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the specification with '||l_object||
                       ' for plant "'||PA_LIMS.f_ActivePlant||'" : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         --does not work for configurational objects
         --l_ret_code := UNAPIAUT.DisableAllowModifyCheck@LNK_LIMS('0');
         RETURN (FALSE);
   END f_MakePartObsolete4Plant;

   FUNCTION f_TransferSpcStGk4Plant(
      a_st           IN     VARCHAR2,
      a_version      IN OUT VARCHAR2,
      a_gk           IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_gk_version   IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_value        IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows   IN     NUMBER
   )
      RETURN BOOLEAN
   IS
   
   -- Constant variables for the tracing
   l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
   l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferSpcStGk4Plant';

   l_inlist            PA_LIMSSPC_VC20NESTEDTABLETYPE:=PA_LIMSSPC_VC20NESTEDTABLETYPE();
   l_count             INTEGER;
   l_ret               BOOLEAN;
   BEGIN
      -- This function calls f_TransferSpcStGk only if some plant group keys are missing. optimalistaion
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Started);
      IF NVL(a_nr_of_rows, 0) = 0 THEN
         l_ret := TRUE;
      ELSE
         --verify if some plant group keys are missing
         FOR l_x IN 1..a_nr_of_rows LOOP
            l_inlist.Extend();
            l_inlist(l_inlist.COUNT) := a_value(l_x);
         END LOOP;         
         SELECT COUNT(*)
         INTO l_count
         FROM uvstgk@LNK_LIMS
         WHERE st = a_st
           AND version = a_version
           AND gk = a_gk(1)
           AND value IN (SELECT * FROM TABLE(CAST (l_inlist AS PA_LIMSSPC_VC20NESTEDTABLETYPE)));
         IF l_count = a_nr_of_rows THEN
            PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, NULL, NULL, 'Nothing to change to plant group keys');
            l_ret := TRUE;
         ELSE
            l_ret := PA_LIMSSPC2.f_TransferSpcStGk(a_st, a_version, a_gk, a_gk_version, a_value, a_nr_of_rows);
         END IF;
      END IF;
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_st||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN(l_ret);
   END f_TransferSpcStGk4Plant;

   FUNCTION f_MakePartEffective4Plant(
      a_Part_No    IN specification_header.part_no%TYPE,
      a_Revision   IN specification_header.revision%TYPE
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Make one specification Effective in Unilab.
      -- ** Parameters **
      -- a_part_no   : part_no of the specification
      -- a_revision  : revision of the specification
      -- ** Return **
      -- TRUE : The specification is Effectived Unilab
      -- FALSE: The specification is not Effectived in Unilab
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_MakePartEffective4Plant';
      l_object       VARCHAR2(255);

      -- General variables
      l_StId                        VARCHAR2(20);
      l_st_version                  VARCHAR2(20);
      l_sh_revision                 NUMBER;
      l_planned_effective_date      DATE             DEFAULT NULL;
      l_result                      BOOLEAN          DEFAULT TRUE;
      l_LinkedSpecification         BOOLEAN          DEFAULT FALSE;
      l_Generic_Part_No             VARCHAR2(20);
      l_Generic_Revision            NUMBER(8);
      l_Description                 VARCHAR2(60);
      l_ret                         NUMBER;
      l_nr_of_occurences            NUMBER;
      l_linked_key_index            NUMBER;
      l_linked_key                  CHAR(1);
      l_Effective_part               CHAR(1);
      l_ret_code                    INTEGER;
      l_orig_version_is_current     CHAR(1);
      l_orig_allow_modify           CHAR(1);
      l_orig_active                 CHAR(1);
      l_ref_version                 VARCHAR2(20);


      -- Specific local variables for the 'SaveSystemDefault' API
      l_setting_name         VARCHAR2(20);
      l_update_setting       BOOLEAN                           DEFAULT TRUE;
      l_setting_name_tab     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_setting_value_tab    UNAPIGEN.VC255_TABLE_TYPE@LNK_LIMS;
      l_nr_of_rows           NUMBER;
      l_modify_reason        VARCHAR2(255);
      
      -- Specific local variables for the 'f_TransferSpcStGk' API
      l_gk_tab             UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_gk_version_tab     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab          UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;
      
      --Specific local variables for InsertEvent
      l_api_name                    VARCHAR2(40);
      l_evmgr_name                  VARCHAR2(20);
      l_object_tp                   VARCHAR2(4);
      l_object_id                   VARCHAR2(20);
      l_object_lc                   VARCHAR2(2);
      l_object_lc_version           VARCHAR2(20);
      l_object_ss                   VARCHAR2(2);
      l_ev_tp                       VARCHAR2(60);
      l_ev_details                  VARCHAR2(255);
      l_seq_nr                      NUMBER;

      -- Exceptions
      l_EXC_TRANSFER                EXCEPTION;

      -- Cursor to get the data of the specification
      CURSOR l_StToTransfer_Cursor(
         c_Part_No    specification_header.part_no%TYPE,
         c_Revision   specification_header.revision%TYPE
      )
      IS
         SELECT sph.part_no, sph.revision, sph.planned_effective_date,
                f_part_descr(1, sph.part_no) description, sph.class3_id
           FROM specification_header sph
          WHERE sph.part_no  = c_Part_No
            AND sph.revision = c_Revision;

      -- Cursor to check if the specification is a linked specification
      CURSOR l_LinkedSpec_Cursor(
         c_Part_No         specification_header.part_no%TYPE,
         c_Revision        specification_header.revision%TYPE,
         c_KwIdGenericSp   itkw.kw_id%TYPE
      )
      IS
         SELECT asp.attached_part_no,
                DECODE(
                   asp.attached_revision,
                   0, F_Rev_Part_Phantom(asp.attached_part_no, 0), -- the attached specification is a phantom (Always take the highest current revision)
                   asp.attached_revision
                ) attached_revision
           FROM specification_kw spk, attached_specification asp
          WHERE spk.part_no = asp.attached_part_no
            AND kw_id = c_KwIdGenericSp
            AND asp.part_no = c_Part_No
            AND asp.revision = c_Revision;

      -- Cursor to get all existing versions of the sampletype in Unilab
      CURSOR l_st_versions_cursor(c_st VARCHAR2)
      IS
         SELECT version
         FROM UVST@LNK_LIMS
         WHERE st = c_st
         ORDER BY version DESC;

      -- Cursor to get the revision of the generic specification from Interspec and Unilab
      CURSOR l_GenericSpec_Cursor(c_Part_No   specification_header.part_no%TYPE)
      IS
         SELECT revision
           FROM specification_header
          WHERE part_no = c_Part_No
            AND status = 4; -- current !

      -- Cursor to get the revision of the generic specification from Unilab
      CURSOR l_GenericSpecUnilab_Cursor(c_Part_No   specification_header.part_no%TYPE)
      IS
         SELECT revision, status
           FROM specification_header
          WHERE part_no = c_Part_No
       ORDER BY revision DESC;

      -- Cursor to check if a higher generic revision than the current exists
      CURSOR l_HighestGenRevision_Cursor (c_generic_part_no    specification_header.part_no%TYPE,
                                          c_generic_revision   specification_header.revision%TYPE)
      IS
         SELECT COUNT(*) nr
           FROM specification_header
          WHERE part_no  = c_generic_part_no
            AND revision > c_generic_revision; 

      -- Cursor to check if the type of the specification can be transferred 
      CURSOR lvq_getspecs
      IS
         SELECT *
           FROM interspc_cfg
          WHERE section = 'U4 INTERFACE'
            AND parameter like 'SPECTYPE%'
          ORDER BY parameter;

      -- Cursor to get the part_type of the specification
      CURSOR lvq_getspectype (c_Part_No specification_header.part_no%TYPE)
      IS
         SELECT *
           FROM part
          WHERE part_no = c_Part_No;
           
     -- Cursor to get the description of the value of the Interspec system setting 'KW ID Generic Spc'
     CURSOR l_kw_cursor(c_kw_id NUMBER)
     IS
        SELECT description
          FROM itkw
         WHERE kw_id = c_kw_id;

      -- Cursor to get all plants that have the same connection string and language id's as the given plant
      -- and that are marked as Effective
      CURSOR l_parteffectiveplants_cursor(c_plant      plant.plant%TYPE, 
                                          c_part_no    specification_header.part_no%TYPE)
      IS
         SELECT a.*
           FROM itlimsplant a, part_plant pp
          WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                   (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                      FROM itlimsplant b
                     WHERE b.plant = c_plant)
            AND a.plant = pp.plant
            AND pp.part_no = c_part_no
            AND NVL(pp.obsolete, '0') = '0';

      -- Cursor to check if a specification is a generic specification
      CURSOR l_gen_cursor(c_part_no   specification_header.part_no%TYPE)
      IS
         SELECT part_no
           FROM interspc_cfg cfg, specification_kw kw
          WHERE cfg.section        = 'U4 INTERFACE'
            AND cfg.parameter      = 'KW ID Generic Spc'
            AND cfg.parameter_data = kw.kw_id
            AND kw.kw_value        = 'Yes'
            AND kw.part_no         = c_part_no;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Part_No||' | '||a_Revision, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'part_no "'||a_part_no||'" | revision='||a_revision;
      

/* TO REVIEW START */
      -- Check if a specification is a generic specification
      FOR l_gen_rec IN l_gen_cursor(a_part_no) LOOP
         -- Set the value of the Unilab system setting 'STGK ID Generic St', if it does not correspond
         -- anymore with the value of the Interspec setting 'KW ID Generic Spc'.
         l_setting_name := 'STGK ID Generic St';
         l_nr_of_rows := 1;
         -- Get the Interspec setting
         FOR l_kw_rec IN l_kw_cursor(PA_LIMS.f_GetSettingValue('KW ID Generic Spc')) LOOP
            l_setting_value_tab(l_nr_of_rows) := PA_LIMS.f_GetGkId(l_kw_rec.description);
            -- Get the Unilab setting
            FOR l_system_rec IN g_system_cursor(l_setting_name) LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_system_rec.setting_value, PA_LIMS.f_GetGkId(l_kw_rec.description)) = 1 THEN
                  l_update_setting := FALSE;
               END IF;
            END LOOP;
         END LOOP;
      END LOOP;
/* TO REVIEW END */

      -- Set the default values for the generic specification. These default
      -- values are only overruled if there is a linked specification
      l_Generic_Part_No  := a_Part_No;
      l_Generic_Revision := a_Revision;

      -- Check if the specification is a linked specification
      FOR l_LinkedSpec_Rec IN l_LinkedSpec_Cursor(a_Part_No, a_Revision, PA_LIMS.f_GetSettingValue('KW ID Generic Spc')) LOOP
         -- Indicate that it's a linked specification
         l_LinkedSpecification := TRUE;

         -- Overrule the default values for the generic specification
         l_Generic_Part_No  := l_LinkedSpec_Rec.Attached_Part_No;
         l_Generic_Revision := -1;

         -- Loop all Unilab versions of this specification
         FOR l_st_versions_rec IN l_st_versions_cursor(l_Generic_Part_No) LOOP
            -- When a linked specification, get the revision of the attached generic specification,
            -- not the attached revision!
            -- Retrieve the revision of the linked specification as known by
            -- Interspec and Unilab.
            FOR l_GenericSpec_Rec IN l_GenericSpec_Cursor(l_Generic_Part_No) LOOP
               IF UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_Generic_Part_No, l_GenericSpec_Rec.revision) 
                  = l_st_versions_rec.version THEN
                     l_Generic_Revision := l_GenericSpec_Rec.Revision;
               END IF;
            END LOOP;

            -- Fetch current revision in Unilab !
            IF l_Generic_Revision = -1 THEN
               -- Get the revision number out of Unilab (do not look in Interspec)
               FOR l_GenericSpecUnilab_Rec IN l_GenericSpecUnilab_Cursor(l_Generic_Part_No) LOOP
                  IF UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_Generic_Part_No, l_GenericSpecUnilab_Rec.revision) 
                     = l_st_versions_rec.version THEN
                     l_Generic_Revision := l_GenericSpecUnilab_Rec.revision;
                  END IF;
               END LOOP;
            END IF;
         END LOOP;

         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                         'Linked specification of generic specification "'||l_Generic_Part_No||'" | revision='||
                         l_Generic_Revision);

         -- If spec doesn't need to be transferred, then following loggings are rather confusing.
         IF f_ToBeTransferred(a_part_no, a_revision, SUBSTR(l_Generic_Part_No,1,20), l_Generic_Revision) THEN
            -- Check if the generic specification was found. If not the user is trying to transfer a 
            -- linked specification before the generic specification was sent, this is not allowed !
            IF l_Generic_Revision = -1 THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to find in Unilab the generic specification with part_no "'||l_generic_part_no||
                             '" of linked specification with '||l_object||'.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Check if a higher generic revision than the current exists. If so, warn the user.
            FOR l_HighestGenRevision_rec IN l_HighestGenRevision_Cursor(l_generic_part_no,l_generic_revision) LOOP
               IF l_HighestGenRevision_rec.nr > 0 THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Linked specification with '||l_object||
                                ' will be attached to the current generic specification with part_no "'||l_generic_part_no||
                                '" | revision='||l_generic_revision||
                                '. Be aware that a higher revision of this generic specification already exists.');
               END IF;
            END LOOP;
         END IF;
      END LOOP;
      
      BEGIN
         -- Generate the sampletype id and version, and the parameterprofile version
         l_StId := SUBSTR(l_Generic_Part_No, 1, 20);
         l_st_version := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_stid, l_Generic_Revision);
         -- For linked specs, the pp_version has to be derived from the revision of the
         -- linked specification, not from the revision of the generic specification
         IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_generic_part_no, a_part_no) = 1 THEN
            l_sh_revision := l_Generic_revision;
         ELSE
            l_sh_revision := a_revision;
         END IF;
         
         -- Check if spec needs to be transferred
         IF f_ToBeTransferred(a_part_no, a_revision, l_StId, l_Generic_Revision) THEN
            -- Log the contents of the sampletype
            PA_LIMS.p_TraceSt(l_StId, l_st_version);

            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Sample type "'||l_stid||'" | version='||l_st_version);

            --check in its life cycle that the transition from the actual status to any status and back to the original status with special conditions:Obsolete4Interspec
            IF NOT f_ObsoletionTransitionPresent(l_stid,l_st_version) THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Sample type marked for obsoletion but life cycle is not ok in Unilab for obsoletion. skipping.');
               -- we do nothing, do not log anything and mark as updated
               --will be hard to trace, but no other options
               RETURN (TRUE);               
            END IF;

            -------------------------------------------------------------------------
            -- BEGIN 05/11/2002

            -- Set the pp keys
            IF NOT PA_LIMS.f_SetPpKeys(a_part_no, a_revision, l_StId) THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to set the parameterprofile keys.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               RETURN (FALSE);
            END IF;

            -- Find the plant pp_key can be found for all specs
            -- Initialize variable
              l_nr_of_rows := 0;
            FOR i IN 1..5 LOOP
               -- Check if this pp_key is the plant pp_key
               IF INSTR(LOWER(PA_LIMS.g_pp_key_name(i)),'plant') > 0 THEN
                  -- Delete sampletype groupkey with value = <plant> 
                  -- for all plants that have the same connection string and language id as the active plant
                  --and that are marked as effective
                  FOR l_plant_rec IN l_parteffectiveplants_cursor(PA_LIMS.f_ActivePlant, a_part_no) LOOP
                     -- Add the sampletype groupkey to an array, the transfer will be done at the end.
                     l_nr_of_rows := l_nr_of_rows + 1;
                     -- Generate the sampletype groupkey id
                     l_gk_tab(l_nr_of_rows)         := PA_LIMS.f_GetGkId(PA_LIMS.g_pp_key_name(i));
                     l_gk_version_tab(l_nr_of_rows) := NULL;
                     l_value_tab(l_nr_of_rows)      := l_plant_rec.plant;                     
                  END LOOP;
               END IF;
            END LOOP;            

            --search for the reference version
            -- when there is a current version => that version is used
            -- in other case, look for the highest version with an affective_till filled in
            -- when no version is found, all versions will be concerned => lowest version used as reference
            -- when such a version is found, all higher versions will be concerned
            l_ref_version := NULL;
            SELECT MAX(DECODE(version_is_current,'1', version))
            INTO l_ref_version
            FROM UVST@LNK_LIMS            
            WHERE st = l_StId;
            
            IF l_ref_version IS NULL THEN
               SELECT MAX(version)
               INTO l_ref_version
               FROM UVST@LNK_LIMS            
               WHERE st = l_StId
               AND effective_till IS NOT NULL;
               
               IF l_ref_version IS NULL THEN
                  --no current version, no version that has ever teminated its version life => all versions concerned
                  SELECT MIN(version)
                  INTO l_ref_version
                  FROM UVST@LNK_LIMS            
                  WHERE st = l_StId;
               ELSE
                  --lowest version after the highest effective_till version
                  SELECT MIN(version)
                  INTO l_ref_version
                  FROM UVST@LNK_LIMS            
                  WHERE st = l_StId
                  AND version > l_ref_version;               
               END IF;
            END IF;
            
            FOR l_st_rec IN (SELECT st, version
                             FROM UVST@LNK_LIMS
                             WHERE st = l_StId
                             AND version >= l_ref_version) LOOP             
               
               --l_ret_code := UNAPIAUT.DisableAllowModifyCheck@LNK_LIMS('1');
               --DisbaleAllowModifyCheck does not work with configuratinal objects
               --
               --we have to be dirty here
               PA_SPECXINTERFACE.InhibitStStatusControl@LNK_LIMS(l_st_rec.st, l_st_rec.version, l_orig_version_is_current, l_orig_allow_modify, l_orig_active);
               -- Add the sampletype groupkey
               IF NOT f_TransferSpcStGk4Plant(l_st_rec.st, l_st_rec.version, l_gk_tab, l_gk_version_tab, l_value_tab, l_nr_of_rows) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;

               -- Delete the parameterprofiles of the sampletype and 
               -- the link between the parameterprofiles and the sampletype
               IF NOT f_EnableStPp(a_part_no, l_st_rec.st, l_st_rec.version) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;

               --end of dirty part
               --insert a specific event indicating that a plant is back effective
               FOR l_plant_rec IN l_parteffectiveplants_cursor(PA_LIMS.f_ActivePlant, a_part_no) LOOP
                  l_api_name := 'f_MakePartEffective4Plant';               
                  l_evmgr_name := '';
                  l_object_tp := 'st';
                  l_object_id := l_st_rec.st;               
                  l_object_lc := '';               
                  l_object_lc_version := '';               
                  l_object_ss := '';               
                  l_ev_tp := 'ObjectUpdated';               
                  l_ev_details := 'version='||l_st_rec.version||
                                  '#sub_ev_tp=PlantEffective'||
                                  '#part_no='||a_part_no||
                                  '#revision='||a_revision||
                                  '#plant='||l_plant_rec.plant;
                  l_seq_nr := NULL;               
                  l_ret := UNAPIEV.InsertEvent@LNK_LIMS
                               (l_api_name,
                                l_evmgr_name,
                                l_object_tp,
                                l_object_id,
                                l_object_lc,
                                l_object_lc_version,
                                l_object_ss,
                                l_ev_tp,
                                l_ev_details,
                                l_seq_nr);
                  IF l_ret <> 0 THEN
                      PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'InsertEvent failed for sub-ev-tp=PlantEffective ret='||l_ret);
                  END IF;
               END LOOP;
               PA_SPECXINTERFACE.RestoreStStatusControl@LNK_LIMS(l_st_rec.st, l_st_rec.version, l_orig_version_is_current, l_orig_allow_modify, l_orig_active);

            END LOOP;
            --l_ret_code := UNAPIAUT.DisableAllowModifyCheck@LNK_LIMS('0');
            --does not work for configurational objects
            
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            l_result := FALSE;
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer the specification with '||l_object||
                          ' for plant "'||PA_LIMS.f_ActivePlant||'" (Error code : '||SQLERRM||').');
      END;

      IF l_result THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
      END IF;

      RETURN (l_result);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the specification with '||l_object||
                       ' for plant "'||PA_LIMS.f_ActivePlant||'" : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         --does not work for configurational objects
         --l_ret_code := UNAPIAUT.DisableAllowModifyCheck@LNK_LIMS('0');
         RETURN (FALSE);
   END f_MakePartEffective4Plant;

   FUNCTION f_TransferASpc(
      a_Part_No    IN specification_header.part_no%TYPE,
      a_Revision   IN specification_header.revision%TYPE
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer one specification from Interspec to Unilab.
      -- ** Parameters **
      -- a_part_no   : part_no of the specification
      -- a_revision  : revision of the specification
      -- ** Return **
      -- TRUE : The specification is transferred to Unilab
      -- FALSE: The specification is not transferred to Unilab
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_TransferASpc';
      l_object       VARCHAR2(255);

      -- General variables
      l_StId                        VARCHAR2(20);
      l_st_version                  VARCHAR2(20);
      l_sh_revision                 NUMBER;
      l_Template                    VARCHAR2(20);
      l_planned_effective_date      DATE             DEFAULT NULL;
      l_result                      BOOLEAN          DEFAULT TRUE;
      l_LinkedSpecification         BOOLEAN          DEFAULT FALSE;
      l_Generic_Part_No             VARCHAR2(20);
      l_Generic_Revision            NUMBER(8);
      l_Description                 VARCHAR2(60);
      l_ret                         NUMBER;
      l_ret2                        BOOLEAN;
      l_nr_of_occurences            NUMBER;
      l_linked_key_index            NUMBER;
      l_linked_key                  CHAR(1);
      l_obsolete_part               CHAR(1);
      l_some_not_obsolete           BOOLEAN;

      -- Specific local variables for the 'SaveSystemDefault' API
      l_setting_name         VARCHAR2(20);
      l_update_setting       BOOLEAN                           DEFAULT TRUE;
      l_setting_name_tab     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_setting_value_tab    UNAPIGEN.VC255_TABLE_TYPE@LNK_LIMS;
      l_nr_of_rows           NUMBER;
      l_modify_reason        VARCHAR2(255);
      
      -- Specific local variables for the 'f_TransferSpcStGk' API
      l_gk_tab             UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_gk_version_tab     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
      l_value_tab          UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;

      -- Exceptions
      l_EXC_TRANSFER                EXCEPTION;

      -- Cursor to get the data of the specification
      CURSOR l_StToTransfer_Cursor(
         c_Part_No    specification_header.part_no%TYPE,
         c_Revision   specification_header.revision%TYPE
      )
      IS
         SELECT sph.part_no, sph.revision, sph.planned_effective_date,
                f_part_descr(1, sph.part_no) description, sph.class3_id
           FROM specification_header sph
          WHERE sph.part_no  = c_Part_No
            AND sph.revision = c_Revision;

      -- Cursor to check if the specification is a linked specification
      CURSOR l_LinkedSpec_Cursor(
         c_Part_No         specification_header.part_no%TYPE,
         c_Revision        specification_header.revision%TYPE,
         c_KwIdGenericSp   itkw.kw_id%TYPE
      )
      IS
         SELECT asp.attached_part_no,
                DECODE(
                   asp.attached_revision,
                   0, F_Rev_Part_Phantom(asp.attached_part_no, 0), -- the attached specification is a phantom (Always take the highest current revision)
                   asp.attached_revision
                ) attached_revision
           FROM specification_kw spk, attached_specification asp
          WHERE spk.part_no = asp.attached_part_no
            AND kw_id = c_KwIdGenericSp
            AND asp.part_no = c_Part_No
            AND asp.revision = c_Revision;

      -- Cursor to get all existing versions of the sampletype in Unilab
      CURSOR l_st_versions_cursor(c_st VARCHAR2)
      IS
         SELECT version
         FROM UVST@LNK_LIMS
         WHERE st = c_st
         ORDER BY version DESC;

      -- Cursor to get the revision of the generic specification from Interspec and Unilab
      CURSOR l_GenericSpec_Cursor(c_Part_No   specification_header.part_no%TYPE)
      IS
         SELECT revision
           FROM specification_header
          WHERE part_no = c_Part_No
            AND status = 4; -- current !

      -- Cursor to get the revision of the generic specification from Unilab
      CURSOR l_GenericSpecUnilab_Cursor(c_Part_No   specification_header.part_no%TYPE)
      IS
         SELECT revision, status
           FROM specification_header
          WHERE part_no = c_Part_No
       ORDER BY revision DESC;

      -- Cursor to check if a higher generic revision than the current exists
      CURSOR l_HighestGenRevision_Cursor (c_generic_part_no    specification_header.part_no%TYPE,
                                          c_generic_revision   specification_header.revision%TYPE)
      IS
         SELECT COUNT(*) nr
           FROM specification_header
          WHERE part_no  = c_generic_part_no
            AND revision > c_generic_revision; 

      -- Cursor to check if the type of the specification can be transferred 
      CURSOR lvq_getspecs
      IS
         SELECT *
           FROM interspc_cfg
          WHERE section = 'U4 INTERFACE'
            AND parameter like 'SPECTYPE%'
          ORDER BY parameter;

      -- Cursor to get the part_type of the specification
      CURSOR lvq_getspectype (c_Part_No specification_header.part_no%TYPE)
      IS
         SELECT *
           FROM part
          WHERE part_no = c_Part_No;
           
     -- Cursor to get the description of the value of the Interspec system setting 'KW ID Generic Spc'
     CURSOR l_kw_cursor(c_kw_id NUMBER)
     IS
        SELECT description
          FROM itkw
         WHERE kw_id = c_kw_id;

      -- Cursor to get all plants that have the same connection string and language id's as the given plant
      CURSOR l_plant_cursor(c_plant      plant.plant%TYPE, 
                            c_part_no    specification_header.part_no%TYPE)
      IS
         SELECT a.*, pp.obsolete
           FROM itlimsplant a, part_plant pp
          WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                   (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                      FROM itlimsplant b
                     WHERE b.plant = c_plant)
            AND a.plant = pp.plant
            AND pp.part_no = c_part_no;

      -- Cursor to check if a specification is a generic specification
      CURSOR l_gen_cursor(c_part_no   specification_header.part_no%TYPE)
      IS
         SELECT part_no
           FROM interspc_cfg cfg, specification_kw kw
          WHERE cfg.section        = 'U4 INTERFACE'
            AND cfg.parameter      = 'KW ID Generic Spc'
            AND cfg.parameter_data = kw.kw_id
            AND kw.kw_value        = 'Yes'
            AND kw.part_no         = c_part_no;

      CURSOR l_st_cursor(c_st VARCHAR2, c_version VARCHAR2)
      IS
         SELECT COUNT(*) nr
         FROM UVST@LNK_LIMS
         WHERE st = c_st
         AND version like c_version
         AND allow_modify='#';
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Part_No||' | '||a_Revision, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'part_no "'||a_part_no||'" | revision='||a_revision;

      BEGIN
         SELECT NVL(MAX(obsolete),'0')
         INTO l_obsolete_part
         FROM part_plant b
         WHERE b.part_no = a_Part_No
           AND plant IN (SELECT plant
                         FROM itlimsplant a
                         WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                               (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                                  FROM itlimsplant b
                                 WHERE b.plant = PA_LIMS.f_ActivePlant));
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'part plant relation does not exist plant='||PA_LIMS.f_ActivePlant||'#part_no='||a_Part_No||'#revission='||a_Revision);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         -- End the remote transaction
         RETURN (FALSE);
      END;
      
      IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_obsolete_part, '1') = 1 THEN
         -- Save the result for all plants with the same connection string and language id
         --that are also marked as obsolete
         l_some_not_obsolete := FALSE;
         FOR l_plant_rec IN l_plant_cursor(PA_LIMS.f_ActivePlant, a_part_no) LOOP
            -- Save the result of the transfer of the specification
            -- allways called in the context of a transfer/ never in an update of a spec
            --to be reviewed: should be updated by returning TRUE
            IF l_plant_rec.obsolete = '1' THEN
               UPDATE itlimsjob
                  SET date_transferred = SYSDATE,
                      result_transfer = 1,
                      to_be_transferred = DECODE(to_be_transferred,'2','0',to_be_transferred),
                      date_proceed = GREATEST(SYSDATE,NVL(date_last_updated, SYSDATE)),
                      result_proceed = LEAST(1, DECODE(to_be_updated,'2',NVL(result_transfer,0),1))
                WHERE plant = l_plant_rec.plant
                  AND part_no = a_Part_No
                  AND revision = a_Revision;
             ELSE
                --itlimsjob will be updated as the normal update in 
                l_some_not_obsolete := TRUE;
             END IF;
         END LOOP;
         IF l_some_not_obsolete THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Not all plants obsolete, continue with transfer');
         ELSE
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'All plants obsolete no transfer');
            l_result := TRUE;
            RETURN (l_result);
         END IF;
      END IF;
      -- Added by JB 13/02/2003
      -- ************************
      -- Check in table INTERSPC_CFG if spec_type can be transferred to Unilab
      -- If not, update table and return TRUE
      FOR lvq_getspecs_rec IN lvq_getspecs LOOP
         FOR lvq_getspectype_rec IN lvq_getspectype (a_Part_No) LOOP
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(lvq_getspecs_rec.parameter_data, lvq_getspectype_rec.part_type) = 1 THEN
               -- Save the result for all plants with the same connection string and language id
               FOR l_plant_rec IN l_plant_cursor(PA_LIMS.f_ActivePlant, a_part_no) LOOP
                  -- Save the result of the transfer of the specification
                  -- allways called in the context of a transfer/ never in an update of a spec
                  --to be reviewed: should be updated by returning TRUE
                  UPDATE itlimsjob
                     SET date_transferred = SYSDATE,
                         result_transfer = 1,
                         to_be_transferred = DECODE(to_be_transferred,'2','0',to_be_transferred),
                         date_proceed = GREATEST(SYSDATE,NVL(date_last_updated, SYSDATE)),
                         result_proceed = LEAST(1, DECODE(to_be_updated,'2',NVL(result_transfer,0),1))
                   WHERE plant = l_plant_rec.plant
                     AND part_no = a_Part_No
                     AND revision = a_Revision;
               END LOOP;
               
               RETURN (l_result);
            END IF;
         END LOOP;
      END LOOP;

      -- Start the remote transaction
      IF NOT PA_LIMS.f_StartRemoteTransaction THEN
        -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Check if a specification is a generic specification
      FOR l_gen_rec IN l_gen_cursor(a_part_no) LOOP
         -- Set the value of the Unilab system setting 'STGK ID Generic St', if it does not correspond
         -- anymore with the value of the Interspec setting 'KW ID Generic Spc'.
         l_setting_name := 'STGK ID Generic St';
         l_nr_of_rows := 1;
         -- Get the Interspec setting
         FOR l_kw_rec IN l_kw_cursor(PA_LIMS.f_GetSettingValue('KW ID Generic Spc')) LOOP
            l_setting_value_tab(l_nr_of_rows) := PA_LIMS.f_GetGkId(l_kw_rec.description);
            -- Get the Unilab setting
            FOR l_system_rec IN g_system_cursor(l_setting_name) LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_system_rec.setting_value, PA_LIMS.f_GetGkId(l_kw_rec.description)) = 1 THEN
                  l_update_setting := FALSE;
               END IF;
            END LOOP;
         END LOOP;

         IF (l_update_setting) THEN
            BEGIN
               -- Fill in the parameters to get save the system setting
               l_setting_name_tab(l_nr_of_rows) := l_setting_name;
               l_modify_reason := 'Imported a new value of setting "'||l_setting_name||'" from Interspec.';
               -- Save the system setting
               l_ret := UNAPIUP.SAVESYSTEMDEFAULT@LNK_LIMS(l_setting_name_tab, l_setting_value_tab, l_nr_of_rows, 
                                                           l_modify_reason);
               -- Check if the save of the system setting succeeded
               IF l_ret <> PA_LIMS.DBERR_SUCCESS THEN
                  -- Log an error in ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to initialize the Unilab system setting "'||l_setting_name||'" : '||TO_CHAR(l_ret));
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  -- End the remote transaction
                  IF NOT PA_LIMS.f_EndRemoteTransaction THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  END IF;
                  RETURN (FALSE);
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  -- Log an error in ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                                'Unable to initialize the Unilab system setting "'||l_setting_name||'" : '||SQLERRM);
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  -- End the remote transaction
                  IF NOT PA_LIMS.f_EndRemoteTransaction THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  END IF;
                  RETURN (FALSE);
            END;
         END IF;
      END LOOP;

      -- Set the default values for the generic specification. These default
      -- values are only overruled if there is a linked specification
      l_Generic_Part_No  := a_Part_No;
      l_Generic_Revision := a_Revision;

      -- Check if the specification is a linked specification
      FOR l_LinkedSpec_Rec IN l_LinkedSpec_Cursor(a_Part_No, a_Revision, PA_LIMS.f_GetSettingValue('KW ID Generic Spc')) LOOP
         -- Indicate that it's a linked specification
         l_LinkedSpecification := TRUE;

         -- Overrule the default values for the generic specification
         l_Generic_Part_No  := l_LinkedSpec_Rec.Attached_Part_No;
         l_Generic_Revision := -1;

         -- Loop all Unilab versions of this specification
         FOR l_st_versions_rec IN l_st_versions_cursor(l_Generic_Part_No) LOOP
            -- When a linked specification, get the revision of the attached generic specification,
            -- not the attached revision!
            -- Retrieve the revision of the linked specification as known by
            -- Interspec and Unilab.
            FOR l_GenericSpec_Rec IN l_GenericSpec_Cursor(l_Generic_Part_No) LOOP
               IF UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_Generic_Part_No, l_GenericSpec_Rec.revision) 
                  = l_st_versions_rec.version THEN
                     l_Generic_Revision := l_GenericSpec_Rec.Revision;
               END IF;
            END LOOP;

            -- Fetch current revision in Unilab !
            IF l_Generic_Revision = -1 THEN
               -- Get the revision number out of Unilab (do not look in Interspec)
               FOR l_GenericSpecUnilab_Rec IN l_GenericSpecUnilab_Cursor(l_Generic_Part_No) LOOP
                  IF UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_Generic_Part_No, l_GenericSpecUnilab_Rec.revision) 
                     = l_st_versions_rec.version THEN
                     l_Generic_Revision := l_GenericSpecUnilab_Rec.revision;
                  END IF;
               END LOOP;
            END IF;
         END LOOP;

         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                         'Linked specification of generic specification "'||l_Generic_Part_No||'" | revision='||
                         l_Generic_Revision);

         -- If spec doesn't need to be transferred, then following loggings are rather confusing.
         IF f_ToBeTransferred(a_part_no, a_revision, SUBSTR(l_Generic_Part_No,1,20), l_Generic_Revision) THEN
            -- Check if the generic specification was found. If not the user is trying to transfer a 
            -- linked specification before the generic specification was sent, this is not allowed !
            IF l_Generic_Revision = -1 THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to find in Unilab the generic specification with part_no "'||l_generic_part_no||
                             '" of linked specification with '||l_object||'.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               -- End the remote transaction
               IF NOT PA_LIMS.f_EndRemoteTransaction THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               END IF;
               RETURN (FALSE);
            END IF;

            -- Check if a higher generic revision than the current exists. If so, warn the user.
            FOR l_HighestGenRevision_rec IN l_HighestGenRevision_Cursor(l_generic_part_no,l_generic_revision) LOOP
               IF l_HighestGenRevision_rec.nr > 0 THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Linked specification with '||l_object||
                                ' will be attached to the current generic specification with part_no "'||l_generic_part_no||
                                '" | revision='||l_generic_revision||
                                '. Be aware that a higher revision of this generic specification already exists.');
               END IF;
            END LOOP;
         END IF;
      END LOOP;
      
      BEGIN
         -- Generate the sampletype id and version, and the parameterprofile version
         l_StId := SUBSTR(l_Generic_Part_No, 1, 20);
         l_st_version := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_stid, l_Generic_Revision);

         IF l_LinkedSpecification THEN
            -- Get the authorisation of the generic st
            -- to check if the whole transfer process has already been finished
            -- (transfer + diff mechanism, can take a long time for st with large testplans).
            -- Not with GetAuthorisation because this can return 0 (if still in buffer).
            FOR l_rec IN l_st_cursor(l_StId, REPLACE(UNVERSION.GETMAJORVERSIONONLY@LNK_LIMS(l_st_version),'*','%')) LOOP
               IF (l_rec.nr > 0) THEN
                   -- Skip the transfer of the linked spec
                   IF PA_LIMS.f_GetSettingValue('Handle Linked Spc') = 'SKIP' THEN
                      -- Tracing
                      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                          'Sampletype "'||l_stid||'" '||
                             'is still in transition, transfer of linked specification will be skipped.');
                      -- Tracing
                      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
                      -- End the remote transaction
                      IF NOT PA_LIMS.f_EndRemoteTransaction THEN
                         -- Tracing
                         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                      END IF;
                      RETURN (FALSE);
                   -- Wait until the transfer of the generic st finished
                   ELSE
                      --We wait for Unilab to process the events but we ignore the return value of the function
                      --if we didn't wait already for it
                      l_ret2 := PA_LIMS.f_Wait4EndOfEventProcessing;
                   END IF;
               END IF;
            END LOOP;
         END IF;


         -- For linked specs, the pp_version has to be derived from the revision of the
         -- linked specification, not from the revision of the generic specification
         IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_generic_part_no, a_part_no) = 1 THEN
            l_sh_revision := l_Generic_revision;
         ELSE
            l_sh_revision := a_revision;
         END IF;
         
         -- Check if spec needs to be transferred
         IF f_ToBeTransferred(a_part_no, a_revision, l_StId, l_Generic_Revision) THEN
            -- Log the contents of the sampletype
            PA_LIMS.p_TraceSt(l_StId, l_st_version);

            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Sample type "'||l_stid||'" | version='||l_st_version);

            -------------------------------------------------------------------------
            -- BEGIN 05/11/2002

            -- Set the pp keys
            IF NOT PA_LIMS.f_SetPpKeys(a_part_no, a_revision, l_StId) THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to set the parameterprofile keys.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               -- End the remote transaction
               IF NOT PA_LIMS.f_EndRemoteTransaction THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               END IF;
               RETURN (FALSE);
            END IF;

            -- Get the data of the specification
            FOR l_StToTransfer_rec IN l_StToTransfer_cursor(l_Generic_Part_No, l_Generic_Revision ) LOOP
               -- Get the template of the sampletype
               l_Template := PA_LIMS.f_GetTemplate('ST', l_StToTransfer_rec.class3_Id);
               l_Description := l_StToTransfer_Rec.Description;
               l_planned_effective_date := l_StToTransfer_rec.planned_effective_date;
            END LOOP;

            -- Transfer the sample type
            IF NOT f_TransferSpcSt(l_StId, l_st_version, l_planned_effective_date,
                                   NVL(f_GetStandardAuValue('DESCRIPTION',l_Generic_Part_No,l_Generic_Revision),l_Description),
                                   f_GetStandardAuValue('DESCRIPTION2',l_Generic_Part_No,l_Generic_Revision),
                                   f_GetStandardAuValue('SHELF_LIFE_VAL',l_Generic_Part_No,l_Generic_Revision),
                                   f_GetStandardAuValue('SHELF_LIFE_UNIT',l_Generic_Part_No,l_Generic_Revision),
                                   f_GetStandardAuValue('LABEL_FORMAT', l_Generic_Part_No, l_Generic_Revision),
                                   f_GetStandardAuValue('DEFAULT_PRIORITY',l_Generic_Part_No,l_Generic_Revision),
                                   l_Template,'0') THEN
               -- Raise an error
               RAISE l_EXC_TRANSFER;
            END IF;

            -- Initialize variable
            l_nr_of_rows := 0;

            IF NOT l_LinkedSpecification THEN
               -- Transfer the attributes of the sampletype
               IF NOT f_TransferSpcAllStAu(l_StId, l_st_version, a_Part_No, a_Revision) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;

               -- Transfer the groupkeys of the sample type
               IF NOT f_TransferSpcAllStGk(l_StId, l_st_version, a_part_no, a_Revision) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;
            END IF;

            -- Transfer the pp_keys as sampletype groupkeys
            -- The linked pp_keys can be found only for linked specs
            IF l_LinkedSpecification THEN
               l_nr_of_occurences := 1;
               LOOP
                  l_linked_key_index := INSTR(PA_LIMS.g_linked_keys,'#',1,l_nr_of_occurences);
                  EXIT WHEN l_linked_key_index = 0;
                  l_linked_key := SUBSTR(PA_LIMS.g_linked_keys,l_linked_key_index+1,1);
                  -- Assign the groupkey to the sampletype only if not empty
                  IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(PA_LIMS.g_pp_key(l_linked_key),' ') = 0 THEN
                     -- Add the sampletype groupkey to an array, the transfer will be done at the end.
                     l_nr_of_rows := l_nr_of_rows + 1;
                     -- Generate the sampletype groupkey id
                     l_gk_tab(l_nr_of_rows)         := PA_LIMS.f_GetGkId(PA_LIMS.g_pp_key_name(l_linked_key));
                     l_gk_version_tab(l_nr_of_rows) := NULL;
                     l_value_tab(l_nr_of_rows)      := PA_LIMS.g_pp_key(l_linked_key);
                  END IF;
                  l_nr_of_occurences := l_nr_of_occurences + 1;
               END LOOP;
            END IF;
            -- The plant pp_key can be found for all specs
            FOR i IN 1..5 LOOP
               -- Check if this pp_key is the plant pp_key
               IF INSTR(LOWER(PA_LIMS.g_pp_key_name(i)),'plant') > 0 THEN
                  -- Append sampletype groupkey with value = <plant> 
                  -- for all plants that have the same connection string and language id as the active plant
                  FOR l_plant_rec IN l_plant_cursor(PA_LIMS.f_ActivePlant, a_part_no) LOOP
                     IF NVL(l_plant_rec.obsolete, '0') <> '1' THEN
                        -- Add the sampletype groupkey to an array, the transfer will be done at the end.
                        l_nr_of_rows := l_nr_of_rows + 1;
                        -- Generate the sampletype groupkey id
                        l_gk_tab(l_nr_of_rows)         := PA_LIMS.f_GetGkId(PA_LIMS.g_pp_key_name(i));
                        l_gk_version_tab(l_nr_of_rows) := NULL;
                        l_value_tab(l_nr_of_rows)      := l_plant_rec.plant;
                     END IF;
                  END LOOP;
               END IF;
            END LOOP;

            -- Transfer the sampletype groupkey
            IF NOT f_TransferSpcStGk(l_StId, l_st_version, l_gk_tab, l_gk_version_tab, l_value_tab, l_nr_of_rows) THEN
               -- Raise an error
               RAISE l_EXC_TRANSFER;
            END IF;

            -- For linked specs, the planned_effective_date has to become the effective_from_date
            -- of the parameterprofile. For the other ones, the effective_from_date will be left
            -- empty.
            IF l_LinkedSpecification THEN
               -- Get the data of the specification
               FOR l_StToTransfer_rec IN l_StToTransfer_cursor(a_Part_No,a_Revision) LOOP
                  l_planned_effective_date := l_StToTransfer_rec.planned_effective_date;
               END LOOP;
            ELSE
               l_planned_effective_date := NULL;
            END IF;

            -- Transfer the parameterprofiles of the sampletype and 
            -- the link between the parameterprofiles and the sampletype
            IF NOT f_TransferSpcAllPpAndStPp(l_StId, l_st_version, l_sh_revision, a_part_no, a_Revision, l_planned_effective_date, l_Template) THEN
               -- Raise an error
               RAISE l_EXC_TRANSFER;
            END IF;

            -- Transfer the links between the properties and the propertygroups of the specification
            IF NOT f_TransferSpcAllPpPr(l_StId, l_st_version, l_sh_revision, a_part_no, a_Revision) THEN
               -- Raise an error
               RAISE l_EXC_TRANSFER;
            END IF;

            -- Inherit the linked specifications of the generic specification
            -- if the specification is a linked specification
            IF l_LinkedSpecification THEN
               IF NOT f_InheritLinkedSpc(l_sh_revision, l_Generic_Part_No, l_Generic_Revision, a_Part_No, a_Revision) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;

               -- Transfer the user attributes configured as sampletype attributes in Interspec as
               -- attributes on the link between the parameterprofile and the sampletype 
               -- for all attached specifications (= linked specifications) in Unilab
               IF NOT f_TransferSpcAllStAu_AttachSp(l_StId, l_st_version, l_sh_revision, a_Part_No, a_Revision) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;
            END IF;

            -------------------------------------------------------------------------
            -- END 05/11/2002

            -- Order the parameter definitions within the parameterprofiles of the sampletype
            IF l_LinkedSpecification THEN
               IF NOT f_OrderPpPr(l_StId, l_st_version, a_part_no, l_sh_revision) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;
            ELSE
               IF NOT f_OrderPpPr(l_StId, l_st_version, NULL, l_sh_revision) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;
            END IF;

            -------------------------------------------------------------------------
            -- BEGIN 05/11/2002

            -- Transfer the attributes of the link between the properties and the property groups of the specification
            IF NOT f_TransferSpcAllPpPrAu(l_StID, l_st_version, l_sh_revision, a_part_no, a_Revision) THEN
               -- Raise an error
               RAISE l_EXC_TRANSFER;
            END IF;

            -------------------------------------------------------------------------
            -- END 05/11/2002

            -- Order the parameterprofiles within the sampletype
            IF NOT f_OrderStPp(l_StId, l_st_version) THEN
               -- Raise an error
               RAISE l_EXC_TRANSFER;
            END IF;

            -- Log the contents of the sampletype
            PA_LIMS.p_TraceSt(l_StId, l_st_version);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            l_result := FALSE;
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer the specification with '||l_object||
                          ' for plant "'||PA_LIMS.f_ActivePlant||'" (Error code : '||SQLERRM||').');
      END;

      -- End the remote transaction
      IF NOT PA_LIMS.f_EndRemoteTransaction THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      IF l_result THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
      END IF;

      RETURN (l_result);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the specification with '||l_object||
                       ' for plant "'||PA_LIMS.f_ActivePlant||'" : '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         -- End the remote transaction
         IF NOT PA_LIMS.f_EndRemoteTransaction THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         END IF;
         RETURN (FALSE);
   END f_TransferASpc;

   FUNCTION f_TransferAllSpc(
      a_plant               IN VARCHAR2                           DEFAULT NULL,
      a_Part_No             IN specification_header.part_no%TYPE  DEFAULT NULL,
      a_Revision            IN specification_header.revision%TYPE DEFAULT NULL
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer the specifications of all plants from Interspec to Unilab.
      -- The specifications must have the following characteristics:
      --    - The specification must have the state 'APPROVED'
      --    - The specification must be transferred for the active plant
      --    - The specification has a property group which use a
      --      display format that is set up for LIMS
      --    - The property group must have at least one property
      -- ** Parameters **
      -- a_plant     : plant where the specification has to be transferred to
      -- a_part_no   : part_no of the specification
      -- a_revision  : revision of the specification
      -- ** Return **
      -- TRUE  : The transfer has succeeded.
      -- FALSE : The transfer has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname       CONSTANT VARCHAR2(12) := 'LimsSpc';
      l_method          CONSTANT VARCHAR2(32) := 'f_TransferAllSpc';

      -- General variables
      l_result          BOOLEAN               DEFAULT TRUE;
      l_lang_id         NUMBER(2);
      l_same            BOOLEAN               DEFAULT FALSE;
      l_first           BOOLEAN;
      l_close           BOOLEAN;

      -- Cursor to get the information about all the plants that have a LIMS db
      CURSOR l_plants_cursor(a_lowest_prio IN INTEGER) IS
        SELECT a.plant, a.connect_string, a.lang_id, a.lang_id_4id, NVL(b.plant_priority, a_lowest_prio ) priority
        FROM itlimsplant a, (SELECT plant, MIN(priority) plant_priority frOM itlimsjob WHERE to_be_transferred<>'0' GROUP BY plant) b
        WHERE a.plant = b.plant(+)
        ORDER BY priority ASC;

      -- Cursor to get the information about the plant
      CURSOR l_plant_cursor(c_plant plant.plant%TYPE)
      IS
         SELECT plant, connect_string, lang_id, lang_id_4id
           FROM itlimsplant
          WHERE plant = c_plant;

      -- Cursor to get all plants that have the same connection string and language id's as the given plant
      CURSOR l_similar_plants_cursor(c_plant      plant.plant%TYPE, 
                                     c_part_no    specification_header.part_no%TYPE)
      IS
         SELECT a.*
           FROM itlimsplant a, part_plant pp
          WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                   (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                      FROM itlimsplant b
                     WHERE b.plant = c_plant)
            AND a.plant = pp.plant
            AND pp.part_no = c_part_no
         UNION --a part_plant relation can be deleted from part-plant but still exist in itlimsjob (we added this union to break and endless loop)
         SELECT a.*
           FROM itlimsplant a, itlimsjob pp
          WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                    (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                       FROM itlimsplant b
                      WHERE b.plant = c_plant)
            AND a.plant = pp.plant
            AND pp.part_no = c_part_no;

      -- Cursor to get all the specifications that have to be transferred to Unilab
      CURSOR l_StToTransfer_Cursor(c_plant PLANT.PLANT%TYPE)
      IS
         ----------------------------------------------------------------------------------------
         -- the reason for this complicated cursor is that generic specifications need to be sent
         -- before their linked specifications
         ----------------------------------------------------------------------------------------
         -- part 1: all generic specifications
         SELECT limsj.part_no, limsj.revision, 'GENERIC' spectype
           FROM interspc_cfg cfg, specification_kw kw, itlimsjob limsj
          WHERE cfg.section = 'U4 INTERFACE'
            AND cfg.parameter = 'KW ID Generic Spc'
            AND cfg.parameter_data = kw.kw_id
            AND kw.kw_value = 'Yes'
            AND kw.part_no = limsj.part_no
            AND limsj.to_be_transferred = '2'
            AND limsj.date_ready > SYSDATE - 14
            AND limsj.plant = c_Plant
         UNION
         -- part 2: the rest
         (
            -- part 2a: all specifications
            SELECT limsj.part_no, limsj.revision, 'OTHER' spectype
              FROM itlimsjob limsj
             WHERE limsj.to_be_transferred = '2'
               AND limsj.date_ready > SYSDATE - 14
               AND limsj.plant = c_Plant
            MINUS
            -- part 2b: all generic specifications (= part 1)
            SELECT limsj.part_no, limsj.revision, 'OTHER' spectype
              FROM interspc_cfg cfg, specification_kw kw, itlimsjob limsj
             WHERE cfg.section = 'U4 INTERFACE'
               AND cfg.parameter = 'KW ID Generic Spc'
               AND cfg.parameter_data = kw.kw_id
               AND kw.kw_value = 'Yes'
               AND kw.part_no = limsj.part_no
               AND limsj.to_be_transferred = '2'
               AND limsj.date_ready > SYSDATE - 14
               AND limsj.plant = c_Plant
         )
         ORDER BY 3, 1 DESC, 2;

      -- Cursor to get all the specifications that have to be transferred to Unilab
      -- handle also all plants that have the same connection string and language id as the given plant
      CURSOR l_SimilarStToTransfer_Cursor(c_plant PLANT.PLANT%TYPE)
      IS
         ----------------------------------------------------------------------------------------
         -- the reason for this complicated cursor is that generic specifications need to be sent
         -- before their linked specifications
         ----------------------------------------------------------------------------------------
        SELECT part_no, revision, spectype, min(priority) priority
      FROM (
         -- part 1: all generic specifications
         -- The priority of a generic spec is the highest priority among its own priority and all the priorities of the linked specs attached to it.
          SELECT limsj.part_no, limsj.revision, 'GENERIC' spectype,LEAST(NVL(limsj.priority,1000),
                                                         NVL((SELECT MIN(priority) 
                                                             FROM itlimsjob b 
                                                             WHERE b.plant= limsj.plant
                                                             AND b.attached_part_no = limsj.part_no
                                                             ),
                                                             1000)
                                                         ) priority
            FROM interspc_cfg cfg, specification_kw kw, itlimsjob limsj, itlimsplant pl
           WHERE cfg.section = 'U4 INTERFACE'
            AND cfg.parameter = 'KW ID Generic Spc'
            AND cfg.parameter_data = kw.kw_id
            AND kw.kw_value = 'Yes'
            AND kw.part_no = limsj.part_no
            AND limsj.to_be_transferred = '2'
            AND limsj.date_ready > SYSDATE - 14
            AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                  (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                    FROM itlimsplant pl2
                   WHERE pl2.plant = c_plant)
            AND pl.plant = limsj.plant
          UNION
          -- part 2: the rest
          (
            -- part 2a: all specifications
            SELECT limsj.part_no, limsj.revision, 'OTHER' spectype, priority
              FROM itlimsjob limsj, itlimsplant pl
             WHERE limsj.to_be_transferred = '2'
               AND limsj.date_ready > SYSDATE - 14
               AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                    (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                      FROM itlimsplant pl2
                     WHERE pl2.plant = c_plant)
               AND pl.plant = limsj.plant
            MINUS
            -- part 2b: all generic specifications (= part 1)
            SELECT limsj.part_no, limsj.revision, 'OTHER' spectype, priority
              FROM interspc_cfg cfg, specification_kw kw, itlimsjob limsj, itlimsplant pl
             WHERE cfg.section = 'U4 INTERFACE'
               AND cfg.parameter = 'KW ID Generic Spc'
               AND cfg.parameter_data = kw.kw_id
               AND kw.kw_value = 'Yes'
               AND kw.part_no = limsj.part_no
               AND limsj.to_be_transferred = '2'
               AND limsj.date_ready > SYSDATE - 14
               AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                    (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                      FROM itlimsplant pl2
                     WHERE pl2.plant = c_plant)
               AND pl.plant = limsj.plant
          )
        )
        GROUP BY part_no, revision, spectype
         ORDER BY 4, 3, 1 DESC, 2;
   
      -- Local procedure to handle the transfer of the specification
      PROCEDURE p_HandleTransferASpc(
         a_Part_No             IN specification_header.part_no%TYPE  DEFAULT NULL,
         a_Revision            IN specification_header.revision%TYPE DEFAULT NULL
      )
      IS
      BEGIN
         -- Transfer the specification
         IF f_TransferASpc(a_Part_No, a_Revision) THEN
            -- Save the result for all plants with the same connection string and language id
            FOR l_plant_rec IN l_similar_plants_cursor(PA_LIMS.f_ActivePlant, a_part_no) LOOP
               -- Save the result of the transfer of the specification

               -- Client application must be adapted (history button must be added)!!! - TEAM 2296
/*
               BEGIN
                  INSERT INTO itlimsjob_h(plant, part_no, revision, date_ready, date_proceed, result_proceed)
                       SELECT plant, part_no, revision, date_ready, SYSDATE, 1
                         FROM itlimsjob
                        WHERE plant    = l_plant_rec.plant
                          AND part_no  = a_Part_No
                          AND revision = a_Revision;
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX THEN
                     UPDATE itlimsjob_h 
                        SET date_proceed   = SYSDATE,
                            result_proceed = 1
                      WHERE plant    = l_plant_rec.plant
                        AND part_no  = a_Part_No
                        AND revision = a_Revision;
                  WHEN OTHERS THEN
                     RAISE;
               END;
               DELETE FROM itlimsjob
                     WHERE plant    = l_plant_rec.plant
                       AND part_no  = a_Part_No
                       AND revision = a_Revision;
*/

               -- Save the result of the transfer of the specification
               --called in the context of a transfer and not of an update of the specs
               UPDATE itlimsjob
                  SET date_transferred = SYSDATE,
                      result_transfer = 1,
                      to_be_transferred = DECODE(to_be_transferred,'2','0',to_be_transferred),
                      date_proceed   = GREATEST(SYSDATE, NVL(date_last_updated, SYSDATE)),
                      result_proceed = LEAST(1, DECODE(to_be_updated,'2',NVL(result_transfer,0),1))
                WHERE plant    = l_plant_rec.plant
                  AND part_no  = a_Part_No
                  AND revision = a_Revision;
            END LOOP;
            COMMIT;
         ELSE
            l_result := FALSE;
            ROLLBACK;
            -- Save the result for all plants with the same connection string and language id
            FOR l_plant_rec IN l_similar_plants_cursor(PA_LIMS.f_ActivePlant, a_part_no) LOOP
               -- Save the result of the transfer of the specification
               UPDATE itlimsjob
                  SET date_transferred = SYSDATE,
                      result_transfer = 0,
                      to_be_transferred = DECODE(to_be_transferred,'2','1',to_be_transferred),
                      date_proceed   = GREATEST(SYSDATE, NVL(date_last_updated, SYSDATE)),
                      result_proceed = LEAST(0, DECODE(to_be_updated,'2',NVL(result_transfer,0),1))
                WHERE plant    = l_plant_rec.plant
                  AND part_no  = a_Part_No
                  AND revision = a_Revision;
            END LOOP;
            COMMIT;
         END IF;
      END p_HandleTransferASpc;
      
      -- Local procedure to handle all the specifications of a plant
      --according to a priority system and accordng to a functional order
      FUNCTION p_HandleAPlant(
          a_plant               IN VARCHAR2                           DEFAULT NULL
       )
       RETURN BOOLEAN IS
       l_first                           BOOLEAN;
       l_close                           BOOLEAN;
       l_iterations                      INTEGER;
       l_count_new_with_higher_prio      INTEGER;
       BEGIN
          --validation input arguments 
          IF a_plant IS NULL THEN
             RAISE_APPLICATION_ERROR(-20000, 'p_HandleAPlant called with an empty a_plant');
          END IF;
          
          --Main loop
          l_first := TRUE;
          l_close := FALSE;
          <<main_loop>>
          LOOP
             l_iterations := 0;
             -- Transfer all the specifications for the plant
             FOR l_SimilarStToTransfer_Rec IN l_SimilarStToTransfer_Cursor(a_plant) LOOP
                l_iterations := l_iterations + 1;
                IF l_first THEN
                   l_first := FALSE;
                   -- Setup the connection for the plant
                   IF NOT PA_LIMS.f_SetupLimsConnection(a_plant) THEN
                      l_result := FALSE;
                      EXIT main_loop;
                   END IF;
                   l_close := TRUE;
                END IF;

                -- Handle the transfer of the specification
                p_HandleTransferASpc(l_SimilarStToTransfer_Rec.Part_No, l_SimilarStToTransfer_Rec.Revision);
                
                --every x iterations (PA_LIMS.c_NrIterationsForReevaluation),
                -- Action1: At least the cursor must be reopened 
                -- Action2: i a very specific case, the cursor must be closed and the complete transfer restarted
                -- 
                --Case : a specification that is not marked as to be transfered has been added/updated in itlimsjob with a very high priority
                --        if such a specification is found than the compplete transfer must be relaunched to be sure
                --        that the configuration is transferred for these new specs to be transferred
                IF l_iterations >= PA_LIMS.c_NrIterationsForReevaluation THEN
                   SELECT COUNT('X')
                   INTO l_count_new_with_higher_prio
                   FROM itlimsjob
                   WHERE priority < (SELECT NVL(MIN(priority),1000) 
                                     FROM itlimsjob limsj
                                     WHERE limsj.to_be_transferred = '2'
                                     AND limsj.date_ready > SYSDATE - 14
                                     AND plant IN (SELECT pl3.plant
                                                   FROM itlimsplant pl3
                                                   WHERE (pl3.connect_string,pl3.lang_id,pl3.lang_id_4id) IN 
                                                       (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                                                        FROM itlimsplant pl2
                                                        WHERE pl2.plant = a_plant)))
                   AND date_transferred IS NULL
                   --2 cases here: a spec has been added to the queue or the priority of a spec for another plant has been increased
                   AND ((to_be_transferred = '1') 
                        OR
                        (to_be_transferred = '2' 
                         AND plant NOT IN (SELECT pl3.plant
                                           FROM itlimsplant pl3
                                           WHERE (pl3.connect_string,pl3.lang_id,pl3.lang_id_4id) IN 
                                                 (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                                                  FROM itlimsplant pl2
                                                  WHERE pl2.plant = a_plant))));
                   IF l_count_new_with_higher_prio>0 THEN
                      PA_LIMS.g_RestartACompleteTransfer := TRUE;
                      l_iterations := 0;  --to force an immediate exit of the outside loop
                      EXIT; -- exit from inside loop
                   END IF;
                   EXIT;
                END IF;
             END LOOP;
             EXIT WHEN (l_iterations = 0);
          END LOOP;
          IF l_close THEN
             -- Close the connection for the plant
             IF NOT PA_LIMS.f_CloseLimsConnection THEN
                l_result := FALSE;
             END IF;
          END IF;
          RETURN (l_result);
       END p_HandleAPlant;
      
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_part_no||' | '||a_revision, a_plant, NULL, PA_LIMS.c_Msg_Started);

      -- Transfer the specifications for all the plants
      IF a_plant IS NULL THEN
         FOR l_plants_rec IN l_plants_cursor(PA_LIMS.c_LowestSpecPriority) LOOP
            -- Check if a plant with the same connection string and language id has already been handled.
            -- Loop all handled plants
            FOR i IN 1..PA_LIMSSPC.g_nr_of_plants LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_plants_rec.connect_string, PA_LIMSSPC.g_connect_string_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plants_rec.lang_id, PA_LIMSSPC.g_lang_id_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plants_rec.lang_id_4id, PA_LIMSSPC.g_lang_id_4id_tab(i)) = 1 THEN
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
               IF NOT a_Part_No IS NULL THEN
                  -- Setup the connection for the plant
                  IF NOT PA_LIMS.f_SetupLimsConnection(l_plants_rec.plant) THEN
                     l_result := FALSE;
                  ELSE
                     -- Set the language in interspec 5.1 (exception handler necessary for compatibilty with 6.3)
                     --Pa_Cnstnt.l_language := l_plants_rec.lang_id;
                     BEGIN EXECUTE IMMEDIATE 'BEGIN pa_cnstnt.l_language := :lang_id; END;'
                           USING l_plants_rec.lang_id;
                     EXCEPTION WHEN OTHERS THEN NULL; END;               
                     --Modified in 6.1 sp1 (exception handler necessary for backward compatibility interspc 5.1)
                     BEGIN EXECUTE IMMEDIATE 'BEGIN iapiGeneral.SESSION.SETTINGS.LanguageId := :lang_id; END;'
                           USING l_plants_rec.lang_id;
                     EXCEPTION WHEN OTHERS THEN NULL; END;
                                         
                     -- Handle the transfer of the specification
                     p_HandleTransferASpc(a_part_no, a_revision);

                     -- Close the connection for the plant
                     IF NOT PA_LIMS.f_CloseLimsConnection THEN
                        l_result := FALSE;
                     END IF;
                  END IF;
               ELSE
                  -- Set the language in interspec 5.1 (exception handler necessary for compatibilty with 6.3)
                  --Pa_Cnstnt.l_language := l_plants_rec.lang_id;
                  BEGIN EXECUTE IMMEDIATE 'BEGIN pa_cnstnt.l_language := :lang_id; END;'
                        USING l_plants_rec.lang_id;
                  EXCEPTION WHEN OTHERS THEN NULL; END;               
                  --Modified in 6.1 sp1 (exception handler necessary for backward compatibility interspc 5.1)
                  BEGIN EXECUTE IMMEDIATE 'BEGIN iapiGeneral.SESSION.SETTINGS.LanguageId := :lang_id; END;'
                        USING l_plants_rec.lang_id;
                  EXCEPTION WHEN OTHERS THEN NULL; END;

                  -- Transfer all the specifications for the plant
                  l_result := p_HandleAPlant(l_plants_rec.plant);
               END IF;
            END IF;
         END LOOP;
      -- Transfer the specifications for a specific plant
      ELSE
         FOR l_plant_rec IN l_plant_cursor(a_plant) LOOP
            l_lang_id := l_plant_rec.lang_id;

            -- Check if a plant with the same connection string and language id has already been handled
            -- Loop all handled plants
            FOR i IN 1..PA_LIMSSPC.g_nr_of_plants LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_plant_rec.connect_string, PA_LIMSSPC.g_connect_string_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plant_rec.lang_id, PA_LIMSSPC.g_lang_id_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plant_rec.lang_id_4id, PA_LIMSSPC.g_lang_id_4id_tab(i)) = 1 THEN
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
            IF NOT a_Part_No IS NULL THEN
               -- Setup the connection for the plant
               IF NOT PA_LIMS.f_SetupLimsConnection(a_Plant) THEN
                  l_result := FALSE;
               ELSE
                  -- Set the language in interspec 5.1 (exception handler necessary for compatibilty with 6.3)
                  --Pa_Cnstnt.l_language := l_lang_id;
                  BEGIN EXECUTE IMMEDIATE 'BEGIN pa_cnstnt.l_language := :lang_id; END;'
                        USING l_lang_id;
                  EXCEPTION WHEN OTHERS THEN NULL; END;               
                  --Modified in 6.1 sp1 (exception handler necessary for backward compatibility interspc 5.1)
                  BEGIN EXECUTE IMMEDIATE 'BEGIN iapiGeneral.SESSION.SETTINGS.LanguageId := :lang_id; END;'
                        USING l_lang_id;
                  EXCEPTION WHEN OTHERS THEN NULL; END;

                  -- Handle the transfer of the specification
                  p_HandleTransferASpc(a_Part_No, a_Revision);

                  -- Close the connection for the plant
                  IF NOT PA_LIMS.f_CloseLimsConnection THEN
                     l_result := FALSE;
                  END IF;
               END IF;
            ELSE
               -- Set the language in interspec 5.1 (exception handler necessary for compatibilty with 6.3)
               --Pa_Cnstnt.l_language := l_lang_id;
               BEGIN EXECUTE IMMEDIATE 'BEGIN pa_cnstnt.l_language := :lang_id; END;'
                     USING l_lang_id;
               EXCEPTION WHEN OTHERS THEN NULL; END;               
               --Modified in 6.1 sp1 (exception handler necessary for backward compatibility interspc 5.1)
               BEGIN EXECUTE IMMEDIATE 'BEGIN iapiGeneral.SESSION.SETTINGS.LanguageId := :lang_id; END;'
                     USING l_lang_id;
               EXCEPTION WHEN OTHERS THEN NULL; END;

               l_result := p_HandleAPlant(a_Plant);
            END IF;
         END IF;
      END IF;

      -- Clear the global arrays
      PA_LIMSSPC.g_nr_of_plants := 0;
      
      IF l_result THEN
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
           PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to close the connection.');
        END IF;
        -- Log an error to ITERROR
        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to transfer the specifications to Unilab: '||SQLERRM);
        -- Tracing
        PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
        -- Clear the global arrays
        PA_LIMSSPC.g_nr_of_plants := 0;
        RETURN(FALSE);
   END f_TransferAllSpc;

   FUNCTION f_TransferSpc(
      a_Part_No    IN specification_header.part_no%TYPE,
      a_Revision   IN specification_header.revision%TYPE,
      a_plant      IN plant.plant%TYPE
   )
      RETURN NUMBER
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer one specification
      -- ** Parameters **
      -- a_part_no   : part_no of the specification
      -- a_revision  : revision of the specification
      -- a_plant     : plant where the specification has to be transferred to
      -- ** Return **
      -- 1 : The transfer has succeeded.
      -- 0 : The transfer has failed
      -- ** Remarks **
      -- THIS FUNCTION IS ONLY NECESSARY FOR THE CLIENT APPLICATION
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname       CONSTANT VARCHAR2(12) := 'LimsSpc';
      l_method          CONSTANT VARCHAR2(32) := 'f_TransferSpc';

      -- General variables
      l_return_value         BOOLEAN;
      l_return_value_temp    BOOLEAN;
      l_job_nr               INTEGER;
      
      --itlimsjob related variables
      l_to_be_transferred     CHAR(1);
      l_to_be_updated         CHAR(1);
      
      
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Part_No||' | '||a_revision, a_plant, NULL, PA_LIMS.c_Msg_Started);
      
      --Increase the priority (decrease the priority value (1=HIGH , 1000=LOW))
      --of that particular specification if it is marked as to be transferred
      UPDATE itlimsjob
      SET priority=1
      WHERE part_no = a_Part_No
        AND revision = a_Revision
        AND plant = a_plant
        AND (to_be_transferred<>'0' OR to_be_updated<>'0');  
      
      --If some modifications to priorities were done,
      --Dicrease the priority of the other specs
      --and trigger the execution of the job by setting
      --the next execution date to now
      IF SQL%ROWCOUNT >= 1 THEN
         UPDATE itlimsjob
         SET priority = LEAST(priority + 1, PA_LIMS.c_LowestSpecPriority)
         WHERE (part_no, revision, plant) NOT IN ((a_Part_No, a_Revision, a_plant));
                  
         --we commit to unlock the records of itlimsjob as fast as possible
      COMMIT;
         --trigger the job
         BEGIN
            SELECT job
            INTO l_job_nr
            FROM sys.DBA_JOBS
            WHERE what LIKE PA_LIMS.c_JobStringToSearch
            AND broken='N';
            DBMS_JOB.NEXT_DATE (l_job_nr, SYSDATE);
      l_return_value := TRUE;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer specification "'||a_part_no||'" | revision='||a_revision||
                          ' for plant "'||a_plant||'" to Unilab: The job "'||PA_LIMS.c_JobStringToSearch||'" is not running or disabled(Broken=Y)');
            l_return_value := FALSE;
         END;
      ELSE
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                             'An attempt was made to trigger the transfer of a spec that is not marked for transfer:"'||a_part_no||'" | revision='||a_revision||
                          ' for plant "'||a_plant||'"');
      END IF;
      --we commit here symetrically with the first update to itlimsjob in this procedure
      COMMIT;

      IF l_return_value THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
         RETURN (1);
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (0);
      END IF;
      
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error to ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer specification "'||a_part_no||'" | revision='||a_revision||
                       ' for plant "'||a_plant||'" to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
        RETURN(0);
   END f_TransferSpc;

   FUNCTION f_TransferUpdateASpc(
      a_Part_No    IN specification_header.part_no%TYPE  DEFAULT NULL,
      a_Revision   IN specification_header.revision%TYPE DEFAULT NULL
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer an update of the specification
      -- The following values have to be updated:
      -- - Planned effective date
      -- ** Return **
      -- TRUE  : The transfer has succeeded
      -- FALSE : The transfer has failed
      -- ** Remarks **
      -- This function is only necessary for the client application
      ------------------------------------------------------------------------------
      -- Constants variables for the tracing
      l_classname       CONSTANT VARCHAR2(12) := 'LimsSpc';
      l_method          CONSTANT VARCHAR2(32) := 'f_TransferUpdateASpc';
      l_object          VARCHAR2(255);

      -- General variables
      l_result                      BOOLEAN          DEFAULT TRUE;
      l_Generic_Part_No             VARCHAR2(20);
      l_Generic_Revision            NUMBER(8);
      l_st                          VARCHAR2(20);
      l_st_version                  VARCHAR2(20);
      l_pp_version                  VARCHAR2(20);
      l_linked_specification        BOOLEAN          DEFAULT FALSE;
      l_obsolete_updated            CHAR(1);
      l_must_be_updated             BOOLEAN;
      l_some_obsolete               CHAR(1);
      l_some_effective              CHAR(1);

      -- Cursor to get the planned effective date
      CURSOR l_PlannedDate_Cursor(c_Part_No    specification_prop.part_no%TYPE,
                                  c_Revision   specification_prop.revision%TYPE)
      IS
         SELECT planned_effective_date, f_part_descr(1, part_no) description
           FROM specification_header
          WHERE part_no = c_Part_No
            AND revision = c_Revision;

      -- Cursor to check if the specification is a linked specification
      CURSOR l_LinkedSpec_cursor(c_part_no        specification_header.part_no%TYPE,
                                 c_revision       specification_header.revision%TYPE,
                                 c_KwIdGenericSp  itkw.kw_id%TYPE)
      IS
         SELECT asp.*
           FROM specification_kw spk, attached_specification asp
          WHERE spk.part_no = asp.attached_part_no
            AND kw_id = c_KwIdGenericSp
            AND asp.part_no = c_part_no
            AND asp.revision = c_revision;
      
      -- Cursor to get all existing versions of the sampletype in Unilab
      CURSOR l_st_versions_cursor(c_st VARCHAR2)
      IS
         SELECT version
         FROM UVST@LNK_LIMS
         WHERE st = c_st
         ORDER BY version DESC;

      -- Cursor to get the revision of the generic specification from Interspec and Unilab
      CURSOR l_GenericSpec_Cursor(c_Part_No   specification_header.part_no%TYPE)
      IS
         SELECT revision
           FROM specification_header
          WHERE part_no = c_Part_No
            AND status = 4; -- current !

      -- Cursor to get the revision of the generic specification from Unilab
      CURSOR l_GenericSpecUnilab_Cursor(c_Part_No   specification_header.part_no%TYPE)
      IS
         SELECT revision
           FROM specification_header
          WHERE part_no = c_Part_No
       ORDER BY revision DESC;

      -- Cursor to get all the parameterprofiles (of this part_no) of this sampletype
      CURSOR l_GetStLinkedpp_Cursor(c_st VARCHAR2, c_version VARCHAR2, c_pp_desc VARCHAR2)
      IS
         SELECT pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
           FROM UVSTPP_PP_SPECX@LNK_LIMS
          WHERE st        = c_st
            AND version   = c_version
            AND description LIKE c_pp_desc||'%'
            AND ss        <> '@O';

      -- Exceptions
      l_EXC_TRANSFER    EXCEPTION;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Part_No||' | '||a_Revision, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Initializing variables
      l_object := 'part_no "'||a_part_no||'" | revision='||a_revision;

      -- Start the remote transaction
      IF NOT PA_LIMS.f_StartRemoteTransaction THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      BEGIN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, a_Part_No||' | '||a_Revision, NULL, NULL, 'Checking if it is a linked spec start');
         -- Check if the specification is a linked specification
         FOR l_LinkedSpec_rec IN l_LinkedSpec_cursor(a_part_no, a_revision, 
                                                     PA_LIMS.f_GetSettingValue('KW ID Generic Spc')) LOOP
            -- Indicate that it's a linked specification
            l_linked_specification := TRUE;

            -- Overrule the default values for the generic specification
            l_Generic_Part_No  := l_LinkedSpec_rec.Attached_Part_No;
            l_Generic_Revision := -1;

            -- Loop all Unilab versions of this specification
            FOR l_st_versions_rec IN l_st_versions_cursor(l_Generic_Part_No) LOOP
               -- When a linked specification, get the revision of the attached generic specification,
               -- not the attached revision!
               -- Retrieve the revision of the linked specification as known by
               -- Interspec and Unilab.
               FOR l_GenericSpec_Rec IN l_GenericSpec_Cursor(l_Generic_Part_No) LOOP
                  IF UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_Generic_Part_No, l_GenericSpec_Rec.revision) 
                     = l_st_versions_rec.version THEN
                        l_Generic_Revision := l_GenericSpec_Rec.Revision;
                  END IF;
               END LOOP;

               -- Fetch current revision in Unilab !
               IF l_Generic_Revision = -1 THEN
                  -- Get the revision number out of Unilab (do not look in Interspec)
                  FOR l_GenericSpecUnilab_Rec IN l_GenericSpecUnilab_Cursor(l_Generic_Part_No) LOOP
                     IF UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_Generic_Part_No, l_GenericSpecUnilab_Rec.revision) 
                        = l_st_versions_rec.version THEN
                        l_Generic_Revision := l_GenericSpecUnilab_Rec.revision;
                     END IF;
                  END LOOP;
               END IF;
            END LOOP;

            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 
                            'Linked specification of generic specification "'||l_Generic_Part_No||'" | revision='||
                            l_Generic_Revision);

            -- If spec doesn't need to be transferred, then following loggings are rather confusing.
            IF f_ToBeTransferred(a_part_no, a_revision, SUBSTR(l_Generic_Part_No,1,20), l_Generic_Revision) THEN
               -- Check if the generic specification was found. If not the user is trying to transfer a 
               -- linked specification before the generic specification was sent, this is not allowed !
               IF l_Generic_Revision = -1 THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to find in Unilab the generic specification with part_no "'||l_generic_part_no||
                                '" of linked specification with '||l_object||'.');
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  -- End the remote transaction
                  IF NOT PA_LIMS.f_EndRemoteTransaction THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  END IF;
                  RETURN (FALSE);
               END IF;
            END IF;
         END LOOP;
         
         PA_LIMS.p_Trace(l_classname, l_method, a_Part_No||' | '||a_Revision, NULL, NULL, 'Checking if it is a linked spec end');
         l_must_be_updated := TRUE;
         l_obsolete_updated := '0';
         --check if the update is due to an obsoletion
         SELECT NVL(MAX(obsolete_updated),'0')
         INTO l_obsolete_updated
         FROM itlimsjob b
         WHERE b.part_no = a_Part_No
           AND b.revision = a_Revision
           AND plant IN (SELECT plant
                         FROM itlimsplant a
                         WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                               (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                                  FROM itlimsplant b
                                 WHERE b.plant = PA_LIMS.f_ActivePlant));
         
         PA_LIMS.p_Trace(l_classname, l_method, a_Part_No||' | '||a_Revision, NULL, NULL, 'Obsolete is updated (1=YES, 0=NO):'||l_obsolete_updated);
         IF l_obsolete_updated = '1' THEN
            --check what is the actual status of the obsolete flag for that part
            --some plant with the same connection string may become obsolete and some other effective
            SELECT NVL(MAX(obsolete),'0'), NVL(MIN(obsolete),'0')
            INTO l_some_obsolete, l_some_effective
            FROM part_plant
            WHERE part_no = a_Part_No
              AND plant IN (SELECT plant
                            FROM itlimsplant a
                            WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                                  (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                                     FROM itlimsplant b
                                    WHERE b.plant = PA_LIMS.f_ActivePlant));
            PA_LIMS.p_Trace(l_classname, l_method, a_Part_No||' | '||a_Revision, NULL, NULL, 'Some Obsolete:'||l_some_obsolete||' Some effective:'||l_some_effective);
            IF l_some_obsolete = '1' THEN
               --plant must become obsolete for plant
               IF NOT f_MakePartObsolete4Plant(a_Part_No, a_Revision) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;
               l_must_be_updated := FALSE;
            END IF;
            IF l_some_effective = '0' THEN --logic is inverted here
               --plant must become effective for plant
               IF NOT f_MakePartEffective4Plant(a_Part_No, a_Revision) THEN
                  -- Raise an error
                  RAISE l_EXC_TRANSFER;
               END IF;
               l_must_be_updated := TRUE; --some modifications could be brought while the plant was marked as obsolete
                                          --to the effective date,...
            END IF;
         END IF;         
         IF l_must_be_updated = TRUE THEN
            -- Get the planned effective date from the specification
            FOR l_PlannedDate_Rec IN l_PlannedDate_Cursor(a_Part_No, a_Revision) LOOP
               -- Transfer the update of the effective_from date
               IF l_linked_specification THEN
                  l_st := SUBSTR(l_Generic_Part_No, 1, 20);
                  l_st_version := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_st, l_Generic_Revision);
                  FOR l_GetStLinkedpp_rec IN l_GetStLinkedpp_Cursor(l_st, l_st_version, a_part_no) LOOP
                     l_pp_version := UNAPIGEN.USEPPVERSION@LNK_LIMS(l_GetStLinkedpp_rec.pp, l_GetStLinkedpp_rec.pp_version,
                               l_GetStLinkedpp_rec.pp_key1, l_GetStLinkedpp_rec.pp_key2, l_GetStLinkedpp_rec.pp_key3,
                               l_GetStLinkedpp_rec.pp_key4, l_GetStLinkedpp_rec.pp_key5);
                     IF NOT f_TransferSpcPp(l_GetStLinkedpp_rec.pp, l_pp_version, l_GetStLinkedpp_rec.pp_key1, 
                                            l_GetStLinkedpp_rec.pp_key2, l_GetStLinkedpp_rec.pp_key3, 
                                            l_GetStLinkedpp_rec.pp_key4, l_GetStLinkedpp_rec.pp_key5, 
                                            l_PlannedDate_Rec.planned_effective_date, NULL, NULL, NULL, '0') THEN
                        -- Raise an error
                        RAISE l_EXC_TRANSFER;
                     END IF;
                  END LOOP;

                  -- Regenerate the version of the sampletype. The transfer of a parameterprofile with 
                  -- pp_key Product filled in, will have caused the creation of a new minor version of the 
                  -- sampletype if this sampletype was not modifiable (cfr. unapipp.SaveParameterProfile).
                  l_st_version := UNVERSION.SQLGETHIGHESTMINORVERSION@LNK_LIMS('st', l_st, l_st_version);
               ELSE
                  l_st := SUBSTR(a_Part_No, 1, 20);
                  l_st_version := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS('st', l_st, a_Revision);

                  -- Check if spec needs to be transferred
                  IF f_ToBeTransferred(a_part_no, a_revision, l_st, a_Revision) THEN
                     IF NOT f_TransferSpcSt(l_st, l_st_version, l_PlannedDate_Rec.planned_effective_date,
                                            NVL(f_GetStandardAuValue('DESCRIPTION',a_Part_No,a_Revision),l_PlannedDate_Rec.description),
                                            f_GetStandardAuValue('DESCRIPTION2',a_Part_No,a_Revision),
                                            f_GetStandardAuValue('SHELF_LIFE_VAL',a_Part_No,a_Revision),
                                            f_GetStandardAuValue('SHELF_LIFE_UNIT',a_Part_No,a_Revision),
                                            f_GetStandardAuValue('LABEL_FORMAT', a_Part_No, a_Revision),
                                            f_GetStandardAuValue('DEFAULT_PRIORITY',a_Part_No,a_Revision),
                                            NULL, '0') THEN
                        -- Raise an error
                        RAISE l_EXC_TRANSFER;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            l_result := FALSE;
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to transfer the update of specification with '||l_object||
                          ' for plant "'||PA_LIMS.f_ActivePlant||'" (Error code : '||SQLERRM||').');
      END;

      -- End the remote transaction
      IF NOT PA_LIMS.f_EndRemoteTransaction THEN
        -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      IF l_result THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
      END IF;

      RETURN (l_result);
   EXCEPTION
      WHEN OTHERS THEN
        -- Log an error to ITERROR
        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                      'Unable to transfer the update of specification with '||l_object||
                      ' to Unilab: '||SQLERRM);
        -- Tracing
        PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
        -- End the remote transaction
        IF NOT PA_LIMS.f_EndRemoteTransaction THEN
          -- Tracing
           PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
        END IF;
        RETURN(FALSE);
   END f_TransferUpdateASpc;

   FUNCTION f_TransferUpdateAllSpc(
      a_plant               IN VARCHAR2                           DEFAULT NULL,
      a_Part_No             IN specification_header.part_no%TYPE  DEFAULT NULL,
      a_Revision            IN specification_header.revision%TYPE DEFAULT NULL
   )
      RETURN BOOLEAN
   IS
       ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Transfer the specifications of all plants from Interspec to Unilab.
      -- The specifications must have the following characteristics:
      --    - The specification must have the state 'APPROVED'
      --    - The specification must be transferred for the active plant
      --    - The specification has a property group which use a
      --      display format that is set up for LIMS
      --    - The property group must have at least one property
      -- ** Parameters **
      -- a_plant     : plant where the specification has to be transferred to
      -- a_part_no   : part_no of the specification
      -- a_revision  : revision of the specification
      -- ** Return **
      -- TRUE  : The transfer has succeeded.
      -- FALSE : The transfer has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname       CONSTANT VARCHAR2(12) := 'LimsSpc';
      l_method          CONSTANT VARCHAR2(32) := 'f_TransferUpdateAllSpc';

      -- General variables
      l_result                            BOOLEAN               DEFAULT TRUE;
      l_lang_id                           NUMBER(2);
      l_same                              BOOLEAN               DEFAULT FALSE;
      l_first                             BOOLEAN;
      l_close                             BOOLEAN;
      l_last_LNK_LIMS_connect_string      VARCHAR2(40);
      l_return_value_temp                 BOOLEAN;

      -- Cursor to get the information about all the plants that have a LIMS db
      CURSOR l_plants_cursor(a_lowest_prio IN INTEGER) IS
        SELECT a.plant, a.connect_string, a.lang_id, a.lang_id_4id, NVL(b.plant_priority, a_lowest_prio ) priority
        FROM itlimsplant a, (SELECT plant, MIN(priority) plant_priority frOM itlimsjob WHERE to_be_updated<>'0' GROUP BY plant) b
        WHERE a.plant = b.plant(+)
        ORDER BY priority ASC;

      -- Cursor to get the information about the plant
      CURSOR l_plant_cursor(c_plant   plant.plant%TYPE)
      IS
         SELECT plant, connect_string, lang_id, lang_id_4id
           FROM itlimsplant
          WHERE plant = c_plant;

      -- Cursor to get all plants that have the same connection string and language id as the given plant
      CURSOR l_similar_plants_cursor(c_plant      plant.plant%TYPE, 
                                     c_part_no    specification_header.part_no%TYPE)
      IS
         SELECT a.*
           FROM itlimsplant a, part_plant pp
          WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                    (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                       FROM itlimsplant b
                      WHERE b.plant = c_plant)
            AND a.plant = pp.plant
            AND pp.part_no = c_part_no
         UNION --a part_plant relation can be deleted from part-plant but still exist in itlimsjob (we added this union to break and endless loop)
         SELECT a.*
           FROM itlimsplant a, itlimsjob pp
          WHERE (a.connect_string,a.lang_id,a.lang_id_4id) IN 
                    (SELECT b.connect_string,b.lang_id,b.lang_id_4id
                       FROM itlimsplant b
                      WHERE b.plant = c_plant)
            AND a.plant = pp.plant
            AND pp.part_no = c_part_no
         ;

/*
      -- Cursor to get all the specifications that have to be updated in Unilab
      CURSOR l_SpToTransferUpdate_Cursor(c_plant PLANT.PLANT%TYPE) IS
         SELECT job.revision, job.part_no
           FROM status_history sth, itlimsjob job
          WHERE sth.revision = job.revision
            AND sth.part_no = job.part_no
            AND sth.status_date_time > job.date_proceed
            AND job.date_proceed IS NOT NULL
            AND job.plant = c_plant
         UNION
         SELECT job.revision, job.part_no
           FROM jrnl_specification_header sphdjournal, itlimsjob job
          WHERE sphdjournal.revision = job.revision
            AND sphdjournal.part_no = job.part_no
            AND sphdjournal.timestamp > job.date_proceed
            AND job.date_proceed IS NOT NULL
            AND job.plant = c_plant
         ORDER BY 2;
*/

      -- Cursor to get all the specifications that have to be updated in Unilab
      CURSOR l_SpToTransferUpdate_Cursor(c_plant PLANT.PLANT%TYPE) IS
         SELECT job.revision, job.part_no
           FROM itlimsjob job
          WHERE job.to_be_updated = '2'
            AND job.date_transferred IS NOT NULL
            AND job.result_transfer = 1
            AND job.plant = c_plant
          ORDER BY 2;

/*
      -- Cursor to get all the specifications that have to be updated in Unilab
      -- handle also all plants that have the same connection string and language id as the given plant
      CURSOR l_SimilSpToTransferUpd_Cursor(c_plant PLANT.PLANT%TYPE) IS
         SELECT job.revision, job.part_no
           FROM status_history sth, itlimsjob job, itlimsplant pl
          WHERE sth.revision = job.revision
            AND sth.part_no = job.part_no
            AND sth.status_date_time > job.date_proceed
            AND job.date_proceed IS NOT NULL
            AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                    (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                       FROM itlimsplant pl2
                      WHERE pl2.plant = c_plant)
            AND pl.plant = job.plant         
         UNION
         SELECT job.revision, job.part_no
           FROM jrnl_specification_header sphdjournal, itlimsjob job, itlimsplant pl
          WHERE sphdjournal.revision = job.revision
            AND sphdjournal.part_no = job.part_no
            AND sphdjournal.timestamp > job.date_proceed
            AND job.date_proceed IS NOT NULL
            AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                    (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                       FROM itlimsplant pl2
                      WHERE pl2.plant = c_plant)
            AND pl.plant = job.plant         
          ORDER BY 2;
*/

      -- Cursor to get all the specifications that have to be updated in Unilab
      -- handle also all plants that have the same connection string and language id as the given plant
      CURSOR l_SimilSpToTransferUpd_Cursor(c_plant PLANT.PLANT%TYPE) IS
         SELECT DISTINCT job.revision, job.part_no, job.priority
           FROM itlimsjob job, itlimsplant pl
          WHERE job.to_be_updated = '2'          --to be sure it must be updated
            AND job.date_transferred IS NOT NULL --to be sure it has been transferred and existing in Unilab
            AND job.result_transfer = 1          --           and successfully transferred
            AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                    (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                       FROM itlimsplant pl2
                      WHERE pl2.plant = c_plant)
            AND pl.plant = job.plant         
          ORDER BY job.priority;

      -- Local procedure to handle the update of the specification
      PROCEDURE p_HandleTransferUpdateASpc(
         a_Part_No             IN specification_header.part_no%TYPE  DEFAULT NULL,
         a_Revision            IN specification_header.revision%TYPE DEFAULT NULL
      )
      IS
      BEGIN

         --we wait for Unilab to process the events but we ignore the return value of the function
         --if we didn't wait already for it
         IF NVL(PA_LIMS.g_LNK_LIMS_connect_string, ' ') <> NVL(l_last_LNK_LIMS_connect_string, ' ') THEN
            l_return_value_temp := PA_LIMS.f_Wait4EndOfEventProcessing;
            l_last_LNK_LIMS_connect_string := PA_LIMS.g_LNK_LIMS_connect_string;
         END IF;
      
         -- Transfer the specification
         IF f_TransferUpdateASpc(a_Part_No, a_Revision) THEN
            -- Save the result for all plants with the same connection string and language id
            FOR l_plant_rec IN l_similar_plants_cursor(PA_LIMS.f_ActivePlant, a_part_no) LOOP
               -- Save the result of the transfer of the specification

               -- Client application must be adapted (history button must be added)!!! - TEAM 2296
/*
               BEGIN
                  INSERT INTO itlimsjob_h(plant, part_no, revision, date_ready, date_proceed, result_proceed)
                       SELECT plant, part_no, revision, date_ready, SYSDATE, 1
                         FROM itlimsjob
                        WHERE plant    = l_plant_rec.plant
                          AND part_no  = a_Part_No
                          AND revision = a_Revision;
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX THEN
                     UPDATE itlimsjob_h 
                        SET date_proceed   = SYSDATE,
                            result_proceed = 1
                      WHERE plant    = l_plant_rec.plant
                        AND part_no  = a_Part_No
                        AND revision = a_Revision;
                  WHEN OTHERS THEN
                     RAISE;
               END;
               DELETE FROM itlimsjob
                     WHERE plant    = l_plant_rec.plant
                       AND part_no  = a_Part_No
                       AND revision = a_Revision;
*/

               -- Save the result of the transfer of the specification
               UPDATE itlimsjob
                  SET date_last_updated = SYSDATE,
                      result_last_update = 1,
                      to_be_updated = DECODE(to_be_updated,'2','0',to_be_updated),
                      obsolete_updated = '0',
                      date_proceed   = GREATEST(SYSDATE,NVL(date_transferred, SYSDATE)),
                      --result_proceed = LEAST(1, DECODE(to_be_updated,'2',NVL(result_transfer,0),1))
                      --decode can not be used since decode is not seing to_be_updated=0
                      result_proceed = LEAST(1, NVL(result_transfer,0))
                WHERE plant    = l_plant_rec.plant
                  AND part_no  = a_Part_No
                  AND revision = a_Revision;
            END LOOP;
            COMMIT;
         ELSE
            l_result := FALSE;
            ROLLBACK;
            -- Save the result for all plants with the same connection string and language id
            FOR l_plant_rec IN l_similar_plants_cursor(PA_LIMS.f_ActivePlant, a_part_no) LOOP
               -- Save the result of the transfer of the specification
               UPDATE itlimsjob
                  SET date_last_updated = SYSDATE,
                      result_last_update = 0,
                      date_proceed   = GREATEST(SYSDATE,NVL(date_transferred, SYSDATE)),
                      result_proceed = LEAST(0, NVL(result_transfer,0))
                WHERE plant    = l_plant_rec.plant
                  AND part_no  = a_Part_No
                  AND revision = a_Revision;
            END LOOP;
            COMMIT;
         END IF;
      END p_HandleTransferUpdateASpc;
      -- Local procedure to handle all the specifications of a plant
      --according to a priority system and accordng to a functional order
      FUNCTION p_HandleUpdateOfAPlant(
          a_plant               IN VARCHAR2                           DEFAULT NULL
       )
       RETURN BOOLEAN IS
       l_first                           BOOLEAN;
       l_close                           BOOLEAN;
       l_iterations                      INTEGER;
       l_count_new_with_higher_prio      INTEGER;
       BEGIN 
          --validation input arguments 
          IF a_plant IS NULL THEN
             RAISE_APPLICATION_ERROR(-20000, 'p_HandleUpdateOfAPlant called with an empty a_plant');
          END IF;      
          --Mian loop
          l_first := TRUE;
          l_close := FALSE;
          <<main_loop>>
          LOOP
             l_iterations := 0;
             -- Transfer all the specifications for the plant
             FOR l_SimilSpToTransferUpdate_Rec IN l_SimilSpToTransferUpd_Cursor(a_plant) LOOP
                l_iterations := l_iterations + 1;
                IF l_first THEN
                   l_first := FALSE;
                   -- Setup the connection for the plant
                   IF NOT PA_LIMS.f_SetupLimsConnection(a_plant) THEN
                      l_result := FALSE;
                      EXIT main_loop;
                   END IF;
                   l_close := TRUE;
                END IF;

                -- Handle the transfer of the specification
                p_HandleTransferUpdateASpc(l_SimilSpToTransferUpdate_Rec.Part_No, l_SimilSpToTransferUpdate_Rec.Revision);
                
                --every x iterations (PA_LIMS.c_NrIterationsForReevaluation),
                -- Action1: At least the cursor must be reopened 
                -- Action2: i a very specific case, the cursor must be closed and the complete transfer restarted
                -- 
                --Case : a specification that is not marked as to be transfered has been added/updated in itlimsjob with a very high priority
                --        if such a specification is found than the compplete transfer must be relaunched to be sure
                --        that the configuration is transferred for these new specs to be transferred
                IF l_iterations >= PA_LIMS.c_NrIterationsForReevaluation THEN
                   SELECT COUNT('X')
                   INTO l_count_new_with_higher_prio
                   FROM itlimsjob
                   WHERE priority < (SELECT NVL(MIN(priority),1000) 
                                     FROM itlimsjob limsj
                                     WHERE limsj.to_be_transferred = '2'
                                     AND limsj.date_ready > SYSDATE - 14
                                     AND plant IN (SELECT pl3.plant
                                                   FROM itlimsplant pl3
                                                   WHERE (pl3.connect_string,pl3.lang_id,pl3.lang_id_4id) IN 
                                                       (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                                                        FROM itlimsplant pl2
                                                        WHERE pl2.plant = a_plant)))
                   AND date_last_updated IS NULL
                   --2 cases here: a spec has been added to the queue or the priority of a spec for another plant has been increased
                   AND ((to_be_updated = '1') 
                        OR
                        (to_be_updated = '2' 
                         AND plant NOT IN (SELECT pl3.plant
                                           FROM itlimsplant pl3
                                           WHERE (pl3.connect_string,pl3.lang_id,pl3.lang_id_4id) IN 
                                                 (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                                                  FROM itlimsplant pl2
                                                  WHERE pl2.plant = a_plant))));
                   IF l_count_new_with_higher_prio>0 THEN
                      PA_LIMS.g_RestartACompleteTransfer := TRUE;
                      l_iterations := 0;  --to force an immediate exit of the outside loop
                      EXIT; -- exit from inside loop
                   END IF;
                   EXIT;
                END IF;
             END LOOP;
             EXIT WHEN (l_iterations = 0);
          END LOOP;
          IF l_close THEN
             -- Close the connection for the plant
             IF NOT PA_LIMS.f_CloseLimsConnection THEN
                l_result := FALSE;
             END IF;
          END IF;
          RETURN (l_result);
       END p_HandleUpdateOfAPlant;

   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_part_no||' | '||a_revision, a_plant, NULL, PA_LIMS.c_Msg_Started);

      -- Transfer the specifications for all the plants
      IF a_plant IS NULL THEN
         FOR l_plants_rec IN l_plants_cursor(PA_LIMS.c_LowestSpecPriority) LOOP
            -- Check if a plant with the same connection string and language id has already been handled
            -- Loop all handled plants
            FOR i IN 1..PA_LIMSSPC.g_nr_of_plants LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_plants_rec.connect_string, PA_LIMSSPC.g_connect_string_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plants_rec.lang_id, PA_LIMSSPC.g_lang_id_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plants_rec.lang_id_4id, PA_LIMSSPC.g_lang_id_4id_tab(i)) = 1 THEN
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
               IF NOT a_Part_No IS NULL THEN
                  -- Setup the connection for the plant
                  IF NOT PA_LIMS.f_SetupLimsConnection(l_plants_rec.plant) THEN
                     l_result := FALSE;
                  ELSE
                     -- Set the language in interspec 5.1 (exception handler necessary for compatibilty with 6.3)
                     -- Pa_Cnstnt.l_language := l_plants_rec.lang_id;
                     BEGIN EXECUTE IMMEDIATE 'BEGIN pa_cnstnt.l_language := :lang_id; END;'
                           USING l_plants_rec.lang_id;
                     EXCEPTION WHEN OTHERS THEN NULL; END;               
                     --Modified in 6.1 sp1 (exception handler necessary for backward compatibility interspc 5.1)
                     BEGIN EXECUTE IMMEDIATE 'BEGIN iapiGeneral.SESSION.SETTINGS.LanguageId := :lang_id; END;'
                           USING l_plants_rec.lang_id;
                     EXCEPTION WHEN OTHERS THEN NULL; END;

                     -- Handle the update of the specification
                     p_HandleTransferUpdateASpc(a_part_no, a_revision);

                     -- Close the connection for the plant
                     IF NOT PA_LIMS.f_CloseLimsConnection THEN
                        l_result := FALSE;
                     END IF;
                  END IF;
               ELSE
                  -- Set the language in interspec 5.1 (exception handler necessary for compatibilty with 6.3)
                  -- Pa_Cnstnt.l_language := l_plants_rec.lang_id;
                  BEGIN EXECUTE IMMEDIATE 'BEGIN pa_cnstnt.l_language := :lang_id; END;'
                        USING l_plants_rec.lang_id;
                  EXCEPTION WHEN OTHERS THEN NULL; END;               
                  --Modified in 6.1 sp1 (exception handler necessary for backward compatibility interspc 5.1)
                  BEGIN EXECUTE IMMEDIATE 'BEGIN iapiGeneral.SESSION.SETTINGS.LanguageId := :lang_id; END;'
                        USING l_plants_rec.lang_id;
                  EXCEPTION WHEN OTHERS THEN NULL; END;

                  l_result := p_HandleUpdateOfAPlant(l_plants_rec.plant);
               END IF;
            END IF;
         END LOOP;
      -- Transfer the specifications for a specific plant
      ELSE
         FOR l_plant_rec IN l_plant_cursor(a_plant) LOOP
            l_lang_id := l_plant_rec.lang_id;

            -- Check if a plant with the same connection string and language id has already been handled
            -- Loop all handled plants
            FOR i IN 1..PA_LIMSSPC.g_nr_of_plants LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_plant_rec.connect_string, PA_LIMSSPC.g_connect_string_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plant_rec.lang_id, PA_LIMSSPC.g_lang_id_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plant_rec.lang_id_4id, PA_LIMSSPC.g_lang_id_4id_tab(i)) = 1 THEN
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
            IF NOT a_Part_No IS NULL THEN
               -- Setup the connection for the plant
               IF NOT PA_LIMS.f_SetupLimsConnection(a_plant) THEN
                  l_result := FALSE;
               ELSE
                  -- Set the language in interspec 5.1 (exception handler necessary for compatibilty with 6.3)
                  -- Pa_Cnstnt.l_language := l_lang_id;
                  BEGIN EXECUTE IMMEDIATE 'BEGIN pa_cnstnt.l_language := :lang_id; END;'
                        USING l_lang_id;
                  EXCEPTION WHEN OTHERS THEN NULL; END;               
                  --Modified in 6.1 sp1 (exception handler necessary for backward compatibility interspc 5.1)
                  BEGIN EXECUTE IMMEDIATE 'BEGIN iapiGeneral.SESSION.SETTINGS.LanguageId := :lang_id; END;'
                        USING l_lang_id;
                  EXCEPTION WHEN OTHERS THEN NULL; END;

                  -- Handle the update of the specification
                  p_HandleTransferUpdateASpc(a_part_no, a_revision);

                  -- Close the connection for the plant
                  IF NOT PA_LIMS.f_CloseLimsConnection THEN
                     l_result := FALSE;
                  END IF;
               END IF;
            ELSE
               -- Set the language in interspec 5.1 (exception handler necessary for compatibilty with 6.3)
               -- Pa_Cnstnt.l_language := l_lang_id;
               BEGIN EXECUTE IMMEDIATE 'BEGIN pa_cnstnt.l_language := :lang_id; END;'
                     USING l_lang_id;
               EXCEPTION WHEN OTHERS THEN NULL; END;               
               --Modified in 6.1 sp1 (exception handler necessary for backward compatibility interspc 5.1)
               BEGIN EXECUTE IMMEDIATE 'BEGIN iapiGeneral.SESSION.SETTINGS.LanguageId := :lang_id; END;'
                     USING l_lang_id;
               EXCEPTION WHEN OTHERS THEN NULL; END;

               l_result := p_HandleUpdateOfAPlant(a_plant);
            END IF;
         END IF;
      END IF;

      -- Clear the global arrays
      PA_LIMSSPC.g_nr_of_plants := 0;
      
      IF l_result THEN
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
           PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to close the connection.');
        END IF;
        -- Log an error to ITERROR
        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                      'Unable to transfer the update of the specifications to Unilab: '||SQLERRM);
        -- Tracing
        PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
        -- Clear the global arrays
        PA_LIMSSPC.g_nr_of_plants := 0;
        RETURN(FALSE);
   END f_TransferUpdateAllSpc;

   FUNCTION f_TransferAHistObs(
      a_Part_No            IN specification_header.part_no%TYPE,
      a_Revision           IN specification_header.revision%TYPE,
      a_obsolescence_date  IN specification_header.obsolescence_date%TYPE
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- If a specification becomes obsolete in Interspec, make it obsolete in Unilab also.
      -- ** Parameters **
      -- a_part_no           : part_no of the specification
      -- a_revision          : revision of the specification
      -- a_obsolescence_date : date the object became obsolete in Interspec
      -- ** Return **
      -- TRUE  : The transfer has succeeded.
      -- FALSE : The transfer has failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname          CONSTANT VARCHAR2(12) := 'LimsSpc';
      l_method             CONSTANT VARCHAR2(32) := 'f_TransferAHistObs';
      l_object             VARCHAR2(255);

      -- General variables
      l_return_value                NUMBER     DEFAULT 1;
      l_StId                        VARCHAR2(20);
      l_st_version                  VARCHAR2(20);
      l_StId_changestatus           VARCHAR2(20);
      l_StId_status                 VARCHAR2(2);
      l_Generic_Part_No             VARCHAR2(20);
      l_Generic_Revision            NUMBER(8);
      l_LinkedSpecification         BOOLEAN      DEFAULT FALSE;
      a_object_tp                   VARCHAR2(4);
      a_st                          VARCHAR2(20);
      a_st_version                  VARCHAR2(20);
      a_pp                          VARCHAR2(20);
      a_pp_version                  VARCHAR2(20);
      a_pp_key1                     VARCHAR2(20);
      a_pp_key2                     VARCHAR2(20);
      a_pp_key3                     VARCHAR2(20);
      a_pp_key4                     VARCHAR2(20);
      a_pp_key5                     VARCHAR2(20);
      a_old_ss                      VARCHAR2(2);
      a_new_ss                      VARCHAR2(2);
      a_object_lc                   VARCHAR2(2);
      a_object_lc_version           VARCHAR2(20);
      a_modify_reason               VARCHAR2(255);
      l_pp_tab                      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS_H;
      l_pp_version_tab              UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS_H;
      l_pp_key1_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS_H;
      l_pp_key2_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS_H;
      l_pp_key3_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS_H;
      l_pp_key4_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS_H;
      l_pp_key5_tab                 UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS_H;
      l_i                           INTEGER;
      l_log_hs                      CHAR(1);
      l_tr_seq_nr                   NUMBER;
      l_ev_seq_nr                   NUMBER;
      l_orig_nr_of_rows             NUMBER;
      l_newminor                    BOOLEAN                             DEFAULT FALSE;
      
      -- Specific local variables for the 'SaveStParameterProfile' API
      l_freq_tp_tab                 UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS_H;
      l_freq_val_tab                UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS_H;
      l_freq_unit_tab               UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS_H;
      l_invert_freq_tab             UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS_H;
      l_last_sched_tab              UNAPIGEN.DATE_TABLE_TYPE@LNK_LIMS_H;
      l_last_cnt_tab                UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS_H;
      l_last_val_tab                UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS_H;
      l_inherit_au_tab              UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS_H;
      l_nr_of_rows                  NUMBER;
      l_next_rows                   NUMBER := -1;
      l_modify_reason               VARCHAR2(255);

      -- Specific local variables for the 'CopySampleType' API
      l_new_StId                    VARCHAR2(20);
      l_new_st_version              VARCHAR2(20);
      l_old_st_version              VARCHAR2(20);

      -- Specific local variables for the 'GetAuthorisation' API
      l_ret_code               INTEGER;
      l_st_lc                  VARCHAR2(2);
      l_st_lc_version          VARCHAR2(20);
      l_st_ss                  VARCHAR2(2);
      l_st_log_hs              CHAR(1);
      l_st_allow_modify        CHAR(1);
      l_st_active              CHAR(1);

      -- Cursor to check if the specification is a linked specification
      CURSOR l_LinkedSpec_Cursor(
         c_Part_No         specification_header.part_no%TYPE,
         c_Revision        specification_header.revision%TYPE,
         c_KwIdGenericSp   itkw.kw_id%TYPE
      )
      IS
         SELECT asp.attached_part_no,
                DECODE(
                   asp.attached_revision,
                   0, F_Rev_Part_Phantom(asp.attached_part_no, 0), -- the attached specification is a phantom (Always take the highest current revision)
                   asp.attached_revision
                ) attached_revision
           FROM specification_kw spk, attached_specification asp
          WHERE spk.part_no = asp.attached_part_no
            AND kw_id = c_KwIdGenericSp
            AND asp.part_no = c_Part_No
            AND asp.revision = c_Revision;

      -- Cursor to get all existing versions of the sampletype in Unilab
      CURSOR l_st_versions_cursor(c_st VARCHAR2)
      IS
         SELECT version
         FROM UVST@LNK_LIMS_H
         WHERE st = c_st
         ORDER BY version DESC;

      -- Cursor to get the revision of the generic specification from Interspec and Unilab
      CURSOR l_GenericSpec_Cursor(c_Part_No   specification_header.part_no%TYPE)
      IS
         SELECT revision
           FROM specification_header
          WHERE part_no = c_Part_No
            AND status = 4; -- current !

      -- Cursor to get the revision of the generic specification from Unilab
      CURSOR l_GenericSpecUnilab_Cursor(c_Part_No   specification_header.part_no%TYPE)
      IS
         SELECT revision
           FROM specification_header
          WHERE part_no = c_Part_No
       ORDER BY revision DESC;

      -- Cursor to get all the links between the parameterprofiles and the sampletype
      -- This cursor is used to determine which parameter profiles have to be made obsolete
      -- We do not touch to the parameter profiles that have been created in Unilab
      -- this explains why we join with the uvppau in this cursor
      CURSOR l_GetStpp_Cursor(c_st VARCHAR2, c_version VARCHAR2)
      IS
         SELECT stpp.pp, stpp.pp_version, 
                stpp.pp_key1, stpp.pp_key2, stpp.pp_key3, stpp.pp_key4, stpp.pp_key5, 
                stpp.description, stpp.ss, stpp.lc, stpp.lc_version, stpp.freq_tp, stpp.freq_val,
                stpp.freq_unit, stpp.invert_freq, stpp.last_sched, stpp.last_cnt, stpp.last_val, 
                stpp.inherit_au
           FROM UVPPAU@LNK_LIMS_H ppau, UVSTPP_PP_SPECX@LNK_LIMS_H stpp
          WHERE stpp.st      = c_st
            AND stpp.version = c_version
            AND ppau.pp      = stpp.pp
            AND ppau.pp_key1 = stpp.pp_key1
            AND ppau.pp_key2 = stpp.pp_key2
            AND ppau.pp_key3 = stpp.pp_key3
            AND ppau.pp_key4 = stpp.pp_key4
            AND ppau.pp_key5 = stpp.pp_key5
            AND ppau.version = stpp.pp_exact_version
            AND ppau.au      = PA_LIMS.c_au_orig_name
          ORDER BY seq;

      -- Cursor to check if the sampletype is obsolete
      CURSOR l_GetSt_Cursor(c_st VARCHAR2, c_version VARCHAR2)
      IS
         SELECT st.st, st.ss
           FROM UVST@LNK_LIMS_H st
          WHERE st.st           = c_st
            AND st.version      = c_version
            AND NVL(st.ss,' ') <> '@O';
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_Part_No||' | '||a_revision, a_obsolescence_date, NULL, PA_LIMS.c_Msg_Started);

      -- Start the remote transaction
      IF NOT PA_LIMS.f_StartRemoteTransaction_h THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Set the default values for the generic specification. These default
      -- values are only overruled if there is a linked specification
      l_Generic_Part_No  := a_Part_No;
      l_Generic_Revision := a_Revision;

      -- Check if the specification is a linked specification
      FOR l_LinkedSpec_Rec IN l_LinkedSpec_Cursor(a_Part_No, a_Revision, PA_LIMS.f_GetSettingValue('KW ID Generic Spc')) LOOP
         -- Indicate that it's a linked specification
         l_LinkedSpecification := TRUE;

         -- Overrule the default values for the generic specification
         l_Generic_Part_No  := l_LinkedSpec_Rec.Attached_Part_No;
         l_Generic_Revision := -1;

         -- Loop all Unilab versions of this specification
         FOR l_st_versions_rec IN l_st_versions_cursor(l_Generic_Part_No) LOOP
            -- When a linked specification, get the revision of the attached generic specification,
            -- not the attached revision!
            -- Retrieve the revision of the linked specification as known by
            -- Interspec and Unilab.
            FOR l_GenericSpec_Rec IN l_GenericSpec_Cursor(l_Generic_Part_No) LOOP
               IF UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS_H('st', l_Generic_Part_No, l_GenericSpec_Rec.revision) 
                  = l_st_versions_rec.version THEN
                     l_Generic_Revision := l_GenericSpec_Rec.Revision;
               END IF;
            END LOOP;

            -- Fetch current revision in Unilab !
            IF l_Generic_Revision = -1 THEN
               -- Get the revision number out of Unilab (do not look in Interspec)
               FOR l_GenericSpecUnilab_Rec IN l_GenericSpecUnilab_Cursor(l_Generic_Part_No) LOOP
                  IF UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS_H('st', l_Generic_Part_No, l_GenericSpecUnilab_Rec.revision) 
                     = l_st_versions_rec.version THEN
                     l_Generic_Revision := l_GenericSpecUnilab_Rec.revision;
                  END IF;
               END LOOP;
            END IF;
         END LOOP;

         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                         'Linked specification of generic specification "'||l_Generic_Part_No||'" | revision='||
                         l_Generic_Revision);

         -- Check if the generic specification was found. If not the user is trying to transfer a 
         -- linked specification before the generic specification was sent, this is not allowed !
         IF l_Generic_Revision = -1 THEN
            -- Log an error to ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to find in Unilab the generic specification with part_no "'||l_generic_part_no||
                          '" of linked specification with part_no "'||a_part_no||'" | revision='||a_revision||'.');
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            -- End the remote transaction
            IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            END IF;
            RETURN (FALSE);
         END IF;
      END LOOP;

      -- Generate the sampletype id and version
      l_StId := SUBSTR(l_Generic_Part_No, 1, 20);
      l_st_version := UNVERSION.CONVERTINTERSPEC2UNILAB@LNK_LIMS_H('st', l_StId, l_Generic_Revision);

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'Sample type "'||l_stid||'" | version='||l_st_version);

      -- Get all the links between the parameterprofiles (of this part_no) and the sampletype
      l_nr_of_rows := 0;
      l_orig_nr_of_rows := 0;
      FOR l_GetStPp_rec IN l_GetStpp_Cursor(l_StId, l_st_version) LOOP
         -- Initializing variables
         l_object := 'parameterprofile "'||l_GetStPp_rec.pp||'" | version='||l_GetStPp_rec.pp_version||
                     ' | pp_keys="'||l_GetStPp_rec.pp_key1||'"#"'||l_GetStPp_rec.pp_key2||'"#"'||l_GetStPp_rec.pp_key3||
                     '"#"'||l_GetStPp_rec.pp_key4||'"#"'||l_GetStPp_rec.pp_key5||'" | status='||l_GetStPp_rec.ss||
                     ' | sample type="'||l_StID||'" | version='||l_st_version;
         
         l_orig_nr_of_rows := l_orig_nr_of_rows + 1;
         IF (l_LinkedSpecification AND (l_GetStPp_rec.description NOT LIKE a_part_no||'%')) THEN
            -- Fill in the parameters to save the standard attributes of the link 
            -- between the parameterprofiles and the sampletype.
            l_nr_of_rows := l_nr_of_rows + 1;
            l_pp_tab (l_nr_of_rows)         := l_GetStPp_rec.pp;
            l_pp_version_tab (l_nr_of_rows) := l_GetStPp_rec.pp_version;
            l_pp_key1_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key1;
            l_pp_key2_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key2;
            l_pp_key3_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key3;
            l_pp_key4_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key4;
            l_pp_key5_tab (l_nr_of_rows)    := l_GetStPp_rec.pp_key5;
            l_freq_tp_tab (l_nr_of_rows)    := SUBSTR(l_GetStPp_rec.freq_tp,1,1);
            l_freq_val_tab (l_nr_of_rows)   := l_GetStPp_rec.freq_val;
            l_freq_unit_tab (l_nr_of_rows)  := l_GetStPp_rec.freq_unit;
            l_invert_freq_tab (l_nr_of_rows):= SUBSTR(l_GetStPp_rec.invert_freq,1,1);
            l_last_sched_tab (l_nr_of_rows) := l_GetStPp_rec.last_sched;
            l_last_cnt_tab (l_nr_of_rows)   := l_GetStPp_rec.last_cnt;
            l_last_val_tab (l_nr_of_rows)   := l_GetStPp_rec.last_val;
            l_inherit_au_tab (l_nr_of_rows) := SUBSTR(l_GetStPp_rec.inherit_au,1,1);
         END IF;

         IF (l_LinkedSpecification AND (l_GetStPp_rec.description LIKE a_part_no||'%')) OR
            (NOT l_LinkedSpecification) THEN
            IF l_GetStPp_rec.ss <> '@O' THEN
               -- Fill in the parameters to change the status of the parameterprofile
               a_pp                   := l_GetStPp_rec.pp;
               a_pp_version           := UNAPIGEN.USEPPVERSION@LNK_LIMS_H(l_GetStPp_rec.pp, l_GetStPp_rec.pp_version,
                                            l_GetStPp_rec.pp_key1, l_GetStPp_rec.pp_key2, l_GetStPp_rec.pp_key3,
                                            l_GetStPp_rec.pp_key4, l_GetStPp_rec.pp_key5);
               a_pp_key1              := l_GetStPp_rec.pp_key1;
               a_pp_key2              := l_GetStPp_rec.pp_key2;
               a_pp_key3              := l_GetStPp_rec.pp_key3;
               a_pp_key4              := l_GetStPp_rec.pp_key4;
               a_pp_key5              := l_GetStPp_rec.pp_key5;
               a_old_ss               := l_GetStPp_rec.ss;
               a_new_ss               := '@O';
               a_object_lc            := l_GetStPp_rec.lc;
               a_object_lc_version    := l_GetStPp_rec.lc_version;
               a_modify_reason        := 'There is no current revision of specification "'||a_part_no||'" | revision='||
                                         a_revision||' in Interspec as from '||
                                         TO_CHAR(a_obsolescence_date,'DDfx/fxMM/RRRR HH24fx:fxMI:SS');
               -- lc is empty => take default lc
               IF a_object_lc IS NULL THEN
                  BEGIN
                     SELECT uvobjects.def_lc, uvlc.version
                       INTO a_object_lc, a_object_lc_version 
                       FROM UVOBJECTS@LNK_LIMS_H, UVLC@LNK_LIMS_H
                      WHERE uvobjects.object = 'pp'
                        AND uvobjects.def_lc = uvlc.lc
                        AND uvlc.version_is_current = '1';
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'No current version found for the default parameterprofile lifecycle.');
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     -- End the remote transaction
                     IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
                        -- Tracing
                        PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     END IF;
                     RETURN (FALSE);
                  END;
               END IF;

               -- Change the status of the parameterprofile
               BEGIN
                  l_return_value := UNAPIPPP.CHANGEPPSTATUS@LNK_LIMS_H(a_pp, a_pp_version, a_pp_key1, a_pp_key2, a_pp_key3,
                                       a_pp_key4, a_pp_key5, a_old_ss, a_new_ss, a_object_lc, a_object_lc_version,
                                       a_modify_reason);
                  -- If the error is a general failure then the SQLERRM must be logged, otherwise
                  -- the error code is the Unilab error
                  IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
                     IF l_return_value = PA_LIMS.DBERR_GENFAIL THEN
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to change the status of '||l_object||' (General failure! Error Code: '||
                                      l_return_value||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS_H||').');
                     ELSE
                        -- Log an error to ITERROR
                        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                      'Unable to change the status of '||l_object||' (Error code : '||l_return_value||').');
                     END IF;

                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     -- End the remote transaction
                     IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
                        -- Tracing
                        PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     END IF;
                     RETURN (FALSE);
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     -- Log an error in ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to change the status of '||l_object||' : '||SQLERRM);
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     -- End the remote transaction
                     IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
                        -- Tracing
                        PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                     END IF;
                     RETURN (FALSE);
               END;
            END IF;
         END IF;
      END LOOP;

      -- Initializing variables
      l_object := 'sample type "'||l_StID||'" | version='||l_st_version;
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL,
                      'Number of pp BEFORE = '||l_orig_nr_of_rows||' - number of pp AFTER = '||l_nr_of_rows);
      -- If the number of rows differs before and after the specification has been set historic/obsolete
      IF l_orig_nr_of_rows <> l_nr_of_rows THEN
         -- Check if a new minor version of the sampletype has to be created
         -- Get the authorisation of the sample type
         l_ret_code := UNAPIGEN.GETAUTHORISATION@LNK_LIMS_H('st', l_StID, l_st_version, l_st_lc, l_st_lc_version, 
                                                            l_st_ss, l_st_allow_modify, l_st_active, l_st_log_hs);
         IF l_ret_code = PA_LIMS.DBERR_NOTMODIFIABLE THEN
            -- Not modifiable, new minor version has to be created before parameterprofile can be assigend
            l_newminor := TRUE;
         ELSIF l_ret_code <> PA_LIMS.DBERR_SUCCESS THEN
            IF l_ret_code = PA_LIMS.DBERR_GENFAIL THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to get the authorisation of '||l_object||' (General failure! Error Code: '||
                             l_ret_code||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS_H||').');
            ELSE
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to get the authorisation of '||l_object||' (Error code : '||l_ret_code||').');
            END IF;
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
         
         -- In fact the f_TransferSpcSt evaluates if it is really necessary to create a new minor version.
         -- If not modifiable, a new minor version will be created; in the other case
         -- the given version will be modified.
         IF (l_newminor) THEN
            -- NORMALLY the api f_TransferSpcSt should be called here (cfr api f_TransferSpcStPp), but this api
            -- does not use the LNK_LIMS_H link, but LNK_LIMS. In fact, a new api f_TransferSpcSt_h should be created,
            -- but because only a very small part of the api would be executed, this small part has been copied here
            -- instead of copying a whole api.
            BEGIN
               -- Fill in the parameters to save the standard attributes of the sampletype
               l_new_StID          := l_StID;
               l_new_st_version    := NULL;
               l_modify_reason     := 'Imported a new version of sample type "'||l_StID||'" from Interspec.';
               -- Create a new minor version of the sampletype
               l_return_value := UNAPIST.COPYSAMPLETYPE@LNK_LIMS_H(l_StID, l_st_version, 
                                                                   l_new_StID, l_new_st_version, l_modify_reason);
               -- If the error is a general failure then the SQLERRM must be logged, otherwise
               -- the error code is the Unilab error
               IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
                  IF l_return_value = PA_LIMS.DBERR_GENFAIL THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save a new version of '||l_object||' (General failure! Error Code: '||
                                   l_return_value||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS_H||').');
                  ELSE
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to save a new version of '||l_object||' (Error code : '||l_return_value||').');
                  END IF;
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  -- End the remote transaction
                  IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  END IF;
                  RETURN (FALSE);
               END IF;
               -- Store the original version, for a check on the current flag later in the code
               l_old_st_version := l_st_version;
               -- Save the new version
               l_st_version := l_new_st_version;
            EXCEPTION
               WHEN OTHERS THEN
                  -- Log an error in ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to save a new version of '||l_object||' : '||SQLERRM);
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  -- End the remote transaction
                  IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  END IF;
                  RETURN (FALSE);
            END;
         END IF;

         -- Delete the link between the parameterprofiles and the sampletype
         -- Fill in the parameters to save the standard attributes of the link 
         -- between the parameterprofiles and the sampletype.
         l_modify_reason := 'Removed the link between the parameter profiles and sample type "'||l_stid||
                            '" because there is no current revision of specification "'||a_part_no||'" | revision='||
                            a_revision||' in Interspec anymore.';
         BEGIN
            -- Save the standard attributes of the link between the parameterprofiles and the sampletype.
            l_return_value := UNAPIST.SAVESTPARAMETERPROFILE@LNK_LIMS_H(l_stid, l_st_version, l_pp_tab, l_pp_version_tab,
                                 l_pp_key1_tab, l_pp_key2_tab, l_pp_key3_tab, l_pp_key4_tab, l_pp_key5_tab, l_freq_tp_tab,
                                 l_freq_val_tab, l_freq_unit_tab, l_invert_freq_tab, l_last_sched_tab, l_last_cnt_tab,
                                 l_last_val_tab, l_inherit_au_tab, l_nr_of_rows, l_next_rows, l_modify_reason);
            -- If the error is a general failure then the SQLERRM must be logged, otherwise
            -- the error code is the Unilab error
            IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
               IF l_return_value = PA_LIMS.DBERR_GENFAIL THEN
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to remove the link between the parameterprofiles and '||l_object||
                                ' (General failure! Error Code: '||l_return_value||' Error Msg:'||
                                UNRPCAPI.LASTERRORTEXT@LNK_LIMS_H||').');
               ELSE
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                'Unable to remove the link between the parameterprofiles and '||l_object||
                                ' (Error code : '||l_return_value||').');
               END IF;

               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               -- End the remote transaction
               IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               END IF;
               RETURN (FALSE);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               -- Log an error in ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                             'Unable to remove the link between the parameterprofiles and '||l_object||' : '||SQLERRM);
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               -- End the remote transaction
               IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               END IF;
               RETURN (FALSE);
         END;
      END IF;

      IF NOT l_LinkedSpecification THEN
         -- check if the sampletype is obsolete
         FOR l_GetSt_rec IN l_GetSt_Cursor(l_StId, l_st_version) LOOP
            l_StId_changestatus := l_GetSt_rec.st;
            l_StId_status       := l_GetSt_rec.ss;
         END LOOP;
         IF l_StId_changestatus IS NOT NULL THEN
            -- If a new minor version has been created, the original given sampletype has to be checked. If this 
            -- sampletype is the current one, the current flag has to be unchecked.
            IF (l_newminor) THEN
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(UNAPIGEN.SQLCURRENTVERSION@LNK_LIMS_H('st',l_StID), l_old_st_version) = 1 THEN
                  UNAPIGEN.DEACTIVATEOBJECT@LNK_LIMS_H('st', l_StID, l_old_st_version, SYSDATE, '1');
               END IF;
            END IF;
         
            -- Fill in the parameters to change the status of the sampletype
            a_object_tp         := 'st';
            a_st                := l_StId;
            a_st_version        := l_st_version;
            a_old_ss            := l_StId_status;
            a_new_ss            := '@O';
            a_modify_reason     := 'There is no current revision of specification "'||a_part_no||'" | revision='||
                                   a_revision||' in Interspec as from '||
                                   TO_CHAR(a_obsolescence_date,'DDfx/fxMM/RRRR HH24fx:fxMI:SS');
            -- take default lc
            BEGIN
               SELECT uvobjects.def_lc, uvlc.version
                 INTO a_object_lc, a_object_lc_version 
                 FROM UVOBJECTS@LNK_LIMS_H, UVLC@LNK_LIMS_H
                WHERE uvobjects.object = a_object_tp
                  AND uvobjects.def_lc = uvlc.lc
                  AND uvlc.version_is_current = '1';
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               -- Log an error to ITERROR
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                             'No current version found for the default sampletype lifecycle.');
               -- Tracing
               PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               -- End the remote transaction
               IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
               END IF;
               RETURN (FALSE);
            END;

            -- Change the status of the sampletype
            BEGIN
               l_return_value := UNAPIPRP.CHANGEOBJECTSTATUS@LNK_LIMS_H(a_object_tp, a_st, a_st_version, a_old_ss, a_new_ss,
                                                                        a_object_lc, a_object_lc_version, a_modify_reason);
               -- If the error is a general failure then the SQLERRM must be logged, otherwise
               -- the error code is the Unilab error
               IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
                  IF l_return_value = PA_LIMS.DBERR_GENFAIL THEN
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to change the status of '||l_object||' (General failure! Error Code: '||
                                   l_return_value||' Error Msg:'||UNRPCAPI.LASTERRORTEXT@LNK_LIMS_H||').');
                  ELSE
                     -- Log an error to ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                                   'Unable to change the status of '||l_object||' (Error code : '||l_return_value||').');
                  END IF;

                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  -- End the remote transaction
                  IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  END IF;
                  RETURN (FALSE);
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  -- Log an error in ITERROR
                  PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                                'Unable to change the status of '||l_object||' : '||SQLERRM);
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  -- End the remote transaction
                  IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
                     -- Tracing
                     PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  END IF;
                  RETURN (FALSE);
            END;
         END IF;
      END IF;

      -- End the remote transaction
      IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
        -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error to ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to transfer the historic/obsolete specification "'||a_part_no||'" | revision='||a_revision||
                       ' to Unilab: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         -- End the remote transaction
         IF NOT PA_LIMS.f_EndRemoteTransaction_h THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         END IF;
         RETURN(FALSE);
   END f_TransferAHistObs;

   PROCEDURE f_TransferAllHistObs( 
      a_plant            IN VARCHAR2      DEFAULT NULL
   )
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- For all specifications: if it becomes obsolete in Interspec, make it obsolete in Unilab also.
      -- ** Parameters **
      -- a_plant           : plant where the specification has to be transferred to
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname       CONSTANT VARCHAR2(12) := 'LimsSpc';
      l_method          CONSTANT VARCHAR2(32) := 'f_TransferAllHistObs';

      -- General variables
      l_result          BOOLEAN               DEFAULT TRUE;
      l_plant_ok        VARCHAR2(20);
      l_same            BOOLEAN               DEFAULT FALSE;
      l_first           BOOLEAN;
      l_close           BOOLEAN;
      ln_result         INTEGER;

      -- Cursor to get all the plants that have a LIMS db
      CURSOR l_plants_cursor
      IS
         SELECT plant, connect_string, lang_id, lang_id_4id
           FROM itlimsplant;

      -- Cursor to get the information about the plant
      CURSOR l_plant_cursor(c_plant   plant.plant%TYPE)
      IS
         SELECT plant, connect_string, lang_id, lang_id_4id
           FROM itlimsplant
          WHERE plant = c_plant;

      -- Cursor to get all the historic and obsolete specifications
      -- without current new revision that have to be send to Unilab
      CURSOR l_StToTransfer_Cursor(c_plant plant.plant%TYPE)
      IS
         SELECT part_no, MAX(revision) revision 
           FROM (SELECT s.part_no, s.revision
                   FROM specification_header s, status st, part_plant pp
                  WHERE (s.part_no, s.revision) IN 
                           (SELECT a.part_no, 
                                   f_status_rev_submit(a.part_no,
                                                       MAX(DECODE(c.status_type, 'CURRENT', 
                                                                  'e'          , 'HISTORIC',
                                                                  'b')))
                              FROM specification_header a, status c
                             WHERE c.status = a.status
                               AND c.status_type IN ('CURRENT','HISTORIC')
                             GROUP BY a.part_no)
                    AND st.status = s.status
                    AND st.status_type IN ('HISTORIC')
                    AND s.obsolescence_date > SYSDATE - 14
                    AND pp.plant = c_plant
                    AND pp.part_no = s.part_no
                 UNION
                 SELECT s.part_no, s.revision
                   FROM specification_header s, status st, part_plant pp
                  WHERE (s.part_no, s.revision) IN
                           (SELECT a.part_no, 
                                   f_status_rev_submit(a.part_no,
                                                       MAX(DECODE(c.status_type, 'CURRENT', 
                                                                  'e'          , 'OBSOLETE',
                                                                  'a')))
                              FROM specification_header a, status c
                             WHERE c.status = a.status
                               AND c.status_type IN ('CURRENT','OBSOLETE')
                             GROUP BY a.part_no)
                    AND st.status = s.status
                    AND st.status_type IN ('OBSOLETE')
                    AND s.obsolescence_date > SYSDATE - 14
                    AND pp.plant = c_plant
                    AND pp.part_no = s.part_no)
          GROUP BY part_no;

      -- Cursor to get all the historic and obsolete specifications
      -- without current new revision that have to be send to Unilab
      -- handle also all plants that have the same connection string and language id as the given plant
      CURSOR l_SimilarStToTransfer_Cursor(c_plant plant.plant%TYPE)
      IS
         SELECT part_no, MAX(revision) revision 
           FROM (SELECT s.part_no, s.revision
                   FROM specification_header s, status st, part_plant pp, itlimsplant pl
                  WHERE (s.part_no, s.revision) IN 
                           (SELECT a.part_no, 
                                   f_status_rev_submit(a.part_no,
                                                       MAX(DECODE(c.status_type, 'CURRENT', 
                                                                  'e'          , 'HISTORIC',
                                                                  'b')))
                              FROM specification_header a, status c
                             WHERE c.status = a.status
                               AND c.status_type IN ('CURRENT','HISTORIC')
                             GROUP BY a.part_no)
                    AND st.status = s.status
                    AND st.status_type IN ('HISTORIC')
                    AND s.obsolescence_date > SYSDATE - 14
                    AND pp.part_no = s.part_no
                    AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                            (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                               FROM itlimsplant pl2
                              WHERE pl2.plant = c_plant)
                    AND pl.plant = pp.plant
                 UNION
                 SELECT s.part_no, s.revision
                   FROM specification_header s, status st, part_plant pp, itlimsplant pl
                  WHERE (s.part_no, s.revision) IN
                           (SELECT a.part_no, 
                                   f_status_rev_submit(a.part_no,
                                                       MAX(DECODE(c.status_type, 'CURRENT', 
                                                                  'e'          , 'OBSOLETE',
                                                                  'a')))
                              FROM specification_header a, status c
                             WHERE c.status = a.status
                               AND c.status_type IN ('CURRENT','OBSOLETE')
                             GROUP BY a.part_no)
                    AND st.status = s.status
                    AND st.status_type IN ('OBSOLETE')
                    AND s.obsolescence_date > SYSDATE - 14
                    AND pp.part_no = s.part_no
                    AND (pl.connect_string,pl.lang_id,pl.lang_id_4id) IN 
                            (SELECT pl2.connect_string,pl2.lang_id,pl2.lang_id_4id
                               FROM itlimsplant pl2
                              WHERE pl2.plant = c_plant)
                    AND pl.plant = pp.plant)
          GROUP BY part_no;

      -- Cursor to get all the information of the specification
      CURSOR l_getpart_no_cursor (c_part_no  specification_header.part_no%TYPE,
                                  c_revision specification_header.revision%TYPE)
      IS
         SELECT *
           FROM specification_header
          WHERE part_no = c_part_no
            AND revision = c_revision;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_plant, NULL, NULL, PA_LIMS.c_Msg_Started);

      --perform a SetConnection
      -- A SetConnection is required starting from Interspec 6.1,
      -- dynamic sql is used to be able to compile this package on Interspec 5.x database.
      IF SUBSTR(PA_LIMS.f_GetInterspecVersion,1,1) <> '5' THEN
         BEGIN
            EXECUTE IMMEDIATE 'DECLARE l_ret_code INTEGER; BEGIN :l_ret_code := iapiGeneral.SetConnection(:a_user, ''IUINTERFACE''); END;'
            USING IN OUT ln_result, IN USER;
            IF ln_result <> 0 THEN
               PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'SetConnection failed, retrned error'||TO_CHAR(ln_result));
            END IF;
         EXCEPTION
         WHEN OTHERS THEN            
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'SetConnection failed:'||SUBSTR(SQLERRM,1,100));
         END;
      END IF;

      -- Transfer the specifications for all the plants
      IF a_plant IS NULL THEN
         FOR l_plants_rec IN l_plants_cursor LOOP
            -- Check if a plant with the same connection string and language id has already been handled
            -- Loop all handled plants
            FOR i IN 1..PA_LIMSSPC.g_nr_of_plants LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_plants_rec.connect_string, PA_LIMSSPC.g_connect_string_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plants_rec.lang_id, PA_LIMSSPC.g_lang_id_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plants_rec.lang_id_4id, PA_LIMSSPC.g_lang_id_4id_tab(i)) = 1 THEN
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
               l_plant_ok := l_plants_rec.plant;

               l_first := TRUE;
               l_close := FALSE;
               -- Transfer all the specifications for the plant
               <<main_loop>>
               FOR l_SimilarStToTransfer_Rec IN l_SimilarStToTransfer_Cursor(l_plants_rec.plant) LOOP
                  FOR l_getpart_no_Rec IN l_getpart_no_cursor (l_SimilarStToTransfer_Rec.Part_No,
                                                               l_SimilarStToTransfer_Rec.Revision) LOOP
                     IF l_first THEN
                        l_first := FALSE;
                        -- Setup the connection for the plant
                        IF NOT PA_LIMS.f_SetupLimsConnection_h(l_plants_rec.plant) THEN
                           l_result := FALSE;
                           EXIT main_loop;
                        END IF;
                        l_close := TRUE;
                     END IF;

                     IF NOT f_TransferAHistObs(l_getpart_no_Rec.Part_No, l_getpart_no_Rec.Revision, 
                                               l_getpart_no_Rec.obsolescence_date) THEN
                        l_result := FALSE;
                        ROLLBACK;
                     ELSE
                        COMMIT;
                     END IF;
                  END LOOP;
               END LOOP;
               IF l_close THEN
                  -- Close the connection for the plant
                  IF NOT PA_LIMS.f_CloseLimsConnection THEN
                     l_result := FALSE;
                  END IF;
               END IF;
            END IF;
         END LOOP;
      -- Transfer the specifications for a specific plant
      ELSE
         FOR l_plant_rec IN l_plant_cursor(a_plant) LOOP
            -- Check if a plant with the same connection string and language id has already been handled
            -- Loop all handled plants
            FOR i IN 1..PA_LIMSSPC.g_nr_of_plants LOOP
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_plant_rec.connect_string, PA_LIMSSPC.g_connect_string_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plant_rec.lang_id, PA_LIMSSPC.g_lang_id_tab(i)) = 1 AND
                  PA_LIMS_SPECX_TOOLS.COMPARE_NUMBER(l_plant_rec.lang_id_4id, PA_LIMSSPC.g_lang_id_4id_tab(i)) = 1 THEN
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
           l_plant_ok := a_plant;

           l_first := TRUE;
           l_close := FALSE;
           -- Transfer all the specifications for the plant
           <<main_loop>>
           FOR l_SimilarStToTransfer_Rec IN l_SimilarStToTransfer_Cursor(a_plant) LOOP
              FOR l_getpart_no_Rec IN l_getpart_no_cursor (l_SimilarStToTransfer_Rec.Part_No, 
                                                           l_SimilarStToTransfer_Rec.Revision) LOOP
                 IF l_first THEN
                    l_first := FALSE;
                    -- Setup the connection for the plant
                    IF NOT PA_LIMS.f_SetupLimsConnection_h(a_plant) THEN
                       l_result := FALSE;
                       EXIT main_loop;
                    END IF;
                    l_close := TRUE;
                 END IF;

                 IF NOT f_TransferAHistObs(l_getpart_no_Rec.Part_No, l_getpart_no_Rec.Revision, 
                                           l_getpart_no_Rec.obsolescence_date) THEN
                    l_result := FALSE;
                    ROLLBACK;
                 ELSE
                    COMMIT;
                 END IF;
              END LOOP;
           END LOOP;
           IF l_close THEN
              -- Close the connection for the plant
              IF NOT PA_LIMS.f_CloseLimsConnection THEN
                 l_result := FALSE;
              END IF;
           END IF;
         END IF;
      END IF;

      -- Clear the global arrays
      PA_LIMSSPC.g_nr_of_plants := 0;
      
      IF l_result THEN
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
        -- Close the connection for the plant
        IF NOT PA_LIMS.f_CloseLimsConnection THEN
           PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to close the connection.');
        END IF;
        -- Log an error to ITERROR
        PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                      'Unable to transfer the historic/obsolete specifications to Unilab: '||SQLERRM);
        -- Tracing
        PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
        -- Clear the global arrays
        PA_LIMSSPC.g_nr_of_plants := 0;
   END f_TransferAllHistObs;
END PA_LIMSSPC;
/
