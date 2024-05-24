create or replace PACKAGE iapiFrame
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiFrame.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to handle frames.
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
   gsSource                      iapiType.Source_Type := 'iapiFrame';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION CopyFrame(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      asFrameNoFrom              IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      asDescription              IN       iapiType.Description_Type,
      asCreatedBy                IN       iapiType.UserId_Type,
      anClass3Id                 IN       iapiType.Id_Type,
      anWorkFlowGroupId          IN       iapiType.Id_Type,
      anAccessGroup              IN       iapiType.Id_Type,
      asIntlFrom                 IN       iapiType.Intl_Type,
      asIntl                     IN       iapiType.Intl_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CopyMasks(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      asOldFrameNo               IN       iapiType.FrameNo_Type,
      anOldRevision              IN       iapiType.FrameRevision_Type,
      anOldOwner                 IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CopyValidation(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      asOldFrameNo               IN       iapiType.FrameNo_Type,
      anOldRevision              IN       iapiType.FrameRevision_Type,
      anOldOwner                 IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION CreateFilter(
      anFilterId                 IN OUT   iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      axColumn                   IN       iapiType.XmlType_Type,
      axOperator                 IN       iapiType.XmlType_Type,
      axValChar                  IN       iapiType.XmlType_Type,
      axValDate                  IN       iapiType.XmlType_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asComment                  IN       iapiType.FilterDescription_Type,
      abOverwrite                IN       iapiType.Boolean_Type,
      anOptions                  IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION CreateFilter(
      anFilterId                 IN OUT   iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      asColumn                   IN       iapiType.String_Type,
      asOperator                 IN       iapiType.String_Type,
      asValChar                  IN       iapiType.String_Type,
      asValDate                  IN       iapiType.String_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asComment                  IN       iapiType.FilterDescription_Type,
      abOverwrite                IN       iapiType.Boolean_Type,
      anOptions                  IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION CreateFilter(
      anFilterId                 IN OUT   iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      atColumn                   IN       iapiType.CharTab_Type,
      atOperator                 IN       iapiType.CharTab_Type,
      atValChar                  IN       iapiType.CharTab_Type,
      atValDate                  IN       iapiType.DateTab_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asComment                  IN       iapiType.FilterDescription_Type,
      abOverwrite                IN       iapiType.Boolean_Type,
      anOptions                  IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateFrameHeader(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      asDescription              IN       iapiType.Description_Type,
      asCreatedBy                IN       iapiType.UserId_Type,
      anClass3Id                 IN       iapiType.Id_Type,
      anWorkFlowGroupId          IN       iapiType.Id_Type,
      anAccessGroup              IN       iapiType.Id_Type,
      asIntl                     IN       iapiType.Intl_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateMaskPropertyGroup(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.FramePropertyGroup_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anViewId                   IN       iapiType.Id_Type,
      asAction                   IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateMaskSection(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anReferenceId              IN       iapiType.Id_Type,
      anSequenceNr               IN       iapiType.Sequence_Type,
      anViewId                   IN       iapiType.Id_Type,
      asAction                   IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type DEFAULT 1 )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistMaskId(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anViewId                   IN       iapiType.Id_Type,
      anOwner                    IN       iapiType.Owner_Type DEFAULT 1 )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistMaskInFrame(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type DEFAULT 1 )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetExtendableFrame(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      aqSections                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetSectionSubSection(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      asViewBoM                  IN       iapiType.PropertyBoolean_Type,
      aqResult                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetSectionSubSectionItems(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      asViewBoM                  IN       iapiType.PropertyBoolean_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      aqResult                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveFrame(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anCheck                    IN       iapiType.Numval_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION StatusChange(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anCurrentStatus            IN       iapiType.StatusId_Type,
      anNextStatus               IN       iapiType.StatusId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SynchroniseFrame(
      asSourceFrameNo            IN       iapiType.FrameNo_Type,
      anSourceRevision           IN       iapiType.FrameRevision_Type,
      asTargetFrameNo            IN       iapiType.FrameNo_Type,
      anTargetRevision           IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SynchroniseMasks(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SynchroniseValidation(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION UpdateFrameFromSection(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
   FUNCTION AssociateIcon(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type DEFAULT 1,
      asIcon                     IN       iapitype.Icon_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
   FUNCTION RemoveIcon(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type DEFAULT 1 )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiFrame;