create or replace PACKAGE
-- Unilab 4.0 Package
-- $Revision: 7 $
-- $Date: 27/10/03 10:10 $
Unversion AS

P_INITIAL_VERSION           CONSTANT VARCHAR2(20) := '0001.00';
-- That string that will be used to return the very first version
-- Verify all functions of this package when modifying this default
--

P_NO_VERSION                CONSTANT VARCHAR2(20) := '0';
--That string that will be used:
--  1. during the upgrade process to mark the object that have been created oustide version control (before the instalation of 4.4)
--  2. to mark object for which version control has not been implemented (like users, group keys, ...).
--  Note that version must be excluded in queries returning the highest minor and major version
--  in GetHighestMinorVersion and GetHighestMajorVersion.
--  a function with a similar name is used in order to be able to use is in sql statements
FUNCTION SQL_NO_VERSION                 /* INTERNAL */
RETURN VARCHAR2;

FUNCTION GetNextMinorVersion
(a_version          IN OUT  VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetNextMajorVersion
(a_version          IN OUT  VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetPreviousMinorVersion
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN OUT  VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetHighestMinorVersion
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN OUT  VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetHighestMajorVersion
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN OUT  VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetPpHighestMinorVersion
(a_pp               IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN OUT  VARCHAR2, /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetPpHighestMajorVersion
(a_pp               IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN OUT  VARCHAR2, /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2) /* VC20_TYPE */
RETURN NUMBER;

--SQL versions that may be used in SQL statements
FUNCTION SQLGetNextMajorVersion
(a_version          IN VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2;

FUNCTION SQLGetNextMinorVersion
(a_version          IN VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2;

FUNCTION SQLGetHighestMajorVersion    /* INTERNAL */
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN      VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2;

FUNCTION SQLGetHighestMinorVersion    /* INTERNAL */
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN      VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2;

FUNCTION SQLGetPreviousMinorVersion    /* INTERNAL */
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN      VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2;

FUNCTION SQLGetPpHighestMajorVersion    /* INTERNAL */
(a_pp               IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2;

FUNCTION SQLGetPpHighestMinorVersion    /* INTERNAL */
(a_pp               IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2;

FUNCTION ConvertInterspec2Unilab
(a_object_tp        IN      VARCHAR2,  /* VC4_TYPE */
 a_object_id        IN      VARCHAR2,  /* VC20_TYPE */
 a_revision         IN      NUMBER)    /* NUM_TYPE */
RETURN VARCHAR2;

FUNCTION ConvertInterspec2UnilabPp
(a_pp               IN      VARCHAR2,  /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2,  /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2,  /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2,  /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2,  /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2,  /* VC20_TYPE */
 a_revision         IN      NUMBER)    /* NUM_TYPE */
RETURN VARCHAR2;

FUNCTION GetMajorVersionOnly
(a_version          IN      VARCHAR2)   /* VC20_TYPE */
RETURN VARCHAR2;

END Unversion;
 