--script run in (registered) database, not in the catalog
--
--login as sysdba:

--Query will give you SID, Total Work, Sofar & % of completion.

SELECT SID
, SERIAL#
, CONTEXT
, SOFAR
, TOTALWORK
, ROUND (SOFAR/TOTALWORK*100, 2) "% COMPLETE"
FROM V$SESSION_LONGOPS
WHERE OPNAME LIKE 'RMAN%' AND OPNAME NOT LIKE '%aggregate%'
AND TOTALWORK! = 0 AND SOFAR <> TOTALWORK
;


prompt einde script
