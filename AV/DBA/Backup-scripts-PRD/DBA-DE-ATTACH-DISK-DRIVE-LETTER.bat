:: script om alle BACKUP-bestanden IS61/REPM/U611 naar EXTERNE-DISK te kopieren.
:: local-directory: "E:\Backup"
:: external-disk: "G:\Oracleprod_test\Backup"

ECHO DO YOU RUN THIS COPY-BACKUP-SCRIPT AS "RUN AS ADMINISTRATOR"? IF NOT THEN CANCEL THIS ACTION AND START AGAIN !!!!
@pause

ECHO VERWIJDEREN VAN EXTERNAL-DISK MAPPING 
::DE-assign volume G
diskpart  /s E:\Backup\diskpartremovevolume.txt >E:\Backup\bck-log\diskpartremovevolume.log


pause

