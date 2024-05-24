CREATE OR REPLACE PACKAGE "UNILAB"."APAOFEA" AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAOFEA
-- ABSTRACT :
--   WRITER : Jan Roubos
--     DATE : 11/06/2015
--   TARGET : -
--  VERSION : -
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 11/06/2015 | JR        | Created
--            |           |
---------------------------------------------------------------------------------------------------------------------

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
FUNCTION ExecuteMeshing
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ExecuteMeshing (avsSc IN VARCHAR2, avsMe IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

END APAOFEA;
/
  GRANT EXECUTE ON "UNILAB"."APAOFEA" TO "URAPI";