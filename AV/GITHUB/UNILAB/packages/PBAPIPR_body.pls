create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapipr AS

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

FUNCTION GetParameterList
(a_pr                      OUT      UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
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

l_ret_code := UNAPIPR.GetParameterList
                (a_pr,
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
END GetParameterList;

FUNCTION GetPrMethod
(a_pr                  OUT    UNAPIGEN.VC20_TABLE_TYPE,
 a_mt                  OUT    UNAPIGEN.VC20_TABLE_TYPE,
 a_description         OUT    UNAPIGEN.VC40_TABLE_TYPE,
 a_nr_measur           OUT    UNAPIGEN.NUM_TABLE_TYPE,
 a_unit                OUT    UNAPIGEN.VC20_TABLE_TYPE,
 a_format              OUT    UNAPIGEN.VC40_TABLE_TYPE,
 a_allow_add           OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_ignore_other        OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_accuracy            OUT    UNAPIGEN.FLOAT_TABLE_TYPE,
 a_freq_tp             OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_freq_val            OUT    UNAPIGEN.NUM_TABLE_TYPE,
 a_freq_unit           OUT    UNAPIGEN.VC20_TABLE_TYPE,
 a_invert_freq         OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_st_based_freq       OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_last_sched          OUT    UNAPIGEN.DATE_TABLE_TYPE,
 a_last_cnt            OUT    UNAPIGEN.NUM_TABLE_TYPE,
 a_last_val            OUT    UNAPIGEN.VC40_TABLE_TYPE,
 a_inherit_au          OUT    PBAPIGEN.VC1_TABLE_TYPE,
 a_nr_of_rows          IN OUT NUMBER,
 a_where_clause        IN     VARCHAR2)
RETURN NUMBER IS

l_row              NUMBER ;
l_allow_add        UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_ignore_other     UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_freq_tp          UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_invert_freq      UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_st_based_freq    UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_inherit_au       UNAPIGEN.CHAR1_TABLE_TYPE  ;
a_version          UNAPIGEN.VC20_TABLE_TYPE;
a_mt_version       UNAPIGEN.VC20_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIPR.GETPRMETHOD
                (a_pr,
                 a_version,
                 a_mt,
                 a_mt_version,
                 a_description,
                 a_nr_measur,
                 a_unit,
                 a_format,
                 l_allow_add,
                 l_ignore_other,
                 a_accuracy,
                 l_freq_tp,
                 a_freq_val,
                 a_freq_unit,
                 l_invert_freq,
                 l_st_based_freq,
                 a_last_sched,
                 a_last_cnt,
                 a_last_val,
                 l_inherit_au,
                 a_nr_of_rows,
                 a_where_clause);

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
 FOR l_row IN 1..a_nr_of_rows LOOP
  a_allow_add(l_row)   := l_allow_add(l_row);
  a_ignore_other(l_row) := l_ignore_other(l_row);
  a_freq_tp(l_row)  := l_freq_tp(l_row);
  a_invert_freq(l_row) := l_invert_freq(l_row);
  a_st_based_freq(l_row) := l_st_based_freq(l_row);
  a_inherit_au(l_row)  := l_inherit_au(l_row);
 END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetPrMethod ;
END pbapipr ;