create or replace PACKAGE
-- Unilab 4.0 Package
-- $Revision: 2 $
-- $Date: 25/11/03 12:59 $
              unwlassign AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : UNWLASSIGN
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 25/06/2008
--   TARGET : Oracle 10.2.0
--  VERSION : av2.0
--------------------------------------------------------------------------------
--  REMARKS : The general rules for cf_type in utcf can be found in the
--            document: customizing the system
--            Minimal information can also be found in the header
--            of the unaction package
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 25/06/2008 | RS        | Added MePriority
-- 23/06/2009 | RS        | Added MeAssignGkDefault
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT APAOGEN.API_NAME_TYPE := 'UNWLASSIGN';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION MePriority                         /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

FUNCTION MeStartAndEndDate                  /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

FUNCTION MePreferredExecutors                /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

FUNCTION MeOperational                      /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

FUNCTION MeReleased                         /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

FUNCTION MePlannedEqType                    /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

FUNCTION MeAssignGkDefault                  /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

END unwlassign;
