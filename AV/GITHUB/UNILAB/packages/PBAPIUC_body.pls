create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiuc AS

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

FUNCTION GetUniqueCodeMask
(a_uc               OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description      OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_uc_structure     OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_curr_val         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_def_mask_for     OUT     PBAPIGEN.VC2_TABLE_TYPE,    /* CHAR2_TABLE_TYPE */
 a_edit_allowed     OUT     PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_valid_cf         OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_log_hs           OUT     PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify     OUT     PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active           OUT     PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc               OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_ss               OUT     UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER IS
l_row               NUMBER;
l_def_mask_for      UNAPIGEN.CHAR2_TABLE_TYPE;
l_edit_allowed      UNAPIGEN.CHAR1_TABLE_TYPE;
l_log_hs            UNAPIGEN.CHAR1_TABLE_TYPE;
l_allow_modify      UNAPIGEN.CHAR1_TABLE_TYPE;
l_active            UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
l_ret_code := UNAPIUC.GetUniqueCodeMask
(a_uc,
 a_description,
 a_uc_structure,
 a_curr_val,
 l_def_mask_for, /* CHAR2_TABLE_TYPE */
 l_edit_allowed, /* CHAR1_TABLE_TYPE */
 a_valid_cf,
 l_log_hs, /* CHAR1_TABLE_TYPE */
 l_allow_modify, /* CHAR1_TABLE_TYPE */
 l_active, /* CHAR1_TABLE_TYPE */
 a_lc,
 a_ss,
 a_nr_of_rows,
 a_where_clause);
IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_def_mask_for(l_row) := l_def_mask_for(l_row);
      a_edit_allowed(l_row) := l_edit_allowed(l_row);
      a_log_hs(l_row) := l_log_hs(l_row);
      a_allow_modify(l_row) := l_allow_modify(l_row);
      a_active(l_row) := l_active(l_row);
   END LOOP;
END IF;
RETURN (l_ret_code);
END GetUniqueCodeMask;

FUNCTION GetCounter
(a_counter          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_curr_cnt         OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_low_cnt          OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_high_cnt         OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_incr_cnt         OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_fixed_length     OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_circular         OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER IS
l_row               NUMBER;
l_fixed_length      UNAPIGEN.CHAR1_TABLE_TYPE;
l_circular          UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
l_ret_code := UNAPIUC.GetCounter
(a_counter,
 a_curr_cnt,
 a_low_cnt,
 a_high_cnt,
 a_incr_cnt,
 l_fixed_length, /* CHAR1_TABLE_TYPE */
 l_circular, /* CHAR1_TABLE_TYPE */
 a_nr_of_rows,
 a_where_clause);
IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_fixed_length(l_row) := l_fixed_length(l_row);
      a_circular(l_row) := l_circular(l_row);
   END LOOP;
END IF;
RETURN (l_ret_code);
END GetCounter;

END pbapiuc;