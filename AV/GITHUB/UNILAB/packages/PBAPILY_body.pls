create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapily AS

l_ret_code        NUMBER;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION GetLayout
(a_ly_tp            OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ly               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_col_id           OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp           OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_len          OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_disp_title       OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_style       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_disp_tp          OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_disp_width       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_disp_format      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_order        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_col_asc          OUT    UNAPIGEN.VC1_TABLE_TYPE,     /* VC1_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2,                    /* VC511_TYPE */
 a_next_rows        IN     NUMBER)                      /* NUM_TYPE */
RETURN NUMBER IS

 l_col_asc          UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */

BEGIN
l_ret_code := UNAPILY.GetLayout
(a_ly_tp            ,
 a_ly               ,
 a_col_id           ,
 a_col_tp           ,
 a_col_len          ,
 a_disp_title       ,
 a_disp_style       ,
 a_disp_tp          ,
 a_disp_width       ,
 a_disp_format      ,
 a_col_order        ,
 l_col_asc          ,
 a_nr_of_rows       ,
 a_where_clause     ,
 a_next_rows);

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
    FOR l_row IN 1..a_nr_of_rows LOOP
       a_col_asc(l_row)    := l_col_asc(l_row);
    END LOOP;
 END IF;
 RETURN(l_ret_code);

END GetLayout;

FUNCTION GetLayout
(a_ly_tp            OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ly               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_col_id           OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp           OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_len          OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_disp_title       OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_style       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_disp_tp          OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_disp_width       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_disp_format      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_order        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_col_asc          OUT    UNAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER IS

 l_col_asc          UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */

BEGIN
l_ret_code := UNAPILY.GetLayout
(a_ly_tp            ,
 a_ly               ,
 a_col_id           ,
 a_col_tp           ,
 a_col_len          ,
 a_disp_title       ,
 a_disp_style       ,
 a_disp_tp          ,
 a_disp_width       ,
 a_disp_format      ,
 a_col_order        ,
 l_col_asc          ,
 a_nr_of_rows       ,
 a_where_clause     );

 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
    FOR l_row IN 1..a_nr_of_rows LOOP
       a_col_asc(l_row)    := l_col_asc(l_row);
    END LOOP;
 END IF;

 RETURN(l_ret_code);

END GetLayout;

FUNCTION SaveLayout
(a_ly_tp            IN    VARCHAR2,                    /* VC20_TYPE */
 a_ly               IN    VARCHAR2,                    /* VC20_TYPE */
 a_col_id           IN    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_tp           IN    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_len          IN    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_disp_title       IN    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_disp_style       IN    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_disp_tp          IN    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_disp_width       IN    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_disp_format      IN    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_col_order        IN    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_col_asc          IN    PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_nr_of_rows       IN    NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN    VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER IS

 l_col_asc          UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */

BEGIN


FOR l_row IN 1..a_nr_of_rows LOOP
   if (a_col_asc(l_row) = ' ') then
        l_col_asc(l_row) := NULL;
   else
         l_col_asc(l_row) := a_col_asc(l_row);
   END IF;
END LOOP;

l_ret_code := UNAPILY.SaveLayout
(a_ly_tp            ,
 a_ly               ,
 a_col_id           ,
 a_col_tp           ,
 a_col_len          ,
 a_disp_title       ,
 a_disp_style       ,
 a_disp_tp          ,
 a_disp_width       ,
 a_disp_format      ,
 a_col_order        ,
 l_col_asc          ,
 a_nr_of_rows       ,
 a_modify_reason    );

 RETURN (l_ret_code);
EXCEPTION
WHEN OTHERS THEN
   IF sqlcode <> 1 THEN
      UNAPIGEN.LogError('pbapilk', sqlerrm);
   END IF;
   RETURN(UNAPIGEN.AbortTxn(UNAPIGEN.P_TXN_ERROR, 'pbapilk.SaveLayout'));

END SaveLayout;

END pbapily;