--controle db-instellingen INTERSPEC

--sga-instance-auto + pga-instance-auto, you set:
--total memory target-size / optional-max-memory-size for db-instance:
show parameter memory_target
show parameter memory_max_target

NAME                                 TYPE        VALUE
------------------------------------ ----------- -----------
memory_target                        big integer 12000M
memory_max_target                    big integer 12000M


--sga-auto + pga-auto, you set:
show parameter sga_target
show parameter sga_max_size
show parameter pga_aggregate_target

NAME                                 TYPE        VALUE
------------------------------------ ----------- --------------------
sga_target                           big integer 0
sga_max_size                         big integer 12000M
pga_aggregate_target                 big integer 0

--sga-auto + pga-manual, you set:
show parameter sga_target
show parameter sga_max_size
show parameter sort_area_size
show parameter hash_area_size
show parameter bitmap_merge_area_size

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
pga_aggregate_target                 big integer 0
sga_target                           big integer 0
sga_max_size                         big integer 12000M
sort_area_size                       integer     65536
hash_area_size                       integer     131072
bitmap_merge_area_size               integer     1048576


--sga-manual, pga-auto, you set:
show parameter shared_pool_size
show parameter db_cache_size
show parameter large_pool_size
show parameter java_pool_size
show parameter streams_pool_size
show parameter pga_aggregate_target

NAME                                 TYPE        VALUE
------------------------------------ ----------- --------------------------
shared_pool_size                     big integer 0
db_cache_size                        big integer 0
large_pool_size                      big integer 0
java_pool_size                       big integer 0
streams_pool_size                    big integer 0
pga_aggregate_target                 big integer 0


--PGA-SIZING
set numwidth 20
set linesize 300
set pages 999
--
select * from v$memory_target_advice order by memory_size;
MEMORY_SIZE MEMORY_SIZE_FACTOR ESTD_DB_TIME ESTD_DB_TIME_FACTOR VERSION
180 		.5 					458 		1.344 				0
270 		.75 				367 		1.0761 				0
360 		1 					341 		1 					0
450 		1.25 				335 		.9817 				0
540 		1.5 				335 		.9817 				0
630 		1.75 				335 		.9817 				0
/*
The row with the MEMORY_SIZE_FACTOR of 1 shows the current size of memory, as set by the MEMORY_TARGET initialization parameter, 
and the amount of DB time required to complete the current workload. In previous and subsequent rows, the results show a number of alternative MEMORY_TARGET sizes. 
For each alternative size, the database shows the size factor (the multiple of the current size), and the estimated DB time to complete the current workload if 
the MEMORY_TARGET parameter were changed to the alternative size. Notice that for a total memory size smaller than the current MEMORY_TARGET size (360 in this example), 
estimated DB time (ESTD_DB_TIME) increases. Notice also that in this example, there is nothing to be gained by increasing total memory size beyond 450MB, 
because the ESTD_DB_TIME value is not decreasing. Therefore, in this example, the suggested MEMORY_TARGET size is 450 MB
*/	
select * from v$sga_target_advice order by sga_size;
SGA_SIZE 	SGA_SIZE_FACTOR ESTD_DB_TIME 	ESTD_DB_TIME_FACTOR ESTD_PHYSICAL_READS
290 		.5 				448176 			1.6578 				1636103
435 		.75 			339336 			1.2552 				1636103
580 		1 				201866 			1 					513881
725 		1.25 			201866 			1 					513881
870 		1.5 			201866 			1 					513881
1015 		1.75 			201866 			1 					513881

select * from v$pga_target_advice order by pga_target_for_estimate;
PGA_TARGET_FOR_ESTIMATE    PGA_TARGET_FACTOR ADV      BYTES_PROCESSED            ESTD_TIME  ESTD_EXTRA_BYTES_RW ESTD_PGA_CACHE_HIT_PERCENTAGE ESTD_OVERALLOC_COUNT
----------------------- -------------------- --- -------------------- -------------------- -------------------- ----------------------------- --------------------
              549453824                 .125 ON         4280070255616             53273139                    0                           100                    0
             1098907648                  .25 ON         4280070255616             53273139                    0                           100                    0
             2197815296                   .5 ON         4280070255616             53273139                    0                           100                    0
             3296722944                  .75 ON         4280070255616             53273139                    0                           100                    0
             4395630592                    1 ON         4280070255616             53273139                    0                           100                    0
             5274756096                  1.2 ON         4280070255616             53273139                    0                           100                    0
             6153882624                  1.4 ON         4280070255616             53273139                    0                           100                    0
             7033008128                  1.6 ON         4280070255616             53273139                    0                           100                    0
             7912134656                  1.8 ON         4280070255616             53273139                    0                           100                    0
             8791261184                    2 ON         4280070255616             53273139                    0                           100                    0
            13186891776                    3 ON         4280070255616             53273139                    0                           100                    0
            17582522368                    4 ON         4280070255616             53273139                    0                           100                    0
            26373783552                    6 ON         4280070255616             53273139                    0                           100                    0
            35165044736                    8 ON         4280070255616             53273139                    0                           100                    0

--**********************************
--KILL SESSION WINDOWS-SERVER
--**********************************



			