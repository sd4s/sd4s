create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapilc AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetStatusList
(a_ss                  OUT    UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_name                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description         OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_R                   OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* RAW8_TABLE_TYPE */
 a_G                   OUT    UNAPIGEN.NUM_TABLE_TYPE,  /*                 ''                           */
 a_B                   OUT    UNAPIGEN.NUM_TABLE_TYPE,  /*                 ''                           */
 a_nr_of_rows          IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause        IN     VARCHAR2,                 /* VC511_TYPE */
 a_next_rows           IN     NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetStatus
(a_ss            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_name          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description   OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_R             OUT     UNAPIGEN.NUM_TABLE_TYPE,  /* RAW8_TABLE_TYPE */
 a_G             OUT     UNAPIGEN.NUM_TABLE_TYPE,  /*                 ''                           */
 a_B             OUT     UNAPIGEN.NUM_TABLE_TYPE,  /*                 ''                           */
 a_alt           OUT     PBAPIGEN.VC1_TABLE_TYPE,  /* RAW8_TABLE_TYPE */
 a_ctrl          OUT     PBAPIGEN.VC1_TABLE_TYPE,  /*                 ''                           */
 a_shift         OUT     PBAPIGEN.VC1_TABLE_TYPE,  /*                 ''                           */
 a_key_name      OUT     UNAPIGEN.VC20_TABLE_TYPE,  /*                 ''                           */
 a_allow_modify  OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active        OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ss_class      OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows    IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause  IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveStatus
(a_ss            IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_name          IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description   IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_R             IN     UNAPIGEN.NUM_TABLE_TYPE,  /* RAW8_TABLE_TYPE */
 a_G             IN     UNAPIGEN.NUM_TABLE_TYPE,  /*                 ''                           */
 a_B             IN     UNAPIGEN.NUM_TABLE_TYPE,  /*                 ''                           */
 a_alt           IN     PBAPIGEN.VC1_TABLE_TYPE,  /* RAW8_TABLE_TYPE */
 a_ctrl          IN     PBAPIGEN.VC1_TABLE_TYPE,  /*                 ''                           */
 a_shift         IN     PBAPIGEN.VC1_TABLE_TYPE,  /*                 ''                           */
 a_key_name      IN     UNAPIGEN.VC20_TABLE_TYPE,  /*                 ''                           */
 a_allow_modify  IN     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active        IN     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ss_class      IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows    IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetLifeCycle
(a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_name                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_intended_use        OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_template         OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_inherit_au          OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ss_after_reanalysis OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_class            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs              OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify        OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active              OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc_lc               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetWlRules
(a_ss            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_entry_action  OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_gk_entry      OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_entry_tp      OUT     PBAPIGEN.VC2_TABLE_TYPE, /* CHAR2_TABLE_TYPE */
 a_use_value     OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows    IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause  IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveWlRules
(a_ss            IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_entry_action  IN     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_gk_entry      IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_entry_tp      IN     PBAPIGEN.VC2_TABLE_TYPE, /* CHAR2_TABLE_TYPE */
 a_use_value     IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows    IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetDefaultLifeCycles
(a_object_tp           OUT     UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_def_lc              OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_name             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_log_hs              OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details      OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ar                  OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveDefaultLifeCycles
(a_object_tp           IN      UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_description         IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_def_lc              IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs              IN      PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details      IN      PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ar                  IN      PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows          IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason       IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

END pbapilc;