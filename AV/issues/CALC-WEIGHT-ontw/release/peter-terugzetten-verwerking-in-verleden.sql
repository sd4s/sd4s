--*******************************************************************************************************************************************
--*******************************************************************************************************************************************
--we draaien deze mutaties terug, om opnieuw de dag-mutaties te gaan verwerken...
--*******************************************************************************************************************************************
--*******************************************************************************************************************************************
delete from dba_sync_besturing_weight_sap where sbw_datum_verwerkt_vanaf > to_date('01-02-2023 00:00:00','dd-mm-yyyy hh24:mi:ss');
commit;
--
select count(*) FROM DBA_WEIGHT_COMPONENT_PART where datum_verwerking > to_date('01-02-2023 00:00:00','dd-mm-yyyy hh24:mi:ss');
DELETE FROM DBA_WEIGHT_COMPONENT_PART where datum_verwerking > to_date('01-02-2023 00:00:00','dd-mm-yyyy hh24:mi:ss');
commit;





--
--bijwerken van gewichten in DBA_WEIGHT_COMPONENT_PART
select comp_part_eenheid_kg , round(comp_part_eenheid_kg,10) from dba_weight_component_part where id = 1661465;
select count(*) from from dba_weight_component_part where COMP_PART_EENHEID_KG <> round(comp_part_eenheid_kg,10);

update dba_weight_component_part set comp_part_eenheid_kg = round(comp_part_eenheid_kg,10) WHERE COMP_PART_EENHEID_KG <> round(comp_part_eenheid_kg,10);
--and id =1663479;







--einde script

