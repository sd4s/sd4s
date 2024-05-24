create or replace PACKAGE unarchive IS

-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION PrepareToArchive
(a_archive_id       IN VARCHAR2,         /* VC20_TYPE */
 a_archive_to       IN VARCHAR2,         /* VC40_TYPE */
 a_archfile         IN VARCHAR2)         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION AfterArchive
(a_archive_id       IN VARCHAR2,         /* VC20_TYPE */
 a_archive_to       IN VARCHAR2,         /* VC40_TYPE */
 a_archfile         IN VARCHAR2)         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION PrepareToRestore
(a_archive_to       IN    VARCHAR2,                 /* VC40_TYPE */
 a_archive_from     IN    VARCHAR2,                 /* VC20_TYPE */
 a_archive_id       IN    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_object_tp        IN    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_object_id        IN    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_object_version   IN    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_object_details   IN    UNAPIGEN.VC255_TABLE_TYPE,/* VC255_TAB_TYPE */
 a_archived_on      IN    UNAPIGEN.DATE_TABLE_TYPE, /* DATE_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER)                  /* NUM_TYPE */
RETURN NUMBER;

FUNCTION AfterRestore
(a_archive_to       IN    VARCHAR2,                 /* VC40_TYPE */
 a_archive_from     IN    VARCHAR2,                 /* VC20_TYPE */
 a_archive_id       IN    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_object_tp        IN    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_object_id        IN    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_object_version   IN    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_object_details   IN    UNAPIGEN.VC255_TABLE_TYPE,/* VC255_TAB_TYPE */
 a_archived_on      IN    UNAPIGEN.DATE_TABLE_TYPE, /* DATE_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER)                  /* NUM_TYPE */
RETURN NUMBER;

END unarchive;