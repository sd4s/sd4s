create or replace PACKAGE iapiSpecification
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSpecification.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.11 (06.07.00.11-00.00) $
   --  $Modtime: 2017-Apr-12 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --
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
   gsSource                      iapiType.Source_Type := 'iapiSpecification';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   gtCopySpec                    iapiType.SpCopySpecTab_Type;
   gtCreateSpec                  iapiType.SpCreateSpecTab_Type;
   giResult                      PLS_INTEGER;
   --AP01004814 --AP01004807
   gbLogIntoITSCHS               BOOLEAN := TRUE;

    --AP00909916 Start
    TYPE SHCache_Rec_Type IS RECORD
    (
        partNo specification_header.part_no%type,
        revision specification_header.revision%type,
        isLocalized NUMERIC(1),
        isInternational specification_header.intl%type,
        statusType status.status_type%type,
        isMultiLanguage NUMERIC(1),
        int_part_no  specification_header.int_part_no%type,
        int_part_rev    specification_header.int_part_rev%type,
        owner specification_header.owner%type,
        locked specification_header.locked%type
    );
    --AP00909916 End

    --AP00909916 Start
    TYPE SHCache_Type IS TABLE OF SHCache_Rec_Type INDEX BY VARCHAR2(23);
    gtSHCache SHCache_Type;
    gnSHCacheEnabled NUMBER(10) := 0;
    --AP00909916 End

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------

   --AP00909916
   ---------------------------------------------------------------------------
   FUNCTION GetSHFromCache(
    anpartNo IN VARCHAR2,
    anRevision IN NUMBER,
    arCacheItem OUT SHCache_Rec_Type
    ) RETURN iapiType.ErrorNum_Type;

   --AP00909916
   ---------------------------------------------------------------------------
    PROCEDURE InsertToSHCache(
        anpartNo IN VARCHAR2,
        anRevision IN NUMBER);

   ---------------------------------------------------------------------------
   FUNCTION ChangeBomPed(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ChangeMetric(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asIntlPart                 IN       iapiType.PartNo_Type,
      asIntl                     IN       iapiType.Intl_Type,
      asUserIntl                 IN       iapiType.Intl_Type,
      anColAccess                IN       iapiType.NumVal_Type,
      anUomType                  IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ChangePed(
      anPedGroupId               IN       iapiType.Id_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anPhaseInTolerance         IN       iapiType.PhaseInTolerance_Type,
      asOutOfSync                OUT      iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ChangeSpecPed(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anPhaseInTolerance         IN       iapiType.PhaseInTolerance_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ChangeValue(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asType                     IN       iapiType.StringVal_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anHeaderId                 IN       iapiType.Id_Type,
      asPlant                    IN       iapiType.Plant_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStage                    IN       iapiType.StageId_Type,
      asNewValueChar             IN       iapiType.StringVal_Type,
      afNewValueNum              IN       iapiType.Float_Type,
      adNewValueDate             IN       iapiType.Date_Type )
      RETURN iapiType.NumVal_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckLock(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      abIsSet                    OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

--AP01280988 Start
---------------------------------------------------------------------------
   FUNCTION CheckPartCodePrefix(
      asPrefix                   IN       iapitype.Prefix_Type,
      asCode                     IN       iapitype.PartNo_Type)
      RETURN iapitype.Boolean_Type;
--AP01280988 End

   ---------------------------------------------------------------------------
   FUNCTION CheckSpecBomPed(
      anPedGroupId               IN       iapiType.Id_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CleanLayout(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anLayoutId                 IN       iapiType.Id_Type,
      anLayoutRev                IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anRefId                    IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ConvertToMultiLanguage(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anLanguageId               IN       iapiType.LanguageId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ConvertToSingleLanguage(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CopySpec(
      asFromPartNo               IN       iapiType.PartNo_Type,
      anFromRevision             IN       iapiType.Revision_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      asFrameId                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type,
      anWorkFlowGroupId          IN       iapiType.Id_Type,
      anAccessGroupId            IN       iapiType.Id_Type,
      anSpecTypeId               IN       iapiType.Id_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anNewRevision              OUT      iapiType.Revision_Type,
      asInternational            IN       iapiType.Intl_Type,
      asInternationalPartNo      IN       iapiType.PartNo_Type,
      anInternationalRevision    IN       iapiType.Revision_Type,
      anInternationalLinked      IN       iapiType.Boolean_Type,
      anMultiLanguage            IN       iapiType.Boolean_Type,
      anUomType                  IN       iapiType.Boolean_Type,
      anMaskId                   IN       iapiType.Id_Type,
      asDescription              IN       iapiType.Description_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CopySpecification(
      asFromPartNo               IN       iapiType.PartNo_Type,
      anFromRevision             IN       iapiType.Revision_Type,
      asPartNo                   IN OUT   iapiType.PartNo_Type,
      asFrameId                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type,
      anWorkFlowGroupId          IN       iapiType.Id_Type,
      anAccessGroupId            IN       iapiType.Id_Type,
      anSpecTypeId               IN       iapiType.Id_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anNewRevision              IN       iapiType.Revision_Type,
      anMultiLanguage            IN       iapiType.Boolean_Type,
      anUomType                  IN       iapiType.Boolean_Type,
      anMaskId                   IN       iapiType.Id_Type,
      asDescription              IN       iapiType.Description_Type,
      anInternationalLinked      IN       iapiType.Boolean_Type DEFAULT 0,
      --AP01387596 --AP01428928 Start
      --aqErrors                   IN OUT   iapiType.Ref_Type ) --orig
      aqErrors                   IN OUT   iapiType.Ref_Type,
      abCleanErrors              IN       iapiType.Boolean_Type DEFAULT 0)
      --AP01387596 --AP01428928 End
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CopySpecificationPb(
      asFromPartNo               IN       iapiType.PartNo_Type,
      anFromRevision             IN       iapiType.Revision_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      asFrameId                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type,
      anWorkFlowGroupId          IN       iapiType.Id_Type,
      anAccessGroupId            IN       iapiType.Id_Type,
      anSpecTypeId               IN       iapiType.Id_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anNewRevision              IN       iapiType.Revision_Type,
      anMultiLanguage            IN       iapiType.Boolean_Type,
      anUomType                  IN       iapiType.Boolean_Type,
      anMaskId                   IN       iapiType.Id_Type,
      asDescription              IN       iapiType.Description_Type,
      anInternationalLinked      IN       iapiType.Boolean_Type DEFAULT 0,
      aqPartNo                   OUT      iapiType.Ref_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateSpecification(
      asPartNo                   IN OUT   iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asDescription              IN       iapiType.Description_Type,
      asCreatedBy                IN       iapiType.UserId_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      asFrameId                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type,
      anSpecTypeId               IN       iapiType.Id_Type,
      anWorkFlowGroupId          IN       iapiType.Id_Type,
      anAccessGroupId            IN       iapiType.Id_Type,
      anMultiLanguage            IN       iapiType.Boolean_Type,
      anUomType                  IN       iapiType.Boolean_Type,
      anMaskId                   IN       iapiType.Id_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
   FUNCTION CreateSpecificationPb(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asDescription              IN       iapiType.Description_Type,
      asCreatedBy                IN       iapiType.UserId_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      asFrameId                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type,
      anSpecTypeId               IN       iapiType.Id_Type,
      anWorkFlowGroupId          IN       iapiType.Id_Type,
      anAccessGroupId            IN       iapiType.Id_Type,
      anMultiLanguage            IN       iapiType.Boolean_Type,
      anUomType                  IN       iapiType.Boolean_Type,
      anMaskId                   IN       iapiType.Id_Type,
      aqPartNo                   OUT      iapiType.Ref_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CurrentPhaseInToCurrent(
      asPartNo                   IN       iapiType.PartNo_Type,
      anStatusType               IN       iapiType.StatusType_Type,
      anPhaseInStatus            IN       iapiType.PhaseInStatus_Type,
      anNextStatus               IN       iapiType.StatusId_Type,
      anElecSignSeq              IN       iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION FillFrameTransferTables(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFrame(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      arFrame                    OUT      iapiType.FrameRec_Type )
      RETURN iapiType.ErrorNum_Type;

   --for version 0605
   ---------------------------------------------------------------------------
   FUNCTION GetFrame2(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asFrameNo                  OUT      iapiType.FrameNo_Type,
-- IS1311 start
--      anFrameRev                 OUT      iapiType.Revision_Type )
      anFrameRev                 OUT      iapiType.FrameRevision_Type )
-- IS1311 end
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetIntlSpecification(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asIntlPartNo               OUT      iapiType.PartNo_Type,
      anIntlRevision             OUT      iapiType.Revision_Type,
      anMaxIntlRevision          OUT      iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLocked(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asUserId                   OUT      iapiType.UserId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetMode(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anMode                     OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNextStatusType(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anWorkFlowGroup            IN       iapiType.Id_Type,
      anStatusType               IN       iapiType.StatusType_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      anPhaseInStatus            IN       iapiType.PhaseInStatus_Type,
      anNextStatus               OUT      iapiType.StatusId_Type,
      anNextStatusType           OUT      iapiType.StatusType_Type,
      anNextPhaseInStatus        OUT      iapiType.PhaseInStatus_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlannedEffectiveGroups(
      atDefaultFilter            IN       iapiType.FilterTab_Type,
      aqPlannedEffectiveGroups   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlannedEffectiveGroups(
      axDefaultFilter            IN       iapiType.XmlType_Type,
      aqPlannedEffectiveGroups   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPrefixAndCode(
      asPartNo                   IN       iapiType.PartNo_Type,
      asPrefix                   IN OUT   iapiType.Prefix_Type,
      anOwnerid                  IN OUT   iapiType.Owner_Type,
      asCode                     IN OUT   iapiType.PartNo_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetStatusType(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asStatusType               OUT      iapiType.StatusType_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION InitialiseForCopy(
      asFromPartNo               IN       iapiType.PartNo_Type,
      anFromRevision             IN       iapiType.Revision_Type,
      anCreateNewRevision        IN       iapiType.Revision_Type,
      asPrefix                   OUT      iapiType.Prefix_Type,
      asCode                     OUT      iapiType.PartNo_Type,
      asDescription              OUT      iapiType.Description_Type,
      adPlannedEffectiveDate     OUT      iapiType.Date_Type,
      anMetric                   OUT      iapiType.Boolean_Type,
      anMultiLanguage            OUT      iapiType.Boolean_Type,
      asFrameNo                  OUT      iapiType.FrameNo_Type,
      anFrameRevision            OUT      iapiType.FrameRevision_Type,
      anOwner                    OUT      iapiType.Owner_Type,
      anFrameMask                OUT      iapiType.Id_Type,
      anWorkflowGroupId          OUT      iapiType.WorkFlowGroupId_Type,
      anAccessGroupId            OUT      iapiType.Id_Type,
      anSpecTypeId               OUT      iapiType.Id_Type,
      asUom                      OUT      iapiType.BaseUom_Type,
      asConversionFactor         OUT      iapiType.NumVal_Type,
      asConversionUom            OUT      iapiType.BaseToUnit_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION InitialiseForCreate(
      asPrefix                   OUT      iapiType.Prefix_Type,
      asCode                     OUT      iapiType.PartNo_Type,
      asDescription              OUT      iapiType.Description_Type,
      adPlannedEffectiveDate     OUT      iapiType.Date_Type,
      anMetric                   OUT      iapiType.Boolean_Type,
      anMultiLanguage            OUT      iapiType.Boolean_Type,
      asFrameNo                  OUT      iapiType.FrameNo_Type,
      anFrameRevision            OUT      iapiType.FrameRevision_Type,
      anOwner                    OUT      iapiType.Owner_Type,
      anFrameMask                OUT      iapiType.Id_Type,
      anWorkflowGroupId          OUT      iapiType.WorkFlowGroupId_Type,
      anAccessGroupId            OUT      iapiType.Id_Type,
      anSpecTypeId               OUT      iapiType.Id_Type,
      asUom                      OUT      iapiType.BaseUom_Type,
      asConversionFactor         OUT      iapiType.NumVal_Type,
      asConversionUom            OUT      iapiType.BaseToUnit_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION InitialiseForLocalise(
      asFromPartNo               IN       iapiType.PartNo_Type,
      anFromRevision             IN       iapiType.Revision_Type,
      asPrefix                   OUT      iapiType.Prefix_Type,
      asCode                     OUT      iapiType.PartNo_Type,
      asDescription              OUT      iapiType.Description_Type,
      adPlannedEffectiveDate     OUT      iapiType.Date_Type,
      anMetric                   OUT      iapiType.Boolean_Type,
      anMultiLanguage            OUT      iapiType.Boolean_Type,
      asFrameNo                  OUT      iapiType.FrameNo_Type,
      anFrameRevision            OUT      iapiType.FrameRevision_Type,
      anOwner                    OUT      iapiType.Owner_Type,
      anFrameMask                OUT      iapiType.Id_Type,
      anWorkflowGroupId          OUT      iapiType.WorkFlowGroupId_Type,
      anAccessGroupId            OUT      iapiType.Id_Type,
      anSpecTypeId               OUT      iapiType.Id_Type,
      asUom                      OUT      iapiType.BaseUom_Type,
      asConversionFactor         OUT      iapiType.NumVal_Type,
      asConversionUom            OUT      iapiType.BaseToUnit_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsLocalized(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anLocalized                OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsMultiLanguage(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anMultiLanguage            OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION LocalizeSpecification(
      asPartNo                   IN OUT   iapiType.PartNo_Type,
      asFrameId                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type,
      anWorkFlowGroupId          IN       iapiType.Id_Type,
      anAccessGroupId            IN       iapiType.Id_Type,
      anSpecTypeId               IN       iapiType.Id_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anNewRevision              IN       iapiType.Revision_Type,
      anMultiLanguage            IN       iapiType.Boolean_Type,
      anUomType                  IN       iapiType.Boolean_Type,
      anMaskId                   IN       iapiType.Id_Type,
      asDescription              IN       iapiType.Description_Type,
      asIntlPartNo               IN       iapiType.PartNo_Type,
      anIntlRevision             IN       iapiType.Revision_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION LocalizeSpecificationPb(
      asPartNo                   IN       iapiType.PartNo_Type,
      asFrameId                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type,
      anWorkFlowGroupId          IN       iapiType.Id_Type,
      anAccessGroupId            IN       iapiType.Id_Type,
      anSpecTypeId               IN       iapiType.Id_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anNewRevision              IN       iapiType.Revision_Type,
      anMultiLanguage            IN       iapiType.Boolean_Type,
      anUomType                  IN       iapiType.Boolean_Type,
      anMaskId                   IN       iapiType.Id_Type,
      asDescription              IN       iapiType.Description_Type,
      asIntlPartNo               IN       iapiType.PartNo_Type,
      anIntlRevision             IN       iapiType.Id_Type,
      aqPartNo                   OUT      iapiType.Ref_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

--AP01259330 Start
   ---------------------------------------------------------------------------
   FUNCTION IsLockingSpecAllowed
      RETURN iapiType.ErrorNum_Type;
--AP01259330 End

   ---------------------------------------------------------------------------
   FUNCTION LockSpec(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION LogChanges(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION PhaseInManual(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anWorkFlowGroup            IN       iapiType.Id_Type,
      anStatus                   IN       iapiType.StatusType_Type,
      anElecSignSeq              IN       iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ReclassSpecType(
      asPartNo                   IN       iapiType.PartNo_Type,
      anSpecType                 IN       iapiType.Id_Type,
      anType                     OUT      iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveSpecification(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveFrame(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asFrameId                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type,
      anMaskId                   IN       iapiType.Id_Type DEFAULT NULL,
      anUpdateMaskId             IN       iapiType.Boolean_Type DEFAULT 0 )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveHeader(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anWorkFlowGroupId          IN       iapiType.WorkFlowGroupId_Type DEFAULT NULL,
      anAccessGroupId            IN       iapiType.Id_Type DEFAULT NULL,
      anMultiLanguage            IN       iapiType.Boolean_Type DEFAULT NULL,
      anSpecTypeId               IN       iapiType.Id_Type DEFAULT NULL,
      anLanguageId               IN       iapiType.LanguageId_Type DEFAULT NULL,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetPedInSync(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SynchroniseAllInternational
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SynchroniseAllLocal
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION TransferFrame(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asOldFrameNo               IN       iapiType.FrameNo_Type,
      anOldFrameRevision         IN       iapiType.FrameRevision_Type,
      anOldFrameOwner            IN       iapiType.Owner_Type,
      asNewFrameNo               IN       iapiType.FrameNo_Type,
      anNewFrameRevision         IN       iapiType.FrameRevision_Type,
      anNewFrameOwner            IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION UnLockSpec(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION UpdateFromFrame(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asOldFrameNo               IN       iapiType.FrameNo_Type,
      anOldFrameRevision         IN       iapiType.FrameRevision_Type,
      anOldFrameOwner            IN       iapiType.Owner_Type,
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION UpdateInternationalPart(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asInternational            IN       iapiType.Intl_Type,
      asInternationalPartNo      IN       iapiType.PartNo_Type,
      anInternationalRevision    IN       iapiType.Revision_Type,
      anInternationalLinked      IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION UpdateLayout(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anType                     IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION UpdateSpecificationHeader(
      anNextStatus               IN       iapiType.StatusId_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anStatusTypeNow            IN       iapiType.StatusType_Type,
      anElecSignSeq              IN       iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateForCopy(
      anCreateNewRevision        IN       iapiType.Boolean_Type,
      asPrefix                   IN       iapiType.Prefix_Type,
      asCode                     IN       iapiType.PartNo_Type,
      asDescription              IN       iapiType.Description_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anMetric                   IN       iapiType.Boolean_Type,
      anMultiLanguage            IN       iapiType.Boolean_Type,
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anFrameMask                IN       iapiType.Id_Type,
      anWorkflowGroupId          IN       iapiType.WorkFlowGroupId_Type,
      anAccessGroupId            IN       iapiType.Id_Type,
      anSpecTypeId               IN       iapiType.Id_Type,
      asUom                      IN       iapiType.BaseUom_Type,
      asConversionFactor         IN       iapiType.NumVal_Type,
      asConversionUom            IN       iapiType.BaseToUnit_Type,
      asPartNo                   OUT      iapiType.PartNo_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateForCreate(
      asPrefix                   IN       iapiType.Prefix_Type,
      asCode                     IN       iapiType.PartNo_Type,
      asDescription              IN       iapiType.Description_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anMetric                   IN       iapiType.Boolean_Type,
      anMultiLanguage            IN       iapiType.Boolean_Type,
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anFrameMask                IN       iapiType.Id_Type,
      anWorkflowGroupId          IN       iapiType.WorkFlowGroupId_Type,
      anAccessGroupId            IN       iapiType.Id_Type,
      anSpecTypeId               IN       iapiType.Id_Type,
      asUom                      IN       iapiType.BaseUom_Type,
      asConversionFactor         IN       iapiType.NumVal_Type,
      asConversionUom            IN       iapiType.BaseToUnit_Type,
      asPartNo                   OUT      iapiType.PartNo_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateForLocalise(
      asInternationalPartNo      IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPrefix                   IN       iapiType.Prefix_Type,
      asCode                     IN       iapiType.PartNo_Type,
      asDescription              IN       iapiType.Description_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anMetric                   IN       iapiType.Boolean_Type,
      anMultiLanguage            IN       iapiType.Boolean_Type,
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anFrameMask                IN       iapiType.Id_Type,
      anWorkflowGroupId          IN       iapiType.WorkFlowGroupId_Type,
      anAccessGroupId            IN       iapiType.Id_Type,
      anSpecTypeId               IN       iapiType.Id_Type,
      asUom                      IN       iapiType.BaseUom_Type,
      asConversionFactor         IN       iapiType.NumVal_Type,
      asConversionUom            IN       iapiType.BaseToUnit_Type,
      asPartNo                   OUT      iapiType.PartNo_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateGroup(
      anPedGroupId               IN       iapiType.Id_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anPhaseInTolerance         IN       iapiType.PhaseInTolerance_Type,
      asPartNo                   IN OUT   iapiType.PartNo_Type,
      anRevision                 IN OUT   iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateInternationalSpec(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asIntlPartNo               IN       iapiType.PartNo_Type,
      anIntlPartRev              IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidatePed(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anPhaseInTolerance         IN       iapiType.PhaseInTolerance_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidatePedGroup(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anPhaseInTolerance         IN       iapiType.PhaseInTolerance_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidatePlantPed(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      anCheckSpecPed             IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateSpecPed(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidationFrame(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asOldFrameNo               IN       iapiType.FrameNo_Type,
      anOldFrameRevision         IN       iapiType.FrameRevision_Type,
      anOldFrameOwner            IN       iapiType.Owner_Type,
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;
   --AP00915832 Start
   ---------------------------------------------------------------------------
   FUNCTION CreateSpecificationDM(
      asPartNo                   IN OUT   iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asDescription              IN       iapiType.Description_Type,
      asCreatedBy                IN       iapiType.UserId_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      asFrameId                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type,
      anSpecTypeId               IN       iapiType.Id_Type,
      anWorkFlowGroupId          IN       iapiType.Id_Type,
      anAccessGroupId            IN       iapiType.Id_Type,
      anMultiLanguage            IN       iapiType.Boolean_Type,
      anUomType                  IN       iapiType.Boolean_Type,
      anMaskId                   IN       iapiType.Id_Type,
      asInternational            IN       iapiType.Intl_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
--AP00915832 End

--COPYCONTENT_SUPPORT
---------------------------------------------------------------------------
  FUNCTION CopyContent(
      asFromPartno               IN       iapitype.partno_type,
      anFromRevision             IN       iapitype.revision_type,
      asPartno                   IN       iapitype.partno_type,
      anRevision                 IN      iapitype.revision_type,
      aqerrors                   IN OUT   iapitype.ref_type )
      RETURN iapitype.errornum_type;

---------------------------------------------------------------------------
-- TFS4878
  FUNCTION Update_display_format_stage(
      asPartno                   IN       iapitype.partno_type,
      anRevision                 IN      iapitype.revision_type)
      RETURN iapitype.errornum_type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecification;