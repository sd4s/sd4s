prompt PL/SQL Developer import file
prompt Created on Thursday, March 11, 2021 by Peter.Schepens
set feedback off
set define off
prompt Loading UTSYSTEM...
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('LOG_OUTDOOR_LVL', '1');
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('MEDIAN', '52900');
--
--insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('MONITOR_INTERVAL', '(1/24)');    --niet in prod
--insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('SMTP_INTERVAL', '(1/24)');       --niet in prod
--
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('WATSON_LIBRARIES', ',ZZZ_Development.nsf,GlobalPVRnD.nsf,GlobalTesting.nsf,');
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('WATSON_SYNC_ACTIEF', 'JA');
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('WATSON_WALLET_PATH', 'C:\oracle\admin\U611\wallet\watson');
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('WATSON_WALLET_PW', 'U611WalletPW001');
--
INSERT INTO UTSYSTEM (SETTING_NAME, SETTING_VALUE) VALUES ('WMS_URL_PROD','http://172.30.0.37:8080/');
INSERT INTO UTSYSTEM (SETTING_NAME, SETTING_VALUE) VALUES ('WMS_URL_PROD_TEST','http://172.30.69.88:8080/');
--
commit; 
--prompt 123 records loaded
set feedback on
set define on
prompt Done.
