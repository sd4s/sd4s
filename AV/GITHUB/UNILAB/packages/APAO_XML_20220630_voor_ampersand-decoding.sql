CREATE OR REPLACE PACKAGE        APAO_XML AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_XML
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 03/11/2010
--   TARGET : Oracle 10.2.0 / Unilab 6.1 sp1
--  VERSION : av2.2
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 03/11/2010 | RS        | Created
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
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION WriteToXML
RETURN NUMBER;

FUNCTION WriteToXML(avs_sc IN VARCHAR2)
RETURN NUMBER;

FUNCTION WriteToXML( avs_uc     IN VARCHAR2,
                     avs_query  IN VARCHAR2)
RETURN NUMBER;

FUNCTION WriteToXML(avs_directory IN VARCHAR2,
                    avs_filename  IN VARCHAR2,
                    avs_query     IN VARCHAR2)
RETURN NUMBER;

END APAO_XML;

/


CREATE OR REPLACE PACKAGE BODY        APAO_XML AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_XML
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 03/11/2010
--   TARGET : Oracle 10.2.0 / Unilab 6.3
--  VERSION : av3.0
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 03/11/2010 | RS        | Created
-- 03/03/2011 | RS        | Upgrade V6.3
--                        | Changed SYSDATE INTO CURRENT_TIMESTAMP
--                        | Changed DATE; INTO TIMESTAMP WITH TIME ZONE;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name                 CONSTANT VARCHAR2(20) := 'APAO_XML';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
FUNCTION ClobToFile ( avs_directory IN VARCHAR2,
                      avs_filename  IN VARCHAR2,
                      avc_clob      IN CLOB )
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name||'.'||'ClobToFile';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm      VARCHAR2(255);
lvi_ret_code     NUMBER;
c_amount         CONSTANT BINARY_INTEGER := 32767;
l_buffer         VARCHAR2(32767);
l_chr10          PLS_INTEGER;
l_clobLen        PLS_INTEGER;
l_fHandler       UTL_FILE.FILE_TYPE;
l_pos            PLS_INTEGER    := 1;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN

   l_clobLen  := DBMS_LOB.GETLENGTH(avc_clob);
   l_fHandler := UTL_FILE.FOPEN(avs_directory, avs_filename,'W',c_amount);

   WHILE l_pos < l_clobLen LOOP
      l_buffer := DBMS_LOB.SUBSTR(avc_clob, c_amount, l_pos);
      EXIT WHEN l_buffer IS NULL;
      l_chr10  := INSTR(l_buffer,CHR(10),-1);
      IF l_chr10 != 0 THEN
         l_buffer := SUBSTR(l_buffer,1,l_chr10-1);
      END IF;
      UTL_FILE.PUT_LINE(l_fHandler, l_buffer,TRUE);
      l_pos := l_pos + LEAST(LENGTH(l_buffer)+1,c_amount);
   END LOOP;

   UTL_FILE.FCLOSE(l_fHandler);
   RETURN UNAPIGEN.DBERR_SUCCESS;

EXCEPTION
WHEN OTHERS THEN
   IF UTL_FILE.IS_OPEN(l_fHandler) THEN
      UTL_FILE.FCLOSE(l_fHandler);
   END IF;
   IF SQLCODE != 1 THEN
      UNAPIGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;

END ClobToFile;

FUNCTION GenerateNextCodemask (avs_uc IN  VARCHAR2)
RETURN VARCHAR2 IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name||'.'||'GenerateNextCodemask';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  VARCHAR2(255);
lvi_ret_code NUMBER;

lvi_seq          NUMBER := 0;

lvs_st           VARCHAR2(20);
lvs_st_version   VARCHAR2(20);
lvs_rt           VARCHAR2(20);
lvs_rt_version   VARCHAR2(20);
lvs_rq           VARCHAR2(20);
lvd_ref_date     TIMESTAMP WITH TIME ZONE;
lvs_next_val     VARCHAR2(255);
lvs_edit_allowed CHAR(1);
lvs_valid_cf     VARCHAR2(20);
lvs_uc           VARCHAR2(20);
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   lvs_uc := avs_uc;
   lvs_st := '';
   lvs_st_version := '';
   lvs_rt := '';
   lvs_rt_version := '';
   lvs_rq := '';
   lvd_ref_date := CURRENT_TIMESTAMP;

   lvi_ret_code := UNAPIUC.CREATENEXTUNIQUECODEVALUE
                   (lvs_uc,
                    lvs_st,
                    lvs_st_version,
                    lvs_rt,
                    lvs_rt_version,
                    lvs_rq,
                    lvd_ref_date,
                    lvs_next_val,
                    lvs_edit_allowed,
                    lvs_valid_cf);

   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
      lvs_sqlerrm := 'GenerateNextCodemask failed for <' || avs_uc || '>. Returncode <' || lvi_ret_code || '>';
      --UNAPIGEN.LogError(lcs_function_name, lvs_sqlerrm);
      --RETURN NULL;
   END IF;

   RETURN lvs_next_val;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      UNAPIGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN SQLCODE;
END GenerateNextCodemask;


FUNCTION WriteToXML
RETURN NUMBER IS
   --------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name||'.'||'WriteToXML(1)';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm      VARCHAR2(255);
lvi_ret_code     NUMBER;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN

   lvi_ret_code := WriteToXML( UNAPIEV.P_SC);
   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      UNAPIGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;

END WriteToXML;

FUNCTION WriteToXML(avs_sc IN VARCHAR2)
RETURN NUMBER IS
   --------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name||'.'||'WriteToXML(2)';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm      VARCHAR2(255);
lvi_ret_code     NUMBER;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN
   lvi_ret_code := WriteToXML( 'XML',
                               'SELECT * FROM avao_sc_xml WHERE sc = ''' || avs_sc || '''');
   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      UNAPIGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;

END WriteToXML;


FUNCTION WriteToXML( avs_uc     IN VARCHAR2,
                     avs_query  IN VARCHAR2)
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name||'.'||'WriteToXML(3)';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm      VARCHAR2(255);
lvi_ret_code     NUMBER;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN

   lvi_ret_code := WriteToXML( 'XML_OUT',
                               GenerateNextCodemask(avs_uc),
                               avs_query);
   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      UNAPIGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;

END WriteToXML;

FUNCTION WriteToXML(avs_directory IN VARCHAR2,
                    avs_filename  IN VARCHAR2,
                    avs_query     IN VARCHAR2)
RETURN NUMBER IS
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT VARCHAR2(40) := ics_package_name||'.'||'WriteToXML(4)';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm      VARCHAR2(255);
lvi_ret_code     NUMBER;
queryCtx         dbms_xmlstore.ctxType;
ctx              dbms_xmlstore.ctxHandle;
lv_xml_clob      CLOB;
lv_clob_len      PLS_INTEGER;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN
   ctx := dbms_xmlgen.newContext(avs_query);
   dbms_xmlgen.setRowTag(ctx, 'SC');
   dbms_xmlgen.setRowSetTag(ctx, 'SCLS');
   dbms_xmlgen.setNullHandling(ctx, dbms_xmlgen.EMPTY_TAG);
   lv_xml_clob := dbms_xmlgen.getXML(ctx);
   lv_clob_len := dbms_lob.getlength(lv_xml_clob);
   lvi_ret_code := ClobToFile( avs_directory,
                               avs_filename,
                               lv_xml_clob);
   dbms_xmlgen.closeContext(ctx);
   RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      UNAPIGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN UNAPIGEN.DBERR_GENFAIL;

END WriteToXML;


END APAO_XML;
/
