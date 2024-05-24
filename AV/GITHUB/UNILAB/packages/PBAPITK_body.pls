create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapitk AS

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

FUNCTION GetTask
(a_tk_tp            IN      VARCHAR2,                    /* VC20_TYPE */
 a_tk               IN      VARCHAR2,                    /* VC20_TYPE */
 a_description      OUT     VARCHAR2,                    /* VC40_TYPE */
 a_col_id           OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp           OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_title       OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_def_val          OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_hidden           OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_is_protected     OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_auto_refresh     OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_col_asc          OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_dsp_len          OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows       IN OUT  NUMBER)                      /* NUM_TYPE */
RETURN NUMBER IS

l_row           NUMBER;
l_hidden          UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_is_protected    UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_mandatory       UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_auto_refresh    UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_col_asc         UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_value_list_tp   UNAPIGEN.CHAR1_TABLE_TYPE  ;

BEGIN

l_ret_code := UNAPITK.GetTask
(a_tk_tp,
 a_tk,
 a_description,
 a_col_id ,
 a_col_tp ,
 a_disp_title,
 a_def_val,
 l_hidden,
 l_is_protected ,
 l_mandatory,
 l_auto_refresh,
 l_col_asc,
 l_value_list_tp ,
 a_dsp_len ,
 a_nr_of_rows);

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
 FOR l_row IN 1..a_nr_of_rows LOOP
  a_hidden(l_row)       := l_hidden(l_row);
  a_is_protected(l_row) := l_is_protected(l_row);
  a_mandatory(l_row)    := l_mandatory(l_row);
  a_auto_refresh(l_row) := l_auto_refresh(l_row);
  a_col_asc(l_row)      := l_col_asc(l_row);
  a_value_list_tp(l_row):= l_value_list_tp(l_row);
 END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetTask;

FUNCTION GetTask
(a_tk_tp            IN      VARCHAR2,                    /* VC20_TYPE */
 a_tk               IN      VARCHAR2,                    /* VC20_TYPE */
 a_description      OUT     VARCHAR2,                    /* VC40_TYPE */
 a_col_id           OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp           OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_title       OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_operator         OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_def_val          OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_andor            OUT     UNAPIGEN.VC3_TABLE_TYPE,     /* VC3_TABLE_TYPE */
 a_hidden           OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_is_protected     OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_auto_refresh     OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_col_asc          OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_operator_protect OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_andor_protect    OUT     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_dsp_len          OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows       IN OUT  NUMBER)                      /* NUM_TYPE */
RETURN NUMBER IS

l_row                NUMBER;
l_hidden             UNAPIGEN.CHAR1_TABLE_TYPE;
l_is_protected       UNAPIGEN.CHAR1_TABLE_TYPE;
l_mandatory          UNAPIGEN.CHAR1_TABLE_TYPE;
l_auto_refresh       UNAPIGEN.CHAR1_TABLE_TYPE;
l_col_asc            UNAPIGEN.CHAR1_TABLE_TYPE;
l_value_list_tp      UNAPIGEN.CHAR1_TABLE_TYPE;
l_operator_protect   UNAPIGEN.CHAR1_TABLE_TYPE;
l_andor_protect      UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN

l_ret_code := UNAPITK.GetTask
(a_tk_tp,
 a_tk,
 a_description,
 a_col_id ,
 a_col_tp ,
 a_disp_title,
 a_operator,
 a_def_val,
 a_andor,
 l_hidden,
 l_is_protected ,
 l_mandatory,
 l_auto_refresh,
 l_col_asc,
 l_value_list_tp ,
 l_operator_protect,
 l_andor_protect,
 a_dsp_len ,
 a_nr_of_rows);

IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
 FOR l_row IN 1..a_nr_of_rows LOOP
  a_hidden(l_row)       := l_hidden(l_row);
  a_is_protected(l_row) := l_is_protected(l_row);
  a_mandatory(l_row)    := l_mandatory(l_row);
  a_auto_refresh(l_row) := l_auto_refresh(l_row);
  a_col_asc(l_row)      := l_col_asc(l_row);
  a_value_list_tp(l_row):= l_value_list_tp(l_row);
  a_operator_protect(l_row):= l_operator_protect(l_row);
  a_andor_protect(l_row):= l_andor_protect(l_row);
 END LOOP ;
END IF ;
RETURN (l_ret_code);
END GetTask;

FUNCTION SaveTask
(a_tk_tp          IN     VARCHAR2,                    /* VC20_TYPE */
 a_tk             IN     VARCHAR2,                    /* VC20_TYPE */
 a_description    IN     VARCHAR2,                    /* VC40_TYPE */
 a_col_id         IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp         IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_def_val        IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_hidden         IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_protected   IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory      IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_auto_refresh   IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_col_asc        IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp  IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_dsp_len        IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows     IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason  IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER IS

l_row                NUMBER;
l_hidden             UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_is_protected       UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_mandatory          UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_auto_refresh       UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_col_asc            UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_value_list_tp      UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_operator_protect   UNAPIGEN.CHAR1_TABLE_TYPE;
l_andor_protect      UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN

FOR l_row IN 1..a_nr_of_rows LOOP
      l_hidden(l_row)         := a_hidden(l_row);
      l_is_protected(l_row)   := a_is_protected(l_row);
      l_mandatory(l_row)      := a_mandatory(l_row);
      l_auto_refresh(l_row)   := a_auto_refresh(l_row);
     IF a_col_asc(l_row) = ' ' THEN
        l_col_asc(l_row)        := NULL;
     ELSE
        l_col_asc(l_row)        := a_col_asc(l_row);
      END IF;
     l_value_list_tp(l_row)  := a_value_list_tp(l_row);
END LOOP;
 l_ret_code := UNAPITK.SaveTask
 (a_tk_tp,
 a_tk,
 a_description,
 a_col_id ,
 a_col_tp ,
 a_def_val,
 l_hidden,
 l_is_protected ,
 l_mandatory,
 l_auto_refresh,
 l_col_asc,
 l_value_list_tp ,
 a_dsp_len ,
 a_nr_of_rows,
 a_modify_reason);
 RETURN l_ret_code ;
END SaveTask;

FUNCTION SaveTask
(a_tk_tp             IN     VARCHAR2,                    /* VC20_TYPE */
 a_tk                IN     VARCHAR2,                    /* VC20_TYPE */
 a_description       IN     VARCHAR2,                    /* VC40_TYPE */
 a_col_id            IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp            IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_title        IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_operator          IN     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_def_val           IN     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_andor             IN     UNAPIGEN.VC3_TABLE_TYPE,     /* VC3_TABLE_TYPE */
 a_hidden            IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_is_protected      IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_mandatory         IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_auto_refresh      IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_col_asc           IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_value_list_tp     IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_operator_protect  IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_andor_protect     IN     PBAPIGEN.VC1_TABLE_TYPE,     /* CHAR1_TABLE_TYPE */
 a_dsp_len           IN     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_nr_of_rows        IN     NUMBER,                      /* NUM_TYPE */
 a_modify_reason     IN     VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER IS

l_row                NUMBER;
l_hidden             UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_is_protected       UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_mandatory          UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_auto_refresh       UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_col_asc            UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_value_list_tp      UNAPIGEN.CHAR1_TABLE_TYPE  ;
l_operator_protect   UNAPIGEN.CHAR1_TABLE_TYPE;
l_andor_protect      UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN

FOR l_row IN 1..a_nr_of_rows LOOP
      l_hidden(l_row)         := a_hidden(l_row);
      l_is_protected(l_row)   := a_is_protected(l_row);
      l_mandatory(l_row)      := a_mandatory(l_row);
      l_auto_refresh(l_row)   := a_auto_refresh(l_row);
     IF a_col_asc(l_row) = ' ' THEN
        l_col_asc(l_row)        := NULL;
     ELSE
        l_col_asc(l_row)        := a_col_asc(l_row);
      END IF;
     l_value_list_tp(l_row)  := a_value_list_tp(l_row);
     l_operator_protect(l_row) := a_operator_protect(l_row);
     l_andor_protect(l_row) := a_andor_protect(l_row);
END LOOP;
 l_ret_code := UNAPITK.SaveTask
 (a_tk_tp,
 a_tk,
 a_description,
 a_col_id ,
 a_col_tp ,
 a_disp_title,
 a_operator,
 a_def_val,
 a_andor,
 l_hidden,
 l_is_protected ,
 l_mandatory,
 l_auto_refresh,
 l_col_asc,
 l_value_list_tp,
 l_operator_protect,
 l_andor_protect,
 a_dsp_len ,
 a_nr_of_rows,
 a_modify_reason);
 RETURN l_ret_code ;
END SaveTask;

END pbapitk ;
