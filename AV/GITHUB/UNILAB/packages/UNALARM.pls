create or replace PACKAGE
-- Unilab 4.0 Package
-- $Revision: 2 $
-- $Date: 17/04/01 11:17 $
unalarm AS

-- The general rules for cf_type in utcf can be found in the document: customizing the system
-- Minimal information can also be found in the header of the unaction package
--
FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION EvalAlarm
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_valid_specsa     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsb     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsc     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsa    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsc    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targeta    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetc    IN    CHAR)                     /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION AddMicroPP
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_valid_specsa     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsb     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsc     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsa    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsc    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targeta    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetc    IN    CHAR)                     /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION AddExtraParameters
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_valid_specsa     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsb     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsc     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsa    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsc    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targeta    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetc    IN    CHAR)                     /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION AddOtherParameters
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_valid_specsa     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsb     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_specsc     IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsa    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_limitsc    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targeta    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetb    IN    CHAR,                     /* CHAR1_TYPE */
 a_valid_targetc    IN    CHAR)                     /* CHAR1_TYPE */
RETURN NUMBER;

END unalarm;
