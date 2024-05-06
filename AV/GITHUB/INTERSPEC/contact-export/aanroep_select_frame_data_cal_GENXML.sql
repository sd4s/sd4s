prompt start aanroep-script...
prompt aanroep: @aanroep_select_frame_data_cal_GENXML.sql



--dd. 06-06-2023: gewijzigd naar "_v1"
/*
--#0
SELECT COUNT(*), PART_STATUS_TYPE  
from DBA_BHR_EXPORT_FRAME_SPEC  d
where  d.frame_id  like 'A_TextComp_v1' 
GROUP BY PART_STATUS_TYPE
;
4152	CURRENT
18157	HISTORIC
115	DEVELOPMENT
*/

--RUN CALLS MANUALLY IN SQLPLUS-SESSION OUT OF C:\CONTACT-DIRECTORY !!! 

--@Peter-Export-Frame-Structure-with-frameprop.sql  A_TextComp_v1 
--@Peter-Export-Frame-Structure-with-frameprop.sql  A_Steelcomp_v1 
--

--*************************************************************
--voorbereiding dd. 19-06-2023 obv LIJST van Nico Geevers:
--LET OP: DIT SCRIPT WERKT ALLEEN VANUIT SQL*DEVELOPER en NIET met deze AANROEP. 
--        SELECT-script maakt er zelf geen XML van. Dus output van query met copy/paste naar XML overhalen !!!
--*************************************************************
--dd. 19-06-2023:
--@Peter-Export-Frame-Structure-with-frameprop-v03-20230710.sql   A_tread_pcs   
--@Peter-Export-Frame-Structure-with-frameprop-v03-20230710.sql   A_tread_v1   
--@Peter-Export-Frame-Structure-with-frameprop-v03-20230710.sql   A_Sidewall_v1
--@Peter-Export-Frame-Structure-with-frameprop-v03-20230710.sql   A_Sidewall_pcs
--@Peter-Export-Frame-Structure-with-frameprop-v03-20230710.sql   A_Extrudate_v1

--*************************************************************
--voorbereiding dd. 22-08-2023 obv LIJST van Nico Geevers:
--LET OP: DIT SCRIPT WERKT ALLEEN VANUIT SQL*DEVELOPER en NIET met deze AANROEP. 
--        SELECT-script maakt er zelf geen XML van. Dus output van query met copy/paste naar XML overhalen !!!
--*************************************************************
--dd. 22-08-2023:
--@Peter-Export-Frame-Structure-with-frameprop-v03-20230710.sql   A_Innerliner_v1    
--@Peter-Export-Frame-Structure-with-frameprop-v03-20230710.sql   A_AT_CARCASS   
--@Peter-Export-Frame-Structure-with-frameprop-v04-20230828.sql   A_PA   

--*************************************************************
--LET OP: DIT SCRIPT WERKT ALLEEN VANUIT SQL*DEVELOPER en NIET met deze AANROEP. 
--        GEBRUIK DUS QUERY UIT SCRIPT EN COPY/PASTE DEZE IN SQL*DEVELOPER ...
--*************************************************************
--dd. 31-08-2023:
--@Peter-Export-Frame-Structure-with-frameprop-v04-20230828.sql  A_Band   



--STILL TO DO:
--@Peter-Export-Frame-Structure-with-frameprop.sql   A_Ply_v1   
--
--@Peter-Export-Frame-Structure-with-frameprop.sql   A_Belt_v1  
--
--@Peter-Export-Frame-Structure-with-frameprop.sql   A_Capply   
--
--@Peter-Export-Frame-Structure-with-frameprop.sql   A_Bead_v1  
--
--

















prompt einde script

