create or replace PACKAGE iapiPartClassification
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiPartClassification.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains all
   --           functionality to maintain part classification.
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
   gsSource                      iapiType.Source_Type := 'iapiPartClassification';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddClassification(
      asPartNo                   IN       iapiType.PartNo_Type,
      anhierarchicallevel        IN       iapiType.Level_Type,
      anMaterialClassId          IN       iapiType.MaterialClassId_Type,
      asClassificationCode       IN       iapiType.ClassificationCode_Type,
      asClassificationType       IN       iapiType.ClassificationType_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetClassifications(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqClassifications          OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveClassification(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiPartClassification;