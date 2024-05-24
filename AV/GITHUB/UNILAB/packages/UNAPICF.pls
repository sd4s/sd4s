create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapicf AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetCustomFunctionList
(a_cf            OUT      UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description   OUT      UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_cf_type       OUT      UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_nr_of_rows    IN OUT   NUMBER,                   /* NUM_TYPE */
 a_where_clause  IN       VARCHAR2,                 /* VC511_TYPE */
 a_next_rows     IN       NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

END unapicf;