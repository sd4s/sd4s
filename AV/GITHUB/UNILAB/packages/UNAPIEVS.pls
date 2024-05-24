create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapievs AS

P_NR_OF_SERVICES   NUMBER;
P_EVSERVICE        UNAPIGEN.VC20_TABLE_TYPE;

li_services_loaded INTEGER;

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION RegisterEventService
(a_evservice_name            IN     VARCHAR2)                    /* VC20_TYPE */
RETURN NUMBER;

FUNCTION UnRegisterEventService
(a_evservice_name            IN     VARCHAR2)                    /* VC20_TYPE */
RETURN NUMBER;

FUNCTION LoadEventServiceList
RETURN NUMBER;

FUNCTION GetEvents
(a_evservice_name            IN     VARCHAR2,                    /* VC20_TYPE */
 a_tr_seq_tab                OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_ev_seq_tab                OUT    UNAPIGEN.NUM_TABLE_TYPE,     /* NUM_TABLE_TYPE + INDICATOR */
 a_created_on_tab            OUT    UNAPIGEN.DATE_TABLE_TYPE,    /* DATE_TABLE_TYPE */
 a_client_id_tab             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_applic_tab                OUT    UNAPIGEN.VC8_TABLE_TYPE,     /* VC8_TABLE_TYPE */
 a_dbapi_name_tab            OUT    UNAPIGEN.VC40_TABLE_TYPE,    /* VC40_TABLE_TYPE */
 a_object_tp_tab             OUT    UNAPIGEN.VC4_TABLE_TYPE,     /* VC4_TABLE_TYPE */
 a_object_id_tab             OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_object_lc_tab             OUT    UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_object_lc_version_tab     OUT    UNAPIGEN.VC20_TABLE_TYPE,    /* VC20_TABLE_TYPE */
 a_object_ss_tab             OUT    UNAPIGEN.VC2_TABLE_TYPE,     /* VC2_TABLE_TYPE */
 a_ev_tp_tab                 OUT    UNAPIGEN.VC60_TABLE_TYPE,    /* VC60_TABLE_TYPE */
 a_username_tab              OUT    UNAPIGEN.VC30_TABLE_TYPE,    /* VC30_TABLE_TYPE */
 a_ev_details_tab            OUT    UNAPIGEN.VC255_TABLE_TYPE,   /* VC255_TABLE_TYPE */
 a_nr_of_rows                IN OUT  NUMBER)                     /* NUM_TYPE */
RETURN NUMBER;

FUNCTION DeleteHandledEvents
(a_evservice_name            IN     VARCHAR2)                    /* VC20_TYPE */
RETURN NUMBER;

END unapievs;