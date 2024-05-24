CREATE OR REPLACE PACKAGE AOPA_VALIDATE_SS AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : AOPA_VALIDATE_SS
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 11/03/2011
--   TARGET : Oracle 10.2.0
--  VERSION : 6.3.0    $Revision: 1 $
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 11/03/2011 | RS        | Upgrade V6.3
-- 30-08-2022 | PS        | Add function ValidateTreadlessGreentyre
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION SP_COPY_FRAME_DATA
RETURN iapiType.ErrorNum_Type;

FUNCTION SP_COPY_FRAME_KEYWORDS
RETURN iapiType.ErrorNum_Type;

FUNCTION SP_SUPPLIER_CODE
RETURN iapiType.ErrorNum_Type;

FUNCTION SP_SPEC_REFERENCE
RETURN iapiType.ErrorNum_Type;

FUNCTION SP_SUPPLIER_REF
RETURN iapiType.ErrorNum_Type;

FUNCTION SP_MANUFACTURER_KW
RETURN iapiType.ErrorNum_Type;

FUNCTION SP_STATUS_KW
RETURN iapiType.ErrorNum_Type;

FUNCTION SP_CODING_CONVENTION
RETURN iapiType.ErrorNum_Type;

FUNCTION DeletePriceFromBoMHeader
RETURN iapiType.ErrorNum_Type;

FUNCTION CreateFinalizeJob
RETURN iapiType.ErrorNum_Type;

FUNCTION ExecuteCustomWarnings
RETURN iapiType.ErrorNum_Type;

FUNCTION ExecuteCustomValidations
RETURN iapiType.ErrorNum_Type;

FUNCTION ExecuteCustomCalculations
RETURN iapiType.ErrorNum_Type;

FUNCTION ClearCustomCalculations
RETURN iapiType.ErrorNum_Type;

FUNCTION ValidateSapCode
RETURN iapiType.ErrorNum_Type;

FUNCTION ValidateBasedUpon
RETURN iapiType.ErrorNum_Type;

FUNCTION ValidatePlant
RETURN iapiType.ErrorNum_Type;

FUNCTION ValidateLabelValues
RETURN iapiType.ErrorNum_Type;

FUNCTION ValidateTreadlessGreentyre
RETURN iapiType.ErrorNum_Type ;

END AOPA_VALIDATE_SS;
/
