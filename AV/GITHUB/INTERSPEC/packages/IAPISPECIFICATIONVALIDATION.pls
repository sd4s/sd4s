create or replace PACKAGE iapiSpecificationValidation
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiSpecificationValidation.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.10 (06.07.00.10-01.00) $
   --  $Modtime: 2017-March-03 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package contains
   --           procedures/functions to check on status changes of a
   --           specification.
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
   gsSource                      iapiType.Source_Type := 'iapiSpecificationValidation';
   gtErrors                      ErrorDataTable_Type := ErrorDataTable_Type( );
   gsPartNo                      iapiType.PartNo_Type;
   gnRevision                    iapiType.Revision_Type;
   gnNextStatus                  iapiType.StatusId_Type;
   gnErrorNo                     iapiType.NumVal_Type;

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION ExecuteValRulesError(
      anCurrentStatus            IN       iapiType.StatusId_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anNextStatus               IN       iapiType.StatusId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExecuteValRulesWarning(
      anCurrentStatus            IN       iapiType.StatusId_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anNextStatus               IN       iapiType.StatusId_Type,
      aqErrors                   OUT      iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateAccessToCurrent
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateAttachedSpecApproved
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateAttachedSpecCurrent
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateBom
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateClassification
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateClearanceNo
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateCurrent
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateHarmonisedBom
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateHistoricObsolete
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateInDevBom
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateLocalised
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateMfg
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateObject
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateObsoleteBom
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateReasonForIssue
      RETURN iapiType.ErrorNum_Type;

   --AP00882254 Start
   --AP00882879 Start
   ---------------------------------------------------------------------------
   FUNCTION ValidateReasonForStatusChange
      RETURN iapiType.ErrorNum_Type;
   --AP00882254 Start
   --AP00882879 Start
   ---------------------------------------------------------------------------
   FUNCTION ValidateReferenceText
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidateUom
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ValidationRules
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
-- ISQF-235 start
   FUNCTION ValidationRulesErrorList
     (anCurrentStatus            IN       iapiType.StatusId_Type,
      anRevision                 IN       iapiType.Revision_Type,
      asPartNo                   IN       iapiType.PartNo_Type,
      anNextStatus               IN       iapiType.StatusId_Type,
      aqErrors                   IN OUT   iapiType.Ref_Type )
      RETURN iapiType.ErrorNum_Type;
-- ISQF-235 end
-- Pragmas
---------------------------------------------------------------------------
END iapiSpecificationValidation;