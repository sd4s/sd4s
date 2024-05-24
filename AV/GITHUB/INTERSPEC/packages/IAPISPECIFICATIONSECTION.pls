create or replace PACKAGE iapiSpecificationSection
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSpecificationSection.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all general
   --           functionality to maintain a specification
   --           section.
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
   gsSource                      iapiType.Source_Type := 'iapiSpecificationSection';
   gtSections                    iapiType.SpSectionTab_Type;
   gtSectionItems                iapiType.SpSectionItemTab_Type;
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   gtGetSections                 SpSectionDataTable_Type := SpSectionDataTable_Type( );
   gtGetSectionItems             SpSectionItemTable_Type := SpSectionItemTable_Type( );
   gtInfo                        iapiType.InfoTab_Type;

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddAnyHook(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type,
      anItemOwner                IN       iapiType.Owner_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddSectionItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddSectionItemViaAnyHook(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type,
      anItemOwner                IN       iapiType.Owner_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckAccessToSave(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckExtendableSection(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anAttribute                IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckLock(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      abIsSet                    OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckSectionLogging(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type,
      anItemId                   IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateSectionHistory(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateSectionLogging(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION EditExtendableSection(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anDisplayFormat            IN       iapiType.Id_Type,
      anAttribute                IN       iapiType.Id_Type,
      anUomId                    IN       iapiType.Id_Type,
      anAss1                     IN       iapiType.Id_Type,
      anAss2                     IN       iapiType.Id_Type,
      anAss3                     IN       iapiType.Id_Type,
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION EditSection(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anFrameRevision            IN       iapiType.FrameRevision_Type,
      anFrameOwner               IN       iapiType.Owner_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      asAction                   IN       iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION EditSectionLayout(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type DEFAULT NULL,
      anSubSectionId             IN       iapiType.Id_Type DEFAULT NULL,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type DEFAULT NULL,
      anLayout                   IN       iapiType.Id_Type,
      aqInfo                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION EditSectionProperty(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroup            IN       iapiType.Id_Type,
      anProperty                 IN       iapiType.Id_Type,
      anAttribute                IN       iapiType.Id_Type,
      anUomId                    IN       iapiType.Id_Type,
      anAss1                     IN       iapiType.Id_Type,
      anAss2                     IN       iapiType.Id_Type,
      anAss3                     IN       iapiType.Id_Type,
      asAction                   IN       iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistItemInSection(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExtendSection(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type,
      anDisplayFormatId          IN       iapiType.Id_Type DEFAULT 0,
      anDisplayFormatRevision    IN       iapiType.Revision_Type DEFAULT NULL,
      anAttributeId              IN       iapiType.Id_Type DEFAULT 0,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      anSectionSequenceNumber    OUT      iapiType.SpSectionSequenceNumber_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLocked(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      asUserId                   OUT      iapiType.UserId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLocked(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asUserId                   OUT      iapiType.UserId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetSectionItems(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type DEFAULT NULL,
      anSubSectionId             IN       iapiType.Id_Type DEFAULT NULL,
      anIncludedOnly             IN       iapiType.Boolean_Type DEFAULT 1,
      aqSectionItems             OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetSections(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anIncludedOnly             IN       iapiType.Boolean_Type DEFAULT 1,
      aqSections                 OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsActionAllowed(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL,
      asAction                   IN       iapiType.String_Type,
      anAllowed                  OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsExtendable(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anExtendable               OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsItemExtendable(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anExtendable               OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsItemExtended(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anExtended                 OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsItemExtended(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type )
      RETURN iapiType.Boolean_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsItemLocallyModifiable(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL,
      anLocallyModifiable        OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsMarkedForEditing(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type,
      anMarkedForEditing         OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION LockSpec(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION LogHistory(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION MarkForEditing(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveSectionItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION UnlockSpec(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION UpdateSectionLogging(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type )
      RETURN iapiType.ErrorNum_Type;
   ---------------------------------------------------------------------------
   FUNCTION F_IS_EXTENDABLE(
		  asPartNo     in iapitype.FrameNo_Type,
			anRevision   in iapitype.FrameRevision_Type,
			anSection    in Frame_Section.Section_Id%TYPE,
			anSubSection in Frame_Section.Sub_Section_Id%TYPE,
			anRef_ID     in Frame_Section.Ref_Id%TYPE)
  return number;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecificationSection;