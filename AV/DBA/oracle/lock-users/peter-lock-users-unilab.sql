--Script om alle ON-LINE INTERSPEC-users te locken...
--Eerst controlerren welke users al gelocked zijn, dit om te voorkomen dat ze evt. later automatisch weer unlocked worden, samen met de rest.

--medewerker-tabel: ITUS
/*
USER_ID		VARCHAR2(20 CHAR)	No
FORENAME	VARCHAR2(20 CHAR)	Yes
LAST_NAME	VARCHAR2(20 CHAR)	Yes
CREATED_ON	DATE	Yes
DELETED_ON	DATE	Yes
*/

set pages 0
set linesize 80

prompt *******************************************************
prompt OVERZICHT VAN ALLE DB-USERS
prompt *******************************************************
select dba.username , dba.account_status
from dba_users  dba
ORDER BY dba.USERNAME
;

prompt *******************************************************
prompt OVERZICHT totaal per account-status
prompt *******************************************************
SELECT dba.account_status, count(*)
from dba_users dba
group by dba.account_status
order by dba.account_status
;
/*
ACCOUNT_STATUS                     COUNT(*)
-------------------------------- ----------
EXPIRED                                  56
EXPIRED & LOCKED                         17
LOCKED                                    2
OPEN                                    391
*/

prompt *******************************************************
prompt OVERZICHT VAN ALLE ACTUELE/LOCKED INTERSPEC-DB-ACCOUNTS
prompt *******************************************************
select dba.username , dba.account_status
from dba_users  dba
,    UTAD       us
where dba.account_status = 'LOCKED'
and   dba.username = us.AD
and   us.ACTIVE = 1
order by dba.username
;
/*
AHE	LOCKED
*/

spool peter-lock-users-unilab.log

set pages 999
set linesize 100

prompt *******************************************************
prompt OVERZICHT VAN ALLE ACTUELE/OPEN UNILAB-DB-ACCOUNTS
prompt *******************************************************
select dba.username , dba.account_status
from dba_users  dba
,    unilab.UTAD       us
where dba.account_status = 'OPEN'
and   dba.username = us.AD
and   us.ACTIVE = 1
order by dba.username
;

prompt *******************************************************
prompt LOCKEN VAN ALLE ACTUELE/OPEN UNILAB-DB-ACCOUNTS
prompt *******************************************************
DECLARE
l_stmnt varchar2(4000);
r_us    sys_refcursor;
l_teller  number := 0;
BEGIN
  for r_us in (select dba.username 
               from dba_users  dba
               ,    unilab.UTAD       us
               where dba.account_status = 'OPEN'
               and   dba.username = us.AD
               and   us.ACTIVE = 1
			   AND   us.AD not in ('UNILAB')
			   and   us.AD not in ('AHE')
               order by dba.username
              )
  LOOP
    l_teller := l_teller + 1;
    l_stmnt := 'ALTER USER '||R_US.USERNAME||' account lock';
	dbms_output.put_line(l_stmnt);
	execute immediate 'ALTER USER '||'"'||R_US.USERNAME||'"'||' account lock' ;
  end loop;
  --
  dbms_output.put_line('TOTAAL USERS GELOCKED: '||l_teller);
END;
/
--test: 383x



prompt *******************************************************
prompt CONTROLE-ACHTERAF: OVERZICHT VAN ALLE ACTUELE/LOCKED UNILAB-DB-ACCOUNTS
prompt *******************************************************
select dba.username , dba.account_status
from dba_users  dba
,    unilab.UTAD       us
where dba.account_status = 'LOCKED'
and   dba.username = us.ad
and   us.active = 1
order by dba.username
;
/*

*/

prompt *******************************************************
prompt CONTROLE-ACHTERAF: OVERZICHT VAN ALLE ACTUELE/OPEN UNILAB-DB-ACCOUNTS
prompt *******************************************************
select dba.username , dba.account_status
from dba_users  dba
,    unilab.UTAD       us
where dba.account_status = 'OPEN'
and   dba.username = us.AD
and   us.ACTIVE = 1
order by dba.username
;

/*
--no rows selected...
*/


spool off;





prompt *******************************************************
prompt UNLOCKEN VAN ALLEEN DE BEHEER/TEST-ACCOUNTS
prompt *******************************************************
SET SERVEROUTPUT ON
DECLARE
l_stmnt varchar2(4000);
r_us    sys_refcursor;
l_teller  number := 0;
BEGIN
  for r_us in (select dba.username 
               from dba_users  dba
               ,    unilab.UTAD       us
               where dba.account_status = 'LOCKED'
               and   dba.username = us.AD
               and   us.ACTIVE = 1
			   and   us.AD in ('PSC','PGO','MVE','MVL','UNILAB')
			   and   us.AD not in ('AHE')
               order by dba.username
              )
  LOOP
    l_teller := l_teller + 1;
    l_stmnt := 'ALTER USER '||R_US.USERNAME||' account unlock';
	dbms_output.put_line(l_stmnt);
	execute immediate 'ALTER USER '||'"'||R_US.USERNAME||'"'||' account unlock' ;
  end loop;
  --
  dbms_output.put_line('TOTAAL USERS GE-UNLOCKED: '||l_teller);
END;
/


prompt *******************************************************
prompt UNLOCKEN VAN ALLE ACTUELE/LOCKED UNILAB-DB-ACCOUNTS
prompt *******************************************************
DECLARE
l_stmnt varchar2(4000);
r_us    sys_refcursor;
l_teller  number := 0;
BEGIN
  for r_us in (select dba.username 
               from dba_users  dba
               ,    unilab.UTAD       us
               where dba.account_status = 'LOCKED'
               and   dba.username = us.AD
               and   us.ACTIVE = 1
			   and   us.AD not in ('AHE')
               order by dba.username
              )
  LOOP
    l_teller := l_teller + 1;
    l_stmnt := 'ALTER USER '||R_US.USERNAME||' account unlock';
	dbms_output.put_line(l_stmnt);
	execute immediate 'ALTER USER '||'"'||R_US.USERNAME||'"'||' account unlock' ;
  end loop;
  --
  dbms_output.put_line('TOTAAL USERS GE-UNLOCKED: '||l_teller);
END;
/


PROMPT
PROMPT EINDE SCRIPT
PROMPT


