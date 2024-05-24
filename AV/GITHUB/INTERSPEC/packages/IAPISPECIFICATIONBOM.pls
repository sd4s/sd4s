create or replace PACKAGE iapiSpecificationBom
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSpecificationBom.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain the BOM of a
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
   gsSource                      iapiType.Source_Type := 'iapiSpecificationBom';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   gtBomItems                    iapiType.BomItemTab_Type;
   gtBomHeaders                  iapiType.BomHeaderTab_Type;
   grBomExplosion                iapiType.BomExplosionRec_Type;
   gtGetBomHeaders               BomHeaderTable_Type := BomHeaderTable_Type( );
   --IS160 Remove
   --gtGetBomItemsTab              iapiType.GetBomItemTab_Type; --orig
   gtGetBomItems                 BomItemTable_Type := BomItemTable_Type( );
   gtInfo                        iapiType.InfoTab_Type;
   --AP01485449 --remove the condition
   --AP00914553
   --gtExecutePrePostFunction      iapiType.Boolean_Type := 1;
   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddBomPath(
      anUniqueId                 IN       iapiType.Sequence_Type,
      asParentPartNo             IN       iapiType.PartNo_Type,
      anParentRevision           IN       iapiType.Revision_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      asAlternativeGroup         IN       iapiType.BomItemAltGroup_Type,
      anAlternativePriority      IN       iapiType.BomItemAltPriority_Type,
      anIsHeader                 IN       iapiType.Boolean_Type,
      anLevel                    IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddDevHeader(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddHeader(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      asDescription              IN       iapiType.Description_Type,
      anQuantity                 IN       iapiType.BomQuantity_Type,
      anConversionFactor         IN       iapiType.BomConvFactor_Type,
      asConvertedUom             IN       iapiType.Description_Type,
      anYield                    IN       iapiType.BomYield_Type,
      asCalculationMode          IN       iapiType.BomItemCalcFlag_Type,
      asBomType                  IN       iapiType.BomItemType_Type,
      anMinimumQuantity          IN       iapiType.BomQuantity_Type,
      anMaximumQuantity          IN       iapiType.BomQuantity_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      anItemNumber               IN       iapiType.BomItemNumber_Type,
      asAlternativeGroup         IN       iapiType.BomItemAltGroup_Type,
      anAlternativePriority      IN       iapiType.BomItemAltPriority_Type,
      asComponentPartNo          IN       iapiType.PartNo_Type,
      anComponentRevision        IN       iapiType.Revision_Type,
      asComponentPlant           IN       iapiType.Plant_Type,
      anQuantity                 IN       iapiType.BomQuantity_Type,
      asUom                      IN       iapiType.Description_Type,
      anConversionFactor         IN       iapiType.BomConvFactor_Type,
      asConvertedUom             IN       iapiType.Description_Type,
      anYield                    IN       iapiType.BomYield_Type,
      anAssemblyScrap            IN       iapiType.Scrap_Type,
      anComponentScrap           IN       iapiType.Scrap_Type,
      anLeadTimeOffset           IN       iapiType.BomLeadTimeOffset_Type,
      anRelevancyToCosting       IN       iapiType.Boolean_Type,
      anBulkMaterial             IN       iapiType.Boolean_Type,
      asItemCategory             IN       iapiType.BomItemCategory_Type,
      asIssueLocation            IN       iapiType.BomIssueLocation_Type,
      asCalculationMode          IN       iapiType.BomItemCalcFlag_Type,
      asBomItemType              IN       iapiType.BomItemType_Type,
      anOperationalStep          IN       iapiType.BomOperationalStep_Type,
      anMinimumQuantity          IN       iapiType.BomQuantity_Type,
      anMaximumQuantity          IN       iapiType.BomQuantity_Type,
      anFixedQuantity            IN       iapiType.Boolean_Type,
      asCode                     IN       iapiType.BomItemCode_Type,
      asText1                    IN       iapiType.BomItemLongCharacter_Type,
      asText2                    IN       iapiType.BomItemLongCharacter_Type,
      asText3                    IN       iapiType.BomItemCharacter_Type,
      asText4                    IN       iapiType.BomItemCharacter_Type,
      asText5                    IN       iapiType.BomItemCharacter_Type,
      anNumeric1                 IN       iapiType.BomItemNumeric_Type,
      anNumeric2                 IN       iapiType.BomItemNumeric_Type,
      anNumeric3                 IN       iapiType.BomItemNumeric_Type,
      anNumeric4                 IN       iapiType.BomItemNumeric_Type,
      anNumeric5                 IN       iapiType.BomItemNumeric_Type,
      anBoolean1                 IN       iapiType.Boolean_Type,
      anBoolean2                 IN       iapiType.Boolean_Type,
      anBoolean3                 IN       iapiType.Boolean_Type,
      anBoolean4                 IN       iapiType.Boolean_Type,
      adDate1                    IN       iapiType.Date_Type,
      adDate2                    IN       iapiType.Date_Type,
      anCharacteristic1          IN       iapiType.Id_Type,
      anCharacteristic2          IN       iapiType.Id_Type,
      anCharacteristic3          IN       iapiType.Id_Type,
      anMakeUp                   IN       iapiType.Boolean_Type,
      asInternationalEquivalent  IN       iapiType.PartNo_Type DEFAULT NULL,
      anIgnorePartPlantRelation  IN       iapiType.Boolean_Type DEFAULT 0,
      anComponentScrapSync       IN       iapiType.Boolean_Type DEFAULT 0,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   --AP01280332 Start
   ---------------------------------------------------------------------------
   FUNCTION AddItem_MOP(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      anItemNumber               IN       iapiType.BomItemNumber_Type,
      asComponentPartNo          IN       iapiType.PartNo_Type,
      asComponentPlant           IN       iapiType.Plant_Type,
      anQuantity                 IN       iapiType.BomQuantity_Type,
      asUom                      IN       iapiType.Description_Type,
      anConversionFactor         IN       iapiType.BomConvFactor_Type,
      asConvertedUom             IN       iapiType.Description_Type,
      anYield                    IN       iapiType.BomYield_Type,
      anAssemblyScrap            IN       iapiType.Scrap_Type,
      anComponentScrap           IN       iapiType.Scrap_Type,
      anLeadTimeOffset           IN       iapiType.BomLeadTimeOffset_Type,
      anRelevancyToCosting       IN       iapiType.Boolean_Type,
      anBulkMaterial             IN       iapiType.Boolean_Type,
      asItemCategory             IN       iapiType.BomItemCategory_Type,
      asIssueLocation            IN       iapiType.BomIssueLocation_Type,
      asCalculationMode          IN       iapiType.BomItemCalcFlag_Type)
      RETURN iapiType.ErrorNum_Type;
      --AP01280332 End

   ---------------------------------------------------------------------------
   PROCEDURE ApplyAutoCalc(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      anAlternative              IN       iapiType.BomAlternative_Type );

   ---------------------------------------------------------------------------
   PROCEDURE ApplyAutoCalc(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anCalcQuantity             OUT      iapiType.BomQuantity_Type,
      anCalcConvFactor           OUT      iapiType.BomConvFactor_Type );

   ---------------------------------------------------------------------------
   FUNCTION BomRecordsMatch(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ChangeHeader(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      asNewPlant                 IN       iapiType.Plant_Type,
      anNewAlternative           IN       iapiType.BomAlternative_Type,
      anNewUsage                 IN       iapiType.BomUsage_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckPlantAvailability(
      anUniqueId                 IN       iapiType.Sequence_Type,
      asPlant                    IN       iapiType.Plant_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CopyBom(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asFromPlant                IN       iapiType.Plant_Type,
      anFromAlternative          IN       iapiType.BomAlternative_Type,
      anFromUsage                IN       iapiType.BomUsage_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      asDescription              IN       iapiType.Description_Type,
      anQuantity                 IN       iapiType.BomQuantity_Type,
      anMinimumQuantity          IN       iapiType.BomQuantity_Type,
      anMaximumQuantity          IN       iapiType.BomQuantity_Type,
      anCopy                     IN       iapiType.Boolean_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Explode(
      anUniqueId                 IN       iapiType.Sequence_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      anMultiLevel               IN       iapiType.Boolean_Type DEFAULT 1,
      adExplosionDate            IN       iapiType.Date_Type DEFAULT SYSDATE,
      anBatchQuantity            IN       iapiType.BomQuantity_Type DEFAULT 100,
      anIncludeInDevelopment     IN       iapiType.Boolean_Type DEFAULT 0,
      anUseMop                   IN       iapiType.Boolean_Type DEFAULT 0,
      anUseBomPath               IN       iapiType.Boolean_Type DEFAULT 0,
      anExplosionType            IN       iapiType.NumVal_Type DEFAULT iapiConstant.EXPLOSION_STANDARD,
      asPriceType                IN       iapiType.PriceType_Type DEFAULT NULL,
      asPeriod                   IN       iapiType.Period_Type DEFAULT NULL,
      asAlternativePriceType     IN       iapiType.PriceType_Type DEFAULT NULL,
      asAlternativePeriod        IN       iapiType.Period_Type DEFAULT NULL,
      aqErrors                   OUT      iapiType.Ref_Type,
      --ISQF131 --oneLine
      anIncludeAlternatives     IN        iapiType.Boolean_Type DEFAULT 0)
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExplodeIngredients(
      anUniqueId                 IN       iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetAttachedExplosion(
      anUniqueId                 IN       iapiType.Sequence_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetBomPathHeaders(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asParentPlant              IN       iapiType.Plant_Type,
      anParentUsage              IN       iapiType.BomUsage_Type,
      aqHeaders                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetBomPathItems(
      anUniqueId                 IN       iapiType.Sequence_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      anIncludeInDevelopment     IN       iapiType.Boolean_Type,
      adExplosionDate            IN       iapiType.Date_Type,
      aqBomPath                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetBomPaths(
      anUniqueId                 IN       iapiType.Sequence_Type,
      aqPaths                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetComponentRevision(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      adDrillDownDate            IN       iapiType.Date_Type,
      abInDevelopment            IN       iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetDominantUom(
      lnBomExpNo                 IN       iapiType.Sequence_Type,
      lsDominantUom              OUT      iapiType.Description_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetExplosion(
      anUniqueId                 IN       iapiType.Sequence_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   --AP00886496 Start
   ---------------------------------------------------------------------------
   FUNCTION GetExplosionExt(
      anUniqueId                 IN       iapiType.Sequence_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
   --AP00886496 End

   ---------------------------------------------------------------------------
   FUNCTION GetExplosionAsBoughtSold(
      anUniqueId                 IN       iapiType.Sequence_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetExplosionHeaders(
      asPartNo                   IN       iapiType.PartNo_Type,
      adExplosionDate            IN       iapiType.Date_Type DEFAULT SYSDATE,
      anIncludeInDevelopment     IN       iapiType.Boolean_Type DEFAULT 0,
      aqHeaders                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetHeaders(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      aqHeaders                  OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetImplosion(
      anUniqueId                 IN       iapiType.Sequence_Type,
      atFilterOptions            IN       iapiType.FilterTab_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetImplosion(
      anUniqueId                 IN       iapiType.Sequence_Type,
      axFilterOptions            IN       iapiType.XmlType_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetImplosionPb(
      anUniqueId                 IN       iapiType.Sequence_Type,
      axDefaultFilter            IN       iapiType.XmlString_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetIngredientExplosion(
      anUniqueId                 IN       iapiType.Sequence_Type,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetIngredientExplosionUom(
      anUniqueId                 IN       iapiType.Sequence_Type,
      anMopSequenceNo            IN       iapiType.Sequence_Type DEFAULT 1 )
      RETURN iapiType.Description_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetIngredientType(
      asPartNo                            iapiType.PartNo_Type,
      anRevision                          iapiType.Revision_Type,
      anExplosionType                     PLS_INTEGER )
      RETURN PLS_INTEGER;

   ---------------------------------------------------------------------------
   FUNCTION GetItems(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative              IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage                    IN       iapiType.BomUsage_Type DEFAULT NULL,
      anIncludeAlternatives      IN       iapiType.Boolean_Type DEFAULT 0,
      aqItems                    OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetMRPItems(
      asPartNo                   IN       iapiType.PartNo_Type,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anSpecType                 IN       iapiType.Id_Type DEFAULT 0,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Implode(
      anUniqueId                 IN       iapiType.Sequence_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      adExplosionDate            IN       iapiType.Date_Type DEFAULT SYSDATE,
      anIncludeInDevelopment     IN       iapiType.Boolean_Type DEFAULT 0,
      anLevel                    IN       iapiType.Level_Type DEFAULT iapiConstant.IMPLOSION_ALL,
      anUseMop                   IN       iapiType.Boolean_Type DEFAULT 0,
      anIncludeAlternatives      IN       iapiType.Boolean_Type DEFAULT 0 )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveBomPath(
      anUniqueId                 IN       iapiType.Sequence_Type,
      asParentPartNo             IN       iapiType.PartNo_Type,
      anParentRevision           IN       iapiType.Revision_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asAlternativeGroup         IN       iapiType.BomItemAltGroup_Type,
      anAlternativePriority      IN       iapiType.BomItemAltPriority_Type,
      anIsHeader                 IN       iapiType.Boolean_Type,
      anLevel                    IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveHeader(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anAlternative              IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage                    IN       iapiType.BomUsage_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      anItemNumber               IN       iapiType.BomItemNumber_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   --AP01280332 Start
   ---------------------------------------------------------------------------
   FUNCTION RemoveItem_MOP(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      asComponentPartNo          IN       iapiType.PartNo_Type,
      asComponentPlant           IN       iapiType.Plant_Type)
      RETURN iapiType.ErrorNum_Type;
   --AP01280332 End

   ---------------------------------------------------------------------------
   FUNCTION ResetBomPath(
      anUniqueId                 IN       iapiType.Sequence_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveBomHeaderBulk(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anAction                   IN       iapiType.NumVal_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveBomItemBulk(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      anAction                   IN       iapiType.NumVal_Type,
      afHandle                   IN       iapiType.Float_Type DEFAULT NULL,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveHeader(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      asDescription              IN       iapiType.Description_Type,
      anQuantity                 IN       iapiType.BomQuantity_Type,
      anConversionFactor         IN       iapiType.BomConvFactor_Type,
      asConvertedUom             IN       iapiType.Description_Type,
      anYield                    IN       iapiType.BomYield_Type,
      asCalculationMode          IN       iapiType.BomItemCalcFlag_Type,
      asBomType                  IN       iapiType.BomItemType_Type,
      anMinimumQuantity          IN       iapiType.BomQuantity_Type,
      anMaximumQuantity          IN       iapiType.BomQuantity_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveItem(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      anItemNumber               IN       iapiType.BomItemNumber_Type,
      anNewItemNumber            IN       iapiType.BomItemNumber_Type DEFAULT NULL,
      asAlternativeGroup         IN       iapiType.BomItemAltGroup_Type,
      anAlternativePriority      IN       iapiType.BomItemAltPriority_Type,
      asComponentPartNo          IN       iapiType.PartNo_Type,
      anComponentRevision        IN       iapiType.Revision_Type,
      asComponentPlant           IN       iapiType.Plant_Type,
      anQuantity                 IN       iapiType.BomQuantity_Type,
      asUom                      IN       iapiType.Description_Type,
      anConversionFactor         IN       iapiType.BomConvFactor_Type,
      asConvertedUom             IN       iapiType.Description_Type,
      anYield                    IN       iapiType.BomYield_Type,
      anAssemblyScrap            IN       iapiType.Scrap_Type,
      anComponentScrap           IN       iapiType.Scrap_Type,
      anLeadTimeOffset           IN       iapiType.BomLeadTimeOffset_Type,
      anRelevancyToCosting       IN       iapiType.Boolean_Type,
      anBulkMaterial             IN       iapiType.Boolean_Type,
      asItemCategory             IN       iapiType.BomItemCategory_Type,
      asIssueLocation            IN       iapiType.BomIssueLocation_Type,
      asCalculationMode          IN       iapiType.BomItemCalcFlag_Type,
      asBomItemType              IN       iapiType.BomItemType_Type,
      anOperationalStep          IN       iapiType.BomOperationalStep_Type,
      anMinimumQuantity          IN       iapiType.BomQuantity_Type,
      anMaximumQuantity          IN       iapiType.BomQuantity_Type,
      anFixedQuantity            IN       iapiType.Boolean_Type,
      asCode                     IN       iapiType.BomItemCode_Type,
      asText1                    IN       iapiType.BomItemLongCharacter_Type,
      asText2                    IN       iapiType.BomItemLongCharacter_Type,
      asText3                    IN       iapiType.BomItemCharacter_Type,
      asText4                    IN       iapiType.BomItemCharacter_Type,
      asText5                    IN       iapiType.BomItemCharacter_Type,
      anNumeric1                 IN       iapiType.BomItemNumeric_Type,
      anNumeric2                 IN       iapiType.BomItemNumeric_Type,
      anNumeric3                 IN       iapiType.BomItemNumeric_Type,
      anNumeric4                 IN       iapiType.BomItemNumeric_Type,
      anNumeric5                 IN       iapiType.BomItemNumeric_Type,
      anBoolean1                 IN       iapiType.Boolean_Type,
      anBoolean2                 IN       iapiType.Boolean_Type,
      anBoolean3                 IN       iapiType.Boolean_Type,
      anBoolean4                 IN       iapiType.Boolean_Type,
      adDate1                    IN       iapiType.Date_Type,
      adDate2                    IN       iapiType.Date_Type,
      anCharacteristic1          IN       iapiType.Id_Type,
      anCharacteristic2          IN       iapiType.Id_Type,
      anCharacteristic3          IN       iapiType.Id_Type,
      anMakeUp                   IN       iapiType.Boolean_Type,
      asInternationalEquivalent  IN       iapiType.PartNo_Type DEFAULT NULL,
      anComponentScrapSync       IN       iapiType.Boolean_Type DEFAULT 0,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   --AP01280332 Start
   ---------------------------------------------------------------------------
   FUNCTION SaveItem_MOP(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      asFromComponentPartNo      IN       iapiType.PartNo_Type,
      asToComponentPartNo        IN       iapiType.PartNo_Type,
      asUom                      IN       iapiType.Description_Type,
      anConversionFactor         IN       iapiType.BomConvFactor_Type,
      asConvertedUom             IN       iapiType.Description_Type,
      asCurrentComponentUom      IN       iapiType.Description_Type,
      anComponentScrap           IN       iapiType.Scrap_Type,
      anLeadTimeOffset           IN       iapiType.BomLeadTimeOffset_Type,
      anRelevancyToCosting       IN       iapiType.Boolean_Type,
      anBulkMaterial             IN       iapiType.Boolean_Type,
      asItemCategory             IN       iapiType.BomItemCategory_Type,
      asIssueLocation            IN       iapiType.BomIssueLocation_Type,
      anOperationalStep          IN       iapiType.BomOperationalStep_Type,
      anComponentScrapSync       IN       iapiType.Boolean_Type DEFAULT 0)
      RETURN iapiType.ErrorNum_Type;
   --AP01280332 End

   ---------------------------------------------------------------------------
   FUNCTION SavePlannedEffectiveDate(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      adPlannedEffectiveDate     IN       iapiType.Date_Type,
      aqInfo                     OUT      iapiType.Ref_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetPreferredHeader(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anUsage                    IN       iapiType.BomUsage_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   FUNCTION GetUomDescription(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPlant                    IN       iapiType.Plant_Type DEFAULT NULL,
      anUomId                    IN       iapiType.Id_Type,
      asPartNoParent             IN       iapiType.PartNo_Type,
      anRevisionParent           IN       iapiType.Revision_Type)
      RETURN iapiType.Description_Type;

FUNCTION GetUomBase(
      anUomId                    IN      iapiType.Id_Type,
      abSameType                 IN      iapiType.Boolean_Type DEFAULT 1)
      RETURN  iapiType.Id_Type;

   FUNCTION GetFirstInternalBomItem(
      aqBomItem                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecificationBom;