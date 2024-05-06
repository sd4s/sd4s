--Create VIEW alle CURRENT BOM-ITEMS incl STATUS + MAX(REVISION)
CREATE or REPLACE view DBA_VW_CRRNT_BOM_ITEMS
as
select bi.part_no
,      bi.revision
,      to_char(sh.issued_date,'dd-mm-yyyy hh24:mi:ss') partissueddate
,      to_char(sh.obsolescence_date,'dd-mm-yyyy hh24:mi:ss') partobsolescencedate
,      bi.plant
,      bi.alternative
,      bh.preferred
,      sh.status
,      s.sort_desc
,      s.status_type
,      p.description
,      sh.frame_id
,      bi.component_part
,      (select distinct bh1.revision 
        from status               s1
		,    specification_header sh1
		,    bom_header           bh1 
		where bh1.part_no    = bi.component_part 
		and   sh1.part_no    = bh1.part_no 
		and   sh1.revision   = bh1.revision 
		and   sh1.status     = s1.status 
		and   s1.status_type = 'CURRENT')  componentrevision
,      bi.quantity
,      bi.uom
,      bi.ch_1
,      c.description    functiecode 
from characteristic       c
,    part                 p
,    status               s
,    specification_header sh
,    bom_header           bh
,    bom_item             bi
where bi.part_no     = bh.part_no
and   bi.revision    = bh.revision
and   bi.alternative = bh.alternative
and   sh.part_no     = bh.part_no
and   sh.revision    = bh.revision
and   sh.status      = s.status
and   s.status_type  = 'CURRENT' 
and   bh.part_no     = p.part_no
and   bi.ch_1        = c.characteristic_id(+)
--and rownum < 5
order by bi.part_no
,        bi.revision
,        bi.component_part
; 

--Create VIEW ALL BOM-ITEMS-REVISIONS incl STATUS + MAX(REVISION)
CREATE or REPLACE view DBA_VW_ALL_BOM_ITEMS
as
select bi.part_no
,      bi.revision
,      to_char(sh.issued_date,'dd-mm-yyyy hh24:mi:ss') partissueddate
,      to_char(sh.obsolescence_date,'dd-mm-yyyy hh24:mi:ss') partobsolescencedate
,      bi.plant
,      bi.alternative
,      bh.preferred
,      sh.status
,      s.sort_desc
,      s.status_type
,      p.description
,      sh.frame_id
,      bi.component_part
,      (select MAX(bh1.revision)
        from status               s1
		,    specification_header sh1
		,    bom_header           bh1 
		where bh1.part_no    = bi.component_part 
		and   sh1.part_no    = bh1.part_no 
		and   sh1.revision   = bh1.revision 
		and   sh1.status     = s1.status )  maxcomponentrevision
,      (select distinct bh1.revision 
        from status               s1
		,    specification_header sh1
		,    bom_header           bh1 
		where bh1.part_no    = bi.component_part 
		and   sh1.part_no    = bh1.part_no 
		and   sh1.revision   = bh1.revision 
		and   sh1.status     = s1.status 
		and   s1.status_type = 'CURRENT')  currentcomponentrevision
,      bi.quantity
,      bi.uom
,      bi.ch_1
,      c.description    functiecode 
from characteristic       c
,    part                 p
,    status               s
,    specification_header sh
,    bom_header           bh
,    bom_item             bi
where bi.part_no     = bh.part_no
and   bi.revision    = bh.revision
and   bi.alternative = bh.alternative
and   sh.part_no     = bh.part_no
and   sh.revision    = bh.revision
and   sh.status      = s.status
--and   s.status_type  = 'CURRENT' 
and   bh.part_no     = p.part_no
and   bi.ch_1        = c.characteristic_id(+)
--and rownum < 5
order by bi.part_no
,        bi.revision
,        bi.component_part
; 



--Create VIEW voor ophalen van gewichten per tyre/component-part/material.
/*
--tabel  DBA_WEIGHT_COMPONENT_PART:
ID
TECH_CALCULATION_DATE
DATUM_VERWERKING
MAINPART
MAINREVISION
MAINPLANT
MAINALTERNATIVE
MAINFRAMEID
PART_NO
REVISION
PLANT
ALTERNATIVE
HEADER_ISSUEDDATE
HEADER_STATUS
COMPONENT_PART_NO
COMPONENT_DESCRIPTION
COMPONENT_REVISION
COMPONENT_ALTERNATIVE
COMPONENT_ISSUEDDATE
COMPONENT_STATUS
CHARACTERISTIC_ID
FUNCTIECODE
PATH
QUANTITY_PATH
BOM_QUANTITY_KG
COMP_PART_EENHEID_KG
REMARK
*/

--lET OP: Indien een component-part op lager niveau een nieuwe REVISION krijgt, wordt er voor
--        de gehele BAND/TYRE incl. alle onderliggende components, een nieuw gewicht berekend.
--        Deze gewichten komen met een NIEUWE TECH_CALCULATION_DATE in de tabel DBA_WEIGHT_COMPONENT_PART
--        te staan. Het REVISION-nummer van de band en/of onderliggende components (behalve degene die echt gewijzigd is) ook niet.
--        Een REVISION-nummer kan dus meerdere keren bij eenzelfde band voorkomen, alleen degene met hoogste REVISION/TECH_CALCULATION_DATE
--        is de JUISTE !!!!!
CREATE or REPLACE view DBA_VW_CRRNT_WEIGHT_COMP_TYRES
(PART_NO
,REVISION
,ALTERNATIVE
,MAINFRAMEID
,WEIGHT_UNIT_KG
,HEADER_ISSUEDDATE
,HEADER_STATUS_DESC
)
as
select dwc.part_no
,      dwc.revision
,      dwc.alternative
,      dwc.mainframeid
,      sum(dwc.bom_quantity_kg * nvl(dwcc.comp_part_eenheid_kg,0))  WEIGHTUNITKG
,      to_char(dwc.header_issueddate,'dd-mm-yyyy hh24:mi:ss')    HEADERISSUEDDATE
,      dwc.header_status                                         HEADERSTATUSDESC
from  dba_weight_component_part dwcc
,     dba_weight_component_part dwc
WHERE dwc.mainpart       = dwc.part_no                --neem start-regel voor de TYRE
and   dwc.component_part_no = dwcc.component_part_no  --leg join met component waarbij het gewicht berekend is (kan bij ander partno zijn)
and   nvl(dwcc.comp_part_eenheid_kg,0) > 0            --select component waarbij gewicht berekend is (kan zelfde/andere band zijn)
and   dwc.HEADER_STATUS in (select s.sort_desc from status s where status_type='CURRENT')   
AND   (   --select part-no alleen indien een CURRENT-TYRE met CURRENT-COMPONENTS
          nvl(dwc.COMP_PART_EENHEID_KG,0) > 0
      OR  (   nvl(dwc.COMP_PART_EENHEID_KG,0) = 0
          AND NOT exists (--geen component aanwezig met een gewicht 
                         select ''  
                         from dba_weight_component_part dwc2
      	                 where dwc2.mainpart = dwc.mainpart
         		         and   nvl(dwc.comp_part_eenheid_kg,0) > 0
                        )
          and   exists (--maar component wel bij een andere band een gewicht heeft dan is wel goede TYRE.
		                select ''
                        from dba_weight_component_part dwc2
                        where dwc2.component_part_no = dwc.component_part_no
                        and   nvl(dwc2.comp_part_eenheid_kg,0) > 0	
                       )
          )
      )
and   dwc.part_no NOT IN (--part-no mag niet als current-component nog eens bij andere band voorkomen.
                          select bi2.component_part 
                          from status               s2
						  ,    specification_header sh2
						  ,    bom_item             bi2 
						  where bi2.component_part = dwc.part_no
						  and   bi2.part_no = sh2.part_no
						  and   bi2.revision = sh2.revision
						  and   sh2.status   = s2.status
						  and   s2.status_type = 'CURRENT' 
						 )   --maakt niet uit voor welk alternative
and   dwc.HEADER_ISSUEDDATE is not null
AND   dwc.REVISION = (SELECT max(dwc2.revision) 
                      FROM dba_weight_component_part dwc2 
			  	  	  WHERE dwc2.part_no = dwc.part_no 
					  --and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0
				     )
AND   dwc.TECH_CALCULATION_DATE = (SELECT max(dwc2.tech_calculation_date)    
                      FROM dba_weight_component_part dwc2 
			  	  	  WHERE dwc2.part_no = dwc.part_no 
					  --and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0       --header altijd actuele selecteren
				     )
and   dwcc.tech_calculation_date = (SELECT max(dwcc2.tech_calculation_date) 
                      FROM dba_weight_component_part dwcc2 
			  	  	  WHERE dwcc2.component_part_no = dwc.component_part_no 
					  and NVL(dwcc2.COMP_PART_EENHEID_KG,0) > 0        --laatst geimporteerde component met hoeveelheid selecteren
				     )					 
group by dwc.part_no
,      dwc.revision
,      dwc.alternative
,      dwc.mainframeid
,      to_char(dwc.header_issueddate,'dd-mm-yyyy hh24:mi:ss')    
,      dwc.header_status
;



--****************************************************************************************************************************************************
--DIT IS LEIDENDE VIEW VOOR TYRE-WEIGHT:
--VANAF 03-07-2022 BEREKENEN WE OOK DE TYRE-WEIGHTS AL TIJDENS HET PROCES, EN SLAAN WE DEZE OOK
--OP IN DE HULPTABEL DBA_WEIGHT_COMPONENT_PART !!!. EXTRA SUM OP COMPONENTS IS DAARMEE OVERBODIG GEWORDEN.
--RESULTATEN UIT DEZE VIEW (DBA_VW_CRRNT_WEIGHT_TYRES) MOET ECHTER WEL ALTIJD HETZELFDE ZIJN ALS RESULTATEN UIT VIEW DBA_VW_CRRNT_WEIGHT_COMP_TYRES !!!
--****************************************************************************************************************************************************
CREATE or REPLACE view DBA_VW_CRRNT_WEIGHT_TYRES
(PART_NO
,REVISION
,ALTERNATIVE
,MAINFRAMEID
,WEIGHT_UNIT_KG
,HEADER_ISSUEDDATE
,HEADER_STATUS_DESC
)
as
select dwc.part_no
,      dwc.revision
,      dwc.alternative
,      dwc.mainframeid
,      nvl(dwc.comp_part_eenheid_kg,0)                           WEIGHTUNITKG
,      to_char(dwc.header_issueddate,'dd-mm-yyyy hh24:mi:ss')    HEADERISSUEDDATE
,      dwc.header_status                                         HEADERSTATUSDESC
from  dba_weight_component_part dwc
WHERE dwc.mainpart            = dwc.part_no                --neem start-regel voor de TYRE
and   dwc.remark              like 'MAINPART-HEADER-TYRE:%'
and   dwc.component_part_no   is null        
and   dwc.component_revision  is null
and   dwc.HEADER_STATUS in (select s.sort_desc from status s where status_type='CURRENT')   
and   dwc.HEADER_ISSUEDDATE is not null
AND   dwc.REVISION = (SELECT max(dwc2.revision) 
                      FROM dba_weight_component_part dwc2 
			  	  	  WHERE dwc2.part_no = dwc.part_no 
					  --and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0
				     )
AND   dwc.TECH_CALCULATION_DATE = (SELECT max(dwc2.tech_calculation_date)    
                      FROM dba_weight_component_part dwc2 
			  	  	  WHERE dwc2.part_no = dwc.part_no 
					  --and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0       --header altijd actuele selecteren
				     )
;


--view om alle COMPONENTS uit te vragen met een eenheid-gewicht !
--Hierbij is hulptabel DBA_WEIGHT_COMPONENT_PART leidend, qua vulling + status !
--Let op: In de hulptabel komen in tegenstelling tot BOM-ITEM/HEADER meerdere REVISIONS
--        voor met CRRNT-status. Komt omdat we vanuit de BATCH alleen nieuwe CRRNT-revisions
--        toevoegen aan de hulptabel, maar niet bestaande voorkomens HISTORIC maken !!!
--        Om CRRNT-revision te vinden zullen we moeten zoeken naar MAX-REVISION bij component-part
--        
--let op: Het kan dus al zijn dat in SPECIFICATION-HEADER een nieuwere REVISION bestaat
--        maar dat BATCH-job nog niet heeft gelopen om de hulptabel bij te werken...
--        Deze views laten de stand uit de hulptabellen zien !!
--
--Let op: In de hulptabel komt een COMPONENT-PART bij iedere band voor. Er zit echter per RUN maar 1 COMPONENT-PART
--        met (max-)REVISION van 1 BAND in waarbij het gewicht ook daadwerkelijk gevuld is !!!. Dit is uit performance-overwegingen.
--        Misschien later alsnog weer toevoegen in procedure DBA_BEPAAL_COMP_PART_GEWICHT !!!
-- 
--Let op: De MATERIALS zitten NIET als component_part in deze view!!!
--
--let op: NEEM GEEN "ID" OP IN DEZE VIEW. HET KOMT SOMS VOOR DAT ER COMPONENT VOOR 2 VERSCHILLENDE PARTS BINNEN 1 SEC WORDT TOEGEVOEGD.
--        IN DAT GEVAL LEVERT DEZE QUERY 2X RIJEN OP, DIE MET EEN DISTINCT ERUIT GEFILTERD WORDT. DUS ALLEEN OVEREENKOMENDE ATTRIBUTEN
--        IN QUERY OPNEMEN. EEN ID ERBIJ, ZORGT ERVOOR DAT QUERY 2 RIJEN OPLEVERT.
--LET OP: NEEM OOK GEEN "CHARACTERISTIC-ID"/"FUNCTIECODE" OP IN DEZE VIEW! ER ZIJN NAMELIJK EEN PAAR COMPONENTEN DIE MET VERSCHILLENDE
--        CHARACTERISTIC-ID'S VOORKOMEN ALS MAX(CALCULATION-DATE). OOK DIT ZORGT ER WEER VOOR DAT ER 2 VOORKOMENS VOOR 1X COMPONENT GETOOND WORDEN.
--        CONCLUSIE: HET LIJKT ER DUS OP DAT GEWICHT VAN COMPONENT-PART-NO DUS ALTIJD HETZELFDE IS, ONDANKS DE FUNCTIE-CODE EN WAARVOOR HIJ GEBRUIKT WORDT....
--
CREATE or REPLACE view DBA_VW_CRRNT_WEIGHT_COMP_PARTS
(TECH_CALCULATION_DATE
,COMPONENT_PART_NO
,COMPONENT_REVISION
,COMPONENT_ALTERNATIVE
,COMPONENT_WEIGHT_UNIT_KG
,COMPONENT_ISSUEDDATE
,COMPONENT_STATUS_DESC
--,CHARACTERISTIC_ID
--,FUNCTIECODE
)
as
select distinct to_char(dwc.tech_calculation_date,'dd-mm-yyyy hh24:mi:ss')   TECHCALCULATIONDATE
,      dwc.component_part_no
,      dwc.component_revision
,      dwc.alternative
,      dwc.COMP_PART_EENHEID_KG
,      to_char(dwc.component_issueddate,'dd-mm-yyyy hh24:mi:ss')    COMPONENTISSUEDDATE
,      dwc.component_status                                         COMPONENTSTATUSDESC
--,      dwc.CHARACTERISTIC_ID
--,      dwc.FUNCTIECODE
from dba_weight_component_part dwc
WHERE dwc.COMPONENT_STATUS in (select s.sort_desc from status s where status_type='CURRENT')    --('CRRNT QR1' ,'CRRNT QR2', 'CRRNT QR3', 'CRRNT QR4', 'CRRNT QR5')
AND   nvl(dwc.COMP_PART_EENHEID_KG,0) > 0
and   dwc.COMPONENT_ISSUEDDATE is not null
AND   dwc.COMPONENT_REVISION = (SELECT max(dwc2.component_revision) 
                                FROM dba_weight_component_part dwc2 
								WHERE dwc2.component_part_no = dwc.component_part_no 
								and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0
							   )
AND   dwc.TECH_CALCULATION_DATE = (SELECT max(dwc2.tech_calculation_date) 
                      FROM dba_weight_component_part dwc2 
			  	  	  WHERE dwc2.component_part_no = dwc.component_part_no
					  and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0
				     )
;
--3690x
--SELECT * FROM DBA_VW_CRRNT_WEIGHT_COMP_PARTS WHERE COMPONENT_PART_NO='ER_FE08-90-0500';





--op het moment dat er 1 COMPONENT-PART gewijzigd is, en er nieuwe VERSIE is gemaakt zullen we voor alle gerelateerde banden
--en bijbehorende componenten nieuwe GEWICHTEN aan moeten leveren...

--COMPONENT-PART in TABEL DBA_WEIGHT_COMPONENT_PART IS DE COMPONENT WAARVOOR WE MATERIALS WILLEN OPHALEN.
--In de tabel BOM_ITEM zit deze component-part daar als PART_NO in, om de relaties naar MATERIAL-COMPONENT-PARTS te vinden.
CREATE or REPLACE view DBA_VW_CRRNT_WEIGHT_MATERIALS
(ID
,COMPONENT_PART_NO
,COMPONENT_REVISION
,MATERIAL_COMPONENT_PART_NO
,MATERIAL_QUANTITY_KG
,MATERIAL_UOM
)
as
select dwc.ID
,      bi.part_no         comp_part
,      bi.revision        comp_revision
,      bi.component_part  comp_part_material
,      case when bi.uom = 'g' then (bi.quantity/1000) else bi.quantity end  quantity_kg
,      bi.uom
from  bom_item                   bi
,     dba_weight_component_part  dwc
where dwc.component_part_no     = bi.part_no 
and   dwc.component_revision    = bi.revision
and   dwc.COMPONENT_STATUS in (select s.sort_desc from status s where status_type='CURRENT')  --('CRRNT QR1' ,'CRRNT QR2', 'CRRNT QR3', 'CRRNT QR4', 'CRRNT QR5')
and   nvl(dwc.comp_part_eenheid_kg,0) > 0
and   dwc.component_issueddate is not null
and   bi.component_part NOT IN (select boi2.part_no from bom_item boi2 where boi2.part_no = bi.component_part)   --maakt niet uit voor welk alternative
AND   dwc.COMPONENT_REVISION = (SELECT max(dwc2.component_revision) 
                                FROM dba_weight_component_part dwc2 
								WHERE dwc2.component_part_no = dwc.component_part_no 
								and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0
								and   dwc2.COMPONENT_STATUS in (select s.sort_desc from status s where status_type='CURRENT')   --('CRRNT QR1' ,'CRRNT QR2', 'CRRNT QR3', 'CRRNT QR4', 'CRRNT QR5')
							   )
AND   dwc.TECH_CALCULATION_DATE = (SELECT max(dwc2.tech_calculation_date) 
                                   FROM dba_weight_component_part dwc2 
                                   WHERE dwc2.component_part_no = dwc.component_part_no
                                   and NVL(dwc2.COMP_PART_EENHEID_KG,0) > 0
								   and   dwc2.COMPONENT_STATUS in (select s.sort_desc from status s where status_type='CURRENT')  --('CRRNT QR1' ,'CRRNT QR2', 'CRRNT QR3', 'CRRNT QR4', 'CRRNT QR5')
                                  )
;


--part_no  like 'GR_NB01000012'		--part-type = 700302
--	part_no  like 'GR_NB01000150'      --part-type = 700302
--		part_no  like 'GC_NBJ140075'		--part-type = 700310
--			part_no  like '636751'				--part-type = 700478
--			part_no  like 'GM_B1004'			--part-type = 700306
/*
GM_B1004	21	GYO	1	110	160200				part_no  like '160200'		--part-type = 700876
GM_B1004	21	GYO	1	100	160774
GM_B1004	21	GYO	1	130	161871
GM_B1004	21	GYO	1	120	164111
GM_B1004	21	GYO	1	85	165421
GM_B1004	21	GYO	3	20	GD_B100401FB11		part_no  like 'GD_B100401FB11'				--part-type = 700314
GM_B1004	21	GYO	6	20	GD_B1004FB11
GM_B1004	21	GYO	5	20	GD_B1004FB11
GM_B1004	21	GYO	2	20	GD_B1004FB11
GM_B1004	21	GYO	4	20	GD_B1004FB11
GM_B1004	21	GYO	6	30	GM_B1004WA
GM_B1004	21	GYO	4	30	GM_B1004WA
GM_B1004	21	GYO	2	10	GM_MB11003
GM_B1004	21	GYO	1	10	GM_MB11003
GM_B1004	21	GYO	4	10	GM_MB11003
GM_B1004	21	GYO	3	10	GM_MB1100301
GM_B1004	21	GYO	6	40	GM_MB11003M2
GM_B1004	21	GYO	5	30	GM_MB11003M2
--conclusie:
--met part-type kunnen we niet zoveel om daarmee de grondstoffen eruit te halen...
--toch maar weer gewoon controle of component-part niet als part-no in BOM-ITEM voorkomt !!!
*/

/*
select * from bom_item where component_part='GR_5711' ;
--
AC_CP0028	2	LIM	1	10	GR_5711		LIM	1.1		kg   --crrnt
EC_KE20		6	ENS	1	10	GR_5711		ENS	0.896	kg
EC_KE20		7	ENS	1	10	GR_5711		ENS	0.896	kg
EC_KE20		8	ENS	1	10	GR_5711		ENS	0.896	kg
EC_KE20		9	ENS	1	10	GR_5711		ENS	0.896	kg
EC_KE20		10	ENS	1	10	GR_5711		ENS	0.896	kg
EC_KE20		11	ENS	1	10	GR_5711		ENS	0.896	kg   --hist
EC_KE21		6	ENS	1	10	GR_5711		ENS	1.064	kg
EC_KE21		7	ENS	1	10	GR_5711		ENS	1.064	kg
EC_KE21		8	ENS	1	10	GR_5711		ENS	1.064	kg
EC_KE21		9	ENS	1	10	GR_5711		ENS	1.064	kg
EC_KE21		10	ENS	1	10	GR_5711		ENS	1.064	kg
EC_KE21		11	ENS	1	10	GR_5711		ENS	1.064	kg
EC_KE21		12	ENS	1	10	GR_5711		ENS	1.064	kg
EC_KE21		13	ENS	1	10	GR_5711		ENS	1.064	kg
EC_KE21		14	ENS	1	10	GR_5711		ENS	1.064	kg
EC_KE21		15	ENS	1	10	GR_5711		ENS	1.064	kg
EC_KE21		16	ENS	1	10	GR_5711		ENS	1.064	kg     --CRRNT
EC_KE28		1	ENS	1	10	GR_5711		ENS	0.896	kg     --obs
--
--Ik had eigenlijk verwacht dat EENHEID van grondstof overal gelijk zou zijn. Dat lijkt nu niet het geval. 
--Hoe kan dit? Is status nog wel CRRNT bij laatste REVISION?
--even checken:
select * from specification_header sh where sh.part_no='AC_CP0028' and revision=(select max(h.revision) from bom_header h where h.part_no = sh.part_no)
--AC_CP0028	2	128	Apollo Limda steel cord calender sheet
select * from specification_header sh where sh.part_no='EC_KE20' and revision=(select max(h.revision) from bom_header h where h.part_no = sh.part_no)
--EC_KE20	11	5	STAALKOORD KE20 GEEL
select * from specification_header sh where sh.part_no='EC_KE21' and revision=(select max(h.revision) from bom_header h where h.part_no = sh.part_no)
--EC_KE21	16	128	STAALKOORD KE21 WIT
select * from specification_header sh where sh.part_no='EC_KE28' and revision=(select max(h.revision) from bom_header h where h.part_no = sh.part_no)
--
--conclusie: het lijkt inderdaad het geval te zijn!. In de BOM-ITEM-tabel komen dus nog PART-NO/REVISIONS voor die al HISTORIC zijn !!!.
--           Er moet dus altijd een controle opzitten als we deze tabel gaan raadplegen...
--
*/


