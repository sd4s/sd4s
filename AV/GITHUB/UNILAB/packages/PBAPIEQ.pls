create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapieq AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

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
 a_operation_doc           OUT     UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_usage                   OUT     UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_usage_doc               OUT     UNAPIGEN.VC255_TABLE_TYPE,    /* VC255_TABLE_TYPE */
 a_eq_component            OUT     PBAPIGEN.VC1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_keep_ctold              OUT     UNAPIGEN.FLOAT_TABLE_TYPE,    /* FLOAT_TABLE_TYPE + INDICATOR */
 a_keep_ctold_unit         OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_is_template             OUT     PBAPIGEN.VC1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE   */
 a_log_hs                  OUT     PBAPIGEN.VC1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE   */
 a_allow_modify            OUT     PBAPIGEN.VC1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE   */
 a_active                  OUT     PBAPIGEN.VC1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE   */
 a_ca_warn_level           OUT     PBAPIGEN.VC1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE   */
 a_lc                      OUT     UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE   */
 a_ss                      OUT     UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE   */
 a_nr_of_rows              IN OUT  NUMBER,                       /* NUM_TYPE         */
 a_where_clause            IN      VARCHAR2)                     /* VC511_TYPE       */
RETURN NUMBER;

FUNCTION GetEquipmentList
(a_eq                      OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_lab                     OUT     UNAPIGEN.VC20_TABLE_TYPE,     /* VC20_TABLE_TYPE  */
 a_description             OUT     UNAPIGEN.VC40_TABLE_TYPE,     /* VC40_TABLE_TYPE  */
 a_ss                      OUT     UNAPIGEN.VC2_TABLE_TYPE,      /* VC2_TABLE_TYPE   */
 a_ca_warn_level           OUT     PBAPIGEN.VC1_TABLE_TYPE,      /* CHAR1_TABLE_TYPE */
 a_nr_of_rows              IN OUT  NUMBER,                       /* NUM_TYPE         */
 a_where_clause            IN      VARCHAR2,                     /* VC511_TYPE       */
 a_next_rows               IN      NUMBER)                       /* NUM_TYPE         */
RETURN NUMBER;

FUNCTION SaveEquipment
(a_eq                      IN      VARCHAR2,                      /* VC20_TYPE        */
 a_lab                     IN      VARCHAR2,                      /* VC20_TYPE        */
 a_description             IN      VARCHAR2,                      /* VC40_TYPE        */
 a_serial_no               IN      VARCHAR2,                      /* VC255_TYPE       */
 a_supplier                IN      VARCHAR2,                      /* VC20_TYPE        */
 a_location                IN      VARCHAR2,                      /* VC40_TYPE        */
 a_invest_cost             IN      NUMBER,                        /* FLOAT_TYPE  + INDICATOR */
 a_invest_unit             IN      VARCHAR2,                      /* VC20_TYPE        */
 a_usage_cost              IN      NUMBER,                        /* FLOAT_TYPE  + INDICATOR */
 a_usage_unit              IN      VARCHAR2,                      /* VC20_TYPE        */
 a_install_date            IN      DATE,                          /* DATE_TYPE        */
 a_in_service_date         IN      DATE,                          /* DATE_TYPE        */
 a_accessories             IN      VARCHAR2,                      /* VC40_TYPE        */
 a_operation               IN      VARCHAR2,                      /* VC255_TYPE       */
 a_operation_doc           IN      VARCHAR2,                      /* VC255_TYPE       */
 a_usage                   IN      VARCHAR2,                      /* VC255_TYPE       */
 a_usage_doc               IN      VARCHAR2,                      /* VC255_TYPE       */
 a_eq_component            IN      VARCHAR2,                      /* CHAR1_TABLE_TYPE */
 a_keep_ctold              IN      NUMBER,                        /* NUM_TYPE         */
 a_keep_ctold_unit         IN      VARCHAR2,                      /* VC20_TYPE        */
 a_is_template             IN      VARCHAR2,                      /* CHAR1_TABLE_TYPE */
 a_log_hs                  IN      VARCHAR2,                      /* CHAR1_TABLE_TYPE */
 a_ca_warn_level           IN      VARCHAR2,                      /* CHAR1_TABLE_TYPE */
 a_lc                      IN      VARCHAR2,                      /* VC2_TYPE         */
 a_modify_reason           IN      VARCHAR2)                      /* VC255_TYPE       */
RETURN NUMBER;

FUNCTION GetEqCalibration
(a_eq                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_lab                     OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_ca                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE  */
 a_sop                     OUT      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE  */
 a_st                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_mt                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_cal_val                 OUT      UNAPIGEN.FLOAT_TABLE_TYPE,   /* FLOAT_TABLE_TYPE  + INDICATOR */
 a_cal_cost                OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_cal_time_val            OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_cal_time_unit           OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_freq_tp                 OUT      PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE   */
 a_freq_val                OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_freq_unit               OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_invert_freq             OUT      PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE   */
 a_last_sched              OUT      UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE  */
 a_last_val                OUT      UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE  */
 a_last_cnt                OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_suspend                 OUT      PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE   */
 a_grace_val               OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_grace_unit              OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_sc                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_pg                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_pgnode                  OUT      UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_pa                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_panode                  OUT      UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_me                      OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_menode                  OUT      UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_reanalysis              OUT      UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE  */
 a_ca_warn_level           OUT      PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE   */
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
 a_freq_tp                 IN       PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE  */
 a_freq_val                IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_freq_unit               IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_invert_freq             IN       PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE  */
 a_last_sched              IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_last_val                IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_last_cnt                IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_suspend                 IN       PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE  */
 a_grace_val               IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE   */
 a_grace_unit              IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_sc                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_pg                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_pgnode                  IN       UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_pa                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_panode                  IN       UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_me                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_menode                  IN       UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE  */
 a_reanalysis              IN       UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE  */
 a_ca_warn_level           IN       PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE  */
 a_nr_of_rows              IN       NUMBER,                      /* NUM_TYPE         */
 a_modify_reason           IN       VARCHAR2)                    /* VC255_TYPE       */
RETURN NUMBER;

END pbapieq ;