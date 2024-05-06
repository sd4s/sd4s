--------------------------------------------------------
--  File created - dinsdag-september-08-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View AV_MAIL_LOG
--------------------------------------------------------

--------------------------------------------------------
--  File created - dinsdag-september-08-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View AV_MAIL_LOG
--------------------------------------------------------

CREATE OR REPLACE FORCE VIEW INTERSPC.AV_MAIL_LOG (LOGDATE, ERROR_MSG) AS 
SELECT logdate, error_msg
FROM iterror
WHERE source = 'iapiEmail'
AND logdate > SYSDATE - 30
ORDER BY logdate DESC;

CREATE OR REPLACE PUBLIC SYNONYM AV_MAIL_LOG FOR INTERSPC.AV_MAIL_LOG;
--
GRANT SELECT ON INTERSPC.AV_MAIL_LOG TO APPROVER;
GRANT SELECT ON INTERSPC.AV_MAIL_LOG TO CONFIGURATOR;
GRANT SELECT ON INTERSPC.AV_MAIL_LOG TO DEV_MGR;
GRANT SELECT ON INTERSPC.AV_MAIL_LOG TO FRAME_BUILDER;
GRANT SELECT ON INTERSPC.AV_MAIL_LOG TO MRP;
GRANT SELECT ON INTERSPC.AV_MAIL_LOG TO VIEW_ONLY;



