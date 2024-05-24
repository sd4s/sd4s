create or replace PACKAGE BODY ulco AS

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

FUNCTION HandleObjectVersion
(a_object_tp     IN    VARCHAR2,   /* VC4_TYPE */
 a_object_id     IN    VARCHAR2,   /* VC20_TYPE */
 a_version       IN    VARCHAR2)   /* VC20_TYPE */
RETURN VARCHAR2 IS

l_highest_version VARCHAR2(20);
l_allow_modify    CHAR(1);
l_count           NUMBER;

BEGIN
   IF UNAPIGEN.IsSystem21CFR11Compliant = UNAPIGEN.DBERR_SUCCESS THEN
   -- system is 21CFR11 compliant
      -- IF highest version is not modifiable => create a new major version
      -- ELSE return highest version
      l_highest_version := UNVERSION.SQLGetHighestMajorVersion(SUBSTR(a_object_tp,1,2), a_object_id, a_version);
      IF l_highest_version IS NOT NULL THEN
         EXECUTE IMMEDIATE 'SELECT allow_modify FROM dd'||UNAPIGEN.P_DD||'.uv'||SUBSTR(a_object_tp,1,2)||
                           ' WHERE '||SUBSTR(a_object_tp,1,2)||' = :a_object_id AND version=:a_highest_version'
                           INTO l_allow_modify USING a_object_id, l_highest_version;
      END IF;
      IF l_highest_version IS NULL OR l_allow_modify='0' THEN
         IF LENGTH(a_object_tp) <> 2 THEN
            -- used object must be saved: find the main object version: must exist before saving
            DBMS_OUTPUT.PUT_LINE('Major problem no modifiable version of main object found');
            RETURN('');
         ELSE
            -- main object must be saved but highest version is not modifiable
            -- => create new version
            RETURN(UNVERSION.SQLGetNextMajorVersion(l_highest_version));
         END IF;
      ELSE
         -- main object or used objects must be saved and highest version is modifiable
         -- => use highest version
         RETURN(l_highest_version);
      END IF;
   ELSE
   -- system is not 21CFR11 compliant
      -- IF object does not exist => create a new object
      -- ELSE return incoming version
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM dd'||UNAPIGEN.P_DD||'.uv'||SUBSTR(a_object_tp,1,2)||
                        ' WHERE '||SUBSTR(a_object_tp,1,2)||' = :a_object_id AND version=:a_version'
                        INTO l_count USING a_object_id, a_version;
      IF l_count = 0 THEN
         IF LENGTH(a_object_tp) <> 2 THEN
            -- used object must be saved: find the main object: must exist before saving
            DBMS_OUTPUT.PUT_LINE('Major problem no main object found');
            RETURN('');
         ELSE
            -- main object must be saved but does not exist
            -- => create new object
            RETURN(UNVERSION.P_INITIAL_VERSION);
         END IF;
      ELSE
         -- main object or used objects must be saved and object exists
         -- => use incoming version
         RETURN(a_version);
      END IF;
   END IF;
END HandleObjectVersion;

FUNCTION HandlePpVersion
(a_object_tp     IN    VARCHAR2,   /* VC4_TYPE */
 a_pp            IN    VARCHAR2,   /* VC20_TYPE */
 a_version       IN    VARCHAR2,   /* VC20_TYPE */
 a_pp_key1       IN    VARCHAR2,   /* VC20_TYPE */
 a_pp_key2       IN    VARCHAR2,   /* VC20_TYPE */
 a_pp_key3       IN    VARCHAR2,   /* VC20_TYPE */
 a_pp_key4       IN    VARCHAR2,   /* VC20_TYPE */
 a_pp_key5       IN    VARCHAR2)   /* VC20_TYPE */
RETURN VARCHAR2 IS

l_highest_version VARCHAR2(20);
l_allow_modify    CHAR(1);
l_count           NUMBER;

BEGIN
   IF UNAPIGEN.IsSystem21CFR11Compliant = UNAPIGEN.DBERR_SUCCESS THEN
      -- system is 21CFR11 compliant
      -- IF highest version is not modifiable => create a new major version
      -- ELSE return highest version
      l_highest_version := UNVERSION.SQLGetPpHighestMajorVersion(a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5);
      IF l_highest_version IS NOT NULL THEN
         EXECUTE IMMEDIATE 'SELECT allow_modify FROM dd'||UNAPIGEN.P_DD||'.uvpp'||
                           ' WHERE pp = :a_pp AND version=:a_highest_version'||
                           ' AND pp_key1 = :a_pp_key1 '||
                           ' AND pp_key2 = :a_pp_key2 '||
                           ' AND pp_key3 = :a_pp_key3 '||
                           ' AND pp_key4 = :a_pp_key4 '||
                           ' AND pp_key5 = :a_pp_key5 '
                           INTO l_allow_modify
                           USING a_pp, l_highest_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5;
      END IF;
      IF l_highest_version IS NULL OR l_allow_modify='0' THEN
         IF LENGTH(a_object_tp) <> 2 THEN
            -- used object must be saved: find the main object version: must exist before saving
            DBMS_OUTPUT.PUT_LINE('Major problem no modifiable version of main object found');
            RETURN('');
         ELSE
            -- main object must be saved but highest version is not modifiable
            -- => create new version
            RETURN(UNVERSION.SQLGetNextMajorVersion(l_highest_version));
         END IF;
      ELSE
         -- main object or used objects must be saved and highest version is modifiable
         -- => use highest version
         RETURN(l_highest_version);
      END IF;
   ELSE
   -- system is not 21CFR11 compliant
      -- IF object does not exist => create a new object
      -- ELSE return incoming version
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM dd'||UNAPIGEN.P_DD||'.uvpp'||
                        ' WHERE pp = :a_pp AND version=:a_version'||
                        ' AND pp_key1 = :a_pp_key1 '||
                        ' AND pp_key2 = :a_pp_key2 '||
                        ' AND pp_key3 = :a_pp_key3 '||
                        ' AND pp_key4 = :a_pp_key4 '||
                        ' AND pp_key5 = :a_pp_key5 '
                        INTO l_count
                        USING a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5;
      IF l_count = 0 THEN
         IF LENGTH(a_object_tp) <> 2 THEN
            -- used object must be saved: find the main object: must exist before saving
            DBMS_OUTPUT.PUT_LINE('Major problem no main object found');
            RETURN('');
         ELSE
            -- main object must be saved but does not exist
            -- => create new object
            RETURN(UNVERSION.P_INITIAL_VERSION);
         END IF;
      ELSE
         -- main object or used objects must be saved and object exists
         -- => use incoming version
         RETURN(a_version);
      END IF;
   END IF;
END HandlePpVersion;

FUNCTION HandleSaveSampleType
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code              NUMBER;
a_st                    VARCHAR2(20);
a_version               VARCHAR2(20);
a_version_is_current    CHAR(1);
a_effective_from        TIMESTAMP WITH TIME ZONE;
a_effective_till        TIMESTAMP WITH TIME ZONE;
a_description           VARCHAR2(40);
a_description2          VARCHAR2(40);
a_is_template           CHAR(1);
a_confirm_userid        CHAR(1);
a_shelf_life_val        NUMBER;
a_shelf_life_unit       VARCHAR2(20);
a_nr_planned_sc         NUMBER;
a_freq_tp               CHAR(1);
a_freq_val              NUMBER;
a_freq_unit             VARCHAR2(20);
a_invert_freq           CHAR(1);
a_last_sched            TIMESTAMP WITH TIME ZONE;
a_last_cnt              NUMBER;
a_last_val              VARCHAR2(40);
a_priority              NUMBER;
a_label_format          VARCHAR2(20);
a_descr_doc             VARCHAR2(40);
a_descr_doc_version     VARCHAR2(20);
a_allow_any_pp          CHAR(1);
a_sc_uc                 VARCHAR2(20);
a_sc_uc_version         VARCHAR2(20);
a_sc_lc                 VARCHAR2(2);
a_sc_lc_version         VARCHAR2(20);
a_inherit_au            CHAR(1);
a_inherit_gk            CHAR(1);
a_st_class              VARCHAR2(2);
a_log_hs                CHAR(1);
a_lc                    VARCHAR2(2);
a_lc_version            VARCHAR2(20);
a_modify_reason         VARCHAR2(255);

BEGIN

a_last_seq := a_curr_line.seq;

a_st := SUBSTR(a_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('st', a_st, SUBSTR(a_curr_line.arg2, 1, 20));
a_version_is_current := SUBSTR(a_curr_line.arg3, 1, 1);
a_effective_from := TO_DATE(a_curr_line.arg4);
a_effective_till := NULL;  --strictly ignored
a_description := SUBSTR(a_curr_line.arg6, 1, 40);
a_description2 := SUBSTR(a_curr_line.arg7, 1, 40);
a_is_template := SUBSTR(a_curr_line.arg8, 1, 1);
a_confirm_userid := SUBSTR(a_curr_line.arg9, 1, 1);
a_shelf_life_val := TO_NUMBER(a_curr_line.arg10);
a_shelf_life_unit := SUBSTR(a_curr_line.arg11, 1, 20);
a_nr_planned_sc := TO_NUMBER(a_curr_line.arg12);
a_freq_tp := SUBSTR(a_curr_line.arg13, 1, 1);
a_freq_val := TO_NUMBER(a_curr_line.arg14);
a_freq_unit := SUBSTR(a_curr_line.arg15, 1, 20);
a_invert_freq := SUBSTR(a_curr_line.arg16, 1, 1);
a_last_sched := TO_DATE(a_curr_line.arg17);
a_last_cnt := TO_NUMBER(a_curr_line.arg18);
a_last_val := SUBSTR(a_curr_line.arg19, 1, 40);
a_priority := TO_NUMBER(a_curr_line.arg20);
a_label_format := SUBSTR(a_curr_line.arg21, 1, 20);
a_descr_doc := SUBSTR(a_curr_line.arg22, 1, 40);
a_descr_doc_version := SUBSTR(a_curr_line.arg23, 1, 20);
a_allow_any_pp := SUBSTR(a_curr_line.arg24, 1, 1);
a_sc_uc := SUBSTR(a_curr_line.arg25, 1, 20);
a_sc_uc_version := SUBSTR(a_curr_line.arg26, 1, 20);
a_sc_lc := SUBSTR(a_curr_line.arg27, 1, 2);
a_sc_lc_version := SUBSTR(a_curr_line.arg28, 1, 20);
a_inherit_au := SUBSTR(a_curr_line.arg29, 1, 1);
a_inherit_gk := SUBSTR(a_curr_line.arg30, 1, 1);
a_st_class := SUBSTR(a_curr_line.arg31, 1, 2);
a_log_hs := SUBSTR(a_curr_line.arg32, 1, 1);
a_lc := SUBSTR(a_curr_line.arg33, 1, 2);
a_lc_version := SUBSTR(a_curr_line.arg34, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg35, 1, 255);

 l_ret_code := UNAPIST.SaveSampleType
            (a_st, a_version, a_version_is_current, a_effective_from, a_effective_till,
             a_description, a_description2, a_is_template, a_confirm_userid,
             a_shelf_life_val, a_shelf_life_unit,
             a_nr_planned_sc, a_freq_tp, a_freq_val,
             a_freq_unit, a_invert_freq, a_last_sched, a_last_cnt, a_last_val,
             a_priority, a_label_format,
             a_descr_doc, a_descr_doc_version, a_allow_any_pp, a_sc_uc, a_sc_uc_version,
             a_sc_lc, a_sc_lc_version, a_inherit_au,
             a_inherit_gk, a_st_class, a_log_hs, a_lc, a_lc_version, a_modify_reason);

RETURN(l_ret_code);

END HandleSaveSampleType;


FUNCTION HandleSaveStParameterProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code               NUMBER;
a_st                     VARCHAR2(20);
a_version                VARCHAR2(20);
a_pp                     UNAPIGEN.VC20_TABLE_TYPE;
a_pp_version             UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key1                UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key2                UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key3                UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key4                UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key5                UNAPIGEN.VC20_TABLE_TYPE;
a_freq_tp                UNAPIGEN.CHAR1_TABLE_TYPE;
a_freq_val               UNAPIGEN.NUM_TABLE_TYPE;
a_freq_unit              UNAPIGEN.VC20_TABLE_TYPE;
a_invert_freq            UNAPIGEN.CHAR1_TABLE_TYPE;
a_last_sched             UNAPIGEN.DATE_TABLE_TYPE;
a_last_cnt               UNAPIGEN.NUM_TABLE_TYPE;
a_last_val               UNAPIGEN.VC40_TABLE_TYPE;
a_inherit_au             UNAPIGEN.CHAR1_TABLE_TYPE;
a_nr_of_rows             NUMBER;
a_next_rows              NUMBER;
a_modify_reason          VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_st := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('stpp', a_st, SUBSTR(a_curr_line.arg2, 1, 20));
a_nr_of_rows := TO_NUMBER(a_curr_line.arg18);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_pp(x) := SUBSTR(l_curr_line.arg3, 1, 20);
   a_pp_version(x) := SUBSTR(l_curr_line.arg4, 1, 20);
   a_pp_key1(x) := SUBSTR(l_curr_line.arg5, 1, 20);
   a_pp_key2(x) := SUBSTR(l_curr_line.arg6, 1, 20);
   a_pp_key3(x) := SUBSTR(l_curr_line.arg7, 1, 20);
   a_pp_key4(x) := SUBSTR(l_curr_line.arg8, 1, 20);
   a_pp_key5(x) := SUBSTR(l_curr_line.arg9, 1, 20);
   a_freq_tp(x) := SUBSTR(l_curr_line.arg10, 1, 1);
   a_freq_val(x) := TO_NUMBER(l_curr_line.arg11);
   a_freq_unit(x) := SUBSTR(l_curr_line.arg12, 1, 20);
   a_invert_freq(x) := SUBSTR(l_curr_line.arg13, 1, 1);
   a_last_sched(x) := TO_DATE(l_curr_line.arg14);
   a_last_cnt(x) := TO_NUMBER(l_curr_line.arg15);
   a_last_val(x) := SUBSTR(l_curr_line.arg16, 1, 40);
   a_inherit_au(x) := SUBSTR(l_curr_line.arg17, 1, 1);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_next_rows := TO_NUMBER(a_curr_line.arg19);
a_modify_reason := SUBSTR(a_curr_line.arg20, 1, 255);

l_ret_code := UNAPIST.SaveStParameterProfile
              (a_st, a_version, a_pp, a_pp_version,
               a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5,
               a_freq_tp, a_freq_val, a_freq_unit,
               a_invert_freq, a_last_sched, a_last_cnt, a_last_val, a_inherit_au,
               a_nr_of_rows, a_next_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveStParameterProfile;


FUNCTION HandleSaveStGroupkey
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_st                    VARCHAR2(20);
a_version               VARCHAR2(20);
a_gk                    UNAPIGEN.VC20_TABLE_TYPE;
a_gk_version            UNAPIGEN.VC20_TABLE_TYPE;
a_value                 UNAPIGEN.VC40_TABLE_TYPE;
a_nr_of_rows            NUMBER;
a_modify_reason         VARCHAR2(255);


CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_st := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('stgk', a_st, SUBSTR(a_curr_line.arg2, 1, 20));
a_nr_of_rows := TO_NUMBER(a_curr_line.arg6);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_gk(x) := SUBSTR(l_curr_line.arg3, 1, 20);
   a_gk_version(x) := SUBSTR(l_curr_line.arg4, 1, 20);
   a_value(x) := SUBSTR(l_curr_line.arg5, 1, 40);


   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg7, 1, 255);

l_ret_code := UNAPIST.SaveStGroupkey
              (a_st, a_version, a_gk, a_gk_version, a_value,
               a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveStGroupkey;


FUNCTION HandleSaveGroupkeySt
(a_curr_line     IN    utlkin%ROWTYPE,
a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_gk                VARCHAR2(20);
a_description       VARCHAR2(40);
a_is_protected      CHAR(1);
a_value_unique      CHAR(1);
a_single_valued     CHAR(1);
a_new_val_allowed   CHAR(1);
a_mandatory         CHAR(1);
a_struct_created    CHAR(1);
a_inherit_gk        CHAR(1);
a_value_list_tp     CHAR(1);
a_default_value     VARCHAR2(40);
a_dsp_rows          NUMBER;
a_val_length        NUMBER;
a_val_start         NUMBER;
a_assign_tp         CHAR(1);
a_assign_id         VARCHAR2(20);
a_q_tp              CHAR(2);
a_q_id              VARCHAR2(20);
a_q_check_au        CHAR(1);
a_q_au              VARCHAR2(20);
a_value             UNAPIGEN.VC40_TABLE_TYPE;
a_sqltext           UNAPIGEN.VC255_TABLE_TYPE;
a_nr_of_rows        NUMBER;
a_modify_reason     VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_gk := SUBSTR(l_curr_line.arg1, 1, 20);

a_description := SUBSTR(l_curr_line.arg2, 1, 40);
a_is_protected := SUBSTR(l_curr_line.arg3, 1, 1);
a_value_unique := SUBSTR(l_curr_line.arg4, 1, 1);
a_single_valued := SUBSTR(l_curr_line.arg5, 1, 1);
a_new_val_allowed := SUBSTR(l_curr_line.arg6, 1, 1);
a_mandatory := SUBSTR(l_curr_line.arg7, 1, 1);
a_struct_created := SUBSTR(l_curr_line.arg8, 1, 1);
a_inherit_gk := SUBSTR(l_curr_line.arg9, 1, 1);
a_value_list_tp := SUBSTR(l_curr_line.arg10, 1, 1);
a_default_value := SUBSTR(l_curr_line.arg11, 1, 40);
a_dsp_rows := TO_NUMBER(l_curr_line.arg12);
a_val_length := TO_NUMBER(l_curr_line.arg13);
a_val_start := TO_NUMBER(l_curr_line.arg14);
a_assign_tp := SUBSTR(l_curr_line.arg15, 1, 1);
a_assign_id := SUBSTR(l_curr_line.arg16, 1, 20);
a_q_tp := SUBSTR(l_curr_line.arg17, 1, 2);
a_q_id := SUBSTR(l_curr_line.arg18, 1, 20);
a_q_check_au := SUBSTR(l_curr_line.arg19, 1, 1);
a_q_au := SUBSTR(l_curr_line.arg20, 1, 20);

a_nr_of_rows := TO_NUMBER(a_curr_line.arg23);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_value(x) := SUBSTR(l_curr_line.arg21, 1, 40);
   a_sqltext(x) := SUBSTR(l_curr_line.arg22, 1, 255);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg24, 1, 255);

l_ret_code := UNAPIGK.SaveGroupkeySt
          (a_gk, a_description, a_is_protected, a_value_unique,
           a_single_valued, a_new_val_allowed, a_mandatory, a_struct_created,
           a_inherit_gk, a_value_list_tp, a_default_value, a_dsp_rows, a_val_length, a_val_start,
           a_assign_tp, a_assign_id, a_q_tp, a_q_id, a_q_check_au, a_q_au,
           a_value, a_sqltext, a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveGroupkeySt;


FUNCTION HandleSaveGroupkeySc
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

 l_ret_code         NUMBER;

a_gk                VARCHAR2(20);
a_description       VARCHAR2(40);
a_is_protected      CHAR(1);
a_value_unique      CHAR(1);
a_single_valued     CHAR(1);
a_new_val_allowed   CHAR(1);
a_mandatory         CHAR(1);
a_struct_created    CHAR(1);
a_inherit_gk        CHAR(1);
a_value_list_tp     CHAR(1);
a_default_value     VARCHAR2(40);
a_dsp_rows          NUMBER;
a_val_length        NUMBER;
a_val_start         NUMBER;
a_assign_tp         CHAR(1);
a_assign_id         VARCHAR2(20);
a_q_tp              CHAR(2);
a_q_id              VARCHAR2(20);
a_q_check_au        CHAR(1);
a_q_au              VARCHAR2(20);
a_value             UNAPIGEN.VC40_TABLE_TYPE;
a_sqltext           UNAPIGEN.VC255_TABLE_TYPE;
a_nr_of_rows        NUMBER;
a_modify_reason     VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_gk := SUBSTR(l_curr_line.arg1, 1, 20);

a_description := SUBSTR(l_curr_line.arg2, 1, 40);
a_is_protected := SUBSTR(l_curr_line.arg3, 1, 1);
a_value_unique := SUBSTR(l_curr_line.arg4, 1, 1);
a_single_valued := SUBSTR(l_curr_line.arg5, 1, 1);
a_new_val_allowed := SUBSTR(l_curr_line.arg6, 1, 1);
a_mandatory := SUBSTR(l_curr_line.arg7, 1, 1);
a_struct_created := SUBSTR(l_curr_line.arg8, 1, 1);
a_inherit_gk := SUBSTR(l_curr_line.arg9, 1, 1);
a_value_list_tp := SUBSTR(l_curr_line.arg10, 1, 1);
a_default_value := SUBSTR(l_curr_line.arg11, 1, 40);
a_dsp_rows := TO_NUMBER(l_curr_line.arg12);
a_val_length := TO_NUMBER(l_curr_line.arg13);
a_val_start := TO_NUMBER(l_curr_line.arg14);
a_assign_tp := SUBSTR(l_curr_line.arg15, 1, 1);
a_assign_id := SUBSTR(l_curr_line.arg16, 1, 20);
a_q_tp := SUBSTR(l_curr_line.arg17, 1, 2);
a_q_id := SUBSTR(l_curr_line.arg18, 1, 20);
a_q_check_au := SUBSTR(l_curr_line.arg19, 1, 1);
a_q_au := SUBSTR(l_curr_line.arg20, 1, 20);

a_nr_of_rows := TO_NUMBER(a_curr_line.arg23);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_value(x) := SUBSTR(l_curr_line.arg21, 1, 40);
   a_sqltext(x) := SUBSTR(l_curr_line.arg22, 1, 255);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg24, 1, 255);

l_ret_code := UNAPIGK.SaveGroupkeySc
          (a_gk, a_description, a_is_protected, a_value_unique,
           a_single_valued, a_new_val_allowed, a_mandatory, a_struct_created,
           a_inherit_gk, a_value_list_tp, a_default_value, a_dsp_rows, a_val_length, a_val_start,
           a_assign_tp, a_assign_id, a_q_tp, a_q_id, a_q_check_au, a_q_au,
           a_value, a_sqltext, a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveGroupkeySc;

FUNCTION HandleSaveGroupkeyMe
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

 l_ret_code         NUMBER;

a_gk                VARCHAR2(20);
a_description       VARCHAR2(40);
a_is_protected      CHAR(1);
a_value_unique      CHAR(1);
a_single_valued     CHAR(1);
a_new_val_allowed   CHAR(1);
a_mandatory         CHAR(1);
a_struct_created    CHAR(1);
a_inherit_gk        CHAR(1);
a_value_list_tp     CHAR(1);
a_default_value     VARCHAR2(40);
a_dsp_rows          NUMBER;
a_val_length        NUMBER;
a_val_start         NUMBER;
a_assign_tp         CHAR(1);
a_assign_id         VARCHAR2(20);
a_q_tp              CHAR(2);
a_q_id              VARCHAR2(20);
a_q_check_au        CHAR(1);
a_q_au              VARCHAR2(20);
a_value             UNAPIGEN.VC40_TABLE_TYPE;
a_sqltext           UNAPIGEN.VC255_TABLE_TYPE;
a_nr_of_rows        NUMBER;
a_modify_reason     VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_gk := SUBSTR(l_curr_line.arg1, 1, 20);

a_description := SUBSTR(l_curr_line.arg2, 1, 40);
a_is_protected := SUBSTR(l_curr_line.arg3, 1, 1);
a_value_unique := SUBSTR(l_curr_line.arg4, 1, 1);
a_single_valued := SUBSTR(l_curr_line.arg5, 1, 1);
a_new_val_allowed := SUBSTR(l_curr_line.arg6, 1, 1);
a_mandatory := SUBSTR(l_curr_line.arg7, 1, 1);
a_struct_created := SUBSTR(l_curr_line.arg8, 1, 1);
a_inherit_gk := SUBSTR(l_curr_line.arg9, 1, 1);
a_value_list_tp := SUBSTR(l_curr_line.arg10, 1, 1);
a_default_value := SUBSTR(l_curr_line.arg11, 1, 40);
a_dsp_rows := TO_NUMBER(l_curr_line.arg12);
a_val_length := TO_NUMBER(l_curr_line.arg13);
a_val_start := TO_NUMBER(l_curr_line.arg14);
a_assign_tp := SUBSTR(l_curr_line.arg15, 1, 1);
a_assign_id := SUBSTR(l_curr_line.arg16, 1, 20);
a_q_tp := SUBSTR(l_curr_line.arg17, 1, 2);
a_q_id := SUBSTR(l_curr_line.arg18, 1, 20);
a_q_check_au := SUBSTR(l_curr_line.arg19, 1, 1);
a_q_au := SUBSTR(l_curr_line.arg20, 1, 20);

a_nr_of_rows := TO_NUMBER(a_curr_line.arg23);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_value(x) := SUBSTR(l_curr_line.arg21, 1, 40);
   a_sqltext(x) := SUBSTR(l_curr_line.arg22, 1, 255);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg24, 1, 255);

l_ret_code := UNAPIGK.SaveGroupkeyMe
          (a_gk, a_description, a_is_protected, a_value_unique,
           a_single_valued, a_new_val_allowed, a_mandatory, a_struct_created,
           a_inherit_gk, a_value_list_tp, a_default_value, a_dsp_rows, a_val_length, a_val_start,
           a_assign_tp, a_assign_id, a_q_tp, a_q_id, a_q_check_au, a_q_au,
           a_value, a_sqltext, a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveGroupkeyMe;

FUNCTION HandleSaveParameterProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_pp                     VARCHAR2(20);
a_version                VARCHAR2(20);
a_pp_key1                VARCHAR2(20);
a_pp_key2                VARCHAR2(20);
a_pp_key3                VARCHAR2(20);
a_pp_key4                VARCHAR2(20);
a_pp_key5                VARCHAR2(20);
a_version_is_current     CHAR(1);
a_effective_from         TIMESTAMP WITH TIME ZONE;
a_effective_till         TIMESTAMP WITH TIME ZONE;
a_description            VARCHAR2(40);
a_description2           VARCHAR2(40);
a_unit                   VARCHAR2(20);
a_format                 VARCHAR2(40);
a_confirm_assign         CHAR(1);
a_allow_any_pr           CHAR(1);
a_never_create_methods   CHAR(1);
a_delay                  NUMBER;
a_delay_unit             VARCHAR2(20);
a_is_template            CHAR(1);
a_sc_lc                  VARCHAR2(2);
a_sc_lc_version          VARCHAR2(20);
a_inherit_au             CHAR(1);
a_pp_class               VARCHAR2(2);
a_log_hs                 CHAR(1);
a_lc                     VARCHAR2(2);
a_lc_version             VARCHAR2(20);
a_modify_reason          VARCHAR2(255);

BEGIN

a_last_seq := a_curr_line.seq;

a_pp := SUBSTR(a_curr_line.arg1, 1, 20);
a_pp_key1 := SUBSTR(a_curr_line.arg3, 1, 20);
a_pp_key2 := SUBSTR(a_curr_line.arg4, 1, 20);
a_pp_key3 := SUBSTR(a_curr_line.arg5, 1, 20);
a_pp_key4 := SUBSTR(a_curr_line.arg6, 1, 20);
a_pp_key5 := SUBSTR(a_curr_line.arg7, 1, 20);
a_version := HandlePpVersion('pp', a_pp, SUBSTR(a_curr_line.arg2, 1, 20), a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5);

a_version_is_current := SUBSTR(a_curr_line.arg8, 1, 1);
a_effective_from := TO_DATE(a_curr_line.arg9);
a_effective_till := NULL;  --strictly ignored
a_description := SUBSTR(a_curr_line.arg11, 1, 40);
a_description2 := SUBSTR(a_curr_line.arg12, 1, 40);
a_unit := SUBSTR(a_curr_line.arg13, 1, 20);
a_format := SUBSTR(a_curr_line.arg14, 1, 40);
a_confirm_assign := SUBSTR(a_curr_line.arg15, 1, 1);
a_allow_any_pr := SUBSTR(a_curr_line.arg16, 1, 1);
a_never_create_methods := SUBSTR(a_curr_line.arg17, 1, 1);
a_delay := TO_NUMBER(a_curr_line.arg18);
a_delay_unit := SUBSTR(a_curr_line.arg19, 1, 20);
a_is_template := SUBSTR(a_curr_line.arg20, 1, 1);
a_sc_lc := SUBSTR(a_curr_line.arg21, 1, 2);
a_sc_lc_version := SUBSTR(a_curr_line.arg22, 1, 20);
a_inherit_au := SUBSTR(a_curr_line.arg23, 1, 1);
a_pp_class := SUBSTR(a_curr_line.arg24, 1, 2);
a_log_hs := SUBSTR(a_curr_line.arg25, 1, 1);
a_lc := SUBSTR(a_curr_line.arg26, 1, 2);
a_lc_version:= SUBSTR(a_curr_line.arg27, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg28, 1, 255);

 l_ret_code := UNAPIPP.SaveParameterProfile
             (a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5,
              a_version_is_current, a_effective_from, a_effective_till,
              a_description, a_description2, a_unit, a_format,
              a_confirm_assign,  a_allow_any_pr, a_never_create_methods,
              a_delay, a_delay_unit,
              a_is_template, a_sc_lc, a_sc_lc_version, a_inherit_au, a_pp_class, a_log_hs,
              a_lc, a_lc_version, a_modify_reason);

RETURN(l_ret_code);

END HandleSaveParameterProfile;

FUNCTION HandleSavePpParameter
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

 l_ret_code         NUMBER;

a_pp              VARCHAR2(20);
a_version         VARCHAR2(20);
a_pp_key1         VARCHAR2(20);
a_pp_key2         VARCHAR2(20);
a_pp_key3         VARCHAR2(20);
a_pp_key4         VARCHAR2(20);
a_pp_key5         VARCHAR2(20);
a_pr              UNAPIGEN.VC20_TABLE_TYPE;
a_pr_version      UNAPIGEN.VC20_TABLE_TYPE;
a_nr_measur       UNAPIGEN.NUM_TABLE_TYPE;
a_unit            UNAPIGEN.VC20_TABLE_TYPE;
a_format          UNAPIGEN.VC40_TABLE_TYPE;
a_allow_add       UNAPIGEN.CHAR1_TABLE_TYPE;
a_is_pp           UNAPIGEN.CHAR1_TABLE_TYPE;
a_freq_tp         UNAPIGEN.CHAR1_TABLE_TYPE;
a_freq_val        UNAPIGEN.NUM_TABLE_TYPE;
a_freq_unit       UNAPIGEN.VC20_TABLE_TYPE;
a_invert_freq     UNAPIGEN.CHAR1_TABLE_TYPE;
a_st_based_freq   UNAPIGEN.CHAR1_TABLE_TYPE;
a_last_sched      UNAPIGEN.DATE_TABLE_TYPE;
a_last_cnt        UNAPIGEN.NUM_TABLE_TYPE;
a_last_val        UNAPIGEN.VC40_TABLE_TYPE;
a_inherit_au      UNAPIGEN.CHAR1_TABLE_TYPE;
a_delay           UNAPIGEN.NUM_TABLE_TYPE;
a_delay_unit      UNAPIGEN.VC20_TABLE_TYPE;
a_mt              UNAPIGEN.VC20_TABLE_TYPE;
a_mt_version      UNAPIGEN.VC20_TABLE_TYPE;
a_mt_nr_measur    UNAPIGEN.NUM_TABLE_TYPE;
a_nr_of_rows      NUMBER;
a_modify_reason   VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_pp := SUBSTR(l_curr_line.arg1, 1, 20);
a_pp_key1 := SUBSTR(l_curr_line.arg3, 1, 20);
a_pp_key2 := SUBSTR(l_curr_line.arg4, 1, 20);
a_pp_key3 := SUBSTR(l_curr_line.arg5, 1, 20);
a_pp_key4 := SUBSTR(l_curr_line.arg6, 1, 20);
a_pp_key5 := SUBSTR(l_curr_line.arg7, 1, 20);
a_version := HandlePpVersion('pppr', a_pp, SUBSTR(a_curr_line.arg2, 1, 20), a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5);
a_nr_of_rows := TO_NUMBER(a_curr_line.arg29);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_pr(x) := SUBSTR(l_curr_line.arg8, 1, 20);
   a_pr_version(x) := SUBSTR(l_curr_line.arg9, 1, 20);
   a_nr_measur(x) := TO_NUMBER(l_curr_line.arg10);
   a_unit(x) := SUBSTR(l_curr_line.arg11, 1, 20);
   a_format(x) := SUBSTR(l_curr_line.arg12, 1, 40);
   a_allow_add(x) := SUBSTR(l_curr_line.arg13, 1, 1);
   a_is_pp(x) := SUBSTR(l_curr_line.arg14, 1, 1);
   a_freq_tp(x) := SUBSTR(l_curr_line.arg15, 1, 1);
   a_freq_val(x) := TO_NUMBER(l_curr_line.arg16);
   a_freq_unit(x) := SUBSTR(l_curr_line.arg17, 1, 20);
   a_invert_freq(x) := SUBSTR(l_curr_line.arg18, 1, 1);
   a_st_based_freq(x) := SUBSTR(l_curr_line.arg19, 1, 1);
   a_last_sched(x) := TO_DATE(l_curr_line.arg20);
   a_last_cnt(x) := TO_NUMBER(l_curr_line.arg21);
   a_last_val(x) := SUBSTR(l_curr_line.arg22, 1, 40);
   a_inherit_au(x) := SUBSTR(l_curr_line.arg23, 1, 1);
   a_delay(x) := TO_NUMBER(l_curr_line.arg24);
   a_delay_unit(x) := SUBSTR(l_curr_line.arg25, 1, 20);
   a_mt(x) := SUBSTR(l_curr_line.arg26, 1, 20);
   a_mt_version(x) := SUBSTR(l_curr_line.arg27, 1, 20);
   a_mt_nr_measur(x) := TO_NUMBER(l_curr_line.arg28);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg30, 1, 255);

l_ret_code := UNAPIPP.SavePpParameter
             (a_pp, a_version,
              a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5,
              a_pr, a_pr_version,
              a_nr_measur, a_unit, a_format,
              a_allow_add , a_is_pp, a_freq_tp,
              a_freq_val, a_freq_unit,
              a_invert_freq, a_st_based_freq,
              a_last_sched, a_last_cnt,
              a_last_val, a_inherit_au, a_delay,
              a_delay_unit, a_mt, a_mt_version, a_mt_nr_measur,
              a_nr_of_rows, a_modify_reason );

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSavePpParameter;


FUNCTION HandleSavePpParameterSpecs
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code                NUMBER;
l_pppr_nr_of_rows         NUMBER;
l_current_pppr_pos        INTEGER;
l_new_current_pppr_pos    INTEGER;
l_assigned                BOOLEAN;

a_pp               VARCHAR2(20);
a_version          VARCHAR2(20);
a_pp_key1          VARCHAR2(20);
a_pp_key2          VARCHAR2(20);
a_pp_key3          VARCHAR2(20);
a_pp_key4          VARCHAR2(20);
a_pp_key5          VARCHAR2(20);
a_pr               UNAPIGEN.VC20_TABLE_TYPE;
a_pr_version       UNAPIGEN.VC20_TABLE_TYPE;
a_spec_set         CHAR(1);
a_low_limit        UNAPIGEN.FLOAT_TABLE_TYPE;
a_high_limit       UNAPIGEN.FLOAT_TABLE_TYPE;
a_low_spec         UNAPIGEN.FLOAT_TABLE_TYPE;
a_high_spec        UNAPIGEN.FLOAT_TABLE_TYPE;
a_low_dev          UNAPIGEN.FLOAT_TABLE_TYPE;
a_rel_low_dev      UNAPIGEN.CHAR1_TABLE_TYPE;
a_target           UNAPIGEN.FLOAT_TABLE_TYPE;
a_high_dev         UNAPIGEN.FLOAT_TABLE_TYPE;
a_rel_high_dev     UNAPIGEN.CHAR1_TABLE_TYPE;
a_nr_of_rows       NUMBER;
a_modify_reason    VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

CURSOR l_pppr_cursor IS
   SELECT pr, pr_version
   FROM utpppr
   WHERE pp = a_pp
   AND version = a_version
   AND pp_key1 = a_pp_key1
   AND pp_key2 = a_pp_key2
   AND pp_key3 = a_pp_key3
   AND pp_key4 = a_pp_key4
   AND pp_key5 = a_pp_key5
   ORDER BY seq;

BEGIN

l_curr_line := a_curr_line;

a_pp := SUBSTR(l_curr_line.arg1, 1, 20);
a_pp_key1 := SUBSTR(l_curr_line.arg3, 1, 20);
a_pp_key2 := SUBSTR(l_curr_line.arg4, 1, 20);
a_pp_key3 := SUBSTR(l_curr_line.arg5, 1, 20);
a_pp_key4 := SUBSTR(l_curr_line.arg6, 1, 20);
a_pp_key5 := SUBSTR(l_curr_line.arg7, 1, 20);
a_version := HandlePpVersion('ppsp', a_pp, SUBSTR(a_curr_line.arg2, 1, 20), a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5);
a_nr_of_rows := TO_NUMBER(a_curr_line.arg20);
a_spec_set := SUBSTR(l_curr_line.arg10, 1, 1);

--specifications must be mapped with entries in utpppr
--with its corresponding position
l_pppr_nr_of_rows := 0;
FOR l_pppr_rec IN l_pppr_cursor LOOP
   l_pppr_nr_of_rows := l_pppr_nr_of_rows+1;
   a_pr(l_pppr_nr_of_rows) := l_pppr_rec.pr;
   a_pr_version(l_pppr_nr_of_rows) := l_pppr_rec.pr_version;
   a_low_limit(l_pppr_nr_of_rows) := NULL;
   a_high_limit(l_pppr_nr_of_rows) := NULL;
   a_low_spec(l_pppr_nr_of_rows) := NULL;
   a_high_spec(l_pppr_nr_of_rows) := NULL;
   a_low_dev(l_pppr_nr_of_rows) := NULL;
   a_rel_low_dev(l_pppr_nr_of_rows) := '0';
   a_target(l_pppr_nr_of_rows) := NULL;
   a_high_dev (l_pppr_nr_of_rows) := NULL;
   a_rel_high_dev (l_pppr_nr_of_rows) := '0';
END LOOP;

l_current_pppr_pos := 1;
OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;
   l_assigned := FALSE;

   --find pr in pppr
   FOR l_pos IN l_current_pppr_pos..l_pppr_nr_of_rows LOOP
      IF SUBSTR(l_curr_line.arg8, 1, 20) = a_pr(l_pos)
          -- AND SUBSTR(l_curr_line.arg9, 1, 20) = a_pr_version(l_pos) /* proived pr_version ignored; check based on position - left for customisation */
      THEN
         a_low_limit(l_pos) := TO_NUMBER(l_curr_line.arg11);
         a_high_limit(l_pos) := TO_NUMBER(l_curr_line.arg12);
         a_low_spec(l_pos) := TO_NUMBER(l_curr_line.arg13);
         a_high_spec(l_pos) := TO_NUMBER(l_curr_line.arg14);
         a_low_dev(l_pos) := TO_NUMBER(l_curr_line.arg15);
         a_rel_low_dev(l_pos) := SUBSTR(l_curr_line.arg16, 1, 1);
         a_target(l_pos) := TO_NUMBER(l_curr_line.arg17);
         a_high_dev (l_pos) := TO_NUMBER(l_curr_line.arg18);
         a_rel_high_dev (l_pos) := SUBSTR(l_curr_line.arg19, 1, 1);
         l_new_current_pppr_pos := l_pos+1;
         l_assigned := TRUE;
         EXIT;
      ELSE
         l_new_current_pppr_pos := l_pos+1;
      END IF;
   END LOOP;
   l_current_pppr_pos := l_new_current_pppr_pos;

   IF NOT l_assigned THEN
      DBMS_OUTPUT.PUT_LINE('Line ' || TO_CHAR(l_curr_line.seq) ||
                           ' Specifications provided for a parameter that is not part of the parameter profile');
   END IF;

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg21, 1, 255);

l_ret_code := UNAPIPP.SavePpParameterSpecs
             (a_pp, a_version,
              a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5,
              a_pr, a_pr_version, a_spec_set,
              a_low_limit, a_high_limit,
              a_low_spec, a_high_spec,
              a_low_dev, a_rel_low_dev,
              a_target, a_high_dev,
              a_rel_high_dev,
              l_pppr_nr_of_rows, a_modify_reason );

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSavePpParameterSpecs;


FUNCTION HandleSaveParameter
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_pr                         VARCHAR2(20);
a_version                    VARCHAR2(20);
a_version_is_current         CHAR(1);
a_effective_from             TIMESTAMP WITH TIME ZONE;
a_effective_till             TIMESTAMP WITH TIME ZONE;
a_description                VARCHAR2(40);
a_description2               VARCHAR2(40);
a_unit                       VARCHAR2(20);
a_format                     VARCHAR2(40);
a_td_info                    NUMBER;
a_td_info_unit               VARCHAR2(20);
a_confirm_uid                CHAR(1);
a_def_val_tp                 CHAR(1);
a_def_au_level               VARCHAR2(4);
a_def_val                    VARCHAR2(40);
a_allow_any_mt               CHAR(1);
a_delay                      NUMBER;
a_delay_unit                 VARCHAR2(20);
a_min_nr_results             NUMBER;
a_calc_method                CHAR(1);
a_calc_cf                    VARCHAR2(20);
a_alarm_order                VARCHAR2(3);
a_seta_specs                 VARCHAR2(20);
a_seta_limits                VARCHAR2(20);
a_seta_target                VARCHAR2(20);
a_setb_specs                 VARCHAR2(20);
a_setb_limits                VARCHAR2(20);
a_setb_target                VARCHAR2(20);
a_setc_specs                 VARCHAR2(20);
a_setc_limits                VARCHAR2(20);
a_setc_target                VARCHAR2(20);
a_is_template                CHAR(1);
a_log_exceptions             CHAR(1);
a_sc_lc                      VARCHAR2(2);
a_sc_lc_version              VARCHAR2(20);
a_inherit_au                 CHAR(1);
a_pr_class                   VARCHAR2(2);
a_log_hs                     CHAR(1);
a_lc                         VARCHAR2(2);
a_lc_version                 VARCHAR2(20);
a_modify_reason              VARCHAR2(255);

BEGIN

a_last_seq := a_curr_line.seq;

a_pr := SUBSTR(a_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('pr', a_pr, SUBSTR(a_curr_line.arg2, 1, 20));
a_version_is_current := SUBSTR(a_curr_line.arg3, 1, 1);
a_effective_from := TO_DATE(a_curr_line.arg4);
a_effective_till := NULL;  --strictly ignored
a_description := SUBSTR(a_curr_line.arg6, 1, 40);
a_description2 := SUBSTR(a_curr_line.arg7, 1, 40);
a_unit := SUBSTR(a_curr_line.arg8, 1, 20);
a_format := SUBSTR(a_curr_line.arg9, 1, 40);
a_td_info := TO_NUMBER(a_curr_line.arg10);
a_td_info_unit := SUBSTR(a_curr_line.arg11, 1, 20);
a_confirm_uid := SUBSTR(a_curr_line.arg12, 1, 1);
a_def_val_tp := SUBSTR(a_curr_line.arg13, 1, 1);
a_def_au_level := SUBSTR(a_curr_line.arg14, 1, 4);
a_def_val := SUBSTR(a_curr_line.arg15, 1, 40);
a_allow_any_mt := SUBSTR(a_curr_line.arg16, 1, 1);
a_delay := TO_NUMBER(a_curr_line.arg17);
a_delay_unit := SUBSTR(a_curr_line.arg18, 1, 20);
a_min_nr_results := TO_NUMBER(a_curr_line.arg19);
a_calc_method := SUBSTR(a_curr_line.arg20, 1, 1);
a_calc_cf := SUBSTR(a_curr_line.arg21, 1, 20);
a_alarm_order := SUBSTR(a_curr_line.arg22, 1, 3);
a_seta_specs := SUBSTR(a_curr_line.arg23, 1, 20);
a_seta_limits := SUBSTR(a_curr_line.arg24, 1, 20);
a_seta_target := SUBSTR(a_curr_line.arg25, 1, 20);
a_setb_specs := SUBSTR(a_curr_line.arg26, 1, 20);
a_setb_limits := SUBSTR(a_curr_line.arg27, 1, 20);
a_setb_target := SUBSTR(a_curr_line.arg28, 1, 20);
a_setc_specs := SUBSTR(a_curr_line.arg29, 1, 20);
a_setc_limits := SUBSTR(a_curr_line.arg30, 1, 20);
a_setc_target := SUBSTR(a_curr_line.arg31, 1, 20);
a_is_template := SUBSTR(a_curr_line.arg32, 1, 1);
a_log_exceptions := SUBSTR(a_curr_line.arg33, 1, 1);
a_sc_lc := SUBSTR(a_curr_line.arg34, 1, 2);
a_sc_lc_version := SUBSTR(a_curr_line.arg35, 1, 20);
a_inherit_au := SUBSTR(a_curr_line.arg36, 1, 1);
a_pr_class := SUBSTR(a_curr_line.arg37, 1, 2);
a_log_hs := SUBSTR(a_curr_line.arg38, 1, 1);
a_lc := SUBSTR(a_curr_line.arg39, 1, 2);
a_lc_version := SUBSTR(a_curr_line.arg40, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg41, 1, 255);

l_ret_code := UNAPIPR.SaveParameter
             (a_pr, a_version, a_version_is_current, a_effective_from, a_effective_till,
              a_description, a_description2, a_unit, a_format, a_td_info, a_td_info_unit,
              a_confirm_uid, a_def_val_tp, a_def_au_level, a_def_val,
              a_allow_any_mt, a_delay, a_delay_unit, a_min_nr_results,
              a_calc_method, a_calc_cf,
              a_alarm_order, a_seta_specs, a_seta_limits, a_seta_target,
              a_setb_specs, a_setb_limits, a_setb_target, a_setc_specs,
              a_setc_limits, a_setc_target, a_is_template, a_log_exceptions,
              a_sc_lc, a_sc_lc_version, a_inherit_au, a_pr_class,
              a_log_hs, a_lc, a_lc_version, a_modify_reason);

RETURN(l_ret_code);

END HandleSaveParameter;


FUNCTION HandleSavePrMethod
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_pr                       VARCHAR2(20);
a_version                  VARCHAR2(20);
a_mt                       UNAPIGEN.VC20_TABLE_TYPE;
a_mt_version               UNAPIGEN.VC20_TABLE_TYPE;
a_nr_measur                UNAPIGEN.NUM_TABLE_TYPE;
a_unit                     UNAPIGEN.VC20_TABLE_TYPE;
a_format                   UNAPIGEN.VC40_TABLE_TYPE;
a_allow_add                UNAPIGEN.CHAR1_TABLE_TYPE;
a_ignore_other             UNAPIGEN.CHAR1_TABLE_TYPE;
a_accuracy                 UNAPIGEN.FLOAT_TABLE_TYPE;
a_freq_tp                  UNAPIGEN.CHAR1_TABLE_TYPE;
a_freq_val                 UNAPIGEN.NUM_TABLE_TYPE;
a_freq_unit                UNAPIGEN.VC20_TABLE_TYPE;
a_invert_freq              UNAPIGEN.CHAR1_TABLE_TYPE;
a_st_based_freq            UNAPIGEN.CHAR1_TABLE_TYPE;
a_last_sched               UNAPIGEN.DATE_TABLE_TYPE;
a_last_cnt                 UNAPIGEN.NUM_TABLE_TYPE;
a_last_val                 UNAPIGEN.VC40_TABLE_TYPE;
a_inherit_au               UNAPIGEN.CHAR1_TABLE_TYPE;
a_nr_of_rows               NUMBER;
a_modify_reason            VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_pr := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('prmt', a_pr, SUBSTR(a_curr_line.arg2, 1, 20));
a_nr_of_rows := TO_NUMBER(a_curr_line.arg20);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_mt(x) := SUBSTR(l_curr_line.arg3, 1, 20);
   a_mt_version(x) := SUBSTR(l_curr_line.arg4, 1, 20);
   a_nr_measur(x) := TO_NUMBER(l_curr_line.arg5);
   a_unit(x) := SUBSTR(l_curr_line.arg6, 1, 20);
   a_format(x) := SUBSTR(l_curr_line.arg7, 1, 40);
   a_allow_add(x) := SUBSTR(l_curr_line.arg8, 1, 1);
   a_ignore_other(x) := SUBSTR(l_curr_line.arg9, 1, 1);
   a_accuracy(x) := TO_NUMBER(l_curr_line.arg10);
   a_freq_tp(x) := SUBSTR(l_curr_line.arg11, 1, 1);
   a_freq_val(x) := TO_NUMBER(l_curr_line.arg12);
   a_freq_unit(x) := SUBSTR(l_curr_line.arg13, 1, 20);
   a_invert_freq(x) := SUBSTR(l_curr_line.arg14, 1, 1);
   a_st_based_freq(x) := SUBSTR(l_curr_line.arg15, 1, 1);
   a_last_sched(x) := TO_DATE(l_curr_line.arg16);
   a_last_cnt(x) := TO_NUMBER(l_curr_line.arg17);
   a_last_val(x) := SUBSTR(l_curr_line.arg18, 1, 40);
   a_inherit_au(x) := SUBSTR(l_curr_line.arg19, 1, 1);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg21, 1, 255);

l_ret_code := UNAPIPR.SavePrMethod
              (a_pr, a_version, a_mt, a_mt_version,
               a_nr_measur, a_unit, a_format,
               a_allow_add, a_ignore_other, a_accuracy,
               a_freq_tp, a_freq_val, a_freq_unit,
               a_invert_freq, a_st_based_freq,
               a_last_sched, a_last_cnt,
               a_last_val, a_inherit_au,
               a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSavePrMethod;


FUNCTION HandleSaveMethod
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_mt                      VARCHAR2(20);
a_version                 VARCHAR2(20);
a_version_is_current      CHAR(1);
a_effective_from          TIMESTAMP WITH TIME ZONE;
a_effective_till          TIMESTAMP WITH TIME ZONE;
a_description             VARCHAR2(40);
a_description2            VARCHAR2(40);
a_unit                    VARCHAR2(20);
a_est_cost                VARCHAR2(40);
a_est_time                VARCHAR2(40);
a_accuracy                NUMBER;
a_is_template             CHAR(1);
a_calibration             CHAR(1);
a_autorecalc              CHAR(1);
a_confirm_complete        CHAR(1);
a_auto_create_cells       CHAR(1);
a_me_result_editable      CHAR(1);
a_executor                VARCHAR2(20);
a_eq_tp                   VARCHAR2(20);
a_sop                     VARCHAR2(40);
a_sop_version             VARCHAR2(20);
a_plaus_low               NUMBER;
a_plaus_high              NUMBER;
a_winsize_x               NUMBER;
a_winsize_y               NUMBER;
a_sc_lc                   VARCHAR2(2);
a_sc_lc_version           VARCHAR2(20);
a_def_val_tp              CHAR(1);
a_def_au_level            VARCHAR2(4);
a_def_val                 VARCHAR2(40);
a_format                  VARCHAR2(40);
a_inherit_au              CHAR(1);
a_mt_class                VARCHAR2(2);
a_log_hs                  CHAR(1);
a_lc                      VARCHAR2(2);
a_lc_version              VARCHAR2(20);
a_modify_reason           VARCHAR2(255);

BEGIN

a_last_seq := a_curr_line.seq;

a_mt := SUBSTR(a_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('mt', a_mt, SUBSTR(a_curr_line.arg2, 1, 20));
a_version_is_current := SUBSTR(a_curr_line.arg3, 1, 1);
a_effective_from := TO_DATE(a_curr_line.arg4);
a_effective_till := NULL;  --strictly ignored
a_description := SUBSTR(a_curr_line.arg6, 1, 40);
a_description2 := SUBSTR(a_curr_line.arg7, 1, 40);
a_unit := SUBSTR(a_curr_line.arg8, 1, 20);
a_est_cost := SUBSTR(a_curr_line.arg9, 1, 40);
a_est_time := SUBSTR(a_curr_line.arg10, 1, 40);
a_accuracy := TO_NUMBER(a_curr_line.arg11);
a_is_template := SUBSTR(a_curr_line.arg12, 1, 1);
a_calibration := SUBSTR(a_curr_line.arg13, 1, 1);
a_autorecalc := SUBSTR(a_curr_line.arg14, 1, 1);
a_confirm_complete := SUBSTR(a_curr_line.arg15, 1, 1);
a_auto_create_cells := SUBSTR(a_curr_line.arg16, 1, 1);
a_me_result_editable := SUBSTR(a_curr_line.arg17, 1, 1);
a_executor := SUBSTR(a_curr_line.arg18, 1, 20);
a_eq_tp := SUBSTR(a_curr_line.arg19, 1, 20);
a_sop := SUBSTR(a_curr_line.arg20, 1, 40);
a_sop_version := SUBSTR(a_curr_line.arg21, 1, 20);
a_plaus_low := TO_NUMBER(a_curr_line.arg22);
a_plaus_high := TO_NUMBER(a_curr_line.arg23);
a_winsize_x := TO_NUMBER(a_curr_line.arg24);
a_winsize_y := TO_NUMBER(a_curr_line.arg25);
a_sc_lc := SUBSTR(a_curr_line.arg26, 1, 2);
a_sc_lc_version := SUBSTR(a_curr_line.arg27, 1, 20);
a_def_val_tp := SUBSTR(a_curr_line.arg28, 1, 1);
a_def_au_level := SUBSTR(a_curr_line.arg29, 1, 4);
a_def_val := SUBSTR(a_curr_line.arg30, 1, 40);
a_format := SUBSTR(a_curr_line.arg31, 1, 40);
a_inherit_au := SUBSTR(a_curr_line.arg32, 1, 1);
a_mt_class := SUBSTR(a_curr_line.arg33, 1, 1);
a_log_hs := SUBSTR(a_curr_line.arg34, 1, 1);
a_lc := SUBSTR(a_curr_line.arg35, 1, 2);
a_lc_version := SUBSTR(a_curr_line.arg36, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg37, 1, 255);

 l_ret_code := UNAPIMT.SaveMethod(
              a_mt, a_version, a_version_is_current, a_effective_from, a_effective_till,
              a_description, a_description2, a_unit, a_est_cost, a_est_time, a_accuracy,
              a_is_template, a_calibration, a_autorecalc, a_confirm_complete,
              a_auto_create_cells, a_me_result_editable,
              a_executor, a_eq_tp, a_sop, a_sop_version,
              a_plaus_low, a_plaus_high, a_winsize_x, a_winsize_y,
              a_sc_lc, a_sc_lc_version, a_def_val_tp, a_def_au_level, a_def_val,
              a_format, a_inherit_au, a_mt_class, a_log_hs, a_lc, a_lc_version,
              a_modify_reason);

RETURN(l_ret_code);

END HandleSaveMethod;

FUNCTION HandleDeleteGKStStructures
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code           NUMBER;
a_gk                 VARCHAR2(20);

BEGIN

a_gk := SUBSTR(a_curr_line.arg1, 1, 20);
l_ret_code := UNAPIGK.DeleteGroupKeyStStructures(a_gk);
RETURN(l_ret_code);

END HandleDeleteGKStStructures;


FUNCTION HandleCreateGKStStructures
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code           NUMBER;
a_gk                 VARCHAR2(20);
a_stor_initial       VARCHAR2(20);
a_stor_next          VARCHAR2(20);
a_stor_min_extents   NUMBER;
a_stor_pct_increase  NUMBER;
a_stor_pct_free      NUMBER;
a_stor_pct_used      NUMBER;

BEGIN

a_gk := SUBSTR(a_curr_line.arg1, 1, 20);
a_stor_initial := SUBSTR(a_curr_line.arg2, 1, 20);
a_stor_next := SUBSTR(a_curr_line.arg3, 1, 20);
a_stor_min_extents := TO_NUMBER(a_curr_line.arg4);
a_stor_pct_increase := TO_NUMBER(a_curr_line.arg5);
a_stor_pct_free := TO_NUMBER(a_curr_line.arg6);
a_stor_pct_used := TO_NUMBER(a_curr_line.arg7);
l_ret_code := UNAPIGK.CreateGroupKeyStStructures(a_gk, a_stor_initial, a_stor_next,
              a_stor_min_extents, a_stor_pct_free, a_stor_pct_increase, a_stor_pct_used);
RETURN(l_ret_code);

END HandleCreateGKStStructures;


FUNCTION HandleDeleteGKScStructures
(a_curr_line     IN    utlkin%ROWTYPE,
a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code           NUMBER;
a_gk                 VARCHAR2(20);

BEGIN

a_gk := SUBSTR(a_curr_line.arg1, 1, 20);
l_ret_code := UNAPIGK.DeleteGroupKeyScStructures(a_gk);
RETURN(l_ret_code);

END HandleDeleteGKScStructures;


FUNCTION HandleCreateGKScStructures
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code           NUMBER;
a_gk                 VARCHAR2(20);
a_stor_initial       VARCHAR2(20);
a_stor_next          VARCHAR2(20);
a_stor_min_extents   NUMBER;
a_stor_pct_increase  NUMBER;
a_stor_pct_free      NUMBER;
a_stor_pct_used      NUMBER;


BEGIN

a_gk := SUBSTR(a_curr_line.arg1, 1, 20);
a_stor_initial := SUBSTR(a_curr_line.arg2, 1, 20);
a_stor_next := SUBSTR(a_curr_line.arg3, 1, 20);
a_stor_min_extents := TO_NUMBER(a_curr_line.arg4);
a_stor_pct_increase := TO_NUMBER(a_curr_line.arg5);
a_stor_pct_free := TO_NUMBER(a_curr_line.arg6);
a_stor_pct_used := TO_NUMBER(a_curr_line.arg7);

l_ret_code := UNAPIGK.CreateGroupKeyScStructures(a_gk, a_stor_initial, a_stor_next,
              a_stor_min_extents, a_stor_pct_free, a_stor_pct_increase, a_stor_pct_used);
RETURN(l_ret_code);

END HandleCreateGKScStructures;


FUNCTION HandleDeleteGKMeStructures
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code           NUMBER;
a_gk                 VARCHAR2(20);

BEGIN

a_gk := SUBSTR(a_curr_line.arg1, 1, 20);
l_ret_code := UNAPIGK.DeleteGroupKeyMeStructures(a_gk);
RETURN(l_ret_code);

END HandleDeleteGKMeStructures;


FUNCTION HandleCreateGKMeStructures
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code           NUMBER;
a_gk                 VARCHAR2(20);
a_stor_initial       VARCHAR2(20);
a_stor_next          VARCHAR2(20);
a_stor_min_extents   NUMBER;
a_stor_pct_increase  NUMBER;
a_stor_pct_free      NUMBER;
a_stor_pct_used      NUMBER;


BEGIN

a_gk := SUBSTR(a_curr_line.arg1, 1, 20);
a_stor_initial := SUBSTR(a_curr_line.arg2, 1, 20);
a_stor_next := SUBSTR(a_curr_line.arg3, 1, 20);
a_stor_min_extents := TO_NUMBER(a_curr_line.arg4);
a_stor_pct_increase := TO_NUMBER(a_curr_line.arg5);
a_stor_pct_free := TO_NUMBER(a_curr_line.arg6);
a_stor_pct_used := TO_NUMBER(a_curr_line.arg7);
l_ret_code := UNAPIGK.CreateGroupKeyMeStructures(a_gk, a_stor_initial, a_stor_next,
              a_stor_min_extents, a_stor_pct_free, a_stor_pct_increase, a_stor_pct_used);
RETURN(l_ret_code);

END HandleCreateGKMeStructures;


FUNCTION HandleSaveUserProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_up               NUMBER(5);
a_description      VARCHAR2(40);
a_dd               VARCHAR2(3);
a_descr_doc        VARCHAR2(40);
a_chg_pwd          CHAR(1);
a_define_menu      CHAR(1);
a_confirm_chg_ss   CHAR(1);
a_language         VARCHAR2(20);
a_up_class         VARCHAR2(2);
a_log_hs           CHAR(1);
a_lc               VARCHAR2(2);
a_modify_reason    VARCHAR2(255);

BEGIN

a_last_seq := a_curr_line.seq;

a_up := TO_NUMBER(a_curr_line.arg1);
a_description := SUBSTR(a_curr_line.arg2, 1, 40);
a_dd := SUBSTR(a_curr_line.arg3, 1, 3);
a_descr_doc := SUBSTR(a_curr_line.arg4, 1, 40);
a_chg_pwd := SUBSTR(a_curr_line.arg5, 1, 1);
a_define_menu := SUBSTR(a_curr_line.arg6,1, 1);
a_confirm_chg_ss := SUBSTR(a_curr_line.arg7, 1, 1);
a_language := SUBSTR(a_curr_line.arg8, 1, 20);
a_up_class := SUBSTR(a_curr_line.arg9, 1, 2);
a_log_hs := SUBSTR(a_curr_line.arg10, 1, 1);
a_lc := SUBSTR(a_curr_line.arg11, 1, 2);
a_modify_reason := SUBSTR(a_curr_line.arg12, 1, 255);

 l_ret_code := UNAPIUP.SaveUserProfile
             (a_up, a_description, a_dd, a_descr_doc, a_chg_pwd,
              a_define_menu, a_confirm_chg_ss, a_language, a_up_class,
              a_log_hs, a_lc, a_modify_reason);

RETURN(l_ret_code);

END HandleSaveUserProfile;


FUNCTION HandleSaveAddress
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_ad               VARCHAR2(20);
a_is_template      CHAR(1);
a_is_user          CHAR(1);
a_struct_created   CHAR(1);
a_ad_tp            VARCHAR2(20);
a_person           VARCHAR2(40);
a_title            VARCHAR2(20);
a_function_name    VARCHAR2(20);
a_def_up           NUMBER(5);
a_company          VARCHAR2(40);
a_street           VARCHAR2(40);
a_city             VARCHAR2(40);
a_state            VARCHAR2(40);
a_country          VARCHAR2(40);
a_ad_nr            VARCHAR2(20);
a_po_box           VARCHAR2(20);
a_zip_code         VARCHAR2(20);
a_phone_nr         VARCHAR2(20);
a_ext_nr           VARCHAR2(20);
a_fax_nr           VARCHAR2(20);
a_email            VARCHAR2(255);
a_ad_class         VARCHAR2(2);
a_log_hs           CHAR(1);
a_lc               VARCHAR2(2);
a_modify_reason    VARCHAR2(255);

BEGIN

a_last_seq := a_curr_line.seq;

a_ad := SUBSTR(a_curr_line.arg1, 1, 20);
a_is_template := SUBSTR(a_curr_line.arg2, 1, 1);
a_is_user := SUBSTR(a_curr_line.arg3, 1, 1);
a_struct_created := SUBSTR(a_curr_line.arg4, 1, 1);
a_ad_tp := SUBSTR(a_curr_line.arg5, 1, 20);
a_person := SUBSTR(a_curr_line.arg6, 1, 40);
a_title := SUBSTR(a_curr_line.arg7, 1, 20);
a_function_name := SUBSTR(a_curr_line.arg8, 1, 20);
a_def_up := TO_NUMBER(a_curr_line.arg9);
a_company := SUBSTR(a_curr_line.arg10, 1, 40);
a_street := SUBSTR(a_curr_line.arg11, 1, 40);
a_city := SUBSTR(a_curr_line.arg12, 1, 40);
a_state := SUBSTR(a_curr_line.arg13, 1, 40);
a_country := SUBSTR(a_curr_line.arg14, 1, 40);
a_ad_nr := SUBSTR(a_curr_line.arg15, 1, 20);
a_po_box := SUBSTR(a_curr_line.arg16, 1, 20);
a_zip_code := SUBSTR(a_curr_line.arg17, 1, 20);
a_phone_nr := SUBSTR(a_curr_line.arg18, 1, 20);
a_ext_nr := SUBSTR(a_curr_line.arg19, 1, 20);
a_fax_nr := SUBSTR(a_curr_line.arg20, 1, 20);
a_email := SUBSTR(a_curr_line.arg21, 1, 255);
a_ad_class := SUBSTR(a_curr_line.arg22, 1, 2);
a_log_hs := SUBSTR(a_curr_line.arg23, 1, 1);
a_lc := SUBSTR(a_curr_line.arg24, 1, 2);
a_modify_reason := SUBSTR(a_curr_line.arg25, 1, 255);

l_ret_code := UNAPIAD.SaveAddress
             (a_ad, a_is_template, a_is_user,
              a_struct_created, a_ad_tp, a_person,
              a_title, a_function_name, a_def_up, a_company, a_street, a_city,
              a_state, a_country, a_ad_nr, a_po_box, a_zip_code, a_phone_nr,
              a_ext_nr, a_fax_nr, a_email, a_ad_class, a_log_hs, a_lc,
              a_modify_reason);

RETURN(l_ret_code);
END HandleSaveAddress;


FUNCTION HandleSaveUpUser
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_up               NUMBER(5);
a_us               UNAPIGEN.VC20_TABLE_TYPE;
a_nr_of_rows       NUMBER;
a_modify_reason    VARCHAR2(255);


CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_up := TO_NUMBER(l_curr_line.arg1);
a_nr_of_rows := TO_NUMBER(a_curr_line.arg3);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_us(x) := SUBSTR(l_curr_line.arg2, 1, 20);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg4, 1, 255);

l_ret_code := UNAPIUP.SaveUpUser
              (a_up, a_us,
               a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);
END HandleSaveUpUser;

FUNCTION HandleSaveTask
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_tk_tp            VARCHAR2(20);
a_tk               VARCHAR2(20);
a_description      VARCHAR2(40);
a_col_id           UNAPIGEN.VC40_TABLE_TYPE;
a_col_tp           UNAPIGEN.VC40_TABLE_TYPE;
a_def_val          UNAPIGEN.VC40_TABLE_TYPE;
a_hidden           UNAPIGEN.CHAR1_TABLE_TYPE;
a_is_protected     UNAPIGEN.CHAR1_TABLE_TYPE;
a_mandatory        UNAPIGEN.CHAR1_TABLE_TYPE;
a_auto_refresh     UNAPIGEN.CHAR1_TABLE_TYPE;
a_col_asc          UNAPIGEN.CHAR1_TABLE_TYPE;
a_value_list_tp    UNAPIGEN.CHAR1_TABLE_TYPE;
a_dsp_len          UNAPIGEN.NUM_TABLE_TYPE;
a_nr_of_rows       NUMBER;
a_modify_reason    VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_tk := SUBSTR(l_curr_line.arg1, 1, 20);
a_tk_tp := SUBSTR(l_curr_line.arg2, 1, 20);
a_description := SUBSTR(l_curr_line.arg3, 1, 40);
a_nr_of_rows := TO_NUMBER(a_curr_line.arg14);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_col_id(x)  := SUBSTR(l_curr_line.arg4, 1, 40);
   a_col_tp(x)  := SUBSTR(l_curr_line.arg5, 1, 40);
   a_def_val(x) := SUBSTR(l_curr_line.arg6, 1, 40);
   a_hidden(x)  := SUBSTR(l_curr_line.arg7, 1, 1);
   a_is_protected(x)  := SUBSTR(l_curr_line.arg8, 1, 1);
   a_mandatory(x)  := SUBSTR(l_curr_line.arg9, 1, 1);
   a_auto_refresh(x)  := SUBSTR(l_curr_line.arg10, 1, 1);
   a_col_asc(x)  := SUBSTR(l_curr_line.arg11, 1, 1);
   a_value_list_tp(x)  := SUBSTR(l_curr_line.arg12, 1, 1);
   a_dsp_len(x)  := TO_NUMBER(l_curr_line.arg13);


   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg15, 1, 255);

l_ret_code := UNAPITK.SaveTask
              (a_tk, a_tk_tp, a_description, a_col_id,
               a_col_tp, a_def_val, a_hidden, a_is_protected, a_mandatory,
               a_auto_refresh, a_col_asc, a_value_list_tp, a_dsp_len, a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);
END HandleSaveTask;

FUNCTION HandleChangeObjectStatus
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;
l_curr_line           utlkin%ROWTYPE;
a_object_tp                   VARCHAR2(4);
a_object_id                   VARCHAR2(20);
a_object_version              VARCHAR2(20);
a_old_ss                      VARCHAR2(2);
a_new_ss                      VARCHAR2(2);
a_object_lc                   VARCHAR2(2);
a_object_lc_version           VARCHAR2(20);
a_modify_reason               VARCHAR2(255);

BEGIN
a_last_seq := a_curr_line.seq;

a_object_tp := SUBSTR(a_curr_line.arg1, 1, 4);
a_object_id := SUBSTR(a_curr_line.arg2, 1, 20);
a_object_version := SUBSTR(a_curr_line.arg3, 1, 20);
a_old_ss := SUBSTR(a_curr_line.arg4, 1, 2);
a_new_ss := SUBSTR(a_curr_line.arg5, 1, 2);
a_object_lc := SUBSTR(a_curr_line.arg6, 1, 2);
a_object_lc_version := SUBSTR(a_curr_line.arg7, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg8, 1, 255);

IF a_object_tp = 'pp' THEN
   l_ret_code := UNAPIPPP.CHANGEPPSTATUS
                   (a_object_id,
                    a_object_version,
                    ' ',
                    ' ',
                    ' ',
                    ' ',
                    ' ',
                    a_old_ss,
                    a_new_ss,
                    a_object_lc,
                    a_object_lc_version,
                    a_modify_reason);
ELSE
   l_ret_code := UNAPIPRP.CHANGEOBJECTSTATUS
                   (a_object_tp,
                    a_object_id,
                    a_object_version,
                    a_old_ss,
                    a_new_ss,
                    a_object_lc,
                    a_object_lc_version,
                    a_modify_reason);
END IF;
RETURN(l_ret_code);
END HandleChangeObjectStatus;

FUNCTION HandleChangePpStatus
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER  IS

l_ret_code         NUMBER;
l_curr_line           utlkin%ROWTYPE;
a_pp                          VARCHAR2(20);
a_version                     VARCHAR2(20);
a_pp_key1                     VARCHAR2(20);
a_pp_key2                     VARCHAR2(20);
a_pp_key3                     VARCHAR2(20);
a_pp_key4                     VARCHAR2(20);
a_pp_key5                     VARCHAR2(20);
a_old_ss                      VARCHAR2(2);
a_new_ss                      VARCHAR2(2);
a_object_lc                   VARCHAR2(2);
a_object_lc_version           VARCHAR2(20);
a_modify_reason               VARCHAR2(255);

BEGIN

a_last_seq := a_curr_line.seq;

a_pp := SUBSTR(a_curr_line.arg1, 1, 20);
a_version := SUBSTR(a_curr_line.arg2, 1, 20);
a_pp_key1 := SUBSTR(a_curr_line.arg3, 1, 20);
a_pp_key2 := SUBSTR(a_curr_line.arg4, 1, 20);
a_pp_key3 := SUBSTR(a_curr_line.arg5, 1, 20);
a_pp_key4 := SUBSTR(a_curr_line.arg6, 1, 20);
a_pp_key5 := SUBSTR(a_curr_line.arg7, 1, 20);
a_old_ss := SUBSTR(a_curr_line.arg8, 1, 2);
a_new_ss := SUBSTR(a_curr_line.arg9, 1, 2);
a_object_lc := SUBSTR(a_curr_line.arg10, 1, 2);
a_object_lc_version := SUBSTR(a_curr_line.arg11, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg12, 1, 255);

l_ret_code := UNAPIPPP.CHANGEPPSTATUS
                (a_pp,
                 a_version,
                 a_pp_key1,
                 a_pp_key2,
                 a_pp_key3,
                 a_pp_key4,
                 a_pp_key5,
                 a_old_ss,
                 a_new_ss,
                 a_object_lc,
                 a_object_lc_version,
                 a_modify_reason);
RETURN(l_ret_code);
END HandleChangePpStatus;

FUNCTION HandleChangeObjectLifeCycle
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_object_tp                   VARCHAR2(4);
a_object_id                   VARCHAR2(20);
a_object_version              VARCHAR2(20);
a_old_lc                      VARCHAR2(2);
a_old_lc_version              VARCHAR2(20);
a_new_lc                      VARCHAR2(2);
a_new_lc_version              VARCHAR2(20);
a_modify_reason               VARCHAR2(255);

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;
a_last_seq := a_curr_line.seq;

a_object_tp := SUBSTR(a_curr_line.arg1, 1, 4);
a_object_id := SUBSTR(a_curr_line.arg2, 1, 20);
a_object_version := SUBSTR(a_curr_line.arg3, 1, 20);
a_old_lc := SUBSTR(a_curr_line.arg4, 1, 2);
a_old_lc_version := SUBSTR(a_curr_line.arg5, 1, 20);
a_new_lc := SUBSTR(a_curr_line.arg6, 1, 2);
a_new_lc_version := SUBSTR(a_curr_line.arg7, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg8, 1, 255);

IF a_object_tp = 'pp' THEN
   l_ret_code := UNAPIPPP.CHANGEPPLIFECYCLE
                   (a_object_id,
                    a_object_version,
                    ' ',
                    ' ',
                    ' ',
                    ' ',
                    ' ',
                    a_old_lc,
                    a_old_lc_version,
                    a_new_lc,
                    a_new_lc_version,
                    a_modify_reason);
ELSE
   l_ret_code := UNAPIPRP.CHANGEOBJECTLIFECYCLE
                   (a_object_tp,
                    a_object_id,
                    a_object_version,
                    a_old_lc,
                    a_old_lc_version,
                    a_new_lc,
                    a_new_lc_version,
                    a_modify_reason);
END IF;
RETURN(l_ret_code);
END HandleChangeObjectLifeCycle;

FUNCTION HandleChangePpLifeCycle
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_pp                          VARCHAR2(20);
a_version                     VARCHAR2(20);
a_pp_key1                     VARCHAR2(20);
a_pp_key2                     VARCHAR2(20);
a_pp_key3                     VARCHAR2(20);
a_pp_key4                     VARCHAR2(20);
a_pp_key5                     VARCHAR2(20);
a_old_lc                      VARCHAR2(2);
a_old_lc_version              VARCHAR2(20);
a_new_lc                      VARCHAR2(2);
a_new_lc_version              VARCHAR2(20);
a_modify_reason               VARCHAR2(255);

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;
a_last_seq := a_curr_line.seq;

a_pp := SUBSTR(a_curr_line.arg1, 1, 20);
a_version := SUBSTR(a_curr_line.arg2, 1, 20);
a_pp_key1 := SUBSTR(a_curr_line.arg3, 1, 20);
a_pp_key2 := SUBSTR(a_curr_line.arg4, 1, 20);
a_pp_key3 := SUBSTR(a_curr_line.arg5, 1, 20);
a_pp_key4 := SUBSTR(a_curr_line.arg6, 1, 20);
a_pp_key5 := SUBSTR(a_curr_line.arg7, 1, 20);
a_old_lc := SUBSTR(a_curr_line.arg8, 1, 2);
a_old_lc_version := SUBSTR(a_curr_line.arg9, 1, 20);
a_new_lc := SUBSTR(a_curr_line.arg10, 1, 2);
a_new_lc_version := SUBSTR(a_curr_line.arg11, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg12, 1, 255);

l_ret_code := UNAPIPPP.CHANGEPPLIFECYCLE
                (a_pp,
                 a_version,
                 a_pp_key1,
                 a_pp_key2,
                 a_pp_key3,
                 a_pp_key4,
                 a_pp_key5,
                 a_old_lc,
                 a_old_lc_version,
                 a_new_lc,
                 a_new_lc_version,
                 a_modify_reason);
RETURN(l_ret_code);
END HandleChangePpLifeCycle;

FUNCTION HandleSaveObjectAccess
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_object_tp                   VARCHAR2(4);
a_object_id                   VARCHAR2(20);
a_object_version              VARCHAR2(20);
a_dd                          UNAPIGEN.VC3_TABLE_TYPE;
a_access_rights               UNAPIGEN.CHAR1_TABLE_TYPE;
a_nr_of_rows                  NUMBER;
a_modify_reason               VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_object_tp := SUBSTR(l_curr_line.arg1, 1, 2);
a_object_id := SUBSTR(l_curr_line.arg2, 1, 20);
a_object_version := SUBSTR(l_curr_line.arg3, 1, 20);
a_nr_of_rows := TO_NUMBER(a_curr_line.arg6);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_dd(x) := SUBSTR(l_curr_line.arg4, 1, 3);
   a_access_rights(x) := SUBSTR(l_curr_line.arg5, 1, 1);
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg7, 1, 255);

IF a_object_tp = 'pp' THEN
   l_ret_code := UNAPIPPP.SavePpAccess
                 (a_object_id,
                  a_object_version,
                  ' ',
                  ' ',
                  ' ',
                  ' ',
                  ' ',
                  a_dd,
                  a_access_rights,
                  a_nr_of_rows,
                  a_modify_reason);
ELSE
   l_ret_code := UNAPIPRP.SaveObjectAccess
                 (a_object_tp,
                  a_object_id,
                  a_object_version,
                  a_dd,
                  a_access_rights,
                  a_nr_of_rows,
                  a_modify_reason);
END IF;
CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveObjectAccess;

FUNCTION HandleSavePpAccess
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_pp                          VARCHAR2(20);
a_version                     VARCHAR2(20);
a_pp_key1                     VARCHAR2(20);
a_pp_key2                     VARCHAR2(20);
a_pp_key3                     VARCHAR2(20);
a_pp_key4                     VARCHAR2(20);
a_pp_key5                     VARCHAR2(20);
a_dd                          UNAPIGEN.VC3_TABLE_TYPE;
a_access_rights               UNAPIGEN.CHAR1_TABLE_TYPE;
a_nr_of_rows                  NUMBER;
a_modify_reason               VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_pp := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := SUBSTR(l_curr_line.arg2, 1, 20);
a_pp_key1 := SUBSTR(l_curr_line.arg3, 1, 20);
a_pp_key2 := SUBSTR(l_curr_line.arg4, 1, 20);
a_pp_key3 := SUBSTR(l_curr_line.arg5, 1, 20);
a_pp_key4 := SUBSTR(l_curr_line.arg6, 1, 20);
a_pp_key5 := SUBSTR(l_curr_line.arg7, 1, 20);
a_nr_of_rows := TO_NUMBER(a_curr_line.arg10);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_dd(x) := SUBSTR(l_curr_line.arg8, 1, 3);
   a_access_rights(x) := SUBSTR(l_curr_line.arg9, 1, 1);
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg11, 1, 255);

l_ret_code := UNAPIPPP.SavePpAccess
              (a_pp,
               a_version,
               a_pp_key1,
               a_pp_key2,
               a_pp_key3,
               a_pp_key4,
               a_pp_key5,
               a_dd,
               a_access_rights,
               a_nr_of_rows,
               a_modify_reason);
CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSavePpAccess;

FUNCTION HandleBeginTransaction
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;
l_curr_line           utlkin%ROWTYPE;

BEGIN
a_last_seq := a_curr_line.seq;

l_ret_code := UNAPIGEN.BEGINTRANSACTION;

RETURN(l_ret_code);
END HandleBeginTransaction;

FUNCTION HandleEndTransaction
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS
l_ret_code         NUMBER;
l_curr_line           utlkin%ROWTYPE;

BEGIN

a_last_seq := a_curr_line.seq;

l_ret_code := UNAPIGEN.ENDTRANSACTION;

RETURN(l_ret_code);
END HandleEndTransaction;


FUNCTION HandleSynchrEndTransaction
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;
l_curr_line           utlkin%ROWTYPE;
l_debug             VARCHAR2(255);
BEGIN

a_last_seq := a_curr_line.seq;

l_ret_code := UNAPIGEN.SYNCHRENDTRANSACTION;

RETURN(l_ret_code);
END HandleSYNCHREndTransaction;


FUNCTION HandleSaveObjectAttribute
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_object_tp                   VARCHAR2(4);
a_object_id                   VARCHAR2(20);
a_object_version              VARCHAR2(20);
a_nr_of_rows                  NUMBER;
a_modify_reason               VARCHAR2(255);
a_au_tab                      UNAPIGEN.VC20_TABLE_TYPE;
a_au_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
a_value_tab                   UNAPIGEN.VC40_TABLE_TYPE;

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

l_debug               VARCHAR2(255);

BEGIN

l_curr_line := a_curr_line;

a_object_tp := SUBSTR(l_curr_line.arg1, 1, 4);
a_object_id := SUBSTR(l_curr_line.arg2, 1, 20);
a_object_version := HandleObjectVersion(a_object_tp||'au', a_object_id, SUBSTR(a_curr_line.arg3, 1, 20));

a_nr_of_rows := TO_NUMBER(l_curr_line.arg7);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_au_tab(x) := SUBSTR(l_curr_line.arg4, 1, 20);
   a_au_version_tab(x) := SUBSTR(l_curr_line.arg5, 1, 20);
   a_value_tab(x) := SUBSTR(l_curr_line.arg6, 1, 40);
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg8, 1, 255);

IF a_object_tp='pp' THEN

   l_ret_code := UNAPIPPP.SAVEPPATTRIBUTE
                 (a_object_id,
                  a_object_version,
                  ' ',
                  ' ',
                  ' ',
                  ' ',
                  ' ',
                  a_au_tab,
                  a_au_version_tab,
                  a_value_tab,
                  a_nr_of_rows,
                  a_modify_reason);

ELSE
   l_ret_code := UNAPIPRP.SAVEOBJECTATTRIBUTE
                (a_object_tp,
                 a_object_id,
                 a_object_version,
                 a_au_tab,
                 a_au_version_tab,
                 a_value_tab,
                 a_nr_of_rows,
                 a_modify_reason);
END IF;

CLOSE l_next_line_cursor;

RETURN(l_ret_code);
END HandleSaveObjectAttribute;

FUNCTION HandleSavePpAttribute
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_pp                          VARCHAR2(20);
a_version                     VARCHAR2(20);
a_pp_key1                     VARCHAR2(20);
a_pp_key2                     VARCHAR2(20);
a_pp_key3                     VARCHAR2(20);
a_pp_key4                     VARCHAR2(20);
a_pp_key5                     VARCHAR2(20);
a_nr_of_rows                  NUMBER;
a_modify_reason               VARCHAR2(255);
a_au_tab                      UNAPIGEN.VC20_TABLE_TYPE;
a_au_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
a_value_tab                   UNAPIGEN.VC40_TABLE_TYPE;

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

l_debug               VARCHAR2(255);

BEGIN

l_curr_line := a_curr_line;

a_pp := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('ppau', a_pp, SUBSTR(a_curr_line.arg2, 1, 20));
a_pp_key1 := SUBSTR(l_curr_line.arg3, 1, 20);
a_pp_key2 := SUBSTR(l_curr_line.arg4, 1, 20);
a_pp_key3 := SUBSTR(l_curr_line.arg5, 1, 20);
a_pp_key4 := SUBSTR(l_curr_line.arg6, 1, 20);
a_pp_key5 := SUBSTR(l_curr_line.arg7, 1, 20);

a_nr_of_rows := TO_NUMBER(l_curr_line.arg11);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_au_tab(x) := SUBSTR(l_curr_line.arg8, 1, 20);
   a_au_version_tab(x) := SUBSTR(l_curr_line.arg9, 1, 20);
   a_value_tab(x) := SUBSTR(l_curr_line.arg10, 1, 40);
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg12, 1, 255);

l_ret_code := UNAPIPPP.SAVEPPATTRIBUTE
              (a_pp,
               a_version,
               a_pp_key1,
               a_pp_key2,
               a_pp_key3,
               a_pp_key4,
               a_pp_key5,
               a_au_tab,
               a_au_version_tab,
               a_value_tab,
               a_nr_of_rows,
               a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);
END HandleSavePpAttribute;

FUNCTION HandleSaveUsedObjectAttribute
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_object_tp                   VARCHAR2(4);
a_used_object_tp              VARCHAR2(4);
a_object_id                   VARCHAR2(20);
a_object_version              VARCHAR2(20);
a_used_object_id              VARCHAR2(20);
a_used_object_version         VARCHAR2(20);
a_nr_of_rows                  NUMBER;
a_modify_reason               VARCHAR2(255);
a_au_tab                      UNAPIGEN.VC20_TABLE_TYPE;
a_au_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
a_value_tab                   UNAPIGEN.VC40_TABLE_TYPE;

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;
a_last_seq := a_curr_line.seq;

a_object_tp := SUBSTR(a_curr_line.arg1, 1, 4);
a_used_object_tp := SUBSTR(a_curr_line.arg2, 1, 4);
a_object_id := SUBSTR(a_curr_line.arg3, 1, 20);
a_object_version := HandleObjectVersion(a_object_tp||'au', a_object_id, SUBSTR(a_curr_line.arg4, 1, 20));
a_used_object_id := SUBSTR(a_curr_line.arg5, 1, 20);
a_used_object_version := SUBSTR(a_curr_line.arg6, 1, 20);

a_nr_of_rows := TO_NUMBER(a_curr_line.arg10);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_au_tab(x) := SUBSTR(l_curr_line.arg7, 1, 20);
   a_au_version_tab(x) := SUBSTR(l_curr_line.arg8, 1, 20);
   a_value_tab(x) := SUBSTR(l_curr_line.arg9, 1, 40);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg11, 1, 255);

IF a_object_tp = 'pp' THEN
   l_ret_code := UNAPIPPP.SAVEPPPRATTRIBUTE
                (a_object_id,
                 a_object_version,
                 ' ',
                 ' ',
                 ' ',
                 ' ',
                 ' ',
                 a_used_object_id,
                 a_used_object_version,
                 a_au_tab,
                 a_au_version_tab,
                 a_value_tab,
                 a_nr_of_rows,
                 a_modify_reason);
ELSE
   l_ret_code := UNAPIPRP.SAVEUSEDOBJECTATTRIBUTE
                (a_object_tp,
                 a_used_object_tp,
                 a_object_id,
                 a_object_version,
                 a_used_object_id,
                 a_used_object_version,
                 a_au_tab,
                 a_au_version_tab,
                 a_value_tab,
                 a_nr_of_rows,
                 a_modify_reason);
END IF;

CLOSE l_next_line_cursor;

RETURN(l_ret_code);
END HandleSaveUsedObjectAttribute;

FUNCTION HandleSavePpPrAttribute
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER  IS

l_ret_code         NUMBER;

a_pp                          VARCHAR2(20);
a_version                     VARCHAR2(20);
a_pp_key1                     VARCHAR2(20);
a_pp_key2                     VARCHAR2(20);
a_pp_key3                     VARCHAR2(20);
a_pp_key4                     VARCHAR2(20);
a_pp_key5                     VARCHAR2(20);
a_pr                          VARCHAR2(20);
a_pr_version                  VARCHAR2(20);
a_nr_of_rows                  NUMBER;
a_modify_reason               VARCHAR2(255);
a_au_tab                      UNAPIGEN.VC20_TABLE_TYPE;
a_au_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
a_value_tab                   UNAPIGEN.VC40_TABLE_TYPE;

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;
a_last_seq := a_curr_line.seq;

a_pp := SUBSTR(a_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('ppau', a_pp, SUBSTR(a_curr_line.arg2, 1, 20));
a_pp_key1 := SUBSTR(a_curr_line.arg3, 1, 20);
a_pp_key2 := SUBSTR(a_curr_line.arg4, 1, 20);
a_pp_key3 := SUBSTR(a_curr_line.arg5, 1, 20);
a_pp_key4 := SUBSTR(a_curr_line.arg6, 1, 20);
a_pp_key5 := SUBSTR(a_curr_line.arg7, 1, 20);
a_pr := SUBSTR(a_curr_line.arg8, 1, 20);
a_pr_version := SUBSTR(a_curr_line.arg9, 1, 20);

a_nr_of_rows := TO_NUMBER(a_curr_line.arg13);
DBMS_OUTPUT.PUT_LINE('nr_rows='||a_nr_of_rows);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP
   a_au_tab(x) := SUBSTR(l_curr_line.arg10, 1, 20);
   a_au_version_tab(x) := SUBSTR(l_curr_line.arg11, 1, 20);
   a_value_tab(x) := SUBSTR(l_curr_line.arg12, 1, 40);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg14, 1, 255);

l_ret_code := UNAPIPPP.SAVEPPPRATTRIBUTE
             (a_pp,
              a_version,
              a_pp_key1,
              a_pp_key2,
              a_pp_key3,
              a_pp_key4,
              a_pp_key5,
              a_pr,
              a_pr_version,
              a_au_tab,
              a_au_version_tab,
              a_value_tab,
              a_nr_of_rows,
              a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);
END HandleSavePpPrAttribute;

FUNCTION HandleSaveInfoProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code               NUMBER;
a_ip                     VARCHAR2(20);
a_version                VARCHAR2(20);
a_version_is_current     CHAR(1);
a_effective_from         TIMESTAMP WITH TIME ZONE;
a_effective_till         TIMESTAMP WITH TIME ZONE;
a_description            VARCHAR2(40);
a_description2           VARCHAR2(40);
a_winsize_x              NUMBER;
a_winsize_y              NUMBER;
a_is_protected           CHAR(1);
a_hidden                 CHAR(1);
a_is_template            CHAR(1);
a_sc_lc                  VARCHAR2(2);
a_sc_lc_version          VARCHAR2(20);
a_inherit_au             CHAR(1);
a_ip_class               VARCHAR2(2);
a_log_hs                 CHAR(1);
a_lc                     VARCHAR2(2);
a_lc_version             VARCHAR2(20);
a_modify_reason          VARCHAR2(255);

CURSOR l_next_line_cursor IS
    SELECT *
    FROM utlkin
    WHERE seq > a_curr_line.seq
    ORDER BY seq;
l_curr_line           utlkin%ROWTYPE;
BEGIN
l_curr_line := a_curr_line;
a_ip := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('ip', a_ip, SUBSTR(a_curr_line.arg2, 1, 20));
a_version_is_current := SUBSTR(a_curr_line.arg3, 1, 1);
a_effective_from := TO_DATE(a_curr_line.arg4);
a_effective_till := NULL;  --strictly ignored
a_description := SUBSTR(l_curr_line.arg6, 1, 40);
a_description2 := SUBSTR(l_curr_line.arg7, 1, 40);
a_winsize_x := TO_NUMBER(l_curr_line.arg8);
a_winsize_y := TO_NUMBER(l_curr_line.arg9);
a_is_protected := SUBSTR(l_curr_line.arg10, 1, 1);
a_hidden := SUBSTR(l_curr_line.arg11, 1, 1);
a_is_template := SUBSTR(l_curr_line.arg12, 1, 1);
a_sc_lc := SUBSTR(l_curr_line.arg13, 1, 2);
a_sc_lc_version := SUBSTR(l_curr_line.arg14, 1, 20);
a_inherit_au := SUBSTR(l_curr_line.arg15, 1, 1);
a_ip_class := SUBSTR(l_curr_line.arg16, 1, 2);
a_log_hs := SUBSTR(l_curr_line.arg17, 1, 1);
a_lc := SUBSTR(l_curr_line.arg18, 1, 2);
a_lc_version := SUBSTR(l_curr_line.arg19, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg20, 1, 255);
l_ret_code := UNAPIIP.SaveInfoProfile
               (a_ip, a_version, a_version_is_current, a_effective_from, a_effective_till,
                a_description, a_description2, a_winsize_x, a_winsize_y,
                a_is_protected, a_hidden, a_is_template, a_sc_lc, a_sc_lc_version,
                a_inherit_au, a_ip_class, a_log_hs, a_lc, a_lc_version, a_modify_reason);
a_last_seq := a_curr_line.seq;
RETURN(l_ret_code);
END HandleSaveInfoProfile;

FUNCTION HandleSaveIpInfoField
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_ip               VARCHAR2(20);
a_version          VARCHAR2(20);
a_ie               UNAPIGEN.VC20_TABLE_TYPE;
a_ie_version       UNAPIGEN.VC20_TABLE_TYPE;
a_pos_x            UNAPIGEN.NUM_TABLE_TYPE;
a_pos_y            UNAPIGEN.NUM_TABLE_TYPE;
a_is_protected     UNAPIGEN.CHAR1_TABLE_TYPE;
a_mandatory        UNAPIGEN.CHAR1_TABLE_TYPE;
a_hidden           UNAPIGEN.CHAR1_TABLE_TYPE;
a_def_val_tp       UNAPIGEN.CHAR1_TABLE_TYPE;
a_def_au_level     UNAPIGEN.VC4_TABLE_TYPE;
a_ievalue          UNAPIGEN.VC2000_TABLE_TYPE;
a_nr_of_rows       NUMBER;
a_next_rows        NUMBER;
a_modify_reason    VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_ip := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('ipie', a_ip, SUBSTR(a_curr_line.arg2, 1, 20));

OPEN l_next_line_cursor;

a_nr_of_rows := TO_NUMBER(a_curr_line.arg13);

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_ie(x)           := SUBSTR(l_curr_line.arg3, 1, 20);
   a_ie_version(x)   := SUBSTR(l_curr_line.arg4, 1, 20);
   a_pos_x(x)        := TO_NUMBER(l_curr_line.arg5);
   a_pos_y(x)        := TO_NUMBER(l_curr_line.arg6);
   a_is_protected(x) := SUBSTR(l_curr_line.arg7, 1, 1);
   a_mandatory(x)    := SUBSTR(l_curr_line.arg8, 1, 1);
   a_hidden(x)       := SUBSTR(l_curr_line.arg9, 1, 1);
   a_def_val_tp(x)   := SUBSTR(l_curr_line.arg10, 1, 1);
   a_def_au_level(x) := SUBSTR(l_curr_line.arg11, 1, 4);
   a_ievalue(x)      := SUBSTR(l_curr_line.arg12, 1, 2000);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_next_rows := TO_NUMBER(a_curr_line.arg14);
a_modify_reason := SUBSTR(a_curr_line.arg15, 1, 255);

l_ret_code := UNAPIIP.SaveIpInfoField
              (a_ip, a_version, a_ie, a_ie_version, a_pos_x, a_pos_y,
               a_is_protected, a_mandatory, a_hidden, a_def_val_tp,
               a_def_au_level, a_ievalue, a_nr_of_rows, a_next_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);
END HandleSaveIpInfoField;

FUNCTION HandleSaveStInfoProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_st                      VARCHAR2(20);
a_version                 VARCHAR2(20);
a_ip                      UNAPIGEN.VC20_TABLE_TYPE;
a_ip_version              UNAPIGEN.VC20_TABLE_TYPE;
a_is_protected            UNAPIGEN.CHAR1_TABLE_TYPE;
a_hidden                  UNAPIGEN.CHAR1_TABLE_TYPE;
a_freq_tp                 UNAPIGEN.CHAR1_TABLE_TYPE;
a_freq_val                UNAPIGEN.NUM_TABLE_TYPE;
a_freq_unit               UNAPIGEN.VC20_TABLE_TYPE;
a_invert_freq             UNAPIGEN.CHAR1_TABLE_TYPE;
a_last_sched              UNAPIGEN.DATE_TABLE_TYPE;
a_last_cnt                UNAPIGEN.NUM_TABLE_TYPE;
a_last_val                UNAPIGEN.VC40_TABLE_TYPE;
a_inherit_au              UNAPIGEN.CHAR1_TABLE_TYPE;
a_nr_of_rows              NUMBER;
a_next_rows               NUMBER;
a_modify_reason           VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_st := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('stip', a_st, SUBSTR(a_curr_line.arg2, 1, 20));
a_nr_of_rows := TO_NUMBER(a_curr_line.arg15);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_ip(x)           := SUBSTR(l_curr_line.arg3, 1, 20);
   a_ip_version(x)   := SUBSTR(l_curr_line.arg4, 1, 20);
   a_is_protected(x) := SUBSTR(l_curr_line.arg5, 1, 1);
   a_hidden(x)       := SUBSTR(l_curr_line.arg6, 1, 1);
   a_freq_tp(x)      := SUBSTR(l_curr_line.arg7, 1, 1);
   a_freq_val(x)     := TO_NUMBER(l_curr_line.arg8);
   a_freq_unit(x)    := SUBSTR(l_curr_line.arg9, 1, 20);
   a_invert_freq(x)  := SUBSTR(l_curr_line.arg10, 1, 1);
   a_last_sched(x)   := TO_DATE(l_curr_line.arg11);
   a_last_cnt(x)     := TO_NUMBER(l_curr_line.arg12);
   a_last_val(x)     := SUBSTR(l_curr_line.arg13, 1, 40);
   a_inherit_au(x)   := SUBSTR(l_curr_line.arg14, 1, 1);
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_next_rows := TO_NUMBER(a_curr_line.arg16);
a_modify_reason := SUBSTR(a_curr_line.arg17, 1, 255);

l_ret_code := UNAPIST.SaveStInfoProfile
              (a_st, a_version, a_ip, a_ip_version, a_is_protected, a_hidden,
               a_freq_tp, a_freq_val, a_freq_unit, a_invert_freq, a_last_sched,
               a_last_cnt, a_last_val,a_inherit_au, a_nr_of_rows, a_next_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);
END HandleSaveStInfoProfile;

FUNCTION HandleSaveAttribute
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_au                    VARCHAR2(20);
a_version               VARCHAR2(20);
a_version_is_current    CHAR(1);
a_effective_from        TIMESTAMP WITH TIME ZONE;
a_effective_till        TIMESTAMP WITH TIME ZONE;
a_description           VARCHAR2(40);
a_description2          VARCHAR2(40);
a_is_protected          CHAR(1);
a_single_valued         CHAR(1);
a_new_val_allowed       CHAR(1);
a_store_db              CHAR(1);
a_inherit_au            CHAR(1);
a_shortcut              RAW(8);
a_value_list_tp         CHAR(1);
a_default_value         VARCHAR2(40);
a_run_mode              CHAR(1);
a_service               VARCHAR2(255);
a_cf_value              VARCHAR2(20);
a_au_class              VARCHAR2(2);
a_log_hs                CHAR(1);
a_lc                    VARCHAR2(2);
a_lc_version            VARCHAR2(20);
a_modify_reason         VARCHAR2(255);

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_au := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('au', a_au, SUBSTR(a_curr_line.arg2, 1, 20));
a_version_is_current := SUBSTR(a_curr_line.arg3, 1, 1);
a_effective_from := TO_DATE(a_curr_line.arg4);
a_effective_till := NULL;  --strictly ignored
a_description := SUBSTR(l_curr_line.arg6, 1, 40);
a_description2 := SUBSTR(l_curr_line.arg7, 1, 40);
a_is_protected := SUBSTR(l_curr_line.arg8, 1, 1);
a_single_valued := SUBSTR(l_curr_line.arg9, 1, 1);
a_new_val_allowed := SUBSTR(l_curr_line.arg10, 1, 1);
a_store_db := SUBSTR(l_curr_line.arg11, 1, 1);
a_inherit_au := SUBSTR(l_curr_line.arg12, 1, 1);
a_shortcut := null;
a_value_list_tp := SUBSTR(l_curr_line.arg14, 1, 1);
a_default_value := SUBSTR(l_curr_line.arg15, 1, 1);
a_run_mode := SUBSTR(l_curr_line.arg16, 1, 1);
a_service := SUBSTR(l_curr_line.arg17, 1, 255);
a_cf_value := SUBSTR(l_curr_line.arg18, 1, 20);
a_au_class := SUBSTR(l_curr_line.arg19, 1, 2);
a_log_hs := SUBSTR(l_curr_line.arg20, 1, 1);
a_lc := SUBSTR(l_curr_line.arg21, 1, 2);
a_lc_version := SUBSTR(l_curr_line.arg22, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg23, 1, 255);

l_ret_code := UNAPIAU.SAVEATTRIBUTE
                (a_au,
                 a_version,
                 a_version_is_current,
                 a_effective_from,
                 a_effective_till,
                 a_description,
                 a_description2,
                 a_is_protected,
                 a_single_valued,
                 a_new_val_allowed,
                 a_store_db,
                 a_inherit_au,
                 a_shortcut,
                 a_value_list_tp,
                 a_default_value,
                 a_run_mode,
                 a_service,
                 a_cf_value,
                 a_au_class,
                 a_log_hs,
                 a_lc,
                 a_lc_version,
                 a_modify_reason);

a_last_seq := a_curr_line.seq;
RETURN(l_ret_code);
END HandleSaveAttribute;

FUNCTION HandleSaveAttributeSql
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;
a_au               VARCHAR2(20);
a_version          VARCHAR2(20);
a_sqltext_tab      UNAPIGEN.VC255_TABLE_TYPE;
a_nr_of_rows       NUMBER;
a_modify_reason    VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_au := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('ausql', a_au, SUBSTR(a_curr_line.arg2, 1, 20));
a_nr_of_rows := TO_NUMBER(a_curr_line.arg4);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_sqltext_tab(x) := SUBSTR(l_curr_line.arg3, 1, 255);
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg4, 1, 255);

l_ret_code := UNAPIAU.SAVEATTRIBUTESQL
                (a_au,
                 a_version,
                 a_sqltext_tab,
                 a_nr_of_rows,
                 a_modify_reason);

CLOSE l_next_line_cursor;
RETURN(l_ret_code);
END HandleSaveAttributeSql;

FUNCTION HandleSaveAttributeValue
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_au               VARCHAR2(20);
a_version          VARCHAR2(20);
a_value_tab        UNAPIGEN.VC40_TABLE_TYPE;
a_nr_of_rows       NUMBER;
a_modify_reason    VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_au := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('aulov', a_au, SUBSTR(a_curr_line.arg2, 1, 20));
a_nr_of_rows := TO_NUMBER(a_curr_line.arg4);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_value_tab(x) := SUBSTR(l_curr_line.arg3, 1, 40);
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg4, 1, 255);

l_ret_code := UNAPIAU.SAVEATTRIBUTEVALUE
                (a_au,
                 a_version,
                 a_value_tab,
                 a_nr_of_rows,
                 a_modify_reason);

CLOSE l_next_line_cursor;
RETURN(l_ret_code);
END HandleSaveAttributeValue;

FUNCTION HandleSaveInfoField
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_ie                    VARCHAR2(20);
a_version               VARCHAR2(20);
a_version_is_current    CHAR(1);
a_effective_from        TIMESTAMP WITH TIME ZONE;
a_effective_till        TIMESTAMP WITH TIME ZONE;
a_is_protected          CHAR(1);
a_mandatory             CHAR(1);
a_hidden                CHAR(1);
a_data_tp               CHAR(1);
a_format                VARCHAR2(40);
a_valid_cf              VARCHAR2(20);
a_def_val_tp            CHAR(1);
a_def_au_level          VARCHAR2(4);
a_ievalue               VARCHAR2(2000);
a_align                 CHAR(1);
a_dsp_title             VARCHAR2(40);
a_dsp_title2            VARCHAR2(40);
a_dsp_len               NUMBER;
a_dsp_tp                CHAR(1);
a_dsp_rows              NUMBER;
a_look_up_ptr           VARCHAR2(40);
a_is_template           CHAR(1);
a_multi_select          CHAR(1);
a_sc_lc                 VARCHAR2(2);
a_sc_lc_version         VARCHAR2(20);
a_inherit_au            CHAR(1);
a_ie_class              VARCHAR2(2);
a_log_hs                CHAR(1);
a_lc                    VARCHAR2(2);
a_lc_version            VARCHAR2(20);
a_modify_reason         VARCHAR2(255);

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_ie := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('ie', a_ie, SUBSTR(a_curr_line.arg2, 1, 20));
a_version_is_current := SUBSTR(a_curr_line.arg3, 1, 1);
a_effective_from := TO_DATE(a_curr_line.arg4);
a_effective_till := NULL;  --strictly ignored
a_is_protected := SUBSTR(l_curr_line.arg6, 1, 1);
a_mandatory := SUBSTR(l_curr_line.arg7, 1, 1);
a_hidden := SUBSTR(l_curr_line.arg8, 1, 1);
a_data_tp := SUBSTR(l_curr_line.arg9, 1, 1);
a_format := SUBSTR(l_curr_line.arg10, 1, 40);
a_valid_cf := SUBSTR(l_curr_line.arg11, 1, 20);
a_def_val_tp := SUBSTR(l_curr_line.arg12, 1, 1);
a_def_au_level := SUBSTR(l_curr_line.arg13, 1, 4);
a_ievalue := SUBSTR(l_curr_line.arg14, 1, 2000);
a_align := SUBSTR(l_curr_line.arg15, 1, 1);
a_dsp_title := SUBSTR(l_curr_line.arg16, 1, 40);
a_dsp_title2 := SUBSTR(l_curr_line.arg17, 1, 40);
a_dsp_len := TO_NUMBER(l_curr_line.arg18);
a_dsp_tp := SUBSTR(l_curr_line.arg19, 1, 1);
a_dsp_rows := TO_NUMBER(l_curr_line.arg20);
a_look_up_ptr := SUBSTR(l_curr_line.arg21, 1, 40);
a_is_template := SUBSTR(l_curr_line.arg22, 1, 1);
a_multi_select := SUBSTR(l_curr_line.arg23, 1, 1);
a_sc_lc := SUBSTR(l_curr_line.arg24, 1, 2);
a_sc_lc_version := SUBSTR(l_curr_line.arg25, 1, 20);
a_inherit_au := SUBSTR(l_curr_line.arg26, 1, 1);
a_ie_class := SUBSTR(l_curr_line.arg27, 1, 2);
a_log_hs := SUBSTR(l_curr_line.arg28, 1, 1);
a_lc := SUBSTR(l_curr_line.arg29, 1, 2);
a_lc_version := SUBSTR(l_curr_line.arg30, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg31, 1, 255);

l_ret_code := UNAPIIE.SAVEINFOFIELD
                (a_ie,
                 a_version,
                 a_version_is_current,
                 a_effective_from,
                 a_effective_till,
                 a_is_protected,
                 a_mandatory,
                 a_hidden,
                 a_data_tp,
                 a_format,
                 a_valid_cf,
                 a_def_val_tp,
                 a_def_au_level,
                 a_ievalue,
                 a_align,
                 a_dsp_title,
                 a_dsp_title2,
                 a_dsp_len,
                 a_dsp_tp,
                 a_dsp_rows,
                 a_look_up_ptr,
                 a_is_template,
                 a_multi_select,
                 a_sc_lc,
                 a_sc_lc_version,
                 a_inherit_au,
                 a_ie_class,
                 a_log_hs,
                 a_lc,
                 a_lc_version,
                 a_modify_reason);

a_last_seq := a_curr_line.seq;
RETURN(l_ret_code);
END HandleSaveInfoField;

FUNCTION HandleSaveInfoFieldSql
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_ie                VARCHAR2(20);
a_version           VARCHAR2(20);
a_sqltext_tab       UNAPIGEN.VC255_TABLE_TYPE;
a_nr_of_rows        NUMBER;
a_modify_reason     VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_ie := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('iesql', a_ie, SUBSTR(a_curr_line.arg2, 1, 20));
a_nr_of_rows := TO_NUMBER(a_curr_line.arg4);

OPEN l_next_line_cursor;
FOR x IN 1..a_nr_of_rows LOOP
   a_last_seq := l_curr_line.seq;

   a_sqltext_tab(x) := SUBSTR(l_curr_line.arg3, 1, 255);
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg5, 1, 255);

l_ret_code := UNAPIIE.SAVEINFOFIELDSQL
                (a_ie,
                 a_version,
                 a_sqltext_tab,
                 a_nr_of_rows,
                 a_modify_reason);

CLOSE l_next_line_cursor;
RETURN(l_ret_code);
END HandleSaveInfoFieldSql;

FUNCTION HandleSaveInfoFieldValue
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code         NUMBER;

a_ie                VARCHAR2(20);
a_version           VARCHAR2(20);
a_value_tab         UNAPIGEN.VC40_TABLE_TYPE;
a_nr_of_rows        NUMBER;
a_modify_reason     VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_ie := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('ielov', a_ie, SUBSTR(a_curr_line.arg2, 1, 20));
a_nr_of_rows := TO_NUMBER(a_curr_line.arg4);

OPEN l_next_line_cursor;
FOR x IN 1..a_nr_of_rows LOOP
   a_last_seq := l_curr_line.seq;

   a_value_tab(x) := SUBSTR(l_curr_line.arg3, 1, 40);
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg5, 1, 255);

l_ret_code := UNAPIIE.SAVEINFOFIELDVALUE
                (a_ie,
                 a_version,
                 a_value_tab,
                 a_nr_of_rows,
                 a_modify_reason);

CLOSE l_next_line_cursor;
RETURN(l_ret_code);
END HandleSaveInfoFieldValue;

FUNCTION HandleSaveMtCell
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code                NUMBER;

a_mt                      VARCHAR2(20);
a_version                 VARCHAR2(20);
a_cell                    UNAPIGEN.VC20_TABLE_TYPE;
a_dsp_title               UNAPIGEN.VC40_TABLE_TYPE;
a_dsp_title2              UNAPIGEN.VC40_TABLE_TYPE;
a_value_f                 UNAPIGEN.FLOAT_TABLE_TYPE;
a_value_s                 UNAPIGEN.VC40_TABLE_TYPE;
a_pos_x                   UNAPIGEN.NUM_TABLE_TYPE;
a_pos_y                   UNAPIGEN.NUM_TABLE_TYPE;
a_align                   UNAPIGEN.CHAR1_TABLE_TYPE;
a_cell_tp                 UNAPIGEN.CHAR1_TABLE_TYPE;
a_winsize_x               UNAPIGEN.NUM_TABLE_TYPE;
a_winsize_y               UNAPIGEN.NUM_TABLE_TYPE;
a_is_protected            UNAPIGEN.CHAR1_TABLE_TYPE;
a_mandatory               UNAPIGEN.CHAR1_TABLE_TYPE;
a_hidden                  UNAPIGEN.CHAR1_TABLE_TYPE;
a_input_tp                UNAPIGEN.VC4_TABLE_TYPE;
a_input_source            UNAPIGEN.VC20_TABLE_TYPE;
a_input_source_version    UNAPIGEN.VC20_TABLE_TYPE;
a_input_pp                UNAPIGEN.VC20_TABLE_TYPE;
a_input_pp_version        UNAPIGEN.VC20_TABLE_TYPE;
a_input_pr                UNAPIGEN.VC20_TABLE_TYPE;
a_input_pr_version        UNAPIGEN.VC20_TABLE_TYPE;
a_input_mt                UNAPIGEN.VC20_TABLE_TYPE;
a_input_mt_version        UNAPIGEN.VC20_TABLE_TYPE;
a_def_val_tp              UNAPIGEN.CHAR1_TABLE_TYPE;
a_def_au_level            UNAPIGEN.VC4_TABLE_TYPE;
a_save_tp                 UNAPIGEN.VC4_TABLE_TYPE;
a_save_pp                 UNAPIGEN.VC20_TABLE_TYPE;
a_save_pp_version         UNAPIGEN.VC20_TABLE_TYPE;
a_save_pr                 UNAPIGEN.VC20_TABLE_TYPE;
a_save_pr_version         UNAPIGEN.VC20_TABLE_TYPE;
a_save_mt                 UNAPIGEN.VC20_TABLE_TYPE;
a_save_mt_version         UNAPIGEN.VC20_TABLE_TYPE;
a_save_eq_tp              UNAPIGEN.VC20_TABLE_TYPE;
a_save_id                 UNAPIGEN.VC20_TABLE_TYPE;
a_save_id_version         UNAPIGEN.VC20_TABLE_TYPE;
a_component               UNAPIGEN.VC20_TABLE_TYPE;
a_unit                    UNAPIGEN.VC20_TABLE_TYPE;
a_format                  UNAPIGEN.VC40_TABLE_TYPE;
a_calc_tp                 UNAPIGEN.CHAR1_TABLE_TYPE;
a_calc_formula            UNAPIGEN.VC2000_TABLE_TYPE;
a_valid_cf                UNAPIGEN.VC20_TABLE_TYPE;
a_max_x                   UNAPIGEN.NUM_TABLE_TYPE;
a_max_y                   UNAPIGEN.NUM_TABLE_TYPE;
a_multi_select            UNAPIGEN.CHAR1_TABLE_TYPE;
a_create_new              UNAPIGEN.CHAR1_TABLE_TYPE;
a_nr_of_rows              NUMBER;
a_next_rows               NUMBER;
a_modify_reason           VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_mt := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('mtce', a_mt, SUBSTR(a_curr_line.arg2, 1, 20));

a_nr_of_rows := TO_NUMBER(a_curr_line.arg48);
OPEN l_next_line_cursor;
FOR x IN 1..a_nr_of_rows LOOP
   a_last_seq := l_curr_line.seq;

   a_cell(x) := SUBSTR(l_curr_line.arg3, 1, 20);
   a_dsp_title(x) := SUBSTR(l_curr_line.arg4, 1, 40);
   a_dsp_title2(x) := SUBSTR(l_curr_line.arg5, 1, 40);
   a_value_f(x) := TO_NUMBER(l_curr_line.arg6);
   a_value_s(x) := SUBSTR(l_curr_line.arg7, 1, 40);
   a_pos_x(x) := TO_NUMBER(l_curr_line.arg8);
   a_pos_y(x) := TO_NUMBER(l_curr_line.arg9);
   a_align(x) := SUBSTR(l_curr_line.arg10, 1, 1);
   a_cell_tp(x) := SUBSTR(l_curr_line.arg11, 1, 1);
   a_winsize_x(x) := TO_NUMBER(l_curr_line.arg12);
   a_winsize_y(x) := TO_NUMBER(l_curr_line.arg13);
   a_is_protected(x) := SUBSTR(l_curr_line.arg14,1, 1);
   a_mandatory(x) := SUBSTR(l_curr_line.arg15,1, 1);
   a_hidden(x) := SUBSTR(l_curr_line.arg16,1, 1);
   a_input_tp(x) := SUBSTR(l_curr_line.arg17, 1, 4);
   a_input_source(x) := SUBSTR(l_curr_line.arg18, 1, 20);
   a_input_source_version(x) := SUBSTR(l_curr_line.arg19, 1, 20);
   a_input_pp(x) := SUBSTR(l_curr_line.arg20, 1, 20);
   a_input_pp_version(x) := SUBSTR(l_curr_line.arg21, 1, 20);
   a_input_pr(x) := SUBSTR(l_curr_line.arg22, 1, 20);
   a_input_pr_version(x) := SUBSTR(l_curr_line.arg23, 1, 20);
   a_input_mt(x) := SUBSTR(l_curr_line.arg24, 1, 20);
   a_input_mt_version(x) := SUBSTR(l_curr_line.arg25, 1, 20);
   a_def_val_tp(x) := SUBSTR(l_curr_line.arg26,1, 1);
   a_def_au_level(x) := SUBSTR(l_curr_line.arg27, 1, 4);
   a_save_tp(x) := SUBSTR(l_curr_line.arg28, 1, 4);
   a_save_pp(x) := SUBSTR(l_curr_line.arg29, 1, 20);
   a_save_pp_version(x) := SUBSTR(l_curr_line.arg30, 1, 20);
   a_save_pr(x) := SUBSTR(l_curr_line.arg31, 1, 20);
   a_save_pr_version(x) := SUBSTR(l_curr_line.arg32, 1, 20);
   a_save_mt(x) := SUBSTR(l_curr_line.arg33, 1, 20);
   a_save_mt_version(x) := SUBSTR(l_curr_line.arg34, 1, 20);
   a_save_eq_tp(x) := SUBSTR(l_curr_line.arg35, 1, 20);
   a_save_id(x) := SUBSTR(l_curr_line.arg36, 1, 20);
   a_save_id_version(x) := SUBSTR(l_curr_line.arg37, 1, 20);
   a_component(x) := SUBSTR(l_curr_line.arg38, 1, 20);
   a_unit(x) := SUBSTR(l_curr_line.arg39, 1, 20);
   a_format(x) := SUBSTR(l_curr_line.arg40, 1, 40);
   a_calc_tp(x) := SUBSTR(l_curr_line.arg41, 1, 1);
   a_calc_formula(x) := SUBSTR(l_curr_line.arg42,1,2000);
   a_valid_cf(x) := SUBSTR(l_curr_line.arg43, 1, 20);
   a_max_x(x) := TO_NUMBER(l_curr_line.arg44);
   a_max_y(x) := TO_NUMBER(l_curr_line.arg45);
   a_multi_select(x) := SUBSTR(l_curr_line.arg46, 1, 1);
   a_create_new(x) := SUBSTR(l_curr_line.arg47, 1, 1);
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_next_rows := TO_NUMBER(a_curr_line.arg49);
a_modify_reason := SUBSTR(a_curr_line.arg50, 1, 255);

l_ret_code := UNAPIMT.SAVEMTCELL
                (a_mt,
                 a_version,
                 a_cell,
                 a_dsp_title,
                 a_dsp_title2,
                 a_value_f,
                 a_value_s,
                 a_pos_x,
                 a_pos_y,
                 a_align,
                 a_cell_tp,
                 a_winsize_x,
                 a_winsize_y,
                 a_is_protected,
                 a_mandatory,
                 a_hidden,
                 a_input_tp,
                 a_input_source,
                 a_input_source_version,
                 a_input_pp,
                 a_input_pp_version,
                 a_input_pr,
                 a_input_pr_version,
                 a_input_mt,
                 a_input_mt_version,
                 a_def_val_tp,
                 a_def_au_level,
                 a_save_tp,
                 a_save_pp,
                 a_save_pp_version,
                 a_save_pr,
                 a_save_pr_version,
                 a_save_mt,
                 a_save_mt_version,
                 a_save_eq_tp,
                 a_save_id,
                 a_save_id_version,
                 a_component,
                 a_unit,
                 a_format,
                 a_calc_tp,
                 a_calc_formula,
                 a_valid_cf,
                 a_max_x,
                 a_max_y,
                 a_multi_select,
                 a_create_new,
                 a_nr_of_rows,
                 a_next_rows,
                 a_modify_reason);

CLOSE l_next_line_cursor;
RETURN(l_ret_code);
END HandleSaveMtCell;

FUNCTION HandleSaveRequestType
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER  IS

l_ret_code                    NUMBER;
a_rt                          VARCHAR2(20);
a_version                     VARCHAR2(20);
a_version_is_current          CHAR(1);
a_effective_from              TIMESTAMP WITH TIME ZONE;
a_effective_till              TIMESTAMP WITH TIME ZONE;
a_description                 VARCHAR2(40);
a_description2                VARCHAR2(40);
a_descr_doc                   VARCHAR2(40);
a_descr_doc_version           VARCHAR2(20);
a_is_template                 CHAR(1);
a_confirm_userid              CHAR(1);
a_nr_planned_rq               NUMBER;
a_freq_tp                     CHAR(1);
a_freq_val                    NUMBER;
a_freq_unit                   VARCHAR2(20);
a_invert_freq                 CHAR(1);
a_last_sched                  TIMESTAMP WITH TIME ZONE;
a_last_cnt                    NUMBER;
a_last_val                    VARCHAR2(40);
a_priority                    NUMBER;
a_label_format                VARCHAR2(20);
a_allow_any_st                CHAR(1);
a_allow_new_sc                CHAR(1);
a_add_stpp                    CHAR(1);
a_planned_responsible         VARCHAR2(20);
a_sc_uc                       VARCHAR2(20);
a_sc_uc_version               VARCHAR2(20);
a_rq_uc                       VARCHAR2(20);
a_rq_uc_version               VARCHAR2(20);
a_rq_lc                       VARCHAR2(2);
a_rq_lc_version               VARCHAR2(20);
a_inherit_au                  CHAR(1);
a_inherit_gk                  CHAR(1);
a_rt_class                    VARCHAR2(2);
a_log_hs                      CHAR(1);
a_lc                          VARCHAR2(2);
a_lc_version                  VARCHAR2(20);
a_modify_reason               VARCHAR2(255);

BEGIN

a_last_seq := a_curr_line.seq;

a_rt := SUBSTR(a_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('rt', a_rt, SUBSTR(a_curr_line.arg2, 1, 20));
a_version_is_current := SUBSTR(a_curr_line.arg3, 1, 1);
a_effective_from := TO_DATE(a_curr_line.arg4);
a_effective_till := NULL;  --strictly ignored
a_description := SUBSTR(a_curr_line.arg6, 1, 40);
a_description2 := SUBSTR(a_curr_line.arg7, 1, 40);
a_descr_doc := SUBSTR(a_curr_line.arg8, 1, 40);
a_descr_doc_version := SUBSTR(a_curr_line.arg9, 1, 20);
a_is_template := SUBSTR(a_curr_line.arg10, 1, 1);
a_confirm_userid := SUBSTR(a_curr_line.arg11, 1, 1);
a_nr_planned_rq := TO_NUMBER(a_curr_line.arg12);
a_freq_tp := SUBSTR(a_curr_line.arg13, 1, 1);
a_freq_val := TO_NUMBER(a_curr_line.arg14);
a_freq_unit := SUBSTR(a_curr_line.arg15, 1, 20);
a_invert_freq := SUBSTR(a_curr_line.arg16, 1, 1);
a_last_sched := TO_DATE(a_curr_line.arg17);
a_last_cnt := TO_NUMBER(a_curr_line.arg18);
a_last_val := SUBSTR(a_curr_line.arg19, 1, 40);
a_priority := TO_NUMBER(a_curr_line.arg20);
a_label_format := SUBSTR(a_curr_line.arg21, 1, 20);
a_allow_any_st := SUBSTR(a_curr_line.arg22, 1, 1);
a_allow_new_sc := SUBSTR(a_curr_line.arg23, 1, 1);
a_add_stpp := SUBSTR(a_curr_line.arg24, 1, 1);
a_planned_responsible := SUBSTR(a_curr_line.arg25, 1, 20);
a_sc_uc := SUBSTR(a_curr_line.arg26, 1, 20);
a_sc_uc_version := SUBSTR(a_curr_line.arg27, 1, 20);
a_rq_uc := SUBSTR(a_curr_line.arg28, 1, 20);
a_rq_uc_version := SUBSTR(a_curr_line.arg29, 1, 20);
a_rq_lc := SUBSTR(a_curr_line.arg30, 1, 2);
a_rq_lc_version := SUBSTR(a_curr_line.arg31, 1, 20);
a_inherit_au := SUBSTR(a_curr_line.arg32, 1, 1);
a_inherit_gk := SUBSTR(a_curr_line.arg33, 1, 1);
a_rt_class := SUBSTR(a_curr_line.arg34, 1, 2);
a_log_hs := SUBSTR(a_curr_line.arg35, 1, 1);
a_lc := SUBSTR(a_curr_line.arg36, 1, 2);
a_lc_version := SUBSTR(a_curr_line.arg37, 1, 20);
a_modify_reason := SUBSTR(a_curr_line.arg38, 1, 255);

l_ret_code := UNAPIRT.SAVEREQUESTTYPE
                (a_rt, a_version, a_version_is_current, a_effective_from, a_effective_till,
                 a_description, a_description2, a_descr_doc, a_descr_doc_version,
                 a_is_template, a_confirm_userid, a_nr_planned_rq,
                 a_freq_tp, a_freq_val, a_freq_unit,
                 a_invert_freq, a_last_sched, a_last_cnt, a_last_val,
                 a_priority, a_label_format, a_allow_any_st, a_allow_new_sc,
                 a_add_stpp, a_planned_responsible,
                 a_sc_uc, a_sc_uc_version, a_rq_uc, a_rq_uc_version, a_rq_lc, a_rq_lc_version,
                 a_inherit_au, a_inherit_gk, a_rt_class, a_log_hs, a_lc, a_lc_version,
                 a_modify_reason);

RETURN(l_ret_code);

END HandleSaveRequestType;

FUNCTION HandleSaveRtSampleType
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER IS

l_ret_code                    NUMBER;
a_rt                          VARCHAR2(20);
a_version                     VARCHAR2(20);
a_st_tab                      UNAPIGEN.VC20_TABLE_TYPE;
a_st_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
a_nr_planned_sc_tab           UNAPIGEN.NUM_TABLE_TYPE;
a_delay_tab                   UNAPIGEN.NUM_TABLE_TYPE;
a_delay_unit_tab              UNAPIGEN.VC20_TABLE_TYPE;
a_freq_tp_tab                 UNAPIGEN.CHAR1_TABLE_TYPE;
a_freq_val_tab                UNAPIGEN.NUM_TABLE_TYPE;
a_freq_unit_tab               UNAPIGEN.VC20_TABLE_TYPE;
a_invert_freq_tab             UNAPIGEN.CHAR1_TABLE_TYPE;
a_last_sched_tab              UNAPIGEN.DATE_TABLE_TYPE;
a_last_cnt_tab                UNAPIGEN.NUM_TABLE_TYPE;
a_last_val_tab                UNAPIGEN.VC40_TABLE_TYPE;
a_inherit_au_tab              UNAPIGEN.CHAR1_TABLE_TYPE;
a_nr_of_rows                  NUMBER;
a_modify_reason               VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_rt := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('rtst', a_rt, SUBSTR(a_curr_line.arg2, 1, 20));
a_nr_of_rows := TO_NUMBER(a_curr_line.arg16);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_st_tab(x) := SUBSTR(l_curr_line.arg3, 1, 20);
   a_st_version_tab(x) := SUBSTR(l_curr_line.arg4, 1, 20);
   a_nr_planned_sc_tab(x) := TO_NUMBER(l_curr_line.arg5);
   a_delay_tab(x) := TO_NUMBER(l_curr_line.arg6);
   a_delay_unit_tab(x) := SUBSTR(l_curr_line.arg7, 1, 20);
   a_freq_tp_tab(x) := SUBSTR(l_curr_line.arg8, 1, 1);
   a_freq_val_tab(x) := TO_NUMBER(l_curr_line.arg9);
   a_freq_unit_tab(x) := SUBSTR(l_curr_line.arg10, 1, 20);
   a_invert_freq_tab(x) := SUBSTR(l_curr_line.arg11, 1, 1);
   a_last_sched_tab(x) := TO_DATE(l_curr_line.arg12);
   a_last_cnt_tab(x) := TO_NUMBER(l_curr_line.arg13);
   a_last_val_tab(x) := SUBSTR(l_curr_line.arg14, 1, 40);
   a_inherit_au_tab(x) := SUBSTR(l_curr_line.arg15, 1, 1);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg17, 1, 255);

l_ret_code := UNAPIRT.SaveRtSampleType
                (a_rt, a_version, a_st_tab, a_st_version_tab, a_nr_planned_sc_tab, a_delay_tab, a_delay_unit_tab, a_freq_tp_tab,
                 a_freq_val_tab, a_freq_unit_tab, a_invert_freq_tab, a_last_sched_tab, a_last_cnt_tab,
                 a_last_val_tab, a_inherit_au_tab, a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveRtSampleType;

FUNCTION HandleSaveRtParameterProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER  IS

l_ret_code                    NUMBER;
a_rt                          VARCHAR2(20);
a_version                     VARCHAR2(20);
a_pp_tab                      UNAPIGEN.VC20_TABLE_TYPE;
a_pp_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key1                     UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key2                     UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key3                     UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key4                     UNAPIGEN.VC20_TABLE_TYPE;
a_pp_key5                     UNAPIGEN.VC20_TABLE_TYPE;
a_delay_tab                   UNAPIGEN.NUM_TABLE_TYPE;
a_delay_unit_tab              UNAPIGEN.VC20_TABLE_TYPE;
a_freq_tp_tab                 UNAPIGEN.CHAR1_TABLE_TYPE;
a_freq_val_tab                UNAPIGEN.NUM_TABLE_TYPE;
a_freq_unit_tab               UNAPIGEN.VC20_TABLE_TYPE;
a_invert_freq_tab             UNAPIGEN.CHAR1_TABLE_TYPE;
a_last_sched_tab              UNAPIGEN.DATE_TABLE_TYPE;
a_last_cnt_tab                UNAPIGEN.NUM_TABLE_TYPE;
a_last_val_tab                UNAPIGEN.VC40_TABLE_TYPE;
a_inherit_au_tab              UNAPIGEN.CHAR1_TABLE_TYPE;
a_nr_of_rows                  NUMBER;
a_modify_reason               VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_rt := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('rtpp', a_rt, SUBSTR(a_curr_line.arg2, 1, 20));
a_nr_of_rows := TO_NUMBER(a_curr_line.arg20);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_pp_tab(x) := SUBSTR(l_curr_line.arg3, 1, 20);
   a_pp_version_tab(x) := SUBSTR(l_curr_line.arg4, 1, 20);
   a_pp_key1(x) := SUBSTR(l_curr_line.arg5, 1, 20);
   a_pp_key2(x) := SUBSTR(l_curr_line.arg6, 1, 20);
   a_pp_key3(x) := SUBSTR(l_curr_line.arg7, 1, 20);
   a_pp_key4(x) := SUBSTR(l_curr_line.arg8, 1, 20);
   a_pp_key5(x) := SUBSTR(l_curr_line.arg9, 1, 20);
   a_delay_tab(x) := TO_NUMBER(l_curr_line.arg10);
   a_delay_unit_tab(x) := SUBSTR(l_curr_line.arg11, 1, 20);
   a_freq_tp_tab(x) := SUBSTR(l_curr_line.arg12, 1, 1);
   a_freq_val_tab(x) := TO_NUMBER(l_curr_line.arg13);
   a_freq_unit_tab(x) := SUBSTR(l_curr_line.arg14, 1, 20);
   a_invert_freq_tab(x) := SUBSTR(l_curr_line.arg15, 1, 1);
   a_last_sched_tab(x) := TO_DATE(l_curr_line.arg16);
   a_last_cnt_tab(x) := TO_NUMBER(l_curr_line.arg17);
   a_last_val_tab(x) := SUBSTR(l_curr_line.arg18, 1, 40);
   a_inherit_au_tab(x) := SUBSTR(l_curr_line.arg19, 1, 1);

   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg21, 1, 255);

l_ret_code := UNAPIRT.SaveRtParameterProfile
                (a_rt, a_version, a_pp_tab, a_pp_version_tab,
                 a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5,
                 a_delay_tab, a_delay_unit_tab, a_freq_tp_tab,
                 a_freq_val_tab, a_freq_unit_tab, a_invert_freq_tab, a_last_sched_tab, a_last_cnt_tab,
                 a_last_val_tab, a_inherit_au_tab, a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveRtParameterProfile;

FUNCTION HandleSaveRtInfoProfile
(a_curr_line     IN    utlkin%ROWTYPE,
 a_last_seq      OUT   utlkin.seq%TYPE)
RETURN NUMBER  IS

l_ret_code         NUMBER;

a_rt                          VARCHAR2(20);
a_version                     VARCHAR2(20);
a_ip_tab                      UNAPIGEN.VC20_TABLE_TYPE;
a_ip_version_tab              UNAPIGEN.VC20_TABLE_TYPE;
a_is_protected_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
a_hidden_tab                  UNAPIGEN.CHAR1_TABLE_TYPE;
a_freq_tp_tab                 UNAPIGEN.CHAR1_TABLE_TYPE;
a_freq_val_tab                UNAPIGEN.NUM_TABLE_TYPE;
a_freq_unit_tab               UNAPIGEN.VC20_TABLE_TYPE;
a_invert_freq_tab             UNAPIGEN.CHAR1_TABLE_TYPE;
a_last_sched_tab              UNAPIGEN.DATE_TABLE_TYPE;
a_last_cnt_tab                UNAPIGEN.NUM_TABLE_TYPE;
a_last_val_tab                UNAPIGEN.VC40_TABLE_TYPE;
a_inherit_au_tab              UNAPIGEN.CHAR1_TABLE_TYPE;
a_nr_of_rows                  NUMBER;
a_modify_reason               VARCHAR2(255);

CURSOR l_next_line_cursor IS
   SELECT *
   FROM utlkin
   WHERE seq > a_curr_line.seq
   ORDER BY seq;

l_curr_line           utlkin%ROWTYPE;

BEGIN

l_curr_line := a_curr_line;

a_rt := SUBSTR(l_curr_line.arg1, 1, 20);
a_version := HandleObjectVersion('rtip', a_rt, SUBSTR(a_curr_line.arg2, 1, 20));
a_nr_of_rows := TO_NUMBER(a_curr_line.arg15);

OPEN l_next_line_cursor;

FOR x IN 1..a_nr_of_rows LOOP

   a_last_seq := l_curr_line.seq;

   a_ip_tab(x)           := SUBSTR(l_curr_line.arg3, 1, 20);
   a_ip_version_tab(x)   := SUBSTR(l_curr_line.arg4, 1, 20);
   a_is_protected_tab(x) := SUBSTR(l_curr_line.arg5, 1, 1);
   a_hidden_tab(x)       := SUBSTR(l_curr_line.arg6, 1, 1);
   a_freq_tp_tab(x)      := SUBSTR(l_curr_line.arg7, 1, 1);
   a_freq_val_tab(x)     := TO_NUMBER(l_curr_line.arg8);
   a_freq_unit_tab(x)    := SUBSTR(l_curr_line.arg9, 1, 20);
   a_invert_freq_tab(x)  := SUBSTR(l_curr_line.arg10, 1, 1);
   a_last_sched_tab(x)   := TO_DATE(l_curr_line.arg11);
   a_last_cnt_tab(x)     := TO_NUMBER(l_curr_line.arg12);
   a_last_val_tab(x)     := SUBSTR(l_curr_line.arg13, 1, 40);
   a_inherit_au_tab(x)   := SUBSTR(l_curr_line.arg14, 1, 1);
   IF x < a_nr_of_rows THEN
      FETCH l_next_line_cursor
      INTO l_curr_line;
   END IF;
END LOOP;

a_modify_reason := SUBSTR(a_curr_line.arg16, 1, 255);

l_ret_code := UNAPIRT.SaveRtInfoProfile
                (a_rt, a_version, a_ip_tab, a_ip_version_tab, a_is_protected_tab, a_hidden_tab, a_freq_tp_tab, a_freq_val_tab, a_freq_unit_tab,
                 a_invert_freq_tab, a_last_sched_tab, a_last_cnt_tab, a_last_val_tab, a_inherit_au_tab,
                 a_nr_of_rows, a_modify_reason);

CLOSE l_next_line_cursor;

RETURN(l_ret_code);

END HandleSaveRtInfoProfile;



END ulco;