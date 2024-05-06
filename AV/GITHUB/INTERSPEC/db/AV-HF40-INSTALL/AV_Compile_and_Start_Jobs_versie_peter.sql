@Compile_All
/

/*
we gaan de JOBS met eigen procedures HERSTARTEN...
@Start_All_Jobs
/
*/

/*
--MAIL EN REST ZIJN NIET UITGEZET, DUS HOEVEN WE OOK NIET AAN TE ZETTEN..
@Start_Mail
/
@Start_Specdata_Server_And_Queue
/
*/


begin dbms_output.put_line('Upgrade Version info table. Waiting..'); end;
/
insert into itversioninfo(type,id,installed_on,description) values('HF','6.7.0',sysdate,'Install I67HF40');

COMMIT;

BEGIN 
   DBMS_OUTPUT.PUT_LINE('Database hotfix installation finished.'); 
END;
/
