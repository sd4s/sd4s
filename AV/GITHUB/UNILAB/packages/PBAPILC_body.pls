create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
pbapilc AS

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

FUNCTION GetStatusList
(a_ss                  OUT    UNAPIGEN.VC2_TABLE_TYPE,  /* VC2_TABLE_TYPE */
 a_name                OUT    UNAPIGEN.VC20_TABLE_TYPE, /* VC20_TABLE_TYPE */
 a_description         OUT    UNAPIGEN.VC40_TABLE_TYPE, /* VC40_TABLE_TYPE */
 a_r                   OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_g                   OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_b                   OUT    UNAPIGEN.NUM_TABLE_TYPE,  /* NUM_TABLE_TYPE */
 a_nr_of_rows          IN OUT NUMBER,                   /* NUM_TYPE */
 a_where_clause        IN     VARCHAR2,                 /* VC511_TYPE */
 a_next_rows           IN     NUMBER)                   /* NUM_TYPE */
RETURN NUMBER IS

BEGIN
l_ret_code := UNAPILC.GetStatusList
                 (a_ss,
                  a_name,
                  a_description,
                  a_r,
                  a_g,
                  a_b,
                  a_nr_of_rows,
                  a_where_clause,
                  a_next_rows);
RETURN (l_ret_code);
END GetStatusList;

FUNCTION GetStatus
(a_ss            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_name          OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description   OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_r             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_g             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_b             OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_alt           OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ctrl          OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_shift         OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_key_name      OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_allow_modify  OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active        OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ss_class      OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows    IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause  IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER IS
l_row                 NUMBER;
l_alt                 UNAPIGEN.CHAR1_TABLE_TYPE;
l_ctrl                UNAPIGEN.CHAR1_TABLE_TYPE;
l_shift               UNAPIGEN.CHAR1_TABLE_TYPE;
l_allow_modify        UNAPIGEN.CHAR1_TABLE_TYPE;
l_active              UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
l_ret_code := UNAPILC.GetStatus
                 (a_ss,
                  a_name,
                  a_description,
                  a_r,
                  a_g,
                  a_b,
                  l_alt,
                  l_ctrl,
                  l_shift,
                  a_key_name,
                  l_allow_modify,
                  l_active,
                  a_ss_class,
                  a_nr_of_rows,
                  a_where_clause);
IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
   FOR l_row IN 1..a_nr_of_rows LOOP
      a_alt(l_row)          := l_alt(l_row);
      a_ctrl(l_row)         := l_ctrl(l_row);
      a_shift(l_row)        := l_shift(l_row);
      a_allow_modify(l_row) := l_allow_modify(l_row);
      a_active(l_row)       := l_active(l_row);
   END LOOP;
END IF;
RETURN (l_ret_code);
END GetStatus;


FUNCTION SaveStatus
(a_ss            IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_name          IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description   IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_r             IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_g             IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_b             IN     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_alt           IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ctrl          IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_shift         IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_key_name      IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_allow_modify  IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_active        IN     PBAPIGEN.VC1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_ss_class      IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows    IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER IS
l_row                 NUMBER;
l_alt                 UNAPIGEN.CHAR1_TABLE_TYPE;
l_ctrl                UNAPIGEN.CHAR1_TABLE_TYPE;
l_shift               UNAPIGEN.CHAR1_TABLE_TYPE;
l_allow_modify        UNAPIGEN.CHAR1_TABLE_TYPE;
l_active              UNAPIGEN.CHAR1_TABLE_TYPE;
BEGIN
FOR l_row IN 1..a_nr_of_rows LOOP
   l_alt(l_row)          := a_alt(l_row);
   l_ctrl(l_row)         := a_ctrl(l_row);
   l_shift(l_row)        := a_shift(l_row);
   l_allow_modify(l_row) := a_allow_modify(l_row);
   l_active(l_row)       := a_active(l_row);
END LOOP;
l_ret_code := UNAPILC.SaveStatus
                 (a_ss,
                  a_name,
                  a_description,
                  a_r,
                  a_g,
                  a_b,
                  l_alt,
                  l_ctrl,
                  l_shift,
                  a_key_name,
                  l_allow_modify,
                  l_active,
                  a_ss_class,
                  a_nr_of_rows);
RETURN (l_ret_code);
END SaveStatus;

FUNCTION GetLifeCycle
(a_lc                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_name                OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_intended_use        OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_is_template         OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_inherit_au          OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_ss_after_reanalysis OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_class            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs              OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_allow_modify        OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_active              OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_lc_lc               OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_ss                  OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER IS

l_row                 NUMBER;
l_is_template         UNAPIGEN.CHAR1_TABLE_TYPE;
l_inherit_au          UNAPIGEN.CHAR1_TABLE_TYPE;
l_log_hs              UNAPIGEN.CHAR1_TABLE_TYPE;
l_allow_modify        UNAPIGEN.CHAR1_TABLE_TYPE;
l_active              UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN

   l_ret_code := UNAPILC.GetLifeCycle
      (a_lc,
       a_name,
       a_description,
       a_intended_use,
       l_is_template,
       l_inherit_au,
       a_ss_after_reanalysis,
       a_lc_class,
       l_log_hs,
       l_allow_modify,
       l_active,
       a_lc_lc,
       a_ss,
       a_nr_of_rows,
       a_where_clause);

    IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
       FOR l_row IN 1..a_nr_of_rows LOOP
          a_is_template(l_row) := l_is_template(l_row);
          a_inherit_au(l_row) := l_inherit_au(l_row);
          a_log_hs(l_row) := l_log_hs(l_row);
          a_allow_modify(l_row) := l_allow_modify(l_row);
          a_active(l_row) := l_active(l_row);
       END LOOP;
    END IF;

    RETURN (l_ret_code);

END GetLifeCycle;

FUNCTION GetWlRules
(a_ss            OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_entry_action  OUT     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_gk_entry      OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_entry_tp      OUT     PBAPIGEN.VC2_TABLE_TYPE, /* CHAR2_TABLE_TYPE */
 a_use_value     OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows    IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause  IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER IS
l_row           NUMBER;
l_entry_action  UNAPIGEN.CHAR1_TABLE_TYPE;
l_entry_tp      UNAPIGEN.CHAR2_TABLE_TYPE;
BEGIN
   l_ret_code := UNAPILC.GetWlRules
      (a_ss,
       l_entry_action,
       a_gk_entry,
       l_entry_tp,
       a_use_value,
       a_nr_of_rows,
       a_where_clause);
    IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
       FOR l_row IN 1..a_nr_of_rows LOOP
          a_entry_action(l_row) := l_entry_action(l_row);
          a_entry_tp(l_row) := l_entry_tp(l_row);
       END LOOP;
    END IF;
    RETURN (l_ret_code);
END GetWlRules;

FUNCTION SaveWlRules
(a_ss            IN     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_entry_action  IN     PBAPIGEN.VC1_TABLE_TYPE, /* CHAR1_TABLE_TYPE */
 a_gk_entry      IN     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_entry_tp      IN     PBAPIGEN.VC2_TABLE_TYPE, /* CHAR2_TABLE_TYPE */
 a_use_value     IN     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows    IN     NUMBER)                    /* NUM_TYPE */
RETURN NUMBER IS
l_row           NUMBER;
l_entry_action  UNAPIGEN.CHAR1_TABLE_TYPE;
l_entry_tp      UNAPIGEN.CHAR2_TABLE_TYPE;
BEGIN
   FOR l_row IN 1..a_nr_of_rows LOOP
      l_entry_action(l_row) := a_entry_action(l_row);
      l_entry_tp(l_row) := a_entry_tp(l_row);
   END LOOP;
   l_ret_code := UNAPILC.SaveWlRules
   (a_ss,
    l_entry_action,
    a_gk_entry,
    l_entry_tp,
    a_use_value,
    a_nr_of_rows);
   RETURN (l_ret_code);
END SaveWlRules;

FUNCTION GetDefaultLifeCycles
(a_object_tp           OUT     UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_def_lc              OUT     UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_lc_name             OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_log_hs              OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* VC1_TABLE_TYPE */
 a_log_hs_details      OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* VC1_TABLE_TYPE */
 a_ar                  OUT     PBAPIGEN.VC1_TABLE_TYPE,   /* VC1_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER)                    /* NUM_TYPE */
RETURN NUMBER IS

l_row           NUMBER;
l_log_hs        UNAPIGEN.CHAR1_TABLE_TYPE;
l_log_hs_details UNAPIGEN.CHAR1_TABLE_TYPE;
l_ar            UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN
   l_ret_code := UNAPILC.GetDefaultLifeCycles
      (a_object_tp,
       a_description,
       a_def_lc,
       a_lc_name,
       l_log_hs,
       l_log_hs_details,
       l_ar,
       a_nr_of_rows);
    IF l_ret_code = UNAPIGEN.DBERR_SUCCESS THEN
       FOR l_row IN 1..a_nr_of_rows LOOP
          a_log_hs(l_row) := l_log_hs(l_row);
          a_log_hs_details(l_row) := l_log_hs_details(l_row);
          a_ar(l_row) := l_ar(l_row);
       END LOOP;
    END IF;
    RETURN (l_ret_code);
END GetDefaultLifeCycles;

FUNCTION SaveDefaultLifeCycles
(a_object_tp           IN      UNAPIGEN.VC4_TABLE_TYPE,   /* VC4_TABLE_TYPE */
 a_description         IN      UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_def_lc              IN      UNAPIGEN.VC2_TABLE_TYPE,   /* VC2_TABLE_TYPE */
 a_log_hs              IN      PBAPIGEN.VC1_TABLE_TYPE,   /* VC1_TABLE_TYPE */
 a_log_hs_details      IN      PBAPIGEN.VC1_TABLE_TYPE,   /* VC1_TABLE_TYPE */
 a_ar                  IN      PBAPIGEN.VC1_TABLE_TYPE,   /* VC1_TABLE_TYPE */
 a_nr_of_rows          IN      NUMBER,                    /* NUM_TYPE */
 a_modify_reason       IN      VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER IS

l_row           NUMBER;
l_log_hs        UNAPIGEN.CHAR1_TABLE_TYPE;
l_log_hs_details        UNAPIGEN.CHAR1_TABLE_TYPE;
l_ar            UNAPIGEN.CHAR1_TABLE_TYPE;

BEGIN

   FOR l_row IN 1..a_nr_of_rows LOOP
      l_log_hs(l_row) := a_log_hs(l_row);
      l_log_hs_details(l_row) := a_log_hs_details(l_row);
      l_ar(l_row) := a_ar(l_row);
   END LOOP;

   l_ret_code := UNAPILC.SaveDefaultLifeCycles
      (a_object_tp,
       a_description,
       a_def_lc,
       l_log_hs,
       l_log_hs_details,
       l_ar,
       a_nr_of_rows,
       a_modify_reason);
   RETURN (l_ret_code);

END SaveDefaultLifeCycles;

END pbapilc;