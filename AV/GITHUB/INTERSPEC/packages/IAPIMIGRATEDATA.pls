create or replace PACKAGE iapiMigrateData
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiMigrateData.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to migrate data from another system
   --           (based on flat file(s) info) into
   --           InterSpec.
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
   gsSource                      iapiType.Source_Type := 'iapiMigrateData';

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AttachedSpecification(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Bom(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ClassificationDescriptor(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ClassificationTreeView(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION FreeText(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetCharacteristicId(
      asCharacteristic           IN       iapiType.Description_Type,
      anCharacteristicId         OUT      iapiType.Id_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportAttachedSpecification(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportBom(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportClassificationDescriptor(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportClassificationTreeView(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportFreeText(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportIngredientList(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportKeyword(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportManufacturer(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportPlant(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportProperty(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ImportSpecificationHeader(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION IngredientList(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Keyword(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Manufacturer(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Plant(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION Property(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SpecificationHeader(
      asDirectory                IN       iapiType.StringVal_Type,
      asFile                     IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiMigrateData;