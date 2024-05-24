--
-- TRIGGER UTWS.AT_UPD_WS_PREP
--

--dit is huidige versie op PROD:
CREATE OR REPLACE TRIGGER UNILAB.AT_UPD_WS_PREP
AFTER UPDATE
ON UNILAB.UTWS 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
WHEN (
(NEW.SS = 'AV' OR NEW.SS = '@P') and NEW.WT='PCTOutdoorPrep'
      )
DECLARE
  REQ UTRQ.RQ%type;
BEGIN
   SELECT REQUESTCODE INTO REQ FROM UTWSGKREQUESTCODE r WHERE r.WS = :NEW.WS;
   INSERT INTO AT_WS_PREP_UPDATES(DATE_TIME, WS, RQ, SS, STATUS) VALUES 
    (SYSDATE, :NEW.WS, REQ, :NEW.SS, 0);
   AT_WMS.AT_SENDWMS(REQ); 

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END AT_UPD_WS_PREP;
/


--dit is versie op ORACLEPROD-TEST:
TRIGGER AT_UPD_WS_PREP
AFTER UPDATE
ON UTWS 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
WHEN (
(NEW.SS = 'AV' OR NEW.SS = '@P') and (OLD.SS <> '@~') and NEW.WT='PCTOutdoorPrep'
      )
DECLARE
  REQ UTRQ.RQ%type;
BEGIN
   SELECT REQUESTCODE INTO REQ FROM UTWSGKREQUESTCODE r WHERE r.WS = :NEW.WS;
   INSERT INTO AT_WS_PREP_UPDATES(DATE_TIME, WS, RQ, SS, STATUS) VALUES 
    (SYSDATE, :NEW.WS, REQ, :NEW.SS, 0);
   AT_WMS.AT_SENDWMS(REQ); 

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END AT_UPD_WS_PREP;