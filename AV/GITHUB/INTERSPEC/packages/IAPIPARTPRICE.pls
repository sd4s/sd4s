create or replace PACKAGE iapiPartPrice
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiPartPrice.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain part prices.
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
   gsSource                      iapiType.Source_Type := 'iapiPartPrice';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION GetPrices(
      asPartNo                   IN       iapiType.PartNo_Type,
      atPlantFilter              IN       iapiType.FilterTab_Type,
      aqPrices                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetPrices(
      asPartNo                   IN       iapiType.PartNo_Type,
      axPlantFilter              IN       iapiType.XmlType_Type,
      aqPrices                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SavePrice(
      asPartNo                   IN       iapiType.PartNo_Type,
      asPeriod                   IN       iapiType.Period_Type,
      asPriceType                IN       iapiType.PriceType_Type,
      asPlantNo                  IN       iapiType.PlantNo_Type,
      anPrice                    IN       iapiType.Price_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiPartPrice;