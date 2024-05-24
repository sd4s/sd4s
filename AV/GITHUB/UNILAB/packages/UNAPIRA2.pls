create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapira2 IS

FUNCTION GetVersion
RETURN VARCHAR2;

----------------------------------------------------------------------------------------------
-- Pseudo Private Functions
-- should not be used by client - public since the package had to be splitted into 3 packages.
----------------------------------------------------------------------------------------------
FUNCTION Restore                                       /* INTERNAL */
(a_archive_to       IN     VARCHAR2,                   /* VC20_TYPE */
 a_archive_from     IN     VARCHAR2,                   /* VC20_TYPE */
 a_archive_id       IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TAB_TYPE */
 a_object_tp        IN     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TAB_TYPE */
 a_object_id        IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TAB_TYPE */
 a_object_version   IN     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TAB_TYPE */
 a_object_details   IN     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TAB_TYPE */
 a_archived_on      IN     UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TAB_TYPE */
 a_nr_of_rows       IN OUT NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

END unapira2;