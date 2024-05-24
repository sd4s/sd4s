create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uniconnect7 AS

FUNCTION GetVersion
RETURN VARCHAR2;

/*--------------------------------------------------------------*/
/* procedures and functions related to the [switchuser] section */
/*--------------------------------------------------------------*/
PROCEDURE UCON_InitialiseSwitchUsSection;    /* INTERNAL */

FUNCTION UCON_AssignSwitchUsSectionRow       /* INTERNAL */
RETURN NUMBER;

FUNCTION UCON_ExecuteSwitchUsSection         /* INTERNAL */
RETURN NUMBER;

FUNCTION UCON_RestoreJobUserContext          /* INTERNAL */
RETURN NUMBER;

FUNCTION UCON_CheckElecSignature             /* INTERNAL */
(a_ss_to       IN VARCHAR2) /*VC2_TYPE*/
RETURN NUMBER;

FUNCTION UCON_ExecuteResetGlobSection         /* INTERNAL */
RETURN NUMBER;

END uniconnect7;