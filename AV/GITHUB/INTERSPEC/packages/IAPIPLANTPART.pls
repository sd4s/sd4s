create or replace PACKAGE iapiPlantPart
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiPlantPart.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           To improve performance when searching
   --           per plant, a new table is created for
   --           each plant. In this table, all parts
   --           linked with that table are stored.
   --           This package holds all procedures to
   --           handle this.
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
   gsSource                      iapiType.Source_Type := 'iapiPlantPart';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AssignPartToPlant(
      asPlant                    IN       iapiType.Plant_Type,
      asPartNo                   IN       iapiType.PartNo_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreatePlantTable(
      asPlant                    IN       iapiType.Plant_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPlantAccess(
      asPlant                    IN       iapiType.Plant_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      asPlantAccess              OUT      iapiType.PlantAccess_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION InsertPlantPart
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemovePartFromPlant(
      asPlant                    IN       iapiType.Plant_Type,
      asPartNo                   IN       iapiType.PartNo_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemovePlantTable(
      asPlant                    IN       iapiType.Plant_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetPlantAccess(
      asPartNo                   IN       iapiType.PartNo_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiPlantPart;