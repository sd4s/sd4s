Herstel-procedure:


--STOPZETTEN van de JOB (eerst job-id uitvragen via TOAD):
exec dbms_scheduler.drop_job(l_job_id);
--OF GENERIEK:
exec cxapp.stopalldbjobs;


--EVT. Opnieuw aanmaken van de APAO_WATSON-package 
--@APAO_WATSON.SQL
--OF WALLET-MANAGER van nieuwe certificaten voorzien !!


--AANZETTEN van de JOB (via losse procedure...):
exec  StartWatsonInterface;
--OF generiek:
exec cxapp.startalldbjobs;

--Let op:
--Door het herstarten van de JOB gaat deze ook automatisch lopen, en werkt dan automatisch een eventuele 
--achterstand weg. 
--Eventueel handmatig dit proces starten, om direct de achterstand weg te werken:
/*
begin 
  apao_watson.import_files(p_test => false); 
end;
/
*/

