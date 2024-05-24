create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiicp AS

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

FUNCTION GetScIcAttribute
(a_sc                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode             OUT   UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_au                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au_version         OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value              OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_description        OUT   UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_protected       OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued      OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed    OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_store_db           OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp      OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_run_mode           OUT   PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_service            OUT   UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cf_value           OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows         IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause       IN     VARCHAR2)                 /* VC511_TYPE */
RETURN NUMBER IS

l_row             NUMBER ;
l_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE ;
l_single_valued   UNAPIGEN.CHAR1_TABLE_TYPE ;
l_new_val_allowed UNAPIGEN.CHAR1_TABLE_TYPE ;
l_store_db        UNAPIGEN.CHAR1_TABLE_TYPE ;
l_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE ;
l_run_mode        UNAPIGEN.CHAR1_TABLE_TYPE ;

BEGIN

l_ret_code := UNAPIICP.GetScIcAttribute
(a_sc,
 a_ic,
 a_icnode,
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
       a_is_protected(l_row) := l_is_protected(l_row) ;
       a_single_valued(l_row) := l_single_valued(l_row) ;
       a_new_val_allowed(l_row) := l_new_val_allowed(l_row) ;
       a_store_db(l_row) := l_store_db(l_row) ;
       a_value_list_tp(l_row) := l_value_list_tp(l_row) ;
       a_run_mode(l_row) := l_run_mode(l_row) ;
    END LOOP ;
 END IF ;

 RETURN (l_ret_code) ;

END GetScIcAttribute;


FUNCTION GetScIcAccess /* TMPLC_INTERNAL */
(a_sc                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ic                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_icnode            OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_dd                OUT     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_data_domain       OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_access_rights     OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause      IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER IS

l_row           NUMBER ;
l_access_rights UNAPIGEN.CHAR1_TABLE_TYPE ;

BEGIN

l_ret_code := UNAPIICP.GetScIcAccess
(a_sc,
 a_ic,
 a_icnode,
 a_dd,
 a_data_domain,
 l_access_rights,
 a_nr_of_rows,
 a_where_clause) ;

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
    FOR l_row IN 1..a_nr_of_rows LOOP
       a_access_rights(l_row) := l_access_rights(l_row) ;
    END LOOP ;
 END IF ;

 RETURN (l_ret_code);

END GetScICAccess;


FUNCTION SaveScIcAccess
(a_sc                IN      VARCHAR2,                  /* VC20_TYPE */
 a_ic                IN      VARCHAR2,                  /* VC20_TYPE */
 a_icnode            IN      NUMBER,                    /* LONG_TYPE */
 a_dd                IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_access_rights     IN      PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason     IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER IS

l_row           NUMBER ;
l_access_rights UNAPIGEN.CHAR1_TABLE_TYPE ;

BEGIN
FOR l_row IN 1..a_nr_of_rows LOOP
   l_access_rights(l_row) := a_access_rights(l_row) ;
END LOOP ;

l_ret_code := UNAPIICP.SaveScIcAccess
(a_sc,
 a_ic,
 a_icnode,
 a_dd,
 l_access_rights,
 a_nr_of_rows,
 a_modify_reason) ;

RETURN (l_ret_code);

END SaveScIcAccess;

/* --------------------------------------------------------------------- */
/*                   the initialisation code                             */
/* --------------------------------------------------------------------- */
BEGIN
   NULL;
END pbapiicp;