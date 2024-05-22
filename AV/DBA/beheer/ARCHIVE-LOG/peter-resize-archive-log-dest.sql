set numwidth 20
set linesize 200
set pages 999


--REPM
show parameter recover

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_recovery_file_dest                string      E:\FlashRecovery
db_recovery_file_dest_size           big integer 4977M


--IS61

show parameter db_recovery_file_dest

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_recovery_file_dest                string      E:\FlashRecovery\IS61\IS61\ARCHIVELOG
db_recovery_file_dest_size           big integer 79 548 125K

SYS AS SYSDBA@is61 >archive log list
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     246718
Next log sequence to archive   246720
Current log sequence           246720

--U611

show parameter db_recovery_file_dest

NAME                                               TYPE        VALUE                                                                                                
-------------------------------------------------- ----------- ---------------------------------------------------------------------------------------------------- 
db_recovery_file_dest                              string      E:\FlashRecovery\U611\ARCHIVELOG                                                                     
db_recovery_file_dest_size                         big integer 128 376 250K                                                                                           


--change size 

SYS AS SYSDBA@u611 >archive log list
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     445544
Next log sequence to archive   445546
Current log sequence           445546


--nog niet gearchiveerde LOG-bestanden:
select count(*), sum(blocks*block_size) 
from v$archived_log 
where backup_count = 0
and deleted = 'NO'
;

--WELKE DATABASE WAS VERANTWOORDELIJKE VOOR VOLLOPEN DE AFGELOPEN DAGEN?
--IS61
SELECT COUNT(*),sum( (blocks*block_size)/1024/1024) , TRUNC(COMPLETION_TIME) 
FROM V$ARCHIVED_LOG 
WHERE COMPLETION_TIME > TO_DATE('23-10-2020','DD-MM-YYYY') 
GROUP BY TRUNC(COMPLETION_TIME)
order by trunc(completion_time)
;
/*
  COUNT(*) SUM((BLOCKS*BLOCK_SIZE)/1024/1024) TRUNC(COM
---------- ---------------------------------- ---------
       873                     11003.90234375 23-OCT-20
       463                   4557.86181640625 24-OCT-20
      2350                    27915.662109375 25-OCT-20
      2217                   28805.7802734375 26-OCT-20
       275                   7457.75537109375 27-OCT-20
       879                    25960.654296875 28-OCT-20
*/
--TOTAAL
SELECT sum( (blocks*block_size)/1024/1024/1024)  
FROM V$ARCHIVED_LOG 
WHERE COMPLETION_TIME > TO_DATE('23-10-2020','DD-MM-YYYY') 
;
--103GB

--u611
SELECT COUNT(*),sum( (blocks*block_size)/1024/1024) , TRUNC(COMPLETION_TIME) 
FROM V$ARCHIVED_LOG 
WHERE COMPLETION_TIME > TO_DATE('23-10-2020','DD-MM-YYYY') 
GROUP BY TRUNC(COMPLETION_TIME)
order by trunc(completion_time)
;
/*
 COUNT(*) SUM((BLOCKS*BLOCK_SIZE)/1024/1024) TRUNC(COM
--------- ---------------------------------- ---------
     2338                         26147.9492 23-OCT-20
     1878                         19979.1616 24-OCT-20
     1133                         12118.9326 25-OCT-20
      546                         6114.78857 26-OCT-20
      143                         1720.99609 27-OCT-20
     1153                         13468.6289 28-OCT-20
*/
--TOTAAL
SELECT sum( (blocks*block_size)/1024/1024/1024)  
FROM V$ARCHIVED_LOG 
WHERE COMPLETION_TIME > TO_DATE('23-10-2020','DD-MM-YYYY') 
;
/*
SUM((BLOCKS*BLOCK_SIZE)/1024/1024/1024)
---------------------------------------
                             77.6976399
*/							 


--CONTROLE RUIMTE VERBRUIKT
column name format a40
--IS61
conn sys/moonflower@is61 as sysdba
select * from v$RECOVERY_FILE_DEST;
/*
NAME                                              SPACE_LIMIT           SPACE_USED    SPACE_RECLAIMABLE      NUMBER_OF_FILES
---------------------------------------- -------------------- -------------------- -------------------- --------------------
E:\FlashRecovery\IS61\IS61\ARCHIVELOG             81457280000          19068381696                    0                  545
*/

--u611
conn sys/moonflower@u611 as sysdba
select * from v$RECOVERY_FILE_DEST;
/*
NAME                                              SPACE_LIMIT           SPACE_USED    SPACE_RECLAIMABLE      NUMBER_OF_FILES
---------------------------------------- -------------------- -------------------- -------------------- --------------------
E:\FlashRecovery\U611\ARCHIVELOG                 131457280000           6002627584                    0                  490
*/



--herstellen van de RECOVERY-FILE
--IS61
conn sys/moonflower@is61 as sysdba
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 100G scope=BOTH ;
--U611
conn sys/moonflower@u611 as sysdba
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 150G scope=BOTH ;


--controle nieuwe instellingen
show parameter recovery


--einde script


