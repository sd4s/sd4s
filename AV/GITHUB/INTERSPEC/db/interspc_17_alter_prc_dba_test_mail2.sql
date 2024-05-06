/*
CREATE or replace procedure DBA_API_TEST_MAIL 
is
--l_recipients VARCHAR2(2000 CHAR)  := 'peter.schepens@apollovredestein.com';
l_sender     iapiType.EmailSender_Type := 'patrick.goossens@apollotyres.com';      --interspc_cfg.parameter_data%TYPE
l_recipients iapiType.EmailToTab_Type; -- := 'peter.schepens@apollotyres.com';       --IS TABLE OF EmailTo_Type  (=varchar2(255) )
l_subject    VARCHAR2(1) := NULL ;  --'DBA-test mail';                  --varchar2  (zonder lengte)
l_body       iapiType.Clob_Type;     --clob
l_index     iapiType.NumVal_Type;    --number
--
l_retval     iapiType.ErrorNum_Type;   --NUMBER;
BEGIN
  l_index := 1; 
  l_recipients(l_index) := 'peter.schepens@apollotyres.com';
  l_body := 'BUFFER-DATA: tekst voor in de mail om te controleren of mail-functie wel werkt...';
  l_retval := IAPIEMAIL.SendEmail(
                asSender=>l_sender
				,atRecipients=> l_recipients
                ,asSubject=>l_subject
                ,asBody=>l_body
                ,anNumberRecipients=>l_index  );
  dbms_output.put_line('return-value: '||l_retval);				
  --
  --Deze EMAIL-procedure SEND niet alleen de MAIL, maar probeert tegelijkertijd ook nog een BLOB op te halen.
  --Deze bestaat niet, dus loopt stuk...
EXCEPTION
  WHEN OTHERS
  THEN dbms_output.put_line('ALG-EXCP: '||SQLERRM);  
END;
*/

create or replace PROCEDURE DBA_API_TEST_MAIL2  AS 
lRawData      RAW(32767);
l_connection  utl_smtp.connection;
l_row         INTEGER;
l_isopen      BOOLEAN DEFAULT FALSE;

    PROCEDURE send_header(a_connection IN OUT utl_smtp.connection, a_name IN VARCHAR2, a_header IN VARCHAR2) AS
    BEGIN
       utl_smtp.write_data(a_connection, a_name || ': ' || a_header || utl_tcp.CRLF);
    END;

   PROCEDURE send_raw_header(a_connection IN OUT utl_smtp.connection, a_name IN VARCHAR2, a_header IN VARCHAR2) AS
      l_raw RAW(32767);
   BEGIN
      l_raw := utl_raw.cast_to_raw(a_name || ': ' || a_header || utl_tcp.CRLF);
      utl_smtp.write_raw_data(a_connection, l_raw);
   END;

BEGIN
   dbms_output.put_line('verstuur mail 5 ');
   --dd. 01-02-2022: Na overschakelen naar microsoft-mailserver krijgen we foutmelding:
   --EXCP-error: transient/permanent-error: ORA-29279: SMTP permanent error: 501 5.5.4 Invalid Address.
   --Oplossing: Voor smtp-domein stond een "@", zonder dit "@" wordt mail wel verstuurd.
   --
   --l_connection := utl_smtp.open_connection('18.208.22.77');   --mailserver on-premise incl. trend
   --l_connection := utl_smtp.open_connection('172.19.1.160');   --mailserver microsoft (=working via ip-address, whitelisted on relay-server!!)
   l_connection := utl_smtp.open_connection('apollotyres-com.mail.protection.outlook.com');   --mailserver microsoft via DNS O365
   l_isopen := TRUE;
   --
   utl_smtp.helo(l_connection, 'apollotyres.com');                    --smtp-domain (voor microsoft zonder "@"!!)
   --utl_smtp.mail(l_connection, 'patrick.goossens@apollotyres.com');    --smtp-sender on-premise incl. trend
   utl_smtp.mail(l_connection, 'interspec2@apollotyres.com');           --smtp-sender microsoft-mailserver
   utl_smtp.rcpt(l_connection, '<patrick.goossens@apollotyres.com>');      --recipient (string gescheiden punt-komma)
   utl_smtp.open_data(l_connection);
        --send_header(l_connection, 'From:',   'patrick.goossens@apollotyres.com');    --sender on-premise incl. trend
        send_header(l_connection, 'From:',   '<interspec2@apollotyres.com>');    --sender microsoft-mailserver
        send_header(l_connection, 'To:',     '<patrick.goossens@apollotyres.com>');      --recipient
        send_raw_header(l_connection, 'Subject', 'DBA Test Mail nw via dns');          --subject
        send_header(l_connection, 'Content-Type', 'text/plain; charset=utf-8');
		LRAWDATA := UTL_RAW.CAST_TO_RAW(UTL_TCP.CRLF || 'CONTENT IN MAIL DOOR DBA INGEVULD');
        UTL_SMTP.WRITE_RAW_DATA(L_CONNECTION, LRAWDATA);
   utl_smtp.close_data(l_connection);
   utl_smtp.quit(l_connection);
   --
   dbms_output.put_line('mail verstuurd');
   l_isopen := FALSE;
   --
EXCEPTION
WHEN utl_smtp.transient_error OR utl_smtp.permanent_error
THEN
   dbms_output.put_line('EXCP-error: transient/permanent-error: '||sqlerrm);
   IF l_isopen THEN
      utl_smtp.quit(l_connection);
      l_isopen := FALSE;
   END IF;
   l_isopen := FALSE;
WHEN OTHERS 
THEN
   dbms_output.put_line('EXCP-OTHERS-error: '||sqlerrm);
   IF l_isopen THEN
      utl_smtp.quit(l_connection);
      l_isopen := FALSE;
   END IF;

END DBA_API_TEST_MAIL2;
/

