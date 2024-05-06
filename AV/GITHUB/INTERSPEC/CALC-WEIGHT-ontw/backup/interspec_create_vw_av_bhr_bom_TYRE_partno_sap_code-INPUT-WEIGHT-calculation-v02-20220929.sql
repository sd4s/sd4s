--*******************************************************************************************************
--Creatie views: AV_BHR_BOM_TYRE_PART_NO
--
--*******************************************************************************************************
--view met alle CURRENT-TYRES incl. SAP-CODE
--Bij CURRENT-TYRE kunnen CURRENT/HISTORIC-BOM-ITEMS voorkomen waarvan ook gewicht moet worden berekend
--ongeacht of BOM-HEADER van COMPONENT-PART CURRENT/HISTORIC is. Zolang in BOM-ITEM dan berekenen.
--Tevens komen er TYRES voor waarbij de BOM_HEADER.revision achterloopt de SPECIFICATION_HEADER.revision.
--In dit geval moeten we ook het gewicht van de BOM-HEADER.revision BEREKENEN !!!. Deze kan dus in de 
--SPECIFICATION_HEADER al een historic-status gekregen hebben.
--
--Er komen ook TYRES voor die aan alle CONDITIES voldoen, MAAR, die GEEN BOM-ITEMS hebben !!!
--Deze sluiten we op dit NIVEAU nog niet uit !!! Komt er later wel uit bij de gewichtsberekening zelf...
--*******************************************************************************************************
--Wordt gebruikt vanuit de AANROEP-VUL-INIT-PART-GEWICHT procedure  !!
--Selectie-criteria:   FRAME_ID like 'A_PCR%' , 'A_TBR%' 
--                     PART_NO  like 'EF%' , 'GF%' , 'XGF%' (TRAIL-BANDEN ENSCHEDE NEMEN WE NIET MEE...)
--*******************************************************************************************************
--
--
create or replace view  av_bhr_bom_tyre_part_no
(PART_NO
,REVISION
,PLANT
,ALTERNATIVE
,BASE_QUANTITY
,FRAME_ID
,SORT_DESC
,SAP_CODE
)
as
select bh.part_no
,      bh.revision
,      bh.plant
,      bh.alternative
,      bh.base_quantity
,      sh.frame_id
,      s.sort_desc
,      (select  prop.char_1 AS sap_code
        from specification_prop prop
        WHERE  prop.part_no        = bh.part_no
		AND    prop.revision       = bh.revision
		and    prop.section_id     = 700755   -- SAP information 
        AND    prop.sub_section_id = 0        -- (none) 
        AND    prop.property_group = 704056   -- SAP articlecode 
        AND    prop.property       = 713824   -- Commercial article code 
        AND    prop.attribute      = 0        -- (none) 
	   )   sap_code
FROM  status               s
,     specification_header sh
,     bom_header           bh
where  (   sh.frame_id   LIKE ('A_PCR%')
       OR  SH.frame_id   LIKE ('A_TBR%')
       --vooralsnog zonder TRIAL/XE-banden Enschede, wel XG-hongarije !!
       )
and (   bh.part_no LIKE ('EF%')
    OR  bh.part_no LIKE ('GF%')
    OR  BH.PART_NO LIKE ('XGF%')
    )
and    bh.preferred  = 1
and    bh.part_no    = sh.part_no
and    bh.revision   = sh.revision
and    sh.status     = s.status
and    s.status_type in ('CURRENT' ,'HISTORIC')
and    EXISTS (--moet wel een current-part zijn waar ook bom-items-components onder hangen...
               --weten hier niet of component wel/niet current is. Zouden we nog extra check op kunnen zetten...		
               --vooralsnog gaan we er vanuit dat zolang component in BOM-ITEM voorkomt dat hij meegenomen moet worden...
               select boi2.part_no
               from  bom_item boi2 
               where boi2.part_no        = bh.part_no 
			   and   boi2.revision       = bh.revision
			   and   boi2.alternative    = bh.alternative
              )
and   bh.part_no  IN (--BH.revision mag current/historic zijn maar wel bij een TYRE die nog current is...
                      select sh2.part_no  
                      from status               s2
					  ,    specification_header sh2 
                      where  sh2.part_no  = bh.part_no 
                      and    sh2.status   = s2.status 
                      and    s2.status_type in ('CURRENT')
                     )
and   bh.revision   = (--BH.revision moet WEL GELIJK aan bh.max-revision zijn (nu we ook op historic selecteren...)
                       select max(h2.revision) 
                       from bom_header   h2 
                       where  h2.part_no     = bh.part_no
					   and    h2.alternative = bh.alternative
                      )
--order by sh.frame_id, bh.part_no, bh.revision
;


--controle-query:
select substr(part_no,1,2), frame_id, count(*) from av_bhr_bom_tyre_part_no group by  substr(part_no,1,2), frame_id order by  substr(part_no,1,2), frame_id;
select substr(part_no,1,2), sort_desc, count(*) from av_bhr_bom_tyre_part_no group by  substr(part_no,1,2), frame_id order by  substr(part_no,1,2), frame_id;


SHOW ERR



PROMPT ***************************************
PROMPT controle AANTALLEN per FRAME-ID
PROMPT ***************************************

select frame_id, count(*)
from av_bhr_bom_header_part_no
group by frame_id
order by frame_id
;
/*
A_ FM			4
A_Athena_report	13
A_Balecutter	1
A_Bead v1		14
A_Belt v1		256
A_CMPD_FM		4
A_CMPD_FM v1	902
A_CMPD_MB v1	186
A_Innerliner v1	41
A_OHT			2
A_PCR			7677       ---- A_PCR
A_PCR_GT v1		27
A_PCR_PG2		1
A_PCR_VULC v1	127
A_PCR_v1		22
A_PCR_v2		2
A_Ply m2		2
A_Ply v1		110
A_Rubberstrip	7
A_Run flat		5
A_SCW v1		271
A_Sidewall v1	60
A_Steelcomp		2
A_Steelcomp v1	13
A_TBR			170          ---- A_TBR
A_TBR_GT		29
A_TBR_VULC		2
A_TBR_v1		1
A_TextComp v1	17
A_XNP			1
A_tread pcs		24
A_tread v1		271
B_AT			355
E_AT			72
E_AT_BELT		12
E_AT_RRO		22
E_BBQ			19
E_BBQ_RM		1
E_Bead			38
E_Bead_AT		1
E_Bead_Bare_AT	1
E_Belt			197
E_Capply		12
E_Chafer		6
E_FM			903
E_Flipper		2
E_Innerliner	24
E_Innerliner AT	9
E_PA			435
E_PA_AT			7
E_PCR			14
E_PCR_GT_B		15
E_PCR_GT_C		7
E_PCR_VULC		366
E_PCR_source	1
E_PCT			12
E_Ply			128
E_Ply_AT		54
E_Rubberstrip	6
E_SCW			48
E_SF_BoxedWheels	105
E_SF_Wheelset	3
E_SM			38
E_Sidewall		66
E_Sidewall at	6
E_Steelcomp		1
E_TextComp		4
E_XNP			241
E_bought_compounds	7
E_tread			67
G_Steelcomp		1
G_TextComp		3
Global compound	331
L_ FM			1
L_Bead			1
L_PCT			1
L_PCT_GT		1
L_Steelcomp		1
L_TextComp		1
TE_Model tyre	2
T_TextComp_FEA	6
Trial B_AT		26
Trial E_ FM			22415
Trial E_AT			446
Trial E_AT_BELT		51
Trial E_AT_CARCASS	17
Trial E_AT_GT		26
Trial E_Bead		4
Trial E_Belt		118
Trial E_Capply		14
Trial E_Innerliner	20
Trial E_PCT			800
Trial E_Ply			177
Trial E_RF insert	5
Trial E_Rubberstr.	3
Trial E_SM			3
Trial E_Sidewall	11
Trial E_Steelcomp	52
Trial E_Stl chafer	8
Trial E_TextComp	243
Trial E_XNP			3020
Trial E_tread		69
Trial G_compound	84
Trial I_ FM_test	12
Trial L_Belt		3
Trial L_PCT			1
Trial_Athena_rep	2
*/


prompt
prompt controle substring/part-no
prompt

select substr(part_no,1,3), count(*)
from av_bhr_bom_header_part_no
group by substr(part_no,1,3)
order by substr(part_no,1,3)
;


PROMPT ***************************************
prompt CONTROLE op aantallen TYRES
PROMPT ***************************************

--controle op prod-omgeving (MET "CRRNT QR5"):
select count(part_no) from av_bhr_bom_header_part_no;
--63657
--controle op prod-omgeving (MET STATUS-TYPE="CURRENT"):
select count(part_no) from av_bhr_bom_header_part_no;
--40069
--controle op prod-omgeving (MET STATUS-TYPE="CURRENT" + NOT-EXISTS-controle dat bom-item nog bij current PART-NO voorkomt):
select count(part_no) from av_bhr_bom_header_part_no;
--45710
--controle op prod-omgeving (MET STATUS-TYPE="CURRENT" + NOT-EXISTS-controle dat bom-item nog bij current PART-NO voorkomt + EXISTS-controle op bom-items):
select count(part_no) from av_bhr_bom_header_part_no;
--41548

PROMPT ***************************************
PROMPT controle op aanwezigheid SAP-CODES
PROMPT ***************************************

select count(part_no) from av_bhr_bom_header_part_no where sap_code is not null;
--5987			(was in eerste instantie: 7696 )

prompt 
prompt einde script
prompt

