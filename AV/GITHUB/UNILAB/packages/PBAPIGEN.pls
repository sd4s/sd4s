create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapigen AS

TYPE VC1_TABLE_TYPE   IS TABLE OF VARCHAR2(1)        INDEX BY BINARY_INTEGER;
TYPE VC2_TABLE_TYPE   IS TABLE OF VARCHAR2(2)        INDEX BY BINARY_INTEGER;
TYPE VC3_TABLE_TYPE   IS TABLE OF VARCHAR2(3)        INDEX BY BINARY_INTEGER;
TYPE VC4_TABLE_TYPE   IS TABLE OF VARCHAR2(4)        INDEX BY BINARY_INTEGER;
TYPE VC8_TABLE_TYPE   IS TABLE OF VARCHAR2(8)        INDEX BY BINARY_INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetShortCutKey
(a_shortcut            OUT       PBAPIGEN.VC8_TABLE_TYPE,       /* RAW8_TABLE_TYPE */
 a_key_tp              OUT       UNAPIGEN.VC2_TABLE_TYPE,        /* VC2_TABLE_TYPE */
 a_value_s             OUT       UNAPIGEN.VC40_TABLE_TYPE,       /* VC40_TABLE_TYPE */
 a_value_f             OUT       UNAPIGEN.FLOAT_TABLE_TYPE,        /* NUM_TABLE_TYPE + INDICATOR */
 a_store_db            OUT       PBAPIGEN.VC1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_run_mode            OUT       PBAPIGEN.VC1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_service             OUT       UNAPIGEN.VC255_TABLE_TYPE,      /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN OUT    NUMBER)                /* NUM_TYPE */
RETURN NUMBER;

FUNCTION AddObjectComment
(a_object_tp          IN       VARCHAR2, /* VC4_TYPE */
 a_object_id          IN       VARCHAR2, /* VC20_TYPE */
 a_comment            IN       VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

END pbapigen;