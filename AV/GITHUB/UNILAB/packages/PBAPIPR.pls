create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapipr AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetParameterList
(a_pr                  OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version             OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current  OUT      PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_effective_from      OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till      OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_description         OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_ss                  OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN       VARCHAR2,                  /* VC511_TYPE */
 a_next_rows           IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetPrMethod
(a_pr                  OUT    UNAPIGEN.VC20_TABLE_TYPE,
 a_mt                  OUT    UNAPIGEN.VC20_TABLE_TYPE,
 a_description         OUT    UNAPIGEN.VC40_TABLE_TYPE,
 a_nr_measur           OUT    UNAPIGEN.NUM_TABLE_TYPE,
 a_unit                OUT    UNAPIGEN.VC20_TABLE_TYPE,
 a_format              OUT    UNAPIGEN.VC40_TABLE_TYPE,
 a_allow_add           OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_ignore_other        OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_accuracy            OUT    UNAPIGEN.FLOAT_TABLE_TYPE,
 a_freq_tp             OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_freq_val            OUT    UNAPIGEN.NUM_TABLE_TYPE,
 a_freq_unit           OUT    UNAPIGEN.VC20_TABLE_TYPE,
 a_invert_freq         OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_st_based_freq       OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_last_sched          OUT    UNAPIGEN.DATE_TABLE_TYPE,
 a_last_cnt            OUT    UNAPIGEN.NUM_TABLE_TYPE,
 a_last_val            OUT    UNAPIGEN.VC40_TABLE_TYPE,
 a_inherit_au          OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_nr_of_rows          IN OUT NUMBER,
 a_where_clause        IN     VARCHAR2)
RETURN NUMBER;
END pbapipr;