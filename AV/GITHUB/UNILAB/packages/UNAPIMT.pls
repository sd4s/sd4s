create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapimt AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetMethodList
(a_mt                      OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2,                  /* VC511_TYPE */
 a_next_rows               IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetMethod
(a_mt                      OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version                 OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current      OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT    UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till          OUT    UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_description             OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description2            OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_unit                    OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_est_cost                OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_est_time                OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_accuracy                OUT    UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_is_template             OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_calibration             OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_autorecalc              OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_confirm_complete        OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_auto_create_cells       OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_me_result_editable      OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_executor                OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_eq_tp                   OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sop                     OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_sop_version             OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_plaus_low               OUT    UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_plaus_high              OUT    UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_winsize_x               OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_winsize_y               OUT    UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sc_lc                   OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_sc_lc_version           OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_def_val_tp              OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_def_au_level            OUT    UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_def_val                 OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_format                  OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_inherit_au              OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_mt_class                OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                  OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active                  OUT    UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                      OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version              OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                      OUT    UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN     VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetMtCell
(a_mt                     OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version                OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_cell                   OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_dsp_title              OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_title2             OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_value_f                OUT      UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s                OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_pos_x                  OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_pos_y                  OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_align                  OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_cell_tp                OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_winsize_x              OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_winsize_y              OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_is_protected           OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_mandatory              OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_hidden                 OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_input_tp               OUT      UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_input_source           OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_input_source_version   OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_input_pp               OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_input_pp_version       OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_input_pr               OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_input_pr_version       OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_input_mt               OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_input_mt_version       OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_def_val_tp             OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_def_au_level           OUT      UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_save_tp                OUT      UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE  */
 a_save_pp                OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_save_pp_version        OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_save_pr                OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_save_pr_version        OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_save_mt                OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_save_mt_version        OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_save_eq_tp             OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_save_id                OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_save_id_version        OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_component              OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_unit                   OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_format                 OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_calc_tp                OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_calc_formula           OUT      UNAPIGEN.VC2000_TABLE_TYPE, /* VC2000_TABLE_TYPE */
 a_valid_cf               OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_max_x                  OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_max_y                  OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_multi_select           OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_create_new             OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows             IN OUT   NUMBER,                     /* NUM_TYPE */
 a_where_clause           IN       VARCHAR2,                   /* VC511_TYPE */
 a_next_rows              IN       NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetMtCellSpin
(a_mt                  OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version             OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_cell                OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_circular            OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_incr                OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_low_val_tp          OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_low_au_level        OUT      UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_low_val             OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_high_val_tp         OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_high_au_level       OUT      UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_high_val            OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN       VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN       NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetMtCellEqType
(a_mt                  OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_version             OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_cell                OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_eq_tp               OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER,                      /* NUM_TYPE */
 a_where_clause        IN       VARCHAR2,                    /* VC511_TYPE */
 a_next_rows           IN       NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetMtCellValue
(a_mt                  OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_version             OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_cell                OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_index_x             OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_index_y             OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_value_f             OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s             OUT      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_selected            OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER,                      /* NUM_TYPE */
 a_where_clause        IN       VARCHAR2,                    /* VC511_TYPE */
 a_next_rows           IN       NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteMethod
(a_mt                  IN       VARCHAR2,                    /* VC20_TYPE */
 a_version             IN       VARCHAR2,                    /* VC20_TYPE */
 a_modify_reason       IN       VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveMethod
(a_mt                      IN       VARCHAR2,                /* VC20_TYPE */
 a_version                 IN       VARCHAR2,                /* VC20_TYPE */
 a_version_is_current      IN       CHAR,                    /* CHAR1_TYPE */
 a_effective_from          IN       DATE,                    /* DATE_TYPE */
 a_effective_till          IN       DATE,                    /* DATE_TYPE */
 a_description             IN       VARCHAR2,                /* VC40_TYPE */
 a_description2            IN       VARCHAR2,                /* VC40_TYPE */
 a_unit                    IN       VARCHAR2,                /* VC20_TYPE */
 a_est_cost                IN       VARCHAR2,                /* VC40_TYPE */
 a_est_time                IN       VARCHAR2,                /* VC40_TYPE */
 a_accuracy                IN       NUMBER,                  /* FLOAT_TYPE + INDICATOR */
 a_is_template             IN       CHAR,                    /* CHAR1_TYPE */
 a_calibration             IN       CHAR,                    /* CHAR1_TYPE */
 a_autorecalc              IN       CHAR,                    /* CHAR1_TYPE */
 a_confirm_complete        IN       CHAR,                    /* CHAR1_TYPE */
 a_auto_create_cells       IN       CHAR,                    /* CHAR1_TYPE */
 a_me_result_editable      IN       CHAR,                    /* CHAR1_TYPE */
 a_executor                IN       VARCHAR2,                /* VC20_TYPE */
 a_eq_tp                   IN       VARCHAR2,                /* VC20_TYPE */
 a_sop                     IN       VARCHAR2,                /* VC40_TYPE */
 a_sop_version             IN       VARCHAR2,                /* VC20_TYPE */
 a_plaus_low               IN       NUMBER,                  /* FLOAT_TYPE + INDICATOR */
 a_plaus_high              IN       NUMBER,                  /* FLOAT_TYPE + INDICATOR */
 a_winsize_x               IN       NUMBER,                  /* NUM_TYPE */
 a_winsize_y               IN       NUMBER,                  /* NUM_TYPE */
 a_sc_lc                   IN       VARCHAR2,                /* VC2_TYPE */
 a_sc_lc_version           IN       VARCHAR2,                /* VC20_TYPE */
 a_def_val_tp              IN       CHAR,                    /* CHAR1_TYPE */
 a_def_au_level            IN       VARCHAR2,                /* VC4_TYPE */
 a_def_val                 IN       VARCHAR2,                /* VC40_TYPE */
 a_format                  IN       VARCHAR2,                /* VC40_TYPE */
 a_inherit_au              IN       CHAR,                    /* CHAR1_TYPE */
 a_mt_class                IN       VARCHAR2,                /* VC2_TYPE */
 a_log_hs                  IN       CHAR,                    /* CHAR1_TYPE */
 a_lc                      IN       VARCHAR2,                /* VC2_TYPE */
 a_lc_version              IN       VARCHAR2,                /* VC20_TYPE */
 a_modify_reason           IN       VARCHAR2)                /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveMtCell
(a_mt                      IN       VARCHAR2,                    /* VC20_TYPE */
 a_version                 IN       VARCHAR2,                    /* VC20_TYPE */
 a_cell                    IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_dsp_title               IN       UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_title2              IN       UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_value_f                 IN       UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s                 IN       UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_pos_x                   IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_pos_y                   IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_align                   IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_cell_tp                 IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_winsize_x               IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_winsize_y               IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_is_protected            IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory               IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_hidden                  IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_input_tp                IN       UNAPIGEN.VC4_TABLE_TYPE,     /* VC4_TABLE_TYPE */
 a_input_source            IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_input_source_version    IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_input_pp                IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_input_pp_version        IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_input_pr                IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_input_pr_version        IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_input_mt                IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_input_mt_version        IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_def_val_tp              IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_def_au_level            IN       UNAPIGEN.VC4_TABLE_TYPE,     /* VC4_TABLE_TYPE */
 a_save_tp                 IN       UNAPIGEN.VC4_TABLE_TYPE,     /* VC4_TABLE_TYPE  */
 a_save_pp                 IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_save_pp_version         IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_save_pr                 IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_save_pr_version         IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_save_mt                 IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_save_mt_version         IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_save_eq_tp              IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_save_id                 IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_save_id_version         IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_component               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_unit                    IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_format                  IN       UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_calc_tp                 IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_calc_formula            IN       UNAPIGEN.VC2000_TABLE_TYPE,  /* VC2000_TABLE_TYPE */
 a_valid_cf                IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_max_x                   IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_max_y                   IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_multi_select            IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_create_new              IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows              IN       NUMBER,                      /* NUM_TYPE */
 a_next_rows               IN       NUMBER,                      /* NUM_TYPE */
 a_modify_reason           IN       VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveMtCellSpin
(a_mt             IN       VARCHAR2,                    /* VC20_TYPE */
 a_version        IN       VARCHAR2,                    /* VC20_TYPE */
 a_cell           IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_circular       IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_incr           IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_low_val_tp     IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_low_au_level   IN       UNAPIGEN.VC4_TABLE_TYPE,     /* VC4_TABLE_TYPE */
 a_low_val        IN       UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_high_val_tp    IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_high_au_level  IN       UNAPIGEN.VC4_TABLE_TYPE,     /* VC4_TABLE_TYPE */
 a_high_val       IN       UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_nr_of_rows     IN       NUMBER,                      /* NUM_TYPE */
 a_next_rows      IN       NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveMtCellEqType
(a_mt             IN       VARCHAR2,                    /* VC20_TYPE */
 a_version        IN       VARCHAR2,                    /* VC20_TYPE */
 a_cell           IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_eq_tp          IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows     IN       NUMBER,                      /* NUM_TYPE */
 a_next_rows      IN       NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveMtCellValue
(a_mt             IN       VARCHAR2,                    /* VC20_TYPE */
 a_version        IN       VARCHAR2,                    /* VC20_TYPE */
 a_cell           IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_index_x        IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_index_y        IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_value_f        IN       UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_value_s        IN       UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_selected       IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows     IN       NUMBER,                      /* NUM_TYPE */
 a_next_rows      IN       NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetMtCellList
(a_cell                OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN       VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN       NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetMtMeasurementRanges
(a_mt                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_component               OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_l_detection_limit       OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_l_determ_limit          OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_h_determ_limit          OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_h_detection_limit       OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_unit                    OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_nr_of_rows              IN OUT   NUMBER,                      /* NUM_TYPE         */
 a_where_clause            IN       VARCHAR2)                    /* VC511_TYPE       */
RETURN NUMBER;

FUNCTION SaveMtMeasurementRanges
(a_mt                      IN       VARCHAR2,                    /* VC20_TYPE        */
 a_version                 IN       VARCHAR2,                    /* VC20_TYPE        */
 a_component               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_l_detection_limit       IN       UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_l_determ_limit          IN       UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_h_determ_limit          IN       UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_h_detection_limit       IN       UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_unit                    IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_nr_of_rows              IN       NUMBER,                      /* NUM_TYPE         */
 a_modify_reason           IN       VARCHAR2)                    /* VC255_TYPE       */
RETURN NUMBER;

FUNCTION GetMtExperienceLevel
(a_mt                  OUT      UNAPIGEN.VC20_TABLE_TYPE,      /* VC20_TABLE_TYPE */
 a_version             OUT      UNAPIGEN.VC20_TABLE_TYPE,      /* VC20_TABLE_TYPE */
 a_el                  OUT      UNAPIGEN.VC20_TABLE_TYPE,      /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER,                        /* NUM_TYPE */
 a_where_clause        IN       VARCHAR2)                      /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveMtExperienceLevel
(a_mt                      IN       VARCHAR2,                    /* VC20_TYPE        */
 a_version                 IN       VARCHAR2,                    /* VC20_TYPE        */
 a_el                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_nr_of_rows              IN       NUMBER,                      /* NUM_TYPE         */
 a_modify_reason           IN       VARCHAR2)                    /* VC255_TYPE       */
RETURN NUMBER;

FUNCTION GetAllowedEqList
(a_mt                  IN       VARCHAR2,                   /* VC20_TYPE */
 a_version             IN       VARCHAR2,                   /* VC20_TYPE */
 a_cell                IN       VARCHAR2,                   /* VC20_TYPE */
 a_lab                 IN       VARCHAR2,                   /* VC20_TYPE */
 a_eq                  OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_ss                  OUT      UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_ca_warn_level       OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION CopyMethod
(a_mt             IN        VARCHAR2,                 /* VC20_TYPE */
 a_version        IN        VARCHAR2,                 /* VC20_TYPE */
 a_cp_mt          IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_cp_version     IN OUT    VARCHAR2,                 /* VC20_TYPE */
 a_modify_reason  IN        VARCHAR2)                 /* VC255_TYPE */
RETURN NUMBER;

END unapimt;