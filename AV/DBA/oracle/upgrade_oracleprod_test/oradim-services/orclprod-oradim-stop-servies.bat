rem stoppen van services:
rem

C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -shutdown -sid U611 -usrpwd moonflower -shutmode immediate -log oradimU611.log  
pause
C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -shutdown -sid SI61 -usrpwd moonflower -shutmode immediate -log oradimIS61.log 
pause
C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -shutdown -sid REPM -usrpwd moonflower -shutmode immediate -log oradimREPM.log 
pause


