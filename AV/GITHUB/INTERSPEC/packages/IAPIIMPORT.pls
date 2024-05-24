create or replace PACKAGE iapiImport
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiImport.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to import data.
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
   gsSource                      iapiType.Source_Type := 'iapiImport';
   gnLineNo                      iapiType.Id_Type;

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddMapping(
      asUserId                   IN       iapiType.UserId_Type,
      asName                     IN       iapiType.MapName_Type,
      anSequence                 IN       iapiType.Sequence_Type,
      asType                     IN       iapiType.MapType_Type,
      asGroup                    IN       iapiType.MapGroup_Type,
      asItem                     IN       iapiType.MapItem_Type,
      asOriginalValue            IN       iapiType.MapValue_Type,
      asRemapValue               IN       iapiType.MapValue_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddBom(
      anImpGetDataNo             IN OUT   iapiType.Id_Type,
      asBomHeaderDesc            IN       iapiType.Description_Type,
      anBomHeaderBaseQty         IN       iapiType.BomQuantity_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anAlternative              IN       iapiType.BomAlternative_Type,
      anItemNumber               IN       iapiType.BomItemNumber_Type,
      asComponentPartNo          IN       iapiType.PartNo_Type,
      anComponentRevision        IN       iapiType.Revision_Type DEFAULT NULL,
      asComponentPlant           IN       iapiType.Plant_Type,
      anQuantity                 IN       iapiType.BomQuantity_Type DEFAULT NULL,
      asUom                      IN       iapiType.Description_Type,
      anConversionFactor         IN       iapiType.BomConvFactor_Type DEFAULT NULL,
      asToUnit                   IN       iapiType.BaseUom_Type DEFAULT NULL,
      anYield                    IN       iapiType.BomYield_Type DEFAULT NULL,
      anAssemblyScrap            IN       iapiType.Scrap_Type DEFAULT NULL,
      anComponentScrap           IN       iapiType.Scrap_Type DEFAULT NULL,
      anLeadTimeOffset           IN       iapiType.BomLeadTimeOffset_Type DEFAULT NULL,
      asItemCategory             IN       iapiType.BomItemCategory_Type,
      asIssueLocation            IN       iapiType.BomIssueLocation_Type DEFAULT NULL,
      asCalculationMode          IN       iapiType.BomItemCalcFlag_Type DEFAULT NULL,
      asBomItemType              IN       iapiType.BomItemType_Type DEFAULT NULL,
      anOperationalStep          IN       iapiType.BomOperationalStep_Type DEFAULT NULL,
      anBomUsage                 IN       iapiType.BomUsage_Type,
      anMinimumQuantity          IN       iapiType.BomQuantity_Type DEFAULT NULL,
      anMaximumQuantity          IN       iapiType.BomQuantity_Type DEFAULT NULL,
      asText1                    IN       iapiType.BomItemLongCharacter_Type DEFAULT NULL,
      asText2                    IN       iapiType.BomItemLongCharacter_Type DEFAULT NULL,
      asCode                     IN       iapiType.BomItemCode_Type DEFAULT NULL,
      asAlternativeGroup         IN       iapiType.BomItemAltGroup_Type DEFAULT NULL,
      anAlternativePriority      IN       iapiType.BomItemAltPriority_Type DEFAULT 1,
      anNumeric1                 IN       iapiType.BomItemNumeric_Type DEFAULT NULL,
      anNumeric2                 IN       iapiType.BomItemNumeric_Type DEFAULT NULL,
      anNumeric3                 IN       iapiType.BomItemNumeric_Type DEFAULT NULL,
      anNumeric4                 IN       iapiType.BomItemNumeric_Type DEFAULT NULL,
      anNumeric5                 IN       iapiType.BomItemNumeric_Type DEFAULT NULL,
      asText3                    IN       iapiType.BomItemCharacter_Type DEFAULT NULL,
      asText4                    IN       iapiType.BomItemCharacter_Type DEFAULT NULL,
      asText5                    IN       iapiType.BomItemCharacter_Type DEFAULT NULL,
      adDate1                    IN       iapiType.Date_Type DEFAULT NULL,
      adDate2                    IN       iapiType.Date_Type DEFAULT NULL,
      anCharacteristic1          IN       iapiType.id_Type DEFAULT NULL,
      anCharacteristic2          IN       iapiType.id_Type DEFAULT NULL,
      anCharacteristic3          IN       iapiType.id_Type DEFAULT NULL,
      anRelevancyToCosting       IN       iapiType.Boolean_Type DEFAULT 0,
      anBulkMaterial             IN       iapiType.Boolean_Type DEFAULT 0,
      anFixedQuantity            IN       iapiType.Boolean_Type DEFAULT 0,
      anBoolean1                 IN       iapiType.Boolean_Type DEFAULT 0,
      anBoolean2                 IN       iapiType.Boolean_Type DEFAULT 0,
      anBoolean3                 IN       iapiType.Boolean_Type DEFAULT 0,
      anBoolean4                 IN       iapiType.Boolean_Type DEFAULT 0,
      anMakeUp                   IN       iapiType.Boolean_Type DEFAULT 0 )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddProperty(
      anImpGetDataNo             IN OUT   iapiType.Id_Type,
      anPropertyGroupId          IN       iapiType.Id_Type,
      anPropertyId               IN       iapiType.Id_Type,
      anAttributeId              IN       iapiType.Id_Type,
      anHeaderId                 IN       iapiType.Id_Type,
      asValue                    IN       iapiType.PropertyLongString_Type,
      anValue                    IN       iapiType.Float_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLogging(
      anImpGetDataNo             IN       iapiType.Id_Type,
      aqImportLogs               OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetMapping(
      asUserId                   IN       iapiType.UserId_Type,
      asName                     IN       iapiType.MapName_Type,
      asType                     IN       iapiType.MapType_Type,
      asGroup                    IN       iapiType.MapGroup_Type,
      aqMappings                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetMappings(
      asUserId                   IN       iapiType.UserId_Type,
      asType                     IN       iapiType.MapType_Type,
      asGroup                    IN       iapiType.MapGroup_Type,
      aqMappingNames             OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportData(
      anImpGetDataNo             IN       iapiType.Id_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anSectionId                IN       iapiType.Id_Type,
      anSubSectionId             IN       iapiType.Id_Type,
      anType                     IN       iapiType.SpecificationSectionType_Type,
      aqInfo                     OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveMapping(
      asUserId                   IN       iapiType.UserId_Type,
      asName                     IN       iapiType.MapName_Type,
      asType                     IN       iapiType.MapType_Type,
      asGroup                    IN       iapiType.MapGroup_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveMapping(
      asUserId                   IN       iapiType.UserId_Type,
      asName                     IN       iapiType.MapName_Type,
      anSequence                 IN       iapiType.Sequence_Type,
      asType                     IN       iapiType.MapType_Type,
      asGroup                    IN       iapiType.MapGroup_Type,
      asItem                     IN       iapiType.MapItem_Type,
      asOriginalValue            IN       iapiType.MapValue_Type,
      asRemapValue               IN       iapiType.MapValue_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiImport;