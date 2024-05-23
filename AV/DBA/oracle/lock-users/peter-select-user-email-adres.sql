--interspec-email-addressen
select user_id ||';'|| forename ||';'|| last_name ||';'|| email_address ||';'|| user_dropped ||';'
from application_user
order by user_id
;  
--
select substr(email_address,instr(email_address,'@')+1) , count(*)
from application_user
group by substr(email_address,instr(email_address,'@')+1);
/*
<null>					113
apollotyres.com			328
vredestein.com			9
APOLLOTYRES.COM			6
apollovredestein.com	128
Apollotyres.com			5
Vredestein.com			7
*/

--UNILAB.
select ad ||';'|| ad_tp ||';'|| person ||';'|| email ||';'|| active ||';'
from utad
order by AD
;
--
select substr(email,instr(email,'@')+1) , count(*)
from utad
group by substr(email,instr(email,'@')+1);
/*
<null>					21
apollotyres.com			377
vredestein.com			88
"apollotyres.com	"	1
atosorigin.com			1
apollotyres.com 		1
APOLLOTYRES.COM			4
ats-global.com			2
apollovredestein.com	113
Apollotyres.com			3
Vredestein.com			8
*/


--bijwerken van email-adressen naar apollotyres.COM
--INTERSPEC
select SUBSTR(email_address,1,instr(email_address,'@')-1) from application_user;
--
update  application_user
SET email_address = SUBSTR(email_address,1,instr(email_address,'@')-1)||'@appollotyres.com'
where email_address like '@apollovredestein.com'
or    UPPER(email_address) like '%@VREDESTEIN.COM'
;


--UNILAB:
select SUBSTR(EMAIL,1,instr(email,'@')-1) from utad;
--
update  UTAD
SET EMAIL = SUBSTR(EMAIL,1,instr(email,'@')-1)||'@appollotyres.com'
where email like '%apollovredestein.com'
or    UPPER(email) like '%@VREDESTEIN.COM'
;


prompt 
prompt einde script
prompt

