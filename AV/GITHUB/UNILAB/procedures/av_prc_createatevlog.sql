--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure CLEARATEVLOG
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UNILAB"."CLEARATEVLOG"     
AS 
    cutoff TIMESTAMP := SYSDATE - INTERVAL '7' DAY;
BEGIN
    MERGE INTO
        atevloghs dest
    USING (
        SELECT *
        FROM   avevloghs
        WHERE  interval < TRUNC(SYSDATE, 'DD')
    ) src
    ON (src.interval = dest.interval)
    WHEN NOT MATCHED THEN
        INSERT (
            interval,
            count,
            waiting_min,
            waiting_max,
            waiting_mean,
            waiting_stddev,
            waiting_median,
            process_min,
            process_max,
            process_mean,
            process_stddev,
            process_median
        )
        VALUES (
            src.interval,
            src.count,
            src.waiting_min,
            src.waiting_max,
            src.waiting_mean,
            src.waiting_stddev,
            src.waiting_median,
            src.process_min,
            src.process_max,
            src.process_mean,
            src.process_stddev,
            src.process_median
        )
    ;


    DELETE FROM atevlog
    WHERE TRUNC(end_date, 'HH24') < cutoff;

    COMMIT;
END CLEARATEVLOG;
 

/
