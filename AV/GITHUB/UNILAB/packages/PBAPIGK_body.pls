create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapigk AS

l_ret_code        NUMBER;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

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
RETURN NUMBER IS
 l_is_protected         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_unique         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_single_valued        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_new_val_allowed      UNAPIGEN.CHAR1_TABLE_TYPE;
 l_mandatory            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_struct_created       UNAPIGEN.CHAR1_TABLE_TYPE;
 l_inherit_gk           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_list_tp        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_assign_tp            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_q_tp                 UNAPIGEN.CHAR2_TABLE_TYPE;
 l_q_check_au           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_row                  INTEGER;
BEGIN
l_ret_code := UNAPIGK.GetGroupKeySt
(a_gk,
 a_description,
 l_is_protected,   /* CHAR1_TABLE_TYPE */
 l_value_unique,   /* CHAR1_TABLE_TYPE */
 l_single_valued,   /* CHAR1_TABLE_TYPE */
 l_new_val_allowed,   /* CHAR1_TABLE_TYPE */
 l_mandatory,   /* CHAR1_TABLE_TYPE */
 l_struct_created,   /* CHAR1_TABLE_TYPE */
 l_inherit_gk,   /* CHAR1_TABLE_TYPE */
 l_value_list_tp,   /* CHAR1_TABLE_TYPE */
 a_default_value,
 a_dsp_rows,
 a_val_length,
 a_val_start,
 l_assign_tp,   /* CHAR1_TABLE_TYPE */
 a_assign_id,
 l_q_tp,   /* CHAR2_TABLE_TYPE */
 a_q_id,
 l_q_check_au,   /* CHAR1_TABLE_TYPE */
 a_q_au,
 a_nr_of_rows,
 a_where_clause);
 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
  FOR l_row IN 1..a_nr_of_rows LOOP
    a_is_protected(l_row)    := l_is_protected(l_row);
    a_value_unique(l_row)    := l_value_unique(l_row);
    a_single_valued(l_row)    := l_single_valued(l_row);
    a_new_val_allowed(l_row)    := l_new_val_allowed(l_row);
    a_mandatory(l_row)    := l_mandatory(l_row);
    a_struct_created(l_row)    := l_struct_created(l_row);
    a_inherit_gk(l_row)    := l_inherit_gk(l_row);
    a_value_list_tp(l_row)    := l_value_list_tp(l_row);
    a_assign_tp(l_row)    := l_assign_tp(l_row);
    a_q_tp(l_row)    := l_q_tp(l_row);
    a_q_check_au(l_row)    := l_q_check_au(l_row);
  END LOOP;
 END IF;
 RETURN(l_ret_code);
END GetGroupKeySt;


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
RETURN NUMBER IS
 l_is_protected         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_unique         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_single_valued        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_new_val_allowed      UNAPIGEN.CHAR1_TABLE_TYPE;
 l_mandatory            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_struct_created       UNAPIGEN.CHAR1_TABLE_TYPE;
 l_inherit_gk           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_list_tp        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_assign_tp            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_q_tp                 UNAPIGEN.CHAR2_TABLE_TYPE;
 l_q_check_au           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_row                  INTEGER;
BEGIN
l_ret_code := UNAPIGK.GetGroupKeySc
(a_gk,
 a_description,
 l_is_protected,   /* CHAR1_TABLE_TYPE */
 l_value_unique,   /* CHAR1_TABLE_TYPE */
 l_single_valued,   /* CHAR1_TABLE_TYPE */
 l_new_val_allowed,   /* CHAR1_TABLE_TYPE */
 l_mandatory,   /* CHAR1_TABLE_TYPE */
 l_struct_created,   /* CHAR1_TABLE_TYPE */
 l_inherit_gk,   /* CHAR1_TABLE_TYPE */
 l_value_list_tp,   /* CHAR1_TABLE_TYPE */
 a_default_value,
 a_dsp_rows,
 a_val_length,
 a_val_start,
 l_assign_tp,   /* CHAR1_TABLE_TYPE */
 a_assign_id,
 l_q_tp,   /* CHAR2_TABLE_TYPE */
 a_q_id,
 l_q_check_au,   /* CHAR1_TABLE_TYPE */
 a_q_au,
 a_nr_of_rows,
 a_where_clause);
 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
  FOR l_row IN 1..a_nr_of_rows LOOP
    a_is_protected(l_row)    := l_is_protected(l_row);
    a_value_unique(l_row)    := l_value_unique(l_row);
    a_single_valued(l_row)    := l_single_valued(l_row);
    a_new_val_allowed(l_row)    := l_new_val_allowed(l_row);
    a_mandatory(l_row)    := l_mandatory(l_row);
    a_struct_created(l_row)    := l_struct_created(l_row);
    a_inherit_gk(l_row)    := l_inherit_gk(l_row);
    a_value_list_tp(l_row)    := l_value_list_tp(l_row);
    a_assign_tp(l_row)    := l_assign_tp(l_row);
    a_q_tp(l_row)    := l_q_tp(l_row);
    a_q_check_au(l_row)    := l_q_check_au(l_row);
  END LOOP;
 END IF;
 RETURN(l_ret_code);
END GetGroupKeySc;


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
RETURN NUMBER IS
 l_is_protected         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_unique         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_single_valued        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_new_val_allowed      UNAPIGEN.CHAR1_TABLE_TYPE;
 l_mandatory            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_struct_created       UNAPIGEN.CHAR1_TABLE_TYPE;
 l_inherit_gk           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_list_tp        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_assign_tp            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_q_tp                 UNAPIGEN.CHAR2_TABLE_TYPE;
 l_q_check_au           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_row                  INTEGER;
BEGIN
l_ret_code := UNAPIGK.GetGroupKeyMe
(a_gk,
 a_description,
 l_is_protected,   /* CHAR1_TABLE_TYPE */
 l_value_unique,   /* CHAR1_TABLE_TYPE */
 l_single_valued,   /* CHAR1_TABLE_TYPE */
 l_new_val_allowed,   /* CHAR1_TABLE_TYPE */
 l_mandatory,   /* CHAR1_TABLE_TYPE */
 l_struct_created,   /* CHAR1_TABLE_TYPE */
 l_inherit_gk,   /* CHAR1_TABLE_TYPE */
 l_value_list_tp,   /* CHAR1_TABLE_TYPE */
 a_default_value,
 a_dsp_rows,
 a_val_length,
 a_val_start,
 l_assign_tp,   /* CHAR1_TABLE_TYPE */
 a_assign_id,
 l_q_tp,   /* CHAR2_TABLE_TYPE */
 a_q_id,
 l_q_check_au,   /* CHAR1_TABLE_TYPE */
 a_q_au,
 a_nr_of_rows,
 a_where_clause);
 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
  FOR l_row IN 1..a_nr_of_rows LOOP
    a_is_protected(l_row)    := l_is_protected(l_row);
    a_value_unique(l_row)    := l_value_unique(l_row);
    a_single_valued(l_row)    := l_single_valued(l_row);
    a_new_val_allowed(l_row)    := l_new_val_allowed(l_row);
    a_mandatory(l_row)    := l_mandatory(l_row);
    a_struct_created(l_row)    := l_struct_created(l_row);
    a_inherit_gk(l_row)    := l_inherit_gk(l_row);
    a_value_list_tp(l_row)    := l_value_list_tp(l_row);
    a_assign_tp(l_row)    := l_assign_tp(l_row);
    a_q_tp(l_row)    := l_q_tp(l_row);
    a_q_check_au(l_row)    := l_q_check_au(l_row);
  END LOOP;
 END IF;
 RETURN(l_ret_code);
END GetGroupKeyMe;

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
RETURN NUMBER IS
 l_is_protected         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_unique         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_single_valued        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_new_val_allowed      UNAPIGEN.CHAR1_TABLE_TYPE;
 l_mandatory            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_struct_created       UNAPIGEN.CHAR1_TABLE_TYPE;
 l_inherit_gk           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_list_tp        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_assign_tp            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_q_tp                 UNAPIGEN.CHAR2_TABLE_TYPE;
 l_q_check_au           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_row                  INTEGER;
BEGIN
l_ret_code := UNAPIGK.GetGroupKeyRq
(a_gk,
 a_description,
 l_is_protected,   /* CHAR1_TABLE_TYPE */
 l_value_unique,   /* CHAR1_TABLE_TYPE */
 l_single_valued,   /* CHAR1_TABLE_TYPE */
 l_new_val_allowed,   /* CHAR1_TABLE_TYPE */
 l_mandatory,   /* CHAR1_TABLE_TYPE */
 l_struct_created,   /* CHAR1_TABLE_TYPE */
 l_inherit_gk,   /* CHAR1_TABLE_TYPE */
 l_value_list_tp,   /* CHAR1_TABLE_TYPE */
 a_default_value,
 a_dsp_rows,
 a_val_length,
 a_val_start,
 l_assign_tp,   /* CHAR1_TABLE_TYPE */
 a_assign_id,
 l_q_tp,   /* CHAR2_TABLE_TYPE */
 a_q_id,
 l_q_check_au,   /* CHAR1_TABLE_TYPE */
 a_q_au,
 a_nr_of_rows,
 a_where_clause);
 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
  FOR l_row IN 1..a_nr_of_rows LOOP
    a_is_protected(l_row)    := l_is_protected(l_row);
    a_value_unique(l_row)    := l_value_unique(l_row);
    a_single_valued(l_row)    := l_single_valued(l_row);
    a_new_val_allowed(l_row)    := l_new_val_allowed(l_row);
    a_mandatory(l_row)    := l_mandatory(l_row);
    a_struct_created(l_row)    := l_struct_created(l_row);
    a_inherit_gk(l_row)    := l_inherit_gk(l_row);
    a_value_list_tp(l_row)    := l_value_list_tp(l_row);
    a_assign_tp(l_row)    := l_assign_tp(l_row);
    a_q_tp(l_row)    := l_q_tp(l_row);
    a_q_check_au(l_row)    := l_q_check_au(l_row);
  END LOOP;
 END IF;
 RETURN(l_ret_code);
END GetGroupKeyRq;

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
RETURN NUMBER IS
 l_is_protected         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_unique         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_single_valued        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_new_val_allowed      UNAPIGEN.CHAR1_TABLE_TYPE;
 l_mandatory            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_struct_created       UNAPIGEN.CHAR1_TABLE_TYPE;
 l_inherit_gk           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_list_tp        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_assign_tp            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_q_tp                 UNAPIGEN.CHAR2_TABLE_TYPE;
 l_q_check_au           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_row                  INTEGER;
BEGIN
l_ret_code := UNAPIGK.GetGroupKeyRt
(a_gk,
 a_description,
 l_is_protected,   /* CHAR1_TABLE_TYPE */
 l_value_unique,   /* CHAR1_TABLE_TYPE */
 l_single_valued,   /* CHAR1_TABLE_TYPE */
 l_new_val_allowed,   /* CHAR1_TABLE_TYPE */
 l_mandatory,   /* CHAR1_TABLE_TYPE */
 l_struct_created,   /* CHAR1_TABLE_TYPE */
 l_inherit_gk,   /* CHAR1_TABLE_TYPE */
 l_value_list_tp,   /* CHAR1_TABLE_TYPE */
 a_default_value,
 a_dsp_rows,
 a_val_length,
 a_val_start,
 l_assign_tp,   /* CHAR1_TABLE_TYPE */
 a_assign_id,
 l_q_tp,   /* CHAR2_TABLE_TYPE */
 a_q_id,
 l_q_check_au,   /* CHAR1_TABLE_TYPE */
 a_q_au,
 a_nr_of_rows,
 a_where_clause);
 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
  FOR l_row IN 1..a_nr_of_rows LOOP
    a_is_protected(l_row)    := l_is_protected(l_row);
    a_value_unique(l_row)    := l_value_unique(l_row);
    a_single_valued(l_row)    := l_single_valued(l_row);
    a_new_val_allowed(l_row)    := l_new_val_allowed(l_row);
    a_mandatory(l_row)    := l_mandatory(l_row);
    a_struct_created(l_row)    := l_struct_created(l_row);
    a_inherit_gk(l_row)    := l_inherit_gk(l_row);
    a_value_list_tp(l_row)    := l_value_list_tp(l_row);
    a_assign_tp(l_row)    := l_assign_tp(l_row);
    a_q_tp(l_row)    := l_q_tp(l_row);
    a_q_check_au(l_row)    := l_q_check_au(l_row);
  END LOOP;
 END IF;
 RETURN(l_ret_code);
END GetGroupKeyRt;


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
RETURN NUMBER IS
 l_is_protected         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_unique         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_single_valued        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_new_val_allowed      UNAPIGEN.CHAR1_TABLE_TYPE;
 l_mandatory            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_struct_created       UNAPIGEN.CHAR1_TABLE_TYPE;
 l_inherit_gk           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_list_tp        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_assign_tp            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_q_tp                 UNAPIGEN.CHAR2_TABLE_TYPE;
 l_q_check_au           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_row                  INTEGER;
BEGIN
l_ret_code := UNAPIGK.GetGroupKeyWs
(a_gk,
 a_description,
 l_is_protected,   /* CHAR1_TABLE_TYPE */
 l_value_unique,   /* CHAR1_TABLE_TYPE */
 l_single_valued,   /* CHAR1_TABLE_TYPE */
 l_new_val_allowed,   /* CHAR1_TABLE_TYPE */
 l_mandatory,   /* CHAR1_TABLE_TYPE */
 l_struct_created,   /* CHAR1_TABLE_TYPE */
 l_inherit_gk,   /* CHAR1_TABLE_TYPE */
 l_value_list_tp,   /* CHAR1_TABLE_TYPE */
 a_default_value,
 a_dsp_rows,
 a_val_length,
 a_val_start,
 l_assign_tp,   /* CHAR1_TABLE_TYPE */
 a_assign_id,
 l_q_tp,   /* CHAR2_TABLE_TYPE */
 a_q_id,
 l_q_check_au,   /* CHAR1_TABLE_TYPE */
 a_q_au,
 a_nr_of_rows,
 a_where_clause);
 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
  FOR l_row IN 1..a_nr_of_rows LOOP
    a_is_protected(l_row)    := l_is_protected(l_row);
    a_value_unique(l_row)    := l_value_unique(l_row);
    a_single_valued(l_row)    := l_single_valued(l_row);
    a_new_val_allowed(l_row)    := l_new_val_allowed(l_row);
    a_mandatory(l_row)    := l_mandatory(l_row);
    a_struct_created(l_row)    := l_struct_created(l_row);
    a_inherit_gk(l_row)    := l_inherit_gk(l_row);
    a_value_list_tp(l_row)    := l_value_list_tp(l_row);
    a_assign_tp(l_row)    := l_assign_tp(l_row);
    a_q_tp(l_row)    := l_q_tp(l_row);
    a_q_check_au(l_row)    := l_q_check_au(l_row);
  END LOOP;
 END IF;
 RETURN(l_ret_code);
END GetGroupKeyWs;

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
RETURN NUMBER IS
 l_is_protected         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_unique         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_single_valued        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_new_val_allowed      UNAPIGEN.CHAR1_TABLE_TYPE;
 l_mandatory            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_struct_created       UNAPIGEN.CHAR1_TABLE_TYPE;
 l_inherit_gk           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_list_tp        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_assign_tp            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_q_tp                 UNAPIGEN.CHAR2_TABLE_TYPE;
 l_q_check_au           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_row                  INTEGER;
BEGIN
l_ret_code := UNAPIGK.GetGroupKeyPt
(a_gk,
 a_description,
 l_is_protected,   /* CHAR1_TABLE_TYPE */
 l_value_unique,   /* CHAR1_TABLE_TYPE */
 l_single_valued,   /* CHAR1_TABLE_TYPE */
 l_new_val_allowed,   /* CHAR1_TABLE_TYPE */
 l_mandatory,   /* CHAR1_TABLE_TYPE */
 l_struct_created,   /* CHAR1_TABLE_TYPE */
 l_inherit_gk,   /* CHAR1_TABLE_TYPE */
 l_value_list_tp,   /* CHAR1_TABLE_TYPE */
 a_default_value,
 a_dsp_rows,
 a_val_length,
 a_val_start,
 l_assign_tp,   /* CHAR1_TABLE_TYPE */
 a_assign_id,
 l_q_tp,   /* CHAR2_TABLE_TYPE */
 a_q_id,
 l_q_check_au,   /* CHAR1_TABLE_TYPE */
 a_q_au,
 a_nr_of_rows,
 a_where_clause);
 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
  FOR l_row IN 1..a_nr_of_rows LOOP
    a_is_protected(l_row)    := l_is_protected(l_row);
    a_value_unique(l_row)    := l_value_unique(l_row);
    a_single_valued(l_row)    := l_single_valued(l_row);
    a_new_val_allowed(l_row)    := l_new_val_allowed(l_row);
    a_mandatory(l_row)    := l_mandatory(l_row);
    a_struct_created(l_row)    := l_struct_created(l_row);
    a_inherit_gk(l_row)    := l_inherit_gk(l_row);
    a_value_list_tp(l_row)    := l_value_list_tp(l_row);
    a_assign_tp(l_row)    := l_assign_tp(l_row);
    a_q_tp(l_row)    := l_q_tp(l_row);
    a_q_check_au(l_row)    := l_q_check_au(l_row);
  END LOOP;
 END IF;
 RETURN(l_ret_code);
END GetGroupKeyPt;

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
RETURN NUMBER IS
 l_is_protected         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_unique         UNAPIGEN.CHAR1_TABLE_TYPE;
 l_single_valued        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_new_val_allowed      UNAPIGEN.CHAR1_TABLE_TYPE;
 l_mandatory            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_struct_created       UNAPIGEN.CHAR1_TABLE_TYPE;
 l_inherit_gk           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_value_list_tp        UNAPIGEN.CHAR1_TABLE_TYPE;
 l_assign_tp            UNAPIGEN.CHAR1_TABLE_TYPE;
 l_q_tp                 UNAPIGEN.CHAR2_TABLE_TYPE;
 l_q_check_au           UNAPIGEN.CHAR1_TABLE_TYPE;
 l_row                  INTEGER;
BEGIN
l_ret_code := UNAPIGK.GetGroupKeySd
(a_gk,
 a_description,
 l_is_protected,   /* CHAR1_TABLE_TYPE */
 l_value_unique,   /* CHAR1_TABLE_TYPE */
 l_single_valued,   /* CHAR1_TABLE_TYPE */
 l_new_val_allowed,   /* CHAR1_TABLE_TYPE */
 l_mandatory,   /* CHAR1_TABLE_TYPE */
 l_struct_created,   /* CHAR1_TABLE_TYPE */
 l_inherit_gk,   /* CHAR1_TABLE_TYPE */
 l_value_list_tp,   /* CHAR1_TABLE_TYPE */
 a_default_value,
 a_dsp_rows,
 a_val_length,
 a_val_start,
 l_assign_tp,   /* CHAR1_TABLE_TYPE */
 a_assign_id,
 l_q_tp,   /* CHAR2_TABLE_TYPE */
 a_q_id,
 l_q_check_au,   /* CHAR1_TABLE_TYPE */
 a_q_au,
 a_nr_of_rows,
 a_where_clause);
 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
  FOR l_row IN 1..a_nr_of_rows LOOP
    a_is_protected(l_row)    := l_is_protected(l_row);
    a_value_unique(l_row)    := l_value_unique(l_row);
    a_single_valued(l_row)    := l_single_valued(l_row);
    a_new_val_allowed(l_row)    := l_new_val_allowed(l_row);
    a_mandatory(l_row)    := l_mandatory(l_row);
    a_struct_created(l_row)    := l_struct_created(l_row);
    a_inherit_gk(l_row)    := l_inherit_gk(l_row);
    a_value_list_tp(l_row)    := l_value_list_tp(l_row);
    a_assign_tp(l_row)    := l_assign_tp(l_row);
    a_q_tp(l_row)    := l_q_tp(l_row);
    a_q_check_au(l_row)    := l_q_check_au(l_row);
  END LOOP;
 END IF;
 RETURN(l_ret_code);
END GetGroupKeySd;

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
RETURN NUMBER IS

l_custom UNAPIGEN.CHAR1_TABLE_TYPE;
l_row    INTEGER;

BEGIN
   FOR l_row IN 1..a_nr_of_rows LOOP
      l_custom(l_row) := a_custom(l_row);
   END LOOP;
   l_ret_code := UNAPIGK.SaveEventRules(a_rule_nr,
                                        a_applic,
                                        a_dbapi_name,
                                        a_object_tp,
                                        a_object_id,
                                        a_object_lc,
                                        a_object_lc_version,
                                        a_object_ss,
                                        a_ev_tp,
                                        a_condition,
                                        a_af,
                                        a_af_delay,
                                        a_af_delay_unit,
                                        l_custom,            /* CHAR1_TABLE_TYPE */
                                        a_nr_of_rows,
                                        a_modify_reason);
   RETURN(l_ret_code);
END SaveEventRules;

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
RETURN NUMBER IS

l_custom UNAPIGEN.CHAR1_TABLE_TYPE;
l_row    INTEGER;

BEGIN
   l_ret_code := UNAPIGK.GetEventRules(a_rule_nr,
                                       a_applic,
                                       a_dbapi_name,
                                       a_object_tp,
                                       a_object_id,
                                       a_object_lc,
                                       a_object_lc_version,
                                       a_object_ss,
                                       a_ev_tp,
                                       a_condition,
                                       a_af,
                                       a_af_delay,
                                       a_af_delay_unit,
                                       l_custom,            /* CHAR1_TABLE_TYPE */
                                       a_nr_of_rows,
                                       a_order_by_clause);
   IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      FOR l_row IN 1..a_nr_of_rows LOOP
        a_custom(l_row) := l_custom(l_row);
      END LOOP;
   END IF;
   RETURN(l_ret_code);
END GetEventRules;

END pbapigk;