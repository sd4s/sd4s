rem starten van Services:
rem (OPTIE = -nocheck 0  even weggehaald...)
C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -startup -sid U611 -usrpwd moonflower -startmode AUTO  -starttype SRVC,INST -pfile C:\Oracle\product\11.2.0\dbhome_1\database\initU611.ora -log oradimU611.log 
pause
C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -startup -sid IS61 -usrpwd moonflower -startmode AUTO  -starttype SRVC,INST -pfile C:\Oracle\product\11.2.0\dbhome_1\database\initIS61.ora -log oradimIS61.log  
pause
C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -startup -sid REPM -usrpwd moonflower -starttype srvc  -pfile C:\Oracle\product\11.2.0\dbhome_1\database\initREPM.ora -log oradimREPM.log  
pause


