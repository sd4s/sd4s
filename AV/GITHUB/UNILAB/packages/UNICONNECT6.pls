create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
uniconnect6 AS

FUNCTION GetVersion
RETURN VARCHAR2;

/*--------------------------------------------------------------*/
/* Auxiliary functions for Pg and Pa creation inside UCON       */
/*--------------------------------------------------------------*/
FUNCTION InsertPg             /* INTERNAL */
(a_sc       IN    VARCHAR2,   /* VC20_TYPE */
 a_pg       IN    VARCHAR2,   /* VC20_TYPE */
 a_firstpos IN    BOOLEAN,    /* BOOLEAN_TYPE */
 a_pgnode   OUT   NUMBER)     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION InsertPa             /* INTERNAL */
(a_sc       IN    VARCHAR2,   /* VC20_TYPE */
 a_pg       IN    VARCHAR2,   /* VC20_TYPE */
 a_pgnode   IN    NUMBER,     /* NUM_TYPE */
 a_pa       IN    VARCHAR2,   /* VC20_TYPE */
 a_firstpos IN    BOOLEAN,    /* BOOLEAN_TYPE */
 a_panode   OUT   NUMBER)     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SpecialRulesForValues     /* INTERNAL */
(a_value_s_mod    IN     BOOLEAN,  /* BOOLEAN_TYPE */
 a_value_s        IN OUT VARCHAR2, /* VC40_TYPE */
 a_value_f_mod    IN     BOOLEAN,  /* BOOLEAN_TYPE */
 a_value_f        IN     NUMBER,   /* FLOAT_TYPE */
 a_format         IN     VARCHAR2, /* VC40_TYPE */
 a_alt_value_s    IN OUT VARCHAR2, /* VC40_TYPE */
 a_alt_value_f    IN OUT NUMBER)   /* FLOAT_TYPE */
RETURN NUMBER;

FUNCTION ApplyConversionFactor   /* INTERNAL */
(a_value_s  IN OUT   VARCHAR2,   /* VC40_TYPE */
 a_format   IN       VARCHAR2,   /* VC40_TYPE */
 a_value_f  OUT      NUMBER)     /* NUM_TYPE */
RETURN NUMBER;


END uniconnect6;