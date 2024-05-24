create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapirq AS

l_ret_code NUMBER;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION SelectRequest
(a_col_id                IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_tp                IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_value             IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_col_operator          IN      UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_col_andor             IN      UNAPIGEN.VC3_TABLE_TYPE,   /* VC3_TABLE_TYPE */
 a_col_nr_of_rows        IN      NUMBER,                    /* NUM_TYPE */
 a_rq                    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rt                    OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_rt_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description           OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc             OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_descr_doc_version     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sampling_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_creation_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_created_by            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_exec_start_date       OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_exec_end_date         OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_due_date              OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_priority              OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_label_format          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_date1                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date2                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date3                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date4                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_date5                 OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_allow_any_st          OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_new_sc          OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_responsible           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_sc_counter            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE + INDICATOR */
 a_rq_class              OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details        OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_modify          OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ar                    OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active                OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc                    OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_version            OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ss                    OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows            IN OUT  NUMBER,                    /* NUM_TYPE */
 a_order_by_clause       IN      VARCHAR2,                  /* VC255_TYPE */
 a_next_rows             IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER IS


l_allow_any_st             UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_allow_new_sc             UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_log_hs                   UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_log_hs_details           UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_allow_modify             UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_ar                       UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_active                   UNAPIGEN.CHAR1_TABLE_TYPE  ;

BEGIN

  l_ret_code := UNAPIRQ.SelectRequest
                   (a_col_id,
                    a_col_tp,
                    a_col_value,
                    a_col_operator,
                    a_col_andor,
                    a_col_nr_of_rows,
                    a_rq,
                    a_rt,
                    a_rt_version,
                    a_description,
                    a_descr_doc,
                    a_descr_doc_version,
                    a_sampling_date,
                    a_creation_date,
                    a_created_by,
                    a_exec_start_date,
                    a_exec_end_date,
                    a_due_date,
                    a_priority,
                    a_label_format,
                    a_date1,
                    a_date2,
                    a_date3,
                    a_date4,
                    a_date5,
                    l_allow_any_st,
                    l_allow_new_sc,
                    a_responsible,
                    a_sc_counter,
                    a_rq_class,
                    l_log_hs,
                    l_log_hs_details,
                    l_allow_modify,
                    l_ar,
                    l_active,
                    a_lc,
                    a_lc_version,
                    a_ss,
                    a_nr_of_rows,
                    a_order_by_clause,
                    a_next_rows);

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_allow_any_st(l_row)    := l_allow_any_st(l_row);
      a_allow_new_sc(l_row)    := l_allow_new_sc(l_row);
      a_log_hs(l_row)          := l_log_hs(l_row);
      a_log_hs_details(l_row)  := l_log_hs_details(l_row);
      a_allow_modify(l_row)    := l_allow_modify(l_row);
      a_ar(l_row)              := l_ar(l_row);
      a_active(l_row)          := l_active(l_row);
   END LOOP ;
END IF ;
RETURN (l_ret_code);
END SelectRequest;

END pbapirq ;