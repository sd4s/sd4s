create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapipr AS

/* Parameter cursor ID */
P_PR_CURSOR   INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetParameterList
(a_pr                      OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                     /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2,                   /* VC511_TYPE */
 a_next_rows               IN       NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetParameter
(a_pr                      OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description2            OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_unit                    OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_format                  OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_td_info                 OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_td_info_unit            OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_confirm_uid             OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_def_val_tp              OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_def_au_level            OUT      UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_def_val                 OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_allow_any_mt            OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_delay                   OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_delay_unit              OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_min_nr_results          OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_calc_method             OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_calc_cf                 OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_alarm_order             OUT      UNAPIGEN.VC3_TABLE_TYPE,    /* VC3_TABLE_TYPE */
 a_seta_specs              OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_seta_limits             OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_seta_target             OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_setb_specs              OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_setb_limits             OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_setb_target             OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_setc_specs              OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_setc_limits             OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_setc_target             OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_is_template             OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_log_exceptions          OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_sc_lc                   OUT      UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_sc_lc_version           OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_inherit_au              OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_pr_class                OUT      UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_active                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_lc                      OUT      UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_lc_version              OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                     /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetPrMethod
(a_pr                  OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version             OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_mt                  OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_mt_version          OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_measur           OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_unit                OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_format              OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_allow_add           OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_ignore_other        OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_accuracy            OUT      UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_freq_tp             OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_freq_val            OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_freq_unit           OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_invert_freq         OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_st_based_freq       OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_last_sched          OUT      UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_last_cnt            OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_last_val            OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_inherit_au          OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN       VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION DeleteParameter
(a_pr                  IN       VARCHAR2,                   /* VC20_TYPE */
 a_version             IN       VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason       IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveParameter
(a_pr                      IN       VARCHAR2,                   /* VC20_TYPE */
 a_version                 IN       VARCHAR2,                   /* VC20_TYPE */
 a_version_is_current      IN       CHAR,                       /* CHAR1_TYPE */
 a_effective_from          IN       DATE,                       /* DATE_TYPE */
 a_effective_till          IN       DATE,                       /* DATE_TYPE */
 a_description             IN       VARCHAR2,                   /* VC40_TYPE */
 a_description2            IN       VARCHAR2,                   /* VC40_TYPE */
 a_unit                    IN       VARCHAR2,                   /* VC20_TYPE */
 a_format                  IN       VARCHAR2,                   /* VC40_TYPE */
 a_td_info                 IN       NUMBER,                     /* NUM_TYPE */
 a_td_info_unit            IN       VARCHAR2,                   /* VC20_TYPE */
 a_confirm_uid             IN       CHAR,                       /* CHAR1_TYPE */
 a_def_val_tp              IN       CHAR,                       /* CHAR1_TYPE */
 a_def_au_level            IN       VARCHAR2,                   /* VC4_TYPE */
 a_def_val                 IN       VARCHAR2,                   /* VC40_TYPE */
 a_allow_any_mt            IN       CHAR,                       /* CHAR1_TYPE */
 a_delay                   IN       NUMBER,                     /* NUM_TYPE */
 a_delay_unit              IN       VARCHAR2,                   /* VC20_TYPE */
 a_min_nr_results          IN       NUMBER,                     /* NUM_TYPE */
 a_calc_method             IN       CHAR,                       /* CHAR1_TYPE */
 a_calc_cf                 IN       VARCHAR2,                   /* VC20_TYPE */
 a_alarm_order             IN       VARCHAR2,                   /* VC3_TYPE */
 a_seta_specs              IN       VARCHAR2,                   /* VC20_TYPE */
 a_seta_limits             IN       VARCHAR2,                   /* VC20_TYPE */
 a_seta_target             IN       VARCHAR2,                   /* VC20_TYPE */
 a_setb_specs              IN       VARCHAR2,                   /* VC20_TYPE */
 a_setb_limits             IN       VARCHAR2,                   /* VC20_TYPE */
 a_setb_target             IN       VARCHAR2,                   /* VC20_TYPE */
 a_setc_specs              IN       VARCHAR2,                   /* VC20_TYPE */
 a_setc_limits             IN       VARCHAR2,                   /* VC20_TYPE */
 a_setc_target             IN       VARCHAR2,                   /* VC20_TYPE */
 a_is_template             IN       CHAR,                       /* CHAR1_TYPE */
 a_log_exceptions          IN       CHAR,                       /* CHAR1_TYPE */
 a_sc_lc                   IN       VARCHAR2,                   /* VC2_TYPE */
 a_sc_lc_version           IN       VARCHAR2,                   /* VC20_TYPE */
 a_inherit_au              IN       CHAR,                       /* CHAR1_TYPE */
 a_pr_class                IN       VARCHAR2,                   /* VC2_TYPE */
 a_log_hs                  IN       CHAR,                       /* CHAR1_TYPE */
 a_lc                      IN       VARCHAR2,                   /* VC2_TYPE */
 a_lc_version              IN       VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason           IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SavePrMethod
(a_pr                  IN       VARCHAR2,                   /* VC20_TYPE */
 a_version             IN       VARCHAR2,                   /* VC20_TYPE */
 a_mt                  IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_mt_version          IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_measur           IN       UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_unit                IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_format              IN       UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_allow_add           IN       UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_ignore_other        IN       UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_accuracy            IN       UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_freq_tp             IN       UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_freq_val            IN       UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_freq_unit           IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_invert_freq         IN       UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_st_based_freq       IN       UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_last_sched          IN       UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_last_cnt            IN       UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_last_val            IN       UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_inherit_au          IN       UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows          IN       NUMBER,                     /* NUM_TYPE */
 a_modify_reason       IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetPrChartType
(a_pr                    OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version               OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy                    OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy_version            OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_st                    OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_st_version            OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows            IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause          IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SavePrChartType
(a_pr                     IN    VARCHAR2,                     /* VC20_TYPE */
 a_version                IN    VARCHAR2,                     /* VC20_TYPE */
 a_cy                     IN    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_cy_version             IN    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_st                     IN    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_st_version             IN    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_nr_of_rows             IN    NUMBER,                       /* NUM_TYPE */
 a_modify_reason          IN    VARCHAR2 )                    /* VC255_TYPE */
RETURN NUMBER ;

FUNCTION CopyParameter
(a_pr             IN        VARCHAR2,                 /* VC20_TYPE */
 a_version        IN        VARCHAR2,                 /* VC20_TYPE */
 a_cp_pr          IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_cp_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

END unapipr;