create or replace PACKAGE BODY ulop AS

-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION HandleCreateSample
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code                    NUMBER;
a_st                          VARCHAR2(20);
a_st_version                  VARCHAR2(20);
a_sc                          VARCHAR2(20);
a_ref_date                    TIMESTAMP WITH TIME ZONE;
a_create_ic                   VARCHAR2(40);
a_create_pg                   VARCHAR2(40);
a_userid                      VARCHAR2(40);
a_modify_reason               VARCHAR2(255);
a_fieldtype_tab               UNAPIGEN.VC20_TABLE_TYPE;
a_fieldnames_tab              UNAPIGEN.VC20_TABLE_TYPE;
a_fieldvalues_tab             UNAPIGEN.VC40_TABLE_TYPE;
a_field_nr_of_rows            NUMBER;

BEGIN

a_last_seq := a_curr_line.seq;

a_st := SUBSTR(a_curr_line.arg1, 1, 20);
a_st_version := SUBSTR(a_curr_line.arg2, 1, 20);
a_sc := SUBSTR(a_curr_line.arg3, 1, 20);
a_ref_date := TO_TIMESTAMP_TZ(a_curr_line.arg4);
a_create_ic := SUBSTR(a_curr_line.arg5, 1, 40);
a_create_pg := SUBSTR(a_curr_line.arg6, 1, 40);
a_userid := SUBSTR(a_curr_line.arg7, 1, 40);
a_modify_reason := SUBSTR(a_curr_line.arg8, 1, 255);
a_field_nr_of_rows := 0;

 l_ret_code := UNAPISC.CreateSample(a_st, a_st_version, a_sc, a_ref_date, a_create_ic,
                                    a_create_pg, a_userid,  a_fieldtype_tab,
                                    a_fieldnames_tab, a_fieldvalues_tab, a_field_nr_of_rows, a_modify_reason);

RETURN(l_ret_code);

END HandleCreateSample;

FUNCTION HandleSaveSample
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code            NUMBER;
a_sc                  VARCHAR2(20);
a_st                  VARCHAR2(20);
a_st_version          VARCHAR2(20);
a_description         VARCHAR2(40);
a_shelf_life_val      NUMBER;
a_shelf_life_unit     VARCHAR(20);
a_sampling_date       TIMESTAMP WITH TIME ZONE;
a_creation_date       TIMESTAMP WITH TIME ZONE;
a_created_by          VARCHAR2(20);
a_exec_start_date     TIMESTAMP WITH TIME ZONE;
a_exec_end_date       TIMESTAMP WITH TIME ZONE;
a_priority            NUMBER;
a_label_format        VARCHAR2(20);
a_descr_doc           VARCHAR2(40);
a_descr_doc_version   VARCHAR2(20);
a_rq                  VARCHAR2(20);
a_sd                  VARCHAR2(20);
a_date1               TIMESTAMP WITH TIME ZONE;
a_date2               TIMESTAMP WITH TIME ZONE;
a_date3               TIMESTAMP WITH TIME ZONE;
a_date4               TIMESTAMP WITH TIME ZONE;
a_date5               TIMESTAMP WITH TIME ZONE;
a_allow_any_pp        CHAR(1);
a_sc_class            VARCHAR2(2);
a_log_hs              CHAR(1);
a_log_hs_details      CHAR(1);
a_lc                  VARCHAR2(2);
a_lc_version          VARCHAR2(20);
a_modify_reason       VARCHAR2(255);

BEGIN

a_last_seq := a_curr_line.seq;

a_sc := SUBSTR(a_curr_line.arg1, 1, 20);
a_st := SUBSTR(a_curr_line.arg2, 1, 20);
a_st_version := SUBSTR(a_curr_line.arg3, 1, 20);
a_description := SUBSTR(a_curr_line.arg4, 1, 40);
a_shelf_life_val := TO_NUMBER(a_curr_line.arg5);
a_shelf_life_unit := SUBSTR(a_curr_line.arg6, 1, 20);
a_sampling_date := TO_TIMESTAMP_TZ(a_curr_line.arg7);
a_creation_date := TO_TIMESTAMP_TZ(a_curr_line.arg8);
a_created_by := SUBSTR(a_curr_line.arg9, 1, 20);
a_exec_start_date := TO_TIMESTAMP_TZ(a_curr_line.arg10);
a_exec_end_date := TO_TIMESTAMP_TZ(a_curr_line.arg11);
a_priority := TO_NUMBER(a_curr_line.arg12);
a_label_format := SUBSTR(a_curr_line.arg13, 1, 20);
a_descr_doc := SUBSTR(a_curr_line.arg14, 1, 40);
a_descr_doc_version := SUBSTR(a_curr_line.arg15, 1, 20);
a_rq := SUBSTR(a_curr_line.arg16, 1, 20);
a_sd := SUBSTR(a_curr_line.arg17, 1, 20);
a_date1 := TO_TIMESTAMP_TZ(a_curr_line.arg18);
a_date2 := TO_TIMESTAMP_TZ(a_curr_line.arg19);
a_date3 := TO_TIMESTAMP_TZ(a_curr_line.arg20);
a_date4 := TO_TIMESTAMP_TZ(a_curr_line.arg21);
a_date5 := TO_TIMESTAMP_TZ(a_curr_line.arg22);
a_allow_any_pp := SUBSTR(a_curr_line.arg23, 1, 1);
a_sc_class := SUBSTR(a_curr_line.arg24, 1, 2);
a_log_hs := SUBSTR(a_curr_line.arg25, 1, 1);
a_log_hs_details := SUBSTR(a_curr_line.arg26, 1, 1);
a_lc := SUBSTR(a_curr_line.arg27, 1, 2);
a_lc_version := SUBSTR(a_curr_line.arg28, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg29, 1, 255);

l_ret_code := UNAPISC.SaveSample
                (a_sc, a_st, a_st_version, a_description, a_shelf_life_val,
                 a_shelf_life_unit, a_sampling_date, a_creation_date,
                 a_created_by, a_exec_start_date, a_exec_end_date,
                 a_priority, a_label_format, a_descr_doc, a_descr_doc_version, a_rq, a_sd, a_date1, a_date2, a_date3,
                 a_date4, a_date5, a_allow_any_pp, a_sc_class, a_log_hs, a_log_hs_details,
                 a_lc, a_lc_version, a_modify_reason);

RETURN(l_ret_code);

END HandleSaveSample;

FUNCTION HandleSaveScParameterGroup
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code                NUMBER;
a_sc                      UNAPIGEN.VC20_TABLE_TYPE;
a_pg                      UNAPIGEN.VC20_TABLE_TYPE;
a_pgnode                  UNAPIGEN.LONG_TABLE_TYPE;
a_pp_version              UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key1                 UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key2                 UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key3                 UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key4                 UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key5                 UNAPIGEN.VC20_TABLE_TYPE;
a_description             UNAPIGEN.VC40_TABLE_TYPE;
a_value_f                 UNAPIGEN.FLOAT_TABLE_TYPE;
a_value_s                 UNAPIGEN.VC40_TABLE_TYPE;
a_unit                    UNAPIGEN.VC20_TABLE_TYPE;
a_exec_start_date         UNAPIGEN.DATE_TABLE_TYPE;
a_exec_end_date           UNAPIGEN.DATE_TABLE_TYPE;
a_executor                UNAPIGEN.VC20_TABLE_TYPE;
a_planned_executor        UNAPIGEN.VC20_TABLE_TYPE;
a_manually_entered        UNAPIGEN.CHAR1_TABLE_TYPE;
a_assign_date             UNAPIGEN.DATE_TABLE_TYPE;
a_assigned_by             UNAPIGEN.VC20_TABLE_TYPE;
a_manually_added          UNAPIGEN.CHAR1_TABLE_TYPE;
a_format                  UNAPIGEN.VC40_TABLE_TYPE;
a_confirm_assign          UNAPIGEN.CHAR1_TABLE_TYPE;
a_allow_any_pr            UNAPIGEN.CHAR1_TABLE_TYPE;
a_never_create_methods    UNAPIGEN.CHAR1_TABLE_TYPE;
a_delay                   UNAPIGEN.NUM_TABLE_TYPE;
a_delay_unit              UNAPIGEN.VC20_TABLE_TYPE;
a_pg_class                UNAPIGEN.VC2_TABLE_TYPE;
a_log_hs                  UNAPIGEN.CHAR1_TABLE_TYPE;
a_log_hs_details          UNAPIGEN.CHAR1_TABLE_TYPE;
a_lc                      UNAPIGEN.VC2_TABLE_TYPE;
a_lc_version              UNAPIGEN.VC20_TABLE_TYPE;
a_modify_flag             UNAPIGEN.NUM_TABLE_TYPE;
a_nr_of_rows              NUMBER;
a_modify_reason           VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_nr_of_rows := TO_NUMBER(a_curr_line.arg34);OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_sc(x) := SUBSTR(l_curr_line.arg1, 1, 20);
   a_pg(x) := SUBSTR(l_curr_line.arg2, 1, 20);
   a_pgnode(x) := TO_NUMBER(l_curr_line.arg3);
   a_pp_version(x) := SUBSTR(l_curr_line.arg4, 1, 20);
   a_pp_key1(x) := SUBSTR(l_curr_line.arg5, 1, 20);
   a_pp_key2(x) := SUBSTR(l_curr_line.arg6, 1, 20);
   a_pp_key3(x) := SUBSTR(l_curr_line.arg7, 1, 20);
   a_pp_key4(x) := SUBSTR(l_curr_line.arg8, 1, 20);
   a_pp_key5(x) := SUBSTR(l_curr_line.arg9, 1, 20);
   a_description(x) := SUBSTR(l_curr_line.arg10, 1, 40);
   a_value_f(x) := TO_NUMBER(l_curr_line.arg11);
   a_value_s(x) := SUBSTR(l_curr_line.arg12, 1, 40);
   a_unit(x) := SUBSTR(l_curr_line.arg13, 1, 20);
   a_exec_start_date(x) := TO_TIMESTAMP_TZ(l_curr_line.arg14);
   a_exec_end_date(x) := TO_TIMESTAMP_TZ(l_curr_line.arg15);
   a_executor(x) := SUBSTR(l_curr_line.arg16, 1, 20);
   a_planned_executor(x) := SUBSTR(l_curr_line.arg17, 1, 20);
   a_manually_entered(x) := SUBSTR(l_curr_line.arg18, 1, 20);
   a_assign_date(x) := TO_TIMESTAMP_TZ(l_curr_line.arg19);
   a_assigned_by(x) := SUBSTR(l_curr_line.arg20, 1, 20);
   a_manually_added(x) := SUBSTR(l_curr_line.arg21, 1, 1);
   a_format(x) := SUBSTR(l_curr_line.arg22, 1, 40);
   a_confirm_assign(x) := SUBSTR(l_curr_line.arg23, 1, 1);
   a_allow_any_pr(x) := SUBSTR(l_curr_line.arg24, 1, 1);
   a_never_create_methods(x) := SUBSTR(l_curr_line.arg25, 1, 1);
   a_delay(x) := TO_NUMBER(l_curr_line.arg26);
   a_delay_unit(x) := SUBSTR(l_curr_line.arg27, 1, 20);
   a_pg_class(x) := SUBSTR(l_curr_line.arg28, 1, 2);
   a_log_hs(x) := SUBSTR(l_curr_line.arg29, 1, 1);
   a_log_hs_details(x) := SUBSTR(l_curr_line.arg30, 1, 1);
   a_lc(x) := SUBSTR(l_curr_line.arg31, 1, 2);
   a_lc_version(x) := SUBSTR(l_curr_line.arg32, 1, 20);
   a_modify_flag(x) := TO_NUMBER(l_curr_line.arg33);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg35, 1, 255);

l_ret_code := UNAPIPG.SaveScParameterGroup
                (a_sc, a_pg, a_pgnode, a_pp_version,
                 a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5,
                 a_description, a_value_f, a_value_s,
                 a_unit, a_exec_start_date, a_exec_end_date, a_executor,
                 a_planned_executor, a_manually_entered, a_assign_date,
                 a_assigned_by, a_manually_added, a_format, a_confirm_assign,
                 a_allow_any_pr, a_never_create_methods, a_delay, a_delay_unit, a_pg_class,
                 a_log_hs, a_log_hs_details, a_lc, a_lc_version,
                 a_modify_flag, a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveScParameterGroup;

FUNCTION HandleSaveScParameter
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code            NUMBER;
a_alarms_handled      CHAR(1);
a_sc                  UNAPIGEN.VC20_TABLE_TYPE;
a_pg                  UNAPIGEN.VC20_TABLE_TYPE;
a_pgnode              UNAPIGEN.LONG_TABLE_TYPE;
a_pa                  UNAPIGEN.VC20_TABLE_TYPE;
a_panode              UNAPIGEN.LONG_TABLE_TYPE;
a_pr_version          UNAPIGEN.VC20_TABLE_TYPE;
a_description         UNAPIGEN.VC40_TABLE_TYPE;
a_value_f             UNAPIGEN.FLOAT_TABLE_TYPE;
a_value_s             UNAPIGEN.VC40_TABLE_TYPE;
a_unit                UNAPIGEN.VC20_TABLE_TYPE;
a_exec_start_date     UNAPIGEN.DATE_TABLE_TYPE;
a_exec_end_date       UNAPIGEN.DATE_TABLE_TYPE;
a_executor            UNAPIGEN.VC20_TABLE_TYPE;
a_planned_executor    UNAPIGEN.VC20_TABLE_TYPE;
a_manually_entered    UNAPIGEN.CHAR1_TABLE_TYPE;
a_assign_date         UNAPIGEN.DATE_TABLE_TYPE;
a_assigned_by         UNAPIGEN.VC20_TABLE_TYPE;
a_manually_added      UNAPIGEN.CHAR1_TABLE_TYPE;
a_format              UNAPIGEN.VC40_TABLE_TYPE;
a_td_info             UNAPIGEN.NUM_TABLE_TYPE;
a_td_info_unit        UNAPIGEN.VC20_TABLE_TYPE;
a_confirm_uid         UNAPIGEN.CHAR1_TABLE_TYPE;
a_allow_any_me        UNAPIGEN.CHAR1_TABLE_TYPE;
a_delay               UNAPIGEN.NUM_TABLE_TYPE;
a_delay_unit          UNAPIGEN.VC20_TABLE_TYPE;
a_min_nr_results      UNAPIGEN.NUM_TABLE_TYPE;
a_calc_method         UNAPIGEN.CHAR1_TABLE_TYPE;
a_calc_cf             UNAPIGEN.VC20_TABLE_TYPE;
a_alarm_order         UNAPIGEN.VC3_TABLE_TYPE;
a_valid_specsa        UNAPIGEN.CHAR1_TABLE_TYPE;
a_valid_specsb        UNAPIGEN.CHAR1_TABLE_TYPE;
a_valid_specsc        UNAPIGEN.CHAR1_TABLE_TYPE;
a_valid_limitsa       UNAPIGEN.CHAR1_TABLE_TYPE;
a_valid_limitsb       UNAPIGEN.CHAR1_TABLE_TYPE;
a_valid_limitsc       UNAPIGEN.CHAR1_TABLE_TYPE;
a_valid_targeta       UNAPIGEN.CHAR1_TABLE_TYPE;
a_valid_targetb       UNAPIGEN.CHAR1_TABLE_TYPE;
a_valid_targetc       UNAPIGEN.CHAR1_TABLE_TYPE;
a_mt                  UNAPIGEN.VC20_TABLE_TYPE;
a_mt_version          UNAPIGEN.VC20_TABLE_TYPE;
a_mt_nr_measur        UNAPIGEN.NUM_TABLE_TYPE;
a_log_exceptions      UNAPIGEN.CHAR1_TABLE_TYPE;
a_pa_class            UNAPIGEN.VC2_TABLE_TYPE;
a_log_hs              UNAPIGEN.CHAR1_TABLE_TYPE;
a_log_hs_details      UNAPIGEN.CHAR1_TABLE_TYPE;
a_lc                  UNAPIGEN.VC2_TABLE_TYPE;
a_lc_version          UNAPIGEN.VC20_TABLE_TYPE;
a_modify_flag         UNAPIGEN.NUM_TABLE_TYPE;
a_nr_of_rows          NUMBER;
a_modify_reason       VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_nr_of_rows := TO_NUMBER(a_curr_line.arg50);
a_alarms_handled := SUBSTR(l_curr_line.arg1, 1, 1);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP
   a_last_seq := l_curr_line.seq;

   a_sc(x) := SUBSTR(l_curr_line.arg2, 1, 20);
   a_pg(x) := SUBSTR(l_curr_line.arg3, 1, 20);
   a_pgnode(x) := TO_NUMBER(l_curr_line.arg4);
   a_pa(x) := SUBSTR(l_curr_line.arg5, 1, 20);
   a_panode(x) := TO_NUMBER(l_curr_line.arg6);
   a_pr_version(x) := SUBSTR(l_curr_line.arg7, 1, 20);
   a_description(x) := SUBSTR(l_curr_line.arg8, 1, 40);
   a_value_f(x) := TO_NUMBER(l_curr_line.arg9);
   a_value_s(x) := SUBSTR(l_curr_line.arg10, 1, 40);
   a_unit(x) := SUBSTR(l_curr_line.arg11, 1, 20);
   a_exec_start_date(x) := TO_TIMESTAMP_TZ(l_curr_line.arg12);
   a_exec_end_date(x) := TO_TIMESTAMP_TZ(l_curr_line.arg13);
   a_executor(x) := SUBSTR(l_curr_line.arg14, 1, 20);
   a_planned_executor(x) := SUBSTR(l_curr_line.arg15, 1, 20);
   a_manually_entered(x) := SUBSTR(l_curr_line.arg16, 1, 1);
   a_assign_date(x) := TO_TIMESTAMP_TZ(l_curr_line.arg17);
   a_assigned_by(x) := SUBSTR(l_curr_line.arg18, 1, 20);
   a_manually_added(x) := SUBSTR(l_curr_line.arg19, 1, 1);
   a_format(x) := SUBSTR(l_curr_line.arg20, 1, 40);
   a_td_info(x) := TO_NUMBER(l_curr_line.arg21);
   a_td_info_unit(x) := SUBSTR(l_curr_line.arg22, 1, 20);
   a_confirm_uid(x) := SUBSTR(l_curr_line.arg23, 1, 1);
   a_allow_any_me(x) := SUBSTR(l_curr_line.arg24, 1, 1);
   a_delay(x) := TO_NUMBER(l_curr_line.arg25);
   a_delay_unit(x) := SUBSTR(l_curr_line.arg26, 1, 20);
   a_min_nr_results(x) := TO_NUMBER(l_curr_line.arg27);
   a_calc_method(x) := SUBSTR(l_curr_line.arg28, 1, 1);
   a_calc_cf(x) := SUBSTR(l_curr_line.arg29, 1, 20);
   a_alarm_order(x) := SUBSTR(l_curr_line.arg30, 1, 3);
   a_valid_specsa(x) := SUBSTR(l_curr_line.arg31, 1, 1);
   a_valid_specsb(x) := SUBSTR(l_curr_line.arg32, 1, 1);
   a_valid_specsc(x) := SUBSTR(l_curr_line.arg33, 1, 1);
   a_valid_limitsa(x) := SUBSTR(l_curr_line.arg34, 1, 1);
   a_valid_limitsb(x) := SUBSTR(l_curr_line.arg35, 1, 1);
   a_valid_limitsc(x) := SUBSTR(l_curr_line.arg36, 1, 1);
   a_valid_targeta(x) := SUBSTR(l_curr_line.arg37, 1, 1);
   a_valid_targetb(x) := SUBSTR(l_curr_line.arg38, 1, 1);
   a_valid_targetc(x) := SUBSTR(l_curr_line.arg39, 1, 1);
   a_mt(x) := SUBSTR(l_curr_line.arg40, 1, 20);
   a_mt_version(x) := SUBSTR(l_curr_line.arg41, 1, 20);
   a_mt_nr_measur(x) := TO_NUMBER(l_curr_line.arg42);
   a_log_exceptions(x) := SUBSTR(l_curr_line.arg43, 1, 1);
   a_pa_class(x) := SUBSTR(l_curr_line.arg44, 1, 2);
   a_log_hs(x) := SUBSTR(l_curr_line.arg45, 1, 1);
   a_log_hs_details(x) := SUBSTR(l_curr_line.arg46, 1, 1);
   a_lc(x) := SUBSTR(l_curr_line.arg47, 1, 2);
   a_lc_version(x) := SUBSTR(l_curr_line.arg48, 1, 20);
   a_modify_flag(x) := TO_NUMBER(l_curr_line.arg49);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;

END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg51, 1, 255);

l_ret_code := UNAPIPA.SaveScParameter
                 (a_alarms_handled, a_sc, a_pg, a_pgnode, a_pa, a_panode, a_pr_version,
                  a_description, a_value_f, a_value_s, a_unit, a_exec_start_date,
                  a_exec_end_date, a_executor, a_planned_executor,
                  a_manually_entered, a_assign_date, a_assigned_by,
                  a_manually_added, a_format, a_td_info, a_td_info_unit,
                  a_confirm_uid, a_allow_any_me, a_delay, a_delay_unit,
                  a_min_nr_results, a_calc_method, a_calc_cf, a_alarm_order,
                  a_valid_specsa, a_valid_specsb, a_valid_specsc,
                  a_valid_limitsa, a_valid_limitsb, a_valid_limitsc,
                  a_valid_targeta, a_valid_targetb, a_valid_targetc,
                  a_mt, a_mt_version, a_mt_nr_measur,
                  a_log_exceptions, a_pa_class,
                  a_log_hs, a_log_hs_details, a_lc, a_lc_version,
                  a_modify_flag, a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveScParameter;

FUNCTION HandleSaveScMethod
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code            NUMBER;
a_alarms_handled      CHAR(1);
a_sc                  UNAPIGEN.VC20_TABLE_TYPE;
a_pg                  UNAPIGEN.VC20_TABLE_TYPE;
a_pgnode              UNAPIGEN.LONG_TABLE_TYPE;
a_pa                  UNAPIGEN.VC20_TABLE_TYPE;
a_panode              UNAPIGEN.LONG_TABLE_TYPE;
a_me                  UNAPIGEN.VC20_TABLE_TYPE;
a_menode              UNAPIGEN.LONG_TABLE_TYPE;
a_reanalysis          UNAPIGEN.NUM_TABLE_TYPE;
a_mt_version          UNAPIGEN.VC20_TABLE_TYPE;
a_description         UNAPIGEN.VC40_TABLE_TYPE;
a_value_f             UNAPIGEN.FLOAT_TABLE_TYPE;
a_value_s             UNAPIGEN.VC40_TABLE_TYPE;
a_unit                UNAPIGEN.VC20_TABLE_TYPE;
a_exec_start_date     UNAPIGEN.DATE_TABLE_TYPE;
a_exec_end_date       UNAPIGEN.DATE_TABLE_TYPE;
a_executor            UNAPIGEN.VC20_TABLE_TYPE;
a_lab                 UNAPIGEN.VC20_TABLE_TYPE;
a_eq                  UNAPIGEN.VC20_TABLE_TYPE;
a_eq_version          UNAPIGEN.VC20_TABLE_TYPE;
a_planned_executor    UNAPIGEN.VC20_TABLE_TYPE;
a_planned_eq          UNAPIGEN.VC20_TABLE_TYPE;
a_planned_eq_version  UNAPIGEN.VC20_TABLE_TYPE;
a_manually_entered    UNAPIGEN.CHAR1_TABLE_TYPE;
a_allow_add           UNAPIGEN.CHAR1_TABLE_TYPE;
a_assign_date         UNAPIGEN.DATE_TABLE_TYPE;
a_assigned_by         UNAPIGEN.VC20_TABLE_TYPE;
a_manually_added      UNAPIGEN.CHAR1_TABLE_TYPE;
a_delay               UNAPIGEN.NUM_TABLE_TYPE;
a_delay_unit          UNAPIGEN.VC20_TABLE_TYPE;
a_format              UNAPIGEN.VC40_TABLE_TYPE;
a_accuracy            UNAPIGEN.FLOAT_TABLE_TYPE;
a_real_cost           UNAPIGEN.VC40_TABLE_TYPE;
a_real_time           UNAPIGEN.VC40_TABLE_TYPE;
a_calibration         UNAPIGEN.CHAR1_TABLE_TYPE;
a_confirm_complete    UNAPIGEN.CHAR1_TABLE_TYPE;
a_autorecalc          UNAPIGEN.CHAR1_TABLE_TYPE;
a_me_result_editable  UNAPIGEN.CHAR1_TABLE_TYPE;
a_next_cell           UNAPIGEN.VC20_TABLE_TYPE;
a_sop                 UNAPIGEN.VC40_TABLE_TYPE;
a_sop_version         UNAPIGEN.VC20_TABLE_TYPE;
a_plaus_low           UNAPIGEN.FLOAT_TABLE_TYPE;
a_plaus_high          UNAPIGEN.FLOAT_TABLE_TYPE;
a_winsize_x           UNAPIGEN.NUM_TABLE_TYPE;
a_winsize_y           UNAPIGEN.NUM_TABLE_TYPE;
a_me_class            UNAPIGEN.VC2_TABLE_TYPE;
a_log_hs              UNAPIGEN.CHAR1_TABLE_TYPE;
a_log_hs_details      UNAPIGEN.CHAR1_TABLE_TYPE;
a_lc                  UNAPIGEN.VC2_TABLE_TYPE;
a_lc_version          UNAPIGEN.VC20_TABLE_TYPE;
a_modify_flag         UNAPIGEN.NUM_TABLE_TYPE;
a_nr_of_rows          NUMBER;
a_modify_reason       VARCHAR2(255);
l_debug               VARCHAR2(200);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;
l_sqlerrm             VARCHAR2(255);

BEGIN

l_debug := 'setting current line';
l_curr_line := a_curr_line;

l_debug := 'arg52';
a_nr_of_rows := TO_NUMBER(a_curr_line.arg52);

l_debug := 'arg1';
a_alarms_handled := SUBSTR(l_curr_line.arg1, 1, 1);
l_debug := 'Open cursor step';

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP
   a_last_seq := l_curr_line.seq;

   l_debug := 'arg2';
   a_sc(x) := SUBSTR(l_curr_line.arg2, 1, 20);
   l_debug := 'arg3';
   a_pg(x) := SUBSTR(l_curr_line.arg3, 1, 20);
   l_debug := 'arg4';
   a_pgnode(x) := TO_NUMBER(l_curr_line.arg4);
   l_debug := 'arg5';
   a_pa(x) := SUBSTR(l_curr_line.arg5, 1, 20);
   l_debug := 'arg6';
   a_panode(x) := TO_NUMBER(l_curr_line.arg6);
   l_debug := 'arg7';
   a_me(x) := SUBSTR(l_curr_line.arg7, 1, 20);
   l_debug := 'arg8';
   a_menode(x) := TO_NUMBER(l_curr_line.arg8);
   l_debug := 'arg9';
   a_reanalysis(x) := TO_NUMBER(l_curr_line.arg9);
   l_debug := 'arg10';
   a_mt_version(x) := SUBSTR(l_curr_line.arg10, 1, 20);
   l_debug := 'arg11';
   a_description(x) := SUBSTR(l_curr_line.arg11, 1, 40);
   l_debug := 'arg12';
   a_value_f(x) := TO_NUMBER(l_curr_line.arg12);
   l_debug := 'arg13';
   a_value_s(x) := SUBSTR(l_curr_line.arg13, 1, 40);
   l_debug := 'arg14';
   a_unit(x) := SUBSTR(l_curr_line.arg14, 1, 20);
   l_debug := 'arg15';
   a_exec_start_date(x) := TO_TIMESTAMP_TZ(l_curr_line.arg15);
   l_debug := 'arg16';
   a_exec_end_date(x) := TO_TIMESTAMP_TZ(l_curr_line.arg16);
   l_debug := 'arg17';
   a_executor(x) := SUBSTR(l_curr_line.arg17, 1, 20);
   l_debug := 'arg18';
   a_lab(x) := SUBSTR(l_curr_line.arg18, 1, 20);
   l_debug := 'arg19';
   a_eq(x) := SUBSTR(l_curr_line.arg19, 1, 20);
   l_debug := 'arg20';
   a_eq_version(x) := SUBSTR(l_curr_line.arg20, 1, 20);
   l_debug := 'arg20';
   a_planned_executor(x) := SUBSTR(l_curr_line.arg21, 1, 20);
   l_debug := 'arg21';
   a_planned_eq(x) := SUBSTR(l_curr_line.arg22, 1, 20);
   l_debug := 'arg22';
   a_planned_eq_version(x) := SUBSTR(l_curr_line.arg23, 1, 20);
   l_debug := 'arg23';
   a_manually_entered(x) := SUBSTR(l_curr_line.arg24, 1, 1);
   l_debug := 'arg24';
   a_allow_add(x) := SUBSTR(l_curr_line.arg25, 1, 1);
   l_debug := 'arg25';
   a_assign_date(x) := TO_TIMESTAMP_TZ(l_curr_line.arg26);
   l_debug := 'arg26';
   a_assigned_by(x) := SUBSTR(l_curr_line.arg27, 1, 20);
   l_debug := 'arg27';
   a_manually_added(x) := SUBSTR(l_curr_line.arg28, 1, 1);
   l_debug := 'arg28';
   a_delay(x) := TO_NUMBER(l_curr_line.arg29);
   l_debug := 'arg29';
   a_delay_unit(x) := SUBSTR(l_curr_line.arg30, 1, 20);
   l_debug := 'arg30';
   a_format(x) := SUBSTR(l_curr_line.arg31, 1, 40);
   l_debug := 'arg31';
   a_accuracy(x) := TO_NUMBER(l_curr_line.arg32);
   l_debug := 'arg32';
   a_real_cost(x) := SUBSTR(l_curr_line.arg33, 1, 20);
   l_debug := 'arg33';
   a_real_time(x) := SUBSTR(l_curr_line.arg34, 1, 20);
   l_debug := 'arg34';
   a_calibration(x) := SUBSTR(l_curr_line.arg35, 1, 1);
   l_debug := 'arg35';
   a_confirm_complete(x) := SUBSTR(l_curr_line.arg36, 1, 1);
   l_debug := 'arg36';
   a_autorecalc(x) := SUBSTR(l_curr_line.arg37, 1, 1);
   l_debug := 'arg37';
   a_me_result_editable(x) := SUBSTR(l_curr_line.arg38, 1, 1);
   l_debug := 'arg38';
   a_next_cell(x) := SUBSTR(l_curr_line.arg39, 1, 20);
   l_debug := 'arg39';
   a_sop(x) := SUBSTR(l_curr_line.arg40, 1, 40);
   l_debug := 'arg40';
   a_sop_version(x) := SUBSTR(l_curr_line.arg41, 1, 20);
   l_debug := 'arg41';
   a_plaus_low(x) := TO_NUMBER(l_curr_line.arg42);
   l_debug := 'arg42';
   a_plaus_high(x) := TO_NUMBER(l_curr_line.arg43);
   l_debug := 'arg43';
   a_winsize_x(x) := TO_NUMBER(l_curr_line.arg44);
   l_debug := 'arg44';
   a_winsize_y(x) := TO_NUMBER(l_curr_line.arg45);
   l_debug := 'arg45';
   a_me_class(x) := SUBSTR(l_curr_line.arg46, 1, 2);
   l_debug := 'arg46';
   a_log_hs(x) := SUBSTR(l_curr_line.arg47, 1, 1);
   l_debug := 'arg47';
   a_log_hs_details(x) := SUBSTR(l_curr_line.arg48, 1, 1);
   l_debug := 'arg48';
   a_lc(x) := SUBSTR(l_curr_line.arg49, 1, 2);
   l_debug := 'arg49';
   a_lc_version(x) := SUBSTR(l_curr_line.arg50, 1, 20);
   l_debug := 'arg50';
   a_modify_flag(x) := TO_NUMBER(l_curr_line.arg51);
   l_debug := 'Fetch next';

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;

END LOOP;

l_debug := 'arg53';
a_modify_reason := SUBSTR(a_curr_line.arg53, 1, 255);
l_debug := 'SaveScMethod call';

l_ret_code := UNAPIME.SaveScMethod
                 (a_alarms_handled, a_sc, a_pg, a_pgnode, a_pa, a_panode,
                  a_me, a_menode, a_reanalysis, a_mt_version, a_description,
                  a_value_f, a_value_s, a_unit,
                  a_exec_start_date, a_exec_end_date, a_executor, a_lab, a_eq, a_eq_version,
                  a_planned_executor, a_planned_eq, a_planned_eq_version, a_manually_entered,
                  a_allow_add, a_assign_date, a_assigned_by, a_manually_added,
                  a_delay, a_delay_unit, a_format, a_accuracy,
                  a_real_cost, a_real_time, a_calibration, a_confirm_complete,
                  a_autorecalc, a_me_result_editable, a_next_cell,
                  a_sop, a_sop_version, a_plaus_low, a_plaus_high, a_winsize_x,
                  a_winsize_y, a_me_class, a_log_hs, a_log_hs_details, a_lc, a_lc_version, a_modify_flag,
                  a_nr_of_rows, a_modify_reason);

l_debug := 'Closing cursor';
CLOSE l_next_line_cursor;

RETURN(l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := l_debug || '#seq=' || TO_CHAR(l_curr_line.seq)
               || '#' ||SUBSTR(SQLERRM,1,100);
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'HandleSaveScMethod' , l_sqlerrm);
   UNAPIGEN.U4COMMIT;
END HandleSaveScMethod;

FUNCTION HandleSaveScPaResult
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code            NUMBER;
a_nr_of_rows          NUMBER;
a_alarms_handled      CHAR(1);
a_sc                  UNAPIGEN.VC20_TABLE_TYPE;
a_pg                  UNAPIGEN.VC20_TABLE_TYPE;
a_pgnode              UNAPIGEN.LONG_TABLE_TYPE;
a_pa                  UNAPIGEN.VC20_TABLE_TYPE;
a_panode              UNAPIGEN.LONG_TABLE_TYPE;
a_value_f             UNAPIGEN.FLOAT_TABLE_TYPE;
a_value_s             UNAPIGEN.VC40_TABLE_TYPE;
a_unit                UNAPIGEN.VC20_TABLE_TYPE;
a_format              UNAPIGEN.VC40_TABLE_TYPE;
a_exec_end_date       UNAPIGEN.DATE_TABLE_TYPE;
a_executor            UNAPIGEN.VC20_TABLE_TYPE;
a_manually_entered    UNAPIGEN.CHAR1_TABLE_TYPE;
a_reanalysis          UNAPIGEN.NUM_TABLE_TYPE;
a_modify_flag         UNAPIGEN.NUM_TABLE_TYPE;
a_modify_reason       VARCHAR2(255);
l_debug               VARCHAR2(200);
l_sqlerrm             VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN
l_debug := 'current line';
l_curr_line := a_curr_line;

l_debug := 'arg14';
a_nr_of_rows := TO_NUMBER(a_curr_line.arg15);
l_debug := 'arg1';
a_alarms_handled := SUBSTR(l_curr_line.arg1, 1, 1);

l_debug := 'open cursor step';
OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP


   a_last_seq := l_curr_line.seq;
   l_debug := 'arg2';
   a_sc(x) := SUBSTR(l_curr_line.arg2, 1, 20);
   l_debug := 'arg3';
   a_pg(x) := SUBSTR(l_curr_line.arg3, 1, 20);
   l_debug := 'arg4';
   a_pgnode(x) := TO_NUMBER(l_curr_line.arg4);
   l_debug := 'arg5';
   a_pa(x) := SUBSTR(l_curr_line.arg5, 1, 20);
   l_debug := 'arg6';
   a_panode(x) := TO_NUMBER(l_curr_line.arg6);
   a_value_f(x) := TO_NUMBER(l_curr_line.arg7);
   l_debug := 'arg8';
   a_value_s(x) := SUBSTR(l_curr_line.arg8, 1, 40);
   a_unit(x) := SUBSTR(l_curr_line.arg9, 1, 20);
   l_debug := 'arg10';
   a_format(x) := SUBSTR(l_curr_line.arg10, 1, 40);
   l_debug := 'arg11';
   a_exec_end_date(x) := TO_TIMESTAMP_TZ(l_curr_line.arg11);
   a_executor(x) := SUBSTR(l_curr_line.arg12, 1, 20);
   a_manually_entered(x) := SUBSTR(l_curr_line.arg13, 1, 1);
   l_debug := 'arg14';
   a_reanalysis(x) := TO_NUMBER(l_curr_line.arg14);
   l_debug := 'modify_flag';
   a_modify_flag(x) := UNAPIGEN.MOD_FLAG_UPDATE;

   l_debug := 'Fetch next';
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;

END LOOP;
l_debug := 'arg15';
a_modify_reason := SUBSTR(a_curr_line.arg16, 1, 255);
l_debug :='calling unapipa';
l_ret_code := UNAPIPA.SaveScPaResult
                (a_alarms_handled, a_sc, a_pg, a_pgnode, a_pa, a_panode,
                  a_value_f, a_value_s, a_unit, a_format, a_exec_end_date,
                  a_executor, a_manually_entered, a_reanalysis, a_modify_flag,
                  a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := l_debug || '#seq=' || TO_CHAR(l_curr_line.seq)
               || '#' ||SUBSTR(SQLERRM,1,100);
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'HandleSaveScPaResult' , l_sqlerrm);
   UNAPIGEN.U4COMMIT;

END HandleSaveScPaResult;

FUNCTION HandleSaveScInfoCard
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code            NUMBER;
a_sc                  UNAPIGEN.VC20_TABLE_TYPE;
a_ic                  UNAPIGEN.VC20_TABLE_TYPE;
a_icnode              UNAPIGEN.LONG_TABLE_TYPE;
a_ip_version          UNAPIGEN.VC20_TABLE_TYPE;
a_description         UNAPIGEN.VC40_TABLE_TYPE;
a_winsize_x           UNAPIGEN.NUM_TABLE_TYPE;
a_winsize_y           UNAPIGEN.NUM_TABLE_TYPE;
a_is_protected        UNAPIGEN.CHAR1_TABLE_TYPE;
a_hidden              UNAPIGEN.CHAR1_TABLE_TYPE;
a_manually_added      UNAPIGEN.CHAR1_TABLE_TYPE;
a_next_ii             UNAPIGEN.VC20_TABLE_TYPE;
a_ic_class            UNAPIGEN.VC2_TABLE_TYPE;
a_log_hs              UNAPIGEN.CHAR1_TABLE_TYPE;
a_log_hs_details      UNAPIGEN.CHAR1_TABLE_TYPE;
a_lc                  UNAPIGEN.VC2_TABLE_TYPE;
a_lc_version          UNAPIGEN.VC20_TABLE_TYPE;
a_modify_flag         UNAPIGEN.NUM_TABLE_TYPE;
a_nr_of_rows          NUMBER;
a_modify_reason       VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_nr_of_rows := TO_NUMBER(a_curr_line.arg18);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP
   a_last_seq := l_curr_line.seq;

   a_sc(x) := SUBSTR(l_curr_line.arg1, 1, 20);
   a_ic(x) := SUBSTR(l_curr_line.arg2, 1, 20);
   a_icnode(x) := TO_NUMBER(l_curr_line.arg3);
   a_ip_version(x) := SUBSTR(l_curr_line.arg4, 1, 20);
   a_description(x) := SUBSTR(l_curr_line.arg5, 1, 40);
   a_winsize_x(x) := TO_NUMBER(l_curr_line.arg6);
   a_winsize_y(x) := TO_NUMBER(l_curr_line.arg7);
   a_is_protected(x) := SUBSTR(l_curr_line.arg8, 1, 1);
   a_hidden(x) := SUBSTR(l_curr_line.arg9, 1, 1);
   a_manually_added(x) := SUBSTR(l_curr_line.arg10, 1, 1);
   a_next_ii(x) := SUBSTR(l_curr_line.arg11, 1, 20);
   a_ic_class(x) := SUBSTR(l_curr_line.arg12, 1, 2);
   a_log_hs(x) := SUBSTR(l_curr_line.arg13, 1, 1);
   a_log_hs_details(x) := SUBSTR(l_curr_line.arg14, 1, 1);
   a_lc(x) := SUBSTR(l_curr_line.arg15, 1, 2);
   a_lc_version(x) := SUBSTR(l_curr_line.arg16, 1, 20);
   a_modify_flag(x) := TO_NUMBER(l_curr_line.arg17);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg19, 1, 255);

l_ret_code := UNAPIIC.SaveScInfoCard
                 (a_sc, a_ic, a_icnode, a_ip_version, a_description,
                  a_winsize_x, a_winsize_y, a_is_protected, a_hidden,
                  a_manually_added, a_next_ii, a_ic_class,
                  a_log_hs, a_log_hs_details, a_lc, a_lc_version,
                  a_modify_flag, a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveScInfoCard;

FUNCTION HandleSaveScInfoField
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code            NUMBER;
a_sc                  UNAPIGEN.VC20_TABLE_TYPE;
a_ic                  UNAPIGEN.VC20_TABLE_TYPE;
a_icnode              UNAPIGEN.LONG_TABLE_TYPE;
a_ii                  UNAPIGEN.VC20_TABLE_TYPE;
a_iinode              UNAPIGEN.LONG_TABLE_TYPE;
a_ie_version          UNAPIGEN.VC20_TABLE_TYPE;
a_iivalue             UNAPIGEN.VC2000_TABLE_TYPE;
a_pos_x               UNAPIGEN.NUM_TABLE_TYPE;
a_pos_y               UNAPIGEN.NUM_TABLE_TYPE;
a_is_protected        UNAPIGEN.CHAR1_TABLE_TYPE;
a_mandatory           UNAPIGEN.CHAR1_TABLE_TYPE;
a_hidden              UNAPIGEN.CHAR1_TABLE_TYPE;
a_dsp_title           UNAPIGEN.VC40_TABLE_TYPE;
a_dsp_len             UNAPIGEN.NUM_TABLE_TYPE;
a_dsp_tp              UNAPIGEN.CHAR1_TABLE_TYPE;
a_dsp_rows            UNAPIGEN.NUM_TABLE_TYPE;
a_ii_class            UNAPIGEN.VC2_TABLE_TYPE;
a_log_hs              UNAPIGEN.CHAR1_TABLE_TYPE;
a_log_hs_details      UNAPIGEN.CHAR1_TABLE_TYPE;
a_lc                  UNAPIGEN.VC2_TABLE_TYPE;
a_lc_version          UNAPIGEN.VC20_TABLE_TYPE;
a_modify_flag         UNAPIGEN.NUM_TABLE_TYPE;
a_nr_of_rows          NUMBER;
a_modify_reason       VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_nr_of_rows := TO_NUMBER(a_curr_line.arg23);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP
   a_last_seq := l_curr_line.seq;

   a_sc(x) := SUBSTR(l_curr_line.arg1, 1, 20);
   a_ic(x) := SUBSTR(l_curr_line.arg2, 1, 20);
   a_icnode(x) := TO_NUMBER(l_curr_line.arg3);
   a_ii(x) := SUBSTR(l_curr_line.arg4, 1, 20);
   a_iinode(x) := TO_NUMBER(l_curr_line.arg5);
   a_ie_version(x) := SUBSTR(l_curr_line.arg6, 1, 20);
   a_iivalue(x) := SUBSTR(l_curr_line.arg7, 1, 40);
   a_pos_x(x) := TO_NUMBER(l_curr_line.arg8);
   a_pos_y(x) := TO_NUMBER(l_curr_line.arg9);
   a_is_protected(x) := SUBSTR(l_curr_line.arg10, 1, 1);
   a_mandatory(x) := SUBSTR(l_curr_line.arg11, 1, 1);
   a_hidden(x) := SUBSTR(l_curr_line.arg12, 1, 1);
   a_dsp_title(x) := SUBSTR(l_curr_line.arg13, 1, 20);
   a_dsp_len(x) := TO_NUMBER(l_curr_line.arg14);
   a_dsp_tp(x) := SUBSTR(l_curr_line.arg15, 1, 1);
   a_dsp_rows(x) := TO_NUMBER(l_curr_line.arg16);
   a_ii_class(x) := SUBSTR(l_curr_line.arg17, 1, 2);
   a_log_hs(x) := SUBSTR(l_curr_line.arg18, 1, 1);
   a_log_hs_details(x) := SUBSTR(l_curr_line.arg19, 1, 1);
   a_lc(x) := SUBSTR(l_curr_line.arg20, 1, 2);
   a_lc_version(x) := SUBSTR(l_curr_line.arg21, 1, 20);
   a_modify_flag(x) := TO_NUMBER(l_curr_line.arg22);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;

END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg24, 1, 255);

l_ret_code := UNAPIIC.SaveScInfoField
                 (a_sc, a_ic, a_icnode, a_ii, a_iinode, a_ie_version,
                  a_iivalue, a_pos_x, a_pos_y, a_is_protected,
                  a_mandatory, a_hidden, a_dsp_title,
                  a_dsp_len, a_dsp_tp, a_dsp_rows, a_ii_class,
                  a_log_hs, a_log_hs_details, a_lc, a_lc_version,
                  a_modify_flag, a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveScInfoField;

FUNCTION HandleSaveScGroupkey
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code            NUMBER;
a_sc                  VARCHAR2(20);
a_gk                  UNAPIGEN.VC20_TABLE_TYPE;
a_gk_version          UNAPIGEN.VC20_TABLE_TYPE;
a_value               UNAPIGEN.VC40_TABLE_TYPE;
a_nr_of_rows          NUMBER;
a_modify_reason       VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_sc := SUBSTR(l_curr_line.arg1, 1, 20);
a_nr_of_rows := TO_NUMBER(a_curr_line.arg5);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP
   a_last_seq := l_curr_line.seq;

   a_gk(x) := SUBSTR(l_curr_line.arg2, 1, 20);
   a_gk_version(x) := SUBSTR(l_curr_line.arg3, 1, 20);
   a_value(x) := SUBSTR(l_curr_line.arg4, 1, 40);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;

END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg6, 1, 255);

l_ret_code := UNAPISCP.SaveScGroupKey
                (a_sc, a_gk, a_gk_version, a_value, a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveScGroupKey;

FUNCTION HandlePlanSample
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code                    NUMBER;
a_st                          VARCHAR2(20);
a_st_version                  VARCHAR2(20);
a_sc                          VARCHAR2(20);
a_ref_date                    TIMESTAMP WITH TIME ZONE;
a_create_ic                   VARCHAR2(40);
a_create_pg                   VARCHAR2(40);
a_userid                      VARCHAR2(40);
a_modify_reason               VARCHAR2(255);
a_fieldtype_tab               UNAPIGEN.VC20_TABLE_TYPE;
a_fieldnames_tab              UNAPIGEN.VC20_TABLE_TYPE;
a_fieldvalues_tab             UNAPIGEN.VC40_TABLE_TYPE;
a_field_nr_of_rows            NUMBER;

BEGIN

a_last_seq := a_curr_line.seq;

a_st := SUBSTR(a_curr_line.arg1, 1, 20);
a_st_version := SUBSTR(a_curr_line.arg2, 1, 20);
a_sc := SUBSTR(a_curr_line.arg3, 1, 20);
a_ref_date := TO_TIMESTAMP_TZ(a_curr_line.arg4);
a_create_ic := SUBSTR(a_curr_line.arg5, 1, 40);
a_create_pg := SUBSTR(a_curr_line.arg6, 1, 40);
a_userid := SUBSTR(a_curr_line.arg7, 1, 40);
a_modify_reason := SUBSTR(a_curr_line.arg8, 1, 255);
a_field_nr_of_rows := 0;

 l_ret_code := UNAPISC.PlanSample(a_st, a_st_version, a_sc, a_ref_date, a_create_ic,
                                   a_create_pg, a_userid,
                                   a_fieldtype_tab,
                                   a_fieldnames_tab,
                                   a_fieldvalues_tab,
                                   a_field_nr_of_rows,
                                   a_modify_reason);

RETURN(l_ret_code);

END HandlePlanSample;

END ulop;