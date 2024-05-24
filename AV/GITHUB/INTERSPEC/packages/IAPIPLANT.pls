create or replace PACKAGE iapiPlant
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiPlant.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain plants.
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
   gsSource                      iapiType.Source_Type := 'iapiPlant';
   gtPlants                      iapiType.PlantTab_Type;
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      asPlantNo                  IN       iapiType.PlantNo_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetKeywords(
      asPlantId                  IN       iapiType.Plant_Type,
      aqKeywords                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLocations(
      asPlantNo                  IN       iapiType.PlantNo_Type,
      aqLocations                OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlant(
      asPlantNo                  IN       iapiType.PlantNo_Type,
      aqPlant                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlants(
      atDefaultFilter            IN       iapiType.FilterTab_Type,
      atKeywordFilter            IN       iapiType.FilterTab_Type,
      anDoNotHave                IN       iapiType.Boolean_Type DEFAULT 0,
      aqPlants                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlants(
      axDefaultFilter            IN       iapiType.XmlType_Type,
      axKeywordFilter            IN       iapiType.XmlType_Type,
      anDoNotHave                IN       iapiType.Boolean_Type DEFAULT 0,
      aqPlants                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlantsPb(
      asDefaultFilter            IN       iapiType.XmlString_Type,
      asKeywordFilter            IN       iapiType.XmlString_Type,
      anDoNotHave                IN       iapiType.Boolean_Type DEFAULT 0,
      aqPlants                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiPlant;