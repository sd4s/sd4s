CREATE OR REPLACE PACKAGE        AT_WMS 
AS
  PROCEDURE AT_SENDWMS(REQUEST VARCHAR2);
END AT_WMS;
/


CREATE OR REPLACE PACKAGE BODY        AT_WMS 
AS
PROCEDURE AT_SENDWMS(REQUEST VARCHAR2)
AS
--procedure stuurt WMS-MAIL met RQ naar UNILAB2WMS, die daar vervolgens in UNILAB de overige attribuut-info ophaalt
--om daarmee vervolgens een bericht naar het WMS (warehouse-management-systeem) te sturen !!
--aangeroepen vanuit db-triggers: UTRQ.AT_UPD_RQ_WMS_INDOOR
--                                UTRQ.AT_UPD_RQ_PREP
--                                UTSC.AT_UPD_SC_WMS_INDOOR
--                                UTWS.AT_UPD_WS_PREP
--URL van UNILAB2WMS.MAIL wordt gestuurd door SETTING in UTSYSTEM.
--Voor ORACLEPROD:      WMS_URL_PROD        http://172.30.0.37:8080/
--Voor ORACLEPROD_TEST: WMS_URL_PROD_TEST   http://172.30.69.88:8080/
--------------------------------------------------------------------------------
-- VOORDAT MAIL VERZONDEN KAN WORDEN MOET DE MAIL-SERVER IN ACL-LIST ZIJN OPGENOMEN
-- MAAK EVT. EERST EEN ACL="httpacl.xml" AAN:
--begin
--  dbms_network_acl_admin.create_acl (acl          => 'httpacl.xml'
--                                    ,description  => 'Allow HTTP Connectivity'
--									,principal    => 'PUBLIC'
--									,is_grant     => TRUE
--									,privilege    => 'connect');
--  --start_date   => SYSTIMESTAMP,
--  --end_date     => NULL);
--end;
--
-- EN VOEG ER DAN EEN URL AAN ACL="httpacl.xml" TOE:
--begin
-- dbms_network_acl_admin.assign_acl (acl         => 'httpacl.xml'
--                                   ,host        => '172.30.0.37'
--								   ,lower_port  => 80
--								   ,upper_port  => 8080);
--  commit;
--end;
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name  CONSTANT APAOGEN.API_NAME_TYPE := 'AT_WMS'||'.'||'LogError';
--
req   utl_http.req;
resp  utl_http.resp;
value VARCHAR2(1024);
l_server_host      varchar2(1024); 
l_http_url         varchar2(1024);
l_sysdate_vooraf   date;
l_sysdate_achteraf date;
BEGIN
  begin
    SELECT upper(SYS_CONTEXT( 'USERENV','SERVER_HOST')) into l_server_host from dual;
  EXCEPTION
    when others 
	then APAOGEN.LogError (lcs_function_name, 'WMS-bepaal USERENV(server_host) gaat fout');
	     --SPRING NAAR ALG-EXCP.
	     RAISE;
  END;  
  l_sysdate_vooraf := sysdate;
  --Ip-adres WMS-SERVER via WILFRED GEERLING
  if l_server_host = 'ORACLEPROD'
  then
    --dd 06-10-2020: http://172.30.0.37:8080/
    SELECT SETTING_VALUE  INTO l_http_url   FROM UTSYSTEM  WHERE UPPER(SETTING_NAME)=UPPER('WMS_URL_PROD');
  else
    --dd 06-10-2020:http://172.30.69.88:8080/
    SELECT SETTING_VALUE  INTO l_http_url   FROM UTSYSTEM  WHERE UPPER(SETTING_NAME)=UPPER('WMS_URL_PROD_TEST');
  end if;
  --req := utl_http.begin_request('http://172.30.0.37:8080/' || REQUEST);
  req := utl_http.begin_request(l_http_url || REQUEST );
  utl_http.set_header(req, 'User-Agent', 'Mozilla/4.0');
  resp := utl_http.get_response(req);
  --dbms_output.put_line('processing response');
  BEGIN
    LOOP
      utl_http.read_line(resp, value, TRUE);
      --dbms_output.put_line(value);
    END LOOP;
  EXCEPTION
    WHEN UTL_HTTP.end_of_body 
	THEN UTL_HTTP.end_response(resp);
  END;
  l_sysdate_achteraf := sysdate;
  if l_sysdate_achteraf > (l_sysdate_vooraf + (5/60*60*24) ) 
  then
    APAOGEN.LogError (lcs_function_name, 'WMS-DUUR verzenden van WMS-HTTP-BERICHT vanuit trigger UTSC.AT_UPD_SC_WMS_INDOOR naar WMS-server DUURT LANGER DAN 5 SEC');
  end if;
EXCEPTION
  WHEN others then
--    utl_http.end_request(req);
--  utl_http.end_response(resp);
  --dbms_output.put_line(sqlerrm);
  APAOGEN.LogError (lcs_function_name, 'EXCP: WMS-FOUT bij verzenden van WMS-HTTP-BERICHT vanuit trigger UTSC.AT_UPD_SC_WMS_INDOOR naar WMS-server: '||sqlerrm );
 -- RAISE;
END;
END AT_WMS;
/
