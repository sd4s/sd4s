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

--we nemen een paar nieuwe SYSTEM-SETTINGS op voor WATSON-WALLET
insert into UTSYSTEM (setting_name, setting_value) values ('WATSON_WALLET_PATH','C:\oracle\admin\U611\wallet\watson')
insert into UTSYSTEM (setting_name, setting_value) values ('WATSON_WALLET_PASSWORD','U611WalletPW001')
 

--STOPZETTEN van de JOB


--Opnieuw aanmaken van de APAO_WATSON-package 
@APAO_WATSON.PCK

--AANZETTEN van de JOB




/*
--achteraf (ALLEEN IN ORACLEPROD_TEST uitrollen!!!)
select * from   utsystem stm where  stm.setting_name like 'WATSON%'
UPDATE utsystem stm set stm.setting_value =',ZZZ_Development.nsf,GlobalPVRnD.nsf,GlobalTesting.nsf,' where stm.setting_name='WATSON_LIBRARIES';
select * from   utsystem stm where  stm.setting_name like 'WATSON%'
*/

