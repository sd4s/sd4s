create or replace PACKAGE
----------------------------------------------------------------------------
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
PA_LIMS IS

   -- constants for the return values of LIMS
   DBERR_SUCCESS       CONSTANT INTEGER      := 0;
   DBERR_GENFAIL       CONSTANT INTEGER      := 1;
   DBERR_NOTMODIFIABLE CONSTANT INTEGER      := 5;
   DBERR_NORECORDS     CONSTANT INTEGER      := 11;
   -- constants for the DB logging
   c_Source            CONSTANT VARCHAR2(20) := 'INTERSPEC <-> LIMS';
   c_Applic            CONSTANT VARCHAR2(20) := 'PA_LIMS';
   -- constants that can be used for Trace
   c_Msg_STARTED       CONSTANT VARCHAR2(40) := 'Method Started ...';
   c_Msg_ENDED         CONSTANT VARCHAR2(40) := 'Method Ended ...';
   c_Msg_ABORTED       CONSTANT VARCHAR2(40) := 'Method Aborted ...';
   -- constant contains the name of the Unilab attribute which contains the original Interspec name
   -- of the parameterprofile, parameter or method
   c_au_orig_name      CONSTANT VARCHAR2(20)  := 'interspec_orig_name';

   -- global variables containing the names of the Unilab sampletype groupkeys
   g_pp_key_name      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
   -- global variables for the parameterprofile pp_keys
   g_pp_key_cache_id   VARCHAR2(60);
   g_pp_key            UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
   g_linked_keys       VARCHAR2(10);
   --global variable containing the actual connect string of LNK_LIMS
   g_LNK_LIMS_connect_string   VARCHAR2(40);
   --global variable containing 1 or 0 initialised upon f_SetUpLimsConnection or f_SetUpLimsConnection_h
   --1 when historic properties must be transferred, 0 when not
   g_tr_historic_prop              CHAR(1) DEFAULT '0';
   g_effective_from_date4historic  DATE;
   --global variable containing 1 or 0 initialised upon f_SetUpLimsConnection or f_SetUpLimsConnection_h
   --1 when template details must be used or not, 0 when not
   g_use_template_details          CHAR(1) DEFAULT '1';
   --Event Buffer used by f_SendTransferFinishedEvents to send all events to Unilab at the end of a transfer
   g_evbuff_nr_of_rows             INTEGER DEFAULT 0;
   g_evbufftab_object_tp           UNAPIGEN.VC4_TABLE_TYPE@LNK_LIMS;
   g_evbufftab_object_id           UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS;
   g_evbufftab_ev_details          UNAPIGEN.VC255_TABLE_TYPE@LNK_LIMS;
   --Global variables and constants used for the prioritizing of the spec transferts
      --Number of iterations between 2 complete reopen of the cursor to see if priorities have been changed while a transfert is busy
      c_NrIterationsForReevaluation   INTEGER DEFAULT 10;
      --global variable set to restart the complete transfert in a very specific case
      g_RestartACompleteTransfer      BOOLEAN DEFAULT FALSE;
      --lowest priority possble when updating the priorities by increasing the priority of another throgh the GUI
      c_LowestSpecPriority            NUMBER DEFAULT 1000000;
      --job string searched in sys.dba_jobs.what to trigger the job execution when clicking the transfer spec button
      c_JobStringToSearch             VARCHAR2(255) DEFAULT 'pa_limsinterface.p_transfercfgandspc;';


   PROCEDURE p_Trace(
      a_classname   IN   VARCHAR2,
      a_method      IN   VARCHAR2,
      a_id1         IN   VARCHAR2,
      a_id2         IN   VARCHAR2,
      a_id3         IN   VARCHAR2,
      a_msg         IN   VARCHAR2
   );

   PROCEDURE p_TraceSt(
      a_StId        IN   VARCHAR2,
      a_version     IN   VARCHAR2
   );

   PROCEDURE p_Log(
      a_Object   IN   VARCHAR2,
      a_Method   IN   VARCHAR2,
      a_Msg      IN   VARCHAR2
   );

   FUNCTION f_SetUpLimsConnection(
      a_plant    IN   plant.plant%TYPE
   )
      RETURN BOOLEAN;

   FUNCTION f_SetUpLimsConnection_h(
      a_plant    IN   plant.plant%TYPE
   )
      RETURN BOOLEAN;

   FUNCTION f_CloseLimsConnection
      RETURN BOOLEAN;

   FUNCTION f_ActivePlant
      RETURN VARCHAR2;
   --comented out in 6.4 - Oracle Bug : 2436624 PLS-801 [2102] compiling a cursor which uses a function with PRAGMA RESTRICT_REFERENCES(...,TRUST)
   --Obsolete since Oracle 10 - check of pragma is performed at runtime (no more at compilation time)
   --It might be necessary to uncomment the following line if you are using a very old platform (this statement may be deleted in 2 releases 6.4 + 2 releases)
   --PRAGMA RESTRICT_REFERENCES(f_ActivePlant, WNDS, WNPS);

   FUNCTION f_StartRemoteTransaction
      RETURN BOOLEAN;

   FUNCTION f_StartRemoteTransaction_h
      RETURN BOOLEAN;

   FUNCTION f_Wait4EndOfEventProcessing
      RETURN BOOLEAN;

   FUNCTION f_EndRemoteTransaction
      RETURN BOOLEAN;

   FUNCTION f_EndRemoteTransaction_h
      RETURN BOOLEAN;

   FUNCTION f_SendTransferFinishedEvents
      RETURN BOOLEAN;

   FUNCTION f_GetTemplate(
      a_Object   IN itlimstmp.en_tp%TYPE,
      a_Id       IN itlimstmp.en_id%TYPE DEFAULT NULL
   )
      RETURN VARCHAR2;

   FUNCTION f_GetDateFormat
      RETURN VARCHAR2;

   FUNCTION f_GetDateFormat_h
      RETURN VARCHAR2;

   FUNCTION f_GetSettingValue(
      a_setting  IN interspc_cfg.parameter%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION f_GetPathValue(
      a_db          IN itlimsppkey.db%TYPE,
      a_pp_key_seq  IN itlimsppkey.pp_key_seq%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION f_GetMtId(
      a_test_method   IN     VARCHAR2,
      a_revision      IN     NUMBER,
      a_tm_desc       IN     VARCHAR2,
      a_mt_desc          OUT VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION f_GetPrId(
      a_property      IN     VARCHAR2,
      a_revision      IN     NUMBER,
      a_attribute     IN     VARCHAR2,
      a_sp_desc       IN     VARCHAR2,
      a_pr_desc          OUT VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION f_GetPpId(
      a_part_no          IN     specification_header.part_no%TYPE,
      a_property_group   IN     VARCHAR2,
      a_revision         IN     NUMBER,
      a_pg_desc          IN     VARCHAR2,
      a_pp_desc             OUT VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION f_GetStAuId(
      a_Ly          IN itlimsconfly.layout_id%TYPE,
      a_lyRev       IN itlimsconfly.layout_rev%TYPE,
      a_Column      IN itlimsconfly.is_col%TYPE,
      a_Property    IN property.property%TYPE,
      a_Attribute   IN specification_prop.attribute%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION f_GetStPpPrAuId(
      a_Ly       IN itlimsconfly.layout_id%TYPE,
      a_lyRev    IN itlimsconfly.layout_rev%TYPE,
      a_Column   IN itlimsconfly.is_col%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION f_GetStGkId(
      a_Ly       IN itlimsconfly.layout_id%TYPE,
      a_lyRev    IN itlimsconfly.layout_rev%TYPE,
      a_Column   IN itlimsconfly.is_col%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION f_GetHighestRevision(
      a_obj_tp   IN VARCHAR2,
      a_obj_id   IN VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION f_GetGkId(
      a_GkId     IN VARCHAR2
   )
      RETURN VARCHAR2;
   --comented out in 6.4 - Oracle Bug : 2436624 PLS-801 [2102] compiling a cursor which uses a function with PRAGMA RESTRICT_REFERENCES(...,TRUST)
   --Obsolete since Oracle 10 - check of pragma is performed at runtime (no more at compilation time)
   --It might be necessary to uncomment the following line if you are using a very old platform (this statement may be deleted in 2 releases 6.4 + 2 releases)
   --PRAGMA RESTRICT_REFERENCES(f_GetGkId, WNDS, WNPS);

   FUNCTION f_RemoveDbLink
      RETURN BOOLEAN;

   FUNCTION f_RemoveDbLink_h
      RETURN BOOLEAN;

   FUNCTION f_ReleaseLock
      RETURN BOOLEAN;

   FUNCTION f_RequestLock
      RETURN BOOLEAN;

   FUNCTION f_SetPpKeys(
      a_part_no      IN VARCHAR2,
      a_revision     IN VARCHAR2,
      a_st           IN VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_GetInterspecVersion
      RETURN VARCHAR2;

   FUNCTION f_GetAttachedPartNo(
      a_part_no      IN VARCHAR2,
      a_revision     IN VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION f_GetIUIVersion
      RETURN VARCHAR2;

END PA_LIMS;