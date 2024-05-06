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
/


