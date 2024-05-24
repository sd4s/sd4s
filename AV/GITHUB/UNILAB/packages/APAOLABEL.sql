CREATE OR REPLACE PACKAGE APAOLABEL AS
--------------------------------------------------------------------------------
--  PROJECT : NVI koppeling Unilab -> Labelview
-------------------------------------------------------------------------------
--  PACKAGE : APAOLABEL
-- ABSTRACT : This package is for generating a file for Labelview
--------------------------------------------------------------------------------
--   WRITER : R.Sparenberg
--     DATE : 24-10-2007
--   TARGET :
--  VERSION : 6.1   $Revision: 0 $
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 24/10/2007 | RS        | Created
-- 27/11/2007 | RS        | Added argument automatic
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions and/or procedures
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- package initialization-code
--------------------------------------------------------------------------------
FUNCTION Openfile(avs_path     IN VARCHAR2,
                  avs_filename IN VARCHAR2,
                  avb_new_file IN BOOLEAN := TRUE)
RETURN UTL_FILE.FILE_TYPE;

FUNCTION Closefile(avi_handle IN OUT UTL_FILE.FILE_TYPE)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION Writeline(avi_handle IN UTL_FILE.FILE_TYPE,
                   avs_line   IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE;

END APAOLABEL;

/


CREATE OR REPLACE PACKAGE BODY        APAOLABEL AS
--------------------------------------------------------------------------------
-- FUNCTION : Openfile
-- ABSTRACT : Function that opens a file and return the file_handle
--------------------------------------------------------------------------------
--   WRITER : A.F Kok
-- REVIEWER :
--     DATE : 25/04/2003
--   TARGET :
--  VERSION : 4.2.2.1.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- 25/04/2003 | AF        | Created
--------------------------------------------------------------------------------
ics_package_name          CONSTANT APAOGEN.API_NAME_TYPE := 'APAOLABEL';

FUNCTION Openfile(avs_path     IN VARCHAR2,
                  avs_filename IN VARCHAR2,
                  avb_new_file IN BOOLEAN := TRUE)
RETURN UTL_FILE.FILE_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'Openfile';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;

lvi_handle   UTL_FILE.FILE_TYPE;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   -----------------------------------------------------------------------------
   -- Make a new file or open a existing file
   -----------------------------------------------------------------------------
   IF avb_new_file THEN
      --------------------------------------------------------------------------
      -- Make new file
      --------------------------------------------------------------------------
      lvi_handle := UTL_FILE.FOPEN (avs_path, avs_filename, 'W' );
   ELSE
      --------------------------------------------------------------------------
      -- Open file to add lines
      --------------------------------------------------------------------------
      lvi_handle := UTL_FILE.FOPEN (avs_path, avs_filename, 'A' );
   END IF;

   RETURN lvi_handle;

EXCEPTION
   WHEN UTL_FILE.INVALID_PATH THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Invalid path: <' || avs_path || '>';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN lvi_handle;
   WHEN UTL_FILE.INVALID_MODE THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Invalid mode';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN lvi_handle;
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Invalid filehandle';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN lvi_handle;
   WHEN UTL_FILE.INVALID_OPERATION THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Invalid operation';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN lvi_handle;
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Internal error';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN lvi_handle;
   WHEN OTHERS THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := SUBSTR (SQLERRM, 1, 255);
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN lvi_handle;
END OpenFile;

--------------------------------------------------------------------------------
-- FUNCTION : Closefile
-- ABSTRACT : Function that closes a log file and clears the variable
--------------------------------------------------------------------------------
--   WRITER : A.F. Kok
-- REVIEWER :
--     DATE : 25/04/2003
--   TARGET :
--  VERSION : 4.2.2.1.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- 25/04/2003 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION Closefile(avi_handle IN OUT UTL_FILE.FILE_TYPE)
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'Closefile';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN

   -----------------------------------------------------------------------------
   -- Close the opened file
   -----------------------------------------------------------------------------
   UTL_FILE.FCLOSE (avi_handle);

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
   WHEN UTL_FILE.INVALID_MODE THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Invalid mode';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Invalid filehandle';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
   WHEN UTL_FILE.INVALID_OPERATION THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Invalid operation';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Internal error';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
   WHEN OTHERS THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := SUBSTR (SQLERRM, 1, 255);
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
END CloseFile;

--------------------------------------------------------------------------------
-- FUNCTION : WriteLine
-- ABSTRACT : Function that writes a message to a log file
--------------------------------------------------------------------------------
--   WRITER : A.F. Kok
-- REVIEWER :
--     DATE : 25/04/2003
--   TARGET :
--  VERSION : 4.2.2.1.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- 25/04/2003 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION Writeline(avi_handle IN UTL_FILE.FILE_TYPE,
                   avs_line   IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'WriteLine';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_ret_code APAOGEN.RETURN_TYPE;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN

   IF avs_line IS NOT NULL THEN
       DBMS_OUTPUT.PUT_LINE(avs_line);
       UTL_FILE.PUT_LINE (avi_handle, avs_line);
   END IF;

   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
   WHEN UTL_FILE.INVALID_MODE THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Invalid mode';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
   WHEN UTL_FILE.INVALID_FILEHANDLE THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Invalid filehandle';
      --------------------------------------------------------------------------------
        -- Do not log this error, it may occur if there are no small labels
        --------------------------------------------------------------------------------
        --UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
   WHEN UTL_FILE.INVALID_OPERATION THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Invalid operation';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
   WHEN UTL_FILE.READ_ERROR THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Read error';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
   WHEN UTL_FILE.WRITE_ERROR THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Write error';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
   WHEN UTL_FILE.INTERNAL_ERROR THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := 'Internal error';
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
   WHEN OTHERS THEN
      UTL_FILE.FCLOSE_ALL;
      lvs_sqlerrm  := SUBSTR (SQLERRM, 1, 255);
      UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
      RETURN SQLCODE;
END WriteLine;

END APAOLABEL;
/
