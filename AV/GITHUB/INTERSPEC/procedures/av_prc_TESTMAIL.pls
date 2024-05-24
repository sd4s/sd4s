create or replace PROCEDURE TESTMAIL AS 
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

   l_connection := utl_smtp.open_connection('172.16.0.5');
   l_isopen := TRUE;

   utl_smtp.helo(l_connection, 'vredestein.com');
   utl_smtp.mail(l_connection, 'mathias.vlessert@apollotyres.com');
   utl_smtp.rcpt(l_connection, 'mathias.vlessert@apollotyres.com');
   utl_smtp.open_data(l_connection);
   send_header(l_connection, 'From',   'interspec@vredestein.com');
   send_header(l_connection, 'To',     'mathias.vlessert@apollotyres.com');
   send_raw_header(l_connection, 'Subject', 'Test Mail');
   send_header(l_connection, 'Content-Type', 'text/plain; charset=utf-8');
      utl_smtp.close_data(l_connection);
   utl_smtp.quit(l_connection);
   l_isopen := FALSE;

EXCEPTION
WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
   IF l_isopen THEN
      utl_smtp.quit(l_connection);
      l_isopen := FALSE;
   END IF;
   l_isopen := FALSE;
WHEN OTHERS THEN
   IF l_isopen THEN
      utl_smtp.quit(l_connection);
      l_isopen := FALSE;
   END IF;

END TESTMAIL;