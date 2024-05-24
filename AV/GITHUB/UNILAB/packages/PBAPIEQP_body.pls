create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapieqp AS

l_ret_code        NUMBER;
StpError          EXCEPTION;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION GetEqAttribute
(a_eq                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_lab                OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_au                 OUT   UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
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
l_row                 NUMBER;
l_is_protected        UNAPIGEN.CHAR1_TABLE_TYPE;
l_single_valued       UNAPIGEN.CHAR1_TABLE_TYPE;
l_new_val_allowed     UNAPIGEN.CHAR1_TABLE_TYPE;
l_store_db            UNAPIGEN.CHAR1_TABLE_TYPE;
l_value_list_tp       UNAPIGEN.CHAR1_TABLE_TYPE;
l_run_mode            UNAPIGEN.CHAR1_TABLE_TYPE;
a_object_version      UNAPIGEN.VC20_TABLE_TYPE;
a_au_version          UNAPIGEN.VC20_TABLE_TYPE;
BEGIN
   l_ret_code := UNAPIEQP.GetEqAttribute(a_eq,
                                         a_lab,
                                         a_au,
                                         a_au_version,
                                         a_value,
                                         a_description,
                                         l_is_protected,    /* CHAR1_TABLE_TYPE */
                                         l_single_valued,   /* CHAR1_TABLE_TYPE */
                                         l_new_val_allowed, /* CHAR1_TABLE_TYPE */
                                         l_store_db,        /* CHAR1_TABLE_TYPE */
                                         l_value_list_tp,   /* CHAR1_TABLE_TYPE */
                                         l_run_mode,        /* CHAR1_TABLE_TYPE */
                                         a_service,
                                         a_cf_value,
                                         a_nr_of_rows,
                                         a_where_clause);
   IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      FOR l_row IN 1..a_nr_of_rows LOOP
         a_is_protected(l_row) := l_is_protected(l_row);
         a_single_valued(l_row) := l_single_valued(l_row);
         a_new_val_allowed(l_row) := l_new_val_allowed(l_row);
         a_store_db(l_row) := l_store_db(l_row);
         a_value_list_tp(l_row) := l_value_list_tp(l_row);
         a_run_mode(l_row) := l_run_mode(l_row);
      END LOOP;
   END IF;
   RETURN (l_ret_code);
END GetEqAttribute;

FUNCTION GetEqAccess
(a_eq                IN      VARCHAR2,                  /* VC20_TYPE */
 a_lab               IN      VARCHAR2,                  /* VC20_TYPE */
 a_dd                OUT     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_data_domain       OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_access_rights     OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER)                    /* NUM_TYPE */
RETURN NUMBER IS
l_row                 NUMBER;
l_access_rights       UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN

   l_ret_code := UNAPIEQP.GetEqAccess(a_eq,
                                      a_lab,
                                      a_dd,
                                      a_data_domain ,
                                      l_access_rights, /* CHAR1_TABLE_TYPE */
                                      a_nr_of_rows);
   IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
    FOR l_row IN 1..a_nr_of_rows LOOP
      a_access_rights(l_row) := l_access_rights(l_row);
    END LOOP;
   END IF;
   RETURN (l_ret_code);
END GetEqAccess;

FUNCTION SaveEqAccess
(a_eq                 IN     VARCHAR2,                  /* VC20_TYPE */
 a_lab                IN     VARCHAR2,                  /* VC20_TYPE */
 a_dd                 IN     UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_access_rights      IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows         IN     NUMBER,                    /* NUM_TYPE */
 a_modify_reason      IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER IS
l_row                 NUMBER;
l_access_rights       UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN

   FOR l_row IN 1..a_nr_of_rows LOOP
      l_access_rights(l_row) := a_access_rights(l_row);
   END LOOP;
   l_ret_code := UNAPIEQP.SaveEqAccess(a_eq,
                                       a_lab,
                                       a_dd,
                                       l_access_rights, /* CHAR1_TABLE_TYPE */
                                       a_nr_of_rows,
                                       a_modify_reason);
   RETURN (l_ret_code);
END SaveEqAccess;

FUNCTION EqTransitionAuthorised
(a_eq                 IN        VARCHAR2,     /* VC20_TYPE */
 a_lab                IN        VARCHAR2,     /* VC20_TYPE */
 a_lc                 IN OUT    VARCHAR2,     /* VC2_TYPE */
 a_old_ss             IN OUT    VARCHAR2,     /* VC2_TYPE */
 a_new_ss             IN        VARCHAR2,     /* VC2_TYPE */
 a_authorised_by      IN        VARCHAR2,     /* VC20_TYPE */
 a_lc_ss_from         OUT       VARCHAR2,     /* VC2_TYPE */
 a_tr_no              OUT       NUMBER,       /* NUM_TYPE */
 a_allow_modify       OUT       VARCHAR2,     /* CHAR1_TYPE */
 a_active             OUT       VARCHAR2,     /* CHAR1_TYPE */
 a_log_hs             OUT       VARCHAR2)     /* CHAR1_TYPE */
RETURN NUMBER IS
   a_lc_version       VARCHAR2(20);
   l_allow_modify     CHAR(1);
   l_active           CHAR(1);
   l_log_hs           CHAR(1);
BEGIN

   /* TO BE REMOVED WHEN VERSION_CONTROL WILL BE SUPPORTED */
   a_lc_version := UNVERSION.P_NO_VERSION;
   /* end of TO BE REMOVED WHEN VERSION_CONTROL WILL BE SUPPORTED */

   l_ret_code := UNAPIEQP.EqTransitionAuthorised(a_eq,
                                                 a_lab,
                                                 a_lc,
                                                 a_lc_version,
                                                 a_old_ss,
                                                 a_new_ss,
                                                 a_authorised_by,
                                                 a_lc_ss_from,
                                                 a_tr_no,
                                                 a_allow_modify,
                                                 a_active,
                                                 a_log_hs);
   IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
      a_allow_modify := l_allow_modify;
      a_active       := l_active;
      a_log_hs       := l_log_hs;
   END IF;
   RETURN (l_ret_code);
END EqTransitionAuthorised;

END pbapieqp;