--************************************************************************************************
--************************************************************************************************
-- TRIGGER: UTRQ.AT_UPD_RQ_PREP
--************************************************************************************************
--************************************************************************************************
--
create or replace TRIGGER AT_UPD_RQ_PREP
AFTER UPDATE
ON UTRQ
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
WHEN (
OLD.SS <> 'CM' and NEW.SS = 'CM' and NEW.RT='T-T: PCT Outdoor'
      )
DECLARE
  REQ UTRQ.RQ%type;
BEGIN
   REQ := :NEW.RQ;
   INSERT INTO AT_WS_PREP_UPDATES(DATE_TIME, WS, RQ, SS, STATUS) VALUES 
    (SYSDATE, '', REQ, :NEW.SS, 0);
   AT_WMS.AT_SENDWMS(REQ); 

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END AT_UPD_RQ_PREP;
/
