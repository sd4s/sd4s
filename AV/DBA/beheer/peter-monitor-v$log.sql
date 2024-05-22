Oracle log switch SQL reports
Oracle Database Tips by Donald Burleson

January 15,  2015

Oracle redo log sizing is an important task, and you also need scripts to monitor redo log switches and other redo statistics.

For complete details on monitoring log switches, see these notes from the book, which shows several important redo log switch monitoring scripts.

Oracle log switch SQL reports
Here are some sample scripts to display the log switch frequency:

set lines 120;
set pages 999;
SELECT
to_char(first_time,'YYYY-MON-DD') day,
to_char(sum(decode(to_char(first_time,'HH24'),'00',1,0)),'99') "00",
to_char(sum(decode(to_char(first_time,'HH24'),'01',1,0)),'99') "01",
to_char(sum(decode(to_char(first_time,'HH24'),'02',1,0)),'99') "02",
to_char(sum(decode(to_char(first_time,'HH24'),'03',1,0)),'99') "03",
to_char(sum(decode(to_char(first_time,'HH24'),'04',1,0)),'99') "04",
to_char(sum(decode(to_char(first_time,'HH24'),'05',1,0)),'99') "05",
to_char(sum(decode(to_char(first_time,'HH24'),'06',1,0)),'99') "06",
to_char(sum(decode(to_char(first_time,'HH24'),'07',1,0)),'99') "07",
to_char(sum(decode(to_char(first_time,'HH24'),'08',1,0)),'99') "0",
to_char(sum(decode(to_char(first_time,'HH24'),'09',1,0)),'99') "09",
to_char(sum(decode(to_char(first_time,'HH24'),'10',1,0)),'99') "10",
to_char(sum(decode(to_char(first_time,'HH24'),'11',1,0)),'99') "11",
to_char(sum(decode(to_char(first_time,'HH24'),'12',1,0)),'99') "12",
to_char(sum(decode(to_char(first_time,'HH24'),'13',1,0)),'99') "13",
to_char(sum(decode(to_char(first_time,'HH24'),'14',1,0)),'99') "14",
to_char(sum(decode(to_char(first_time,'HH24'),'15',1,0)),'99') "15",
to_char(sum(decode(to_char(first_time,'HH24'),'16',1,0)),'99') "16",
to_char(sum(decode(to_char(first_time,'HH24'),'17',1,0)),'99') "17",
to_char(sum(decode(to_char(first_time,'HH24'),'18',1,0)),'99') "18",
to_char(sum(decode(to_char(first_time,'HH24'),'19',1,0)),'99') "19",
to_char(sum(decode(to_char(first_time,'HH24'),'20',1,0)),'99') "20",
to_char(sum(decode(to_char(first_time,'HH24'),'21',1,0)),'99') "21",
to_char(sum(decode(to_char(first_time,'HH24'),'22',1,0)),'99') "22",
to_char(sum(decode(to_char(first_time,'HH24'),'23',1,0)),'99') "23"
from  v$log_history
GROUP by to_char(first_time,'YYYY-MON-DD')
ORDER BY to_char(first_time,'YYYY-MON-DD')
;

/*
This log switch script is handy because it displays the log switch activity as a two-dimensional table, showing log switches by hours of the day and log switches by date:
                              LOG SWITCH FREQUENCY REPORT

INTERSPEC

DAY                  00  01  02  03  04  05  06  07  0   09  10  11  12  13  14  15  16  17  18  19  20  21  22  23
-------------------- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
2020-SEP-01            1   3   0   0   0   4   7   3   8  27  21  34  31  28  27  13  13   2   3   1   0   1   3   0
2020-SEP-02            1   3   0   0   0   2   9   4   7  19  16  13  15  17   2   1   7   2   0   1   0   4   2   0
2020-SEP-03           19   2   0   0   0   3   5   6  14  25  24  13  15  16  17   8  13   3   2   5   0   0   2   1
2020-SEP-04            1   3   0   0   0   1   5   0   1  13  18  12  12  20   6  23   7   0   1   0   0   0   3   0
2020-SEP-05            3   3   0   0   0   1   2   0   0   0   1   0   0   2   1   0   0   1   0   0   1   0   0   1
2020-SEP-06            3   2   1   0   0   1   1   1   0   0   1   0   0   2   1   0   0   1   0   0   1   0   1   0
2020-SEP-07            0   3   1   0   0   1  11   1  14  20  37  19  10  52  36  33  63  38  10   0   0   0   3   0
2020-SEP-08            3   3   0   0   0   1   0   0  15  48  61  58  30  57  48  43  27  17   0   3   0   0   3   0
2020-SEP-09            2   4  20  20  20  20  30  23  41  68  43  71  34  94  45  47 ###  41  19  20  18  20  23  11
2020-SEP-10            0   0   0   0   0   0   0  20  42  57   5   0   0   0   0   0   0   0   0   0   0   0   0   0

9sept 
15:50 uur RDT-specs uit ITLIMSJOB gehaald
16:18 uur session lims-interface gekilled.
16:22 uur 

UNILAB:

DAY                  00  01  02  03  04  05  06  07  0   09  10  11  12  13  14  15  16  17  18  19  20  21  22  23
-------------------- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
2020-SEP-01            7  14   6   8   7   8   7   7   6  16  27  13   5  14  12  14  18   7   4   8   6   4   3   3
2020-SEP-02            5  16   2   5   7   7   6   9  11  16  12  14  12  12  20  17  13  10   5   5   6   9   7   7
2020-SEP-03            7   9   6   7   6   9   3   6  12  11  10  35  14  14  22  15  11   5   9   4   7   4   3   2
2020-SEP-04            3  10   3   3   6   3   5   6   4  10  13   9   8  14   7  12  11   6   5   2   3   5   8   5
2020-SEP-05            6  12   5   9   7   8   5   5   7   5   4   6   3   4   6   4   5   7   3   3   6   4   1   1
2020-SEP-06            2   4   2   7   2   2   5   5   5   1   5   5   2   5   3   3   5   5   6   2   2   5   5   5
2020-SEP-07            4   6   1   2   1   4   4   8   7   7   6   5   5  16  11  14   9   6   4   5   6   4   9   3
2020-SEP-08            3  11   3   5   5   6   4   5  10  13  13  14  10  39  13   8  14   7   5   6   7   5   8   3
2020-SEP-09            1  24  85  86  85  79  79  79  87  83  88  85  82  84  94  88  89  88  72  84  72  86  85  66
2020-SEP-10            1   4   1   1   0   0   1  77 ### ###   0   0   0   0   0   0   0   0   0   0   0   0   0   0

*/
 

rem
rem Name:     log_stat.sql
rem
rem FUNCTION: Provide a current status for redo logs
rem
rem
COLUMN first_change# FORMAT 99999999  HEADING Change#
COLUMN group#        FORMAT 9,999     HEADING Grp#
COLUMN thread#       FORMAT 999       HEADING Th#
COLUMN sequence#     FORMAT 999,999   HEADING Seq#
COLUMN members       FORMAT 999       HEADING Mem
COLUMN archived      FORMAT a4        HEADING Arc?
COLUMN first_time    FORMAT a21       HEADING 'Switch|Time'
BREAK ON thread#
SET PAGES 60 LINES 131 FEEDBACK OFF
START title132 'Current Redo Log Status'
SPOOL rep_out\&db\log_stat
SELECT thread#,group#,sequence#,bytes,
       members,archived,
       status,first_change#,
       TO_CHAR(first_time, 'DD-MM-YYYY HH24:MI:SS') first_time
  FROM sys.v_$log
  ORDER BY
       thread#,
       group#;
	   
SPOOL OFF



SET PAGES 22 LINES 80 FEEDBACK ON
CLEAR BREAKS
CLEAR COLUMNS
TTILE OFF

/*
LISTING 11.22 Example output of script to monitor redo log status.

Date: 06/15/97                                               Page:   1
Time: 01:39 PM           Current Redo Log Status                SYSTEM 

                             ORTEST1 database

Switch                                                                          

Th# Grp#  Seq#     BYTES Mem Arc? STATUS   Change# Time

--- ---- -----   ------- -------- -------- ------- ------------------
 1    1 4,489   1048576   2 NO   INACTIVE  719114 15-JUN-97 16:54:23
      2 4,490   1048576   2 NO   INACTIVE  719117 15-JUN-97 16:56:10
      3 4,491   1048576   2 NO   CURRENT   719120 15-JUN-97 17:02:22
*/


Monitoring Redo Log Switches
In addition to the alert logs, the frequency of log switches can also be monitored via the v$log_history and v$archived_log views. This script shows an example of a script to monitor archive log switches:

REM NAME         :log_hist.sql
REM PURPOSE      :Provide info on logs for last 24 hours since last
REM PURPOSE      :log switch
REM USE          :From SQLPLUS
REM Limitations  : None
REM MRA 10/14/01 Updated for Oracle9i
REM


COLUMN thread#             FORMAT 999      HEADING 'Thrd#'
COLUMN sequence#           FORMAT 99999    HEADING 'Seq#'
COLUMN first_change#                       HEADING 'SCN Low#'
COLUMN next_change#                        HEADING 'SCN High#'
COLUMN archive_name        FORMAT a50      HEADING 'Log File'
COLUMN first_time          FORMAT a20      HEADING 'Switch Time'
COLUMN name                FORMAT a30      HEADING 'Archive Log'

SET LINES 132 FEEDBACK OFF VERIFY OFF
START title132 "Log History Report"
SPOOL rep_out\&db\log_hist
REM
SELECT
     X.recid,a.thread#,
     a.sequence#,a.first_change#,
     a.switch_change#,
     TO_CHAR(a.first_time,'DD-MON-YYYY HH24:MI:SS') first_time,x.name
FROM v$loghist a
,    v$archived_log x
WHERE
  a.first_time>
   (SELECT b.first_time-1
   FROM v$loghist b WHERE b.switch_change# =
    (SELECT MAX(c.switch_change#) FROM v$loghist c)) AND
     x.recid(+)=a.sequence#
;

SPOOL OFF
SET LINES 80 VERIFY ON FEEDBACK ON
CLEAR COLUMNS
TTITLE OFF
PAUSE Press Enter to continue

Monitoring Redo Statistics
There are no views in Oracle that allow the user to look directly at a log files statistical data. Instead, 
we must look at statistics based on redo log and log writer process statistics. These statistics are in the 
views V$STATNAME, V$SESSION, V$PROCESS, V$SESSTAT, V$LATCH, and V$LATCHNAME. An example of a report that uses 
these views is shown in Source 11.29; an example of the scripts output is shown in Listing 11.24.

Script to generate reports on redo statistics.

REM
REM NAME          : rdo_stat.sql
REM PURPOSE       : Show REDO latch statistics
REM USE           : from SQLPlus
REM Limitations   : Must have access to v$_ views
REM

SET PAGES 56 LINES 78 VERIFY OFF FEERemote DBACK OFF
START title80 "Redo Latch Statistics"
SPOOL rep_out/&&db/rdo_stat
rem
COLUMN name      FORMAT a30          HEADING Name
COLUMN percent   FORMAT 999.999      HEADING Percent
COLUMN total                         HEADING Total
rem
SELECT
     l2.name,
     immediate_gets+gets Total,
     immediate_gets "Immediates",
     misses+immediate_misses "Total Misses",
     DECODE (100.*(GREATEST(misses+immediate_misses,1)/
     GREATEST(immediate_gets+gets,1)),100,0) Percent
FROM v$latch l1,
     v$latchname l2
WHERE l2.name like '%redo%'
     and l1.latch#=l2.latch# 
;

rem
PAUSE Press Enter to continue
rem
rem Name: Redo_stat.sql
rem
rem Function: Select redo statistics from v$sysstat

COLUMN name    FORMAT a30         HEADING 'Redo|Statistic|Name'
COLUMN value   FORMAT 999,999,999 HEADING 'Redo|Statistic|Value'
SET PAGES 80 LINES 60 FEERemote DBACK OFF VERIFY OFF
START title80 'Redo Log Statistics'
SPOOL rep_out/&&db/redo_stat
SELECT
     name,
     value
FROM
     v$sysstat
WHERE
     name LIKE '%redo%'
ORDER BY statistic#;
SPOOL OFF
SET LINES 24 FEERemote DBACK ON VERIFY ON
TTITLE OFF
CLEAR COLUMNS
CLEAR BREAKS

 Also see these related notes on redo log switch frequency:

Oracle redo size tips

Redo log sizing advisor

Optimal size - Oracle log_buffer sizing

Oracle Concepts - Redo Log Files

Tuning Oracle redo logs

Oracle Log File Size Redo Blocks