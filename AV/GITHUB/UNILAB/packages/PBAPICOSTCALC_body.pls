create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapicostcalc AS

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

FUNCTION SaveJournalDetails
(a_journal_nr         IN  VARCHAR2,                       /* VC20_TYPE */
 a_rqseq              IN  UNAPIGEN.NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE */
 a_seq                IN  UNAPIGEN.NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE */
 a_object_tp          IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_object_version     IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_rq                 IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_sc                 IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_pg                 IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_pgnode             IN  UNAPIGEN.LONG_TABLE_TYPE,       /* LONG_TABLE_TYPE */
 a_pp_key1            IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_pp_key2            IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_pp_key3            IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_pp_key4            IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_pp_key5            IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_pa                 IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_panode             IN  UNAPIGEN.LONG_TABLE_TYPE,       /* LONG_TABLE_TYPE */
 a_me                 IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_menode             IN  UNAPIGEN.LONG_TABLE_TYPE,       /* LONG_TABLE_TYPE */
 a_reanalysis         IN  UNAPIGEN.NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE */
 a_description        IN  UNAPIGEN.VC255_TABLE_TYPE,      /* VC255_TABLE_TYPE */
 a_qtity              IN  UNAPIGEN.NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE */
 a_price              IN  UNAPIGEN.FLOAT_TABLE_TYPE,      /* FLOAT_TABLE_TYPE + INDICATOR */
 a_disc_abs           IN  UNAPIGEN.NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE */
 a_disc_rel           IN  UNAPIGEN.NUM_TABLE_TYPE,        /* NUM_TABLE_TYPE */
 a_net_price          IN  UNAPIGEN.FLOAT_TABLE_TYPE,      /* FLOAT_TABLE_TYPE + INDICATOR */
 a_active             IN  PBAPIGEN.VC1_TABLE_TYPE,        /* CHAR1_TABLE_TYPE */
 a_allow_modify       IN  PBAPIGEN.VC1_TABLE_TYPE,        /* CHAR1_TABLE_TYPE */
 a_last_updated       IN  UNAPIGEN.DATE_TABLE_TYPE,       /* DATE_TABLE_TYPE */
 a_ac_code            IN  UNAPIGEN.VC20_TABLE_TYPE,       /* VC20_TABLE_TYPE */
 a_nr_of_rows         IN  NUMBER)                         /* NUM_TYPE */
RETURN NUMBER IS
   l_row                 NUMBER;
   l_active              UNAPIGEN.CHAR1_TABLE_TYPE;
   l_allow_modify        UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
   FOR l_row IN 1..a_nr_of_rows LOOP
      l_active(l_row)       := a_active(l_row);
      l_allow_modify(l_row) := a_allow_modify(l_row);
   END LOOP;
   l_ret_code := UNAPICOSTCALC.SaveJournalDetails
                     (a_journal_nr,
                      a_rqseq,
                      a_seq,
                      a_object_tp,
                      a_object_version,
                      a_rq,
                      a_sc,
                      a_pg,
                      a_pgnode,
                      a_pp_key1,
                      a_pp_key2,
                      a_pp_key3,
                      a_pp_key4,
                      a_pp_key5,
                      a_pa,
                      a_panode,
                      a_me,
                      a_menode,
                      a_reanalysis,
                      a_description,
                      a_qtity,
                      a_price,
                      a_disc_abs,
                      a_disc_rel,
                      a_net_price,
                      l_active,
                      l_allow_modify,
                      a_last_updated,
                      a_ac_code,
                      a_nr_of_rows);
   RETURN(l_ret_code);
END SaveJournalDetails;

END pbapicostcalc;