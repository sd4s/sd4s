--**********************************************************************************************************
-- CREATE VIEWS: 	1.DBA_V_WEIGHT_COMP_PART            --> Uitvragen hulptabel DBA_WEIGHT_COMPONENT_PART voor wat betreft gewichten
--**********************************************************************************************************
--Uitvragen hulptabel DBA_WEIGHT_COMPONENT_PART voor wat betreft gewichten:

--Met onderstaande query kunnen we de volgende gewichten ophalen:
--comp_gewicht_factor_top_down = RESULT van QUANTITY-PATH = gewicht-factor vanuit TYRE top-down geconcatenneerd naar COMPONENT toe.
--result_bepaal_header_gewicht = gewicht van component door optelsom van alle MATERIAL die in onderliggen BOM zitten.
--tyre_comp_gewicht            = gewicht van 1xEenheid COMPONENT vermenigvuldig met gewicht-factor-tyre-component, om daarmee gwicht van COMPONENT binnen specifieke band=MAINPART te berekenen.
--
--With this query we retrieve the following weights/factors:
--comp_gewicht_factor_top_down = RESULT of QUANTITY-PATH = WEIGHT-factor concatenated from TYRE top-down to COMPONENT-PARTNO.
--result_bepaal_header_gewicht = WEIGHT of component through sum of all MATERIALS existing in underlying BOM-STRUCTURE.
--tyre_comp_gewicht            = WEIGHT of 1xUNIT COMPONENT multiplied by the gewicht-factor-tyre-component, to calculate the WEIGHT of the COMPONENT WITHIN the specific RELATED TYRE=MAINPART.


create or replace view DBA_V_WEIGHT_COMP_PART
(datum_verwerking
,mainpart
,mainrevision
,mainframeid
,lvl_tree
,part_no
,revision
,alternative
,header_status
,component_part_no
,component_revision
,component_status
,quantity_path                   
,comp_gewicht_path_top_down   
,result_bepaal_header_gewicht
,tyre_related_comp_gewicht
,sap_article_code
,sap_da_article_code
)
as
select to_char(dwc.datum_verwerking,'dd-mm-yyyy hh24:mi:ss') datum_verwerking
,      dwc.mainpart
,      dwc.mainrevision
,      dwc.mainframeid
,      dwc.lvl_tree
,      dwc.part_no
,      dwc.revision
,      dwc.alternative
,      dwc.header_status
,      dwc.component_part_no
,      dwc.component_revision
,      dwc.component_status
,      dwc.quantity_path                   
,      dwc.bom_quantity_kg                             comp_gewicht_path_top_down   
,      dwc.comp_part_eenheid_kg                        result_bepaal_header_gewicht
,      dwc.bom_quantity_kg * dwc.comp_part_eenheid_kg  tyre_related_comp_gewicht
,      dwc.sap_article_code
,      dwc.sap_da_article_code
from DBA_WEIGHT_COMPONENT_PART  dwc
where dwc.datum_verwerking  in (select MAX(datum_verwerking) 
                                from dba_weight_component_part  dwc2 
								where dwc2.mainpart = dwc.mainpart)
order by dwc.id
;

--uitvragen VIEW mbv MAINPART:
SELECT * FROM DBA_V_WEIGHT_COMP_PART where mainpart='GF_385552260KERRF';

/*
select select to_char(dwc.datum_verwerking,'dd-mm-yyyy hh24:mi:ss') datum_verwerking
,      dwc.mainpart
,      dwc.mainframeid
,      dwc.lvl_tree
,      dwc.part_no
,      dwc.component_part_no
,      dwc.quantity_path                   
,      dwc.bom_quantity_kg                             comp_gewicht_path_top_down   
,      dwc.comp_part_eenheid_kg                        result_bepaal_header_gewicht
,      dwc.bom_quantity_kg * dwc.comp_part_eenheid_kg  tyre_related_comp_gewicht
from DBA_WEIGHT_COMPONENT_PART  dwc
where dwc.mainpart='GF_385552260KERRF'
and   dwc.datum_verwerking  in (select MAX(datum_verwerking) 
                                from dba_weight_component_part  dwc2 
								where dwc2.mainpart = dwc.mainpart)
order by dwc.id
;
*/


PROMPT
PROMPT EINDE SCRIPT
PROMPT

								