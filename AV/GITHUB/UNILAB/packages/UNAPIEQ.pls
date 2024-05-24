create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapieq AS

/* Global variable used in UNAPIEQ l_scmecellinput_cursor CURSOR */
/* This cursor is used to update the Methods using the EqCte modified.
/* Setting this value to 'TRUE' will use an alternative query, using the UTSCMEGKINEXECUTION groupkey  */
P_USE_MEGKINEXECUTION4EQCTE BOOLEAN DEFAULT FALSE;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetEquipmentList
(a_eq                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_lab                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_description             OUT     UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE  */
 a_ss                      OUT     UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE   */
 a_ca_warn_level           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE  */
 a_nr_of_rows              IN OUT  NUMBER,                       /* NUM_TYPE         */
 a_where_clause            IN      VARCHAR2,                     /* VC511_TYPE       */
 a_next_rows               IN      NUMBER)                       /* NUM_TYPE         */
RETURN NUMBER;

FUNCTION GetEquipment
(a_eq                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_lab                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_description             OUT     UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE  */
 a_serial_no               OUT     UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_supplier                OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_location                OUT     UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE  */
 a_invest_cost             OUT     UNAPIGEN.FLOAT_TABLE_TYPE,    /* FLOAT_TABLE_TYPE + INDICATOR */
 a_invest_unit             OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_usage_cost              OUT     UNAPIGEN.FLOAT_TABLE_TYPE,    /* FLOAT_TABLE_TYPE + INDICATOR */
 a_usage_unit              OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_install_date            OUT     UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE  */
 a_in_service_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,     /* DATE_TABLE_TYPE  */
 a_accessories             OUT     UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE  */
 a_operation               OUT     UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_operation_doc           OUT     UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE  */
 a_usage                   OUT     UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_usage_doc               OUT     UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE  */
 a_eq_component            OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE   */
 a_keep_ctold              OUT     UNAPIGEN.FLOAT_TABLE_TYPE,    /* FLOAT_TABLE_TYPE + INDICATOR */
 a_keep_ctold_unit         OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_is_template             OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE   */
 a_log_hs                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE   */
 a_allow_modify            OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE   */
 a_active                  OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE   */
 a_ca_warn_level           OUT     UNAPIGEN.CHAR1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE   */
 a_lc                      OUT     UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE   */
 a_ss                      OUT     UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE   */
 a_nr_of_rows              IN OUT  NUMBER,                       /* NUM_TYPE         */
 a_where_clause            IN      VARCHAR2)                     /* VC511_TYPE       */
RETURN NUMBER;

FUNCTION SaveEquipment
(a_eq                      IN      VARCHAR2,                     /* VC20_TYPE        */
 a_lab                     IN      VARCHAR2,                     /* VC20_TYPE        */
 a_description             IN      VARCHAR2,                     /* VC40_TYPE        */
 a_serial_no               IN      VARCHAR2,                     /* VC255_TYPE       */
 a_supplier                IN      VARCHAR2,                     /* VC20_TYPE        */
 a_location                IN      VARCHAR2,                     /* VC40_TYPE        */
 a_invest_cost             IN      NUMBER,                       /* FLOAT_TYPE  + INDICATOR */
 a_invest_unit             IN      VARCHAR2,                     /* VC20_TYPE        */
 a_usage_cost              IN      NUMBER,                       /* FLOAT_TYPE  + INDICATOR */
 a_usage_unit              IN      VARCHAR2,                     /* VC20_TYPE        */
 a_install_date            IN      DATE,                         /* DATE_TYPE        */
 a_in_service_date         IN      DATE,                         /* DATE_TYPE        */
 a_accessories             IN      VARCHAR2,                     /* VC40_TYPE        */
 a_operation               IN      VARCHAR2,                     /* VC255_TYPE       */
 a_operation_doc           IN      VARCHAR2,                     /* VC255_TYPE       */
 a_usage                   IN      VARCHAR2,                     /* VC255_TYPE       */
 a_usage_doc               IN      VARCHAR2,                     /* VC255_TYPE       */
 a_eq_component            IN      CHAR,                         /* CHAR1_TYPE       */
 a_keep_ctold              IN      NUMBER,                       /* FLOAT_TYPE + INDICATOR */
 a_keep_ctold_unit         IN      VARCHAR2,                     /* VC20_TYPE        */
 a_is_template             IN      CHAR,                         /* CHAR1_TYPE       */
 a_log_hs                  IN      CHAR,                         /* CHAR1_TYPE       */
 a_ca_warn_level           IN      CHAR,                         /* CHAR1_TYPE       */
 a_lc                      IN      VARCHAR2,                     /* VC2_TYPE         */
 a_modify_reason           IN      VARCHAR2)                     /* VC255_TYPE       */
RETURN NUMBER;

FUNCTION DeleteEquipment
(a_eq                      IN      VARCHAR2,                     /* VC20_TYPE,       */
 a_lab                     IN      VARCHAR2,                     /* VC20_TYPE        */
 a_modify_reason           IN      VARCHAR2)                     /* VC255_TYPE       */
RETURN NUMBER;

FUNCTION GetEqConstants
(a_eq                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_lab                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_ct_name                 OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_ca                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_value_s                 OUT     UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE  */
 a_value_f                 OUT     UNAPIGEN.FLOAT_TABLE_TYPE,    /* FLOAT_TABLE_TYPE + INDICATOR */
 a_format                  OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_unit                    OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_nr_of_rows              IN OUT  NUMBER,                       /* NUM_TYPE         */
 a_where_clause            IN      VARCHAR2)                     /* VC511_TYPE       */
RETURN NUMBER;

FUNCTION SaveEqConstants
(a_eq                      IN      VARCHAR2,                    /* VC20_TYPE         */
 a_lab                     IN      VARCHAR2,                    /* VC20_TYPE         */
 a_ct_name                 IN      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE   */
 a_ca                      IN      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE   */
 a_value_s                 IN      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE   */
 a_value_f                 IN      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_format                  IN      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE   */
 a_unit                    IN      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE   */
 a_nr_of_rows              IN      NUMBER,                      /* NUM_TYPE          */
 a_modify_reason           IN      VARCHAR2)                    /* VC255_TYPE        */
RETURN NUMBER;

FUNCTION Save1EqConstant
(a_eq                      IN      VARCHAR2,                    /* VC20_TYPE   */
 a_lab                     IN      VARCHAR2,                    /* VC20_TYPE   */
 a_ct_name                 IN      VARCHAR2,                    /* VC20_TYPE   */
 a_ca                      IN      VARCHAR2,                    /* VC20_TYPE   */
 a_value_s                 IN      VARCHAR2,                    /* VC40_TYPE   */
 a_value_f                 IN      NUMBER,                      /* FLOAT_TYPE + INDICATOR */
 a_format                  IN      VARCHAR2,                    /* VC20_TYPE   */
 a_unit                    IN      VARCHAR2,                    /* VC20_TYPE   */
 a_modify_reason           IN      VARCHAR2)                    /* VC255_TYPE  */
RETURN NUMBER;

FUNCTION GetOldEqConstantList
(a_eq                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_lab                     OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_exec_start_date         OUT      UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE  */
 a_ct_name                 OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_ca                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_value_s                 OUT      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE  */
 a_value_f                 OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_format                  OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_unit                    OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_nr_of_rows              IN OUT   NUMBER,                      /* NUM_TYPE         */
 a_where_clause            IN       VARCHAR2,                    /* VC511_TYPE       */
 a_next_rows               IN       NUMBER)                      /* NUM_TYPE         */
RETURN NUMBER;

FUNCTION GetEqMeasurementRanges
(a_eq                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_lab                     OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_component               OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_l_detection_limit       OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR  */
 a_l_determ_limit          OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR  */
 a_h_determ_limit          OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR  */
 a_h_detection_limit       OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_unit                    OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_nr_of_rows              IN OUT   NUMBER,                      /* NUM_TYPE         */
 a_where_clause            IN       VARCHAR2)                    /* VC511_TYPE       */
RETURN NUMBER;

FUNCTION SaveEqMeasurementRanges
(a_eq                      IN       VARCHAR2,                    /* VC20_TYPE        */
 a_lab                     IN       VARCHAR2,                    /* VC20_TYPE        */
 a_component               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_l_detection_limit       IN       UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_l_determ_limit          IN       UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_h_determ_limit          IN       UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_h_detection_limit       IN       UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_unit                    IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_nr_of_rows              IN       NUMBER,                      /* NUM_TYPE         */
 a_modify_reason           IN       VARCHAR2)                    /* VC255_TYPE       */
RETURN NUMBER;

FUNCTION GetEqCalibration
(a_eq                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_lab                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_ca                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE  */
 a_sop                     OUT      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE  */
 a_st                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_mt                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_cal_val                 OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_cal_cost                OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_cal_time_val            OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE  */
 a_cal_time_unit           OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_freq_tp                 OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE  */
 a_freq_val                OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_freq_unit               OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_invert_freq             OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE   */
 a_last_sched              OUT      UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE  */
 a_last_val                OUT      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE  */
 a_last_cnt                OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_suspend                 OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE   */
 a_grace_val               OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_grace_unit              OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_sc                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_pg                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_pgnode                  OUT      UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_pa                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_panode                  OUT      UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_me                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_menode                  OUT      UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_reanalysis              OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_ca_warn_level           OUT      UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE  */
 a_nr_of_rows              IN OUT   NUMBER,                      /* NUM_TYPE         */
 a_where_clause            IN       VARCHAR2)                    /* VC511_TYPE       */
RETURN NUMBER;

FUNCTION SaveEqCalibration
(a_eq                      IN       VARCHAR2,                    /* VC20_TYPE        */
 a_lab                     IN       VARCHAR2,                    /* VC20_TYPE        */
 a_ca                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_description             IN       UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE  */
 a_sop                     IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_st                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_mt                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_cal_val                 IN       UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE + INDICATOR */
 a_cal_cost                IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_cal_time_val            IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE  */
 a_cal_time_unit           IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_freq_tp                 IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE  */
 a_freq_val                IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_freq_unit               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_invert_freq             IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE  */
 a_last_sched              IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_last_val                IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_last_cnt                IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_suspend                 IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE  */
 a_grace_val               IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_grace_unit              IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_sc                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_pg                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_pgnode                  IN       UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_pa                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_panode                  IN       UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_me                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_menode                  IN       UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_reanalysis              IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_ca_warn_level           IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE  */
 a_nr_of_rows              IN       NUMBER,                      /* NUM_TYPE         */
 a_modify_reason           IN       VARCHAR2)                    /* VC255_TYPE       */
RETURN NUMBER;

FUNCTION GetEqCommunication
(a_eq                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_lab                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_cd                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_setting_name            OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_setting_value           OUT     UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE  */
 a_setting_seq             OUT     UNAPIGEN.NUM_TABLE_TYPE,      /* NUM_TABLE_TYPE   */
 a_nr_of_rows              IN OUT  NUMBER,                       /* NUM_TYPE         */
 a_where_clause            IN      VARCHAR2)                     /* VC511_TYPE       */
RETURN NUMBER;

FUNCTION SaveEqCommunication
(a_eq                      IN      VARCHAR2,                    /* VC20_TYPE         */
 a_lab                     IN      VARCHAR2,                    /* VC20_TYPE         */
 a_cd                      IN      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE   */
 a_setting_name            IN      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE   */
 a_setting_value           IN      UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE   */
 a_setting_seq             IN      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE    */
 a_nr_of_rows              IN      NUMBER,                      /* NUM_TYPE          */
 a_modify_reason           IN      VARCHAR2)                    /* VC255_TYPE        */
RETURN NUMBER;

FUNCTION GetCdEntries
(a_cd                      OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_setting_name            OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_setting_value           OUT    UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows              IN OUT NUMBER,                     /* NUM_TYPE */
 a_where_clause            IN     VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetComponentList
(a_component        OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION StartInstrument
(a_eq                      IN    VARCHAR2,                    /* VC20_TYPE         */
 a_lab                     IN    VARCHAR2)                    /* VC20_TYPE         */
RETURN NUMBER;

FUNCTION StopInstrument
(a_eq                      IN    VARCHAR2,                    /* VC20_TYPE         */
 a_lab                     IN    VARCHAR2)                    /* VC20_TYPE         */
RETURN NUMBER;

FUNCTION GetEqChartType
(a_eq                    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_lab                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy                    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ct_name               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause          IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveEqChartType
(a_eq                     IN    VARCHAR2,                     /* VC20_TYPE */
 a_lab                    IN    VARCHAR2,                     /* VC20_TYPE */
 a_cy                     IN    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_cy_version             IN    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_ct_name                IN    UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE */
 a_nr_of_rows             IN    NUMBER,                       /* NUM_TYPE */
 a_modify_reason          IN    VARCHAR2 )                    /* VC255_TYPE */
RETURN NUMBER ;

FUNCTION GetEqChartList
(a_eq                IN       VARCHAR2,                  /* VC20_TYPE */
 a_lab               IN       VARCHAR2,                  /* VC20_TYPE */
 a_ch                OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy                OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cy_version        OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description       OUT      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_creation_date     OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_ch_context_key    OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_visual_cf         OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_ss                OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows        IN OUT   NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetEquipmentType
(a_eq                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_lab                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_eq_tp                   OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_nr_of_rows              IN OUT  NUMBER,                       /* NUM_TYPE         */
 a_where_clause            IN      VARCHAR2)                     /* VC511_TYPE       */
RETURN NUMBER;

FUNCTION SaveEquipmentType
(a_eq                      IN      VARCHAR2,                    /* VC20_TYPE         */
 a_lab                     IN      VARCHAR2,                    /* VC20_TYPE         */
 a_eq_tp                   IN      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE   */
 a_nr_of_rows              IN      NUMBER,                      /* NUM_TYPE          */
 a_modify_reason           IN      VARCHAR2)                    /* VC255_TYPE        */
RETURN NUMBER;

FUNCTION GetLab
(a_lab                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_nr_of_rows              IN OUT  NUMBER,                       /* NUM_TYPE         */
 a_where_clause            IN      VARCHAR2)                     /* VC511_TYPE       */
RETURN NUMBER;

END unapieq;