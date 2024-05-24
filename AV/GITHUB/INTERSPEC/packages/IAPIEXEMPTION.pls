create or replace PACKAGE iapiExemption
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiExemption.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           Package to handle exemptions.
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
   gsSource                      iapiType.Source_Type := 'iapiExemption';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddExemption(
      asPartNo                   IN       iapiType.PartNo_Type,
      asDescription              IN       iapiType.Description_Type,
      alText                     IN       iapiType.Clob_Type,
      adFromDate                 IN       iapiType.Date_Type,
      adToDate                   IN       iapiType.Date_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetExemptions(
      asPartNo                   IN       iapiType.PartNo_Type,
      aqExemptions               OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION RemoveExemption(
      asPartNo                   IN       iapiType.PartNo_Type,
      anPartExemptionNo          IN       iapiType.SequenceNr_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SaveExemption(
      asPartNo                   IN       iapiType.PartNo_Type,
      anPartExemptionNo          IN       iapiType.SequenceNr_Type,
      asDescription              IN       iapiType.Description_Type,
      alText                     IN       iapiType.Clob_Type,
      adFromDate                 IN       iapiType.Date_Type,
      adToDate                   IN       iapiType.Date_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiExemption;