create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapime5 AS

CELLOUTPUT_NODE_INTERVAL CONSTANT INTEGER := 1000;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION HandleScMeCellOutput                        /* INTERNAL */
(a_sc             IN     VARCHAR2,                   /* VC20_TYPE */
 a_pg             IN     VARCHAR2,                   /* VC20_TYPE */
 a_pgnode         IN     NUMBER,                     /* LONG_TYPE */
 a_pa             IN     VARCHAR2,                   /* VC20_TYPE */
 a_panode         IN     NUMBER,                     /* LONG_TYPE */
 a_me             IN     VARCHAR2,                   /* VC20_TYPE */
 a_menode         IN     NUMBER,                     /* LONG_TYPE */
 a_reanalysis     IN     NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

END unapime5;