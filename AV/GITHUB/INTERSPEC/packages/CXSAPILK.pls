CREATE OR REPLACE PACKAGE INTERSPC.-- CXsuite Package
-- $Revision: 5 $
-- $Date: 9/03/06 15:29 $
cxsapilk AS


------------------------------------------------------------------------------
-----------                ALM package for Unilab/Interspec           --------
-----------          License Package header script (cxsapilk.h)     ----------
------------------------------------------------------------------------------
-- Functions :
-- 1. SaveLicense
-- 2. DeleteLicense
-- 3. SaveLicenseTemplate
-- 4. DeleteLicenseTemplate
-- 5. GetLicense
-- 6. getLicenseTemplate
-- 7. CheckLicense
-- 8. GrantLicense
-- 9. PingLicense
-- 10. FreeLicense
-- 11. GetActualLicenseUsage
-- 12. ConvertOldInterspecLicense
-- 13. ConvertOldUnilabLicense
-- 14. IsDBAUser
-- 15. InsertRecoveryRecord
------------------------------------------------------------------------------


--Array Types used in the interfaces of this package functions
TYPE VC20_TABLE_TYPE  IS TABLE OF VARCHAR2(20)       INDEX BY BINARY_INTEGER;
TYPE VC40_TABLE_TYPE  IS TABLE OF VARCHAR2(40)       INDEX BY BINARY_INTEGER;
TYPE VC255_TABLE_TYPE IS TABLE OF VARCHAR2(255)      INDEX BY BINARY_INTEGER;
TYPE NUM_TABLE_TYPE   IS TABLE OF NUMBER             INDEX BY BINARY_INTEGER;
TYPE DATE_TABLE_TYPE  IS TABLE OF VARCHAR2(30)       INDEX BY BINARY_INTEGER;
TYPE BLOB_TABLE_TYPE   IS TABLE OF BLOB             INDEX BY BINARY_INTEGER;
TYPE RAW16_TABLE_TYPE  IS TABLE OF RAW(16)          INDEX BY BINARY_INTEGER;
TYPE RAW160_TABLE_TYPE  IS TABLE OF RAW(160)        INDEX BY BINARY_INTEGER;
TYPE RAW1020_TABLE_TYPE  IS TABLE OF RAW(1020)      INDEX BY BINARY_INTEGER;

--possible error codes
DBERR_SUCCESS                  CONSTANT INTEGER := 0;
DBERR_GENFAIL                  CONSTANT INTEGER := 1;
DBERR_NORECORDS                CONSTANT INTEGER := 11;
DBERR_OK_NO_ALM                CONSTANT INTEGER := 1100;
DBERR_INVALIDLICENSE           CONSTANT INTEGER := 1101;
DBERR_LICENSEEXPIRED           CONSTANT INTEGER := 1102;
DBERR_NOLICENSE4APP            CONSTANT INTEGER := 1103;
DBERR_TOOMANYUSERS4ALM         CONSTANT INTEGER := 1104;

--public variables setting the default value and the maximum limit for a_nr_of_rows argument
P_DEFAULT_CHUNK_SIZE   NUMBER DEFAULT 100;
P_MAX_CHUNK_SIZE       NUMBER DEFAULT 5000;

FUNCTION SaveLicense
(a_serial_id            IN          VARCHAR2,                   /* VC40_TYPE */
 a_shortname            IN          VARCHAR2,                   /* VC40_TYPE */
 a_setting_name         IN          CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_setting_value        IN          CXSAPILK.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows           IN          NUMBER,                     /* NUM_TYPE */
 a_hash_code_client     IN          VARCHAR2,                   /* VC255_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteLicense
(a_serial_id            IN          VARCHAR2,                   /* VC40_TYPE */
 a_shortname            IN          VARCHAR2,                   /* VC40_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveLicenseTemplate
(a_serial_id            IN          VARCHAR2,                   /* VC40_TYPE */
 a_shortname            IN          VARCHAR2,                   /* VC40_TYPE */
 a_template             IN          BLOB,                       /* BLOB_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveLicenseTemplate
(a_serial_id            IN          CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_shortname            IN          CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_template             IN          CXSAPILK.BLOB_TABLE_TYPE,   /* BLOB_TABLE_TYPE */
 a_nr_of_rows           IN          NUMBER,                     /* NUM_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteLicenseTemplate
(a_serial_id            IN          CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_shortname            IN          CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows           IN          NUMBER,                     /* NUM_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetLicense
(a_serial_id               OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_shortname               OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_setting_name            OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_setting_value           OUT      CXSAPILK.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows           IN OUT      NUMBER,                     /* NUM_TYPE */
 a_search_criteria1     IN          VARCHAR2,                   /* VC20_TYPE */
 a_search_id1           IN          VARCHAR2,                   /* VC511_TYPE */
 a_search_criteria2     IN          VARCHAR2,                   /* VC20_TYPE */
 a_search_id2           IN          VARCHAR2,                   /* VC511_TYPE */
 a_next_rows            IN          NUMBER,                     /* NUM_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetLicenseTemplate
(a_serial_id            IN          VARCHAR2,                   /* VC40_TYPE */
 a_shortname            IN          VARCHAR2,                   /* VC40_TYPE */
 a_template                OUT      BLOB,                       /* BLOB_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetLicenseTemplate
(a_serial_id               OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_shortname               OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_template                OUT      CXSAPILK.BLOB_TABLE_TYPE,   /* BLOB_TABLE_TYPE */
 a_nr_of_rows           IN OUT      NUMBER,                     /* NUM_TYPE */
 a_search_criteria1     IN          VARCHAR2,                   /* VC20_TYPE */
 a_search_id1           IN          VARCHAR2,                   /* VC511_TYPE */
 a_search_criteria2     IN          VARCHAR2,                   /* VC20_TYPE */
 a_search_id2           IN          VARCHAR2,                   /* VC511_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CheckLicense
(a_app_id               IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_version          IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_lic_check_ok_4_app      OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_max_users_4_app         OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows           IN          NUMBER,                     /* NUM_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CheckLicense
(a_app_id               IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_version          IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_custom_param     IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_lic_check_ok_4_app      OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_max_users_4_app         OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows           IN          NUMBER,                     /* NUM_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GrantLicense
(a_app_id               IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_version          IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_logon_station        IN          CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_user_sid             IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_user_name            IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_of_rows           IN          NUMBER,                     /* NUM_TYPE */
 a_error_code              OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

/* for Interspec only for app_id=IISC to be able to make the difference between */
FUNCTION GrantLicense
(a_app_id               IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_version          IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_custom_param     IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_logon_station        IN          CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_user_sid             IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_user_name            IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_of_rows           IN          NUMBER,                     /* NUM_TYPE */
 a_error_code              OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION PingLicense
(a_app_id               IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_version          IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_logon_station        IN          CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_user_sid             IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_user_name            IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_of_rows           IN          NUMBER,                     /* NUM_TYPE */
 a_error_code              OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION PingLicense
(a_app_id               IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_version          IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_custom_param     IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_logon_station        IN          CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_user_sid             IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_user_name            IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_of_rows           IN          NUMBER,                     /* NUM_TYPE */
 a_error_code              OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION FreeLicense
(a_app_id               IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_version          IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_logon_station        IN          CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_user_sid             IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_user_name            IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_of_rows           IN          NUMBER,                     /* NUM_TYPE */
 a_error_code              OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION FreeLicense
(a_app_id               IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_version          IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_custom_param     IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_logon_station        IN          CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_user_sid             IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_user_name            IN          CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_of_rows           IN          NUMBER,                     /* NUM_TYPE */
 a_error_code              OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetActualLicenseUsage
(a_app_id                  OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_version             OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_logon_station           OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_user_sid                OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_user_name               OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_logon_date              OUT      CXSAPILK.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_last_heartbeat          OUT      CXSAPILK.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_lic_consumed            OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_executable              OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_nr_of_rows          IN  OUT      NUMBER,                     /* NUM_TYPE */
 a_search_criteria     IN           VARCHAR2,                   /* VC20_TYPE */
 a_search_id           IN           VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN           NUMBER,                     /* NUM_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetActualLicenseUsage
(a_app_id                  OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_version             OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_logon_station           OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_user_sid                OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_user_name               OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_logon_date              OUT      CXSAPILK.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_last_heartbeat          OUT      CXSAPILK.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_lic_consumed            OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_executable              OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_lic_consumed_serial_id  OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_lic_consumed_shortname  OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN  OUT      NUMBER,                     /* NUM_TYPE */
 a_search_criteria     IN           VARCHAR2,                   /* VC20_TYPE */
 a_search_id           IN           VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN           NUMBER,                     /* NUM_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetActualLicenseUsage
(a_app_id                  OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_version             OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_app_custom_param        OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_logon_station           OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_user_sid                OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_user_name               OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_logon_date              OUT      CXSAPILK.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_last_heartbeat          OUT      CXSAPILK.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_lic_consumed            OUT      CXSAPILK.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_executable              OUT      CXSAPILK.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_lic_consumed_serial_id  OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_lic_consumed_shortname  OUT      CXSAPILK.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN  OUT      NUMBER,                     /* NUM_TYPE */
 a_search_criteria     IN           VARCHAR2,                   /* VC20_TYPE */
 a_search_id           IN           VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN           NUMBER,                     /* NUM_TYPE */
 a_error_message           OUT      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

PROCEDURE ConvertOldInterspecLicense
(a_ispcdba_schema   IN VARCHAR2);

PROCEDURE ConvertOldUnilabLicense
(a_uldba_schema   IN VARCHAR2);

FUNCTION IsDBAUser
RETURN NUMBER;

PROCEDURE TestHashCode(a_string_to_hash IN VARCHAR2);

PROCEDURE InsertRecoveryRecord;

--debugging only
PROCEDURE DebugMe(a_flag IN CHAR);

END cxsapilk;
/
