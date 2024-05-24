prompt PL/SQL Developer import file
prompt Created on Thursday, March 11, 2021 by Peter.Schepens
set feedback off
set define off
prompt Loading UTSYSTEM...
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('LOG_OUTDOOR_LVL', '4');
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('MEDIAN', '43900');

insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('MONITOR_INTERVAL', '(1/24)');    --niet in prod
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('SMTP_INTERVAL', '(1/24)');       --niet in prod

insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('WATSON_LIBRARIES', ',ZZZ_Development.nsf,');
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('WATSON_SYNC_ACTIEF', 'NEE');
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('WATSON_WALLET_PATH', 'C:\oracle\admin\U611\wallet\watson');
insert into UTSYSTEM (SETTING_NAME, SETTING_VALUE) values ('WATSON_WALLET_PW', 'U611WalletPW001');
--
INSERT INTO UTSYSTEM (SETTING_NAME, SETTING_VALUE) VALUES ('WMS_URL_PROD','http://172.30.0.37:8080/');
--wms draaide voor 10-06-2022 op werkplek van Wilfred:
--INSERT INTO UTSYSTEM (SETTING_NAME, SETTING_VALUE) VALUES ('WMS_URL_PROD_TEST','http://172.30.69.88:8080/');
--wms draait per 10-06-2022 op LIMSCLIENT (let op: ER IS OOK AANVULLING OP ACL NODIG OM NAAR LIMSCLIENT TE KUNNEN MAILEN...)
--INSERT INTO UTSYSTEM (SETTING_NAME, SETTING_VALUE) VALUES ('WMS_URL_PROD_TEST','http://172.30.0.37:8090/');
update UTSYSTEM SET SETTING_VALUE = 'http://172.30.0.37:8090/' WHERE SETTING_NAME='WMS_URL_PROD_TEST';

--
commit; 
--prompt 123 records loaded
set feedback on
set define on
prompt Done.



