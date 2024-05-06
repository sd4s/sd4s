--------------------------------------------------------
--  File created - dinsdag-september-08-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View AV_MAIL_LOG_USER
--------------------------------------------------------

CREATE OR REPLACE FORCE VIEW INTERSPC.AV_MAIL_LOG_USER 
(USER_ID
, FORENAME
, LAST_NAME
, EMAIL_ADDRESS) 
AS 
SELECT user_id
, forename
, last_name
, email_address
FROM application_user
WHERE email_address IS NOT NULL
AND email_address IN (
  SELECT DISTINCT REGEXP_REPLACE(
    error_msg,
    'ORA-29279: [^:]+: 550 (.+?)... No such user|The e-mail address <([^>]+)> is invalid or does not exist',
    '\1\2'
  )
  FROM iterror
  WHERE source = 'iapiEmail'
  AND logdate > SYSDATE - 30
);

CREATE OR REPLACE PUBLIC SYNONYM AV_MAIL_LOG_USER FOR INTERSPC.AV_MAIL_LOG_USER;
--
GRANT SELECT ON INTERSPC.AV_MAIL_LOG_USER TO APPROVER;
GRANT SELECT ON INTERSPC.AV_MAIL_LOG_USER TO CONFIGURATOR;
GRANT SELECT ON INTERSPC.AV_MAIL_LOG_USER TO DEV_MGR;
GRANT SELECT ON INTERSPC.AV_MAIL_LOG_USER TO FRAME_BUILDER;
GRANT SELECT ON INTERSPC.AV_MAIL_LOG_USER TO MRP;
GRANT SELECT ON INTERSPC.AV_MAIL_LOG_USER TO VIEW_ONLY;
