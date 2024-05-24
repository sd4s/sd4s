create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapich AS

/* SelectChart FROM and WHERE clause variable, used in GetChGroupKey */
P_SELECTION_CLAUSE               VARCHAR2(4000);
P_SELECTION_VAL_TAB              VC40_NESTEDTABLE_TYPE := VC40_NESTEDTABLE_TYPE();

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION SaveChart
(a_ch               IN    VARCHAR2, /* VC20_TYPE */
a_cy                IN    VARCHAR2, /* VC20_TYPE */
a_cy_version        IN    VARCHAR2, /* VC20_TYPE */
a_description       IN    VARCHAR2, /* VC40_TYPE */
a_chart_title       IN    VARCHAR2, /* VC255_TYPE */
a_x_axis_title      IN    VARCHAR2, /* VC255_TYPE */
a_y_axis_title      IN    VARCHAR2, /* VC255_TYPE */
a_y_axis_unit       IN    VARCHAR2, /* VC20_TYPE */
a_creation_date     IN    DATE    , /* DATE_TYPE */
a_ch_context_key    IN    VARCHAR2, /* VC255_TYPE */
a_datapoint_cnt     IN    NUMBER  , /* NUM_TYPE */
a_datapoint_unit    IN    VARCHAR2, /* VC20_TYPE */
a_xr_measurements   IN    NUMBER  , /* NUM_TYPE */
a_xr_max_charts     IN    NUMBER  , /* NUM_TYPE */
a_sqc_avg           IN    NUMBER  , /* FLOAT_TYPE */
a_sqc_std_dev       IN    NUMBER  , /* FLOAT_TYPE */
a_sqc_avg_range     IN    NUMBER  , /* FLOAT_TYPE */
a_sqc_std_dev_range IN    NUMBER  , /* FLOAT_TYPE */
a_exec_start_date   IN    DATE    , /* DATE_TYPE */
a_exec_end_date     IN    DATE    , /* DATE_TYPE */
a_assign_cf         IN    VARCHAR2, /* VC255_TYPE */
a_cy_calc_cf        IN    VARCHAR2, /* VC255_TYPE */
a_visual_cf         IN    VARCHAR2, /* VC255_TYPE */
a_xr_serie_seq      IN    NUMBER  , /* NUM_TYPE */
a_ch_class          IN    VARCHAR2, /* VC2_TYPE */
a_log_hs            IN    CHAR    , /* CHAR1_TYPE */
a_log_hs_details    IN    CHAR    , /* CHAR1_TYPE */
a_lc                IN    VARCHAR2, /* VC2_TYPE */
a_lc_version        IN    VARCHAR2, /* VC20_TYPE */
a_modify_reason     IN    VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveChart
(a_ch               IN    VARCHAR2, /* VC20_TYPE */
a_cy                IN    VARCHAR2, /* VC20_TYPE */
a_cy_version        IN    VARCHAR2, /* VC20_TYPE */
a_description       IN    VARCHAR2, /* VC40_TYPE */
a_chart_title       IN    VARCHAR2, /* VC255_TYPE */
a_x_axis_title      IN    VARCHAR2, /* VC255_TYPE */
a_y_axis_title      IN    VARCHAR2, /* VC255_TYPE */
a_y_axis_unit       IN    VARCHAR2, /* VC20_TYPE */
a_creation_date     IN    DATE    , /* DATE_TYPE */
a_ch_context_key    IN    VARCHAR2, /* VC255_TYPE */
a_datapoint_cnt     IN    NUMBER  , /* NUM_TYPE */
a_datapoint_unit    IN    VARCHAR2, /* VC20_TYPE */
a_xr_measurements   IN    NUMBER  , /* NUM_TYPE */
a_xr_max_charts     IN    NUMBER  , /* NUM_TYPE */
a_sqc_avg           IN    NUMBER  , /* FLOAT_TYPE */
a_sqc_std_dev       IN    NUMBER  , /* FLOAT_TYPE */
a_sqc_avg_range     IN    NUMBER  , /* FLOAT_TYPE */
a_sqc_std_dev_range IN    NUMBER  , /* FLOAT_TYPE */
a_exec_start_date   IN    DATE    , /* DATE_TYPE */
a_exec_end_date     IN    DATE    , /* DATE_TYPE */
a_assign_cf         IN    VARCHAR2, /* VC255_TYPE */
a_cy_calc_cf        IN    VARCHAR2, /* VC255_TYPE */
a_visual_cf         IN    VARCHAR2, /* VC255_TYPE */
a_valid_sqc_rule1   IN    VARCHAR2, /* VC255_TYPE */
a_valid_sqc_rule2   IN    VARCHAR2, /* VC255_TYPE */
a_valid_sqc_rule3   IN    VARCHAR2, /* VC255_TYPE */
a_valid_sqc_rule4   IN    VARCHAR2, /* VC255_TYPE */
a_valid_sqc_rule5   IN    VARCHAR2, /* VC255_TYPE */
a_valid_sqc_rule6   IN    VARCHAR2, /* VC255_TYPE */
a_valid_sqc_rule7   IN    VARCHAR2, /* VC255_TYPE */
a_xr_serie_seq      IN    NUMBER  , /* NUM_TYPE */
a_ch_class          IN    VARCHAR2, /* VC2_TYPE */
a_log_hs            IN    CHAR    , /* CHAR1_TYPE */
a_log_hs_details    IN    CHAR    , /* CHAR1_TYPE */
a_lc                IN    VARCHAR2, /* VC2_TYPE */
a_lc_version        IN    VARCHAR2, /* VC20_TYPE */
a_modify_reason     IN    VARCHAR2) /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetChart
(a_ch                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description          OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_chart_title          OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_x_axis_title         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_y_axis_title         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_y_axis_unit          OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_creation_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_ch_context_key       OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_datapoint_cnt        OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_datapoint_unit       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_xr_measurements      OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_xr_max_charts        OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sqc_avg              OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev          OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_avg_range        OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev_range    OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_exec_start_date      OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_assign_cf            OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cy_calc_cf           OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_visual_cf            OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_xr_serie_seq         OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ch_class             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
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

FUNCTION GetChart
(a_ch                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description          OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_chart_title          OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_x_axis_title         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_y_axis_title         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_y_axis_unit          OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_creation_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_ch_context_key       OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_datapoint_cnt        OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_datapoint_unit       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_xr_measurements      OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_xr_max_charts        OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sqc_avg              OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev          OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_avg_range        OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev_range    OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_exec_start_date      OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_assign_cf            OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cy_calc_cf           OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_visual_cf            OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule1      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule2      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule3      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule4      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule5      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule6      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule7      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_xr_serie_seq         OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ch_class             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
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

FUNCTION CreateChart
(a_cy                   IN      VARCHAR2,       /* VC20_TYPE */
 a_cy_version           IN OUT  VARCHAR2,       /* VC20_TYPE */
 a_ch                   IN OUT  VARCHAR2,       /* VC20_TYPE */
 a_ch_context_key       IN      VARCHAR2,       /* VC255_TYPE */
 a_ref_date             IN      DATE,           /* DATE_TYPE */
 a_userid               IN      VARCHAR2,       /* VC40_TYPE */
 a_modify_reason        IN      VARCHAR2)       /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetChDatapoint
(a_ch                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_seq        OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_measure_seq          OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_x_value_f            OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_x_value_s            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_x_value_d            OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_datapoint_value_f    OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_datapoint_value_s    OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_label      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_datapoint_marker     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_colour     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_link       OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_z_value_f            OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_z_value_s            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_range      OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sqc_avg              OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_avg_range        OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev          OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev_range    OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec1                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec2                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec3                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec4                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec5                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec6                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec7                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec8                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec9                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec10               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec11               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec12               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec13               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec14               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec15               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_active               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause         IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER ;

FUNCTION GetChDatapoint
(a_ch                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_seq        OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_measure_seq          OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_x_value_f            OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_x_value_s            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_x_value_d            OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_datapoint_value_f    OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_datapoint_value_s    OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_label      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_datapoint_marker     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_colour     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_link       OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_z_value_f            OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_z_value_s            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_range      OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sqc_avg              OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_avg_range        OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev          OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev_range    OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec1                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec2                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec3                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec4                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec5                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec6                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec7                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec8                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec9                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec10               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec11               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec12               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec13               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec14               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec15               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_active               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause         IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows            IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetChDatapoint
(a_ch                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_seq        OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_measure_seq          OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_x_value_f            OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_x_value_s            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_x_value_d            OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_datapoint_value_f    OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_datapoint_value_s    OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_label      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_datapoint_marker     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_colour     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_link       OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_z_value_f            OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_z_value_s            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_range      OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sqc_avg              OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_avg_range        OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev          OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev_range    OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec1                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec2                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec3                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec4                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec5                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec6                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec7                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec8                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec9                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec10               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec11               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec12               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec13               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec14               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec15               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_active               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule1_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule2_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule3_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule4_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule5_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule6_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule7_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause         IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER ;

FUNCTION GetChDatapoint
(a_ch                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_seq        OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_measure_seq          OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_x_value_f            OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_x_value_s            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_x_value_d            OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_datapoint_value_f    OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_datapoint_value_s    OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_label      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_datapoint_marker     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_colour     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_link       OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_z_value_f            OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_z_value_s            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_range      OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sqc_avg              OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_avg_range        OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev          OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev_range    OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec1                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec2                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec3                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec4                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec5                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec6                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec7                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec8                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec9                OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec10               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec11               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec12               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec13               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec14               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec15               OUT     UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_active               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule1_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule2_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule3_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule4_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule5_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule6_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule7_violated       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause         IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows            IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveChDatapoint
(a_ch                   IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_seq        IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_measure_seq          IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_x_value_f            IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_x_value_s            IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_x_value_d            IN      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_datapoint_value_f    IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_datapoint_value_s    IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_label      IN      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_datapoint_marker     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_colour     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_link       IN      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_z_value_f            IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_z_value_s            IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_range      IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sqc_avg              IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_avg_range        IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev          IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev_range    IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec1                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec2                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec3                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec4                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec5                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec6                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec7                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec8                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec9                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec10               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec11               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec12               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec13               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec14               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec15               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_active               IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows           IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason        IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveChDatapoint
(a_ch                   IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_seq        IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_measure_seq          IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_x_value_f            IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_x_value_s            IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_x_value_d            IN      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_datapoint_value_f    IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_datapoint_value_s    IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_label      IN      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_datapoint_marker     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_colour     IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_datapoint_link       IN      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_z_value_f            IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_z_value_s            IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_datapoint_range      IN      UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sqc_avg              IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_avg_range        IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev          IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev_range    IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec1                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec2                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec3                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec4                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec5                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec6                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec7                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec8                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec9                IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec10               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec11               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec12               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec13               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec14               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_spec15               IN      UNAPIGEN.FLOAT_TABLE_TYPE, /* FLOAT_TABLE_TYPE + INDICATOR */
 a_active               IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule1_violated       IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule2_violated       IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule3_violated       IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule4_violated       IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule5_violated       IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule6_violated       IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_rule7_violated       IN      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows           IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason        IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SelectChart
(a_col_id               IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp               IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value            IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_operator         IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_col_andor            IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_col_nr_of_rows       IN      NUMBER,                    /* NUM_TYPE */
 a_ch                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description          OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_chart_title          OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_x_axis_title         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_y_axis_title         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_y_axis_unit          OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_creation_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_ch_context_key       OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_datapoint_cnt        OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_datapoint_unit       OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_xr_measurements      OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_xr_max_charts        OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_sqc_avg              OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev          OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_avg_range        OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_sqc_std_dev_range    OUT     UNAPIGEN.FLOAT_TABLE_TYPE,  /* FLOAT_TABLE_TYPE + INDICATOR */
 a_exec_start_date      OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date        OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_assign_cf            OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cy_calc_cf           OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_visual_cf            OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule1      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule2      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule3      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule4      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule5      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule6      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_valid_sqc_rule7      OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_xr_serie_seq         OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ch_class             OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details       OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify         OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ar                   OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active               OUT     UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                   OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                   OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows           IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause      IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows            IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

END unapich;