iterror:
--meldingen die ik krijg voordat databases gereboot zijn (met jobs active op INTERSPC/UNILAB) :
ORACLEPROD_TEST	IUINTERFACE	INTERSPEC <-> LIMS	PA_LIMS	INTERSPC	26-07-2021 05:14:53	Unable to transfer the update of specification with part_no "XEF_E17B197A_FEA" | revision=3 for plant "" (Error code : User-Defined Exception).
ORACLEPROD_TEST	IUINTERFACE	INTERSPEC <-> LIMS	PA_LIMS	INTERSPC	26-07-2021 05:14:53	Unable to retrieve the standard attributes of sample type "TEF_H215/65R16XPRT" | version=0001.02 | description="Xpert Test xpert test" (Error code : 1).
ORACLEPROD_TEST	IUINTERFACE	INTERSPEC <-> LIMS	PA_LIMS	INTERSPC	26-07-2021 05:14:53	Unable to transfer the update of specification with part_no "TEF_H215/65R16XPRT" | revision=1 for plant "" (Error code : User-Defined Exception).
ORACLEPROD_TEST	IUINTERFACE	INTERSPEC <-> LIMS	PA_LIMS	INTERSPC	26-07-2021 05:14:53	Unable to retrieve the standard attributes of sample type "XEF_E17B197A_FEA" | version=0003.01 | description="225/35R18 87Y XL Ultrac Satin" (Error code : 1).
ORACLEPROD_TEST	IUINTERFACE	INTERSPEC <-> LIMS	PA_LIMS	INTERSPC	26-07-2021 05:14:53	Unable to transfer the update of specification with part_no "XEF_E17B197A_FEA" | revision=3 for plant "" (Error code : User-Defined Exception).
ORACLEPROD_TEST	IUINTERFACE	INTERSPEC <-> LIMS	PA_LIMS	INTERSPC	26-07-2021 05:14:53	Unable to retrieve the standard attributes of sample type "TEF_H215/65R16XPRT" | version=0001.02 | description="Xpert Test xpert test" (Error code : 1).
ORACLEPROD_TEST	IUINTERFACE	INTERSPEC <-> LIMS	PA_LIMS	INTERSPC	26-07-2021 05:14:53	Unable to transfer the update of specification with part_no "TEF_H215/65R16XPRT" | revision=1 for plant "" (Error code : User-Defined Exception).

--db GEREBOOT, DB-GESTART, EN ALLEEN INTERSPEC-JOBS GESTART:
88187	ORACLEPROD_TEST	MAIL JOB	iapiEmail	SendEmail	INTERSPC	26-07-2021 05:23:57	Failed to send mail due to the following error: ORA-24247: network access denied by access control list (ACL)
88188	ORACLEPROD_TEST	MAIL JOB	iapiEmail	SendEmails	INTERSPC	26-07-2021 05:23:57	"ORA-29278: SMTP transient error: 421 Service not available   ORA-24247: network access denied by access control list (ACL)"
--
88185	ORACLEPROD_TEST	IUINTERFACE	INTERSPEC <-> LIMS	PA_LIMS	INTERSPC	26-07-2021 05:23:56	Unable to transfer the configuration
88184	ORACLEPROD_TEST	IUINTERFACE	INTERSPEC <-> LIMS	PA_LIMS	INTERSPC	26-07-2021 05:23:56	Unable to initialize the DB API for the plant "ENS" SetConnection@LNK_LIMS returned: 42
88186	ORACLEPROD_TEST	IUINTERFACE	INTERSPEC <-> LIMS	PA_LIMS	INTERSPC	26-07-2021 05:23:56	Unable to initialize the DB API for the plant "ENS" SetConnection@LNK_LIMS returned: 42

--mail-error heeft te maken met aanpassingen patrick
--Er gaat hier dus wel iets mis met aanmaken van db-link LIMS-INTERFACE naar UNILAB...


SELECT USER FROM DUAL@U611.REGRESS.RDBMS.DEV.US.ORACLE.COM          ;

/*
OWNER		INTERSPC
DB_LINK		U611.REGRESS.RDBMS.DEV.US.ORACLE.COM
USERNAME	UNILAB
HOST		U611
CREATED		12-04-2014 10:15:21
*/


deze dblink is dus waarschijnlijk nog aangemaakt met het OUDE password.

alter user UNILAB identified by moonflower;
alter user INTERSPC identified by moonflower;

l_dblink_user := 'LIMS';
l_dblink_password := 'l1ms';





--*************************************************************************************************
--*************************************************************************************************
onderzoek:	PA_LIMS.FUNCTION f_SetUpLimsConnection( a_plant    IN plant.plant%TYPE )


--vullen van 
OPEN l_get_conf_setting_cursor('CUSTOMSETCONNECTION');

SELECT parameter_data
FROM interspc_cfg
WHERE section = 'U4 INTERFACE'
AND parameter = 'CUSTOMSETCONNECTION';
--RESULT=NULL			

			
--
         l_client_id := 'unknown';  --SUBSTR(USERENV('TERMINAL')||l_customsetcon_parameter,1,30); 
         l_password := NULL;
         l_applic := 'Interspc';  
         l_numeric_characters := 'DB';
         l_timezone := 'SERVER';
         l_date_format := f_GetDateFormat;
								SELECT setting_value
								FROM UVSYSTEM@LNK_LIMS
								WHERE setting_name = 'JOBS_DATE_FORMAT';
								=> "DDfx/fxMM/RR HH24fx:fxMI:SS"
		 
         --timezone could not be used for backward compatibility reason
		 --
		 L_SETCON_USERNAME = NULL;   --wordt nergens gevuld...
		 L_UP = NULL;   --WORDT NERGENS GEVULD....
		 L_USER_PROFILE = NULL;   -- WORDT NERGENS GEVULD....
		 L_LANGUAGE = NULL;      --WORDT NERGENS GEVULD...
		 L_TK = NULL;          --WORDT NERGENS GEVULD....
		 
         l_return_value := UNAPIGEN.SETCONNECTION@LNK_LIMS(a_client_id =>l_client_id,
                                                            a_us => l_setcon_username, 
                                                            a_password => l_password, 
                                                            a_applic => l_applic,
                                                            a_numeric_characters => l_numeric_characters,
                                                            a_date_format => l_date_format,
                                                            a_up => l_up,
                                                            a_user_profile => l_user_profile,
                                                            a_language => l_language,
                                                            a_tk => l_tk);
															

L_US := A_US;
L_INSTALL_BUSY := '0';
L_TIMEZONE := '';

RETURN ( UNAPIGEN.SETCONNECTION4INSTALL(A_CLIENT_ID          => A_CLIENT_ID,
                                A_US                 => L_US,
                                A_APPLIC             => A_APPLIC,
                                A_NUMERIC_CHARACTERS => A_NUMERIC_CHARACTERS,
                                A_DATE_FORMAT        => A_DATE_FORMAT,
                                A_TIMEZONE           => L_TIMEZONE,
                                A_UP                 => A_UP,
                                A_USER_PROFILE       => A_USER_PROFILE,
                                A_LANGUAGE           => A_LANGUAGE,
                                A_TK                 => A_TK,
                                A_INSTALL_BUSY       => L_INSTALL_BUSY));








