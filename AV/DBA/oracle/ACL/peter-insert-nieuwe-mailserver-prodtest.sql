--ACL werkzaamheden als user SYSTEM uitvoeren !!!
--nieuwe EMAIL-SMTP-SERVER om als port-forwarding te dienen richting OFFICE-365-MAIL !!
--MAILhost: 18.208.22.77


COLUMN HOST FORMAT A50
COLUMN ACL FORMAT A40

--*********************************************************
--OPVRAGEN HUIDIGE VULLING ACL !!!
--controle ACL
--*********************************************************
--interspec:
select * from dba_network_acls;
/*
--ORACLEPROD_TEST:
172.16.0.5		25	25	/sys/acls/mailserver_Interspec_acl.xml	93CC7D3334D14249A5B842D091A60CCA
172.30.99.99	25	25	/sys/acls/mailserver_Interspec_acl.xml	93CC7D3334D14249A5B842D091A60CCA
172.30.2.5		25	25	/sys/acls/mailserver_Interspec_acl.xml	93CC7D3334D14249A5B842D091A60CCA
*/

--unilab:
select * from dba_network_acls;
/*
--ORACLEPROD_TEST:
testupload.vredestein.com	80	8080	/sys/acls/httpacl.xml			90839E28F63344CA865C71BAF98ACBC1
172.16.0.5				25		25		/sys/acls/mailserver_u_acl.xml	8E47A68553AE45EFB83E72B39D270612
172.30.2.5				25		25		/sys/acls/mailserver_u_acl.xml	8E47A68553AE45EFB83E72B39D270612
172.30.0.9				8080	8080	/sys/acls/httpacl.xml			90839E28F63344CA865C71BAF98ACBC1
172.30.69.44			80		8080	/sys/acls/httpacl.xml			90839E28F63344CA865C71BAF98ACBC1
172.30.30.3				80		8080	/sys/acls/httpacl.xml			90839E28F63344CA865C71BAF98ACBC1
172.30.65.137			80		8080	/sys/acls/httpacl.xml			90839E28F63344CA865C71BAF98ACBC1
ensidoc.vredestein.com					/sys/acls/httpacl.xml			90839E28F63344CA865C71BAF98ACBC1
18.208.22.77			25		25		/sys/acls/mailserver_u_acl.xml	8E47A68553AE45EFB83E72B39D270612*/
*/


--*********************************************************
--OPVRAGEN HUIDIGE VULLING ACL-RECHTEN !!!
--*********************************************************
--interspec
SELECT * FROM dba_network_acl_privileges where principal='INTERSPC';
/*
--ORACLEPROD_TEST:
/sys/acls/mailserver_Interspec_acl.xml	93CC7D3334D14249A5B842D091A60CCA	INTERSPC	connect	true	false		
*/

--UNILAB
SELECT * FROM dba_network_acl_privileges where principal='UNILAB';
/*
--ORACLEPROD_TEST:
/sys/acls/httpacl.xml	        90839E28F63344CA865C71BAF98ACBC1	UNILAB	connect	true	false		
/sys/acls/mailserver_u_acl.xml	8E47A68553AE45EFB83E72B39D270612	UNILAB	connect	true	false		
*/




--*********************************************************
--uitdelen rechten ACL, is voor INTERSPC al gebeurd (hoeft dus waarschijnlijk niet meer te gebeuren):
--*********************************************************
--rechten interspec
begin
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'mailserver_Interspec_acl.xml',
principal => 'INTERSPC',
is_grant => true,
privilege => 'connect');
end;
/
commit;

--rechten unilab
begin
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'mailserver_u_acl.xml',
principal => 'UNILAB',
is_grant => true,
privilege => 'connect');
end;
/
commit;


--*********************************************************
--TOEVOEGEN ACL-MAILSERVER OP INTERSPEC + UNILAB.
--LET OP: DEZE ZIJN VOOR INTERSPEC + UNILAB NIET GELIJK AAN ELKAAR...
--*********************************************************

--*************************
--INTERSPEC
--*************************

--assign INTERSPEC-ACL voor de NIEUWE MAILHOST
BEGIN
dbms_network_acl_admin.assign_acl (
acl => 'mailserver_Interspec_acl.xml',
host => '18.208.22.77', 
lower_port => 25,
upper_port => 25
);
END;
--
commit;

--assign INTERSPEC-ACL voor de nieuwe MAILSERVER-MICROSOFT (dd. 01-02-2022)
BEGIN
dbms_network_acl_admin.assign_acl (
acl => 'mailserver_Interspec_acl.xml',
host => '172.19.1.160', 
lower_port => 25,
upper_port => 25
);
END;
--
commit;



--assign INTERSPEC-ACL voor de nieuwe MAILSERVER-MICROSOFT (dd. 08-02-2022)
BEGIN
dbms_network_acl_admin.assign_acl (
acl => 'mailserver_Interspec_acl.xml',
host => 'apollotyres-com.mail.protection.outlook.com', 
lower_port => 25,
upper_port => 25
);
END;
/
--
commit;



--*************************
--UNILAB
--*************************

--assign UNILAB-ACL voor de NIEUWE MAILHOST voor eindgebruikers via MICROSOFT-OUTLOOK.
BEGIN
dbms_network_acl_admin.assign_acl (
acl => 'mailserver_u_acl.xml',
host => '18.208.22.77', 
lower_port => 25,
upper_port => 25
);
END;
--
commit;

--assign UNILAB-ACL voor de nieuwe MAILSERVER-MICROSOFT (dd. 01-02-2022)
BEGIN
dbms_network_acl_admin.assign_acl (
acl => 'mailserver_u_acl.xml',
host => '172.19.1.160', 
lower_port => 25,
upper_port => 25
);
END;
/

--
commit;


--assign UNILAB-ACL voor de nieuwe MAILSERVER-MICROSOFT (dd. 08-02-2022) obv DNS-naam
BEGIN
dbms_network_acl_admin.assign_acl (
acl => 'mailserver_u_acl.xml',
host => 'apollotyres-com.mail.protection.outlook.com', 
lower_port => 25,
upper_port => 25
);
END;
/
--
commit;


--172.30.69.88:8080
--assign UNILAB-ACL voor de nieuwe TEST-MAILSERVER voor WMS-interface OUTDOOR-TESTING (Wilfred Geerling) vanuit DB-TRIGGERS !
BEGIN
dbms_network_acl_admin.assign_acl (
acl => 'httpacl.xml',
host => '172.30.69.88', 
lower_port => 8080,
upper_port => 8080
);
END;
/
--
commit;


--**********************************************
--172.30.0.37:8090	
--assign LIMSCLIENT op port=809 tbv WMS-mail-interface op de ORACLEPROD_TEST. (zat voor 10-06-2022 op laptop WILFRED):
--
BEGIN
dbms_network_acl_admin.assign_acl (
acl => 'httpacl.xml',
host => '172.30.0.37', 
lower_port => 8090,
upper_port => 8090
);
END;
/
--
commit;



--**************************************************
--AANPASSINGEN INTERSPEC.INTERSPC_CFG
--**************************************************
select * from interspc_cfg where parameter like '%mail%';

WAS:
interspec	def_email_ext			@vredestein.com	
interspec	email_sender			interspec@apollovredestein.com
interspec	mailhost				172.30.2.5	

WORDT op 29-07-2021:
interspec	def_email_ext			@apollotyres.com	
interspec	email_sender			patrick.goossens@apollotyres.com	
interspec	mailhost				18.208.22.77	

WORDT op 01-02-2022:
interspec	def_email_ext			apollotyres.com		  (let op: DOMEIN ZONDER EEN "@" !!!!)
interspec	email_sender			interspec_TEST@apollotyres.com	
interspec	mailhost				172.19.1.160	

WORDT op 08-02-2022:
interspec	def_email_ext			apollotyres.com		  (let op: DOMEIN ZONDER EEN "@" !!!!)
interspec	email_sender			interspec_TEST@apollotyres.com	
interspec	mailhost				apollotyres-com.mail.protection.outlook.com		(LET OP: KUN JE NIET PINGEN, HANGEN MEERDERE IP-ADRESSEN ACHTER !!!)	


update interspc.INTERSPC_CFG set parameter_data='apollotyres.com'                             where parameter =  'def_email_ext'  ;   
update interspc.INTERSPC_CFG set parameter_data='interspec_TEST@apollotyres.com'              where parameter =  'email_sender'  ;   
update interspc.INTERSPC_CFG set parameter_data='apollotyres-com.mail.protection.outlook.com' where parameter =  'mailhost'      ;  
COMMIT;

set linesize 200
set parameter_data format a50
SELECT * FROM interspc.INTERSPC_CFG WHERE section='interspec' and parameter in ('def_email_ext','email_sender','mailhost');


--**************************************************
--AANPASSINGEN UNILAB.UTSYSTEM:   
--**************************************************
--SELECT * FROM UTSYSTEM WHERE SETTING_NAME LIKE 'SMTP%';

WAS:
SMTP_DOMAIN		vredestein.com
SMTP_INTERVAL	(1/24)
SMTP_SENDER		unilab@vredestein.com
SMTP_SERVER		172.30.2.5

WORDT op 29-07-2021:
SMTP_DOMAIN		apollotyres.com
SMTP_INTERVAL	(1/24)
SMTP_SENDER		patrick.goossens@apollotyres.com
SMTP_SERVER		18.208.22.77

WORDT op 03-02-2022:
SMTP_DOMAIN		apollotyres.com					 (let op: DOMEIN ZONDER EEN "@" !!!!)
SMTP_INTERVAL	(1/24)
SMTP_SENDER		unilab_TEST@apollotyres.com
SMTP_SERVER		172.19.1.160

WORDT op 08-02-2022:
SMTP_DOMAIN		apollotyres.com									 (let op: DOMEIN ZONDER EEN "@" !!!!)
SMTP_INTERVAL	(1/24)
SMTP_SENDER		unilab_TEST@apollotyres.com
SMTP_SERVER		apollotyres-com.mail.protection.outlook.com		(LET OP: DNS-NAME KUN JE NIET PINGEN, HANGEN MEERDERE IP-ADRESSEN ACHTER !!!)	


update unilab.utsystem set setting_value='apollotyres.com'                              where setting_NAME =  'SMTP_DOMAIN' ;   
update unilab.utsystem set setting_value='unilab_TEST@apollotyres.com'                  where setting_NAME =  'SMTP_SENDER' ;  
update unilab.utsystem set setting_value='apollotyres-com.mail.protection.outlook.com'  where setting_NAME =  'SMTP_SERVER' ;   
COMMIT;

set linesize 200
column setting_value format a50
SELECT * FROM unilab.UTSYSTEM WHERE SETTING_NAME LIKE 'SMTP%';


--einde script

