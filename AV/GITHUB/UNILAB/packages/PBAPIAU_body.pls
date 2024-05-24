create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiau AS

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

FUNCTION GetAttributeList
(a_au                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current  OUT  PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from      OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till      OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_ss                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER IS
l_row             NUMBER ;
l_version_is_current UNAPIGEN.CHAR1_TABLE_TYPE ;
BEGIN
l_ret_code := UNAPIAU.GetAttributeList
(a_au ,
 a_version ,
 l_version_is_current ,
 a_effective_from ,
 a_effective_till ,
 a_description ,
 a_ss ,
 a_nr_of_rows ,
 a_where_clause ,
 a_next_rows  ) ;
IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
       a_version_is_current(l_row) := l_version_is_current(l_row) ;
   END LOOP;
END IF;
RETURN(l_ret_code);

END GetAttributeList;



FUNCTION GetAttribute
(a_au              OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description     OUT   UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description2    OUT   UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_is_protected    OUT   PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_single_valued   OUT   PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_new_val_allowed OUT   PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_store_db        OUT   PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_inherit_au      OUT   PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_shortcut        OUT   PBAPIGEN.VC8_TABLE_TYPE,    /* RAW8_TABLE_TYPE */
 a_value_list_tp   OUT   PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_default_value   OUT   UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_run_mode        OUT   PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_service         OUT   UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_cf_value        OUT   UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_au_class        OUT   UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_log_hs          OUT   PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_allow_modify    OUT   PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_active          OUT   PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_lc              OUT   UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_ss              OUT   UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                   /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER IS

l_row             NUMBER ;
l_current_version UNAPIGEN.CHAR1_TABLE_TYPE ;
l_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE ;
l_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE ;
l_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE ;
l_store_db        UNAPIGEN.CHAR1_TABLE_TYPE ;
l_inherit_au      UNAPIGEN.CHAR1_TABLE_TYPE ;
l_shortcut        UNAPIGEN.RAW8_TABLE_TYPE ;
l_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE ;
l_run_mode        UNAPIGEN.CHAR1_TABLE_TYPE ;
l_log_hs          UNAPIGEN.CHAR1_TABLE_TYPE ;
l_allow_modify    UNAPIGEN.CHAR1_TABLE_TYPE ;
l_active          UNAPIGEN.CHAR1_TABLE_TYPE ;
a_version         UNAPIGEN.VC20_TABLE_TYPE;
a_current_version UNAPIGEN.VC1_TABLE_TYPE;
a_effective_from  UNAPIGEN.DATE_TABLE_TYPE;
a_effective_till  UNAPIGEN.DATE_TABLE_TYPE;
a_lc_version      UNAPIGEN.VC20_TABLE_TYPE;

BEGIN
l_ret_code := UNAPIAU.GetAttribute
(a_au,
a_version,
l_current_version,
a_effective_from,
a_effective_till,
a_description,
a_description2,
l_is_protected,
l_single_valued,
l_new_val_allowed,
l_store_db,
l_inherit_au,
l_shortcut,
l_value_list_tp,
a_default_value,
l_run_mode,
a_service,
a_cf_value,
a_au_class,
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
   a_current_version(l_row) := l_current_version(l_row) ;
   a_is_protected(l_row)   := l_is_protected(l_row) ;
   a_single_valued(l_row)  := l_single_valued(l_row) ;
   a_new_val_allowed(l_row):= l_new_val_allowed(l_row) ;
   a_store_db(l_row) := l_store_db(l_row) ;
   a_inherit_au(l_row) := l_inherit_au(l_row) ;
   a_shortcut(l_row) := 'shortcut' ; /* CONVERSION PROBLEMS !! */
   a_value_list_tp(l_row)  := l_value_list_tp(l_row) ;
   a_run_mode(l_row) := l_run_mode(l_row);
   a_log_hs(l_row)      := l_log_hs(l_row) ;
   a_allow_modify(l_row)   := l_allow_modify(l_row) ;
   a_active(l_row)      := l_active(l_row) ;
   END LOOP;
END IF;
RETURN(l_ret_code);

END GetAttribute;

END pbapiau;