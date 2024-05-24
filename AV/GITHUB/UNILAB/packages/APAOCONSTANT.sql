CREATE OR REPLACE PACKAGE APAOCONSTANT AS
PRAGMA RESTRICT_REFERENCES (APAOCONSTANT, WNDS, WNPS);
--------------------------------------------------------------------------------
-- PROJECT : ATOS ORIGIN
-------------------------------------------------------------------------------
-- PACKAGE : APAOCONSTANT
--ABSTRACT : Package with functions to retrieve constants
--           from table ATAOCONSTANT
--------------------------------------------------------------------------------
--   WRITER : ATOS ORIGIN
--     DATE :
--   TARGET : Oracle 9.2.0
--  VERSION : 6.1
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
-- CHANGES :
--
-- When        | Who       | What
-- ============|===========|====================================================
--             |           |
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
TYPE CONSTANT_TYPE IS RECORD (value_f ATAOCONSTANT.value_f%TYPE, value_s ATAOCONSTANT.value_s%TYPE);

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

--------------------------------------------------------------------------------
-- FUNCTION : GetConstNumber
-- ABSTRACT : Function to retrieve a numeric value as constant
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 9.2.0
--  VERSION :
--------------------------------------------------------------------------------
--            Argument(s)             | Description
-- ===================================|=========================================
--           avs_constant IN VARCHAR2 | Name of constant to retrieve
--
--------------------------------------------------------------------------------
--            Errorcode (return value)| Description
-- ===================================|=========================================
--   ERRORS :                  NULL   | No data found or field was empty
--                                    | (when no data found application error
--                                    |  is triggered)
--                  Any numeric value | The value found in column value_f from
--                                    | table ATAOCONSTANT
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION GetConstNumber (avs_constant IN VARCHAR2)
RETURN NUMBER ;
--PRAGMA RESTRICT_REFERENCES (GetConstNumber, WNDS, WNPS);

--------------------------------------------------------------------------------
-- FUNCTION : GetConstString
-- ABSTRACT : Function to retrieve a string value as constant
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 9.2.0
--  VERSION :
--------------------------------------------------------------------------------
--            Argument(s)             | Description
-- ===================================|=========================================
--           avs_constant IN VARCHAR2 | Name of constant to retrieve
--
--------------------------------------------------------------------------------
--            Errorcode (return value)| Description
-- ===================================|=========================================
--   ERRORS :                  NULL   | No data found or field was empty
--                                    | (when no data found application error
--                                    |  is triggered)
--                   Any string value | The value found in column value_s from
--                                    | table ATAOCONSTANT
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION GetConstString (avs_constant IN VARCHAR2)
RETURN VARCHAR2 ;
--PRAGMA RESTRICT_REFERENCES (GetConstString, WNDS, WNPS);

--------------------------------------------------------------------------------
-- FUNCTION : GetConstant
-- ABSTRACT : Function to retrieve a constant
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 9.2.0
--  VERSION :
--------------------------------------------------------------------------------
--            Argument(s)             | Description
-- ===================================|=========================================
--           avs_constant IN VARCHAR2 | Name of constant to retrieve
--
--------------------------------------------------------------------------------
--            Errorcode (return value)| Description
-- ===================================|=========================================
--   ERRORS :                  NULL   | No data found or field was empty
--                                    | (when no data found application error
--                                    |  is triggered)
--                  A constant-record | The value found in column value_s, value_f
--                                    | from table ATAOCONSTANT
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION GetConstant (avs_constant IN VARCHAR2)
RETURN CONSTANT_TYPE;
--PRAGMA RESTRICT_REFERENCES (GetConstant, WNDS, WNPS);

END APAOCONSTANT;

/


CREATE OR REPLACE PACKAGE BODY APAOCONSTANT AS
--------------------------------------------------------------------------------
-- PROJECT  : ATOS ORIGIN
-------------------------------------------------------------------------------
-- PACKAGE  : APAOCONSTANT
-- ABSTRACT : Package with functions to retrieve constants
--            from table ATAOCONSTANT
--------------------------------------------------------------------------------
--   WRITER : ATOS ORIGIN
--     DATE :
--   TARGET : Oracle 9.2.0
--  VERSION : 6.1
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
-- CHANGES :
--
-- When        | Who       | What
-- ============|===========|====================================================
--             |           |
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name CONSTANT APAOGEN.API_NAME_TYPE := 'APAOCONSTANT';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- FUNCTION : GetConstNumber
-- ABSTRACT : Function to retrieve a numeric value as constant
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 9.2.0
--  VERSION :
--------------------------------------------------------------------------------
--            Argument(s)             | Description
-- ===================================|=========================================
--           avs_constant IN VARCHAR2 | Name of constant to retrieve
--
--------------------------------------------------------------------------------
--            Errorcode (return value)| Description
-- ===================================|=========================================
--   ERRORS :                  NULL   | No data found or field was empty
--                                    | (when no data found application error
--                                    |  is triggered)
--                  Any numeric value | The value found in column value_f from
--                                    | table ATAOCONSTANT
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION GetConstNumber (avs_constant IN VARCHAR2)
RETURN NUMBER IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'GetConstNumber';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm          APAOGEN.ERROR_MSG_TYPE;
lvn_constant_value   ATAOCONSTANT.value_f%TYPE ;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   lvn_constant_value := NULL ;
   SELECT value_f
     INTO lvn_constant_value
     FROM ATAOCONSTANT
    WHERE constant_name = avs_constant ;
   RETURN lvn_constant_value ;
EXCEPTION
WHEN NO_DATA_FOUND THEN
   RAISE_APPLICATION_ERROR(-20000, 'constant <'|| avs_constant || '> not defined' ) ;
   RETURN lvn_constant_value ;
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20000, 'error locating constant <'|| avs_constant || '>' ) ;
   RETURN lvn_constant_value ;
END GetConstNumber;

--------------------------------------------------------------------------------
-- FUNCTION : GetConstString
-- ABSTRACT : Function to retrieve a string value as constant
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 9.2.0
--  VERSION :
--------------------------------------------------------------------------------
--            Argument(s)             | Description
-- ===================================|=========================================
--           avs_constant IN VARCHAR2 | Name of constant to retrieve
--
--------------------------------------------------------------------------------
--            Errorcode (return value)| Description
-- ===================================|=========================================
--   ERRORS :                  NULL   | No data found or field was empty
--                                    | (when no data found application error
--                                    |  is triggered)
--                   Any string value | The value found in column value_s from
--                                    | table ATAOCONSTANT
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION GetConstString (avs_constant IN VARCHAR2)
RETURN VARCHAR2 IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'GetConstString';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm          APAOGEN.ERROR_MSG_TYPE;
lvs_constant_value   ATAOCONSTANT.value_s%TYPE ;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   lvs_constant_value := NULL ;
   SELECT value_s
     INTO lvs_constant_value
     FROM ATAOCONSTANT
    WHERE constant_name = avs_constant ;
   RETURN lvs_constant_value ;
EXCEPTION
WHEN NO_DATA_FOUND THEN
   RAISE_APPLICATION_ERROR(-20000, 'constant <'|| avs_constant || '> not defined' ) ;
   RETURN lvs_constant_value ;
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20000, 'error locating constant <'|| avs_constant || '>' ) ;
   RETURN lvs_constant_value ;
END GetConstString;

--------------------------------------------------------------------------------
-- FUNCTION : GetConstant
-- ABSTRACT : Function to retrieve a constant
--------------------------------------------------------------------------------
--   WRITER :
-- REVIEWER :
--     DATE :
--   TARGET : Oracle 9.2.0
--  VERSION :
--------------------------------------------------------------------------------
--            Argument(s)             | Description
-- ===================================|=========================================
--           avs_constant IN VARCHAR2 | Name of constant to retrieve
--
--------------------------------------------------------------------------------
--            Errorcode (return value)| Description
-- ===================================|=========================================
--   ERRORS :                  NULL   | No data found or field was empty
--                                    | (when no data found application error
--                                    |  is triggered)
--                  A constant-record | The value found in column value_s, value_f
--                                    | from table ATAOCONSTANT
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
--            |           |
--------------------------------------------------------------------------------
FUNCTION GetConstant (avs_constant IN VARCHAR2)
RETURN CONSTANT_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'GetConstant';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm APAOGEN.ERROR_MSG_TYPE;
lvr_constant        CONSTANT_TYPE;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   lvr_constant.value_s := NULL ;
   lvr_constant.value_f := NULL ;
   SELECT value_s, value_f
     INTO lvr_constant.value_s, lvr_constant.value_f
     FROM ATAOCONSTANT
    WHERE constant_name = avs_constant ;
   RETURN lvr_constant ;
EXCEPTION
WHEN NO_DATA_FOUND THEN
   RAISE_APPLICATION_ERROR(-20000, 'constant <'|| avs_constant || '> not defined' ) ;
   RETURN lvr_constant ;
WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20000, 'error locating constant <'|| avs_constant || '>' ) ;
   RETURN lvr_constant ;
END GetConstant;

--------------------------------------------------------------------------------
-- package initialization-code
--------------------------------------------------------------------------------

END APAOCONSTANT;
/
