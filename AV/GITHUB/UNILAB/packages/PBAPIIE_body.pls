create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiie AS
l_row      NUMBER;
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

FUNCTION GetInfoFieldList
(a_ie               OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description      OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_tp           OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_ss               OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                  /* NUM_TYPE */
 a_where_clause     IN   VARCHAR2,                   /* VC511_TYPE */
 a_next_rows        IN   NUMBER)                     /* NUM_TYPE */
RETURN NUMBER IS

l_current_version  UNAPIGEN.CHAR1_TABLE_TYPE ;  /* CHAR1_TABLE_TYPE */
l_dsp_tp           UNAPIGEN.CHAR1_TABLE_TYPE ;  /* CHAR1_TABLE_TYPE */
a_version          UNAPIGEN.VC20_TABLE_TYPE;    /* VC20_TABLE_TYPE */
a_effective_from   UNAPIGEN.DATE_TABLE_TYPE;    /* DATE_TABLE_TYPE */
a_effective_till   UNAPIGEN.DATE_TABLE_TYPE;    /* DATE_TABLE_TYPE */

BEGIN
l_ret_code := UNAPIIE.GetInfoFieldList
(a_ie,
 a_version,
 l_current_version,
 a_effective_from,
 a_effective_till,
 a_description,
 l_dsp_tp,
 a_ss,
 a_nr_of_rows,
 a_where_clause,
 a_next_rows);
IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_dsp_tp(l_row)            := l_dsp_tp(l_row) ;
   END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetInfoFieldList;

FUNCTION GetInfoField
(a_ie               OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_is_protected     OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_hidden           OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_data_tp          OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_format           OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_valid_cf         OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_def_val_tp       OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_def_au_level     OUT  UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_ievalue          OUT  UNAPIGEN.VC2000_TABLE_TYPE, /* VC2000_TABLE_TYPE */
 a_align            OUT  UNAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_dsp_title        OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_title2       OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_dsp_len          OUT  UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_dsp_tp           OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_dsp_rows         OUT  UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_look_up_ptr      OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_is_template      OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_multi_select     OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_sc_lc            OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_inherit_au       OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_ie_class         OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs           OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify     OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active           OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc               OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_ss               OUT  UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                  /* NUM_TYPE */
 a_where_clause     IN   VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER IS

l_current_version  UNAPIGEN.CHAR1_TABLE_TYPE ;  /* CHAR1_TABLE_TYPE */
l_is_protected     UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_mandatory        UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_hidden           UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_data_tp          UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_def_val_tp       UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_align            UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_dsp_tp           UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_is_template      UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_multi_select     UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_inherit_au       UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_log_hs           UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_allow_modify     UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_active           UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
a_version          UNAPIGEN.VC20_TABLE_TYPE;   /* VC20_TABLE_TYPE */
a_current_version  UNAPIGEN.VC1_TABLE_TYPE;    /* CHAR1_TABLE_TYPE */
a_effective_from   UNAPIGEN.DATE_TABLE_TYPE;   /* DATE_TABLE_TYPE */
a_effective_till   UNAPIGEN.DATE_TABLE_TYPE;   /* DATE_TABLE_TYPE */
a_sc_lc_version    UNAPIGEN.VC20_TABLE_TYPE;   /* VC20_TABLE_TYPE */
a_lc_version       UNAPIGEN.VC20_TABLE_TYPE;   /* VC20_TABLE_TYPE */

BEGIN
l_ret_code := UNAPIIE.GetInfoField
(a_ie,
 a_version,
 l_current_version,
 a_effective_from,
 a_effective_till,
 l_is_protected,
 l_mandatory,
 l_hidden,
 l_data_tp,
 a_format,
 a_valid_cf,
 l_def_val_tp,
 a_def_au_level,
 a_ievalue,
 l_align,
 a_dsp_title,
 a_dsp_title2,
 a_dsp_len,
 l_dsp_tp,
 a_dsp_rows,
 a_look_up_ptr,
 l_is_template,
 l_multi_select,
 a_sc_lc,
 a_sc_lc_version,
 l_inherit_au,
 a_ie_class,
 l_log_hs,
 l_allow_modify,
 l_active,
 a_lc,
 a_lc_version,
 a_ss,
 a_nr_of_rows,
 a_where_clause) ;
IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_current_version(l_row):= l_current_version(l_row) ;
      a_is_protected(l_row)   := l_is_protected(l_row) ;
      a_mandatory(l_row)      := l_mandatory(l_row);
      a_hidden(l_row)         := l_hidden(l_row) ;
      a_data_tp(l_row)        := l_data_tp(l_row) ;
      a_align(l_row)          := l_align(l_row) ;
      a_def_val_tp(l_row)     := l_def_val_tp(l_row);
      a_dsp_tp(l_row)         := l_dsp_tp(l_row);
      a_is_template(l_row)    := l_is_template(l_row);
      a_multi_select(l_row)   := l_multi_select(l_row);
      a_inherit_au(l_row)     := l_inherit_au(l_row) ;
      a_log_hs(l_row)         := l_log_hs(l_row);
      a_allow_modify(l_row)   := l_allow_modify(l_row);
      a_active(l_row)         := l_active(l_row);
   END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetInfoField;

FUNCTION GetInfoFieldSpin
(a_ie              OUT  UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_circular        OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_incr            OUT  UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_low_val_tp      OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_low_au_level    OUT  UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_low_val         OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_high_val_tp     OUT  PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_high_au_level   OUT  UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_high_val        OUT  UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                  /* NUM_TYPE */
 a_where_clause    IN  VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER IS

l_circular        UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_low_val_tp      UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
l_high_val_tp     UNAPIGEN.CHAR1_TABLE_TYPE;  /* CHAR1_TABLE_TYPE */
a_version         UNAPIGEN.VC20_TABLE_TYPE;   /* VC20_TABLE_TYPE */

BEGIN
l_ret_code := UNAPIIE.GetInfoFieldSpin
  (a_ie,
   a_version,
   l_circular,
   a_incr,
   l_low_val_tp,
   a_low_au_level,
   a_low_val,
   l_high_val_tp,
   a_high_au_level ,
   a_high_val,
   a_nr_of_rows,
   a_where_clause);


IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_circular(l_row)   := l_circular(l_row);
      a_low_val_tp(l_row) := l_low_val_tp(l_row);
      a_high_val_tp(l_row):= l_high_val_tp(l_row);
   END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetInfoFieldSpin;

END pbapiie;