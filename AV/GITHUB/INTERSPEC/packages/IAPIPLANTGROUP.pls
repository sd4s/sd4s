create or replace PACKAGE iapiPlantGroup
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiPlantGroup.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain plantgroups and their
   --           relation with plants.
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
   gsSource                      iapiType.Source_Type := 'iapiPlantGroup';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddPlantGroup(
      anPlantGroup               IN       iapiType.Id_Type,
      asDescription              IN       iapiType.Description_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AddPlantToPlantGroup(
      anPlantGroup               IN       iapiType.PlantGroup_Type,
      asPlant                    IN       iapiType.Plant_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExistPlant(
      asPlant                    IN       iapiType.Plant_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION ExistPlantGroup(
      anPlantGroup               IN       iapiType.PlantGroup_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION ExistPlantInPlantGroup(
      anPlantGroup               IN       iapiType.PlantGroup_Type,
      asPlant                    IN       iapiType.Plant_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlantGroups(
      aqPlantgroups              OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlantsAssignedToPlantGroup(
      anPlantGroup               IN       iapiType.PlantGroup_Type,
      aqPlants                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemovePlantFromPlantGroup(
      anPlantGroup               IN       iapiType.PlantGroup_Type,
      asPlant                    IN       iapiType.Plant_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemovePlantGroup(
      anPlantGroup               IN       iapiType.PlantGroup_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SavePlantGroup(
      anPlantGroup               IN       iapiType.PlantGroup_Type,
      asDescription              IN       iapiType.Description_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiPlantGroup;