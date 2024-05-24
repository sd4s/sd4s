create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapipp AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetParameterProfileList
(a_pp                      OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version                 OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key1                 OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key2                 OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key3                 OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key4                 OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key5                 OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version_is_current      OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_effective_till          OUT     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_description             OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_ss                      OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause            IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows               IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetParameterProfile
(a_pp                          OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version                     OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key1                     OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key2                     OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key3                     OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key4                     OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key5                     OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version_is_current          OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_effective_from              OUT     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_effective_till              OUT     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_description                 OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description2                OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_unit                        OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_format                      OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_confirm_assign              OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_any_pr                OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_never_create_methods        OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_delay                       OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_delay_unit                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_is_template                 OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_sc_lc                       OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_sc_lc_version               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_inherit_au                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_pp_class                    OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs                      OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_modify                OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_active                      OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_lc                          OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_lc_version                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ss                          OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows                  IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause                IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetPpParameter
(a_pp                  OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version             OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key1             OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key2             OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key3             OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key4             OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key5             OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pr                  OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pr_version          OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description         OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_unit                OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_format              OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_measur           OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_allow_add           OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_is_pp               OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_freq_tp             OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_freq_val            OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_freq_unit           OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_invert_freq         OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_st_based_freq       OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_last_sched          OUT    UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_last_cnt            OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_last_val            OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_inherit_au          OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_delay               OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_delay_unit          OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_mt                  OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_mt_version          OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_mt_nr_measur        OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows          IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetPpParameterSpecs
(a_pp           OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version      OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key1      OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key2      OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key3      OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key4      OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key5      OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pr           OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pr_version   OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_low_limit    OUT    UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_limit   OUT    UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_low_spec     OUT    UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_spec    OUT    UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_low_dev      OUT    UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_rel_low_dev  OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_target       OUT    UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_dev     OUT    UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_rel_high_dev OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_spec_set     IN     CHAR,                      /* CHAR1_TYPE */
 a_nr_of_rows   IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION DeleteParameterProfile
(a_pp                  IN     VARCHAR2,                /* VC20_TYPE */
 a_version             IN     VARCHAR2,                /* VC20_TYPE */
 a_pp_key1             IN     VARCHAR2,                /* VC20_TYPE */
 a_pp_key2             IN     VARCHAR2,                /* VC20_TYPE */
 a_pp_key3             IN     VARCHAR2,                /* VC20_TYPE */
 a_pp_key4             IN     VARCHAR2,                /* VC20_TYPE */
 a_pp_key5             IN     VARCHAR2,                /* VC20_TYPE */
 a_modify_reason       IN     VARCHAR2)                /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveParameterProfile
(a_pp                           IN     VARCHAR2,                 /* VC20_TYPE */
 a_version                      IN     VARCHAR2,                 /* VC20_TYPE */
 a_pp_key1                      IN     VARCHAR2,                 /* VC20_TYPE */
 a_pp_key2                      IN     VARCHAR2,                 /* VC20_TYPE */
 a_pp_key3                      IN     VARCHAR2,                 /* VC20_TYPE */
 a_pp_key4                      IN     VARCHAR2,                 /* VC20_TYPE */
 a_pp_key5                      IN     VARCHAR2,                 /* VC20_TYPE */
 a_version_is_current           IN     CHAR,                     /* CHAR1_TYPE */
 a_effective_from               IN     DATE,                     /* DATE_TYPE */
 a_effective_till               IN     DATE,                     /* DATE_TYPE */
 a_description                  IN     VARCHAR2,                 /* VC40_TYPE */
 a_description2                 IN     VARCHAR2,                 /* VC40_TYPE */
 a_unit                         IN     VARCHAR2,                 /* VC20_TYPE */
 a_format                       IN     VARCHAR2,                 /* VC40_TYPE */
 a_confirm_assign               IN     CHAR,                     /* CHAR1_TYPE */
 a_allow_any_pr                 IN     CHAR,                     /* CHAR1_TYPE */
 a_never_create_methods         IN     CHAR,                     /* CHAR1_TYPE */
 a_delay                        IN     NUMBER,                   /* NUM_TYPE */
 a_delay_unit                   IN     VARCHAR2,                 /* VC20_TYPE */
 a_is_template                  IN     CHAR,                     /* CHAR1_TYPE */
 a_sc_lc                        IN     VARCHAR2,                 /* VC2_TYPE */
 a_sc_lc_version                IN     VARCHAR2,                 /* VC20_TYPE */
 a_inherit_au                   IN     CHAR,                     /* CHAR1_TYPE */
 a_pp_class                     IN     VARCHAR2,                 /* VC2_TYPE */
 a_log_hs                       IN     CHAR,                     /* CHAR1_TYPE */
 a_lc                           IN     VARCHAR2,                 /* VC2_TYPE */
 a_lc_version                   IN     VARCHAR2,                 /* VC20_TYPE */
 a_modify_reason                IN     VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SavePpParameter
(a_pp            IN  VARCHAR2,                  /* VC20_TYPE */
 a_version       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key1       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key2       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key3       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key4       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key5       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pr            IN  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pr_version    IN  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_measur     IN  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_unit          IN  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_format        IN  UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_allow_add     IN  UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_is_pp         IN  UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_freq_tp       IN  UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_freq_val      IN  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_freq_unit     IN  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_invert_freq   IN  UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_st_based_freq IN  UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_last_sched    IN  UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_last_cnt      IN  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_last_val      IN  UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_inherit_au    IN  UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_delay         IN  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_delay_unit    IN  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_mt            IN  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_mt_version    IN  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_mt_nr_measur  IN  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows    IN  NUMBER,                    /* NUM_TYPE */
 a_modify_reason IN  VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SavePpParameterSpecs
(a_pp            IN  VARCHAR2,                  /* VC20_TYPE */
 a_version       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key1       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key2       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key3       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key4       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key5       IN  VARCHAR2,                  /* VC20_TYPE */
 a_pr            IN  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pr_version    IN  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_spec_set      IN  CHAR,                      /* CHAR1_TYPE */
 a_low_limit     IN  UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_limit    IN  UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_low_spec      IN  UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_spec     IN  UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_low_dev       IN  UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_rel_low_dev   IN  UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_target        IN  UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_high_dev      IN  UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_rel_high_dev  IN  UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows    IN  NUMBER,                    /* NUM_TYPE */
 a_modify_reason IN  VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CopyParameterProfile
(a_pp            IN     VARCHAR2,                  /* VC20_TYPE */
 a_version       IN     VARCHAR2,                  /* VC20_TYPE */
 a_pp_key1       IN     VARCHAR2,                  /* VC20_TYPE */
 a_pp_key2       IN     VARCHAR2,                  /* VC20_TYPE */
 a_pp_key3       IN     VARCHAR2,                  /* VC20_TYPE */
 a_pp_key4       IN     VARCHAR2,                  /* VC20_TYPE */
 a_pp_key5       IN     VARCHAR2,                  /* VC20_TYPE */
 a_cp_pp         IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_cp_version    IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_cp_pp_key1    IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_cp_pp_key2    IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_cp_pp_key3    IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_cp_pp_key4    IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_cp_pp_key5    IN OUT VARCHAR2,                  /* VC20_TYPE */
 a_modify_reason IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

END unapipp;