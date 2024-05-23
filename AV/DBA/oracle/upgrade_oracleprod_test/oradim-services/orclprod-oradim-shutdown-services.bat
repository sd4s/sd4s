rem stoppen van services:
rem (bij stoppen services is geen password nodig -usrpwd moonflower)
C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -shutdown -sid U611 -usrpwd moonflower  -shutttype SRVC,INST  -shutmode immediate -log oradimU611.log  
pause
C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -shutdown -sid SI61 -usrpwd moonflower  -shutttype SRVC,INST  -shutmode immediate -log oradimIS61.log 
pause
C:\Oracle\product\11.2.0\dbhome_1\bin\oradim.exe -shutdown -sid REPM  -usrpwd moonflower -shuttype inst  -shutmode Immediate -log oradimREPM.log 
pause


