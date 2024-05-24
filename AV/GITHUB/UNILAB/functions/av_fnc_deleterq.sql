--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function DELETERQ
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."DELETERQ" (avs_rq IN APAOGEN.API_NAME_TYPE)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'DeleteRq';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_rq(avs_rq IN VARCHAR2) IS
	SELECT 'DELETE FROM ' || b.owner || '.' || b.table_name || ' WHERE rq = ''' || avs_rq || '''' querie
	  FROM utsystem a, all_tab_columns b, all_tables c
	 WHERE UPPER(b.owner)        = UPPER(a.setting_value)
	   AND a.setting_name 		  = 'DBA_NAME'
		AND b.owner					  = c.owner
		AND b.table_name			  = c.table_name
		AND UPPER(b.column_name)  = 'RQ';

CURSOR lvq_sc(avs_sc IN VARCHAR2) IS
	SELECT 'DELETE FROM ' || b.owner || '.' || b.table_name || ' WHERE sc = ''' || avs_sc || '''' querie
	  FROM utsystem a, all_tab_columns b, all_tables c
	 WHERE UPPER(b.owner)        = UPPER(a.setting_value)
	   AND a.setting_name 		  = 'DBA_NAME'
		AND b.owner					  = c.owner
		AND b.table_name			  = c.table_name
		AND UPPER(b.column_name)  = 'SC';

CURSOR lvq_rqsc(avs_rq IN VARCHAR2) IS
   SELECT sc
	  FROM utsc
	 WHERE rq = avs_rq;

lvi_ret_code  		APAOGEN.RETURN_TYPE;
lvs_sc				VARCHAR2(20);

BEGIN

	FOR lvr_rq IN lvq_rq(avs_rq) LOOP
		 lvi_ret_code := APAOGEN.ExecuteSQL(lvr_rq.querie, FALSE);
		 IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
			ROLLBACK;
			RETURN UNAPIGEN.DBERR_GENFAIL;
		 END IF;
	END LOOP;
	FOR lvr_rqsc IN lvq_rqsc(avs_rq) LOOP
		FOR lvr_sc IN lvq_sc(lvr_rqsc.sc) LOOP
			 lvi_ret_code := APAOGEN.ExecuteSQL(lvr_sc.querie, FALSE);
			 IF lvi_ret_code != UNAPIGEN.DBERR_SUCCESS THEN
				ROLLBACK;
				RETURN UNAPIGEN.DBERR_GENFAIL;
			 END IF;
		END LOOP;
	END LOOP;

	RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;

END DeleteRq;
 

/
