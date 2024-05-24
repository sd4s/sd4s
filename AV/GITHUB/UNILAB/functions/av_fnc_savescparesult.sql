--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function SAVESCPARESULT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."SAVESCPARESULT" (avs_sc IN APAOGEN.API_NAME_TYPE,
                                           avs_pg IN APAOGEN.API_NAME_TYPE, avn_pgnode IN NUMBER,
                                           avs_pa IN APAOGEN.API_NAME_TYPE, avn_panode IN NUMBER,
                                           avf_value_f IN FLOAT, avs_value_s VARCHAR2,
                                           avs_unit IN VARCHAR2,
                                           avs_format IN VARCHAR2)
RETURN APAOGEN.RETURN_TYPE IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name CONSTANT APAOGEN.API_NAME_TYPE := 'FUNCTION SaveScPaResult';
  l_ret_code       INTEGER;
  l_row            INTEGER;     
  l_alarms_handled CHAR(1);
  l_nr_of_rows     NUMBER;
  -- SaveScPaResult
  l_sc_tab         UNAPIGEN.VC20_TABLE_TYPE;
  l_pg_tab         UNAPIGEN.VC20_TABLE_TYPE;
  l_pgnode_tab     UNAPIGEN.LONG_TABLE_TYPE;
  l_pa_tab         UNAPIGEN.VC20_TABLE_TYPE;
  l_panode_tab     UNAPIGEN.LONG_TABLE_TYPE;
  l_value_f_tab    UNAPIGEN.FLOAT_TABLE_TYPE;
  l_value_s_tab    UNAPIGEN.VC40_TABLE_TYPE;
  l_unit_tab       UNAPIGEN.VC20_TABLE_TYPE;
  l_format_tab     UNAPIGEN.VC40_TABLE_TYPE;
  l_exec_end_date_tab UNAPIGEN.DATE_TABLE_TYPE;
  l_executor_tab   UNAPIGEN.VC20_TABLE_TYPE;
  l_manually_entered_tab UNAPIGEN.CHAR1_TABLE_TYPE;
  l_reanalysis_tab UNAPIGEN.NUM_TABLE_TYPE;
  l_modify_flag_tab UNAPIGEN.NUM_TABLE_TYPE;
BEGIN 
  APAOGEN.LogError (lcs_function_name, 'Function invoked for sc '||avs_sc||', pa '||avs_pa||'.');
  IF LENGTH (avs_value_s) > 40 THEN
    APAOGEN.LogError (lcs_function_name, 'String value shortened from '||avs_value_s||' to '||SUBSTR (avs_value_s, 1, 40)||'.');
  END IF;
  SELECT reanalysis INTO l_reanalysis_tab (1) FROM utscpa WHERE sc = avs_sc AND pg = avs_pg AND pgnode = avn_pgnode AND pa = avs_pa AND panode = avn_panode;
  l_alarms_handled := '1';
  l_nr_of_rows     := 1;    
  FOR l_row IN 1..l_nr_of_rows LOOP
     l_sc_tab(l_row) := avs_sc;
     l_pg_tab(l_row) := avs_pg;
     l_pgnode_tab(l_row) := avn_pgnode;
     l_pa_tab(l_row) := avs_pa;
     l_panode_tab(l_row) := avn_panode;
     l_value_f_tab(l_row) := avf_value_f;
     l_value_s_tab(l_row) := SUBSTR (avs_value_s, 1, 40);
     l_unit_tab(l_row) := avs_unit;
     l_format_tab(l_row) := avs_format;
     l_exec_end_date_tab(l_row) := CURRENT_TIMESTAMP;
     l_executor_tab(l_row) := USER;
     l_manually_entered_tab(l_row) :=  '1';
     l_modify_flag_tab(l_row) := UNAPIGEN.MOD_FLAG_UPDATE;
  END LOOP;
  l_ret_code := UNAPIPA.SAVESCPARESULT
                   (l_alarms_handled,
                    l_sc_tab,
                    l_pg_tab,
                    l_pgnode_tab,
                    l_pa_tab,
                    l_panode_tab,
                    l_value_f_tab,
                    l_value_s_tab,
                    l_unit_tab,
                    l_format_tab,
                    l_exec_end_date_tab,
                    l_executor_tab,
                    l_manually_entered_tab,
                    l_reanalysis_tab,
                    l_modify_flag_tab,
                    l_nr_of_rows,
                    lcs_function_name);
     
  IF l_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
    APAOGEN.LogError (lcs_function_name, 'SaveScPaResult returned '||l_ret_code||'.');
  END IF;

  RETURN l_ret_code;
	
EXCEPTION
WHEN OTHERS THEN
   IF SQLCODE != 1 THEN
      APAOGEN.LogError (lcs_function_name, SQLERRM);
   END IF;
   RETURN SQLCODE;
END SaveScPaResult;

/
