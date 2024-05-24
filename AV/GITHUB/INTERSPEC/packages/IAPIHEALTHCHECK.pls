create or replace PACKAGE iapiHealthCheck
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiHealthCheck.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality for health check.
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
   gsSource                      iapiType.Source_Type := 'iapiHealthCheck';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION CheckDeletedItemsForPartPlants(
      anSpecificationType        IN       iapiType.Id_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anUseMoP                   IN       iapiType.NumVal_Type DEFAULT 0,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckDeletedItemsForParts(
      anSpecificationType        IN       iapiType.Id_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anUseMoP                   IN       iapiType.NumVal_Type DEFAULT 0,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckOrphanedItemsForAth(
      anSpecificationType        IN       iapiType.Id_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anUseMoP                   IN       iapiType.NumVal_Type DEFAULT 0,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckOrphanedItemsForBom(
      anSpecificationType        IN       iapiType.Id_Type,
      anStatus                   IN       iapiType.StatusId_Type,
      asPlant                    IN       iapiType.Plant_Type,
      anUseMoP                   IN       iapiType.NumVal_Type DEFAULT 0,
      aqItems                    OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiHealthCheck;