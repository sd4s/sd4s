create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapilu AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetLookUp
(a_lu                  OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE  */
 a_string_val          OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE  */
 a_num_val             OUT      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_shortcut            OUT      UNAPIGEN.RAW8_TABLE_TYPE,  /* RAW8_TABLE_TYPE  */
 a_nr_of_rows          IN OUT   NUMBER,                    /* NUM_TYPE         */
 a_where_clause        IN       VARCHAR2,                  /* VC511_TYPE       */
 a_next_rows           IN       NUMBER)                    /* NUM_TYPE         */
RETURN NUMBER;

-- C++ working with OO4O has difficulties to handle RAW-values => RAW becomes VARCHAR2.
FUNCTION GetLookUp
(a_lu                  OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE  */
 a_string_val          OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE  */
 a_num_val             OUT      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_alt                 OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ctrl                OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_shift               OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_key_name            OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER,                    /* NUM_TYPE         */
 a_where_clause        IN       VARCHAR2,                  /* VC511_TYPE       */
 a_next_rows           IN       NUMBER)                    /* NUM_TYPE         */
RETURN NUMBER;

FUNCTION SaveLookUp
(a_lu                  IN       VARCHAR2,                  /* VC20_TYPE        */
 a_string_val          IN       UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE  */
 a_num_val             IN       UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_shortcut            IN       UNAPIGEN.RAW8_TABLE_TYPE,  /* RAW8_TABLE_TYPE  */
 a_nr_of_rows          IN       NUMBER,                    /* NUM_TYPE         */
 a_next_rows           IN       NUMBER)                    /* NUM_TYPE         */
RETURN NUMBER;

-- C++ working with OO4O has difficulties to handle RAW-values => RAW becomes VARCHAR2.
FUNCTION SaveLookUp
(a_lu                  IN       VARCHAR2,                  /* VC20_TYPE        */
 a_string_val          IN       UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE  */
 a_num_val             IN       UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_alt                 IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ctrl                IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_shift               IN       UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_key_name            IN       UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN       NUMBER,                    /* NUM_TYPE         */
 a_next_rows           IN       NUMBER)                    /* NUM_TYPE         */
RETURN NUMBER;

END unapilu;