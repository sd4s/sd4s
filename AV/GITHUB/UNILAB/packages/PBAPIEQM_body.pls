create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapieqm AS

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

FUNCTION ChangeEqCaStatus
(a_eq                IN      VARCHAR2,     /* VC20_TYPE */
 a_lab               IN      VARCHAR2,     /* VC20_TYPE */
 a_ca                IN      VARCHAR2,     /* VC20_TYPE */
 a_new_ca_warn_level IN      VARCHAR2,     /* CHAR_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER IS

l_new_ca_warn_level  CHAR(1) ;

BEGIN
l_new_ca_warn_level := a_new_ca_warn_level;
l_ret_code := UNAPIEQM.ChangeEqCaStatus
(a_eq,
 a_lab,
 a_ca,
 l_new_ca_warn_level,
 a_modify_reason);

 RETURN (l_ret_code) ;

END ChangeEqCaStatus ;

FUNCTION AddEqCaLog
(a_eq            IN        VARCHAR2,      /* VC20_TYPE */
 a_lab           IN        VARCHAR2,      /* VC20_TYPE */
 a_ca            IN        VARCHAR2,      /* VC20_TYPE */
 a_who           IN        VARCHAR2,      /* VC20_TYPE */
 a_logdate       IN        DATE,          /* DATE_TYPE */
 a_sc            IN        VARCHAR2,      /* VC20_TYPE */
 a_pg            IN        VARCHAR2,      /* VC20_TYPE */
 a_pgnode        IN        NUMBER,        /* LONG_TYPE */
 a_pa            IN        VARCHAR2,      /* VC20_TYPE */
 a_panode        IN        NUMBER,        /* LONG_TYPE */
 a_me            IN        VARCHAR2,      /* VC20_TYPE */
 a_menode        IN        NUMBER,        /* LONG_TYPE */
 a_ca_warn_level IN        VARCHAR2,      /* CHAR_TYPE */
 a_modify_reason IN        VARCHAR2)      /* VC255_TYPE */
RETURN NUMBER IS

l_ca_warn_level  CHAR(1) ;

BEGIN
l_ret_code := UNAPIEQM.AddEqCaLog
(a_eq,
 a_lab,
 a_ca,
 a_who,
 a_logdate,
 a_sc,
 a_pg,
 a_pgnode,
 a_pa,
 a_panode,
 a_me,
 a_menode,
 l_ca_warn_level,
 a_modify_reason);

 RETURN (l_ret_code) ;

END AddEqCaLog ;

FUNCTION GetEqCaLog
(a_eq             OUT      VARCHAR2,                    /* VC20_TYPE */
 a_lab            OUT      VARCHAR2,                    /* VC20_TYPE */
 a_ca             OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_who            OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_logdate        OUT      UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE  */
 a_sc             OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pg             OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_pgnode         OUT      UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_pa             OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_panode         OUT      UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_me             OUT      UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_menode         OUT      UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_ca_warn_level  OUT      PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE   */
 a_why            OUT      UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows     IN OUT   NUMBER,                      /* NUM_TYPE */
 a_where_clause   IN       VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER IS

l_ca_warn_level            UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_row       NUMBER ;

BEGIN
l_ret_code := UNAPIEQM.GetEqCaLog
(a_eq,
 a_lab,
 a_ca,
 a_who,
 a_logdate,
 a_sc,
 a_pg,
 a_pgnode,
 a_pa,
 a_panode,
 a_me,
 a_menode,
 l_ca_warn_level,
 a_why,
 a_nr_of_rows,
 a_where_clause);

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
 FOR l_row IN 1..a_nr_of_rows LOOP
  a_ca_warn_level  (l_row) := l_ca_warn_level  (l_row);
 END LOOP ;
END IF ;
RETURN (l_ret_code);

END GetEqCaLog;

END pbapieqm ;