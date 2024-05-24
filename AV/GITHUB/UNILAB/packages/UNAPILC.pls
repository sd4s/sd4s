create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapilc AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetStatusList
(a_ss                  OUT    UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_name                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description         OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_color               OUT    UNAPIGEN.RAW8_TABLE_TYPE, /* RAW8_TABLE_TYPE */
 a_nr_of_rows          IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause        IN     VARCHAR2,                 /* VC511_TYPE */
 a_next_rows           IN     NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

-- C++ working with OO4O has difficulties to handle RAW-values => RAW becomes VARCHAR2 or NUMBER.
FUNCTION GetStatusList
(a_ss                  OUT    UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_name                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description         OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_R                   OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_G                   OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_B                   OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_nr_of_rows          IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause        IN     VARCHAR2,                 /* VC511_TYPE */
 a_next_rows           IN     NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetStatus
(a_ss            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_name          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description   OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_color         OUT     UNAPIGEN.RAW8_TABLE_TYPE,  /* RAW8_TABLE_TYPE */
 a_shortcut      OUT     UNAPIGEN.RAW8_TABLE_TYPE,  /* RAW8_TABLE_TYPE */
 a_allow_modify  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ss_class      OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows    IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause  IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

-- C++ working with OO4O has difficulties to handle RAW-values => RAW becomes VARCHAR2 or NUMBER.
FUNCTION GetStatus
(a_ss            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_name          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description   OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_R             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_G             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_B             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_alt           OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ctrl          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_shift         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_key_name      OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_allow_modify  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ss_class      OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows    IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause  IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveStatus
(a_ss            IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_name          IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description   IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_color         IN     UNAPIGEN.RAW8_TABLE_TYPE,  /* RAW8_TABLE_TYPE */
 a_shortcut      IN     UNAPIGEN.RAW8_TABLE_TYPE,  /* RAW8_TABLE_TYPE */
 a_allow_modify  IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active        IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ss_class      IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows    IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

-- C++ working with OO4O has difficulties to handle RAW-values => RAW becomes VARCHAR2 or NUMBER.
FUNCTION SaveStatus
(a_ss            IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_name          IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description   IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_R             IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_G             IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_B             IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_alt           IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ctrl          IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_shift         IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_key_name      IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_allow_modify  IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active        IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ss_class      IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows    IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetLifeCycleList
(a_lc                  OUT    UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_name                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description         OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_ss                  OUT    UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_ss_after_reanalysis OUT    UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause        IN     VARCHAR2,                 /* VC511_TYPE */
 a_next_rows           IN     NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetLifeCycle
(a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_name                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_intended_use        OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_template         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_inherit_au          OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ss_after_reanalysis OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_class            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc_lc               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetLcTrCondition
(a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_from             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_condition           OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetLcTrCondition
(a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_from             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_condition           OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetLcTrAuthorised
(a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_from             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_us                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetLcTrAuthorised
(a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_from             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_us                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetLcTrAction
(a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_from             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_af                  OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetLcTrAction
(a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_from             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_af                  OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveLifeCycle
(a_lc                  IN      VARCHAR2,                /* VC2_TYPE */
 a_name                IN      VARCHAR2,                /* VC20_TYPE */
 a_description         IN      VARCHAR2,                /* VC40_TYPE */
 a_intended_use        IN      VARCHAR2,                /* VC40_TYPE */
 a_is_template         IN      CHAR,                    /* CHAR1_TYPE */
 a_inherit_au          IN      CHAR,                    /* CHAR1_TYPE */
 a_ss_after_reanalysis IN      VARCHAR2,                /* VC2_TYPE */
 a_lc_class            IN      VARCHAR2,                /* VC2_TYPE */
 a_log_hs              IN      CHAR,                    /* CHAR1_TYPE */
 a_modify_reason       IN      VARCHAR2)                /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveLcTrCondition
(a_lc                  IN      VARCHAR2,                  /* VC2_TYPE */
 a_ss_from             IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_condition           IN      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason       IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveLcTrCondition
(a_lc                  IN      VARCHAR2,                  /* VC2_TYPE */
 a_ss_from             IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_condition           IN      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN      NUMBER,                    /* NUM_TYPE */
 a_next_rows           IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason       IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveLcTrAuthorised
(a_lc                  IN      VARCHAR2,                  /* VC2_TYPE */
 a_ss_from             IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_us                  IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason       IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveLcTrAuthorised
(a_lc                  IN      VARCHAR2,                  /* VC2_TYPE */
 a_ss_from             IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_us                  IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN      NUMBER,                    /* NUM_TYPE */
 a_next_rows           IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason       IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveLcTrAction
(a_lc                  IN      VARCHAR2,                  /* VC2_TYPE */
 a_ss_from             IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_af                  IN      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason       IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveLcTrAction
(a_lc                  IN      VARCHAR2,                  /* VC2_TYPE */
 a_ss_from             IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss_to               IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_tr_no               IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_af                  IN      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows          IN      NUMBER,                    /* NUM_TYPE */
 a_next_rows           IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason       IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteLifeCycle
(a_lc                  IN      VARCHAR2,                 /* VC2_TYPE */
 a_modify_reason       IN      VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetDefaultLifeCycles
(a_object_tp           OUT     UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_def_lc              OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_name             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_log_hs              OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details      OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveDefaultLifeCycles
(a_object_tp           IN      UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_description         IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_def_lc              IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs              IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details      IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                  IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows          IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason       IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetSsUsageLifeCycleList
(a_ss                  IN      VARCHAR2,                 /* VC2_TYPE */
 a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_lc_name             OUT     UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetWlRules
(a_ss            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_entry_action  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_gk_entry      OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_entry_tp      OUT     UNAPIGEN.CHAR2_TABLE_TYPE, /* CHAR2_TABLE_TYPE */
 a_use_value     OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows    IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause  IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveWlRules
(a_ss            IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_entry_action  IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_gk_entry      IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_entry_tp      IN     UNAPIGEN.CHAR2_TABLE_TYPE, /* CHAR2_TABLE_TYPE */
 a_use_value     IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows    IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

END unapilc;