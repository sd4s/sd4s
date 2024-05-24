CREATE OR REPLACE PACKAGE        APAO_CONVERSION AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_CONVERSION
-- ABSTRACT :
--   WRITER : Jan Roubos
--     DATE : 22/09/2016
--   TARGET : -
--  VERSION : -
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 22/09/2016 | JR        | Created
---------------------------------------------------------------------------------------------------------------------

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
FUNCTION ERULG501
	(avs_from IN VARCHAR2,
	 avs_to   IN VARCHAR2,
	 avi_max  IN NUMBER,
	 avb_details IN BOOLEAN)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ERULG502
	(avs_from IN VARCHAR2,
	 avs_to   IN VARCHAR2,
	 avi_max  IN NUMBER,
	 avb_details IN BOOLEAN)
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ERULG504
RETURN APAOGEN.RETURN_TYPE;

FUNCTION ERULG505
RETURN APAOGEN.RETURN_TYPE;

FUNCTION MDR_TestMethod
	(avs_from IN VARCHAR2,
	 avs_to   IN VARCHAR2,
	 avi_max  IN NUMBER,
	 avb_details IN BOOLEAN)
RETURN APAOGEN.RETURN_TYPE;

END APAO_CONVERSION;
/


CREATE OR REPLACE PACKAGE BODY        APAO_CONVERSION AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_CONVERSION
-- ABSTRACT :
--   WRITER : Jan Roubos
--     DATE : 22/09/2016
--   TARGET : -
--  VERSION : -
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 22/09/2016 | JR        | Created
-- 22/12/2016 | JR        | Changed ERULG501, equipment type if no current than use highest version
-- 22/12/2016 | JR        | Changed ERULG501, equipment type may also be NULL
-- 05/01/2017 | JR        | Changed ERULG501, equipment type may be NULL, but not in the specific GK table
-- 15/06/2017 | JR        | Added MDR_TestMethod
-- 22/06/2017 | JR        | Chanaged MDR_TestMethod, use of the API generated a lot of events (>215000)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
ics_package_name          CONSTANT VARCHAR2(20) := 'APAO_CONVERSION';
DBERR_OBJECTNOTFOUND     CONSTANT INTEGER := 337;    -- DBERR_OBJECTNOTFOUND (337, found in IAPICONSTANTDBERROR)
lvi_seq					NUMBER;


PROCEDURE LOGCONVERSION
	(avs_conversion		IN VARCHAR2,
	 avs_object_tp      IN VARCHAR2,
     avs_object_id 		IN VARCHAR2,
	 avs_old			IN VARCHAR2,
	 avs_new			IN VARCHAR2,
	 avs_message		IN VARCHAR2) IS
--PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	lvi_seq := lvi_seq + 1;
	INSERT INTO atao_conversion_log (logdate, sequence, conversion, object_tp, object_id, old, new, message)
	VALUES (CURRENT_TIMESTAMP, lvi_seq, avs_conversion, avs_object_tp, avs_object_id, avs_old, avs_new, avs_message);
--	COMMIT;
END LOGCONVERSION;

----------------------------------------------------------------------------------------
-- ERULG501 Update operational environment with ME groupkeys “user_group” en “equipment_type”
----------------------------------------------------------------------------------------
FUNCTION ERULG501
	(avs_from IN VARCHAR2,
	 avs_to   IN VARCHAR2,
	 avi_max  IN NUMBER,
	 avb_details IN BOOLEAN)
RETURN APAOGEN.RETURN_TYPE IS
    lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ERULG501';
    lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
    lvi_ret_code        NUMBER;
	lvi_count			NUMBER;
	lvi_nr_of_rows      INTEGER := 0;
	lvi_counter			INTEGER := 0;
    lvsError            VARCHAR2(255) := NULL;
    lvn_total           NUMBER;
	lvs_lab 			VARCHAR2(20);
	lvb_found			BOOLEAN;
	lvt_value_tab       UNAPIGEN.VC40_TABLE_TYPE;
	lvs_eq_tp			VARCHAR2(20);
	lvs_gk				VARCHAR2(20);
	lvs_gk_version      UTGKME.version%TYPE;
	l_previous_allow_modify_check  CHAR(1);
	StpError            EXCEPTION;

    CURSOR lvq_conv IS
      SELECT *
          FROM atao_conversion
         WHERE type = 'ERULG501'
		   AND enabled = '1'
		   ORDER BY rulenr;

-- Detmine the ME's which do not have a ME gk user_group
CURSOR lvq_user_group IS
	SELECT t1.sc, pg, pgnode, pa, panode, me, menode
	  FROM utscmegk t1
		 , utsc t2
		WHERE t2.creation_date BETWEEN TO_DATE(avs_from,'DD-MM-YYYY')
							   	   AND TO_DATE(avs_to,'DD-MM-YYYY')
		AND t2.sc = t1.sc
	MINUS
	SELECT sc, pg, pgnode, pa, panode, me, menode
	  FROM utscmegkuser_group
	ORDER BY sc, pg, pgnode, pa, panode, me, menode;

-- Detmine the ME's which do not have a ME gk equipment_type
CURSOR lvq_equipment_type IS
	SELECT t1.sc, pg, pgnode, pa, panode, me, menode
	  FROM utscmegk t1
		 , utsc t2
		WHERE t2.creation_date BETWEEN TO_DATE(avs_from,'DD-MM-YYYY')
							   	   AND TO_DATE(avs_to,'DD-MM-YYYY')
		AND t2.sc = t1.sc
	MINUS
	SELECT sc, pg, pgnode, pa, panode, me, menode
	  FROM utscmegkequipment_type
	MINUS
	SELECT t1.sc, pg, pgnode, pa, panode, me, menode
	  FROM utscmegk t1
		 , utsc t2
		WHERE t2.creation_date BETWEEN TO_DATE(avs_from,'DD-MM-YYYY')
							   	   AND TO_DATE(avs_to,'DD-MM-YYYY')
		AND t2.sc = t1.sc
		AND t1.gk = 'Equipment_type'
		AND t1.value IS NULL
	ORDER BY sc, pg, pgnode, pa, panode, me, menode;

CURSOR lvq_count IS
	SELECT DISTINCT lab, count(*) as total
	 FROM utscme t1
		, utsc t2
		WHERE t2.creation_date BETWEEN TO_DATE(avs_from,'DD-MM-YYYY')
							   	   AND TO_DATE(avs_to,'DD-MM-YYYY')
		AND t2.sc = t1.sc
        GROUP BY lab;


BEGIN
	SELECT MAX(sequence)
	  INTO lvi_seq
	  FROM atao_conversion_log;

	IF lvi_seq IS NULL THEN
		lvi_seq := 0;
	END IF;

	lvi_count := 0;
	lvi_ret_code := UNILAB.APAOACTION.SETCONNECTION;

	logconversion('ERULG501', '-','-','-','-','Start from ' || avs_from || ' until ' || avs_to || ' max updates = ' || avi_max || ' - '|| lcs_function_name);
	SELECT count(*) as total
	  INTO lvn_total
	  FROM utscme t1
		 , utsc t2
		WHERE t2.creation_date BETWEEN TO_DATE(avs_from,'DD-MM-YYYY')
							   	   AND TO_DATE(avs_to,'DD-MM-YYYY')
		AND t2.sc = t1.sc;
		logconversion('ERULG501', '-','-','-','-','Totaal PRE: ' || to_char(lvn_total));

		FOR lvr_conv IN lvq_conv LOOP
		logconversion('ERULG501', '-','-','-','-','Start for ' || lvr_conv.old);

		FOR lvr_count IN lvq_count LOOP
			logconversion('ERULG501', '-','-',lvr_conv.old || '-PRE','-','Lab : ' || lvr_count.lab || ' total in period: ' || lvr_count.total);
		END LOOP;

		IF (lvr_conv.old = 'user_group') THEN
			lvi_count	:= 0;
			lvs_gk := 'user_group';

			FOR lvr_user_group IN lvq_user_group LOOP
				--lvi_ret_code := UNAPIGEN.BEGINTRANSACTION();
				lvi_nr_of_rows := 0;

				 FOR r IN (SELECT executor AS user_group /*CR1 role*/
							FROM utmt
							WHERE mt = lvr_user_group.me
							  AND version_is_current = 1
							UNION
							SELECT value AS user_group /*CR1 role*/
							FROM utadau
							WHERE au = 'parent_group' /*CR1 'parent_role' role*/
							  AND ad IN (SELECT executor AS user_group /*CR1 role*/
										 FROM utmt
										 WHERE mt = lvr_user_group.me
										   AND version_is_current = 1)) LOOP
					 lvi_nr_of_rows := lvi_nr_of_rows + 1;
					 lvt_value_tab (lvi_nr_of_rows) := r.user_group; /*CR1 r.role*/
				  END LOOP;

				 IF lvi_nr_of_rows > 0 THEN

					FOR counter IN 1..lvi_nr_of_rows LOOP
						BEGIN
							INSERT INTO utscmegk (sc, pg, pgnode, pa, panode, me, menode, gk, gk_version, gkseq, value)
								VALUES 	(lvr_user_group.sc,
										lvr_user_group.pg,lvr_user_group.pgnode,
										lvr_user_group.pa,lvr_user_group.panode,
										lvr_user_group.me,lvr_user_group.menode,
										lvs_gk, lvs_gk_version, 499 + counter, lvt_value_tab(counter));

							INSERT INTO utscmegkuser_group (user_group, sc, pg, pgnode, pa, panode, me, menode)
							   VALUES (lvt_value_tab(counter), lvr_user_group.sc,
										lvr_user_group.pg,lvr_user_group.pgnode,
										lvr_user_group.pa,lvr_user_group.panode,
										lvr_user_group.me,lvr_user_group.menode);

							IF avb_details THEN
									logconversion('ERULG501', 'me',lvr_user_group.sc,lvr_conv.old,'-', '#sc=' || lvr_user_group.sc ||
								  '#pg=' || lvr_user_group.pg || '#pgnode=' || TO_CHAR(lvr_user_group.pgnode) ||
								  '#pa=' || lvr_user_group.pa || '#panode=' || TO_CHAR(lvr_user_group.panode) ||
								  '#me=' || lvr_user_group.me || '#menode=' || TO_CHAR(lvr_user_group.menode) ||
								  '#gk=' || lvs_gk ||' SAVED');
							END IF;
						EXCEPTION
							WHEN OTHERS THEN
							IF SQLCODE != 1 THEN
								lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
								logconversion('ERULG501', 'me',lvr_user_group.sc,lvr_conv.old,'ERR', lvs_sqlerrm);
							END IF;
						END;
					END LOOP;

					lvi_count := lvi_count + 1;
					IF lvi_count >= avi_max THEN
						EXIT;
					END IF;
				ELSE
					logconversion('ERULG501', 'me',lvr_user_group.sc,lvr_conv.old,'-', 'UserGroup could not be determined for ' || lvr_user_group.me);
				END IF;
				--lvi_ret_code := UNAPIGEN.ENDTRANSACTION();
				COMMIT;
			END LOOP;
			logconversion('ERULG501', '-','-','-','-', lvi_count || ' records processed');
		ELSIF (lvr_conv.old = 'equipment_type') THEN
			lvi_count	:= 0;
			lvs_gk := 'Equipment_type';

			FOR lvr_equipment_type IN lvq_equipment_type LOOP
				BEGIN
					SELECT eq_tp
					INTO lvs_eq_tp
					  FROM utmt
					  WHERE mt = lvr_equipment_type.me
					  AND version_is_current = '1';
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
					BEGIN
						SELECT eq_tp
						  INTO lvs_eq_tp
						  FROM utmt
						  WHERE mt = lvr_equipment_type.me
							AND version = (
						  SELECT MAX(version)
						  FROM utmt
						  WHERE mt = lvr_equipment_type.me);
					EXCEPTION
						WHEN NO_DATA_FOUND THEN
						logconversion('ERULG501', 'me',lvr_equipment_type.sc,lvr_conv.old,'ERR', 'No current equipmenttype for: ' || lvr_equipment_type.me);
						lvs_eq_tp := NULL;
					END;
				END;

				--IF (lvs_eq_tp IS NOT NULL) THEN
					BEGIN
						INSERT INTO utscmegk (sc, pg, pgnode, pa, panode, me, menode, gk, gk_version, gkseq, value)
							VALUES 	(lvr_equipment_type.sc,
									lvr_equipment_type.pg,lvr_equipment_type.pgnode,
									lvr_equipment_type.pa,lvr_equipment_type.panode,
									lvr_equipment_type.me,lvr_equipment_type.menode,
									lvs_gk, lvs_gk_version, 500, lvs_eq_tp);

						IF (lvs_eq_tp IS NOT NULL) THEN
							-- 05/01/2017, JR, the specific GK table can not contain NULL values
							INSERT INTO utscmegkequipment_type (equipment_type, sc, pg, pgnode, pa, panode, me, menode)
							   VALUES (lvs_eq_tp, lvr_equipment_type.sc,
										lvr_equipment_type.pg,lvr_equipment_type.pgnode,
										lvr_equipment_type.pa,lvr_equipment_type.panode,
										lvr_equipment_type.me,lvr_equipment_type.menode);
						END IF;

						IF avb_details THEN
								logconversion('ERULG501', 'me',lvr_equipment_type.sc,lvr_conv.old,'-', '#sc=' || lvr_equipment_type.sc ||
							  '#pg=' || lvr_equipment_type.pg || '#pgnode=' || TO_CHAR(lvr_equipment_type.pgnode) ||
							  '#pa=' || lvr_equipment_type.pa || '#panode=' || TO_CHAR(lvr_equipment_type.panode) ||
							  '#me=' || lvr_equipment_type.me || '#menode=' || TO_CHAR(lvr_equipment_type.menode) ||
							  '#gk=' || lvs_gk ||' SAVED');
						END IF;
					EXCEPTION
						WHEN OTHERS THEN
						IF SQLCODE != 1 THEN
							lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
							logconversion('ERULG501', 'me',lvr_equipment_type.sc,lvr_conv.old,'ERR', lvs_sqlerrm);
						END IF;
					END;

					lvi_count := lvi_count + 1;
					IF lvi_count >= avi_max THEN
						logconversion('ERULG501', '-','-',lvr_conv.old,'-', lvi_count || ' records processed');
						EXIT;
					END IF;
				--END IF;
			END LOOP;
			COMMIT;

		ELSE
			logconversion('ERULG501', '-','-','-','-','ERROR' || lvr_conv.old || ' unknown');
		END IF;

		FOR lvr_count IN lvq_count LOOP
			logconversion('ERULG501', '-','-',lvr_conv.old || '-POST','-','Lab : ' || lvr_count.lab || ' total in period: ' || lvr_count.total);
		END LOOP;

	END LOOP;
		SELECT count(*) as total
	  INTO lvn_total
	  FROM utscme t1
		 , utsc t2
		WHERE t2.creation_date BETWEEN TO_DATE(avs_from,'DD-MM-YYYY')
							   	   AND TO_DATE(avs_to,'DD-MM-YYYY')
		AND t2.sc = t1.sc;
		logconversion('ERULG501', '-','-','-','-','Totaal POST: ' || to_char(lvn_total));

	logconversion('ERULG501', '-','-','-','-','End   ' || lcs_function_name);

  RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END ERULG501;


----------------------------------------------------------------------------------------
-- ERULG502 Update existing operational methods with me-lab “Enschede”
----------------------------------------------------------------------------------------
FUNCTION ERULG502
	(avs_from IN VARCHAR2,
	 avs_to   IN VARCHAR2,
	 avi_max  IN NUMBER,
	 avb_details IN BOOLEAN)
RETURN APAOGEN.RETURN_TYPE IS
    lcs_function_name   CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ERULG502';
    lvs_sqlerrm         APAOGEN.ERROR_MSG_TYPE;
    lvi_ret_code        NUMBER;
	lvi_count			NUMBER;

    CURSOR lvq_conv IS
      SELECT *
          FROM atao_conversion
         WHERE type = 'ERULG502'
		   AND enabled = '1'
		   ORDER BY rulenr;


	CURSOR lvq_me (avs_planned_executor IN VARCHAR2
				 , avs_lab 				IN VARCHAR2) IS
	    SELECT t1.sc, pg, pgnode, pa, panode, me, menode, planned_executor, lab
		  FROM utscme t1
		     , utsc t2
		WHERE t2.creation_date BETWEEN TO_DATE(avs_from,'DD-MM-YYYY')
							   	   AND TO_DATE(avs_to,'DD-MM-YYYY')
		AND t2.sc = t1.sc
		AND t1.lab <> avs_lab
		AND planned_executor = avs_planned_executor;


    lvsError            VARCHAR2(255) := NULL;
    lvn_total           NUMBER;
	lvs_lab 			VARCHAR2(20);
	lvb_found			BOOLEAN;

  -- Specific local variables
  l_modify_reason  VARCHAR2(255);
  l_nr_of_rows                NUMBER;
  l_where_clause              VARCHAR2(511);
  l_sc_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_pg_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_pgnode_tab                UNAPIGEN.LONG_TABLE_TYPE;
  l_pa_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_panode_tab                UNAPIGEN.LONG_TABLE_TYPE;
  l_me_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_menode_tab                UNAPIGEN.LONG_TABLE_TYPE;
  l_reanalysis_tab            UNAPIGEN.NUM_TABLE_TYPE;
  l_mt_version_tab            UNAPIGEN.VC20_TABLE_TYPE;
  l_description_tab           UNAPIGEN.VC40_TABLE_TYPE;
  l_value_f_tab               UNAPIGEN.FLOAT_TABLE_TYPE;
  l_value_s_tab               UNAPIGEN.VC40_TABLE_TYPE;
  l_unit_tab                  UNAPIGEN.VC20_TABLE_TYPE;
  l_exec_start_date_tab       UNAPIGEN.DATE_TABLE_TYPE;
  l_exec_end_date_tab         UNAPIGEN.DATE_TABLE_TYPE;
  l_executor_tab              UNAPIGEN.VC20_TABLE_TYPE;
  l_lab_tab                   UNAPIGEN.VC20_TABLE_TYPE;
  l_eq_tab                    UNAPIGEN.VC20_TABLE_TYPE;
  l_eq_version_tab            UNAPIGEN.VC20_TABLE_TYPE;
  l_planned_executor_tab      UNAPIGEN.VC20_TABLE_TYPE;
  l_planned_eq_tab            UNAPIGEN.VC20_TABLE_TYPE;
  l_planned_eq_version_tab    UNAPIGEN.VC20_TABLE_TYPE;
  l_manually_entered_tab      UNAPIGEN.CHAR1_TABLE_TYPE;
  l_allow_add_tab             UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_assign_date_tab           UNAPIGEN. DATE_TABLE_TYPE;
  l_assigned_by_tab           UNAPIGEN.VC20_TABLE_TYPE;
  l_manually_added_tab        UNAPIGEN.CHAR1_TABLE_TYPE;
  l_delay_tab                 UNAPIGEN.NUM_TABLE_TYPE;
  l_delay_unit_tab            UNAPIGEN.VC20_TABLE_TYPE;
  l_format_tab                UNAPIGEN.VC40_TABLE_TYPE;
  l_accuracy_tab              UNAPIGEN.FLOAT_TABLE_TYPE;
  l_real_cost_tab             UNAPIGEN.VC40_TABLE_TYPE;
  l_real_time_tab             UNAPIGEN.VC40_TABLE_TYPE;
  l_calibration_tab           UNAPIGEN. CHAR1_TABLE_TYPE;
  l_confirm_complete_tab      UNAPIGEN.CHAR1_TABLE_TYPE;
  l_autorecalc_tab            UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_me_result_editable_tab    UNAPIGEN.CHAR1_TABLE_TYPE;
  l_next_cell_tab             UNAPIGEN.VC20_TABLE_TYPE;
  l_sop_tab                   UNAPIGEN.VC40_TABLE_TYPE;
  l_sop_version_tab           UNAPIGEN.VC20_TABLE_TYPE;
  l_plaus_low_tab             UNAPIGEN.FLOAT_TABLE_TYPE;
  l_plaus_high_tab            UNAPIGEN.FLOAT_TABLE_TYPE;
  l_winsize_x_tab             UNAPIGEN.NUM_TABLE_TYPE;
  l_winsize_y_tab             UNAPIGEN.NUM_TABLE_TYPE;
  l_me_class_tab              UNAPIGEN.VC2_TABLE_TYPE;
  l_log_hs_tab                UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_log_hs_details_tab        UNAPIGEN.CHAR1_TABLE_TYPE;
  l_allow_modify_tab          UNAPIGEN.CHAR1_TABLE_TYPE;
  l_ar_tab                    UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_active_tab                UNAPIGEN.  CHAR1_TABLE_TYPE;
  l_lc_tab                    UNAPIGEN.VC2_TABLE_TYPE;
  l_lc_version_tab            UNAPIGEN.VC20_TABLE_TYPE;
  l_ss_tab                    UNAPIGEN.VC2_TABLE_TYPE;
  l_reanalysedresult_tab      UNAPIGEN.CHAR1_TABLE_TYPE;
  l_modify_flag_tab UNAPIGEN.NUM_TABLE_TYPE;
  l_alarms_handled            CHAR(1);
BEGIN
	SELECT MAX(sequence)
	  INTO lvi_seq
	  FROM atao_conversion_log;

	IF lvi_seq IS NULL THEN
		lvi_seq := 0;
	END IF;

	lvi_count := 0;
	lvi_ret_code := UNILAB.APAOACTION.SETCONNECTION;

	logconversion('ERULG502', '-','-','-','-','Start from ' || avs_from || ' until ' || avs_to || ' max updates = ' || avi_max || ' - '|| lcs_function_name);
	FOR lvr_conv IN lvq_conv LOOP
		logconversion('ERULG502', '-','-','-','-','Start for ' || lvr_conv.old);
		lvb_found := TRUE;
		BEGIN
		   select pref_value
			 into lvs_lab
			 from utupuspref a, utad b
			where a.pref_name = 'lab' and a.up = b.def_up and a.us = b.ad
			  and a.us = lvr_conv.old;
		EXCEPTION
		   WHEN OTHERS THEN
			  logconversion('ERULG502', '-','-','-','-',lvr_conv.old || ' has no lab set, so we skip');
			  lvb_found := FALSE;
		END;

		IF lvb_found THEN
			FOR lvr_me IN lvq_me(lvr_conv.old, lvs_lab) LOOP
			    --lvi_ret_code := UNAPIGEN.BEGINTRANSACTION();

				-- IN and IN OUT arguments
				 l_alarms_handled := '1';
				 l_modify_reason := 'ERULG0502 update me lab';
				 l_where_clause   := 'WHERE sc = ''' || lvr_me.sc                         || ''''||
										' AND pg = '''|| REPLACE (lvr_me.pg, '''', '''''') || ''' AND pgnode = '|| lvr_me.pgnode ||
										' AND pa = '''|| REPLACE (lvr_me.pa, '''', '''''') || ''' AND panode = '|| lvr_me.panode ||
										' AND me = '''|| REPLACE (lvr_me.me, '''', '''''') || ''' AND menode = '|| lvr_me.menode;
				  l_nr_of_rows     := NULL;

				  lvi_ret_code       := UNAPIME.GETSCMETHOD
								   (l_sc_tab,
									l_pg_tab,
									l_pgnode_tab,
									l_pa_tab,
									l_panode_tab,
									l_me_tab,
									l_menode_tab,
									l_reanalysis_tab,
									l_mt_version_tab,
									l_description_tab,
									l_value_f_tab,
									l_value_s_tab,
									l_unit_tab,
									l_exec_start_date_tab,
									l_exec_end_date_tab,
									l_executor_tab,
									l_lab_tab,
									l_eq_tab,
									l_eq_version_tab,
									l_planned_executor_tab,
									l_planned_eq_tab,
									l_planned_eq_version_tab,
									l_manually_entered_tab,
									l_allow_add_tab,
									l_assign_date_tab,
									l_assigned_by_tab,
									l_manually_added_tab,
									l_delay_tab,
									l_delay_unit_tab,
									l_format_tab,
									l_accuracy_tab,
									l_real_cost_tab,
									l_real_time_tab,
									l_calibration_tab,
									l_confirm_complete_tab,
									l_autorecalc_tab,
									l_me_result_editable_tab,
									l_next_cell_tab,
									l_sop_tab,
									l_sop_version_tab,
									l_plaus_low_tab,
									l_plaus_high_tab,
									l_winsize_x_tab,
									l_winsize_y_tab,
									l_me_class_tab,
									l_log_hs_tab,
									l_log_hs_details_tab,
									l_allow_modify_tab,
									l_ar_tab,
									l_active_tab,
									l_lc_tab,
									l_lc_version_tab,
									l_ss_tab,
									l_reanalysedresult_tab,
									l_nr_of_rows,
									l_where_clause);

						IF lvi_ret_code <>  UNAPIGEN.DBERR_SUCCESS THEN
							logconversion('ERULG502', 'me',lvr_me.sc,lvr_conv.old,'-', 'GETSCMETHOD failed ' || lvi_ret_code);
						ELSE
						  FOR l_row IN 1..l_nr_of_rows LOOP
							 l_lab_tab(l_row)     := lvs_lab;
							 l_modify_flag_tab(l_row)     := UNAPIGEN.MOD_FLAG_UPDATE;
						  END LOOP;

						  lvi_ret_code       := UNAPIME.SAVESCMETHOD
							   (l_alarms_handled,
								l_sc_tab,
								l_pg_tab,
								l_pgnode_tab,
								l_pa_tab,
								l_panode_tab,
								l_me_tab,
								l_menode_tab,
								l_reanalysis_tab,
								l_mt_version_tab,
								l_description_tab,
								l_value_f_tab,
								l_value_s_tab,
								l_unit_tab,
								l_exec_start_date_tab,
								l_exec_end_date_tab,
								l_executor_tab,
								l_lab_tab,
								l_eq_tab,
								l_eq_version_tab,
								l_planned_executor_tab,
								l_planned_eq_tab,
								l_planned_eq_version_tab,
								l_manually_entered_tab,
								l_allow_add_tab,
								l_assign_date_tab,
								l_assigned_by_tab,
								l_manually_added_tab,
								l_delay_tab,
								l_delay_unit_tab,
								l_format_tab,
								l_accuracy_tab,
								l_real_cost_tab,
								l_real_time_tab,
								l_calibration_tab,
								l_confirm_complete_tab,
								l_autorecalc_tab,
								l_me_result_editable_tab,
								l_next_cell_tab,
								l_sop_tab,
								l_sop_version_tab,
								l_plaus_low_tab,
								l_plaus_high_tab,
								l_winsize_x_tab,
								l_winsize_y_tab,
								l_me_class_tab,
								l_log_hs_tab,
								l_log_hs_details_tab,
								l_lc_tab,
								l_lc_version_tab,
								l_modify_flag_tab,
								l_nr_of_rows,
								l_modify_reason);

						   IF lvi_ret_code <> UNAPIGEN.DBERR_SUCCESS THEN
								logconversion('ERULG502', 'me',lvr_me.sc,lvr_conv.old,'-', 'SAVESCMETHOD failed ' || lvi_ret_code);
							ELSE
							   IF avb_details THEN
									logconversion('ERULG502', 'me',lvr_me.sc,lvr_conv.old,lvs_lab, lvr_me.pg || ' # ' || lvr_me.pa || ' # ' || lvr_me.me || ' saved');
							   END IF;
							END IF;

						   lvi_count := lvi_count + 1;
						   IF lvi_count >= avi_max THEN
								logconversion('ERULG502', '-','-',lvr_conv.old,'-', lvi_count || ' records processed');
								EXIT;
							END IF;
						END IF;

				--lvi_ret_code := UNAPIGEN.ENDTRANSACTION();
			END LOOP;
		END IF;
	END LOOP;

	logconversion('ERULG502', '-','-','-','-','End   ' || lcs_function_name);

  RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END ERULG502;

----------------------------------------------------------------------------------------
-- ERULG504 Update mt-planned executor for “Tyre testing std”
----------------------------------------------------------------------------------------
FUNCTION ERULG504
RETURN APAOGEN.RETURN_TYPE IS
    lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ERULG504';
    lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
    lvi_ret_code            NUMBER;

    CURSOR lvq_conv IS
      SELECT *
          FROM atao_conversion
         WHERE type = 'ERULG504'
		   AND enabled = '1'
		   ORDER BY rulenr;

    lvsError            VARCHAR2(255) := NULL;
    lvn_total           NUMBER;
BEGIN
	SELECT MAX(sequence)
	  INTO lvi_seq
	  FROM atao_conversion_log;

	IF lvi_seq IS NULL THEN
		lvi_seq := 0;
	END IF;

	logconversion('ERULG504', '-','-','-','-','Start ' || lcs_function_name);


	-- Check if the new User (in UTAD) exist, if NOT stop with the execution  !!!
	FOR lvr_conv IN lvq_conv LOOP
		SELECT COUNT(*)
		  INTO lvn_total
		  FROM utad
		  WHERE ad = lvr_conv.new;

		IF lvn_total = 0 THEN
			logconversion('ERULG504', 'utad','-',lvr_conv.old,lvr_conv.new, 'New user not present' );
			lvsError := 'Not all users are present, so conversion will not be executed';
		END IF;
	END LOOP;

	IF (lvsError IS NULL ) THEN
		-- All users are present, so no we can convert

		-- convert the UTMT
		FOR lvr_conv IN lvq_conv LOOP
			-- Count and log the number of records to be converted
			SELECT COUNT(*)
			  INTO lvn_total
			  FROM utmt
			  WHERE executor = lvr_conv.old;
			logconversion('ERULG504', 'utmt','-',lvr_conv.old,lvr_conv.new, 'To be converted '  || lvn_total);

			-- Update the UTMT records with the new values
			BEGIN
				UPDATE utmt
				   SET executor = lvr_conv.new
				WHERE executor = lvr_conv.old;

				 logconversion('ERULG504', 'utmt','-',lvr_conv.old,lvr_conv.new, 'utmt converted');
			EXCEPTION
				WHEN OTHERS THEN
					IF SQLCODE <> 1 THEN
						lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
					END IF;
					logconversion('ERULG504', 'utmt','-',lvr_conv.old,lvr_conv.new, lvs_sqlerrm);
			END;
		END LOOP;

	ELSE
		-- New user is not present, so we can't do a conversion
		logconversion('ERULG504', '-','-','-','-', lvsError);
	END IF;
	logconversion('ERULG504', '-','-','-','-','End   ' || lcs_function_name);

  RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END ERULG504;

----------------------------------------------------------------------------------------
-- ERULG505 Update "Planned responsible" of RT and RQ
----------------------------------------------------------------------------------------
FUNCTION ERULG505
RETURN APAOGEN.RETURN_TYPE IS
    lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||'ERULG505';
    lvs_sqlerrm             APAOGEN.ERROR_MSG_TYPE;
    lvi_ret_code            NUMBER;

    CURSOR lvq_conv IS
      SELECT *
          FROM atao_conversion
         WHERE type = 'ERULG505'
		   AND enabled = '1'
		   ORDER BY rulenr;

    lvsError            VARCHAR2(255) := NULL;
    lvn_total           NUMBER;
BEGIN
	SELECT MAX(sequence)
	  INTO lvi_seq
	  FROM atao_conversion_log;

	IF lvi_seq IS NULL THEN
		lvi_seq := 0;
	END IF;

	logconversion('ERULG505', '-','-','-','-','Start ' || lcs_function_name);


	-- Check if the new User (in UTAD) exist, if NOT stop with the execution  !!!
	FOR lvr_conv IN lvq_conv LOOP
		SELECT COUNT(*)
		  INTO lvn_total
		  FROM utad
		  WHERE ad = lvr_conv.new;

		IF lvn_total = 0 THEN
			logconversion('ERULG505', 'utad','-',lvr_conv.old,lvr_conv.new, 'New user not present' );
			lvsError := 'Not all users are present, so conversion will not be executed';
		END IF;
	END LOOP;

	IF (lvsError IS NULL ) THEN
		-- All users are present, so no we can convert

		-- First we convert the UTRT
		FOR lvr_conv IN lvq_conv LOOP
			-- Count and log the number of records to be converted
			SELECT COUNT(*)
			  INTO lvn_total
			  FROM utrt
			  WHERE planned_responsible = lvr_conv.old;
			logconversion('ERULG505', 'utrt','-',lvr_conv.old,lvr_conv.new, 'To be converted '  || lvn_total);

			-- Update the UTRT records with the new values
			BEGIN
				UPDATE utrt
				   SET planned_responsible = lvr_conv.new
				 WHERE planned_responsible = lvr_conv.old;
				 logconversion('ERULG505', 'utrt','-',lvr_conv.old,lvr_conv.new, 'utrt converted');
			EXCEPTION
				WHEN OTHERS THEN
					IF SQLCODE <> 1 THEN
						lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
					END IF;
					logconversion('ERULG505', 'utrt','-',lvr_conv.old,lvr_conv.new, lvs_sqlerrm);
			END;
		END LOOP;

		-- Then the URTQ
		FOR lvr_conv IN lvq_conv LOOP
			-- Count and log the number of records to be converted
			SELECT COUNT(*)
			  INTO lvn_total
			  FROM utrq
			  WHERE responsible = lvr_conv.old;
			logconversion('ERULG505', 'utrq','-',lvr_conv.old,lvr_conv.new, 'To be converted '  || lvn_total);

			-- Update the UTRQ records with the new values
			BEGIN
				UPDATE utrq
				   SET responsible = lvr_conv.new
				 WHERE responsible = lvr_conv.old;
				 logconversion('ERULG505', 'utrq','-',lvr_conv.old,lvr_conv.new, 'utrq converted');
			EXCEPTION
				WHEN OTHERS THEN
					IF SQLCODE <> 1 THEN
						lvs_sqlerrm := SUBSTR(SQLERRM,1,255);
					END IF;
					logconversion('ERULG505', 'utrq','-',lvr_conv.old,lvr_conv.new, lvs_sqlerrm);
			END;
		END LOOP;

	ELSE
		-- New user is not present, so we can't do a conversion
		logconversion('ERULG505', '-','-','-','-', lvsError);
	END IF;
	logconversion('ERULG505', '-','-','-','-','End   ' || lcs_function_name);

  RETURN lvi_ret_code;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END ERULG505;

FUNCTION MDR_TestMethod
(avs_from IN VARCHAR2,
	 avs_to   IN VARCHAR2,
	 avi_max  IN NUMBER,
	 avb_details IN BOOLEAN)
RETURN APAOGEN.RETURN_TYPE IS
    lvs_conversion          VARCHAR2(20) := 'MDR_TestMethod';
    lcs_function_name       CONSTANT APAOGEN.API_NAME_TYPE := ics_package_name||'.'||lvs_conversion;


--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
--
-- selecteer alle PG/PA behorende bij PG lifecycle G2
--
-- 08/06/2017, MDR mag 'hard' met onderstaande settings worden geschreven:
--	avTestMethod = TP013B
-- 	avTestMethodDesc = Vulcanisation properties at 190°C
--
  CURSOR lvq_pa1 IS
 select pg.sc, pg.pg, pg.pgnode, pg.pp_key1, pa.pa, panode, pa.description
	    from utsc   sc
	       , utscpg pg
	       , utscpa pa
	    where sc.creation_date 	BETWEEN TO_DATE(avs_from,'DD-MM-YYYY') AND TO_DATE(avs_to,'DD-MM-YYYY')
	      and pg.sc = sc.sc
	      AND pg.pg = 'MDR vulc prop 190C'
	      AND pa.sc = pg.sc
	      AND pa.pg = pg.pg
	      AND pa.pgnode = pg.pgnode
   minus
      select pg.sc, pg.pg, pg.pgnode, pg.pp_key1, pa.pa, pa.panode, pa.description
        from utsc   sc
	       , utscpg pg
	       , utscpa pa
	       , utscpaau au
	    where sc.creation_date 	BETWEEN TO_DATE(avs_from,'DD-MM-YYYY') AND TO_DATE(avs_to,'DD-MM-YYYY')
	      and pg.sc = sc.sc
	      AND pg.pg = 'MDR vulc prop 190C'
	      AND pa.sc = pg.sc
	      AND pa.pg = pg.pg
	      AND pa.pgnode = pg.pgnode
          AND au.sc = sc.sc
          AND au.pg = pg.pg
          AND au.pgnode = pg.pgnode
          AND au.pa = pa.pa
          AND au.panode = pa.panode
	  --AND NVL(pg.pp_key1, ' ' ) = ' '
	      AND au.au in ( 'avTestMethod','avTestMethodDesc');

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lvs_sqlerrm  APAOGEN.ERROR_MSG_TYPE;
lvi_count 			NUMBER;
lvi_counter 		PLS_INTEGER := 0;
lvi_counter_max		PLS_INTEGER := 0;
lvi_commit			PLS_INTEGER := 10;
lvs_TestMethod 		VARCHAR2(40);
lvs_TestMethodDesc  VARCHAR2(40);
lvs_au              VARCHAR2(40);
BEGIN
	SELECT MAX(sequence)
	  INTO lvi_seq
	  FROM atao_conversion_log;

	IF lvi_seq IS NULL THEN
		lvi_seq := 0;
	END IF;

	logconversion(lvs_conversion, '-','-','-','-','Start ' || lcs_function_name);
	logconversion(lvs_conversion, '-','-','-','-','Periode ' || avs_from || ' tot ' || avs_to || ' max = ' || to_char(avi_max));

	lvs_TestMethod := 'TP013B';
	-- ruzie met het graden symbool chr(248), dus dan maar zo.
	SELECT value
	  INTO lvs_TestMethodDesc
	  FROM UTPPAU
	  WHERE PP = 'MDR vulc prop 190C'
	    AND AU = 'avTestMethodDesc'
	    AND pp_key1 = 'EM_770'
	    AND rownum < 2;

	FOR lvr_pa1 IN lvq_pa1 LOOP
		IF avb_details THEN
			logconversion(lvs_conversion, '-','-','-','-','SC: ' || lvr_pa1.sc || ';PG: ' || lvr_pa1.pg || ';PA: ' || lvr_pa1.pa);
		ELSE
			-- log om de 100 records toch 1 detail record
			IF MOD(lvi_counter, 100) = 0 THEN
				logconversion(lvs_conversion, '-','-','-','-','SC: ' || lvr_pa1.sc || ';PG: ' || lvr_pa1.pg || ';PA: ' || lvr_pa1.pa);
			END IF;
		END IF;

		------------------------------------------------------------------------
		-- Save attribute
		------------------------------------------------------------------------
		BEGIN
			lvs_au := 'avTestMethod';
			INSERT INTO utscpaau (sc, pg, pgnode, pa, panode, au, auseq, value)
				 VALUES (lvr_pa1.sc,
						lvr_pa1.pg, lvr_pa1.pgnode,
						lvr_pa1.pa, lvr_pa1.panode,
						lvs_au, 500, 'TP013B');
			lvs_au := 'avTestMethodDesc';
			INSERT INTO utscpaau (sc, pg, pgnode, pa, panode, au, auseq, value)
				 VALUES (lvr_pa1.sc,
						lvr_pa1.pg, lvr_pa1.pgnode,
						lvr_pa1.pa, lvr_pa1.panode,
						lvs_au, 500, lvs_TestMethodDesc);
		EXCEPTION
			WHEN OTHERS THEN
				lvs_sqlerrm := SUBSTR ('Insert in utscpaau failed for: ' ||
							'<' || lvr_pa1.sc || '><' ||
							'<' || lvr_pa1.pg || '><' || TO_CHAR (lvr_pa1.pgnode) || '>' ||
							'<' || lvr_pa1.pa || '><' || TO_CHAR (lvr_pa1.panode) || '>, ' || lvs_au, 0, 255);

				logconversion(lvs_conversion, '-','-','-','-','ERROR' || lvs_sqlerrm);
				lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
				logconversion(lvs_conversion, '-','-','-','-','ERROR' || lvs_sqlerrm);
		END;

		lvi_counter 	:= lvi_counter + 1;
		lvi_counter_max := lvi_counter_max + 1;
		IF lvi_counter > lvi_commit THEN
			lvi_counter := 0;
			commit;
		END IF;
		IF avi_max > 0 THEN
			IF lvi_counter_max >= avi_max THEN
				logconversion(lvs_conversion, '-','-','-','-','LET OP: Er zijn nog meer records voor deze periode ' || lcs_function_name);
				EXIT;
			END IF;
		END IF;
	END LOOP;
	logconversion(lvs_conversion, '-','-','-','-','Einde ' || lcs_function_name);
	COMMIT;
	RETURN 0;

EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE != 1 THEN
    lvs_sqlerrm := SUBSTR (SQLERRM, 0, 255);
    UNAPIGEN.LogError (lcs_function_name, lvs_sqlerrm);
  END IF;
  RETURN UNAPIGEN.DBERR_GENFAIL;
END MDR_TestMethod;

END APAO_CONVERSION;
/
