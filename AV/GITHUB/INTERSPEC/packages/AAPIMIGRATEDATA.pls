create or replace PACKAGE            "AAPIMIGRATEDATA"
IS
   FUNCTION GetPackageVersion
      RETURN iapiType.String_Type;

   gsSource                      iapiType.Source_Type := 'iapiMigrateData';

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
END aapiMigrateData;