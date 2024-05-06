prompt start aanroep-script...
prompt aanroep: @aanroep_select_spec_data_cal_GENXML_VW.sql



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

--@select_spec_data_cal_GENXML_VW.sql  A_TextComp_v1   CURRENT   
--@select_spec_data_cal_GENXML_VW.sql  A_TextComp_v1   DEVELOPMENT 
--
--@select_spec_data_cal_GENXML_VW.sql  A_Steelcomp_v1   CURRENT   
--@select_spec_data_cal_GENXML_VW.sql  A_Steelcomp_v1   DEVELOPMENT 
--

--*************************************************************
--voorbereiding dd. 19-06-2023 obv LIJST van Nico Geevers:
--*************************************************************
@select_spec_data_cal_GENXML_VW.sql   A_tread_pcs   CURRENT 
@select_spec_data_cal_GENXML_VW.sql   A_tread_pcs   DEVELOPMENT 
--
@select_spec_data_cal_GENXML_VW.sql   A_tread_v1   CURRENT 
@select_spec_data_cal_GENXML_VW.sql   A_tread_v1   DEVELOPMENT 
--
@select_spec_data_cal_GENXML_VW.sql   A_Sidewall_v1   CURRENT 
@select_spec_data_cal_GENXML_VW.sql   A_Sidewall_v1   DEVELOPMENT 
--
@select_spec_data_cal_GENXML_VW.sql   A_Sidewall_pcs   CURRENT 
@select_spec_data_cal_GENXML_VW.sql   A_Sidewall_pcs   DEVELOPMENT 
--
@select_spec_data_cal_GENXML_VW.sql   A_Extrudate_v1   CURRENT 
@select_spec_data_cal_GENXML_VW.sql   A_Extrudate_v1   DEVELOPMENT 
--
--@select_spec_data_cal_GENXML_VW.sql   A_Ply_v1   CURRENT 
--@select_spec_data_cal_GENXML_VW.sql   A_Ply_v1   DEVELOPMENT 
--
--@select_spec_data_cal_GENXML_VW.sql   A_Belt_v1   CURRENT 
--@select_spec_data_cal_GENXML_VW.sql   A_Belt_v1   DEVELOPMENT 
--
--@select_spec_data_cal_GENXML_VW.sql   A_Capply   CURRENT 
--@select_spec_data_cal_GENXML_VW.sql   A_Capply   DEVELOPMENT 
--
--@select_spec_data_cal_GENXML_VW.sql   A_Bead_v1   CURRENT 
--@select_spec_data_cal_GENXML_VW.sql   A_Bead_v1   DEVELOPMENT 
--
--@select_spec_data_cal_GENXML_VW.sql   A_Innerliner_v1    CURRENT 
--@select_spec_data_cal_GENXML_VW.sql   A_Innerliner_v1    DEVELOPMENT 
--
--@select_spec_data_cal_GENXML_VW.sql   A_Band   CURRENT 
--@select_spec_data_cal_GENXML_VW.sql   A_Band   DEVELOPMENT 
--
--@select_spec_data_cal_GENXML_VW.sql   A_AT_CARCASS   CURRENT 
--@select_spec_data_cal_GENXML_VW.sql   A_AT_CARCASS   DEVELOPMENT 
--
--@select_spec_data_cal_GENXML_VW.sql   A_PA   CURRENT 
--@select_spec_data_cal_GENXML_VW.sql   A_PA   DEVELOPMENT 















prompt einde script

