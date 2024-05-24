create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapigk AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetGroupKeySt
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    PBAPIGEN.VC2_TABLE_TYPE,     /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeySc
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    PBAPIGEN.VC2_TABLE_TYPE,     /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyMe
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    PBAPIGEN.VC2_TABLE_TYPE,     /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRq
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    PBAPIGEN.VC2_TABLE_TYPE,     /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRt
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    PBAPIGEN.VC2_TABLE_TYPE,     /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyWs
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    PBAPIGEN.VC2_TABLE_TYPE,     /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyPt
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    PBAPIGEN.VC2_TABLE_TYPE,     /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeySd
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    PBAPIGEN.VC2_TABLE_TYPE,     /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveEventRules
(a_rule_nr           IN       UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_applic            IN       UNAPIGEN.VC8_TABLE_TYPE,    /* VC8_TABLE_TYPE */
 a_dbapi_name        IN       UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_object_tp         IN       UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_object_id         IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_object_lc         IN       UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_object_lc_version IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_object_ss         IN       UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_ev_tp             IN       UNAPIGEN.VC60_TABLE_TYPE,   /* VC60_TABLE_TYPE */
 a_condition         IN       UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_af                IN       UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_af_delay          IN       UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_af_delay_unit     IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_custom            IN       PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN       NUMBER,                     /* NUM_TYPE */
 a_modify_reason     IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetEventRules
(a_rule_nr           OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_applic            OUT      UNAPIGEN.VC8_TABLE_TYPE,    /* VC8_TABLE_TYPE */
 a_dbapi_name        OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_object_tp         OUT      UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_object_id         OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_object_lc         OUT      UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_object_lc_version OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_object_ss         OUT      UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_ev_tp             OUT      UNAPIGEN.VC60_TABLE_TYPE,   /* VC60_TABLE_TYPE */
 a_condition         OUT      UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_af                OUT      UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_af_delay          OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_af_delay_unit     OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_custom            OUT      PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN  OUT  NUMBER,                     /* NUM_TYPE */
 a_order_by_clause   IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

END pbapigk;