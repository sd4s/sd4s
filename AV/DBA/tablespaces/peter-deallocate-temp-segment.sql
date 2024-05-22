SELECT segment_name, segment_type, header_file, relative_fno, header_block, bytes/POWER(1024, 2) AS "SIZE_MB"
FROM dba_segments
WHERE tablespace_name = 'TEMP'
AND segment_type = 'TEMPORARY'
--

select
   srt.tablespace,
   srt.segfile#,
   srt.segblk#,
   srt.blocks,
   a.sid,
   a.serial#,
   a.username,
   a.osuser,
   a.status
from
   v$session    a,
   v$sort_usage srt
where
   a.saddr = srt.session_addr
order by
   srt.tablespace, srt.segfile#, srt.segblk#,
   srt.blocks;
   
   
--   
SELECT TABLESPACE_NAME
,SUM(TABLESPACE_SIZE)/1024/1024 TOTAL_SIZE
,SUM(ALLOCATED_SPACE )/1024/1024 USED_SPACE
,SUM(FREE_SPACE)/1024/1024 SPACE_FREE 
FROM DBA_TEMP_FREE_SPACE
GROUP BY TABLESPACE_NAME
,TABLESPACE_SIZE
,ALLOCATED_SPACE
,FREE_SPACE
;
--TEMP	32767	32767	9833

select FILE_NAME
,TABLESPACE_NAME
,sum(bytes)/1024/1024 Total_MB 
from dba_temp_files 
group by FILE_NAME
,TABLESPACE_NAME
;
--D:\DATABASE\IS61\DATA\IS61\DATAFILE\O1_MF_TEMP_9JG8DS3S_.TMP	TEMP	32767

--ALTER TABLESPACE TEMP SHRINK SPACE KEEP 200M;
ALTER TABLESPACE TEMP SHRINK SPACE ;

