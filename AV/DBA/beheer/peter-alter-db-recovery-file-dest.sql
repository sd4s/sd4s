--The db_recovery_file_dest parameter defines the location of the Flash Recovery Area (FRA) and the db_recovery_file_dest parameter specifies the default location for the recovery area. The recovery area contains multiplexed copies of the following files:
--   Control files
--   Online redo logs
--   Archived redo logs
--   Flashback logs
--   RMAN backups
--
--Op dit moment is DB_RECOVERY_FILE_DEST voor INTERSPEC maar op 29GB gepland.
--

conn SYSTEM/moonflower@IS61

show parameter db_recovery
/*
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_recovery_file_dest                string      E:\FlashRecovery\IS61\IS61\ARCHIVELOG
db_recovery_file_dest_size           big integer 30000M
*/

--indien SPFILE gebruikt:
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 50G SCOPE=BOTH;
--anders:
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 50G ;
--EN dan handmatig de PFILE wijzigen (zie: C:\oracle\product\11.2.0\dbhome_1\database\initIS61.ora)




--ALTER SYSTEM SET DB_RECOVERY_FILE_DEST = 'E:\FlashRecovery\IS61\IS61\ARCHIVELOG' SCOPE=BOTH


prompt
prompt einde script
prompt
