create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.4.0 (V06.04.00.00_24.01) $
-- $Date: 2009-04-20T16:24:00 $
uniconnect AS

TYPE BOOLEAN_TABLE_TYPE IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;

/* UNICONNECT CONSTANTS */
P_ON_DBAPI_ERROR_CONTINUE CONSTANT BOOLEAN := FALSE;
P_ON_PARSE_ERROR_CONTINUE CONSTANT BOOLEAN := FALSE;
P_ON_EXCEPTIONS_CONTINUE  CONSTANT BOOLEAN := FALSE;
P_MAX_DEADLOCK_RETRIES    CONSTANT INTEGER := 2;    --maximal number of retries when deadlock encountered

/* Own settings for change status and cancel for timeout on In-transition objects */
/* will overule current settings with the same name in UNAPIEV */
P_CSS_RETRIESWHENINTRANSITION  CONSTANT INTEGER DEFAULT 1;
P_CSS_INTERVALWHENINTRANSITION CONSTANT NUMBER  DEFAULT 2/5;

/* UNICONNECT GLOBAL SETTINGS */
P_SET_CREATE_SC         CHAR(1);
P_SET_CREATE_PG         VARCHAR2(20);
P_SET_CREATE_PA         VARCHAR2(20);
P_SET_CREATE_ME         VARCHAR2(20);
P_SET_CREATE_IC         VARCHAR2(20);
P_SET_CREATE_II         VARCHAR2(20);
P_SET_CREATE_ME_DETAILS VARCHAR2(20);
P_SET_ALLOW_REANALYSIS  CHAR(1);

/* UNICONNECT GLOBAL VARIABLES */
P_GLOB_SC           VARCHAR2(20);
P_GLOB_PG           VARCHAR2(20);
P_GLOB_PGNODE       NUMBER(9);
P_GLOB_PA           VARCHAR2(20);
P_GLOB_PANODE       NUMBER(9);
P_GLOB_ME           VARCHAR2(20);
P_GLOB_MENODE       NUMBER(9);
P_GLOB_CE           VARCHAR2(20);
P_GLOB_CENODE       NUMBER(9);
P_GLOB_IC           VARCHAR2(20);
P_GLOB_ICNODE       NUMBER(9);
P_GLOB_II           VARCHAR2(20);
P_GLOB_IINODE       NUMBER(9);

/* UNICONNECT package variables */
P_TEXT_LINE              UNAPIGEN.VC2000_TABLE_TYPE;
P_CUR_TEXT_LINE          VARCHAR2(2000);
P_CONTINUATION_USED      BOOLEAN ;
P_SECTION                VARCHAR2(20);
P_ROWS_IN_SECTION        NUMBER;
P_VARIABLE_NAME          VARCHAR2(20);
P_VARIABLE_VALUE         VARCHAR2(2000);

/* LOCAL VARIABLES FOR [sc] section */
P_SC_SC                   VARCHAR2(2000); --can be filled in with a sql query
P_SC_ST                   VARCHAR2(20);
P_SC_ST_VERSION           VARCHAR2(20);
P_SC_REF_DATE             TIMESTAMP WITH TIME ZONE;
P_SC_USER_ID              VARCHAR2(20);
P_SC_COMMENT              VARCHAR2(255);
P_SC_ADD_COMMENT          VARCHAR2(255);
P_SC_FIELDTYPE_TAB        UNAPIGEN.VC20_TABLE_TYPE;
P_SC_FIELDNAMES_TAB       UNAPIGEN.VC20_TABLE_TYPE;
P_SC_FIELDVALUES_TAB      UNAPIGEN.VC40_TABLE_TYPE;
P_SC_FIELDNR_OF_ROWS      NUMBER;
P_SC_SS                   VARCHAR2(2);
P_SC_COPY_FROM            VARCHAR2(20);
P_SC_LAST_SC              VARCHAR2(20);

--modify flags
P_SC_ST_MOD         BOOLEAN;
P_SC_ST_VERSION_MOD BOOLEAN;
P_SC_REF_DATE_MOD   BOOLEAN;
P_SC_USER_ID_MOD    BOOLEAN;

--local variables for SelectSample
P_SELSC_COL_ID_TAB                  UNAPIGEN.VC40_TABLE_TYPE;
P_SELSC_COL_TP_TAB                  UNAPIGEN.VC40_TABLE_TYPE;
P_SELSC_COL_VALUE_TAB               UNAPIGEN.VC40_TABLE_TYPE;
P_SELSC_COL_NR_OF_ROWS              NUMBER;

P_SELSC_NR_OF_ROWS                  NUMBER;
P_SELSC_ORDER_BY_CLAUSE             VARCHAR2(255);
P_SELSC_NEXT_ROWS                   NUMBER;
P_SELSC_SC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_SELSC_ST_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_SELSC_ST_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_SELSC_DESCRIPTION_TAB             UNAPIGEN.VC40_TABLE_TYPE;
P_SELSC_SHELF_LIFE_VAL_TAB          UNAPIGEN.NUM_TABLE_TYPE;
P_SELSC_SHELF_LIFE_UNIT_TAB         UNAPIGEN.VC20_TABLE_TYPE;
P_SELSC_SAMPLING_DATE_TAB           UNAPIGEN.DATE_TABLE_TYPE;
P_SELSC_CREATION_DATE_TAB           UNAPIGEN.DATE_TABLE_TYPE;
P_SELSC_CREATED_BY_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_SELSC_EXEC_START_DATE_TAB         UNAPIGEN.DATE_TABLE_TYPE;
P_SELSC_EXEC_END_DATE_TAB           UNAPIGEN.DATE_TABLE_TYPE;
P_SELSC_PRIORITY_TAB                UNAPIGEN.NUM_TABLE_TYPE;
P_SELSC_LABEL_FORMAT_TAB            UNAPIGEN.VC20_TABLE_TYPE;
P_SELSC_DESCR_DOC_TAB               UNAPIGEN.VC40_TABLE_TYPE;
P_SELSC_DESCR_DOC_VERSION_TAB       UNAPIGEN.VC20_TABLE_TYPE;
P_SELSC_RQ_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_SELSC_SD_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_SELSC_DATE1_TAB                   UNAPIGEN.DATE_TABLE_TYPE;
P_SELSC_DATE2_TAB                   UNAPIGEN.DATE_TABLE_TYPE;
P_SELSC_DATE3_TAB                   UNAPIGEN.DATE_TABLE_TYPE;
P_SELSC_DATE4_TAB                   UNAPIGEN.DATE_TABLE_TYPE;
P_SELSC_DATE5_TAB                   UNAPIGEN.DATE_TABLE_TYPE;
P_SELSC_ALLOW_ANY_PP_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
P_SELSC_SC_CLASS_TAB                UNAPIGEN.VC2_TABLE_TYPE;
P_SELSC_LOG_HS_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
P_SELSC_LOG_HS_DETAILS_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_SELSC_ALLOW_MODIFY_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
P_SELSC_AR_TAB                      UNAPIGEN.CHAR1_TABLE_TYPE;
P_SELSC_ACTIVE_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
P_SELSC_LC_TAB                      UNAPIGEN.VC2_TABLE_TYPE;
P_SELSC_LC_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_SELSC_SS_TAB                      UNAPIGEN.VC2_TABLE_TYPE;

/* LOCAL VARIABLES FOR [pg] section */
P_PG_SC                          VARCHAR2(20);
P_PG_NR_OF_ROWS                  NUMBER;
P_PG_MODIFY_REASON               VARCHAR2(255);

P_PG_SC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_PG_PG_TAB                      UNAPIGEN.VC20_TABLE_TYPE;

P_PG_PGNAME_TAB                  UNAPIGEN.VC20_TABLE_TYPE; --will contain the variable name used like pg, pg.pg , pg.description, pg[],...
P_PG_PGDESCRIPTION_TAB           UNAPIGEN.VC40_TABLE_TYPE; --will contain the pg description when pg.description syntax is used

P_PG_PGNODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
P_PG_PP_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_PG_PP_KEY1_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
P_PG_PP_KEY2_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
P_PG_PP_KEY3_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
P_PG_PP_KEY4_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
P_PG_PP_KEY5_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
P_PG_DESCRIPTION_TAB             UNAPIGEN.VC40_TABLE_TYPE;
P_PG_VALUE_F_TAB                 UNAPIGEN.FLOAT_TABLE_TYPE;
P_PG_VALUE_S_TAB                 UNAPIGEN.VC40_TABLE_TYPE;
P_PG_UNIT_TAB                    UNAPIGEN.VC20_TABLE_TYPE;
P_PG_EXEC_START_DATE_TAB         UNAPIGEN.DATE_TABLE_TYPE;
P_PG_EXEC_END_DATE_TAB           UNAPIGEN.DATE_TABLE_TYPE;
P_PG_EXECUTOR_TAB                UNAPIGEN.VC20_TABLE_TYPE;
P_PG_PLANNED_EXECUTOR_TAB        UNAPIGEN.VC20_TABLE_TYPE;
P_PG_MANUALLY_ENTERED_TAB        UNAPIGEN.CHAR1_TABLE_TYPE;
P_PG_ASSIGN_DATE_TAB             UNAPIGEN.DATE_TABLE_TYPE;
P_PG_ASSIGNED_BY_TAB             UNAPIGEN.VC20_TABLE_TYPE;
P_PG_MANUALLY_ADDED_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_PG_FORMAT_TAB                  UNAPIGEN.VC40_TABLE_TYPE;
P_PG_CONFIRM_ASSIGN_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_PG_ALLOW_ANY_PR_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
P_PG_NEVER_CREATE_METHODS_TAB    UNAPIGEN.CHAR1_TABLE_TYPE;
P_PG_DELAY_TAB                   UNAPIGEN.NUM_TABLE_TYPE;
P_PG_DELAY_UNIT_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_PG_PG_CLASS_TAB                UNAPIGEN.VC2_TABLE_TYPE;
P_PG_LOG_HS_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
P_PG_LOG_HS_DETAILS_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_PG_LC_TAB                      UNAPIGEN.VC2_TABLE_TYPE;
P_PG_LC_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_PG_MODIFY_FLAG_TAB             UNAPIGEN.NUM_TABLE_TYPE;
P_PG_SS_TAB                      UNAPIGEN.VC2_TABLE_TYPE;
P_PG_ADD_COMMENT_TAB             UNAPIGEN.VC255_TABLE_TYPE;

P_PG_DESCRIPTION_MODTAB          BOOLEAN_TABLE_TYPE;
P_PG_VALUE_F_MODTAB              BOOLEAN_TABLE_TYPE;
P_PG_VALUE_S_MODTAB              BOOLEAN_TABLE_TYPE;
P_PG_UNIT_MODTAB                 BOOLEAN_TABLE_TYPE;
P_PG_EXEC_START_DATE_MODTAB      BOOLEAN_TABLE_TYPE;
P_PG_EXEC_END_DATE_MODTAB        BOOLEAN_TABLE_TYPE;
P_PG_EXECUTOR_MODTAB             BOOLEAN_TABLE_TYPE;
P_PG_MANUALLY_ENTERED_MODTAB     BOOLEAN_TABLE_TYPE;
P_PG_SS_MODTAB                   BOOLEAN_TABLE_TYPE;

/* LOCAL VARIABLES FOR [pa] section */
P_PA_SC                          VARCHAR2(20);
P_PA_PG                          VARCHAR2(20);
P_PA_PGNAME                      VARCHAR2(20); --will contain the variable name used like pg, pg.pg , pg.description, pg[],...
P_PA_PGDESCRIPTION               VARCHAR2(40); --will contain the pg description when pg.description syntax is used
P_PA_PP_KEY1                     VARCHAR2(20);
P_PA_PP_KEY2                     VARCHAR2(20);
P_PA_PP_KEY3                     VARCHAR2(20);
P_PA_PP_KEY4                     VARCHAR2(20);
P_PA_PP_KEY5                     VARCHAR2(20);
P_PA_PP_VERSION                  VARCHAR2(20);
P_PA_PGNODE                      NUMBER;
P_PA_NR_OF_ROWS                  NUMBER;
P_PA_ALARMS_HANDLED              CHAR(1);
P_PA_USE_SAVESCPARESULT          BOOLEAN DEFAULT FALSE;

P_PA_SC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_PA_PG_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_PA_PGNODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
P_PA_PA_TAB                      UNAPIGEN.VC20_TABLE_TYPE;

P_PA_PANAME_TAB                  UNAPIGEN.VC20_TABLE_TYPE; --will contain the variable name used like pa, pa.pa , pa.description, pa[],...
P_PA_PADESCRIPTION_TAB           UNAPIGEN.VC40_TABLE_TYPE; --will contain the pa description when pg.description syntax is used

P_PA_PANODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;

P_PA_PR_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_PA_DESCRIPTION_TAB             UNAPIGEN.VC40_TABLE_TYPE;
P_PA_VALUE_F_TAB                 UNAPIGEN.FLOAT_TABLE_TYPE;
P_PA_VALUE_S_TAB                 UNAPIGEN.VC40_TABLE_TYPE;
P_PA_UNIT_TAB                    UNAPIGEN.VC20_TABLE_TYPE;
P_PA_EXEC_START_DATE_TAB         UNAPIGEN.DATE_TABLE_TYPE;
P_PA_EXEC_END_DATE_TAB           UNAPIGEN.DATE_TABLE_TYPE;
P_PA_EXECUTOR_TAB                UNAPIGEN.VC20_TABLE_TYPE;
P_PA_PLANNED_EXECUTOR_TAB        UNAPIGEN.VC20_TABLE_TYPE;
P_PA_MANUALLY_ENTERED_TAB        UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_ASSIGN_DATE_TAB             UNAPIGEN.DATE_TABLE_TYPE;
P_PA_ASSIGNED_BY_TAB             UNAPIGEN.VC20_TABLE_TYPE;
P_PA_MANUALLY_ADDED_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_FORMAT_TAB                  UNAPIGEN.VC40_TABLE_TYPE;
P_PA_TD_INFO_TAB                 UNAPIGEN.NUM_TABLE_TYPE;
P_PA_TD_INFO_UNIT_TAB            UNAPIGEN.VC20_TABLE_TYPE;
P_PA_CONFIRM_UID_TAB             UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_ALLOW_ANY_ME_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_DELAY_TAB                   UNAPIGEN.NUM_TABLE_TYPE;
P_PA_DELAY_UNIT_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_PA_MIN_NR_RESULTS_TAB          UNAPIGEN.NUM_TABLE_TYPE;
P_PA_CALC_METHOD_TAB             UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_CALC_CF_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
P_PA_ALARM_ORDER_TAB             UNAPIGEN.VC3_TABLE_TYPE;
P_PA_VALID_SPECSA_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_VALID_SPECSB_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_VALID_SPECSC_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_VALID_LIMITSA_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_VALID_LIMITSB_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_VALID_LIMITSC_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_VALID_TARGETA_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_VALID_TARGETB_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_VALID_TARGETC_TAB           UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_MT_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_PA_MT_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_PA_MT_NR_MEASUR_TAB            UNAPIGEN.NUM_TABLE_TYPE;
P_PA_LOG_EXCEPTIONS_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_PA_CLASS_TAB                UNAPIGEN.VC2_TABLE_TYPE;
P_PA_LOG_HS_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_LOG_HS_DETAILS_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_PA_LC_TAB                      UNAPIGEN.VC2_TABLE_TYPE;
P_PA_LC_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_PA_MODIFY_FLAG_TAB             UNAPIGEN.NUM_TABLE_TYPE;
P_PA_MODIFY_REASON               VARCHAR2(255);
P_PA_REANALYSIS_TAB              UNAPIGEN.NUM_TABLE_TYPE;
P_PA_SS_TAB                      UNAPIGEN.VC2_TABLE_TYPE;
P_PA_ADD_COMMENT_TAB             UNAPIGEN.VC255_TABLE_TYPE;

P_PA_DESCRIPTION_MODTAB          BOOLEAN_TABLE_TYPE;
P_PA_VALUE_F_MODTAB              BOOLEAN_TABLE_TYPE;
P_PA_VALUE_S_MODTAB              BOOLEAN_TABLE_TYPE;
P_PA_UNIT_MODTAB                 BOOLEAN_TABLE_TYPE;
P_PA_MANUALLY_ENTERED_MODTAB     BOOLEAN_TABLE_TYPE;
P_PA_EXEC_START_DATE_MODTAB      BOOLEAN_TABLE_TYPE;
P_PA_EXEC_END_DATE_MODTAB        BOOLEAN_TABLE_TYPE;
P_PA_EXECUTOR_MODTAB             BOOLEAN_TABLE_TYPE;
P_PA_SS_MODTAB                   BOOLEAN_TABLE_TYPE;

/* LOCAL VARIABLES FOR [me] section */
P_ME_SC                          VARCHAR2(20);
P_ME_PG                          VARCHAR2(20);
P_ME_PGNAME                      VARCHAR2(20); --will contain the variable name used like pg, pg.pg , pg.description, pg[],...
P_ME_PGDESCRIPTION               VARCHAR2(40); --will contain the pg description when pg.description syntax is used
P_ME_PP_KEY1                     VARCHAR2(20);
P_ME_PP_KEY2                     VARCHAR2(20);
P_ME_PP_KEY3                     VARCHAR2(20);
P_ME_PP_KEY4                     VARCHAR2(20);
P_ME_PP_KEY5                     VARCHAR2(20);
P_ME_PP_VERSION                  VARCHAR2(20);
P_ME_PGNODE                      NUMBER;
P_ME_PA                          VARCHAR2(20);
P_ME_PANAME                      VARCHAR2(20); --will contain the variable name used like pa, pa.pa , pa.description, pa[],...
P_ME_PADESCRIPTION               VARCHAR2(40); --will contain the pg description when pa.description syntax is used
P_ME_PANODE                      NUMBER;
P_ME_PR_VERSION                  VARCHAR2(20);
P_ME_NR_OF_ROWS                  NUMBER;
P_ME_ALARMS_HANDLED              CHAR(1);
P_ME_USE_SAVESCMERESULT          BOOLEAN DEFAULT FALSE;
P_ME_ANY_RESULT                  BOOLEAN DEFAULT FALSE;

P_ME_SC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_ME_PG_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_ME_PGNODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
P_ME_PA_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_ME_PANODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
P_ME_ME_TAB                      UNAPIGEN.VC20_TABLE_TYPE;

P_ME_MENAME_TAB                  UNAPIGEN.VC20_TABLE_TYPE; --will contain the variable name used like me, me.me , me.description, me[],...
P_ME_MEDESCRIPTION_TAB           UNAPIGEN.VC40_TABLE_TYPE; --will contain the me description when me.description syntax is used

P_ME_MENODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;

P_ME_MT_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_ME_DESCRIPTION_TAB             UNAPIGEN.VC40_TABLE_TYPE;
P_ME_VALUE_F_TAB                 UNAPIGEN.FLOAT_TABLE_TYPE;
P_ME_VALUE_S_TAB                 UNAPIGEN.VC40_TABLE_TYPE;
P_ME_UNIT_TAB                    UNAPIGEN.VC20_TABLE_TYPE;
P_ME_EXEC_START_DATE_TAB         UNAPIGEN.DATE_TABLE_TYPE;
P_ME_EXEC_END_DATE_TAB           UNAPIGEN.DATE_TABLE_TYPE;
P_ME_EXECUTOR_TAB                UNAPIGEN.VC20_TABLE_TYPE;
P_ME_LAB_TAB                     UNAPIGEN.VC20_TABLE_TYPE;
P_ME_EQ_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_ME_EQ_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_ME_PLANNED_EXECUTOR_TAB        UNAPIGEN.VC20_TABLE_TYPE;
P_ME_PLANNED_EQ_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_ME_PLANNED_EQ_VERSION_TAB      UNAPIGEN.VC20_TABLE_TYPE;
P_ME_MANUALLY_ENTERED_TAB        UNAPIGEN.CHAR1_TABLE_TYPE;
P_ME_ALLOW_ADD_TAB               UNAPIGEN.CHAR1_TABLE_TYPE;
P_ME_ASSIGN_DATE_TAB             UNAPIGEN.DATE_TABLE_TYPE;
P_ME_ASSIGNED_BY_TAB             UNAPIGEN.VC20_TABLE_TYPE;
P_ME_MANUALLY_ADDED_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_ME_DELAY_TAB                   UNAPIGEN.NUM_TABLE_TYPE;
P_ME_DELAY_UNIT_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_ME_FORMAT_TAB                  UNAPIGEN.VC40_TABLE_TYPE;
P_ME_ACCURACY_TAB                UNAPIGEN.FLOAT_TABLE_TYPE;
P_ME_REAL_COST_TAB               UNAPIGEN.VC40_TABLE_TYPE;
P_ME_REAL_TIME_TAB               UNAPIGEN.VC40_TABLE_TYPE;
P_ME_CALIBRATION_TAB             UNAPIGEN.CHAR1_TABLE_TYPE;
P_ME_CONFIRM_COMPLETE_TAB        UNAPIGEN.CHAR1_TABLE_TYPE;
P_ME_AUTORECALC_TAB              UNAPIGEN.CHAR1_TABLE_TYPE;
P_ME_ME_RESULT_EDITABLE_TAB      UNAPIGEN.CHAR1_TABLE_TYPE;
P_ME_NEXT_CELL_TAB               UNAPIGEN.VC20_TABLE_TYPE;
P_ME_SOP_TAB                     UNAPIGEN.VC40_TABLE_TYPE;
P_ME_SOP_VERSION_TAB             UNAPIGEN.VC20_TABLE_TYPE;
P_ME_PLAUS_LOW_TAB               UNAPIGEN.FLOAT_TABLE_TYPE;
P_ME_PLAUS_HIGH_TAB              UNAPIGEN.FLOAT_TABLE_TYPE;
P_ME_WINSIZE_X_TAB               UNAPIGEN.NUM_TABLE_TYPE;
P_ME_WINSIZE_Y_TAB               UNAPIGEN.NUM_TABLE_TYPE;
P_ME_ME_CLASS_TAB                UNAPIGEN.VC2_TABLE_TYPE;
P_ME_LOG_HS_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
P_ME_LOG_HS_DETAILS_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_ME_LC_TAB                      UNAPIGEN.VC2_TABLE_TYPE;
P_ME_LC_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_ME_MODIFY_FLAG_TAB             UNAPIGEN.NUM_TABLE_TYPE;
P_ME_MODIFY_REASON               VARCHAR2(255);
P_ME_REANALYSIS_TAB              UNAPIGEN.NUM_TABLE_TYPE;
P_ME_SS_TAB                      UNAPIGEN.VC2_TABLE_TYPE;
P_ME_ADD_COMMENT_TAB             UNAPIGEN.VC255_TABLE_TYPE;

P_ME_DESCRIPTION_MODTAB          BOOLEAN_TABLE_TYPE;
P_ME_VALUE_F_MODTAB              BOOLEAN_TABLE_TYPE;
P_ME_VALUE_S_MODTAB              BOOLEAN_TABLE_TYPE;
P_ME_UNIT_MODTAB                 BOOLEAN_TABLE_TYPE;
P_ME_MANUALLY_ENTERED_MODTAB     BOOLEAN_TABLE_TYPE;
P_ME_EXEC_START_DATE_MODTAB      BOOLEAN_TABLE_TYPE;
P_ME_EXEC_END_DATE_MODTAB        BOOLEAN_TABLE_TYPE;
P_ME_EXECUTOR_MODTAB             BOOLEAN_TABLE_TYPE;
P_ME_EQ_MODTAB                   BOOLEAN_TABLE_TYPE;
P_ME_LAB_MODTAB                  BOOLEAN_TABLE_TYPE;
P_ME_SS_MODTAB                   BOOLEAN_TABLE_TYPE;

/* LOCAL VARIABLES FOR [cell] section */
P_CE_SC                          VARCHAR2(20);
P_CE_PG                          VARCHAR2(20);
P_CE_PGNAME                      VARCHAR2(20); --will contain the variable name used like pg, pg.pg , pg.description, pg[],...
P_CE_PGDESCRIPTION               VARCHAR2(40); --will contain the pg description when pg.description syntax is used
P_CE_PP_KEY1                     VARCHAR2(20);
P_CE_PP_KEY2                     VARCHAR2(20);
P_CE_PP_KEY3                     VARCHAR2(20);
P_CE_PP_KEY4                     VARCHAR2(20);
P_CE_PP_KEY5                     VARCHAR2(20);
P_CE_PP_VERSION                  VARCHAR2(20);
P_CE_PGNODE                      NUMBER;
P_CE_PA                          VARCHAR2(20);
P_CE_PANAME                      VARCHAR2(20); --will contain the variable name used like pa, pa.pa , pa.description, pa[],...
P_CE_PADESCRIPTION               VARCHAR2(40); --will contain the pa description when pa.description syntax is used
P_CE_PANODE                      NUMBER;
P_CE_PR_VERSION                  VARCHAR2(20);

P_CE_ME                          VARCHAR2(20);
P_CE_MENAME                      VARCHAR2(20); --will contain the variable name used like me, me.me , me.description, me[],...
P_CE_MEDESCRIPTION               VARCHAR2(40); --will contain the me description when me.description syntax is used
P_CE_MENODE                      NUMBER;
P_CE_MT_VERSION                  VARCHAR2(20);

P_CE_NR_OF_ROWS                  NUMBER;

P_CE_COMPLETED                   CHAR(1);
P_CE_SC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_CE_PG_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_CE_PGNODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
P_CE_PA_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_CE_PANODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
P_CE_ME_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_CE_MENODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
P_CE_CE_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_CE_CENODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;

P_CE_CENAME_TAB                  UNAPIGEN.VC20_TABLE_TYPE; --will contain the variable name used like cell, cell.cell , cell.description, cell[],...
P_CE_CEDESCRIPTION_TAB           UNAPIGEN.VC40_TABLE_TYPE; --will contain the cell description when cell.description syntax is used

P_CE_DSP_TITLE_TAB               UNAPIGEN.VC40_TABLE_TYPE;
P_CE_VALUE_F_TAB                 UNAPIGEN.FLOAT_TABLE_TYPE;
P_CE_VALUE_S_TAB                 UNAPIGEN.VC40_TABLE_TYPE;
P_CE_CELL_TP_TAB                 UNAPIGEN.CHAR1_TABLE_TYPE;
P_CE_POS_X_TAB                   UNAPIGEN.NUM_TABLE_TYPE;
P_CE_POS_Y_TAB                   UNAPIGEN.NUM_TABLE_TYPE;
P_CE_ALIGN_TAB                   UNAPIGEN.CHAR1_TABLE_TYPE;
P_CE_WINSIZE_X_TAB               UNAPIGEN.NUM_TABLE_TYPE;
P_CE_WINSIZE_Y_TAB               UNAPIGEN.NUM_TABLE_TYPE;
P_CE_IS_PROTECTED_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
P_CE_MANDATORY_TAB               UNAPIGEN.CHAR1_TABLE_TYPE;
P_CE_HIDDEN_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
P_CE_UNIT_TAB                    UNAPIGEN.VC20_TABLE_TYPE;
P_CE_FORMAT_TAB                  UNAPIGEN.VC40_TABLE_TYPE;
P_CE_EQ_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_CE_EQ_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_CE_COMPONENT_TAB               UNAPIGEN.VC20_TABLE_TYPE;
P_CE_CALC_TP_TAB                 UNAPIGEN.CHAR1_TABLE_TYPE;
P_CE_CALC_FORMULA_TAB            UNAPIGEN.VC2000_TABLE_TYPE;
P_CE_VALID_CF_TAB                UNAPIGEN.VC20_TABLE_TYPE;
P_CE_MAX_X_TAB                   UNAPIGEN.NUM_TABLE_TYPE;
P_CE_MAX_Y_TAB                   UNAPIGEN.NUM_TABLE_TYPE;
P_CE_MULTI_SELECT_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
P_CE_MODIFY_FLAG_TAB             UNAPIGEN.NUM_TABLE_TYPE;
P_CE_MODIFY_REASON               VARCHAR2(255);
P_CE_REANALYSIS_TAB              UNAPIGEN.NUM_TABLE_TYPE;

P_CE_DSP_TITLE_MODTAB            BOOLEAN_TABLE_TYPE;
P_CE_VALUE_F_MODTAB              BOOLEAN_TABLE_TYPE;
P_CE_VALUE_S_MODTAB              BOOLEAN_TABLE_TYPE;
P_CE_EQ_MODTAB                   BOOLEAN_TABLE_TYPE;
P_CE_UNIT_MODTAB                 BOOLEAN_TABLE_TYPE;

/* LOCAL VARIABLES FOR [cell table] section */
P_CET_SC                         VARCHAR2(20);
P_CET_PG                         VARCHAR2(20);
P_CET_PGNAME                     VARCHAR2(20); --will contain the variable name used like pg, pg.pg , pg.description, pg[],...
P_CET_PGDESCRIPTION              VARCHAR2(40); --will contain the pg description when pg.description syntax is used
P_CET_PP_KEY1                    VARCHAR2(20);
P_CET_PP_KEY2                    VARCHAR2(20);
P_CET_PP_KEY3                    VARCHAR2(20);
P_CET_PP_KEY4                    VARCHAR2(20);
P_CET_PP_KEY5                    VARCHAR2(20);
P_CET_PP_VERSION                 VARCHAR2(20);
P_CET_PGNODE                     NUMBER;
P_CET_PA                         VARCHAR2(20);
P_CET_PANAME                     VARCHAR2(20); --will contain the variable name used like pa, pa.pa , pa.description, pa[],...
P_CET_PADESCRIPTION              VARCHAR2(40); --will contain the pa description when pa.description syntax is used
P_CET_PANODE                     NUMBER;
P_CET_PR_VERSION                 VARCHAR2(20);

P_CET_ME                         VARCHAR2(20);
P_CET_MENAME                     VARCHAR2(20); --will contain the variable name used like me, me.me , me.description, me[],...
P_CET_MEDESCRIPTION              VARCHAR2(40); --will contain the me description when me.description syntax is used
P_CET_MENODE                     NUMBER;
P_CET_REANALYSIS                 NUMBER(3);
P_CET_MT_VERSION                 VARCHAR2(20);

P_CET_NR_OF_ROWS                 NUMBER;

P_CET_CE                         VARCHAR2(20);
P_CET_CE_TAB                     UNAPIGEN.VC20_TABLE_TYPE;

P_CET_CENAME                     VARCHAR2(20); --will contain the variable name used like cell, cell.cell , cell.description, cell[],...
P_CET_CEDESCRIPTION              VARCHAR2(40); --will contain the cell description when cell.description syntax is used

P_CET_INDEX_X_TAB                UNAPIGEN.NUM_TABLE_TYPE;
P_CET_INDEX_Y_TAB                UNAPIGEN.NUM_TABLE_TYPE;

P_CET_VALUE_F_TAB                UNAPIGEN.FLOAT_TABLE_TYPE;
P_CET_VALUE_S_TAB                UNAPIGEN.VC40_TABLE_TYPE;
P_CET_SELECTED_TAB               UNAPIGEN.CHAR1_TABLE_TYPE;
P_CET_MODIFY_FLAG_TAB            UNAPIGEN.NUM_TABLE_TYPE;
P_CET_MODIFY_REASON              VARCHAR2(255);

P_CET_VALUE_F_MODTAB             BOOLEAN_TABLE_TYPE;
P_CET_VALUE_S_MODTAB             BOOLEAN_TABLE_TYPE;

/* LOCAL VARIABLES FOR [ic] section */
P_IC_SC                          VARCHAR2(20);
P_IC_NR_OF_ROWS                  NUMBER;
P_IC_MODIFY_REASON               VARCHAR2(255);

P_IC_SC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_IC_IC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;

P_IC_ICNAME_TAB                  UNAPIGEN.VC20_TABLE_TYPE; --will contain the variable name used like ic, ic.ic , ic.description, ic[],...
P_IC_ICDESCRIPTION_TAB           UNAPIGEN.VC40_TABLE_TYPE; --will contain the ic description when ic.description syntax is used

P_IC_ICNODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
P_IC_IP_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_IC_DESCRIPTION_TAB             UNAPIGEN.VC40_TABLE_TYPE;
P_IC_WINSIZE_X_TAB               UNAPIGEN.NUM_TABLE_TYPE;
P_IC_WINSIZE_Y_TAB               UNAPIGEN.NUM_TABLE_TYPE;
P_IC_IS_PROTECTED_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
P_IC_HIDDEN_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
P_IC_MANUALLY_ADDED_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_IC_NEXT_II_TAB                 UNAPIGEN.VC20_TABLE_TYPE;
P_IC_IC_CLASS_TAB                UNAPIGEN.VC2_TABLE_TYPE;
P_IC_LOG_HS_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
P_IC_LOG_HS_DETAILS_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_IC_LC_TAB                      UNAPIGEN.VC2_TABLE_TYPE;
P_IC_LC_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_IC_MODIFY_FLAG_TAB             UNAPIGEN.NUM_TABLE_TYPE;
P_IC_ADD_COMMENT_TAB             UNAPIGEN.VC255_TABLE_TYPE;
P_IC_SS_TAB                      UNAPIGEN.VC2_TABLE_TYPE;

/* LOCAL VARIABLES FOR [ii] section */
P_II_SC                          VARCHAR2(20);
P_II_IC                          VARCHAR2(20);
P_II_ICNAME                      VARCHAR2(20); --will contain the variable name used like ic, ic.ic , ic.description, ic[],...
P_II_ICDESCRIPTION               VARCHAR2(40); --will contain the ic description when ic.description syntax is used
P_II_ICNODE                      NUMBER;
P_II_IP_VERSION                  VARCHAR2(20);
P_II_NR_OF_ROWS                  NUMBER;
P_II_USE_SAVESCIIVALUE           BOOLEAN DEFAULT FALSE;

P_II_SC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_II_IC_TAB                      UNAPIGEN.VC20_TABLE_TYPE;
P_II_ICNODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
P_II_II_TAB                      UNAPIGEN.VC20_TABLE_TYPE;

P_II_IINAME_TAB                  UNAPIGEN.VC20_TABLE_TYPE; --will contain the variable name used like ii, ii.ii , ii.description, ii[],...
P_II_IIDESCRIPTION_TAB           UNAPIGEN.VC40_TABLE_TYPE; --will contain the ii description when ii.description syntax is used

P_II_IINODE_TAB                  UNAPIGEN.LONG_TABLE_TYPE;
P_II_IE_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_II_IIVALUE_TAB                 UNAPIGEN.VC2000_TABLE_TYPE;
P_II_POS_X_TAB                   UNAPIGEN.NUM_TABLE_TYPE;
P_II_POS_Y_TAB                   UNAPIGEN.NUM_TABLE_TYPE;
P_II_IS_PROTECTED_TAB            UNAPIGEN.CHAR1_TABLE_TYPE;
P_II_MANDATORY_TAB               UNAPIGEN.CHAR1_TABLE_TYPE;
P_II_HIDDEN_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
P_II_DSP_TITLE_TAB               UNAPIGEN.VC40_TABLE_TYPE;
P_II_DSP_LEN_TAB                 UNAPIGEN.NUM_TABLE_TYPE;
P_II_DSP_TP_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
P_II_DSP_ROWS_TAB                UNAPIGEN.NUM_TABLE_TYPE;
P_II_II_CLASS_TAB                UNAPIGEN.VC2_TABLE_TYPE;
P_II_LOG_HS_TAB                  UNAPIGEN.CHAR1_TABLE_TYPE;
P_II_LOG_HS_DETAILS_TAB          UNAPIGEN.CHAR1_TABLE_TYPE;
P_II_LC_TAB                      UNAPIGEN.VC2_TABLE_TYPE;
P_II_LC_VERSION_TAB              UNAPIGEN.VC20_TABLE_TYPE;
P_II_MODIFY_FLAG_TAB             UNAPIGEN.NUM_TABLE_TYPE;
P_II_MODIFY_REASON               VARCHAR2(255);
P_II_SS_TAB                      UNAPIGEN.VC2_TABLE_TYPE;

P_II_IIVALUE_MODTAB              BOOLEAN_TABLE_TYPE;

/* LOCAL VARIABLES FOR [switchuser] section */
--assignment variables
P_SU_CLIENT_ID                   VARCHAR2(20); --optional
P_SU_US                          VARCHAR2(20); --mandatory
P_SU_PASSWORD                    VARCHAR2(20); --optional
P_SU_APPLIC                      VARCHAR2(8);  --optional
P_SU_NUMERIC_CHARACTERS          VARCHAR2(2);  --optional
P_SU_DATE_FORMAT                 VARCHAR2(255);--optional
P_SU_UP                          NUMBER(5);    --optional

--when the user has been switched, in Unilink
--the user context must be restored for the next files to be processed
--that might not contain a user section
P_SU_USER_SWITCHED               BOOLEAN DEFAULT FALSE;
P_SU_JOB_CLIENT_ID               VARCHAR2(20);
P_SU_JOB_US                      VARCHAR2(20);
P_SU_JOB_USER_DESCRIPTION        VARCHAR2(40);
P_SU_JOB_PASSWORD                VARCHAR2(20);
P_SU_JOB_APPLIC                  VARCHAR2(8);
P_SU_JOB_NUMERIC_CHARACTERS      VARCHAR2(2);
P_SU_JOB_DATE_FORMAT             VARCHAR2(255);
P_SU_JOB_UP                      NUMBER(5);
P_SU_JOB_DD                      VARCHAR2(3);

FUNCTION Parser                /* INTERNAL */
RETURN NUMBER;

PROCEDURE UCONWriteToLog            /* INTERNAL */
(a_severity IN NUMBER,           /* NUM_TYPE */
 a_text_line   IN VARCHAR2);     /* VC2000_TYPE */

FUNCTION FinishTransaction       /* INTERNAL */
RETURN NUMBER;

END uniconnect;
