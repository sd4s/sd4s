set %Gebruiker=peter.schepens@apollotyres.com
set %Wachtwoord=spat!al015

net use m: \\oracleprod_test  /persistent:yes    /user:%Gebruiker% %Wachtwoord%
pause

net use m: /delete 
net use m: \\oracleprod_test\e$\DBA  /persistent:yes    /user:peter.schepens@apollotyres.com  spat!al015
pause

