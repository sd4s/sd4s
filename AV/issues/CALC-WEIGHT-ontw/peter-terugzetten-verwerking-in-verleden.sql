--*******************************************************************************************************************************************
--*******************************************************************************************************************************************
--we draaien deze mutaties terug, om opnieuw de dag-mutaties te gaan verwerken...
--*******************************************************************************************************************************************
--*******************************************************************************************************************************************
--select om inzicht te krijgen in specification_header.issued-date van een component 
select part_no, revision, status, description, issued_date, obsolescence_date, frame_id
from specification_header 
where part_no='GS_SWBC3104DL'
GS_SWBC3104DL	1	5	SW/RC/BC assembly 315/70 R22.5 Sizes(L) Bead imp	16-02-2023 12:20:52	02-03-2023 11:10:33	A_Sidewall v1
GS_SWBC3104DL	2	127	SW/RC/BC assembly 315/70 R22.5 Sizes(L) Bead imp	02-03-2023 11:10:33						A_Sidewall v1

--select om overzicht te krijgen vanaf welk tijdstip we terug willen draaien.
--Hierbij willen we terug naar situatie waarbij:	SBW_DATUM_VERWERKT_VANAF > TRUNC(SPECIFICATOIN_HEADER.ISSUED_DATE) !!!
--Zou eigenlijk standaard alleen bij een INCREMENTELE-VERWERKINGEN mogelijk MOETEN zijn. 
--
select id, sbw_datum_verwerkt_vanaf, sbw_datum_verwerkt_tm, sbw_tech_dat_laatste_wijz, sbw_aantal_tyres, sbw_sync_type, sbw_selected_frame_id
from dba_sync_besturing_weight_sap
where sbw_datum_verwerkt_vanaf > TRUNC(to_date('02-03-2023 11:10:33','dd-mm-yyyy hh24:mi:ss'))
order by id
;
/*
3707	02-03-2023 01:00:05	21-03-2023 15:05:21	21-03-2023 15:05:21	414	MUTATIE	A_PCR
3709	02-03-2023 01:01:46	21-03-2023 16:09:06	21-03-2023 16:09:06	12	MUTATIE	A_TBR
3710	02-03-2023 01:02:01	21-03-2023 16:12:25	21-03-2023 16:12:25	20	MUTATIE	E_AT
3711	02-03-2023 01:03:02	21-03-2023 16:16:30	21-03-2023 16:16:30	3	MUTATIE	E_BBQ
3712	02-03-2023 01:03:19	21-03-2023 16:16:47	21-03-2023 16:16:47	61	MUTATIE	E_PCR_VULC
3713	02-03-2023 01:03:36	21-03-2023 16:27:11	21-03-2023 16:27:11	1	MUTATIE	E_SF_BoxedWheels
3714	02-03-2023 01:03:53	21-03-2023 16:27:49	21-03-2023 16:27:49	1	MUTATIE	E_SF_Wheelset
3715	02-03-2023 01:04:10	21-03-2023 16:28:24	21-03-2023 16:28:24	0	MUTATIE	E_SM
*/

--**************************************
--VERWIJDEREN DBA_SYNC_BESTURING_WEIGHT_SAP
--**************************************
delete from dba_sync_besturing_weight_sap 
where sbw_datum_verwerkt_vanaf >  TRUNC(to_date('02-03-2023 11:10:33','dd-mm-yyyy hh24:mi:ss'))
;
commit;
--
--**************************************
--CONTROLE DBA_WEIGHT_COMPONENT_PART
--**************************************
/*
select count(*) FROM DBA_WEIGHT_COMPONENT_PART 
where datum_verwerking >=  TRUNC(to_date('02-03-2023 11:10:33','dd-mm-yyyy hh24:mi:ss'))
;
--3614
select count(*) FROM DBA_WEIGHT_COMPONENT_PART 
where datum_verwerking >=  TRUNC(to_date('02-03-2023 11:10:33','dd-mm-yyyy hh24:mi:ss'))
and component_part_no is null
;
--56
*/

--**************************************
--VERWIJDEREN DBA_WEIGHT_COMPONENT_PART:
--**************************************
DELETE FROM DBA_WEIGHT_COMPONENT_PART          
where datum_verwerking >=  TRUNC(to_date('02-03-2023 11:10:33','dd-mm-yyyy hh24:mi:ss'))
;
--33779 rows deleted

--**************************************
--VERWIJDEREN DBA_WEIGHT_RELATED_TYRE_LOG:
--**************************************
DELETE FROM DBA_WEIGHT_RELATED_TYRE_LOG          
where datum_verwerkt_vanaf >=  TRUNC(to_date('02-03-2023 11:10:33','dd-mm-yyyy hh24:mi:ss'))
;
--1822 rows deleted

--**************************************
--VERWIJDEREN DBA_WEIGHT_PART_NEW_REV_LOG:
--**************************************
DELETE FROM DBA_WEIGHT_PART_NEW_REV_LOG          
where datum_verwerkt_vanaf >=  TRUNC(to_date('02-03-2023 11:10:33','dd-mm-yyyy hh24:mi:ss'))
;
--1194 rows deleted



--INDIEN ALLES OK:
commit;




/*
--
--AD-HOC-ACTIE: bijwerken van gewichten in DBA_WEIGHT_COMPONENT_PART door deze af te ronden...
--De VERWERKINGS-MODULE is hierop aangepast. Was een eenmalig actie...
select comp_part_eenheid_kg , round(comp_part_eenheid_kg,10) from dba_weight_component_part where id = 1661465;
select count(*) from from dba_weight_component_part where COMP_PART_EENHEID_KG <> round(comp_part_eenheid_kg,10);
--
update dba_weight_component_part set comp_part_eenheid_kg = round(comp_part_eenheid_kg,10) WHERE COMP_PART_EENHEID_KG <> round(comp_part_eenheid_kg,10);
--and id =1663479;
*/



--einde script

