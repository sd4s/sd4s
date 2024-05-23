--Crosschecking Within a Range of Dates: Example 
--The following example queries the media manager for the status of the backup sets in a given six month range. 
--Note that RMAN uses the date format specified in the NLS_DATE_FORMAT parameter, which is 'DD-MON-YY' in this example:

--CONNECT: RMAN

--to crosscheck only disk, specify CROSSCHECK DEVICE TYPE DISK
CROSSCHECK BACKUP DEVICE TYPE DISK   COMPLETED BETWEEN '01-SEP-20' AND '22-DEC-20';
  
/*
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=80 device type=DISK
crosschecked backup piece: found to be 'AVAILABLE'
backup piece handle=E:\BACKUP\U611\BCK_1059731988_3546_1.BAK RECID=3513 STAMP=1059731988
crosschecked backup piece: found to be 'AVAILABLE'
backup piece handle=E:\BACKUP\U611\BCK_1059733786_3547_1.BAK RECID=3514 STAMP=1059733787
Crosschecked 2 objects
*/

PROMPT einde script

