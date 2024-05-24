create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uniconnect5 AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION SaveScMeCellTable
(a_sc             IN     VARCHAR2,                  /* VC20_TYPE */
 a_pg             IN     VARCHAR2,                  /* VC20_TYPE */
 a_pgnode         IN     NUMBER,                    /* LONG_TYPE */
 a_pa             IN     VARCHAR2,                  /* VC20_TYPE */
 a_panode         IN     NUMBER,                    /* LONG_TYPE */
 a_me             IN     VARCHAR2,                  /* VC20_TYPE */
 a_menode         IN     NUMBER,                    /* LONG_TYPE */
 a_reanalysis     IN     NUMBER,                    /* NUM_TYPE */
 a_cell           IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_index_x        IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_index_y        IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_value_f        IN     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s        IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_selected       IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_modify_flag    IN OUT UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows     IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;


END uniconnect5;