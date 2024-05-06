--********************************************************
--welke gebruikers zitten in ROLE ?
--
SELECT u.usename
,      gr.groname 
FROM pg_user u
,    pg_group gr
WHERE u.usesysid = ANY(gr.grolist)
AND gr.groname in (SELECT DISTINCT gr2.groname from pg_group gr2 where gr2.groname = 'grp_ens_lims_self_service_users' )
ORDER by u.usename
,        gr.groname;


--welke USERS bestaan er?
SELECT u.usename
from pg_user u
order by usename
;
--oa:
--usr_fea_simulation


--welke ROLLEN heeft een gebruiker?
SELECT u.usename
,      gr.groname 
FROM pg_user u
,    pg_group gr
WHERE u.usesysid = ANY(gr.grolist)
--AND gr.groname in (SELECT DISTINCT gr2.groname from pg_group gr2 where gr2.groname = 'grp_ens_lims_self_service_users' )
AND  u.usename like '%fea%'
ORDER by u.usename
,        gr.groname
;



