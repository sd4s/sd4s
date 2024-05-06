-- *************************************************************************************
-- *************************************************************************************
-- LET OP:   ADD-SUPPLEMENTAL-COUNT PROCEDURE MOET REEDS ZIJN AANGEMAAKT.......
-- *************************************************************************************
-- *************************************************************************************

SET SERVEROUTPUT ON
--INCL DEBUG, GEEN COMMIT...
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_COUNT (p_table_name=>'UTEQ', p_debug=>'J'); END;
/*
serveroutput:
ALTER TABLE UTEQ ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS
*/
--DAADWERKELIJK AANZETTEN...
--BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'UTRQGKRQDAY', p_debug=>'N'); END;

--debug alle tabellen in schema...
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_count (p_table_name=>'', p_debug=>'J'); END;
--************************************************************************************************************
--************************************************************************************************************
--en nu HELE SCHEMA voor het ECHIE...!!!!!!!!!!!!!!!!!!!! (DEBUG=N)
BEGIN DBA_AWS_ADD_SUPPLEMENTAL_count (p_table_name=>'', p_debug=>'N'); END;
--of specifieke tabel:
--BEGIN DBA_AWS_ADD_SUPPLEMENTAL_LOG (p_table_name=>'AVSPECIFICATION_WEIGHT', p_debug=>'N'); END;
--
alter system switch logfile; 
--************************************************************************************************************
--************************************************************************************************************

--CONTROLE
select table_name, ASC_COUNT   from dba_aws_supplemental_log ;
--




prompt
prompt einde script
prompt

