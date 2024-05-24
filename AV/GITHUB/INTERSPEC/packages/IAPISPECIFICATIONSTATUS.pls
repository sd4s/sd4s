create or replace PACKAGE iapiSpecificationStatus
IS
---------------------------------------------------------------------------
-- $Workfile: iapiSpecificationStatus.h $
---------------------------------------------------------------------------
--   $Author: evoVaLa3 $
-- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
--  $Modtime: 2014-May-05 12:00 $
--   Project: Interspec DB API
---------------------------------------------------------------------------
--  Abstract:
--           This package contains all general
--           functionality to maintain status changes.
--
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
   gsSource                      iapiType.Source_Type := 'iapiSpecificationStatus';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   gtStatusChange                iapiType.StatusChangeTab_Type;
   gnretval                      iapiType.ErrorNum_Type;
   --AP01274418 Start
   --spec is approved/rejected - had a status change
   --0 - neither rejected nor approved
   --1 - rejected or approved
   gbApprovedPF                  iapiType.Boolean_Type := 0;
   --AP01274418 End
   --IS1179 --oneLine
   gtErrorsAutoStatus          ErrorDataTable_Type := ErrorDataTable_Type( );

---------------------------------------------------------------------------
-- Public procedures and functions
---------------------------------------------------------------------------
---------------------------------------------------------------------------
   FUNCTION AddReasonForIssue(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asText                     IN       iapiType.Buffer_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddReasonForRejection(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asText                     IN       iapiType.Buffer_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION AddReasonForStatusChange(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asText                     IN       iapiType.Buffer_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION Approve(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      asApprove                  IN       iapiType.StringVal_Type,
      --AP00870932 Start
      --asReason                   IN       iapiType.StringVal_Type,--orig
      asReason                   IN       iapiType.Buffer_Type,
      --AP00870932 End
      asUserId                   IN       iapiType.UserId_Type,
      anEsSeqNo                  IN       iapiType.NumVal_Type DEFAULT NULL,
      --AP01155473 Start
      --aqErrors                   OUT      iapiType.Ref_Type ) --orig
      aqErrors                   OUT      iapiType.Ref_Type,
      abCheckPreconditions       IN       iapiType.Boolean_Type DEFAULT 1)
      --AP01155473 End
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   PROCEDURE AutoStatus;

--AP01155473 Start
---------------------------------------------------------------------------
   FUNCTION CheckAllPreconditions(
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
--AP01155473 End
---------------------------------------------------------------------------
   FUNCTION CheckStatusChangeSignature(
      asPartNo                   IN       iapiType.PartNo_Type DEFAULT NULL,
      anRevision                 IN       iapiType.Revision_Type DEFAULT NULL,
      anStatusFrom               IN       iapiType.StatusId_Type DEFAULT NULL,
      anStatusTo                 IN       iapiType.StatusId_Type DEFAULT NULL,
      anMop                      IN       iapiType.Boolean_Type DEFAULT 0,
      anSignatureRequired        OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION GetLastReasonForIssue(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      aqReasonForIssue           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION GetNextAutoStatus(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anNextStatus               IN       iapiType.StatusId_Type,
      anNextAutoStatus           OUT      iapiType.StatusId_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION GetNextStatusList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      aqNextStatusList           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION GetReasonForStatusChange(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asReason                   IN       iapiType.StatusType_Type,
      aqReason                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION GetStatusHistory(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      aqStatusHistory            OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION SaveReasonForIssue(
      anReasonId                 IN       iapiType.Id_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asText                     IN       iapiType.Text_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION SaveReasonForRejection(
      anReasonId                 IN       iapiType.Id_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asText                     IN       iapiType.Text_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION SaveReasonForStatusChange(
      anReasonId                 IN       iapiType.Id_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asText                     IN       iapiType.Text_Type )
      RETURN iapiType.ErrorNum_Type;

   --AP01155473 Start
---------------------------------------------------------------------------
   FUNCTION CheckPreconditions(
      anCurrentStatus            IN       iapiType.StatusId_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anNextStatus               IN       iapiType.StatusId_Type,
      asUserId                   IN       iapiType.UserId_Type,
      anEsSeqNo                  IN       iapiType.NumVal_Type DEFAULT NULL,
      aqErrors                   OUT      iapiType.Ref_Type)
      RETURN iapiType.ErrorNum_Type;
  --AP01155473 End

  --AP01155473 Start
---------------------------------------------------------------------------
   FUNCTION StatusChange(
      anCurrentStatus            IN       iapiType.StatusId_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anNextStatus               IN       iapiType.StatusId_Type,
      asUserId                   IN       iapiType.UserId_Type,
      anEsSeqNo                  IN       iapiType.NumVal_Type DEFAULT NULL,
      --AP01155473 Start
      --aqErrors                   OUT      iapiType.Ref_Type ) --orig
      aqErrors                   OUT      iapiType.Ref_Type,
      abCheckPreconditions       IN       iapiType.Boolean_Type DEFAULT 1)
      --AP01155473 End
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION ValidateStatusChange(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anStatusFrom               IN       iapiType.StatusId_Type,
      anStatusTo                 IN       iapiType.StatusId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION GetSpecificationApprove(
      aqSpecificationApproveList OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION GetApproversList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anStatusWorkFlowList       IN       iapiType.StatusId_Type,
      aqApproversList            OUT      iapiType.Ref_Type )
      RETURN iapitype.errornum_type;

---------------------------------------------------------------------------
   FUNCTION SetApproversList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anStatusWorkFlowList       IN       iapiType.StatusId_Type,
      acApproversListSelected    IN       iapiType.CLOB_Type )
      RETURN iapiType.ErrorNum_Type;

   --AP00870590 Start
---------------------------------------------------------------------------
   FUNCTION SetApproversListPb(
      asPartNoList               IN       iapiType.XmlString_Type,
      asRevisionList             IN       iapiType.XmlString_Type,
      anStatusWorkFlow           IN       iapiType.StatusId_Type,
      acApproversListSelected    IN       iapiType.CLOB_Type,
      aqErrors                   OUT      iapiType.Ref_Type)
      RETURN iapiType.ErrorNum_Type;
   --AP00870590 End

   --AP00870590 Start
---------------------------------------------------------------------------
   FUNCTION SetApproversList(
      axPartNoList               IN       iapiType.XmlType_Type,
      axRevisionList             IN       iapiType.XmlType_Type,
      anStatusWorkFlow           IN       iapiType.StatusId_Type,
      acApproversListSelected    IN       iapiType.CLOB_Type,
      aqErrors                   OUT      iapiType.Ref_Type)
      RETURN iapiType.ErrorNum_Type;
   --AP00870590 End

---------------------------------------------------------------------------
   FUNCTION SetApproversList(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anStatusWorkFlowList       IN       iapiType.StatusId_Type,
      axApproversListSelected    IN       iapiType.XmlType_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION Who_Has_HasNot_Approved(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      aqWhoHasHasNotApprovedList OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION ClearSpecificationToApprove(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anStatusWorkFlowList       IN       iapiType.StatusId_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION ExecuteStatusChangeCustomCode(
      anWorkFlowGroupId          IN       iapiType.WorkFlowGroupId_Type,
      anStatus                   IN       iapiType.StatusId_Type )
      RETURN iapiType.ErrorNum_Type;


   --AP00941883
---------------------------------------------------------------------------
   FUNCTION CheckApproversForBlockedSpec (
      asPartNo                   IN     iapiType.PartNo_Type,
      anRevision                 IN     iapiType.Revision_Type,
      anToApprove                OUT    iapiType.NumVal_Type)
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecificationStatus;