:: script om alle BACKUP-bestanden IS61/REPM/U611 naar EXTERNE-DISK te kopieren.
:: local-directory: "E:\Backup"
:: external-disk: "G:\Oracleprod_test\Backup"

ECHO DO YOU RUN THIS COPY-BACKUP-SCRIPT AS "RUN AS ADMINISTRATOR"? IF NOT THEN CANCEL THIS ACTION AND START AGAIN !!!!
@pause

::assign-volume aan G:
diskpart  /s E:\Backup\diskpartassignvolume.txt >E:\Backup\bck-log\diskpartassignvolume.log
::you must allow at least 15 seconds between each script for a complete shutdown of the previous execution 
::before running the diskpart command again in successive scripts

pause

