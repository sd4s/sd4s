create or replace PACKAGE iapiPartManufacturer
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiPartManufacturer.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain part manufacturers.
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
   gsSource                      iapiType.Source_Type := 'iapiPartManufacturer';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddManufacturer(
      asPartNo                   IN       iapiType.PartNo_Type,
      anManufacturerId           IN       iapiType.Id_Type,
      asManufacturerPlantNo      IN       iapiType.ManufacturerPlantNo_Type,
      asProductCode              IN       iapiType.ProductCode_Type,
      adApprovalDate             IN       iapiType.Date_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anObjectId                 IN       iapiType.Id_Type,
      anObjectRevision           IN       iapiType.Revision_Type,
      anObjectOwner              IN       iapiType.Owner_Type,
      asClearanceNo              IN       iapiType.ClearanceNumber_Type DEFAULT NULL,
      asTradeName                IN       iapiType.TradeName_Type DEFAULT NULL,
      adAuditDate                IN       iapiType.Date_Type DEFAULT NULL,
      anAuditFrequency           IN       iapiType.AuditFrequence_Type DEFAULT NULL,
      anInternational            IN       iapiType.Intl_Type DEFAULT 0,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetManufacturers(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqManufacturers            OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveManufacturer(
      asPartNo                   IN       iapiType.PartNo_Type,
      anManufacturerId           IN       iapiType.Id_Type,
      asManufacturerPlantNo      IN       iapiType.ManufacturerPlantNo_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveManufacturer(
      asPartNo                   IN       iapiType.PartNo_Type,
      anManufacturerId           IN       iapiType.Id_Type,
      asManufacturerPlantNo      IN       iapiType.ManufacturerPlantNo_Type,
      asProductCode              IN       iapiType.ProductCode_Type,
      adApprovalDate             IN       iapiType.Date_Type,
      anRevision                 IN       iapiType.Revision_Type,
      anObjectId                 IN       iapiType.Id_Type,
      anObjectRevision           IN       iapiType.Revision_Type,
      anObjectOwner              IN       iapiType.Owner_Type,
      asClearanceNo              IN       iapiType.ClearanceNumber_Type DEFAULT NULL,
      asTradeName                IN       iapiType.TradeName_Type DEFAULT NULL,
      adAuditDate                IN       iapiType.Date_Type DEFAULT NULL,
      anAuditFrequency           IN       iapiType.AuditFrequence_Type DEFAULT NULL,
      anInternational            IN       iapiType.Intl_Type DEFAULT 0,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiPartManufacturer;