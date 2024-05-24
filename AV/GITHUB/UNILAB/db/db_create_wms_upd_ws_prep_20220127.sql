CREATE OR REPLACE TRIGGER UNILAB.AT_UPD_WS_PREP
AFTER UPDATE
ON UNILAB.UTWS 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
WHEN ( (NEW.SS = 'AV' OR NEW.SS = '@P') and NEW.WT='PCTOutdoorPrep' )
DECLARE
lcs_function_name     varchar2(100) := 'AT_UPD_WS_PREP';
REQ UTRQ.RQ%type;
BEGIN
   BEGIN
     SELECT REQUESTCODE INTO REQ FROM UTWSGKREQUESTCODE r WHERE r.WS = :NEW.WS;
   EXCEPTION
     WHEN OTHERS 
	 THEN UNAPIGEN.LogError (lcs_function_name, 'UTWS-EXCP-ERROR WS: '||:NEW.WS||' FOUT BEPALEN RQ: '||SUBSTR(sqlerrm,1,255)  );
	      --raise alg-excp
		  raise;
   END;
   --
   INSERT INTO AT_WS_PREP_UPDATES(DATE_TIME, WS, RQ, SS, STATUS) 
   VALUES (SYSDATE, :NEW.WS, REQ, :NEW.SS, 0);
   --
   AT_WMS.AT_SENDWMS(REQ); 
   --
EXCEPTION
  WHEN OTHERS 
  THEN
    UNAPIGEN.LogError (lcs_function_name, 'UTWS-ALG-EXCP-ERROR WS: '||:NEW.WS||'-RQ:'||REQ||'-'||SUBSTR(sqlerrm,1,255) );
    -- Consider logging the error and then re-raise
    --RAISE;
END AT_UPD_WS_PREP;
/

