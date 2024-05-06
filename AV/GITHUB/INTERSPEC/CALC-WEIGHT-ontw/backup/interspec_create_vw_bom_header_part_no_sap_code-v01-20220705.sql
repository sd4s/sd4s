--*******************************************************************************************************
--view met alle CURRENT-TYRES incl. SAP-CODE
--Bij CURRENT-TYRE kunnen CURRENT/HISTORIC-BOM-ITEMS voorkomen waarvan ook gewicht moet worden berekend
--ongeacht of BOM-HEADER van COMPONENT-PART CURRENT/HISTORIC is. Zolang in BOM-ITEM dan berekenen.
--Wordt gebruikt vanuit de AANROEP-COMP-PART-GEWICHT procedure  !!
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
where  bh.part_no    NOT IN (--Een TYRE mag zelf niet als bom-item-component-part voorkomen
                             --Soms komt in historie een band nog wel als component voor, deze uitsluiten.
                             select boi2.component_part 
                             from status s
							 , specification_header sh
							 , bom_item boi2 
							 where boi2.component_part = bh.part_no 
							 and   boi2.part_no        = sh.part_no
							 and   boi2.revision       = sh.revision
							 and   sh.status           = s.status
							 and   s.status_type       = 'CURRENT'
							)
and    EXISTS (--moet wel een current-part zijn waar ook bom-items-components onder hangen...
               --weten hier niet of component wel/niet current is. Zouden we nog extra check op kunnen zetten...		
               select boi2.part_no
               from  bom_item boi2 
               where boi2.part_no        = bh.part_no 
			   and   boi2.revision       = bh.revision
			   and   boi2.revision   = (select max(sh1.revision) from status s1, specification_header sh1 where sh1.part_no = boi2.part_no and sh1.status = s1.status and s1.status_type in ('CURRENT','HISTORIC'))
              )
and    s.status_type = 'CURRENT' 
and    bh.preferred  = 1
and    bh.part_no    = sh.part_no
and    bh.revision   = sh.revision
and    sh.status     = s.status
--vooralsnog alleen voor A_PCR 
and    sh.frame_id   in ('A_PCR')
--vooralsnog zonder TRIAL/XE-banden Enschede, wel XG-hongarije !!
and substr(bh.part_no,1,2) in ('EF')   --('GF','XG')
and substr(bh.part_no,1,2) not in ('XE')
order by bh.part_no, bh.revision
;

SHOW ERR

--*******************************************************************************************************
--view met alle CURRENT-HEADERS incl. SAP-CODE
--Wordt gebruikt vanuit de AANROEP-BOM-HEADER procedure 
--Op dit moment weer gelijk aan de VW-BOM-TYRES-PART-NO, maar zou eigenlijk voor alle BOM-HEADERS gebruikt moeten kunnen worden...
create or replace view  av_bhr_bom_header_part_no
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
where  bh.part_no    NOT IN (--Een TYRE mag zelf niet als bom-item-component-part voorkomen
                             --Soms komt in historie een band nog wel als component voor, deze uitsluiten.
                             select boi2.component_part 
                             from status s
							 , specification_header sh
							 , bom_item boi2 
							 where boi2.component_part = bh.part_no 
							 and   boi2.part_no        = sh.part_no
							 and   boi2.revision       = sh.revision
							 and   sh.status           = s.status
							 and   s.status_type       = 'CURRENT'
							)
and    EXISTS (--moet wel een current-part zijn waar ook bom-items-components onder hangen...
               --weten hier niet of component wel/niet current is. Zouden we nog extra check op kunnen zetten...		
               select boi2.part_no
               from  bom_item boi2 
               where boi2.part_no        = bh.part_no 
			   and   boi2.revision       = bh.revision
              )
and    s.status_type = 'CURRENT' 
and    bh.preferred  = 1
and    bh.part_no    = sh.part_no
and    bh.revision   = sh.revision
and    sh.status     = s.status
--and    sh.frame_id   in ('A_PCR')
order by bh.part_no, bh.revision
;

SHOW ERR

--*******************************************************************************************************
--*******************************************************************************************************


--wat is sap-code bij een specificatie 
--(IN EERSTE INSTANTIE VOOR A_PCR-specs maar zou ook voor de overige specs moeten gelden...)
/*
SELECT part_no, revision, char_1 AS sap_code
FROM specification_prop
WHERE section_id = 700755    --SAP information 
AND sub_section_id = 0       --(none) 
AND property_group = 704056  --SAP articlecode 
AND property = 713824        --Commercial article code
AND attribute = 0            --(none) 
;
*/

/*
--bijv. voor spec-part-no: EF_Y245/35R20QPRX (prod)
--                         EF_W245/40R18WPRX (test-FOUTIEVE CURSOR)
--                         EF_710/40R22FLT162 (test)
select count(*)
FROM  bom_header bh
where  bh.part_no  NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = bh.part_no)
and    bh.revision = (select max(boi3.revision) from bom_item boi3 where boi3.part_no = bh.part_no)
order by bh.part_no, bh.revision
;
--45173

create or replace view  av_bhr_bom_header_part_no
as
select bh.part_no, bh.revision, bh.plant, bh.alternative, bh.base_quantity
FROM  bom_header bh
where  bh.part_no  NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = bh.part_no)
and    bh.revision = (select max(boi3.revision) from bom_item boi3 where boi3.part_no = bh.part_no)
order by bh.part_no, bh.revision
;
*/

--
--specification_header.frame_id   (EF = A_PCR )
--                    .status     (via fk naar status.sort_desc = 'CRRNT QR5'  = CURRENT/IN-PRODUCTION (=QR5)  ) 
--

/*
create or replace view  av_bhr_bom_header_part_no
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
where  bh.part_no    NOT IN (select boi2.component_part from bom_item boi2 where boi2.component_part = bh.part_no )
--and    bh.revision   = (select max(boi3.revision) from bom_item boi3 where boi3.part_no = bh.part_no)
and    s.status_type = 'CURRENT' 
--and    s.sort_desc IN ('CRRNT QR3','CRRNT QR4' ,'CRRNT QR5')
and    bh.preferred  = 1
and    bh.part_no    = sh.part_no
and    bh.revision   = sh.revision
and    sh.status     = s.status
--and    sh.frame_id   in ('A_PCR')
order by bh.part_no, bh.revision
;

*/













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


