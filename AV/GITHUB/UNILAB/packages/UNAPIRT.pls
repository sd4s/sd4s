create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapirt AS

/* SelectRequestType FROM and WHERE clause variable, used in GetRtGroupKey and GetObjectAttribute */
P_SELECTION_CLAUSE               VARCHAR2(4000);
P_SELECTION_VAL_TAB              VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetRequestTypeList
(a_rt                          OUT      UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_version                     OUT      UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_version_is_current          OUT      UNAPIGEN.CHAR1_TABLE_TYPE,/* CHAR1_TABLE_TYPE */
 a_effective_from              OUT      UNAPIGEN.DATE_TABLE_TYPE, /* DATE_TABLE_TYPE */
 a_effective_till              OUT      UNAPIGEN.DATE_TABLE_TYPE, /* DATE_TABLE_TYPE */
 a_description                 OUT      UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_ss                          OUT      UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_nr_of_rows                  IN OUT   NUMBER,                   /* NUM_TYPE */
 a_where_clause                IN       VARCHAR2,                 /* VC511_TYPE */
 a_next_rows                   IN       NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetRequestType
(a_rt                      OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version                 OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version_is_current      OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_effective_till          OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_description             OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_description2            OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_descr_doc               OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_descr_doc_version       OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_is_template             OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_confirm_userid          OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_nr_planned_rq           OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE + INDICATOR */
 a_freq_tp                 OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_freq_val                OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_freq_unit               OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_invert_freq             OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_last_sched              OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_last_cnt                OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_last_val                OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_priority                OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE + INDICATOR */
 a_label_format            OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_allow_any_st            OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_new_sc            OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_add_stpp                OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_planned_responsible     OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_sc_uc                   OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_sc_uc_version           OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_rq_uc                   OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_rq_uc_version           OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_rq_lc                   OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_rq_lc_version           OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_inherit_au              OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_inherit_gk              OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_rt_class                OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_log_hs                  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active                  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc                      OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_lc_version              OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ss                      OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN   VARCHAR2)                     /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SelectRequestType
(a_col_id              IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_tp              IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_value           IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_nr_of_rows      IN   NUMBER,                       /* NUM_TYPE */
 a_rt                  OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version             OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version_is_current  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_effective_from      OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_effective_till      OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_description         OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_description2        OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_descr_doc           OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_descr_doc_version   OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_is_template         OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_confirm_userid      OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_nr_planned_rq       OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE + INDICATOR */
 a_freq_tp             OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_freq_val            OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_freq_unit           OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_invert_freq         OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_last_sched          OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_last_cnt            OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_last_val            OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_priority            OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE + INDICATOR */
 a_label_format        OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_allow_any_st        OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_new_sc        OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_add_stpp            OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_planned_responsible OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_sc_uc               OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_sc_uc_version       OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_rq_uc               OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_rq_uc_version       OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_rq_lc               OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_rq_lc_version       OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_inherit_au          OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_inherit_gk          OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_rt_class            OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_log_hs              OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify        OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active              OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc                  OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_lc_version          OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ss                  OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause     IN   VARCHAR2,                     /* VC255_TYPE */
 a_next_rows           IN   NUMBER)                       /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectRequestType
(a_col_id              IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_tp              IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_value           IN   UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_col_operator        IN   UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_col_andor           IN   UNAPIGEN.VC3_TABLE_TYPE,      /* VC3_TABLE_TYPE */
 a_col_nr_of_rows      IN   NUMBER,                       /* NUM_TYPE */
 a_rt                  OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version             OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_version_is_current  OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_effective_from      OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_effective_till      OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_description         OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_description2        OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_descr_doc           OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_descr_doc_version   OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_is_template         OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_confirm_userid      OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_nr_planned_rq       OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE + INDICATOR */
 a_freq_tp             OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_freq_val            OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_freq_unit           OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_invert_freq         OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_last_sched          OUT  UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE */
 a_last_cnt            OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE */
 a_last_val            OUT  UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE */
 a_priority            OUT  UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE + INDICATOR */
 a_label_format        OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_allow_any_st        OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_new_sc        OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_add_stpp            OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_planned_responsible OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_sc_uc               OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_sc_uc_version       OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_rq_uc               OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_rq_uc_version       OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_rq_lc               OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_rq_lc_version       OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_inherit_au          OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_inherit_gk          OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_rt_class            OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_log_hs              OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify        OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active              OUT  UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc                  OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_lc_version          OUT  UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ss                  OUT  UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause     IN   VARCHAR2,                     /* VC255_TYPE */
 a_next_rows           IN   NUMBER)                       /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectRtGkValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                    /* NUM_TYPE */
 a_gk               IN      VARCHAR2,                  /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectRtGkValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_operator     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_col_andor        IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                    /* NUM_TYPE */
 a_gk               IN      VARCHAR2,                  /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectRtPropValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                    /* NUM_TYPE */
 a_prop             IN      VARCHAR2,                  /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectRtPropValues
(a_col_id           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp           IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value        IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_operator     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_col_andor        IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_col_nr_of_rows   IN      NUMBER,                    /* NUM_TYPE */
 a_prop             IN      VARCHAR2,                  /* VC20_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause  IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows        IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetRtSampleType
(a_rt               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_version          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_st               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_st_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_planned_sc    OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_delay            OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_delay_unit       OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_freq_tp          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_val         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_freq_unit        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_invert_freq      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_last_sched       OUT    UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_last_cnt         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_last_val         OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_inherit_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetRtInfoProfile
(a_rt               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_version          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ip               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ip_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_hidden           OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_tp          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_val         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_freq_unit        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_invert_freq      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_last_sched       OUT    UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_last_cnt         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_last_val         OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_inherit_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetRtParameterProfile
(a_rt               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_version          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key1          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key2          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key3          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key4          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pp_key5          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_delay            OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_delay_unit       OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_freq_tp          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_val         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_freq_unit        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_invert_freq      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_last_sched       OUT    UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_last_cnt         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_last_val         OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_inherit_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetRtGroupKey
(a_rt                 OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version            OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_gk                 OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_gk_version         OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_value              OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description        OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_is_protected       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_value_unique       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_single_valued      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_new_val_allowed    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_mandatory          OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_value_list_tp      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_rows           OUT    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows         IN OUT NUMBER,                     /* NUM_TYPE */
 a_where_clause       IN     VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveRequestType
(a_rt                  IN  VARCHAR2,                  /* VC20_TYPE */
 a_version             IN  VARCHAR2,                  /* VC20_TYPE */
 a_version_is_current  IN  CHAR,                      /* CHAR1_TYPE */
 a_effective_from      IN  DATE,                      /* DATE_TYPE */
 a_effective_till      IN  DATE,                      /* DATE_TYPE */
 a_description         IN  VARCHAR2,                  /* VC40_TYPE */
 a_description2        IN  VARCHAR2,                  /* VC40_TYPE */
 a_descr_doc           IN  VARCHAR2,                  /* VC40_TYPE */
 a_descr_doc_version   IN  VARCHAR2,                  /* VC20_TYPE */
 a_is_template         IN  CHAR,                      /* CHAR1_TYPE */
 a_confirm_userid      IN  CHAR,                      /* CHAR1_TYPE */
 a_nr_planned_rq       IN  NUMBER,                    /* NUM_TYPE + INDICATOR */
 a_freq_tp             IN  CHAR,                      /* CHAR1_TYPE */
 a_freq_val            IN  NUMBER,                    /* NUM_TYPE */
 a_freq_unit           IN  VARCHAR2,                  /* VC20_TYPE */
 a_invert_freq         IN  CHAR,                      /* CHAR1_TYPE */
 a_last_sched          IN  DATE,                      /* DATE_TYPE */
 a_last_cnt            IN  NUMBER,                    /* NUM_TYPE */
 a_last_val            IN  VARCHAR2,                  /* VC40_TYPE */
 a_priority            IN  NUMBER,                    /* NUM_TYPE + INDICATOR */
 a_label_format        IN  VARCHAR2,                  /* VC20_TYPE */
 a_allow_any_st        IN  CHAR,                      /* CHAR1_TYPE */
 a_allow_new_sc        IN  CHAR,                      /* CHAR1_TYPE */
 a_add_stpp            IN  CHAR,                      /* CHAR1_TYPE */
 a_planned_responsible IN  VARCHAR2,                  /* VC20_TYPE */
 a_sc_uc               IN  VARCHAR2,                  /* VC20_TYPE */
 a_sc_uc_version       IN  VARCHAR2,                  /* VC20_TYPE */
 a_rq_uc               IN  VARCHAR2,                  /* VC20_TYPE */
 a_rq_uc_version       IN  VARCHAR2,                  /* VC20_TYPE */
 a_rq_lc               IN  VARCHAR2,                  /* VC2_TYPE */
 a_rq_lc_version       IN  VARCHAR2,                  /* VC20_TYPE */
 a_inherit_au          IN  CHAR,                      /* CHAR1_TYPE */
 a_inherit_gk          IN  CHAR,                      /* CHAR1_TYPE */
 a_rt_class            IN  VARCHAR2,                  /* VC2_TYPE */
 a_log_hs              IN  CHAR,                      /* CHAR1_TYPE */
 a_lc                  IN  VARCHAR2,                  /* VC2_TYPE */
 a_lc_version          IN  VARCHAR2,                  /* VC20_TYPE */
 a_modify_reason       IN  VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteRequestType
(a_rt            IN  VARCHAR2,          /* VC20_TYPE */
 a_version       IN  VARCHAR2,          /* VC20_TYPE */
 a_modify_reason IN  VARCHAR2)          /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveRtSampleType
(a_rt               IN    VARCHAR2,                   /* VC20_TYPE */
 a_version          IN    VARCHAR2,                   /* VC20_TYPE */
 a_st               IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_st_version       IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_planned_sc    IN    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE + INDICATOR */
 a_delay            IN    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_delay_unit       IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_freq_tp          IN    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_freq_val         IN    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_freq_unit        IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_invert_freq      IN    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_last_sched       IN    UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_last_cnt         IN    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_last_val         IN    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_inherit_au       IN    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN    NUMBER,                     /* NUM_TYPE */
 a_modify_reason    IN    VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveRtInfoProfile
(a_rt               IN    VARCHAR2,                    /* VC20_TYPE */
 a_version          IN    VARCHAR2,                    /* VC20_TYPE */
 a_ip               IN    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ip_version       IN    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_is_protected     IN    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_hidden           IN    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_tp          IN    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_freq_val         IN    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_freq_unit        IN    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_invert_freq      IN    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_last_sched       IN    UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_last_cnt         IN    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_last_val         IN    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_inherit_au       IN    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN    NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN    VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveRtParameterProfile
(a_rt               IN    VARCHAR2,                   /* VC20_TYPE */
 a_version          IN    VARCHAR2,                   /* VC20_TYPE */
 a_pp               IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_version       IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key1          IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key2          IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key3          IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key4          IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pp_key5          IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_delay            IN    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_delay_unit       IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_freq_tp          IN    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_freq_val         IN    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_freq_unit        IN    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_invert_freq      IN    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_last_sched       IN    UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_last_cnt         IN    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_last_val         IN    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_inherit_au       IN    UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN    NUMBER,                     /* NUM_TYPE */
 a_modify_reason    IN    VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveRtGroupKey
(a_rt                 IN       VARCHAR2,                   /* VC20_TYPE */
 a_version            IN       VARCHAR2,                   /* VC20_TYPE */
 a_gk                 IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_gk_version         IN OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_value              IN       UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows         IN       NUMBER,                     /* NUM_TYPE */
 a_modify_reason      IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1RtGroupKey
(a_rt                 IN       VARCHAR2,                   /* VC20_TYPE */
 a_version            IN       VARCHAR2,                   /* VC20_TYPE */
 a_gk                 IN       VARCHAR2,                   /* VC20_TYPE */
 a_gk_version         IN OUT   VARCHAR2,                   /* VC20_TYPE */
 a_value              IN       UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows         IN       NUMBER,                     /* NUM_TYPE */
 a_modify_reason      IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetRtPpAttribute
(a_rt               OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version          OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp               OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key1          OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key2          OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key3          OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key4          OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key5          OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au               OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_store_db         OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_run_mode         OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_service          OUT    UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cf_value         OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveRtPpAttribute
(a_rt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_version        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key1        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key2        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key3        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key4        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key5        IN        VARCHAR2,                 /* VC20_TYPE */
 a_au             IN        UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_au_version     IN OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1RtPpAttribute
(a_rt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_version        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key1        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key2        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key3        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key4        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key5        IN        VARCHAR2,                 /* VC20_TYPE */
 a_au             IN        VARCHAR2,                 /* VC20_TYPE */
 a_value          IN        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_au_version     IN        VARCHAR2,                 /* VC20_TYPE */
 a_nr_of_rows     IN        NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

END unapirt;