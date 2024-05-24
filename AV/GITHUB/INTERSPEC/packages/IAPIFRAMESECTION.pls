create or replace PACKAGE iapiFrameSection
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiFrameSection.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to handle frame section data.
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
   gsSource                      iapiType.Source_Type := 'iapiFrameSection';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistItemInSection(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL,
      anMaskId                   IN       iapiType.Id_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetSectionItems(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      aqSectionItems             OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetSections(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      aqSections                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsExtendable(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type )
      RETURN iapiType.Boolean_Type;

   ---------------------------------------------------------------------------
   FUNCTION IsItemLocallyModifiable(
      asFrameNo                  IN       iapiType.FrameNo_Type,
      anRevision                 IN       iapiType.FrameRevision_Type,
      anOwner                    IN       iapiType.Owner_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL,
      anLocallyModifiable        OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiFrameSection;