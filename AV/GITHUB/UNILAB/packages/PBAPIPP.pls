create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapipp AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetPpParameterSpecs
(a_pp           OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pr           OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_low_limit    OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_high_limit   OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_low_spec     OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_high_spec    OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_low_dev      OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_rel_low_dev  OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_target       OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_high_dev     OUT     UNAPIGEN.FLOAT_TABLE_TYPE,
 a_rel_high_dev OUT     PBAPIGEN.VC1_TABLE_TYPE,/* CHAR1_TABLE_TYPE */
 a_spec_set     IN     CHAR,
 a_nr_of_rows   IN OUT NUMBER,
 a_where_clause IN     VARCHAR2)
RETURN NUMBER;

FUNCTION GetParameterProfileList
(a_pp                      OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_version                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pp_key1                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pp_key2                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pp_key3                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pp_key4                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_pp_key5                 OUT     UNAPIGEN.VC20_TABLE_TYPE,
 a_description             OUT     UNAPIGEN.VC40_TABLE_TYPE,
 a_ss                      OUT     UNAPIGEN.VC2_TABLE_TYPE,
 a_nr_of_rows              IN OUT  NUMBER,
 a_where_clause            IN      VARCHAR2,
 a_next_rows               IN      NUMBER)
RETURN NUMBER;


END pbapipp;