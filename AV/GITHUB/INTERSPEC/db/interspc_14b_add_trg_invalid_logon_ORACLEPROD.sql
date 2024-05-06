--------------------------------------------------------
--  File created - 2021-07-21  
--------------------------------------------------------
-- script uitvoeren als user SYS !!
-- Met kopie/paste naar ORACLEPROD-sqlplus lukt het niet, dus save script en run SCRIPT vanaf ORACLEPROD !!
--------------------------------------------------------


--Aanpassingen nodig in:
1)batch-files + snelkoppelingen op ORACLEPROD_TEST   DBA-DIRECTORY
2)Interfaces ATHENA (webfocus) en WMS  (Alban + Wilfred hierover informeren)

--Unilab registreert VALID-LOGINS in table: AT_SESSIONS by after-logon-db-trigger SYS.TR_DATABASE_LOGON and via UNILAB.UNSESSION.LOGON
--Interspec registreert VALID-LOGINS in table: AT_SESSIONS by after-logon-db-trigger SYS.TR_DATABASE_LOGON and via UNILAB.AAPISESSION.LOGON


--implementatie van invalid-login-detectie...
select * from all_triggers where owner='SYS' ;

--table aanmaken als SCHEMA-owner UNILAB/INTERSPC
DROP TABLE DBA_INVALID_LOGON  CASCADE CONSTRAINTS;
--
CREATE TABLE DBA_INVALID_LOGON
(
  USERNAME   VARCHAR2(100 BYTE),
  USERHOST   VARCHAR2(128 BYTE),
  TIMESTAMP  DATE
);


--db-trigger aanmaken als SYS-user.
DROP TRIGGER DBA_INVALID_LOGON_TRIGGER;
--

--
--INTERSPC-VERSIE:
CREATE OR REPLACE TRIGGER SYS.DBA_INVALID_LOGON_TRIGGER  
AFTER SERVERERROR ON DATABASE
declare
--trigger om te registreren wie of wat er met een verkeerd password heeft proberen in te loggen...
--zodra er verkeerd user/password gebruikt wordt leggen we deze actie vast.
l_open varchar2(30);
BEGIN
  IF (IS_SERVERERROR(1017)) THEN
    -- ook in snapshot databases kan worden geschreven, dat is ok
    select open_mode
    into l_open
    from v$database;
    --
    if l_open = 'READ WRITE'
    then
	  BEGIN
        INSERT INTO INTERSPC.dba_invalid_logon VALUES(SYS_CONTEXT('USERENV', 'AUTHENTICATED_IDENTITY')||'-'||sys_context ('userenv','OS_USER') , SYS_CONTEXT('USERENV', 'HOST')||'@'||sys_context('userenv','service_name') , SYSDATE);
	    COMMIT;
	  EXCEPTION
	    WHEN OTHERS THEN NULL;
	  END;
    end if;
  END IF;
END;
/



