create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapipg AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetScParameterGroup
(a_sc                     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg                     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode                 OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pp_version             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key1                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key2                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key3                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key4                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key5                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_value_f                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s                OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_unit                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date          OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_executor               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_planned_executor       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_entered       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_assign_date            OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_assigned_by            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_added         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_format                 OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_confirm_assign         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_any_pr           OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_never_create_methods   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_delay                  OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_delay_unit             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_log_hs                 OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_reanalysis             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pg_class               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_allow_modify           OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active                 OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                     OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                     OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows             IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause           IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

/* used by proCX */
FUNCTION InitScParameterGroup
(a_pp                     IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_version_in          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key1                IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key2                IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key3                IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key4                IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key5                IN      VARCHAR2,                  /* VC20_TYPE */
 a_seq                    IN      NUMBER,                    /* NUM_TYPE */
 a_sc                     IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_version             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_value_f                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s                OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_unit                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date          OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_executor               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_planned_executor       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_entered       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_assign_date            OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_assigned_by            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_added         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_format                 OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_confirm_assign         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_any_pr           OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_never_create_methods   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_delay                  OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_delay_unit             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_reanalysis             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pg_class               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                 OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                     OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows             IN OUT  NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION InitScPgDetails
(a_st               IN      VARCHAR2,                  /* VC20_TYPE */
 a_st_version       IN OUT  VARCHAR2,                  /* VC20_TYPE */
 a_pp               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_version       IN OUT  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2,                  /* VC20_TYPE */
 a_sc               IN      VARCHAR2,                  /* VC20_TYPE */
 a_filter_freq      IN      CHAR,                      /* CHAR1_TYPE */
 a_ref_date         IN      DATE,                      /* DATE_TYPE */
 a_pa               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pr_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description      OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_value_f          OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s          OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_unit             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date  OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date    OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_executor         OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_planned_executor OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_entered OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_assign_date      OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_assigned_by      OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_added   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_format           OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_td_info          OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_td_info_unit     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_confirm_uid      OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_any_me     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_delay            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_delay_unit       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_min_nr_results   OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_calc_method      OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_calc_cf          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_alarm_order      OUT     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_valid_specsa     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_specsb     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_specsc     OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_limitsa    OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_limitsb    OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_limitsc    OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_targeta    OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_targetb    OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_valid_targetc    OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_mt               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_mt_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_mt_nr_measur     OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_log_exceptions   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_reanalysis       OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pa_class         OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs           OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

/* used by proCX */
FUNCTION SaveScParameterGroup
(a_sc                     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg                     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode                 IN OUT  UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pp_version             IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key1                IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key2                IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key3                IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key4                IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key5                IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description            IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_value_f                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s                IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_unit                   IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date        IN      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date          IN OUT  UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_executor               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_planned_executor       IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_entered       IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_assign_date            IN      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_assigned_by            IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_manually_added         IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_format                 IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_confirm_assign         IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_any_pr           IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_never_create_methods   IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_delay                  IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_delay_unit             IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg_class               IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                 IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details         IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                     IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version             IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_modify_flag            IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows             IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason          IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION ReanalScPgDetails
(a_sc                IN      VARCHAR2,                 /* VC20_TYPE */
 a_pg                IN      VARCHAR2,                 /* VC20_TYPE */
 a_pgnode            IN      NUMBER,                   /* LONG_TYPE */
 a_modify_reason     IN      VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateScPgDetails
(a_st               IN      VARCHAR2,                  /* VC20_TYPE */
 a_st_version       IN OUT  VARCHAR2,                  /* VC20_TYPE */
 a_pp               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_version       IN OUT  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2,                  /* VC20_TYPE */
 a_seq              IN      NUMBER,                    /* NUM_TYPE */
 a_sc               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pgnode           IN      NUMBER,                    /* LONG_TYPE */
 a_filter_freq      IN      CHAR,                      /* CHAR1_TYPE */
 a_ref_date         IN      DATE,                      /* DATE_TYPE */
 a_modify_reason    IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

/* next pg not always in db: next_pgnode is the way used to pass a virtual next pg created later */
FUNCTION CreateScPgDetails2                            /* INTERNAL */
(a_st               IN      VARCHAR2,                  /* VC20_TYPE */
 a_st_version       IN OUT  VARCHAR2,                  /* VC20_TYPE */
 a_pp               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_version       IN OUT  VARCHAR2,                  /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2,                  /* VC20_TYPE */
 a_seq              IN      NUMBER,                    /* NUM_TYPE */
 a_sc               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pgnode           IN      NUMBER,                    /* LONG_TYPE */
 a_next_pgnode      IN      NUMBER,                    /* LONG_TYPE */
 a_filter_freq      IN      CHAR,                      /* CHAR1_TYPE */
 a_ref_date         IN      DATE,                      /* DATE_TYPE */
 a_modify_reason    IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION AddScPgDetails
(a_sc               IN      VARCHAR2,                  /* VC20_TYPE */
 a_st               IN      VARCHAR2,                  /* VC20_TYPE */
 a_st_version       IN      VARCHAR2,                  /* VC20_TYPE */
 a_pg               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pgnode           IN      NUMBER,                    /* LONG_TYPE */
 a_pr               IN      VARCHAR2,                  /* VC20_TYPE */
 a_pr_version       IN      VARCHAR2,                  /* VC20_TYPE */
 a_seq              IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason    IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CopyScPgDetails
(a_sc_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode_from    IN        NUMBER,                   /* LONG_TYPE */
 a_st_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_st_to_version  IN        VARCHAR2,                 /* VC20_TYPE */
 a_sc_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode_to      IN        NUMBER,                   /* LONG_TYPE */
 a_copy_methods   IN        CHAR,                     /* CHAR1_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CopyScPgPaResults
(a_sc_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg_from        IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode_from    IN        NUMBER,                   /* LONG_TYPE */
 a_st_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_st_to_version  IN        VARCHAR2,                 /* VC20_TYPE */
 a_sc_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_pg_to          IN        VARCHAR2,                 /* VC20_TYPE */
 a_pgnode_to      IN        NUMBER,                   /* LONG_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetFullTestPlan
(a_object_tp             IN      VARCHAR2,                  /* VC4_TYPE */
 a_object_id             IN      VARCHAR2,                  /* VC20_TYPE */
 a_object_version        IN      VARCHAR2,                  /* VC20_TYPE */
 a_tst_tp                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_id                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_id_version        OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_seq                OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pr_seq                OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_mt_seq                OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pp_key1               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key2               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key3               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key4               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key5               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_description       OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_tst_nr_measur         OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_tst_already_assigned  OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                    /* NUM_TYPE */
 a_next_rows             IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveFullTestPlan
(a_sc                    IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sc_nr_of_rows         IN      NUMBER,                    /* NUM_TYPE */
 a_tst_tp                IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_id                IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_id_version        IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_seq                IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pr_seq                IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_mt_seq                IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pp_key1               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key2               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key3               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key4               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key5               IN OUT  UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_nr_measur         IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_modify_flag           IN OUT  UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                    /* NUM_TYPE */
 a_next_rows             IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetTestPlanAttributes
(a_object_tp            IN      VARCHAR2,                  /* VC4_TYPE */
 a_object_id            IN      VARCHAR2,                  /* VC20_TYPE */
 a_object_version       IN      VARCHAR2,                  /* VC20_TYPE */
 a_tst_tp               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_id               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_tst_id_version       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_seq               OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pr_seq               OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_mt_seq               OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_pp_key1              OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key2              OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key3              OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key4              OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pp_key5              OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value                OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description          OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_single_valued        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_new_val_allowed      OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_store_db             OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_value_list_tp        OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_run_mode             OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_service              OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE  */
 a_cf_value             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER,                    /* NUM_TYPE */
 a_next_rows            IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetSupplierAndCustomer                            /* INTERNAL */
(a_pp_key1              IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key2              IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key3              IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key4              IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key5              IN      VARCHAR2,                  /* VC20_TYPE */
 a_supplier             OUT     VARCHAR2,                  /* VC20_TYPE */
 a_customer             OUT     VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION SQLIsSupplierOrCustomerPp                         /* INTERNAL */
(a_pp_key1              IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key2              IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key3              IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key4              IN      VARCHAR2,                  /* VC20_TYPE */
 a_pp_key5              IN      VARCHAR2)                  /* VC20_TYPE */
RETURN VARCHAR2;

END unapipg;