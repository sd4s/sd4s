create or replace PACKAGE iapiSpecificationFreeText
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSpecificationFreeText.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain free texts of a
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
   gsSource                      iapiType.Source_Type := 'iapiSpecificationFreeText';
   gtFreeTexts                   iapiType.SpFreeTextTab_Type;
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   gtGetFreeTexts                SpFreeTextTable_Type := SpFreeTextTable_Type( );
   gtInfo                        iapiType.InfoTab_Type;

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddFreeText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anLanguageId               IN       iapiType.LanguageId_Type DEFAULT 1,
      alText                     IN       iapiType.Clob_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExtendFreeText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anLanguageId               IN       iapiType.LanguageId_Type DEFAULT 1,
      alText                     IN       iapiType.Clob_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      anSectionSequenceNumber    OUT      iapiType.SpSectionSequenceNumber_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExtendFreeTextPb(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anLanguageId               IN       iapiType.LanguageId_Type DEFAULT 1,
      alText                     IN       iapiType.Clob_Type DEFAULT NULL,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqSectionSequenceNumber    OUT      iapiType.Ref_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetFreeText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type DEFAULT NULL,
      anSubSectionId             IN       iapiType.Id_Type DEFAULT NULL,
      anItemId                   IN       iapiType.Id_Type DEFAULT NULL,
      anLanguageId               IN       iapiType.LanguageId_Type DEFAULT 1,
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type DEFAULT 1,
      anIncludedOnly             IN       iapitype.boolean_type DEFAULT 1,
      aqFreeText                 OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetFreeTexts(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type DEFAULT NULL,
      anSubSectionId             IN       iapiType.Id_Type DEFAULT NULL,
      aqFreeTexts                OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveFreeText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveFreeText(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anItemId                   IN       iapiType.Id_Type,
      anLanguageId               IN       iapiType.LanguageId_Type,
      alText                     IN       iapiType.Clob_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecificationFreeText;