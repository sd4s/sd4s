create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapiad AS

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

FUNCTION GetAddress
(a_ad                  OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_is_template         OUT     VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_user             OUT     vc1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created      OUT     vc1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ad_tp               OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_person              OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_title               OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_function_name       OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_def_up              OUT     UNAPIGEN.LONG_TABLE_TYPE,    /* LONG_TABLE_TYPE */
 a_company             OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_street              OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_city                OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_state               OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_country             OUT     UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_ad_nr               OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_po_box              OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_zip_code            OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_phone_nr            OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_ext_nr              OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_fax_nr              OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_email               OUT     UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_ad_class            OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_log_hs              OUT     VC1_TABLE_TYPE,              /* CHAR1_TABLE_TYPE */
 a_allow_modify        OUT     VC1_TABLE_TYPE,              /* CHAR1_TABLE_TYPE */
 a_active              OUT     VC1_TABLE_TYPE,              /* CHAR1_TABLE_TYPE */
 a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_ss                  OUT     UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                      /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER IS
 l_is_template         UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_is_user             UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_struct_created      UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_log_hs              UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_allow_modify        UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_active              UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_row                 INTEGER;
BEGIN
l_ret_code := UNAPIAD.GetAddress
(a_ad,
 l_is_template,
 l_is_user,
 l_struct_created,
 a_ad_tp         ,
 a_person        ,
 a_title         ,
 a_function_name ,
 a_def_up        ,
 a_company       ,
 a_street        ,
 a_city          ,
 a_state         ,
 a_country       ,
 a_ad_nr         ,
 a_po_box        ,
 a_zip_code      ,
 a_phone_nr      ,
 a_ext_nr        ,
 a_fax_nr        ,
 a_email         ,
 a_ad_class      ,
 l_log_hs        ,
 l_allow_modify  ,
 l_active        ,
 a_lc            ,
 a_ss            ,
 a_nr_of_rows    ,
 a_where_clause   );
 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
    FOR l_row IN 1..a_nr_of_rows LOOP
       a_is_template(l_row)    := l_is_template(l_row);
       a_is_user(l_row)        := l_is_user(l_row);
       a_struct_created(l_row) := l_struct_created(l_row);
       a_log_hs(l_row)         := l_log_hs(l_row);
       a_allow_modify(l_row)   := l_allow_modify(l_row);
       a_active(l_row)         := l_active(l_row);
    END LOOP;
 END IF;
 RETURN(l_ret_code);
END GetAddress;

FUNCTION GetAddress
(a_ad                      OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_is_template             OUT     UNAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_is_user                 OUT     UNAPIGEN.vc1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_identification_type     OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_identified_by_string    OUT     UNAPIGEN.VC511_TABLE_TYPE, /* VC511_TABLE_TYPE */
 a_struct_created          OUT     UNAPIGEN.vc1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ad_tp                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_person                  OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE  */
 a_title                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_function_name           OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_def_up                  OUT     UNAPIGEN.LONG_TABLE_TYPE,  /* LONG_TABLE_TYPE */
 a_company                 OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_street                  OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_city                    OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_state                   OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_country                 OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_ad_nr                   OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_po_box                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_zip_code                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_phone_nr                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_ext_nr                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_fax_nr                  OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_email                   OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_ad_class                OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs                  OUT     UNAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_allow_modify            OUT     UNAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active                  OUT     UNAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_lc                      OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss                      OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows              IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause            IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER IS
 l_is_template         UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_is_user             UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_struct_created      UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_log_hs              UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_allow_modify        UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_active              UNAPIGEN.CHAR1_TABLE_TYPE;   /* CHAR1_TABLE_TYPE */
 l_row                 INTEGER;
BEGIN
l_ret_code := UNAPIAD.GetAddress
(a_ad,
 l_is_template,
 l_is_user,
 a_identification_type,
 a_identified_by_string,
 l_struct_created,
 a_ad_tp         ,
 a_person        ,
 a_title         ,
 a_function_name ,
 a_def_up        ,
 a_company       ,
 a_street        ,
 a_city          ,
 a_state         ,
 a_country       ,
 a_ad_nr         ,
 a_po_box        ,
 a_zip_code      ,
 a_phone_nr      ,
 a_ext_nr        ,
 a_fax_nr        ,
 a_email         ,
 a_ad_class      ,
 l_log_hs        ,
 l_allow_modify  ,
 l_active        ,
 a_lc            ,
 a_ss            ,
 a_nr_of_rows    ,
 a_where_clause   );
 IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
    FOR l_row IN 1..a_nr_of_rows LOOP
       a_is_template(l_row)    := l_is_template(l_row);
       a_is_user(l_row)        := l_is_user(l_row);
       a_struct_created(l_row) := l_struct_created(l_row);
       a_log_hs(l_row)         := l_log_hs(l_row);
       a_allow_modify(l_row)   := l_allow_modify(l_row);
       a_active(l_row)         := l_active(l_row);
    END LOOP;
 END IF;
 RETURN(l_ret_code);
END GetAddress;


END pbapiad;