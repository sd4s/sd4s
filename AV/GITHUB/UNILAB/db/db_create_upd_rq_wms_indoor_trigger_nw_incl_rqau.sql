--create or replace update-trigger UTRQ

--De tabel AT_WMS_TRIGGER_UPDATES wordt gevuld indien RQAU=interface2WMS  een VALUE=1 heeft
/*
 DATE_TIME       TIMESTAMP(6)      
,RT              VARCHAR2(20 CHAR) 
,RQ              VARCHAR2(20 CHAR)
,ST              VARCHAR2(20 CHAR)
,SC              VARCHAR2(20 CHAR)
,LC              VARCHAR2(2 CHAR)
,SS              VARCHAR2(2 CHAR)  
,STATUS          NUMBER(5)   
--
DATE_TIME,RT,RQ,ST,SC,LC,SS,STATUS

*/
CREATE OR REPLACE TRIGGER AT_UPD_RQ_WMS_INDOOR
AFTER UPDATE
ON UTRQ
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
WHEN (OLD.SS <> 'CM' and NEW.SS = 'CM' )  
DECLARE
lcs_function_name     varchar2(100) := 'AT_UPD_RQ_WMS_INDOOR';
l_interface2WMS_value VARCHAR2(40);
L_RQ                  UTRQ.RQ%type;
BEGIN
  L_RQ := :NEW.RQ;
  --controleren of WMS moeten triggeren. Eerst controle op UTRQAU.interface2WMS
  --Komt in eerste instantie alleen bij RT="T: PCT indoor std" voor !
  begin
    select au.value  
	into l_interface2WMS_value
	from utrtau au
    where exists (select '' 
	              from utrt rt 
				  where rt.rt               = :NEW.RT 
				  and rt.version_is_current = 1 
				  and rt.rt                 = au.rt 
				  and rt.version            = au.version)
    and au = 'Interface2WMS'
	;
  exception
    when no_data_found 
	then 
	  --au-attribuut is niet aangemaakt voor RT
	  l_interface2WMS_value := null;
    when others 
	then 
	  --een technische fout, deze wel loggen, proces gaat wel door !
	  l_interface2WMS_value := null;
	  UNAPIGEN.LogError (lcs_function_name, SUBSTR(sqlerrm,1,255) );
      UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-WMS-SELECT-UTRQ-EXCP RQ:'||L_RQ||'-'||SUBSTR(sqlerrm,1,255) );
  end;  
  --
  if nvl(l_interface2WMS_value,0) = 1
  then
    INSERT INTO AT_WMS_TRIGGER_UPDATES(DATE_TIME,RT,RQ,ST,SC,LC,SS,STATUS) 
    VALUES (SYSDATE, :NEW.RT, L_RQ, '','', :NEW.LC, :NEW.SS, 0);
    --verstuur bericht naar WMS
    AT_WMS.AT_SENDWMS(L_RQ); 
    --
  end if;
EXCEPTION
  WHEN OTHERS THEN
    -- Consider logging the error and then re-raise
	--een technische fout, deze wel loggen, proces gaat wel door !
	--UNAPIGEN.LogError (lcs_function_name, SUBSTR(sqlerrm,1,255) );
    UNAPIGEN.LogError (lcs_function_name, 'INSERT-SEND-WMS-UTRQ-ALG-EXCP RQ:'||L_RQ||'-'||SUBSTR(sqlerrm,1,255) );
	--RAISE;
END AT_UPD_RQ_WMS_INDOOR;
/
SHOW ERR


--****************************************
--****************************************
--NIEUWE VARIANT !!!!!!
--****************************************
--****************************************


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
	  --Check in the CONFIGURATION on the CURRENT Request Type if the
      --attribute avCustToAvailable is present with the value 1
	  --If count=0 (if value=0, or AU not EXISTS) then RESULT=FALSE.
	  SELECT COUNT(*)
	  INTO lvi_counter1
      FROM utrtau au
      WHERE au.rt         = L_RT
      AND   au.version    = L_RT_VERSION
      AND   au.au         = 'Interface2WMS'
      AND   au.value      = '1'
      and   exists (select '' 
	                from utrt rt 
				    where rt.rt                 = L_RT
				    and   rt.version_is_current = 1 
				    and   rt.rt                 = au.rt 
				    and   rt.version            = au.version
				   )         
      ;
	end if;
    --	
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN 
	  --Daarna controleren op UTRQAU.interface2WMS
      --Komt in eerste instantie alleen bij RT="T: PCT indoor std" voor !
	  --Check in the CONFIGURATION on the CURRENT Request Type if the
      --attribute avCustToAvailable is present with the value 1
	  --If count=0 (if value=0, or AU not EXISTS) then RESULT=FALSE.
      SELECT COUNT(*)
	  INTO lvi_counter1
      FROM utrtau au
      WHERE au.rt         = L_RT
      AND   au.version    = L_RT_VERSION
      AND   au.au         = 'Interface2WMS'
      AND   au.value      = '1'
      and   exists (select '' 
	                from utrt rt 
				    where rt.rt                 = L_RT
				    and   rt.version_is_current = 1 
				    and   rt.rt                 = au.rt 
				    and   rt.version            = au.version
				   )
      ;
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

/*
UpdateOpalObjectRecord	"ORA-04091: table UNILAB.UTRQ is mutating, trigger/function may not see it
ORA-01403: no data found
ORA-06512: at "UNILAB.AT_UPD_RQ_WMS_INDOOR", line 71
ORA-04088: error during execution of trigger 'UNILAB.AT_UPD_RQ_WMS_INDOOR'"
AT_UPD_RQ_WMS_INDOOR	"INSERT-SEND-WNS-ALG-EXCP: ORA-04091: table UNILAB.UTRQ is mutating, trigger/function may not see it
ORA-01403: no data found"
*/


PROMPT
PROMPT einde script
prompt


