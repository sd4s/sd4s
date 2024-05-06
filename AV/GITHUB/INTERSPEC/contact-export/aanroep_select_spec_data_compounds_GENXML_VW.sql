prompt start aanroep-script...
prompt aanroep: @aanroep_select_spec_data_compounds_GENXML_VW.sql

--dd. 15-04-2023: gewijzigd naar "_v1"
--#55106
@select_spec_data_compounds_GENXML_VW.sql  A_CMPD_MB_v1   CURRENT   
--@select_spec_data_compounds_GENXML_VW_TYP1.sql  A_CMPD_MB_v1   CURRENT  
--@select_spec_data_compounds_GENXML_VW_TYP4.sql  A_CMPD_MB_v1   CURRENT  
--@select_spec_data_compounds_GENXML_VW_TYP2.sql  A_CMPD_MB_v1   CURRENT  
--@select_spec_data_compounds_GENXML_VW_TYP5.sql  A_CMPD_MB_v1   CURRENT  
--@select_spec_data_compounds_GENXML_VW_TYP6.sql  A_CMPD_MB_v1   CURRENT  
--@select_spec_data_compounds_GENXML_VW_TYP8.sql  A_CMPD_MB_v1   CURRENT  
@select_spec_data_compounds_GENXML_VW.sql  A_CMPD_MB_v1   DEVELOPMENT   
 
--dd. 15-04-2023: gewijzigd naar "_v1" 
--#133221
@select_spec_data_compounds_GENXML_VW.sql  A_CMPD_FM_v1   CURRENT   
@select_spec_data_compounds_GENXML_VW.sql  A_CMPD_FM_v1   DEVELOPMENT 

--dd. 15-04-2023: gewijzigd naar "_v1"
--#38018
@select_spec_data_compounds_GENXML_VW.sql  A_SCW_v1       CURRENT   
@select_spec_data_compounds_GENXML_VW.sql  A_SCW_v1       DEVELOPMENT


prompt einde script

