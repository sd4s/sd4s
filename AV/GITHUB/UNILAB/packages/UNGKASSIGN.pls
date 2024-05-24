create or replace PACKAGE        -- Unilab 4.0 Package
-- $Revision: 2 $
-- $Date: 21/09/04 14:00 $
       ungkassign AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : UNGKASSIGN
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
-- 25/06/2008 | RS        | Added RqAlways
-- 23/06/2016 | JP/JR     | Added AssignRoles 			(ERULG011A)
-- 18/07/2016 | JP/JR     | Added AssignMeGkUserGroup	(ERULG011A)
-- 18/07/2016 | JP/JR     | Added ScPriority, ScDate1-5 (ERULG008C)
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
FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION RqAlways
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

/*-----------------------------------------------*/
/* Custom SampleCode related groupkey assignment */
/*-----------------------------------------------*/
FUNCTION ScDateNumber
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ScSamplingDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

/*-------------------------------------------*/
/* Custom Method related groupkey assignment */
/*-------------------------------------------*/
FUNCTION MeAssignSection
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION MeAssignResponsible
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

/*--------------------------------------------*/
/* Custom request related groupkey assignment */
/*--------------------------------------------*/
FUNCTION RqDayNumber
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION RqWebUser
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

/*----------------------------------------------*/
/* Custom worksheet related groupkey assignment */
/*----------------------------------------------*/
FUNCTION WsCreationDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

/*--------*/
/* u4easy */
/*--------*/

FUNCTION MeDepartment
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ScOperational
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ScReleased
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ScDepartment
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ScValidation
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION RqOperational
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

/*-----------------------------------------------*/
/* Easy QC                                       */
/* cf_type = scgkcreate in utcf                  */
/*-----------------------------------------------*/
FUNCTION ScMonthCreationDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ScWeekCreationDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ScYearCreationDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ScDayCreationDate
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

/*-----------------------------------------------*/
/* Easy QC                                       */
/* cf_type = megkcreate in utcf                  */
/*-----------------------------------------------*/

FUNCTION MeAssignWorkday
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

/*-----------------------------------------------*/
/* Easy QC                                       */
/* cf_type = sdgkcreate in utcf                  */
/*-----------------------------------------------*/
FUNCTION SdAssignScGroupKeys
RETURN NUMBER;

FUNCTION ScCreateCnGroupKeys
RETURN NUMBER;

FUNCTION AssignRoles
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION AssignMeGkUserGroup
(a_gk   IN     VARCHAR2)                                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION ScPriority                         /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

FUNCTION ScDate1                            /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

FUNCTION ScDate2                            /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

FUNCTION ScDate3                            /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

FUNCTION ScDate4                            /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;

FUNCTION ScDate5                            /* INTERNAL */
(a_ss_to           IN VARCHAR2)             /* VC2_TYPE */
RETURN NUMBER;



END ungkassign;