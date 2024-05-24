create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapigk AS

CURSOR l_dba_objects_cursor (a_table_name VARCHAR2) IS
SELECT DECODE(COUNT(*),0,'0','1') struct_created
FROM dba_objects
WHERE object_type='TABLE'
AND owner = (SELECT setting_value FROM utsystem
             WHERE setting_name = 'DBA_NAME')
AND object_name = UPPER(a_table_name);

CURSOR l_table_store_cursor (a_table VARCHAR2) IS
   SELECT GREATEST(FLOOR(a.initial_extent/1024),1) initial_extent,
          GREATEST(FLOOR(a.next_extent   /1024),1) next_extent,
          a.pct_increase, a.pct_free, a.pct_used
   FROM user_tables a
   WHERE a.table_name = a_table;

CURSOR l_index_store_cursor (a_index VARCHAR2) IS
   SELECT GREATEST(FLOOR(a.initial_extent/1024),1) initial_extent,
          GREATEST(FLOOR(a.next_extent   /1024),1) next_extent,
          a.pct_increase, a.pct_free
   FROM user_indexes a
   WHERE a.index_name = a_index;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetGroupKeyStList
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeySt
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    UNAPIGEN.CHAR2_TABLE_TYPE,   /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyStValue
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyStSql
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeySt
(a_gk               IN   VARCHAR2,                    /* VC20_TYPE */
 a_description      IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected     IN   CHAR,                        /* CHAR1_TYPE */
 a_value_unique     IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued    IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed  IN   CHAR,                        /* CHAR1_TYPE */
 a_mandatory        IN   CHAR,                        /* CHAR1_TYPE */
 a_struct_created   IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_gk       IN   CHAR,                        /* CHAR1_TYPE */
 a_value_list_tp    IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value    IN   VARCHAR2,                    /* VC40_TYPE */
 a_dsp_rows         IN   NUMBER,                      /* NUM_TYPE */
 a_val_length       IN   NUMBER,                      /* NUM_TYPE */
 a_val_start        IN   NUMBER,                      /* NUM_TYPE */
 a_assign_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_assign_id        IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_tp             IN   CHAR,                        /* CHAR2_TYPE */
 a_q_id             IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_check_au       IN   CHAR,                        /* CHAR1_TYPE */
 a_q_au             IN   VARCHAR2,                    /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeySt
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyStStructures
(a_gk                IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                 /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyStStructures
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyStEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyStEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyScList
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeySc
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    UNAPIGEN.CHAR2_TABLE_TYPE,   /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyScValue
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyScSql
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeySc
(a_gk               IN   VARCHAR2,                    /* VC20_TYPE */
 a_description      IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected     IN   CHAR,                        /* CHAR1_TYPE */
 a_value_unique     IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued    IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed  IN   CHAR,                        /* CHAR1_TYPE */
 a_mandatory        IN   CHAR,                        /* CHAR1_TYPE */
 a_struct_created   IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_gk       IN   CHAR,                        /* CHAR1_TYPE */
 a_value_list_tp    IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value    IN   VARCHAR2,                    /* VC40_TYPE */
 a_dsp_rows         IN   NUMBER,                      /* NUM_TYPE */
 a_val_length       IN   NUMBER,                      /* NUM_TYPE */
 a_val_start        IN   NUMBER,                      /* NUM_TYPE */
 a_assign_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_assign_id        IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_tp             IN   CHAR,                        /* CHAR2_TYPE */
 a_q_id             IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_check_au       IN   CHAR,                        /* CHAR1_TYPE */
 a_q_au             IN   VARCHAR2,                    /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeySc
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyScStructures
(a_gk                IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                 /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyScStructures
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyScEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyScEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyMeList
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyMe
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    UNAPIGEN.CHAR2_TABLE_TYPE,   /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyMeValue
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyMeSql
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeyMe
(a_gk               IN   VARCHAR2,                    /* VC20_TYPE */
 a_description      IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected     IN   CHAR,                        /* CHAR1_TYPE */
 a_value_unique     IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued    IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed  IN   CHAR,                        /* CHAR1_TYPE */
 a_mandatory        IN   CHAR,                        /* CHAR1_TYPE */
 a_struct_created   IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_gk       IN   CHAR,                        /* CHAR1_TYPE */
 a_value_list_tp    IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value    IN   VARCHAR2,                    /* VC40_TYPE */
 a_dsp_rows         IN   NUMBER,                      /* NUM_TYPE */
 a_val_length       IN   NUMBER,                      /* NUM_TYPE */
 a_val_start        IN   NUMBER,                      /* NUM_TYPE */
 a_assign_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_assign_id        IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_tp             IN   CHAR,                        /* CHAR2_TYPE */
 a_q_id             IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_check_au       IN   CHAR,                        /* CHAR1_TYPE */
 a_q_au             IN   VARCHAR2,                    /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyMe
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyMeStructures
(a_gk                IN    VARCHAR2,                   /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,                   /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,                   /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                     /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                     /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                     /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;


FUNCTION DeleteGroupKeyMeStructures
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyMeEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyMeEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRtList
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRt
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    UNAPIGEN.CHAR2_TABLE_TYPE,   /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRtValue
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRtSql
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeyRt
(a_gk               IN   VARCHAR2,                    /* VC20_TYPE */
 a_description      IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected     IN   CHAR,                        /* CHAR1_TYPE */
 a_value_unique     IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued    IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed  IN   CHAR,                        /* CHAR1_TYPE */
 a_mandatory        IN   CHAR,                        /* CHAR1_TYPE */
 a_struct_created   IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_gk       IN   CHAR,                        /* CHAR1_TYPE */
 a_value_list_tp    IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value    IN   VARCHAR2,                    /* VC40_TYPE */
 a_dsp_rows         IN   NUMBER,                      /* NUM_TYPE */
 a_val_length       IN   NUMBER,                      /* NUM_TYPE */
 a_val_start        IN   NUMBER,                      /* NUM_TYPE */
 a_assign_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_assign_id        IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_tp             IN   CHAR,                        /* CHAR2_TYPE */
 a_q_id             IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_check_au       IN   CHAR,                        /* CHAR1_TYPE */
 a_q_au             IN   VARCHAR2,                    /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyRt
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyRtStructures
(a_gk                IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyRtStructures
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyRtEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyRtEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRqList
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRq
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    UNAPIGEN.CHAR2_TABLE_TYPE,   /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRqValue
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRqSql
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeyRq
(a_gk               IN   VARCHAR2,                    /* VC20_TYPE */
 a_description      IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected     IN   CHAR,                        /* CHAR1_TYPE */
 a_value_unique     IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued    IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed  IN   CHAR,                        /* CHAR1_TYPE */
 a_mandatory        IN   CHAR,                        /* CHAR1_TYPE */
 a_struct_created   IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_gk       IN   CHAR,                        /* CHAR1_TYPE */
 a_value_list_tp    IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value    IN   VARCHAR2,                    /* VC40_TYPE */
 a_dsp_rows         IN   NUMBER,                      /* NUM_TYPE */
 a_val_length       IN   NUMBER,                      /* NUM_TYPE */
 a_val_start        IN   NUMBER,                      /* NUM_TYPE */
 a_assign_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_assign_id        IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_tp             IN   CHAR,                        /* CHAR2_TYPE */
 a_q_id             IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_check_au       IN   CHAR,                        /* CHAR1_TYPE */
 a_q_au             IN   VARCHAR2,                    /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyRq
(a_gk               IN     VARCHAR2,                  /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyRqStructures
(a_gk                IN    VARCHAR2,                 /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,                 /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,                 /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                   /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                   /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                   /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                   /* NUM_TYPE */
RETURN NUMBER;


FUNCTION DeleteGroupKeyRqStructures
(a_gk    IN    VARCHAR2)                              /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyRqEntries
(a_gk    IN    VARCHAR2)                              /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyRqEntries
(a_gk    IN    VARCHAR2)                              /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyWsList
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyWs
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    UNAPIGEN.CHAR2_TABLE_TYPE,   /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyWsValue
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyWsSql
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeyWs
(a_gk               IN   VARCHAR2,                    /* VC20_TYPE */
 a_description      IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected     IN   CHAR,                        /* CHAR1_TYPE */
 a_value_unique     IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued    IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed  IN   CHAR,                        /* CHAR1_TYPE */
 a_mandatory        IN   CHAR,                        /* CHAR1_TYPE */
 a_struct_created   IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_gk       IN   CHAR,                        /* CHAR1_TYPE */
 a_value_list_tp    IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value    IN   VARCHAR2,                    /* VC40_TYPE */
 a_dsp_rows         IN   NUMBER,                      /* NUM_TYPE */
 a_val_length       IN   NUMBER,                      /* NUM_TYPE */
 a_val_start        IN   NUMBER,                      /* NUM_TYPE */
 a_assign_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_assign_id        IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_tp             IN   CHAR,                        /* CHAR2_TYPE */
 a_q_id             IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_check_au       IN   CHAR,                        /* CHAR1_TYPE */
 a_q_au             IN   VARCHAR2,                    /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyWs
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyWsStructures
(a_gk                IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                 /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyWsStructures
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyWsEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyWsEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyPtList
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyPt
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    UNAPIGEN.CHAR2_TABLE_TYPE,   /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyPtValue
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyPtSql
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeyPt
(a_gk               IN   VARCHAR2,                    /* VC20_TYPE */
 a_description      IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected     IN   CHAR,                        /* CHAR1_TYPE */
 a_value_unique     IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued    IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed  IN   CHAR,                        /* CHAR1_TYPE */
 a_mandatory        IN   CHAR,                        /* CHAR1_TYPE */
 a_struct_created   IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_gk       IN   CHAR,                        /* CHAR1_TYPE */
 a_value_list_tp    IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value    IN   VARCHAR2,                    /* VC40_TYPE */
 a_dsp_rows         IN   NUMBER,                      /* NUM_TYPE */
 a_val_length       IN   NUMBER,                      /* NUM_TYPE */
 a_val_start        IN   NUMBER,                      /* NUM_TYPE */
 a_assign_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_assign_id        IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_tp             IN   CHAR,                        /* CHAR2_TYPE */
 a_q_id             IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_check_au       IN   CHAR,                        /* CHAR1_TYPE */
 a_q_au             IN   VARCHAR2,                    /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyPt
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyPtStructures
(a_gk                IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyPtStructures
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyPtEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyPtEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeySdList
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeySd
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    UNAPIGEN.CHAR2_TABLE_TYPE,   /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeySdValue
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeySdSql
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeySd
(a_gk               IN   VARCHAR2,                    /* VC20_TYPE */
 a_description      IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected     IN   CHAR,                        /* CHAR1_TYPE */
 a_value_unique     IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued    IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed  IN   CHAR,                        /* CHAR1_TYPE */
 a_mandatory        IN   CHAR,                        /* CHAR1_TYPE */
 a_struct_created   IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_gk       IN   CHAR,                        /* CHAR1_TYPE */
 a_value_list_tp    IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value    IN   VARCHAR2,                    /* VC40_TYPE */
 a_dsp_rows         IN   NUMBER,                      /* NUM_TYPE */
 a_val_length       IN   NUMBER,                      /* NUM_TYPE */
 a_val_start        IN   NUMBER,                      /* NUM_TYPE */
 a_assign_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_assign_id        IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_tp             IN   CHAR,                        /* CHAR2_TYPE */
 a_q_id             IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_check_au       IN   CHAR,                        /* CHAR1_TYPE */
 a_q_au             IN   VARCHAR2,                    /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeySd
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeySdStructures
(a_gk                IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeySdStructures
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeySdEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeySdEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyDcList
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyDc
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    UNAPIGEN.CHAR2_TABLE_TYPE,   /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyDcValue
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyDcSql
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeyDc
(a_gk               IN   VARCHAR2,                    /* VC20_TYPE */
 a_description      IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected     IN   CHAR,                        /* CHAR1_TYPE */
 a_value_unique     IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued    IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed  IN   CHAR,                        /* CHAR1_TYPE */
 a_mandatory        IN   CHAR,                        /* CHAR1_TYPE */
 a_struct_created   IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_gk       IN   CHAR,                        /* CHAR1_TYPE */
 a_value_list_tp    IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value    IN   VARCHAR2,                    /* VC40_TYPE */
 a_dsp_rows         IN   NUMBER,                      /* NUM_TYPE */
 a_val_length       IN   NUMBER,                      /* NUM_TYPE */
 a_val_start        IN   NUMBER,                      /* NUM_TYPE */
 a_assign_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_assign_id        IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_tp             IN   CHAR,                        /* CHAR2_TYPE */
 a_q_id             IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_check_au       IN   CHAR,                        /* CHAR1_TYPE */
 a_q_au             IN   VARCHAR2,                    /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyDc
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyDcStructures
(a_gk                IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                 /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyDcStructures
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyDcEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyDcEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyChList
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyCh
(a_gk               OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description      OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_is_protected     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_unique     OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_single_valued    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_new_val_allowed  OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_mandatory        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_struct_created   OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_inherit_gk       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_value_list_tp    OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_default_value    OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_dsp_rows         OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_length       OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_val_start        OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_assign_tp        OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_assign_id        OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_tp             OUT    UNAPIGEN.CHAR2_TABLE_TYPE,   /* CHAR2_TABLE_TYPE */
 a_q_id             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_q_check_au       OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_q_au             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_nr_of_rows       IN OUT NUMBER,                      /* NUM_TYPE */
 a_where_clause     IN     VARCHAR2)                    /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyChValue
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyChSql
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeyCh
(a_gk               IN   VARCHAR2,                    /* VC20_TYPE */
 a_description      IN   VARCHAR2,                    /* VC40_TYPE */
 a_is_protected     IN   CHAR,                        /* CHAR1_TYPE */
 a_value_unique     IN   CHAR,                        /* CHAR1_TYPE */
 a_single_valued    IN   CHAR,                        /* CHAR1_TYPE */
 a_new_val_allowed  IN   CHAR,                        /* CHAR1_TYPE */
 a_mandatory        IN   CHAR,                        /* CHAR1_TYPE */
 a_struct_created   IN   CHAR,                        /* CHAR1_TYPE */
 a_inherit_gk       IN   CHAR,                        /* CHAR1_TYPE */
 a_value_list_tp    IN   CHAR,                        /* CHAR1_TYPE */
 a_default_value    IN   VARCHAR2,                    /* VC40_TYPE */
 a_dsp_rows         IN   NUMBER,                      /* NUM_TYPE */
 a_val_length       IN   NUMBER,                      /* NUM_TYPE */
 a_val_start        IN   NUMBER,                      /* NUM_TYPE */
 a_assign_tp        IN   CHAR,                        /* CHAR1_TYPE */
 a_assign_id        IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_tp             IN   CHAR,                        /* CHAR2_TYPE */
 a_q_id             IN   VARCHAR2,                    /* VC20_TYPE */
 a_q_check_au       IN   CHAR,                        /* CHAR1_TYPE */
 a_q_au             IN   VARCHAR2,                    /* VC20_TYPE */
 a_value            IN   UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_sqltext          IN   UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows       IN   NUMBER,                      /* NUM_TYPE */
 a_modify_reason    IN   VARCHAR2)                    /* VC255_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyCh
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyChStructures
(a_gk                IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                 /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyChStructures
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyChEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyChEntries
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

PROCEDURE DeleteGroupKeyFromTask                      /* INTERNAL */
(a_gk_tp               IN      VARCHAR2,              /* VC4_TYPE */
 a_gk                  IN      VARCHAR2);             /* VC20_TYPE */
RETURN NUMBER;

FUNCTION InitGroupKeyDefStorage
(a_gk_tp             IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_initial      OUT   VARCHAR2,               /* VC20_TYPE */
 a_stor_next         OUT   VARCHAR2,               /* VC20_TYPE */
 a_stor_min_extents  OUT   NUMBER,                 /* NUM_TYPE */
 a_stor_pct_increase OUT   NUMBER,                 /* NUM_TYPE */
 a_stor_pct_free     OUT   NUMBER,                 /* NUM_TYPE */
 a_stor_pct_used     OUT   NUMBER                  /* NUM_TYPE */
)
RETURN NUMBER;

FUNCTION SaveEventRules
(a_rule_nr           IN       UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_applic            IN       UNAPIGEN.VC8_TABLE_TYPE,    /* VC8_TABLE_TYPE */
 a_dbapi_name        IN       UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_object_tp         IN       UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_object_id         IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_object_lc         IN       UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_object_lc_version IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_object_ss         IN       UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_ev_tp             IN       UNAPIGEN.VC60_TABLE_TYPE,   /* VC60_TABLE_TYPE */
 a_condition         IN       UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_af                IN       UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_af_delay          IN       UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_af_delay_unit     IN       UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_custom            IN       UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN       NUMBER,                     /* NUM_TYPE */
 a_modify_reason     IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetEventRules
(a_rule_nr           OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_applic            OUT      UNAPIGEN.VC8_TABLE_TYPE,    /* VC8_TABLE_TYPE */
 a_dbapi_name        OUT      UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_object_tp         OUT      UNAPIGEN.VC4_TABLE_TYPE,    /* VC4_TABLE_TYPE */
 a_object_id         OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_object_lc         OUT      UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_object_lc_version OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_object_ss         OUT      UNAPIGEN.VC2_TABLE_TYPE,    /* VC2_TABLE_TYPE */
 a_ev_tp             OUT      UNAPIGEN.VC60_TABLE_TYPE,   /* VC60_TABLE_TYPE */
 a_condition         OUT      UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_af                OUT      UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_af_delay          OUT      UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_af_delay_unit     OUT      UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_custom            OUT      UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows        IN  OUT  NUMBER,                     /* NUM_TYPE */
 a_order_by_clause   IN       VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateUserStructsForGroupKey
(a_gk_tp               IN      VARCHAR2,              /* VC4_TYPE */
 a_gk                  IN      VARCHAR2)              /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteUserStructsForGroupKey
(a_gk_tp               IN      VARCHAR2,              /* VC4_TYPE */
 a_gk                  IN      VARCHAR2)              /* VC20_TYPE */
RETURN NUMBER;

FUNCTION InitGroupKeyDefBuffer
(a_gk_tp               IN      VARCHAR2)              /* VC4_TYPE */
RETURN NUMBER;

FUNCTION CloseGroupKeyDefBuffer
(a_gk_tp               IN      VARCHAR2)              /* VC4_TYPE */
RETURN NUMBER;

TYPE GkDefinitionRec IS RECORD(
  description                    VARCHAR2(40),
  is_protected                   CHAR(1),
  value_unique                   CHAR(1),
  single_valued                  CHAR(1),
  new_val_allowed                CHAR(1),
  mandatory                      CHAR(1),
  value_list_tp                  CHAR(1),
  dsp_rows                       NUMBER(3));
TYPE GkTabIndexedByVarchar2 IS TABLE OF GkDefinitionRec INDEX BY VARCHAR2(20);
P_GK_DEF_BUFFER     GkTabIndexedByVarchar2;

--constants that are used when creating group key tables dynamically
ALLSTGKTABLECOLUMNS    CONSTANT VARCHAR2(100) := 'st, version, ~gk~';
ALLRTGKTABLECOLUMNS    CONSTANT VARCHAR2(100) := 'rt, version, ~gk~';
ALLSCGKTABLECOLUMNS    CONSTANT VARCHAR2(100) := 'sc, ~gk~';
ALLSCMEGKTABLECOLUMNS  CONSTANT VARCHAR2(100) := 'sc, pg, pgnode, pa, panode, me, menode, ~gk~';
ALLWSGKTABLECOLUMNS    CONSTANT VARCHAR2(100) := 'ws, ~gk~';
ALLRQGKTABLECOLUMNS    CONSTANT VARCHAR2(100) := 'rq, ~gk~';
ALLSDGKTABLECOLUMNS    CONSTANT VARCHAR2(100) := 'sd, ~gk~';
ALLPTGKTABLECOLUMNS    CONSTANT VARCHAR2(100) := 'pt, ~gk~';
ALLDCGKTABLECOLUMNS    CONSTANT VARCHAR2(100) := 'dc, version, ~gk~';
ALLCHGKTABLECOLUMNS    CONSTANT VARCHAR2(100) := 'ch, ~gk~';

END unapigk;