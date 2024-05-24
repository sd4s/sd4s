create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapius AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetUpUsExperienceLevel
(a_up               OUT      UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_us               OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_el               OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_is_enabled       OUT      PBAPIGEN.VC1_TABLE_TYPE,  /* VC1_TABLE_TYPE */
 a_nr_of_rows       IN OUT   NUMBER,                     /* NUM_TYPE         */
 a_where_clause     IN       VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveUpUsExperienceLevel
(a_up                      IN       NUMBER,                      /* LONG_TYPE        */
 a_us                      IN       VARCHAR2,                    /* VC20_TYPE        */
 a_el                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_is_enabled              IN       PBAPIGEN.VC1_TABLE_TYPE,   /* VC1_TABLE_TYPE */
 a_nr_of_rows              IN       NUMBER,                      /* NUM_TYPE         */
 a_modify_reason           IN       VARCHAR2)                    /* VC255_TYPE       */
RETURN NUMBER;

END pbapius;