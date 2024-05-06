--Op oracleprod-test wijzigen we eerst de LIBRARY-LIST door daar alleen de ZZZ-DEVELOPMENT-sectie actief te hebben.
--Dit om te voorkomen dat we per ongeluk een WATSON-productie-document binnenhalen, en gereedmelden. We krijgen dit document
--dan niet meer in onze productie-omgeving beschikbaar.

--Hiervoor zijn de volgende zaken al geregeld:
--1)oracle wallet is aangemaakt
--2)het APOLLO-certificaat is geimpoerteerd
--3)De ACL is uitgebreid met de watson-server

--Hierna moet de WATSON-package nog aangepast worden.

/*
--voorarf (ALLEEN IN ORACLEPROD_TEST uitrollen!!!)
select * from   utsystem stm where  stm.setting_name like 'WATSON%'
UPDATE utsystem stm set stm.setting_value =',ZZZ_Development.nsf,' where stm.setting_name='WATSON_LIBRARIES';
select * from   utsystem stm where  stm.setting_name like 'WATSON%'
*/


select * from   utsystem stm where  stm.setting_name like 'WATSON%';

--we nemen een paar nieuwe SYSTEM-SETTINGS op voor WATSON-WALLET
insert into UTSYSTEM (setting_name, setting_value) values ('WATSON_SYNC_ACTIEF','JA');
--
insert into UTSYSTEM (setting_name, setting_value) values ('WATSON_WALLET_PATH','C:\oracle\admin\U611\wallet\watson');
insert into UTSYSTEM (setting_name, setting_value) values ('WATSON_WALLET_PW','U611WalletPW001');
--
--ORACLEPROD:      UPDATE utsystem stm set stm.setting_value =',ZZZ_Development.nsf,GlobalPVRnD.nsf,GlobalTesting.nsf,' where stm.setting_name='WATSON_LIBRARIES';
--ORACLEPROD_TEST: UPDATE utsystem stm set stm.setting_value =',ZZZ_Development.nsf,' where stm.setting_name='WATSON_LIBRARIES';
--
commit; 

select * from   utsystem stm where  stm.setting_name like 'WATSON%';


--STOPZETTEN van de JOB (eerst job-id uitvragen via TOAD):
exec dbms_scheduler.drop_job(l_job_id);
--OF GENERIEK:
exec cxapp.stopalldbjobs;


--Opnieuw aanmaken van de APAO_WATSON-package 
--@APAO_WATSON.SQL


--AANZETTEN van de JOB (via losse procedure...):
exec  StartWatsonInterface;
--OF generiek:
exec cxapp.startalldbjobs;

--Let op:
--Door het herstarten van de JOB gaat deze ook automatisch lopen, en werkt dan automatisch een eventuele 
--achterstand weg. 
--Eventueel handmatig dit proces starten, om direct de achterstand weg te werken:
/*
begin 
  apao_watson.import_files(p_test => false); 
end;
/
*/



/*
--achteraf (ALLEEN IN ORACLEPROD_TEST uitrollen!!!)
select * from   utsystem stm where  stm.setting_name like 'WATSON%'
UPDATE utsystem stm set stm.setting_value =',ZZZ_Development.nsf,GlobalPVRnD.nsf,GlobalTesting.nsf,' where stm.setting_name='WATSON_LIBRARIES';
select * from   utsystem stm where  stm.setting_name like 'WATSON%'
*/

