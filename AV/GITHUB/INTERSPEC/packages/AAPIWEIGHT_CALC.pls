create or replace PACKAGE AAPIWEIGHT_CALC 
AS 
--
-- Refresh-procedure voor MV = mv_bom_item_comp_header die voor iedere dagelijkse mutatieverwerking uitgevoerd moet worden
procedure refresh_mv_bom_item_header ;
--***************************************************************************************************************
-- SELECT BOM-STRUCTURE functions/procedures
--***************************************************************************************************************
--selecteer van PARTNO/BOM-HEADER alle component-parts incl gewicht.
--PART-NO is verplicht. Indien Revision/alternative LEEG, dan worden deze van CURRENT-HEADER-revision gebruikt !!!
PROCEDURE SELECT_PART_GEWICHT (p_header_part_no      IN  varchar2 default null
                              ,p_header_revision     in  number   default null
                              ,p_header_alternative  IN  number   default 1 ) 
DETERMINISTIC
;
--select BOM-structuur van PART-ITEMS van een bepaald LVL:
--PART-NO is verplicht. Indien Revision/alternative LEEG, dan worden deze van CURRENT-HEADER-revision gebruikt !!!
PROCEDURE SELECT_LEVEL_PART (p_header_part_no      IN  varchar2 default null
                            ,p_header_revision     in  number   default null
                            ,p_header_alternative  IN  number   default 1 
                            ,p_level               IN  number   default 2 ) 
DETERMINISTIC
;
--Select PART-ITEMS van een bepaald LVL waarbij TYRE/HEADER-GEWICHT getoond wordt.
--Werkt alleen nog maar voor LEVEL=1 !!!!
--PART-NO is verplicht. Indien Revision/alternative LEEG, dan worden deze van CURRENT-HEADER-revision gebruikt !!!
PROCEDURE SELECT_TYRE_LEVEL_PART_WEIGHT (p_header_part_no      IN  varchar2 default null
                                        ,p_header_revision     in  number   default null
                                        ,p_header_alternative  IN  number   default 1 
                                        ,p_level               IN  number   default 2 ) 
DETERMINISTIC
;
--AD-HOC BEHEER procedure voor uitvragen van GEWICHT van een BOM-HEADER
procedure DBA_SELECT_PART_ITEM (p_header_part_no      varchar2 default null
                               ,p_header_revision     number   default null
                               ,p_alternative         number   default null )
DETERMINISTIC
;
--AD-HOC- BEHEER procedure voor uitvragen van ALLEEN materials DIRECT gerelateerd aan een BOM_HEADER
procedure DBA_SELECT_PART_MATERIALS (p_header_part_no      varchar2 default null
                                    ,p_header_revision     number   default null
                                    ,p_alternative         number   default null )
DETERMINISTIC
;                                    
--Procedure to find the SAP-WEIGHT-CALCULATION-TYRES (CURRENT/FRAME-ID) related to a component
PROCEDURE oud_select_part_related_tyre (p_component_part_no   IN  varchar2 default null) ;
--Procedure to find the SAP-WEIGHT-CALCULATION-TYRES BASED ON MV=mv_bom_item_comp_header (CURRENT/FRAME-ID) related to a component
--same as handling in DBA_VERWERK_GEWICHT_MUTATIES...
PROCEDURE SELECT_MV_PART_RELATED_TYRE (p_component_part_no   IN  varchar2 default null) 
DETERMINISTIC
;
--
--Function to find all related-TYRE-PART-NO and by all alternatives of a specific COMPONENT-PART/BOM-ITEM.
function FNC_SELECT_ALL_BOM_ITEM_TYRE (p_component_part_no   IN  varchar2 default null
                                      ,p_show_incl_items_jn  IN  varchar2 default 'N' ) 
RETURN NUMBER
DETERMINISTIC
;




--***************************************************************************************************************
-- WEIGHT-CALCULATION functions/procedures
--***************************************************************************************************************
--
--Function to calculate the weight through a PATH-string coming from a CONNECT-TO-PRIOR-query
--Is used in the DBA_FNC_BEPAAL_HEADER_GEWICHT-procedure
FUNCTION DBA_BEPAAL_QUANTITY_KG (P_STMNT VARCHAR2) 
RETURN VARCHAR
DETERMINISTIC;
--
--Function = old, to calculate the header-weight on base of all the kg-materials within its BOM.
--parameter:  p_header_part_no     = MANDATORY, if not exists then process stops !!
--            p_header_revision    = OPTIONAL, if not given then the max(revision) will be used
--            p_header_alternative = OPTIONAL, if not given then the preferred-alternative will be used
--            p_show_incl_items_jn = OPTIONAL, if not given then NO debug-messages will be shown.
--Wordt NIET MEER aangeroepen door DBA_BEPAAL_COMP_PART_GEWICHT. Alleen nog maar voor AD-HOC gebruik!
function dba_fnc_bepaal_header_gewicht (p_header_part_no      IN  varchar2 default null
                                       ,p_header_revision     in  number   default null
                                       ,p_header_alternative  IN  number   default 1
                                       ,p_show_incl_items_jn  IN  varchar2 default 'N' ) 
RETURN NUMBER
DETERMINISTIC
;
--Function to calculate the header-weight on base of all the kg-materials within its BOM.
--parameter:  p_header_part_no     = MANDATORY, if not exists then process stops !!
--            p_header_revision    = OPTIONAL, if not given then the max(revision) will be used
--            p_header_alternative = OPTIONAL, if not given then the preferred-alternative will be used
--            p_show_incl_items_jn = OPTIONAL, if not given then NO debug-messages will be shown.
--Wordt aangeroepen door: BEPAAL_MV_COMP_PART_GEWICHT
--Maakt gebruik van MV = MV_BOM_ITEM_COMP_HEADER
function FNC_BEPAAL_MV_HEADER_GEWICHT (p_header_part_no      IN  varchar2 default null
                                      ,p_header_revision     in  number   default null
                                      ,p_header_alternative  IN  number   default 1
                                      ,p_show_incl_items_jn  IN  varchar2 default 'N' ) 
RETURN NUMBER
DETERMINISTIC
;
--Function = OLD, replaced by BEPAAL_MV_COMP_PART_GEWICHT.
--to select complete BOM-STRUCTURE of BOM-header and will calculate:
--1)The weight of the BOM-HEADER
--2)and also the for alle BOM-ITEM-COMPONENT-PARTS within the bom-structure
--Roept aan: DBA_FNC_BEPAAL_HEADER_GEWICHT om kg-materialen te berekenen.
procedure dba_bepaal_comp_part_gewicht (p_header_part_no        varchar2 
                                       ,p_header_revision       varchar2 default null
                                       ,p_alternative           number   default null
                                       ,p_show_incl_items_jn    varchar2 default 'N'
                                       ,p_insert_weight_comp_jn varchar2 default 'N'														 
										          				 )
DETERMINISTIC
;
--Function to select complete BOM-STRUCTURE of BOM-header and will calculate:
--1)The weight of the BOM-HEADER
--2)and also the for alle BOM-ITEM-COMPONENT-PARTS within the bom-structure
--Aangeroepen-vanuit: DBA_VERWERK_GEWICHT_MUTATIES
--Roept aan:          FNC_BEPAAL_MV_HEADER_GEWICHT om kg-materialen te berekenen.
--Maakt gebruik van MV = MV_BOM_ITEM_COMP_HEADER
procedure BEPAAL_MV_COMP_PART_GEWICHT (p_header_part_no        varchar2 
                                      ,p_header_revision       varchar2 default null
                                      ,p_alternative           number   default null
                                      ,p_show_incl_items_jn    varchar2 default 'N'
                                      ,p_insert_weight_comp_jn varchar2 default 'N'														 
										      			   	 )
DETERMINISTIC
;
--
--
--***************************************************************************************************************
-- AUTOMATISCH JOB/VERWERKING functions/procedures
--***************************************************************************************************************
--Procedure om voor PART-NO de actuele-current WEIGHT te berekenen en te vergelijken met 
--laatste voorkomen in de DBA_WEIGHT_COMPONENT_PART tabel (met hoogste VERWERKT-DATUM)
procedure prc_check_part_changed_weight (p_part_no                   IN OUT varchar2
                                        ,p_revision                  IN OUT number 
                                        ,p_alternative               IN OUT number  
                                        ,p_new_comp_part_eenheid_kg  IN OUT number
                                        ,p_old_comp_part_eenheid_kg  IN OUT number
                                        ,p_new_header_base_quantity  IN OUT number
                                        ,p_old_header_base_quantity  IN OUT number
                                        ,p_weight_changed_ind        IN OUT varchar2 );
--Functie roept procedure prc_check_part_changed_weight aan, en geeft alleen true/false terug.
function fnc_check_part_changed_weight (p_part_no      varchar2
                                       ,p_revision     number 
                                       ,p_alternative  number  )
RETURN VARCHAR2
;                                   
--Create procedure om dagelijks / periodiek te draaien en alle mutaties van na het runnen van de vorige keer
--op basis van stuurtabel DBA_SYNC_BESTURING_WEIGHT_SAP gaan verwerken in de tabel DBA_WEIGHT_COMPONENT_PART 
procedure DBA_VERWERK_GEWICHT_MUTATIES (p_header_frame_id   varchar2 default 'ALLE' )
DETERMINISTIC
;
--
--LET OP: ALLEEN HANDMATIG STARTEN INDIEN VOLLEDIGE NIEUWE LOAD VAN STUURTABEL + DBA_WEIGHT_COMPONENT_PART NODIG IS !!!!
--        DE STUURTABEL MOET HANDMATIG WORDEN GETRUNCATED VOOR EEN SCHONE START...
procedure AANROEP_VUL_INIT_PART_GEWICHT (p_header_part_no        varchar2   default 'ALLE' 
                                        ,p_header_frame_id       varchar2   default 'ALLE' 
                                        ,p_aantal                number     default 999999999
                                        ,p_show_incl_items_jn    varchar2   default 'N' 
                                        ,p_insert_weight_comp_jn varchar2   default 'J'			)
DETERMINISTIC
;
     

END AAPIWEIGHT_CALC;
/
