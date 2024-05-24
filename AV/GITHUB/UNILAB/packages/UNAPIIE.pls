create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiie AS

/* Info profile cursor ID */
P_IE_CURSOR            INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetInfoFieldList
(a_ie                   OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version              OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version_is_current   OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_effective_from       OUT  UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_effective_till       OUT  UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_description          OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_tp               OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_ss                   OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER,                  /* NUM_TYPE */
 a_where_clause         IN   VARCHAR2,                   /* VC511_TYPE */
 a_next_rows            IN   NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetInfoField
(a_ie                   OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version              OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version_is_current   OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_effective_from       OUT  UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_effective_till       OUT  UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_is_protected         OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_mandatory            OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_hidden               OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_data_tp              OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_format               OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_valid_cf             OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_def_val_tp           OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_def_au_level         OUT  UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_ievalue              OUT  UNAPIGEN.VC2000_TABLE_TYPE, /* VC2000_TABLE_TYPE */
 a_align                OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_title            OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_title2           OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_len              OUT  UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_dsp_tp               OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_rows             OUT  UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_look_up_ptr          OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_is_template          OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_multi_select         OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_sc_lc                OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_sc_lc_version        OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_inherit_au           OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_ie_class             OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs               OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_modify         OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_active               OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_lc                   OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_lc_version           OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ss                   OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER,                  /* NUM_TYPE */
 a_where_clause         IN   VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetInfoFieldSpin
(a_ie              OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version         OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_circular        OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_incr            OUT  UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_low_val_tp      OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_low_au_level    OUT  UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_low_val         OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_high_val_tp     OUT  UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_high_au_level   OUT  UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_high_val        OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                  /* NUM_TYPE */
 a_where_clause    IN  VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetInfoFieldSql
(a_ie            OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version       OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sqltext       OUT   UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows    IN OUT   NUMBER,                 /* NUM_TYPE */
 a_where_clause  IN   VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetInfoFieldValue
(a_ie              OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version         OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value           OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows      IN OUT   NUMBER,                 /* NUM_TYPE */
 a_where_clause    IN   VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION DeleteInfoField
(a_ie             IN   VARCHAR2,                   /* VC20_TYPE */
 a_version        IN   VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason  IN   VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveInfoField
(a_ie                   IN   VARCHAR2,                   /* VC20_TYPE */
 a_version              IN   VARCHAR2,                   /* VC20_TYPE */
 a_version_is_current   IN   CHAR,                       /* CHAR1_TYPE */
 a_effective_from       IN   DATE,                       /* DATE_TYPE */
 a_effective_till       IN   DATE,                       /* DATE_TYPE */
 a_is_protected         IN   CHAR,                       /* CHAR1_TYPE */
 a_mandatory            IN   CHAR,                       /* CHAR1_TYPE */
 a_hidden               IN   CHAR,                       /* CHAR1_TYPE */
 a_data_tp              IN   CHAR,                       /* CHAR1_TYPE */
 a_format               IN   VARCHAR2,                   /* VC40_TYPE */
 a_valid_cf             IN   VARCHAR2,                   /* VC20_TYPE */
 a_def_val_tp           IN   CHAR,                       /* CHAR1_TYPE */
 a_def_au_level         IN   VARCHAR2,                   /* VC4_TYPE */
 a_ievalue              IN   VARCHAR2,                   /* VC2000_TYPE */
 a_align                IN   CHAR,                       /* CHAR1_TYPE */
 a_dsp_title            IN   VARCHAR2,                   /* VC40_TYPE */
 a_dsp_title2           IN   VARCHAR2,                   /* VC40_TYPE */
 a_dsp_len              IN   NUMBER,                     /* NUM_TYPE */
 a_dsp_tp               IN   CHAR,                       /* CHAR1_TYPE */
 a_dsp_rows             IN   NUMBER,                     /* NUM_TYPE */
 a_look_up_ptr          IN   VARCHAR2,                   /* VC40_TYPE */
 a_is_template          IN   CHAR,                       /* CHAR1_TYPE */
 a_multi_select         IN   CHAR,                       /* CHAR1_TYPE */
 a_sc_lc                IN   VARCHAR2,                   /* VC2_TYPE */
 a_sc_lc_version        IN   VARCHAR2,                   /* VC20_TYPE */
 a_inherit_au           IN   CHAR,                       /* CHAR1_TYPE */
 a_ie_class             IN   VARCHAR2,                   /* VC2_TYPE */
 a_log_hs               IN   CHAR,                       /* CHAR1_TYPE */
 a_lc                   IN   VARCHAR2,                   /* VC2_TYPE */
 a_lc_version           IN   VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason        IN   VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveInfoFieldSpin
(a_ie               IN   VARCHAR2,                   /* VC20_TYPE */
 a_version          IN   VARCHAR2,                   /* VC20_TYPE */
 a_circular         IN   CHAR,                       /* CHAR1_TYPE */
 a_incr             IN   NUMBER,                     /* NUM_TYPE */
 a_low_val_tp       IN   CHAR,                       /* CHAR1_TYPE */
 a_low_au_level     IN   VARCHAR2,                   /* VC4_TYPE */
 a_low_val          IN   VARCHAR2,                   /* VC40_TYPE */
 a_high_val_tp      IN   CHAR,                       /* CHAR1_TYPE */
 a_high_au_level    IN   VARCHAR2,                   /* VC4_TYPE */
 a_high_val         IN   VARCHAR2,                   /* VC40_TYPE */
 a_modify_reason    IN   VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveInfoFieldSql
(a_ie               IN   VARCHAR2,                   /* VC20_TYPE */
 a_version          IN   VARCHAR2,                   /* VC20_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                     /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveInfoFieldValue
(a_ie               IN   VARCHAR2,                   /* VC20_TYPE */
 a_version          IN   VARCHAR2,                   /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                     /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

END unapiie;