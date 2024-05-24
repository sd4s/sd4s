CREATE OR REPLACE PACKAGE        AT_WMS AS

PROCEDURE AT_SENDWMS(REQUEST VARCHAR2);

END AT_WMS;
/


CREATE OR REPLACE PACKAGE BODY        AT_WMS AS

PROCEDURE AT_SENDWMS(REQUEST VARCHAR2)
AS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
lcs_function_name  CONSTANT APAOGEN.API_NAME_TYPE := 'AT_WMS'||'.'||'LogError';
--
req   utl_http.req;
resp  utl_http.resp;
value VARCHAR2(1024);
BEGIN
  --Ip-adres WMS-SERVER WILFRED GEERLING
  req := utl_http.begin_request('http://172.30.0.37:8080/' || REQUEST);
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
EXCEPTION
  WHEN others then
--    utl_http.end_request(req);
--  utl_http.end_response(resp);
  dbms_output.put_line(sqlerrm);
 -- RAISE;

/*
begin
  dbms_network_acl_admin.create_acl (
  acl          => 'httpacl.xml',
  description  => 'Allow HTTP Connectivity',
  principal    => 'PUBLIC',
  is_grant     => TRUE,
  privilege    => 'connect');
--  start_date   => SYSTIMESTAMP,
--  end_date     => NULL);
end;

begin
 dbms_network_acl_admin.assign_acl (
  acl         => 'httpacl.xml',
  host        => '172.30.69.44',
  lower_port  => 80,
  upper_port  => 8080);
  commit;
end;
*/
END;

END AT_WMS;
/
