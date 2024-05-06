prompt start aanroep-script...
prompt aanroep: @aanroep_select_spec_data_GENXML_VW.sql

@select_spec_data_GENXML_VW.sql   A_RM_Antidegradant  CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Aux            CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Aux_Chem       CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Aux_EA         CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Aux_Liners     CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_bead_wire_v1   CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_chafer_v1      CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Fabric_v1      CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Filller_v1     CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Filller_Wh_v1  CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Polymer_v1     CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Rectbead_v1    CURRENT  
@select_spec_data_GENXML_VW.sql   A_RM_Resinv1        CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_RubChem_v1     CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Silanes_v1     CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_softener_v1    CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_SpeChem_v1     CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Steel_cord_v1  CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Valves         CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_VarRM_v1       CURRENT
@select_spec_data_GENXML_VW.sql   A_RM_Vulcagents_v1  CURRENT    --dd. 04-04-2023: gewijzigd naar "_v1"
--
@select_spec_data_GENXML_VW.sql   A_Man_RM_AntiD      CURRENT     --dd. 04-04-2023: toegevoegd 
@select_spec_data_GENXML_VW.sql   A_Man_RM_Aux        CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_Aux_EA     CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_Aux_Liner  CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_bead_wire  CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_chaferv1   CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_Fabric_v1  CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_Filllerv1  CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_Fill_Wv1   CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_Polymerv1  CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_rectbead   CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_Resinv1    CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_RubChemv1  CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_Silanesv1  CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_soft._v1   CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_SpeChem    CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_Steel_v1   CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_VarRM_v1   CURRENT
@select_spec_data_GENXML_VW.sql   A_Man_RM_Vulc_v1    CURRENT



prompt
prompt selectie van alle CURRENT-specs die na 1 April 2023 CURRENT zijn geworden !!!.
prompt Hierbij onderscheid maken tussen NEW-specs + NEW-revisions !!!
prompt

--select distinct frame_id from specification_header where frame_id like 'A_RM%v1' order by frame_id;
/*
--Niet geexporteerd:
A_RM_Plant info
A_RM_Polymer CIM
A_RM_Polymer JVS
A_RM_Polymer_Manv1
A_RM_Reprocess v1
*/

--select distinct frame_id from specification_header where frame_id like 'A_Man_RM%v1' order by frame_id;

--full new specs
select sh.part_no, sh.revision, sh.status, s.status_type, sh.issued_date, sh.created_on, sh.obsolescence_date, sh.frame_id
from specification_header sh
join status s ON s.status = sh.status
where sh.issued_date > to_date('01-04-2023','dd-mm-yyyy') 
and status_type = 'CURRENT'
and revision = 1
and frame_id IN
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
order by frame_id, part_no
;

--NEW REVISION specs 
select sh.part_no, sh.revision, sh.status, s.status_type, sh.issued_date, sh.created_on, sh.obsolescence_date, sh.frame_id
from specification_header sh
join status s ON s.status = sh.status
where sh.issued_date > to_date('01-04-2023','dd-mm-yyyy') 
and status_type = 'CURRENT'
and revision > 1
and frame_id IN
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
,'A_Man_RM_rectbead'   
,'A_Man_RM_Resinv1'    --
,'A_Man_RM_RubChemv1'  --
,'A_Man_RM_Silanesv1'  --
,'A_Man_RM_soft. v1'   --
,'A_Man_RM_SpeChem'    
,'A_Man_RM_Steel v1'   --
,'A_Man_RM_VarRM v1'   --
,'A_Man_RM_Vulc v1'    --
)
order by frame_id, part_no
;

