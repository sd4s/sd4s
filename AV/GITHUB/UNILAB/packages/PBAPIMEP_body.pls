create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapimep AS

l_ret_code   NUMBER;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION GetScMeGroupKey
(a_sc              OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pg              OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_pgnode          OUT    UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_pa              OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_panode          OUT    UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_me              OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_menode          OUT    UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_gk              OUT    UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_gk_version      OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value           OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_description     OUT    UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_is_protected    OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_value_unique    OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_single_valued   OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_new_val_allowed OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_mandatory       OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_value_list_tp   OUT    PBAPIGEN.VC1_TABLE_TYPE,    /* CHAR1_TABLE_TYPE */
 a_dsp_rows        OUT    UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows      IN OUT NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN     VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER IS

l_row               NUMBER ;
l_is_protected      UNAPIGEN.CHAR1_TABLE_TYPE ;
l_value_unique      UNAPIGEN.CHAR1_TABLE_TYPE ;
l_single_valued     UNAPIGEN.CHAR1_TABLE_TYPE ;
l_new_val_allowed   UNAPIGEN.CHAR1_TABLE_TYPE ;
l_mandatory         UNAPIGEN.CHAR1_TABLE_TYPE ;
l_value_list_tp     UNAPIGEN.CHAR1_TABLE_TYPE ;

BEGIN

l_ret_code := UNAPIMEP.GetScMeGroupKey
(a_sc,
 a_pg,
 a_pgnode,
 a_pa,
 a_panode,
 a_me,
 a_menode,
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
 a_where_clause) ;

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
    FOR l_row IN 1..a_nr_of_rows LOOP
       a_is_protected(l_row) := l_is_protected(l_row) ;
       a_value_unique(l_row) := l_value_unique(l_row) ;
       a_single_valued(l_row) := l_single_valued(l_row) ;
       a_new_val_allowed(l_row) := l_new_val_allowed(l_row) ;
       a_mandatory(l_row) := l_mandatory(l_row) ;
       a_value_list_tp(l_row) := l_value_list_tp(l_row) ;
    END LOOP ;
 END IF ;

 RETURN (l_ret_code) ;

END GetScMeGroupKey;


FUNCTION InitScMeAttribute
(a_sc               IN     VARCHAR2,                  /* VC20_TYPE */
 a_pr               IN     VARCHAR2,                  /* VC20_TYPE */
 a_pr_version       IN     VARCHAR2,                  /* VC20_TYPE */
 a_mt               IN     VARCHAR2,                  /* VC20_TYPE */
 a_mt_version       IN     VARCHAR2,                  /* VC20_TYPE */
 a_au               OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au_version       OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected     OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_store_db         OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_run_mode         OUT    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_service          OUT    UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cf_value         OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER)                    /* NUM_TYPE */
RETURN NUMBER IS

l_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE ;
l_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE ;
l_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE ;
l_store_db        UNAPIGEN.CHAR1_TABLE_TYPE ;
l_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE ;
l_run_mode        UNAPIGEN.CHAR1_TABLE_TYPE ;
l_row             NUMBER ;

BEGIN

l_ret_code := UNAPIMEP.InitScMeAttribute
(a_sc,
 a_pr,
 a_pr_version,
 a_mt,
 a_mt_version,
 a_au,
 a_au_version,
 a_value,
 a_description,
 l_is_protected,
 l_single_valued,
 l_new_val_allowed,
 l_store_db,
 l_value_list_tp,
 l_run_mode,
 a_service,
 a_cf_value,
 a_nr_of_rows) ;

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
    FOR l_row IN 1..a_nr_of_rows LOOP
       a_is_protected(l_row) := l_is_protected(l_row) ;
       a_single_valued(l_row) := l_single_valued(l_row) ;
       a_new_val_allowed(l_row) := l_new_val_allowed(l_row) ;
       a_store_db(l_row) := l_store_db(l_row) ;
       a_value_list_tp(l_row) := l_value_list_tp(l_row) ;
       a_run_mode(l_row) := l_run_mode(l_row) ;
    END LOOP ;
 END IF ;

 RETURN (l_ret_code) ;

END InitScMeAttribute;


FUNCTION GetScMeAttribute
(a_sc               OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pg               OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_pgnode           OUT   UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_pa               OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_panode           OUT   UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_me               OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_menode           OUT   UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_au               OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au_version       OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description      OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected     OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_store_db         OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_run_mode         OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_service          OUT   UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cf_value         OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER IS

l_row             NUMBER ;
l_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE ;
l_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE ;
l_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE ;
l_store_db        UNAPIGEN.CHAR1_TABLE_TYPE ;
l_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE ;
l_run_mode        UNAPIGEN.CHAR1_TABLE_TYPE ;

BEGIN

l_ret_code := UNAPIMEP.GetScMeAttribute
(a_sc,
 a_pg,
 a_pgnode,
 a_pa,
 a_panode,
 a_me,
 a_menode,
 a_au,
 a_au_version,
 a_value,
 a_description,
 l_is_protected,
 l_single_valued,
 l_new_val_allowed,
 l_store_db,
 l_value_list_tp,
 l_run_mode,
 a_service,
 a_cf_value,
 a_nr_of_rows,
 a_where_clause) ;

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
    FOR l_row IN 1..a_nr_of_rows LOOP
       l_is_protected(l_row) := l_is_protected(l_row) ;
       l_single_valued(l_row) := l_single_valued(l_row) ;
       l_new_val_allowed(l_row) := l_new_val_allowed(l_row) ;
       l_store_db(l_row) := l_store_db(l_row) ;
       l_value_list_tp(l_row) := l_value_list_tp(l_row) ;
       l_run_mode(l_row) := l_run_mode(l_row) ;
    END LOOP ;
 END IF ;

 RETURN (l_ret_code) ;

END GetScMeAttribute;

END pbapimep;