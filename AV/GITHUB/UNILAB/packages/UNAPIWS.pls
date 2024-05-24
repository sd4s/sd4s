create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiws AS

/* SelectWorksheet FROM and WHERE clause variable, used in GetScGroupKey and GetScMeGroupKey */
P_SELECTION_CLAUSE               VARCHAR2(4000);
P_SELECTION_VAL_TAB              VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION SaveWorksheet
(a_ws                   IN     VARCHAR2,       /* VC20_TYPE */
 a_wt                   IN     VARCHAR2,       /* VC20_TYPE */
 a_wt_version           IN     VARCHAR2,       /* VC20_TYPE */
 a_description          IN     VARCHAR2,       /* VC40_TYPE */
 a_creation_date        IN     DATE,           /* DATE_TYPE */
 a_created_by           IN     VARCHAR2,       /* VC20_TYPE */
 a_exec_start_date      IN     DATE,           /* DATE_TYPE */
 a_exec_end_date        IN     DATE,           /* DATE_TYPE */
 a_priority             IN     NUMBER,         /* NUM_TYPE + INDICATOR */
 a_due_date             IN     DATE,           /* DATE_TYPE */
 a_responsible          IN     VARCHAR2,       /* VC20_TYPE */
 a_sc_counter           IN     NUMBER,         /* NUM_TYPE + INDICATOR */
 a_min_rows             IN     NUMBER,         /* NUM_TYPE + INDICATOR */
 a_max_rows             IN     NUMBER,         /* NUM_TYPE + INDICATOR */
 a_complete             IN     CHAR,           /* CHAR1_TYPE */
 a_valid_cf             IN     VARCHAR2,       /* VC20_TYPE */
 a_descr_doc            IN     VARCHAR2,       /* VC40_TYPE */
 a_descr_doc_version    IN     VARCHAR2,       /* VC20_TYPE */
 a_date1                IN     DATE,           /* DATE_TYPE */
 a_date2                IN     DATE,           /* DATE_TYPE */
 a_date3                IN     DATE,           /* DATE_TYPE */
 a_date4                IN     DATE,           /* DATE_TYPE */
 a_date5                IN     DATE,           /* DATE_TYPE */
 a_ws_class             IN     VARCHAR2,       /* VC2_TYPE */
 a_log_hs               IN     CHAR,           /* CHAR1_TYPE */
 a_log_hs_details       IN     CHAR,           /* CHAR1_TYPE */
 a_lc                   IN     VARCHAR2,       /* VC2_TYPE */
 a_lc_version           IN     VARCHAR2,       /* VC20_TYPE */
 a_modify_reason        IN     VARCHAR2)       /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetWorksheet
(a_ws                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_wt                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_wt_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description          OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_creation_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date      OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_priority             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_due_date             OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_responsible          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sc_counter           OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_min_rows             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_max_rows             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_complete             OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_cf             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_descr_doc            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc_version    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_date1                OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date2                OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date3                OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date4                OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date5                OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_ws_class             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                   OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                   OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause         IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveWsSample
(a_ws                   IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rownr                IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ws_modify_flag       IN OUT UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sc                   IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_st                   IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_st_version           IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description          IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_shelf_life_val       IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_shelf_life_unit      IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sampling_date        IN     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_creation_date        IN     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by           IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date      IN     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date        IN     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_priority             IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_label_format         IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_descr_doc            IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc_version    IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rq                   IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sd                   IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_date1                IN     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date2                IN     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date3                IN     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date4                IN     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date5                IN     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_allow_any_pp         IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_sc_class             IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs               IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details       IN     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                   IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version           IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_modify_flag          IN OUT UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows           IN     NUMBER,                    /* NUM_TYPE */
 a_next_rows            IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason        IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetWsSample
(a_ws                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rownr                OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sc                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_st                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_st_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description          OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_shelf_life_val       OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_shelf_life_unit      OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sampling_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_creation_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date      OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_priority             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_label_format         OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_descr_doc            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc_version    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rq                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sd                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_date1                OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date2                OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date3                OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date4                OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date5                OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_allow_any_pp         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_sc_class             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                   OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                   OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause         IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows            IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveWsInfoField
(a_ws               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_rownr            IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_ws_modify_flag   IN OUT UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_sc               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ic               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_icnode           IN OUT UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_ii               IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_iinode           IN OUT UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_ie_version       IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_iivalue          IN     UNAPIGEN.VC2000_TABLE_TYPE,  /* VC2000_TABLE_TYPE */
 a_pos_x            IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_pos_y            IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_is_protected     IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_hidden           IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_title        IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_len          IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_dsp_tp           IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_rows         IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_ii_class         IN     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_log_hs           IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details   IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc               IN     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_lc_version       IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_modify_flag      IN OUT UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                      /* NUM_TYPE */
 a_next_rows        IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetWsInfoField
(a_ws               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_rownr            OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_sc               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ic               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_icnode           OUT     UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_ii               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_iinode           OUT     UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_ie_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_iivalue          OUT     UNAPIGEN.VC2000_TABLE_TYPE, /* VC2000_TABLE_TYPE */
 a_pos_x            OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_pos_y            OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_is_protected     OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_hidden           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_title        OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_len          OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_dsp_tp           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_dsp_rows         OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_ii_class         OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_log_hs_details   OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_modify     OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_ar               OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_active           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_lc               OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_lc_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ss               OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows        IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveWsMethod
(a_ws                   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_rownr                IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_ws_modify_flag       IN OUT UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_alarms_handled       IN     CHAR,                        /* CHAR1_TYPE */
 a_sc                   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pg                   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pgnode               IN     UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_pa                   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_panode               IN     UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_me                   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_menode               IN OUT UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_reanalysis           IN OUT UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_mt_version           IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description          IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_value_f              IN     UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s              IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_unit                 IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_exec_start_date      IN     UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_exec_end_date        IN OUT UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_executor             IN OUT UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_lab                  IN OUT UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_eq                   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_eq_version           IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_planned_executor     IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_planned_eq           IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_planned_eq_version   IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_manually_entered     IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_add            IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_assign_date          IN     UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_assigned_by          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_manually_added       IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_delay                IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE  */
 a_delay_unit           IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_format               IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_accuracy             IN     UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_real_cost            IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_real_time            IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_calibration          IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_confirm_complete     IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_autorecalc           IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_me_result_editable   IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_next_cell            IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_sop                  IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_sop_version          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_plaus_low            IN     UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_plaus_high           IN     UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_winsize_x            IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_winsize_y            IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_me_class             IN     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_log_hs               IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details       IN     UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc                   IN     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_lc_version           IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_modify_flag          IN OUT UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_nr_of_rows           IN     NUMBER,                      /* NUM_TYPE */
 a_next_rows            IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason        IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetWsMethod
(a_ws                       OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_rownr                    OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_sc                       OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pg                       OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pgnode                   OUT     UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_pa                       OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_panode                   OUT     UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_me                       OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_menode                   OUT     UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_reanalysis               OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_mt_version               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description              OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_value_f                  OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s                  OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_unit                     OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_exec_start_date          OUT     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_exec_end_date            OUT     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_executor                 OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_lab                      OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_eq                       OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_eq_version               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_planned_executor         OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_planned_eq               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_planned_eq_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_manually_entered         OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_add                OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_assign_date              OUT     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_assigned_by              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_manually_added           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_delay                    OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_delay_unit               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_format                   OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_accuracy                 OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_real_cost                OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_real_time                OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_calibration              OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_confirm_complete         OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_autorecalc               OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_me_result_editable       OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_next_cell                OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sop                      OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_sop_version              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_plaus_low                OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_plaus_high               OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_winsize_x                OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_winsize_y                OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_me_class                 OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs                   OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_log_hs_details           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_modify             OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_ar                       OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_active                   OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_lc                       OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_lc_version               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ss                       OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_reanalysedresult         OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows               IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause             IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows                IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectWorksheet
(a_col_id                   IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp                   IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value                IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_nr_of_rows           IN      NUMBER,                    /* NUM_TYPE */
 a_ws                       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_wt                       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_wt_version               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description              OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_creation_date            OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date          OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date            OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_priority                 OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_due_date                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_responsible              OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sc_counter               OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_min_rows                 OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_max_rows                 OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_complete                 OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_cf                 OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_descr_doc                OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc_version        OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_date1                    OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date2                    OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date3                    OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date4                    OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date5                    OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_ws_class                 OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_modify             OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active                   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                       OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                       OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows               IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause          IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows                IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectWorksheet
(a_col_id                   IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp                   IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value                IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_operator             IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_col_andor                IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_col_nr_of_rows           IN      NUMBER,                    /* NUM_TYPE */
 a_ws                       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_wt                       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_wt_version               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description              OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_creation_date            OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date          OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date            OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_priority                 OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_due_date                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_responsible              OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sc_counter               OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_min_rows                 OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_max_rows                 OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_complete                 OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_cf                 OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_descr_doc                OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc_version        OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_date1                    OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date2                    OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date3                    OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date4                    OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date5                    OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_ws_class                 OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_allow_modify             OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active                   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                       OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                       OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows               IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause          IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows                IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SelectWsGkValues
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

FUNCTION SelectWsGkValues
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

FUNCTION SelectWsPropValues
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

FUNCTION SelectWsPropValues
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

FUNCTION DeleteWorksheet
(a_ws            IN  VARCHAR2,                         /* VC20_TYPE */
 a_modify_reason IN  VARCHAR2)                         /* VC255_TYPE */
RETURN NUMBER;

FUNCTION Save1WsScRow
(a_ws               IN     VARCHAR2,                   /* VC20_TYPE */
 a_rownr            IN OUT NUMBER,                     /* NUM_TYPE */
 a_ws_modify_flag   IN OUT NUMBER,                     /* NUM_TYPE */
 a_sc               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateWorksheet
(a_wt               IN     VARCHAR2,                   /* VC20_TYPE */
 a_wt_version       IN OUT VARCHAR2,                   /* VC20_TYPE */
 a_ws               IN OUT VARCHAR2,                   /* VC20_TYPE */
 a_ref_date         IN     DATE,                       /* DATE_TYPE */
 a_userid           IN     VARCHAR2,                   /* VC40_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                     /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateWsSample
(a_ws               IN     VARCHAR2,                   /* VC20_TYPE */
 a_rownr            IN OUT NUMBER,                     /* NUM_TYPE */
 a_st               IN     VARCHAR2,                   /* VC20_TYPE */
 a_st_version       IN OUT VARCHAR2,                   /* VC20_TYPE */
 a_sc               IN OUT VARCHAR2,                   /* VC20_TYPE */
 a_create_ic        IN     VARCHAR2,                   /* VC40_TYPE */
 a_create_pg        IN     VARCHAR2,                   /* VC40_TYPE */
 a_ref_date         IN     DATE,                       /* DATE_TYPE */
 a_userid           IN     VARCHAR2,                   /* VC40_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                     /* NUM_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GenerateWorksheetCode
(a_wt               IN     VARCHAR2,                   /* VC20_TYPE */
 a_wt_version       IN OUT VARCHAR2,                   /* VC20_TYPE */
 a_ref_date         IN     DATE,                       /* DATE_TYPE */
 a_fieldtype_tab    IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_fieldnames_tab   IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_fieldvalues_tab  IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN     NUMBER,                     /* NUM_TYPE */
 a_ws               OUT    VARCHAR2,                   /* VC20_TYPE */
 a_edit_allowed     OUT    CHAR,                       /* CHAR1_TYPE */
 a_valid_cf         OUT    VARCHAR2)                   /* VC20_TYPE */
RETURN NUMBER;

END unapiws;