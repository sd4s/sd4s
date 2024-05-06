--AUTONOMOUS-procedure voor inserten van WEIGH-CALCULATION COMPONENT-PARTS:

create or replace procedure DBA_INSERT_WEIGHT_COMP_PART (p_tech_calculation_date date default null
                                                        ,p_datum_verwerking      date default null
                                                        ,p_mainpart              varchar2
                                                        ,p_mainrevision          number
                                                        ,p_mainplant             varchar2
                                                        ,p_mainalternative       number
                                                        ,p_mainframeid           varchar2
                                                        ,p_part_no               varchar2
														,p_revision              number
                                                        ,p_plant                 varchar2
                                                        ,p_alternative           number
														,p_header_issueddate     date
														,p_header_status         varchar2
														,p_component_part_no     varchar2
                                                        ,p_component_description varchar2
														,p_component_revision    number
														,p_component_alternative number
														,p_component_issueddate  date
														,p_component_status      varchar2
 								                        ,p_characteristic_id     number
														,p_functiecode           varchar2
								                        ,p_path                  varchar2
								                        ,p_quantity_path         varchar2
								                        ,p_bom_quantity_kg       number
														,p_comp_part_eenheid_kg  number
								                        ,p_remark                varchar2
														,p_lvl                   varchar2
														,p_lvl_tree              varchar2
														) 
is
pragma autonomous_transaction;
--procedure om bom-header-components incl. unit-kg op te slaan voor SAP-INTERAFACE !!
--ID wordt gevuld vanuit INSERT trigger dba_weight_component_part.DBA_WEIGHT_COMP_PART_BRI !!
--TECH_CALCULATION_DATE wordt gevuld vanuit aanroepende procedure DBA_BEPAAL_COMP_PART_GEWICHT
--zodat deze datum voor alle COMPONENT-PARTS van een BAND/TYRE hetzelfde is, maar indien deze leeg
--gelaten worden dan wordt deze alsnog gevuld door trigger dba_weight_component_part.DBA_WEIGHT_COMP_PART_BRI 
--
l_calc_date   date;
begin
  --
  insert into DBA_WEIGHT_COMPONENT_PART
  (tech_calculation_date
  ,datum_verwerking
  ,mainpart
  ,mainrevision
  ,mainplant
  ,mainalternative
  ,mainframeid
  ,part_no
  ,revision
  ,plant
  ,alternative
  ,header_issueddate
  ,header_status
  ,component_part_no
  ,component_description
  ,component_revision
  ,component_alternative
  ,component_issueddate
  ,component_status
  ,characteristic_id
  ,functiecode
  ,path
  ,quantity_path
  ,bom_quantity_kg
  ,comp_part_eenheid_kg
  ,remark    
  ,lvl
  ,lvl_tree  
  )
  values
  (p_tech_calculation_date
  ,p_datum_verwerking
  ,p_mainpart
  ,p_mainrevision
  ,p_mainplant
  ,p_mainalternative
  ,p_mainframeid
  ,p_part_no
  ,p_revision
  ,p_plant
  ,p_alternative
  ,p_header_issueddate
  ,p_header_status
  ,p_component_part_no
  ,p_component_description
  ,p_component_revision
  ,p_component_alternative
  ,p_component_issueddate
  ,p_component_status
  ,p_characteristic_id
  ,p_functiecode
  ,p_path
  ,p_quantity_path
  ,p_bom_quantity_kg
  ,p_comp_part_eenheid_kg         
  ,p_remark 
  ,p_lvl
  ,p_lvl_tree
  );
  --
  commit;
  --
exception
  when others
  then dbms_output.put_line('DBA-INSERT-WEIGHT-COMP_PART-ALG-EXCP-ERROR MAINPART: '||p_mainpart||' PART_NO: '||p_part_no||' COMP-PART: '||p_COMPONENT_PART_NO||' CHR: '||P_CHARACTERISTIC_ID||' : '||sqlerrm);
       null;
end;
/
show err


