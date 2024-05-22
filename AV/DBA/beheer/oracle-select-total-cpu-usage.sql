SELECT 'CPU_ORACLE'     TYPE
,       ROUND(value / 100, 3) COST_PERCENT_CORE 
FROM v$sysmetric
WHERE metric_name = 'CPU Usage Per Sec'
AND group_id = 2
UNION
SELECT 'CPU_OS'         TYPE
,      ROUND((percent.busy * parameter.cpu_count) / 100, 3) COST_PERCENT_CORE
FROM (SELECT value busy
      FROM v$sysmetric
      WHERE metric_name = 'Host CPU Utilization (%)'
      AND group_id=2) percent
	 ,(SELECT value cpu_count
       FROM v$parameter
       WHERE name = 'cpu_count') parameter
;



--I am doing a little test of the cpu utilization case on my laptop. I know the follow query will generate alot i/o:
--select count(*) from t1, t2;
--t1 is about 1/5 million and t2 is about 150000.
--the cpu utilization is 60%. To find out what's the waits:


select event, sid, seq#,
wait_time,
seconds_in_wait,
/* state,
p1text, p1, p1raw,
p2text, p2, p2raw,
p3text, p3, p3raw
p1text || ' = ' || p1 parm1,
p2text || ' = ' || p2 parm2,
 p3text || ' = ' || p3 parm3
*/
decode( p1text, null, null, p1text || ' = ' || p1 ) || 
   decode( p2text, null, null, ', ' || p2text || ' = ' || p2 ) || 
   decode( p3text, null, null, ', ' || p3text || ' = ' || p3 )
parameters
from v$session_wait
where event not in ( 'pmon timer', 'rdbms ipc message', 'smon timer','WMON goes to sleep','SQL*Net message from client' )
order by event, p1, p2

WAIT SECONDS			EVENT SID SEQ TIME IN WAIT PARAMETERS
----------------------------- ----- ------ ---- ------- -------------------------
null event 			9 23689 1	11 83 -1
wakeup time manager 8 2719 20

--***** the sid 9 is doing the query.
--***** What's the "null event"?

--Check the session stats:
select s.sid
, s.value
, n.name
from v$sesstat s
,    v$statname n
where n.statistic# = s.statistic#
and s.value <> 0
and s.sid like '&sid'
and n.name like '&name'
and s.statistic# like '&statistic'
order by sid, n.name


--mburk@jnas> @vsesstat
--Enter value for sid: 9
--Enter value for name: %
--Enter value for statistic: %

--Session System Statistics - By Sid
SID VALUE NAME
---- ---------------- ----------------------------------------------------------
9 	3 			CPU used by this session
	3 			CPU used when call started
	6,053 		Cached Commit SCN referenced
	4 			Commit SCN cached
	49 			SQL*Net roundtrips to/from client
	6,762 		buffer is not pinned count
	18 			buffer is pinned count
	3,990 		bytes received via SQL*Net from client
	3,813 		bytes sent via SQL*Net to client
	111 		calls to get snapshot scn: kcmgss
	1 			change write time
	4 			cleanout - number of ktugct calls
	4 			cleanouts only - consistent read gets
	35 			cluster key scan block gets
	35 			cluster key scans
	4 			commit txn count during cleanout
	6,938 		consistent gets
	146 		consistent gets - examination
	10 			cursor authentications
	4 			db block changes
	4 			db block gets
	4 			dirty buffers inspected
	8 			enqueue releases
	8 			enqueue requests
	89 			execute count
	4 			free buffer inspected
	6,651 		free buffer requested
	64 			hot buffers moved to head of LRU
	4 			immediate (CR) block cleanout applications
	52 			index fetch by key
	53 			index scans kdiixs1
	1 			logons cumulative
	1 			logons current
	6,705 		no work - consistent read gets
	39 			opened cursors cumulative
	1 			opened cursors current
	3 			parse count (hard)
	39 			parse count (total)
	5 			parse time cpu
	29 			parse time elapsed
	1,500,624 	physical reads
	1,493,974 	physical reads direct
	236 		physical writes
	236 		physical writes direct
	236 		physical writes non checkpoint
	6,395 		prefetched blocks
	1,044,465,908 process last non-idle time
	1,537 		recursive calls
	3 			recursive cpu usage

--Session System Statistics - By Sid

SID VALUE NAME
---- ---------------- ----------------------------------------------------------
9 	4 			redo entries
	240 		redo size
	13 			rows fetched via callback
	1,044,465,908 session connect time
	6,942 		session logical reads
	1,662,788 	session pga memory
	2,711,364 	session pga memory max
	1,225,904 	session uga memory
	2,040,880 	session uga memory max
	53 			shared hash latch upgrades - no wait
	1 			sorts (disk)
	45 			sorts (memory)
	479,387 	sorts (rows)
	41 			table fetch by rowid
	6,627 		table scan blocks gotten
	485,574 	table scan rows gotten
	2 			table scans (long tables)
	5 			table scans (short tables)
	47 			user calls
	38 			workarea executions - optimal
	1,105 		workarea memory allocated

70 rows selected.

--the results show session 9 using 3/100 seconds of CPU time.
--The LIO=6,938 and PIO=1,500,624.

