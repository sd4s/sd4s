create or replace PACKAGE iapiCustomCalculation
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiCustomCalculation.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality for the Custom calculation
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
   gsSource                      iapiType.Source_Type := 'iapiCustomCalculation';
   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION ValidateCustomCalculation(
      asValidationFunction       IN       iapiType.StringVal_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      asReferenceType            IN       iapiType.StringVal_Type,
      asCulture                  IN       iapiType.StringVal_Type,
      --IS620 --abLogError added
      abLogError                 IN       iapiType.Boolean_Type DEFAULT 1)
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateMA(
      asPartNo                   IN       iapiType.PartNo_Type,
      asReferenceType            IN       iapiType.StringVal_Type,
      asCulture                  IN       iapiType.StringVal_Type,
      --IS620 --abLogError added
      abLogError                 IN       iapiType.Boolean_Type DEFAULT 1)
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateFA(
      asPartNo                   IN       iapiType.PartNo_Type,
      asReferenceType            IN       iapiType.StringVal_Type,
      asCulture                  IN       iapiType.StringVal_Type,
      --IS620 --abLogError added
      abLogError                 IN       iapiType.Boolean_Type DEFAULT 1)
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateMFA(
      asPartNo                   IN       iapiType.PartNo_Type,
      asReferenceType            IN       iapiType.StringVal_Type,
      asCulture                  IN       iapiType.StringVal_Type,
      --IS620 --abLogError added
      abLogError                 IN       iapiType.Boolean_Type DEFAULT 1)
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateRF(
      asPartNo                   IN       iapiType.PartNo_Type,
      asReferenceType            IN       iapiType.StringVal_Type,
      asCulture                  IN       iapiType.StringVal_Type,
      --IS620 --abLogError added
      abLogError                 IN       iapiType.Boolean_Type DEFAULT 1)
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   PROCEDURE GetCustomCalculations(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asReferenceType            IN       iapiType.StringVal_Type,
      asCulture                  IN       iapiType.StringVal_Type,
      aqCalculations             OUT      iapiType.Ref_Type );

   ---------------------------------------------------------------------------
   PROCEDURE GetCustomCalculationValues(
      asPartNo                   IN       iapiType.PartNo_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asReferenceType            IN       iapiType.StringVal_Type,
      asCulture                  IN       iapiType.StringVal_Type,
      aqCalculationValues        OUT      iapiType.Ref_Type );

   ---------------------------------------------------------------------------
   PROCEDURE GetRetentionFactorGroups(
      asReferenceType            IN       iapiType.StringVal_Type,
      asCulture                  IN       iapiType.StringVal_Type,
      aqRfGroup                  OUT      iapiType.Ref_Type );

   ---------------------------------------------------------------------------
   PROCEDURE GetRetentionFactor(
      anId                       IN       iapiType.Id_Type,
      anDetailId                 IN       iapiType.Id_Type,
      asReferenceType            IN       iapiType.StringVal_Type,
      asCulture                  IN       iapiType.StringVal_Type,
      aqRfGroup                  OUT      iapiType.Ref_Type );
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiCustomCalculation;