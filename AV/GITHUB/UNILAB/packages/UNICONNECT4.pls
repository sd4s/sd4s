create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uniconnect4 AS

FUNCTION GetVersion
RETURN VARCHAR2;

/*------------------------------------------------------*/
/* procedures and functions related to the [ic] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialiseScIcSection;    /* INTERNAL */

FUNCTION UCON_AssignScIcSectionRow       /* INTERNAL */
RETURN NUMBER;

FUNCTION UCON_ExecuteScIcSection         /* INTERNAL */
RETURN NUMBER;

/*------------------------------------------------------*/
/* procedures and functions related to the [ii] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialiseScIiSection;    /* INTERNAL */

FUNCTION UCON_AssignScIiSectionRow       /* INTERNAL */
RETURN NUMBER;

FUNCTION UCON_ExecuteScIiSection         /* INTERNAL */
RETURN NUMBER;


END uniconnect4;