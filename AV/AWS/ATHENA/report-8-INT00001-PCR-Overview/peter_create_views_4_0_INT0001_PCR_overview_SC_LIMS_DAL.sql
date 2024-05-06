--*************************************************************************
--*************************************************************************
-- REPORT: INT00001 PCR-OVERVIEW   TOP FILTER  ON PLANTS RELATED TO A_PCR-FRAME-ID's
--*************************************************************************
--*************************************************************************

--IMPLEMENTATION PCR-VIEWS IN REDSHIFT-SC_LIMS_DAL

/*
CNB	CNB Camac
DEL	Deli tyre
PER	Perambra
YAZ	Yazd Plant
APR	Andhra Pradesh
CHE	Chennai
ENS	Enschede Plant
LAD	Ladysmith plant
MOS	Moscow plant
AUR	Aurangabad
BHI	Bhiwadi
CHI	Chitoor plant
GYO	Gyöngyöshalász
KIR	Kirov Plant
LIM	Limda
0	default plant
CHO	Chopanki
DEV	Development Plant
KAL	Kalamassery
PUN	Pune
VOR	Voronezh Plant
*/

-- A_PCR and A_PCR_v1
DROP VIEW sc_lims_dal.av_pcr_plants;
--
CREATE OR REPLACE VIEW sc_lims_dal.av_pcr_plants
(plant
,plant_description
)
as
select p.plant
,      p.description
from sc_interspec_ens.plant p
where exists (select pp.plant 
              from sc_interspec_ens.specification_header sh 
			  JOIN sc_interspec_ens.part_plant           pp on pp.part_no = sh.part_no and pp.plant = p.plant
			  where sh.frame_id like 'A_PCR%' 
			 )
;

grant all on  sc_lims_dal.av_pcr_plants   to usr_rna_readonly1;


--test-query
SELECT * FROM AV_PCR_PLANTS
;
/*
DEV	Development Plant
GYO	Gyöngyöshalász
LIM	Limda
YAZ	Yazd Plant
APR	Andhra Pradesh
CHE	Chennai
ENS	Enschede Plant
*/


--einde script