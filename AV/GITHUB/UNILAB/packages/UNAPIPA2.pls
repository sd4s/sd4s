create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapipa2 AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION CreateScPaDetails                            /* INTERNAL */
(a_st             IN        VARCHAR2,                 /* VC20_TYPE */
 a_st_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_pp             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_pp_key1        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key2        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key3        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key4        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pp_key5        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pr             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pr_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_seq            IN        NUMBER,                   /* NUM_TYPE */
 a_sc             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg             IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode         IN        NUMBER,                   /* LONG_TYPE */
 a_panode         IN        NUMBER,                   /* LONG_TYPE */
 a_filter_freq    IN        CHAR,                     /* CHAR1_TYPE */
 a_ref_date       IN        DATE,                     /* DATE_TYPE */
 a_mt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_mt_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_mt_nr_measur   IN        NUMBER,                   /* NUM_TYPE + INDICATOR */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION AddScPaDetails                           /* INTERNAL */
(a_sc             IN    VARCHAR2,                 /* VC20_TYPE */
 a_st             IN    VARCHAR2,                 /* VC20_TYPE */
 a_st_version     IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg             IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode         IN    NUMBER,                   /* LONG_TYPE */
 a_pa             IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode         IN    NUMBER,                   /* LONG_TYPE */
 a_mt             IN    VARCHAR2,                 /* VC20_TYPE */
 a_mt_version     IN    VARCHAR2,                 /* VC20_TYPE */
 a_seq            IN    NUMBER,                   /* NUM_TYPE */
 a_modify_reason  IN    VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CopyScPaDetails                              /* INTERNAL */
(a_sc_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode_from    IN        NUMBER,                   /* LONG_TYPE */
 a_pa_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_panode_from    IN        NUMBER,                   /* LONG_TYPE */
 a_st_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_st_to_version  IN        VARCHAR2,                 /* VC20_TYPE */
 a_sc_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode_to      IN        NUMBER,                   /* LONG_TYPE */
 a_pa_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_panode_to      IN        NUMBER,                   /* LONG_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION InitScPaDetails                                         /* INTERNAL */
(a_st                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_st_version              IN OUT     VARCHAR2,                  /* VC20_TYPE */
 a_pp                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_pgnode                  IN         NUMBER,                    /* LONG_TYPE */
 a_pp_version              IN OUT     VARCHAR2,                  /* VC20_TYPE */
 a_pp_key1                 IN         VARCHAR2,                  /* VC20_TYPE */
 a_pp_key2                 IN         VARCHAR2,                  /* VC20_TYPE */
 a_pp_key3                 IN         VARCHAR2,                  /* VC20_TYPE */
 a_pp_key4                 IN         VARCHAR2,                  /* VC20_TYPE */
 a_pp_key5                 IN         VARCHAR2,                  /* VC20_TYPE */
 a_pr                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_pr_version              IN OUT     VARCHAR2,                  /* VC20_TYPE */
 a_sc                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_filter_freq             IN         CHAR,                      /* CHAR1_TYPE */
 a_ref_date                IN         DATE,                      /* DATE_TYPE */
 a_mt                      IN         VARCHAR2,                  /* VC20_TYPE */
 a_mt_version_in           IN         VARCHAR2,                  /* VC20_TYPE */
 a_mt_nr_measur            IN         NUMBER,                    /* NUM_TYPE + INDICATOR */
 a_me                      OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_reanalysis              OUT        UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_mt_version              OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description             OUT        UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_value_f                 OUT        UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s                 OUT        UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_unit                    OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date         OUT        UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date           OUT        UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_executor                OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_lab                     OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_eq                      OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_eq_version              OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_planned_executor        OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_planned_eq              OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_planned_eq_version      OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_entered        OUT        UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_add               OUT        UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_assign_date             OUT        UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_assigned_by             OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_added          OUT        UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_delay                   OUT        UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_delay_unit              OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_format                  OUT        UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_accuracy                OUT        UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_real_cost               OUT        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_real_time               OUT        UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_calibration             OUT        UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_confirm_complete        OUT        UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_autorecalc              OUT        UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_me_result_editable      OUT        UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_next_cell               OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sop                     OUT        UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_sop_version             OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_plaus_low               OUT        UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_plaus_high              OUT        UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_winsize_x               OUT        UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_winsize_y               OUT        UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_me_class                OUT        UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                  OUT        UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details          OUT        UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                      OUT        UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version              OUT        UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows              IN OUT     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveScPaResult                               /* INTERNAL */
(a_alarms_handled    IN     CHAR,                     /* CHAR1_TYPE */
 a_sc               IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg               IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode           IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa               IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode           IN     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_value_f          IN     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s          IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_unit             IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_format           IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_exec_end_date    IN OUT UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_executor         IN OUT UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_entered IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_reanalysis       OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_modify_flag      IN OUT UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ReanalScParameter                          /* INTERNAL */
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_reanalysis       OUT   NUMBER,                   /* NUM_TYPE */
 a_modify_reason    IN    VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ConfirmPaAssignment                           /* INTERNAL */
(a_alarms_handled   IN     CHAR,                       /* CHAR1_TYPE */
 a_sc               IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pg               IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pgnode           IN OUT UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_pa               IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_panode           IN OUT UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_pr_version       IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description      IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_value_f          IN     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s          IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_unit             IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_exec_start_date  IN     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_exec_end_date    IN OUT UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_executor         IN OUT UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_planned_executor IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_manually_entered IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_assign_date      IN     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_assigned_by      IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_manually_added   IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_format           IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_td_info          IN     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_td_info_unit     IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_confirm_uid      IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_any_me     IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_delay            IN     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_delay_unit       IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_min_nr_results   IN     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_calc_method      IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_calc_cf          IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_alarm_order      IN     UNAPIGEN.VC3_TABLE_TYPE,    /* VC3_TABLE_TYPE */
 a_valid_specsa     IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_valid_specsb     IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_valid_specsc     IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_valid_limitsa    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_valid_limitsb    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_valid_limitsc    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_valid_targeta    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_valid_targetb    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_valid_targetc    IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_mt               IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_mt_version       IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_mt_nr_measur     IN     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE + INDICATOR */
 a_log_exceptions   IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_pa_class         IN     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs           IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_log_hs_details   IN     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_lc               IN     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_lc_version       IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_modify_flag      IN OUT UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                     /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION UpdateTrendInfo                            /* INTERNAL */
(a_sc               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pg               IN    VARCHAR2,                 /* VC20_TYPE */
 a_pgnode           IN    NUMBER,                   /* LONG_TYPE */
 a_pa               IN    VARCHAR2,                 /* VC20_TYPE */
 a_panode           IN    NUMBER,                   /* LONG_TYPE */
 a_value_f          IN    FLOAT,                    /* FLOAT_TYPE + INDICATOR */
 a_value_s          IN    VARCHAR2,                 /* VC40_TYPE */
 a_exec_end_date    IN    DATE,                     /* DATE_TYPE */
 a_td_info          IN    NUMBER,                   /* NUM_TYPE */
 a_td_info_unit     IN    VARCHAR2,                 /* VC20_TYPE */
 a_reanalysis       IN    NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;

FUNCTION CopyAvailablePaResult                 /* INTERNAL */
(a_sc               IN   VARCHAR2,             /* VC20_TYPE */
 a_pg               IN   VARCHAR2,             /* VC20_TYPE */
 a_pgnode           IN   NUMBER,               /* LONG_TYPE */
 a_pa               IN   VARCHAR2,             /* VC20_TYPE */
 a_panode           IN   NUMBER)               /* LONG_TYPE */
RETURN NUMBER;

END unapipa2;