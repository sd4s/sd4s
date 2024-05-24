create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiip AS

l_ret_code  NUMBER;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION GetIpInfoField
(a_ip            OUT      UNAPIGEN.VC20_TABLE_TYPE,
 a_ie            OUT      UNAPIGEN.VC20_TABLE_TYPE,
 a_description   OUT      UNAPIGEN.VC40_TABLE_TYPE,
 a_dsp_len       OUT      UNAPIGEN.NUM_TABLE_TYPE,
 a_dsp_tp        OUT      PBAPIGEN.VC1_TABLE_TYPE,
 a_dsp_rows      OUT      UNAPIGEN.NUM_TABLE_TYPE,
 a_seq           OUT      UNAPIGEN.NUM_TABLE_TYPE,
 a_pos_x         OUT      UNAPIGEN.NUM_TABLE_TYPE,
 a_pos_y         OUT      UNAPIGEN.NUM_TABLE_TYPE,
 a_is_protected  OUT      PBAPIGEN.VC1_TABLE_TYPE,
 a_mandatory     OUT      PBAPIGEN.VC1_TABLE_TYPE,
 a_hidden        OUT      PBAPIGEN.VC1_TABLE_TYPE,
 a_def_val_tp    OUT      PBAPIGEN.VC1_TABLE_TYPE,
 a_def_au_level  OUT      UNAPIGEN.VC4_TABLE_TYPE,
 a_ievalue       OUT      UNAPIGEN.VC2000_TABLE_TYPE,
 a_nr_of_rows    IN OUT   NUMBER,
 a_where_clause  IN       VARCHAR2,
 a_next_rows     IN       NUMBER)
RETURN NUMBER IS

l_row          NUMBER ;
l_dsp_tp       UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_is_protected UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_mandatory    UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_hidden       UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_def_val_tp   UNAPIGEN.CHAR1_TABLE_TYPE  ;
a_version      UNAPIGEN.VC20_TABLE_TYPE;
a_ie_version   UNAPIGEN.VC20_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIIP.GETIPINFOFIELD
                (a_ip,
                 a_version,
                 a_ie,
                 a_ie_version,
                 a_description,
                 a_dsp_len,
                 l_dsp_tp,
                 a_dsp_rows,
                 a_pos_x,
                 a_pos_y,
                 l_is_protected,
                 l_mandatory,
                 l_hidden,
                 l_def_val_tp,
                 a_def_au_level,
                 a_ievalue,
                 a_nr_of_rows,
                 a_where_clause,
                 a_next_rows);

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_dsp_tp(l_row)      := l_dsp_tp(l_row);
      a_is_protected(l_row)   := l_is_protected(l_row);
      a_mandatory(l_row)      := l_mandatory(l_row);
      a_hidden(l_row)         := l_hidden(l_row);
      a_def_val_tp(l_row)     := l_def_val_tp(l_row);
   END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetIpInfoField ;

END pbapiip ;