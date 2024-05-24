---------------------------------------------------------------------------
-- $Workfile: PA_LIMS.sql $
--      Type: Package Body
--   $Author: Fe $
--            COMPEX N.V.
----------------------------------------------------------------------------
--  Abstract: Functions and procedures for the interface between Interspec 
--            and Unilab.
--
--            REMARK 1: Do not use 'SELECT *' to select from an Unilab table, 
--            but always specify the column names. If they are not specified,
--            errors can occur when the column order of a table differs on
--            the Unilab databases.
--
--            REMARK 2: Do not directly use an Unilab api in a 'SELECT'- or 
--            'WHERE'-clause of a query in an Interspec package. If the packages
--            have public synonyms, and if the link connects to another Unilab
--            database as before the re-creation, this kind of Unilab api call
--            invalidates the Interspec packages.
--            The only mechanism that does not invalidate the packages, is to
--            create an Unilab view that uses the Unilab api.  
--
--            REMARK 3: Do not select from Unilab tables, but from Unilab views.
--            This is necessary since every user can be used in the 
--            database link.
--
--            REMARK 4: When both databases are unicode (CHARACTER_SET = AL32UTF8, 
--            NLS_LENGTH_SEMANTICS = CHAR), then watch out with selecting data of
--            datatype CHAR through the link. A column of type CHAR(1) at Unilab
--            side, becomes CHAR(4) at Interspec side. You have to SUBSTR
--            explicitely before assigning the value to a local variable.
--            For more info, cfr. Oracle bugs 2928548, and 2749304.
--            E.g. the selects from uvpppr_pr_specx, uvstpp_pp_specx.
----------------------------------------------------------------------------
-- Functions:
-- 1.  p_Trace
-- 2.  p_TraceSt
-- 3.  p_Log
-- 4.  f_SetUpLimsConnection
-- 5.  f_SetUpLimsConnection_h
-- 6.  f_CloseLimsConnection
-- 7.  f_ActivePlant
-- 8.  f_StartRemoteTransaction
-- 9.  f_StartRemoteTransaction_h
-- 10. f_Wait4EndOfEventProcessing
-- 11. f_EndRemoteTransaction
-- 12. f_EndRemoteTransaction_h
-- 13. f_SendTransferFinishedEvents
-- 14. f_GetTemplate
-- 15. f_GetDateFormat
-- 16. f_GetDateFormat_h
-- 17. f_GetSettingValue
-- 18. f_GetPathValue
-- 19. f_GetMtId
-- 20. f_GetPrId
-- 21. f_GetPpId
-- 22. f_GetStAuId
-- 23. f_GetStPpPrAuId
-- 24. f_GetStGkId
-- 25. f_GetHighestRevision
-- 26. f_GetGkId
-- 27. f_RemoveDbLink
-- 28. f_RemoveDbLink_h
-- 29. f_ReleaseLock
-- 30. f_RequestLock
-- 31. f_SetPpKeys
-- 32. f_GetInterspecVersion 
-- 33. f_GetAttachedPartNo
-- 34. f_GetIUIVersion
----------------------------------------------------------------------------
-- Versions:
-- speCX ver  Date         Author          Description
-- ---------  -----------  --------------  ---------------------------------
-- 2.2.0      01/12/2000   CL              New release
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.2.1      22/05/2001   JB              CR: Change the composition of the
--                                         Id of aStandard attribute
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.2.2      10/07/2001   CL              Bug: Only one user may use the
--                                         DB link
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.2.3      10/07/2001   CL              Add a function for debugging (Trace)
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.3.0      15/07/2001   CL              Release 2.3.0
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 2.3.0a     30/07/2001   CL              Add trace information for the composition
--                                         of a sample type
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--            09/12/2002   JB              New functions:
--                                          The new job "f_TransferAllHistObs" (freq = 5 min) works with
--                                          its own database link "LNK_LIMS_H" to avoid
--                                          locks when transfering current specs:
--                                          - f_SetUpLimsConnection_h
--                                          - f_StartRemoteTransaction_h
--                                          - f_EndRemoteTransaction_h
--                                          - f_GetStId_h
--                                          - f_RemoveDbLink_h
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 5.0        20/08/2003   RF              Release 5.0
--                                         Since Unilab 5.0 SP2 can handle versions, 
--                                         effective_dates, and multiple plants, a new design has been
--                                         made ("RFD0309021-DS DB API Interspec-Unilab interface.doc"
--                                         in the Unilab 5.0 SP2 URS folder). Please check this 
--                                         design for more detailed information of the modifications.
----------------------------------------------------------------------------



CREATE OR REPLACE PACKAGE BODY 
----------------------------------------------------------------------------
-- $Revision: 3 $
--  $Modtime: 26/08/14 15:00 $
----------------------------------------------------------------------------
PA_LIMS IS

   -- Constants for api logging:
   -- If you want to have api logging        => LOGGING := TRUE
   -- If you do not want to have api logging => LOGGING := FALSE
   -- If you want api logging in DBMS_OUTPUT      => DEBUG := TRUE
   -- If you want api logging in a database table => DEBUG := FALSE
   c_LOGGING      CONSTANT BOOLEAN       := TRUE;
   c_DEBUG        CONSTANT BOOLEAN       := FALSE;
   -- Constant which contains the ID of the userlock
   c_UserLockId   CONSTANT NUMBER        := 17001;

   -- Global variable contains the id of the language used for object id and for description
   g_lang_id_4id               NUMBER(2);
   g_lang_id_4desc             NUMBER(2);
   -- Global variable contains the name of the active plant
   g_ActivePlant               VARCHAR2(20);
   
   -- Global variable contains the value of the Unilab system setting 'JOBS_DATE_FORMAT'
   g_DateFormat                VARCHAR2(255);
   --flag to avoid infinite loop in f_GetInterspcVersion
   p_inside_getispecversion    CHAR(1) DEFAULT '0';
   --Last transaction on unilab side indexed by connection string
   TYPE last_tr_tab_type IS TABLE OF NUMBER INDEX BY VARCHAR2(40);
   p_u4_last_tr_seq            last_tr_tab_type;

   --settings for waiting on event processing on unilab side between trasnfer and update
   p_wait4ev_polling_interv    NUMBER;
   p_wait4ev_max_retries       NUMBER;
   p_wait4ev_initial_wait      NUMBER;
   p_wait4ev_mult_factor       NUMBER;
      
   --Cache for Interspc_cfg settings
   TYPE IndexedByVarchar2Tab IS TABLE OF VARCHAR2(80) INDEX BY VARCHAR2(30);
   p_InterspcCfgTab            IndexedByVarchar2Tab;
      
   FUNCTION f_GetIUIVersion
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the version of the Interspec-Unilab interface
      -- ** Return **
      -- The version of the Interspec-Unilab interface
      ------------------------------------------------------------------------------
      -- General variables
   BEGIN
      RETURN('06.04.00.00_03.00');
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unable to get the version of the Interspec-Unilab interface : '||SQLERRM);
         RETURN (NULL);
   END f_GetIUIVersion;
   
   FUNCTION f_GetInterspecVersion
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the version of Interspec
      -- ** Return **
      -- The version of Interspec
      ------------------------------------------------------------------------------
      -- General variables
      l_version   interspc_cfg.parameter_data%TYPE;

      CURSOR l_cfg_cursor IS
         SELECT parameter_data
           FROM interspc_cfg
          WHERE parameter = 'version';
   BEGIN
      p_inside_getispecversion := '1';
      FOR l_cfg_rec IN l_cfg_cursor LOOP
         l_version := l_cfg_rec.parameter_data;
      END LOOP;
      p_inside_getispecversion := '0';
      RETURN(l_version);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unable to get the Interspec version : '||SQLERRM);
         p_inside_getispecversion := '0';
         RETURN (NULL);
   END f_GetInterspecVersion;

   FUNCTION f_ReleaseLock
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The function releases the User Lock
      -- ** Return **
      -- True: It was possible to release the user lock
      -- False: It was not possible to release the user lock
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'f_ReleaseLock';

      -- Variable which contains the return value
      l_return_value         INTEGER;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Arguments of DBMS_LOCK.RELEASE:
      --    ID  Lock (semaphore) ID
      l_return_value := DBMS_LOCK.RELEASE(c_UserLockId);
      IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 'Unable to release the user lock: '||TO_CHAR(l_return_value));
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log Message
         PA_LIMS.p_Log(l_classname, l_method, NULL);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_ReleaseLock;

   FUNCTION f_RequestLock
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- The function requests the User Lock
      -- ** Return **
      -- True: It was possible to set the user lock
      -- False: It was not possible to set the user lock
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12)  := 'Lims';
      l_method      CONSTANT VARCHAR2(32)  := 'f_RequestLock';

      -- Variable which contains the return value
      l_return_value         INTEGER;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Arguments of DBMS_LOCK.REQUEST:
      --    ID                Lock (semaphore) ID
      --    LockMode          DBMS_LOCK.X_MODE     = Exclusive Mode
      --    Timeout           DBMS_LOCK.MAXWAIT    = Wait
      --    Release_on_commit FALSE                = Do not release lock on commit or rollback
      l_return_value := DBMS_LOCK.REQUEST(c_UserLockId, DBMS_LOCK.X_MODE, DBMS_LOCK.MAXWAIT, FALSE);
      IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 'Unable to request the user lock: '||TO_CHAR(l_return_value));
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log Message
         PA_LIMS.p_Log(l_classname, l_method, NULL);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_RequestLock;

   FUNCTION f_RemoveDbLink
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Remove the DB link
      -- - Close the database link
      -- - Remove the database link
      -- ** Return **
      -- True: The remove of the DB Link has succeeded.
      -- False: The close of the Db Link has failed.
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'f_RemoveDbLink';

      -- General variables
      l_return_value         INTEGER;
      l_cur_hdl              INTEGER;

      -- Definition of handled exceptions
      LNK_NOT_OPEN           EXCEPTION;
      PRAGMA EXCEPTION_INIT(LNK_NOT_OPEN,  -2081);
      LNK_NOT_EXIST          EXCEPTION;
      PRAGMA EXCEPTION_INIT(LNK_NOT_EXIST,  -2024);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Make sure that the transaction on the LIMS DB is closed
      ROLLBACK;

      -- Close the database link
      BEGIN
         -- Open Cursor
         l_cur_hdl := DBMS_SQL.OPEN_CURSOR;
         -- Parse cursor
         DBMS_SQL.PARSE(l_cur_hdl, 'ALTER SESSION CLOSE DATABASE LINK LNK_LIMS', DBMS_SQL.NATIVE);
         -- Execute cursor
         l_return_value := DBMS_SQL.EXECUTE(l_cur_hdl);
         -- Close the handle
         DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
      EXCEPTION
         WHEN LNK_NOT_OPEN THEN
            -- If the cursor is still open, then the cursor must be closed.
            IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            END IF;
         WHEN OTHERS THEN
            COMMIT;
            BEGIN
               -- Parse cursor
               DBMS_SQL.PARSE(l_cur_hdl, 'ALTER SESSION CLOSE DATABASE LINK LNK_LIMS', DBMS_SQL.NATIVE);
               -- Execute cursor
               l_return_value := DBMS_SQL.EXECUTE(l_cur_hdl);
               -- Close the handle
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            EXCEPTION
               WHEN OTHERS THEN
                  -- If the cursor is still open, then the cursor must be closed.
                  IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
                     DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
                  END IF;
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(c_Source, c_Applic, 'Unable to close the database link "LNK_LIMS": '||SQLERRM);
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
            END;
      END;

      -- Drop the database link
      BEGIN
         -- Open Cursor
         l_cur_hdl := DBMS_SQL.OPEN_CURSOR;
         -- Parse cursor
         DBMS_SQL.PARSE(l_cur_hdl, 'DROP DATABASE LINK LNK_LIMS', DBMS_SQL.NATIVE);
         -- Execute cursor
         l_return_value := DBMS_SQL.EXECUTE(l_cur_hdl);
         -- Close the handle
         DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
      EXCEPTION
         WHEN LNK_NOT_EXIST THEN
            -- If the cursor is still open, then the cursor must be closed.
            IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            END IF;
         WHEN OTHERS THEN
            -- If the cursor is still open, then the cursor must be closed.
            IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            END IF;
            -- Log an error to ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic, 'Unable to remove the database link "LNK_LIMS": '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 'Unexpected error when removing the database link "LNK_LIMS": '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_RemoveDbLink;

   FUNCTION f_RemoveDbLink_h
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Remove the DB link
      -- - Close the database link
      -- - Remove the database link
      -- ** Return **
      -- True: The remove of the DB Link has succeeded.
      -- False: The close of the Db Link has failed.
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'f_RemoveDbLink_h';

      -- General variables
      l_return_value         INTEGER;
      l_cur_hdl              INTEGER;
      
      -- Definition of handled exceptions
      LNK_NOT_OPEN           EXCEPTION;
      PRAGMA EXCEPTION_INIT(LNK_NOT_OPEN,  -2081);
      LNK_NOT_EXIST          EXCEPTION;
      PRAGMA EXCEPTION_INIT(LNK_NOT_EXIST,  -2024);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);
      -- Make sure that the transaction on the LIMS DB is closed
      ROLLBACK;

      -- Close the database link
      BEGIN
         -- Open Cursor
         l_cur_hdl := DBMS_SQL.OPEN_CURSOR;
         -- Parse cursor
         DBMS_SQL.PARSE(l_cur_hdl, 'ALTER SESSION CLOSE DATABASE LINK LNK_LIMS_H', DBMS_SQL.NATIVE);
         -- Execute cursor
         l_return_value := DBMS_SQL.EXECUTE(l_cur_hdl);
         -- Close the handle
         DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
      EXCEPTION
         WHEN LNK_NOT_OPEN THEN
            -- If the cursor is still open, then the cursor must be closed.
            IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            END IF;
         WHEN OTHERS THEN
            COMMIT;
            BEGIN
               -- Parse cursor
               DBMS_SQL.PARSE(l_cur_hdl, 'ALTER SESSION CLOSE DATABASE LINK LNK_LIMS_H', DBMS_SQL.NATIVE);
               -- Execute cursor
               l_return_value := DBMS_SQL.EXECUTE(l_cur_hdl);
               -- Close the handle
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            EXCEPTION
               WHEN OTHERS THEN
                  -- If the cursor is still open, then the cursor must be closed.
                  IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
                     DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
                  END IF;
                  -- Log an error to ITERROR
                  PA_LIMS.p_Log(c_Source, c_Applic, 'Unable to close the database link "LNK_LIMS_H": '||SQLERRM);
                  -- Tracing
                  PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
                  RETURN (FALSE);
            END;
      END;

      -- Drop the database link
      BEGIN
         -- Open Cursor
         l_cur_hdl := DBMS_SQL.OPEN_CURSOR;
         -- Parse cursor
         DBMS_SQL.PARSE(l_cur_hdl, 'DROP DATABASE LINK LNK_LIMS_H', DBMS_SQL.NATIVE);
         -- Execute cursor
         l_return_value := DBMS_SQL.EXECUTE(l_cur_hdl);
         -- Close the handle
         DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
      EXCEPTION
         WHEN LNK_NOT_EXIST THEN
            -- If the cursor is still open, then the cursor must be closed.
            IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            END IF;
         WHEN OTHERS THEN
            -- If the cursor is still open, then the cursor must be closed.
            IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            END IF;

            -- Log an error to ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic, 'Unable to remove the database link "LNK_LIMS_H": '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 'Unexpected error when removing the database link "LNK_LIMS_H": '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_RemoveDbLink_h;
   
   FUNCTION f_SetUpLimsConnection(
      a_plant    IN plant.plant%TYPE
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Set up the LIMS connection for a specific plant:
      -- - Set the user lock
      -- - Create the DB link
      -- - Initialize the DB-API on the LIMS database
      -- - Disable the API signature based on the Timestamp
      -- ** Parameters **
      -- a_Plant: The ID of the plant for which the LIMS connection must be set up
      -- ** Return **
      -- True: The set up of the LIMS connection has succeeded.
      -- False: The set up of the LIMS connection has failed.
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12)                      := 'Lims';
      l_method      CONSTANT VARCHAR2(32)                      := 'f_SetUpLimsConnection';
      
      -- General variables
      l_return_value            INTEGER;
      l_connection_string       itlimsplant.connect_string%TYPE;
      l_cur_hdl                 INTEGER;      -- to create and test the connection
      l_sql_string              VARCHAR2(255);
      l_setcon_username         VARCHAR2(30);
      l_customsetcon_parameter  VARCHAR2(255);
      l_cust_ret_code           INTEGER;
      l_count_corrupt_entries   INTEGER;

      -- Specific local variables for the 'SetConnection' API
      l_client_id            VARCHAR2(20);
      l_password             VARCHAR2(20);
      l_applic               VARCHAR2(8);
      l_numeric_characters   VARCHAR2(2);
      l_date_format          VARCHAR2(255);
      l_timezone             VARCHAR2(20);
      l_up                   NUMBER;
      l_user_profile         VARCHAR2(40);
      l_language             VARCHAR2(20);
      l_tk                   VARCHAR2(20);

      -- Cursor to get the connection string
      CURSOR l_get_connection_string_cursor(c_plant plant.plant%TYPE)
      IS
         SELECT connect_string
           FROM itlimsplant
          WHERE plant = c_plant;

      -- Cursor to check if the database link is valid
      CURSOR l_check_connection_cursor
      IS
         SELECT SYSDATE
           FROM DUAL@LNK_LIMS;

      -- Cursor to get the configuration setting
      CURSOR l_get_conf_setting_cursor(c_setting interspc_cfg.parameter%TYPE)
      IS
         SELECT parameter_data
           FROM interspc_cfg
          WHERE section = 'U4 INTERFACE'
            AND parameter = c_setting;
                      
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_plant, NULL, NULL, PA_LIMS.c_Msg_Started);
      
      --the following check is necessary since a constraints (parent-child and NOT NULL) could not be added to 
      --the table itlimsplant since this version of the interface must work with old versions of the client
      --where ony one column can be filled in with the interspc client
      SELECT COUNT('X')
      INTO l_count_corrupt_entries
      FROM itlimsplant 
      WHERE lang_id_4id IS NULL;
      
      IF l_count_corrupt_entries > 0 THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 'Transfer not started. Correct your configuration, the column lang_id_4id is empty for some records in the table itlimsplant.');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Disable the API signature based on tiLimstamp because the same session is calling the same
      -- API on different servers
      BEGIN
         -- Open Cursor
         l_cur_hdl := SYS.DBMS_SQL.OPEN_CURSOR;
         -- Parse SQL
         DBMS_SQL.PARSE(l_cur_hdl, 'ALTER SESSION SET REMOTE_DEPENDENCIES_MODE=SIGNATURE', SYS.DBMS_SQL.NATIVE);
         -- Execute cursor
         l_return_value := SYS.DBMS_SQL.EXECUTE(l_cur_hdl);
         -- Close the handle
         SYS.DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
      EXCEPTION
         WHEN OTHERS THEN
            -- If the cursor is still open, then the cursor must be closed.
            IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            END IF;
            -- Log an error to ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic, 
                          'Unable to disable the API signature based on tiLimstamp for "'||a_plant||'": '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      -- Get the connection string of the plant
      FOR l_get_connection_string_rec IN l_get_connection_string_cursor(a_plant) LOOP
         l_connection_string := l_get_connection_string_rec.connect_string;
      END LOOP;

      -- Check if the connection string for the plant is configured
      IF l_connection_string IS NULL THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 'Unable to get the connect string for the plant "'||a_plant||'".');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Close the previous database connection to make sure that there is no connection
      IF NOT PA_LIMS.f_RemoveDbLink THEN
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Request the user lock. The database link can only be used for one session
      IF NOT PA_LIMS.f_RequestLock THEN
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      IF NOT PA_LIMSDBLink.f_CreateDatabaseLink('LNK_LIMS', l_connection_string, l_setcon_username, l_sql_string) THEN
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;
      g_LNK_LIMS_connect_string := l_connection_string;
      
      -- Create the database link
      BEGIN
         -- Open Cursor
         l_cur_hdl := DBMS_SQL.OPEN_CURSOR;
         -- Parse SQL
         DBMS_SQL.PARSE(l_cur_hdl,
                        l_sql_string, 
                        DBMS_SQL.NATIVE);
         -- Execute cursor
         l_return_value := DBMS_SQL.EXECUTE(l_cur_hdl);
         -- Close the handle
         DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
      EXCEPTION
         WHEN OTHERS THEN
            -- If the cursor is still open, then the cursor must be closed.
            IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            END IF;
            -- Log an error to ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic,
                          'Unable to create the database link "LNK_LIMS" for the plant "'||a_plant||
                          '" with connect string "'||l_connection_string||'" : '||SQLERRM);
            PA_LIMS.p_Log(c_Source, c_Applic,
                          'Used CREATE statement was:');
            PA_LIMS.p_Log(c_Source, c_Applic,
                          l_sql_string);
            -- Release the user lock because it is not possible to SetupLimsConnection
            IF NOT PA_LIMS.f_ReleaseLock THEN
               NULL;
            END IF;
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      -- Test the DB link
      BEGIN
         FOR l_check_connection_rec IN l_check_connection_cursor LOOP
            NULL;
         END LOOP;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic,
                          'Unable to query the remote database of the plant "'||a_plant||'" : '||SQLERRM);
            -- Release the user lock because it is not possible to SetupLimsConnection
            IF NOT PA_LIMS.f_ReleaseLock THEN
               NULL;
            END IF;
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      OPEN l_get_conf_setting_cursor('CUSTOMSETCONNECTION');
      FETCH l_get_conf_setting_cursor
      INTO l_customsetcon_parameter;
      CLOSE l_get_conf_setting_cursor;

      -- Set up the connection with lims
      BEGIN
         -- Fill the In parameters of the API call
         --This concatenation may be suppressed when support of 6.1 is finished
         l_client_id := SUBSTR(USERENV('TERMINAL')||l_customsetcon_parameter,1,30);
         l_password := NULL;
         l_applic := 'Interspc';  
         l_numeric_characters := 'DB';
         l_timezone := 'SERVER';
         l_date_format := f_GetDateFormat;
         --timezone could not be used for backward compatibility reason
         l_return_value := UNAPIGEN.SETCONNECTION@LNK_LIMS(a_client_id =>l_client_id,
                                                            a_us => l_setcon_username, 
                                                            a_password => l_password, 
                                                            a_applic => l_applic,
                                                            a_numeric_characters => l_numeric_characters,
                                                            a_date_format => l_date_format,
                                                            a_up => l_up,
                                                            a_user_profile => l_user_profile,
                                                            a_language => l_language,
                                                            a_tk => l_tk);
         -- Check if the set up of the connection succeeded
         IF l_return_value <> DBERR_SUCCESS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic,
                          'Unable to initialize the DB API for the plant "'||a_plant||'" SetConnection@LNK_LIMS returned: '||TO_CHAR(l_return_value));
            -- Release the user lock because it is not possible to SetupLimsConnection
            IF NOT PA_LIMS.f_ReleaseLock THEN
               NULL;
            END IF;
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic,
                          'Unable to initialize the DB API for the plant "'||a_plant||'" : '||SQLERRM);
            -- Release the user lock because it is not possible to SetupLimsConnection
            IF NOT PA_LIMS.f_ReleaseLock THEN
               NULL;
            END IF;
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;
      
      --Set the same date format on the 2 sides of the database link in order to avoid problems
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = '''||REPLACE(l_date_format,'''', '''''')||'''';

      --Set the timestamp format on the 2 sides of the database link in order to avoid problems
      --There are problems when not the same in fact
      EXECUTE IMMEDIATE 'ALTER SESSION SET  NLS_TIMESTAMP_TZ_FORMAT = '''||REPLACE(l_date_format,'''', '''''')||'''';
      EXECUTE IMMEDIATE 'ALTER SESSION SET  NLS_TIMESTAMP_FORMAT = '''||REPLACE(l_date_format,'''', '''''')||'''';
      
      -- Set custom connection with lims
      l_cust_ret_code:= PA_SPECXINTERFACE.SetCustomConnectionParameter@LNK_LIMS(l_customsetcon_parameter);
      --Return code is not checked

      -- Get the id of the language used for object id
      BEGIN
         FOR i IN 1..PA_LIMSSPC.g_nr_of_plants LOOP
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(a_Plant,PA_LIMSSPC.g_plant_tab(i)) = 1 THEN
               g_lang_id_4id := PA_LIMSSPC.g_lang_id_4id_tab(i);
               g_lang_id_4desc := PA_LIMSSPC.g_lang_id_tab(i);
               EXIT;
            END IF;
         END LOOP;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 'Language for Unilab object id is not defined !');
         -- Release the user lock because it is not possible to SetupLimsConnection
         IF NOT PA_LIMS.f_ReleaseLock THEN
            NULL;
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END;

      -- Save the active plant
      g_ActivePlant := a_Plant;

      g_tr_historic_prop := '0';
      OPEN l_get_conf_setting_cursor('Transfer Hist Prop');
      FETCH l_get_conf_setting_cursor
      INTO g_tr_historic_prop;
      CLOSE l_get_conf_setting_cursor;
      g_effective_from_date4historic := TO_DATE('01/01/2099 12:00:00', 'DD/MM/YYYY HH24:MI:SS');
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'g_tr_historic_prop set to ' ||g_tr_historic_prop);

      g_use_template_details := '1';
      OPEN l_get_conf_setting_cursor('Use All Temp Details');
      FETCH l_get_conf_setting_cursor
      INTO g_use_template_details;
      CLOSE l_get_conf_setting_cursor;
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'g_use_template_details set to ' ||g_use_template_details);

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 
                       'Unexpected error when setting up the lims connection for the plant "'||a_plant||
                       '" : '||SQLERRM);
         -- Release the user lock because it is not possible to SetupLimsConnection
         IF NOT PA_LIMS.f_ReleaseLock THEN
            NULL;
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_SetUpLimsConnection;

   FUNCTION f_SetUpLimsConnection_h(
      a_plant    IN plant.plant%TYPE
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Set up the LIMS connection for a specific plant:
      -- - Set the user lock
      -- - Create the DB link
      -- - Initialize the DB-API on the LIMS database
      -- - Disable the API signature based on the Timestamp
      -- ** Parameters **
      -- a_Plant: The ID of the plant for which the LIMS connection must be set up
      -- ** Return **
      -- True: The set up of the LIMS connection has succeeded.
      -- False: The set up of the LIMS connection has failed.
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12)                      := 'Lims';
      l_method      CONSTANT VARCHAR2(32)                      := 'f_SetUpLimsConnection_h';

      -- General variables
      l_return_value           INTEGER;
      l_connection_string      itlimsplant.connect_string%TYPE;
      l_cur_hdl                INTEGER;      -- to create and test the connection
      l_sql_string             VARCHAR2(255);
      l_setcon_username        VARCHAR2(30);
      l_customsetcon_parameter VARCHAR2(255);
      l_cust_ret_code          INTEGER;
      l_count_corrupt_entries  INTEGER;

      -- Specific local variables for the 'SetConnection' API
      l_client_id              VARCHAR2(20);
      l_password               VARCHAR2(20);
      l_applic                 VARCHAR2(8);
      l_numeric_characters     VARCHAR2(2);
      l_date_format            VARCHAR2(255);
      l_timezone               VARCHAR2(20);
      l_up                     NUMBER;
      l_user_profile           VARCHAR2(40);
      l_language               VARCHAR2(20);
      l_tk                     VARCHAR2(20);

      -- Cursor to get the connection string
      CURSOR l_get_connection_string_cursor(c_plant plant.plant%TYPE)
      IS
         SELECT connect_string
           FROM itlimsplant
          WHERE plant = c_plant;

      -- Cursor to check if the database link is valid
      CURSOR l_check_connection_cursor
      IS
         SELECT SYSDATE
           FROM DUAL@LNK_LIMS_H;

      -- Cursor to get the configuration setting
      CURSOR l_get_conf_setting_cursor(c_setting interspc_cfg.parameter%TYPE)
      IS
         SELECT parameter_data
           FROM interspc_cfg
          WHERE section = 'U4 INTERFACE'
            AND parameter = c_setting;
           
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_plant, NULL, NULL, PA_LIMS.c_Msg_Started);

      --the following check is necessary since a constraints (parent-child and NOT NULL) could not be added to 
      --the table itlimsplant since this version of the interface must work with old versions of the client
      --where ony one column can be filled in with the interspc client
      SELECT COUNT('X')
      INTO l_count_corrupt_entries
      FROM itlimsplant 
      WHERE lang_id_4id IS NULL;
      
      IF l_count_corrupt_entries > 0 THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 'Transfer not started. Correct your configuration, the column lang_id_4id is empty for some records in the table itlimsplant.');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Disable the API signature based on tiLimstamp because the same session is calling the same
      -- API on different servers
      BEGIN
         -- Open Cursor
         l_cur_hdl := SYS.DBMS_SQL.OPEN_CURSOR;
         -- Parse SQL
         DBMS_SQL.PARSE(l_cur_hdl, 'ALTER SESSION SET REMOTE_DEPENDENCIES_MODE=SIGNATURE', SYS.DBMS_SQL.NATIVE);
         -- Execute cursor
         l_return_value := SYS.DBMS_SQL.EXECUTE(l_cur_hdl);
         -- Close the handle
         SYS.DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
      EXCEPTION
         WHEN OTHERS THEN
            -- If the cursor is still open, then the cursor must be closed.
            IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            END IF;
            -- Log an error to ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic,
                          'Unable to disable the API signature based on tiLimstamp for "'||a_plant||'": '||SQLERRM);
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      -- Get the connection string of the plant
      FOR l_get_connection_string_rec IN l_get_connection_string_cursor(a_plant) LOOP
         l_connection_string := l_get_connection_string_rec.connect_string;
      END LOOP;

      -- Check if the connection string for the plant is configured
      IF l_connection_string IS NULL THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 'Unable to get the connect string for the plant "'||a_plant||'".');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);

         RETURN (FALSE);
      END IF;

      -- Close the previous database connection to make sure that there is no connection
      IF NOT PA_LIMS.f_RemoveDbLink_h THEN
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Request the user lock. The database link can only be used for one session
      IF NOT PA_LIMS.f_RequestLock THEN
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      IF NOT PA_LIMSDBLink.f_CreateDatabaseLink('LNK_LIMS_H', l_connection_string, l_setcon_username, l_sql_string) THEN
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Create the database link
      BEGIN
         -- Open Cursor
         l_cur_hdl := DBMS_SQL.OPEN_CURSOR;
         -- Parse SQL
         DBMS_SQL.PARSE(l_cur_hdl,
                        l_sql_string, 
                        DBMS_SQL.NATIVE);
         -- Execute cursor
         l_return_value := DBMS_SQL.EXECUTE(l_cur_hdl);
         -- Close the handle
         DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
      EXCEPTION
         WHEN OTHERS THEN
            -- If the cursor is still open, then the cursor must be closed.
            IF DBMS_SQL.IS_OPEN(l_cur_hdl) THEN
               DBMS_SQL.CLOSE_CURSOR(l_cur_hdl);
            END IF;
            -- Log an error to ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic,
                          'Unable to create the database link "LNK_LIMS_H" for the plant "'||a_plant||
                          '" with connect string "'||l_connection_string||'" : '||SQLERRM);
            PA_LIMS.p_Log(c_Source, c_Applic,
                          'Used CREATE statement was:');
            PA_LIMS.p_Log(c_Source, c_Applic,
                          l_sql_string);
            -- Release the user lock because it is not possible to SetupLimsConnection
            IF NOT PA_LIMS.f_ReleaseLock THEN
               NULL;
            END IF;
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      -- Test the DB link
      BEGIN
         FOR l_check_connection_rec IN l_check_connection_cursor LOOP
            NULL;
         END LOOP;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic,
                          'Unable to query the remote database of the plant "'||a_plant||'" : '||SQLERRM);
            -- Release the user lock because it is not possible to SetupLimsConnection
            IF NOT PA_LIMS.f_ReleaseLock THEN
               NULL;
            END IF;
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;
      
      OPEN l_get_conf_setting_cursor('CUSTOMSETCONNECTION');
      FETCH l_get_conf_setting_cursor
      INTO l_customsetcon_parameter;
      CLOSE l_get_conf_setting_cursor;

      -- Set up the connection with lims
      BEGIN
         -- Fill the In parameters of the API call
         --This concatenation may be suppressed when support of 6.1 is finished
         l_client_id := SUBSTR(USERENV('TERMINAL')||l_customsetcon_parameter,1,30);
         l_password := NULL;
         l_applic := 'Interspc';
         l_numeric_characters := 'DB';
         l_timezone := 'SERVER';
         l_date_format := f_GetDateFormat_h;
         --timezone could not be used for backward compatibility reason
         l_return_value := UNAPIGEN.SETCONNECTION@LNK_LIMS_H(a_client_id =>l_client_id,
                                                             a_us => l_setcon_username, 
                                                             a_password => l_password, 
                                                             a_applic => l_applic,
                                                             a_numeric_characters => l_numeric_characters,
                                                             a_date_format => l_date_format,
                                                             a_up => l_up,
                                                             a_user_profile => l_user_profile,
                                                             a_language => l_language,
                                                             a_tk => l_tk);
         -- Check if the set up of the connection succeeded
         IF l_return_value <> DBERR_SUCCESS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic,
                          'Unable to initialize the DB API for the plant "'||a_plant||'" : '||TO_CHAR(l_return_value));
            -- Release the user lock because it is not possible to SetupLimsConnection
            IF NOT PA_LIMS.f_ReleaseLock THEN
               NULL;
            END IF;
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(c_Source, c_Applic,
                          'Unable to initialize the DB API for the plant "'||a_plant||'" : '||SQLERRM);
            -- Release the user lock because it is not possible to SetupLimsConnection
            IF NOT PA_LIMS.f_ReleaseLock THEN
               NULL;
            END IF;
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
      END;

      --Set the same date format on the 2 sides of the database link in order to avoid problems
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = '''||REPLACE(l_date_format,'''', '''''')||'''';

      --Set the timestamp format on the 2 sides of the database link in order to avoid problems
      --There are problems when not the same in fact
      EXECUTE IMMEDIATE 'ALTER SESSION SET  NLS_TIMESTAMP_TZ_FORMAT = '''||REPLACE(l_date_format,'''', '''''')||'''';
      EXECUTE IMMEDIATE 'ALTER SESSION SET  NLS_TIMESTAMP_FORMAT = '''||REPLACE(l_date_format,'''', '''''')||'''';

      -- Set custom connection with lims
      l_cust_ret_code:= PA_SPECXINTERFACE.SetCustomConnectionParameter@LNK_LIMS_H(l_customsetcon_parameter);
      --Return code is not checked

      -- Get the id of the language used for object id
      BEGIN
         FOR i IN 1..PA_LIMSSPC.g_nr_of_plants LOOP
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(a_Plant,PA_LIMSSPC.g_plant_tab(i)) = 1 THEN
               g_lang_id_4id := PA_LIMSSPC.g_lang_id_4id_tab(i);
               g_lang_id_4desc := PA_LIMSSPC.g_lang_id_tab(i);
               EXIT;
            END IF;
         END LOOP;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 'Language for Unilab object id is not defined !');
         -- Release the user lock because it is not possible to SetupLimsConnection
         IF NOT PA_LIMS.f_ReleaseLock THEN
            NULL;
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END;

      -- Save the active plant
      g_ActivePlant := a_Plant;

      g_tr_historic_prop := '0';
      OPEN l_get_conf_setting_cursor('Transfer Hist Prop');
      FETCH l_get_conf_setting_cursor
      INTO g_tr_historic_prop;
      CLOSE l_get_conf_setting_cursor;
      g_effective_from_date4historic := TO_DATE('01/01/2099 12:00:00', 'DD/MM/YYYY HH24:MI:SS');
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'g_tr_historic_prop set to ' ||g_tr_historic_prop);

      g_use_template_details := '1';
      OPEN l_get_conf_setting_cursor('Use All Temp Details');
      FETCH l_get_conf_setting_cursor
      INTO g_use_template_details;
      CLOSE l_get_conf_setting_cursor;
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'g_use_template_details set to ' ||g_use_template_details);

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic,
                       'Unexpected error when setting up the lims connection for the plant "'||a_plant||
                       '" : '||SQLERRM);
         -- Release the user lock because it is not possible to SetupLimsConnection
         IF NOT PA_LIMS.f_ReleaseLock THEN
            NULL;
         END IF;
         IF l_get_conf_setting_cursor%ISOPEN THEN
            CLOSE l_get_conf_setting_cursor;
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_SetUpLimsConnection_h;

   FUNCTION f_CloseLimsConnection
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Close the Lims Connection
      -- - Reset the user lock
      -- ** Return **
      -- True: The close of the Lims Connection has succeeded.
      -- False: The close of the Lims Connection has failed.
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'f_CloseLimsConnection';
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);

      -- Release the Lock
      IF NOT PA_LIMS.f_ReleaseLock THEN
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(c_Source, c_Applic, 'Unexpected error when closing the Lims connection : '||SQLERRM);
         IF NOT f_ReleaseLock THEN
            NULL;
         END IF;
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_CloseLimsConnection;

   FUNCTION f_GetDateFormat
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the date format for the interface
      -- ** Return **
      -- The date format for the Interface
      ------------------------------------------------------------------------------
      -- General variables
      l_DateFormat   VARCHAR2(255) DEFAULT 'DDfx/fxMM/RR HH24fx:fxMI:SS';

      -- Cursor to get the name of the plant
      CURSOR l_get_DateFormat_cursor
      IS
         SELECT setting_value
           FROM UVSYSTEM@LNK_LIMS
          WHERE setting_name = 'JOBS_DATE_FORMAT';
   BEGIN
      IF g_DateFormat IS NULL THEN
         -- Get the date format for jobs in the unilab DB
         FOR l_get_DateFormat_rec IN l_get_DateFormat_cursor LOOP
            l_DateFormat := l_get_DateFormat_rec.setting_value;
         END LOOP;

         g_DateFormat := l_DateFormat;
      END IF;

      RETURN (g_DateFormat);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to get the date format for the interface : '||SQLERRM);
         RETURN (NULL);
   END f_GetDateFormat;

   FUNCTION f_GetDateFormat_h
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the date format for the interface
      -- ** Return **
      -- The date format for the Interface
      ------------------------------------------------------------------------------
      -- General variables
      l_DateFormat   VARCHAR2(255) DEFAULT 'DDfx/fxMM/RR HH24fx:fxMI:SS';

      -- Cursor to get the name of the plant
      CURSOR l_get_DateFormat_cursor
      IS
         SELECT setting_value
           FROM UVSYSTEM@LNK_LIMS_H
          WHERE setting_name = 'JOBS_DATE_FORMAT';
   BEGIN
      IF g_DateFormat IS NULL THEN
         -- Get the date format for jobs in the unilab DB
         FOR l_get_DateFormat_rec IN l_get_DateFormat_cursor LOOP
            l_DateFormat := l_get_DateFormat_rec.setting_value;
         END LOOP;

         g_DateFormat := l_DateFormat;
      END IF;

      RETURN (g_DateFormat);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         Pa_Lims.p_Log(Pa_Lims.c_Source, Pa_Lims.c_Applic, 
                       'Unable to get the date format for the interface : '||SQLERRM);
         RETURN (NULL);
   END f_GetDateFormat_h;

   FUNCTION f_ActivePlant
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the name of the plant for which the database link is active
      -- ** Return **
      -- The name of the plant
      ------------------------------------------------------------------------------
   BEGIN
      RETURN (g_ActivePlant);
   END f_ActivePlant;

   FUNCTION f_StartRemoteTransaction
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Start the remote transaction on the LIMS db
      -- ** Return **
      -- TRUE  : The start of the remote transaction succeeded
      -- FALSE : The start of the remote transaction failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'f_StartRemoteTransaction';

      -- General variables
      l_return_value         INTEGER;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);
      
      -- Begin the remote transaction
      l_return_value := UNRPCAPI.BEGINTRANSACTION@LNK_LIMS;
      -- Check if the begin of the transaction suceeded
      IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to begin the transaction. (Error Code: '||l_return_value||')');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to begin the transaction: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_StartRemoteTransaction;

   FUNCTION f_StartRemoteTransaction_h
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Start the remote transaction on the LIMS db
      -- ** Return **
      -- TRUE  : The start of the remote transaction succeeded
      -- FALSE : The start of the remote transaction failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'f_StartRemoteTransaction_h';

      -- General variables
      l_return_value         INTEGER;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);
      
      -- Begin the remote transaction
      l_return_value := UNRPCAPI.BEGINTRANSACTION@LNK_LIMS_H;
      -- Check if the begin of the transaction suceeded
      IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to begin the transaction. (Error Code: '||l_return_value||')');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      END IF;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to begin the transaction: '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_StartRemoteTransaction_h;

   FUNCTION f_Wait4EndOfEventProcessing
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- End the remote transaction on the LIMS db
      -- ** Return **
      -- TRUE  : The end of the remote transaction succeeded
      -- FALSE : The end of the remote transaction failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'f_Wait4EndOfEventProcessing';

      -- General variables
      l_return_value         INTEGER;
      l_retries              INTEGER;
      l_count_ev             INTEGER;
      l_wait_interval        NUMBER;
      l_u4_last_tr_seq       NUMBER;
      
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);

      --get time-out settings when not yet fetched and number of retries
      IF p_wait4ev_polling_interv IS NULL THEN
         --load system setting for the polling
         BEGIN
            SELECT parameter_data
            INTO p_wait4ev_polling_interv
            FROM interspc_cfg
            WHERE section = 'U4 INTERFACE'
              AND parameter = 'WAIT4EV_POLLING_INTERV';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            p_wait4ev_polling_interv := 10; --10 seconds
         END;
         BEGIN
            SELECT parameter_data
            INTO p_wait4ev_max_retries
            FROM interspc_cfg
            WHERE section = 'U4 INTERFACE'
              AND parameter = 'WAIT4EV_MAX_RETRIES';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            p_wait4ev_max_retries := 60; --60 times
         END;
         
         IF NVL(p_wait4ev_max_retries, 0) = 0 THEN
            p_wait4ev_initial_wait := 0;
            p_wait4ev_mult_factor := 0;
         ELSE
            p_wait4ev_initial_wait := p_wait4ev_polling_interv/4;
            p_wait4ev_mult_factor := (p_wait4ev_polling_interv-(p_wait4ev_polling_interv/4))/p_wait4ev_max_retries;
            --the timeout will start with 1/4 of the configured wait time
            --and will increase ti reach the configured timeout at the end
            --timeout = a+ b*retry_number  (a=p_wait4ev_initial_wait and b=p_wait4ev_mult_factor) 
         END IF;
      END IF;
      
      --scan uvev to see if events have been processed for last tranaction
      IF g_LNK_LIMS_connect_string IS NULL THEN
         l_u4_last_tr_seq := NULL;
      ELSE
         BEGIN
            l_u4_last_tr_seq := p_u4_last_tr_seq(g_LNK_LIMS_connect_string);
         EXCEPTION
         WHEN NO_DATA_FOUND THEN --this execption must be catched since we are not sure it has been assigned
            l_u4_last_tr_seq := NULL;
         END;
      END IF;
         
      IF l_u4_last_tr_seq IS NOT NULL THEN
         l_retries := 0;
         LOOP
            SELECT count('x')
            INTO l_count_ev
            FROM uvev@LNK_LIMS
            WHERE tr_seq = l_u4_last_tr_seq;
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 
                         '#events='||l_count_ev||'#tr_seq='||l_u4_last_tr_seq);
            EXIT WHEN l_count_ev=0;
            EXIT WHEN l_retries >= p_wait4ev_max_retries;
            l_wait_interval := p_wait4ev_initial_wait+(p_wait4ev_mult_factor*l_retries);
            DBMS_LOCK.SLEEP(l_wait_interval);
            l_retries := l_retries+1;
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 
                         'retries='||l_retries||' - waiting '||l_wait_interval||' second(s)');
         END LOOP;
      END IF;
         
      -- Just add a warning n iterror but return true
      IF l_count_ev <> 0 THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Timeout reached while waiting for Unilab to process the events for transaction:'||l_u4_last_tr_seq);
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 
                         'Timeout reached while waiting for Unilab to process the events for transaction:'||l_u4_last_tr_seq);
      END IF;
      -- to be sure we don't wait more than 1 time for the same transaction
      --we reset the last txn id kept
      BEGIN
         IF g_LNK_LIMS_connect_string IS NULL THEN
            p_u4_last_tr_seq(g_LNK_LIMS_connect_string) := NULL; 
         END IF;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
      END;
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to end the transaction :  '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_Wait4EndOfEventProcessing;

   FUNCTION f_EndRemoteTransaction
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- End the remote transaction on the LIMS db
      -- ** Return **
      -- TRUE  : The end of the remote transaction succeeded
      -- FALSE : The end of the remote transaction failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'f_EndRemoteTransaction';

      -- General variables
      l_return_value         INTEGER;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);

      --get last transaction id
      --the last txn must be kept by connection string
      IF g_LNK_LIMS_connect_string IS NOT NULL THEN
         l_return_value := UNAPIGEN.GetTxnId@LNK_LIMS(p_u4_last_tr_seq(g_LNK_LIMS_connect_string));
      END IF;
      
      -- End the transaction
      l_return_value := UNRPCAPI.ENDTRANSACTION@LNK_LIMS;
      -- Check if the end of the transaction suceeded
      IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to end the transaction. (Error Code: '||l_return_value||')');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
         RETURN (TRUE);
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to end the transaction :  '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_EndRemoteTransaction;

   FUNCTION f_EndRemoteTransaction_h
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- End the remote transaction on the LIMS db
      -- ** Return **
      -- TRUE  : The end of the remote transaction succeeded
      -- FALSE : The end of the remote transaction failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'f_EndRemoteTransaction_h';

      -- General variables
      l_return_value         INTEGER;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);
      
      -- End the transaction
      l_return_value := UNRPCAPI.ENDTRANSACTION@LNK_LIMS_H;
      -- Check if the end of the transaction suceeded
      IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to end the transaction. (Error Code: '||l_return_value||')');
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
      ELSE
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
         RETURN (TRUE);
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to end the transaction :  '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_EndRemoteTransaction_h;

   FUNCTION f_SendTransferFinishedEvents
      RETURN BOOLEAN 
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- End the remote transaction on the LIMS db
      -- ** Return **
      -- TRUE  : The end of the remote transaction succeeded
      -- FALSE : The end of the remote transaction failed
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'f_SendTransferFinishedEvents';

      -- General variables
      l_return_value         INTEGER;
      l_return_value_temp    BOOLEAN;
      l_return_value_final   BOOLEAN;
                  
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Started);
      
      -- Insert the buffered events if some present in buffer
      IF PA_LIMS.g_evbuff_nr_of_rows > 0 THEN
      
         --first wait for the other events to be processed --return code is ignored
         l_return_value_temp := PA_LIMS.f_Wait4EndOfEventProcessing;
         IF l_return_value_temp <> TRUE THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'f_Wait4EndOfEventProcessing failed in f_SendTransferFinishedEvents but we will continue the transfer');
         END IF;

         l_return_value_final := TRUE;
         -- Start the remote transaction
         IF NOT PA_LIMS.f_StartRemoteTransaction THEN
           -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            RETURN (FALSE);
         END IF;
      
         l_return_value := PA_SPECXINTERFACE.f_InsertBufferedEvents@LNK_LIMS(PA_LIMS.g_evbufftab_object_tp, PA_LIMS.g_evbufftab_object_id, PA_LIMS.g_evbufftab_ev_details, PA_LIMS.g_evbuff_nr_of_rows);
         -- Check if the end of the transaction suceeded
         IF l_return_value <> PA_LIMS.DBERR_SUCCESS THEN
            -- Log an error in ITERROR
            PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                          'Unable to send the events at the end of the transaction. (Error Code: '||l_return_value||')');
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            l_return_value_final := FALSE;
         ELSE
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Ended);
         END IF;

         -- End the remote transaction
         IF NOT PA_LIMS.f_EndRemoteTransaction THEN
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
            l_return_value_final := FALSE;
         END IF;
         COMMIT;
         
      END IF;
      RETURN(l_return_value_final);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to send the events at the end of the transaction :  '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         RETURN (FALSE);
   END f_SendTransferFinishedEvents;

   FUNCTION f_GetTemplate(
      a_Object   IN itlimstmp.en_tp%TYPE,
      a_Id       IN itlimstmp.en_id%TYPE
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the templates of the object
      -- ** Parameters **
      -- a_object: object type
      -- a_id    : object id
      -- ** Return **
      -- The name of the template
      ------------------------------------------------------------------------------
      -- Cursor to get the name of the template
      CURSOR l_Get_Template_Cursor(
         c_Object   itlimstmp.en_tp%TYPE,
         c_Id       itlimstmp.en_id%TYPE
      )
      IS
         SELECT lims_tmp
           FROM itlimstmp
          WHERE en_tp = c_Object
            AND en_id = NVL(c_Id, 0);
   BEGIN
      -- Get the default template of the method definition and the parameter definition
      IF (a_Object = 'MT') OR (a_Object = 'PR') THEN
         FOR l_Get_Tempate_Rec IN l_Get_Template_Cursor(a_Object, a_Id) LOOP
            RETURN (l_Get_Tempate_Rec.lims_tmp);
         END LOOP;
      END IF;

      -- Get the template of the sample type and the parameter profile
      IF (a_Object = 'ST') OR (a_Object = 'LY') THEN
         -- Get the template of the object ID
         FOR l_Get_Tempate_Rec IN l_Get_Template_Cursor(a_Object, a_Id) LOOP
            RETURN (l_Get_Tempate_Rec.lims_tmp);
         END LOOP;

         -- Get the default template
         FOR l_Get_Tempate_Rec IN l_Get_Template_Cursor(a_Object, NULL) LOOP
            RETURN (l_Get_Tempate_Rec.lims_tmp);
         END LOOP;
      END IF;

      RETURN (NULL);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to get the template for '||a_Object||' "'||a_Id||'":  '||SQLERRM);
         RETURN (NULL);
   END f_GetTemplate;

   FUNCTION f_GetSettingValue(
      a_setting    IN interspc_cfg.parameter%TYPE
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the value of a configuration setting
      -- ** Parameters **
      -- a_setting: setting name
      -- ** Return **
      -- The value of the setting
      ------------------------------------------------------------------------------
      l_parameter_data    interspc_cfg.parameter_data%TYPE;   
      -- Cursor to get the configuration setting
      CURSOR l_get_conf_setting_cursor(c_setting interspc_cfg.parameter%TYPE)
      IS
         SELECT parameter_data
           FROM interspc_cfg
          WHERE section = 'U4 INTERFACE'
            AND parameter = c_setting;
   BEGIN
      BEGIN
         RETURN(p_InterspcCfgTab(a_setting));
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         --p_InterspcCfgTab is a table of VARCHAR2 indexed by VARCHAR2
         --It allows us to cache the interspc_cfg settings 
         --and search in the array directly by passing the searched setting_name
         p_InterspcCfgTab(a_setting) := NULL;
      FOR l_get_conf_setting_rec IN l_get_conf_setting_cursor(a_setting) LOOP
            p_InterspcCfgTab(a_setting) := l_get_conf_setting_rec.parameter_data;
            EXIT;
      END LOOP;
         RETURN(p_InterspcCfgTab(a_setting));
      END;

      -- Log an error in ITERROR
      PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to get the setting "'||a_setting||'".');
      RETURN (NULL);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 'Unable to get the setting "'||a_setting||'" :  '||SQLERRM);
         RETURN (NULL);
   END f_GetSettingValue;

   FUNCTION f_GetPathValue(
      a_db          IN itlimsppkey.db%TYPE,
      a_pp_key_seq  IN itlimsppkey.pp_key_seq%TYPE
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Get the path to find a pp_key on a Unilab db
      -- ** Parameters **
      -- a_db        : Unilab database of which a path has to be found
      -- a_pp_key_seq: seq of the pp_key of which the path has to be found
      -- ** Return **
      -- The value of the path
      ------------------------------------------------------------------------------
      -- Cursor to get the path value
      CURSOR l_path_cursor(c_db IN VARCHAR2, c_pp_key_seq IN NUMBER)
      IS
         SELECT path
           FROM itlimsppkey
          WHERE db         = c_db
            AND pp_key_seq = c_pp_key_seq;
   BEGIN
      -- Get the path value
      FOR l_path_rec IN l_path_cursor(a_db, a_pp_key_seq) LOOP
         RETURN (l_path_rec.path);
      END LOOP;

      -- Log an error in ITERROR
      PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                    'Unable to get the path of pp_key'||a_pp_key_seq||' on database '||
                       a_db||'.');
      RETURN (NULL);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unable to get the path of pp_key'||a_pp_key_seq||' on database '||
                          a_db||':  '||SQLERRM);
         RETURN (NULL);
   END f_GetPathValue;

   FUNCTION f_GetPrId(
      a_property    IN     VARCHAR2, 
      a_revision    IN     NUMBER,
      a_attribute   IN     VARCHAR2,
      a_sp_desc     IN     VARCHAR2,
      a_pr_desc        OUT VARCHAR2
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Generate the ID and description of a parameter definition
      -- ** Parameters **
      -- a_property   : property for which the parameter definition id has to be searched
      -- a_revision   : revision of the property
      -- a_attribute  : attribute of the property
      -- a_sp_desc    : IF a_attribute is empty THEN
      --                   description of the property
      --                ELSE
      --                   description of the property concatenated with description of the attribute 
      --                END IF;
      -- a_pr_desc    : description of the parameter definition
      -- ** Information **
      -- The parameter definition has a limited length of 20, the description of 40.
      -- ** Return **
      -- The Id of the parameter definition
      ------------------------------------------------------------------------------
      -- General variables
      l_lims_desc                VARCHAR2(130);
      l_lims_au_desc             VARCHAR2(60);
      l_nr_of_pr                 NUMBER;
      l_property                 VARCHAR2(20);
      l_pr                       VARCHAR2(20);
--      l_prev_sp_desc               VARCHAR2(60);
--      l_prev_au_desc               VARCHAR2(60);
      l_exists                   BOOLEAN;
      l_temp_pr_id               VARCHAR2(20);
      l_highest_major_version    VARCHAR2(20);

      -- Cursor to check if the property already exists in Unilab
      CURSOR l_pr_cursor(c_property VARCHAR2) IS
         SELECT DISTINCT uvpr.pr, SUBSTR(uvpr.description,1,37) substr_description, MAX(uvpr.description) description
           FROM UVPR@LNK_LIMS, UVPRAU@LNK_LIMS
          WHERE uvprau.pr      = uvpr.pr
            AND uvprau.version = uvpr.version
            AND uvprau.au      = c_au_orig_name
            AND uvprau.value   = c_property
       GROUP BY uvpr.pr, SUBSTR(uvpr.description,1,37);
       
       CURSOR l_pr_cursor_4desc(c_pr VARCHAR2, c_version VARCHAR2) IS
         SELECT uvpr.pr, SUBSTR(uvpr.description,1,37) substr_description, uvpr.description description
           FROM UVPR@LNK_LIMS
          WHERE uvpr.pr = c_pr
            AND uvpr.version = c_version;
       l_pr_desc_rec    l_pr_cursor_4desc%ROWTYPE;
   BEGIN
      -- if the property has an attribute, it has to be concatenated to the property.
      IF a_attribute = 0 THEN
         l_property := a_property;
      ELSE
         l_property := RPAD(a_property,10,' ')||a_attribute;
      END IF;
   
      -----------------
      -- description --
      -----------------
      -- check if the description is too long for Unilab
      IF LENGTH(a_sp_desc) > 40 THEN
         -- truncate the description
         a_pr_desc := SUBSTR(a_sp_desc,1,37);
         -- check if this description already exists in Unilab
         l_exists := FALSE;
         SELECT MAX(pr)
         INTO l_temp_pr_id
         FROM UVPRAU@LNK_LIMS
         WHERE uvprau.au = c_au_orig_name
         AND uvprau.value = l_property;
         
         l_highest_major_version :=PA_LIMS_CUSTOM.f_GetHighestMajorVersion('pr', l_temp_pr_id);
         --This cursor is only watching at the highest major version that should come from Interspec
         --We stay away from any modification made in minor versions
         OPEN l_pr_cursor_4desc(l_temp_pr_id, l_highest_major_version);
         FETCH l_pr_cursor_4desc
         INTO l_pr_desc_rec;
         IF l_pr_cursor_4desc%FOUND THEN
--         FOR l_pr_desc_rec IN l_pr_cursor(l_temp_pr_id, l_highest_major_version) LOOP
            l_exists := TRUE;
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pr_desc_rec.substr_description, a_pr_desc) = 1 THEN
               -- Truncated description in unilab is matching the truncated description of Interspec
               --
               -- check if the NOT truncated description differs from the previous one
               --
               --
--This piece of code was systemitcally leading to the generation of a new version of parameters in Unilab
--every time f_transferCfg was run.
--As far as I understood this code, its is attempting to compare the new long description with the old one when changed
--to see if something has changed to the description at the end of the string (after 37) and regenerate an description
--with a higher index at the end indicating that someone has changed the trailing characters of the description
--This piece of code was attempting the unfeasible since original full description is not stored in Unilab (nowhere)
-- it can detect the modification in Interspec but can not compare it to unilab
--Conclusion: Just commented out this code that was just leading to problems by attempting the infeasible
--            This code was also incompatible with the new principle introduced in version 6.2 for pr and mt: 
--                              major version from interspec/minor versions in Unilab
--
a_pr_desc := l_pr_desc_rec.description;
--
--               BEGIN
--                  SELECT NVL(sp1.description,' ')
--                    INTO l_prev_sp_desc
--                    FROM property_h sp1
--                   WHERE sp1.property = a_property
--                     AND sp1.revision = (SELECT MAX(sp2.revision) 
--                                           FROM property_h sp2
--                                          WHERE sp1.property = sp2.property
--                                            AND sp1.lang_id  = sp2.lang_id
--                                            AND sp2.revision < a_revision)
--                     AND sp1.lang_id  = g_lang_id_4desc;
--               EXCEPTION
--               WHEN NO_DATA_FOUND THEN
--                  l_prev_sp_desc := ' ';
--               END;
--               IF l_prev_sp_desc <> ' ' AND
--                  a_attribute <> 0 THEN
--                  BEGIN                 
--                     SELECT description
--                       INTO l_prev_au_desc
--                       FROM attribute_h
--                      WHERE attribute = a_attribute
--                        AND max_rev   = 1
--                        AND lang_id   = g_lang_id_4desc; 
--                     l_prev_sp_desc := SUBSTR(l_prev_sp_desc||' '||l_prev_au_desc,1,60);
--                  EXCEPTION
--                  WHEN NO_DATA_FOUND THEN
--                     --ignored, we do not touch l_prev_sp_desc
--                     NULL;
--                  END;
--               END IF;
--               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_prev_sp_desc, a_sp_desc) = 1 THEN
--                  a_pr_desc := l_pr_desc_rec.description;
--               ELSE
--                  l_exists := FALSE;
--               END IF;
            ELSE
               l_exists := FALSE;
            END IF;
--         END LOOP;
         END IF;
         CLOSE l_pr_cursor_4desc;
         IF NOT l_exists THEN
            -- get the number of existing pr's with this truncated description
            SELECT COUNT(DISTINCT description)
              INTO l_nr_of_pr
              FROM UVPR@LNK_LIMS
             WHERE SUBSTR(description,1,37) = a_pr_desc;
            -- concatenate (number of existing pr's)+1 at the end
            a_pr_desc := a_pr_desc||'_'||LPAD((l_nr_of_pr+1),2,'0');
         END IF;
      ELSE
         a_pr_desc := a_sp_desc;
      END IF;

      --------
      -- id --
      --------
      -- get the LIMS description, which will become the parameter id
      BEGIN
         SELECT description
           INTO l_lims_desc
           FROM property_h
          WHERE property = a_property
            AND revision = a_revision
            AND lang_id  = g_lang_id_4id;
         
         -- if the property has an attribute, its LIMS description has to be concatenated to the property LIMS description
         IF a_attribute <> 0 THEN
            SELECT description
              INTO l_lims_au_desc
              FROM attribute_h
             WHERE attribute = a_attribute
               AND max_rev   = 1
               AND lang_id   = g_lang_id_4id; 
            l_lims_desc := l_lims_desc||' '||l_lims_au_desc;
         END IF;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_lims_desc := a_sp_desc;
      END;
      -- check if the LIMS description is too long for Unilab
      IF LENGTH(l_lims_desc) > 20 THEN
         -- truncate the LIMS description
         l_pr := SUBSTR(l_lims_desc,1,17);
         -- check if this property already exists in Unilab
         l_exists := FALSE;
         FOR l_pr_rec IN l_pr_cursor(l_property) LOOP
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(SUBSTR(l_pr_rec.pr,1,17), l_pr) = 1 THEN
               l_exists := TRUE;
               l_pr := l_pr_rec.pr;
            END IF;
         END LOOP;
         IF NOT l_exists THEN
            -- get the number of existing pr's with this truncated LIMS description
            SELECT COUNT(DISTINCT pr)
              INTO l_nr_of_pr
              FROM UVPR@LNK_LIMS
             WHERE SUBSTR(pr,1,17) = l_pr;
            -- concatenate (number of existing pr's)+1 at the end
            l_pr := l_pr||'_'||LPAD((l_nr_of_pr+1),2,'0');
         END IF;
      ELSE
         l_pr := l_lims_desc;
      END IF;
      RETURN (l_pr);
   EXCEPTION
      WHEN OTHERS THEN
         IF l_pr_cursor_4desc%ISOPEN THEN
            CLOSE l_pr_cursor_4desc;
         END IF;
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to generate the parameter id and description for property "'||a_property||
                       '" | revision='||a_revision||' | description="'||a_sp_desc||'" | attribute="'||
                       a_attribute||'" : '||SQLERRM);
         RETURN (NULL);
   END f_GetPrId;

   FUNCTION f_GetMtId(
      a_test_method   IN     VARCHAR2,
      a_revision      IN     NUMBER,
      a_tm_desc       IN     VARCHAR2,
      a_mt_desc          OUT VARCHAR2
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Generate the ID and description of a method definition
      -- ** Parameters **
      -- a_test_method : test_method for which the method definition id has to be searched
      -- a_revision    : revision of the test_method
      -- a_tm_desc     : description of the test_method
      -- a_mt_desc     : description of the method definition
      -- ** Information **
      -- The method definition has a limited length of 20, the description of 40.
      -- ** Return **
      -- The Id of the method definition
      ------------------------------------------------------------------------------
      -- General variables
      l_lims_desc                VARCHAR2(130);
      l_nr_of_mt                 NUMBER;
      l_mt                       VARCHAR2(20);
      l_prev_tm_desc             VARCHAR2(60);
      l_exists                   BOOLEAN;
      l_temp_mt_id               VARCHAR2(20);
      l_highest_major_version    VARCHAR2(20);

      -- Cursor to check if the test_method already exists in Unilab
      CURSOR l_mt_cursor(c_test_method VARCHAR2) IS
         SELECT DISTINCT uvmt.mt, SUBSTR(uvmt.description,1,37) substr_description, MAX(uvmt.description) description
           FROM UVMT@LNK_LIMS, UVMTAU@LNK_LIMS
          WHERE uvmtau.mt      = uvmt.mt
            AND uvmtau.version = uvmt.version
            AND uvmtau.au      = c_au_orig_name
            AND uvmtau.value   = c_test_method
       GROUP BY uvmt.mt, SUBSTR(uvmt.description,1,37);

       CURSOR l_mt_cursor_4desc(c_mt VARCHAR2, c_version VARCHAR2) IS
         SELECT uvmt.mt, SUBSTR(uvmt.description,1,37) substr_description, uvmt.description description
           FROM UVMT@LNK_LIMS
          WHERE uvmt.mt = c_mt
            AND uvmt.version = c_version;
       l_mt_desc_rec    l_mt_cursor_4desc%ROWTYPE;
       
   BEGIN
      -----------------
      -- description --
      -----------------
      -- check if the description is too long for Unilab
      IF LENGTH(a_tm_desc) > 40 THEN
         -- truncate the description
         a_mt_desc := SUBSTR(a_tm_desc,1,37);
         -- check if this description already exists in Unilab
         l_exists := FALSE;
         SELECT MAX(mt)
         INTO l_temp_mt_id
         FROM UVMTAU@LNK_LIMS
         WHERE uvmtau.au = c_au_orig_name
         AND uvmtau.value = a_test_method;

         l_highest_major_version := PA_LIMS_CUSTOM.f_GetHighestMajorVersion('mt', l_temp_mt_id);
         --This cursor is only watching at the highest major version that should come from Interspec
         --We stay away from any modification made in minor versions
         OPEN l_mt_cursor_4desc(l_temp_mt_id, l_highest_major_version);
         FETCH l_mt_cursor_4desc
         INTO l_mt_desc_rec;
         IF l_mt_cursor_4desc%FOUND THEN
--         FOR l_mt_rec IN l_mt_cursor(a_test_method) LOOP
            l_exists := TRUE;
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_mt_desc_rec.substr_description, a_mt_desc) = 1 THEN
               -- Truncated description in unilab is matching the truncated description of Interspec
               --
               -- check if the NOT truncated description differs from the previous one
               --
               --
--This piece of code was systemitcally leading to the generation of a new version of methods in Unilab
--every time f_transferCfg was run.
--As far as I understood this code, its is attempting to compare the new long description with the old one when changed
--to see if something has changed to the description at the end of the string (after 37) and regenerate an description
--with a higher index at the end indicating that someone has changed the trailing characters of the description
--This piece of code was attempting the unfeasible since original full description is not stored in Unilab (nowhere)
-- it can detect the modification in Interspec but can not compare it to unilab
--Conclusion: Just commented out this code that was just leading to problems by attempting the infeasible
--            This code was also incompatible with the new principle introduced in version 6.2 for pr and mt: 
--                              major version from interspec/minor versions in Unilab
--
a_mt_desc := l_mt_desc_rec.description;
--               BEGIN
--                  SELECT NVL(tm1.description,' ')
--                    INTO l_prev_tm_desc
--                    FROM test_method_h tm1
--                   WHERE tm1.test_method = a_test_method
--                     AND tm1.revision    = (SELECT MAX(tm2.revision) 
--                                              FROM test_method_h tm2
--                                             WHERE tm1.test_method = tm2.test_method
--                                               AND tm1.lang_id     = tm2.lang_id
--                                               AND tm2.revision    < a_revision)
--                     AND tm1.lang_id     = g_lang_id_4desc;
--               EXCEPTION
--               WHEN NO_DATA_FOUND THEN
--                  l_prev_tm_desc := ' ';
--               END;
--               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_prev_tm_desc, a_tm_desc) = 1 THEN
--                  a_mt_desc := l_mt_desc_rec.description;
--               ELSE
--                  l_exists := FALSE;
--               END IF;
            ELSE
               l_exists := FALSE;
            END IF;
--         END LOOP;
         END IF;
         CLOSE l_mt_cursor_4desc;
         
         IF NOT l_exists THEN
            -- get the number of existing mt's with this truncated description
            SELECT COUNT(DISTINCT description)
              INTO l_nr_of_mt
              FROM UVMT@LNK_LIMS
             WHERE SUBSTR(description,1,37) = a_mt_desc;
            -- concatenate (number of existing mt's)+1 at the end
            a_mt_desc := a_mt_desc||'_'||LPAD((l_nr_of_mt+1),2,'0');
         END IF;
      ELSE
         a_mt_desc := a_tm_desc;
      END IF;

      --------
      -- id --
      --------
      -- get the LIMS description, which will become the method id
      BEGIN
         SELECT description
           INTO l_lims_desc
           FROM test_method_h
          WHERE test_method = a_test_method
            AND revision    = a_revision
            AND lang_id     = g_lang_id_4id;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_lims_desc := a_tm_desc;
      END;
      -- check if the LIMS description is too long for Unilab
      IF LENGTH(l_lims_desc) > 20 THEN
         -- truncate the LIMS description
         l_mt := SUBSTR(l_lims_desc,1,17);
         -- check if this test_method already exists in Unilab
         l_exists := FALSE;
         FOR l_mt_rec IN l_mt_cursor(a_test_method) LOOP
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(SUBSTR(l_mt_rec.mt,1,17), l_mt) = 1 THEN
               l_exists := TRUE;
               l_mt := l_mt_rec.mt;
            END IF;
         END LOOP;
         IF NOT l_exists THEN
            -- get the number of existing mt's with this truncated LIMS description
            SELECT COUNT(DISTINCT mt)
              INTO l_nr_of_mt
              FROM UVMT@LNK_LIMS
             WHERE SUBSTR(mt,1,17) = l_mt;
            -- concatenate (number of existing mt's)+1 at the end
            l_mt := l_mt||'_'||LPAD((l_nr_of_mt+1),2,'0');
         END IF;
      ELSE
         l_mt := l_lims_desc;
      END IF;
      RETURN (l_mt);
   EXCEPTION
      WHEN OTHERS THEN
         IF l_mt_cursor_4desc%ISOPEN THEN
            CLOSE l_mt_cursor_4desc;
         END IF;
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to generate the method id and description for testmethod "'||a_test_method||
                       '" | revision='||a_revision||' | description="'||a_tm_desc||'" : '||SQLERRM);
         RETURN (NULL);
   END f_GetMtId;

   FUNCTION f_GetPpId(
      a_part_no          IN     specification_header.part_no%TYPE,
      a_property_group   IN     VARCHAR2,
      a_revision         IN     NUMBER,
      a_pg_desc          IN     VARCHAR2,
      a_pp_desc             OUT VARCHAR2
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Generate the ID and description of a parameterprofile
      -- ** Parameters **
      -- a_part_no          : part_no of the specification
      -- a_property_group   : property_group for which the parameterprofile id has to be searched
      -- a_revision         : revision of the property_group
      -- a_pg_desc          : description of the property_group
      -- a_pp_desc          : description of the parameterprofile
      -- ** Information **
      -- The parameterprofile has a limited length of 20, the description of 40.
      -- ** Return **
      -- The Id of the parameterprofile
      ------------------------------------------------------------------------------
      -- General variables
      l_lims_desc      VARCHAR2(130);
      l_nr_of_pp       NUMBER;
      l_pp             VARCHAR2(20);
      l_pg_desc        VARCHAR2(150);
      l_prev_pg_desc   VARCHAR2(60);
      l_exists         BOOLEAN;

      -- Cursor to check if the property_group already exists in Unilab
      CURSOR l_pp_cursor(c_property_group VARCHAR2) IS
         SELECT DISTINCT uvpp.pp, SUBSTR(uvpp.description,1,37) substr_description, MAX(uvpp.description) description
           FROM UVPP@LNK_LIMS, UVPPAU@LNK_LIMS
          WHERE uvppau.pp      = uvpp.pp
            AND uvppau.version = uvpp.version
            AND uvppau.pp_key1 = uvpp.pp_key1
            AND uvppau.pp_key2 = uvpp.pp_key2
            AND uvppau.pp_key3 = uvpp.pp_key3
            AND uvppau.pp_key4 = uvpp.pp_key4
            AND uvppau.pp_key5 = uvpp.pp_key5
            AND uvppau.au      = c_au_orig_name
            AND uvppau.value   = c_property_group
       GROUP BY uvpp.pp, SUBSTR(uvpp.description,1,37);
   BEGIN
      -- if the property has an attribute, it has to be concatenated to the property.
      IF a_part_no IS NOT NULL THEN
         l_pg_desc := a_part_no||' '||a_pg_desc;
      ELSE
         l_pg_desc := a_pg_desc;
      END IF;

      -----------------
      -- description --
      -----------------
      -- check if the description is too long for Unilab
      IF LENGTH(l_pg_desc) > 40 THEN
         -- truncate the description
         a_pp_desc := SUBSTR(l_pg_desc,1,37);
         -- check if this description already exists in Unilab
         l_exists := FALSE;
         FOR l_pp_rec IN l_pp_cursor(a_property_group) LOOP
            l_exists := TRUE;
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_pp_rec.substr_description, a_pp_desc) = 1 THEN
               -- check if the NOT truncated description differs from the previous one
               BEGIN
                  SELECT NVL(pg1.description,' ')
                    INTO l_prev_pg_desc
                    FROM property_group_h pg1
                   WHERE pg1.property_group = a_property_group
                     AND pg1.revision       = (SELECT MAX(pg2.revision) 
                                                 FROM property_group_h pg2
                                                WHERE pg1.property_group = pg2.property_group
                                                  AND pg1.lang_id        = pg2.lang_id
                                                  AND pg2.revision       < a_revision)
                     AND pg1.lang_id  = g_lang_id_4desc;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  l_prev_pg_desc := ' ';
               END;
               IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_prev_pg_desc, l_pg_desc) = 1 THEN
                  a_pp_desc := l_pp_rec.description;
               ELSE
                  l_exists := FALSE;
               END IF;
            ELSE
               l_exists := FALSE;
            END IF;
         END LOOP;
         IF NOT l_exists THEN
            -- get the number of existing pp's with this truncated description
            SELECT COUNT(DISTINCT description)
              INTO l_nr_of_pp
              FROM UVPP@LNK_LIMS
             WHERE SUBSTR(description,1,37) = a_pp_desc;
            -- concatenate (number of existing pp's)+1 at the end
            a_pp_desc := a_pp_desc||'_'||LPAD((l_nr_of_pp+1),2,'0');
         END IF;
      ELSE
         a_pp_desc := l_pg_desc;
      END IF;

      --------
      -- id --
      --------
      -- get the LIMS description, which will become the parameterprofile id
      BEGIN
         SELECT description
           INTO l_lims_desc
           FROM property_group_h
          WHERE property_group = a_property_group
            AND revision       = a_revision
            AND lang_id        = g_lang_id_4id;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_lims_desc := a_pg_desc;
      END;
      -- check if the LIMS description is too long for Unilab
      IF LENGTH(l_lims_desc) > 20 THEN
         -- truncate the LIMS description
         l_pp := SUBSTR(l_lims_desc,1,17);
         -- check if this property_group already exists in Unilab
         l_exists := FALSE;
         FOR l_pp_rec IN l_pp_cursor(a_property_group) LOOP
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(SUBSTR(l_pp_rec.pp,1,17), l_pp) = 1 THEN
               l_exists := TRUE;
               l_pp := l_pp_rec.pp;
            END IF;
         END LOOP;
         IF NOT l_exists THEN
            -- get the number of existing pp's with this truncated LIMS description
            SELECT COUNT(DISTINCT pp)
              INTO l_nr_of_pp
              FROM UVPP@LNK_LIMS
             WHERE SUBSTR(pp,1,17) = l_pp;
            -- concatenate (number of existing pp's)+1 at the end
            l_pp := l_pp||'_'||LPAD((l_nr_of_pp+1),2,'0');
         END IF;
      ELSE
         l_pp := l_lims_desc;
      END IF;
      RETURN (l_pp);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to generate the parameterprofile id and description for propertygroup "'||
                       a_property_group||'" | revision='||a_revision||' | description="'||l_pg_desc||'" : '||SQLERRM);
         RETURN (NULL);
   END f_GetPpId;

   FUNCTION f_GetStAuId(
      a_Ly          IN itlimsconfly.layout_id%TYPE,
      a_lyRev       IN itlimsconfly.layout_rev%TYPE,
      a_Column      IN itlimsconfly.is_col%TYPE,
      a_Property    IN property.property%TYPE,
      a_Attribute   IN specification_prop.attribute%TYPE
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Generate the ID of an attribute of a sample type
      -- ** Parameters **
      -- a_Ly         : layout id
      -- a_lyRev      : layout revision
      -- a_Column     : layout column name
      -- a_Property   : property id
      -- a_Attribute  : attribute id
      -- ** Information **
      -- The ID of the attribute of the sample type has a limited length of 20.
      -- ** Return **
      -- The Id of the Parameter profile
      -- ** Remarks **
      --    JB 22/05/01 The composition of the name of the attribute is switched
      --                First the name of the property (l_desc_property),
      --                Then the name of layoutcolumn (l_field_name)
      ------------------------------------------------------------------------------
      -- General variables
      l_field_name       VARCHAR2(40);
      l_desc_property    VARCHAR2(60);
      l_desc_attribute   VARCHAR2(60);

      -- Cursor to get the name of the field
      CURSOR l_get_field_name_cursor(
         c_Ly       itlimsconfly.layout_id%TYPE,
         c_lyRev    itlimsconfly.layout_rev%TYPE,
         c_Column   itlimsconfly.is_col%TYPE
      )
      IS
         SELECT SUBSTR(f_hdh_descr(1, header_id, header_rev), 1, 40) cf_hd
           FROM property_layout
          WHERE layout_id = c_Ly
            AND revision = c_lyRev
            AND DECODE("PROPERTY_LAYOUT"."FIELD_ID",
                       1,  'num_1',
                       2,  'num_2',
                       3,  'num_3',
                       4,  'num_4',
                       5,  'num_5',
                       6,  'num_6',
                       7,  'num_7',
                       8,  'num_8',
                       9,  'num_9',
                       10, 'num_10',
                       11, 'char_1',
                       12, 'char_2',
                       13, 'char_3',
                       14, 'char_4',
                       15, 'char_5',
                       16, 'char_6',
                       17, 'boolean_1',
                       18, 'boolean_2',
                       19, 'boolean_3',
                       20, 'boolean_4',
                       21, 'date_1',
                       22, 'date_2',
                       23, 'UOM_ID',
                       25, 'test_method',
                       26, 'CHARACTERISTIC',
                       30, 'CH_2',
                       31, 'CH_3',
                       32, 'tm_det_1',
                       33, 'tm_det_2',
                       34, 'tm_det_3',
                       35, 'tm_det_4') = c_Column;

      -- Cursor to get the description of the property
      CURSOR l_get_desc_property_cursor(c_Property property.property%TYPE)
      IS
         SELECT description
           FROM property
          WHERE property = c_Property;

      -- Cursor to get the description of the attribute
      CURSOR l_get_desc_attribute_cursor(c_Attribute property.property%TYPE)
      IS
         SELECT description
           FROM attribute
          WHERE attribute = c_Attribute;
   BEGIN
      -- Get the name of the field
      FOR l_get_field_name_rec IN l_get_field_name_cursor(a_ly, a_LyRev, a_Column) LOOP
         l_field_name := l_get_field_name_rec.cf_hd;
      END LOOP;

      -- Get the description of the property
      FOR l_get_desc_property_rec IN l_get_desc_property_cursor(a_Property) LOOP
         l_desc_property := l_get_desc_property_rec.description;
      END LOOP;

      -- Check if the field name is found
      IF (l_field_name IS NULL) OR (l_desc_property IS NULL) THEN
         RETURN (NULL);
      ELSE
         IF a_Attribute = 0 THEN
            RETURN(SUBSTR(l_desc_property||l_field_name, 1, 20));
         ELSE
            -- Get the description of the property
            FOR l_get_desc_attribute_rec IN l_get_desc_attribute_cursor(a_attribute) LOOP
               l_desc_attribute := l_get_desc_attribute_rec.description;
            END LOOP;

            IF l_desc_attribute IS NULL THEN
               RETURN (NULL);
            END IF;

            RETURN (SUBSTR(l_desc_property||l_desc_attribute||l_field_name, 1, 20));
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN (NULL);
   END f_GetStAuId;

   FUNCTION f_GetStPpPrAuId(
      a_Ly       IN ITLIMSCONFLY.LAYOUT_ID%TYPE,
      a_lyRev    IN ITLIMSCONFLY.LAYOUT_REV%TYPE,
      a_Column   IN ITLIMSCONFLY.IS_COL%TYPE
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Generate the ID of the attribute of a parameter definition assigned
      -- to a parameter profile
      -- ** Parameters **
      -- a_Ly     : layout id
      -- a_lyRev  : layout revision
      -- a_Column : layout column name
      -- ** Information **
      -- The ID of the attribute of the sample type has a limited length of 20.
      -- ** Return **
      -- The ID of the attribute of a parameter definition assigned to a parameter profile
      ------------------------------------------------------------------------------
      -- General variables
      l_field_name   VARCHAR2(40);

      -- Cursor to get the field name for the column
      CURSOR l_get_field_name_cursor(
         c_Ly       itlimsconfly.layout_id%TYPE,
         c_lyRev    itlimsconfly.layout_rev%TYPE,
         c_Column   itlimsconfly.is_col%TYPE
      )
      IS
         SELECT SUBSTR(f_hdh_descr(1, header_id, header_rev), 1, 40) cf_hd
           FROM property_layout
          WHERE layout_id = c_Ly
            AND revision = c_lyRev
            AND DECODE("PROPERTY_LAYOUT"."FIELD_ID",
                       1, 'num_1',
                       2, 'num_2',
                       3, 'num_3',
                       4, 'num_4',
                       5, 'num_5',
                       6, 'num_6',
                       7, 'num_7',
                       8, 'num_8',
                       9, 'num_9',
                       10, 'num_10',
                       11, 'char_1',
                       12, 'char_2',
                       13, 'char_3',
                       14, 'char_4',
                       15, 'char_5',
                       16, 'char_6',
                       17, 'boolean_1',
                       18, 'boolean_2',
                       19, 'boolean_3',
                       20, 'boolean_4',
                       21, 'date_1',
                       22, 'date_2',
                       23, 'UOM_ID',
                       25, 'test_method',
                       26, 'CHARACTERISTIC',
                       30, 'CH_2',
                       31, 'CH_3',
                       32, 'tm_det_1',
                       33, 'tm_det_2',
                       34, 'tm_det_3',
                       35, 'tm_det_4') = c_Column;
   BEGIN
      -- Get the name of the field
      FOR l_get_field_name_rec IN l_get_field_name_cursor(a_ly, a_LyRev, a_Column) LOOP
         l_field_name := l_get_field_name_rec.cf_hd;
      END LOOP;

      -- Check if the field name is found
      IF l_field_name IS NULL THEN
         RETURN (NULL);
      ELSE
         RETURN (SUBSTR(l_field_name, 1, 20));
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to generate the id for the attribute of a parameter definition'||
                       ' assigned to a parameter profile of a sample type (layout="'||a_Ly||'" | revision='||
                       a_LyRev||' | column="'||a_Column||'") : '||SQLERRM);
         RETURN (NULL);
   END f_GetStPpPrAuId;

   FUNCTION f_GetStGkId(
      a_Ly       IN itlimsconfly.layout_id%TYPE,
      a_lyRev    IN itlimsconfly.layout_rev%TYPE,
      a_Column   IN itlimsconfly.is_col%TYPE
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Generate the ID of the sample type groupkey
      -- ** Parameters **
      -- a_Ly     : layout id
      -- a_lyRev  : layout revision
      -- a_Column : layout column name
      -- ** Information **
      -- The ID of the sample type groupkey has a limited length of 20.
      -- ** Return **
      -- The ID of the sample type groupkey
      ------------------------------------------------------------------------------
      -- General variables
      l_field_name   VARCHAR2(40);

      -- Cursor to get the field name
      CURSOR l_get_field_name_cursor(
         c_Ly       itlimsconfly.layout_id%TYPE,
         c_lyRev    itlimsconfly.layout_rev%TYPE,
         c_Column   itlimsconfly.is_col%TYPE
      )
      IS
         SELECT SUBSTR(f_hdh_descr(1, header_id, header_rev), 1, 40) cf_hd
           FROM property_layout
          WHERE layout_id = c_Ly
            AND revision = c_lyRev
            AND DECODE("PROPERTY_LAYOUT"."FIELD_ID",
                       1, 'num_1',
                       2, 'num_2',
                       3, 'num_3',
                       4, 'num_4',
                       5, 'num_5',
                       6, 'num_6',
                       7, 'num_7',
                       8, 'num_8',
                       9, 'num_9',
                       10, 'num_10',
                       11, 'char_1',
                       12, 'char_2',
                       13, 'char_3',
                       14, 'char_4',
                       15, 'char_5',
                       16, 'char_6',
                       17, 'boolean_1',
                       18, 'boolean_2',
                       19, 'boolean_3',
                       20, 'boolean_4',
                       21, 'date_1',
                       22, 'date_2',
                       23, 'UOM_ID',
                       25, 'test_method',
                       26, 'CHARACTERISTIC',
                       30, 'CH_2',
                       31, 'CH_3',
                       32, 'tm_det_1',
                       33, 'tm_det_2',
                       34, 'tm_det_3',
                       35, 'tm_det_4') = c_Column;
   BEGIN
      -- Get the field name
      FOR l_get_field_name_rec IN l_get_field_name_cursor(a_ly, a_LyRev, a_Column) LOOP
         l_field_name := l_get_field_name_rec.cf_hd;
      END LOOP;

      -- Check if the field name is found
      IF l_field_name IS NULL THEN
         RETURN (NULL);
      ELSE
         RETURN (f_GetGkId(l_field_name));
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN (NULL);
   END f_GetStGkId;

   FUNCTION f_GetGkId(
      a_GkId    IN VARCHAR2
   )
      RETURN VARCHAR2
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Generate the ID of a groupkey
      -- ** Parameters **
      -- a_GkId : gk id
      -- ** Information **
      -- The ID of a groupkey has a limited length of 20.
      -- The following characters are not allowed ' ','_' and '.''
      -- ** Return **
      -- The ID of a groupkey
      ------------------------------------------------------------------------------
      -- General variables
      l_gk_id   VARCHAR2(20);
   BEGIN
      l_gk_id := SUBSTR(a_GkId, 1, 20);
      l_gk_id := REPLACE(l_gk_id, ' ', '_');
      l_gk_id := REPLACE(l_gk_id, '-', '_');
      l_gk_id := REPLACE(l_gk_id, '.', '_');
      RETURN (l_gk_id);
   EXCEPTION
      WHEN OTHERS THEN
         RETURN (NULL);
   END f_GetGkId;

   FUNCTION f_GetHighestRevision(
      a_obj_tp   IN VARCHAR2,
      a_obj_id   IN VARCHAR2
   )
      RETURN NUMBER
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Generate the version of the given object
      -- ** Parameters **
      -- a_obj_tp  : object type
      -- a_obj_id  : object id
      -- ** Information **
      -- The following characters are allowed: specification, property_group, property and test_method
      -- ** Return **
      -- The highest revision of the given object
      ------------------------------------------------------------------------------
      -- General variables
      l_revision NUMBER(4);
   BEGIN
      IF a_obj_tp = 'specification' THEN
         SELECT MAX(revision)
           INTO l_revision
           FROM specification_header
          WHERE part_no = a_obj_id;
      ELSIF a_obj_tp = 'property_group' THEN
         SELECT DISTINCT revision -- DISTINCT because of the several lang_id's
           INTO l_revision
           FROM property_group_h
          WHERE property_group = a_obj_id
            AND max_rev = 1;
      ELSIF a_obj_tp = 'property' THEN
         SELECT DISTINCT revision -- DISTINCT because of the several lang_id's
           INTO l_revision
           FROM property_h
          WHERE property = a_obj_id
            AND max_rev = 1;
      ELSIF a_obj_tp = 'test_method' THEN
         SELECT DISTINCT revision -- DISTINCT because of the several lang_id's
           INTO l_revision
           FROM test_method_h
          WHERE test_method = a_obj_id
            AND max_rev = 1;
      ELSIF a_obj_tp = 'attribute' THEN
         SELECT DISTINCT revision -- DISTINCT because of the several lang_id's
           INTO l_revision
           FROM attribute_h
          WHERE description = a_obj_id
            AND max_rev = 1;
      ELSE
         l_revision := NULL;
      END IF;
      RETURN(l_revision);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         -- Will only happen for attributes: if the object does not exist, return revision 1
         RETURN(1);
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic, 
                       'Unable to generate the revision for '||a_obj_tp||' "'||a_obj_id||'" : '||SQLERRM);
         RETURN (NULL);
   END f_GetHighestRevision;

   PROCEDURE p_Trace(
      a_classname   IN   VARCHAR2,
      a_method      IN   VARCHAR2,
      a_id1         IN   VARCHAR2,
      a_id2         IN   VARCHAR2,
      a_id3         IN   VARCHAR2,
      a_msg         IN   VARCHAR2
   )
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Trace the api calls
      ------------------------------------------------------------------------------
      -- General variables
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'p_Trace';
      l_idlength    CONSTANT INTEGER      := 40;
   BEGIN
      -- Logging to DBMS output
      DBMS_OUTPUT.PUT_LINE(RPAD(a_classname, 8, ' ')||' | '||RPAD(a_method, 30, ' ')||' | '||
                           SUBSTR(a_id1, 1, l_idlength)||' | '||SUBSTR(a_id2, 1, l_idlength)||' | '||
                           SUBSTR(a_id3, 1, l_idlength)||' | '||SUBSTR(a_msg,1,150));
      IF LENGTH(a_msg) > 150 THEN
         DBMS_OUTPUT.PUT_LINE(SUBSTR(a_msg,151,200));
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         -- Log Message
         PA_LIMS.P_Log(l_classname, l_method, NULL);
         NULL;
   END p_Trace;

   PROCEDURE p_Log(
      a_Object   IN   VARCHAR2,
      a_Method   IN   VARCHAR2,
      a_Msg      IN   VARCHAR2
   )
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Logs errors in the table ITERROR
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname   CONSTANT VARCHAR2(12) := 'Lims';
      l_method      CONSTANT VARCHAR2(32) := 'p_Log';

      -- General variables
      l_Msg   VARCHAR2(1024);
   BEGIN
      -- check if we want to log the Message (!!!! REALTIME activation ????)
      IF (c_LOGGING) THEN
         -- check the destination of logging
         IF (c_DEBUG) THEN
            -- to the DBMS_OUTPUT window
            IF a_Msg IS NULL THEN
               l_Msg := SUBSTR(SQLERRM,1,256);
            ELSE
               l_Msg := SUBSTR(a_Msg,1,256);
            END IF;

            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, a_object, a_method, NULL, l_Msg);
         ELSE
            -- to the logging table in the database
            IF a_Msg IS NULL THEN
               l_Msg := SUBSTR(SQLERRM,1,256);
            ELSE
               l_Msg := SUBSTR(a_Msg,1,256);
            END IF;

            -- Log the error
            -- Since the mechanism for errorlogging has been changed from Interspec 6.1 on,
            -- dynamic sql is used to decide which package to use.
            IF p_inside_getispecversion = '0' THEN --avoid infinite loop f_GetInterspecVersion calling p_Log
               IF SUBSTR(PA_LIMS.f_GetInterspecVersion,1,1) = '5' THEN
                  EXECUTE IMMEDIATE 'BEGIN PA_ITERROR.p_LogUserError(:a_object,:a_method,:l_msg); END;'
                  USING IN a_object, a_method, l_msg;
               ELSE
                  EXECUTE IMMEDIATE 'BEGIN IAPIGENERAL.LogError(:a_object,:a_method,:l_msg); END;'
                  USING IN a_object, a_method, l_msg;
               END IF;
            END IF;
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END p_Log;

   PROCEDURE p_TraceSt(
      a_StId      IN VARCHAR2,
      a_version   IN VARCHAR2
   )
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Trace the contents of the St
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'LimsSpc';
      l_method       CONSTANT VARCHAR2(32)                      := 'p_TraceSt';

      -- Cursor to get the sampletype attributes
      CURSOR l_GetStAu_Cursor(c_st VARCHAR2, c_version VARCHAR2)
       IS
         SELECT au, value
           FROM UVSTAU@LNK_LIMS
          WHERE st = c_st
            AND version = c_version
          ORDER BY auseq;

      -- Cursor to get the sampletype parameterprofiles
      CURSOR l_GetStPp_Cursor(c_st VARCHAR2, c_version VARCHAR2)
       IS
         SELECT pp, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5
           FROM UVSTPP@LNK_LIMS
          WHERE st = c_st
            AND version = c_version
          ORDER BY seq;

      -- Cursor to get the parameterprofile attributes
      CURSOR l_GetPpAu_Cursor(c_pp VARCHAR2, c_version VARCHAR2, c_pp_key1 VARCHAR2, 
                              c_pp_key2 VARCHAR2, c_pp_key3 VARCHAR2, c_pp_key4 VARCHAR2, 
                              c_pp_key5 VARCHAR2)
       IS
         SELECT au, value
           FROM UVPPAU@LNK_LIMS
          WHERE pp = c_pp
            AND version = c_version
            AND pp_key1 = c_pp_key1
            AND pp_key2 = c_pp_key2
            AND pp_key3 = c_pp_key3
            AND pp_key4 = c_pp_key4
            AND pp_key5 = c_pp_key5
          ORDER BY auseq;
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_StId||' | '||a_version, NULL, NULL, PA_LIMS.c_Msg_Started);

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 'The links between attributes and sample type: ');
      FOR l_GetStAu_Rec IN l_GetStAu_Cursor(a_StId, a_version) LOOP
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, l_GetStAu_Rec.au, l_GetStAu_Rec.value, NULL, NULL);
      END LOOP;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 
                      'The links between parameterprofiles and sample type: ');
      FOR l_GetStPp_Rec IN l_GetStPp_Cursor(a_StId, a_version) LOOP
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, l_GetStPp_Rec.pp||' | '||l_GetStPp_Rec.pp_version,
                         l_GetStPp_Rec.pp_key1||' | '||l_GetStPp_Rec.pp_key2, 
                         l_GetStPp_Rec.pp_key3||' | '||l_GetStPp_Rec.pp_key4, l_GetStPp_Rec.pp_key5);

         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, 
                         'The links between attributes and parameterprofile: ');
         FOR l_GetPpAu_Rec IN l_GetPpAu_Cursor(l_GetStPp_Rec.pp, l_GetStPp_Rec.pp_version, l_GetStPp_Rec.pp_key1, 
                                               l_GetStPp_Rec.pp_key2, l_GetStPp_Rec.pp_key3, l_GetStPp_Rec.pp_key4,
                                               l_GetStPp_Rec.pp_key5) LOOP
            -- Tracing
            PA_LIMS.p_Trace(l_classname, l_method, l_GetPpAu_Rec.au, l_GetPpAu_Rec.value, NULL, NULL);
         END LOOP;
      END LOOP;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, Pa_Lims.c_Msg_Ended);
   END p_TraceSt;
   
   FUNCTION f_SetPpKeys(
      a_part_no      IN VARCHAR2, 
      a_revision     IN VARCHAR2,
      a_st           IN VARCHAR2
   )
      RETURN BOOLEAN
   IS
      ------------------------------------------------------------------------------
      -- ** Purpose **
      -- Fill the parameterprofile keys, and get their names
      -- ** Parameters **
      -- a_part_no    : the part_no
      -- a_revision   : the revision of the part_no
      -- a_st         : the value for the pp_key with key_tp 'st'
      -- ** Return **
      -- TRUE  : it was possible to fill the information about the pp_keys
      -- FALSE : it was not possible to fill the information about the pp_keys
      ------------------------------------------------------------------------------
      -- Constant variables for the tracing
      l_classname    CONSTANT VARCHAR2(12)                      := 'Lims';
      l_method       CONSTANT VARCHAR2(32)                      := 'f_SetPpKeys';
   
      -- General variables
      l_cfg                  BOOLEAN                            := FALSE;
      l_path                 VARCHAR2(80);
      l_section_id           NUMBER(8);
      l_sub_section_id       NUMBER(8);
      l_property_group       NUMBER(6);
      l_property             NUMBER(8);
      l_column_name          VARCHAR2(20);
      l_value                VARCHAR2(20);
      
      -- Cursor to get the connect_string of a plant
      CURSOR l_connect_cursor(c_plant IN VARCHAR2) IS
         SELECT connect_string
           FROM itlimsplant
          WHERE plant = c_plant;
            
      -- Cursor to get the pp_key name
      CURSOR l_pp_key_cursor(c_seq IN NUMBER) IS
         SELECT DECODE(SUBSTR(key_name,1,3), 'gk.', SUBSTR(key_name,4), NULL) gk
           FROM UVKEYPP@LNK_LIMS
          WHERE seq = c_seq;
          
      -- Cursor to check if a pp_key name exists as sampletype groupkey
      CURSOR l_gkst_cursor(c_pp_key_name IN VARCHAR2) IS
         SELECT gk 
           FROM UVGKST@LNK_LIMS 
          WHERE LOWER(gk) = LOWER(c_pp_key_name);
   BEGIN
      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, a_part_no, a_revision, a_st, Pa_Lims.c_Msg_Started);
      
      -- Check if the API is called from the pa_limscfg package, or from the pa_limsspc package
      IF (a_part_no IS NULL) AND (a_revision IS NULL) AND (a_st IS NULL) THEN
         l_cfg := TRUE;
      END IF;
      
      IF g_pp_key_cache_id = a_part_no||'#'||a_revision||'#'||a_st THEN
         --pp keys are already initialised in the global variables for that
         --combination
         PA_LIMS.p_Trace(l_classname, l_method, 'pp_keys in cache OK', NULL, NULL, Pa_Lims.c_Msg_Ended);
         RETURN (TRUE);         
      END IF;
      g_pp_key_cache_id := NULL;
      
      -- Clear the global variables
      FOR i IN 1..5 LOOP
         g_pp_key_name(i) := NULL;
         g_pp_key(i) := ' ';
      END LOOP;
      g_linked_keys := ' ';
      
      -- Loop the 5 preferences containing the path for the pp_key value
      FOR i IN 1..5 LOOP
         ---------------------------
         -- Get the pp_key values --
         ---------------------------
         -- The values only have to be set when the api is called from the operational package
         IF (NOT l_cfg) THEN
            -- Initialize the variable
            l_value := NULL;
            -- Get the path
            FOR l_connect_rec IN l_connect_cursor(PA_LIMS.f_ActivePlant) LOOP
               l_path := PA_LIMS.f_GetPathValue(l_connect_rec.connect_string, i);
            END LOOP;

            -- If the pp_key has not been defined, the preference has been left empty.
            IF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_path, '0') = 1 THEN
               NULL;
            -- For pp_key product, the value is the sampletype. No path has to be followed to find this value, so the
            -- preference contains hardcoded 'sample type'.
            ELSIF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_path, 'sample type') = 1 THEN
               l_value := a_st;
            -- For pp_key plant, the pp_key has to be left empty. No path has to be followed to find a value, so the
            -- preference contains hardcoded 'plant'.
            ELSIF PA_LIMS_SPECX_TOOLS.COMPARE_STRING(l_path, 'plant') = 1 THEN
               NULL;
            -- For the other pp_keys, the path has to be followed to find the value.
            ELSE
               l_section_id     := SUBSTR(l_path, 1, INSTR(l_path,'#',1,1)-1);
               l_sub_section_id := SUBSTR(l_path, 
                                          INSTR(l_path,'#',1,1)+1,
                                          INSTR(l_path,'#',1,2)-(INSTR(l_path,'#',1,1)+1));
               l_property_group := SUBSTR(l_path, 
                                          INSTR(l_path,'#',1,2)+1,
                                          INSTR(l_path,'#',1,3)-(INSTR(l_path,'#',1,2)+1));
               l_property       := SUBSTR(l_path,
                                          INSTR(l_path,'#',1,3)+1,
                                          INSTR(l_path,'#',1,4)-(INSTR(l_path,'#',1,3)+1));
               l_column_name    := SUBSTR(l_path, INSTR(l_path,'#',1,4)+1);

               BEGIN
                  EXECUTE IMMEDIATE 'SELECT '||l_column_name||' FROM specification_prop'||
                                    ' WHERE part_no = :a_part_no'||
                                    ' AND revision = :a_revision'||
                                    ' AND section_id = :l_section_id'||
                                    ' AND sub_section_id = :l_sub_section_id'||
                                    ' AND property_group = :l_property_group'||
                                    ' AND property = :l_property'
                  INTO l_value
                  USING a_part_no, a_revision, l_section_id, l_sub_section_id, l_property_group, l_property;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     -- The specification is not a linked specification of this type, eg. it is not a customer specification
                     NULL;
                  WHEN OTHERS THEN
                     -- Log some error details error in ITERROR
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                           'Unable to set the parameterprofile keys (section_id="'||l_section_id||'" | sub_section_id="'||
                            l_sub_section_id||'"): '||SQLERRM);
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                           'Unable to set the parameterprofile keys (property_group="'||l_property_group||'" | property="'||
                            l_property||'"): '||SQLERRM);
                     PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                           'Unable to set the parameterprofile keys (column_name="'||l_column_name||'" | PA_LIMS.f_ActivePlant="'||PA_LIMS.f_ActivePlant||'"): '||SQLERRM);
                     RAISE;
               END;
               -- the pp_key gets its value by following a path of a linked specification => it is a "linked key"
               g_linked_keys := g_linked_keys||'#'||i;
            END IF;

            -- Fill the global variables for the pp_keys with the correct value.
            IF l_value IS NOT NULL THEN
               g_pp_key(i) := l_value;
            END IF;
         END IF;
         
         --------------------------
         -- Get the pp_key names --
         --------------------------
         -- Get the pp_key description
         FOR l_pp_key_rec IN l_pp_key_cursor(i) LOOP
            -- The sampletype groupkey name will be the pp_key description
            g_pp_key_name(i) := l_pp_key_rec.gk;
            -- Check if this pp_key description already exists as sampletype groupkey. If so,
            -- then the sampletype groupkey will be taken, to avoid errors due to upper-/lowercase.
            FOR l_gkst_rec IN l_gkst_cursor(g_pp_key_name(i)) LOOP
               g_pp_key_name(i) := l_gkst_rec.gk;
            END LOOP;
         END LOOP;
      END LOOP;
      
      g_pp_key_cache_id := a_part_no||'#'||a_revision||'#'||a_st;

      -- Tracing
      PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, Pa_Lims.c_Msg_Ended);
      RETURN (TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         -- Log an error in ITERROR
         PA_LIMS.p_Log(PA_LIMS.c_Source, PA_LIMS.c_Applic,
                       'Unable to set the parameterprofile keys (part_no="'||a_part_no||'" | revision="'||
                       a_revision||'"): '||SQLERRM);
         -- Tracing
         PA_LIMS.p_Trace(l_classname, l_method, NULL, NULL, NULL, PA_LIMS.c_Msg_Aborted);
         --reset for security
         g_pp_key_cache_id := NULL;
         RETURN (FALSE);
   END f_SetPpKeys;
   
   FUNCTION f_GetAttachedPartNo(
      a_part_no      IN VARCHAR2, 
      a_revision     IN VARCHAR2
   )
   RETURN VARCHAR2 IS
   
      l_attached_part_no      VARCHAR2(18);
      
      CURSOR l_LinkedSpec_Cursor(
         c_Part_No         specification_header.part_no%TYPE,
         c_Revision        specification_header.revision%TYPE,
         c_KwIdGenericSp   itkw.kw_id%TYPE
      )
      IS
         SELECT asp.attached_part_no
           FROM specification_kw spk, attached_specification asp
          WHERE spk.part_no = asp.attached_part_no
            AND kw_id = c_KwIdGenericSp
            AND asp.part_no = c_Part_No
         AND asp.revision = c_Revision;
   BEGIN
      
      l_attached_part_no := NULL;
      FOR l_LinkedSpec_Rec IN l_LinkedSpec_Cursor(a_Part_No, a_Revision, PA_LIMS.f_GetSettingValue('KW ID Generic Spc')) LOOP
         -- Indicate that it's a linked specification
         l_attached_part_no := l_LinkedSpec_Rec.attached_part_no;
         EXIT;
      END LOOP;
      RETURN(l_attached_part_no);
            
   END f_GetAttachedPartNo;

END PA_LIMS;
/
