create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapigk2 AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetGroupKeyRtList                                 /* INTERNAL */
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRt                                  /* INTERNAL */
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

FUNCTION GetGroupKeyRtValue                            /* INTERNAL */
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRtSql                              /* INTERNAL */
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeyRt                               /* INTERNAL */
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

FUNCTION DeleteGroupKeyRt                              /* INTERNAL */
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyRtStructures                /* INTERNAL */
(a_gk                IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                 /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyRtStructures              /* INTERNAL */
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyRtEntries                 /* INTERNAL */
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyRtEntries                 /* INTERNAL */
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRqList                                 /* INTERNAL */
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRq                                  /* INTERNAL */
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

FUNCTION GetGroupKeyRqValue                            /* INTERNAL */
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyRqSql                              /* INTERNAL */
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeyRq                               /* INTERNAL */
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

FUNCTION DeleteGroupKeyRq                             /* INTERNAL */
(a_gk               IN     VARCHAR2,                  /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyRqStructures                   /* INTERNAL */
(a_gk                IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,                  /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                    /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyRqStructures                   /* INTERNAL */
(a_gk    IN    VARCHAR2)                              /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyRqEntries                      /* INTERNAL */
(a_gk    IN    VARCHAR2)                              /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyRqEntries                      /* INTERNAL */
(a_gk    IN    VARCHAR2)                              /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyWsList                                 /* INTERNAL */
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyWs                                  /* INTERNAL */
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

FUNCTION GetGroupKeyWsValue                            /* INTERNAL */
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyWsSql                              /* INTERNAL */
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeyWs                               /* INTERNAL */
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

FUNCTION DeleteGroupKeyWs                              /* INTERNAL */
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyWsStructures                /* INTERNAL */
(a_gk                IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                 /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyWsStructures              /* INTERNAL */
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyWsEntries                 /* INTERNAL */
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyWsEntries                 /* INTERNAL */
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyPtList                                 /* INTERNAL */
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyPt                                  /* INTERNAL */
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

FUNCTION GetGroupKeyPtValue                            /* INTERNAL */
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeyPtSql                              /* INTERNAL */
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeyPt                               /* INTERNAL */
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

FUNCTION DeleteGroupKeyPt                              /* INTERNAL */
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyPtStructures                /* INTERNAL */
(a_gk                IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                 /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyPtStructures              /* INTERNAL */
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeyPtEntries                 /* INTERNAL */
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeyPtEntries                 /* INTERNAL */
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeySdList                                 /* INTERNAL */
(a_gk                  OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_description         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeySd                                  /* INTERNAL */
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

FUNCTION GetGroupKeySdValue                            /* INTERNAL */
(a_gk               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_value            OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_nr_of_rows       IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause     IN      VARCHAR2)                  /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetGroupKeySdSql                              /* INTERNAL */
(a_gk              OUT     UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_sqltext         OUT     UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_nr_of_rows      IN OUT  NUMBER,                     /* NUM_TYPE */
 a_where_clause    IN      VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION SaveGroupKeySd                               /* INTERNAL */
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

FUNCTION DeleteGroupKeySd                              /* INTERNAL */
(a_gk               IN     VARCHAR2,                   /* VC20_TYPE */
 a_modify_reason    IN     VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeySdStructures                /* INTERNAL */
(a_gk                IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_initial      IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_next         IN    VARCHAR2,               /* VC20_TYPE */
 a_stor_min_extents  IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_increase IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_free     IN    NUMBER,                 /* NUM_TYPE */
 a_stor_pct_used     IN    NUMBER)                 /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeySdStructures              /* INTERNAL */
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CreateGroupKeySdEntries                 /* INTERNAL */
(a_gk    IN    VARCHAR2)                         /* VC20_TYPE */
RETURN NUMBER;

FUNCTION DeleteGroupKeySdEntries                 /* INTERNAL */
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

FUNCTION InitGroupKeyDefBuffer
(a_gk_tp               IN      VARCHAR2)              /* VC4_TYPE */
RETURN NUMBER;

FUNCTION CloseGroupKeyDefBuffer
(a_gk_tp               IN      VARCHAR2)              /* VC4_TYPE */
RETURN NUMBER;

END unapigk2;