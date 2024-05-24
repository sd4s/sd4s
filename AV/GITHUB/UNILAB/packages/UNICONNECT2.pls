create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uniconnect2 AS

FUNCTION GetVersion
RETURN VARCHAR2;

/*------------------------------------------------------*/
/* procedures and functions related to the [sc] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialiseScSection;    /* INTERNAL */

FUNCTION UCON_AssignScSectionRow       /* INTERNAL */
RETURN NUMBER;

FUNCTION UCON_ExecuteScSection         /* INTERNAL */
RETURN NUMBER;

/*------------------------------------------------------*/
/* procedures and functions related to the [pg] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialisePgSection;    /* INTERNAL */

FUNCTION UCON_AssignPgSectionRow       /* INTERNAL */
RETURN NUMBER;

FUNCTION FindScPg (a_sc          IN     VARCHAR2,
                   a_pg          IN OUT VARCHAR2,
                   a_description IN     VARCHAR2,
                   a_pgnode      IN     NUMBER,
                   a_pp_key1     IN     VARCHAR2,
                   a_pp_key2     IN     VARCHAR2,
                   a_pp_key3     IN     VARCHAR2,
                   a_pp_key4     IN     VARCHAR2,
                   a_pp_key5     IN     VARCHAR2,
                   a_pp_version  IN     VARCHAR2,
                   a_search_base IN     VARCHAR2,
                   a_pos         IN INTEGER,
                   a_current_row IN INTEGER)
RETURN utscpg%ROWTYPE;

FUNCTION UCON_ExecutePgSection         /* INTERNAL */
RETURN NUMBER;

/*------------------------------------------------------*/
/* procedures and functions related to the [pa] section */
/*------------------------------------------------------*/
PROCEDURE UCON_InitialisePaSection;    /* INTERNAL */

FUNCTION UCON_AssignPaSectionRow       /* INTERNAL */
RETURN NUMBER;

FUNCTION FindScPa (a_sc          IN     VARCHAR2,
                   a_pg          IN     VARCHAR2,
                   a_pgnode      IN     NUMBER,
                   a_pp_key1     IN     VARCHAR2,
                   a_pp_key2     IN     VARCHAR2,
                   a_pp_key3     IN     VARCHAR2,
                   a_pp_key4     IN     VARCHAR2,
                   a_pp_key5     IN     VARCHAR2,
                   a_pp_version  IN     VARCHAR2,
                   a_pa          IN OUT VARCHAR2,
                   a_description IN     VARCHAR2,
                   a_panode      IN     NUMBER,
                   a_pr_version  IN     VARCHAR2,
                   a_search_base IN     VARCHAR2,
                   a_pos         IN INTEGER,
                   a_current_row IN INTEGER)
RETURN utscpa%ROWTYPE;

FUNCTION UCON_ExecutePaSection         /* INTERNAL */
RETURN NUMBER;

PROCEDURE WriteGlobalVariablesToLog;

END uniconnect2;