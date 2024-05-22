--ACL werkzaamheden als user SYSTEM uitvoeren !!!
--nieuwe EMAIL-SMTP-SERVER om als port-forwarding te dienen richting OFFICE-365-MAIL !!
--MAILhost: 18.208.22.77


set linesize 300
set pages 999
column host format a30
column acl format a50

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
--
--ORACLEPROD:
HOST                           LOWER_PORT UPPER_PORT ACL                                             ACLID
------------------------------ ---------- ---------- -------------------------------------------------- --------------------------------
172.16.0.5                             25         25 /sys/acls/mailserver_Interspec_acl.xml          93CC7D3334D14249A5B842D091A60CCA
172.30.99.99                           25         25 /sys/acls/mailserver_Interspec_acl.xml          93CC7D3334D14249A5B842D091A60CCA
172.30.2.5                             25         25 /sys/acls/mailserver_Interspec_acl.xml          93CC7D3334D14249A5B842D091A60CCA
*/


set linesize 300
set pages 999
column host format a30
column acl format a50

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
18.208.22.77			25		25		/sys/acls/mailserver_u_acl.xml	8E47A68553AE45EFB83E72B39D270612
--
--ORACLEPROD:
HOST                           LOWER_PORT UPPER_PORT ACL                                             ACLID
------------------------------ ---------- ---------- -------------------------------------------------- --------------------------------
ensidoc.vredestein.com                 80       8080 /sys/acls/httpacl.xml                           90839E28F63344CA865C71BAF98ACBC1
172.30.0.37                            80       8080 /sys/acls/httpacl.xml                           90839E28F63344CA865C71BAF98ACBC1
172.30.65.137                          80       8080 /sys/acls/httpacl.xml                           90839E28F63344CA865C71BAF98ACBC1
172.30.30.3                            80       8080 /sys/acls/httpacl.xml                           90839E28F63344CA865C71BAF98ACBC1
172.30.69.44                           80       8080 /sys/acls/httpacl.xml                           90839E28F63344CA865C71BAF98ACBC1
172.30.0.9                           8080       8080 /sys/acls/httpacl.xml                           90839E28F63344CA865C71BAF98ACBC1
testupload.vredestein.com              80       8080 /sys/acls/httpacl.xml                           90839E28F63344CA865C71BAF98ACBC1
172.30.2.5                             25         25 /sys/acls/mailserver_u_acl.xml                  8E47A68553AE45EFB83E72B39D270612
172.16.0.5                             25         25 /sys/acls/mailserver_u_acl.xml                  8E47A68553AE45EFB83E72B39D270612

*/


--*********************************************************
--OPVRAGEN HUIDIGE VULLING ACL-RECHTEN !!!
--*********************************************************
--interspec
SELECT * FROM dba_network_acl_privileges where principal='INTERSPC';
/*
--ORACLEPROD_TEST:
/sys/acls/mailserver_Interspec_acl.xml	93CC7D3334D14249A5B842D091A60CCA	INTERSPC	connect	true	false		
--ORACLEPROD:
/sys/acls/mailserver_Interspec_acl.xml 93CC7D3334D14249A5B842D091A60CCA     INTERSPC    connect true    false
*/

--UNILAB
SELECT * FROM dba_network_acl_privileges where principal='UNILAB';
/*
--ORACLEPROD_TEST:
/sys/acls/httpacl.xml	        90839E28F63344CA865C71BAF98ACBC1	UNILAB	connect	true	false		
/sys/acls/mailserver_u_acl.xml	8E47A68553AE45EFB83E72B39D270612	UNILAB	connect	true	false		
--ORACLEPROD:
/sys/acls/httpacl.xml           90839E28F63344CA865C71BAF98ACBC1    UNILAB  connect true    false
/sys/acls/mailserver_u_acl.xml  8E47A68553AE45EFB83E72B39D270612    UNILAB  connect true    false
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
/
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
/
--
commit;


--*************************
--UNILAB
--*************************

--assign UNILAB-ACL voor de NIEUWE MAILHOST
BEGIN
dbms_network_acl_admin.assign_acl (
acl => 'mailserver_u_acl.xml',
host => '18.208.22.77', 
lower_port => 25,
upper_port => 25
);
END;
/
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






--**************************************************
--AANPASSINGEN INTERSPEC.INTERSPC_CFG
--**************************************************
--SELECT * FROM INTERSPC_CFG WHERE section='interspec' and parameter in ('def_email_ext','email_sender','mailhost');
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


update INTERSPC_CFG set parameter_data='apollotyres.com'           where parameter =  'def_email_ext'  ;   --AND parameter_data='@apollotyres.com';
update INTERSPC_CFG set parameter_data='interspec@apollotyres.com'  where parameter =  'email_sender'  ;   --AND parameter_data='interspec@apollovredestein.com' ;
update INTERSPC_CFG set parameter_data='172.19.1.160'               where parameter =  'mailhost'      ;   --AND parameter_data='18.208.22.77'   --AND parameter_data='172.30.2.5' ;
COMMIT;
--SELECT * FROM INTERSPC_CFG WHERE section='interspec' and parameter in ('def_email_ext','email_sender','mailhost');



--**************************************************
--AANPASSINGEN UNILAB.UTSYSTEM:   
--**************************************************
--SELECT * FROM UTSYSTEM WHERE SETTING_NAME LIKE 'SMTP%';
--

WAS:
SMTP_DOMAIN		vredestein.com
SMTP_INTERVAL	(1/24)
SMTP_SENDER		unilab@vredestein.com
SMTP_SERVER		172.30.2.5

WORDT op 29-07-2021:
SMTP_DOMAIN		apollotyres.com
SMTP_INTERVAL	(1/24)
SMTP_SENDER		unilab@apollotyres.com
SMTP_SERVER		18.208.22.77

WORDT op 03-02-2022:
SMTP_DOMAIN		apollotyres.com
SMTP_INTERVAL	(1/24)
SMTP_SENDER		unilab_TEST@apollotyres.com
SMTP_SERVER		172.19.1.160

update utsystem set setting_value='apollotyres.com'         where setting_NAME =  'SMTP_DOMAIN' ;   --AND setting_value='vredestein.com';
update utsystem set setting_value='unilab@apollotyres.com'  where setting_NAME =  'SMTP_SENDER' ;   --AND setting_value='unilab@vredestein.com' ;
update utsystem set setting_value='172.19.1.160'            where setting_NAME =  'SMTP_SERVER' ;   --AND setting_value='18.208.22.77';  AND setting_value='172.30.2.5';
COMMIT;

--SELECT * FROM UTSYSTEM WHERE SETTING_NAME LIKE 'SMTP%';



--einde script

