create or replace PACKAGE iapiManufacturerPlant
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiManufacturerPlant.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain the manufacturer-plants
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
   gsSource                      iapiType.Source_Type := 'iapiManufacturerPlant';
   gtManufacturerPlants          iapiType.ManufacturerPlantTab_Type;
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      anManufacturerPlantNo      IN       iapiType.ManufacturerPlantNo_Type,
      anManufacturerId           IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetKeywords(
      anManufacturerPlantNo      IN       iapiType.ManufacturerPlantNo_Type,
      anManufacturerId           IN       iapiType.Id_Type,
      aqKeywords                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturerPlant(
      asManufacturerPlantNo      IN       iapiType.ManufacturerPlantNo_Type,
      anManufacturerId           IN       iapiType.Id_Type,
      aqManufacturerPlant        OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturerPlants(
      atDefaultFilter            IN       iapiType.FilterTab_Type,
      atKeywordFilter            IN       iapiType.FilterTab_Type,
      anDoNotHave                IN       iapiType.Boolean_Type DEFAULT 0,
      asSpecPrefixType           IN       iapiType.SpecificationPrefixType_type DEFAULT NULL,
      aqManufacturerPlants       OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturerPlants(
      axDefaultFilter            IN       iapiType.XmlType_Type,
      axKeywordFilter            IN       iapiType.XmlType_Type,
      anDoNotHave                IN       iapiType.Boolean_Type DEFAULT 0,
      asSpecPrefixType           IN       iapiType.SpecificationPrefixType_type DEFAULT NULL,
      aqManufacturerPlants       OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturerPlantsPb(
      asDefaultFilter            IN       iapiType.XmlString_Type,
      asKeywordFilter            IN       iapiType.XmlString_Type,
      anDoNotHave                IN       iapiType.Boolean_Type DEFAULT 0,
      asSpecPrefixType           IN       iapiType.SpecificationPrefixType_type DEFAULT NULL,
      aqManufacturerPlants       OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiManufacturerPlant;