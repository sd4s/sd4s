create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapifi AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetBlob
(a_id              IN       VARCHAR2,
 a_description     OUT      VARCHAR2,
 a_object_link     OUT      VARCHAR2,
 a_key_1           OUT      VARCHAR2,
 a_key_2           OUT      VARCHAR2,
 a_key_3           OUT      VARCHAR2,
 a_key_4           OUT      VARCHAR2,
 a_key_5           OUT      VARCHAR2,
 a_url             OUT      VARCHAR2,
 a_data            OUT      BLOB )
RETURN NUMBER;

FUNCTION SaveBlob
(a_id              IN       VARCHAR2,
 a_description     IN       VARCHAR2,
 a_object_link     IN       VARCHAR2,
 a_key_1           IN       VARCHAR2,
 a_key_2           IN       VARCHAR2,
 a_key_3           IN       VARCHAR2,
 a_key_4           IN       VARCHAR2,
 a_key_5           IN       VARCHAR2,
 a_url             IN       VARCHAR2,
 a_data            IN       BLOB,
 a_modify_reason   IN       VARCHAR2)
RETURN NUMBER;

FUNCTION DeleteDocument
(a_id              IN       VARCHAR2,    /* VC20_TYPE */
 a_modify_reason   IN       VARCHAR2)    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CopyDocument
(a_original_id     IN       VARCHAR2,    /* VC20_TYPE */
 a_new_id          IN       VARCHAR2,    /* VC20_TYPE */
 a_modify_reason   IN       VARCHAR2)    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetFileList
(a_fi                      OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version                 OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current      OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till          OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_ss                      OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN       VARCHAR2,                  /* VC511_TYPE */
 a_next_rows               IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetFile
(a_fi                  OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version             OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_version_is_current  OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_effective_from      OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_effective_till      OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_creation_date       OUT      UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by          OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_dll_id              OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_dll_url             OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_cpp_id              OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_cpp_url             OUT      UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_log_hs              OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_log_hs_details      OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify        OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active              OUT      UNAPIGEN.CHAR1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc                  OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version          OUT      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                  OUT      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT   NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN       VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveFile
(a_fi                      IN    VARCHAR2,        /* VC20_TYPE */
 a_version                 IN    VARCHAR2,        /* VC20_TYPE */
 a_version_is_current      IN    CHAR,            /* CHAR1_TYPE */
 a_effective_from          IN    DATE,            /* DATE_TYPE */
 a_effective_till          IN    DATE,            /* DATE_TYPE */
 a_creation_date           IN    DATE,            /* DATE_TYPE */
 a_created_by              IN    VARCHAR2,        /* VC20_TYPE */
 a_dll_id                  IN    VARCHAR2,        /* VC20_TYPE */
 a_cpp_id                  IN    VARCHAR2,        /* VC20_TYPE */
 a_log_hs                  IN    CHAR,            /* CHAR1_TYPE */
 a_log_hs_details          IN    CHAR,            /* CHAR1_TYPE */
 a_lc                      IN    VARCHAR2,        /* VC2_TYPE */
 a_lc_version              IN    VARCHAR2,        /* VC20_TYPE */
 a_modify_reason           IN    VARCHAR2)        /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteFile
(a_fi                  IN       VARCHAR2,          /* VC20_TYPE */
 a_version             IN       VARCHAR2,          /* VC20_TYPE */
 a_modify_reason       IN       VARCHAR2)          /* VC255_TYPE */
RETURN NUMBER;

END unapifi;