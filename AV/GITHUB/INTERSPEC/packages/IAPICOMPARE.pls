create or replace PACKAGE iapiCompare
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiCompare.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality for comparison of specifications.
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
   gsSource                      iapiType.Source_Type := 'iapiCompare';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION ChemicalIngredient(
      asPartNo1                  IN       iapiType.PartNo_Type,
      anRevision1                IN       iapiType.Revision_Type,
      asPlant1                   IN       iapiType.Plant_Type,
      asChemicalIngredient1      IN       iapiType.StringVal_Type,
      anAlternative1             IN       iapiType.BomAlternative_Type DEFAULT 1,
      anUsage1                   IN       iapiType.BomUsage_Type DEFAULT 1,
      adExplosionDate1           IN       iapiType.Date_Type DEFAULT SYSDATE,
      anIncludeInDevelopment1    IN       iapiType.Boolean_Type DEFAULT 0,
      anUseBomPath1              IN       iapiType.Boolean_Type DEFAULT 0,
      asPartNo2                  IN       iapiType.PartNo_Type,
      anRevision2                IN       iapiType.Revision_Type,
      asPlant2                   IN       iapiType.Plant_Type,
      asChemicalIngredient2      IN       iapiType.StringVal_Type,
      anAlternative2             IN       iapiType.BomAlternative_Type DEFAULT 1,
      anUsage2                   IN       iapiType.BomUsage_Type DEFAULT 1,
      adExplosionDate2           IN       iapiType.Date_Type DEFAULT SYSDATE,
      anIncludeInDevelopment2    IN       iapiType.Boolean_Type DEFAULT 0,
      anUseBomPath2              IN       iapiType.Boolean_Type DEFAULT 0,
      aqChemicalIngredients      OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ChemicalIngredient(
      anUniqueId1                IN       iapiType.Sequence_Type,
      asPartNo1                  IN       iapiType.PartNo_Type,
      anRevision1                IN       iapiType.Revision_Type,
      asPlant1                   IN       iapiType.Plant_Type,
      asChemicalIngredient1      IN       iapiType.StringVal_Type,
      anAlternative1             IN       iapiType.BomAlternative_Type DEFAULT 1,
      anUsage1                   IN       iapiType.BomUsage_Type DEFAULT 1,
      adExplosionDate1           IN       iapiType.Date_Type DEFAULT SYSDATE,
      anIncludeInDevelopment1    IN       iapiType.Boolean_Type DEFAULT 0,
      anUseBomPath1              IN       iapiType.Boolean_Type DEFAULT 0,
      anUniqueId2                IN       iapiType.Sequence_Type,
      asPartNo2                  IN       iapiType.PartNo_Type,
      anRevision2                IN       iapiType.Revision_Type,
      asPlant2                   IN       iapiType.Plant_Type,
      asChemicalIngredient2      IN       iapiType.StringVal_Type,
      anAlternative2             IN       iapiType.BomAlternative_Type DEFAULT 1,
      anUsage2                   IN       iapiType.BomUsage_Type DEFAULT 1,
      adExplosionDate2           IN       iapiType.Date_Type DEFAULT SYSDATE,
      anIncludeInDevelopment2    IN       iapiType.Boolean_Type DEFAULT 0,
      anUseBomPath2              IN       iapiType.Boolean_Type DEFAULT 0,
      aqChemicalIngredients      OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetBomHeaders(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative              IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage                    IN       iapiType.BomUsage_Type DEFAULT NULL,
      asPartNo2                  IN       iapiType.PartNo_Type,
      anRevision2                IN       iapiType.Revision_Type,
      asPlant2                   IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative2             IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage2                   IN       iapiType.BomUsage_Type DEFAULT NULL,
      aqBoms                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetBomItems(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative              IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage                    IN       iapiType.BomUsage_Type DEFAULT NULL,
      asPartNo2                  IN       iapiType.PartNo_Type,
      anRevision2                IN       iapiType.Revision_Type,
      asPlant2                   IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative2             IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage2                   IN       iapiType.BomUsage_Type DEFAULT NULL,
      aqBoms                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetChemicalIngredient(
      anUniqueId1                IN       iapiType.Sequence_Type,
      asPartNo1                  IN       iapiType.PartNo_Type,
      anRevision1                IN       iapiType.Revision_Type,
      asPlant1                   IN       iapiType.Plant_Type DEFAULT NULL,
      asChemicalIngredient1      IN       iapiType.StringVal_Type,
      anAlternative1             IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage1                   IN       iapiType.BomUsage_Type DEFAULT NULL,
      anUniqueId2                IN       iapiType.Sequence_Type,
      asPartNo2                  IN       iapiType.PartNo_Type,
      anRevision2                IN       iapiType.Revision_Type,
      asPlant2                   IN       iapiType.Plant_Type DEFAULT NULL,
      asChemicalIngredient2      IN       iapiType.StringVal_Type,
      anAlternative2             IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage2                   IN       iapiType.BomUsage_Type DEFAULT NULL,
      aqChemicalIngredients      OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetCIPerc(
      anIngredient               IN       iapiType.Id_Type,
      anUniqueId                 IN       iapiType.Id_Type )
      RETURN iapiType.NumVal_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetCISum(
      anIngredient               IN       iapiType.Id_Type,
      anUniqueId                 IN       iapiType.Id_Type )
      RETURN iapiType.NumVal_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetCITotal(
      anUniqueId                 IN       iapiType.Id_Type )
      RETURN iapiType.NumVal_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetClassificationDetail(
      asPartNo1                  IN       iapiType.PartNo_Type,
      asPartNo2                  IN       iapiType.PartNo_Type,
      aqClassification           OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetCompareBHStatus(
      AnFrom                     IN       iapiType.Id_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      asPartNo2                  IN       iapiType.PartNo_Type,
      anRevision2                IN       iapiType.Revision_Type,
      asPlant2                   IN       iapiType.Plant_Type,
      anAlternative2             IN       iapiType.BomAlternative_Type,
      anUsage2                   IN       iapiType.BomUsage_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetCompareBIStatus(
      anFrom                     IN       iapiType.Id_Type,
      asPartNoCompare            IN       iapiType.PartNo_Type,
      anRevisionCompare          IN       iapiType.Revision_Type,
      asPlantCompare             IN       iapiType.Plant_Type,
      anAlternativeCompare       IN       iapiType.BomAlternative_Type,
      anUsageCompare             IN       iapiType.BomUsage_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      asComponentPart            IN       iapiType.PartNo_Type,
      anComponentRevision        IN       iapiType.Revision_Type,
      asComponentPlant           IN       iapiType.Plant_Type,
      anQuantity                 IN       iapiType.BomQuantity_Type,
      asUom                      IN       iapiType.Description_Type,
      anConversionFactor         IN       iapiType.Bomconvfactor_Type,
      asConvertedUom             IN       iapiType.Description_Type,
      anYield                    IN       iapiType.BomYield_Type,
      anAssemblyScrap            IN       iapiType.Scrap_Type,
      anComponentScrap           IN       iapiType.Scrap_Type,
      anLeadTimeOffset           IN       iapiType.Bomleadtimeoffset_Type,
      asItemCategory             IN       iapiType.Bomitemcategory_Type,
      asIssueLocation            IN       iapiType.Bomissuelocation_Type,
      asCalculationMode          IN       iapiType.BomItemCalcFlag_Type,
      asBomItemType              IN       iapiType.BomitemType_Type,
      anOperationalStep          IN       iapiType.Bomoperationalstep_Type,
      anMinimumQuantity          IN       iapiType.Bomquantity_Type,
      anMaximumQuantity          IN       iapiType.Bomquantity_Type,
      asCode                     IN       iapiType.Bomitemcode_Type,
      asAlternativeGroup         IN       iapiType.Bomitemaltgroup_Type,
      anAlternativePriority      IN       iapiType.Bomitemaltpriority_Type,
      anNumeric1                 IN       iapiType.BomItemNumeric_Type,
      anNumeric2                 IN       iapiType.BomItemNumeric_Type,
      anNumeric3                 IN       iapiType.BomItemNumeric_Type,
      anNumeric4                 IN       iapiType.BomItemNumeric_Type,
      anNumeric5                 IN       iapiType.BomItemNumeric_Type,
      asText1                    IN       iapiType.BomItemLongCharacter_Type,
      asText2                    IN       iapiType.BomItemLongCharacter_Type,
      asText3                    IN       iapiType.BomItemLongCharacter_Type,
      asText4                    IN       iapiType.BomItemLongCharacter_Type,
      asText5                    IN       iapiType.BomItemLongCharacter_Type,
      adDate1                    IN       iapiType.Date_Type,
      adDate2                    IN       iapiType.Date_Type,
      asCharacteristic1          IN       iapiType.Description_Type,
      asCharacteristic2          IN       iapiType.Description_Type,
      asCharacteristic3          IN       iapiType.Description_Type,
      anRelevancyToCosting       IN       iapiType.Boolean_Type,
      anBulkMaterial             IN       iapiType.Boolean_Type,
      anFixedQuantity            IN       iapiType.Boolean_Type,
      anBoolean1                 IN       iapiType.Boolean_Type,
      anBoolean2                 IN       iapiType.Boolean_Type,
      anBoolean3                 IN       iapiType.Boolean_Type,
      anBoolean4                 IN       iapiType.Boolean_Type,
      asInternationalEquivalent  IN       iapiType.PartNo_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetCompareCIListStatus(
      anFrom                     IN       iapiType.Id_Type,
      anIngredient               IN       iapiType.Id_Type,
      anUniqueId1                IN       iapiType.Id_Type,
      asChemicalIngredient1      IN       iapiType.StringVal_Type,
      anUniqueId2                IN       iapiType.Id_Type,
      asChemicalIngredient2      IN       iapiType.StringVal_Type )
      RETURN iapiType.Id_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetCompareLabelDetails(
      anLogId1                   IN       iapiType.Id_Type,
      anLogId2                   IN       iapiType.Id_Type,
      aqLabelCommonDetails       OUT      iapiType.Ref_Type,
      aqLabelUniqueDetails       OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetCompareLocalisedBHStatus(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      asIntlPlant                IN       iapiType.Plant_Type,
      anIntlAlternative          IN       iapiType.BomAlternative_Type,
      anIntlUsage                IN       iapiType.BomUsage_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetCompareLocalisedBIStatus(
      AnFrom                     IN       iapiType.Id_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      asComponentPart            IN       iapiType.PartNo_Type,
      anComponentRevision        IN       iapiType.Revision_Type,
      asComponentPlant           IN       iapiType.Plant_Type,
      anItemNumber               IN       iapiType.BomItemNumber_Type,
      anQuantity                 IN       iapiType.BomQuantity_Type,
      asUom                      IN       iapiType.Description_Type,
      anYield                    IN       iapiType.BomYield_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLocalisedBomHeaders(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asIntlPlant                IN       iapiType.Plant_Type,
      anIntlAlternative          IN       iapiType.BomAlternative_Type,
      anIntlBomUsage             IN       iapiType.BomUsage_Type,
      aqBoms                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLocalisedBomItems(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      asIntlPlant                IN       iapiType.Plant_Type,
      anIntlAlternative          IN       iapiType.BomAlternative_Type,
      anIntlBomUsage             IN       iapiType.BomUsage_Type,
      aqBoms                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetObjectDetail(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anObjectId                 IN       iapiType.Id_Type,
      anObjectRevision           IN       iapiType.Revision_Type,
      anObjectOwner              IN       iapiType.Owner_Type,
      aqObject                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
   FUNCTION GetObjectDetailWeb(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anObjectId                 IN       iapiType.Id_Type,
      anObjectRevision           IN       iapiType.Revision_Type,
      anObjectOwner              IN       iapiType.Owner_Type,
      aqObject                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

    ---------------------------------------------------------------------------
   FUNCTION GetProcessDataDetail(
      asPartNo1                  IN       iapiType.PartNo_Type,
      anRevision1                IN       iapiType.Revision_Type,
      asPartNo2                  IN       iapiType.PartNo_Type,
      anRevision2                IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      asPlant                    IN       iapiType.Plant_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStage                    IN       iapiType.StageId_Type,
      aqProcessData              OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetProcessTextDetail(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anTextType                 IN       iapiType.TextType_Type,
      asPlant                    IN       iapiType.Plant_Type,
      asLine                     IN       iapiType.Line_Type,
      anConfiguration            IN       iapiType.Configuration_Type,
      anStage                    IN       iapiType.StageId_Type,
      aqProcessText              OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPropertyGroupDetail(
      asPartNo1                  IN       iapiType.PartNo_Type,
      anRevision1                IN       iapiType.Revision_Type,
      asPartNo2                  IN       iapiType.PartNo_Type,
      anRevision2                IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anRefId                    IN       iapiType.Id_Type,
      aqPropertyGroup            OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPropertyGroupDetailLang(
      asPartNo1                  IN       iapiType.PartNo_Type,
      anRevision1                IN       iapiType.Revision_Type,
      anlangId1                  IN       iapiType.LanguageId_Type,
      asPartNo2                  IN       iapiType.PartNo_Type,
      anRevision2                IN       iapiType.Revision_Type,
      anlangId2                  IN       iapiType.LanguageId_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      anRefId                    IN       iapiType.Id_Type,
      aqPropertyGroup            OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPropertyGroupNoteDetail(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anlangId                   IN       iapiType.LanguageId_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      aqPropertyGroupNote        OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiCompare;