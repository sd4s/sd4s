create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiie AS

/* Info profile cursor ID */
P_IE_CURSOR            INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetInfoFieldList
(a_ie               OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description      OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_tp           OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_ss               OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                  /* NUM_TYPE */
 a_where_clause     IN   VARCHAR2,                   /* VC511_TYPE */
 a_next_rows        IN   NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetInfoField
(a_ie               OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_is_protected     OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_hidden           OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_data_tp          OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_format           OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_valid_cf         OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_def_val_tp       OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_def_au_level     OUT  UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_ievalue          OUT  UNAPIGEN.VC2000_TABLE_TYPE, /* VC2000_TABLE_TYPE */
 a_align            OUT  UNAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_dsp_title        OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_title2       OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_len          OUT  UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_dsp_tp           OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_dsp_rows         OUT  UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_look_up_ptr      OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_is_template      OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_multi_select     OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_sc_lc            OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_inherit_au       OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_ie_class         OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs           OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify     OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active           OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc               OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_ss               OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                  /* NUM_TYPE */
 a_where_clause     IN   VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetInfoFieldSpin
(a_ie              OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_circular        OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_incr            OUT  UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_low_val_tp      OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_low_au_level    OUT  UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_low_val         OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_high_val_tp     OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_high_au_level   OUT  UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_high_val        OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                  /* NUM_TYPE */
 a_where_clause    IN  VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

END pbapiie;