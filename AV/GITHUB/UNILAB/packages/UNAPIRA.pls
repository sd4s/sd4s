create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapira IS

P_CLOSE_CURSOR             CONSTANT CHAR(1) := '1';
P_DO_NOT_CLOSE_CURSOR      CONSTANT CHAR(1) := '0';

P_PUBLIC_SEP               CONSTANT CHAR(1) := CHR(9);  -- The TAB character is used as separator in the final archive file
P_SEP                      CONSTANT CHAR(1) := CHR(9);  -- The TAB character is used as separator in the final archive file
-- P_INTERNAL_SEP is the separator used internally by the archive module to avoid conflicts with
-- the tab characters which are really making part of the data values. The archive file only contains the public separator.
P_INTERNAL_SEP             CONSTANT CHAR(1) := CHR(17); -- Used as internal separator in ArchiveXXToFile
                                                        -- Free character in ASCII code
                                                        -- This character is not making part

-- Special strings used to replace the special characters that are potential problems for the archiving.
-- Tabs are used as separator by archiving. Carriage return and tab characters are also interpreted by UTL_FILE.
P_REPL_TAB                 CONSTANT CHAR(5) := '<TAB>';
P_REPL_CR                  CONSTANT CHAR(4) := '<CR>';
P_REPL_LF                  CONSTANT CHAR(4) := '<LF>';

P_MAXCOLUMNSBYTABLE        CONSTANT INTEGER := 200;

P_ARCH_FILE_HANDLE         UTL_FILE.FILE_TYPE;
P_FILE_DIR                 VARCHAR2(255);
P_FILE_NAME                VARCHAR2(20);
P_TSTZ_FORMAT              VARCHAR2(40);
P_CURR_DATE                TIMESTAMP WITH TIME ZONE;
P_CURR_DATE_STRING         VARCHAR2(40);
P_ARCHIVER_VERSION         VARCHAR2(20);
P_ARCHIVE_ARCHIVER_VERSION VARCHAR2(20);
P_ARCHIVE_TSTZ_FORMAT      VARCHAR2(40);

P_DBMS_OUTPUT              BOOLEAN DEFAULT FALSE;

CURSOR c_system (a_setting_name VARCHAR2) IS
   SELECT setting_value
     FROM utsystem
    WHERE setting_name = a_setting_name;

CURSOR c_toarchive_cursor(c_archive_to VARCHAR2, c_archive_id VARCHAR2) IS
   SELECT *
     FROM uttoarchive
    WHERE archive_to = c_archive_to
      AND archive_id = c_archive_id
      AND NVL(archive_on, CAST(CURRENT_TIMESTAMP AS TIMESTAMP(0) WITH TIME ZONE)) <= CAST(CURRENT_TIMESTAMP AS TIMESTAMP(0) WITH TIME ZONE)
      AND NVL(handled_ok, '0') = '0';

CURSOR l_allwsgk_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          DECODE(SUBSTR(table_name,1,6), 'UTWSGK', 1, 2) table_order1,
          LENGTH(table_name) table_order2
     FROM user_tab_columns
    WHERE column_name = 'WS'
      AND (table_name LIKE 'UTWSGK%')
    ORDER BY 2 ASC, 3 ASC, 1 ASC;

CURSOR l_allscgk_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          DECODE(SUBSTR(table_name,1,6), 'UTSCGK', 1, 'UTSCME', 2, 3) table_order1,
          LENGTH(table_name) table_order2
     FROM user_tab_columns
    WHERE column_name = 'SC'
      AND (table_name LIKE 'UTSCGK%' OR table_name LIKE 'UTSCMEGK%')
    ORDER BY 2 ASC, 3 ASC, 1 ASC;

CURSOR l_allstgk_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          DECODE(SUBSTR(table_name,1,6), 'UTSTGK', 1, 2) table_order1,
          LENGTH(table_name) table_order2
     FROM user_tab_columns
    WHERE column_name = 'ST'
      AND (table_name LIKE 'UTSTGK%')
    ORDER BY 2 ASC, 3 ASC, 1 ASC;

CURSOR l_allrqgk_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          DECODE(SUBSTR(table_name,1,6), 'UTRQGK', 1, 2) table_order1,
          LENGTH(table_name) table_order2
     FROM user_tab_columns
    WHERE column_name = 'RQ'
      AND table_name LIKE 'UTRQGK%'
    ORDER BY 2 ASC, 3 ASC, 1 ASC;

CURSOR l_allrtgk_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          DECODE(SUBSTR(table_name,1,6), 'UTRTGK', 1, 2) table_order1,
          LENGTH(table_name) table_order2
     FROM user_tab_columns
    WHERE column_name = 'RT'
      AND (table_name LIKE 'UTRTGK%')
    ORDER BY 2 ASC, 3 ASC, 1 ASC;

CURSOR l_allsdgk_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          DECODE(SUBSTR(table_name,1,6), 'UTSDGK', 1, 2) table_order1,
          LENGTH(table_name) table_order2
     FROM user_tab_columns
    WHERE column_name = 'SD'
      AND table_name LIKE 'UTSDGK%'
    ORDER BY 2 ASC, 3 ASC, 1 ASC;

CURSOR l_allptgk_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          DECODE(SUBSTR(table_name,1,6), 'UTPTGK', 1, 2) table_order1,
          LENGTH(table_name) table_order2
     FROM user_tab_columns
    WHERE column_name = 'PT'
      AND (table_name LIKE 'UTPTGK%')
    ORDER BY 2 ASC, 3 ASC, 1 ASC;

CURSOR l_allsccustom_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          LENGTH(table_name) table_order1
     FROM user_tab_columns
    WHERE column_name = 'SC'
      AND table_name LIKE 'AT%'
    ORDER BY 2 ASC, 1 ASC;

CURSOR l_allwscustom_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          LENGTH(table_name) table_order1
     FROM user_tab_columns
    WHERE column_name = 'WS'
      AND table_name LIKE 'AT%'
    ORDER BY 2 ASC, 1 ASC;

CURSOR l_allatcustom_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          LENGTH(table_name) table_order1
     FROM user_tables
    WHERE table_name NOT IN (SELECT table_name
                               FROM user_tab_columns
                              WHERE column_name IN ('SC', 'RQ', 'WS', 'SD', 'CH')
                                AND table_name LIKE 'AT%')
      AND table_name LIKE 'AT%'
    ORDER BY 2 ASC, 1 ASC;

CURSOR l_allrqcustom_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          LENGTH(table_name) table_order1
     FROM user_tab_columns
    WHERE column_name = 'RQ'
      AND table_name LIKE 'AT%'
    ORDER BY 2 ASC, 1 ASC;

CURSOR l_allsdcustom_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          LENGTH(table_name) table_order1
     FROM user_tab_columns
    WHERE column_name = 'SD'
      AND table_name LIKE 'AT%'
    ORDER BY 2 ASC, 1 ASC;

CURSOR l_allchcustom_tables_cursor IS
   SELECT DISTINCT LOWER(table_name) table_name,
          LENGTH(table_name) table_order1
     FROM user_tab_columns
    WHERE column_name = 'CH'
      AND table_name LIKE 'AT%'
    ORDER BY 2 ASC, 1 ASC;

CURSOR l_user_tab_columns_cursor(a_table_name VARCHAR2) IS
   SELECT LOWER(column_name) column_name, data_type
     FROM user_tab_columns
    WHERE table_name = DECODE(UPPER(a_table_name),'UTPDAXSLT', 'UTXSLT', UPPER(a_table_name))
    ORDER BY column_id ASC;

FUNCTION GetVersion
RETURN VARCHAR2;

----------------------------------------------------------------------------------------------
-- Public Functions
----------------------------------------------------------------------------------------------
FUNCTION Archive                         /* INTERNAL */
(a_archive_id       IN VARCHAR2,         /* VC20_TYPE */
 a_archive_to       IN VARCHAR2,         /* VC20_TYPE */
 a_archfile         IN VARCHAR2)         /* VC20_TYPE */
RETURN NUMBER;

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

FUNCTION GetArchiveIndex                              /* INTERNAL */
(a_archive_to       IN     VARCHAR2,                  /* VC20_TYPE */
 a_archive_from     IN     VARCHAR2,                  /* VC20_TYPE */
 a_archive_id       OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TAB_TYPE */
 a_object_tp        OUT    UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TAB_TYPE */
 a_object_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TAB_TYPE */
 a_object_version   OUT    UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TAB_TYPE */
 a_object_details   OUT    UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TAB_TYPE */
 a_archived_on      OUT    UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TAB_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2,                  /* VC255_TYPE */
 a_next_rows        IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION AddToToBeArchivedList                        /* INTERNAL */
(a_object_tp        IN     VARCHAR2,                  /* VC40_TYPE */
 a_object_id        IN     VARCHAR2,                  /* VC20_TYPE */
 a_object_version   IN     VARCHAR2,                  /* VC20_TYPE */
 a_object_details   IN     VARCHAR2,                  /* VC255_TYPE */
 a_copy_flag        IN     CHAR,                      /* CHAR1_TYPE */
 a_delete_flag      IN     CHAR,                      /* CHAR1_TYPE */
 a_archive_id       IN     VARCHAR2,                  /* VC20_TYPE */
 a_archive_to       IN     VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;



----------------------------------------------------------------------------------------------
-- Pseudo Private Functions
-- should not be used by client - public since the package had to be splitted into 3 packages.
----------------------------------------------------------------------------------------------
l_exception_step  VARCHAR2(2000);

PROCEDURE UtlFileExceptionHandler   /* INTERNAL */
(a_api_name      IN   VARCHAR2,     /* VC40_TYPE */
 a_sqlerrm       IN   VARCHAR2,     /* VC255_TYPE */
 a_error_type    IN   VARCHAR2,     /* VC40_TYPE */
 a_close_cursor  IN   CHAR);        /* CHAR1_TYPE */

FUNCTION CloseDBLink     /* INTERNAL */
(a_link IN   VARCHAR2)
RETURN NUMBER;

FUNCTION ListAllColumns                   /* INTERNAL */
(a_table_name     IN       VARCHAR2,      /* VC40_TYPE */
 a_brackets       IN       VARCHAR2,      /* VC40_TYPE */
 a_ar_implemented IN       CHAR)          /* CHAR1_TYPE */
RETURN VARCHAR2;

PROCEDURE ParseObjectDetails             /* INTERNAL */
(a_object_details    IN    VARCHAR2,     /* VC255_TYPE */
 a_pp_key1           OUT   VARCHAR2,     /* VC20_TYPE */
 a_pp_key2           OUT   VARCHAR2,     /* VC20_TYPE */
 a_pp_key3           OUT   VARCHAR2,     /* VC20_TYPE */
 a_pp_key4           OUT   VARCHAR2,     /* VC20_TYPE */
 a_pp_key5           OUT   VARCHAR2,     /* VC20_TYPE */
 a_lab               OUT   VARCHAR2);    /* VC20_TYPE */

END unapira;