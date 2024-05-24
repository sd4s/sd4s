create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapius AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION CreateUser
(a_us          IN VARCHAR2,                  /* VC20_TYPE */
 a_password    IN VARCHAR2,                  /* VC20_TYPE */
 a_up          IN NUMBER)                    /* LONG_TYPE */
RETURN NUMBER;

FUNCTION CreateUser
(a_us                      IN VARCHAR2,                  /* VC20_TYPE */
 a_identification_type     IN VARCHAR2,                  /* VC20_TYPE */
 a_identified_by_string    IN VARCHAR2,                  /* VC511_TYPE */
 a_up                      IN NUMBER)                    /* LONG_TYPE */
RETURN NUMBER;

FUNCTION CreateSharedUser4up
(a_us                      IN VARCHAR2,                  /* VC20_TYPE */
 a_up                      IN NUMBER)                    /* LONG_TYPE */
RETURN NUMBER;

FUNCTION GetUserAuthenticationList
(a_us                      OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_identification_type     OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_identified_by_string    OUT      UNAPIGEN.VC511_TABLE_TYPE,  /* VC511_TABLE_TYPE */
 a_up                      OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                     /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION CreateUserStructures
(a_us          IN VARCHAR2,                   /* VC20_TYPE */
 a_up          IN NUMBER)                     /* LONG_TYPE */
RETURN NUMBER;

FUNCTION DeleteUser
(a_us          IN VARCHAR2,                   /* VC20_TYPE */
 a_up          IN NUMBER)                     /* LONG_TYPE */
RETURN NUMBER;

FUNCTION DeleteUserStructures
(a_us          IN VARCHAR2,                   /* VC20_TYPE */
 a_up          IN NUMBER)                     /* LONG_TYPE */
RETURN NUMBER;

FUNCTION AllowApi
(a_us          IN VARCHAR2)                   /* VC20_TYPE */
RETURN NUMBER;

FUNCTION NewDataDomain                        /* INTERNAL */
(a_us          IN VARCHAR2,                   /* VC20_TYPE */
 a_up          IN NUMBER)                     /* LONG_TYPE */
RETURN NUMBER;

FUNCTION NewSharedUser4up                     /* INTERNAL */
(a_us          IN VARCHAR2,                   /* VC20_TYPE */
 a_up          IN NUMBER)                     /* LONG_TYPE */
RETURN NUMBER;

FUNCTION GetExperienceLevelList
(a_el               OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT   NUMBER,                    /* NUM_TYPE         */
 a_where_clause     IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetUpUsExperienceLevel
(a_up               OUT      UNAPIGEN.LONG_TABLE_TYPE,   /* LONG_TABLE_TYPE */
 a_us               OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_el               OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_is_enabled       OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN OUT   NUMBER,                     /* NUM_TYPE         */
 a_where_clause     IN       VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveUpUsExperienceLevel
(a_up                      IN       NUMBER,                      /* LONG_TYPE        */
 a_us                      IN       VARCHAR2,                    /* VC20_TYPE        */
 a_el                      IN       UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE  */
 a_is_enabled              IN       UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE  */
 a_nr_of_rows              IN       NUMBER,                      /* NUM_TYPE         */
 a_modify_reason           IN       VARCHAR2)                    /* VC255_TYPE       */
RETURN NUMBER;

FUNCTION GetUserList                                          /* INTERNAL */
(a_dn            OUT     UNAPIGEN.VC255_TABLE_TYPE,           /* VC255_TABLE_TYPE */
 a_display_name  OUT     UNAPIGEN.VC255_TABLE_TYPE,           /* VC255_TABLE_TYPE */
 a_connect_id    OUT     UNAPIGEN.VC20_TABLE_TYPE,            /* VC20_TABLE_TYPE */
 a_email         OUT     UNAPIGEN.VC255_TABLE_TYPE,           /* VC255_TABLE_TYPE */
 a_nr_of_rows    IN OUT  NUMBER,                              /* NUM_TYPE */
 a_where_clause  IN      VARCHAR2)                            /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SynchSharedUser4up                   /* INTERNAL */
(a_up          IN NUMBER)                     /* LONG_TYPE */
RETURN NUMBER;

END unapius;