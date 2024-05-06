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
--revision-history  who    what
--dd 20-10-2022     PS     Extra FRAME-IDs toevoegd aan INPUT-VIEW voor WEIGHT-CALCULATION tbv SpaceMaster/Spoilers.
--*******************************************************************************************************
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
,SAP_DA_ARTICLE_CODE
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
,      (select  prop.char_1 AS sap_da_article_code
        from specification_prop prop
        WHERE  prop.part_no        = bh.part_no
		AND    prop.revision       = bh.revision
		and    prop.section_id     = 700755   -- SAP information 
        AND    prop.sub_section_id = 0        -- (none) 
        AND    prop.property_group = 704056   -- SAP articlecode 
        AND    prop.property       = 713825   -- Commercial article code 
        AND    prop.attribute      = 0        -- (none) 
	   )   sap_da_article_code
FROM  status               s
,     specification_header sh
,     bom_header           bh
where  (   ( sh.frame_id   LIKE ('A_PCR%')      --vooralsnog zonder TRIAL/XE-banden Enschede, wel XG-hongarije !!
           and (  bh.part_no LIKE ('EF%') OR  bh.part_no LIKE ('GF%') OR  BH.PART_NO LIKE ('XGF%') )
           )
       OR  ( sh.frame_id   LIKE ('A_TBR%')      --Truck-banden alleen Hongarije
           and (   bh.part_no LIKE ('GF%') OR  BH.PART_NO LIKE ('XGF%') )
           )
	   OR  ( sh.frame_id in ('E_PCR_VULC')      --C-alternative VulcTyre
	       AND bh.part_no like ('EV_C%')
	       )
	   OR  ( sh.frame_id in ('E_SM')            --SpaceMaster Tyre
	       AND bh.part_no like ('EF%')
	       )
	   OR  ( sh.frame_id in ('E_SF_Wheelset')   --SpaceMaster Wheelset (LET OP: IS GEEN FINISHED-PRODUCT !!)
	       and  (  bh.part_no like ('EF%') or bh.part_no like ('SW%') )
	       )
	   OR  ( sh.frame_id in ('E_SF_BoxedWheels')   --SpaceMaster WheelsetBox (Bevat aantal Wheelsets)
	       and  (  bh.part_no like ('EF%') or bh.part_no like ('SE%') )
	       )
	   OR  ( sh.frame_id in ('E_BBQ')           --Spoiler	
	       and bh.part_no like ('EQ%')
		   )
	   OR  ( sh.frame_id in ('E_AT')            --Produced Agriculture Tyre (no trial/XEF)
	       AND bh.part_no like ('EF%')
		   )
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
					   AND    h2.revision in (select sh2.revision
                                              from status               s2
                        					  ,    specification_header sh2 
                                              where  sh2.part_no  = h2.part_no 
                                              and    sh2.status   = s2.status 
                                              and    s2.status_type in ('CURRENT')
                                             )
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
from av_bhr_bom_TYRE_part_no
group by frame_id
order by frame_id
;
/*
A_PCR				4192
A_PCR_VULC v1		3
A_PCR_v1			5
A_TBR				213
E_AT				96
E_BBQ				36
E_PCR_VULC			267
E_SF_BoxedWheels	106
E_SF_Wheelset		107
E_SM				25
*/

PROMPT ***************************************
PROMPT controle op aanwezigheid SAP-CODES
PROMPT ***************************************

select frame_id, count(part_no) 
from av_bhr_bom_tyre_part_no 
where sap_code is not null
group by frame_id
order by frame_id
;
/*
A_PCR				3917   	-- dus 4192 - 3917 = 275 	zonder sap-code
A_PCR_VULC v1		0		-- dus    3 -    0 = 3 		zonder sap-code
A_PCR_v1			1	 	-- dus    5 -    1 = 4 		zonder sap-code
A_TBR				143		-- dus  213 -  143 = 70 	zonder sap-code
E_AT				96		-- allemaal met sap-code !!!!!!!!!
E_BBQ				19		-- dus   36 -   19 = 17 	zonder sap-code
E_SF_BoxedWheels	1		-- dus  106 -    1 = 105	zonder sap-code
E_SF_Wheelset		5		-- dus  107 -    5 = 102 	zonder sap-code
E_SM				25		-- allemaal met sap-code !!!!!!!!!
*/

PROMPT ***************************************
PROMPT controle op aanwezigheid SAP-DA-ARTICLE-CODES
PROMPT ***************************************

select frame_id, count(part_no) 
from av_bhr_bom_tyre_part_no 
where sap_da_article_code is not null
group by frame_id
order by frame_id
;
/*
A_PCR				3705	-- dus 4192 - 3705 = 487 	zonder sap-da-article-code
A_PCR_VULC v1		0
A_PCR_v1			1
A_TBR				1
E_AT				96		--allemaal met sap-da-article-code !!!!!
E_BBQ				0
E_SF_BoxedWheels	0
E_SF_Wheelset		0
E_SM				0
*/



--check op status van de tyres...
select frame_id, sort_desc, count(*)
from av_bhr_bom_TYRE_part_no
group by frame_id, sort_desc
order by frame_id, sort_desc
;
/*
A_PCR			CRRNT QR0	5
A_PCR			CRRNT QR1	108
A_PCR			CRRNT QR2	3139
A_PCR			CRRNT QR3	39
A_PCR			CRRNT QR4	191
A_PCR			CRRNT QR5	634
A_PCR			HISTORIC	28
A_PCR			TEMP CRRNT	48
A_PCR_VULC v1	CRRNT QR2	3
A_PCR_v1		CRRNT QR2	5
--
A_TBR			CRRNT QR1	2
A_TBR			CRRNT QR2	180
A_TBR			CRRNT QR4	31
--
E_AT			CRRNT QR2	12
E_AT			CRRNT QR3	11
E_AT			CRRNT QR4	33
E_AT			CRRNT QR5	40
--	
E_BBQ			CRRNT QR3	3
E_BBQ			CRRNT QR4	7
E_BBQ			CRRNT QR5	26
--
E_PCR_VULC		CRRNT QR3	23
E_PCR_VULC		CRRNT QR4	133
E_PCR_VULC		CRRNT QR5	111
--
E_SF_BoxedWheels	CRRNT QR3	3
E_SF_BoxedWheels	CRRNT QR4	100
E_SF_BoxedWheels	CRRNT QR5	1
E_SF_BoxedWheels	TEMP CRRNT	2
--
E_SF_Wheelset	CRRNT QR3	5
E_SF_Wheelset	CRRNT QR4	100
E_SF_Wheelset	TEMP CRRNT	2
--
E_SM			CRRNT QR3	2
E_SM			CRRNT QR4	3
E_SM			CRRNT QR5	20

--CONCLUSIE: Meeste TYRES staan wel op CURRENT, alleen bij PCR een aantal op HISTORIC/TEMP
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




prompt 
prompt einde script
prompt

