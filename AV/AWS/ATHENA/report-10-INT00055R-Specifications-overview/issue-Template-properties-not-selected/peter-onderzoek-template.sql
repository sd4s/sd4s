[Tuesday 2:43 PM] Vinoth2 S
hi Peter Schepens, to filter header descriptions the sample query 
select distinct part_no,section_id,section_descr,sub_section_id,sub_section_descr,property_group,property_group_desc,property,property_desc,uom,db_field_value,header_description
from  sc_lims_dal.AV_REQOV_BASE_SELECT_SPECPROP_NW  
where part_no = 'Mask_PCR_INT00044' and db_field_value = 1

[Tuesday 2:44 PM] Vinoth2 S
for BoM, 
select * 
from sc_lims_dal.av_spec_overview_bomresultsrelated
where part_plant = 'ENS' and frame_id = 'A_PCR'


[Tuesday 2:46 PM] Vinoth2 S
select *
from  sc_lims_dal.AV_REQOV_BASE_SELECT_SPECPROP_NW  
where part_plant = 'GYO' and frame_id = 'A_Innerliner v1'


--SELECTION-CRITERIA FOR REPORT:
--part_plant = 'GYO' 
--frame_id = 'A_Innerliner v1'
--template=  Mask_PCR_INT00044

select * from av_parts where part_number='Mask_PCR_INT00044'
--Mask_PCR_INT00044	PCR INNER LINER / SQUEEGEE SPECIFICATION	pcs	I-S

select distinct part_no,section_id,section_descr,sub_section_id,sub_section_descr,property_group,property_group_desc,property,property_desc,uom,db_field_value,header_description
from  sc_lims_dal.AV_REQOV_BASE_SELECT_SPECPROP_NW  
where part_no = 'Mask_PCR_INT00044'


select *
from  sc_lims_dal.AV_REQOV_BASE_SELECT_SPECPROP_NW  
where part_plant = 'GYO' 
and frame_id = 'A_Innerliner v1'
and part_no='GL_G19C040A'
;

--A_Innerliner v1-GL_G19C040A
