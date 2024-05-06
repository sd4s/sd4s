create or replace procedure DBA_API_TEST_MAIL
is
--Testprocedure om handmatig de mail-functionaliteit in UNILAB te kunnen checken.
--Mail-procedure binnen UNILAB (UNAPIGEN.SENDMAIL maakt gebruik van een 3-tal settings
--uit de UTSYSTEM-tabel:
--SMTP_SERVER  18.208.22.77
--SMTP_DOMAIN  apollotyres.com
--SMTP_SENDER	 unilab@apollotyres.com
--
--dd. 03-01-2022: Trend-mail-host wordt vervangen door microsoft-mail-server.
--Hiervoor moeten de volgende SYSTEM-SETTINGS worden aangepast in UTSYSTEM:
--SMTP_SERVER  172.19.1.160
--SMTP_DOMAIN  apollotyres.com                (hier mag geen "@" voor staan !!)
--SMTP_SENDER	 unilab_test@apollotyres.com
--
--dd. 08-02-2022: Trend-mail-host wordt vervangen door microsoft-mail-server.
--Hiervoor moeten de volgende SYSTEM-SETTINGS worden aangepast in UTSYSTEM:
--SMTP_SERVER  apollotyres-com.mail.protection.outlook.com (via office-365-DNS)
--SMTP_DOMAIN  apollotyres.com                (hier mag geen "@" voor staan !!)
--SMTP_SENDER	 unilab_test@apollotyres.com
--
--l_recipients VARCHAR2(2000 CHAR)  := 'peter.schepens@apollovredestein.com';
l_recipients VARCHAR2(2000 CHAR)  := 'peter.schepens@apollotyres.com';
l_subject    VARCHAR2(255 CHAR)   := 'DBA-test mail';
l_buffer     unapigen.vc255_table_type;
l_index      NUMBER;
--
l_retval    NUMBER;
BEGIN
  l_index := 1;
  l_buffer(l_index) := 'BUFFER-DATA: tekst voor in de mail om te controleren of mail-functie via DNS wel werkt...';

  l_retval := unapiGen.SendMail(
                l_recipients,
                l_subject,
                l_buffer,
                l_index  );
  dbms_output.put_line('return-value: '||l_retval);				
  --
END;

/*
WAS:

CREATE or replace procedure DBA_API_TEST_MAIL 
is
--l_recipients VARCHAR2(2000 CHAR)  := 'peter.schepens@apollovredestein.com';
l_recipients VARCHAR2(2000 CHAR)  := 'peter.schepens@apollotyres.com';
l_subject    VARCHAR2(255 CHAR)   := 'DBA-test mail';
l_buffer     unapigen.vc255_table_type;
l_index      NUMBER;
--
l_retval     NUMBER;
BEGIN
  l_index := 1; 
  l_buffer(l_index) := 'BUFFER-DATA: tekst voor in de mail om te controleren of mail-functie wel werkt...';
  l_retval := unapiGen.SendMail(
                l_recipients,
                l_subject,
                l_buffer,
                l_index  );
  dbms_output.put_line('return-value: '||l_retval);				
  --
END;
*/


