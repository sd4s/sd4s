rem MAAK DIRECT CONNECTIE met ORACLEPROD_TEST !!!
rem Create credentials
cmdkey /generic:"oracleprod_test" /user:"peter.schepens@apollotyres.com" /pass:"spat!al006"
REM pause
rem Connect MSTSC with servername and credentials created before
rem 
mstsc /v:oracleprod_test /admin
REM pause
rem  Delete the credentials after MSTSC session is done
cmdkey /delete:TERMSRV/oracleprod_test
pause

