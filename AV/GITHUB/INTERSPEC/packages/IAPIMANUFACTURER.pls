create or replace PACKAGE iapiManufacturer
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiManufacturer.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain manufacturers.
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
   gsSource                      iapiType.Source_Type := 'iapiManufacturer';
   gtManufacturers               iapiType.ManufacturerTab_Type;
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION ExistId(
      anManufacturerId           IN       iapiType.Id_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetKeywords(
      anManufacturerId           IN       iapiType.Id_Type,
      aqKeywords                 OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturer(
      anManufacturerId           IN       iapiType.Id_Type,
      aqManufacturer             OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturers(
      atDefaultFilter            IN       iapiType.FilterTab_Type,
      atKeywordFilter            IN       iapiType.FilterTab_Type,
      anDoNotHave                IN       iapiType.Boolean_Type DEFAULT 0,
      asSpecPrefixType           IN       iapiType.SpecificationPrefixType_Type DEFAULT NULL,
      anWhereUsed                IN       iapiType.Boolean_Type DEFAULT 1,
      aqManufacturers            OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturers(
      axDefaultFilter            IN       iapiType.XmlType_Type,
      axKeywordFilter            IN       iapiType.XmlType_Type,
      anDoNotHave                IN       iapiType.Boolean_Type DEFAULT 0,
      asSpecPrefixType           IN       iapiType.SpecificationPrefixType_Type DEFAULT NULL,
      anWhereUsed                IN       iapiType.Boolean_Type DEFAULT 1,
      aqManufacturers            OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturersPb(
      asDefaultFilter            IN       iapiType.XmlString_Type,
      asKeywordFilter            IN       iapiType.XmlString_Type,
      anDoNotHave                IN       iapiType.Boolean_Type DEFAULT 0,
      asSpecPrefixType           IN       iapiType.SpecificationPrefixType_Type DEFAULT NULL,
      anWhereUsed                IN       iapiType.Boolean_Type DEFAULT 1,
      aqManufacturers            OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturerTypes(
      atDefaultFilter            IN       iapiType.FilterTab_Type,
      aqManufacturerTypes        OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturerTypes(
      axDefaultFilter            IN       iapiType.XmlType_Type,
      aqManufacturerTypes        OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturerTypesPb(
      asDefaultFilter            IN       iapiType.XmlString_Type,
      aqManufacturerTypes        OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ShowLocal(
      asSpecPrefixType           IN       iapiType.SpecificationPrefixType_Type,
      anShowLocal                OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiManufacturer;