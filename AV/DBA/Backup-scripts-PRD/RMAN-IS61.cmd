set oracle_sid=IS61
rman target sys/moonflower

CROSSCHECK BACKUP;
delete expired backup;
delete obsolete;


 