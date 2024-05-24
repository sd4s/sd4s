create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapieqm AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION ChangeEqCaStatus
(a_eq                IN      VARCHAR2,     /* VC20_TYPE */
 a_lab               IN      VARCHAR2,     /* VC20_TYPE */
 a_ca                IN      VARCHAR2,     /* VC20_TYPE */
 a_new_ca_warn_level IN      VARCHAR2,     /* CHAR_TYPE */
 a_modify_reason     IN      VARCHAR2)     /* VC255_TYPE */
RETURN NUMBER;

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
RETURN NUMBER;

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
RETURN NUMBER;
END pbapieqm ;