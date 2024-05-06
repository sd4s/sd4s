CREATE OR REPLACE TRIGGER AT_UPD_RQ_WMS_INDOOR
AFTER UPDATE
ON UTRQ
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
WHEN (OLD.SS <> 'CM' and NEW.SS = 'CM' )  
DECLARE
lcs_function_name     CONSTANT varchar2(100) := 'AT_UPD_RQ_WMS_INDOOR';
l_interface2WMS_value VARCHAR2(40);
L_RQ                  UTRQ.RQ%type;
L_RT                  UTRQ.RT%type;
L_RT_VERSION          UTRQ.RT_VERSION%type;
--
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_counter_rqau  APAOGEN.COUNTER_TYPE;
lvi_au_value      APAOGEN.AUVALUE_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;
--
BEGIN
  L_RQ         := :NEW.RQ;
  L_RT         := :NEW.RT;
  L_RT_VERSION := :NEW.RT_VERSION; 
  --controleren of WMS moeten triggeren. 
  --Eerst controle op RQAU of er attribuut is aangemaakt die de default RTAU-overruled...
  BEGIN
    UNAPIGEN.LogError (lcs_function_name, 'START AT_UPD_RQ_WMS_INDOOR RQ: '||L_RQ);
    --lvi_counter_rqau levert altijd een waarde terug, 0,1 of meer.
    SELECT COUNT(*)
    INTO lvi_counter_rqau
    FROM utrqau  au
    WHERE au.rq        = L_RQ            --'DSA2135004T'
    AND   au.au        = 'Interface2WMS'
    ;
	--indien counter_rqau > 0 dan gaan we waarde ophalen, anders halen we rtau op.
	if nvl(lvi_counter_rqau,0) > 0
	then
      SELECT  au.value
      INTO    lvi_au_value
      FROM utrqau  au
      WHERE au.rq        = L_RQ            --'DSA2135004T'
      AND   au.au        = 'Interface2WMS'
      GROUP by au.value
      ;
      --indien rqau bestaat dan overruled deze rtau-waarde.
      --Indien au-value wel bestaat maar met waarde = <null> dan result=FALSE, en kijken we niet verder naar rtau.
      if  lvi_counter_rqau    > 0
      and nvl(lvi_au_value,0) = 1
      then  lvi_counter1 := 1;   --TRUE
      else  lvi_counter1 := 0;   --FALSE
      end if;
	ELSE
	  --Daarna controleren op UTRQAU.interface2WMS
      --Komt in eerste instantie alleen bij RT="T: PCT indoor std" voor !
	  --Check in the CONFIGURATION on the VERSION of REQUEST-TYPE if the
      --attribute interface2WMS is present with the value 1
	  --If count=0 (if value=0, or AU not EXISTS) then RESULT=FALSE.
	  SELECT COUNT(*)
	  INTO lvi_counter1
      FROM utrtau au
      WHERE au.rt         = L_RT
      AND   au.version    = L_RT_VERSION
      AND   au.au         = 'Interface2WMS'
      AND   au.value      = '1'
	  ;
	  --PS: dd 30-06-2022 extra check uitgezet, omdat er alleen op huidige revision van request gecontroleerd moet worden.
      --and   exists (select '' 
	  --              from utrt rt 
      --              where rt.rt                 = L_RT
      --              and   rt.version_is_current = 1 
      --              and   rt.rt                 = au.rt 
      --              and   rt.version            = au.version
      --  )         
	end if;
    --	
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN 
	  --Daarna controleren op UTRQAU.interface2WMS
      --Komt in eerste instantie alleen bij RT="T: PCT indoor std" voor !
	  --Check in the CONFIGURATION on the VERSION of REQUEST-TYPE if the
      --attribute interface2WMS is present with the value 1
	  --If count=0 (if value=0, or AU not EXISTS) then RESULT=FALSE.
      SELECT COUNT(*)
	  INTO lvi_counter1
      FROM utrtau au
      WHERE au.rt         = L_RT
      AND   au.version    = L_RT_VERSION
      AND   au.au         = 'Interface2WMS'
      AND   au.value      = '1'
      ;
	  --PS: dd 30-06-2022 extra check uitgezet, omdat er alleen op huidige revision van request gecontroleerd moet worden.
      --and   exists (select '' 
	  --              from utrt rt 
      --              where rt.rt                 = L_RT
      --              and   rt.version_is_current = 1 
      --              and   rt.rt                 = au.rt 
      --              and   rt.version            = au.version
      -- )
	WHEN OTHERS
	THEN lvi_counter1 := 0;
	     UNAPIGEN.LogError (lcs_function_name, 'SELECT-WMS-UTRQ-EXCP RQ:'||L_RQ||'-'||SUBSTR(sqlerrm,1,255) );
  END;	
  --
  IF nvl(lvi_counter1,0) > 0 
  THEN  
    begin  
      INSERT INTO AT_WMS_TRIGGER_UPDATES(DATE_TIME,RT,RQ,ST,SC,LC,SS,STATUS) 
      VALUES (SYSDATE, :NEW.RT, L_RQ, '','', :NEW.LC, :NEW.SS, 0);
      --verstuur bericht naar WMS
      UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-UTRQ-WMS VOOR AT_SENDWMS RQ: '||L_RQ);
      AT_WMS.AT_SENDWMS(L_RQ); 
      UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-UTRQ-WMS NA AT_SENDWMS RQ: '||L_RQ);
      --
	EXCEPTION
	  when others 
	  THEN 
        UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-WMS-UTRQ-EXCP RQ:'||L_RQ||'-'||SUBSTR(sqlerrm,1,255) );
        --UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-WMS-EXCP: '||SUBSTR(sqlerrm,1,255) );
	end;
  END IF;
  --
EXCEPTION
  WHEN OTHERS THEN
    -- Consider logging the error and then re-raise
	--een technische fout, deze wel loggen, proces gaat wel door !
	UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-WMS-UTRQ-ALG-EXCP RQ:'||L_RQ||'-'||SUBSTR(sqlerrm,1,255) );
	--UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-WNS-ALG-EXCP: '||SUBSTR(sqlerrm,1,255) );
    --RAISE;
END AT_UPD_RQ_WMS_INDOOR;
/
SHOW ERR


--
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
WHEN ( OLD.SS <> 'CM' and NEW.SS = 'CM' and NEW.RT='T-T: PCT Outdoor' )
DECLARE
lcs_function_name     CONSTANT varchar2(100) := 'AT_UPD_RQ_PREP';
REQ UTRQ.RQ%type;
BEGIN
   REQ := :NEW.RQ;
   INSERT INTO AT_WS_PREP_UPDATES(DATE_TIME, WS, RQ, SS, STATUS) VALUES 
    (SYSDATE, '', REQ, :NEW.SS, 0);
   UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-UTRQ-WMS-UPD-RQ-PREP VOOR AT_SENDWMS RQ: '||REQ);
   AT_WMS.AT_SENDWMS(REQ); 
   UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-UTRQ-WMS-UPD-RQ-PREP VOOR AT_SENDWMS RQ: '||REQ);

   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END AT_UPD_RQ_PREP;
/

--************************************************************************************************
--************************************************************************************************
--create or replace update-trigger UTSC
--************************************************************************************************
--************************************************************************************************
CREATE OR REPLACE TRIGGER AT_UPD_SC_WMS_INDOOR
AFTER UPDATE
ON UTSC
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
WHEN (  (NEW.SS='@P' and OLD.SS<>'@P') 
     or (NEW.SS='OR' and OLD.SS<>'OR') 
     or (NEW.SS='@C' and OLD.SS<>'@C') 
	 )
DECLARE
lcs_function_name     CONSTANT varchar2(100) := 'AT_UPD_SC_WMS_INDOOR';
l_interface2WMS_value VARCHAR2(40);
L_RQ                  UTSC.RQ%type;
L_SC                  UTSC.SC%type;
L_RT                  UTRQ.RT%type;
L_RT_VERSION          UTRQ.RT_VERSION%type;
--
lvs_sqlerrm       APAOGEN.ERROR_MSG_TYPE;
lvi_counter_rqau  APAOGEN.COUNTER_TYPE;
lvi_au_value      APAOGEN.AUVALUE_TYPE;
lvi_counter1      APAOGEN.COUNTER_TYPE;
--
BEGIN
  UNAPIGEN.LogError (lcs_function_name, 'START AT_UPD_SC_WMS_INDOOR RQ: '||L_RQ||'-SC: '||L_SC);
  --
  L_RQ         := :NEW.RQ;
  L_SC         := :NEW.SC;
  --controleren of WMS moeten triggeren. Eerst controle of bij RQ een UTRQAU.interface2WMS voorkomt.
  --Komt in eerste instantie alleen bij RT="T: PCT indoor std" voor !
  --Eerst controle op RQAU of er attribuut is aangemaakt die de default RTAU-overruled...
  --VOOR PRODUCTIE-SAMPLES BESTAAT GEEN RQ. ALS RQ leeg is hoeven we nooit te mailen...
  --
  IF L_RQ IS NOT NULL
  THEN
    --
    BEGIN
		--lvi_counter_rqau levert altijd een waarde terug, 0,1 of meer.
		SELECT COUNT(*)
		INTO lvi_counter_rqau
		FROM utrqau  au
		WHERE au.rq        = L_RQ            --'DSA2135004T'
		AND   au.au        = 'Interface2WMS'
		;
		--indien counter_rqau > 0 dan gaan we waarde ophalen, anders halen we rtau op.
		if nvl(lvi_counter_rqau,0) > 0
		then
		  SELECT  au.value
		  INTO    lvi_au_value
		  FROM utrqau  au
		  WHERE au.rq        = L_RQ            --'DSA2135004T'
		  AND   au.au        = 'Interface2WMS'
		  GROUP by au.value
		  ;
		  --indien rqau bestaat dan overruled deze rtau-waarde.
		  --Indien au-value wel bestaat maar met waarde = <null> dan result=FALSE, en kijken we niet verder naar rtau.
		  if  lvi_counter_rqau    > 0
		  and nvl(lvi_au_value,0) = 1
		  then  lvi_counter1 := 1;   --TRUE
		  else  lvi_counter1 := 0;   --FALSE
		  end if;
		ELSE
		  --Daarna controleren op UTRQAU.interface2WMS
		  --Komt in eerste instantie alleen bij RT="T: PCT indoor std" voor !
          --Check in the CONFIGURATION on the VERSION of REQUEST-TYPE if the
          --attribute interface2WMS is present with the value 1
          --If count=0 (if value=0, or AU not EXISTS) then RESULT=FALSE.
		  select rq.rt, rq.rt_version
		  into L_RT, L_RT_VERSION
		  from utrq rq
		  where rq.rq = L_RQ
		  ;
		  --
		  SELECT COUNT(*)
		  INTO lvi_counter1
		  FROM utrtau au
		  WHERE au.rt         = L_RT
		  AND   au.version    = L_RT_VERSION
		  AND   au.au         = 'Interface2WMS'
		  AND   au.value      = '1'
		  ;
          --PS: dd 30-06-2022 extra check uitgezet, omdat er alleen op huidige revision van request gecontroleerd moet worden.
          --and   exists (select '' 
          --              from utrt rt 
          --              where rt.rt                 = L_RT
          --              and   rt.version_is_current = 1 
          --              and   rt.rt                 = au.rt 
          --              and   rt.version            = au.version
          -- )
		end if;
		--
		--	
	EXCEPTION
		WHEN NO_DATA_FOUND
		THEN 
		  --Daarna controleren op UTRQAU.interface2WMS
		  --Komt in eerste instantie alleen bij RT="T: PCT indoor std" voor !
          --Check in the CONFIGURATION on the VERSION of REQUEST-TYPE if the
          --attribute interface2WMS is present with the value 1
          --If count=0 (if value=0, or AU not EXISTS) then RESULT=FALSE.
		  select rq.rt, rq.rt_version
		  into L_RT, L_RT_VERSION
		  from utrq rq
		  where rq.rq = L_RQ
		  ;
		  --
		  SELECT COUNT(*)
		  INTO lvi_counter1
		  FROM utrtau au
		  WHERE au.rt         = L_RT
		  AND   au.version    = L_RT_VERSION
		  AND   au.au         = 'Interface2WMS'
		  AND   au.value      = '1'
		  ;
          --PS: dd 30-06-2022 extra check uitgezet, omdat er alleen op huidige revision van request gecontroleerd moet worden.
          --and   exists (select '' 
          --              from utrt rt 
          --              where rt.rt                 = L_RT
          --              and   rt.version_is_current = 1 
          --              and   rt.rt                 = au.rt 
          --              and   rt.version            = au.version
          -- )
		WHEN OTHERS
		THEN lvi_counter1 := 0;
			 UNAPIGEN.LogError (lcs_function_name, 'SELECT-WMS-UTSC-EXCP RQ:'||L_RQ||'-SC:'||L_SC||'-'||SUBSTR(sqlerrm,1,255) );	
	END;	
	--  
	IF nvl(lvi_counter1,0) > 0 
	THEN  
		begin  
		  INSERT INTO AT_WMS_TRIGGER_UPDATES(DATE_TIME,RT,RQ,ST,SC,LC,SS,STATUS) 
		  VALUES (SYSDATE, L_RT, L_RQ, :NEW.ST, L_SC, :NEW.LC, :NEW.SS, 0);
		  --verstuur bericht naar WMS. Nu nog op basis van RQ.  
		  --Handiger zou zijn om op dit niveau ook een L_SC mee te geven !!. 
		  --Deze trigger gaat nl. per SC af, en zou dan indien er meerdere SC onder een RQ voorkomen, meerdere keren 
		  --een WMS-bericht verzenden voor een bericht richting het WMS. 
		  --De vraag is hoe erg dat is. Wellicht is het mogelijk dat in vervolg-stap binnen SAP daar op gefilterd kan worden.
		  UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-UTSC-WMS VOOR AT_SENDWMS RQ: '||L_RQ||'-SC:'||L_SC);
		  AT_WMS.AT_SENDWMS(L_RQ); 
		  UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-UTSC-WMS NA AT_SENDWMS RQ: '||L_RQ||'-SC:'||L_SC);
		  --
		EXCEPTION
		  when others 
		  THEN 
			UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-WMS-UTSC-EXCP: '||L_RQ||'-SC:'||L_SC||'-'||SUBSTR(sqlerrm,1,255) );
		end;
	END IF;
	--
  end if; --rq is not null
  --  
EXCEPTION
  WHEN OTHERS THEN
    -- Consider logging the error and then re-raise
	--een technische fout, deze wel loggen, proces gaat wel door !
	UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-WMS-UTSC-ALG-EXCP-ERROR RQ: '||L_RQ||'-SC:'||L_SC||'-'||SUBSTR(sqlerrm,1,255) );
    --RAISE;
END AT_UPD_SC_WMS_INDOOR;
/
SHOW ERR


--************************************************************************************************
--************************************************************************************************
-- TRIGGER UTWS.AT_UPD_WS_PREP
--************************************************************************************************
--************************************************************************************************


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
   UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-UTWS-WMS-UPD-WS-PREP VOOR AT_SENDWMS WS: '||:NEW.WS||'-RQ:'||REQ);
   AT_WMS.AT_SENDWMS(REQ); 
   UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-UTSC-WMS-UPD-WS-PREP VOOR AT_SENDWMS WS: '||:NEW.WS||'-RQ:'||REQ);
   --
EXCEPTION
  WHEN OTHERS 
  THEN
    UNAPIGEN.LogError (lcs_function_name, 'UTWS-ALG-EXCP-ERROR WS: '||:NEW.WS||'-RQ:'||REQ||'-'||SUBSTR(sqlerrm,1,255) );
    -- Consider logging the error and then re-raise
    --RAISE;
END AT_UPD_WS_PREP;
/

