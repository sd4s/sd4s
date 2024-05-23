Herstart-procedure ONDERHOUDSAVOND

LET OP: DB-BACKUP-jobs. INDIEN ONDERHOUD OP DEZE TIJDSTIPPEN dan via WINDOWS-TASK-manager de betreffende JOBS stoppen:
incremental-backup IS61:   daily 20:00 uur
incremental-backup U611:   daily 20:30 uur
incremental-backup REPM:   daily 21:00 uur
--
Full backup IS61:          fryday 18:00 uur
Full backup U611:          fryday 18:30 uur
Full backup REPM:          fryday 19:50 uur
	

Actie								Script
-------------------------------------------------------------	-----------------------------------------------------------
1)zet db-jobs van IS61 en U611 uit.				E:\DBA\dba-db-stop-jobs-oracleprod.bat
  (eerste INTERSPEC en dan pas UNILAB jobs stoppen...)
2)controleer de log-files van stop-jobs                         E:\DBA\jobs\log_jobs_unilab_stop.log
                                                                E:\DBA\jobs\log_jobs_interspec_stop.log


3)download & installeer windows-updates via server-panel (LET OP: NOG GEEN HERSTART!!!)

4)installeer db-wijzigingen op IS61 en U611			E:\DBA\releases

5)shutdown alle databases 					E:\DBA\dba-db-stop-services-incl-jobs-oracleprod.bat
6)controleer de log-files van shutdown db                       E:\DBA\log-dba-db-shutdown-IS61.log
                                                                E:\DBA\log-dba-db-shutdown-U611.log
                                                                E:\DBA\log-dba-db-shutdown-REPM.log

7)RESTART van windows-server ORACLEPROD vanuit controlepanel-update-window

8)Open apart CMD-window op je eigen laptop/kantoorwerkplek 
  om te ping naar ORACLEPROD om te zien of deze weer up is	ping oracleprod

optioneel:
9)controleer via controlpanel-updates of er nog windows-updates
  klaar staan. Installeer deze. RESTART server evt. nogmaals

Indien alle windows-updates geinstalleerd:
10)shutdown de databases nogmaals.				E:\DBA\dba-db-stop-services-incl-jobs.bat
   DB wordt automatisch door windows gestart. In her verleden
   gebeurde dit obv PFILE, handmatig herstart nodig voor PFILE.

11)start alle databases incl. DB-JOBS				E:\DBA\dba-db-start-services-incl-jobs-oracleprod.bat
   (volgorde van starten van db maakt niet uit, zolang db-jobs maar uitgezet zijn voor stoppen van db...)
   (start daarna eerst de UNILAB-jobs en daarna pas de INTERSPEC-jobs !)

12)Controleer IS61 en U611 of interface/db-jobs goed werken.
   (door verkeerde-taalinstelling of dblink-issue kunnen 
    processen in oneindige LOOP komen waarin heel veel 
    ERROR-LOGGING gegenereerd wordt.)

   Controleer IS61-LOG-SWITCHES					SQL*DEVELOPER: IS61.AV_DBA_MONITOR_LOG_SWITCHES
   Controleer IS61-BAD-events tbv UNILAB                        SQL*DEVELOPER: IS61.AV_DBA_MONITOR_LIMSJOB_ACTIVE

   Controleer U611-LOG-SWITCHES					SQL*DEVELOPER: U611.AV_DBA_MONITOR_LOG_SWITCHES
   Controleer U611-JOBS-met-verkeerd-data-format                SQL*DEVELOPER: U611.AV_DBA_MONITOR_GETSCMETHOD_ERR

13)Controleer of je met UNILAB/INTERSPEC connectie kunt maken.	


Indien alles OK:
14)Restart LIMS-REPORTSERVER                                    "RDP LIMSREPORT_64" + LOGIN & RESTART-server



--einde
  