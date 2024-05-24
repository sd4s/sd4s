create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapipa3 AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION SaveScParameter                               /* INTERNAL */
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

END unapipa3;