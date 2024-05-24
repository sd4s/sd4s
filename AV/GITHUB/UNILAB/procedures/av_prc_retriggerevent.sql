--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure RETRIGGEREVENT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."RETRIGGEREVENT" 
(
  a_tr_seq IN NUMBER,
  a_ev_seq IN NUMBER DEFAULT NULL
) AS 
    l_client_id      VARCHAR2(20);
    l_username       VARCHAR2(20);
    l_applic         VARCHAR2(8);
    l_numeric_chars  VARCHAR2(2);
    l_date_format    VARCHAR2(255);
    l_up             NUMBER;
    l_user_profile   VARCHAR2(40);
    l_language       VARCHAR2(20);
    l_tk             VARCHAR2(20);
    
    l_seq_nr         NUMBER;
    l_retval         NUMBER;
BEGIN
    FOR ev IN (
        SELECT * FROM atevlog WHERE tr_seq = a_tr_seq AND ev_seq = NVL(a_ev_seq, ev_seq) AND ROWNUM = 1
    ) LOOP
        l_client_id     := ev.client_id;
        l_username      := ev.username;
        l_applic        := ev.applic;
        l_numeric_chars := '.,';
        l_date_format   := 'DDfx/fxMM/RR HH24fx:fxMI:SS';
        EXIT;
    END LOOP;
    
    l_retval := unapigen.SetConnection(
        a_client_id          => l_client_id,
        a_us                 => l_username,
        a_applic             => l_applic,
        a_numeric_characters => l_numeric_chars,
        a_date_format        => l_date_format,
        a_up                 => l_up,
        a_user_profile       => l_user_profile,
        a_language           => l_language,
        a_tk                 => l_tk
    );

    l_retval := unapigen.BeginTxn(unapigen.p_multi_api_txn);
    
    FOR ev IN (
        SELECT * FROM atevlog WHERE tr_seq = a_tr_seq AND ev_seq = NVL(a_ev_seq, ev_seq)
    ) LOOP
        l_retval := unapiev.InsertEvent(
            a_api_name          => ev.dbapi_name,
            a_evmgr_name        => ev.evmgr_name,
            a_object_tp         => ev.object_tp,
            a_object_id         => ev.object_id,
            a_object_lc         => ev.object_lc,
            a_object_lc_version => ev.object_lc_version,
            a_object_ss         => ev.object_ss,
            a_ev_tp             => ev.ev_tp,
            a_ev_details        => ev.ev_details,
            a_seq_nr            => l_seq_nr
        );
    END LOOP;

    l_retval := unapigen.EndTxn(unapigen.p_multi_api_txn);
END RETRIGGEREVENT;

/
