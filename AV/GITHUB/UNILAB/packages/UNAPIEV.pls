create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapiev AS

/*
l_ev_nr_of_rows          INTEGER;
l_ev_tr_seq               UNAPIGEN.NUM_TABLE_TYPE;
l_ev_ev_seq              UNAPIGEN.NUM_TABLE_TYPE;
l_ev_created_on          UNAPIGEN.DATE_TABLE_TYPE;
l_ev_created_on_tz       UNAPIGEN.DATE_TABLE_TYPE;
l_ev_client_id           UNAPIGEN.VC20_TABLE_TYPE;
l_ev_applic              UNAPIGEN.VC8_TABLE_TYPE;
l_ev_dbapi_name          UNAPIGEN.VC40_TABLE_TYPE;
l_ev_evmgr_name          UNAPIGEN.VC20_TABLE_TYPE;
l_ev_object_tp           UNAPIGEN.VC4_TABLE_TYPE;
l_ev_object_id           UNAPIGEN.VC20_TABLE_TYPE;
l_ev_object_lc           UNAPIGEN.VC2_TABLE_TYPE;
l_ev_object_lc_version   UNAPIGEN.VC20_TABLE_TYPE;
l_ev_object_ss           UNAPIGEN.VC2_TABLE_TYPE;
l_ev_ev_tp               UNAPIGEN.VC60_TABLE_TYPE;
l_ev_username            UNAPIGEN.VC30_TABLE_TYPE;
l_ev_ev_details          UNAPIGEN.VC2000_TABLE_TYPE;
*/
l_ev_tab                 uoevlist := uoevlist();

CURSOR c_evrules IS
   SELECT *
   FROM utevrules
   ORDER BY rule_nr;

P_EV_REC                   utev%ROWTYPE;
P_EVRULE_REC               c_evrules%ROWTYPE;
P_EV_OUTPUT_ON             BOOLEAN;
P_EV_MAXRECURSIVELEVEL     INTEGER DEFAULT 20;
P_EV_RECURSIVELEVEL        INTEGER;
P_RETRIESWHENINTRANSITION  INTEGER DEFAULT 300; --maximum number of retries before returning DBERR_INTRANSITION
P_INTERVALWHENINTRANSITION NUMBER  DEFAULT 1/5; --interval between 2 retries in seconds (lowest precision is 0.01)
                                               --the smallest interval can be entered in hundredths of a second
                                               --default used 200 ms.
P_CURRENT_TXN_SEQ          NUMBER;
P_WAITFORALERTTIMEOUT      INTEGER DEFAULT 120; --timeout of event manager for DBMS_ALERT.WAITONE
                                                --default 120 seconds
                                                --can be set to a lower value but pay attention to the workload on system
P_EV_MGR_SESSION           BOOLEAN DEFAULT FALSE;
P_CLIENT_EVMGR_USED        VARCHAR2(3);
P_RQ                       VARCHAR2(20);
P_OLD_RQ                   VARCHAR2(20);
P_SC                       VARCHAR2(20);
P_CH                       VARCHAR2(20);
P_WS                       VARCHAR2(20);
P_ROWNR                    NUMBER(4);
P_SC_FROM                  VARCHAR2(20);
P_PG                       VARCHAR2(20);
P_PA                       VARCHAR2(20);
P_ME                       VARCHAR2(20);
P_REANALYSIS               NUMBER(3);
P_IC                       VARCHAR2(20);
P_II                       VARCHAR2(20);
P_PGNODE                   NUMBER(9);
P_PANODE                   NUMBER(9);
P_MENODE                   NUMBER(9);
P_ICNODE                   NUMBER(9);
P_IINODE                   NUMBER(9);
P_CSNODE                   NUMBER(9);
P_TPNODE                   NUMBER(9);
P_SS_TO                    VARCHAR2(2);
P_SS_FROM                  VARCHAR2(2);
P_LC_SS_FROM               VARCHAR2(2);
P_TR_NO                    NUMBER(3);
P_NEW_VALUE                VARCHAR2(40);
P_OLD_VALUE                VARCHAR2(40);
P_TD_INFO                  NUMBER(3);
P_TD_INFO_UNIT             VARCHAR2(20);
P_ST                       VARCHAR2(20);
P_ST_VERSION               VARCHAR2(20);
P_RT                       VARCHAR2(20);
P_RT_VERSION               VARCHAR2(20);
P_WT                       VARCHAR2(20);
P_WT_VERSION               VARCHAR2(20);
P_CY                       VARCHAR2(20);
P_CY_VERSION               VARCHAR2(20);
P_PT                       VARCHAR2(20);
P_PT_VERSION               VARCHAR2(20);
P_SD                       VARCHAR2(20);
P_CF                       VARCHAR2(20);
P_EQ                       VARCHAR2(20);
P_LAB                      VARCHAR2(20);
P_CT                       VARCHAR2(20);
P_OLD_CA_WARN_LEVEL        VARCHAR2(1);
P_NEW_CA_WARN_LEVEL        VARCHAR2(1);
P_CA                       VARCHAR2(20);
P_MT                       VARCHAR2(20);
P_MT_VERSION               VARCHAR2(20);
P_PR_VERSION               VARCHAR2(20);
P_PP_VERSION               VARCHAR2(20);
P_IP_VERSION               VARCHAR2(20);
P_IE_VERSION               VARCHAR2(20);
P_PP_KEY1                  VARCHAR2(20);
P_PP_KEY2                  VARCHAR2(20);
P_PP_KEY3                  VARCHAR2(20);
P_PP_KEY4                  VARCHAR2(20);
P_PP_KEY5                  VARCHAR2(20);
P_EQSC_SC                  VARCHAR2(20);
P_EQSC_EQ                  VARCHAR2(20);
P_EQSC_LAB                 VARCHAR2(20);
P_EQSC_EVALEQLC            BOOLEAN;
P_STOPLCEVALUATION         BOOLEAN;
P_STOPEVMGR                BOOLEAN;
P_NR_RESULTS               INTEGER;
P_SDSCTPREACHED            VARCHAR2(40);
P_SCGK_PREVIOUS_SC         VARCHAR2(20);
P_WSGK_PREVIOUS_WS         VARCHAR2(20);
P_SCMEGK_PREVIOUS_ME       VARCHAR2(20);
P_SCMEGK_PREVIOUS_DETAILS  VARCHAR2(255);
P_CHGK_PREVIOUS_CH         VARCHAR2(20);
l_subevents                INTEGER;
l_ev_session               VARCHAR2(3);
l_obj_cursor               INTEGER;
P_LOG_HS                   BOOLEAN;
P_LOG_HS_DETAILS           BOOLEAN;
P_VALID_SQC                CHAR(1);
P_VERSION                  VARCHAR2(20);
P_OLD_CURRENT_VERSION      VARCHAR2(20);
P_ALARMS_HANDLED           CHAR(1);
P_AF                       VARCHAR2(255);
P_POSTPONE_AF              INTEGER;
P_HS_SEQ                   INTEGER;
P_DC                       VARCHAR2(40);
P_DC_VERSION               VARCHAR2(20);
P_UPDATE_NEXT_CELL         CHAR(1);
P_UPDATE_ME_LAB            VARCHAR2(20);

P_EVMGRS_EV_IN_BULK        CHAR(1);
P_EVMGRS_POLLING_ON        CHAR(1);
P_EVMGRS_POLLINGINTERV     NUMBER;
P_EVMGRS_1QBYINSTANCE      CHAR(1);
P_EVMGRS_COLLECTSTAT       CHAR(1);

TYPE TRANSITION_OBJECT_TYPE IS RECORD(
   tp          VARCHAR2(4),
   id          VARCHAR2(20),
   lc          VARCHAR(2),
   lc_version  VARCHAR2(20),
   ss_from     VARCHAR2(2),
   ss_to       VARCHAR2(2),
   tr_no       NUMBER,
   lc_ss_from  VARCHAR2(2),
   ev_details  VARCHAR2(2000));
TYPE TRANSITION_OBJECT_TABLE_TYPE IS TABLE OF TRANSITION_OBJECT_TYPE INDEX BY BINARY_INTEGER;
P_EV_TR           TRANSITION_OBJECT_TABLE_TYPE;
P_EV_TR_COUNT     INTEGER;

--public record avilable for custom code in uncondition, unaction and unaccess
TYPE LC_TRANSITION IS RECORD(
   lc          VARCHAR(2),
   lc_version  VARCHAR2(20),
   ss_from     VARCHAR2(2),
   ss_to       VARCHAR2(2),
   tr_no       NUMBER,
   lc_ss_from  VARCHAR2(2));
P_LC_TR        LC_TRANSITION;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION AlertRegister
(a_alert_name          IN       VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION AlertRemove
(a_alert_name          IN       VARCHAR2)                  /* VC20_TYPE */
RETURN NUMBER;

FUNCTION AlertDelete
(a_alert_name          IN       VARCHAR2,                  /* VC20_TYPE */
 a_alert_data          IN       VARCHAR2)                  /* VC2000_TYPE */
RETURN NUMBER;

FUNCTION AlertSend
(a_alert_name          IN       VARCHAR2,                  /* VC20_TYPE */
 a_alert_data          IN       VARCHAR2)                  /* VC2000_TYPE */
RETURN NUMBER;

FUNCTION PrintScLabel
(a_sc                  IN       VARCHAR2,                  /* VC20_TYPE */
 a_printer             IN       VARCHAR2,                  /* VC255_TYPE */
 a_label_format        IN       VARCHAR2,                  /* VC20_TYPE */
 a_nr_of_labels        IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION PrintRqLabel
(a_rq                  IN       VARCHAR2,                  /* VC20_TYPE */
 a_printer             IN       VARCHAR2,                  /* VC255_TYPE */
 a_label_format        IN       VARCHAR2,                  /* VC20_TYPE */
 a_nr_of_labels        IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION PrintSdLabel
(a_sd                  IN       VARCHAR2,                  /* VC20_TYPE */
 a_printer             IN       VARCHAR2,                  /* VC255_TYPE */
 a_label_format        IN       VARCHAR2,                  /* VC20_TYPE */
 a_nr_of_labels        IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION AlertWaitAny
(a_alert_name          OUT      VARCHAR2,                  /* VC20_TYPE */
 a_alert_data          OUT      VARCHAR2,                  /* VC2000_TYPE */
 a_alert_status        OUT      NUMBER,                    /* NUM_TYPE */
 a_alert_wait_time     IN       NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteEvent                                       /* INTERNAL */
(a_ev_seq              IN       NUMBER,                    /* NUM_TYPE */
 a_created_on          IN       DATE,                      /* DATE_TYPE */
 a_evmgr_name          IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_tp           IN       VARCHAR2,                  /* VC4_TYPE */
 a_object_id           IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_lc           IN       VARCHAR2,                  /* VC2_TYPE */
 a_object_lc_version   IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_ss           IN       VARCHAR2,                  /* VC2_TYPE */
 a_ev_tp               IN       VARCHAR2)                  /* VC60_TYPE */
RETURN NUMBER;

FUNCTION InsertEvent                                       /* INTERNAL */
(a_api_name            IN       VARCHAR2,                  /* VC40_TYPE */
 a_evmgr_name          IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_tp           IN       VARCHAR2,                  /* VC4_TYPE */
 a_object_id           IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_lc           IN       VARCHAR2,                  /* VC2_TYPE */
 a_object_lc_version   IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_ss           IN       VARCHAR2,                  /* VC2_TYPE */
 a_ev_tp               IN       VARCHAR2,                  /* VC60_TYPE */
 a_ev_details          IN       VARCHAR2,                  /* VC255_TYPE */
 a_seq_nr              IN OUT   NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION InsertInfoFieldEvent                              /* INTERNAL */
(a_api_name            IN       VARCHAR2,                  /* VC40_TYPE */
 a_evmgr_name          IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_tp           IN       VARCHAR2,                  /* VC4_TYPE */
 a_object_id           IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_lc           IN       VARCHAR2,                  /* VC2_TYPE */
 a_object_lc_version   IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_ss           IN       VARCHAR2,                  /* VC2_TYPE */
 a_ev_tp               IN       VARCHAR2,                  /* VC60_TYPE */
 a_ev_details          IN       VARCHAR2,                  /* VC255_TYPE */
 a_seq_nr              IN OUT   NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION BroadcastEvent                                    /* INTERNAL */
(a_api_name            IN       VARCHAR2,                  /* VC40_TYPE */
 a_evmgr_name          IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_tp           IN       VARCHAR2,                  /* VC4_TYPE */
 a_object_id           IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_lc           IN       VARCHAR2,                  /* VC2_TYPE */
 a_object_lc_version   IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_ss           IN       VARCHAR2,                  /* VC2_TYPE */
 a_ev_tp               IN       VARCHAR2,                  /* VC60_TYPE */
 a_ev_details          IN       VARCHAR2,                  /* VC255_TYPE */
 a_seq_nr              IN OUT   NUMBER)                    /* NUM_TYPE */
RETURN NUMBER;

FUNCTION BroadcastEvent                                /* INTERNAL */
(a_api_name                IN       VARCHAR2,          /* VC40_TYPE */
 a_evmgr_name              IN       VARCHAR2,          /* VC20_TYPE */
 a_object_tp               IN       VARCHAR2,          /* VC4_TYPE */
 a_object_id               IN       VARCHAR2,          /* VC20_TYPE */
 a_object_lc               IN       VARCHAR2,          /* VC2_TYPE */
 a_object_lc_version       IN       VARCHAR2,          /* VC20_TYPE */
 a_object_ss               IN       VARCHAR2,          /* VC2_TYPE */
 a_ev_tp                   IN       VARCHAR2,          /* VC60_TYPE */
 a_ev_details              IN       VARCHAR2,          /* VC255_TYPE */
 a_wakeupalsostudyeventmgr IN       CHAR,              /* CHAR1_TYPE */
 a_seq_nr                  IN OUT   NUMBER)            /* NUM_TYPE */
RETURN NUMBER;

FUNCTION InsertTimedEvent                                  /* INTERNAL */
(a_api_name            IN       VARCHAR2,                  /* VC40_TYPE */
 a_evmgr_name          IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_tp           IN       VARCHAR2,                  /* VC4_TYPE */
 a_object_id           IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_lc           IN       VARCHAR2,                  /* VC2_TYPE */
 a_object_lc_version   IN       VARCHAR2,                  /* VC20_TYPE */
 a_object_ss           IN       VARCHAR2,                  /* VC2_TYPE */
 a_ev_tp               IN       VARCHAR2,                  /* VC60_TYPE */
 a_ev_details          IN       VARCHAR2,                  /* VC255_TYPE */
 a_seq_nr              IN OUT   NUMBER,                    /* NUM_TYPE */
 a_execute_at          IN       DATE)                      /* DATE_TYPE */
RETURN NUMBER;

FUNCTION UpdateTimedEvent                                  /* INTERNAL */
(a_object_tp           IN       VARCHAR2,                  /* VC4_TYPE */
 a_object_id           IN       VARCHAR2,                  /* VC20_TYPE */
 a_ev_tp               IN       VARCHAR2,                  /* VC60_TYPE */
 a_ev_details          IN       VARCHAR2,                  /* VC255_TYPE */
 a_execute_at          IN       DATE)                      /* DATE_TYPE */
RETURN NUMBER;

FUNCTION DeleteTimedEvent                                  /* INTERNAL */
(a_object_tp           IN       VARCHAR2,                  /* VC4_TYPE */
 a_object_id           IN       VARCHAR2,                  /* VC20_TYPE */
 a_ev_tp               IN       VARCHAR2,                  /* VC60_TYPE */
 a_ev_details          IN       VARCHAR2)                  /* VC255_TYPE */
RETURN NUMBER;

FUNCTION SaveClient                                         /* INTERNAL */
(a_client_id           IN       VARCHAR2,                   /* VC20_TYPE */
 a_evmgr_name          IN       VARCHAR2,                   /* VC20_TYPE */
 a_evmgr_tp            IN       CHAR,                       /* CHAR1_TYPE */
 a_evmgr_public        IN       CHAR)                       /* CHAR1_TYPE */
RETURN NUMBER ;

FUNCTION EvalLifeCycle                                     /* INTERNAL */
(a_ss_to      IN OUT VARCHAR2,                             /* VC2_TYPE */
 a_tr_no      OUT    NUMBER)                               /* NUM_TYPE */
RETURN NUMBER;

FUNCTION ExecuteTrActions                                   /* INTERNAL */
(a_ss_from       IN VARCHAR2,                               /* VC2_TYPE */
 a_ss_to         IN VARCHAR2,                               /* VC2_TYPE */
 a_tr_no         IN NUMBER,                                 /* NUM_TYPE */
 a_transition_ok IN NUMBER)                                 /* NUM_TYPE */
RETURN NUMBER;

FUNCTION ExecuteAction                                      /* INTERNAL */
(a_af            IN VARCHAR2)                               /* VC255_TYPE */
RETURN NUMBER;

PROCEDURE ParseEventDetails                                 /* INTERNAL */
(a_ev_details          IN        VARCHAR2,                  /* VC255_TYPE */
 a_qualifier_table     OUT       UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_qualifier_val_table OUT       UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_nr_of_rows          OUT       NUMBER)                    /* NUM_TYPE */
;

PROCEDURE FindDetail                                         /* INTERNAL */
(a_qualifier_table      IN        UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_qualifier_val_table  IN        UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_qualifier_to_find    IN        VARCHAR2,                  /* VC255_TABLE_TYPE */
 a_qualifier_val_found  OUT       VARCHAR2,                  /* VC255_TABLE_TYPE */
 a_nr_of_rows           IN        NUMBER)                    /* NUM_TYPE */
;

PROCEDURE FindDetail                                         /* INTERNAL */
(a_qualifier_table      IN        UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_qualifier_val_table  IN        UNAPIGEN.VC255_TABLE_TYPE, /* VC255_TABLE_TYPE */
 a_qualifier_to_find    IN        VARCHAR2,                  /* VC255_TABLE_TYPE */
 a_qualifier_val_found  OUT       NUMBER,                    /* NUM_TABLE_TYPE */
 a_nr_of_rows           IN        NUMBER)                    /* NUM_TYPE */
;

PROCEDURE EvaluateEventDetails                               /* INTERNAL */
(a_ev_seq               IN        NUMBER)                    /* NUM_TYPE */
;

PROCEDURE UpdateObjectRecord                     /* INTERNAL */
(a_ss_to IN VARCHAR2);                           /* VC2_TYPE */

PROCEDURE UpdateOpalObjectRecord                 /* INTERNAL */
(a_ss_to           IN VARCHAR2);                 /* VC2_TYPE */

PROCEDURE TimedEventmgr;                         /* INTERNAL */

PROCEDURE EventManagerJob                        /* INTERNAL */
(a_evmgr_name IN VARCHAR2,
 a_ev_session IN NUMBER);

FUNCTION StartTimedEventmgr                      /* INTERNAL */
RETURN NUMBER;

FUNCTION StopTimedEventmgr                       /* INTERNAL */
RETURN NUMBER;

FUNCTION StartEventmgr                           /* INTERNAL */
(a_evmgr_name    IN    VARCHAR2,
 a_how_many      IN    NUMBER)
RETURN NUMBER;

FUNCTION StartEventmgr                           /* INTERNAL */
(a_evmgr_name    IN    VARCHAR2,
 a_how_many      IN    NUMBER,
 a_startref_nr   IN    NUMBER)
RETURN NUMBER;

FUNCTION StopEventmgr                            /* INTERNAL */
(a_evmgr_name    IN    VARCHAR2)
RETURN NUMBER;

FUNCTION IsEventManagerRunning                   /* INTERNAL */
(a_evmgr_name    IN    VARCHAR2)
RETURN NUMBER;

--FUNCTION AssignWorkList                          /* INTERNAL */
--(a_ss_to           IN VARCHAR2)                  /* VC2_TYPE */
--RETURN NUMBER;

FUNCTION StartAllMgrs                            /* INTERNAL */
RETURN NUMBER;

FUNCTION StopAllMgrs                             /* INTERNAL */
RETURN NUMBER;

FUNCTION CreateDefaultServiceLayer                             /* INTERNAL */
RETURN NUMBER;

FUNCTION DropDefaultServiceLayer                             /* INTERNAL */
RETURN NUMBER;

FUNCTION CreateEventManagerQueues
(a_nr_of_instances          IN        NUMBER)         /* NUM_TYPE */
RETURN NUMBER;

FUNCTION CopyAssignFreq                               /* INTERNAL */
(a_object_tp                IN        VARCHAR2,       /* VC4_TYPE */
 a_object_id                IN        VARCHAR2,       /* VC20_TYPE */
 a_object_old_version       IN        VARCHAR2,       /* VC20_TYPE */
 a_object_new_version       IN        VARCHAR2)       /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CopyPpAssignFreq                               /* INTERNAL */
(a_pp                       IN        VARCHAR2,       /* VC20_TYPE */
 a_pp_old_version           IN        VARCHAR2,       /* VC20_TYPE */
 a_pp_new_version           IN        VARCHAR2,       /* VC20_TYPE */
 a_pp_key1                  IN        VARCHAR2,       /* VC20_TYPE */
 a_pp_key2                  IN        VARCHAR2,       /* VC20_TYPE */
 a_pp_key3                  IN        VARCHAR2,       /* VC20_TYPE */
 a_pp_key4                  IN        VARCHAR2,       /* VC20_TYPE */
 a_pp_key5                  IN        VARCHAR2)       /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CleanStBasedAssignFreq                       /* INTERNAL */
(a_object_id                IN        VARCHAR2,       /* VC20_TYPE */
 a_object_old_version       IN        VARCHAR2)       /* VC20_TYPE */
RETURN NUMBER;

FUNCTION EvaluateEventRules                           /* INTERNAL */
(a_rules_loaded             IN OUT    CHAR)           /* CHAR1_TYPE */
RETURN NUMBER;

FUNCTION MoveEventsFromInactiveQueue
(a_inactivated_instance_nr     IN        NUMBER,         /* NUM_TYPE */
 a_handling_instance_nr        IN        NUMBER)         /* NUM_TYPE */
RETURN NUMBER;

FUNCTION HandleEventsFromInactiveQueue
(a_evmgr_name                  IN        VARCHAR2,       /* VC40_TYPE */
 a_inactive_instance_name      IN        VARCHAR2,       /* VC40_TYPE */
 a_target_instance_name        IN        VARCHAR2)       /* VC40_TYPE */
RETURN NUMBER;

FUNCTION HandleEventsFromInactiveQueue
(a_evmgr_name                  IN        VARCHAR2,       /* VC40_TYPE */
 a_inactivated_instance_nr     IN        NUMBER,         /* NUM_TYPE */
 a_handling_instance_nr        IN        NUMBER)         /* NUM_TYPE */
RETURN NUMBER;

FUNCTION SQLTranslatedJobInterval
(a_amount                      IN        VARCHAR2,
 a_time_unit                   IN        VARCHAR2)
RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(SQLTranslatedJobInterval, WNDS, WNPS);

FUNCTION SQLTranslatedJobInterval
(a_amount                      IN        NUMBER,
 a_time_unit                   IN        VARCHAR2)
RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(SQLTranslatedJobInterval, WNDS, WNPS);


CURSOR l_alert_seq_cursor (a_alert_seq IN NUMBER) IS
   SELECT MIN(alert_seq)
   FROM uvclientalerts
   WHERE alert_seq >= a_alert_seq;

CURSOR l_client_alerts_cursor (a_alert_seq IN NUMBER) IS
   SELECT alert_name, alert_data
   FROM uvclientalerts
   WHERE alert_seq = a_alert_seq;

--Cursor for event manager settings
CURSOR c_event_manager_settings IS
SELECT
   NVL(MAX(DECODE(setting_name, 'EVMGRS_EV_IN_BULK', setting_value)),'1') EVMGRS_EV_IN_BULK,
   NVL(MAX(DECODE(setting_name, 'EVMGRS_POLLING_ON', setting_value)),'0') EVMGRS_POLLING_ON,
   NVL(MAX(DECODE(setting_name, 'EVMGRS_POLLINGINTERV', setting_value)), '450') EVMGRS_POLLINGINTERV,
   NVL(MAX(DECODE(setting_name, 'EVMGRS_1QBYINSTANCE', setting_value)),'0') EVMGRS_1QBYINSTANCE,
   NVL(MAX(DECODE(setting_name, 'EVMGRS_COLLECTSTAT', setting_value)),'0') EVMGRS_COLLECTSTAT,
   SYS_CONTEXT ('USERENV', 'INSTANCE') SESSIONINSTANCENR
FROM utsystem
WHERE setting_name IN ('EVMGRS_EV_IN_BULK','EVMGRS_POLLING_ON','EVMGRS_POLLINGINTERV','EVMGRS_1QBYINSTANCE','EVMGRS_COLLECTSTAT');

END unapiev;