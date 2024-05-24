create or replace PACKAGE iapiAuditTrail
IS
---------------------------------------------------------------------------
-- $Workfile: iapiAuditTrail.h $
---------------------------------------------------------------------------
--   Project:Interspec DB API
---------------------------------------------------------------------------
--  Abstract: This package contains all functionality for journal logging.
--
---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
---------------------------------------------------------------------------
---------------------------------------------------------------------------
   FUNCTION GetPackageVersion
      RETURN iapiType.String_Type;

---------------------------------------------------------------------------
-- $NoKeywords: $
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Member variables
---------------------------------------------------------------------------
   gsSource                      iapiType.Source_Type := 'iapiAuditTrail';

---------------------------------------------------------------------------
-- Public procedures and functions
---------------------------------------------------------------------------
---------------------------------------------------------------------------
   FUNCTION GetBomJournal(
      asPartNo                   IN       iapiType.PartNo_Type DEFAULT NULL,
      anRevision                 IN       iapiType.Revision_Type DEFAULT NULL,
      aqSpecifications           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION GetMessage(
      asMessageId                IN       iapiType.MessageId_Type,
      asParameter1               IN       iapiType.StringVal_Type DEFAULT NULL,
      asParameter2               IN       iapiType.StringVal_Type DEFAULT NULL,
      asParameter3               IN       iapiType.StringVal_Type DEFAULT NULL,
      asParameter4               IN       iapiType.StringVal_Type DEFAULT NULL,
      asParameter5               IN       iapiType.StringVal_Type DEFAULT NULL,
      asMessage                  IN OUT   iapiType.MessageText_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddAccessGroupHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       ACCESS_GROUP%ROWTYPE,
      arNewValue                 IN       ACCESS_GROUP%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddAccessGroupListHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       USER_ACCESS_GROUP%ROWTYPE,
      arNewValue                 IN       USER_ACCESS_GROUP%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddStatusHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       STATUS%ROWTYPE,
      arNewValue                 IN       STATUS%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddUserGroupHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       USER_GROUP%ROWTYPE,
      arNewValue                 IN       USER_GROUP%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddUserGroupListHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       USER_GROUP_LIST%ROWTYPE,
      arNewValue                 IN       USER_GROUP_LIST%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddUserHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       APPLICATION_USER%ROWTYPE,
      arNewValue                 IN       APPLICATION_USER%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddUserHsAddUserPlant(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       ITUP%ROWTYPE,
      arNewValue                 IN       ITUP%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddWorkflowGroupFilterHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       USER_WORKFLOW_GROUP%ROWTYPE,
      arNewValue                 IN       USER_WORKFLOW_GROUP%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddWorkflowGroupHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       WORKFLOW_GROUP%ROWTYPE,
      arNewValue                 IN       WORKFLOW_GROUP%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddWorkflowGroupListHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       WORK_FLOW_LIST%ROWTYPE,
      arNewValue                 IN       WORK_FLOW_LIST%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddWorkflowTypeHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       WORK_FLOW_GROUP%ROWTYPE,
      arNewValue                 IN       WORK_FLOW_GROUP%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddWorkflowTypeListHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       WORK_FLOW%ROWTYPE,
      arNewValue                 IN       WORK_FLOW%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddReportHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       ITREPD%ROWTYPE,
      arNewValue                 IN       ITREPD%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddReportNstDefHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       ITREPNSTDEF%ROWTYPE,
      arNewValue                 IN       ITREPNSTDEF%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

--------------------------------------------------------------------------------------------------------
   FUNCTION AddReportDataHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       ITREPDATA%ROWTYPE,
      arNewValue                 IN       ITREPDATA%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

--------------------------------------------------------------------------------------------------------
   FUNCTION AddReportArgHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       ITREPARG%ROWTYPE,
      arNewValue                 IN       ITREPARG%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

--------------------------------------------------------------------------------------------------------
   FUNCTION AddReportSqlHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       ITREPSQL%ROWTYPE,
      arNewValue                 IN       ITREPSQL%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

--------------------------------------------------------------------------------------------------------
   FUNCTION AddReportAccessHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       ITREPAC%ROWTYPE,
      arNewValue                 IN       ITREPAC%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

--------------------------------------------------------------------------------------------------------
   FUNCTION AddReportLinkHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       ITREPL%ROWTYPE,
      arNewValue                 IN       ITREPL%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

--------------------------------------------------------------------------------------------------------
   FUNCTION AddReportGroupHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       ITREPG%ROWTYPE,
      arNewValue                 IN       ITREPG%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

--------------------------------------------------------------------------------------------------------
   FUNCTION AddReportGroupLinkHistory(
      asAction                   IN       iapiType.StringVal_Type,
      arOldValue                 IN       ITREPL%ROWTYPE,
      arNewValue                 IN       ITREPL%ROWTYPE )
      RETURN iapiType.ErrorNum_Type;

   FUNCTION SetUserInfoHistory
      RETURN iapiType.ErrorNum_Type;
END iapiAuditTrail;