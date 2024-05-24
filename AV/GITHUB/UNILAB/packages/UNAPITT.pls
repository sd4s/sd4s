create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapitt AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetTitleFormat
(a_window          OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_title_format    OUT    UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows     IN OUT  NUMBER,                      /* NUM_TYPE */
 a_where_clause    IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER ;


FUNCTION SaveTitleFormat
(a_window          IN       UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_title_format    IN       UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN       NUMBER)                     /* NUM_TYPE */
RETURN NUMBER ;

END unapitt;