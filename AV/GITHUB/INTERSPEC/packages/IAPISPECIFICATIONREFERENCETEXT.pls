create or replace PACKAGE iapiSpecificationReferenceText
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSpecificationReferenceText.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain reference texts of a
   --           specification.
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
   gsSource                      iapiType.Source_Type := 'iapiSpecificationReferenceText';
   gtReferenceTexts              iapiType.SpReferenceTextTab_Type;
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   gtGetReferenceTexts           SpReferenceTextTable_Type := SpReferenceTextTable_Type( );
   gtInfo                        iapiType.InfoTab_Type;

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddReferenceText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddReferenceTextViaAnyHook(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type,
      anItemOwner                IN       iapiType.Owner_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExtendReferenceText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type DEFAULT 0,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      anSectionSequenceNumber    OUT      iapiType.SpSectionSequenceNumber_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExtendReferenceTextPb(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type DEFAULT 0,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqSectionSequenceNumber    OUT      iapiType.Ref_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetReferenceText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type DEFAULT NULL,
      anSubSectionId             IN       iapiType.Id_Type DEFAULT NULL,
      anItemId                   IN       iapiType.Id_Type DEFAULT NULL,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL,
      anLanguageId               IN       iapiType.LanguageId_Type DEFAULT 1,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT 1,
      aqReferenceText            OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveReferenceText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anItemRevision             IN       iapiType.Revision_Type DEFAULT NULL,
      anItemOwner                IN       iapiType.Owner_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecificationReferenceText;