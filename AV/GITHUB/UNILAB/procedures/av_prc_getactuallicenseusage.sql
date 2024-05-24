--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure GETACTUALLICENSEUSAGE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."GETACTUALLICENSEUSAGE" 
AS
   l_ret                        NUMBER;
   a_app_id                     cxsapilk.vc20_table_type;
   a_app_version                cxsapilk.vc20_table_type;
   /* VC20_TABLE_TYPE */
   a_logon_station              cxsapilk.vc40_table_type;
   /* VC40_TABLE_TYPE */
   a_user_sid                   cxsapilk.vc20_table_type;
   /* VC20_TABLE_TYPE */
   a_user_name                  cxsapilk.vc40_table_type;
   /* VC40_TABLE_TYPE */
   a_logon_date                 cxsapilk.date_table_type;
   /* DATE_TABLE_TYPE */
   a_last_heartbeat             cxsapilk.date_table_type;
   /* DATE_TABLE_TYPE */
   a_lic_consumed               cxsapilk.num_table_type; /* NUM_TABLE_TYPE */
   a_executable                 cxsapilk.vc20_table_type;
   /* VC20_TABLE_TYPE */
   a_lic_consumed_serial_id     cxsapilk.vc40_table_type;
   /* VC40_TABLE_TYPE */
   a_lic_consumed_shortname     cxsapilk.vc40_table_type;
   /* VC40_TABLE_TYPE */
   a_nr_of_rows                 NUMBER;                        /* NUM_TYPE */
   a_search_criteria            VARCHAR2 (200);               /* VC20_TYPE */
   a_search_id                  VARCHAR2 (200);              /* VC511_TYPE */
   a_next_rows                  NUMBER;                        /* NUM_TYPE */
   a_error_message              VARCHAR2 (200);              /* VC255_TYPE */
   lcs_function_name   CONSTANT VARCHAR2 (40)      := 'GetActualLicenseUsage';
   lvs_sqlerrm                  VARCHAR2 (255);
   lvd_logon_date               TIMESTAMP WITH TIME ZONE;
   lvd_logon_date_d             DATE;
   lvs_osuser                   VARCHAR2 (30);
   lvn_sid                      NUMBER;
   lvs_machine                  VARCHAR2 (64);
   lvs_terminal                 VARCHAR2 (30);
   lvd_session_logon_time       TIMESTAMP WITH TIME ZONE;
   lvd_session_logon_time_d     DATE;
   lvs_user_description         VARCHAR2 (40 CHAR);
   lvs_executable               VARCHAR2 (20 CHAR);
   lvs_step                              VARCHAR2 (20);
BEGIN
   lvs_step := '0';
   DELETE      atlicensecheck;
   lvs_step := '1';

   EXECUTE IMMEDIATE 'alter session set nls_date_format = ''DD/MM/YYYY HH24:MI:SS''';
   lvs_step := '2';

   l_ret :=
      cxsapilk.getactuallicenseusage (a_app_id,
                                      a_app_version,
                                      a_logon_station,
                                      a_user_sid,
                                      a_user_name,
                                      a_logon_date,
                                      a_last_heartbeat,
                                      a_lic_consumed,
                                      a_executable,
                                      a_lic_consumed_serial_id,
                                      a_lic_consumed_shortname,
                                      a_nr_of_rows,
                                      a_search_criteria,
                                      a_search_id,
                                      a_next_rows,
                                      a_error_message
                                     );
   lvs_step := '3';

   FOR i IN 1 .. a_nr_of_rows
   LOOP
        lvs_step := '4.'||i;        
        IF a_logon_date (i) IS NOT NULL THEN
            lvs_step := '5a.'||i;        
            lvd_logon_date_d := TO_DATE (a_logon_date (i));
            lvs_step := '5b.'||i;
            lvd_logon_date := TO_TIMESTAMP_TZ (lvd_logon_date_d);
            lvs_step := '6.'||i;

            BEGIN
                SELECT osuser, SID, machine, terminal,
                         logon_time
                  INTO lvs_osuser, lvn_sid, lvs_machine, lvs_terminal,
                         lvd_session_logon_time_d
                  FROM v$session
                 WHERE username = a_user_name (i)
                    AND program = a_executable (i)
                    AND logon_time BETWEEN   lvd_logon_date_d
                                                                          - (1 / 24 / 60 * 15)
                                                                     AND   lvd_logon_date_d
                                                                          + (1 / 24 / 60 * 15);

                lvs_step := '7.'||i;
                lvd_session_logon_time := TO_TIMESTAMP_TZ (lvd_session_logon_time_d);
                lvs_step := '8.'||i;
            EXCEPTION
                WHEN OTHERS
                THEN
                    BEGIN
                        lvs_step := '9.'||i;
                        SELECT MIN (osuser) || '(*)', MIN (SID),
                                 MIN (machine) || '(*)', MIN (terminal) || '(*)',
                                 MIN (logon_time)
                          INTO lvs_osuser, lvn_sid,
                                 lvs_machine, lvs_terminal,
                                 lvd_session_logon_time_d
                          FROM v$session
                         WHERE username = a_user_name (i)
                            AND program = a_executable (i);

                        lvs_step := '10.'||i;
                        lvd_session_logon_time :=
                                                    TO_TIMESTAMP_TZ (lvd_session_logon_time_d);
                        lvs_step := '11.'||i;
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            lvs_step := '12.'||i;
                            lvs_osuser := NULL;
                            lvn_sid := NULL;
                            lvs_machine := NULL;
                            lvs_terminal := NULL;
                            lvd_session_logon_time := NULL;
                            lvs_step := '13.'||i;
                    END;
            END;

            lvs_step := '14.'||i;
            BEGIN
                SELECT person
                  INTO lvs_user_description
                  FROM utad
                 WHERE ad = a_user_name (i);
                lvs_step := '15.'||i;
            EXCEPTION
                WHEN OTHERS
                THEN
                    lvs_step := '16.'||i;
                    lvs_user_description := a_user_name (i);
                    lvs_step := '17.'||i;
            END;

            lvs_step := '18.'||i;
            BEGIN
                SELECT DECODE (MAX (description),
                                    'Sample Management', 'Analyzer',
                                    'Define Sample Type', 'Configuration',
                                    MAX (description)
                                  )
                  INTO lvs_executable
                  FROM utfa
                 WHERE NLS_UPPER (applic || '.exe') = NLS_UPPER (a_executable (i));
                lvs_step := '19.'||i;
            EXCEPTION
                WHEN OTHERS
                THEN
                    lvs_step := '20.'||i;
                    lvs_executable := a_executable (i);
                    lvs_step := '21.'||i;
            END;

            lvs_step := '22.'||i;
            INSERT INTO atlicensecheck
                            (RECORD, lic_consumed,
                             machine, terminal, logon_station, SID,
                             user_name, user_description, osuser,
                             logon_date, session_logon_time, executable,
                             job_last_run
                            )
                  VALUES (TO_NUMBER (LPAD (i, 2, '0')), a_lic_consumed (i),
                             lvs_machine, lvs_terminal, a_logon_station (i), lvn_sid,
                             a_user_name (i), lvs_user_description, lvs_osuser,
                             lvd_logon_date, lvd_session_logon_time, lvs_executable,
                             CURRENT_TIMESTAMP
                            );
            lvs_step := '23.'||i;
        END IF;
   END LOOP;

    lvs_step := '24';
   IF a_nr_of_rows = 0
   THEN
        lvs_step := '25';
      INSERT INTO atlicensecheck
                  (RECORD, job_last_run
                  )
           VALUES (0, CURRENT_TIMESTAMP
                  );
        lvs_step := '26';
   END IF;
    lvs_step := '27';

   COMMIT;
    lvs_step := '28';
EXCEPTION
   WHEN OTHERS
   THEN
      IF SQLCODE <> 1
      THEN
         lvs_sqlerrm := SQLERRM;
      END IF;

        -- Function "cxsapilk.getactuallicenseusage" can return a_nr_of_rows > 0, but a_logon_date (i) can be null
        --    But to avoid error logging in uterror because of this strange error, check if this is the case
        IF lvs_step <> '4.1' AND lvs_sqlerrm <> 'ORA-01403: no data found' THEN
          unapigen.logerror (lcs_function_name, 'Step='||lvs_step||' :'||lvs_sqlerrm);
      END IF;
      
END getactuallicenseusage;
 

/
