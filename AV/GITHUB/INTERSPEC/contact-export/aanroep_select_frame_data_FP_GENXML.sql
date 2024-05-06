prompt start aanroep-script voor export FRAME-data of FINISHED-PRODUCTS ....
prompt
prompt aanroep: @aanroep_select_frame_data_FP_GENXML.sql
prompt


--dd. 06-06-2023: gewijzigd naar "_v1"
/*
--#0
SELECT COUNT(*), PART_STATUS_TYPE  
from DBA_BHR_EXPORT_FRAME_SPEC  d
where  d.frame_id  like 'A_PCR' 
GROUP BY PART_STATUS_TYPE
;
4152	CURRENT
18157	HISTORIC
115		DEVELOPMENT
*/

--RUN CALLS MANUALLY IN SQLPLUS-SESSION OUT OF C:\CONTACT-DIRECTORY !!! 

--*************************************************************
--voorbereiding dd. 19-06-2023 obv LIJST van Nico Geevers:
--LET OP: DIT SCRIPT WERKT ALLEEN VANUIT SQL*DEVELOPER en NIET met deze AANROEP. 
--        SELECT-script maakt er zelf geen XML van. Dus output van query met copy/paste naar XML overhalen !!!
--*************************************************************
--
--dd. 31-08-2023:
--@Peter-Export-Frame-Structure-with-frameprop-v04-20230828.sql  A_PCR
--@Peter-Export-Frame-Structure-with-frameprop-v04-20230828.sql  A_PCR_GT_v1
--@Peter-Export-Frame-Structure-with-frameprop-v04-20230828.sql  A_PCR_VULC_v1
--@Peter-Export-Frame-Structure-with-frameprop-v04-20230828.sql  A_PCR_Certificate
--  
--

















prompt einde script

