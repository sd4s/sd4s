--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function DELETESC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."DELETESC" (avs_sc IN APAOGEN.API_NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'DeleteSc';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_sc(avs_sc IN VARCHAR2) IS
	SELECT 'DELETE FROM ' || b.owner || '.' || b.table_name || ' WHERE sc = ''' || avs_sc || '''' querie
	  FROM utsystem a, all_tab_columns b, all_tables c
	 WHERE UPPER(b.owner)        = UPPER(a.setting_value)
	   AND a.setting_name 		  = 'DBA_NAME'
		AND b.owner					  = c.owner
		AND b.table_name			  = c.table_name
		AND UPPER(b.column_name)  = 'SC';

lvi_ret_code	APAOGEN.RETURN_TYPE;
BEGIN

	FOR lvr_sc IN lvq_sc(avs_sc) LOOP
		lvi_ret_code := APAOGEN.ExecuteSQL(lvr_sc.querie, FALSE);
		IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
			--ROLLBACK;
			RETURN UNAPIGEN.DBERR_GENFAIL;
		END IF;
	END LOOP;

	RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;

END DeleteSc;
 

/
