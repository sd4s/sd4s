create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapievp AS

DEBUG_SQC_RULES      BOOLEAN DEFAULT FALSE;
SQC_RULES_LOADED     BOOLEAN DEFAULT FALSE;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION EvalAlarmHandling                          /* INTERNAL */
(a_alarms_handled   IN    CHAR,                     /* CHAR1_TYPE */
 a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_valid_specsa     OUT   CHAR,                     /* CHAR1_TYPE */
 a_valid_specsb     OUT   CHAR,                     /* CHAR1_TYPE */
 a_valid_specsc     OUT   CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsa    OUT   CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsb    OUT   CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsc    OUT   CHAR,                     /* CHAR1_TYPE */
 a_valid_targeta    OUT   CHAR,                     /* CHAR1_TYPE */
 a_valid_targetb    OUT   CHAR,                     /* CHAR1_TYPE */
 a_valid_targetc    OUT   CHAR)                     /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION CheckSQCRules                     /* INTERNAL */
(a_sc                      IN  VARCHAR2,   /* VC20_TYPE */
 a_pg                      IN  VARCHAR2,   /* VC20_TYPE */
 a_pgnode                  IN  NUMBER,     /* LONG_TYPE */
 a_pa                      IN  VARCHAR2,   /* VC20_TYPE */
 a_panode                  IN  NUMBER,     /* LONG_TYPE */
 a_value_f                 IN  NUMBER,     /* FLOAT_TYPE */
 a_valid_sqc               OUT CHAR)       /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION InheritNewSpecs                                 /* INTERNAL */
(a_sc                     IN      VARCHAR2,              /* VC20_TYPE */
 a_modified               IN      VARCHAR2,              /* VC20_TYPE */
 a_new_inherit_from_pp    IN      VARCHAR2)              /* VC20_TYPE */
RETURN NUMBER;

FUNCTION SaveScPaTextResult                    /* INTERNAL */
(a_sc               IN   VARCHAR2,             /* VC20_TYPE */
 a_pg               IN   VARCHAR2,             /* VC20_TYPE */
 a_pgnode           IN   NUMBER,               /* LONG_TYPE */
 a_pa               IN   VARCHAR2,             /* VC20_TYPE */
 a_panode           IN   NUMBER,               /* LONG_TYPE */
 a_value_f          IN   FLOAT,                /* FLOAT_TYPE */
 a_value_s          IN   VARCHAR2,             /* VC40_TYPE */
 a_unit             IN   VARCHAR2,             /* VC20_TYPE */
 a_exec_end_date    IN   DATE,                 /* DATE_TYPE */
 a_executor         IN   VARCHAR2,             /* VC20_TYPE */
 a_manually_entered IN   CHAR)                 /* CHAR1_TYPE */
RETURN NUMBER;

END unapievp;