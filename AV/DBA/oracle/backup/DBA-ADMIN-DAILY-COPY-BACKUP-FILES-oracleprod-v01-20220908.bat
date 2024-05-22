:: script om alle BACKUP-bestanden IS61/REPM/U611 naar EXTERNE-DISK te kopieren.
:: local-directory: "E:\Backup"
:: external-disk: "G:\Oracleprod_test\Backup"

ECHO DO YOU RUN THIS COPY-BACKUP-SCRIPT AS "RUN AS ADMINISTRATOR"? IF NOT THEN CANCEL THIS ACTION AND START AGAIN !!!!
::@pause

::assign-volume aan Z, Dit is DISK beschikbaar via kantoor-pc BROEK_01981 (staat nu nog uit omdat juiste drive niet direct beschikbaar is...):
::diskpart  /s E:\Backup\diskpartassignvolume.txt >E:\Backup\bck-log\diskpartassignvolume.log
::
::you must allow at least 15 seconds between each script for a complete shutdown of the previous execution 
::before running the diskpart command again in successive scripts
timeout /t 5

@ECHO OFF
::default-TMP-dir:
set basedir="E:\Backup"
::default-BACKUP-dir:
set localdirIS61="%basedir%\IS61"
set localdirREPM="%basedir%\REPM"
set localdirU611="%basedir%\U611"
::default-COPY-BACKUP-dir:
set copydirIS61="Z:\Oracleprod_DbBackUp\Backup\IS61"
set copydirREPM="Z:\Oracleprod_DbBackUp\Backup\REPM"
set copydirU611="Z:\Oracleprod_DbBackUp\Backup\U611"
::
echo basedir is %basedir%
echo localdirIS61 is %localdirIS61%
echo copydirIS61 is %copydirIS61%
echo localdirU611 is %localdirU611%
echo copydirU611 is %copydirU611%
::PAUSE

set CUR_YYYY=%date:~10,4%
set CUR_MM=%date:~4,2%
set CUR_DD=%date:~7,2%
set CUR_HH=%time:~0,2%
if %CUR_HH% lss 10 (set CUR_HH=0%time:~1,1%)
set CUR_NN=%time:~3,2%
set CUR_SS=%time:~6,2%

::echo start script
::pause

:: this is for listing down all the files in localdir-directories:
::dir %localdirIS61% /B
set bckfileIS61=%basedir%\bck-log\backuplist_IS61_%CUR_YYYY%%CUR_MM%%CUR_DD%-%CUR_HH%%CUR_NN%%CUR_SS%.txt
dir %localdirIS61% /B >%bckfileIS61%
if %ERRORLEVEL% NEQ 0 goto ERROR
echo "backupfile-list voor %localdirIS61% aangemaakt"
::pause
::dir %localdirREPM% /B
set bckfileREPM=%basedir%\bck-log\backuplist_REPM_%CUR_YYYY%%CUR_MM%%CUR_DD%-%CUR_HH%%CUR_NN%%CUR_SS%.txt
dir %localdirREPM% /B >%bckfileREPM%
if %ERRORLEVEL% NEQ 0 goto ERROR
echo "backupfile-list voor %localdirREPM% aangemaakt"
::pause
::dir %localdirU611% /B
set bckfileU611=%basedir%\bck-log\backuplist_u611_%CUR_YYYY%%CUR_MM%%CUR_DD%-%CUR_HH%%CUR_NN%%CUR_SS%.txt
dir %localdirU611% /B >%bckfileU611%
if %ERRORLEVEL% NEQ 0 goto ERROR
echo "backupfile-list voor %localdirU611% aangemaakt"


ECHO VERWIJDEREN VAN BAK-FILE VAN UNILAB OUDER DAN 6 DAGEN VAN DE ORACLEPROD... 
ECHO ER PASSEN NIET 2X FULL-BACK OP ORACLEPROD, DUS VOOR HET MAKEN VAN NIEUWE FULL-EXPORT MOET DE VORIGE EERSTE VERWIJDERD WORDEN.
::pause
::forfiles /S /C "cmd /c if @fsize GTR 1048576 echo @path"
::ForFiles  /s /d -2 /c "cmd /c if @fsize GTR 200000000 echo @file"
ForFiles /p %localdirU611% /s /d -6 /c "cmd /c if @fsize GTR 200000000 echo @file"
ForFiles /p %localdirU611% /s /d -6 /c "cmd /c if @fsize GTR 200000000 del @file"



ECHO START COPY BACKUP-FILES...

:COPY_BACKUP_IS61
if NOT exist %copydirIS61%  (
   goto :NOTTHERE
   )
if exist %copydirIS61%  (
   ::Alleen nieuwere files kopieren, incl. subdirectory EN zonder bevestiging indien al aanwezig. Ook evt. read-only files overschrijven... 
   xcopy %localdirIS61%\*.*  %copydirIS61%  /D /S /Y /r
   echo "Copy van Backup-Files-IS61 is gemaakt ..."
)

:COPY_BACKUP_REPM
if NOT exist %copydirREPM%  (
   goto :NOTTHERE
   )
if exist %copydirREPM%  (
   ::Alleen nieuwere files kopieren, incl. subdirectory EN zonder bevestiging indien al aanwezig. Ook evt. read-only files overschrijven... 
   xcopy %localdirREPM%\*.*  %copydirREPM%  /D /S /Y /r
   echo "Copy van Backup-Files-REPM is gemaakt ..."
)

:COPY_BACKUP_U611
if NOT exist %copydirU611%  (
   goto :NOTTHERE
   )
if exist %copydirU611%  (
   ::Alleen nieuwere files kopieren, incl. subdirectory EN zonder bevestiging indien al aanwezig. Ook evt. read-only files overschrijven... 
   xcopy %localdirU611%\*.*  %copydirU611%  /D /S /Y /r
   echo "Copy van Backup-Files-U611 is gemaakt ..."
)



ECHO VERWIJDEREN VAN EXTERNAL-DISK DE BAK-FILES OUDER DAN 14 DAGEN... (MAX 2X FULL-BAK + INCREMENTAL BEWAREN !!!)
::pause
::forfiles /S /C "cmd /c if @fsize GTR 1048576 echo @path"
::ForFiles  /s /d -2 /c "cmd /c if @fsize GTR 200000000 echo @file"
ForFiles /p %copydirIS61% /s /d -14 /c "cmd /c echo @file"
ForFiles /p %copydirREPM% /s /d -14 /c "cmd /c echo @file"
ForFiles /p %copydirU611% /s /d -14 /c "cmd /c echo @file"
::
ForFiles /p %copydirIS61% /s /d -14 /c "cmd /c del @file"
ForFiles /p %copydirREPM% /s /d -14 /c "cmd /c del @file"
ForFiles /p %copydirU611% /s /d -14 /c "cmd /c del @file"
::ForFiles /p "%copydirU611%" /s /d -14 /c "cmd /c if @fsize GTR 200000000 del @file"


ECHO VERWIJDEREN VAN EXTERNAL-DISK MAPPING 
::DE-assign volume Z: (vooralsnog blijft drive-mapping naar de BROEK_01981 gewoon bestaan, dus hoeven hem ook niet te de-attachen...)
::diskpart  /s E:\Backup\diskpartremovevolume.txt >E:\Backup\bck-log\diskpartremovevolume.log


ECHO COPY BACKUP-FILES IS COMPLETED !!!!!!!
::PAUSE
exit

:ERROR
ECHO ERROR: Algemene ERROR...
ECHO ERROR: CHECK ALL BACKUP-DIRECTORIES + BACKUP-FILES ON CONSISTENCY !!!!
::pause
exit

:NOTTHERE
ECHO ERROR: LOCALDIR bestaat niet, IS is niet geinstalleerd...
ECHO ERROR: HF40 CAN ONLY BE AFTER INTERSPEC 6.7 IS INSTALLED CORRECTLY.
::pause
exit
