create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiedittable AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetTableList
(a_table_name          OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_description         OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_log_hs              OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_log_hs_details      OUT    UNAPIGEN.CHAR1_TABLE_TYPE,   /* CHAR1_TABLE_TYPE */
 a_where_clause        OUT    UNAPIGEN.VC511_TABLE_TYPE,   /* VC511_TABLE_TYPE */
 a_nr_of_rows          IN OUT NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveTableList
(a_table_name          IN    VARCHAR2,                   /* VC20_TYPE */
 a_description         IN    VARCHAR2,                   /* VC40_TYPE */
 a_log_hs              IN    CHAR,                       /* CHAR1_TYPE */
 a_log_hs_details      IN    CHAR,                       /* CHAR1_TYPE */
 a_where_clause        IN    VARCHAR2)                   /* VC511_TYPE */
RETURN NUMBER;

FUNCTION GetTableDescription
(a_column_name         OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_nullable            OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_data_type           OUT     UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_data_length         OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_data_precision      OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_data_scale          OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_char_length         OUT     UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_ispartofprimarykey  OUT     UNAPIGEN.CHAR1_TABLE_TYPE,  /* CHAR1_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_table_name          IN      VARCHAR2,                   /* VC40_TYPE */
 a_order_by_clause     IN      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetTableData
(a_row_values          OUT     UNAPIGEN.VC4000_TABLE_TYPE, /* VC4000_TABLE_TYPE */
 a_nr_of_rows          IN OUT  NUMBER,                     /* NUM_TYPE */
 a_table_name          IN      VARCHAR2,                   /* VC40_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveTableData
(a_row_values          IN      UNAPIGEN.VC4000_TABLE_TYPE, /* VC4000_TABLE_TYPE */
 a_nr_of_rows          IN      NUMBER,                     /* NUM_TYPE */
 a_table_name          IN      VARCHAR2,                   /* VC40_TYPE */
 a_where_clause        IN      VARCHAR2,                   /* VC511_TYPE */
 a_next_rows           IN      NUMBER,                     /* NUM_TYPE */
 a_modify_reason       IN      VARCHAR2)                   /* VC255_TYPE */
RETURN NUMBER;

FUNCTION GetTableHistory
(a_table_name        OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_who               OUT     UNAPIGEN.VC20_TABLE_TYPE,  /* VC20_TABLE_TYPE */
 a_who_description   OUT     UNAPIGEN.VC40_TABLE_TYPE,  /* VC40_TABLE_TYPE */
 a_what              OUT     UNAPIGEN.VC60_TABLE_TYPE,  /* VC60_TABLE_TYPE */
 a_what_description  OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_logdate           OUT     UNAPIGEN.DATE_TABLE_TYPE,  /* DATE_TABLE_TYPE */
 a_why               OUT     UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_tr_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_ev_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,   /* NUM_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER,                    /* NUM_TYPE */
 a_where_clause      IN      VARCHAR2,                  /* VC511_TYPE */
 a_next_rows         IN      NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION GetTableHistoryDetails
(a_table_name        OUT     UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_tr_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_ev_seq            OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_seq               OUT     UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE */
 a_details           OUT     UNAPIGEN.VC4000_TABLE_TYPE,  /* VC4000_TABLE_TYPE */
 a_nr_of_rows        IN OUT  NUMBER,                      /* NUM_TYPE */
 a_where_clause      IN      VARCHAR2,                    /* VC511_TYPE */
 a_next_rows         IN      NUMBER)                      /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SaveTableHistory
(a_table_name        IN        VARCHAR2,                   /* VC20_TYPE */
 a_who               IN        UNAPIGEN.VC20_TABLE_TYPE,   /* VC20_TABLE_TYPE */
 a_who_description   IN        UNAPIGEN.VC40_TABLE_TYPE,   /* VC40_TABLE_TYPE */
 a_what              IN        UNAPIGEN.VC60_TABLE_TYPE,   /* VC60_TABLE_TYPE */
 a_what_description  IN        UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_logdate           IN        UNAPIGEN.DATE_TABLE_TYPE,   /* DATE_TABLE_TYPE */
 a_why               IN        UNAPIGEN.VC255_TABLE_TYPE,  /* VC255_TABLE_TYPE */
 a_tr_seq            IN        UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_ev_seq            IN        UNAPIGEN.NUM_TABLE_TYPE,    /* NUM_TABLE_TYPE */
 a_nr_of_rows        IN        NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

END unapiedittable;