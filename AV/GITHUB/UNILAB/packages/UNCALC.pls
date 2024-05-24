create or replace PACKAGE
-- Unilab 4.0 Package
-- $Revision: 3 $
-- $Date: 17/04/01 11:17 $
uncalc AS

-- The general rules for cf_type in utcf can be found in the document: customizing the system
-- Minimal information can also be found in the header of the unaction package
--

FUNCTION CalcMethod
(a_sc               IN    VARCHAR2,    /* VC20_TYPE */
 a_pg               IN    VARCHAR2,    /* VC20_TYPE */
 a_pgnode           IN    NUMBER,      /* LONG_TYPE */
 a_pa               IN    VARCHAR2,    /* VC20_TYPE */
 a_panode           IN    NUMBER,      /* LONG_TYPE */
 a_value_f          OUT   FLOAT,       /* FLOAT_TYPE */
 a_value_s          OUT   VARCHAR2)    /* VC40_TYPE */
RETURN NUMBER;

FUNCTION Average
(a_sc               IN    VARCHAR2,    /* VC20_TYPE */
 a_pg               IN    VARCHAR2,    /* VC20_TYPE */
 a_pgnode           IN    NUMBER,      /* LONG_TYPE */
 a_pa               IN    VARCHAR2,    /* VC20_TYPE */
 a_panode           IN    NUMBER,      /* LONG_TYPE */
 a_value_f          OUT   FLOAT,       /* FLOAT_TYPE */
 a_value_s          OUT   VARCHAR2)    /* VC40_TYPE */
RETURN NUMBER;

P_LOG_CALC_ERRORS   BOOLEAN DEFAULT FALSE;

END uncalc;
 