rem CREATE services:
C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -new -sid U611 -pfile C:\Oracle\product\11.2.0\dbhome_1\database\initU611.ora -log oradimU611.log  
pause
C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -new -sid SI61 -pfile C:\Oracle\product\11.2.0\dbhome_1\database\initSI61.ora -log oradimIS61.log  
pause
C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -new -sid REPM -pfile C:\Oracle\product\11.2.0\dbhome_1\database\initREPM.ora -log oradimREPM.log 
pause



