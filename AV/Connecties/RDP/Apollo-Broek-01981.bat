rem MAAK DIRECT CONNECTIE vanuit laptop SCHEPENS_01820.apollotyres.com met KANTOOR-PC BROEK-01981.apollotyres.com !!!
rem Create credentials
cmdkey /generic:"Broek_01981" /user:"peter.schepens@apollotyres.com" /pass:"spat!al015"
REM pause
rem Connect MSTSC with servername and credentials created before
rem 
mstsc /v:Broek_01981 /admin
pause
rem evt. met NET-USE commando een mapping terug maken naar local-computer:
rem net use X:  \\schepens_01820\c:  spat!al007  /user:apollotyres\peter.schepens 

rem  Delete the credentials after MSTSC session is done
cmdkey /delete:TERMSRV/Broek_01981
pause

