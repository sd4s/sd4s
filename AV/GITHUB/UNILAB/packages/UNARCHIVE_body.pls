create or replace PACKAGE BODY
unarchive AS

-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $

l_sqlerrm         VARCHAR2(255);
l_sql_string      VARCHAR2(2000);
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

-- Function containing any custom code to execute BEFORE ARCHIVING
FUNCTION PrepareToArchive
(a_archive_id       IN VARCHAR2,         /* VC20_TYPE */
 a_archive_to       IN VARCHAR2,         /* VC40_TYPE */
 a_archfile         IN VARCHAR2)         /* VC20_TYPE */
RETURN NUMBER IS
   l_copy_flag     CHAR(1);
   l_delete_flag   CHAR(1);
   l_archive_id    VARCHAR2(20);

   -- Cursor needed for the example below
   CURSOR l_SelectScToBeArchived_cursor IS
      SELECT a.sc sc
        FROM utsc a
       WHERE sc = 'none'
      MINUS
      SELECT a.object_id sc
        FROM uttoarchive a
       WHERE a.object_tp = 'sc';
BEGIN
-- Example - commented out for safety reasons
--
--   l_archive_id := 'u4ar'||TO_CHAR(CURRENT_TIMESTAMP,'RRMMDD');
--
--   UPDATE uttoarchive
--      SET archive_id = l_archive_id;
--   UNAPIGEN.U4COMMIT;
--
-- Add all samples of a specific product_class raw material (sample goup key) which
-- have been terminated since more than 3 months since customer complaint
-- can only be raised for samples from maximum 3 months.
--
--   FOR l_sc_rec IN l_SelectScToBeArchived_cursor LOOP
--      l_copy_flag   := '1';
--      l_delete_flag := '1';
--
--      l_ret_code := unapira.AddToToBeArchivedList('sc', l_sc_rec.sc, l_copy_flag,
--                                                  l_delete_flag, l_archive_id, 'DB');
--      IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
--         INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
--         VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
--                'PrepareToArchive',
--                'unapira.AddToToBeArchivedList returned '||TO_CHAR(l_ret_code)||
--                   ' for sc '||l_sc_rec.sc);
--      END IF;
--   END LOOP;

   RETURN(UNAPIGEN.DBERR_SUCCESS);
END PrepareToArchive;

-- Function containing any custom code to execute AFTER ARCHIVING
FUNCTION AfterArchive
(a_archive_id       IN VARCHAR2,         /* VC20_TYPE */
 a_archive_to       IN VARCHAR2,         /* VC40_TYPE */
 a_archfile         IN VARCHAR2)         /* VC20_TYPE */
RETURN NUMBER IS
BEGIN
-- Example - commented out for safety reasons
--
-- Example for 'Archive Scenario': the samples/requests that were archived are not yet deleted.
-- We will now reschedule the same samples for deletion in one month
--
--   UPDATE uttoarchive
--      SET handled_ok  = '0',
--          archive_id  = 'DELETE',
--          archive_on  = ADD_MONTHS(CURRENT_TIMESTAMP, 1),  -- delete one month after this archive
--          delete_flag = '1',
--          copy_flag   = '0'
--    WHERE handled_ok = 1
--      AND copy_flag  =  1
--      AND (object_tp = 'sc' OR object_tp ='rq');

   RETURN(UNAPIGEN.DBERR_SUCCESS);
END AfterArchive;

-- Function containing any custom code to execute BEFORE RESTORING
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
RETURN NUMBER IS
BEGIN
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END PrepareToRestore ;

-- Function containing any custom code to execute AFTER RESTORING
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
RETURN NUMBER IS
BEGIN
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END AfterRestore;

END unarchive;