--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure REEVALPARAMETERS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."REEVALPARAMETERS" 
IS
    l_client_id      VARCHAR2(20);
    l_username       VARCHAR2(20);
    l_applic         VARCHAR2(8);
    l_numeric_chars  VARCHAR2(2);
    l_date_format    VARCHAR2(255);
    l_up             NUMBER;
    l_user_profile   VARCHAR2(40);
    l_language       VARCHAR2(20);
    l_tk             VARCHAR2(20);

    l_nr_results     NUMBER;
    l_ev_details     VARCHAR2(2000);
    l_seq_nr         NUMBER;
    l_retval         NUMBER;

    CURSOR inconsistent_pas IS
        SELECT sc, pg, pgnode, pa, panode
        FROM (
            SELECT sc, pg, pgnode, pa, panode, utscpa.ss
            FROM utscpa
            INNER JOIN utscpg USING(sc, pg, pgnode)
            INNER JOIN utsc   USING(sc)
        ) pa
        WHERE
            pa.ss NOT IN ('CM', 'SC', 'WC', 'OW', 'OS', '@C')
            AND NOT EXISTS (
                SELECT *
                FROM utscme
                WHERE sc = pa.sc
                  AND pg = pa.pg
                  AND pgnode = pa.pgnode
                  AND pa = pa.pa
                  AND panode = pa.panode
                  AND (
                      ss NOT IN ('CM', 'SC', 'WC', 'OW', 'OS')
                      OR exec_end_date IS NULL
                  )
            )
            AND EXISTS (
                SELECT *
                FROM utscme
                WHERE sc = pa.sc
                  AND pg = pa.pg
                  AND pgnode = pa.pgnode
                  AND pa = pa.pa
                  AND panode = pa.panode
            )
    ;

    CURSOR last_me(
        a_sc     IN VARCHAR2,
        a_pg     IN VARCHAR2,
        a_pgnode IN NUMBER,
        a_pa     IN VARCHAR2,
        a_panode IN NUMBER
    ) IS
        SELECT me, menode, mt_version, lc, lc_version, ss, reanalysis FROM (
            SELECT *
            FROM utscme
            WHERE sc = a_sc
              AND pg = a_pg
              AND pgnode = a_pgnode
              AND pa = a_pa
              AND panode = a_panode
            ORDER BY exec_end_date DESC
        ) WHERE ROWNUM = 1
    ;
    
    CURSOR result_count(
        a_sc     IN VARCHAR2,
        a_pg     IN VARCHAR2,
        a_pgnode IN NUMBER,
        a_pa     IN VARCHAR2,
        a_panode IN NUMBER
    ) IS
        SELECT NVL(COUNT(sc), 0)
        FROM utscme
        WHERE sc = a_sc
          AND pg = a_pg
          AND pgnode = a_pgnode
          AND pa = a_pa
          AND panode = a_panode
          AND nvl(active, '1') = '1'
          AND nvl(ss, '@~') <> '@C'
          AND exec_end_date IS NOT NULL;
BEGIN
    l_client_id     := 'EvMgrJob';
    l_applic        := 'EvMgrJob';
    l_username      := 'UNILAB';
    l_numeric_chars := '.,';
    l_date_format   := 'DDfx/fxMM/RR HH24fx:fxMI:SS';
    
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
    
    FOR pa IN inconsistent_pas LOOP
        dbms_output.put_line(pa.sc);
        FOR me IN last_me(pa.sc, pa.pg, pa.pgnode, pa.pa, pa.panode) LOOP
            OPEN  result_count(pa.sc, pa.pg, pa.pgnode, pa.pa, pa.panode);
            FETCH result_count INTO l_nr_results;
            CLOSE result_count;

            l_ev_details := 
                'sc=' || pa.sc ||
                '#pg=' || pa.pg ||
                '#pgnode=' || pa.pgnode ||
                '#pa=' || pa.pa ||
                '#panode=' || pa.panode ||
                '#menode=' || me.menode || 
                '#reanalysis=' || me.reanalysis ||
                '#alarms_handled=0' ||
                '#nr_results=' || l_nr_results ||
                '#mt_version=' || me.mt_version
            ;
            
            l_retval := unapiev.InsertEvent(
                a_api_name          => 'SaveScMeResult',
                a_evmgr_name        => 'U4EVMGR',
                a_object_tp         => 'me',
                a_object_id         => me.me,
                a_object_lc         => me.lc,
                a_object_lc_version => me.lc_version,
                a_object_ss         => me.ss,
                a_ev_tp             => 'MeResultUpdated',
                a_ev_details        => l_ev_details,
                a_seq_nr            => l_seq_nr
            );
        END LOOP;
    END LOOP;

    l_retval := unapigen.EndTxn(unapigen.p_multi_api_txn);
END;

/
