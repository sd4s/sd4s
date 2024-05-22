--tracing van UNILAB-sessie voor bekijken van SAMPLE-RESULTS

--open REQUEST-LIST - MY-RQS-OUTDOOR

/* Formatted on 25/11/2021 10:03:23 (QP5 v5.374) */
DELETE FROM UTUPUSTKVALUELISTS
      WHERE UP = :B4 AND US = :B3 AND TK_TP = :B2 AND TK = :B1

/* Formatted on 25/11/2021 10:04:49 (QP5 v5.374) */
BEGIN
    :SUUTVL_retcode :=
        UNAPIUPP.SaveUpUsTaskValueLists ( :SUUTVL_up,
                                         :SUUTVL_us,
                                         :SUUTVL_tk_tp,
                                         :SUUTVL_tk,
                                         :SUUTVL_col_id,
                                         :SUUTVL_col_tp,
                                         :SUUTVL_seq,
                                         :SUUTVL_valueseq,
                                         :SUUTVL_value,
                                         :SUUTVL_nr_of_rows,
                                         :SUUTVL_next_rows);
END;

/* Formatted on 25/11/2021 10:04:58 (QP5 v5.374) */
BEGIN
    :SGKV_retcode :=
        UNAPIRQ.SelectRqGkValues ( :SGKV_col_id,
                                  :SGKV_col_tp,
                                  :SGKV_col_value,
                                  :SGKV_col_operator,
                                  :SGKV_col_andor,
                                  :SGKV_col_nr_of_rows,
                                  :SGKV_gk,
                                  :SGKV_value,
                                  :SGKV_nr_of_rows,
                                  :SGKV_order_by_clause,
                                  :SGKV_next_rows);
END;

/* Formatted on 25/11/2021 10:05:15 (QP5 v5.374) */
BEGIN
    :GETLY_retcode :=
        UNAPILY.GetLayout ( :GETLY_ly_tp,
                           :GETLY_ly,
                           :GETLY_col_id,
                           :GETLY_col_tp,
                           :GETLY_col_len,
                           :GETLY_disp_title,
                           :GETLY_disp_style,
                           :GETLY_disp_tp,
                           :GETLY_disp_width,
                           :GETLY_disp_format,
                           :GETLY_col_order,
                           :GETLY_col_asc,
                           :GETLY_nr_of_rows,
                           :GETLY_where_clause);
END;

/* Formatted on 25/11/2021 10:05:25 (QP5 v5.374) */
BEGIN
    :GETIE_retcode :=
        UNAPIIE.GetInfoField ( :GETIE_ie,
                              :GETIE_version,
                              :GETIE_version_is_current,
                              :GETIE_effective_from,
                              :GETIE_effective_till,
                              :GETIE_is_protected,
                              :GETIE_mandatory,
                              :GETIE_hidden,
                              :GETIE_data_tp,
                              :GETIE_format,
                              :GETIE_valid_cf,
                              :GETIE_def_val_tp,
                              :GETIE_def_au_level,
                              :GETIE_ievalue,
                              :GETIE_align,
                              :GETIE_dsp_title,
                              :GETIE_dsp_title2,
                              :GETIE_dsp_len,
                              :GETIE_dsp_tp,
                              :GETIE_dsp_rows,
                              :GETIE_look_up_ptr,
                              :GETIE_is_template,
                              :GETIE_multi_select,
                              :GETIE_sc_lc,
                              :GETIE_sc_lc_version,
                              :GETIE_inherit_au,
                              :GETIE_ie_class,
                              :GETIE_log_hs,
                              :GETIE_allow_modify,
                              :GETIE_active,
                              :GETIE_lc,
                              :GETIE_lc_version,
                              :GETIE_ss,
                              :GETIE_nr_of_rows,
                              :GETIE_where_clause);
END;

/* Formatted on 25/11/2021 10:05:50 (QP5 v5.374) */
BEGIN
    :GETIESQL_retcode :=
        UNAPIIE.GetInfoFieldSql ( :GETIESQL_ie,
                                 :GETIESQL_version,
                                 :GETIESQL_sqltext,
                                 :GETIESQL_nr_of_rows,
                                 :GETIESQL_where_clause);
END;


--REFRESH OP FILTER VANUIT REQUEST-LIST = MY-RQS-OUTDOOR

--per request een aparte query !!!!

/* Formatted on 25/11/2021 10:10:40 (QP5 v5.374) */
  SELECT rq,
         ic,
         icnode,
         ip_version,
         description,
         winsize_x,
         winsize_y,
         is_protected,
         hidden,
         manually_added,
         next_ii,
         ic_class,
         log_hs,
         log_hs_details,
         allow_modify,
         ar,
         active,
         lc,
         lc_version,
         ss
    FROM dd1.uvrqic
   WHERE rq = '21.167.PSC'
ORDER BY icnode

/* Formatted on 25/11/2021 10:10:55 (QP5 v5.374) */
  SELECT rq,
         ic,
         icnode,
         ip_version,
         description,
         winsize_x,
         winsize_y,
         is_protected,
         hidden,
         manually_added,
         next_ii,
         ic_class,
         log_hs,
         log_hs_details,
         allow_modify,
         ar,
         active,
         lc,
         lc_version,
         ss
    FROM dd1.uvrqic
   WHERE rq = '21.086.PSC'
ORDER BY icnode

==> LET OP: per REQUEST zien we hier de AUTHORISATION-ATTRIBUTES IS_PROTECTED, HIDDEN !!!!

/* Formatted on 25/11/2021 10:14:44 (QP5 v5.374) */
SELECT iesql.ie, iesql.version, iesql.sqltext
  FROM dd1.uviesql iesql
 WHERE     ie = 'avRqPlannedExeWeek'
       AND version =
           UNAPIGEN.USEVERSION ('ie', 'avRqPlannedExeWeek', '0001.07')
		   
/* Formatted on 25/11/2021 10:14:56 (QP5 v5.374) */
SELECT ie,
       version,
       NVL (version_is_current, '0'),
       effective_from,
       effective_till,
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       ie_class,
       log_hs,
       allow_modify,
       active,
       lc,
       lc_version,
       ss
  FROM dd1.uvie
 WHERE     ie = 'avRqRequiredReady'
       AND version =
           UNAPIGEN.USEVERSION ('ie', 'avRqRequiredReady', '~Current~')

/* Formatted on 25/11/2021 10:15:46 (QP5 v5.374) */
SELECT ie,
       version,
       NVL (version_is_current, '0'),
       effective_from,
       effective_till,
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       ie_class,
       log_hs,
       allow_modify,
       active,
       lc,
       lc_version,
       ss
  FROM dd1.uvie
 WHERE     ie = 'avRqPlannedExeWeek'
       AND version =
           UNAPIGEN.USEVERSION ('ie', 'avRqPlannedExeWeek', '~Current~')

/* Formatted on 25/11/2021 10:16:35 (QP5 v5.374) */
SELECT ie,
       version,
       NVL (version_is_current, '0'),
       effective_from,
       effective_till,
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       ie_class,
       log_hs,
       allow_modify,
       active,
       lc,
       lc_version,
       ss
  FROM dd1.uvie
 WHERE     ie = 'avRqDescription'
       AND version =
           UNAPIGEN.USEVERSION ('ie', 'avRqDescription', '~Current~')

/* Formatted on 25/11/2021 10:16:45 (QP5 v5.374) */
SELECT VERSION
  FROM UTIE
 WHERE IE = :B1 AND VERSION_IS_CURRENT = '1'

/* Formatted on 25/11/2021 10:16:55 (QP5 v5.374) */
SELECT ACTIVE
  FROM UTIE
 WHERE IE = :B2 AND VERSION = :B1

/* Formatted on 25/11/2021 10:17:10 (QP5 v5.374) */
BEGIN
    :GETRQII_retcode :=
        UNAPIRQ.GetRqInfoField ( :GETRQII_rq,
                                :GETRQII_ic,
                                :GETRQII_icnode,
                                :GETRQII_ii,
                                :GETRQII_iinode,
                                :GETRQII_ie_version,
                                :GETRQII_iivalue,
                                :GETRQII_pos_x,
                                :GETRQII_pos_y,
                                :GETRQII_is_protected,
                                :GETRQII_mandatory,
                                :GETRQII_hidden,
                                :GETRQII_dsp_title,
                                :GETRQII_dsp_len,
                                :GETRQII_dsp_tp,
                                :GETRQII_dsp_rows,
                                :GETRQII_ii_class,
                                :GETRQII_log_hs,
                                :GETRQII_log_hs_details,
                                :GETRQII_allow_modify,
                                :GETRQII_ar,
                                :GETRQII_active,
                                :GETRQII_lc,
                                :GETRQII_lc_version,
                                :GETRQII_ss,
                                :GETRQII_nr_of_rows,
                                :GETRQII_where_clause,
                                :GETRQII_next_rows);
END;

/* Formatted on 25/11/2021 10:17:35 (QP5 v5.374) */
BEGIN
    :GETRQIC_retcode :=
        UNAPIRQ.GetRqInfoCard ( :GETRQIC_rq,
                               :GETRQIC_ic,
                               :GETRQIC_icnode,
                               :GETRQIC_ip_version,
                               :GETRQIC_description,
                               :GETRQIC_winsize_x,
                               :GETRQIC_winsize_y,
                               :GETRQIC_is_protected,
                               :GETRQIC_hidden,
                               :GETRQIC_manually_added,
                               :GETRQIC_next_ii,
                               :GETRQIC_ic_class,
                               :GETRQIC_log_hs,
                               :GETRQIC_log_hs_details,
                               :GETRQIC_allow_modify,
                               :GETRQIC_ar,
                               :GETRQIC_active,
                               :GETRQIC_lc,
                               :GETRQIC_lc_version,
                               :GETRQIC_ss,
                               :GETRQIC_nr_of_rows,
                               :GETRQIC_where_clause);
END;

/* Formatted on 25/11/2021 10:17:46 (QP5 v5.374) */
BEGIN
    :GETIE_retcode :=
        UNAPIIE.GetInfoField ( :GETIE_ie,
                              :GETIE_version,
                              :GETIE_version_is_current,
                              :GETIE_effective_from,
                              :GETIE_effective_till,
                              :GETIE_is_protected,
                              :GETIE_mandatory,
                              :GETIE_hidden,
                              :GETIE_data_tp,
                              :GETIE_format,
                              :GETIE_valid_cf,
                              :GETIE_def_val_tp,
                              :GETIE_def_au_level,
                              :GETIE_ievalue,
                              :GETIE_align,
                              :GETIE_dsp_title,
                              :GETIE_dsp_title2,
                              :GETIE_dsp_len,
                              :GETIE_dsp_tp,
                              :GETIE_dsp_rows,
                              :GETIE_look_up_ptr,
                              :GETIE_is_template,
                              :GETIE_multi_select,
                              :GETIE_sc_lc,
                              :GETIE_sc_lc_version,
                              :GETIE_inherit_au,
                              :GETIE_ie_class,
                              :GETIE_log_hs,
                              :GETIE_allow_modify,
                              :GETIE_active,
                              :GETIE_lc,
                              :GETIE_lc_version,
                              :GETIE_ss,
                              :GETIE_nr_of_rows,
                              :GETIE_where_clause);
END;
 
/* Formatted on 25/11/2021 10:17:57 (QP5 v5.374) */
BEGIN
    :GETIESQL_retcode :=
        UNAPIIE.GetInfoFieldSql ( :GETIESQL_ie,
                                 :GETIESQL_version,
                                 :GETIESQL_sqltext,
                                 :GETIESQL_nr_of_rows,
                                 :GETIESQL_where_clause);
END;

--ANALYSIS-DETAILS VANUIT REQUEST

/* Formatted on 25/11/2021 10:21:57 (QP5 v5.374) */
  SELECT ly_tp,
         ly,
         col_id,
         col_tp,
         col_len,
         disp_title,
         disp_style,
         disp_tp,
         disp_width,
         disp_format,
         col_order,
         col_asc
    FROM dd1.uvly
   WHERE ly = 'avOutdoor' AND ly_tp = 'rqadlist'
ORDER BY seq

/* Formatted on 25/11/2021 10:23:28 (QP5 v5.374) */
SELECT iesql.ie, iesql.version, iesql.sqltext
  FROM dd1.uviesql iesql
 WHERE     ie = 'avPartNoRear'
       AND version = UNAPIGEN.USEVERSION ('ie', 'avPartNoRear', '0001.00')
	   
/* Formatted on 25/11/2021 10:23:39 (QP5 v5.374) */
SELECT iesql.ie, iesql.version, iesql.sqltext
  FROM dd1.uviesql iesql
 WHERE     ie = 'avPartNoOutdoor'
       AND version = UNAPIGEN.USEVERSION ('ie', 'avPartNoOutdoor', '0001.00')

/* Formatted on 25/11/2021 10:23:53 (QP5 v5.374) */
SELECT iesql.ie, iesql.version, iesql.sqltext
  FROM dd1.uviesql iesql
 WHERE     ie = 'avPartNoFront'
       AND version = UNAPIGEN.USEVERSION ('ie', 'avPartNoFront', '0001.00')

/* Formatted on 25/11/2021 10:24:01 (QP5 v5.374) */
SELECT iesql.ie, iesql.version, iesql.sqltext
  FROM dd1.uviesql iesql
 WHERE     ie = 'avPartDescLastLook'
       AND version =
           UNAPIGEN.USEVERSION ('ie', 'avPartDescLastLook', '0001.00')

/* Formatted on 25/11/2021 10:24:10 (QP5 v5.374) */
SELECT iesql.ie, iesql.version, iesql.sqltext
  FROM dd1.uviesql iesql
 WHERE     ie = 'avDesCons'
       AND version = UNAPIGEN.USEVERSION ('ie', 'avDesCons', '0001.00')

/* Formatted on 25/11/2021 10:24:18 (QP5 v5.374) */
SELECT ie,
       version,
       NVL (version_is_current, '0'),
       effective_from,
       effective_till,
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       ie_class,
       log_hs,
       allow_modify,
       active,
       lc,
       lc_version,
       ss
  FROM dd1.uvie
 WHERE     ie = 'avTreat'
       AND version = UNAPIGEN.USEVERSION ('ie', 'avTreat', '~Current~')

* Formatted on 25/11/2021 10:24:31 (QP5 v5.374) */
SELECT ie,
       version,
       NVL (version_is_current, '0'),
       effective_from,
       effective_till,
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       ie_class,
       log_hs,
       allow_modify,
       active,
       lc,
       lc_version,
       ss
  FROM dd1.uvie
 WHERE     ie = 'avRequestedTestSetup'
       AND version =
           UNAPIGEN.USEVERSION ('ie', 'avRequestedTestSetup', '~Current~')

/* Formatted on 25/11/2021 10:24:42 (QP5 v5.374) */
SELECT ie,
       version,
       NVL (version_is_current, '0'),
       effective_from,
       effective_till,
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       ie_class,
       log_hs,
       allow_modify,
       active,
       lc,
       lc_version,
       ss
  FROM dd1.uvie
 WHERE     ie = 'avPartNoRear'
       AND version = UNAPIGEN.USEVERSION ('ie', 'avPartNoRear', '~Current~')

/* Formatted on 25/11/2021 10:24:52 (QP5 v5.374) */
SELECT ie,
       version,
       NVL (version_is_current, '0'),
       effective_from,
       effective_till,
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       ie_class,
       log_hs,
       allow_modify,
       active,
       lc,
       lc_version,
       ss
  FROM dd1.uvie
 WHERE     ie = 'avPartNoOutdoor'
       AND version =
           UNAPIGEN.USEVERSION ('ie', 'avPartNoOutdoor', '~Current~')

/* Formatted on 25/11/2021 10:25:01 (QP5 v5.374) */
SELECT ie,
       version,
       NVL (version_is_current, '0'),
       effective_from,
       effective_till,
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       ie_class,
       log_hs,
       allow_modify,
       active,
       lc,
       lc_version,
       ss
  FROM dd1.uvie
 WHERE     ie = 'avPartNoFront'
       AND version = UNAPIGEN.USEVERSION ('ie', 'avPartNoFront', '~Current~')

/* Formatted on 25/11/2021 10:25:11 (QP5 v5.374) */
SELECT ie,
       version,
       NVL (version_is_current, '0'),
       effective_from,
       effective_till,
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       ie_class,
       log_hs,
       allow_modify,
       active,
       lc,
       lc_version,
       ss
  FROM dd1.uvie
 WHERE     ie = 'avPartDescLastLook'
       AND version =
           UNAPIGEN.USEVERSION ('ie', 'avPartDescLastLook', '~Current~')

/* Formatted on 25/11/2021 10:25:20 (QP5 v5.374) */
SELECT ie,
       version,
       NVL (version_is_current, '0'),
       effective_from,
       effective_till,
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       ie_class,
       log_hs,
       allow_modify,
       active,
       lc,
       lc_version,
       ss
  FROM dd1.uvie
 WHERE     ie = 'avDesCons'
       AND version = UNAPIGEN.USEVERSION ('ie', 'avDesCons', '~Current~')

/* Formatted on 25/11/2021 10:25:33 (QP5 v5.374) */
  SELECT a.sc,
         a.st,
         a.st_version,
         a.description,
         a.shelf_life_val,
         a.shelf_life_unit,
         a.sampling_date,
         a.creation_date,
         a.created_by,
         a.exec_start_date,
         a.exec_end_date,
         a.priority,
         a.label_format,
         a.descr_doc,
         a.descr_doc_version,
         a.rq,
         a.sd,
         a.date1,
         a.date2,
         a.date3,
         a.date4,
         a.date5,
         a.allow_any_pp,
         a.sc_class,
         a.log_hs,
         a.log_hs_details,
         a.allow_modify,
         a.active,
         a.lc,
         a.lc_version,
         a.ss,
         a.ar
    FROM dd1.uvsc a, utrqsc
   WHERE utrqsc.sc = a.sc AND utrqsc.rq = :rq_val
ORDER BY utrqsc.seq

/* Formatted on 25/11/2021 10:25:48 (QP5 v5.374) */
SELECT VERSION
  FROM UTIE
 WHERE IE = :B1 AND VERSION_IS_CURRENT = '1'

/* Formatted on 25/11/2021 10:26:18 (QP5 v5.374) */
SELECT ACTIVE
  FROM UTIE
 WHERE IE = :B2 AND VERSION = :B1

/* Formatted on 25/11/2021 10:26:28 (QP5 v5.374) */
  SELECT DISTINCT UVUPUS.us
    FROM UVUPUS
ORDER BY us ASC

/* Formatted on 25/11/2021 10:26:40 (QP5 v5.374) */
BEGIN
    :GETSC_retcode :=
        UNAPISC.GetSample ( :GETSC_sc,
                           :GETSC_st,
                           :GETSC_st_version,
                           :GETSC_description,
                           :GETSC_shelf_life_val,
                           :GETSC_shelf_life_unit,
                           :GETSC_sampling_date,
                           :GETSC_creation_date,
                           :GETSC_created_by,
                           :GETSC_exec_start_date,
                           :GETSC_exec_end_date,
                           :GETSC_priority,
                           :GETSC_label_format,
                           :GETSC_descr_doc,
                           :GETSC_descr_doc_version,
                           :GETSC_rq,
                           :GETSC_sd,
                           :GETSC_date1,
                           :GETSC_date2,
                           :GETSC_date3,
                           :GETSC_date4,
                           :GETSC_date5,
                           :GETSC_allow_any_pp,
                           :GETSC_sc_class,
                           :GETSC_log_hs,
                           :GETSC_log_hs_details,
                           :GETSC_allow_modify,
                           :GETSC_ar,
                           :GETSC_active,
                           :GETSC_lc,
                           :GETSC_lc_version,
                           :GETSC_ss,
                           :GETSC_nr_of_rows,
                           :GETSC_where_clause);
END;

/* Formatted on 25/11/2021 10:26:52 (QP5 v5.374) */
BEGIN
    :GETSCIE_retcode :=
        UNAPIIC.GetScInfoField ( :GETSCIE_sc,
                                :GETSCIE_ic,
                                :GETSCIE_icnode,
                                :GETSCIE_ii,
                                :GETSCIE_iinode,
                                :GETSCIE_ie_version,
                                :GETSCIE_iivalue,
                                :GETSCIE_pos_x,
                                :GETSCIE_pos_y,
                                :GETSCIE_is_protected,
                                :GETSCIE_mandatory,
                                :GETSCIE_hidden,
                                :GETSCIE_dsp_title,
                                :GETSCIE_dsp_len,
                                :GETSCIE_dsp_tp,
                                :GETSCIE_dsp_rows,
                                :GETSCIE_ii_class,
                                :GETSCIE_log_hs,
                                :GETSCIE_log_hs_details,
                                :GETSCIE_allow_modify,
                                :GETSCIE_ar,
                                :GETSCIE_active,
                                :GETSCIE_lc,
                                :GETSCIE_lc_version,
                                :GETSCIE_ss,
                                :GETSCIE_nr_of_rows,
                                :GETSCIE_where_clause,
                                :GETSCIE_next_rows);
END;

/* Formatted on 25/11/2021 10:27:01 (QP5 v5.374) */
BEGIN
    :GETSCIC_retcode :=
        UNAPIIC.GetScInfoCard ( :GETSCIC_sc,
                               :GETSCIC_ic,
                               :GETSCIC_icnode,
                               :GETSCIC_ip_version,
                               :GETSCIC_description,
                               :GETSCIC_winsize_x,
                               :GETSCIC_winsize_y,
                               :GETSCIC_is_protected,
                               :GETSCIC_hidden,
                               :GETSCIC_manually_added,
                               :GETSCIC_next_ii,
                               :GETSCIC_ic_class,
                               :GETSCIC_log_hs,
                               :GETSCIC_log_hs_details,
                               :GETSCIC_allow_modify,
                               :GETSCIC_ar,
                               :GETSCIC_active,
                               :GETSCIC_lc,
                               :GETSCIC_lc_version,
                               :GETSCIC_ss,
                               :GETSCIC_nr_of_rows,
                               :GETSCIC_where_clause);
END;

/* Formatted on 25/11/2021 10:27:13 (QP5 v5.374) */
BEGIN
    :GETRQPP_retcode :=
        UNAPIRQ.GetRqParameterProfile ( :GETRQPP_rq,
                                       :GETRQPP_pp,
                                       :GETRQPP_pp_version,
                                       :GETRQPP_pp_key1,
                                       :GETRQPP_pp_key2,
                                       :GETRQPP_pp_key3,
                                       :GETRQPP_pp_key4,
                                       :GETRQPP_pp_key5,
                                       :GETRQPP_description,
                                       :GETRQPP_delay,
                                       :GETRQPP_delay_unit,
                                       :GETRQPP_freq_tp,
                                       :GETRQPP_freq_val,
                                       :GETRQPP_freq_unit,
                                       :GETRQPP_invert_freq,
                                       :GETRQPP_last_sched,
                                       :GETRQPP_last_cnt,
                                       :GETRQPP_last_val,
                                       :GETRQPP_inherit_au,
                                       :GETRQPP_nr_of_rows,
                                       :GETRQPP_where_clause);
END;

/* Formatted on 25/11/2021 10:27:29 (QP5 v5.374) */
BEGIN
    :GETLY_retcode :=
        UNAPILY.GetLayout ( :GETLY_ly_tp,
                           :GETLY_ly,
                           :GETLY_col_id,
                           :GETLY_col_tp,
                           :GETLY_col_len,
                           :GETLY_disp_title,
                           :GETLY_disp_style,
                           :GETLY_disp_tp,
                           :GETLY_disp_width,
                           :GETLY_disp_format,
                           :GETLY_col_order,
                           :GETLY_col_asc,
                           :GETLY_nr_of_rows,
                           :GETLY_where_clause);
END;

/* Formatted on 25/11/2021 10:27:37 (QP5 v5.374) */
BEGIN
    :GETIE_retcode :=
        UNAPIIE.GetInfoField ( :GETIE_ie,
                              :GETIE_version,
                              :GETIE_version_is_current,
                              :GETIE_effective_from,
                              :GETIE_effective_till,
                              :GETIE_is_protected,
                              :GETIE_mandatory,
                              :GETIE_hidden,
                              :GETIE_data_tp,
                              :GETIE_format,
                              :GETIE_valid_cf,
                              :GETIE_def_val_tp,
                              :GETIE_def_au_level,
                              :GETIE_ievalue,
                              :GETIE_align,
                              :GETIE_dsp_title,
                              :GETIE_dsp_title2,
                              :GETIE_dsp_len,
                              :GETIE_dsp_tp,
                              :GETIE_dsp_rows,
                              :GETIE_look_up_ptr,
                              :GETIE_is_template,
                              :GETIE_multi_select,
                              :GETIE_sc_lc,
                              :GETIE_sc_lc_version,
                              :GETIE_inherit_au,
                              :GETIE_ie_class,
                              :GETIE_log_hs,
                              :GETIE_allow_modify,
                              :GETIE_active,
                              :GETIE_lc,
                              :GETIE_lc_version,
                              :GETIE_ss,
                              :GETIE_nr_of_rows,
                              :GETIE_where_clause);
END;

/* Formatted on 25/11/2021 10:27:47 (QP5 v5.374) */
BEGIN
    :GETIEVAL_retcode :=
        UNAPIIE.GetInfoFieldValue ( :GETIEVAL_ie,
                                   :GETIEVAL_version,
                                   :GETIEVAL_value,
                                   :GETIEVAL_nr_of_rows,
                                   :GETIEVAL_where_clause);
END;

/* Formatted on 25/11/2021 10:27:55 (QP5 v5.374) */
BEGIN
    :GETIESQL_retcode :=
        UNAPIIE.GetInfoFieldSql ( :GETIESQL_ie,
                                 :GETIESQL_version,
                                 :GETIESQL_sqltext,
                                 :GETIESQL_nr_of_rows,
                                 :GETIESQL_where_clause);
END;

/* Formatted on 25/11/2021 10:28:08 (QP5 v5.374) */
BEGIN
    :DML_retcode :=
        UNAPIGEN.UnExecDml ( :DML_dml_string,
                            :DML_dml_value,
                            :DML_nr_of_rows,
                            :DML_next_rows);
END;


--VANUIT REQUEST-LIST - ANALYSIS-DETAILS - SAMPLE KIES RESULTS

/* Formatted on 25/11/2021 10:30:01 (QP5 v5.374) */
  SELECT ly_tp,
         ly,
         col_id,
         col_tp,
         col_len,
         disp_title,
         disp_style,
         disp_tp,
         disp_width,
         disp_format,
         col_order,
         col_asc
    FROM dd1.uvly
   WHERE ly = 'avOutdoor' AND ly_tp = 'rqadlist'
ORDER BY seq

/* Formatted on 25/11/2021 10:30:14 (QP5 v5.374) */
  SELECT ly_tp,
         ly,
         col_id,
         col_tp,
         col_len,
         disp_title,
         disp_style,
         disp_tp,
         disp_width,
         disp_format,
         col_order,
         col_asc
    FROM dd1.uvly
   WHERE ly = 'avDef' AND ly_tp = 'scpg'
ORDER BY seq

/* Formatted on 25/11/2021 10:30:23 (QP5 v5.374) */
  SELECT ly_tp,
         ly,
         col_id,
         col_tp,
         col_len,
         disp_title,
         disp_style,
         disp_tp,
         disp_width,
         disp_format,
         col_order,
         col_asc
    FROM dd1.uvly
   WHERE ly = 'avDef' AND ly_tp = 'scpa'
ORDER BY seq

/* Formatted on 25/11/2021 10:30:36 (QP5 v5.374) */
  SELECT ly_tp,
         ly,
         col_id,
         col_tp,
         col_len,
         disp_title,
         disp_style,
         disp_tp,
         disp_width,
         disp_format,
         col_order,
         col_asc
    FROM dd1.uvly
   WHERE ly = 'avDef' AND ly_tp = 'scme'
ORDER BY seq

/* Formatted on 25/11/2021 10:30:47 (QP5 v5.374) */
SELECT ie,
       version,
       NVL (version_is_current, '0'),
       effective_from,
       effective_till,
       is_protected,
       mandatory,
       hidden,
       data_tp,
       format,
       valid_cf,
       def_val_tp,
       def_au_level,
       ievalue,
       align,
       dsp_title,
       dsp_title2,
       dsp_len,
       dsp_tp,
       dsp_rows,
       look_up_ptr,
       is_template,
       multi_select,
       sc_lc,
       sc_lc_version,
       inherit_au,
       ie_class,
       log_hs,
       allow_modify,
       active,
       lc,
       lc_version,
       ss
  FROM dd1.uvie
 WHERE     ie = 'avRequestedTestSetup'
       AND version =
           UNAPIGEN.USEVERSION ('ie', 'avRequestedTestSetup', '~Current~')
		   
/* Formatted on 25/11/2021 10:31:04 (QP5 v5.374) */
  SELECT a.sc,
         a.st,
         a.st_version,
         a.description,
         a.shelf_life_val,
         a.shelf_life_unit,
         a.sampling_date,
         a.creation_date,
         a.created_by,
         a.exec_start_date,
         a.exec_end_date,
         a.priority,
         a.label_format,
         a.descr_doc,
         a.descr_doc_version,
         a.rq,
         a.sd,
         a.date1,
         a.date2,
         a.date3,
         a.date4,
         a.date5,
         a.allow_any_pp,
         a.sc_class,
         a.log_hs,
         a.log_hs_details,
         a.allow_modify,
         a.active,
         a.lc,
         a.lc_version,
         a.ss,
         a.ar
    FROM dd1.uvsc a, utrqsc
   WHERE utrqsc.sc = a.sc AND utrqsc.rq = :rq_val
ORDER BY utrqsc.seq

/* Formatted on 25/11/2021 10:31:15 (QP5 v5.374) */
  SELECT a.sc,
         a.st,
         a.st_version,
         a.description,
         a.shelf_life_val,
         a.shelf_life_unit,
         a.sampling_date,
         a.creation_date,
         a.created_by,
         a.exec_start_date,
         a.exec_end_date,
         a.priority,
         a.label_format,
         a.descr_doc,
         a.descr_doc_version,
         a.rq,
         a.sd,
         a.date1,
         a.date2,
         a.date3,
         a.date4,
         a.date5,
         a.allow_any_pp,
         a.sc_class,
         a.log_hs,
         a.log_hs_details,
         a.allow_modify,
         a.active,
         a.lc,
         a.lc_version,
         a.ss,
         a.ar
    FROM dd1.uvsc a
   WHERE a.sc = :sc_val
ORDER BY sc

/* Formatted on 25/11/2021 10:31:40 (QP5 v5.374) */
SELECT VERSION
  FROM UTIE
 WHERE IE = :B1 AND VERSION_IS_CURRENT = '1'

/* Formatted on 25/11/2021 10:32:14 (QP5 v5.374) */
SELECT ACTIVE
  FROM UTIE
 WHERE IE = :B2 AND VERSION = :B1

/* Formatted on 25/11/2021 10:32:23 (QP5 v5.374) */
SELECT A.USER_SID,
       A.USER_NAME,
       A.APP_ID,
       A.APP_VERSION,
       A.APP_CUSTOM_PARAM,
       A.LIC_CHECK_APPLIES,
       A.LOGON_DATE,
       A.LAST_HEARTBEAT,
       A.LOGOFF_DATE,
       A.LOGON_STATION,
       A.AUDSID,
       A.INST_ID,
       A.ROWID
  FROM CTLICUSERCNT A
 WHERE     USER_SID = :B4
       AND APP_ID = :B3
       AND LOGON_STATION = :B2
       AND AUDSID = :B1

/* Formatted on 25/11/2021 10:32:44 (QP5 v5.374) */
BEGIN
    :GSCPASP_retcode :=
        UNAPIPA.GetScPaSpecs ( :GSCPASP_spec_set,
                              :GSCPASP_sc,
                              :GSCPASP_pg,
                              :GSCPASP_pgnode,
                              :GSCPASP_pa,
                              :GSCPASP_panode,
                              :GSCPASP_low_limit,
                              :GSCPASP_high_limit,
                              :GSCPASP_low_spec,
                              :GSCPASP_high_spec,
                              :GSCPASP_low_dev,
                              :GSCPASP_rel_low_dev,
                              :GSCPASP_target,
                              :GSCPASP_high_dev,
                              :GSCPASP_rel_high_dev,
                              :GSCPASP_nr_of_rows,
                              :GSCPASP_where_clause);
END;

/* Formatted on 25/11/2021 10:32:55 (QP5 v5.374) */
BEGIN
    :GETSC_retcode :=
        UNAPISC.GetSample ( :GETSC_sc,
                           :GETSC_st,
                           :GETSC_st_version,
                           :GETSC_description,
                           :GETSC_shelf_life_val,
                           :GETSC_shelf_life_unit,
                           :GETSC_sampling_date,
                           :GETSC_creation_date,
                           :GETSC_created_by,
                           :GETSC_exec_start_date,
                           :GETSC_exec_end_date,
                           :GETSC_priority,
                           :GETSC_label_format,
                           :GETSC_descr_doc,
                           :GETSC_descr_doc_version,
                           :GETSC_rq,
                           :GETSC_sd,
                           :GETSC_date1,
                           :GETSC_date2,
                           :GETSC_date3,
                           :GETSC_date4,
                           :GETSC_date5,
                           :GETSC_allow_any_pp,
                           :GETSC_sc_class,
                           :GETSC_log_hs,
                           :GETSC_log_hs_details,
                           :GETSC_allow_modify,
                           :GETSC_ar,
                           :GETSC_active,
                           :GETSC_lc,
                           :GETSC_lc_version,
                           :GETSC_ss,
                           :GETSC_nr_of_rows,
                           :GETSC_where_clause);
END;

/* Formatted on 25/11/2021 10:33:07 (QP5 v5.374) */
BEGIN
    :GETSCPG_retcode :=
        UNAPIPG.GetScParameterGroup ( :GETSCPG_sc,
                                     :GETSCPG_pg,
                                     :GETSCPG_pgnode,
                                     :GETSCPG_pp_version,
                                     :GETSCPG_pp_key1,
                                     :GETSCPG_pp_key2,
                                     :GETSCPG_pp_key3,
                                     :GETSCPG_pp_key4,
                                     :GETSCPG_pp_key5,
                                     :GETSCPG_description,
                                     :GETSCPG_value_f,
                                     :GETSCPG_value_s,
                                     :GETSCPG_unit,
                                     :GETSCPG_exec_start_date,
                                     :GETSCPG_exec_end_date,
                                     :GETSCPG_executor,
                                     :GETSCPG_planned_executor,
                                     :GETSCPG_manually_entered,
                                     :GETSCPG_assign_date,
                                     :GETSCPG_assigned_by,
                                     :GETSCPG_manually_added,
                                     :GETSCPG_format,
                                     :GETSCPG_confirm_assign,
                                     :GETSCPG_allow_any_pr,
                                     :GETSCPG_never_create_methods,
                                     :GETSCPG_delay,
                                     :GETSCPG_delay_unit,
                                     :GETSCPG_log_hs,
                                     :GETSCPG_log_hs_details,
                                     :GETSCPG_reanalysis,
                                     :GETSCPG_pg_class,
                                     :GETSCPG_allow_modify,
                                     :GETSCPG_active,
                                     :GETSCPG_lc,
                                     :GETSCPG_lc_version,
                                     :GETSCPG_ss,
                                     :GETSCPG_nr_of_rows,
                                     :GETSCPG_where_clause);
END;

/* Formatted on 25/11/2021 10:33:19 (QP5 v5.374) */
BEGIN
    :GETSCPA_retcode :=
        UNAPIPA.GetScParameter ( :GETSCPA_sc,
                                :GETSCPA_pg,
                                :GETSCPA_pgnode,
                                :GETSCPA_pa,
                                :GETSCPA_panode,
                                :GETSCPA_pr_version,
                                :GETSCPA_description,
                                :GETSCPA_value_f,
                                :GETSCPA_value_s,
                                :GETSCPA_unit,
                                :GETSCPA_exec_start_date,
                                :GETSCPA_exec_end_date,
                                :GETSCPA_executor,
                                :GETSCPA_planned_executor,
                                :GETSCPA_manually_entered,
                                :GETSCPA_assign_date,
                                :GETSCPA_assigned_by,
                                :GETSCPA_manually_added,
                                :GETSCPA_format,
                                :GETSCPA_td_info,
                                :GETSCPA_td_info_unit,
                                :GETSCPA_confirm_uid,
                                :GETSCPA_allow_any_me,
                                :GETSCPA_delay,
                                :GETSCPA_delay_unit,
                                :GETSCPA_min_nr_results,
                                :GETSCPA_calc_method,
                                :GETSCPA_calc_cf,
                                :GETSCPA_alarm_order,
                                :GETSCPA_valid_specsa,
                                :GETSCPA_valid_specsb,
                                :GETSCPA_valid_specsc,
                                :GETSCPA_valid_limitsa,
                                :GETSCPA_valid_limitsb,
                                :GETSCPA_valid_limitsc,
                                :GETSCPA_valid_targeta,
                                :GETSCPA_valid_targetb,
                                :GETSCPA_valid_targetc,
                                :GETSCPA_log_exceptions,
                                :GETSCPA_reanalysis,
                                :GETSCPA_pa_class,
                                :GETSCPA_log_hs,
                                :GETSCPA_log_hs_details,
                                :GETSCPA_allow_modify,
                                :GETSCPA_active,
                                :GETSCPA_lc,
                                :GETSCPA_lc_version,
                                :GETSCPA_ss,
                                :GETSCPA_nr_of_rows,
                                :GETSCPA_where_clause);
END;

/* Formatted on 25/11/2021 10:33:29 (QP5 v5.374) */
BEGIN
    :GETSCME_retcode :=
        UNAPIME.GetScMethod ( :GETSCME_sc,
                             :GETSCME_pg,
                             :GETSCME_pgnode,
                             :GETSCME_pa,
                             :GETSCME_panode,
                             :GETSCME_me,
                             :GETSCME_menode,
                             :GETSCME_reanalysis,
                             :GETSCME_mt_version,
                             :GETSCME_description,
                             :GETSCME_value_f,
                             :GETSCME_value_s,
                             :GETSCME_unit,
                             :GETSCME_exec_start_date,
                             :GETSCME_exec_end_date,
                             :GETSCME_executor,
                             :GETSCME_lab,
                             :GETSCME_eq,
                             :GETSCME_eq_version,
                             :GETSCME_planned_executor,
                             :GETSCME_planned_eq,
                             :GETSCME_planned_eq_version,
                             :GETSCME_manually_entered,
                             :GETSCME_allow_add,
                             :GETSCME_assign_date,
                             :GETSCME_assigned_by,
                             :GETSCME_manually_added,
                             :GETSCME_delay,
                             :GETSCME_delay_unit,
                             :GETSCME_format,
                             :GETSCME_accuracy,
                             :GETSCME_real_cost,
                             :GETSCME_real_time,
                             :GETSCME_calibration,
                             :GETSCME_confirm_complete,
                             :GETSCME_autorecalc,
                             :GETSCME_me_result_editable,
                             :GETSCME_next_cell,
                             :GETSCME_sop,
                             :GETSCME_sop_version,
                             :GETSCME_plaus_low,
                             :GETSCME_plaus_high,
                             :GETSCME_winsize_x,
                             :GETSCME_winsize_y,
                             :GETSCME_me_class,
                             :GETSCME_log_hs,
                             :GETSCME_log_hs_details,
                             :GETSCME_allow_modify,
                             :GETSCME_ar,
                             :GETSCME_active,
                             :GETSCME_lc,
                             :GETSCME_lc_version,
                             :GETSCME_ss,
                             :GETSCME_reanalysedresult,
                             :GETSCME_nr_of_rows,
                             :GETSCME_where_clause);
END;

/* Formatted on 25/11/2021 10:33:39 (QP5 v5.374) */
BEGIN
    :GETSCIE_retcode :=
        UNAPIIC.GetScInfoField ( :GETSCIE_sc,
                                :GETSCIE_ic,
                                :GETSCIE_icnode,
                                :GETSCIE_ii,
                                :GETSCIE_iinode,
                                :GETSCIE_ie_version,
                                :GETSCIE_iivalue,
                                :GETSCIE_pos_x,
                                :GETSCIE_pos_y,
                                :GETSCIE_is_protected,
                                :GETSCIE_mandatory,
                                :GETSCIE_hidden,
                                :GETSCIE_dsp_title,
                                :GETSCIE_dsp_len,
                                :GETSCIE_dsp_tp,
                                :GETSCIE_dsp_rows,
                                :GETSCIE_ii_class,
                                :GETSCIE_log_hs,
                                :GETSCIE_log_hs_details,
                                :GETSCIE_allow_modify,
                                :GETSCIE_ar,
                                :GETSCIE_active,
                                :GETSCIE_lc,
                                :GETSCIE_lc_version,
                                :GETSCIE_ss,
                                :GETSCIE_nr_of_rows,
                                :GETSCIE_where_clause,
                                :GETSCIE_next_rows);
END;

/* Formatted on 25/11/2021 10:33:48 (QP5 v5.374) */
BEGIN
    :GETSCIC_retcode :=
        UNAPIIC.GetScInfoCard ( :GETSCIC_sc,
                               :GETSCIC_ic,
                               :GETSCIC_icnode,
                               :GETSCIC_ip_version,
                               :GETSCIC_description,
                               :GETSCIC_winsize_x,
                               :GETSCIC_winsize_y,
                               :GETSCIC_is_protected,
                               :GETSCIC_hidden,
                               :GETSCIC_manually_added,
                               :GETSCIC_next_ii,
                               :GETSCIC_ic_class,
                               :GETSCIC_log_hs,
                               :GETSCIC_log_hs_details,
                               :GETSCIC_allow_modify,
                               :GETSCIC_ar,
                               :GETSCIC_active,
                               :GETSCIC_lc,
                               :GETSCIC_lc_version,
                               :GETSCIC_ss,
                               :GETSCIC_nr_of_rows,
                               :GETSCIC_where_clause);
END;

/* Formatted on 25/11/2021 10:33:57 (QP5 v5.374) */
BEGIN
    :GETRQPP_retcode :=
        UNAPIRQ.GetRqParameterProfile ( :GETRQPP_rq,
                                       :GETRQPP_pp,
                                       :GETRQPP_pp_version,
                                       :GETRQPP_pp_key1,
                                       :GETRQPP_pp_key2,
                                       :GETRQPP_pp_key3,
                                       :GETRQPP_pp_key4,
                                       :GETRQPP_pp_key5,
                                       :GETRQPP_description,
                                       :GETRQPP_delay,
                                       :GETRQPP_delay_unit,
                                       :GETRQPP_freq_tp,
                                       :GETRQPP_freq_val,
                                       :GETRQPP_freq_unit,
                                       :GETRQPP_invert_freq,
                                       :GETRQPP_last_sched,
                                       :GETRQPP_last_cnt,
                                       :GETRQPP_last_val,
                                       :GETRQPP_inherit_au,
                                       :GETRQPP_nr_of_rows,
                                       :GETRQPP_where_clause);
END;

/* Formatted on 25/11/2021 10:34:08 (QP5 v5.374) */
BEGIN
    :GETLY_retcode :=
        UNAPILY.GetLayout ( :GETLY_ly_tp,
                           :GETLY_ly,
                           :GETLY_col_id,
                           :GETLY_col_tp,
                           :GETLY_col_len,
                           :GETLY_disp_title,
                           :GETLY_disp_style,
                           :GETLY_disp_tp,
                           :GETLY_disp_width,
                           :GETLY_disp_format,
                           :GETLY_col_order,
                           :GETLY_col_asc,
                           :GETLY_nr_of_rows,
                           :GETLY_where_clause);
END;

/* Formatted on 25/11/2021 10:34:17 (QP5 v5.374) */
BEGIN
    :GETIE_retcode :=
        UNAPIIE.GetInfoField ( :GETIE_ie,
                              :GETIE_version,
                              :GETIE_version_is_current,
                              :GETIE_effective_from,
                              :GETIE_effective_till,
                              :GETIE_is_protected,
                              :GETIE_mandatory,
                              :GETIE_hidden,
                              :GETIE_data_tp,
                              :GETIE_format,
                              :GETIE_valid_cf,
                              :GETIE_def_val_tp,
                              :GETIE_def_au_level,
                              :GETIE_ievalue,
                              :GETIE_align,
                              :GETIE_dsp_title,
                              :GETIE_dsp_title2,
                              :GETIE_dsp_len,
                              :GETIE_dsp_tp,
                              :GETIE_dsp_rows,
                              :GETIE_look_up_ptr,
                              :GETIE_is_template,
                              :GETIE_multi_select,
                              :GETIE_sc_lc,
                              :GETIE_sc_lc_version,
                              :GETIE_inherit_au,
                              :GETIE_ie_class,
                              :GETIE_log_hs,
                              :GETIE_allow_modify,
                              :GETIE_active,
                              :GETIE_lc,
                              :GETIE_lc_version,
                              :GETIE_ss,
                              :GETIE_nr_of_rows,
                              :GETIE_where_clause);
END;

/* Formatted on 25/11/2021 10:34:26 (QP5 v5.374) */
BEGIN
    :GETIEVAL_retcode :=
        UNAPIIE.GetInfoFieldValue ( :GETIEVAL_ie,
                                   :GETIEVAL_version,
                                   :GETIEVAL_value,
                                   :GETIEVAL_nr_of_rows,
                                   :GETIEVAL_where_clause);
END;

	   
--**************************************************************
--**************************************************************
--RMK op METHODE-ATTIRBUUT-PROMPT = DESCRIPTION
--**************************************************************
--**************************************************************
/* Formatted on 25/11/2021 10:39:38 (QP5 v5.374) */
BEGIN
    :GSCPACL_retcode :=
        UNAPIPA.GetScPaChartList ( :GSCPACL_sc,
                                  :GSCPACL_pg,
                                  :GSCPACL_pgnode,
                                  :GSCPACL_pa,
                                  :GSCPACL_panode,
                                  :GSCPACL_ch,
                                  :GSCPACL_cy,
                                  :GSCPACL_cy_version,
                                  :GSCPACL_description,
                                  :GSCPACL_creation_date,
                                  :GSCPACL_ch_context_key,
                                  :GSCPACL_visual_cf,
                                  :GSCPACL_ss,
                                  :GSCPACL_nr_of_rows);
END;

/* Formatted on 25/11/2021 10:39:49 (QP5 v5.374) */
BEGIN
    :GSCPASP_retcode :=
        UNAPIPA.GetScPaSpecs ( :GSCPASP_spec_set,
                              :GSCPASP_sc,
                              :GSCPASP_pg,
                              :GSCPASP_pgnode,
                              :GSCPASP_pa,
                              :GSCPASP_panode,
                              :GSCPASP_low_limit,
                              :GSCPASP_high_limit,
                              :GSCPASP_low_spec,
                              :GSCPASP_high_spec,
                              :GSCPASP_low_dev,
                              :GSCPASP_rel_low_dev,
                              :GSCPASP_target,
                              :GSCPASP_high_dev,
                              :GSCPASP_rel_high_dev,
                              :GSCPASP_nr_of_rows,
                              :GSCPASP_where_clause);
END;

/* Formatted on 25/11/2021 10:40:08 (QP5 v5.374) */
SELECT EXEC_END_DATE, PR_VERSION
  FROM UTSCPA
 WHERE SC = :B5 AND PG = :B4 AND PGNODE = :B3 AND PA = :B2 AND PANODE = :B1
 
/* Formatted on 25/11/2021 10:40:24 (QP5 v5.374) */
SELECT MAX (DECODE (VERSION_IS_CURRENT, '1', VERSION, NULL))
           CURRENT_VERSION,
       MAX (DECODE (ACTIVE, '1', VERSION, NULL))
           MAX_ACTIVE_VERSION,
       MAX (VERSION)
           MAX_INACTIVE_VERSION
  FROM UTPR
 WHERE PR = :B2 AND VERSION LIKE :B1

/* Formatted on 25/11/2021 10:40:36 (QP5 v5.374) */
SELECT PP_VERSION,
       PP_KEY1,
       PP_KEY2,
       PP_KEY3,
       PP_KEY4,
       PP_KEY5
  FROM UTSCPG
 WHERE SC = :B3 AND PG = :B2 AND PGNODE = :B1
 
 
--**************************************************************
--**************************************************************
--RMK op PARAMETER-ATTIRBUUT-PROMPT = PARAMETER
--**************************************************************
--**************************************************************

/* Formatted on 25/11/2021 10:42:18 (QP5 v5.374) */
  SELECT DISTINCT CY, CY_VERSION
    FROM UTPRCYST
   WHERE     PR = :B3
         AND VERSION = NVL ( :B4, UNAPIGEN.USEVERSION ('pr', :B3, '*'))
         AND NVL (ST, :B2) = :B2
         AND NVL (DECODE (ST_VERSION, '~Current~', NULL, ST_VERSION), :B1) =
             :B1
ORDER BY CY

/* Formatted on 25/11/2021 10:43:47 (QP5 v5.374) */
BEGIN
    :GSCPASP_retcode :=
        UNAPIPA.GetScPaSpecs ( :GSCPASP_spec_set,
                              :GSCPASP_sc,
                              :GSCPASP_pg,
                              :GSCPASP_pgnode,
                              :GSCPASP_pa,
                              :GSCPASP_panode,
                              :GSCPASP_low_limit,
                              :GSCPASP_high_limit,
                              :GSCPASP_low_spec,
                              :GSCPASP_high_spec,
                              :GSCPASP_low_dev,
                              :GSCPASP_rel_low_dev,
                              :GSCPASP_target,
                              :GSCPASP_high_dev,
                              :GSCPASP_rel_high_dev,
                              :GSCPASP_nr_of_rows,
                              :GSCPASP_where_clause);
END;

/* Formatted on 25/11/2021 10:43:58 (QP5 v5.374) */
BEGIN
    :GSCPACL_retcode :=
        UNAPIPA.GetScPaChartList ( :GSCPACL_sc,
                                  :GSCPACL_pg,
                                  :GSCPACL_pgnode,
                                  :GSCPACL_pa,
                                  :GSCPACL_panode,
                                  :GSCPACL_ch,
                                  :GSCPACL_cy,
                                  :GSCPACL_cy_version,
                                  :GSCPACL_description,
                                  :GSCPACL_creation_date,
                                  :GSCPACL_ch_context_key,
                                  :GSCPACL_visual_cf,
                                  :GSCPACL_ss,
                                  :GSCPACL_nr_of_rows);
END;

/* Formatted on 25/11/2021 10:44:06 (QP5 v5.374) */
BEGIN
    :GETSC_retcode :=
        UNAPISC.GetSample ( :GETSC_sc,
                           :GETSC_st,
                           :GETSC_st_version,
                           :GETSC_description,
                           :GETSC_shelf_life_val,
                           :GETSC_shelf_life_unit,
                           :GETSC_sampling_date,
                           :GETSC_creation_date,
                           :GETSC_created_by,
                           :GETSC_exec_start_date,
                           :GETSC_exec_end_date,
                           :GETSC_priority,
                           :GETSC_label_format,
                           :GETSC_descr_doc,
                           :GETSC_descr_doc_version,
                           :GETSC_rq,
                           :GETSC_sd,
                           :GETSC_date1,
                           :GETSC_date2,
                           :GETSC_date3,
                           :GETSC_date4,
                           :GETSC_date5,
                           :GETSC_allow_any_pp,
                           :GETSC_sc_class,
                           :GETSC_log_hs,
                           :GETSC_log_hs_details,
                           :GETSC_allow_modify,
                           :GETSC_ar,
                           :GETSC_active,
                           :GETSC_lc,
                           :GETSC_lc_version,
                           :GETSC_ss,
                           :GETSC_nr_of_rows,
                           :GETSC_where_clause);
END;

/* Formatted on 25/11/2021 10:44:17 (QP5 v5.374) */
BEGIN
    :GETSCPG_retcode :=
        UNAPIPG.GetScParameterGroup ( :GETSCPG_sc,
                                     :GETSCPG_pg,
                                     :GETSCPG_pgnode,
                                     :GETSCPG_pp_version,
                                     :GETSCPG_pp_key1,
                                     :GETSCPG_pp_key2,
                                     :GETSCPG_pp_key3,
                                     :GETSCPG_pp_key4,
                                     :GETSCPG_pp_key5,
                                     :GETSCPG_description,
                                     :GETSCPG_value_f,
                                     :GETSCPG_value_s,
                                     :GETSCPG_unit,
                                     :GETSCPG_exec_start_date,
                                     :GETSCPG_exec_end_date,
                                     :GETSCPG_executor,
                                     :GETSCPG_planned_executor,
                                     :GETSCPG_manually_entered,
                                     :GETSCPG_assign_date,
                                     :GETSCPG_assigned_by,
                                     :GETSCPG_manually_added,
                                     :GETSCPG_format,
                                     :GETSCPG_confirm_assign,
                                     :GETSCPG_allow_any_pr,
                                     :GETSCPG_never_create_methods,
                                     :GETSCPG_delay,
                                     :GETSCPG_delay_unit,
                                     :GETSCPG_log_hs,
                                     :GETSCPG_log_hs_details,
                                     :GETSCPG_reanalysis,
                                     :GETSCPG_pg_class,
                                     :GETSCPG_allow_modify,
                                     :GETSCPG_active,
                                     :GETSCPG_lc,
                                     :GETSCPG_lc_version,
                                     :GETSCPG_ss,
                                     :GETSCPG_nr_of_rows,
                                     :GETSCPG_where_clause);
END;

/* Formatted on 25/11/2021 10:44:25 (QP5 v5.374) */
BEGIN
    :GETSCPA_retcode :=
        UNAPIPA.GetScParameter ( :GETSCPA_sc,
                                :GETSCPA_pg,
                                :GETSCPA_pgnode,
                                :GETSCPA_pa,
                                :GETSCPA_panode,
                                :GETSCPA_pr_version,
                                :GETSCPA_description,
                                :GETSCPA_value_f,
                                :GETSCPA_value_s,
                                :GETSCPA_unit,
                                :GETSCPA_exec_start_date,
                                :GETSCPA_exec_end_date,
                                :GETSCPA_executor,
                                :GETSCPA_planned_executor,
                                :GETSCPA_manually_entered,
                                :GETSCPA_assign_date,
                                :GETSCPA_assigned_by,
                                :GETSCPA_manually_added,
                                :GETSCPA_format,
                                :GETSCPA_td_info,
                                :GETSCPA_td_info_unit,
                                :GETSCPA_confirm_uid,
                                :GETSCPA_allow_any_me,
                                :GETSCPA_delay,
                                :GETSCPA_delay_unit,
                                :GETSCPA_min_nr_results,
                                :GETSCPA_calc_method,
                                :GETSCPA_calc_cf,
                                :GETSCPA_alarm_order,
                                :GETSCPA_valid_specsa,
                                :GETSCPA_valid_specsb,
                                :GETSCPA_valid_specsc,
                                :GETSCPA_valid_limitsa,
                                :GETSCPA_valid_limitsb,
                                :GETSCPA_valid_limitsc,
                                :GETSCPA_valid_targeta,
                                :GETSCPA_valid_targetb,
                                :GETSCPA_valid_targetc,
                                :GETSCPA_log_exceptions,
                                :GETSCPA_reanalysis,
                                :GETSCPA_pa_class,
                                :GETSCPA_log_hs,
                                :GETSCPA_log_hs_details,
                                :GETSCPA_allow_modify,
                                :GETSCPA_active,
                                :GETSCPA_lc,
                                :GETSCPA_lc_version,
                                :GETSCPA_ss,
                                :GETSCPA_nr_of_rows,
                                :GETSCPA_where_clause);
END;

/* Formatted on 25/11/2021 10:44:36 (QP5 v5.374) */
BEGIN
    :GETSCME_retcode :=
        UNAPIME.GetScMethod ( :GETSCME_sc,
                             :GETSCME_pg,
                             :GETSCME_pgnode,
                             :GETSCME_pa,
                             :GETSCME_panode,
                             :GETSCME_me,
                             :GETSCME_menode,
                             :GETSCME_reanalysis,
                             :GETSCME_mt_version,
                             :GETSCME_description,
                             :GETSCME_value_f,
                             :GETSCME_value_s,
                             :GETSCME_unit,
                             :GETSCME_exec_start_date,
                             :GETSCME_exec_end_date,
                             :GETSCME_executor,
                             :GETSCME_lab,
                             :GETSCME_eq,
                             :GETSCME_eq_version,
                             :GETSCME_planned_executor,
                             :GETSCME_planned_eq,
                             :GETSCME_planned_eq_version,
                             :GETSCME_manually_entered,
                             :GETSCME_allow_add,
                             :GETSCME_assign_date,
                             :GETSCME_assigned_by,
                             :GETSCME_manually_added,
                             :GETSCME_delay,
                             :GETSCME_delay_unit,
                             :GETSCME_format,
                             :GETSCME_accuracy,
                             :GETSCME_real_cost,
                             :GETSCME_real_time,
                             :GETSCME_calibration,
                             :GETSCME_confirm_complete,
                             :GETSCME_autorecalc,
                             :GETSCME_me_result_editable,
                             :GETSCME_next_cell,
                             :GETSCME_sop,
                             :GETSCME_sop_version,
                             :GETSCME_plaus_low,
                             :GETSCME_plaus_high,
                             :GETSCME_winsize_x,
                             :GETSCME_winsize_y,
                             :GETSCME_me_class,
                             :GETSCME_log_hs,
                             :GETSCME_log_hs_details,
                             :GETSCME_allow_modify,
                             :GETSCME_ar,
                             :GETSCME_active,
                             :GETSCME_lc,
                             :GETSCME_lc_version,
                             :GETSCME_ss,
                             :GETSCME_reanalysedresult,
                             :GETSCME_nr_of_rows,
                             :GETSCME_where_clause);
END;

/* Formatted on 25/11/2021 10:44:46 (QP5 v5.374) */
BEGIN
    :GETLY_retcode :=
        UNAPILY.GetLayout ( :GETLY_ly_tp,
                           :GETLY_ly,
                           :GETLY_col_id,
                           :GETLY_col_tp,
                           :GETLY_col_len,
                           :GETLY_disp_title,
                           :GETLY_disp_style,
                           :GETLY_disp_tp,
                           :GETLY_disp_width,
                           :GETLY_disp_format,
                           :GETLY_col_order,
                           :GETLY_col_asc,
                           :GETLY_nr_of_rows,
                           :GETLY_where_clause);
END;

--klik nogmaals op METHODE-DESCRIPTION: GEEN VERSCHIL
--KLIK NOGMAALS OP PARAMETER-PARAMETER: WEL NIEUWE QUERIES:

/* Formatted on 25/11/2021 10:48:33 (QP5 v5.374) */
SELECT ST, ST_VERSION
  FROM UTSC
 WHERE SC = :B1
 
/* Formatted on 25/11/2021 10:48:49 (QP5 v5.374) */
SELECT PP_VERSION,
       PP_KEY1,
       PP_KEY2,
       PP_KEY3,
       PP_KEY4,
       PP_KEY5
  FROM UTSCPG
 WHERE SC = :B3 AND PG = :B2 AND PGNODE = :B1

/* Formatted on 25/11/2021 10:48:59 (QP5 v5.374) */
SELECT MAX (DECODE (VERSION_IS_CURRENT, '1', VERSION, NULL))
           CURRENT_VERSION,
       MAX (DECODE (ACTIVE, '1', VERSION, NULL))
           MAX_ACTIVE_VERSION,
       MAX (VERSION)
           MAX_INACTIVE_VERSION
  FROM UTPR
 WHERE PR = :B2 AND VERSION LIKE :B1
 
/* Formatted on 25/11/2021 10:49:08 (QP5 v5.374) */
SELECT EXEC_END_DATE, PR_VERSION
  FROM UTSCPA
 WHERE SC = :B5 AND PG = :B4 AND PGNODE = :B3 AND PA = :B2 AND PANODE = :B1

/* Formatted on 25/11/2021 10:49:22 (QP5 v5.374) */
  SELECT DISTINCT CY, CY_VERSION
    FROM UTPRCYST
   WHERE     PR = :B3
         AND VERSION = NVL ( :B4, UNAPIGEN.USEVERSION ('pr', :B3, '*'))
         AND NVL (ST, :B2) = :B2
         AND NVL (DECODE (ST_VERSION, '~Current~', NULL, ST_VERSION), :B1) =
             :B1
ORDER BY CY

/* Formatted on 25/11/2021 10:49:45 (QP5 v5.374) */
BEGIN
    :GSCPACL_retcode :=
        UNAPIPA.GetScPaChartList ( :GSCPACL_sc,
                                  :GSCPACL_pg,
                                  :GSCPACL_pgnode,
                                  :GSCPACL_pa,
                                  :GSCPACL_panode,
                                  :GSCPACL_ch,
                                  :GSCPACL_cy,
                                  :GSCPACL_cy_version,
                                  :GSCPACL_description,
                                  :GSCPACL_creation_date,
                                  :GSCPACL_ch_context_key,
                                  :GSCPACL_visual_cf,
                                  :GSCPACL_ss,
                                  :GSCPACL_nr_of_rows);
END;


--kies vanuit RESULTS + METHODS vanaf attribuut DESCRIPTION via RMK de optie [EDIT LAYOUT]
--er lijken geen queries bijgekomen te zijn !!!!!!!!!!!


--VIA TOAD-TRACE QUERIES OPZOEKEN:

/* Formatted on 25/11/2021 11:00:25 (QP5 v5.374) */
BEGIN
    :rc :=
        PBAPIUPP.GETUPPREF ( :0,
                            :1,
                            :2,
                            :3,
                            :4,
                            :5,
                            :6,
                            :7,
                            :8,
                            :9);
END;

/* Formatted on 25/11/2021 11:01:16 (QP5 v5.374) */
BEGIN
    :rc :=
        PBAPIUPP.GETUPFUNCLIST ( :0,
                                :1,
                                :2,
                                :3,
                                :4,
                                :5,
                                :6);
END;
/*
--ik zit er nu via ROL/UP = 
--rol=CONSTRUCTION-PCT (lees: UP = 26 in, deze mag niet SAVEN van LAYOUTS !!!)
--rol=APPLICATION-MANAGEMENT = UP = 1
--rol=TYRE-TESTING-STD = UP = 10
--rol=TYRE-TESTING-STD-MGT = UP = 11
--rol=TYRE-MOUNTING-STD = UP = 45  (LET OP: IN PROD-OMGEVING IS DIT UP=47 !!!!!!)

via PBAPIUPP.GETUPFUNCLIST naar UNAPIUPP.GETUPFUNCLIST:

   SELECT A.UP, A.APPLIC, B.DESCRIPTION, A.FA, A.INHERIT_FA
   FROM UTUPFA A, UTFA B
   WHERE A.APPLIC = A.TOPIC
     AND A.APPLIC = B.APPLIC
     AND A.TOPIC = B.TOPIC
     AND A.VERSION = NVL( null, A.VERSION)
     AND A.UP = NVL( 26 , A.UP)
   UNION
   SELECT A.UP, B.APPLIC, B.DESCRIPTION, B.FA, '1'
   FROM UTUP A, UTFA B
   WHERE (A.UP, A.VERSION, B.APPLIC) NOT IN 
      (SELECT UP, VERSION, APPLIC FROM UTUPFA
       WHERE TOPIC = APPLIC
         AND VERSION = A.VERSION
         AND UP = A.UP)
     AND B.TOPIC = B.APPLIC
     AND A.VERSION = NVL( NULL , A.VERSION)
     AND A.UP = NVL( 26, A.UP)
   ORDER BY 1,3;

26	analyzer	Analyzer				1	0
26	costcalc	Cost Calculation		0	0
26	database	Database				0	0
26	addef		Define Address			0	0
26	eqdef		Define Equipment		0	0
26	gkdef		Define Group Key		0	0
26	lydef		Define Layout			0	0
26	lcdef		Define Life Cycle		0	0
26	ptdef		Define Protocol			0	0
26	rtdef		Define Request Type		0	0
26	stdef		Define Sample Type		0	0
26	tkdef		Define Task				0	0
26	ucdef		Define Unique Code Mask	0	0
26	updef		Define User Profile		0	0
26	dcmgt		Document Management		1	1
26	u4iweb		Internet application	1	0
26	radef		Remote Archive Definition	0	0
26	rqmgt		Request Management		1	1
26	scmgt		Sample Management		1	1
26	sdmgt		Study Management		0	0
26	unicnct		Uniconnect				0	0
26	wlmgt		Worklist Management		1	0
26	wsmgt		Worksheet Management	0	0
--
1	analyzer	Analyzer	1	1
1	costcalc	Cost Calculation	1	1
1	database	Database	0	1
1	addef	Define Address	1	1
1	eqdef	Define Equipment	1	1
1	gkdef	Define Group Key	1	1
1	lydef	Define Layout	1	1
1	lcdef	Define Life Cycle	1	1
1	ptdef	Define Protocol	1	1
1	rtdef	Define Request Type	1	1
1	stdef	Define Sample Type	1	1
1	tkdef	Define Task	1	1
1	ucdef	Define Unique Code Mask	1	1
1	updef	Define User Profile	1	1
1	dcmgt	Document Management	1	1
1	u4iweb	Internet application	1	1
1	radef	Remote Archive Definition	1	1
1	rqmgt	Request Management	1	1
1	scmgt	Sample Management	1	1
1	sdmgt	Study Management	1	1
1	unicnct	Uniconnect	0	1
1	wlmgt	Worklist Management	1	1
1	wsmgt	Worksheet Management	1	1
--
10	analyzer	Analyzer	1	1
10	costcalc	Cost Calculation	0	0
10	database	Database	0	1
10	addef	Define Address	0	0
10	eqdef	Define Equipment	0	0
10	gkdef	Define Group Key	0	0
10	lydef	Define Layout	0	0
10	lcdef	Define Life Cycle	0	0
10	ptdef	Define Protocol	0	0
10	rtdef	Define Request Type	0	0
10	stdef	Define Sample Type	0	0
10	tkdef	Define Task	0	0
10	ucdef	Define Unique Code Mask	0	0
10	updef	Define User Profile	0	0
10	dcmgt	Document Management	1	1
10	u4iweb	Internet application	0	0
10	radef	Remote Archive Definition	0	0
10	rqmgt	Request Management	1	1
10	scmgt	Sample Management	1	1
10	sdmgt	Study Management	0	0
10	unicnct	Uniconnect	0	1
10	wlmgt	Worklist Management	1	1
10	wsmgt	Worksheet Management	0	0
--
11	analyzer	Analyzer	1	1
11	costcalc	Cost Calculation	1	1
11	database	Database	0	1
11	addef	Define Address	1	1
11	eqdef	Define Equipment	1	1
11	gkdef	Define Group Key	1	1
11	lydef	Define Layout	1	1
11	lcdef	Define Life Cycle	1	1
11	ptdef	Define Protocol	1	1
11	rtdef	Define Request Type	1	1
11	stdef	Define Sample Type	1	1
11	tkdef	Define Task	1	1
11	ucdef	Define Unique Code Mask	1	1
11	updef	Define User Profile	1	1
11	dcmgt	Document Management	1	1
11	u4iweb	Internet application	1	1
11	radef	Remote Archive Definition	1	1
11	rqmgt	Request Management	1	1
11	scmgt	Sample Management	1	1
11	sdmgt	Study Management	1	1
11	unicnct	Uniconnect	0	1
11	wlmgt	Worklist Management	1	1
11	wsmgt	Worksheet Management	1	1
--
45	analyzer	Analyzer	1	1
45	costcalc	Cost Calculation	0	0
45	database	Database	0	1
45	addef	Define Address	0	0
45	eqdef	Define Equipment	0	0
45	gkdef	Define Group Key	0	0
45	lydef	Define Layout	0	0
45	lcdef	Define Life Cycle	0	0
45	ptdef	Define Protocol	0	0
45	rtdef	Define Request Type	0	0
45	stdef	Define Sample Type	0	0
45	tkdef	Define Task	0	0
45	ucdef	Define Unique Code Mask	0	0
45	updef	Define User Profile	0	0
45	dcmgt	Document Management	0	0
45	u4iweb	Internet application	0	0
45	radef	Remote Archive Definition	0	0
45	rqmgt	Request Management	1	1
45	scmgt	Sample Management	1	1
45	sdmgt	Study Management	0	0
45	unicnct	Uniconnect	0	1
45	wlmgt	Worklist Management	1	1
45	wsmgt	Worksheet Management	1	1
--
*/   


/* Formatted on 25/11/2021 11:01:24 (QP5 v5.374) */
BEGIN
    :rc :=
        UNAPIUP.GETUSERPROFILELIST ( :0,
                                    :1,
                                    :2,
                                    :3,
                                    :4,
                                    :5);
END;
/*
--bepalen van actuele UP:
--
SELECT up, description, ss 
FROM dd5.uvup 
WHERE active = '1' ORDER BY up, version; 
of 
WHERE version_is_current = '1' AND  ORDER BY up, version;
*/


/* Formatted on 25/11/2021 11:01:33 (QP5 v5.374) */
BEGIN
    :rc :=
        PBAPIUP.GETUSERPROFILE ( :0,
                                :1,
                                :2,
                                :3,
                                :4,
                                :5,
                                :6,
                                :7,
                                :8,
                                :9,
                                :10,
                                :11,
                                :12,
                                :13,
                                :14,
                                :15);
END;

--via PBAPIUP.GETUSERPROFILE  




/* Formatted on 25/11/2021 11:01:41 (QP5 v5.374) */
BEGIN
    :rc :=
        pbapilc.GETSTATUS ( :0,
                           :1,
                           :2,
                           :3,
                           :4,
                           :5,
                           :6,
                           :7,
                           :8,
                           :9,
                           :10,
                           :11,
                           :12,
                           :13,
                           :14);
END;

/* Formatted on 25/11/2021 11:01:50 (QP5 v5.374) */
BEGIN
    :rc :=
        PBAPIUPP.GETUPTASKLIST ( :0,
                                :1,
                                :2,
                                :3,
                                :4,
                                :5,
                                :6,
                                :7);
END;

/* Formatted on 25/11/2021 11:02:01 (QP5 v5.374) */
BEGIN
    :rc :=
        PBAPIUP.GETUPUSER ( :0,
                           :1,
                           :2,
                           :3,
                           :4,
                           :5);
END;

/* Formatted on 25/11/2021 11:02:18 (QP5 v5.374) */
BEGIN
    :rc :=
        UNAPIAD.GETADDRESSLIST ( :0,
                                :1,
                                :2,
                                :3,
                                :4,
                                :5);
END;

/* Formatted on 25/11/2021 11:02:26 (QP5 v5.374) */
BEGIN
    :rc :=
        UNAPIUPP.GETPREF ( :0,
                          :1,
                          :2,
                          :3,
                          :4,
                          :5,
                          :6,
                          :7);
END;

/* Formatted on 25/11/2021 11:02:35 (QP5 v5.374) */
BEGIN
    :rc :=
        UNAPITK.GETPREFVALUE ( :0,
                              :1,
                              :2,
                              :3,
                              :4);
END;

/* Formatted on 25/11/2021 11:02:43 (QP5 v5.374) */
BEGIN
    :rc :=
        UNAPIGK.GETGROUPKEYMELIST ( :0,
                                   :1,
                                   :2,
                                   :3,
                                   :4);
END;

/* Formatted on 25/11/2021 11:02:55 (QP5 v5.374) */
BEGIN
    :SGKV_retcode :=
        UNAPISC.SelectScGkValues ( :SGKV_col_id,
                                  :SGKV_col_tp,
                                  :SGKV_col_value,
                                  :SGKV_col_operator,
                                  :SGKV_col_andor,
                                  :SGKV_col_nr_of_rows,
                                  :SGKV_gk,
                                  :SGKV_value,
                                  :SGKV_nr_of_rows,
                                  :SGKV_order_by_clause,
                                  :SGKV_next_rows);
END;

/* Formatted on 25/11/2021 11:03:11 (QP5 v5.374) */
BEGIN
    :rc :=
        UNAPILY.GETLAYOUTLIST ( :0,
                               :1,
                               :2,
                               :3);
END;

/* Formatted on 25/11/2021 11:03:20 (QP5 v5.374) */
BEGIN
    :rc :=
        UNAPIGK.GETGROUPKEYRTLIST ( :0,
                                   :1,
                                   :2,
                                   :3,
                                   :4);
END;

/* Formatted on 25/11/2021 11:04:39 (QP5 v5.374) */
BEGIN
    :GETRQPP_retcode :=
        UNAPIRQ.GetRqParameterProfile ( :GETRQPP_rq,
                                       :GETRQPP_pp,
                                       :GETRQPP_pp_version,
                                       :GETRQPP_pp_key1,
                                       :GETRQPP_pp_key2,
                                       :GETRQPP_pp_key3,
                                       :GETRQPP_pp_key4,
                                       :GETRQPP_pp_key5,
                                       :GETRQPP_description,
                                       :GETRQPP_delay,
                                       :GETRQPP_delay_unit,
                                       :GETRQPP_freq_tp,
                                       :GETRQPP_freq_val,
                                       :GETRQPP_freq_unit,
                                       :GETRQPP_invert_freq,
                                       :GETRQPP_last_sched,
                                       :GETRQPP_last_cnt,
                                       :GETRQPP_last_val,
                                       :GETRQPP_inherit_au,
                                       :GETRQPP_nr_of_rows,
                                       :GETRQPP_where_clause);
END;

/* Formatted on 25/11/2021 11:05:10 (QP5 v5.374) */
BEGIN
    :GUUTL_retcode :=
        UNAPIUPP.GetUpUsTaskList ( :GUUTL_up_in,
                                  :GUUTL_us_in,
                                  :GUUTL_tk_tp_in,
                                  :GUUTL_up,
                                  :GUUTL_us,
                                  :GUUTL_tk_tp,
                                  :GUUTL_tk,
                                  :GUUTL_description,
                                  :GUUTL_is_enabled,
                                  :GUUTL_nr_of_rows);
END;

/* Formatted on 25/11/2021 11:05:20 (QP5 v5.374) */
BEGIN
    :GUUTD_retcode :=
        UNAPIUPP.GetUpUsTaskDetails ( :GUUTD_up_in,
                                     :GUUTD_us_in,
                                     :GUUTD_tk_tp_in,
                                     :GUUTD_tk_in,
                                     :GUUTD_up,
                                     :GUUTD_us,
                                     :GUUTD_tk_tp,
                                     :GUUTD_tk,
                                     :GUUTD_description,
                                     :GUUTD_col_id,
                                     :GUUTD_col_tp,
                                     :GUUTD_disp_title,
                                     :GUUTD_operator,
                                     :GUUTD_def_val,
                                     :GUUTD_andor,
                                     :GUUTD_hidden,
                                     :GUUTD_is_protected,
                                     :GUUTD_mandatory,
                                     :GUUTD_auto_refresh,
                                     :GUUTD_col_asc,
                                     :GUUTD_value_list_tp,
                                     :GUUTD_operator_protect,
                                     :GUUTD_andor_protect,
                                     :GUUTD_dsp_len,
                                     :GUUTD_inherit_tk,
                                     :GUUTD_nr_of_rows);
END;

--let op: IN TASK-DETAILS ZITTEN OOK DE HIDDEN/IS-PROTECTED-ATTRIBUTES !!!!!!!!

/* Formatted on 25/11/2021 11:05:48 (QP5 v5.374) */
BEGIN
    :SUUTVL_retcode :=
        UNAPIUPP.SaveUpUsTaskValueLists ( :SUUTVL_up,
                                         :SUUTVL_us,
                                         :SUUTVL_tk_tp,
                                         :SUUTVL_tk,
                                         :SUUTVL_col_id,
                                         :SUUTVL_col_tp,
                                         :SUUTVL_seq,
                                         :SUUTVL_valueseq,
                                         :SUUTVL_value,
                                         :SUUTVL_nr_of_rows,
                                         :SUUTVL_next_rows);
END;

/* Formatted on 25/11/2021 11:06:31 (QP5 v5.374) */
BEGIN
    :GUUTP_retcode :=
        UNAPIUPP.GetUpUsTkPref ( :GUUTP_up,
                                :GUUTP_us,
                                :GUUTP_tk_tp,
                                :GUUTP_tk,
                                :GUUTP_pref_name,
                                :GUUTP_pref_value,
                                :GUUTP_nr_of_rows);
END;

/* Formatted on 25/11/2021 11:06:43 (QP5 v5.374) */
BEGIN
    :SCSQLV_retcode :=
        UNAPITK.SelectCustomSQLValues ( :SCSQLV_tk_tp,
                                       :SCSQLV_tk,
                                       :SCSQLV_col_id,
                                       :SCSQLV_col_tp,
                                       :SCSQLV_col_value,
                                       :SCSQLV_col_nr_of_rows,
                                       :SCSQLV_col_id4customsql,
                                       :SCSQLV_col_tp4customsql,
                                       :SCSQLV_value,
                                       :SCSQLV_nr_of_rows,
                                       :SCSQLV_order_by_clause,
                                       :SCSQLV_next_rows);
END;

/* Formatted on 25/11/2021 11:07:01 (QP5 v5.374) */
BEGIN
    :GUUTVL_retcode :=
        UNAPIUPP.GetUpUsTaskValueLists ( :GUUTVL_up,
                                        :GUUTVL_us,
                                        :GUUTVL_tk_tp,
                                        :GUUTVL_tk,
                                        :GUUTVL_col_id,
                                        :GUUTVL_col_tp,
                                        :GUUTVL_seq,
                                        :GUUTVL_valueseq,
                                        :GUUTVL_value,
                                        :GUUTVL_nr_of_rows,
                                        :GUUTVL_next_rows);
END;

/* Formatted on 25/11/2021 11:07:22 (QP5 v5.374) */
BEGIN
    :GETOBJAU_retcode :=
        UNAPIPRP.GetObjectAttribute ( :GETOBJAU_object_tp,
                                     :GETOBJAU_object_id,
                                     :GETOBJAU_object_version,
                                     :GETOBJAU_au,
                                     :GETOBJAU_au_version,
                                     :GETOBJAU_value,
                                     :GETOBJAU_description,
                                     :GETOBJAU_is_protected,
                                     :GETOBJAU_single_valued,
                                     :GETOBJAU_new_val_allowed,
                                     :GETOBJAU_store_db,
                                     :GETOBJAU_value_list_tp,
                                     :GETOBJAU_run_mode,
                                     :GETOBJAU_service,
                                     :GETOBJAU_cf_value,
                                     :GETOBJAU_nr_of_rows,
                                     :GETOBJAU_where_clause);
END;

--LET OP: HIER ZIT OOK EEN IS-PROTECTED-VALUE + STORE-DB-value !!!!!!!!!!!!!!!

/* Formatted on 25/11/2021 11:08:28 (QP5 v5.374) */
BEGIN
    :GETUOAU_retcode :=
        UNAPIPRP.GetUsedObjectAttribute ( :GETUOAU_object_tp,
                                         :GETUOAU_used_object_tp,
                                         :GETUOAU_object_id,
                                         :GETUOAU_object_version,
                                         :GETUOAU_used_object_id,
                                         :GETUOAU_used_object_version,
                                         :GETUOAU_au,
                                         :GETUOAU_au_version,
                                         :GETUOAU_value,
                                         :GETUOAU_description,
                                         :GETUOAU_is_protected,
                                         :GETUOAU_single_valued,
                                         :GETUOAU_new_val_allowed,
                                         :GETUOAU_store_db,
                                         :GETUOAU_value_list_tp,
                                         :GETUOAU_run_mode,
                                         :GETUOAU_service,
                                         :GETUOAU_cf_value,
                                         :GETUOAU_nr_of_rows,
                                         :GETUOAU_where_clause);
END;

/* Formatted on 25/11/2021 11:09:04 (QP5 v5.374) */
BEGIN
    :GAFTPAU_retcode :=
        UNAPIPG.GetTestPlanAttributes ( :GAFTPAU_object_tp,
                                       :GAFTPAU_object_id,
                                       :GAFTPAU_object_version,
                                       :GAFTPAU_tst_tp,
                                       :GAFTPAU_tst_id,
                                       :GAFTPAU_tst_id_version,
                                       :GAFTPAU_pp_seq,
                                       :GAFTPAU_pr_seq,
                                       :GAFTPAU_mt_seq,
                                       :GAFTPAU_pp_key1,
                                       :GAFTPAU_pp_key2,
                                       :GAFTPAU_pp_key3,
                                       :GAFTPAU_pp_key4,
                                       :GAFTPAU_pp_key5,
                                       :GAFTPAU_au,
                                       :GAFTPAU_au_version,
                                       :GAFTPAU_value,
                                       :GAFTPAU_description,
                                       :GAFTPAU_is_protected,
                                       :GAFTPAU_single_valued,
                                       :GAFTPAU_new_val_allowed,
                                       :GAFTPAU_store_db,
                                       :GAFTPAU_value_list_tp,
                                       :GAFTPAU_run_mode,
                                       :GAFTPAU_service,
                                       :GAFTPAU_cf_value,
                                       :GAFTPAU_nr_of_rows,
                                       :GAFTPAU_next_rows);
END;

--let op: hier zijn ook de is-protected + store-db attributen aanwezig !!!!!!!!!!

/* Formatted on 25/11/2021 11:09:54 (QP5 v5.374) */
BEGIN
    :GETAFTP_retcode :=
        UNAPIPG.GetFullTestPlan ( :GETAFTP_object_tp,
                                 :GETAFTP_object_id,
                                 :GETAFTP_object_version,
                                 :GETAFTP_tst_tp,
                                 :GETAFTP_tst_id,
                                 :GETAFTP_tst_id_version,
                                 :GETAFTP_pp_seq,
                                 :GETAFTP_pr_seq,
                                 :GETAFTP_mt_seq,
                                 :GETAFTP_pp_key1,
                                 :GETAFTP_pp_key2,
                                 :GETAFTP_pp_key3,
                                 :GETAFTP_pp_key4,
                                 :GETAFTP_pp_key5,
                                 :GETAFTP_tst_description,
                                 :GETAFTP_tst_nr_measur,
                                 :GETAFTP_tst_already_assigned,
                                 :GETAFTP_nr_of_rows,
                                 :GETAFTP_next_rows);
END;

/* Formatted on 25/11/2021 11:10:30 (QP5 v5.374) */
BEGIN
    :GAS_retcode :=
        UNAPIGEN.GetAllowedStatus ( :GAS_object_lc,
                                   :GAS_cur_ss,
                                   :GAS_new_ss,
                                   :GAS_ss_name,
                                   :GAS_nr_of_rows);
END;

/* Formatted on 25/11/2021 11:10:56 (QP5 v5.374) */
BEGIN
    :GUP4US_retcode :=
        UNAPIGEN.GetUserProfilesForUser ( :GUP4US_up,
                                         :GUP4US_description,
                                         :GUP4US_nr_of_rows);
END;

/* Formatted on 25/11/2021 11:11:14 (QP5 v5.374) */
SELECT COUNT (U.US)
  FROM UVUPUS U, UVAD A
 WHERE U.UP = :B2 AND U.US = :B1 AND U.US = A.AD AND A.ACTIVE = 1
 
/* Formatted on 25/11/2021 11:11:37 (QP5 v5.374) */
BEGIN
    :GSCPACL_retcode :=
        UNAPIPA.GetScPaChartList ( :GSCPACL_sc,
                                  :GSCPACL_pg,
                                  :GSCPACL_pgnode,
                                  :GSCPACL_pa,
                                  :GSCPACL_panode,
                                  :GSCPACL_ch,
                                  :GSCPACL_cy,
                                  :GSCPACL_cy_version,
                                  :GSCPACL_description,
                                  :GSCPACL_creation_date,
                                  :GSCPACL_ch_context_key,
                                  :GSCPACL_visual_cf,
                                  :GSCPACL_ss,
                                  :GSCPACL_nr_of_rows);
END;

 

--na openen edit-layout-scherm van METHODS 

/* Formatted on 25/11/2021 11:25:16 (QP5 v5.374) */
BEGIN
    :GSCPACL_retcode :=
        UNAPIPA.GetScPaChartList ( :GSCPACL_sc,
                                  :GSCPACL_pg,
                                  :GSCPACL_pgnode,
                                  :GSCPACL_pa,
                                  :GSCPACL_panode,
                                  :GSCPACL_ch,
                                  :GSCPACL_cy,
                                  :GSCPACL_cy_version,
                                  :GSCPACL_description,
                                  :GSCPACL_creation_date,
                                  :GSCPACL_ch_context_key,
                                  :GSCPACL_visual_cf,
                                  :GSCPACL_ss,
                                  :GSCPACL_nr_of_rows);
END;

/* Formatted on 25/11/2021 11:27:28 (QP5 v5.374) */
BEGIN
    :GSCPASP_retcode :=
        UNAPIPA.GetScPaSpecs ( :GSCPASP_spec_set,
                              :GSCPASP_sc,
                              :GSCPASP_pg,
                              :GSCPASP_pgnode,
                              :GSCPASP_pa,
                              :GSCPASP_panode,
                              :GSCPASP_low_limit,
                              :GSCPASP_high_limit,
                              :GSCPASP_low_spec,
                              :GSCPASP_high_spec,
                              :GSCPASP_low_dev,
                              :GSCPASP_rel_low_dev,
                              :GSCPASP_target,
                              :GSCPASP_high_dev,
                              :GSCPASP_rel_high_dev,
                              :GSCPASP_nr_of_rows,
                              :GSCPASP_where_clause);
END;



--***********************************************
-- BEHEERSCHERM USER-MANAGEMENT LAAT TE WEINIG ROLLEN ZIEN...
--*******************************************************

/* Formatted on 25/11/2021 17:27:18 (QP5 v5.374) */
  SELECT UP, description, ss
    FROM dd1.uvup
   WHERE 1 = 1
ORDER BY UP

/*
1	Application management	@A
2	Viewers	@A
3	Preparation lab	@A
4	Preparation lab mgt	@A
5	Physical lab	@A
6	Physical lab mgt	@A
7	Chemical lab	@A
8	Chemical lab mgt	@A
9	Certificate control	@A
10	Tyre testing std	@A
11	Tyre testing std mgt	@A
12	Tyre testing adv.	@A
13	Tyre testing adv mgt	@A
14	Process tech. VF	@A
15	Process tech. VF mgt	@A
16	Process tech. BV	@A
17	Process tech. BV mgt	@A
18	User Mgt	@A
19	User Group	@A
20	Purchasing	@A
21	Obsolete users	@A
22	Material lab mgt	@A
23	QEA	@A
24	Compounding	@A
25	Reinforcement	@A
26	Construction PCT	@A
27	Research	@A
28	Proto PCT	@A
29	Proto Extrusion	@A
30	Proto Mixing	@A
31	Proto Tread	@A
32	Proto Calander	@A
33	Construction AT	@A
34	Proto AT	@A
35	Construction SM	@A
36	FEA	@A
37	FEA mgt	@A
38	Tyre Order	@A
39	BAM mgt	@A
40	BAM	@A
41	Raw material mgt	@A
42	Construction TBR	@A
43	Raw Matreials	@A
44	Construction TWT	@A
45	Raw Materials Chennai	@A
46	Purchasing mgt	@A
47	Tyre mounting std	@A
*/

SELECT A.UP,
       A.PREF_NAME,
       A.PREF_VALUE,
       A.INHERIT_PREF
  FROM UTUPPREF A
 WHERE     A.VERSION = NVL ( null, A.VERSION)
       AND A.UP = NVL ( 2, A.UP)
       AND A.PREF_NAME LIKE '%'
UNION
SELECT A.UP,
       B.PREF_NAME,
       B.PREF_VALUE,
       '1'
  FROM UTUP A, UTPREF B
 WHERE     (A.UP, A.VERSION, B.PREF_NAME) NOT IN
               (SELECT UP, VERSION, PREF_NAME
                  FROM UTUPPREF
                 WHERE VERSION = A.VERSION AND UP = A.UP)
       AND A.VERSION = NVL ( null, A.VERSION)
       AND A.UP = NVL ( 2, A.UP)
       AND B.PREF_TP = 'up'
       AND B.PREF_NAME LIKE '%'
ORDER BY 1, 2




SELECT A.UP,
       A.APPLIC,
       B.DESCRIPTION,
       A.FA,
       A.INHERIT_FA
  FROM UTUPFA A, UTFA B
 WHERE     A.APPLIC = A.TOPIC
       AND A.APPLIC = B.APPLIC
       AND A.TOPIC = B.TOPIC
       AND A.VERSION = NVL ( null, A.VERSION)
       AND A.UP = NVL ( 2, A.UP)
UNION
SELECT A.UP,
       B.APPLIC,
       B.DESCRIPTION,
       B.FA,
       '1'
  FROM UTUP A, UTFA B
 WHERE     (A.UP, A.VERSION, B.APPLIC) NOT IN
               (SELECT UP, VERSION, APPLIC
                  FROM UTUPFA
                 WHERE TOPIC = APPLIC AND VERSION = A.VERSION AND UP = A.UP)
       AND B.TOPIC = B.APPLIC
       AND A.VERSION = NVL ( null, A.VERSION)
       AND A.UP = NVL ( 2, A.UP)
ORDER BY 1, 3
 
	
SELECT a.UP,
       a.seq,
       a.tk_tp,
       a.tk,
       b.description,
       a.is_enabled
  FROM utuptk a, dd1.uvtk b
 WHERE     a.tk_tp = b.tk_tp
       AND a.tk = b.tk
       AND a.version = NVL ( null, a.version)
       AND a.UP = NVL ( 2, a.UP)
       AND a.tk_tp LIKE '%'
UNION
SELECT a.UP,
       999,
       b.tk_tp,
       b.tk,
       b.description,
       '0'
  FROM utup a, dd1.uvtk b
 WHERE     (a.UP, b.tk_tp, b.tk) NOT IN (SELECT UP, tk_tp, tk
                                           FROM utuptk
                                          WHERE UP = a.UP)
       AND a.version = NVL ( null, a.version)
       AND a.UP = NVL ( 2, a.UP)
       AND b.tk_tp LIKE '%'
ORDER BY 1, 2, 3	


SELECT up, description, dd, descr_doc, chg_pwd, define_menu, confirm_chg_ss, language, up_class, log_hs, allow_modify, active, lc, ss 
FROM dd1.uvup 
WHERE version_is_current = '1' 
AND up = 2 ORDER BY up, version
--2	Viewers	3		1	1	0	ENG		1	0	1	@L	@A



  SELECT ad, person, ss
    FROM dd1.uvad
   WHERE     (   ad IN
                     (SELECT e.us
                        FROM utup  b,
                             utupus a,
                             utup  c,
                             utup  d,
                             utupus e
                       WHERE     a.us = 'PSC'
                             AND a.UP = b.UP
                             AND c.dd = b.dd
                             AND d.UP = c.UP
                             AND e.UP = d.UP)
              OR is_user = '0')
         AND (is_user = '1' OR is_user = '2')
ORDER BY UPPER (ad)

SELECT LANGUAGE, DESCRIPTION, ACTIVE FROM UTUP WHERE UP = 2