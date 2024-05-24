create or replace PACKAGE iapiPartPlant
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiPartPlant.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to handle part/plant relations
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
   gsSource                      iapiType.Source_Type := 'iapiPartPlant';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddPlant(
      asPartNo                   IN       iapiType.PartNo_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      anComponentScrap           IN       iapiType.Scrap_Type DEFAULT 0,
      anRelevancyToCosting       IN       iapiType.Boolean_Type DEFAULT 0,
      anBulkMaterial             IN       iapiType.Boolean_Type DEFAULT 0,
      anLeadTimeOffset           IN       iapiType.LeadTimeOffset_Type DEFAULT 0,
      asItemCategory             IN       iapiType.ItemCategory_Type DEFAULT 'L',
      anObsolete                 IN       iapiType.Boolean_Type DEFAULT 0,
      asIssueLocation            IN       iapiType.IssueLocation_Type,
      asIssueUom                 IN       iapiType.IssueUom_Type,
      anOperationalStep          IN       iapiType.OperationalStep_Type,
      anComponentScrapSync       IN       iapiType.Boolean_Type DEFAULT 0,
      --R18 Revert
      --asActulStatus         IN          iapiType.PlantStatus_Type DEFAULT NULL,
      --asPlannedStatus       IN          iapiType.PlantStatus_Type DEFAULT NULL,
      --
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      asPartNo                   IN       iapiType.PartNo_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetHistory(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqHistory                  OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLocations(
      asPartNo                   IN       iapiType.PartNo_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      aqLocations                OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlants(
      asPartNo                   IN       iapiType.PartNo_Type,
      axDefaultFilter            IN       iapiType.XmlType_Type DEFAULT NULL,
      aqPlants                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlants(
      asPartNo                   IN       iapiType.PartNo_Type,
      atDefaultFilter            IN       iapiType.FilterTab_Type,
      aqPlants                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlantsPb(
      asPartNo                   IN       iapiType.PartNo_Type,
      axDefaultFilter            IN       iapiType.XmlString_Type DEFAULT NULL,
      aqPlants                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemovePlant(
      asPartNo                   IN       iapiType.PartNo_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SavePlant(
      asPartNo                   IN       iapiType.PartNo_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      anComponentScrap           IN       iapiType.Scrap_Type DEFAULT 0,
      anRelevancyToCosting       IN       iapiType.Boolean_Type DEFAULT 0,
      anBulkMaterial             IN       iapiType.Boolean_Type DEFAULT 0,
      anLeadTimeOffset           IN       iapiType.LeadTimeOffset_Type DEFAULT 0,
      asItemCategory             IN       iapiType.ItemCategory_Type DEFAULT 'L',
      anObsolete                 IN       iapiType.Boolean_Type DEFAULT 0,
      asIssueLocation            IN       iapiType.IssueLocation_Type,
      asIssueUom                 IN       iapiType.IssueUom_Type,
      anOperationalStep          IN       iapiType.OperationalStep_Type,
      anComponentScrapSync       IN       iapiType.Boolean_Type DEFAULT 0,
      --R18 Revert
      --asActualStatus         IN          iapiType.PlantStatus_Type DEFAULT NULL,
      --asPlannedStatus       IN          iapiType.PlantStatus_Type DEFAULT NULL,
      --
      aqErrors                   OUT      iapiType.Ref_Type)
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiPartPlant;