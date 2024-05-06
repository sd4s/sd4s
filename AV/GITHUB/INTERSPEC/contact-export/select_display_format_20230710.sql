select l.layout_id, l.description 
from layout  l
where l.description in ('IS_Compound_small component' 
                      ,'IS_Compound_sidewall extrudate' 
					  ,'IS_PRODUCTION _GEN PCHE' 
					  ,'IS_PRODUCTION _GEN PCHI' 
					  ,'IS_Production_General' 
					  ,'IS_Compound_quintoplex' 
					  ,'IS_Compound_Triplex extruder' 
					  )
order by l.layout_id
;
/*
704873	IS_Production_General
704893	IS_PRODUCTION _GEN PCHE
704894	IS_PRODUCTION _GEN PCHI
704933	IS_Compound_small component
704935	IS_Compound_sidewall extrudate
704936	IS_Compound_quintoplex
704937	IS_Compound_Triplex extruder
--
--704873	,704893	, 704894	,704933	, 704935	, 704936	,704937
*/ 

select 'layout_id' 
,      'description'
,      'revision' 
,      'start_pos' 
,      'header_id' 
,      'description_Header'
,      'length'
,      'db_field'
,      'allignment'
,      'Hide_Header'
,      'bold'
,      'underline'
,      'color'
,      'edit_allowed'
from dual
;
--layout_id	description	  revision	start_pos	header_id	description_Header	length	db_field	allignment	Hide_Header	bold	underline	color	edit_allowed


-- Display formats - attempt 2
select pl.layout_id
,      l.description
,      l.revision
,      pl.start_pos
,      pl.header_id
,      h.description Header
,      pl.length
,      CASE when pl.field_id = 1  then 'Num_1'
            when pl.field_id = 2  then 'Num_2'
            when pl.field_id = 3  then 'Num_3'
            when pl.field_id = 4  then 'Num_4'
            when pl.field_id = 5  then 'Num_5'
            when pl.field_id = 6  then 'Num_6'
            when pl.field_id = 7  then 'Num_7'
            when pl.field_id = 8  then 'Num_8'
            when pl.field_id = 9  then 'Num_9'
            when pl.field_id = 10 then 'Num_10'
            when pl.field_id = 11 then 'Char_1'
            when pl.field_id = 12 then 'Char_2'
            when pl.field_id = 13 then 'Char_3'
            when pl.field_id = 14 then 'Char_4'
            when pl.field_id = 15 then 'Char_5'
            when pl.field_id = 16 then 'Char_6'
            when pl.field_id = 17 then 'Boolean_1'
            when pl.field_id = 18 then 'Boolean_2'
            when pl.field_id = 19 then 'Boolean_3'
            when pl.field_id = 20 then 'Boolean_4'
            when pl.field_id = 21 then 'Date_1'
            when pl.field_id = 22 then 'Date_2'
            when pl.field_id = 23 then 'UOM_id'
            when pl.field_id = 24 then 'Attribute'
            when pl.field_id = 25 then 'Test method'
            when pl.field_id = 26 then 'Characteristic'
            when pl.field_id = 27 then 'Property'
            when pl.field_id = 30 then 'Ch_2 (Characteristic 2)'
            when pl.field_id = 31 then 'Ch_3 (Characteristic 3)'
            when pl.field_id = 32 then 'Tm_det_1 (Test method detail)'
            when pl.field_id = 33 then 'Tm_det_2 (Test method detail)'
            when pl.field_id = 34 then 'Tm_det_3 (Test method detail)'
            when pl.field_id = 35 then 'Tm_det_4 (Test method detail)'
            when pl.field_id = 40 then 'Info'
            else 'NULL'
       END db_field
,      CASE when pl.alignment = 0 then 'Left'
            when pl.alignment = 1 then 'Right'
            when pl.alignment = 2 then 'Center'
            else 'NULL'
       END allignment
,      pl.header Hide_Header
,      pl.bold
,      pl.underline
,      pl.color
,      pl.edit_allowed
from layout l
,    property_layout pl
,    header h
where l.layout_id = pl.layout_id
and   l.status    = 2 -- Current
and pl.layout_id IN (704873	,704893	, 704894	,704933	, 704935	, 704936	,704937)  --700968
and   pl.revision = l.revision
and   h.header_id = pl.header_id
order by pl.layout_id, pl.start_pos
;




select sh.part_no, sh.revision, sh.status, sh.frame_id
, sp.section_id, s.description section_descr
, sp.SUB_section_id, ss.description subsection_descr
, sp.property_group, pg.description pg_descr
, sp.property, p.description p_descr
, sps.type, sps.ref_id, h.header_id, pl.field_id
, sps.display_format, l.description
, h.description
, sp.characteristic, c.description
,      CASE when pl.field_id = 1  then 'Num_1'
            when pl.field_id = 2  then 'Num_2'
            when pl.field_id = 3  then 'Num_3'
            when pl.field_id = 4  then 'Num_4'
            when pl.field_id = 5  then 'Num_5'
            when pl.field_id = 6  then 'Num_6'
            when pl.field_id = 7  then 'Num_7'
            when pl.field_id = 8  then 'Num_8'
            when pl.field_id = 9  then 'Num_9'
            when pl.field_id = 10 then 'Num_10'
            when pl.field_id = 11 then 'Char_1'
            when pl.field_id = 12 then 'Char_2'
            when pl.field_id = 13 then 'Char_3'
            when pl.field_id = 14 then 'Char_4'
            when pl.field_id = 15 then 'Char_5'
            when pl.field_id = 16 then 'Char_6'
            when pl.field_id = 17 then 'Boolean_1'
            when pl.field_id = 18 then 'Boolean_2'
            when pl.field_id = 19 then 'Boolean_3'
            when pl.field_id = 20 then 'Boolean_4'
            when pl.field_id = 21 then 'Date_1'
            when pl.field_id = 22 then 'Date_2'
            when pl.field_id = 23 then 'UOM_id'
            when pl.field_id = 24 then 'Attribute'
            when pl.field_id = 25 then 'Test method'
            when pl.field_id = 26 then 'Characteristic'
            when pl.field_id = 27 then 'Property'
            when pl.field_id = 30 then 'Ch_2 (Characteristic 2)'
            when pl.field_id = 31 then 'Ch_3 (Characteristic 3)'
            when pl.field_id = 32 then 'Tm_det_1 (Test method detail)'
            when pl.field_id = 33 then 'Tm_det_2 (Test method detail)'
            when pl.field_id = 34 then 'Tm_det_3 (Test method detail)'
            when pl.field_id = 35 then 'Tm_det_4 (Test method detail)'
            when pl.field_id = 40 then 'Info'
            else 'NULL'
       END db_field
,      CASE when pl.field_id = 1  then to_char(sp.Num_1)
            when pl.field_id = 2  then to_char(sp.Num_2)
            when pl.field_id = 3  then to_char(sp.Num_3)
            when pl.field_id = 4  then to_char(sp.Num_4)
            when pl.field_id = 5  then to_char(sp.Num_5)
            when pl.field_id = 6  then to_char(sp.Num_6)
            when pl.field_id = 7  then to_char(sp.Num_7)
            when pl.field_id = 8  then to_char(sp.Num_8)
            when pl.field_id = 9  then to_char(sp.Num_9)
            when pl.field_id = 10 then to_char(sp.Num_10)
            when pl.field_id = 11 then sp.Char_1
            when pl.field_id = 12 then sp.Char_2
            when pl.field_id = 13 then sp.Char_3
            when pl.field_id = 14 then sp.Char_4
            when pl.field_id = 15 then sp.Char_5
            when pl.field_id = 16 then sp.Char_6
            when pl.field_id = 17 then sp.Boolean_1
            when pl.field_id = 18 then sp.Boolean_2
            when pl.field_id = 19 then sp.Boolean_3
            when pl.field_id = 20 then sp.Boolean_4
            when pl.field_id = 21 then TO_CHAR(sp.Date_1,'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 22 then to_char(sp.Date_2,'dd-mm-yyyy hh24:mi:ss')
            when pl.field_id = 23 then to_char(sp.UOM_id)
            when pl.field_id = 24 then to_char(sp.Attribute)
            when pl.field_id = 25 then to_char(sp.Test_method)
            when pl.field_id = 26 then to_char(sp.Characteristic)
            when pl.field_id = 27 then to_char(sp.Property)
            when pl.field_id = 30 then to_char(sp.Ch_2)
            when pl.field_id = 31 then to_char(sp.Ch_3)
            when pl.field_id = 32 then sp.Tm_det_1
            when pl.field_id = 33 then sp.Tm_det_2
            when pl.field_id = 34 then sp.Tm_det_3
            when pl.field_id = 35 then sp.Tm_det_4
            when pl.field_id = 40 then sp.Info
            else 'NULL'
       END db_field_value
from specification_header      sh
JOIN specification_prop        sp   on sp.part_no   = sh.part_no  and sh.revision = sp.revision
join specification_section     sps  on sps.part_no  = sp.part_no  and sps.revision = sp.revision and  sps.section_id  = sp.section_id  and sps.sub_section_id = sp.sub_section_id 
JOIN layout                    l    ON l.layout_id  = sps.display_format and l.revision = sps.display_format_rev
JOIN property_layout           pl   ON pl.layout_id = l.layout_id        and pl.revision = l.revision
join header                    h    on h.header_id  = pl.header_id 
JOIN SECTION                   s    ON s.section_id = sp.section_id
JOIN SUB_SECTION               ss   on ss.sub_section_id   = sp.sub_section_id
JOIN PROPERTY_GROUP            pg   ON pg.property_GROUP   = sp.property_group
JOIN PROPERTY                  p    on p.property          = sp.property
full OUTER JOIN CHARACTERISTIC c    ON c.characteristic_id = sp.characteristic
WHERE  s.description  in ('SAP information'
                         , 'Chemical and physical properties')
and   sp.part_no = '100033_MIL_GEN'						 
and   sp.revision = (select max(sh2.revision) from specification_header sh2 where sh2.part_no = sp.part_no)
and sH.frame_id IN
('A_RM_Antidegradant'
,'A_RM_Aux'            
,'A_RM_Aux_Chem'       
,'A_RM_Aux_EA'         
,'A_RM_Aux_Liners'     
,'A_RM_bead_wire v1'   --
,'A_RM_chafer v1'      --
,'A_RM_Fabric v1'      --
,'A_RM_Filller v1'     --
,'A_RM_Filller Wh v1'  --
,'A_RM_Polymer v1'     --
,'A_RM_Rectbead v1'    --
,'A_RM_Resinv1'        --
,'A_RM_RubChem v1'     --
,'A_RM_Silanes v1'     --
,'A_RM_softener v1'    --
,'A_RM_SpeChem v1'     --
,'A_RM_Steel cord v1'  --
,'A_RM_Valves'         
,'A_RM_VarRM v1'       --
,'A_RM_Vulcagents v1'  --
,'A_Man_RM_AntiD'      
,'A_Man_RM_Aux'        
,'A_Man_RM_Aux_EA'     
,'A_Man_RM_Aux_Liner'  
,'A_Man_RM_bead_wire'  
,'A_Man_RM_chaferv1'    --
,'A_Man_RM_Fabric v1'   --
,'A_Man_RM_Filllerv1'    --
,'A_Man_RM_Fill Wv1'   --
,'A_Man_RM_Polymerv1'   --
,'A_Man_RM_rectbead'   --
,'A_Man_RM_Resinv1'    --
,'A_Man_RM_RubChemv1'  --
,'A_Man_RM_Silanesv1'  --
,'A_Man_RM_soft. v1'   --
,'A_Man_RM_SpeChem'    
,'A_Man_RM_Steel v1'   --
,'A_Man_RM_VarRM v1'   --
,'A_Man_RM_Vulc v1'    --
)
order by  SH.part_no, SH.frame_id, SP.section_id, SP.sub_section_id, SP.property_group, SP.property
;



--einde script

