create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapist AS

l_ret_code NUMBER;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION GetSampleTypeList
(a_st                      OUT      UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      PBAPIGEN.VC1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_description             OUT      UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                   /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2,                 /* VC511_TYPE */
 a_next_rows               IN       NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS


l_version_is_current  UNAPIGEN.CHAR1_TABLE_TYPE  ;

BEGIN

l_ret_code := UNAPIST.GetSampleTypeList
                (a_st,
                 a_version,
                 l_version_is_current ,
                 a_effective_from ,
                 a_effective_till,
                 a_description ,
                 a_ss,
                 a_nr_of_rows ,
                 a_where_clause ,
                 a_next_rows
                 );

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
 FOR l_row IN 1..a_nr_of_rows LOOP
  a_version_is_current(l_row)  := l_version_is_current(l_row);
 END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetSampleTypeList;


FUNCTION GetStGroupKey
(a_st                 OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_gk                 OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_value              OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description        OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_is_protected       OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_value_unique       OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_single_valued      OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_new_val_allowed    OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_mandatory          OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_value_list_tp      OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_dsp_rows           OUT    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows         IN OUT NUMBER,                     /* NUM_TYPE */
 a_where_clause       IN     VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER IS

l_row                 NUMBER ;
l_is_protected        UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_value_unique        UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_single_valued       UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_new_val_allowed     UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_mandatory           UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_value_list_tp       UNAPIGEN.CHAR1_TABLE_TYPE  ;
a_version             UNAPIGEN.VC20_TABLE_TYPE;
a_gk_version          UNAPIGEN.VC20_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIST.GetStGroupKey
(a_st,
 a_version,
 a_gk,
 a_gk_version,
 a_value,
 a_description,
 l_is_protected,
 l_value_unique,
 l_single_valued,
 l_new_val_allowed,
 l_mandatory,
 l_value_list_tp,
 a_dsp_rows,
 a_nr_of_rows,
 a_where_clause);
IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
 FOR l_row IN 1..a_nr_of_rows LOOP
  a_is_protected(l_row)  := l_is_protected(l_row);
  a_value_unique(l_row) := l_value_unique(l_row);
  a_single_valued(l_row) := l_single_valued(l_row);
  a_new_val_allowed(l_row):= l_new_val_allowed(l_row);
  a_mandatory(l_row) := l_mandatory(l_row);
  a_value_list_tp(l_row) := l_value_list_tp(l_row);
 END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetStGroupKey ;

FUNCTION GetStInfoProfile
(a_st               OUT    UNAPIGEN.VC20_TABLE_TYPE,
 a_ip               OUT    UNAPIGEN.VC20_TABLE_TYPE,
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,
 a_is_protected     OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_hidden           OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_freq_tp          OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_freq_val         OUT    UNAPIGEN.NUM_TABLE_TYPE,
 a_freq_unit        OUT    UNAPIGEN.VC20_TABLE_TYPE,
 a_invert_freq      OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_last_sched       OUT    UNAPIGEN.DATE_TABLE_TYPE,
 a_last_cnt         OUT    UNAPIGEN.NUM_TABLE_TYPE,
 a_last_val         OUT    UNAPIGEN.VC40_TABLE_TYPE,
 a_inherit_au       OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_nr_of_rows       IN OUT NUMBER,
 a_where_clause     IN     VARCHAR2,
 a_next_rows        IN     NUMBER)
RETURN NUMBER IS

l_row            NUMBER ;
l_is_protected   UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_hidden         UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_freq_tp        UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_invert_freq    UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_inherit_au     UNAPIGEN.CHAR1_TABLE_TYPE  ;
a_version        UNAPIGEN.VC20_TABLE_TYPE;
a_ip_version     UNAPIGEN.VC20_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIST.GETSTINFOPROFILE
                (a_st,
                 a_version,
                 a_ip,
                 a_ip_version,
                 a_description,
                 l_is_protected,
                 l_hidden,
                 l_freq_tp,
                 a_freq_val,
                 a_freq_unit,
                 l_invert_freq,
                 a_last_sched,
                 a_last_cnt,
                 a_last_val,
                 l_inherit_au,
                 a_nr_of_rows,
                 a_where_clause,
     a_next_rows);

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
 FOR l_row IN 1..a_nr_of_rows LOOP
  a_is_protected(l_row)  := l_is_protected(l_row);
  a_hidden(l_row)   := l_hidden(l_row);
  a_freq_tp(l_row)  := l_freq_tp(l_row);
  a_invert_freq(l_row) := l_invert_freq(l_row);
  a_inherit_au(l_row)     := l_inherit_au(l_row);
 END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetStInfoProfile ;

END pbapist ;