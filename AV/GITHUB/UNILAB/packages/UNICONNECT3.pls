create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uniconnect3 AS

FUNCTION GetVersion
RETURN VARCHAR2;

/*------------------------------------------------------*/
/* procedures and functions related to the [me] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialiseMeSection;    /* INTERNAL */

FUNCTION UCON_AssignMeSectionRow       /* INTERNAL */
RETURN NUMBER;

FUNCTION UCON_ExecuteMeSection         /* INTERNAL */
RETURN NUMBER;

/*--------------------------------------------------------*/
/* procedures and functions related to the [cell] section */
/*--------------------------------------------------------*/
PROCEDURE UCON_InitialiseMeCellSection;    /* INTERNAL */

FUNCTION UCON_AssignMeCellSectionRow       /* INTERNAL */
RETURN NUMBER;

FUNCTION UCON_ExecuteMeCellSection         /* INTERNAL */
RETURN NUMBER;

/*--------------------------------------------------------------*/
/* procedures and functions related to the [cell table] section */
/*--------------------------------------------------------------*/
PROCEDURE UCON_InitialiseMeCeTabSection;    /* INTERNAL */

FUNCTION UCON_AssignMeCeTabSectionRow       /* INTERNAL */
RETURN NUMBER;

FUNCTION UCON_ExecuteMeCeTabSection         /* INTERNAL */
RETURN NUMBER;


END uniconnect3;